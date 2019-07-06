Panel_manageWorker:setMaskingChild(true)
Panel_manageWorker:setGlassBackground(true)
Panel_manageWorker:ActiveMouseEventEffect(true)
local UI_TYPE = CppEnums.PA_UI_CONTROL_TYPE
local UI_TM = CppEnums.TextMode
local UI_PP = CppEnums.PAUIMB_PRIORITY
local plantKey
local Control_WorkerList = {}
local Control_RestoreItem = {}
local Worker_Table = {}
local RestoreItem_Table = {}
local WorkerTooltip_Index, ItemTooltip_Index
local waitingCancelIdx = -1
local waitingCancelWorkerNo = {}
eWorkerStateType = {
  waiting = 0,
  working = 1,
  transfer = 2
}
local defaul_Control = {
  _Title = UI.getChildControl(Panel_manageWorker, "titlebar_manageWorker"),
  _List_BG = UI.getChildControl(Panel_manageWorker, "Static_WorkerList_BG"),
  _List_Scroll = UI.getChildControl(Panel_manageWorker, "WorkerList_ScrollBar"),
  _worker_BG = UI.getChildControl(Panel_manageWorker, "Static_workerBG"),
  _worker_CheckBox = UI.getChildControl(Panel_manageWorker, "button_workerList_checkBox"),
  _worker_Name = UI.getChildControl(Panel_manageWorker, "workerManage_workerName"),
  _worker_State = UI.getChildControl(Panel_manageWorker, "Button_workerState"),
  _worker_Move = UI.getChildControl(Panel_manageWorker, "Button_workerMove"),
  _worker_Redo = UI.getChildControl(Panel_manageWorker, "Button_React"),
  _worker_RestorePoint = UI.getChildControl(Panel_manageWorker, "Progress2_RestorePoint"),
  _worker_CurrentPoint = UI.getChildControl(Panel_manageWorker, "Progress2_CurrentPoint"),
  _List_Empty = UI.getChildControl(Panel_manageWorker, "StaticText_EmptySlot"),
  _buttonQuestion = UI.getChildControl(Panel_manageWorker, "Button_Question"),
  _closeButton = UI.getChildControl(Panel_manageWorker, "Button_Close"),
  _Item_BG = UI.getChildControl(Panel_manageWorker, "Static_Restore_Item_BG"),
  _Item_Slider = UI.getChildControl(Panel_manageWorker, "Slider_Restore_Item"),
  _Item_SliderBG = UI.getChildControl(Panel_manageWorker, "Static_Item_SliderBG"),
  _Btn_CloseItem = UI.getChildControl(Panel_manageWorker, "Button_Close_Item"),
  _Item_IconBG = UI.getChildControl(Panel_manageWorker, "Static_Restore_Item_Icone_BG"),
  _Item_Icone = UI.getChildControl(Panel_manageWorker, "Static_Restore_Item_Icone"),
  _Item_Count = UI.getChildControl(Panel_manageWorker, "StaticText_Item_Count"),
  _Item_RestoreValue = UI.getChildControl(Panel_manageWorker, "StaticText_Item_Restore_Value"),
  _Guide_Restore = UI.getChildControl(Panel_manageWorker, "StaticText_Guide_Restore"),
  _Slot_MaxCount = 5,
  _Slot_MinCount = 3,
  _Slot_GapY = 45,
  _Scroll_GapX = 7,
  _Item_MaxCount = 5,
  _Item_GapX = 49
}
local btnControl = {
  _Fire = UI.getChildControl(Panel_manageWorker, "button_doWorkerFire")
}
local scroll_Param = {
  _offsetIndex = 0,
  _offsetMax = 0,
  _slotMax = 0,
  _contentCount = 0
}
local slider_Param = {
  _offsetIndex = 0,
  _offsetMax = 0,
  _slotMax = 0,
  _contentCount = 0
}
local default_Size_Pos = {
  _Panel_SizeX = 0,
  _Panel_SizeY = 0,
  _Title_SizeX = 0,
  _List_BG_SpanX = 0,
  _List_BG_SpanY = 0,
  _List_BG_SizeY = 0,
  _Item_BG_SpanX = 0,
  _Item_BG_SpanY = 0
}
function default_Size_Pos:Init()
  self._Panel_SizeX = Panel_manageWorker:GetSizeX()
  self._Panel_SizeY = Panel_manageWorker:GetSizeY()
  self._Title_SizeX = defaul_Control._Title:GetSizeX()
  self._List_BG_SpanX = defaul_Control._List_BG:GetSpanSize().x
  self._List_BG_SpanY = defaul_Control._List_BG:GetSpanSize().y
  self._List_BG_SizeY = defaul_Control._List_BG:GetSizeY()
  self._Item_BG_SpanX = defaul_Control._Item_BG:GetSpanSize().x
  self._Item_BG_SpanY = defaul_Control._Item_BG:GetSpanSize().y
  defaul_Control._scroll_Button = UI.getChildControl(defaul_Control._List_Scroll, "Frame_ScrollBar_thumb")
  defaul_Control._List_Scroll:ComputePos()
end
default_Size_Pos:Init()
function defaul_Control:hide()
  self._worker_BG:SetShow(false)
  self._worker_CheckBox:SetShow(false)
  self._worker_Name:SetShow(false)
  self._worker_State:SetShow(false)
  self._worker_Move:SetShow(false)
  self._worker_Redo:SetShow(false)
  self._worker_RestorePoint:SetShow(false)
  self._worker_CurrentPoint:SetShow(false)
  self._List_Empty:SetShow(false)
  self._Item_BG:SetShow(false)
  self._Item_SliderBG:SetShow(false)
  self._Btn_CloseItem:SetShow(false)
  self._Item_IconBG:SetShow(false)
  self._Item_Icone:SetShow(false)
  self._Item_Count:SetShow(false)
  self._Item_RestoreValue:SetShow(false)
end
function WorldMapWindow_WaitWorkerFire()
  local _checked_Worker = {}
  for workerIndex, value in pairs(Worker_Table) do
    if true == value._isChecked then
      local index = #_checked_Worker + 1
      _checked_Worker[index] = value._WorkerNo
    end
  end
  for key, value in pairs(_checked_Worker) do
    local workerNo = value
    ToClient_requestDeleteMyWorker(workerNo)
  end
end
function HandleClick_WorkerCheckBox(workerIndex, idx)
  if Control_WorkerList._worker_CheckBox[idx]:IsCheck() and nil ~= Worker_Table[workerIndex] then
    Worker_Table[workerIndex]._isChecked = true
  elseif false == Control_WorkerList._worker_CheckBox[idx]:IsCheck() and nil ~= Worker_Table[workerIndex] then
    Worker_Table[workerIndex]._isChecked = false
  end
end
function Control_WorkerList:Init()
  defaul_Control._List_BG:addInputEvent("Mouse_UpScroll", "Control_Scroll(true, false)")
  defaul_Control._List_BG:addInputEvent("Mouse_DownScroll", "Control_Scroll(false, false)")
  defaul_Control._List_Scroll:addInputEvent("Mouse_UpScroll", "Control_Scroll(true, false)")
  defaul_Control._List_Scroll:addInputEvent("Mouse_DownScroll", "Control_Scroll(false, false)")
  defaul_Control._List_Scroll:addInputEvent("Mouse_LDown", "Control_ScrollOnClick(false)")
  defaul_Control._List_Scroll:addInputEvent("Mouse_LUp", "Control_ScrollOnClick(false)")
  defaul_Control._scroll_Button:addInputEvent("Mouse_LPress", "Control_ScrollOnClick(false)")
  defaul_Control._closeButton:addInputEvent("Mouse_LUp", "WorldMapWindow_CloseWaitWorkerManage()")
  defaul_Control._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"Worker\" )")
  defaul_Control._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"Worker\", \"true\")")
  defaul_Control._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"Worker\", \"false\")")
  btnControl._Fire:addInputEvent("Mouse_LUp", "WorldMapWindow_WaitWorkerFire()")
  self._worker_BG = {}
  self._worker_CheckBox = {}
  self._worker_Name = {}
  self._worker_State = {}
  self._worker_Move = {}
  self._worker_Redo = {}
  self._List_Empty = {}
  self._worker_RestorePoint = {}
  self._worker_CurrentPoint = {}
  for idx = 0, defaul_Control._Slot_MaxCount - 1 do
    self._worker_BG[idx] = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATIC, defaul_Control._List_BG, "Worker_BG_" .. tostring(idx))
    self._worker_RestorePoint[idx] = UI.createControl(UI_TYPE.PA_UI_CONTROL_PROGRESS2, defaul_Control._List_BG, "Worker_RestorePoint_" .. tostring(idx))
    self._worker_CurrentPoint[idx] = UI.createControl(UI_TYPE.PA_UI_CONTROL_PROGRESS2, defaul_Control._List_BG, "Worker_CurrentPoint_" .. tostring(idx))
    self._worker_CheckBox[idx] = UI.createControl(UI_TYPE.PA_UI_CONTROL_CHECKBUTTON, defaul_Control._List_BG, "Worker_CheckBox_" .. tostring(idx))
    self._worker_Name[idx] = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATICTEXT, defaul_Control._List_BG, "Worker_Name_" .. tostring(idx))
    self._worker_State[idx] = UI.createControl(UI_TYPE.PA_UI_CONTROL_BUTTON, defaul_Control._List_BG, "Worker_State_" .. tostring(idx))
    self._worker_Move[idx] = UI.createControl(UI_TYPE.PA_UI_CONTROL_BUTTON, defaul_Control._List_BG, "Worker_Move" .. tostring(idx))
    self._worker_Redo[idx] = UI.createControl(UI_TYPE.PA_UI_CONTROL_BUTTON, defaul_Control._List_BG, "Worker_ReDo_" .. tostring(idx))
    self._List_Empty[idx] = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATICTEXT, defaul_Control._List_BG, "Worker_Empty_" .. tostring(idx))
    CopyBaseProperty(defaul_Control._worker_BG, self._worker_BG[idx])
    CopyBaseProperty(defaul_Control._worker_CheckBox, self._worker_CheckBox[idx])
    CopyBaseProperty(defaul_Control._worker_Name, self._worker_Name[idx])
    CopyBaseProperty(defaul_Control._worker_State, self._worker_State[idx])
    CopyBaseProperty(defaul_Control._worker_Move, self._worker_Move[idx])
    CopyBaseProperty(defaul_Control._worker_Redo, self._worker_Redo[idx])
    CopyBaseProperty(defaul_Control._worker_RestorePoint, self._worker_RestorePoint[idx])
    CopyBaseProperty(defaul_Control._worker_CurrentPoint, self._worker_CurrentPoint[idx])
    CopyBaseProperty(defaul_Control._List_Empty, self._List_Empty[idx])
    self._worker_BG[idx]:SetSpanSize(self._worker_BG[idx]:GetSpanSize().x - default_Size_Pos._List_BG_SpanX, self._worker_BG[idx]:GetSpanSize().y - default_Size_Pos._List_BG_SpanY + defaul_Control._Slot_GapY * idx)
    self._worker_CheckBox[idx]:SetSpanSize(self._worker_CheckBox[idx]:GetSpanSize().x - default_Size_Pos._List_BG_SpanX, self._worker_CheckBox[idx]:GetSpanSize().y - default_Size_Pos._List_BG_SpanY + defaul_Control._Slot_GapY * idx)
    self._worker_Name[idx]:SetSpanSize(self._worker_Name[idx]:GetSpanSize().x - default_Size_Pos._List_BG_SpanX, self._worker_Name[idx]:GetSpanSize().y - default_Size_Pos._List_BG_SpanY + defaul_Control._Slot_GapY * idx)
    self._worker_State[idx]:SetSpanSize(self._worker_State[idx]:GetSpanSize().x - default_Size_Pos._List_BG_SpanX, self._worker_State[idx]:GetSpanSize().y - default_Size_Pos._List_BG_SpanY + defaul_Control._Slot_GapY * idx)
    self._worker_Move[idx]:SetSpanSize(self._worker_Move[idx]:GetSpanSize().x - default_Size_Pos._List_BG_SpanX, self._worker_Move[idx]:GetSpanSize().y - default_Size_Pos._List_BG_SpanY + defaul_Control._Slot_GapY * idx)
    self._worker_Redo[idx]:SetSpanSize(self._worker_Redo[idx]:GetSpanSize().x - default_Size_Pos._List_BG_SpanX, self._worker_Redo[idx]:GetSpanSize().y - default_Size_Pos._List_BG_SpanY + defaul_Control._Slot_GapY * idx)
    self._worker_RestorePoint[idx]:SetSpanSize(self._worker_RestorePoint[idx]:GetSpanSize().x - default_Size_Pos._List_BG_SpanX, self._worker_RestorePoint[idx]:GetSpanSize().y - default_Size_Pos._List_BG_SpanY + defaul_Control._Slot_GapY * idx + 5)
    self._worker_CurrentPoint[idx]:SetSpanSize(self._worker_CurrentPoint[idx]:GetSpanSize().x - default_Size_Pos._List_BG_SpanX, self._worker_CurrentPoint[idx]:GetSpanSize().y - default_Size_Pos._List_BG_SpanY + defaul_Control._Slot_GapY * idx + 5)
    self._List_Empty[idx]:SetSpanSize(self._List_Empty[idx]:GetSpanSize().x - default_Size_Pos._List_BG_SpanX, self._List_Empty[idx]:GetSpanSize().y - default_Size_Pos._List_BG_SpanY + defaul_Control._Slot_GapY * idx)
    self._worker_BG[idx]:addInputEvent("Mouse_UpScroll", "Control_Scroll(true, false)")
    self._worker_BG[idx]:addInputEvent("Mouse_DownScroll", "Control_Scroll(false, false)")
    self._worker_State[idx]:addInputEvent("Mouse_UpScroll", "Control_Scroll(true, false)")
    self._worker_State[idx]:addInputEvent("Mouse_DownScroll", "Control_Scroll(false, false)")
    self._worker_Move[idx]:addInputEvent("Mouse_UpScroll", "Control_Scroll(true, false)")
    self._worker_Move[idx]:addInputEvent("Mouse_DownScroll", "Control_Scroll(false, false)")
    self._worker_Redo[idx]:addInputEvent("Mouse_UpScroll", "Control_Scroll(true, false)")
    self._worker_Redo[idx]:addInputEvent("Mouse_DownScroll", "Control_Scroll(false, false)")
    self._List_Empty[idx]:addInputEvent("Mouse_UpScroll", "Control_Scroll(true, false)")
    self._List_Empty[idx]:addInputEvent("Mouse_DownScroll", "Control_Scroll(false, false)")
    self._List_Empty[idx]:addInputEvent("Mouse_Out", "HandleOut_WorkerTooltip(" .. idx .. ", false)")
  end
  defaul_Control._Guide_Restore:SetShow(false)
  defaul_Control._Guide_Restore:SetTextMode(UI_TM.eTextMode_AutoWrap)
  defaul_Control._Guide_Restore:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTOREGUIDE"))
end
Control_WorkerList:Init()
function Control_RestoreItem:Init()
  self._Item_BG = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATIC, defaul_Control._List_BG, "Item_SliderBG")
  CopyBaseProperty(defaul_Control._Item_BG, self._Item_BG)
  self._Item_BG:SetSpanSize(self._Item_BG:GetSpanSize().x - default_Size_Pos._List_BG_SpanX, self._Item_BG:GetSpanSize().y - default_Size_Pos._List_BG_SpanY)
  self._Item_BG:addInputEvent("Mouse_UpScroll", "Control_Scroll(true, true)")
  self._Item_BG:addInputEvent("Mouse_DownScroll", "Control_Scroll(false, true)")
  self._Item_BG:AddChild(defaul_Control._Item_Slider)
  Panel_manageWorker:RemoveControl(defaul_Control._Item_Slider)
  self._Item_Slider = defaul_Control._Item_Slider
  self._Btn_CloseItem = UI.createControl(UI_TYPE.PA_UI_CONTROL_BUTTON, self._Item_BG, "Btn_CloseItem")
  self._Item_SliderBG = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATIC, self._Item_BG, "Item_SliderBG")
  CopyBaseProperty(defaul_Control._Btn_CloseItem, self._Btn_CloseItem)
  CopyBaseProperty(defaul_Control._Item_SliderBG, self._Item_SliderBG)
  self._Item_Slider:SetSpanSize(self._Item_Slider:GetSpanSize().x - default_Size_Pos._Item_BG_SpanX, self._Item_Slider:GetSpanSize().y - default_Size_Pos._Item_BG_SpanY)
  self._Item_SliderBG:SetSpanSize(self._Item_SliderBG:GetSpanSize().x - default_Size_Pos._Item_BG_SpanX, self._Item_SliderBG:GetSpanSize().y - default_Size_Pos._Item_BG_SpanY)
  self._Btn_CloseItem:SetSpanSize(self._Btn_CloseItem:GetSpanSize().x - default_Size_Pos._Item_BG_SpanX, self._Btn_CloseItem:GetSpanSize().y - default_Size_Pos._Item_BG_SpanY)
  self._Btn_CloseItem:addInputEvent("Mouse_LUp", "Control_RestoreItem_Reset()")
  self._Item_Slider_Button = UI.getChildControl(self._Item_Slider, "Slider_Restore_Item_Button")
  self._Item_Slider:addInputEvent("Mouse_UpScroll", "Control_Scroll(true, true)")
  self._Item_Slider:addInputEvent("Mouse_DownScroll", "Control_Scroll(false, true)")
  self._Item_Slider_Button:addInputEvent("Mouse_UpScroll", "Control_Scroll(true, true)")
  self._Item_Slider_Button:addInputEvent("Mouse_DownScroll", "Control_Scroll(false, true)")
  self._Item_Slider:addInputEvent("Mouse_LDown", "Control_ScrollOnClick(true)")
  self._Item_Slider:addInputEvent("Mouse_LUp", "Control_ScrollOnClick(true)")
  self._Item_Slider_Button:addInputEvent("Mouse_LPress", "Control_ScrollOnClick(true)")
  self._Item_IconBG = {}
  self._Item_Icone = {}
  self._Item_Count = {}
  self._Item_RestoreValue = {}
  for idx = 0, defaul_Control._Item_MaxCount - 1 do
    self._Item_IconBG[idx] = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATIC, self._Item_BG, "Item_Icon_BG_" .. tostring(idx))
    self._Item_Icone[idx] = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATIC, self._Item_BG, "Item_Icon_" .. tostring(idx))
    self._Item_Count[idx] = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATICTEXT, self._Item_BG, "Item_Count_" .. tostring(idx))
    self._Item_RestoreValue[idx] = UI.createControl(UI_TYPE.PA_UI_CONTROL_STATICTEXT, self._Item_BG, "Item_RestoreValue_" .. tostring(idx))
    CopyBaseProperty(defaul_Control._Item_IconBG, self._Item_IconBG[idx])
    CopyBaseProperty(defaul_Control._Item_Icone, self._Item_Icone[idx])
    CopyBaseProperty(defaul_Control._Item_Count, self._Item_Count[idx])
    CopyBaseProperty(defaul_Control._Item_RestoreValue, self._Item_RestoreValue[idx])
    self._Item_IconBG[idx]:SetSpanSize(self._Item_IconBG[idx]:GetSpanSize().x - default_Size_Pos._Item_BG_SpanX + defaul_Control._Item_GapX * idx, self._Item_IconBG[idx]:GetSpanSize().y - default_Size_Pos._Item_BG_SpanY)
    self._Item_Icone[idx]:SetSpanSize(self._Item_Icone[idx]:GetSpanSize().x - default_Size_Pos._Item_BG_SpanX + defaul_Control._Item_GapX * idx, self._Item_Icone[idx]:GetSpanSize().y - default_Size_Pos._Item_BG_SpanY)
    self._Item_Count[idx]:SetSpanSize(self._Item_Count[idx]:GetSpanSize().x - default_Size_Pos._Item_BG_SpanX + defaul_Control._Item_GapX * idx, self._Item_Count[idx]:GetSpanSize().y - default_Size_Pos._Item_BG_SpanY)
    self._Item_RestoreValue[idx]:SetSpanSize(self._Item_RestoreValue[idx]:GetSpanSize().x - default_Size_Pos._Item_BG_SpanX + defaul_Control._Item_GapX * idx, self._Item_RestoreValue[idx]:GetSpanSize().y - default_Size_Pos._Item_BG_SpanY)
    self._Item_Icone[idx]:addInputEvent("Mouse_RUp", "HandleClick_RestoreItem(" .. idx .. ")")
    self._Item_Icone[idx]:addInputEvent("Mouse_On", "HandleOn_RestoreItemTooltip(" .. idx .. ")")
    self._Item_Icone[idx]:addInputEvent("Mouse_Out", "HandleOut_RestoreItemTooltip(" .. idx .. ")")
    self._Item_Icone[idx]:addInputEvent("Mouse_UpScroll", "Control_Scroll(true, true)")
    self._Item_Icone[idx]:addInputEvent("Mouse_DownScroll", "Control_Scroll(false, true)")
  end
  self._saveIndex = nil
  self._Item_BG:SetShow(false)
end
Control_RestoreItem:Init()
defaul_Control:hide()
function Control_WorkerList:SetControl(waitWorkerCount, maxWorkerCount)
  defaul_Control._Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_MANAGE") .. " (" .. waitWorkerCount .. "/" .. maxWorkerCount .. ")")
  scroll_Param._contentCount = maxWorkerCount
  scroll_Param._offsetMax = maxWorkerCount - defaul_Control._Slot_MaxCount
  if scroll_Param._offsetMax < 0 then
    scroll_Param._offsetMax = 0
    scroll_Param._slotMax = maxWorkerCount
  else
    scroll_Param._slotMax = defaul_Control._Slot_MaxCount
  end
  local list_SizeY_Add = 0
  local panel_SizeX_Add = 0
  if maxWorkerCount > defaul_Control._Slot_MaxCount then
    list_SizeY_Add = defaul_Control._Slot_GapY * (defaul_Control._Slot_MaxCount - defaul_Control._Slot_MinCount) + 15
    panel_SizeX_Add = defaul_Control._Scroll_GapX
  elseif maxWorkerCount == defaul_Control._Slot_MaxCount then
    list_SizeY_Add = defaul_Control._Slot_GapY * (defaul_Control._Slot_MaxCount - defaul_Control._Slot_MinCount) + 15
  elseif maxWorkerCount < defaul_Control._Slot_MaxCount and maxWorkerCount > defaul_Control._Slot_MinCount then
    list_SizeY_Add = defaul_Control._Slot_GapY * (maxWorkerCount - defaul_Control._Slot_MinCount) + 15
  end
  Panel_manageWorker:SetSize(default_Size_Pos._Panel_SizeX + panel_SizeX_Add, default_Size_Pos._Panel_SizeY + list_SizeY_Add)
  defaul_Control._List_BG:SetSize(defaul_Control._List_BG:GetSizeX(), default_Size_Pos._List_BG_SizeY + list_SizeY_Add)
  defaul_Control._Title:SetSize(default_Size_Pos._Title_SizeX + panel_SizeX_Add, defaul_Control._Title:GetSizeY())
  defaul_Control._List_Scroll:SetSize(defaul_Control._List_Scroll:GetSizeX(), defaul_Control._List_BG:GetSizeY())
  btnControl._Fire:ComputePos()
  defaul_Control._buttonQuestion:ComputePos()
  defaul_Control._closeButton:ComputePos()
  Panel_manageWorker:ComputePos()
end
function Control_RestoreItem_Reset()
  Control_RestoreItem._Item_BG:SetShow(false)
  Control_RestoreItem._Item_Slider:SetShow(false)
  defaul_Control._Guide_Restore:SetShow(false)
  btnControl._Fire:SetShow(true)
  if scroll_Param._contentCount < scroll_Param._offsetIndex + scroll_Param._slotMax then
    scroll_Param._offsetIndex = scroll_Param._contentCount - scroll_Param._slotMax
  end
  Control_WorkerList:UpdateSlot(0, false)
  Control_RestoreItem._saveIndex = nil
end
function Control_RestoreItem:InsertControl(idx, isRefresh)
  if slider_Param._contentCount == 0 then
    Worker_Table[idx]._State_Text = "<PAColor0xffc4bebe>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_WAIT") .. "<PAOldColor>"
    Control_WorkerList._worker_State[idx]:SetText("<PAColor0xfffeff99>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE") .. "<PAOldColor>")
    if self._Item_BG:GetShow() then
      Control_RestoreItem_Reset()
    else
      if false == isRefresh then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_NOITEM"))
      end
      HandleOut_RestoreItemTooltip(nil)
    end
    self._saveIndex = nil
    return
  end
  self._saveIndex = idx
  if idx + 2 > scroll_Param._slotMax - 1 then
    local newPosition = math.max(defaul_Control._Slot_MinCount, scroll_Param._slotMax) - 3
    local adjust = idx - newPosition
    if false == isRefresh then
      scroll_Param._offsetIndex = scroll_Param._offsetIndex + adjust
    end
    idx = newPosition
    Control_WorkerList:UpdateSlot(idx + 1, true)
  elseif idx + 2 < scroll_Param._slotMax - 1 then
    Control_WorkerList:UpdateSlot(idx + 1, true)
  else
    Control_WorkerList:clear(idx + 1)
  end
  Control_WorkerList._worker_State[idx]:SetText("<PAColor0xfffeff99>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE") .. "<PAOldColor>")
  Control_RestoreItem.Index = idx
  self._Item_BG:SetSpanSize(self._Item_BG:GetSpanSize().x, Control_WorkerList._worker_BG[idx + 1]:GetSpanSize().y + 5)
  self._Item_BG:SetShow(true)
  defaul_Control._Guide_Restore:SetShow(true)
  btnControl._Fire:SetShow(false)
  defaul_Control._Guide_Restore:ComputePos()
  self:UpdateItemList()
end
function Worker_Table_Set()
  Worker_Table = {}
  local plant = ToClient_getPlant(plantKey)
  if nil == plant or CppEnums.PlantType.ePlantType_Town ~= plant:getType() then
    return
  end
  local waitWorkerCount = ToClient_getPlantWaitWorkerListCount(plantKey, 0)
  local maxWorkerCount = ToClient_getTownWorkerMaxCapacity(plantKey)
  for workerIndex = 0, maxWorkerCount - 1 do
    Worker_Table[workerIndex] = {}
    if workerIndex < waitWorkerCount then
      Worker_Table[workerIndex]._isEmpty = false
      local workerData = ToClient_getPlantWaitWorkerByIndex(plantKey, workerIndex)
      local workerStaticStatus = workerData:getWorkerStaticStatus()
      local checkData = workerData:getStaticSkillCheckData()
      local workerGrade = workerData:getWorkerStaticStatus():getCharacterStaticStatus()._gradeType:get()
      checkData._diceCheckForceSuccess = true
      Worker_Table[workerIndex]._WorkerNo = workerData:getWorkerNo()
      Worker_Table[workerIndex]._Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. workerData:getLevel() .. " " .. ConvertFromGradeToColor(workerGrade, true) .. ToClient_getWorkerName(workerStaticStatus) .. "<PAOldColor>"
      Worker_Table[workerIndex]._MaxPoint = workerStaticStatus._actionPoint
      Worker_Table[workerIndex]._CurrentPoint = workerData:getActionPoint()
      Worker_Table[workerIndex]._recoveryActionPoint = workerData:getRecoveryActionPointWithSkill(checkData)
      Worker_Table[workerIndex]._Grade = workerGrade
      if isWaitWorker(workerData) == true then
        Worker_Table[workerIndex]._State_Text = "<PAColor0xfffeff99>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE") .. "<PAOldColor>"
        Worker_Table[workerIndex]._State = eWorkerStateType.waiting
      elseif workerData == true then
        Worker_Table[workerIndex]._State_Text = "<PAColor0xffff8400>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_TRANSFERING") .. "<PAOldColor>"
        Worker_Table[workerIndex]._State = eWorkerStateType.transfer
      else
        Worker_Table[workerIndex]._State_Text = "<PAColor0xffde3900>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_CANCELWORK") .. "<PAOldColor>"
        Worker_Table[workerIndex]._State = eWorkerStateType.working
      end
    else
      Worker_Table[workerIndex]._isEmpty = true
    end
  end
  Control_WorkerList:SetControl(waitWorkerCount, maxWorkerCount)
  Control_WorkerList:UpdateSlot(0, false)
end
function RestoreItem_Table_Set()
  local Cnt_RestoreItem = ToClient_getNpcRecoveryItemList()
  for idx = 0, Cnt_RestoreItem - 1 do
    RestoreItem_Table[idx] = {}
    local NpcRecoveryItem = ToClient_getNpcRecoveryItemByIndex(idx)
    RestoreItem_Table[idx]._slotNo = NpcRecoveryItem._slotNo
    RestoreItem_Table[idx]._itemKey = NpcRecoveryItem._itemEnchantKey
    RestoreItem_Table[idx]._itemCnt = NpcRecoveryItem._itemCount_s64
    RestoreItem_Table[idx]._restore = NpcRecoveryItem._contentsEventParam1
    local itemStatic = NpcRecoveryItem:getItemStaticStatus()
    RestoreItem_Table[idx]._itemIcon = "icon/" .. getItemIconPath(itemStatic)
  end
  slider_Param._offsetIndex = 0
  slider_Param._contentCount = Cnt_RestoreItem
  slider_Param._offsetMax = Cnt_RestoreItem - defaul_Control._Item_MaxCount
  if 0 > slider_Param._offsetMax then
    slider_Param._offsetMax = 0
    slider_Param._slotMax = Cnt_RestoreItem
  else
    slider_Param._slotMax = defaul_Control._Item_MaxCount
  end
end
function Control_RestoreItem:clear()
  for key, value in pairs(Control_RestoreItem._Item_IconBG) do
    value:SetShow(false)
  end
  for key, value in pairs(Control_RestoreItem._Item_Icone) do
    value:SetShow(false)
  end
  for key, value in pairs(Control_RestoreItem._Item_Count) do
    value:SetShow(false)
  end
  for key, value in pairs(Control_RestoreItem._Item_RestoreValue) do
    value:SetShow(false)
  end
end
function UISlider_SetButtonSize(scroll, configSlotCount, contentsCount)
  if configSlotCount < contentsCount then
    local size = configSlotCount / contentsCount
    scroll:GetControlButton():SetSize(scroll:GetSizeX() * size, scroll:GetControlButton():GetSizeY())
    scroll:SetShow(true)
  else
    scroll:SetShow(false)
  end
end
function Control_RestoreItem:UpdateItemList()
  self:clear()
  for idx = 0, slider_Param._slotMax - 1 do
    local itemIndex = slider_Param._offsetIndex + idx
    self._Item_Icone[idx]:ChangeTextureInfoName(RestoreItem_Table[itemIndex]._itemIcon)
    self._Item_Count[idx]:SetText(tostring(RestoreItem_Table[itemIndex]._itemCnt))
    self._Item_RestoreValue[idx]:SetText("+" .. tostring(RestoreItem_Table[itemIndex]._restore))
    self._Item_IconBG[idx]:SetShow(true)
    self._Item_Icone[idx]:SetShow(true)
    self._Item_Count[idx]:SetShow(true)
    self._Item_RestoreValue[idx]:SetShow(true)
  end
  UISlider_SetButtonSize(self._Item_Slider, defaul_Control._Item_MaxCount, slider_Param._contentCount)
  if self._Item_Slider:GetShow() then
    self._Item_SliderBG:SetShow(false)
  else
    self._Item_SliderBG:SetShow(true)
  end
  local _offsetMax = slider_Param._offsetMax
  if _offsetMax == 0 then
    _offsetMax = 1
  end
  self._Item_Slider:SetControlPos(slider_Param._offsetIndex / _offsetMax * 100)
end
function Control_WorkerList:clear(idx)
  for key, value in pairs(self._worker_BG) do
    if idx <= key then
      value:SetShow(false)
    end
  end
  for key, value in pairs(self._worker_CheckBox) do
    if idx <= key then
      value:SetShow(false)
      value:SetCheck(false)
    end
  end
  for key, value in pairs(self._worker_Name) do
    if idx <= key then
      value:SetShow(false)
    end
  end
  for key, value in pairs(self._worker_State) do
    if idx <= key then
      value:SetShow(false)
    end
  end
  for key, value in pairs(self._worker_Redo) do
    if idx <= key then
      value:SetShow(false)
    end
  end
  for key, value in pairs(self._worker_Move) do
    if idx <= key then
      value:SetShow(false)
    end
  end
  for key, value in pairs(self._List_Empty) do
    if idx <= key then
      value:SetShow(false)
    end
  end
  for key, value in pairs(self._worker_RestorePoint) do
    if idx <= key then
      value:SetShow(false)
    end
  end
  for key, value in pairs(self._worker_CurrentPoint) do
    if idx <= key then
      value:SetShow(false)
    end
  end
end
function Control_WorkerList:UpdateSlot(_Index, isAdjust)
  local adjust = 0
  if isAdjust then
    adjust = 2
  end
  self:clear(0)
  local _blank_Count = 0
  local workerIndex = scroll_Param._offsetIndex
  for idx = 0, scroll_Param._slotMax - 1 do
    if nil ~= Worker_Table[workerIndex] and (true ~= isAdjust or idx < _Index or idx >= _Index + adjust) then
      if false == Worker_Table[workerIndex]._isEmpty then
        local progressRate = Worker_Table[workerIndex]._CurrentPoint / Worker_Table[workerIndex]._MaxPoint * 100
        self._worker_BG[idx]:SetShow(true)
        self._worker_CheckBox[idx]:SetShow(true)
        self._worker_Name[idx]:SetShow(true)
        self._worker_RestorePoint[idx]:SetProgressRate(progressRate)
        self._worker_RestorePoint[idx]:SetShow(true)
        self._worker_CurrentPoint[idx]:SetProgressRate(progressRate)
        self._worker_CurrentPoint[idx]:SetShow(true)
        self._worker_State[idx]:SetShow(true)
        local workStringNo = tostring(Worker_Table[workerIndex]._WorkerNo:get_s64())
        local workerName = Worker_Table[workerIndex]._Name
        if Worker_Table[workerIndex]._State == eWorkerStateType.working then
          workerName = "[\236\158\145\236\151\133\236\164\145] " .. workerName
        else
          workerName = "[\235\140\128\234\184\176\236\164\145] " .. workerName
        end
        self._worker_Name[idx]:SetText(workerName)
        self._worker_State[idx]:addInputEvent("Mouse_On", "HandleOn_WorkerTooltip(" .. idx .. ")")
        self._worker_State[idx]:addInputEvent("Mouse_Out", "HandleOut_WorkerTooltip(" .. idx .. ", false)")
        self._worker_BG[idx]:addInputEvent("Mouse_On", "HandleOn_WorkerTooltip(" .. idx .. ")")
        self._worker_BG[idx]:addInputEvent("Mouse_Out", "HandleOut_WorkerTooltip(" .. idx .. ", false)")
        if true == waitingCancelWorkerNo[workStringNo] then
          if Worker_Table[workerIndex]._State == eWorkerStateType.working then
            self._worker_State[idx]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_TOWN_WORKERMANAGE_CANCELRESERVE"))
            self._worker_State[idx]:SetEnable(false)
            self._worker_State[idx]:SetMonoTone(true)
            self._worker_Move[idx]:SetShow(true)
            self._worker_Move[idx]:addInputEvent("Mouse_LUp", "HandleLClick_WorkerMove_Button(" .. workerIndex .. ", " .. idx .. ")")
          else
            waitingCancelWorkerNo[workStringNo] = nil
            self._worker_State[idx]:SetText("<PAColor0xfffeff99>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE") .. "<PAOldColor>")
            self._worker_State[idx]:SetEnable(true)
            self._worker_State[idx]:SetMonoTone(false)
            self._worker_Move[idx]:SetShow(false)
          end
        else
          if Worker_Table[workerIndex]._State == eWorkerStateType.working then
            self._worker_State[idx]:SetText("<PAColor0xffde3900>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_CANCELWORK") .. "<PAOldColor>")
          else
            self._worker_State[idx]:SetText("<PAColor0xfffeff99>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE") .. "<PAOldColor>")
          end
          self._worker_State[idx]:SetEnable(true)
          self._worker_State[idx]:SetMonoTone(false)
          local workingWorker = ToClient_getPlantWorkingWorkerByWorkerNo(Worker_Table[workerIndex]._WorkerNo)
          if nil ~= workingWorker and 0 == workingWorker._type or Worker_Table[workerIndex]._State == eWorkerStateType.working then
            self._worker_Move[idx]:SetShow(true)
            self._worker_Move[idx]:addInputEvent("Mouse_LUp", "HandleLClick_WorkerMove_Button(" .. workerIndex .. ", " .. idx .. ")")
          end
        end
        self._worker_State[idx]:addInputEvent("Mouse_LUp", "HandleLClick_WorkerState_Button(" .. workerIndex .. ", " .. idx .. ")")
        self._worker_CheckBox[idx]:addInputEvent("Mouse_LUp", "HandleClick_WorkerCheckBox(" .. workerIndex .. ", " .. idx .. ")")
        if Worker_Table[workerIndex]._State == eWorkerStateType.waiting then
          local workerData = ToClient_getPlantWaitWorkerByIndex(plantKey, workerIndex)
          local _homeWaypoint = plantKey:getWaypointKey()
          if nil ~= workerData then
            local workerNo = workerData:getWorkerNo():get_s64()
            for key, value in pairs(workedWorker) do
              if workerNo == key then
                self._worker_Redo[idx]:SetShow(true)
                self._worker_Redo[idx]:addInputEvent("Mouse_LUp", "HandleClick_ReDoWork(" .. workerIndex .. ")")
                break
              end
            end
          end
        end
        local _workerData = ToClient_getPlantWaitWorkerByIndex(plantKey, workerIndex)
        if nil ~= _workerData then
          local _workerNo = _workerData:getWorkerNo():get_s64()
          local _leftWorkCount = ToClient_getNpcWorkerWorkingCount(_workerNo)
          if _leftWorkCount > 0 then
            self._worker_Name[idx]:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAP_TOWN_WORKERMANAGE_LEFTWORKCOUNT", "workerName", workerName, "_leftWorkCount", _leftWorkCount))
          end
        end
        if true == Worker_Table[workerIndex]._isChecked then
          self._worker_CheckBox[idx]:SetCheck(true)
        else
          self._worker_CheckBox[idx]:SetCheck(false)
        end
      else
        self._worker_BG[idx]:SetShow(false)
        self._List_Empty[idx]:SetShow(true)
      end
      workerIndex = workerIndex + 1
    else
      self._worker_BG[idx]:SetShow(false)
      self._worker_CheckBox[idx]:SetShow(false)
      self._worker_Name[idx]:SetShow(false)
      self._worker_RestorePoint[idx]:SetShow(false)
      self._worker_CurrentPoint[idx]:SetShow(false)
      self._worker_State[idx]:SetShow(false)
      self._worker_Move[idx]:SetShow(false)
      self._worker_Redo[idx]:SetShow(false)
      _blank_Count = _blank_Count + 1
    end
  end
  UIScroll.SetButtonSize(defaul_Control._List_Scroll, scroll_Param._slotMax, scroll_Param._contentCount + _blank_Count)
  local _offsetMax = scroll_Param._offsetMax
  if _offsetMax == 0 then
    _offsetMax = 1
  end
  local _offsetIndex = scroll_Param._offsetIndex
  if _offsetMax < _offsetIndex then
    _offsetIndex = _offsetMax
  end
  defaul_Control._List_Scroll:SetControlPos(_offsetIndex / _offsetMax)
end
local workerIndex_CancelWork
function WorkerManage_CancelWork(workerIndex)
  workerIndex_CancelWork = workerIndex
  local _workerNo = Worker_Table[workerIndex]._WorkerNo:get_s64()
  local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(_workerNo)
  local _leftWorkCount = ToClient_getNpcWorkerWorkingCount(_workerNo)
  if _leftWorkCount < 1 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_HOUSECONTROL_ONLYONEWORK"))
    return
  else
    local workName = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_TOWN_WORKERMANAGE_PORTRESS")
    if nil ~= esSSW then
      workName = esSSW:getDescription()
    end
    local cancelWorkContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_TOWN_WORKERMANAGE_CONFIRM_WORKCANCEL", "workName", workName)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WORKINGPROGRESS_CANCELWORK_TITLE"),
      content = cancelWorkContent,
      functionYes = WorkerManage_CancelWork_Continue,
      functionCancel = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "top")
  end
end
function WorkerManage_CancelWork_Continue()
  local _workerNo = Worker_Table[workerIndex_CancelWork]._WorkerNo
  ToClient_requestCancelNextWorking(_workerNo)
end
function HandleLClick_WorkerState_Button(workerIndex, idx)
  if Worker_Table[workerIndex]._State == eWorkerStateType.waiting then
    RestoreItem_Table_Set()
    Control_RestoreItem:InsertControl(idx, false)
    Control_RestoreItem.workerIndex = workerIndex
  elseif Worker_Table[workerIndex]._State == eWorkerStateType.working then
    local workStringNo = tostring(Worker_Table[workerIndex]._WorkerNo:get_s64())
    waitingCancelWorkerNo[workStringNo] = true
    WorkerManage_CancelWork(workerIndex)
  elseif Worker_Table[workerIndex]._State == eWorkerStateType.transfer then
  end
  HandleOut_WorkerTooltip(idx, true)
end
function HandleLClick_WorkerMove_Button(workerIndex, idx)
  local workerData = ToClient_getPlantWaitWorkerByIndex(plantKey, workerIndex)
  local workerStaticStatus = workerData:getWorkerStaticStatus()
  if false == ToClient_isWaitWorker(workerData) then
    FGlobal_WorldMapWindowEscape()
    ToClient_setTownModeByWorkNo(workerData:getWorkerNo())
  end
end
function HandleOn_WorkerState_Button(workerIndex, idx)
  if false == Panel_Worker_Tooltip:GetShow() then
    HandleOn_WorkerTooltip(idx)
  end
  if Worker_Table[workerIndex]._State == eWorkerStateType.waiting then
    Control_WorkerList._worker_State[idx]:SetText("<PAColor0xfffeff99>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE") .. "<PAOldColor>")
  elseif Worker_Table[workerIndex]._State == eWorkerStateType.working then
    Control_WorkerList._worker_State[idx]:SetText("<PAColor0xffde3900>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_CANCELWORK") .. "<PAOldColor>")
  elseif Worker_Table[workerIndex]._State == eWorkerStateType.transfer then
  end
end
function HandleOut_WorkerState_Button(workerIndex, idx)
  if true == UI.isInPositionForLua(Control_WorkerList._worker_BG[idx], getMousePosX(), getMousePosY()) then
    return
  end
  if Panel_Worker_Tooltip:GetShow() then
    HandleOut_WorkerTooltip(idx, false)
  end
  if nil == Worker_Table[workerIndex] then
    return
  end
  if Worker_Table[workerIndex]._State == eWorkerStateType.waiting or Worker_Table[workerIndex]._State == eWorkerStateType.working then
    if Control_RestoreItem._saveIndex == idx then
      return
    end
    local state = ""
    if Worker_Table[workerIndex]._State == eWorkerStateType.waiting then
      state = "<PAColor0xfffeff99>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE") .. "<PAOldColor>"
    else
      state = "<PAColor0xffde3900>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_CANCELWORK") .. "<PAOldColor>"
    end
    Control_WorkerList._worker_State[idx]:SetText(state)
  elseif Worker_Table[workerIndex]._State == eWorkerStateType.transfer then
  end
end
function Control_Scroll(isUp, isSlider)
  if Control_RestoreItem._Item_BG:GetShow() and false == isSlider then
    Control_RestoreItem_Reset()
  end
  local self = scroll_Param
  if true == isSlider then
    self = slider_Param
  end
  if self._offsetIndex == 0 and self._offsetMax == 0 then
    return
  end
  local save_offset = self._offsetIndex
  if true == isUp then
    self._offsetIndex = self._offsetIndex - 1
    if self._offsetIndex < 0 then
      self._offsetIndex = 0
    end
  else
    self._offsetIndex = self._offsetIndex + 1
    if self._offsetIndex > self._offsetMax then
      self._offsetIndex = self._offsetMax
    end
  end
  if save_offset ~= self._offsetIndex then
    if false == isSlider then
      Control_WorkerList:UpdateSlot(0, false)
      if WorkerTooltip_Index ~= nil and Panel_Worker_Tooltip:GetShow() then
        HandleOn_WorkerTooltip(WorkerTooltip_Index)
      end
    elseif true == isSlider then
      Control_RestoreItem:UpdateItemList()
      if ItemTooltip_Index ~= nil and Panel_Tooltip_Item:GetShow() then
        HandleOn_RestoreItemTooltip(ItemTooltip_Index)
      end
    end
  end
end
function Control_ScrollOnClick(isSlider)
  if Control_RestoreItem._Item_BG:GetShow() and false == isSlider then
    Control_RestoreItem_Reset()
  end
  local _scrollSize = defaul_Control._List_Scroll:GetSizeY()
  local _buttonSize = defaul_Control._scroll_Button:GetSizeY()
  local _buttonPos = defaul_Control._scroll_Button:GetPosY()
  local self = scroll_Param
  if true == isSlider then
    _scrollSize = Control_RestoreItem._Item_Slider:GetSizeX()
    _buttonSize = Control_RestoreItem._Item_Slider_Button:GetSizeX()
    _buttonPos = Control_RestoreItem._Item_Slider_Button:GetPosX()
    self = slider_Param
  end
  local namnunSize = _scrollSize - _buttonSize
  local namnunPercents = _buttonPos / namnunSize
  if namnunPercents > 1 then
    namnunPercents = 1
  end
  self._offsetIndex = math.floor(namnunPercents * self._offsetMax)
  if false == isSlider then
    Control_WorkerList:UpdateSlot(0, false)
  elseif true == isSlider then
    Control_RestoreItem:UpdateItemList()
  end
end
function WorldMapWindow_OpenWaitWorkerManageByPlantKey(aPlantKey)
  plantKey = aPlantKey
  scroll_Param._offsetIndex = 0
  Control_RestoreItem_Reset()
  Worker_Table_Set()
end
function WorldMapWindow_OpenWaitWorkerManage(node)
  WorldMapWindow_OpenWaitWorkerManageByPlantKey(node:getPlantKey())
end
function WorldMapWindow_WorkerManage_Refresh()
  if false == ToClient_WorldMapIsShow() or plantKey == nil then
    return
  end
  local saveIndex
  if Control_RestoreItem._Item_BG:GetShow() then
    saveIndex = Control_RestoreItem._saveIndex
  end
  FGlobal_InitWorkerTooltip()
  Worker_Table_Set()
  if saveIndex ~= nil then
    RestoreItem_Table_Set()
    Control_RestoreItem:InsertControl(saveIndex, true)
  end
  if nil ~= ItemTooltip_Index then
    HandleOn_RestoreItemTooltip(ItemTooltip_Index)
  end
end
function WorldMapWindow_CloseWaitWorkerManage()
  Panel_manageWorker:SetShow(false)
  plantKey = nil
  Control_RestoreItem_Reset()
  FGlobal_InitWorkerTooltip()
end
function HandleOn_WorkerTooltip(idx)
  local adjust = 0
  if Control_RestoreItem._Item_BG:GetShow() and idx > Control_RestoreItem._saveIndex then
    adjust = 2
  end
  local workerIndex = scroll_Param._offsetIndex + idx - adjust
  local uiBase = Control_WorkerList._worker_BG[idx]
  if nil == Worker_Table[workerIndex] then
    return
  end
  if true == Worker_Table[workerIndex]._isEmpty then
    HandleOut_WorkerTooltip(idx, true)
  else
    HandleOnWorkerTooltip(ToClient_getPlantWaitWorkerByIndex(plantKey, workerIndex), uiBase)
    WorkerTooltip_Index = idx
  end
end
function HandleOut_WorkerTooltip(idx, isReset)
  local MousePosX = getMousePosX()
  local MousePosY = getMousePosY()
  if WorkerTooltip_Index == idx then
    local uiBase = Control_WorkerList._worker_BG[idx]
    local checkX = MousePosX - uiBase:GetParentPosX()
    local checkY = MousePosY - uiBase:GetParentPosY()
    if checkX > 0 and checkY > 0 and checkX < uiBase:GetSizeX() and checkY < uiBase:GetSizeY() and false == isReset then
      return
    end
    HandleOutWorkerTooltip(uiBase)
    WorkerTooltip_Index = nil
  end
end
function HandleOn_RestoreItemTooltip(idx)
  local itemIndex = slider_Param._offsetIndex + idx
  local staticStatusKey = RestoreItem_Table[itemIndex]._itemKey
  local staticStatusWrapper = getItemEnchantStaticStatus(staticStatusKey)
  local uiBase = Control_RestoreItem._Item_IconBG[idx]
  Panel_Tooltip_Item_Show(staticStatusWrapper, uiBase, true, false)
  ItemTooltip_Index = idx
  local itemIndex = slider_Param._offsetIndex + idx
  local workerIndex = Control_RestoreItem.workerIndex
  local index = Control_RestoreItem.Index
  local restorePoint = RestoreItem_Table[itemIndex]._restore
  local progressRate = (Worker_Table[workerIndex]._CurrentPoint + restorePoint + Worker_Table[workerIndex]._recoveryActionPoint) / Worker_Table[workerIndex]._MaxPoint * 100
  Control_WorkerList._worker_RestorePoint[index]:SetProgressRate(progressRate)
end
function HandleOut_RestoreItemTooltip(idx)
  if nil == idx then
    Panel_Tooltip_Item_hideTooltip()
    for key, value in pairs(Control_WorkerList._worker_RestorePoint) do
      value:SetProgressRate(0)
    end
    ItemTooltip_Index = nil
  elseif ItemTooltip_Index == idx then
    Panel_Tooltip_Item_hideTooltip()
    local workerIndex = Control_RestoreItem.workerIndex
    local index = Control_RestoreItem.Index
    local progressRate = Worker_Table[workerIndex]._CurrentPoint / Worker_Table[workerIndex]._MaxPoint * 100
    Control_WorkerList._worker_RestorePoint[index]:SetProgressRate(progressRate)
    ItemTooltip_Index = nil
  end
end
function HandleClick_RestoreItem(idx)
  local index = slider_Param._offsetIndex + idx
  local workerIndex = Control_RestoreItem.workerIndex
  local workerNo = Worker_Table[workerIndex]._WorkerNo
  local slotNo = RestoreItem_Table[index]._slotNo
  if Worker_Table[workerIndex]._MaxPoint == Worker_Table[workerIndex]._CurrentPoint then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE_MAX"))
    return
  end
  requestRecoveryWorker(workerNo, slotNo, 1)
end

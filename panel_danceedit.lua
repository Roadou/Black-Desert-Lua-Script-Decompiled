PaGlobal_DanceEdit = {
  _controller = {
    _list2_DanceList = UI.getChildControl(Panel_DanceEdit, "List2_SlotContainer")
  },
  slotCountPerLine = 4,
  _selectIndex = -1
}
function PaGlobal_DanceEdit:getSelectIndex()
  return self._selectIndex
end
function PaGlobal_DanceEdit:Initialize()
  self._selectIndex = -1
  PaGlobal_DanceEdit:UpdateList()
  local uiStatic, uiSaveButton, uiResetButton = UI.getChildControl(Panel_DanceEdit, "Static_PlayVideo"), UI.getChildControl(Panel_DanceEdit, "Button_Save"), UI.getChildControl(Panel_DanceEdit, "Button_Reset")
  local uiPlayButton = UI.getChildControl(uiStatic, "Button_Play")
  uiPlayButton:addInputEvent("Mouse_LUp", "PanelDanceEdit_Event_PlayDance()")
  uiSaveButton:addInputEvent("Mouse_LUp", "PanelDanceEdit_Event_SaveDance()")
  uiResetButton:addInputEvent("Mouse_LUp", "PanelDanceEdit_Event_ResetDance()")
end
function PanelDanceEdit_Event_PlayDance()
  getGameDanceEditor():playDance()
end
function PanelDanceEdit_Event_SaveDance()
  getGameDanceEditor():saveDance()
end
function PanelDanceEdit_Event_ResetDance()
  getGameDanceEditor():clearDance()
end
function PanelDanceEdit_Ev_ControlCreate(control, key)
  local danceSize = getGameDanceEditor():getDanceSize()
  key = Int64toInt32(key)
  for i = 0, PaGlobal_DanceEdit.slotCountPerLine - 1 do
    local relativePos = i + key * PaGlobal_DanceEdit.slotCountPerLine
    local uiContent = UI.getChildControl(control, "Static_SlotBg_" .. tostring(i))
    uiContent:SetShow(danceSize > relativePos)
    uiContent:addInputEvent("Mouse_LUp", "PanelDanceEdit_SlotEvent_MouseLUp(" .. relativePos .. ")")
  end
end
function PanelDanceEdit_SlotEvent_MouseLUp(danceIndex)
  Proc_ShowMessage_Ack("DANCE_IDX: " .. tostring(danceIndex))
  local lstControl = PaGlobal_DanceEdit._controller._list2_DanceList
  local slotIndex = PaGlobal_DanceEdit._selectIndex % PaGlobal_DanceEdit.slotCountPerLine
  local content, selectControl = {}, {}
  PaGlobal_DanceEdit:HideSelect()
  if danceIndex ~= -1 then
    PaGlobal_DanceEdit._selectIndex = danceIndex
    slotIndex = danceIndex % PaGlobal_DanceEdit.slotCountPerLine
    content = lstControl:GetContentByKey(danceIndex / PaGlobal_DanceEdit.slotCountPerLine)
    selectControl = UI.getChildControl(content, "Static_Select_" .. tostring(slotIndex))
    selectControl:SetShow(true)
    local deleteButton = UI.getChildControl(selectControl, "Button_Remove")
    local speedUpButton = UI.getChildControl(selectControl, "Button_SpeedUp")
    local speedDwbutton = UI.getChildControl(selectControl, "Button_SpeedDown")
    deleteButton:addInputEvent("Mouse_LUp", "PanelDanceEdit_SlotEvent_DeleteLUp(" .. danceIndex .. ")")
    speedUpButton:addInputEvent("Mouse_LUp", "PanelDanceEdit_SlotEvent_SpeedUpLUp(" .. danceIndex .. ")")
    speedDwbutton:addInputEvent("Mouse_LUp", "PanelDanceEdit_SlotEvent_SpeedDwLUp(" .. danceIndex .. ")")
    local danceInfo = getGameDanceEditor():getDanceInfo()
    if danceInfo[danceIndex] == nil then
      _PA_LOG("\234\185\128\234\183\156\235\179\180", "danceInfo[danceIndex] == nil  " .. danceIndex)
    end
    PanelDanceEdit_Slot_SpeedUpdate(danceIndex, danceInfo[danceIndex].speed)
  end
end
function PaGlobal_DanceEdit:HideSelect()
  if PaGlobal_DanceEdit._selectIndex == -1 then
    return
  end
  local lstControl = PaGlobal_DanceEdit._controller._list2_DanceList
  local slotIndex = PaGlobal_DanceEdit._selectIndex % self.slotCountPerLine
  local content, selectControl = {}, {}
  content = lstControl:GetContentByKey(PaGlobal_DanceEdit._selectIndex / self.slotCountPerLine)
  selectControl = UI.getChildControl(content, "Static_Select_" .. tostring(slotIndex))
  selectControl:SetShow(false)
end
function PanelDanceEdit_SlotEvent_DeleteLUp(danceIndex)
  Proc_ShowMessage_Ack("DELETE_IDX: " .. tostring(danceIndex))
  getGameDanceEditor():delDanceUnit(danceIndex)
  PaGlobal_DanceEdit:HideSelect()
  PaGlobal_DanceEdit:UpdateList()
  self._selectIndex = -1
end
function PanelDanceEdit_SlotEvent_SpeedUpLUp(danceIndex)
  local danceInfo = getGameDanceEditor():getDanceInfo()
  local changeSpeed = danceInfo[danceIndex].speed + 0.1
  getGameDanceEditor():editDanceUnit(danceIndex, changeSpeed)
  PanelDanceEdit_Slot_SpeedUpdate(danceIndex, changeSpeed)
end
function PanelDanceEdit_SlotEvent_SpeedDwLUp(danceIndex)
  local danceInfo = getGameDanceEditor():getDanceInfo()
  local changeSpeed = danceInfo[danceIndex].speed - 0.1
  getGameDanceEditor():editDanceUnit(danceIndex, changeSpeed)
  PanelDanceEdit_Slot_SpeedUpdate(danceIndex, changeSpeed)
end
function PanelDanceEdit_Slot_SpeedUpdate(danceIndex, speed)
  local slotIndex = danceIndex % PaGlobal_DanceEdit.slotCountPerLine
  local content = PaGlobal_DanceEdit._controller._list2_DanceList:GetContentByKey(danceIndex / PaGlobal_DanceEdit.slotCountPerLine)
  local selectControl = UI.getChildControl(content, "Static_Select_" .. tostring(slotIndex))
  local speedText = UI.getChildControl(selectControl, "StaticText_Speed")
  speedText:SetText("X " .. string.format("%.1f", speed))
end
function PaGlobal_DanceEdit:UpdateList()
  local uiList2 = PaGlobal_DanceEdit._controller._list2_DanceList
  uiList2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PanelDanceEdit_Ev_ControlCreate")
  uiList2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  uiList2:getElementManager():clearKey()
  local danceSize = getGameDanceEditor():getDanceSize()
  local pushKeycount = danceSize / self.slotCountPerLine
  if danceSize % self.slotCountPerLine ~= 0 then
    pushKeycount = pushKeycount + 1
  end
  for pushKeyIndex = 0, pushKeycount do
    uiList2:getElementManager():pushKey(pushKeyIndex)
  end
end
PaGlobal_DanceEdit:Initialize()

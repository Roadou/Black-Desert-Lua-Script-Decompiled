Panel_WorkerRestoreAll:SetShow(false)
Panel_WorkerRestoreAll:setGlassBackground(true)
Panel_WorkerRestoreAll:ActiveMouseEventEffect(true)
local UI_TM = CppEnums.TextMode
local UI_PP = CppEnums.PAUIMB_PRIORITY
local UI_Color = Defines.Color
local workerRestoreAll = {
  slot = {},
  startPosY = 5,
  _startIndex = 0,
  _listCount = 0,
  _panelTitle = UI.getChildControl(Panel_WorkerRestoreAll, "titlebar_RestoreAll"),
  _itemListBG = UI.getChildControl(Panel_WorkerRestoreAll, "Static_ItemList_BG"),
  _selectItemGuide = UI.getChildControl(Panel_WorkerRestoreAll, "StaticText_Select_Item_Guide"),
  _workerStatusBG = UI.getChildControl(Panel_WorkerRestoreAll, "Static_WorkerStatusBG"),
  _workernPoint = UI.getChildControl(Panel_WorkerRestoreAll, "StaticText_Worker"),
  _restorePoint = UI.getChildControl(Panel_WorkerRestoreAll, "StaticText_RestorePoint"),
  _possiblePoint = UI.getChildControl(Panel_WorkerRestoreAll, "StaticText_PossiblePoint"),
  _slider = UI.getChildControl(Panel_WorkerRestoreAll, "Slider_Restore_Item"),
  _midLine = UI.getChildControl(Panel_WorkerRestoreAll, "Static_MidLine"),
  _btnWinClose = UI.getChildControl(Panel_WorkerRestoreAll, "Button_Close"),
  _btnConfirm = UI.getChildControl(Panel_WorkerRestoreAll, "Button_Restore"),
  _btnCancel = UI.getChildControl(Panel_WorkerRestoreAll, "Button_Cancel"),
  restoreItemMaxCount = 6,
  restoreItemHasCount = 0,
  restoreItemSlot = {},
  selectedRestoreWorkerIdx = 0,
  selectedItemIdx = 0,
  selectedUiIndex = -1,
  sliderStartIdx = 0,
  upgradeWokerIdx = -1
}
workerRestoreAll._sliderBtn = UI.getChildControl(workerRestoreAll._slider, "Slider_Restore_Item_Button")
local itemSelectList = {}
local workerListCount = 0
local workerArray = Array.new()
local function workerRestoreAll_Init()
  local self = workerRestoreAll
  for resIdx = 0, self.restoreItemMaxCount - 1 do
    local tempItemSlot = {}
    tempItemSlot.slotBG = UI.createAndCopyBasePropertyControl(Panel_WorkerRestoreAll, "Static_Restore_Item_Icon_BG", self._itemListBG, "workerManager_restoreSlotBG_" .. resIdx)
    tempItemSlot.slotIcon = UI.createAndCopyBasePropertyControl(Panel_WorkerRestoreAll, "Static_Restore_Item_Icon", tempItemSlot.slotBG, "workerManager_restoreSlot_" .. resIdx)
    tempItemSlot.selectIcon = UI.createAndCopyBasePropertyControl(Panel_WorkerRestoreAll, "Static_Selected_Item_Icon", tempItemSlot.slotBG, "workerManager_selectedSlot_" .. resIdx)
    tempItemSlot.itemCount = UI.createAndCopyBasePropertyControl(Panel_WorkerRestoreAll, "StaticText_Item_Count", tempItemSlot.slotIcon, "workerManager_restoreItemCount_" .. resIdx)
    tempItemSlot.restorePoint = UI.createAndCopyBasePropertyControl(Panel_WorkerRestoreAll, "StaticText_Item_Restore_Value", tempItemSlot.slotIcon, "workerManager_restorePoint_" .. resIdx)
    tempItemSlot.slotBG:SetPosX(17 + resIdx * 52)
    tempItemSlot.slotBG:SetPosY(87)
    tempItemSlot.slotBG:SetPosY(53)
    tempItemSlot.slotIcon:SetPosX(5)
    tempItemSlot.slotIcon:SetPosY(5)
    tempItemSlot.selectIcon:SetPosX(0)
    tempItemSlot.selectIcon:SetPosY(0)
    tempItemSlot.itemCount:SetPosX(tempItemSlot.slotIcon:GetSizeX() - 9)
    tempItemSlot.itemCount:SetPosY(tempItemSlot.slotIcon:GetSizeY() - 10)
    tempItemSlot.restorePoint:SetPosX(3)
    tempItemSlot.restorePoint:SetPosY(2)
    tempItemSlot.slotBG:addInputEvent("Mouse_UpScroll", "workerRestoreAll_SliderScroll( true )")
    tempItemSlot.slotBG:addInputEvent("Mouse_DownScroll", "workerRestoreAll_SliderScroll( false )")
    tempItemSlot.slotIcon:addInputEvent("Mouse_UpScroll", "workerRestoreAll_SliderScroll( true )")
    tempItemSlot.slotIcon:addInputEvent("Mouse_DownScroll", "workerRestoreAll_SliderScroll( false )")
    tempItemSlot.selectIcon:addInputEvent("Mouse_UpScroll", "workerRestoreAll_SliderScroll( true )")
    tempItemSlot.selectIcon:addInputEvent("Mouse_DownScroll", "workerRestoreAll_SliderScroll( false )")
    self.restoreItemSlot[resIdx] = tempItemSlot
  end
  self._itemListBG:AddChild(self._slider)
  self._itemListBG:addInputEvent("Mouse_UpScroll", "workerRestoreAll_SliderScroll( true )")
  self._itemListBG:addInputEvent("Mouse_DownScroll", "workerRestoreAll_SliderScroll( false )")
  self._btnCancel:addInputEvent("Mouse_LUp", "workerRestoreAll_Close()")
  self._btnWinClose:addInputEvent("Mouse_LUp", "workerRestoreAll_Close()")
  self._slider:SetPosX(15)
  self._slider:SetPosY(100)
  Panel_WorkerRestoreAll:RemoveControl(self._slider)
end
local function restoreItem_update()
  local self = workerRestoreAll
  for itemIdx = 0, self.restoreItemMaxCount - 1 do
    local slot = self.restoreItemSlot[itemIdx]
    slot.slotBG:SetShow(false)
    slot.slotIcon:addInputEvent("Mouse_RUp", "")
    slot.selectIcon:addInputEvent("Mouse_RUp", "")
    slot.selectIcon:SetShow(false)
  end
  self.restoreItemHasCount = ToClient_getNpcRecoveryItemList()
  if 0 >= self.restoreItemHasCount then
    Panel_WorkerRestoreAll:SetShow(false)
    if Panel_WorkerRestoreAll:IsUISubApp() then
      Panel_WorkerRestoreAll:CloseUISubApp()
    end
  end
  local uiIdx = 0
  for itemIdx = self.sliderStartIdx, self.restoreItemHasCount - 1 do
    if uiIdx >= self.restoreItemMaxCount then
      break
    end
    local slot = self.restoreItemSlot[uiIdx]
    slot.slotBG:SetShow(true)
    if itemSelectList[itemIdx] then
      slot.selectIcon:SetShow(true)
    elseif false == itemSelectList[itemIdx] then
      slot.selectIcon:SetShow(false)
    end
    local recoveryItem = ToClient_getNpcRecoveryItemByIndex(itemIdx)
    local itemStatic = recoveryItem:getItemStaticStatus()
    slot.slotIcon:ChangeTextureInfoName("icon/" .. getItemIconPath(itemStatic))
    slot.itemCount:SetText(tostring(recoveryItem._itemCount_s64))
    slot.restorePoint:SetText("+" .. tostring(recoveryItem._contentsEventParam1))
    slot.slotIcon:addInputEvent("Mouse_LUp", "HandleClicked_restoreAll_SelectItem(" .. itemIdx .. ")")
    uiIdx = uiIdx + 1
  end
  if self.restoreItemMaxCount < self.restoreItemHasCount then
    self._slider:SetShow(true)
    local sliderSize = self._slider:GetSizeX()
    local targetPercent = self.restoreItemMaxCount / self.restoreItemHasCount * 100
    local sliderBtnSize = sliderSize * (targetPercent / 100)
    self._sliderBtn:SetSize(sliderBtnSize, self._sliderBtn:GetSizeY())
    self._slider:SetInterval(self.restoreItemHasCount - self.restoreItemMaxCount)
    self._slider:addInputEvent("Mouse_LUp", "HandleLPress_WorkerManager_RestoreItemSlider()")
    self._sliderBtn:addInputEvent("Mouse_LPress", "HandleLPress_WorkerManager_RestoreItemSlider()")
  else
    self._slider:SetShow(false)
  end
  local workerCount = 0
  local totalPoint = 0
  local selectItem = ToClient_getNpcRecoveryItemByIndex(self.selectedItemIdx)
  if nil == selectItem then
    return
  end
  local selectItemCount = Int64toInt32(selectItem._itemCount_s64)
  local selectItemPoint = selectItem._contentsEventParam1
  local totalselectItemPoint = selectItemCount * selectItemPoint
  local workerIndexCtrl = 1
  local workerCountCtrl = 0
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    workerIndexCtrl = 0
    workerCountCtrl = 1
  end
  for idx = workerIndexCtrl, workerListCount - workerCountCtrl do
    local workerNoRaw = workerArray[idx]
    if nil == workerNoRaw then
      return
    end
    local workerWrapperLua = getWorkerWrapper(workerNoRaw, false)
    local maxPoint = workerWrapperLua:getMaxActionPoint()
    local currentPoint = workerWrapperLua:getActionPoint()
    local restoreActionPoint = maxPoint - currentPoint
    local remainder = 0
    remainder = restoreActionPoint % selectItemPoint
    if maxPoint >= currentPoint + selectItemPoint then
      workerCount = workerCount + 1
      totalPoint = totalPoint + (restoreActionPoint - remainder)
    end
  end
  local function WorkerRestore()
    local sizeX = 0
    local itemTextSizeX = self._selectItemGuide:GetTextSizeX()
    local workerTextSizeX = self._workernPoint:GetTextSizeX()
    local restoreTextSizeX = self._restorePoint:GetTextSizeX()
    local possibleTextSizeX = self._possiblePoint:GetTextSizeX()
    local Size_Com = function(bgSize, controlSize)
      if bgSize < controlSize then
        bgSize = controlSize
      end
      return bgSize
    end
    sizeX = Size_Com(sizeX, itemTextSizeX)
    sizeX = Size_Com(sizeX, workerTextSizeX)
    sizeX = Size_Com(sizeX, restoreTextSizeX)
    sizeX = Size_Com(sizeX, possibleTextSizeX)
    local bgSizeX = 0
    local itemBGSizeX1 = self._itemListBG:GetSizeX()
    local descBGSizeX2 = self._workerStatusBG:GetSizeX()
    bgSizeX = Size_Com(bgSizeX, itemBGSizeX1)
    bgSizeX = Size_Com(bgSizeX, descBGSizeX2)
    if bgSizeX < sizeX + 20 then
      local sizeX = sizeX + 20 - bgSizeX
      Panel_WorkerRestoreAll:SetSize(Panel_WorkerRestoreAll:GetSizeX() + sizeX, Panel_WorkerRestoreAll:GetSizeY())
      Panel_WorkerRestoreAll:SetPosX(Panel_WorkerRestoreAll:GetPosX() - sizeX)
      self._itemListBG:SetSize(bgSizeX + sizeX, self._itemListBG:GetSizeY())
      self._workerStatusBG:SetSize(self._workerStatusBG:GetSizeX() + sizeX, self._workerStatusBG:GetSizeY())
      self._panelTitle:SetSize(self._panelTitle:GetSizeX() + sizeX, self._panelTitle:GetSizeY())
      self._midLine:SetSize(self._midLine:GetSizeX() + sizeX, self._midLine:GetSizeY())
      self._slider:SetSize(self._slider:GetSizeX() + sizeX, self._slider:GetSizeY())
      self._slider:SetInterval(self._slider:GetSizeX() + sizeX)
      self._btnCancel:ComputePos()
      self._btnConfirm:ComputePos()
      self._btnWinClose:ComputePos()
    end
  end
  self._selectItemGuide:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERRESTOREALL_DESC_SELECTITEM"))
  self._workernPoint:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERRESTORE_WORKERCOUNT", "count", tostring(workerCount)))
  self._restorePoint:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERRESTORE_POSSIBLE", "totalPoint", tostring(totalPoint)))
  if totalselectItemPoint >= totalPoint then
    self._possiblePoint:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORKERRESTORE_CONSUMEITEM", "selectItemCount", tostring(totalPoint / selectItemPoint), "totalPoint", tostring(totalPoint)))
  elseif totalselectItemPoint < totalPoint then
    self._possiblePoint:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORKERRESTORE_CONSUMEITEM", "selectItemCount", tostring(selectItemCount), "totalPoint", tostring(totalselectItemPoint)))
  end
  WorkerRestore()
end
function HandleClicked_restoreAll_SelectItem(itemIdx)
  local self = workerRestoreAll
  for idx = 0, self.restoreItemHasCount - 1 do
    itemSelectList[idx] = false
  end
  if nil == itemSelectList[itemIdx] or false == itemSelectList[itemIdx] then
    itemSelectList[itemIdx] = true
    self.selectedItemIdx = itemIdx
  else
    itemSelectList[itemIdx] = false
  end
  self._btnConfirm:addInputEvent("Mouse_LUp", "workerRestoreAll_Confirm(" .. self.selectedItemIdx .. ")")
  restoreItem_update()
end
function workerRestoreAll_SliderScroll(isUp)
  local self = workerRestoreAll
  if true == isUp then
    if self.sliderStartIdx <= 0 then
      self.sliderStartIdx = 0
      return
    end
    self.sliderStartIdx = self.sliderStartIdx - 1
  else
    if self.restoreItemHasCount <= self.sliderStartIdx + self.restoreItemMaxCount then
      return
    end
    self.sliderStartIdx = self.sliderStartIdx + 1
  end
  local currentPos = self.sliderStartIdx / (self.restoreItemHasCount - self.restoreItemMaxCount) * 100
  if currentPos > 100 then
    currentPos = 100
  elseif currentPos < 0 then
    currentPos = 0
  end
  self._slider:SetControlPos(currentPos)
  restoreItem_update()
end
function HandleLPress_WorkerManager_RestoreItemSlider()
  local self = workerRestoreAll
  local pos = self._slider:GetControlPos()
  local posIdx = math.floor((self.restoreItemHasCount - self.restoreItemMaxCount) * pos)
  if posIdx > self.restoreItemHasCount - self.restoreItemMaxCount then
    return
  end
  self.sliderStartIdx = posIdx
  local currentPos = self.sliderStartIdx / (self.restoreItemHasCount - self.restoreItemMaxCount) * 100
  if currentPos > 100 then
    currentPos = 100
  elseif currentPos < 0 then
    currentPos = 0
  end
  self._slider:SetControlPos(currentPos)
  restoreItem_update()
end
function workerRestoreAll_Confirm(itemIdx)
  local self = workerRestoreAll
  local recoveryItem = ToClient_getNpcRecoveryItemByIndex(itemIdx)
  local recoveryItemCount = Int64toInt32(recoveryItem._itemCount_s64)
  local restorePoint = recoveryItem._contentsEventParam1
  local slotNo = recoveryItem._slotNo
  local selectCheckCount = 0
  for ii = 0, self.restoreItemHasCount - 1 do
    if true == itemSelectList[ii] then
      selectCheckCount = selectCheckCount + 1
    end
  end
  if 0 == selectCheckCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERRESTORE_NOSELECTITEM"))
    return
  end
  local currentItemCount = recoveryItemCount
  local workerIndexCtrl = 1
  local workerCountCtrl = 0
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    workerIndexCtrl = 0
    workerCountCtrl = 1
  end
  for idx = workerIndexCtrl, workerListCount - workerCountCtrl do
    local workerNoRaw = workerArray[idx]
    if nil == workerNoRaw then
      return
    end
    local workerWrapperLua = getWorkerWrapper(workerNoRaw, false)
    local maxPoint = workerWrapperLua:getMaxActionPoint()
    local currentPoint = workerWrapperLua:getActionPoint()
    local restoreItemCount = ToClient_getNpcRecoveryItemList()
    local restoreActionPoint = maxPoint - currentPoint
    local itemNeedCount = math.floor(restoreActionPoint / restorePoint)
    if currentItemCount < itemNeedCount then
      itemNeedCount = currentItemCount
    end
    if itemNeedCount >= 1 then
      requestRecoveryWorker(WorkerNo(workerNoRaw), slotNo, itemNeedCount)
      currentItemCount = currentItemCount - itemNeedCount
    end
  end
end
function FGlobal_restoreItem_update()
  restoreItem_update()
end
function FGlobal_WorkerRestoreAll_Open(listCount, workerNoRaw)
  local panel
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    panel = Panel_Window_WorkerManager_All
  else
    panel = Panel_WorkerManager
  end
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    Panel_WorkerRestoreAll:SetPosX(panel:GetPosX() + panel:GetSizeX() / 2 - Panel_WorkerRestoreAll:GetSizeX() / 2)
    Panel_WorkerRestoreAll:SetPosY(panel:GetPosY() + panel:GetSizeY() / 2 - Panel_WorkerRestoreAll:GetSizeY() / 2)
  else
    Panel_WorkerRestoreAll:SetPosX(getScreenSizeX() - panel:GetSizeX() - Panel_WorkerRestoreAll:GetSizeX() - 10)
    Panel_WorkerRestoreAll:SetPosY(panel:GetPosY())
  end
  if panel:IsUISubApp() then
    if panel:GetScreenParentPosX() > 0 then
      Panel_WorkerRestoreAll:SetPosX(panel:GetScreenParentPosX() - Panel_WorkerRestoreAll:GetSizeX() - 10)
    else
      Panel_WorkerRestoreAll:SetPosX(panel:GetScreenParentPosX() + panel:GetSizeX() - 10)
    end
    Panel_WorkerRestoreAll:SetPosY(panel:GetScreenParentPosY())
  end
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:push(Panel_WorkerRestoreAll, true)
  else
    Panel_WorkerRestoreAll:SetShow(true)
    if panel:IsUISubApp() then
      Panel_WorkerRestoreAll:OpenUISubApp()
    end
  end
  workerListCount = listCount
  workerArray = workerNoRaw
  self.sliderStartIdx = 0
  HandleClicked_restoreAll_SelectItem(0)
end
function workerRestoreAll_Close()
  Panel_WorkerRestoreAll:SetShow(false)
  if Panel_WorkerRestoreAll:IsUISubApp() then
    Panel_WorkerRestoreAll:CloseUISubApp()
  end
end
workerRestoreAll_Init()

Panel_Window_WorkerManager_Restore_Renew:SetShow(false)
Panel_Window_WorkerManager_Restore_Renew:ignorePadSnapMoveToOtherPanel()
local workerRestore = {
  _ui = {
    _static_MainTitleBG = UI.getChildControl(Panel_Window_WorkerManager_Restore_Renew, "Static_MainTitleBG"),
    _static_SubFrameBG = UI.getChildControl(Panel_Window_WorkerManager_Restore_Renew, "Static_SubFrameBG"),
    _static_BottomKeyBG = UI.getChildControl(Panel_Window_WorkerManager_Restore_Renew, "Static_BottomKeyBG")
  },
  _config = {
    _slotConfig = {
      createIcon = true,
      createCount = true,
      createMailCount = true
    },
    _maxItemCount = 12,
    _maxItemRow = 6,
    _slotStartX = 42,
    _slotStartY = 105,
    _slotGapX = 70,
    _slotGapY = 60,
    _slotBgSize = 80,
    _itemDescBgSize = 95,
    _feedAllDataBgSize = 115,
    _titleBgSize = 70,
    _bottomBgSize = 70
  },
  _isRestoreAll,
  _selectItemIndex,
  _totalItemCount
}
function workerRestore:initialize()
  self:initControl()
  self:createControl()
end
function workerRestore:initControl()
  local workerRestoreUI = self._ui
  workerRestoreUI._static_ItemSlotBg_Template = UI.getChildControl(workerRestoreUI._static_SubFrameBG, "Static_ItemSlotBg_Template")
  workerRestoreUI._static_ItemSlotBg_Template:SetShow(false)
  workerRestoreUI._staticText_Title = UI.getChildControl(workerRestoreUI._static_MainTitleBG, "StaticText_Title")
  workerRestoreUI._staticText_RestoreWorkerCount = UI.getChildControl(workerRestoreUI._static_SubFrameBG, "StaticText_RestoreWorkerCount")
  workerRestoreUI._staticText_RestroreActionPoint = UI.getChildControl(workerRestoreUI._static_SubFrameBG, "StaticText_RestroreActionPoint")
  workerRestoreUI._staticText_NeedItem = UI.getChildControl(workerRestoreUI._static_SubFrameBG, "StaticText_NeedItem")
  workerRestoreUI._static_HorizontalLine2 = UI.getChildControl(workerRestoreUI._static_SubFrameBG, "Static_HorizontalLine2")
  workerRestoreUI._static_HorizontalLine3 = UI.getChildControl(workerRestoreUI._static_SubFrameBG, "Static_HorizontalLine3")
  workerRestoreUI._static_HorizontalLine4 = UI.getChildControl(workerRestoreUI._static_SubFrameBG, "Static_HorizontalLine4")
  workerRestoreUI._staticText_FeedAll_ConsoleUI = UI.getChildControl(workerRestoreUI._static_BottomKeyBG, "StaticText_FeedAll_ConsoleUI")
  workerRestoreUI._staticText_Feed_ConsoleUI = UI.getChildControl(workerRestoreUI._static_BottomKeyBG, "StaticText_Feed_ConsoleUI")
  workerRestoreUI._staticText_Cancel_ConsoleUI = UI.getChildControl(workerRestoreUI._static_BottomKeyBG, "StaticText_Cancel_ConsoleUI")
end
function workerRestore:createControl()
  local workerRestoreUI = self._ui
  workerRestoreUI._restoreItemSlot = {}
  for index = 0, self._config._maxItemCount - 1 do
    workerRestoreUI._restoreItemSlot[index] = {}
    workerRestoreUI._restoreItemSlot[index].slotBG = UI.cloneControl(workerRestoreUI._static_ItemSlotBg_Template, workerRestoreUI._static_SubFrameBG, "Item_Slot_" .. index)
    workerRestoreUI._restoreItemSlot[index].slotBG:addInputEvent("Mouse_On", "PaGlobalFunc_WorkerManager_Restore_SelectItem(" .. index .. ")")
    local itemSlot = {}
    SlotItem.new(itemSlot, "Item_Slot_" .. index, index, workerRestoreUI._restoreItemSlot[index].slotBG, self._config._slotConfig)
    itemSlot:createChild()
    workerRestoreUI._restoreItemSlot[index].slotBG:SetPosX(self._config._slotStartX + self._config._slotGapX * (index % self._config._maxItemRow))
    workerRestoreUI._restoreItemSlot[index].slotBG:SetPosY(self._config._slotStartY + self._config._slotGapY * math.floor(index / self._config._maxItemRow))
    workerRestoreUI._restoreItemSlot[index].slotBG:SetShow(false)
    workerRestoreUI._restoreItemSlot[index].itemSlot = itemSlot
  end
end
function FromClient_luaLoadComplete_WorkerManager_Restore()
  workerRestore:initialize()
end
function workerRestore:setPanelSize()
  local config = self._config
  local sizeX = Panel_Window_WorkerManager_Restore_Renew:GetSizeX()
  local sizeY = config._bottomBgSize + config._titleBgSize
  local subFrameSize = 0
  subFrameSize = config._itemDescBgSize + config._slotBgSize * math.ceil(self._totalItemCount / self._config._maxItemRow)
  if true == self._isRestoreAll then
    subFrameSize = subFrameSize + config._feedAllDataBgSize
  end
  sizeY = sizeY + subFrameSize
  self._ui._static_SubFrameBG:SetSize(self._ui._static_SubFrameBG:GetSizeX(), subFrameSize)
  Panel_Window_WorkerManager_Restore_Renew:SetSize(sizeX, sizeY)
  if true == self._isRestoreAll then
    self._ui._static_HorizontalLine3:ComputePos()
    local addSize = config._slotBgSize * (math.ceil(self._totalItemCount / self._config._maxItemRow) - 1)
    local orginPos = self._ui._static_HorizontalLine3:GetPosY()
    local newPos = orginPos + addSize
    self._ui._static_HorizontalLine3:SetPosY(newPos)
    newPos = newPos + 25
    self._ui._staticText_RestoreWorkerCount:SetPosY(newPos)
    newPos = newPos + 25
    self._ui._staticText_RestroreActionPoint:SetPosY(newPos)
    newPos = newPos + 25
    self._ui._staticText_NeedItem:SetPosY(newPos)
  end
  self._ui._static_HorizontalLine4:ComputePos()
  self._ui._static_BottomKeyBG:ComputePos()
  self._ui._staticText_FeedAll_ConsoleUI:ComputePos()
  self._ui._staticText_Feed_ConsoleUI:ComputePos()
  self._ui._staticText_Cancel_ConsoleUI:ComputePos()
  local newPosX = self._ui._staticText_Cancel_ConsoleUI:GetPosX() - self._ui._staticText_Feed_ConsoleUI:GetTextSizeX() - 50
  self._ui._staticText_Feed_ConsoleUI:SetPosX(newPosX)
  newPosX = newPosX - self._ui._staticText_FeedAll_ConsoleUI:GetTextSizeX() - 50
  self._ui._staticText_FeedAll_ConsoleUI:SetPosX(newPosX)
end
function workerRestore:setPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_Window_WorkerManager_Restore_Renew:GetSizeX()
  local panelSizeY = Panel_Window_WorkerManager_Restore_Renew:GetSizeY()
  Panel_Window_WorkerManager_Restore_Renew:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Panel_Window_WorkerManager_Restore_Renew:SetPosY(scrSizeY / 2 - panelSizeY / 2)
end
function workerRestore:resetData(isRestoreAll)
  self._isRestoreAll = isRestoreAll
  self._selectItemIndex = 0
  self._totalItemCount = 0
  if true == self._isRestoreAll then
    self._ui._staticText_RestoreWorkerCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERRESTORE_WORKERCOUNT", "count", 0))
    self._ui._staticText_RestroreActionPoint:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERRESTORE_POSSIBLE", "totalPoint", 0))
    self._ui._staticText_NeedItem:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORKERRESTORE_CONSUMEITEM", "selectItemCount", 0, "totalPoint", 0))
    self._ui._staticText_Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERRESTOREALL_TITLE"))
    Panel_Window_WorkerManager_Restore_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
    Panel_Window_WorkerManager_Restore_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_WorkerManager_RestoreAll_Confirm()")
    self._ui._static_HorizontalLine3:SetShow(true)
    self._ui._staticText_RestoreWorkerCount:SetShow(true)
    self._ui._staticText_RestroreActionPoint:SetShow(true)
    self._ui._staticText_NeedItem:SetShow(true)
    self._ui._staticText_FeedAll_ConsoleUI:SetShow(false)
  else
    self._ui._staticText_Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERMANAGER_RESTORE_TITLE"))
    Panel_Window_WorkerManager_Restore_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_WorkerManager_Restore_Confirm(true)")
    Panel_Window_WorkerManager_Restore_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_WorkerManager_Restore_Confirm()")
    self._ui._static_HorizontalLine3:SetShow(false)
    self._ui._staticText_RestoreWorkerCount:SetShow(false)
    self._ui._staticText_RestroreActionPoint:SetShow(false)
    self._ui._staticText_NeedItem:SetShow(false)
    self._ui._staticText_FeedAll_ConsoleUI:SetShow(true)
  end
end
function workerRestore:setRestoreItemData()
  self._totalItemCount = ToClient_getNpcRecoveryItemList()
  for index = 0, self._config._maxItemCount - 1 do
    local slot = self._ui._restoreItemSlot[index]
    if index < self._totalItemCount then
      local recoveryItem = ToClient_getNpcRecoveryItemByIndex(index)
      local itemStatic = recoveryItem:getItemStaticStatus()
      local selectItemCount = Int64toInt32(recoveryItem._itemCount_s64)
      local selectItemPoint = recoveryItem._contentsEventParam1
      slot.slotBG:SetShow(true)
      slot.itemSlot.icon:ChangeTextureInfoName("icon/" .. getItemIconPath(itemStatic))
      slot.itemSlot.count:SetText(tostring(selectItemCount))
      slot.itemSlot.count:SetShow(true)
      slot.itemSlot.mailCount:SetText("+" .. tostring(selectItemPoint))
      slot.itemSlot.mailCount:SetShow(true)
      slot.itemSlot.mailCount:SetFontColor(4288929536)
      slot.itemSlot.mailCount:SetPosX(-20)
      slot.itemSlot.mailCount:SetPosY(-2)
    else
      slot.slotBG:SetShow(false)
    end
  end
end
function workerRestore:open(isRestoreAll)
  if true == Panel_Window_WorkerManager_Restore_Renew:GetShow() then
    return
  end
  self:resetData(isRestoreAll)
  self:setRestoreItemData()
  self:setPanelSize()
  self:setPosition()
  if self._totalItemCount <= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHATNEW_NO_HAVE_ITEM"))
    return
  end
  Panel_Window_WorkerManager_Restore_Renew:SetShow(true)
end
function PaGlobalFunc_WorkerManager_Restore_Open(isRestoreAll)
  workerRestore:open(isRestoreAll)
end
function workerRestore:close()
  if false == Panel_Window_WorkerManager_Restore_Renew:GetShow() then
    return
  end
  Panel_Window_WorkerManager_Restore_Renew:SetShow(false)
end
function PaGlobalFunc_WorkerManager_Restore_Close()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  workerRestore:close()
end
function workerRestore:update()
  self:setRestoreItemData()
  if 0 < self._totalItemCount then
    self:setPanelSize()
    self:setPosition()
    ToClient_padSnapResetPanelControl(Panel_Window_WorkerManager_Restore_Renew)
  end
end
function workerRestore:selectItem(itemIndex)
  local selectItem = ToClient_getNpcRecoveryItemByIndex(itemIndex)
  if nil == selectItem then
    return
  end
  for index = 0, self._config._maxItemCount - 1 do
    local slot = self._ui._restoreItemSlot[index].slotBG
    slot:SetCheck(false)
  end
  self._ui._restoreItemSlot[itemIndex].slotBG:SetCheck(true)
  PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemWrapper, getInventoryItemByType(CppEnums.ItemWhereType.eInventory, selectItem._slotNo), Defines.TooltipTargetType.Item, 0)
  self._selectItemIndex = itemIndex
  if true == self._isRestoreAll then
    local selectWorkerCount
    local totalPoint = 0
    if true == _ContentsGroup_NewUI_WorkerManager_All then
      selectWorkerCount = PaGlobalFunc_WorkerManager_All_GetSelectWorkerCount()
      totalPoint = PaGlobalFunc_WorkerManager_All_GetTotalRestoreCount(itemIndex)
    else
      selectWorkerCount = PaGlobalFunc_WorkerManager_GetSelectWorkerCount()
      totalPoint = PaGlobalFunc_WorkerManager_GetTotalRestoreCount(itemIndex)
    end
    local selectItemCount = Int64toInt32(selectItem._itemCount_s64)
    local selectItemPoint = selectItem._contentsEventParam1
    local totalselectItemPoint = selectItemCount * selectItemPoint
    self._ui._staticText_RestoreWorkerCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERRESTORE_WORKERCOUNT", "count", selectWorkerCount))
    self._ui._staticText_RestroreActionPoint:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERRESTORE_POSSIBLE", "totalPoint", totalPoint))
    if totalPoint <= totalselectItemPoint then
      self._ui._staticText_NeedItem:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORKERRESTORE_CONSUMEITEM", "selectItemCount", tostring(totalPoint / selectItemPoint), "totalPoint", tostring(totalPoint)))
    else
      self._ui._staticText_NeedItem:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORKERRESTORE_CONSUMEITEM", "selectItemCount", tostring(selectItemCount), "totalPoint", tostring(totalselectItemPoint)))
    end
  end
end
function PaGlobalFunc_WorkerManager_Restore_SelectItem(itemIndex)
  workerRestore:selectItem(itemIndex)
end
function workerRestore:restoreConfirm(isRestoreAll)
  local selectedWorker
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    selectedWorker = PaGlobalFunc_WorkerManager_All_GetSelectWorker()
  else
    selectedWorker = PaGlobalFunc_WorkerManager_GetSelectWorker()
  end
  if nil == selectedWorker then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
    self:close()
  end
  local workerNoRaw = tonumber64(selectedWorker)
  local workerWrapperLua = getWorkerWrapper(workerNoRaw)
  local maxPoint = workerWrapperLua:getMaxActionPoint()
  local currentPoint = workerWrapperLua:getActionPoint()
  local restoreActionPoint = maxPoint - currentPoint
  if restoreActionPoint <= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE_MAX"))
  end
  local selectItem = ToClient_getNpcRecoveryItemByIndex(self._selectItemIndex)
  if nil == selectItem then
    return
  end
  local currentItemCount = Int64toInt32(selectItem._itemCount_s64)
  local restorePoint = selectItem._contentsEventParam1
  local slotNo = selectItem._slotNo
  if true == isRestoreAll then
    local itemNeedCount = math.floor(restoreActionPoint / restorePoint)
    if currentItemCount < itemNeedCount then
      itemNeedCount = currentItemCount
    end
    if itemNeedCount >= 1 then
      requestRecoveryWorker(WorkerNo(workerNoRaw), slotNo, itemNeedCount)
    end
    _AudioPostEvent_SystemUiForXBOX(50, 0)
  else
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    requestRecoveryWorker(WorkerNo(workerNoRaw), slotNo, 1)
  end
end
function PaGlobalFunc_WorkerManager_Restore_Confirm(isRestoreAll)
  workerRestore:restoreConfirm(isRestoreAll)
end
function workerRestore:restoreAllConfirm()
  local selectedWorkerList
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    selectedWorkerList = PaGlobalFunc_WorkerManager_All_GetSelectWorkerList()
  else
    selectedWorkerList = PaGlobalFunc_WorkerManager_GetSelectWorkerList()
  end
  if nil == selectedWorkerList then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
    self:close()
  end
  local isRestore = false
  local currentItemCount = recoveryItemCount
  for _, workerNoRaw in pairs(selectedWorkerList) do
    local workerWrapperLua = getWorkerWrapper(workerNoRaw)
    local maxPoint = workerWrapperLua:getMaxActionPoint()
    local currentPoint = workerWrapperLua:getActionPoint()
    local selectItem = ToClient_getNpcRecoveryItemByIndex(self._selectItemIndex)
    if nil == selectItem then
      return
    end
    local currentItemCount = Int64toInt32(selectItem._itemCount_s64)
    local restorePoint = selectItem._contentsEventParam1
    local restoreActionPoint = maxPoint - currentPoint
    local itemNeedCount = math.floor(restoreActionPoint / restorePoint)
    local slotNo = selectItem._slotNo
    if currentItemCount < itemNeedCount then
      itemNeedCount = currentItemCount
    end
    if itemNeedCount >= 1 then
      requestRecoveryWorker(WorkerNo(workerNoRaw), slotNo, itemNeedCount)
      currentItemCount = currentItemCount - itemNeedCount
      isRestore = true
    end
  end
  if false == isRestore then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE_MAX"))
  end
end
function PaGlobalFunc_WorkerManager_RestoreAll_Confirm()
  workerRestore:restoreAllConfirm()
end
function FromClient_WorkerManager_UpdateRestoreItem()
  if false == Panel_Window_WorkerManager_Restore_Renew:GetShow() then
    return
  end
  workerRestore:update()
end
function workerRestore:registEventHandler()
  registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_WorkerManager_Restore")
  registerEvent("FromClient_InventoryUpdate", "FromClient_WorkerManager_UpdateRestoreItem")
end
workerRestore:registEventHandler()

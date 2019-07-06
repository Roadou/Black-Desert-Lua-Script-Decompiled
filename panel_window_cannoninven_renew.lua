local _panel = Panel_Window_Inventory_Cannon
local VEHICLE_TYPE = {
  WHACHA = 1,
  FLAMETOWER = 2,
  CANNON = 3,
  PRACTICE_CANNON = 4
}
local CannonInven = {
  _ui = {
    _stc_InvenCannonBG = UI.getChildControl(_panel, "Static_InvenCannonBG"),
    _stc_InvenPlayerBG = UI.getChildControl(_panel, "Static_InvenPlayerBG"),
    _stc_cannonSlotBGList = {},
    _slot_cannonSlotList = {},
    _stc_playerSlotBGList = {},
    _slot_playerSlotList = {}
  },
  _playerInvenIndexList = {},
  _playerUsingSlotCount = nil,
  _cannonInvenIndexList = {},
  _cannonUsingSlotCount = nil,
  _playerActorKeyRaw = nil,
  _vehicleActorKeyRaw = nil,
  _vehicleActorType = nil,
  _cannonSlotCountMax = 6,
  _playerSlotCountMax = 4,
  _isOnLeftWindow = true,
  _whereTypeToOpen = nil,
  _vehicleData = {
    [VEHICLE_TYPE.WHACHA] = {
      mountKey = CppEnums.VehicleType.Type_ThrowStone,
      ammoItemKey = {56051}
    },
    [VEHICLE_TYPE.FLAMETOWER] = {
      mountKey = CppEnums.VehicleType.Type_ThrowFire,
      ammoItemKey = {56052}
    },
    [VEHICLE_TYPE.CANNON] = {
      mountKey = CppEnums.VehicleType.Type_Cannon,
      ammoItemKey = {
        56003,
        56007,
        56008
      }
    },
    [VEHICLE_TYPE.PRACTICE_CANNON] = {
      mountKey = CppEnums.VehicleType.Type_PracticeCannon,
      ammoItemKey = {56008}
    }
  }
}
function CannonInven:initControl()
  self._ui._txt_cannonTitle = UI.getChildControl(self._ui._stc_InvenCannonBG, "StaticText_Title")
  local originSizeY = self._ui._txt_cannonTitle:GetTextSizeY()
  self._ui._txt_cannonTitle:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txt_cannonTitle:SetText(self._ui._txt_cannonTitle:GetText())
  self._ui._stc_cannonCenterBG = UI.getChildControl(self._ui._stc_InvenCannonBG, "Static_CenterBG")
  self._ui._stc_cannonBottomKeyBG = UI.getChildControl(self._ui._stc_InvenCannonBG, "Static_BottomKeyBG")
  self._ui._txt_cannon_KeyGuideB = UI.getChildControl(self._ui._stc_cannonBottomKeyBG, "StaticText_Cancel_ConsoleUI")
  PaGlobalFunc_ConsoleKeyGuide_SetAlign({
    self._ui._txt_cannon_KeyGuideB
  }, self._ui._stc_cannonBottomKeyBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 10)
  self._ui._stc_cannonSlot = UI.getChildControl(self._ui._stc_cannonCenterBG, "Static_Slot")
  if 1 < self._ui._txt_cannonTitle:GetLineCount() then
    local gapY = self._ui._txt_cannonTitle:GetTextSizeY() - originSizeY
    self._ui._stc_InvenCannonBG:SetSize(self._ui._stc_InvenCannonBG:GetSizeX(), self._ui._stc_InvenCannonBG:GetSizeY() + gapY)
    self._ui._stc_cannonCenterBG:SetPosY(self._ui._stc_cannonCenterBG:GetPosY() + gapY)
    self._ui._stc_cannonBottomKeyBG:ComputePos()
  end
  self._ui._txt_playerTitle = UI.getChildControl(self._ui._stc_InvenPlayerBG, "StaticText_Title")
  self._ui._stc_playerCenterBG = UI.getChildControl(self._ui._stc_InvenPlayerBG, "Static_CenterBG")
  self._ui._stc_playerBottomKeyBG = UI.getChildControl(self._ui._stc_InvenPlayerBG, "Static_BottomKeyBG")
  self._ui._txt_player_KeyGuideA = UI.getChildControl(self._ui._stc_playerBottomKeyBG, "StaticText_Confirm_ConsoleUI")
  self._ui._txt_player_KeyGuideB = UI.getChildControl(self._ui._stc_playerBottomKeyBG, "StaticText_Cancel_ConsoleUI")
  local keyguides = {
    self._ui._txt_player_KeyGuideA,
    self._ui._txt_player_KeyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyguides, self._ui._stc_playerBottomKeyBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 10)
  self._ui._stc_playerSlot = UI.getChildControl(self._ui._stc_playerCenterBG, "Static_Slot")
end
function CannonInven:registEventHandler()
  registerEvent("FromClient_UpdateCannonBallCount", "PaGlobal_CannonInven_UpdateCannonInven")
  registerEvent("FromClient_ServantInventoryUpdate", "PaGlobal_CannonInven_UpdateCannonInven")
end
function CannonInven:initialize()
  self:initControl()
  self:registEventHandler()
  self:createNewSlot()
end
function CannonInven:update()
  self:updatePlayerInven()
  self:updateCannonInven()
end
function CannonInven:setInitialInfo(actorKeyRaw)
  local selfPlayer = getSelfPlayer()
  if selfPlayer == nil then
    return
  end
  self._playerActorKeyRaw = selfPlayer:get():getActorKeyRaw()
  self._whereTypeToOpen = CppEnums.ItemWhereType.eInventory
  self._vehicleActorKeyRaw = actorKeyRaw
  self:setCannonInfo()
  self:update()
end
function PaGlobal_CannonInven_UpdateCannonInven()
  local self = CannonInven
  self:update()
end
function CannonInven:updateCannonInven()
  if nil == self._vehicleActorKeyRaw then
    return
  end
  local vehicleActorWrapper = getVehicleActor(self._vehicleActorKeyRaw)
  if nil == vehicleActorWrapper then
    return
  end
  local vehicleActor = vehicleActorWrapper:get()
  if nil == vehicleActor then
    return
  end
  if nil ~= self._cannonUsingSlotCount then
    for iSlot = 1, self._cannonSlotCountMax do
      self._ui._stc_cannonSlotBGList[iSlot]:SetShow(false)
    end
  end
  local vehicleInven = vehicleActor:getInventory()
  local cannonUsingSlotCount = 0
  self._cannonUsingSlotCount = 0
  local capacity = vehicleInven:size()
  for iSlot = 0, capacity - 1 do
    local itemWrapper = getServantInventoryItemBySlotNo(self._vehicleActorKeyRaw, iSlot)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      if nil ~= itemSSW then
        cannonUsingSlotCount = cannonUsingSlotCount + 1
        local slot = self._ui._slot_cannonSlotList[cannonUsingSlotCount]
        slot:setItem(itemWrapper)
        slot.isEmpty = false
        self._ui._stc_cannonSlotBGList[cannonUsingSlotCount]:SetShow(true)
        self._cannonInvenIndexList[cannonUsingSlotCount] = iSlot
      end
    end
  end
  self._cannonUsingSlotCount = cannonUsingSlotCount
end
function CannonInven:updatePlayerInven()
  local selfPlayer = getSelfPlayer()
  local invenUseSize = selfPlayer:get():getInventorySlotCount(self._whereTypeToOpen)
  local inventory = Inventory_GetCurrentInventory()
  local invenMaxSize = inventory:sizeXXX()
  local vehicleTypeIndex
  for iType = 1, #self._vehicleData do
    if self._vehicleActorType == self._vehicleData[iType].mountKey then
      vehicleTypeIndex = iType
    end
  end
  if nil == vehicleTypeIndex then
    return
  end
  if nil ~= self._playerUsingSlotCount then
    for iSlot = 1, self._playerUsingSlotCount do
      self._ui._slot_playerSlotList[iSlot]:clearItem()
    end
  end
  local cannonballTypeCount = 0
  local invenCapacity = invenUseSize - __eTInventorySlotNoUseStart
  for iSlot = 1, invenCapacity do
    local itemWrapper = getInventoryItemByType(self._whereTypeToOpen, iSlot)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      if nil ~= itemSSW then
        local itemType = itemSSW:get()._key:getItemKey()
        for iUsableType = 1, #self._vehicleData[vehicleTypeIndex].ammoItemKey do
          if itemType == self._vehicleData[vehicleTypeIndex].ammoItemKey[iUsableType] then
            cannonballTypeCount = cannonballTypeCount + 1
            local slot = self._ui._slot_playerSlotList[cannonballTypeCount]
            slot:setItem(itemWrapper)
            slot.isEmpty = false
            self._ui._stc_playerSlotBGList[cannonballTypeCount]:SetShow(true)
            self._playerInvenIndexList[cannonballTypeCount] = iSlot
          end
        end
      end
    end
  end
  self._playerUsingSlotCount = cannonballTypeCount
end
function CannonInven:setCannonInfo()
  local vehicleActorWrapper = getVehicleActor(self._vehicleActorKeyRaw)
  if nil == vehicleActorWrapper then
    return
  end
  local vehicleActor = vehicleActorWrapper:get()
  if nil == vehicleActor then
    return
  end
  self._vehicleActorType = vehicleActor:getVehicleType()
end
function CannonInven:createNewSlot()
  local slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createClassEquipBG = true,
    createCash = true
  }
  for index = 1, self._cannonSlotCountMax do
    self._ui._stc_cannonSlotBGList[index] = UI.cloneControl(self._ui._stc_cannonSlot, self._ui._stc_cannonCenterBG, "Static_CannonSlotBG" .. index)
    local slot = {}
    SlotItem.new(slot, "CannonSlot" .. index, index, self._ui._stc_cannonSlotBGList[index], slotConfig)
    slot:createChild()
    self._ui._slot_cannonSlotList[index] = slot
    posX = self._ui._stc_cannonSlot:GetPosX() + (self._ui._stc_cannonSlot:GetSizeX() + 5) * (index - 1)
    self._ui._stc_cannonSlotBGList[index]:SetPosX(posX)
    self._ui._stc_cannonSlotBGList[index]:SetShow(true)
    self._ui._stc_cannonSlotBGList[index]:addInputEvent("Mouse_On", "PaGlobal_CannonInven_MouseOnLeftSlot(" .. index .. ")")
  end
  for index = 1, self._playerSlotCountMax do
    self._ui._stc_playerSlotBGList[index] = UI.cloneControl(self._ui._stc_playerSlot, self._ui._stc_playerCenterBG, "Static_PlayerSlotBG" .. index)
    local slot = {}
    SlotItem.new(slot, "PlayerSlot" .. index, index, self._ui._stc_playerSlotBGList[index], slotConfig)
    slot:createChild()
    self._ui._slot_playerSlotList[index] = slot
    posX = self._ui._stc_playerSlot:GetPosX() + (self._ui._stc_playerSlot:GetSizeX() + 5) * (index - 1)
    self._ui._stc_playerSlotBGList[index]:SetPosX(posX)
    self._ui._stc_playerSlotBGList[index]:SetShow(true)
    self._ui._stc_playerSlotBGList[index]:addInputEvent("Mouse_On", "PaGlobal_CannonInven_MouseOnRightSlot(" .. index .. ")")
    self._ui._stc_playerSlotBGList[index]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_CannonInven_AddCannonBallNumPadPopUp(" .. index .. ")")
  end
end
function PaGlobal_CannonInven_AddCannonBallNumPadPopUp(index)
  local self = CannonInven
  local slotNo = self._playerInvenIndexList[index]
  local itemWrapper = getInventoryItemByType(self._whereTypeToOpen, slotNo)
  if index > self._playerUsingSlotCount or nil == slotNo or nil == itemWrapper then
    return
  end
  Panel_NumberPad_Show(true, itemWrapper:get():getCount_s64(), slotNo, PaGlobal_CannonInven_AddCannonBall, nil, slotNo)
end
function PaGlobal_CannonInven_RemoveCannonBallNumPadPopUp(index)
  local self = CannonInven
  local slotNo = self._cannonInvenIndexList[index]
  local itemWrapper = getServantInventoryItemBySlotNo(self._vehicleActorKeyRaw, slotNo)
  if index > self._cannonUsingSlotCount or nil == slotNo or nil == itemWrapper then
    return
  end
  Panel_NumberPad_Show(true, itemWrapper:get():getCount_s64(), slotNo, PaGlobal_CannonInven_RemoveCannonBall, nil, slotNo)
end
function PaGlobal_CannonInven_AddCannonBall(count64, slotNo)
  local self = CannonInven
  local vehicleActor = getVehicleActor(self._vehicleActorKeyRaw)
  if nil == vehicleActor then
    return
  end
  local itemWrapper = getInventoryItemByType(self._whereTypeToOpen, slotNo)
  local moveToType = CppEnums.MoveItemToType.Type_Vehicle
  if nil ~= itemWrapper then
    moveInventoryItemFromActorToActor(self._playerActorKeyRaw, self._vehicleActorKeyRaw, moveToType, slotNo, count64)
  end
end
function PaGlobal_CannonInven_RemoveCannonBall(count64, slotNo)
  local self = CannonInven
  local vehicleActor = getVehicleActor(self._vehicleActorKeyRaw)
  if nil == vehicleActor then
    return
  end
  local itemWrapper = getServantInventoryItemBySlotNo(self._vehicleActorKeyRaw, slotNo)
  if nil ~= itemWrapper then
    moveInventoryItemFromActorToActor(self._vehicleActorKeyRaw, self._playerActorKeyRaw, self._whereTypeToOpen, slotNo, count64)
  end
end
function PaGlobal_CannonInven_MouseOnLeftSlot(index)
  local self = CannonInven
  self._isOnLeftWindow = true
  self._ui._stc_cannonBottomKeyBG:SetShow(true)
  self._ui._stc_playerBottomKeyBG:SetShow(false)
  if nil ~= self._cannonInvenIndexList[index] and index <= self._cannonUsingSlotCount then
    local itemWrapper = getServantInventoryItemBySlotNo(self._vehicleActorKeyRaw, self._cannonInvenIndexList[index])
    PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemWrapper, itemWrapper, Defines.TooltipTargetType.NameAndWeight, self._ui._stc_InvenCannonBG)
  end
end
function PaGlobal_CannonInven_MouseOnRightSlot(index)
  local self = CannonInven
  self._isOnLeftWindow = false
  self._ui._stc_cannonBottomKeyBG:SetShow(false)
  self._ui._stc_playerBottomKeyBG:SetShow(true)
  if nil ~= self._playerInvenIndexList[index] and index <= self._playerUsingSlotCount then
    local itemWrapper = getInventoryItemByType(self._whereTypeToOpen, self._playerInvenIndexList[index])
    PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemWrapper, itemWrapper, Defines.TooltipTargetType.NameAndWeight, self._ui._stc_InvenPlayerBG)
  end
end
function CannonInven:open(actorKeyRaw)
  if true == _panel:GetShow() then
    return
  end
  self:setInitialInfo(actorKeyRaw)
  self:update()
  _panel:SetShow(true)
  ToClient_padSnapSetTargetGroup(self._ui._stc_InvenPlayerBG)
end
function CannonInven:close()
  Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  PaGlobalFunc_FloatingTooltip_Close()
  _panel:SetShow(false)
end
function PaGlobalFunc_CannonInven_Open(actorKeyRaw)
  local self = CannonInven
  self:open(actorKeyRaw)
end
function PaGlobalFunc_CannonInven_Close()
  local self = CannonInven
  self:close()
end
function FromClient_luaLoadComplete_CannonInven()
  local self = CannonInven
  self:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_CannonInven")

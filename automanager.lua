AutoStateType = {
  MOVE = 1,
  WAIT_FOR_PRESSBUTTON = 2,
  HUNT = 3,
  DIALOG_INTERACTION = 4,
  DEAD = 5,
  EXCEPTION_GUIDE = 6,
  TUTORIAL = 7
}
PaGlobal_AutoManager = {
  _ActiveState = false,
  _stateUnit = nil,
  _storageStateUnit = {},
  _questNo = -1,
  _updateDelay = 0,
  _updateTime = 3
}
function PaGlobal_AutoManager:init()
  self._storageStateUnit[AutoStateType.MOVE] = AutoState_Move
  self._storageStateUnit[AutoStateType.HUNT] = AutoState_Hunt
  self._storageStateUnit[AutoStateType.WAIT_FOR_PRESSBUTTON] = AutoState_WaitForPressButton
  self._storageStateUnit[AutoStateType.DIALOG_INTERACTION] = AutoState_DialogInteraction
  self._storageStateUnit[AutoStateType.DEAD] = AutoState_Dead
  self._storageStateUnit[AutoStateType.EXCEPTION_GUIDE] = AutoState_ExceptionGuide
  self._storageStateUnit[AutoStateType.TUTORIAL] = AutoState_Tutorial
  for _, v in pairs(self._storageStateUnit) do
    v:init()
  end
  self._ActiveState = false
  self._stateUnit = nil
  self._questNo = -1
end
function PaGlobal_AutoManager:frameMove(deltaTime)
  if false == self._ActiveState then
    return
  end
  if nil == self._stateUnit then
    return
  end
  self._stateUnit:update(deltaTime)
  self._updateDelay = deltaTime + self._updateDelay
  if self._updateTime < self._updateDelay then
    self._updateDelay = 0
    self:checkException()
  end
end
function PaGlobal_AutoManager:start(isTutorialStart)
  if false == ToClient_AutoPlay_UseableAutoPlay() then
    return
  end
  local questList = ToClient_GetQuestList()
  if questList == nil then
    _PA_ASSERT(false, "Quest \236\160\149\235\179\180\234\176\128 nil\236\158\133\235\139\136\235\139\164..AutoState_WaitForPressButton:start")
    return
  end
  PaGlobal_AutoQuestMsg:SetShow(true)
  PaGlobal_AutoQuestMsg._ui._staticBlackSpirit:EraseAllEffect()
  PaGlobal_AutoQuestMsg._ui._staticBlackSpirit:AddEffect("fN_DarkSpirit_Idle_2_AutoQuest", true, -50, -70)
  local uiQuestInfo = questList:getMainQuestInfo()
  if uiQuestInfo == nil then
    FGlobal_AutoQuestBlackSpiritMessage(" \237\152\132\236\158\172\235\161\156\236\132\156\235\138\148 \235\169\148\236\157\184\237\128\152\236\138\164\237\138\184 \235\143\153\236\132\160\236\156\188\235\161\156 \236\152\164\237\134\160\234\176\128 \236\167\132\237\150\137\235\144\156\235\139\164;\235\169\148\236\157\184\237\128\152\236\138\164\237\138\184 \236\151\134\235\139\164\235\169\180 \236\139\156\236\158\145\237\149\160 \236\136\152 \236\151\134\235\139\164;")
    self:stop()
    return
  end
  self:init()
  self._ActiveState = true
  if true == isTutorialStart then
    self._stateUnit = AutoState_Tutorial
  else
    self._stateUnit = AutoState_WaitForPressButton
  end
  self._stateUnit:start()
  local questList = ToClient_GetQuestList()
  local uiQuestInfo = questList:getMainQuestInfo()
  self._questNo = uiQuestInfo:getQuestNo()
  PaGlobal_AutoQuestMsg:AniStop()
  ToClient_AutoPlayerStart()
end
function PaGlobal_AutoManager:stop()
  self._ActiveState = false
  ToClient_changeAutoMode(CppEnums.Client_AutoControlStateType.NONE)
  ToClient_AutoPlayerStop()
  Panel_MainQuest:EraseAllEffect()
  PaGlobal_AutoQuestMsg:SetShow(false)
end
function Auto_FrameMove(deltaTime)
  PaGlobal_AutoManager:frameMove(deltaTime)
end
function PaGlobal_AutoManager:checkException()
  PaGlobal_AutoManager:checkReturnToTown()
  PaGlobal_AutoManager:checkUseToRecoverPosion()
end
function PaGlobal_AutoManager:checkReturnToTown()
  if self._stateUnit._state == AutoStateType.MOVE and AutoState_Move:isReservation() == true then
    return
  end
  local needToReturn = false
  local reserveReason = -1
  if getInventoryFreeCount() < 1 then
    needToReturn = true
    reserveReason = AutoMoveState_Type.TO_TOWN_DUE_FULLINVEN
  elseif 0 < getWeightLevel() then
    needToReturn = true
    reserveReason = AutoMoveState_Type.TO_TOWN_DUE_TOOHEAVY
  end
  if needToReturn == true then
    AutoState_Move:setReserveReason(reserveReason)
    local pos3D = getNearTownRegionPos()
    ToClient_WorldMapNaviStart(pos3D, NavigationGuideParam(), false, true)
    ToClient_NaviReStart()
  end
end
function PaGlobal_AutoManager:checkUseToRecoverPosion()
  local selfPlayer = getSelfPlayer():get()
  local hp = selfPlayer:getHp()
  local maxhp = selfPlayer:getMaxHp()
  if hp / maxhp > 0.5 then
    return
  end
  for i = 0, 19 do
    local quickSlotInfo = getQuickSlotItem(i)
    if quickSlotInfo ~= nil and (CppEnums.QuickSlotType.eItem == quickSlotInfo._type or CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type) then
      local itemKey = quickSlotInfo._itemKey:get()
      for hpIdx = 0, #potionData.hp - 1 do
        if itemKey == potionData.hp[hpIdx] then
          local inventoryType = QuickSlot_GetInventoryTypeFrom(quickSlotInfo._type)
          local inventory = selfPlayer:getInventoryByType(inventoryType)
          local invenSlotNo = inventory:getSlot(quickSlotInfo._itemKey)
          local itemInfoWrapper = getInventoryItemByType(inventoryType, invenSlotNo)
          local itemInfo
          if itemInfoWrapper ~= nil then
            itemInfo = itemInfoWrapper:get()
          end
          if nil ~= itemInfo and itemInfo:getCount_s64() ~= 0 and quickSlot_UseSlot(i) == false then
            FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_DRUG_POTION"))
          end
        end
      end
    end
  end
end
function Auto_TransferState(typeState)
  local self = PaGlobal_AutoManager
  if self._ActiveState == false then
    return
  end
  if nil == self._stateUnit then
    local traceString = debug.traceback()
    traceString = string.gsub(traceString, "d:/output/dev/UI_Data/Script/", "")
    _PA_LOG("\235\176\149\234\183\156\235\130\152", "traceBack:" .. traceString)
    return
  end
  if self._stateUnit._state == typeState then
    return
  end
  self._stateUnit:endProc()
  self._stateUnit = self._storageStateUnit[typeState]
  self._stateUnit:start()
end
function Auto_QuestClearNotify(questNo)
  local self = PaGlobal_AutoManager
  if self._ActiveState and self._questNo == questNo then
    self:stop()
    FGlobal_AutoQuestBlackSpiritMessage("\237\128\152\236\138\164\237\138\184\234\176\128 \236\153\132\235\163\140\235\144\152\236\150\180 \236\152\164\237\134\160 \236\162\133\235\163\140")
  end
end
function Auto_NotifyChangeDialog()
  local self = PaGlobal_AutoManager
  if self._ActiveState and self._stateUnit._state == AutoStateType.DIALOG_INTERACTION then
    AutoState_DialogInteraction:NotifyChangeDialog()
  end
end

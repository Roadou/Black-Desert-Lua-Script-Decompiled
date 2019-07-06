AutoHuntState_Type = {NONE = 0, EXISTNEARMONSTER = 1}
AutoState_Hunt = {
  _state = AutoStateType.HUNT,
  _reserveReason = AutoHuntState_Type.NONE,
  _pressDelay = 0,
  _satisCheckTime = 3
}
function AutoState_Hunt:init()
  self._reserveReason = AutoHuntState_Type.NONE
end
function AutoState_Hunt:start()
  if ToClient_getAutoMode() ~= CppEnums.Client_AutoControlStateType.BATTLE then
    ToClient_changeAutoMode(CppEnums.Client_AutoControlStateType.BATTLE)
  end
  FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_HUNT_START"))
  PaGlobal_AutoQuestMsg:AniStart()
  FGlobal_AutoQuest_KeyViewer_Show()
  PaGlobal_AutoQuestMsg._accessBlackSpiritClick = AutoState_StopHunt_AccessBlackSpiritclick
end
function AutoState_Hunt:update(deltaTime)
  self._pressDelay = self._pressDelay + deltaTime
  if self._pressDelay < self._satisCheckTime then
    return
  end
  self._pressDelay = 0
  FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_HUNT_HUNTING"))
  local questList = ToClient_GetQuestList()
  if questList == nil or true == questList:isMainQuestClearAll() then
    return
  end
  local uiQuestInfo = questList:getMainQuestInfo()
  if nil ~= uiQuestInfo and true == uiQuestInfo:isSatisfied() then
    Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
    return
  end
  if self._reserveReason == AutoHuntState_Type.EXISTNEARMONSTER then
    if ToClient_Auto_CheckExistNearMonster(300) == false then
      FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_HUNT_CHANGESTATE_DUETO_CANTFIND_TARGET"))
      Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
      return
    end
  elseif Auto_FindNearQuestMonster() == false then
    FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_HUNT_CHANGESTATE_DUETO_CANTFIND_TARGET"))
    Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
    return
  end
end
function AutoState_Hunt:endProc()
  ToClient_changeAutoMode(CppEnums.Client_AutoControlStateType.NONE)
  self._reserveReason = AutoHuntState_Type.NONE
  PaGlobal_AutoQuestMsg:AniStop()
  PaGlobal_AutoQuestMsg._ui._staticBlackSpirit:EraseAllEffect()
  PaGlobal_AutoQuestMsg._ui._staticBlackSpirit:AddEffect("fN_DarkSpirit_Idle_2_AutoQuest", true, -50, -70)
  FGlobal_AutoQuest_KeyViewer_Hide()
end
function AutoState_Hunt:setReserveReason(reason)
  self._reserveReason = reason
end
function AutoState_StopHunt_AccessBlackSpiritclick()
  Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
end

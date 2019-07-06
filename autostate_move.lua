AutoMoveState_Type = {
  NONE = 0,
  TO_NPC_FOR_START_QUEST = 1,
  TO_NPC_FOR_FINISH_QUEST = 2,
  SANDWICHED = 3,
  TO_TOWN_DUE_FULLINVEN = 4,
  TO_TOWN_DUE_TOOHEAVY = 5
}
AutoState_Move = {
  _state = AutoStateType.MOVE,
  _moveflag = AutoMoveState_Type.None,
  _reserveReason = AutoMoveState_Type.None,
  _pressDelay = 0,
  _pressDelay_forHalfSecond = 0,
  _printTime = 3,
  _exceptionGuideStart = false,
  _exceptionGuideString = nil
}
function AutoState_Move:init()
  self._moveflag = AutoMoveState_Type.None
  self._reserveReason = AutoMoveState_Type.None
end
function AutoState_Move:start()
  self._moveflag = self._reserveReason
  if self._moveflag == AutoMoveState_Type.TO_TOWN_DUE_FULLINVEN or self._moveflag == AutoMoveState_Type.TO_TOWN_DUE_TOOHEAVY then
    self._pressDelay = self._printTime
  end
  self._pressDelay_forHalfSecond = 0
  local questList = ToClient_GetQuestList()
  local uiQuestInfo = questList:getMainQuestInfo()
  self._exceptionGuideStart = AutoState_ExceptionGuide:checkException(uiQuestInfo:getQuestNo()._group, uiQuestInfo:getQuestNo()._quest)
  if true == self._exceptionGuideStart then
    self._exceptionGuideString = PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_EXCEPTIONGUIDE_" .. tostring(uiQuestInfo:getQuestNo()._group) .. "_" .. tostring(uiQuestInfo:getQuestNo()._quest) .. "_1")
  end
end
function AutoState_Move:update(deltaTime)
  self._pressDelay = self._pressDelay + deltaTime
  if self._printTime < self._pressDelay then
    self._pressDelay = 0
    if self._moveflag == AutoMoveState_Type.TO_TOWN_DUE_FULLINVEN then
      FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_MOVE_DUETO_FULLINVEN"))
    elseif self._moveflag == AutoMoveState_Type.TO_TOWN_DUE_TOOHEAVY then
      FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_MOVE_DUETO_TOOHEAVY"))
    elseif true == self._exceptionGuideStart then
      FGlobal_AutoQuestBlackSpiritMessage(self._exceptionGuideString)
    else
      FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_MOVE_MOVING"))
    end
  end
  local navi = ToClient_currentNaviisMainQuest()
  if navi == false then
    _PA_LOG("\234\185\128\234\183\156\235\179\180", "(navi == false)")
    FromClient_Auto_EndNaviMove()
    return
  end
  if getSelfPlayer():isNavigationMoving() == false then
    Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
    return
  end
  self._pressDelay_forHalfSecond = self._pressDelay_forHalfSecond + deltaTime
  if self._pressDelay_forHalfSecond > 0.5 then
    self._pressDelay_forHalfSecond = 0
    local length = ToClient_getPhysicalSpeedforFIndway()
    if length < 35 then
      self._moveflag = AutoMoveState_Type.SANDWICHED
      if ToClient_pushStuckPostion() then
        if ToClient_Auto_IsClimbAble() == true then
        elseif ToClient_Auto_CheckExistNearMonster(300) == true then
          ToClient_changeAutoMode(CppEnums.Client_AutoControlStateType.BATTLE)
          FromClient_Auto_NotifyChangetoBattle_dueMobBlockWay()
        else
          ToClient_changeAutoMode(CppEnums.Client_AutoControlStateType.FINDWAY)
        end
        _PA_LOG("\234\185\128\234\183\156\235\179\180", "length < 35      NaviEndPosDist: " .. tostring(ToClient_getNaviEndPointDist()))
        return
      end
    end
  end
end
function AutoState_Move:endProc()
  self._reserveReason = AutoMoveState_Type.None
  ToClient_StopNavi()
  ToClient_changeAutoMode(CppEnums.Client_AutoControlStateType.NONE)
  PaGlobal_AutoQuestMsg._ui._staticBlackSpirit:EraseAllEffect()
  PaGlobal_AutoQuestMsg._ui._staticBlackSpirit:AddEffect("fN_DarkSpirit_Idle_2_AutoQuest", true, -50, -70)
end
function AutoState_Move:setReserveReason(reason)
  self._reserveReason = reason
end
function AutoState_Move:isReservation()
  if self._reserveReason == AutoMoveState_Type.TO_TOWN_DUE_FULLINVEN or self._reserveReason == AutoMoveState_Type.TO_TOWN_DUE_TOOHEAVY then
    return true
  end
  return false
end

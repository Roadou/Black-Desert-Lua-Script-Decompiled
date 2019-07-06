local enStatus = {
  CALL = 0,
  RIDE = 1,
  RUN = 2,
  END = 3
}
local HorseRiding = {
  _preTick = 0,
  _isStartHorseRiding = false,
  _nowStatus = enStatus.CALL,
  _oldStatus = enStatus.CALL,
  _isWaitingForStart = false
}
function FromClient_StartReconnectFishing()
  ToClient_StartFishingReconnect()
end
function FromClient_StartReconnectAutoLevelUp()
  ToClient_AutoLevelUpReconnect()
end
function FromClient_StartReconnectAtion()
  HorseRiding._isStartHorseRiding = true
  HorseRiding._nowStatus = enStatus.CALL
end
function ReconnectAction_HorseCall()
  Servant_Call(0)
end
function ReconnectAction_HorseRide()
  interaction_processInteraction(CppEnums.InteractionType.InteractionType_Ride)
end
function ReconnectAction_HorseGoToStart()
  HorseRiding._isWaitingForStart = true
  ToClient_GotoStartPosForReconnect(NavigationGuideParam())
end
function FromClient_ReconnectHorseRun()
  if false == HorseRiding._isWaitingForStart then
    return
  end
  HorseRiding._isWaitingForStart = false
  ToClient_SettingLoopNavi(NavigationGuideParam())
  ToClient_NaviReStart()
  FGlobal_ToggleServantAutoCarrot()
end
registerEvent("FromClient_StartReconnectAtion", "FromClient_StartReconnectAtion")
registerEvent("FromClient_ReconnectHorseRun", "FromClient_ReconnectHorseRun")
registerEvent("FromClient_StartReconnectFishing", "FromClient_StartReconnectFishing")
registerEvent("FromClient_StartReconnectAutoLevelUp", "FromClient_StartReconnectAutoLevelUp")
function Update_ReconnectHorse()
  if false == HorseRiding._isStartHorseRiding then
    return
  end
  if false == FrameControl_FiveSecond() or false == IsSelfPlayerWaitAction() then
    return
  end
  local self = HorseRiding
  if enStatus.CALL == self._nowStatus then
    ReconnectAction_HorseCall()
    self._nowStatus = enStatus.RIDE
  elseif enStatus.RIDE == self._nowStatus then
    ReconnectAction_HorseRide()
    self._nowStatus = enStatus.RUN
  elseif enStatus.RUN == self._nowStatus then
    ReconnectAction_HorseGoToStart()
    self._nowStatus = enStatus.END
  elseif enStatus.END == self._nowStatus then
    FromClient_ReconnectHorseRun()
    self._isStartHorseRiding = false
  end
end
function FrameControl_FiveSecond()
  local self = HorseRiding
  local nowTick = os.time()
  if 0 == self._preTick then
    self._preTick = nowTick
    return false
  end
  if nowTick - self._preTick < 5 then
    return false
  end
  self._preTick = nowTick
  return true
end
registerEvent("FromClient_ReconnectAlert_Show", "FromClient_ReconnectAlert_Show")
registerEvent("FromClient_ReconnectAlert_Hide", "FromClient_ReconnectAlert_Hide")
function FromClient_ReconnectAlert_Show()
  local messageBoxtitle = PAGetString(Defines.StringSheet_GAME, "GUILD_MESSAGEBOX_TITLE")
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_AUTO_RECONNECT")
  local messageBoxData = {
    title = messageBoxtitle,
    content = messageBoxMemo,
    functionYes = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_HIGH
  }
  Proc_ShowMessage_Ack(messageBoxMemo)
end
function FromClient_ReconnectAlert_Hide()
  postProcessMessageData()
end

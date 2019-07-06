local enTimeValue = {
  Second = 1,
  RunningTime = 6,
  StandingTime = 24,
  StandingTime_Half = 12
}
local enCameraValue = {
  UpdateCameraYaw = 0.015,
  SetCameraPich_Low = -0.2,
  SetCameraPich_High = 0.35,
  ForLogAngle = 0.1,
  GoalArea = 200,
  BreakArea = 50
}
local AutoFrameCheckManager = {
  _isOn = false,
  _isRpeat = false,
  _nowRepeatCount = 0,
  _maxRepeatCount = 0,
  _minFrame = 25,
  _prevTick = 0,
  _cameraYaw = 0,
  _cameraPitch = 0,
  _isStop = true,
  _index = 0,
  _maxIndex = 0,
  _PositionList = {},
  _oldPositionX = 0,
  _oldPositionY = 0,
  _oldPositionZ = 0,
  _logPositionX = 0,
  _logPositionY = 0,
  _logPositionZ = 0,
  _logCameraYaw = 0,
  _accumulateFrame = 0,
  _accumulateCount = 0,
  _isCaptured = false
}
function setStandingTime(value)
  enTimeValue.StandingTime = value
  enTimeValue.StandingTime_Half = value / 2
end
function setRunningTime(value)
  enTimeValue.RunningTime = value
end
function setUpdateCameraYaw(value)
  enCameraValue.UpdateCameraYaw = value
end
function AutoFrameCheckManager:FrameCheck()
  local nowFrame = ToClient_getFPS()
  self._accumulateFrame = self._accumulateFrame + nowFrame
  self._accumulateCount = self._accumulateCount + 1
  if nowFrame < AutoFrameCheckManager._minFrame then
    local selfPlayer = getSelfPlayer()
    local nowPositionX = selfPlayer:get():getPositionX()
    local nowPositionY = selfPlayer:get():getPositionY()
    local nowPositionZ = selfPlayer:get():getPositionZ()
    if self._logPositionX == nowPositionX and self._logPositionY == nowPositionY and self._logPositionZ == nowPositionY then
      return
    end
    local fixedYaw = math.abs(self._logCameraYaw - self._cameraYaw)
    if fixedYaw < enCameraValue.ForLogAngle then
      return
    end
    local TargetPosition = self._PositionList[self._index]
    self._logPositionX = nowPositionX
    self._logPositionY = nowPositionY
    self._logPositionZ = nowPositionZ
    self._logCameraYaw = self._cameraYaw
    local logString = string.format("NowCycle[%d] FrameLow[%d] Position[%f/%f/%f] CameraYaw[%f] avgFrame[%d]", self._nowRepeatCount + 1, nowFrame, nowPositionX, nowPositionY, nowPositionZ, self._cameraYaw, self._accumulateFrame / self._accumulateCount)
    local logString2 = string.format("TargetPosition[%f/%f/%f] (%s)", TargetPosition._goalX, TargetPosition._goalY, TargetPosition._goalZ, TargetPosition._where)
    local screenShotString = string.format("_Position(%f/%f/%f)", nowPositionX, nowPositionY, nowPositionZ)
    _PA_SVC_LOG(logString)
    _PA_SVC_LOG(logString2)
    if false == self._isCaptured then
      ToClient_CaptureByFrameCheck()
      self._isCaptured = true
    end
  end
end
function AutoFrameCheckManager:isArriveGoalbyPosition(X, Y, Z)
  local selfPlayer = getSelfPlayer()
  local nowPositionX = selfPlayer:get():getPositionX()
  local nowPositionY = selfPlayer:get():getPositionY()
  local nowPositionZ = selfPlayer:get():getPositionZ()
  local fixedPositionX = math.abs(X - nowPositionX)
  local fixedPositionY = math.abs(Y - nowPositionY)
  local fixedPositionZ = math.abs(Z - nowPositionZ)
  if fixedPositionX < enCameraValue.GoalArea and fixedPositionY < enCameraValue.GoalArea and fixedPositionZ < enCameraValue.GoalArea then
    return true
  end
  return false
end
function AutoFrameCheckManager:RunningStop()
  local selfPlayer = getSelfPlayer()
  local nowPositionX = selfPlayer:get():getPositionX()
  local nowPositionY = selfPlayer:get():getPositionY()
  local nowPositionZ = selfPlayer:get():getPositionZ()
  local position = float3(nowPositionX, nowPositionY, nowPositionZ)
  ToClient_WorldMapNaviStart(position, NavigationGuideParam(), true, true)
end
function AutoFrameCheckManager:AutoFrameCheck()
  if self._maxIndex <= 0 then
    return
  end
  local nowTick = os.time()
  local deltaTick = nowTick - self._prevTick
  if deltaTick < enTimeValue.Second then
    return
  end
  local X = self._PositionList[self._index]._goalX
  local Y = self._PositionList[self._index]._goalY
  local Z = self._PositionList[self._index]._goalZ
  local NowWhere = self._PositionList[self._index]._where
  local selfPlayer = getSelfPlayer()
  if true == self:isArriveGoalbyPosition(X, Y, Z) then
    ToClient_StopNavi()
    self._index = self._index + 1
    if self._maxIndex <= self._index then
      if true == self._isRpeat then
        self._index = 0
        self._nowRepeatCount = self._nowRepeatCount + 1
        if self._maxRepeatCount <= self._nowRepeatCount and 0 ~= self._maxRepeatCount then
          OffFrameCheck()
          return
        end
      else
        OffFrameCheck()
        return
      end
    end
    local X1 = self._PositionList[self._index]._goalX
    local Y1 = self._PositionList[self._index]._goalY
    local Z1 = self._PositionList[self._index]._goalZ
    local Position = float3(X1, Y1, Z1)
    ToClient_WorldMapNaviStart(Position, NavigationGuideParam(), false, true)
    self._isStop = true
    self._prevTick = os.time()
    return
  end
  if true == self._isStop and deltaTick > enTimeValue.StandingTime then
    self._isStop = false
    local position = float3(X, Y, Z)
    ToClient_NaviReStart()
    selfPlayerSetCameraPich(-0.4)
    self._prevTick = os.time()
    return
  end
  if true == self._isStop and deltaTick < enTimeValue.StandingTime then
    if not IsSelfPlayerWaitAction() then
      ToClient_StopNavi()
      return
    end
    self:FrameCheck()
    self._cameraYaw = self._cameraYaw + enCameraValue.UpdateCameraYaw
    selfPlayerSetCameraYaw(self._cameraYaw)
    if deltaTick < enTimeValue.StandingTime_Half then
      self._cameraPitch = enCameraValue.SetCameraPich_High
    else
      self._cameraPitch = enCameraValue.SetCameraPich_Low
    end
    selfPlayerSetCameraPich(self._cameraPitch)
    return
  end
  if false == self._isStop and deltaTick > enTimeValue.RunningTime then
    self._isStop = true
    self._cameraYaw = 0
    self._cameraPitch = 0
    self._cameraRoll = 0
    self._prevTick = os.time()
    self._isCaptured = false
    ToClient_StopNavi()
    return
  end
end
function AutoFrameCheckManager_UpdatePerFrame()
  if false == AutoFrameCheckManager._isOn then
    return
  end
  AutoFrameCheckManager:AutoFrameCheck()
end
function FGlobal_AutoFrameCheck_setMinFrame(frame)
  AutoFrameCheckManager._minFrame = frame
end
function FGlobal_AutoFrameCheck_addPositionList(X, Y, Z, strWhere)
  local nowIndex = AutoFrameCheckManager._maxIndex
  local tempString = ""
  if nil ~= strWhere then
    tempString = strWhere
  end
  AutoFrameCheckManager._maxIndex = AutoFrameCheckManager._maxIndex + 1
  AutoFrameCheckManager._PositionList[nowIndex] = {
    _goalX = X,
    _goalY = Y,
    _goalZ = Z,
    _where = tempString
  }
end
function FGlobal_AutoFrameCheck_resetPositionList()
  FGlobal_AutoFrameCheck_Stop()
  AutoFrameCheckManager._index = 0
  AutoFrameCheckManager._maxIndex = 0
  AutoFrameCheckManager._prevTick = 0
  AutoFrameCheckManager._PositionList = {}
end
function FGlobal_AutoFrameCheck_Start()
  AutoFrameCheckManager._index = 0
  AutoFrameCheckManager._nowRepeatCount = 0
  AutoFrameCheckManager._prevTick = 0
  AutoFrameCheckManager._isCaptured = false
  AutoFrameCheckManager._accumulateCount = 0
  AutoFrameCheckManager._accumulateFrame = 0
  local X = AutoFrameCheckManager._PositionList[AutoFrameCheckManager._index]._goalX
  local Y = AutoFrameCheckManager._PositionList[AutoFrameCheckManager._index]._goalY
  local Z = AutoFrameCheckManager._PositionList[AutoFrameCheckManager._index]._goalZ
  local Position = float3(X, Y, Z)
  ToClient_WorldMapNaviStart(Position, NavigationGuideParam(), false, true)
  _PA_SVC_LOG("############################ AutoFrameCheck Start!! ####################################")
  AutoFrameCheckManager._isOn = true
end
function FGlobal_AutoFrameCheck_Stop()
  AutoFrameCheckManager._isOn = false
end
function FGlobal_setAutoFrameCheckRepeat(value)
  if value < 0 then
    _PA_SVC_LOG("FGlobal_setAutoFrameCheckRepeat \237\149\168\236\136\152\236\151\144 0 \236\157\180\237\149\152 \234\176\146\236\157\180 \235\147\164\236\150\180\236\152\164\235\169\180 \236\149\136\235\144\169\235\139\136\235\139\164!!!")
  end
  if 0 == value then
    AutoFrameCheckManager._isRpeat = true
    AutoFrameCheckManager._maxRepeatCount = value
  else
    AutoFrameCheckManager._isRpeat = true
    AutoFrameCheckManager._maxRepeatCount = value
  end
end
function OnFrameCheck()
  AutoFrameCheckManager._isOn = true
end
function OffFrameCheck()
  AutoFrameCheckManager._isOn = false
  _PA_SVC_LOG("############################ AutoFrameCheck End!! ####################################")
end
function testAutoQuestStart()
  setRunningTime(8)
  setStandingTime(2)
  FGlobal_setAutoFrameCheckRepeat(0)
  FGlobal_AutoFrameCheck_setMinFrame(80)
  FGlobal_AutoFrameCheck_addPositionList(-309323.09375, 13343.671875, -370570.78125)
  FGlobal_AutoFrameCheck_addPositionList(-306090.40625, 13897.889648, -366944.25)
  FGlobal_AutoFrameCheck_addPositionList(-289764.21875, 16052.167969, -363110.46875)
  FGlobal_AutoFrameCheck_Start()
end
function testAutoQuestEnd()
  FGlobal_AutoFrameCheck_resetPositionList()
end
function setYaw(value)
  selfPlayerSetCameraYaw(value)
end
function ToClient_StopNavi()
  ToClient_NaviMoveStop(true)
end
function ToClient_ReStartNavi()
  ToClient_NaviReStart()
end
function CCAP()
  ToClient_CaptureByFrameCheck()
end

PaGlobal_TutorialPhase_BasicControl = {
  _phaseNo = 2,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 1,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = true,
  _regionKeyRawList = {9},
  _startLimitLevel = 15,
  _state = 0
}
function PaGlobal_TutorialPhase_BasicControl:setState(isStart)
  self._state = isStart
end
function PaGlobal_TutorialPhase_BasicControl:getState()
  return self._state
end
function PaGlobal_TutorialPhase_BasicControl:checkPossibleForPhaseStart(stepNo)
  if false == self._isPhaseOpen then
    _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "\237\138\156\237\134\160\235\166\172\236\150\188 Phase\234\176\128 \235\139\171\237\152\128\236\158\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "\237\138\156\237\134\160\235\166\172\236\150\188 \236\139\156\236\158\145 \234\176\128\235\138\165 \236\151\172\235\182\128 \234\178\128\236\130\172\236\164\145\236\151\144 selfPlayer\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164! _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local currentRegionKeyRaw = selfPlayer:getRegionKeyRaw()
  local isPossiblePhaseRegion = false
  for index, value in pairs(self._regionKeyRawList) do
    if value == currentRegionKeyRaw then
      isPossiblePhaseRegion = true
      break
    end
  end
  if false == isPossiblePhaseRegion then
    _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "\237\138\156\237\134\160\235\166\172\236\150\188\236\157\180 \234\176\128\235\138\165\237\149\156 \236\167\128\236\151\173\236\157\180 \236\149\132\235\139\136\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\164\237\150\137\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  if self._startLimitLevel < getSelfPlayer():get():getLevel() then
    _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "\236\186\144\235\166\173\237\132\176\236\157\152 \235\160\136\235\178\168\236\157\180 " .. tostring(self._startLimitLevel) .. "\235\165\188 \236\180\136\234\179\188\237\150\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\167\132\237\150\137\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_BasicControl:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_BasicControl:startPhase(stepNo)
  if false == self:checkPossibleForPhaseStart(stepNo) then
    return
  end
  local isSkippable = self:checkSkippablePhase()
  if true == isSkippable and false == PaGlobal_TutorialManager:isDoingTutorial() then
    PaGlobal_TutorialManager:questionPhaseSkip(self, stepNo)
  else
    self:startPhaseXXX(stepNo)
  end
end
function PaGlobal_TutorialPhase_BasicControl:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "PaGlobal_TutorialPhase_BasicControl:startPhase()")
  self._currentStep = 1
  self._nextStep = stepNo
  self._currentProgress = 1
  self._updateTime = 0
  ToClient_DeleteNaviGuideByGroup()
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:repositionScreen()
  self:setState(PaGlobal_TutorialState.eState_Start)
  Panel_Tutorial_Renew:SetShow(true, true)
end
function PaGlobal_TutorialPhase_BasicControl:endPhase()
  self._currentStep = 0
  self._nextStep = 1
  PaGlobal_TutorialUiBlackSpirit:showRotateArrow(false)
  PaGlobal_TutorialManager:startNextPhase()
  _PA_LOG("\236\157\180\235\139\164\237\152\156", "PaGlobal_TutorialPhase_BasicControl:endPhase()")
end
function PaGlobal_TutorialPhase_BasicControl:updatePerFrame(deltaTime)
  self:handleStep(deltaTime)
end
local currentInputMode
function PaGlobal_TutorialPhase_BasicControl:handleStep(deltaTime)
  if 1 == self._currentStep then
    self:Step01_LookAround(deltaTime)
  else
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_BasicControl:Step01_LookAround(deltaTime)
  local currentState = self:getState()
  if PaGlobal_TutorialState.eState_Start == currentState then
    self:Step01_Prepare()
  elseif PaGlobal_TutorialState.eState_Do == currentState then
    self:Step01_DoStep(deltaTime)
  elseif PaGlobal_TutorialState.eState_Done == currentState then
    self:Step01_Done()
  end
end
function PaGlobal_TutorialPhase_BasicControl:Step01_Prepare()
  local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIALXB_TEXT_8")
  PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
  PaGlobal_TutorialUiManager:getUiGuideButton():showRotateArrow(true)
  self:setState(PaGlobal_TutorialState.eState_Do)
end
function PaGlobal_TutorialPhase_BasicControl:Step01_DoStep(deltaTime)
  self._updateTime = self._updateTime + deltaTime
  if 1 == self._currentProgress and 8 * timeRatio < self._updateTime then
    self:setState(PaGlobal_TutorialState.eState_Done)
  end
end
function PaGlobal_TutorialPhase_BasicControl:Step01_Done()
  self._updateTime = 0
  self._currentProgress = 1
  self._currentStep = self._currentStep + 1
  PaGlobal_TutorialUiManager:getUiGuideButton():showCtrlGuide(false)
  self:setState(PaGlobal_TutorialState.eState_Start)
end

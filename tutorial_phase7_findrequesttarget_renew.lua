PaGlobal_TutorialPhase_FindRequestTarget = {
  _phaseNo = 7,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 1,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = true,
  _regionKeyRawList = {9},
  _startLimitLevel = 15
}
function PaGlobal_TutorialPhase_FindRequestTarget:checkPossibleForPhaseStart(stepNo)
  if false == self._isPhaseOpen then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 Phase\234\176\128 \235\139\171\237\152\128\236\158\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 \236\139\156\236\158\145 \234\176\128\235\138\165 \236\151\172\235\182\128 \234\178\128\236\130\172\236\164\145\236\151\144 selfPlayer\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164! _phaseNo : " .. tostring(self._phaseNo))
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
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188\236\157\180 \234\176\128\235\138\165\237\149\156 \236\167\128\236\151\173\236\157\180 \236\149\132\235\139\136\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\164\237\150\137\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  if self._startLimitLevel < getSelfPlayer():get():getLevel() then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\236\186\144\235\166\173\237\132\176\236\157\152 \235\160\136\235\178\168\236\157\180 " .. tostring(self._startLimitLevel) .. "\235\165\188 \236\180\136\234\179\188\237\150\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\167\132\237\150\137\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_FindRequestTarget:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_FindRequestTarget:startPhase(stepNo)
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
function PaGlobal_TutorialPhase_FindRequestTarget:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_FindRequestTarget:startStep() stepNo : " .. tostring(stepNo))
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  self._updateTime = 0
  classType = getSelfPlayer():getClassType()
  PaGlobal_TutorialManager:setAllowShowQuickSlot(true)
  PaGlobal_TutorialManager:setAllowNewQuickSlot(false)
  PaGlobal_TutorialManager:setAllowMainQuestWidget(false)
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialUiManager:setShowAllDefaultUi(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  Panel_SkillCommand:SetShow(true, true)
  PaGlobal_TutorialUiManager:repositionScreen()
  Panel_Tutorial_Renew:SetShow(true, true)
end
function PaGlobal_TutorialPhase_FindRequestTarget:endPhase()
  self._currentStep = 0
  self._nextStep = 1
  PaGlobal_TutorialManager:setAllowMainQuestWidget(true)
  Panel_MainQuest:SetShow(true, true)
  PaGlobal_TutorialManager:endTutorial()
  PaGlobal_TutorialUiManager:setShowAllDefaultUi(true)
end
local result = false
function PaGlobal_TutorialPhase_FindRequestTarget:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
  if 1 == self._currentStep then
    result = self:updateStepOpenQuestWindow(deltaTime)
  end
  if true == result then
    result = false
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:handleChangeStep(currentStep)
  if 1 == self._currentStep then
    self:changeStepOpenQuestWindow()
  elseif self._currentStep >= 2 then
    self:changeStepSuggestCallBlackSpirit()
  end
end
local isNeedToCheckUpdateTime = true
function PaGlobal_TutorialPhase_FindRequestTarget:changeStepOpenQuestWindow()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("", PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_76") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIALXB_TEXT_12"))
    end)
  elseif 2 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("", PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_78") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIALXB_TEXT_13"))
    end)
  elseif 3 == self._currentProgress then
    isNeedToCheckUpdateTime = true
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("", PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_82") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_83"))
    end)
  elseif 4 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("", PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_84") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIALXB_TEXT_14"))
    end)
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:updateStepOpenQuestWindow(deltaTime)
  if 3 == self._currentProgress and true == isNeedToCheckUpdateTime then
    if 4 < self._updateTime then
      self._updateTime = 0
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setShowAll(false)
      isNeedToCheckUpdateTime = false
    end
    self._updateTime = self._updateTime + deltaTime
  elseif 4 == self._currentProgress then
    if 4 < self._updateTime then
      self._updateTime = 0
      return true
    end
    self._updateTime = self._updateTime + deltaTime
  end
  return false
end
function PaGlobal_TutorialPhase_FindRequestTarget:eventCallShowQuestNewWindow(isShow)
  if true == isShow then
    if 1 == self._currentProgress then
      audioPostEvent_SystemUi(4, 12)
      _AudioPostEvent_SystemUiForXBOX(4, 12)
      self._currentProgress = self._currentProgress + 1
      self:handleChangeStep(self._currentStep)
    end
  elseif false == isShow and 2 == self._currentProgress then
    audioPostEvent_SystemUi(4, 12)
    _AudioPostEvent_SystemUiForXBOX(4, 12)
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:eventCallRadarMouseOn()
end
local isSatisfiedCondition = false
function PaGlobal_TutorialPhase_FindRequestTarget:eventCallCheckQuestCondition()
  if self._currentProgress <= 4 and false == isSatisfiedCondition then
    self._currentProgress = 4
    local isSatisfy = PaGlobal_TutorialManager:isSatisfiedQuestCondition(self._questData[1]._questGroupNo, self._questData[1]._questId)
    if true == isSatisfy then
      isSatisfiedCondition = true
      audioPostEvent_SystemUi(4, 12)
      self._currentProgress = 1
      self._nextStep = self._nextStep + 1
    end
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:changeStepSuggestCallBlackSpirit()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiManager:getUiBlackSpirit():showSuggestCallSpiritUi()
  end
end
local isClearQuest = false
function PaGlobal_TutorialPhase_FindRequestTarget:eventCallClearBlackSpiritQuest(isAccept, questGroupNo, questId)
  if (1 == self._currentProgress or true == isSatisfiedCondition) and questGroupNo == self._questData[1]._questGroupNo and questId == self._questData[1]._questId then
    isClearQuest = true
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:eventCallAfterBlackSpiritDialogClose()
  if 1 == self._currentProgress or true == isSatisfiedCondition or true == isClearQuest then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:handleEventQuestUpdateNotify(isAccept, questNoRaw)
  local questGroupNo = PaGlobal_TutorialManager:getQuestGroupNoByQuestNoRaw(questNoRaw)
  local questId = PaGlobal_TutorialManager:getQuestIdByQuestNoRaw(questNoRaw)
  if 1 ~= self._currentStep or true == isAccept then
  end
  if self._currentStep >= 2 and false == isAccept then
    self:eventCallClearBlackSpiritQuest(isAccept, questGroupNo, questId)
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:handleAfterAndPopFlush()
  if true == isSatisfiedCondition then
    self:eventCallAfterBlackSpiritDialogClose()
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:handleShowQuestNewWindow(isShow)
  if 1 == self._currentStep then
    self:eventCallShowQuestNewWindow(isShow)
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:handleRadarMouseOn()
end
function PaGlobal_TutorialPhase_FindRequestTarget:handleQuestWidgetUpdate()
  self:eventCallCheckQuestCondition()
end

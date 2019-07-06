PaGlobal_TutorialPhase_AncientStoneChamber = {
  _phaseNo = 9,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 1,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = false,
  _startLimitLevel = 15,
  _questData = {
    [1] = {_questGroupNo = 653, _questId = 7}
  },
  _regionKeyRawList = {
    [1] = 137
  }
}
function PaGlobal_TutorialPhase_AncientStoneChamber:checkPossibleForPhaseStart(stepNo)
  do return false end
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
function PaGlobal_TutorialPhase_AncientStoneChamber:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_AncientStoneChamber:startPhase(stepNo)
  if false == self:checkPossibleForPhaseStart(stepNo) then
    return
  end
  if true == PaGlobal_SummonBossTutorial_Manager:isDoingSummonBossTutorial() then
    PaGlobal_SummonBossTutorial_Manager:endTutorial()
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 phase(" .. tostring(self._phaseNo) .. ")\234\176\128 \235\179\180\236\138\164 \236\134\140\237\153\152 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\162\133\235\163\140\236\139\156\237\130\180! _phaseNo : " .. tostring(self._phaseNo))
  end
  local isSkippable = self:checkSkippablePhase()
  if true == isSkippable and false == PaGlobal_TutorialManager:isDoingTutorial() then
    PaGlobal_TutorialManager:questionPhaseSkip(self, stepNo)
  else
    self:startPhaseXXX(stepNo)
  end
end
function PaGlobal_TutorialPhase_AncientStoneChamber:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_AncientStoneChamber:startStep() stepNo : " .. tostring(stepNo) .. " typeNo : " .. tostring(typeNo))
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  self._updateTime = 0
  classType = getSelfPlayer():getClassType()
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
  PaGlobal_TutorialManager:setAllowShowQuickSlot(true)
  PaGlobal_TutorialManager:setAllowNewQuickSlot(true)
  PaGlobal_TutorialUiManager:getUiKeyButton():setShowAll(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:repositionScreen()
  Panel_Tutorial:SetShow(true, true)
  self:eventCallStep1QuestWidgetUpdate()
  self:updatePerFrame(0)
end
function PaGlobal_TutorialPhase_AncientStoneChamber:endPhase()
  self._currentStep = 0
  self._nextStep = 1
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialManager:endTutorial()
end
local result = false
function PaGlobal_TutorialPhase_AncientStoneChamber:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
  if 1 == self._currentStep then
    result = self:updateStepInteractionStatue(deltaTime)
  end
  if true == result then
    result = false
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_AncientStoneChamber:handleChangeStep(currentStep)
  if 1 == self._currentStep then
    self:changeStepInteractionStatue()
  elseif 2 == self._currentStep then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_AncientStoneChamber:changeStepInteractionStatue()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_17"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_18"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  elseif 2 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_19"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_20"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  elseif 3 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_21"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_22"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
      PaGlobal_TutorialUiManager:getUiBlackSpirit():addBubbleKey("_bubbleKey_R")
    end)
  elseif 4 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_23"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_24"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
      PaGlobal_TutorialUiManager:getUiBlackSpirit():addBubbleKey("_bubbleKey_R")
    end)
  elseif 5 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_25"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_26"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
      PaGlobal_TutorialUiManager:getUiBlackSpirit():addBubbleKey("_bubbleKey_R")
    end)
  end
end
function PaGlobal_TutorialPhase_AncientStoneChamber:updateStepInteractionStatue(deltaTime)
  if self._currentProgress <= 3 then
    if 2.5 < self._updateTime then
      self._updateTime = 0
      self._currentProgress = self._currentProgress + 1
      self:handleChangeStep(self._currentStep)
    end
    self._updateTime = self._updateTime + deltaTime
  end
  return false
end
function PaGlobal_TutorialPhase_AncientStoneChamber:eventCallStep1QuestWidgetUpdate()
  local isSatisfy = PaGlobal_TutorialManager:isSatisfiedQuestCondition(self._questData[1]._questGroupNo, self._questData[1]._questId)
  if true == isSatisfy then
    self._currentProgress = 5
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_AncientStoneChamber:eventCallClearQuest(isAccept, questGroupNo, questId)
  if questGroupNo == self._questData[1]._questGroupNo and questId == self._questData[1]._questId then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_AncientStoneChamber:handleRegionChanged(regionInfo)
  local regionKeyRaw = regionInfo:getRegionKey()
  if -1 == regionKeyRaw then
    self:endPhase()
  end
  local isPossibleTutorialRegion = false
  for index, value in pairs(self._regionKeyRawList) do
    if value == regionKeyRaw then
      isPossibleTutorialRegion = true
      break
    end
  end
  if false == isPossibleTutorialRegion then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_AncientStoneChamber:handleQuestWidgetUpdate()
  if 1 == self._currentStep then
    self:eventCallStep1QuestWidgetUpdate()
  end
end
function PaGlobal_TutorialPhase_AncientStoneChamber:handleEventQuestUpdateNotify(isAccept, questNoRaw)
  local questGroupNo = PaGlobal_TutorialManager:getQuestGroupNoByQuestNoRaw(questNoRaw)
  local questId = PaGlobal_TutorialManager:getQuestIdByQuestNoRaw(questNoRaw)
  if 1 == self._currentStep and false == isAccept then
    self:eventCallClearQuest(isAccept, questGroupNo, questId)
  end
end

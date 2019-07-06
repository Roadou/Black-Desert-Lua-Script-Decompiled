PaGlobal_TutorialPhase_WesternGuardCamp = {
  _phaseNo = 8,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 1,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = true,
  _startLimitLevel = 15,
  _questData = {
    [1] = {_questGroupNo = 653, _questId = 5},
    [2] = {_questGroupNo = 1001, _questId = 71}
  },
  _regionKeyRawList = {
    [1] = 9,
    [2] = 10
  }
}
local uiQuestIconGuideImage = UI.getChildControl(Panel_Tutorial, "Static_QuestImage")
local function setQuestIconGuideImage(posX, posY)
  local uiQuestIconGuideImageSizeX = uiQuestIconGuideImage:GetSizeX()
  local uiQuestIconGuideImageSizeY = uiQuestIconGuideImage:GetSizeY()
  uiQuestIconGuideImage:SetPosX(posX - uiQuestIconGuideImageSizeX * 0.5)
  uiQuestIconGuideImage:SetPosY(posY - uiQuestIconGuideImageSizeY * 0.5)
end
function PaGlobal_TutorialPhase_WesternGuardCamp:checkPossibleForPhaseStart(stepNo)
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
function PaGlobal_TutorialPhase_WesternGuardCamp:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_WesternGuardCamp:startPhase(stepNo)
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
function PaGlobal_TutorialPhase_WesternGuardCamp:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_WesternGuardCamp:startStep() stepNo : " .. tostring(stepNo) .. " typeNo : " .. tostring(typeNo))
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
end
function PaGlobal_TutorialPhase_WesternGuardCamp:endPhase()
  self._currentProgress = 1
  self._currentStep = 0
  self._nextStep = 1
  if true == uiQuestIconGuideImage:GetShow() then
    uiQuestIconGuideImage:SetIgnore(true)
    local aniInfo = UIAni.AlphaAnimation(0, uiQuestIconGuideImage, 0, 0.25)
    aniInfo:SetHideAtEnd(true)
    PaGlobal_TutorialUiMasking:hideQuestMasking()
  end
  Panel_CheckedQuest:EraseAllEffect()
  PaGlobal_CheckedQuest:eraseEffectQuestNaviButtonForTutorial()
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialManager:endTutorial()
end
local result = false
function PaGlobal_TutorialPhase_WesternGuardCamp:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
  if 1 == self._currentStep then
    result = self:updateStepMeetTargetNpc(deltaTime)
  end
  if true == result then
    result = false
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:handleChangeStep(currentStep)
  if 1 == self._currentStep then
    self:changeStepMeetTargetNpc()
  elseif 2 == self._currentStep then
    self:changeStepTryAutoNaviButton()
  elseif 3 == self._currentStep then
    self:changeStepMeetCompleteNpc()
  end
end
local isAcceptQuest = false
function PaGlobal_TutorialPhase_WesternGuardCamp:changeStepMeetTargetNpc()
  if 1 == self._currentProgress then
    isAcceptQuest = false
    ToClient_DeleteNaviGuideByGroup()
    setQuestIconGuideImage(getScreenSizeX() * 0.5, getScreenSizeY() * 0.5)
    uiQuestIconGuideImage:SetAlpha(0.5)
    uiQuestIconGuideImage:SetShow(true)
    PaGlobal_TutorialUiMasking:showSpiritMasking()
    UIAni.AlphaAnimation(1, uiQuestIconGuideImage, 0, 1.5)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_01") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_02"), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 330)
    end)
    uiQuestIconGuideImage:addInputEvent("Mouse_LUp", "PaGlobal_TutorialPhase_WesternGuardCamp:handleMouseLUp_QuestIconGuideImage()")
    uiQuestIconGuideImage:SetIgnore(true)
  elseif 2 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_03") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_04"), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 330)
    end)
  elseif 3 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_05"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_06"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 330)
    end)
    uiQuestIconGuideImage:SetIgnore(false)
  elseif 4 == self._currentProgress then
    PaGlobal_TutorialUiMasking:hideQuestMasking()
    uiQuestIconGuideImage:SetIgnore(true)
    local navigationGuideParam = NavigationGuideParam()
    ToClient_DeleteNaviGuideByGroup()
    worldmapNavigatorStart(float3(-65010.1, -4053.25, 43990.1), navigationGuideParam, false, false, true)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_07"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_08"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:updateStepMeetTargetNpc(deltaTime)
  if self._currentProgress < 3 then
    if 2.5 * timeRatio < self._updateTime then
      self._updateTime = 0
      self._currentProgress = self._currentProgress + 1
      self:handleChangeStep(self._currentStep)
    end
    self._updateTime = self._updateTime + deltaTime
  end
  return false
end
function PaGlobal_TutorialPhase_WesternGuardCamp:eventCallAcceptStep1Quest(isAccept, questGroupNo, questId)
  if questGroupNo == self._questData[2]._questGroupNo and questId == self._questData[2]._questId then
    isAcceptQuest = true
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:eventCallAfterStep1DialogClose()
  if true == isAcceptQuest then
    isAcceptQuest = false
    self._currentProgress = 1
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:addEffectQuestFindNaviButtonForTutorial(questGroupNo, questId)
  local questUiInfoInPanelCheckedQuest = PaGlobal_CheckedQuest:findShownQuestUiInCheckedQuest(questGroupNo, questId)
  if nil ~= questUiInfoInPanelCheckedQuest then
    PaGlobal_CheckedQuest:addEffectQuestFindNaviButtonForTutorial(questUiInfoInPanelCheckedQuest)
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:changeStepTryAutoNaviButton()
  if 1 == self._currentProgress then
    uiQuestIconGuideImage:SetShow(false)
    if false == Panel_CheckedQuest:GetShow() then
      Panel_CheckedQuest:SetShow(true, true)
    end
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_09"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_10"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
    Panel_CheckedQuest:AddEffect("UI_Tutorial_MouseMove", true, 140, -115)
  elseif 2 == self._currentProgress then
    self:addEffectQuestFindNaviButtonForTutorial(self._questData[2]._questGroupNo, self._questData[2]._questId)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_11"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_12"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  elseif 3 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_27"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_28"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:eventCallQuestWidgetMouseOver(show)
  if 1 == self._currentProgress and true == show then
    Panel_CheckedQuest:EraseAllEffect()
    audioPostEvent_SystemUi(4, 12)
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:eventCallClickQuestWidgetFindTarget(questGroupNo, questId, condition, isAuto)
  if questGroupNo == self._questData[2]._questGroupNo and questId == self._questData[2]._questId then
    audioPostEvent_SystemUi(4, 12)
    PaGlobal_CheckedQuest:eraseEffectQuestNaviButtonForTutorial()
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\234\184\184\236\176\190\234\184\176 \235\178\132\237\138\188 \237\129\180\235\166\173 questGroupNo : " .. tostring(questGroupNo) .. " / questId : " .. tostring(questId) .. " / condition : " .. tostring(condition) .. " / isAuto : " .. tostring(isAuto))
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:eventCallStep2QuestWidgetUpdate()
  local isSatisfy = PaGlobal_TutorialManager:isSatisfiedQuestCondition(self._questData[2]._questGroupNo, self._questData[2]._questId)
  if true == isSatisfy then
    audioPostEvent_SystemUi(4, 12)
    Panel_CheckedQuest:EraseAllEffect()
    PaGlobal_CheckedQuest:eraseEffectQuestNaviButtonForTutorial()
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:eventCallStep2QuestWidgetScrollEvent(isDown)
  if 2 == self._currentProgress then
    PaGlobal_CheckedQuest:eraseEffectQuestNaviButtonForTutorial()
    self:addEffectQuestFindNaviButtonForTutorial(self._questData[2]._questGroupNo, self._questData[2]._questId)
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:changeStepMeetCompleteNpc()
  PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_15"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_16"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
  end)
end
function PaGlobal_TutorialPhase_WesternGuardCamp:eventCallClearStep3Quest(isAccept, questGroupNo, questId)
  if questGroupNo == self._questData[2]._questGroupNo and questId == self._questData[2]._questId then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:handleRegionChanged(regionInfo)
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
function PaGlobal_TutorialPhase_WesternGuardCamp:handleEventQuestUpdateNotify(isAccept, questNoRaw)
  local questGroupNo = PaGlobal_TutorialManager:getQuestGroupNoByQuestNoRaw(questNoRaw)
  local questId = PaGlobal_TutorialManager:getQuestIdByQuestNoRaw(questNoRaw)
  if 1 == self._currentStep and true == isAccept then
    self:eventCallAcceptStep1Quest(isAccept, questGroupNo, questId)
  elseif 3 == self._currentStep and false == isAccept then
    self:eventCallClearStep3Quest(isAccept, questGroupNo, questId)
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:handleAfterAndPopFlush()
  if 1 == self._currentStep then
    self:eventCallAfterStep1DialogClose()
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:handleQuestWidgetMouseOver(show)
  if 2 == self._currentStep then
    self:eventCallQuestWidgetMouseOver(show)
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:handleClickedQuestWidgetFindTarget(questGroupNo, questId, condition, isAuto)
  if 2 == self._currentStep then
    self:eventCallClickQuestWidgetFindTarget(questGroupNo, questId, condition, isAuto)
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:handleQuestWidgetUpdate()
  if 2 == self._currentStep then
    self:eventCallStep2QuestWidgetUpdate()
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:handleQuestWidgetScrollEvent(isDown)
  if 2 == self._currentStep then
    self:eventCallStep2QuestWidgetScrollEvent(isDown)
  end
end
function PaGlobal_TutorialPhase_WesternGuardCamp:handleMouseLUp_QuestIconGuideImage()
  audioPostEvent_SystemUi(4, 12)
  uiQuestIconGuideImage:SetIgnore(true)
  local aniInfo = UIAni.AlphaAnimation(0, uiQuestIconGuideImage, 0, 0.25)
  aniInfo:SetHideAtEnd(true)
  PaGlobal_TutorialUiMasking:hideQuestMasking()
  self._currentProgress = self._currentProgress + 1
  self:handleChangeStep(self._currentStep)
end

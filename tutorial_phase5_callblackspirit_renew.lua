PaGlobal_TutorialPhase_CallBlackSpirit = {
  _phaseNo = 5,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 1,
  _isPhaseOpen = true,
  _isSkippable = true,
  _regionKeyRawList = {9},
  _startLimitLevel = 15,
  _questData = {
    [1] = {_questGroupNo = 21001, _questId = 1},
    [2] = {_questGroupNo = 21001, _questId = 2}
  },
  _posData = {
    [1] = float3(-60165.2, -3857.59, 47040.2),
    [2] = float3(-65848.13, -3927.43, 46123.3)
  },
  _NpcKeyData = {
    [1] = 40751,
    [2] = 40036
  },
  _lastSpiritUiData = {
    _posX = 0,
    _posY = 0,
    _isLeftSideBubble = false,
    _stringBlack = nil,
    _stringYellow = nil
  }
}
local classType
local isAcceptedQuest = false
local isClearQuest = false
function PaGlobal_TutorialPhase_CallBlackSpirit:checkPossibleForPhaseStart(stepNo)
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
function PaGlobal_TutorialPhase_CallBlackSpirit:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_CallBlackSpirit:startPhase(stepNo)
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
function PaGlobal_TutorialPhase_CallBlackSpirit:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_CallBlackSpirit:startPhase()")
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  classType = getSelfPlayer():getClassType()
  Panel_ConsoleKeyGuide:SetShow(false)
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:setShowAllDefaultUi(false)
  PaGlobal_TutorialUiManager:repositionScreen()
  Panel_Tutorial_Renew:SetShow(true, true)
end
function PaGlobal_TutorialPhase_CallBlackSpirit:endPhase()
  self._currentStep = 0
  self._nextStep = 1
  PaGlobal_TutorialManager:startNextPhase()
end
local result
function PaGlobal_TutorialPhase_CallBlackSpirit:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
  if 2 == self._currentStep or 3 == self._currentStep then
    self:showSuggestInteraction(self:updateCheckInteraction())
  end
end
local currentInteractableActor, isMatchCharacterKey
function PaGlobal_TutorialPhase_CallBlackSpirit:updateCheckInteraction()
  currentInteractableActor = interaction_getInteractable()
  isMatchCharacterKey = false
  if nil ~= currentInteractableActor then
    if 2 == self._currentStep then
      isMatchCharacterKey = self._NpcKeyData[1] == currentInteractableActor:getCharacterKeyRaw()
    elseif 3 == self._currentStep then
      isMatchCharacterKey = self._NpcKeyData[2] == currentInteractableActor:getCharacterKeyRaw()
    end
  end
  return isMatchCharacterKey
end
function PaGlobal_TutorialPhase_CallBlackSpirit:showSuggestInteraction(isInteractable)
  if false == isInteractable then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("", self._lastSpiritUiData._stringBlack .. " " .. self._lastSpiritUiData._stringYellow)
    end)
  elseif true == isInteractable then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("", PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIALXB_TEXT_9") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIALXB_TEXT_10"))
    end)
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:handleChangeStep(currentStep)
  if 1 == currentStep then
    self:changeStepSuggestCallBlackSpirit()
  elseif 2 == currentStep then
    PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
    self:changeStepFollowQuest()
  elseif 3 == currentStep then
    self:changeStepFindSkillInstructor()
  elseif 4 == currentStep then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:changeStepSuggestCallBlackSpirit()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiManager:getUiBlackSpirit():showSuggestCallSpiritUi()
    PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallAddEffectRequestButton(dialogData)
  if false == isAcceptedQuest then
    local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
    FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
    FGlobal_AddEffect_DialogButton(funcButtonIndex, "UI_ArrowMark02", true, 0, -90)
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallAcceptBlackSpiritQuest(isAccept, questGroupNo, questId)
  if 1 == self._currentProgress and questGroupNo == self._questData[1]._questGroupNo and questId == self._questData[1]._questId then
    isAcceptedQuest = true
    local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
    FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
    FGlobal_EraseAllEffect_ExitButton()
    FGlobal_AddEffect_ExitButton("UI_ArrowMark02", true, 0, -90)
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallAfterBlackSpiritDialogClose()
  if 1 == self._currentProgress and true == isAcceptedQuest then
    isAcceptedQuest = false
    FGlobal_EraseAllEffect_ExitButton()
    self._currentProgress = 1
    self._nextStep = self._nextStep + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:changeStepFollowQuest()
  if 1 == self._currentProgress then
    self._lastSpiritUiData._stringBlack = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_74")
    self._lastSpiritUiData._stringYellow = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_75")
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("", PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_74") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_75"))
    end)
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallClearBlackSpiritQuest(isAccept, questGroupNo, questId)
  if self._currentProgress <= 2 then
    self._currentProgress = 2
    Panel_CheckedQuest:EraseAllEffect()
    if questGroupNo == self._questData[1]._questGroupNo and questId == self._questData[1]._questId then
      isClearQuest = true
      local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
      FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
      FGlobal_EraseAllEffect_ExitButton()
      FGlobal_AddEffect_ExitButton("UI_ArrowMark02", true, 0, -90)
    end
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallAcceptFindSkillInstructorQuest(isAccept, questGroupNo, questId)
  if self._currentProgress <= 2 then
    self._currentProgress = 2
    Panel_CheckedQuest:EraseAllEffect()
    if questGroupNo == self._questData[2]._questGroupNo and questId == self._questData[2]._questId then
      isClearQuest = true
      isAcceptedQuest = true
      local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
      FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
      FGlobal_EraseAllEffect_ExitButton()
      FGlobal_AddEffect_ExitButton("UI_ArrowMark02", true, 0, -90)
    end
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallAfterNpcDialogClose()
  if 2 == self._currentProgress and true == isClearQuest and true == isAcceptedQuest then
    isClearQuest = false
    isAcceptedQuest = false
    FGlobal_EraseAllEffect_ExitButton()
    self._currentProgress = 1
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:changeStepFindSkillInstructor()
  if 1 == self._currentProgress then
    isAcceptedQuest = false
    self._lastSpiritUiData._stringBlack = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_6")
    self._lastSpiritUiData._stringYellow = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIALXB_TEXT_11")
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("", self._lastSpiritUiData._stringBlack .. " " .. self._lastSpiritUiData._stringYellow)
    end)
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallClearFindSkillInstructorQuest(isAccept, questGroupNo, questId)
  if 1 == self._currentProgress and questGroupNo == self._questData[2]._questGroupNo and questId == self._questData[2]._questId then
    isClearQuest = true
    local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
    FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
    FGlobal_EraseAllEffect_ExitButton()
    FGlobal_AddEffect_ExitButton("UI_ArrowMark02", true, 0, -90)
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallAfterSkillInstructorDialogClose()
  if 1 == self._currentProgress and true == isClearQuest then
    isClearQuest = false
    isAcceptedQuest = false
    FGlobal_EraseAllEffect_ExitButton()
    self._currentProgress = 1
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:handleEventQuestUpdateNotify(isAccept, questNoRaw)
  local questGroupNo = PaGlobal_TutorialManager:getQuestGroupNoByQuestNoRaw(questNoRaw)
  local questId = PaGlobal_TutorialManager:getQuestIdByQuestNoRaw(questNoRaw)
  if 1 == self._currentStep and true == isAccept then
    self:eventCallAcceptBlackSpiritQuest(isAccept, questGroupNo, questId)
  elseif 2 == self._currentStep and true == isAccept then
    self:eventCallAcceptFindSkillInstructorQuest(isAccept, questGroupNo, questId)
  elseif 3 == self._currentStep and false == isAccept then
    self:eventCallClearFindSkillInstructorQuest(isAccept, questGroupNo, questId)
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:handleAfterAndPopFlush()
  if 1 == self._currentStep then
    self:eventCallAfterBlackSpiritDialogClose()
  elseif 2 == self._currentStep then
    self:eventCallAfterNpcDialogClose()
  elseif 3 == self._currentStep then
    self:eventCallAfterSkillInstructorDialogClose()
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:handleShowDialog(dialogData)
  if 1 == self._currentStep or 2 == self._currentStep then
    self:eventCallAddEffectRequestButton(dialogData)
  end
end

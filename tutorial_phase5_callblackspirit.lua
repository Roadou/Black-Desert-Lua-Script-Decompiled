PaGlobal_TutorialPhase_CallBlackSpirit = {
  _phaseNo = 5,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 1,
  _isPhaseOpen = true,
  _isSkippable = true,
  _regionKeyRawList = {88, 349},
  _startLimitLevel = 15,
  _questData = {
    [1] = {_questGroupNo = 650, _questId = 1},
    [2] = {_questGroupNo = 650, _questId = 2}
  },
  _posData = {
    [1] = float3(-140042, 1181.99, 117240.02),
    [2] = float3(-140212, 1157.95, 114325)
  },
  _NpcKeyData = {
    [1] = 40720,
    [2] = 40603
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
function PaGlobal_TutorialPhase_CallBlackSpirit:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_CallBlackSpirit:startPhase()")
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  classType = getSelfPlayer():getClassType()
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
  PaGlobal_TutorialManager:setAllowShowQuickSlot(true)
  PaGlobal_TutorialManager:setAllowNewQuickSlot(false)
  PaGlobal_TutorialManager:setAllowMainQuestWidget(false)
  PaGlobal_TutorialUiManager:setShowAllDefaultUi(false)
  PaGlobal_TutorialUiManager:getUiKeyButton():setShowAll(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  FGlobal_Panel_Radar_Show(true)
  Panel_TimeBar:SetShow(true)
  if false == _ContentsGroup_RenewUI then
    GameTips_Show()
    GameTips_Reposition()
  end
  FGlobal_NewQuickSlot_Update()
  QuickSlot_UpdateData()
  local remasterUIOption = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eSwapRemasterUISetting)
  if true == remasterUIOption then
    Panel_MainStatus_Remaster:SetShow(true)
  else
    Panel_MainStatus_User_Bar:SetShow(true, false)
  end
  FGlobal_ClassResource_SetShowControl(true)
  Panel_UIMain:SetShow(not _ContentsGroup_RenewUI_Main, true)
  Panel_MainQuest:SetShow(true, true)
  if 1 ~= stepNo then
    Panel_CheckedQuest:SetShow(true, false)
  end
  PaGlobal_TutorialUiManager:repositionScreen()
  Panel_Tutorial:SetShow(true, true)
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
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(self._lastSpiritUiData._stringBlack, self._lastSpiritUiData._stringYellow, self._lastSpiritUiData._isLeftSideBubble, self._lastSpiritUiData._posX, self._lastSpiritUiData._posY)
    end)
  elseif true == isInteractable then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_21"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_22"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
      PaGlobal_TutorialUiManager:getUiBlackSpirit():addBubbleKey("_bubbleKey_R")
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
    if false == _ContentsGroup_NewUI_Dialog_All then
      local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
      FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
      FGlobal_AddEffect_DialogButton(funcButtonIndex, "UI_ArrowMark02", true, 0, -50)
    else
      local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
    end
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallAcceptBlackSpiritQuest(isAccept, questGroupNo, questId)
  if 1 == self._currentProgress and questGroupNo == self._questData[1]._questGroupNo and questId == self._questData[1]._questId then
    isAcceptedQuest = true
    if false == _ContentsGroup_NewUI_Dialog_All then
      local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
      FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
      FGlobal_EraseAllEffect_ExitButton()
      FGlobal_AddEffect_ExitButton("UI_ArrowMark02", true, 0, -50)
    else
      local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
    end
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallAfterBlackSpiritDialogClose()
  if 1 == self._currentProgress and true == isAcceptedQuest then
    isAcceptedQuest = false
    if false == _ContentsGroup_NewUI_Dialog_All then
      FGlobal_EraseAllEffect_ExitButton()
    end
    self._currentProgress = 1
    self._nextStep = self._nextStep + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:changeStepFollowQuest()
  if 1 == self._currentProgress then
    isAcceptedQuest = false
    PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
    Panel_CheckedQuest:SetShow(false)
    Panel_CheckedQuest:SetShow(true, true)
    self._lastSpiritUiData._stringBlack = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_72")
    self._lastSpiritUiData._stringYellow = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_73")
    self._lastSpiritUiData._isLeftSideBubble = false
    self._lastSpiritUiData._posX = Panel_CheckedQuest:GetPosX()
    self._lastSpiritUiData._posY = Panel_CheckedQuest:GetPosY() + Panel_CheckedQuest:GetPosY() * 0.25
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(self._lastSpiritUiData._stringBlack, self._lastSpiritUiData._stringYellow, self._lastSpiritUiData._isLeftSideBubble, self._lastSpiritUiData._posX, self._lastSpiritUiData._posY)
    end)
    Panel_CheckedQuest:AddEffect("UI_Tutorial_MouseMove", true, 140, -115)
  elseif 2 == self._currentProgress then
    self._lastSpiritUiData._stringBlack = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_74")
    self._lastSpiritUiData._stringYellow = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_75")
    self._lastSpiritUiData._isLeftSideBubble = false
    self._lastSpiritUiData._posX = Panel_CheckedQuest:GetPosX()
    self._lastSpiritUiData._posY = Panel_CheckedQuest:GetPosY() + Panel_CheckedQuest:GetPosY() * 0.25
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(self._lastSpiritUiData._stringBlack, self._lastSpiritUiData._stringYellow, self._lastSpiritUiData._isLeftSideBubble, self._lastSpiritUiData._posX, self._lastSpiritUiData._posY)
    end)
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallQuestWidgetMouseOver(show)
  if 1 == self._currentProgress and true == show then
    Panel_CheckedQuest:EraseAllEffect()
    audioPostEvent_SystemUi(4, 12)
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallClearBlackSpiritQuest(isAccept, questGroupNo, questId)
  if self._currentProgress <= 2 then
    self._currentProgress = 2
    Panel_CheckedQuest:EraseAllEffect()
    if questGroupNo == self._questData[1]._questGroupNo and questId == self._questData[1]._questId then
      isClearQuest = true
      if false == _ContentsGroup_NewUI_Dialog_All then
        local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
        FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
        FGlobal_EraseAllEffect_ExitButton()
        FGlobal_AddEffect_ExitButton("UI_ArrowMark02", true, 0, -50)
      else
        local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
      end
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
      if false == _ContentsGroup_NewUI_Dialog_All then
        FGlobal_EraseAllEffect_ExitButton()
        FGlobal_AddEffect_ExitButton("UI_ArrowMark02", true, 0, -50)
      end
    end
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallAfterNpcDialogClose()
  if 2 == self._currentProgress and true == isClearQuest and true == isAcceptedQuest then
    isClearQuest = false
    isAcceptedQuest = false
    if false == _ContentsGroup_NewUI_Dialog_All then
      FGlobal_EraseAllEffect_ExitButton()
    end
    self._currentProgress = 1
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:changeStepFindSkillInstructor()
  if 1 == self._currentProgress then
    isAcceptedQuest = false
    FGlobal_Panel_LowLevelGuide_MovePlay_FindWay()
    self._lastSpiritUiData._stringBlack = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_6")
    self._lastSpiritUiData._stringYellow = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_7")
    self._lastSpiritUiData._isLeftSideBubble = false
    self._lastSpiritUiData._posX = getScreenSizeX() * 0.5 + 150
    self._lastSpiritUiData._posY = getScreenSizeY() * 0.5 - 200
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(self._lastSpiritUiData._stringBlack, self._lastSpiritUiData._stringYellow, self._lastSpiritUiData._isLeftSideBubble, self._lastSpiritUiData._posX, self._lastSpiritUiData._posY)
    end)
    if true == _ContentsGroup_NewUI_DailyStamp_All then
      PaGlobalFunc_DailyStamp_All_Open()
    else
      FGlobal_DailyStamp_ShowCheck()
    end
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallClearFindSkillInstructorQuest(isAccept, questGroupNo, questId)
  if 1 == self._currentProgress and questGroupNo == self._questData[2]._questGroupNo and questId == self._questData[2]._questId then
    isClearQuest = true
    if false == _ContentsGroup_NewUI_Dialog_All then
      local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
      FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
      FGlobal_EraseAllEffect_ExitButton()
      FGlobal_AddEffect_ExitButton("UI_ArrowMark02", true, 0, -50)
    else
      local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
    end
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:eventCallAfterSkillInstructorDialogClose()
  if 1 == self._currentProgress and true == isClearQuest then
    Panel_SelfPlayerExpGage_SetShow(true, true)
    isClearQuest = false
    isAcceptedQuest = false
    if false == _ContentsGroup_NewUI_Dialog_All then
      FGlobal_EraseAllEffect_ExitButton()
    end
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
function PaGlobal_TutorialPhase_CallBlackSpirit:handleQuestWidgetMouseOver(show)
  if 2 == self._currentStep then
    self:eventCallQuestWidgetMouseOver(show)
  end
end
function PaGlobal_TutorialPhase_CallBlackSpirit:handleShowDialog(dialogData)
  if 1 == self._currentStep or 2 == self._currentStep then
    self:eventCallAddEffectRequestButton(dialogData)
  end
end

PaGlobal_TutorialPhase_FindRequestTarget = {
  _phaseNo = 7,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 1,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = true,
  _regionKeyRawList = {88, 349},
  _startLimitLevel = 15,
  _questData = {
    [1] = {_questGroupNo = 650, _questId = 3}
  }
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
function PaGlobal_TutorialPhase_FindRequestTarget:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_FindRequestTarget:startStep() typeNo : " .. tostring(typeNo))
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  self._updateTime = 0
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
  if true == _ContentsGroup_RenewUI_Main then
    Panel_SkillCommand:SetShow(true, true)
  end
  FGlobal_NewQuickSlot_Update()
  QuickSlot_UpdateData()
  Panel_UIMain:SetShow(not _ContentsGroup_RenewUI_Main, true)
  Panel_SelfPlayerExpGage_SetShow(true, false)
  local remasterUIOption = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eSwapRemasterUISetting)
  if true == remasterUIOption then
    Panel_MainStatus_Remaster:SetShow(true)
  else
    Panel_MainStatus_User_Bar:SetShow(true, false)
  end
  FGlobal_Panel_MainStatus_User_Bar_Show()
  FGlobal_ClassResource_SetShowControl(true)
  Panel_CheckedQuest:SetShow(true, false)
  Panel_MainQuest:SetShow(true, true)
  PaGlobal_TutorialUiManager:repositionScreen()
  Panel_Tutorial:SetShow(true, true)
end
function PaGlobal_TutorialPhase_FindRequestTarget:endPhase()
  self._currentStep = 0
  self._nextStep = 1
  PaGlobal_TutorialManager:setAllowMainQuestWidget(true)
  Panel_MainQuest:SetShow(true, true)
  PaGlobal_TutorialManager:endTutorial()
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
  elseif 2 == self._currentStep then
    self:changeStepSuggestCallBlackSpirit()
  end
end
local isNeedToCheckUpdateTime = true
function PaGlobal_TutorialPhase_FindRequestTarget:changeStepOpenQuestWindow()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_76"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_77"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  elseif 2 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_78"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_79"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  elseif 3 == self._currentProgress then
    FGlobal_Panel_Radar_Show_AddEffect()
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_80"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_81"), false, FGlobal_Panel_Radar_GetPosX() - 300, FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY())
    end)
  elseif 4 == self._currentProgress then
    isNeedToCheckUpdateTime = true
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_82"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_83"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  elseif 5 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_84"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_85"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:updateStepOpenQuestWindow(deltaTime)
  if 4 == self._currentProgress and true == isNeedToCheckUpdateTime then
    if 4 < self._updateTime then
      self._updateTime = 0
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setShowAll(false)
      isNeedToCheckUpdateTime = false
    end
    self._updateTime = self._updateTime + deltaTime
  elseif 5 == self._currentProgress then
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
      self._currentProgress = self._currentProgress + 1
      self:handleChangeStep(self._currentStep)
    end
  elseif false == isShow and 2 == self._currentProgress then
    audioPostEvent_SystemUi(4, 12)
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:eventCallRadarMouseOn()
  if 3 == self._currentProgress then
    audioPostEvent_SystemUi(4, 12)
    FGlobal_Panel_Radar_Show_AddEffect()
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
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
    isSatisfiedCondition = false
    PaGlobal_TutorialUiManager:getUiBlackSpirit():showSuggestCallSpiritUi()
    PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  end
end
local isClearQuest = false
function PaGlobal_TutorialPhase_FindRequestTarget:eventCallClearBlackSpiritQuest(isAccept, questGroupNo, questId)
  if 1 == self._currentProgress and questGroupNo == self._questData[1]._questGroupNo and questId == self._questData[1]._questId then
    isClearQuest = true
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:eventCallAfterBlackSpiritDialogClose()
  if 1 == self._currentProgress and true == isClearQuest then
    isClearQuest = false
    PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:handleEventQuestUpdateNotify(isAccept, questNoRaw)
  local questGroupNo = PaGlobal_TutorialManager:getQuestGroupNoByQuestNoRaw(questNoRaw)
  local questId = PaGlobal_TutorialManager:getQuestIdByQuestNoRaw(questNoRaw)
  if 1 ~= self._currentStep or true == isAccept then
  end
  if 2 == self._currentStep and false == isAccept then
    self:eventCallClearBlackSpiritQuest(isAccept, questGroupNo, questId)
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:handleAfterAndPopFlush()
  if 2 == self._currentStep then
    self:eventCallAfterBlackSpiritDialogClose()
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:handleShowQuestNewWindow(isShow)
  if 1 == self._currentStep then
    self:eventCallShowQuestNewWindow(isShow)
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:handleRadarMouseOn()
  if 1 == self._currentStep then
    self:eventCallRadarMouseOn()
  end
end
function PaGlobal_TutorialPhase_FindRequestTarget:handleQuestWidgetUpdate()
  if 1 == self._currentStep then
    self:eventCallCheckQuestCondition()
  end
end

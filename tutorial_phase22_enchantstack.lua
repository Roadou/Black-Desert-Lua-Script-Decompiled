PaGlobal_TutorialPhase_EnchantStack = {
  _phaseNo = 22,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 0,
  _prevProgress = 1,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = false,
  _talkerCharacterKeyData = {
    [1] = 0
  },
  _questData = {
    [1] = {_questGroupNo = 653, _questId = 6}
  },
  _equipSlotIcon = nil,
  _materialSlotIcon = nil
}
function PaGlobal_TutorialPhase_EnchantStack:checkPossibleForPhaseStart(stepNo)
  if false == self._isPhaseOpen then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 Phase\234\176\128 \235\139\171\237\152\128\236\158\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() or true == PaGlobal_ArousalTutorial_Manager:isDoingArousalTutorial() or true == PaGlobal_SummonBossTutorial_Manager:isDoingSummonBossTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
    return false
  end
  if false == questList_isClearQuest(self._questData[1]._questGroupNo, self._questData[1]._questId) then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "[\234\176\129\236\132\177]\236\151\144\235\139\164\235\130\152\236\157\152 \237\157\148\236\160\129 \237\128\152\236\138\164\237\138\184\235\165\188 \236\153\132\235\163\140\237\149\152\236\167\128 \236\149\138\236\156\188\235\169\180 \234\176\149\237\153\148\235\165\188 \237\149\160 \236\136\152 \236\151\134\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 \236\139\156\236\158\145 \234\176\128\235\138\165 \236\151\172\235\182\128 \234\178\128\236\130\172\236\164\145\236\151\144 selfPlayer\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164! _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local pcPosition = selfPlayer:get():getPosition()
  local regionInfo = getRegionInfoByPosition(pcPosition)
  if false == regionInfo:get():isSafeZone() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_DO_SAFEZONE"))
    return false
  end
  local playerLevel = getSelfPlayer():get():getLevel()
  if not (playerLevel >= 50) or not (playerLevel <= 56) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_NOLEVEL_ACK"))
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_EnchantStack:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_EnchantStack:startPhase(stepNo)
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
function PaGlobal_TutorialPhase_EnchantStack:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_EnchantStack:startStep() stepNo : " .. tostring(stepNo) .. " typeNo : " .. tostring(typeNo))
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  self._prevProgress = 0
  self._updateTime = 0
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialManager:setAllowShowQuickSlot(true)
  PaGlobal_TutorialManager:setAllowNewQuickSlot(true)
  FGlobal_WorldmapMain_SetAllowTutorialPanelShow(false)
  if false == _ContentsGroup_NewUI_Dialog_All then
    FGlobal_Dialog_SetAllowTutorialPanelShow(true)
  else
    PaGlobalFunc_DialogMain_All_SetAllowTutorialPanelShow(true)
  end
  PaGlobal_TutorialUiManager:getUiKeyButton():setShowAll(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:repositionScreen()
  Panel_Tutorial:SetShow(true, true)
end
function PaGlobal_TutorialPhase_EnchantStack:endPhase()
  if false == _ContentsGroup_NewUI_Dialog_All then
    local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Enchant)
    if -1 ~= funcButtonIndex then
      FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
    end
  else
    local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Enchant)
  end
  PaGlobal_Enchant:removeFailCountEffect()
  PaGlobal_Enchant:removeValksCountEffect()
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialManager:endTutorial()
end
function PaGlobal_TutorialPhase_EnchantStack:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_EnchantStack:handleChangeStep(currentStep)
  if 1 == self._currentStep then
    self:changeStep1()
  end
end
function PaGlobal_TutorialPhase_EnchantStack:toNextProgress()
  if 4 == self._currentProgress then
    self._currentProgress = 9
  else
    self._currentProgress = self._currentProgress + 1
    do break end
    self._currentProgress = self._currentProgress + 1
  end
  self:handleChangeStep(self._currentStep)
end
function PaGlobal_TutorialPhase_EnchantStack:toNextStep()
  self._currentProgress = 1
  if 4 == self._nextStep then
    self._nextStep = 9
  else
    self._nextStep = self._nextStep + 1
    do break end
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_EnchantStack:toStep(destStep, destProgress)
  self._nextStep = destStep
  if nil == destProgress then
    self._currentProgress = 1
  else
    self._currentProgress = destProgress
  end
  if self._currentStep == self._nextStep then
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_EnchantStack:setEffectDialogButtonByType(funcButtonType)
  if false == _ContentsGroup_NewUI_Dialog_All then
    local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(funcButtonType)
    if -1 == funcButtonIndex then
      return false
    end
    FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
    FGlobal_AddEffect_DialogButton(funcButtonIndex, "UI_ArrowMark02", true, 0, -50)
  else
    local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(funcButtonType)
  end
  return true
end
function PaGlobal_TutorialPhase_EnchantStack:changeStep1()
  local westString1 = "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_115"
  local westString2 = "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_116"
  if isGameTypeEnglish() then
    westString1 = "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_119"
    westString2 = "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_120"
  end
  if 1 == self._currentProgress then
    self:setEffectDialogButtonByType(CppEnums.ContentsType.Contents_Enchant)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_99"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_100"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif 2 == self._currentProgress then
    if false == _ContentsGroup_NewUI_Dialog_All then
      local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Enchant)
      if -1 ~= funcButtonIndex then
        FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
      end
    else
      local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Enchant)
    end
    PaGlobal_Enchant:addFailCountEffectForTutorial()
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_101"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_102"), true, Panel_Window_Enchant:GetPosX() + Panel_Window_Enchant:GetSizeX() * 1.1, Panel_Window_Enchant:GetPosY() - Panel_Window_Enchant:GetSizeY() * 0.025, false)
    end)
  elseif 3 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_103"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_104"), true, Panel_Window_Enchant:GetPosX() + Panel_Window_Enchant:GetSizeX() * 1.1, Panel_Window_Enchant:GetPosY() - Panel_Window_Enchant:GetSizeY() * 0.025, false)
    end)
  elseif 4 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_105"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_106"), true, Panel_Window_Enchant:GetPosX() + Panel_Window_Enchant:GetSizeX() * 1.1, Panel_Window_Enchant:GetPosY() - Panel_Window_Enchant:GetSizeY() * 0.025, false)
    end)
  elseif 5 == self._currentProgress then
    PaGlobal_Enchant:addValksCountEffectForTutorial()
    PaGlobal_Enchant:removeFailCountEffect()
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_107"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_108"), true, Panel_Window_Enchant:GetPosX() + Panel_Window_Enchant:GetSizeX() * 1.1, Panel_Window_Enchant:GetPosY() - Panel_Window_Enchant:GetSizeY() * 0.025, false)
    end)
  elseif 6 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_109"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_110"), true, Panel_Window_Enchant:GetPosX() + Panel_Window_Enchant:GetSizeX() * 1.1, Panel_Window_Enchant:GetPosY() - Panel_Window_Enchant:GetSizeY() * 0.025, false)
    end)
  elseif 7 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_111"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_112"), true, Panel_Window_Enchant:GetPosX() + Panel_Window_Enchant:GetSizeX() * 1.1, Panel_Window_Enchant:GetPosY() - Panel_Window_Enchant:GetSizeY() * 0.025, false)
    end)
  elseif 8 == self._currentProgress then
    PaGlobal_Enchant:addFailCountEffectForTutorial()
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_113"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_114"), true, Panel_Window_Enchant:GetPosX() + Panel_Window_Enchant:GetSizeX() * 1.1, Panel_Window_Enchant:GetPosY() - Panel_Window_Enchant:GetSizeY() * 0.025, false)
    end)
  elseif 9 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, westString1), PAGetString(Defines.StringSheet_GAME, westString2), true, Panel_Window_Enchant:GetPosX() + Panel_Window_Enchant:GetSizeX() * 1.1, Panel_Window_Enchant:GetPosY() - Panel_Window_Enchant:GetSizeY() * 0.025, false)
    end)
  end
end
function PaGlobal_TutorialPhase_EnchantStack:eventCallStep1ShowDialog(dialogData)
  if self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_EnchantStack:eventCallStep1ClickedExitButton(talker)
  if self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_EnchantStack:eventCallStep1ClickedDialogFuncButton(funcButtonType)
  if CppEnums.ContentsType.Contents_Enchant ~= funcButtonType then
    self:endPhase()
  end
  if 1 == self._currentProgress and CppEnums.ContentsType.Contents_Enchant == funcButtonType then
    self._currentProgress = 2
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_EnchantStack:eventCallStep1CloseEnchantWindow()
  if 2 < self._currentProgress then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_EnchantStack:eventCallStep1MouseLUpBubble()
  if 9 == self._currentProgress then
    self:endPhase()
  else
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_EnchantStack:handleShowDialog(dialogData)
  if 1 == self._currentStep then
    self:eventCallStep1ShowDialog(dialogData)
  end
end
function PaGlobal_TutorialPhase_EnchantStack:handleClickedExitButton(talker)
  if 1 == self._currentStep then
    self:eventCallStep1ClickedExitButton(talker)
  end
end
function PaGlobal_TutorialPhase_EnchantStack:handleClickedDialogFuncButton(funcButtonType)
  if 1 == self._currentStep then
    self:eventCallStep1ClickedDialogFuncButton(funcButtonType)
  end
end
function PaGlobal_TutorialPhase_EnchantStack:handleCloseEnchantWindow()
  if 1 == self._currentStep then
    self:eventCallStep1CloseEnchantWindow()
  end
end
function PaGlobal_TutorialPhase_EnchantStack:handleMouseLUpBubble()
  if 1 == self._currentStep then
    self:eventCallStep1MouseLUpBubble()
  end
end

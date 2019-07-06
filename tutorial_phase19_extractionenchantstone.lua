PaGlobal_TutorialPhase_ExtractionEnchantStone = {
  _phaseNo = 19,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 0,
  _prevProgress = 1,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = false,
  _buttonExtraction_EnchantStone = UI.getChildControl(Panel_Window_Extraction, "Button_Extraction_EnchantStone"),
  _buttonExtraction_Crystal = UI.getChildControl(Panel_Window_Extraction, "Button_Extraction_Crystal"),
  _buttonExtraction_Cloth = UI.getChildControl(Panel_Window_Extraction, "Button_Extraction_Cloth")
}
function PaGlobal_TutorialPhase_ExtractionEnchantStone:checkPossibleForPhaseStart(stepNo)
  if false == self._isPhaseOpen then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 Phase\234\176\128 \235\139\171\237\152\128\236\158\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 \236\139\156\236\158\145 \234\176\128\235\138\165 \236\151\172\235\182\128 \234\178\128\236\130\172\236\164\145\236\151\144 selfPlayer\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164! _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() or true == PaGlobal_ArousalTutorial_Manager:isDoingArousalTutorial() or true == PaGlobal_SummonBossTutorial_Manager:isDoingSummonBossTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
    return false
  end
  local pcPosition = selfPlayer:get():getPosition()
  local regionInfo = getRegionInfoByPosition(pcPosition)
  if false == regionInfo:get():isSafeZone() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_DO_SAFEZONE"))
    return false
  end
  local playerLevel = getSelfPlayer():get():getLevel()
  if not (playerLevel >= 40) or not (playerLevel <= 56) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_NOLEVEL_ACK"))
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:addEffectExtractionDialogButton(extractionDialogButton)
  if nil ~= self.extractionDialogButton then
    self.extractionDialogButton:EraseAllEffect()
    self.extractionDialogButton:AddEffect("UI_ArrowMark02", true, 0, -50)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:eraseAllEffectExtractionDialogButton(extractionDialogButton)
  if nil ~= self.extractionDialogButton then
    self.extractionDialogButton:EraseAllEffect()
    self.extractionDialogButton:AddEffect("UI_ArrowMark02", true, 0, -50)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:startPhase(stepNo)
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
function PaGlobal_TutorialPhase_ExtractionEnchantStone:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_ExtractionEnchantStone:startStep() stepNo : " .. tostring(stepNo) .. " typeNo : " .. tostring(typeNo))
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  self._prevProgress = 0
  self._updateTime = 0
  self._buttonExtraction_EnchantStone = PaGlobal_Extraction:getExtractionButtonEnchantStone()
  self._buttonExtraction_Crystal = PaGlobal_Extraction:getExtractionButtonCrystal()
  self._buttonExtraction_Cloth = PaGlobal_Extraction:getExtractionButtonCloth()
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
function PaGlobal_TutorialPhase_ExtractionEnchantStone:endPhase()
  self._buttonExtraction_EnchantStone:EraseAllEffect()
  self._buttonExtraction_Crystal:EraseAllEffect()
  self._buttonExtraction_Cloth:EraseAllEffect()
  PaGlobal_ExtractionEnchantStone:getButtonExtractionApply():EraseAllEffect()
  if false == _ContentsGroup_NewUI_Dialog_All then
    local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Extract)
    if -1 ~= funcButtonIndex then
      FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
    end
  else
    local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Extract)
  end
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialManager:endTutorial()
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:handleChangeStep(currentStep)
  if 1 == self._currentStep then
    self:changeStep1()
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:toNextProgress()
  if isGameTypeEnglish() then
    if 10 == self._currentProgress then
      self._currentProgress = 14
    else
      self._currentProgress = self._currentProgress + 1
    end
  else
    self._currentProgress = self._currentProgress + 1
  end
  self:handleChangeStep(self._currentStep)
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:toNextStep()
  self._currentProgress = 1
  if isGameTypeEnglish() then
    if 10 == self._nextStep then
      self._nextStep = 14
    else
      self._nextStep = self._nextStep + 1
    end
  else
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:toStep(destStep, destProgress)
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
function PaGlobal_TutorialPhase_ExtractionEnchantStone:setEffectDialogButtonByType(funcButtonType)
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
function PaGlobal_ExtractionEnchantStone:eraseAllEffectDialogButtonByType(funcButtonType)
  if false == _ContentsGroup_NewUI_Dialog_All then
    local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(funcButtonType)
    if -1 == funcButtonIndex then
      return false
    end
    FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
  else
    local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(funcButtonType)
  end
  return true
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:changeStep1()
  local westString1 = "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_69"
  local westString2 = "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_70"
  if isGameTypeEnglish() then
    westString1 = "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_117"
    westString2 = "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_118"
  end
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_43"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_44"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 2 == self._currentProgress then
    self:setEffectDialogButtonByType(CppEnums.ContentsType.Contents_Extract)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_45"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_46"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif 3 == self._currentProgress then
    self._buttonExtraction_EnchantStone:AddEffect("UI_ArrowMark02", true, 0, -50)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_47"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_48"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif 4 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_49"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_50"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 5 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_51"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_52"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 6 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_53"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_54"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 7 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_55"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_56"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 8 == self._currentProgress then
    PaGlobal_ExtractionEnchantStone:getButtonExtractionApply():EraseAllEffect()
    self._buttonExtraction_EnchantStone:EraseAllEffect()
    self._buttonExtraction_Crystal:AddEffect("UI_ArrowMark02", true, 0, -50)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_57"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_58"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif 9 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_59"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_60"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 10 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_61"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_62"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 11 == self._currentProgress then
    self._buttonExtraction_Crystal:EraseAllEffect()
    self._buttonExtraction_Cloth:AddEffect("UI_ArrowMark02", true, 0, -50)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_63"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_64"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif 12 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_65"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_66"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 13 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_67"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_68"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 14 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, westString1), PAGetString(Defines.StringSheet_GAME, westString2), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:eventCallStep1ShowDialog(dialogData)
  if (3 == self._currentProgress or 4 == self._currentProgress or 5 == self._currentProgress) and self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
    if false == _ContentsGroup_NewUI_Dialog_All then
      local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Extract)
      FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
      FGlobal_AddEffect_DialogButton(funcButtonIndex, "UI_ArrowMark02", true, 0, -50)
    else
      local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Extract)
    end
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:eventCallStep1ClickedExitButton(talker)
  self:endPhase()
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:eventCallStep1ClickedDialogFuncButton(funcButtonType)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "funcButtonType : " .. tostring(funcButtonType))
  if CppEnums.ContentsType.Contents_Extract ~= funcButtonType then
    self:endPhase()
  end
  if self._currentProgress < 3 then
    self._currentProgress = 3
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:eventCallStep1OpenExtractionPanel(isShow)
  if false == isShow then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:eventCallStep1ClickExtractionEnchantStoneButton(isShow)
  if false == isShow then
    return
  end
  if 3 == self._currentProgress or 4 == self._currentProgress or 5 == self._currentProgress then
    PaGlobal_ExtractionEnchantStone:getButtonExtractionApply():EraseAllEffect()
    PaGlobal_ExtractionEnchantStone:getButtonExtractionApply():AddEffect("UI_ArrowMark06", true, -70, 0)
    PaGlobal_ExtractionEnchantStone:getButtonExtractionApply():AddEffect("UI_ArrowMark04", true, 70, 0)
  end
  if 3 == self._currentProgress or 4 == self._currentProgress then
    self._currentProgress = 5
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:eventCallStep1ClickExtractionCrystalButton(isShow)
  if false == isShow then
    return
  end
  if 9 == self._currentProgress or 10 == self._currentProgress then
  end
  if 8 == self._currentProgress then
    self._currentProgress = 9
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:eventCallStep1ClickExtractionClothButton(isShow)
  if false == isShow then
    return
  end
  if 12 == self._currentProgress or 13 == self._currentProgress then
  end
  if 11 == self._currentProgress then
    self._currentProgress = 12
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:eventCallStep1MouseLUpBubble()
  if 14 == self._currentProgress then
    self:endPhase()
  else
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:handleShowDialog(dialogData)
  if 1 == self._currentStep then
    self:eventCallStep1ShowDialog(dialogData)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:handleClickedExitButton(talker)
  if 1 == self._currentStep then
    self:eventCallStep1ClickedExitButton(talker)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:handleClickedDialogFuncButton(funcButtonType)
  if 1 == self._currentStep then
    self:eventCallStep1ClickedDialogFuncButton(funcButtonType)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:handleOpenExtractionPanel(isShow)
  if 1 == self._currentStep then
    self:eventCallStep1OpenExtractionPanel(isShow)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:handleClickExtractionEnchantStoneButton(isShow)
  if 1 == self._currentStep then
    self:eventCallStep1ClickExtractionEnchantStoneButton(isShow)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:handleClickExtractionCrystalButton(isShow)
  if 1 == self._currentStep then
    self:eventCallStep1ClickExtractionCrystalButton(isShow)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:handleClickExtractionClothButton(isShow)
  if 1 == self._currentStep then
    self:eventCallStep1ClickExtractionClothButton(isShow)
  end
end
function PaGlobal_TutorialPhase_ExtractionEnchantStone:handleMouseLUpBubble()
  if 1 == self._currentStep then
    self:eventCallStep1MouseLUpBubble()
  end
end

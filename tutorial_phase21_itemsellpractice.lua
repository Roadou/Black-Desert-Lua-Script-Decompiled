PaGlobal_TutorialPhase_ItemSellPractice = {
  _phaseNo = 21,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 0,
  _prevProgress = 1,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = false,
  _radioButtonSell = nil,
  _npcShopSpiritPosX = 0,
  _npcShopSpiritPosY = 0,
  _buttonSellAll = nil
}
function PaGlobal_TutorialPhase_ItemSellPractice:checkPossibleForPhaseStart(stepNo)
  if false == self._isPhaseOpen then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 Phase\234\176\128 \235\139\171\237\152\128\236\158\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() or true == PaGlobal_ArousalTutorial_Manager:isDoingArousalTutorial() or true == PaGlobal_SummonBossTutorial_Manager:isDoingSummonBossTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
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
  if not (playerLevel >= 10) or not (playerLevel <= 40) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_NOLEVEL_ACK"))
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_ItemSellPractice:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_ItemSellPractice:startPhase(stepNo)
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
function PaGlobal_TutorialPhase_ItemSellPractice:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_ItemSellPractice:startStep() stepNo : " .. tostring(stepNo) .. " typeNo : " .. tostring(typeNo))
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  self._prevProgress = 0
  self._updateTime = 0
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
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
function PaGlobal_TutorialPhase_ItemSellPractice:endPhase()
  if false == _ContentsGroup_NewUI_Dialog_All then
    local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Shop)
    if -1 ~= funcButtonIndex then
      FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
    end
  else
    local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Shop)
  end
  if nil ~= self._radioButtonSell then
    self._radioButtonSell:EraseAllEffect()
  end
  if nil ~= self._buttonSellAll then
    self._buttonSellAll:EraseAllEffect()
  end
  if nil ~= self._checkButton_Warehouse then
    self._checkButton_Warehouse:EraseAllEffect()
  end
  if nil ~= self._checkButton_Inventory then
    self._checkButton_Inventory:EraseAllEffect()
  end
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialManager:endTutorial()
end
function PaGlobal_TutorialPhase_ItemSellPractice:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_ItemSellPractice:handleChangeStep(currentStep)
  if 1 == self._currentStep then
    self:changeStep1()
  end
end
function PaGlobal_TutorialPhase_ItemSellPractice:toNextProgress()
  self._currentProgress = self._currentProgress + 1
  self:handleChangeStep(self._currentStep)
end
function PaGlobal_TutorialPhase_ItemSellPractice:toNextStep()
  self._currentProgress = 1
  self._nextStep = self._nextStep + 1
end
function PaGlobal_TutorialPhase_ItemSellPractice:toStep(destStep, destProgress)
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
function PaGlobal_TutorialPhase_ItemSellPractice:setEffectDialogButtonByType(funcButtonType)
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
function PaGlobal_TutorialPhase_ItemSellPractice:calcSpiritPosForNpcShopWindow()
  local spiritPosX = 0
  local spiritPosY = 0
  if nil ~= Panel_Window_NpcShop then
    spiritPosX = Panel_Window_NpcShop:GetPosX() + Panel_Window_NpcShop:GetSizeX() * 0.8
    spiritPosY = Panel_Window_NpcShop:GetPosY() + Panel_Window_NpcShop:GetSizeY() * 1.025
  end
  return spiritPosX, spiritPosY
end
function PaGlobal_TutorialPhase_ItemSellPractice:changeStep1()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_77"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_78"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 2 == self._currentProgress then
    self:setEffectDialogButtonByType(CppEnums.ContentsType.Contents_Shop)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_79"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_80"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif 3 == self._currentProgress then
    if false == _ContentsGroup_NewUI_Dialog_All then
      local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Shop)
      if -1 ~= funcButtonIndex then
        FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
      end
    else
      local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Shop)
    end
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_81"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_82"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 4 == self._currentProgress then
    if nil ~= Panel_Window_NpcShop and nil ~= FGlobal_NpcShop_GetRadioButtonByIndex then
      self._radioButtonSell = FGlobal_NpcShop_GetRadioButtonByIndex(1)
    end
    if nil ~= self._radioButtonSell then
      self._radioButtonSell:AddEffect("UI_ArrowMark08", true, 0, 50)
      self._radioButtonSell:AddEffect("UI_WorldMap_Ping01", true, 0, 0)
    end
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_83"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_84"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif 5 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_85"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_86"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 6 == self._currentProgress then
    if nil ~= Panel_Window_NpcShop then
      self._buttonSellAll = FGlobal_NpcShop_GetNpcShop().buttonSellAll
    end
    if nil ~= self._buttonSellAll then
      self._buttonSellAll:AddEffect("UI_ArrowMark02", true, 0, -50)
      self._buttonSellAll:AddEffect("UI_WorldMap_Ping01", true, 0, 0)
    end
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_87"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_88"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 7 == self._currentProgress then
    if nil ~= self._buttonSellAll then
      self._buttonSellAll:EraseAllEffect()
    end
    if nil ~= Panel_Window_NpcShop and nil ~= FGlobal_NpcShop_GetNpcShop then
      self._checkButton_Inventory = FGlobal_NpcShop_GetNpcShop().checkButton_Inventory
      self._checkButton_Warehouse = FGlobal_NpcShop_GetNpcShop().checkButton_Warehouse
    end
    if nil ~= self._checkButton_Inventory then
      self._checkButton_Inventory:AddEffect("UI_WorldMap_Ping01", true, 0, 0)
      self._checkButton_Inventory:AddEffect("UI_ArrowMark06", true, -50, 0)
    end
    if nil ~= self._checkButton_Warehouse then
      self._checkButton_Warehouse:AddEffect("UI_WorldMap_Ping02", true, 0, 0)
      self._checkButton_Warehouse:AddEffect("UI_ArrowMark06", true, -50, 0)
    end
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_89"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_90"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 8 == self._currentProgress then
    if nil ~= self._checkButton_Warehouse then
      self._checkButton_Warehouse:EraseAllEffect()
    end
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_91"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_92"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 9 == self._currentProgress then
    if nil ~= self._checkButton_Inventory then
      self._checkButton_Inventory:EraseAllEffect()
    end
    if nil ~= self._checkButton_Warehouse then
      self._checkButton_Warehouse:AddEffect("UI_WorldMap_Ping02", true, 0, 0)
      self._checkButton_Warehouse:AddEffect("UI_ArrowMark06", true, -50, 0)
    end
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_93"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_94"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 10 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_95"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_96"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 11 == self._currentProgress then
    if nil ~= self._checkButton_Warehouse then
      self._checkButton_Warehouse:EraseAllEffect()
    end
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_97"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_98"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  end
end
function PaGlobal_TutorialPhase_ItemSellPractice:eventCallStep1ClickedExitButton(talker)
  self:endPhase()
end
function PaGlobal_TutorialPhase_ItemSellPractice:eventCallStep1ClickedDialogFuncButton(funcButtonType)
  if CppEnums.ContentsType.Contents_Shop ~= funcButtonType then
    self:endPhase()
  end
  if 2 == self._currentProgress and CppEnums.ContentsType.Contents_Shop == funcButtonType then
    self._currentProgress = 3
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_ItemSellPractice:eventCallStep1NpcShopWindowClose()
  if 2 < self._currentProgress then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_ItemSellPractice:eventCallStep1NpcShopTabButtonClick(tabIndex)
  if 4 == self._currentProgress then
    if 1 == tabIndex then
      if nil ~= self._radioButtonSell then
        self._radioButtonSell:EraseAllEffect()
      end
      self._currentProgress = 5
      self:handleChangeStep(self._currentStep)
    elseif nil ~= self._radioButtonSell then
      self._radioButtonSell:AddEffect("UI_ArrowMark08", true, 0, 50)
      self._radioButtonSell:AddEffect("UI_WorldMap_Ping01", true, 0, 0)
    end
  elseif self._currentProgress >= 5 and 1 ~= tabIndex then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_ItemSellPractice:eventCallStep1MouseLUpBubble()
  if 11 == self._currentProgress then
    self:endPhase()
  else
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_ItemSellPractice:handleClickedExitButton(talker)
  if 1 == self._currentStep then
    self:eventCallStep1ClickedExitButton(talker)
  end
end
function PaGlobal_TutorialPhase_ItemSellPractice:handleNpcShopWindowClose()
  if 1 == self._currentStep then
    self:eventCallStep1NpcShopWindowClose()
  end
end
function PaGlobal_TutorialPhase_ItemSellPractice:handleNpcShopTabButtonClick(tabIndex)
  if 1 == self._currentStep then
    self:eventCallStep1NpcShopTabButtonClick(tabIndex)
  end
end
function PaGlobal_TutorialPhase_ItemSellPractice:handleClickedDialogFuncButton(funcButtonType)
  if 1 == self._currentStep then
    self:eventCallStep1ClickedDialogFuncButton(funcButtonType)
  end
end
function PaGlobal_TutorialPhase_ItemSellPractice:handleMouseLUpBubble()
  if 1 == self._currentStep then
    self:eventCallStep1MouseLUpBubble()
  end
end

PaGlobal_TutorialPhase_NewItemEquip = {
  _phaseNo = 16,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 0,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = false
}
function PaGlobal_TutorialPhase_NewItemEquip:checkPossibleForPhaseStart(stepNo)
  if false == self._isPhaseOpen then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 Phase\234\176\128 \235\139\171\237\152\128\236\158\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() or true == PaGlobal_ArousalTutorial_Manager:isDoingArousalTutorial() or true == PaGlobal_SummonBossTutorial_Manager:isDoingSummonBossTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
    return false
  end
  local playerLevel = getSelfPlayer():get():getLevel()
  if not (playerLevel >= 6) or not (playerLevel <= 49) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_NOLEVEL_ACK"))
    return false
  end
  if false == Panel_NewEquip:GetShow() then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\236\139\160\234\183\156 \236\158\165\235\185\132 \237\140\168\235\132\144\236\157\180 \236\151\180\235\160\164\236\158\136\236\167\128 \236\149\138\236\149\132 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_NewItemEquip:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_NewItemEquip:startPhase(stepNo)
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
function PaGlobal_TutorialPhase_NewItemEquip:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_NewItemEquip:startStep() stepNo : " .. tostring(stepNo) .. " typeNo : " .. tostring(typeNo))
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  self._updateTime = 0
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
  PaGlobal_TutorialManager:setAllowShowQuickSlot(true)
  PaGlobal_TutorialManager:setAllowNewQuickSlot(true)
  FGlobal_WorldmapMain_SetAllowTutorialPanelShow(false)
  if false == _ContentsGroup_NewUI_Dialog_All then
    FGlobal_Dialog_SetAllowTutorialPanelShow(false)
  else
    PaGlobalFunc_DialogMain_All_SetAllowTutorialPanelShow(false)
  end
  PaGlobal_TutorialUiManager:getUiKeyButton():setShowAll(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:repositionScreen()
  Panel_Tutorial:SetShow(true, true)
end
function PaGlobal_TutorialPhase_NewItemEquip:endPhase()
  Panel_NewEquip:EraseAllEffect()
  PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialManager:endTutorial()
end
function PaGlobal_TutorialPhase_NewItemEquip:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_NewItemEquip:handleChangeStep(currentStep)
  if 1 == self._currentStep then
    self:changeStep1()
  end
end
function PaGlobal_TutorialPhase_NewItemEquip:toNextProgress()
  self._currentProgress = self._currentProgress + 1
  self:handleChangeStep(self._currentStep)
end
function PaGlobal_TutorialPhase_NewItemEquip:toNextStep()
  self._currentProgress = 1
  self._nextStep = self._nextStep + 1
end
function PaGlobal_TutorialPhase_NewItemEquip:changeStep1()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_1"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_2"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 2 == self._currentProgress then
    if true == Panel_NewEquip:GetShow() then
      Panel_NewEquip:AddEffect("UI_QustComplete02", true, 0, 0)
      Panel_NewEquip:AddEffect("UI_WorldMap_Ping01", true, 0, 0)
    elseif false == Panel_NewEquip:GetShow() then
      self:endPhase()
      _PA_LOG("\234\179\189\235\175\188\236\154\176", "(\236\149\132\236\157\180\237\133\156 \236\158\165\236\176\169 \237\138\156\237\134\160\235\166\172\236\150\188)\236\139\160\234\183\156 \236\158\165\235\185\132 \237\140\168\235\132\144\236\157\180 \237\145\156\236\139\156\235\144\152\236\150\180 \236\158\136\236\167\128 \236\149\138\236\149\132 \237\142\152\236\157\180\236\166\136 \236\162\133\235\163\140. : ")
    end
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_3"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_4"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
      PaGlobal_TutorialUiManager:getUiBlackSpirit():addBubbleKey("_bubbleKey_I")
    end)
  elseif 3 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_5"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_6"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 4 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_7"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_8"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  end
end
function PaGlobal_TutorialPhase_NewItemEquip:eventCallStep1ClosedInventory()
  if 2 ~= self._currentProgress then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_NewItemEquip:eventCallStep1OpenedInventory()
  if 2 == self._currentProgress then
    self._currentProgress = 3
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_NewItemEquip:eventCallStep1MouseLUpBubble()
  if 4 == self._currentProgress then
    self:endPhase()
  else
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_NewItemEquip:handleOpenedInventory()
  if 1 == self._currentStep then
    self:eventCallStep1OpenedInventory()
  end
end
function PaGlobal_TutorialPhase_NewItemEquip:handleClosedInventory()
  if 1 == self._currentStep then
    self:eventCallStep1ClosedInventory()
  end
end
function PaGlobal_TutorialPhase_NewItemEquip:handleMouseLUpBubble()
  if 1 == self._currentStep then
    self:eventCallStep1MouseLUpBubble()
  end
end

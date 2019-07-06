PaGlobal_TutorialPhase_WorldmapNodeAndNavi = {
  _phaseNo = 10,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 0,
  _prevProgress = 0,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = false,
  _nodeWaypointKeyList = {
    1,
    301,
    601,
    1101,
    1301,
    61,
    604,
    608,
    602,
    302,
    1141,
    1319,
    1314,
    1343,
    1380,
    1002
  }
}
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:checkPossibleForPhaseStart(stepNo)
  if false == self._isPhaseOpen then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 Phase\234\176\128 \235\139\171\237\152\128\236\158\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() or true == PaGlobal_ArousalTutorial_Manager:isDoingArousalTutorial() or true == PaGlobal_SummonBossTutorial_Manager:isDoingSummonBossTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:startPhase(stepNo)
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
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_WorldmapNodeAndNavi:startStep() stepNo : " .. tostring(stepNo) .. " typeNo : " .. tostring(typeNo))
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  self._prevProgress = 0
  self._updateTime = 0
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
  PaGlobal_TutorialManager:setAllowShowQuickSlot(true)
  PaGlobal_TutorialManager:setAllowNewQuickSlot(true)
  FGlobal_WorldmapMain_SetAllowTutorialPanelShow(true)
  PaGlobal_TutorialUiManager:getUiKeyButton():setShowAll(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:repositionScreen()
  Panel_Tutorial:SetShow(true, true)
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:endPhase()
  PaGlobal_TutorialUiBlackSpirit:setIgnoreBubble(true)
  FGlobal_WorldmapMain_SetAllowTutorialPanelShow(false)
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialManager:endTutorial()
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:handleChangeStep(currentStep)
  if 1 == self._currentStep then
    self:changeStepSuggestOpenWorldmap()
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:toNextProgress()
  self._currentProgress = self._currentProgress + 1
  self:handleChangeStep(self._currentStep)
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:toNextStep()
  self._currentProgress = 1
  self._nextStep = self._nextStep + 1
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:toStep(destStep, destProgress)
  self._nextStep = destStep
  if nil == destProgress then
    self._currentProgress = 1
  else
    self._currentProgress = destProgress
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:setEffectNodeWaypointKeyList()
  for index, value in ipairs(self._nodeWaypointKeyList) do
    FGlobal_WorldmapMain_EraseAllEffectUiNodeButtonByWaypointKey(value)
    FGlobal_WorldmapMain_AddEffectUiNodeButtonByWaypointKey(value, "UI_ArrowMark02", true, 0, -50)
    FGlobal_WorldmapMain_AddEffectUiNodeButtonByWaypointKey(value, "UI_WorldMap_Ping01", true, 0, 0)
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:eraseAllEffectNodeWaypointKeyList()
  for index, value in ipairs(self._nodeWaypointKeyList) do
    FGlobal_WorldmapMain_EraseAllEffectUiNodeButtonByWaypointKey(value)
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:changeStepSuggestOpenWorldmap()
  if 1 == self._currentProgress then
    toClient_FadeIn(0.75)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_31"), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 2 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_32"), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 3 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_33"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_34"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
    self:setEffectNodeWaypointKeyList()
  elseif 4 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_35"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_36"), false, getScreenSizeX() * 0.3, getScreenSizeY() * 0.6, true)
    end)
    self:eraseAllEffectNodeWaypointKeyList()
  elseif 5 == self._currentProgress then
    ToClient_DeleteNaviGuideByGroup()
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_37"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_38"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif 6 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_39"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_40"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif -1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_41"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_42"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5, true)
    end)
  elseif -2 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_43"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_44"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5, true)
    end)
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:eventCallStep1WorldMapOpenComplete()
  if 4 == self._currentProgress then
    self:setEffectNodeWaypointKeyList()
  elseif -1 == self._currentProgress then
    if 5 <= self._prevProgress then
      self._currentProgress = 5
    else
      self._currentProgress = 1
    end
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:eventCallStep1NodeLClick(uiNodeButton)
  if 3 ~= self._currentProgress then
    self._prevProgress = self._currentProgress
    self._currentProgress = -2
  elseif 3 == self._currentProgress then
    local isMatchWaypointKey = false
    for index, value in ipairs(self._nodeWaypointKeyList) do
      if value == uiNodeButton:getWaypointKey() then
        isMatchWaypointKey = true
        break
      end
    end
    if true == isMatchWaypointKey then
      self._currentProgress = self._currentProgress + 1
    else
      self._prevProgress = self._currentProgress
      self._currentProgress = -2
    end
  end
  self:handleChangeStep(self._currentStep)
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:eventCallStep1ResetTownMode()
  if 3 <= self._currentProgress and self._currentProgress < 4 then
    self:setEffectNodeWaypointKeyList()
  elseif 4 == self._currentProgress then
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  elseif -2 == self._currentProgress then
    if 3 > self._prevProgress then
      self._currentProgress = 1
    elseif 4 == self._prevProgress then
      self._currentProgress = 3
    else
      self._currentProgress = self._prevProgress
    end
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:eventCallStep1RClickWorldmapPanel()
  if 5 == self._currentProgress then
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:eventCallStep1WorldMapImmediatelyClose()
  if 1 <= self._currentProgress and self._currentProgress < 6 then
    self._prevProgress = self._currentProgress
    self._currentProgress = -1
    self:handleChangeStep(self._currentStep)
  elseif 6 == self._currentProgress then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:eventCallStep1MouseLUpBubble()
  if 6 == self._currentProgress then
    self:endPhase()
  else
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:handleWorldMapOpenComplete()
  if 1 == self._currentStep then
    self:eventCallStep1WorldMapOpenComplete()
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:handleWorldMapImmediatelyClose()
  if 1 == self._currentStep then
    self:eventCallStep1WorldMapImmediatelyClose()
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:handleLClickWorldMapNode(uiNodeButton)
  if 1 == self._currentStep then
    self:eventCallStep1NodeLClick(uiNodeButton)
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:handleRClickWorldmapPanel(pos3D, immediately, isTopPicking, uiKnowledgeStatic)
  if 1 == self._currentStep then
    self:eventCallStep1RClickWorldmapPanel()
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:handleRClickWorldMapNode(uiNodeButton)
  if 1 == self._currentStep then
    self:eventCallStep1RClickWorldmapPanel()
  end
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:handleResetTownMode()
  self:eventCallStep1ResetTownMode()
end
function PaGlobal_TutorialPhase_WorldmapNodeAndNavi:handleMouseLUpBubble()
  if 1 == self._currentStep then
    self:eventCallStep1MouseLUpBubble()
  end
end

PaGlobal_TutorialPhase_WorldmapMenu = {
  _phaseNo = 12,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 0,
  _prevProgress = 0,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = false,
  _tempTargetUi = nil,
  _eventTempControl = nil,
  _longWaitTime = 20,
  _cityWaypointKeyList = {
    1,
    301,
    601,
    1101,
    1301
  }
}
function PaGlobal_TutorialPhase_WorldmapMenu:checkPossibleForPhaseStart(stepNo)
  if false == self._isPhaseOpen then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 Phase\234\176\128 \235\139\171\237\152\128\236\158\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() or true == PaGlobal_ArousalTutorial_Manager:isDoingArousalTutorial() or true == PaGlobal_SummonBossTutorial_Manager:isDoingSummonBossTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
    return false
  end
  local foundCount = 0
  for key, value in pairs(self._cityWaypointKeyList) do
    if true == checkSelfplayerNode(value, false) then
      foundCount = foundCount + 1
    end
  end
  if 0 == foundCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_CANTSTART_NOTFOUNDCITY"))
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_WorldmapMenu:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_WorldmapMenu:startPhase(stepNo)
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
function PaGlobal_TutorialPhase_WorldmapMenu:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_WorldmapMenu:startStep() stepNo : " .. tostring(stepNo) .. " typeNo : " .. tostring(typeNo))
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  self._prevProgress = 1
  self._updateTime = 0
  self._longWaitTime = 20
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
  PaGlobal_TutorialManager:setAllowShowQuickSlot(true)
  PaGlobal_TutorialManager:setAllowNewQuickSlot(true)
  FGlobal_WorldmapMain_SetAllowTutorialPanelShow(true)
  PaGlobal_TutorialUiManager:getUiKeyButton():setShowAll(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:repositionScreen()
  Panel_Tutorial:SetShow(true, true)
end
function PaGlobal_TutorialPhase_WorldmapMenu:endPhase()
  if nil ~= self._eventTempControl then
    self._eventTempControl:SetShow(false, false)
  end
  FGlobal_WorldmapMain_EraseAllEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().normal)
  FGlobal_WorldmapMain_EraseAllEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().viliage)
  FGlobal_WorldmapMain_EraseAllEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().city)
  self:eraseAllEffectAllSearchResultUi()
  self:eraseAllEffectAllModeButton()
  self:eraseAllEffectAllCheckButton()
  PaGlobal_TutorialUiBlackSpirit:setIgnoreBubble(true)
  FGlobal_WorldmapMain_SetAllowTutorialPanelShow(false)
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialManager:endTutorial()
end
function PaGlobal_TutorialPhase_WorldmapMenu:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
  if 1 == self._currentStep then
    self:updateStep1(deltaTime)
  elseif 2 == self._currentStep then
    self:updateStep2(deltaTime)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:handleChangeStep(currentStep)
  if 1 == self._currentStep then
    self:changeStep1()
  elseif 2 == self._currentStep then
    self:changeStep2()
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:toNextProgress()
  self._currentProgress = self._currentProgress + 1
  self:handleChangeStep(self._currentStep)
end
function PaGlobal_TutorialPhase_WorldmapMenu:toNextStep()
  self._currentProgress = 1
  self._nextStep = self._nextStep + 1
end
function PaGlobal_TutorialPhase_WorldmapMenu:toStep(destStep, destProgress)
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
function PaGlobal_TutorialPhase_WorldmapMenu:setEffectAllSearchResultUi(effectName, isLoop, offsetX, offsetY)
  for index = 0, FGlobal_WorldmapMain_GetSearchingResultCount() - 1 do
    local resultUiByIndex = FGlobal_WorldmapMain_GetSearchResultUiPool(index)
    if nil ~= resultUiByIndex then
      resultUiByIndex:EraseAllEffect()
      resultUiByIndex:AddEffect(effectName, isLoop, offsetX, offsetY)
    end
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eraseAllEffectAllSearchResultUi()
  for index = 0, FGlobal_WorldmapMain_GetSearchingResultCount() - 1 do
    local resultUiByIndex = FGlobal_WorldmapMain_GetSearchResultUiPool(index)
    if nil ~= resultUiByIndex then
      resultUiByIndex:EraseAllEffect()
    end
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:setEffectAllModeButton()
  local worldmapModeButtonList = FGlobal_WorldmapMain_GetWorldmapModeButtonList()
  for key, value in pairs(worldmapModeButtonList) do
    value:EraseAllEffect()
    value:AddEffect("UI_ItemInstall", true, 0, 0)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eraseAllEffectAllModeButton()
  local worldmapModeButtonList = FGlobal_WorldmapMain_GetWorldmapModeButtonList()
  for key, value in pairs(worldmapModeButtonList) do
    value:EraseAllEffect()
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:setEffectAllCheckButton()
  local worldmapFilterCheckButtonList = FGlobal_WorldmapMain_GetWorldmapCheckButtonList()
  for key, value in pairs(worldmapFilterCheckButtonList) do
    value:EraseAllEffect()
    value:AddEffect("UI_ItemInstall_Gold", true, 0, 0)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eraseAllEffectAllCheckButton()
  local worldmapFilterCheckButtonList = FGlobal_WorldmapMain_GetWorldmapCheckButtonList()
  for key, value in pairs(worldmapFilterCheckButtonList) do
    value:EraseAllEffect()
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:changeStep1()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_63"), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 2 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_64"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_65"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
    self._tempTargetUi = UI.getChildControl(Panel_WorldMap_Main, "MainMenu_Bg")
    self._eventTempControl = FGlobal_WorldmapMain_GetOrCreateEventTempControl("Mouse_On", self._tempTargetUi, Panel_WorldMap_Main)
    if nil ~= self._eventTempControl then
      self._eventTempControl:SetShow(true, true)
    end
  elseif 3 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_66"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_67"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
    if nil ~= self._eventTempControl then
      self._eventTempControl:SetShow(false, false)
    end
    FGlobal_WorldmapMain_EraseAllEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().normal)
    FGlobal_WorldmapMain_AddEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().normal, "UI_WorldMap_Ping01", true, 0, 0)
    FGlobal_WorldmapMain_AddEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().normal, "UI_ItemJewel02", true, 0, 0)
  elseif 4 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_68"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_69"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
    FGlobal_WorldmapMain_EraseAllEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().viliage)
    FGlobal_WorldmapMain_AddEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().viliage, "UI_WorldMap_Ping01", true, 0, 0)
    FGlobal_WorldmapMain_AddEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().viliage, "UI_ItemJewel02", true, 0, 0)
  elseif 5 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_70"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_71"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
    FGlobal_WorldmapMain_EraseAllEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().city)
    FGlobal_WorldmapMain_AddEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().city, "UI_WorldMap_Ping01", true, 0, 0)
    FGlobal_WorldmapMain_AddEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().city, "UI_ItemJewel02", true, 0, 0)
  elseif 6 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_72"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_73"), false, getScreenSizeX() * 0.3, getScreenSizeY() * 0.2, true)
    end)
    self:setEffectAllSearchResultUi("UI_ButtonLineRight_Blue", true, -10, 0)
    FGlobal_WorldmapMain_EraseAllEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().city)
    FGlobal_WorldmapMain_AddEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().city, "UI_WorldMap_Ping02", true, 0, 0)
    FGlobal_WorldmapMain_AddEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().city, "UI_ItemJewel02", true, 0, 0)
  elseif 7 == self._currentProgress then
    self._updateTime = 0
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_74"), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif -1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_75"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_76"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5, true)
    end)
  elseif -2 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_77"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_78"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5, true)
    end)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:updateStep1(deltaTime)
  if 2 == self._currentProgress then
    FGlobal_WorldmapMain_PerFrameAlphaAnimationEventTempControl(0.4, 0.9, deltaTime * 7.5)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eventCallStep1WorldMapOpenComplete()
  if -1 == self._currentProgress then
    self._currentProgress = self._prevProgress
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eventCallStep1WorldMapImmediatelyClose()
  if 1 <= self._currentProgress and self._currentProgress <= 7 then
    self._prevProgress = self._currentProgress
    self._currentProgress = -1
    self:handleChangeStep(self._currentStep)
  elseif -2 == self._currentProgress then
    self._currentProgress = -1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eventCallStep1NodeLClick(uiNodeButton)
  if 1 <= self._currentProgress and self._currentProgress <= 7 then
    self._prevProgress = self._currentProgress
    self._currentProgress = -2
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eventCallStep1ResetTownMode()
  if -2 == self._currentProgress then
    self._currentProgress = self._prevProgress
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eventCallStep1WorldmapMainEventTempControl()
  if 2 == self._currentProgress then
    if nil ~= self._eventTempControl then
      self._eventTempControl:SetShow(false, false)
    end
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eventCallStep1ClickedGrandWorldMapSearchNodeType(typeIndex)
  if 3 == self._currentProgress then
    if FGlobal_WorldmapMain_GetWorldmapNodeType().normal == typeIndex then
      FGlobal_WorldmapMain_EraseAllEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().normal)
      self:toNextProgress()
    end
  elseif 4 == self._currentProgress then
    if FGlobal_WorldmapMain_GetWorldmapNodeType().viliage == typeIndex then
      FGlobal_WorldmapMain_EraseAllEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().viliage)
      self:toNextProgress()
    end
  elseif 5 == self._currentProgress and FGlobal_WorldmapMain_GetWorldmapNodeType().city == typeIndex then
    FGlobal_WorldmapMain_EraseAllEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().city)
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eventCallStep1ClickedGrandWorldmapGotoNodeFocus(resultIndex)
  if 6 == self._currentProgress then
    FGlobal_WorldmapMain_EraseAllEffectNodeTypeRadioButton(FGlobal_WorldmapMain_GetWorldmapNodeType().city)
    self:eraseAllEffectAllSearchResultUi()
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eventCallStep1MouseLUpBubble()
  if 7 == self._currentProgress then
    self:toNextStep()
  else
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:changeStep2()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_79"), "", false, getScreenSizeX() * 0.6, getScreenSizeY() * 0.2, false)
    end)
  elseif 2 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_80"), "", false, getScreenSizeX() * 0.6, getScreenSizeY() * 0.2, false)
    end)
    self:eraseAllEffectAllModeButton()
    self:setEffectAllModeButton()
  elseif 3 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_81"), "", false, getScreenSizeX() * 0.6, getScreenSizeY() * 0.2, false)
    end)
    self:eraseAllEffectAllModeButton()
    self:eraseAllEffectAllCheckButton()
    self:setEffectAllCheckButton()
  elseif 4 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_82") .. string.format([[
%.2f

]], self._longWaitTime - self._updateTime) .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_83"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_84"), false, getScreenSizeX() * 0.6, getScreenSizeY() * 0.2, true)
    end)
  elseif 5 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_85"), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
    self:eraseAllEffectAllModeButton()
    self:eraseAllEffectAllCheckButton()
  elseif 6 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_86"), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif -1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_87"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_88"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5, true)
    end)
  elseif -2 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_43"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_44"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5, true)
    end)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:updateStep2(deltaTime)
  if 4 == self._currentProgress then
    if self._longWaitTime * timeRatio < self._updateTime then
      self._updateTime = 0
      self._longWaitTime = 20
      self:toNextProgress()
    end
    self:handleChangeStep(self._currentProgress)
    self._updateTime = self._updateTime + deltaTime
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eventCallStep2WorldMapOpenComplete()
  if -1 == self._currentProgress then
    self._currentProgress = self._prevProgress
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eventCallStep2WorldMapImmediatelyClose()
  if 1 <= self._currentProgress and self._currentProgress <= 4 then
    self._prevProgress = self._currentProgress
    self._currentProgress = -1
    self:handleChangeStep(self._currentStep)
  elseif -2 == self._currentProgress then
    self._currentProgress = -1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eventCallStep2NodeLClick(uiNodeButton)
  if 1 <= self._currentProgress and self._currentProgress <= 4 then
    self._prevProgress = self._currentProgress
    self._currentProgress = -2
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eventCallStep2ResetTownMode()
  if -2 == self._currentProgress then
    self._currentProgress = self._prevProgress
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:eventCallStep2MouseLUpBubble()
  if 6 == self._currentProgress then
    self:endPhase()
  else
    if 3 == self._currentProgress then
      self:eraseAllEffectAllModeButton()
      self:eraseAllEffectAllCheckButton()
      self:setEffectAllModeButton()
      self:setEffectAllCheckButton()
    end
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:handleWorldMapOpenComplete()
  if 1 == self._currentStep then
    self:eventCallStep1WorldMapOpenComplete()
  elseif 2 == self._currentStep then
    self:eventCallStep2WorldMapOpenComplete()
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:handleWorldMapImmediatelyClose()
  if 1 == self._currentStep then
    self:eventCallStep1WorldMapImmediatelyClose()
  elseif 2 == self._currentStep then
    self:eventCallStep2WorldMapImmediatelyClose()
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:handleWorldmapMainEventTempControl()
  if 1 == self._currentStep then
    self:eventCallStep1WorldmapMainEventTempControl()
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:handleClickedGrandWorldMapSearchNodeType(typeIndex)
  if 1 == self._currentStep then
    self:eventCallStep1ClickedGrandWorldMapSearchNodeType(typeIndex)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:handleClickedGrandWorldmapGotoNodeFocus(resultIndex)
  if 1 == self._currentStep then
    self:eventCallStep1ClickedGrandWorldmapGotoNodeFocus(resultIndex)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:handleLClickWorldMapNode(uiNodeButton)
  if 1 == self._currentStep then
    self:eventCallStep1NodeLClick(uiNodeButton)
  elseif 2 == self._currentStep then
    self:eventCallStep2NodeLClick(uiNodeButton)
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:handleResetTownMode()
  if 1 == self._currentStep then
    self:eventCallStep1ResetTownMode()
  elseif 2 == self._currentStep then
    self:eventCallStep2ResetTownMode()
  end
end
function PaGlobal_TutorialPhase_WorldmapMenu:handleMouseLUpBubble()
  if 1 == self._currentStep then
    self:eventCallStep1MouseLUpBubble()
  elseif 2 == self._currentStep then
    self:eventCallStep2MouseLUpBubble()
  end
end

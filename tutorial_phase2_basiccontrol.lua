PaGlobal_TutorialPhase_BasicControl = {
  _phaseNo = 2,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 1,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = true,
  _regionKeyRawList = {88, 349},
  _startLimitLevel = 15
}
local uiRotateArrow = UI.getChildControl(Panel_Tutorial, "Static_RotateArrow")
local uiCtrlGuide = UI.getChildControl(Panel_Tutorial, "Static_CtrlGuide")
local uiClickButton = UI.getChildControl(Panel_Tutorial, "StaticText_ClickButton")
local function setPosClickButton(posX, posY)
  local uiClickButtonSizeX = uiClickButton:GetSizeX()
  local uiClickButtonSizeY = uiClickButton:GetSizeY()
  uiClickButton:SetPosX(posX - uiClickButtonSizeX * 0.5)
  uiClickButton:SetPosY(posY - uiClickButtonSizeY * 0.5)
end
function PaGlobal_TutorialPhase_BasicControl:checkPossibleForPhaseStart(stepNo)
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
function PaGlobal_TutorialPhase_BasicControl:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_BasicControl:startPhase(stepNo)
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
function PaGlobal_TutorialPhase_BasicControl:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_BasicControl:startPhase()")
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  FGlobal_NewQuickSlot_Update()
  ToClient_DeleteNaviGuideByGroup()
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
  PaGlobal_TutorialManager:setAllowShowQuickSlot(false)
  PaGlobal_TutorialManager:setAllowNewQuickSlot(false)
  PaGlobal_TutorialManager:setAllowMainQuestWidget(false)
  PaGlobal_TutorialUiManager:setShowAllDefaultUi(false)
  PaGlobal_TutorialUiManager:getUiKeyButton():setShowAll(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:repositionScreen()
  Panel_Tutorial:SetShow(true, true)
end
function PaGlobal_TutorialPhase_BasicControl:endPhase()
  self._currentStep = 0
  self._nextStep = 1
  uiRotateArrow:SetShow(false)
  uiCtrlGuide:SetShow(false)
  uiClickButton:SetShow(false)
  PaGlobal_TutorialManager:startNextPhase()
end
local result, currentInputMode
function PaGlobal_TutorialPhase_BasicControl:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
  if 1 == self._currentStep then
    result = self:updateLookAround(deltaTime)
  elseif 2 == self._currentStep then
    result = self:updateClickButton(deltaTime)
  elseif 3 == self._currentStep then
    result = self:updateWaitMinimapComment(deltaTime)
  end
  if true == result then
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_BasicControl:handleChangeStep(currentStep)
  if 1 == currentStep then
    self:changeStepLookAround()
  elseif 2 == currentStep then
    self:changeStepClickButton()
  elseif 3 == currentStep then
    self:changeStepWaitMinimapComment()
  elseif 4 == currentStep then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_BasicControl:changeStepLookAround()
  PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_60"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_61"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
  end)
  uiRotateArrow:SetAlpha(0)
  uiRotateArrow:SetShow(true)
  uiRotateArrow:SetPosX(getScreenSizeX() * 0.5 - uiRotateArrow:GetSizeX() * 0.5)
  uiRotateArrow:SetPosY(getScreenSizeY() * 0.475 - uiRotateArrow:GetSizeX() * 0.5)
  UIAni.AlphaAnimation(1, uiRotateArrow, 0, 0.75)
end
function PaGlobal_TutorialPhase_BasicControl:updateLookAround(deltaTime)
  if 8 * timeRatio < self._updateTime then
    audioPostEvent_SystemUi(4, 12)
    self._updateTime = 0
    return true
  end
  self._updateTime = self._updateTime + deltaTime
  return false
end
function PaGlobal_TutorialPhase_BasicControl:changeStepClickButton()
  if 1 == self._currentProgress then
    uiRotateArrow:SetShow(false)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_62"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_63"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
    uiCtrlGuide:SetAlpha(0)
    UIAni.AlphaAnimation(1, uiCtrlGuide, 0, 0.75)
    uiCtrlGuide:SetShow(true)
    uiCtrlGuide:SetPosX(getScreenSizeX() * 0.85 - uiCtrlGuide:GetSizeX() * 0.5)
    uiCtrlGuide:SetPosY(getScreenSizeY() * 0.8 - uiCtrlGuide:GetSizeY() * 0.5)
    uiClickButton:SetAlpha(0)
    uiClickButton:SetShow(true)
    UIAni.AlphaAnimation(1, uiClickButton, 0, 1.5)
    setPosClickButton(getScreenSizeX() * 0.5, getScreenSizeY() * 0.5)
    uiClickButton:SetText("1 / 3")
    uiClickButton:addInputEvent("Mouse_LUp", "PaGlobal_TutorialPhase_BasicControl:handleMouseLUp_PracticeButton()")
  elseif 2 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_64"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_65"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
    setPosClickButton(getScreenSizeX() * 0.5 - 150, getScreenSizeY() * 0.5 - 150)
    uiClickButton:SetAlpha(0)
    UIAni.AlphaAnimation(1, uiClickButton, 0, 0.5)
    uiClickButton:SetText("2 / 3")
  elseif 3 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_66"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_67"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
    setPosClickButton(FGlobal_Panel_Radar_GetPosX() + FGlobal_Panel_Radar_GetSizeX() * 0.5, FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() * 0.5)
    uiClickButton:SetAlpha(0)
    UIAni.AlphaAnimation(1, uiClickButton, 0, 0.5)
    uiClickButton:SetText("3 / 3")
  end
end
local isUiMode
function PaGlobal_TutorialPhase_BasicControl:updateClickButton(deltaTime)
  currentInputMode = UI.Get_ProcessorInputMode()
  isUiMode = CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode == currentInputMode
  if true == isUiMode then
    PaGlobal_TutorialUiManager:getUiMasking():showSpiritMasking()
  elseif false == isUiMode then
    PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
  end
  return false
end
function PaGlobal_TutorialPhase_BasicControl:changeStepWaitMinimapComment()
  PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_86"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_87"), false, FGlobal_Panel_Radar_GetPosX(), FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY())
  end)
  UIAni.AlphaAnimation(0, uiClickButton, 0, 0.25)
  PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
  FGlobal_Panel_Radar_Show_AddEffect()
  Panel_TimeBar:SetShow(true)
end
function PaGlobal_TutorialPhase_BasicControl:updateWaitMinimapComment(deltaTime)
  if 6 * timeRatio < self._updateTime + deltaTime then
    self._updateTime = 0
    return true
  end
  self._updateTime = self._updateTime + deltaTime
  return false
end
function PaGlobal_TutorialPhase_BasicControl:handleMouseLUp_PracticeButton()
  audioPostEvent_SystemUi(4, 12)
  self._currentProgress = self._currentProgress + 1
  self:handleChangeStep(self._currentStep)
  if self._currentProgress > 3 then
    UIAni.AlphaAnimation(0, uiCtrlGuide, 0, 0.75)
    self._currentProgress = 1
    self._nextStep = self._nextStep + 1
  end
end

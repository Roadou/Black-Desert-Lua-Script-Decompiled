PaGlobal_TutorialPhase_WallRiding = {
  _phaseNo = 20,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 0,
  _prevProgress = 2,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = true,
  _regionKeyRawList = {41},
  _questData = {
    [1] = {_questGroupNo = 658, _questId = 8}
  }
}
local uiWallRidingGuideImage = UI.getChildControl(Panel_Tutorial, "Static_KeyTutorialImage")
local function setQuestIconGuideImage(posX, posY)
  local uiWallRidingGuideImageSizeX = uiWallRidingGuideImage:GetSizeX()
  local uiWallRidingGuideImageSizeY = uiWallRidingGuideImage:GetSizeY()
  uiWallRidingGuideImage:SetPosX(posX - uiWallRidingGuideImageSizeX * 0.5)
  uiWallRidingGuideImage:SetPosY(posY - uiWallRidingGuideImageSizeY * 0.5)
end
function PaGlobal_TutorialPhase_WallRiding:checkPossibleForPhaseStart(stepNo)
  if false == self._isPhaseOpen then
    _PA_LOG("\236\161\176\236\158\172\236\155\144", "\237\138\156\237\134\160\235\166\172\236\150\188 Phase\234\176\128 \235\139\171\237\152\128\236\158\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    _PA_LOG("\236\161\176\236\158\172\236\155\144", "\237\138\156\237\134\160\235\166\172\236\150\188 \236\139\156\236\158\145 \234\176\128\235\138\165 \236\151\172\235\182\128 \234\178\128\236\130\172\236\164\145\236\151\144 selfPlayer\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164! _phaseNo : " .. tostring(self._phaseNo))
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
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188\236\157\180 \234\176\128\235\138\165\237\149\156 \236\167\128\236\151\173(\235\167\136\235\178\149\236\130\172\236\157\152 \236\160\156\235\139\168)\236\157\180 \236\149\132\235\139\136\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\164\237\150\137\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  if true == questList_isClearQuest(self._questData[1]._questGroupNo, self._questData[1]._questId) then
    _PA_LOG("\236\161\176\236\158\172\236\155\144", "_questGroupNo" .. tostring(self._questData[1]._questGroupNo) .. "_questId" .. tostring(self._questData[1]._questId) .. "\235\165\188 \236\153\132\235\163\140\237\149\152\236\151\172 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\167\132\237\150\137\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164.")
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_WallRiding:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_WallRiding:startPhase(stepNo)
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
function PaGlobal_TutorialPhase_WallRiding:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\236\161\176\236\158\172\236\155\144", "PaGlobal_TutorialPhase_WallRiding:startStep() stepNo : " .. tostring(stepNo) .. " typeNo : " .. tostring(typeNo))
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
function PaGlobal_TutorialPhase_WallRiding:endPhase()
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialManager:endTutorial()
end
function PaGlobal_TutorialPhase_WallRiding:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WallRiding:handleChangeStep(currentStep)
  if 1 == self._currentStep then
    self:changeStep1()
  end
end
function PaGlobal_TutorialPhase_WallRiding:toNextProgress()
  self._currentProgress = self._currentProgress + 1
  self:handleChangeStep(self._currentStep)
end
function PaGlobal_TutorialPhase_WallRiding:toNextStep()
  self._currentProgress = 1
  self._nextStep = self._nextStep + 1
end
function PaGlobal_TutorialPhase_WallRiding:progressException(processNo)
  self._currentProgress = processNo
end
function PaGlobal_TutorialPhase_WallRiding:changeStep1()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_71"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_72"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 2 == self._currentProgress then
    setQuestIconGuideImage(getScreenSizeX() * 0.5, getScreenSizeY() * 0.5)
    uiWallRidingGuideImage:SetAlpha(0.5)
    uiWallRidingGuideImage:SetShow(true)
    UIAni.AlphaAnimation(1, uiWallRidingGuideImage, 0, 1.5)
    uiWallRidingGuideImage:SetIgnore(false)
    uiWallRidingGuideImage:addInputEvent("Mouse_LUp", "PaGlobal_TutorialPhase_WallRiding:handleMouseLUp_QuestIconGuideImage()")
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_73"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_74"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 320)
    end)
  elseif 3 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_75"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_A_76"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  end
end
function PaGlobal_TutorialPhase_WallRiding:eventCallStep1RegionChanged(regionInfo)
  local currentRegionKey = regionInfo:getRegionKey()
  for index, value in pairs(self._regionKeyRawList) do
    if value ~= currentRegionKey then
      self:endPhase()
      return
    end
  end
end
function PaGlobal_TutorialPhase_WallRiding:eventCallStep1MouseLUpBubble()
  if 1 == self._currentProgress then
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_WallRiding:eventCallStep1EventQuestUpdateNotify()
  if true == PaGlobal_TutorialManager:isSatisfiedQuestCondition(self._questData[1]._questGroupNo, self._questData[1]._questId) then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_WallRiding:handleMouseLUp_QuestIconGuideImage()
  uiWallRidingGuideImage:SetIgnore(true)
  local aniInfo = UIAni.AlphaAnimation(0, uiWallRidingGuideImage, 0, 0.25)
  aniInfo:SetHideAtEnd(true)
  self:toNextProgress()
end
function PaGlobal_TutorialPhase_WallRiding:handleRegionChanged(regionInfo)
  self:eventCallStep1RegionChanged(regionInfo)
end
function PaGlobal_TutorialPhase_WallRiding:handleMouseLUpBubble()
  if 1 == self._currentStep then
    self:eventCallStep1MouseLUpBubble()
  end
end
function PaGlobal_TutorialPhase_WallRiding:handleQuestWidgetUpdate()
  self:eventCallStep1EventQuestUpdateNotify()
end

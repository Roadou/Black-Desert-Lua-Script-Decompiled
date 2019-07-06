PaGlobal_TutorialPhase_Hidel_Trade = {
  _phaseNo = 14,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 0,
  _prevProgress = 1,
  _updateTime = 0,
  _isPhaseOpen = false,
  _isSkippable = true,
  _regionKeyRawList = {
    32,
    38,
    42,
    62,
    318
  },
  _waypointKeyData = {
    [1] = 323
  },
  _talkerCharacterKeyData = {
    [1] = 41085
  },
  _questData = {
    [1] = {_questGroupNo = 2039, _questId = 2}
  }
}
local isSatisfiedCondition = false
function PaGlobal_TutorialPhase_Hidel_Trade:checkPossibleForPhaseStart(stepNo)
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
  local explorePoint = ToClient_getExplorePointByTerritoryRaw(ToClient_getDefaultTerritoryKey())
  if nil == explorePoint then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "explorePoint\234\176\128 nil \236\158\133\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  if explorePoint:getRemainedPoint() < 2 then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\234\179\181\237\151\140\235\143\132\234\176\128 \235\182\128\236\161\177\237\149\180\236\132\156 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. : _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_Hidel_Trade:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_Hidel_Trade:startPhase(stepNo)
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
function PaGlobal_TutorialPhase_Hidel_Trade:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_Hidel_Trade:startStep() stepNo : " .. tostring(stepNo) .. " typeNo : " .. tostring(typeNo))
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  self._prevProgress = 1
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
function PaGlobal_TutorialPhase_Hidel_Trade:endPhase()
  FGlobal_WorldmapMain_SetAllowTutorialPanelShow(false)
  if false == _ContentsGroup_NewUI_Dialog_All then
    FGlobal_Dialog_SetAllowTutorialPanelShow(false)
  else
    PaGlobalFunc_DialogMain_All_SetAllowTutorialPanelShow(false)
  end
  FGlobal_NodeMenu_SetEnableNodeUnlinkButton(true)
  if false == _ContentsGroup_NewUI_Dialog_All then
    local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Shop)
    FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
    FGlobal_EraseAllEffect_ExitButton()
  else
    local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType()
  end
  PaGlobal_TutorialUiBlackSpirit:setIgnoreBubble(true)
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialManager:endTutorial()
end
function PaGlobal_TutorialPhase_Hidel_Trade:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:handleChangeStep(currentStep)
  if 1 == self._currentStep then
    self:changeStep1()
  elseif 2 == self._currentStep then
    self:changeStep2()
  elseif 3 == self._currentStep then
    self:changeStep3()
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:toNextProgress()
  self._currentProgress = self._currentProgress + 1
  self:handleChangeStep(self._currentStep)
end
function PaGlobal_TutorialPhase_Hidel_Trade:toNextStep()
  self._currentProgress = 1
  self._nextStep = self._nextStep + 1
end
function PaGlobal_TutorialPhase_Hidel_Trade:toStep(destStep, destProgress)
  self._nextStep = destStep
  if nil == destProgress then
    self._currentProgress = 1
  else
    self._currentProgress = destProgress
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:addEffectUiNodeButtonByWaypointKey(waypointKey)
  local uiNodeButton = ToClient_FindNodeButtonByWaypointKey(waypointKey)
  if nil ~= uiNodeButton then
    uiNodeButton:EraseAllEffect()
    uiNodeButton:AddEffect("UI_ArrowMark02", true, 0, -50)
    uiNodeButton:AddEffect("UI_WorldMap_Ping01", true, 0, 0)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eraseAllEffectUiNodeButtonByWaypointKey(waypointKey)
  local uiNodeButton = ToClient_FindNodeButtonByWaypointKey(waypointKey)
  if nil ~= uiNodeButton then
    uiNodeButton:EraseAllEffect()
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:setEffectDialogButtonByType(funcButtonType)
  local funcButtonIndex
  if false == _ContentsGroup_NewUI_Dialog_All then
    funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(funcButtonType)
    if -1 == funcButtonIndex then
      return false
    end
    FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
    FGlobal_AddEffect_DialogButton(funcButtonIndex, "UI_ArrowMark02", true, 0, -50)
  else
    funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(funcButtonType)
    if -1 == funcButtonIndex then
      return false
    end
  end
  return true
end
function PaGlobal_TutorialPhase_Hidel_Trade:isInvestedContributePoint(waypointKey)
  if true == isExploreUpgradable(waypointKey) then
    if true == isWithdrawablePlant(waypointKey) then
      return true
    elseif false == isWithdrawablePlant(waypointKey) then
      return false
    end
  end
  return false
end
function PaGlobal_TutorialPhase_Hidel_Trade:changeStep1()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\152\164? \235\132\136 \234\183\184\234\177\176 \234\179\160\235\140\128\236\157\152 \236\178\160\236\163\188\237\153\148\236\158\150\236\149\132?\n\234\183\184\235\159\176\234\177\180 \236\131\129\236\160\144\236\151\144 \234\183\184\235\131\165 \237\140\148 \236\136\152 \236\151\134\235\138\148 \235\172\188\234\177\180\236\157\184\235\141\176.", "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 2 == self._currentProgress then
    FGlobal_WorldmapMain_SetAllowTutorialPanelShow(true)
    self._updateTime = 0
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\157\180 \236\163\188\237\153\148\235\165\188 \235\139\164\235\165\184 \236\167\128\236\151\173\236\156\188\235\161\156 \234\176\128\236\132\156 \237\140\144\235\167\164\237\149\180\235\179\180\236\158\144.", "<M>\237\130\164\235\165\188 \235\136\140\235\159\172\236\132\156 \236\155\148\235\147\156\235\167\181\236\157\132 \236\151\180\236\150\180\235\180\144.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif 3 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\237\145\156\236\139\156\235\144\156 \235\170\168\235\160\136\237\139\176 \234\177\176\235\140\128 \235\134\141\236\158\165\236\157\180 \235\179\180\236\157\180\236\167\128?", "\235\170\168\235\160\136\237\139\176 \234\177\176\235\140\128 \235\134\141\236\158\165 \234\177\176\236\160\144\236\157\132 \236\154\176\237\129\180\235\166\173 \237\149\180\235\180\144.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif 4 == self._currentProgress then
    FGlobal_WorldmapMain_SetAllowTutorialPanelShow(false)
    self:eraseAllEffectUiNodeButtonByWaypointKey(self._waypointKeyData[1])
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\158\152\237\150\136\236\150\180. \235\170\169\236\160\129\236\167\128\235\165\188 \236\176\190\236\149\132\234\176\128\235\160\164\235\169\180 \236\155\148\235\147\156\235\167\181\236\157\132 \235\139\171\236\149\132\236\149\188\234\178\160\236\167\128?", "\236\157\180\235\143\153\237\149\180\236\149\188\237\149\152\235\139\136\234\185\140 <ESC>\235\130\152 <M>\237\130\164\235\165\188 \235\136\140\235\159\172 \236\155\148\235\147\156\235\167\181\236\157\132 \235\139\171\236\149\132.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif -1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_41"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_42"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5, true)
    end)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep1WorldMapOpen()
  if 2 == self._currentProgress then
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep1WorldMapOpenComplete()
  if 3 == self._currentProgress then
    self:addEffectUiNodeButtonByWaypointKey(self._waypointKeyData[1])
  elseif -1 == self._currentProgress then
    self._currentProgress = self._prevProgress
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep1WorldMapImmediatelyClose()
  if 3 == self._currentProgress then
    self._prevProgress = self._currentProgress
    self._currentProgress = -1
    self:handleChangeStep(self._currentStep)
  elseif 4 == self._currentProgress then
    if true == self:isInvestedContributePoint(self._waypointKeyData[1]) then
      self:toStep(3)
    else
      self:toNextStep()
    end
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep1ResetTownMode()
  if 3 <= self._currentProgress and self._currentProgress <= 4 then
    self:addEffectUiNodeButtonByWaypointKey(self._waypointKeyData[1])
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep1RClickWorldMapNode(uiNodeButton)
  if 3 == self._currentProgress and self._waypointKeyData[1] == uiNodeButton:getWaypointKey() then
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep1BeforeShowDialog()
  if self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
    if false == _ContentsGroup_NewUI_Dialog_All then
      FGlobal_Dialog_SetAllowTutorialPanelShow(true)
    else
      PaGlobalFunc_DialogMain_All_SetAllowTutorialPanelShow(true)
    end
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    FGlobal_Dialog_SetAllowTutorialPanelShow(false)
  else
    PaGlobalFunc_DialogMain_All_SetAllowTutorialPanelShow(false)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep1ShowDialog(dialogData)
  if self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
    if true == self:isInvestedContributePoint(self._waypointKeyData[1]) then
      self:toStep(3, 2)
      self:eventCallStep3ShowDialog(dialogData)
    else
      self:toStep(2, 2)
      self:eventCallStep2ShowDialog(dialogData)
    end
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep1CheckQuestCondition()
  if false == isSatisfiedCondition then
    local isSatisfy = PaGlobal_TutorialManager:isSatisfiedQuestCondition(self._questData[1]._questGroupNo, self._questData[1]._questId)
    if true == isSatisfy then
      isSatisfiedCondition = true
      audioPostEvent_SystemUi(4, 12)
      self:endPhase()
    end
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep1MouseLUpBubble()
  if 4 == self._currentProgress then
    self:toNextStep()
  else
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:changeStep2()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\234\184\184\236\149\136\235\130\180\235\165\188 \235\148\176\235\157\188\234\176\128\235\169\180 <\237\131\144\237\151\152 \234\177\176\236\160\144 \234\180\128\235\166\172\236\158\144>\235\169\148\235\165\180\236\139\156\236\149\136\235\138\144 \235\170\168\235\160\136\237\139\176 \236\151\144\234\178\140 \235\143\132\235\139\172\237\149\152\234\178\140 \235\144\160\234\177\176\236\149\188.", "\234\184\184\236\149\136\235\130\180\235\165\188 \235\148\176\235\157\188 \235\140\128\236\131\129\236\157\132 \236\176\190\236\149\132 \235\167\144\236\157\132 \234\177\184\236\150\180\235\179\180\236\158\144.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif 2 == self._currentProgress then
    FGlobal_WorldmapMain_SetAllowTutorialPanelShow(true)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\235\172\180\236\151\173\236\157\132 \237\149\152\234\184\176 \236\160\132\236\151\144 \234\177\176\236\160\144\236\157\132 \234\180\128\235\166\172\235\165\188 \237\149\180\235\179\180\236\158\144.", "\235\140\128\237\153\148\235\169\148\235\137\180\236\164\145\236\151\144 '\237\131\144\237\151\152 \234\177\176\236\160\144 \234\180\128\235\166\172'\235\178\132\237\138\188\236\157\132 \235\136\140\235\159\172\235\180\144.", false, getScreenSizeX() * 0.55, getScreenSizeY() * 0.45, true)
    end)
  elseif 3 == self._currentProgress then
    do
      local positionTarget = UI.getChildControl(Panel_NodeMenu, "MainMenu_Bg")
      PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
        PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\235\172\180\236\151\173\236\157\128 \235\172\188\237\146\136\236\157\152 \236\155\144\236\130\176\236\167\128 \234\177\176\236\160\144\234\179\188 \237\140\144\235\167\164\237\149\160 \234\177\176\236\160\144\236\157\180 \236\151\176\234\178\176 \235\144\152\236\150\180 \236\158\136\236\150\180\236\149\188 \236\160\156\234\176\146\236\157\132 \235\176\155\236\149\132.\n\234\177\176\236\160\144\236\157\132 \236\151\176\234\178\176\237\149\152\234\179\160 \236\139\182\236\156\188\235\169\180 \234\179\181\237\151\140\235\143\132\235\165\188 \237\136\172\236\158\144\237\149\180\236\149\188\235\143\188.", "\236\153\188\236\170\189 \236\156\132\236\151\144 \237\145\156\236\139\156\235\144\156 '\234\179\181\237\151\140\235\143\132 \237\136\172\236\158\144'\235\178\132\237\138\188\236\157\132 \235\136\140\235\159\172\235\179\180\236\158\144.", false, positionTarget:GetPosX() + positionTarget:GetSizeX() * 2, positionTarget:GetPosY() + positionTarget:GetSizeY() * 0.5, true)
      end)
    end
  elseif 4 == self._currentProgress then
    while true == ToClient_isTownMode() do
      FGlobal_WorldMapWindowEscape()
    end
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\157\180\236\160\156 \234\177\176\236\160\144\234\176\132\236\151\144 \236\151\176\234\178\176\235\144\156 \236\132\160\236\157\180 \235\182\137\236\150\180\236\167\132 \234\178\131\236\157\180 \235\179\180\236\157\180\236\167\128?\n\236\157\180\235\160\135\234\178\140 \235\144\152\235\169\180 \235\145\144 \234\177\176\236\160\144\236\157\180 \236\151\176\234\178\176\235\144\156\234\177\176\236\149\188.\n\236\157\180\234\178\131\236\157\180 \235\132\136\236\157\152 \236\178\171 \234\177\176\236\160\144 \236\151\176\234\178\176\236\157\180 \235\144\152\234\178\160\234\181\176.", "\236\157\180\236\160\156 <ESC>\237\130\164\235\130\152 <M>\237\130\164\235\165\188 \235\136\140\235\159\172 \236\155\148\235\147\156\235\167\181\236\157\132 \235\139\171\236\149\132.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep2BeforeShowDialog()
  if self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
    if false == _ContentsGroup_NewUI_Dialog_All then
      FGlobal_Dialog_SetAllowTutorialPanelShow(true)
    else
      PaGlobalFunc_DialogMain_All_SetAllowTutorialPanelShow(true)
    end
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    FGlobal_Dialog_SetAllowTutorialPanelShow(false)
  else
    PaGlobalFunc_DialogMain_All_SetAllowTutorialPanelShow(false)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep2ShowDialog(dialogData)
  if 1 == self._currentProgress then
    if self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
      self:setEffectDialogButtonByType(CppEnums.ContentsType.Contents_Explore)
      self:toNextProgress()
    end
  elseif 2 == self._currentProgress and self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
    self:setEffectDialogButtonByType(CppEnums.ContentsType.Contents_Explore)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep2ClickedExitButton(talker)
  if 2 == self._currentProgress then
    if 0 == dialog_getTalkNpcKey() then
      _PA_LOG("\234\179\189\235\175\188\236\154\176", "\235\140\128\237\153\148\236\164\145\236\157\184 NPC\237\130\164 \234\176\146\236\157\180 0\236\157\180 \235\130\152\236\153\148\235\139\164! NPC\236\160\149\235\179\180\234\176\128 \236\151\134\234\177\176\235\130\152 \236\160\149\236\131\129\236\160\129\236\156\188\235\161\156 \236\160\149\235\179\180\235\165\188 \235\176\155\236\167\128 \235\170\187\237\150\136\236\157\140! _phaseNo : " .. tostring(self._phaseNo))
      return
    end
    self._currentProgress = 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep2ClickedDialogFuncButton(funcButtonType)
  if 2 == self._currentProgress and self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() and CppEnums.ContentsType.Contents_Explore == funcButtonType then
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep2EventUpdateExplorationNode(waypointKey)
  if 3 == self._currentProgress and self._waypointKeyData[1] == waypointKey then
    FGlobal_NodeMenu_SetEnableNodeUnlinkButton(false)
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep2WorldMapImmediatelyClose()
  if self._currentProgress < 4 then
    self._currentProgress = 1
    self:handleChangeStep(self._currentStep)
  elseif 4 == self._currentProgress then
    FGlobal_WorldmapMain_SetAllowTutorialPanelShow(false)
    self:toNextStep()
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep2CheckQuestCondition()
  if false == isSatisfiedCondition then
    local isSatisfy = PaGlobal_TutorialManager:isSatisfiedQuestCondition(self._questData[1]._questGroupNo, self._questData[1]._questId)
    if true == isSatisfy then
      isSatisfiedCondition = true
      audioPostEvent_SystemUi(4, 12)
      self:endPhase()
    end
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:changeStep3()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\157\180\236\160\156 \234\179\160\235\140\128 \236\178\160\236\163\188\237\153\148\235\165\188 \237\140\144\235\167\164\237\149\152\235\159\172 \234\176\128\235\179\180\236\158\144.", "'\235\169\148\235\165\180\236\139\156\236\149\136\235\138\144 \235\170\168\235\160\136\237\139\176'\236\151\144\234\178\140 \234\176\128\236\132\156 \235\167\144\236\157\132 \234\177\184\236\150\180\235\180\144.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
    ToClient_DeleteNaviGuideByGroup()
    worldmapNavigatorStart(float3(73723.8, -1352.55, -70902.8), NavigationGuideParam(), false, false, true)
  elseif 2 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\234\179\160\235\140\128 \236\178\160\236\163\188\237\153\148\235\165\188 \237\140\144\235\167\164\237\149\180 \235\179\188\234\177\176\236\149\188.", "\235\140\128\237\153\148\235\169\148\235\137\180\236\164\145\236\151\144 '\235\172\180\236\151\173'\235\178\132\237\138\188\236\157\132 \235\136\140\235\159\172\235\179\180\236\158\144.", false, getScreenSizeX() * 0.3, getScreenSizeY() * 0.45, true)
    end)
  elseif 3 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\235\172\180\236\151\173\237\146\136\236\157\128 \236\139\156\236\139\156\234\176\129\234\176\129 \236\139\156\236\132\184\234\176\128 \235\179\128\237\149\180.\n\234\183\184\234\177\180 \236\153\188\236\170\189 \236\139\156\236\132\184 \237\152\132\237\153\169\237\145\156\236\151\144\236\132\156 \236\158\144\236\132\184\237\158\136 \237\153\149\236\157\184\237\149\160 \236\136\152 \236\158\136\236\167\128.", "", false, Panel_Trade_Market_Graph_Window:GetPosX() + Panel_Trade_Market_Graph_Window:GetSizeX() * 1.1, Panel_Trade_Market_Graph_Window:GetPosY() + Panel_Trade_Market_Graph_Window:GetSizeY() * 0.5, false)
    end)
  elseif 4 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\154\176\236\184\161\236\157\152 \237\140\144\235\167\164 \235\178\132\237\138\188\236\157\132 \235\136\132\235\165\180\235\169\180 \235\172\180\236\151\173\237\146\136\236\157\132 \237\140\144\235\167\164 \237\149\160 \236\136\152 \236\158\136\236\150\180.\n\234\184\176\236\154\180\236\157\180 \235\132\152\236\185\156\235\139\164\235\169\180 \234\176\128\234\178\169 \237\157\165\236\160\149\236\151\144 \235\143\132\236\160\132\237\149\152\235\138\148\234\178\131\235\143\132 \236\162\139\236\149\132.", "", false, Panel_Trade_Market_Graph_Window:GetPosX() + Panel_Trade_Market_Graph_Window:GetSizeX() * 1.1, Panel_Trade_Market_Graph_Window:GetPosY() + Panel_Trade_Market_Graph_Window:GetSizeY() * 0.5, false)
    end)
  elseif 5 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\234\190\184\236\164\128\237\158\136 \236\158\172\236\130\176\236\157\132 \236\140\147\236\149\132\235\179\180\235\157\188\234\179\160.\n\234\183\184\235\159\188 \235\130\152\236\164\145\236\151\144 \235\179\180\236\158\144.", "[\237\138\156\237\134\160\235\166\172\236\150\188 \236\162\133\235\163\140]", false, Panel_Trade_Market_Graph_Window:GetPosX() + Panel_Trade_Market_Graph_Window:GetSizeX() * 1.1, Panel_Trade_Market_Graph_Window:GetPosY() + Panel_Trade_Market_Graph_Window:GetSizeY() * 0.5, false)
    end)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep3BeforeShowDialog()
  if self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
    if false == _ContentsGroup_NewUI_Dialog_All then
      FGlobal_Dialog_SetAllowTutorialPanelShow(true)
    else
      PaGlobalFunc_DialogMain_All_SetAllowTutorialPanelShow(true)
    end
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    FGlobal_Dialog_SetAllowTutorialPanelShow(false)
  else
    PaGlobalFunc_DialogMain_All_SetAllowTutorialPanelShow(false)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep3ShowDialog(dialogData)
  if 1 == self._currentProgress then
    if self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
      self:setEffectDialogButtonByType(CppEnums.ContentsType.Contents_Shop)
      self:toNextProgress()
    end
  elseif (2 == self._currentProgress or 3 == self._currentProgress) and self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
    self:setEffectDialogButtonByType(CppEnums.ContentsType.Contents_Shop)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep3ClickedDialogFuncButton(funcButtonType)
  if 2 == self._currentProgress and self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() and CppEnums.ContentsType.Contents_Shop == funcButtonType then
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep3ClickedExitButton(talker)
  if 2 == self._currentProgress then
    if 0 == dialog_getTalkNpcKey() then
      _PA_LOG("\234\179\189\235\175\188\236\154\176", "\235\140\128\237\153\148\236\164\145\236\157\184 NPC\237\130\164 \234\176\146\236\157\180 0\236\157\180 \235\130\152\236\153\148\235\139\164! NPC\236\160\149\235\179\180\234\176\128 \236\151\134\234\177\176\235\130\152 \236\160\149\236\131\129\236\160\129\236\156\188\235\161\156 \236\160\149\235\179\180\235\165\188 \235\176\155\236\167\128 \235\170\187\237\150\136\236\157\140! _phaseNo : " .. tostring(self._phaseNo))
      return
    end
    self._currentProgress = 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_FindNearNpc:eventCallStep3ShowDialog(dialogData)
  if 1 == self._currentProgress then
    if 0 == dialog_getTalkNpcKey() then
      _PA_LOG("\234\179\189\235\175\188\236\154\176", "\235\140\128\237\153\148\236\164\145\236\157\184 NPC\237\130\164 \234\176\146\236\157\180 0\236\157\180 \235\130\152\236\153\148\235\139\164! NPC\236\160\149\235\179\180\234\176\128 \236\151\134\234\177\176\235\130\152 \236\160\149\236\131\129\236\160\129\236\156\188\235\161\156 \236\160\149\235\179\180\235\165\188 \235\176\155\236\167\128 \235\170\187\237\150\136\236\157\140!")
      return
    end
    if self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
      self:toNextStep()
    end
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep3CheckQuestCondition()
  if false == isSatisfiedCondition then
    local isSatisfy = PaGlobal_TutorialManager:isSatisfiedQuestCondition(self._questData[1]._questGroupNo, self._questData[1]._questId)
    if true == isSatisfy then
      isSatisfiedCondition = true
      audioPostEvent_SystemUi(4, 12)
      self:endPhase()
    end
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:eventCallStep3MouseLUpBubble()
  if 5 == self._currentProgress then
    self:endPhase()
  else
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:handleRegionChanged(regionInfo)
end
function PaGlobal_TutorialPhase_Hidel_Trade:handleQuestWidgetUpdate()
  if 1 == self._currentStep then
    self:eventCallStep1CheckQuestCondition()
  elseif 2 == self._currentStep then
    self:eventCallStep2CheckQuestCondition()
  elseif 3 == self._currentStep then
    self:eventCallStep3CheckQuestCondition()
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:handleBeforeWorldmapOpen()
  if 1 == self._currentStep then
    self:eventCallStep1WorldMapOpen()
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:handleWorldMapOpenComplete()
  if 1 == self._currentStep then
    self:eventCallStep1WorldMapOpenComplete()
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:handleWorldMapImmediatelyClose()
  if 1 == self._currentStep then
    self:eventCallStep1WorldMapImmediatelyClose()
  elseif 2 == self._currentStep then
    self:eventCallStep2WorldMapImmediatelyClose()
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:handleResetTownMode()
  if 1 == self._currentStep then
    self:eventCallStep1ResetTownMode()
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:handleRClickWorldMapNode(uiNodeButton)
  if 1 == self._currentStep then
    self:eventCallStep1RClickWorldMapNode(uiNodeButton)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:handleBeforeShowDialog()
  if 1 == self._currentStep then
    self:eventCallStep1BeforeShowDialog()
  elseif 2 == self._currentStep then
    self:eventCallStep2BeforeShowDialog()
  elseif 3 == self._currentStep then
    self:eventCallStep3BeforeShowDialog()
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:handleShowDialog(dialogData)
  if 1 == self._currentStep then
    self:eventCallStep1ShowDialog(dialogData)
  elseif 2 == self._currentStep then
    self:eventCallStep2ShowDialog(dialogData)
  elseif 3 == self._currentStep then
    self:eventCallStep3ShowDialog(dialogData)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:handleClickedDialogFuncButton(funcButtonType)
  if 2 == self._currentStep then
    self:eventCallStep2ClickedDialogFuncButton(funcButtonType)
  elseif 3 == self._currentStep then
    self:eventCallStep3ClickedDialogFuncButton(funcButtonType)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:handleClickedExitButton(talker)
  if 2 == self._currentStep then
    self:eventCallStep2ClickedExitButton(talker)
  elseif 3 == self._currentStep then
    self:eventCallStep3ClickedExitButton(talker)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:handleEventUpdateExplorationNode(waypointKey)
  if 2 == self._currentStep then
    self:eventCallStep2EventUpdateExplorationNode(waypointKey)
  end
end
function PaGlobal_TutorialPhase_Hidel_Trade:handleMouseLUpBubble()
  if 1 == self._currentStep then
    self:eventCallStep1MouseLUpBubble()
  elseif 3 == self._currentStep then
    self:eventCallStep3MouseLUpBubble()
  end
end

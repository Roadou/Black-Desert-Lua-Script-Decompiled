PaGlobal_TutorialPhase_InteractionSupplyBox = {
  _phaseNo = 3,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 1,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = true,
  _regionKeyRawList = {9},
  _startLimitLevel = 15,
  _destination = {
    [0] = float3(-61741.2, -3875.45, 47009.27),
    [1] = float3(-63456.71, -3841.63, 47345.69),
    [2] = float3(-61741.2, -3875.45, 47009.27),
    [3] = float3(-61320.2, -3828.62, 47866.29)
  }
}
local eventID = PaGlobal_TutorialEventList
local supplyBoxCharacterKey = 35634
local beginnerPotion = 502
local navigationGuideParam
function PaGlobal_TutorialPhase_InteractionSupplyBox:setState(state)
  self._state = state
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:getState()
  return self._state
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:checkPossibleForPhaseStart(stepNo)
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
function PaGlobal_TutorialPhase_InteractionSupplyBox:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:startPhase(stepNo)
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
function PaGlobal_TutorialPhase_InteractionSupplyBox:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_InteractionSupplyBox:startPhase()")
  self._currentStep = stepNo
  self._currentProgress = 1
  self._updateTime = 0
  ToClient_DeleteNaviGuideByGroup()
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:repositionScreen()
  Panel_Tutorial_Renew:SetShow(true, true)
  self:setState(PaGlobal_TutorialState.eState_Start)
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:endPhase()
  self._currentStep = 0
  self._nextStep = 1
  self._updateTime = 0
  PaGlobal_TutorialManager:startNextPhase()
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:updatePerFrame(deltaTime)
  self:handleStep(deltaTime)
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:handleStep(deltaTime)
  if 1 == self._currentStep then
    self:Step01_MoveDestination(deltaTime)
  elseif 2 == self._currentStep then
    self:Step02_CheckInteraction(deltaTime)
  elseif 3 == self._currentStep then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:Step01_MoveDestination(deltaTime)
  local currentState = self:getState()
  if PaGlobal_TutorialState.eState_Start == currentState then
    self:Step01_Prepare()
  elseif PaGlobal_TutorialState.eState_Do == currentState then
    self:Step01_DoStep(deltaTime)
  elseif PaGlobal_TutorialState.eState_Done == currentState then
    self:Step01_Done()
  end
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:Step01_Prepare()
  self:setState(PaGlobal_TutorialState.eState_Do)
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:Step01_DoStep(deltaTime)
  navigationGuideParam = NavigationGuideParam()
  if 1 == self._currentProgress then
    pathfindResult = worldmapNavigatorStart(self._destination[0], navigationGuideParam, false, false, true)
    FGlobal_Panel_Radar_Show_AddEffect()
    local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_90") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_91")
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
    self._currentProgress = self._currentProgress + 1
    PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_DeleteNavigationGuide, function()
      _AudioPostEvent_SystemUiForXBOX(4, 12)
      self._currentProgress = self._currentProgress + 1
    end)
    if -1 == pathfindResult then
      self._currentProgress = self._currentProgress + 1
    end
  elseif 2 == self._currentProgress then
  elseif 3 == self._currentProgress then
    pathfindResult = worldmapNavigatorStart(self._destination[1], navigationGuideParam, false, false, true)
    local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_92") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_91")
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
    self._currentProgress = self._currentProgress + 1
    if -1 == pathfindResult then
      self._currentProgress = self._currentProgress + 1
    end
  elseif 4 == self._currentProgress then
  elseif 5 == self._currentProgress then
    pathfindResult = worldmapNavigatorStart(self._destination[2], navigationGuideParam, false, false, true)
    local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_92") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_93")
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
    self._currentProgress = self._currentProgress + 1
    if -1 == pathfindResult then
      self._currentProgress = self._currentProgress + 1
    end
  elseif 6 == self._currentProgress then
  elseif 7 == self._currentProgress then
    self:setState(PaGlobal_TutorialState.eState_Done)
  end
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:Step01_Done()
  PaGlobal_TutorialManager:ClearEventFunctor()
  self._updateTime = 0
  self._currentProgress = 1
  self._currentStep = self._currentStep + 1
  self:setState(PaGlobal_TutorialState.eState_Start)
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:Step02_CheckInteraction(deltaTime)
  local currentState = self:getState()
  if PaGlobal_TutorialState.eState_Start == currentState then
    self:Step02_Prepare()
  elseif PaGlobal_TutorialState.eState_Do == currentState then
    self:Step02_DoStep(deltaTime)
  elseif PaGlobal_TutorialState.eState_Done == currentState then
    self:Step02_Done()
  end
end
local gainedBeginnerPotion = false
local isFinish = false
function PaGlobal_TutorialPhase_InteractionSupplyBox:Step02_Prepare()
  navigationGuideParam = NavigationGuideParam()
  navigationGuideParam._isAutoErase = false
  worldmapNavigatorStart(self._destination[3], navigationGuideParam, false, false, true)
  PaGlobal_TutorialManager:ClearEventFunctor()
  PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_UpdateInventory, function(param)
    if param._slotItemKey == beginnerPotion then
      gainedBeginnerPotion = true
      isFinish = true
    end
  end)
  PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_ClickExitButton, function(talker)
    if nil ~= talker and talker:getCharacterKey() == supplyBoxCharacterKey then
      Inventory_updateSlotData(true)
      if true == gainedBeginnerPotion then
        self._currentProgress = 2
      end
    end
  end)
  PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_AfterAndPopFlush, function()
    if true == isFinish then
      self._currentProgress = 2
    end
  end)
  self:setState(PaGlobal_TutorialState.eState_Do)
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:Step02_DoStep(deltaTime)
  if 1 == self._currentProgress then
    local currentInteractableActor = interaction_getInteractable()
    local isMatchCharacterKey = false
    if nil ~= currentInteractableActor then
      isMatchCharacterKey = supplyBoxCharacterKey == currentInteractableActor:getCharacterKeyRaw()
    end
    if false == isMatchCharacterKey then
      local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_32") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_68")
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
    else
      local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_36") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_37")
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
    end
  elseif 2 == self._currentProgress then
    local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_53")
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
    PaGlobal_TutorialManager:ClearEventFunctor()
    PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_UpdateQuickSlot, function(quickSlotItemKey)
      if beginnerPotion == quickSlotItemKey then
        self._currentProgress = 4
        PaGlobal_TutorialManager:ClearEventFunctor()
      end
    end)
    self._currentProgress = self._currentProgress + 1
  elseif 3 == self._currentProgress then
  elseif 4 == self._currentProgress then
    self:setState(PaGlobal_TutorialState.eState_Done)
  end
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:Step02_Done()
  PaGlobal_TutorialManager:ClearEventFunctor()
  self._updateTime = 0
  self._currentProgress = 1
  self._currentStep = self._currentStep + 1
  self:setState(PaGlobal_TutorialState.eState_Start)
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:handleAfterAndPopFlush()
  if true == isFinish then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_InteractionSupplyBox:handleDeleteNavigationGuide(key)
  if 1 == self._currentStep then
    self:eventCallDeleteNavigationGuide(key)
  end
end

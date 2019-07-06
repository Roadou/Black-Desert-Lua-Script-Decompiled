PaGlobal_TutorialPhase_InventoryAndQuickSlot = {
  _phaseNo = 4,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 1,
  _returnStep = 0,
  _returnProgress = 0,
  _isPhaseOpen = true,
  _isSkippable = true,
  _regionKeyRawList = {9},
  _startLimitLevel = 5
}
local beginnerPotionItemKey = 502
local enabledEffectSlotInQuickSlot
local eventID = PaGlobal_TutorialEventList
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:setState(state)
  self._state = state
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:getState()
  return self._state
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:checkPossibleForPhaseStart(stepNo)
  if false == self._isPhaseOpen then
    _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "\237\138\156\237\134\160\235\166\172\236\150\188 Phase\234\176\128 \235\139\171\237\152\128\236\158\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "\237\138\156\237\134\160\235\166\172\236\150\188 \236\139\156\236\158\145 \234\176\128\235\138\165 \236\151\172\235\182\128 \234\178\128\236\130\172\236\164\145\236\151\144 selfPlayer\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164! _phaseNo : " .. tostring(self._phaseNo))
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
    _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "\237\138\156\237\134\160\235\166\172\236\150\188\236\157\180 \234\176\128\235\138\165\237\149\156 \236\167\128\236\151\173\236\157\180 \236\149\132\235\139\136\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\164\237\150\137\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  if self._startLimitLevel < getSelfPlayer():get():getLevel() then
    _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "\236\186\144\235\166\173\237\132\176\236\157\152 \235\160\136\235\178\168\236\157\180 " .. tostring(self._startLimitLevel) .. "\235\165\188 \236\180\136\234\179\188\237\150\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\167\132\237\150\137\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:startPhase(stepNo)
  if false == self:checkPossibleForPhaseStart(stepNo) then
    return
  end
  if true == PaGlobal_SummonBossTutorial_Manager:isDoingSummonBossTutorial() then
    PaGlobal_SummonBossTutorial_Manager:endTutorial()
    _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "\237\138\156\237\134\160\235\166\172\236\150\188 phase(" .. tostring(self._phaseNo) .. ")\234\176\128 \235\179\180\236\138\164 \236\134\140\237\153\152 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\162\133\235\163\140\236\139\156\237\130\180! _phaseNo : " .. tostring(self._phaseNo))
  end
  local isSkippable = self:checkSkippablePhase()
  if true == isSkippable and false == PaGlobal_TutorialManager:isDoingTutorial() then
    PaGlobal_TutorialManager:questionPhaseSkip(self, stepNo)
  else
    self:startPhaseXXX(stepNo)
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "PaGlobal_TutorialPhase_InventoryAndQuickSlot:startPhase()")
  self._currentStep = stepNo
  self._currentProgress = 1
  ToClient_DeleteNaviGuideByGroup()
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:repositionScreen()
  Panel_Tutorial_Renew:SetShow(true, true)
  self:setState(PaGlobal_TutorialState.eState_Start)
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:endPhase()
  self._currentStep = 0
  self._nextStep = 1
  PaGlobal_TutorialManager:startNextPhase()
  _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "PaGlobal_TutorialPhase_InventoryAndQuickSlot:startNextPhase()")
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:updatePerFrame(deltaTime)
  self:handleStep(deltaTime)
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:handleStep(deltaTime)
  if 1 == self._currentStep then
    self:Step01_UsePotionInInventory()
  elseif 2 == self._currentStep then
    self:endPhase()
  elseif -1 == self._currentStep then
    self:changeStepExceptionClosedInventory()
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:changeStepExceptionClosedInventory()
  local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_38") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIALXB_TEXT_4")
  PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
  PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:Step01_UsePotionInInventory(deltaTime)
  local currentState = self:getState()
  if PaGlobal_TutorialState.eState_Start == currentState then
    self:Step01_Prepare()
  elseif PaGlobal_TutorialState.eState_Do == currentState then
    self:Step01_DoStep(deltaTime)
  elseif PaGlobal_TutorialState.eState_Done == currentState then
    self:Step01_Done()
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:Step01_Prepare()
  self:setState(PaGlobal_TutorialState.eState_Do)
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:Step01_DoStep(deltaTime)
  if 1 == self._currentProgress then
    if true == Panel_Window_Inventory:GetShow() then
      self._currentProgress = 3
      return
    end
    local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_38") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_15")
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
    PaGlobal_TutorialManager:ClearEventFunctor()
    PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_OpenInventory, function()
      self._currentProgress = 3
    end)
    PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_CloseInventory, function()
      self._currentProgress = 1
    end)
    PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_InventorySlotRClick, function()
      self._currentProgress = 5
    end)
    PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_UpdateInventory, function(param)
      if beginnerPotionItemKey == param._slotItemKey then
        PaGlobal_Inventory:addSlotEffectForTutorial(param._slot, "fUI_Tuto_ItemHp_01A", true, 0, 0)
      end
    end)
    self._currentProgress = self._currentProgress + 1
  elseif 2 == self._currentProgress then
  elseif 3 == self._currentProgress then
    Inventory_updateSlotData(true)
    local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_70") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_71")
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
    PaGlobal_TutorialManager:ClearEventFunctor()
    PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_InventorySlotRClick, function(rClickedItemKey)
      if beginnerPotionItemKey == rClickedItemKey then
        _AudioPostEvent_SystemUiForXBOX(4, 12)
        self._currentProgress = 5
      end
    end)
    PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_CloseInventory, function()
      PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
      _AudioPostEvent_SystemUiForXBOX(4, 12)
      self._currentProgress = 1
    end)
    PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_UpdateInventory, function(param)
      if beginnerPotionItemKey == param._slotItemKey then
        PaGlobal_Inventory:addSlotEffectForTutorial(param._slot, "fUI_Tuto_ItemHp_01A", true, 0, 0)
      end
    end)
    self._currentProgress = self._currentProgress + 1
  elseif 4 == self._currentProgress then
  elseif 5 == self._currentProgress then
    Inventory_updateSlotData(true)
    PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
    local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_48") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_49") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_45")
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
    PaGlobal_TutorialManager:ClearEventFunctor()
    PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_QuickSlotClick, function(quickSlotItemKey)
      _PA_LOG("\236\157\180\235\139\164\237\152\156", tostring(quickSlotItemKey))
      if beginnerPotionItemKey == quickSlotItemKey then
        self._currentProgress = 7
        PaGlobal_TutorialManager:ClearEventFunctor()
      end
    end)
    self._currentProgress = self._currentProgress + 1
  elseif 6 == self._currentProgress then
  elseif 7 == self._currentProgress then
    PaGlobal_TutorialManager:ClearEventFunctor()
    self:setState(PaGlobal_TutorialState.eState_Done)
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:Step01_Done()
  PaGlobal_TutorialManager:ClearEventFunctor()
  self._updateTime = 0
  self._currentProgress = 1
  self._currentStep = self._currentStep + 1
  self:setState(PaGlobal_TutorialState.eState_Start)
end

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
  _startLimitLevel = 15
}
local beginnerPotionItemKey = 502
local enabledEffectSlotInQuickSlot, classType
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:checkPossibleForPhaseStart(stepNo)
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
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_InventoryAndQuickSlot:startPhase()")
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  classType = getSelfPlayer():getClassType()
  ToClient_DeleteNaviGuideByGroup()
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
  PaGlobal_TutorialManager:setAllowShowQuickSlot(true)
  PaGlobal_TutorialManager:setAllowNewQuickSlot(false)
  PaGlobal_TutorialManager:setAllowMainQuestWidget(false)
  PaGlobal_TutorialUiManager:setShowAllDefaultUi(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:repositionScreen()
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:endPhase()
  self._currentStep = 0
  self._nextStep = 1
  PaGlobal_TutorialManager:startNextPhase()
end
local result
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
  if 1 == currentStep then
    result = false
  elseif 2 == currentStep then
    result = false
  end
  if true == result then
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:handleChangeStep(currentStep)
  if 1 == currentStep then
    self:changeStepUsePotionInInventory()
  elseif 2 == currentStep then
    self:endPhase()
  elseif -1 == currentStep then
    self:changeStepExceptionClosedInventory()
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:changeStepExceptionClosedInventory()
  PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("", PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_38") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIALXB_TEXT_4"))
  end)
  PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:eventCallExceptionClosedInventory()
  if 2 == self._currentStep and 1 == self._currentProgress then
    return
  end
  if -1 ~= self._currentStep then
    self._returnStep = self._currentStep
    self._returnProgress = self._currentProgress
    self._nextStep = -1
  end
  PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:eventCallExceptionOpenedInventory()
  self._nextStep = self._returnStep
  self._currentProgress = self._returnProgress
  self._returnStep = 0
  self._returnProgress = 0
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:changeStepUsePotionInInventory()
  if 1 == self._currentProgress then
    PaGlobalFunc_QuickSlot_SetShow(false, false)
    if true == Panel_Window_Inventory:GetShow() then
      self._currentProgress = self._currentProgress + 1
      self:handleChangeStep(self._currentStep)
      return
    end
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("", PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_38") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIALXB_TEXT_4"))
    end)
  elseif 2 == self._currentProgress then
    Inventory_updateSlotData(true)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("", PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_70") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIALXB_TEXT_5"))
    end)
  elseif 3 == self._currentProgress then
    Inventory_updateSlotData(true)
    PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("", PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIALXB_TEXT_6"))
    end)
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:eventCallOpenedInventory()
  if 1 == self._currentProgress then
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:eventCallAddEffectInventoryBeginnerPotion(slot, slotItemKey)
  if 1 == self._currentStep and 2 == self._currentProgress and beginnerPotionItemKey == slotItemKey then
    PaGlobal_Inventory:addSlotEffectForTutorial(slot, "fUI_Tuto_ItemHp_01A", true, 0, 0)
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:eventCallCompareInventoryBeginnerPotionItemKey(rClickedItemKey)
  if 2 == self._currentProgress and beginnerPotionItemKey == rClickedItemKey then
    audioPostEvent_SystemUi(4, 12)
    _AudioPostEvent_SystemUiForXBOX(4, 12)
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:eventCallClosedInventory()
  if 3 == self._currentProgress then
    self._nextStep = self._nextStep + 1
    self._currentProgress = 1
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:handleOpenedInventory()
  if 1 == self._currentStep then
    self:eventCallOpenedInventory()
  elseif -1 == self._currentStep then
    self:eventCallExceptionOpenedInventory()
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:handleClosedInventory()
  if 1 == self._currentStep and 3 == self._currentProgress then
    self:eventCallClosedInventory()
  else
    self:eventCallExceptionClosedInventory()
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:handleUpdateInventorySlotData(slot, slotItemKey)
  if 1 == self._currentStep or 2 == self._currentStep then
    self:eventCallAddEffectInventoryBeginnerPotion(slot, slotItemKey)
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:handleInventorySlotRClick(rClickedItemKey)
  if 1 == self._currentStep then
    self:eventCallCompareInventoryBeginnerPotionItemKey(rClickedItemKey)
  end
end

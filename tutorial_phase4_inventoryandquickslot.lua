PaGlobal_TutorialPhase_InventoryAndQuickSlot = {
  _phaseNo = 4,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 1,
  _returnStep = 0,
  _returnProgress = 0,
  _isPhaseOpen = true,
  _isSkippable = true,
  _regionKeyRawList = {88, 349},
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
  PaGlobal_TutorialUiManager:getUiKeyButton():setShowAll(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:repositionScreen()
  FGlobal_Panel_Radar_Show(true)
  Panel_TimeBar:SetShow(true)
  if false == _ContentsGroup_RenewUI then
    GameTips_Show()
    GameTips_Reposition()
  end
  FGlobal_NewQuickSlot_Update()
  local remasterUIOption = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eSwapRemasterUISetting)
  if true == remasterUIOption then
    Panel_MainStatus_Remaster:SetShow(true)
  else
    Panel_MainStatus_User_Bar:SetShow(true, false)
  end
  FGlobal_ClassResource_SetShowControl(true)
  Panel_Tutorial:SetShow(true, true)
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
    if false == _ContentsGroup_RenewUI then
      self:changeStepUsePotionInQuickSlot()
    else
      self:endPhase()
    end
  elseif 3 == currentStep then
    self:endPhase()
  elseif -1 == currentStep then
    self:changeStepExceptionClosedInventory()
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:changeStepExceptionClosedInventory()
  PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_38"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_15"), true, getScreenSizeX() * 0.5 + 150, getScreenSizeY() * 0.5 - 200)
    PaGlobal_TutorialUiManager:getUiBlackSpirit():addBubbleKey("_bubbleKey_I")
  end)
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:eventCallExceptionClosedInventory()
  if 2 == self._currentStep and 1 == self._currentProgress then
    return
  end
  if 2 == self._currentStep and 2 == self._currentProgress then
    return
  end
  if -1 ~= self._currentStep then
    self._returnStep = self._currentStep
    self._returnProgress = self._currentProgress
    self._nextStep = -1
  end
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
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_38"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_15"), true, getScreenSizeX() * 0.5 - 150, getScreenSizeY() * 0.5)
      PaGlobal_TutorialUiManager:getUiBlackSpirit():addBubbleKey("_bubbleKey_I")
    end)
  elseif 2 == self._currentProgress then
    if false == _ContentsGroup_RenewUI then
      Inventory_SetCheckRadioButtonNormalInventory(true)
      Inventory_updateSlotData()
    else
      Inventory_updateSlotData(true)
    end
    Inventory_updateSlotData()
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_70"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_71"), false, getScreenSizeX(), Panel_Window_Inventory:GetPosY() - 100)
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
    self._nextStep = self._nextStep + 1
    self._currentProgress = 1
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:changeStepUsePotionInQuickSlot()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
    PaGlobalFunc_QuickSlot_SetShow(false)
    FGlobal_QuickSlot_Show()
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_48") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_49"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_45"), false, Panel_QuickSlot:GetPosX(), Panel_QuickSlot:GetPosY() - 200)
    end)
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:eventCallAddEffectQuickSlot(slot, quickSlotItemKey)
  if 1 == self._currentProgress and beginnerPotionItemKey == quickSlotItemKey and nil == enabledEffectSlotInQuickSlot then
    PaGlobal_QuickSlot:addSlotEffectForTutorial(slot, "fUI_Tuto_ItemHp_01A", true, 0, 0)
    enabledEffectSlotInQuickSlot = slot
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:eventCallCompareUsedQuickSlotItemKey(itemKey)
  if 1 == self._currentProgress then
    if itemKey ~= beginnerPotionItemKey then
      return
    end
    if nil ~= enabledEffectSlotInQuickSlot then
      PaGlobal_QuickSlot:eraseSlotEffectForTutorial(enabledEffectSlotInQuickSlot)
      enabledEffectSlotInQuickSlot = nil
    end
    PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
    audioPostEvent_SystemUi(4, 12)
    self._nextStep = self._nextStep + 1
    self._currentProgress = 1
    self:handleChangeStep(self._currentStep)
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
  self:eventCallExceptionClosedInventory()
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
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:handleUpdateQuickSlotPerFrame(slot, quickSlotItemKey)
  if 2 == self._currentStep then
    self:eventCallAddEffectQuickSlot(slot, quickSlotItemKey)
  end
end
function PaGlobal_TutorialPhase_InventoryAndQuickSlot:handleQuickSlotClick(clickedItemKey)
  if 2 == self._currentStep then
    self:eventCallCompareUsedQuickSlotItemKey(clickedItemKey)
  end
end

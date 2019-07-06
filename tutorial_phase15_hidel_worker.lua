PaGlobal_TutorialPhase_Hidel_Worker = {
  _phaseNo = 15,
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
    [1] = 323,
    [2] = 439
  },
  _talkerCharacterKeyData = {
    [1] = 41085
  },
  _itemKeyData = {
    [1] = 64616
  }
}
function PaGlobal_TutorialPhase_Hidel_Worker:checkPossibleForPhaseStart(stepNo)
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
  if explorePoint:getRemainedPoint() < 4 then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\234\179\181\237\151\140\235\143\132\234\176\128 \235\182\128\236\161\177\237\149\180\236\132\156 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. : _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local inventory = selfPlayer:get():getInventoryByType(CppEnums.ItemWhereType.eInventory)
  if nil == inventory then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\236\157\184\235\178\164\237\134\160\235\166\172\235\165\188 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164! _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local hasItem = true
  if toInt64(0, 0) == inventory:getItemCount_s64(ItemEnchantKey(64616, 0)) then
    hasItem = false
  end
  if false == hasItem then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188\236\151\144 \237\149\132\236\154\148\237\149\156 \236\157\188\234\190\188 \234\179\132\236\149\189\236\132\156(64616)\235\165\188 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\150\180\236\132\156 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local hidelPlantKey = ToClient_convertWaypointKeyToPlantKey(301)
  local townWorkerMaxCapacity = ToClient_getTownWorkerMaxCapacity(hidelPlantKey)
  local plantWaitWorkerListCount = ToClient_getPlantWaitWorkerListCount(hidelPlantKey)
  if townWorkerMaxCapacity - plantWaitWorkerListCount <= 0 then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\234\179\160\236\154\169\235\144\156 \236\157\188\234\190\188 \236\136\152 :  " .. tostring(plantWaitWorkerListCount) .. " / \236\157\188\234\190\188 \236\136\152\236\154\169 \234\176\128\235\138\165 \236\136\152 : " .. tostring(townWorkerMaxCapacity))
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\149\152\236\157\180\235\141\184\236\157\152 \236\157\188\234\190\188 \236\136\153\236\134\140\234\176\128 \235\170\168\236\158\144\235\157\188\236\132\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local wheatPlantKey = ToClient_convertWaypointKeyToPlantKey(439)
  if 0 < ToClient_getPlantWorkingList(wheatPlantKey) then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\235\170\168\235\160\136\237\139\176 \234\177\176\235\140\128 \235\134\141\236\158\165 \235\176\128 \236\158\172\235\176\176 \235\133\184\235\147\156\236\151\144 \236\157\180\235\175\184 \236\157\188\234\190\188\236\157\180 \236\157\188\237\149\152\234\179\160 \236\158\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_Hidel_Worker:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_Hidel_Worker:startPhase(stepNo)
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
function PaGlobal_TutorialPhase_Hidel_Worker:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_Hidel_Worker:startStep() stepNo : " .. tostring(stepNo) .. " typeNo : " .. tostring(typeNo))
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  self._prevProgress = 0
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
  Panel_Tutorial:SetShow(true, false)
end
function PaGlobal_TutorialPhase_Hidel_Worker:endPhase()
  FGlobal_Worldmap_SetRenderMode({
    Defines.RenderMode.eRenderMode_WorldMap
  })
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_Dialog_Main_SetRenderModeList({
      Defines.RenderMode.eRenderMode_Dialog
    })
  else
    FGlobal_Dialog_SetRenderMode({
      Defines.RenderMode.eRenderMode_Dialog
    })
  end
  if false == _ContentsGroup_NewUI_Dialog_All then
    FGlobal_EraseAllEffect_ExitButton()
  end
  FGlobal_NodeMenu_SetEnableNodeUnlinkButton(true)
  PaGlobal_TutorialUiBlackSpirit:setShowAll(false)
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialManager:endTutorial()
end
function PaGlobal_TutorialPhase_Hidel_Worker:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleChangeStep(currentStep)
  if 1 == self._currentStep then
    self:changeStep1()
  elseif 2 == self._currentStep then
    self:changeStep2()
  elseif 3 == self._currentStep then
    self:changeStep3()
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:toNextProgress()
  self._currentProgress = self._currentProgress + 1
  self:handleChangeStep(self._currentStep)
end
function PaGlobal_TutorialPhase_Hidel_Worker:toNextStep()
  self._currentProgress = 1
  self._nextStep = self._nextStep + 1
end
function PaGlobal_TutorialPhase_Hidel_Worker:toStep(destStep, destProgress)
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
function PaGlobal_TutorialPhase_Hidel_Worker:addEffectUiNodeButtonByWaypointKey(waypointKey)
  local uiNodeButton = ToClient_FindNodeButtonByWaypointKey(waypointKey)
  if nil ~= uiNodeButton then
    uiNodeButton:EraseAllEffect()
    uiNodeButton:AddEffect("UI_ArrowMark02", true, 0, -50)
    uiNodeButton:AddEffect("UI_WorldMap_Ping01", true, 0, 0)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eraseAllEffectUiNodeButtonByWaypointKey(waypointKey)
  local uiNodeButton = ToClient_FindNodeButtonByWaypointKey(waypointKey)
  if nil ~= uiNodeButton then
    uiNodeButton:EraseAllEffect()
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:changeStep1()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\157\188\234\190\188 \234\179\132\236\149\189\236\132\156\235\165\188 \235\176\155\236\149\152\234\181\176.\n\236\130\172\236\154\169\237\149\180\236\132\156 \236\157\188\234\190\188\236\157\132 \234\179\160\236\154\169\237\149\180\235\179\180\236\158\144.", "<I>\237\130\164\235\161\156 \234\176\128\235\176\169\236\157\132 \236\151\180\236\150\180\236\132\156\n\234\179\132\236\149\189\236\132\156\235\165\188 <\236\154\176\237\129\180\235\166\173>\236\156\188\235\161\156 \236\130\172\236\154\169\237\149\180\235\179\180\236\158\144.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  elseif 2 == self._currentProgress then
    PaGlobal_TutorialUiMasking:hideQuestMasking()
    FGlobal_WorldmapMain_SetAllowTutorialPanelShow(true)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\162\139\236\149\132. \236\157\180\236\160\156 \234\179\160\236\154\169\237\149\156 \236\157\188\234\190\188\236\157\132 \237\153\149\236\157\184\237\149\180\235\179\180\236\158\144.", "\236\154\176\236\132\160 <M>\237\130\164\235\161\156 \236\155\148\235\147\156\235\167\181\236\157\132 \236\151\180\236\150\180\235\180\144.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  elseif 3 == self._currentProgress then
    local bottomWorkerButton = UI.getChildControl(Panel_WorldMap, "BottomMenu_WorkerList")
    bottomWorkerButton:EraseAllEffect()
    bottomWorkerButton:AddEffect("UI_ArrowMark02", true, 0, -50)
    bottomWorkerButton:AddEffect("UI_WorldMap_Ping01", true, 0, 0)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\152\164\235\165\184\236\170\189 \237\149\152\235\139\168\236\151\144 \237\145\156\236\139\156\235\144\156 \236\157\188\234\190\188 \235\170\169\235\161\157 \235\178\132\237\138\188\236\157\180 \235\179\180\236\157\180\236\167\128?", "\236\157\188\234\190\188 \235\170\169\235\161\157 \235\178\132\237\138\188\236\157\132 \236\153\188\237\129\180\235\166\173 \237\149\180\235\180\144.", true, getScreenSizeX() * 0.75, getScreenSizeY() * 0.65)
    end)
  elseif 4 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\234\179\160\236\154\169\235\144\156 \236\157\188\234\190\188\236\157\180 \235\179\180\236\157\188\234\177\176\236\149\188.\n\236\157\188\234\190\188\236\157\132 \234\179\160\236\154\169\237\149\152\235\169\180 \236\151\172\235\159\172\234\176\128\236\167\128 \236\157\188\236\157\132 \235\140\128\236\139\160 \236\139\156\237\130\172 \236\136\152 \236\158\136\236\150\180.", "\237\153\149\236\157\184\237\150\136\236\156\188\235\169\180 <ESC>\237\130\164\235\130\152 <M>\237\130\164\235\165\188 \235\136\140\235\159\172 \236\155\148\235\147\156\235\167\181\236\157\132 \235\139\171\236\149\132.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  elseif 5 == self._currentProgress then
    local bottomWorkerButton = UI.getChildControl(Panel_WorldMap, "BottomMenu_WorkerList")
    bottomWorkerButton:EraseAllEffect()
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\157\180\236\160\156 \235\170\168\235\160\136\237\139\176 \235\134\141\236\158\165\236\156\188\235\161\156 \234\176\128\236\132\156 \236\157\188\234\190\188\236\151\144\234\178\140 \236\157\188\236\157\132 \236\139\156\236\188\156\235\179\180\236\158\144.", "<M>\237\130\164\235\165\188 \235\136\140\235\159\172 \236\155\148\235\147\156\235\167\181\236\157\132 \236\151\180\236\150\180\235\180\144.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  elseif 6 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\237\145\156\236\139\156\235\144\156 \235\170\168\235\160\136\237\139\176 \234\177\176\235\140\128 \235\134\141\236\158\165\236\157\180 \235\179\180\236\157\180\236\167\128?", "\235\170\168\235\160\136\237\139\176 \234\177\176\235\140\128 \235\134\141\236\158\165 \234\177\176\236\160\144\236\157\132 \236\154\176\237\129\180\235\166\173 \237\149\180\235\180\144.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  elseif 7 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\158\152\237\150\136\236\150\180. \235\170\169\236\160\129\236\167\128\235\165\188 \236\176\190\236\149\132\234\176\128\235\160\164\235\169\180 \236\155\148\235\147\156\235\167\181\236\157\132 \235\139\171\236\149\132\236\149\188\234\178\160\236\167\128?", "\236\157\180\235\143\153\237\149\180\236\149\188\237\149\152\235\139\136\234\185\140 <ESC>\235\130\152 <M>\237\130\164\235\165\188 \235\136\140\235\159\172 \236\155\148\235\147\156\235\167\181\236\157\132 \235\139\171\236\149\132.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  elseif -1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\153\156 \235\178\140\236\141\168 \236\167\128\235\143\132\235\165\188 \235\139\171\235\138\148\234\177\176\236\167\128?", "<M>\237\130\164\235\165\188 \235\136\140\235\159\172 \236\155\148\235\147\156\235\167\181\236\157\132 \236\151\180\236\150\180\235\180\144.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep1AddEffectEmploymentContract(slot, slotItemKey)
  if 1 == self._currentProgress and self._itemKeyData[1] == slotItemKey then
    PaGlobal_Inventory:addSlotEffectForTutorial(slot, "fUI_Tuto_ItemHp_01A", true, 0, 0)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep1InventorySlotRClick(rClickedItemKey)
  if 1 == self._currentProgress and self._itemKeyData[1] == rClickedItemKey then
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep1WorldMapOpen()
  if 2 == self._currentProgress then
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  elseif -1 == self._currentProgress then
    self._currentProgress = self._prevProgress
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep1GrandWorldMap_CheckPopup(openPanelEnum, popupPanel)
  if 3 == self._currentProgress and 5 == openPanelEnum then
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep1WorldMapImmediatelyClose()
  if 3 == self._currentProgress or 6 == self._currentProgress then
    self._prevProgress = self._currentProgress
    self:toStep(1, -1)
  elseif 4 == self._currentProgress then
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  elseif 7 == self._currentProgress then
    FGlobal_WorldmapMain_SetAllowTutorialPanelShow(false)
    if true == isExploreUpgradable(self._waypointKeyData[1]) then
      if true == isWithdrawablePlant(self._waypointKeyData[1]) then
        self:toStep(3)
      elseif false == isWithdrawablePlant(self._waypointKeyData[1]) then
        self:toNextStep()
      end
    end
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep1WorldMapOpenComplete()
  if 5 == self._currentProgress then
    self:addEffectUiNodeButtonByWaypointKey(self._waypointKeyData[1])
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  elseif 6 == self._currentProgress then
    self:addEffectUiNodeButtonByWaypointKey(self._waypointKeyData[1])
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep1ResetTownMode()
  if 6 == self._currentProgress then
    self:addEffectUiNodeButtonByWaypointKey(self._waypointKeyData[1])
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep1RClickWorldMapNode(uiNodeButton)
  if 6 == self._currentProgress and self._waypointKeyData[1] == uiNodeButton:getWaypointKey() then
    self:eraseAllEffectUiNodeButtonByWaypointKey(self._waypointKeyData[1])
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:changeStep2()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\234\184\184\236\149\136\235\130\180\235\165\188 \235\148\176\235\157\188\234\176\128\235\169\180 <\237\131\144\237\151\152 \234\177\176\236\160\144 \234\180\128\235\166\172\236\158\144>\235\169\148\235\165\180\236\139\156\236\149\136\235\138\144 \235\170\168\235\160\136\237\139\176 \236\151\144\234\178\140 \235\143\132\235\139\172\237\149\152\234\178\140 \235\144\160\234\177\176\236\149\188.", "\234\184\184\236\149\136\235\130\180\235\165\188 \235\148\176\235\157\188 \235\140\128\236\131\129\236\157\132 \236\176\190\236\149\132 \235\167\144\236\157\132 \234\177\184\236\150\180\235\179\180\236\158\144.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif 2 == self._currentProgress then
    FGlobal_WorldmapMain_SetAllowTutorialPanelShow(true)
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\157\188\234\190\188\236\151\144\234\178\140 \236\157\188\236\157\132 \236\139\156\237\130\172 \234\177\176\236\160\144\236\157\128 \234\180\128\235\166\172\234\176\128 \237\149\132\236\154\148\237\149\180.", "\235\140\128\237\153\148\235\169\148\235\137\180\236\164\145\236\151\144 '\237\131\144\237\151\152 \234\177\176\236\160\144 \234\180\128\235\166\172'\235\178\132\237\138\188\236\157\132 \235\136\140\235\159\172\235\180\144.", false, getScreenSizeX() * 0.55, getScreenSizeY() * 0.45, true)
    end)
  elseif 3 == self._currentProgress then
    do
      local positionTarget = UI.getChildControl(Panel_NodeMenu, "MainMenu_Bg")
      PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
        PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\157\188\234\190\188\236\157\152 \236\134\140\236\134\141 \234\177\176\236\160\144\234\179\188 \236\157\188\236\157\132 \237\149\160 \234\177\176\236\160\144\236\157\180 \236\151\176\234\178\176 \235\144\152\236\150\180 \236\158\136\236\150\180\236\149\188 \236\157\188\234\190\188\236\151\144\234\178\140 \236\157\188\236\157\132 \236\139\156\237\130\172 \236\136\152 \236\158\136\236\150\180.\n\234\177\176\236\160\144\236\157\132 \236\151\176\234\178\176\237\149\152\234\179\160 \236\139\182\236\156\188\235\169\180 \234\179\181\237\151\140\235\143\132\235\165\188 \237\136\172\236\158\144\237\149\180\236\149\188\235\143\188.", "\236\153\188\236\170\189 \236\156\132\236\151\144 \237\145\156\236\139\156\235\144\156 '\234\179\181\237\151\140\235\143\132 \237\136\172\236\158\144'\235\178\132\237\138\188\236\157\132 \235\136\140\235\159\172\235\179\180\236\158\144.", false, positionTarget:GetPosX() + positionTarget:GetSizeX() * 2, positionTarget:GetPosY() + positionTarget:GetSizeY() * 0.5, true)
      end)
    end
  elseif 4 == self._currentProgress then
    while true == ToClient_isTownMode() do
      FGlobal_WorldMapWindowEscape()
    end
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\157\180\236\160\156 \234\177\176\236\160\144\234\176\132\236\151\144 \236\151\176\234\178\176\235\144\156 \236\132\160\236\157\180 \235\182\137\236\150\180\236\167\132 \234\178\131\236\157\180 \235\179\180\236\157\180\236\167\128?\n\236\157\180\235\160\135\234\178\140 \235\144\152\235\169\180 \235\145\144 \234\177\176\236\160\144\236\157\180 \236\151\176\234\178\176\235\144\156\234\177\176\236\149\188.", "\236\157\180\236\160\156 <ESC>\237\130\164\235\130\152 <M>\237\130\164\235\165\188 \235\136\140\235\159\172 \236\155\148\235\147\156\235\167\181\236\157\132 \235\139\171\236\149\132.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep2BeforeShowDialog()
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
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep2ShowDialog(dialogData)
  if 1 == self._currentProgress then
    if self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
      if false == _ContentsGroup_NewUI_Dialog_All then
        local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Explore)
        FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
        FGlobal_AddEffect_DialogButton(funcButtonIndex, "UI_ArrowMark02", true, 0, -50)
      else
        local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Explore)
      end
      self._currentProgress = self._currentProgress + 1
      self:handleChangeStep(self._currentStep)
    end
  elseif 2 == self._currentProgress and self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
    if false == _ContentsGroup_NewUI_Dialog_All then
      local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Explore)
      FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
      FGlobal_AddEffect_DialogButton(funcButtonIndex, "UI_ArrowMark02", true, 0, -50)
    else
      local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Explore)
    end
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep2ClickedDialogFuncButton(funcButtonType)
  if 2 == self._currentProgress and self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() and CppEnums.ContentsType.Contents_Explore == funcButtonType then
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep2EventUpdateExplorationNode(waypointKey)
  if 3 == self._currentProgress and self._waypointKeyData[1] == waypointKey then
    FGlobal_NodeMenu_SetEnableNodeUnlinkButton(false)
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep2WorldMapImmediatelyClose()
  if 4 == self._currentProgress then
    FGlobal_Worldmap_ResetRenderMode()
    self._currentProgress = 1
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:changeStep3()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\157\180\236\160\156 \236\157\188\234\190\188\236\151\144\234\178\140 \236\157\188\236\157\132 \236\139\156\237\130\172 \236\164\128\235\185\132\235\165\188 \237\149\180 \235\179\180\236\158\144.", "'\235\169\148\235\165\180\236\139\156\236\149\136\235\138\144 \235\170\168\235\160\136\237\139\176'\236\151\144\234\178\140 \234\176\128\236\132\156 \235\167\144\236\157\132 \234\177\184\236\150\180\235\180\144.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif 2 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\131\157\236\130\176 \234\177\176\236\160\144\236\151\144 \237\136\172\236\158\144 \237\149\180 \235\179\188\234\177\176\236\149\188.\n\235\169\148\235\165\180\236\139\156\236\149\136\235\138\144 \235\170\168\235\160\136\237\139\176\236\153\128\236\157\152 \235\140\128\237\153\148\235\169\148\235\137\180\236\164\145\236\151\144 \236\149\140\235\167\158\236\157\128 \234\178\131\236\157\180 \236\158\136\236\167\128.", "'\237\131\144\237\151\152 \234\177\176\236\160\144 \234\180\128\235\166\172'\235\178\132\237\138\188\236\157\132 \235\136\140\235\159\172\235\179\180\236\158\144.", false, getScreenSizeX() * 0.45, getScreenSizeY() * 0.4, true)
    end)
  elseif 3 == self._currentProgress then
    self:addEffectUiNodeButtonByWaypointKey(self._waypointKeyData[2])
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\237\145\156\236\139\156\235\144\156 \236\131\157\236\130\176 \234\177\176\236\160\144\236\157\180 \235\179\180\236\157\180\236\167\128?", "'\235\176\128 \236\158\172\235\176\176'\236\131\157\236\130\176 \234\177\176\236\160\144\236\157\132 \236\153\188\237\129\180\235\166\173 \237\149\180\235\180\144.", true, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.6)
    end)
  elseif 4 == self._currentProgress then
    do
      local positionTarget = UI.getChildControl(Panel_NodeMenu, "MainMenu_Bg")
      PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
        PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\157\180 \234\177\176\236\160\144\236\151\144\236\132\156 \236\131\157\236\130\176\236\157\132 \237\149\152\234\179\160 \236\139\182\236\156\188\235\169\180 \234\179\181\237\151\140\235\143\132\235\165\188 \237\136\172\236\158\144\237\149\180\236\149\188\235\143\188.", "\236\153\188\236\170\189 \236\156\132\236\151\144 \237\145\156\236\139\156\235\144\156 '\234\179\181\237\151\140\235\143\132 \237\136\172\236\158\144'\235\178\132\237\138\188\236\157\132 \235\136\140\235\159\172\235\179\180\236\158\144.", false, positionTarget:GetPosX() + positionTarget:GetSizeX() * 2, positionTarget:GetPosY() + positionTarget:GetSizeY() * 0.5)
      end)
    end
  elseif 5 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\234\179\160\236\154\169\235\144\156 \236\157\188\234\190\188 \235\170\169\235\161\157\236\157\180 \235\179\180\236\157\180\236\167\128?\n\236\157\188\234\190\188\236\151\144\234\178\140 \236\157\188\236\157\132 \236\139\156\236\188\156\235\179\180\236\158\144.", "\236\158\145\236\151\133 \236\139\156\236\158\145 \235\178\132\237\138\188\236\157\132 \235\136\140\235\159\172\235\180\144.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  elseif 6 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial("\236\157\180\235\159\176\236\139\157\236\156\188\235\161\156 \236\157\188\234\190\188\236\157\132 \236\131\157\236\130\176 \234\177\176\236\160\144\236\151\144 \235\179\180\235\130\180\236\132\156 \236\157\188\236\157\132 \236\139\156\237\130\172 \236\136\152 \236\158\136\236\150\180.\n\236\157\188\234\190\188\236\157\180 \236\157\188\236\157\132 \237\149\152\235\138\148\235\143\153\236\149\136 \235\132\140 \235\170\168\237\151\152\236\157\132 \234\179\132\236\134\141 \237\149\160 \236\136\152 \236\158\136\236\167\128.", "\236\157\180\236\160\156 <ESC>\237\130\164\235\130\152 <M>\237\130\164\235\161\156 \236\155\148\235\147\156\235\167\181\236\157\132 \235\139\171\234\179\160 \235\170\168\237\151\152\236\157\132 \234\179\132\236\134\141\237\149\152\235\143\132\235\161\157 \237\149\180.", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep3InteractionShow(actorProxyWrapper)
  local isTargetNpc = false
  if 1 == self._currentProgress then
    local actorProxyWrapper = interaction_getInteractable()
    if nil ~= actorProxyWrapper and self._talkerCharacterKeyData[1] == actorProxyWrapper:getCharacterKeyRaw() then
      isTargetNpc = true
    end
    if true == isTargetNpc then
      if true == _ContentsGroup_RenewUI_Dailog then
        PaGlobalFunc_Dialog_Main_SetRenderModeList({
          Defines.RenderMode.eRenderMode_Dialog,
          Defines.RenderMode.eRenderMode_Tutorial
        })
      else
        FGlobal_Dialog_SetRenderMode({
          Defines.RenderMode.eRenderMode_Dialog,
          Defines.RenderMode.eRenderMode_Tutorial
        })
      end
    elseif true == _ContentsGroup_RenewUI_Dailog then
      PaGlobalFunc_Dialog_Main_SetRenderModeList({
        Defines.RenderMode.eRenderMode_Dialog
      })
    else
      FGlobal_Dialog_SetRenderMode({
        Defines.RenderMode.eRenderMode_Dialog,
        Defines.RenderMode.eRenderMode_Tutorial
      })
    end
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep3BeforeShowDialog()
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
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep3ShowDialog(dialogData)
  if 1 == self._currentProgress then
    if self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
      if false == _ContentsGroup_NewUI_Dialog_All then
        local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Explore)
        FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
        FGlobal_AddEffect_DialogButton(funcButtonIndex, "UI_ArrowMark02", true, 0, -50)
      else
        local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Explore)
      end
      self._currentProgress = self._currentProgress + 1
      self:handleChangeStep(self._currentStep)
    end
  elseif 2 == self._currentProgress and self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
    if false == _ContentsGroup_NewUI_Dialog_All then
      local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Explore)
      FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
      FGlobal_AddEffect_DialogButton(funcButtonIndex, "UI_ArrowMark02", true, 0, -50)
    else
      local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_Explore)
    end
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep3ClickedDialogFuncButton(funcButtonType)
  if 2 == self._currentProgress and self._talkerCharacterKeyData[1] == dialog_getTalkNpcKey() then
    FGlobal_WorldmapMain_SetAllowTutorialPanelShow(true)
    if CppEnums.ContentsType.Contents_Explore == funcButtonType then
      self._currentProgress = self._currentProgress + 1
      self:handleChangeStep(self._currentStep)
    end
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep3NodeLClick(uiNodeButton)
  if 3 == self._currentProgress and self._waypointKeyData[2] == uiNodeButton:getWaypointKey() then
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep3SetTownMode(waypointKey)
  if 3 == self._currentProgress and self._waypointKeyData[1] == waypointKey then
    self:addEffectUiNodeButtonByWaypointKey(self._waypointKeyData[2])
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep3EventUpdateExplorationNode(waypointKey)
  if 4 == self._currentProgress and self._waypointKeyData[2] == waypointKey then
    FGlobal_NodeMenu_SetEnableNodeUnlinkButton(false)
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep3ClickPlantdoWork(plantKey, workingCount)
  if 5 == self._currentProgress then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "plantKey:getWaypointKey() : " .. tostring(plantKey:getWaypointKey()) .. " / workingCount : " .. tostring(workingCount))
    if self._waypointKeyData[2] == plantKey:getWaypointKey() then
      self._currentProgress = self._currentProgress + 1
      self:handleChangeStep(self._currentStep)
    end
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:eventCallStep3WorldMapImmediatelyClose()
  if 6 == self._currentProgress then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleBeforeWorldmapOpen()
  if 1 == self._currentStep then
    self:eventCallStep1WorldMapOpen()
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleWorldMapOpenComplete()
  if 1 == self._currentStep then
    self:eventCallStep1WorldMapOpenComplete()
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleUpdateInventorySlotData(slot, slotItemKey)
  if 1 == self._currentStep then
    self:eventCallStep1AddEffectEmploymentContract(slot, slotItemKey)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleInventorySlotRClick(rClickedItemKey)
  if 1 == self._currentStep then
    self:eventCallStep1InventorySlotRClick(rClickedItemKey)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleGrandWorldMap_CheckPopup(openPanelEnum, popupPanel)
  if 1 == self._currentStep then
    self:eventCallStep1GrandWorldMap_CheckPopup(openPanelEnum, popupPanel)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleWorldMapImmediatelyClose()
  if 1 == self._currentStep then
    self:eventCallStep1WorldMapImmediatelyClose()
  elseif 2 == self._currentStep then
    self:eventCallStep2WorldMapImmediatelyClose()
  elseif 3 == self._currentStep then
    self:eventCallStep3WorldMapImmediatelyClose()
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleResetTownMode()
  if 1 == self._currentStep then
    self:eventCallStep1ResetTownMode()
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleLClickWorldMapNode(uiNodeButton)
  if 3 == self._currentStep then
    self:eventCallStep3NodeLClick(uiNodeButton)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleRClickWorldMapNode(uiNodeButton)
  if 1 == self._currentStep then
    self:eventCallStep1RClickWorldMapNode(uiNodeButton)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleInteractionShow(actorProxyWrapper)
  if 3 == self._currentStep then
    self:eventCallStep3InteractionShow(actorProxyWrapper)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleBeforeShowDialog()
  if 2 == self._currentStep then
    self:eventCallStep2BeforeShowDialog()
  elseif 3 == self._currentStep then
    self:eventCallStep3BeforeShowDialog()
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleShowDialog(dialogData)
  if 2 == self._currentStep then
    self:eventCallStep2ShowDialog(dialogData)
  elseif 3 == self._currentStep then
    self:eventCallStep3ShowDialog(dialogData)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleClickedDialogFuncButton(funcButtonType)
  if 2 == self._currentStep then
    self:eventCallStep2ClickedDialogFuncButton(funcButtonType)
  elseif 3 == self._currentStep then
    self:eventCallStep3ClickedDialogFuncButton(funcButtonType)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleEventUpdateExplorationNode(waypointKey)
  if 2 == self._currentStep then
    self:eventCallStep2EventUpdateExplorationNode(waypointKey)
  elseif 3 == self._currentStep then
    self:eventCallStep3EventUpdateExplorationNode(waypointKey)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleClickPlantdoWork(plantKey, workingCount)
  if 3 == self._currentStep then
    self:eventCallStep3ClickPlantdoWork(plantKey, workingCount)
  end
end
function PaGlobal_TutorialPhase_Hidel_Worker:handleSetTownMode(waypointKey)
  if 3 == self._currentStep then
    self:eventCallStep3SetTownMode(waypointKey)
  end
end

registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_TutorialManager")
registerEvent("FromClient_DeleteNavigationGuide", "FromClient_DeleteNavigationGuide_TutorialManager")
registerEvent("EventQuestUpdateNotify", "FromClient_EventQuestUpdateNotify_TutorialManager")
registerEvent("FromClient_UpdateQuestList", "FromClient_UpdateQuestList_TutorialManager")
registerEvent("selfPlayer_regionChanged", "FromClient_selfPlayer_regionChanged_TutorialManager")
registerEvent("FromClient_ImmediatelyCloseWorldMap", "FromClient_ImmediatelyCloseWorldMap_TutorialManager")
registerEvent("FromClient_RClickedWorldMapNode", "FromClient_RClickedWorldMapNode_TutorialManager")
registerEvent("FromClient_RenderStateChange", "FromClient_RenderStateChange_TutorialManager")
registerEvent("FromClient_RClickWorldmapPanel", "FromClient_RClickWorldmapPanel_TutorialManager")
registerEvent("FromClient_resetTownMode", "FromClient_resetTownMode_TutorialManager")
registerEvent("FromClient_RClickedWorldMapHouse", "FromClient_RClickedWorldMapHouse_TutorialManager")
registerEvent("FromClint_EventUpdateExplorationNode", "FromClint_EventUpdateExplorationNode_TutorialManager")
function FromClient_luaLoadComplete_TutorialManager(isTool)
  PaGlobal_TutorialManager:handleLuaLoadComplete(isTool)
end
function PaGlobal_TutorialManager:handleLuaLoadComplete(isTool)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "@@@\235\163\168\236\149\132\235\161\156\235\147\156\236\153\132\235\163\140!!@@@")
end
function PaGlobal_TutorialManager:handleTutorialUiManagerInitialize()
  if true == _ContentsGroup_RenewUI_Tutorial then
    if true == Panel_IntroMovie:GetShow() or true == isMoviePlayMode() then
      return
    end
    if 1 == getSelfPlayer():get():getLevel() then
      return
    end
  end
  if false == isMoviePlayMode() then
    self:continueTutorial()
  end
end
function PaGlobal_TutorialManager:handleOpenedInventory()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleOpenedInventory then
    self:getCurrentPhase():handleOpenedInventory()
  end
end
function PaGlobal_TutorialManager:handleClosedInventory()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClosedInventory then
    self:getCurrentPhase():handleClosedInventory()
  end
end
function PaGlobal_TutorialManager:handleUpdateInventorySlotData(slot, slotItemKey)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleUpdateInventorySlotData then
    self:getCurrentPhase():handleUpdateInventorySlotData(slot, slotItemKey)
  end
end
function PaGlobal_TutorialManager:handleInventorySlotRClick(rClickedItemKey)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleInventorySlotRClick then
    self:getCurrentPhase():handleInventorySlotRClick(rClickedItemKey)
  end
end
function PaGlobal_TutorialManager:handleInventorySlotRClickgetSlotNo(SlotNo)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleInventorySlotRClickgetSlotNo then
    self:getCurrentPhase():handleInventorySlotRClickgetSlotNo(SlotNo)
  end
end
function PaGlobal_TutorialManager:handleNewEquipInInventory(newItemSlotNo)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleNewEquipInInventory then
    self:getCurrentPhase():handleNewEquipInInventory(newItemSlotNo)
  elseif false == self:isDoingTutorial() then
    if false == _ContentsGroup_RenewUI_Tutorial and true == PaGlobal_ArousalTutorial_Manager:isDoingArousalTutorial() or false == _ContentsGroup_RenewUI_Tutorial and true == PaGlobal_SummonBossTutorial_Manager:isDoingSummonBossTutorial() then
      _PA_LOG("\234\179\189\235\175\188\236\154\176", "(\236\149\132\236\157\180\237\133\156 \236\158\165\236\176\169 \237\138\156\237\134\160\235\166\172\236\150\188)\235\139\164\235\165\184 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\180 \236\167\132\237\150\137\236\164\145\236\157\180\235\175\128\235\161\156 \235\133\184\236\182\156\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164.")
      return
    end
    local phaseNo = 16
    local stepNo = 1
  end
end
function PaGlobal_TutorialManager:handleEquipItem(slotNo)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleEquipItem then
    self:getCurrentPhase():handleEquipItem(slotNo)
  end
end
function PaGlobal_TutorialManager:handleInventoryDelete(itemWrapper, deleteWhereType, deleteSlotNo)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleInventoryDelete then
    self:getCurrentPhase():handleInventoryDelete(itemWrapper, deleteWhereType, deleteSlotNo)
  end
end
function PaGlobal_TutorialManager:handleUpdateQuickSlotPerFrame(slot, quickSlotItemKey)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleUpdateQuickSlotPerFrame then
    self:getCurrentPhase():handleUpdateQuickSlotPerFrame(slot, quickSlotItemKey)
  end
end
function PaGlobal_TutorialManager:handleUpdateNewQuickSlotPerFrame(panelIdx, slot, newQuickSlotItemKey)
end
function PaGlobal_TutorialManager:handleQuickSlotClick(clickedItemKey)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleQuickSlotClick then
    self:getCurrentPhase():handleQuickSlotClick(clickedItemKey)
  end
end
function PaGlobal_TutorialManager:handleNewQuickSlotClick(clickedItemKey)
end
function PaGlobal_TutorialManager:handleQuickSlotRegistItem(slotIndex, dragWhereTypeInfo, dragSlotInfo)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleQuickSlotRegistItem then
    self:getCurrentPhase():handleQuickSlotRegistItem(slotIndex, dragWhereTypeInfo, dragSlotInfo)
  end
end
function FromClient_EventQuestUpdateNotify_TutorialManager(isAccept, questNoRaw)
  PaGlobal_TutorialManager:handleEventQuestUpdateNotify(isAccept, questNoRaw)
end
function PaGlobal_TutorialManager:handleEventQuestUpdateNotify(isAccept, questNoRaw)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleEventQuestUpdateNotify then
    self:getCurrentPhase():handleEventQuestUpdateNotify(isAccept, questNoRaw)
  elseif false == self:isDoingTutorial() then
    if true == isAccept then
      self:acceptTriggerQuest(questNoRaw)
    elseif false == isAccept then
      self:clearTriggerQuest(questNoRaw)
    end
  end
end
function FromClient_UpdateQuestList_TutorialManager()
  PaGlobal_TutorialManager:handleQuestWidgetUpdate()
end
function PaGlobal_TutorialManager:handleQuestWidgetUpdate()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleQuestWidgetUpdate then
    self:getCurrentPhase():handleQuestWidgetUpdate()
  end
end
function PaGlobal_TutorialManager:handleAfterAndPopFlush()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleAfterAndPopFlush then
    self:getCurrentPhase():handleAfterAndPopFlush()
  end
end
function PaGlobal_TutorialManager:handleUpdateMainDialog()
end
function PaGlobal_TutorialManager:handleClickedQuestWidgetFindTarget(questGroupId, questId, condition, isAuto)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickedQuestWidgetFindTarget then
    self:getCurrentPhase():handleClickedQuestWidgetFindTarget(questGroupId, questId, condition, isAuto)
  end
end
function FromClient_DeleteNavigationGuide_TutorialManager(key)
  PaGlobal_TutorialManager:handleDeleteNavigationGuide(key)
end
function PaGlobal_TutorialManager:handleDeleteNavigationGuide(key)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleDeleteNavigationGuide then
    self:getCurrentPhase():handleDeleteNavigationGuide(key)
  end
end
function PaGlobal_TutorialManager:handleQuestWidgetMouseOver(show)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleQuestWidgetMouseOver then
    self:getCurrentPhase():handleQuestWidgetMouseOver(show)
  end
end
function PaGlobal_TutorialManager:handleQuestWidgetScrollEvent(isDown)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleQuestWidgetScrollEvent then
    self:getCurrentPhase():handleQuestWidgetScrollEvent(isDown)
  end
end
function PaGlobal_TutorialManager:handleEventSelfPlayerUsedSkill(skillWrapper)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleEventSelfPlayerUsedSkill then
    self:getCurrentPhase():handleEventSelfPlayerUsedSkill(skillWrapper)
  end
end
function PaGlobal_TutorialManager:handleShowQuestNewWindow(isShow)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleShowQuestNewWindow then
    self:getCurrentPhase():handleShowQuestNewWindow(isShow)
  end
end
function PaGlobal_TutorialManager:handleRadarMouseOn()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleRadarMouseOn then
    self:getCurrentPhase():handleRadarMouseOn()
  end
end
function PaGlobal_TutorialManager:handleBeforeShowDialog()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleBeforeShowDialog then
    self:getCurrentPhase():handleBeforeShowDialog()
  end
end
function PaGlobal_TutorialManager:handleShowDialog(dialogData)
  if true == self:isDoingTutorial() then
    local isTutorialShow = false
    if false == _ContentsGroup_NewUI_Dialog_All then
      isTutorialShow = FGlobal_Dialog_IsAllowTutorialPanelShow()
    else
      isTutorialShow = PaGlobalFunc_DialogMain_All_IsAllowTutorialPanelShow()
    end
    if false == isTutorialShow then
      if false == _ContentsGroup_RenewUI_Tutorial then
        Panel_Tutorial:SetShow(false, false)
      else
        Panel_Tutorial_Renew:SetShow(false, false)
      end
    end
    if nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleShowDialog then
      self:getCurrentPhase():handleShowDialog(dialogData)
    end
  end
end
function PaGlobal_TutorialManager:handleClickedExitButton(talker)
  if true == self:isDoingTutorial() then
    local isTutorialShow = false
    if false == _ContentsGroup_NewUI_Dialog_All then
      isTutorialShow = FGlobal_Dialog_IsAllowTutorialPanelShow()
    else
      isTutorialShow = PaGlobalFunc_DialogMain_All_IsAllowTutorialPanelShow()
    end
    if false == isTutorialShow then
      if false == _ContentsGroup_RenewUI_Tutorial then
        Panel_Tutorial:SetShow(true, true)
      else
        Panel_Tutorial_Renew:SetShow(true, true)
      end
    end
    if nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickedExitButton then
      self:getCurrentPhase():handleClickedExitButton(talker)
    end
  end
end
function PaGlobal_TutorialManager:handleClickedDialogTutorialStartButton(phaseNo)
  self:startTutorial(phaseNo, 1)
end
function PaGlobal_TutorialManager:handleNpcShopWindowClose()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleNpcShopWindowClose then
    self:getCurrentPhase():handleNpcShopWindowClose()
  end
end
function PaGlobal_TutorialManager:handleNpcShopUpdateContent()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleNpcShopUpdateContent then
    self:getCurrentPhase():handleNpcShopUpdateContent()
  end
end
function PaGlobal_TutorialManager:handleNpcShopTabButtonClick(tabIndex)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleNpcShopTabButtonClick then
    self:getCurrentPhase():handleNpcShopTabButtonClick(tabIndex)
  end
end
function PaGlobal_TutorialManager:handleCloseIntroMovie()
  if 1 == getSelfPlayer():get():getLevel() then
    self:continueTutorial()
  end
end
function PaGlobal_TutorialManager:handleStopCutScene(cutSceneName)
  if 1 == getSelfPlayer():get():getLevel() then
    for index, value in ipairs(self._firstCutSceneList) do
      if cutSceneName == value then
        self:continueTutorial()
        return
      end
    end
  end
end
function FromClient_selfPlayer_regionChanged_TutorialManager(regionInfo)
  PaGlobal_TutorialManager:handleRegionChanged(regionInfo)
end
function PaGlobal_TutorialManager:handleRegionChanged(regionInfo)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleRegionChanged then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "[\237\138\156\237\134\160\235\166\172\236\150\188\236\164\145 \236\167\128\236\151\173 \236\157\180\235\143\153] RegionKeyRaw : " .. tostring(regionInfo:getRegionKey()) .. " / AreaName : " .. tostring(regionInfo:getAreaName()))
    self:getCurrentPhase():handleRegionChanged(regionInfo)
  end
end
function PaGlobal_TutorialManager:handleBeforeWorldmapOpen()
  if true == self:isDoingTutorial() then
    if false == FGlobal_WorldmapMain_IsAllowTutorialPanelShow() then
      Panel_Tutorial:SetShow(false, false)
      return
    end
    if nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleBeforeWorldmapOpen then
      self:getCurrentPhase():handleBeforeWorldmapOpen()
    end
  end
end
function PaGlobal_TutorialManager:handleWorldMapOpenComplete()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleWorldMapOpenComplete then
    self:getCurrentPhase():handleWorldMapOpenComplete()
  end
end
function FromClient_ImmediatelyCloseWorldMap_TutorialManager()
  PaGlobal_TutorialManager:handleWorldMapImmediatelyClose()
end
function PaGlobal_TutorialManager:handleWorldMapImmediatelyClose()
  if true == self:isDoingTutorial() then
    if false == FGlobal_WorldmapMain_IsAllowTutorialPanelShow() then
      if false == _ContentsGroup_RenewUI_Tutorial then
        Panel_Tutorial:SetShow(true, true)
      else
        Panel_Tutorial_Renew:SetShow(true, true)
      end
    end
    if nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleWorldMapImmediatelyClose then
      self:getCurrentPhase():handleWorldMapImmediatelyClose()
    end
  end
end
function PaGlobal_TutorialManager:handleLClickWorldMapNode(uiNodeButton)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "LClick uiNodeButton:getWaypointKey() : " .. tostring(uiNodeButton:getWaypointKey()))
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleLClickWorldMapNode then
    self:getCurrentPhase():handleLClickWorldMapNode(uiNodeButton)
  end
end
function FromClient_RClickedWorldMapNode_TutorialManager(uiNodeButton)
  PaGlobal_TutorialManager:handleRClickWorldMapNode(uiNodeButton)
end
function PaGlobal_TutorialManager:handleRClickWorldMapNode(uiNodeButton)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "RClick uiNodeButton:getWaypointKey() : " .. tostring(uiNodeButton:getWaypointKey()))
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleRClickWorldMapNode then
    self:getCurrentPhase():handleRClickWorldMapNode(uiNodeButton)
  end
end
function FromClient_RenderStateChange_TutorialManager(changeState)
  PaGlobal_TutorialManager:handleRenderStateChange(changeState)
end
function PaGlobal_TutorialManager:handleRenderStateChange(changeState)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleRenderStateChange then
    self:getCurrentPhase():handleRenderStateChange(changeState)
  end
end
function FromClient_RClickWorldmapPanel_TutorialManager(pos3D, immediately, isTopPicking, uiKnowledgeStatic)
  PaGlobal_TutorialManager:handleRClickWorldmapPanel(pos3D, immediately, isTopPicking, uiKnowledgeStatic)
end
function PaGlobal_TutorialManager:handleRClickWorldmapPanel(pos3D, immediately, isTopPicking, uiKnowledgeStatic)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleRClickWorldmapPanel then
    self:getCurrentPhase():handleRClickWorldmapPanel(pos3D, immediately, isTopPicking, uiKnowledgeStatic)
  end
end
function PaGlobal_TutorialManager:handleWorldmapMainEventTempControl()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleWorldmapMainEventTempControl then
    self:getCurrentPhase():handleWorldmapMainEventTempControl()
  end
end
function PaGlobal_TutorialManager:handleClickedGrandWorldMapSearchNodeType(typeIndex)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickedGrandWorldMapSearchNodeType then
    self:getCurrentPhase():handleClickedGrandWorldMapSearchNodeType(typeIndex)
  end
end
function PaGlobal_TutorialManager:handleClickedGrandWorldmapGotoNodeFocus(resultIdx)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickedGrandWorldmapGotoNodeFocus then
    self:getCurrentPhase():handleClickedGrandWorldmapGotoNodeFocus(resultIdx)
  end
end
function FromClient_resetTownMode_TutorialManager()
  PaGlobal_TutorialManager:handleResetTownMode()
end
function PaGlobal_TutorialManager:handleResetTownMode()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleResetTownMode then
    self:getCurrentPhase():handleResetTownMode()
  end
end
function PaGlobal_TutorialManager:handleNpcNavi_ShowToggle(isShow)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleNpcNavi_ShowToggle then
    self:getCurrentPhase():handleNpcNavi_ShowToggle(isShow)
  end
end
function PaGlobal_TutorialManager:handleClickedTownNpcIconNaviStart(spawnType, isAuto)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickedTownNpcIconNaviStart then
    self:getCurrentPhase():handleClickedTownNpcIconNaviStart(spawnType, isAuto)
  end
end
function PaGlobal_TutorialManager:checkTargetHouseKeyForTutorial(houseKey)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().getTargetHouseKey then
    return self:getCurrentPhase():getTargetHouseKey() == houseKey
  end
end
function PaGlobal_TutorialManager:handleHouseHoldButtonSetBaseTexture(houseBtn)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleHouseHoldButtonSetBaseTexture then
    self:getCurrentPhase():handleHouseHoldButtonSetBaseTexture(houseBtn)
  end
end
function PaGlobal_TutorialManager:handleLClickedWorldMapHouse(uiHouseButton)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleLClickedWorldMapHouse then
    self:getCurrentPhase():handleLClickedWorldMapHouse(uiHouseButton)
  end
end
function FromClient_RClickedWorldMapHouse_TutorialManager(uiHouseButton)
  PaGlobal_TutorialManager:handleRClickedWorldMapHouse(uiHouseButton)
end
function PaGlobal_TutorialManager:handleRClickedWorldMapHouse(uiHouseButton)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleRClickedWorldMapHouse then
    self:getCurrentPhase():handleRClickedWorldMapHouse(uiHouseButton)
  end
end
function PaGlobal_TutorialManager:handleClickedHouseControlSetUseType(index, groupType)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickedHouseControlSetUseType then
    self:getCurrentPhase():handleClickedHouseControlSetUseType(index, groupType)
  end
end
function PaGlobal_TutorialManager:handleClickedHouseControlBuyHouseContinue()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickedHouseControlBuyHouseContinue then
    self:getCurrentPhase():handleClickedHouseControlBuyHouseContinue()
  end
end
function PaGlobal_TutorialManager:handleClickedHouseControlSellHouseContinue(houseKey)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickedHouseControlSellHouseContinue then
    self:getCurrentPhase():handleClickedHouseControlSellHouseContinue(houseKey)
  end
end
function PaGlobal_TutorialManager:handleCloseHouseControl()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleCloseHouseControl then
    self:getCurrentPhase():handleCloseHouseControl()
  end
end
function PaGlobal_TutorialManager:handleTradeMarketSellSomeConfirm(itemKey)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleTradeMarketSellSomeConfirm then
    self:getCurrentPhase():handleTradeMarketSellSomeConfirm(itemKey)
  end
end
function PaGlobal_TutorialManager:handleClickedTradeItemAllSell(talker)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickedTradeItemAllSell then
    self:getCurrentPhase():handleClickedTradeItemAllSell(talker)
  end
end
function PaGlobal_TutorialManager:handleGrandWorldMap_CheckPopup(openPanelEnum, popupPanel)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "handleGrandWorldMap_CheckPopup( " .. tostring(openPanelEnum) .. ", " .. tostring(popupPanel) .. " )")
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleGrandWorldMap_CheckPopup then
    self:getCurrentPhase():handleGrandWorldMap_CheckPopup(openPanelEnum, popupPanel)
  end
end
function PaGlobal_TutorialManager:handleInteractionShow(actorProxyWrapper)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleInteractionShow then
    self:getCurrentPhase():handleInteractionShow(actorProxyWrapper)
  end
end
function PaGlobal_TutorialManager:handleClickedDialogFuncButton(funcButtonType)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickedDialogFuncButton then
    self:getCurrentPhase():handleClickedDialogFuncButton(funcButtonType)
  end
end
function PaGlobal_TutorialManager:handleOnNodeUpgradeClick(nodeKey)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleOnNodeUpgradeClick then
    self:getCurrentPhase():handleOnNodeUpgradeClick(nodeKey)
  end
end
function FromClint_EventUpdateExplorationNode_TutorialManager(waypointKey)
  PaGlobal_TutorialManager:handleEventUpdateExplorationNode(waypointKey)
end
function PaGlobal_TutorialManager:handleEventUpdateExplorationNode(waypointKey)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleEventUpdateExplorationNode then
    self:getCurrentPhase():handleEventUpdateExplorationNode(waypointKey)
  end
end
function PaGlobal_TutorialManager:handleClickPlantdoWork(plantKey, workingCount)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickPlantdoWork then
    self:getCurrentPhase():handleClickPlantdoWork(plantKey, workingCount)
  end
end
function PaGlobal_TutorialManager:handleSetTownMode(waypointKey)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleSetTownMode then
    self:getCurrentPhase():handleSetTownMode(waypointKey)
  end
end
function FromClient_RegisterExplorationNode_TutorialManager(waypointKey)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "\236\131\136 \235\133\184\235\147\156 \235\147\177\235\161\157 waypointKey : " .. tostring(waypointKey))
  PaGlobal_TutorialManager:handleRegisterExplorationNode(waypointKey)
end
function PaGlobal_TutorialManager:handleRegisterExplorationNode(waypointKey)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleRegisterExplorationNode then
    self:getCurrentPhase():handleRegisterExplorationNode(waypointKey)
  elseif 301 == waypointKey then
    local phaseNo = 13
    if false == self._isInitialized then
      self:initialize()
    end
    if nil ~= self._phaseList[phaseNo].checkPossibleForPhaseStart and false == self._phaseList[phaseNo]:checkPossibleForPhaseStart(1) then
      return
    end
    self:startTutorial(phaseNo, 1)
  end
end
function PaGlobal_TutorialManager:handleClickWorldmapTutorialButton(buttonNum)
  local phaseNo = 0
  if 1 == buttonNum then
    phaseNo = 10
  elseif 2 == buttonNum then
    phaseNo = 11
  elseif 3 == buttonNum then
    phaseNo = 12
  end
  if false == self._isInitialized then
    self:initialize()
  end
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "phaseNo : " .. tostring(phaseNo))
  if nil ~= self._phaseList[phaseNo].checkPossibleForPhaseStart and false == self._phaseList[phaseNo]:checkPossibleForPhaseStart(1) then
    return
  end
  self:startTutorial(phaseNo, 1)
end
function PaGlobal_TutorialManager:handleCloseEnchantWindow()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleCloseEnchantWindow then
    self:getCurrentPhase():handleCloseEnchantWindow()
  end
end
function PaGlobal_TutorialManager:handleEnchantResultShow(resultType, mainWhereType, mainSlotNo, subWhereType, subSlotNo)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleEnchantResultShow then
    self:getCurrentPhase():handleEnchantResultShow(resultType, mainWhereType, mainSlotNo, subWhereType, subSlotNo)
  end
end
function PaGlobal_TutorialManager:handleExtractionEnchantStoneResultShow()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleExtractionEnchantStoneResultShow then
    self:getCurrentPhase():handleExtractionEnchantStoneResultShow()
  end
end
function PaGlobal_TutorialManager:handleOpenExtractionPanel(isShow)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleOpenExtractionPanel then
    self:getCurrentPhase():handleOpenExtractionPanel(isShow)
  end
end
function PaGlobal_TutorialManager:handleClickExtractionEnchantStoneButton(isShow)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickExtractionEnchantStoneButton then
    self:getCurrentPhase():handleClickExtractionEnchantStoneButton(isShow)
  end
end
function PaGlobal_TutorialManager:handleClickExtractionCaphrasButton(isShow)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickExtractionCaphrasButton then
    self:getCurrentPhase():handleClickExtractionCaphrasButton(isShow)
  end
end
function PaGlobal_TutorialManager:handleClickExtractionCrystalButton(isShow)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickExtractionCrystalButton then
    self:getCurrentPhase():handleClickExtractionCrystalButton(isShow)
  end
end
function PaGlobal_TutorialManager:handleClickExtractionClothButton(isShow)
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleClickExtractionClothButton then
    self:getCurrentPhase():handleClickExtractionClothButton(isShow)
  end
end
function PaGlobal_TutorialManager:handleApplyExtractionEnchantStone()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleApplyExtractionEnchantStone then
    self:getCurrentPhase():handleApplyExtractionEnchantStone()
  end
end
function PaGlobal_TutorialManager:handleMouseLUpBubble()
  if true == self:isDoingTutorial() and nil ~= self:getCurrentPhase() and nil ~= self:getCurrentPhase().handleMouseLUpBubble then
    self:getCurrentPhase():handleMouseLUpBubble()
  end
end

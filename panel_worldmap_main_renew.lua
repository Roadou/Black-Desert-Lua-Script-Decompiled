local Window_WorldMap_MainInfo = {
  _renderMode = RenderModeWrapper.new(100, {
    Defines.RenderMode.eRenderMode_WorldMap
  }, false),
  _isFadeOutWindow = false,
  _isClose = false,
  _isPrevShowQuestWigetPanel = false,
  _isPrevShowMainQuestPanel = false,
  _townModeWaypointKey = nil,
  _isTownMode = false,
  _isAllowTutorialPanelShow = false,
  _hideAutoCompletedNaviBtn,
  _isDialog = false,
  _xPressedCheck = false,
  _isAttacked = false,
  _isImmediatelyClose = false
}
local _Contents_NodeWarIsOpen = ToClient_IsContentsGroupOpen("21")
function StartLoopNavi()
  ToClient_OnCompletedNodeLoop(NavigationGuideParam())
end
function FGlobal_WorldmapShowAni()
  local worldmapRenderUI = ToClient_getWorldmapRenderBase()
  worldmapRenderUI:ResetVertexAni()
  ToClient_WorldmapSetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  if CppEnums.WorldMapAnimationStyle.noAnimation == ToClient_getGameOptionControllerWrapper():getWorldmapOpenType() then
    local aniInfo = worldmapRenderUI:addColorAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(Defines.Color.C_00FFFFFF)
    aniInfo:SetEndColor(Defines.Color.C_FFFFFFFF)
    aniInfo.IsChangeChild = false
  elseif nil == selfPlayer or selfPlayer:getRegionInfoWrapper():isDesert() and false == selfPlayer:isResistDesert() then
    local aniInfo = worldmapRenderUI:addColorAnimation(0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(Defines.Color.C_FFFFFFFF)
    aniInfo:SetEndColor(Defines.Color.C_FFFFFFFF)
    aniInfo.IsChangeChild = false
  else
    local aniInfo = worldmapRenderUI:addColorAnimation(0, 0.8, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(Defines.Color.C_00FFFFFF)
    aniInfo:SetEndColor(2147483647)
    aniInfo.IsChangeChild = false
    aniInfo = worldmapRenderUI:addColorAnimation(0.8, 1, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(2147483647)
    aniInfo:SetEndColor(Defines.Color.C_FFFFFFFF)
    aniInfo.IsChangeChild = false
  end
  Panel_WorldMap:ResetVertexAni()
  ToClient_WorldmapSetAlpha(0)
  _AudioPostEvent_SystemUiForXBOX(1, 2)
end
function FGlobal_WorldmapHideAni()
end
function PaGlobalFunc_WorldMap_SetIsTownMode(isTown)
  local self = Window_WorldMap_MainInfo
  self._isTownMode = isTown
end
function PaGlobalFunc_WorldMap_GetIsTownMode()
  local self = Window_WorldMap_MainInfo
  return self._isTownMode
end
function PaGlobalFunc_FromClient_WorldMap_UpdateWorldMapNode(node)
  local self = Window_WorldMap_MainInfo
  self:UpdateWorldMapNode(node)
end
function Window_WorldMap_MainInfo:UpdateWorldMapNode(node)
  local plantKey = node:getPlantKey()
  local nodeKey = plantKey:getWaypointKey()
  local wayPlant = ToClient_getPlant(plantKey)
  local exploreLevel = node:getLevel()
  local affiliatedTownKey = 0
  local nodeSSW = node:getStaticStatus()
  local regionInfo = nodeSSW:getMinorSiegeRegion()
  if nil ~= wayPlant then
    affiliatedTownKey = ToClinet_getPlantAffiliatedWaypointKey(wayPlant)
  end
  if nil ~= PaGlobalFunc_WorldMapSideBar_EraseArrow then
    PaGlobalFunc_WorldMapSideBar_EraseArrow()
  end
end
function PaGlobalFunc_FromClient_WorldMap_FadeOutHideUI(frameTime)
  local worldmapRenderUI = ToClient_getWorldmapRenderBase()
  worldmapRenderUI:ResetVertexAni()
  local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
  local UI_color = Defines.Color
  local selfPlayer = getSelfPlayer()
  if CppEnums.WorldMapAnimationStyle.noAnimation == ToClient_getGameOptionControllerWrapper():getWorldmapOpenType() then
    local aniInfo = worldmapRenderUI:addColorAnimation(0, 0.3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(UI_color.C_FFFFFFFF)
    aniInfo:SetEndColor(UI_color.C_00FFFFFF)
    aniInfo.IsChangeChild = false
    aniInfo:SetHideAtEnd(false)
    aniInfo:SetDisableWhileAni(true)
    Panel_WorldMap:ResetVertexAni()
    aniInfo = Panel_WorldMap:addColorAnimation(0, 0.3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(UI_color.C_FFFFFFFF)
    aniInfo:SetEndColor(UI_color.C_00FFFFFF)
    aniInfo.IsChangeChild = false
    aniInfo:SetHideAtEnd(true)
    aniInfo:SetDisableWhileAni(true)
  elseif nil == selfPlayer or selfPlayer:getRegionInfoWrapper():isDesert() and false == selfPlayer:isResistDesert() then
    ToClient_WorldmapSetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
    local aniInfo = worldmapRenderUI:addColorAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(UI_color.C_FFFFFFFF)
    aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
    aniInfo.IsChangeChild = false
    aniInfo:SetHideAtEnd(false)
    aniInfo:SetDisableWhileAni(true)
    Panel_WorldMap:ResetVertexAni()
    aniInfo = Panel_WorldMap:addColorAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(UI_color.C_FFFFFFFF)
    aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
    aniInfo.IsChangeChild = false
    aniInfo:SetHideAtEnd(true)
    aniInfo:SetDisableWhileAni(true)
  else
    ToClient_WorldmapSetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
    local aniInfo = worldmapRenderUI:addColorAnimation(0, 0.5 * frameTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(UI_color.C_FFFFFFFF)
    aniInfo:SetEndColor(2147483647)
    aniInfo.IsChangeChild = false
    aniInfo:SetHideAtEnd(false)
    aniInfo:SetDisableWhileAni(true)
    aniInfo = worldmapRenderUI:addColorAnimation(0.5 * frameTime, 1 * frameTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(2147483647)
    aniInfo:SetEndColor(UI_color.C_00FFFFFF)
    aniInfo.IsChangeChild = false
    aniInfo:SetHideAtEnd(true)
    aniInfo:SetDisableWhileAni(true)
    Panel_WorldMap:ResetVertexAni()
    aniInfo = Panel_WorldMap:addColorAnimation(0, 1 * frameTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(UI_color.C_FFFFFFFF)
    aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
    aniInfo.IsChangeChild = false
    aniInfo:SetHideAtEnd(true)
    aniInfo:SetDisableWhileAni(true)
  end
  ToClient_WorldmapSetAlpha(1)
  _AudioPostEvent_SystemUiForXBOX(1, 3)
end
function PaGlobalFunc_FromClient_WorldMap_FadeOut()
  local self = Window_WorldMap_MainInfo
  self._isFadeOutWindow = true
  PaGlobalFunc_ChattingInfo_Close()
end
function PaGlobalFunc_WorldMap_GetIsFadeOut()
  local self = Window_WorldMap_MainInfo
  return self._isFadeOutWindow
end
function PaGlobalFunc_FromClient_WorldMap_ReSetTownMode()
  local self = Window_WorldMap_MainInfo
  self._townModeWaypointKey = nil
  ToClient_worldmapHouseManagerSetShow(false, CppEnums.WaypointKeyUndefined)
  ToClient_worldmapGuildHouseSetShow(true, CppEnums.WaypointKeyUndefined)
  ToClient_worldmapTerritoryManagerSetShow(true)
  if true == _ContentsGroup_ForXBoxFinalCert then
    PaGlobalFunc_WorldMapSideBar_Open()
    if Panel_NodeStable:GetShow() then
      StableClose_FromWorldMap()
    end
    ToClient_SetGuildMode(PaGlobalFunc_WorldMap_TopMenu_GetIsGuildMode())
    PaGlobalFunc_WorldMapSideBar_EraseArrow()
    FGlobal_FilterEffectClear()
  else
    ToClient_SetGuildMode(PaGlobalFunc_WorldMap_TopMenu_GetIsGuildMode())
    FGlobal_Hide_Tooltip_Work(nil, true)
  end
  PaGlobalFunc_WorldMap_SetIsTownMode(false)
  PaGlobalFunc_WorldMap_TopMenu_Open()
  PaGlobalFunc_WorldMap_RingMenu_Open()
  PaGlobalFunc_WorldMap_RightMenu_Close()
  PaGlobalFunc_WorldMap_BottomMenu_Open()
  PaGlobalFunc_WorldMap_NodeWarInfo_Open()
  PaGlobalFunc_WorldMap_WarInfo_Open()
  PaGlobal_ConsoleWorldMapKeyGuide_SetShow(true)
end
function PaGlobalFunc_FromClient_WorldMap_SetTownMode(waypointKey)
  local self = Window_WorldMap_MainInfo
  if true == PaGlobalFunc_WorldMap_GetIsTownMode() then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "\237\131\128\236\154\180 \235\170\168\235\147\156\235\165\188 \236\151\172\235\159\172\235\178\136 \237\152\184\236\182\156 \237\150\136\236\138\181\235\139\136\235\139\164.")
    return
  end
  self._townModeWaypointKey = waypointKey
  local eCheckState = CppEnums.WorldMapCheckState
  local explorationNodeInClient = ToClient_getExploratioNodeInClientByWaypointKey(waypointKey)
  if nil ~= explorationNodeInClient then
    self:UpdateWorldMapNode(explorationNodeInClient)
  end
  PaGlobalFunc_WorldMap_WarInfo_Close()
  PaGlobalFunc_WorldMap_NodeWarInfo_Close()
  local knowledgeShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Knowledge)
  local fishNChipShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_FishnChip)
  local tradeShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Trade)
  ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, waypointKey)
  ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, waypointKey)
  ToClient_worldmapHouseManagerSetShow(true, waypointKey)
  ToClient_worldmapTradeNpcSetShow(tradeShow, waypointKey)
  ToClient_worldmapGuildHouseSetShow(true, waypointKey)
  ToClient_worldmapQuestManagerSetShow(false)
  ToClient_worldmapGuideLineSetShow(false)
  ToClient_worldmapDeliverySetShow(false)
  ToClient_worldmapTerritoryManagerSetShow(false)
  if true == _ContentsGroup_ForXBoxFinalCert then
    PaGlobalFunc_WorldMapSideBar_Close()
    PaGlobalFunc_WorldMapSideBar_RetreatToWorldMapMode()
  else
  end
  ToClient_SetGuildMode(false)
  PaGlobalFunc_WorldMap_SetIsTownMode(true)
  PaGlobalFunc_WorldMap_TopMenu_Open()
  PaGlobalFunc_WorldMap_BottomMenu_Close()
  PaGlobal_ConsoleWorldMapKeyGuide_SetShow(true)
  PaGlobalFunc_WorldMap_HouseFilter_FilterClear()
end
function FGlobal_WorldmapMain_IsAllowTutorialPanelShow()
  local self = Window_WorldMap_MainInfo
  return self._isAllowTutorialPanelShow
end
function FGlobal_WorldmapMain_SetAllowTutorialPanelShow(bAllow)
  local self = Window_WorldMap_MainInfo
  self._isAllowTutorialPanelShow = bAllow
end
function PaGlobalFunc_FromClient_WorldMap_OpenFromExplore(waypointKey)
  local self = Window_WorldMap_MainInfo
  self._isDialog = true
  local explorationNodeInClient = ToClient_getExploratioNodeInClientByWaypointKey(waypointKey)
  PaGlobalFunc_WorldMap_NodeManagement_Open(explorationNodeInClient)
end
function PaGlobalFunc_FromClient_WorldMap_Open()
  local self = Window_WorldMap_MainInfo
  if true == isDeadInWatchingMode() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPOPENALERT_INDEAD"))
    return
  end
  PaGlobal_ConsoleWorldMapKeyGuide_SetShow(true)
  self._isFadeOutWindow = false
  ToClient_SaveUiInfo(false)
  if true == ToClient_WorldMapIsShow() then
    PaGlobalFunc_WorldMap_PopClose()
    return
  end
  if Panel_Win_System:GetShow() then
    allClearMessageData()
  end
  if ToClient_CheckExistSummonMaid() or Panel_Window_Warehouse:GetShow() then
    Warehouse_Close()
  end
  SetUIMode(Defines.UIMode.eUIMode_WorldMap)
  ToClient_openWorldMap()
  setFullSizeMode(true, FullSizeMode.fullSizeModeEnum.Worldmap)
  if nil ~= Panel_PersonalIcon_NpcNavigation then
    FGlobal_NpcNavi_ShowRequestOuter()
  end
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    PaGlobalFunc_WorkerManager_All_Close()
  else
    PaGlobalFunc_WorkerManager_Close()
  end
  if nil ~= Panel_PersonalIcon_NpcNavigation then
    FGlobal_NpcNavi_Hide()
  end
  PaGlobalFunc_WorldMap_NodeWarInfo_Open()
  PaGlobalFunc_WorldMap_WarInfo_Open()
  if true == _ContentsGroup_ForXBoxFinalCert then
    PaGlobalFunc_WorldMapSideBar_Open()
  elseif false == _ContentsGroup_ForXBoxXR then
    FGlobal_WorldMapOpenForMenu()
    FGlobal_WorldMapOpenForMain()
  end
  self._isPrevShowQuestWigetPanel = Panel_CheckedQuest:GetShow()
  self._isPrevShowMainQuestPanel = Panel_MainQuest:GetShow()
  FGlobal_QuestWidget_Close()
  if false == _ContentsGroup_RenewUI_Worker then
    FGlobal_workerChangeSkill_Close()
    if not Panel_WorkerRestoreAll:IsUISubApp() then
      workerRestoreAll_Close()
    end
  end
  FGlobal_TentTooltipHide()
  FGolbal_ItemMarketNew_Close()
  if Panel_Window_ItemMarket_ItemSet:GetShow() then
    FGlobal_ItemMarketItemSet_Close()
  end
  if Panel_ChatOption:GetShow() then
    ChattingOption_Close()
  end
  Panel_Tooltip_Item_hideTooltip()
  delivery_requsetList()
  self._renderMode:set()
  if true ~= _ContentsGroup_ForXBoxXR or false == _ContentsGroup_ForXBoxFinalCert then
  end
  PaGlobalFunc_WorldMap_SetIsTownMode(false)
  PaGlobalFunc_WorldMap_TopMenu_Open()
  PaGlobalFunc_WorldMap_RingMenu_Open()
  PaGlobalFunc_WorldMap_BottomMenu_Open()
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_WORLDMAP")
  self._isImmediatelyClose = false
end
function PaGlobalFunc_FromClient_WorldMap_Close()
  local self = Window_WorldMap_MainInfo
  self._isClose = true
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
function PaGlobalFunc_WorldMap_CloseSubPanel()
  local self = Window_WorldMap_MainInfo
  Panel_Window_Warehouse:SetShow(false)
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    PaGlobalFunc_WorkerManager_All_Close()
  else
    PaGlobalFunc_WorkerManager_Close()
  end
  Panel_Working_Progress:SetShow(false)
  FGlobal_ItemMarketItemSet_Close()
  FGolbal_ItemMarketNew_Close()
  PaGlobalFunc_WorldMap_NodeWarInfo_Close()
  PaGlobalFunc_WorldMap_WarInfo_Close()
  PaGlobalFunc_TerritoryTooltipInfo_Close()
  PaGlobalFunc_nodeSiegeInfo_Close()
  PaGlobaFunc_WarFilter_Close()
  PaGlobal_WarInfomation_Close()
  if not _ContentsGroup_isUsedNewTradeEventNotice and not Panel_TradeMarket_EventInfo:IsUISubApp() then
    TradeEventInfo_Close()
  end
end
function Window_WorldMap_MainInfo:ClosePanel()
  if false == _ContentsGroup_RenewUI_Worker then
    if Panel_WorkerTrade_Caravan:GetShow() and nil ~= Panel_WorkerTrade_Caravan then
      FGlobal_WorkerTradeCaravan_Hide()
      return false
    end
  elseif true == _ContentsGroup_NewUI_WorkerAuction_All and nil ~= Panel_Window_WorkerAuction_All then
    HandleEventLUp_WorkerAuction_All_Close()
  elseif nil ~= Panel_Dialog_WorkerTrade_Renew then
    FGlobal_WorkerTrade_Close()
  end
  if true == PaGlobalFunc_WorldMap_RingMenu_GetIsRingMenuOpen() then
    PaGlobalFunc_WorldMap_RingMenu_SetShowRingMenu(false)
    return false
  end
  if true == PaGlobalFunc_WorldMap_NodeInfo_GetShow() then
    PaGlobalFunc_WorldMap_NodeInfo_Close()
    return false
  end
  if true == PaGlobalFunc_WorldMap_NodeManagement_GetShow() then
    PaGlobalFunc_WorldMap_NodeManagement_Close()
    return false
  end
  if true == PaGlobalFunc_WorldMap_NodeProduct_GetShow() then
    PaGlobalFunc_WorldMap_NodeProduct_Close()
    return false
  end
  return true
end
function Window_WorldMap_MainInfo:ClosePanelInTown()
  if true == PaGlobalFunc_WorldMapHouseManager_IsShow() then
    PaGlobalFunc_WorldMapHouseManager_Close()
    return false
  end
  if true == PaGlobalFunc_WorldMap_HouseCraft_GetShow() then
    PaGlobalFunc_WorldMap_HouseCraft_Close()
    return false
  end
  if true == PaGlobalFunc_WorldMap_HouseCraftLarge_GetShow() then
    PaGlobalFunc_WorldMap_HouseCraftLarge_Close()
    return false
  end
  if true == PaGlobalFunc_WorldMap_HouseFilter_GetShow() then
    PaGlobalFunc_WorldMap_HouseFilter_Close()
    return false
  end
  if true == PaGlobalFunc_WorldMap_RightMenu_GetShow() then
    PaGlobalFunc_WorldMap_RightMenu_Toggle()
    return false
  end
  if true == PaGlobalFunc_Warehouse_GetShow() then
    Warehouse_Close()
    DeliveryRequestWindow_Close()
    PaGlobalFunc_WorldMap_TopMenu_Open()
    PaGlobalFunc_WorldMap_RingMenu_Open()
    return false
  end
  if true == PaGlobalFunc_WorldMap_Stable_GetShow() then
    PaGlobalFunc_WorldMap_Stable_Close()
    return false
  end
  FGlobal_ClearWorldmapIconTooltip()
  return true
end
function Window_WorldMap_MainInfo:PrepareClosePanel()
  if true == PaGlobalFunc_WorldMap_SellBuyHouse_GetShow() then
    PaGlobalFunc_WorldMap_SellBuyHouse_Close()
    return false
  end
  if false == PaGlobalFunc_WorldMap_HouseFilter_CloseSubFilter() then
    return false
  end
  return true
end
function PaGlobalFunc_WorldMap_WindowEscape()
  local self = Window_WorldMap_MainInfo
  if false == self:PrepareClosePanel() then
    return
  end
  if false == self:ClosePanelInTown() then
    return
  end
  if false == self:ClosePanel() then
    return
  end
  if true == ToClient_WorldMapIsShow() then
    if true == PaGlobalFunc_WorldMap_GetIsTownMode() then
      ToClient_WorldMapPushEscape()
      return
    end
    if false ~= _ContentsGroup_ForXBoxXR or false == _ContentsGroup_ForXBoxFinalCert then
    end
    PaGlobalFunc_WorldMap_PopClose()
  end
  if false == PaGlobalFunc_WorldMap_GetIsTownMode() then
    PaGlobalFunc_WorldMap_CloseSubPanel()
    FGlobal_HideAll_Tooltip_Work_Copy()
  end
  if nil ~= Panel_Window_DailyStamp_Renew and true == Panel_Window_DailyStamp_Renew:GetShow() then
    Panel_Window_DailyStamp_Renew:ignorePadSnapUpdate(false)
  end
end
function PaGlobalFunc_WorldMap_GetIsClose()
  local self = Window_WorldMap_MainInfo
  return self._isClose
end
function PaGlobalFunc_WorldMap_PopClose()
  if false == ToClient_WorldMapIsShow() then
    return
  end
  ToClient_preCloseMap()
  if false == _ContentsGroup_RenewUI then
    Panel_Window_QuestNew_Show(false)
  end
  if true == _ContentsGroup_ForXBoxFinalCert then
    PaGlobalFunc_WorldMapSideBar_EraseArrow()
  else
  end
  PaGlobalFunc_WorldMap_NodeInfo_Close()
  PaGlobalFunc_WorldMap_NodeManagement_Close()
  PaGlobalFunc_WorldMap_NodeProduct_Close()
  PaGlobalFunc_WorldMapHouseManager_Close()
  PaGlobalFunc_WorldMap_HouseCraft_Close()
  PaGlobalFunc_WorldMap_HouseCraftLarge_Close()
  PaGlobalFunc_WorldMap_HouseFilter_Close()
  PaGlobalFunc_WorldMap_RightMenu_Toggle()
  Warehouse_Close()
  DeliveryRequestWindow_Close()
  PaGlobalFunc_WorldMap_Stable_Close()
  PaGlobalFunc_WorldMap_NodeWarInfo_Close()
  PaGlobalFunc_WorldMap_WarInfo_Close()
  DeliveryCarriageInformationWindow_Close()
  PaGlobalFunc_WorldMap_RingMenu_Close()
  PaGlobalFunc_WorldMap_RightMenu_Close()
  PaGlobalFunc_WorldMap_TopMenu_Close()
  PaGlobalFunc_WorldMap_BottomMenu_Close()
  FGlobal_Hide_Tooltip_Work(nil, true)
  FGlobal_HideWorkerTooltip()
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
function PaGlobalFunc_WorldMap_CloseForLuaKeyHandling(isAttacked)
  local self = Window_WorldMap_MainInfo
  if Defines.UIMode.eUIMode_WoldMapSearch == GetUIMode() then
    ClearFocusEdit()
    SetUIMode(Defines.UIMode.eUIMode_WorldMap)
  end
  if nil ~= isAttacked then
    self._isAttacked = isAttacked
  end
  PaGlobalFunc_WorldMap_PopClose()
end
function PaGlobalFunc_FromClient_WorldMap_ImmediatelyClose()
  local self = Window_WorldMap_MainInfo
  if true == self._isImmediatelyClose then
    return
  end
  FGlobal_TentTooltipHide()
  self._isFadeOutWindow = false
  DragManager:clearInfo()
  WorldMapPopupManager:clear()
  setFullSizeMode(false)
  self._renderMode:reset()
  Panel_WorldMap:ResetVertexAni()
  Panel_WorldMap:SetShow(false, false)
  ToClient_closeWorldMap()
  if nil ~= Panel_PersonalIcon_NpcNavigation then
    FGlobal_NpcNavi_ShowRequestOuter()
  end
  setShowLine(true)
  collectgarbage("collect")
  PaGlobalFunc_WorldMap_CloseSubPanel()
  PaGlobalFunc_WorldMap_NodeInfo_Close()
  PaGlobalFunc_WorldMap_NodeManagement_Close()
  PaGlobalFunc_WorldMap_NodeProduct_Close()
  PaGlobalFunc_WorldMapHouseManager_Close()
  PaGlobalFunc_WorldMap_HouseCraft_Close()
  PaGlobalFunc_WorldMap_HouseCraftLarge_Close()
  PaGlobalFunc_WorldMap_HouseFilter_Close()
  PaGlobalFunc_WorldMap_RightMenu_Toggle()
  Warehouse_Close()
  DeliveryRequestWindow_Close()
  PaGlobalFunc_WorldMap_Stable_Close()
  PaGlobal_WarInfomation_Close()
  PaGlobalFunc_WorldMap_RingMenu_Close()
  PaGlobalFunc_WorldMap_TopMenu_Close()
  PaGlobalFunc_WorldMap_BottomMenu_Close()
  PaGlobalFunc_WorldMap_NodeWarInfo_Close()
  PaGlobalFunc_WorldMap_WarInfo_Close()
  PaGlobalFunc_TerritoryTooltipInfo_Close()
  PaGlobalFunc_nodeSiegeInfo_Close()
  PaGlobaFunc_WarFilter_Close()
  self._isClose = false
  Panel_CheckedQuest:SetShow(self._isPrevShowQuestWigetPanel)
  Panel_MainQuest:SetShow(self._isPrevShowMainQuestPanel)
  self._isPrevShowQuestWigetPanel = false
  self._isPrevShowMainQuestPanel = false
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    PaGlobalFunc_WorkerManager_All_Close()
  else
    PaGlobalFunc_WorkerManager_Close()
  end
  if nil ~= FGlobal_TownfunctionNavi_UnSetWorldMap then
    FGlobal_TownfunctionNavi_UnSetWorldMap()
  end
  FGlobal_HouseInstallation_MinorWar_Close()
  if true == self._isDialog then
    PaGlobalFunc_MainDialog_ReOpen()
  else
    SetUIMode(Defines.UIMode.eUIMode_Default)
  end
  if true == self._isAttacked then
    FromClient_CloseMainDialogByAttacked()
    PaGlobalFunc_MainDialog_Hide()
    PaGlobalFunc_MainDialog_Close()
  end
  self._isDialog = false
  self._isAttacked = false
  CheckChattingInput()
  if ToClient_IsSavedUi() then
    ToClient_SaveUiInfo(false)
    ToClient_SetSavedUi(false)
  end
  if true == _ContentsGroup_RenewUI then
    PaGlobal_ConsoleWorldMapKeyGuide_SetShow(false)
  end
  if nil ~= FGlobal_Panel_MovieTheater640_WindowClose then
    FGlobal_Panel_MovieTheater640_WindowClose()
  end
  self._isImmediatelyClose = true
end
function Window_WorldMap_MainInfo:InitControl()
end
function Window_WorldMap_MainInfo:InitEvent()
  self._renderMode:setClosefunctor(self._renderMode, PaGlobalFunc_WorldMap_CloseForLuaKeyHandling)
  Panel_WorldMap:RegisterUpdateFunc("PaGlobalFunc_WorldMap_UpdatePerFrame")
  ToClient_WorldmapRegisterShowEventFunc(true, "FGlobal_WorldmapShowAni()")
  ToClient_WorldmapRegisterShowEventFunc(false, "FGlobal_WorldmapHideAni()")
end
local startPressTime = 0
local currentPressTime = 0
local endPressTime = 0
local _yButtonPressed = false
function PaGlobalFunc_WorldMap_UpdatePerFrame(deltaTime)
  local self = Window_WorldMap_MainInfo
  if true == PaGlobalFunc_WorldMap_RingMenu_GetIsRingMenuOpen() then
    return
  end
  if true == isPadDown(__eJoyPadInputType_Y) then
    if false == PaGlobalFunc_WorldMap_RingMenu_GetShow() then
      return
    end
    if false == _yButtonPressed then
      _yButtonPressed = true
      PaGlobalFunc_WorldMap_TopMenu_OnYPressed(true)
      _AudioPostEvent_SystemUiForXBOX(51, 7)
      if 5 == PaGlobalFunc_WorldMap_TopMenu_GetMenuIndex() then
        PaGlobalFunc_WorldMap_TopMenu_ShowYDown(true)
      end
    end
  end
  if true == isPadUp(__eJoyPadInputType_DPad_Right) then
    if true == _yButtonPressed then
      if false == PaGlobaFunc_WarFilter_GetShow() then
        PaGlobalFunc_WorldMap_TopMenu_NextMenu(false)
      else
        Input_WarFilter_DPad(__eJoyPadInputType_DPad_Right)
      end
    end
  elseif true == isPadUp(__eJoyPadInputType_DPad_Left) and true == _yButtonPressed then
    if false == PaGlobaFunc_WarFilter_GetShow() then
      PaGlobalFunc_WorldMap_TopMenu_NextMenu(true)
    else
      Input_WarFilter_DPad(__eJoyPadInputType_DPad_Left)
    end
  end
  if true == isPadUp(__eJoyPadInputType_Y) then
    _yButtonPressed = false
    PaGlobalFunc_WorldMap_TopMenu_OnYPressed(false)
    PaGlobalFunc_WorldMap_TopMenu_ShowYDown(false)
    if true == PaGlobaFunc_WarFilter_GetShow() then
      PaGlobaFunc_WarFilter_ApplyAndClose()
      PaGlobalFunc_nodeSiegeInfo_Close()
    end
    _AudioPostEvent_SystemUiForXBOX(51, 7)
    if false == PaGlobalFunc_WorldMap_TopMenu_GetShow() then
      return
    end
    if false == PaGlobalFunc_WorldMap_GetIsTownMode() then
      if false == PaGlobalFunc_WorldMap_RingMenu_GetShow() then
        return
      end
    else
      PaGlobalFunc_WorldMap_TopMenu_ToggleTownMenu()
    end
  end
  if false == PaGlobalFunc_WorldMap_BottomMenu_GetShow() then
    return
  end
  if false == PaGlobalFunc_WorldMap_RingMenu_GetShow() then
    return
  end
  if true == isPadUp(__eJoyPadInputType_DPad_Down) then
    if true == _yButtonPressed and true == _Contents_NodeWarIsOpen and 5 == PaGlobalFunc_WorldMap_TopMenu_GetMenuIndex() then
      if false == PaGlobaFunc_WarFilter_GetShow() then
        PaGlobaFunc_WarFilter_Open()
      else
        Input_WarFilter_DPad(__eJoyPadInputType_DPad_Down)
      end
    else
      PaGlobalFunc_WorldMap_BottomMenu_ModeChange(1)
    end
  end
  if true == isPadUp(__eJoyPadInputType_DPad_Up) then
    if true == _yButtonPressed and PaGlobaFunc_WarFilter_GetShow() then
      Input_WarFilter_DPad(__eJoyPadInputType_DPad_Up)
    else
      PaGlobalFunc_WorldMap_BottomMenu_ModeChange(0)
    end
  end
  if true == isPadUp(__eJoyPadInputType_RightTrigger) then
    _AudioPostEvent_SystemUiForXBOX(51, 7)
    PaGlobalFunc_WorldMap_BottomMenu_StartTrigger()
  end
  if true == isPadUp(__eJoyPadInputType_RightShoulder) then
    _AudioPostEvent_SystemUiForXBOX(51, 6)
    PaGlobalFunc_WorldMap_BottomMenu_UpdateMenu(1)
  end
  if true == isPadUp(__eJoyPadInputType_LeftShoulder) then
    _AudioPostEvent_SystemUiForXBOX(51, 6)
    PaGlobalFunc_WorldMap_BottomMenu_UpdateMenu(-1)
  end
  if 0 ~= PaGlobalFunc_WorldMap_BottomMenu_GetMode() then
    return
  end
  if true == isPadDown(__eJoyPadInputType_X) then
    startPressTime = deltaTime
    endPressTime = startPressTime + 1
  end
  if true == isPadPressed(__eJoyPadInputType_X) then
    currentPressTime = currentPressTime + deltaTime
    if startPressTime + 0.5 <= currentPressTime then
      self._xPressedCheck = true
    end
    if endPressTime <= currentPressTime and 0 ~= startPressTime and 0 ~= endPressTime then
      if -1 == PaGlobalFunc_WorldMap_GetFocusedBookMarkIndex() then
        ToClient_SetWorldMapBookMark(PaGlobalFunc_WorldMap_BottomMenu_GetBookMarkIndex())
      else
        ToClient_UnSetWorldMapBookMark(PaGlobalFunc_WorldMap_GetFocusedBookMarkIndex())
        PaGlobalFunc_WorldMap_ClearFocusedBookMarkIndex()
      end
      PaGlobalFunc_WorldMap_BottomMenu_UpdateMenu(0)
      startPressTime = 0
      endPressTime = 0
      currentPressTime = 0
    end
  end
  if true == isPadUp(__eJoyPadInputType_X) then
    startPressTime = 0
    endPressTime = 0
    currentPressTime = 0
  end
end
function Window_WorldMap_MainInfo:InitRegister()
  registerEvent("FromClient_WorldMapOpen", "PaGlobalFunc_FromClient_WorldMap_Open")
  registerEvent("FromClient_WorldMapOpenFromExplore", "PaGlobalFunc_FromClient_WorldMap_OpenFromExplore")
  registerEvent("FromClient_ExitWorldMap", "PaGlobalFunc_FromClient_WorldMap_Close")
  registerEvent("FromClient_ImmediatelyCloseWorldMap", "PaGlobalFunc_FromClient_WorldMap_ImmediatelyClose")
  registerEvent("FromClient_WorldMapFadeOut", "PaGlobalFunc_FromClient_WorldMap_FadeOut")
  registerEvent("FromClient_WorldMapFadeOutHideUI", "PaGlobalFunc_FromClient_WorldMap_FadeOutHideUI")
  registerEvent("FromClient_SetTownMode", "PaGlobalFunc_FromClient_WorldMap_SetTownMode")
  registerEvent("FromClient_resetTownMode", "PaGlobalFunc_FromClient_WorldMap_ReSetTownMode")
  registerEvent("FromClient_WorldMapNodeUpgrade", "PaGlobalFunc_FromClient_WorldMap_UpdateWorldMapNode")
  registerEvent("FromClint_EventUpdateExplorationNode", "PaGlobalFunc_FromClient_WorldMap_UpdateExplorationNode")
  registerEvent("FromClient_RClickWorldmapPanel", "FromClient_RClickWorldmapPanel")
  registerEvent("FromClient_DeleteNaviGuidOnTheWorldmapPanel", "PaGlobalFunc_FromClient_WorldMap_DeleteNaviGuidOnTheWorldmapPanel")
  registerEvent("FromClient_HideAutoCompletedNaviBtn", "PaGlobalFunc_FromClient_WorldMap_HideAutoCompletedNaviBtn")
  registerEvent("FromClient_DeliveryRequestAck", "DeliveryRequest_UpdateRequestSlotData")
  registerEvent("EventDeliveryInfoUpdate", "DeliveryInformation_UpdateSlotData")
  registerEvent("progressEventCancelByAttacked", "PaGlobalFunc_FromClient_WorldMap_EventSelfPlayerAttacked")
  registerEvent("EventSelfPlayerPreDead", "PaGlobalFunc_FromClient_WorldMap_EventSelfPlayerAttacked")
  registerEvent("FromClient_SetGuildModeeWorldMapNodeIcon", "FromClient_WorldMapNodeInfo_SetGuildMode")
  registerEvent("FromClient_NodeIsNextSiege", "FromClient_NodeIsNextSiege")
  registerEvent("FromClient_NodeFilterOn", "FromClient_NodeFilterOn")
end
function Window_WorldMap_MainInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function FromClient_NodeIsNextSiege(explorationNode)
  explorationNode:EraseAllEffect()
  explorationNode:AddEffect("UI_ArrowMark_Diagonal01", true, 70, 80)
end
function FromClient_NodeFilterOn(btn)
  btn:EraseAllEffect()
  btn:AddEffect("UI_ArrowMark_Diagonal01", true, 70, 80)
end
function FromClient_WorldMapNodeInfo_SetGuildMode(nodeBtn)
  local dayType = {
    [0] = "0Sunday",
    "1Monday",
    "2Tuesday",
    "3wednesday",
    "4Thursday",
    "5Friday",
    "6Saturday"
  }
  if PaGlobalFunc_WorldMap_TopMenu_GetIsGuildMode() then
    local warStateIcon = nodeBtn:FromClient_getWarStateIcon()
    local guildMark = nodeBtn:FromClient_getGuildMark()
    local guildMarkBG = nodeBtn:FromClient_getGuildMarkBG()
    local guildIcon = nodeBtn:FromClient_getNodeGuildIcon()
    local explorationInfo = nodeBtn:FromClient_getExplorationNodeInClient()
    local villageSiegeType = nodeBtn:getVillageSiegeType()
    local siegeNode = nodeBtn:FromClient_getExplorationNodeInClient():getStaticStatus():getMinorSiegeRegion()
    if nil ~= siegeNode and villageSiegeType < 7 then
      local taxGrade = siegeNode:getVillageTaxLevel()
      warStateIcon:SetShow(false)
      guildMark:SetShow(false)
      guildMarkBG:SetShow(false)
      nodeBtn:SetMonoTone(false)
      local normalUrl = "New_UI_Common_forLua/Widget/WorldMap/WorldMap_NodeWarGuildIcon/" .. dayType[villageSiegeType] .. "/" .. tostring(taxGrade) .. "_Nomal.dds"
      local overUrl = "New_UI_Common_forLua/Widget/WorldMap/WorldMap_NodeWarGuildIcon/" .. dayType[villageSiegeType] .. "/" .. tostring(taxGrade) .. "_Over.dds"
      local clickUrl = "New_UI_Common_forLua/Widget/WorldMap/WorldMap_NodeWarGuildIcon/" .. dayType[villageSiegeType] .. "/" .. tostring(taxGrade) .. "_Click.dds"
      nodeBtn:ChangeTextureInfoName(normalUrl)
      nodeBtn:getBaseTexture():setUV(0, 0, 1, 1)
      nodeBtn:setRenderTexture(nodeBtn:getBaseTexture())
      nodeBtn:ChangeOnTextureInfoName(overUrl)
      nodeBtn:ChangeClickTextureInfoName(clickUrl)
    end
    if nil ~= explorationInfo then
      local explorationInfoSSW = explorationInfo:getStaticStatus()
      local minorSiegeRegion = explorationInfoSSW:getMinorSiegeRegion()
      if nil ~= minorSiegeRegion then
        local regionKey = minorSiegeRegion._regionKey:get()
        local isWeekNode = ToClient_IsVillageSiegeInThisWeek(regionKey)
        if isWeekNode then
          guildMark:SetMonoTone(false)
          guildMarkBG:SetMonoTone(false)
          guildIcon:SetMonoTone(false)
        else
          guildMark:SetMonoTone(true)
          guildMarkBG:SetMonoTone(true)
          guildIcon:SetMonoTone(true)
        end
      end
    end
  else
    FromClient_WorldMapNodeInfo_GuildWarSet(nodeBtn)
  end
end
function FromClient_WorldMapNodeInfo_GuildWarSet(nodeBtn)
  local explorationInfo = nodeBtn:FromClient_getExplorationNodeInClient()
  local nodeStaticStatus = explorationInfo:getStaticStatus()
  local regionInfo = nodeStaticStatus:getMinorSiegeRegion()
  local warStateIcon = nodeBtn:FromClient_getWarStateIcon()
  local guildModeGuildMark = nodeBtn:FromClient_getNodeGuildIcon()
  if nil ~= regionInfo then
    local regionKey = regionInfo._regionKey
    local regionWrapper = getRegionInfoWrapper(regionKey:get())
    local minorSiegeWrapper = regionWrapper:getMinorSiegeWrapper()
    local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(regionKey:get())
    local guildMark = nodeBtn:FromClient_getGuildMark()
    local guildMarkBG = nodeBtn:FromClient_getGuildMarkBG()
    if nil ~= minorSiegeWrapper then
      if minorSiegeWrapper:isSiegeBeing() then
        warStateIcon:setUpdateTextureAni(true)
        warStateIcon:SetShow(true)
        guildMark:SetShow(false)
        guildMarkBG:SetShow(false)
      else
        warStateIcon:setUpdateTextureAni(false)
        if true == siegeWrapper:doOccupantExist() then
          local isSet = setGuildTextureByGuildNo(siegeWrapper:getGuildNo(), guildMark)
          if false == isSet then
            guildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(guildMark, 183, 1, 188, 6)
            guildMark:getBaseTexture():setUV(x1, y1, x2, y2)
          else
            guildMark:getBaseTexture():setUV(0, 0, 1, 1)
          end
          guildMark:setRenderTexture(guildMark:getBaseTexture())
          warStateIcon:SetShow(false)
          guildMark:SetShow(true)
          guildMarkBG:SetShow(true)
        else
          warStateIcon:SetShow(true)
          guildMark:SetShow(false)
          guildMarkBG:SetShow(false)
        end
      end
    else
      warStateIcon:SetShow(false)
      guildMark:SetShow(false)
      guildMarkBG:SetShow(false)
    end
    guildModeGuildMark:SetShow(false)
  end
end
function PaGlobalFunc_FromClient_WorldMap_EventSelfPlayerAttacked()
  PaGlobalFunc_WorldMap_CloseForLuaKeyHandling(true)
end
function FromClient_RClickWorldmapPanel(pos3D, immediately, isTopPicking)
  local self = Window_WorldMap_MainInfo
  if true == self._xPressedCheck then
    self._xPressedCheck = false
    return
  end
  local selfPlayer = getSelfPlayer()
  if false == immediately and ToClient_IsShowNaviGuideGroup(0) then
    if true == PaGlobal_TutorialManager:isDoingTutorial() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_TUTORIAL_ACK"))
      return
    end
    if isPadPressed(__eJoyPadInputType_LeftTrigger) then
      ToClient_WorldMapNaviStartFromConsole(pos3D, NavigationGuideParam(), false, isTopPicking)
    else
      ToClient_DeleteNaviGuideByGroup(0)
      _AudioPostEvent_SystemUiForXBOX(0, 15)
    end
    return
  end
  if 0 ~= ToClient_GetMyTeamNoLocalWar() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_LOCALWAR_CANTNAVI_ACK"))
    return
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_TUTORIAL_ACK"))
    return
  end
  if false == isKeyPressed(CppEnums.VirtualKeyCode.KeyCode_MENU) then
    ToClient_DeleteNaviGuideByGroup(0)
  end
  ToClient_WorldMapNaviStartFromConsole(pos3D, NavigationGuideParam(), false, isTopPicking)
  _AudioPostEvent_SystemUiForXBOX(0, 14)
end
function PaGlobalFunc_FromClient_WorldMap_HideAutoCompletedNaviBtn(isShow)
  local self = Window_WorldMap_MainInfo
  self._hideAutoCompletedNaviBtn = isShow
end
function PaGlobalFunc_FromClient_WorldMap_DeleteNaviGuidOnTheWorldmapPanel()
  ToClient_DeleteNaviGuideByGroup(0)
end
function PaGlobalFunc_FromClient_WorldMap_UpdateExplorationNode()
  if false == ToClient_WorldMapIsShow() then
    return
  end
  ToClient_reloadNodeLine(PaGlobalFunc_WorldMap_TopMenu_GetIsGuildMode(), CppEnums.WaypointKeyUndefined)
end
function PaGlobalFunc_WorldMap_Open()
  if GetUIMode() == Defines.UIMode.eUIMode_Gacha_Roulette then
    return
  end
  if CppEnums.worldmapRenderState.NOT_RENDER ~= ToClient_getWorldmapRenderState() then
    return
  end
  if true == ToClient_SniperGame_IsPlaying() then
    return
  end
  if nil ~= Panel_Window_DailyStamp_Renew and true == Panel_Window_DailyStamp_Renew:GetShow() then
    ToClient_padSnapSetTargetPanel(Panel_WorldMap)
    Panel_WorldMap:ignorePadSnapMoveToOtherPanel()
    Panel_Window_DailyStamp_Renew:ignorePadSnapUpdate(true)
  end
  if Panel_Casting_Bar:GetShow() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NOTOPEN_INGACTION"))
    return
  end
  FGlobal_HideWorkerTooltip()
  PaGlobalFunc_ChattingInfo_Close()
  ToClient_AddWorldMapFlush()
end
function PaGlobalFunc_FromClient_WorldMap_Main_luaLoadComplete()
  local self = Window_WorldMap_MainInfo
  self:Initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_WorldMap_Main_luaLoadComplete")

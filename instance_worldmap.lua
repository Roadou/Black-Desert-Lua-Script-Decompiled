local IM = CppEnums.EProcessorInputMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local ENT = CppEnums.ExplorationNodeType
local UI_color = Defines.Color
local UI_TYPE = CppEnums.PA_UI_CONTROL_TYPE
local UI_TM = CppEnums.TextMode
local VCK = CppEnums.VirtualKeyCode
local isCloseWorldMap = false
local HideAutoCompletedNaviBtn = false
local isPrevShowMainQuestPanel = false
local isPrevShowPanel = false
local isCullingNaviBtn = true
local isFirstCall = true
local renderMode = RenderModeWrapper.new(100, {
  Defines.RenderMode.eRenderMode_WorldMap
}, false)
if nil == WorldMapWindow then
  WorldMapWindow = {}
end
local altKeyGuide = ToClient_getWorldmapKeyGuideUI()
WorldMapWindow.EnumInfoNodeKeyType = {
  eInfoNodeKeyType_Waypoint = 0,
  eInfoNodeKeyType_HouseListIdx = 1,
  eInfoNodeKeyType_Region = 2,
  eInfoNodeKeyType_FixedHouseListIdx = 3
}
ToClient_WorldmapRegisterShowEventFunc(true, "FGlobal_WorldmapShowAni()")
ToClient_WorldmapRegisterShowEventFunc(false, "FGlobal_WorldmapHideAni()")
function FGlobal_WorldmapShowAni()
  local worldmapRenderUI = ToClient_getWorldmapRenderBase()
  worldmapRenderUI:ResetVertexAni()
  ToClient_WorldmapSetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  if CppEnums.WorldMapAnimationStyle.noAnimation == ToClient_getGameOptionControllerWrapper():getWorldmapOpenType() then
    local aniInfo = worldmapRenderUI:addColorAnimation(0, 0.3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(UI_color.C_00FFFFFF)
    aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
    aniInfo.IsChangeChild = false
  elseif nil == selfPlayer or selfPlayer:getRegionInfoWrapper():isDesert() and false == selfPlayer:isResistDesert() then
    local aniInfo = worldmapRenderUI:addColorAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(UI_color.C_FFFFFFFF)
    aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
    aniInfo.IsChangeChild = false
  else
    local aniInfo = worldmapRenderUI:addColorAnimation(0, 0.8, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(UI_color.C_00FFFFFF)
    aniInfo:SetEndColor(2147483647)
    aniInfo.IsChangeChild = false
    aniInfo = worldmapRenderUI:addColorAnimation(0.8, 1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo:SetStartColor(2147483647)
    aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
    aniInfo.IsChangeChild = false
  end
  Panel_WorldMap:ResetVertexAni()
  ToClient_WorldmapSetAlpha(0)
  audioPostEvent_SystemUi(1, 2)
end
function FGlobal_WorldmapHideAni()
end
local SelectedNode
local isFadeOutWindow = false
function FGlobal_SelectedNode()
  return SelectedNode
end
function HandleClicked_CompleteNode()
  if ToClient_WorldMapNaviEmpty() == true or ToClient_WorldMapNaviIsLoopPath() == true or false ~= HideAutoCompletedNaviBtn then
    return
  end
  if 0 ~= ToClient_GetMyTeamNoLocalWar() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_LOCALWAR_CANTNAVI_ACK"))
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if selfPlayer:getRegionInfoWrapper():isDesert() == true then
    return
  end
  ToClient_DeleteNaviGuideByGroup(0)
  ToClient_OnCompletedNodeLoop(NavigationGuideParam())
  TooltipSimple_Hide()
  isCullingNaviBtn = true
end
function SimpleTooltip_NodeBtn(isShow, tipType)
  if not isShow then
    ToClient_OnNaviRenderAsloopPath(isShow)
    TooltipSimple_Hide()
    return
  end
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_AUTONAVITITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_AUTONAVIDESC") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SHORTBUTTON_HOWTOUSE_TOOLTIP_DESC")
    control = naviBtn
  end
  TooltipSimple_Show(control, name, desc)
  ToClient_OnNaviRenderAsloopPath(isShow)
end
function FromClient_DeleteNaviGuidOnTheWorldmapPanel()
  ToClient_DeleteNaviGuideByGroup(0)
end
function FromClient_RClickWorldmapPanel(pos3D, immediately, isTopPicking)
  if false == immediately and ToClient_IsShowNaviGuideGroup(0) then
    if getSelfPlayer():get():getLevel() < 11 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_TUTORIAL_ACK"))
      return
    end
    if isKeyPressed(VCK.KeyCode_MENU) then
      ToClient_WorldMapNaviStart(pos3D, NavigationGuideParam(), false, isTopPicking)
    else
      ToClient_DeleteNaviGuideByGroup(0)
      audioPostEvent_SystemUi(0, 15)
    end
    if ToClient_WorldMapNaviIsLoopPath() == true then
    end
    isCullingNaviBtn = true
    return
  end
  if 0 ~= ToClient_GetMyTeamNoLocalWar() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_LOCALWAR_CANTNAVI_ACK"))
    return
  end
  if getSelfPlayer():get():getLevel() < 11 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_TUTORIAL_ACK"))
    return
  end
  if false == isKeyPressed(VCK.KeyCode_MENU) then
    ToClient_DeleteNaviGuideByGroup(0)
  end
  ToClient_WorldMapNaviStart(pos3D, NavigationGuideParam(), false, isTopPicking)
  audioPostEvent_SystemUi(0, 14)
  local selfPlayer = getSelfPlayer()
  isCullingNaviBtn = true
  if ToClient_WorldMapNaviPickingIsDesert(pos3D) == false and selfPlayer:getRegionInfoWrapper():isDesert() == false and ToClient_WorldMapNaviIsLoopPath() == false and selfPlayer:getRegionInfoWrapper():isOcean() == false and ToClient_WorldMapNaviEmpty() == false and HideAutoCompletedNaviBtn == false then
    isCullingNaviBtn = false
    WorldMap_ShortcutButton_RePos()
  end
  HideAutoCompletedNaviBtn = false
end
function FromClient_WorldMapFadeOutHideUI(frameTime)
  local worldmapRenderUI = ToClient_getWorldmapRenderBase()
  worldmapRenderUI:ResetVertexAni()
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
  audioPostEvent_SystemUi(1, 3)
end
function FromClient_LClickedWorldMapNode(explorationNode)
  SelectedNode = explorationNode:FromClient_getExplorationNodeInClient()
  PaGlobal_TutorialManager:handleLClickWorldMapNode(explorationNode)
end
function FromClient_NodeIsNextSiege(explorationNode)
  explorationNode:EraseAllEffect()
  explorationNode:AddEffect("UI_ArrowMark_Diagonal01", true, 70, 80)
end
function FromClient_KnowledgeWorldMapPath(pos3D)
  local navParam = NavigationGuideParam()
  navParam._worldmapColor = float4(1, 0.55, 0.55, 0.55)
  navParam._worldmapBgColor = float4(1, 0.85, 0.85, 0.6)
  ToClient_DeleteNaviGuideByGroup(0)
  ToClient_WorldMapNaviStart(pos3D, navParam, false, true)
  audioPostEvent_SystemUi(0, 14)
end
function UpdateWorldMapNode(node)
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
  if true == _ContentsGroup_ForXBoxFinalCert then
    if nil ~= PaGlobalFunc_WorldMapSideBar_EraseArrow then
      PaGlobalFunc_WorldMapSideBar_EraseArrow()
    end
    PaGlobalFunc_WorldMapNodeInfo_Open(node)
    WorldMapPopupManager:increaseLayer()
    WorldMapPopupManager:push(Panel_Worldmap_NodeInfo_Console, true)
  else
    if nil ~= WorldMapArrowEffectEraseClear then
      WorldMapArrowEffectEraseClear()
    end
    FGlobal_ShowInfoNodeMenuPanel(node)
    WorldMapPopupManager:increaseLayer()
    WorldMapPopupManager:push(Panel_NodeMenu, true)
    if nil ~= regionInfo then
      local regionKey = regionInfo._regionKey
      local regionWrapper = getRegionInfoWrapper(regionKey:get())
      local minorSiegeWrapper = regionWrapper:getMinorSiegeWrapper()
      if nil ~= minorSiegeWrapper then
        WorldMapPopupManager:push(Panel_NodeOwnerInfo, true)
      end
    end
    FGlobal_OpenOtherPanelWithNodeMenu(node, true)
  end
  FGlobal_FilterClear()
  NodeName_ShowToggle(true)
end
function FGlobal_OpenOtherPanelWithNodeMenu(node, isShow)
  if false == ToClient_WorldMapIsShow() then
    return
  end
  if true ~= isShow then
    return
  end
  if false == Panel_NodeMenu:IsShow() then
    return
  end
  local plantKey = node:getPlantKey()
  local nodeKey = plantKey:getWaypointKey()
  local wayPlant = ToClient_getPlant(plantKey)
  local exploreLevel = node:getLevel()
  if exploreLevel > 0 and wayPlant ~= nil and wayPlant:getType() == CppEnums.PlantType.ePlantType_Zone then
    local workingcnt = ToClient_getPlantWorkingList(plantKey)
    if 0 == workingcnt then
      local _plantKey = node:getPlantKey()
      local nod_Key = _plantKey:get()
      local explorationSSW = ToClient_getExplorationStaticStatusWrapper(nod_Key)
      if explorationSSW:get():isFinance() then
        FGlobal_Finance_WorkManager_Reset_Pos()
        FGlobal_Finance_WorkManager_Open(node)
      else
        FGlobal_Plant_WorkManager_Reset_Pos()
        FGlobal_Plant_WorkManager_Open(node)
      end
    elseif 1 == workingcnt then
      FGlobal_ShowWorkingProgress(node, 1)
    end
  end
end
function FromClient_WorldMapNodeFindNearNode(nodeKey)
  ToClient_DeleteNaviGuideByGroup(0)
  ToClient_WorldMapFindNearNode(nodeKey, NavigationGuideParam())
  audioPostEvent_SystemUi(0, 14)
end
function FromClient_WorldMapNodeFindTargetNode(nodeKey)
  local explorationSSW = ToClient_getExplorationStaticStatusWrapper(nodeKey)
  if nil == explorationSSW then
    return
  end
  ToClient_DeleteNaviGuideByGroup(0)
  ToClient_WorldMapNaviStart(explorationSSW:get():getPosition(), NavigationGuideParam(), false, false)
  audioPostEvent_SystemUi(0, 14)
end
function FGlobal_LoadWorldMapTownSideWindow(nodeKey)
  local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint(nodeKey)
  if nil ~= regionInfoWrapper and regionInfoWrapper:get():isMainOrMinorTown() and regionInfoWrapper:get():hasWareHouseNpc() then
    Warehouse_OpenPanelFromWorldmap(nodeKey, CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap)
  end
end
function FGlobal_PushOpenWorldMap()
  if GetUIMode() == Defines.UIMode.eUIMode_Gacha_Roulette then
    return
  end
  if CppEnums.worldmapRenderState.NOT_RENDER ~= ToClient_getWorldmapRenderState() then
    return
  end
  if true == ToClient_SniperGame_IsPlaying() then
    return
  end
  if Instance_Casting_Bar:GetShow() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NOTOPEN_INGACTION"))
    return
  end
  PaGlobalFunc_FullScreenFade_RunAfterFadeIn(FGlobal_PushOpenWorldMapActual)
end
function FGlobal_PushOpenWorldMapActual()
  PaGlobalFunc_FullScreenFade_FadeOut()
  FGlobal_HideWorkerTooltip()
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_Hide()
  else
    FGlobal_HideDialog()
  end
  if true == _ContentsGroup_RenewUI_Chatting then
    PaGlobalFunc_ChattingInfo_Close()
  end
  ToClient_AddWorldMapFlush()
end
function FGlobal_CloseWorldmapForLuaKeyHandling()
  if Defines.UIMode.eUIMode_WoldMapSearch == GetUIMode() then
    ClearFocusEdit()
    SetUIMode(Defines.UIMode.eUIMode_WorldMap)
  end
  FGlobal_PopCloseWorldMap()
end
function FGlobal_PopCloseWorldMap()
  if ToClient_WorldMapIsShow() then
    PaGlobalFunc_FullScreenFade_RunAfterFadeIn(FGlobal_PopCloseWorldMapActual)
  end
end
function FGlobal_PopCloseWorldMapActual()
  PaGlobalFunc_FullScreenFade_FadeOut()
  ToClient_preCloseMap()
  Panel_NodeSiegeTooltip:SetShow(false)
  Panel_WorldMap_Tooltip:SetShow(false)
  if false == _ContentsGroup_RenewUI then
    Panel_Window_QuestNew_Show(false)
  end
  Instance_Tooltip_SimpleText:SetShow(false)
  isCloseWorldMap = false
  if true == _ContentsGroup_ForXBoxFinalCert then
    PaGlobalFunc_WorldMapSideBar_EraseArrow()
  else
    WorldMapArrowEffectErase()
  end
  DeliveryCarriageInformationWindow_Close()
  FGlobal_Hide_Tooltip_Work(nil, true)
  FGlobal_HideWorkerTooltip()
end
function FromClient_WorldMapOpen()
  if isDeadInWatchingMode() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPOPENALERT_INDEAD"))
    return
  end
  if true == _ContentsGroup_RenewUI then
    PaGlobal_ConsoleWorldMapKeyGuide_SetShow(true)
  end
  isFadeOutWindow = false
  ToClient_SaveUiInfo(false)
  if ToClient_WorldMapIsShow() then
    FGlobal_PopCloseWorldMap()
    return
  end
  if Instance_MessageBox:GetShow() then
    allClearMessageData()
  end
  if ToClient_CheckExistSummonMaid() or Panel_Window_Warehouse:GetShow() then
    Warehouse_Close()
  end
  PaGlobal_TutorialManager:handleBeforeWorldmapOpen()
  Panel_MovieTheater640_Initialize()
  SetUIMode(Defines.UIMode.eUIMode_WorldMap)
  ToClient_openWorldMap()
  FGlobal_NpcNavi_ShowRequestOuter()
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_Close()
  else
    Panel_Npc_Dialog:SetShow(false)
  end
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    PaGlobalFunc_WorkerManager_All_Close()
  else
    workerManager_Close()
  end
  FGlobal_NpcNavi_Hide()
  FGlobal_WarInfo_Open()
  FGlobal_NodeWarInfo_Open()
  if true == _ContentsGroup_ForXBoxFinalCert then
    PaGlobalFunc_WorldMapSideBar_Open()
  elseif false == _ContentsGroup_ForXBoxXR then
    FGlobal_WorldMapOpenForMenu()
    FGlobal_WorldMapOpenForMain()
  end
  isPrevShowPanel = Panel_CheckedQuest:GetShow()
  isPrevShowMainQuestPanel = Panel_MainQuest:GetShow()
  FGlobal_QuestWidget_Close()
  if false == _ContentsGroup_RenewUI_Worker then
    FGlobal_workerChangeSkill_Close()
    if not Panel_WorkerRestoreAll:IsUISubApp() then
      workerRestoreAll_Close()
    end
  else
  end
  FGlobal_TentTooltipHide()
  if Panel_CheckedQuestInfo:GetShow() and not Panel_CheckedQuestInfo:IsUISubApp() then
    Panel_CheckedQuestInfo:SetShow(false)
  end
  FGolbal_ItemMarketNew_Close()
  if PaGlobalFunc_ItemMarketItemSet_GetShow() then
    FGlobal_ItemMarketItemSet_Close()
  end
  if Instance_ChatOption:GetShow() then
    ChattingOption_Close()
  end
  isCullingNaviBtn = true
  Panel_WorldMapNaviBtn()
  Panel_Tooltip_Item_hideTooltip()
  delivery_requsetList()
  renderMode:set()
  if true == ToClient_WorldMapIsShow() then
    PaGlobal_TutorialManager:handleWorldMapOpenComplete()
  end
  if true ~= _ContentsGroup_ForXBoxXR or false == _ContentsGroup_ForXBoxFinalCert then
  end
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_WORLDMAP")
end
function FGlobal_Worldmap_SetRenderMode(renderModeList)
  renderMode:setRenderMode(renderModeList)
end
function FGlobal_Worldmap_ResetRenderMode()
  renderMode:reset()
end
function Panel_WorldMapNaviBtn()
  if ToClient_WorldMapNaviEmpty() == false and ToClient_WorldMapNaviIsLoopPath() == false then
    isCullingNaviBtn = false
    WorldMap_ShortcutButton_RePos()
    return
  end
end
function FGlobal_OpenWorldMapWithHouse()
  FGlobal_PushOpenWorldMap()
  local actorWrapper = interaction_getInteractable()
  ToClient_OpenWorldMapWithHouse(actorWrapper:get())
  isCloseWorldMap = false
end
function FGlobal_WorldMapWindowEscape()
  if false == _ContentsGroup_RenewUI_Worker then
    if Panel_WorkerTrade_Caravan:GetShow() and nil ~= Panel_WorkerTrade_Caravan then
      FGlobal_WorkerTradeCaravan_Hide()
      return
    end
  elseif true == _ContentsGroup_NewUI_WorkerAuction_All and nil ~= Panel_Window_WorkerAuction_All then
    HandleEventLUp_WorkerAuction_All_Close()
  elseif nil ~= Panel_Dialog_WorkerTrade_Renew then
    FGlobal_WorkerTrade_Close()
  end
  if ToClient_WorldMapIsShow() then
    local _panel_TradeMarket_EventInfo = Panel_TradeMarket_EventInfo
    if _ContentsGroup_isUsedNewTradeEventNotice then
      _panel_TradeMarket_EventInfo = Panel_TradeEventNotice_Renewal
    end
    local _panel_houseControl = Panel_HouseControl
    if true == _ContentsGroup_ForXBoxFinalCert then
      _panel_houseControl = Panel_Worldmap_HouseCraft
    end
    if _panel_houseControl:GetShow() == false and Panel_LargeCraft_WorkManager:GetShow() == false and Panel_RentHouse_WorkManager:GetShow() == false and Panel_Building_WorkManager:GetShow() == false and Panel_House_SellBuy_Condition:GetShow() == false and PaGlobalFunc_PanelDelivery_GetShow() == false and Panel_Trade_Market_Graph_Window:GetShow() == false and (_panel_TradeMarket_EventInfo:GetShow() == false or _panel_TradeMarket_EventInfo:IsUISubApp() == true) and Worldmap_Grand_GuildHouseControl:GetShow() == false and Worldmap_Grand_GuildCraft:GetShow() == false and Panel_NodeStable:GetShow() == false and Panel_Window_Warehouse:GetShow() == false and (Panel_CheckedQuest:GetShow() == false or Panel_CheckedQuest:IsUISubApp() == true) and Panel_Window_Delivery_InformationView:GetShow() == false and (PaGlobalFunc_ItemMarket_GetShow() == false or PaGlobalFunc_ItemMarket_IsUISubApp() == true) and (true == _ContentsGroup_RenewUI_Worker and false == Panel_Window_WorkerManager_Renew:GetShow() or false == _ContentsGroup_RenewUI_Worker and (Panel_WorkerManager:GetShow() == false or Panel_WorkerManager:IsUISubApp() == true)) and Panel_WorldMap_MovieGuide:GetShow() == false and (true == _ContentsGroup_RenewUI_Worker and false == Panel_Dialog_WorkerTrade_Renew:GetShow() or false == _ContentsGroup_RenewUI_Worker and Panel_WorkerTrade:GetShow() == false) and (true == _ContentsGroup_RenewUI_Worker or false == _ContentsGroup_RenewUI_Worker and Panel_WorkerTrade_Caravan:GetShow() == false) then
      ToClient_WorldMapPushEscape()
    end
    if false == _ContentsGroup_ForXBoxXR and false == _ContentsGroup_ForXBoxFinalCert then
      FGlobal_WarInfo_Open()
      FGlobal_NodeWarInfo_Open()
    end
    if not WorldMapPopupManager:pop() then
      FGlobal_PopCloseWorldMap()
    end
  end
  if 0 > WorldMapPopupManager._currentMode then
    FGlobal_WorldMapCloseSubPanel()
    FGlobal_HideAll_Tooltip_Work_Copy()
  end
end
function FromClient_ExitWorldMap()
  isCloseWorldMap = true
end
function FromClient_WorldMapFadeOut()
  isFadeOutWindow = true
  if true == _ContentsGroup_RenewUI_Chatting then
    PaGlobalFunc_ChattingInfo_Close()
  else
    ChatInput_Close()
  end
end
function FGlobal_IsFadeOutState()
  return isFadeOutWindow
end
function FGlobal_AskCloseWorldMap()
  return isCloseWorldMap
end
local IM = CppEnums.EProcessorInputMode
function FGlobal_WorldMapClose()
  isFadeOutWindow = false
  _PA_LOG("\236\160\149\236\167\128\237\152\156", "FGlobal_WorldMapClose-> clearInfo...")
  DragManager:clearInfo()
  WorldMapPopupManager:clear()
  renderMode:reset()
  Panel_WorldMap:ResetVertexAni()
  Panel_WorldMap:SetShow(false, false)
  ToClient_closeWorldMap()
  setShowLine(true)
  collectgarbage("collect")
  FGlobal_WorldMapCloseSubPanel()
  isCloseWorldMap = false
  if false == isFirstCall then
    isPrevShowPanel = false
    isPrevShowMainQuestPanel = false
  end
  isFirstCall = false
  if false == _ContentsGroup_RenewUI_Worker then
  end
  SetUIMode(Defines.UIMode.eUIMode_Default)
  CheckChattingInput()
  if ToClient_IsSavedUi() then
    ToClient_SaveUiInfo(false)
    ToClient_SetSavedUi(false)
  end
  if true == _ContentsGroup_RenewUI then
    PaGlobal_ConsoleWorldMapKeyGuide_SetShow(false)
  end
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
function FGlobal_WorldMapCloseSubPanel()
  if not _ContentsGroup_isUsedNewTradeEventNotice then
  end
  if true == _ContentsGroup_ForXBoxFinalCert then
    PaGlobalFunc_WorldMapSideBar_ResetFilter()
  else
    FGlobal_SetNodeFilter()
  end
  isCullingNaviBtn = true
end
local eCheckState = CppEnums.WorldMapCheckState
local eWorldmapState = CppEnums.WorldMapState
function FromClient_NewWorldMap_RenderStateChange(state)
  if true == _ContentsGroup_ForXBoxFinalCert then
    FromClient_WorldMapSideBar_RenderStateChange(state)
    return
  end
  if eWorldmapState.eWMS_EXPLORE_PLANT == state then
    local questShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Quest)
    local knowledgeShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Knowledge)
    local fishNChipShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_FishnChip)
    local nodeShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Node)
    local tradeShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Trade)
    local wayShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Way)
    local positionShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Postions)
    local wagonIsShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Wagon)
    ToClient_worldmapNodeMangerSetShow(nodeShow)
    ToClient_worldmapBuildingManagerSetShow(true)
    ToClient_worldmapQuestManagerSetShow(questShow)
    ToClient_worldmapGuideLineSetShow(wayShow)
    ToClient_worldmapDeliverySetShow(wagonIsShow)
    ToClient_worldmapTerritoryManagerSetShow(true)
    ToClient_worldmapActorManagerSetShow(positionShow)
    ToClient_worldmapPinSetShow(positionShow)
    ToClient_worldmapGuildHouseSetShow(true, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapTradeNpcSetShow(tradeShow, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapHouseManagerSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_SetGuildMode(FGlobal_isGuildWarMode())
  elseif eWorldmapState.eWMS_REGION == state then
    ToClient_worldmapNodeMangerSetShow(false)
    ToClient_worldmapBuildingManagerSetShow(false)
    ToClient_worldmapQuestManagerSetShow(false)
    ToClient_worldmapGuideLineSetShow(false)
    ToClient_worldmapDeliverySetShow(false)
    ToClient_worldmapActorManagerSetShow(false)
    ToClient_worldmapPinSetShow(false)
    ToClient_worldmapTradeNpcSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapHouseManagerSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, CppEnums.WaypointKeyUndefined)
  elseif eWorldmapState.eWMS_LOCATION_INFO_WATER == state then
    ToClient_worldmapNodeMangerSetShow(false)
    ToClient_worldmapBuildingManagerSetShow(false)
    ToClient_worldmapQuestManagerSetShow(false)
    ToClient_worldmapGuideLineSetShow(false)
    ToClient_worldmapDeliverySetShow(false)
    ToClient_worldmapActorManagerSetShow(false)
    ToClient_worldmapPinSetShow(false)
    ToClient_worldmapTradeNpcSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapHouseManagerSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, CppEnums.WaypointKeyUndefined)
  elseif eWorldmapState.eWMS_LOCATION_INFO_CELCIUS == state then
    ToClient_worldmapNodeMangerSetShow(false)
    ToClient_worldmapBuildingManagerSetShow(false)
    ToClient_worldmapQuestManagerSetShow(false)
    ToClient_worldmapGuideLineSetShow(false)
    ToClient_worldmapDeliverySetShow(false)
    ToClient_worldmapActorManagerSetShow(false)
    ToClient_worldmapPinSetShow(false)
    ToClient_worldmapTradeNpcSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapHouseManagerSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, CppEnums.WaypointKeyUndefined)
  elseif eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY == state then
    ToClient_worldmapNodeMangerSetShow(false)
    ToClient_worldmapBuildingManagerSetShow(false)
    ToClient_worldmapQuestManagerSetShow(false)
    ToClient_worldmapGuideLineSetShow(false)
    ToClient_worldmapDeliverySetShow(false)
    ToClient_worldmapActorManagerSetShow(false)
    ToClient_worldmapPinSetShow(false)
    ToClient_worldmapTradeNpcSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapHouseManagerSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, CppEnums.WaypointKeyUndefined)
  end
end
local _townModeWaypointKey
function FromClient_SetTownMode(waypointKey)
  _townModeWaypointKey = waypointKey
  local explorationNodeInClient = ToClient_getExploratioNodeInClientByWaypointKey(waypointKey)
  if nil ~= explorationNodeInClient then
    UpdateWorldMapNode(explorationNodeInClient)
  end
  FGlobal_WarInfo_Close()
  FGlobal_NodeWarInfo_Close()
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
    Instance_WorldMap_Main:SetShow(false)
    FGlobal_WorldmapGrand_Bottom_MenuSet(waypointKey)
    FGlobal_nodeOwnerInfo_SetPosition()
    FGlobal_GrandWorldMap_SearchToWorldMapMode()
  end
  ToClient_SetGuildMode(false)
  FGlobal_LoadWorldMapTownSideWindow(waypointKey)
  Panel_NodeSiegeTooltip:SetShow(false)
  PaGlobal_TutorialManager:handleSetTownMode(waypointKey)
end
function FromClient_resetTownMode()
  _townModeWaypointKey = nil
  ToClient_worldmapHouseManagerSetShow(false, CppEnums.WaypointKeyUndefined)
  ToClient_worldmapGuildHouseSetShow(true, CppEnums.WaypointKeyUndefined)
  ToClient_worldmapTerritoryManagerSetShow(true)
  if true == _ContentsGroup_ForXBoxFinalCert then
    PaGlobalFunc_WorldMapSideBar_Open()
    if Panel_NodeStable:GetShow() then
      StableClose_FromWorldMap()
    end
    ToClient_SetGuildMode(PaGlobalFunc_WorldMapSideBar_IsGuildWarMode())
    PaGlobalFunc_WorldMapSideBar_EraseArrow()
    FGlobal_FilterEffectClear()
  else
    FGlobal_WorldMapStateMaintain()
    Instance_WorldMap_Main:SetShow(true)
    FGlobal_WorldmapGrand_Bottom_MenuSet()
    if Panel_NodeStable:GetShow() then
      StableClose_FromWorldMap()
    end
    FGlobal_nodeOwnerInfo_Close()
    ToClient_SetGuildMode(FGlobal_isGuildWarMode())
    WorldMapArrowEffectEraseClear()
    FGlobal_FilterEffectClear()
    FGlobal_GrandWorldMap_SearchToWorldMapMode()
    FGlobal_Hide_Tooltip_Work(nil, true)
  end
end
function FGlobal_OpenNodeStable()
  _PA_LOG("\235\176\149\235\178\148\236\164\128", "FGlobal_OpenNodeStable")
  if nil == _townModeWaypointKey then
    return
  end
  local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint(_townModeWaypointKey)
  if nil ~= regionInfoWrapper and regionInfoWrapper:get():hasStableNpc() then
    StableOpen_FromWorldMap(_townModeWaypointKey)
  end
end
function AltKeyGuide_ReSize()
  local altKeyGuideTextX = altKeyGuide:GetTextSizeX() + 10
  local altKeyGuideTextY = altKeyGuide:GetTextSizeY() + 10
  altKeyGuide:SetSize(altKeyGuideTextX, altKeyGuideTextY)
end
function FromClient_HideAutoCompletedNaviBtn(isShow)
  HideAutoCompletedNaviBtn = isShow
end
registerEvent("FromClient_RenderStateChange", "FromClient_NewWorldMap_RenderStateChange")
if false == _ContentsGroup_RenewUI_WorldMap then
  registerEvent("FromClient_WorldMapOpen", "FromClient_WorldMapOpen")
  registerEvent("FromClient_LClickedWorldMapNode", "FromClient_LClickedWorldMapNode")
  registerEvent("FromClient_SetTownMode", "FromClient_SetTownMode")
  registerEvent("FromClient_resetTownMode", "FromClient_resetTownMode")
  registerEvent("FromClient_ExitWorldMap", "FromClient_ExitWorldMap")
  registerEvent("FromClient_ImmediatelyCloseWorldMap", "FGlobal_WorldMapClose")
  registerEvent("FromClient_WorldMapFadeOut", "FromClient_WorldMapFadeOut")
  registerEvent("FromClient_WorldMapFadeOutHideUI", "FromClient_WorldMapFadeOutHideUI")
  registerEvent("FromClient_WorldMapNodeUpgrade", "UpdateWorldMapNode")
  registerEvent("FromClient_FillNodeInfo", "FGlobal_OpenOtherPanelWithNodeMenu")
end
registerEvent("FromClient_NodeIsNextSiege", "FromClient_NodeIsNextSiege")
registerEvent("FromClient_WorldMapNodeFindNearNode", "FromClient_WorldMapNodeFindNearNode")
registerEvent("FromClient_WorldMapNodeFindTargetNode", "FromClient_WorldMapNodeFindTargetNode")
registerEvent("FromClient_RClickWorldmapPanel", "FromClient_RClickWorldmapPanel")
registerEvent("FromClient_DeleteNaviGuidOnTheWorldmapPanel", "FromClient_DeleteNaviGuidOnTheWorldmapPanel")
registerEvent("FromClient_HideAutoCompletedNaviBtn", "FromClient_HideAutoCompletedNaviBtn")
registerEvent("FromClient_DeliveryRequestAck", "DeliveryRequest_UpdateRequestSlotData")
registerEvent("EventDeliveryInfoUpdate", "DeliveryInformation_UpdateSlotData")
function FromClient_WorldMap_luaLoadComplete()
  FGlobal_WorldMapClose()
end
AltKeyGuide_ReSize()
renderMode:setClosefunctor(renderMode, FGlobal_CloseWorldmapForLuaKeyHandling)

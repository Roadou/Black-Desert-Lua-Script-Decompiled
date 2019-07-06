local UI_color = Defines.Color
local ServantStable_Btn = UI.getChildControl(Panel_WorldMap, "BottomMenu_ServantStable")
local WareHouse_Btn = UI.getChildControl(Panel_WorldMap, "BottomMenu_WareHouse")
local Quest_Btn = UI.getChildControl(Panel_WorldMap, "BottomMenu_Quest")
local Transport_Btn = UI.getChildControl(Panel_WorldMap, "BottomMenu_Transport")
local transportAlert = UI.getChildControl(Panel_WorldMap, "Static_TransportAlert")
local ItemMarket_Btn = UI.getChildControl(Panel_WorldMap, "BottomMenu_ItemMarket")
local MarketPlace_Btn = UI.getChildControl(Panel_WorldMap, "BottomMenu_MarketPlace")
local WorkerList_Btn = UI.getChildControl(Panel_WorldMap, "BottomMenu_WorkerList")
local HelpMenu_Btn = UI.getChildControl(Panel_WorldMap, "BottomMenu_HelpMovie")
local Exit_Btn = UI.getChildControl(Panel_WorldMap, "BottomMenu_Exit")
local WorkerTrade_Btn = UI.getChildControl(Panel_WorldMap, "BottomMenu_WorkerTrade")
local StableMarket_Btn = UI.getChildControl(Panel_WorldMap, "BottomMenu_StableMarket")
local NpcFind = UI.getChildControl(Panel_WorldMap, "BottomMenu_NpcFind")
local btn_inMyPosition = UI.getChildControl(Panel_WorldMap, "BottomMenu_InMyPosition")
local isWorkerTradeOpen = ToClient_IsContentsGroupOpen("209")
local base_carriageMoveCount = ToClient_MaxCarriageCount()
local gab_carriageText = 35
local txt_NationSiegeCarriageCount = UI.getChildControl(Panel_WorldMap, "StaticText_RemainCarriage")
local NationSiegeCarriage_A = UI.getChildControl(Panel_WorldMap, "Button_NationSiegeCarriage_A")
local NationSiegeCarriage_B = UI.getChildControl(Panel_WorldMap, "Button_NationSiegeCarriage_B")
local NationSiegeCarriage_C = UI.getChildControl(Panel_WorldMap, "Button_NationSiegeCarriage_C")
local txt_pingTooltip = UI.getChildControl(Panel_WorldMap, "StaticText_KeyGuide")
local currentNodeKey
local popupType = {
  stable = 0,
  wareHouse = 1,
  quest = 2,
  transport = 3,
  itemMarket = 4,
  workerList = 5,
  helpMovie = 6,
  workerTrade = 7,
  workerTradeCaravan = 8,
  stableMarket = 9,
  npcNavi = 10,
  marketPlace = 11,
  workerList_All = 12
}
local popupTypeCount = 13
local popupPanelList = {}
Panel_WorldMap:SetShow(false, false)
local function worldMap_Init()
  Exit_Btn:SetSize(44, 44)
  HelpMenu_Btn:SetSize(44, 44)
  WorkerList_Btn:SetSize(44, 44)
  ItemMarket_Btn:SetSize(44, 44)
  MarketPlace_Btn:SetSize(44, 44)
  Transport_Btn:SetSize(44, 44)
  Quest_Btn:SetSize(44, 44)
  WareHouse_Btn:SetSize(44, 44)
  ServantStable_Btn:SetSize(44, 44)
  WorkerTrade_Btn:SetSize(44, 44)
  StableMarket_Btn:SetSize(44, 44)
  NpcFind:SetSize(44, 44)
  btn_inMyPosition:SetSize(44, 44)
  transportAlert:SetShow(false)
  Exit_Btn:SetSpanSize(5, 5)
  HelpMenu_Btn:SetSpanSize(Exit_Btn:GetSpanSize().x + Exit_Btn:GetSizeX() + 3, 5)
  if true == ToClient_IsGrowStepOpen(__eGrowStep_worker) and true == _ContentsGroup_GrowStep or false == _ContentsGroup_GrowStep then
    WorkerList_Btn:SetSpanSize(HelpMenu_Btn:GetSpanSize().x + HelpMenu_Btn:GetSizeX() + 3, 5)
  else
    WorkerList_Btn:SetSpanSize(Exit_Btn:GetSpanSize().x + Exit_Btn:GetSizeX() + 3, 5)
  end
  MarketPlace_Btn:SetSpanSize(WorkerList_Btn:GetSpanSize().x + WorkerList_Btn:GetSizeX() + 3, 5)
  if true == _ContentsGroup_RenewUI_ItemMarketPlace then
    ItemMarket_Btn:SetSpanSize(MarketPlace_Btn:GetSpanSize().x + MarketPlace_Btn:GetSizeX() + 3, 5)
  else
    ItemMarket_Btn:SetSpanSize(WorkerList_Btn:GetSpanSize().x + WorkerList_Btn:GetSizeX() + 3, 5)
  end
  if not _ContentsGroup_RenewUI_ItemMarketPlace_Only then
    Transport_Btn:SetSpanSize(ItemMarket_Btn:GetSpanSize().x + ItemMarket_Btn:GetSizeX() + 3, 5)
    transportAlert:SetSpanSize(ItemMarket_Btn:GetSpanSize().x + ItemMarket_Btn:GetSizeX(), 33)
  else
    Transport_Btn:SetSpanSize(MarketPlace_Btn:GetSpanSize().x + MarketPlace_Btn:GetSizeX() + 3, 5)
    transportAlert:SetSpanSize(MarketPlace_Btn:GetSpanSize().x + MarketPlace_Btn:GetSizeX(), 33)
  end
  Quest_Btn:SetSpanSize(Transport_Btn:GetSpanSize().x + Transport_Btn:GetSizeX() + 3, 5)
  WareHouse_Btn:SetSpanSize(Quest_Btn:GetSpanSize().x + Quest_Btn:GetSizeX() + 3, 5)
  ServantStable_Btn:SetSpanSize(WareHouse_Btn:GetSpanSize().x + WareHouse_Btn:GetSizeX() + 3, 5)
  StableMarket_Btn:SetSpanSize(ServantStable_Btn:GetSpanSize().x + ServantStable_Btn:GetSizeX() + 3, 5)
  NpcFind:SetSpanSize(StableMarket_Btn:GetSpanSize().x + StableMarket_Btn:GetSizeX() + 3, 5)
  btn_inMyPosition:SetSpanSize(NpcFind:GetSpanSize().x + StableMarket_Btn:GetSizeX() + 3, 5)
  WorkerTrade_Btn:SetSpanSize(btn_inMyPosition:GetSpanSize().x + StableMarket_Btn:GetSizeX() + 3, 5)
  local isShowNationCarriage = false
  if true == _ContentsGroup_NationSiege and true == ToClient_isBeingNationSiege() and nil ~= getSelfPlayer() then
    local isGuildMaster = getSelfPlayer():get():isGuildMaster()
    local isCastleGuild = checkIsHasCastle()
    if true == isGuildMaster and true == isCastleGuild then
      isShowNationCarriage = true
    end
  end
  if true == isShowNationCarriage then
    txt_NationSiegeCarriageCount:SetShow(true)
    NationSiegeCarriage_A:SetShow(true)
    NationSiegeCarriage_B:SetShow(true)
    NationSiegeCarriage_C:SetShow(true)
    local offsetX = getScreenSizeX()
    NationSiegeCarriage_A:SetPosX(offsetX - 200 + NationSiegeCarriage_A:GetSizeX() * 1 + 5)
    NationSiegeCarriage_B:SetPosX(NationSiegeCarriage_A:GetPosX() + NationSiegeCarriage_A:GetSizeX() + 5)
    NationSiegeCarriage_C:SetPosX(NationSiegeCarriage_B:GetPosX() + NationSiegeCarriage_B:GetSizeX() + 5)
    local remainCount = base_carriageMoveCount - ToClient_CurrentCarriageMoveCount()
    txt_NationSiegeCarriageCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_CARRIAGE_COUNT_TEXT_SET", "remainCount", remainCount))
    txt_NationSiegeCarriageCount:SetPosX(NationSiegeCarriage_A:GetPosX() - txt_NationSiegeCarriageCount:GetTextSizeX() - gab_carriageText)
    txt_pingTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_GRAND_PING_TOOLTIP_NATIONSEIGE_ING"))
    txt_pingTooltip:SetSize(txt_pingTooltip:GetTextSizeX() + 20, txt_pingTooltip:GetTextSizeY() + 20)
  else
    txt_NationSiegeCarriageCount:SetShow(false)
    NationSiegeCarriage_A:SetShow(false)
    NationSiegeCarriage_B:SetShow(false)
    NationSiegeCarriage_C:SetShow(false)
    txt_pingTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_GRAND_PING_TOOLTIP_BASE"))
    txt_pingTooltip:SetSize(txt_pingTooltip:GetTextSizeX() + 20, txt_pingTooltip:GetTextSizeY() + 20)
  end
  NationSiegeCarriage_A:addInputEvent("Mouse_LUp", "HandleClick_NationSiegeCarriage(1)")
  NationSiegeCarriage_B:addInputEvent("Mouse_LUp", "HandleClick_NationSiegeCarriage(2)")
  NationSiegeCarriage_C:addInputEvent("Mouse_LUp", "HandleClick_NationSiegeCarriage(3)")
  NationSiegeCarriage_A:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_NationSiegeCarriage_Tooltip(1, true)")
  NationSiegeCarriage_A:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_NationSiegeCarriage_Tooltip(1, false)")
  NationSiegeCarriage_B:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_NationSiegeCarriage_Tooltip(2, true)")
  NationSiegeCarriage_B:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_NationSiegeCarriage_Tooltip(2, false)")
  NationSiegeCarriage_C:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_NationSiegeCarriage_Tooltip(3, true)")
  NationSiegeCarriage_C:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_NationSiegeCarriage_Tooltip(3, false)")
  ServantStable_Btn:addInputEvent("Mouse_LUp", "BtnEvent_ServantStable()")
  WareHouse_Btn:addInputEvent("Mouse_LUp", "BtnEvent_WareHouse()")
  Quest_Btn:addInputEvent("Mouse_LUp", "BtnEvent_Quest()")
  Transport_Btn:addInputEvent("Mouse_LUp", "BtnEvent_Transport()")
  ItemMarket_Btn:addInputEvent("Mouse_LUp", "BtnEvent_ItemMarket()")
  MarketPlace_Btn:addInputEvent("Mouse_LUp", "BtnEvent_MarketPlace()")
  WorkerList_Btn:addInputEvent("Mouse_LUp", "BtnEvent_WorkerList()")
  HelpMenu_Btn:addInputEvent("Mouse_LUp", "BtnEvent_HelpMovie()")
  Exit_Btn:addInputEvent("Mouse_LUp", "BtnEvent_Exit()")
  StableMarket_Btn:addInputEvent("Mouse_LUp", "BtnEvent_StableMarket()")
  WorkerTrade_Btn:addInputEvent("Mouse_LUp", "BtnEvent_WorkerTrade()")
  NpcFind:addInputEvent("Mouse_LUp", "BtnEvent_NpcNavi()")
  btn_inMyPosition:addInputEvent("Mouse_LUp", "BtnEvent_InMyPosition()")
  ServantStable_Btn:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 0 .. " )")
  ServantStable_Btn:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 0 .. " )")
  WareHouse_Btn:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 1 .. " )")
  WareHouse_Btn:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 1 .. " )")
  Quest_Btn:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 2 .. " )")
  Quest_Btn:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 2 .. " )")
  Transport_Btn:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 3 .. " )")
  Transport_Btn:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 3 .. " )")
  ItemMarket_Btn:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 4 .. " )")
  ItemMarket_Btn:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 4 .. " )")
  WorkerList_Btn:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 5 .. " )")
  WorkerList_Btn:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 5 .. " )")
  HelpMenu_Btn:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 6 .. " )")
  HelpMenu_Btn:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 6 .. " )")
  Exit_Btn:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 7 .. " )")
  Exit_Btn:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 7 .. " )")
  WorkerTrade_Btn:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 8 .. " )")
  WorkerTrade_Btn:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 8 .. " )")
  StableMarket_Btn:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 9 .. " )")
  StableMarket_Btn:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 9 .. " )")
  NpcFind:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 10 .. " )")
  NpcFind:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 10 .. " )")
  btn_inMyPosition:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 12 .. " )")
  btn_inMyPosition:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 12 .. " )")
  MarketPlace_Btn:addInputEvent("Mouse_On", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 11 .. " )")
  MarketPlace_Btn:addInputEvent("Mouse_Out", "HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 11 .. " )")
end
function GrandWorldMap_CheckPopup(openPanel)
  for idx = 0, popupTypeCount - 1 do
    if openPanel ~= idx and nil ~= popupPanelList[idx].panelname and popupPanelList[idx].panelname:GetShow() then
      popupPanelList[idx].closeFunc()
    end
  end
  PaGlobal_TutorialManager:handleGrandWorldMap_CheckPopup(openPanel, popupPanelList[openPanel].panelname)
end
function BtnEvent_ServantStable()
  if not Panel_NodeStable:GetShow() then
    if nil ~= currentNodeKey then
      GrandWorldMap_CheckPopup(popupType.stable)
      StableOpen_FromWorldMap(currentNodeKey)
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_GRAND_WRONG_STABLE"))
      return
    end
  else
    StableClose_FromWorldMap()
  end
end
function BtnEvent_StableMarket()
  if true == Panel_Window_StableMarket:GetShow() then
    StableMarket_Close()
  else
    GrandWorldMap_CheckPopup(popupType.stableMarket)
    StableMarket_Open()
  end
end
function BtnEvent_WorkerTrade()
  if not ToClient_IsActiveWorkerTrade() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_WORKERTRADEALERT"))
    return
  end
  if Panel_WorkerTrade:GetShow() then
    WorkerTrade_Close()
  else
    GrandWorldMap_CheckPopup(popupType.workerTrade)
    WorldMapPopupManager:increaseLayer(true)
    WorldMapPopupManager:push(Panel_WorkerTrade, true)
    FGlobal_WorkerTrade_Update()
  end
end
function BtnEvent_NpcNavi()
  if Panel_NpcNavi:GetShow() then
    NpcNavi_ShowToggle()
  else
    GrandWorldMap_CheckPopup(popupType.npcNavi)
    NpcNavi_ShowToggle()
    WorldMapPopupManager:increaseLayer(true)
    WorldMapPopupManager:push(Panel_NpcNavi, true)
  end
end
function BtnEvent_InMyPosition()
  if true == btn_inMyPosition:IsIgnore() then
    return
  end
  ToClient_moveCameraSelfPlayerForWorldmap()
end
function BtnEvent_WareHouse()
  if Panel_Window_Warehouse:GetShow() then
    Warehouse_Close()
  elseif nil ~= currentNodeKey then
    GrandWorldMap_CheckPopup(popupType.wareHouse)
    Warehouse_OpenPanelFromWorldmap(currentNodeKey, CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap)
  end
end
function BtnEvent_Quest()
  if Panel_CheckedQuest:GetShow() then
    FGlobal_QuestWidget_Close()
  else
    GrandWorldMap_CheckPopup(popupType.quest)
    FGlobal_QuestWidget_Open()
  end
end
function BtnEvent_Transport()
  if Panel_Window_Delivery_InformationView:GetShow() then
    DeliveryInformationView_Close()
  else
    GrandWorldMap_CheckPopup(popupType.transport)
    DeliveryInformationView_Open()
  end
end
function BtnEvent_ItemMarket()
  if Panel_Window_ItemMarket:IsShow() then
    FGolbal_ItemMarketNew_Close()
  else
    GrandWorldMap_CheckPopup(popupType.itemMarket)
    FGlobal_ItemMarket_Open_ForWorldMap(1)
  end
end
function BtnEvent_MarketPlace()
  if false == _ContentsGroup_RenewUI_ItemMarketPlace then
    return
  end
  if true == PaGlobalFunc_MarketPlace_GetShow() then
    PaGlobalFunc_MarketPlace_Close()
  else
    GrandWorldMap_CheckPopup(popupType.marketPlace)
    PaGlobalFunc_MarketPlace_OpenForWorldMap(1)
  end
end
function BtnEvent_WorkerList()
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    if nil ~= Panel_Window_WorkerManager_All and Panel_Window_WorkerManager_All:GetShow() then
      PaGlobalFunc_WorkerManager_All_Close()
    else
      GrandWorldMap_CheckPopup(popupType.workerList_All)
      PaGlobalFunc_WorkerManager_All_OpenWorldMap()
    end
  elseif nil ~= Panel_WorkerManager and Panel_WorkerManager:GetShow() then
    workerManager_Close()
  else
    GrandWorldMap_CheckPopup(popupType.workerList)
    if nil ~= currentNodeKey then
      FGlobal_workerManager_UpdateNode(ToClient_convertWaypointKeyToPlantKey(currentNodeKey))
    else
      FGlobal_workerManager_OpenWorldMap()
    end
  end
end
function BtnEvent_HelpMovie()
  PaGlobal_MovieGuide_Web:Open()
end
function BtnEvent_Exit()
  FGlobal_CloseWorldmapForLuaKeyHandling()
end
function HandleClick_NationSiegeCarriage(point)
  local remainCount = base_carriageMoveCount - ToClient_CurrentCarriageMoveCount()
  local isMove = false
  if remainCount < 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_CARRIAGE_COUNT_ZERO"))
  end
  if 1 == point then
    ToClient_MoveSupplyCarriage(__eNationSiegeCarriage_APoint)
    isMove = true
  elseif 2 == point then
    ToClient_MoveSupplyCarriage(__eNationSiegeCarriage_BPoint)
    isMove = true
  elseif 3 == point then
    ToClient_MoveSupplyCarriage(__eNationSiegeCarriage_CPoint)
    isMove = true
  end
  if true == isMove then
    txt_NationSiegeCarriageCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_CARRIAGE_COUNT_TEXT_SET", "remainCount", remainCount - 1))
  end
end
function HandleOnOut_WorldmapGrand_NationSiegeCarriage_Tooltip(point, isShow)
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_GRAND_NATIONSIEGECARRIAGE_TOOLTIP_TITLE")
  if 1 == point then
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_GRAND_NATIONSIEGECARRIAGE_TOOLTIP_POINT_A")
    control = NationSiegeCarriage_A
  elseif 2 == point then
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_GRAND_NATIONSIEGECARRIAGE_TOOLTIP_POINT_B")
    control = NationSiegeCarriage_B
  elseif 3 == point then
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_GRAND_NATIONSIEGECARRIAGE_TOOLTIP_POINT_C")
    control = NationSiegeCarriage_C
  end
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function checkIsHasCastle()
  local myGuildWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildWrapper then
    return false
  end
  local myGuildNo = myGuildWrapper:getGuildNo_s64()
  local calpheonWrapper = ToClient_getNationSiegeTeamWrapper(2)
  if nil ~= calpheonWrapper then
    local calpheonGuildCount = calpheonWrapper:getGuildCount()
    for ii = 1, calpheonGuildCount do
      local guildNo = calpheonWrapper:getGuildNoRawByIndex(ii - 1)
      if true == calpheonWrapper:isKingByIndex(ii - 1) and myGuildNo == guildNo then
        return true
      end
    end
  end
  local valenciaWrapper = ToClient_getNationSiegeTeamWrapper(4)
  if nil ~= valenciaWrapper then
    local valenciaGuildCount = valenciaWrapper:getGuildCount()
    for ii = 1, valenciaGuildCount do
      local guildNo = valenciaWrapper:getGuildNoRawByIndex(ii - 1)
      if true == valenciaWrapper:isKingByIndex(ii - 1) and myGuildNo == guildNo then
        return true
      end
    end
  end
  return false
end
local function makePopupPanelList()
  popupPanelList = {
    [popupType.stable] = {panelname = Panel_NodeStable, closeFunc = StableClose_FromWorldMap},
    [popupType.wareHouse] = {panelname = Panel_Window_Warehouse, closeFunc = Warehouse_Close},
    [popupType.quest] = {panelname = Panel_CheckedQuest, closeFunc = FGlobal_QuestWidget_Close},
    [popupType.transport] = {panelname = Panel_Window_Delivery_InformationView, closeFunc = DeliveryInformationView_Close},
    [popupType.itemMarket] = {panelname = Panel_Window_ItemMarket, closeFunc = FGolbal_ItemMarketNew_Close},
    [popupType.workerList] = {panelname = Panel_Window_WorkerManager_Renew, closeFunc = PaGlobalFunc_WorkerManager_Close},
    [popupType.helpMovie] = {panelname = Panel_WorldMap_MovieGuide, closeFunc = Panel_Worldmap_MovieGuide_Close},
    [popupType.workerTrade] = {panelname = Panel_WorkerTrade, closeFunc = WorkerTrade_Close},
    [popupType.workerTradeCaravan] = {panelname = Panel_WorkerTrade_Caravan, closeFunc = FGlobal_WorkerTradeCaravan_Hide},
    [popupType.stableMarket] = {panelname = Panel_Window_StableMarket, closeFunc = StableMarket_Close},
    [popupType.npcNavi] = {panelname = Panel_NpcNavi, closeFunc = NpcNavi_ShowToggle},
    [popupType.marketPlace] = {panelname = Panel_Window_MarketPlace_Main, closeFunc = PaGlobalFunc_MarketPlace_Close},
    [popupType.workerList_All] = {panelname = Panel_Window_WorkerManager_All, closeFunc = PaGlobalFunc_WorkerManager_All_Close}
  }
end
function FGlobal_WorldMapOpenForMenu()
  local isGrowStep = true
  if true == _ContentsGroup_GrowStep then
    isGrowStep = ToClient_IsGrowStepOpen(__eGrowStep_worker)
  else
    isGrowStep = true
  end
  ServantStable_Btn:SetShow(true)
  WareHouse_Btn:SetShow(true)
  Quest_Btn:SetShow(true)
  Transport_Btn:SetShow(true)
  ItemMarket_Btn:SetShow(not _ContentsGroup_RenewUI_ItemMarketPlace_Only)
  WorkerList_Btn:SetShow(isGrowStep)
  HelpMenu_Btn:SetShow(true)
  Exit_Btn:SetShow(true)
  WorkerTrade_Btn:SetShow(isWorkerTradeOpen)
  StableMarket_Btn:SetShow(true)
  NpcFind:SetShow(true)
  btn_inMyPosition:SetShow(true)
  makePopupPanelList()
  Panel_WorldMap:SetShow(true, false)
  Panel_Worldmap_MovieGuide_Init()
  if isGameTypeKR2() or isGameTypeGT() then
    HelpMenu_Btn:SetShow(false)
  end
  MarketPlace_Btn:SetShow(_ContentsGroup_RenewUI_ItemMarketPlace, false)
end
function WorldmapGrand_setAlpha(boolValue)
  local returnValue = ""
  if true == boolValue then
    returnValue = 1
  else
    returnValue = 0.7
  end
  return returnValue
end
function HandleOnOut_WorldmapGrand_MenuButtonTooltip(isShow, buttonType)
  if isShow then
    local control
    local name = ""
    local desc
    if 0 == buttonType then
      control = ServantStable_Btn
      name = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_MENUBUTTONTOOLTIP_STABLE")
    elseif 1 == buttonType then
      control = WareHouse_Btn
      name = PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_WAREHOUSE")
    elseif 2 == buttonType then
      control = Quest_Btn
      name = PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST")
    elseif 3 == buttonType then
      control = Transport_Btn
      name = PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_DELIVERY")
    elseif 4 == buttonType then
      control = ItemMarket_Btn
      name = PAGetString(Defines.StringSheet_GAME, "GAME_ITEM_MARKET_NAME")
    elseif 5 == buttonType then
      control = WorkerList_Btn
      name = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_WORKERTITLE")
    elseif 6 == buttonType then
      control = HelpMenu_Btn
      name = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_MENUBUTTONTOOLTIP_HELPMOVIE")
    elseif 7 == buttonType then
      control = Exit_Btn
      name = PAGetString(Defines.StringSheet_RESOURCE, "UICONTROL_BTN_GAMEEXIT")
    elseif 8 == buttonType then
      control = WorkerTrade_Btn
      name = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_HELPWORKERTRADE")
    elseif 9 == buttonType then
      control = StableMarket_Btn
      name = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_FUNCTION_BTN_MARKET")
    elseif 10 == buttonType then
      control = StableMarket_Btn
      name = PAGetString(Defines.StringSheet_GAME, "NPCNAVIGATION_NOTDRAGABLE")
    elseif 11 == buttonType then
      control = MarketPlace_Btn
      name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_TITLE")
    elseif 12 == buttonType then
      control = btn_inMyPosition
      name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORLDMAP_INMYPOSITION")
      desc = PAGetString(Defines.StringSheet_GAME, "PANEL_WORLDMAP_INMYPOSITION_DESC")
    end
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function FGlobal_WorldmapGrand_Bottom_MenuSet(waypointKey)
  if nil ~= waypointKey then
    currentNodeKey = waypointKey
    local isStableOpen = false
    local isWareHouseOpen = false
    local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint(waypointKey)
    if nil ~= regionInfoWrapper then
      isStableOpen = regionInfoWrapper:get():hasStableNpc()
      isWareHouseOpen = regionInfoWrapper:get():hasWareHouseNpc()
    end
    ServantStable_Btn:SetAlpha(WorldmapGrand_setAlpha(isStableOpen))
    ServantStable_Btn:SetIgnore(not isStableOpen)
    WareHouse_Btn:SetAlpha(WorldmapGrand_setAlpha(isWareHouseOpen))
    WareHouse_Btn:SetIgnore(not isWareHouseOpen)
    WorkerTrade_Btn:SetAlpha(WorldmapGrand_setAlpha(not isWorkerTradeOpen))
    WorkerTrade_Btn:SetIgnore(isWorkerTradeOpen)
    btn_inMyPosition:SetAlpha(WorldmapGrand_setAlpha(false))
    btn_inMyPosition:SetIgnore(true)
  else
    currentNodeKey = nil
    ServantStable_Btn:SetAlpha(WorldmapGrand_setAlpha(false))
    ServantStable_Btn:SetIgnore(true)
    WareHouse_Btn:SetAlpha(WorldmapGrand_setAlpha(false))
    WareHouse_Btn:SetIgnore(true)
    WorkerTrade_Btn:SetAlpha(WorldmapGrand_setAlpha(isWorkerTradeOpen))
    WorkerTrade_Btn:SetIgnore(not isWorkerTradeOpen)
    btn_inMyPosition:SetAlpha(WorldmapGrand_setAlpha(true))
    btn_inMyPosition:SetIgnore(false)
  end
end
function worldmapGrand_Base_OnScreenResize()
  local offsetX = getScreenSizeX()
  local offsetY = getScreenSizeY()
  local remainCount = base_carriageMoveCount - ToClient_CurrentCarriageMoveCount()
  Panel_WorldMap:SetSize(offsetX, offsetY)
  ServantStable_Btn:ComputePos()
  WareHouse_Btn:ComputePos()
  Quest_Btn:ComputePos()
  Transport_Btn:ComputePos()
  ItemMarket_Btn:ComputePos()
  MarketPlace_Btn:ComputePos()
  WorkerList_Btn:ComputePos()
  HelpMenu_Btn:ComputePos()
  Exit_Btn:ComputePos()
  WorkerTrade_Btn:ComputePos()
  StableMarket_Btn:ComputePos()
  NpcFind:ComputePos()
  btn_inMyPosition:ComputePos()
  transportAlert:ComputePos()
  NationSiegeCarriage_A:ComputePos()
  NationSiegeCarriage_B:ComputePos()
  NationSiegeCarriage_C:ComputePos()
  txt_NationSiegeCarriageCount:ComputePos()
  NationSiegeCarriage_A:SetPosX(offsetX - 200 + NationSiegeCarriage_A:GetSizeX() * 1 + 5)
  NationSiegeCarriage_B:SetPosX(NationSiegeCarriage_A:GetPosX() + NationSiegeCarriage_A:GetSizeX() + 5)
  NationSiegeCarriage_C:SetPosX(NationSiegeCarriage_B:GetPosX() + NationSiegeCarriage_B:GetSizeX() + 5)
  txt_NationSiegeCarriageCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_CARRIAGE_COUNT_TEXT_SET", "remainCount", remainCount))
  txt_NationSiegeCarriageCount:SetPosX(NationSiegeCarriage_A:GetPosX() - txt_NationSiegeCarriageCount:GetTextSizeX() - gab_carriageText)
end
function FromClient_isCompletedTransport(isComplete)
  if nil == isComplete then
    return
  end
end
function PaGlobalFunc_Panel_WorldMap_Open()
  worldMap_Init()
end
worldMap_Init()
registerEvent("onScreenResize", "worldmapGrand_Base_OnScreenResize")
registerEvent("FromClient_isCompletedTransport", "FromClient_isCompletedTransport")

local UI_TYPE = CppEnums.PA_UI_CONTROL_TYPE
local ENT = CppEnums.ExplorationNodeType
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local viewWorldMapTradeNpcKey = -1
function FromClient_OnWorldMapTradeNpc(tradeNpcStatic)
  local uiHeadStatic = tradeNpcStatic:FromClient_getTradeListHead()
end
function FromClient_OutWorldMapTradeNpc(tradeNpcStatic)
  local uiHeadStatic = tradeNpcStatic:FromClient_getTradeListHead()
  uiHeadStatic:SetShow(false)
end
function FromClient_LClickWorldMapTradeNpc(tradeNpcStatic)
  local clientSpawnInRegionData = tradeNpcStatic:getClientSpawnInRegionData()
  if true == clientSpawnInRegionData:FromClient_isTerritorySupply() then
    WorldMapPopupManager:increaseLayer(false)
    refreshTradeSupplyList(clientSpawnInRegionData)
    WorldMapPopupManager:push(Panel_TradeNpcItemInfo, true)
  elseif clientSpawnInRegionData:FromClient_isTerritoryTrade() then
    return
  else
    local wp = npcShop_demandWpByRequestShop(clientSpawnInRegionData:get():getKeyRaw())
    viewWorldMapTradeNpcKey = clientSpawnInRegionData:get():getKeyRaw()
    local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "Lua_WorldMap_TradeList_Show_Title")
    local messageboxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "Lua_WorldMap_TradeList_Show_Question", "Usewp", wp)
    local messageboxData = {
      title = messageboxTitle,
      content = messageboxMemo,
      functionYes = ViewTradeShopGraphList,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
end
function FromClient_RClickWorldMapTradeNpc(tradeNpcStatic)
  local npcData = tradeNpcStatic:getClientSpawnInRegionData()
  local pos3D = npcData:getPosition()
  FromClient_RClickWorldmapPanel(pos3D, true, false)
end
function ViewTradeShopGraphList()
  ToClient_npcShop_requestShopItemListByWorldMap(viewWorldMapTradeNpcKey)
end
function FromClient_ResponseWorldMapTradeNpc(clientSpawnInRegionData, tradeNpcStatic)
  if false == ToClient_WorldMapIsShow() then
    return
  end
  WorldMapPopupManager:increaseLayer(false)
  WorldMapPopupManager:push(Panel_Trade_Market_Graph_Window, true)
  global_CommerceGraphDataInit(true)
end
registerEvent("FromClient_OnWorldMapTradeNpc", "FromClient_OnWorldMapTradeNpc")
registerEvent("FromClient_OutWorldMapTradeNpc", "FromClient_OutWorldMapTradeNpc")
registerEvent("FromClient_LClickWorldMapTradeNpc", "FromClient_LClickWorldMapTradeNpc")
registerEvent("FromClient_RClickWorldMapTradeNpc", "FromClient_RClickWorldMapTradeNpc")
registerEvent("FromClient_ResponseWorldMapTradeNpc", "FromClient_ResponseWorldMapTradeNpc")

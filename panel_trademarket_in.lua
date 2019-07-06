local _panel = Panel_TradeMarket_In
local TradeMarketIn = {
  _ui = {
    txt_Title = UI.getChildControl(_panel, "StaticText_Title"),
    btn_Sell = UI.getChildControl(_panel, "RadioButton_Sell"),
    btn_Buy = UI.getChildControl(_panel, "RadioButton_Buy"),
    txt_AlertText = UI.getChildControl(_panel, "StaticText_AlertText"),
    stc_BottomBg = UI.getChildControl(_panel, "Static_BottomBG")
  },
  _isTerritorySupply = nil
}
function TradeMarketIn:open()
  local talker = dialog_getTalker()
  local npcActorproxy = talker:get()
  local npcPosition = npcActorproxy:getPosition()
  local npcRegionInfo = getRegionInfoByPosition(npcPosition)
  local npcTradeNodeName = npcRegionInfo:getTradeExplorationNodeName()
  local npcTradeOriginRegion = npcRegionInfo:get():getTradeOriginRegion()
  local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
  local characterStaticStatus = characterStaticStatusWrapper:get()
  if false == checkSelfplayerNode(npcTradeOriginRegion._waypointKey, true) and false == characterStaticStatus:isFishSupplyMerchant() then
    self._ui.txt_AlertText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_WindowTradeMarket_NeedInvest", "npc_tradenodename", npcTradeNodeName))
    self._ui.btn_Sell:SetShow(false)
    self._ui.btn_Buy:SetShow(false)
    self._ui.txt_AConsoleUI:SetShow(false)
    self._ui.txt_AlertText:SetShow(true)
    self._isTerritorySupply = false
  else
    if characterStaticStatus:isTerritorySupplyMerchant() then
      self._ui.btn_Sell:SetSpanSize(0, 0)
      self._ui.btn_Sell:SetShow(true)
      self._ui.btn_Buy:SetShow(false)
      self._isTerritorySupply = true
    elseif characterStaticStatus:isSupplyMerchant() or characterStaticStatus:isFishSupplyMerchant() or characterStaticStatus:isGuildSupplyShopMerchant() then
      self._ui.btn_Sell:SetSpanSize(0, 0)
      self._ui.btn_Sell:SetShow(true)
      self._ui.btn_Buy:SetShow(false)
      if characterStaticStatus:isGuildSupplyShopMerchant() then
        self._isTerritorySupply = false
      else
        self._isTerritorySupply = true
      end
    else
      self._ui.btn_Sell:SetSpanSize(135, 0)
      self._ui.btn_Sell:SetShow(true)
      self._ui.btn_Buy:SetShow(true)
      self._isTerritorySupply = false
    end
    self._ui.txt_AConsoleUI:SetShow(true)
    self._ui.txt_AlertText:SetShow(false)
  end
  _panel:SetShow(true)
end
function TradeMarketIn:close()
  _panel:SetShow(false)
end
function TradeMarketIn:init()
  self._ui.txt_AConsoleUI = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_A_ConsoleUI")
  self:registEventHandler()
end
function TradeMarketIn:registEventHandler()
  self._ui.btn_Sell:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_TradeMarketIn_OpenSellPanel()")
  self._ui.btn_Buy:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_TradeMarketIn_OpenBuyPanel()")
  PaGlobal_registerPanelOnBlackBackground(_panel)
end
function PaGlobal_TradeMarketIn_OpenSellPanel()
  local self = TradeMarketIn
  self:close()
  PaGlobal_TradeMarketGoods_Open()
  PaGlobal_TradeMarketGraph_Open(true, self._isTerritorySupply)
end
function PaGlobal_TradeMarketIn_OpenBuyPanel()
  local self = TradeMarketIn
  self:close()
  PaGlobal_TradeMarketBasket_Open()
  PaGlobal_TradeMarketGraph_Open(false, self._isTerritorySupply)
end
function PaGlobalFunc_TradeMarketIn_Open()
  local self = TradeMarketIn
  self:open()
end
function PaGlobalFunc_TradeMarketIn_Close()
  local self = TradeMarketIn
  self:close()
end
function PaGlobalFunc_TradeMarketIn_Init()
  local self = TradeMarketIn
  self:init()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_TradeMarketIn_Init")

PaGlobal_GuildHouse_Auction_Bid_All = {
  _ui = {
    stc_bidBg = nil,
    stc_aucPrice = nil,
    stc_icon = nil,
    stc_warehouseMoney = nil
  },
  _ui_pc = {
    btn_cancel = nil,
    btn_confirm = nil,
    btn_close = nil
  },
  _ui_console = {
    stc_bottomBg = nil,
    stc_selectA = nil,
    stc_cancelB = nil,
    stc_keyGuideX = nil
  },
  _sizeY = {
    CONSOLE_PANEL = 290,
    PC_PANEL = 360,
    CONSOLE_MAINBG = 230,
    PC_MAINBG = 300
  },
  _initialize = false,
  _isConsole = false,
  _bidIndex = nil,
  _auctionPrice = nil
}
runLua("UI_Data/Script/Window/Auction/Panel_GuildHouse_Auction_Bid_All_1.lua")
runLua("UI_Data/Script/Window/Auction/Panel_GuildHouse_Auction_Bid_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildHouse_Auction_Bid_AllInit")
function FromClient_GuildHouse_Auction_Bid_AllInit()
  PaGlobal_GuildHouse_Auction_Bid_All:initialize()
end

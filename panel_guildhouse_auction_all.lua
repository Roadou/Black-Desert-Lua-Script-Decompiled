PaGlobal_GuildHouse_Auction_All = {
  _ui = {
    stc_title = nil,
    btn_allBid = nil,
    btn_myBid = nil,
    stc_selectBar = nil,
    stc_tapBg = nil,
    stc_subPage = nil,
    stc_noticeBg = nil,
    stc_autionGuide = nil,
    stc_frame = nil,
    stc_subPageTitle = nil
  },
  _ui_pc = {
    btn_close = nil,
    btn_question = nil,
    btn_listLeft = nil,
    btn_listRight = nil
  },
  _ui_console = {
    btn_LT = nil,
    btn_RT = nil,
    btn_listLeft = nil,
    btn_listRight = nil,
    stc_bottomBg = nil,
    btn_viewInfo = nil,
    btn_close = nil,
    btn_bid = nil
  },
  _initialize = false,
  _isConsole = false,
  _sizeY = {
    CONSOLE_PANEL = 880,
    PC_PANEL = 910,
    CONSOLE_BIDLIST = 240,
    PC_BIDLIST = 260,
    CONSOLE_BIDLISTBG = 560,
    PC_BIDLISTBG = 590
  },
  _houseAuctionList = {},
  _houseMyBidList = {},
  _houseAuctionCnt = 0,
  _houseBidCnt = 0,
  _maxPage = 1,
  _isCheckMaxPage = true
}
runLua("UI_Data/Script/Window/Auction/Panel_GuildHouse_Auction_All_1.lua")
runLua("UI_Data/Script/Window/Auction/Panel_GuildHouse_Auction_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildHouse_Auction_AllInit")
function FromClient_GuildHouse_Auction_AllInit()
  PaGlobal_GuildHouse_Auction_All:initialize()
end

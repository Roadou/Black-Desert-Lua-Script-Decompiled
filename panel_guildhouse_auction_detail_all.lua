PaGlobal_GuildHouse_Auction_Detail_All = {
  _ui = {
    stc_subFrameBg = nil,
    stc_descBg = nil,
    stc_desc = nil,
    stc_image = nil
  },
  _ui_pc = {btn_close = nil, btn_bid = nil},
  _ui_console = {
    stc_bottom = nil,
    stc_cancel = nil,
    stc_apply = nil
  },
  _initialize = false,
  _isConsole = false,
  _houseTabType = nil,
  _houseIndex = nil,
  _sizeY = {
    CONSOLE_PANEL = 640,
    PC_PANEL = 710,
    CONSOLE_BG = 578,
    PC_BG = 638
  }
}
runLua("UI_Data/Script/Window/Auction/Panel_GuildHouse_Auction_Detail_All_1.lua")
runLua("UI_Data/Script/Window/Auction/Panel_GuildHouse_Auction_Detail_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildHouse_Auction_Detail_AllInit")
function FromClient_GuildHouse_Auction_Detail_AllInit()
  PaGlobal_GuildHouse_Auction_Detail_All:initialize()
end

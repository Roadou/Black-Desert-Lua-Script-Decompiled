PaGlobal_GuildWarInfoSmall = {
  _ui = {
    _btn_close = nil,
    _btn_refresh = nil,
    _btn_bigWin = nil,
    _stc_blackBG = nil,
    _stc_defenceBG = nil,
    _list_attackGuild = nil,
    _list_scroll = nil,
    _stc_noWarBG = nil,
    _stc_noOccupyBG = nil,
    _stc_comboBox = nil
  },
  _MAX_GUILDCOUNT = 50,
  _defenceGuildInfo = nil,
  _attackGuildInfo = nil,
  _isSeigeBeing = false,
  _siegeRegion = nil,
  _refreshTimer = 0,
  _initialize = false
}
runLua("UI_Data/Script/Window/GuildWarInfo/Panel_Window_GuildWarInfoSmall_1.lua")
runLua("UI_Data/Script/Window/GuildWarInfo/Panel_Window_GuildWarInfoSmall_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildWarInfoSmallInit")
function FromClient_GuildWarInfoSmallInit()
  PaGlobal_GuildWarInfoSmall:initialize()
  Panel_Window_GuildWarInfoSmall:RegisterUpdateFunc("PaGlobal_GuildWarInfoSmall_UpdatePerFrame")
end

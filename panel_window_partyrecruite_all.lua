PaGlobal_PartyRecruite_All = {
  _ui = {
    stc_centerBg = nil,
    edit_adDesc = nil,
    stc_level = nil
  },
  _ui_pc = {
    btn_close = nil,
    stc_icon_Text = nil,
    btn_admin = nil
  },
  _ui_console = {
    stc_icon_X = nil,
    stc_arrow = nil,
    stc_bottomBg = nil,
    stc_icon_A = nil,
    stc_icon_B = nil
  },
  _selectLevel = 0,
  _maxLevel = toInt64(0, 60),
  _initialize = false
}
runLua("UI_Data/Script/Window/Party/Panel_Window_PartyRecruite_All_1.lua")
runLua("UI_Data/Script/Window/Party/Panel_Window_PartyRecruite_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_PartyRecruite_All_Init")
function FromClient_PartyRecruite_All_Init()
  PaGlobal_PartyRecruite_All:initialize()
end

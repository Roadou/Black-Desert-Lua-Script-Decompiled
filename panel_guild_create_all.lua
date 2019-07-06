PaGlobal_Guild_Create_All = {
  _ui = {
    stc_nameBg = nil,
    stc_guildName = nil,
    stc_guildDesc = nil
  },
  _ui_pc = {
    btn_close = nil,
    btn_confirm = nil,
    btn_cancle = nil
  },
  _ui_console = {
    stc_bottomBg = nil,
    btn_confirm = nil,
    btn_close = nil
  },
  _initialize = false,
  _isConsole = false,
  _isClan = false,
  _isConfirm = false,
  _consolePanelSizeY = 425,
  _consoleBgSizeY = 433,
  _consoleBgSizeX = 688,
  _pcPanelSizeY = 495
}
runLua("UI_Data/Script/Window/Guild/Panel_Guild_Create_All_1.lua")
runLua("UI_Data/Script/Window/Guild/Panel_Guild_Create_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_PaGlobal_Guild_Create_AllInit")
function FromClient_PaGlobal_Guild_Create_AllInit()
  PaGlobal_Guild_Create_All:initialize()
end

PaGlobal_CreateClan_All = {
  _ui = {
    stc_title = nil,
    stc_btnBg = nil,
    btn_clan = nil,
    btn_guild = nil,
    stc_selectTypeDescBG = nil,
    stc_selectTypeDesc = nil
  },
  _ui_pc = {
    btn_close = nil,
    btn_question = nil,
    btn_confirm = nil
  },
  _ui_console = {
    stc_bottomBg = nil,
    btn_confirm = nil,
    btn_close = nil
  },
  _initialize = false,
  _isConsole = false,
  _isClan = false,
  _typeDescOriginSizeY = nil,
  _confirmOriginPosY = nil,
  _consloeMoveY = 85,
  _consolePanelSizeY = 770,
  _pcPanelSizeY = 840
}
runLua("UI_Data/Script/Window/Guild/Panel_Window_CreateClan_All_1.lua")
runLua("UI_Data/Script/Window/Guild/Panel_Window_CreateClan_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_PaGlobal_CreateClan_AllInit")
function FromClient_PaGlobal_CreateClan_AllInit()
  PaGlobal_CreateClan_All:initialize()
end

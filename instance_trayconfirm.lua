PaGlobal_TrayConfirm = {
  _ui = {
    _txtTitle = nil,
    _txtCheckDesc = nil,
    _txtTrayHelp = nil,
    _chkTray = nil,
    _btnConfirm = nil,
    _btnCancel = nil
  },
  _eMessageType = 0,
  _initialize = false
}
runLua("UI_Data/Script/Instance/TrayConfirm/Instance_TrayConfirm_1.lua")
runLua("UI_Data/Script/Instance/TrayConfirm/Instance_TrayConfirm_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_TrayConfirmInit")
function FromClient_TrayConfirmInit()
  PaGlobal_TrayConfirm:initialize()
end

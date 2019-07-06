PaGlobal_AreaOfHadum = {
  _ui = {
    _createTotemButton = nil,
    _openAndCloseButton = nil,
    _pointProgressBar = nil,
    _pointTextBox = nil,
    _hadumIcon = nil
  },
  _initialize = false,
  _isOpen = false
}
runLua("UI_Data/Script/Widget/Hadum/Panel_Widget_Hadum_1.lua")
runLua("UI_Data/Script/Widget/Hadum/Panel_Widget_Hadum_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_AreaOfHadumInit")
function FromClient_AreaOfHadumInit()
  PaGlobal_AreaOfHadum:initialize()
end

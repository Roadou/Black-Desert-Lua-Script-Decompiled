PaGlobal_CommandGuide = {
  _ui = {
    _stc_commandBg = nil,
    _stc_commandShowBg = nil,
    _txt_commandKey = {},
    _txt_commandKeyDesc = {},
    _stc_commandMouse = {},
    _txt_dot = nil
  },
  dotControl = {},
  keyControl = {},
  _MOUSETYPE = {LEFT = 1, RIGHT = 2},
  _isShowType = nil,
  _maxCommandCount = 0,
  _initialize = false
}
runLua("UI_Data/Script/Widget/Interaction/Panel_CommandGuide_1.lua")
runLua("UI_Data/Script/Widget/Interaction/Panel_CommandGuide_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_CommandGuideInit")
function FromClient_CommandGuideInit()
  PaGlobal_CommandGuide:initialize()
end

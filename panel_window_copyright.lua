PaGlobal_Copyright = {
  _ui = {_web_copyright = nil},
  _screenSizeX = nil,
  _screenSizeY = nil,
  _initialize = false,
  _isType = 0,
  _isLogin = false
}
registerEvent("FromClient_luaLoadComplete", "FromClient_CopyrightInit")
runLua("UI_Data/Script/Window/Copyright/Console/Panel_Window_Copyright_1.lua")
runLua("UI_Data/Script/Window/Copyright/Console/Panel_Window_Copyright_2.lua")
function FromClient_CopyrightInit()
  PaGlobal_Copyright:initialize()
end

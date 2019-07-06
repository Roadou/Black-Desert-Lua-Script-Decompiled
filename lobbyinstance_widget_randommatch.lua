PaGlobal_RandomMatch = {
  _ui = {_btnCancel = nil},
  _isSearch = false,
  _initialize = false
}
runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Widget_RandomMatch_1.lua")
runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Widget_RandomMatch_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_LobbyInstance_RandomMatchInit")
function FromClient_LobbyInstance_RandomMatchInit()
  PaGlobal_RandomMatch:initialize()
end

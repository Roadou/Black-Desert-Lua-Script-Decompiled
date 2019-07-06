PaGlobal_LobbyInstanceRating = {
  _ui = {
    _topArea = UI.getChildControl(LobbyInstance_Widget_Rating, "Static_Top_Area"),
    _bottomBg = UI.getChildControl(LobbyInstance_Widget_Rating, "Static_Bottom_Area")
  },
  nowToggleKey = __eBattleRoyaleMode_Solo,
  initialize = false
}
runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Widget_Rating_1.lua")
runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Widget_Rating_2.lua")
function FromClient_LobbyInstanceRating_luaLoadComplete()
  PaGlobal_LobbyInstanceRating:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_LobbyInstanceRating_luaLoadComplete")

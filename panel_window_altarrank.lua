PaGlobal_AltarRankWeb = {
  _ui = {stc_titleBG = nil, btn_Close = nil},
  _config = {_WEBSIZEX = 834, _WEBSIZEY = 590},
  _webControl = nil,
  _initialize = false
}
runLua("UI_Data/Script/Window/Rank/Panel_Window_AltarRank_1.lua")
runLua("UI_Data/Script/Window/Rank/Panel_Window_AltarRank_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_AltarRank_WebInit")
function FromClient_AltarRank_WebInit()
  PaGlobal_AltarRankWeb:initialize()
end

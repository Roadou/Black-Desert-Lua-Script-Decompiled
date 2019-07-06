PaGlobal_VolunteerRankWeb = {
  _ui = {stc_titleBG = nil, btn_Close = nil},
  _config = {_WEBSIZEX = 834, _WEBSIZEY = 590},
  _webControl = nil,
  _initialize = false
}
runLua("UI_Data/Script/Window/Rank/Panel_Window_VolunteerRankWeb_1.lua")
runLua("UI_Data/Script/Window/Rank/Panel_Window_VolunteerRankWeb_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_VolunteerRank_WebInit")
function FromClient_VolunteerRank_WebInit()
  PaGlobal_VolunteerRankWeb:initialize()
end

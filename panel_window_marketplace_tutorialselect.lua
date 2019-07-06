PaGlobal_MarketPlaceTutorialSelect = {
  _ui = {},
  _TYPE = {
    REGISTER = 1,
    BUY = 2,
    SELL = 3
  },
  _initialize = false
}
runLua("UI_Data/Script/Window/MarketPlace/Panel_Window_MarketPlace_TutorialSelect_1.lua")
runLua("UI_Data/Script/Window/MarketPlace/Panel_Window_MarketPlace_TutorialSelect_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_MarketPlaceTutorialSelect_Init")
function FromClient_MarketPlaceTutorialSelect_Init()
  PaGlobal_MarketPlaceTutorialSelect:initialize()
end

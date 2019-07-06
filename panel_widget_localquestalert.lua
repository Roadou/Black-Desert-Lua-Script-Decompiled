PaGlobal_LocalQuestAlert = {
  _ui = {
    stc_bg = UI.getChildControl(Panel_Widget_LocalQuestAlert, "Static_BG")
  },
  _info = {},
  _LOCAL = {
    CALPHEON = 1,
    BALENOS = 2,
    VALENCIA = 3,
    SERENDIA = 4,
    MEDIA = 5,
    DRIGAN = 6,
    KAMASYLVIA = 7
  },
  _completeInfoKey = -1,
  _initialize = false
}
runLua("UI_Data/Script/Widget/Alert/Panel_Widget_LocalQuestAlert_1.lua")
runLua("UI_Data/Script/Widget/Alert/Panel_Widget_LocalQuestAlert_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_LocalQuestAlert_Init")
function FromClient_LocalQuestAlert_Init()
  PaGlobal_LocalQuestAlert:initialize()
end

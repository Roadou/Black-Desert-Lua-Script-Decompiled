PaGlobal_TopIcon_Garden = {
  _ui = {static_GardenIcon_Template = nil},
  _harvestEffect = "fUI_Garden_01A",
  _harvestEffectOn = false,
  _initialize = false
}
runLua("UI_Data/Script/Widget/TopWidgetIcon/Console/Panel_Widget_TopIcon_Garden_1.lua")
runLua("UI_Data/Script/Widget/TopWidgetIcon/Console/Panel_Widget_TopIcon_Garden_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_TopIcon_GardenInit")
function FromClient_TopIcon_GardenInit()
  PaGlobal_TopIcon_Garden:initialize()
end

PaGlobal_WorldMapBarterInfo = {
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true,
    createCount = true
  },
  _initialize = false,
  _panelList = Array.new()
}
runLua("UI_Data/Script/Window/Worldmap_Grand/Panel_Worldmap_BarterInfo_1.lua")
runLua("UI_Data/Script/Window/Worldmap_Grand/Panel_Worldmap_BarterInfo_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_WorldMapBarterInfoInit")
function FromClient_WorldMapBarterInfoInit()
  PaGlobal_WorldMapBarterInfo:initialize()
end

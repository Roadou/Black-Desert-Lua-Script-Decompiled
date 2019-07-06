PaGlobal_GardenInformation = {
  _ui = {_list2_cropInfo = nil},
  _cropIndexList = {},
  _keyGuideAlign = {},
  _initialize = false
}
runLua("UI_Data/Script/Widget/Housing/Console/Panel_Window_GardenInformation_Renew_1.lua")
runLua("UI_Data/Script/Widget/Housing/Console/Panel_Window_GardenInformation_Renew_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_GardenInformationInit")
function FromClient_GardenInformationInit()
  PaGlobal_GardenInformation:initialize()
end

PaGlobal_GardenList = {
  _ui = {_list2_garden = nil},
  _totalGardenCount = nil,
  _gardenIndexList = {},
  _gardenPosList = {},
  _isHarvestManagementOpen = nil,
  _keyGuideAlign = {},
  _initialize = false
}
runLua("UI_Data/Script/Widget/Housing/Console/Panel_Window_GardenList_Renew_1.lua")
runLua("UI_Data/Script/Widget/Housing/Console/Panel_Window_GardenList_Renew_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_GardenListInit")
function FromClient_GardenListInit()
  PaGlobal_GardenList:initialize()
end

PaGlobal_GrowStepManager = {
  _isOnce = {worldMap2 = false, worldMap3 = false},
  _initialize = false
}
runLua("UI_Data/script/Widget/ContentOpen/GrowStepManager_1.lua")
runLua("UI_Data/script/Widget/ContentOpen/GrowStepManager_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_GrowStepManager")
function FromClient_GrowStepManager()
  PaGlobal_GrowStepManager:initialize()
end

PaGlobal_BloodAltarGauge_All = {
  _ui = {},
  _isExitOn = false,
  _exitPosX = 0,
  _currentGaugeRate = 0,
  _currentStageTitle = "",
  _initialize = false
}
runLua("UI_Data/Script/Window/BloodAltar/Panel_Widget_BloodAltarGauge_All_1.lua")
runLua("UI_Data/Script/Window/BloodAltar/Panel_Widget_BloodAltarGauge_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_BloodAltarGauge_Initialize")
function FromClient_BloodAltarGauge_Initialize()
  PaGlobal_BloodAltarGauge_All:initialize()
end

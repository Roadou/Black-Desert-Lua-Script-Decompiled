PaGlobal_WatchTimer = {
  _ui = {
    _timerText = UI.getChildControl(Instance_Widget_WatchTimer, "StaticText_Timer"),
    stc_surviveTime = UI.getChildControl(Instance_Widget_WatchTimer, "Static_SurviveTime")
  },
  _brStartTime = 0,
  _timer = 0,
  _lastUpdateTime = 0,
  _initialize = false
}
runLua("UI_Data/Script/Instance/Instance_Widget_WatchTimer_1.lua")
runLua("UI_Data/Script/Instance/Instance_Widget_WatchTimer_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_WatchTimerInit")
function FromClient_WatchTimerInit()
  PaGlobal_WatchTimer:initialize()
end

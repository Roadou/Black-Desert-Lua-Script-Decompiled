PaGlobal_NationSiegeKillLog = {
  _ui = {
    stc_log = nil,
    txt_killer = nil,
    txt_victim = nil,
    stc_calpheonIcon = nil,
    stc_valenciaIcon = nil
  },
  _logPool = {
    _logData = {},
    _startPos = float2(0, 0),
    _offsetSizeY = nil,
    _killerSize = float2(0, 0),
    _victimSize = float2(0, 0)
  },
  _logAnimTime = 0.1,
  _maxViewTime = 10,
  _isAnimCool = false,
  _fAnimDeltaTime = 0,
  _MAX_ROW = 10,
  _LOOP_ROW = 9,
  _msgList = Array.new(),
  _killCount = {},
  _initialize = false
}
runLua("UI_Data/Script/Widget/NationSiege/Panel_Widget_NationSiegeKillLog_1.lua")
runLua("UI_Data/Script/Widget/NationSiege/Panel_Widget_NationSiegeKillLog_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_PaGlobal_NationSiegeKillLogInit")
function FromClient_PaGlobal_NationSiegeKillLogInit()
  PaGlobal_NationSiegeKillLog:initialize()
end

PaGlobal_NationSiegeStatus = {
  ENUM_CLASS = {
    GENERAL = 1,
    SUBBOSS_1 = 2,
    SUBBOSS_2 = 3
  },
  ENUM_TERRITORY = {CALPHEON = 2, VALENCIA = 4},
  _ui = {
    _calpheon = {
      [1] = {},
      [2] = {},
      [3] = {},
      ["txt_deadCount"] = nil
    },
    _valencia = {
      [1] = {},
      [2] = {},
      [3] = {},
      ["txt_deadCount"] = nil
    },
    _staticText_revivePoint = nil
  },
  _isCacheQuestPanelShow = false,
  _siege_ClassString = {},
  _initialize = false
}
runLua("UI_Data/Script/Widget/NationSiege/NationSiegeStatus/Panel_Widget_NationSiegeStatus_1.lua")
runLua("UI_Data/Script/Widget/NationSiege/NationSiegeStatus/Panel_Widget_NationSiegeStatus_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_NationSiegeStatusInit")
function FromClient_NationSiegeStatusInit()
  PaGlobal_NationSiegeStatus:initialize()
end

PaGlobal_WorkerSkillTooltip_All = {
  _ui = {
    _stc_Tooltip_Template = nil,
    _icon_SkillBgTemplate = nil,
    _icon_SkillTemplate = nil,
    _txt_Name_Template = nil,
    _txt_Desc_Template = nil
  },
  _MAXSLOT = 7,
  _tooltiplist = {},
  _TOOLTIPSIZE_Y = 81,
  _TOOLTIPPOS_Y = 150,
  _uiBase = nil,
  _initialize = false,
  _isConsole = false
}
runLua("UI_Data/Script/Widget/Tooltip/Panel_WorkerSkillTooltip_All_1.lua")
runLua("UI_Data/Script/Widget/Tooltip/Panel_WorkerSkillTooltip_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_WorketSkillTooltip_ALL_Init")
function FromClient_WorketSkillTooltip_ALL_Init()
  PaGlobal_WorkerSkillTooltip_All:initialize()
end

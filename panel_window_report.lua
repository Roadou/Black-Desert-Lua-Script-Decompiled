PaGlobal_Report = {
  _ui = {
    _stc_Main = nil,
    _rdo_Classifys = {},
    _edit_Contents = nil,
    stc_BottomBG = nil,
    stc_ConsoleUI_Y = nil,
    stc_ConsoleUI_A = nil,
    stc_ConsoleUI_B = nil
  },
  _value = {classifyCount = 7, selectedClassify = nil},
  _string = {
    default = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDINFO_INPUT_EDITTEXT", "maxLength", 120)
  },
  _initialize = false
}
runLua("UI_Data/Script/Window/Report/Panel_Window_Report_1.lua")
runLua("UI_Data/Script/Window/Report/Panel_Window_Report_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_Report_Init")
function FromClient_Report_Init()
  PaGlobal_Report:initialize()
end

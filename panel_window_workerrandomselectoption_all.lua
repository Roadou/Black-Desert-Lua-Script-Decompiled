PaGlobal_WorkerRandomSelectOption_All = {
  _ui = {
    _stc_TitleBg = nil,
    _btn_Close_PC = nil,
    _btn_Continue_PC = nil,
    _btn_Cancel_PC = nil,
    _stc_MainBg_KeyGuide = nil,
    _stc_MainBg_KeyGuide_A = nil,
    _stc_MainBg_KeyGudie_B = nil,
    _stc_MainBg_KeyGudie_Y = nil,
    _btn_WorkerRace = nil,
    _txt_WorkerRace = nil,
    _btn_WorkerGrade = nil,
    _txt_WorkerGrade = nil,
    _btn_WorkerCount = nil,
    _txt_workerCount = nil,
    _stc_MainDescBg = nil,
    _txt_MainDesc = nil,
    _stc_GradeSelectBg = nil,
    _btn_GradeSelect_All = nil,
    _btn_GradeSelect_Normal = nil,
    _btn_GradeSelect_Skilled = nil,
    _btn_GradeSelect_Expert = nil,
    _btn_GradeSelect_OnlyMaster = nil,
    _btn_GradeSelect_Confirm = nil
  },
  _config = {_repetitionCount = 1, _workerGrade = 0},
  _ENUM_GRADE = {
    _ALL = 0,
    _NORMAL = 1,
    _SKILLED = 2,
    _EXPERT = 3,
    _ONLYMASTER = 4
  },
  _gradeButtons = {},
  _selectedButton = nil,
  _isConsole = false,
  _initialize = false
}
runLua("UI_Data/Script/Window/WokerHire/Panel_Window_WorkerRandomSelectOption_All_1.lua")
runLua("UI_Data/Script/Window/WokerHire/Panel_Window_WorkerRandomSelectOption_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_WorkerRandomSelectOption_Init")
function FromClient_WorkerRandomSelectOption_Init()
  PaGlobal_WorkerRandomSelectOption_All:initialize()
end

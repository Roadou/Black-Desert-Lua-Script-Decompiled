PaGlobal_WorkerRandomSelect_All = {
  _ui = {
    _stc_TitleBg = nil,
    _btn_Close_PC = nil,
    _btn_Question_PC = nil,
    _stc_ImgBg = nil,
    _stc_WokerImg = nil,
    _txt_WorkerName = nil,
    _txt_WorkerSpeed = nil,
    _txt_WokrerMoveSpeed = nil,
    _txt_WokrerLuck = nil,
    _txt_WorkerActionPoint = nil,
    _stc_WorkerEmployBg = nil,
    _txt_WorkerEmployCount = nil,
    _stc_CurrentEnergyBg = nil,
    _icon_CurrentEnergy = nil,
    _txt_CurrentEnergy = nil,
    _stc_WorkerHireFeeBg = nil,
    _icon_WorkerHireFee = nil,
    _txt_WorkerHireFee = nil,
    _rdo_InvenMoney = nil,
    _txt_InvenMoney = nil,
    _rdo_WareMoney = nil,
    _txt_WareMoney = nil,
    _btn_Continuation_PC = nil,
    _btn_OtherWorker_PC = nil,
    _btn_HireWorker_PC = nil,
    _stc_KeyGuideBg = nil,
    _stc_KeyGuide_A = nil,
    _stc_KeyGuide_B = nil,
    _stc_KeyGuide_X = nil,
    _stc_KeyGuide_Y = nil,
    _stc_Plus_ConsoleUI = nil,
    _stc_X_With_RT_ConsoleUI = nil,
    _stc_RT_With_X_ConsoleUI = nil
  },
  _currentWorkerinfo = {_workerIdx = nil, _workerPrice64 = nil},
  _config = {_repetitionCount = nil, _workerGrade = nil},
  _ENUM_GRADE = {
    ALL = 0,
    NORMAL = 0,
    SKILLED = 1,
    EXPERT = 2,
    ONLYMASTER = 3
  },
  _HIRECOST = 5,
  _REFRESH_RATE = 1,
  _delta_Time = nil,
  _Count = 0,
  _checkPopUp = nil,
  _isCurrectWorkerCondition = false,
  _isContinueSelectWorkerStart = false,
  _keyGuides = {},
  _filteredWorker = {},
  _isConsole = false,
  _initialize = false
}
runLua("UI_Data/Script/Window/WokerHire/Panel_Window_WorkerRandomSelect_All_1.lua")
runLua("UI_Data/Script/Window/WokerHire/Panel_Window_WorkerRandomSelect_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_WorkerRandomSelectInit")
function FromClient_WorkerRandomSelectInit()
  PaGlobal_WorkerRandomSelect_All:initialize()
end

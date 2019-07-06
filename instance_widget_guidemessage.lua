PaGlobal_GuideMessage = {
  _eState = {
    _non = 0,
    _state1Ing = 2,
    _state1End = 3,
    _state2Ing = 5,
    _state2End = 6
  },
  _ui = {_static_State1BG = nil, _static_State2BG = nil},
  _classList = {
    CppEnums.ClassType.ClassType_Warrior,
    CppEnums.ClassType.ClassType_Sorcerer,
    CppEnums.ClassType.ClassType_Giant,
    CppEnums.ClassType.ClassType_Tamer,
    CppEnums.ClassType.ClassType_BladeMaster,
    CppEnums.ClassType.ClassType_BladeMasterWomen,
    CppEnums.ClassType.ClassType_CombattantWomen,
    CppEnums.ClassType.ClassType_Valkyrie,
    CppEnums.ClassType.ClassType_NinjaWomen,
    CppEnums.ClassType.ClassType_DarkElf,
    CppEnums.ClassType.ClassType_Wizard,
    CppEnums.ClassType.ClassType_WizardWomen,
    CppEnums.ClassType.ClassType_NinjaMan,
    CppEnums.ClassType.ClassType_Combattant,
    __eClassType_ElfRanger_Reserved1,
    __eClassType_ElfRanger_Reserved2,
    __eClassType_KunoichiOld
  },
  _isStart = false,
  _currentTime = 0,
  _currentState = 0,
  _STATE1_START_TIME = 20,
  _STATE1_END_TIME = 30,
  _STATE2_START_TIME = 32,
  _STATE2_END_TIME = 40,
  _initialize = false
}
runLua("UI_Data/Script/Instance/GuideMessage/Instance_Widget_GuideMessage_1.lua")
runLua("UI_Data/Script/Instance/GuideMessage/Instance_Widget_GuideMessage_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_GuideMessageInit")
function FromClient_GuideMessageInit()
  PaGlobal_GuideMessage:initialize()
end

PaGlobal_Window_FamilySkill_Main = {
  _ui = {
    _skillPointTitleArray = {},
    _skillPointValueArray = {},
    _resetSkillButton = nil,
    _skillDescription = nil,
    _skillIconArray = {},
    _skillIconBgArray = {},
    _skillList = nil
  },
  _skillPointTitleCount = nil,
  _initialize = false,
  _learnSkillKind = nil,
  _learnSkillLevel = nil
}
runLua("UI_Data/Script/Widget/EdanaContract/Panel_Window_Edana_Main_1.lua")
runLua("UI_Data/Script/Widget/EdanaContract/Panel_Window_Edana_Main_2.lua")
registerEvent("FromClient_UpdateFamilySkillExpAndPoint", "FromClient_UpdateFamilySkillExpAndPoint")
registerEvent("FromClient_UpdateFamilySkill", "FromClient_UpdateFamilySkill")

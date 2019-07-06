local CT = CppEnums.ClassType
PaGlobal_AwakenSkill = {
  awakenWeapon = {
    [CT.ClassType_Warrior] = ToClient_IsContentsGroupOpen("901"),
    [CT.ClassType_Ranger] = ToClient_IsContentsGroupOpen("902"),
    [CT.ClassType_Sorcerer] = ToClient_IsContentsGroupOpen("903"),
    [CT.ClassType_Giant] = ToClient_IsContentsGroupOpen("904"),
    [CT.ClassType_Tamer] = ToClient_IsContentsGroupOpen("905"),
    [CT.ClassType_BladeMaster] = ToClient_IsContentsGroupOpen("906"),
    [CT.ClassType_BladeMasterWomen] = ToClient_IsContentsGroupOpen("907"),
    [CT.ClassType_Valkyrie] = ToClient_IsContentsGroupOpen("908"),
    [CT.ClassType_Wizard] = ToClient_IsContentsGroupOpen("909"),
    [CT.ClassType_WizardWomen] = ToClient_IsContentsGroupOpen("910"),
    [CT.ClassType_NinjaMan] = ToClient_IsContentsGroupOpen("911"),
    [CT.ClassType_NinjaWomen] = ToClient_IsContentsGroupOpen("912"),
    [CT.ClassType_DarkElf] = ToClient_IsContentsGroupOpen("913"),
    [CT.ClassType_Combattant] = ToClient_IsContentsGroupOpen("914"),
    [CT.ClassType_CombattantWomen] = ToClient_IsContentsGroupOpen("918"),
    [CT.ClassType_Lahn] = ToClient_IsContentsGroupOpen("916"),
    [CT.ClassType_Orange] = ToClient_IsContentsGroupOpen("942"),
    [__eClassType_ShyWaman] = ToClient_IsContentsGroupOpen("1366")
  },
  isAwakenWeaponContentsOpen = false
}
function PaGlobal_AwakenSkill:initalize()
  self.isAwakenWeaponContentsOpen = self.awakenWeapon[getSelfPlayer():getClassType()]
  PaGlobal_Skill.radioButtons[PaGlobal_Skill.awakenTabIndex]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_AWAKEN_WEAPONS"))
  if self.isAwakenWeaponContentsOpen then
    PaGlobal_Skill.radioButtons[PaGlobal_Skill.awakenTabIndex]:SetShow(true)
  else
    PaGlobal_Skill.radioButtons[PaGlobal_Skill.awakenTabIndex]:SetShow(false)
  end
end

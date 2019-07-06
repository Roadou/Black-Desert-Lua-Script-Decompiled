local CT = CppEnums.ClassType
PaGlobal_SuccessionSkill = {
  classSuccessionSkill = {
    [CT.ClassType_Warrior] = ToClient_IsContentsGroupOpen("1367"),
    [CT.ClassType_Ranger] = ToClient_IsContentsGroupOpen("1368"),
    [CT.ClassType_Sorcerer] = ToClient_IsContentsGroupOpen("1369"),
    [CT.ClassType_Giant] = ToClient_IsContentsGroupOpen("1370"),
    [CT.ClassType_Tamer] = ToClient_IsContentsGroupOpen("1371"),
    [CT.ClassType_BladeMaster] = ToClient_IsContentsGroupOpen("1372"),
    [CT.ClassType_BladeMasterWomen] = ToClient_IsContentsGroupOpen("1373"),
    [CT.ClassType_Valkyrie] = ToClient_IsContentsGroupOpen("1374"),
    [CT.ClassType_Wizard] = ToClient_IsContentsGroupOpen("1375"),
    [CT.ClassType_WizardWomen] = ToClient_IsContentsGroupOpen("1376"),
    [CT.ClassType_NinjaMan] = ToClient_IsContentsGroupOpen("1377"),
    [CT.ClassType_NinjaWomen] = ToClient_IsContentsGroupOpen("1378"),
    [CT.ClassType_DarkElf] = ToClient_IsContentsGroupOpen("1379"),
    [CT.ClassType_Combattant] = ToClient_IsContentsGroupOpen("1380"),
    [CT.ClassType_CombattantWomen] = ToClient_IsContentsGroupOpen("1381"),
    [CT.ClassType_Lahn] = ToClient_IsContentsGroupOpen("1382"),
    [CT.ClassType_Orange] = ToClient_IsContentsGroupOpen("1383"),
    [__eClassType_ShyWaman] = ToClient_IsContentsGroupOpen("1366")
  },
  isSuccessionContentsOpen = false
}
function PaGlobal_SuccessionSkill:initalize()
  self.isAwakenWeaponContentsOpen = self.classSuccessionSkill[getSelfPlayer():getClassType()]
  if self.isAwakenWeaponContentsOpen then
    PaGlobal_Skill.radioButtons[PaGlobal_Skill.successionTabIndex]:SetShow(true)
  else
    PaGlobal_Skill.radioButtons[PaGlobal_Skill.successionTabIndex]:SetShow(false)
  end
end

Panel_MainStatus_User_ProductSkillPoint:SetShow(true)
local _staticSkillExp = UI.getChildControl(Panel_MainStatus_User_ProductSkillPoint, "CircularProgress_SkillExp_p")
local _staticSkillPoint = UI.getChildControl(Panel_MainStatus_User_ProductSkillPoint, "StaticText_SkillPoint_p")
function Panel_User_ProductSkillPoint_Update()
  local skillPointInfo = ToClient_getSkillPointInfo(2)
  _staticSkillPoint:SetText(tostring(skillPointInfo._remainPoint))
  local skillExpRate = skillPointInfo._currentExp / skillPointInfo._nextLevelExp
  _staticSkillExp:SetProgressRate(skillExpRate * 100)
end

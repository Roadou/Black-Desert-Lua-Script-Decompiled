local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
function Skill_ShowAni()
  UIAni.fadeInSCR_Down(Instance_Window_Skill)
end
function Skill_HideAni()
  Instance_Window_Skill:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local skillHideAni = Instance_Window_Skill:addColorAnimation(0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  skillHideAni:SetStartColor(UI_color.C_FFFFFFFF)
  skillHideAni:SetEndColor(UI_color.C_00FFFFFF)
  skillHideAni:SetStartIntensity(3)
  skillHideAni:SetEndIntensity(1)
  skillHideAni.IsChangeChild = true
  skillHideAni:SetHideAtEnd(true)
  skillHideAni:SetDisableWhileAni(true)
end
function PaGlobal_Skill:OpenLearnAni1()
  local aniInfo1 = Instance_Window_Skill:addScaleAnimation(0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Instance_Window_Skill:GetSizeX() / 2
  aniInfo1.AxisY = Instance_Window_Skill:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
end
function PaGlobal_Skill:OpenLearnAni2()
  local aniInfo2 = Instance_Window_Skill:addScaleAnimation(0.12, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Instance_Window_Skill:GetSizeX() / 2
  aniInfo2.AxisY = Instance_Window_Skill:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end

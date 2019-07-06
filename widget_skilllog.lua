Panel_Widget_SkillLog:setGlassBackground(true)
Panel_Widget_SkillLog:setMaskingChild(true)
Panel_Widget_SkillLog:SetShow(false, false)
Panel_Widget_SkillLog:RegisterShowEventFunc(true, "Panel_Widget_SkillLog_ShowAni()")
Panel_Widget_SkillLog:RegisterShowEventFunc(false, "Panel_Widget_SkillLog_HideAni()")
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_DS = CppEnums.DialogState
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
local skillLog_Icon = UI.getChildControl(Panel_Widget_SkillLog, "Static_C_SkillIcon")
local skillLog = UI.getChildControl(Panel_Widget_SkillLog, "StaticText_UsedSkill")
local notifySkillMsg = {}
local panelPosX = Panel_Widget_SkillLog:GetPosX()
local panelPosY = Panel_Widget_SkillLog:GetPosY()
local iconSizeX = skillLog_Icon:GetSizeX()
local iconSizeY = skillLog_Icon:GetSizeY()
local logPosX = skillLog:GetPosX()
notifySkillMsg[0] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Widget_SkillLog, "StaticText_SkillMsg_1")
CopyBaseProperty(skillLog, notifySkillMsg[0])
notifySkillMsg[1] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Widget_SkillLog, "StaticText_SkillMsg_2")
CopyBaseProperty(skillLog, notifySkillMsg[1])
notifySkillMsg[2] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Widget_SkillLog, "StaticText_SkillMsg_3")
CopyBaseProperty(skillLog, notifySkillMsg[2])
local displayTime = 2
local _displayRunningTime = 0
function Panel_Widget_SkillLog_ShowAni()
  Panel_Widget_SkillLog:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toTop.dds")
  local FadeMaskAni = Panel_Widget_SkillLog:addTextureUVAnimation(0, 0.75, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0.1, 0)
  FadeMaskAni:SetEndUV(0, 0.6, 0)
  FadeMaskAni:SetStartUV(1, 0.1, 1)
  FadeMaskAni:SetEndUV(1, 0.6, 1)
  FadeMaskAni:SetStartUV(0, 0.4, 2)
  FadeMaskAni:SetEndUV(0, 1, 2)
  FadeMaskAni:SetStartUV(1, 0.4, 3)
  FadeMaskAni:SetEndUV(1, 1, 3)
  Panel_Widget_SkillLog:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo3 = Panel_Widget_SkillLog:addColorAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo3:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo3.IsChangeChild = true
  local aniInfo8 = Panel_Widget_SkillLog:addColorAnimation(0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo8:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetStartIntensity(3)
  aniInfo8:SetEndIntensity(1)
end
function Panel_Widget_SkillLog_HideAni()
  Panel_Widget_SkillLog:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local SkillLog_Alpha = Panel_Widget_SkillLog:addColorAnimation(0, 0.6, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  SkillLog_Alpha:SetStartColor(UI_color.C_FFFFFFFF)
  SkillLog_Alpha:SetEndColor(UI_color.C_00FFFFFF)
  SkillLog_Alpha.IsChangeChild = true
  SkillLog_Alpha:SetHideAtEnd(true)
  SkillLog_Alpha:SetDisableWhileAni(true)
end
local index = 0
function SkillLog_Init()
  _displayRunningTime = 0
  notifySkillMsg[0]:SetText("")
  notifySkillMsg[1]:SetText("")
  notifySkillMsg[2]:SetText("")
  index = 0
end
function FromClient_EventSelfPlayerUsedSkill()
  local autoUIPosY = 0
  if ToClient_getAutoMode() == CppEnums.Client_AutoControlStateType.BATTLE then
    Panel_Widget_SkillLog:SetPosX(Panel_Movie_KeyViewer:GetPosX() + 50)
    Panel_Widget_SkillLog:SetPosY(Panel_Movie_KeyViewer:GetPosY() - 100)
    skillLog_Icon:SetSize(70, 70)
    notifySkillMsg[0]:SetPosX(90)
    notifySkillMsg[1]:SetPosX(90)
    notifySkillMsg[2]:SetPosX(90)
    autoUIPosY = 32
  else
    Panel_Widget_SkillLog:SetPosX(getOriginScreenSizeX() / 2 - Panel_Widget_SkillLog:GetSizeX() * 1.3)
    Panel_Widget_SkillLog:SetPosY(getOriginScreenSizeY() / 2 + Panel_Widget_SkillLog:GetSizeY() / 2)
    skillLog_Icon:SetSize(iconSizeX, iconSizeY)
    notifySkillMsg[0]:SetPosX(logPosX)
    notifySkillMsg[1]:SetPosX(logPosX)
    notifySkillMsg[2]:SetPosX(logPosX)
  end
  if false == FGlobal_IsChecked_SkillCommand() then
    Panel_Widget_SkillLog:SetShow(false)
    local skillWrapper = selfPlayerUsedSkillFront()
    PaGlobal_TutorialManager:handleEventSelfPlayerUsedSkill(skillWrapper)
    Tutorial_CheckUsedSkill(skillWrapper)
    selfPlayerUsedSkillPopFront()
    return
  end
  Panel_Widget_SkillLog:SetShow(true, true)
  local skillWrapper = selfPlayerUsedSkillFront()
  if nil ~= skillWrapper then
    local local_index = index % 3
    PaGlobal_TutorialManager:handleEventSelfPlayerUsedSkill(skillWrapper)
    Tutorial_CheckUsedSkill(skillWrapper)
    local iconPath = skillWrapper:getSkillTypeStaticStatusWrapper():getIconPath()
    skillLog_Icon:ChangeTextureInfoNameAsync("Icon/" .. iconPath)
    local skillName = skillWrapper:getName()
    SkillName_fadeIn(notifySkillMsg[local_index])
    notifySkillMsg[local_index]:SetText(skillName)
    notifySkillMsg[local_index]:SetShow(true)
    notifySkillMsg[local_index]:SetPosY(58 + autoUIPosY)
    selfPlayerUsedSkillPopFront()
    notifySkillMsg[(index - 1) % 3]:SetPosY(30 + autoUIPosY)
    notifySkillMsg[(index - 2) % 3]:SetPosY(2 + autoUIPosY)
    _displayRunningTime = 0
    index = index + 1
  end
  if false == ToClient_isConsole() then
    SkillCommand_Effect(skillWrapper)
  end
end
function SkillName_fadeOut(control)
  local aniInfo = control:addColorAnimation(2, 1.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo:SetStartColor(Defines.Color.C_FFFFFFFF)
  aniInfo:SetEndColor(Defines.Color.C_00FFFFFF)
  aniInfo:SetHideAtEnd(false)
end
function SkillName_fadeIn(control)
  local aniInfo = control:addColorAnimation(0, 0.15, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo:SetStartColor(Defines.Color.C_00FFFFFF)
  aniInfo:SetEndColor(Defines.Color.C_FFFFFFFF)
end
function SkillName_ScaleAni(control)
  local aniInfo = control:addScaleAnimation(0, 0.05, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo:SetStartScale(0)
  aniInfo:SetEndScale(1)
  aniInfo.AxisX = 0
  aniInfo.AxisY = 0
  aniInfo.ScaleType = 4
end
function SkillLog_TimeCheck(deltaTime)
  _displayRunningTime = _displayRunningTime + deltaTime
  if displayTime < _displayRunningTime then
    Panel_Widget_SkillLog:SetShow(false, true)
    SkillLog_Init()
  end
end
function Panel_Widget_SkillLog_SetPos()
  Panel_Widget_SkillLog:SetPosX(getOriginScreenSizeX() / 2 - Panel_Widget_SkillLog:GetSizeX() * 1.3)
  Panel_Widget_SkillLog:SetPosY(getOriginScreenSizeY() / 2 + Panel_Widget_SkillLog:GetSizeY() / 2)
end
SkillLog_Init()
Panel_Widget_SkillLog:RegisterUpdateFunc("SkillLog_TimeCheck")
registerEvent("EventSelfPlayerUsedSkill", "FromClient_EventSelfPlayerUsedSkill")
registerEvent("onScreenResize", "Panel_Widget_SkillLog_SetPos")

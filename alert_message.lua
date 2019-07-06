PAGlobal_Alert_Message = {_showingSec = 1}
Panel_Alert_Message:SetShow(false, false)
Panel_Alert_Message:RegisterShowEventFunc(true, "AlertMessage_ShowAni()")
Panel_Alert_Message:RegisterShowEventFunc(false, "AlertMessage_HideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
local UI_color = Defines.Color
local desc = UI.getChildControl(Panel_Alert_Message, "StaticText_Desc1")
function AlertMessage_ShowAni()
  Panel_Alert_Message:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_MidHorizon.dds")
  local FadeMaskAni = Panel_Alert_Message:addTextureUVAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  local uvStartX = 0
  local uvStartY = 0
  FadeMaskAni:SetStartUV(uvStartX, uvStartY, 0)
  FadeMaskAni:SetEndUV(0.6, 0, 0)
  FadeMaskAni:SetStartUV(1, 0, 1)
  FadeMaskAni:SetEndUV(0.4, 0, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0.6, 1, 2)
  FadeMaskAni:SetStartUV(1, 1, 3)
  FadeMaskAni:SetEndUV(0.4, 1, 3)
  FadeMaskAni.IsChangeChild = true
end
function AlertMessage_HideAni()
  Panel_Alert_Message:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local closeAni = Panel_Alert_Message:addColorAnimation(0, 1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(UI_color.C_FFFFFFFF)
  closeAni:SetEndColor(UI_color.C_00FFFFFF)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
  closeAni:SetHideAtEnd(true)
  closeAni:SetDisableWhileAni(true)
end
function FGlobal_Show_AlertMessage(msg, showTime)
  PAGlobal_Alert_Message._showingSec = showTime
  Panel_Alert_Message:SetShow(false)
  PaGlobal_Radar_WarAlert(false)
  desc:SetText(msg)
  Panel_Alert_Message:SetPosX(getScreenSizeX() / 2 - Panel_Alert_Message:GetSizeX() / 2)
  Panel_Alert_Message:SetPosY(230)
  Panel_Alert_Message:SetShow(true, true)
end
local _time = 0
function AlertMessage_FrameUpdate_ForHide(deltaTime)
  if _time < PAGlobal_Alert_Message._showingSec then
    _time = _time + deltaTime
  elseif Panel_Alert_Message:GetShow() then
    Panel_Alert_Message:SetShow(false, false)
    _time = 0
  end
end
Panel_Alert_Message:RegisterUpdateFunc("AlertMessage_FrameUpdate_ForHide")

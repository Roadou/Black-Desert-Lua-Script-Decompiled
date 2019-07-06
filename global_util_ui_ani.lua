UIAni = {}
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AV = CppEnums.PA_UI_ALIGNVERTICAL
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
local UI_color = Defines.Color
function UIAni.closeAni(panel)
  panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local closeAni = panel:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(UI_color.C_FFFFFFFF)
  closeAni:SetEndColor(UI_color.C_00FFFFFF)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
  closeAni:SetHideAtEnd(true)
  closeAni:SetDisableWhileAni(true)
end
function UIAni.showAniScaleElastic(panel, params)
  _PA_ASSERT(nil ~= panel, "panel \235\167\164\234\176\156\235\179\128\236\136\152\235\138\148 \235\132\163\236\150\180 \236\163\188\236\133\148\236\149\188 \237\149\169\235\139\136\235\139\164!")
  if nil == params then
    params = {}
  end
  local startTime = params.startTime and params.startTime or 0
  local middleTime = params.middleTime and params.middleTime or 0.08
  local endTime = params.endTime and params.endTime or 0.15
  local startScale = params.startScale and params.startScale or 0.5
  local middleScale = params.middleScale and params.middleScale or 1.1
  local endScale = params.endScale and params.endScale or 1
  local scaleType = params.scaleType and params.scaleType or CppEnums.PAUI_SCALE_ANIM_TYPE.PAUI_ANIM_TYPE_SCALE_Y
  if startTime > middleTime then
    _PA_LOG("\236\157\180\236\158\172\236\164\128", "\236\158\152\235\170\187\235\144\156 middleTime\236\157\132 \236\132\164\236\160\149\237\150\136\236\138\181\235\139\136\235\139\164. middleTime\236\157\132 \234\176\149\236\160\156\235\161\156 \235\179\128\234\178\189\237\149\169\235\139\136\235\139\164.")
    middleTime = startTime + 0.08
  end
  if endTime < middleTime then
    _PA_LOG("\236\157\180\236\158\172\236\164\128", "\236\158\152\235\170\187\235\144\156 endTime\236\157\132 \236\132\164\236\160\149\237\150\136\236\138\181\235\139\136\235\139\164. endTime\236\157\132 \234\176\149\236\160\156\235\161\156 \235\179\128\234\178\189\237\149\169\235\139\136\235\139\164.")
    endTime = middleTime + 0.08
  end
  local animGrowing = panel:addScaleAnimation(startTime, middleTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  animGrowing:SetStartScale(startScale)
  animGrowing:SetEndScale(middleScale)
  animGrowing.AxisX = panel:GetSizeX() / 2
  animGrowing.AxisY = panel:GetSizeY() / 2
  animGrowing.ScaleType = scaleType
  animGrowing.IsChangeChild = true
  local animShrinking = panel:addScaleAnimation(middleTime, endTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  animShrinking:SetStartScale(middleScale)
  animShrinking:SetEndScale(endScale)
  animShrinking.AxisX = panel:GetSizeX() / 2
  animShrinking.AxisY = panel:GetSizeY() / 2
  animShrinking.ScaleType = scaleType
  animShrinking.IsChangeChild = true
end
function UIAni.TestFunc(panel, uvStX, uvStY, uvEndX, uvEndY)
  local getGuildMarkTexture = guildMark:getBaseTexture()
  getGuildMarkTexture:setUV(uvStX, uvStY, uvEndX, uvEndY)
  guildMark:SetTexturePreload(false)
end
function UIAni.fadeInSCR_MidOut(panel)
  panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_MidHorizon.dds")
  local FadeMaskAni = panel:addTextureUVAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0, 0)
  FadeMaskAni:SetEndUV(0.6, 0, 0)
  FadeMaskAni:SetStartUV(1, 0, 1)
  FadeMaskAni:SetEndUV(0.4, 0, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0.6, 1, 2)
  FadeMaskAni:SetStartUV(1, 1, 3)
  FadeMaskAni:SetEndUV(0.4, 1, 3)
  FadeMaskAni.IsChangeChild = true
end
function UIAni.fadeInSCR_Up(panel)
  panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toTop.dds")
  local FadeMaskAni = panel:addTextureUVAnimation(0, 0.75, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0.1, 0)
  FadeMaskAni:SetEndUV(0, 0.6, 0)
  FadeMaskAni:SetStartUV(1, 0.1, 1)
  FadeMaskAni:SetEndUV(1, 0.6, 1)
  FadeMaskAni:SetStartUV(0, 0.4, 2)
  FadeMaskAni:SetEndUV(0, 1, 2)
  FadeMaskAni:SetStartUV(1, 0.4, 3)
  FadeMaskAni:SetEndUV(1, 1, 3)
  panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo3 = panel:addColorAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo3:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo3.IsChangeChild = true
  local aniInfo8 = panel:addColorAnimation(0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo8:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetStartIntensity(3)
  aniInfo8:SetEndIntensity(1)
end
function UIAni.fadeInSCR_Right(panel)
  panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toRight.dds")
  local FadeMaskAni = panel:addTextureUVAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0.6, 0.1, 0)
  FadeMaskAni:SetEndUV(0.1, 0.1, 0)
  FadeMaskAni:SetStartUV(1, 1, 1)
  FadeMaskAni:SetEndUV(0.4, 1, 1)
  FadeMaskAni:SetStartUV(0.6, 1, 2)
  FadeMaskAni:SetEndUV(0.1, 1, 2)
  FadeMaskAni:SetStartUV(1, 1, 3)
  FadeMaskAni:SetEndUV(0.4, 1, 3)
  panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo3 = panel:addColorAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo3:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo3.IsChangeChild = true
  local aniInfo8 = panel:addColorAnimation(0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo8:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetStartIntensity(3)
  aniInfo8:SetEndIntensity(1)
end
function UIAni.fadeInSCR_Down(panel)
  panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toBottom.dds")
  local FadeMaskAni = panel:addTextureUVAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0.6, 0)
  FadeMaskAni:SetEndUV(0, 0.1, 0)
  FadeMaskAni:SetStartUV(1, 0.6, 1)
  FadeMaskAni:SetEndUV(1, 0.1, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0, 0.4, 2)
  FadeMaskAni:SetStartUV(1, 1, 3)
  FadeMaskAni:SetEndUV(0, 0.4, 3)
  panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo3 = panel:addColorAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo3:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo3.IsChangeChild = true
  local aniInfo8 = panel:addColorAnimation(0.15, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo8:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetStartIntensity(3)
  aniInfo8:SetEndIntensity(1)
end
function UIAni.fadeInSCR_Left(panel)
  panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toLeft.dds")
  local FadeMaskAni = panel:addTextureUVAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0, 0)
  FadeMaskAni:SetEndUV(0.6, 0, 0)
  FadeMaskAni:SetStartUV(0.4, 0, 1)
  FadeMaskAni:SetEndUV(1, 0, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0.6, 1, 2)
  FadeMaskAni:SetStartUV(0.4, 1, 3)
  FadeMaskAni:SetEndUV(1, 1, 3)
  panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo8 = panel:addColorAnimation(0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo8:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo8:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetStartIntensity(3)
  aniInfo8:SetEndIntensity(1)
  aniInfo3.IsChangeChild = true
end
function UIAni.fadeInSCR_Left_Clear(panel)
  panel:ChangeSpecialTextureInfoName("")
end
function UIAni.fadeInSCRWorldMap_Down(panel)
  local FadeMaskAni = panel:addTextureUVAnimation(0, 0.28, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0.6, 0)
  FadeMaskAni:SetEndUV(0, 0.1, 0)
  FadeMaskAni:SetStartUV(1, 0.6, 1)
  FadeMaskAni:SetEndUV(1, 0.1, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0, 0.4, 2)
  FadeMaskAni:SetStartUV(1, 1, 3)
  FadeMaskAni:SetEndUV(0, 0.4, 3)
  panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo3 = panel:addColorAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo3:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo3.IsChangeChild = true
  local aniInfo8 = panel:addColorAnimation(0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo8:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetStartIntensity(3)
  aniInfo8:SetEndIntensity(1)
end
function UIAni.fadeInSCRDialog_MidOut(panel)
  panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_MidHorizon.dds")
  local FadeMaskAni = panel:addTextureUVAnimation(0, 2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0, 0)
  FadeMaskAni:SetEndUV(0.6, 0, 0)
  FadeMaskAni:SetStartUV(1, 0, 1)
  FadeMaskAni:SetEndUV(0.4, 0, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0.6, 1, 2)
  FadeMaskAni:SetStartUV(1, 1, 3)
  FadeMaskAni:SetEndUV(0.4, 1, 3)
end
function UIAni.fadeInSCRDialog_Up(panel)
  panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toTop.dds")
  local FadeMaskAni = panel:addTextureUVAnimation(0, 0.85, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0.1, 0)
  FadeMaskAni:SetEndUV(0, 0.6, 0)
  FadeMaskAni:SetStartUV(1, 0.1, 1)
  FadeMaskAni:SetEndUV(1, 0.6, 1)
  FadeMaskAni:SetStartUV(0, 0.4, 2)
  FadeMaskAni:SetEndUV(0, 1, 2)
  FadeMaskAni:SetStartUV(1, 0.4, 3)
  FadeMaskAni:SetEndUV(1, 1, 3)
  panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo3 = panel:addColorAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo3:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo3.IsChangeChild = true
  local aniInfo8 = panel:addColorAnimation(0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo8:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetStartIntensity(3)
  aniInfo8:SetEndIntensity(1)
end
function UIAni.fadeInSCRDialog_Right(panel)
  panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toRight.dds")
  local FadeMaskAni = panel:addTextureUVAnimation(0, 0.36, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0.6, 0.1, 0)
  FadeMaskAni:SetEndUV(0.1, 0.1, 0)
  FadeMaskAni:SetStartUV(1, 1, 1)
  FadeMaskAni:SetEndUV(0.4, 1, 1)
  FadeMaskAni:SetStartUV(0.6, 1, 2)
  FadeMaskAni:SetEndUV(0.1, 1, 2)
  FadeMaskAni:SetStartUV(1, 1, 3)
  FadeMaskAni:SetEndUV(0.4, 1, 3)
  panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo3 = panel:addColorAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo3:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo3.IsChangeChild = true
  local aniInfo8 = panel:addColorAnimation(0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo8:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetStartIntensity(3)
  aniInfo8:SetEndIntensity(1)
end
function UIAni.fadeInSCRDialog_Down(panel)
  panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toBottom.dds")
  local FadeMaskAni = panel:addTextureUVAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0.6, 0)
  FadeMaskAni:SetEndUV(0, 0.1, 0)
  FadeMaskAni:SetStartUV(1, 0.6, 1)
  FadeMaskAni:SetEndUV(1, 0.1, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0, 0.4, 2)
  FadeMaskAni:SetStartUV(1, 1, 3)
  FadeMaskAni:SetEndUV(0, 0.4, 3)
  panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo3 = panel:addColorAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo3:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo3.IsChangeChild = true
end
function UIAni.fadeInSCRDialog_Left(panel)
  panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_Gradient_toLeft.dds")
  local FadeMaskAni = panel:addTextureUVAnimation(0, 0.36, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0, 0)
  FadeMaskAni:SetEndUV(0.6, 0, 0)
  FadeMaskAni:SetStartUV(0.4, 0, 1)
  FadeMaskAni:SetEndUV(1, 0, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0.6, 1, 2)
  FadeMaskAni:SetStartUV(0.4, 1, 3)
  FadeMaskAni:SetEndUV(1, 1, 3)
  panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo3 = panel:addColorAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo3:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo3.IsChangeChild = true
  local aniInfo8 = panel:addColorAnimation(0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo8:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetStartIntensity(3)
  aniInfo8:SetEndIntensity(1)
end
function UIAni.AlphaAnimation(toAlpha, control, startTime, EndTime)
  control:ResetVertexAni()
  local alphaAni = control:addColorAnimation(startTime, EndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  alphaAni:SetStartColorBySafe(PAUIColorType(control:GetAlpha() * 255, 255, 255, 255))
  alphaAni:SetEndColorBySafe(PAUIColorType(toAlpha * 255, 255, 255, 255))
  alphaAni.IsChangeChild = true
  return alphaAni
end
function UIAni.perFrameAlphaAnimation(toAlpha, control, rate)
  local newAlpha = control:GetAlpha()
  if newAlpha == toAlpha then
    return
  end
  if math.abs(toAlpha - newAlpha) < 0.01 then
    control:SetAlpha(toAlpha)
  else
    newAlpha = newAlpha + (toAlpha - newAlpha) * rate
    control:SetAlpha(newAlpha)
  end
  if newAlpha > 0 then
    control:SetShow(true)
  else
    control:SetShow(false)
  end
end
function UIAni.perFrameFontAlphaAnimation(toAlpha, control, rate)
  local newAlpha = control:GetFontAlpha()
  if newAlpha == toAlpha then
    return
  end
  if math.abs(toAlpha - newAlpha) < 0.01 then
    control:SetFontAlpha(toAlpha)
  else
    newAlpha = newAlpha + (toAlpha - newAlpha) * rate
    control:SetFontAlpha(newAlpha)
  end
  if newAlpha > 0 then
    control:SetShow(true)
  else
    control:SetShow(false)
  end
end
function IsAniUse()
  if true == _ContentsGroup_RenewUI_Dailog then
    return not Panel_Dialog_Main:GetShow()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    return not Panel_Npc_Dialog:GetShow()
  else
    return not Panel_Npc_Dialog_All:GetShow()
  end
end

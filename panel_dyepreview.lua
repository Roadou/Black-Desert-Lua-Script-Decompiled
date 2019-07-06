local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
Panel_DyePreview:SetShow(false)
Panel_DyePreview:setGlassBackground(true)
Panel_DyePreview:ActiveMouseEventEffect(true)
Panel_DyePreview:RegisterShowEventFunc(true, "Panel_DyePreview_ShowAni()")
Panel_DyePreview:RegisterShowEventFunc(false, "Panel_DyePreview_HideAni()")
local ui = {
  _btn_WinClose = UI.getChildControl(Panel_DyePreview, "Button_Win_Close"),
  _btn_Question = UI.getChildControl(Panel_DyePreview, "Button_Question"),
  _btn_Close = UI.getChildControl(Panel_DyePreview, "Button_Close"),
  _viewer = UI.getChildControl(Panel_DyePreview, "Static_Viewer")
}
function Panel_DyePreview_ShowAni()
  Panel_DyePreview:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_DyePreview, 0, 0.15)
  local aniInfo1 = Panel_DyePreview:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_DyePreview:GetSizeX() / 2
  aniInfo1.AxisY = Panel_DyePreview:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_DyePreview:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_DyePreview:GetSizeX() / 2
  aniInfo2.AxisY = Panel_DyePreview:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_DyePreview_HideAni()
  Panel_DyePreview:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_DyePreview, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end

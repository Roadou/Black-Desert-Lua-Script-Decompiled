local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
local _text_Msg = UI.getChildControl(Panel_ActionMessage, "MsgText")
Panel_ActionMessage:setFlushAble(false)
Panel_ActionMessage:RegisterShowEventFunc(true, "ActionMessageShowAni()")
Panel_ActionMessage:RegisterShowEventFunc(false, "ActionMessageHideAni()")
function ActionMessageShowAni()
  UIAni.fadeInSCR_Down(Panel_ActionMessage)
  local aniInfo1 = Panel_ActionMessage:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_ActionMessage:GetSizeX() / 2
  aniInfo1.AxisY = Panel_ActionMessage:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_ActionMessage:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_ActionMessage:GetSizeX() / 2
  aniInfo2.AxisY = Panel_ActionMessage:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function ActionMessageHideAni()
  Panel_ActionMessage:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_ActionMessage:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
function ActionMessageShowByObservertory()
  if false == _ContentsGroup_RenewUI_WatchMode then
    if Panel_WatchingMode:GetShow() then
      return
    end
    _text_Msg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ACTIONNAKMESSAGE"))
    Panel_ActionMessage:SetShow(true, true)
  end
end
function ActionMessageHide()
  Panel_ActionMessage:SetShow(false, true)
end
function ActionMessagePanel_Resize()
  Panel_ActionMessage:SetPosX((getScreenSizeX() - Panel_ActionMessage:GetSizeX()) * 0.5)
end
ActionMessagePanel_Resize()
ActionChartEventBindFunction(305, ActionMessageShowByObservertory)
ActionChartEventBindFunction(306, ActionMessageHide)

local _panel = Panel_WebControl_Renew
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
_panel:SetShow(false, false)
_panel:ActiveMouseEventEffect(true)
_panel:setGlassBackground(true)
_panel:RegisterShowEventFunc(true, "Panel_WebControl_Renew_ShowAni()")
_panel:RegisterShowEventFunc(false, "Panel_WebControl_Renew_HideAni()")
function Panel_WebControl_Renew_ShowAni()
  UIAni.fadeInSCR_Down(_panel)
  local aniInfo1 = _panel:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = _panel:GetSizeX() / 2
  aniInfo1.AxisY = _panel:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = _panel:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = _panel:GetSizeX() / 2
  aniInfo2.AxisY = _panel:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_WebControl_Renew_HideAni()
  audioPostEvent_SystemUi(13, 5)
  _panel:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, _panel, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local WebControl = {
  _ui = {
    txt_titleBG = UI.getChildControl(_panel, "StaticText_TitleBg"),
    stc_botBG = UI.getChildControl(_panel, "Static_BottomBg")
  }
}
local self = WebControl
function FromClient_luaLoadComplete_WebControl()
  WebControl:Initialize()
end
function WebControl:Initialize()
  self._ui.webUI = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, _panel, "WebControl_WebUI")
  self._ui.webUI:SetPosX(0)
  self._ui.webUI:SetPosY(110)
  self._ui.webUI:SetSize(_panel:GetSizeX(), _panel:GetSizeY() - 200)
  self._ui.webUI:ResetUrl()
  PaGlobal_registerPanelOnBlackBackground(_panel)
  Panel_WebControl_Renew:registerPadEvent(__eConsoleUIPadEvent_RStickUp, "HandleEventRS_WebControl_InputKeyEvent(\"RS_UP\")")
  Panel_WebControl_Renew:registerPadEvent(__eConsoleUIPadEvent_RStickDown, "HandleEventRS_WebControl_InputKeyEvent(\"RS_DOWN\")")
  Panel_WebControl_Renew:registerPadEvent(__eConsoleUIPadEvent_RStickLeft, "HandleEventRS_WebControl_InputKeyEvent(\"RS_LEFT\")")
  Panel_WebControl_Renew:registerPadEvent(__eConsoleUIPadEvent_RStickRight, "HandleEventRS_WebControl_InputKeyEvent(\"RS_RIGHT\")")
end
function PaGlobalFunc_WebControl_Open(url)
  _panel:SetShow(true)
  self._ui.webUI:SetUrl(self._ui.webUI:GetSizeX(), self._ui.webUI:GetSizeY(), url, false, true)
end
function PaGlobalFunc_WebControl_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_WebControl_Close()
  _panel:SetShow(false)
  self._ui.webUI:ResetUrl()
end
function HandleEventRS_WebControl_InputKeyEvent(key)
  if nil == Panel_WebControl_Renew then
    return
  end
  if false == Panel_WebControl_Renew:GetShow() then
    return
  end
  if nil == WebControl._ui.webUI then
    return
  end
  WebControl._ui.webUI:TriggerEvent("FromClient_GamePadInputForWebBanner", key)
end
FromClient_luaLoadComplete_WebControl()

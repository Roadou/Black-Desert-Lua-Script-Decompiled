Panel_Window_BlackDesertLab:SetShow(false)
Panel_Window_BlackDesertLab:setMaskingChild(true)
Panel_Window_BlackDesertLab:setGlassBackground(true)
Panel_Window_BlackDesertLab:SetDragAll(true)
Panel_Window_BlackDesertLab:RegisterShowEventFunc(true, "PaGlobal_BlackDesertLab_ShowAni()")
Panel_Window_BlackDesertLab:RegisterShowEventFunc(false, "PaGlobal_BlackDesertLab_HideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local serviceType = CppEnums.GameServiceType
local PaGlobal_BlackDesertLab = {
  _ui = {
    _close = UI.getChildControl(Panel_Window_BlackDesertLab, "Button_Win_Close"),
    _web = nil
  },
  _url = ""
}
function PaGlobal_BlackDesertLab_ShowAni()
  UIAni.fadeInSCR_Down(Panel_Window_BlackDesertLab)
  local aniInfo1 = Panel_Window_BlackDesertLab:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.2)
  aniInfo1.AxisX = Panel_Window_BlackDesertLab:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_BlackDesertLab:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Window_BlackDesertLab:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.2)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_BlackDesertLab:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_BlackDesertLab:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function PaGlobal_BlackDesertLab_HideAni()
  Panel_Window_BlackDesertLab:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_Window_BlackDesertLab, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
function PaGlobal_BlackDesertLab:Init()
  self._ui._close:addInputEvent("Mouse_LUp", "PaGlobal_BlackDesertLab_Close()")
  self._ui._web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Window_BlackDesertLab, "WebControl_Content1")
  self._ui._web:SetShow(true)
  self._ui._web:SetSize(604, 400)
  self._ui._web:SetPosX(8)
  self._ui._web:SetPosY(64)
  self._ui._web:ResetUrl()
  if serviceType.eGameServiceType_DEV == getGameServiceType() then
    self._url = "http://dev-account.global-lab.playblackdesert.com/GlobalLabRegister"
  elseif serviceType.eGameServiceType_KOR_ALPHA == getGameServiceType() or serviceType.eGameServiceType_JPN_ALPHA == getGameServiceType() or serviceType.eGameServiceType_NA_ALPHA == getGameServiceType() or serviceType.eGameServiceType_TW_ALPHA == getGameServiceType() or serviceType.eGameServiceType_SA_ALPHA == getGameServiceType() or serviceType.eGameServiceType_TH_ALPHA == getGameServiceType() or serviceType.eGameServiceType_ID_ALPHA == getGameServiceType() or serviceType.eGameServiceType_TR_ALPHA == getGameServiceType() then
    self._url = "http://alpha-account.global-lab.playblackdesert.com/GlobalLabRegister"
  elseif serviceType.eGameServiceType_KOR_REAL == getGameServiceType() or serviceType.eGameServiceType_JPN_REAL == getGameServiceType() or serviceType.eGameServiceType_NA_REAL == getGameServiceType() or serviceType.eGameServiceType_TW_REAL == getGameServiceType() or serviceType.eGameServiceType_SA_REAL == getGameServiceType() or serviceType.eGameServiceType_TH_REAL == getGameServiceType() or serviceType.eGameServiceType_ID_REAL == getGameServiceType() or serviceType.eGameServiceType_TR_REAL == getGameServiceType() then
    self._url = "https://account.global-lab.playblackdesert.com/GlobalLabRegister"
  end
end
function PaGlobal_BlackDesertLab_Show()
  local self = PaGlobal_BlackDesertLab
  if "" == self._url then
    return
  end
  FGlobal_SetCandidate()
  self._ui._web:SetUrl(604, 400, self._url, false, true)
  self._ui._web:SetIME(true)
  Panel_Window_BlackDesertLab:SetShow(true, true)
  Panel_Window_BlackDesertLab:SetPosX(getScreenSizeX() / 2 - Panel_Window_BlackDesertLab:GetSizeX() / 2)
  Panel_Window_BlackDesertLab:SetPosY(getScreenSizeY() / 2 - Panel_Window_BlackDesertLab:GetSizeY() / 2)
end
function PaGlobal_BlackDesertLab_Close()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  Panel_Window_BlackDesertLab:SetShow(false, false)
  FGlobal_ClearCandidate()
  PaGlobal_BlackDesertLab._ui._web:ResetUrl()
  ClearFocusEdit()
end
function PaGlobal_BlackDesertLab_Init()
  PaGlobal_BlackDesertLab:Init()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_BlackDesertLab_Init")

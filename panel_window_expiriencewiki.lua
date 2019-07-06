local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_Window_ExpirienceWiki:SetShow(false, false)
Panel_Window_ExpirienceWiki:ActiveMouseEventEffect(true)
Panel_Window_ExpirienceWiki:setGlassBackground(true)
Panel_Window_ExpirienceWiki:RegisterShowEventFunc(true, "Panel_Window_ExpirienceWiki_ShowAni()")
Panel_Window_ExpirienceWiki:RegisterShowEventFunc(false, "Panel_Window_ExpirienceWiki_HideAni()")
function Panel_Window_ExpirienceWiki_ShowAni()
  UIAni.fadeInSCR_Down(Panel_Window_ExpirienceWiki)
  local aniInfo1 = Panel_Window_ExpirienceWiki:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_Window_ExpirienceWiki:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_ExpirienceWiki:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Window_ExpirienceWiki:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_ExpirienceWiki:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_ExpirienceWiki:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_Window_ExpirienceWiki_HideAni()
  audioPostEvent_SystemUi(13, 5)
  Panel_Window_ExpirienceWiki:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_Window_ExpirienceWiki, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local ExpirienceWiki = {
  _ui = {
    _txt_titleBar = UI.getChildControl(Panel_Window_ExpirienceWiki, "StaticText_Title"),
    _btn_close = UI.getChildControl(Panel_Window_ExpirienceWiki, "Button_Close"),
    _web_ExpirienceWiki = nil
  },
  _sizeX = nil,
  _sizeY = nil,
  _panelSizeX = nil,
  _panelSizeY = nil,
  _titleBarSizeX = nil
}
function ExpirienceWiki:Initialize()
  self._ui._web_ExpirienceWiki = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Window_ExpirienceWiki, "WebControl_ExpirienceWiki")
  self._ui._web_ExpirienceWiki:SetShow(true)
  self._ui._web_ExpirienceWiki:SetHorizonCenter()
  self._ui._web_ExpirienceWiki:SetPosY(52)
  self._ui._web_ExpirienceWiki:SetSize(1100, 630)
  self._ui._web_ExpirienceWiki:ResetUrl()
  self._ui._web_ExpirienceWiki:ComputePos()
  self._ui._btn_close:addInputEvent("Mouse_LUp", "PaGlobal_ExpirienceWiki_Close()")
end
function ExpirienceWiki:open()
  if not _ContentsGroup_ExpirienceWiki then
    return
  end
  audioPostEvent_SystemUi(13, 6)
  Panel_Window_ExpirienceWiki:SetShow(true, true)
  FGlobal_SetCandidate()
  local UiConvertable = CppEnums.ClientSceneState.eUIConvertableType_showTime
  if isSceneState == CppEnums.ClientSceneState.eClientSceneStateType_Customization then
    UiConvertable = CppEnums.UIConvertableType.eUIConvertableType_none
  elseif isSceneState == CppEnums.ClientSceneState.eClientSceneStateType_InGameCustomization then
    UiConvertable = CppEnums.UIConvertableType.eUIConvertableType_none
  elseif isSceneState == CppEnums.ClientSceneState.eClientSceneStateType_InGame then
    UiConvertable = CppEnums.UIConvertableType.eUIConvertableType_showTime
  end
  Panel_Window_ExpirienceWiki:setUiConvertableType(UiConvertable)
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local url = PaGlobal_URL_Check(worldNo)
  local cryptKey = getSelfPlayer():get():getWebAuthenticKeyCryptString()
  local classType = getSelfPlayer():getClassType()
  local isGm = ToClient_SelfPlayerIsGM()
  local userNickName = getSelfPlayer():getUserNickname()
  local userNo = getSelfPlayer():get():getUserNo()
  local langType = getGameServiceResType()
  url = url .. "/InGameBoard/Home?userNo=" .. tostring(userNo) .. "&userNickname=" .. tostring(userNickName) .. "&certKey=" .. tostring(cryptKey) .. "&classType=" .. tostring(classType) .. "&isGm=" .. tostring(isGm) .. "&langType=" .. tostring(langType)
  self._ui._web_ExpirienceWiki:SetUrl(1100, 630, url, false, true)
  self._ui._web_ExpirienceWiki:SetIME(true)
  Panel_Window_ExpirienceWiki:SetPosX(getScreenSizeX() / 2 - Panel_Window_ExpirienceWiki:GetSizeX() / 2)
  Panel_Window_ExpirienceWiki:SetPosY(getScreenSizeY() / 2 - Panel_Window_ExpirienceWiki:GetSizeY() / 2)
end
function PaGlobal_ExpirienceWiki_Open()
  ExpirienceWiki:open()
end
function ExpirienceWiki:close()
  audioPostEvent_SystemUi(13, 5)
  FGlobal_ClearCandidate()
  self._ui._web_ExpirienceWiki:ResetUrl()
  Panel_Window_ExpirienceWiki:SetShow(false, false)
end
function PaGlobal_ExpirienceWiki_Close()
  ExpirienceWiki:close()
end
function PaGlobal_ExpirienceWiki_Resize()
  local self = ExpirienceWiki
  local screenSizeX = getScreenSizeX()
  if screenSizeX < 1900 then
    self._sizeX = 870
    self._sizeY = 630
    self._panelSizeX = 900
    self._panelSizeY = 715
    self._titleBarSizeX = 890
  elseif screenSizeX >= 1900 and screenSizeX < 3800 then
    self._sizeX = 1305
    self._sizeY = 945
    self._panelSizeX = 1335
    self._panelSizeY = 1030
    self._titleBarSizeX = 1325
  else
    self._sizeX = 1740
    self._sizeY = 1260
    self._panelSizeX = 1770
    self._panelSizeY = 1345
    self._titleBarSizeX = 1760
  end
  Panel_Window_ExpirienceWiki:SetSize(self._panelSizeX, self._panelSizeY)
  self._ui._titleBar:SetSize(self._titleBarSizeX, self._ui._titleBar:GetSizeY())
  self._ui._web_ExpirienceWiki:SetPosX(15)
  self._ui._web_ExpirienceWiki:SetPosY(70)
  self._ui._web_ExpirienceWiki:SetSize(self._sizeX, self._sizeY)
end
ExpirienceWiki:Initialize()

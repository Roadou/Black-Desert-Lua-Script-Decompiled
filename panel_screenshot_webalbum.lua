local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_ScreenShotAlbum:SetShow(false, false)
Panel_ScreenShotAlbum:ActiveMouseEventEffect(true)
Panel_ScreenShotAlbum:setGlassBackground(true)
Panel_ScreenShotAlbum:RegisterShowEventFunc(true, "Panel_ScreenShotAlbum_ShowAni()")
Panel_ScreenShotAlbum:RegisterShowEventFunc(false, "Panel_ScreenShotAlbum_HideAni()")
function Panel_ScreenShotAlbum_ShowAni()
  UIAni.fadeInSCR_Down(Panel_ScreenShotAlbum)
  local aniInfo1 = Panel_ScreenShotAlbum:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_ScreenShotAlbum:GetSizeX() / 2
  aniInfo1.AxisY = Panel_ScreenShotAlbum:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_ScreenShotAlbum:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_ScreenShotAlbum:GetSizeX() / 2
  aniInfo2.AxisY = Panel_ScreenShotAlbum:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_ScreenShotAlbum_HideAni()
  Panel_ScreenShotAlbum:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_ScreenShotAlbum, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local _btn_Close = UI.getChildControl(Panel_ScreenShotAlbum, "Button_Close")
_btn_Close:addInputEvent("Mouse_LUp", "ScreenshotAlbum_Close()")
local _screenshotAlbumWeb
function Panel_ScreenShotAlbum_Initialize()
  _screenshotAlbumWeb = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_ScreenShotAlbum, "WebControl_ScreenshotAlbum")
  _screenshotAlbumWeb:SetShow(true)
  _screenshotAlbumWeb:SetPosX(15)
  _screenshotAlbumWeb:SetPosY(70)
  _screenshotAlbumWeb:SetSize(875, 635)
  _screenshotAlbumWeb:ResetUrl()
end
Panel_ScreenShotAlbum_Initialize()
function ScreenshotAlbum_Open()
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  Panel_ScreenShotAlbum:SetShow(true, true)
  FGlobal_SetCandidate()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local url = PaGlobal_URL_Check(worldNo)
  if nil == getSelfPlayer() then
    return
  end
  local userNo = getSelfPlayer():get():getUserNo()
  local cryptKey = getSelfPlayer():get():getWebAuthenticKeyCryptString()
  local classType = getSelfPlayer():getClassType()
  local isGm = ToClient_SelfPlayerIsGM()
  url = url .. "/ScreenShot?userNo=" .. tostring(userNo) .. "&certKey=" .. tostring(cryptKey) .. "&classType=" .. tostring(classType) .. "&isGm=" .. tostring(isGm)
  _screenshotAlbumWeb:SetUrl(875, 635, url, false, true)
  _screenshotAlbumWeb:SetIME(true)
  Panel_ScreenShotAlbum:SetPosX(getScreenSizeX() / 2 - Panel_ScreenShotAlbum:GetSizeX() / 2, getScreenSizeY() / 2 - Panel_ScreenShotAlbum:GetSizeY() / 2)
end
function ScreenshotAlbum_Close()
  FGlobal_ClearCandidate()
  _screenshotAlbumWeb:ResetUrl()
  Panel_ScreenShotAlbum:SetShow(false, false)
end
function FGlobal_ScreenshotAlbum_Show(isCTMode)
  ScreenshotAlbum_Open(isCTMode)
end
function FGlobal_ScreenshotAlbum_ShowByScreenShotFrame()
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  Panel_ScreenShotAlbum:SetShow(true, true)
end
function FGlobal_ScreenshotAlbum_Close()
  Panel_ScreenShotAlbum:SetShow(false, false)
end

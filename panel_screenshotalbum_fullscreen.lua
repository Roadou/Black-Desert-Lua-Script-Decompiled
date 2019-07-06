local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_ScreenShotAlbum_FullScreen:SetShow(false, false)
Panel_ScreenShotAlbum_FullScreen:ActiveMouseEventEffect(true)
Panel_ScreenShotAlbum_FullScreen:setGlassBackground(true)
Panel_ScreenShotAlbum_FullScreen:RegisterShowEventFunc(true, "Panel_ScreenShotAlbum_FullScreen_ShowAni()")
Panel_ScreenShotAlbum_FullScreen:RegisterShowEventFunc(false, "Panel_ScreenShotAlbum_FullScreen_HideAni()")
function Panel_ScreenShotAlbum_FullScreen_ShowAni()
  UIAni.fadeInSCR_Down(Panel_ScreenShotAlbum_FullScreen)
  local aniInfo1 = Panel_ScreenShotAlbum_FullScreen:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_ScreenShotAlbum_FullScreen:GetSizeX() / 2
  aniInfo1.AxisY = Panel_ScreenShotAlbum_FullScreen:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_ScreenShotAlbum_FullScreen:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_ScreenShotAlbum_FullScreen:GetSizeX() / 2
  aniInfo2.AxisY = Panel_ScreenShotAlbum_FullScreen:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_ScreenShotAlbum_FullScreen_HideAni()
  Panel_ScreenShotAlbum_FullScreen:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_ScreenShotAlbum_FullScreen, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local titleBar = UI.getChildControl(Panel_ScreenShotAlbum_FullScreen, "StaticText_Title")
local _btn_Close = UI.getChildControl(Panel_ScreenShotAlbum_FullScreen, "Button_Close")
_btn_Close:addInputEvent("Mouse_LUp", "ScreenshotAlbum_FullScreen_Close()")
local _screenshotAlbumWeb
function Panel_ScreenShotAlbum_FullScreen_Initialize()
  _screenshotAlbumWeb = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_ScreenShotAlbum_FullScreen, "WebControl_ScreenshotAlbum")
  _screenshotAlbumWeb:SetShow(true)
  _screenshotAlbumWeb:SetSize(875, 635)
  _screenshotAlbumWeb:ResetUrl()
end
Panel_ScreenShotAlbum_FullScreen_Initialize()
function ScreenshotAlbum_FullScreen_Open(addUrl)
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  Panel_ScreenShotAlbum_FullScreen:SetShow(true, true)
  FGlobal_SetCandidate()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local url = PaGlobal_URL_Check(worldNo)
  url = url .. "/ScreenShot" .. addUrl
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_ScreenShotAlbum_FullScreen:SetSize(scrX, scrY)
  Panel_ScreenShotAlbum_FullScreen:SetPosX(0)
  Panel_ScreenShotAlbum_FullScreen:SetPosY(0)
  _screenshotAlbumWeb:SetSize(scrX - 30, scrY - 70)
  _screenshotAlbumWeb:SetPosX(15)
  _screenshotAlbumWeb:SetPosY(55)
  _screenshotAlbumWeb:SetUrl(scrX - 30, scrY - 70, url, false, true)
  _screenshotAlbumWeb:SetIME(true)
  titleBar:SetSize(scrX - 13, titleBar:GetSizeY())
  titleBar:ComputePos()
end
function ScreenshotAlbum_FullScreen_Close()
  FGlobal_ClearCandidate()
  _screenshotAlbumWeb:ResetUrl()
  Panel_ScreenShotAlbum_FullScreen:SetShow(false, false)
  FGlobal_ScreenshotAlbum_ShowByScreenShotFrame()
end
function FGlobal_ScreenShotAlbumOpen_FullScreen(url)
  FGlobal_ScreenshotAlbum_Close()
  ScreenshotAlbum_FullScreen_Open(url)
end

Panel_LogoXbox:SetShow(true, false)
Panel_LogoXbox:SetOffsetIgnorePanel(true)
local backGround = UI.getChildControl(Panel_LogoXbox, "Static_BackGround")
local button_Xbox = UI.getChildControl(Panel_LogoXbox, "Button_XboxPressA")
local txt_keyGuideA = UI.getChildControl(button_Xbox, "StaticText_A")
local txt_VersionInfo = UI.getChildControl(Panel_LogoXbox, "StaticText_VersionInfo")
local txt_VersionInfo2 = UI.getChildControl(Panel_LogoXbox, "StaticText_VersionInfo2")
local txt_betaWarning = UI.getChildControl(Panel_LogoXbox, "StaticText_BetaWarning")
if nil ~= txt_betaWarning then
  txt_betaWarning:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_betaWarning:SetText(txt_betaWarning:GetText())
  txt_betaWarning:SetShow(false)
end
function obt_info()
  if true == _ContentsGroup_XB_Obt then
    txt_betaWarning:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    txt_betaWarning:SetText(txt_betaWarning:GetText())
    txt_betaWarning:SetShow(true)
    txt_VersionInfo:SetShow(true)
    txt_VersionInfo2:SetShow(true)
  else
    txt_VersionInfo:SetShow(false)
    txt_betaWarning:SetShow(false)
    txt_VersionInfo2:SetShow(false)
  end
end
obt_info()
local stc_webBG = UI.getChildControl(Panel_LogoXbox, "Static_WebBG")
local web_movie
local _initialized = false
local _movieIsPlaying = false
function Panel_LogoXBox_Init()
  ToClient_setIsShowChattingViewer(true)
  Panel_LogoXbox:SetPosX(0)
  Panel_LogoXbox:SetPosY(0)
  if true == _initialized then
    return
  end
  screenX = getOriginScreenSizeX()
  screenY = getOriginScreenSizeY()
  Panel_LogoXbox:SetSize(screenX, screenY)
  Panel_LogoXbox:ComputePos()
  backGround:SetSize(screenX, screenY)
  backGround:SetShow(true)
  backGround:ComputePos()
  button_Xbox:SetShow(true)
  button_Xbox:ComputePos()
  if nil ~= txt_VersionInfo then
    txt_VersionInfo:ComputePos()
  end
  if nil ~= txt_betaWarning then
    txt_betaWarning:ComputePos()
    if true == _ContentsGroup_XB_Obt then
      txt_VersionInfo:SetPosY(txt_betaWarning:GetPosY() - 40)
      txt_VersionInfo:SetPosX(30)
      txt_VersionInfo:SetShow(true)
      txt_VersionInfo2:SetShow(true)
    end
  end
  stc_webBG:SetSize(screenX, screenY)
  stc_webBG:SetPosX(0)
  stc_webBG:SetPosY(0)
  _initialized = true
end
function Panel_LogoXbox_InitWeb()
  Panel_LogoXBox_Init()
  if nil == web_movie then
    web_movie = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, stc_webBG, "WebControl_BGMovie")
  end
  local uiScale = getGlobalScale()
  local sizeX = getResolutionSizeX()
  local sizeY = getResolutionSizeY()
  sizeX = sizeX / uiScale
  sizeY = sizeY / uiScale
  local movieSizeX = sizeX
  local movieSizeY = sizeX * 1080 / 1920
  local posX = 0
  local posY = 0
  if sizeY >= movieSizeY then
    posY = (sizeY - movieSizeY) / 2
  else
    movieSizeX = sizeY * 1920 / 1080
    movieSizeY = sizeY
    posX = (sizeX - movieSizeX) / 2
  end
  local marginX = movieSizeX * 0.013
  local marginY = movieSizeY * 0.013
  web_movie:SetPosX(posX - marginX / 2)
  web_movie:SetPosY(posY - marginY / 2)
  web_movie:SetSize(movieSizeX + marginX, movieSizeY + marginY)
  web_movie:SetUrl(1920, 1080, "coui://UI_Data/UI_Html/LogoXBox_Movie.html")
  registerEvent("ToClient_EndGuideMovie", "FromClient_LogoXBox_OnMovieEvent")
end
function FromClient_LogoXBox_OnMovieEvent(param)
  _PA_LOG("\235\176\149\235\178\148\236\164\128", "FromClient_LogoXBox_OnMovieEvent param : " .. param)
  if 1 == param then
    if nil ~= web_movie then
      web_movie:TriggerEvent("PlayMovie", "")
      _movieIsPlaying = true
    end
  elseif 2 == param then
    web_movie:SetShow(false)
  end
end
function Panel_LogoXbox_PressA()
  web_movie:SetShow(false)
  _AudioPostEvent_SystemUiForXBOX(50, 8)
  if true == ToClient_isPS4() then
    ToClient_PressAnyKeyPs4()
  else
    ToClient_ActiveProcessXbox()
  end
end
function Panel_LogoXbox_UpdatePerFrame(deltaTime)
end
Panel_LogoXbox:registerPadEvent(__eConsoleUIPadEvent_Up_A, "Panel_LogoXbox_PressA()")
button_Xbox:addInputEvent("Mouse_LUp", "Panel_LogoXbox_PressA()")
registerEvent("FromClient_luaLoadCompleteLateUdpate", "Panel_LogoXbox_InitWeb")

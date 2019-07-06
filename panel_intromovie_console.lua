Panel_IntroMovie:SetShow(false, false)
Panel_IntroMovie:SetOffsetIgnorePanel(true)
local updateTime = 0
local static_IntroMovie
local IM = CppEnums.EProcessorInputMode
isIntroMoviePlaying = false
local introMoviePlayTime = 20
function InitIntroMoviePanel()
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return
  end
  local selfPlayerLevel = selfPlayerWrapper:get():getLevel()
  if 1 == selfPlayerLevel and false == isSwapCharacter() and false == selfPlayerWrapper:isInstancePlayer() and static_IntroMovie == nil then
    ShowableFirstExperience(false)
    Panel_IntroMovie:SetShow(true, false)
    local sizeX = getScreenSizeX()
    local sizeY = getScreenSizeY()
    local movieSizeX = sizeX
    local movieSizeY = sizeX * 9 / 16
    if sizeY < movieSizeY then
      movieSizeX = sizeY * 16 / 9
      movieSizeY = sizeY
    end
    Panel_IntroMovie:SetPosX(0)
    Panel_IntroMovie:SetPosY(0)
    Panel_IntroMovie:SetSize(getOriginScreenSizeX(), getOriginScreenSizeY())
    static_IntroMovie = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_IntroMovie, "WebControl_Movie")
    static_IntroMovie:SetIgnore(false)
    static_IntroMovie:SetPosX((getOriginScreenSizeX() - movieSizeX) / 2)
    static_IntroMovie:SetPosY((getOriginScreenSizeY() - movieSizeY) / 2)
    static_IntroMovie:SetSize(movieSizeX, movieSizeY)
    static_IntroMovie:SetUrl(1280, 720, "coui://UI_Data/UI_Html/Intro_Movie.html")
    isIntroMoviePlaying = true
    setMoviePlayMode(true)
  end
  introMoviePlayTime = 28
end
function SetMovieSize()
  if static_IntroMovie == nil then
    return
  end
  local sizeX = getScreenSizeX()
  local sizeY = getScreenSizeY()
  local movieSizeX = sizeX
  local movieSizeY = sizeX * 9 / 16
  if sizeY < movieSizeY then
    movieSizeX = sizeY * 16 / 9
    movieSizeY = sizeY
  end
  Panel_IntroMovie:SetPosX(0)
  Panel_IntroMovie:SetPosY(0)
  Panel_IntroMovie:SetSize(sizeX, sizeY)
  static_IntroMovie:SetIgnore(false)
  static_IntroMovie:SetPosX((getOriginScreenSizeX() - movieSizeX) / 2)
  static_IntroMovie:SetPosY((getOriginScreenSizeY() - movieSizeY) / 2)
  static_IntroMovie:SetSize(movieSizeX, movieSizeY)
  isIntroMoviePlaying = true
end
function CloseIntroMovie()
  if static_IntroMovie ~= nil then
    static_IntroMovie:TriggerEvent("StopMovie", "")
    static_IntroMovie:ResetUrl()
    static_IntroMovie:SetShow(false)
    static_IntroMovie = nil
  end
  Panel_IntroMovie:SetShow(false, false)
  isIntroMoviePlaying = false
  SetUIMode(Defines.UIMode.eUIMode_Default)
  setMoviePlayMode(false)
  ShowableFirstExperience(true)
  PaGlobal_TutorialManager:handleCloseIntroMovie()
end
function ShowIntroMovie()
  static_IntroMovie:TriggerEvent("PlayMovie", "coui://UI_Movie/Intro_movieClip.webm")
  setMoviePlayMode(true)
end
function ToClient_EndIntroMovie(param)
  if param == 1 then
    ShowIntroMovie()
  elseif param == 2 and Panel_IntroMovie:IsShow() then
    setMoviePlayMode(false)
    toClient_FadeIn(1)
    CloseIntroMovie()
  end
end
registerEvent("FromClient_luaLoadCompleteLateUdpate", "InitIntroMoviePanel")
registerEvent("ToClient_EndGuideMovie", "ToClient_EndIntroMovie")
registerEvent("onScreenResize", "SetMovieSize")

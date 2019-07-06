Panel_IntroMovie:SetShow(false, false)
local updateTime = 0
local static_IntroMovie
local IM = CppEnums.EProcessorInputMode
isIntroMoviePlaying = false
local introMoviePlayTime = 20
function InitIntroMoviePanel()
  local uiScale = getGlobalScale()
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return
  end
  local selfPlayerLevel = selfPlayerWrapper:get():getLevel()
  if 1 == selfPlayerLevel and false == isSwapCharacter() and false == selfPlayerWrapper:isInstancePlayer() and static_IntroMovie == nil then
    ToClient_SetFalseCharacterViewMode()
    ShowableFirstExperience(false)
    Panel_IntroMovie:SetShow(true, false)
    local sizeX = getResolutionSizeX()
    local sizeY = getResolutionSizeY()
    sizeX = sizeX / uiScale
    sizeY = sizeY / uiScale
    local movieSizeX = sizeX
    local movieSizeY = sizeX * 9 / 16
    local posX = 0
    local posY = 0
    if sizeY >= movieSizeY then
      posY = (sizeY - movieSizeY) / 2
    else
      movieSizeX = sizeY * 16 / 9
      movieSizeY = sizeY
      posX = (sizeX - movieSizeX) / 2
    end
    Panel_IntroMovie:SetPosX(0)
    Panel_IntroMovie:SetPosY(0)
    Panel_IntroMovie:SetSize(sizeX, sizeY)
    static_IntroMovie = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_IntroMovie, "WebControl_Movie")
    static_IntroMovie:SetIgnore(false)
    static_IntroMovie:SetPosX(posX)
    static_IntroMovie:SetPosY(posY)
    static_IntroMovie:SetSize(movieSizeX, movieSizeY)
    static_IntroMovie:SetUrl(1280, 720, "coui://UI_Data/UI_Html/Intro_Movie.html")
    isIntroMoviePlaying = true
    setMoviePlayMode(true)
  end
  if isGameTypeKorea() then
    introMoviePlayTime = 60
    if _ContentsGroup_MainQuestRenewal then
      introMoviePlayTime = 28
    end
  elseif isGameTypeJapan() then
    introMoviePlayTime = 60
  elseif isGameTypeEnglish() then
    introMoviePlayTime = 125
  elseif isGameTypeRussia() then
    introMoviePlayTime = 60
  elseif isGameTypeTaiwan() then
    introMoviePlayTime = 125
  elseif ToClient_isConsole() then
    introMoviePlayTime = 28
  else
    introMoviePlayTime = 60
  end
end
function SetMovieSize()
  local uiScale = getGlobalScale()
  if static_IntroMovie == nil then
    return
  end
  local sizeX = getResolutionSizeX()
  local sizeY = getResolutionSizeY()
  sizeX = sizeX / uiScale
  sizeY = sizeY / uiScale
  local movieSizeX = sizeX
  local movieSizeY = sizeX * 9 / 16
  local posX = 0
  local posY = 0
  if sizeY >= movieSizeY then
    posY = (sizeY - movieSizeY) / 2
  else
    movieSizeX = sizeY * 16 / 9
    movieSizeY = sizeY
    posX = (sizeX - movieSizeX) / 2
  end
  Panel_IntroMovie:SetPosX(0)
  Panel_IntroMovie:SetPosY(0)
  Panel_IntroMovie:SetSize(sizeX, sizeY)
  static_IntroMovie:SetIgnore(false)
  static_IntroMovie:SetPosX(posX)
  static_IntroMovie:SetPosY(posY)
  static_IntroMovie:SetSize(movieSizeX, movieSizeY)
  isIntroMoviePlaying = true
end
function CloseIntroMovie()
  if static_IntroMovie ~= nil then
    static_IntroMovie:TriggerEvent("StopMovie", "")
    static_IntroMovie = nil
    unregisterEvent("ToClient_EndGuideMovie", "ToClient_EndIntroMovie")
  end
  Panel_IntroMovie:SetShow(false, false)
  isIntroMoviePlaying = false
  SetUIMode(Defines.UIMode.eUIMode_Default)
  setMoviePlayMode(false)
  ShowableFirstExperience(true)
  PaGlobal_TutorialManager:handleCloseIntroMovie()
end
function ShowIntroMovie()
  if nil == static_IntroMovie then
    return
  end
  if true == _ContentsGroup_MainQuestRenewal or ToClient_isConsole() then
    static_IntroMovie:TriggerEvent("PlayMovie", "coui://UI_Movie/Intro_movieClip.webm")
  else
    static_IntroMovie:TriggerEvent("PlayMovie", "coui://UI_Movie/Intro_movieClip_legacy.webm")
  end
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
if true == _ContentsGroup_RenewUI or ToClient_IsDevelopment() then
  registerEvent("FromClient_luaLoadCompleteLateUdpate", "InitIntroMoviePanel")
else
  InitIntroMoviePanel()
end
registerEvent("ToClient_EndGuideMovie", "ToClient_EndIntroMovie")
registerEvent("onScreenResize", "SetMovieSize")

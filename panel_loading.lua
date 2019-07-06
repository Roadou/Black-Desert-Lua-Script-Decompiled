Panel_Loading:SetShow(true, false)
Panel_Loading:SetOffsetIgnorePanel(true)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TM = CppEnums.TextMode
local _currentTime = 10000
local _isStartLoading = false
local screenX, screenY
local _bg1 = UI.getChildControl(Panel_Loading, "Static_BG_1")
local _bg2 = UI.getChildControl(Panel_Loading, "Static_BG_2")
local _regionName = UI.getChildControl(Panel_Loading, "StaticText_RegionName")
local _knowledge_Image = UI.getChildControl(Panel_Loading, "Static_knowImage")
local _knowledge_title = UI.getChildControl(Panel_Loading, "StaticText_knowTitle")
local _knowledge_desc = UI.getChildControl(Panel_Loading, "StaticText_knowDesc")
local progressRate = UI.getChildControl(Panel_Loading, "Progress2_Loading")
local progressHead = UI.getChildControl(progressRate, "Progress2_Bar_Head")
local staticBack = UI.getChildControl(Panel_Loading, "Static_Progress_Back")
local goblinRun = UI.getChildControl(Panel_Loading, "Static_GoblinRun")
local txt_versionInfo = UI.getChildControl(Panel_Loading, "StaticText_VersionInfo")
local backGroundEvnetImage = UI.getChildControl(Panel_Loading, "Static_BackImage")
local stc_movieBG = UI.getChildControl(backGroundEvnetImage, "Static_MovieBG")
local _ui_web_loadingMovie
local stc_fade = UI.getChildControl(Panel_Loading, "Static_Fade")
local stc_bi = UI.getChildControl(Panel_Loading, "Static_BI")
local isDraganOpen = ToClient_IsContentsGroupOpen("6")
local iskamasilviaOpen = ToClient_IsContentsGroupOpen("5")
local isBgOpen = isDraganOpen
local bgImageTexture = {}
local _movieLength = {
  10000,
  10000,
  10000,
  10000,
  10000,
  10000,
  10000,
  10000,
  10000
}
local _movieURL = {
  "coui://UI_Movie/01_sliced.webm",
  "coui://UI_Movie/02_sliced.webm",
  "coui://UI_Movie/03_sliced.webm",
  "coui://UI_Movie/04_sliced.webm",
  "coui://UI_Movie/05_sliced.webm",
  "coui://UI_Movie/06_sliced.webm",
  "coui://UI_Movie/07_sliced.webm",
  "coui://UI_Movie/08_sliced.webm",
  "coui://UI_Movie/09_sliced.webm"
}
local _movieOrder = {
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9
}
local _currentMovieIndex
if isBgOpen then
  bgImageTexture = {
    [0] = "New_UI_Common_ForLua/Window/Loading/Dragan_01.dds",
    [1] = "New_UI_Common_ForLua/Window/Loading/Dragan_02.dds",
    [2] = "New_UI_Common_ForLua/Window/Loading/Dragan_03.dds",
    [3] = "New_UI_Common_ForLua/Window/Loading/Dragan_04.dds",
    [4] = "New_UI_Common_ForLua/Window/Loading/Dragan_05.dds",
    [5] = "New_UI_Common_ForLua/Window/Loading/Dragan_06.dds",
    ["count"] = 6
  }
end
if isGameTypeJapan() then
  isBgOpen = false
  bgImageTexture = {}
  bgImageTexture = {
    [0] = "New_UI_Common_ForLua/Window/Loading/event_13.dds",
    [1] = "New_UI_Common_ForLua/Window/Loading/event_14.dds",
    [2] = "New_UI_Common_ForLua/Window/Loading/event_15.dds",
    ["count"] = 3
  }
end
if isGameTypeRussia() then
  isBgOpen = false
  bgImageTexture = {}
  bgImageTexture = {
    [0] = "New_UI_Common_ForLua/Window/Loading/event_16.dds",
    [1] = "New_UI_Common_ForLua/Window/Loading/event_17.dds",
    [2] = "New_UI_Common_ForLua/Window/Loading/event_18.dds",
    ["count"] = 3
  }
end
if isGameTypeEnglish() then
  isBgOpen = false
  bgImageTexture = {}
  bgImageTexture = {
    [0] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_1.dds",
    [1] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_2.dds",
    [2] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_3.dds",
    [3] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_4.dds",
    ["count"] = 4
  }
end
if isGameTypeJapan() then
  isBgOpen = false
  bgImageTexture = {}
  bgImageTexture = {
    [0] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_1.dds",
    [1] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_2.dds",
    [2] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_3.dds",
    [3] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_4.dds",
    ["count"] = 4
  }
end
if isGameTypeTaiwan() then
  isBgOpen = false
  bgImageTexture = {}
  bgImageTexture = {
    [0] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_1.dds",
    [1] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_2.dds",
    [2] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_3.dds",
    [3] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_4.dds",
    ["count"] = 4
  }
end
if isGameTypeSA() then
  isBgOpen = false
  bgImageTexture = {}
  bgImageTexture = {
    [0] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_1.dds",
    [1] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_2.dds",
    [2] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_3.dds",
    [3] = "New_UI_Common_ForLua/Window/Loading/bgNAOnly_4.dds",
    ["count"] = 4
  }
end
if isGameTypeKR2() then
  isBgOpen = false
  bgImageTexture = {}
  bgImageTexture = {
    [0] = "New_UI_Common_ForLua/Window/Loading/bgKR2Only_1.dds",
    ["count"] = 1
  }
end
if ToClient_isConsole() then
  isBgOpen = true
  bgImageTexture = {}
  bgImageTexture = {
    [0] = "New_UI_Common_ForLua/Window/Loading/xbox_loading_1.dds",
    [1] = "New_UI_Common_ForLua/Window/Loading/xbox_loading_2.dds",
    [2] = "New_UI_Common_ForLua/Window/Loading/xbox_loading_3.dds",
    [3] = "New_UI_Common_ForLua/Window/Loading/xbox_loading_4.dds",
    [4] = "New_UI_Common_ForLua/Window/Loading/xbox_loading_5.dds",
    [5] = "New_UI_Common_ForLua/Window/Loading/xbox_loading_6.dds",
    [6] = "New_UI_Common_ForLua/Window/Loading/xbox_loading_7.dds",
    [7] = "New_UI_Common_ForLua/Window/Loading/xbox_loading_8.dds",
    [8] = "New_UI_Common_ForLua/Window/Loading/xbox_loading_9.dds",
    [9] = "New_UI_Common_ForLua/Window/Loading/xbox_loading_10.dds",
    ["count"] = 10
  }
end
if true == _ContentsGroup_RemasterUI_Lobby then
  isBgOpen = true
end
local UI_color = Defines.Color
progressRate:SetCurrentProgressRate(0)
_knowLedge_TitleSizeX = 0
function LoadingPanel_Resize()
  screenX = getOriginScreenSizeX()
  screenY = getOriginScreenSizeY()
  Panel_Loading:SetSize(screenX, screenY)
  Panel_Loading:ComputePos()
  txt_versionInfo:ComputePos()
  txt_versionInfo:SetShow(_ContentsGroup_XB_Obt)
  _bg1:SetSize(screenX, screenY)
  _bg1:ComputePos()
  _bg2:SetSize(screenX, screenY)
  _bg2:SetSize(1, 1)
  _bg2:ComputePos()
  local uiScale = ToClient_GetUIScale()
  local gameOptionSetting = ToClient_getGameOptionControllerWrapper()
  if true == gameOptionSetting:getIsUHDMode() then
    uiScale = uiScale * 0.5
  end
  progressRate:SetSize(screenX * 0.8 * uiScale, progressRate:GetSizeY() * uiScale)
  progressRate:ComputePos()
  if true == ToClient_isConsole() then
    local gapY = (screenY - getScreenSizeY()) / 2
    progressRate:SetPosY(progressRate:GetPosY() - gapY)
  end
  staticBack:SetSize(screenX * 0.8, staticBack:GetSizeY())
  staticBack:ComputePos()
  backGroundEvnetImage:SetSize(screenX, screenY)
  backGroundEvnetImage:SetShow(isBgOpen)
  stc_movieBG:SetSize(screenX, screenY)
  stc_fade:SetSize(screenX, screenY)
  if nil ~= _ui_web_loadingMovie and true == _ContentsGroup_RemasterUI_Lobby then
    backGroundEvnetImage:SetShow(true)
  end
  if true == _ContentsGroup_RemasterUI_Lobby then
    stc_bi:ComputePos()
    stc_bi:SetShow(true)
  else
    stc_bi:SetShow(false)
  end
end
local addXpos = 0
function LoadingPanel_Init()
  progressRate:SetCurrentProgressRate(0)
  local progressRateX = progressRate:GetPosX()
  local progressRateY = progressRate:GetPosY()
  local progressHeadX = progressHead:GetPosX()
  local progressHeadY = progressHead:GetPosY()
  local isXmas = ToClient_isEventOn("x-mas")
  local isHalloween = ToClient_isEventOn("Halloween")
  local isEaster = ToClient_isEventOn("Easter")
  if isXmas then
    goblinRun:ChangeTextureInfoName("New_UI_Common_ForLua/Default/goblrun2.dds")
  elseif isEaster then
    goblinRun:ChangeTextureInfoName("New_UI_Common_ForLua/Default/EN_easter.dds")
  elseif isHalloween then
    goblinRun:ChangeTextureInfoName("new_ui_common_forlua/default/goblrun3.dds")
    progressHead:ChangeTextureInfoName("new_ui_common_forlua/default/obsidian_child2.dds")
    addXpos = 10
  else
    goblinRun:ChangeTextureInfoName("new_ui_common_forlua/default/goblrun.dds")
    progressHead:ChangeTextureInfoName("new_ui_common_forlua/default/obsidian_child.dds")
  end
  goblinRun:SetPosX(progressRateX + progressHeadX + progressHead:GetSizeX() + addXpos)
  goblinRun:SetPosY(progressRateY + progressHeadY + 25)
  stc_movieBG:SetShow(false)
  if _ContentsGroup_RemasterUI_Lobby then
    stc_movieBG:SetShow(true)
    stc_fade:SetShow(false)
    _currentMovieIndex = 1
    LoadingPanel_ShuffleOrder(_movieOrder)
  end
  if true == ToClient_isConsole() then
    stc_movieBG:SetShow(false)
    stc_fade:SetShow(false)
  end
end
function LoadingPanel_ShuffleOrder(table)
  if nil == table or nil == #table then
    return
  end
  if #table <= 1 then
    return
  end
  for ii = 1, #table do
    local temp = table[ii]
    local posToShuffle = getRandomValue(1, #table)
    table[ii] = table[posToShuffle]
    table[posToShuffle] = temp
  end
end
function LoadingPanel_LoadMovie()
  if false == _ContentsGroup_RemasterUI_Lobby or true == ToClient_isConsole() then
    return
  end
  stc_movieBG:SetShow(true)
  if nil == _ui_web_loadingMovie then
    _ui_web_loadingMovie = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, backGroundEvnetImage, "Static_LoadingMovie")
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
  _ui_web_loadingMovie:SetPosX(posX - marginX / 2)
  _ui_web_loadingMovie:SetPosY(posY - marginY / 2)
  _ui_web_loadingMovie:SetSize(movieSizeX + marginX, movieSizeY + marginY)
  _ui_web_loadingMovie:SetUrl(1920, 1080, "coui://UI_Data/UI_Html/LobbyBG_Movie.html")
end
function FromClient_LoadingPanel_OnMovieEvent(param)
  if false == _ContentsGroup_RemasterUI_Lobby then
    return
  end
  if 1 == param then
    LoadingPanel_StartFadeIn()
    if nil ~= _ui_web_loadingMovie then
      _ui_web_loadingMovie:TriggerEvent("PlayMovie", _movieURL[_movieOrder[_currentMovieIndex]])
    end
  elseif 2 == param then
    _currentMovieIndex = _currentMovieIndex + 1
    if nil == _movieOrder[_currentMovieIndex] then
      _currentMovieIndex = 1
    end
    _ui_web_loadingMovie:TriggerEvent("PlayMovie", _movieURL[_movieOrder[_currentMovieIndex]])
    LoadingPanel_StartFadeIn()
  end
  if nil ~= PaGlobal_FadeOutClose then
    PaGlobal_FadeOutClose()
  end
end
local _fadeTime = 1
function LoadingPanel_StartFadeIn()
  stc_fade:SetShow(false)
end
function LoadingPanel_StartFadeOut()
  stc_fade:SetShow(false)
end
function LoadingPanel_SetProgress(rate)
  progressRate:SetProgressRate(rate)
  local progressRateX = progressRate:GetPosX()
  local progressRateY = progressRate:GetPosY()
  local progressHeadX = progressHead:GetPosX()
  local progressHeadY = progressHead:GetPosY()
  local isHalloween = ToClient_isEventOn("Halloween")
  local addXpos2 = 0
  if isHalloween then
    addXpos2 = 10
  else
    addXpos2 = 0
  end
  goblinRun:SetPosX(progressRateX + progressHeadX + progressHead:GetSizeX() + addXpos2)
  goblinRun:SetPosY(progressRateY + progressHeadY + 25)
end
function LoadingPanel_SetRegionName()
  local cameraPosition = getWorldMapCameraLookAt()
  _regionName:SetText(getRegionNameByPosition(cameraPosition))
end
local function LoadingPanel_PlayKnowledgeAni()
  _bg1:SetShow(true)
  _bg2:SetShow(true)
  local ImageMoveAni = _knowledge_Image:addMoveAnimation(0, 1.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni:SetStartPosition(screenX / 2 - 200, screenY / 2 - 350)
  ImageMoveAni:SetEndPosition(screenX / 2 - 200, screenY / 2 - 400)
  ImageMoveAni.IsChangeChild = true
  _knowledge_Image:CalcUIAniPos(ImageMoveAni)
  local knowTitleMoveAni = _knowledge_title:addMoveAnimation(0, 1.65, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  knowTitleMoveAni:SetStartPosition(screenX / 2 - _knowLedge_TitleSizeX / 2, screenY / 2 - 50)
  knowTitleMoveAni:SetEndPosition(screenX / 2 - _knowLedge_TitleSizeX / 2, screenY / 2 + 20)
  knowTitleMoveAni.IsChangeChild = true
  _knowledge_title:CalcUIAniPos(knowTitleMoveAni)
  local knowDescMoveAni = _knowledge_desc:addMoveAnimation(0, 1.75, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  knowDescMoveAni:SetStartPosition(screenX / 2 - 300, screenY / 2 - 25)
  knowDescMoveAni:SetEndPosition(screenX / 2 - 300, screenY / 2 + 50)
  knowDescMoveAni.IsChangeChild = true
  _knowledge_desc:CalcUIAniPos(knowDescMoveAni)
  local ImageAni = _knowledge_Image:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageAni:SetStartColor(UI_color.C_00FFFFFF)
  ImageAni:SetEndColor(UI_color.C_00FFFFFF)
  ImageAni.IsChangeChild = true
  local knowTitleAni = _knowledge_title:addColorAnimation(0, 0.35, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  knowTitleAni:SetStartColor(UI_color.C_00FFFFFF)
  knowTitleAni:SetEndColor(UI_color.C_00FFFFFF)
  knowTitleAni.IsChangeChild = true
  local knowDescAni = _knowledge_desc:addColorAnimation(0, 0.45, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  knowDescAni:SetStartColor(UI_color.C_00FFFFFF)
  knowDescAni:SetEndColor(UI_color.C_00FFFFFF)
  knowDescAni.IsChangeChild = true
  local ImageAni = _knowledge_Image:addColorAnimation(0.25, 0.85, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageAni:SetStartColor(UI_color.C_00FFFFFF)
  ImageAni:SetEndColor(UI_color.C_FFFFFFFF)
  ImageAni.IsChangeChild = true
  local knowTitleAni = _knowledge_title:addColorAnimation(0.35, 0.95, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  knowTitleAni:SetStartColor(UI_color.C_00FFFFFF)
  knowTitleAni:SetEndColor(UI_color.C_FFFFFFFF)
  knowTitleAni.IsChangeChild = true
  local knowDescAni = _knowledge_desc:addColorAnimation(0.45, 1.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  knowDescAni:SetStartColor(UI_color.C_00FFFFFF)
  knowDescAni:SetEndColor(UI_color.C_FFFFFFFF)
  knowDescAni.IsChangeChild = true
  local ImageAni = _knowledge_Image:addColorAnimation(7, 7.65, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageAni:SetStartColor(UI_color.C_FFFFFFFF)
  ImageAni:SetEndColor(UI_color.C_00FFFFFF)
  ImageAni.IsChangeChild = true
  local knowTitleAni = _knowledge_title:addColorAnimation(7, 7.75, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  knowTitleAni:SetStartColor(UI_color.C_FFFFFFFF)
  knowTitleAni:SetEndColor(UI_color.C_00FFFFFF)
  knowTitleAni.IsChangeChild = true
  local knowDescAni = _knowledge_desc:addColorAnimation(7, 7.85, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  knowDescAni:SetStartColor(UI_color.C_FFFFFFFF)
  knowDescAni:SetEndColor(UI_color.C_00FFFFFF)
  knowDescAni.IsChangeChild = true
end
local function LoadingPanel_GetRandomKnowledge()
  local mentalCardData = RequestIntimacy_getRandomKnowledge()
  if nil ~= mentalCardData then
    _knowledge_Image:SetShow(true, false)
    _knowledge_title:SetShow(true, false)
    _knowledge_desc:SetShow(true, false)
    local screenX = getScreenSizeX()
    _knowledge_Image:ChangeTextureInfoName(mentalCardData:getPicture())
    _knowledge_title:SetText(mentalCardData:getName())
    _knowLedge_TitleSizeX = _knowledge_title:GetTextSizeX()
    _knowledge_desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
    _knowledge_desc:SetText(mentalCardData:getDesc())
    LoadingPanel_PlayKnowledgeAni()
  end
  if true == _ContentsGroup_RenewUI then
  end
end
function LoadingPanel_GetBackGroundImage()
  if isBgOpen and nil ~= bgImageTexture and nil ~= bgImageTexture.count then
    local loadingImageIndex = math.random(0, bgImageTexture.count - 1)
    loadingImageIndex = (loadingImageIndex + 1) % bgImageTexture.count
    backGroundEvnetImage:ChangeTextureInfoName(bgImageTexture[loadingImageIndex])
    backGroundEvnetImage:getBaseTexture():setUV(0, 0, 1, 1)
    backGroundEvnetImage:setRenderTexture(backGroundEvnetImage:getBaseTexture())
  end
end
local updateTime = 0
local isScope = false
function LoadingPanel_UpdatePerFrame(deltaTime)
  if true == _ContentsGroup_RemasterUI_Lobby then
    luaTimer_UpdatePerFrame(deltaTime)
  end
  _currentTime = _currentTime + deltaTime
  updateTime = updateTime - deltaTime
  if _currentTime > 8 then
    _currentTime = 0
    LoadingPanel_GetRandomKnowledge()
  end
end
registerEvent("ToClient_EndGuideMovie", "FromClient_LoadingPanel_OnMovieEvent")
registerEvent("EventMapLoadProgress", "LoadingPanel_SetProgress")
registerEvent("onScreenResize", "LoadingPanel_Resize")
Panel_Loading:RegisterUpdateFunc("LoadingPanel_UpdatePerFrame")
LoadingPanel_Resize()
LoadingPanel_GetBackGroundImage()
function InitLoadingMoviePanel()
  _PA_LOG("COHERENT", "InitLoadingMoviePanel")
  LoadingPanel_LoadMovie()
end
function RegisterEvent()
  registerEvent("FromClient_luaLoadCompleteLateUdpate", "InitLoadingMoviePanel")
end
RegisterEvent()

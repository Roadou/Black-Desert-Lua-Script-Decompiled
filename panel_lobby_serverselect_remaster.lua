local _panel = Panel_Lobby_ServerSelect_Remaster
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local CHANNEL_TYPE = {
  SINGLE_WORLD_SYSTEM = 1,
  WAR_INFO = 2,
  OLVIA_CHANNEL = 3,
  PC_ROOM_CHANNEL = 4,
  ARSHA_CHANNEL = 5
}
local ServerSelectRemaster = {
  _ui = {
    stc_movieBG = UI.getChildControl(_panel, "Static_MovieBG"),
    stc_fade = UI.getChildControl(_panel, "Static_MovieFade"),
    stc_rightBg = UI.getChildControl(_panel, "Static_RightBg"),
    stc_leftBg = UI.getChildControl(_panel, "Static_LeftBg"),
    txt_serverSelectTitle = UI.getChildControl(_panel, "StaticText_ServerSelectTitle"),
    stc_channelDesc = {},
    stc_divideLines = {},
    tree_server = nil,
    scroll_serverList = nil
  },
  _treeData = {},
  _treeMainBranchKey = {},
  _lastConnectedServerIdx = 0,
  _worldServerCount = 0,
  _selectedWorldIndex = 1,
  _selectedChannelIndex = nil,
  _worldIndex = nil,
  _serverIndex = nil,
  _currentButtonState = 1,
  _currentDescriptionY = 0,
  _currentHoveredKey32 = nil,
  _defaultYGap = 15
}
local _startAnimationFlag = false
local _rightBgTargetX = 0
local _listContents = {}
local _listContentsTarget = {}
local _listContentsAlphaTarget = {}
local _listContentsAlphaFlag = {}
local _listContentsFlag = {}
local _listContentsCount = 0
local _listContentsAnimArea = 0
local _listContentsTargetCurve = {}
local _listContentsBaseX = 0
local _listContentsShowAniFlag = false
local _listContentsLaunchedCount = 1
local _listContentsLaunchTimeTable = {}
local _listContentsLaunchElapsed = 0
local _startAnimationFinished = false
local _isInitialized = false
local _treeSize = 0
local _channelButtonsState = 0
local _movieLength = {10000, 10000}
local _movieURL = {
  "coui://UI_Movie/06_sliced.webm",
  "coui://UI_Movie/07_sliced.webm"
}
local _movieOrder = {1, 2}
local _currentMovieIndex, _currentMovieIndex, _ui_web_loadingMovie
local BUTTON_STATE = {
  NORMAL = 1,
  SELECTED = 2,
  MAINSERVER_SELECT = 3
}
local _channelDescriptionData = {
  [CHANNEL_TYPE.SINGLE_WORLD_SYSTEM] = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_CHANNELSELECTTITLE"),
    desc = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_CHANNELSELECTDESC")
  },
  [CHANNEL_TYPE.WAR_INFO] = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_TITLE"),
    desc = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_TERRITORY_SUB_TITLE") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_TERRITORY_SUB_DESC_BALENOS") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_TERRITORY_SUB_DESC_SERENDIA") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_TERRITORY_SUB_DESC_CALPEON") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_TERRITORY_SUB_DESC_MEDIA") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_TERRITORY_SUB_DESC_VALENCIA") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_DATE_SUB_TITLE") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_DATE_SUB_DESC_TERRITORYWAR") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_DATE_SUB_DESC_NODEWAR")
  },
  [CHANNEL_TYPE.OLVIA_CHANNEL] = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SPEEDCHANNEL_TITLE"),
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SPEEDCHANNEL_DESC")
  },
  [CHANNEL_TYPE.PC_ROOM_CHANNEL] = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_SEVERSELECT_PCROOMSERVER"),
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_DESC")
  },
  [CHANNEL_TYPE.ARSHA_CHANNEL] = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_PVPICON"),
    desc = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_PVPDESC")
  }
}
local _channelIconUV = {
  [CHANNEL_TYPE.SINGLE_WORLD_SYSTEM] = {
    192,
    227,
    220,
    255
  },
  [CHANNEL_TYPE.WAR_INFO] = {
    192,
    227,
    220,
    255
  },
  [CHANNEL_TYPE.OLVIA_CHANNEL] = {
    163,
    227,
    191,
    255
  },
  [CHANNEL_TYPE.PC_ROOM_CHANNEL] = {
    221,
    198,
    249,
    226
  },
  [CHANNEL_TYPE.ARSHA_CHANNEL] = {
    105,
    227,
    133,
    255
  }
}
local screenX = getScreenSizeX()
local screenY = getScreenSizeY()
_stc_BackgroundImage = Array.new()
local bgItem = {
  "base",
  "calpeon",
  "media",
  "valencia",
  "sea",
  "kamasilvia",
  "kamasilvia2",
  "dragan",
  "xmas",
  "halloween",
  "thanksGivingDay",
  "aurora",
  "KoreaOnly",
  "JapanOnly",
  "RussiaOnly",
  "NaOnly",
  "TaiwanOnly",
  "KR2Only",
  "SAOnly",
  "TROnly",
  "THOnly",
  "IDOnly"
}
local bgIndex = {}
for k, v in pairs(bgItem) do
  bgIndex[v] = k
end
local baseLink = "New_UI_Common_forLua/Window/Lobby/"
local bgManager = {
  [bgIndex.base] = {
    isOpen = true,
    imageCount = 3,
    iconPath = "bgBase_"
  },
  [bgIndex.calpeon] = {
    isOpen = ToClient_IsContentsGroupOpen("2"),
    imageCount = 6,
    iconPath = "bgCalpeon_"
  },
  [bgIndex.media] = {
    isOpen = ToClient_IsContentsGroupOpen("3"),
    imageCount = 2,
    iconPath = "bgMedia_"
  },
  [bgIndex.valencia] = {
    isOpen = ToClient_IsContentsGroupOpen("4"),
    imageCount = 6,
    iconPath = "bgValencia_"
  },
  [bgIndex.sea] = {
    isOpen = ToClient_IsContentsGroupOpen("83"),
    imageCount = 3,
    iconPath = "bgValenciaSea_"
  },
  [bgIndex.kamasilvia] = {
    isOpen = ToClient_IsContentsGroupOpen("5"),
    imageCount = 7,
    iconPath = "bgKamasilvia_"
  },
  [bgIndex.kamasilvia2] = {
    isOpen = ToClient_IsContentsGroupOpen("260"),
    imageCount = 3,
    iconPath = "bgKamasilvia2_Server_"
  },
  [bgIndex.dragan] = {
    isOpen = ToClient_IsContentsGroupOpen("6"),
    imageCount = 1,
    iconPath = "bgDraganServer_"
  },
  [bgIndex.xmas] = {
    isOpen = ToClient_isEventOn("x-mas"),
    imageCount = 1,
    iconPath = "bgXmas_"
  },
  [bgIndex.halloween] = {
    isOpen = ToClient_isEventOn("Halloween"),
    imageCount = 3,
    iconPath = "bgHalloween_"
  },
  [bgIndex.thanksGivingDay] = {
    isOpen = ToClient_isEventOn("ThanksGivingDay"),
    imageCount = 2,
    iconPath = "bgThanksGivingDay_"
  },
  [bgIndex.aurora] = {
    isOpen = ToClient_isEventOn("Aurora"),
    imageCount = 2,
    iconPath = "bgAurora_"
  },
  [bgIndex.KoreaOnly] = {
    isOpen = isGameTypeKorea() and false,
    imageCount = 1,
    iconPath = "bgKoreaOnly2_"
  },
  [bgIndex.JapanOnly] = {
    isOpen = isGameTypeJapan() and false,
    imageCount = 2,
    iconPath = "bgJapanOnly_"
  },
  [bgIndex.RussiaOnly] = {
    isOpen = isGameTypeRussia() and false,
    imageCount = 0,
    iconPath = "bgRussiaOnly_"
  },
  [bgIndex.NaOnly] = {
    isOpen = isGameTypeEnglish() and false,
    imageCount = 4,
    iconPath = "bgNAOnly_"
  },
  [bgIndex.TaiwanOnly] = {
    isOpen = isGameTypeTaiwan() and false,
    imageCount = 0,
    iconPath = "bgTaiwanOnly_"
  },
  [bgIndex.KR2Only] = {
    isOpen = isGameTypeKR2() and false,
    imageCount = 0,
    iconPath = "bgKR2Only_"
  },
  [bgIndex.SAOnly] = {
    isOpen = isGameTypeSA() and false,
    imageCount = 0,
    iconPath = "bgSAOnly_"
  },
  [bgIndex.TROnly] = {
    isOpen = isGameTypeTR() and false,
    imageCount = 0,
    iconPath = "bgTROnly_"
  },
  [bgIndex.THOnly] = {
    isOpen = isGameTypeTH() and false,
    imageCount = 0,
    iconPath = "bgTHOnly_"
  },
  [bgIndex.IDOnly] = {
    isOpen = isGameTypeID() and false,
    imageCount = 0,
    iconPath = "bgIDOnly_"
  }
}
local totalBG = 0
local imageIndex = 1
local startIndex, endIndex
local tempBg = UI.getChildControl(_panel, "bgBase_1")
for v, value in ipairs(bgManager) do
  if value.isOpen then
    totalBG = totalBG + value.imageCount
    if 0 < value.imageCount then
      startIndex = imageIndex
      for index = 1, value.imageCount do
        local targetControl = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, _panel, "Static_ServerSelectBg_" .. imageIndex)
        CopyBaseProperty(tempBg, targetControl)
        targetControl:ChangeTextureInfoName(baseLink .. value.iconPath .. index .. ".dds")
        targetControl:SetSize(screenX, screenY)
        targetControl:SetPosX(0)
        targetControl:SetPosY(0)
        targetControl:SetAlpha(0)
        _panel:SetChildIndex(targetControl, 0)
        _stc_BackgroundImage[imageIndex] = targetControl
        endIndex = imageIndex
        imageIndex = imageIndex + 1
      end
    end
  end
end
tempBg:SetShow(false)
local bgStartIndex = getRandomValue(startIndex, endIndex)
local _isScope = true
local _updateTimeAcc = 0
local currentBackIndex = bgStartIndex
local startUV = 0.1
local endUV = startUV + 0.04
local startUV2 = 0.9
local endUV2 = startUV2 + 0.04
local self = ServerSelectRemaster
function ServerSelectRemaster:init()
  if false == _isInitialized then
    self._ui.stc_divideLines[1] = UI.getChildControl(self._ui.stc_leftBg, "Static_DivideLine_1")
    self._ui.stc_divideLines[2] = UI.getChildControl(self._ui.stc_leftBg, "Static_DivideLine_2")
    self._ui.stc_channelDesc[CHANNEL_TYPE.SINGLE_WORLD_SYSTEM] = UI.getChildControl(self._ui.stc_leftBg, "SINGLE_WORLD_SYSTEM")
    self._ui.stc_channelDesc[CHANNEL_TYPE.WAR_INFO] = UI.getChildControl(self._ui.stc_leftBg, "WAR_INFO")
    self._ui.stc_channelDesc[CHANNEL_TYPE.OLVIA_CHANNEL] = UI.getChildControl(self._ui.stc_leftBg, "OLVIA_CHANNEL")
    self._ui.stc_channelDesc[CHANNEL_TYPE.PC_ROOM_CHANNEL] = UI.getChildControl(self._ui.stc_leftBg, "PC_ROOM_CHANNEL")
    self._ui.stc_channelDesc[CHANNEL_TYPE.ARSHA_CHANNEL] = UI.getChildControl(self._ui.stc_leftBg, "ARSHA_CHANNEL")
    for ii = 1, #self._ui.stc_channelDesc do
      self:updateChannelDesc(ii)
      self._ui.stc_channelDesc[ii]:SetShow(false)
    end
    local topComponent = self._ui.stc_channelDesc[CHANNEL_TYPE.SINGLE_WORLD_SYSTEM]
    topComponent:SetShow(true)
    self._ui.stc_divideLines[1]:SetShow(false)
    self._ui.stc_divideLines[2]:SetShow(false)
    self._ui.stc_divideLines[2]:SetPosY(topComponent:GetSizeY() + topComponent:GetPosY() + self._defaultYGap)
    self._currentDescriptionY = self._ui.stc_divideLines[1]:GetPosY() + self._defaultYGap * 2
    self._ui.tree_server = UI.getChildControl(_panel, "List2_ServerList")
    self._ui.scroll_serverList = self._ui.tree_server:GetVScroll()
    self._ui.txt_Select_ConsoleUI = UI.getChildControl(self._ui.stc_rightBg, "StaticText_Select_ConsoleUI")
    self._ui.txt_Select_ConsoleUI:SetShow(false)
    self._ui.txt_Back_ConsoleUI = UI.getChildControl(self._ui.stc_rightBg, "StaticText_Back_ConsoleUI")
    self._ui.txt_Back_ConsoleUI:SetShow(false)
    self._ui.txt_serverName = UI.getChildControl(self._ui.stc_leftBg, "StaticText_ServerName")
    self._ui.btn_mainServer = UI.getChildControl(self._ui.stc_rightBg, "Button_MainServer")
    self._ui.btn_mainServerSelect = UI.getChildControl(self._ui.stc_rightBg, "Button_MainServerSelect")
    self._ui.btn_mainServer:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui.btn_mainServer:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_NOMAINSERVER"))
    self._ui.btn_mainServer:SetTextSpan(15, self._ui.btn_mainServer:GetSizeY() / 2 - self._ui.btn_mainServer:GetTextSizeY() / 2)
    self._ui.btn_recentServer = UI.getChildControl(self._ui.stc_rightBg, "Button_RecentServer")
    self._ui.btn_randomServer = UI.getChildControl(self._ui.stc_rightBg, "Button_RandomServer")
    self._ui.btn_recentServer:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui.btn_recentServer:SetText(PAGetString(Defines.StringSheet_RESOURCE, "LUA_SERVERSELECT_LASTJOINSERVER_NONE"))
    self._ui.btn_recentServer:SetTextSpan(15, self._ui.btn_recentServer:GetSizeY() / 2 - self._ui.btn_recentServer:GetTextSizeY() / 2)
    self._ui.btn_mainServer:ComputePos()
    self._ui.btn_mainServerSelect:ComputePos()
    self._ui.btn_recentServer:ComputePos()
    self._ui.btn_randomServer:ComputePos()
    PaGlobal_ServerSelect_Resize()
    local content = UI.getChildControl(self._ui.tree_server, "List2_1_Content")
    _listContentsCount = math.ceil(self._ui.tree_server:GetSizeY() / content:GetSizeY()) + 1
    local thetaUnit = math.pi * 0.5 / _listContentsAnimArea
    for ii = 1, _listContentsAnimArea do
      _listContentsTargetCurve[ii] = math.sin(thetaUnit * ii)
    end
    for ii = 1, _listContentsCount do
      _listContentsLaunchTimeTable[ii] = (ii - 1) * 0.03
    end
    self:registEventHandler()
    _isInitialized = true
  end
  _currentMovieIndex = 1
  self:shuffleOrder(_movieOrder)
end
function ServerSelectRemaster:updateChannelDesc(channelType)
  local component = self._ui.stc_channelDesc[channelType]
  local txt_title = UI.getChildControl(component, "StaticText_Title")
  local txt_desc = UI.getChildControl(component, "StaticText_Desc")
  txt_title:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_title:SetText(_channelDescriptionData[channelType].title)
  txt_desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_desc:SetText(_channelDescriptionData[channelType].desc)
  if channelType == CHANNEL_TYPE.OLVIA_CHANNEL then
    if isGameTypeTaiwan() then
      txt_desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SPEEDCHANNEL_DESC_TW"))
    else
      txt_desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SPEEDCHANNEL_DESC"))
    end
  elseif channelType == CHANNEL_TYPE.ARSHA_CHANNEL then
    if isGameTypeKorea() then
      txt_desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_PVPDESC_ARSHASERVER"))
    else
      txt_desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_PVPDESC"))
    end
  elseif channelType == CHANNEL_TYPE.PC_ROOM_CHANNEL then
    local isBlackSpiritEnable = ToClient_IsContentsGroupOpen("1015")
    if isGameTypeEnglish() then
      txt_title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_TITLE_NA"))
      txt_desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_DESC_NA"))
    elseif isBlackSpiritEnable then
      txt_title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_TITLE"))
      txt_desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_DESC"))
    else
      txt_title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_TITLE"))
      txt_desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_DESC_NONEBLACKSPIRIT"))
    end
  end
  txt_title:SetPosY(0)
  txt_desc:SetPosY(txt_title:GetTextSizeY() + self._defaultYGap)
  txt_desc:SetSize(txt_desc:GetSizeX(), txt_desc:GetTextSizeY())
  local val = txt_title:GetTextSizeY() + txt_desc:GetTextSizeY() + self._defaultYGap * 2
  component:SetSize(component:GetSizeX(), val)
  component:ComputePos()
end
function ServerSelectRemaster:shuffleOrder(table)
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
function ServerSelectRemaster:registEventHandler()
  if true == ToClient_IsDevelopment() then
  end
  self._ui.btn_mainServer:addInputEvent("Mouse_LUp", "InputMLUp_ServerSelect_EnterMainServer()")
  self._ui.btn_mainServerSelect:addInputEvent("Mouse_LUp", "InputMLUp_ServerSelect_ChangeMainServer()")
  self._ui.btn_recentServer:addInputEvent("Mouse_LUp", "InputMLUp_ServerSelect_EnterLastJoinedServer()")
  self._ui.btn_randomServer:addInputEvent("Mouse_LUp", "InputMLUp_ServerSelect_EnterRandomServer()")
  registerEvent("EventUpdateServerInformationForServerSelect", "PaGlobal_ServerSelect_EventUpdateServerInfo")
  registerEvent("onScreenResize", "PaGlobal_ServerSelect_Resize")
  unregisterEvent("ToClient_EndGuideMovie", "FromClient_LoginRemaster_OnMovieEvent")
  registerEvent("ToClient_EndGuideMovie", "FromClient_ServerSelect_OnMovieEvent")
  _panel:RegisterUpdateFunc("PaGlobal_ServerSelect_PerFrameUpdate")
end
function ServerSelectRemaster:open()
  _panel:SetShow(true)
  self._ui.txt_serverName:SetText("")
  self:initTreeData()
  local ImageMoveAni = self._ui.stc_rightBg:addMoveAnimation(0, 0.7, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni:SetStartPosition(getScreenSizeX(), 0)
  ImageMoveAni:SetEndPosition(getScreenSizeX() - self._ui.stc_rightBg:GetSizeX(), 0)
  ImageMoveAni.IsChangeChild = true
  self._ui.stc_rightBg:CalcUIAniPos(ImageMoveAni)
  self:updateTextOnButtons()
end
function ServerSelectRemaster:PlayMovie()
  self._ui.stc_fade:SetSize(getScreenSizeX(), getScreenSizeY())
  self._ui.stc_movieBG:SetSize(getScreenSizeX(), getScreenSizeY())
  if nil == _ui_web_loadingMovie then
    _ui_web_loadingMovie = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, self._ui.stc_movieBG, "Static_BgMovie")
  end
  _ui_web_loadingMovie:ResetUrl()
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
  _panel:SetPosX(0)
  _panel:SetPosY(0)
  _panel:SetSize(sizeX, sizeY)
  local marginX = movieSizeX * 0.013
  local marginY = movieSizeY * 0.013
  _ui_web_loadingMovie:SetPosX(posX - marginX / 2)
  _ui_web_loadingMovie:SetPosY(posY - marginY / 2)
  _ui_web_loadingMovie:SetSize(movieSizeX + marginX, movieSizeY + marginY)
  _ui_web_loadingMovie:SetUrl(1920, 1080, "coui://UI_Data/UI_Html/LobbyBG_Movie.html")
end
local _moviePlayed = false
local _fadeTime = 1
function FromClient_ServerSelect_OnMovieEvent(param)
  if 1 == param then
    self:startFadeIn()
    if nil ~= _ui_web_loadingMovie then
      _ui_web_loadingMovie:TriggerEvent("PlayMovie", _movieURL[_movieOrder[_currentMovieIndex]])
      _moviePlayed = true
    end
  elseif 2 == param then
    _currentMovieIndex = _currentMovieIndex + 1
    if nil == _movieOrder[_currentMovieIndex] then
      _currentMovieIndex = 1
    end
    _ui_web_loadingMovie:TriggerEvent("PlayMovie", _movieURL[_movieOrder[_currentMovieIndex]])
    self:startFadeIn()
    luaTimer_AddEvent(PaGlobalFunc_ServerSelectRemaster_FadeOut, _movieLength[_movieOrder[_currentMovieIndex]] - _fadeTime * 1000, false, 0)
  end
end
function ServerSelectRemaster:startFadeIn()
  self._ui.stc_fade:SetShow(false)
end
function PaGlobalFunc_ServerSelectRemaster_FadeOut()
  self:startFadeOut()
end
function ServerSelectRemaster:startFadeOut()
  self._ui.stc_fade:SetShow(false)
end
local _dummyData = {}
function ServerSelectRemaster:initTreeData()
  local tree = self._ui.tree_server
  tree = UI.getChildControl(_panel, "List2_ServerList")
  tree:changeAnimationSpeed(11)
  tree:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_ServerSelect_ServerList_ControlCreate")
  tree:createChildContent(CppEnums.PAUIList2ElementManagerType.tree)
  tree:getElementManager():clearKey()
  local mainElement = tree:getElementManager():getMainElement()
  self._worldServerCount = getGameWorldServerDataCount()
  local teenWorldIndex, adultWorldIndex
  local key = 1
  _dummyData[1] = {}
  for ii = 1, self._worldServerCount do
    local worldServerData = getGameWorldServerDataByIndex(ii - 1)
    local worldElement = mainElement:createChild(toInt64(0, key))
    worldElement:setIsOpen(false)
    self._treeData[key] = {isWorldServer = true, worldIndex = ii}
    self._treeMainBranchKey[ii] = key
    key = key + 1
    if isGameServiceTypeKor() and false == ToClient_IsDevelopment() then
      local channelServerData = getGameChannelServerDataByIndex(ii - 1, 0)
      if nil ~= channelServerData and false == channelServerData._isAdultWorld then
        teenWorldIndex = ii
      else
        adultWorldIndex = ii
      end
    end
    local channelCount = getGameChannelServerDataCount(worldServerData._worldNo)
    local tempTable = {}
    local tempOlviaTable = {}
    for jj = 1, channelCount do
      local channelServerData = getGameChannelServerDataByIndex(ii - 1, jj - 1)
      if false == ToClient_IsDevelopment() and false == ToClient_SelfPlayerIsGM() then
        if false == channelServerData._isInstanceChannel then
          if true == channelServerData._isSpeedChannel then
            tempOlviaTable[#tempOlviaTable + 1] = {
              isWorldServer = false,
              worldIndex = ii,
              channelIndex = jj,
              isSpeedChannel = channelServerData._isSpeedChannel,
              serverNo = channelServerData._serverNo
            }
          else
            tempTable[#tempTable + 1] = {
              isWorldServer = false,
              worldIndex = ii,
              channelIndex = jj,
              isSpeedChannel = channelServerData._isSpeedChannel,
              serverNo = channelServerData._serverNo
            }
          end
        end
      elseif true == channelServerData._isSpeedChannel then
        tempOlviaTable[#tempOlviaTable + 1] = {
          isWorldServer = false,
          worldIndex = ii,
          channelIndex = jj,
          isSpeedChannel = channelServerData._isSpeedChannel,
          serverNo = channelServerData._serverNo
        }
      else
        tempTable[#tempTable + 1] = {
          isWorldServer = false,
          worldIndex = ii,
          channelIndex = jj,
          isSpeedChannel = channelServerData._isSpeedChannel,
          serverNo = channelServerData._serverNo
        }
      end
    end
    for ii = 1, #tempOlviaTable do
      worldElement:createChild(toInt64(0, key))
      self._treeData[key] = tempOlviaTable[ii]
      key = key + 1
    end
    for ii = 1, #tempTable do
      worldElement:createChild(toInt64(0, key))
      self._treeData[key] = tempTable[ii]
      key = key + 1
    end
  end
  local openAdultWorld = true
  if isGameServiceTypeKor() and false == ToClient_IsDevelopment() then
    local isAdultUser = ToClient_isAdultUser()
    if true == isAdultUser then
      self:updateSingleWorldDesc(false)
    else
      self:updateSingleWorldDesc(true)
    end
    openAdultWorld = true == isAdultUser
  else
    self:updateSingleWorldDesc(false)
  end
  if openAdultWorld then
    if nil == adultWorldIndex then
      local firstWorld = tree:getElementManager():getByKey(toInt64(0, 1))
      firstWorld:setIsOpen(true)
    else
      local firstWorld = tree:getElementManager():getByKey(toInt64(0, adultWorldIndex))
      firstWorld:setIsOpen(true)
    end
  elseif nil == teenWorldIndex then
    local teenWorld = tree:getElementManager():getByKey(toInt64(0, 2))
    teenWorld:setIsOpen(true)
  else
    local teenWorld = tree:getElementManager():getByKey(toInt64(0, teenWorldIndex))
    teenWorld:setIsOpen(true)
  end
  _treeSize = key
  tree:getElementManager():refillKeyList()
  _listContentsCount = tree:getChildContentListSize()
end
local _lateUpdateFlag = false
function ServerSelectRemaster:initTreeLateUpdate()
  if true == _lateUpdateFlag then
    return
  end
  self:initTreeData()
  _lateUpdateFlag = true
end
function ServerSelectRemaster:updateListData()
  local worldServerData = getGameWorldServerDataByIndex(self._selectedWorldIndex - 1)
  if nil == worldServerData then
    return
  end
  for ii = 1, _treeSize do
    self._ui.tree_server:requestUpdateByKey(toInt64(0, ii))
  end
  self:updateTextOnButtons()
end
function PaGlobal_ServerSelect_ServerList_ControlCreate(content, key)
  local key32 = Int64toInt32(key)
  _listContents[key32] = content
  if false == _startAnimationFinished then
    _listContentsTarget[key32] = _listContentsBaseX
    content:SetAlphaExtraChild(0)
  else
    _listContentsAlphaTarget[key32] = 1
    _listContentsAlphaFlag[key32] = true
  end
  local worldButtonBG = UI.getChildControl(content, "Static_WorldButtonBG")
  local channelButtonBG = UI.getChildControl(content, "Static_ChannelButtonBG")
  local bool = self._treeData[key32].isWorldServer
  worldButtonBG:SetShow(bool)
  channelButtonBG:SetShow(not bool)
  if self._treeData[key32].isWorldServer then
    PaGlobal_ServerSelect_CreateWorldBranch(content, key)
  else
    PaGlobal_ServerSelect_CreateChannelBranch(content, key)
  end
end
function PaGlobal_ServerSelect_CreateWorldBranch(content, key)
  local key32 = Int64toInt32(key)
  local worldButtonBG = UI.getChildControl(content, "Static_WorldButtonBG")
  local btn = UI.getChildControl(worldButtonBG, "Button_NormalServerSlot")
  local worldIdx = self._treeData[key32].worldIndex
  if nil == worldIdx then
    return
  end
  local worldServerData = getGameWorldServerDataByIndex(worldIdx - 1)
  if nil ~= worldServerData then
    local name = getWorldNameByWorldNo(worldServerData._worldNo)
    btn:SetText(name)
  else
    btn:SetText("dummy")
  end
  local isExpBonusEvent = IsWorldServerEventTypeByWorldIndex(worldIdx - 1, -1, 0)
  local isDropRateEvent = IsWorldServerEventTypeByWorldIndex(worldIdx - 1, -1, 1)
  local txt_worldBonus = UI.getChildControl(worldButtonBG, "StaticText_Bonus")
  local tempEventName = ""
  if isExpBonusEvent then
    tempEventName = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_EXPEVENT")
  end
  if isDropRateEvent then
    if "" ~= tempEventName then
      tempEventName = tempEventName .. " " .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_DROPEVENT")
    else
      tempEventName = tempEventName .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_DROPEVENT")
    end
  end
  if "" == tempEventName then
    txt_worldBonus:SetShow(false)
  else
    txt_worldBonus:SetShow(true)
    txt_worldBonus:SetText(tempEventName)
  end
  btn:addInputEvent("Mouse_LUp", "InputMLUp_ServerSelect_SelectWorld(" .. worldIdx .. ")")
  btn:addInputEvent("Mouse_On", "InputMOn_ServerSelect_SelectWorldTooltip(" .. key32 .. ")")
end
function PaGlobal_ServerSelect_CreateChannelBranch(content, key)
  local key32 = Int64toInt32(key)
  local worldServerIdx = self._treeData[key32].worldIndex
  local channelServerIdx = self._treeData[key32].channelIndex
  local channelButtonBG = UI.getChildControl(content, "Static_ChannelButtonBG")
  local worldServerData = getGameWorldServerDataByIndex(worldServerIdx - 1)
  local channelServerData = getGameChannelServerDataByIndex(worldServerIdx - 1, channelServerIdx - 1)
  if nil == channelServerIdx then
    return
  end
  if nil == channelServerData then
    return
  end
  local isBeingWar = channelServerData._isSiegeBeing
  local isVillageStart = channelServerData._isVillageSiege
  local changeChannelTime = getChannelMoveableRemainTime(worldServerData._worldNo)
  local changeMoveChannel = getChannelMoveableTime(worldServerData._worldNo)
  local changeRealChannelTime = convertStringFromDatetime(changeChannelTime)
  local btn_NormalSlot = UI.getChildControl(channelButtonBG, "Button_NormalServerSlot")
  local btn_ArshaSlot = UI.getChildControl(channelButtonBG, "Button_ArshaServerSlot")
  local btn_OlviaSlot = UI.getChildControl(channelButtonBG, "Button_OlviaServerSlot")
  local txt_ServerName = UI.getChildControl(channelButtonBG, "StaticText_Name")
  local txt_State = UI.getChildControl(channelButtonBG, "StaticText_State")
  local stc_highlightBG = UI.getChildControl(channelButtonBG, "Static_SelectGradation")
  local txt_enter = UI.getChildControl(stc_highlightBG, "StaticText_Enter")
  for ii = 1, 4 do
    local icon = UI.getChildControl(channelButtonBG, "Static_ChannelIcon" .. ii)
    icon:SetShow(false)
  end
  local stc_maintanance = UI.getChildControl(channelButtonBG, "Static_Maintanance")
  btn_NormalSlot:SetShow(false)
  btn_ArshaSlot:SetShow(false)
  btn_OlviaSlot:SetShow(false)
  txt_State:SetShow(false)
  stc_maintanance:SetShow(false)
  stc_highlightBG:SetShow(false)
  local serverSlotButton = btn_NormalSlot
  local isAdmission = true
  local restrictedServerNo = worldServerData._restrictedServerNo
  if restrictedServerNo ~= 0 then
    if restrictedServerNo == channelServerData._serverNo then
      isAdmission = true
    elseif changeChannelTime > toInt64(0, 0) then
      isAdmission = false
    else
      isAdmission = true
    end
  end
  local admissionDesc = ""
  if false == isAdmission then
    admissionDesc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_ISADMISSION_LIMIT", "admissionDesc", admissionDesc)
  else
    admissionDesc = ""
  end
  local channelName = getChannelName(worldServerData._worldNo, channelServerData._serverNo)
  _PA_ASSERT(nil ~= channelName, "\236\132\156\235\178\132 \236\157\180\235\166\132\236\157\128 \236\161\180\236\158\172\237\149\180\236\149\188\237\149\169\235\139\136\235\139\164.")
  local stateStr = ""
  local busyState = channelServerData._busyState
  if busyState == 0 or channelServerData:isClosed() then
    stateStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_0")
    stc_maintanance:SetShow(true)
  elseif busyState == 1 then
    stateStr = ""
  elseif busyState == 2 then
    stateStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_2")
  elseif busyState == 3 then
    stateStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_3")
  elseif busyState == 4 then
    stateStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_4")
  end
  txt_State:SetText(stateStr)
  if true == isLoginIDShow() then
    if changeChannelTime > toInt64(0, 0) and not isAdmission then
      txt_State:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANGECHANNEL", "changeRealChannelTime", changeRealChannelTime))
    end
  elseif not isAdmission and busyState ~= 0 then
    if changeChannelTime > toInt64(0, 0) then
      txt_State:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANGECHANNEL", "changeRealChannelTime", changeRealChannelTime))
    else
      txt_State:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANGECHANNEL", "changeRealChannelTime", 0))
    end
  end
  txt_State:SetPosY(channelButtonBG:GetSizeY() / 2 - txt_State:GetTextSizeY() / 2)
  if true == channelServerData._isSiegeChannel and isBeingWar then
    self:showChannelIcon(channelButtonBG, CHANNEL_TYPE.WAR_INFO)
  end
  if true == isGameServiceTypeDev() then
    channelName = channelName .. " " .. getDotIp(channelServerData) .. admissionDesc
  elseif true == isBeingWar then
    if true == isVillageStart then
      channelName = channelName .. " " .. admissionDesc .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_SERVERSELECT_LOCALWAR_BEING")
    else
      channelName = channelName .. " " .. admissionDesc .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_SERVERSELECT_TERRITORYWAR_BEING")
    end
  else
    channelName = channelName .. " " .. admissionDesc
  end
  txt_ServerName:SetText(channelName)
  txt_ServerName:SetShow(true)
  local temporaryWrapper = getTemporaryInformationWrapper()
  if channelServerData._isSpeedChannel then
    self:showChannelIcon(channelButtonBG, CHANNEL_TYPE.OLVIA_CHANNEL)
    serverSlotButton = btn_OlviaSlot
    if 0 ~= temporaryWrapper:getMyAdmissionToSpeedServer() or ToClient_IsDevelopment() then
      serverSlotButton:SetIgnore(false)
      serverSlotButton:SetMonoTone(false)
    else
      serverSlotButton:SetIgnore(true)
      serverSlotButton:SetMonoTone(true)
    end
  elseif channelServerData._isPcroomChannel then
    self:showChannelIcon(channelButtonBG, CHANNEL_TYPE.PC_ROOM_CHANNEL)
  elseif channelServerData._isDontPvPTendencyDecrease then
    serverSlotButton = btn_ArshaSlot
    self:showChannelIcon(channelButtonBG, CHANNEL_TYPE.ARSHA_CHANNEL)
  end
  serverSlotButton:addInputEvent("Mouse_LUp", "InputMLUp_ServerSelect_SelectChannel(" .. key32 .. ")")
  serverSlotButton:addInputEvent("Mouse_On", "InputMOn_ServerSelect_OverChannelControl(" .. key32 .. ")")
  serverSlotButton:addInputEvent("Mouse_Out", "InputMOut_ServerSelect_OutFromChannelControl()")
  serverSlotButton:SetShow(true)
  if BUTTON_STATE.SELECTED == self._currentButtonState and self._selectedChannelIndex == channelServerIdx then
    txt_State:SetShow(false)
    stc_maintanance:SetShow(false)
  elseif BUTTON_STATE.MAINSERVER_SELECT == self._currentButtonState then
    txt_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SELECT"))
    txt_State:SetShow(true)
    stc_maintanance:SetShow(false)
  elseif false == stc_maintanance:GetShow() then
    txt_State:SetShow(true)
  end
  if nil ~= channelServerIdx and self._selectedChannelIndex == channelServerIdx then
    stc_highlightBG:SetShow(true)
    if not isAdmission then
      txt_enter:SetFontColor(Defines.Color.C_FF525B6D)
      serverSlotButton:addInputEvent("Mouse_LUp", "")
    else
      txt_enter:SetFontColor(Defines.Color.C_FFEEEEEE)
    end
  else
    stc_highlightBG:SetShow(false)
  end
  local stc_overBG = UI.getChildControl(channelButtonBG, "Static_SelectHighlight")
  if key32 == self._currentHoveredKey32 then
    stc_overBG:SetShow(true)
    if true == _startAnimationFinished then
      _listContentsTarget[key32] = _listContentsBaseX - 10
      _listContentsFlag[key32] = true
    else
      _listContentsTarget[key32] = _listContentsBaseX
      _listContentsFlag[key32] = true
    end
  else
    stc_overBG:SetShow(false)
  end
end
function ServerSelectRemaster:showChannelIcon(buttonBG, iconIndex, monotone)
  for ii = 1, 4 do
    local stc = UI.getChildControl(buttonBG, "Static_ChannelIcon" .. ii)
    if false == stc:GetShow() then
      stc:ChangeTextureInfoName("renewal/ui_icon/console_icon_01.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(stc, _channelIconUV[iconIndex][1], _channelIconUV[iconIndex][2], _channelIconUV[iconIndex][3], _channelIconUV[iconIndex][4])
      stc:getBaseTexture():setUV(x1, y1, x2, y2)
      stc:setRenderTexture(stc:getBaseTexture())
      local name = UI.getChildControl(buttonBG, "StaticText_Name")
      stc:SetPosX(name:GetSpanSize().x + name:GetTextSizeX() + 10 + (ii - 1) * stc:GetSizeX())
      stc:SetShow(true)
      stc:SetMonoTone(true == monotone)
      break
    end
  end
end
function ServerSelectRemaster:updateTextOnButtons()
  local worldServerData = getGameWorldServerDataByIndex(self._selectedWorldIndex - 1)
  if nil == worldServerData then
    return
  end
  local mainServerNo = ToClient_getUserSubCacheData(__eMainServerNo)
  local temporaryWrapper = getTemporaryInformationWrapper()
  local mainServerName = getChannelName(worldServerData._worldNo, mainServerNo)
  if -1 ~= mainServerNo then
    self._ui.btn_mainServer:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SETMAINSERVER", "serverName", tostring(mainServerName)))
  end
  local lastServerNo = temporaryWrapper:getLastServerNo()
  if nil == getChannelName(worldServerData._worldNo, lastServerNo) then
    self._ui.btn_recentServer:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_LASTJOINSERVER_NONE"))
  else
    self._ui.btn_recentServer:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_RECENT_SERVER", "lastJoinServer", tostring(getChannelName(worldServerData._worldNo, lastServerNo))))
  end
  self._ui.btn_recentServer:SetTextSpan(15, self._ui.btn_recentServer:GetSizeY() / 2 - self._ui.btn_recentServer:GetTextSizeY() / 2)
end
function InputMLUp_ServerSelect_SelectWorld(worldIndex)
  InputMLUp_ServerSelect_SelectChannel(nil)
  if isGameServiceTypeKor() and false == ToClient_IsDevelopment() then
    local isAdultUser = ToClient_isAdultUser()
    local isAdultWorld
    local serverData = getGameChannelServerDataByIndex(worldIndex - 1, 0)
    if serverData == nil then
      isAdultWorld = true
    else
      isAdultWorld = serverData._isAdultWorld
    end
    if isAdultUser ~= isAdultWorld then
      local msg = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_ADULT_CANT_CONNECT")
      if false == isAdultWorld then
        msg = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_NONADULT_CANT_CONNECT")
      end
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
        content = msg,
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
      return
    end
    if true == isAdultUser and true == isAdultWorld then
      self:updateSingleWorldDesc(false)
    elseif false == isAdultUser and false == isAdultWorld then
      self:updateSingleWorldDesc(true)
    end
    if false == isAdultUser and false == ToClient_CanEnterNonAdultWorld() then
      return
    end
  end
  self._currentButtonState = BUTTON_STATE.NORMAL
  local key = self._treeMainBranchKey[worldIndex]
  for ii = 1, #self._treeMainBranchKey do
    local mainElement = self._ui.tree_server:getElementManager():getByKey(toInt64(0, self._treeMainBranchKey[ii]), false)
    mainElement:setIsOpen(false)
  end
  local selectedElement = self._ui.tree_server:getElementManager():getByKey(toInt64(0, key))
  selectedElement:setIsOpen(true)
  self._ui.tree_server:getElementManager():refillKeyList()
  self._ui.tree_server:moveTopIndex()
  self._selectedWorldIndex = worldIndex
end
function ServerSelectRemaster:updateSingleWorldDesc(isTeen)
  local parent = self._ui.stc_channelDesc[CHANNEL_TYPE.SINGLE_WORLD_SYSTEM]
  local txt_title = UI.getChildControl(parent, "StaticText_Title")
  local txt_desc = UI.getChildControl(parent, "StaticText_Desc")
  if isTeen then
    txt_desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_CHANNELSELECTDESC_15"))
  else
    txt_desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_CHANNELSELECTDESC"))
  end
  parent:SetSize(parent:GetSizeX(), txt_title:GetSizeY() + txt_desc:GetTextSizeY() + 15)
  parent:ComputePos()
end
function InputMLUp_ServerSelect_SelectChannel(key32)
  if nil == key32 then
    if nil ~= self._selectedChannelIndex then
      local oldSelect = self._selectedChannelIndex
      self._selectedChannelIndex = nil
      self._ui.tree_server:requestUpdateByKey(toInt64(0, oldSelect))
    end
    self._ui.stc_divideLines[1]:SetShow(false)
    self._ui.txt_serverName:SetText("")
    for ii = 2, #self._ui.stc_channelDesc do
      self._ui.stc_channelDesc[ii]:SetShow(false)
    end
    return
  end
  _listContentsTarget[key32] = _listContentsBaseX - 10
  _listContentsFlag[key32] = true
  if nil == self._treeData[key32] then
    return
  end
  local worldServerIdx = self._treeData[key32].worldIndex
  local channelServerIdx = self._treeData[key32].channelIndex
  local worldServerData = getGameWorldServerDataByIndex(worldServerIdx - 1)
  local channelServerData = getGameChannelServerDataByIndex(worldServerIdx - 1, channelServerIdx - 1)
  local channelName = getChannelName(worldServerData._worldNo, channelServerData._serverNo)
  self._ui.txt_serverName:SetText(channelName)
  if BUTTON_STATE.MAINSERVER_SELECT == self._currentButtonState then
    self._selectedChannelIndex = nil
    self._ui.stc_divideLines[2]:SetShow(false)
    for ii = 2, #self._ui.stc_channelDesc do
      self._ui.stc_channelDesc[ii]:SetShow(false)
    end
    self:SetMainServer(worldServerIdx, channelServerIdx)
    return
  end
  if self._selectedWorldIndex ~= worldServerIdx or self._selectedChannelIndex ~= channelServerIdx then
    self._selectedWorldIndex = worldServerIdx
    self._selectedChannelIndex = channelServerIdx
    local channelServerData = getGameChannelServerDataByIndex(worldServerIdx - 1, channelServerIdx - 1)
    if nil == channelServerData then
      return
    end
    local isBeingWar = channelServerData._isSiegeBeing
    local isVillageStart = channelServerData._isVillageSiege
    local channelType
    if channelServerData._isSpeedChannel then
      channelType = CHANNEL_TYPE.OLVIA_CHANNEL
    elseif channelServerData._isPcroomChannel then
      channelType = CHANNEL_TYPE.PC_ROOM_CHANNEL
    elseif channelServerData._isDontPvPTendencyDecrease then
      channelType = CHANNEL_TYPE.ARSHA_CHANNEL
    elseif channelServerData._isSiegeChannel then
      channelType = CHANNEL_TYPE.WAR_INFO
    end
    for ii = 2, #self._ui.stc_channelDesc do
      self._ui.stc_channelDesc[ii]:SetShow(false)
    end
    if nil ~= self._ui.stc_channelDesc[channelType] then
      self._ui.stc_channelDesc[channelType]:SetPosY(self._currentDescriptionY)
      self._ui.stc_channelDesc[channelType]:SetShow(true)
      self._ui.stc_channelDesc[channelType]:SetAlphaExtraChild(0)
      UIAni.AlphaAnimation(1, self._ui.stc_channelDesc[channelType], 0, 0.8)
      if false == self._ui.stc_divideLines[1]:GetShow() then
        self._ui.stc_divideLines[1]:SetShow(true)
        self._ui.stc_divideLines[1]:SetAlphaExtraChild(0)
        UIAni.AlphaAnimation(1, self._ui.stc_divideLines[1], 0, 0.8)
      end
    end
    self._currentButtonState = BUTTON_STATE.SELECTED
    self._ui.tree_server:getElementManager():refillKeyList()
  else
    local channelServerData = getGameChannelServerDataByIndex(worldServerIdx - 1, channelServerIdx - 1)
    if nil == channelServerData then
      return
    end
    if channelServerData._isPcroomChannel then
    end
    InputMLUp_ServerSelect_EnterChannel(key32)
  end
end
function InputMLUp_ServerSelect_EnterChannel(key32)
  if nil == self._treeData[key32] then
    return
  end
  local worldIndex = self._treeData[key32].worldIndex
  local serverIdx = self._treeData[key32].channelIndex
  if isGameServiceTypeKor() and false == ToClient_isAdultUser() and false == ToClient_CanEnterNonAdultWorld() then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CANT_CONNECTABLE_TIME"),
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    self:enableButton(false)
    return
  end
  if true == selectServerGroup(worldIndex - 1, serverIdx - 1) then
    self:enableButton(false)
  end
end
function ServerSelectRemaster:enableButton(bool)
  local elementCount = self._ui.tree_server
end
function InputMLUp_ServerSelect_EnterLastJoinedServer()
  local tempWrapper = getTemporaryInformationWrapper()
  local lastJoinServerNo = tempWrapper:getLastServerNo()
  if 1 == lastJoinServerNo then
    return
  end
  for ii = 1, #self._treeData do
    if nil ~= self._treeData[ii].channelIndex then
      local serverData = getGameChannelServerDataByIndex(self._selectedWorldIndex - 1, self._treeData[ii].channelIndex - 1)
      if nil ~= serverData and lastJoinServerNo == serverData._serverNo then
        PaGlobalFunc_ServerSelectRemaster_EnterMemorizedChannel(self._treeData[ii].channelIndex)
        break
      end
    end
  end
end
function InputMLUp_ServerSelect_EnterRandomServer()
  if isGameServiceTypeKor() and false == ToClient_IsDevelopment() and false == ToClient_CanEnterNonAdultWorld() then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CANT_CONNECTABLE_TIME"),
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  selectRandomServer(self._selectedWorldIndex - 1)
end
function PaGlobalFunc_ServerSelectRemaster_EnterMemorizedChannel(channelIdx)
  local channelServerData = getGameChannelServerDataByIndex(self._selectedWorldIndex - 1, channelIdx - 1)
  if nil == channelServerData then
    return
  end
  if channelServerData._isPcroomChannel then
  end
  if isGameServiceTypeKor() and false == ToClient_IsDevelopment() and false == ToClient_CanEnterNonAdultWorld() then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CANT_CONNECTABLE_TIME"),
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  selectMemorizedServer(self._selectedWorldIndex - 1, channelIdx - 1)
end
function InputMLUp_ServerSelect_EnterMainServer()
  if PaGlobalFunc_ServerSelectAutoConnectToLastServer() then
    return
  end
  local mainServerNo = ToClient_getUserSubCacheData(__eMainServerNo)
  if -1 == mainServerNo then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_MAINSERVERTITLE"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_MAINSERVERALERT"),
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  local worldServerIdx = self._treeData[self._selectedWorldIndex].worldIndex
  local worldServerData = getGameWorldServerDataByIndex(worldServerIdx - 1)
  local restrictedServerNo = worldServerData._restrictedServerNo
  if 0 ~= restrictedServerNo and mainServerNo ~= restrictedServerNo then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_MAINSERVERTITLE"),
      content = PAGetString(Defines.StringSheet_SymbolNo, "eErrNoChannelMoveableTimeIsInvalid"),
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  for ii = 1, #self._treeData do
    if nil ~= self._treeData[ii].channelIndex then
      local serverData = getGameChannelServerDataByIndex(worldServerIdx - 1, self._treeData[ii].channelIndex - 1)
      if nil ~= serverData and mainServerNo == serverData._serverNo then
        PaGlobalFunc_ServerSelectRemaster_EnterMemorizedChannel(self._treeData[ii].channelIndex)
        break
      end
    end
  end
end
function PaGlobalFunc_ServerSelectAutoConnectToLastServer()
  local rv = ToClient_CheckToMoveChannel()
  if 0 == rv then
    return false
  end
  local tempWrapper = getTemporaryInformationWrapper()
  local lastJoinServerNo = tempWrapper:getLastServerNo()
  if lastJoinServerNo <= 1 then
    return
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_AUTO_CONNECT_TO_LAST_SERVER_WHEN_RESTRICTED_TO_MOVE_CHANNEL"),
    functionYes = InputMLUp_ServerSelect_EnterLastJoinedServer,
    exitButton = false,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1
  }
  MessageBox.showMessageBox(messageBoxData)
  return true
end
function InputMLUp_ServerSelect_ChangeMainServer()
  if BUTTON_STATE.MAINSERVER_SELECT ~= self._currentButtonState then
    self._currentButtonState = BUTTON_STATE.MAINSERVER_SELECT
  else
    self._currentButtonState = BUTTON_STATE.NORMAL
  end
  self._selectedChannelIndex = nil
  self:updateListData()
end
function ServerSelectRemaster:SetMainServer(worldIndex, serverIndex)
  local worldServerData = getGameWorldServerDataByIndex(worldIndex - 1)
  local serverData = getGameChannelServerDataByIndex(worldIndex - 1, serverIndex - 1)
  if nil == serverData then
    Proc_ShowMessage_Ack("\236\158\152\235\170\187\235\144\156 \236\132\156\235\178\132 \236\160\149\235\179\180\236\158\133\235\139\136\235\139\164. \235\139\164\236\139\156 \236\139\156\235\143\132\237\149\180\236\163\188\236\132\184\236\154\148.")
    return
  end
  local function Set_MainServer()
    local serverData = getGameChannelServerDataByIndex(worldIndex - 1, serverIndex - 1)
    local serverNo = serverData._serverNo
    ToClient_setUserSubCacheData(__eMainServerNo, serverNo)
    self._currentButtonState = BUTTON_STATE.NORMAL
    self:updateListData()
    self:updateTextOnButtons()
  end
  local serverName = getChannelName(worldServerData._worldNo, serverData._serverNo)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_MAINSERVERTITLE"),
    content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_MAINSERVERCONTENT", "serverName", serverName),
    functionApply = Set_MainServer,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_ServerSelect_EventUpdateServerInfo()
  local isShow = _panel:IsShow()
  if false == isShow then
    self:init()
    PaGlobal_ServerSelect_Resize()
    self:open()
  else
    self:initTreeData()
  end
end
function PaGlobal_ServerSelect_Resize()
  _panel:SetSize(getScreenSizeX(), getScreenSizeY())
  self._ui.stc_rightBg:SetSize(self._ui.stc_rightBg:GetSizeX(), getScreenSizeY())
  self._ui.stc_leftBg:SetSize(self._ui.stc_leftBg:GetSizeX(), getScreenSizeY())
  self._ui.stc_rightBg:ComputePos()
  self._ui.stc_leftBg:ComputePos()
  if true == _startAnimationFinished then
    self._ui.stc_leftBg:SetPosX(0)
  end
  self._ui.tree_server:SetSize(self._ui.tree_server:GetSizeX(), getScreenSizeY() - 250)
  self._ui.tree_server:ComputePos()
  self._ui.txt_serverSelectTitle:ComputePos()
  self._ui.btn_mainServer:ComputePos()
  self._ui.btn_mainServerSelect:ComputePos()
  self._ui.btn_recentServer:ComputePos()
  self._ui.btn_randomServer:ComputePos()
  self._ui.stc_channelDesc[CHANNEL_TYPE.SINGLE_WORLD_SYSTEM]:ComputePos()
end
_stc_BackgroundImage[currentBackIndex]:SetShow(true)
_stc_BackgroundImage[currentBackIndex]:SetAlpha(1)
local _startAnimationFlag = false
local _animationDelay = 0.5
local _animationDelayCount = 0
function PaGlobal_ServerSelect_PerFrameUpdate(deltaTime)
  local component = self._ui.stc_channelDesc[CHANNEL_TYPE.SINGLE_WORLD_SYSTEM]
  local txt_desc = UI.getChildControl(component, "StaticText_Desc")
  luaTimer_UpdatePerFrame(deltaTime)
  _updateTimeAcc = _updateTimeAcc - deltaTime
  if _updateTimeAcc <= 0 then
    _updateTimeAcc = 15
    self:updateListData()
    if _isScope then
      _stc_BackgroundImage[currentBackIndex]:SetShow(true)
      _isScope = false
      local FadeMaskAni = _stc_BackgroundImage[currentBackIndex]:addTextureUVAnimation(0, 15, 0)
      FadeMaskAni:SetStartUV(startUV, startUV, 0)
      FadeMaskAni:SetEndUV(endUV, startUV, 0)
      FadeMaskAni:SetStartUV(startUV2, startUV, 1)
      FadeMaskAni:SetEndUV(endUV2, startUV, 1)
      FadeMaskAni:SetStartUV(startUV, startUV2, 2)
      FadeMaskAni:SetEndUV(endUV, startUV2, 2)
      FadeMaskAni:SetStartUV(startUV2, startUV2, 3)
      FadeMaskAni:SetEndUV(endUV2, startUV2, 3)
    else
      _isScope = true
      local FadeMaskAni = _stc_BackgroundImage[currentBackIndex]:addTextureUVAnimation(0, 15, 0)
      FadeMaskAni:SetEndUV(startUV, startUV, 0)
      FadeMaskAni:SetStartUV(endUV, startUV, 0)
      FadeMaskAni:SetEndUV(startUV2, startUV, 1)
      FadeMaskAni:SetStartUV(endUV2, startUV, 1)
      FadeMaskAni:SetEndUV(startUV, startUV2, 2)
      FadeMaskAni:SetStartUV(endUV, startUV2, 2)
      FadeMaskAni:SetEndUV(startUV2, startUV2, 3)
      FadeMaskAni:SetStartUV(endUV2, startUV2, 3)
      local fadeColor = _stc_BackgroundImage[currentBackIndex]:addColorAnimation(15, 17, 0)
      fadeColor:SetStartColor(Defines.Color.C_FFFFFFFF)
      fadeColor:SetEndColor(Defines.Color.C_00FFFFFF)
      currentBackIndex = currentBackIndex + 1
      if totalBG < currentBackIndex then
        currentBackIndex = getRandomValue(1, totalBG)
      end
      local baseTexture = _stc_BackgroundImage[currentBackIndex]:getBaseTexture()
      baseTexture:setUV(startUV, startUV, startUV2, startUV2)
      _stc_BackgroundImage[currentBackIndex]:setRenderTexture(baseTexture)
      local fadeColor2 = _stc_BackgroundImage[currentBackIndex]:addColorAnimation(12, 15, 0)
      fadeColor2:SetStartColor(Defines.Color.C_00FFFFFF)
      fadeColor2:SetEndColor(Defines.Color.C_FFFFFFFF)
    end
  end
  if false == _startAnimationFlag then
    _animationDelayCount = _animationDelayCount + deltaTime
    if _animationDelayCount > _animationDelay then
      self:playAnimation()
    end
    if _animationDelayCount > 1 then
      if false == _moviePlayed then
        self:startFadeIn()
        self._ui.stc_movieBG:SetShow(false)
      end
      _startAnimationFlag = true
      _startAnimationFinished = true
      self:initTreeLateUpdate()
    end
  end
  for ii = 1, _treeSize do
    if true == _listContentsFlag[ii] then
      self:animateListComponents(deltaTime, ii)
    end
    if true == _listContentsAlphaFlag[ii] then
      self:animateListComponentsAlpha(deltaTime, ii)
    end
  end
  if true == _listContentsShowAniFlag then
    self:playListComponentsAni(deltaTime)
  end
  if true == _frameAnimationFlag then
    self:animateFrame(deltaTime)
  end
  self._ui.tree_server:ComputePos()
end
function ServerSelectRemaster:playAnimation()
  if false == _startAnimationFinished then
    _listContentsShowAniFlag = true
  end
end
function ServerSelectRemaster:playListComponentsAni(deltaTime)
  _listContentsLaunchElapsed = _listContentsLaunchElapsed + deltaTime
  local content = _listContents[_listContentsLaunchedCount]
  if _listContentsLaunchedCount == _treeSize + 1 or _listContentsLaunchedCount == self._ui.tree_server:getChildContentListSize() + 1 or nil == _listContentsLaunchTimeTable[_listContentsLaunchedCount] then
    _listContentsShowAniFlag = false
    return
  elseif nil ~= content and nil ~= content.SetShow and _listContentsLaunchElapsed >= _listContentsLaunchTimeTable[_listContentsLaunchedCount] then
    content:SetShow(true)
    _listContentsAlphaFlag[_listContentsLaunchedCount] = true
    _listContentsAlphaTarget[_listContentsLaunchedCount] = 1
    _listContentsLaunchedCount = _listContentsLaunchedCount + 1
  end
end
function ServerSelectRemaster:animateListComponents(deltaTime, index)
  local content = _listContents[index]
  if nil == content or nil == _listContentsTarget[index] then
    return
  end
  local currentPos = content:GetPosX()
  local distance = _listContentsTarget[index] - currentPos
  local acc = distance / 100 * deltaTime * 10
  if acc > -1 and acc < 0 then
    acc = -1
  elseif acc < 1 and acc > 0 then
    acc = 1
  end
  if 1 < math.abs(distance) then
    content:SetPosX(currentPos + acc)
  else
    content:SetPosX(_listContentsTarget[index])
    _listContentsFlag[index] = false
  end
end
function ServerSelectRemaster:animateListComponentsAlpha(deltaTime, index)
  local content = _listContents[index]
  if nil == content or nil == _listContentsAlphaTarget[index] then
    return
  end
  local currentAlpha = content:GetAlpha()
  local distance = _listContentsAlphaTarget[index] - currentAlpha
  local acc = distance * deltaTime * 5
  if 0.01 < math.abs(distance) then
    local nextAlpha = currentAlpha + acc
    content:SetAlphaExtraChild(nextAlpha)
    local worldBG = UI.getChildControl(content, "Static_WorldButtonBG")
    local worldBtn = UI.getChildControl(worldBG, "Button_NormalServerSlot")
    worldBtn:SetAlpha(nextAlpha * 0.8)
    local channelBG = UI.getChildControl(content, "Static_ChannelButtonBG")
    local channelBtn = UI.getChildControl(channelBG, "Button_NormalServerSlot")
    channelBtn:SetAlpha(nextAlpha * 0.8)
    local channelSelect = UI.getChildControl(channelBG, "Static_SelectGradation")
    channelSelect:SetAlpha(nextAlpha * 0.9)
    local channelSelectYellow = UI.getChildControl(channelSelect, "Static_SelectYellow")
    channelSelectYellow:SetAlpha(nextAlpha * 0.7)
  else
    content:SetAlphaExtraChild(_listContentsAlphaTarget[index])
    _listContentsAlphaFlag[index] = false
    local worldBG = UI.getChildControl(content, "Static_WorldButtonBG")
    local worldBtn = UI.getChildControl(worldBG, "Button_NormalServerSlot")
    worldBtn:SetAlpha(_listContentsAlphaTarget[index] * 0.8)
    local channelBG = UI.getChildControl(content, "Static_ChannelButtonBG")
    local channelBtn = UI.getChildControl(channelBG, "Button_NormalServerSlot")
    channelBtn:SetAlpha(_listContentsAlphaTarget[index] * 0.8)
    local channelSelect = UI.getChildControl(channelBG, "Static_SelectGradation")
    channelSelect:SetAlpha(_listContentsAlphaTarget[index] * 0.9)
    local channelSelectYellow = UI.getChildControl(channelSelect, "Static_SelectYellow")
    channelSelectYellow:SetAlpha(_listContentsAlphaTarget[index] * 0.7)
  end
end
function InputMOn_ServerSelect_SelectWorldTooltip(worldIndex)
end
function InputMOn_ServerSelect_OverChannelControl(key32)
  if false == self:isHitTest(_listContents[key32]) then
    return
  end
  if _startAnimationFinished then
    for ii = 1, #_listContentsTarget do
      _listContentsTarget[ii] = _listContentsBaseX
    end
  end
  local oldIndex = self._currentHoveredKey32
  self._currentHoveredKey32 = key32
  if nil ~= oldIndex then
    self._ui.tree_server:requestUpdateByKey(toInt64(0, oldIndex))
  end
  self._ui.tree_server:requestUpdateByKey(toInt64(0, key32))
end
function ServerSelectRemaster:isHitTest(control)
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  local bgPosX = control:GetParentPosX()
  local bgPosY = control:GetParentPosY()
  local bgSizeX = control:GetSizeX()
  local bgSizeY = control:GetSizeY()
  if mousePosX >= bgPosX and mousePosX <= bgPosX + bgSizeX and mousePosY >= bgPosY and mousePosY <= bgPosY + bgSizeY then
    return true
  end
  return false
end
function InputMOut_ServerSelect_OutFromChannelControl()
  if _startAnimationFinished then
    for ii = 1, _listContentsCount do
      _listContentsTarget[ii] = _listContentsBaseX
      _listContentsFlag[ii] = true
    end
  end
end
function InputMOut_ServerSelect_SelectServer(index)
end
function PaGlobal_ServerSelect_Init()
  self:init()
  PaGlobal_ServerSelect_Resize()
  self:open()
end
PaGlobal_ServerSelect_Init()
function InitServerSelectMoviePanel()
  _PA_LOG("COHERENT", "InitServerSelectMoviePanel")
  self:PlayMovie()
end
function RegisterEvent()
  registerEvent("FromClient_luaLoadCompleteLateUdpate", "InitServerSelectMoviePanel")
end
RegisterEvent()

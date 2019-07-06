local _panel = Panel_Lobby_ServerSelect_Renew
local ServerSelect = {
  _ui = {
    stc_leftBg = UI.getChildControl(_panel, "Static_DescriptionBG"),
    stc_movieBG = UI.getChildControl(_panel, "Static_MovieBG"),
    stc_fade = UI.getChildControl(_panel, "Static_MovieFade"),
    txt_ServerSelectTitle = UI.getChildControl(_panel, "StaticText_ServerSelectTitle"),
    stc_RightBg = UI.getChildControl(_panel, "Static_RightBg"),
    stc_bannerArea = UI.getChildControl(_panel, "Static_BannerArea"),
    stc_bannerArea_obt = UI.getChildControl(_panel, "Static_BannerArea2")
  },
  _serverIdxData = {},
  _lastConnectedServerIdx = 0,
  _worldServerCount = 0,
  _selectedWorldIndex = 0,
  _maxWorldIndex = 0,
  _defaultYGap = 15,
  _currentBannerPage = 1,
  _inviteWorldIdx = nil,
  _inviteServerIdx = nil,
  _bannerIsReady = {}
}
local screenX = getScreenSizeX()
local screenY = getScreenSizeY()
_stc_BackgroundImage = Array.new()
local _movieLength = {
  10000,
  10000,
  10000
}
local _movieURL = {
  "coui://UI_Movie/Remaster_loading_Scene_003_re.webm",
  "coui://UI_Movie/Remaster_loading_Scene_004_re.webm",
  "coui://UI_Movie/Remaster_loading_Scene_011_re.webm"
}
local _movieOrder = {
  1,
  2,
  3
}
local _currentMovieIndex, _currentMovieIndex, _ui_web_loadingMovie
local bgItem = {"XBOnly"}
local bgIndex = {}
for k, v in pairs(bgItem) do
  bgIndex[v] = k
end
local openContent = ToClient_isConsole()
local baseLink = "New_UI_Common_forLua/Window/Loading/"
local bgManager = {
  [bgIndex.XBOnly] = {
    isOpen = openContent,
    imageCount = 7,
    iconPath = "xbox_loading_"
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
local CHANNEL_TYPE = {
  SINGLE_WORLD_SYSTEM = 1,
  WAR_INFO = 2,
  OLVIA_CHANNEL = 3,
  PC_ROOM_CHANNEL = 4,
  ARSHA_CHANNEL = 5
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
local self = ServerSelect
function ServerSelect:init()
  self._ui.stc_channelDesc = {}
  self._ui.stc_channelDesc[CHANNEL_TYPE.SINGLE_WORLD_SYSTEM] = UI.getChildControl(self._ui.stc_leftBg, "SINGLE_WORLD_SYSTEM")
  self._ui.stc_channelDesc[CHANNEL_TYPE.WAR_INFO] = UI.getChildControl(self._ui.stc_leftBg, "WAR_INFO")
  self._ui.stc_channelDesc[CHANNEL_TYPE.OLVIA_CHANNEL] = UI.getChildControl(self._ui.stc_leftBg, "OLVIA_CHANNEL")
  self._ui.stc_channelDesc[CHANNEL_TYPE.PC_ROOM_CHANNEL] = UI.getChildControl(self._ui.stc_leftBg, "PC_ROOM_CHANNEL")
  self._ui.stc_channelDesc[CHANNEL_TYPE.ARSHA_CHANNEL] = UI.getChildControl(self._ui.stc_leftBg, "ARSHA_CHANNEL")
  local topComponent = self._ui.stc_channelDesc[CHANNEL_TYPE.SINGLE_WORLD_SYSTEM]
  for ii = 1, #self._ui.stc_channelDesc do
    self:updateChannelDesc(ii)
    self._ui.stc_channelDesc[ii]:SetShow(false)
    if ii > CHANNEL_TYPE.SINGLE_WORLD_SYSTEM then
      self._ui.stc_channelDesc[ii]:SetPosY(topComponent:GetPosY() + topComponent:GetSizeY() + 10)
    end
  end
  self._ui.stc_channelDesc[CHANNEL_TYPE.SINGLE_WORLD_SYSTEM]:SetShow(true)
  self._ui.txt_WorldName = UI.getChildControl(self._ui.stc_RightBg, "StaticText_WorldName")
  self._ui.list_Server = UI.getChildControl(self._ui.stc_RightBg, "List2_ServerList")
  self._ui.list_Server:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_ServerSelect_ServerList_ControlCreate")
  self._ui.list_Server:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.btn_WorldTemplate = UI.getChildControl(self._ui.stc_RightBg, "Button_WorldTemplate")
  self._ui.txt_Select_ConsoleUI = UI.getChildControl(self._ui.stc_RightBg, "StaticText_Select_ConsoleUI")
  self._ui.txt_Back_ConsoleUI = UI.getChildControl(self._ui.stc_RightBg, "StaticText_Back_ConsoleUI")
  local keyGuides = {
    self._ui.txt_Select_ConsoleUI,
    self._ui.txt_Back_ConsoleUI
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.stc_RightBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self._ui.stc_fade:SetShow(false)
  self._ui.stc_movieBG:SetShow(false)
  local txt_version = UI.getChildControl(_panel, "StaticText_VersionString")
  txt_version:SetText("ver." .. tostring(ToClient_getVersionString()))
  self:registEventHandler()
  self:initListData()
end
function ServerSelect:initBanners()
  if true == _ContentsGroup_XB_Obt then
    self._ui.stc_bannerArea:SetShow(false)
    self._ui.stc_bannerArea_obt:SetShow(true)
    return
  elseif false == _ContentsGroup_Console_WebBanner then
    self._ui.stc_bannerArea:SetShow(false)
    self._ui.stc_bannerArea_obt:SetShow(false)
    return
  end
  self._ui.stc_bannerArea_obt:SetShow(false)
  self._ui.stc_bannerArea:SetShow(true)
  self._ui.stc_bannerBGs = {
    [0] = UI.getChildControl(self._ui.stc_bannerArea, "Static_TopBanner"),
    [1] = UI.getChildControl(self._ui.stc_bannerArea, "Static_MidBanner"),
    [2] = UI.getChildControl(self._ui.stc_bannerArea, "Static_BottomBanner")
  }
  local domainURL = ""
  if nil ~= ToClient_getXBoxBannerURL then
    domainURL = ToClient_getXBoxBannerURL()
  end
  if nil == domainURL or "" == domainURL then
    domainURL = "https://dev-game-portal.xbox.playblackdesert.com/Banner?bannerType="
  else
    domainURL = "https://" .. domainURL .. "/Banner?bannerType="
  end
  domainURL = domainURL .. "0&bannerPosition="
  self._ui.web_banners = {}
  for ii = 0, #self._ui.stc_bannerBGs do
    self._ui.web_banners[ii] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, self._ui.stc_bannerBGs[ii], "web_topBanner" .. ii)
    self._ui.web_banners[ii]:SetSize(self._ui.stc_bannerBGs[ii]:GetSizeX() - 20, self._ui.stc_bannerBGs[ii]:GetSizeY() - 20)
    self._ui.web_banners[ii]:SetHorizonCenter()
    self._ui.web_banners[ii]:SetVerticalMiddle()
    self._ui.web_banners[ii]:SetUrl(self._ui.web_banners[ii]:GetSizeX(), self._ui.web_banners[ii]:GetSizeY(), domainURL .. tostring(ii), false, true)
    self._ui.web_banners[ii]:addInputEvent("Mouse_On", "InputMOn_ServerSelect_OverWebBanner(true)")
    self._ui.web_banners[ii]:addInputEvent("Mouse_Out", "InputMOn_ServerSelect_OverWebBanner(false)")
    self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_LB, "Input_ServerSelect_ToWebBanner(\"LB\", " .. ii .. ")")
    self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_RB, "Input_ServerSelect_ToWebBanner(\"RB\", " .. ii .. ")")
    self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "Input_ServerSelect_ToWebBanner(\"CLICK\", " .. ii .. ")")
    if true == ToClient_isPS4() then
      self._ui.web_banners[ii]:SetIgnore(true)
      self._ui.stc_bannerBGs[ii]:SetIgnore(true)
      self._ui.web_banners[ii]:addInputEvent("Mouse_On", "")
      self._ui.web_banners[ii]:addInputEvent("Mouse_Out", "")
      self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_LB, "")
      self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_RB, "")
      self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
    end
  end
  local keyGuideLB = UI.getChildControl(self._ui.stc_bannerBGs[1], "StaticText_KeyGuideLB")
  local keyGuideRB = UI.getChildControl(self._ui.stc_bannerBGs[1], "StaticText_KeyGuideRB")
  self._ui.stc_bannerBGs[1]:SetChildIndex(keyGuideLB, self._ui.stc_bannerBGs[1]:GetChildSize())
  self._ui.stc_bannerBGs[1]:SetChildIndex(keyGuideRB, self._ui.stc_bannerBGs[1]:GetChildSize())
end
function ServerSelect:registEventHandler()
  if true == ToClient_IsDevelopment() then
  end
  registerEvent("FromClient_luaLoadCompleteLateUdpate", "PaGlobalFunc_ServerSelect_LateUpdate")
  registerEvent("FromClient_ShowXboxInviteMessage", "FromClient_ServerSelect_ShowXboxInviteMessage")
  registerEvent("FromClient_WebUIBannerEventForXBOX", "FromClient_WebUIBannerEventForXBOX_ServerSelect")
  registerEvent("FromClient_WebUIBannerIsReadyForXBOX", "FromClient_WebUIBannerIsReadyForXBOX_ServerSelect")
  registerEvent("EventUpdateServerInformationForServerSelect", "PaGlobal_ServerSelect_EventUpdateServerInfo")
  registerEvent("onScreenResize", "PaGlobal_ServerSelect_Resize")
  registerEvent("FromClient_UnpackUserGameVariable", "PaGlobal_ServerSelect_Resize")
  _panel:RegisterUpdateFunc("PaGlobal_ServerSelect_PerFrameUpdate")
end
function ServerSelect:updateChannelDesc(channelType)
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
function ServerSelect:updateListData()
  if true == ToClient_IsDevelopment() then
    self:developUpdateListData_XXX()
  else
    self:updateListData_XXX()
  end
end
function ServerSelect:developUpdateListData_XXX()
  local channelIdx = 0
  self._maxWorldIndex = getGameWorldServerDataCount()
  for worldIdx = 0, self._maxWorldIndex do
    local worldServerData = getGameWorldServerDataByIndex(worldIdx)
    if nil == worldServerData then
      return
    end
    local serverCount = getGameChannelServerDataCount(worldServerData._worldNo)
    for serverIndex = 0, serverCount - 1 do
      self._ui.list_Server:requestUpdateByKey(toInt64(0, channelIdx))
      channelIdx = channelIdx + 1
    end
  end
end
function ServerSelect:updateListData_XXX()
  local channelIdx = 0
  local worldServerData = getGameWorldServerDataByIndex(self._selectedWorldIndex)
  local serverCount = getGameChannelServerDataCount(worldServerData._worldNo)
  for serverIndex = 0, serverCount - 1 do
    self._ui.list_Server:requestUpdateByKey(toInt64(0, channelIdx))
    channelIdx = channelIdx + 1
  end
end
function InputMOn_ServerSelect_OverWebBanner(isOn)
  local self = ServerSelect
  self._ui.txt_Select_ConsoleUI:SetShow(isOn)
end
function Input_ServerSelect_ToWebBanner(key, bannerIndex)
  local self = ServerSelect
  if "CLICK" == key and not self._bannerIsReady[bannerIndex] then
    MessageBox.showMessageBox({
      content = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WEBCONTROL_PAGE_NOT_READY"),
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    })
    return
  end
  self._ui.web_banners[bannerIndex]:TriggerEvent("FromClient_GamePadInputForWebBanner", key)
end
function FromClient_WebUIBannerEventForXBOX_ServerSelect(linkType, link)
  if Defines.ConsoleBannerLinkType.InGameWeb == linkType then
    PaGlobalFunc_WebControl_Open(link)
  else
    MessageBox.showMessageBox({
      content = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WEBCONTROL_PAGE_NOT_READY"),
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    })
  end
end
function FromClient_WebUIBannerIsReadyForXBOX_ServerSelect(bannerType, bannerIndex)
  _PA_LOG("\235\176\149\235\178\148\236\164\128", "FromClient_WebUIBannerIsReadyForXBOX_ServerSelect bannerIndex  :" .. bannerIndex)
  local self = ServerSelect
  if 0 == bannerType then
    self._bannerIsReady[bannerIndex] = true
  end
end
function ServerSelect:initListData()
  if true == ToClient_IsDevelopment() then
    self:developInitListData_XXX()
  else
    self:initListData_XXX()
  end
  PaGlobal_CheckGamerTag()
end
function ServerSelect:developInitListData_XXX()
  local worldServerCount = getGameWorldServerDataCount()
  local channelIdx = 0
  self._maxWorldIndex = getGameWorldServerDataCount()
  self._ui.list_Server:getElementManager():clearKey()
  for worldIdx = 0, self._maxWorldIndex do
    local worldServerData = getGameWorldServerDataByIndex(worldIdx)
    if nil == worldServerData then
      return
    end
    local worldName = getWorldNameByWorldNo(worldServerData._worldNo)
    if true == ToClient_isConsole() then
      worldName = "Black Desert World"
    end
    self._ui.txt_WorldName:SetText(worldName)
    if isGameServiceTypeKor() and false == ToClient_IsDevelopment() then
      local serverData = getGameChannelServerDataByIndex(worldIdx, 0)
      local isAdultWorld
      if serverData == nil then
        isAdultWorld = true
      else
        isAdultWorld = serverData._isAdultWorld
      end
      local isAdultUser = ToClient_isAdultUser()
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
    end
    local serverCount = getGameChannelServerDataCount(worldServerData._worldNo)
    for serverIndex = 0, serverCount - 1 do
      local serverIdxData = {}
      serverIdxData.worldIdx = worldIdx
      serverIdxData.serverIdx = serverIndex
      self._serverIdxData[channelIdx] = serverIdxData
      self._ui.list_Server:getElementManager():pushKey(toInt64(0, channelIdx))
      channelIdx = channelIdx + 1
    end
  end
end
function ServerSelect:initListData_XXX()
  local worldServerCount = getGameWorldServerDataCount()
  local channelIdx = 0
  self._maxWorldIndex = getGameWorldServerDataCount()
  self._ui.list_Server:getElementManager():clearKey()
  local worldServerData = getGameWorldServerDataByIndex(self._selectedWorldIndex)
  if nil == worldServerData then
    return
  end
  local worldName = getWorldNameByWorldNo(worldServerData._worldNo)
  if true == ToClient_isConsole() then
    worldName = "Black Desert World"
  end
  self._ui.txt_WorldName:SetText(worldName)
  if isGameServiceTypeKor() and false == ToClient_IsDevelopment() then
    local serverData = getGameChannelServerDataByIndex(self._selectedWorldIndex, 0)
    local isAdultWorld
    if serverData == nil then
      isAdultWorld = true
    else
      isAdultWorld = serverData._isAdultWorld
    end
    local isAdultUser = ToClient_isAdultUser()
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
  end
  local serverCount = getGameChannelServerDataCount(worldServerData._worldNo)
  for serverIndex = 0, serverCount - 1 do
    local serverIdxData = {}
    serverIdxData.worldIdx = self._selectedWorldIndex
    serverIdxData.serverIdx = serverIndex
    self._serverIdxData[channelIdx] = serverIdxData
    self._ui.list_Server:getElementManager():pushKey(toInt64(0, channelIdx))
    channelIdx = channelIdx + 1
  end
end
function PaGlobalFunc_ServerSelect_LateUpdate()
  self:startFadeIn()
  self:initBanners()
end
function ServerSelect:playWebMovie()
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
local _fadeTime = 0.2
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
    luaTimer_AddEvent(PaGlobalFunc_ServerSelect_FadeOut, _movieLength[_movieOrder[_currentMovieIndex]] - _fadeTime * 1000, false, 0)
  end
end
function ServerSelect:startFadeIn()
  local ImageAni = self._ui.stc_fade:addColorAnimation(0.1, _fadeTime, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  ImageAni:SetStartColor(Defines.Color.C_FF000000)
  ImageAni:SetEndColor(Defines.Color.C_00000000)
  ImageAni:SetHideAtEnd(true)
end
function PaGlobalFunc_ServerSelect_FadeOut()
  self:startFadeOut()
end
function ServerSelect:startFadeOut()
  self._ui.stc_fade:SetShow(true)
  local ImageAni = self._ui.stc_fade:addColorAnimation(0, _fadeTime, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  ImageAni:SetStartColor(Defines.Color.C_00000000)
  ImageAni:SetEndColor(Defines.Color.C_FF000000)
  ImageAni:SetHideAtEnd(false)
end
function InputMLUp_ServerSelect_EnterServer(channelIdx, isAdmission)
  local self = ServerSelect
  if not isAdmission then
    local worldServerData = getGameWorldServerDataByIndex(self._selectedWorldIndex)
    local changeChannelTime = getChannelMoveableRemainTime(worldServerData._worldNo)
    local changeRealChannelTime = convertStringFromDatetime(changeChannelTime)
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANGECHANNEL_PENALTY", "changeRealChannelTime", changeRealChannelTime)
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if nil == self._serverIdxData[channelIdx] then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 8)
  local worldIndex = self._serverIdxData[channelIdx].worldIdx
  local serverIndex = self._serverIdxData[channelIdx].serverIdx
  if isGameServiceTypeKor() and false == ToClient_isAdultUser() and false == ToClient_CanEnterNonAdultWorld() then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CANT_CONNECTABLE_TIME"),
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if true == _ContentsGroup_Console_WebBanner then
    for ii = 0, #self._ui.web_banners do
      self._ui.web_banners[ii]:ResetUrl()
    end
    self._bannerIsReady = {}
  end
  if true == selectServerGroup(worldIndex, serverIndex) then
  end
end
function InputMOn_ServerSelect_ChannelTooltip(channelType, isClose)
  for ii = 2, #self._ui.stc_channelDesc do
    self._ui.stc_channelDesc[ii]:SetShow(false)
  end
  self._ui.stc_channelDesc[channelType]:SetShow(true)
  self._ui.txt_Select_ConsoleUI:SetShow(true)
  self._ui.txt_Select_ConsoleUI:SetMonoTone(isClose)
end
function InputMLUp_ServerSelect_SelectWorld()
end
function InputMLUp_ServerSelect_EnterLastJoinedServer()
  local tempWrapper = getTemporaryInformationWrapper()
  local lastJoinServerNo = tempWrapper:getLastServerNo()
  if 1 == lastJoinServerNo then
    return
  end
  PaGlobal_ServerSelect_EnterMemorizedChannel(lastJoinServerNo)
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
  local self = ServerSelect
  selectRandomServer(self._selectedWorldIndex)
end
function PaGlobal_ServerSelect_ServerList_ControlCreate(content, key)
  local self = ServerSelect
  local channelIdx = Int64toInt32(key)
  local worldIdx = self._serverIdxData[channelIdx].worldIdx
  local serverIdx = self._serverIdxData[channelIdx].serverIdx
  local worldServerData = getGameWorldServerDataByIndex(worldIdx)
  local serverData = getGameChannelServerDataByIndex(worldIdx, serverIdx)
  if nil == serverData then
    return
  end
  local isBeingWar = serverData._isSiegeBeing
  local isVillageStart = serverData._isVillageSiege
  local changeChannelTime = getChannelMoveableRemainTime(worldServerData._worldNo)
  local changeRealChannelTime = convertStringFromDatetime(changeChannelTime)
  local btn_NormalSlot = UI.getChildControl(content, "Button_NormalServerSlot")
  local btn_ArshaSlot = UI.getChildControl(content, "Button_ArshaServerSlot")
  local btn_OlviaSlot = UI.getChildControl(content, "Button_OlviaServerSlot")
  local txt_ServerName = UI.getChildControl(content, "StaticText_Name")
  local txt_State = UI.getChildControl(content, "StaticText_State")
  local stc_NoEntrance = UI.getChildControl(content, "Static_NoEntranceIcon")
  local stc_checking = UI.getChildControl(content, "Static_CheckIcon")
  btn_NormalSlot:SetShow(false)
  btn_ArshaSlot:SetShow(false)
  btn_OlviaSlot:SetShow(false)
  txt_State:SetShow(false)
  stc_NoEntrance:SetShow(false)
  stc_checking:SetShow(false)
  local serverSlotButton = btn_NormalSlot
  local isAdmission = true
  local restrictedServerNo = worldServerData._restrictedServerNo
  if restrictedServerNo ~= 0 then
    if restrictedServerNo == serverData._serverNo then
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
  end
  local channelName = getChannelName(worldServerData._worldNo, serverData._serverNo)
  _PA_ASSERT(nil ~= channelName, "\236\132\156\235\178\132 \236\157\180\235\166\132\236\157\128 \236\161\180\236\158\172\237\149\180\236\149\188\237\149\169\235\139\136\235\139\164.")
  if true == isGameServiceTypeDev() then
    channelName = channelName .. " " .. getDotIp(serverData) .. admissionDesc
  else
    channelName = channelName .. " " .. admissionDesc
  end
  txt_ServerName:SetText(channelName)
  txt_ServerName:SetShow(true)
  local stateStr = ""
  local busyState = serverData._busyState
  if true == ToClient_isConsole() and true == ToClient_isServiceMaintenance() then
    busyState = 0
  end
  local isServerClose = false
  if busyState == 0 or serverData:isClosed() then
    stateStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_0")
    stc_checking:SetShow(true)
    isServerClose = true
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
  txt_State:SetShow(true)
  if true == isLoginIDShow() then
    if changeChannelTime > toInt64(0, 0) and not isAdmission then
      txt_State:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANGECHANNEL", "changeRealChannelTime", changeRealChannelTime))
      stc_checking:SetShow(false)
      stc_NoEntrance:SetShow(true)
    end
  elseif not isAdmission and busyState ~= 0 then
    if changeChannelTime > toInt64(0, 0) then
      txt_State:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANGECHANNEL", "changeRealChannelTime", changeRealChannelTime))
    else
      txt_State:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANGECHANNEL", "changeRealChannelTime", 0))
    end
    stc_checking:SetShow(false)
    stc_NoEntrance:SetShow(true)
  end
  local stc = UI.getChildControl(content, "Static_ChannelIcon")
  stc:SetShow(false)
  self:showChannelIcon(content, CHANNEL_TYPE.SINGLE_WORLD_SYSTEM)
  local temporaryWrapper = getTemporaryInformationWrapper()
  local channelType = CHANNEL_TYPE.SINGLE_WORLD_SYSTEM
  if serverData._isSpeedChannel then
    serverSlotButton = btn_OlviaSlot
    channelType = CHANNEL_TYPE.OLVIA_CHANNEL
    self:showChannelIcon(content, CHANNEL_TYPE.OLVIA_CHANNEL)
    if 0 ~= temporaryWrapper:getMyAdmissionToSpeedServer() then
      serverSlotButton:SetMonoTone(false)
    else
      serverSlotButton:SetMonoTone(true)
    end
  elseif serverData._isPcroomChannel then
    channelType = CHANNEL_TYPE.PC_ROOM_CHANNEL
    self:showChannelIcon(content, CHANNEL_TYPE.PC_ROOM_CHANNEL)
  elseif serverData._isDontPvPTendencyDecrease then
    serverSlotButton = btn_ArshaSlot
    channelType = CHANNEL_TYPE.ARSHA_CHANNEL
    self:showChannelIcon(content, CHANNEL_TYPE.ARSHA_CHANNEL)
  elseif serverData._isSiegeChannel then
    channelType = CHANNEL_TYPE.WAR_INFO
    if isBeingWar then
      self:showChannelIcon(content, CHANNEL_TYPE.WAR_INFO)
    end
  end
  if not isAdmission then
    txt_ServerName:SetFontColor(Defines.Color.C_FF525B6D)
    serverSlotButton:addInputEvent("Mouse_LUp", "InputMLUp_ServerSelect_EnterServer(" .. channelIdx .. ", false)")
  elseif 0 == busyState and false == ToClient_IsDevelopment() then
    txt_ServerName:SetFontColor(Defines.Color.C_FF525B6D)
    serverSlotButton:addInputEvent("Mouse_LUp", "")
  else
    txt_ServerName:SetFontColor(Defines.Color.C_FFEEEEEE)
    serverSlotButton:addInputEvent("Mouse_LUp", "InputMLUp_ServerSelect_EnterServer(" .. channelIdx .. ", true)")
  end
  serverSlotButton:SetShow(true)
  if isServerClose then
    serverSlotButton:addInputEvent("Mouse_On", "InputMOn_ServerSelect_ChannelTooltip(" .. channelType .. ", true)")
  else
    serverSlotButton:addInputEvent("Mouse_On", "InputMOn_ServerSelect_ChannelTooltip(" .. channelType .. ", false)")
  end
end
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
function ServerSelect:showChannelIcon(content, iconIndex)
  local stc = UI.getChildControl(content, "Static_ChannelIcon")
  if CHANNEL_TYPE.SINGLE_WORLD_SYSTEM == iconIndex then
    stc:SetShow(false)
    return
  end
  stc:ChangeTextureInfoName("renewal/ui_icon/console_icon_01.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(stc, _channelIconUV[iconIndex][1], _channelIconUV[iconIndex][2], _channelIconUV[iconIndex][3], _channelIconUV[iconIndex][4])
  stc:getBaseTexture():setUV(x1, y1, x2, y2)
  stc:setRenderTexture(stc:getBaseTexture())
  local name = UI.getChildControl(content, "StaticText_Name")
  stc:SetPosX(name:GetSpanSize().x + name:GetTextSizeX() + 10)
  stc:SetShow(true)
end
function PaGlobal_ServerSelect_EnterMemorizedChannel(channelIdx)
  local self = ServerSelect
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
  selectMemorizedServer(self._selectedWorldIndex, channelIdx)
end
function PaGlobal_ServerSelect_EventUpdateServerInfo()
  local isShow = _panel:IsShow()
  if false == isShow then
    return
  end
  PaGlobal_ServerSelect_Init()
end
function PaGlobal_ServerSelect_Resize()
  if false == _panel:IsShow() then
    return
  end
  local resizedRatioY = getScreenSizeY() / _panel:GetSizeY()
  local self = ServerSelect
  _panel:SetSize(getScreenSizeX(), getScreenSizeY())
  self._ui.stc_RightBg:SetSize(self._ui.stc_RightBg:GetSizeX(), getScreenSizeY())
  self._ui.stc_RightBg:SetPosX(getScreenSizeX() - self._ui.stc_RightBg:GetSizeX())
  self._ui.stc_leftBg:ComputePos()
  self._ui.list_Server:SetSize(self._ui.list_Server:GetSizeX(), self._ui.list_Server:GetSizeY() * resizedRatioY)
  self._ui.txt_Select_ConsoleUI:SetPosY(self._ui.txt_Select_ConsoleUI:GetPosY() * resizedRatioY)
  self._ui.txt_Back_ConsoleUI:SetPosY(self._ui.txt_Back_ConsoleUI:GetPosY() * resizedRatioY)
end
_stc_BackgroundImage[currentBackIndex]:SetShow(true)
_stc_BackgroundImage[currentBackIndex]:SetAlpha(1)
local oneSecond = 1
local timeCounter = 0
function PaGlobal_ServerSelect_PerFrameUpdate(deltaTime)
  local self = ServerSelect
  timeCounter = timeCounter + deltaTime
  if timeCounter > oneSecond then
    timeCounter = 0
    self._ui.list_Server:requestUpdateVisible()
  end
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
end
function PaGlobal_ServerSelect_Init()
  local self = ServerSelect
  self:init()
end
function FromClient_ServerSelect_ShowXboxInviteMessage(worldIdx, serverIdx, userName, channelName)
  local self = ServerSelect
  self._inviteWorldIdx = worldIdx
  self._inviteServerIdx = serverIdx
  if true == ToClient_isPS4() then
    PaGlobal_ServerSelect_ApplyInvite()
    return
  end
  local messageBoxMemo = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WINDOW_XBOXCHANNELINVITE", "userName", tostring(userName), "channelName", tostring(channelName))
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"),
    content = messageBoxMemo,
    functionYes = PaGlobal_ServerSelect_ApplyInvite,
    functionNo = PaGlobal_ServerSelect_DeclineInvite,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_ServerSelect_ApplyInvite()
  local worldIdx = self._inviteWorldIdx
  local serverIdx = self._inviteServerIdx
  local worldServerData = getGameWorldServerDataByIndex(worldIdx)
  local serverData = getGameChannelServerDataByIndex(worldIdx, serverIdx)
  if nil == serverData then
    Proc_ShowMessage_Ack("Not correct Server data.")
    return
  end
  local changeChannelTime = getChannelMoveableRemainTime(worldServerData._worldNo)
  local isAdmission = true
  local restrictedServerNo = worldServerData._restrictedServerNo
  if restrictedServerNo ~= 0 then
    if restrictedServerNo == serverData._serverNo then
      isAdmission = true
    elseif changeChannelTime > toInt64(0, 0) then
      isAdmission = false
    else
      isAdmission = true
    end
  end
  if false == isAdmission then
    local changeRealChannelTime = convertStringFromDatetime(changeChannelTime)
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANGECHANNEL_PENALTY", "changeRealChannelTime", changeRealChannelTime)
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if serverData._isSpeedChannel and 0 == temporaryWrapper:getMyAdmissionToSpeedServer() then
    Proc_ShowMessage_Ack("You cannot join this Server.")
    return
  end
  if true == _ContentsGroup_Console_WebBanner then
    for ii = 0, #self._ui.web_banners do
      self._ui.web_banners[ii]:ResetUrl()
    end
    self._bannerIsReady = {}
  end
  selectServerGroup(worldIdx, serverIdx)
end
function PaGlobal_ServerSelect_DeclineInvite()
  local self = ServerSelect
  self._inviteWorldIdx = nil
  self._inviteServerIdx = nil
end
PaGlobal_ServerSelect_Init()
Panel_Lobby_ServerSelect_Renew:SetShow(true)
PaGlobal_ServerSelect_Resize()

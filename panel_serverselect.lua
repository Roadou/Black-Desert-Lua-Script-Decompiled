local UI_PD = CppEnums.Padding
Panel_ServerSelect:SetShow(true, false)
Panel_ServerSelect:SetSize(getScreenSizeX(), getScreenSizeY())
Panel_ServerSelect:SetShow(false, false)
local FRAME_SERVERLIST = UI.getChildControl(Panel_ServerSelect, "FrameServerList")
local FRAMEContents_SERVERLIST = UI.getChildControl(FRAME_SERVERLIST, "Frame_1_Content")
local FRAME_Scroll = UI.getChildControl(FRAME_SERVERLIST, "Frame_1_VerticalScroll")
local SELECT_SERVER_BG_TEXT = UI.getChildControl(Panel_ServerSelect, "StaticText_ServerSelect")
local WORLD_BG_BTN = UI.getChildControl(Panel_ServerSelect, "Button_Server")
local WORLD_NAME_TEXT = UI.getChildControl(Panel_ServerSelect, "StaticText_ServerName")
local WORLD_Event_TEXT = UI.getChildControl(Panel_ServerSelect, "StaticText_ServerEvent")
local WORLD_UNABLE_CREATE_CHARACTER = UI.getChildControl(Panel_ServerSelect, "Static_UnableCreate")
local WORLD_SPEED_SERVER_IMG = UI.getChildControl(Panel_ServerSelect, "Static_WorthChannel")
local WORLD_CHARACTERCOUNT_TEXT = UI.getChildControl(Panel_ServerSelect, "StaticText_CharacterCount")
local WORLD_STATUS_TEXT = UI.getChildControl(Panel_ServerSelect, "Static_ServerStatus")
local WORLD_PRIMIUMSERVER_ICON = UI.getChildControl(Panel_ServerSelect, "Static_PrimiumIcon")
local CHANNEL_BG_STATIC = UI.getChildControl(Panel_ServerSelect, "Static_ChannelBG")
local CHANNEL_NAME_TEXT = UI.getChildControl(Panel_ServerSelect, "StaticText_ChannelName")
local CHANNEL_MAINICON_STATIC = UI.getChildControl(Panel_ServerSelect, "Static_MainChannelIcon")
local CHANNEL_STATUS_TEXT = UI.getChildControl(Panel_ServerSelect, "Static_ChannelStatus")
local CHANNEL_ENTER_BTN = UI.getChildControl(Panel_ServerSelect, "Button_Channel")
local CHANNEL_MAINSERVER = UI.getChildControl(Panel_ServerSelect, "RadioButton_MainServer")
local CHANNEL_MAINSERVERSQ = UI.getChildControl(Panel_ServerSelect, "Static_MainServerSq")
local CHANNEL_CHANGE_TEXT = UI.getChildControl(Panel_ServerSelect, "MultilineText_ChangeChannel")
local channel_WarIcon = UI.getChildControl(Panel_ServerSelect, "Static_WarIcon")
local channel_Premium = UI.getChildControl(Panel_ServerSelect, "Static_PremiumIcon")
local channel_PvPIcon = UI.getChildControl(Panel_ServerSelect, "Static_PvPIcon")
local mainServerBg = UI.getChildControl(Panel_ServerSelect, "Static_MainServerBg")
local mainServerText = UI.getChildControl(mainServerBg, "StaticText_MainServerDesc")
local btn_SetMainServer = UI.getChildControl(mainServerBg, "Button_SetMainServer")
local btn_EnterMainServer = UI.getChildControl(mainServerBg, "Button_EnterMainServer")
local btn_EnterLastJoinServer = UI.getChildControl(mainServerBg, "Button_LastJoinServer")
local txt_EnterLastJoinServer = UI.getChildControl(mainServerBg, "MultilineText_LastJoinServer")
local btn_RandomJoinServer = UI.getChildControl(mainServerBg, "Button_RandomJoinServer")
mainServerText:setPadding(UI_PD.ePadding_Left, 10)
mainServerText:setPadding(UI_PD.ePadding_Top, 5)
mainServerText:setPadding(UI_PD.ePadding_Right, 10)
mainServerText:setPadding(UI_PD.ePadding_Bottom, 5)
local isRadioBtnShow = false
local isSpeedServer = {}
local isNotSpeedServer = {}
local isFirst = true
local isSettingLastConnectServer = false
if _ContentsGroup_isConsolePadControl then
  mainServerBg:SetShow(false)
end
local warInfo = {
  _uiWarInfo = UI.getChildControl(Panel_ServerSelect, "Static_WarInfo"),
  _warInfoTitle = UI.getChildControl(Panel_ServerSelect, "StaticText_WarInfo_Title"),
  _uiBG = UI.getChildControl(Panel_ServerSelect, "Static_WarInfo_BG"),
  _warGuide = UI.getChildControl(Panel_ServerSelect, "StaticText_WarGuide"),
  _siegeBG = UI.getChildControl(Panel_ServerSelect, "Static_SiegeBG"),
  _staticChannel = UI.getChildControl(Panel_ServerSelect, "StaticText_Channel"),
  _siegeBalenos = UI.getChildControl(Panel_ServerSelect, "StaticText_Siege_Balenos"),
  _siegeSerendia = UI.getChildControl(Panel_ServerSelect, "StaticText_Siege_Serendia"),
  _siegeCalpheon = UI.getChildControl(Panel_ServerSelect, "StaticText_Siege_Calpheon"),
  _siegeMedia = UI.getChildControl(Panel_ServerSelect, "StaticText_Siege_Media"),
  _siegeValencia = UI.getChildControl(Panel_ServerSelect, "StaticText_Siege_Valencia"),
  _nodeWarBG = UI.getChildControl(Panel_ServerSelect, "Static_NodeWarBG"),
  _staticSchedule = UI.getChildControl(Panel_ServerSelect, "StaticText_Schedule"),
  _scheduleSiege = UI.getChildControl(Panel_ServerSelect, "StaticText_Schedule_Siege"),
  _scheduleNodeWar = UI.getChildControl(Panel_ServerSelect, "StaticText_Schedule_Nodewar"),
  _slotMaxCount = 5,
  _startPosY = 5,
  _isSieging = false,
  _isNodeWar = false,
  _slots = {}
}
local channelSelectInfo = {
  _channelSelectTitle = UI.getChildControl(Panel_ServerSelect, "StaticText_ChannelSelectTitle"),
  _mainBG = UI.getChildControl(Panel_ServerSelect, "Static_ChannelSelectMainBG"),
  _subBG = UI.getChildControl(Panel_ServerSelect, "Static_ChannelSelectSubBG"),
  _channelSelectDesc = UI.getChildControl(Panel_ServerSelect, "StaticText_ChannelSelectDesc")
}
local channelSpeedInfo = {
  _speedTitle = UI.getChildControl(Panel_ServerSelect, "StaticText_SpeedTitle"),
  _speedMainBG = UI.getChildControl(Panel_ServerSelect, "Static_SpeedMainBG"),
  _speedSubBG = UI.getChildControl(Panel_ServerSelect, "Static_SpeedDescBG"),
  _speedDesc = UI.getChildControl(Panel_ServerSelect, "StaticText_SpeedDesc")
}
local channelPKInfo = {
  _pkTitle = UI.getChildControl(Panel_ServerSelect, "StaticText_PKTitle"),
  _pkMainBG = UI.getChildControl(Panel_ServerSelect, "Static_PKMainBG"),
  _pkSubBG = UI.getChildControl(Panel_ServerSelect, "Static_PKDescBG"),
  _pkDesc = UI.getChildControl(Panel_ServerSelect, "StaticText_PKDesc")
}
function channelSelectInfo_Init()
  local self = channelSelectInfo
  self._mainBG:AddChild(self._channelSelectTitle)
  self._mainBG:AddChild(self._subBG)
  self._mainBG:AddChild(self._channelSelectDesc)
  Panel_ServerSelect:RemoveControl(self._channelSelectTitle)
  Panel_ServerSelect:RemoveControl(self._subBG)
  Panel_ServerSelect:RemoveControl(self._channelSelectDesc)
  self._channelSelectDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local isAdult = ToClient_isAdultUser()
  if isAdult then
    self._channelSelectDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_CHANNELSELECTDESC"))
  else
    self._channelSelectDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_CHANNELSELECTDESC_15"))
  end
  self._mainBG:SetSize(self._mainBG:GetSizeX(), self._channelSelectDesc:GetTextSizeY() + 70)
  self._subBG:SetSize(self._subBG:GetSizeX(), self._channelSelectDesc:GetTextSizeY() + 10)
  self._channelSelectTitle:SetPosX(10)
  self._channelSelectTitle:SetPosY(30)
  self._subBG:SetPosX(10)
  self._subBG:SetPosY(40)
  self._channelSelectDesc:SetPosX(18)
  self._channelSelectDesc:SetPosY(50)
end
function warInfo_Init()
  local self = warInfo
  self._uiWarInfo:AddChild(self._warInfoTitle)
  self._uiWarInfo:AddChild(self._uiBG)
  self._uiWarInfo:AddChild(self._siegeBG)
  self._uiWarInfo:AddChild(self._staticChannel)
  self._uiWarInfo:AddChild(self._siegeBalenos)
  self._uiWarInfo:AddChild(self._siegeSerendia)
  self._uiWarInfo:AddChild(self._siegeCalpheon)
  self._uiWarInfo:AddChild(self._siegeMedia)
  self._uiWarInfo:AddChild(self._siegeValencia)
  self._uiWarInfo:AddChild(self._nodeWarBG)
  self._uiWarInfo:AddChild(self._staticSchedule)
  self._uiWarInfo:AddChild(self._scheduleSiege)
  self._uiWarInfo:AddChild(self._scheduleNodeWar)
  Panel_ServerSelect:RemoveControl(self._warInfoTitle)
  Panel_ServerSelect:RemoveControl(self._uiBG)
  Panel_ServerSelect:RemoveControl(self._siegeBG)
  Panel_ServerSelect:RemoveControl(self._staticChannel)
  Panel_ServerSelect:RemoveControl(self._siegeBalenos)
  Panel_ServerSelect:RemoveControl(self._siegeSerendia)
  Panel_ServerSelect:RemoveControl(self._siegeCalpheon)
  Panel_ServerSelect:RemoveControl(self._siegeMedia)
  Panel_ServerSelect:RemoveControl(self._siegeValencia)
  Panel_ServerSelect:RemoveControl(self._nodeWarBG)
  Panel_ServerSelect:RemoveControl(self._staticSchedule)
  Panel_ServerSelect:RemoveControl(self._scheduleSiege)
  Panel_ServerSelect:RemoveControl(self._scheduleNodeWar)
  self._warInfoTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_TITLE"))
  self._staticChannel:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_TERRITORY_SUB_TITLE"))
  self._siegeBalenos:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_TERRITORY_SUB_DESC_BALENOS"))
  self._siegeSerendia:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_TERRITORY_SUB_DESC_SERENDIA"))
  self._siegeCalpheon:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_TERRITORY_SUB_DESC_CALPEON"))
  self._siegeMedia:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_TERRITORY_SUB_DESC_MEDIA"))
  self._siegeValencia:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_TERRITORY_SUB_DESC_VALENCIA"))
  self._staticSchedule:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_DATE_SUB_TITLE"))
  self._scheduleSiege:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_DATE_SUB_DESC_TERRITORYWAR"))
  self._scheduleNodeWar:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_WARCHANNEL_DATE_SUB_DESC_NODEWAR"))
  self._warInfoTitle:SetPosX(10)
  self._warInfoTitle:SetPosY(38)
  self._uiBG:SetPosX(10)
  self._uiBG:SetPosY(45)
  self._siegeBG:SetPosX(15)
  self._siegeBG:SetPosY(50)
  self._staticChannel:SetPosX(25)
  self._staticChannel:SetPosY(60)
  self._siegeBalenos:SetPosX(30)
  self._siegeBalenos:SetPosY(80)
  self._siegeSerendia:SetPosX(30)
  self._siegeSerendia:SetPosY(100)
  self._siegeCalpheon:SetPosX(30)
  self._siegeCalpheon:SetPosY(120)
  self._siegeMedia:SetPosX(30)
  self._siegeMedia:SetPosY(140)
  self._siegeValencia:SetPosX(30)
  self._siegeValencia:SetPosY(160)
  self._nodeWarBG:SetPosX(15)
  self._nodeWarBG:SetPosY(190)
  self._staticSchedule:SetPosX(25)
  self._staticSchedule:SetPosY(200)
  self._scheduleSiege:SetPosX(30)
  self._scheduleSiege:SetPosY(220)
  self._scheduleNodeWar:SetPosX(30)
  self._scheduleNodeWar:SetPosY(240)
end
function SpeedChannelInfo_Init()
  local self = channelSpeedInfo
  self._speedMainBG:AddChild(self._speedTitle)
  self._speedMainBG:AddChild(self._speedSubBG)
  self._speedMainBG:AddChild(self._speedDesc)
  Panel_ServerSelect:RemoveControl(self._speedTitle)
  Panel_ServerSelect:RemoveControl(self._speedSubBG)
  Panel_ServerSelect:RemoveControl(self._speedDesc)
  self._speedTitle:SetPosX(10)
  self._speedTitle:SetPosY(30)
  self._speedSubBG:SetPosX(10)
  self._speedSubBG:SetPosY(40)
  self._speedDesc:SetPosX(18)
  self._speedDesc:SetPosY(45)
  self._speedDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._speedTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SPEEDCHANNEL_TITLE"))
  if isGameTypeTaiwan() then
    self._speedDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SPEEDCHANNEL_DESC_TW"))
  else
    self._speedDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SPEEDCHANNEL_DESC"))
  end
  self._speedMainBG:SetSize(self._speedMainBG:GetSizeX(), self._speedTitle:GetSizeY() + self._speedDesc:GetTextSizeY() + 50)
  self._speedSubBG:SetSize(self._speedSubBG:GetSizeX(), self._speedDesc:GetTextSizeY())
end
function PKChannelInfo_Init()
  local self = channelPKInfo
  self._pkMainBG:AddChild(self._pkTitle)
  self._pkMainBG:AddChild(self._pkSubBG)
  self._pkMainBG:AddChild(self._pkDesc)
  Panel_ServerSelect:RemoveControl(self._pkTitle)
  Panel_ServerSelect:RemoveControl(self._pkSubBG)
  Panel_ServerSelect:RemoveControl(self._pkDesc)
  self._pkTitle:SetPosX(10)
  self._pkTitle:SetPosY(30)
  self._pkSubBG:SetPosX(10)
  self._pkSubBG:SetPosY(40)
  self._pkDesc:SetPosX(18)
  self._pkDesc:SetPosY(45)
  self._pkDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._pkTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_SEVERSELECT_PK"))
  if isGameTypeKorea() then
    self._pkDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_PVPDESC_ARSHASERVER"))
  else
    self._pkDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_PVPDESC"))
  end
  self._pkMainBG:SetSize(self._pkMainBG:GetSizeX(), self._pkTitle:GetSizeY() + self._pkDesc:GetTextSizeY() + 50)
  self._pkSubBG:SetSize(self._pkSubBG:GetSizeX(), self._pkDesc:GetTextSizeY())
  if isGameTypeKorea() then
    local isAdult = ToClient_isAdultUser()
    if isAdult then
      ChannelSelectInfo_Show()
      SpeedChannelInfo_Show()
      PKChannelInfo_Show()
      warInfo_Show()
    else
      ChannelSelectInfo_Show()
      SpeedChannelInfo_Hide()
      PKChannelInfo_Hide()
      warInfo_Hide()
    end
  elseif isGameTypeJapan() then
    ChannelSelectInfo_Show()
    SpeedChannelInfo_Show()
    PKChannelInfo_Show()
    warInfo_Show()
  elseif isGameTypeTaiwan() then
    ChannelSelectInfo_Show()
    SpeedChannelInfo_Show()
    PKChannelInfo_Hide()
    warInfo_Show()
  elseif isGameTypeRussia() then
    ChannelSelectInfo_Hide()
    SpeedChannelInfo_Show()
    PKChannelInfo_Show()
    warInfo_Show()
  elseif isGameTypeSA() then
    ChannelSelectInfo_Show()
    SpeedChannelInfo_Show()
    PKChannelInfo_Hide()
    warInfo_Show()
  elseif isGameTypeTH() or isGameTypeID() then
    ChannelSelectInfo_Show()
    SpeedChannelInfo_Hide()
    PKChannelInfo_Show()
    warInfo_Show()
  elseif isGameTypeTR() then
    ChannelSelectInfo_Show()
    SpeedChannelInfo_Show()
    PKChannelInfo_Show()
    warInfo_Show()
  elseif isGameTypeEnglish() then
    ChannelSelectInfo_Show()
    SpeedChannelInfo_Show()
    PKChannelInfo_Show()
    warInfo_Show()
  else
    ChannelSelectInfo_Hide()
    SpeedChannelInfo_Hide()
    PKChannelInfo_Hide()
    warInfo_Hide()
  end
end
WORLD_BG_BTN:SetShow(false)
WORLD_NAME_TEXT:SetShow(false)
WORLD_UNABLE_CREATE_CHARACTER:SetShow(false)
WORLD_SPEED_SERVER_IMG:SetShow(false)
WORLD_CHARACTERCOUNT_TEXT:SetShow(false)
WORLD_STATUS_TEXT:SetShow(false)
WORLD_PRIMIUMSERVER_ICON:SetShow(false)
CHANNEL_BG_STATIC:SetShow(false)
CHANNEL_NAME_TEXT:SetShow(false)
CHANNEL_STATUS_TEXT:SetShow(false)
CHANNEL_ENTER_BTN:SetShow(false)
CHANNEL_CHANGE_TEXT:SetShow(false)
CHANNEL_MAINSERVER:SetShow(false)
CHANNEL_MAINSERVERSQ:SetShow(false)
FRAME_SERVERLIST:SetShow(true)
local screenX = getScreenSizeX()
local screenY = getScreenSizeY()
Static_Back = Array.new()
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
local tempBg = UI.getChildControl(Panel_ServerSelect, "bgBase_1")
for v, value in ipairs(bgManager) do
  if value.isOpen then
    totalBG = totalBG + value.imageCount
    if value.imageCount > 0 then
      startIndex = imageIndex
      for index = 1, value.imageCount do
        local targetControl = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_ServerSelect, "Static_ServerSelectBg_" .. imageIndex)
        CopyBaseProperty(tempBg, targetControl)
        targetControl:ChangeTextureInfoName(baseLink .. value.iconPath .. index .. ".dds")
        targetControl:SetSize(screenX, screenY)
        targetControl:SetPosX(0)
        targetControl:SetPosY(0)
        targetControl:SetAlpha(0)
        Panel_ServerSelect:SetChildIndex(targetControl, 0)
        Static_Back[imageIndex] = targetControl
        endIndex = imageIndex
        imageIndex = imageIndex + 1
      end
    end
  end
end
tempBg:SetShow(false)
local bgStartIndex = getRandomValue(startIndex, endIndex)
local _selectWorldIndex = -1
local _worldServerCount = 0
local _oldSelectWorldIndex = -1
local _channelCtrl = {
  _bgStatic,
  _nameText,
  _warIcon,
  _premiumIcon,
  _statusText,
  _enterBtn,
  _changeChannel
}
local _worldServerCtrl = {
  _bgButton,
  _nameText,
  _countText,
  _statusText,
  _channelCount,
  _channelCtrls
}
local _worldServerCtrls = {}
local serverStatusTexture = {
  [0] = {
    133,
    27,
    149,
    43
  },
  {
    150,
    27,
    166,
    43
  },
  {
    167,
    27,
    183,
    43
  },
  {
    184,
    27,
    200,
    43
  },
  {
    184,
    44,
    200,
    60
  }
}
function changeTexture_ByServerStatus(control, status)
  control:ChangeTextureInfoName("new_ui_common_forlua/Default/Default_Etc_01.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, serverStatusTexture[status][1], serverStatusTexture[status][2], serverStatusTexture[status][3], serverStatusTexture[status][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
local createStatusTexture = {
  [0] = {
    139,
    44,
    166,
    71
  },
  {
    111,
    44,
    138,
    71
  }
}
function changeTexture_ByCreateStatus(control, status)
  control:ChangeTextureInfoName("new_ui_common_forlua/Default/Default_Etc_01.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, createStatusTexture[status][1], createStatusTexture[status][2], createStatusTexture[status][3], createStatusTexture[status][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
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
    functionYes = ServerList_LastJoinServer,
    exitButton = false,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1
  }
  MessageBox.showMessageBox(messageBoxData)
  return true
end
function StartUp_Panel_SelectServer()
  PaGlobalFunc_ServerSelectAutoConnectToLastServer()
  if isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_KOR) then
    SELECT_SERVER_BG_TEXT:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANNEL"))
  else
    SELECT_SERVER_BG_TEXT:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SERVER"))
  end
  Panel_ServerSelect:SetShow(false, false)
  Panel_ServerSelect:SetSize(getScreenSizeX(), getScreenSizeY())
  _worldServerCount = getGameWorldServerDataCount()
  for idx = 0, _worldServerCount - 1 do
    local serverData = getGameWorldServerDataByIndex(idx)
    if nil == serverData then
      break
    end
    local isExpBonusEvent = IsWorldServerEventTypeByWorldIndex(idx, -1, 0)
    local isDropRateEvent = IsWorldServerEventTypeByWorldIndex(idx, -1, 1)
    local worldCtrl = {}
    local tempBtn = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, FRAME_SERVERLIST:GetFrameContent(), "WorldButton_" .. tostring(idx))
    CopyBaseProperty(WORLD_BG_BTN, tempBtn)
    tempBtn:SetShow(true)
    tempBtn:ActiveMouseEventEffect(true)
    tempBtn:addInputEvent("Mouse_LUp", "Panel_Lobby_function_SelectWorldServer(" .. idx .. ")")
    tempBtn:SetPosX(0)
    tempBtn:SetPosY(idx * (tempBtn:GetSizeY() + 25))
    local tempName = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempBtn, "WorldName_" .. tostring(idx))
    CopyBaseProperty(WORLD_NAME_TEXT, tempName)
    tempName:SetShow(true)
    tempName:ActiveMouseEventEffect(true)
    local tempWorldName = getWorldNameByWorldNo(serverData._worldNo)
    tempName:SetText(tempWorldName)
    tempName:SetPosX(20)
    tempName:SetPosY(14)
    local tempPrimiumIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempBtn, "WorldPrimiumIcon_" .. tostring(idx))
    CopyBaseProperty(WORLD_PRIMIUMSERVER_ICON, tempPrimiumIcon)
    tempPrimiumIcon:SetPosX(20)
    local tempEvent = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempBtn, "WorldEventName_" .. tostring(idx))
    CopyBaseProperty(WORLD_Event_TEXT, tempEvent)
    tempEvent:ActiveMouseEventEffect(true)
    local tempEventName = ""
    if isExpBonusEvent then
      tempEventName = tempEventName .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_EXPEVENT")
    end
    if isDropRateEvent then
      tempEventName = tempEventName .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_DROPEVENT")
    end
    if "" == tempEventName then
      tempName:SetPosY(20)
      tempEvent:SetShow(false)
      tempPrimiumIcon:SetPosY(20)
    else
      tempName:SetPosY(14)
      tempEvent:SetShow(true)
      tempPrimiumIcon:SetPosY(14)
    end
    tempEvent:SetText(tempEventName)
    tempEvent:SetPosX(20)
    tempEvent:SetPosY(37)
    local tempCount = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempBtn, "WorldCount_" .. tostring(idx))
    CopyBaseProperty(WORLD_CHARACTERCOUNT_TEXT, tempCount)
    tempCount:SetShow(true)
    tempCount:ActiveMouseEventEffect(true)
    local tempStr = ""
    tempStr = "(" .. tostring(serverData._characterCount) .. "/" .. tostring(serverData._deleteCount) .. ")"
    tempCount:SetText(tempStr)
    tempCount:SetPosX(180)
    tempCount:SetPosY(20)
    local tempStatus = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempBtn, "WorldStatus_" .. tostring(idx))
    CopyBaseProperty(WORLD_STATUS_TEXT, tempStatus)
    tempStatus:SetShow(true)
    tempStatus:ActiveMouseEventEffect(true)
    tempStatus:SetAutoResize(true)
    tempStatus:SetVerticalMiddle()
    tempStatus:SetHorizonRight()
    local busyState = getGameWorldServerBusyByIndex(idx)
    if busyState == 0 then
      tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_0")
    elseif busyState == 1 then
      tempStr = ""
    elseif busyState == 2 then
      tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_2")
    elseif busyState == 3 then
      tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_3")
    elseif busyState == 4 then
      tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_4")
    end
    local tempUnableCreate = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempBtn, "WorldUnableCreate_" .. tostring(idx))
    CopyBaseProperty(WORLD_UNABLE_CREATE_CHARACTER, tempUnableCreate)
    tempUnableCreate:SetShow(true)
    tempUnableCreate:SetPosX(tempBtn:GetSizeX() - tempUnableCreate:GetSizeX() * 1.5)
    tempUnableCreate:SetPosY(18)
    if ToClient_IsCreatableWorldServer(idx) then
      changeTexture_ByCreateStatus(tempUnableCreate, 0)
    else
      changeTexture_ByCreateStatus(tempUnableCreate, 1)
    end
    tempStatus:SetText(tempStr)
    tempStatus:SetSpanSize(tempUnableCreate:GetSizeX() * 2 + 10, -3)
    worldCtrl._bgButton = tempBtn
    worldCtrl._nameText = tempName
    worldCtrl._unableCreate = tempUnableCreate
    worldCtrl._countText = tempCount
    worldCtrl._statusText = tempStatus
    _worldServerCtrls[idx] = worldCtrl
  end
  for idx = 0, _worldServerCount - 1 do
    Panel_SelectServer_ReCreateChannelCtrl(idx)
  end
  _selectWorldIndex = -1
  Panel_Lobby_function_SelectWorldServer(PaGlobal_FindMyWorldServer())
  Panel_SelectServer_RePositioningCtrls()
  PaGlobal_CheckGamerTag()
  Panel_ServerSelect:SetShow(true, false)
end
function PaGlobal_FindMyWorldServer()
  local isAdult = ToClient_isAdultUser()
  local count = _worldServerCount
  for ii = 0, count - 1 do
    local serverData = getGameChannelServerDataByIndex(ii, 0)
    if isAdult == serverData._isAdultWorld then
      return ii
    end
  end
  return 0
end
function Panel_SelectServer_ReCreateChannelCtrl(worldIndex)
  local worldServerData = getGameWorldServerDataByIndex(worldIndex)
  local restrictedServerNo = worldServerData._restrictedServerNo
  local changeChannelTime = getChannelMoveableRemainTime(worldServerData._worldNo)
  local changeMoveChannel = getChannelMoveableTime(worldServerData._worldNo)
  local changeRealChannelTime = convertStringFromDatetime(changeChannelTime)
  local changeMoveChannelTime = convertStringFromDatetime(changeMoveChannel)
  _worldServerCtrls[worldIndex]._channelCount = getGameChannelServerDataCount(worldServerData._worldNo)
  _worldServerCtrls[worldIndex]._channelCtrls = {}
  isSpeedServer[worldIndex] = {}
  isNotSpeedServer[worldIndex] = {}
  local index1 = 0
  local index2 = 0
  for idx = 0, _worldServerCtrls[worldIndex]._channelCount - 1 do
    local serverData = getGameChannelServerDataByIndex(worldIndex, idx)
    if nil == serverData then
      break
    end
    local isAdmission = true
    if restrictedServerNo ~= 0 then
      if restrictedServerNo == serverData._serverNo then
        isAdmission = true
      elseif changeChannelTime > toInt64(0, 0) then
        isAdmission = false
      else
        isAdmission = true
      end
    end
    local strTemp = "ChannelBG_" .. tostring(worldIndex) .. "_" .. tostring(idx)
    local tempBG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, FRAME_SERVERLIST:GetFrameContent(), "ChannelBG_" .. tostring(worldIndex) .. "_" .. tostring(idx))
    CopyBaseProperty(CHANNEL_BG_STATIC, tempBG)
    tempBG:SetShow(false)
    tempBG:ActiveMouseEventEffect(true)
    tempBG:SetIgnore(false)
    local tempCheckMainServer = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, tempBG, "ChannelRadioBtn_" .. tostring(worldIndex) .. "_" .. tostring(idx))
    CopyBaseProperty(CHANNEL_MAINSERVER, tempCheckMainServer)
    tempCheckMainServer:SetPosX(270)
    tempCheckMainServer:SetPosY(7)
    tempCheckMainServer:SetShow(false)
    tempCheckMainServer:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SELECT"))
    local tempCheckMainServerSQ = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempBG, "ChannelSequense_" .. tostring(worldIndex) .. "_" .. tostring(idx))
    CopyBaseProperty(CHANNEL_MAINSERVERSQ, tempCheckMainServerSQ)
    tempCheckMainServerSQ:SetPosX(270)
    tempCheckMainServerSQ:SetPosY(7)
    tempCheckMainServerSQ:SetShow(false)
    local tempName = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempBG, "ChannelName_" .. tostring(worldIndex) .. "_" .. tostring(idx))
    CopyBaseProperty(CHANNEL_NAME_TEXT, tempName)
    tempName:SetShow(true)
    tempName:ActiveMouseEventEffect(true)
    local tempWar = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempBG, "ChannelWar_" .. tostring(worldIndex) .. "_" .. tostring(idx))
    CopyBaseProperty(channel_WarIcon, tempWar)
    tempWar:SetShow(false)
    tempWar:ActiveMouseEventEffect(true)
    local tempPremium = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempBG, "ChannelPremium_" .. tostring(worldIndex) .. "_" .. tostring(idx))
    CopyBaseProperty(channel_Premium, tempPremium)
    tempPremium:SetShow(false)
    tempPremium:ActiveMouseEventEffect(true)
    local tempPvPIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempBG, "ChannelPvP_" .. tostring(worldIndex) .. "_" .. tostring(idx))
    CopyBaseProperty(channel_PvPIcon, tempPvPIcon)
    tempPvPIcon:SetShow(false)
    tempPvPIcon:ActiveMouseEventEffect(true)
    tempPvPIcon:addInputEvent("Mouse_On", "PkIcon_SimpleTooltip(true)")
    tempPvPIcon:addInputEvent("Mouse_Out", "PkIcon_SimpleTooltip(false)")
    local tempMainIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempBG, "ChannelMainIcon_" .. tostring(worldIndex) .. "_" .. tostring(idx))
    CopyBaseProperty(CHANNEL_MAINICON_STATIC, tempMainIcon)
    tempMainIcon:SetShow(false)
    tempMainIcon:ActiveMouseEventEffect(true)
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
    tempName:SetText(channelName)
    tempName:SetPosX(15)
    tempName:SetPosY(13)
    if serverData._isMain == true then
      tempMainIcon:SetShow(false)
      tempMainIcon:SetPosX(15)
      tempMainIcon:SetPosY(17)
    end
    local tempStatus = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempBG, "ChannelStatus_" .. tostring(worldIndex) .. "_" .. tostring(idx))
    CopyBaseProperty(CHANNEL_STATUS_TEXT, tempStatus)
    tempStatus:SetShow(true)
    tempStatus:ActiveMouseEventEffect(true)
    local busyState = serverData._busyState
    if busyState == 0 or serverData:isClosed() then
      tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_0")
    elseif busyState == 1 then
      tempStr = ""
    elseif busyState == 2 then
      tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_2")
    elseif busyState == 3 then
      tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_3")
    elseif busyState == 4 then
      tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_4")
    end
    tempStatus:SetText(tempStr)
    tempStatus:SetPosX(160)
    tempStatus:SetPosY(14)
    local tempUnableCreate = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempBG, "ChannelCreateStatus_" .. tostring(idx))
    CopyBaseProperty(WORLD_SPEED_SERVER_IMG, tempUnableCreate)
    tempUnableCreate:SetShow(false)
    tempUnableCreate:SetPosX(230)
    tempUnableCreate:SetPosY(8)
    local tempBtn = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, tempBG, "ChannelButton_" .. tostring(worldIndex) .. "_" .. tostring(idx))
    CopyBaseProperty(CHANNEL_ENTER_BTN, tempBtn)
    tempBtn:SetIgnore(false)
    tempBtn:ActiveMouseEventEffect(true)
    tempBtn:SetPosX(270)
    tempBtn:SetPosY(7)
    tempBtn:addInputEvent("Mouse_LUp", "Panel_Lobby_function_EnterChannel(" .. idx .. ")")
    local tempChgChannel = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_MULTILINETEXT, tempBG, "ChannelChangeText_" .. tostring(worldIndex) .. "_" .. tostring(idx))
    CopyBaseProperty(CHANNEL_CHANGE_TEXT, tempChgChannel)
    tempChgChannel:SetIgnore(true)
    tempChgChannel:SetPosX(265)
    tempChgChannel:SetPosY(7)
    if true == isLoginIDShow() then
      tempBtn:SetShow(isAdmission)
      if changeChannelTime > toInt64(0, 0) then
        tempChgChannel:SetShow(not isAdmission)
        if tempChgChannel:GetShow() then
          tempBtn:SetShow(false)
        end
        tempChgChannel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANGECHANNEL", "changeRealChannelTime", changeRealChannelTime))
      end
    else
      tempBtn:SetShow(isAdmission and busyState ~= 0)
      local isTextShow = not isAdmission and busyState ~= 0
      tempChgChannel:SetShow(isTextShow)
      if tempChgChannel:GetShow() then
        tempBtn:SetShow(false)
      end
      if isTextShow then
        if changeChannelTime > toInt64(0, 0) then
          tempChgChannel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANGECHANNEL", "changeRealChannelTime", changeRealChannelTime))
        else
          tempChgChannel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANGECHANNEL", "changeRealChannelTime", 0))
        end
      end
    end
    if serverData._isSpeedChannel then
      tempUnableCreate:SetShow(true)
      isSpeedServer[worldIndex][index1] = idx
      tempBtn:SetShow(false)
      index1 = index1 + 1
    else
      tempUnableCreate:SetShow(false)
      isNotSpeedServer[worldIndex][index2] = idx
      index2 = index2 + 1
    end
    _worldServerCtrls[worldIndex]._channelCtrls[idx] = {}
    _worldServerCtrls[worldIndex]._channelCtrls[idx]._bgStatic = tempBG
    _worldServerCtrls[worldIndex]._channelCtrls[idx]._nameText = tempName
    _worldServerCtrls[worldIndex]._channelCtrls[idx]._warIcon = tempWar
    _worldServerCtrls[worldIndex]._channelCtrls[idx]._premiumIcon = tempPremium
    _worldServerCtrls[worldIndex]._channelCtrls[idx]._pvpIcon = tempPvPIcon
    _worldServerCtrls[worldIndex]._channelCtrls[idx]._statusText = tempStatus
    _worldServerCtrls[worldIndex]._channelCtrls[idx]._enterBtn = tempBtn
    _worldServerCtrls[worldIndex]._channelCtrls[idx]._changeChannel = tempChgChannel
    _worldServerCtrls[worldIndex]._channelCtrls[idx]._radioBtnMain = tempCheckMainServer
    _worldServerCtrls[worldIndex]._channelCtrls[idx]._mainServerSQ = tempCheckMainServerSQ
  end
  for idx = 0, index2 - 1 do
    isSpeedServer[worldIndex][index1 + idx] = isNotSpeedServer[worldIndex][idx]
  end
end
local delayTime = 1
local serverSelectDeltaTime = 0
function Panel_SelectServer_Delta(deltaTime)
  serverSelectDeltaTime = serverSelectDeltaTime + deltaTime
  if delayTime <= serverSelectDeltaTime then
    isSettingLastConnectServer = false
    local serverCount = getGameWorldServerDataCount()
    local temporaryWrapper = getTemporaryInformationWrapper()
    mainServerText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_NOMAINSERVER"))
    txt_EnterLastJoinServer:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_BTN_LASTJOINSERVER"))
    for index = 0, serverCount - 1 do
      local worldServerData = getGameWorldServerDataByIndex(index)
      local restrictedServerNo = worldServerData._restrictedServerNo
      local changeChannelTime = getChannelMoveableRemainTime(worldServerData._worldNo)
      changeChannelTime = changeChannelTime - toInt64(0, 20)
      local changeMoveChannel = getChannelMoveableTime(worldServerData._worldNo)
      local changeRealChannelTime = convertStringFromDatetime(changeChannelTime)
      local changeMoveChannelTime = convertStringFromDatetime(changeMoveChannel)
      for idx = 0, _worldServerCtrls[index]._channelCount - 1 do
        local serverData = getGameChannelServerDataByIndex(index, idx)
        if nil == serverData then
          break
        end
        local isBeingWar = serverData._isSiegeBeing
        local isVillageStart = serverData._isVillageSiege
        local isAdmission = true
        if restrictedServerNo ~= 0 then
          if restrictedServerNo == serverData._serverNo then
            isAdmission = true
          elseif changeChannelTime > toInt64(0, 0) then
            isAdmission = false
          else
            isAdmission = true
          end
        end
        local busyState = serverData._busyState
        if busyState == 0 or serverData:isClosed() then
          tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_0")
        elseif busyState == 1 then
          tempStr = ""
        elseif busyState == 2 then
          tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_2")
        elseif busyState == 3 then
          tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_3")
        elseif busyState == 4 then
          tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_4")
        end
        _worldServerCtrls[index]._channelCtrls[idx]._statusText:SetText(tempStr)
        local isTempShow = isAdmission and busyState ~= 0
        local admissionDesc = ""
        if false == isAdmission then
          admissionDesc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_ISADMISSION_LIMIT", "admissionDesc", admissionDesc)
        else
        end
        local channelName = getChannelName(worldServerData._worldNo, serverData._serverNo)
        _PA_ASSERT(nil ~= channelName, "\236\132\156\235\178\132 \236\157\180\235\166\132\236\157\128 \236\161\180\236\158\172\237\149\180\236\149\188\237\149\169\235\139\136\235\139\164.")
        if isGameServiceTypeDev() then
          channelName = channelName .. " " .. getDotIp(serverData) .. admissionDesc
          _worldServerCtrls[index]._channelCtrls[idx]._warIcon:SetShow(isBeingWar)
        elseif isBeingWar then
          if isVillageStart then
            channelName = channelName .. " " .. admissionDesc
            _worldServerCtrls[index]._channelCtrls[idx]._bgStatic:addInputEvent("Mouse_On", "ServerSelect_Simpletooltip(true, 0, " .. index .. ", " .. idx .. ")")
            _worldServerCtrls[index]._channelCtrls[idx]._bgStatic:addInputEvent("Mouse_Out", "ServerSelect_Simpletooltip(false)")
          else
            channelName = channelName .. " " .. admissionDesc
            _worldServerCtrls[index]._channelCtrls[idx]._bgStatic:addInputEvent("Mouse_On", "ServerSelect_Simpletooltip(true, 1, " .. index .. ", " .. idx .. ")")
            _worldServerCtrls[index]._channelCtrls[idx]._bgStatic:addInputEvent("Mouse_Out", "ServerSelect_Simpletooltip(false)")
          end
          _worldServerCtrls[index]._channelCtrls[idx]._warIcon:SetShow(true)
        else
          _worldServerCtrls[index]._channelCtrls[idx]._warIcon:SetShow(false)
          channelName = channelName .. " " .. admissionDesc
          _worldServerCtrls[index]._channelCtrls[idx]._bgStatic:addInputEvent("Mouse_On", "")
        end
        _worldServerCtrls[index]._channelCtrls[idx]._nameText:SetText(channelName)
        _worldServerCtrls[index]._channelCtrls[idx]._warIcon:SetPosX(235)
        _worldServerCtrls[index]._channelCtrls[idx]._warIcon:SetPosY(_worldServerCtrls[index]._channelCtrls[idx]._nameText:GetPosY())
        _worldServerCtrls[index]._channelCtrls[idx]._premiumIcon:SetPosX(235)
        _worldServerCtrls[index]._channelCtrls[idx]._premiumIcon:SetPosY(_worldServerCtrls[index]._channelCtrls[idx]._nameText:GetPosY())
        _worldServerCtrls[index]._channelCtrls[idx]._pvpIcon:SetPosX(235)
        _worldServerCtrls[index]._channelCtrls[idx]._pvpIcon:SetPosY(_worldServerCtrls[index]._channelCtrls[idx]._nameText:GetPosY())
        _worldServerCtrls[index]._channelCtrls[idx]._premiumIcon:SetShow(false)
        _worldServerCtrls[index]._channelCtrls[idx]._pvpIcon:SetShow(false)
        if true == isLoginIDShow() then
          _worldServerCtrls[index]._channelCtrls[idx]._enterBtn:SetShow(isAdmission and not isRadioBtnShow)
          _worldServerCtrls[index]._channelCtrls[idx]._radioBtnMain:SetShow(isAdmission and isRadioBtnShow)
          _worldServerCtrls[index]._channelCtrls[idx]._mainServerSQ:SetShow(isAdmission and isRadioBtnShow)
        elseif serverData._isPremiumChannel then
          if true == temporaryWrapper:isPremiumChannelPermission() then
            _worldServerCtrls[index]._channelCtrls[idx]._enterBtn:SetShow(isTempShow and not isRadioBtnShow)
            _worldServerCtrls[index]._channelCtrls[idx]._radioBtnMain:SetShow(isTempShow and isRadioBtnShow)
            _worldServerCtrls[index]._channelCtrls[idx]._mainServerSQ:SetShow(isTempShow and isRadioBtnShow)
          else
            _worldServerCtrls[index]._channelCtrls[idx]._enterBtn:SetShow(false)
            _worldServerCtrls[index]._channelCtrls[idx]._radioBtnMain:SetShow(false)
            _worldServerCtrls[index]._channelCtrls[idx]._mainServerSQ:SetShow(false)
          end
        elseif serverData._isSteamChannel then
          if true == isSteamClient() then
            _worldServerCtrls[index]._channelCtrls[idx]._enterBtn:SetShow(isTempShow and not isRadioBtnShow)
            _worldServerCtrls[index]._channelCtrls[idx]._radioBtnMain:SetShow(isTempShow and isRadioBtnShow)
            _worldServerCtrls[index]._channelCtrls[idx]._mainServerSQ:SetShow(isTempShow and isRadioBtnShow)
          else
            _worldServerCtrls[index]._channelCtrls[idx]._enterBtn:SetShow(false)
            _worldServerCtrls[index]._channelCtrls[idx]._radioBtnMain:SetShow(false)
            _worldServerCtrls[index]._channelCtrls[idx]._mainServerSQ:SetShow(false)
          end
        elseif serverData._isSpeedChannel then
          if 0 ~= temporaryWrapper:getMyAdmissionToSpeedServer() then
            _worldServerCtrls[index]._channelCtrls[idx]._enterBtn:SetShow(isTempShow and not isRadioBtnShow)
            _worldServerCtrls[index]._channelCtrls[idx]._radioBtnMain:SetShow(isTempShow and isRadioBtnShow)
            _worldServerCtrls[index]._channelCtrls[idx]._mainServerSQ:SetShow(isTempShow and isRadioBtnShow)
          else
            _worldServerCtrls[index]._channelCtrls[idx]._enterBtn:SetShow(false)
            _worldServerCtrls[index]._channelCtrls[idx]._radioBtnMain:SetShow(false)
            _worldServerCtrls[index]._channelCtrls[idx]._mainServerSQ:SetShow(false)
          end
        elseif serverData._isBalanceChannel then
          if ToClient_isAccessableBalanceChannel() then
            _worldServerCtrls[index]._channelCtrls[idx]._enterBtn:SetShow(isTempShow and not isRadioBtnShow)
            _worldServerCtrls[index]._channelCtrls[idx]._radioBtnMain:SetShow(isTempShow and isRadioBtnShow)
            _worldServerCtrls[index]._channelCtrls[idx]._mainServerSQ:SetShow(isTempShow and isRadioBtnShow)
          else
            _worldServerCtrls[index]._channelCtrls[idx]._enterBtn:SetShow(false)
            _worldServerCtrls[index]._channelCtrls[idx]._radioBtnMain:SetShow(false)
            _worldServerCtrls[index]._channelCtrls[idx]._mainServerSQ:SetShow(false)
          end
        elseif serverData._isPcroomChannel then
          _worldServerCtrls[index]._channelCtrls[idx]._premiumIcon:SetShow(true)
        else
          _worldServerCtrls[index]._channelCtrls[idx]._enterBtn:SetShow(isTempShow and not isRadioBtnShow)
          _worldServerCtrls[index]._channelCtrls[idx]._radioBtnMain:SetShow(isTempShow and isRadioBtnShow)
          _worldServerCtrls[index]._channelCtrls[idx]._mainServerSQ:SetShow(isTempShow and isRadioBtnShow)
        end
        if serverData._isDontPvPTendencyDecrease then
          _worldServerCtrls[index]._channelCtrls[idx]._pvpIcon:SetShow(true)
        end
        _worldServerCtrls[index]._channelCtrls[idx]._changeChannel:SetShow(not isTempShow)
        if 0 == busyState then
          _worldServerCtrls[index]._channelCtrls[idx]._changeChannel:SetShow(false)
        end
        _worldServerCtrls[index]._channelCtrls[idx]._changeChannel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CHANGECHANNEL", "changeRealChannelTime", changeRealChannelTime))
        local mainServerNo = ServerList_GetMainServerNo()
        if -1 ~= mainServerNo and serverData._serverNo == mainServerNo then
          mainServerText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SETMAINSERVER", "serverName", tostring(getChannelName(worldServerData._worldNo, serverData._serverNo))))
        end
        local lastServerNo = temporaryWrapper:getLastServerNo()
        if nil == getChannelName(worldServerData._worldNo, lastServerNo) then
          if false == isSettingLastConnectServer then
            txt_EnterLastJoinServer:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_BTN_LASTJOINSERVER"))
          end
        else
          txt_EnterLastJoinServer:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVERSELECT_LASTJOINSERVER_NUMBER", "lastJoinServer", tostring(getChannelName(worldServerData._worldNo, lastServerNo))))
          isSettingLastConnectServer = true
        end
        _worldServerCtrls[index]._channelCtrls[idx]._radioBtnMain:addInputEvent("Mouse_LUp", "ServerList_SetMainServer(" .. index .. "," .. idx .. ")")
      end
    end
    serverSelectDeltaTime = 0
  end
end
function Panel_SelectServer_ShowChannelCtrls(worldIndex)
  local retBool = false
  local count = _worldServerCount
  for idx = 0, count - 1 do
    local isShow = false
    if idx == worldIndex then
      retBool = true
      isShow = true
      if isGameServiceTypeKor() and false == ToClient_IsDevelopment() then
        if false == ToClient_CanEnterNonAdultWorld() then
          isShow = false
        end
        local serverData = getGameChannelServerDataByIndex(worldIndex, 0)
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
          isShow = false
          retBool = false
        end
      end
    end
    for channelIdx = 0, _worldServerCtrls[idx]._channelCount - 1 do
      _worldServerCtrls[idx]._channelCtrls[channelIdx]._bgStatic:SetShow(isShow)
    end
  end
  return retBool
end
function Panel_SelectServer_RePositioningCtrls()
  local bgPosY = SELECT_SERVER_BG_TEXT:GetPosY() + 20
  local worldSizeY = WORLD_BG_BTN:GetSizeY()
  local posX = SELECT_SERVER_BG_TEXT:GetPosX() + 20
  local posY = bgPosY + 30
  FRAME_SERVERLIST:SetPosX(posX)
  FRAME_SERVERLIST:SetPosY(posY)
  posX = 0
  posY = 0
  local count = _worldServerCount
  for idx = 0, count - 1 do
    _worldServerCtrls[idx]._bgButton:SetPosX(posX + 4)
    _worldServerCtrls[idx]._bgButton:SetPosY(posY + 5)
    local varyY = Panel_SelectServer_GetVariableSizeY(posX + 5, posY, idx)
    posY = posY + varyY
    SELECT_SERVER_BG_TEXT:SetSize(SELECT_SERVER_BG_TEXT:GetSizeX(), getScreenSizeY() - 20)
  end
  FRAME_SERVERLIST:SetSize(SELECT_SERVER_BG_TEXT:GetSizeX() - 40, SELECT_SERVER_BG_TEXT:GetSizeY() - 60 - 130)
  FRAMEContents_SERVERLIST:SetSize(SELECT_SERVER_BG_TEXT:GetSizeX() - 40, posY)
  FRAME_Scroll:SetSize(FRAME_Scroll:GetSizeX(), SELECT_SERVER_BG_TEXT:GetSizeY() - 60 - 110)
  FRAME_SERVERLIST:UpdateContentScroll()
  FRAME_Scroll:SetControlTop()
  FRAME_SERVERLIST:UpdateContentPos()
  if FRAME_SERVERLIST:GetSizeY() < FRAMEContents_SERVERLIST:GetSizeY() then
    FRAME_Scroll:SetShow(true)
  else
    FRAME_Scroll:SetShow(false)
  end
  mainServerBg:ComputePos()
end
function Panel_SelectServer_GetVariableSizeY(posX, posY, worldIndex)
  local default = WORLD_BG_BTN:GetSizeY() + 10
  if _selectWorldIndex ~= worldIndex then
    return default
  end
  local channelSizeY = CHANNEL_BG_STATIC:GetSizeY() + 5
  local count = _worldServerCtrls[worldIndex]._channelCount
  local tempPosY
  for idx = 0, count - 1 do
    tempPosY = posY + default + channelSizeY * idx
    _worldServerCtrls[worldIndex]._channelCtrls[isSpeedServer[worldIndex][idx]]._bgStatic:SetPosX(posX)
    _worldServerCtrls[worldIndex]._channelCtrls[isSpeedServer[worldIndex][idx]]._bgStatic:SetPosY(tempPosY)
  end
  FRAMEContents_SERVERLIST:SetSize(posX, tempPosY + default)
  return default + channelSizeY * count
end
function Panel_Lobby_function_SelectWorldServer(index)
  _oldSelectWorldIndex = _selectWorldIndex
  _selectWorldIndex = index
  if true == Panel_SelectServer_ShowChannelCtrls(index) then
    Panel_SelectServer_RePositioningCtrls()
  else
    Panel_Lobby_function_SelectWorldServer(_oldSelectWorldIndex)
  end
end
function Panel_Lobby_function_EnterChannel(index)
  if isGameServiceTypeKor() and false == ToClient_isAdultUser() and false == ToClient_CanEnterNonAdultWorld() then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_CANT_CONNECTABLE_TIME"),
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    Panel_Lobby_Function_EnableEnterChannelButton(false)
    return
  end
  if PaGlobalFunc_ServerSelectAutoConnectToLastServer() then
    return
  end
  if true == selectServerGroup(_selectWorldIndex, index) then
    Panel_Lobby_Function_EnableEnterChannelButton(false)
  end
end
function Panel_Lobby_Function_EnableEnterChannelButton(enableValue)
  for worldIndex = 0, _worldServerCount - 1 do
    for idx = 0, _worldServerCtrls[worldIndex]._channelCount - 1 do
      local tmpBG = UI.getChildControl(FRAME_SERVERLIST:GetFrameContent(), "ChannelBG_" .. tostring(worldIndex) .. "_" .. tostring(idx))
      local tmpButton = UI.getChildControl(tmpBG, "ChannelButton_" .. tostring(worldIndex) .. "_" .. tostring(idx))
      tmpButton:SetEnable(enableValue)
      tmpButton:SetMonoTone(not enableValue)
    end
  end
end
function Panel_Lobby_function_EnterMemorizedChannel(index)
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
  selectMemorizedServer(_selectWorldIndex, index)
end
function ServerList_RandomServerJoin()
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
  if PaGlobalFunc_ServerSelectAutoConnectToLastServer() then
    return
  end
  selectRandomServer(_selectWorldIndex)
end
function EventUpdateServerInformation_SelectServer()
  local isShow = Panel_ServerSelect:IsShow()
  if false == isShow then
    return
  end
  local selectIndex = _selectWorldIndex
  StartUp_Panel_SelectServer()
  if -1 ~= selectIndex then
    Panel_Lobby_function_SelectWorldServer(selectIndex)
  end
end
function SelectServer_RequestInfo_ForTest()
  requestServerInformationForTest()
end
function PanelServerSelect_Resize()
  local count = getGameWorldServerDataCount() + 1
  Panel_ServerSelect:SetSize(getScreenSizeX(), getScreenSizeY())
  SELECT_SERVER_BG_TEXT:SetSize(SELECT_SERVER_BG_TEXT:GetSizeX() + 21, count * 48 + 50)
  SELECT_SERVER_BG_TEXT:SetHorizonRight()
  FRAME_SERVERLIST:SetSize(SELECT_SERVER_BG_TEXT:GetSizeX() - 40, SELECT_SERVER_BG_TEXT:GetSizeY() - 60)
  FRAME_Scroll:SetSize(FRAME_Scroll:GetSizeX(), SELECT_SERVER_BG_TEXT:GetSizeY() - 60)
  FRAME_SERVERLIST:SetHorizonRight()
  FRAME_SERVERLIST:UpdateContentPos()
  if FRAME_SERVERLIST:GetSizeY() < FRAME_SERVERLIST:GetSizeY() then
    FRAME_Scroll:SetShow(true)
  else
    FRAME_Scroll:SetShow(false)
  end
  for ii = 1, totalBG do
    Static_Back[ii]:SetSize(getScreenSizeX(), getScreenSizeY())
  end
end
local currentBackIndex = bgStartIndex
Static_Back[currentBackIndex]:SetShow(true)
Static_Back[currentBackIndex]:SetAlpha(1)
local updateTime = 0
local isScope = true
local startUV = 0.1
local endUV = startUV + 0.04
local startUV2 = 0.9
local endUV2 = startUV2 + 0.04
function ChannelSelectInfo_onScreenResize()
  local self = channelSelectInfo
  local scrX = getScreenSizeX()
  self._mainBG:SetPosX(scrX - (FRAME_SERVERLIST:GetSizeX() + self._mainBG:GetSizeX() + 55))
  self._mainBG:SetPosY(10)
end
function SpeedChannelInfo_onScreenResize()
  local self = channelSpeedInfo
  local scrX = getScreenSizeX()
  self._speedMainBG:SetPosX(scrX - (FRAME_SERVERLIST:GetSizeX() + self._speedMainBG:GetSizeX() + 55))
  if isGameTypeRussia() then
    self._speedMainBG:SetPosY(10)
  else
    self._speedMainBG:SetPosY(channelSelectInfo._mainBG:GetPosY() + channelSelectInfo._mainBG:GetSizeY() + 10)
  end
end
function PKChannelInfo_onScreenResize()
  local self = channelPKInfo
  local scrX = getScreenSizeX()
  self._pkMainBG:SetPosX(scrX - (FRAME_SERVERLIST:GetSizeX() + channelSpeedInfo._speedMainBG:GetSizeX() + 55))
  if channelSpeedInfo._speedMainBG:GetShow() then
    self._pkMainBG:SetPosY(channelSpeedInfo._speedMainBG:GetPosY() + channelSpeedInfo._speedMainBG:GetSizeY() + 10)
  elseif channelSelectInfo._mainBG:GetShow() then
    self._pkMainBG:SetPosY(channelSelectInfo._mainBG:GetPosY() + channelSelectInfo._mainBG:GetSizeY() + 10)
  else
    self._pkMainBG:SetPosY(10)
  end
end
function warInfo_onScreenResize()
  local self = warInfo
  local scrX = getScreenSizeX()
  self._uiWarInfo:SetPosX(scrX - (FRAME_SERVERLIST:GetSizeX() + self._uiWarInfo:GetSizeX() + 55))
  if channelPKInfo._pkMainBG:GetShow() then
    self._uiWarInfo:SetPosY(channelPKInfo._pkMainBG:GetPosY() + channelPKInfo._pkMainBG:GetSizeY() + 10)
  elseif channelSpeedInfo._speedMainBG:GetShow() then
    self._uiWarInfo:SetPosY(channelSpeedInfo._speedMainBG:GetPosY() + channelSpeedInfo._speedMainBG:GetSizeY() + 10)
  elseif channelSelectInfo._mainBG:GetShow() then
    self._uiWarInfo:SetPosY(channelSelectInfo._mainBG:GetPosY() + channelSelectInfo._mainBG:GetSizeY() + 10)
  else
    self._uiWarInfo:SetPosY(10)
  end
end
function ChannelSelectInfo_Show()
  local self = channelSelectInfo
  ChannelSelectInfo_onScreenResize()
  self._mainBG:SetShow(true)
end
function ChannelSelectInfo_Hide()
  local self = channelSelectInfo
  if not self._mainBG:GetShow() then
    return
  end
  self._mainBG:SetShow(false)
end
function SpeedChannelInfo_Show()
  local self = channelSpeedInfo
  SpeedChannelInfo_onScreenResize()
  self._speedMainBG:SetShow(true)
end
function SpeedChannelInfo_Hide()
  local self = channelSpeedInfo
  if not self._speedMainBG:GetShow() then
    return
  end
  self._speedMainBG:SetShow(false)
end
function PKChannelInfo_Show()
  local self = channelPKInfo
  PKChannelInfo_onScreenResize()
  self._pkMainBG:SetShow(true)
end
function PKChannelInfo_Hide()
  local self = channelPKInfo
  if not self._pkMainBG:GetShow() then
    return
  end
  self._pkMainBG:SetShow(false)
end
function warInfo_Show()
  local self = warInfo
  warInfo_onScreenResize()
  self._uiWarInfo:SetShow(true)
end
function warInfo_Hide()
  local self = warInfo
  if not self._uiWarInfo:GetShow() then
    return
  end
  self._uiWarInfo:SetShow(false)
end
function Panel_ServerSelect_Update(deltaTime)
  Panel_SelectServer_Delta(deltaTime)
  updateTime = updateTime - deltaTime
  if updateTime <= 0 then
    updateTime = 15
    if isScope then
      Static_Back[currentBackIndex]:SetShow(true)
      isScope = false
      local FadeMaskAni = Static_Back[currentBackIndex]:addTextureUVAnimation(0, 15, 0)
      FadeMaskAni:SetStartUV(startUV, startUV, 0)
      FadeMaskAni:SetEndUV(endUV, startUV, 0)
      FadeMaskAni:SetStartUV(startUV2, startUV, 1)
      FadeMaskAni:SetEndUV(endUV2, startUV, 1)
      FadeMaskAni:SetStartUV(startUV, startUV2, 2)
      FadeMaskAni:SetEndUV(endUV, startUV2, 2)
      FadeMaskAni:SetStartUV(startUV2, startUV2, 3)
      FadeMaskAni:SetEndUV(endUV2, startUV2, 3)
    else
      isScope = true
      local FadeMaskAni = Static_Back[currentBackIndex]:addTextureUVAnimation(0, 15, 0)
      FadeMaskAni:SetEndUV(startUV, startUV, 0)
      FadeMaskAni:SetStartUV(endUV, startUV, 0)
      FadeMaskAni:SetEndUV(startUV2, startUV, 1)
      FadeMaskAni:SetStartUV(endUV2, startUV, 1)
      FadeMaskAni:SetEndUV(startUV, startUV2, 2)
      FadeMaskAni:SetStartUV(endUV, startUV2, 2)
      FadeMaskAni:SetEndUV(startUV2, startUV2, 3)
      FadeMaskAni:SetStartUV(endUV2, startUV2, 3)
      local fadeColor = Static_Back[currentBackIndex]:addColorAnimation(15, 17, 0)
      fadeColor:SetStartColor(Defines.Color.C_FFFFFFFF)
      fadeColor:SetEndColor(Defines.Color.C_00FFFFFF)
      currentBackIndex = currentBackIndex + 1
      if totalBG < currentBackIndex then
        currentBackIndex = getRandomValue(1, totalBG)
      end
      local baseTexture = Static_Back[currentBackIndex]:getBaseTexture()
      baseTexture:setUV(startUV, startUV, startUV2, startUV2)
      Static_Back[currentBackIndex]:setRenderTexture(baseTexture)
      local fadeColor2 = Static_Back[currentBackIndex]:addColorAnimation(12, 15, 0)
      fadeColor2:SetStartColor(Defines.Color.C_00FFFFFF)
      fadeColor2:SetEndColor(Defines.Color.C_FFFFFFFF)
    end
  end
end
function ServerList_GetMainServerNo()
  local mainServerNo = ToClient_getUserSubCacheData(__eMainServerNo)
  return mainServerNo
end
function ServerList_ToggleRadioBtn()
  if true == isRadioBtnShow then
    isRadioBtnShow = false
  elseif false == isRadioBtnShow then
    isRadioBtnShow = true
  end
end
function ServerList_SetMainServer(worldIndex, serverIndex)
  local worldServerData = getGameWorldServerDataByIndex(worldIndex)
  local serverData = getGameChannelServerDataByIndex(worldIndex, serverIndex)
  if nil == serverData then
    Proc_ShowMessage_Ack("\236\158\152\235\170\187\235\144\156 \236\132\156\235\178\132 \236\160\149\235\179\180\236\158\133\235\139\136\235\139\164. \235\139\164\236\139\156 \236\139\156\235\143\132\237\149\180\236\163\188\236\132\184\236\154\148.")
    return
  end
  local function Set_MainServer()
    local serverData = getGameChannelServerDataByIndex(worldIndex, serverIndex)
    local serverNo = serverData._serverNo
    ToClient_setUserSubCacheData(__eMainServerNo, serverNo)
    isRadioBtnShow = false
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
function ServerSelect_Simpletooltip(isShow, tipType, index, idx)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  local warName = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_LOCALWAR")
  if 0 == tipType then
    warName = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_LOCALWAR")
  elseif 1 == tipType then
    warName = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_TERRITORYWAR")
  end
  name = warName
  control = _worldServerCtrls[index]._channelCtrls[idx]._bgStatic
  TooltipSimple_Show(control, name, desc)
end
function PkIcon_SimpleTooltip(isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_SEVERSELECT_PK")
  TooltipSimple_Show(channel_PvPIcon, name)
end
function ServerList_EnterMainServer()
  if PaGlobalFunc_ServerSelectAutoConnectToLastServer() then
    return
  end
  local mainServerNo = ServerList_GetMainServerNo()
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
  local worldServerData = getGameWorldServerDataByIndex(_selectWorldIndex)
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
  for idx = 0, _worldServerCtrls[_selectWorldIndex]._channelCount - 1 do
    local serverData = getGameChannelServerDataByIndex(_selectWorldIndex, idx)
    if nil == serverData then
      break
    end
    if ServerList_GetMainServerNo() == serverData._serverNo then
      Panel_Lobby_function_EnterMemorizedChannel(idx)
      break
    end
  end
end
function ServerList_LastJoinServer()
  local tempWrapper = getTemporaryInformationWrapper()
  local lastJoinServerNo = tempWrapper:getLastServerNo()
  if 1 == lastJoinServerNo then
    return
  end
  local worldServerData = getGameWorldServerDataByIndex(_selectWorldIndex)
  local channelCount = getGameChannelServerDataCount(worldServerData._worldNo)
  for idx = 0, _worldServerCtrls[_selectWorldIndex]._channelCount - 1 do
    local serverData = getGameChannelServerDataByIndex(_selectWorldIndex, idx)
    if nil == serverData then
      break
    end
    if serverData._serverNo == lastJoinServerNo then
      Panel_Lobby_function_EnterMemorizedChannel(idx)
      break
    end
  end
end
btn_SetMainServer:addInputEvent("Mouse_LUp", "ServerList_ToggleRadioBtn()")
btn_EnterMainServer:addInputEvent("Mouse_LUp", "ServerList_EnterMainServer()")
btn_EnterLastJoinServer:addInputEvent("Mouse_LUp", "ServerList_LastJoinServer()")
btn_RandomJoinServer:addInputEvent("Mouse_LUp", "ServerList_RandomServerJoin()")
registerEvent("EventChangeLobbyStageToServerSelect", "StartUp_Panel_SelectServer")
registerEvent("EventUpdateServerInformationForServerSelect", "EventUpdateServerInformation_SelectServer")
Panel_ServerSelect:RegisterUpdateFunc("Panel_ServerSelect_Update")
registerEvent("onScreenResize", "PanelServerSelect_Resize")
PanelServerSelect_Resize()
warInfo_Init()
channelSelectInfo_Init()
SpeedChannelInfo_Init()
PKChannelInfo_Init()

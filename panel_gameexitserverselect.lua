local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
Panel_ChannelSelect:SetShow(false)
Panel_ChannelSelect:RegisterShowEventFunc(true, "Panel_ChannelSelect_ShowAni()")
Panel_ChannelSelect:RegisterShowEventFunc(false, "Panel_ChannelSelect_HideAni()")
local channelSelect = {
  _BlockBG = UI.getChildControl(Panel_ChannelSelect, "Static_BlockBG"),
  _close_btn = UI.getChildControl(Panel_ChannelSelect, "Button_Close"),
  _question_btn = UI.getChildControl(Panel_ChannelSelect, "Button_Question"),
  _allBG = UI.getChildControl(Panel_ChannelSelect, "Static_AllBG"),
  _title = UI.getChildControl(Panel_ChannelSelect, "StaticText_Title"),
  _subframe = UI.getChildControl(Panel_ChannelSelect, "Static_SubFrame"),
  _channelBg = UI.getChildControl(Panel_ChannelSelect, "Static_Channel_BG"),
  _currentChBg = UI.getChildControl(Panel_ChannelSelect, "Static_CurrentChannel_BG"),
  _selectedChBg = UI.getChildControl(Panel_ChannelSelect, "StaticText_SelectedChannelBg"),
  _warIcon = UI.getChildControl(Panel_ChannelSelect, "StaticText_WarIcon"),
  _noEnteranceIcon = UI.getChildControl(Panel_ChannelSelect, "StaticText_NoEnterance"),
  _maintenanceIcon = UI.getChildControl(Panel_ChannelSelect, "StaticText_Maintenance"),
  _expIcon = UI.getChildControl(Panel_ChannelSelect, "StaticText_ExpEvent"),
  _PremiumIcon = UI.getChildControl(Panel_ChannelSelect, "StaticText_Preminum"),
  _PKIcon = UI.getChildControl(Panel_ChannelSelect, "StaticText_PK"),
  _CheckDescIcon = UI.getChildControl(Panel_ChannelSelect, "CheckButton_Desc"),
  _mainDesc = UI.getChildControl(Panel_ChannelSelect, "Static_ChannelSelectDescPanel"),
  _txt_timeIcon = UI.getChildControl(Panel_ChannelSelect, "StaticText_TimeIcon"),
  _txt_timeDesc = UI.getChildControl(Panel_ChannelSelect, "StaticText_Desc"),
  channelSelectData = {},
  isSpeedServer = {},
  isNotSpeedServer = {},
  groupBg = {},
  channelSelectUIPool = {},
  _selectChannel = -1,
  _channelUiMaxCount = 0,
  _serverCountInGroup = 0
}
channelSelect._mainDescBg = UI.getChildControl(channelSelect._mainDesc, "Static_ChannelSelectDescBG")
local isCalpheon = ToClient_IsContentsGroupOpen("2")
local isMedia = ToClient_IsContentsGroupOpen("3")
local isValencia = ToClient_IsContentsGroupOpen("4")
local isSiegeEnable = ToClient_IsContentsGroupOpen("21")
local channelGroupCount = {}
if isGameTypeKorea() then
  channelGroupCount = {
    [0] = 5,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    1
  }
elseif isGameTypeJapan() then
  channelGroupCount = {
    [0] = 4,
    4,
    4,
    4,
    4,
    4,
    2
  }
elseif isGameTypeRussia() then
  channelGroupCount = {
    [0] = 3,
    4,
    4,
    4,
    4,
    4
  }
elseif isGameTypeEnglish() then
  channelGroupCount = {
    [0] = 2,
    6,
    6,
    6,
    6,
    6,
    6
  }
elseif isGameTypeTaiwan() then
  channelGroupCount = {
    [0] = 3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3
  }
else
  channelGroupCount = {
    [0] = 5,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3
  }
end
local channelChildControl = {
  _name = UI.getChildControl(channelSelect._channelBg, "StaticText_ChannelName"),
  _status = UI.getChildControl(channelSelect._channelBg, "StaticText_Status"),
  _warIcon = UI.getChildControl(channelSelect._channelBg, "Static_WarIcon"),
  _noEnteranceIcon = UI.getChildControl(channelSelect._channelBg, "Static_NoEnterance"),
  _maintenanceIcon = UI.getChildControl(channelSelect._channelBg, "Static_Maintenance"),
  _expIcon = UI.getChildControl(channelSelect._channelBg, "Static_ExpEvent"),
  _premiumIcon = UI.getChildControl(channelSelect._channelBg, "Static_Premium"),
  _pkIcon = UI.getChildControl(channelSelect._channelBg, "Static_PK")
}
local channelMainDesc = {
  _serverTitle = UI.getChildControl(channelSelect._mainDescBg, "StaticText_ChannelSelectTitle"),
  _serverDesc = UI.getChildControl(channelSelect._mainDescBg, "StaticText_ChannelSelectDesc"),
  _speedTitle = UI.getChildControl(channelSelect._mainDescBg, "StaticText_SpeedTitle"),
  _speedDesc = UI.getChildControl(channelSelect._mainDescBg, "StaticText_SpeedDesc"),
  _pkTitle = UI.getChildControl(channelSelect._mainDescBg, "StaticText_PKTitle"),
  _pkDesc = UI.getChildControl(channelSelect._mainDescBg, "StaticText_PKDesc"),
  _siegeTitle = UI.getChildControl(channelSelect._mainDescBg, "StaticText_Channel"),
  _siegeBalenos = UI.getChildControl(channelSelect._mainDescBg, "StaticText_Siege_Balenos"),
  _siegeSerendia = UI.getChildControl(channelSelect._mainDescBg, "StaticText_Siege_Serendia"),
  _siegeCalpheon = UI.getChildControl(channelSelect._mainDescBg, "StaticText_Siege_Calpheon"),
  _siegeMedia = UI.getChildControl(channelSelect._mainDescBg, "StaticText_Siege_Media"),
  _siegeValencia = UI.getChildControl(channelSelect._mainDescBg, "StaticText_Siege_Valencia"),
  _scheduleTitle = UI.getChildControl(channelSelect._mainDescBg, "StaticText_Schedule"),
  _scheduleSiege = UI.getChildControl(channelSelect._mainDescBg, "StaticText_Schedule_Siege"),
  _scheduleNodeWar = UI.getChildControl(channelSelect._mainDescBg, "StaticText_Schedule_Nodewar")
}
function Panel_ChannelSelect_ShowAni()
  audioPostEvent_SystemUi(1, 0)
  Panel_ChannelSelect:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_ChannelSelect, 0, 0.3)
end
function Panel_ChannelSelect_HideAni()
  audioPostEvent_SystemUi(1, 1)
  local ani1 = UIAni.AlphaAnimation(0, Panel_ChannelSelect, 0, 0.2)
  ani1:SetHideAtEnd(true)
end
local bgIndex
function ChannelSelect_Init()
  local self = channelSelect
  local curChannelData = getCurrentChannelServerData()
  if nil == curChannelData then
    return
  end
  local isChannelCountLow = false
  local curWorldData = getGameWorldServerDataByWorldNo(curChannelData._worldNo)
  local channelCount = getGameChannelServerDataCount(curWorldData._worldNo)
  local instanceChannelCount = ToClient_InstanceChannelCount(curChannelData._worldNo)
  if channelCount >= instanceChannelCount and false == ToClient_SelfPlayerIsGM() then
    channelCount = channelCount - instanceChannelCount
  end
  if channelCount < 20 then
    isChannelCountLow = true
  end
  local halfChannelCount = math.ceil(channelCount / 2)
  local channelGroupIndex = 0
  while not (halfChannelCount <= self._channelUiMaxCount) do
    self._channelUiMaxCount = self._channelUiMaxCount + channelGroupCount[channelGroupIndex]
    channelGroupIndex = channelGroupIndex + 1
  end
  bgIndex = math.floor((channelCount - 1) / self._channelUiMaxCount)
  if isChannelCountLow then
    bgIndex = 0
    self._channelUiMaxCount = 20
  end
  for index = 0, bgIndex do
    if nil == self.groupBg[index] then
      self.groupBg[index] = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_ChannelSelect, "Static_ChannelGroupBg_" .. index)
      CopyBaseProperty(self._allBG, self.groupBg[index])
      self.groupBg[index]:SetPosX(15 + (self._allBG:GetSizeX() + 5) * index)
      self.groupBg[index]:SetShow(true)
      self.groupBg[index]:SetSize(self.groupBg[index]:GetSizeX(), self._channelUiMaxCount * 30 + 5)
    end
  end
  local isAdult = ToClient_isAdultUser()
  if isChannelCountLow then
    for index = 0, channelCount - 1 do
      local channelList = {}
      channelList.channelBg = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, self.groupBg[0], "create_ChannelBg_" .. index)
      channelList.channelCurrentBg = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, channelList.channelBg, "create_ChannelCurrentBg_" .. index)
      channelList.channelSelectedBg = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, channelList.channelBg, "create_ChannelSelectedBg_" .. index)
      channelList.channelName = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, channelList.channelBg, "create_ChannelName_" .. index)
      channelList.channelStatus = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, channelList.channelBg, "create_ChannelStatus_" .. index)
      channelList.channelWaricon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, channelList.channelBg, "create_ChannelWaricon_" .. index)
      channelList.channelnoEnterIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, channelList.channelBg, "create_ChannelNoEnterIcon_" .. index)
      channelList.channelMaintenanceIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, channelList.channelBg, "create_ChannelMaintenanceIcon_" .. index)
      channelList.channelExpIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, channelList.channelBg, "create_ChannelExpIcon_" .. index)
      channelList.channelPremiumIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, channelList.channelBg, "create_ChannelPremiumIcon_" .. index)
      channelList.channelPKIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, channelList.channelBg, "create_ChannelPKIcon_" .. index)
      CopyBaseProperty(self._channelBg, channelList.channelBg)
      CopyBaseProperty(self._currentChBg, channelList.channelCurrentBg)
      CopyBaseProperty(self._selectedChBg, channelList.channelSelectedBg)
      CopyBaseProperty(channelChildControl._name, channelList.channelName)
      CopyBaseProperty(channelChildControl._status, channelList.channelStatus)
      CopyBaseProperty(channelChildControl._warIcon, channelList.channelWaricon)
      CopyBaseProperty(channelChildControl._noEnteranceIcon, channelList.channelnoEnterIcon)
      CopyBaseProperty(channelChildControl._maintenanceIcon, channelList.channelMaintenanceIcon)
      CopyBaseProperty(channelChildControl._expIcon, channelList.channelExpIcon)
      CopyBaseProperty(channelChildControl._premiumIcon, channelList.channelPremiumIcon)
      CopyBaseProperty(channelChildControl._pkIcon, channelList.channelPKIcon)
      channelList.channelBg:SetShow(true)
      channelList.channelBg:SetPosX(3)
      channelList.channelBg:SetPosY(5 + (channelList.channelBg:GetSizeY() + 5) * index)
      channelList.channelCurrentBg:SetShow(false)
      channelList.channelCurrentBg:SetPosX(0)
      channelList.channelCurrentBg:SetPosY(0)
      channelList.channelSelectedBg:SetShow(false)
      channelList.channelSelectedBg:SetPosX(0)
      channelList.channelSelectedBg:SetPosY(0)
      self.channelSelectUIPool[index] = channelList
    end
  else
    for index = 0, channelCount - 1 do
      local _bgIndex = math.floor(index / self._channelUiMaxCount)
      local channelList = {}
      channelList.channelBg = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, self.groupBg[_bgIndex], "create_ChannelBg_" .. index)
      channelList.channelCurrentBg = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, channelList.channelBg, "create_ChannelCurrentBg_" .. index)
      channelList.channelSelectedBg = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, channelList.channelBg, "create_ChannelSelectedBg_" .. index)
      channelList.channelName = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, channelList.channelBg, "create_ChannelName_" .. index)
      channelList.channelStatus = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, channelList.channelBg, "create_ChannelStatus_" .. index)
      channelList.channelWaricon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, channelList.channelBg, "create_ChannelWaricon_" .. index)
      channelList.channelnoEnterIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, channelList.channelBg, "create_ChannelNoEnterIcon_" .. index)
      channelList.channelMaintenanceIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, channelList.channelBg, "create_ChannelMaintenanceIcon_" .. index)
      channelList.channelExpIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, channelList.channelBg, "create_ChannelExpIcon_" .. index)
      channelList.channelPremiumIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, channelList.channelBg, "create_ChannelPremiumIcon_" .. index)
      channelList.channelPKIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, channelList.channelBg, "create_ChannelPKIcon_" .. index)
      CopyBaseProperty(self._channelBg, channelList.channelBg)
      CopyBaseProperty(self._currentChBg, channelList.channelCurrentBg)
      CopyBaseProperty(self._selectedChBg, channelList.channelSelectedBg)
      CopyBaseProperty(channelChildControl._name, channelList.channelName)
      CopyBaseProperty(channelChildControl._status, channelList.channelStatus)
      CopyBaseProperty(channelChildControl._warIcon, channelList.channelWaricon)
      CopyBaseProperty(channelChildControl._noEnteranceIcon, channelList.channelnoEnterIcon)
      CopyBaseProperty(channelChildControl._maintenanceIcon, channelList.channelMaintenanceIcon)
      CopyBaseProperty(channelChildControl._expIcon, channelList.channelExpIcon)
      CopyBaseProperty(channelChildControl._premiumIcon, channelList.channelPremiumIcon)
      CopyBaseProperty(channelChildControl._pkIcon, channelList.channelPKIcon)
      channelList.channelBg:SetShow(true)
      channelList.channelBg:SetPosX(3)
      channelList.channelBg:SetPosY(5 + (channelList.channelBg:GetSizeY() + 5) * (index % self._channelUiMaxCount))
      channelList.channelCurrentBg:SetShow(false)
      channelList.channelCurrentBg:SetPosX(0)
      channelList.channelCurrentBg:SetPosY(0)
      channelList.channelSelectedBg:SetShow(false)
      channelList.channelSelectedBg:SetPosX(0)
      channelList.channelSelectedBg:SetPosY(0)
      self.channelSelectUIPool[index] = channelList
    end
  end
  channelMainDesc._serverTitle:SetPosY(20)
  channelMainDesc._serverDesc:SetPosY(45)
  channelMainDesc._serverDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  channelMainDesc._serverDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_CHANNELSELECTDESC"))
  channelMainDesc._pkTitle:SetShow(false)
  channelMainDesc._pkDesc:SetShow(false)
  channelMainDesc._siegeCalpheon:SetShow(false)
  channelMainDesc._siegeMedia:SetShow(false)
  channelMainDesc._siegeValencia:SetShow(false)
  local sizeControl
  if isGameTypeSA() then
    channelMainDesc._pkTitle:SetShow(false)
    channelMainDesc._pkDesc:SetShow(false)
    sizeControl = channelMainDesc._speedDesc
  elseif isGameTypeTH() or isGameTypeID() then
    channelMainDesc._speedTitle:SetShow(false)
    channelMainDesc._speedDesc:SetShow(false)
    sizeControl = channelMainDesc._serverDesc
  elseif isGameTypeKR2() or isGameTypeGT() then
    channelMainDesc._speedTitle:SetShow(false)
    channelMainDesc._speedDesc:SetShow(false)
    channelMainDesc._siegeTitle:SetShow(false)
    channelMainDesc._siegeBalenos:SetShow(false)
    channelMainDesc._siegeSerendia:SetShow(false)
    channelMainDesc._siegeCalpheon:SetShow(false)
    channelMainDesc._siegeMedia:SetShow(false)
    channelMainDesc._siegeValencia:SetShow(false)
    channelMainDesc._scheduleTitle:SetShow(false)
    channelMainDesc._scheduleSiege:SetShow(false)
    channelMainDesc._scheduleNodeWar:SetShow(false)
    sizeControl = channelMainDesc._serverDesc
  elseif isGameTypeRussia() or isGameTypeEnglish() or isGameTypeJapan() or isGameTypeTR() then
    channelMainDesc._pkTitle:SetShow(true)
    channelMainDesc._pkDesc:SetShow(true)
    sizeControl = channelMainDesc._pkDesc
  elseif isGameTypeKorea() then
    if isAdult then
      channelMainDesc._serverDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_CHANNELSELECTDESC"))
      channelMainDesc._pkTitle:SetShow(true)
      channelMainDesc._pkDesc:SetShow(true)
      sizeControl = channelMainDesc._pkDesc
    else
      channelMainDesc._serverDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_CHANNELSELECTDESC_15"))
      channelMainDesc._pkTitle:SetShow(false)
      channelMainDesc._pkDesc:SetShow(false)
      sizeControl = channelMainDesc._pkDesc
    end
  else
    sizeControl = channelMainDesc._speedDesc
  end
  if channelMainDesc._siegeTitle:GetShow() then
    if isCalpheon and isSiegeEnable then
      channelMainDesc._siegeCalpheon:SetShow(true)
    else
      channelMainDesc._siegeCalpheon:SetShow(false)
    end
    if isMedia and isSiegeEnable then
      channelMainDesc._siegeMedia:SetShow(true)
    else
      channelMainDesc._siegeMedia:SetShow(false)
    end
    if isValencia and isSiegeEnable then
      channelMainDesc._siegeValencia:SetShow(true)
    else
      channelMainDesc._siegeValencia:SetShow(false)
    end
  end
  channelMainDesc._speedTitle:SetPosY(channelMainDesc._serverDesc:GetPosY() + channelMainDesc._serverDesc:GetTextSizeY() + 20)
  channelMainDesc._speedTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SPEEDCHANNEL_TITLE"))
  channelMainDesc._speedDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  if isGameTypeTaiwan() then
    channelMainDesc._speedDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SPEEDCHANNEL_DESC_TW"))
  else
    channelMainDesc._speedDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_SPEEDCHANNEL_DESC"))
  end
  channelMainDesc._speedDesc:SetPosY(channelMainDesc._speedTitle:GetPosY() + 25)
  channelMainDesc._pkTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_SEVERSELECT_PK"))
  channelMainDesc._pkDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  if isGameTypeKorea() then
    channelMainDesc._pkDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_PVPDESC_ARSHASERVER"))
  else
    channelMainDesc._pkDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVERSELECT_PVPDESC"))
  end
  channelMainDesc._pkTitle:SetPosY(channelMainDesc._speedDesc:GetPosY() + channelMainDesc._speedDesc:GetTextSizeY() + 20)
  channelMainDesc._pkDesc:SetPosY(channelMainDesc._pkTitle:GetPosY() + 25)
  if isGameTypeTH() or isGameTypeID() then
    channelMainDesc._pkTitle:SetPosY(channelMainDesc._serverDesc:GetPosY() + channelMainDesc._serverDesc:GetTextSizeY() + 20)
    channelMainDesc._pkDesc:SetPosY(channelMainDesc._pkTitle:GetPosY() + 25)
    channelMainDesc._pkTitle:SetShow(true)
    channelMainDesc._pkDesc:SetShow(true)
    sizeControl = channelMainDesc._pkDesc
  end
  channelMainDesc._siegeTitle:SetPosY(sizeControl:GetPosY() + sizeControl:GetTextSizeY() + 20)
  channelMainDesc._siegeBalenos:SetPosY(channelMainDesc._siegeTitle:GetPosY() + 25)
  channelMainDesc._siegeSerendia:SetPosY(channelMainDesc._siegeBalenos:GetPosY() + 20)
  channelMainDesc._siegeCalpheon:SetPosY(channelMainDesc._siegeSerendia:GetPosY() + 20)
  channelMainDesc._siegeMedia:SetPosY(channelMainDesc._siegeCalpheon:GetPosY() + 20)
  channelMainDesc._siegeValencia:SetPosY(channelMainDesc._siegeMedia:GetPosY() + 20)
  channelMainDesc._scheduleTitle:SetPosY(channelMainDesc._siegeValencia:GetPosY() + 30)
  if isCalpheon then
    channelMainDesc._scheduleTitle:SetPosY(channelMainDesc._siegeCalpheon:GetPosY() + 30)
  end
  if isMedia then
    channelMainDesc._scheduleTitle:SetPosY(channelMainDesc._siegeMedia:GetPosY() + 30)
  end
  if isValencia then
    channelMainDesc._scheduleTitle:SetPosY(channelMainDesc._siegeValencia:GetPosY() + 30)
  end
  channelMainDesc._scheduleSiege:SetPosY(channelMainDesc._scheduleTitle:GetPosY() + 20)
  channelMainDesc._scheduleNodeWar:SetPosY(channelMainDesc._scheduleSiege:GetPosY() + 20)
  if isGameTypeKorea() and not isAdult then
    channelMainDesc._pkTitle:SetShow(false)
    channelMainDesc._pkDesc:SetShow(false)
    channelMainDesc._speedTitle:SetShow(false)
    channelMainDesc._speedDesc:SetShow(false)
    channelMainDesc._siegeTitle:SetShow(false)
    channelMainDesc._siegeBalenos:SetShow(false)
    channelMainDesc._siegeSerendia:SetShow(false)
    channelMainDesc._siegeCalpheon:SetShow(false)
    channelMainDesc._siegeMedia:SetShow(false)
    channelMainDesc._siegeValencia:SetShow(false)
    channelMainDesc._scheduleTitle:SetShow(false)
    channelMainDesc._scheduleSiege:SetShow(false)
    channelMainDesc._scheduleNodeWar:SetShow(false)
  end
  if isGameTypeKR2() or isGameTypeGT() then
    self._mainDescBg:SetSize(self._mainDescBg:GetSizeX(), channelMainDesc._serverDesc:GetPosY() + channelMainDesc._serverDesc:GetTextSizeY() + 15)
  elseif isGameTypeKorea() then
    if isAdult then
      self._mainDescBg:SetSize(self._mainDescBg:GetSizeX(), channelMainDesc._scheduleNodeWar:GetPosY() + channelMainDesc._scheduleNodeWar:GetTextSizeY() + 15)
    else
      self._mainDescBg:SetSize(self._mainDescBg:GetSizeX(), channelMainDesc._serverDesc:GetPosY() + channelMainDesc._serverDesc:GetTextSizeY() + 15)
    end
  else
    self._mainDescBg:SetSize(self._mainDescBg:GetSizeX(), channelMainDesc._scheduleNodeWar:GetPosY() + channelMainDesc._scheduleNodeWar:GetTextSizeY() + 15)
  end
  self._mainDesc:SetSize(self._mainDesc:GetSizeX(), self._mainDescBg:GetSizeY() + 15)
  self._warIcon:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHANNELSELECTE_WARICON"))
  self._noEnteranceIcon:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHANNELSELECTE_NOENTERANCEICON"))
  self._maintenanceIcon:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHANNELSELECTE_MAINTENANCEICON"))
  self._expIcon:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHANNELSELECTE_EXPEVENTICON"))
  self._PremiumIcon:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_SEVERSELECT_PCROOMSERVER"))
  self._PKIcon:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_SEVERSELECT_PK"))
  if isChannelCountLow then
    if isGameTypeRussia() or isGameTypeKorea() or isGameTypeEnglish() or isGameTypeJapan() or isGameTypeTR() then
      Panel_ChannelSelect:SetSize(410, self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 90)
    else
      Panel_ChannelSelect:SetSize(410, self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 70)
    end
    self._title:SetSize(400, self._title:GetSizeY())
    self._warIcon:ComputePos()
    self._noEnteranceIcon:ComputePos()
    self._maintenanceIcon:ComputePos()
    self._expIcon:ComputePos()
    self._PremiumIcon:ComputePos()
    self._PKIcon:ComputePos()
    self._warIcon:SetPosX(15)
    self._warIcon:SetPosY(self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 10)
    self._noEnteranceIcon:SetPosX(self._warIcon:GetPosX() + self._warIcon:GetSizeX() + self._warIcon:GetTextSizeX() + 15)
    self._noEnteranceIcon:SetPosY(self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 10)
    self._maintenanceIcon:SetPosX(15)
    self._maintenanceIcon:SetPosY(self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 30)
    self._expIcon:SetPosX(self._maintenanceIcon:GetPosX() + self._maintenanceIcon:GetSizeX() + self._maintenanceIcon:GetTextSizeX() + 15)
    self._expIcon:SetPosY(self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 30)
    self._PremiumIcon:SetPosX(self._expIcon:GetPosX() + self._expIcon:GetSizeX() + self._expIcon:GetTextSizeX() + 15)
    self._PremiumIcon:SetPosY(self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 30)
    self._PKIcon:SetPosX(15)
    self._PKIcon:SetPosY(self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 55)
  else
    if isGameTypeKorea() or isGameTypeRussia() or isGameTypeEnglish() or isGameTypeJapan() or isGameTypeTR() then
      Panel_ChannelSelect:SetSize(796, self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 70)
    else
      Panel_ChannelSelect:SetSize(796, self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 50)
    end
    self._title:SetSize(786, self._title:GetSizeY())
    self._warIcon:ComputePos()
    self._noEnteranceIcon:ComputePos()
    self._maintenanceIcon:ComputePos()
    self._expIcon:ComputePos()
    self._PremiumIcon:ComputePos()
    self._PKIcon:ComputePos()
    self._warIcon:SetPosY(self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 10)
    self._noEnteranceIcon:SetPosY(self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 10)
    self._maintenanceIcon:SetPosY(self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 10)
    self._expIcon:SetPosY(self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 10)
    self._PremiumIcon:SetPosY(self.groupBg[0]:GetPosY() + self.groupBg[0]:GetSizeY() + 10)
    self._noEnteranceIcon:SetPosX(self._warIcon:GetPosX() + self._warIcon:GetSizeX() + self._warIcon:GetTextSizeX() + 15)
    self._maintenanceIcon:SetPosX(self._noEnteranceIcon:GetPosX() + self._noEnteranceIcon:GetSizeX() + self._noEnteranceIcon:GetTextSizeX() + 15)
    self._expIcon:SetPosX(self._maintenanceIcon:GetPosX() + self._maintenanceIcon:GetSizeX() + self._maintenanceIcon:GetTextSizeX() + 15)
    self._PremiumIcon:SetPosX(self._expIcon:GetPosX() + self._expIcon:GetSizeX() + self._expIcon:GetTextSizeX() + 15)
    self._PKIcon:SetPosX(20)
  end
  if isGameTypeKorea() then
    self._PremiumIcon:SetShow(true)
  else
    self._PremiumIcon:SetShow(false)
  end
  if isGameTypeKorea() or isGameTypeRussia() or isGameTypeEnglish() or isGameTypeJapan() or isGameTypeTR() then
    self._PKIcon:SetShow(true)
  else
    self._PKIcon:SetShow(false)
  end
  if isGameTypeKR2() or isGameTypeGT() then
    channelSelect._warIcon:SetShow(false)
    channelSelect._noEnteranceIcon:SetShow(false)
    channelSelect._maintenanceIcon:SetShow(false)
    channelSelect._expIcon:SetShow(false)
    channelSelect._PremiumIcon:SetShow(false)
    channelSelect._PKIcon:SetShow(false)
  end
  self._txt_timeIcon:ComputePos()
  self._txt_timeDesc:ComputePos()
  self:registerEventHandler()
end
local oneTimeChange = false
function ChannelSelect_Update()
  local curChannelData = getCurrentChannelServerData()
  if nil == curChannelData then
    return
  end
  local self = channelSelect
  local curWorldData = getGameWorldServerDataByWorldNo(curChannelData._worldNo)
  local channelCount = getGameChannelServerDataCount(curWorldData._worldNo)
  local restrictedServerNo = curWorldData._restrictedServerNo
  local curServerNo = curChannelData._serverNo
  local channelMoveableGlobalTime = getChannelMoveableTime(curWorldData._worldNo)
  local channelMoveableRemainTime = getChannelMoveableRemainTime(curWorldData._worldNo)
  local _worldServerCount = getGameWorldServerDataCount()
  local _serverData
  self._txt_timeDesc:SetShow(false)
  self._txt_timeIcon:SetShow(false)
  isSpeedServer = {}
  isNotSpeedServer = {}
  local index1 = 0
  local index2 = 0
  for chIndex = 0, channelCount - 1 do
    local _serverData = getGameChannelServerDataByWorldNo(curChannelData._worldNo, chIndex)
    if _serverData._isSpeedChannel then
      isSpeedServer[index1] = chIndex
      index1 = index1 + 1
    elseif false == _serverData._isInstanceChannel or true == ToClient_SelfPlayerIsGM() then
      isNotSpeedServer[index2] = chIndex
      index2 = index2 + 1
    end
  end
  for idx = 0, index2 - 1 do
    isSpeedServer[index1 + idx] = isNotSpeedServer[idx]
  end
  local channelSizeX = 0
  local temporaryWrapper = getTemporaryInformationWrapper()
  channelCount = index1 + index2
  for chIndex = 0, channelCount - 1 do
    _serverData = getGameChannelServerDataByWorldNo(curChannelData._worldNo, isSpeedServer[chIndex])
    if nil ~= _serverData then
      self.channelSelectUIPool[chIndex].channelMaintenanceIcon:SetShow(false)
      local busyState = _serverData._busyState
      if busyState == 0 or _serverData:isClosed() then
        tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_0")
        self.channelSelectUIPool[chIndex].channelMaintenanceIcon:SetShow(true)
      elseif busyState == 1 then
        tempStr = ""
      elseif busyState == 2 then
        tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_2")
      elseif busyState == 3 then
        tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_3")
      elseif busyState == 4 then
        tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_4")
      end
      local warTerritoryName = ToClient_GetStartSiegeTerritoryKey()
      if -2 == warTerritoryName then
        tempWarName = "\235\170\168\235\145\144 \235\182\136\234\176\128"
      elseif -1 == warTerritoryName then
        tempWarName = "\235\170\168\235\145\144 \234\176\128\235\138\165"
      elseif 0 == warTerritoryName then
        tempWarName = "\235\176\156\235\160\136\235\133\184\236\138\164"
      elseif 1 == warTerritoryName then
        tempWarName = "\236\132\184\235\160\140\235\148\148\236\149\132"
      elseif 2 == warTerritoryName then
        tempWarName = "\236\185\188\237\142\152\236\152\168"
      elseif 3 == warTerritoryName then
        tempWarName = "\235\169\148\235\148\148\236\149\132"
      elseif 4 == warTerritoryName then
        tempWarName = "\235\176\156\235\160\140\236\139\156\236\149\132"
      else
        _PA_ASSERT(false, "\237\153\149\236\157\184\235\144\152\236\167\128 \236\149\138\236\157\128 \236\160\132\236\159\129 \234\176\128\235\138\165/\235\182\136\234\176\128\235\138\165 \236\167\128\236\151\173\234\176\146\236\157\180 \235\147\164\236\150\180\236\153\148\235\148\176! \237\153\149\236\157\184\237\149\152\234\177\176\235\130\152 \236\131\136\235\161\156\236\154\180 \236\160\132\236\159\129\236\167\128\236\151\173\236\157\180 \236\182\148\234\176\128\235\144\172\235\139\164\235\169\180 \236\182\148\234\176\128\237\149\180\236\163\188\236\150\180\236\149\188\237\149\156\235\139\164!!!!")
      end
      local tempChannel = getGameChannelServerDataByWorldNo(curChannelData._worldNo, isSpeedServer[chIndex])
      local isBeingWar = tempChannel._isSiegeBeing
      local isVillage = tempChannel._isVillageSiege
      self.channelSelectUIPool[chIndex].channelWaricon:SetShow(isBeingWar)
      self.channelSelectUIPool[chIndex].channelExpIcon:SetShow(_serverData._isSpeedChannel)
      self.channelSelectUIPool[chIndex].channelPremiumIcon:SetShow(_serverData._isPcroomChannel)
      self.channelSelectUIPool[chIndex].channelPKIcon:SetShow(_serverData._isDontPvPTendencyDecrease)
      if _serverData._isSteamChannel then
        if true == isSteamClient() then
          self.channelSelectUIPool[chIndex].channelBg:SetIgnore(false)
        else
          self.channelSelectUIPool[chIndex].channelBg:SetIgnore(true)
        end
      elseif _serverData._isPremiumChannel then
        if false == temporaryWrapper:isPremiumChannelPermission() then
          self.channelSelectUIPool[chIndex].channelBg:addInputEvent("Mouse_LUp", "")
          self.channelSelectUIPool[chIndex].channelBg:SetIgnore(true)
        end
      elseif _serverData._isSpeedChannel then
        if 0 ~= temporaryWrapper:getMyAdmissionToSpeedServer() then
          if false == _ContentsGroup_isConsolePadControl then
            self.channelSelectUIPool[chIndex].channelBg:addInputEvent("Mouse_On", "GameChannelMove_NewbieServerJoinDateToolTip( true, " .. chIndex .. " )")
            self.channelSelectUIPool[chIndex].channelBg:addInputEvent("Mouse_Out", "GameChannelMove_NewbieServerJoinDateToolTip( false, " .. chIndex .. ")")
          end
        elseif ToClient_SelfPlayerIsGM() then
          self.channelSelectUIPool[chIndex].channelBg:SetIgnore(false)
        else
          self.channelSelectUIPool[chIndex].channelBg:SetIgnore(true)
        end
      end
      if _serverData._isBalanceChannel then
        if ToClient_isAccessableBalanceChannel() then
          self.channelSelectUIPool[chIndex].channelBg:SetIgnore(false)
        else
          self.channelSelectUIPool[chIndex].channelBg:addInputEvent("Mouse_LUp", "")
          self.channelSelectUIPool[chIndex].channelBg:SetIgnore(true)
        end
      end
      if _serverData._isPcroomChannel and false == ToClient_isAccessablePcRoomChannel() then
        self.channelSelectUIPool[chIndex].channelBg:addInputEvent("Mouse_LUp", "")
        self.channelSelectUIPool[chIndex].channelBg:SetIgnore(true)
      end
      local isAdmission = true
      local isSiegeBeing = deadMessage_isSiegeBeingMyChannel()
      local isInSiegeBattle = deadMessage_isInSiegeBattle()
      if true == isSiegeBeing and false == isInSiegeBattle then
        isAdmission = true
      elseif restrictedServerNo ~= 0 and toInt64(0, 0) ~= channelMoveableGlobalTime then
        if restrictedServerNo == tempChannel._serverNo then
          isAdmission = true
        elseif channelMoveableRemainTime > toInt64(0, 0) then
          isAdmission = false
          if false == self._txt_timeIcon:GetShow() then
            self._txt_timeDesc:SetShow(true)
            self._txt_timeIcon:SetShow(true)
            local changeRealChannelTime = convertStringFromDatetime(channelMoveableRemainTime)
            self._txt_timeIcon:SetText(changeRealChannelTime)
            self._txt_timeIcon:SetSpanSize(self._txt_timeIcon:GetTextSizeX() + 10, self._txt_timeIcon:GetSpanSize().y)
          end
        else
          isAdmission = true
        end
      end
      self.channelSelectUIPool[chIndex].channelnoEnterIcon:SetShow(not isAdmission)
      local channelName = getChannelName(tempChannel._worldNo, tempChannel._serverNo)
      if nil == channelName then
        channelName = ""
      end
      self.channelSelectUIPool[chIndex].channelBg:addInputEvent("Mouse_LUp", "HandleClicked_ChannelSelect( " .. chIndex .. " )")
      self.channelSelectUIPool[chIndex].channelCurrentBg:SetShow(false)
      if curChannelData._worldNo == tempChannel._worldNo and curChannelData._serverNo == tempChannel._serverNo then
        self.channelSelectUIPool[chIndex].channelCurrentBg:SetShow(true)
        self.channelSelectUIPool[chIndex].channelBg:addInputEvent("Mouse_LUp", "")
        if isGameServiceTypeDev() then
        end
      else
      end
      self.channelSelectUIPool[chIndex].channelSelectedBg:SetShow(false)
      if tempChannel._isMain then
      else
      end
      if isGameServiceTypeDev() then
        self.channelSelectUIPool[chIndex].channelName:SetText(channelName .. "(" .. tempWarName .. ")")
      else
        self.channelSelectUIPool[chIndex].channelName:SetText(channelName)
      end
      self.channelSelectUIPool[chIndex].channelStatus:SetText(tempStr)
      local basePosX = self.channelSelectUIPool[chIndex].channelName:GetPosX() + self.channelSelectUIPool[chIndex].channelName:GetTextSizeX() + 20
      if self.channelSelectUIPool[chIndex].channelWaricon:GetShow() then
        self.channelSelectUIPool[chIndex].channelWaricon:SetPosX(basePosX)
        basePosX = basePosX + self.channelSelectUIPool[chIndex].channelWaricon:GetSizeX() + 5
      end
      if self.channelSelectUIPool[chIndex].channelnoEnterIcon:GetShow() then
        self.channelSelectUIPool[chIndex].channelnoEnterIcon:SetPosX(basePosX)
        basePosX = basePosX + self.channelSelectUIPool[chIndex].channelnoEnterIcon:GetSizeX() + 5
      end
      if self.channelSelectUIPool[chIndex].channelMaintenanceIcon:GetShow() then
        self.channelSelectUIPool[chIndex].channelMaintenanceIcon:SetPosX(basePosX)
        basePosX = basePosX + self.channelSelectUIPool[chIndex].channelMaintenanceIcon:GetSizeX() + 5
      end
      if self.channelSelectUIPool[chIndex].channelExpIcon:GetShow() then
        self.channelSelectUIPool[chIndex].channelExpIcon:SetPosX(basePosX)
        basePosX = basePosX + self.channelSelectUIPool[chIndex].channelExpIcon:GetSizeX() + 5
      end
      if self.channelSelectUIPool[chIndex].channelPremiumIcon:GetShow() then
        self.channelSelectUIPool[chIndex].channelPremiumIcon:SetPosX(basePosX)
        basePosX = basePosX + self.channelSelectUIPool[chIndex].channelPremiumIcon:GetSizeX() + 5
      end
      if self.channelSelectUIPool[chIndex].channelPKIcon:GetShow() then
        self.channelSelectUIPool[chIndex].channelPKIcon:SetPosX(basePosX)
        basePosX = basePosX + self.channelSelectUIPool[chIndex].channelPKIcon:GetSizeX() + 5
      end
      local channelBgSizeX = self.channelSelectUIPool[chIndex].channelStatus:GetTextSizeX() + basePosX + 50
      channelSizeX = math.max(channelSizeX, channelBgSizeX)
      if false == _ContentsGroup_isConsolePadControl then
        self.channelSelectUIPool[chIndex].channelWaricon:addInputEvent("Mouse_On", "ChannelSelect_IconToolTip(" .. 0 .. "," .. chIndex .. ")")
        self.channelSelectUIPool[chIndex].channelWaricon:addInputEvent("Mouse_Out", "ChannelSelect_IconToolTip()")
        self.channelSelectUIPool[chIndex].channelnoEnterIcon:addInputEvent("Mouse_On", "ChannelSelect_IconToolTip(" .. 1 .. "," .. chIndex .. ")")
        self.channelSelectUIPool[chIndex].channelnoEnterIcon:addInputEvent("Mouse_Out", "ChannelSelect_IconToolTip()")
        self.channelSelectUIPool[chIndex].channelMaintenanceIcon:addInputEvent("Mouse_On", "ChannelSelect_IconToolTip(" .. 2 .. "," .. chIndex .. ")")
        self.channelSelectUIPool[chIndex].channelMaintenanceIcon:addInputEvent("Mouse_Out", "ChannelSelect_IconToolTip()")
        self.channelSelectUIPool[chIndex].channelExpIcon:addInputEvent("Mouse_On", "ChannelSelect_IconToolTip(" .. 3 .. "," .. chIndex .. ")")
        self.channelSelectUIPool[chIndex].channelExpIcon:addInputEvent("Mouse_Out", "ChannelSelect_IconToolTip()")
        self.channelSelectUIPool[chIndex].channelPremiumIcon:addInputEvent("Mouse_On", "ChannelSelect_IconToolTip(" .. 4 .. "," .. chIndex .. ")")
        self.channelSelectUIPool[chIndex].channelPremiumIcon:addInputEvent("Mouse_Out", "ChannelSelect_IconToolTip()")
        self.channelSelectUIPool[chIndex].channelPKIcon:addInputEvent("Mouse_On", "ChannelSelect_IconToolTip(" .. 5 .. "," .. chIndex .. ")")
        self.channelSelectUIPool[chIndex].channelPKIcon:addInputEvent("Mouse_Out", "ChannelSelect_IconToolTip()")
      end
    end
  end
  local channelSizeX = math.max(channelSizeX, 290)
  for chIndex = 0, channelCount - 1 do
    self.channelSelectUIPool[chIndex].channelBg:SetSize(channelSizeX, self.channelSelectUIPool[chIndex].channelBg:GetSizeY())
    self.channelSelectUIPool[chIndex].channelCurrentBg:SetSize(channelSizeX, self.channelSelectUIPool[chIndex].channelCurrentBg:GetSizeY())
    self.channelSelectUIPool[chIndex].channelSelectedBg:SetSize(channelSizeX, self.channelSelectUIPool[chIndex].channelSelectedBg:GetSizeY())
    self.channelSelectUIPool[chIndex].channelStatus:ComputePos()
  end
  for index = 0, bgIndex do
    self.groupBg[index]:SetSize(channelSizeX + 10, self.groupBg[bgIndex]:GetSizeY())
    if index > 0 then
      self.groupBg[index]:SetPosX(self.groupBg[index - 1]:GetPosX() + self.groupBg[index - 1]:GetSizeX() + 10)
    end
  end
  Panel_ChannelSelect:SetSize(self.groupBg[bgIndex]:GetPosX() + self.groupBg[bgIndex]:GetSizeX() + 20, Panel_ChannelSelect:GetSizeY())
  self._title:SetSize(Panel_ChannelSelect:GetSizeX() - 10, self._title:GetSizeY())
  self._subframe:SetSize(self._title:GetSizeX(), Panel_ChannelSelect:GetSizeY() - 105)
  self._close_btn:ComputePos()
  self._question_btn:ComputePos()
  self._question_btn:SetShow(false)
  if not oneTimeChange then
    FGlobal_SeasonTexture_ChannelSelectPanelSizeCahnge(Panel_ChannelSelect:GetSizeX())
    oneTimeChange = true
  end
  Panel_ChannelSelect:ComputePos()
  self._txt_timeDesc:ComputePos()
  self._txt_timeIcon:SetSpanSize(self._txt_timeIcon:GetTextSizeX() + 30, self._txt_timeIcon:GetSpanSize().y)
  local exceedingY = self._mainDesc:GetParentPosY() + self._mainDesc:GetSizeY() - getScreenSizeY()
  if exceedingY > 0 then
    self._mainDesc:SetPosY(self._mainDesc:GetPosY() - exceedingY - 15)
  end
end
local tooltipCheck = false
function ChannelSelect_IconToolTip(iconType, index)
  if nil == iconType then
    TooltipSimple_Hide()
    tooltipCheck = false
    return
  end
  tooltipCheck = true
  local control, name
  if 0 == iconType then
    control = channelSelect.channelSelectUIPool[index].channelWaricon
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHANNELSELECTE_WARICON")
  elseif 1 == iconType then
    control = channelSelect.channelSelectUIPool[index].channelnoEnterIcon
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHANNELSELECTE_NOENTERANCEICON")
  elseif 2 == iconType then
    control = channelSelect.channelSelectUIPool[index].channelMaintenanceIcon
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHANNELSELECTE_MAINTENANCEICON")
  elseif 3 == iconType then
    control = channelSelect.channelSelectUIPool[index].channelExpIcon
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHANNELSELECTE_EXPEVENTICON")
  elseif 4 == iconType then
    control = channelSelect.channelSelectUIPool[index].channelPremiumIcon
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_SEVERSELECT_PCROOMSERVER")
  elseif 5 == iconType then
    control = channelSelect.channelSelectUIPool[index].channelPKIcon
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_SEVERSELECT_PK")
  end
  TooltipSimple_Show(control, name)
end
function GameChannelMove_NewbieServerJoinDateToolTip(isShow, chIndex)
  local temporaryWrapper = getTemporaryInformationWrapper()
  local newbieTime = temporaryWrapper:getSpeedServerExpiration()
  local isAdmission = temporaryWrapper:getMyAdmissionToSpeedServer()
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITSERVERSELECT_NEWBIE_TOOLTIP_TITLE")
  desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GAMEEXITSERVERSELECT_NEWBIE_TOOLTIP_DESC", "newbieTime", getTimeYearMonthDayHourMinSecByTTime64(newbieTime))
  control = channelSelect.channelSelectUIPool[chIndex].channelBg
  if true == isShow then
    if 0 ~= isAdmission then
      TooltipSimple_Show(control, name, desc)
    elseif not tooltipCheck then
      TooltipSimple_Hide()
    end
  elseif not tooltipCheck then
    TooltipSimple_Hide()
  end
end
function HandleClicked_ChannelSelect(selectChannel)
  audioPostEvent_SystemUi(0, 0)
  if isChannelMoveOnlySafe() then
    local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
    if not regionInfo:get():isSafeZone() and false == ToClient_SelfPlayerIsGM() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITSERVERSELECT_SAFEREGION"))
      return
    end
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoPlayerIsDoingTutorial"))
    return
  end
  local curChannelData = getCurrentChannelServerData()
  local curWorldData = getGameWorldServerDataByWorldNo(curChannelData._worldNo)
  local channelCount = getGameChannelServerDataCount(curWorldData._worldNo)
  _selectChannel = isSpeedServer[selectChannel]
  local tempChannel = getGameChannelServerDataByWorldNo(curChannelData._worldNo, _selectChannel)
  local channelName = getChannelName(tempChannel._worldNo, tempChannel._serverNo)
  local changeChannelTime = getChannelMoveableRemainTime(curChannelData._worldNo)
  local changeRealChannelTime = convertStringFromDatetime(changeChannelTime)
  local isSiegeBeing = deadMessage_isSiegeBeingMyChannel()
  local isInSiegeBattle = deadMessage_isInSiegeBattle()
  if nil ~= tempChannel then
    local busyState = tempChannel._busyState
    local isSpecialCharacter = getTemporaryInformationWrapper():isSpecialCharacter()
    if busyState == 0 then
      local messageMemo = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING_DONTJOIN")
      Proc_ShowMessage_Ack(messageMemo)
      return
    elseif true == getSelfPlayer():get():isBattleGroundDefine() and true == tempChannel._isSiegeChannel or true == tempChannel._isSiegeChannel and isSpecialCharacter then
      local messageMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_BATTLEGROURND")
      Proc_ShowMessage_Ack(messageMemo)
      return
    end
  end
  if ToClient_SelfPlayerCheckAction("READ_BOOK") then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITSERVERSELECT_READBOOK_WARNNING")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if true == isSiegeBeing and false == isInSiegeBattle then
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_MSG", "channelName", tostring(channelName))
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"),
      content = messageBoxMemo,
      functionYes = moveChannelMsg,
      functionNo = ChannelSelect_Update,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  elseif changeChannelTime > toInt64(0, 0) then
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANGECHANNEL_PENALTY", "changeRealChannelTime", changeRealChannelTime)
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"),
      content = messageBoxMemo,
      functionYes = ChannelSelect_Update,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_MSG", "channelName", tostring(channelName))
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"),
      content = messageBoxMemo,
      functionYes = moveChannelMsg,
      functionNo = ChannelSelect_Update,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
  channelSelect.channelSelectUIPool[selectChannel].channelSelectedBg:SetShow(true)
end
function moveChannelMsg()
  if false == _ContentsGroup_RenewUI_ExitGame then
    FGlobal_gameExit_saveCurrentData()
  else
    PaGlobalFunc_GameExit_SaveCurrentData()
  end
  gameExit_MoveChannel(_selectChannel)
  if nil ~= PaGlobal_FadeOutOpen then
    PaGlobal_FadeOutOpen()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELWAIT_MSG")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"),
    content = messageBoxMemo,
    functionYes = nil,
    functionClose = nil,
    exitButton = true,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function EventUpdateServerInformation_Exit()
  local isShow = Panel_ChannelSelect:IsShow()
  if false == isShow then
    return
  end
  local curChannelData = getCurrentChannelServerData()
  if nil == curChannelData then
    return
  end
  local curWorldData = getGameWorldServerDataByWorldNo(curChannelData._worldNo)
  local channelCount = getGameChannelServerDataCount(curWorldData._worldNo)
  local restrictedServerNo = curWorldData._restrictedServerNo
  local curServerNo = curChannelData._serverNo
  local channelMoveableGlobalTime = getChannelMoveableTime()
  local channelMoveableRemainTime = converStringFromLeftDateTime(channelMoveableGlobalTime)
  for chIndex = 0, channelCount - 1 do
    local tempChannel = getGameChannelServerDataByWorldNo(curChannelData._worldNo, chIndex)
    if nil == tempChannel then
      return
    end
    local isAdmission = true
    if restrictedServerNo ~= 0 and toInt64(0, 0) ~= channelMoveableGlobalTime then
      if restrictedServerNo == tempChannel._serverNo then
        isAdmission = true
      elseif channelMoveableRemainTime > 0 then
        isAdmission = true
      else
        isAdmission = false
      end
    end
    local channelName = getChannelName(tempChannel._worldNo, tempChannel._serverNo)
    if nil == channelName then
      channelName = ""
    end
    if curChannelData._worldNo == tempChannel._worldNo and curChannelData._serverNo == tempChannel._serverNo then
      channelName = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELNAME_CURRENT") .. channelName
    end
    if tempChannel._isMain then
    else
    end
    if not isAdmission then
      channelName = channelName .. PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELNAME_LIMIT")
    else
    end
    channelSelect.channelSelectUIPool[chIndex].channelName:SetText(channelName)
    channelSelect.channelSelectUIPool[chIndex].channelBg:addInputEvent("Mouse_LUp", "HandleClicked_ChannelSelect( " .. chIndex .. " )")
  end
end
function FGlobal_ChannelSelect_Show()
  if true == ToClient_IsInstanceFieldPlayerbyContentsType(__eInstanceContentsType_SavageDefence) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantDoingAlterOfBlood"))
    return
  end
  if isDeadInWatchingMode() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHANNELCHANGEOPENALERT_INDEAD"))
    return
  end
  local rv = ToClient_CheckToMoveChannel()
  if 0 ~= rv then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoRestrictedToMoveChannelOnBossSpawnPeriod"))
    return
  end
  Panel_ChannelSelect:SetShow(true, true)
  ChannelSelect_Update()
  Panel_ChannelSelect:ComputePos()
end
function FGlobal_ChannelSelect_Hide()
  Panel_ChannelSelect:SetShow(false, true)
end
function ChannelSelect_onScreenResize()
  local self = channelSelect
  self._BlockBG:SetSize(getScreenSizeX() + 200, getScreenSizeY() + 200)
  self._BlockBG:SetHorizonCenter()
  self._BlockBG:SetVerticalMiddle()
  Panel_ChannelSelect:ComputePos()
end
function channelSelect:registerEventHandler()
  self._close_btn:addInputEvent("Mouse_LUp", "FGlobal_ChannelSelect_Hide()")
  self._CheckDescIcon:addInputEvent("Mouse_LUp", "Input_ChannelSelect_ToggleDesc()")
  Panel_ChannelSelect:RegisterUpdateFunc("PaGlobalFunc_ChannelSelect_UpdatePerFrame")
  registerEvent("onScreenResize", "ChannelSelect_onScreenResize")
end
local elapsedTime = 0
function PaGlobalFunc_ChannelSelect_UpdatePerFrame(deltaTime)
  local self = channelSelect
  if true == self._txt_timeIcon:GetShow() then
    elapsedTime = elapsedTime + deltaTime
    if elapsedTime > 1 then
      elapsedTime = 0
      local curChannelData = getCurrentChannelServerData()
      local curWorldData = getGameWorldServerDataByWorldNo(curChannelData._worldNo)
      local channelMoveableRemainTime = getChannelMoveableRemainTime(curWorldData._worldNo)
      local changeRealChannelTime = convertStringFromDatetime(channelMoveableRemainTime)
      if "" ~= changeRealChannelTime then
        self._txt_timeIcon:SetText(changeRealChannelTime)
      else
        self._txt_timeIcon:SetShow(false)
        self._txt_timeDesc:SetShow(false)
      end
    end
  end
end
function Input_ChannelSelect_ToggleDesc()
  local self = channelSelect
  if true == self._mainDesc:GetShow() then
    self._mainDesc:SetShow(false)
  else
    self._mainDesc:SetShow(true)
  end
end
registerEvent("FromClient_luaLoadComplete", "ChannelSelect_Init")

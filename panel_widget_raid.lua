Panel_Widget_Raid:SetShow(false)
local raidParty = {
  _ui = {
    _static_PartyBG = UI.getChildControl(Panel_Widget_Raid, "Static_PartyBG"),
    _btn_Mandate = UI.getChildControl(Panel_Widget_Raid, "Button_Mandate"),
    _btn_Exile = UI.getChildControl(Panel_Widget_Raid, "Button_Exile"),
    _btn_Exit = UI.getChildControl(Panel_Widget_Raid, "Button_Out")
  },
  _partyMemberData = {},
  _uiPartyMemberList = {},
  _partyMemberCount = 0,
  _slotMouseIndex = 0,
  _isSlotMouseOn = false,
  _isMaster = false,
  _selectIndex = -1,
  _maxPartyMemberCount = 20,
  _isInitialized = false
}
function PaGlobal_RaidParty_GetShow()
  return Panel_Widget_Raid:GetShow()
end
function raidParty:Initialize()
  self._ui._btn_Mandate:SetShow(false)
  self._ui._btn_Exile:SetShow(false)
  self._ui._btn_Exit:SetShow(false)
  self._ui._static_PartyBG:SetShow(true)
  for index = 1, self._maxPartyMemberCount do
    local partyMember = {}
    partyMember._base = UI.cloneControl(self._ui._static_PartyBG, Panel_Widget_Raid, "Static_PartyMember_" .. index)
    partyMember._name = UI.getChildControl(partyMember._base, "StaticText_CharacterInfo")
    partyMember._hpBG = UI.getChildControl(partyMember._base, "Static_HpBG")
    partyMember._hp = UI.getChildControl(partyMember._base, "Progress2_Hp")
    partyMember._actionBtn = UI.getChildControl(partyMember._base, "Button_Order")
    partyMember._deadConditionBG = UI.getChildControl(partyMember._base, "Static_DeadConditionBG")
    partyMember._name:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    if index < 11 then
      partyMember._base:SetPosY((index - 1) * (self._ui._static_PartyBG:GetSizeY() + 10))
    else
      partyMember._base:SetPosX(self._ui._static_PartyBG:GetPosX() + self._ui._static_PartyBG:GetSizeX() + 25)
      partyMember._base:SetPosY((index - 11) * (self._ui._static_PartyBG:GetSizeY() + 10))
    end
    partyMember._base:SetShow(false)
    partyMember._actionBtn:SetShow(false)
    partyMember._base:addInputEvent("Mouse_On", "PaGlobal_RaidParty_ButtonAction(true," .. index .. ")")
    partyMember._base:addInputEvent("Mouse_Out", "PaGlobal_RaidParty_ButtonAction(false," .. index .. ")")
    partyMember._base:addInputEvent("Mouse_LUp", "PaGlobal_RaidParty_ClickButtonAction(" .. index .. ")")
    self._uiPartyMemberList[index] = partyMember
  end
  self._ui._btn_Mandate:addInputEvent("Mouse_LUp", "PaGlobal_RaidParty_ChangeLeader()")
  self._ui._btn_Exile:addInputEvent("Mouse_LUp", "PaGlobal_RaidParty_BanishMember()")
  self._ui._btn_Exit:addInputEvent("Mouse_LUp", "PaGlobal_RaidParty_ExitParty()")
  self._isInitialized = true
end
function PaGlobal_RaidParty_Open()
  raidParty:open()
end
function PaGlobal_RaidParty_Close()
  raidParty:Close()
end
function raidParty:open()
  Panel_Widget_Raid:SetShow(true)
end
function raidParty:Close()
  Panel_Widget_Raid:SetShow(false)
end
function PaGlobal_RaidParty_Update()
  raidParty:Update()
end
function raidParty:Update()
  if false == self._isInitialized then
    return
  end
  self._partyMemberCount = RequestParty_getPartyMemberCount()
  if 0 == self._partyMemberCount then
    raidParty:Close()
  elseif self._partyMemberCount < 11 then
    self._ui._static_PartyBG:SetShow(false)
  end
  self._partyMemberData = {}
  self._partyMemberData = PaGlobalFunc_PartyWidget_setMemeberData(self._partyMemberCount)
  if nil == self._partyMemberData[1] then
    return
  end
  self._isMaster = false
  for index = 1, self._maxPartyMemberCount do
    self._uiPartyMemberList[index]._base:SetShow(false)
    if index <= self._partyMemberCount then
      self:SetInfo(index)
      self._uiPartyMemberList[index]._base:SetShow(true)
      local colorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
      if colorBlindMode >= 1 then
        self._uiPartyMemberList[index]._hp:ChangeTextureInfoName("Renewal/Progress/Console_Progressbar_02.dds")
        local xx1, yy1, xx2, yy2 = setTextureUV_Func(self._uiPartyMemberList[index]._hp, 314, 498, 447, 509)
        self._uiPartyMemberList[index]._hp:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
        self._uiPartyMemberList[index]._hp:setRenderTexture(self._uiPartyMemberList[index]._hp:getBaseTexture())
      else
        self._uiPartyMemberList[index]._hp:ChangeTextureInfoName("Renewal/Progress/console_progressbar_03.dds")
        local xx1, yy1, xx2, yy2 = setTextureUV_Func(self._uiPartyMemberList[index]._hp, 329, 415, 462, 426)
        self._uiPartyMemberList[index]._hp:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
        self._uiPartyMemberList[index]._hp:setRenderTexture(self._uiPartyMemberList[index]._hp:getBaseTexture())
      end
    end
  end
end
function raidParty:SetInfo(index)
  if true == self._partyMemberData[index]._isSelf and true == self._partyMemberData[index]._isMaster then
    self._isMaster = true
  end
  self._uiPartyMemberList[index]._name:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. self._partyMemberData[index]._level .. " " .. self._partyMemberData[index]._name)
  self._uiPartyMemberList[index]._hp:SetProgressRate(self._partyMemberData[index]._currentHp / self._partyMemberData[index]._maxHp)
  if self._uiPartyMemberList[index]._name:IsLimitText() then
    self._uiPartyMemberList[index]._name:SetIgnore(false)
    self._uiPartyMemberList[index]._name:addInputEvent("Mouse_On", "PaGlobal_RaidParty_LimitTextTooptip(true, " .. index .. ")")
    self._uiPartyMemberList[index]._name:addInputEvent("Mouse_Out", "PaGlobal_RaidParty_LimitTextTooptip(false, " .. index .. ")")
  end
  if self._partyMemberData[index]._isMaster then
    self._uiPartyMemberList[index]._name:SetFontColor(Defines.Color.C_FFA3EF00)
  else
    self._uiPartyMemberList[index]._name:SetFontColor(Defines.Color.C_FFFFFFFF)
  end
  local isDead = self._partyMemberData[index]._currentHp <= 0
  self._uiPartyMemberList[index]._hpBG:SetShow(not isDead)
  self._uiPartyMemberList[index]._deadConditionBG:SetShow(isDead)
  self._uiPartyMemberList[index]._base:SetShow(true)
  self._uiPartyMemberList[index]._name:SetShow(true)
  self._uiPartyMemberList[index]._hp:SetShow(true)
end
function PaGlobal_RaidParty_LimitTextTooptip(isShow, index)
  raidParty:LimitTextTooptip(isShow, index)
end
function raidParty:LimitTextTooptip(isShow, index)
  if isShow == false then
    TooltipSimple_Hide()
    return
  end
  TooltipSimple_Show(self._uiPartyMemberList[index]._name, self._uiPartyMemberList[index]._name:GetText())
end
function PaGlobal_RaidParty_ButtonAction(isShow, index)
  raidParty:ButtonAction(isShow, index)
end
function raidParty:ButtonAction(isShow, index)
  if self._uiPartyMemberList[index]._actionBtn:GetShow() and index == self._selectIndex then
    return
  end
  if isShow and (true == self._isMaster or true == self._partyMemberData[index]._isSelf) then
    local memberCount = RequestParty_getPartyMemberCount()
    for count = 1, memberCount do
      if count == index then
        self._uiPartyMemberList[count]._actionBtn:SetShow(true)
      else
        self._uiPartyMemberList[count]._actionBtn:SetShow(false)
        self._ui._btn_Mandate:SetShow(false)
        self._ui._btn_Exile:SetShow(false)
        self._ui._btn_Exit:SetShow(false)
      end
    end
  else
    self._uiPartyMemberList[index]._actionBtn:SetShow(false)
  end
end
function PaGlobal_RaidParty_ClickButtonAction(index)
  raidParty:ClickButtonAction(index)
end
function raidParty:ClickButtonAction(index)
  if self._ui._btn_Mandate:GetShow() or self._ui._btn_Exile:GetShow() or self._ui._btn_Exit:GetShow() then
    self._ui._btn_Mandate:SetShow(false)
    self._ui._btn_Exile:SetShow(false)
    self._ui._btn_Exit:SetShow(false)
  end
  if self._selectIndex == self._partyMemberData[index]._index then
    self._ui._btn_Mandate:SetShow(false)
    self._ui._btn_Exile:SetShow(false)
    self._ui._btn_Exit:SetShow(false)
    self._selectIndex = -1
    return
  end
  self._ui._btn_Mandate:SetPosX(self._uiPartyMemberList[index]._base:GetPosX() + self._uiPartyMemberList[index]._base:GetSizeX() + 5)
  self._ui._btn_Exile:SetPosX(self._uiPartyMemberList[index]._base:GetPosX() + self._uiPartyMemberList[index]._base:GetSizeX() + 5)
  self._ui._btn_Exit:SetPosX(self._uiPartyMemberList[index]._base:GetPosX() + self._uiPartyMemberList[index]._base:GetSizeX() + 5)
  self._ui._btn_Mandate:SetPosY(self._uiPartyMemberList[index]._base:GetPosY())
  self._ui._btn_Exile:SetPosY(self._uiPartyMemberList[index]._base:GetPosY() + 30)
  self._ui._btn_Exit:SetPosY(self._uiPartyMemberList[index]._base:GetPosY() + 15)
  if false == self._partyMemberData[index]._isSelf and self._isMaster then
    self._ui._btn_Mandate:SetShow(true)
    self._ui._btn_Exile:SetShow(true)
  elseif self._partyMemberData[index]._isSelf then
    self._ui._btn_Exit:SetShow(true)
  else
    self._ui._btn_Mandate:SetShow(false)
    self._ui._btn_Exile:SetShow(false)
    self._ui._btn_Exit:SetShow(false)
  end
  Panel_Widget_Raid:SetChildIndex(self._ui._btn_Mandate, 9999)
  Panel_Widget_Raid:SetChildIndex(self._ui._btn_Exile, 9998)
  Panel_Widget_Raid:SetChildIndex(self._ui._btn_Exit, 9997)
  self._selectIndex = self._partyMemberData[index]._index
end
function PaGlobal_RaidParty_ChangeLeader()
  raidParty:ChangeLeader()
end
function raidParty:ChangeLeader()
  local index = self._selectIndex
  RequestParty_changeLeader(index)
  self._ui._btn_Mandate:SetShow(false)
  self._ui._btn_Exile:SetShow(false)
  raidParty:Update()
end
function PaGlobal_RaidParty_BanishMember()
  raidParty:BanishMember()
end
function raidParty:BanishMember()
  local index = self._selectIndex
  local withdrawMemberData = RequestParty_getPartyMemberAt(index)
  local withdrawMemberActorKey = withdrawMemberData:getActorKey()
  local withdrawMemberPlayerActor = getPlayerActor(withdrawMemberActorKey)
  local partyType = ToClient_GetPartyType()
  local function messageBox_party_BanishMember()
    RequestParty_withdrawMember(index)
    self._ui._btn_Mandate:SetShow(false)
    self._ui._btn_Exile:SetShow(false)
    raidParty:Update()
  end
  local contentString = ""
  local titleForceOut = ""
  if 0 == partyType then
    contentString = withdrawMemberData:name() .. PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT_QUESTION")
    titleForceOut = PAGetString(Defines.StringSheet_GAME, "PANEL_PARTY_FORCEOUT")
  else
    contentString = withdrawMemberData:name() .. PAGetString(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_FORCEOUT_QUESTION")
    titleForceOut = PAGetString(Defines.StringSheet_GAME, "PANEL_LARGEPARTY_FORCEOUT")
  end
  local messageboxData = {
    title = titleForceOut,
    content = contentString,
    functionYes = messageBox_party_BanishMember,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobal_RaidParty_ExitParty()
  raidParty:ExitParty()
end
function raidParty:ExitParty()
  local index = self._selectIndex
  local isPlayingPvPMatch = getSelfPlayer():isDefinedPvPMatch()
  if true == isPlayingPvPMatch then
    RequestParty_withdrawMember(index)
    return
  end
  local function partyOut()
    RequestParty_withdrawMember(index)
    raidParty:Close()
  end
  local partyType = ToClient_GetPartyType()
  local messageBoxMemo = ""
  if 0 == partyType then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_PARTY_DISTRIBUTION_GETOUTPARTY")
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_LARGEPARTY_DISTRIBUTION_GETOUTPARTY")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = partyOut,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
  raidParty:Update()
end
function LargeParty_Resize()
  raidParty:Resize()
end
function raidParty:Resize()
  if 0 == RequestParty_getPartyMemberCount() then
    Panel_Widget_Raid:SetShow(false)
  end
  if Panel_Widget_Raid:GetRelativePosX() == -1 or Panel_Widget_Raid:GetRelativePosY() == -1 then
    local initPosX = 10
    local initPosY = 200
    changePositionBySever(Panel_Widget_Raid, CppEnums.PAGameUIType.PAGameUIPanel_Party, false, true, false)
    FGlobal_InitPanelRelativePos(Panel_Widget_Raid, initPosX, initPosY)
  elseif Panel_Widget_Raid:GetRelativePosX() == 0 or Panel_Widget_Raid:GetRelativePosY() == 0 then
    Panel_Widget_Raid:SetPosX(10)
    Panel_Widget_Raid:SetPosY(200)
  else
    Panel_Widget_Raid:SetPosX(getScreenSizeX() * Panel_Widget_Raid:GetRelativePosX() - Panel_Widget_Raid:GetSizeX() / 2)
    Panel_Widget_Raid:SetPosY(getScreenSizeY() * Panel_Widget_Raid:GetRelativePosY() - Panel_Widget_Raid:GetSizeY() / 2)
  end
  FGlobal_PanelRepostionbyScreenOut(Panel_Widget_Raid)
end
function RaidPartyOption_Hide()
  raidParty._ui._btn_Exile:SetShow(false)
  raidParty._ui._btn_Mandate:SetShow(false)
  raidParty._ui._btn_Exit:SetShow(false)
end
function raidParty:registEventHandler()
  registerEvent("FromClient_luaLoadComplete", "FromClient_RaidPartyWidget_luaLoadComplete")
  registerEvent("onScreenResize", "LargeParty_Resize()")
  registerEvent("FromClient_GroundMouseClick", "RaidPartyOption_Hide")
end
function FromClient_RaidPartyWidget_luaLoadComplete()
  raidParty:Initialize()
end
raidParty:registEventHandler()

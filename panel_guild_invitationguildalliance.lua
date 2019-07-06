local PaGlobal_Guild_InvitationGuildAlliance = {
  _ui = {
    button_Confirm = nil,
    button_Refuse = nil,
    content = nil,
    contentTitle = nil,
    from = nil,
    allianceInfo_BG = nil,
    guildMark = nil,
    frame = nil,
    frame2 = nil
  },
  _listConfig = {
    startX = 0,
    startY = 5,
    gapY = 25,
    sizeY = 100
  }
}
function OpenGuildAllianceInvitation()
  PaGlobal_GuildInvitationAlliance_CheckLoadUI()
  PaGlobal_Guild_InvitationGuildAlliance:update()
end
function PaGlobal_Guild_InvitationGuildAlliance:initialize()
  if nil == Panel_GuildAlliance_Invitation then
    return
  end
  self._ui.button_Confirm = UI.getChildControl(Panel_GuildAlliance_Invitation, "Button_Confirm")
  self._ui.button_Refuse = UI.getChildControl(Panel_GuildAlliance_Invitation, "Button_Refuse")
  self._ui.content = UI.getChildControl(Panel_GuildAlliance_Invitation, "StaticText_AgreementContent")
  self._ui.contentTitle = UI.getChildControl(Panel_GuildAlliance_Invitation, "StaticText_AgreementContentTitle")
  self._ui.from = UI.getChildControl(Panel_GuildAlliance_Invitation, "StaticText_From")
  self._ui.allianceInfo_BG = UI.getChildControl(Panel_GuildAlliance_Invitation, "Static_AllianceInfo_BG")
  self._ui.guildMark = UI.getChildControl(Panel_GuildAlliance_Invitation, "Static_GuildMark")
  self._ui.frame = UI.getChildControl(Panel_GuildAlliance_Invitation, "Frame_1")
  self._ui.frame2 = UI.getChildControl(Panel_GuildAlliance_Invitation, "Frame_2")
  self._ui.guildNameTemplete = UI.getChildControl(self._ui.allianceInfo_BG, "StaticText_GuildNameTemplete")
  self._ui.guildLimitMemberTemplete = UI.getChildControl(self._ui.allianceInfo_BG, "Static_GuildLimitMemberTemplete")
  self._ui.taxConstRateTemplete = UI.getChildControl(self._ui.allianceInfo_BG, "StaticText_TaxConstRateTemplete")
  self._ui.guildNameTemplete:SetShow(false)
  self._ui.guildLimitMemberTemplete:SetShow(false)
  self._ui.taxConstRateTemplete:SetShow(false)
  self._ui.frame_Content = UI.getChildControl(self._ui.frame, "Frame_1_Content")
  self._ui.frame2_Content = UI.getChildControl(self._ui.frame2, "Frame_2_Content")
  self._ui.frame_Summary = UI.getChildControl(self._ui.frame_Content, "StaticText_1")
  self._ui.frame2_List = UI.getChildControl(self._ui.frame2_Content, "Static_List")
  self._ui.leaderCheck = UI.getChildControl(self._ui.frame2_List, "RadioButton_LeaderCheck")
  self._ui.leaderCheck:SetCheck(true)
  self._ui.guildName = {}
  self._ui.guildLimitMemberCount = {}
  self._ui.guildtaxRate = {}
  self._ui.frame_Summary:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.frame_Summary:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDALLIANCE_RULES"))
  self._ui.frame_Content:SetSize(self._ui.frame_Content:GetSizeX(), self._ui.frame_Summary:GetTextSizeY())
  self._ui.frame2_Content:SetSize(self._ui.frame2_Content:GetSizeX(), self._listConfig.sizeY)
  PaGlobal_Guild_InvitationGuildAlliance:SetPosition()
  self._ui.frame:UpdateContentPos()
  if self._ui.frame_Content:GetSizeY() < self._ui.frame:GetSizeY() then
    self._ui.frame:GetVScroll():SetShow(false)
  else
    self._ui.frame:GetVScroll():SetShow(true)
  end
  for ii = 0, 9 do
    if nil == self._ui.guildName[ii] then
      self._ui.guildName[ii] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui.frame2_List, "StaticText_InvitiationGuildName" .. ii)
      CopyBaseProperty(self._ui.guildNameTemplete, self._ui.guildName[ii])
    end
    self._ui.guildName[ii]:SetPosX(self._listConfig.startX + 98)
    self._ui.guildName[ii]:SetPosY(self._listConfig.startY + self._listConfig.gapY * ii)
    self._ui.guildName[ii]:SetShow(false)
    if nil == self._ui.guildLimitMemberCount[ii] then
      self._ui.guildLimitMemberCount[ii] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui.frame2_List, "StaticText_InvitiationGuildLimitMemberCount" .. ii)
      CopyBaseProperty(self._ui.guildLimitMemberTemplete, self._ui.guildLimitMemberCount[ii])
    end
    self._ui.guildLimitMemberCount[ii]:SetPosX(self._listConfig.startX + 198)
    self._ui.guildLimitMemberCount[ii]:SetPosY(self._listConfig.startY + self._listConfig.gapY * ii)
    self._ui.guildLimitMemberCount[ii]:SetShow(false)
    if nil == self._ui.guildtaxRate[ii] then
      self._ui.guildtaxRate[ii] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui.frame2_List, "StaticText_InvitiationGuildTaxRate" .. ii)
      CopyBaseProperty(self._ui.taxConstRateTemplete, self._ui.guildtaxRate[ii])
    end
    self._ui.guildtaxRate[ii]:SetPosX(self._listConfig.startX + 283)
    self._ui.guildtaxRate[ii]:SetPosY(self._listConfig.startY + self._listConfig.gapY * ii)
    self._ui.guildtaxRate[ii]:SetShow(false)
  end
  self._ui.contentTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDALLIANCE_COTRACT_TITLE"))
  self._ui.guildMark:SetShow(false)
end
function PaGlobal_Guild_InvitationGuildAlliance:registEventHandler()
  if nil == Panel_GuildAlliance_Invitation then
    return
  end
  self._ui.button_Confirm:addInputEvent("Mouse_LUp", "guildAlliance_accept()")
  self._ui.button_Refuse:addInputEvent("Mouse_LUp", "guildAlliance_refuse()")
end
function PaGlobal_Guild_InvitationGuildAlliance:registMessageHandler()
  registerEvent("ResponseGuildAlliance_invite", "FromClient_ResponseGuildAlliance_invite")
end
function PaGlobal_Guild_InvitationGuildAlliance:update()
  if nil == Panel_GuildAlliance_Invitation then
    return
  end
  local _allianceName = tostring(ToClient_getJoinAllianceName())
  local _guildName = {}
  local _tax = {}
  local _limitCount = {}
  local _count = ToClient_getJoinAllianceGuildCount() - 1
  self._ui.content:SetText("[" .. _allianceName .. "]")
  for ii = 0, _count do
    _guildName[ii] = tostring(ToClient_getJoinAllianceGuildName(ii))
    _tax[ii] = ToClient_getJoinAllianceGuildPercent(ii)
    _limitCount[ii] = ToClient_getJoinAllianceGuildLimitCount(ii)
  end
  for ii = 0, _count do
    self._ui.guildName[ii]:SetText(_guildName[ii])
    self._ui.guildName[ii]:SetShow(true)
    self._ui.guildLimitMemberCount[ii]:SetText("" .. _limitCount[ii] .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_INFO_MEMBERCOUNT_TEXT"))
    self._ui.guildLimitMemberCount[ii]:SetShow(true)
    self._ui.guildtaxRate[ii]:SetText("" .. _tax[ii] .. "%")
    self._ui.guildtaxRate[ii]:SetShow(true)
  end
  self._ui.from:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_LEADER_NAME") .. " " .. _guildName[0])
  local _list_SizeY = self._listConfig.gapY * _count - 6
  self:SetPosition()
  self._ui.frame2:UpdateContentPos()
  self._ui.frame2:GetVScroll():ControlButtonUp()
  self._ui.frame2_Content:SetSize(self._ui.frame2_Content:GetSizeX(), _list_SizeY)
  if _list_SizeY <= self._ui.frame2:GetSizeY() then
    self._ui.frame2:GetVScroll():SetShow(false)
  else
    self._ui.frame2:GetVScroll():SetShow(true)
  end
end
function PaGlobal_Guild_InvitationGuildAlliance:SetPosition()
  if nil == Panel_GuildAlliance_Invitation then
    return
  end
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_GuildAlliance_Invitation:GetSizeX()
  local panelSizeY = Panel_GuildAlliance_Invitation:GetSizeY()
  Panel_GuildAlliance_Invitation:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Panel_GuildAlliance_Invitation:SetPosY(scrSizeY / 2 - panelSizeY / 2)
end
function FGlobal_InvitationGuildAlliance_Close()
  if false == PaGlobal_GuildInvitationAlliance_GetShow() then
    return
  end
  guildAlliance_refuse()
  PaGlobal_GuildInvitationAlliance_CheckCloseUI(false)
  ClearFocusEdit()
  CheckChattingInput()
end
function FromClient_ResponseGuildAlliance_invite(hostName)
  OpenGuildAllianceInvitation()
end
function guildAlliance_accept()
  ToClient_sendJoinGuildAlliance(true)
  PaGlobal_GuildInvitationAlliance_CheckCloseUI(false)
end
function guildAlliance_refuse()
  ToClient_sendJoinGuildAlliance(false)
  PaGlobal_GuildInvitationAlliance_CheckCloseUI(false)
end
function PaGlobal_GuildInvitationAlliance_CheckLoadUI()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_GuildAlliance_Invitation:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_GuildAlliance_Invitation.XML", "Panel_GuildAlliance_Invitation", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_GuildAlliance_Invitation = rv
    rv = nil
    PaGlobal_GuildInvitationAlliance_Init()
  end
  Panel_GuildAlliance_Invitation:SetShow(true)
end
function PaGlobal_GuildInvitationAlliance_CheckCloseUI(isAni)
  if false == PaGlobal_GuildInvitationAlliance_GetShow() then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_GuildAlliance_Invitation:SetShow(false, isAni)
  else
    reqCloseUI(Panel_GuildAlliance_Invitation)
  end
end
function PaGlobal_GuildInvitationAlliance_GetShow()
  if nil == Panel_GuildAlliance_Invitation then
    return false
  end
  return Panel_GuildAlliance_Invitation:GetShow()
end
function FromClient_GuildInvitationAlliance_Init()
  PaGlobal_GuildInvitationAlliance_Init()
  PaGlobal_Guild_InvitationGuildAlliance:registMessageHandler()
end
function PaGlobal_GuildInvitationAlliance_Init()
  PaGlobal_Guild_InvitationGuildAlliance:initialize()
  PaGlobal_Guild_InvitationGuildAlliance:registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildInvitationAlliance_Init")

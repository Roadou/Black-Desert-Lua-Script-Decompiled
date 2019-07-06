PaGlobal_Guild_AllianceInfo = {
  _mainUi = {
    allianceInviteBg = nil,
    allianceInfoBg = nil,
    frame2 = nil
  },
  _inviteListConfig = {
    createCount = 0,
    startX = 0,
    startY = 8,
    gapY = 40,
    listSizeY = 0
  },
  _inviteUi = {},
  _isLoadInviteUI = false,
  _allianceName = "",
  _allianceType = 0,
  _leaderDefaultMemeberCount = 0,
  _selectedGuildIndex = 0,
  _createdCount = 0,
  _minLimitMemberCount = 10,
  _maxLimitMemberCount = 0,
  _allianceMemberName = {},
  _guildLimitMemeberCount = {},
  _taxConstRate = {},
  _currentTotalLimitMember = 0,
  _currentTotalTaxConst = 100,
  _isInvited = false,
  _taxRate_Default = {
    [0] = 0,
    [1] = 100,
    [2] = 20,
    [3] = 15,
    [4] = 15,
    [5] = 15,
    [6] = 14,
    [7] = 12,
    [8] = 11,
    [9] = 10,
    [10] = 10
  },
  defaultFrameBG_Alliance = nil
}
function PaGlobal_Guild_AllianceInfo:OpenGuildAlliance()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  local guildAlliance = ToClient_GetMyGuildAllianceWrapper()
  local _isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local _isGuildAllianceMember = getSelfPlayer():get():isGuildAllianceMember()
  self:InviteInitialize_ReState()
  self:InviteInitialize()
  self:InfoInitialize()
  self:gulidalliance_CautionInitialize()
  if true ~= _isGuildAllianceMember then
    if true == _isGuildMaster then
      if nil == guildAlliance then
        self:Alliance_AllInputInitialize()
        self._mainUi.allianceInviteBg:SetShow(true)
        self._mainUi.allianceInfoBg:SetShow(false)
      else
        self._mainUi.allianceInviteBg:SetShow(false)
        self._mainUi.allianceInfoBg:SetShow(true)
      end
    else
      self._mainUi.allianceInfoBg:SetShow(false)
      self._mainUi.allianceInviteBg:SetShow(false)
    end
  else
    self._mainUi.allianceInviteBg:SetShow(false)
    self._mainUi.allianceInfoBg:SetShow(true)
  end
  if nil ~= self._allianceName then
    self._allianceName = ""
  end
end
function PaGlobal_Guild_AllianceInfo:InviteInitialize()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  local _guildWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil == _guildWrapper then
    return
  end
  for ii = 1, 9 do
    self._allianceMemberName[ii] = ""
    self._guildLimitMemeberCount[ii] = 10
    self._taxConstRate[ii] = 0
  end
  if nil == guildAlliance then
    self:Alliance_AllInputInitialize()
  end
  ClearFocusEdit()
  self._allianceMemberName[0] = _guildWrapper:getName()
  self._guildLimitMemeberCount[0] = 10
  self._leaderDefaultMemeberCount = self._guildLimitMemeberCount[0]
  self._taxConstRate[0] = 100
  self._inviteUi.guildList.leaderNameUi:SetFontColor(4294294074)
  self._inviteUi.guildList.leaderNameUi:SetText(self._allianceMemberName[0])
  self._inviteUi.guildList.leaderMemberCountUi:SetText(self._guildLimitMemeberCount[0] .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_INFO_MEMBERCOUNT_TEXT"))
  self._inviteUi.guildList.leaderTaxConstCountUi:SetText(self._taxConstRate[0] .. "%")
  self._inviteUi.button_DeleteGuild:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDALLIANCEINFO_DELETE_ALLIANCE"))
  self._inviteUi.button_AddAlliances:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDALLIANCEINFO_ADD_ALLIANCE"))
  self._inviteUi.guildList.guildBGTemplete:SetShow(false)
  self._inviteUi.guildList.guildNameTemplete:SetShow(false)
  self._inviteUi.guildList.guildMemberCountTemplete:SetShow(false)
  self._inviteUi.guildList.taxConstRateTemplete:SetShow(false)
  self._inviteUi.edit_AllianceNameTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDALLIANCEINFO_CREATE_ALLIANCENAME_TEXT"))
  self._inviteUi.edit_AllianceName:SetSpanSize(self._inviteUi.edit_AllianceNameTitle:GetTextSizeX() + 20, self._inviteUi.edit_AllianceName:GetSpanSize().y)
  self._inviteUi.text_Wait:SetShow(false)
  self._createdCount = 0
  self._currentTotalTaxConst = 100
  self:totalGuildLimitMemberCheck()
end
function PaGlobal_Guild_AllianceInfo:InviteInitialize_Load()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  self._mainUi.allianceInviteBg = UI.getChildControl(Panel_Guild_AllianceInfo, "Static_Frame_AllianceInviteBG")
  self._mainUi.allianceInfoBg = UI.getChildControl(Panel_Guild_AllianceInfo, "Static_Frame_AllianceInfoBG")
  self._mainUi.frame2 = UI.getChildControl(Panel_Guild_AllianceInfo, "Frame_2")
  self._inviteUi = {}
  self._inviteUi = {
    edit_AllianceNameTitle = UI.getChildControl(self._mainUi.allianceInviteBg, "StaticText_AllianceName"),
    edit_AllianceName = UI.getChildControl(self._mainUi.allianceInviteBg, "Edit_AllianceName"),
    button_AddAlliances = UI.getChildControl(self._mainUi.allianceInviteBg, "Button_AddAlliances"),
    button_DeleteGuild = UI.getChildControl(self._mainUi.allianceInviteBg, "Button_DeleteGuild"),
    guild_ListBg = UI.getChildControl(self._mainUi.allianceInviteBg, "Static_AddGuildListBG"),
    total_InfoUi = UI.getChildControl(self._mainUi.allianceInviteBg, "StaticText_Total_Info"),
    button_Invite = UI.getChildControl(self._mainUi.allianceInviteBg, "Button_Invite"),
    button_Initialize = UI.getChildControl(self._mainUi.allianceInviteBg, "Button_Initialize"),
    button_Cancel_Invite = UI.getChildControl(self._mainUi.allianceInviteBg, "Button_Cancel_Invite"),
    text_Wait = UI.getChildControl(self._mainUi.allianceInviteBg, "StaticText_Wait"),
    addGuildTitle = UI.getChildControl(self._mainUi.allianceInviteBg, "StaticText_AddGuildName"),
    frame = UI.getChildControl(self._mainUi.allianceInviteBg, "Frame_1")
  }
  self._inviteUi.button_AllianceName = UI.getChildControl(self._inviteUi.edit_AllianceName, "Button_AllianceName")
  self._inviteUi.guildList = {}
  self._inviteUi.guildList = {
    guild_TitleListBg = UI.getChildControl(self._inviteUi.guild_ListBg, "Static_Name_ListBG"),
    guildBGTemplete = UI.getChildControl(self._inviteUi.guild_ListBg, "Static_GuildBGTemplete"),
    guildNameTemplete = UI.getChildControl(self._inviteUi.guild_ListBg, "Static_GuildNameTemplete"),
    guildMemberCountTemplete = UI.getChildControl(self._inviteUi.guild_ListBg, "Static_GuildMemberTemplete"),
    taxConstRateTemplete = UI.getChildControl(self._inviteUi.guild_ListBg, "Static_TaxConstRateTemplete")
  }
  self._inviteUi.guildList.limitGuildCountUi = UI.getChildControl(self._inviteUi.guildList.guild_TitleListBg, "StaticText_GuildMemberCountName")
  self._inviteUi.guildList.limitTaxConstUi = UI.getChildControl(self._inviteUi.guildList.guild_TitleListBg, "StaticText_TaxConstName")
  self._inviteUi.inputUi = {}
  self._inviteUi.inputUi = {
    listNo = {},
    guildBGUi = {},
    guildNameUi = {},
    button_confirmGuildNameUi = {},
    guildMemeberCountUi = {},
    taxConstRateUi = {}
  }
  for ii = 1, 9 do
    self._inviteUi.inputUi.listNo[ii] = ii
    self._allianceMemberName[ii] = ""
    self._guildLimitMemeberCount[ii] = 10
    self._taxConstRate[ii] = 0
  end
  self._inviteUi.button_AllianceName:SetShow(false)
  self._inviteUi.frame1_Content = UI.getChildControl(self._inviteUi.frame, "Frame_1_Content")
  self._inviteUi.frame1_List = UI.getChildControl(self._inviteUi.frame1_Content, "Static_List")
  self._inviteUi.guildList.leaderNameUi = UI.getChildControl(self._inviteUi.frame1_List, "StaticText_LeaderName")
  self._inviteUi.guildList.leaderMemberCountUi = UI.getChildControl(self._inviteUi.frame1_List, "StaticText_LeaderMemberCount")
  self._inviteUi.guildList.leaderTaxConstCountUi = UI.getChildControl(self._inviteUi.frame1_List, "StaticText_LeaderTaxConstCount")
  self.gulidalliance_Caution = UI.getChildControl(self._mainUi.frame2:GetFrameContent(), "StaticText_GuildAlliance_Caution")
  local _guildWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil == _guildWrapper then
    return
  end
  self._inviteUi.guildList.leaderMemberCountUi:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:GuildLimitMemberCheck(0)")
  self._inviteUi.guildList.leaderTaxConstCountUi:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:taxConstCheck(0)")
  self._inviteUi.button_DeleteGuild:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:deleteGuildInput()")
  self._inviteUi.button_AddAlliances:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:OpenAllianceList()")
  self._inviteUi.button_AddAlliances:addInputEvent("Mouse_On", "PaGlobal_Guild_AllianceInfo:AllianceTooltips(true, 1)")
  self._inviteUi.button_AddAlliances:addInputEvent("Mouse_Out", "PaGlobal_Guild_AllianceInfo:AllianceTooltips(false)")
  self._inviteUi.button_DeleteGuild:addInputEvent("Mouse_On", "PaGlobal_Guild_AllianceInfo:AllianceTooltips(true, 2)")
  self._inviteUi.button_DeleteGuild:addInputEvent("Mouse_Out", "PaGlobal_Guild_AllianceInfo:AllianceTooltips(false)")
  self._inviteUi.button_Invite:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:HandleClickedButtonConfirm()")
  self._inviteUi.button_Initialize:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:OpenGuildAlliance()")
  self._inviteUi.button_Cancel_Invite:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:confirm_CancelInvite()")
  self:InviteListCreate()
  self:AllianceName_Init()
end
function PaGlobal_Guild_AllianceInfo:InviteListCreate()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  self._inviteUi.frame:GetVScroll():SetShow(false)
  local plusSizeX = 0
  for ii = 1, 9 do
    if ii % 2 == 1 then
      plusSizeX = 460
    else
      plusSizeX = 0
    end
    self._inviteUi.inputUi.guildBGUi[ii] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._inviteUi.frame1_List, "StaticText_GuildBG" .. ii)
    CopyBaseProperty(self._inviteUi.guildList.guildBGTemplete, self._inviteUi.inputUi.guildBGUi[ii])
    self._inviteUi.inputUi.guildBGUi[ii]:SetPosX(plusSizeX)
    self._inviteUi.inputUi.guildBGUi[ii]:SetPosY(self._inviteListConfig.startY + self._inviteListConfig.gapY * math.floor(ii / 2))
    self._inviteUi.inputUi.guildBGUi[ii]:SetShow(false)
    self._inviteUi.inputUi.guildNameUi[ii] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_EDIT, self._inviteUi.frame1_List, "StaticText_GuildName" .. ii)
    CopyBaseProperty(self._inviteUi.guildList.guildNameTemplete, self._inviteUi.inputUi.guildNameUi[ii])
    self._inviteUi.inputUi.guildNameUi[ii]:SetPosX(plusSizeX + 10)
    self._inviteUi.inputUi.guildNameUi[ii]:SetPosY(self._inviteListConfig.startY + self._inviteListConfig.gapY * math.floor(ii / 2) + 5)
    self._inviteUi.inputUi.guildNameUi[ii]:SetMaxInput(getGameServiceTypeGuildNameLength())
    self._inviteUi.inputUi.guildNameUi[ii]:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:HandleClicked_AllianceGulildNameEditSetFocus(" .. self._inviteUi.inputUi.listNo[ii] .. ")")
    self._inviteUi.inputUi.guildNameUi[ii]:RegistReturnKeyEvent("PaGlobal_Guild_AllianceInfo:AllianceMemberName_Regist(" .. self._inviteUi.inputUi.listNo[ii] .. ")")
    self._inviteUi.inputUi.guildNameUi[ii]:SetEditText("")
    self._inviteUi.inputUi.guildNameUi[ii]:SetText(ii)
    self._inviteUi.inputUi.guildNameUi[ii]:SetShow(false)
    self._inviteUi.inputUi.guildMemeberCountUi[ii] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._inviteUi.frame1_List, "StaticText_GuildMemberCount" .. ii)
    CopyBaseProperty(self._inviteUi.guildList.guildMemberCountTemplete, self._inviteUi.inputUi.guildMemeberCountUi[ii])
    self._inviteUi.inputUi.guildMemeberCountUi[ii]:SetPosX(250 + plusSizeX)
    self._inviteUi.inputUi.guildMemeberCountUi[ii]:SetPosY(self._inviteListConfig.startY + self._inviteListConfig.gapY * math.floor(ii / 2) + 5)
    self._inviteUi.inputUi.guildMemeberCountUi[ii]:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:GuildLimitMemberCheck(" .. self._inviteUi.inputUi.listNo[ii] .. ")")
    self._inviteUi.inputUi.guildMemeberCountUi[ii]:SetShow(false)
    self._inviteUi.inputUi.taxConstRateUi[ii] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._inviteUi.frame1_List, "StaticText_TaxConstRate" .. ii)
    CopyBaseProperty(self._inviteUi.guildList.taxConstRateTemplete, self._inviteUi.inputUi.taxConstRateUi[ii])
    self._inviteUi.inputUi.taxConstRateUi[ii]:SetPosX(350 + plusSizeX)
    self._inviteUi.inputUi.taxConstRateUi[ii]:SetPosY(self._inviteListConfig.startY + self._inviteListConfig.gapY * math.floor(ii / 2) + 5)
    self._inviteUi.inputUi.taxConstRateUi[ii]:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:taxConstCheck(" .. self._inviteUi.inputUi.listNo[ii] .. ")")
    self._inviteUi.inputUi.taxConstRateUi[ii]:SetShow(false)
  end
  self._inviteUi.inputUi.taxConstRateUi[0] = self._inviteUi.guildList.leaderTaxConstCountUi
  self._inviteUi.frame:GetVScroll():SetShow(false)
  self._isLoadInviteUI = true
end
function PaGlobal_Guild_AllianceInfo:InviteInitialize_ReState()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  if false == self._isLoadInviteUI then
    return
  end
  self._inviteUi.frame:GetVScroll():SetShow(false)
  for ii = 1, 9 do
    self._inviteUi.inputUi.guildBGUi[ii]:SetShow(false)
    self._inviteUi.inputUi.guildNameUi[ii]:SetShow(false)
    self._inviteUi.inputUi.guildMemeberCountUi[ii]:SetShow(false)
    self._inviteUi.inputUi.taxConstRateUi[ii]:SetShow(false)
  end
  self._inviteUi.edit_AllianceName:SetEditText("")
  self._inviteUi.edit_AllianceName:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDALLIANCEINFO_ALLIANCENAMETIP_TEXT"))
end
function PaGlobal_Guild_AllianceInfo:gulidalliance_CautionInitialize()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  self._mainUi.frame2:GetVScroll():SetShow(false)
  self._mainUi.frame2:GetVScroll():SetVerticalMode(false)
  self.gulidalliance_Caution:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._mainUi.frame2:GetVScroll():ControlButtonUp()
  self._mainUi.frame2:UpdateContentPos()
  self._mainUi.frame2:GetFrameContent():SetSize(self._mainUi.frame2:GetFrameContent():GetSizeX(), 170)
  self.gulidalliance_Caution:SetText(self.gulidalliance_Caution:GetText())
  self.gulidalliance_Caution:SetSize(self.gulidalliance_Caution:GetSizeX(), self.gulidalliance_Caution:GetTextSizeY())
  local _contentTextSizeY = self.gulidalliance_Caution:GetTextSizeY()
  local _limitSize = self._mainUi.frame2:GetSizeY()
  local contentSizeY = self._mainUi.frame2:GetFrameContent():GetSizeY()
  self.gulidalliance_Caution:SetTextVerticalCenter()
  if _contentTextSizeY > contentSizeY then
    self._mainUi.frame2:GetVScroll():SetShow(true)
    self._mainUi.frame2:GetVScroll():SetVerticalMode(true)
    self._mainUi.frame2:GetFrameContent():SetSize(self._mainUi.frame2:GetFrameContent():GetSizeX(), self.gulidalliance_Caution:GetTextSizeY() + 20)
    self.gulidalliance_Caution:SetTextVerticalTop()
  end
  self.gulidalliance_Caution:ComputePos()
end
function PaGlobal_Guild_AllianceInfo:AllianceName_Init()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  self._inviteUi.edit_AllianceName:SetEditText("")
  self._inviteUi.edit_AllianceName:SetMaxInput(getGameServiceTypeGuildNameLength())
  self._inviteUi.edit_AllianceName:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:HandleClicked_AllianceNameEditSetFocus()")
  self._inviteUi.edit_AllianceName:RegistReturnKeyEvent("PaGlobal_Guild_AllianceInfo:AllianceName_Regist()")
  self._inviteUi.edit_AllianceName:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDALLIANCEINFO_ALLIANCENAMETIP_TEXT"))
end
function PaGlobal_Guild_AllianceInfo:AllianceTooltips(isShow, tipType)
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  local name, desc, control
  if 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_ADDALLIANCETIP_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_ADDALLIANCETIP_INFO")
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDALLIANCEINFO_DELETE_ALLIANCE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_DELETEALLIANCETIP_INFO")
  end
  control = self._inviteUi.button_AllianceName
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_Guild_AllianceInfo:HandleClicked_AllianceNameEditSetFocus()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  Panel_NumberPad_Close()
  if "" == self._allianceName then
    self._inviteUi.edit_AllianceName:SetEditText("")
  else
    SetFocusEdit(self._inviteUi.edit_AllianceName)
  end
end
function PaGlobal_Guild_AllianceInfo:AllianceName_Regist()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  if "" == self._inviteUi.edit_AllianceName:GetText() then
    PaGlobal_Guild_AllianceInfo:AllianceName_Init()
  end
  ClearFocusEdit()
end
function PaGlobal_Guild_AllianceInfo:ConfirmAllianceName()
  ToClient_CreateGuildAlliance(allianceName)
end
function PaGlobal_Guild_AllianceInfo:addAllianceTooltips(isShow, tipType)
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_ADDALLIANCETIP_TITLE")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_ADDALLIANCETIP_INFO")
  control = self._inviteUi.button_AllianceName
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_Guild_AllianceInfo:OpenAllianceList()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  if 9 > self._createdCount and self._createdCount >= 0 then
    Panel_NumberPad_Close()
    if 100 <= self._currentTotalLimitMember then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_WARNING_MAX_GUILDMEMBER_COUNT"))
    else
      self._createdCount = self._createdCount + 1
      self:taxConstDefaultCheck(self._createdCount)
      self:currentTaxConstCheck()
      self._inviteUi.inputUi.guildNameUi[self._createdCount]:SetTextHorizonCenter()
      self._inviteUi.inputUi.guildNameUi[self._createdCount]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_INPUTMEMBERNAME_TEXT"))
      self._inviteUi.inputUi.guildMemeberCountUi[self._createdCount]:SetText(self._guildLimitMemeberCount[self._createdCount] .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_INFO_MEMBERCOUNT_TEXT"))
      self._inviteUi.inputUi.guildBGUi[self._createdCount]:SetShow(true)
      self._inviteUi.inputUi.guildNameUi[self._createdCount]:SetShow(true)
      self._inviteUi.inputUi.guildMemeberCountUi[self._createdCount]:SetShow(true)
      self._inviteUi.inputUi.taxConstRateUi[self._createdCount]:SetShow(true)
      self._inviteUi.button_DeleteGuild:SetIgnore(false)
      self._inviteUi.button_DeleteGuild:SetMonoTone(false)
      self._inviteUi.button_DeleteGuild:SetShow(true)
      self._inviteUi.button_Invite:SetShow(true)
      self._inviteUi.button_Initialize:SetShow(true)
      self._inviteUi.button_Cancel_Invite:SetShow(true)
    end
    self:InviteListSizeCheck()
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_TOTALMEMEBEROVER_TEXT"))
  end
  self:totalGuildLimitMemberCheck()
end
function PaGlobal_Guild_AllianceInfo:InviteListSizeCheck()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  self._inviteListConfig.listSizeY = (self._createdCount + 1) * self._inviteListConfig.gapY + 5
  if self._inviteListConfig.listSizeY > 1000 then
    self._inviteUi.frame1_Content:SetSize(self._inviteUi.frame1_Content:GetSizeX(), self._inviteListConfig.listSizeY)
    self._inviteUi.frame:UpdateContentPos()
    self._inviteUi.frame:GetVScroll():SetShow(true)
  else
    self._inviteUi.frame:GetVScroll():SetShow(false)
  end
end
function PaGlobal_Guild_AllianceInfo:AllianceMemberName_Regist(index)
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  self._allianceMemberName[index] = tostring(self._inviteUi.inputUi.guildNameUi[index]:GetEditText())
  ClearFocusEdit()
end
function PaGlobal_Guild_AllianceInfo:HandleClicked_AllianceGulildNameEditSetFocus(index)
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  if "" ~= self._allianceMemberName[index] then
    self._inviteUi.inputUi.guildNameUi[index]:SetText(self._allianceMemberName[index])
    self._inviteUi.inputUi.guildNameUi[index]:SetEditText(self._allianceMemberName[index])
  else
    self._inviteUi.inputUi.guildNameUi[index]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_INPUTMEMBERNAME_TEXT"))
    self._inviteUi.inputUi.guildNameUi[index]:SetEditText("")
  end
  self._inviteUi.inputUi.guildNameUi[index]:SetTextHorizonCenter()
  self._inviteUi.inputUi.guildNameUi[index]:SetEditText(self._inviteUi.inputUi.guildNameUi[index]:GetEditText(), true)
end
function PaGlobal_Guild_AllianceInfo:totalGuildLimitMemberCheck()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  self._currentTotalLimitMember = 0
  self._maxLimitMemberCount = toInt64(0, 0)
  for ii = 0, self._createdCount do
    self._currentTotalLimitMember = self._currentTotalLimitMember + self._guildLimitMemeberCount[ii]
  end
  self._maxLimitMemberCount = toInt64(0, 100 - self._currentTotalLimitMember + self._guildLimitMemeberCount[self._selectedGuildIndex])
  self._inviteUi.guildList.limitGuildCountUi:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDALLIANCEINFO_GUILD_LIMIT_MEMBER_COUNT_TITLE_TEXT"))
  self:totalInfo()
end
function PaGlobal_Guild_AllianceInfo:GuildLimitMemberCheck(index)
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  self._selectedGuildIndex = index
  Panel_NumberPad_Close()
  self:totalGuildLimitMemberCheck()
  Panel_NumberPad_Show(true, self._maxLimitMemberCount, 0, guildAlliaceMemberChanged)
end
function guildAlliaceMemberChanged(count)
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  local self = PaGlobal_Guild_AllianceInfo
  local _count = Int64toInt32(count)
  if _count < self._minLimitMemberCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_WARNING_MIN_LIMIT_GUILD_COUNT"))
    if 0 == self._selectedGuildIndex then
      self._guildLimitMemeberCount[0] = self._minLimitMemberCount
      self._inviteUi.guildList.leaderMemberCountUi:SetText(self._guildLimitMemeberCount[0] .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_INFO_MEMBERCOUNT_TEXT"))
    else
      self._guildLimitMemeberCount[self._selectedGuildIndex] = self._minLimitMemberCount
      self._inviteUi.inputUi.guildMemeberCountUi[self._selectedGuildIndex]:SetText(self._guildLimitMemeberCount[self._selectedGuildIndex] .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_INFO_MEMBERCOUNT_TEXT"))
    end
  elseif 0 == self._selectedGuildIndex then
    if _count < self._leaderDefaultMemeberCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_WARNING_GUILDMEMBER_COUNT"))
      self._guildLimitMemeberCount[0] = self._leaderDefaultMemeberCount
      self._inviteUi.guildList.leaderMemberCountUi:SetText(self._guildLimitMemeberCount[0] .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_INFO_MEMBERCOUNT_TEXT"))
    else
      self._guildLimitMemeberCount[0] = _count
      self._inviteUi.guildList.leaderMemberCountUi:SetText(self._guildLimitMemeberCount[0] .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_INFO_MEMBERCOUNT_TEXT"))
    end
  else
    self._guildLimitMemeberCount[self._selectedGuildIndex] = _count
    self._inviteUi.inputUi.guildMemeberCountUi[self._selectedGuildIndex]:SetText(_count .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_INFO_MEMBERCOUNT_TEXT"))
  end
  PaGlobal_Guild_AllianceInfo:totalGuildLimitMemberCheck()
end
function PaGlobal_Guild_AllianceInfo:taxConstDefaultCheck(index)
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  if 100 < self._currentTotalTaxConst + self._taxRate_Default[index + 1] then
    for ii = 0, index do
      self._taxConstRate[ii] = self._taxRate_Default[index + 1]
    end
  else
    self._taxConstRate[index] = self._taxRate_Default[index + 1]
  end
end
function PaGlobal_Guild_AllianceInfo:currentTaxConstCheck()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  self._currentTotalTaxConst = 0
  for ii = 0, self._createdCount do
    self._currentTotalTaxConst = self._currentTotalTaxConst + self._taxConstRate[ii]
    self._inviteUi.inputUi.taxConstRateUi[ii]:SetText(self._taxConstRate[ii] .. "%")
    self._inviteUi.guildList.limitTaxConstUi:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDALLIANCEINFO_GUILD_TAX_CONST_TITLE_TEXT"))
    self:totalInfo()
  end
end
function PaGlobal_Guild_AllianceInfo:taxConstCheck(index)
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  self._selectedGuildIndex = index
  Panel_NumberPad_Close()
  PaGlobal_Guild_AllianceInfo:currentTaxConstCheck()
  local _taxconstMin = self._taxRate_Default[index + 1]
  local _maxTaxConst = toInt64(0, 100 - self._currentTotalTaxConst + self._taxConstRate[self._selectedGuildIndex])
  Panel_NumberPad_Show(true, _maxTaxConst, 0, taxConstChanged)
end
function taxConstChanged(count)
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  local self = PaGlobal_Guild_AllianceInfo
  Panel_NumberPad_Close()
  local _count = Int64toInt32(count)
  if _count < self._taxRate_Default[self._createdCount + 1] then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_WARNING_TAXCONST_MIN"))
    _count = self._taxRate_Default[self._createdCount + 1]
  end
  self._taxConstRate[self._selectedGuildIndex] = _count
  self._inviteUi.inputUi.taxConstRateUi[self._selectedGuildIndex]:SetText(self._taxConstRate[self._selectedGuildIndex] .. "%")
  PaGlobal_Guild_AllianceInfo:currentTaxConstCheck()
  PaGlobal_Guild_AllianceInfo:totalInfo()
end
function PaGlobal_Guild_AllianceInfo:deleteGuildInput()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  local uiEdit = GetFocusEdit()
  if nil == uiEdit then
    if false == self._isInvited then
      self:inputInitialize(self._createdCount)
      self._createdCount = self._createdCount - 1
      if self._createdCount <= 0 then
        self._createdCount = 0
        self._inviteUi.button_DeleteGuild:SetIgnore(true)
        self._inviteUi.button_DeleteGuild:SetMonoTone(true)
      end
      self:taxConstDefaultCheck(self._createdCount)
      self:totalGuildLimitMemberCheck()
      self:currentTaxConstCheck()
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_WARNING_DELETEBUTTON"))
    end
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_WARNING_DELETEBUTTON_INPUT"))
  end
end
function PaGlobal_Guild_AllianceInfo:inputInitialize(index)
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  if 0 < self._createdCount then
    self._inviteUi.inputUi.guildBGUi[index]:SetShow(false)
    self._inviteUi.inputUi.guildNameUi[index]:SetShow(false)
    self._inviteUi.inputUi.guildMemeberCountUi[index]:SetShow(false)
    self._inviteUi.inputUi.taxConstRateUi[index]:SetShow(false)
    self._inviteUi.inputUi.guildNameUi[index]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_INPUTMEMBERNAME_TEXT"))
    self._allianceMemberName[index] = ""
    self._guildLimitMemeberCount[index] = self._minLimitMemberCount
    self._taxConstRate[index - 1] = self._taxRate_Default[index]
    for ii = 1, index do
      self._inviteUi.inputUi.taxConstRateUi[index]:SetText(self._taxConstRate[index - 1] .. "%")
    end
  end
end
function PaGlobal_Guild_AllianceInfo:totalInfo()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  local _info = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDALLIANCEINFO_GUILD_LIMIT_MEMBER_COUNT_TITLE_TEXT") .. " (" .. self._currentTotalLimitMember .. "/100)  " .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDALLIANCEINFO_GUILD_TAX_CONST_TITLE_TEXT") .. " (" .. self._currentTotalTaxConst .. "/100)"
  self._inviteUi.total_InfoUi:SetText(_info)
end
function PaGlobal_Guild_AllianceInfo:HandleClickedButtonConfirm()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  self._allianceName = tostring(self._inviteUi.edit_AllianceName:GetEditText())
  for ii = 1, self._createdCount do
    self._allianceMemberName[ii] = tostring(self._inviteUi.inputUi.guildNameUi[ii]:GetEditText())
  end
  local _isDone = 0
  for ii = 0, self._createdCount do
    if "" ~= self._allianceMemberName[ii] then
      _isDone = _isDone + 1
    end
  end
  if "" == self._allianceName then
    self:notInputMessage(0)
  elseif _isDone ~= self._createdCount + 1 then
    self:notInputMessage(1)
  elseif 100 ~= self._currentTotalTaxConst then
    self:notInputMessage(2)
  else
    _isDone = 0
    self:confirm_AllianceCreate()
  end
end
function PaGlobal_Guild_AllianceInfo:confirm_AllianceCreate()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  ToClient_RequestClearAllianceJoinQueue()
  for ii = 0, self._createdCount do
    ToClient_RequestAddAllianceJoinQueue(self._allianceMemberName[ii], self._taxConstRate[ii], self._guildLimitMemeberCount[ii])
  end
  ToClient_CreateGuildAlliance(self._allianceName, self._allianceType)
end
function PaGlobal_Guild_AllianceInfo:confirm_CancelInvite()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  ToClient_CancelCreateGuildAlliance()
  self._isInvited = false
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_CANCEL_CREATE_ALLIANCE"))
  self._inviteUi.text_Wait:SetShow(false)
  self._inviteUi.total_InfoUi:SetShow(true)
end
function PaGlobal_Guild_AllianceInfo:notInputMessage(index)
  local _title = ""
  local _info = ""
  if 0 == index then
    _info = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_WARNING_NONE_ALLIANCENAME")
  elseif 1 == index then
    _info = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_WARNING_NONE_GUILDNAME")
  elseif 2 == index then
    _info = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_WARNING_NONE_TAX_CONST")
  end
  local messageBoxData = {
    title = _title,
    content = _info,
    functionApply = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1m
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_Guild_AllianceInfo:Alliance_AllInputInitialize()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  if false == self._isInvited then
    for ii = 1, self._createdCount do
      self:inputInitialize(ii)
    end
    self._createdCount = 0
    self._allianceName = ""
    self._inviteUi.edit_AllianceName:SetEditText("")
    self._inviteUi.button_DeleteGuild:SetIgnore(true)
    self._inviteUi.button_DeleteGuild:SetMonoTone(true)
    self._taxConstRate[0] = self._taxRate_Default[1]
    self._inviteUi.edit_AllianceName:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDALLIANCEINFO_ALLIANCENAMETIP_TEXT"))
    if self._inviteUi.edit_AllianceName:GetTextSizeX() > self._inviteUi.edit_AllianceName:GetSizeX() then
      self._inviteUi.edit_AllianceName:SetSize(self._inviteUi.edit_AllianceName:GetTextSizeX() + 20, self._inviteUi.edit_AllianceName:GetSizeY())
    end
  end
end
function FGlobal_GuildAllianceDone(index, guildName)
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  self._isInvited = true
  local self = PaGlobal_Guild_AllianceInfo
  if __eCreateGuildAlliance_Create == index then
    self._inviteUi.text_Wait:SetShow(true)
    self._inviteUi.total_InfoUi:SetShow(false)
  elseif __eCreateGuildAlliance_Complete == index then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_ACCEPT_JOIN", "guildName", guildName))
    self:OpenGuildAlliance()
  elseif __eCreateGuildAlliance_AcceptJoin == index then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_ACCEPT_JOIN", "guildName", guildName))
  elseif __eCreateGuildAlliance_Reject == index then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_REJECT_JOIN", "guildName", guildName))
    self:OpenGuildAlliance()
  else
    self:OpenGuildAlliance()
  end
end
function PaGlobal_Guild_AllianceInfo:InfoInitialize()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  local guildAlliance = ToClient_GetMyGuildAllianceWrapper()
  if nil == guildAlliance then
    self._inviteUi.button_DeleteGuild:SetIgnore(true)
    self._inviteUi.button_DeleteGuild:SetMonoTone(true)
    return
  end
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return
  end
  local selfPlayer = selfPlayerWrapper:get()
  if nil == selfPlayer then
    return
  end
  local _myGuildNo = getSelfPlayer():getGuildNo_s64()
  local _allianceNo = guildAlliance:guildAllianceNo_s64()
  local _chairName = guildAlliance:getGuildAllianceChairName()
  local _allianceNameInfo = guildAlliance:getRepresentativeName()
  local _allianceMemberCount = guildAlliance:getMemberCount()
  local _guildNo = {}
  local _guildName = {}
  local _guildLimitMemberCount = {}
  local _currentGuildMemberCount = {}
  local _guildTaxConst = {}
  local _totalGuildMemberCount = 0
  local _leaderNo = 0
  for ii = 0, _allianceMemberCount - 1 do
    local allianceMember = guildAlliance:getMemberGuild(ii)
    _guildName[ii] = allianceMember:getName()
    _guildNo[ii] = allianceMember:getGuildNo_s64()
    _guildLimitMemberCount[ii] = guildAlliance:getLimitMemberCountOfMemberGuild(_guildNo[ii])
    _guildTaxConst[ii] = guildAlliance:getTaxRateOfMemberGuild(_guildNo[ii])
    _currentGuildMemberCount[ii] = allianceMember:getMemberCount()
    _totalGuildMemberCount = _totalGuildMemberCount + _currentGuildMemberCount[ii]
    if tostring(_guildName[ii]) == tostring(_chairName) then
      _leaderNo = ii
    end
  end
  self._infoUi.gulidNameTemplete:SetShow(false)
  self._infoUi.guildMemberCountTemplete:SetShow(false)
  self._infoUi.guildtaxConstTemplete:SetShow(false)
  self._infoUi.allinaceNameUi:SetText(tostring(_allianceNameInfo))
  self._infoUi.allMemeberCount:SetText(_totalGuildMemberCount .. " / 100")
  self._infoUi.allMemeberCount:SetPosX(self._infoUi.allinaceNameUi:GetPosX() + self._infoUi.allinaceNameUi:GetTextSizeX() + 10)
  self._infoUi.allMemeberCount:SetPosY(self._infoUi.allinaceNameUi:GetPosY())
  for ii = 0, _allianceMemberCount - 1 do
    self._infoUi.guildName[ii]:SetText(_guildName[ii])
    self._infoUi.guildName[ii]:SetShow(true)
    self._infoUi.guildMemberCount[ii]:SetText(_currentGuildMemberCount[ii] .. "/" .. _guildLimitMemberCount[ii])
    self._infoUi.guildMemberCount[ii]:SetShow(true)
    self._infoUi.guildtaxConst[ii]:SetText(_guildTaxConst[ii] / CppDefine.e1Percent .. "%")
    self._infoUi.guildtaxConst[ii]:SetShow(true)
  end
  self._infoUi.button_Notice:SetShow(false)
  self._infoUi.button_NoticeInitialize:SetShow(false)
  self._infoUi.guildAllianceMaster[_leaderNo]:SetShow(true)
  self._infoUi.allianceMark:SetIgnore(true)
  self._infoUi.btnGuildAllianceMark:SetShow(false)
  local _notice = guildAlliance:getNotice()
  self._infoUi.editAllianceNoticeUi:SetText(_notice)
  if selfPlayer:isGuildAllianceChair() then
    self._infoUi.allianceMark:SetIgnore(false)
    self._infoUi.btnGuildAllianceMark:SetShow(true)
    self._infoUi.btnGuildAllianceMark:addInputEvent("Mouse_LUp", "FGlobal_Guild_AllianceInfo_ChangeMark()")
    self._infoUi.btnGuildAllianceMark:addInputEvent("Mouse_On", "FGlobal_Guild_AllianceInfo_MarkToolTip(0)")
    self._infoUi.btnGuildAllianceMark:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
    self._infoUi.editAllianceNoticeUi:SetIgnore(false)
    self._infoUi.editAllianceNoticeUi:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:HandleClicked_AllianceNoticeEditSetFocus()")
    self._infoUi.editAllianceNoticeUi:SetMaxInput(300)
    self._infoUi.editAllianceNoticeUi:RegistReturnKeyEvent("PaGlobal_Guild_AllianceInfo:AllianceNotice_Regist()")
    self._infoUi.editAllianceNoticeUi:SetEditText(_notice)
    self._infoUi.button_Notice:SetShow(true)
    self._infoUi.button_NoticeInitialize:SetShow(true)
    self._infoUi.noticeBg:SetIgnore(true)
  else
    self._infoUi.editAllianceNoticeUi:SetIgnore(true)
    self._infoUi.allyIconBG:SetIgnore(true)
  end
  if selfPlayer:isGuildMaster() then
    self._infoUi.btnGuildAllianceSecession:SetShow(true)
    self._infoUi.btnGuildAllianceSecession:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:DisbandAlliance()")
    self._infoUi.btnGuildAllianceSecession:addInputEvent("Mouse_On", "FGlobal_Guild_AllianceInfo_MarkToolTip(1)")
    self._infoUi.btnGuildAllianceSecession:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  else
    self._infoUi.btnGuildAllianceSecession:SetShow(false)
  end
  self._infoUi.editAllianceNoticeUi:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local isSet = setGuildTextureByAllianceNo(_allianceNo, self._infoUi.allianceMark)
  if false == isSet then
    self._infoUi.allianceMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._infoUi.allianceMark, 183, 1, 188, 6)
    self._infoUi.allianceMark:getBaseTexture():setUV(x1, y1, x2, y2)
    self._infoUi.allianceMark:setRenderTexture(self._infoUi.allianceMark:getBaseTexture())
  else
    self._infoUi.allianceMark:getBaseTexture():setUV(0, 0, 1, 1)
    self._infoUi.allianceMark:setRenderTexture(self._infoUi.allianceMark:getBaseTexture())
  end
end
function PaGlobal_Guild_AllianceInfo:InfoInitialize_Load()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  self._infoUi = {
    infoBg = UI.getChildControl(self._mainUi.allianceInfoBg, "Static_AllianceInfo_BG"),
    noticeBg = UI.getChildControl(self._mainUi.allianceInfoBg, "Static_AllianceNotice_BG")
  }
  self._infoUi.allyIconBG = UI.getChildControl(self._infoUi.infoBg, "Static_AllyIcon_BG")
  self._infoUi.allianceMark = UI.getChildControl(self._infoUi.infoBg, "Static_Ally_Icon")
  self._infoUi.btnGuildAllianceMark = UI.getChildControl(self._infoUi.infoBg, "Button_GuildAllianceMark")
  self._infoUi.btnGuildAllianceSecession = UI.getChildControl(self._infoUi.infoBg, "Button_GuildDispersal")
  self._infoUi.allinaceNameUi = UI.getChildControl(self._infoUi.infoBg, "StaticText_R_GuildAlliacneName")
  self._infoUi.allMemeberCount = UI.getChildControl(self._infoUi.infoBg, "StaticText_MemberCountValue")
  self._infoUi.leaderCheck = UI.getChildControl(self._infoUi.infoBg, "Static_LeaderCheck")
  self._infoUi.gulidNameTemplete = UI.getChildControl(self._infoUi.infoBg, "StaticText_GuildNameTemplete")
  self._infoUi.guildMemberCountTemplete = UI.getChildControl(self._infoUi.infoBg, "Static_GuildMemberTemplete")
  self._infoUi.guildtaxConstTemplete = UI.getChildControl(self._infoUi.infoBg, "StaticText_TaxConstRateTemplete")
  self._infoUi.guildAllianceMaster = {}
  self._infoUi.guildName = {}
  self._infoUi.guildMemberCount = {}
  self._infoUi.guildtaxConst = {}
  local _guildListConfig = {
    startX = 150,
    startY = 175,
    gapY = 25
  }
  for ii = 0, 9 do
    self._infoUi.guildAllianceMaster[ii] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._mainUi.allianceInfoBg, "StaticText_InfoGuildMasterIcon_" .. ii)
    CopyBaseProperty(self._infoUi.leaderCheck, self._infoUi.guildAllianceMaster[ii])
    self._infoUi.guildAllianceMaster[ii]:SetPosX(34)
    self._infoUi.guildAllianceMaster[ii]:SetPosY(_guildListConfig.startY + _guildListConfig.gapY * ii)
    self._infoUi.guildAllianceMaster[ii]:SetShow(false)
    self._infoUi.guildName[ii] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._mainUi.allianceInfoBg, "StaticText_InfoGuildName" .. ii)
    CopyBaseProperty(self._infoUi.gulidNameTemplete, self._infoUi.guildName[ii])
    self._infoUi.guildName[ii]:SetPosX(_guildListConfig.startX + 41)
    self._infoUi.guildName[ii]:SetPosY(_guildListConfig.startY + _guildListConfig.gapY * ii)
    self._infoUi.guildName[ii]:SetShow(false)
    self._infoUi.guildMemberCount[ii] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._mainUi.allianceInfoBg, "StaticText_InfoGuildMemberCount" .. ii)
    CopyBaseProperty(self._infoUi.guildMemberCountTemplete, self._infoUi.guildMemberCount[ii])
    self._infoUi.guildMemberCount[ii]:SetPosX(_guildListConfig.startX + 187)
    self._infoUi.guildMemberCount[ii]:SetPosY(_guildListConfig.startY + _guildListConfig.gapY * ii)
    self._infoUi.guildMemberCount[ii]:SetShow(false)
    self._infoUi.guildtaxConst[ii] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._mainUi.allianceInfoBg, "StaticText_InfoGuildTaxConst" .. ii)
    CopyBaseProperty(self._infoUi.guildtaxConstTemplete, self._infoUi.guildtaxConst[ii])
    self._infoUi.guildtaxConst[ii]:SetPosX(_guildListConfig.startX + 287)
    self._infoUi.guildtaxConst[ii]:SetPosY(_guildListConfig.startY + _guildListConfig.gapY * ii)
    self._infoUi.guildtaxConst[ii]:SetShow(false)
  end
  self._infoUi.editAllianceNoticeUi = UI.getChildControl(self._infoUi.noticeBg, "MultilineEdit_Introduce")
  self._infoUi.button_Notice = UI.getChildControl(self._infoUi.noticeBg, "Button_Notice")
  self._infoUi.button_NoticeInitialize = UI.getChildControl(self._infoUi.noticeBg, "Button_NoticeInitialize")
  self._infoUi.button_Notice:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:AllianceNotice_Regist()")
  self._infoUi.button_NoticeInitialize:addInputEvent("Mouse_LUp", "PaGlobal_Guild_AllianceInfo:AllianceNotice_Initialize()")
  self.defaultFrameBG_Alliance = UI.getChildControl(Panel_Window_Guild, "Static_Frame_AllianceBG")
  self.defaultFrameBG_Alliance:MoveChilds(self.defaultFrameBG_Alliance:GetID(), Panel_Guild_AllianceInfo)
  deletePanel(Panel_Guild_AllianceInfo:GetID())
end
function FGlobal_Guild_AllianceInfo_ChangeMark()
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_ADDMARK_MESSAGEBOX_TITLE"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_ADDMARK_MESSAGEBOX_TEXT"),
    functionYes = FGlobal_GuildAllianceInfo_ChangeMarkContinue,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PA_UI_CONTROL_TYPE.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "top")
end
function FGlobal_GuildAllianceInfo_ChangeMarkContinue()
  guildMarkUpdate(true)
end
function FGlobal_Guild_AllianceInfo_MarkToolTip(tipType)
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  local self = PaGlobal_Guild_AllianceInfo
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDALLIANCEMARK_BTN_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDALLIANCEMARK_BTN_TOOLTIP_DESC")
    control = self._infoUi.btnGuildAllianceMark
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_MESSAGE_DISBAND_TITLE")
    control = self._infoUi.btnGuildAllianceSecession
  end
  TooltipSimple_Show(control, name, desc)
end
function FGlobal_GuildAllianceInfoOnMarkChanged()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  local self = PaGlobal_Guild_AllianceInfo
  if self:isShowing() then
    self:InfoInitialize()
  end
end
function PaGlobal_Guild_AllianceInfo:isShowing()
  if nil == Panel_Guild_AllianceInfo then
    return false
  end
  return Panel_Guild_AllianceInfo:GetShow()
end
function PaGlobal_Guild_AllianceInfo:HandleClicked_AllianceNoticeEditSetFocus()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  SetFocusEdit(self._infoUi.editAllianceNoticeUi)
  self._infoUi.editAllianceNoticeUi:SetMaxEditLine(16)
  self._infoUi.editAllianceNoticeUi:SetEditText(self._infoUi.editAllianceNoticeUi:GetEditText(), true)
end
function PaGlobal_Guild_AllianceInfo:AllianceNotice_Regist()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  local _notice = self._infoUi.editAllianceNoticeUi:GetEditText()
  self._infoUi._notice = tostring(_notice)
  ToClient_SetGuildAllianceNotice(_notice)
  ClearFocusEdit()
end
function PaGlobal_Guild_AllianceInfo:AllianceNotice_Initialize()
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  self._infoUi._notice = ""
  self._infoUi.editAllianceNoticeUi:SetEditText("")
  self._infoUi.editAllianceNoticeUi:SetText(self._infoUi._notice)
  ToClient_SetGuildAllianceNotice("")
end
function PaGlobal_Guild_AllianceInfo:DisbandAlliance()
  local _title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_MESSAGE_DISBAND_TITLE")
  local _content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_MESSAGE_DISBAND_INFO")
  local messageboxData = {
    title = _title,
    content = _content,
    functionYes = confirm_DisbandAlliance,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PA_UI_CONTROL_TYPE.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function confirm_DisbandAlliance()
  local self = PaGlobal_Guild_AllianceInfo
  ToClient_RequestDestroyGuildAlliance()
end
function FGlobal_GuildAllianceDisbandDone()
  local self = PaGlobal_Guild_AllianceInfo
  local _title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_MESSAGE_DISBAND_TITLE")
  local _content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCEINFO_MESSAGE_DISBAND_DONE")
  local messageBoxData = {
    title = _title,
    content = _content,
    functionApply = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
  FGlobal_GuildAllianceDone()
end
function FGlobal_GuildAlliance_Show(isShow)
  if nil == Panel_Guild_AllianceInfo then
    return
  end
  local self = PaGlobal_Guild_AllianceInfo
  if isShow == true then
    self.defaultFrameBG_Alliance:SetShow(true)
    self:OpenGuildAlliance()
  else
    self.defaultFrameBG_Alliance:SetShow(false)
  end
end
function FGlobal_GuildAllianceOnNoticeChanged()
  local self = PaGlobal_Guild_AllianceInfo
  local guildAlliance = ToClient_GetMyGuildAllianceWrapper()
  if nil == guildAlliance then
    return
  else
    self:OpenGuildAlliance()
    self._infoUi.editAllianceNoticeUi:SetText(guildAlliance:getNotice())
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Panel_Guild_AllianceInfo")
function PaGlobal_Guild_AllianceInfo:registMessageHandler()
  registerEvent("EventChangeGuildInfo", "FGlobal_GuildAllianceInfoOnMarkChanged")
  registerEvent("FromClient_ResponseGuildNotice", "FGlobal_GuildAllianceOnNoticeChanged")
  registerEvent("FromClient_CreateGuildAlliance", "FGlobal_GuildAllianceDone")
  registerEvent("FromClient_DestroyGuildAlliance", "FGlobal_GuildAllianceDisbandDone")
end
function FromClient_luaLoadComplete_Panel_Guild_AllianceInfo()
  PaGlobal_GuildAllianceInfo_Initialize()
  PaGlobal_Guild_AllianceInfo:OpenGuildAlliance()
  PaGlobal_Guild_AllianceInfo:registMessageHandler()
end
function PaGlobal_GuildAllianceInfo_Initialize()
  PaGlobal_Guild_AllianceInfo:InviteInitialize_Load()
  PaGlobal_Guild_AllianceInfo:InfoInitialize_Load()
end

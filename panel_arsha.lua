local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
Panel_Window_Arsha:SetShow(false)
local arshaPvP = {
  btn_Close = UI.getChildControl(Panel_Window_Arsha, "Button_Close"),
  arshaManagementTitle = UI.getChildControl(Panel_Window_Arsha, "StaticText_ArshaManagementTitle"),
  img_NotAdmin = UI.getChildControl(Panel_Window_Arsha, "Static_NotAdminBG"),
  list2_ArshaWait = UI.getChildControl(Panel_Window_Arsha, "List2_ArshaWait"),
  list2_ArshaObserver = UI.getChildControl(Panel_Window_Arsha, "List2_ArshaObserver"),
  roundWing = UI.getChildControl(Panel_Window_Arsha, "Static_RoundWing"),
  freeWing = UI.getChildControl(Panel_Window_Arsha, "Static_FreeWing"),
  personalMatchWing = UI.getChildControl(Panel_Window_Arsha, "Static_PersonalWing"),
  list2_ArshaTeamA = UI.getChildControl(Panel_Window_Arsha, "List2_ArshaTeamA"),
  list2_ArshaTeamB = UI.getChildControl(Panel_Window_Arsha, "List2_ArshaTeamB"),
  btn_AllResurrection = UI.getChildControl(Panel_Window_Arsha, "Button_AllResurrection"),
  btn_InviteList = UI.getChildControl(Panel_Window_Arsha, "Button_InviteList"),
  btn_GoA = UI.getChildControl(Panel_Window_Arsha, "Button_GoA"),
  btn_GoB = UI.getChildControl(Panel_Window_Arsha, "Button_GoB"),
  btn_GameStart = UI.getChildControl(Panel_Window_Arsha, "Button_GameStart"),
  btn_GameStop = UI.getChildControl(Panel_Window_Arsha, "Button_GameStop"),
  btn_GoWait = UI.getChildControl(Panel_Window_Arsha, "Button_GoWait"),
  btn_Exit = UI.getChildControl(Panel_Window_Arsha, "Button_Exit"),
  rdo_SelectWait = UI.getChildControl(Panel_Window_Arsha, "Radiobutton_SelectWait"),
  rdo_SelectWatch = UI.getChildControl(Panel_Window_Arsha, "Radiobutton_SelectWatch"),
  txt_bottomDesc = UI.getChildControl(Panel_Window_Arsha, "StaticText_BottomDesc"),
  btn_Kick_A = UI.getChildControl(Panel_Window_Arsha, "Button_Kick_A"),
  btn_Kick_B = UI.getChildControl(Panel_Window_Arsha, "Button_Kick_B"),
  _isOpen = false,
  _targetScore = 3,
  _timeLimit = ToClient_CompetitionMatchTimeLimit(),
  _levelLimit = 58,
  _maxPartyMemberCount = 5,
  _maxWaitTime = 20
}
local checkPopUp = UI.getChildControl(Panel_Window_Arsha, "CheckButton_PopUp")
local isPopUpContentsEnable = ToClient_IsContentsGroupOpen("240")
local isPersonalModeOpen = true
checkPopUp:SetShow(false)
checkPopUp:addInputEvent("Mouse_LUp", "PaGlobal_Panel_Arsha_PopUp()")
checkPopUp:addInputEvent("Mouse_On", "PaGlobal_Panel_Arsha_ShowIconToolTip( true )")
checkPopUp:addInputEvent("Mouse_Out", "PaGlobal_Panel_Arsha_ShowIconToolTip( false )")
arshaPvP.rdo_RoundMode = UI.getChildControl(arshaPvP.arshaManagementTitle, "Radiobutton_RoundMode")
arshaPvP.rdo_FreeMode = UI.getChildControl(arshaPvP.arshaManagementTitle, "Radiobutton_FreeMode")
arshaPvP.rdo_PersonalMode = UI.getChildControl(arshaPvP.arshaManagementTitle, "Radiobutton_PersonalMode")
arshaPvP.chk_ArshaOpen = UI.getChildControl(arshaPvP.arshaManagementTitle, "Checkbox_ArshaOpen")
arshaPvP.txt_RoundCountTitle = UI.getChildControl(arshaPvP.arshaManagementTitle, "StaticText_RoundCountTitle")
arshaPvP.txt_RoundCount = UI.getChildControl(arshaPvP.arshaManagementTitle, "StaticText_RoundCount")
arshaPvP.btn_RoundCount = UI.getChildControl(arshaPvP.arshaManagementTitle, "Button_RoundCount")
arshaPvP.txt_LimitTimeTitle = UI.getChildControl(arshaPvP.arshaManagementTitle, "StaticText_LimitTimeTitle")
arshaPvP.txt_LimitMinute = UI.getChildControl(arshaPvP.arshaManagementTitle, "StaticText_LimitMinute")
arshaPvP.txt_LimitMinuteTitle = UI.getChildControl(arshaPvP.arshaManagementTitle, "StaticText_LimitMinuteTitle")
arshaPvP.txt_LimitSecond = UI.getChildControl(arshaPvP.arshaManagementTitle, "StaticText_LimitSecond")
arshaPvP.txt_LimitSecondTitle = UI.getChildControl(arshaPvP.arshaManagementTitle, "StaticText_LimitSecondTitle")
arshaPvP.btn_LimitTime = UI.getChildControl(arshaPvP.arshaManagementTitle, "Button_LimitTime")
arshaPvP.txt_LimitLevelTitle = UI.getChildControl(arshaPvP.arshaManagementTitle, "StaticText_LimitLevelTitle")
arshaPvP.txt_LimitLevel = UI.getChildControl(arshaPvP.arshaManagementTitle, "StaticText_LimitLevel")
arshaPvP.txt_LimitLevelMore = UI.getChildControl(arshaPvP.arshaManagementTitle, "StaticText_LimitLevelMore")
arshaPvP.btn_LimitLevel = UI.getChildControl(arshaPvP.arshaManagementTitle, "Button_LimitLevel")
arshaPvP.txt_PartyMemberLimitTItle = UI.getChildControl(arshaPvP.arshaManagementTitle, "StaticText_PartyMemberLimitTitle")
arshaPvP.txt_PartyMemberLimitCount = UI.getChildControl(arshaPvP.arshaManagementTitle, "StaticText_PartyMemberLimitCount")
arshaPvP.btn_PartyMemberLimit = UI.getChildControl(arshaPvP.arshaManagementTitle, "Button_PartyMemberLimit")
arshaPvP.chk_WatchMemberInvite = UI.getChildControl(arshaPvP.arshaManagementTitle, "Checkbox_WatchMemberInvite")
arshaPvP.edit_InviteMemberEdit = UI.getChildControl(arshaPvP.arshaManagementTitle, "Edit_CharacterName")
arshaPvP.btn_Invite = UI.getChildControl(arshaPvP.arshaManagementTitle, "Button_Invite")
arshaPvP.btn_NameChange = UI.getChildControl(arshaPvP.arshaManagementTitle, "Button_ChangeTeamName")
arshaPvP.roundMark = UI.getChildControl(arshaPvP.roundWing, "Static_RoundMark")
arshaPvP.txt_RoundMarkCount = UI.getChildControl(arshaPvP.roundWing, "StaticText_RoundCount")
arshaPvP.txt_RoundMarkText = UI.getChildControl(arshaPvP.roundWing, "StaticText_RoundText")
arshaPvP.txt_RoundMarkTeamA = UI.getChildControl(arshaPvP.roundWing, "StaticText_TeamA")
arshaPvP.txt_RoundMarkTeamB = UI.getChildControl(arshaPvP.roundWing, "StaticText_TeamB")
arshaPvP.freeMark = UI.getChildControl(arshaPvP.freeWing, "Static_FreeMark")
arshaPvP.txt_FreeMarkCount = UI.getChildControl(arshaPvP.freeWing, "StaticText_FreeCount")
arshaPvP.txt_FreeMarkText = UI.getChildControl(arshaPvP.freeWing, "StaticText_FreeText")
arshaPvP.personalMark = UI.getChildControl(arshaPvP.personalMatchWing, "Static_PersonalMark")
arshaPvP.txt_personalCurrentRound = UI.getChildControl(arshaPvP.personalMatchWing, "StaticText_RoundCount")
arshaPvP.txt_personalMatchText = UI.getChildControl(arshaPvP.personalMatchWing, "StaticText_PersonalMatchText")
arshaPvP.txt_personalRoundTeamA = UI.getChildControl(arshaPvP.personalMatchWing, "StaticText_TeamA")
arshaPvP.txt_personalRoundTeamB = UI.getChildControl(arshaPvP.personalMatchWing, "StaticText_TeamB")
arshaPvP.txt_modeTitle = UI.getChildControl(arshaPvP.img_NotAdmin, "StaticText_NotAdminTitle")
arshaPvP.descBG = UI.getChildControl(arshaPvP.img_NotAdmin, "StaticText_DescBG")
local sub_Kick = UI.getChildControl(Panel_Window_ArshaPvPSubMenu, "Button_Kick")
local sub_KickAll = UI.getChildControl(Panel_Window_ArshaPvPSubMenu, "Button_KickAll")
local sub_teamChange = UI.getChildControl(Panel_Window_ArshaPvPSubMenu, "Button_TeamChange")
local sub_Upgrade = UI.getChildControl(Panel_Window_ArshaPvPSubMenu, "Button_SubMaster")
local sub_btnTeamMaster = UI.getChildControl(Panel_Window_ArshaPvPSubMenu, "Button_TeamMaster")
function ArshaPvP_init()
  local self = arshaPvP
  self.list2_ArshaTeamA:changeAnimationSpeed(10)
  self.list2_ArshaTeamA:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "ArshaPvP_TeamA_Update")
  self.list2_ArshaTeamA:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self.list2_ArshaTeamB:changeAnimationSpeed(10)
  self.list2_ArshaTeamB:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "ArshaPvP_TeamB_Update")
  self.list2_ArshaTeamB:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self.list2_ArshaWait:changeAnimationSpeed(10)
  self.list2_ArshaWait:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "ArshaPvP_Wait_Update")
  self.list2_ArshaWait:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self.list2_ArshaObserver:changeAnimationSpeed(10)
  self.list2_ArshaObserver:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "ArshaPvP_Observer_Update")
  self.list2_ArshaObserver:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self.btn_Close:addInputEvent("Mouse_LUp", "FGlobal_ArshaPvP_Close()")
  UI.setLimitTextAndAddTooltip(self.btn_Kick_A)
  UI.setLimitTextAndAddTooltip(self.btn_Kick_B)
  UI.setLimitTextAndAddTooltip(self.btn_NameChange)
  UI.setLimitTextAndAddTooltip(self.btn_RoundCount)
  UI.setLimitTextAndAddTooltip(self.btn_LimitTime)
  UI.setLimitTextAndAddTooltip(self.btn_LimitLevel)
  UI.setLimitTextAndAddTooltip(self.btn_PartyMemberLimit)
  UI.setLimitTextAndAddTooltip(self.btn_Invite)
  if ToClient_IsCompetitionHost() then
    self.arshaManagementTitle:SetShow(true)
    self.img_NotAdmin:SetShow(false)
  else
    self.arshaManagementTitle:SetShow(false)
    self.img_NotAdmin:SetShow(true)
    self.btn_Kick_A:SetShow(false)
    self.btn_Kick_B:SetShow(false)
    self.btn_GoA:SetSize(370, 35)
    self.btn_GoB:SetSize(370, 35)
  end
  local matchMode = ToClient_CompetitionMatchType()
  self.rdo_RoundMode:SetEnableArea(0, 0, self.rdo_RoundMode:GetSizeX() + self.rdo_RoundMode:GetTextSizeX() + 10, self.rdo_RoundMode:GetSizeY())
  self.rdo_FreeMode:SetEnableArea(0, 0, self.rdo_FreeMode:GetSizeX() + self.rdo_FreeMode:GetTextSizeX() + 10, self.rdo_FreeMode:GetSizeY())
  self.rdo_PersonalMode:SetEnableArea(0, 0, self.rdo_PersonalMode:GetSizeX() + self.rdo_PersonalMode:GetTextSizeX() + 10, self.rdo_PersonalMode:GetSizeY())
  if CppEnums.CompetitionMatchType.eCompetitionMatchMode_Round == matchMode then
    self.txt_modeTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_TEAMMODE_TITLE"))
    self.rdo_RoundMode:SetCheck(true)
    self.rdo_FreeMode:SetCheck(false)
    self.rdo_PersonalMode:SetCheck(false)
    self.roundWing:SetShow(true)
    self.freeWing:SetShow(false)
    self.personalMatchWing:SetShow(false)
    self.txt_PartyMemberLimitTItle:SetShow(false)
    self.txt_PartyMemberLimitCount:SetShow(false)
    self.btn_PartyMemberLimit:SetShow(false)
  elseif CppEnums.CompetitionMatchType.eCompetitionMatchMode_FreeForAll == matchMode then
    self.txt_modeTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_ALIVEMODE_TITLE"))
    self.rdo_RoundMode:SetCheck(false)
    self.rdo_FreeMode:SetCheck(true)
    self.rdo_PersonalMode:SetCheck(false)
    self.roundWing:SetShow(false)
    self.freeWing:SetShow(true)
    self.personalMatchWing:SetShow(false)
    self.txt_PartyMemberLimitTItle:SetShow(true)
    self.txt_PartyMemberLimitCount:SetShow(true)
    self.btn_PartyMemberLimit:SetShow(true)
  elseif CppEnums.CompetitionMatchType.eCompetitionMatchMode_Personal == matchMode then
    self.txt_modeTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_PERSONALMODE_TITLE"))
    self.rdo_RoundMode:SetCheck(false)
    self.rdo_FreeMode:SetCheck(false)
    self.rdo_PersonalMode:SetCheck(true)
    self.roundWing:SetShow(false)
    self.freeWing:SetShow(false)
    self.personalMatchWing:SetShow(true)
    self.txt_RoundCountTitle:SetShow(false)
    self.txt_RoundCount:SetShow(false)
    self.btn_RoundCount:SetShow(false)
    self.txt_PartyMemberLimitTItle:SetShow(false)
    self.txt_PartyMemberLimitCount:SetShow(false)
    self.btn_PartyMemberLimit:SetShow(false)
  end
  self.rdo_SelectWait:SetCheck(true)
  self.rdo_SelectWatch:SetCheck(false)
  self.list2_ArshaWait:SetShow(true)
  self.list2_ArshaObserver:SetShow(false)
  self.txt_bottomDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.txt_bottomDesc:SetShow(false)
  self.btn_GoA:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_TeamChange(" .. 1 .. ")")
  self.btn_GoB:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_TeamChange(" .. 2 .. ")")
  self.btn_GoWait:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_TeamChange(" .. 0 .. ")")
  self.btn_Exit:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_Exit()")
  self.btn_GameStart:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_GameStart()")
  self.btn_GameStop:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_GameStop()")
  self.rdo_RoundMode:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_ModeChange(" .. CppEnums.CompetitionMatchType.eCompetitionMatchMode_Round .. ")")
  self.rdo_FreeMode:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_ModeChange(" .. CppEnums.CompetitionMatchType.eCompetitionMatchMode_FreeForAll .. ")")
  if true == isPersonalModeOpen then
    self.rdo_PersonalMode:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_ModeChange(" .. CppEnums.CompetitionMatchType.eCompetitionMatchMode_Personal .. ")")
  else
    self.rdo_FreeMode:SetPosX(self.rdo_FreeMode:GetPosX() + 10)
    self.rdo_PersonalMode:SetShow(false)
  end
  self.rdo_SelectWait:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_WaitAndWatch( 0 )")
  self.rdo_SelectWatch:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_WaitAndWatch( 1 )")
  self.btn_NameChange:addInputEvent("Mouse_LUp", "Team_NameChangeOpen()")
  self.edit_InviteMemberEdit:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_EditSetFocus()")
  self.btn_Invite:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_Summon()")
  self.edit_InviteMemberEdit:RegistReturnKeyEvent("HandleClicked_ArshaPvP_Summon()")
  self.btn_AllResurrection:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_AllPlayerResurrection()")
  self.btn_InviteList:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_InviteList()")
  self.txt_RoundCount:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_RoundCountSetting()")
  self.txt_LimitMinute:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_LimitMinuteSetting()")
  self.txt_LimitSecond:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_LimitSecondSetting()")
  self.txt_LimitLevel:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_LimitLevelSetting()")
  self.txt_PartyMemberLimitCount:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_PartyMemberCountSetting()")
  self.btn_RoundCount:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_Setting()")
  self.btn_LimitTime:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_Setting()")
  self.btn_LimitLevel:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_Setting()")
  self.btn_LimitTime:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_Setting()")
  self.btn_PartyMemberLimit:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_Setting()")
  self.chk_ArshaOpen:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_OpenOrClose()")
  self.rdo_RoundMode:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 0 .. ")")
  self.rdo_RoundMode:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  self.rdo_FreeMode:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 1 .. ")")
  self.rdo_FreeMode:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  self.chk_ArshaOpen:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 2 .. ")")
  self.chk_ArshaOpen:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  self.btn_RoundCount:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 3 .. ")")
  self.btn_RoundCount:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  self.btn_LimitTime:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 4 .. ")")
  self.btn_LimitTime:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  self.btn_LimitLevel:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 5 .. ")")
  self.btn_LimitLevel:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  self.btn_PartyMemberLimit:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 6 .. ")")
  self.btn_PartyMemberLimit:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  self.chk_WatchMemberInvite:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 7 .. ")")
  self.chk_WatchMemberInvite:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  self.btn_AllResurrection:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 9 .. ")")
  self.btn_AllResurrection:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  self.btn_InviteList:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 10 .. ")")
  self.btn_InviteList:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  self.btn_GameStart:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 11 .. ")")
  self.btn_GameStart:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  self.btn_GameStop:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 12 .. ")")
  self.btn_GameStop:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  self.btn_Exit:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 13 .. ")")
  self.btn_Exit:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  self.rdo_SelectWait:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 14 .. ")")
  self.rdo_SelectWait:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  self.rdo_SelectWatch:addInputEvent("Mouse_On", "ArshaPvP_Simpletooltip(true, " .. 15 .. ")")
  self.rdo_SelectWatch:addInputEvent("Mouse_Out", "ArshaPvP_Simpletooltip()")
  sub_Kick:addInputEvent("Mouse_Out", "ArshaPvP_SubMenu_Off()")
  sub_KickAll:addInputEvent("Mouse_Out", "ArshaPvP_SubMenu_Off()")
  sub_Upgrade:addInputEvent("Mouse_Out", "ArshaPvP_SubMenu_Off()")
  sub_teamChange:addInputEvent("Mouse_Out", "ArshaPvP_SubMenu_Off()")
  sub_btnTeamMaster:addInputEvent("Mouse_Out", "ArshaPvP_SubMenu_Off()")
  self.btn_Kick_A:addInputEvent("Mouse_LUp", "ArshaPvP_Team_Kick(1, 0)")
  self.btn_Kick_B:addInputEvent("Mouse_LUp", "ArshaPvP_Team_Kick(2, 0)")
  self._timeLimit = 5
  self:registEventHandler()
end
function arshaPvP:registEventHandler()
  registerEvent("FromClient_UpdateObserverList", "FromClient_UpdateTeamUserList")
  registerEvent("FromClient_UpdateEntryList", "FromClient_UpdateTeamUserList")
  registerEvent("FromClient_ChangeMatchType", "FromClient_ChangeMatchType")
  registerEvent("FromClient_UpdateTeamScore", "FromClient_UpdateTeamScore")
  registerEvent("FromClient_CompetitionMatchDone", "FromClient_CompetitionMatchDone")
  registerEvent("FromClient_CompetitionOptionChanged", "FromClient_CompetitionOptionChanged")
  registerEvent("FromClient_CompetitionUseItemModeChanged", "FromClient_CompetitionUseItemModeChanged")
  registerEvent("FromClient_JoinNewPlayer", "FromClient_JoinNewPlayer")
  registerEvent("FromClient_KillHistory", "FromClient_KillHistory")
  registerEvent("FromClient_EntryUserChangeTeam", "FromClient_EntryUserChangeTeam")
  registerEvent("FromClient_GetOutUserFromCompetition", "FromClient_GetOutUserFromCompetition")
  registerEvent("FromClient_ChangeAssistant", "FromClient_ChangeAssistant")
  registerEvent("FromClient_NotifyUseSkill", "FromClient_NotifyUseSkill")
  registerEvent("FromClient_NotifyUseSkillCoolTime", "FromClient_NotifyUseSkillCoolTime")
  registerEvent("FromClient_ChangeTeamName", "FromClient_ChangeTeamName")
  registerEvent("FromClient_CompetitionMatchDoneToObserver", "FromClient_CompetitionMatchDoneToObserver")
  Panel_Window_Arsha:RegisterUpdateFunc("SkillCooltime_UpdatePerFrame")
end
local selectedKey = -1
function ArshaPvP_TeamA_Update(contents, key)
  local idx = Int64toInt32(key)
  selectedKey = idx
  local matchMode = ToClient_CompetitionMatchType()
  local waitListInfo, teamInfo
  if 0 == matchMode then
    waitListInfo = ToClient_GetTeamUserInfoAt(1, idx)
  elseif 1 == matchMode then
    teamInfo = ToClient_GetTeamListAt(idx)
    if nil == teamInfo then
      return
    end
    waitListInfo = ToClient_GetTeamLeaderInfo(teamInfo:getTeamNo())
  elseif 2 == matchMode then
    waitListInfo = ToClient_GetTeamUserInfoAt(1, idx)
    teamInfo = ToClient_GetArshaTeamInfo(1)
    if nil == teamInfo then
      return
    end
  end
  if nil ~= waitListInfo then
    local _static_TeamMaster = UI.getChildControl(contents, "Static_TeamMasterIcon")
    local _txt_Level = UI.getChildControl(contents, "StaticText_Level")
    _txt_Level:SetShow(true)
    _txt_Level:SetPosY(0)
    local _txt_Class = UI.getChildControl(contents, "StaticText_Class")
    _txt_Class:SetShow(true)
    _txt_Class:SetPosY(0)
    local _txt_Name = UI.getChildControl(contents, "StaticText_Name")
    _txt_Name:SetShow(true)
    _txt_Name:SetPosY(0)
    local teamNo = waitListInfo:getTeamNo()
    local userNo = waitListInfo:getUserNo()
    local userLevel = waitListInfo:getCharacterLevel()
    local userClass = waitListInfo:getCharacterClass()
    local userName = waitListInfo:getUserName()
    local characterName = waitListInfo:getCharacterName()
    local isAssistant = waitListInfo:isAssistant()
    _txt_Level:SetText(userLevel)
    _txt_Class:SetText(getCharacterClassName(userClass))
    _txt_Name:SetText(characterName)
    if waitListInfo:isHost() then
      _txt_Name:SetFontColor(Defines.Color.C_FFFFD237)
    elseif waitListInfo:isAssistant() then
      _txt_Name:SetFontColor(Defines.Color.C_FFB5FF6D)
    else
      _txt_Name:SetFontColor(Defines.Color.C_FFFFFFFF)
    end
    local isHost = ToClient_IsCompetitionHost()
    local isSubHost = ToClient_IsCompetitionAssistant()
    if isHost or isSubHost then
      _txt_Name:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_TeamSubMenuShow( " .. idx .. ", " .. 0 .. ", " .. tostring(userNo) .. ", " .. tostring(isAssistant) .. " )")
    else
      _txt_Name:addInputEvent("Mouse_LUp", "")
    end
    if 2 == ToClient_CompetitionMatchType() then
      if waitListInfo:getUserNo() == teamInfo:getTeamMaster() then
        _static_TeamMaster:SetShow(true)
      else
        _static_TeamMaster:SetShow(false)
      end
      if true == waitListInfo:isDeadInPersonalMatch() then
        _txt_Name:SetFontColor(Defines.Color.C_FF444444)
      end
    else
      _static_TeamMaster:SetShow(false)
    end
    Panel_Window_ArshaPvPSubMenu:addInputEvent("Mouse_Out", "ArshaPvP_SubMenu_Off()")
  end
end
function ArshaPvP_TeamB_Update(contents, key)
  local idx = Int64toInt32(key)
  selectedKey = idx
  local matchMode = ToClient_CompetitionMatchType()
  local waitListInfo, teamInfo
  if 0 == matchMode then
    waitListInfo = ToClient_GetTeamUserInfoAt(2, idx)
  elseif 1 == matchMode then
    waitListInfo = ToClient_GetEntryListAt(idx)
  elseif 2 == matchMode then
    waitListInfo = ToClient_GetTeamUserInfoAt(2, idx)
    teamInfo = ToClient_GetArshaTeamInfo(2)
    if nil == teamInfo then
      return
    end
  end
  if nil ~= waitListInfo then
    local _static_TeamMaster = UI.getChildControl(contents, "Static_TeamMasterIcon")
    local _txt_Level = UI.getChildControl(contents, "StaticText_Level")
    _txt_Level:SetShow(true)
    _txt_Level:SetPosY(0)
    local _txt_Class = UI.getChildControl(contents, "StaticText_Class")
    _txt_Class:SetShow(true)
    _txt_Class:SetPosY(0)
    local _txt_Name = UI.getChildControl(contents, "StaticText_Name")
    _txt_Name:SetShow(true)
    _txt_Name:SetPosY(0)
    local teamNo = waitListInfo:getTeamNo()
    local userNo = waitListInfo:getUserNo()
    local userLevel = waitListInfo:getCharacterLevel()
    local userClass = waitListInfo:getCharacterClass()
    local characterName = waitListInfo:getCharacterName()
    local isAssistant = waitListInfo:isAssistant()
    _txt_Level:SetText(userLevel)
    _txt_Class:SetText(getCharacterClassName(userClass))
    _txt_Name:SetText(characterName)
    if waitListInfo:isHost() then
      _txt_Name:SetFontColor(Defines.Color.C_FFFFD237)
    elseif waitListInfo:isAssistant() then
      _txt_Name:SetFontColor(Defines.Color.C_FFB5FF6D)
    else
      _txt_Name:SetFontColor(Defines.Color.C_FFFFFFFF)
    end
    local isHost = ToClient_IsCompetitionHost()
    local isSubHost = ToClient_IsCompetitionAssistant()
    if isHost or isSubHost then
      _txt_Name:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_TeamSubMenuShow( " .. idx .. ", " .. 1 .. ", " .. tostring(userNo) .. ", " .. tostring(isAssistant) .. " )")
    else
      _txt_Name:addInputEvent("Mouse_LUp", "")
    end
    if 2 == ToClient_CompetitionMatchType() then
      if waitListInfo:getUserNo() == teamInfo:getTeamMaster() then
        _static_TeamMaster:SetShow(true)
      else
        _static_TeamMaster:SetShow(false)
      end
      if true == waitListInfo:isDeadInPersonalMatch() then
        _txt_Name:SetFontColor(Defines.Color.C_FF444444)
      end
    else
      _static_TeamMaster:SetShow(false)
    end
    Panel_Window_ArshaPvPSubMenu:addInputEvent("Mouse_Out", "ArshaPvP_SubMenu_Off()")
  end
end
function ArshaPvP_Wait_Update(contents, key)
  local idx = Int64toInt32(key)
  selectedKey = idx
  local waitListInfo = ToClient_GetTeamUserInfoAt(0, idx)
  if nil ~= waitListInfo and 0 == waitListInfo:getTeamNo() then
    local _txt_Level = UI.getChildControl(contents, "StaticText_Level")
    _txt_Level:SetShow(true)
    _txt_Level:SetPosX(0)
    _txt_Level:SetPosY(5)
    local _txt_Class = UI.getChildControl(contents, "StaticText_Class")
    _txt_Class:SetShow(true)
    _txt_Class:SetPosX(110)
    _txt_Class:SetPosY(5)
    local _txt_Name = UI.getChildControl(contents, "StaticText_Name")
    _txt_Name:SetShow(true)
    _txt_Name:SetPosX(185)
    _txt_Name:SetPosY(5)
    local teamNo = waitListInfo:getTeamNo()
    local userNo = waitListInfo:getUserNo()
    local userLevel = waitListInfo:getCharacterLevel()
    local userClass = waitListInfo:getCharacterClass()
    local characterName = waitListInfo:getCharacterName()
    local isAssistant = waitListInfo:isAssistant()
    _txt_Level:SetText(userLevel)
    _txt_Class:SetText(getCharacterClassName(userClass))
    _txt_Name:SetText(characterName)
    if waitListInfo:isHost() then
      _txt_Name:SetFontColor(Defines.Color.C_FFFFD237)
    elseif waitListInfo:isAssistant() then
      _txt_Name:SetFontColor(Defines.Color.C_FFB5FF6D)
    else
      _txt_Name:SetFontColor(Defines.Color.C_FFFFFFFF)
    end
    local isHost = ToClient_IsCompetitionHost()
    local isSubHost = ToClient_IsCompetitionAssistant()
    if isHost or isSubHost then
      _txt_Name:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_TeamSubMenuShow( " .. idx .. ", " .. 2 .. ", " .. tostring(userNo) .. ", " .. tostring(isAssistant) .. " )")
    else
      _txt_Name:addInputEvent("Mouse_LUp", "")
    end
    Panel_Window_ArshaPvPSubMenu:addInputEvent("Mouse_Out", "ArshaPvP_SubMenu_Off()")
  end
end
function ArshaPvP_Observer_Update(contents, key)
  local idx = Int64toInt32(key)
  selectedKey = idx
  local waitListInfo = ToClient_GetObserverListAt(idx)
  if nil ~= waitListInfo then
    local _txt_Level = UI.getChildControl(contents, "StaticText_Level")
    _txt_Level:SetShow(true)
    _txt_Level:SetPosX(0)
    _txt_Level:SetPosY(5)
    local _txt_Class = UI.getChildControl(contents, "StaticText_Class")
    _txt_Class:SetShow(true)
    _txt_Class:SetPosX(110)
    _txt_Class:SetPosY(5)
    local _txt_Name = UI.getChildControl(contents, "StaticText_Name")
    _txt_Name:SetShow(true)
    _txt_Name:SetPosX(185)
    _txt_Name:SetPosY(5)
    local teamNo = waitListInfo:getTeamNo()
    local userNo = waitListInfo:getUserNo()
    local userLevel = waitListInfo:getCharacterLevel()
    local userClass = waitListInfo:getCharacterClass()
    local characterName = waitListInfo:getCharacterName()
    local isAssistant = waitListInfo:isAssistant()
    _txt_Level:SetText(userLevel)
    _txt_Class:SetText(getCharacterClassName(userClass))
    _txt_Name:SetText(characterName)
    if waitListInfo:isHost() then
      _txt_Name:SetFontColor(Defines.Color.C_FFFFD237)
    elseif waitListInfo:isAssistant() then
      _txt_Name:SetFontColor(Defines.Color.C_FFB5FF6D)
    else
      _txt_Name:SetFontColor(Defines.Color.C_FFFFFFFF)
    end
    local isHost = ToClient_IsCompetitionHost()
    local isSubHost = ToClient_IsCompetitionAssistant()
    if isHost or isSubHost then
      _txt_Name:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_TeamSubMenuShow( " .. idx .. ", " .. 3 .. ", " .. tostring(userNo) .. ", " .. tostring(isAssistant) .. " )")
    else
      _txt_Name:addInputEvent("Mouse_LUp", "")
    end
    Panel_Window_ArshaPvPSubMenu:addInputEvent("Mouse_Out", "ArshaPvP_SubMenu_Off()")
  end
end
function ArshaPvP_SelectedUpdate_Round()
  local self = arshaPvP
  local ListTeamACount = ToClient_GetTeamUserInfoCount(1)
  self.list2_ArshaTeamA:getElementManager():clearKey()
  if ListTeamACount > 0 then
    for idx = 0, ListTeamACount - 1 do
      self.list2_ArshaTeamA:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local ListTeamBCount = ToClient_GetTeamUserInfoCount(2)
  self.list2_ArshaTeamB:getElementManager():clearKey()
  if ListTeamBCount > 0 then
    for idx = 0, ListTeamBCount - 1 do
      self.list2_ArshaTeamB:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local ListWaitCount = ToClient_GetTeamUserInfoCount(0)
  self.list2_ArshaWait:getElementManager():clearKey()
  if ListWaitCount > 0 then
    for idx = 0, ListWaitCount - 1 do
      self.list2_ArshaWait:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local ListObserverCount = ToClient_GetObserverListCount()
  self.list2_ArshaObserver:getElementManager():clearKey()
  if ListObserverCount > 0 then
    for idx = 0, ListObserverCount - 1 do
      self.list2_ArshaObserver:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local teamA_Info = ToClient_GetTeamListAt(0)
  local teamB_Info = ToClient_GetTeamListAt(1)
  local teamA_Name = ""
  local teamB_Name = ""
  if nil ~= teamA_Info and nil ~= teamB_Info then
    teamA_Name = teamA_Info:getTeamName()
    teamB_Name = teamB_Info:getTeamName()
  end
  if "" == teamA_Name or "" == teamB_Name then
    teamA_Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_A")
    teamB_Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_B")
  end
  self.txt_RoundMarkTeamA:SetText(teamA_Name)
  self.txt_RoundMarkTeamB:SetText(teamB_Name)
end
function ArshaPvP_SelectedUpdate_FreeForAll()
  local self = arshaPvP
  local tempidx = 0
  local ListPartyMasterCount = ToClient_GetTeamListCountWithOutZero()
  self.list2_ArshaTeamA:getElementManager():clearKey()
  if ListPartyMasterCount > 0 then
    for idx = 0, ListPartyMasterCount - 1 do
      self.list2_ArshaTeamA:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local ListAllUserCount = ToClient_GetEntryListCount()
  self.list2_ArshaTeamB:getElementManager():clearKey()
  if ListAllUserCount > 0 then
    for idx = 0, ListAllUserCount - 1 do
      self.list2_ArshaTeamB:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local ListWaitCount = ToClient_GetTeamUserInfoCount(0)
  self.list2_ArshaWait:getElementManager():clearKey()
  if ListWaitCount > 0 then
    for idx = 0, ListWaitCount - 1 do
      self.list2_ArshaWait:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local ListObserverCount = ToClient_GetObserverListCount()
  self.list2_ArshaObserver:getElementManager():clearKey()
  if ListObserverCount > 0 then
    for idx = 0, ListObserverCount - 1 do
      self.list2_ArshaObserver:getElementManager():pushKey(toInt64(0, idx))
    end
  end
end
function ArshaPvP_SelectedUpdate_PersonalMatch()
  local self = arshaPvP
  local ListTeamACount = ToClient_GetTeamUserInfoCount(1)
  self.list2_ArshaTeamA:getElementManager():clearKey()
  if ListTeamACount > 0 then
    for idx = 0, ListTeamACount - 1 do
      self.list2_ArshaTeamA:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local ListTeamBCount = ToClient_GetTeamUserInfoCount(2)
  self.list2_ArshaTeamB:getElementManager():clearKey()
  if ListTeamBCount > 0 then
    for idx = 0, ListTeamBCount - 1 do
      self.list2_ArshaTeamB:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local ListWaitCount = ToClient_GetTeamUserInfoCount(0)
  self.list2_ArshaWait:getElementManager():clearKey()
  if ListWaitCount > 0 then
    for idx = 0, ListWaitCount - 1 do
      self.list2_ArshaWait:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local ListObserverCount = ToClient_GetObserverListCount()
  self.list2_ArshaObserver:getElementManager():clearKey()
  if ListObserverCount > 0 then
    for idx = 0, ListObserverCount - 1 do
      self.list2_ArshaObserver:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local teamA_Info = ToClient_GetArshaTeamInfo(1)
  local teamB_Info = ToClient_GetArshaTeamInfo(2)
  local teamA_Name = ""
  local teamB_Name = ""
  if nil ~= teamA_Info and nil ~= teamB_Info then
    teamA_Name = teamA_Info:getTeamName()
    teamB_Name = teamB_Info:getTeamName()
  end
  if "" == teamA_Name or "" == teamB_Name then
    teamA_Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_A")
    teamB_Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_B")
  end
  self.txt_personalRoundTeamA:SetText(teamA_Name)
  self.txt_personalRoundTeamB:SetText(teamB_Name)
end
function FGlobal_ArshaPvP_ChangeAssistant(userNo_s64, isAssistant)
  local function ChangeAssistantUser()
    ToClient_RequestChangeAssistans(userNo_s64, isAssistant)
  end
  local userinfo = ToClient_GetCompetitionDefinedUser(userNo_s64)
  local characterName = ""
  if nil ~= userinfo then
    characterName = userinfo:getCharacterName()
  end
  local message
  if true == isAssistant then
    message = "LUA_COMPETITION_REQUEST_SET_ASSISTANT"
  else
    message = "LUA_COMPETITION_REQUEST_RELEASE_ASSISTANT"
  end
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, message, "name", characterName)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = ChangeAssistantUser,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FGlobal_ArshaPvP_ChangeTeam(teamNo, userNo, isObserver)
  if -1 == teamNo then
    txt_teamNo:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_OBSERVER"))
  end
  ToClient_RequestSetTeam(userNo, teamNo)
  ClearFocusEdit()
end
function FGlobal_CheckArshaPvpUiEdit(targetUI)
  local self = arshaPvP
  return nil ~= targetUI and targetUI:GetKey() == self.edit_InviteMemberEdit:GetKey()
end
function HandleClicked_ArshaPvP_EditSetFocus()
  local self = arshaPvP
  SetFocusEdit(self.edit_InviteMemberEdit)
  self.edit_InviteMemberEdit:SetEditText(self.edit_InviteMemberEdit:GetEditText(), true)
end
function FGlobal_ArshaPvPClearFocusEdit()
  ClearFocusEdit()
  CheckChattingInput()
end
function HandleClicked_ArshaPvP_TeamChange(teamNo)
  if nil == getSelfPlayer() then
    return
  end
  local userNo = getSelfPlayer():get():getUserNo()
  ToClient_RequestSetTeam(userNo, teamNo)
end
function ArshaPvP_RefreshUpdate()
  local self = arshaPvP
  local matchMode = ToClient_CompetitionMatchType()
  local isHost = ToClient_IsCompetitionHost()
  local isSubHost = ToClient_IsCompetitionAssistant()
  if CppEnums.CompetitionMatchType.eCompetitionMatchMode_Round == matchMode then
    self.rdo_RoundMode:SetCheck(true)
    self.rdo_FreeMode:SetCheck(false)
    self.rdo_PersonalMode:SetCheck(false)
    self.roundWing:SetShow(true)
    self.freeWing:SetShow(false)
    self.personalMatchWing:SetShow(false)
  elseif CppEnums.CompetitionMatchType.eCompetitionMatchMode_FreeForAll == matchMode then
    self.rdo_RoundMode:SetCheck(false)
    self.rdo_FreeMode:SetCheck(true)
    self.rdo_PersonalMode:SetCheck(false)
    self.roundWing:SetShow(false)
    self.freeWing:SetShow(true)
    self.personalMatchWing:SetShow(false)
  elseif CppEnums.CompetitionMatchType.eCompetitionMatchMode_Personal == matchMode then
    self.rdo_RoundMode:SetCheck(false)
    self.rdo_FreeMode:SetCheck(false)
    self.rdo_PersonalMode:SetCheck(true)
    self.roundWing:SetShow(false)
    self.freeWing:SetShow(false)
    self.personalMatchWing:SetShow(true)
  end
  if isHost then
    self.btn_GoA:SetShow(true)
    self.btn_GoB:SetShow(true)
    self.btn_GoWait:SetShow(true)
    self.btn_GameStart:SetShow(true)
    self.btn_GameStop:SetShow(true)
    self.btn_Exit:SetShow(true)
    self.btn_AllResurrection:SetShow(true)
    self.btn_InviteList:SetShow(true)
    self.btn_NameChange:SetShow(true)
  elseif isSubHost then
    self.btn_GoA:SetShow(true)
    self.btn_GoB:SetShow(true)
    self.btn_GoWait:SetShow(true)
    self.btn_GameStart:SetShow(false)
    self.btn_GameStop:SetShow(false)
    self.btn_Exit:SetShow(true)
    self.btn_AllResurrection:SetShow(false)
    self.btn_InviteList:SetShow(true)
    self.btn_NameChange:SetShow(true)
    self.arshaManagementTitle:SetShow(true)
    self.img_NotAdmin:SetShow(false)
    self.rdo_RoundMode:SetIgnore(true)
    self.rdo_FreeMode:SetIgnore(true)
    self.chk_ArshaOpen:SetIgnore(true)
    self.txt_RoundCount:SetIgnore(true)
    self.btn_RoundCount:SetIgnore(true)
    self.txt_LimitMinute:SetIgnore(true)
    self.txt_LimitSecond:SetIgnore(true)
    self.btn_LimitTime:SetIgnore(true)
    self.txt_LimitLevel:SetIgnore(true)
    self.btn_LimitLevel:SetIgnore(true)
    self.txt_PartyMemberLimitCount:SetIgnore(true)
    self.btn_PartyMemberLimit:SetIgnore(true)
    self.rdo_RoundMode:SetMonoTone(true)
    self.rdo_FreeMode:SetMonoTone(true)
    self.chk_ArshaOpen:SetMonoTone(true)
    self.txt_RoundCount:SetMonoTone(true)
    self.btn_RoundCount:SetMonoTone(true)
    self.txt_LimitMinute:SetMonoTone(true)
    self.txt_LimitSecond:SetMonoTone(true)
    self.btn_LimitTime:SetMonoTone(true)
    self.txt_LimitLevel:SetMonoTone(true)
    self.btn_LimitLevel:SetMonoTone(true)
    self.txt_PartyMemberLimitCount:SetMonoTone(true)
    self.btn_PartyMemberLimit:SetMonoTone(true)
  else
    local isHost = ToClient_IsCompetitionHost()
    local isSubHost = ToClient_IsCompetitionAssistant()
    local isCanChangeTeam = ToClient_IsMyselfInEntryUser() and (0 == matchMode or 2 == matchMode) and not isHost and not isSubHost
    self.btn_GoA:SetShow(isCanChangeTeam)
    self.btn_GoB:SetShow(isCanChangeTeam)
    self.btn_GoWait:SetShow(isCanChangeTeam)
    self.btn_Kick_A:SetShow(isCanChangeTeam)
    self.btn_Kick_B:SetShow(isCanChangeTeam)
    self.btn_Exit:SetShow(true)
    self.btn_GameStart:SetShow(false)
    self.btn_GameStop:SetShow(false)
    self.btn_AllResurrection:SetShow(false)
    self.btn_InviteList:SetShow(false)
    self.btn_NameChange:SetShow(false)
  end
  self._targetScore = ToClient_GetTargetScore()
  self._levelLimit = ToClient_GetLevelLimit()
  self._maxPartyMemberCount = ToClient_GetMaxPartyMemberCount()
  levellimit = self._levelLimit
  ArshaPvP_Widget_Update()
  ArshaPvP_SubMenu_ButtonPosition()
  local isLimitSecondTime = self._timeLimit * 60
  local limitMinuteTime = 0
  local limitSecondTime = 0
  if isLimitSecondTime >= 60 then
    limitMinuteTime = math.floor(isLimitSecondTime / 60)
    limitSecondTime = math.ceil(isLimitSecondTime % 60)
  else
    limitSecondTime = isLimitSecondTime
  end
  self.txt_RoundCount:SetText(self._targetScore)
  self.txt_LimitMinute:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", limitMinuteTime))
  self.txt_LimitSecond:SetText(limitSecondTime)
  self.txt_LimitLevel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WINDOW_ARSHA_LEVELLIMIT", "level", levellimit))
  self.txt_PartyMemberLimitCount:SetText(self._maxPartyMemberCount)
end
function HandleClicked_ArshaPvP_GameStart()
  local self = arshaPvP
  local targetScore = ToClient_GetTargetScore()
  ToClient_RequestStartArshaMatch()
end
function HandleClicked_ArshaPvP_GameStop()
  ToClient_RequestSetFight(CppEnums.CompetitionFightState.eCompetitionFightState_Done)
end
function HandleClicked_ArshaPvP_Exit()
  local ArshaPvP_Exit = function()
    ToClient_RequestLeaveMyself()
  end
  local isHost = ToClient_IsCompetitionHost()
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_EXIT_BTN_DESC_MESSAGEBOX_NORMAL")
  if isHost then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_EXIT_BTN_DESC_MESSAGEBOX_HOST")
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_EXIT_BTN_DESC_MESSAGEBOX_NORMAL")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = ArshaPvP_Exit,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleClicked_ArshaPvP_ModeChange(matchMode)
  local self = arshaPvP
  local isHost = ToClient_IsCompetitionHost()
  local isSubHost = ToClient_IsCompetitionAssistant()
  local limitTimeSum = ToClient_CompetitionMatchTimeLimit()
  ToClient_CompetitionMatchTypeChange(matchMode)
  if 0 == matchMode then
    self.txt_RoundCountTitle:SetShow(true)
    self.txt_RoundCountTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_ROUNDOFWIN_TITLE"))
    self.txt_LimitTimeTitle:SetPosX(25)
    self.txt_LimitTimeTitle:SetPosY(80)
    self.txt_LimitMinute:SetPosX(185)
    self.txt_LimitMinute:SetPosY(80)
    self.txt_LimitMinuteTitle:SetPosX(242)
    self.txt_LimitMinuteTitle:SetPosY(80)
    self.txt_LimitSecond:SetPosX(185)
    self.txt_LimitSecond:SetPosY(80)
    self.txt_LimitSecondTitle:SetPosX(242)
    self.txt_LimitSecondTitle:SetPosY(80)
    self.btn_LimitTime:SetPosX(305)
    self.btn_LimitTime:SetPosY(80)
    self.txt_LimitLevelTitle:SetPosX(25)
    self.txt_LimitLevelTitle:SetPosY(110)
    self.txt_LimitLevel:SetPosX(185)
    self.txt_LimitLevel:SetPosY(110)
    self.txt_LimitLevelMore:SetPosX(242)
    self.txt_LimitLevelMore:SetPosY(110)
    self.btn_LimitLevel:SetPosX(305)
    self.btn_LimitLevel:SetPosY(110)
    self.txt_RoundCount:SetShow(true)
    self.btn_RoundCount:SetShow(true)
    self.txt_PartyMemberLimitTItle:SetShow(false)
    self.txt_PartyMemberLimitCount:SetShow(false)
    self.btn_PartyMemberLimit:SetShow(false)
    self.btn_GoA:SetSize(267, 35)
    self.btn_GoB:SetSize(267, 35)
    self.txt_LimitMinute:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", limitMinuteTime))
    self.txt_LimitLevel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WINDOW_ARSHA_LEVELLIMIT", "level", levellimit))
    if isHost or isSubHost then
      self.btn_Kick_A:SetShow(true)
      self.btn_Kick_B:SetShow(true)
    else
      self.btn_Kick_A:SetShow(false)
      self.btn_Kick_B:SetShow(false)
    end
  elseif 1 == matchMode then
    self.txt_RoundCountTitle:SetShow(true)
    self.txt_RoundCountTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_ROUNDOFALIVE_TITLE"))
    self.txt_RoundCount:SetShow(true)
    self.txt_RoundCount:SetShow(true)
    self.btn_RoundCount:SetShow(true)
    self.txt_LimitTimeTitle:SetPosY(80)
    self.txt_LimitMinute:SetPosY(80)
    self.txt_LimitMinuteTitle:SetPosY(80)
    self.txt_LimitSecond:SetPosY(110)
    self.txt_LimitSecondTitle:SetPosY(110)
    self.btn_LimitTime:SetPosY(80)
    self.txt_LimitLevelTitle:SetPosY(110)
    self.txt_LimitLevel:SetPosY(110)
    self.txt_LimitLevelMore:SetPosY(110)
    self.btn_LimitLevel:SetPosY(110)
    self.txt_PartyMemberLimitTItle:SetShow(true)
    self.txt_PartyMemberLimitCount:SetShow(true)
    self.btn_PartyMemberLimit:SetShow(true)
    self.btn_Kick_A:SetShow(false)
    self.btn_Kick_B:SetShow(false)
    self.btn_GoA:SetShow(false)
    self.btn_GoB:SetShow(false)
    self.btn_GoA:SetSize(370, 35)
    self.btn_GoB:SetSize(370, 35)
    self.txt_LimitMinute:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", limitMinuteTime))
    self.txt_LimitLevel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WINDOW_ARSHA_LEVELLIMIT", "level", levellimit))
  elseif 2 == matchMode then
    self.txt_RoundCountTitle:SetShow(false)
    self.txt_RoundCountTitle:SetShow(false)
    self.txt_RoundCountTitle:SetShow(false)
    self.txt_RoundCountTitle:SetShow(false)
    self.txt_RoundCountTitle:SetShow(false)
    self.txt_LimitTimeTitle:SetPosY(50)
    self.txt_LimitMinute:SetPosY(50)
    self.txt_LimitMinuteTitle:SetPosY(50)
    self.btn_LimitTime:SetPosY(50)
    self.txt_LimitLevelTitle:SetPosY(80)
    self.txt_LimitLevel:SetPosY(80)
    self.txt_LimitLevelMore:SetPosY(80)
    self.btn_LimitLevel:SetPosY(80)
    self.txt_RoundCount:SetShow(false)
    self.btn_RoundCount:SetShow(false)
    self.txt_PartyMemberLimitTItle:SetShow(false)
    self.txt_PartyMemberLimitCount:SetShow(false)
    self.btn_PartyMemberLimit:SetShow(false)
    self.btn_GoA:SetShow(true)
    self.btn_GoB:SetShow(true)
    self.btn_GoA:SetSize(370, 35)
    self.btn_GoB:SetSize(370, 35)
    self.txt_LimitMinute:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", limitMinuteTime))
    self.txt_LimitLevel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WINDOW_ARSHA_LEVELLIMIT", "level", levellimit))
  end
  ToClient_RequestCompetitionOption(self._isOpen, limitTimeSum, self._targetScore, self._levelLimit, self._maxPartyMemberCount, self._maxWaitTime)
end
function HandleClicked_ArshaPvP_Setting()
  local self = arshaPvP
  local matchMode = ToClient_CompetitionMatchType()
  local targetScore = ToClient_GetTargetScore()
  local limitTimeSum = 0
  if 0 < self._timeLimit then
    limitTimeSum = self._timeLimit * 60
  end
  self._targetScore = tonumber(self.txt_RoundCount:GetText())
  self._levelLimit = levellimit
  self._maxPartyMemberCount = tonumber(self.txt_PartyMemberLimitCount:GetText())
  self._maxWaitTime = 20
  if true == self._isOpen then
    self.chk_ArshaOpen:SetCheck(false)
  else
    self.chk_ArshaOpen:SetCheck(true)
  end
  if 0 == matchMode then
    local roundCount = targetScore * 2 - 1
    self.descBG:SetText(PAGetStringParam4(Defines.StringSheet_GAME, "LUA_ARSHA_USER_DESC_GAMEPROGRESSES_ROUND", "limitTimeSum", limitTimeSum, "level", levellimit, "round", roundCount, "targetScore", targetScore))
    self.txt_RoundMarkCount:SetText(roundCount)
    self.txt_RoundCountTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_ROUNDOFWIN_TITLE"))
  elseif 1 == matchMode then
    self.descBG:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_ARSHA_USER_DESC_GAMEPROGRESSES_FREE", "limitTimeSum", limitTimeSum, "level", levellimit, "targetScore", targetScore))
    self.txt_FreeMarkCount:SetText(targetScore)
    self.txt_RoundCountTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_ROUNDOFALIVE_TITLE"))
  end
  self.descBG:SetSize(self.descBG:GetSizeX(), self.descBG:GetTextSizeY() + 10)
  self.descBG:ComputePos()
  ArshaPvP_Widget_Update()
  ToClient_RequestCompetitionOption(self._isOpen, limitTimeSum, self._targetScore, self._levelLimit, self._maxPartyMemberCount, self._maxWaitTime)
end
function HandleClicked_ArshaPvP_ChangeOption()
  local self = arshaPvP
  local matchMode = ToClient_CompetitionMatchType()
  local targetScore = ToClient_GetTargetScore()
  if 0 == matchMode then
    self.txt_modeTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_TEAMMODE_TITLE"))
    self.txt_RoundCountTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_ROUNDOFWIN_TITLE"))
    self.txt_RoundMarkCount:SetText(targetScore * 2 - 1)
    self.txt_RoundMarkText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ARSHA_USER_OPTION_ROUND_FORCOUNT", "targetScore", targetScore))
    if 1 == targetScore then
    end
  elseif 1 == matchMode then
    self.txt_modeTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_ALIVEMODE_TITLE"))
    self.txt_RoundCountTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_ROUNDOFALIVE_TITLE"))
    self.txt_FreeMarkCount:SetText(targetScore)
    self.txt_FreeMarkText:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_ALIVEMODE_TITLE"))
  elseif 2 == matchMode then
    self.txt_modeTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_PERSONALMODE_TITLE"))
    self.txt_personalMatchText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_PERSONALMODE"))
  end
  if targetScore <= 0 then
  end
end
function HandleClicked_ArshaPvP_WaitAndWatch(selectType)
  local self = arshaPvP
  local isWaitList = self.rdo_SelectWait:IsCheck()
  local isWatchList = self.rdo_SelectWatch:IsCheck()
  ArshaPvP_SubMenu_PowerOff()
  local isHost = ToClient_IsCompetitionHost()
  local isSubHost = ToClient_IsCompetitionAssistant()
  if isWaitList then
    self.rdo_SelectWait:SetCheck(true)
    self.rdo_SelectWatch:SetCheck(false)
    self.list2_ArshaWait:SetShow(true)
    self.list2_ArshaObserver:SetShow(false)
  elseif isWatchList then
    self.rdo_SelectWait:SetCheck(false)
    self.rdo_SelectWatch:SetCheck(true)
    self.list2_ArshaWait:SetShow(false)
    self.list2_ArshaObserver:SetShow(true)
  end
  ArshaPvP_SubMenu_ButtonPosition()
end
function HandleClicked_ArshaPvP_Summon()
  local self = arshaPvP
  local characterName = self.edit_InviteMemberEdit:GetEditText()
  local isObserver = self.chk_WatchMemberInvite:IsCheck()
  if nil == characterName or "" == characterName then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SUMMON_ACK"))
    return
  end
  ToClient_RequestInviteCompetition(characterName, isObserver)
  ClearFocusEdit()
end
function HandleClicked_ArshaPvP_AllPlayerResurrection()
  ToClient_RequestRebirthPlayerAll()
end
function HandleClicked_ArshaPvP_InviteList()
  FGlobal_ArshaPvP_InviteList_Open()
end
function HandleClicked_ArshaPvP_RoundCountSetting()
  local s64_maxNumber = toInt64(0, 10)
  Panel_NumberPad_Show(true, s64_maxNumber, param, ArshaPvP_RoundCountConfirmFunction)
end
function ArshaPvP_RoundCountConfirmFunction(inputNumber, param)
  local self = arshaPvP
  self.txt_RoundCount:SetText(Int64toInt32(inputNumber))
end
function HandleClicked_ArshaPvP_LimitMinuteSetting()
  local s64_maxNumber = toInt64(0, 60)
  Panel_NumberPad_Show(true, s64_maxNumber, param, ArshaPvP_LimitMinuteConfirmFunction)
end
function ArshaPvP_LimitMinuteConfirmFunction(inputNumber, param)
  local self = arshaPvP
  self.txt_LimitSecond:SetText(0)
  limitTimeSum = Int64toInt32(inputNumber)
  self._timeLimit = limitTimeSum
  self.txt_LimitMinute:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", limitTimeSum))
end
function HandleClicked_ArshaPvP_LimitSecondSetting()
  local self = arshaPvP
  local s64_maxNumber = toInt64(0, 60)
  if 5 <= tonumber(self.txt_LimitMinute:GetText()) then
    return
  end
  Panel_NumberPad_Show(true, s64_maxNumber, param, ArshaPvP_LimitSecondConfirmFunction)
end
function ArshaPvP_LimitSecondConfirmFunction(inputNumber, param)
  local self = arshaPvP
  if 5 < tonumber(self.txt_LimitMinute:GetText()) then
    self.txt_LimitSecond:SetText(0)
    return
  end
  self.txt_LimitSecond:SetText(Int64toInt32(inputNumber))
end
function HandleClicked_ArshaPvP_LimitLevelSetting()
  local self = arshaPvP
  local s64_maxNumber = toInt64(0, 99)
  Panel_NumberPad_Show(true, s64_maxNumber, param, ArshaPvP_LimitLevelConfirmFunction)
end
function ArshaPvP_LimitLevelConfirmFunction(inputNumber, param)
  local self = arshaPvP
  self._levelLimit = levellimit
  levellimit = Int64toInt32(inputNumber)
  self.txt_LimitLevel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WINDOW_ARSHA_LEVELLIMIT", "level", levellimit))
end
function HandleClicked_ArshaPvP_PartyMemberCountSetting()
  local self = arshaPvP
  local s64_maxNumber = toInt64(0, 5)
  Panel_NumberPad_Show(true, s64_maxNumber, param, ArshaPvP_PartyMemberConfirmFunction)
end
function ArshaPvP_PartyMemberConfirmFunction(inputNumber, param)
  local self = arshaPvP
  self.txt_PartyMemberLimitCount:SetText(Int64toInt32(inputNumber))
end
function HandleClicked_ArshaPvP_TeamSubMenuShow(idx, controlType, userNo_s64, isAssistant)
  local self = arshaPvP
  local isHost = ToClient_IsCompetitionHost()
  local isSubHost = ToClient_IsCompetitionAssistant()
  local isMatchType = ToClient_CompetitionMatchType()
  local contents = self.list2_ArshaTeamA:GetContentByKey(toInt64(0, idx))
  Panel_Window_ArshaPvPSubMenu:SetSize(200, 180)
  sub_Kick:SetPosY(8)
  sub_KickAll:SetPosY(41)
  sub_Upgrade:SetPosY(74)
  sub_teamChange:SetPosY(107)
  if 0 == controlType then
    contents = self.list2_ArshaTeamA:GetContentByKey(toInt64(0, idx))
    if isHost then
      if 0 == isMatchType then
        sub_KickAll:addInputEvent("Mouse_LUp", "ArshaPvP_Team_Kick(1, " .. 0 .. ")")
        Panel_Window_ArshaPvPSubMenu:SetSize(200, 148)
        sub_teamChange:SetShow(true)
        sub_btnTeamMaster:SetShow(false)
        sub_Upgrade:SetPosY(74)
        sub_teamChange:SetPosY(107)
      elseif 1 == isMatchType then
        Panel_Window_ArshaPvPSubMenu:SetSize(200, 113)
        sub_teamChange:SetShow(false)
        sub_btnTeamMaster:SetShow(false)
        sub_Upgrade:SetPosY(74)
        sub_teamChange:SetPosY(107)
      elseif 2 == isMatchType then
        sub_teamChange:SetShow(true)
        sub_btnTeamMaster:SetShow(true)
        sub_btnTeamMaster:addInputEvent("Mouse_LUp", "ToClient_SetPersonalMatchTeamMaster(" .. userNo_s64 .. ",1)")
      end
      sub_Kick:SetShow(true)
      sub_KickAll:SetShow(true)
      sub_Upgrade:SetShow(true)
      sub_Kick:SetPosY(8)
    elseif isSubHost then
      Panel_Window_ArshaPvPSubMenu:SetSize(200, 75)
      sub_Kick:SetShow(true)
      sub_Upgrade:SetShow(false)
      sub_teamChange:SetShow(false)
      sub_btnTeamMaster:SetShow(false)
    end
  elseif 1 == controlType then
    contents = self.list2_ArshaTeamB:GetContentByKey(toInt64(0, idx))
    if isHost then
      if 0 == isMatchType then
        sub_KickAll:addInputEvent("Mouse_LUp", "ArshaPvP_Team_Kick(2, " .. 0 .. ")")
        Panel_Window_ArshaPvPSubMenu:SetSize(200, 180)
        sub_teamChange:SetShow(true)
        sub_btnTeamMaster:SetShow(false)
        sub_Upgrade:SetPosY(74)
        sub_teamChange:SetPosY(107)
      elseif 1 == isMatchType then
        Panel_Window_ArshaPvPSubMenu:SetSize(200, 113)
        sub_teamChange:SetShow(false)
        sub_btnTeamMaster:SetShow(false)
        sub_Upgrade:SetPosY(74)
        sub_teamChange:SetPosY(107)
      elseif 2 == isMatchType then
        sub_teamChange:SetShow(true)
        sub_btnTeamMaster:SetShow(true)
        sub_btnTeamMaster:addInputEvent("Mouse_LUp", "ToClient_SetPersonalMatchTeamMaster(" .. userNo_s64 .. ",2)")
      end
      sub_Kick:SetShow(true)
      sub_KickAll:SetShow(true)
      sub_Upgrade:SetShow(true)
      sub_Kick:SetPosY(8)
    elseif isSubHost then
      Panel_Window_ArshaPvPSubMenu:SetSize(200, 75)
      sub_Kick:SetShow(true)
      sub_Upgrade:SetShow(false)
      sub_teamChange:SetShow(false)
      sub_btnTeamMaster:SetShow(false)
    end
  elseif 2 == controlType then
    contents = self.list2_ArshaWait:GetContentByKey(toInt64(0, idx))
    sub_btnTeamMaster:SetShow(false)
    if isHost then
      if 1 == isMatchType then
        Panel_Window_ArshaPvPSubMenu:SetSize(200, 75)
        sub_teamChange:SetShow(false)
        sub_Upgrade:SetPosY(41)
        sub_teamChange:SetPosY(74)
      else
        Panel_Window_ArshaPvPSubMenu:SetSize(200, 113)
        sub_teamChange:SetShow(true)
        sub_Upgrade:SetPosY(41)
        sub_teamChange:SetPosY(74)
      end
      sub_Kick:SetShow(true)
      sub_KickAll:SetShow(false)
      sub_Upgrade:SetShow(true)
      sub_Kick:SetPosY(8)
    elseif isSubHost then
      Panel_Window_ArshaPvPSubMenu:SetSize(200, 40)
      sub_Kick:SetShow(true)
      sub_KickAll:SetShow(false)
      sub_Upgrade:SetShow(false)
      sub_teamChange:SetShow(false)
    end
  elseif 3 == controlType then
    contents = self.list2_ArshaObserver:GetContentByKey(toInt64(0, idx))
    sub_btnTeamMaster:SetShow(false)
    if isHost then
      if 1 == isMatchType then
        Panel_Window_ArshaPvPSubMenu:SetSize(200, 40)
        sub_teamChange:SetShow(false)
        sub_teamChange:SetPosY(38)
      else
        Panel_Window_ArshaPvPSubMenu:SetSize(200, 40)
        sub_teamChange:SetShow(false)
        sub_teamChange:SetPosY(38)
      end
      sub_Kick:SetShow(true)
      sub_KickAll:SetShow(false)
      sub_Upgrade:SetShow(false)
      sub_Kick:SetPosY(8)
    elseif isSubHost then
      Panel_Window_ArshaPvPSubMenu:SetSize(200, 40)
      sub_Kick:SetShow(true)
      sub_KickAll:SetShow(false)
      sub_Upgrade:SetShow(false)
      sub_teamChange:SetShow(false)
    end
  end
  if nil ~= contents then
    local charName = UI.getChildControl(contents, "StaticText_Name")
    Panel_Window_ArshaPvPSubMenu:SetShow(true)
    Panel_Window_ArshaPvPSubMenu:SetPosX(charName:GetParentPosX())
    Panel_Window_ArshaPvPSubMenu:SetPosY(charName:GetParentPosY() + charName:GetSizeY())
    sub_Kick:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_UserKick(" .. idx .. ", " .. userNo_s64 .. ")")
    if 1 == isMatchType then
      sub_KickAll:addInputEvent("Mouse_LUp", "ArshaPvP_Team_Kick(" .. userNo_s64 .. ", " .. 1 .. ")")
    end
    sub_teamChange:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_UserTeamChange(" .. idx .. ", " .. userNo_s64 .. ", " .. tostring(not isAssistant) .. ")")
    sub_Upgrade:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_UserUpgrade(" .. idx .. ", " .. userNo_s64 .. ", " .. tostring(not isAssistant) .. ")")
  end
end
function ArshaPvP_SubMenu_Off()
  local panelPosX = Panel_Window_ArshaPvPSubMenu:GetPosX()
  local panelPosY = Panel_Window_ArshaPvPSubMenu:GetPosY()
  local panelSizeX = Panel_Window_ArshaPvPSubMenu:GetSizeX()
  local panelSizeY = Panel_Window_ArshaPvPSubMenu:GetSizeY()
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  if panelPosX <= mousePosX and mousePosX <= panelPosX + panelSizeX and panelPosY <= mousePosY and mousePosY <= panelPosY + panelSizeY then
    return
  end
  Panel_Window_ArshaPvPSubMenu:SetShow(false)
end
function ArshaPvP_SubMenu_PowerOff()
  Panel_Window_ArshaPvPSubMenu:SetShow(false)
end
function ArshaPvP_SubMenu_ButtonPosition()
  local iconPosY = 4
  if sub_Kick:GetShow() then
    sub_Kick:SetPosY(iconPosY)
    iconPosY = iconPosY + sub_Kick:GetSizeY() + 5
  end
  if sub_Upgrade:GetShow() then
    sub_Upgrade:SetPosY(iconPosY)
    iconPosY = iconPosY + sub_Upgrade:GetSizeY() + 5
  end
  if sub_teamChange:GetShow() then
    sub_teamChange:SetPosY(iconPosY)
    iconPosY = iconPosY + sub_teamChange:GetSizeY() + 5
  end
end
function HandleClicked_ArshaPvP_UserKick(idx, userNo_str)
  local userinfo = ToClient_GetCompetitionDefinedUser(userNo_str)
  ArshaPvP_SubMenu_PowerOff()
  local characterName
  if nil ~= userinfo then
    characterName = userinfo:getCharacterName()
  end
  local function KickUserCompetition()
    ToClient_RequestLeavePlayer(userNo_str)
  end
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_USERKICK_MESSAGEBOX", "name", characterName)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = KickUserCompetition,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleClicked_ArshaPvP_UserTeamChange(idx, userNo_str, isAssistant)
  FGlobal_ArshaPvP_TeamChangeControl_Open(idx, userNo_str, isAssistant)
  ArshaPvP_SubMenu_PowerOff()
end
function HandleClicked_ArshaPvP_UserUpgrade(idx, userNo_str, isAssistant)
  local function ChangeAssistantUser()
    ToClient_RequestChangeAssistans(userNo_str, isAssistant)
  end
  ArshaPvP_SubMenu_PowerOff()
  local userinfo = ToClient_GetCompetitionDefinedUser(userNo_str)
  local characterName = ""
  if nil ~= userinfo then
    characterName = userinfo:getCharacterName()
  end
  local message
  if true == isAssistant then
    message = "LUA_COMPETITION_REQUEST_SET_ASSISTANT"
  else
    message = "LUA_COMPETITION_REQUEST_RELEASE_ASSISTANT"
  end
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, message, "name", characterName)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = ChangeAssistantUser,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleClicked_ArshaPvP_OpenOrClose()
  local self = arshaPvP
  local isOpen = ToClient_IsCompetitionOpen_HostOnly()
  self._isOpen = not isOpen
  HandleClicked_ArshaPvP_Setting()
end
function ArshaPvP_Simpletooltip(isShow, tipType)
  if nil == isShow then
    TooltipSimple_Hide()
    return
  end
  local self = arshaPvP
  local name, desc, control, isOpenType
  local isMatchType = ToClient_CompetitionMatchType()
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_TEAMMODE_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_ROUND_DESC")
    control = self.rdo_RoundMode
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_ALIVEMODE_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_FREE_DESC")
    control = self.rdo_FreeMode
  elseif 2 == tipType then
    if self._isOpen then
      isOpenType = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_OPENTYPE")
    else
      isOpenType = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_CLOSETYPE")
    end
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_OPENCLOSE_TITLE")
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_OPENCLOSE_DESC", "isOpenType", isOpenType)
    control = self.chk_ArshaOpen
  elseif 3 == tipType then
    if 0 == isMatchType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_ROUNDTYPE_ROUND_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_ROUNDTYPE_ROUND_DESC")
    elseif 1 == isMatchType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_ROUNDTYPE_FREE_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_ROUNDTYPE_FREE_DESC")
    end
    control = self.btn_RoundCount
  elseif 4 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_LIMITTIME_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_LIMITTIME_DESC")
    control = self.btn_LimitTime
  elseif 5 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_LIMITLEVEL_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_LIMITLEVEL_DESC")
    control = self.btn_LimitLevel
  elseif 6 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_LIMITMEMBER_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_LIMITMEMBER_DESC")
    control = self.btn_PartyMemberLimit
  elseif 7 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_WATCHINVITE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_WATCHINVITE_DESC")
    control = self.chk_WatchMemberInvite
  elseif 9 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_RESURRECTION_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_RESURRECTION_DESC")
    control = self.btn_AllResurrection
  elseif 10 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_INVITELIST_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_INVITELIST_DESC")
    control = self.btn_InviteList
  elseif 11 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_GAMESTART_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_GAMESTART_DESC")
    control = self.btn_GameStart
  elseif 12 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_GAMESTOP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_GAMESTOP_DESC")
    control = self.btn_GameStop
  elseif 13 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_EXIT_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_EXIT_DESC")
    control = self.btn_Exit
  elseif 14 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_WAIT_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_WAIT_DESC")
    control = self.rdo_SelectWait
  elseif 15 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_WATCH_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SIMPLETOOLTIP_WATCH_DESC")
    control = self.rdo_SelectWatch
  end
  TooltipSimple_Show(control, name, desc)
end
function FGlobal_ArshaPvP_HostJoin()
  ToClient_RequestEnterCompetitionHost()
end
function FGlobal_ArshaPvP_Open()
  if false == ToClient_IsGrowStepOpen(__eGrowStep_arsha) then
    return
  end
  local self = arshaPvP
  local isHost = ToClient_IsCompetitionHost()
  local isSubHost = ToClient_IsCompetitionAssistant()
  FromClient_UpdateTeamUserList()
  ArshaPvP_RefreshUpdate()
  ArshaPvP_SubMenu_ButtonPosition()
  self.rdo_RoundMode:SetIgnore(false)
  self.rdo_FreeMode:SetIgnore(false)
  self.chk_ArshaOpen:SetIgnore(false)
  self.txt_RoundCount:SetIgnore(false)
  self.btn_RoundCount:SetIgnore(false)
  self.txt_LimitMinute:SetIgnore(false)
  self.txt_LimitSecond:SetIgnore(false)
  self.btn_LimitTime:SetIgnore(false)
  self.txt_LimitLevel:SetIgnore(false)
  self.btn_LimitLevel:SetIgnore(false)
  self.txt_PartyMemberLimitCount:SetIgnore(false)
  self.btn_PartyMemberLimit:SetIgnore(false)
  self.chk_WatchMemberInvite:SetIgnore(false)
  self.rdo_RoundMode:SetMonoTone(false)
  self.rdo_FreeMode:SetMonoTone(false)
  self.chk_ArshaOpen:SetMonoTone(false)
  self.txt_RoundCount:SetMonoTone(false)
  self.btn_RoundCount:SetMonoTone(false)
  self.txt_LimitMinute:SetMonoTone(false)
  self.txt_LimitSecond:SetMonoTone(false)
  self.btn_LimitTime:SetMonoTone(false)
  self.txt_LimitLevel:SetMonoTone(false)
  self.btn_LimitLevel:SetMonoTone(false)
  self.txt_PartyMemberLimitCount:SetMonoTone(false)
  self.btn_PartyMemberLimit:SetMonoTone(false)
  self.chk_WatchMemberInvite:SetMonoTone(false)
  if isHost then
    self.arshaManagementTitle:SetShow(true)
    self.img_NotAdmin:SetShow(false)
  elseif isSubHost then
    self.arshaManagementTitle:SetShow(true)
    self.img_NotAdmin:SetShow(false)
    self.rdo_RoundMode:SetIgnore(true)
    self.rdo_FreeMode:SetIgnore(true)
    self.chk_ArshaOpen:SetIgnore(true)
    self.txt_RoundCount:SetIgnore(true)
    self.btn_RoundCount:SetIgnore(true)
    self.txt_LimitMinute:SetIgnore(true)
    self.txt_LimitSecond:SetIgnore(true)
    self.btn_LimitTime:SetIgnore(true)
    self.txt_LimitLevel:SetIgnore(true)
    self.btn_LimitLevel:SetIgnore(true)
    self.txt_PartyMemberLimitCount:SetIgnore(true)
    self.btn_PartyMemberLimit:SetIgnore(true)
    self.rdo_RoundMode:SetMonoTone(true)
    self.rdo_FreeMode:SetMonoTone(true)
    self.chk_ArshaOpen:SetMonoTone(true)
    self.txt_RoundCount:SetMonoTone(true)
    self.btn_RoundCount:SetMonoTone(true)
    self.txt_LimitMinute:SetMonoTone(true)
    self.txt_LimitSecond:SetMonoTone(true)
    self.btn_LimitTime:SetMonoTone(true)
    self.txt_LimitLevel:SetMonoTone(true)
    self.btn_LimitLevel:SetMonoTone(true)
    self.txt_PartyMemberLimitCount:SetMonoTone(true)
    self.btn_PartyMemberLimit:SetMonoTone(true)
  else
    self.arshaManagementTitle:SetShow(false)
    self.img_NotAdmin:SetShow(true)
    self.btn_Kick_A:SetShow(false)
    self.btn_Kick_B:SetShow(false)
    self.btn_GoA:SetSize(370, 35)
    self.btn_GoB:SetSize(370, 35)
  end
  self.rdo_SelectWait:SetCheck(true)
  self.rdo_SelectWatch:SetCheck(false)
  local matchMode = ToClient_CompetitionMatchType()
  local isLimitSecondTime = ToClient_CompetitionMatchTimeLimit()
  local matchMode = ToClient_CompetitionMatchType()
  local targetScore = ToClient_GetTargetScore()
  local limitSecondTime = 0
  if isLimitSecondTime >= 60 then
    limitMinuteTime = math.floor(isLimitSecondTime / 60)
    limitSecondTime = math.ceil(isLimitSecondTime % 60)
  else
    limitSecondTime = isLimitSecondTime
  end
  if 0 == matchMode then
    local roundCount = targetScore * 2 - 1
    self.descBG:SetText(PAGetStringParam4(Defines.StringSheet_GAME, "LUA_ARSHA_USER_DESC_GAMEPROGRESSES_ROUND", "limitTimeSum", limitMinuteTime, "level", levellimit, "round", roundCount, "targetScore", targetScore))
    self.txt_RoundMarkCount:SetText(tostring(roundCount))
    self.txt_RoundCountTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_ROUNDOFWIN_TITLE"))
    self.txt_RoundMarkText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ARSHA_USER_OPTION_ROUND_FORCOUNT", "targetScore", targetScore))
    self.txt_LimitMinute:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", limitMinuteTime))
    self.txt_LimitLevel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WINDOW_ARSHA_LEVELLIMIT", "level", levellimit))
    if isHost or isSubHost then
      self.btn_Kick_A:SetShow(true)
      self.btn_Kick_B:SetShow(true)
    else
      self.btn_Kick_A:SetShow(false)
      self.btn_Kick_B:SetShow(false)
      self.btn_GoA:SetSize(370, 35)
      self.btn_GoB:SetSize(370, 35)
    end
  elseif 1 == matchMode then
    self.descBG:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_ARSHA_USER_DESC_GAMEPROGRESSES_FREE", "limitTimeSum", limitMinuteTime, "level", levellimit, "targetScore", targetScore))
    self.txt_FreeMarkCount:SetText(tostring(targetScore))
    self.txt_RoundCountTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_ROUNDOFALIVE_TITLE"))
    self.txt_FreeMarkText:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_ALIVEMODE_TITLE"))
    self.btn_Kick_A:SetShow(false)
    self.btn_Kick_B:SetShow(false)
    self.txt_LimitMinute:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", limitMinuteTime))
    self.txt_LimitLevel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WINDOW_ARSHA_LEVELLIMIT", "level", levellimit))
  elseif 2 == matchMode then
    self.descBG:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_ARSHA_USER_DESC_GAMEPROGRESSES_PERSONAL", "limitTimeSum", limitMinuteTime, "level", levellimit))
    local currentRound = ToClient_GetCurrentRound()
    if currentRound <= 0 then
      currentRound = 1
    end
    self.txt_personalCurrentRound:SetText(tostring(currentRound))
    self.txt_personalMatchText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_PERSONALMODE"))
    self.btn_Kick_A:SetShow(false)
    self.btn_Kick_B:SetShow(false)
    self.txt_LimitMinute:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", limitMinuteTime))
    self.txt_LimitLevel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WINDOW_ARSHA_LEVELLIMIT", "level", levellimit))
  end
  self.descBG:SetSize(self.descBG:GetSizeX(), self.descBG:GetTextSizeY() + 10)
  self.descBG:ComputePos()
  self.txt_RoundCount:SetText(targetScore)
  self.txt_LimitSecond:SetText(limitSecondTime)
  self.txt_LimitLevel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WINDOW_ARSHA_LEVELLIMIT", "level", levellimit))
  self.txt_PartyMemberLimitCount:SetText(ToClient_GetMaxPartyMemberCount())
  self.txt_LimitMinute:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", limitMinuteTime))
  Panel_Window_Arsha:SetShow(true)
end
function FGlobal_ArshaPvP_Close()
  Panel_Window_Arsha:SetShow(false)
  Panel_Window_Arsha:CloseUISubApp()
  checkPopUp:SetCheck(false)
  ArshaPvP_SubMenu_PowerOff()
end
function ArshaPvP_Team_Kick(teamNo, isMode)
  if nil == teamNo then
    return
  end
  if 0 == teamNo then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_ALLKICK_NOWAITMEMBERKICK"))
    return
  end
  local self = arshaPvP
  if 1 == isMode then
    local userinfo = ToClient_GetCompetitionDefinedUser(teamNo)
    teamNo = userinfo:getTeamNo()
  end
  local function KickTeamAll()
    ToClient_RequestLeaveTeam(teamNo)
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_ALLKICK_EXECUTE")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = KickTeamAll,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function Team_NameChangeOpen()
  FGlobal_TeamNameChangeControl_Open()
end
function PaGlobal_Panel_Arsha_PopUp()
  if checkPopUp:IsCheck() then
    Panel_Window_Arsha:OpenUISubApp()
  else
    Panel_Window_Arsha:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function PaGlobal_Panel_Arsha_ShowIconToolTip(isShow)
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
    local desc = ""
    if checkPopUp:IsCheck() then
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_CHECK_TOOLTIP")
    else
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_NOCHECK_TOOLTIP")
    end
    TooltipSimple_Show(checkPopUp, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function FromClient_UpdateTeamUserList()
  if CppEnums.CompetitionMatchType.eCompetitionMatchMode_Round == ToClient_CompetitionMatchType() then
    ArshaPvP_SelectedUpdate_Round()
  elseif CppEnums.CompetitionMatchType.eCompetitionMatchMode_FreeForAll == ToClient_CompetitionMatchType() then
    ArshaPvP_SelectedUpdate_FreeForAll()
  elseif CppEnums.CompetitionMatchType.eCompetitionMatchMode_Personal == ToClient_CompetitionMatchType() then
    ArshaPvP_SelectedUpdate_PersonalMatch()
  end
  ArshaPvP_RefreshUpdate()
  HandleClicked_ArshaPvP_WaitAndWatch()
end
function FromClient_ChangeMatchType()
  local self = arshaPvP
  if not Panel_Window_Arsha:GetShow() then
    return
  end
  FromClient_UpdateTeamUserList()
  HandleClicked_ArshaPvP_ChangeOption()
end
function FromClient_UpdateTeamScore(teamNum, scoreValue, round, winTeamHP, loseTeamHP)
  if 0 == teamNum then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAMSCORE_DRAW", "currentRound", round))
  else
    local matchMode = ToClient_CompetitionMatchType()
    local teamA_Info = ToClient_GetTeamListAt(0)
    local teamB_Info = ToClient_GetTeamListAt(1)
    local teamA_Name = ""
    local teamB_Name = ""
    if nil ~= teamA_Info and nil ~= teamB_Info then
      teamA_Name = teamA_Info:getTeamName()
      teamB_Name = teamB_Info:getTeamName()
    end
    if "" == teamA_Name or "" == teamB_Name then
      teamA_Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_A")
      teamB_Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_B")
    end
    local teamWinString = teamB_Name
    local teamLoseString = teamA_Name
    if 1 == teamNum then
      teamWinString = teamA_Name
      teamLoseString = teamB_Name
    end
    if 0 == matchMode then
      Proc_ShowMessage_Ack(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAMSCORE", "currentRound", round, "teamNo", teamWinString, "score", scoreValue))
    elseif 1 == matchMode then
      local leaderInfo = ToClient_GetTeamLeaderInfo(teamNum)
      Proc_ShowMessage_Ack(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAMSCORE", "currentRound", round, "teamNo", leaderInfo:getCharacterName(), "score", scoreValue))
    elseif 2 == matchMode then
      Proc_ShowMessage_Ack(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAMSCORE", "currentRound", round, "teamNo", teamWinString, "score", scoreValue))
    end
    Proc_ShowMessage_Ack(PAGetStringParam4(Defines.StringSheet_GAME, "LUA_ARSHA_TEAMWIN_PERCENT_HP", "teamNameA", teamWinString, "hpA", winTeamHP, "teamNameB", teamLoseString, "hpB", loseTeamHP))
  end
end
function FromClient_CompetitionMatchDone(teamNo, rank, teamHpPercent)
  if 0 == teamNo then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_MATCH_DONE_DRAW", "teamNo", teamNo))
    return
  end
  _PA_LOG("HP", tostring(teamHpPercent))
  local matchMode = ToClient_CompetitionMatchType()
  if 0 == matchMode then
    local teamA_Info = ToClient_GetTeamListAt(0)
    local teamB_Info = ToClient_GetTeamListAt(1)
    local teamA_Name = ""
    local teamB_Name = ""
    if nil ~= teamA_Info and nil ~= teamB_Info then
      teamA_Name = teamA_Info:getTeamName()
      teamB_Name = teamB_Info:getTeamName()
    end
    if "" == teamA_Name or "" == teamB_Name then
      teamA_Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_A")
      teamB_Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_B")
    end
    local winTeamName = teamB_Name
    if 1 == teamNo then
      winTeamName = teamA_Name
    end
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_MATCH_DONE", "teamNo", winTeamName))
  elseif 1 == matchMode then
    local leaderInfo = ToClient_GetTeamLeaderInfo(teamNo)
    if nil ~= leaderInfo then
      Proc_ShowMessage_Ack(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_COMPETITION_MATCH_DONE_FREEFORALL", "rank", rank, "hpPercent", tostring(teamHpPercent), "leaderName", leaderInfo:getCharacterName()))
    end
  elseif 2 == matchMode then
    local teamA_Info = ToClient_GetArshaTeamInfo(1)
    local teamB_Info = ToClient_GetArshaTeamInfo(2)
    local teamA_Name = ""
    local teamB_Name = ""
    if nil ~= teamA_Info and nil ~= teamB_Info then
      teamA_Name = teamA_Info:getTeamName()
      teamB_Name = teamB_Info:getTeamName()
    end
    if "" == teamA_Name or "" == teamB_Name then
      teamA_Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_A")
      teamB_Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_B")
    end
    local winTeamName = teamB_Name
    if 1 == teamNo then
      winTeamName = teamA_Name
    end
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_MATCH_DONE", "teamNo", winTeamName))
  end
end
function FromClient_CompetitionMatchDoneToObserver(winteamno, matchResult)
  if __eCompetitionResult_Draw == matchResult then
    msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_DRAW_MAIN"),
      sub = "",
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 46, false)
  else
    local teamA_Info = ToClient_GetArshaTeamInfo(1)
    local teamB_Info = ToClient_GetArshaTeamInfo(2)
    local teamA_Name = ""
    local teamB_Name = ""
    if nil ~= teamA_Info and nil ~= teamB_Info then
      teamA_Name = teamA_Info:getTeamName()
      teamB_Name = teamB_Info:getTeamName()
    end
    if "" == teamA_Name or "" == teamB_Name then
      teamA_Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_A")
      teamB_Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_B")
    end
    local winTeamName = teamB_Name
    if 1 == winteamno then
      winTeamName = teamA_Name
    end
    msg = {
      main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_MATCH_DONE", "teamNo", winTeamName),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_FIGHTSTATE_STOP_MAIN"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 45, false)
  end
end
function FromClient_JoinNewPlayer(characterName, isEntryUser)
  if isEntryUser then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_JOINNEWPLAYER_ENTRY", "characterName", characterName))
  else
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_JOINNEWPLAYER_OBSERVER", "characterName", characterName))
  end
end
function FromClient_KillHistory(deadUserInfo, attackerUserInfo)
  if nil == attackerUserInfo then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_USERDEAD_SELF", "characterName", deadUserInfo:getCharacterName()))
  else
    Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_COMPETITION_USERDEAD_ATTACKED", "attackerName", attackerUserInfo:getCharacterName(), "deadUserName", deadUserInfo:getCharacterName()))
  end
end
function FromClient_EntryUserChangeTeam(userInfo)
  local matchMode = ToClient_CompetitionMatchType()
  if 1 == matchMode or nil == userInfo then
    return
  end
  local message = ""
  local teamNo = userInfo:getTeamNo()
  if 0 == teamNo then
    message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_CHANGE_TO_WAITING", "playerName", userInfo:getCharacterName())
  else
    local teamInfo = ToClient_GetArshaTeamInfo(teamNo)
    local teamName = ""
    if nil ~= teamInfo then
      teamName = teamInfo:getTeamName()
    end
    if "" == teamName then
      if 1 == teamNo then
        teamName = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_A")
      elseif 2 == teamNo then
        teamName = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_B")
      end
    end
    message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_COMPETITION_USER_CHANGETEAM", "characterName", userInfo:getCharacterName(), "teamNo", teamName)
  end
  chatting_sendMessage("", message, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
end
function FromClient_GetOutUserFromCompetition(outUserInfo)
  if nil == outUserInfo then
    return
  end
  if true == outUserInfo:isHost() then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_GAMEHOST_LEAVE", "characterName", outUserInfo:getCharacterName()))
  else
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GETOUT_FROM_COMPETITION", "characterName", outUserInfo:getCharacterName()))
  end
end
function FromClient_ChangeAssistant(userInfo)
end
function FromClient_CompetitionOptionChanged(isOpen, matchTimeLimit, targetScore, levelLimit, maxPartyMemberCount, maxWaitTime)
  local self = arshaPvP
  self.chk_ArshaOpen:SetCheck(isOpen)
  self._isOpen = isOpen
  self._targetScore = targetScore
  self._levelLimit = levelLimit
  self._maxPartyMemberCount = maxPartyMemberCount
  self._maxWaitTime = maxWaitTime
  local isLimitSecondTime = matchTimeLimit
  local matchMode = ToClient_CompetitionMatchType()
  local isHost = ToClient_IsCompetitionHost()
  local limitMinuteTime = 0
  local limitSecondTime = 0
  if isLimitSecondTime >= 60 then
    limitMinuteTime = math.floor(isLimitSecondTime / 60)
    limitSecondTime = math.ceil(isLimitSecondTime % 60)
  else
    limitSecondTime = isLimitSecondTime
  end
  if 0 == matchMode then
    local roundCount = targetScore * 2 - 1
    self.descBG:SetText(PAGetStringParam4(Defines.StringSheet_GAME, "LUA_ARSHA_USER_DESC_GAMEPROGRESSES_ROUND", "limitTimeSum", limitMinuteTime, "level", levellimit, "round", roundCount, "targetScore", targetScore))
    self.txt_RoundMarkCount:SetText(roundCount)
    self.txt_RoundMarkText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ARSHA_USER_OPTION_ROUND_FORCOUNT", "targetScore", targetScore))
  elseif 1 == matchMode then
    self.descBG:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_ARSHA_USER_DESC_GAMEPROGRESSES_FREE", "limitTimeSum", limitMinuteTime, "level", levellimit, "targetScore", targetScore))
    self.txt_FreeMarkCount:SetText(targetScore)
    self.txt_RoundCount:SetText(targetScore)
  elseif 2 == matchMode then
    self.descBG:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ARSHA_USER_DESC_GAMEPROGRESSES_PERSONAL", "limitTimeSum", limitMinuteTime, "level", levellimit))
    local currentRound = ToClient_GetCurrentRound()
    if currentRound <= 0 then
      currentRound = 1
    end
    self.txt_personalCurrentRound:SetText(tostring(currentRound))
    self.txt_personalMatchText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_PERSONALMODE"))
  end
  self.descBG:SetSize(self.descBG:GetSizeX(), self.descBG:GetTextSizeY() + 10)
  self.descBG:ComputePos()
  if isHost then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_SETTING_GAME_ACK"))
  end
  HandleClicked_ArshaPvP_ChangeOption()
  ArshaPvP_Widget_Update()
end
function FromClient_NotifyUseSkill(userName, skillName)
  local message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ARSHA_NOTIFYUSESKILL_MESSAGE", "userName", userName, "skillName", skillName)
  chatting_sendMessage("", message, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
end
function FromClient_CompetitionUseItemModeChanged(isCanUseItemMode)
  if true == isCanUseItemMode then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_CHANGED_CANUSEITEMMODE"))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_CHANGED_CANNOTUSEITEMMODE"))
  end
end
function FromClient_ChangeTeamName()
  if CppEnums.CompetitionMatchType.eCompetitionMatchMode_Round == ToClient_CompetitionMatchType() then
    ArshaPvP_SelectedUpdate_Round()
  elseif CppEnums.CompetitionMatchType.eCompetitionMatchMode_Personal == ToClient_CompetitionMatchType() then
    ArshaPvP_SelectedUpdate_PersonalMatch()
  end
  ArshaPvP_Widget_Init()
  ArshaPvP_Widget_Update()
end
function getArshaPvpOption()
  local self = arshaPvP
  local option = {}
  option._isOpen = self._isOpen
  option._timeLimit = self._timeLimit
  ToClient_LuaDebugCallStack()
  option._targetScore = self._targetScore
  option._levelLimit = self._levelLimit
  option._maxPartyMemberCount = self._maxPartyMemberCount
  option._maxWaitTime = self._maxWaitTim
  return option
end
function ArshaDebuff(isOn)
  ToClient_ArshaDebuffOnOff(isOn)
end
registerEvent("FromClient_luaLoadComplete", "ArshaPvP_init")

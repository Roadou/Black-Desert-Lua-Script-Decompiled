Panel_Arsha_SelectMember = {
  _ui = {
    _btn_WinClose = UI.getChildControl(Panel_Window_ArshaSelectMember, "Button_Win_Close"),
    _staticText_Title = UI.getChildControl(Panel_Window_ArshaSelectMember, "StaticText_Title"),
    _static_Bg = UI.getChildControl(Panel_Window_ArshaSelectMember, "Static_Bg"),
    _static_BottomBg = UI.getChildControl(Panel_Window_ArshaSelectMember, "Static_BottomBg")
  },
  _attendUserNoTemp = toInt64(-1, -1)
}
local EnableControl = function(target, isEnable)
  if true == isEnable then
    target:SetEnable(true)
    target:SetMonoTone(false)
    target:SetIgnore(false)
  else
    target:SetEnable(false)
    target:SetMonoTone(true)
    target:SetIgnore(true)
  end
end
local EnableText = function(targetText, isEnable)
  if true == isEnable then
    targetText:SetFontAlpha(1)
  else
    targetText:SetFontAlpha(0.65)
  end
end
function CreateListContent_Arsha_AttendMember(content, userIdx)
  local myTeamNo = ToClient_GetMyTeamNo()
  local teamInfo = ToClient_GetArshaTeamInfo(myTeamNo)
  if nil == teamInfo then
    return
  end
  local userInfo = ToClient_GetTeamUserInfoAt(myTeamNo, Int64toInt32(userIdx))
  if nil == userInfo then
    return
  end
  local isAttendSet = ToClient_IsMyTeamAttendSetted()
  local isDead = userInfo:isDeadInPersonalMatch()
  local selectedUserInfo = ToClient_GetEntryInfoByUserNo(Panel_Arsha_SelectMember._attendUserNoTemp)
  local userNo = userInfo:getUserNo()
  local selectedUserNo = -1
  if nil ~= selectedUserInfo then
    selectedUserNo = selectedUserInfo:getUserNo()
  end
  local checkBtn_AsAttend = UI.getChildControl(content, "CheckButton_SelectAttend")
  local static_ClassIcon = UI.getChildControl(content, "Static_ClassIcon")
  local staticText_Level = UI.getChildControl(content, "StaticText_Level")
  local staticText_Name = UI.getChildControl(content, "StaticText_CharacterName")
  local staticText_State = UI.getChildControl(content, "StaticText_State")
  local staticTeamMasterIcon = UI.getChildControl(content, "Static_TeamMasterIcon")
  local classSymbomInfo = CppEnums.ClassType_Symbol[userInfo:getCharacterClass()]
  static_ClassIcon:ChangeTextureInfoName(classSymbomInfo[1])
  local x1, y1, x2, y2 = setTextureUV_Func(static_ClassIcon, classSymbomInfo[2], classSymbomInfo[3], classSymbomInfo[4], classSymbomInfo[5])
  static_ClassIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  static_ClassIcon:setRenderTexture(static_ClassIcon:getBaseTexture())
  staticText_Name:SetText(userInfo:getCharacterName())
  staticText_Level:SetText(tostring(userInfo:getCharacterLevel()))
  local isEnable = true
  if true == isAttendSet then
    _PA_LOG("\236\149\132\235\165\180\236\131\164\236\157\152\236\176\189", "selected:" .. Int64toInt32(Panel_Arsha_SelectMember._attendUserNoTemp) .. " vs userNo:" .. Int64toInt32(userNo))
    EnableControl(checkBtn_AsAttend, false)
    checkBtn_AsAttend:SetCheck(selectedUserNo == userNo)
    if selectedUserNo == userNo then
      staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_ENTRYSTATUS_FIGHTING"))
    elseif true == userInfo:isDeadInPersonalMatch() then
      staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_ENTRYSTATUS_DEFEATTED"))
    else
      staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_ENTRYSTATUS_WAITING"))
    end
  else
    EnableControl(checkBtn_AsAttend, true)
    checkBtn_AsAttend:SetShow(true)
    if true == userInfo:isDeadInPersonalMatch() then
      staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_ENTRYSTATUS_DEFEATTED"))
      checkBtn_AsAttend:SetShow(false)
    else
      staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_ENTRYSTATUS_WAITING"))
      if nil == selectedUserInfo then
        checkBtn_AsAttend:SetCheck(false)
      else
        checkBtn_AsAttend:SetCheck(selectedUserNo == userNo)
      end
    end
    checkBtn_AsAttend:addInputEvent("Mouse_LUp", "Panel_Arsha_SelectMember:SetAttendMemberTemp(" .. Int64toInt32(userIdx) .. ")")
  end
  staticTeamMasterIcon:SetShow(false)
  if false == ToClient_Arsha_IsMySelfTeamMaster() then
    checkBtn_AsAttend:SetShow(false)
    if userNo == teamInfo:getTeamMaster() then
      staticTeamMasterIcon:SetShow(true)
    end
  end
end
function Panel_Arsha_SelectMember:OpenPanel()
  _PA_LOG("\236\149\132\235\165\180\236\131\164\236\157\152\236\176\189", "Panel_Arsha_SelectMember:Show")
  Panel_Window_ArshaSelectMember:SetShow(true)
  Panel_Window_ArshaSelectMember:SetPosXY(200, 200)
  self:UpdateMemberList()
end
function Panel_Arsha_SelectMember:ClosePanel()
  Panel_Window_ArshaSelectMember:SetShow(false)
end
function Panel_Arsha_SelectMember:Initialize()
  local ui = self._ui
  ui._staticText_Line = UI.getChildControl(ui._static_Bg, "StaticText_Line")
  ui._staticText_CheckTitle = UI.getChildControl(ui._static_Bg, "StaticText_CheckTitle")
  ui._staticText_ClassTitle = UI.getChildControl(ui._static_Bg, "StaticText_ClassTitle")
  ui._staticText_LevelTitle = UI.getChildControl(ui._static_Bg, "StaticText_LevelTitle")
  ui._staticText_NameTitle = UI.getChildControl(ui._static_Bg, "StaticText_NameTitle")
  ui._staticText_StateTitle = UI.getChildControl(ui._static_Bg, "StaticText_StateTitle")
  ui._list_entryMembers = UI.getChildControl(ui._static_Bg, "List2_Member")
  ui._btn_ConfirmAttend = UI.getChildControl(ui._static_BottomBg, "Button_Adjust")
  ui._staticText_OurTeamState = UI.getChildControl(ui._static_BottomBg, "StaticText_OurTeamState")
  ui._btn_ConfirmAttend:addInputEvent("Mouse_LUp", "Panel_Arsha_SelectMember:ConfirmAttendMember()")
  ui._list_entryMembers:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "CreateListContent_Arsha_AttendMember")
  ui._list_entryMembers:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  if CppEnums.CompetitionMatchType.eCompetitionMatchMode_Personal == ToClient_CompetitionMatchType() and CppEnums.CompetitionFightState.eCompetitionFightState_SelectAttend == ToClient_CompetitionFightState() then
    Panel_Arsha_SelectMember:OpenPanel()
  end
end
function Panel_Arsha_SelectMember:UpdateMemberList()
  local ui = self._ui
  local myTeamNo = ToClient_GetMyTeamNo()
  if true == ToClient_Arsha_IsMySelfTeamMaster() then
    ui._btn_ConfirmAttend:SetShow(true)
  else
    ui._btn_ConfirmAttend:SetShow(false)
  end
  local isAttendSetted = ToClient_IsMyTeamAttendSetted()
  if true == isAttendSetted then
    local attendUserInfo = ToClient_GetArshaAttendUserInfo(myTeamNo)
    if nil == attendUserInfo then
      return
    end
    Panel_Arsha_SelectMember._attendUserNoTemp = attendUserInfo:getUserNo()
    EnableControl(ui._btn_ConfirmAttend, false)
  else
    EnableControl(ui._btn_ConfirmAttend, true)
  end
  local ListTeamACount = ToClient_GetTeamUserInfoCount(myTeamNo)
  ui._list_entryMembers:getElementManager():clearKey()
  if ListTeamACount > 0 then
    for idx = 0, ListTeamACount - 1 do
      ui._list_entryMembers:getElementManager():pushKey(idx)
    end
  end
  if true == isAttendSetted then
    ui._staticText_OurTeamState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_WAITING_OTHERATTEND"))
  elseif true == ToClient_Arsha_IsMySelfTeamMaster() then
    ui._staticText_OurTeamState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_SELECT_AND_CONFIRM"))
  else
    ui._staticText_OurTeamState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_SELECTING_OURATTEND"))
  end
end
function Panel_Arsha_SelectMember:SetAttendMemberTemp(userIdx)
  local myTeamNo = ToClient_GetMyTeamNo()
  local teamInfo = ToClient_GetArshaTeamInfo(myTeamNo)
  if nil == teamInfo then
    return
  end
  local userInfo = ToClient_GetTeamUserInfoAt(myTeamNo, userIdx)
  if nil == userInfo then
    return
  end
  local userNo = userInfo:getUserNo()
  _PA_LOG("\236\149\132\235\165\180\236\131\164\236\157\152\236\176\189", "SetAttendMemberTemp = " .. Int64toInt32(userNo))
  Panel_Arsha_SelectMember._attendUserNoTemp = userNo
  self:UpdateMemberList()
end
function Panel_Arsha_SelectMember:ConfirmAttendMember()
  local myTeamNo = ToClient_GetMyTeamNo()
  ToClient_SelectPersonalMatchAttend(self._attendUserNoTemp, myTeamNo)
end
function Panel_Arsha_SelectMember:Clear()
  self._attendUserNoTemp = toInt64(-1, -1)
end
function FromClient_SelectAttendTimeAlert(second)
  local msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ARSHA_SELECTATTEND_TIMEALERT", "sec", second)
  if nil ~= msg and "" ~= msg then
    Proc_ShowMessage_Ack(msg)
  end
end
function FromClient_PersonalMatchAttendSetted(userNo, teamNo)
  local teamInfo = ToClient_GetArshaTeamInfo(teamNo)
  if nil == teamInfo then
    return
  end
  local entryInfo = ToClient_GetEntryInfoByUserNo(userNo)
  if nil == entryInfo then
    return
  end
  local teamName = ""
  teamName = teamInfo:getTeamName()
  if "" == teamName then
    if 1 == teamNo then
      teamName = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_A")
    else
      teamName = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_B")
    end
  end
  local msg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ARSHA_TEAMATTEND_SELECTED", "playerName", entryInfo:getCharacterName(), "teamName", teamName)
  if nil ~= msg and "" ~= msg then
    Proc_ShowMessage_Ack(msg)
  end
end
function FromClient_PersonalMatchMasterSetted(userNo, teamNo, isAutoSelected)
  local teamInfo = ToClient_GetArshaTeamInfo(teamNo)
  if nil == teamInfo then
    return
  end
  local entryInfo = ToClient_GetEntryInfoByUserNo(userNo)
  if nil == entryInfo then
    return
  end
  local teamName = ""
  teamName = teamInfo:getTeamName()
  if "" == teamName then
    if 1 == teamNo then
      teamName = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_A")
    else
      teamName = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_B")
    end
  end
  local msg = ""
  if true == isAutoSelected then
    msg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAMMASTER_CHANGED", "teamName", teamName, "playerName", entryInfo:getCharacterName())
  else
    msg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ARSHA_TEAMMASTER_SELECTED", "playerName", entryInfo:getCharacterName(), "teamName", teamName)
  end
  if nil ~= msg and "" ~= msg then
    Proc_ShowMessage_Ack(msg)
  end
  local selfPlayer = getSelfPlayer()
  local fightState = ToClient_CompetitionFightState()
  if nil ~= selfPlayer and selfPlayer:get():getUserNo() == userNo and CppEnums.CompetitionFightState.eCompetitionFightState_SelectAttend == fightState then
    Panel_Arsha_SelectMember:OpenPanel()
  end
  FromClient_UpdateTeamUserList()
end
function FromClient_luaLoadComplete_Arsha_SelectMemeber()
  Panel_Arsha_SelectMember:Initialize()
end
function FromClient_ArshaMyAttendSetResult(isSuccess, userNo)
  if true == isSuccess then
    Panel_Arsha_SelectMember._attendUserNoTemp = userNo
  else
    Panel_Arsha_SelectMember._attendUserNoTemp = toInt64(-1, -1)
  end
  Panel_Arsha_SelectMember:UpdateMemberList()
end
function FromClient_ResetArshaSelectAttendUI()
  Panel_Arsha_SelectMember._attendUserNoTemp = toInt64(-1, -1)
end
function FromClient_ArshaTeamAttendOut_ResetSelectMemberUI(teamNo)
  local myTeamNo = ToClient_GetMyTeamNo()
  if myTeamNo == teamNo then
    local msg = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_MYTEAM_ATTEND_ESCAPED")
    if nil ~= msg and "" ~= msg then
      Proc_ShowMessage_Ack(msg)
    end
    msg = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_RESELECT_ATTEND")
    if nil ~= msg and "" ~= msg then
      Proc_ShowMessage_Ack(msg)
    end
    Panel_Arsha_SelectMember._attendUserNoTemp = toInt64(-1, -1)
    Panel_Arsha_SelectMember:UpdateMemberList()
  else
    local msg = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_OTHERTEAM_ATTEND_ESCAPED")
    if msg ~= nil and msg ~= "" then
      Proc_ShowMessage_Ack(msg)
    end
  end
end
function FromClient_UpdateEntryList_UpdateMember()
  Panel_Arsha_SelectMember:UpdateMemberList()
end
function FromClient_UpdateTeamScore_ClearLoseTeam(teamNum, scoreValue, round, winTeamHP, loseTeamHP)
  if 0 == teamNum then
    Panel_Arsha_SelectMember:Clear()
  elseif ToClient_GetMyTeamNo() ~= teamNum then
    Panel_Arsha_SelectMember:Clear()
  end
end
registerEvent("FromClient_SelectAttendTimeAlert", "FromClient_SelectAttendTimeAlert")
registerEvent("FromClient_PersonalMatchAttendSetted", "FromClient_PersonalMatchAttendSetted")
registerEvent("FromClient_PersonalMatchMasterSetted", "FromClient_PersonalMatchMasterSetted")
registerEvent("FromClient_ArshaMyAttendSetResult", "FromClient_ArshaMyAttendSetResult")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Arsha_SelectMemeber")
registerEvent("FromClient_FirstMatchStart", "FromClient_ResetArshaSelectAttendUI")
registerEvent("FromClient_ArshaTeamAttendOut", "FromClient_ArshaTeamAttendOut_ResetSelectMemberUI")
registerEvent("FromClient_UpdateEntryList", "FromClient_UpdateEntryList_UpdateMember")
registerEvent("FromClient_UpdateTeamScore", "FromClient_UpdateTeamScore_ClearLoseTeam")

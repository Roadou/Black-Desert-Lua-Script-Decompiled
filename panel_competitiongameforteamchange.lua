local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
Panel_CompetitionGameForTeamChange:SetShow(false)
local competitionGameForTeamChange = {
  _list_TeamA = UI.getChildControl(Panel_CompetitionGameForTeamChange, "List2_CompetitionGameTeamA"),
  _list_TeamB = UI.getChildControl(Panel_CompetitionGameForTeamChange, "List2_CompetitionGameTeamB"),
  _list_Entry = UI.getChildControl(Panel_CompetitionGameForTeamChange, "List2_CompetitionGameWait"),
  _list_Observer = UI.getChildControl(Panel_CompetitionGameForTeamChange, "List2_CompetitionGameObserver"),
  _btn_TeamA = UI.getChildControl(Panel_CompetitionGameForTeamChange, "Button_SetTeamA"),
  _btn_TeamB = UI.getChildControl(Panel_CompetitionGameForTeamChange, "Button_SetTeamB"),
  _btn_TeamWait = UI.getChildControl(Panel_CompetitionGameForTeamChange, "Button_SetTeamWait"),
  _btn_TeamObserver = UI.getChildControl(Panel_CompetitionGameForTeamChange, "Button_SetTeamObserver"),
  _btn_leaveCompetition = UI.getChildControl(Panel_CompetitionGameForTeamChange, "Button_LeaveCompetitionSelf"),
  _btn_Close = UI.getChildControl(Panel_CompetitionGameForTeamChange, "Button_Close"),
  _btn_ForHost = UI.getChildControl(Panel_CompetitionGameForTeamChange, "Button_ForHost"),
  _txt_Timer = UI.getChildControl(Panel_CompetitionGameForTeamChange, "StaticText_Timer"),
  _txt_TeamA = UI.getChildControl(Panel_CompetitionGameForTeamChange, "StaticText_TeamA"),
  _txt_TeamB = UI.getChildControl(Panel_CompetitionGameForTeamChange, "StaticText_TeamB")
}
function FGlobal_CompetitionGameForTeamChange_Open()
  local self = competitionGameForTeamChange
  FromClient_UpdateTeamUserList()
  HandleChangeOption_ForTeamChange()
  if ToClient_IsCompetitionHost() or ToClient_IsCompetitionAssistant() then
    self._btn_ForHost:SetShow(true)
  else
    self._btn_ForHost:SetShow(false)
  end
  local matchMode = ToClient_CompetitionMatchType()
  local isCanChangeTeam = ToClient_IsMyselfInEntryUser() and 0 == matchMode
  self._btn_TeamA:SetShow(isCanChangeTeam)
  self._btn_TeamB:SetShow(isCanChangeTeam)
  self._btn_TeamWait:SetShow(isCanChangeTeam)
  Panel_CompetitionGameForTeamChange:SetShow(true)
  self._btn_TeamObserver:SetShow(false)
end
function CompetitionGameForTeamChange_Init()
  local self = competitionGameForTeamChange
  self._list_TeamA:changeAnimationSpeed(10)
  self._list_TeamA:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "CompetitionGame_TeamA_Update")
  self._list_TeamA:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._list_TeamB:changeAnimationSpeed(10)
  self._list_TeamB:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "CompetitionGame_TeamB_Update")
  self._list_TeamB:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._list_Entry:changeAnimationSpeed(10)
  self._list_Entry:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "CompetitionGame_Entry_Update")
  self._list_Entry:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._list_Observer:changeAnimationSpeed(10)
  self._list_Observer:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "CompetitionGame_Observer_Update")
  self._list_Observer:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._btn_Close:addInputEvent("Mouse_LUp", "FGlobal_CompetitionGameForTeamChange_Close()")
  self._btn_ForHost:addInputEvent("Mouse_LUp", "FGlobal_CompetitionGameForHost_Open()")
  if ToClient_IsCompetitionHost() then
    self._btn_ForHost:SetShow(true)
  else
    self._btn_ForHost:SetShow(false)
  end
end
local selectedKey = -1
function CompetitionGame_TeamA_Update(contents, key)
  local idx = Int64toInt32(key)
  selectedKey = idx
  local matchMode = ToClient_CompetitionMatchType()
  local waitListInfo
  if 0 == matchMode then
    waitListInfo = ToClient_GetTeamUserInfoAt(1, idx)
  else
    local teamInfo = ToClient_GetTeamListAt(idx)
    if nil == teamInfo then
      return
    end
    waitListInfo = ToClient_GetTeamLeaderInfo(teamInfo:getTeamNo())
  end
  if nil ~= waitListInfo then
    local _txt_Level = UI.getChildControl(contents, "StaticText_Level")
    _txt_Level:SetShow(true)
    _txt_Level:SetPosX(7)
    _txt_Level:SetPosY(5)
    local _txt_Class = UI.getChildControl(contents, "StaticText_Class")
    _txt_Class:SetShow(true)
    _txt_Class:SetPosX(75)
    _txt_Class:SetPosY(5)
    local _txt_Name = UI.getChildControl(contents, "StaticText_Name")
    _txt_Name:SetShow(true)
    _txt_Name:SetPosX(246)
    _txt_Name:SetPosY(5)
    local _btn_TeamSet = UI.getChildControl(contents, "Button_TeamSet")
    local _btn_Kick = UI.getChildControl(contents, "Button_MemberKick")
    local _btn_AssistantSet = UI.getChildControl(contents, "Button_AssistantSet")
    _btn_TeamSet:SetShow(false)
    _btn_Kick:SetShow(false)
    _btn_AssistantSet:SetShow(false)
    if ToClient_IsCompetitionHost() or ToClient_IsCompetitionAssistant() then
      _btn_Kick:SetShow(true)
    end
    if ToClient_IsCompetitionHost() then
      _btn_TeamSet:SetShow(true)
      _btn_AssistantSet:SetShow(true)
    end
    local matchMode = ToClient_CompetitionMatchType()
    if 1 == matchMode then
      _btn_TeamSet:SetShow(false)
    end
    local teamNo = waitListInfo:getTeamNo()
    local userNo = waitListInfo:getUserNo()
    local userLevel = waitListInfo:getCharacterLevel()
    local userClass = waitListInfo:getCharacterClass()
    local userName = waitListInfo:getUserName()
    local characterName = waitListInfo:getCharacterName()
    local isAssistant = waitListInfo:isAssistant()
    _txt_Level:SetText(userLevel)
    _txt_Class:SetText(getCharacterClassName(userClass))
    _txt_Name:SetText(userName .. "(" .. characterName .. ")")
    if waitListInfo:isHost() then
      _txt_Name:SetFontColor(Defines.Color.C_FFFFD237)
    elseif waitListInfo:isAssistant() then
      _txt_Name:SetFontColor(Defines.Color.C_FFB5FF6D)
    else
      _txt_Name:SetFontColor(Defines.Color.C_FFFFFFFF)
    end
    _btn_Kick:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGameForTeamChange_Kick(" .. tostring(userNo) .. ")")
    _btn_TeamSet:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTeamSet_Open(" .. tostring(userNo) .. ", " .. teamNo .. ", false)")
    _btn_AssistantSet:addInputEvent("Mouse_LUp", "FGlobal_ChangeAssistant(" .. tostring(userNo) .. ", " .. tostring(not isAssistant) .. ")")
  end
end
function CompetitionGame_TeamB_Update(contents, key)
  _PA_LOG("LUA_COMPETITION", "CompetitionGame_TeamB_Update : START")
  local idx = Int64toInt32(key)
  selectedKey = idx
  local matchMode = ToClient_CompetitionMatchType()
  local waitListInfo
  if 0 == matchMode then
    _PA_LOG("LUA_COMPETITION", "CompetitionGame_TeamB_Update : TeamB Info")
    waitListInfo = ToClient_GetTeamUserInfoAt(2, idx)
  else
    _PA_LOG("LUA_COMPETITION", "CompetitionGame_TeamB_Update : AllEntry Info")
    waitListInfo = ToClient_GetEntryListAt(idx)
  end
  _PA_LOG("LUA_COMPETITION", "CompetitionGame_TeamB_Update : ING...")
  if nil ~= waitListInfo then
    local _txt_Level = UI.getChildControl(contents, "StaticText_Level")
    _txt_Level:SetShow(true)
    _txt_Level:SetPosX(7)
    _txt_Level:SetPosY(0)
    local _txt_Class = UI.getChildControl(contents, "StaticText_Class")
    _txt_Class:SetShow(true)
    _txt_Class:SetPosX(75)
    _txt_Class:SetPosY(0)
    local _txt_Name = UI.getChildControl(contents, "StaticText_Name")
    _txt_Name:SetShow(true)
    _txt_Name:SetPosX(246)
    _txt_Name:SetPosY(0)
    local _btn_TeamSet = UI.getChildControl(contents, "Button_TeamSet")
    local _btn_Kick = UI.getChildControl(contents, "Button_MemberKick")
    local _btn_AssistantSet = UI.getChildControl(contents, "Button_AssistantSet")
    _btn_TeamSet:SetShow(false)
    _btn_Kick:SetShow(false)
    _btn_AssistantSet:SetShow(false)
    if ToClient_IsCompetitionHost() or ToClient_IsCompetitionAssistant() then
      _btn_Kick:SetShow(true)
    end
    if ToClient_IsCompetitionHost() then
      _btn_TeamSet:SetShow(true)
      _btn_AssistantSet:SetShow(true)
    end
    local matchMode = ToClient_CompetitionMatchType()
    if 1 == matchMode then
      _btn_TeamSet:SetShow(false)
    end
    local teamNo = waitListInfo:getTeamNo()
    local userNo = waitListInfo:getUserNo()
    local userLevel = waitListInfo:getCharacterLevel()
    local userClass = waitListInfo:getCharacterClass()
    local userName = waitListInfo:getUserName()
    local characterName = waitListInfo:getCharacterName()
    local isAssistant = waitListInfo:isAssistant()
    _txt_Level:SetText(userLevel)
    _txt_Class:SetText(getCharacterClassName(userClass))
    _txt_Name:SetText(userName .. "(" .. characterName .. ")")
    if waitListInfo:isHost() then
      _txt_Name:SetFontColor(Defines.Color.C_FFFFD237)
    elseif waitListInfo:isAssistant() then
      _txt_Name:SetFontColor(Defines.Color.C_FFB5FF6D)
    else
      _txt_Name:SetFontColor(Defines.Color.C_FFFFFFFF)
    end
    _btn_Kick:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGameForTeamChange_Kick(" .. tostring(userNo) .. ")")
    _btn_TeamSet:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTeamSet_Open(" .. tostring(userNo) .. ", " .. teamNo .. ", false)")
    _btn_AssistantSet:addInputEvent("Mouse_LUp", "FGlobal_ChangeAssistant(" .. tostring(userNo) .. ", " .. tostring(not isAssistant) .. ")")
  end
end
function FGlobal_CompetitionGameForHost_ChangeTeam(teamNo, userNo, isObserver)
  if -1 == teamNo then
    txt_teamNo:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_OBSERVER"))
  end
  ToClient_RequestSetTeam(userNo, teamNo)
  ClearFocusEdit()
end
function CompetitionGame_Entry_Update(contents, key)
  local idx = Int64toInt32(key)
  selectedKey = idx
  local waitListInfo = ToClient_GetTeamUserInfoAt(0, idx)
  if nil ~= waitListInfo and 0 == waitListInfo:getTeamNo() then
    local _txt_Level = UI.getChildControl(contents, "StaticText_Level")
    _txt_Level:SetShow(true)
    _txt_Level:SetPosX(17)
    _txt_Level:SetPosY(5)
    local _txt_Class = UI.getChildControl(contents, "StaticText_Class")
    _txt_Class:SetShow(true)
    _txt_Class:SetPosX(90)
    _txt_Class:SetPosY(5)
    local _txt_Name = UI.getChildControl(contents, "StaticText_Name")
    _txt_Name:SetShow(true)
    _txt_Name:SetPosX(210)
    _txt_Name:SetPosY(5)
    local _btn_TeamSet = UI.getChildControl(contents, "Button_TeamSet")
    local _btn_Kick = UI.getChildControl(contents, "Button_MemberKick")
    local _btn_AssistantSet = UI.getChildControl(contents, "Button_AssistantSet")
    _btn_TeamSet:SetShow(false)
    _btn_Kick:SetShow(false)
    _btn_AssistantSet:SetShow(false)
    if ToClient_IsCompetitionHost() or ToClient_IsCompetitionAssistant() then
      _btn_Kick:SetShow(true)
    end
    if ToClient_IsCompetitionHost() then
      _btn_TeamSet:SetShow(true)
      _btn_AssistantSet:SetShow(true)
    end
    local matchMode = ToClient_CompetitionMatchType()
    if 1 == matchMode then
      _btn_TeamSet:SetShow(false)
    end
    local teamNo = waitListInfo:getTeamNo()
    local userNo = waitListInfo:getUserNo()
    local userLevel = waitListInfo:getCharacterLevel()
    local userClass = waitListInfo:getCharacterClass()
    local userName = waitListInfo:getUserName()
    local characterName = waitListInfo:getCharacterName()
    local isAssistant = waitListInfo:isAssistant()
    _txt_Level:SetText(userLevel)
    _txt_Class:SetText(getCharacterClassName(userClass))
    _txt_Name:SetText(userName .. "(" .. characterName .. ")")
    if waitListInfo:isHost() then
      _txt_Name:SetFontColor(Defines.Color.C_FFFFD237)
    elseif waitListInfo:isAssistant() then
      _txt_Name:SetFontColor(Defines.Color.C_FFB5FF6D)
    else
      _txt_Name:SetFontColor(Defines.Color.C_FFFFFFFF)
    end
    _btn_Kick:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGameForTeamChange_Kick(" .. tostring(userNo) .. ")")
    _btn_TeamSet:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTeamSet_Open(" .. tostring(userNo) .. ", " .. teamNo .. ", false)")
    _btn_AssistantSet:addInputEvent("Mouse_LUp", "FGlobal_ChangeAssistant(" .. tostring(userNo) .. ", " .. tostring(not isAssistant) .. ")")
  end
end
function CompetitionGame_Observer_Update(contents, key)
  local idx = Int64toInt32(key)
  selectedKey = idx
  local waitListInfo = ToClient_GetObserverListAt(idx)
  if nil ~= waitListInfo then
    local _txt_Level = UI.getChildControl(contents, "StaticText_Level")
    _txt_Level:SetShow(true)
    _txt_Level:SetPosX(17)
    _txt_Level:SetPosY(5)
    local _txt_Class = UI.getChildControl(contents, "StaticText_Class")
    _txt_Class:SetShow(true)
    _txt_Class:SetPosX(110)
    _txt_Class:SetPosY(5)
    local _txt_Name = UI.getChildControl(contents, "StaticText_Name")
    _txt_Name:SetShow(true)
    _txt_Name:SetPosX(230)
    _txt_Name:SetPosY(5)
    local _btn_AssistantSet = UI.getChildControl(contents, "Button_AssistantSet")
    local _btn_TeamSet = UI.getChildControl(contents, "Button_TeamSet")
    _btn_TeamSet:SetShow(false)
    local _btn_Kick = UI.getChildControl(contents, "Button_MemberKick")
    _btn_TeamSet:SetShow(false)
    _btn_Kick:SetShow(false)
    _btn_AssistantSet:SetShow(false)
    if ToClient_IsCompetitionHost() or ToClient_IsCompetitionAssistant() then
      _btn_Kick:SetShow(true)
    end
    if ToClient_IsCompetitionHost() then
      _btn_AssistantSet:SetShow(true)
    end
    local teamNo = waitListInfo:getTeamNo()
    local userNo = waitListInfo:getUserNo()
    local userLevel = waitListInfo:getCharacterLevel()
    local userClass = waitListInfo:getCharacterClass()
    local userName = waitListInfo:getUserName()
    local characterName = waitListInfo:getCharacterName()
    local isAssistant = waitListInfo:isAssistant()
    _txt_Level:SetText(userLevel)
    _txt_Class:SetText(getCharacterClassName(userClass))
    _txt_Name:SetText(userName .. "(" .. characterName .. ")")
    if waitListInfo:isHost() then
      _txt_Name:SetFontColor(Defines.Color.C_FFFFD237)
    elseif waitListInfo:isAssistant() then
      _txt_Name:SetFontColor(Defines.Color.C_FFB5FF6D)
    else
      _txt_Name:SetFontColor(Defines.Color.C_FFFFFFFF)
    end
    _btn_Kick:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGameForTeamChange_Kick(" .. tostring(userNo) .. ")")
    _btn_TeamSet:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTeamSet_Open(" .. tostring(userNo) .. ", " .. teamNo .. ", false)")
    _btn_AssistantSet:addInputEvent("Mouse_LUp", "FGlobal_ChangeAssistant(" .. tostring(userNo) .. ", " .. tostring(not isAssistant) .. ")")
  end
end
function CompetitionGame_AliveUser(contents, key)
  local idx = Int64toInt32(key)
  selectedKey = idx
  local waitListInfo = ToClient_GetTeamUserInfoAt(0, idx)
  if nil ~= waitListInfo and 0 == waitListInfo:getTeamNo() then
    local _txt_Level = UI.getChildControl(contents, "StaticText_Level")
    _txt_Level:SetShow(true)
    _txt_Level:SetPosX(17)
    _txt_Level:SetPosY(5)
    local _txt_Class = UI.getChildControl(contents, "StaticText_Class")
    _txt_Class:SetShow(true)
    _txt_Class:SetPosX(110)
    _txt_Class:SetPosY(5)
    local _txt_Name = UI.getChildControl(contents, "StaticText_Name")
    _txt_Name:SetShow(true)
    _txt_Name:SetPosX(230)
    _txt_Name:SetPosY(5)
    local teamNo = waitListInfo:getTeamNo()
    local userNo = waitListInfo:getUserNo()
    local userLevel = waitListInfo:getCharacterLevel()
    local userClass = waitListInfo:getCharacterClass()
    local userName = waitListInfo:getUserName()
    local characterName = waitListInfo:getCharacterName()
    _txt_Level:SetText(userLevel)
    _txt_Class:SetText(getCharacterClassName(userClass))
    _txt_Name:SetText(userName .. "(" .. characterName .. ")")
  end
end
function CompetitionGameForTeamChange_SelectedUpdate_Round()
  local self = competitionGameForTeamChange
  local ListCount = ToClient_GetTeamUserInfoCount(1)
  self._list_TeamA:getElementManager():clearKey()
  if ListCount > 0 then
    for idx = 0, ListCount - 1 do
      self._list_TeamA:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local ListCount = ToClient_GetTeamUserInfoCount(2)
  self._list_TeamB:getElementManager():clearKey()
  if ListCount > 0 then
    for idx = 0, ListCount - 1 do
      self._list_TeamB:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local ListCount = ToClient_GetTeamUserInfoCount(0)
  self._list_Entry:getElementManager():clearKey()
  if ListCount > 0 then
    for idx = 0, ListCount - 1 do
      self._list_Entry:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local ListCount = ToClient_GetObserverListCount()
  self._list_Observer:getElementManager():clearKey()
  if ListCount > 0 then
    for idx = 0, ListCount - 1 do
      self._list_Observer:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  self._txt_TeamA:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_A"))
  self._txt_TeamB:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_B"))
end
function CompetitionGameForTeamChange_SelectedUpdate_FreeForAll()
  local self = competitionGameForTeamChange
  local ListCount = ToClient_GetTeamUserInfoCount(0)
  self._list_Entry:getElementManager():clearKey()
  if ListCount > 0 then
    for idx = 0, ListCount - 1 do
      self._list_Entry:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local tempidx = 0
  local alluser = ToClient_GetTeamListCountWithOutZero()
  self._list_TeamA:getElementManager():clearKey()
  if alluser > 0 then
    for idx = 0, alluser - 1 do
      self._list_TeamA:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  _PA_LOG("LUA_COMPETITION", "CompetitionGameForTeamChange_SelectedUpdate_FreeForAll : TeamB STart")
  local ListCount = ToClient_GetEntryListCount()
  self._list_TeamB:getElementManager():clearKey()
  if ListCount > 0 then
    for idx = 0, ListCount - 1 do
      self._list_TeamB:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  _PA_LOG("LUA_COMPETITION", "CompetitionGameForTeamChange_SelectedUpdate_FreeForAll : TeamB End")
  local ListCount = ToClient_GetObserverListCount()
  self._list_Observer:getElementManager():clearKey()
  if ListCount > 0 then
    for idx = 0, ListCount - 1 do
      self._list_Observer:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  self._txt_TeamA:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_PARTY_LEADER"))
  self._txt_TeamB:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_PARTY_ALL_USER"))
end
function FGlobal_CompetitionGameForTeamChange_Close()
  Panel_CompetitionGameForTeamChange:SetShow(false)
end
function FGlobal_ChangeAssistant(userNo_s64, isAssistant)
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
function FromClient_UpdateTeamUserList()
  if CppEnums.CompetitionMatchType.eCompetitionMatchMode_Round == ToClient_CompetitionMatchType() then
    CompetitionGameForTeamChange_SelectedUpdate_Round()
  else
    CompetitionGameForTeamChange_SelectedUpdate_FreeForAll()
  end
end
function HandleClicked_CompetitionTeamChange(teamNo)
  local userNo = getSelfPlayer():get():getUserNo()
  ToClient_RequestSetTeam(userNo, teamNo)
end
function HandleUpdateMatchTime(limitTime, matchTime)
  local self = competitionGameForTeamChange
  self._txt_Timer:SetText(limitTime - matchTime)
end
function HandleChangeMode()
  _PA_LOG("LUA_COMPETITION", "HandleChangeMode : START")
  local self = competitionGameForTeamChange
  if Panel_CompetitionGameForTeamChange:GetShow() == false then
    _PA_LOG("LUA_COMPETITION", "HandleChangeMode : END1")
    return
  end
  FGlobal_CompetitionGameForTeamChange_Close()
  FGlobal_CompetitionGameForTeamChange_Open()
  _PA_LOG("LUA_COMPETITION", "HandleChangeMode : END2")
end
function HandleClicked_CompetitionGameForTeamChange_Kick(userNo_s64)
  local userinfo = ToClient_GetCompetitionDefinedUser(userNo_s64)
  local characterName
  if nil ~= userinfo then
    characterName = userinfo:getCharacterName()
  end
  local function KickUserCompetition()
    ToClient_RequestLeavePlayer(userNo_s64)
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
function FromClient_UpdateTeamScore(teamNum, scoreValue, round)
  if 0 == teamNum then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAMSCORE_DRAW", "currentRound", round))
  else
    local matchMode = ToClient_CompetitionMatchType()
    if 0 == matchMode then
      local teamAlphabet = "B"
      if 1 == teamNum then
        teamAlphabet = "A"
      end
      Proc_ShowMessage_Ack(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAMSCORE", "currentRound", round, "teamNo", teamAlphabet, "score", scoreValue))
    elseif 1 == matchMode then
      local leaderInfo = ToClient_GetTeamLeaderInfo(teamNum)
      Proc_ShowMessage_Ack(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAMSCORE", "currentRound", round, "teamNo", leaderInfo:getUserName(), "score", scoreValue))
    end
  end
end
function FromClient_WaitBeforeFight()
end
function FromClient_CompetitionMatchDone(teamNo, rank)
  if 0 == teamNo then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_MATCH_DONE_DRAW", "teamNo", teamNo))
    return
  end
  local matchMode = ToClient_CompetitionMatchType()
  if 0 == matchMode then
    local teamAlphabet = "B"
    if 1 == teamNo then
      teamAlphabet = "A"
    end
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_MATCH_DONE", "teamNo", teamAlphabet))
  elseif 1 == matchMode then
    local leaderInfo = ToClient_GetTeamLeaderInfo(teamNo)
    if nil ~= leaderInfo then
      Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_COMPETITION_MATCH_DONE_FREEFORALL", "rank", rank, "leaderName", leaderInfo:getCharacterName()))
    end
  elseif 2 == matchMode then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_MATCH_DONE", "teamNo", teamAlphabet))
  end
end
function HandleChangeOption_ForTeamChange()
  _PA_LOG("LUA_COMPETITION", "HandleChangeOption_ForTeamChange : START")
  local self = competitionGameForTeamChange
  local matchMode = ToClient_CompetitionMatchType()
  local targetScore = ToClient_GetTargetScore()
  if 0 == matchMode then
    self._txt_Timer:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_COMPETITION_ROUND_SCORE_DESC", "totalRound", targetScore * 2 - 1, "targetRound", targetScore))
    if 1 == targetScore then
      self._txt_Timer:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_SINGLEROUND"))
    end
  elseif 1 == matchMode then
    self._txt_Timer:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_FREEFORALL_SCORE_DESC", "targetCount", targetScore))
  end
  if targetScore <= 0 then
    self._txt_Timer:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_ERROR_SCORE"))
  end
  _PA_LOG("LUA_COMPETITION", "HandleChangeOption_ForTeamChange : END")
end
function HandleTestFunc()
  FGlobal_CompetitionGameForTeamChange_Open()
end
function HandleJoinNewPlayer(characterName, isEntryUser)
  if isEntryUser then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_JOINNEWPLAYER_ENTRY", "characterName", characterName))
  else
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_JOINNEWPLAYER_OBSERVER", "characterName", characterName))
  end
end
function HandleAnyUserDead(deadUserInfo, attackerUserInfo)
  if nil == attackerUserInfo then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_USERDEAD_SELF", "characterName", deadUserInfo:getCharacterName()))
  else
    Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_COMPETITION_USERDEAD_ATTACKED", "attackerName", attackerUserInfo:getCharacterName(), "deadUserName", deadUserInfo:getCharacterName()))
  end
end
function FromClient_EntryUserChangeTeam(userInfo)
  local matchMode = ToClient_CompetitionMatchType()
  if 0 ~= matchMode or nil == userInfo then
    return
  end
  local teamAlphabet = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_COMPETITIONGAME_WAITINGLIST")
  if userInfo:getTeamNo() == 1 then
    teamAlphabet = "A"
  elseif userInfo:getTeamNo() == 2 then
    teamAlphabet = "B"
  end
  local message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_COMPETITION_USER_CHANGETEAM", "characterName", userInfo:getCharacterName(), "teamNo", teamAlphabet)
  chatting_sendMessage("", message, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
end
function FromClient_GetOutUserFromCompetition(outUserInfo)
  if nil == outUserInfo then
    return
  end
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GETOUT_FROM_COMPETITION", "characterName", outUserInfo:getCharacterName()))
end
function CompetitionGameForTeamChange_Event()
  local self = competitionGameForTeamChange
  self._btn_TeamA:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionTeamChange(" .. 1 .. ")")
  self._btn_TeamB:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionTeamChange(" .. 2 .. ")")
  self._btn_TeamWait:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionTeamChange(" .. 0 .. ")")
  self._btn_leaveCompetition:addInputEvent("Mouse_LUp", "ToClient_RequestLeaveMyself()")
  registerEvent("FromClient_UpdateObserverList", "FromClient_UpdateTeamUserList")
  registerEvent("FromClient_UpdateEntryList", "FromClient_UpdateTeamUserList")
  registerEvent("FromClient_ChangeMatchType", "HandleChangeMode")
  registerEvent("FromClient_UpdateTeamScore", "FromClient_UpdateTeamScore")
  registerEvent("FromClient_WaitBeforeFight", "FromClient_WaitBeforeFight")
  registerEvent("FromClient_CompetitionMatchDone", "FromClient_CompetitionMatchDone")
  registerEvent("FromClient_ChangeMatchType", "HandleChangeOption_ForTeamChange")
  registerEvent("FromClient_CompetitionOptionChanged", "HandleChangeOption_ForTeamChange")
  registerEvent("FromClient_JoinNewPlayer", "HandleJoinNewPlayer")
  registerEvent("FromClient_KillHistory", "HandleAnyUserDead")
  registerEvent("FromClient_EntryUserChangeTeam", "FromClient_EntryUserChangeTeam")
  registerEvent("FromClient_GetOutUserFromCompetition", "FromClient_GetOutUserFromCompetition")
end
CompetitionGameForTeamChange_Init()
CompetitionGameForTeamChange_Event()

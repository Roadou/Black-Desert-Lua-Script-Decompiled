local IM = CppEnums.EProcessorInputMode
Panel_CompetitionGame:SetShow(false)
local competitionGame = {
  edit_Name = UI.getChildControl(Panel_CompetitionGame, "Edit_CharacterName"),
  btn_Summon = UI.getChildControl(Panel_CompetitionGame, "Button_Summon"),
  btn_Close = UI.getChildControl(Panel_CompetitionGame, "Button_Close"),
  _btn_Start = UI.getChildControl(Panel_CompetitionGame, "Button_StartGame"),
  _btn_Pause = UI.getChildControl(Panel_CompetitionGame, "Button_PauseGame"),
  _btn_AllResurrection = UI.getChildControl(Panel_CompetitionGame, "Button_AllPlayerResurrection"),
  _btn_InviteList = UI.getChildControl(Panel_CompetitionGame, "Button_InviteList"),
  _btn_OpenOrClose = UI.getChildControl(Panel_CompetitionGame, "Button_OpenOrClose"),
  _list2 = UI.getChildControl(Panel_CompetitionGame, "List2_GamescomList"),
  _chk_Observer = UI.getChildControl(Panel_CompetitionGame, "CheckBox_Observer"),
  _btn_TargetScore = UI.getChildControl(Panel_CompetitionGame, "Button_TargetScore"),
  _txt_TargetScore = UI.getChildControl(Panel_CompetitionGame, "StaticText_TargetScore"),
  _btn_TimeLimit = UI.getChildControl(Panel_CompetitionGame, "Button_TimeLimit"),
  _txt_TimeLimit = UI.getChildControl(Panel_CompetitionGame, "StaticText_TimeLimit"),
  _radioBtn_RoundMode = UI.getChildControl(Panel_CompetitionGame, "RadioButton_RoundMode"),
  _radioBtn_FreeForAll = UI.getChildControl(Panel_CompetitionGame, "RadioButton_FreeForAll"),
  _list2 = UI.getChildControl(Panel_CompetitionGame, "List2_GamescomList"),
  _list2_Observer = UI.getChildControl(Panel_CompetitionGame, "List2_GamescomListObserver"),
  _targetScore = 3,
  _timeLimit = 300,
  _levelLimit = 58,
  _maxPartyMemberCount = 5,
  maxTeamCount = 999
}
function CompetitionGame_Init()
  local self = competitionGame
  self._list2:changeAnimationSpeed(10)
  self._list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "CompetitionGame_ListUpdate")
  self._list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._list2_Observer:changeAnimationSpeed(10)
  self._list2_Observer:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "CompetitionGame_ListUpdate_Observer")
  self._list2_Observer:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  _targetScore = ToClient_GetTargetScore()
  _timeLimit = ToClient_CompetitionMatchTimeLimit()
  self._txt_TargetScore:SetText(_targetScore)
  self._txt_TimeLimit:SetText(_timeLimit)
end
local selectedKey = -1
function CompetitionGame_ListUpdate(contents, key)
  local idx = Int64toInt32(key)
  selectedKey = idx
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
  _txt_Name:SetPosX(340)
  _txt_Name:SetPosY(5)
  local _txt_TeamNo = UI.getChildControl(contents, "StaticText_TeamNo")
  _txt_TeamNo:SetShow(true)
  local _btn_TeamSet = UI.getChildControl(contents, "Button_TeamSet")
  _btn_TeamSet:SetShow(true)
  local _btn_Kick = UI.getChildControl(contents, "Button_MemberKick")
  _btn_Kick:SetShow(true)
  local _btn_Resurrection = UI.getChildControl(contents, "Button_MemberResurrection")
  _btn_Resurrection:SetShow(true)
  local entryListInfo = ToClient_GetEntryListAt(idx)
  if nil ~= entryListInfo then
    local userNo = entryListInfo:getUserNo()
    local userLevel = entryListInfo:getCharacterLevel()
    local userClass = entryListInfo:getCharacterClass()
    local userName = entryListInfo:getUserName()
    local characterName = entryListInfo:getCharacterName()
    local teamNo = entryListInfo:getTeamNo()
    _txt_Level:SetText(userLevel)
    _txt_Class:SetText(getCharacterClassName(userClass))
    _txt_Name:SetText(userName .. "(" .. characterName .. ")")
    _txt_TeamNo:SetText(teamNo)
    _btn_TeamSet:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTeamSet_Open(" .. userNo .. ", " .. teamNo .. ", false)")
    _btn_Resurrection:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGame_Resurrection(" .. idx .. ")")
    _btn_Kick:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGame_Kick(" .. idx .. ", false)")
  end
end
function CompetitionGame_ListUpdate_Observer(contents, key)
  local self = competitionGame
  local idx = Int64toInt32(key)
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
  _txt_Name:SetPosX(340)
  _txt_Name:SetPosY(5)
  local _txt_TeamNo = UI.getChildControl(contents, "StaticText_TeamNo")
  _txt_TeamNo:SetShow(false)
  local _btn_TeamSet = UI.getChildControl(contents, "Button_TeamSet")
  _btn_TeamSet:SetShow(false)
  local _btn_Kick = UI.getChildControl(contents, "Button_MemberKick")
  _btn_Kick:SetShow(true)
  local observerListInfo = ToClient_GetObserverListAt(idx)
  if nil ~= observerListInfo then
    local userNo = observerListInfo:getUserNo()
    local userLevel = observerListInfo:getCharacterLevel()
    local userClass = observerListInfo:getCharacterClass()
    local userName = observerListInfo:getUserName()
    local characterName = observerListInfo:getCharacterName()
    local teamNo = observerListInfo:getTeamNo()
    _txt_Level:SetText(userLevel)
    _txt_Class:SetText(getCharacterClassName(userClass))
    _txt_Name:SetText(userName .. "(" .. characterName .. ")")
    _txt_TeamNo:SetText(teamNo)
    _btn_TeamSet:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTeamSet_Open(" .. userNo .. ", " .. teamNo .. ", true)")
    _btn_Kick:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGame_Kick(" .. idx .. ", true)")
  end
end
function CompetitionGame_SelectedUpdate()
  local self = competitionGame
  local entryListCount = 0
  self._list2:getElementManager():clearKey()
  if entryListCount > 0 then
    for idx = 0, entryListCount - 1 do
      self._list2:getElementManager():pushKey(toInt64(0, idx))
    end
  end
  local observerListCount = ToClient_GetObserverListCount()
  self._list2_Observer:getElementManager():clearKey()
  if observerListCount > 0 then
    for idx = 0, observerListCount - 1 do
      self._list2_Observer:getElementManager():pushKey(toInt64(0, idx))
    end
  end
end
function HandleClicked_CompetitionGame_Summon()
  local self = competitionGame
  if not ToClient_SelfPlayerIsGM() then
    return
  end
  local characterName = self.edit_Name:GetEditText()
  local isObserver = self._chk_Observer:IsCheck()
  if nil == characterName or "" == characterName then
    return
  end
  ToClient_RequestInviteCompetition(characterName, isObserver)
  ClearFocusEdit()
end
function FGlobal_CompetitionGame_ChangeTeam(teamNo, userNo, isObserver)
  if -1 == teamNo then
    txt_teamNo:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_OBSERVER"))
  else
    txt_teamNo:SetText(tostring(teamNo))
  end
  ToClient_RequestSetTeam(userNo, teamNo)
  ClearFocusEdit()
end
function FGlobal_CompetitionGame_TargetScore(score)
  local self = competitionGame
  self._targetScore = score
  self._txt_TargetScore:SetText(score)
  HandleClicked_ChangeCompetitionOption()
end
function FGlobal_CompetitionGame_TimeLimit(timeLimit)
  local self = competitionGame
  self._timeLimit = timeLimit
  self._txt_TimeLimit:SetText(timeLimit)
  HandleClicked_ChangeCompetitionOption()
end
function HandleClicked_CompetitionGame_Kick(idx, isObserver)
  local entryListInfo = ToClient_GetEntryListAt(idx)
  local observerListInfo = ToClient_GetObserverListAt(idx)
  if isObserver then
    competitionListInfo = ToClient_GetObserverListAt(idx)
  else
    competitionListInfo = ToClient_GetEntryListAt(idx)
  end
  if nil == competitionListInfo then
    return
  end
  local userNo_s64 = competitionListInfo:getUserNo()
  local userCharacterName = competitionListInfo:getCharacterName()
  local function KickUserCompetition()
    ToClient_RequestLeavePlayer(userNo_s64)
  end
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_USERKICK_MESSAGEBOX", "name", userCharacterName)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = KickUserCompetition,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleClicked_CompetitionGame_Resurrection(idx)
  if nil == idx then
    return
  end
  local entryListInfo = ToClient_GetEntryListAt(idx)
  local userNo_s64 = entryListInfo:getUserNo()
  local userCharacterName = entryListInfo:getCharacterName()
  local function userResurrectionExecute()
    ToClient_RequestRebirthPlayer(userNo_s64)
  end
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_USERRESURRECSTION_MESSAGEBOX", "name", userCharacterName)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = userResurrectionExecute,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FromClient_ResponseEntryList()
  local self = competitionGame
  CompetitionGame_SelectedUpdate()
end
function FromClient_UpdateEntryList()
  local self = competitionGame
  CompetitionGame_SelectedUpdate()
end
function FromClient_ResponseObserverList()
  local self = competitionGame
  CompetitionGame_SelectedUpdate()
end
function FromClient_UpdateObserverList()
  local self = competitionGame
  CompetitionGame_SelectedUpdate()
end
function FromClient_InviteCompetiton(hostCharacterName, isObserver)
  local self = competitionGame
  local function InviteCompetition()
    ToClient_ResponseInviteCompetition(true, isObserver)
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_INVITE_FIGHTER")
  if isObserver then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_INVITE_OBSERVER")
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_INVITE_FIGHTER")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = InviteCompetition,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleClicked_CompetitionGame_EditText()
  local self = competitionGame
  self.edit_Name:SetEditText("", true)
  SetFocusEdit(self.edit_Name)
end
function HandleClicked_competitionGameEditSetFocus()
  local self = competitionGame
  SetFocusEdit(self.edit_Name)
  self.edit_Name:SetEditText(self.edit_Name:GetEditText(), true)
end
function HandleClicked_CompetitionGame_GameStart()
  local self = competitionGame
  ToClient_RequestSetFight(CppEnums.CompetitionFightState.eCompetitionFightState_Wait, self._targetScore)
end
function HandleClicked_CompetitionGame_Pause()
  ToClient_RequestSetFight(CppEnums.CompetitionFightState.eCompetitionFightState_Stop)
end
function HandleClicked_CompetitionGame_Done()
  ToClient_RequestSetFight(CppEnums.CompetitionFightState.eCompetitionFightState_Done)
end
function HandleClicked_CompetitionGame_AllPlayerResurrection()
  ToClient_RequestRebirthPlayerAll()
end
function CompetitionGame_Entry()
  ToClient_RequestEnterCompetitionHost()
end
function FGlobal_CompetitionGame_NormalUser_Out()
  ToClient_RequestLeaveMyself()
end
function FGlobal_CompetitionGame_Open()
  CompetitionGame_SelectedUpdate()
  Panel_CompetitionGame:SetShow(true)
  RefreshMatchModeButton()
  selectedKey = -1
end
function FGlobal_CompetitionGame_Close()
  Panel_CompetitionGame:SetShow(false)
  FGlobal_CompetitionTeamSet_Close()
end
function HandleClicked_ModeChange(matchMode)
  local self = competitionGame
  ToClient_CompetitionMatchTypeChange(matchMode)
  RefreshMatchModeButton()
end
function HandleClicked_ChangeCompetitionOption()
  local self = competitionGame
  if ToClient_IsCompetitionHost() == true then
    local isOpen = ToClient_IsCompetitionOpen_HostOnly()
    ToClient_RequestCompetitionOption(not isOpen, self._timeLimit, self._targetScore, self._levelLimit, self._maxPartyMemberCount)
  end
end
function FromClient_IsMyTeamResult(matchResult)
  local msg = {
    main = "",
    sub = "",
    addMsg = ""
  }
  if __eCompetitionResult_Draw == matchResult then
    msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_DRAW_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_WIN_SUB"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 46, false)
  elseif __eCompetitionResult_Win == matchResult then
    msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_WIN_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_WIN_SUB"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 45, false)
  elseif __eCompetitionResult_Loose == matchResult then
    msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_LOSE_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_WIN_SUB"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 46, false)
  end
end
function FromClient_RoundReady(currentRound, countDown)
  if 0 == countDown then
    return
  end
  local msg = {
    main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_ROUND", "round", currentRound),
    sub = countDown,
    addMsg = ""
  }
  Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect(msg, 5, 62, false)
end
function CompetitionGame_Event()
  local self = competitionGame
  self.edit_Name:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGame_EditText()")
  self.btn_Summon:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGame_Summon()")
  self.edit_Name:RegistReturnKeyEvent("HandleClicked_CompetitionGame_Summon()")
  self.btn_Close:addInputEvent("Mouse_LUp", "FGlobal_CompetitionGame_Close()")
  self._btn_Start:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGame_GameStart()")
  self._btn_Pause:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGame_Done()")
  self._btn_AllResurrection:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGame_AllPlayerResurrection()")
  self._btn_TargetScore:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTargetScoreSet_Open(true)")
  self._btn_TimeLimit:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTargetScoreSet_Open(false)")
  self._radioBtn_RoundMode:addInputEvent("Mouse_LUp", "HandleClicked_ModeChange(" .. CppEnums.CompetitionMatchType.eCompetitionMatchMode_Round .. ")")
  self._radioBtn_FreeForAll:addInputEvent("Mouse_LUp", "HandleClicked_ModeChange(" .. CppEnums.CompetitionMatchType.eCompetitionMatchMode_FreeForAll .. ")")
  registerEvent("FromClient_InviteCompetiton", "FromClient_InviteCompetiton")
  registerEvent("FromClient_IsMyTeamResult", "FromClient_IsMyTeamResult")
  registerEvent("FromClient_RoundReady", "FromClient_RoundReady")
end
CompetitionGame_Init()
CompetitionGame_Event()

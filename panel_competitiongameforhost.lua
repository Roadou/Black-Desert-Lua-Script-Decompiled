local IM = CppEnums.EProcessorInputMode
Panel_CompetitionGameForHost:SetShow(false)
local competitionGameForHost = {
  edit_Name = UI.getChildControl(Panel_CompetitionGameForHost, "Edit_CharacterName"),
  btn_Summon = UI.getChildControl(Panel_CompetitionGameForHost, "Button_Summon"),
  btn_Close = UI.getChildControl(Panel_CompetitionGameForHost, "Button_Close"),
  _btn_Start = UI.getChildControl(Panel_CompetitionGameForHost, "Button_StartGame"),
  _btn_Pause = UI.getChildControl(Panel_CompetitionGameForHost, "Button_PauseGame"),
  _btn_AllResurrection = UI.getChildControl(Panel_CompetitionGameForHost, "Button_AllPlayerResurrection"),
  _btn_InviteList = UI.getChildControl(Panel_CompetitionGameForHost, "Button_InviteList"),
  _btn_OpenOrClose = UI.getChildControl(Panel_CompetitionGameForHost, "Button_OpenOrClose"),
  _chk_Observer = UI.getChildControl(Panel_CompetitionGameForHost, "CheckBox_Observer"),
  _chk_Assistant = UI.getChildControl(Panel_CompetitionGameForHost, "CheckBox_Assistant"),
  _btn_TargetScore = UI.getChildControl(Panel_CompetitionGameForHost, "Button_TargetScore"),
  _txt_TargetScore = UI.getChildControl(Panel_CompetitionGameForHost, "StaticText_TargetScore"),
  _btn_TimeLimit = UI.getChildControl(Panel_CompetitionGameForHost, "Button_TimeLimit"),
  _txt_TimeLimit = UI.getChildControl(Panel_CompetitionGameForHost, "StaticText_TimeLimit"),
  _btn_LevelLimit = UI.getChildControl(Panel_CompetitionGameForHost, "Button_SetLevelLimit"),
  _txt_LevelLimit = UI.getChildControl(Panel_CompetitionGameForHost, "StaticText_LevelLimitValue"),
  _btn_PartyMemberCount = UI.getChildControl(Panel_CompetitionGameForHost, "Button_SetPartyMember"),
  _txt_PartyMemberCount = UI.getChildControl(Panel_CompetitionGameForHost, "StaticText_PartyMemberValue"),
  _btn_MaxWaitTime = UI.getChildControl(Panel_CompetitionGameForHost, "Button_SetWaitTime"),
  _txt_MaxWaitTime = UI.getChildControl(Panel_CompetitionGameForHost, "StaticText_WaitTimeValue"),
  _radioBtn_RoundMode = UI.getChildControl(Panel_CompetitionGameForHost, "RadioButton_RoundMode"),
  _radioBtn_FreeForAll = UI.getChildControl(Panel_CompetitionGameForHost, "RadioButton_FreeForAll"),
  _targetScore = 3,
  _timeLimit = 300,
  _levelLimit = 58,
  _maxPartyMemberCount = 5,
  _maxWaitTime = 20,
  _isOpen = false,
  maxTeamCount = 999
}
function CompetitionGameForHost_Init()
  _PA_LOG("LUA_COMPETITION", "CompetitionGameForHost_Init : START")
  local self = competitionGameForHost
  self._targetScore = ToClient_GetTargetScore()
  self._timeLimit = ToClient_CompetitionMatchTimeLimit()
  self._levelLimit = ToClient_GetLevelLimit()
  self._maxPartyMemberCount = ToClient_GetMaxPartyMemberCount()
  self._maxWaitTime = ToClient_GetMaxWaitTime()
  self._chk_Assistant:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_CHK_ASSISTANT"))
  self._txt_TargetScore:SetText(self._targetScore)
  self._txt_TimeLimit:SetText(self._timeLimit)
  self._txt_LevelLimit:SetText(self._levelLimit)
  self._txt_PartyMemberCount:SetText(self._maxPartyMemberCount)
  self._txt_MaxWaitTime:SetText(self._maxWaitTime)
  _PA_LOG("LUA_COMPETITION", "CompetitionGameForHost_Init : END")
end
function HandleClicked_CompetitionGameForHost_Summon()
  _PA_LOG("LUA_COMPETITION", "HandleClicked_CompetitionGameForHost_Summon : START")
  local self = competitionGameForHost
  if not ToClient_SelfPlayerIsGM() then
    return
  end
  local characterName = self.edit_Name:GetEditText()
  local isObserver = self._chk_Observer:IsCheck()
  local isAssistant = self._chk_Assistant:IsCheck()
  if nil == characterName or "" == characterName then
    return
  end
  ToClient_RequestInviteCompetition(characterName, isObserver, isAssistant)
  ClearFocusEdit()
  _PA_LOG("LUA_COMPETITION", characterName .. tostring(isObserver))
  _PA_LOG("LUA_COMPETITION", "HandleClicked_CompetitionGameForHost_Summon : END")
end
function FGlobal_CompetitionGameForHost_TargetScore(score)
  _PA_LOG("LUA_COMPETITION", "FGlobal_CompetitionGameForHost_TargetScore : START")
  local self = competitionGameForHost
  self._targetScore = score
  self._txt_TargetScore:SetText(score)
  HandleClicked_ChangeCompetitionForHostOption()
  _PA_LOG("LUA_COMPETITION", tostring(self._targetScore))
  _PA_LOG("LUA_COMPETITION", "FGlobal_CompetitionGameForHost_TargetScore : END")
end
function FGlobal_CompetitionGameForHost_TimeLimit(timeLimit)
  _PA_LOG("LUA_COMPETITION", "FGlobal_CompetitionGameForHost_TimeLimit : START")
  local self = competitionGameForHost
  self._timeLimit = timeLimit
  self._txt_TimeLimit:SetText(timeLimit)
  HandleClicked_ChangeCompetitionForHostOption()
  _PA_LOG("LUA_COMPETITION", tostring(self._timeLimit))
  _PA_LOG("LUA_COMPETITION", "FGlobal_CompetitionGameForHost_TimeLimit : START")
end
function FGlobal_CompetitionGameForHost_LevelLimit(levelLimit)
  _PA_LOG("LUA_COMPETITION", "FGlobal_CompetitionGameForHost_LevelLimit : START")
  local self = competitionGameForHost
  self._levelLimit = levelLimit
  self._txt_LevelLimit:SetText(levelLimit)
  HandleClicked_ChangeCompetitionForHostOption()
  _PA_LOG("LUA_COMPETITION", tostring(self._levelLimit))
  _PA_LOG("LUA_COMPETITION", "FGlobal_CompetitionGameForHost_LevelLimit : END")
end
function FGlobal_CompetitionGameForHost_PartyMemberCount(partyMemberCount)
  _PA_LOG("LUA_COMPETITION", "FGlobal_CompetitionGameForHost_PartyMemberCount : START")
  local self = competitionGameForHost
  self._maxPartyMemberCount = partyMemberCount
  self._txt_PartyMemberCount:SetText(partyMemberCount)
  HandleClicked_ChangeCompetitionForHostOption()
  _PA_LOG("LUA_COMPETITION", tostring(self._maxPartyMemberCount))
  _PA_LOG("LUA_COMPETITION", "FGlobal_CompetitionGameForHost_PartyMemberCount : END")
end
function FGlobal_CompetitionGameForHost_MaxWaitTime(waitTime)
  _PA_LOG("LUA_COMPETITION", "FGlobal_CompetitionGameForHost_MaxWaitTime : START")
  local self = competitionGameForHost
  self._maxWaitTime = waitTime
  self._txt_MaxWaitTime:SetText(waitTime)
  HandleClicked_ChangeCompetitionForHostOption()
  _PA_LOG("LUA_COMPETITION", tostring(self._maxWaitTime))
  _PA_LOG("LUA_COMPETITION", "FGlobal_CompetitionGameForHost_MaxWaitTime : END")
end
function CompetitionGame_HostIntoCompetition()
  ToClient_RequestEnterCompetitionHost()
end
function HandleClicked_CompetitionGameForHost_Kick(idx, isObserver)
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
function HandleClicked_CompetitionGameForHost_Resurrection(idx)
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
function FGlobal_CheckcompetitionGameUiEdit(targetUI)
  _PA_LOG("LUA_COMPETITION", "FGlobal_CheckcompetitionGameUiEdit : START")
  local self = competitionGameForHost
  _PA_LOG("LUA_COMPETITION", "FGlobal_CheckcompetitionGameUiEdit : END")
  return nil ~= targetUI and targetUI:GetKey() == self.edit_Name:GetKey()
end
function HandleClicked_FGlobal_competitionGameClearFocusEditEditText()
  _PA_LOG("LUA_COMPETITION", "HandleClicked_FGlobal_competitionGameClearFocusEditEditText : START")
  local self = competitionGameForHost
  self.edit_Name:SetEditText("", true)
  SetFocusEdit(self.edit_Name)
  _PA_LOG("LUA_COMPETITION", "HandleClicked_FGlobal_competitionGameClearFocusEditEditText : END")
end
function HandleClicked_competitionGameEditSetFocus()
  _PA_LOG("LUA_COMPETITION", "HandleClicked_competitionGameEditSetFocus : START")
  local self = competitionGameForHost
  SetFocusEdit(self.edit_Name)
  self.edit_Name:SetEditText(self.edit_Name:GetEditText(), true)
  _PA_LOG("LUA_COMPETITION", "HandleClicked_competitionGameEditSetFocus : END")
end
function HandleClicked_FGlobal_competitionGameClearFocusEditGameStart()
  local self = competitionGameForHost
  ToClient_RequestSetFight(CppEnums.CompetitionFightState.eCompetitionFightState_Wait, self._targetScore)
end
function HandleClicked_FGlobal_competitionGameClearFocusEditPause()
  ToClient_RequestSetFight(CppEnums.CompetitionFightState.eCompetitionFightState_Stop)
end
function HandleClicked_FGlobal_competitionGameClearFocusEditDone()
  ToClient_RequestSetFight(CppEnums.CompetitionFightState.eCompetitionFightState_Done)
end
function HandleClicked_FGlobal_competitionGameClearFocusEditAllPlayerResurrection()
  ToClient_RequestRebirthPlayerAll()
end
function FGlobal_competitionGameClearFocusEdit()
  ClearFocusEdit()
  CheckChattingInput()
end
function FGlobal_CompetitionGameForHost_NormalUser_Out()
  ToClient_RequestLeaveMyself()
end
function FGlobal_CompetitionGameForHost_Open()
  _PA_LOG("LUA_COMPETITION", "FGlobal_CompetitionGameForHost_Open : START")
  Panel_CompetitionGameForHost:SetShow(true)
  RefreshMatchModeButton()
  _PA_LOG("LUA_COMPETITION", "FGlobal_CompetitionGameForHost_Open : END")
end
function FGlobal_CompetitionGameForHost_Close()
  _PA_LOG("LUA_COMPETITION", "FGlobal_CompetitionGameForHost_Close : START")
  Panel_CompetitionGameForHost:SetShow(false)
  FGlobal_CompetitionTeamSet_Close()
  _PA_LOG("LUA_COMPETITION", "FGlobal_CompetitionGameForHost_Close : END")
end
function HandleClicked_ModeChange(matchMode)
  _PA_LOG("LUA_COMPETITION", "HandleClicked_ModeChange : START")
  local self = competitionGameForHost
  ToClient_CompetitionMatchTypeChange(matchMode)
  ToClient_RequestCompetitionOption(self._isOpen, self._timeLimit, self._targetScore, self._levelLimit, self._maxPartyMemberCount, self._maxWaitTime)
  _PA_LOG("LUA_COMPETITION", "HandleClicked_ModeChange : END")
end
function HandleClicked_OpenOrClose()
  _PA_LOG("LUA_COMPETITION", "HandleClicked_OpenOrClose : START")
  local self = competitionGameForHost
  local isOpen = ToClient_IsCompetitionOpen_HostOnly()
  self._isOpen = not isOpen
  HandleClicked_ChangeCompetitionForHostOption()
  _PA_LOG("LUA_COMPETITION", "HandleClicked_OpenOrClose : END")
end
function HandleClicked_ChangeCompetitionForHostOption()
  _PA_LOG("LUA_COMPETITION", "HandleClicked_ChangeCompetitionForHostOption : START")
  local self = competitionGameForHost
  if ToClient_IsCompetitionHost() == true then
    ToClient_RequestCompetitionOption(self._isOpen, self._timeLimit, self._targetScore, self._levelLimit, self._maxPartyMemberCount, self._maxWaitTime)
  end
  _PA_LOG("LUA_COMPETITION", "HandleClicked_ChangeCompetitionForHostOption : END")
end
function HandleChangeOption(isOpen, matchTimeLimit, targetScore, levelLimit, maxPartyMemberCount, maxWaitTime)
  _PA_LOG("LUA_COMPETITION", "HandleChangeOption : START")
  local self = competitionGameForHost
  if true == isOpen then
    self._btn_OpenOrClose:SetText("Close")
  else
    self._btn_OpenOrClose:SetText("Open")
  end
  self._isOpen = isOpen
  self._targetScore = targetScore
  self._timeLimit = matchTimeLimit
  self._levelLimit = levelLimit
  self._maxPartyMemberCount = maxPartyMemberCount
  self._maxWaitTime = maxWaitTime
  self._txt_TargetScore:SetText(self._targetScore)
  self._txt_TimeLimit:SetText(self._timeLimit)
  self._txt_LevelLimit:SetText(self._levelLimit)
  self._txt_PartyMemberCount:SetText(self._maxPartyMemberCount)
  self._txt_MaxWaitTime:SetText(self._maxWaitTime)
  _PA_LOG("LUA_COMPETITION", tostring(isOpen))
  _PA_LOG("LUA_COMPETITION", tostring(targetScore))
  _PA_LOG("LUA_COMPETITION", tostring(matchTimeLimit))
  _PA_LOG("LUA_COMPETITION", tostring(levelLimit))
  _PA_LOG("LUA_COMPETITION", tostring(maxPartyMemberCount))
  _PA_LOG("LUA_COMPETITION", "HandleChangeOption : END")
end
function RefreshMatchModeButton()
  local self = competitionGameForHost
  local matchMode = ToClient_CompetitionMatchType()
  _PA_LOG("LUA_COMPETITION", "RefreshMatchModeButton : START")
  _PA_LOG("LUA_COMPETITION", tostring(matchMode))
  if CppEnums.CompetitionMatchType.eCompetitionMatchMode_Round == matchMode then
    self._radioBtn_RoundMode:SetCheck(true)
    self._radioBtn_FreeForAll:SetCheck(false)
  elseif CppEnums.CompetitionMatchType.eCompetitionMatchMode_FreeForAll == matchMode then
    self._radioBtn_RoundMode:SetCheck(false)
    self._radioBtn_FreeForAll:SetCheck(true)
  end
  self._targetScore = ToClient_GetTargetScore()
  self._timeLimit = ToClient_CompetitionMatchTimeLimit()
  self._levelLimit = ToClient_GetLevelLimit()
  self._maxPartyMemberCount = ToClient_GetMaxPartyMemberCount()
  self._txt_TargetScore:SetText(self._targetScore)
  self._txt_TimeLimit:SetText(self._timeLimit)
  self._txt_LevelLimit:SetText(self._levelLimit)
  self._txt_PartyMemberCount:SetText(self._maxPartyMemberCount)
  _PA_LOG("LUA_COMPETITION", tostring(self._targetScore))
  _PA_LOG("LUA_COMPETITION", tostring(self._timeLimit))
  _PA_LOG("LUA_COMPETITION", tostring(self._levelLimit))
  _PA_LOG("LUA_COMPETITION", tostring(self._maxPartyMemberCount))
  _PA_LOG("LUA_COMPETITION", "RefreshMatchModeButton : END")
end
function HandleClicked_CompetitionGameForHost_GameStart()
  local self = competitionGameForHost
  _PA_LOG("LUA_COMPETITION", "HandleClicked_CompetitionGameForHost_GameStart : START")
  ToClient_RequestSetFight(CppEnums.CompetitionFightState.eCompetitionFightState_Wait, self._targetScore)
  _PA_LOG("LUA_COMPETITION", tostring(self._targetScore))
  _PA_LOG("LUA_COMPETITION", "HandleClicked_CompetitionGameForHost_GameStart : END")
end
function HandleClicked_CompetitionGameForHost_Pause()
  _PA_LOG("LUA_COMPETITION", "HandleClicked_CompetitionGameForHost_Pause : START")
  ToClient_RequestSetFight(CppEnums.CompetitionFightState.eCompetitionFightState_Stop)
  _PA_LOG("LUA_COMPETITION", "HandleClicked_CompetitionGameForHost_Pause : END")
end
function HandleClicked_CompetitionGameForHost_Done()
  _PA_LOG("LUA_COMPETITION", "HandleClicked_CompetitionGameForHost_Done : START")
  ToClient_RequestSetFight(CppEnums.CompetitionFightState.eCompetitionFightState_Done)
  _PA_LOG("LUA_COMPETITION", "HandleClicked_CompetitionGameForHost_Done : END")
end
function HandleClicked_CompetitionGameForHost_AllPlayerResurrection()
  _PA_LOG("LUA_COMPETITION", "HandleClicked_CompetitionGameForHost_AllPlayerResurrection : START")
  ToClient_RequestRebirthPlayerAll()
  _PA_LOG("LUA_COMPETITION", "HandleClicked_CompetitionGameForHost_AllPlayerResurrection : END")
end
function HandleClicked_CompetitionGameForHost_EditText()
  _PA_LOG("LUA_COMPETITION", "HandleClicked_CompetitionGameForHost_EditText : START")
  local self = competitionGameForHost
  self.edit_Name:SetEditText("", true)
  SetFocusEdit(self.edit_Name)
  _PA_LOG("LUA_COMPETITION", tostring(self.edit_Name))
  _PA_LOG("LUA_COMPETITION", "HandleClicked_CompetitionGameForHost_EditText : END")
end
function CompetitionGameForHost_Event()
  _PA_LOG("LUA_COMPETITION", "CompetitionGameForHost_Event : START")
  local self = competitionGameForHost
  self.edit_Name:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGameForHost_EditText()")
  self.btn_Summon:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGameForHost_Summon()")
  self.edit_Name:RegistReturnKeyEvent("HandleClicked_CompetitionGameForHost_Summon()")
  self.btn_Close:addInputEvent("Mouse_LUp", "FGlobal_CompetitionGameForHost_Close()")
  self._btn_Start:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGameForHost_GameStart()")
  self._btn_Pause:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGameForHost_Done()")
  self._btn_AllResurrection:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionGameForHost_AllPlayerResurrection()")
  self._btn_InviteList:addInputEvent("Mouse_LUp", "FGlobal_CompetitionGame_InviteList_Open()")
  self._btn_TargetScore:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTargetScoreSet_Open(0)")
  self._btn_TimeLimit:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTargetScoreSet_Open(1)")
  self._btn_LevelLimit:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTargetScoreSet_Open(2)")
  self._btn_PartyMemberCount:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTargetScoreSet_Open(3)")
  self._btn_MaxWaitTime:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTargetScoreSet_Open(4)")
  self._radioBtn_RoundMode:addInputEvent("Mouse_LUp", "HandleClicked_ModeChange(" .. CppEnums.CompetitionMatchType.eCompetitionMatchMode_Round .. ")")
  self._radioBtn_FreeForAll:addInputEvent("Mouse_LUp", "HandleClicked_ModeChange(" .. CppEnums.CompetitionMatchType.eCompetitionMatchMode_FreeForAll .. ")")
  self._btn_OpenOrClose:addInputEvent("Mouse_LUp", "HandleClicked_OpenOrClose()")
  registerEvent("FromClient_CompetitionOptionChanged", "HandleChangeOption")
  _PA_LOG("LUA_COMPETITION", "CompetitionGameForHost_Event : END")
end
CompetitionGameForHost_Init()
CompetitionGameForHost_Event()

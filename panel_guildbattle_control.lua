local isShowGuildBattleCam = true
PaGlobal_GuildBattle_Control = {_elapsedTime = 0}
local HideIfShowing = function(panel)
  if true == panel:IsShow() then
    panel:Show(false)
  end
end
local ShowIfNotShowing = function(panel)
  if true ~= panel:IsShow() then
    panel:Show(true)
  end
end
function FGlobal_GuildBattle_IsOpen()
  return true == PaGlobal_GuildBattlePoint:IsShow() or true == PaGlobal_GuildBattle_SelectEntry:IsShow() or true == PaGlobal_GuildBattle_SelectAttend:IsShow()
end
local function UpdatePanelsVisibility()
  local isMaster = ToClient_GuildBattle_AmIMasterForThisBattle()
  local battleState = ToClient_GuildBattle_GetCurrentState()
  if __eGuildBattleState_Idle == battleState then
    HideIfShowing(PaGlobal_GuildBattlePoint)
    HideIfShowing(PaGlobal_GuildBattle_SelectEntry)
    HideIfShowing(PaGlobal_GuildBattle_SelectAttend)
    ShowIfNotShowing(PaGlobal_GuildBattle_JoinMember)
  elseif __eGuildBattleState_Join == battleState then
    if true == ToClient_getJoinGuildBattle() then
      ShowIfNotShowing(PaGlobal_GuildBattlePoint)
    else
      HideIfShowing(PaGlobal_GuildBattlePoint)
    end
    HideIfShowing(PaGlobal_GuildBattle_SelectEntry)
    HideIfShowing(PaGlobal_GuildBattle_SelectAttend)
    HideIfShowing(PaGlobal_GuildBattle_JoinMember)
  elseif __eGuildBattleState_SelectEntry == battleState then
    ShowIfNotShowing(PaGlobal_GuildBattlePoint)
    if false == ToClient_isPersonalBattle() then
      ShowIfNotShowing(PaGlobal_GuildBattle_SelectEntry)
    end
    HideIfShowing(PaGlobal_GuildBattle_SelectAttend)
    HideIfShowing(PaGlobal_GuildBattle_JoinMember)
  elseif __eGuildBattleState_SelectAttend == battleState then
    ShowIfNotShowing(PaGlobal_GuildBattlePoint)
    HideIfShowing(PaGlobal_GuildBattle_SelectEntry)
    if true == isMaster or true == ToClient_isPersonalBattle() then
      ShowIfNotShowing(PaGlobal_GuildBattle_SelectAttend)
    end
    HideIfShowing(PaGlobal_GuildBattle_JoinMember)
  elseif __eGuildBattleState_Ready == battleState then
    ShowIfNotShowing(PaGlobal_GuildBattlePoint)
    HideIfShowing(PaGlobal_GuildBattle_SelectEntry)
    HideIfShowing(PaGlobal_GuildBattle_SelectAttend)
    HideIfShowing(PaGlobal_GuildBattle_JoinMember)
  elseif __eGuildBattleState_Fight == battleState then
    ShowIfNotShowing(PaGlobal_GuildBattlePoint)
    HideIfShowing(PaGlobal_GuildBattle_SelectEntry)
    HideIfShowing(PaGlobal_GuildBattle_SelectAttend)
    HideIfShowing(PaGlobal_GuildBattle_JoinMember)
  elseif __eGuildBattleState_End == battleState then
    ShowIfNotShowing(PaGlobal_GuildBattlePoint)
    HideIfShowing(PaGlobal_GuildBattle_SelectEntry)
    HideIfShowing(PaGlobal_GuildBattle_SelectAttend)
    HideIfShowing(PaGlobal_GuildBattle_JoinMember)
  elseif __eGuildBattleState_Teleport == battleState then
    ShowIfNotShowing(PaGlobal_GuildBattlePoint)
    HideIfShowing(PaGlobal_GuildBattle_SelectEntry)
    HideIfShowing(PaGlobal_GuildBattle_SelectAttend)
    HideIfShowing(PaGlobal_GuildBattle_JoinMember)
  else
    _PA_ASSERT(false, "\236\131\136\235\161\156\236\154\180 BattleState\234\176\128 \236\182\148\234\176\128\235\144\156 \235\147\175\237\149\169\235\139\136\235\139\164. \236\189\148\235\147\156\235\165\188 \236\151\133\235\141\176\236\157\180\237\138\184 \237\149\180\236\163\188\236\132\184\236\154\148.")
  end
end
local ShowBattleStateChangeMessage = function(state)
  if false == ToClient_isPersonalBattle() then
    local progressServer = ToClient_GuildBattle_GetMyGuildBattleServer()
    local curChannelData = getCurrentChannelServerData()
    if progressServer == 0 or progressServer ~= curChannelData._serverNo then
      return
    end
  end
  local msg = {
    main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_USE_GUILDWINDOW"),
    sub = PaGlobal_GuildBattle:GetTitle(),
    addMsg = ""
  }
  if state == __eGuildBattleState_Idle then
    return
  elseif state == __eGuildBattleState_Join then
    msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_USE_GUILDWINDOW")
    msg.sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_MATCH_SUCCESS")
  elseif state == __eGuildBattleState_SelectEntry then
    if true == ToClient_isPersonalBattle() then
      return
    else
      msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_STARTSELECT_ENTRY")
    end
  elseif state == __eGuildBattleState_SelectAttend then
    if true == ToClient_isPersonalBattle() then
      msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_STARTSELECT_ATTEND")
    else
      msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_STARTSELECT_ATTEND")
    end
  elseif state == __eGuildBattleState_Ready then
    if true == ToClient_isPersonalBattle() then
      msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_READYSTATE")
    else
      msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_READYSTATE")
    end
  elseif state == __eGuildBattleState_Fight then
    if true == ToClient_isPersonalBattle() then
      msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_FIGHTSTART")
    else
      msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_FIGHTSTART")
    end
  elseif state == __eGuildBattleState_End then
    local winnerGuildNo = ToClient_GuildBattle_GetWinGuildNo()
    if true == ToClient_isPersonalBattle() then
      msg.sub = PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_END")
    else
      msg.sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_END")
    end
    if Int64toInt32(winnerGuildNo) == -1 then
      msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_MATCH_DONE_DRAW")
    elseif true == ToClient_isPersonalBattle() then
      local battleResultReason = ToClient_GuildBattle_GetBattleResultReason()
      if true == ToClient_isPersonalBattleWin() then
        if __eGuildBattleResultReason_NoMaster == battleResultReason then
          msg.sub = PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_OTHERTEAM_MASTER_OUT")
        elseif __eGuildBattleResultReason_TooManyPlayerOut == battleResultReason then
          msg.sub = PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_OTHERTEAM_MANYPLAYER_OUT")
        end
        msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_WIN")
      else
        if __eGuildBattleResultReason_NoMaster == battleResultReason then
          msg.sub = PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_MYTEAM_MASTER_OUT")
        elseif __eGuildBattleResultReason_TooManyPlayerOut == battleResultReason then
          msg.sub = PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_MYTEAM_MANYPLAYER_OUT")
        end
        msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_LOSE")
      end
    else
      local guildName = ToClient_guild_getGuildName(winnerGuildNo)
      msg.main = tostring(guildName) .. " " .. tostring(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_WINNER"))
    end
  elseif state == __eGuildBattleState_Teleport then
    return
  else
    self._CanCancel = false
    return
  end
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 6, 78, false)
end
function FGlobal_GuildBattle_UpdatePerFrame(deltaTime)
  if nil == ToClient_GuildBattle_IsInGuildBattle or nil == PaGlobal_GuildBattle_SelectEntry or nil == PaGlobal_GuildBattle_SelectAttend or nil == PaGlobal_GuildBattlePoint or nil == PaGlobal_GuildBattle_Control or nil == PaGlobal_GuildBattle then
    return
  end
  PaGlobal_GuildBattle_Control._elapsedTime = PaGlobal_GuildBattle_Control._elapsedTime + deltaTime
  if PaGlobal_GuildBattle_Control._elapsedTime >= 0.2 then
    ToClient_GuildBattle_UpdateTimerPerFrame()
    if true == ToClient_getJoinGuildBattle() then
      UpdatePanelsVisibility()
      if true == PaGlobal_GuildBattle_SelectEntry:IsShow() then
        PaGlobal_GuildBattle_SelectEntry:UpdateRemainTime()
      end
      if true == PaGlobal_GuildBattle_SelectAttend:IsShow() then
        PaGlobal_GuildBattle_SelectAttend:UpdateRemainTime()
      end
      if true == PaGlobal_GuildBattlePoint:IsShow() then
        PaGlobal_GuildBattlePoint:UpdateRemainTime()
      end
    end
    if true == PaGlobal_GuildBattle:IsShow() then
      PaGlobal_GuildBattle:UpdateRemainTime()
    end
    PaGlobal_GuildBattle_Control._elapsedTime = PaGlobal_GuildBattle_Control._elapsedTime - 0.2
  end
end
function FromClient_GuildBattle_Control_Initialize()
  PaGlobal_GuildBattle_Control._elapsedTime = 0
  HideIfShowing(PaGlobal_GuildBattle_SelectEntry)
  HideIfShowing(PaGlobal_GuildBattle_SelectAttend)
  HideIfShowing(PaGlobal_GuildBattlePoint)
end
function FromClient_GuildBattle_GuildBattleTimerEnd()
end
function FromClient_GuildBattle_Emergency_Ringout(count)
  msg = {
    main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_EMERGENCY_RINGOUT", "count", count),
    sub = PaGlobal_GuildBattle:GetTitle(),
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 6, 78, false)
end
function FromClient_GuildBattle_FightEnd(winState, isRingOut)
  msg = {
    main = "",
    sub = PaGlobal_GuildBattle:GetTitle(),
    addMsg = ""
  }
  if winState == __eGuildBattleWinState_Win then
    if true == isRingOut then
      msg.sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_RINGOUT_WIN")
    end
    msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_WINFIGHT")
  elseif winState == __eGuildBattleWinState_Lose then
    if true == isRingOut then
      msg.sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_RINGOUT_LOSE")
    end
    msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_LOSEFIGHT")
  elseif winState == __eGuildBattleWinState_Draw then
    msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_DRAWFIGHT")
  else
    _PA_ASSERT(false, "\236\131\136\235\161\156\236\154\180 WinState\234\176\128 \236\131\157\234\178\188\236\138\181\235\139\136\234\185\140? winState=" .. winState)
    return
  end
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 6, 78, false)
  PaGlobal_GuildBattlePoint:clearAttendName()
end
function FromClient_GuildBattle_OnUpdateBattleInfo()
  if true == PaGlobal_GuildBattle_SelectEntry:IsShow() then
    PaGlobal_GuildBattle_SelectEntry:UpdateMemberInfo()
  end
  if true == PaGlobal_GuildBattle_SelectAttend:IsShow() then
    PaGlobal_GuildBattle_SelectAttend:UpdateMemberInfo()
  end
  if true == PaGlobal_GuildBattlePoint:IsShow() then
    PaGlobal_GuildBattlePoint:UpdateRoundAndScore()
  end
  if true == PaGlobal_GuildBattle:IsShow() then
    PaGlobal_GuildBattle:UpdateGuildBattleInfo()
  end
end
function FromClient_GuildBattle_OnChangeBattleState()
  local battleState = ToClient_GuildBattle_GetCurrentState()
  if true == ToClient_getJoinGuildBattle() then
    ShowBattleStateChangeMessage(battleState)
    UpdatePanelsVisibility()
    if true == PaGlobal_GuildBattle_SelectEntry:IsShow() then
      PaGlobal_GuildBattle_SelectEntry:UpdateMemberInfo()
      PaGlobal_GuildBattle_SelectEntry:UpdateRemainTime()
    end
    if true == PaGlobal_GuildBattle_SelectAttend:IsShow() then
      PaGlobal_GuildBattle_SelectAttend:UpdateMemberInfo()
      PaGlobal_GuildBattle_SelectAttend:UpdateRemainTime()
    end
    if true == PaGlobal_GuildBattlePoint:IsShow() then
      PaGlobal_GuildBattlePoint:UpdateRoundAndScore()
      PaGlobal_GuildBattlePoint:UpdateRemainTime()
    end
  end
  if true == PaGlobal_GuildBattle:IsShow() then
    PaGlobal_GuildBattle:UpdateGuildBattleInfo()
  end
end
function FromClient_GuildBattle_UnjoinBattle()
  PaGlobal_GuildBattle_Control._elapsedTime = 0
  HideIfShowing(PaGlobal_GuildBattle_SelectEntry)
  HideIfShowing(PaGlobal_GuildBattle_SelectAttend)
  HideIfShowing(PaGlobal_GuildBattlePoint)
end
function FromClient_GuildBattle_OurMemberJoined_GuildBattleControl(userNo)
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil == guildWrapper then
    return
  end
  local memberInfo = guildWrapper:getMemberByUserNo(userNo)
  if nil == memberInfo then
    return
  end
  local userName = ""
  if true == memberInfo:isOnline() then
    userName = memberInfo:getCharacterName()
  else
    userName = memberInfo:getName()
  end
  msg = {
    main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_PLAYERJOINED", "characterName", userName),
    sub = PaGlobal_GuildBattle:GetTitle(),
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 78, false)
end
function FromClient_GuildBattle_OurMemberUnjoined_GuildBattleControl(userNo, isMyTeamMasterOut)
  local userName = ""
  if false == ToClient_isPersonalBattle() then
    local guildWrapper = ToClient_GetMyGuildInfoWrapper()
    if nil == guildWrapper then
      return
    end
    local memberInfo = guildWrapper:getMemberByUserNo(userNo)
    if nil == memberInfo then
      return
    end
    if true == memberInfo:isOnline() then
      userName = memberInfo:getCharacterName()
    else
      userName = memberInfo:getName()
    end
  else
    local memberInfo = Toclient_getPersonalBattleMemberInfo(userNo)
    if nil == memberInfo then
      return
    end
    userName = memberInfo:getCharacterName()
  end
  msg = {
    main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_PLAYERUNJOINED", "characterName", userName),
    sub = PaGlobal_GuildBattle:GetTitle(),
    addMsg = ""
  }
  if true == ToClient_isPersonalBattle() and true == isMyTeamMasterOut then
    msg.main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_MASTERUNJOINED", "characterName", userName)
  end
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 78, false)
  if true == PaGlobal_GuildBattle_SelectEntry:IsShow() then
    PaGlobal_GuildBattle_SelectEntry:UpdateMemberInfo()
  end
  if true == PaGlobal_GuildBattle_SelectAttend:IsShow() then
    PaGlobal_GuildBattle_SelectAttend:UpdateMemberInfo()
  end
end
function FromClient_GuildBattle_SomeOneKilledSomeOne_ForWaitingState(attackerName, peerName)
  msg = {
    main = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_COMPETITION_USERDEAD_ATTACKED", "attackerName", attackerName, "deadUserName", peerName),
    sub = PaGlobal_GuildBattle:GetTitle(),
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 4.5, 78, false)
end
function FromClient_GuildBattle_SomeOneKilledSomeOne_GuildBattleControl(attackerName, peerName, attackerTeamNo, peerTeamNo)
  local attackerGuildInfo = ToClient_GuildBattle_GetCurrentServerGuildBattleInfo(attackerTeamNo)
  local peerGuildInfo = ToClient_GuildBattle_GetCurrentServerGuildBattleInfo(peerTeamNo)
  if nil == attackerGuildInfo or nil == peerGuildInfo then
    return
  end
  if true == ToClient_isPersonalBattle() then
    if 0 == attackerTeamNo then
      attackerguildName = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_1")
      peerguildName = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_2")
    else
      attackerguildName = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_2")
      peerguildName = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_1")
    end
  else
    attackerguildName = attackerGuildInfo:getName()
    peerguildName = peerGuildInfo:getName()
  end
  msg = {
    main = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_SOMEONEKILLEDSOMEONE", "attackerName", attackerName, "attackGuildName", attackerguildName, "peerName", peerName, "peerGuildName", peerguildName),
    sub = PaGlobal_GuildBattle:GetTitle(),
    addMsg = ""
  }
  if true == ToClient_isPersonalBattle() then
    msg.main = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_SOMEONEKILLEDSOMEONE", "attackerName", attackerName, "attackGuildName", attackerguildName, "peerName", peerName, "peerGuildName", peerguildName)
  end
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 4.5, 78, false)
end
function FromClient_GuildBattle_AttendPlayer_GuildBattleControl()
  msg = {
    main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_SELECTED_PARTICIPANT"),
    sub = PaGlobal_GuildBattle:GetTitle(),
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 78, false)
end
GuildWatchMode = {
  UI_BG = UI.getChildControl(Panel_GuildBattleWatchingMode, "Static_CommandBG"),
  UI_KeyQ = UI.getChildControl(Panel_GuildBattleWatchingMode, "StaticText_Key_Q"),
  UI_KeyE = UI.getChildControl(Panel_GuildBattleWatchingMode, "StaticText_Key_E"),
  UI_KeyR = UI.getChildControl(Panel_GuildBattleWatchingMode, "StaticText_Key_R"),
  UI_TextSmall = UI.getChildControl(Panel_GuildBattleWatchingMode, "StaticText_Small"),
  UI_TextBig = UI.getChildControl(Panel_GuildBattleWatchingMode, "StaticText_Big"),
  UI_TextExit = UI.getChildControl(Panel_GuildBattleWatchingMode, "StaticText_Exit"),
  UI_TextDesc = UI.getChildControl(Panel_GuildBattleWatchingMode, "StaticText_CameraSpeedLow"),
  UI_ShowButton = UI.getChildControl(Panel_GuildBattleWatchingMode, "Button_ShowCommand"),
  UI_RemainTime = UI.getChildControl(Panel_GuildBattleWatchingMode, "StaticText_RemainTime"),
  _isSeigeWatching = false,
  _remainTime = -1
}
function HandleClick_WatchShowToggle()
  if true == GuildWatchMode.UI_BG:GetShow() then
    GuildWatchMode_SetControlShow(false)
  else
    GuildWatchMode_SetControlShow(true)
  end
end
function PaGlobal_GuildBattle_WatchModeStringSetting()
  if true == ToClient_isPersonalBattle() then
    GuildWatchMode.UI_TextSmall:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_WATCHING_START"))
    GuildWatchMode.UI_TextBig:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_WATCHING_FIND_NEXT"))
    GuildWatchMode.UI_TextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_WATCHING_DESC"))
  else
    GuildWatchMode.UI_TextSmall:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_WATCHING_START"))
    GuildWatchMode.UI_TextBig:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_WATCHING_FIND_NEXT"))
    GuildWatchMode.UI_TextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_WATCHING_DESC"))
  end
  local yPos = GuildWatchMode.UI_KeyE:GetPosY()
  if __eGuildBattleMode_OneOne ~= ToClient_GuildBattle_GetCurrentMode() then
    GuildWatchMode.UI_KeyE:SetShow(true)
    GuildWatchMode.UI_TextBig:SetShow(true)
    GuildWatchMode.UI_KeyR:SetPosY(yPos + 30)
    GuildWatchMode.UI_TextExit:SetPosY(yPos + 32)
  else
    GuildWatchMode.UI_KeyE:SetShow(false)
    GuildWatchMode.UI_TextBig:SetShow(false)
    GuildWatchMode.UI_TextSmall:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WATCHING_START"))
    GuildWatchMode.UI_TextSmall:SetPosY(yPos - 47)
    GuildWatchMode.UI_TextBig:SetText("")
    GuildWatchMode.UI_KeyR:SetPosY(yPos)
    GuildWatchMode.UI_TextExit:SetPosY(yPos + 2)
  end
end
function GuildWatchMode_SetControlShow(isShow)
  PaGlobal_GuildBattle_WatchModeStringSetting()
  GuildWatchMode.UI_BG:SetShow(isShow)
  GuildWatchMode.UI_KeyQ:SetShow(isShow)
  GuildWatchMode.UI_KeyE:SetShow(isShow)
  GuildWatchMode.UI_KeyR:SetShow(isShow)
  GuildWatchMode.UI_TextSmall:SetShow(isShow)
  GuildWatchMode.UI_TextBig:SetShow(isShow)
  GuildWatchMode.UI_TextExit:SetShow(isShow)
  GuildWatchMode.UI_TextDesc:SetShow(isShow)
  if false == isShow then
    Panel_GuildBattleWatchingMode:SetPosY(Panel_GuildBattleWatchingMode:GetPosY() + 200)
  else
    Panel_GuildBattleWatchingMode:SetPosY(Panel_GuildBattleWatchingMode:GetPosY() - 200)
  end
  if true == isShow and true == GuildWatchMode._isSeigeWatching then
    GuildWatchMode.UI_RemainTime:SetShow(isShow)
  else
    GuildWatchMode.UI_RemainTime:SetShow(isShow)
  end
end
function WatchingPanel_SetPosition()
  local ScrX = getScreenSizeX()
  local ScrY = getScreenSizeY()
  Panel_GuildBattleWatchingMode:SetSize(200, 320)
  Panel_GuildBattleWatchingMode:SetPosY(ScrY * 3 / 4)
  Panel_GuildBattleWatchingMode:ComputePos()
end
function FromClient_NotifyGuildTeamBattleShowWatchPanel(isShow)
  if false == isShowGuildBattleCam then
    ToClient_CanOpenGuildBattleCam(false)
    return
  end
  WatchingPanel_SetPosition()
  PaGlobal_GuildBattle_WatchModeStringSetting()
  GuildWatchMode.UI_BG:SetShow(isShow)
  GuildWatchMode.UI_KeyQ:SetShow(isShow)
  GuildWatchMode.UI_KeyE:SetShow(isShow)
  GuildWatchMode.UI_KeyR:SetShow(isShow)
  GuildWatchMode.UI_TextSmall:SetShow(isShow)
  GuildWatchMode.UI_TextBig:SetShow(isShow)
  GuildWatchMode.UI_TextExit:SetShow(isShow)
  GuildWatchMode.UI_TextDesc:SetShow(isShow)
  GuildWatchMode.UI_ShowButton:SetCheck(isShow)
  Panel_GuildBattleWatchingMode:SetShow(isShow)
  ToClient_CanOpenGuildBattleCam(isShow)
end
function FromClient_NotifyGuildBattleCameraMessage()
  return
end
function FromClient_FightTimeLeftMessage(fightTime)
  local min = math.floor(fightTime / 60)
  local sec = math.floor(fightTime % 60)
  local msg = {
    main = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_FIGHT_TIMELEFT", "min", tostring(min), "sec", tostring(sec)),
    sub = PaGlobal_GuildBattle:GetTitle(),
    addMsg = ""
  }
  if 0 == sec then
    msg.main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_FIGHT_TIMELEFT_MIN", "min", tostring(min))
  end
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 78, false)
end
function GuildBattle_UpdatePerFrame(deltaTime)
  if false == GuildWatchMode._isSeigeWatching then
    return
  end
  if nil == GuildWatchMode._remainTime then
    GuildWatchMode._isSeigeWatching = false
    Panel_GuildBattleWatchingMode:SetShow(false)
    FromClient_NotifySiegeShowWatchPanel(false)
    if true == ToClient_isBeingNationSiege() then
      ToClient_FirstPersonOpserverModeInNationSiege(false)
    else
      ToClient_FirstPersonOpserverModeInSiege(false)
    end
  end
  if GuildWatchMode._remainTime < 0 then
    GuildWatchMode._isSeigeWatching = false
    Panel_GuildBattleWatchingMode:SetShow(false)
    FromClient_NotifySiegeShowWatchPanel(false)
    if true == ToClient_isBeingNationSiege() then
      ToClient_FirstPersonOpserverModeInNationSiege(false)
    else
      ToClient_FirstPersonOpserverModeInSiege(false)
    end
  else
    GuildWatchMode._remainTime = GuildWatchMode._remainTime - deltaTime
    GuildWatchMode.UI_RemainTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWATCH_REMAINTIME", "time", tostring(math.floor(GuildWatchMode._remainTime))))
    GuildWatchMode.UI_RemainTime:SetShow(true)
  end
  if true == ToClient_isBeingNationSiege() then
    GuildWatchMode.UI_RemainTime:SetShow(false)
  end
end
Panel_GuildBattleWatchingMode:SetShow(false)
GuildWatchMode.UI_ShowButton:addInputEvent("Mouse_LUp", "HandleClick_WatchShowToggle()")
GuildWatchMode.UI_ShowButton:SetCheck(true)
Panel_GuildBattleWatchingMode:RegisterUpdateFunc("GuildBattle_UpdatePerFrame")
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildBattle_Control_Initialize")
registerEvent("FromClient_GuildBattle_FightEnd", "FromClient_GuildBattle_FightEnd")
registerEvent("FromClient_guildBattleTimer", "FromClient_GuildBattle_GuildBattleTimerEnd")
registerEvent("FromClient_responseRequestGuildBattleInfo", "FromClient_GuildBattle_OnUpdateBattleInfo")
registerEvent("FromClient_GuildBattle_StateChanged", "FromClient_GuildBattle_OnChangeBattleState")
registerEvent("FromClient_unjoinGuildBattle", "FromClient_GuildBattle_UnjoinBattle")
registerEvent("FromClient_GuildBattle_OurMemberJoined", "FromClient_GuildBattle_OurMemberJoined_GuildBattleControl")
registerEvent("FromClient_GuildBattle_OurMemberUnjoined", "FromClient_GuildBattle_OurMemberUnjoined_GuildBattleControl")
registerEvent("FromClient_GuildBattle_SomeOneKilledSomeOne", "FromClient_GuildBattle_SomeOneKilledSomeOne_GuildBattleControl")
registerEvent("FromClient_GuildBattle_AttendPlayer", "FromClient_GuildBattle_AttendPlayer_GuildBattleControl")
registerEvent("FromClient_NotifyGuildTeamBattleShowWatchPanel", "FromClient_NotifyGuildTeamBattleShowWatchPanel")
registerEvent("FromClient_NotifyGuildBattleCameraMessage", "FromClient_NotifyGuildBattleCameraMessage")
registerEvent("FromClient_FightTimeLeftMessage", "FromClient_FightTimeLeftMessage")
registerEvent("FromClient_GuildBattle_Emergency_Ringout", "FromClient_GuildBattle_Emergency_Ringout")
registerEvent("FromClient_GuildBattle_SomeOneKilledSomeOne_ForWaitingState", "FromClient_GuildBattle_SomeOneKilledSomeOne_ForWaitingState")

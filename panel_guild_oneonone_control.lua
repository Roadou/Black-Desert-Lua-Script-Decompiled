PaGlobal_Guild_OneOnOne_Control = {
  _ui = {},
  _msgType = {
    _preparing = 0,
    _startBuliding = 1,
    _startRequest = 2,
    _startAccept = 3,
    _battleRequested = 4,
    _noBattleRequested = 5,
    _battleAccepted = 6,
    _battleNotAccepted = 7,
    _doppingTime = 8,
    _fightStarted = 9,
    _battleResult = 10,
    _ringout = 11,
    _logout = 12,
    _gulidTeamBattleIng = 13
  }
}
function FGlobal_IsIgnoreOtherNak_GuildTeamBattleState()
  local state = ToClient_GetGuildTeamBattleState()
  if state == __eGuildTeamBattleState_Requesting or state == __eGuildTeamBattleState_Accepting or state == __eGuildTeamBattleState_Teleport or state == __eGuildTeamBattleState_Fight then
    return true
  end
  return false
end
local GetGuildWrapper = function(guildNo)
  local guildWrapper
  local isAlliance = false
  guildWrapper = ToClient_GetGuildAllianceWrapperbyNo(guildNo)
  if nil ~= guildWrapper then
    isAlliance = true
  else
    guildWrapper = ToClient_GetGuildWrapperByGuildNo(guildNo)
  end
  return isAlliance, guildWrapper
end
local GetTeamKind = function(isAlliance)
  if true == isAlliance then
    return PAGetString(Defines.StringSheet_GAME, "LUA_WORD_GUILDALLIANCE")
  else
    return PAGetString(Defines.StringSheet_GAME, "LUA_WORD_GUILD")
  end
end
local TruncateHpRate = function(value)
  value = value * 10
  value = math.floor(value)
  return value * 0.1
end
local function ShowGuildTeamBattleResultMessage(result, isAttackTeamWin)
  local attackTeamInfo = ToClient_GetGuildTeamBattleAttackTeam()
  local defenceTeamInfo = ToClient_GetGuildTeamBattleDefenceTeam()
  local strLoseTeamName = ""
  local strLoseTeamKind = ""
  local strLosePlayerName = ""
  if true == isAttackTeamWin then
    strLoseTeamName = defenceTeamInfo:getTeamName()
    strLosePlayerName = defenceTeamInfo:getPlayerName(0)
    strLoseTeamKind = GetTeamKind(defenceTeamInfo:isAlliance())
  else
    strLoseTeamName = attackTeamInfo:getTeamName()
    strLosePlayerName = attackTeamInfo:getPlayerName(0)
    strLoseTeamKind = GetTeamKind(attackTeamInfo:isAlliance())
  end
  local resultMessage = ""
  if __eGuildTeamBattleResult_WinNormal == result then
    resultMessage = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_NORMALWIN_WAITMESSAGE", "loseTeamName", strLoseTeamName, "loseTeamKind", strLoseTeamKind, "losePlayerName", strLosePlayerName)
    PaGlobal_Guild_OneOnOneClock:SetNoticeMessage(resultMessage)
  elseif __eGuildTeamBattleResult_AttendLogout == result then
    resultMessage = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_LOGOUTWIN_WAITMESSAGE", "loseTeamName", strLoseTeamName, "loseTeamKind", strLoseTeamKind, "losePlayerName", strLosePlayerName)
    PaGlobal_Guild_OneOnOneClock:SetNoticeMessage(resultMessage)
  elseif __eGuildTeamBattleResult_AttendRingout == result then
    resultMessage = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_RINGOUTWIN_WAITMESSAGE", "loseTeamName", strLoseTeamName, "loseTeamKind", strLoseTeamKind, "losePlayerName", strLosePlayerName)
    PaGlobal_Guild_OneOnOneClock:SetNoticeMessage(resultMessage)
  end
end
function FromClient_GuildTeamBattle_End(result, isAttackTeamWin, attackGuildNo, defenceGuildNo, attackTeamHpRate, defenceTeamHpRate)
  local message = {
    main = "",
    sub = "",
    addMsg = ""
  }
  local attackTeamInfo = ToClient_GetGuildTeamBattleAttackTeam()
  local defenceTeamInfo = ToClient_GetGuildTeamBattleDefenceTeam()
  local strAttackTeamName = attackTeamInfo:getTeamName()
  local strDefenceTeamName = defenceTeamInfo:getTeamName()
  local strAttackTeamKind = GetTeamKind(attackTeamInfo:isAlliance())
  local strDefenceTeamKind = GetTeamKind(defenceTeamInfo:isAlliance())
  local msgType = 95
  local soundType = PaGlobal_Guild_OneOnOne_Control._msgType._preparing
  if true == isAttackTeamWin then
    message.sub = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ATTACKTEAMWIN_MAIN", "attackTeamName", strAttackTeamName, "attackTeamKind", strAttackTeamKind)
  else
    message.sub = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_DEFENCETEAMWIN_MAIN", "defenceTeamName", strDefenceTeamName, "defenceTeamKind", defenceTeamKind)
  end
  if __eGuildTeamBattleResult_WinNormal == result or __eGuildTeamBattleResult_WinByTimeout == result or __eGuildTeamBattleResult_WinByNoMaster == result or __eGuildTeamBattleResult_Draw == result or __eGuildTeamBattleResult_AttendLogout == result or __eGuildTeamBattleResult_AttendRingout == result then
    local winTeamInfo, loseTeamInfo
    if true == isAttackTeamWin then
      winTeamInfo = attackTeamInfo
      loseTeamInfo = defenceTeamInfo
    else
      winTeamInfo = defenceTeamInfo
      loseTeamInfo = attackTeamInfo
    end
    local strWinTeamName = ""
    local strLoseTeamName = ""
    local strWinPlayerName = ""
    local strLosePlayerName = ""
    strWinTeamName = winTeamInfo:getTeamName()
    strWinPlayerName = winTeamInfo:getPlayerName(0)
    strLoseTeamName = loseTeamInfo:getTeamName()
    strLosePlayerName = loseTeamInfo:getPlayerName(0)
    if true == winTeamInfo:isAlliance() and true == loseTeamInfo:isAlliance() then
      message.main = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_DEFEATMESSAGE_ALLIANCE_VS_ALLIANCE", "teamName1", strWinTeamName, "playerName1", strWinPlayerName, "teamName2", strLoseTeamName, "playerName2", strLosePlayerName)
    elseif false == winTeamInfo:isAlliance() and true == loseTeamInfo:isAlliance() then
      message.main = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_DEFEATMESSAGE_GUILD_VS_ALLIANCE", "teamName1", strWinTeamName, "playerName1", strWinPlayerName, "teamName2", strLoseTeamName, "playerName2", strLosePlayerName)
    elseif true == winTeamInfo:isAlliance() and false == loseTeamInfo:isAlliance() then
      message.main = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_DEFEATMESSAGE_ALLIANCE_VS_GUILD", "teamName1", strWinTeamName, "playerName1", strWinPlayerName, "teamName2", strLoseTeamName, "playerName2", strLosePlayerName)
    else
      message.main = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_DEFEATMESSAGE_GUILD_VS_GUILD", "teamName1", strWinTeamName, "playerName1", strWinPlayerName, "teamName2", strLoseTeamName, "playerName2", strLosePlayerName)
    end
    if true == ToClient_IsSelfPlayerInGuildTeamBattleTerritory() then
      msgType = 99
    else
      msgType = 95
    end
    soundType = PaGlobal_Guild_OneOnOne_Control._msgType._battleResult
    ShowGuildTeamBattleResultMessage(result, isAttackTeamWin)
  elseif __eGuildTeamBattleResult_DefenceTeamNotRespond == result then
    message.main = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_NOTMATCHED_SUB_NOTRESPONSE", "attackTeamName", strAttackTeamName, "attackTeamKind", strAttackTeamKind, "defenceTeamName", strDefenceTeamName, "defenceTeamKind", strDefenceTeamKind)
    if true == ToClient_IsSelfPlayerInGuildTeamBattleTerritory() then
      msgType = 98
    else
      msgType = 94
    end
    soundType = PaGlobal_Guild_OneOnOne_Control._msgType._battleNotAccepted
  elseif __eGuildTeamBattleResult_Rejected == result then
    message.main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_NOTMATCHED_SUB_REJECTED")
    if true == ToClient_IsSelfPlayerInGuildTeamBattleTerritory() then
      msgType = 98
    else
      msgType = 94
    end
    soundType = PaGlobal_Guild_OneOnOne_Control._msgType._battleNotAccepted
  else
    return
  end
  Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, msgType, false, soundType)
  if __eGuildTeamBattleResult_WinByTimeout == result or __eGuildTeamBattleResult_Draw == result then
    attackTeamHpRate = TruncateHpRate(attackTeamHpRate)
    defenceTeamHpRate = TruncateHpRate(defenceTeamHpRate)
    local msg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_END_SUB_TIMEOUTWIN", "attackTeamHpRate", attackTeamHpRate, "defenceTeamHpRate", defenceTeamHpRate)
    if "" ~= msg and nil ~= msg then
      Proc_ShowMessage_Ack(msg)
    end
  end
end
function FromClient_GuildTeamBattle_RequestDone(attackTeamInfo, defenceTeamInfo)
  local strAttackTeamName = attackTeamInfo:getTeamName()
  local strDefenceTeamName = defenceTeamInfo:getTeamName()
  local strAttackPlayerName = attackTeamInfo:getPlayerName(0)
  local strDefencePlayerName = defenceTeamInfo:getPlayerName(0)
  local isAttackAlliance = attackTeamInfo:isAlliance()
  local isDefenceAlliance = defenceTeamInfo:isAlliance()
  local msgMain = ""
  local msgSub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTBATTLE_MAIN")
  if true == isAttackAlliance and true == isDefenceAlliance then
    msgMain = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTED_ALLIANCE_VS_ALLIANCE", "attackTeamName", strAttackTeamName, "attackPlayerName", strAttackPlayerName, "defenceTeamName", strDefenceTeamName)
  elseif false == isAttackAlliance and true == isDefenceAlliance then
    msgMain = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTED_GUILD_VS_ALLIANCE", "attackTeamName", strAttackTeamName, "attackPlayerName", strAttackPlayerName, "defenceTeamName", strDefenceTeamName)
  elseif true == isAttackAlliance and false == isDefenceAlliance then
    msgMain = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTED_ALLIANCE_VS_GUILD", "attackTeamName", strAttackTeamName, "attackPlayerName", strAttackPlayerName, "defenceTeamName", strDefenceTeamName)
  else
    msgMain = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTED_GUILD_VS_GUILD", "attackTeamName", strAttackTeamName, "attackPlayerName", strAttackPlayerName, "defenceTeamName", strDefenceTeamName)
  end
  local message = {
    main = msgMain,
    sub = msgSub,
    addMsg = ""
  }
  local msgType = 96
  if false == ToClient_IsSelfPlayerInGuildTeamBattleTerritory() then
    msgType = 92
  else
    msgType = 96
  end
  Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 5, msgType, false, PaGlobal_Guild_OneOnOne_Control._msgType._battleRequested)
end
function FromClient_GuildTeamBattle_AcceptDone(attackTeamInfo, defenceTeamInfo)
  local strAttackTeamName = attackTeamInfo:getTeamName()
  local strAttackTeamKind = GetTeamKind(attackTeamInfo:isAlliance())
  local strDefenceTeamName = defenceTeamInfo:getTeamName()
  local strDefenceTeamKind = GetTeamKind(defenceTeamInfo:isAlliance())
  local strDefencePlayerName = defenceTeamInfo:getPlayerName(0)
  local msgMain = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ACCEPTED_SUB", "attackTeamName", strAttackTeamName, "attackTeamKind", strAttackTeamKind, "defenceTeamName", strDefenceTeamName, "defenceTeamKind", strDefenceTeamKind)
  local msgSub = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ACCEPTED", "defenceTeamName", strDefenceTeamName, "defenceTeamKind", strDefenceTeamKind, "defencePlayerName", strDefencePlayerName)
  local message = {
    main = msgMain,
    sub = msgSub,
    addMsg = ""
  }
  local msgType = 97
  if true == ToClient_IsSelfPlayerInGuildTeamBattleTerritory() then
    msgType = 97
  else
    msgType = 93
  end
  Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 5, msgType, false, PaGlobal_Guild_OneOnOne_Control._msgType._battleAccepted)
end
local checkHideOrShowPanel = function(state)
  if false == ToClient_IsSelfPlayerInGuildTeamBattleTerritory() then
    PaGlobal_Guild_OneOnOneClock:Close()
    return
  end
  if __eGuildTeamBattleState_Idle == state then
    PaGlobal_Guild_OneOnOneClock:Close()
  elseif __eGuildTeamBattleState_Preparing == state then
    PaGlobal_Guild_OneOnOneClock:Close()
  elseif __eGuildTeamBattleState_Building == state then
    PaGlobal_Guild_OneOnOneClock:Close()
  elseif __eGuildTeamBattleState_Requesting == state then
    PaGlobal_Guild_OneOnOneClock:Open()
  elseif __eGuildTeamBattleState_Accepting == state then
    PaGlobal_Guild_OneOnOneClock:Open()
  elseif __eGuildTeamBattleState_Teleport == state then
    PaGlobal_Guild_OneOnOneClock:Open()
  elseif __eGuildTeamBattleState_Fight == state then
    PaGlobal_Guild_OneOnOneClock:Open()
  elseif __eGuildTeamBattleState_End == state then
    PaGlobal_Guild_OneOnOneClock:Close()
  else
    PaGlobal_Guild_OneOnOneClock:Close()
    return
  end
end
function FromClient_GuildTeamBattle_StateChanged(state, param1)
  checkHideOrShowPanel(state)
  if __eGuildTeamBattleState_Idle == state then
    PaGlobal_Radar_GuildTeamBattleAlert(false)
  elseif __eGuildTeamBattleState_Preparing == state then
    local territoryKeyRaw = ToClient_GetStartSiegeTerritoryKey()
    local territoryKey = getTerritoryByIndex(territoryKeyRaw)
    local territoryName = getTerritoryNameByKey(territoryKey)
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_READYBATTLEAREASOON_MAIN"),
      sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_READYBATTLEAREASOON_SUB", "territoryName", territoryName),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 92, false, PaGlobal_Guild_OneOnOne_Control._msgType._preparing)
    PaGlobal_Radar_GuildTeamBattleAlert(false)
  elseif __eGuildTeamBattleState_Building == state then
    local territoryKeyRaw = ToClient_GetStartSiegeTerritoryKey()
    local territoryKey = getTerritoryByIndex(territoryKeyRaw)
    local territoryName = getTerritoryNameByKey(territoryKey)
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_STARTREQUESTINGSOON_MAIN"),
      sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_STARTREQUESTINGSOON_SUB", "territoryName", territoryName),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 92, false, PaGlobal_Guild_OneOnOne_Control._msgType._startBuliding)
    PaGlobal_Radar_GuildTeamBattleAlert(true)
  elseif __eGuildTeamBattleState_Requesting == state then
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_STARTREQUESTING_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_STARTREQUESTING_SUB"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 92, false, PaGlobal_Guild_OneOnOne_Control._msgType._startRequest)
    PaGlobal_Radar_GuildTeamBattleAlert(true)
  elseif __eGuildTeamBattleState_Accepting == state then
    local defenceTeamInfo = ToClient_GetGuildTeamBattleDefenceTeam()
    local strDefenceTeamName = defenceTeamInfo:getTeamName()
    local strDefenceTeamKind = GetTeamKind(defenceTeamInfo:isAlliance())
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_STARTACCEPTING_MAIN"),
      sub = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_STARTACCEPTING_SUB", "defenceTeamName", strDefenceTeamName, "defenceTeamKind", strDefenceTeamKind),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 93, false, PaGlobal_Guild_OneOnOne_Control._msgType._startAccept)
    PaGlobal_Radar_GuildTeamBattleAlert(true)
  elseif __eGuildTeamBattleState_Teleport == state then
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ATTENDTELEPORTED_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ATTENDTELEPORTED_SUB"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 93, false, PaGlobal_Guild_OneOnOne_Control._msgType._doppingTime)
    PaGlobal_Radar_GuildTeamBattleAlert(true)
  elseif __eGuildTeamBattleState_Fight == state then
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_FIGHTSTART_MAIN"),
      sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_FIGHTSTART_SUB", "minute", 3),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 93, false, PaGlobal_Guild_OneOnOne_Control._msgType._fightStarted)
    PaGlobal_Radar_GuildTeamBattleAlert(true)
    PaGlobal_Guild_OneOnOneClock:clearNoticeMessage()
  elseif __eGuildTeamBattleState_End == state then
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_NOTMATCHED_MAIN"),
      sub = "",
      addMsg = ""
    }
    local stoppedReason = Int64toInt32(param1)
    local soundType = PaGlobal_Guild_OneOnOne_Control._msgType._battleResult
    if __eGuildTeamBattleStopReason_NoAttend == stoppedReason then
      message.sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_NOTMATCHED_SUB_TIMEOUT")
      soundType = PaGlobal_Guild_OneOnOne_Control._msgType._noBattleRequested
    elseif __eGuildTeamBattleStopReason_InternalError == stoppedReason then
      message.sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_NOTMATCHED_SUB_TIMEOUT")
      soundType = PaGlobal_Guild_OneOnOne_Control._msgType._noBattleRequested
    elseif __eGuildTeamBattleStopReason_DefenceTeamNotRespond == stoppedReason then
      return
    elseif __eGuildTeamBattleStopReason_FightEnded == stoppedReason then
      local isAttackTeamWin = ToClient_GuildTeamBattle_IsAttackTeamWin()
      local attackTeamInfo = ToClient_GetGuildTeamBattleAttackTeam()
      local defenceTeamInfo = ToClient_GetGuildTeamBattleDefenceTeam()
      local strWinTeamName = ""
      local strWinTeamKind = ""
      if true == isAttackTeamWin then
        strWinTeamName = attackTeamInfo:getTeamName()
        strWinTeamKind = GetTeamKind(attackTeamInfo:isAlliance())
      else
        strWinTeamName = defenceTeamInfo:getTeamName()
        strWinTeamKind = GetTeamKind(defenceTeamInfo:isAlliance())
      end
      message.main = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_END_MESSAGE_MAIN", "winTeamName", strWinTeamName, "winTeamKind", strWinTeamKind)
      message.sub = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_END_MESSAGE_SUB", "winTeamName", strWinTeamName, "winTeamKind", strWinTeamKind)
    else
      return
    end
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 94, false, soundType)
    PaGlobal_Radar_GuildTeamBattleAlert(false)
  else
    PaGlobal_Radar_GuildTeamBattleAlert(false)
  end
end
function FGlobal_GuildTeamBattle_RegularCheck()
  local ui = PaGlobal_Guild_OneOnOne_Control._ui
  local state = ToClient_GetGuildTeamBattleState()
  if __eGuildTeamBattleState_Preparing == state then
    if true == ToClient_IsDoingGuildTeamBattleRingout() then
      PaGlobal_Guild_OneOnOneAlert:Show(ToClient_GetRemainTimeGuildTeamBattleState())
    else
      PaGlobal_Guild_OneOnOneAlert:Hide()
    end
  else
    PaGlobal_Guild_OneOnOneAlert:Hide()
  end
  checkHideOrShowPanel(state)
end
function FGlobal_GuildTeamBattle_RingoutPlayer(isAttackTeam, playerIndex)
  local teamInfo
  if true == isAttackTeam then
    teamInfo = ToClient_GetGuildTeamBattleAttackTeam()
  else
    teamInfo = ToClient_GetGuildTeamBattleDefenceTeam()
  end
  local msg = {
    main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_PLAYERRINGOUT_MAIN"),
    sub = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_PLAYERRINGOUT_SUB", "teamName", teamInfo:getTeamName(), "teamKind", GetTeamKind(teamInfo:isAlliance()), "playerName", teamInfo:getPlayerName(playerIndex)),
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(msg, 4, 93, false, PaGlobal_Guild_OneOnOne_Control._msgType._ringout)
end
function FGlobal_GuildTeamBattle_RingoutAlert()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_RINGOUTSELF"))
end
function FGlobal_GuildTeamBattle_AttendLogout(isAttackTeam, playerIndex)
  local teamInfo
  if true == isAttackTeam then
    teamInfo = ToClient_GetGuildTeamBattleAttackTeam()
  else
    teamInfo = ToClient_GetGuildTeamBattleDefenceTeam()
  end
  local msg = {
    main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ATTENDANCE_LOGOUT_MAIN"),
    sub = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ATTENDANCE_LOGOUT_SUB", "teamName", teamInfo:getTeamName(), "teamKind", GetTeamKind(teamInfo:isAlliance()), "playerName", teamInfo:getPlayerName(playerIndex)),
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(msg, 4, 93, false, PaGlobal_Guild_OneOnOne_Control._msgType._logout)
end
function FromClient_Guild_OneOnOneControl_Initialize()
end
function TestGuildTeamBattleMessage(mode, param1, param2)
  if false == ToClient_IsDevelopment() then
    return
  end
  local territoryName = "territoryName"
  local strAttackTeamName = "AttackTeam"
  local strDefenceTeamName = "DefenceTeam"
  local strAttackTeamKind = "Guild"
  local strDefenceTeamKind = "Alliance"
  local strAttackPlayerName = "AttackPlayer"
  local strDefencePlayerName = "DefencePlayer"
  local strWinTeamName = "WinTeam"
  local strLoseTeamName = "LoseTeam"
  local strWinPlayerName = "WinTeamPlayer"
  local strLosePlayerName = "LoseTeamPlayer"
  local strTeamName = "GuildName"
  local strPlayerName = "PlayerName"
  local strTeamKind = "Guild"
  local msgType = PaGlobal_Guild_OneOnOne_Control._msgType
  if mode == 0 then
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_READYBATTLEAREASOON_MAIN"),
      sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_READYBATTLEAREASOON_SUB", "territoryName", territoryName),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 92, false, msgType._preparing)
  elseif mode == 1 then
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_STARTREQUESTINGSOON_MAIN"),
      sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_STARTREQUESTINGSOON_SUB", "territoryName", territoryName),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 92, false, msgType._startBuliding)
  elseif mode == 2 then
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_STARTREQUESTING_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_STARTREQUESTING_SUB"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 92, false, msgType._battleRequested)
  elseif mode == 3 then
    local msgMain = ""
    local msgSub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTBATTLE_MAIN")
    if param2 == 0 then
      msgMain = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTED_ALLIANCE_VS_ALLIANCE", "attackTeamName", strAttackTeamName, "attackPlayerName", strAttackPlayerName, "defenceTeamName", strDefenceTeamName)
    elseif param2 == 1 then
      msgMain = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTED_GUILD_VS_ALLIANCE", "attackTeamName", strAttackTeamName, "attackPlayerName", strAttackPlayerName, "defenceTeamName", strDefenceTeamName)
    elseif param2 == 2 then
      msgMain = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTED_ALLIANCE_VS_GUILD", "attackTeamName", strAttackTeamName, "attackPlayerName", strAttackPlayerName, "defenceTeamName", strDefenceTeamName)
    else
      msgMain = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTED_GUILD_VS_GUILD", "attackTeamName", strAttackTeamName, "attackPlayerName", strAttackPlayerName, "defenceTeamName", strDefenceTeamName)
    end
    local message = {
      main = msgMain,
      sub = msgSub,
      addMsg = ""
    }
    local tmp = 96
    if 0 == param1 then
      tmp = 92
    else
      tmp = 96
    end
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 5, tmp, false, msgType._battleRequested)
  elseif mode == 4 then
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_NOTMATCHED_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_NOTMATCHED_SUB_TIMEOUT"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 94, false, msgType._noBattleRequested)
  elseif mode == 5 then
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_STARTACCEPTING_MAIN"),
      sub = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_STARTACCEPTING_SUB", "defenceTeamName", strDefenceTeamName, "defenceTeamKind", strDefenceTeamKind),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 93, false, msgType._startAccept)
  elseif mode == 6 then
    local msgMain = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ACCEPTED_SUB", "attackTeamName", strAttackTeamName, "attackTeamKind", strAttackTeamKind, "defenceTeamName", strDefenceTeamName, "defenceTeamKind", strDefenceTeamKind)
    local msgSub = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ACCEPTED", "defenceTeamName", strDefenceTeamName, "defenceTeamKind", strDefenceTeamKind, "defencePlayerName", strDefencePlayerName)
    local message = {
      main = msgMain,
      sub = msgSub,
      addMsg = ""
    }
    local tmp = 97
    if 0 == param1 then
      tmp = 93
    else
      tmp = 97
    end
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 5, tmp, false, msgType._battleAccepted)
  elseif mode == 7 then
    local message = {
      main = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_NOTMATCHED_SUB_NOTRESPONSE", "attackTeamName", strAttackTeamName, "attackTeamKind", strAttackTeamKind, "defenceTeamName", strDefenceTeamName, "defenceTeamKind", strDefenceTeamKind),
      sub = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ATTACKTEAMWIN_MAIN", "attackTeamName", strAttackTeamName, "attackTeamKind", strAttackTeamKind),
      addMsg = ""
    }
    local tmp = 0
    if 0 == param1 then
      tmp = 94
    else
      tmp = 98
    end
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, tmp, false, msgType._battleNotAccepted)
  elseif mode == 8 then
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ATTENDTELEPORTED_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ATTENDTELEPORTED_SUB"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 93, false, msgType._doppingTime)
  elseif mode == 9 then
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_FIGHTSTART_MAIN"),
      sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_FIGHTSTART_SUB", "minute", 3),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 93, false, msgType._fightStarted)
  elseif mode == 10 then
    local message = {}
    if true == isAttackTeamWin then
      message.sub = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ATTACKTEAMWIN_MAIN", "attackTeamName", strAttackTeamName, "attackTeamKind", strAttackTeamKind)
    else
      message.sub = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_DEFENCETEAMWIN_MAIN", "defenceTeamName", strDefenceTeamName, "defenceTeamKind", defenceTeamKind)
    end
    if 0 == param2 then
      message.main = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_DEFEATMESSAGE_ALLIANCE_VS_ALLIANCE", "teamName1", strWinTeamName, "playerName1", strWinPlayerName, "teamName2", strLoseTeamName, "playerName2", strLosePlayerName)
    elseif 1 == param2 then
      message.main = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_DEFEATMESSAGE_GUILD_VS_ALLIANCE", "teamName1", strWinTeamName, "playerName1", strWinPlayerName, "teamName2", strLoseTeamName, "playerName2", strLosePlayerName)
    elseif 2 == param2 then
      message.main = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_DEFEATMESSAGE_ALLIANCE_VS_GUILD", "teamName1", strWinTeamName, "playerName1", strWinPlayerName, "teamName2", strLoseTeamName, "playerName2", strLosePlayerName)
    else
      message.main = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_DEFEATMESSAGE_GUILD_VS_GUILD", "teamName1", strWinTeamName, "playerName1", strWinPlayerName, "teamName2", strLoseTeamName, "playerName2", strLosePlayerName)
    end
    local tmp = 0
    if 0 == param1 then
      tmp = 95
    else
      tmp = 99
    end
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, tmp, false, msgType._battleResult)
  elseif mode == 11 then
    local msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_PLAYERRINGOUT_MAIN"),
      sub = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_PLAYERRINGOUT_SUB", "teamName", strTeamName, "teamKind", strTeamKind, "playerName", strPlayerName),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(msg, 4, 93, false, msgType._ringout)
  elseif mode == 12 then
    local msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ATTENDANCE_LOGOUT_MAIN"),
      sub = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ATTENDANCE_LOGOUT_SUB", "teamName", strTeamName, "teamKind", strTeamKind, "playerName", strPlayerName),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(msg, 4, 93, false, msgType._logout)
  elseif mode == 13 then
    local message = {
      main = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_INGMESSAGE_SUB", "attackTeamName", strAttackTeamName, "attackTeamKind", strAttackTeamKind, "defenceTeamName", strDefenceTeamName, "defenceTeamKind", strDefenceTeamKind),
      sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_INGMESSAGE_MAIN", "territoryName", territoryName),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 93, false, msgType._gulidTeamBattleIng)
  elseif mode == 14 then
    local attackTeamHpRate = 80
    local defenceTeamHpRate = 95
    local msg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_END_SUB_TIMEOUTWIN", "attackTeamHpRate", attackTeamHpRate, "defenceTeamHpRate", defenceTeamHpRate)
    if "" ~= msg and nil ~= msg then
      Proc_ShowMessage_Ack(msg)
    end
  end
end
function FGlobal_Update_ShowGuildTeamBattlePing(prevIsShouldPlayMusic, isShouldPlayMusic, currentState)
  if false == _ContentsGroup_RemasterUI_Main_RightTop then
    FGlobal_PersonalIcon_ButtonPosUpdate()
  else
    FromClient_Widget_FunctionButton_Resize()
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_Guild_OneOnOneControl_Initialize")
registerEvent("FromClient_GuildTeamBattle_End", "FromClient_GuildTeamBattle_End")
registerEvent("FromClient_GuildTeamBattle_RequestDone", "FromClient_GuildTeamBattle_RequestDone")
registerEvent("FromClient_GuildTeamBattle_AcceptDone", "FromClient_GuildTeamBattle_AcceptDone")
registerEvent("FromClient_GuildTeamBattle_StateChanged", "FromClient_GuildTeamBattle_StateChanged")
registerEvent("FromClient_GuildTeamBattle_CheckOpenRequest", "FGlobal_GuildTeamBattle_RegularCheck")
registerEvent("FromClient_UpdateGuildTeamBattle_RingoutPlayer", "FGlobal_GuildTeamBattle_RingoutPlayer")
registerEvent("FromClient_GuildTeamBattle_RingoutAlert", "FGlobal_GuildTeamBattle_RingoutAlert")
registerEvent("FromClient_GuildTeamBattle_AttendLogout", "FGlobal_GuildTeamBattle_AttendLogout")
registerEvent("FromClient_GuildTeamBattle_UpdatePingUI", "FGlobal_Update_ShowGuildTeamBattlePing")

PaGlobal_Guild_OneOnOneClock = {
  _ui = {
    _panel = Panel_Guild_OneOnOneClock,
    _staticCenter_Bg = UI.getChildControl(Panel_Guild_OneOnOneClock, "StaticText_Center"),
    _staticText_AttackTeamName = UI.getChildControl(Panel_Guild_OneOnOneClock, "StaticText_Left"),
    _staticText_DefenceTeamName = UI.getChildControl(Panel_Guild_OneOnOneClock, "StaticText_Right"),
    _staticText_Title = UI.getChildControl(Panel_Guild_OneOnOneClock, "StaticText_Center"),
    _staticText_AlertMessageBg = UI.getChildControl(Panel_Guild_OneOnOneClock, "StaticText_AlertMessageBg"),
    _staticText_NoticeMessageBg = UI.getChildControl(Panel_Guild_OneOnOneClock, "StaticText_NoticeMessageBg"),
    _staticText_AttackPlayerName = UI.getChildControl(Panel_Guild_OneOnOneClock, "StaticText_LeftCharacterName"),
    _staticText_DefencePlayerName = UI.getChildControl(Panel_Guild_OneOnOneClock, "StaticText_RightCharacterName")
  },
  _lastTerritoryKey = -1,
  _lastRemainTime = -1,
  _ringoutTimeAccum = 0,
  _noticeText = ""
}
local GetTeamKind = function(isAlliance)
  if true == isAlliance then
    return PAGetString(Defines.StringSheet_GAME, "LUA_WORD_GUILDALLIANCE")
  else
    return PAGetString(Defines.StringSheet_GAME, "LUA_WORD_GUILD")
  end
end
function PaGlobal_Guild_OneOnOneClock:Open()
  local ui = self._ui
  local state = ToClient_GetGuildTeamBattleState()
  if __eGuildTeamBattleState_Teleport == state then
    ui._staticText_Time:SetText("03:00")
  end
  self:UpdateData()
  Panel_Guild_OneOnOneClock:SetShow(true)
end
function PaGlobal_Guild_OneOnOneClock:UpdateData()
  local ui = self._ui
  local attackTeam = ToClient_GetGuildTeamBattleAttackTeam()
  ui._staticText_AttackTeamName:SetText(attackTeam:getTeamName() .. " " .. GetTeamKind(attackTeam:isAlliance()))
  local defenceTeam = ToClient_GetGuildTeamBattleDefenceTeam()
  ui._staticText_DefenceTeamName:SetText(defenceTeam:getTeamName() .. " " .. GetTeamKind(defenceTeam:isAlliance()))
  if true == attackTeam:isDefined() then
    ui._staticText_AttackPlayerName:SetText(attackTeam:getPlayerName(0))
    ui._staticText_AttackTeamName:SetShow(true)
    ui._staticText_DefenceTeamName:SetShow(true)
  else
    ui._staticText_AttackPlayerName:SetText("-")
    ui._staticText_AttackTeamName:SetShow(false)
    ui._staticText_DefenceTeamName:SetShow(false)
  end
  if true == defenceTeam:isDefined() then
    ui._staticText_DefencePlayerName:SetText(defenceTeam:getPlayerName(0))
  else
    ui._staticText_DefencePlayerName:SetText("-")
  end
end
function PaGlobal_Guild_OneOnOneClock:IsShow()
  return Panel_Guild_OneOnOneClock:GetShow()
end
function PaGlobal_Guild_OneOnOneClock:Close()
  Panel_Guild_OneOnOneClock:SetShow(false)
  PaGlobal_Guild_OneOnOneClock._ui._staticText_AlertMessageBg:SetShow(false)
  PaGlobal_Guild_OneOnOneClock._ui._staticText_NoticeMessageBg:SetShow(false)
end
function PaGlobal_Guild_OneOnOneClock:SetNoticeMessage(noticeText)
  self._noticeText = noticeText
end
function PaGlobal_Guild_OneOnOneClock:clearNoticeMessage()
  self._noticeText = ""
end
function PaGlobal_Guild_OneOnOneClock:ShowInfoMessage(msg)
  local ui = PaGlobal_Guild_OneOnOneClock._ui
  ui._staticText_AlertMessageBg:SetShow(false)
  ui._staticText_NoticeMessageBg:SetShow(true)
  ui._staticText_NoticeMessage:SetText(msg)
end
function PaGlobal_Guild_OneOnOneClock:hideInfoMessage()
  local ui = PaGlobal_Guild_OneOnOneClock._ui
  ui._staticText_NoticeMessageBg:SetShow(false)
end
function PaGlobal_Guild_OneOnOneClock:UpdateClock(state, remainSec)
  local ui = self._ui
  local attackTeamInfo = ToClient_GetGuildTeamBattleAttackTeam()
  local defenceTeamInfo = ToClient_GetGuildTeamBattleDefenceTeam()
  local strAttackTeamName = attackTeamInfo:getTeamName()
  local strDefenceTeamName = defenceTeamInfo:getTeamName()
  local strAttackTeamKind = GetTeamKind(attackTeamInfo:isAlliance())
  local strDefenceTeamKind = GetTeamKind(defenceTeamInfo:isAlliance())
  if remainSec < 0 then
    remainSec = 0
  end
  local clockTime = convertSecondsToClockTime(remainSec)
  if __eGuildTeamBattleState_Requesting == state then
    ui._staticText_Time:SetText(clockTime)
    local attackTeam = ToClient_GetGuildTeamBattleAttackTeam()
    if false == attackTeam:isDefined() then
      ui._staticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTING"))
      self:SetNoticeMessage(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTING_DESC"))
    else
      ui._staticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTING_DONE"))
      self:SetNoticeMessage(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_AFTER_REQUESTING", "defenceTeamName", strDefenceTeamName, "defenceTeamKind", strDefenceTeamKind))
    end
    self:UpdateData()
  elseif __eGuildTeamBattleState_Accepting == state then
    ui._staticText_Time:SetText(clockTime)
    local defenceTeam = ToClient_GetGuildTeamBattleDefenceTeam()
    if false == defenceTeam:isDefined() then
      ui._staticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ACCEPTING"))
      self:SetNoticeMessage(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ACCEPTING_DESC", "defenceTeamName", strDefenceTeamName, "defenceTeamKind", strDefenceTeamKind))
    else
      ui._staticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ACCEPTTED"))
      self:SetNoticeMessage(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_WAITING_TELEPORT"))
    end
    self:UpdateData()
  elseif __eGuildTeamBattleState_Teleport == state then
    ui._staticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_READYING"))
    self:SetNoticeMessage(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_FIGHTSTART_AFTER_SEC", "sec", remainSec))
    self:UpdateData()
  elseif __eGuildTeamBattleState_Fight == state then
    ui._staticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_FIGHTING"))
    ui._staticText_Time:SetText(clockTime)
    ui._staticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_FIGHTING"))
    self:UpdateData()
  else
    self:Close()
  end
  if true == Panel_RewardSelect_NakMessage:GetShow() then
    ui._staticText_NoticeMessageBg:SetShow(false)
  elseif "" ~= self._noticeText then
    ui._staticText_NoticeMessage:SetText(self._noticeText)
    ui._staticText_NoticeMessageBg:SetShow(true)
    if __eGuildTeamBattleState_Teleport == state and remainSec <= 5 then
      ui._staticText_NoticeMessageBg:SetShow(false)
    end
  else
    ui._staticText_NoticeMessageBg:SetShow(false)
  end
end
function FromClient_Guild_OneOnOneClock_Initialize()
  local ui = PaGlobal_Guild_OneOnOneClock._ui
  ui._staticText_Time = UI.getChildControl(ui._staticCenter_Bg, "StaticText_Time")
  ui._staticText_AlertMessage = UI.getChildControl(ui._staticText_AlertMessageBg, "StaticText_AlertMessage")
  ui._staticText_NoticeMessage = UI.getChildControl(ui._staticText_NoticeMessageBg, "StaticText_NoticeMessage")
  ui._staticText_AlertMessageBg:SetShow(false)
  ui._staticText_NoticeMessageBg:SetShow(false)
  PaGlobal_Guild_OneOnOneClock._lastTerritoryKey = -1
end
function FGlobal_UpdateOneOnOneClock_TimeUpdate(state, remainSec)
  local ui = PaGlobal_Guild_OneOnOneClock._ui
  local self = PaGlobal_Guild_OneOnOneClock
  self:UpdateClock(state, remainSec)
  if __eGuildTeamBattleState_Requesting == state or __eGuildTeamBattleState_Accepting == state or __eGuildTeamBattleState_Teleport == state or __eGuildTeamBattleState_Fight == state then
    if true == ToClient_IsDoingGuildTeamBattleRingout() then
      if false == ToClient_IsSelfInGuildTeamBattle() then
        ui._staticText_AlertMessage:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ILLEGALENTERANCE_MAIN", "remainSec", ToClient_GetGuildTeamBattleRingoutTime()))
        ui._staticText_AlertMessageBg:SetShow(true)
      else
        ui._staticText_AlertMessageBg:SetShow(false)
      end
    else
      ui._staticText_AlertMessageBg:SetShow(false)
    end
  end
  if __eGuildTeamBattleState_Teleport == state then
    if (true == ToClient_IsSelfInGuildTeamBattle() or true == ToClient_IsSelfPlayerInGuildTeamBattleTerritory()) and remainSec ~= self._lastRemainTime then
      if remainSec > 0 and remainSec < 60 and remainSec % 10 == 0 then
        local msg = {
          main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_WAITING_MAIN", "remainSec", remainSec),
          sub = "",
          addMsg = ""
        }
        Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 3, false)
      elseif remainSec > 0 and remainSec <= 5 then
        local msg = {
          main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_STARTSOON"),
          sub = tostring(remainSec),
          addMsg = ""
        }
        Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect(msg, 1, 62, false)
      end
      self._lastRemainTime = remainSec
    end
  elseif __eGuildTeamBattleState_Fight == state then
    if true == ToClient_IsDoingGuildTeamBattleRingout() then
      if true == ToClient_IsSelfInGuildTeamBattle() then
        ui._staticText_AlertMessage:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_RINGOUT_MAIN", "remainSec", ToClient_GetGuildTeamBattleRingoutTime()))
      else
        ui._staticText_AlertMessage:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ILLEGALENTERANCE_MAIN", "remainSec", ToClient_GetGuildTeamBattleRingoutTime()))
      end
      ui._staticText_AlertMessageBg:SetShow(true)
    else
      ui._staticText_AlertMessageBg:SetShow(false)
    end
  end
end
function FGlobal_UpdateOneOnOneClock_TurnOnOff(regionInfo)
  local state = ToClient_GetGuildTeamBattleState()
  local territoryKey = regionInfo:getTerritoryKeyRaw()
  if __eGuildTeamBattleState_Teleport == state or __eGuildTeamBattleState_Fight == state or __eGuildTeamBattleState_Requesting == state or __eGuildTeamBattleState_Accepting == state then
    if PaGlobal_Guild_OneOnOneClock._lastTerritoryKey ~= territoryKey then
      if true == ToClient_IsSelfPlayerInGuildTeamBattleTerritory() then
        local attackTeamInfo = ToClient_GetGuildTeamBattleAttackTeam()
        local defenceTeamInfo = ToClient_GetGuildTeamBattleDefenceTeam()
        if true == ToClient_IsGuildTeamBattleInfoSet() then
          local message = {
            main = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_INGMESSAGE_SUB", "attackTeamName", attackTeamInfo:getTeamName(), "attackTeamKind", GetTeamKind(attackTeamInfo:isAlliance()), "defenceTeamName", defenceTeamInfo:getTeamName(), "defenceTeamKind", GetTeamKind(defenceTeamInfo:isAlliance())),
            sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_INGMESSAGE_MAIN", "territoryName", regionInfo:getTerritoryName()),
            addMsg = ""
          }
          Proc_ShowMessage_Ack_For_RewardSelect_GuildTeamBattle(message, 4, 93, false, PaGlobal_Guild_OneOnOne_Control._msgType._gulidTeamBattleIng)
        end
        PaGlobal_Guild_OneOnOneClock:Open()
      else
        PaGlobal_Guild_OneOnOneClock:Close()
      end
    end
  else
    PaGlobal_Guild_OneOnOneClock:Close()
  end
  PaGlobal_Guild_OneOnOneClock._lastTerritoryKey = territoryKey
end
registerEvent("FromClient_luaLoadComplete", "FromClient_Guild_OneOnOneClock_Initialize")
registerEvent("FromClient_GuildTeamBattle_RequestDone", "FromClient_GuildTeamBattle_RequestDone_ClosePanel")
registerEvent("FromClient_UpdateGuildTeamBattleTime", "FGlobal_UpdateOneOnOneClock_TimeUpdate")
registerEvent("selfPlayer_regionChanged", "FGlobal_UpdateOneOnOneClock_TurnOnOff")

NationSiege_Widget = {
  _territoryName = nil,
  _territoryKeyGet = nil,
  _isCommanderDead = false,
  _msgType = 2,
  _showTime = 10,
  _bossWarningShowTime = 5
}
local WARNING_HP_RATE = {
  [1] = 75,
  [2] = 50,
  [3] = 25
}
local ENUM_TERRITORY = {CALPHEON = 2, VALENCIA = 4}
local bossHpSave = {
  [1] = 100,
  [2] = 100,
  [3] = 100,
  [4] = 100,
  [5] = 100,
  [6] = 100
}
local bossWarningCheck = {
  [1] = {},
  [2] = {},
  [3] = {},
  [4] = {},
  [5] = {},
  [6] = {}
}
local bossClassName = {
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_NAKMESSAGE_NATIONSEIGE_CALPHEON_BOSS"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_NAKMESSAGE_NATIONSEIGE_VALENCIA_BOSS"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_NAKMESSAGE_NATIONSEIGE_CALPHEON_SUBBOSS_2"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_NAKMESSAGE_NATIONSEIGE_CALPHEON_SUBBOSS_1"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_NAKMESSAGE_NATIONSEIGE_VALENCIA_SUBBOSS_2"),
  [6] = PAGetString(Defines.StringSheet_GAME, "LUA_NAKMESSAGE_NATIONSEIGE_VALENCIA_SUBBOSS_1")
}
function NationSiege_Widget:init()
  self._territoryName = nil
  self._territoryKeyGet = nil
  self._isCommanderDead = false
  for ii = 1, 6 do
    for jj = 1, 3 do
      bossWarningCheck[ii][jj] = false
    end
  end
  if true == ToClient_isBeingNationSiege() then
    FGlobal_FunctionButton_NationSiegeIcon_StartAni()
    NationSiege_Widget:initCurrentAllBossHp()
    PaGlobal_NationSiegeKillLog_Open()
  end
end
function NationSiege_Widget:registEvnetHandler()
  registerEvent("FromClient_NationSiegeStart", "FromClient_NationSiegeStart")
  registerEvent("FromClient_NationSiegeStop", "FromClient_NationSiegeStop")
  registerEvent("FromClient_NationSiegeVictory", "FromClient_NationSiegeVictory")
  registerEvent("FromClient_NationSiegeNotifySystemMessage", "FromClient_NationSiegeNotifySystemMessage")
  registerEvent("FromClient_NationSiegeBossHpChanged", "FromClient_NationWarNakMessage_BossHpChanged")
  registerEvent("FromClient_NoticeChatMessageUpdate_NationSiege", "FromClient_NoticeChatMessageUpdate_NationSiege")
end
function FromClient_NationSiegeVictory(territoryKey)
  self._territoryName = getTerritoryNameByKey(territoryKey)
  self._territoryRegion = territoryKey:get()
end
function FromClient_NationSiegeStart()
  local self = NationSiege_Widget
  local msg = {
    main = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_NOTIFY_START_NATIONSIEGE"),
    sub = ""
  }
  PaGlobalFunc_NationWar_Message_Show(msg, 1, self._showTime, false)
  FGlobal_FunctionButton_NationSiegeIcon_StartAni()
  PaGlobal_NationSiegeKillLog_Open()
  chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTNATIONSIEGE_GUIDE_MAIN"), CppEnums.ChatType.System)
  chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTNATIONSIEGE_GUIDE_SUB"), CppEnums.ChatType.System)
  chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTNATIONSIEGE_GUIDE_SUB2"), CppEnums.ChatType.System)
  chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTNATIONSIEGE_GUIDE_SUB3"), CppEnums.ChatType.System)
  chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTNATIONSIEGE_GUIDE_SUB4"), CppEnums.ChatType.System)
  chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTNATIONSIEGE_GUIDE_SUB5"), CppEnums.ChatType.System)
  chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTNATIONSIEGE_GUIDE_SUB6"), CppEnums.ChatType.System)
  chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTNATIONSIEGE_GUIDE_SUB7"), CppEnums.ChatType.System)
  chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTNATIONSIEGE_GUIDE_SUB8"), CppEnums.ChatType.System)
end
function FromClient_NationSiegeStop()
  local self = NationSiege_Widget
  if true == self._isCommanderDead then
    return
  end
  if ENUM_TERRITORY.CALPHEON == self._territoryRegion then
    self._msgType = 3
    self._territoryName = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSEIGE_NATIONNAME_CALPHEON_01")
  elseif ENUM_TERRITORY.VALENCIA == self._territoryRegion then
    self._msgType = 4
    self._territoryName = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSEIGE_NATIONNAME_VALENCIA_01")
  end
  self:nationSiegeStop()
end
function PaGlobal_NationSiege_StopMessage()
  local self = NationSiege_Widget
  self:nationSiegeStop()
end
function NationSiege_Widget:nationSiegeStop()
  local msg
  if nil ~= self._territoryName and nil ~= self._territoryRegion then
    msg = {
      main = PAGetStringParam1(Defines.StringSheet_GAME, "GAME_MESSAGE_NOTIFY_FINISH_NATIONSIEGE", "territoryName", self._territoryName),
      sub = ""
    }
  else
    msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYDRAWNATIONSIEGE_MAIN"),
      sub = ""
    }
  end
  PaGlobalFunc_NationWar_Message_Show(msg, self._msgType, self._showTime, false)
  FGlobal_FunctionButton_NationSiegeIcon_StopAni()
  PaGlobal_NationSiegeKillLog_Close()
end
function FromClient_NationSiegeNotifySystemMessage(msgType, territoryKey, characterKey, killGuildName, killFamilyName)
  local self = NationSiege_Widget
  local territoryName, actor, actorName, msg, mainText, subText
  if __eNationSiegeMessageType_BeforeOneMinute == msgType then
    chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTNATIONSIEGE_START_MAIN"), CppEnums.ChatType.System)
    chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTNATIONSIEGE_START_SUB"), CppEnums.ChatType.System)
    chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYSTARTNATIONSIEGE_SARRT_SUB2"), CppEnums.ChatType.System)
  elseif __eNationSiegeMessageType_BossDie == msgType then
    local territoryIndex = Int64toInt32(territoryKey)
    local tempKey = getTerritoryByIndex(territoryIndex)
    territoryName = getTerritoryNameByKey(tempKey)
    local characterKeyRaw = Int64toInt32(characterKey)
    local characterStaticStatusWarpper = getCharacterStaticStatusWarpper(characterKeyRaw)
    local characterName = ""
    if nil ~= characterStaticStatusWarpper then
      actorName = characterStaticStatusWarpper:getName()
    end
    mainText = PAGetStringParam2(Defines.StringSheet_GAME, "GAME_MESSAGE_NOTIFY_NATIONSIEGE_CAL_COMMANDER1_DIE", "territoryName", territoryName, "NationGrandCommander", actorName)
    subText = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_BOSSKILL_MESSAGE_BY_PLAYER", "killGuildName", killGuildName, "killFamilyName", killFamilyName)
    msg = {main = mainText, sub = subText}
    if ENUM_TERRITORY.CALPHEON == Int64toInt32(territoryKey) then
      self._msgType = 4
      self._territoryName = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSEIGE_NATIONNAME_VALENCIA_01")
    elseif ENUM_TERRITORY.VALENCIA == Int64toInt32(territoryKey) then
      self._msgType = 3
      self._territoryName = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSEIGE_NATIONNAME_CALPHEON_01")
    end
    self._territoryRegion = territoryKey
    self._isCommanderDead = true
    PaGlobalFunc_NationWar_Message_Show(msg, 7, self._showTime, false)
  elseif __eNationSiegeMessageType_SubBossDie == msgType then
    local territoryIndex = Int64toInt32(territoryKey)
    local tempKey = getTerritoryByIndex(territoryIndex)
    territoryName = getTerritoryNameByKey(tempKey)
    local characterKeyRaw = Int64toInt32(characterKey)
    local characterStaticStatusWarpper = getCharacterStaticStatusWarpper(characterKeyRaw)
    local characterName = ""
    if nil ~= characterStaticStatusWarpper then
      actorName = characterStaticStatusWarpper:getName()
    end
    mainText = PAGetStringParam2(Defines.StringSheet_GAME, "GAME_MESSAGE_NOTIFY_NATIONSIEGE_CAL_COMMANDER2_DIE", "territoryName", territoryName, "NationSubCommander", actorName)
    subText = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_BOSSKILL_MESSAGE_BY_PLAYER", "killGuildName", killGuildName, "killFamilyName", killFamilyName)
    msg = {main = mainText, sub = subText}
    PaGlobalFunc_NationWar_Message_Show(msg, 7, self._showTime, false)
  elseif __eNationSiegeMessageType_CarriageMove == msgType then
    local territoryIndex = Int64toInt32(territoryKey)
    local tempKey = getTerritoryByIndex(territoryIndex)
    territoryName = getTerritoryNameByKey(tempKey)
    chatting_sendMessage("", PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYNATIONSIEGE_CAL_CARRIAGE_START", "territoryName", territoryName), CppEnums.ChatType.System)
  elseif __eNationSiegeMessageType_CarriageDie == msgType then
    local territoryIndex = Int64toInt32(territoryKey)
    local tempKey = getTerritoryByIndex(territoryIndex)
    territoryName = getTerritoryNameByKey(tempKey)
    chatting_sendMessage("", PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_NOTIFYNATIONSIEGE_CAL_CARRIAGE_DIE", "territoryName", territoryName), CppEnums.ChatType.System)
  end
end
function FromClient_NoticeChatMessageUpdate_NationSiege(_noticeSender, _noticeContent)
  Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_MASTER_ORDER_MESSAGE", "sender", _noticeSender, "content", _noticeContent))
end
function FromClient_NationWarNakMessage_BossHpChanged()
  local msg, mainText, subText
  local wrapper_Calpheon = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.CALPHEON)
  if nil == wrapper_Calpheon then
    return
  end
  local mainBoss_Calpheon = wrapper_Calpheon:getBossByCharacterKey(ToClient_getNationSiegeBossCharacterKey(ENUM_TERRITORY.CALPHEON))
  if nil ~= mainBoss_Calpheon then
    local hpRate = mainBoss_Calpheon:getHpRate() * 100
    NationSiege_Widget:showBossHpWarningMessage(hpRate, 1, mainBoss_Calpheon:getName())
    bossHpSave[1] = hpRate
  end
  local wrapper_Valencia = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.VALENCIA)
  if nil == wrapper_Valencia then
    return
  end
  local mainBoss_Valencia = wrapper_Valencia:getBossByCharacterKey(ToClient_getNationSiegeBossCharacterKey(ENUM_TERRITORY.VALENCIA))
  if nil ~= mainBoss_Valencia then
    local hpRate = mainBoss_Valencia:getHpRate() * 100
    NationSiege_Widget:showBossHpWarningMessage(hpRate, 2, mainBoss_Valencia:getName())
    bossHpSave[2] = hpRate
  end
  for index = 0, ToClient_getNationSiegeSubBossCount() - 1 do
    local subBossWrapper_Calpheon = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.CALPHEON)
    local subBoss_Calpheon = subBossWrapper_Calpheon:getBossByCharacterKey(ToClient_getNationSiegeSubBossCharacterKeyByIndex(ENUM_TERRITORY.CALPHEON, index))
    if nil ~= subBoss_Calpheon then
      local hpRate = subBoss_Calpheon:getHpRate() * 100
      if 0 == index then
        NationSiege_Widget:showBossHpWarningMessage(hpRate, 3, subBoss_Calpheon:getName())
        bossHpSave[3] = hpRate
      else
        NationSiege_Widget:showBossHpWarningMessage(hpRate, 4, subBoss_Calpheon:getName())
        bossHpSave[4] = hpRate
      end
    end
    local subBossWrapper_Valencia = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.VALENCIA)
    local subBoss_Valencia = subBossWrapper_Valencia:getBossByCharacterKey(ToClient_getNationSiegeSubBossCharacterKeyByIndex(ENUM_TERRITORY.VALENCIA, index))
    if nil ~= subBoss_Valencia then
      local hpRate = subBoss_Valencia:getHpRate() * 100
      if 0 == index then
        NationSiege_Widget:showBossHpWarningMessage(hpRate, 5, subBoss_Valencia:getName())
        bossHpSave[5] = hpRate
      else
        NationSiege_Widget:showBossHpWarningMessage(hpRate, 6, subBoss_Valencia:getName())
        bossHpSave[6] = hpRate
      end
    end
  end
end
function NationSiege_Widget:bossWarningMessageCheck(bossClassNum, hpRate, warningLevel)
  if hpRate <= 0 then
    return false
  end
  if bossHpSave[bossClassNum] == hpRate then
    return false
  end
  if hpRate > WARNING_HP_RATE[warningLevel] then
    return false
  end
  if true == bossWarningCheck[bossClassNum][warningLevel] then
    return false
  end
  bossWarningCheck[bossClassNum][warningLevel] = true
  return true
end
function NationSiege_Widget:showBossHpWarningMessage(hpRate, bossClassNum, bossName)
  if nil == hpRate or nil == bossClassNum or nil == bossName then
    return
  end
  if nil == Panel_Widget_NationWar_NakMessage or true == Panel_Widget_NationWar_NakMessage:GetShow() then
    return
  end
  local warningLevel = 1
  if WARNING_HP_RATE[1] < bossHpSave[bossClassNum] then
    warningLevel = 1
  elseif WARNING_HP_RATE[2] < bossHpSave[bossClassNum] then
    warningLevel = 2
  elseif WARNING_HP_RATE[3] < bossHpSave[bossClassNum] then
    warningLevel = 3
  end
  local isShowNak = NationSiege_Widget:bossWarningMessageCheck(bossClassNum, math.floor(hpRate), warningLevel)
  if false == isShowNak then
    return
  end
  mainText = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NAKMESSAGE_NATIONSEIGE_HP_WARNING_BOSS", "bossName", tostring(bossName), "percent", tostring(math.floor(hpRate)))
  subText = bossClassName[bossClassNum]
  msg = {main = mainText, sub = subText}
  PaGlobalFunc_NationWar_Message_Show(msg, 8, NationSiege_Widget._bossWarningShowTime, false)
end
function NationSiege_Widget:initCurrentAllBossHp()
  local wrapper_Calpheon = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.CALPHEON)
  if nil == wrapper_Calpheon then
    return
  end
  local mainBoss_Calpheon = wrapper_Calpheon:getBossByCharacterKey(ToClient_getNationSiegeBossCharacterKey(ENUM_TERRITORY.CALPHEON))
  if nil ~= mainBoss_Calpheon then
    local hpRate = math.floor(mainBoss_Calpheon:getHpRate() * 100)
    NationSiege_Widget:initSaveAndCheck(1, hpRate)
  end
  local wrapper_Valencia = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.VALENCIA)
  if nil == wrapper_Valencia then
    return
  end
  local mainBoss_Valencia = wrapper_Valencia:getBossByCharacterKey(ToClient_getNationSiegeBossCharacterKey(ENUM_TERRITORY.VALENCIA))
  if nil ~= mainBoss_Valencia then
    local hpRate = math.floor(mainBoss_Valencia:getHpRate() * 100)
    NationSiege_Widget:initSaveAndCheck(2, hpRate)
  end
  for index = 0, ToClient_getNationSiegeSubBossCount() - 1 do
    local subBossWrapper_Calpheon = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.CALPHEON)
    local subBoss_Calpheon = subBossWrapper_Calpheon:getBossByCharacterKey(ToClient_getNationSiegeSubBossCharacterKeyByIndex(ENUM_TERRITORY.CALPHEON, index))
    if nil ~= subBoss_Calpheon then
      local hpRate = math.floor(subBoss_Calpheon:getHpRate() * 100)
      if 0 == index then
        NationSiege_Widget:initSaveAndCheck(3, hpRate)
      else
        NationSiege_Widget:initSaveAndCheck(4, hpRate)
      end
    end
    local subBossWrapper_Valencia = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.VALENCIA)
    local subBoss_Valencia = subBossWrapper_Valencia:getBossByCharacterKey(ToClient_getNationSiegeSubBossCharacterKeyByIndex(ENUM_TERRITORY.VALENCIA, index))
    if nil ~= subBoss_Valencia then
      local hpRate = math.floor(subBoss_Valencia:getHpRate() * 100)
      if 0 == index then
        NationSiege_Widget:initSaveAndCheck(5, hpRate)
      else
        NationSiege_Widget:initSaveAndCheck(6, hpRate)
      end
    end
  end
end
function NationSiege_Widget:initSaveAndCheck(bossClassNum, hpRate)
  if nil == bossClassNum or nil == hpRate then
    return
  end
  bossHpSave[bossClassNum] = hpRate
  if hpRate < WARNING_HP_RATE[1] then
    bossWarningCheck[bossClassNum][1] = true
  end
  if hpRate < WARNING_HP_RATE[2] then
    bossWarningCheck[bossClassNum][2] = true
  end
  if hpRate < WARNING_HP_RATE[3] then
    bossWarningCheck[bossClassNum][3] = true
  end
end
function FromClient_NationSiegeReviveAck()
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEG_REVIVE_DESC")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_RESPAWN_MB_TITLE"),
    content = messageBoxMemo,
    functionYes = FromClient_NationSiegeReviveAck_MessageBox_Yes,
    functionNo = FromClient_NationSiegeReviveAck_MessageBox_No,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FromClient_NationSiegeReviveAck_MessageBox_Yes()
  ToClient_AcceptRevive(true)
end
function FromClient_NationSiegeReviveAck_MessageBox_No()
  ToClient_AcceptRevive(false)
end
function PaGloblaFunc_NationSiege_Init()
  local self = NationSiege_Widget
  self:init()
  self:registEvnetHandler()
end
registerEvent("FromClient_NationSiegeReviveAck", "FromClient_NationSiegeReviveAck")
registerEvent("FromClient_luaLoadComplete", "PaGloblaFunc_NationSiege_Init")

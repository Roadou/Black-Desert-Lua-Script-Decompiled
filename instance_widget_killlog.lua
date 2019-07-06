local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local _panel = Instance_Widget_KillLog
local MAX_ROW = 5
local logStruct = {
  stc_logParent = nil,
  stc_weapon_icon = nil,
  stc_text_attacker = nil,
  stct_text_dead = nil,
  isShow = false,
  _index = 0,
  deltaTime = 0,
  second = 0,
  isAnimation = false,
  startPos = float2(0, 0),
  endPos = float2(0, 0),
  _AnimTime = 0
}
logStruct.__index = logStruct
local killLog = {
  _ui = {},
  _logPool = {
    _logData = {},
    _startPosition = float2(0, 0),
    _attackerSize = float2(0, 0),
    _deadSize = float2(0, 0)
  },
  loopRow = MAX_ROW - 1,
  maxViewTime = 10,
  _textOffset = 5,
  _AnimTime = 0.1,
  fAnimDeltaTime = 0,
  isAnimCoolTime = false,
  _msgList = Array.new()
}
local killCount = {}
local dataStruct = {
  attackerName,
  attackeeName,
  attackerClassType,
  attackeeClassType,
  attackerKey,
  attackeeKey,
  attacker_killCount = 0,
  attackee_killCount = 0
}
dataStruct.__index = dataStruct
function dataStruct:set(attackerName, attackeeName, attackerClassType, attackeeClassType, attackerKey, attackeeKey)
  self.attackerName = attackerName
  self.attackeeName = attackeeName
  self.attackerClassType = attackerClassType
  self.attackeeClassType = attackeeClassType
  self.attackerKey = attackerKey
  self.attackeeKey = attackeeKey
  if attackerClassType == CppEnums.ClassType.ClassType_Temp1 or attackerClassType == CppEnums.ClassType.ClassType_Count then
    self.attacker_killCount = 0
    self.attackee_killCount = 0
    return
  end
  self.attacker_killCount = killCount[attackerName]
  if nil ~= killCount[attackeeName] then
    self.attackee_killCount = killCount[attackeeName]
  end
end
function killLog:initialize()
  local logParent = UI.getChildControl(_panel, "Static_log")
  local weaponIcon = UI.getChildControl(_panel, "Static_weapon_icon")
  local attacker = UI.getChildControl(_panel, "StaticText_attacker")
  local dead = UI.getChildControl(_panel, "StaticText_dead")
  local logPool = killLog._logPool
  logPool._startPosition = float2(logParent:GetPosX(), logParent:GetPosY())
  logPool._offsetSizeY = logParent:GetSizeY() + 3
  logPool._attackerSize = float2(attacker:GetSizeX(), attacker:GetSizeY())
  logPool._deadSize = float2(dead:GetSizeX(), dead:GetSizeY())
  for i = 0, killLog.loopRow do
    logPool._logData[i] = {}
    setmetatable(logPool._logData[i], logStruct)
    logPool._logData[i]:cloneControl(logParent, weaponIcon, attacker, dead, i)
    logPool._logData[i]:initialize(self._AnimTime)
  end
  self:registEventHandler()
end
function killLog:registEventHandler()
  registerEvent("FromClient_BattleRoyaleKillLog", "FromClient_killLog_BattleRoyaleKillLog")
  _panel:RegisterUpdateFunc("PaGlobalFunc_killLog_Update")
end
function killLog:open()
  if _panel:GetShow() == true then
    self:close()
    return
  end
  _panel:SetShow(true)
end
function killLog:close()
  _panel:SetShow(false)
end
function killLog:update(deltaTime)
  for i = 0, self.loopRow do
    self._logPool._logData[i]:updateTime(deltaTime)
  end
  self:updateAddLog(deltaTime)
end
function killLog:resize()
end
function killLog:updateAddLog(deltaTime)
  if true == self.isAnimCoolTime then
    self.fAnimDeltaTime = self.fAnimDeltaTime + deltaTime
    if self._AnimTime < self.fAnimDeltaTime then
      self.isAnimCoolTime = false
      self.fAnimDeltaTime = 0
    end
    return
  end
  if 0 < self._msgList:length() then
    local data = self._msgList:pop_front()
    self:addLog(data)
    self.isAnimCoolTime = true
  end
end
function killLog:addLog(data)
  self:addAllIndexing()
  local logPool = killLog._logPool
  local index = self:findWaitingLogIndex()
  logPool._logData[index]:addLog(data)
  self:reposition()
end
function killLog:findWaitingLogIndex()
  local logPool = killLog._logPool
  for i = 0, killLog.loopRow do
    if false == logPool._logData[i].isShow then
      return i
    end
  end
  return 0
end
function killLog:addAllIndexing()
  local logPool = killLog._logPool
  for i = 0, killLog.loopRow do
    if true == logPool._logData[i].isShow then
      logPool._logData[i]._index = logPool._logData[i]._index + 1
      if MAX_ROW <= logPool._logData[i]._index then
        logPool._logData[i].isShow = false
      end
    end
  end
end
function killLog:reposition()
  local logPool = killLog._logPool
  for i = 0, killLog.loopRow do
    logPool._logData[i]:reposition(logPool._startPosition, logPool._offsetSizeY)
  end
end
function logStruct:initialize(_AnimTime)
  self._index = 0
  self.isShow = false
  self._AnimTime = _AnimTime
  self.stc_logParent:SetShow(false)
  self.stc_weapon_icon:SetShow(false)
  self.stc_text_attacker:SetShow(true)
  self.stct_text_dead:SetShow(false)
end
function logStruct:cloneControl(logParent, weaponIcon, attacker, dead, index)
  self.stc_logParent = UI.cloneControl(logParent, _panel, "Static_log" .. index)
  self.stc_text_attacker = UI.cloneControl(attacker, self.stc_logParent, "StaticText_attacker" .. index)
  self.stc_weapon_icon = UI.cloneControl(weaponIcon, self.stc_logParent, "Static_weapon_icon_" .. index)
  self.stct_text_dead = UI.cloneControl(dead, self.stc_logParent, "StaticText_dead" .. index)
end
function logStruct:addLog(data)
  local stringHead = ""
  if data.attackerName == data.attackeeName and data.attackerClassType == CppEnums.ClassType.ClassType_Temp1 then
    self.stc_text_attacker:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_KILLLOG_SUICIDE", "name", data.attackerName))
  elseif 0 ~= data.attackerKey then
    local staticStatusWrapper = ToClient_GetCharacterStaticStatusWrapper(data.attackerKey)
    if nil == staticStatusWrapper then
      return
    end
    local attackerName = staticStatusWrapper:getName()
    local attackerString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ATTACKER_MONSTER", "name", attackerName)
    local attackeeString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ATTACKEESTRING", "name", data.attackeeName, "class", CppEnums.ClassType2String[data.attackeeClassType])
    self.stc_text_attacker:SetText(stringHead .. " " .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_KILLLOG_2", "attacker", attackerString, "attackee", attackeeString))
  else
    if 2 < data.attacker_killCount then
      stringHead = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_KILLCOUNT", "killCount", data.attacker_killCount)
    end
    local attackerString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ATTACKERSTRING", "name", data.attackerName, "class", CppEnums.ClassType2String[data.attackerClassType])
    local attackeeString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ATTACKEESTRING", "name", data.attackeeName, "class", CppEnums.ClassType2String[data.attackeeClassType])
    if 2 < data.attackee_killCount then
      self.stc_text_attacker:SetText(stringHead .. " " .. PAGetStringParam3(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_KILLLOG_1", "attacker", attackerString, "attackee", attackeeString, "count", data.attackee_killCount))
    else
      self.stc_text_attacker:SetText(stringHead .. " " .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_KILLLOG_2", "attacker", attackerString, "attackee", attackeeString))
    end
  end
  self.isShow = true
  self.deltaTime = 0
  self._index = 0
  self.isAnimation = false
end
function logStruct:reposition(startPos, offsetSize)
  if true == self.isShow then
    self.stc_logParent:SetPosXY(startPos.x, startPos.y + offsetSize * self._index)
    self:addAnimation(startPos, offsetSize)
  end
  self.stc_logParent:SetShow(self.isShow)
end
function logStruct:addAnimation(startPos, offsetSize)
  if false == self.isShow or true == self.isAnimation then
    return
  end
  local moveAni = self.stc_logParent:addMoveAnimation(0, self._AnimTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  moveAni:SetStartPosition(startPos.x + 200, startPos.y + offsetSize * self._index)
  moveAni:SetEndPosition(startPos.x, startPos.y + offsetSize * self._index)
  self.isAnimation = true
end
function logStruct:updateTime(deltaTime)
  if false == self.isShow then
    return
  end
  self.deltaTime = self.deltaTime + deltaTime
  if killLog.maxViewTime < self.deltaTime then
    self.isShow = false
    self.deltaTime = 0
    killLog:reposition()
  end
end
function FromClient_killLog_Init()
  local self = killLog
  self:initialize()
  self:open()
end
function FromClient_killLog_ScreenResize()
  local self = killLog
  self:resize()
end
function PaGlobalFunc_killLog_Open()
  local self = killLog
  self:open()
end
function PaGlobalFunc_killLog_Close()
  local self = killLog
  self:close()
end
function PaGlobalFunc_killLog_Update(deltaTime)
  local self = killLog
  self:update(deltaTime)
end
function FromClient_killLog_BattleRoyaleKillLog(attackerName, attackeeName, attackerClassType, attackeeClassType, attackerKey, attackeeKey)
  local self = killLog
  if nil ~= attackerName then
    if nil == killCount[attackerName] then
      killCount[attackerName] = 1
    else
      killCount[attackerName] = killCount[attackerName] + 1
    end
  end
  local data = {}
  setmetatable(data, dataStruct)
  data:set(attackerName, attackeeName, attackerClassType, attackeeClassType, attackerKey, attackeeKey)
  self._msgList:push_back(data)
  local myName = getSelfPlayer():getUserNickname()
  if attackerName == myName and CppEnums.ClassType.ClassType_Temp1 ~= attackerClassType and CppEnums.ClassType.ClassType_Count ~= attackerClassType then
    local msg = {}
    msg.main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_KILLMSG_MAIN", "classType", CppEnums.ClassType2String[attackeeClassType])
    msg.sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_KILLMSG_SUB", "count", killCount[attackerName])
    PaGlobal_KillMessage(killCount[attackerName])
    PaGlobal_KillUpdate(killCount[attackerName], attackeeClassType)
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_killLog_Init")

local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
function PaGlobal_NationSiegeKillLog:initialize()
  if true == PaGlobal_NationSiegeKillLog._initialize then
    return
  end
  PaGlobal_NationSiegeKillLog._ui.stc_log = UI.getChildControl(Panel_Widget_NationSiegeKillLog, "Static_log")
  PaGlobal_NationSiegeKillLog._ui.txt_killer = UI.getChildControl(Panel_Widget_NationSiegeKillLog, "StaticText_attacker")
  PaGlobal_NationSiegeKillLog._ui.stc_calpheonIcon = UI.getChildControl(Panel_Widget_NationSiegeKillLog, "Static_calpheon_icon")
  PaGlobal_NationSiegeKillLog._ui.stc_valenciaIcon = UI.getChildControl(Panel_Widget_NationSiegeKillLog, "Static_valencia_icon")
  PaGlobal_NationSiegeKillLog._ui.txt_victim = UI.getChildControl(Panel_Widget_NationSiegeKillLog, "StaticText_dead")
  PaGlobal_NationSiegeKillLog._logPool._startPos = float2(PaGlobal_NationSiegeKillLog._ui.stc_log:GetPosX(), PaGlobal_NationSiegeKillLog._ui.stc_log:GetPosY())
  PaGlobal_NationSiegeKillLog._logPool._offsetSizeY = PaGlobal_NationSiegeKillLog._ui.stc_log:GetSizeY() + 6
  PaGlobal_NationSiegeKillLog._logPool._killerSize = float2(PaGlobal_NationSiegeKillLog._ui.txt_killer:GetSizeX(), PaGlobal_NationSiegeKillLog._ui.txt_killer:GetSizeY())
  PaGlobal_NationSiegeKillLog._logPool._victimSize = float2(PaGlobal_NationSiegeKillLog._ui.txt_victim:GetSizeX(), PaGlobal_NationSiegeKillLog._ui.txt_victim:GetSizeY())
  for ii = 0, PaGlobal_NationSiegeKillLog._LOOP_ROW do
    PaGlobal_NationSiegeKillLog._logPool._logData[ii] = {}
    PaGlobal_NationSiegeKillLog._logPool._logData[ii].stc_log = UI.cloneControl(PaGlobal_NationSiegeKillLog._ui.stc_log, Panel_Widget_NationSiegeKillLog, "Static_log" .. ii)
    PaGlobal_NationSiegeKillLog._logPool._logData[ii].txt_killer = UI.cloneControl(PaGlobal_NationSiegeKillLog._ui.txt_killer, PaGlobal_NationSiegeKillLog._logPool._logData[ii].stc_log, "StaticText_attacker" .. ii)
    PaGlobal_NationSiegeKillLog._logPool._logData[ii].stc_calpheonIcon = UI.cloneControl(PaGlobal_NationSiegeKillLog._ui.stc_calpheonIcon, PaGlobal_NationSiegeKillLog._logPool._logData[ii].stc_log, "Static_calpheon_icon" .. ii)
    PaGlobal_NationSiegeKillLog._logPool._logData[ii].stc_valenciaIcon = UI.cloneControl(PaGlobal_NationSiegeKillLog._ui.stc_valenciaIcon, PaGlobal_NationSiegeKillLog._logPool._logData[ii].stc_log, "Static_valencia_icon" .. ii)
    PaGlobal_NationSiegeKillLog._logPool._logData[ii].txt_victim = UI.cloneControl(PaGlobal_NationSiegeKillLog._ui.txt_victim, PaGlobal_NationSiegeKillLog._logPool._logData[ii].stc_log, "StaticText_dead" .. ii)
    PaGlobal_NationSiegeKillLog:initalizeLogData(ii)
  end
  PaGlobal_NationSiegeKillLog:registEventHandler()
  PaGlobal_NationSiegeKillLog:validate()
  PaGlobal_NationSiegeKillLog._initialize = true
end
function PaGlobal_NationSiegeKillLog:initalizeLogData(index)
  if nil == PaGlobal_NationSiegeKillLog._logPool._logData[index] then
    return
  end
  PaGlobal_NationSiegeKillLog._logPool._logData[index].index = 0
  PaGlobal_NationSiegeKillLog._logPool._logData[index].deltaTime = 0
  PaGlobal_NationSiegeKillLog._logPool._logData[index].isShow = false
  PaGlobal_NationSiegeKillLog._logPool._logData[index].isAnimation = false
  PaGlobal_NationSiegeKillLog._logPool._logData[index].animTime = 0
  PaGlobal_NationSiegeKillLog._logPool._logData[index].killerNation = 0
  PaGlobal_NationSiegeKillLog._logPool._logData[index].logAnimTime = PaGlobal_NationSiegeKillLog._logAnimTime
  PaGlobal_NationSiegeKillLog._logPool._logData[index].stc_log:SetShow(false)
  PaGlobal_NationSiegeKillLog._logPool._logData[index].txt_killer:SetShow(false)
  PaGlobal_NationSiegeKillLog._logPool._logData[index].stc_calpheonIcon:SetShow(false)
  PaGlobal_NationSiegeKillLog._logPool._logData[index].stc_valenciaIcon:SetShow(false)
  PaGlobal_NationSiegeKillLog._logPool._logData[index].txt_victim:SetShow(false)
end
function PaGlobal_NationSiegeKillLog:registEventHandler()
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  registerEvent("FromClient_NationSiegePlayerDead", "FromClient_NationSiegePlayerDead")
  Panel_Widget_NationSiegeKillLog:RegisterUpdateFunc("PaGlobalFunc_NationSiegeKillLog_Update")
end
function PaGlobal_NationSiegeKillLog:prepareOpen()
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
end
function PaGlobal_NationSiegeKillLog:open()
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  Panel_Widget_NationSiegeKillLog:SetShow(true)
end
function PaGlobal_NationSiegeKillLog:prepareClose()
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
end
function PaGlobal_NationSiegeKillLog:close()
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  Panel_Widget_NationSiegeKillLog:SetShow(false)
end
function PaGlobal_NationSiegeKillLog:update(deltaTime)
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  for ii = 0, PaGlobal_NationSiegeKillLog._LOOP_ROW do
    PaGlobal_NationSiegeKillLog:updateLogTime(ii, deltaTime)
  end
  PaGlobal_NationSiegeKillLog:updateAddLog(deltaTime)
end
function PaGlobal_NationSiegeKillLog:validate()
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  PaGlobal_NationSiegeKillLog._ui.stc_log:isValidate()
  PaGlobal_NationSiegeKillLog._ui.txt_killer:isValidate()
  PaGlobal_NationSiegeKillLog._ui.stc_calpheonIcon:isValidate()
  PaGlobal_NationSiegeKillLog._ui.stc_valenciaIcon:isValidate()
  PaGlobal_NationSiegeKillLog._ui.txt_victim:isValidate()
end
function PaGlobal_NationSiegeKillLog:killEventDataSet(victimUserNo, victimRegionName, victimTeamTerritory, victimName, victimGuildName, killerTerritory, killerName, killerGuildName)
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  local data = {}
  data.victimUserNo = victimUserNo
  data.victimRegionName = victimRegionName
  data.victimTeamTerritory = victimTeamTerritory
  data.victimName = victimName
  data.victimGuildName = victimGuildName
  data.killerTerritory = killerTerritory
  data.killerName = killerName
  data.killerGuildName = killerGuildName
  if nil ~= killerName then
    if nil == PaGlobal_NationSiegeKillLog._killCount[killerName] then
      PaGlobal_NationSiegeKillLog._killCount[killerName] = 1
    else
      PaGlobal_NationSiegeKillLog._killCount[killerName] = PaGlobal_NationSiegeKillLog._killCount[killerName] + 1
    end
  end
  PaGlobal_NationSiegeKillLog._msgList:push_back(data)
end
function PaGlobal_NationSiegeKillLog:reposition()
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  if nil == PaGlobal_NationSiegeKillLog._logPool then
    return
  end
  for ii = 0, PaGlobal_NationSiegeKillLog._LOOP_ROW do
    PaGlobal_NationSiegeKillLog:repositionLog(ii)
  end
end
function PaGlobal_NationSiegeKillLog:repositionLog(index)
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  if nil == index then
    return
  end
  local startPos = PaGlobal_NationSiegeKillLog._logPool._startPos
  local offsetSize = PaGlobal_NationSiegeKillLog._logPool._offsetSizeY
  if true == PaGlobal_NationSiegeKillLog._logPool._logData[index].isShow then
    PaGlobal_NationSiegeKillLog._logPool._logData[index].stc_log:SetPosXY(startPos.x, startPos.y + offsetSize * PaGlobal_NationSiegeKillLog._logPool._logData[index].index)
    PaGlobal_NationSiegeKillLog:addLogAnimation(index, startPos, offsetSize)
  end
  PaGlobal_NationSiegeKillLog._logPool._logData[index].stc_log:SetShow(PaGlobal_NationSiegeKillLog._logPool._logData[index].isShow)
  PaGlobal_NationSiegeKillLog._logPool._logData[index].txt_killer:SetShow(PaGlobal_NationSiegeKillLog._logPool._logData[index].isShow)
  if 2 == PaGlobal_NationSiegeKillLog._logPool._logData[index].killerNation then
    PaGlobal_NationSiegeKillLog._logPool._logData[index].stc_calpheonIcon:SetShow(true)
    PaGlobal_NationSiegeKillLog._logPool._logData[index].stc_valenciaIcon:SetShow(false)
  elseif 4 == PaGlobal_NationSiegeKillLog._logPool._logData[index].killerNation then
    PaGlobal_NationSiegeKillLog._logPool._logData[index].stc_calpheonIcon:SetShow(false)
    PaGlobal_NationSiegeKillLog._logPool._logData[index].stc_valenciaIcon:SetShow(true)
  end
  PaGlobal_NationSiegeKillLog._logPool._logData[index].stc_calpheonIcon:SetPosX(PaGlobal_NationSiegeKillLog._logPool._logData[index].txt_killer:GetPosX())
  PaGlobal_NationSiegeKillLog._logPool._logData[index].stc_valenciaIcon:SetPosX(PaGlobal_NationSiegeKillLog._logPool._logData[index].txt_killer:GetPosX())
  PaGlobal_NationSiegeKillLog._logPool._logData[index].txt_victim:SetShow(false)
end
function PaGlobal_NationSiegeKillLog:updateLogTime(index, deltaTime)
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  if nil == PaGlobal_NationSiegeKillLog._logPool._logData[index] then
    return
  end
  if false == PaGlobal_NationSiegeKillLog._logPool._logData[index].isShow then
    return
  end
  PaGlobal_NationSiegeKillLog._logPool._logData[index].deltaTime = PaGlobal_NationSiegeKillLog._logPool._logData[index].deltaTime + deltaTime
  if PaGlobal_NationSiegeKillLog._maxViewTime < PaGlobal_NationSiegeKillLog._logPool._logData[index].deltaTime then
    PaGlobal_NationSiegeKillLog._logPool._logData[index].isShow = false
    PaGlobal_NationSiegeKillLog._logPool._logData[index].deltaTime = 0
    PaGlobal_NationSiegeKillLog:reposition()
  end
end
function PaGlobal_NationSiegeKillLog:addLogAnimation(index, startPos, offsetSize)
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  if nil == index or nil == startPos or nil == offsetSize then
    return
  end
  if false == PaGlobal_NationSiegeKillLog._logPool._logData[index].isShow or PaGlobal_NationSiegeKillLog._logPool._logData[index].isAnimation then
    return
  end
  PaGlobal_NationSiegeKillLog._logPool._logData[index].isAnimation = true
end
function PaGlobal_NationSiegeKillLog:updateAddLog(deltaTime)
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  if nil == deltaTime then
    return
  end
  if true == PaGlobal_NationSiegeKillLog._isAnimCool then
    PaGlobal_NationSiegeKillLog._fAnimDeltaTime = PaGlobal_NationSiegeKillLog._fAnimDeltaTime + deltaTime
    if PaGlobal_NationSiegeKillLog._logAnimTime < PaGlobal_NationSiegeKillLog._fAnimDeltaTime then
      PaGlobal_NationSiegeKillLog._isAnimCool = false
      PaGlobal_NationSiegeKillLog._fAnimDeltaTime = 0
    end
    return
  end
  if 0 < PaGlobal_NationSiegeKillLog._msgList:length() then
    local data = PaGlobal_NationSiegeKillLog._msgList:pop_front()
    PaGlobal_NationSiegeKillLog:addLog(data)
    PaGlobal_NationSiegeKillLog._isAnimCool = true
  end
end
function PaGlobal_NationSiegeKillLog:addLog(data)
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  PaGlobal_NationSiegeKillLog:pushAllIndexing()
  local findIdx = PaGlobal_NationSiegeKillLog:findWaitngLogIndex()
  PaGlobal_NationSiegeKillLog:addLogDataSet(findIdx, data)
  PaGlobal_NationSiegeKillLog:reposition()
end
function PaGlobal_NationSiegeKillLog:pushAllIndexing()
  for ii = 0, PaGlobal_NationSiegeKillLog._LOOP_ROW do
    if true == PaGlobal_NationSiegeKillLog._logPool._logData[ii].isShow then
      PaGlobal_NationSiegeKillLog._logPool._logData[ii].index = PaGlobal_NationSiegeKillLog._logPool._logData[ii].index + 1
      if PaGlobal_NationSiegeKillLog._MAX_ROW <= PaGlobal_NationSiegeKillLog._logPool._logData[ii].index then
        PaGlobal_NationSiegeKillLog._logPool._logData[ii].isShow = false
      end
    end
  end
end
function PaGlobal_NationSiegeKillLog:findWaitngLogIndex()
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  for ii = 0, PaGlobal_NationSiegeKillLog._LOOP_ROW do
    if false == PaGlobal_NationSiegeKillLog._logPool._logData[ii].isShow then
      return ii
    end
  end
  return 0
end
function PaGlobal_NationSiegeKillLog:addLogDataSet(index, data)
  if nil == Panel_Widget_NationSiegeKillLog then
    return
  end
  if nil == index or nil == data then
    return
  end
  local killerTerritory = ""
  local killCount = PaGlobal_NationSiegeKillLog._killCount[data.killerName]
  local CaltextUV = {
    x1 = 1,
    y1 = 1,
    x2 = 193,
    y2 = 26
  }
  local ValtextUV = {
    x1 = 1,
    y1 = 27,
    x2 = 193,
    y2 = 52
  }
  if 2 == data.killerTerritory then
    killerTerritory = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSEIGE_NATIONNAME_CALPHEON_01")
    PaGlobal_NationSiegeKillLog._logPool._logData[index].killerNation = 2
  elseif 4 == data.killerTerritory then
    killerTerritory = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSEIGE_NATIONNAME_VALENCIA_01")
    PaGlobal_NationSiegeKillLog._logPool._logData[index].killerNation = 4
  end
  local logStr = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_KILLLOG_TEXT", "killerName", data.killerName, "victimName", data.victimName, "victimRegionName", data.victimRegionName)
  if nil ~= killCount and killCount >= 2 then
    logStr = logStr .. " " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_KILLLOG_ADD_KILLCOUNT", "killCount", killCount)
  end
  PaGlobal_NationSiegeKillLog._logPool._logData[index].txt_killer:SetText(logStr)
  PaGlobal_NationSiegeKillLog._logPool._logData[index].txt_killer:SetSize(PaGlobal_NationSiegeKillLog._logPool._logData[index].txt_killer:GetTextSizeX() + 65, PaGlobal_NationSiegeKillLog._logPool._logData[index].txt_killer:GetTextSizeY())
  PaGlobal_NationSiegeKillLog._logPool._logData[index].txt_killer:ComputePos()
  PaGlobal_NationSiegeKillLog._logPool._logData[index].isShow = true
  PaGlobal_NationSiegeKillLog._logPool._logData[index].deltaTime = 0
  PaGlobal_NationSiegeKillLog._logPool._logData[index].index = 0
  PaGlobal_NationSiegeKillLog._logPool._logData[index].isAnimation = false
end

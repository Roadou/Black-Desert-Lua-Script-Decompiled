function PaGlobal_WatchTimer:initialize()
  if true == PaGlobal_WatchTimer._initialize then
    return
  end
  local textSizeX = PaGlobal_WatchTimer._ui._timerText:GetTextSizeX()
  local isGapX = Instance_Widget_WatchTimer:GetSizeX() - (textSizeX + PaGlobal_WatchTimer._ui.stc_surviveTime:GetSizeX() + PaGlobal_WatchTimer._ui.stc_surviveTime:GetSpanSize().x + PaGlobal_WatchTimer._ui._timerText:GetSpanSize().x)
  if isGapX < 0 then
    Instance_Widget_WatchTimer:SetSize(Instance_Widget_WatchTimer:GetSizeX() + math.abs(isGapX) + 15, Instance_Widget_WatchTimer:GetSizeY())
    PaGlobal_WatchTimer._ui._timerText:ComputePos()
  end
  PaGlobal_WatchTimer:registEventHandler()
  PaGlobal_WatchTimer:validate()
  PaGlobal_WatchTimer:onScreenResize()
  PaGlobal_WatchTimer._initialize = true
  PaGlobal_WatchTimer:checkClass()
end
function PaGlobal_WatchTimer:checkClass()
  local playerWrapper = getSelfPlayer()
  local classType = playerWrapper:getClassType()
  if 2 == classType then
    PaGlobal_WatchTimer:close()
  else
    PaGlobal_WatchTimer:open()
  end
end
function PaGlobal_WatchTimer:registEventHandler()
  Instance_Widget_WatchTimer:RegisterUpdateFunc("PaGlobalFunc_WatchTimer_UpdatePerFrame")
end
function PaGlobal_WatchTimer:onScreenResize()
  if nil ~= Instance_Radar then
    Instance_Widget_WatchTimer:SetPosX(Instance_Radar:GetPosX() + (Instance_Radar:GetSizeX() - Instance_Widget_WatchTimer:GetSizeX()) / 2)
  end
end
function PaGlobal_WatchTimer:open()
  if nil ~= PaGlobal_WatchTimer then
    Instance_Widget_WatchTimer:SetShow(true)
  end
end
function PaGlobal_WatchTimer:close()
  if nil ~= PaGlobal_WatchTimer then
    Instance_Widget_WatchTimer:SetShow(false)
  end
end
function PaGlobalFunc_WatchTimer_ReturnAliveTime()
  return PaGlobal_WatchTimer._lastUpdateTime
end
function PaGlobalFunc_WatchTimer_Open()
  PaGlobal_WatchTimer:open()
end
function PaGlobalFunc_WatchTimer_Close()
  PaGlobal_WatchTimer:close()
end
function PaGlobalFunc_WatchTimer_UpdatePerFrame(deltatime)
  PaGlobal_WatchTimer:update(deltatime)
end
function PaGlobal_WatchTimer:update(deltatime)
  PaGlobal_WatchTimer._timer = PaGlobal_WatchTimer._timer + deltatime
  if PaGlobal_WatchTimer._timer < PaGlobal_WatchTimer._lastUpdateTime + 1 then
    return
  end
  if 0 == PaGlobal_WatchTimer._brStartTime then
    local brStartTime = ToClient_BattleRoyaleStartTime()
    if nil == brStartTime then
      return
    end
    PaGlobal_WatchTimer._brStartTime = Int64toInt32(brStartTime)
  end
  PaGlobal_WatchTimer._lastUpdateTime = math.floor(PaGlobal_WatchTimer._timer)
  local brStartTime = PaGlobal_WatchTimer._brStartTime
  local serverUtcTime = getServerUtc64()
  local elapsedTime = 0
  if nil ~= brStartTime and nil ~= serverUtcTime then
    elapsedTime = 0
    serverUtcTime = Int64toInt32(serverUtcTime)
    if brStartTime ~= 0 then
      elapsedTime = serverUtcTime - brStartTime
    else
      return
    end
  end
  if elapsedTime < 0 then
    return
  end
  local clockMinutes = math.floor(elapsedTime / 60)
  local clockSeconds = elapsedTime % 60
  local clockMinutesText = ""
  local clockSecondsText = ""
  if clockMinutes < 0 then
    clockMinutes = 0
  end
  if clockMinutes < 10 then
    clockMinutesText = clockMinutesText .. "0" .. tostring(clockMinutes)
  else
    clockMinutesText = clockMinutesText .. tostring(clockMinutes)
  end
  if clockSeconds < 0 then
    clockSeconds = 0
  end
  if clockSeconds < 10 then
    clockSecondsText = clockSecondsText .. "0" .. tostring(clockSeconds)
  else
    clockSecondsText = clockSecondsText .. tostring(clockSeconds)
  end
  PaGlobal_WatchTimer._ui._timerText:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_RESULT_TIME", "minute", clockMinutesText, "second", clockSecondsText))
end
function PaGlobal_WatchTimer:validate()
  local timerUi = PaGlobal_WatchTimer._ui
end

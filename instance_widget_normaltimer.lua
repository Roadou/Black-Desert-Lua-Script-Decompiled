local _panel = Instance_Widget_NormalTimer
local normalTimer = {
  _ui = {
    _leftTime = UI.getChildControl(_panel, "StaticText_LeftTime")
  },
  _leftTime = 60,
  _isGameStart = false,
  _isScreetRoomMaster = false,
  _isTrainingRoom = false,
  _isFullGameStart = false
}
function normalTimer:open()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  self._isScreetRoomMaster = selfPlayer:get():getUserNo() == ToClient_GetBattleRoyalePrivateGameHost()
  self._isTrainingRoom = ToClient_IsBattleRoyaleTrainingRoom()
  if self._isScreetRoomMaster then
    return
  end
  if true == self._isTrainingRoom then
    return
  end
  _panel:SetShow(true)
end
function normalTimer:close()
  _panel:SetShow(false)
end
function PaGlobalFunc_NormalTimer_UpdatePerFrame(deltaTime)
  local self = normalTimer
  if self._leftTime < 0 then
    _panel:ClearUpdateLuaFunc()
    self:close()
    return
  elseif true == self._isFullGameStart then
    _panel:ClearUpdateLuaFunc()
    normalTimer._ui._leftTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_REMAIN_STARTMESSAGE"))
    return
  end
  self._leftTime = self._leftTime - deltaTime
  self._ui._leftTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_REMAIN_STARTTIME", "time", math.floor(self._leftTime)))
end
function PaGlobalFunc_NormalTimerStart(isLate)
  if not _panel:GetShow() then
    return
  end
  local self = normalTimer
  if self._isScreetRoomMaster or self._isTrainingRoom then
    return
  end
  if isLate then
    if not self._isGameStart then
      self._ui._leftTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_REMAIN_STARTMESSAGE"))
    end
  else
    self._isGameStart = true
    _panel:RegisterUpdateFunc("PaGlobalFunc_NormalTimer_UpdatePerFrame")
  end
end
function PaGlobalFunc_NormalTimerFullStart()
  if nil == Instance_Widget_NormalTimer then
    return
  end
  normalTimer._isFullGameStart = true
  Instance_Widget_NormalTimer:ClearUpdateLuaFunc()
  normalTimer._ui._leftTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_REMAIN_STARTMESSAGE"))
end
function PaGlobalFunc_NormalTimer_Open()
  local self = normalTimer
  self:open()
end
function PaGlobalFunc_NormalTimer_Close()
  local self = normalTimer
  self:close()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_NormalTimer_Open")

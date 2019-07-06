local _panel = Instance_Widget_Timer
local PrivateTimeMessage = {
  _ui = {
    _txt_privateDesc = UI.getChildControl(_panel, "StaticText_PrivateDesc"),
    _txt_privateLimitDesc = UI.getChildControl(_panel, "StaticText_PrivateLimitDesc"),
    _btn_privateTimeSetButton = UI.getChildControl(_panel, "Button_PrivateTimeSetButton")
  },
  _maxCount = 3,
  _currentCount = 0,
  _leftTime = 300,
  _plusTime = 300,
  _leftTimeString = "",
  _isGameStart = false
}
function PrivateTimeMessage:open()
  _panel:SetShow(true)
end
function PrivateTimeMessage:close()
  _panel:SetShow(false)
end
function PrivateTimeMessage:updateDesc()
  self._ui._txt_privateDesc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_TIMER_ALERT", "leftTime", self._leftTimeString))
end
function PrivateTimeMessage:UpdatePerFrame(deltaTime)
  if self._leftTime <= 0 then
    PaGlobalFunc_PrivateTimeMessage_GameStart()
    return
  end
  self._leftTime = self._leftTime - deltaTime
  if self._leftTime < 60 then
    self._leftTimeString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_TIMER_SECOND", "sec", math.floor(self._leftTime))
    if self._currentCount < self._maxCount then
      self._ui._btn_privateTimeSetButton:SetShow(true)
      self._ui._txt_privateLimitDesc:SetShow(true)
    end
  else
    self._leftTimeString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_TIMER_MINUTE", "min", math.floor(self._leftTime / 60))
  end
  self:updateDesc()
end
function PrivateTimeMessage:isMaster()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return false
  end
  return selfPlayer:get():getUserNo() == ToClient_GetBattleRoyalePrivateGameHost()
end
function PrivateTimeMessage:registEventHandler()
  self._ui._btn_privateTimeSetButton:addInputEvent("Mouse_LUp", "InputMLUp_PrivateTimeMessage_TimeIncrease()")
  _panel:RegisterUpdateFunc("PaGlobalFunc_PrivateTimeMessage_Timer_UpdatePerFrame")
  registerEvent("FromClient_BattleRoyaleStateChanged", "FromClient_PrivateTimeMessage_BattleRoyaleStateChanged")
end
function PaGlobalFunc_PrivateTimeMessage_Timer_UpdatePerFrame(deltaTime)
  local self = PrivateTimeMessage
  if nil == self then
    return
  end
  self:UpdatePerFrame(deltaTime)
end
function PaGlobalFunc_PrivateTimeMessage_GetIsStart()
  local self = PrivateTimeMessage
  if nil == self then
    return false
  end
  return self._isGameStart
end
function PaGlobalFunc_PrivateTimeMessage_GameStart()
  local self = PrivateTimeMessage
  if nil == self then
    return
  end
  if false == PaGlobal_WidgetLeave_GetIsStart() then
    ToClient_StartBattleRoyalPrivateRoom()
  end
  self:close()
  _panel:ClearUpdateLuaFunc()
  self._isGameStart = true
end
function PaGlobalFunc_PrivateTimeMessage_Init()
  local self = PrivateTimeMessage
  if true == self:isMaster() then
    self:registEventHandler()
    self:open()
  end
  self._ui._btn_privateTimeSetButton:SetShow(false)
  self._ui._txt_privateLimitDesc:SetShow(false)
end
function FromClient_PrivateTimeMessage_BattleRoyaleStateChanged(state)
  local self = PrivateTimeMessage
  if state > 0 then
    self:close()
    _panel:ClearUpdateLuaFunc()
  end
end
function InputMLUp_PrivateTimeMessage_TimeIncrease()
  local self = PrivateTimeMessage
  if nil == self then
    return
  end
  if self._maxCount <= self._currentCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_TIMER_CANTEXTENTION"))
    return
  end
  self._currentCount = self._currentCount + 1
  self._leftTime = self._leftTime + self._plusTime
  self:updateDesc()
  self._ui._btn_privateTimeSetButton:SetShow(false)
  self._ui._txt_privateLimitDesc:SetShow(false)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_PrivateTimeMessage_Init")

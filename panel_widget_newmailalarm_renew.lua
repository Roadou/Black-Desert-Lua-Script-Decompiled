local NewMailAlarm = {_animationTime = 0, _remainTime = 4}
local _panel = Panel_Widget_NewMailAlarm_Renew
function NewMailAlarm:initialize()
  _panel:RegisterUpdateFunc("FromClient_NewMailAlarm_UpdatePerFrame")
  registerEvent("FromClient_NewMail", "FromClient_NewMailAlarm")
end
function FromClient_luaLoadComplete_NewMailAlarm_Init()
  NewMailAlarm:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_NewMailAlarm_Init")
function NewMailAlarm:ShowAni()
  local alarmMoveAni1 = _panel:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  alarmMoveAni1:SetStartPosition(getScreenSizeX() + 10, getScreenSizeY() - _panel:GetSizeY() - 80)
  alarmMoveAni1:SetEndPosition(getScreenSizeX() - _panel:GetSizeX() - 20, getScreenSizeY() - _panel:GetSizeY() - 80)
  alarmMoveAni1.IsChangeChild = true
  _panel:CalcUIAniPos(alarmMoveAni1)
  alarmMoveAni1:SetDisableWhileAni(true)
end
function NewMailAlarm:HideAni()
  local alarmMoveAni2 = _panel:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  alarmMoveAni2:SetStartPosition(_panel:GetPosX(), getScreenSizeY() - _panel:GetSizeY() - 80)
  alarmMoveAni2:SetEndPosition(getScreenSizeX() + 10, getScreenSizeY() - _panel:GetSizeY() - 80)
  alarmMoveAni2.IsChangeChild = true
  _panel:CalcUIAniPos(alarmMoveAni2)
  alarmMoveAni2:SetDisableWhileAni(true)
  alarmMoveAni2:SetHideAtEnd(true)
  alarmMoveAni2:SetDisableWhileAni(true)
  Panel_Tooltip_Item_hideTooltip()
end
function FromClient_NewMailAlarm_UpdatePerFrame(deltaTime)
  local self = NewMailAlarm
  self._animationTime = self._animationTime + deltaTime
  if self._remainTime < self._animationTime then
    self._animationTime = 0
    self:HideAni()
  end
end
function FromClient_NewMailAlarm()
  _AudioPostEvent_SystemUiForXBOX(10, 1)
  local self = NewMailAlarm
  self._animationTime = 0
  _panel:SetShow(true)
  self:ShowAni()
end

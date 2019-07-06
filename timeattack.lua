registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_TimeAttack")
registerEvent("FromClient_startTimeAttack", "FromClient_startTimeAttack")
registerEvent("FromClient_endTimeAttack", "FromClient_endTimeAttack")
registerEvent("FromClient_closeTimeAttackUI", "FromClient_closeTimeAttackUI")
Panel_TimeAttack:SetShow(false)
PaGlobal_TimeAttack = {
  _expiredTime = 0,
  _isProgress = false,
  _uiRemainTime = UI.getChildControl(Panel_TimeAttack, "StaticText_BossName"),
  _panelPosX = 0,
  _panelPosY = 0
}
function PaGlobal_TimeAttack:TimeAttack_Initialize()
  self._panelPosX = getScreenSizeX() / 2 - Panel_TimeAttack:GetSizeX() / 2
  self._panelPosY = getScreenSizeY() / 2 - 300
  Panel_TimeAttack:SetPosX(PaGlobal_TimeAttack._panelPosX)
  Panel_TimeAttack:SetPosY(PaGlobal_TimeAttack._panelPosY)
end
function PaGlobal_TimeAttack:openTimeAttack()
  Panel_TimeAttack:SetShow(true)
end
function PaGlobal_TimeAttack:closeTimeAttack()
  Panel_TimeAttack:SetShow(false)
end
function PaGlobal_TimeAttack:setInfo(expiredTime)
  self._expiredTime = expiredTime
end
function PaGlobal_TimeAttack:getExpiredTime()
  return self._expiredTime
end
function PaGlobal_TimeAttack:isProgress()
  return self._isProgress
end
function FromClient_startTimeAttack(expiredTime)
  PaGlobal_TimeAttack._isProgress = true
  PaGlobal_TimeAttack:setInfo(expiredTime)
  PaGlobal_TimeAttack:openTimeAttack()
end
function FromClient_endTimeAttack(isSuccess, clearTime)
  local msg = {}
  if true == isSuccess then
    local timeString = Util.Time.timeFormatting(Int64toInt32(clearTime))
    msg.main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TIMAATTACK_SUCCESSMSG", "time", timeString)
    msg.sub = ""
    msg.addMsg = ""
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 70)
  elseif false == isSuccess then
    msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_TIMAATTACK_FAILMSG")
    msg.sub = ""
    msg.addMsg = ""
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 71)
  end
  PaGlobal_TimeAttack._isProgress = false
  PaGlobal_TimeAttack:closeTimeAttack()
end
function FromClient_closeTimeAttackUI()
  PaGlobal_TimeAttack._isProgress = false
  PaGlobal_TimeAttack:closeTimeAttack()
end
function FromClient_luaLoadComplete_TimeAttack()
  local isProgress = ToClient_isProgressTimeAttack()
  if true == isProgress then
    local expiredTime = ToClient_getTimeAttackExpiredTime()
    FromClient_startTimeAttack(expiredTime)
  end
end
Panel_TimeAttack:RegisterUpdateFunc("PaGlobal_UpdateTimeAttack")
function PaGlobal_UpdateTimeAttack()
  if true == PaGlobal_TimeAttack:isProgress() then
    PaGlobal_TimeAttack._uiRemainTime:SetText(converStringFromLeftDateTime(PaGlobal_TimeAttack:getExpiredTime()))
  end
  PaGlobal_TimeAttack._panelPosX = Panel_TimeAttack:GetPosX()
  PaGlobal_TimeAttack._panelPosY = Panel_TimeAttack:GetPosY()
end
function TimeAttack_Resize()
  Panel_TimeAttack:SetPosX(PaGlobal_TimeAttack._panelPosX)
  Panel_TimeAttack:SetPosY(PaGlobal_TimeAttack._panelPosY)
end
PaGlobal_TimeAttack:TimeAttack_Initialize()
registerEvent("onScreenResize", "TimeAttack_Resize")

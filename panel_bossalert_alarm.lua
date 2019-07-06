Panel_BossAlertV2:SetShow(false)
local PaGlobal_BossAlert = {
  _ui = {
    _bg = UI.getChildControl(Panel_BossAlertV2, "Static_Bg"),
    _date = UI.getChildControl(Panel_BossAlertV2, "StaticText_Date"),
    _desc = UI.getChildControl(Panel_BossAlertV2, "StaticText_Desc"),
    _itemSlotBg = UI.getChildControl(Panel_BossAlertV2, "Static_Slot_IconBG"),
    _itemSlot = UI.getChildControl(Panel_BossAlertV2, "Static_Slot_Icon"),
    _closeIcon = UI.getChildControl(Panel_BossAlertV2, "Button_Win_Close")
  },
  _aniTime = 0,
  _maxTime = 10,
  _lastMaxTime = 600,
  _lastMinute = 0,
  updateTime = 0
}
function PaGlobal_BossAlert:Init()
  self._ui._desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._bg:addInputEvent("Mouse_LUp", "PaGlobal_BossAlertSet_Show()")
  self._ui._closeIcon:addInputEvent("Mouse_LUp", "PaGlobal_BossAlert_NewAlarmClose()")
  Panel_BossAlertV2:RegisterUpdateFunc("UpdateFunc_checkBossAlramAnimation")
end
function PaGlobal_BossAlert:ShowAni()
  local posY = 45
  if Panel_ItemMarket_NewAlarm:GetShow() then
    if FGlobal_AlertMsgBg_ShowCheck() then
      posY = 205
    else
      posY = 130
    end
  elseif FGlobal_AlertMsgBg_ShowCheck() then
    posY = 120
  end
  local alarmMoveAni1 = Panel_BossAlertV2:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  alarmMoveAni1:SetStartPosition(getScreenSizeX() + 10, getScreenSizeY() - Panel_BossAlertV2:GetSizeY() - posY)
  alarmMoveAni1:SetEndPosition(getScreenSizeX() - Panel_BossAlertV2:GetSizeX() - 5, getScreenSizeY() - Panel_BossAlertV2:GetSizeY() - posY)
  alarmMoveAni1.IsChangeChild = true
  Panel_BossAlertV2:CalcUIAniPos(alarmMoveAni1)
  alarmMoveAni1:SetDisableWhileAni(true)
  audioPostEvent_SystemUi(19, 50)
  _AudioPostEvent_SystemUiForXBOX(19, 50)
end
function PaGlobal_BossAlert:HideAni()
  local alarmMoveAni2 = Panel_BossAlertV2:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  alarmMoveAni2:SetStartPosition(Panel_BossAlertV2:GetPosX(), Panel_BossAlertV2:GetPosY())
  alarmMoveAni2:SetEndPosition(getScreenSizeX() + 10, Panel_BossAlertV2:GetPosY())
  alarmMoveAni2.IsChangeChild = true
  Panel_BossAlertV2:CalcUIAniPos(alarmMoveAni2)
  alarmMoveAni2:SetDisableWhileAni(true)
  alarmMoveAni2:SetHideAtEnd(true)
  alarmMoveAni2:SetDisableWhileAni(true)
  Panel_Tooltip_Item_hideTooltip()
end
function FGlobal_BossAlertMsg_ResetPos(alertShow, marketAlertShow, alertType)
  if not Panel_BossAlertV2:GetShow() then
    return
  end
  local posY, startTime, endTime = 45, 0, 0.1
  if marketAlertShow then
    if alertShow then
      posY = 205
    else
      posY = 130
    end
  elseif alertShow then
    posY = 120
  end
  if 0 == alertType then
    if not alertShow then
      startTime, endTime = 0.3, 0.4
    end
  elseif 1 == alertType then
    if not marketAlertShow then
      startTime, endTime = 0.3, 0.4
    end
  else
    return
  end
  local alarmMoveAni3 = Panel_BossAlertV2:addMoveAnimation(startTime, endTime, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  alarmMoveAni3:SetStartPosition(Panel_BossAlertV2:GetPosX(), Panel_BossAlertV2:GetPosY())
  alarmMoveAni3:SetEndPosition(Panel_BossAlertV2:GetPosX(), getScreenSizeY() - Panel_BossAlertV2:GetSizeY() - posY)
  alarmMoveAni3.IsChangeChild = true
  Panel_BossAlertV2:CalcUIAniPos(alarmMoveAni3)
  alarmMoveAni3:SetDisableWhileAni(true)
end
local inconunt = 0
function PaGlobal_BossAlert_NewAlarmShow(deltaTime)
  if false == PaGlobal_BossAlertSet_GetIsShowBossAlert() then
    return
  end
  local self = PaGlobal_BossAlert
  self.updateTime = self.updateTime + deltaTime
  if self.updateTime < 60 then
    return
  end
  PaGlobal_BossAlertSet_ReturnTimeAfterAlertEnd()
  self.updateTime = 0
  local bossTime, bossName, lastMinute = PaGlobal_BossAlertSet_ReturnTimeBeforeAlert()
  if "unknown" == bossTime or "" == bossName then
    return
  end
  local isYear = ToClient_GetThisYear()
  local isMonth = ToClient_GetThisMonth()
  local isDay = ToClient_GetToday()
  local isHour = os.date("%H")
  local isMinute = os.date("%M")
  local isSecond = os.date("%S")
  self._lastMinute = lastMinute
  if 0 == lastMinute then
    self._ui._date:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BOSSALERT_ALARM_NAME", "bossName", tostring(bossName)))
  else
    self._ui._date:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BOSSALERT_ALARM_NAME_TIME", "bossName", tostring(bossName), "bossTime", tostring(bossTime)))
  end
  self._ui._desc:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_BOSSALERT_ALARM_DATE", "year", tostring(isYear), "month", tostring(isMonth), "day", tostring(isDay)) .. " " .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BOSSALERT_ALARM_TIME", "hour", tostring(isHour), "minute", tostring(isMinute)))
  Panel_BossAlertV2:SetShow(true)
  self._aniTime = 0
  self:ShowAni()
end
function PaGlobal_BossAlert_TooltipShow()
  local self = PaGlobal_BossAlert
end
function PaGlobal_BossAlert_TooltipHide()
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_BossAlert_NewAlarmClose()
  PaGlobal_BossAlert:HideAni()
end
function UpdateFunc_checkBossAlramAnimation(deltaTime)
  if PaGlobal_BossAlertSet_ReturnKeep() then
    self.updateTime = 0
    if 0 == PaGlobal_BossAlert._lastMinute then
      PaGlobal_BossAlert_CheckTimeForHide(deltaTime, PaGlobal_BossAlert._lastMaxTime)
    end
    return
  end
  PaGlobal_BossAlert_CheckTimeForHide(deltaTime, PaGlobal_BossAlert._maxTime)
end
function PaGlobal_BossAlert_CheckTimeForHide(deltaTime, maxTime)
  local self = PaGlobal_BossAlert
  self._aniTime = self._aniTime + deltaTime
  if maxTime < self._aniTime then
    self:HideAni()
    self._aniTime = 0
    self.updateTime = 0
  end
end
PaGlobal_BossAlert:Init()

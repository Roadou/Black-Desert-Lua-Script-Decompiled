local _btn_WarCall = FGlobal_GetPersonalIconControl(10)
local _isVolunteer = false
function WarCall_ToolTip(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local regionInfoWrapper = ToClient_getRegionInfoWrapperByPosition(ToClient_GetTeleportToSiegeTentPos())
  if nil == regionInfoWrapper then
    return
  end
  local areaName = regionInfoWrapper:getAreaName()
  local usableTime64 = ToClient_GetTeleportToSiegeTentTime()
  local descStr = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_DESC", "areaName", areaName, "time", convertStringFromDatetime(getLeftSecond_TTime64(usableTime64)))
  if _isVolunteer then
    descStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_DESC2", "time", convertStringFromDatetime(getLeftSecond_TTime64(usableTime64)))
  else
    descStr = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_DESC", "areaName", areaName, "time", convertStringFromDatetime(getLeftSecond_TTime64(usableTime64)))
  end
  local name, desc, uiControl = PAGetString(Defines.StringSheet_GAME, "LUA_WARCALL_TOOLTIP_NAME"), descStr, _btn_WarCall
  registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
  TooltipSimple_Show(uiControl, name, desc)
end
function Click_WarCall()
  ToClient_RequestTeleportToSiegeTentCall()
  TooltipSimple_Hide()
end
function Response_GuildWarCall(sendType, isVolunteer)
  _isVolunteer = isVolunteer
  if 0 == sendType then
    Panel_WarCall_Open()
    luaTimer_AddEvent(Panel_WarCall_Close, 600000, false, 0)
  else
    Panel_WarCall_Close()
  end
  FGlobal_PersonalIcon_ButtonPosUpdate()
end
function Panel_WarCall_Open()
  _btn_WarCall:SetShow(true)
  FGlobal_PersonalIcon_ButtonPosUpdate()
end
function Panel_WarCall_Close()
  if _btn_WarCall:GetShow() then
    _btn_WarCall:SetShow(false)
  end
end
function FGlobal_WarCallCheck()
  local leftTime = Int64toInt32(getLeftSecond_TTime64(ToClient_GetTeleportToSiegeTentTime()))
  if leftTime > 0 then
    Panel_WarCall_Open()
  else
    Panel_WarCall_Close()
  end
end
FGlobal_WarCallCheck()
registerEvent("FromClient_ResponseTeleportToSiegeTent", "Response_GuildWarCall")

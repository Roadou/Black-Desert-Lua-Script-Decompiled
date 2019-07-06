local _btn_BusterCall = FGlobal_GetPersonalIconControl(6)
function BusterCall_ToolTip(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local regionInfoWrapper = ToClient_getRegionInfoWrapperByPosition(ToClient_GetGuildBustCallPos())
  if nil == regionInfoWrapper then
    return
  end
  local areaName = regionInfoWrapper:getAreaName()
  local usableTime64 = ToClient_GetGuildBustCallTime()
  local descStr = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_DESC", "areaName", areaName, "time", convertStringFromDatetime(getLeftSecond_TTime64(usableTime64)))
  local name, desc, uiControl = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_NAME"), descStr, _btn_BusterCall
  registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
  TooltipSimple_Show(uiControl, name, desc)
end
function Click_BusterCall()
  ToClient_RequestTeleportGuildBustCall()
  TooltipSimple_Hide()
end
function Response_GuildBusterCall(sendType)
  if 0 == sendType then
    Panel_BusterCall_Open()
    luaTimer_AddEvent(Panel_BusterCall_Close, 600000, false, 0)
  else
    Panel_BusterCall_Close()
  end
  FGlobal_PersonalIcon_ButtonPosUpdate()
end
function Panel_BusterCall_Open()
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  if true == isGuildMaster then
    Panel_BusterCall_Close()
    return
  end
  _btn_BusterCall:SetShow(true)
  FGlobal_PersonalIcon_ButtonPosUpdate()
  _btn_BusterCall:EraseAllEffect()
  _btn_BusterCall:AddEffect("fUI_Buster_Call01", true, 0, 0)
end
function Panel_BusterCall_Close()
  if _btn_BusterCall:GetShow() then
    _btn_BusterCall:EraseAllEffect()
    _btn_BusterCall:SetShow(false)
  end
end
function FGlobal_BusterCallCheck()
  local leftTime = Int64toInt32(getLeftSecond_TTime64(ToClient_GetGuildBustCallTime()))
  if leftTime > 0 then
    Panel_BusterCall_Open()
  else
    Panel_BusterCall_Close()
  end
end
FGlobal_BusterCallCheck()
registerEvent("FromClient_ResponseBustCall", "Response_GuildBusterCall")

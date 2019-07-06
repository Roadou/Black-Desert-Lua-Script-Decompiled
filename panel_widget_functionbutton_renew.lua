Widget_Function_Type_Renew = {
  SiegeWarCall = 1,
  BusterCall = 2,
  SummonPartyCall = 3,
  count = 4
}
local FunctionButton = {
  _ui = {
    _stc_siegeWarCall = UI.getChildControl(Panel_Widget_FunctionButton_Renew, "Button_SiegeWarCall"),
    _stc_busterCall = UI.getChildControl(Panel_Widget_FunctionButton_Renew, "Button_BusterCall"),
    _stc_summonPartyCall = UI.getChildControl(Panel_Widget_FunctionButton_Renew, "Button_PartySummon")
  },
  _button = {
    [Widget_Function_Type_Renew.SiegeWarCall] = nil,
    [Widget_Function_Type_Renew.BusterCall] = nil,
    [Widget_Function_Type_Renew.SummonPartyCall] = nil
  },
  _buttonShow = {
    [Widget_Function_Type_Renew.SiegeWarCall] = false,
    [Widget_Function_Type_Renew.BusterCall] = false,
    [Widget_Function_Type_Renew.SummonPartyCall] = false
  },
  _isTimeDisplay = {
    [Widget_Function_Type_Renew.SiegeWarCall] = false,
    [Widget_Function_Type_Renew.BusterCall] = false,
    [Widget_Function_Type_Renew.SummonPartyCall] = false
  },
  _buttonIntervalX = 0,
  _panel = Panel_Widget_FunctionButton_Renew
}
function FunctionButton:initControl()
  self._button[Widget_Function_Type_Renew.SiegeWarCall] = self._ui._stc_siegeWarCall
  self._button[Widget_Function_Type_Renew.BusterCall] = self._ui._stc_busterCall
  self._button[Widget_Function_Type_Renew.SummonPartyCall] = self._ui._stc_summonPartyCall
end
function FunctionButton:registEventHandler()
  registerEvent("FromClient_ResponseBustCall", "FromClient_Widget_FunctionButton_ResponseBustCall")
  registerEvent("FromClient_ResponseTeleportToSiegeTent", "FromClient_Widget_FunctionButton_ResponseTeleportToSiegeTent")
  registerEvent("FromClient_ResponseUseCompass", "FromClient_Widget_FunctionButton_ResponseUseCompass")
  registerEvent("ResponseParty_updatePartyList", "PaGlobalFunc_Widget_FunctionButton_Check_PartySummon")
  registerEvent("onScreenResize", "FromClient_FunctionButton_OnResize")
end
function FunctionButton:initialize()
  self:initControl()
  self:updateAllButton()
  self:registEventHandler()
end
function FromClient_Widget_FunctionButton_ResponseBustCall(sendType)
  local self = FunctionButton
  if 0 == sendType then
    self._isTimeDisplay[Widget_Function_Type_Renew.BusterCall] = true
    luaTimer_AddEvent(PaGlobalFunc_Widget_FunctionButton_Close_GuildBusterCall, 600000, false, 0)
  else
    self._isTimeDisplay[Widget_Function_Type_Renew.BusterCall] = false
  end
  self:updateAllButton()
end
function PaGlobalFunc_Widget_FunctionButton_Close_GuildBusterCall()
  local self = FunctionButton
  self._isTimeDisplay[Widget_Function_Type_Renew.BusterCall] = false
  self:updateAllButton()
end
function PaGlobalFunc_Widget_FunctionButton_Check_GuildBusterCall()
  local self = FunctionButton
  local regionInfoWrapper = ToClient_getRegionInfoWrapperByPosition(ToClient_GetGuildBustCallPos())
  if nil == regionInfoWrapper then
    self._isTimeDisplay[Widget_Function_Type_Renew.BusterCall] = false
    return
  end
  local leftTime = Int64toInt32(getLeftSecond_TTime64(ToClient_GetGuildBustCallTime()))
  self._isTimeDisplay[Widget_Function_Type_Renew.SiegeWarCall] = leftTime > 0
  luaTimer_AddEvent(PaGlobalFunc_Widget_FunctionButton_Close_GuildBusterCall, leftTime * 1000, false, 0)
  self:updateAllButton()
end
function FromClient_Widget_FunctionButton_ResponseTeleportToSiegeTent(sendType)
  local self = FunctionButton
  if 0 == sendType then
    self._isTimeDisplay[Widget_Function_Type_Renew.SiegeWarCall] = true
    luaTimer_AddEvent(PaGlobalFunc_Widget_FunctionButton_Close_SiegeWarCall, 600000, false, 0)
  else
    self._isTimeDisplay[Widget_Function_Type_Renew.SiegeWarCall] = false
  end
  self:updateAllButton()
end
function PaGlobalFunc_Widget_FunctionButton_Close_SiegeWarCall()
  local self = FunctionButton
  self._isTimeDisplay[Widget_Function_Type_Renew.BusterCall] = false
  self:updateAllButton()
end
function PaGlobalFunc_Widget_FunctionButton_Check_SiegeWarCall()
  local self = FunctionButton
  local regionInfoWrapper = ToClient_getRegionInfoWrapperByPosition(ToClient_GetTeleportToSiegeTentPos())
  if nil == regionInfoWrapper then
    self._isTimeDisplay[Widget_Function_Type_Renew.SiegeWarCall] = false
    return
  end
  local leftTime = Int64toInt32(getLeftSecond_TTime64(ToClient_GetTeleportToSiegeTentTime()))
  self._isTimeDisplay[Widget_Function_Type_Renew.SiegeWarCall] = leftTime > 0
  luaTimer_AddEvent(PaGlobalFunc_Widget_FunctionButton_Close_SiegeWarCall, leftTime * 1000, false, 0)
  self:updateAllButton()
end
function FromClient_Widget_FunctionButton_ResponseUseCompass()
  local self = FunctionButton
  self._isTimeDisplay[Widget_Function_Type_Renew.SummonPartyCall] = false
  PaGlobalFunc_Widget_FunctionButton_Check_PartySummon()
  self:updateAllButton()
  local partyName = ""
  partyName = ToClient_GetCharacterNameUseCompass()
  local partyActorKey = ToClient_GetCharacterActorKeyRawUseCompass()
  local playerActorKey = getSelfPlayer():getActorKey()
  local msg = ""
  if partyActorKey == playerActorKey then
    msg = PAGetString(Defines.StringSheet_GAME, "LUA_COMPASS_MESSAGE_1")
  else
    msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPASS_MESSAGE_2", "partyName", partyName)
  end
  Proc_ShowMessage_Ack(msg)
  luaTimer_AddEvent(PaGlobalFunc_Widget_FunctionButton_Close_PartySummon, 600000, false, 0)
end
function PaGlobalFunc_Widget_FunctionButton_Close_PartySummon()
  local self = FunctionButton
  self._isTimeDisplay[Widget_Function_Type_Renew.SummonPartyCall] = false
  self:updateAllButton()
end
function PaGlobalFunc_Widget_FunctionButton_Check_PartySummon()
  local self = FunctionButton
  local partyActorKey = ToClient_GetCharacterActorKeyRawUseCompass()
  local playerActorKey = getSelfPlayer():getActorKey()
  local remainTime = Int64toInt32(ToClient_GetLeftUsableTeleportCompassTime())
  if remainTime > 0 then
    if partyActorKey ~= playerActorKey then
      if 0 < RequestParty_getPartyMemberCount() then
        self._isTimeDisplay[Widget_Function_Type_Renew.SummonPartyCall] = true
      else
        self._isTimeDisplay[Widget_Function_Type_Renew.SummonPartyCall] = false
      end
    else
      self._isTimeDisplay[Widget_Function_Type_Renew.SummonPartyCall] = false
    end
    luaTimer_AddEvent(PaGlobalFunc_Widget_FunctionButton_Close_PartySummon, remainTime * 1000, false, 0)
    self:updateAllButton()
  else
    self._isTimeDisplay[Widget_Function_Type_Renew.SummonPartyCall] = false
    self:updateAllButton()
    return
  end
end
function FunctionButton:updateAllButton()
  local spanPosX = 0
  for index = 1, Widget_Function_Type_Renew.count - 1 do
    if nil ~= self._buttonShow[index] then
      self:checkButtonStatus(index)
      self._button[index]:SetShow(self._buttonShow[index])
      if true == self._buttonShow[index] then
        self._button[index]:SetSpanSize(spanPosX, 0)
        spanPosX = spanPosX + (self._button[index]:GetSizeX() + self._buttonIntervalX)
      end
    end
  end
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  if true == isGuildMaster then
  end
end
function FunctionButton:checkButtonStatus(buttonType)
  if buttonType == Widget_Function_Type_Renew.SiegeWarCall then
    self._buttonShow[buttonType] = self._isTimeDisplay[buttonType]
  elseif buttonType == Widget_Function_Type_Renew.BusterCall then
    self._buttonShow[buttonType] = self._isTimeDisplay[buttonType]
  elseif buttonType == Widget_Function_Type_Renew.SummonPartyCall then
    self._buttonShow[buttonType] = self._isTimeDisplay[buttonType]
  end
end
function FGlobal_GetPersonalIconControl()
end
function PaGlobalFunc_Widget_FunctionButton_Control(buttonType)
  local self = FunctionButton
  if nil ~= self._button[buttonType] then
    return self._button[buttonType]
  end
end
function FGlobal_GetPersonalText(index)
end
function FGlobal_GetPersonalIconPosX()
  return Panel_Widget_FunctionButton_Renew:GetPosX()
end
function FGlobal_GetPersonalIconPosY()
  return Panel_Widget_FunctionButton_Renew:GetPosY()
end
function FGlobal_GetPersonalIconSizeX()
  return Panel_Widget_FunctionButton_Renew:GetSizeX()
end
function FGlobal_GetPersonalIconSizeY()
  return Panel_Widget_FunctionButton_Renew:GetSizeY()
end
function FromClient_Widget_FunctionButtonRenew_Init()
  local self = FunctionButton
  self:initialize()
  self._panel:SetShow(true)
  PaGlobalFunc_Widget_FunctionButton_Check_SiegeWarCall()
  PaGlobalFunc_Widget_FunctionButton_Check_GuildBusterCall()
  PaGlobalFunc_Widget_FunctionButton_Check_PartySummon()
end
function FromClient_FunctionButton_OnResize()
  local self = FunctionButton
  self._panel:ComputePos()
  self._panel:SetPosY(getScreenSizeY() - FGlobal_GetPersonalIconSizeY() - 10)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_Widget_FunctionButtonRenew_Init")

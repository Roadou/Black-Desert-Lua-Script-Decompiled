local _panel = Panel_Window_Guild_ReceivePay
_panel:ignorePadSnapMoveToOtherPanel()
local GuildReceivePay = {
  _ui = {
    stc_CenterBg = UI.getChildControl(_panel, "Static_CenterBg"),
    stc_BottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  },
  paytype = false
}
function GuildReceivePay:open()
  self:update()
  _AudioPostEvent_SystemUiForXBOX(8, 14)
  _panel:SetShow(true)
end
function GuildReceivePay:update()
  local memberIdx = PaGlobalFunc_GuildMemberFunction_GetMemberIndex()
  local guildInfo = ToClient_GetMyGuildInfoWrapper()
  local memberInfo = guildInfo:getMember(memberIdx)
  if nil == memberInfo then
    self._ui.txt_PayValue:SetText("0")
    return
  end
  local benefit = memberInfo:getContractedBenefit()
  self._ui.txt_PayValue:SetText(tostring(benefit))
end
function GuildReceivePay:init()
  self._ui.txt_PayValue = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_PayValue")
  self._ui.btn_Inventory = UI.getChildControl(self._ui.stc_CenterBg, "Button_Inventory")
  self._ui.btn_Warehouse = UI.getChildControl(self._ui.stc_CenterBg, "Button_Warehouse")
  self:registEvent()
end
function GuildReceivePay:registEvent()
  PaGlobal_registerPanelOnBlackBackground(_panel)
  self._ui.btn_Inventory:addInputEvent("Mouse_LUp", "InputMLUp_GuildReceivePay_PayIntoInventory()")
  self._ui.btn_Warehouse:addInputEvent("Mouse_LUp", "InputMLUp_GuildReceivePay_PayIntoWarehouse()")
end
function GuildReceivePay:close()
  _panel:SetShow(false)
end
function PaGlobalFunc_GuildReceivePay_Open()
  local self = GuildReceivePay
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildReceivePay")
    return
  end
  self:open()
end
function PaGlobalFunc_GuildReceivePay_Close()
  local self = GuildReceivePay
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildReceivePay")
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  self:close()
end
function PaGlobalFunc_GuildReceivePay_Init()
  local self = GuildReceivePay
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildReceivePay")
    return
  end
  self:init()
end
function InputMLUp_GuildReceivePay_PayIntoInventory()
  local self = GuildReceivePay
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildReceivePay")
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  ToClient_TakeMyGuildBenefit(false)
  self.paytype = false
  self:close()
end
function PaGlobalFunc_GuildReceivePay_PayTypeReturn()
  local self = GuildReceivePay
  return self.paytype
end
function InputMLUp_GuildReceivePay_PayIntoWarehouse()
  local self = GuildReceivePay
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildReceivePay")
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  ToClient_TakeMyGuildBenefit(true)
  self.paytype = true
  self:close()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_GuildReceivePay_Init")

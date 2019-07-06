local Panel_Window_StableRegister_MarketCheck_info = {
  _ui = {
    staticText_Desc = nil,
    radioButton_Me = nil,
    radioButton_All = nil
  },
  _value = {selectServantNo = nil},
  _config = {}
}
function Panel_Window_StableRegister_MarketCheck_info:registerEventHandler()
  Panel_Window_StableRegister_MarketCheck:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_StableRegister_MarketCheck_Up()")
  Panel_Window_StableRegister_MarketCheck:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_StableRegister_MarketCheck_Down()")
  Panel_Window_StableRegister_MarketCheck:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_StableRegister_MarketCheck_Confirm()")
  Panel_Window_StableRegister_MarketCheck:registerPadEvent(__eCONSOLE_UI_INPUT_TYPE_B, "PaGlobalFunc_StableRegister_MarketCheck_Back()")
  Panel_Window_StableRegister_MarketCheck:ignorePadSnapMoveToOtherPanel()
end
function Panel_Window_StableRegister_MarketCheck_info:initialize()
  self:childControl()
  self:initValue()
  self:registerEventHandler()
end
function Panel_Window_StableRegister_MarketCheck_info:initValue()
  self._value.selectServantNo = nil
end
function Panel_Window_StableRegister_MarketCheck_info:childControl()
  self._ui.staticText_Desc = UI.getChildControl(Panel_Window_StableRegister_MarketCheck, "StaticText_Desc")
  self._ui.staticText_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.radioButton_Me = UI.getChildControl(Panel_Window_StableRegister_MarketCheck, "RadioButton_Me")
  self._ui.radioButton_All = UI.getChildControl(Panel_Window_StableRegister_MarketCheck, "RadioButton_All")
  self._ui.static_bottomBg = UI.getChildControl(Panel_Window_StableRegister_MarketCheck, "Static_Bottombg")
  self._ui.staticText_keyguide_A = UI.getChildControl(self._ui.static_bottomBg, "StaticText_OK_ConsoleUI")
  self._ui.staticText_keyguide_B = UI.getChildControl(self._ui.static_bottomBg, "StaticText_NO_ConsoleUI")
  local tempBtnGroup = {
    self._ui.staticText_keyguide_A,
    self._ui.staticText_keyguide_B
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui.static_bottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Panel_Window_StableRegister_MarketCheck_info:setContent()
end
function Panel_Window_StableRegister_MarketCheck_info:open()
  Panel_Window_StableRegister_MarketCheck:SetShow(true)
end
function Panel_Window_StableRegister_MarketCheck_info:close()
  Panel_Window_StableRegister_MarketCheck:SetShow(false)
end
function Panel_Window_StableRegister_MarketCheck_info:getTransferType()
  if self._ui.radioButton_All:IsCheck() then
    return CppEnums.TransferType.TransferType_Normal
  else
    return CppEnums.TransferType.TransferType_Self
  end
end
function Panel_Window_StableRegister_MarketCheck_info:clearCheck()
  self._ui.radioButton_Me:SetCheck(false)
  self._ui.radioButton_All:SetCheck(false)
end
function PaGlobalFunc_StableRegister_MarketCheck_GetShow()
  return Panel_Window_StableRegister_MarketCheck:GetShow()
end
function PaGlobalFunc_StableRegister_MarketCheck_Open()
  local self = Panel_Window_StableRegister_MarketCheck_info
  self:open()
end
function PaGlobalFunc_StableRegister_MarketCheck_Close()
  local self = Panel_Window_StableRegister_MarketCheck_info
  self:close()
end
function PaGlobalFunc_StableRegister_MarketCheck_ShowByServantNo(servantNo)
  local self = Panel_Window_StableRegister_MarketCheck_info
  if nil == servantNo then
    return
  end
  self:initValue()
  self:clearCheck()
  self._ui.radioButton_Me:SetCheck(true)
  self._ui.staticText_Desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_MARKETREGIST"))
  self._value.selectServantNo = servantNo
  self:open()
  PaGlobalFunc_StableRegister_Market_Close()
end
function PaGlobalFunc_StableRegister_MarketCheck_RegisterMatingXXXXX(s64_price)
  local self = Panel_Window_StableRegister_MarketCheck_info
  if nil ~= self._value.selectServantNo and self._value.selectServantNo == PaGlobalFunc_StableList_SelectSlotNo() then
    stable_registerServantToSomeWhereElse(self._value.selectServantNo, CppEnums.AuctionType.AuctionGoods_ServantMating, self:getTransferType(), s64_price)
    self:close()
  else
  end
end
function PaGlobalFunc_StableRegister_MarketCheck_Confirm()
  local self = Panel_Window_StableRegister_MarketCheck_info
  if nil == self._value.selectServantNo then
    return
  end
  if self._value.selectServantNo == PaGlobalFunc_StableList_SelectSlotNo() then
    local servantInfo = stable_getServant(self._value.selectServantNo)
    local price = 0
    if CppEnums.TransferType.TransferType_Self == self:getTransferType() then
      price = getServantSelfMatingPrice()
    else
      price = servantInfo:getMinRegisterMatingPrice_s64()
    end
    PaGlobalFunc_StableRegister_MarketCheck_RegisterMatingXXXXX(price)
  end
end
function PaGlobalFunc_StableRegister_MarketCheck_Back()
  local self = Panel_Window_StableRegister_MarketCheck_info
  self:close()
  PaGlobalFunc_StableRegister_Market_ShowByType(CppEnums.ServantRegist.eEventType_RegisterMating)
end
function PaGlobalFunc_StableRegister_MarketCheck_Up()
  local self = Panel_Window_StableRegister_MarketCheck_info
  self._ui.radioButton_Me:SetCheck(true)
  self._ui.radioButton_All:SetCheck(false)
end
function PaGlobalFunc_StableRegister_MarketCheck_Down()
  local self = Panel_Window_StableRegister_MarketCheck_info
  self._ui.radioButton_Me:SetCheck(false)
  self._ui.radioButton_All:SetCheck(true)
end
function FromClient_StableRegister_MarketCheck_Init()
  local self = Panel_Window_StableRegister_MarketCheck_info
  self:initialize()
end
function FromClient_StableRegister_MarketCheck_Resize()
  local self = Panel_Window_StableRegister_MarketCheck_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_StableRegister_MarketCheck_Init")

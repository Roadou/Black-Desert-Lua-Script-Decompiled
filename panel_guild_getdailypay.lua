local getDailyPay = {
  _btn_Close = nil,
  _btn_GetMoney = nil,
  _btn_Cancel = nil,
  _rdo_Inven = nil,
  _rdo_Warehouse = nil,
  _dailypay = nil
}
function getDailyPay:initialize()
  if nil == Panel_Guild_GetDailyPay then
    return
  end
  getDailyPay._btn_Close = UI.getChildControl(Panel_Guild_GetDailyPay, "Button_Close")
  getDailyPay._btn_GetMoney = UI.getChildControl(Panel_Guild_GetDailyPay, "Button_GetMoney")
  getDailyPay._btn_Cancel = UI.getChildControl(Panel_Guild_GetDailyPay, "Button_Cancel")
  getDailyPay._rdo_Inven = UI.getChildControl(Panel_Guild_GetDailyPay, "RadioButton_Inven")
  getDailyPay._rdo_Warehouse = UI.getChildControl(Panel_Guild_GetDailyPay, "RadioButton_Warehouse")
  getDailyPay._dailypay = UI.getChildControl(Panel_Guild_GetDailyPay, "StaticText_DailyPay")
  self._rdo_Inven:SetCheck(true)
  self._rdo_Warehouse:SetCheck(false)
  self:registEventHandler()
end
function getDailyPay:registEventHandler()
  if nil == Panel_Guild_GetDailyPay then
    return
  end
  self._btn_GetMoney:addInputEvent("Mouse_LUp", "GetDailyPay_Execute()")
  self._btn_Cancel:addInputEvent("Mouse_LUp", "FGlobal_GetDailyPay_Hide()")
  self._btn_Close:addInputEvent("Mouse_LUp", "FGlobal_GetDailyPay_Hide()")
end
function GetDailyPay_Execute()
  if nil == Panel_Guild_GetDailyPay then
    return
  end
  local self = getDailyPay
  local isInven = self._rdo_Inven:IsCheck()
  local isWarehouse = self._rdo_Warehouse:IsCheck()
  local isGetCheck = false
  if isInven then
    isGetCheck = false
  elseif isWarehouse then
    isGetCheck = true
  end
  ToClient_TakeMyGuildBenefit(isGetCheck)
  FGlobal_GetDailyPay_Hide()
end
function FGlobal_GetDailyPay_Show()
  if true == PaGlobal_GuildGetDailyPay_GetShow() then
    return
  end
  local self = getDailyPay
  PaGlobal_GuildGetDailyPay_CheckLoadUI()
  self._rdo_Inven:SetCheck(true)
  self._rdo_Warehouse:SetCheck(false)
  GuildListInfoPage:UpdateData()
  local myIndex = FGlobal_GetDailyPay_RealIndexInfo()
  local memberInfo = ToClient_GetMyGuildInfoWrapper():getMember(myIndex)
  if nil == memberInfo then
    _PA_ASSERT(false, "FGlobal_AgreementGuild_Master_Open \236\157\152 \235\169\164\235\178\132\236\157\184\235\141\177\236\138\164\234\176\128 \235\185\132\236\160\149\236\131\129\236\158\133\235\139\136\235\139\164 " .. tostring(myIndex))
  end
  self.memberBenefit = memberInfo:getContractedBenefit()
  self._rdo_Inven:SetHorizonCenter()
  self._rdo_Warehouse:SetHorizonCenter()
  self._rdo_Inven:SetVerticalTop()
  self._rdo_Warehouse:SetVerticalTop()
  self._rdo_Inven:SetEnableArea(0, 0, self._rdo_Inven:GetSizeX() + self._rdo_Inven:GetTextSizeX() + 10, self._rdo_Inven:GetSizeY())
  self._rdo_Warehouse:SetEnableArea(0, 0, self._rdo_Warehouse:GetSizeX() + self._rdo_Warehouse:GetTextSizeX() + 10, self._rdo_Warehouse:GetSizeY())
  self._dailypay:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_GETDAILYPAY_DAIYPAY", "money", makeDotMoney(self.memberBenefit)))
  rdo_InvenSizeX = self._rdo_Inven:GetSizeX() + self._rdo_Inven:GetTextSizeX() + 10
  rdo_WarehouseSizeX = self._rdo_Warehouse:GetSizeX() + self._rdo_Warehouse:GetTextSizeX() + 10
  longX = math.max(rdo_InvenSizeX, rdo_WarehouseSizeX)
  self._rdo_Inven:SetSpanSize(-longX / 2, 100)
  self._rdo_Warehouse:SetSpanSize(-longX / 2, 130)
end
function FGlobal_GetDailyPay_Hide()
  PaGlobal_GuildGetDailyPay_CheckCloseUI()
end
function FGlobal_GetDailyPay_WarehouseCheckReturn()
  if nil == Panel_Guild_GetDailyPay then
    return false
  end
  return getDailyPay._rdo_Warehouse:IsCheck()
end
function PaGlobal_GuildGetDailyPay_CheckLoadUI()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_GetDailyPay:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_Guild_GetDailyPay.XML", "Panel_Guild_GetDailyPay", Defines.UIGroup.PAGameUIGroup_Window_Progress, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_Guild_GetDailyPay = rv
    rv = nil
    getDailyPay:initialize()
  end
  Panel_Guild_GetDailyPay:SetShow(true)
end
function PaGlobal_GuildGetDailyPay_CheckCloseUI()
  if false == PaGlobal_GuildGetDailyPay_GetShow() then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_GetDailyPay:SetShow(false)
  else
    reqCloseUI(Panel_Guild_GetDailyPay)
  end
end
function PaGlobal_GuildGetDailyPay_GetShow()
  if nil == Panel_Guild_GetDailyPay then
    return false
  end
  return Panel_Guild_GetDailyPay:GetShow()
end
function FromClient_GuildGetDailyPay_Init()
  getDailyPay:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildGetDailyPay_Init")

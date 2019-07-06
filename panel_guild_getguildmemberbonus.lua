local getGuildMemberBonus = {
  _btn_Close = nil,
  _btn_GetMoney = nil,
  _btn_Cancel = nil,
  _rdo_Inven = nil,
  _rdo_Warehouse = nil,
  _txt_Notice = nil,
  _txt_memberBonus = nil
}
function getGuildMemberBonus:initialize()
  if nil == Panel_Guild_GetGuildMemberBonus then
    return
  end
  self._btn_Close = UI.getChildControl(Panel_Guild_GetGuildMemberBonus, "Button_Close")
  self._btn_GetMoney = UI.getChildControl(Panel_Guild_GetGuildMemberBonus, "Button_GetMoney")
  self._btn_Cancel = UI.getChildControl(Panel_Guild_GetGuildMemberBonus, "Button_Cancel")
  self._rdo_Inven = UI.getChildControl(Panel_Guild_GetGuildMemberBonus, "RadioButton_Inven")
  self._rdo_Warehouse = UI.getChildControl(Panel_Guild_GetGuildMemberBonus, "RadioButton_Warehouse")
  self._txt_Notice = UI.getChildControl(Panel_Guild_GetGuildMemberBonus, "StaticText_Notice")
  self._txt_memberBonus = UI.getChildControl(Panel_Guild_GetGuildMemberBonus, "StaticText_GuildMemberBonus")
  self._rdo_Inven:SetCheck(true)
  self._rdo_Warehouse:SetCheck(false)
  self._rdo_Inven:SetHorizonCenter()
  self._rdo_Warehouse:SetHorizonCenter()
  self._rdo_Inven:SetVerticalTop()
  self._rdo_Warehouse:SetVerticalTop()
  self._rdo_Inven:SetEnableArea(0, 0, self._rdo_Inven:GetSizeX() + self._rdo_Inven:GetTextSizeX() + 10, self._rdo_Inven:GetSizeY())
  self._rdo_Warehouse:SetEnableArea(0, 0, self._rdo_Warehouse:GetSizeX() + self._rdo_Warehouse:GetTextSizeX() + 10, self._rdo_Warehouse:GetSizeY())
  self._txt_Notice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_PENSION_NOTICE"))
  self._txt_memberBonus:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_GETGUILDMEMBERBONUS", "money", makeDotMoney(0)))
  rdo_InvenSizeX = self._rdo_Inven:GetSizeX() + self._rdo_Inven:GetTextSizeX() + 10
  rdo_WarehouseSizeX = self._rdo_Warehouse:GetSizeX() + self._rdo_Warehouse:GetTextSizeX() + 10
  local longX = math.max(rdo_InvenSizeX, rdo_WarehouseSizeX)
  self._rdo_Inven:SetSpanSize(-longX / 2, 100)
  self._rdo_Warehouse:SetSpanSize(-longX / 2, 130)
end
function GetGuildMemberBonus_Execute()
  if nil == Panel_Guild_GetGuildMemberBonus then
    return
  end
  local self = getGuildMemberBonus
  local isInven = self._rdo_Inven:IsCheck()
  local isWarehouse = self._rdo_Warehouse:IsCheck()
  local isGetCheck = false
  if isInven then
    isGetCheck = false
  elseif isWarehouse then
    isGetCheck = true
  end
  ToClient_RequestGuildMemberBonus(isGetCheck)
  FGlobal_GetGuildMemberBonus_Hide()
end
function FGlobal_GetGuildMemberBonus_Show()
  local self = getGuildMemberBonus
  if false == PaGlobal_GetGuildMemberBonus_GetShow() then
    ToClient_RequestGuildMemberBonusShow()
    PaGlobal_GetGuildMemberBonus_CheckLoadUI()
    self._rdo_Inven:SetCheck(true)
    self._rdo_Warehouse:SetCheck(false)
    self._txt_memberBonus:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_GETGUILDMEMBERBONUS", "money", makeDotMoney(getSelfPlayer():getGuildMemberBonus())))
  end
end
function FGlobal_GetGuildMemberBonus_Hide()
  PaGlobal_GetGuildMemberBonus_CheckCloseUI()
end
function FromClient_UpdateGuildMemberBonus()
  if true == PaGlobal_GetGuildMemberBonus_GetShow() then
    local self = getGuildMemberBonus
    self._txt_memberBonus:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_GETGUILDMEMBERBONUS", "money", makeDotMoney(getSelfPlayer():getGuildMemberBonus())))
  end
end
function getGuildMemberBonus:registEventHandler()
  if nil == Panel_Guild_GetGuildMemberBonus then
    return
  end
  Panel_Guild_GetGuildMemberBonus:RegisterCloseLuaFunc(PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Escape
  }), "FGlobal_GetGuildMemberBonus_Hide()")
  self._btn_GetMoney:addInputEvent("Mouse_LUp", "GetGuildMemberBonus_Execute()")
  self._btn_Cancel:addInputEvent("Mouse_LUp", "FGlobal_GetGuildMemberBonus_Hide()")
  self._btn_Close:addInputEvent("Mouse_LUp", "FGlobal_GetGuildMemberBonus_Hide()")
end
function getGuildMemberBonus:registMessageHandler()
  registerEvent("FromClient_UpdateGuildMemberBonus", "FromClient_UpdateGuildMemberBonus")
end
function PaGlobal_GetGuildMemberBonus_CheckLoadUI()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_GetGuildMemberBonus:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_Guild_GetGuildMemberBonus.XML", "Panel_Guild_GetGuildMemberBonus", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_Guild_GetGuildMemberBonus = rv
    rv = nil
    PaGlobal_GetGuildMemberBonus_Init()
  end
  Panel_Guild_GetGuildMemberBonus:SetShow(true)
end
function PaGlobal_GetGuildMemberBonus_CheckCloseUI()
  if nil == Panel_Guild_GetGuildMemberBonus then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_GetGuildMemberBonus:SetShow(false)
  else
    reqCloseUI(Panel_Guild_GetGuildMemberBonus)
  end
end
function PaGlobal_GetGuildMemberBonus_GetShow()
  if nil == Panel_Guild_GetGuildMemberBonus then
    return false
  end
  return Panel_Guild_GetGuildMemberBonus:GetShow()
end
function FromClient_GetGuildMemberBonus_Init()
  PaGlobal_GetGuildMemberBonus_Init()
  getGuildMemberBonus:registMessageHandler()
end
function PaGlobal_GetGuildMemberBonus_Init()
  getGuildMemberBonus:initialize()
  getGuildMemberBonus:registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_GetGuildMemberBonus_Init")

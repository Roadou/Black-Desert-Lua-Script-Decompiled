local getGuildMemberBonus = {
  _ui = {
    stc_mainBG = UI.getChildControl(Panel_Guild_GetGuildMemberBonus, "Static_MainBG")
  },
  _noticeString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_PENSION_NOTICE"),
  _selectedIndex = 0
}
function getGuildMemberBonus:init()
  self._ui._txt_memberBonus = UI.getChildControl(self._ui.stc_mainBG, "StaticText_GuildMemberBonus")
  self._ui._btn_Inven = UI.getChildControl(self._ui.stc_mainBG, "Button_Inven")
  self._ui._txt_SilverInInven = UI.getChildControl(self._ui._btn_Inven, "StaticText_SilverInInven")
  self._ui._btn_Warehouse = UI.getChildControl(self._ui.stc_mainBG, "Button_Warehouse")
  self._ui._txt_SilverInWarehouse = UI.getChildControl(self._ui._btn_Warehouse, "StaticText_SilverInWarehouse")
  self._ui._txt_Notice = UI.getChildControl(self._ui.stc_mainBG, "StaticText_Notice")
  self._ui._stc_Line = UI.getChildControl(self._ui.stc_mainBG, "Static_Line")
  self._ui._txt_Notice:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._noticeOriginSizeX = self._ui._txt_Notice:GetSizeX()
  self._ui._txt_keyGuide_A = UI.getChildControl(Panel_Guild_GetGuildMemberBonus, "StaticText_KeyGuide_A")
  self._ui._txt_keyGuide_B = UI.getChildControl(Panel_Guild_GetGuildMemberBonus, "StaticText_KeyGuide_B")
  self:resize()
  self:registEventHandler()
end
function getGuildMemberBonus:resize()
  self._ui._txt_Notice:SetSize(self._ui.stc_mainBG:GetSizeX() - 40)
  self._ui._txt_Notice:SetText(self._noticeString)
  local gapY = self._ui._txt_Notice:GetPosY() + self._ui._txt_Notice:GetTextSizeY() - self._ui._stc_Line:GetPosY()
  if gapY > 0 then
    gapY = gapY + 20
    self._ui.stc_mainBG:SetSize(self._ui.stc_mainBG:GetSizeX(), self._ui.stc_mainBG:GetSizeY() + gapY)
    Panel_Guild_GetGuildMemberBonus:SetSize(Panel_Guild_GetGuildMemberBonus:GetSizeX(), Panel_Guild_GetGuildMemberBonus:GetSizeY() + gapY)
    Panel_Guild_GetGuildMemberBonus:ComputePosAllChild()
    self._ui._stc_Line:SetPosY(self._ui._stc_Line:GetPosY() + gapY)
  end
  local keyGuides = {
    self._ui._txt_keyGuide_A,
    self._ui._txt_keyGuide_B
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, Panel_Guild_GetGuildMemberBonus, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_CENTER)
end
function getGuildMemberBonus:registEventHandler()
  Panel_Guild_GetGuildMemberBonus:ignorePadSnapMoveToOtherPanel()
  Panel_Guild_GetGuildMemberBonus:registerPadEvent(__eConsoleUIPadEvent_Up_A, "GetGuildMemberBonus_Execute()")
  self._ui._btn_Inven:addInputEvent("Mouse_On", "PaGlobal_GetGuildMemberBonus_SetSelectIndex(" .. 0 .. ")")
  self._ui._btn_Warehouse:addInputEvent("Mouse_On", "PaGlobal_GetGuildMemberBonus_SetSelectIndex(" .. 1 .. ")")
  registerEvent("onScreenResize", "FromClient_GetGuildMemberBonus_Resize")
  registerEvent("FromClient_UpdateGuildMemberBonus", "FromClient_UpdateGuildMemberBonus")
end
function FromClient_GetGuildMemberBonus_Resize()
  getGuildMemberBonus:resize()
end
function GetGuildMemberBonus_Execute()
  local self = getGuildMemberBonus
  local isGetCheck = false
  if 0 == self._selectedIndex then
    isGetCheck = false
  elseif 1 == self._selectedIndex then
    isGetCheck = true
  end
  ToClient_RequestGuildMemberBonus(isGetCheck)
  FGlobal_GetGuildMemberBonus_Hide()
end
function FGlobal_GetGuildMemberBonus_Show()
  local self = getGuildMemberBonus
  if not Panel_Guild_GetGuildMemberBonus:GetShow() then
    ToClient_RequestGuildMemberBonusShow()
    Panel_Guild_GetGuildMemberBonus:SetShow(true)
    self._selectedIndex = 0
    local myInvenMoney = getSelfPlayer():get():getInventory():getMoney_s64()
    warehouse_requestInfo(getCurrentWaypointKey())
    self._ui._txt_SilverInInven:SetText(makeDotMoney(myInvenMoney))
    self._ui._txt_SilverInWarehouse:SetText(makeDotMoney(warehouse_moneyByCurrentRegionMainTown_s64()))
    self._ui._txt_memberBonus:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_GETGUILDMEMBERBONUS", "money", makeDotMoney(getSelfPlayer():getGuildMemberBonus())))
  end
end
function FGlobal_GetGuildMemberBonus_Hide()
  Panel_Guild_GetGuildMemberBonus:SetShow(false)
end
function FromClient_UpdateGuildMemberBonus()
  if true == Panel_Guild_GetGuildMemberBonus:GetShow() then
    local self = getGuildMemberBonus
    self._ui._txt_memberBonus:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_GETGUILDMEMBERBONUS", "money", makeDotMoney(getSelfPlayer():getGuildMemberBonus())))
  end
end
function FGlobal_GetGuildMemberBonus_Init()
  local self = getGuildMemberBonus
  self:init()
end
function PaGlobal_GetGuildMemberBonus_SetSelectIndex(index)
  local self = getGuildMemberBonus
  self._selectedIndex = index
end
registerEvent("FromClient_luaLoadComplete", "FGlobal_GetGuildMemberBonus_Init")

local Panel_Window_StableRegister_Market_info = {
  _ui = {
    staticText_Title = nil,
    staticText_Price = nil,
    static_Profile = nil,
    static_Gender = nil,
    staticText_Tier = nil,
    staticText_HP_Val = nil,
    staticText_SP_Val = nil,
    staticText_Weight_Val = nil,
    staticText_Life_Val = nil,
    staticText_Mating_Val = nil,
    staticText_Speed_Val = nil,
    staticText_Acc_Val = nil,
    staticText_Rotate_Val = nil,
    staticText_Break_Val = nil,
    staticText_Price_Val = nil
  },
  _value = {
    minPrice = 0,
    selectServantNo = nil,
    openType = CppEnums.ServantRegist.eEventType_RegisterMarket
  },
  _config = {},
  _texture = {
    sexIcon = "Renewal/UI_Icon/Console_Icon_01.dds",
    male = {
      x1 = 82,
      y1 = 1,
      x2 = 101,
      y2 = 20
    },
    female = {
      x1 = 62,
      y1 = 1,
      x2 = 81,
      y2 = 20
    }
  }
}
function Panel_Window_StableRegister_Market_info:registerEventHandler()
  Panel_Window_StableRegister_Market:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_StableRegister_Market_Confirm()")
  Panel_Window_StableRegister_Market:registerPadEvent(__eCONSOLE_UI_INPUT_TYPE_B, "PaGlobalFunc_StableRegister_Market_Back()")
  Panel_Window_StableRegister_Market:ignorePadSnapMoveToOtherPanel()
end
function Panel_Window_StableRegister_Market_info:registerMessageHandler()
end
function Panel_Window_StableRegister_Market_info:initialize()
  self:childControl()
  self:initValue()
  self:registerMessageHandler()
  self:registerEventHandler()
end
function Panel_Window_StableRegister_Market_info:initValue()
  self._value.selectServantNo = nil
  self._value.minPrice = 0
  self._value.openType = CppEnums.ServantRegist.eEventType_RegisterMarket
end
function Panel_Window_StableRegister_Market_info:childControl()
  self._ui.staticText_Title = UI.getChildControl(Panel_Window_StableRegister_Market, "StaticText_Title")
  self._ui.staticText_Price = UI.getChildControl(Panel_Window_StableRegister_Market, "StaticText_Price")
  self._ui.static_Profile = UI.getChildControl(Panel_Window_StableRegister_Market, "Static_Profile")
  self._ui.static_Gender = UI.getChildControl(Panel_Window_StableRegister_Market, "Static_Gender")
  self._ui.staticText_Tier = UI.getChildControl(Panel_Window_StableRegister_Market, "StaticText_Tier")
  self._ui.staticText_HP_Val = UI.getChildControl(Panel_Window_StableRegister_Market, "StaticText_HP_Val")
  self._ui.staticText_SP_Val = UI.getChildControl(Panel_Window_StableRegister_Market, "StaticText_SP_Val")
  self._ui.staticText_Weight_Val = UI.getChildControl(Panel_Window_StableRegister_Market, "StaticText_Weight_Val")
  self._ui.staticText_Life_Val = UI.getChildControl(Panel_Window_StableRegister_Market, "StaticText_Life_Val")
  self._ui.staticText_Mating_Val = UI.getChildControl(Panel_Window_StableRegister_Market, "StaticText_Mating_Val")
  self._ui.staticText_Speed_Val = UI.getChildControl(Panel_Window_StableRegister_Market, "StaticText_Speed_Val")
  self._ui.staticText_Acc_Val = UI.getChildControl(Panel_Window_StableRegister_Market, "StaticText_Acc_Val")
  self._ui.staticText_Rotate_Val = UI.getChildControl(Panel_Window_StableRegister_Market, "StaticText_Rotate_Val")
  self._ui.staticText_Break_Val = UI.getChildControl(Panel_Window_StableRegister_Market, "StaticText_Break_Val")
  self._ui.staticText_Price_Val = UI.getChildControl(Panel_Window_StableRegister_Market, "StaticText_Price_Val")
  self._ui.static_Bottombg = UI.getChildControl(Panel_Window_StableRegister_Market, "Static_Bottombg")
  self._ui.static_KeyGuide_A = UI.getChildControl(self._ui.static_Bottombg, "StaticText_Confirm_ConsoleUI")
  self._ui.static_KeyGuide_B = UI.getChildControl(self._ui.static_Bottombg, "StaticText_Cancel_ConsoleUI")
  local tempBtnGroup = {
    self._ui.static_KeyGuide_A,
    self._ui.static_KeyGuide_B
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui.static_Bottombg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Panel_Window_StableRegister_Market_info:setContent()
  servantInfo = stable_getServant(self._value.selectServantNo)
  if nil == servantInfo then
    return
  end
  if CppEnums.ServantRegist.eEventType_RegisterMarket == self._value.openType then
    self._ui.staticText_Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_MARKETREGISTER"))
    self._ui.staticText_Price:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONSIGN_BUYPRICE"))
  elseif CppEnums.ServantRegist.eEventType_RegisterMating == self._value.openType then
    self._ui.staticText_Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_MATINGREGISTER"))
    self._ui.staticText_Price:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_STABLEREGISTER_MATING_PRICE"))
  end
  self._ui.static_Profile:ChangeTextureInfoName(servantInfo:getIconPath1())
  if servantInfo:isMale() then
    self._ui.static_Gender:ChangeTextureInfoName(self._texture.sexIcon)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Gender, self._texture.male.x1, self._texture.male.y1, self._texture.male.x2, self._texture.male.y2)
    self._ui.static_Gender:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.static_Gender:setRenderTexture(self._ui.static_Gender:getBaseTexture())
  else
    self._ui.static_Gender:ChangeTextureInfoName(self._texture.sexIcon)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Gender, self._texture.female.x1, self._texture.female.y1, self._texture.female.x2, self._texture.female.y2)
    self._ui.static_Gender:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.static_Gender:setRenderTexture(self._ui.static_Gender:getBaseTexture())
  end
  self._ui.staticText_HP_Val:SetText(makeDotMoney(servantInfo:getHp()) .. " / " .. makeDotMoney(servantInfo:getMaxHp()))
  self._ui.staticText_SP_Val:SetText(makeDotMoney(servantInfo:getMp()) .. " / " .. makeDotMoney(servantInfo:getMaxMp()))
  self._ui.staticText_Weight_Val:SetText(makeDotMoney(servantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000))
  if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse then
    self._ui.staticText_Tier:SetShow(true)
    if 9 == servantInfo:getTier() then
      self._ui.staticText_Tier:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TEXT_TIER9"))
    else
      self._ui.staticText_Tier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", servantInfo:getTier()))
    end
  else
    self._ui.staticText_Tier:SetShow(false)
  end
  local deadCount = servantInfo:getDeadCount()
  if servantInfo:doClearCountByDead() then
    deadCount = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETOK", "deadCount", deadCount)
  else
    deadCount = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETNO", "deadCount", deadCount)
  end
  local matingCount = servantInfo:getMatingCount()
  if servantInfo:doClearCountByDead() then
    matingCount = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETOK", "deadCount", matingCount)
  else
    matingCount = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETNO", "deadCount", matingCount)
  end
  self._ui.staticText_Life_Val:SetText(deadCount)
  self._ui.staticText_Mating_Val:SetText(matingCount)
  self._ui.staticText_Speed_Val:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / 10000) .. "%")
  self._ui.staticText_Acc_Val:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration) / 10000) .. "%")
  self._ui.staticText_Rotate_Val:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / 10000) .. "%")
  self._ui.staticText_Break_Val:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / 10000) .. "%")
  if self._value.openType == CppEnums.ServantRegist.eEventType_RegisterMarket then
    self._value.minPrice = servantInfo:getMinRegisterMarketPrice_s64()
  end
  if self._value.openType == CppEnums.ServantRegist.eEventType_RegisterMating then
    self._value.minPrice = servantInfo:getMinRegisterMatingPrice_s64()
  end
  self._ui.staticText_Price_Val:SetText(makeDotMoney(self._value.minPrice))
end
function Panel_Window_StableRegister_Market_info:open()
  Panel_Window_StableRegister_Market:SetShow(true)
end
function Panel_Window_StableRegister_Market_info:close()
  Panel_Window_StableRegister_Market:SetShow(false)
end
function PaGlobalFunc_StableRegister_Market_GetShow()
  return Panel_Window_StableRegister_Market:GetShow()
end
function PaGlobalFunc_StableRegister_Market_Open()
  local self = Panel_Window_StableRegister_Market_info
  self:open()
end
function PaGlobalFunc_StableRegister_Market_Close()
  local self = Panel_Window_StableRegister_Market_info
  self:close()
end
function PaGlobalFunc_StableRegister_Market_Exit()
  local self = Panel_Window_StableRegister_Market_info
  self:close()
  PaGlobalFunc_StableList_Show()
end
function PaGlobalFunc_StableRegister_Market_ShowByType(eOpenType)
  local self = Panel_Window_StableRegister_Market_info
  self:initValue()
  if nil == eOpenType or eOpenType ~= CppEnums.ServantRegist.eEventType_RegisterMarket and eOpenType ~= CppEnums.ServantRegist.eEventType_RegisterMating then
    self._value.openType = CppEnums.ServantRegist.eEventType_RegisterMarket
  else
    self._value.openType = eOpenType
  end
  self._value.selectServantNo = PaGlobalFunc_StableList_SelectSlotNo()
  if nil == self._value.selectServantNo then
    return
  end
  self:setContent()
  self:open()
  PaGlobalFunc_StableInfo_Close()
end
function PaGlobalFunc_StableRegister_Market_Confirm()
  local self = Panel_Window_StableRegister_Market_info
  if self._value.openType == CppEnums.ServantRegist.eEventType_RegisterMating then
    if self._value.selectServantNo == PaGlobalFunc_StableList_SelectSlotNo() then
      PaGlobalFunc_StableRegister_MarketCheck_ShowByServantNo(self._value.selectServantNo)
    else
    end
  else
    _AudioPostEvent_SystemUiForXBOX(50, 0)
    stable_registerServantToSomeWhereElse(self._value.selectServantNo, CppEnums.AuctionType.AuctionGoods_ServantMarket, CppEnums.TransferType.TransferType_Normal, self._value.minPrice)
    self:close()
  end
end
function PaGlobalFunc_StableRegister_Market_Back()
  local self = Panel_Window_StableRegister_Market_info
  self:close()
  PaGlobalFunc_StableInfo_Open()
end
function FromClient_StableRegister_Market_Init()
  local self = Panel_Window_StableRegister_Market_info
  self:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_StableRegister_Market_Init")

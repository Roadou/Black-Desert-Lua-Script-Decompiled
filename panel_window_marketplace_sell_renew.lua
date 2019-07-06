local _panel = Panel_Window_MarketPlace_SellManagement
_panel:ignorePadSnapMoveToOtherPanel()
local MarketPlaceSell = {
  _ui = {
    _button_WinClose = UI.getChildControl(_panel, "Button_Win_Close"),
    _itemStatusBg = UI.getChildControl(_panel, "Static_ItemBg"),
    _stc_ItemName = UI.getChildControl(_panel, "StaticText_ItemName"),
    _stc_WeightBg = UI.getChildControl(_panel, "Static_WeightBg"),
    _stc_PriceBg = UI.getChildControl(_panel, "Static_PriceBg"),
    _stc_CountBg = UI.getChildControl(_panel, "Static_CountBg"),
    _stc_Desc = UI.getChildControl(_panel, "StaticText_Desc"),
    _selectItemPriceBg = UI.getChildControl(_panel, "Static_SetPrice"),
    _selectItemCountBg = UI.getChildControl(_panel, "Static_SetCount"),
    _stc_WalletBg = UI.getChildControl(_panel, "Static_WalletBg"),
    _stc_TotalPriceBg = UI.getChildControl(_panel, "Static_TotalPriceBg"),
    _button_Sell = UI.getChildControl(_panel, "Button_InMarketRegist"),
    _stc_BottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true
  },
  _config = {
    _defaultPanelSizeY = _panel:GetSizeY()
  },
  _selectPriceInfo = {
    _price = toInt64(0, 0),
    _index = 0
  },
  _selectCount = toInt64(0, 0),
  _maxItemCount_s64 = toInt64(0, 0),
  _selectEnchantLevel = 0,
  _enchantLevelPrice = toInt64(0, 0),
  _selectItemSlot = nil,
  _itemKey = 0,
  _itemMinLevel = 0,
  _biddingSellListCount = 0,
  _isSealed = false,
  _sellitemName = nil,
  _itemnameColor = nil,
  _standardPrice_s64 = toInt64(0, 0)
}
function MarketPlaceSell:initialize()
  self:createControl()
end
function MarketPlaceSell:createControl()
  self._ui._itemWeight = UI.getChildControl(self._ui._stc_WeightBg, "StaticText_WeightValue")
  self._ui._itemPrice = UI.getChildControl(self._ui._stc_PriceBg, "StaticText_PriceValue")
  self._ui._itemCount = UI.getChildControl(self._ui._stc_CountBg, "StaticText_CountValue")
  self._ui._selectItemCount = UI.getChildControl(self._ui._selectItemCountBg, "StaticText_CountValue")
  self._ui._selectItemPrice = UI.getChildControl(self._ui._selectItemPriceBg, "StaticText_PriceValue")
  self._ui._myGoldValue = UI.getChildControl(self._ui._stc_WalletBg, "StaticText_MyGoldValue")
  self._ui._weightValue = UI.getChildControl(self._ui._stc_WalletBg, "StaticText_WeightValue")
  self._ui._priceFormula = UI.getChildControl(self._ui._stc_TotalPriceBg, "StaticText_PriceFormula")
  self._ui._totalPrice = UI.getChildControl(self._ui._stc_TotalPriceBg, "StaticText_7")
  self._ui._selectItemPriceBg:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceSell_OpenSelectList(1)")
  self._ui._selectItemCountBg:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceSell_SelectCount()")
  self._ui._button_Sell:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceSell_Req()")
  self._ui._button_WinClose:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceSell_Cancel()")
  self._ui._txt_A_ConsoleUI = UI.getChildControl(self._ui._stc_BottomBg, "StaticText_A_ConsoleUI")
  self._ui._txt_B_ConsoleUI = UI.getChildControl(self._ui._stc_BottomBg, "StaticText_B_ConsoleUI")
  self._ui._txt_X_ConsoleUI = UI.getChildControl(self._ui._stc_BottomBg, "StaticText_KeyGuideDetail")
  self._ui._txt_Y_ConsoleUI = UI.getChildControl(self._ui._stc_BottomBg, "StaticText_Y_ConsoleUI")
  local keyGuides = {
    self._ui._txt_X_ConsoleUI,
    self._ui._txt_A_ConsoleUI,
    self._ui._txt_Y_ConsoleUI,
    self._ui._txt_B_ConsoleUI
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui._stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  local slot = {}
  slot.background = self._ui._itemStatusBg
  SlotItem.new(slot, "ItemIcon", 0, slot.background, self._slotConfig)
  slot:createChild()
  slot.icon:SetShow(true)
  self._selectItemSlot = slot
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobal_MarketPlaceSell_Req()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobal_MarketPlaceSell_Tooltip()")
end
function MarketPlaceSell:updateNeedTotalPrice()
  local needTotalPrice = self._selectCount * (self._selectPriceInfo._price + self._enchantLevelPrice)
  self._ui._priceFormula:SetText("(" .. makeDotMoney(self._selectPriceInfo._price) .. " + " .. makeDotMoney(self._enchantLevelPrice) .. ") X " .. makeDotMoney(self._selectCount))
  self._ui._totalPrice:SetText(makeDotMoney(needTotalPrice))
end
function MarketPlaceSell:setNameAndEnchantLevel(enchantLevel, itemType, itemName, itemClassify)
  local nameStr = ""
  if 1 == itemType and enchantLevel > 15 then
    nameStr = HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemName
  elseif enchantLevel > 0 and CppEnums.ItemClassifyType.eItemClassify_Accessory == itemClassify then
    nameStr = HighEnchantLevel_ReplaceString(enchantLevel + 15) .. " " .. itemName
  else
    nameStr = itemName
  end
  return nameStr
end
function MarketPlaceSell:setPanelSize()
  local startSizeY = self._config._defaultPanelSizeY
  if false == self._ui._selectItemCountBg:GetShow() then
    startSizeY = startSizeY - 50
  end
  _panel:SetSize(_panel:GetSizeX(), startSizeY)
  self._ui._stc_WalletBg:ComputePos()
  self._ui._stc_TotalPriceBg:ComputePos()
  self._ui._button_Sell:ComputePos()
  self._ui._stc_BottomBg:ComputePos()
end
function PaGlobal_MarketPlaceSell_OpenSelectList(selectListType)
  local self = MarketPlaceSell
  if 1 == selectListType then
    PaGlobalFunc_MarketPlaceSelectList_Open(selectListType, self._standardPrice_s64, 0, self._biddingSellListCount)
  end
end
function PaGlobal_MarketPlaceSell_SelectCount()
  local self = MarketPlaceSell
  PaGlobal_MarketPlaceSelectList_Cancel()
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._itemKey, self._itemMinLevel))
  if nil ~= itemSSW then
    local maxRegisterCount = itemSSW:getMaxRegisterCountForWorldMarket() * toInt64(0, 10)
    if true == itemSSW:get():isCash() then
      maxRegisterCount = toInt64(0, 100)
    end
    if maxRegisterCount < self._maxItemCount_s64 then
      self._maxItemCount_s64 = maxRegisterCount
    end
  else
    self._maxItemCount_s64 = toInt64(0, 0)
  end
  Panel_NumberPad_Show(true, self._maxItemCount_s64, nil, PaGlobal_MarketPlaceSell_SetCount)
end
function PaGlobal_MarketPlaceSell_SetCount(inputNumber)
  local self = MarketPlaceSell
  self._ui._selectItemCount:SetText(makeDotMoney(inputNumber))
  self._selectCount = inputNumber
  self:updateNeedTotalPrice()
end
function PaGlobalFunc_MarketPlaceSell_Initialize()
  MarketPlaceSell:initialize()
end
function FromClient_responseGetSellBiddingList(systemItemInfo, biddingSellListCount)
  local itemKey = systemItemInfo:getItemKeyRaw()
  local enchantLevel = systemItemInfo:getEnchantLevel()
  local enchantMinLevel = systemItemInfo:getMinEnchantLevel()
  local standardPrice_s64 = systemItemInfo:getBiddingPricePerOne()
  local itemCount_s64 = systemItemInfo:getBiddingCount()
  local isSealed = systemItemInfo:isSealed()
  MarketPlaceSell:open(itemKey, enchantLevel, enchantMinLevel, standardPrice_s64, itemCount_s64, isSealed, biddingSellListCount)
end
function MarketPlaceSell:open(itemKey, enchantLevel, enchantMinLevel, standardPrice_s64, itemCount_s64, isSealed, biddingSellListCount)
  tempItemEnchantKey = ItemEnchantKey(itemKey, enchantLevel)
  local itemSSW = getItemEnchantStaticStatus(tempItemEnchantKey)
  if nil == itemSSW then
    return
  end
  local nameColorGrade = itemSSW:getGradeType()
  local enchantLevel = itemSSW:get()._key:getEnchantLevel()
  self._selectItemSlot:setItemByStaticStatus(itemSSW)
  self._itemKey = itemKey
  self._itemLevel = enchantLevel
  self._itemMinLevel = enchantMinLevel
  self._biddingSellListCount = biddingSellListCount - 1
  self._isSealed = isSealed
  if self._itemLevel ~= self._itemMinLevel then
    ToClient_requestGetAddEnchantLevelPrice(self._itemKey, self._itemLevel)
  else
    self._enchantLevelPrice = toInt64(0, 0)
  end
  local nameColor = PaGlobalFunc_MarketPlace_SetNameColor(nameColorGrade)
  local nameColor_Desc = PaGlobalFunc_MarketPlace_SetNameColor_Desc(nameColorGrade)
  self._ui._stc_ItemName:SetFontColor(nameColor)
  self._itemnameColor = nameColor_Desc
  local itemNameStr = PaGlobalFunc_MarketPlace_setNameAndEnchantLevel(enchantLevel, itemSSW:getItemType(), itemSSW:getName(), itemSSW:getItemClassify())
  self._ui._stc_ItemName:SetText(itemNameStr)
  self._sellitemName = itemNameStr
  local str_itemWeight = string.format("%.2f", Int64toInt32(itemSSW:getWorldMarketVolume()) / 10)
  self._ui._itemWeight:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_VOLUME_VT_PARAM_NONCOLOR", "Weight", str_itemWeight))
  self._ui._itemPrice:SetText(makeDotMoney(standardPrice_s64))
  self._ui._itemCount:SetText(makeDotMoney(itemCount_s64))
  PaGlobalFunc_MarketPlaceSell_SelectPrice(0, standardPrice_s64)
  PaGlobal_MarketPlaceSell_SetCount(toInt64(0, 1))
  local silverInfo = getWorldMarketSilverInfo()
  self._ui._myGoldValue:SetText(makeDotMoney(silverInfo:getItemCount()))
  local currentWeight = getWorldMarketCurrentWeight()
  local maxWeight = getWorldMarketMaxWeight()
  local s64_allWeight_div = toInt64(0, currentWeight)
  local s64_maxWeight_div = toInt64(0, maxWeight)
  local str_AllWeight = string.format("%.1f", Int64toInt32(s64_allWeight_div) / 10)
  local str_MaxWeight = string.format("%.0f", Int64toInt32(s64_maxWeight_div) / 10)
  self._ui._weightValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_VOLUME_VT_PARAM_NONCOLOR", "Weight", str_AllWeight .. " / " .. str_MaxWeight))
  self._maxItemCount_s64 = itemCount_s64
  self._selectPriceInfo._price = standardPrice_s64
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._itemKey, self._itemMinLevel))
  local maxRegisterCount = 0
  if nil ~= itemSSW then
    maxRegisterCount = itemSSW:getMaxRegisterCountForWorldMarket() * toInt64(0, 10)
    if true == itemSSW:get():isCash() then
      maxRegisterCount = toInt64(0, 100)
    end
    if toInt64(0, 1) < self._maxItemCount_s64 and maxRegisterCount > toInt64(0, 1) then
      self._ui._selectItemCountBg:SetShow(true)
    else
      self._ui._selectItemCountBg:SetShow(false)
    end
  end
  self:setPanelSize()
  self:updateNeedTotalPrice()
  self._standardPrice_s64 = standardPrice_s64
  _panel:SetShow(true)
end
function PaGlobalFunc_MarketPlaceSell_SelectPriceByIndex(index)
  local self = MarketPlaceSell
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlaceSell")
    return
  end
  if false == _panel:GetShow() then
    return
  end
  local price_s64 = ToClient_getWorldMarketSellBiddingLstPrice(index)
  PaGlobalFunc_MarketPlaceSell_SelectPrice(index, price_s64)
  PaGlobal_MarketPlaceSelectList_Cancel()
end
function PaGlobalFunc_MarketPlaceSell_SelectPrice(index, itemPrice)
  local self = MarketPlaceSell
  self._ui._selectItemPrice:SetText(makeDotMoney(itemPrice))
  local prevSelectPriceIndex = self._selectPriceInfo._index
  self._selectPriceInfo._index = index
  self._selectPriceInfo._price = itemPrice
  self:updateNeedTotalPrice()
end
function PaGlobalFunc_MarketPlaceSell_GetShow()
  return _panel:GetShow()
end
function PaGlobal_MarketPlaceSell_Req()
  local self = MarketPlaceSell
  local UI_BUFFTYPE = CppEnums.UserChargeType
  local enchantKey = ItemEnchantKey(self._itemKey, self._itemLevel)
  local itemSSW = getItemEnchantStaticStatus(enchantKey)
  if nil == itemSSW then
    return
  end
  local isPremiumUser = false
  if true == getSelfPlayer():get():isApplyChargeSkill(UI_BUFFTYPE.eUserChargeType_PremiumPackage) then
    isPremiumUser = true
  end
  local isCountryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_UNAPPLIED_VALUE_PACKAGE_TOOLTIP_DESC", "forPremium", requestGetRefundPercentForPremiumPackage())
  local function sellExcute()
    ToClient_requestSellItemToWorldMarket(self._itemKey, self._itemMinLevel, self._selectCount, self._selectPriceInfo._price, self._itemLevel, self._isSealed)
    PaGlobal_MarketPlaceSell_Cancel()
  end
  local function checkbox_sell()
    local needTotalPrice = self._selectCount * (self._selectPriceInfo._price + self._enchantLevelPrice)
    local messageBoxMemo = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_MARKETPLACE_SELL", "itemName", tostring(self._itemnameColor .. self._sellitemName .. "<PAOldColor>"), "itemCount", tostring(self._selectCount), "itemSumPrice", makeDotMoney(needTotalPrice))
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_SELL_TITLE")
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = sellExcute,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
  if false == isPremiumUser and false == itemSSW:get():isCash() then
    FromClient_ValuePackageIcon()
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
    local messageBoxMemo = isCountryTypeSet
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = checkbox_sell,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "middle")
  else
    checkbox_sell()
  end
end
function PaGlobal_MarketPlaceSell_Tooltip()
  local self = MarketPlaceSell
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._itemKey, self._itemLevel))
  PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.Item, 0, getScreenSizeX())
end
function PaGlobal_MarketPlaceSell_Cancel()
  Panel_NumberPad_Close()
  PaGlobalFunc_TooltipInfo_Close()
  PaGlobal_MarketPlaceSelectList_Cancel()
  _panel:SetShow(false)
end
function PaGlobalFunc_MarketPlaceSell_EnchantLevelPrice(enchantLevelPrice)
  local self = MarketPlaceSell
  self._enchantLevelPrice = enchantLevelPrice
  self:updateNeedTotalPrice()
end
function FromClient_responseSellItemToWorldMarket(mySilver)
  ToClient_requestMyBiddingListByWorldMarket()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_MarketPlaceSell_Initialize")
registerEvent("FromClient_responseGetSellBiddingList", "FromClient_responseGetSellBiddingList")
registerEvent("FromClient_responseSellItemToWorldMarket", "FromClient_responseSellItemToWorldMarket")

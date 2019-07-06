local _panel = Panel_Window_MarketPlace_BuyManagement
_panel:ignorePadSnapMoveToOtherPanel()
local MarketPlaceBuy = {
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
    _selectItemEnchantBg = UI.getChildControl(_panel, "Static_SetEnchant"),
    _stc_WalletBg = UI.getChildControl(_panel, "Static_WalletBg"),
    _stc_TotalPriceBg = UI.getChildControl(_panel, "Static_TotalPriceBg"),
    _button_Buy = UI.getChildControl(_panel, "Button_InMarketRegist"),
    _bottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true
  },
  _config = {
    _defaultPanelSizeY = _panel:GetSizeY()
  },
  _selectEnchantLevel = 0,
  _enchantLevelPrice = toInt64(0, 0),
  _selectPriceInfo = {
    _price = toInt64(0, 0),
    _index = 0
  },
  _selectCount = toInt64(0, 0),
  _maxItemCount_s64 = toInt64(0, 0),
  _selectItemSlot = nil,
  _itemKey = 0,
  _itemMinLevel = 0,
  _itemMaxLevel = 0,
  _biddingBuyListCount = 0,
  _buyitemName = nil,
  _registitemCount = nil,
  _itemnameColor = nil,
  _standardPrice_s64 = toInt64(0, 0)
}
function MarketPlaceBuy:initialize()
  self:createControl()
end
function MarketPlaceBuy:createControl()
  self._ui._itemWeight = UI.getChildControl(self._ui._stc_WeightBg, "StaticText_WeightValue")
  self._ui._itemPrice = UI.getChildControl(self._ui._stc_PriceBg, "StaticText_PriceValue")
  self._ui._itemCount = UI.getChildControl(self._ui._stc_CountBg, "StaticText_CountValue")
  self._ui._selectItemCount = UI.getChildControl(self._ui._selectItemCountBg, "StaticText_CountValue")
  self._ui._selectItemPrice = UI.getChildControl(self._ui._selectItemPriceBg, "StaticText_PriceValue")
  self._ui._selectItemEnchant = UI.getChildControl(self._ui._selectItemEnchantBg, "StaticText_EnchantValue")
  self._ui._myGoldValue = UI.getChildControl(self._ui._stc_WalletBg, "StaticText_MyGoldValue")
  self._ui._weightValue = UI.getChildControl(self._ui._stc_WalletBg, "StaticText_WeightValue")
  self._ui._priceFormula = UI.getChildControl(self._ui._stc_TotalPriceBg, "StaticText_PriceFormula")
  self._ui._totalPrice = UI.getChildControl(self._ui._stc_TotalPriceBg, "StaticText_7")
  self._ui._selectItemPriceBg:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceBuy_OpenSelectList(0)")
  self._ui._selectItemEnchantBg:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceBuy_OpenSelectList(2)")
  self._ui._selectItemCountBg:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceBuy_SelectCount()")
  self._ui._button_Buy:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceBuy_Req()")
  self._ui._button_WinClose:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceBuy_Cancel()")
  local slot = {}
  slot.background = self._ui._itemStatusBg
  SlotItem.new(slot, "ItemIcon", 0, slot.background, self._slotConfig)
  slot:createChild()
  slot.icon:SetShow(true)
  self._selectItemSlot = slot
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobal_MarketPlaceBuy_Req()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobal_MarketPlaceBuy_Tooltip()")
  self._ui._stctxt_keyguideX = UI.getChildControl(self._ui._bottomBg, "StaticText_KeyGuideDetail")
  self._ui._stctxt_keyguideY = UI.getChildControl(self._ui._bottomBg, "StaticText_Y_ConsoleUI")
  self._ui._stctxt_keyguideA = UI.getChildControl(self._ui._bottomBg, "StaticText_A_ConsoleUI")
  self._ui._stctxt_keyguideB = UI.getChildControl(self._ui._bottomBg, "StaticText_B_ConsoleUI")
  local tempBtnGroup = {
    self._ui._stctxt_keyguideX,
    self._ui._stctxt_keyguideY,
    self._ui._stctxt_keyguideA,
    self._ui._stctxt_keyguideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui._bottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function MarketPlaceBuy:computeControl()
  local startSizeY = self._config._defaultPanelSizeY
  local startPosY = self._ui._selectItemPriceBg:GetPosY() + 50
  if true == self._ui._selectItemCountBg:GetShow() then
    self._ui._selectItemCountBg:SetPosY(startPosY)
    startPosY = startPosY + 50
  end
  if true == self._ui._selectItemEnchantBg:GetShow() then
    self._ui._selectItemEnchantBg:SetPosY(startPosY)
  end
  if false == self._ui._selectItemCountBg:GetShow() then
    startSizeY = startSizeY - 50
  end
  if false == self._ui._selectItemEnchantBg:GetShow() then
    startSizeY = startSizeY - 50
  end
  _panel:SetSize(_panel:GetSizeX(), startSizeY)
  self._ui._stc_WalletBg:ComputePos()
  self._ui._stc_TotalPriceBg:ComputePos()
  self._ui._button_Buy:ComputePos()
  local bottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  bottomBg:ComputePos()
end
function MarketPlaceBuy:updateNeedTotalPrice()
  local needTotalPrice = self._selectCount * (self._selectPriceInfo._price + self._enchantLevelPrice)
  self._ui._priceFormula:SetText("(" .. makeDotMoney(self._selectPriceInfo._price) .. " + " .. makeDotMoney(self._enchantLevelPrice) .. ") X " .. makeDotMoney(self._selectCount))
  self._ui._totalPrice:SetText(makeDotMoney(needTotalPrice))
end
function MarketPlaceBuy:makeEnchantLevelStr(itemStatic, minEnchantLevel, maxEnchantLevel)
  local resultEnchantLevelStr = ""
  if itemStatic:isEquipable() then
    local itemType = itemStatic:getItemType()
    local itemClassify = itemStatic:getItemClassify()
    if 0 == minEnchantLevel and minEnchantLevel == maxEnchantLevel then
      return resultEnchantLevelStr
    end
    resultEnchantLevelStr = MarketPlaceBuy:setNameAndEnchantLevel(minEnchantLevel, itemType, itemClassify)
    if minEnchantLevel ~= maxEnchantLevel then
      resultEnchantLevelStr = resultEnchantLevelStr .. " ~ " .. MarketPlaceBuy:setNameAndEnchantLevel(maxEnchantLevel, itemType, itemClassify)
    end
  end
  return resultEnchantLevelStr
end
function MarketPlaceBuy:setNameAndEnchantLevel(enchantLevel, itemType, itemClassify)
  local nameStr = ""
  if 1 == itemType and enchantLevel > 15 then
    nameStr = HighRomaEnchantLevel_ReplaceString(enchantLevel)
  elseif enchantLevel > 0 and CppEnums.ItemClassifyType.eItemClassify_Accessory == itemClassify then
    nameStr = HighRomaEnchantLevel_ReplaceString(enchantLevel + 15)
  else
    nameStr = "+" .. tostring(enchantLevel)
  end
  return nameStr
end
function PaGlobal_MarketPlaceBuy_OpenSelectList(selectListType)
  local self = MarketPlaceBuy
  if 0 == selectListType then
    PaGlobalFunc_MarketPlaceSelectList_Open(selectListType, self._standardPrice_s64, 0, self._biddingBuyListCount)
  elseif 2 == selectListType then
    PaGlobalFunc_MarketPlaceSelectList_Open(selectListType, self._standardPrice_s64, self._itemMinLevel, self._itemMaxLevel)
  end
end
function PaGlobal_MarketPlaceBuy_SelectCount()
  local self = MarketPlaceBuy
  PaGlobal_MarketPlaceSelectList_Cancel()
  local silverInfo = getWorldMarketSilverInfo()
  self._maxItemCount_s64 = silverInfo:getItemCount() / (self._selectPriceInfo._price + self._enchantLevelPrice)
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._itemKey, self._itemMinLevel))
  if nil ~= itemSSW then
    local maxRegisterCount = itemSSW:getMaxRegisterCountForWorldMarket()
    if maxRegisterCount < self._maxItemCount_s64 then
      self._maxItemCount_s64 = maxRegisterCount
    end
  else
    self._maxItemCount_s64 = toInt64(0, 0)
  end
  Panel_NumberPad_Show(true, self._maxItemCount_s64, nil, PaGlobal_MarketPlaceBuy_SetCount)
end
function PaGlobal_MarketPlaceBuy_SetCount(inputNumber)
  local self = MarketPlaceBuy
  self._ui._selectItemCount:SetText(makeDotMoney(inputNumber))
  self._selectCount = inputNumber
  self:updateNeedTotalPrice()
end
function PaGlobal_MarketPlaceBuy_Req()
  local self = MarketPlaceBuy
  local needTotalPrice = self._selectCount * (self._selectPriceInfo._price + self._enchantLevelPrice)
  local messageBoxMemo = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_MARKETPLACE_BUY", "itemName", tostring(self._itemnameColor .. self._buyitemName .. "<PAOldColor>"), "itemCount", tostring(self._selectCount), "itemSumPrice", makeDotMoney(needTotalPrice))
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_BUY_TITLE"),
    content = messageBoxMemo,
    functionYes = MarketPlaceBuy_YES,
    functionNo = MessageBox_Empty_function,
    exitButton = true,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function MarketPlaceBuy_YES()
  local self = MarketPlaceBuy
  PaGlobal_MarketPlaceBuy_Cancel()
  ToClient_requestBuyItemToWorldMarket(self._itemKey, self._itemMinLevel, self._selectCount, self._selectPriceInfo._price, self._selectEnchantLevel)
end
function PaGlobal_MarketPlaceBuy_Tooltip()
  local self = MarketPlaceBuy
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._itemKey, self._selectEnchantLevel))
  PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.Item, 0, getScreenSizeX())
end
function PaGlobal_MarketPlaceBuy_Cancel()
  Panel_NumberPad_Close()
  PaGlobalFunc_TooltipInfo_Close()
  PaGlobal_MarketPlaceSelectList_Cancel()
  _panel:SetShow(false)
end
function PaGlobalFunc_MarketPlaceBuy_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_MarketPlaceBuy_SelectEnchantLevel(enchantLevel, isGroupLevel)
  local self = MarketPlaceBuy
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlaceBuy")
    return
  end
  local enchantStr
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._itemKey, self._itemMinLevel))
  if itemSSW:isEquipable() then
    local itemType = itemSSW:getItemType()
    local itemClassify = itemSSW:getItemClassify()
    enchantStr = self:setNameAndEnchantLevel(enchantLevel, itemType, itemClassify)
  else
    enchantStr = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_AFFILIATEDTERRITORY")
  end
  self._ui._selectItemEnchant:SetText(enchantStr)
  local prevSelectEnchantLevel = self._selectEnchantLevel
  self._selectEnchantLevel = enchantLevel
  if true == isGroupLevel then
    ToClient_requestGetAddEnchantLevelPrice(self._itemKey, self._selectEnchantLevel)
  end
  itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._itemKey, self._selectEnchantLevel))
  if nil == itemSSW then
    return
  end
  local nameColorGrade = itemSSW:getGradeType()
  local enchantLevel = itemSSW:get()._key:getEnchantLevel()
  self._selectItemSlot:setItemByStaticStatus(itemSSW)
  local itemNameStr = PaGlobalFunc_MarketPlace_setNameAndEnchantLevel(enchantLevel, itemSSW:getItemType(), itemSSW:getName(), itemSSW:getItemClassify())
  self._ui._stc_ItemName:SetText(itemNameStr)
  self._buyitemName = itemNameStr
  PaGlobal_MarketPlaceSelectList_Cancel()
end
function PaGlobalFunc_MarketPlaceBuy_SelectPriceByIndex(index)
  local self = MarketPlaceBuy
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlaceBuy")
    return
  end
  if false == _panel:GetShow() then
    return
  end
  local price_s64 = ToClient_getWorldMarketBuyBiddingLstPrice(index)
  PaGlobalFunc_MarketPlaceBuy_SelectPrice(index, price_s64)
  PaGlobal_MarketPlaceSelectList_Cancel()
end
function PaGlobalFunc_MarketPlaceBuy_SelectOriginPrice(originPrice64)
  local self = MarketPlaceBuy
  for ii = 0, self._biddingBuyListCount do
    if ToClient_getWorldMarketBuyBiddingLstPrice(ii) == originPrice64 then
      PaGlobalFunc_MarketPlaceBuy_SelectPrice(ii, originPrice64)
      PaGlobal_MarketPlaceSelectList_Cancel()
      return
    end
  end
end
function PaGlobalFunc_MarketPlaceBuy_SelectPrice(index, itemPrice)
  local self = MarketPlaceBuy
  self._ui._selectItemPrice:SetText(makeDotMoney(itemPrice))
  local prevSelectPriceIndex = self._selectPriceInfo._index
  self._selectPriceInfo._index = index
  self._selectPriceInfo._price = itemPrice
  local isEnchantSelectable = false
  for ii = index, self._biddingBuyListCount do
    local biddingInfo = ToClient_GetBiddingInfoByIndex(ii)
    local price_s64 = ToClient_GetBiddingPriceByIndex(ii)
    local sellCount = Int64toInt32(biddingInfo:getSellCount())
    if sellCount > 0 then
      isEnchantSelectable = true
    end
  end
  self._ui._selectItemEnchantBg:SetShow(isEnchantSelectable)
  if 0 == self._itemMinLevel and 0 == self._itemMaxLevel or self._itemMinLevel == self._itemMaxLevel then
    self._ui._selectItemEnchantBg:SetShow(false)
  end
  self:computeControl()
  self:updateNeedTotalPrice()
end
function PaGlobalFunc_MarketPlaceBuy_Initialize()
  MarketPlaceBuy:initialize()
end
function FromClient_responseGetBuyBiddingList(systemItemInfo, biddingBuyListCount)
  local itemKey = systemItemInfo:getItemKeyRaw()
  local minEnchantLevel = systemItemInfo:getMinEnchantLevel()
  local maxEnchantLevel = systemItemInfo:getMaxEnchantLevel()
  local standardPrice_s64 = systemItemInfo:getBiddingPricePerOne()
  local itemCount_s64 = systemItemInfo:getBiddingCount()
  MarketPlaceBuy:open(itemKey, minEnchantLevel, maxEnchantLevel, standardPrice_s64, itemCount_s64, biddingBuyListCount)
end
function MarketPlaceBuy:open(itemKey, minEnchantLevel, maxEnchantLevel, standardPrice_s64, itemCount_s64, biddingBuyListCount)
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey, minEnchantLevel))
  if nil == itemSSW then
    return
  end
  local nameColorGrade = itemSSW:getGradeType()
  local enchantLevel = itemSSW:get()._key:getEnchantLevel()
  self._selectItemSlot:setItemByStaticStatus(itemSSW)
  self._itemKey = itemKey
  self._itemMinLevel = minEnchantLevel
  self._itemMaxLevel = maxEnchantLevel
  self._biddingBuyListCount = biddingBuyListCount - 1
  self._enchantLevelPrice = toInt64(0, 0)
  local nameColor = PaGlobalFunc_MarketPlace_SetNameColor(nameColorGrade)
  local nameColor_Desc = PaGlobalFunc_MarketPlace_SetNameColor_Desc(nameColorGrade)
  self._ui._stc_ItemName:SetFontColor(nameColor)
  self._itemnameColor = nameColor_Desc
  local itemNameStr = PaGlobalFunc_MarketPlace_setNameAndEnchantLevel(enchantLevel, itemSSW:getItemType(), itemSSW:getName(), itemSSW:getItemClassify())
  self._ui._stc_ItemName:SetText(itemNameStr)
  self._buyitemName = itemNameStr
  local str_itemWeight = string.format("%.2f", Int64toInt32(itemSSW:getWorldMarketVolume()) / 10)
  self._ui._itemWeight:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_VOLUME_VT_PARAM_NONCOLOR", "Weight", str_itemWeight))
  self._ui._itemPrice:SetText(makeDotMoney(standardPrice_s64))
  self._ui._itemCount:SetText(makeDotMoney(itemCount_s64))
  self._registitemCount = makeDotMoney(itemCount_s64)
  self._ui._selectItemEnchantBg:SetShow(true)
  self._ui._selectItemEnchantBg:SetEnable(true)
  local isGroupLevel = minEnchantLevel ~= maxEnchantLevel
  PaGlobalFunc_MarketPlaceBuy_SelectEnchantLevel(minEnchantLevel, isGroupLevel)
  PaGlobalFunc_MarketPlaceBuy_SelectOriginPrice(standardPrice_s64)
  PaGlobal_MarketPlaceBuy_SetCount(toInt64(0, 1))
  local silverInfo = getWorldMarketSilverInfo()
  self._ui._myGoldValue:SetText(makeDotMoney(silverInfo:getItemCount()))
  local currentWeight = getWorldMarketCurrentWeight()
  local maxWeight = getWorldMarketMaxWeight()
  local s64_allWeight_div = toInt64(0, currentWeight)
  local s64_maxWeight_div = toInt64(0, maxWeight)
  local str_AllWeight = string.format("%.1f", Int64toInt32(s64_allWeight_div) / 10)
  local str_MaxWeight = string.format("%.0f", Int64toInt32(s64_maxWeight_div) / 10)
  self._ui._weightValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_VOLUME_VT_PARAM_NONCOLOR", "Weight", str_AllWeight .. " / " .. str_MaxWeight))
  self._maxItemCount_s64 = silverInfo:getItemCount() / standardPrice_s64
  self._selectPriceInfo._price = standardPrice_s64
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._itemKey, self._itemMinLevel))
  local maxRegisterCount = 0
  if nil ~= itemSSW then
    maxRegisterCount = itemSSW:getMaxRegisterCountForWorldMarket()
    if toInt64(0, 1) < self._maxItemCount_s64 and maxRegisterCount > toInt64(0, 1) then
      self._ui._selectItemCountBg:SetShow(true)
    else
      self._ui._selectItemCountBg:SetShow(false)
    end
  end
  if 1 > Int64toInt32(itemCount_s64) then
    self._ui._selectItemEnchantBg:SetShow(false)
  end
  self:computeControl()
  self:updateNeedTotalPrice()
  self._standardPrice_s64 = standardPrice_s64
  _panel:SetShow(true)
end
function PaGlobalFunc_MarketPlaceBuy_EnchantLevelPrice(enchantLevelPrice)
  local self = MarketPlaceBuy
  self._enchantLevelPrice = enchantLevelPrice
  self:updateNeedTotalPrice()
end
function FromClient_responseEnchantLevelPrice(enchantLevelPrice)
  if true == Panel_Window_MarketPlace_BuyManagement:IsShow() then
    PaGlobalFunc_MarketPlaceBuy_EnchantLevelPrice(enchantLevelPrice)
  else
    PaGlobalFunc_MarketPlaceSell_EnchantLevelPrice(enchantLevelPrice)
  end
end
function FromClient_responseBuyItemToWorldMarket(mySilver)
  local self = MarketPlaceBuy
  local silverInfo = getWorldMarketSilverInfo()
  self._ui._myGoldValue:SetText(makeDotMoney(silverInfo:getItemCount()))
  PaGlobalFunc_MarketPlace_UpdateMyInfo()
  PaGlobalFunc_ItemMarket_OnBuyComplete()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_MarketPlaceBuy_Initialize")
registerEvent("FromClient_responseGetBuyBiddingList", "FromClient_responseGetBuyBiddingList")
registerEvent("FromClient_responseEnchantLevelPrice", "FromClient_responseEnchantLevelPrice")
registerEvent("FromClient_responseBuyItemToWorldMarket", "FromClient_responseBuyItemToWorldMarket")

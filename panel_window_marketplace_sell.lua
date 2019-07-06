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
    _stc_LastTimeBg = UI.getChildControl(_panel, "Static_LastTimeBg"),
    _stc_LastPriceBg = UI.getChildControl(_panel, "Static_LastPriceBg"),
    _stc_TotalTradeBg = UI.getChildControl(_panel, "Static_TotalTradeBg"),
    _stc_DescBG = UI.getChildControl(_panel, "Static_DescBG"),
    _stc_SellDescBG = UI.getChildControl(_panel, "Static_SellDescBG"),
    _selectItemPriceBg = UI.getChildControl(_panel, "Static_SetPrice"),
    _selectItemCountBg = UI.getChildControl(_panel, "Static_SetCount"),
    _stc_WalletBg = UI.getChildControl(_panel, "Static_WalletBg"),
    _stc_TotalPriceBg = UI.getChildControl(_panel, "Static_TotalPriceBg"),
    _button_Sell = UI.getChildControl(_panel, "Button_InMarketRegist"),
    _stc_blockBG = UI.getChildControl(_panel, "Static_BlockBG"),
    _stc_rightBG = UI.getChildControl(_panel, "Static_RightBg"),
    stc_GraphBg = UI.getChildControl(_panel, "Static_GraphBg"),
    txt_hoverPrice = UI.getChildControl(_panel, "StaticText_HoverPrice")
  },
  _graph = {},
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
  _addSizeY = 0,
  _standardPrice_s64 = toInt64(0, 0),
  _isOpenThisPanel = false,
  _isMouseOver = false
}
function MarketPlaceSell:initialize()
  self:createControl()
  self:setSellDesc()
  self:graphControlInitialize()
end
function MarketPlaceSell:createControl()
  self._ui._itemWeight = UI.getChildControl(self._ui._stc_WeightBg, "StaticText_WeightValue")
  self._ui._itemPrice = UI.getChildControl(self._ui._stc_PriceBg, "StaticText_PriceValue")
  self._ui._itemCount = UI.getChildControl(self._ui._stc_CountBg, "StaticText_CountValue")
  self._ui._lastTime = UI.getChildControl(self._ui._stc_LastTimeBg, "StaticText_LastTimeValue")
  self._ui._lastPrice = UI.getChildControl(self._ui._stc_LastPriceBg, "StaticText_LastPriceValue")
  self._ui._totalTrade = UI.getChildControl(self._ui._stc_TotalTradeBg, "StaticText_TotalTradeValue")
  self._ui._selectItemCount = UI.getChildControl(self._ui._selectItemCountBg, "StaticText_CountValue")
  self._ui._selectItemPrice = UI.getChildControl(self._ui._selectItemPriceBg, "StaticText_PriceValue")
  self._ui.btn_itemCountPlus = UI.getChildControl(self._ui._selectItemCountBg, "Button_CountPlus")
  self._ui.btn_itemCountMinus = UI.getChildControl(self._ui._selectItemCountBg, "Button_CountMinus")
  self._ui.btn_maxPrice = UI.getChildControl(self._ui._selectItemPriceBg, "Button_MaxPrice")
  self._ui.btn_minPrice = UI.getChildControl(self._ui._selectItemPriceBg, "Button_MinPrice")
  self._ui._myGoldValue = UI.getChildControl(self._ui._stc_WalletBg, "StaticText_MyGoldValue")
  self._ui._weightValue = UI.getChildControl(self._ui._stc_WalletBg, "StaticText_WeightValue")
  self._ui._priceFormula = UI.getChildControl(self._ui._stc_TotalPriceBg, "StaticText_PriceFormula")
  self._ui._totalPrice = UI.getChildControl(self._ui._stc_TotalPriceBg, "StaticText_7")
  self._ui._selectItemCount:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceSell_SelectCount()")
  self._ui.btn_itemCountPlus:addInputEvent("Mouse_LUp", " HandleLClick_MarketPlace_SellCountButton(1, true)")
  self._ui.btn_itemCountMinus:addInputEvent("Mouse_LUp", " HandleLClick_MarketPlace_SellCountButton(1, false)")
  self._ui.btn_maxPrice:addInputEvent("Mouse_LUp", " HandleLClick_MarketPlace_SellCountButton(3,true)")
  self._ui.btn_minPrice:addInputEvent("Mouse_LUp", " HandleLClick_MarketPlace_SellCountButton(3,false)")
  self._ui._button_Sell:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceSell_Req()")
  self._ui._button_WinClose:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceSell_Cancel()")
  self._ui._txtDesc = UI.getChildControl(self._ui._stc_DescBG, "Static_Desc")
  self._ui._txtSellDesc = UI.getChildControl(self._ui._stc_SellDescBG, "Static_SellDesc")
  self._ui._txtSellDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txtSellDesc:SetText(self._ui._txtSellDesc:GetText())
  self._ui._stc_DescBG:SetShow(false)
  self._ui.txt_graphPanel = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_GraphPanel")
  self._ui.txt_unitPrice = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_UnitPrice")
  if self._ui._stc_SellDescBG:GetSizeY() < self._ui._txtSellDesc:GetTextSizeY() then
    self._addSizeY = self._ui._txtSellDesc:GetTextSizeY() - self._ui._stc_SellDescBG:GetSizeY() + 10
    self:addControlSizeY(self._addSizeY)
  end
  local slot = {}
  slot.background = self._ui._itemStatusBg
  SlotItem.new(slot, "ItemIcon", 0, slot.background, self._slotConfig)
  slot:createChild()
  slot.icon:SetShow(true)
  self._selectItemSlot = slot
  local isViewRecentInfo = true
  if false == isViewRecentInfo then
    self._ui._lastPriceTitle = UI.getChildControl(self._ui._stc_LastPriceBg, "StaticText_LastPriceTitle")
    self._ui._lastPriceTitle:SetShow(false)
    self._ui._lastPrice:SetShow(false)
    self._ui._lastTimeTitle = UI.getChildControl(self._ui._stc_LastTimeBg, "StaticText_LastTimetTitle")
    self._ui._lastTimeTitle:SetShow(false)
    self._ui._lastTime:SetShow(false)
    self._ui._totalTradeTitle = UI.getChildControl(self._ui._stc_TotalTradeBg, "StaticText_TotalTradeTitle")
    self._ui._totalTradeTitle:SetShow(false)
    self._ui._totalTrade:SetShow(false)
    self._ui._stc_WeightBg:SetSpanSize(self._ui._stc_TotalTradeBg:GetSpanSize().x, self._ui._stc_TotalTradeBg:GetSpanSize().y)
  end
  Panel_Window_MarketPlace_SellManagement:RegisterUpdateFunc("Update_MarketPlaceSell_HoverPrice")
end
function MarketPlaceSell:setSellDesc()
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    return
  end
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(regionInfoWrapper:getAffiliatedTownRegionKey())
  if nil == siegeWrapper then
    return
  end
  local isCountryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_GUIDETEXT2", "forPremium", requestGetRefundPercentForPremiumPackage())
  if isGameTypeJapan() then
    isCountryTypeSet = ""
  else
    isCountryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_GUIDETEXT2", "forPremium", requestGetRefundPercentForPremiumPackage())
  end
  local transferTaxRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  local taxText = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_GUIDETEXT", "feePercent", requestGetTradeFeePercent(), "transferTaxRate", transferTaxRate) .. isCountryTypeSet
  local prevDescSizeY = self._ui._txtSellDesc:GetTextSizeY()
  self._ui._txtSellDesc:SetText(taxText .. [[


]] .. self._ui._txtSellDesc:GetText())
  local increaseDescSizeY = self._ui._txtSellDesc:GetTextSizeY() - prevDescSizeY + 10
  self:addControlSizeY(increaseDescSizeY)
end
function MarketPlaceSell:graphControlInitialize()
  local txt_GraphPrice = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_Price")
  local stc_GraphPriceLine = UI.getChildControl(self._ui.stc_GraphBg, "Static_PriceLine")
  local txt_GraphDate = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_Date")
  self._graph.panel = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui.stc_GraphBg, "Graph_Panel")
  CopyBaseProperty(self._ui.txt_graphPanel, self._graph.panel)
  self._ui.txt_graphPanel:SetShow(false)
  self._graph.panel:SetGraphMode(true)
  self._graph.panel:addInputEvent("Mouse_On", "PaGlobal_MarketPlaceSell_HoverPrice(true)")
  self._graph.panel:addInputEvent("Mouse_Out", "PaGlobal_MarketPlaceSell_HoverPrice(false)")
  self._graph.panelSizeX = self._graph.panel:GetSizeX()
  self._graph.priceArray = {}
  local dataIntervalX = self._graph.panel:GetSizeX() / 3.2
  local priceIntervalY = (self._graph.panel:GetSizeY() + 20) / 4.5
  for i = 1, 5 do
    local tmpGraph = {
      txt_Price = nil,
      stc_PriceLine = nil,
      txt_Date = nil
    }
    tmpGraph.txt_Price = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui.stc_GraphBg, "StaticText_Price_" .. i)
    tmpGraph.stc_PriceLine = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_GraphBg, "Static_PriceLine_" .. i)
    tmpGraph.txt_Date = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui.stc_GraphBg, "StaticText_Date_" .. i)
    CopyBaseProperty(txt_GraphPrice, tmpGraph.txt_Price)
    CopyBaseProperty(stc_GraphPriceLine, tmpGraph.stc_PriceLine)
    CopyBaseProperty(txt_GraphDate, tmpGraph.txt_Date)
    tmpGraph.txt_Price:SetSpanSize(tmpGraph.txt_Price:GetSpanSize().x, tmpGraph.txt_Price:GetSpanSize().y + (i - 1) * priceIntervalY)
    tmpGraph.stc_PriceLine:SetSpanSize(tmpGraph.stc_PriceLine:GetSpanSize().x, tmpGraph.stc_PriceLine:GetSpanSize().y + (i - 1) * priceIntervalY)
    tmpGraph.txt_Date:SetSpanSize(tmpGraph.txt_Date:GetSpanSize().x + (i - 1) * dataIntervalX, tmpGraph.txt_Date:GetSpanSize().y)
    tmpGraph.txt_Price:SetShow(true)
    tmpGraph.stc_PriceLine:SetShow(true)
    tmpGraph.txt_Date:SetShow(true)
    tmpGraph.txt_Price:SetText(i)
    if 5 == i then
      tmpGraph.txt_Date:SetShow(false)
    end
    self._graph[i] = tmpGraph
  end
end
function MarketPlaceSell:updateNeedTotalPrice()
  local needTotalPrice = self._selectCount * (self._selectPriceInfo._price + self._enchantLevelPrice)
  self._ui._priceFormula:SetText("(" .. makeDotMoney(self._selectPriceInfo._price) .. " + " .. makeDotMoney(self._enchantLevelPrice) .. ") X " .. makeDotMoney(self._selectCount))
  self._ui._totalPrice:SetText(makeDotMoney(needTotalPrice))
end
function MarketPlaceSell:addControlSizeY(addSize)
  local listControl = UI.getChildControl(_panel, "List2_ItemList")
  _panel:SetSize(_panel:GetSizeX(), _panel:GetSizeY() + addSize)
  self._ui._stc_SellDescBG:SetSize(self._ui._stc_SellDescBG:GetSizeX(), self._ui._stc_SellDescBG:GetSizeY() + addSize)
  self._ui._stc_rightBG:SetSize(self._ui._stc_rightBG:GetSizeX(), self._ui._stc_rightBG:GetSizeY() + addSize)
  self._ui._button_Sell:SetSpanSize(self._ui._button_Sell:GetSpanSize().x, self._ui._button_Sell:GetSpanSize().y + addSize)
  listControl:SetSize(listControl:GetSizeX(), listControl:GetSizeY() + addSize)
  _panel:ComputePos()
  self._ui._txtSellDesc:ComputePos()
  self._ui._stc_SellDescBG:ComputePos()
  self._ui._button_Sell:ComputePos()
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
function sellTest()
  MarketPlaceSell:setPanelSize()
end
function MarketPlaceSell:setPanelSize()
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
  local lastPrice_s64 = systemItemInfo:getLastTradePrice()
  local lastTime_utc = systemItemInfo:getLastTradeTime()
  local totalCount_s64 = systemItemInfo:getTotalTradeCount()
  local minPrice = systemItemInfo:getBiddingMinPrice()
  local maxPrice = systemItemInfo:getBiddingMaxPrice()
  if true == PaGlobal_QAItemMarketFunctionFlag then
    PaGlobalFunc_ItemMarketSellTestDetail(itemKey, enchantLevel, enchantMinLevel, standardPrice_s64, itemCount_s64, isSealed, biddingSellListCount)
  else
    MarketPlaceSell:open(itemKey, enchantLevel, enchantMinLevel, standardPrice_s64, itemCount_s64, isSealed, biddingSellListCount, lastPrice_s64, lastTime_utc, totalCount_s64, minPrice, maxPrice)
  end
end
function MarketPlaceSell:open(itemKey, enchantLevel, enchantMinLevel, standardPrice_s64, itemCount_s64, isSealed, biddingSellListCount, lastPrice_s64, lastTime_utc, totalCount_s64, minPrice, maxPrice)
  tempItemEnchantKey = ItemEnchantKey(itemKey, enchantLevel)
  local itemSSW = getItemEnchantStaticStatus(tempItemEnchantKey)
  if true == PaGlobal_TutorialPhase_IsTutorial() then
    itemSSW = PaGlobal_TutorialPhase_MarketPlace_GetItemSSW()
    itemKey = itemSSW:get()._key
  end
  if nil == itemSSW then
    return
  end
  PaGlobal_MarketPlacePriceList_ChangePanel(true)
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
  local itemIcon = UI.getChildControl(self._ui._itemStatusBg, "Static_ItemIcon")
  itemIcon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlaceSell_ShowToolTip( " .. self._itemKey .. ", " .. enchantLevel .. " )")
  itemIcon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
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
  local _lastTime_ts, _lastPrice, _totalTrade
  if nil == lastPrice_s64 or lastPrice_s64 <= toInt64(0, 0) then
    _lastPrice = "-"
  else
    _lastPrice = makeDotMoney(lastPrice_s64)
  end
  if nil == lastTime_utc or lastTime_utc <= toInt64(0, 0) then
    _lastTime_ts = "-"
  else
    _lastTime_ts = os.date("%m-%d %H:%M", Int64toInt32(lastTime_utc))
  end
  if nil == totalCount_s64 or totalCount_s64 < toInt64(0, 0) then
    _totalTrade = "-"
  else
    _totalTrade = makeDotMoney(totalCount_s64)
  end
  self._ui._lastTime:SetText(tostring(_lastTime_ts))
  self._ui._lastPrice:SetText(tostring(_lastPrice))
  self._ui._totalTrade:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WINDOW_MARKETPLACE_TOTALTRADECOUNT_SUB", "count", tostring(_totalTrade)))
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
  self._isOpenThisPanel = true
  self:setPanelSize()
  self._ui._stc_blockBG:SetSize(getScreenSizeX() + 500, getScreenSizeY() + 500)
  self._ui._stc_blockBG:ComputePos()
  self:updateNeedTotalPrice()
  self._standardPrice_s64 = standardPrice_s64
  PaGlobalFunc_MarketPlacePriceList_Open(standardPrice_s64, minPrice, maxPrice, true)
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
  PaGlobal_MarketPlaceSelectList_SetFocus(index)
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
    if false == isPremiumUser and false == itemSSW:get():isCash() then
      messageBoxMemo = messageBoxMemo .. [[


]] .. isCountryTypeSet
    end
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = sellExcute,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
  checkbox_sell()
end
function PaGlobal_MarketPlaceSell_Tooltip()
  local self = MarketPlaceSell
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._itemKey, self._itemLevel))
  PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.Item, 0, getScreenSizeX())
end
function PaGlobal_MarketPlaceSell_Cancel()
  Panel_Tooltip_Item_hideTooltip()
  Panel_NumberPad_Close()
  PaGlobal_MarketPlaceSelectList_Cancel()
  PaGlobal_MarketPlacePriceList_Cancel()
  _panel:SetShow(false)
  MarketPlaceSell._isOpenThisPanel = false
end
function PaGlobalFunc_MarketPlaceSell_EnchantLevelPrice(enchantLevelPrice)
  local self = MarketPlaceSell
  self._enchantLevelPrice = enchantLevelPrice
  self:updateNeedTotalPrice()
end
function PaGlobalFunc_MarketPlaceSell_ShowToolTip(itemKey, selectEnchantLevel)
  local self = MarketPlaceSell
  local slot = UI.getChildControl(self._ui._itemStatusBg, "Static_ItemIcon")
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey, selectEnchantLevel))
  if nil == slot or nil == itemSSW then
    return
  end
  PaGlobalFunc_MarketPlace_ShowToolTip(itemSSW, slot, true)
end
function FromClient_responseSellItemToWorldMarket(mySilver)
  if true == PaGlobal_QAItemMarketFunctionFlag then
    PaGlobalFunc_ItemMarketTestEnd()
  end
  ToClient_requestMyBiddingListByWorldMarket()
  if nil == self then
    return
  end
  local self = MarketPlaceSell
  if nil == self._itemKey then
    return
  end
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._itemKey))
  if nil ~= itemSSW and true == itemSSW:get():isCash() then
    ToClient_requestMyWalletList()
    PaGlobalFunc_Wallet_UpdatePearlItemLimitCount()
  end
end
function PaGlobalFunc_MarketPlaceSell_GetPanel()
  return _panel
end
function HandleLClick_MarketPlace_SellCountButton(type, isPlus)
  local self = MarketPlaceSell
  local resultValue = 0
  if true == isPlus then
    resultValue = Int64toInt32(self._selectCount) + 1
  else
    resultValue = Int64toInt32(self._selectCount) - 1
  end
  if 1 == type then
    if resultValue > 0 and resultValue <= Int64toInt32(self._maxItemCount_s64) then
      PaGlobal_MarketPlaceSell_SetCount(toInt64(0, resultValue))
    end
  elseif 3 == type then
    local size = ToClient_GetBiddingListSize()
    if true == isPlus then
      PaGlobalFunc_MarketPlaceSell_SelectPriceByIndex(0)
      PaGlobal_MarketPlaceSelectList_ListMoveIndex(0)
    else
      PaGlobalFunc_MarketPlaceSell_SelectPriceByIndex(size - 1)
      PaGlobal_MarketPlaceSelectList_ListMoveIndex(size - 1)
    end
  end
end
function FromClient_MarketPlaceSell_responseMarketPriceInfo()
  local self = MarketPlaceSell
  if nil == self or false == self._isOpenThisPanel then
    return
  end
  self._graph.panel:ClearGraphList()
  local graphSize = ToClient_GetWorldMarketPriceGraphSize()
  local minPrice, maxPrice = PaGlobal_MarketPlace_PriceMinMax()
  local avgPrice = (minPrice + maxPrice) / 2
  local maxPricePercent = (maxPrice - avgPrice) / avgPrice
  local avgInterval = {
    maxPricePercent,
    maxPricePercent / 2,
    0,
    maxPricePercent / 2 * -1,
    maxPricePercent * -1
  }
  local dateIntervalX = self._graph.panelSizeX / 29
  local unitPriceString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPALCE_UNITPRICE", "price", makeDotMoney(ToClient_GetWorldMarketUnitPriceGraph()))
  if graphSize > 30 then
    graphSize = 30
  end
  self._ui.txt_unitPrice:SetText(unitPriceString)
  self._graph.panel:SetSize(dateIntervalX * (graphSize - 1), self._graph.panel:GetSizeY())
  self._graph.panel:ComputePos()
  for i = 1, 5 do
    self._graph[i].txt_Price:SetText(makeDotMoney(math.floor(avgPrice + avgPrice * avgInterval[i] + 0.5)))
    self._graph[6 - i].txt_Date:SetText(ToClient_GetWorldMarketBerforeDay((i - 2) * 10))
  end
  for i = 0, graphSize - 1 do
    local vector2_DrawPos = ToClient_GetWorldMarketPriceGraphPosAt(i)
    self._graph.priceArray[i] = vector2_DrawPos.y
    vector2_DrawPos.x = dateIntervalX * i
    vector2_DrawPos.y = (1 - (vector2_DrawPos.y - minPrice) / (maxPrice - minPrice)) * self._graph.panel:GetSizeY()
    self._graph.panel:AddGraphPos(vector2_DrawPos)
  end
  self._graph.panel:interpolationGraphLine()
  _panel:SetShow(true)
  PaGlobalFunc_MarketPlaceSell_SelectPriceByIndex(0)
  PaGlobalFunc_MarketPlacePriceList_SetDefaultIndex(true)
end
function PaGlobal_MarketPlaceSell_HoverPrice(isOn)
  local self = MarketPlaceSell
  if true == isOn then
    self._isMouseOver = true
    self._ui.txt_hoverPrice:SetShow(true)
    return
  else
    self._isMouseOver = false
    self._ui.txt_hoverPrice:SetShow(false)
    return
  end
end
function Update_MarketPlaceSell_HoverPrice(deltatime)
  local self = MarketPlaceSell
  local hoverControl = self._ui.txt_hoverPrice
  if false == self._isMouseOver then
    return
  end
  hoverControl:SetPosX(getMousePosX() - _panel:GetPosX() + 30)
  hoverControl:SetPosY(getMousePosY() - _panel:GetPosY())
  local dateIntervalX = self._graph.panelSizeX / 29
  local pricePosX = getMousePosX() - self._graph.panel:GetParentPosX()
  local currentIndex = math.floor(pricePosX / dateIntervalX + 0.5)
  hoverControl:SetText(makeDotMoney(self._graph.priceArray[currentIndex]))
end
function PaGlobal_MarketPlaceSell_TutorialOpen(itemKey, enchantLevel, enchantMinLevel, standardPrice_s64, itemCount_s64, isSealed, biddingSellListCount)
  if false == PaGlobal_TutorialPhase_IsTutorial() then
    return
  end
  local self = MarketPlaceSell
  local itemKey, itemSSW
  itemSSW = PaGlobal_TutorialPhase_MarketPlace_GetItemSSW()
  itemKey = PaGlobal_TutorialPhase_MarketPlace_GetItemSSW():get()._key
  if nil == itemSSW then
    return
  end
  PaGlobal_MarketPlacePriceList_ChangePanel(true)
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
  local itemIcon = UI.getChildControl(self._ui._itemStatusBg, "Static_ItemIcon")
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
  self._isOpenThisPanel = true
  self:setPanelSize()
  self._ui._stc_blockBG:SetSize(getScreenSizeX() + 500, getScreenSizeY() + 500)
  self._ui._stc_blockBG:ComputePos()
  self:updateNeedTotalPrice()
  self._standardPrice_s64 = standardPrice_s64
  Panel_Window_MarketPlace_SellManagement:SetShow(true)
  PaGlobalFunc_MarketPlacePriceList_Open(standardPrice_s64, 0, 0, true)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_MarketPlaceSell_Initialize")
registerEvent("FromClient_responseGetSellBiddingList", "FromClient_responseGetSellBiddingList")
registerEvent("FromClient_responseSellItemToWorldMarket", "FromClient_responseSellItemToWorldMarket")
registerEvent("FromClient_responseMarketPriceInfo", "FromClient_MarketPlaceSell_responseMarketPriceInfo")

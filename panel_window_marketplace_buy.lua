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
    _stc_CountBg = UI.getChildControl(_panel, "Static_CountBg"),
    _stc_LastTimeBg = UI.getChildControl(_panel, "Static_LastTimeBg"),
    _stc_LastPriceBg = UI.getChildControl(_panel, "Static_LastPriceBg"),
    _stc_TotalTradeBg = UI.getChildControl(_panel, "Static_TotalTradeBg"),
    _stc_Desc = UI.getChildControl(_panel, "StaticText_Desc"),
    _stc_BuyDescBG = UI.getChildControl(_panel, "Static_BuyDescBG"),
    _selectItemPriceBg = UI.getChildControl(_panel, "Static_SetPrice"),
    _selectItemCountBg = UI.getChildControl(_panel, "Static_SetCount"),
    _selectItemEnchantBg = UI.getChildControl(_panel, "Static_SetEnchant"),
    _stc_WalletBg = UI.getChildControl(_panel, "Static_WalletBg"),
    _stc_TotalPriceBg = UI.getChildControl(_panel, "Static_TotalPriceBg"),
    _button_Buy = UI.getChildControl(_panel, "Button_InMarketRegist"),
    _button_BuyInCashShop = UI.getChildControl(_panel, "Button_BuyInCashShop"),
    _stc_blockBG = UI.getChildControl(_panel, "Static_BlockBG"),
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
  _addSizeY = 0,
  _standardPrice_s64 = toInt64(0, 0),
  _isOpenThisPanel = false,
  _isMouseOver = false,
  _buyBiddingList = {
    _itemKey = 0,
    _minEnchantLevel = 0,
    _maxEnchantLevel = 0,
    _standardPrice_s64 = toInt64(0, 0),
    _itemCount_s64 = toInt64(0, 0),
    _biddingBuyListCount = 0,
    _lastPrice_s64 = toInt64(0, 0),
    _lastTime_utc = 0,
    _totalCount_s64 = toInt64(0, 0),
    _minPrice = 0,
    _maxPrice = 0
  }
}
function MarketPlaceBuy:initialize()
  self:createControl()
  self:graphControlInitialize()
end
function MarketPlaceBuy:createControl()
  self._ui._itemWeight = UI.getChildControl(self._ui._stc_WeightBg, "StaticText_WeightValue")
  self._ui._itemPrice = UI.getChildControl(self._ui._stc_PriceBg, "StaticText_PriceValue")
  self._ui._itemCount = UI.getChildControl(self._ui._stc_CountBg, "StaticText_CountValue")
  self._ui._lastTime = UI.getChildControl(self._ui._stc_LastTimeBg, "StaticText_LastTimeValue")
  self._ui._lastPrice = UI.getChildControl(self._ui._stc_LastPriceBg, "StaticText_LastPriceValue")
  self._ui._totalTrade = UI.getChildControl(self._ui._stc_TotalTradeBg, "StaticText_TotalTradeValue")
  self._ui._selectItemCount = UI.getChildControl(self._ui._selectItemCountBg, "StaticText_CountValue")
  self._ui._selectItemPrice = UI.getChildControl(self._ui._selectItemPriceBg, "StaticText_PriceValue")
  self._ui._selectItemEnchant = UI.getChildControl(self._ui._selectItemEnchantBg, "StaticText_EnchantValue")
  self._ui.btn_itemCountPlus = UI.getChildControl(self._ui._selectItemCountBg, "Button_CountPlus")
  self._ui.btn_itemCountMinus = UI.getChildControl(self._ui._selectItemCountBg, "Button_CountMinus")
  self._ui.btn_enchantCountPlus = UI.getChildControl(self._ui._selectItemEnchantBg, "Button_EnchantPlus")
  self._ui.btn_enchantCountMinus = UI.getChildControl(self._ui._selectItemEnchantBg, "Button_EnchantMinus")
  self._ui.btn_maxPrice = UI.getChildControl(self._ui._selectItemPriceBg, "Button_MaxPrice")
  self._ui.btn_minPrice = UI.getChildControl(self._ui._selectItemPriceBg, "Button_MinPrice")
  self._ui._myGoldValue = UI.getChildControl(self._ui._stc_WalletBg, "StaticText_MyGoldValue")
  self._ui._weightValue = UI.getChildControl(self._ui._stc_WalletBg, "StaticText_WeightValue")
  self._ui._priceFormula = UI.getChildControl(self._ui._stc_TotalPriceBg, "StaticText_PriceFormula")
  self._ui._totalPrice = UI.getChildControl(self._ui._stc_TotalPriceBg, "StaticText_7")
  self._ui._priceDesc = UI.getChildControl(self._ui._stc_TotalPriceBg, "StaticText_PriceDesc")
  self._ui._priceDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_BUY_DESC"))
  self._ui._afterBuyTitle = UI.getChildControl(self._ui._stc_TotalPriceBg, "StaticText_AfterBuyMoneyTitle")
  self._ui._afterBuyTitle:SetTextMode(__eTextMode_LimitText)
  self._ui._afterBuy = UI.getChildControl(self._ui._stc_TotalPriceBg, "StaticText_AfterBuyMoney")
  self._ui.txt_graphPanel = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_GraphPanel")
  self._ui.txt_unitPrice = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_UnitPrice")
  self._ui.stc_graphPanelBG = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_GraphPanelBG")
  self._ui._selectItemEnchant:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceBuy_OpenSelectList(2)")
  self._ui._selectItemCount:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceBuy_SelectCount()")
  self._ui.btn_itemCountPlus:addInputEvent("Mouse_LUp", " HandleLClick_MarketPlace_CountButton(1,true)")
  self._ui.btn_itemCountMinus:addInputEvent("Mouse_LUp", " HandleLClick_MarketPlace_CountButton(1,false)")
  self._ui.btn_enchantCountPlus:addInputEvent("Mouse_LUp", " HandleLClick_MarketPlace_CountButton(2,true)")
  self._ui.btn_enchantCountMinus:addInputEvent("Mouse_LUp", " HandleLClick_MarketPlace_CountButton(2,false)")
  self._ui.btn_maxPrice:addInputEvent("Mouse_LUp", " HandleLClick_MarketPlace_CountButton(3,true)")
  self._ui.btn_minPrice:addInputEvent("Mouse_LUp", " HandleLClick_MarketPlace_CountButton(3,false)")
  self._ui._button_Buy:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceBuy_Req()")
  self._ui._button_BuyInCashShop:addInputEvent("Mouse_LUp", "HandleEventLUp_MarketPlaceBuy_BuyProductInCashShopOpen()")
  self._ui._button_WinClose:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceBuy_Cancel()")
  self._ui._txtBuyDesc = UI.getChildControl(self._ui._stc_BuyDescBG, "Static_BuyDesc")
  self._ui._txtBuyDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txtBuyDesc:SetText(self._ui._txtBuyDesc:GetText())
  if self._ui._stc_BuyDescBG:GetSizeY() < self._ui._txtBuyDesc:GetTextSizeY() then
    self._addSizeY = self._ui._txtBuyDesc:GetTextSizeY() - self._ui._stc_BuyDescBG:GetSizeY() + 10
    self._ui._stc_BuyDescBG:SetSize(self._ui._stc_BuyDescBG:GetSizeX(), self._ui._stc_BuyDescBG:GetSizeY() + self._addSizeY)
    self._ui._txtBuyDesc:SetSize(self._ui._txtBuyDesc:GetSizeX(), self._ui._txtBuyDesc:GetSizeY() + self._addSizeY)
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
  Panel_Window_MarketPlace_BuyManagement:RegisterUpdateFunc("Update_MarketPlaceBuy_HoverPrice")
end
function MarketPlaceBuy:graphControlInitialize()
  local txt_GraphPrice = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_Price")
  local stc_GraphPriceLine = UI.getChildControl(self._ui.stc_GraphBg, "Static_PriceLine")
  local txt_GraphDate = UI.getChildControl(self._ui.stc_GraphBg, "StaticText_Date")
  self._graph.panel = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui.stc_GraphBg, "Graph_Panel")
  CopyBaseProperty(self._ui.txt_graphPanel, self._graph.panel)
  self._ui.txt_graphPanel:SetShow(false)
  self._graph.panel:SetGraphMode(true)
  self._graph.panel:addInputEvent("Mouse_On", "PaGlobal_MarketPlaceBuy_HoverPrice(true)")
  self._graph.panel:addInputEvent("Mouse_Out", "PaGlobal_MarketPlaceBuy_HoverPrice(false)")
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
function MarketPlaceBuyTest()
  MarketPlaceBuy:computeControl()
end
local graphTest = {}
function PaLocal_MarketPlace_GraphTest(input)
  if 1 == input then
    for i = 1, 10 do
      graphTest[i] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, _panel, "StaticText_TestPoint_" .. i)
      graphTest[i]:SetText("0")
      graphTest[i]:SetSize(graphTest[i]:GetTextSizeX(), graphTest[i]:GetTextSizeY())
      graphTest[i]:SetPosX(0)
      graphTest[i]:SetPosY(0)
      graphTest[i]:SetShow(true)
    end
  elseif 2 == input then
    for i = 1, 10 do
      graphTest[i]:SetPosX(MarketPlaceBuy._ui.stc_GraphBg:GetParentPosX() + 120 - _panel:GetPosX())
      graphTest[i]:SetPosY(MarketPlaceBuy._ui.stc_GraphBg:GetParentPosY() - _panel:GetPosY())
      graphTest[i]:SetShow(true)
    end
  elseif 3 == input then
    for i = 1, 10 do
      graphTest[i]:SetShow(false)
    end
  end
end
function MarketPlaceBuy:computeControl()
  _panel:SetSize(_panel:GetSizeX(), _panel:GetSizeY())
  self._ui._button_Buy:ComputePos()
  local bottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  bottomBg:ComputePos()
end
function MarketPlaceBuy:updateNeedTotalPrice()
  local silverInfo = getWorldMarketSilverInfo()
  local needTotalPrice = self._selectCount * (self._selectPriceInfo._price + self._enchantLevelPrice)
  local afterBuyMoneyValue = silverInfo:getItemCount() - needTotalPrice
  self._ui._priceFormula:SetText("(" .. makeDotMoney(self._selectPriceInfo._price) .. " + " .. makeDotMoney(self._enchantLevelPrice) .. ") X " .. makeDotMoney(self._selectCount))
  self._ui._totalPrice:SetText(makeDotMoney(needTotalPrice))
  if needTotalPrice > silverInfo:getItemCount() then
    self._ui._afterBuy:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_BUY_IMPOSSIBLEBUY"))
  else
    self._ui._afterBuy:SetText(makeDotMoney(afterBuyMoneyValue))
  end
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
  ToClient_requestBuyItemToWorldMarket(self._itemKey, self._itemMinLevel, self._selectCount, self._selectPriceInfo._price, self._selectEnchantLevel)
  MarketPlaceBuy._ui._button_Buy:ClearDisableTime()
  MarketPlaceBuy._ui._button_Buy:SetAutoDisableTime(1.5)
  MarketPlaceBuy._ui._button_Buy:DoAutoDisableTime()
  if true == PaGlobalFunc_SubWallet_IsShow() then
    PaGlobalFunc_SubWallet_Close()
  end
end
function PaGlobal_MarketPlaceBuy_Tooltip()
  local self = MarketPlaceBuy
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._itemKey, self._selectEnchantLevel))
  PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.Item, 0, getScreenSizeX())
end
function PaGlobal_MarketPlaceBuy_Cancel()
  Panel_NumberPad_Close()
  PaGlobal_MarketPlaceSelectList_Cancel()
  PaGlobal_MarketPlacePriceList_Cancel()
  Panel_Tooltip_Item_hideTooltip()
  MarketPlaceBuy._isOpenThisPanel = false
  _panel:SetShow(false)
  if nil ~= PaGlobal_MarKetPlace_BuyProductInCashShop_GetShow and true == PaGlobal_MarKetPlace_BuyProductInCashShop_GetShow() then
    PaGlobal_MarKetPlace_BuyProductInCashShop_Close()
  end
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
  local itemIcon = UI.getChildControl(self._ui._itemStatusBg, "Static_ItemIcon")
  itemIcon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlaceBuy_ShowToolTip( " .. self._itemKey .. ", " .. self._selectEnchantLevel .. " )")
  itemIcon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
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
  PaGlobal_MarketPlaceSelectList_SetFocus(index)
  PaGlobalFunc_MarketPlaceBuy_SelectPrice(index, price_s64)
  PaGlobal_MarketPlaceSelectList_Cancel()
end
function PaGlobalFunc_MarketPlaceBuy_SelectPrice(index, itemPrice)
  local self = MarketPlaceBuy
  self._ui._selectItemPrice:SetText(makeDotMoney(itemPrice))
  local prevSelectPriceIndex = self._selectPriceInfo._index
  self._selectPriceInfo._index = index
  self._selectPriceInfo._price = itemPrice
  self:updateEnchantBg()
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
  local lastPrice_s64 = systemItemInfo:getLastTradePrice()
  local lastTime_utc = systemItemInfo:getLastTradeTime()
  local totalCount_s64 = systemItemInfo:getTotalTradeCount()
  local minPrice = systemItemInfo:getBiddingMinPrice()
  local maxPrice = systemItemInfo:getBiddingMaxPrice()
  if true == PaGlobal_QAItemMarketFunctionFlag then
    PaGlobalFunc_ItemMarketBuyTestDetail(itemKey, minEnchantLevel, maxEnchantLevel, standardPrice_s64, itemCount_s64, biddingBuyListCount)
  else
    MarketPlaceBuy._buyBiddingList._itemKey = itemKey
    MarketPlaceBuy._buyBiddingList._minEnchantLevel = minEnchantLevel
    MarketPlaceBuy._buyBiddingList._maxEnchantLevel = maxEnchantLevel
    MarketPlaceBuy._buyBiddingList._standardPrice_s64 = standardPrice_s64
    MarketPlaceBuy._buyBiddingList._itemCount_s64 = itemCount_s64
    MarketPlaceBuy._buyBiddingList._biddingBuyListCount = biddingBuyListCount
    MarketPlaceBuy._buyBiddingList._lastPrice_s64 = lastPrice_s64
    MarketPlaceBuy._buyBiddingList._lastTime_utc = lastTime_utc
    MarketPlaceBuy._buyBiddingList._totalCount_s64 = totalCount_s64
    MarketPlaceBuy._buyBiddingList._minPrice = minPrice
    MarketPlaceBuy._buyBiddingList._maxPrice = maxPrice
    MarketPlaceBuy:open(itemKey, minEnchantLevel, maxEnchantLevel, standardPrice_s64, itemCount_s64, biddingBuyListCount, lastPrice_s64, lastTime_utc, totalCount_s64, minPrice, maxPrice)
  end
end
function MarketPlaceBuy:open(itemKey, minEnchantLevel, maxEnchantLevel, standardPrice_s64, itemCount_s64, biddingBuyListCount, lastPrice_s64, lastTime_utc, totalCount_s64, minPrice, maxPrice)
  if false == MarketPlaceBuy:initData(itemKey, minEnchantLevel, maxEnchantLevel, standardPrice_s64, itemCount_s64, biddingBuyListCount, lastPrice_s64, lastTime_utc, totalCount_s64, minPrice, maxPrice, true) then
    return
  end
  MarketPlaceBuy:resetData()
  PaGlobal_MarketPlacePriceList_ChangePanel(false)
  PaGlobalFunc_MarketPlacePriceList_Open(standardPrice_s64, minPrice, maxPrice, false)
end
function MarketPlaceBuy:initData(itemKey, minEnchantLevel, maxEnchantLevel, standardPrice_s64, itemCount_s64, biddingBuyListCount, lastPrice_s64, lastTime_utc, totalCount_s64, minPrice, maxPrice, isInit)
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey, minEnchantLevel))
  if nil == itemSSW then
    return false
  end
  local nameColorGrade = itemSSW:getGradeType()
  local enchantLevel = itemSSW:get()._key:getEnchantLevel()
  self._selectItemSlot:setItemByStaticStatus(itemSSW)
  self._itemKey = itemKey
  self._itemMinLevel = minEnchantLevel
  self._itemMaxLevel = maxEnchantLevel
  self._biddingBuyListCount = biddingBuyListCount - 1
  self._enchantLevelPrice = toInt64(0, 0)
  local itemIcon = UI.getChildControl(self._ui._itemStatusBg, "Static_ItemIcon")
  itemIcon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlaceBuy_ShowToolTip( " .. self._itemKey .. ", " .. enchantLevel .. " )")
  itemIcon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
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
  self._registitemCount = makeDotMoney(itemCount_s64)
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
  if true == isInit then
    PaGlobalFunc_MarketPlaceBuy_SelectPrice(biddingBuyListCount - 1, standardPrice_s64)
  end
  PaGlobal_MarketPlaceBuy_SetCount(toInt64(0, 1))
  local isGroupLevel = minEnchantLevel ~= maxEnchantLevel
  self._ui._selectItemEnchantBg:SetEnable(true)
  if false == isGroupLevel then
    self._ui._selectItemEnchantBg:SetEnable(false)
  end
  PaGlobalFunc_MarketPlaceBuy_SelectEnchantLevel(minEnchantLevel, isGroupLevel)
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
  self:computeControl()
  self._ui._stc_blockBG:SetSize(getScreenSizeX() + 500, getScreenSizeY() + 500)
  self._ui._stc_blockBG:ComputePos()
  self:updateNeedTotalPrice()
  self._isOpenThisPanel = true
  self._standardPrice_s64 = standardPrice_s64
  if nil ~= PaGlobal_MarKetPlace_BuyProductInCashShopIsCheck then
    self._ui._button_BuyInCashShop:SetShow(PaGlobal_MarKetPlace_BuyProductInCashShopIsCheck(self._itemKey))
  else
    self._ui._button_BuyInCashShop:SetShow(false)
  end
  return true
end
function MarketPlaceBuy:resetData()
  local itemKey = MarketPlaceBuy._buyBiddingList._itemKey
  local minEnchantLevel = MarketPlaceBuy._buyBiddingList._minEnchantLevel
  local maxEnchantLevel = MarketPlaceBuy._buyBiddingList._maxEnchantLevel
  local standardPrice_s64 = MarketPlaceBuy._buyBiddingList._standardPrice_s64
  local itemCount_s64 = MarketPlaceBuy._buyBiddingList._itemCount_s64
  local biddingBuyListCount = MarketPlaceBuy._buyBiddingList._biddingBuyListCount
  local lastTime_utc = MarketPlaceBuy._buyBiddingList._lastTime_utc
  local lastPrice_s64 = MarketPlaceBuy._buyBiddingList._lastPrice_s64
  local totalCount_s64 = MarketPlaceBuy._buyBiddingList._totalCount_s64
  local minPrice = MarketPlaceBuy._buyBiddingList._minPrice
  local maxPrice = MarketPlaceBuy._buyBiddingList._maxPrice
  MarketPlaceBuy:initData(itemKey, minEnchantLevel, maxEnchantLevel, standardPrice_s64, itemCount_s64, biddingBuyListCount, lastPrice_s64, lastTime_utc, totalCount_s64, minPrice, maxPrice, false)
end
function MarketPlaceBuy:updateEnchantBg()
  if 0 == MarketPlaceBuy._itemMinLevel and 0 == MarketPlaceBuy._itemMaxLevel or MarketPlaceBuy._itemMaxLevel == MarketPlaceBuy._itemMinLevel then
    if true == MarketPlaceBuy._ui._selectItemEnchantBg:GetShow() then
      MarketPlaceBuy._ui._selectItemEnchantBg:SetShow(false)
      PaGlobalFunc_MarketPlaceBuy_SelectEnchantLevel(MarketPlaceBuy._itemMinLevel, true)
      MarketPlaceBuy:resetData()
    end
    return
  end
  local biddingInfo = ToClient_GetBiddingInfoByIndex(MarketPlaceBuy._selectPriceInfo._index)
  local sellCount = Int64toInt32(biddingInfo:getSellCount())
  if sellCount < 1 then
    if true == MarketPlaceBuy._ui._selectItemEnchantBg:GetShow() then
      MarketPlaceBuy._ui._selectItemEnchantBg:SetShow(false)
      PaGlobalFunc_MarketPlaceBuy_SelectEnchantLevel(MarketPlaceBuy._itemMinLevel, true)
      MarketPlaceBuy:resetData()
    end
    return
  end
  MarketPlaceBuy._ui._selectItemEnchantBg:SetShow(true)
end
function PaGlobalFunc_MarketPlaceBuy_EnchantLevelPrice(enchantLevelPrice)
  local self = MarketPlaceBuy
  self._enchantLevelPrice = enchantLevelPrice
  self:updateNeedTotalPrice()
end
function PaGlobalFunc_MarketPlaceBuy_ShowToolTip(itemKey, selectEnchantLevel)
  local self = MarketPlaceBuy
  local slot = UI.getChildControl(self._ui._itemStatusBg, "Static_ItemIcon")
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey, selectEnchantLevel))
  if nil == slot or nil == itemSSW then
    return
  end
  PaGlobalFunc_MarketPlace_ShowToolTip(itemSSW, slot, true)
end
function FromClient_responseEnchantLevelPrice(enchantLevelPrice)
  if true == Panel_Window_MarketPlace_BuyManagement:IsShow() then
    PaGlobalFunc_MarketPlaceBuy_EnchantLevelPrice(enchantLevelPrice)
  else
    PaGlobalFunc_MarketPlaceSell_EnchantLevelPrice(enchantLevelPrice)
  end
end
function FromClient_responseBuyItemToWorldMarket(mySilver)
  if true == PaGlobal_QAItemMarketFunctionFlag then
    PaGlobalFunc_ItemMarketTestEnd()
    return
  end
  local self = MarketPlaceBuy
  local silverInfo = getWorldMarketSilverInfo()
  self._ui._myGoldValue:SetText(makeDotMoney(silverInfo:getItemCount()))
  PaGlobalFunc_MarketPlace_UpdateMyInfo()
  PaGlobalFunc_ItemMarket_OnBuyComplete()
  ToClient_requestGetBiddingList(ItemEnchantKey(self._itemKey, self._selectEnchantLevel), true, PaGlobalFunc_ItemMarket_isHotCategory())
end
function PaGlobalFunc_MarketPlaceBuy_GetPanel()
  return _panel
end
function PaGlobalFunc_MarketPlaceBuy_SetItemCount(count)
  local self = MarketPlaceBuy
  self._ui._itemCount:SetText(makeDotMoney(count))
end
function HandleLClick_MarketPlace_CountButton(type, isPlus)
  local self = MarketPlaceBuy
  local changeValue = 0
  local resultValue = 0
  if true == isPlus then
    changeValue = 1
  else
    changeValue = -1
  end
  if 1 == type then
    resultValue = Int64toInt32(self._selectCount) + changeValue
    if resultValue > 0 and resultValue <= Int64toInt32(self._maxItemCount_s64) then
      PaGlobal_MarketPlaceBuy_SetCount(toInt64(0, resultValue))
    end
  elseif 2 == type then
    resultValue = Int64toInt32(self._selectEnchantLevel) + changeValue
    if resultValue >= self._itemMinLevel and resultValue <= self._itemMaxLevel then
      PaGlobalFunc_MarketPlaceBuy_SelectEnchantLevel(resultValue, true)
    end
  elseif 3 == type then
    local size = ToClient_GetBiddingListSize()
    if 1 == changeValue then
      PaGlobalFunc_MarketPlaceBuy_SelectPriceByIndex(0)
      PaGlobal_MarketPlaceSelectList_ListMoveIndex(0)
    else
      PaGlobalFunc_MarketPlaceBuy_SelectPriceByIndex(size - 1)
      PaGlobal_MarketPlaceSelectList_ListMoveIndex(size - 1)
    end
  end
end
function HandleEventLUp_MarketPlaceBuy_BuyProductInCashShopOpen()
  if nil == MarketPlaceBuy or false == MarketPlaceBuy._isOpenThisPanel then
    return
  end
  PaGlobal_MarKetPlace_BuyProductInCashShop_Open(MarketPlaceBuy._itemKey)
end
function FromClient_MarketPlaceBuy_responseMarketPriceInfo()
  local self = MarketPlaceBuy
  if nil == self or false == MarketPlaceBuy._isOpenThisPanel then
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
  PaGlobalFunc_MarketPlaceBuy_SelectPriceByIndex(0)
  PaGlobalFunc_MarketPlacePriceList_SetDefaultIndex(false)
end
function PaGlobal_MarketPlace_PriceMinMax()
  local priceList = {}
  local graphSize = ToClient_GetWorldMarketPriceGraphSize()
  local avg = 0
  for i = 0, graphSize - 1 do
    local priceStruct = ToClient_GetWorldMarketPriceGraphPosAt(i)
    local price = math.ceil(priceStruct.y)
    table.insert(priceList, price)
  end
  table.sort(priceList)
  if priceList[1] == priceList[graphSize] then
    avg = priceList[1] / 2
  else
    avg = priceList[graphSize] - (priceList[1] + priceList[graphSize]) / 2
  end
  local minPrice = priceList[1] - avg * 0.1
  local maxPrice = priceList[graphSize] + avg * 0.1
  if minPrice < 0 then
    minPrice = 0
  end
  return minPrice, maxPrice
end
function PaGlobal_MarketPlaceBuy_HoverPrice(isOn)
  local self = MarketPlaceBuy
  if true == isOn then
    self._isMouseOver = true
    return
  else
    self._isMouseOver = false
    return
  end
end
function Update_MarketPlaceBuy_HoverPrice(deltatime)
  local self = MarketPlaceBuy
  local hoverControl = self._ui.txt_hoverPrice
  if false == self._isMouseOver then
    self._ui.txt_hoverPrice:SetShow(false)
    return
  end
  local dateIntervalX = self._graph.panelSizeX / 29
  local pricePosX = getMousePosX() - self._graph.panel:GetParentPosX()
  local currentIndex = math.floor(pricePosX / dateIntervalX + 0.5)
  if self._graph.priceArray and nil == self._graph.priceArray[currentIndex] then
    self._ui.txt_hoverPrice:SetShow(false)
    return
  end
  self._ui.txt_hoverPrice:SetShow(true)
  hoverControl:SetPosX(getMousePosX() - _panel:GetPosX() + 30)
  hoverControl:SetPosY(getMousePosY() - _panel:GetPosY())
  hoverControl:SetText(makeDotMoney(self._graph.priceArray[currentIndex]))
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_MarketPlaceBuy_Initialize")
registerEvent("FromClient_responseGetBuyBiddingList", "FromClient_responseGetBuyBiddingList")
registerEvent("FromClient_responseEnchantLevelPrice", "FromClient_responseEnchantLevelPrice")
registerEvent("FromClient_responseBuyItemToWorldMarket", "FromClient_responseBuyItemToWorldMarket")
registerEvent("FromClient_responseMarketPriceInfo", "FromClient_MarketPlaceBuy_responseMarketPriceInfo")

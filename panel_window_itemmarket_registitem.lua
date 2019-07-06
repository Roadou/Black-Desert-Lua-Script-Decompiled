local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
Panel_Window_ItemMarket_RegistItem:SetShow(false)
Panel_Window_ItemMarket_RegistItem:setGlassBackground(false)
Panel_Window_ItemMarket_RegistItem:ActiveMouseEventEffect(false)
local ItemMarketRegistItem = {
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true
  },
  btn_Close = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Button_Win_Close"),
  btn_Cancle = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Button_Cancle"),
  btn_Confirm = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Button_Confirm"),
  slotBG = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Static_SlotBG"),
  itemName = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "StaticText_ItemName"),
  priceEdit = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Edit_SellPrice"),
  btn_MinPrice = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Button_MinPrice"),
  btn_MaxPrice = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Button_MaxPrice"),
  btn_CheckPrice = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Button_CheckSum"),
  SellSumPrice = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "StaticText_SellSumPriceValue"),
  sellItemTitle = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "StaticText_SubTitle1"),
  averagePriceIcon = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Static_AveragePrice_TitleIcon"),
  recentPriceIcon = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Static_RecentPrice_TitleIcon"),
  maxPriceIcon = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Static_MaxPrice_TitleIcon"),
  minPriceIcon = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Static_MinPrice_TitleIcon"),
  registHighPriceIcon = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Static_RegistHighPrice_TitleIcon"),
  registLowPriceIcon = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Static_RegistLowPrice_TitleIcon"),
  registListCountIcon = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Static_RegistListCount_TitleIcon"),
  registItemCountIcon = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Static_RegistItemCount_TitleIcon"),
  guideText = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "StaticText_GuideText"),
  titleText = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "StaticText_Title"),
  averagePrice_Value = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "StaticText_AveragePrice_Value"),
  recentPrice_Value = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "StaticText_RecentPrice_Value"),
  max_Value = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "StaticText_Max_Value"),
  minPrice_Value = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "StaticText_MinPrice_Value"),
  registHighPrice_Value = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "StaticText_RegistHighPrice_Value"),
  registLowPrice_Value = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "StaticText_RegistLowPrice_Value"),
  registListCount_Value = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "StaticText_RegistListCount_Value"),
  registItemCount_Value = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "StaticText_RegistItemCount_Value"),
  _buttonQuestion = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Button_Question"),
  _buttonPassword = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Button_Pass"),
  _staticTextPassword = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "StaticText_PassState"),
  _Bottom_BG = UI.getChildControl(Panel_Window_ItemMarket_RegistItem, "Static_HelpBG"),
  itemSlot = {},
  _invenWhereType = 0,
  _invenSlotNo = 0,
  _registerCount = 0,
  _waypointKey = 0,
  _minPrice = 0,
  _maxPrice = 0,
  _isByMaid = false,
  _priceCheck = false,
  _isAblePearlProduct = false,
  _lastRegistPrice = {},
  _itemKey = nil,
  _password = 0
}
local territoryKey = {
  [0] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_0")),
  [1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_1")),
  [2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_2")),
  [3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_3")),
  [4] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_4")),
  [5] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_5")),
  [6] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_6")),
  [7] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_7"))
}
function ItemMarketRegistItem:Initialize()
  self.priceEdit:SetNumberMode()
  self.priceEdit:SetMaxInput(13)
  self._txt_RegistItemCount = UI.getChildControl(self._Bottom_BG, "StaticText_RegistItemCount_Help")
  self._txt_RegistHighPrice = UI.getChildControl(self._Bottom_BG, "StaticText_RegistHighPrice_Help")
  self._txt_RegistLowPrice = UI.getChildControl(self._Bottom_BG, "StaticText_RegistLowPrice_Help")
  self._txt_RegistListCount = UI.getChildControl(self._Bottom_BG, "StaticText_RegistListCount_Help")
  self._txt_MaxPrice = UI.getChildControl(self._Bottom_BG, "StaticText_MaxPrice_Help")
  self._txt_MinPrice = UI.getChildControl(self._Bottom_BG, "StaticText_MinPrice_Help")
  self._txt_RegistItemCount:SetMonoTone(true)
  self._txt_RegistHighPrice:SetMonoTone(true)
  self._txt_RegistLowPrice:SetMonoTone(true)
  self._txt_RegistListCount:SetMonoTone(true)
  self._txt_MaxPrice:SetMonoTone(true)
  self._txt_MinPrice:SetMonoTone(true)
  SlotItem.new(self.itemSlot, "ItemMarketRegistItem_Icon", 0, self.slotBG, self.slotConfig)
  self.itemSlot:createChild()
  self._isAblePearlProduct = requestCanRegisterPearlItemOnMarket()
end
function ItemMarketRegistItem:SetPostion()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_Window_ItemMarket_RegistItem:GetSizeX()
  local panelSizeY = Panel_Window_ItemMarket_RegistItem:GetSizeY()
  Panel_Window_ItemMarket_RegistItem:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Panel_Window_ItemMarket_RegistItem:SetPosY(scrSizeY / 2 - panelSizeY / 2)
end
function ItemMarketRegistItem:Clear()
  local self = ItemMarketRegistItem
  local emptyText
  emptyText = ""
  self.priceEdit:SetEditText(emptyText, true)
  self.priceEdit:SetNumberMode(true)
  self.averagePrice_Value:SetText("0")
  self.recentPrice_Value:SetText("0")
  self.max_Value:SetText("0")
  self.minPrice_Value:SetText("0")
  self.registHighPrice_Value:SetText("0")
  self.registLowPrice_Value:SetText("0")
  self.registListCount_Value:SetText("0")
  self.registItemCount_Value:SetText("0")
  self.SellSumPrice:SetText("")
  self._invenWhereType = -1
  self._invenSlotNo = -1
  self._waypointKey = 0
end
function ItemMarketRegistItem:getTargetItem()
  if self._invenWhereType < 0 or 0 > self._invenSlotNo then
    return
  end
  if CppEnums.ItemWhereType.eInventory == self._invenWhereType or CppEnums.ItemWhereType.eCashInventory == self._invenWhereType then
    return getInventoryItemByType(self._invenWhereType, self._invenSlotNo)
  elseif CppEnums.ItemWhereType.eWarehouse == self._invenWhereType then
    if 0 >= self._waypointKey then
      return
    end
    local warehouseWrapper = warehouse_get(self._waypointKey)
    return warehouseWrapper:getItem(self._invenSlotNo)
  end
end
function PaGlobal_ItemmarketRegistItem_Update()
  if not Panel_Window_ItemMarket_RegistItem:GetShow() then
    return
  end
  local self = ItemMarketRegistItem
  local registedItemCount = getItemMarketMyItemsCount()
  self.sellItemTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ENABLE_REGISTCOUNT", "itemCount", 30 - registedItemCount))
end
function ItemMarketRegistItem:Update()
  local self = ItemMarketRegistItem
  local registedItemCount = getItemMarketMyItemsCount()
  self.sellItemTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ENABLE_REGISTCOUNT", "itemCount", 30 - registedItemCount))
  local itemWrapper = self:getTargetItem()
  if not itemWrapper then
    _PA_ASSERT(false, "itemWrapper \236\151\134\236\138\181\235\139\136\235\139\164. \235\185\132\236\160\149\236\131\129\236\158\133\235\139\136\235\139\164.")
    return
  end
  local itemSS = itemWrapper:getStaticStatus()
  local itemKey = itemSS:get()._key:get()
  local summaryInfo = getItemMarketSummaryInClientByItemEnchantKey(itemSS:get()._key:get())
  local masterInfo = getItemMarketMasterByItemEnchantKey(itemSS:get()._key:get())
  if nil == summaryInfo or nil == masterInfo then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_NOREGISTITEM_ACK"))
    return
  end
  local registHighPrice = summaryInfo:getDisplayedHighestOnePrice()
  local registLowPrice = summaryInfo:getDisplayedLowestOnePrice()
  local marketConditions = (masterInfo:getMinPrice() + masterInfo:getMaxPrice()) / toInt64(0, 2)
  local recentPrice = summaryInfo:getLastTradedOnePrice()
  local registListCount = summaryInfo:getTradedTotalAmount()
  local registItemCount = summaryInfo:getDisplayedTotalAmount()
  local itemMaxPrice = masterInfo:getMaxPrice()
  local itemMinPrice = masterInfo:getMinPrice()
  self._minPrice = masterInfo:getMinPrice()
  self._maxPrice = masterInfo:getMaxPrice()
  self.itemSlot.icon:addInputEvent("Mouse_On", "_ItemMarketRegistItem_ShowToolTip( " .. self._invenSlotNo .. ", " .. self._invenWhereType .. " )")
  self.itemSlot.icon:addInputEvent("Mouse_Out", "_ItemMarketRegistItem_HideToolTip()")
  local replaceCount = function(num)
    local count = Int64toInt32(num)
    if 0 == count then
      count = "-"
    else
      count = makeDotMoney(num)
    end
    return count
  end
  self._itemKey = itemKey
  self.registHighPrice_Value:SetText(replaceCount(registHighPrice))
  self.registLowPrice_Value:SetText(replaceCount(registLowPrice))
  self.averagePrice_Value:SetText(replaceCount(marketConditions))
  self.recentPrice_Value:SetText(replaceCount(recentPrice))
  self.registListCount_Value:SetText(replaceCount(registListCount))
  self.registItemCount_Value:SetText(replaceCount(registItemCount))
  self.max_Value:SetText(makeDotMoney(itemMaxPrice))
  self.minPrice_Value:SetText(makeDotMoney(itemMinPrice))
  if nil ~= self._lastRegistPrice[itemKey] then
    recentPrice = toInt64(0, self._lastRegistPrice[itemKey])
  end
  local highAndLowAvgPrice = (masterInfo:getMaxPrice() + masterInfo:getMinPrice()) / toInt64(0, 2)
  if recentPrice > toInt64(0, 0) then
    self.priceEdit:SetEditText(tostring(makeDotMoney(recentPrice)), true)
  end
  self._averagePrice = highAndLowAvgPrice
  if itemMaxPrice < recentPrice or itemMinPrice > recentPrice then
    self.priceEdit:SetEditText(tostring(makeDotMoney(highAndLowAvgPrice)), true)
  end
  if registItemCount == toInt64(0, 0) then
    self.priceEdit:SetEditText(tostring(makeDotMoney(itemMaxPrice)), true)
  end
end
function ItemMarketRegistItem:RegistDO()
  if -1 == self._invenWhereType or -1 == self._invenSlotNo then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_REGISTITEM_ACK"))
    return
  end
  local pricePerOne
  local onePrice = self.priceEdit:GetEditText()
  onePrice = string.gsub(onePrice, ",", "")
  pricePerOne = tonumber64(onePrice)
  if nil == pricePerOne or pricePerOne <= toInt64(0, 0) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_PERITEMPRICE_ACK"))
    return
  end
  local self = ItemMarketRegistItem
  local itemWrapper = self:getTargetItem()
  if not itemWrapper then
    _PA_ASSERT(false, "itemWrapper \236\151\134\236\138\181\235\139\136\235\139\164. \235\185\132\236\160\149\236\131\129\236\158\133\235\139\136\235\139\164.")
    return
  end
  local itemSS = itemWrapper:getStaticStatus()
  local masterInfo = getItemMarketMasterByItemEnchantKey(itemSS:get()._key:get())
  if pricePerOne > masterInfo:getMaxPrice() or pricePerOne < masterInfo:getMinPrice() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ERRORPRICE_ACK"))
    return
  end
  local doBroadCast = requestDoBroadcastRegister(pricePerOne)
  if pricePerOne > toInt64(0, 0) then
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_MESSAGEBOX_ALERT")
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_CANCELITEM_MSGBOX")
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = ItemMarketItemSet_RegistDo_FromDoBroadcast,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "top")
    return
  end
  if itemWrapper:isCash() then
    PaymentPassword(ItemMarketItemSet_RegistDo_FromPaymentPassword)
  else
    if self._isByMaid then
      local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
      if nil == regionInfo then
        return
      end
      if checkMaid_SubmitMarket(true) then
        requestRegisterItemForItemMarketByMaid(self._invenWhereType, self._invenSlotNo, self._registerCount, pricePerOne, self._password)
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_COOLTIME"))
        return
      end
    else
      requestRegisterItemForItemMarket(self._invenWhereType, self._invenSlotNo, self._registerCount, pricePerOne, self._password)
    end
    self._priceCheck = false
    itemMarket_afterRegist()
  end
end
function itemMarket_afterRegist()
  local self = ItemMarketRegistItem
  self.itemSlot.icon:addInputEvent("Mouse_On", "")
  self.itemSlot.icon:addInputEvent("Mouse_Out", "")
  self:Clear()
  self.itemSlot:clearItem()
  self.itemName:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.itemName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ITEMSELECT_TEXT"))
  ClearFocusEdit()
  local registedItemCount = getItemMarketMyItemsCount()
  self.sellItemTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ENABLE_REGISTCOUNT", "itemCount", 30 - registedItemCount))
  if nil ~= PaGlobalFunc_ServantIcon_MaidCoolUpdate then
    PaGlobalFunc_ServantIcon_MaidCoolUpdate()
  end
  FGlobal_ItemMarketPassword_CanelPassword()
  FGlobal_ItemMarketRegistItem_CancelPassword()
end
function ItemMarketItemSet_RegistDo_FromDoBroadcast()
  local self = ItemMarketRegistItem
  local itemWrapper = self:getTargetItem()
  if not itemWrapper then
    _PA_ASSERT(false, "itemWrapper \236\151\134\236\138\181\235\139\136\235\139\164. \235\185\132\236\160\149\236\131\129\236\158\133\235\139\136\235\139\164.")
    return
  end
  local pricePerOne
  local onePrice = self.priceEdit:GetEditText()
  onePrice = string.gsub(onePrice, ",", "")
  pricePerOne = tonumber64(onePrice)
  if itemWrapper:isCash() then
    PaymentPassword(ItemMarketItemSet_RegistDo_FromPaymentPassword)
  else
    if self._isByMaid then
      local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
      if nil == regionInfo then
        return
      end
      if checkMaid_SubmitMarket(true) then
        requestRegisterItemForItemMarketByMaid(self._invenWhereType, self._invenSlotNo, self._registerCount, pricePerOne, self._password)
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_COOLTIME"))
        return
      end
    else
      requestRegisterItemForItemMarket(self._invenWhereType, self._invenSlotNo, self._registerCount, pricePerOne, self._password)
    end
    self._priceCheck = false
    itemMarket_afterRegist()
  end
end
function ItemMarketItemSet_RegistDo_FromPaymentPassword()
  local self = ItemMarketRegistItem
  local pricePerOne
  local onePrice = self.priceEdit:GetEditText()
  onePrice = string.gsub(onePrice, ",", "")
  pricePerOne = tonumber64(onePrice)
  if self._isByMaid then
    local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
    if nil == regionInfo then
      return
    end
    if checkMaid_SubmitMarket(true) then
      requestRegisterItemForItemMarketByMaid(self._invenWhereType, self._invenSlotNo, self._registerCount, pricePerOne, self._password)
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_COOLTIME"))
      return
    end
  else
    requestRegisterItemForItemMarket(self._invenWhereType, self._invenSlotNo, self._registerCount, pricePerOne, self._password)
  end
  self._priceCheck = false
  itemMarket_afterRegist()
end
local savedConfirmPrice = 0
function _ItemMarketRegistItem_RegistDO()
  local self = ItemMarketRegistItem
  local onePrice = self.priceEdit:GetEditText()
  local itemCount = self._registerCount
  onePrice = string.gsub(onePrice, ",", "")
  if not self._priceCheck then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_PERITEMPRICECONFIRM_ACK"))
    return
  elseif "" == onePrice then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ITEMSELECT_TEXT"))
    return
  end
  local sumItemPrice = onePrice * itemCount
  if toUint64(0, savedConfirmPrice) ~= toUint64(0, sumItemPrice) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKETREGIST_CONFIRMPRICE"))
  else
    self._lastRegistPrice[self._itemKey] = onePrice
    ItemMarketRegistItem:RegistDO()
  end
end
function HandleClicked_ItemMarketRegistItem_RegistDO()
  _ItemMarketRegistItem_RegistDO()
end
function HandleClicked_ItemMarketRegistItem_NumberPadShow()
  local self = ItemMarketRegistItem
  local itemWrapper = self:getTargetItem()
  if Defines.s64_const.s64_1 == self._maxPrice then
    itemPrice_MinOrMax(self._maxPrice, self._invenSlotNo, self._invenWhereType)
  elseif nil ~= itemWrapper then
    Panel_NumberPad_Show(true, self._maxPrice, self._invenSlotNo, itemPrice_MinOrMax, nil, self._invenWhereType)
  else
    ClearFocusEdit()
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_NOSELECTITEM_ACK"))
  end
end
function itemPrice_MinOrMax(price, invenSlotNo, invenWhereType)
  local self = ItemMarketRegistItem
  local countPrice = price
  local countMin = self._minPrice
  if countPrice > countMin then
    self.priceEdit:SetEditText(tostring(makeDotMoney(countPrice)), true)
  else
    self.priceEdit:SetEditText(tostring(makeDotMoney(countMin)), true)
  end
end
function HandleClicked_ItemMarketRegistItem_SellPriceMinOrMax(index)
  local self = ItemMarketRegistItem
  local itemWrapper = self:getTargetItem()
  if not itemWrapper then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_NOSELECTITEM_ACK"))
    return
  end
  if nil ~= itemWrapper then
    if 0 == index then
      self.priceEdit:SetEditText(tostring(makeDotMoney(self._minPrice)), true)
    elseif 1 == index then
      self.priceEdit:SetEditText(tostring(makeDotMoney(self._maxPrice)), true)
    end
  else
  end
end
function HandleClicked_ItemMarketRegistItem_SellPriceSum()
  local self = ItemMarketRegistItem
  self._priceCheck = true
  local onePrice = self.priceEdit:GetEditText()
  local itemCount = self._registerCount
  onePrice = string.gsub(onePrice, ",", "")
  if nil == onePrice or "" == onePrice or 0 == onePrice then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_PERPRICE_ACK"))
    return
  end
  if nil == itemCount or 0 == itemCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_NOSELECTITEM_ACK"))
    return
  end
  local sumItemPrice = onePrice * itemCount
  savedConfirmPrice = sumItemPrice
  self.SellSumPrice:SetText(makeDotMoney(sumItemPrice))
end
function FGlobal_ItemMarketRegistItem_RegistDO()
  _ItemMarketRegistItem_RegistDO()
end
function FGlobal_ItemMarketRegistItem_Open(isOpenWarehouse, isByMaid)
  local self = ItemMarketRegistItem
  local regionInfoWrapper = getRegionInfoWrapper(getSelfPlayer():getRegionKeyRaw())
  if nil == regionInfoWrapper then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ERRORAREA_ACK"))
    return
  end
  if isOpenWarehouse then
    requestItemMarketMyItems(true, true)
    if true == _ContentsGroup_isAllWarehouse then
      PaGlobal_SearchMenuWarehouse:Close()
    end
  end
  if true == Panel_Manufacture:GetShow() then
    Manufacture_Close()
  end
  if Panel_Window_ItemMarket:GetShow() then
    FGolbal_ItemMarketNew_Close()
  end
  self.titleText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ITEMMODIFY_TEXT", "getItem", territoryKey[regionInfoWrapper:getTerritoryKeyRaw()]))
  self._invenWhereType = -1
  self._invenSlotNo = -1
  self._registerCount = 0
  if isByMaid == nil then
    self._isByMaid = false
  else
    self._isByMaid = isByMaid
  end
  self.itemName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ITEMSELECT_TEXT"))
  self.itemSlot.icon:SetShow(true)
  self.itemSlot.icon:addInputEvent("Mouse_On", "")
  self.itemSlot.icon:addInputEvent("Mouse_Out", "")
  self.slotBG:SetShow(true)
  self.itemName:SetShow(true)
  self:Clear()
  self.itemSlot:clearItem()
  ClearFocusEdit()
  FGlobal_ItemMarketItemSet_Close()
  ItemMarketRegistItem:SetPostion()
  Panel_Window_ItemMarket_RegistItem:SetShow(true)
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
  if 5 == getGameServiceType() or 6 == getGameServiceType() then
    isCountryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_GUIDETEXT2_JP", "pcRoom", requestGetRefundPercentForPcRoom())
  else
    isCountryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_GUIDETEXT2", "forPremium", requestGetRefundPercentForPremiumPackage())
  end
  local transferTaxRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  self.guideText:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.guideText:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_GUIDETEXT", "feePercent", requestGetTradeFeePercent(), "transferTaxRate", transferTaxRate) .. isCountryTypeSet)
  Inventory_SetFunctor(FGlobal_ItemMarket_InvenFilter_IsRegistItem, FGlobal_ItemMarket_InvenFilter_RClick, InventoryWindow_Close, nil)
  if nil == isOpenWarehouse then
    Inventory_SetShow(true)
  end
  if getScreenSizeX() / 2 < Panel_Window_Inventory:GetSizeX() + Panel_Window_ItemMarket_RegistItem:GetSizeX() / 2 then
    Panel_Window_ItemMarket_RegistItem:SetPosX(getScreenSizeX() - Panel_Window_Inventory:GetSizeX() - Panel_Window_ItemMarket_RegistItem:GetSizeX())
  end
  local registedItemCount = getItemMarketMyItemsCount()
  self.sellItemTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ENABLE_REGISTCOUNT", "itemCount", 30 - registedItemCount))
end
function FGlobal_ReturnIsByMaid()
  ItemMarketRegistItem._isByMaid = false
end
function FGlobal_ItemMarketRegistItem_Close(isItemMarketItemSet_Show)
  Panel_Window_ItemMarket_RegistItem:SetShow(false)
  FGlobal_ItemMarketPassword_CanelPassword()
  ItemMarketRegistItem_SimpleToolTip(false)
  Inventory_SetFunctor(nil, nil, nil, nil)
  if ItemMarketRegistItem._isByMaid then
    if Panel_Window_Inventory:GetShow() then
      InventoryWindow_Close()
    end
    if Panel_Window_Warehouse:GetShow() then
      Warehouse_Close()
    end
    PaGlobalFunc_ServantIcon_MaidCoolUpdate()
    return
  end
  if not Panel_Window_Warehouse:GetShow() then
    if Panel_Window_Inventory:GetShow() then
      InventoryWindow_Close()
    end
    if nil ~= isItemMarketItemSet_Show and true == isItemMarketItemSet_Show then
      FGlobal_ItemMarketItemSet_Open()
    end
    _ItemMarketRegistItem_HideToolTip()
  else
    FGlobal_Warehouse_ResetFilter()
    Inventory_SetFunctor(nil, FGlobal_PopupMoveItem_InitByInventory, Warehouse_Close, nil)
    Panel_Window_Warehouse:SetVerticalMiddle()
    Panel_Window_Warehouse:SetHorizonCenter()
    Panel_Window_Warehouse:SetSpanSize(100, 0)
  end
end
function FGlobal_ItemMarket_InvenFilter_IsRegistItem(slotNo, itemWrapper, invenWhereType)
  if nil == itemWrapper then
    return true
  end
  local isAble = requestIsRegisterItemForItemMarket(itemWrapper:get():getKey())
  local itemBindType = itemWrapper:getStaticStatus():get()._vestedType:getItemKey()
  local isVested = itemWrapper:get():isVested()
  local isPersonalTrade = itemWrapper:getStaticStatus():isPersonalTrade()
  if isUsePcExchangeInLocalizingValue() then
    local isFilter = isVested and isPersonalTrade
    if isFilter then
      return isFilter
    end
  end
  if true == isAble then
    if ToClient_Inventory_CheckItemLock(slotNo, invenWhereType) then
      isAble = false
    else
      isAble = true
    end
  end
  if 2 == itemBindType then
    if true ~= itemWrapper:get():isVested() and isAble then
      isAble = true
    else
      isAble = false
    end
  end
  if itemWrapper:isCash() then
    if false == isAble and false == ItemMarketRegistItem._isAblePearlProduct then
      isAble = false
    else
      isAble = isAble and ItemMarketRegistItem._isAblePearlProduct
    end
  end
  return not isAble
end
function FGlobal_ItemMarket_InvenFilter_RClick(slotNo, itemWrapper, s64_count, inventoryType, waypointKey)
  if Defines.s64_const.s64_1 == s64_count then
    FGlobal_ItemMarketRegistItemFromInventory(1, slotNo, inventoryType, waypointKey)
  else
    local masterInfo = getItemMarketMasterByItemEnchantKey(itemWrapper:get():getKey():get())
    if masterInfo ~= nil and s64_count > masterInfo:getMaxRegisterCount() then
      s64_count = masterInfo:getMaxRegisterCount()
    end
    Panel_NumberPad_Show(true, s64_count, slotNo, FGlobal_ItemMarketRegistItemFromInventory, nil, inventoryType, nil, waypointKey)
  end
end
function FGlobal_ItemMarketRegistItemFromInventory(s64_count, slotNo, inventoryType, waypointKey)
  local self = ItemMarketRegistItem
  local itemWrapper
  if CppEnums.ItemWhereType.eInventory == inventoryType or CppEnums.ItemWhereType.eCashInventory == inventoryType then
    itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  elseif CppEnums.ItemWhereType.eWarehouse == inventoryType then
    if not waypointKey then
      local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
      if nil == regionInfo then
        return
      end
      local regionInfoWrapper = getRegionInfoWrapper(regionInfo:getAffiliatedTownRegionKey())
      waypointKey = regionInfoWrapper:getPlantKeyByWaypointKey():getWaypointKey()
      if ToClient_IsAccessibleRegionKey(regionInfo:getAffiliatedTownRegionKey()) == false then
        local plantWayKey = ToClient_GetOtherRegionKey_NeerByTownRegionKey()
        local newRegionInfo = ToClient_getRegionInfoWrapperByWaypoint(plantWayKey)
        if nil == newRegionInfo then
          return
        end
        waypointKey = newRegionInfo:get()._waypointKey
        if 0 == waypointKey then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CANTFIND_WAREHOUSE_INTERRITORY"))
          return
        end
      end
    end
    warehouse_requestInfo(waypointKey)
    local warehouseWrapper = warehouse_get(waypointKey)
    itemWrapper = warehouseWrapper:getItem(slotNo)
  end
  if nil == itemWrapper then
    _PA_ASSERT(false, "itemWrapper \236\151\134\236\138\181\235\139\136\235\139\164. \235\185\132\236\160\149\236\131\129\236\158\133\235\139\136\235\139\164.")
    return
  end
  local itemSS = itemWrapper:getStaticStatus()
  local summaryInfo = getItemMarketSummaryInClientByItemEnchantKey(itemSS:get()._key:get())
  if nil == summaryInfo then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_REGISTERITEM_MESSAGE_1"))
    return
  end
  local iconPath = itemSS:getIconPath()
  self.itemSlot:setItemByStaticStatus(itemWrapper:getStaticStatus(), Int64toInt32(s64_count))
  local nameColorGrade = itemSS:getGradeType()
  local nameColor
  if 0 == nameColorGrade then
    nameColor = UI_color.C_FFEFEFEF
  elseif 1 == nameColorGrade then
    nameColor = 4284350320
  elseif 2 == nameColorGrade then
    nameColor = 4283144191
  elseif 3 == nameColorGrade then
    nameColor = 4294953010
  elseif 4 == nameColorGrade then
    nameColor = 4294929408
  else
    nameColor = UI_color.C_FFFFFFFF
  end
  self.itemName:SetFontColor(nameColor)
  self.itemName:SetTextMode(UI_TM.eTextMode_AutoWrap)
  local enchantLevel = itemSS:get()._key:getEnchantLevel()
  if 1 == itemSS:getItemType() and enchantLevel > 15 then
    self.itemName:SetText(HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemSS:getName())
  elseif enchantLevel > 0 and CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSS:getItemClassify() then
    self.itemName:SetText(HighEnchantLevel_ReplaceString(enchantLevel + 15) .. " " .. itemSS:getName())
  else
    self.itemName:SetText(itemSS:getName())
  end
  self._invenWhereType = inventoryType
  self._invenSlotNo = slotNo
  self._registerCount = Int64toInt32(s64_count)
  self._waypointKey = waypointKey
  self:Update()
end
function _ItemMarketRegistItem_ShowToolTip(slotNo, inventoryType)
  local self = ItemMarketRegistItem
  local itemWrapper = self:getTargetItem()
  Panel_Tooltip_Item_Show(itemWrapper, self.itemSlot.icon, false, true, nil)
end
function _ItemMarketRegistItem_HideToolTip()
  Panel_Tooltip_Item_hideTooltip()
end
function ItemMarketRegistItem_SimpleToolTip(isShow, iconType)
  local self = ItemMarketRegistItem
  local name = ""
  local desc = ""
  local uiControl
  if 0 == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_AVGPRICE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_AVGPRICE_DESC")
    uiControl = self.averagePriceIcon
  elseif 1 == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_RECENTPRICE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_RECENTPRICE_DESC")
    uiControl = self.recentPriceIcon
  elseif 2 == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_MAXPRICE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_MAXPRICE_DESC")
    uiControl = self.maxPriceIcon
  elseif 3 == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_MINPRICE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_MINPRICE_DESC")
    uiControl = self.minPriceIcon
  elseif 4 == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTHIGH_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTHIGH_DESC")
    uiControl = self.registHighPriceIcon
  elseif 5 == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTLOW_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTLOW_DESC")
    uiControl = self.registLowPriceIcon
  elseif 6 == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTLIST_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTLIST_DESC")
    uiControl = self.registListCountIcon
  elseif 7 == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTITEM_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTITEM_DESC")
    uiControl = self.registItemCountIcon
  end
  if true == isShow then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function ItemMarketRegistItem:registEventHandler()
  self.btn_Close:addInputEvent("Mouse_LUp", "FGlobal_ItemMarketRegistItem_Close()")
  self.btn_Cancle:addInputEvent("Mouse_LUp", "FGlobal_ItemMarketRegistItem_Close()")
  self.btn_Confirm:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketRegistItem_RegistDO()")
  self.priceEdit:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketRegistItem_NumberPadShow()")
  self.btn_MinPrice:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketRegistItem_SellPriceMinOrMax( 0 )")
  self.btn_MaxPrice:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketRegistItem_SellPriceMinOrMax( 1 )")
  self.btn_CheckPrice:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketRegistItem_SellPriceSum()")
  self.averagePriceIcon:addInputEvent("Mouse_On", "ItemMarketRegistItem_SimpleToolTip( true, 0 )")
  self.averagePriceIcon:addInputEvent("Mouse_Out", "ItemMarketRegistItem_SimpleToolTip( false )")
  self.recentPriceIcon:addInputEvent("Mouse_On", "ItemMarketRegistItem_SimpleToolTip( true, 1 )")
  self.recentPriceIcon:addInputEvent("Mouse_Out", "ItemMarketRegistItem_SimpleToolTip( false )")
  self.maxPriceIcon:addInputEvent("Mouse_On", "ItemMarketRegistItem_SimpleToolTip( true, 2 )")
  self.maxPriceIcon:addInputEvent("Mouse_Out", "ItemMarketRegistItem_SimpleToolTip( false )")
  self.minPriceIcon:addInputEvent("Mouse_On", "ItemMarketRegistItem_SimpleToolTip( true, 3 )")
  self.minPriceIcon:addInputEvent("Mouse_Out", "ItemMarketRegistItem_SimpleToolTip( false )")
  self.registHighPriceIcon:addInputEvent("Mouse_On", "ItemMarketRegistItem_SimpleToolTip( true, 4 )")
  self.registHighPriceIcon:addInputEvent("Mouse_Out", "ItemMarketRegistItem_SimpleToolTip( false )")
  self.registLowPriceIcon:addInputEvent("Mouse_On", "ItemMarketRegistItem_SimpleToolTip( true, 5 )")
  self.registLowPriceIcon:addInputEvent("Mouse_Out", "ItemMarketRegistItem_SimpleToolTip( false )")
  self.registListCountIcon:addInputEvent("Mouse_On", "ItemMarketRegistItem_SimpleToolTip( true, 6 )")
  self.registListCountIcon:addInputEvent("Mouse_Out", "ItemMarketRegistItem_SimpleToolTip( false )")
  self.registItemCountIcon:addInputEvent("Mouse_On", "ItemMarketRegistItem_SimpleToolTip( true, 7 )")
  self.registItemCountIcon:addInputEvent("Mouse_Out", "ItemMarketRegistItem_SimpleToolTip( false )")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"ItemMarket\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"ItemMarket\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"ItemMarket\", \"false\")")
  self._buttonPassword:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketRegistItem_OpenRegistPassword()")
end
function HandleClicked_ItemMarketRegistItem_OpenRegistPassword()
  if 0 < ItemMarketRegistItem._invenSlotNo then
    FGlobal_ItemMarketPassword_Open(ItemMarketRegistItem._password)
  end
end
function FGlobal_ItemMarketRegistItem_RegistPassword(password)
  ItemMarketRegistItem._staticTextPassword:SetText("\236\158\160\234\184\136 \236\149\132\236\157\180\237\133\156")
  ItemMarketRegistItem._password = password
end
function FGlobal_ItemMarketRegistItem_CancelPassword()
  ItemMarketRegistItem._staticTextPassword:SetText("")
  ItemMarketRegistItem._password = 0
end
function ItemMarketRegistItem:registMessageHandler()
end
ItemMarketRegistItem:Initialize()
ItemMarketRegistItem:registEventHandler()
ItemMarketRegistItem:registMessageHandler()
if false == ToClient_IsContentsGroupOpen("344") then
  ItemMarketRegistItem._buttonPassword:SetShow(false)
  ItemMarketRegistItem._staticTextPassword:SetShow(false)
end

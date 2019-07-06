local LIMITEDSELLMONEY = 1000000000
local VCK = CppEnums.VirtualKeyCode
local UI_color = Defines.Color
local isNA = isGameTypeEnglish()
Panel_Trade_Market_Sell_ItemList:SetShow(false, false)
Panel_Trade_Market_Sell_ItemList:SetAlpha(1)
Panel_Trade_Market_Sell_ItemList:setGlassBackground(true)
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local _ItemPanel = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "Static_MiniPanel")
local _TradeGamePanel = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "Static_MiniPanel_forTradeGame")
local _SlotBG = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "Static_Slot")
_SlotBG:SetShow(false)
local _ItemIcon = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "Static_Icon")
_ItemIcon:SetShow(false)
local _RemainCount = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_remainCount")
local _NpcRemainCount = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_NpcRemainCount")
local _ItemName = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_itemName")
local _SellPrice = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_sellPrice_Value")
local _QuotationRate = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_MarketPriceRate")
local _AddCard = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "Button_AddCart")
local _sellScroll = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "Frame_Scroll")
local _distanceBonus = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_DistanceBonus")
local _distanceBonusValue = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_DistanceBonusValue")
local _distanceNoBonus = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_NoBonus")
local _desertBuff = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_DesertBuff")
local _lifePowerBuffIcon = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_LifePowerBuff")
local _lifePowerBuffValue = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_LifePowerBuffValue")
local _profitStatic = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_MySellPrice")
local _profitGold = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_Profit_Value")
local _noLink = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_LinkedExplorationNode")
local _expiration = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_Option")
local _tradePrice = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "StaticText_TradePrice")
local _btnSellAllItem = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "Button_AllTradeItemSell")
local _btnTradeGame = UI.getChildControl(Panel_Trade_Market_Sell_ItemList, "Button_TradeGameStart")
local _isShip = true
_btnSellAllItem:addInputEvent("Mouse_LUp", "HandleClicked_TradeItem_AllSellQuestion()")
_btnTradeGame:addInputEvent("Mouse_LUp", "click_TradeGameStart()")
local e1Percent = 10000
local e100Percent = 1000000
local tradeSellMarket = {
  maxSellCount = 7,
  currentItemCount = 0,
  scrollIndex = 0,
  itemsStartPosY = 25,
  intervalPanel = 10,
  _isNoLinkedNodeOne = false,
  _isLinkedNode = {},
  remainItemCount = {},
  itemProfit = {},
  vehicleItem = {},
  vehicleActorKey = {},
  expirationDate = {},
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = false,
    createExpiration = true,
    createCash = true
  },
  ListBody = {},
  ListBodyGame = {},
  itemSlot_BG = {},
  remainCount = {},
  npcRemainCount = {},
  itemName = {},
  sellPrice = {},
  Quotation = {},
  AddCart = {},
  profitStatic = {},
  profitGold = {},
  noLink = {},
  desertBuff = {},
  lifePowerBuffIcon = {},
  lifePowerBuffValue = {},
  itemEnchantKey = {},
  itemIndex = {},
  expiration = {},
  DistanceBonus = {},
  DistanceBonusValue = {},
  DistanceNoBonus = {},
  tradePrice = {},
  icons = {},
  totalProfit = toInt64(0, 0),
  ItemNameTable = {}
}
local realPriceCache = {
  _maxIndex = 0,
  _cacheData = {}
}
function global_tradeSellListExit()
  if Panel_Trade_Market_Sell_ItemList:IsShow() then
    Panel_Trade_Market_Sell_ItemList:SetShow(false)
  end
  FGlobal_isTradeGameSuccess()
end
function global_tradeSellListOpen()
  if true == ToClient_IsDevelopment() then
    _isShip = trademarket_isShip()
  else
    _isShip = false
  end
  FGlobal_isTradeGameSuccess()
  local talker = dialog_getTalker()
  if nil ~= talker then
    local actorKeyRaw = talker:getActorKey()
    local actorProxyWrapper = getNpcActor(actorKeyRaw)
    local actorProxy = actorProxyWrapper:get()
    local characterStaticStatus = actorProxy:getCharacterStaticStatus()
    if true == characterStaticStatus:isSmuggleMerchant() then
      return
    end
  end
  Panel_Trade_Market_Sell_ItemList:SetShow(true)
  tradeSellMarket.totalProfit = toInt64(0, 0)
  for count = 1, 10 do
    tradeSellMarket:setShowTradeIcon(count, false)
  end
  tradeSellMarket._isNoLinkedNodeOne = false
  _sellScroll:SetControlPos(0)
  tradeSellMarket.scrollIndex = 0
  global_sellItemFromPlayer()
  local talker = dialog_getTalker()
  local npcActorproxy = talker:get()
  local npcPosition = npcActorproxy:getPosition()
  local npcRegionInfo = getRegionInfoByPosition(npcPosition)
  local npcTradeOriginRegion = npcRegionInfo:get():getTradeOriginRegion()
  local boolValue = checkSelfplayerNode(npcTradeOriginRegion._waypointKey, false)
  eventResizeSellList()
end
function global_refreshScrollIndex()
  if false == global_IsTrading then
    return
  end
  local mySellCount = npcShop_getSellCount()
  local vhicleSellCount = npcShop_getVehicleSellCount()
  local isValidDistance = getDistanceFromVehicle()
  if false == isValidDistance then
    vhicleSellCount = 0
  end
  local sellCount = mySellCount + vhicleSellCount
  if sellCount > tradeSellMarket.maxSellCount and sellCount < tradeSellMarket.scrollIndex + tradeSellMarket.maxSellCount then
    tradeSellMarket.scrollIndex = tradeSellMarket.scrollIndex - 1
    local controlPos = tradeSellMarket.scrollIndex / (sellCount - tradeSellMarket.maxSellCount)
    if controlPos > 1 then
      controlPos = 1
    end
    _sellScroll:SetControlPos(controlPos)
  end
end
local _sellCount = 0
local showTradeItemList = {}
local _commerceIndex = 1
function global_sellItemFromPlayer()
  _sellCount = 0
  realPriceCache._maxIndex = 0
  realPriceCache._cacheData = {}
  local mySellCount = npcShop_getSellCount()
  local vhicleSellCount = npcShop_getVehicleSellCount()
  local isValidDistance = getDistanceFromVehicle()
  if true == ToClient_IsDevelopment() and true == _isShip then
    vhicleSellCount = npcShop_getShipSellCount()
    isValidDistance = getDistanceFromShip()
  end
  if false == isValidDistance then
    vhicleSellCount = 0
  end
  local sellCount = mySellCount + vhicleSellCount
  local talker = dialog_getTalker()
  if nil ~= talker then
    local actorKeyRaw = talker:getActorKey()
    local actorProxyWrapper = getNpcActor(actorKeyRaw)
    local actorProxy = actorProxyWrapper:get()
    local characterStaticStatus = actorProxy:getCharacterStaticStatus()
    if true == characterStaticStatus:isSmuggleMerchant() then
      return
    end
  end
  if sellCount > 0 then
    Panel_Trade_Market_Sell_ItemList:SetShow(true)
  else
    Panel_Trade_Market_Sell_ItemList:SetShow(false)
  end
  _sellCount = sellCount
  if sellCount <= 0 then
    return
  end
  for count = 1, 10 do
    tradeSellMarket:setShowTradeIcon(count, false)
  end
  local commerceIndex = 1
  local inventory = getSelfPlayer():get():getInventory()
  table.remove(showTradeItemList)
  local addScrollIndex = 1
  for ii = 1, tradeSellMarket.maxSellCount do
    addScrollIndex = ii
    local indexNum = tradeSellMarket.scrollIndex + addScrollIndex - 1
    if mySellCount <= indexNum then
      break
    end
    local shopItemWrapper = npcShop_getItemSell(indexNum)
    if nil ~= shopItemWrapper then
      local tradeItemInfo = {
        _isMyInventory = true,
        _indexNumber = indexNum,
        _itemKey = shopItemWrapper:getStaticStatus():get()._key:get()
      }
      showTradeItemList[commerceIndex] = tradeItemInfo
      commerceIndex = commerceIndex + 1
    else
      break
    end
  end
  local vehicleIndex = 0
  local servertInventorySize = 0
  local temporaryWrapper = getTemporaryInformationWrapper()
  local servantInfo = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
  if true == ToClient_IsDevelopment() and true == _isShip then
    servantInfo = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Ship)
  end
  if nil ~= servantInfo then
    local servertinventory = servantInfo:getInventory()
    if nil ~= servertinventory then
      servertInventorySize = servertinventory:size()
      if true == isValidDistance and commerceIndex <= tradeSellMarket.maxSellCount then
        vehicleIndex = tradeSellMarket.scrollIndex + tradeSellMarket.maxSellCount - mySellCount
        local slotCountIndex = 1
        local clucValue = vehicleIndex - tradeSellMarket.maxSellCount
        if clucValue > 0 then
          slotCountIndex = slotCountIndex + clucValue
        end
        local vehicleTradeItemCount = slotCountIndex
        for slotCount = slotCountIndex, servertInventorySize - 1 do
          if not servertinventory:empty(slotCount) then
            local servertitemWrapper = npcShop_getVehicleSellItem(vehicleTradeItemCount - 1)
            if true == ToClient_IsDevelopment() then
              if true == _isShip then
                servertitemWrapper = npcShop_getShipSellItem(vehicleTradeItemCount - 1)
              else
                servertitemWrapper = npcShop_getVehicleSellItem(vehicleTradeItemCount - 1)
              end
            end
            if nil == servertitemWrapper then
            end
            if vhicleSellCount < vehicleTradeItemCount then
              break
            end
            local itemStaticStaus = servertitemWrapper:getStaticStatus()
            if true == itemStaticStaus:isForJustTrade() then
              addScrollIndex = addScrollIndex + 1
              local indexNum = tradeSellMarket.scrollIndex + addScrollIndex - 1
              local tradeItemInfo = {
                _isMyInventory = false,
                _indexNumber = vehicleTradeItemCount - 1,
                _itemKey = itemStaticStaus:get()._key:get()
              }
              showTradeItemList[commerceIndex] = tradeItemInfo
              commerceIndex = commerceIndex + 1
              vehicleTradeItemCount = vehicleTradeItemCount + 1
              if commerceIndex > tradeSellMarket.maxSellCount then
                break
              end
            end
          else
          end
        end
      end
    end
  end
  local myLandVehicleActorKey, landVehicleActorProxy
  local isLinkedNode = false
  if nil ~= servantInfo then
    myLandVehicleActorKey = servantInfo:getActorKeyRaw()
  end
  if nil ~= myLandVehicleActorKey then
    landVehicleActorProxy = getVehicleActor(myLandVehicleActorKey)
  end
  local selfPlayer = getSelfPlayer()
  local selfPlayerRegion = getRegionInfoByPosition(selfPlayer:get():getPosition())
  local selfPlayerTradeOriginRegion = selfPlayerRegion:get():getTradeOriginRegion()
  local selfPlayerPosition = selfPlayerTradeOriginRegion:getWaypointInGamePosition()
  local tradeBonusPercent = FromClient_getTradeBonusPercent()
  local isExistTradeOrigin = true
  local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
  local characterStaticStatus = characterStaticStatusWrapper:get()
  local _isSupplyMerchant = characterStaticStatus:isSupplyMerchant()
  local _isFishSupplyMerchant = characterStaticStatus:isFishSupplyMerchant()
  for count = 1, commerceIndex - 1 do
    local tradeItemInfoList = showTradeItemList[count]
    local indexNum = tradeItemInfoList._indexNumber
    tradeSellMarket._isLinkedNode[count] = false
    tradeSellMarket.itemEnchantKey[count] = tradeItemInfoList._itemKey
    tradeSellMarket.itemIndex[count] = indexNum
    local tradeItemWrapper = npcShop_getTradeItem(tradeItemInfoList._itemKey)
    if nil == tradeItemWrapper:get() then
      _PA_LOG("asdf", "tradeItemWrapper \234\176\128 nil\236\157\180\235\139\164...")
      break
    end
    tradeSellMarket:setShowTradeIcon(count, true)
    local _leftPeriod
    local s64_TradeItemNo = toInt64(0, 0)
    local s64_inventoryItemCount = toInt64(0, 0)
    local itemValueType
    local f_sellRate = 0
    local profitItemGold = toInt64(0, 0)
    local realPrice = 0
    if true == tradeItemInfoList._isMyInventory then
      s64_TradeItemNo = npcShop_getItemNo(indexNum)
      s64_inventoryItemCount = inventory:getItemCountByItemNo_s64(s64_TradeItemNo)
      itemValueType = inventory:getItemByItemNo(s64_TradeItemNo)
      realPrice = fillSellTradeItemInfo(count, indexNum, itemValueType, tradeItemWrapper, characterStaticStatus, selfPlayerPosition, 0)
      tradeSellMarket.vehicleItem[count] = 0
      tradeSellMarket.vehicleActorKey[count] = 0
      tradeSellMarket:setBuyItemDataInfo(count, tradeItemWrapper:getStaticStatus():getName(), s64_inventoryItemCount, realPrice, tradeItemWrapper:getLeftCount())
      local itemWrapper = npcShop_getItemWrapperByShopSlotNo(indexNum)
      tradeSellMarket.noLink[count]:SetText(itemWrapper:getProductionRegion())
      tradeSellMarket.icons[count]:setItemByStaticStatus(tradeItemWrapper:getStaticStatus(), nil, tradeSellMarket.expirationDate[count])
      tradeSellMarket.icons[count].icon:addInputEvent("Mouse_On", "tradeItem_toolTip_Show(" .. indexNum .. ", \"tradeMarket_Sell\" )")
      tradeSellMarket.icons[count].icon:addInputEvent("Mouse_Out", "tradeItem_toolTip_Hide()")
      Panel_Tooltip_Item_SetPosition(indexNum, tradeSellMarket.icons[count], "tradeMarket_Sell")
      tradeSellMarket.expiration[count]:SetShow(true)
      realPriceCache._cacheData[realPriceCache._maxIndex] = Int64toInt32(realPrice)
      realPriceCache._maxIndex = realPriceCache._maxIndex + 1
    else
      s64_TradeItemNo = npcShop_getVehicleInvenItemNoByShopSlotNo(indexNum)
      if true == ToClient_IsDevelopment() and true == _isShip then
        s64_TradeItemNo = npcShop_getShipInvenItemNoByShopSlotNo(indexNum)
      end
      if nil == landVehicleActorProxy then
        break
      end
      local vehicleInven = landVehicleActorProxy:get():getInventory()
      s64_inventoryItemCount = vehicleInven:getItemCountByItemNo_s64(s64_TradeItemNo)
      itemValueType = vehicleInven:getItemByItemNo(s64_TradeItemNo)
      realPrice = fillSellTradeItemInfo(count, indexNum, itemValueType, tradeItemWrapper, characterStaticStatus, selfPlayerPosition, 4)
      tradeSellMarket.vehicleItem[count] = 4
      tradeSellMarket.vehicleActorKey[count] = myLandVehicleActorKey
      tradeSellMarket:setBuyItemDataInfo(count, PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_RIDE", "getName", tradeItemWrapper:getStaticStatus():getName()), s64_inventoryItemCount, realPrice, tradeItemWrapper:getLeftCount())
      local vehilcleItemWrapper
      if false == ToClient_IsDevelopment() then
        vehilcleItemWrapper = npcShop_getVehicleItemWrapper(indexNum)
      elseif true == _isShip then
        vehilcleItemWrapper = npcShop_getShipItemWrapper(indexNum)
      else
        vehilcleItemWrapper = npcShop_getVehicleItemWrapper(indexNum)
      end
      tradeSellMarket.noLink[count]:SetText(vehilcleItemWrapper:getProductionRegion())
      tradeSellMarket.icons[count]:setItemByStaticStatus(vehilcleItemWrapper:getStaticStatus(), nil, tradeSellMarket.expirationDate[count])
      tradeSellMarket.icons[count].icon:addInputEvent("Mouse_On", "tradeItem_toolTip_Show(" .. indexNum .. ", \"tradeMarket_VehicleSell\")")
      tradeSellMarket.icons[count].icon:addInputEvent("Mouse_Out", "tradeItem_toolTip_Hide()")
      Panel_Tooltip_Item_SetPosition(indexNum, tradeSellMarket.icons[count], "tradeMarket_VehicleSell")
      tradeSellMarket.expiration[count]:SetShow(true)
      realPriceCache._cacheData[realPriceCache._maxIndex] = Int64toInt32(realPrice)
      realPriceCache._maxIndex = realPriceCache._maxIndex + 1
    end
  end
  tradeSellMarket.currentItemCount = sellCount
  _sellScroll:SetInterval(commerceIndex)
  if sellCount < commerceIndex then
    _sellScroll:SetShow(false)
  else
    _sellScroll:SetShow(true)
  end
  _commerceIndex = commerceIndex
end
function fillSellTradeItemInfo(count, indexNum, itemValueType, tradeItemWrapper, characterStaticStatus, selfPlayerPosition, inventoryType)
  local isSupplyMerchant = characterStaticStatus:isSupplyMerchant()
  local isFishSupplyMerchant = characterStaticStatus:isFishSupplyMerchant()
  local itemExpiration = itemValueType:getExpirationDate()
  local _displayleftPeriod
  local leftPeriod = FromClient_getTradeItemExpirationDate(itemExpiration, tradeItemWrapper:getStaticStatus():get()._expirationPeriod)
  if isFishSupplyMerchant and leftPeriod > 300000 then
    leftPeriod = 1000000
  end
  _displayleftPeriod = leftPeriod / e1Percent
  local leftPeriodString = _displayleftPeriod .. "%"
  if itemExpiration:isDefined() and false == itemExpiration:isIndefinite() then
    local s64_Time = itemExpiration:get_s64()
    local s64_remainTime = getLeftSecond_s64(itemExpiration)
    if Defines.s64_const.s64_0 == s64_remainTime then
      tradeSellMarket.expirationDate[count] = 1
    else
      tradeSellMarket.expirationDate[count] = 0
    end
  else
    tradeSellMarket.expirationDate[count] = -1
  end
  tradeSellMarket.expiration[count]:SetText(leftPeriodString)
  local regionInfo = itemValueType:getItemRegionInfo()
  local fromPosition = float3(0, 0, 0)
  if 0 ~= regionInfo._waypointKey then
    fromPosition = regionInfo:getWaypointInGamePosition()
  end
  local f_sellRate = 0
  local isExistTradeOrigin = true
  local profitItemGold = toInt64(0, 0)
  f_sellRate = tradeItemWrapper:getSellPriceRate()
  local bigHand = 1000000 ~= getSelfPlayer():get():getlTradeItemCountRate()
  local checkTradeBonusGold = false == isSupplyMerchant and false == isFishSupplyMerchant
  local realPrice = 0
  if checkTradeBonusGold then
    realPrice = getCalculateTradeItemPrice(tradeItemWrapper:getTradeSellPrice(), tradeItemWrapper:getStaticStatus():getCommerceType(), fromPosition, selfPlayerPosition, tradeItemWrapper:getTradeGroupType(), characterStaticStatus:getTradeGroupType(), leftPeriod, isTradeGameSuccess() or bigHand)
  else
    realPrice = tradeItemWrapper:getTradeSellPrice()
  end
  local fromToDistanceNavi = 0
  if 0 ~= regionInfo._waypointKey then
    fromToDistanceNavi = getFromToDistanceTradeShop()
  else
    isExistTradeOrigin = false
  end
  local desertBuffPercent = ToClient_TradeGroupFromToAddPercent(tradeItemWrapper:getTradeGroupType(), characterStaticStatus:getTradeGroupType())
  local desertBuffDistance = ToClient_TradeGroupFromToDistance(tradeItemWrapper:getTradeGroupType(), characterStaticStatus:getTradeGroupType())
  if desertBuffPercent > 100 and fromToDistanceNavi >= desertBuffDistance then
    tradeSellMarket.desertBuff[count]:SetShow(true)
  else
    tradeSellMarket.desertBuff[count]:SetShow(false)
  end
  local bonusPercent = 0
  bonusPercent = math.floor(fromToDistanceNavi / 100 * FromClient_getTradeBonusPercent())
  bonusPercent = math.min(bonusPercent, FromClient_getTradeMaxDistancePercent())
  local bonosPercentString = bonusPercent / e1Percent - bonusPercent / e1Percent % 1 .. "%"
  tradeSellMarket.DistanceBonusValue[count]:SetText(bonosPercentString)
  tradeSellMarket.DistanceNoBonus[count]:SetShow(false)
  local isLinkedNode = false
  if false == ToClient_IsDevelopment() then
    isLinkedNode = npcShop_CheckLinkedItemExplorationNode(indexNum, inventoryType)
  elseif true == _isShip then
    isLinkedNode = npcShop_CheckLinkedItemExplorationNode(indexNum, inventoryType, 1)
  else
    isLinkedNode = npcShop_CheckLinkedItemExplorationNode(indexNum, inventoryType, 0)
  end
  local isNodeFreeTrade = tradeItemWrapper:getStaticStatus():get():isNodeFreeTrade()
  if isNodeFreeTrade then
    isLinkedNode = true
  end
  if not isLinkedNode then
    tradeSellMarket._isNoLinkedNodeOne = true
    realPrice = Int64toInt32(tradeItemWrapper:getStaticStatus():get()._originalPrice_s64) * getNotLinkNodeSellPercent() / e1Percent / 100
    f_sellRate = getNotLinkNodeSellPercent() / e1Percent
    if false == isExistTradeOrigin then
      realPrice = Int64toInt32(tradeItemWrapper:getStaticStatus():get()._originalPrice_s64)
      f_sellRate = 100
    end
    profitItemGold = toInt64(0, realPrice) - itemValueType:getBuyingPrice()
    tradeSellMarket.DistanceNoBonus[count]:SetShow(true)
    tradeSellMarket.DistanceBonusValue[count]:SetShow(false)
    tradeSellMarket.DistanceBonus[count]:SetShow(false)
    tradeSellMarket._isLinkedNode[count] = false
  else
    profitItemGold = realPrice - itemValueType:getBuyingPrice()
    tradeSellMarket._isLinkedNode[count] = true
  end
  local str_sellRate = string.format("%.f", f_sellRate)
  local str_sellRate_Value = PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TradeMarketSellList_Percents", "Percent", str_sellRate)
  if 100 < tonumber(tostring(str_sellRate)) then
    str_sellRate_Value = "<PAColor0xFFFFCE22>" .. str_sellRate_Value .. "\226\150\178<PAOldColor>"
  else
    str_sellRate_Value = "<PAColor0xFFF26A6A>" .. str_sellRate_Value .. "\226\150\188<PAOldColor>"
  end
  tradeSellMarket.Quotation[count]:SetText(str_sellRate_Value)
  if profitItemGold < toInt64(0, 0) then
    local profitItemGold_abs = toInt64(0, math.abs(Int64toInt32(profitItemGold)))
    tradeSellMarket.profitGold[count]:SetFontColor(UI_color.C_FFD20000)
    tradeSellMarket.profitGold[count]:SetText("-" .. makeDotMoney(profitItemGold_abs))
  else
    tradeSellMarket.profitGold[count]:SetFontColor(UI_color.C_FFFFCE22)
    tradeSellMarket.profitGold[count]:SetText(makeDotMoney(profitItemGold))
  end
  tradeSellMarket.noLink[count]:SetShow(true)
  tradeSellMarket.AddCart[count]:SetPosY(tradeSellMarket.noLink[count]:GetPosY() + tradeSellMarket.noLink[count]:GetTextSizeY() + 10)
  tradeSellMarket.itemProfit[count] = profitItemGold
  tradeSellMarket.icons[count].icon:SetShow(true)
  if true == isSupplyMerchant or isFishSupplyMerchant then
    local profitRate = string.format("%.f", tradeItemWrapper:getSellPriceRate())
    if not isLinkedNode and isFishSupplyMerchant then
      profitRate = 30
    end
    local sellPrice = Int64toInt32(tradeItemWrapper:getStaticStatus():get()._originalPrice_s64)
    str_sellRate_Value = "<PAColor0xFFFFCE22>" .. profitRate .. "%\226\150\178<PAOldColor>"
    tradeSellMarket.Quotation[count]:SetText(str_sellRate_Value)
    tradeSellMarket.profitGold[count]:SetFontColor(UI_color.C_FFFFCE22)
    tradeSellMarket.profitGold[count]:SetText(makeDotMoney(sellPrice * profitRate / 100 * _displayleftPeriod / 100))
    tradeSellMarket.sellPrice[count]:SetText(makeDotMoney(sellPrice * profitRate / 100 * _displayleftPeriod / 100))
  end
  tradeSellMarket.lifePowerBuffIcon[count]:SetShow(false)
  tradeSellMarket.lifePowerBuffValue[count]:SetShow(false)
  if true == isSupplyMerchant and nil ~= tradeItemWrapper:getStaticStatus():get() then
    local commerceType = tradeItemWrapper:getStaticStatus():get()._commerceType
    if 4 == commerceType then
      if true == _ContentsGroup_EnhanceAlchemy then
        tradeSellMarket.lifePowerBuffIcon[count]:SetShow(true)
        tradeSellMarket.lifePowerBuffValue[count]:SetShow(true)
        tradeSellMarket.lifePowerBuffValue[count]:SetText(makeDotMoney(tradeItemWrapper:getAlchemyBonusPrice()))
        tradeSellMarket.lifePowerBuffIcon[count]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 9, " .. count .. " )")
        tradeSellMarket.lifePowerBuffIcon[count]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
        tradeSellMarket.lifePowerBuffIcon[count]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 9, " .. count .. " )")
      end
    elseif 3 == commerceType and true == _ContentsGroup_EnhanceCooking then
      tradeSellMarket.lifePowerBuffIcon[count]:SetShow(true)
      tradeSellMarket.lifePowerBuffValue[count]:SetShow(true)
      tradeSellMarket.lifePowerBuffValue[count]:SetText(makeDotMoney(tradeItemWrapper:getCookingBonusPrice()))
      tradeSellMarket.lifePowerBuffIcon[count]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 10, " .. count .. " )")
      tradeSellMarket.lifePowerBuffIcon[count]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
      tradeSellMarket.lifePowerBuffIcon[count]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 10, " .. count .. " )")
    end
  end
  return realPrice
end
function FGlobal_MySellCount()
  return _sellCount
end
function HandleClicked_TradeItem_AllSellQuestion()
  local messageBoxMemo = ""
  if true == tradeSellMarket._isNoLinkedNodeOne then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketSellList_TradeItemAllSellQuestion_NodeLink")
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketSellList_TradeItemAllSellQuestion")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketSellList_NeedNodeLinkTitle"),
    content = messageBoxMemo,
    functionYes = HandleClicked_TradeItem_AllSell,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleClicked_TradeItem_AllSell()
  if Panel_TradeGame:GetShow() then
    Fglobal_TradeGame_Close()
  end
  local inventory = getSelfPlayer():get():getInventory()
  local s64_inventoryItemCount = toInt64(0, 0)
  local s64_TradeItemNo = toInt64(0, 0)
  local temporaryWrapper = getTemporaryInformationWrapper()
  local servantInfo = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
  if true == ToClient_IsDevelopment() then
    _isShip = trademarket_isShip()
    if true == _isShip then
      servantInfo = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Ship)
    end
  end
  local talker = dialog_getTalker()
  if nil ~= talker then
    local actorKeyRaw = talker:getActorKey()
    local actorProxyWrapper = getNpcActor(actorKeyRaw)
    local actorProxy = actorProxyWrapper:get()
    local characterStaticStatus = actorProxy:getCharacterStaticStatus()
    if (true == characterStaticStatus:isSupplyMerchant() or true == characterStaticStatus:isFishSupplyMerchant()) and 0 < math.floor(Int64toInt32(inventory:getWeight_s64()) / Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64())) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Weight"))
      return
    end
  end
  local myInventortySellAbleCount = npcShop_getSellCount()
  local priceIndex = 0
  for ii = 0, myInventortySellAbleCount do
    local shopItemWrapper = npcShop_getItemSell(ii)
    if nil ~= shopItemWrapper then
      local tradeType = shopItemWrapper:getStaticStatus():get()._tradeType
      s64_TradeItemNo = npcShop_getItemNo(ii)
      s64_inventoryItemCount = inventory:getItemCountByItemNo_s64(s64_TradeItemNo)
      if 5 == tradeType then
        npcShop_doSellInTradeShop(ii, Int64toInt32(s64_inventoryItemCount), 0, 14)
        priceIndex = priceIndex + 1
      else
        local realPrice = realPriceCache._cacheData[priceIndex]
        if nil == realPrice then
          realPrice = 150000
        end
        local myInvenMoney = Int64toInt32(getSelfPlayer():get():getInventory():getMoney_s64())
        local limitCount = math.floor((LIMITEDSELLMONEY - myInvenMoney) / realPrice)
        priceIndex = priceIndex + 1
        npcShop_doSellInTradeShop(ii, Int64toInt32(s64_inventoryItemCount), 0, 0)
      end
    end
  end
  if nil ~= servantInfo then
    local servertinventory = servantInfo:getInventory()
    if nil ~= servertinventory then
      local servertInventorySize = servertinventory:size()
      local emptyCount = 0
      for slotCount = 2, servertInventorySize - 1 do
        if not servertinventory:empty(slotCount) then
          local s64_VehicleItemNo = npcShop_getVehicleInvenItemNoByShopSlotNo(slotCount - 2 - emptyCount)
          if true == ToClient_IsDevelopment() and true == _isShip then
            s64_VehicleItemNo = npcShop_getShipInvenItemNoByShopSlotNo(slotCount - 2 - emptyCount)
          end
          if nil ~= s64_VehicleItemNo then
            local vehicleItemCount = Int64toInt32(servertinventory:getItemCountByItemNo_s64(s64_VehicleItemNo))
            local servertitemWrapper
            if false == ToClient_IsDevelopment() then
              servertitemWrapper = npcShop_getVehicleSellItem(slotCount - 2 - emptyCount)
            elseif true == _isShip then
              servertitemWrapper = npcShop_getShipSellItem(slotCount - 2 - emptyCount)
            else
              servertitemWrapper = npcShop_getVehicleSellItem(slotCount - 2 - emptyCount)
            end
            if nil ~= servertitemWrapper then
              local realPrice = realPriceCache._cacheData[priceIndex]
              if nil == realPrice then
                realPrice = 150000
              end
              local myInvenMoney = Int64toInt32(getSelfPlayer():get():getInventory():getMoney_s64())
              local limitCount = math.floor((LIMITEDSELLMONEY - myInvenMoney) / realPrice)
              priceIndex = priceIndex + 1
              if false == ToClient_IsDevelopment() then
                npcShop_doSellInTradeShop(slotCount - 2 - emptyCount, vehicleItemCount, 4, 0)
              elseif true == _isShip then
                npcShop_doSellInTradeShop(slotCount - 2 - emptyCount, vehicleItemCount, 4, 0, 1)
              else
                npcShop_doSellInTradeShop(slotCount - 2 - emptyCount, vehicleItemCount, 4, 0, 0)
              end
            end
          end
        else
          emptyCount = emptyCount + 1
        end
      end
    end
  end
  PaGlobal_TutorialManager:handleClickedTradeItemAllSell(talker)
  tradeSellMarket._isNoLinkedNodeOne = false
end
function click_TradeGameStart()
  local talker = dialog_getTalker()
  if nil == talker then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if -1 ~= ToClient_GetMyDuelCharacterIndex() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantCharacterTagSellTradeItem"))
    return
  end
  local useStartSlot = inventorySlotNoUserStart()
  local invenUseSize = selfPlayer:get():getInventorySlotCount(true)
  local inventory = selfPlayer:get():getInventoryByType(CppEnums.ItemWhereType.eInventory)
  local invenMaxSize = inventory:sizeXXX()
  local freeCount = inventory:getFreeCount()
  if invenUseSize - useStartSlot <= invenUseSize - freeCount - useStartSlot then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_DONTPLAYGAME"))
    return
  end
  if Panel_TradeGame:GetShow() then
    if true == isTradeGameFinish() then
      Fglobal_TradeGame_Close()
    end
    return
  end
  local wp = selfPlayer:getWp()
  if 0 >= FGlobal_MySellCount() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_2")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_1"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if wp < 5 then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_3")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_1"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_4") .. " " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERRANDOMSELECT_NOWWP", "getWp", wp)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_1"),
    content = messageBoxMemo,
    functionYes = TradeGameStart,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function TradeGameStart()
  local talker = dialog_getTalker()
  if nil == talker then
    return
  end
  ToClient_TradeGameStart(talker:getActorKey())
end
function tradeSellMarket:setBuyItemDataInfo(index, itemName, leftCount, price, possibleCount)
  tradeSellMarket.ListBody[index]:EraseAllEffect()
  _btnTradeGame:EraseAllEffect()
  tradeSellMarket.itemName[index]:SetTextMode(UI_TM.eTextMode_LimitText)
  local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
  local characterStaticStatus = characterStaticStatusWrapper:get()
  local wp = getSelfPlayer():getWp()
  local bigHand = 1000000 ~= getSelfPlayer():get():getlTradeItemCountRate() and not characterStaticStatus:isSupplyMerchant() and not characterStaticStatus:isFishSupplyMerchant()
  local sellPrice = Int64toInt32(price)
  if true == isTradeGameSuccess() or bigHand then
    _btnTradeGame:SetIgnore(true)
    _btnTradeGame:SetMonoTone(true)
    if isNA then
    else
    end
    if true == checkLinkedNode(index) then
      bonusText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_TRADEGAME")
      itemName = itemName .. " " .. bonusText
      tradeSellMarket.itemName[index]:SetText(tostring(itemName))
    else
      tradeSellMarket.itemName[index]:SetText(tostring(itemName))
    end
  elseif wp < 5 then
    _btnTradeGame:SetIgnore(true)
    _btnTradeGame:SetMonoTone(true)
    if isNA then
    else
    end
    tradeSellMarket.itemName[index]:SetText(tostring(itemName))
  else
    _btnTradeGame:SetIgnore(false)
    _btnTradeGame:SetMonoTone(false)
    if isNA then
    else
    end
    tradeSellMarket.itemName[index]:SetText(tostring(itemName))
  end
  if true == tradeSellMarket.itemName[index]:IsLimitText() then
    tradeSellMarket.ItemNameTable[index] = itemName
    tradeSellMarket.itemName[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 8, " .. index .. ")")
    tradeSellMarket.itemName[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
    tradeSellMarket.itemName[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 8, " .. index .. ")")
    tradeSellMarket.itemName[index]:SetIgnore(false)
  else
    tradeSellMarket.ItemNameTable[index] = nil
  end
  tradeSellMarket.sellPrice[index]:SetText(makeDotMoney(sellPrice))
  tradeSellMarket.remainItemCount[index] = leftCount
  tradeSellMarket.remainCount[index]:SetText(tostring(leftCount))
  if possibleCount == Defines.s64_const.toInt64 then
    tradeSellMarket.npcRemainCount[index]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_NPCREMAINCOUNT", "possibleCount", tostring(possibleCount)))
  else
    tradeSellMarket.npcRemainCount[index]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_REMAININFINITY"))
  end
  if true == characterStaticStatus:isTerritorySupplyMerchant() then
    tradeSellMarket.AddCart[index]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_SELLMARKET"))
    _btnSellAllItem:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_SELLALLITEM"))
  else
    tradeSellMarket.AddCart[index]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_TRADLESELLMARKET"))
    _btnSellAllItem:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_TRADLESELLMARKETALL"))
  end
  if true == characterStaticStatus:isSupplyMerchant() or characterStaticStatus:isFishSupplyMerchant() then
    _btnTradeGame:SetShow(false)
    tradeSellMarket.DistanceBonusValue[index]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_NOTAPPLY"))
  else
    _btnTradeGame:SetShow(true)
  end
end
function checkLinkedNode(index)
  return tradeSellMarket._isLinkedNode[index]
end
function NpcTradeSell_ScrollEvent(isUpscroll)
  tradeSellMarket.scrollIndex = UIScroll.ScrollEvent(_sellScroll, isUpscroll, tradeSellMarket.maxSellCount, tradeSellMarket.currentItemCount, tradeSellMarket.scrollIndex, 1)
  global_sellItemFromPlayer()
  tradeItem_toolTip_Hide()
end
function NpcTradeSell_LupEvent(index)
  if index < 0 then
    return
  end
  local tradeItemInfo = showTradeItemList[index]
  local tradeItemWrapper = npcShop_getTradeItem(tradeItemInfo._itemKey)
  local itemSS = tradeItemWrapper:getStaticStatus()
  global_SellPanel_Refresh(itemSS)
end
function createSellItemList()
  for index = 1, 10 do
    getItemList(index)
  end
  UIScroll.InputEvent(_sellScroll, "NpcTradeSell_ScrollEvent")
  _sellScroll:SetControlPos(0)
  Panel_Trade_Market_Sell_ItemList:addInputEvent("Mouse_UpScroll", "NpcTradeSell_ScrollEvent(true)")
  Panel_Trade_Market_Sell_ItemList:addInputEvent("Mouse_DownScroll", "NpcTradeSell_ScrollEvent(false)")
end
function getItemList(index)
  local tempListBody = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Trade_Market_Sell_ItemList, "Static_SellMiniPanel_" .. index)
  CopyBaseProperty(_ItemPanel, tempListBody)
  tradeSellMarket.ListBody[index] = tempListBody
  tradeSellMarket.ListBody[index]:addInputEvent("Mouse_UpScroll", "NpcTradeSell_ScrollEvent(true)")
  tradeSellMarket.ListBody[index]:addInputEvent("Mouse_DownScroll", "NpcTradeSell_ScrollEvent(false)")
  tradeSellMarket.ListBody[index]:addInputEvent("Mouse_LUp", "NpcTradeSell_LupEvent(" .. index .. ")")
  local tempListBodyGame = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempListBody, "Static_TradeGameMiniPanel_" .. index)
  CopyBaseProperty(_TradeGamePanel, tempListBodyGame)
  tradeSellMarket.ListBodyGame[index] = tempListBodyGame
  tradeSellMarket.ListBodyGame[index]:addInputEvent("Mouse_UpScroll", "NpcTradeSell_ScrollEvent(true)")
  tradeSellMarket.ListBodyGame[index]:addInputEvent("Mouse_DownScroll", "NpcTradeSell_ScrollEvent(false)")
  tradeSellMarket.ListBodyGame[index]:addInputEvent("Mouse_LUp", "NpcTradeSell_LupEvent(" .. index .. ")")
  local tempItemSlotBG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempListBody, "Static_Slot_" .. index)
  CopyBaseProperty(_SlotBG, tempItemSlotBG)
  tradeSellMarket.itemSlot_BG[index] = tempItemSlotBG
  tradeSellMarket.itemSlot_BG[index]:addInputEvent("Mouse_LUp", "NpcTradeSell_LupEvent(" .. index .. ")")
  tempItemSlotBG:SetIgnore(false)
  local slot = {}
  SlotItem.new(slot, "TradeShopItem_" .. index, index, tempListBody, tradeSellMarket.slotConfig)
  slot:createChild()
  slot.icon:SetPosY(tempItemSlotBG:GetPosY() + 4)
  slot.icon:SetPosX(tempItemSlotBG:GetPosX() + 4)
  slot.icon:addInputEvent("Mouse_UpScroll", "NpcTradeSell_ScrollEvent(true)")
  slot.icon:addInputEvent("Mouse_DownScroll", "NpcTradeSell_ScrollEvent(false)")
  slot.icon:addInputEvent("Mouse_LUp", "NpcTradeSell_LupEvent(" .. index .. ")")
  local tempRemainCount = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_remainCount_" .. index)
  CopyBaseProperty(_RemainCount, tempRemainCount)
  tradeSellMarket.remainCount[index] = tempRemainCount
  local tempNpcRemainCount = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_npcRemainCount_" .. index)
  CopyBaseProperty(_NpcRemainCount, tempNpcRemainCount)
  tradeSellMarket.npcRemainCount[index] = tempNpcRemainCount
  local tempItemName = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_itemName_" .. index)
  CopyBaseProperty(_ItemName, tempItemName)
  tempItemName:SetAutoResize(true)
  tempItemName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  tradeSellMarket.itemName[index] = tempItemName
  local tempSellPrice = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_sellPrice_" .. index)
  CopyBaseProperty(_SellPrice, tempSellPrice)
  tradeSellMarket.sellPrice[index] = tempSellPrice
  local tempQuotation = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_QuotationRate_" .. index)
  CopyBaseProperty(_QuotationRate, tempQuotation)
  tradeSellMarket.Quotation[index] = tempQuotation
  tradeSellMarket.Quotation[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 2, " .. index .. " )")
  tradeSellMarket.Quotation[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
  tradeSellMarket.Quotation[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 2, " .. index .. " )")
  local tempExpiration = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_Expiration_" .. index)
  CopyBaseProperty(_expiration, tempExpiration)
  tradeSellMarket.expiration[index] = tempExpiration
  tradeSellMarket.expiration[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 5, " .. index .. " )")
  tradeSellMarket.expiration[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
  tradeSellMarket.expiration[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 5, " .. index .. " )")
  local tempTradePrice = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_TradePrice_" .. index)
  CopyBaseProperty(_tradePrice, tempTradePrice)
  tradeSellMarket.tradePrice[index] = tempTradePrice
  tradeSellMarket.tradePrice[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 0, " .. index .. " )")
  tradeSellMarket.tradePrice[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
  tradeSellMarket.tradePrice[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 0, " .. index .. " )")
  local tempDistanceBouns = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_Distance_" .. index)
  CopyBaseProperty(_distanceBonus, tempDistanceBouns)
  tradeSellMarket.DistanceBonus[index] = tempDistanceBouns
  tradeSellMarket.DistanceBonus[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 3, " .. index .. " )")
  tradeSellMarket.DistanceBonus[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
  tradeSellMarket.DistanceBonus[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 3, " .. index .. " )")
  local tempDistanceBonusValue = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_DistanceValue_" .. index)
  CopyBaseProperty(_distanceBonusValue, tempDistanceBonusValue)
  tradeSellMarket.DistanceBonusValue[index] = tempDistanceBonusValue
  local tempDistanceNoBonus = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_DistanceNoBonus_" .. index)
  CopyBaseProperty(_distanceNoBonus, tempDistanceNoBonus)
  tradeSellMarket.DistanceNoBonus[index] = tempDistanceNoBonus
  tradeSellMarket.DistanceNoBonus[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 6, " .. index .. " )")
  tradeSellMarket.DistanceNoBonus[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
  tradeSellMarket.DistanceNoBonus[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 6, " .. index .. " )")
  local tempAddCart = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, tempListBody, "Button_AddCart_" .. index)
  tempAddCart:addInputEvent("Mouse_LUp", "click_tradeSellMarket_SellItem(" .. index .. ")")
  CopyBaseProperty(_AddCard, tempAddCart)
  tradeSellMarket.AddCart[index] = tempAddCart
  tradeSellMarket.AddCart[index]:addInputEvent("Mouse_UpScroll", "NpcTradeSell_ScrollEvent(true)")
  tradeSellMarket.AddCart[index]:addInputEvent("Mouse_DownScroll", "NpcTradeSell_ScrollEvent(false)")
  local tempProfitStatic = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "Static_Profit_" .. index)
  CopyBaseProperty(_profitStatic, tempProfitStatic)
  tradeSellMarket.profitStatic[index] = tempProfitStatic
  tradeSellMarket.profitStatic[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 1, " .. index .. " )")
  tradeSellMarket.profitStatic[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
  tradeSellMarket.profitStatic[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 1, " .. index .. " )")
  local tempProfitGold = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_ProfitGold_" .. index)
  CopyBaseProperty(_profitGold, tempProfitGold)
  tradeSellMarket.profitGold[index] = tempProfitGold
  local tempNoLinked = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_NoLinked_" .. index)
  CopyBaseProperty(_noLink, tempNoLinked)
  tradeSellMarket.noLink[index] = tempNoLinked
  tradeSellMarket.noLink[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 4, " .. index .. " )")
  tradeSellMarket.noLink[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
  tradeSellMarket.noLink[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 4, " .. index .. " )")
  local tempDesertBuff = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_DesertBuff_" .. index)
  CopyBaseProperty(_desertBuff, tempDesertBuff)
  tradeSellMarket.desertBuff[index] = tempDesertBuff
  tradeSellMarket.desertBuff[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 7, " .. index .. " )")
  tradeSellMarket.desertBuff[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
  tradeSellMarket.desertBuff[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 7, " .. index .. " )")
  local tempLifePowerBuffIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_LifePowerBuffIcon_" .. index)
  CopyBaseProperty(_lifePowerBuffIcon, tempLifePowerBuffIcon)
  tradeSellMarket.lifePowerBuffIcon[index] = tempLifePowerBuffIcon
  tradeSellMarket.lifePowerBuffIcon[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 9, " .. index .. " )")
  tradeSellMarket.lifePowerBuffIcon[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
  tradeSellMarket.lifePowerBuffIcon[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 9, " .. index .. " )")
  local tempLifePowerBuffValue = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_LifePowerBuffValue_" .. index)
  CopyBaseProperty(_lifePowerBuffValue, tempLifePowerBuffValue)
  tradeSellMarket.lifePowerBuffValue[index] = tempLifePowerBuffValue
  tradeSellMarket.icons[index] = slot
  local sizeY = tempListBody:GetSizeY()
  local posY = tradeSellMarket.itemsStartPosY + (index - 1) * sizeY + tradeSellMarket.intervalPanel * index + 30
  tradeSellMarket.ListBody[index]:SetPosY(posY)
end
local selectIndex = 0
local sellStackCount = 0
local tempTradeType = 0
function click_tradeSellMarket_SellItem(index)
  selectIndex = index
  local isLinkedNode = npcShop_CheckLinkedItemExplorationNode(tradeSellMarket.itemIndex[index], tradeSellMarket.vehicleItem[index])
  param = {
    [0] = tradeSellMarket.itemIndex[index],
    [1] = tradeSellMarket.itemProfit[index],
    [2] = tradeSellMarket.vehicleItem[index],
    [3] = tradeSellMarket.vehicleActorKey[index],
    [4] = tradeSellMarket.expirationDate[index],
    [5] = isLinkedNode
  }
  Panel_NumberPad_Show(true, tradeSellMarket.remainItemCount[index], param, TradeMarket_SellSome_ConfirmFunction)
end
function TradeMarket_SellSome_ConfirmFunction(inputNumber, param)
  local inventory = getSelfPlayer():get():getInventory()
  local s64_TradeItemNo = toInt64(0, 0)
  local s64_inventoryItemCount = toInt64(0, 0)
  local itemValueType, regionInfo
  local talker = dialog_getTalker()
  if nil ~= talker then
    local actorKeyRaw = talker:getActorKey()
    local actorProxyWrapper = getNpcActor(actorKeyRaw)
    local actorProxy = actorProxyWrapper:get()
    local characterStaticStatus = actorProxy:getCharacterStaticStatus()
    if (true == characterStaticStatus:isSupplyMerchant() or true == characterStaticStatus:isFishSupplyMerchant()) and 0 < math.floor(Int64toInt32(inventory:getWeight_s64()) / Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64())) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Weight"))
      return
    end
  end
  if 0 == param[2] then
    s64_TradeItemNo = npcShop_getItemNo(param[0])
    s64_inventoryItemCount = inventory:getItemCountByItemNo_s64(s64_TradeItemNo)
    itemValueType = inventory:getItemByItemNo(s64_TradeItemNo)
    regionInfo = itemValueType:getItemRegionInfo()
    itemWrapper = npcShop_getItemSell(param[0])
  elseif 4 == param[2] then
    local myLandVehicleActorKey, landVehicleActorProxy
    local temporaryWrapper = getTemporaryInformationWrapper()
    local servantInfo = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
    if true == ToClient_IsDevelopment() then
      if true == _isShip then
        servantInfo = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Ship)
      else
        servantInfo = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
      end
    end
    if nil ~= servantInfo then
      local servertinventory = servantInfo:getInventory()
      if false == ToClient_IsDevelopment() then
        s64_TradeItemNo = npcShop_getVehicleInvenItemNoByShopSlotNo(param[0])
      elseif true == _isShip then
        s64_TradeItemNo = npcShop_getShipInvenItemNoByShopSlotNo(param[0])
      else
        s64_TradeItemNo = npcShop_getVehicleInvenItemNoByShopSlotNo(param[0])
      end
      myLandVehicleActorKey = servantInfo:getActorKeyRaw()
      if nil ~= myLandVehicleActorKey then
        landVehicleActorProxy = getVehicleActor(myLandVehicleActorKey)
      end
      local vehicleInven = landVehicleActorProxy:get():getInventory()
      s64_inventoryItemCount = vehicleInven:getItemCountByItemNo_s64(s64_TradeItemNo)
      itemValueType = vehicleInven:getItemByItemNo(s64_TradeItemNo)
      regionInfo = itemValueType:getItemRegionInfo()
    end
    if false == ToClient_IsDevelopment() then
      itemWrapper = npcShop_getVehicleSellItem(param[0])
    elseif true == _isShip then
      itemWrapper = npcShop_getShipSellItem(param[0])
    else
      itemWrapper = npcShop_getVehicleSellItem(param[0])
    end
  end
  if nil == itemWrapper then
    return
  end
  PaGlobal_TutorialManager:handleTradeMarketSellSomeConfirm(itemWrapper:getStaticStatus():get()._key:getItemKey())
  local tradeType = itemWrapper:getStaticStatus():get()._tradeType
  tempTradeType = tradeType
  sellStackCount = inputNumber
  if false == param[5] and 0 ~= regionInfo._waypointKey then
    local itemData
    if 0 == param[2] then
      itemData = npcShop_getItemWrapperByShopSlotNo(param[0])
    elseif 4 == param[2] then
      if false == ToClient_IsDevelopment() then
        itemData = npcShop_getVehicleItemWrapper(param[0])
      elseif true == _isShip then
        itemData = npcShop_getShipItemWrapper(param[0])
      else
        itemData = npcShop_getVehicleItemWrapper(param[0])
      end
    end
    if nil ~= itemData then
      local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
      local characterStaticStatus = characterStaticStatusWrapper:get()
      if true == characterStaticStatus:isSupplyMerchant() then
        TradeMarket_CheckNodeLink_SellSome()
        return
      end
      local isNodeFreeTrade = itemWrapper:getStaticStatus():get():isNodeFreeTrade()
      if true == isNodeFreeTrade then
        TradeMarket_CheckNodeLink_SellSome()
      else
        local talker = dialog_getTalker()
        local nodeString = PAGetStringParam3(Defines.StringSheet_GAME, "Lua_TradeMarketSellList_NeedNodeLink", "exploreNode1", talker:getExplorationNodeName(), "exploreNode2", itemData:getProductionRegion(), "sellPercent", getNotLinkNodeSellPercent() / e1Percent)
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketSellList_NeedNodeLinkTitle"),
          content = nodeString,
          functionYes = TradeMarket_CheckNodeLink_SellSome,
          functionCancel = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
      end
    end
  else
    local rv
    if 5 == tradeType then
      rv = npcShop_doSellInTradeShop(param[0], Int64toInt32(sellStackCount), param[2], 14)
    else
      local realPrice = realPriceCache._cacheData[selectIndex - 1]
      if nil == realPrice then
        realPrice = 150000
      end
      local myInvenMoney = Int64toInt32(getSelfPlayer():get():getInventory():getMoney_s64())
      local limitCount = math.floor((LIMITEDSELLMONEY - myInvenMoney) / realPrice)
      if false == ToClient_IsDevelopment() then
        rv = npcShop_doSellInTradeShop(param[0], Int64toInt32(sellStackCount), param[2], 0)
      elseif true == _isShip then
        rv = npcShop_doSellInTradeShop(param[0], Int64toInt32(sellStackCount), param[2], 0, 1)
      else
        rv = npcShop_doSellInTradeShop(param[0], Int64toInt32(sellStackCount), param[2], 0, 0)
      end
    end
    if 0 == rv then
      tradeSellMarket.totalProfit = tradeSellMarket.totalProfit + param[1] * inputNumber
    end
  end
end
function TradeMarket_CheckNodeLink_SellSome()
  if nil == tempTradeType then
    tempTradeType = 0
  end
  if 5 == tempTradeType then
    npcShop_doSellInTradeShop(tradeSellMarket.itemIndex[selectIndex], Int64toInt32(sellStackCount), tradeSellMarket.vehicleItem[selectIndex], 14)
  elseif false == ToClient_IsDevelopment() then
    npcShop_doSellInTradeShop(tradeSellMarket.itemIndex[selectIndex], Int64toInt32(sellStackCount), tradeSellMarket.vehicleItem[selectIndex], 0)
  elseif true == _isShip then
    npcShop_doSellInTradeShop(tradeSellMarket.itemIndex[selectIndex], Int64toInt32(sellStackCount), tradeSellMarket.vehicleItem[selectIndex], 0, 1)
  else
    npcShop_doSellInTradeShop(tradeSellMarket.itemIndex[selectIndex], Int64toInt32(sellStackCount), tradeSellMarket.vehicleItem[selectIndex], 0, 0)
  end
end
function tradeSellMarket:setShowTradeIcon(index, isShow)
  tradeSellMarket.ListBody[index]:SetShow(isShow)
  tradeSellMarket.itemSlot_BG[index]:SetShow(isShow)
  tradeSellMarket.remainCount[index]:SetShow(isShow)
  tradeSellMarket.npcRemainCount[index]:SetShow(false)
  tradeSellMarket.icons[index].icon:SetShow(isShow)
  tradeSellMarket.itemName[index]:SetShow(isShow)
  tradeSellMarket.sellPrice[index]:SetShow(isShow)
  tradeSellMarket.Quotation[index]:SetShow(isShow)
  tradeSellMarket.profitStatic[index]:SetShow(isShow)
  tradeSellMarket.profitGold[index]:SetShow(isShow)
  tradeSellMarket.noLink[index]:SetShow(isShow)
  tradeSellMarket.AddCart[index]:SetShow(isShow)
  tradeSellMarket.DistanceBonus[index]:SetShow(isShow)
  tradeSellMarket.DistanceBonusValue[index]:SetShow(isShow)
  tradeSellMarket.DistanceNoBonus[index]:SetShow(isShow)
  tradeSellMarket.tradePrice[index]:SetShow(isShow)
  tradeSellMarket.expiration[index]:SetShow(false)
  tradeSellMarket.ListBodyGame[index]:SetShow(false)
end
local temp_InvenSlotNum, temp_ToolTipType
function tradeItem_toolTip_Show(InvenSlotNum, toolTiptype)
  temp_InvenSlotNum = InvenSlotNum
  temp_ToolTipType = toolTiptype
  Panel_Tooltip_Item_Show_GeneralNormal(InvenSlotNum, toolTiptype, true)
end
function tradeItem_toolTip_Hide()
  if nil == temp_InvenSlotNum then
    return
  end
  Panel_Tooltip_Item_Show_GeneralNormal(temp_InvenSlotNum, temp_ToolTipType, false)
  temp_InvenSlotNum = nil
  temp_ToolTipType = nil
end
function eventSellToNpcListRefresh()
  if false == global_IsTrading then
    return
  end
  for count = 1, tradeSellMarket.maxSellCount do
    tradeSellMarket:setShowTradeIcon(count, false)
  end
  global_sellItemFromPlayer()
end
function eventResizeSellList()
  local bodySizeY = _ItemPanel:GetSizeY()
  local sellPanelSizeY = getScreenSizeY() - Panel_Npc_Trade_Market:GetSizeY() - 80
  local showCount = 0
  local maxCount = 10
  local itemsSizeY = 0
  for count = 1, maxCount do
    if sellPanelSizeY > bodySizeY * count + (count - 1) * tradeSellMarket.intervalPanel then
      showCount = showCount + 1
      if maxCount == count then
        itemsSizeY = bodySizeY * count + (count - 1) * tradeSellMarket.intervalPanel
        break
      end
    else
      itemsSizeY = bodySizeY * (count - 1) + (count - 2) * tradeSellMarket.intervalPanel
      break
    end
  end
  tradeSellMarket.maxSellCount = showCount
  Panel_Trade_Market_Sell_ItemList:SetSize(Panel_Trade_Market_Sell_ItemList:GetSizeX(), itemsSizeY + tradeSellMarket.itemsStartPosY + 50)
  _btnSellAllItem:SetPosY(itemsSizeY + tradeSellMarket.itemsStartPosY + 50 + 5)
  _btnTradeGame:SetPosY(itemsSizeY + tradeSellMarket.itemsStartPosY + 50 + 5)
  if isNA then
    _btnTradeGame:SetSize(220, _btnTradeGame:GetSizeY())
    _btnSellAllItem:SetSize(220, _btnTradeGame:GetSizeY())
    _btnSellAllItem:SetPosX(_btnTradeGame:GetPosX())
    _btnSellAllItem:SetPosY(itemsSizeY + tradeSellMarket.itemsStartPosY + 50 + 5 + _btnTradeGame:GetSizeY())
  end
  _sellScroll:SetPosX(tradeSellMarket.ListBody[1]:GetPosX() + tradeSellMarket.ListBody[1]:GetSizeX() + 2)
  _sellScroll:SetPosY(tradeSellMarket.itemsStartPosY + 40)
  _sellScroll:SetSize(_sellScroll:GetSizeX(), itemsSizeY)
end
function TradeMarketSellList_SimpleToolTips(isShow, tipType, index)
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_TRADEPRICE")
    control = tradeSellMarket.tradePrice[index]
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_PROFITSTATIC")
    control = tradeSellMarket.profitStatic[index]
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_MARKETPRICE")
    control = tradeSellMarket.Quotation[index]
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_DISTANCEBONUS")
    control = tradeSellMarket.DistanceBonus[index]
  elseif 4 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_NOLINK")
    control = tradeSellMarket.noLink[index]
  elseif 5 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_EXPIRATION")
    control = tradeSellMarket.expiration[index]
  elseif 6 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_NOTDISTANCEBONUS")
    control = tradeSellMarket.DistanceNoBonus[index]
  elseif 7 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_DESERTBUFF")
    control = tradeSellMarket.desertBuff[index]
  elseif 8 == tipType then
    if nil == tradeSellMarket.ItemNameTable[index] then
      return
    end
    name = tradeSellMarket.ItemNameTable[index]
    control = tradeSellMarket.itemName[index]
  elseif 9 == tipType then
    local alchemySSW = ToClient_getAlchemyStatStaticStatus()
    if nil ~= alchemySSW then
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETLIST_LIFEPOWER_TOOLTIP_DESC", "rate", string.format("%.2f", alchemySSW._addRoyalTradeBonus / 10000))
    end
    name = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETLIST_LIFEPOWER_TOOLTIP_NAME")
    control = tradeSellMarket.lifePowerBuffIcon[index]
  elseif 10 == tipType then
    local cookingSSW = ToClient_getCookingStatStaticStatus()
    if nil ~= cookingSSW then
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETLIST_LIFEPOWER_TOOLTIP_DESC", "rate", string.format("%.2f", cookingSSW._addRoyalTradeBonus / 10000))
    end
    name = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETLIST_LIFEPOWER_TOOLTIP_NAME")
    control = tradeSellMarket.lifePowerBuffIcon[index]
  end
  if true == isShow then
    registTooltipControl(control, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
createSellItemList()
registerEvent("EventNpcShopUpdate", "eventSellToNpcListRefresh")
registerEvent("onScreenResize", "eventResizeSellList")

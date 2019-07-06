local _panel = Panel_TradeMarket_Goods
local UI_color = Defines.Color
local CONST_CALCULATE_PERCENT_VALUE = 10000
local LIMITED_SELLMONEY = 1000000000
local TradeMarketGoods = {
  _ui = {
    stc_TitleBg = UI.getChildControl(_panel, "Static_TitleBg"),
    list_GoodsList = UI.getChildControl(_panel, "List2_GoodsList"),
    stc_InfoBg = UI.getChildControl(_panel, "Static_InfoBg"),
    stc_BottomBG = UI.getChildControl(_panel, "Static_BottomBG")
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = false,
    createCash = true
  },
  _goodsItemList = {},
  _goodsSlotList = {},
  _sellData = nil,
  _realPriceList = {},
  _isExistNoLink = false,
  _currentSellCount = 0,
  _keyguideAlignTop = {},
  _keyguideAlignBottom = {},
  _sellInfo = {_sellCount, _sellTime}
}
function TradeMarketGoods:init()
  self._ui.txt_XConsole = UI.getChildControl(self._ui.stc_BottomBG, "StaticText_X_ConsoleUI")
  self._ui.txt_XConsole:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_TRADLESELLMARKETALL"))
  self._ui.txt_YConsole = UI.getChildControl(self._ui.stc_BottomBG, "StaticText_Y_ConsoleUI")
  self._keyguideAlignTop = {
    self._ui.txt_XConsole,
    self._ui.txt_YConsole
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguideAlignTop, self._ui.stc_BottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, 44, 5)
  self._ui.txt_AConsole = UI.getChildControl(self._ui.stc_BottomBG, "StaticText_A_ConsoleUI")
  self._ui.txt_BConsole = UI.getChildControl(self._ui.stc_BottomBG, "StaticText_B_ConsoleUI")
  self._keyguideAlignBottom = {
    self._ui.txt_AConsole,
    self._ui.txt_BConsole
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguideAlignBottom, self._ui.stc_BottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, 44, 5)
  self._ui.stc_MarketCondition = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_MarketCondition")
  self._ui.stc_Guarantee = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_PriceGuarantee")
  self._ui.stc_Origin = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_Origin")
  self._ui.stc_Transaction = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_TransactionPrice")
  self._ui.stc_Profit = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_Profit")
  self._ui.stc_DistanceBonus = UI.getChildControl(self._ui.stc_InfoBg, "StaticText_DistanceBonus")
  self._ui.stc_MarketCondition:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_AVG_NAME"))
  self._ui.stc_Guarantee:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_EXPIRATION"))
  self._ui.stc_Origin:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_NOLINK"))
  self._ui.stc_Transaction:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_TRADEPRICE"))
  self._ui.stc_Profit:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_PROFITSTATIC"))
  self._ui.stc_DistanceBonus:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_DISTANCEBONUS"))
  self:registEvent()
  PaGlobal_TradeMarketGoods_OnResize()
end
function TradeMarketGoods:registEvent()
  self._ui.list_GoodsList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_TradeMarketGoods_CreateList")
  self._ui.list_GoodsList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  registerEvent("FromClient_ServantInventoryUpdate", "PaGlobal_TradeMarketGoods_Update")
  registerEvent("EventNpcShopUpdate", "PaGlobal_TradeMarketGoods_Update")
  registerEvent("onScreenResize", "PaGlobal_TradeMarketGoods_OnResize")
end
function TradeMarketGoods:open()
  local talker = dialog_getTalker()
  if nil ~= talker then
    local actorKeyRaw = talker:getActorKey()
    local characterSS = getNpcActor(actorKeyRaw):get():getCharacterStaticStatus()
    if true == characterSS:isSmuggleMerchant() then
      return
    end
  end
  _sellInfo = {_sellCount, _sellTime}
  self:update()
  _panel:SetShow(true)
end
function TradeMarketGoods:close()
  self._isExistNoLink = false
  self._currentSellCount = 0
  self._sellData = nil
  _sellInfo = {_sellCount, _sellTime}
  _panel:SetShow(false)
end
function TradeMarketGoods:update()
  if false == PaGlobal_GetIsTrading() then
    return
  end
  local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
  local characterStaticStatus = characterStaticStatusWrapper:get()
  if true == characterStaticStatus:isTerritorySupplyMerchant() then
    self._ui.txt_AConsole:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_SELLMARKET"))
    self._ui.txt_XConsole:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_SELLALLITEM"))
  else
    self._ui.txt_AConsole:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_TRADLESELLMARKET"))
    self._ui.txt_XConsole:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_TRADLESELLMARKETALL"))
  end
  local mySellCount = npcShop_getSellCount()
  local vehicleSellCount = npcShop_getVehicleSellCount()
  local isValidDistance = getDistanceFromVehicle()
  if false == isValidDistance then
    vehicleSellCount = 0
  end
  local sellCount = mySellCount + vehicleSellCount
  self._currentSellCount = sellCount
  local isDoingSell = false
  local guideMonotone = true
  if sellCount > 0 then
    guideMonotone = false
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobal_TradeMarketGoods_SellAllItem()")
    if true == PaGlobal_BiddingGame_GetSuccess() or true == characterStaticStatus:isSupplyMerchant() or characterStaticStatus:isTerritorySupplyMerchant() or characterStaticStatus:isFishSupplyMerchant() then
      self._ui.txt_YConsole:SetShow(false)
      _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
    else
      self._ui.txt_YConsole:SetShow(true)
      _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobal_TradeMarketGoods_BiddingGameStart()")
      if self._sellInfo._sellTime and getTickCount32() - self._sellInfo._sellTime < 10000 then
        isDoingSell = true
      elseif self._sellInfo._sellTime then
        self._sellInfo = {_sellCount, _sellTime}
      elseif self._sellInfo._sellCount and 0 < self._sellInfo._sellCount then
        isDoingSell = true
      end
    end
  else
    guideMonotone = true
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
  end
  self._ui.txt_XConsole:SetMonoTone(guideMonotone)
  self._ui.txt_YConsole:SetMonoTone(guideMonotone)
  self._ui.txt_AConsole:SetMonoTone(guideMonotone)
  if true == isDoingSell then
    self._ui.txt_YConsole:SetMonoTone(true)
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguideAlignTop, self._ui.stc_BottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, 44, 5)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguideAlignBottom, self._ui.stc_BottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, 44, 5)
  local totalGoodsCount = 0
  local totalGoodsTable = {}
  local charInvenIdx = 0
  for charInvenIdx = 0, mySellCount - 1 do
    local shopItemWrapper = npcShop_getItemSell(charInvenIdx)
    local itemKey = shopItemWrapper:getStaticStatus():get()._key:get()
    local table = {}
    table._key = itemKey
    table._isServant = false
    table._itemNum = charInvenIdx
    totalGoodsTable[totalGoodsCount] = table
    totalGoodsCount = totalGoodsCount + 1
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local servantInfo = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
  if nil ~= servantInfo and vehicleSellCount > 0 then
    local servantInventory = servantInfo:getInventory()
    if nil ~= servantInventory then
      local servantInventorySize = servantInventory:size()
      local servantGoodsIdx = 0
      for slotIdx = 0, servantInventorySize - 1 do
        if false == servantInventory:empty(slotIdx) then
          if vehicleSellCount <= servantGoodsIdx then
            break
          end
          local servantItemWrapper = npcShop_getVehicleSellItem(servantGoodsIdx)
          local itemStaticStaus = servantItemWrapper:getStaticStatus()
          if true == itemStaticStaus:isForJustTrade() then
            local itemKey = itemStaticStaus:get()._key:get()
            local table = {}
            table._key = itemKey
            table._isServant = true
            table._itemNum = servantGoodsIdx
            totalGoodsTable[totalGoodsCount] = table
            servantGoodsIdx = servantGoodsIdx + 1
            totalGoodsCount = totalGoodsCount + 1
          end
        end
      end
    end
  end
  for goodsIdx = 0, totalGoodsCount - 1 do
    local itemKey = totalGoodsTable[goodsIdx]._key
    local selfPlayer = getSelfPlayer()
    local inventory = selfPlayer:get():getInventory()
    local tradeItemWrapper = npcShop_getTradeItem(itemKey)
    local characterStaticStatus = npcShop_getCurrentCharacterKeyForTrade():get()
    local isSupplyMerchant = characterStaticStatus:isSupplyMerchant()
    local isFishSupplyMerchant = characterStaticStatus:isFishSupplyMerchant()
    local selfPlayerRegion = getRegionInfoByPosition(selfPlayer:get():getPosition())
    local selfPlayerPosition = selfPlayerRegion:get():getTradeOriginRegion():getWaypointInGamePosition()
    local bigHand = 1000000 ~= selfPlayer:get():getlTradeItemCountRate()
    local isExistTradeOrigin = true
    local profitItemGold = toInt64(0, 0)
    local f_sellRate = tradeItemWrapper:getSellPriceRate()
    local s64_inventoryItemCount = toInt64(0, 0)
    local s64_TradeItemNo = toInt64(0, 0)
    local itemValueType
    local invenType = 0
    if true == totalGoodsTable[goodsIdx]._isServant then
      if nil == servantInfo then
        break
      end
      local vehicleInven = getVehicleActor(servantInfo:getActorKeyRaw()):get():getInventory()
      s64_TradeItemNo = npcShop_getVehicleInvenItemNoByShopSlotNo(totalGoodsTable[goodsIdx]._itemNum)
      s64_inventoryItemCount = vehicleInven:getItemCountByItemNo_s64(s64_TradeItemNo)
      itemValueType = vehicleInven:getItemByItemNo(s64_TradeItemNo)
      invenType = 4
    else
      s64_TradeItemNo = npcShop_getItemNo(totalGoodsTable[goodsIdx]._itemNum)
      s64_inventoryItemCount = inventory:getItemCountByItemNo_s64(s64_TradeItemNo)
      itemValueType = inventory:getItemByItemNo(s64_TradeItemNo)
      invenType = 0
    end
    local regionInfo = itemValueType:getItemRegionInfo()
    local fromPosition = float3(0, 0, 0)
    if 0 ~= regionInfo._waypointKey then
      fromPosition = regionInfo:getWaypointInGamePosition()
    end
    if nil == tradeItemWrapper:get() then
      _PA_ASSERT(false, "npcShop_getTradeItem \234\176\128 nil \236\158\133\235\139\136\235\139\164!! : PaGlobal_TradeMarketGoods_CreateList")
      return
    end
    local expirationIndex
    local itemExpiration = itemValueType:getExpirationDate()
    if itemExpiration:isDefined() and false == itemExpiration:isIndefinite() then
      local s64_Time = itemExpiration:get_s64()
      local s64_remainTime = getLeftSecond_s64(itemExpiration)
      if Defines.s64_const.s64_0 == s64_remainTime then
        expirationIndex = 1
      else
        expirationIndex = 0
      end
    else
      expirationIndex = -1
    end
    local leftPeriod = FromClient_getTradeItemExpirationDate(itemExpiration, tradeItemWrapper:getStaticStatus():get()._expirationPeriod)
    if true == isFishSupplyMerchant and leftPeriod > 300000 then
      leftPeriod = 1000000
    end
    local displayPeriod = leftPeriod / CONST_CALCULATE_PERCENT_VALUE
    local realPrice = 0
    if false == isSupplyMerchant and false == isFishSupplyMerchant then
      realPrice = getCalculateTradeItemPrice(tradeItemWrapper:getTradeSellPrice(), tradeItemWrapper:getStaticStatus():getCommerceType(), fromPosition, selfPlayerPosition, tradeItemWrapper:getTradeGroupType(), characterStaticStatus:getTradeGroupType(), leftPeriod, PaGlobal_BiddingGame_GetSuccess() or bigHand)
    else
      realPrice = tradeItemWrapper:getTradeSellPrice()
    end
    local fromToDistanceNavi = 0
    if 0 ~= regionInfo._waypointKey then
      fromToDistanceNavi = getFromToDistanceTradeShop()
    else
      isExistTradeOrigin = false
    end
    local bonusPercent = 0
    bonusPercent = math.floor(fromToDistanceNavi / 100 * FromClient_getTradeBonusPercent())
    bonusPercent = math.min(bonusPercent, FromClient_getTradeMaxDistancePercent())
    local isLinkedNode = npcShop_CheckLinkedItemExplorationNode(totalGoodsTable[goodsIdx]._itemNum, invenType)
    local isNodeFreeTrade = tradeItemWrapper:getStaticStatus():get():isNodeFreeTrade()
    if isNodeFreeTrade then
      isLinkedNode = true
    end
    if false == isLinkedNode then
      self._isExistNoLink = true
      realPrice = Int64toInt32(tradeItemWrapper:getStaticStatus():get()._originalPrice_s64) * getNotLinkNodeSellPercent() / CONST_CALCULATE_PERCENT_VALUE / 100
      f_sellRate = getNotLinkNodeSellPercent() / CONST_CALCULATE_PERCENT_VALUE
      if false == isExistTradeOrigin then
        realPrice = Int64toInt32(tradeItemWrapper:getStaticStatus():get()._originalPrice_s64)
        f_sellRate = 100
      end
      profitItemGold = toInt64(0, realPrice) - itemValueType:getBuyingPrice()
    else
      profitItemGold = realPrice - itemValueType:getBuyingPrice()
    end
    local itemData = {}
    itemData.itemKey = itemKey
    itemData.sellRate = f_sellRate
    itemData.realPrice = realPrice
    itemData.displayPeriod = displayPeriod
    itemData.bonusPercent = bonusPercent
    itemData.profitItemGold = profitItemGold
    itemData.leftCount = s64_inventoryItemCount
    itemData.isServant = totalGoodsTable[goodsIdx]._isServant
    itemData.invenNum = totalGoodsTable[goodsIdx]._itemNum
    itemData.inventoryType = invenType
    self._goodsItemList[goodsIdx] = itemData
    self._realPriceList[goodsIdx] = Int64toInt32(realPrice)
  end
  self._ui.list_GoodsList:getElementManager():clearKey()
  for index = 0, sellCount - 1 do
    self._ui.list_GoodsList:getElementManager():pushKey(toInt64(0, index))
  end
end
function PaGlobal_TradeMarketGoods_Open()
  local self = TradeMarketGoods
  self:open()
end
function PaGlobal_TradeMarketGoods_Close()
  local self = TradeMarketGoods
  self:close()
end
function PaGlobal_TradeMarketGoods_Update()
  local self = TradeMarketGoods
  self:update()
end
function PaGlobal_TradeMarketGoods_CreateList(content, key)
  local self = TradeMarketGoods
  local goodsIdx = Int64toInt32(key)
  local itemData = self._goodsItemList[goodsIdx]
  if nil == itemData then
    return
  end
  local tradeItemWrapper = npcShop_getTradeItem(itemData.itemKey)
  local itemSSW = tradeItemWrapper:getStaticStatus()
  local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
  local characterStaticStatus = characterStaticStatusWrapper:get()
  local itemWrapper
  if true == itemData.isServant then
    itemWrapper = npcShop_getVehicleItemWrapper(itemData.invenNum)
  else
    itemWrapper = npcShop_getItemWrapperByShopSlotNo(itemData.invenNum)
  end
  local f_sellRate = itemData.sellRate
  local realPrice = itemData.realPrice
  local displayPeriod = itemData.displayPeriod
  local bonusPercent = itemData.bonusPercent
  local profitItemGold = itemData.profitItemGold
  local stc_Bg = UI.getChildControl(content, "Static_Bg")
  local stc_ItemSlotBg = UI.getChildControl(content, "Static_ItmeSlotBg")
  local txt_ItemName = UI.getChildControl(content, "StaticText_ItemName")
  local txt_MarketCondition = UI.getChildControl(content, "StaticText_MarketCondition")
  local txt_Guarantee = UI.getChildControl(content, "StaticText_PriceGuarantee")
  local txt_Origin = UI.getChildControl(content, "StaticText_Origin")
  local txt_TransactionPrice = UI.getChildControl(content, "StaticText_TransactionPrice")
  local txt_Profit = UI.getChildControl(content, "StaticText_Profit")
  local txt_Distance = UI.getChildControl(content, "StaticText_DistanceBonus")
  local stc_Icon = UI.getChildControl(stc_ItemSlotBg, "Static_ItemIcon")
  local stc_Count = UI.getChildControl(stc_ItemSlotBg, "StaticText_ItemCount")
  local txt_BiddingBonus = UI.getChildControl(content, "StaticText_BiddingBonus")
  local txt_OriginValue = UI.getChildControl(content, "StaticText_Origin_Value")
  local distanceBonusString = bonusPercent / CONST_CALCULATE_PERCENT_VALUE - bonusPercent / CONST_CALCULATE_PERCENT_VALUE % 1 .. "%"
  local str_sellRate = string.format("%.f", itemData.sellRate)
  local str_sellRate_Value = PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TradeMarketSellList_Percents", "Percent", str_sellRate)
  if 100 < tonumber(tostring(str_sellRate)) then
    str_sellRate_Value = "<PAColor0xFFFFCE22>" .. str_sellRate_Value .. "\226\150\178<PAOldColor>"
  else
    str_sellRate_Value = "<PAColor0xFFF26A6A>" .. str_sellRate_Value .. "\226\150\188<PAOldColor>"
  end
  stc_Icon:ChangeTextureInfoNameAsync("Icon/" .. itemSSW:getIconPath())
  txt_ItemName:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  txt_ItemName:SetText(itemSSW:getName())
  if true == itemSSW:isStackable() then
    stc_Count:SetText(tostring(itemWrapper:get():getCount_s64()))
    stc_Count:SetShow(true)
  else
    stc_Count:SetShow(false)
  end
  txt_MarketCondition:SetText(str_sellRate_Value)
  txt_TransactionPrice:SetText(makeDotMoney(Int64toInt32(realPrice)))
  txt_Guarantee:SetText(tostring(displayPeriod) .. "%")
  txt_Distance:SetText(distanceBonusString)
  if true == characterStaticStatus:isSupplyMerchant() or true == characterStaticStatus:isFishSupplyMerchant() then
    txt_Distance:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_NOTAPPLY"))
  end
  txt_OriginValue:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  txt_OriginValue:SetText(itemWrapper:getProductionRegion())
  if profitItemGold < toInt64(0, 0) then
    local profitItemGold_abs = toInt64(0, math.abs(Int64toInt32(profitItemGold)))
    txt_Profit:SetFontColor(UI_color.C_FFD20000)
    txt_Profit:SetText("-" .. makeDotMoney(profitItemGold_abs))
  else
    txt_Profit:SetFontColor(UI_color.C_FFFFCE22)
    txt_Profit:SetText(makeDotMoney(profitItemGold))
  end
  if true == PaGlobal_BiddingGame_GetSuccess() then
    txt_BiddingBonus:SetText("- " .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_TRADEGAME"))
    txt_BiddingBonus:SetShow(true)
  else
    txt_BiddingBonus:SetShow(false)
  end
  stc_Bg:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_TradeMarketGoods_SellItem(" .. goodsIdx .. ")")
end
function PaGlobal_TradeMarketGoods_SellItem(goodsIdx)
  local self = TradeMarketGoods
  local param = goodsIdx
  Panel_NumberPad_Show(true, self._goodsItemList[goodsIdx].leftCount, param, PaGlobal_TradeMarketGoods_SellItemContinue)
end
function PaGlobal_TradeMarketGoods_SellItemContinue(inputNumber, param)
  local self = TradeMarketGoods
  local goodsIdx = param
  local itemData = self._goodsItemList[goodsIdx]
  local inventory = getSelfPlayer():get():getInventory()
  local s64_TradeItemNo = toInt64(0, 0)
  local s64_inventoryItemCount = toInt64(0, 0)
  local itemValueType, regionInfo, itemWrapper
  local talker = dialog_getTalker()
  if nil ~= talker then
    local actorKeyRaw = talker:getActorKey()
    local actorProxy = getNpcActor(actorKeyRaw):get()
    local characterStaticStatus = actorProxy:getCharacterStaticStatus()
    if (true == characterStaticStatus:isSupplyMerchant() or true == characterStaticStatus:isFishSupplyMerchant()) and 0 < math.floor(Int64toInt32(inventory:getWeight_s64()) / Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64())) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Weight"))
      return
    end
  end
  if 0 == itemData.inventoryType then
    s64_TradeItemNo = npcShop_getItemNo(itemData.invenNum)
    s64_inventoryItemCount = inventory:getItemCountByItemNo_s64(s64_TradeItemNo)
    itemValueType = inventory:getItemByItemNo(s64_TradeItemNo)
    regionInfo = itemValueType:getItemRegionInfo()
    itemWrapper = npcShop_getItemSell(itemData.invenNum)
  elseif 4 == itemData.inventoryType then
    local myLandVehicleActorKey, landVehicleActorProxy
    local temporaryWrapper = getTemporaryInformationWrapper()
    local servantInfo = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
    if nil ~= servantInfo then
      s64_TradeItemNo = npcShop_getVehicleInvenItemNoByShopSlotNo(itemData.invenNum)
      myLandVehicleActorKey = servantInfo:getActorKeyRaw()
      if nil ~= myLandVehicleActorKey then
        landVehicleActorProxy = getVehicleActor(myLandVehicleActorKey)
      end
      local vehicleInven = landVehicleActorProxy:get():getInventory()
      s64_inventoryItemCount = vehicleInven:getItemCountByItemNo_s64(s64_TradeItemNo)
      itemValueType = vehicleInven:getItemByItemNo(s64_TradeItemNo)
      regionInfo = itemValueType:getItemRegionInfo()
    end
    itemWrapper = npcShop_getVehicleSellItem(itemData.invenNum)
  end
  if nil == itemWrapper then
    _PA_ASSERT(false, "itemWrapper\234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PaGlobal_TradeMarketGoods_SellItemContinue")
    return
  end
  PaGlobal_TutorialManager:handleTradeMarketSellSomeConfirm(itemWrapper:getStaticStatus():get()._key:getItemKey())
  local tradeType = itemWrapper:getStaticStatus():get()._tradeType
  local isLinkedNode = npcShop_CheckLinkedItemExplorationNode(itemData.invenNum, itemData.inventoryType)
  local sellData = {
    tradeType = tradeType,
    invenNum = itemData.invenNum,
    inputNumber = inputNumber,
    inventoryType = itemData.inventoryType
  }
  self._sellData = sellData
  if false == isLinkedNode and 0 ~= regionInfo._waypointKey then
    local itemWrapper
    if 0 == itemData.inventoryType then
      itemWrapper = npcShop_getItemWrapperByShopSlotNo(itemData.invenNum)
    elseif 4 == itemData.inventoryType then
      itemWrapper = npcShop_getVehicleItemWrapper(itemData.invenNum)
    end
    if nil ~= itemWrapper then
      local characterStaticStatus = npcShop_getCurrentCharacterKeyForTrade():get()
      if true == characterStaticStatus:isSupplyMerchant() then
        PaGlobal_TradeMarketGoods_SellComplete()
        return
      end
      local isNodeFreeTrade = itemWrapper:getStaticStatus():get():isNodeFreeTrade()
      if true == isNodeFreeTrade then
        PaGlobal_TradeMarketGoods_SellComplete()
      else
        local talker = dialog_getTalker()
        local nodeString = PAGetStringParam3(Defines.StringSheet_GAME, "Lua_TradeMarketSellList_NeedNodeLink", "exploreNode1", talker:getExplorationNodeName(), "exploreNode2", itemWrapper:getProductionRegion(), "sellPercent", getNotLinkNodeSellPercent() / CONST_CALCULATE_PERCENT_VALUE)
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketSellList_NeedNodeLinkTitle"),
          content = nodeString,
          functionYes = PaGlobal_TradeMarketGoods_SellComplete,
          functionCancel = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
      end
    end
  else
    local rv
    if 5 == tradeType then
      rv = npcShop_doSellInTradeShop(itemData.invenNum, Int64toInt32(inputNumber), itemData.inventoryType, 14)
    else
      rv = npcShop_doSellInTradeShop(itemData.invenNum, Int64toInt32(inputNumber), itemData.inventoryType, 0)
    end
    if 0 == rv then
    end
  end
end
function PaGlobal_TradeMarketGoods_SellComplete()
  local self = TradeMarketGoods
  if nil == self._sellData then
    return
  end
  if nil == self._sellData.tradeType then
    self._sellData.tradeType = 0
  end
  if 5 == self._sellData.tradeType then
    npcShop_doSellInTradeShop(self._sellData.invenNum, Int64toInt32(self._sellData.inputNumber), self._sellData.inventoryType, 14)
  else
    npcShop_doSellInTradeShop(self._sellData.invenNum, Int64toInt32(self._sellData.inputNumber), self._sellData.inventoryType, 0)
  end
end
function PaGlobal_TradeMarketGoods_SellAllItem()
  local self = TradeMarketGoods
  local messageBoxMemo = ""
  if true == self._isExistNoLink then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketSellList_TradeItemAllSellQuestion_NodeLink")
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketSellList_TradeItemAllSellQuestion")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketSellList_NeedNodeLinkTitle"),
    content = messageBoxMemo,
    functionYes = PaGlobal_TradeMarketGoods_SellAllContinue,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_TradeMarketGoods_SellAllContinue()
  local self = TradeMarketGoods
  self._ui.txt_YConsole:SetMonoTone(true)
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
  local inventory = getSelfPlayer():get():getInventory()
  local s64_inventoryItemCount = toInt64(0, 0)
  local s64_TradeItemNo = toInt64(0, 0)
  local temporaryWrapper = getTemporaryInformationWrapper()
  local servantInfo = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
  local sellCount = 0
  local talker = dialog_getTalker()
  if nil ~= talker then
    local actorKeyRaw = talker:getActorKey()
    local actorProxy = getNpcActor(actorKeyRaw):get()
    local characterStaticStatus = actorProxy:getCharacterStaticStatus()
    if (true == characterStaticStatus:isSupplyMerchant() or true == characterStaticStatus:isFishSupplyMerchant()) and 0 < math.floor(Int64toInt32(inventory:getWeight_s64()) / Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64())) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Weight"))
      return
    end
  end
  local myInventortySellAbleCount = npcShop_getSellCount()
  local priceIndex = 0
  for goodsIdx = 0, myInventortySellAbleCount do
    local shopItemWrapper = npcShop_getItemSell(goodsIdx)
    if nil ~= shopItemWrapper then
      local tradeType = shopItemWrapper:getStaticStatus():get()._tradeType
      s64_TradeItemNo = npcShop_getItemNo(goodsIdx)
      s64_inventoryItemCount = inventory:getItemCountByItemNo_s64(s64_TradeItemNo)
      if 5 == tradeType then
        npcShop_doSellInTradeShop(goodsIdx, Int64toInt32(s64_inventoryItemCount), 0, 14)
        priceIndex = priceIndex + 1
        sellCount = sellCount + 1
      else
        local realPrice = self._realPriceList[priceIndex]
        if nil == realPrice then
          realPrice = 150000
        end
        local myInvenMoney = Int64toInt32(getSelfPlayer():get():getInventory():getMoney_s64())
        local limitCount = math.floor((LIMITED_SELLMONEY - myInvenMoney) / realPrice)
        priceIndex = priceIndex + 1
        npcShop_doSellInTradeShop(goodsIdx, Int64toInt32(s64_inventoryItemCount), 0, 0)
        sellCount = sellCount + 1
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
          if nil ~= s64_VehicleItemNo then
            local vehicleItemCount = Int64toInt32(servertinventory:getItemCountByItemNo_s64(s64_VehicleItemNo))
            local servertItemWrapper = npcShop_getVehicleSellItem(slotCount - 2 - emptyCount)
            if nil ~= servertItemWrapper then
              local realPrice = self._realPriceList[priceIndex]
              if nil == realPrice then
                realPrice = 150000
              end
              local myInvenMoney = Int64toInt32(getSelfPlayer():get():getInventory():getMoney_s64())
              local limitCount = math.floor((LIMITED_SELLMONEY - myInvenMoney) / realPrice)
              priceIndex = priceIndex + 1
              npcShop_doSellInTradeShop(slotCount - 2 - emptyCount, vehicleItemCount, 4, 0)
              sellCount = sellCount + 1
            end
          end
        else
          emptyCount = emptyCount + 1
        end
      end
    end
  end
  PaGlobal_TutorialManager:handleClickedTradeItemAllSell(talker)
  PaGlobal_BiddingGame_Close()
  self._isExistNoLink = false
  self._currentSellCount = 0
  self._sellInfo._sellCount = sellCount
  self._sellInfo._sellTime = getTickCount32()
end
function PaGlobal_TradeMarketGoods_BiddingGameStart()
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
  local self = TradeMarketGoods
  local useStartSlot = inventorySlotNoUserStart()
  local invenUseSize = selfPlayer:get():getInventorySlotCount(true)
  local inventory = selfPlayer:get():getInventoryByType(CppEnums.ItemWhereType.eInventory)
  local invenMaxSize = inventory:sizeXXX()
  local freeCount = inventory:getFreeCount()
  if invenUseSize - useStartSlot <= invenUseSize - freeCount - useStartSlot then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_DONTPLAYGAME"))
    return
  end
  if 0 >= self._currentSellCount then
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
  local wp = selfPlayer:getWp()
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
    functionYes = PaGlobal_TradeMarketGoods_BiddingGameContinue,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_TradeMarketGoods_BiddingGameContinue()
  local talker = dialog_getTalker()
  if nil == talker then
    return
  end
  ToClient_TradeGameStart(talker:getActorKey())
end
function PaGlobal_TradeMarketGoods_GetSellCount()
  local self = TradeMarketGoods
  return self._currentSellCount
end
function PaGlobal_TradeMarketGoods_OnResize()
  local self = TradeMarketGoods
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local panelSizeX = _panel:GetSizeX()
  local panelSizeY = _panel:GetSizeY()
  _panel:SetSize(panelSizeX, screenSizeY)
  _panel:ComputePos()
  self._ui.stc_TitleBg:ComputePos()
  self._ui.stc_BottomBG:ComputePos()
  self._ui.stc_InfoBg:ComputePos()
end
function PaGlobal_TradeMarketGoods_Init()
  local self = TradeMarketGoods
  self:init()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_TradeMarketGoods_Init")
function global_tradeSellListOpen()
  PaGlobal_TradeMarketGoods_Open()
end
function global_sellItemFromPlayer()
  PaGlobal_TradeMarketGoods_Update()
end

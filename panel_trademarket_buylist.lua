local UI_LifeString = CppEnums.LifeExperienceString
local VCK = CppEnums.VirtualKeyCode
Panel_Trade_Market_BuyItemList:SetShow(false, false)
Panel_Trade_Market_BuyItemList:SetAlpha(1)
Panel_Trade_Market_BuyItemList:setGlassBackground(true)
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local _ItemPanel = UI.getChildControl(Panel_Trade_Market_BuyItemList, "Static_Panel")
local _SlotBG = UI.getChildControl(Panel_Trade_Market_BuyItemList, "Static_Slot")
local _ItemIcon = UI.getChildControl(Panel_Trade_Market_BuyItemList, "Static_Icon")
local _RemainCount = UI.getChildControl(Panel_Trade_Market_BuyItemList, "StaticText_remainCount")
local _ItemName = UI.getChildControl(Panel_Trade_Market_BuyItemList, "StaticText_itemName")
local _SellPrice = UI.getChildControl(Panel_Trade_Market_BuyItemList, "StaticText_sellPrice")
local _QuotationRate = UI.getChildControl(Panel_Trade_Market_BuyItemList, "StaticText_QuotationRate")
local _AddCard = UI.getChildControl(Panel_Trade_Market_BuyItemList, "Button_AddCart")
local _showTrade = UI.getChildControl(Panel_Trade_Market_BuyItemList, "Button_TradeInfoShow")
local _expiration = UI.getChildControl(Panel_Trade_Market_BuyItemList, "StaticText_Option")
local _TitleName = UI.getChildControl(Panel_Trade_Market_BuyItemList, "StaticText_BuyListTitle")
local _buyingCondition = UI.getChildControl(Panel_Trade_Market_BuyItemList, "StaticText_BuyingCondition")
local _supply = UI.getChildControl(Panel_Trade_Market_BuyItemList, "StaticText_Supply")
local _descBg = UI.getChildControl(Panel_Trade_Market_BuyItemList, "Static_DescBg")
local _desc = UI.getChildControl(Panel_Trade_Market_BuyItemList, "StaticText_Desc")
_ItemPanel:SetShow(false, true)
_SlotBG:SetShow(false, true)
_ItemIcon:SetShow(false, true)
_RemainCount:SetShow(false, true)
_ItemName:SetShow(false, true)
_SellPrice:SetShow(false, true)
_QuotationRate:SetShow(false, true)
_AddCard:SetShow(false, true)
_showTrade:SetShow(false, true)
_buyingCondition:SetShow(false, true)
_supply:SetShow(false)
_ItemName:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
_desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
_desc:SetText(_desc:GetText())
_descBg:SetSize(_descBg:GetSizeX(), math.max(_descBg:GetSizeY(), _desc:GetTextSizeY() + 10))
local tradeBuyMarket = {
  isTradeMode = 0,
  iconSizeCalcX = 260,
  iconSizeCalcY = 190,
  maxSellCount = 9,
  enCommerceIndex = -1,
  isOpenShop = false,
  isInitialized = false,
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = false,
    createCash = true
  },
  ListBody = {},
  itemSlot_BG = {},
  remainCount = {},
  itemName = {},
  sellPrice = {},
  Quotation = {},
  AddCart = {},
  trendShow = {},
  expiration = {},
  buyingCondition = {},
  itemEnchantKey = {},
  itemIndex = {},
  supply = {},
  icons = {}
}
local territoryName = {
  [0] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_0")),
  [1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_1")),
  [2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_2")),
  [3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_3")),
  [4] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_4")),
  [5] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_5")),
  [6] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_6")),
  [7] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_7"))
}
function global_buyListExit()
  if Panel_Trade_Market_BuyItemList:IsShow() then
    Panel_Trade_Market_BuyItemList:SetShow(false)
  end
  tradeBuyMarket.enCommerceIndex = -1
end
function global_isShopOpen()
  return tradeBuyMarket.isOpenShop
end
function global_buyListOpen(enCommerceIndex)
  local rv = npcShop_CheckBuyListByCommerceType(enCommerceIndex)
  if false == rv then
    return
  end
  tradeBuyMarket.enCommerceIndex = enCommerceIndex
  Panel_Trade_Market_BuyItemList:SetShow(true)
  for count = 1, tradeBuyMarket.maxSellCount do
    tradeBuyMarket:setShowTradeIcon(count, false)
  end
  global_setBuyList()
end
local tradeBuyMarketList_Position = function()
  local basePosX = Panel_Trade_Market_Graph_Window:GetSizeX() + 50
  Panel_Trade_Market_BuyItemList:SetPosX(basePosX)
end
function global_setBuyList()
  tradeBuyMarketList_Position()
  local sellCount = npcShop_getBuyCount()
  local commerceIndex = 1
  local itemOrderIndex
  for index = 1, sellCount do
    if -1 ~= tradeBuyMarket.enCommerceIndex then
      itemOrderIndex = index - 1
      local itemwrapper = npcShop_getItemBuy(itemOrderIndex)
      local itemSell = itemwrapper:get()
      local itemStatus = itemwrapper:getStaticStatus()
      local itemCommerceType = itemStatus:getCommerceType()
      if itemCommerceType == tradeBuyMarket.enCommerceIndex or enCommerceType.enCommerceType_Max == tradeBuyMarket.enCommerceIndex then
        if commerceIndex > tradeBuyMarket.maxSellCount then
          return
        end
        tradeBuyMarket:setShowTradeIcon(commerceIndex, true)
        local itemSS = itemStatus:get()
        tradeBuyMarket.itemEnchantKey[commerceIndex] = itemSS._key:get()
        tradeBuyMarket.itemIndex[commerceIndex] = itemOrderIndex
        local originalPrice = itemStatus:getOriginalPriceByInt64()
        local tradeItemWrapper = npcShop_getTradeItem(tradeBuyMarket.itemEnchantKey[commerceIndex])
        local sellRate = string.format("%.f", npcShop_GetTradeGraphRateOfPrice(itemSS._key:get()))
        local buyableStack = tradeItemWrapper:get():calculateRemainCount()
        tradeBuyMarket:setBuyItemDataInfo(commerceIndex, itemStatus:getName(), itemSell.leftCount_s64, tradeItemWrapper, buyableStack, sellRate)
        tradeBuyMarket.icons[commerceIndex]:setItemByStaticStatus(itemwrapper:getStaticStatus())
        tradeBuyMarket.icons[commerceIndex].icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. itemOrderIndex .. ", \"tradeMarket_Buy\", true)")
        tradeBuyMarket.icons[commerceIndex].icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. itemOrderIndex .. ", \"tradeMarket_Buy\", false)")
        Panel_Tooltip_Item_SetPosition(itemOrderIndex, tradeBuyMarket.icons[commerceIndex], "tradeMarket_Buy")
        if 0 == itemStatus:get()._expirationPeriod then
          tradeBuyMarket.expiration[commerceIndex]:SetShow(false)
        end
        tradeBuyMarket.expiration[commerceIndex]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_WARRANTY", "expirationPeriod", tostring(tradeItemWrapper:getStaticStatus():get()._expirationPeriod / 60)))
        tradeBuyMarket.expiration[commerceIndex]:addInputEvent("Mouse_On", "TradeBuyMarket_SimpleTooltip( true, " .. commerceIndex .. ", 0 )")
        tradeBuyMarket.expiration[commerceIndex]:addInputEvent("Mouse_Out", "TradeBuyMarket_SimpleTooltip( false, " .. commerceIndex .. ", 0 )")
        local territorySupplyKey
        if _ContentsGroup_isUsedNewTradeEventNotice then
          territorySupplyKey = FGlobal_TradeEventNotice_Renewal_GetTerritorySupplyIndex(tradeBuyMarket.itemEnchantKey[commerceIndex])
        else
          territorySupplyKey = FGlobal_TradeSupplyItemInfo_Compare(tradeBuyMarket.itemEnchantKey[commerceIndex])
        end
        if nil ~= territorySupplyKey then
          tradeBuyMarket.supply[commerceIndex]:SetShow(true)
          local supplyText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_SUPPLY", "territoryName", territoryName[territorySupplyKey])
          tradeBuyMarket.supply[commerceIndex]:SetText("")
          tradeBuyMarket.supply[commerceIndex]:addInputEvent("Mouse_On", "TradeBuyMarket_SimpleTooltip( true, " .. commerceIndex .. ", 1, " .. territorySupplyKey .. " )")
          tradeBuyMarket.supply[commerceIndex]:addInputEvent("Mouse_Out", "TradeBuyMarket_SimpleTooltip( false, " .. commerceIndex .. ", 1, " .. territorySupplyKey .. " )")
        else
          tradeBuyMarket.supply[commerceIndex]:SetShow(false)
        end
        tradeBuyMarket.icons[commerceIndex].icon:SetShow(true)
        local iconPosX = tradeBuyMarket.ListBody[commerceIndex]:GetPosX()
        local iconPosY = tradeBuyMarket.ListBody[commerceIndex]:GetPosY()
        tradeBuyMarket.icons[commerceIndex].icon:SetPosX(14)
        tradeBuyMarket.icons[commerceIndex].icon:SetPosY(11)
        commerceIndex = commerceIndex + 1
      end
    end
  end
end
function tradeBuyMarket:setBuyItemDataInfo(index, itemName, leftCount, tradeItemWrapper, buyableStackCount, sellRate)
  tradeBuyMarket.itemName[index]:SetAutoResize(true)
  tradeBuyMarket.itemName[index]:SetTextMode(UI_TM.eTextMode_Limit_AutoWrap)
  tradeBuyMarket.itemName[index]:setLineCountByLimitAutoWrap(2)
  tradeBuyMarket.itemName[index]:SetText(tostring(itemName))
  if true == tradeItemWrapper:isTradableItem() then
    tradeBuyMarket.remainCount[index]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TradeMarketBuyList_RemainCount", "Count", tostring(buyableStackCount)))
    tradeBuyMarket.sellPrice[index]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_PRICE_ONEPIECE", "price", makeDotMoney(tradeItemWrapper:getTradeSellPrice())))
    tradeBuyMarket.sellPrice[index]:SetPosX(tradeBuyMarket.sellPrice[index]:GetTextSizeX() + 13)
    tradeBuyMarket.Quotation[index]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TradeMarketBuyList_Percents", "Percent", tostring(sellRate)))
    tradeBuyMarket.AddCart[index]:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketBuyList_AddtoCart"))
    local needLifeType = tradeItemWrapper:get():getNeedLifeType()
    local needLifeLevel = tradeItemWrapper:get():getNeedLifeLevel()
    local conditionLevel, conditionTypeName
    if _ContentsGroup_isUsedNewCharacterInfo == false then
      conditionLevel = FGlobal_CraftLevel_Replace(needLifeLevel + 1, needLifeType)
      conditionTypeName = FGlobal_CraftType_ReplaceName(needLifeType)
    else
      conditionLevel = FGlobal_UI_CharacterInfo_Basic_Global_CraftLevelReplace(needLifeLevel + 1)
      conditionTypeName = UI_LifeString[needLifeType]
    end
    local buyingConditionValue = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_BUYING_CONDITIONTITLE") .. " "
    if 0 == needLifeLevel or nil == needLifeLevel then
      buyingConditionValue = buyingConditionValue .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_BUYING_CONDITION_NIL")
      tradeBuyMarket.buyingCondition[index]:SetText(buyingConditionValue)
      tradeBuyMarket.buyingCondition[index]:SetFontColor(Defines.Color.C_FFC4BEBE)
      tradeBuyMarket.AddCart[index]:SetEnable(true)
      tradeBuyMarket.AddCart[index]:SetMonoTone(false)
      tradeBuyMarket.trendShow[index]:SetEnable(true)
      tradeBuyMarket.trendShow[index]:SetMonoTone(false)
    else
      local player = getSelfPlayer()
      local playerGet = player:get()
      local playerThisCraftLevel = playerGet:getLifeExperienceLevel(needLifeType)
      if needLifeLevel < playerThisCraftLevel then
        tradeBuyMarket.AddCart[index]:SetEnable(true)
        tradeBuyMarket.AddCart[index]:SetMonoTone(false)
        tradeBuyMarket.trendShow[index]:SetEnable(true)
        tradeBuyMarket.trendShow[index]:SetMonoTone(false)
        tradeBuyMarket.buyingCondition[index]:SetFontColor(Defines.Color.C_FFC4BEBE)
        buyingConditionValue = "<PAColor0xFFC4BEBE>" .. buyingConditionValue .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_BUYING_CONDITION", "craftName", conditionTypeName, "craftLevel", conditionLevel) .. "<PAOldColor>"
      else
        tradeBuyMarket.AddCart[index]:SetEnable(false)
        tradeBuyMarket.AddCart[index]:SetMonoTone(true)
        tradeBuyMarket.AddCart[index]:SetShow(false)
        tradeBuyMarket.trendShow[index]:SetEnable(false)
        tradeBuyMarket.trendShow[index]:SetMonoTone(true)
        tradeBuyMarket.trendShow[index]:SetShow(false)
        buyingConditionValue = "<PAColor0xFFa91000>" .. buyingConditionValue .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_BUYING_CONDITION", "craftName", conditionTypeName, "craftLevel", conditionLevel) .. "<PAOldColor>"
        tradeBuyMarket.buyingCondition[index]:SetFontColor(Defines.Color.C_FF775555)
      end
      tradeBuyMarket.buyingCondition[index]:SetText(buyingConditionValue)
    end
    tradeBuyMarket.buyingCondition[index]:addInputEvent("Mouse_On", "TradeMarket_BuyList_SimpleTooltip( true, " .. index .. ", " .. needLifeType .. ", " .. needLifeLevel .. ")")
    tradeBuyMarket.buyingCondition[index]:addInputEvent("Mouse_Out", "TradeMarket_BuyList_SimpleTooltip( false, " .. index .. ", " .. needLifeType .. ", " .. needLifeLevel .. ")")
    if 0 < Int64toInt32(buyableStackCount) then
      tradeBuyMarket.AddCart[index]:SetEnable(true)
    else
      tradeBuyMarket.AddCart[index]:SetEnable(false)
    end
  else
    tradeBuyMarket.remainCount[index]:SetShow(false)
    tradeBuyMarket.sellPrice[index]:SetShow(false)
    tradeBuyMarket.Quotation[index]:SetShow(false)
    tradeBuyMarket.AddCart[index]:SetShow(false)
    tradeBuyMarket.trendShow[index]:SetShow(false)
  end
  _descBg:SetPosY(getScreenSizeY() - Panel_Npc_Trade_Market:GetSizeY() - _descBg:GetSizeY() - 100)
  _desc:SetPosY(_descBg:GetPosY() + 20)
  _descBg:SetShow(false)
  _desc:SetShow(false)
  local talker = dialog_getTalker()
  if nil ~= talker then
    local actorKeyRaw = talker:getActorKey()
    local actorProxyWrapper = getNpcActor(actorKeyRaw)
    local actorProxy = actorProxyWrapper:get()
    local characterStaticStatus = actorProxy:getCharacterStaticStatus()
    if not characterStaticStatus:isTerritorySupplyMerchant() and not characterStaticStatus:isTerritoryTradeMerchant() and 1000000 ~= getSelfPlayer():get():getlTradeItemCountRate() then
      _descBg:SetShow(true)
      _desc:SetShow(true)
    end
  end
end
function FGlobal_RemainItemDesc_Hide()
  _descBg:SetShow(false)
  _desc:SetShow(false)
end
function createBuyItemList()
  local index = 1
  for col = 1, 3 do
    for row = 1, 3 do
      createItemList(index, row, col - 1)
      index = index + 1
    end
  end
  local posX = tradeBuyMarket.ListBody[1]:GetPosX()
  local posY = tradeBuyMarket.ListBody[1]:GetPosY()
  _TitleName:SetPosX(posX)
  _TitleName:SetPosY(posY - 50)
  tradeBuyMarket.isInitialized = true
end
function updateMarketList()
  if false == Panel_Trade_Market_BuyItemList:GetShow() then
    return
  end
  if false == isKeyDown_Once(VCK.KeyCode_LBUTTON) then
    return
  end
  local eventControl = getEventControl()
  if nil ~= eventControl then
    local parentControl = eventControl:getParent()
    if nil ~= parentControl and parentControl:GetKey() == Panel_Window_Exchange_Number:GetKey() then
      return
    end
  end
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  local enableStart = Panel_Trade_Market_BuyItemList:getEnableStart()
  local enableEnd = Panel_Trade_Market_BuyItemList:getEnableEnd()
  local checkStartPosX = Panel_Trade_Market_BuyItemList:GetParentPosX() + enableStart.x
  local checkStartPosY = Panel_Trade_Market_BuyItemList:GetParentPosY() + enableStart.y
  local checkEndPosX = Panel_Trade_Market_BuyItemList:GetParentPosX() + enableEnd.x
  local checkEndPosY = Panel_Trade_Market_BuyItemList:GetParentPosY() + enableEnd.y
  if false == (mousePosX > checkStartPosX and mousePosX < checkEndPosX and mousePosY > checkStartPosY and mousePosY < checkEndPosY) then
    Panel_Window_Exchange_Number:SetShow(false)
  end
end
function createItemList(index, row, col)
  local tempListBody = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Trade_Market_BuyItemList, "Static_Panel_" .. index)
  CopyBaseProperty(_ItemPanel, tempListBody)
  tradeBuyMarket.ListBody[index] = tempListBody
  local tempItemSlotBG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempListBody, "Static_Slot_" .. index)
  CopyBaseProperty(_SlotBG, tempItemSlotBG)
  tradeBuyMarket.itemSlot_BG[index] = tempItemSlotBG
  local icon = {}
  SlotItem.new(icon, "TradeShopItem_" .. index, index, tempListBody, tradeBuyMarket.slotConfig)
  icon:createChild()
  local tempRemainCount = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_remainCount_" .. index)
  CopyBaseProperty(_RemainCount, tempRemainCount)
  tradeBuyMarket.remainCount[index] = tempRemainCount
  local tempItemName = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_itemName_" .. index)
  CopyBaseProperty(_ItemName, tempItemName)
  tradeBuyMarket.itemName[index] = tempItemName
  local tempSellPrice = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_sellPrice_" .. index)
  CopyBaseProperty(_SellPrice, tempSellPrice)
  tradeBuyMarket.sellPrice[index] = tempSellPrice
  local tempQuotation = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_QuotationRate_" .. index)
  CopyBaseProperty(_QuotationRate, tempQuotation)
  tradeBuyMarket.Quotation[index] = tempQuotation
  local tempAddCart = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, tempListBody, "Button_AddCart_" .. index)
  tempAddCart:addInputEvent("Mouse_LUp", "click_tradeBuyMarket_BuyItemAddCart(" .. index .. ")")
  CopyBaseProperty(_AddCard, tempAddCart)
  tradeBuyMarket.AddCart[index] = tempAddCart
  local tempTrendShow = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, tempListBody, "Button_TrendShow" .. index)
  tempTrendShow:addInputEvent("Mouse_LUp", "click_tradeBuyMarket_BuyItemTrendShow(" .. index .. ")")
  CopyBaseProperty(_showTrade, tempTrendShow)
  tradeBuyMarket.trendShow[index] = tempTrendShow
  local tempExpiration = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_Expiration" .. index)
  CopyBaseProperty(_expiration, tempExpiration)
  tradeBuyMarket.expiration[index] = tempExpiration
  local tempBuyingCondition = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_BuyingCondition" .. index)
  CopyBaseProperty(_buyingCondition, tempBuyingCondition)
  tempBuyingCondition:SetTextMode(UI_TM.eTextMode_LimitText)
  tradeBuyMarket.buyingCondition[index] = tempBuyingCondition
  local tempSupply = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_Supply_" .. index)
  CopyBaseProperty(_supply, tempSupply)
  tradeBuyMarket.supply[index] = tempSupply
  tradeBuyMarket.icons[index] = icon
  tradeBuyMarket:setShowTradeIcon(index, true)
  posX = (row - 1) * tradeBuyMarket.iconSizeCalcX
  posY = col * tradeBuyMarket.iconSizeCalcY
  tempListBody:SetPosX(posX)
  tempListBody:SetPosY(posY)
end
function click_tradeBuyMarket_BuyItemAddCart(index)
  param = {
    [0] = tradeBuyMarket.itemEnchantKey[index],
    [1] = tradeBuyMarket.itemIndex[index],
    [2] = true,
    [3] = tradeBuyMarket.enCommerceIndex
  }
  local tradeItemWrapper = npcShop_getTradeItem(param[0])
  local buyableStack = tradeItemWrapper:get():calculateRemainCount()
  if global_CheckItem_From_Cart(param[0]) then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketBuyList_Already_Exist_In_Barket"))
    return
  end
  Panel_NumberPad_Show(true, buyableStack, param, TradeMarket_BuySome_ConfirmFunction)
end
local _trendIndex
function click_tradeBuyMarket_BuyItemTrendShow(index)
  local talker = dialog_getTalker()
  if nil == talker then
    return
  end
  local actorProxyWrapper = getNpcActor(talker:getActorKey())
  local actorProxy = actorProxyWrapper:get()
  local characterStaticStatus = actorProxy:getCharacterStaticStatus()
  if characterStaticStatus:isTerritorySupplyMerchant() or characterStaticStatus:isTerritoryTradeMerchant() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_TERRITORYSUPPLY_MEMO")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_TERRITORYSUPPLY_TITLE"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if 1 > getSelfPlayer():getWp() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_WPCHECK_MEMO")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_TERRITORYSUPPLY_TITLE"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  _trendIndex = index
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_WPUSE_MEMO")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_TERRITORYSUPPLY_TITLE"),
    content = messageBoxMemo,
    functionYes = Show_OtherRegion_Trend,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function Show_OtherRegion_Trend()
  local talker = dialog_getTalker()
  if nil == talker then
    return
  end
  ToClient_SendTrendInfo(talker:getActorKey(), tradeBuyMarket.itemEnchantKey[trendIndex()])
end
function trendIndex()
  return _trendIndex
end
function TradeBuyMarket_SimpleTooltip(isShow, index, tipType, territoryKey)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if 1 == tipType and nil == territoryKey then
    return
  end
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_TOOLTIP_PRICEENSURE")
    control = tradeBuyMarket.expiration[index]
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TRADEMARKET_EVENTINFO_SUBTITLE_2")
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_SUPPLY", "territoryName", territoryName[territoryKey])
    control = tradeBuyMarket.supply[index]
  end
  TooltipSimple_Show(control, name, desc)
end
function tradeBuyMarket:setShowTradeIcon(index, isShow)
  tradeBuyMarket.ListBody[index]:SetShow(isShow)
  tradeBuyMarket.itemSlot_BG[index]:SetShow(isShow)
  tradeBuyMarket.remainCount[index]:SetShow(isShow)
  tradeBuyMarket.icons[index].icon:SetShow(isShow)
  tradeBuyMarket.itemName[index]:SetShow(isShow)
  tradeBuyMarket.sellPrice[index]:SetShow(isShow)
  tradeBuyMarket.Quotation[index]:SetShow(isShow)
  tradeBuyMarket.AddCart[index]:SetShow(isShow)
  tradeBuyMarket.trendShow[index]:SetShow(isShow)
  tradeBuyMarket.expiration[index]:SetShow(isShow)
  tradeBuyMarket.buyingCondition[index]:SetShow(isShow)
end
function eventBuyFromNpcListRefesh()
  if false == global_IsTrading then
    return
  end
  for count = 1, tradeBuyMarket.maxSellCount do
    tradeBuyMarket:setShowTradeIcon(count, false)
  end
  global_setBuyList()
end
function TradeMarket_BuyList_SimpleTooltip(isShow, index, lifeType, lifeLevel)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if 0 == lifeLevel or nil == lifeLevel then
    return
  end
  local player = getSelfPlayer()
  local playerGet = player:get()
  local playerThisCraftLevel = playerGet:getLifeExperienceLevel(lifeType)
  local name, desc, control, conditionLevel, conditionTypeName
  if _ContentsGroup_isUsedNewCharacterInfo == false then
    conditionLevel = FGlobal_CraftLevel_Replace(lifeLevel + 1, lifeType)
    conditionTypeName = FGlobal_CraftType_ReplaceName(lifeType)
  else
    conditionLevel = FGlobal_UI_CharacterInfo_Basic_Global_CraftLevelReplace(lifeLevel + 1)
    conditionTypeName = UI_LifeString[lifeType]
  end
  if lifeLevel < playerThisCraftLevel then
    name = "<PAColor0xFFC4BEBE>" .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_BUYING_CONDITION", "craftName", conditionTypeName, "craftLevel", conditionLevel) .. "<PAOldColor>"
  else
    name = "<PAColor0xFFa91000>" .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_BUYING_CONDITION", "craftName", conditionTypeName, "craftLevel", conditionLevel) .. "<PAOldColor>"
  end
  control = tradeBuyMarket.buyingCondition[index]
  TooltipSimple_Show(control, name, desc)
end
function PaGlobalFunc_TradeMarket_ReOrderMarketList()
  tradeBuyMarket:reorderMarketList()
end
function tradeBuyMarket:reorderMarketList()
  if false == tradeBuyMarket.isInitialized then
    return
  end
  if false == Panel_Trade_Market_BuyItemList:IsShow() then
    return
  end
  tradeBuyMarketList_Position()
end
createBuyItemList()
Panel_Trade_Market_BuyItemList:RegisterUpdateFunc("updateMarketList")
registerEvent("EventNpcShopUpdate", "eventBuyFromNpcListRefesh")
registerEvent("ToClient_SendTrendInfo", "ToClient_SendTrendInfo")
registerEvent("onScreenResize", "PaGlobalFunc_TradeMarket_ReOrderMarketList")

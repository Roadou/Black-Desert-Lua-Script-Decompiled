Panel_Npc_Trade_Market:SetShow(false, false)
Panel_Npc_Trade_Market:setGlassBackground(true)
global_IsTrading = false
function global_setTrading(istrading)
  global_IsTrading = istrading
end
gDialogSceneIndex = {
  [enCommerceType.enCommerceType_Luxury_Miscellaneous] = 8,
  [enCommerceType.enCommerceType_Luxury] = 7,
  [enCommerceType.enCommerceType_Grocery] = 5,
  [enCommerceType.enCommerceType_Cloth] = 10,
  [enCommerceType.enCommerceType_ObjectSaint] = 11,
  [enCommerceType.enCommerceType_MilitarySupplies] = 12,
  [enCommerceType.enCommerceType_Medicine] = 6,
  [enCommerceType.enCommerceType_SeaFood] = 14,
  [enCommerceType.enCommerceType_RawMaterial] = 13,
  [enCommerceType.enCommerceType_Max] = 0
}
local UI_TM = CppEnums.TextMode
local const_64 = Defines.s64_const
local currentTradeSlot = 0
local tradeBuyMaxCount = 9
local npcTradeShop = {
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = false,
    createCash = true
  },
  _TradeBuyListRow = 3,
  _TradeBuyListCol = 3,
  _buySlotMaxCount = 14,
  _buyRequest = false,
  _isShip = true,
  _selectClickIndex = 1,
  _selectClickItemKey = 0,
  _numpadNumber = toInt64(0, 1),
  _totalWeight = const_64.s64_0,
  _myRemainWeight = const_64.s64_0,
  _totalCost = const_64.s64_0,
  buyListFrame,
  buyListFrameContent,
  _buttonExit,
  _buttonToggleServant,
  _staticCategoryTotal,
  _staticPossessMoneyText,
  _staticPossessMoneyValue,
  _staticPossessMoney,
  _staticTotalMoneyText,
  _staticTotalMoneyValue,
  _staticTotalMoney,
  _staticTotalWeightText,
  _staticTotalWeight,
  _StaticTextCartWeightLT,
  _button_Confirm,
  _button_ClearList,
  _button_Confirm_EnterVihicle,
  _currentWeightText,
  _currentWeightLT,
  _vehicleWeightLT,
  _vehicleWeightText,
  _alertpanel,
  _alerttext,
  _btnInvestNode,
  preLoadUI = {
    _static_Icon = nil,
    _static_TextItemName = nil,
    _static_Multiply = nil,
    _button_Quantity = nil,
    _static_Equal = nil,
    _static_Cost = nil,
    _static_CostIcon = nil
  },
  _slotBuyAmount = {},
  _buyList = {}
}
function global_setTradeUI(refreshGraph)
  currentTradeSlot = 1
  npcTradeShop._numpadNumber = toInt64(0, 1)
  npcTradeShop:InitTradeMarket()
  npcTradeShop:initTradeData()
  if true == refreshGraph then
    global_CommerceGraphDataInit(false)
  end
  npcTradeShop._staticPossessMoneyValue:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  npcTradeShop._staticTotalMoneyValue:SetText("0")
  setShowLine(false)
end
function global_enterBasketInShop(slotItemKey, index, itemCount)
  if tradeBuyMaxCount < currentTradeSlot then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_NOTIFYDISPLAY"))
    UI.ASSERT(false, "\235\132\136\235\172\180 \235\167\142\236\157\180 \235\139\180\236\156\188\235\160\164\234\179\160 \237\149\169\235\139\136\235\139\164.")
    return 0
  end
  if nil ~= npcTradeShop._slotBuyAmount[slotItemKey] then
    return 0
  end
  local slot = npcTradeShop._buyList[currentTradeSlot]
  local shopItemWrapper = npcShop_getItemBuy(index)
  local buyData = {
    _itemCount = toInt64(0, 0),
    _slotIndex = 0,
    _itemKey = 0,
    _commerceTypeIndex = 0
  }
  local itemSS = shopItemWrapper:getStaticStatus()
  buyData._itemCount = itemCount
  buyData._slotIndex = index
  buyData._itemKey = slotItemKey
  buyData._commerceTypeIndex = itemSS:getCommerceType()
  npcTradeShop._slotBuyAmount[slotItemKey] = buyData
  npcTradeShop._selectClickItemKey = slotItemKey
  npcTradeShop._selectClickIndex = currentTradeSlot
  local s64_inventoryItemCount
  local shopItem = shopItemWrapper:get()
  slot:setItem(shopItemWrapper:getStaticStatus(), shopItem.leftCount_s64, shopItem.price_s64, s64_inventoryItemCount)
  currentTradeSlot = currentTradeSlot + 1
  totalCalculateMoney()
  Panel_Tooltip_Item_SetPosition(slot.slotNo, slot, "shop")
  npcTradeShop._buyRequest = false
  return 1
end
function global_CheckItem_From_Cart(checkItemKey)
  return nil ~= npcTradeShop._slotBuyAmount[checkItemKey]
end
function click_TradeMarket_Quantity(index)
  npcTradeShop._selectClickIndex = index
  local slot = npcTradeShop._buyList[index]
  npcTradeShop._selectClickItemKey = slot.itemKey
  param = {
    [0] = npcTradeShop._selectClickItemKey,
    [1] = index,
    [2] = false,
    [3] = npcTradeShop._slotBuyAmount[npcTradeShop._selectClickItemKey]._commerceTypeIndex
  }
  local tradeItemWrapper = npcShop_getTradeItem(param[0])
  local buyableStack = tradeItemWrapper:getRemainStackCount()
  Panel_NumberPad_Show(true, buyableStack, param, TradeMarket_BuySome_ConfirmFunction)
end
function TradeMarket_BuySome_ConfirmFunction(inputNumber, param)
  npcTradeShop._numpadNumber = inputNumber
  local rv = global_enterBasketInShop(param[0], param[1], inputNumber)
  if 0 == rv and true == param[2] then
    return
  end
  npcTradeShop._slotBuyAmount[npcTradeShop._selectClickItemKey]._itemCount = inputNumber
  local quentityButton = npcTradeShop._buyList[npcTradeShop._selectClickIndex].button_Quantity
  quentityButton:SetText(tostring(inputNumber))
  local npcSceneCharacterKey = getClientSceneKey()
  if true == param[2] and 0 ~= npcSceneCharacterKey then
    callAIHandlerByIndex(1, gDialogSceneIndex[param[3]], "SceneTradeBuy")
  else
    totalCalculateMoney()
  end
end
function calculateMoney(index)
  if false == npcTradeShop:checkSlotIndex(index) or index > currentTradeSlot then
    UI.ASSERT(false, "\236\138\172\235\161\175 \235\178\136\237\152\184\234\176\128 \236\157\180\236\131\129\237\149\169\235\139\136\235\139\164.")
    return
  end
  local slot = npcTradeShop._buyList[index]
  local s64itemPrice = slot.s64price * npcTradeShop._slotBuyAmount[slot.itemKey]._itemCount
  slot.static_Cost:SetText(makeDotMoney(s64itemPrice))
  npcTradeShop._totalWeight = npcTradeShop._totalWeight + toInt64(0, slot.itemWeight) * npcTradeShop._slotBuyAmount[slot.itemKey]._itemCount
  return s64itemPrice
end
function totalCalculateMoney()
  npcTradeShop._totalWeight = toInt64(0, 0)
  local totalItemPrice = toInt64(0, 0)
  for count = 1, currentTradeSlot - 1 do
    s64itemPrice = calculateMoney(count)
    totalItemPrice = totalItemPrice + s64itemPrice
  end
  npcTradeShop._staticTotalMoneyValue:SetText(makeDotMoney(totalItemPrice))
  npcTradeShop._totalCost = totalItemPrice
  local itemWeight = string.format("%.1f", Int64toInt32(npcTradeShop._totalWeight) / 10000)
  if npcTradeShop._myRemainWeight < npcTradeShop._totalWeight then
    npcTradeShop._StaticTextCartWeightLT:SetFontColor(Defines.Color.C_FFD20000)
  else
    npcTradeShop._StaticTextCartWeightLT:SetFontColor(Defines.Color.C_FFFFBC3A)
  end
  npcTradeShop._StaticTextCartWeightLT:SetText(itemWeight .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT"))
end
function npcTradeShop:checkSlotIndex(index)
  if index < 0 or index > tradeBuyMaxCount then
    UI.ASSERT(false, "\236\156\160\237\154\168\237\149\152\236\167\128 \236\149\138\236\157\128 \236\138\172\235\161\175 \235\178\136\237\152\184 \236\158\133\235\139\136\235\139\164.(lua)")
    return false
  end
  return true
end
function npcTradeShop:registUiControl()
  local index = 0
  npcTradeShop.buyListFrame = UI.getChildControl(Panel_Npc_Trade_Market, "Frame_BuyList")
  npcTradeShop.buyListFrameContent = npcTradeShop.buyListFrame:GetFrameContent()
  npcTradeShop.title = UI.getChildControl(Panel_Npc_Trade_Market, "Panel_title")
  npcTradeShop._buttonExit = UI.getChildControl(Panel_Npc_Trade_Market, "Button_Win_Close")
  npcTradeShop._buttonToggleServant = UI.getChildControl(Panel_Npc_Trade_Market, "Button_ToggleServant")
  npcTradeShop._staticEarnProfitText = UI.getChildControl(Panel_Npc_Trade_Market, "StaticText_Earn_Profit_Title")
  npcTradeShop._staticEarnProfitValue = UI.getChildControl(Panel_Npc_Trade_Market, "StaticText_Earn_Profit_Value")
  npcTradeShop._staticEarnProfitCoin = UI.getChildControl(Panel_Npc_Trade_Market, "StaticText_Earn_Profit_Coin")
  npcTradeShop._petInventoryTitle = UI.getChildControl(Panel_Npc_Trade_Market, "StaticText_Pet_Inventory")
  npcTradeShop._petInventoryValue = UI.getChildControl(Panel_Npc_Trade_Market, "StaticText_Pet_Inventory_Value")
  npcTradeShop._alertpanel = UI.getChildControl(Panel_Npc_Trade_Market, "Static_AlertPanel")
  npcTradeShop._alerttext = UI.getChildControl(Panel_Npc_Trade_Market, "StaticText_Alert_NoticeText")
  npcTradeShop._btnInvestNode = UI.getChildControl(Panel_Npc_Trade_Market, "Button_Node_Invest")
  npcTradeShop.preLoadUI = {
    _static_Icon = UI.getChildControl(npcTradeShop.buyListFrameContent, "list_icon"),
    _static_TextItemName = UI.getChildControl(npcTradeShop.buyListFrameContent, "list_name"),
    _static_Multiply = UI.getChildControl(npcTradeShop.buyListFrameContent, "list_multiply"),
    _button_Quantity = UI.getChildControl(npcTradeShop.buyListFrameContent, "Button_listCount"),
    _static_Equal = UI.getChildControl(npcTradeShop.buyListFrameContent, "list_equal"),
    _static_Cost = UI.getChildControl(npcTradeShop.buyListFrameContent, "StaticText_Cost"),
    _static_CostIcon = UI.getChildControl(npcTradeShop.buyListFrameContent, "list_totalCost_moneyIcon")
  }
  npcTradeShop._staticCategoryTotal = UI.getChildControl(npcTradeShop.buyListFrameContent, "category_total")
  npcTradeShop._staticPossessMoneyText = UI.getChildControl(npcTradeShop.buyListFrameContent, "possessed_money")
  npcTradeShop._staticPossessMoneyValue = UI.getChildControl(npcTradeShop.buyListFrameContent, "possessed_money_value")
  npcTradeShop._staticPossessMoney = UI.getChildControl(npcTradeShop.buyListFrameContent, "possessed_money_moneyIcon")
  npcTradeShop._staticTotalMoneyText = UI.getChildControl(npcTradeShop.buyListFrameContent, "totalCost")
  npcTradeShop._staticTotalMoneyValue = UI.getChildControl(npcTradeShop.buyListFrameContent, "totalCost_value")
  npcTradeShop._staticTotalMoney = UI.getChildControl(npcTradeShop.buyListFrameContent, "totalCost_moneyIcon")
  npcTradeShop._staticTotalWeightText = UI.getChildControl(npcTradeShop.buyListFrameContent, "totalWeight")
  npcTradeShop._staticTotalWeight = UI.getChildControl(npcTradeShop.buyListFrameContent, "totalWeight_value")
  npcTradeShop._StaticTextCartWeightLT = UI.getChildControl(npcTradeShop.buyListFrameContent, "totalWeight_LT")
  npcTradeShop._button_Confirm = UI.getChildControl(npcTradeShop.buyListFrameContent, "Button_confirm")
  npcTradeShop._currentWeightLT = UI.getChildControl(npcTradeShop.buyListFrameContent, "currentWeight_LT")
  npcTradeShop._vehicleWeightText = UI.getChildControl(npcTradeShop.buyListFrameContent, "StaticText_Vehicle_Weight")
  npcTradeShop._vehicleWeightLT = UI.getChildControl(npcTradeShop.buyListFrameContent, "currentVehicleWeight_LT")
  npcTradeShop._button_Confirm:addInputEvent("Mouse_LUp", "click_Confirm_BasketList()")
  npcTradeShop._button_ClearList = UI.getChildControl(npcTradeShop.buyListFrameContent, "Button_clearList")
  npcTradeShop._button_ClearList:addInputEvent("Mouse_LUp", "click_clear_BasketList()")
  npcTradeShop._buttonExit:addInputEvent("Mouse_LUp", "closeNpcTrade_Basket()")
  npcTradeShop._buttonToggleServant:addInputEvent("Mouse_LUp", "trademarket_toggleServant()")
  npcTradeShop._button_Confirm_EnterVihicle = UI.getChildControl(npcTradeShop.buyListFrameContent, "Button_confirm_EnterViehicle")
  npcTradeShop._button_Confirm_EnterVihicle:addInputEvent("Mouse_LUp", "click_Confirm_Enter_Vehicle()")
  npcTradeShop._currentWeightText = UI.getChildControl(npcTradeShop.buyListFrameContent, "currentWeight")
  local preloadUIList = npcTradeShop.preLoadUI
  for countCol = 1, npcTradeShop._TradeBuyListCol do
    for countRow = 1, npcTradeShop._TradeBuyListRow do
      index = (countCol - 1) * npcTradeShop._TradeBuyListCol + countRow
      local buyList = {
        slotNo = 0,
        s64price = toInt64(0, 0),
        s64StackCount = 0,
        itemWeight = 0,
        itemKey
      }
      buyList.slotNo = index - 1
      buyList.static_TextItemName = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, npcTradeShop.buyListFrameContent, "BuyListBuyItemName_" .. index)
      CopyBaseProperty(preloadUIList._static_TextItemName, buyList.static_TextItemName)
      buyList.static_Multiply = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, npcTradeShop.buyListFrameContent, "BuyList_multiply_" .. index)
      CopyBaseProperty(preloadUIList._static_Multiply, buyList.static_Multiply)
      buyList.button_Quantity = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, npcTradeShop.buyListFrameContent, "BuyList_Quantity" .. index)
      CopyBaseProperty(preloadUIList._button_Quantity, buyList.button_Quantity)
      buyList.button_Quantity:addInputEvent("Mouse_LUp", "click_TradeMarket_Quantity(" .. index .. ")")
      buyList.static_Equal = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, npcTradeShop.buyListFrameContent, "BuyList_Equal" .. index)
      CopyBaseProperty(preloadUIList._static_Equal, buyList.static_Equal)
      buyList.static_Cost = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, npcTradeShop.buyListFrameContent, "BuyList_Cost" .. index)
      CopyBaseProperty(preloadUIList._static_Cost, buyList.static_Cost)
      buyList.static_CostIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, npcTradeShop.buyListFrameContent, "BuyListIcon_Cost" .. index)
      CopyBaseProperty(preloadUIList._static_CostIcon, buyList.static_CostIcon)
      buyList.icon = {}
      SlotItem.new(buyList.icon, "ShopItem_" .. index, index, npcTradeShop.buyListFrameContent, npcTradeShop.slotConfig)
      buyList.icon:createChild()
      function buyList:setItem(itemStaticWrapper, s64_stackCount, s64_price, s64_invenCount, disable)
        local enable = const_64.s64_0 ~= s64_stackCount and not disable
        self.icon:setItemByStaticStatus(itemStaticWrapper)
        self.icon.icon:SetMonoTone(not enable)
        self.static_TextItemName:SetText(itemStaticWrapper:getName())
        self.s64price = s64_price
        self.s64StackCount = s64_stackCount
        self.itemWeight = itemStaticWrapper:get()._weight
        self.itemKey = itemStaticWrapper:get()._key:get()
        self:setShow(true)
      end
      function buyList:clearSlot()
        self:setShow(false)
        self.button_Quantity:SetText("1")
        self.static_Cost:SetText("0")
      end
      function buyList:setShow(bShow)
        local bShow = bShow or false
        self.static_TextItemName:SetShow(bShow)
        self.static_Multiply:SetShow(bShow)
        self.button_Quantity:SetShow(bShow)
        self.static_Equal:SetShow(bShow)
        self.static_Cost:SetShow(bShow)
        self.static_CostIcon:SetShow(bShow)
        self.icon.icon:SetShow(bShow)
      end
      npcTradeShop._buyList[index] = buyList
    end
  end
  npcTradeShop.buyListFrame:SetSize(getScreenSizeX() - 20, npcTradeShop.buyListFrame:GetSizeY())
  npcTradeShop.buyListFrameContent:SetSize(npcTradeShop.buyListFrame:GetSizeX(), npcTradeShop.buyListFrame:GetSizeY())
  eventResetTradeUI()
end
function check_Servant()
  local myLandVehicle = getTemporaryInformationWrapper()
  local servantInfoWrapper = myLandVehicle:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
  if true == ToClient_IsDevelopment() and true == npcTradeShop._isShip then
    servantInfoWrapper = myLandVehicle:getUnsealVehicle(CppEnums.ServantType.Type_Ship)
  end
  if nil ~= servantInfoWrapper then
    local myLandVehicleActorKey = servantInfoWrapper:getActorKeyRaw()
    if nil ~= myLandVehicleActorKey then
      local landVehicleActorProxy = getActor(myLandVehicleActorKey)
      local selfProxy = getSelfPlayer()
      if nil ~= landVehicleActorProxy then
        local isAbleDistance = getDistanceFromVehicle()
        if true == ToClient_IsDevelopment() and true == npcTradeShop._isShip then
          isAbleDistance = getDistanceFromShip()
        end
        if isAbleDistance then
          if false == ToClient_IsDevelopment() then
            local vehicleInventory = servantInfoWrapper:getInventory()
            local maxInventorySlot = vehicleInventory:size() - 2
            local freeInventorySlot = maxInventorySlot - vehicleInventory:getFreeCount()
            local myLandVehicleActorKey = myLandVehicle:getUnsealVehicle(false):getActorKeyRaw()
            local servantWrapper = myLandVehicle:getUnsealVehicleByActorKeyRaw(myLandVehicleActorKey)
            local max_weight = Int64toInt32(servantWrapper:getMaxWeight_s64() / Defines.s64_const.s64_10000)
            local total_weight = Int64toInt32((servantWrapper:getInventoryWeight_s64() + servantWrapper:getEquipWeight_s64() + servantWrapper:getMoneyWeight_s64()) / Defines.s64_const.s64_10000)
            local vehicleRemainWeightValue = string.format("%.1f", max_weight - total_weight)
            return true, maxInventorySlot, freeInventorySlot, vehicleRemainWeightValue
          else
            local myLandVehicleActorKey = servantInfoWrapper:getActorKeyRaw()
            local servantWrapper = getVehicleActor(myLandVehicleActorKey)
            local servantActor = servantWrapper:get()
            if nil == servantActor then
              return nil, 0, 0
            end
            local inventory = servantActor:getInventory()
            if nil == inventory then
              return nil, 0, 0
            end
            local useStartSlot = inventorySlotNoUserStart()
            local maxInventorySlot = inventory:size() - useStartSlot
            local freeInventorySlot = maxInventorySlot - inventory:getFreeCount()
            local max_weight = Int64toInt32(servantActor:getPossessableWeight_s64() / Defines.s64_const.s64_10000)
            local total_weight = Int64toInt32(servantActor:getCurrentWeight_s64() / Defines.s64_const.s64_10000)
            local vehicleRemainWeightValue = string.format("%.1f", max_weight - total_weight)
            return true, maxInventorySlot, freeInventorySlot, vehicleRemainWeightValue
          end
        else
          return false, 0, 0
        end
      else
        return nil, 0, 0
      end
    else
      return nil, 0, 0
    end
  else
    return nil, 0, 0
  end
end
function check_Servant_Inventory()
  local checkServant, maxInventorySlot, freeInventorySlot, remainWeight = check_Servant()
  if true == checkServant then
    npcTradeShop._petInventoryTitle:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketList_Servant_Inventory"))
    npcTradeShop._petInventoryValue:SetText(freeInventorySlot .. " / " .. maxInventorySlot)
    npcTradeShop._vehicleWeightLT:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_WindowTradeMarket_Weight", "Weight", tostring(remainWeight)))
    npcTradeShop._petInventoryTitle:SetShow(true)
    npcTradeShop._petInventoryValue:SetShow(true)
    npcTradeShop._vehicleWeightText:SetShow(true)
    npcTradeShop._vehicleWeightLT:SetShow(true)
    npcTradeShop._petInventoryTitle:SetSpanSize(155, 137)
  elseif false == checkServant then
    npcTradeShop._petInventoryTitle:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketList_Servant_NotNear"))
    npcTradeShop._petInventoryValue:SetText(freeInventorySlot .. " / " .. maxInventorySlot)
    npcTradeShop._petInventoryTitle:SetShow(true)
    npcTradeShop._petInventoryValue:SetShow(false)
    npcTradeShop._vehicleWeightText:SetShow(false)
    npcTradeShop._vehicleWeightLT:SetShow(false)
    npcTradeShop._petInventoryTitle:SetSpanSize(70, 137)
  elseif nil == checkServant then
    npcTradeShop._petInventoryTitle:SetShow(false)
    npcTradeShop._petInventoryValue:SetShow(false)
    npcTradeShop._vehicleWeightText:SetShow(false)
    npcTradeShop._vehicleWeightLT:SetShow(false)
  end
end
function npcTradeShop:InitTradeMarket()
  currentTradeSlot = 1
  npcTradeShop._buyRequest = false
  for count = 1, tradeBuyMaxCount do
    npcTradeShop._buyList[count]:clearSlot()
  end
end
function npcTradeShop:initTradeData()
  npcTradeShop._slotBuyAmount = {}
  npcTradeShop._staticPossessMoneyValue:SetText("0")
  npcTradeShop._staticTotalMoneyValue:SetText("0")
  npcTradeShop._StaticTextCartWeightLT:SetText("0" .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT"))
  TradeShopMoneyRefresh()
end
function click_Confirm_BasketList()
  if currentTradeSlot <= 1 then
    return
  end
  local showMessageBox = check_Servant()
  if true == showMessageBox then
    local tileString = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_BuyMsg_UseVehicleInvenTitle")
    local contentString = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_BuyMsg_UseVehicleInvenContent")
    local messageboxData = {
      title = tileString,
      content = contentString,
      functionYes = confirm_VehicleInventory,
      functionNo = confirm_ToMyInventory,
      exitButton = true,
      isCancelClose = false,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    confirm_ToMyInventory()
  end
end
function confirm_ToMyInventory()
  local titleString = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_BuyMsg_UseInvenTitle")
  local contentString = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_BuyMsg_UseInvenContent")
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = confirm_MyInventory,
    functionNo = MessageBox_Empty_function,
    exitButton = true,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function confirm_MyInventory()
  send_doBuy(0, 0)
end
function confirm_VehicleInventory()
  local myLandVehicle = getTemporaryInformationWrapper()
  local myLandVehicleActorKey = myLandVehicle:getUnsealVehicle(false):getActorKeyRaw()
  if true == ToClient_IsDevelopment() then
    if true == npcTradeShop._isShip then
      myLandVehicleActorKey = myLandVehicle:getUnsealVehicle(CppEnums.ServantType.Type_Ship):getActorKeyRaw()
    else
      myLandVehicleActorKey = myLandVehicle:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle):getActorKeyRaw()
    end
  end
  local servantWrapper = getVehicleActor(myLandVehicleActorKey)
  local servantActor = servantWrapper:get()
  local max_weight = Int64toInt32(servantActor:getPossessableWeight_s64() / Defines.s64_const.s64_10000)
  local total_weight = Int64toInt32(servantActor:getCurrentWeight_s64() / Defines.s64_const.s64_10000)
  if max_weight - total_weight < Int64toInt32(npcTradeShop._totalWeight) / 10000 then
    local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_VEHICLE_MSG_TITLE")
    local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_VEHICLE_MSG_CONTENT")
    local messageboxData = {
      title = titleString,
      content = contentString,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
    return
  end
  send_doBuy(0, 4)
end
function send_doBuy(fromWhere, toWhere)
  local rv = 0
  local servantType = 0
  rv = check_BuyableTradeItem()
  if 0 ~= rv then
    return
  end
  if true == npcTradeShop._isShip then
    servantType = 1
  end
  for slotIndex, itemCount in pairs(npcTradeShop._slotBuyAmount) do
    if toInt64(0, 0) ~= npcTradeShop._slotBuyAmount[slotIndex]._itemCount then
      local itemCount = npcTradeShop._slotBuyAmount[slotIndex]._itemCount
      local itemCount32 = Int64toInt32(itemCount)
      for count = 0, itemCount32 - 1 do
        if false == ToClient_IsDevelopment() then
          npcShop_doBuy(npcTradeShop._slotBuyAmount[slotIndex]._slotIndex, 1, fromWhere, toWhere, false)
        else
          npcShop_doBuy(npcTradeShop._slotBuyAmount[slotIndex]._slotIndex, 1, fromWhere, toWhere, false, servantType)
        end
      end
      npcTradeShop._buyRequest = true
    end
  end
end
function check_BuyableTradeItem()
  local myMoney = getSelfPlayer():get():getInventory():getMoney_s64()
  if myMoney < npcTradeShop._totalCost then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Money"))
    return -1
  end
  return 0
end
function click_Confirm_Enter_Vehicle()
  local myLandVehicle = getTemporaryInformationWrapper()
  local myLandVehicleActorKey = myLandVehicle:getUnsealVehicle(false):getActorKeyRaw()
  if true == ToClient_IsDevelopment() then
    if true == npcTradeShop._isShip then
      myLandVehicleActorKey = myLandVehicle:getUnsealVehicle(CppEnums.ServantType.Type_Ship):getActorKeyRaw()
    else
      myLandVehicleActorKey = myLandVehicle:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle):getActorKeyRaw()
    end
  end
  if nil ~= myLandVehicleActorKey then
    local landVehicleActorProxy = getActor(myLandVehicleActorKey)
    local selfProxy = getSelfPlayer()
    if nil == landVehicleActorProxy then
      NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "Lua_WindowTradeMarket_NotVehicleNear"))
      return
    end
    local isAbleDistance = getDistanceFromVehicle()
    if true == ToClient_IsDevelopment() and true == npcTradeShop._isShip then
      isAbleDistance = getDistanceFromShip()
    end
    if true == isAbleDistance then
      send_doBuy(0, 4)
    end
  else
    UI.debugMessage("\237\131\136 \234\178\131\236\157\180 \236\151\134\236\138\181\235\139\136\235\139\164.")
  end
end
function click_clear_BasketList()
  global_setTradeUI(false)
  global_TradeShopReset()
end
function npcTradeShop:setBuyControlShow(index, isShow)
  local resizeControl = npcTradeShop._buyList[index]
  resizeControl.icon.icon:SetShow(isShow)
  resizeControl.static_TextItemName:SetShow(isShow)
  resizeControl.static_Multiply:SetShow(isShow)
  resizeControl.button_Quantity:SetShow(isShow)
  resizeControl.static_Equal:SetShow(isShow)
end
function npcTradeShop:setControlPos(control, PosX, PosY)
  control:SetPosX(PosX)
  control:SetPosY(PosY)
end
function npcTradeShop:setSizeBuyListControl(index, posX, posY)
  local resizeControl = npcTradeShop._buyList[index]
  npcTradeShop:setControlPos(resizeControl.icon.icon, posX, posY)
  npcTradeShop.title:ComputePos()
  npcTradeShop._buttonExit:ComputePos()
  npcTradeShop._buttonToggleServant:ComputePos()
  npcTradeShop._staticEarnProfitText:ComputePos()
  npcTradeShop._staticEarnProfitValue:ComputePos()
  npcTradeShop._staticEarnProfitCoin:ComputePos()
  npcTradeShop._petInventoryTitle:ComputePos()
  npcTradeShop._petInventoryValue:ComputePos()
  npcTradeShop._staticCategoryTotal:ComputePos()
  npcTradeShop._staticPossessMoneyText:ComputePos()
  npcTradeShop._staticPossessMoneyValue:ComputePos()
  npcTradeShop._staticPossessMoney:ComputePos()
  npcTradeShop._staticTotalMoneyText:ComputePos()
  npcTradeShop._staticTotalMoneyValue:ComputePos()
  npcTradeShop._staticTotalMoney:ComputePos()
  npcTradeShop._staticTotalWeightText:ComputePos()
  npcTradeShop._staticTotalWeight:ComputePos()
  npcTradeShop._StaticTextCartWeightLT:ComputePos()
  npcTradeShop._button_Confirm:ComputePos()
  npcTradeShop._currentWeightLT:ComputePos()
  npcTradeShop._vehicleWeightLT:ComputePos()
  npcTradeShop._vehicleWeightText:ComputePos()
  npcTradeShop._button_ClearList:ComputePos()
  npcTradeShop._button_Confirm_EnterVihicle:ComputePos()
  npcTradeShop._currentWeightText:ComputePos()
  local basePosX = resizeControl.icon.icon:GetPosX()
  local basePosY = resizeControl.icon.icon:GetPosY()
  resizeControl.static_TextItemName:SetTextMode(UI_TM.eTextMode_AutoWrap)
  npcTradeShop:setControlPos(resizeControl.static_TextItemName, basePosX + 50, basePosY + 3)
  basePosX = resizeControl.static_TextItemName:GetPosX()
  basePosY = resizeControl.static_TextItemName:GetPosY()
  npcTradeShop:setControlPos(resizeControl.static_Multiply, basePosX + 120, basePosY + 7)
  basePosX = resizeControl.static_Multiply:GetPosX()
  basePosY = resizeControl.static_Multiply:GetPosY()
  npcTradeShop:setControlPos(resizeControl.button_Quantity, basePosX + 20, basePosY)
  basePosX = resizeControl.button_Quantity:GetPosX()
  basePosY = resizeControl.button_Quantity:GetPosY()
  npcTradeShop:setControlPos(resizeControl.static_Equal, basePosX + 30, basePosY)
  basePosX = resizeControl.static_Equal:GetPosX()
  basePosY = resizeControl.static_Equal:GetPosY()
  npcTradeShop:setControlPos(resizeControl.static_Cost, basePosX + 30, basePosY)
  basePosX = resizeControl.static_Cost:GetPosX()
  basePosY = resizeControl.static_Cost:GetPosY()
  npcTradeShop:setControlPos(resizeControl.static_CostIcon, basePosX + 40, basePosY)
  basePosX = resizeControl.static_CostIcon:GetPosX()
  basePosY = resizeControl.static_CostIcon:GetPosY()
  npcTradeShop:setControlPos(resizeControl.static_CostIcon, basePosX + 20, basePosY + 5)
end
function eventResetTradeUI()
  Panel_Npc_Trade_Market:SetPosY(getScreenSizeY() - Panel_Npc_Trade_Market:GetSizeY())
  Panel_Npc_Trade_Market:SetSize(getScreenSizeX(), Panel_Npc_Trade_Market:GetSizeY())
  npcTradeShop.buyListFrame:SetSize(npcTradeShop.buyListFrame:GetSizeX(), npcTradeShop.buyListFrame:GetSizeY())
  npcTradeShop.buyListFrameContent:SetSize(npcTradeShop.buyListFrame:GetSizeX(), npcTradeShop.buyListFrame:GetSizeY())
  Panel_Npc_Trade_Market:ComputePos()
  npcTradeShop.buyListFrame:ComputePos()
  npcTradeShop.buyListFrameContent:ComputePos()
  local tradeFrame = npcTradeShop.buyListFrame
  tradeFrame:SetPosX(Panel_Npc_Trade_Market:GetSizeX() - tradeFrame:GetSizeX() - 20)
  local buyListSizeX = npcTradeShop.buyListFrame:GetSizeX() - 300
  local displaySizeX = buyListSizeX / 3
  local displayPosY = npcTradeShop.buyListFrame:GetPosY()
  local posX = 0
  local posY = 0
  local col = -1
  for count = 1, tradeBuyMaxCount do
    local row = (count - 1) % 3
    if 0 == row then
      col = col + 1
    end
    local rPosX = posX + row * displaySizeX
    local rPosY = posY + col * 50 + 5
    npcTradeShop:setSizeBuyListControl(count, rPosX, rPosY)
  end
end
function trademarket_toggleServant()
  if true == npcTradeShop._isShip then
    npcTradeShop._isShip = false
  else
    npcTradeShop._isShip = true
  end
  global_setTradeUI(true)
  global_tradeSellListOpen()
  check_Servant_Inventory()
  local tempInfo = getTemporaryInformationWrapper()
  local vehicleWrapper
end
function trademarket_isShip()
  return npcTradeShop._isShip
end
function closeNpcTrade_Basket()
  if Panel_Win_System:GetShow() then
    Proc_ShowMessage_Ack("\236\149\140\235\166\188\236\176\189\236\157\132 \235\168\188\236\160\128 \235\139\171\236\149\132\236\163\188\236\132\184\236\154\148.")
    return
  end
  Fglobal_TradeGame_Close()
  SetUIMode(Defines.UIMode.eUIMode_NpcDialog)
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_setIgnoreShowDialog(false)
    PaGlobalFunc_MainDialog_ReOpen(false)
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    setIgnoreShowDialog(false)
    Panel_Npc_Dialog:SetShow(true, false)
  else
    PaGlobalFunc_DialogMain_All_SetIgnoreShowDialog(false)
    PaGlobalFunc_DialogMain_All_ShowToggle(true)
  end
  InventoryWindow_Close()
  Panel_Tooltip_Item_hideTooltip()
  if Panel_Trade_Market_Graph_Window:IsShow() then
    Panel_Trade_Market_Graph_Window:SetShow(false)
  end
  if Panel_Npc_Trade_Market:IsShow() then
    Panel_Npc_Trade_Market:SetShow(false)
  end
  global_buyListExit()
  global_tradeSellListExit()
  cutSceneCameraWaveMode(true)
  isNearActorEdgeShow(true)
  local mainCameraName = Dialog_getMainSceneCameraName()
  changeCameraScene(mainCameraName, 0.5)
  global_IsTrading = false
  local npcKey = dialog_getTalkNpcKey()
  if 0 ~= npcKey then
    closeClientChangeScene(npcKey)
  else
    UI.ASSERT("\237\130\164 \236\132\164\236\160\149\236\157\180 \235\144\152\236\150\180 \236\158\136\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. \236\150\180\235\150\187\234\178\140 \236\139\164\237\150\137\236\157\132 \237\150\136\236\157\132\234\185\140...")
  end
end
function InitNpcTradeShopOpen()
  if false == global_IsTrading then
    if true == _ContentsGroup_RenewUI_Dailog then
      if false == PaGlobalFunc_MainDialog_IsShow() then
        return
      end
    elseif false == _ContentsGroup_NewUI_Dialog_All then
      if false == Panel_Npc_Dialog:IsShow() then
        return
      end
    elseif false == Panel_Npc_Dialog_All:IsShow() then
      return
    end
    local npcKey = dialog_getTalkNpcKey()
    if 0 ~= npcKey then
      openClientChangeScene(npcKey, 1)
    end
    SetUIMode(Defines.UIMode.eUIMode_Trade)
    if true == _ContentsGroup_RenewUI_Dailog then
      PaGlobalFunc_MainDialog_setIgnoreShowDialog(true)
      PaGlobalFunc_MainDialog_Close(false)
    elseif false == _ContentsGroup_NewUI_Dialog_All then
      setIgnoreShowDialog(true)
      Panel_Npc_Dialog:SetShow(false, false)
    else
      PaGlobalFunc_DialogMain_All_SetIgnoreShowDialog(true)
      PaGlobalFunc_DialogMain_All_ShowToggle(false)
    end
    global_IsTrading = true
    Panel_Npc_Trade_Market:SetShow(true)
    Panel_Trade_Market_Graph_Window:SetShow(true, false)
    if true == ToClient_IsDevelopment() then
      tempInfo = getTemporaryInformationWrapper()
      shipWrapper = tempInfo:getUnsealVehicle(CppEnums.ServantType.Type_Ship)
      vehicleWrapper = tempInfo:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
      if nil ~= shipWrapper and nil ~= vehicleWrapper then
        npcTradeShop._isShip = false
      elseif nil ~= shipWrapper then
        npcTradeShop._isShip = true
      else
        npcTradeShop._isShip = false
      end
    else
      npcTradeShop._buttonToggleServant:SetShow(false)
    end
    global_setTradeUI(true)
    global_tradeSellListOpen()
    cutSceneCameraWaveMode(false)
    isNearActorEdgeShow(false)
    check_Servant_Inventory()
    npcTradeShop._staticEarnProfitValue:SetText("0")
    npcTradeShop._staticEarnProfitValue:SetShow(false)
    npcTradeShop._staticEarnProfitText:SetShow(false)
    npcTradeShop._staticEarnProfitCoin:SetShow(false)
  end
  local talker = dialog_getTalker()
  local npcActorproxy = talker:get()
  local npcPosition = npcActorproxy:getPosition()
  local npcRegionInfo = getRegionInfoByPosition(npcPosition)
  local npcTradeNodeName = npcRegionInfo:getTradeExplorationNodeName()
  local npcTradeOriginRegion = npcRegionInfo:get():getTradeOriginRegion()
  local boolValue = checkSelfplayerNode(npcTradeOriginRegion._waypointKey, true)
  if not boolValue then
    npcTradeShop._alertpanel:SetShow(true)
    npcTradeShop._alerttext:SetShow(true)
    npcTradeShop._alertpanel:SetSpanSize((getScreenSizeX() - npcTradeShop._alertpanel:GetSizeX()) / 2, (npcTradeShop._alertpanel:GetSizeY() + Panel_Npc_Trade_Market:GetSizeY() - getScreenSizeY()) / 2)
    npcTradeShop._alerttext:SetSpanSize((getScreenSizeX() - npcTradeShop._alerttext:GetSizeX()) / 2, (npcTradeShop._alerttext:GetSizeY() + Panel_Npc_Trade_Market:GetSizeY() - getScreenSizeY()) / 2)
    npcTradeShop._alerttext:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_WindowTradeMarket_NeedInvest", "npc_tradenodename", npcTradeNodeName))
    local isNpcNodeCotrol = getDialogButtonIndexByType(CppEnums.ContentsType.Contents_Explore)
    if -1 ~= isNpcNodeCotrol then
      npcTradeShop._btnInvestNode:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_WindowTradeMarket_NodeButton"))
      npcTradeShop._btnInvestNode:SetSize(npcTradeShop._btnInvestNode:GetTextSizeX() + 40, npcTradeShop._btnInvestNode:GetSizeY())
      npcTradeShop._btnInvestNode:SetSpanSize((getScreenSizeX() - npcTradeShop._btnInvestNode:GetSizeX()) / 2, npcTradeShop._alertpanel:GetPosY() + npcTradeShop._alertpanel:GetSizeY() + 10)
      npcTradeShop._btnInvestNode:addInputEvent("Mouse_LUp", "click_OpenWorldMap_InvestNode()")
      npcTradeShop._btnInvestNode:SetShow(true)
    else
      npcTradeShop._btnInvestNode:SetShow(false)
    end
  else
    npcTradeShop._alertpanel:SetShow(false)
    npcTradeShop._alerttext:SetShow(false)
    npcTradeShop._btnInvestNode:SetShow(false)
  end
  FGlobal_RemoteControl_Show(2)
end
function click_OpenWorldMap_InvestNode()
  closeNpcTrade_Basket()
  local buttonIndex = getDialogButtonIndexByType(CppEnums.ContentsType.Contents_Explore)
  if true == _ContentsGroup_NewUI_Dialog_All then
    HandleEventLUp_DialogMain_All_FuncButton(buttonIndex)
  else
    HandleClickedFuncButton(buttonIndex)
  end
end
function TradeShopGraphRefresh()
  if true == global_IsTrading then
    local rv = global_updateCurrentCommerce()
    if true == rv then
      global_sellItemFromPlayer()
      global_setBuyList()
    end
  end
end
function TradeShopMoneyRefresh()
  if true == _ContentsGroup_InvenUpdateCheck and false == Panel_Npc_Trade_Market:GetShow() then
    return
  end
  if true == global_IsTrading then
    if true == npcTradeShop._buyRequest then
      currentTradeSlot = 1
      npcTradeShop._numpadNumber = toInt64(0, 1)
      npcTradeShop:InitTradeMarket()
      npcTradeShop:initTradeData()
      TradeItem_BuySuccess()
    end
    local selfPlayerWrapper = getSelfPlayer()
    local selfPlayer = selfPlayerWrapper:get()
    local selfPlayerPossessableWeigh = selfPlayer:getPossessableWeight_s64()
    local selfPlayerCurrentWeigh = selfPlayer:getCurrentWeight_s64()
    npcTradeShop._myRemainWeight = selfPlayerPossessableWeigh - selfPlayerCurrentWeigh
    local itemWeightDiv100 = selfPlayerPossessableWeigh / const_64.s64_100
    local s64_CurrentWeight = selfPlayerCurrentWeigh / const_64.s64_100
    local str_int32remainWeight = string.format("%.1f", Int64toInt32(itemWeightDiv100 - s64_CurrentWeight) / 100)
    npcTradeShop._currentWeightLT:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_WindowTradeMarket_Weight", "Weight", tostring(str_int32remainWeight)))
    npcTradeShop._staticPossessMoneyValue:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
    eventBuyFromNpcListRefesh()
    global_refreshScrollIndex()
    InventoryWindow_Close()
  end
end
function TradeItem_BuySuccess()
  local tradeItemMessage = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_BUYING_SUCCESS")
  npcTradeShop._alertpanel:SetSpanSize((getScreenSizeX() - npcTradeShop._alertpanel:GetSizeX()) / 2, (npcTradeShop._alertpanel:GetSizeY() + Panel_Npc_Trade_Market:GetSizeY() - getScreenSizeY()) / 3)
  npcTradeShop._alerttext:SetSpanSize((getScreenSizeX() - npcTradeShop._alerttext:GetSizeX()) / 2, (npcTradeShop._alerttext:GetSizeY() + Panel_Npc_Trade_Market:GetSizeY() - getScreenSizeY()) / 3)
  npcTradeShop._alertpanel:SetShow(true)
  npcTradeShop._alerttext:SetShow(true)
  npcTradeShop._alerttext:SetText(tradeItemMessage)
end
function npcTradeShop:registTradeShopEvent()
  registerEvent("onScreenResize", "eventResetTradeUI")
  registerEvent("EventNpcTradeShopUpdate", "InitNpcTradeShopOpen")
  registerEvent("EventNpcTradeShopGraphRefresh", "TradeShopGraphRefresh")
  registerEvent("FromClient_InventoryUpdate", "TradeShopMoneyRefresh")
  registerEvent("FromClient_ServantInventoryUpdate", "check_Servant_Inventory")
end
function refreshEarnProfit(profit)
  npcTradeShop._staticEarnProfitValue:SetText(tostring(profit))
  npcTradeShop._staticEarnProfitValue:SetShow(true)
  npcTradeShop._staticEarnProfitText:SetShow(true)
  npcTradeShop._staticEarnProfitCoin:SetShow(true)
end
npcTradeShop:registUiControl()
npcTradeShop:InitTradeMarket()
npcTradeShop:registTradeShopEvent()

local _panel = Panel_TradeMarket_Basket
local TradeMarketBasket = {
  _ui = {
    stc_TitleBg = UI.getChildControl(_panel, "Static_TitleBg"),
    stc_TabBg = UI.getChildControl(_panel, "Static_TabBg"),
    list_BasketList = UI.getChildControl(_panel, "List2_MyItem"),
    stc_StateBg = UI.getChildControl(_panel, "Static_StateBg"),
    stc_BottomBg = UI.getChildControl(_panel, "Static_BottomBG")
  },
  _basketSlotList = {},
  _basketDataList = {},
  _tradeBuyMaxCount = 9,
  _currentTradeSlot = 0,
  _selectClickItemKey = 0,
  _selectClickIndex = 1,
  _totalCost = 0,
  _totalWeight = toInt64(0, 0),
  _currentInvenTab = 0,
  _invenTabStartX = 0,
  _isShip = false
}
function TradeMarketBasket:init()
  self._ui.btn_MyInven = UI.getChildControl(self._ui.stc_TabBg, "RadioButton_MyInven")
  self._ui.btn_VehicleInven = UI.getChildControl(self._ui.stc_TabBg, "RadioButton_LandVehicleInven")
  self._ui.txt_HaveMoney = UI.getChildControl(self._ui.stc_StateBg, "StaticText_HaveMoney")
  self._ui.txt_NeedMoney = UI.getChildControl(self._ui.stc_StateBg, "StaticText_NeedMoney")
  self._ui.txt_CurrentWeight = UI.getChildControl(self._ui.stc_StateBg, "StaticText_CurrentWeight")
  self._ui.txt_NeedWeight = UI.getChildControl(self._ui.stc_StateBg, "StaticText_NeedWeight")
  self._ui.txt_AConsole = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_A_ConsoleUI")
  self._ui.txt_BConsole = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_B_ConsoleUI")
  local keyGuides = {
    self._ui.txt_AConsole,
    self._ui.txt_BConsole
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, 44, 5)
  self._ui.txt_XConsole = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_X_ConsoleUI")
  self._ui.txt_YConsole = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_Y_ConsoleUI")
  keyGuides = {
    self._ui.txt_XConsole,
    self._ui.txt_YConsole
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, 44, 5)
  self:registEvent()
  self._invenTabStartX = self._ui.btn_MyInven:GetPosX()
  PaGlobal_TradeMarketBasket_OnResize()
end
function TradeMarketBasket:registEvent()
  self._ui.list_BasketList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_TradeMarketBasket_CreateList")
  self._ui.list_BasketList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobal_TradeMarketBasket_BuyAll()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobal_TradeMarketBasket_FreeBasket()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LT, "PaGlobal_TradeMarketBasket_ChangeTab(" .. 0 .. ")")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RT, "PaGlobal_TradeMarketBasket_ChangeTab(" .. 1 .. ")")
  registerEvent("FromClient_InventoryUpdate", "PaGlobal_TradeMarketBasket_UpdateBasket")
end
function TradeMarketBasket:open()
  local isServant = PaGlobal_TradeMarket_CheckServant()
  if nil == isServant or false == isServant then
    self._ui.btn_VehicleInven:SetShow(false)
  else
    self._ui.btn_VehicleInven:SetShow(true)
  end
  if true == isServant then
    self._ui.btn_MyInven:SetPosX(self._invenTabStartX - 60)
  else
    self._ui.btn_MyInven:SetPosX(self._invenTabStartX)
  end
  PaGlobal_TradeMarketBasket_ChangeTab(0)
  self:update()
  _panel:SetShow(true)
end
function TradeMarketBasket:close()
  self:freeBasket()
  _panel:SetShow(false)
end
function TradeMarketBasket:update()
  self:freeBasket()
  local selfPlayer = getSelfPlayer():get()
  local myMoney = selfPlayer:getInventory():getMoney_s64()
  self._ui.txt_HaveMoney:SetText(PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_STD_TXT_MONEY") .. " : " .. makeDotMoney(myMoney))
  self:updateWeight()
  PaGlobal_TradeMarketBasket_TotalCalculateMoney()
  self._ui.list_BasketList:getElementManager():clearKey()
  for idx = 0, self._currentTradeSlot - 1 do
    self._ui.list_BasketList:getElementManager():pushKey(toInt64(0, idx))
  end
end
function TradeMarketBasket:updateWeight()
  local selfPlayer = getSelfPlayer():get()
  if 0 == self._currentInvenTab then
    local selfPlayerPossessableWeigh = selfPlayer:getPossessableWeight_s64()
    local selfPlayerCurrentWeigh = selfPlayer:getCurrentWeight_s64()
    self._currentWeight = selfPlayerPossessableWeigh - selfPlayerCurrentWeigh
    local itemWeightDiv100 = selfPlayerPossessableWeigh / Defines.s64_const.s64_100
    local s64_CurrentWeight = selfPlayerCurrentWeigh / Defines.s64_const.s64_100
    local str_int32remainWeight = string.format("%.1f", Int64toInt32(itemWeightDiv100 - s64_CurrentWeight) / 100)
    self._ui.txt_CurrentWeight:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_WindowTradeMarket_Weight", "Weight", tostring(str_int32remainWeight)))
  elseif 1 == self._currentInvenTab then
    local checkServant, maxInventorySlot, freeInventorySlot, remainWeight = PaGlobal_TradeMarket_CheckServant()
    self._currentWeight = remainWeight
    local vehicleRemainWeightValue = string.format("%.1f", Int64toInt32(remainWeight / Defines.s64_const.s64_10000))
    self._ui.txt_CurrentWeight:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_WindowTradeMarket_Weight", "Weight", tostring(vehicleRemainWeightValue)))
  end
end
function TradeMarketBasket:freeBasket()
  self._basketSlotList = {}
  self._basketDataList = {}
  self._currentTradeSlot = 0
  self._totalCost = 0
  self._totalWeight = 0
  self._ui.txt_AConsole:SetMonoTone(true)
  self._ui.txt_XConsole:SetMonoTone(true)
  self._ui.txt_YConsole:SetMonoTone(true)
  self._ui.list_BasketList:getElementManager():clearKey()
end
function PaGlobal_TradeMarketBasket_Open()
  local self = TradeMarketBasket
  self:open()
end
function PaGlobal_TradeMarketBasket_Close()
  local self = TradeMarketBasket
  self:close()
end
function PaGlobal_TradeMarketBasket_FreeBasket()
  local self = TradeMarketBasket
  self:freeBasket()
  PaGlobal_TradeMarketBasket_TotalCalculateMoney()
end
function PaGlobal_TradeMarketBasket_UpdateBasket()
  local self = TradeMarketBasket
  self:update()
end
function PaGlobal_TradeMarketBasket_AddConfirm(inputNumber, param)
  local self = TradeMarketBasket
  local rv = PaGlobal_TradeMarketBasket_AddBasket(param[0], param[1], inputNumber)
  if 0 == rv and true == param[2] then
    return
  end
  local npcSceneCharacterKey = getClientSceneKey()
  if true == param[2] and 0 ~= npcSceneCharacterKey then
    callAIHandlerByIndex(1, gDialogSceneIndex[param[3]], "SceneTradeBuy")
  else
    PaGlobal_TradeMarketBasket_TotalCalculateMoney()
  end
end
function PaGlobal_TradeMarketBasket_AddBasket(slotItemKey, index, itemCount)
  local self = TradeMarketBasket
  if self._tradeBuyMaxCount < self._currentTradeSlot then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_NOTIFYDISPLAY"))
    UI.ASSERT(false, "\235\132\136\235\172\180 \235\167\142\236\157\180 \235\139\180\236\156\188\235\160\164\234\179\160 \237\149\169\235\139\136\235\139\164.")
    return 0
  end
  if nil ~= self._basketDataList[slotItemKey] then
    return 0
  end
  local shopItemWrapper = npcShop_getItemBuy(index)
  local itemSS = shopItemWrapper:getStaticStatus()
  local buyData = {
    _itemCount = toInt64(0, 0),
    _slotIndex = 0,
    _itemKey = 0,
    _commerceTypeIndex = 0,
    _totalMoney = toInt64(0, 0),
    _itemWeight = toInt64(0, 0)
  }
  buyData._itemCount = itemCount
  buyData._slotIndex = index
  buyData._itemKey = slotItemKey
  buyData._commerceTypeIndex = itemSS:getCommerceType()
  buyData._totalMoney = itemCount * shopItemWrapper:get().price_s64
  buyData._itemWeight = itemCount * toInt64(0, itemSS:get()._weight)
  self._basketSlotList[self._currentTradeSlot] = buyData
  self._basketDataList[slotItemKey] = buyData
  self._selectClickItemKey = slotItemKey
  self._selectClickIndex = self._currentTradeSlot
  self._ui.list_BasketList:getElementManager():pushKey(toInt64(0, self._currentTradeSlot))
  self._currentTradeSlot = self._currentTradeSlot + 1
  self._ui.txt_AConsole:SetMonoTone(false)
  self._ui.txt_XConsole:SetMonoTone(false)
  self._ui.txt_YConsole:SetMonoTone(false)
  PaGlobal_TradeMarketBasket_TotalCalculateMoney()
  return 1
end
function PaGlobal_TradeMarketBasket_TotalCalculateMoney()
  local self = TradeMarketBasket
  local totalItemPrice = toInt64(0, 0)
  for count = 0, self._currentTradeSlot - 1 do
    totalItemPrice = totalItemPrice + self._basketSlotList[count]._totalMoney
  end
  local totalItemWeight = toInt64(0, 0)
  for count = 0, self._currentTradeSlot - 1 do
    totalItemWeight = totalItemWeight + self._basketSlotList[count]._itemWeight
  end
  self._totalCost = totalItemPrice
  self._totalWeight = totalItemWeight
  self._ui.txt_NeedMoney:SetText(PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_STD_TXT_NEEDCOST") .. " : " .. makeDotMoney(totalItemPrice))
  local itemWeight = string.format("%.1f", Int64toInt32(self._totalWeight) / 10000)
  if self._currentWeight < self._totalWeight then
    self._ui.txt_NeedWeight:SetFontColor(Defines.Color.C_FFD20000)
  else
    self._ui.txt_NeedWeight:SetFontColor(Defines.Color.C_FFFFBC3A)
  end
  self._ui.txt_NeedWeight:SetText(itemWeight .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT"))
end
function PaGlobal_TradeMarketBasket_BuyAll()
  local self = TradeMarketBasket
  if self._currentTradeSlot < 1 then
    return
  end
  if 0 == self._currentInvenTab then
    PaGlobal_TradeMarketBasket_BuyAllToMyInvenConfirm()
  elseif 1 == self._currentInvenTab then
    PaGlobal_TradeMarketBasket_BuyToServantConfirm()
  end
end
function PaGlobal_TradeMarketBasket_BuyAllToMyInvenConfirm()
  local titleString = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_BuyMsg_UseInvenTitle")
  local contentString = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_BuyMsg_UseInvenContent")
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = PaGlobal_TradeMarketBasket_BuyToMyInvenConfirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobal_TradeMarketBasket_BuyToMyInvenConfirm()
  PaGlobal_TradeMarketBasket_BuyItem(0, 0)
end
function PaGlobal_TradeMarketBasket_BuyToServantConfirm()
  local self = TradeMarketBasket
  local myLandVehicle = getTemporaryInformationWrapper()
  local myLandVehicleActorKey = myLandVehicle:getUnsealVehicle(false):getActorKeyRaw()
  local servantWrapper = getVehicleActor(myLandVehicleActorKey)
  local servantActor = servantWrapper:get()
  local max_weight = Int64toInt32(servantActor:getPossessableWeight_s64() / Defines.s64_const.s64_10000)
  local total_weight = Int64toInt32(servantActor:getCurrentWeight_s64() / Defines.s64_const.s64_10000)
  if max_weight - total_weight < Int64toInt32(self._totalWeight) / 10000 then
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
  PaGlobal_TradeMarketBasket_BuyItem(0, 4)
end
function PaGlobal_TradeMarketBasket_BuyItem(fromWhere, toWhere)
  local self = TradeMarketBasket
  local rv = PaGlobal_TradeMarketBasket_CheckBuyableItem()
  if 0 ~= rv then
    return
  end
  local servantType = 0
  if true == self._isShip then
    servantType = 1
  end
  for _, slotData in pairs(self._basketSlotList) do
    if toInt64(0, 0) ~= slotData._itemCount then
      local itemCount32 = Int64toInt32(slotData._itemCount)
      for count = 0, itemCount32 - 1 do
        rv = npcShop_doBuy(slotData._slotIndex, 1, fromWhere, toWhere, false)
      end
    end
  end
end
function PaGlobal_TradeMarketBasket_CheckBuyableItem()
  local self = TradeMarketBasket
  local myMoney = getSelfPlayer():get():getInventory():getMoney_s64()
  if myMoney < self._totalCost then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Money"))
    return -1
  end
  return 0
end
function PaGlobal_TradeMarketBasket_CheckBasketItem(checkItemKey)
  local self = TradeMarketBasket
  return nil ~= self._basketDataList[checkItemKey]
end
function PaGlobal_TradeMarketBasket_CreateList(content, key)
  local self = TradeMarketBasket
  local basketIdx = Int64toInt32(key)
  local slotData = self._basketSlotList[basketIdx]
  if nil == slotData then
    return
  end
  local shopItemWrapper = npcShop_getItemBuy(slotData._slotIndex)
  local itemSS = shopItemWrapper:getStaticStatus()
  local itemCount = Int64toInt32(slotData._itemCount)
  local stc_Bg = UI.getChildControl(content, "Static_Bg")
  local stc_ItemSlotBg = UI.getChildControl(content, "Static_ItmeSlotBg")
  local txt_Name = UI.getChildControl(content, "StaticText_ItemName")
  local txt_Count = UI.getChildControl(content, "StaticText_Count")
  local txt_Price = UI.getChildControl(content, "StaticText_Price")
  local stc_Icon = UI.getChildControl(stc_ItemSlotBg, "Static_ItemIcon")
  txt_Name:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  txt_Name:SetText(itemSS:getName())
  txt_Count:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKET_BUYCONFIRM_COUNT") .. " " .. tostring(itemCount))
  stc_Icon:ChangeTextureInfoNameAsync("Icon/" .. itemSS:getIconPath())
  txt_Price:SetText(makeDotMoney(slotData._totalMoney))
  stc_Bg:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_TradeMarketBasket_AddMoreBasket(" .. basketIdx .. ")")
end
function PaGlobal_TradeMarketBasket_AddMoreBasket(basketIdx)
  local self = TradeMarketBasket
  local slotData = self._basketSlotList[basketIdx]
  if nil == slotData then
    _PA_ASSERT(false, "_basketSlotList \234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PaGlobal_TradeMarketBasket_AddMoreBasket")
    return
  end
  local param = {
    [0] = basketIdx
  }
  local tradeItemWrapper = npcShop_getTradeItem(slotData._itemKey)
  local buyableStack = tradeItemWrapper:getRemainStackCount()
  Panel_NumberPad_Show(true, buyableStack, param, PaGlobal_TradeMarketBasket_AddMoreConfirm)
end
function PaGlobal_TradeMarketBasket_AddMoreConfirm(inputNumber, param)
  local self = TradeMarketBasket
  local basketIdx = param[0]
  local slotData = self._basketSlotList[basketIdx]
  if nil == slotData then
    _PA_ASSERT(false, "_basketSlotList \234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PaGlobal_TradeMarketBasket_AddMoreBasket")
    return
  end
  local shopItemWrapper = npcShop_getItemBuy(slotData._slotIndex)
  local itemSS = shopItemWrapper:getStaticStatus()
  slotData._itemCount = inputNumber
  slotData._totalMoney = inputNumber * shopItemWrapper:get().price_s64
  slotData._itemWeight = inputNumber * toInt64(0, itemSS:get()._weight)
  self._ui.list_BasketList:requestUpdateByKey(toInt64(0, basketIdx))
  PaGlobal_TradeMarketBasket_TotalCalculateMoney()
end
function PaGlobal_TradeMarketBasket_ChangeTab(idx)
  local self = TradeMarketBasket
  if 0 == idx then
    self._ui.btn_MyInven:SetCheck(true)
    self._ui.btn_VehicleInven:SetCheck(false)
    self._currentInvenTab = idx
  elseif 1 == idx and true == self._ui.btn_VehicleInven:GetShow() then
    self._ui.btn_VehicleInven:SetCheck(true)
    self._ui.btn_MyInven:SetCheck(false)
    self._currentInvenTab = idx
  end
  self:updateWeight()
  PaGlobal_TradeMarketBasket_TotalCalculateMoney()
end
function PaGlobal_TradeMarketBasket_Init()
  local self = TradeMarketBasket
  self:init()
end
function PaGlobal_TradeMarketBasket_OnResize()
  local self = TradeMarketBasket
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local panelSizeX = _panel:GetSizeX()
  local panelSizeY = _panel:GetSizeY()
  _panel:SetSize(panelSizeX, screenSizeY)
  _panel:ComputePos()
  self._ui.stc_TitleBg:ComputePos()
  self._ui.stc_BottomBg:ComputePos()
  self._ui.stc_StateBg:ComputePos()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_TradeMarketBasket_Init")
function global_enterBasketInShop(slotItemKey, index, itemCount)
  PaGlobal_TradeMarketBasket_AddBasket(slotItemKey, index, itemCount)
end
function totalCalculateMoney()
  PaGlobal_TradeMarketBasket_TotalCalculateMoney()
end
function TradeMarket_BuySome_ConfirmFunction(inputNumber, param)
  PaGlobal_TradeMarketBasket_AddConfirm(inputNumber, param)
end
function global_CheckItem_From_Cart(checkItemKey)
  PaGlobal_TradeMarketBasket_CheckBasketItem(checkItemKey)
end

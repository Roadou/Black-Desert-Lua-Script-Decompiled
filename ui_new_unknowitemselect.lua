local IM = CppEnums.EProcessorInputMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local ENT = CppEnums.ExplorationNodeType
local UI_color = Defines.Color
local UI_TYPE = CppEnums.PA_UI_CONTROL_TYPE
local UI_TM = CppEnums.TextMode
local VCK = CppEnums.VirtualKeyCode
local isReserveContentOpen = ToClient_IsContentsGroupOpen("1023")
Panel_Window_UnknownRandomSelect:SetDragEnable(true)
Panel_Window_UnknownRandomSelect:SetDragAll(true)
local _selectSlotNo = -1
local _priceRate = -1
local _itemIcon = UI.getChildControl(Panel_Window_UnknownRandomSelect, "Static_ItemIcon")
local _itemNameValue = UI.getChildControl(Panel_Window_UnknownRandomSelect, "StaticText_UnknowItemName")
local _itemValue = UI.getChildControl(Panel_Window_UnknownRandomSelect, "StaticText_ItemPriceValue")
local _itemButtonReSelect = UI.getChildControl(Panel_Window_UnknownRandomSelect, "Button_ItemReSelect")
local _itemButtonSelect = UI.getChildControl(Panel_Window_UnknownRandomSelect, "Button_ItemSelect")
local _myInven = UI.getChildControl(Panel_Window_UnknownRandomSelect, "StaticText_Money")
local _myWareHouse = UI.getChildControl(Panel_Window_UnknownRandomSelect, "StaticText_Money2")
local _myInvenBtn = UI.getChildControl(Panel_Window_UnknownRandomSelect, "RadioButton_Icon_Money")
local _myWareHouseBtn = UI.getChildControl(Panel_Window_UnknownRandomSelect, "RadioButton_Icon_Money2")
local _iconSilver = UI.getChildControl(Panel_Window_UnknownRandomSelect, "StaticText_Gold_Icon3")
local _itemPriceBG = UI.getChildControl(Panel_Window_UnknownRandomSelect, "StaticText_ItemPrice")
local _reserveButton = UI.getChildControl(Panel_Window_UnknownRandomSelect, "Button_Reserve")
local _reserveAni = UI.getChildControl(Panel_Window_UnknownRandomSelect, "Static_SequenceSlotAni")
_reserveAni:SetShow(false)
local _reserveTime = UI.getChildControl(Panel_Window_UnknownRandomSelect, "StaticText_ReservationLeftTime")
local shopTypeNum
local randomShopItemPrice = 0
function randomSelect_ReserveAni(isShow)
  if 44672 == dialog_getTalkNpcKey() then
    isShow = false
  end
  _reserveAni:SetShow(isShow)
  _reserveAni:setUpdateTextureAni(isShow)
  _reserveTime:SetShow(isShow)
  if false == isShow then
    _reserveTime:SetText(nil)
  else
    ToClient_UpdateRandomShopKeepTime()
  end
end
function randomShopShow(slotNo, priceRate)
  _priceRate = priceRate
  local sellCount = npcShop_getBuyCount()
  local selfPlayer = getSelfPlayer()
  local MyWp = selfPlayer:getWp()
  for ii = 0, sellCount - 1 do
    local itemwrapper = npcShop_getItemBuy(ii)
    local shopItem = itemwrapper:get()
    if slotNo == shopItem.shopSlotNo then
      _selectSlotNo = shopItem.shopSlotNo
      itemRandomSS = itemwrapper:getStaticStatus()
      sellPrice_64 = itemRandomSS:get()._sellPriceToNpc_s64
      sellPrice_32 = Int64toInt32(sellPrice_64)
      if nil ~= itemRandomSS then
        local itemIconPath = itemRandomSS:getIconPath()
        _itemIcon:ChangeTextureInfoName("Icon/" .. itemIconPath)
        _itemIcon:addInputEvent("Mouse_On", "ItemRandomShowToolTip( " .. ii .. ", " .. slotNo .. " )")
        local price32 = Int64toInt32(shopItem.price_s64)
        price32 = price32 * priceRate / 1000000
        randomShopItemPrice = price32
        _itemValue:SetText(makeDotMoney(price32))
        _iconSilver:SetPosX(_itemPriceBG:GetPosX() + 50)
        _itemValue:SetPosX(_iconSilver:GetPosX() + _iconSilver:GetSizeX() + 10)
        _itemNameValue:SetText(itemRandomSS:getName())
      end
    end
  end
  if 12 == shopTypeNum then
    useWp = ToClient_getRandomShopConsumWp()
    if 44672 == dialog_getTalkNpcKey() then
      _reserveButton:SetShow(false)
    else
      _reserveButton:SetShow(isReserveContentOpen)
    end
  elseif 13 == shopTypeNum then
    useWp = 10
    _reserveButton:SetShow(false)
  end
  if true == ToClient_IsRandomShopKeepItem() and 12 == shopTypeNum then
    randomSelect_ReserveAni(true)
  else
    randomSelect_ReserveAni(false)
  end
  if MyWp < useWp then
    _itemButtonReSelect:SetEnable(false)
    _itemButtonReSelect:SetMonoTone(true)
  elseif true == ToClient_isReSelectRandomShopItem() then
    _itemButtonReSelect:SetEnable(true)
    _itemButtonReSelect:SetMonoTone(false)
  else
    _itemButtonReSelect:SetEnable(false)
    _itemButtonReSelect:SetMonoTone(true)
  end
  if 12 == shopTypeNum and true == ToClient_IsRandomShopKeepItem() and 44672 == dialog_getTalkNpcKey() then
    _itemButtonReSelect:SetEnable(false)
    _itemButtonReSelect:SetMonoTone(true)
    _itemButtonSelect:SetEnable(false)
    _itemButtonSelect:SetMonoTone(true)
  else
    _itemButtonSelect:SetEnable(true)
    _itemButtonSelect:SetMonoTone(false)
  end
  local btnReSelectSizeX = _itemButtonReSelect:GetSizeX() + 23
  local btnReSelectTextPosX = btnReSelectSizeX - btnReSelectSizeX / 2 - _itemButtonReSelect:GetTextSizeX() / 2
  _itemButtonReSelect:SetTextSpan(btnReSelectTextPosX, 5)
  local btnSelectSizeX = _itemButtonSelect:GetSizeX() + 23
  local btnSelectTextPosX = btnSelectSizeX - btnSelectSizeX / 2 - _itemButtonSelect:GetTextSizeX() / 2
  _itemButtonSelect:SetTextSpan(btnSelectTextPosX, 5)
  randomSelectShow()
end
function randomSelectShow()
  Panel_Window_UnknownRandomSelect:SetShow(true)
  if ToClient_HasWareHouseFromNpc() then
    if toInt64(0, 0) == warehouse_moneyFromNpcShop_s64() then
      _myInvenBtn:SetCheck(true)
      _myWareHouseBtn:SetCheck(false)
    else
      _myInvenBtn:SetCheck(false)
      _myWareHouseBtn:SetCheck(true)
    end
  else
    _myInvenBtn:SetCheck(true)
    _myWareHouseBtn:SetCheck(false)
  end
  _myInven:SetPosX(_myInvenBtn:GetPosX() + _myInvenBtn:GetTextSizeX() + 35)
  _myWareHouse:SetPosX(_myWareHouseBtn:GetPosX() + _myWareHouseBtn:GetTextSizeX() + 35)
end
function randomSelectHide()
  Panel_Window_UnknownRandomSelect:SetShow(false)
end
function click_ItemReSelect()
  messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_TITLE")
  local isConsumWP = ToClient_getRandomShopConsumWp()
  if 12 == shopTypeNum then
    contentString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_STRING", "getWp", getSelfPlayer():getWp(), "itemWP", isConsumWP)
  elseif 13 == shopTypeNum then
    contentString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_STRING2", "getWp", getSelfPlayer():getWp())
  end
  local messageboxData = {
    title = messageTitle,
    content = contentString,
    functionYes = Item_RequestShopList,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function click_ReserveKeepItem()
  ToClient_ReserveRandomShopItem(_selectSlotNo, _priceRate)
end
function Item_RequestShopList()
  local myWp = getSelfPlayer():getWp()
  if 12 == shopTypeNum then
    useWp = ToClient_getRandomShopConsumWp()
  elseif 13 == shopTypeNum then
    useWp = 10
  end
  if myWp < useWp then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_WP_SHORTAGE_ACK"))
    randomSelectHide()
  else
    npcShop_requestList(CppEnums.ContentsType.Contents_Shop, true)
    if myWp < useWp then
      _itemButtonReSelect:SetEnable(false)
      _itemButtonReSelect:SetMonoTone(true)
    else
      _itemButtonReSelect:SetEnable(true)
      _itemButtonReSelect:SetMonoTone(false)
    end
  end
end
function click_ItemSelect()
  messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_TITLE")
  messageMemo = PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_BUYITEMCONFIRM")
  local messageboxData = {
    title = messageTitle,
    content = messageMemo,
    functionYes = Item_RequestDoBuy,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function Item_RequestDoBuy()
  local invenCheck = _myInvenBtn:IsCheck()
  local wareHouseMoney = warehouse_moneyFromNpcShop_s64()
  local moneyWhereType = CppEnums.ItemWhereType.eInventory
  if invenCheck then
    moneyWhereType = CppEnums.ItemWhereType.eInventory
    if getSelfPlayer():get():getInventory():getMoney_s64() < toInt64(0, randomShopItemPrice) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Money"))
    end
  else
    moneyWhereType = CppEnums.ItemWhereType.eWarehouse
    if wareHouseMoney < toInt64(0, randomShopItemPrice) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RANDOMITEM_WAREHOUSEMONEY"))
      return
    else
    end
  end
  npcShop_doBuyInRandomShop(_selectSlotNo, 1, moneyWhereType, 0, _priceRate)
  _priceRate = -1
  _selectSlotNo = -1
  Panel_Window_UnknownRandomSelect:SetShow(false)
end
function FGlobal_ItemRandom_Money_Update()
  _myInven:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  _myWareHouse:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
end
function ItemRandomShowToolTip(ii, slotNo)
  local itemwrapper = npcShop_getItemBuy(ii)
  if nil ~= itemwrapper then
    local itemRandomSS = itemwrapper:getStaticStatus()
    Panel_Tooltip_Item_Show(itemRandomSS, _itemIcon, true, false, nil)
  end
end
function ItemRandomHideToolTip()
  Panel_Tooltip_Item_hideTooltip()
end
function itemShop_registEventHandler()
  _itemButtonReSelect:addInputEvent("Mouse_LUp", "click_ItemReSelect()")
  _itemButtonSelect:addInputEvent("Mouse_LUp", "click_ItemSelect()")
  _itemIcon:addInputEvent("Mouse_Out", "ItemRandomHideToolTip()")
  _reserveButton:addInputEvent("Mouse_LUp", "click_ReserveKeepItem()")
end
function FromClient_EventRandomShopShow_Random(shopType, slotNo, priceRate)
  shopTypeNum = shopType
  if 12 == shopType or 13 == shopType then
    randomShopShow(slotNo, priceRate)
  end
end
function FromClient_NotifyRandomShop(notifyType)
  if 2 == notifyType then
    randomSelect_ReserveAni(false)
  elseif 3 == notifyType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RESERVED_RANDOMSHOPITEM"))
    randomSelect_ReserveAni(true)
  elseif 4 == notifyType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CLEAR_RANDOMSHOPITEM"))
    randomSelect_ReserveAni(false)
  elseif 5 == notifyType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PURCHASE_RANDOMSHOPITEM"))
    randomSelect_ReserveAni(false)
  end
end
function FromClient_UpdateRandomShopKeepTime(u16_year, u16_month, u16_day, u16_hour, u16_minute)
  local tempStr = {
    [0] = tostring(u16_minute) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE"),
    [1] = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_HOUR", "hour", tostring(u16_hour)),
    [2] = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(u16_day)),
    [3] = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MONTH", "month", tostring(u16_month)),
    [4] = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", tostring(u16_year))
  }
  local resultString = ""
  if true == isGameServiceTypeTurkey() then
    resultString = tempStr[2] .. "" .. tempStr[3] .. "" .. tempStr[4] .. "" .. tempStr[1] .. "" .. tempStr[0]
  else
    resultString = tempStr[4] .. "" .. tempStr[3] .. "" .. tempStr[2] .. "" .. tempStr[1] .. "" .. tempStr[0]
  end
  _reserveTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENDTIME_RANDOMSHOPITEM") .. resultString)
end
registerEvent("FromClient_UpdateRandomShopKeepTime", "FromClient_UpdateRandomShopKeepTime")
registerEvent("FromClient_NotifyRandomShop", "FromClient_NotifyRandomShop")
registerEvent("FromClient_EventRandomShopShow", "FromClient_EventRandomShopShow_Random")
registerEvent("EventWarehouseUpdate", "FGlobal_ItemRandom_Money_Update")
itemShop_registEventHandler()
FGlobal_ItemRandom_Money_Update()

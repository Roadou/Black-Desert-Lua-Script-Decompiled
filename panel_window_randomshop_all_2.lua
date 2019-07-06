function PaGlobalFunc_RandomShop_All_Open(slotNo, priceRate)
  PaGlobal_RandowShop_All:prepareOpen(slotNo, priceRate)
end
function PaGlobalFunc_RandomShop_All_Close()
  PaGlobal_RandowShop_All:prepareClose()
end
function HandleEventOn_RandomShop_All_ItemTooltip(ii, slotNo)
  local itemwrapper = npcShop_getItemBuy(ii)
  if nil ~= itemwrapper then
    local itemRandomSS = itemwrapper:getStaticStatus()
    Panel_Tooltip_Item_Show(itemRandomSS, PaGlobal_RandowShop_All._ui.stc_itemSlot, true, false, nil)
  end
end
function HandleEventOut_RandomShop_All_ItemTooltipHide()
  Panel_Tooltip_Item_hideTooltip()
end
function HandleEventLUp_RandomShop_All_OtherItemShow()
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_TITLE")
  local messageDesc = ""
  local isConsumWp = ToClient_getRandomShopConsumWp()
  if 12 == PaGlobal_RandowShop_All._shopTypeNum then
    messageDesc = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_STRING", "getWp", getSelfPlayer():getWp(), "itemWP", isConsumWp)
  elseif 13 == PaGlobal_RandowShop_All._shopTypeNum then
    messageDesc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_STRING2", "getWp", getSelfPlayer():getWp())
  end
  local messageboxData = {
    title = messageTitle,
    content = messageDesc,
    functionYes = PaGlobalFunc_RandomShop_All_RequestShopList,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function HandleEventLUp_RandomShop_All_BuyItem()
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_TITLE")
  local messageDesc = PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_BUYITEMCONFIRM")
  local messageboxData = {
    title = messageTitle,
    content = messageDesc,
    functionYes = PaGlobalFunc_RandomShop_All_BuyItem,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function HandleEventLUp_RandomShop_All_ReserveKeepItem()
  ToClient_ReserveRandomShopItem(PaGlobal_RandowShop_All._selectSlotNo, PaGlobal_RandowShop_All._priceRate)
end
function FromClient_RandomShop_All_EventRandomShopShow(shopType, slotNo, priceRate)
  if nil == Panel_Window_RandomShop_All then
    return
  end
  if nil == shopType or nil == slotNo or nil == priceRate then
    _PA_ASSERT_NAME(false, "FromClient_RandomShop_All_EventRandomShopShow\236\156\188\235\161\156 \235\147\164\236\150\180\236\152\164\235\138\148 \236\157\184\236\158\144\234\176\128 nil.", "\236\160\149\236\167\128\237\152\156")
  end
  PaGlobal_RandowShop_All._shopTypeNum = shopType
  if 12 == shopType or 13 == shopType then
    PaGlobalFunc_RandomShop_All_Open(slotNo, priceRate)
  end
end
function FromClient_RandomShop_All_UpdateRandomShopKeepTime(u16_year, u16_month, u16_day, u16_hour, u16_minute)
  if nil == Panel_Window_RandomShop_All then
    return
  end
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
  PaGlobal_RandowShop_All._ui.mtxt_reserveTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENDTIME_RANDOMSHOPITEM") .. resultString)
end
function FromClient_RandomShop_All_NotifyRandomShop(notifyType)
  if 2 == notifyType then
    PaGlobalFunc_RandomShop_All_ReserveAni(false)
  elseif 3 == notifyType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RESERVED_RANDOMSHOPITEM"))
    PaGlobalFunc_RandomShop_All_ReserveAni(true)
  elseif 4 == notifyType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CLEAR_RANDOMSHOPITEM"))
    PaGlobalFunc_RandomShop_All_ReserveAni(false)
  elseif 5 == notifyType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PURCHASE_RANDOMSHOPITEM"))
    PaGlobalFunc_RandomShop_All_ReserveAni(false)
  end
end
function FromClient_RandomShop_All_MoneyUpdate()
  if nil == Panel_Window_RandomShop_All then
    return
  end
  if false == PaGlobal_RandowShop_All._initialize then
    return
  end
  PaGlobal_RandowShop_All._ui.txt_invenMoney:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  PaGlobal_RandowShop_All._ui.txt_warehouseMoney:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
end
function PaGlobalFunc_RandomShop_All_ReserveAni(isShow)
  if nil == Panel_Window_RandomShop_All then
    return
  end
  if 44672 == dialog_getTalkNpcKey() then
    isShow = false
  end
  PaGlobal_RandowShop_All._ui.stc_reserveIcon:SetShow(isShow)
  PaGlobal_RandowShop_All._ui.stc_reserveIcon:setUpdateTextureAni(isShow)
  PaGlobal_RandowShop_All._ui.mtxt_reserveTime:SetShow(isShow)
  if false == isShow then
    PaGlobal_RandowShop_All._ui.mtxt_reserveTime:SetText(" ")
  else
    ToClient_UpdateRandomShopKeepTime()
  end
end
function PaGlobalFunc_RandomShop_All_RequestShopList()
  if nil == Panel_Window_RandomShop_All then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local myWp = selfPlayer:getWp()
  local useWp = 0
  if 12 == PaGlobal_RandowShop_All._shopTypeNum then
    useWp = ToClient_getRandomShopConsumWp()
  elseif 13 == PaGlobal_RandowShop_All._shopTypeNum then
    useWp = 10
  end
  if myWp < useWp then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_WP_SHORTAGE_ACK"))
    PaGlobalFunc_RandomShop_All_Close()
  else
    npcShop_requestList(CppEnums.ContentsType.Contents_Shop, true)
    if myWp < useWp then
      PaGlobal_RandowShop_All._ui_pc.btn_other:SetIgnore(true)
      PaGlobal_RandowShop_All._ui_pc.btn_other:SetMonoTone(true)
    else
      PaGlobal_RandowShop_All._ui_pc.btn_other:SetIgnore(false)
      PaGlobal_RandowShop_All._ui_pc.btn_other:SetMonoTone(false)
    end
  end
end
function PaGlobalFunc_RandomShop_All_BuyItem()
  local invenCheck = PaGlobal_RandowShop_All._ui.radio_inven:IsCheck()
  local wareHouseMoney = warehouse_moneyFromNpcShop_s64()
  local moneyWhereType = CppEnums.ItemWhereType.eInventory
  if true == invenCheck then
    moneyWhereType = CppEnums.ItemWhereType.eInventory
    if getSelfPlayer():get():getInventory():getMoney_s64() < toInt64(0, PaGlobal_RandowShop_All._randomShopItemPrice) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Money"))
      return
    end
  else
    moneyWhereType = CppEnums.ItemWhereType.eWarehouse
    if wareHouseMoney < toInt64(0, PaGlobal_RandowShop_All._randomShopItemPrice) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RANDOMITEM_WAREHOUSEMONEY"))
      return
    end
  end
  npcShop_doBuyInRandomShop(PaGlobal_RandowShop_All._selectSlotNo, 1, moneyWhereType, 0, PaGlobal_RandowShop_All._priceRate)
  PaGlobal_RandowShop_All._priceRate = -1
  PaGlobal_RandowShop_All._selectSlotNo = -1
  PaGlobalFunc_RandomShop_All_Close()
end

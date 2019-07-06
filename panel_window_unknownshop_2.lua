function HandleEventXUp_UnknownShop_ToggleItemTooltip(index)
  local itemWrapper = npcShop_getItemBuy(index)
  if true == PaGlobalFunc_TooltipInfo_GetShow() then
    PaGlobalFunc_TooltipInfo_Close()
  elseif nil ~= itemWrapper then
    local itemSSW = itemWrapper:getStaticStatus()
    PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.Item, 0)
  end
end
function HandleEventAUp_UnknownShop_BuyItem()
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_TITLE")
  local messageMemo = PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_BUYITEMCONFIRM")
  local messageBoxData = {
    title = messageTitle,
    content = messageMemo,
    functionApply = PaGlobal_UnknownShop_BuyItem,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBoxCheck.showMessageBox(messageBoxData)
end
function HandleEventYUp_UnknownShop_ReselectItem()
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_TITLE")
  local contentString
  local isConsumWP = ToClient_getRandomShopConsumWp()
  local playerWP = getSelfPlayer():getWp()
  if 12 == PaGlobal_UnknownShop._shopTypeNo then
    contentString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_STRING", "getWp", playerWP, "itemWP", isConsumWP)
  elseif 13 == PaGlobal_UnknownShop._shopTypeNo then
    contentString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_STRING2", "getWp", playerWP)
  end
  local messageboxData = {
    title = messageTitle,
    content = contentString,
    functionYes = PaGlobal_UnknownShop_UpdateShopList,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function HandleEventLT_UnknownShop_ReserveItem()
  ToClient_ReserveRandomShopItem(PaGlobal_UnknownShop._shopSlotNo, PaGlobal_UnknownShop._priceRate)
end
function FromClient_UnknownShop_Open(shopType, slotNo, priceRate)
  PaGlobal_UnknownShop._shopTypeNo = shopType
  if 12 == PaGlobal_UnknownShop._shopTypeNo or 13 == PaGlobal_UnknownShop._shopTypeNo then
    PaGlobal_UnknownShop:prepareOpen(slotNo, priceRate)
  end
end
function FromClient_UnknownShop_NotifyMessage(notifyType)
  if 2 == notifyType then
    PaGlobal_UnknownShop_ReserveAni(false)
  elseif 3 == notifyType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RESERVED_RANDOMSHOPITEM"))
    PaGlobal_UnknownShop_ReserveAni(true)
  elseif 4 == notifyType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CLEAR_RANDOMSHOPITEM"))
    PaGlobal_UnknownShop_ReserveAni(false)
  elseif 5 == notifyType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PURCHASE_RANDOMSHOPITEM"))
    PaGlobal_UnknownShop_ReserveAni(false)
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
  PaGlobal_UnknownShop._ui.txt_reserveTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENDTIME_RANDOMSHOPITEM") .. resultString)
end

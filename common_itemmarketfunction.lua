function PaGlobalFunc_ItemMarket_GetShow()
  return Panel_Window_ItemMarket:GetShow()
end
function PaGlobalFunc_ItemMarket_IsUISubApp()
  return Panel_Window_ItemMarket:IsUISubApp()
end
function PaGlobalFunc_ItemMarketBidDesc_GetShow()
  return Panel_ItemMarket_BidDesc:GetShow()
end
function PaGlobalFunc_ItemMarketFunction_GetShow()
  return Panel_Window_ItemMarket_Function:GetShow()
end
function PaGlobalFunc_ItemMarketAlarmList_GetShow()
  return Panel_Window_ItemMarketAlarmList_New:GetShow()
end
function PaGlobalFunc_ItemMarketAlarmList_IsUISubApp()
  return Panel_Window_ItemMarketAlarmList_New:IsUISubApp()
end
function PaGlobalFunc_ItemMarketRegistItem_GetShow()
  return Panel_Window_ItemMarket_RegistItem:GetShow()
end
function PaGlobalFunc_ItemMarketRegistItem_SetShow(isShow)
  return Panel_Window_ItemMarket_RegistItem:SetShow(isShow)
end
function PaGlobalFunc_ItemMarketBuyConfirm_GetShow()
  return Panel_Window_ItemMarket_BuyConfirm:GetShow()
end
function PaGlobalFunc_ItemMarketItemSet_GetShow()
  return Panel_Window_ItemMarket_ItemSet:GetShow()
end
function FromClient_notifyItemMarketMessage(msgType, strParam1, param1, param2, param3, param4)
  if 0 == msgType then
    if 0 == param1 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYCOMPLETEITEM"))
    elseif 1 == param1 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYBIDDINGITEM"))
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYCOMPLETEITEM"))
    end
  elseif 1 == msgType then
    local territoryNameArray = {
      [0] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_0")),
      [1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_1")),
      [2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_2")),
      [3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_3")),
      [4] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_4")),
      [5] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_5")),
      [6] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_6")),
      [7] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_7"))
    }
    if param2 < 0 or param2 > 6 then
      return
    end
    local territoryName = territoryNameArray[param2]
    local issw = getItemEnchantStaticStatus(ItemEnchantKey(param1))
    if issw == nil then
      return
    end
    local itemName = issw:getName()
    local enchantLevel = issw:get()._key:getEnchantLevel()
    local isCash = issw:get():isCash()
    if enchantLevel > 0 and 4 ~= issw:getItemClassify() then
      strParam1 = "+" .. enchantLevel .. " " .. itemName
    end
    if enchantLevel >= 16 then
      local enchantString = ""
      if 16 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1")
      elseif 17 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2")
      elseif 18 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3")
      elseif 19 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4")
      elseif 20 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5")
      end
      strParam1 = enchantString .. " " .. HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemName
    elseif enchantLevel > 0 and enchantLevel < 16 and 4 ~= issw:getItemClassify() then
      if true == isCash then
        strParam1 = itemName
      else
        strParam1 = "+" .. enchantLevel .. " " .. itemName
      end
    elseif 4 == issw:getItemClassify() then
      local enchantString = ""
      if 1 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1")
      elseif 2 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2")
      elseif 3 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3")
      elseif 4 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4")
      elseif 5 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5")
      end
      if 0 == enchantLevel then
        strParam1 = itemName
      else
        strParam1 = enchantString .. " " .. HighEnchantLevel_ReplaceString(enchantLevel + 15) .. " " .. itemName
      end
    else
      strParam1 = itemName
    end
    local subStr
    if param4 then
      subStr = "LUA_ITEMMARKET_REGIST_ITEMMARKET"
    else
      subStr = "LUA_ITEMMARKET_STANDBY_ITEMMARKET"
    end
    local message = {
      main = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ITEMMARKET_NOTIFYITEMMARKETMSG_MAIN", "strParam1", strParam1, "param3", makeDotMoney(param3)),
      sub = PAGetString(Defines.StringSheet_GAME, subStr)
    }
    Proc_ShowMessage_Ack_For_RewardSelect(message, 5, 19)
  elseif 2 == msgType then
    local message = ""
    if param2 == 1 then
      message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ITEMMARKET_SELLITEM", "strParam1", strParam1, "param1", param1)
    else
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_SELLITEMONE", "strParam1", strParam1)
    end
    Proc_ShowMessage_Ack(message)
  elseif 3 == msgType then
    PaGlobal_ItemmarketRegistItem_Update()
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_AFTERREGIST_ACK"))
  elseif 4 == msgType then
    PaGlobalFunc_ItemMarket_UpdateForNotice()
  elseif 5 == msgType then
    local issw = getItemEnchantStaticStatus(ItemEnchantKey(param1))
    if issw == nil then
      return
    end
    local itemName = issw:getName()
    local enchantLevel = issw:get()._key:getEnchantLevel()
    FGlobal_ItemMarketAlarm_Open(ItemEnchantKey(param1))
    _PA_LOG("\236\156\160\237\157\165\236\139\160", " ItemMarket \234\180\128\236\139\172 \236\149\132\236\157\180\237\133\156 \235\169\148\236\132\184\236\167\128 \236\157\145\235\139\181 \236\178\152\235\166\172 " .. itemName .. " " .. tostring(enchantLevel))
  elseif 6 == msgType then
    local issw = getItemEnchantStaticStatus(ItemEnchantKey(param1))
    if issw == nil then
      return
    end
    local itemName = issw:getName()
    local enchantLevel = issw:get()._key:getEnchantLevel()
    local isCash = issw:get():isCash()
    if enchantLevel > 0 and 4 ~= issw:getItemClassify() then
      strParam1 = "+" .. enchantLevel .. " " .. itemName
    end
    if enchantLevel >= 16 then
      local enchantString = ""
      if 16 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1")
      elseif 17 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2")
      elseif 18 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3")
      elseif 19 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4")
      elseif 20 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5")
      end
      strParam1 = enchantString .. " " .. HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemName
    elseif enchantLevel > 0 and enchantLevel < 16 and 4 ~= issw:getItemClassify() then
      if true == isCash then
        strParam1 = itemName
      else
        strParam1 = "+" .. enchantLevel .. " " .. itemName
      end
    elseif 4 == issw:getItemClassify() then
      local enchantString = ""
      if 1 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1")
      elseif 2 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2")
      elseif 3 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3")
      elseif 4 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4")
      elseif 5 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5")
      end
      if 0 == enchantLevel then
        strParam1 = itemName
      else
        strParam1 = enchantString .. " " .. HighEnchantLevel_ReplaceString(enchantLevel + 15) .. " " .. itemName
      end
    else
      strParam1 = itemName
    end
    local message = {
      main = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ITEMMARKET_NOTIFYITEMMARKETMSG_MAIN", "strParam1", strParam1, "param3", makeDotMoney(param3)),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_STANDBY_ITEMMARKETBYPARTY")
    }
    Proc_ShowMessage_Ack_For_RewardSelect(message, 5, 19)
  elseif 7 == msgType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_SELLCOMPLETEBYRESERVATION"))
  elseif 8 == msgType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_RESERVATIONSUCCESS"))
    FGlobal_ItemMarketPreBid_Close()
  elseif 9 == msgType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CANCELRESERVATIONSUCCESS"))
  elseif 10 == msgType then
    local territoryNameArray = {
      [0] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_0")),
      [1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_1")),
      [2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_2")),
      [3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_3")),
      [4] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_4")),
      [5] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_5")),
      [6] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_6")),
      [7] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_7"))
    }
    if param2 < 0 or param2 > 6 then
      return
    end
    local territoryName = territoryNameArray[param2]
    local issw = getItemEnchantStaticStatus(ItemEnchantKey(param1))
    if issw == nil then
      return
    end
    local itemName = issw:getName()
    local enchantLevel = issw:get()._key:getEnchantLevel()
    local isCash = issw:get():isCash()
    if enchantLevel > 0 and 4 ~= issw:getItemClassify() then
      strParam1 = "+" .. enchantLevel .. " " .. itemName
    end
    if enchantLevel >= 16 then
      local enchantString = ""
      if 16 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1")
      elseif 17 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2")
      elseif 18 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3")
      elseif 19 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4")
      elseif 20 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5")
      end
      strParam1 = enchantString .. " " .. HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemName
    elseif enchantLevel > 0 and enchantLevel < 16 and 4 ~= issw:getItemClassify() then
      if true == isCash then
        strParam1 = itemName
      else
        strParam1 = "+" .. enchantLevel .. " " .. itemName
      end
    elseif 4 == issw:getItemClassify() then
      local enchantString = ""
      if 1 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1")
      elseif 2 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2")
      elseif 3 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3")
      elseif 4 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4")
      elseif 5 == enchantLevel then
        enchantString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5")
      end
      if 0 == enchantLevel then
        strParam1 = itemName
      else
        strParam1 = enchantString .. " " .. HighEnchantLevel_ReplaceString(enchantLevel + 15) .. " " .. itemName
      end
    else
      strParam1 = itemName
    end
    local message = {
      main = strParam1,
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_SELLCOMPLETEBYRESERVATION")
    }
    Proc_ShowMessage_Ack_For_RewardSelect(message, 5, 19)
  elseif 11 == msgType then
    local issw = getItemEnchantStaticStatus(ItemEnchantKey(param1))
    if issw == nil then
      return
    end
    local itemName = issw:getName()
    local enchantLevel = issw:get()._key:getEnchantLevel()
    local itemType = issw:getItemType()
    local itemClassify = issw:getItemClassify()
    local itemNameStr = PaGlobalFunc_MarketPlace_setNameAndEnchantLevel(enchantLevel, itemType, itemName, itemClassify)
    local message = {main, sub}
    if 0 == param2 then
      message.main = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ITEMMARKET_NOTIFYITEMMARKETMSG_MAIN", "strParam1", itemNameStr, "param3", makeDotMoney(param3))
      message.sub = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPALCE_SELLNOTICETITLE")
      Proc_ShowMessage_Ack_For_RewardSelect(message, 5, 19)
    elseif 1 == param2 then
      message.main = tostring(itemNameStr)
      message.sub = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_BUYBIDDING_SUCCESS")
      Proc_ShowMessage_Ack_For_RewardSelect(message, 5, 19)
    elseif 2 == param2 then
      message.main = strParam1
      message.sub = PAGetString(Defines.StringSheet_GAME, "LUA_NOTIFICATION_FLUCTUATION_TITLE_DOWN")
      Proc_ShowMessage_Ack_For_RewardSelect(message, 5, 113)
    elseif 3 == param2 then
      message.main = strParam1
      message.sub = PAGetString(Defines.StringSheet_GAME, "LUA_NOTIFICATION_FLUCTUATION_TITLE_UP")
      Proc_ShowMessage_Ack_For_RewardSelect(message, 5, 114)
    end
  end
end
function PaGlobalFunc_MarketPlace_CommonInit()
  registerEvent("FromClient_notifyItemMarketMessage", "FromClient_notifyItemMarketMessage")
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_MarketPlace_CommonInit")

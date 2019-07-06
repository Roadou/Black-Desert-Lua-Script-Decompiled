function PaGlobalFunc_NPCShop_ALL_SetANI(switch)
  if nil == Panel_Dialog_NPCShop_All then
    return
  end
  PaGlobal_NPCShop_ALL:setAni(switch)
end
function HandleEventLUp_NPCShop_ALL_Close(showAni)
  if nil ~= Panel_Dialog_NPCShop_All or false ~= Panel_Dialog_NPCShop_All:GetShow() then
    PaGlobal_NPCShop_ALL:prepareClose(showAni)
  end
end
function FromClient_NPCShop_ALL_Open(showAni)
  if nil == Panel_Dialog_NPCShop_All or true == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:prepareOpen(showAni)
end
function FromClient_NPCShop_ALL_Resize()
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:resize()
end
function PaGlobalFunc_NPCShop_ALL_GetShow()
  if nil == Panel_Dialog_NPCShop_All then
    return false
  end
  return Panel_Dialog_NPCShop_All:GetShow()
end
function PaGlobalFunc_NPCShop_ALL_GetCurrentTabIndex()
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return nil
  end
  if nil == PaGlobal_NPCShop_ALL._value._currentTabIndex or PaGlobal_NPCShop_ALL._value._currentTabIndex < 0 then
    return nil
  end
  return PaGlobal_NPCShop_ALL._value._currentTabIndex
end
function PaGlobalFunc_NPCShop_ALL_WindowShow()
  if nil == Panel_Dialog_NPCShop_All or true == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobalFunc_NPCShop_ALL:WindowShow()
end
function PaGlobalFunc_NPCShop_ALL_GetRadioButtonByIndex(radioButtonIndex)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  local radioButton = PaGlobal_NPCShop_ALL._radioButton_Tab[radioButtonIndex]
  if nil == radioButton then
    return nil
  end
  return radioButton
end
function HandleEventLUp_NPCShop_ALL_BuySome()
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:buySome()
end
function PaGlobalFunc_NPCShop_ALL_ConfirmBuySome()
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  local buyCount = PaGlobal_NPCShop_ALL._value._inputNumber
  local slot = PaGlobal_NPCShop_ALL._value._selectedSlotIndex
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  if nil ~= buyCount and nil ~= slot then
    local selectedSlot = PaGlobal_NPCShop_ALL._createdItemSlot[slot]
    if PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:IsCheck() then
      fromWhereType = CppEnums.ItemWhereType.eWarehouse
    end
    if npcShop_isGuildShopContents() then
      fromWhereType = CppEnums.ItemWhereType.eGuildWarehouse
      if not PaGlobal_NPCShop_ALL:guildCheckByBuy() then
        return
      end
    end
    npcShop_doBuy(slot, buyCount, fromWhereType, 0, PaGlobal_NPCShop_ALL._value._isCamping)
    selectedSlot.btn:SetCheck(false)
    PaGlobal_NPCShop_ALL._value._inputNumber = nil
    PaGlobal_NPCShop_ALL._value._selectedSlotIndex = nil
  end
end
function PaGlobalFunc_NPCShop_ALL_ConfirmSellAll(count, selectedIndex)
  if nil ~= count and nil ~= selectedIndex then
    local toWhereType = CppEnums.ItemWhereType.eInventory
    local shopItemWrapper = npcShop_getItemSell(selectedIndex)
    local shopItem = shopItemWrapper:get()
    local inventory = getSelfPlayer():get():getInventory()
    local s64_inventoryItemCount = inventory:getItemCount_s64(shopItemWrapper:getStaticStatus():get()._key)
    local shopItemSSW = npcShop_getItemWrapperByShopSlotNo(selectedIndex)
    local itemCount = Int64toInt32(s64_inventoryItemCount)
    local pricePiece = Int64toInt32(shopItemSSW:getSellPriceCalculate(shopItem:getItemPriceOption()))
    local sellPrice = pricePiece * itemCount
    if npcShop_isGuildShopContents() then
      toWhereType = CppEnums.ItemWhereType.eGuildWarehouse
    elseif PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:IsCheck() then
      toWhereType = CppEnums.ItemWhereType.eWarehouse
    end
    warehouse_requestInfo(getCurrentWaypointKey())
    npcShop_doSellByItemNo(selectedIndex, count, toWhereType, PaGlobal_NPCShop_ALL._value._isCamping)
    if CppEnums.ItemWhereType.eWarehouse == toWhereType then
      Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_MONEYFORWAREHOUSE_ACK", "getMoney", makeDotMoney(sellPrice)), 6)
    end
    PaGlobal_NPCShop_ALL._value._selectedSlotIndex = nil
  end
end
function HandleEventLUp_NPCShop_ALL_BuyOrSellItem(inputNumber)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:buyOrSellItem(inputNumber)
end
function FromClient_NPCShop_ALL_PushKeyToList2()
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:PushKeyToList2()
end
function HandleEventLUp_NPCShop_ALL_SellItemAll()
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:sellItemAll()
end
function HandleEventLUp_NPCShop_ALL_CheckBoxToggle(check)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:checkBoxToggle(check)
end
function HandleEventLUp_NPCShop_ALL_TabButtonClick(idx)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:tabButtonClick(idx)
end
function HandleEventLUp_NPCShop_ALL_OnSlotClicked(idx)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:onSlotClicked(idx)
end
function HandleEventLUp_NPCShop_ALL_OnRSlotClicked(idx)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:onRSlotClicked(idx)
end
function PaGlobalFunc_NPCShop_ALL_IsExchangeItem(idx, itemWrapper)
  if nil == Panel_Dialog_NPCShop_All then
    return
  end
  if nil == itemWrapper then
    return true
  end
  local isVested = itemWrapper:get():isVested()
  local isPersonalTrade = itemWrapper:getStaticStatus():isPersonalTrade()
  if isUsePcExchangeInLocalizingValue() then
    local isFilter = isVested and isPersonalTrade
    if isFilter then
      return isFilter
    end
  end
  local whereType = Inventory_GetCurrentInventoryType()
  if ToClient_Inventory_CheckItemLock(idx, whereType) then
    return true
  end
  local isAble = npcShop_IsItemExchangeWithSystem(itemWrapper:get():getKey())
  return not isAble
end
function HandleEventRUp_NPCShop_ALL_InvenItemRClick(idx)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:InvenItemRClick(idx)
end
function PaGlobalFunc_NPCShop_ALL_InvenItemSell(itemCount, idx)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:InvenItemSell(itemCount, idx)
end
function PaGlobalFunc_NPCShop_ALL_UpdateGuildPriceLimit()
  if nil == Panel_Dialog_NPCShop_All then
    return
  end
  PaGlobal_NPCShop_ALL:UpdateGuildPriceLimit()
end
function PaGlobalFunc_NPCShop_ALL_UpdateMoney()
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:UpdateMoney()
end
function FromClient_NPCShop_ALL_UpdateMoneyWithContent()
  if nil == Panel_Dialog_NPCShop_All then
    return
  end
  PaGlobal_NPCShop_ALL:UpdateMoneyWithContent()
end
function PaGlobalFunc_NPCShop_ALL_SetIsCamping(isCamping)
  if nil == Panel_Dialog_NPCShop_All then
    return
  end
  PaGlobal_NPCShop_ALL:setIsCamping(isCamping)
end
function FromClient_NPCShop_ALL_UpdateContent(content, key)
  if nil == Panel_Dialog_NPCShop_All then
    return
  end
  PaGlobal_NPCShop_ALL:updateContentData(content, key)
end
function PaGlobalFunc_NPCShop_ALL_ChangeTapByPad(idx)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:changeTapByPad(idx)
end
function PaGlobalFunc_NPCShop_ALL_BuySomeOrSellByPad(index)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL._value._selectedSlotIndex = index
  if PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex then
    HandleEventLUp_NPCShop_ALL_BuySome()
  elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXSELL == PaGlobal_NPCShop_ALL._value._currentTabIndex then
    HandleEventLUp_NPCShop_ALL_SellItemAll()
  elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXREBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex then
    HandleEventLUp_NPCShop_ALL_BuyOrSellItem()
  end
end
function PaGlobalFunc_NPCShop_ALL_ShowToolTipByPad(selectedIndex, show)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() or false == PaGlobal_NPCShop_ALL._isConsole then
    return
  end
  PaGlobal_NPCShop_ALL:ShowToolTipByPad(selectedIndex, show)
end
function HandleEventOnOut_NPCShop_ALL_ShowToolTipByMouse(dataIndex, show)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() or true == PaGlobal_NPCShop_ALL._isConsole then
    return
  end
  PaGlobal_NPCShop_ALL._pos._toolTipPosX = Panel_Dialog_NPCShop_All:GetPosX() + Panel_Dialog_NPCShop_All:GetSizeX() + Panel_Dialog_NPCShop_All:GetSpanSize().x
  PaGlobal_NPCShop_ALL._pos._toolTipPosY = Panel_Dialog_NPCShop_All:GetPosY() + PaGlobal_NPCShop_ALL._ui._list2_Item_List:GetPosY()
  if true == show then
    Panel_Tooltip_Item_Show_GeneralStatic(dataIndex, "shop", true, nil, PaGlobal_NPCShop_ALL._pos._toolTipPosX, PaGlobal_NPCShop_ALL._pos._toolTipPosY)
  else
    Panel_Tooltip_Item_Show_GeneralStatic(dataIndex, "shop", false, nil)
  end
end

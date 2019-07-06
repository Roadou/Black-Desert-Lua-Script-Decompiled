function PaGlobal_MarKetPlace_BuyProductInCashShop_Open(itemKey)
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return
  end
  if nil == itemKey then
    return
  end
  PaGlobal_MarKetPlace_BuyProductInCashShop:prepareOpen(itemKey)
  PaGlobal_MarKetPlace_BuyProductInCashShop:open()
end
function PaGlobal_MarKetPlace_BuyProductInCashShop_Close()
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return
  end
  PaGlobal_MarKetPlace_BuyProductInCashShop:prepareClose()
  PaGlobal_MarKetPlace_BuyProductInCashShop:close()
end
function PaGlobal_MarKetPlace_BuyProductInCashShop_GetShow()
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return false
  end
  return Panel_Window_MarketPlace_BuyProductInCashShop:GetShow()
end
function HandleEventLUp_MarKetPlace_BuyProductInCashShopClose()
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return
  end
  PaGlobal_MarKetPlace_BuyProductInCashShop_Close()
end
function HandleEventOnOut_MarKetPlace_BuyProductInCashShop_ShowItemToolTip(isShow, itemIdx, productIdx)
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return
  end
  if nil == isShow or nil == itemIdx or nil == productIdx then
    return
  end
  if true == isShow then
    local cashProductNo = PaGlobal_MarKetPlace_BuyProductInCashShop._productNoList[productIdx]
    local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(cashProductNo)
    local itemWrapper = cashProduct:getItemByIndex(itemIdx)
    local slotIcon = PaGlobal_MarKetPlace_BuyProductInCashShop._productUiList[productIdx]._iconList[itemIdx]
    Panel_Tooltip_Item_Show(itemWrapper, slotIcon, true, false, nil)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function HandleEventOnOut_MarKetPlace_BuyProductInCashShop_ShowItemNameToolTip(isShow, productNo, productIdx)
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return
  end
  if nil == isShow or nil == productIdx then
    return
  end
  if true == isShow then
    local uiControl = PaGlobal_MarKetPlace_BuyProductInCashShop._productUiList[productIdx]._name
    local product = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNo)
    local name = product:getDisplayName()
    local desc = product:getDisplaySubName()
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function HandleEventLUp_MarKetPlace_BuyProductInCashShop(cashProductNo)
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return
  end
  if nil == cashProductNo then
    return
  end
  PaGlobal_MarKetPlace_BuyProductInCashShop:goToProductPage(cashProductNo)
end
function PaGlobal_MarKetPlace_BuyProductInCashShop_ShowAni()
end
function PaGlobal_MarKetPlace_BuyProductInCashShop_HideAni()
end
function PaGlobal_MarKetPlace_BuyProductInCashShopIsCheck(itemKey)
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return false
  end
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
  if nil == itemSSW then
    return false
  end
  local cashProductCount = itemSSW:getCashProductNoListSize()
  if 0 == cashProductCount then
    return false
  end
  local cashProductNo, cashProduct, checkProductPossible
  local possibleProductCount = 0
  for ii = 0, cashProductCount - 1 do
    cashProductNo = itemSSW:getCashProductNoAt(ii)
    cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(cashProductNo)
    checkProductPossible = PaGlobal_MarKetPlace_BuyProductInCashShop:checkPossible(cashProduct)
    if true == checkProductPossible then
      possibleProductCount = possibleProductCount + 1
    end
  end
  if possibleProductCount <= 0 then
    return false
  end
  return true
end

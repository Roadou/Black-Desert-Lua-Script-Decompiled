function PaGlobal_MarKetPlace_BuyProductInCashShop:initialize()
  if true == PaGlobal_MarKetPlace_BuyProductInCashShop._initialize then
    return
  end
  PaGlobal_MarKetPlace_BuyProductInCashShop._ui._btn_close = UI.getChildControl(Panel_Window_MarketPlace_BuyProductInCashShop, "Button_Close")
  PaGlobal_MarKetPlace_BuyProductInCashShop._ui._txt_guide = UI.getChildControl(Panel_Window_MarketPlace_BuyProductInCashShop, "StaticText_GoCashShopGuide")
  PaGlobal_MarKetPlace_BuyProductInCashShop._ui._txt_guide:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_MarKetPlace_BuyProductInCashShop._ui._txt_guide:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_MARKETPLACE_BUYPRODUCT_INCASHSHOP_DESC"))
  PaGlobal_MarKetPlace_BuyProductInCashShop._ui._list_products = UI.getChildControl(Panel_Window_MarketPlace_BuyProductInCashShop, "List2_ProductsList")
  PaGlobal_MarKetPlace_BuyProductInCashShop._ui._list_products:changeAnimationSpeed(10)
  PaGlobal_MarKetPlace_BuyProductInCashShop._ui._list_products:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "Paglobal_MarketPlace_BuyProductInCashShop_updateListContent")
  PaGlobal_MarKetPlace_BuyProductInCashShop._ui._list_products:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  PaGlobal_MarKetPlace_BuyProductInCashShop:registEventHandler()
  PaGlobal_MarKetPlace_BuyProductInCashShop:validate()
  PaGlobal_MarKetPlace_BuyProductInCashShop._initialize = true
end
function PaGlobal_MarKetPlace_BuyProductInCashShop:registEventHandler()
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return
  end
  PaGlobal_MarKetPlace_BuyProductInCashShop._ui._btn_close:addInputEvent("Mouse_LUp", "HandleEventLUp_MarKetPlace_BuyProductInCashShopClose()")
  Panel_Window_MarketPlace_BuyProductInCashShop:RegisterShowEventFunc(true, "PaGlobal_MarKetPlace_BuyProductInCashShop_ShowAni()")
  Panel_Window_MarketPlace_BuyProductInCashShop:RegisterShowEventFunc(false, "PaGlobal_MarKetPlace_BuyProductInCashShop_HideAni()")
end
function PaGlobal_MarKetPlace_BuyProductInCashShop:prepareOpen(itemKey)
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return
  end
  PaGlobal_MarKetPlace_BuyProductInCashShop._itemkey = itemKey
  PaGlobal_MarKetPlace_BuyProductInCashShop:update()
end
function PaGlobal_MarKetPlace_BuyProductInCashShop:open()
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return
  end
  if 1 == PaGlobal_MarKetPlace_BuyProductInCashShop._productCount then
    PaGlobal_MarKetPlace_BuyProductInCashShop:goToProductPage(PaGlobal_MarKetPlace_BuyProductInCashShop._productNoList[1])
  else
    Panel_Window_MarketPlace_BuyProductInCashShop:SetShow(true)
  end
end
function PaGlobal_MarKetPlace_BuyProductInCashShop:prepareClose()
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return
  end
end
function PaGlobal_MarKetPlace_BuyProductInCashShop:close()
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return
  end
  Panel_Window_MarketPlace_BuyProductInCashShop:SetShow(false)
end
function PaGlobal_MarKetPlace_BuyProductInCashShop:update()
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return
  end
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(PaGlobal_MarKetPlace_BuyProductInCashShop._itemkey))
  if nil == itemSSW then
    return
  end
  local cashProductCount = itemSSW:getCashProductNoListSize()
  if 0 == cashProductCount then
    return
  end
  local cashProductNo, cashProduct, checkProductPossible
  PaGlobal_MarKetPlace_BuyProductInCashShop._productCount = 0
  PaGlobal_MarKetPlace_BuyProductInCashShop._ui._list_products:getElementManager():clearKey()
  for ii = 0, cashProductCount - 1 do
    cashProductNo = itemSSW:getCashProductNoAt(ii)
    cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(cashProductNo)
    checkProductPossible = PaGlobal_MarKetPlace_BuyProductInCashShop:checkPossible(cashProduct)
    if true == checkProductPossible then
      PaGlobal_MarKetPlace_BuyProductInCashShop._productCount = PaGlobal_MarKetPlace_BuyProductInCashShop._productCount + 1
      PaGlobal_MarKetPlace_BuyProductInCashShop._productNoList[PaGlobal_MarKetPlace_BuyProductInCashShop._productCount] = cashProductNo
      PaGlobal_MarKetPlace_BuyProductInCashShop._ui._list_products:getElementManager():pushKey(toInt64(0, PaGlobal_MarKetPlace_BuyProductInCashShop._productCount))
      PaGlobal_MarKetPlace_BuyProductInCashShop._ui._list_products:updateContentPos()
    end
  end
end
function PaGlobal_MarKetPlace_BuyProductInCashShop:validate()
end
function Paglobal_MarketPlace_BuyProductInCashShop_updateListContent(contents, index)
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return
  end
  contents:ComputePos()
  local productUiInfo = {
    _box = UI.getChildControl(contents, "Static_BlueLineBox"),
    _img = UI.getChildControl(contents, "Static_ProductImage"),
    _name = UI.getChildControl(contents, "StaticText_ProductName"),
    _imgBorder = UI.getChildControl(contents, "Static_ProductBorder"),
    _iconBgList = {},
    _iconList = {}
  }
  for ii = 0, 9 do
    productUiInfo._iconBgList[ii] = UI.getChildControl(contents, "Static_ItemBG_" .. ii)
    productUiInfo._iconBgList[ii]:SetShow(false)
    productUiInfo._iconList[ii] = UI.getChildControl(contents, "Static_ItemIcon_" .. ii)
    productUiInfo._iconList[ii]:SetShow(false)
  end
  local index32 = Int64toInt32(index)
  local productNo = PaGlobal_MarKetPlace_BuyProductInCashShop._productNoList[index32]
  local product = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNo)
  productUiInfo._name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  productUiInfo._name:SetText(product:getDisplayName() .. " " .. product:getDisplaySubName())
  if true == productUiInfo._name:IsLimitText() then
    productUiInfo._name:addInputEvent("Mouse_On", "HandleEventOnOut_MarKetPlace_BuyProductInCashShop_ShowItemNameToolTip(true," .. productNo .. "," .. index32 .. ")")
    productUiInfo._name:addInputEvent("Mouse_Out", "HandleEventOnOut_MarKetPlace_BuyProductInCashShop_ShowItemNameToolTip(false," .. productNo .. "," .. index32 .. ")")
  else
    productUiInfo._name:addInputEvent("Mouse_On", "")
    productUiInfo._name:addInputEvent("Mouse_Out", "")
  end
  if nil == product:getPackageIcon() then
    productUiInfo._img:ChangeTextureInfoName("New_Icon/09_Cash/03_Product/00021034.dds")
  else
    productUiInfo._img:ChangeTextureInfoName(product:getPackageIcon())
  end
  productUiInfo._img:addInputEvent("Mouse_LUp", "HandleEventLUp_MarKetPlace_BuyProductInCashShop(" .. productNo .. ")")
  PaGlobal_MarKetPlace_BuyProductInCashShop:borderChange(productUiInfo._imgBorder, product:getTag())
  local tagType = product:getTag()
  if (4 == tagType or 5 == tagType) and not product:isApplyDiscount() and product:isDefinedDiscount() then
    productUiInfo._imgBorder:SetShow(false)
  else
    productUiInfo._imgBorder:SetShow(true)
  end
  local itemListCount = product:getItemListCount()
  if itemListCount > 6 then
    productUiInfo._box:SetSize(productUiInfo._box:GetSizeX(), 175)
    contents:SetSize(contents:GetSizeX(), 185)
  else
    productUiInfo._box:SetSize(productUiInfo._box:GetSizeX(), 140)
    contents:SetSize(contents:GetSizeX(), 150)
  end
  for jj = 0, itemListCount - 1 do
    local item = product:getItemByIndex(jj)
    productUiInfo._iconList[jj]:ChangeTextureInfoName("icon/" .. item:getIconPath())
    productUiInfo._iconList[jj]:addInputEvent("Mouse_On", "HandleEventOnOut_MarKetPlace_BuyProductInCashShop_ShowItemToolTip(true, " .. jj .. "," .. index32 .. ")")
    productUiInfo._iconList[jj]:addInputEvent("Mouse_Out", "HandleEventOnOut_MarKetPlace_BuyProductInCashShop_ShowItemToolTip(false, " .. jj .. "," .. index32 .. ")")
    productUiInfo._iconBgList[jj]:SetShow(true)
    productUiInfo._iconList[jj]:SetShow(true)
  end
  PaGlobal_MarKetPlace_BuyProductInCashShop._productUiList[index32] = productUiInfo
end
function PaGlobal_MarKetPlace_BuyProductInCashShop:goToProductPage(cashProductNo)
  if nil == Panel_Window_MarketPlace_BuyProductInCashShop then
    return
  end
  PaGlobal_MarKetPlace_BuyProductInCashShop_Close()
  PaGlobalFunc_FullScreenFade_RunAfterFadeIn(ToClient_RequestShowProduct(cashProductNo, nil, 1))
end
function PaGlobal_MarKetPlace_BuyProductInCashShop:checkPossible(cashProduct)
  if nil == cashProduct:isMallDisplayable() or false == cashProduct:isMallDisplayable() then
    return false
  end
  if not cashProduct:isBuyable() then
    return false
  end
  return true
end
function PaGlobal_MarKetPlace_BuyProductInCashShop:borderChange(border, tagType)
  border:ChangeTextureInfoName("new_ui_common_forlua/window/ingamecashshop/CashShop_03.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(border, PaGlobal_MarKetPlace_BuyProductInCashShop._tagTexture[tagType][1], PaGlobal_MarKetPlace_BuyProductInCashShop._tagTexture[tagType][2], PaGlobal_MarKetPlace_BuyProductInCashShop._tagTexture[tagType][3], PaGlobal_MarKetPlace_BuyProductInCashShop._tagTexture[tagType][4])
  border:getBaseTexture():setUV(x1, y1, x2, y2)
  border:setRenderTexture(border:getBaseTexture())
end

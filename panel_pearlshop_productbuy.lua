local pearlShopProductBuy = {
  _init = false,
  _panel = Panel_PearlShop_ProductBuy,
  _productNoRaw = 0,
  _amount = 1,
  _ui = {
    TopBg = nil,
    BtmBg = nil,
    _mainBG = nil,
    _titleControl = nil,
    _descControl = nil,
    _subItemSlotTemplateControl = nil,
    _itemSlotBgControl = nil,
    _amountControl = nil,
    _pearlControl = nil,
    _mileageControl = nil,
    _subItemSlotControlListSize = 16,
    _subItemSlotControlListCountPerLine = 8,
    _subItemSlotControlList = {},
    _bottomControl = nil
  },
  _titleSlotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  _subSlotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  _slotGapX = 7,
  _mainSlot = nil,
  _slotList = {},
  _keyGuideAlign = {},
  _selectedCouponIdx = nil,
  _isAvailableCoupon = false
}
function pearlShopProductBuy:initialize()
  if self._init then
    return
  end
  self._init = true
  self._ui.TopBg = UI.getChildControl(self._panel, "Static_TopBg")
  self._ui.BtmBg = UI.getChildControl(self._panel, "Static_BtmBg")
  local mainBgControl = UI.getChildControl(self._panel, "Static_MainBG")
  self._ui._titleControl = UI.getChildControl(mainBgControl, "StaticText_ProductName")
  self._ui._descControl = UI.getChildControl(mainBgControl, "StaticText_ProductDesc")
  self._ui._descControl:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.line3 = UI.getChildControl(mainBgControl, "Static_HorizontalLine3")
  self._ui.line4 = UI.getChildControl(mainBgControl, "Static_HorizontalLine4")
  self._ui.line5 = UI.getChildControl(mainBgControl, "Static_HorizontalLine5")
  self._ui._itemSlotBgControl = UI.getChildControl(mainBgControl, "Static_MainItemSlotBg")
  self._ui._mainBG = mainBgControl
  local slot = {}
  SlotItem.new(slot, "MainSlot", 0, self._ui._itemSlotBgControl, self._titleSlotConfig)
  slot:createChild()
  self._mainSlot = slot
  self._ui._subItemSlotTemplateControl = UI.getChildControl(mainBgControl, "Static_SubItemSlotBg")
  self._ui._subItemSlotTemplateControl:SetShow(false)
  for i = 0, self._ui._subItemSlotControlListSize - 1 do
    local subItemSlotControl = UI.cloneControl(self._ui._subItemSlotTemplateControl, self._panel, "Static_SubItemSlot" .. i)
    self._ui._subItemSlotControlList[i] = subItemSlotControl
    local slot = {}
    SlotItem.new(slot, "Slot" .. i, i, subItemSlotControl, self._subSlotConfig)
    slot:createChild()
    self._slotList[i] = slot
  end
  self._ui._leftButtonControl = UI.getChildControl(mainBgControl, "Static_Left")
  self._ui._rightButtonControl = UI.getChildControl(mainBgControl, "Static_Right")
  self._ui._couponControl = UI.getChildControl(mainBgControl, "StaticText_Coupon")
  self._ui._couponControl:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui._amountControl = UI.getChildControl(mainBgControl, "StaticText_Count")
  self._ui._pearlControl = UI.getChildControl(mainBgControl, "StaticText_Pearl")
  self._ui._mileageControl = UI.getChildControl(mainBgControl, "StaticText_Mileage")
  self._ui._pearlOriginControl = UI.getChildControl(mainBgControl, "StaticText_PearlOrigin")
  self._ui._mileageOriginControl = UI.getChildControl(mainBgControl, "StaticText_MileageOrigin")
  self._ui._pearlOriginControl:SetLineRender(true)
  self._ui._mileageOriginControl:SetLineRender(true)
  self._ui._couponTitle = UI.getChildControl(mainBgControl, "StaticText_CouponTitle")
  self._ui._countTitle = UI.getChildControl(mainBgControl, "StaticText_CountTitle")
  self._ui._priceTitle = UI.getChildControl(mainBgControl, "StaticText_PriceTitle")
  self._ui._txt_CouponBG = UI.getChildControl(self._ui._couponControl, "StaticText_SelectCoupon")
  self._ui._list2_Coupon = UI.getChildControl(self._ui._txt_CouponBG, "List2_Coupon")
  self._ui._list2_Coupon:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_PearlShopProductBuy_CreateCouponList")
  self._ui._list2_Coupon:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._bottomControl = UI.getChildControl(self._panel, "Static_BottomSite")
  self._ui._bottomKeyGuideA = UI.getChildControl(self._ui._bottomControl, "StaticText_Confirm_ConsoleUI")
  self._ui._bottomKeyGuideB = UI.getChildControl(self._ui._bottomControl, "StaticText_XboxClose_ConsoleUI")
  self._ui._bottomKeyGuideY = UI.getChildControl(self._ui._bottomControl, "StaticText_Coupon_ConsoleUI")
  self._keyGuideAlign = {
    self._ui._bottomKeyGuideY,
    self._ui._bottomKeyGuideA,
    self._ui._bottomKeyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._bottomControl, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self._ui._bottomKeyGuideY:SetShow(false)
  self._panel:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "PaGlobalFunc_PearlShopProductBuyDown()")
  self._panel:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "PaGlobalFunc_PearlShopProductBuyUp()")
  self._panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_PearlShopProductBuyBuy()")
  self._panel:ignorePadSnapMoveToOtherPanel()
end
function PaGlobalFunc_PearlShopProductBuyCheckShow()
  return pearlShopProductBuy:checkShow()
end
function pearlShopProductBuy:checkShow()
  return self._panel:GetShow()
end
function PaGlobalFunc_PearlShopProductBuyBack()
  pearlShopProductBuy:back()
end
function pearlShopProductBuy:back()
  self:close()
end
function PaGlobalFunc_PearlShopProductBuyUp()
  _AudioPostEvent_SystemUiForXBOX(51, 4)
  pearlShopProductBuy:changeAmount(1)
end
function PaGlobalFunc_PearlShopProductBuyDown()
  _AudioPostEvent_SystemUiForXBOX(51, 4)
  pearlShopProductBuy:changeAmount(-1)
end
function pearlShopProductBuy:changeAmount(diff)
  local amount = self._amount + diff
  if amount <= 0 then
    return
  elseif amount > 20 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_OVER20"))
    return
  end
  if nil ~= self._selectedCouponIdx then
    self._selectedCouponIdx = nil
  end
  self._amount = amount
  self:update()
end
function pearlShopProductBuy:open(productInfo)
  if not productInfo then
    return
  end
  self._productNoRaw = productInfo:getNoRaw()
  self._amount = 1
  self._selectedCouponIdx = nil
  self:update()
  _AudioPostEvent_SystemUiForXBOX(8, 14)
  self._panel:SetShow(true)
end
function pearlShopProductBuy:getProductInfo()
  if self._productNoRaw then
    return getIngameCashMall():getCashProductStaticStatusByProductNoRaw(self._productNoRaw)
  end
end
function PaGlobalFunc_PearlShopProductBuyOpen(productInfo)
  pearlShopProductBuy:open(productInfo)
end
function PaGlobalFunc_PearlShopProductBuyBuy()
  local self = pearlShopProductBuy
  if false == self._ui._txt_CouponBG:GetShow() then
    if true == self._isAvailableCoupon and nil == self._selectedCouponIdx then
      local messageBoxtitle = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING")
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_INGAMECASHSHOP_ALERTCOUPON")
      local messageBoxData = {
        title = messageBoxtitle,
        content = messageBoxMemo,
        functionYes = PaGlobalFunc_PearlShopProductBuyYes,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData, "middle")
      return
    else
      self:buy()
    end
  end
end
function PaGlobalFunc_PearlShopProductBuyYes()
  pearlShopProductBuy:buy()
end
function pearlShopProductBuy:buy()
  local productInfo = self:getProductInfo()
  if not productInfo then
    return
  end
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(self._productNoRaw)
  if nil == cashProduct then
    return
  end
  local couponKey = 0
  local couponNo = toInt64(0, -1)
  if nil ~= self._selectedCouponIdx then
    local couponWrapper = ToClient_GetCouponInfoWrapper(self._selectedCouponIdx)
    if nil ~= couponWrapper then
      couponKey = couponWrapper:getCouponKey()
      couponNo = couponWrapper:getCouponNo()
    end
  end
  local haveMileage, haveCash = InGameShop_UpdateCash()
  local count = self._ui._amountControl:GetText()
  local isEnoughMoney = false
  if toInt64(0, 0) < productInfo:getPearlPrice() then
    isEnoughMoney = haveCash >= cashProduct:getPrice() * toInt64(0, count)
  elseif toInt64(0, 0) < productInfo:getPearlPrice() then
    isEnoughMoney = haveMileage >= cashProduct:getPrice() * toInt64(0, count)
  else
    isEnoughMoney = true
  end
  if isEnoughMoney then
    _AudioPostEvent_SystemUiForXBOX(16, 0)
  else
    _AudioPostEvent_SystemUiForXBOX(16, 1)
  end
  self:close()
  getIngameCashMall():requestBuyItem(productInfo:getNoRaw(), count, productInfo:getPrice(), false, couponNo, couponKey, 0, CppEnums.ItemWhereType.eInventory)
  pearlShopProductBuy:close()
end
function pearlShopProductBuy:close()
  if true == self._ui._txt_CouponBG:GetShow() then
    self:couponListClsoe()
    return
  end
  PaGlobalFunc_PearlShopSetBKeyGuide()
  self._panel:SetShow(false)
end
function PaGlobalFunc_PearlShopProductBuyClose()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  pearlShopProductBuy:close()
end
function pearlShopProductBuy:addItemSlotControlList(count)
  for i = self._ui._subItemSlotControlListSize, count do
    local subItemSlotControl = UI.cloneControl(self._ui._subItemSlotTemplateControl, self._panel, "Static_SubItemSlot" .. i)
    self._ui._subItemSlotControlList[i] = subItemSlotControl
    local slot = {}
    SlotItem.new(slot, "Slot" .. i, i, subItemSlotControl, self._subSlotConfig)
    slot:createChild()
    self._slotList[i] = slot
  end
  self._ui._subItemSlotControlListSize = count
end
function pearlShopProductBuy:update(applyCoupon)
  local productInfo = self:getProductInfo()
  if not productInfo then
    return
  end
  self._isAvailableCoupon = false
  self._mainSlot:setItemByStaticStatus(productInfo:getItemByIndex(0))
  self._ui._titleControl:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._titleControl:SetText(productInfo:getDisplayName())
  local itemListCount = productInfo:getItemListCount()
  local additionalSubItemCount = productInfo:getSubItemListCount()
  local totalItemListCount = itemListCount + additionalSubItemCount
  local firstPosX = 50
  if totalItemListCount > self._ui._subItemSlotControlListSize then
    self:addItemSlotControlList(totalItemListCount)
  end
  local desc = ""
  for i = 0, self._ui._subItemSlotControlListSize - 1 do
    local control = self._ui._subItemSlotControlList[i]
    control:SetPosX(firstPosX + (self._ui._subItemSlotTemplateControl:GetSizeX() + 10) * (i % self._ui._subItemSlotControlListCountPerLine))
    control:SetPosY(255 + math.floor(i / self._ui._subItemSlotControlListCountPerLine) * 54)
    local showFlag = i < itemListCount
    control:SetShow(showFlag)
    if showFlag then
      local itemInfo = productInfo:getItemByIndex(i)
      local itemCount = productInfo:getItemCountByIndex(i)
      if nil ~= itemInfo then
        self._slotList[i]:setItemByStaticStatus(itemInfo, itemCount)
        if 1 < Int64toInt32(itemCount) then
          desc = desc .. "-" .. " " .. itemInfo:getName() .. " x" .. Int64toInt32(itemCount) .. "\n"
        else
          desc = desc .. "-" .. " " .. itemInfo:getName() .. "\n"
        end
      end
    end
  end
  for i = 0, additionalSubItemCount - 1 do
    local control = self._ui._subItemSlotControlList[i + itemListCount]
    local subItemInfo = productInfo:getSubItemByIndex(i)
    local subItemCount = productInfo:getSubItemCountByIndex(i)
    if nil ~= subItemInfo then
      self._slotList[i + itemListCount]:setItemByStaticStatus(subItemInfo, subItemCount)
      control:SetShow(true)
      if 1 < Int64toInt32(subItemCount) then
        desc = desc .. "-" .. " " .. subItemInfo:getName() .. "x" .. Int64toInt32(subItemCount) .. "\n"
      else
        desc = desc .. "-" .. " " .. subItemInfo:getName() .. "\n"
      end
    end
  end
  self._ui._descControl:SetText(desc)
  local addSize = self._ui._descControl:GetTextSizeY() + 54 * math.floor(totalItemListCount / self._ui._subItemSlotControlListCountPerLine)
  local addPosY = 54 * math.floor((totalItemListCount - 1) / self._ui._subItemSlotControlListCountPerLine)
  if addSize > 20 then
    self._panel:SetSize(512, 572 + addSize)
    self._ui.TopBg:SetSize(472, 256 + addSize)
    self._ui._descControl:SetSize(390, addSize + 10)
    self._ui._descControl:SetPosY(235 + addPosY)
    self._ui.BtmBg:SetPosY(self._ui.TopBg:GetPosY() + self._ui.TopBg:GetSizeY() + 10)
    self._ui._mainBG:SetSize(502, 400 + addSize)
  else
    self._panel:SetSize(512, 664)
    self._ui._descControl:SetSize(390, 20)
    self._ui._descControl:SetPosY(235 + addPosY)
    self._ui._mainBG:SetSize(502, 450)
    self._ui.BtmBg:ComputePos()
  end
  self._ui._bottomControl:ComputePos()
  self._ui.line5:SetPosY(self._ui.BtmBg:GetPosY() + 20)
  self._ui.line4:SetPosY(self._ui.line5:GetPosY() - 50)
  self._ui.line3:SetPosY(self._ui.line4:GetPosY() + 50)
  self._ui._couponTitle:SetPosY(self._ui.line4:GetPosY() - 30)
  self._ui._couponControl:SetPosY(self._ui.line4:GetPosY() - 35)
  self._ui._leftButtonControl:SetPosY(self._ui.line4:GetPosY() + 18)
  self._ui._rightButtonControl:SetPosY(self._ui.line4:GetPosY() + 18)
  self._ui._amountControl:SetPosY(self._ui.line4:GetPosY() + 10)
  self._ui._countTitle:SetPosY(self._ui.line4:GetPosY() + 12)
  self._ui._pearlControl:SetPosY(self._ui.line3:GetPosY() + 15)
  self._ui._mileageControl:SetPosY(self._ui.line3:GetPosY() + 14)
  self._ui._priceTitle:SetPosY(self._ui.line3:GetPosY() + 14)
  self._ui._amountControl:SetText(tostring(self._amount))
  local usableCouponCount = self:couponListUpdate()
  if usableCouponCount > 0 then
    self._ui._bottomKeyGuideY:SetShow(true)
    self._panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_PearlShopProductBuy_ShowCouponList()")
    self._ui._couponControl:SetFontColor(Defines.Color.C_FFEEEEEE)
    if nil == self._selectedCouponIdx then
      self._ui._couponControl:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PEARLSHOP_CANUSECOUPON", "couponcount", usableCouponCount))
    else
      local couponWrapper = ToClient_GetCouponInfoWrapper(self._selectedCouponIdx)
      local couponName = couponWrapper:getCouponName()
      self._ui._couponControl:SetText(couponName)
    end
  else
    self._ui._couponControl:SetFontColor(Defines.Color.C_FF76747D)
    self._ui._couponControl:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PEARLSHOP_NOCOUPON"))
    self._ui._bottomKeyGuideY:SetShow(false)
    self._panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
  end
  local priceStr = makeDotMoney(toInt64(0, self._amount) * productInfo:getPrice())
  local rightgapX = 40
  if nil == applyCoupon or false == applyCoupon then
    self._ui._pearlOriginControl:SetShow(false)
    if toInt64(0, 0) < productInfo:getPearlPrice() then
      self._ui._pearlControl:SetShow(true)
      self._ui._mileageControl:SetShow(false)
      self._ui._pearlControl:SetText(priceStr)
      local sizeX = self._ui._pearlControl:GetSizeX() + self._ui._pearlControl:GetTextSizeX() + rightgapX
      self._ui._pearlControl:SetPosX(self._ui.BtmBg:GetSizeX() - sizeX)
    elseif toInt64(0, 0) < productInfo:getMileagePrice() then
      self._ui._pearlControl:SetShow(false)
      self._ui._mileageControl:SetShow(true)
      self._ui._mileageControl:SetText(priceStr)
      local sizeX = self._ui._mileageControl:GetSizeX() + self._ui._mileageControl:GetTextSizeX() + rightgapX
      self._ui._mileageControl:SetPosX(self._ui.BtmBg:GetSizeX() - sizeX)
    end
  else
    local couponWrapper = ToClient_GetCouponInfoWrapper(self._selectedCouponIdx)
    if nil == couponWrapper then
      return
    end
    local couponName = couponWrapper:getCouponName()
    local couponDiscountRate = couponWrapper:getCouponDisCountRate()
    local couponDiscountPearl = couponWrapper:getCouponDisCountPearl()
    local couponState = couponWrapper:getCouponState()
    local couponCategoryCheck = couponWrapper:checkCategory(productInfo:getMainCategory(), productInfo:getMiddleCategory(), productInfo:getSmallCategory())
    local couponMaxDiscount = couponWrapper:getCouponMaxDisCountPearl()
    local couponMinProductPearl = couponWrapper:getCouponMinProductPearl()
    local isDiscountPearl = couponWrapper:isDisCountPearl()
    if false == couponCategoryCheck then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_UNABLECOUPON"))
      self._ui._pearlControl:SetShow(true)
      self._ui._mileageControl:SetShow(false)
      self._ui._pearlControl:SetText(priceStr)
      self._ui._pearlOriginControl:SetShow(false)
      local sizeX = self._ui._pearlControl:GetSizeX() + self._ui._pearlControl:GetTextSizeX() + rightgapX
      self._ui._pearlControl:SetPosX(self._ui.BtmBg:GetSizeX() - sizeX)
      return
    end
    local couponDiscountValue
    if false == isDiscountPearl then
      self._ui._amountControl:SetText(1)
      couponDiscountValue = productInfo:getPrice() * toInt64(0, couponDiscountRate / 10000) / toInt64(0, 100)
      if couponMaxDiscount > toInt64(0, 0) then
        if couponMaxDiscount < couponDiscountValue then
          self._ui._pearlControl:SetText(tostring(productInfo:getPrice() - couponMaxDiscount))
          Proc_ShowMessage_Ack(tostring(couponName) .. PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_LIMITMAXSALE"))
        else
          self._ui._pearlControl:SetText(tostring(productInfo:getPrice() - productInfo:getPrice() * toInt64(0, couponDiscountRate / 10000) / toInt64(0, 100)))
        end
      else
        self._ui._pearlControl:SetText(tostring(productInfo:getPrice() - productInfo:getPrice() * toInt64(0, couponDiscountRate / 10000) / toInt64(0, 100)))
      end
    else
      local productPrice = productInfo:getPrice() * toInt64(0, self.savedProductCount)
      couponDiscountValue = productPrice - couponDiscountPearl
      if couponDiscountValue <= toInt64(0, 0) then
        couponDiscountValue = ToClient_MinCashProductPriceCoupon()
      end
      self._ui._pearlControl:SetText(tostring(couponDiscountValue))
    end
    self._ui._pearlOriginControl:SetShow(true)
    self._ui._pearlControl:SetShow(true)
    self._ui._pearlOriginControl:SetText(makeDotMoney(productInfo:getPrice()))
    local sizeX = self._ui._pearlControl:GetSizeX() + self._ui._pearlControl:GetTextSizeX() + rightgapX
    self._ui._pearlControl:SetPosX(self._ui.BtmBg:GetSizeX() - sizeX)
    local posX = self._ui._pearlControl:GetPosX() - self._ui._pearlOriginControl:GetTextSizeX() - rightgapX
    self._ui._pearlOriginControl:SetPosX(posX)
    self._ui._pearlOriginControl:SetPosY(self._ui._pearlControl:GetPosY())
  end
end
function pearlShopProductBuy:changePlatformSpecKey()
end
function FromClient_PearlShopProductBuyInit()
  pearlShopProductBuy:initialize()
end
function pearlShopProductBuy:couponListClsoe()
  self._ui._bottomKeyGuideY:SetShow(true)
  self._panel:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "PaGlobalFunc_PearlShopProductBuyDown()")
  self._panel:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "PaGlobalFunc_PearlShopProductBuyUp()")
  self._ui._txt_CouponBG:SetShow(false)
end
function pearlShopProductBuy:couponListUpdate()
  local count = ToClient_GetCouponInfoCount()
  local cashProduct
  local main = -1
  local middle = -1
  local small = -1
  local productNoRaw = self._productNoRaw
  local tcount = 0
  if nil ~= productNoRaw then
    cashProduct = self:getProductInfo()
    main = cashProduct:getMainCategory()
    middle = cashProduct:getMiddleCategory()
    small = cashProduct:getSmallCategory()
  else
    return 0
  end
  if toInt64(0, 0) < cashProduct:getMileagePrice() then
    return 0
  end
  self._ui._list2_Coupon:getElementManager():clearKey()
  for i = 0, count - 1 do
    local couponWrapper = ToClient_GetCouponInfoWrapper(i)
    if 0 == couponWrapper:getCouponState() then
      if nil == cashProduct then
        tcount = tcount + 1
        self._ui._list2_Coupon:getElementManager():pushKey(toInt64(0, i))
      else
        cashProductPrice = cashProduct:getPrice() * toInt64(0, productCount)
        local isDiscountPearl = couponWrapper:isDisCountPearl()
        local minProductPearl = 0
        if isDiscountPearl then
          minProductPearl = couponWrapper:getCouponMinProductPearl()
          if 1 == minProductPearl then
            isDiscountPearl = false
          elseif minProductPearl <= cashProductPrice then
            isDiscountPearl = false
          end
        end
        if true == couponWrapper:checkCategory(main, middle, small) and false == isDiscountPearl then
          tcount = tcount + 1
          self._ui._list2_Coupon:getElementManager():pushKey(toInt64(0, i))
        end
      end
    end
  end
  if tcount > 0 then
    self._isAvailableCoupon = true
  end
  return tcount
end
function PaGlobalFunc_PearlShopProductBuy_ShowCouponList()
  local self = pearlShopProductBuy
  self._ui._bottomKeyGuideY:SetShow(false)
  self._panel:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "")
  self._panel:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "")
  self._ui._txt_CouponBG:SetShow(true)
  self:couponListUpdate()
  ToClient_padSnapSetTargetGroup(self._ui._list2_Coupon)
end
function PaGlobalFunc_PearlShopProductBuy_CreateCouponList(control, key64)
  local self = pearlShopProductBuy
  local idx = Int64toInt32(key64)
  local btn_Coupon = UI.getChildControl(control, "Button_Coupon")
  local txt_Title = UI.getChildControl(btn_Coupon, "StaticText_CouponName")
  local txt_Rate = UI.getChildControl(btn_Coupon, "StaticText_CouponRate")
  local couponWrapper = ToClient_GetCouponInfoWrapper(idx)
  if nil ~= couponWrapper then
    local couponName = couponWrapper:getCouponName()
    local couponKey = couponWrapper:getCouponKey()
    local couponState = couponWrapper:getCouponState()
    local couponExpirationDate = couponWrapper:getExpirationDateTime()
    local couponRate = couponWrapper:getCouponDisCountRate()
    local couponPearl = couponWrapper:getCouponDisCountPearl()
    local couponMaxDiscount = couponWrapper:getCouponMaxDisCountPearl()
    local couponCategory = couponWrapper:getCouponCategoryExpression()
    local isDiscountPearl = couponWrapper:isDisCountPearl()
    btn_Coupon:addInputEvent("Mouse_LUp", "PaGlobalFunc_PearlShopProductBuy_ApplyCoupon(" .. idx .. ")")
    btn_Coupon:addInputEvent("Mouse_On", "PaGlobalFunc_PearlShopProductBuy_FocusOn(" .. idx .. ")")
    btn_Coupon:addInputEvent("Mouse_Out", "PaGlobalFunc_PearlShopProductBuy_FocusOut(" .. idx .. ")")
    txt_Title:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    txt_Title:SetText(couponName)
    if false == isDiscountPearl then
      txt_Rate:SetText(couponRate / 10000 .. "%")
    else
      txt_Rate:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_COUPON_COUPONPEARL", "couponPearl", tostring(couponPearl)))
    end
  end
end
function PaGlobalFunc_PearlShopProductBuy_ApplyCoupon(couponIndex)
  local self = pearlShopProductBuy
  self._selectedCouponIdx = couponIndex
  self:couponListClsoe()
  self:update(true)
  PaGlobalFunc_PearlShopProductBuy_FocusOut(couponIndex)
end
function PaGlobalFunc_PearlShopProductBuy_FocusOn(couponIndex)
  local self = pearlShopProductBuy
  local control = self._ui._list2_Coupon:GetContentByKey(toInt64(0, couponIndex))
  local btn_Coupon = UI.getChildControl(control, "Button_Coupon")
  local txt_Title = UI.getChildControl(btn_Coupon, "StaticText_CouponName")
  local txt_Rate = UI.getChildControl(btn_Coupon, "StaticText_CouponRate")
  txt_Title:SetFontColor(Defines.Color.C_FFEEEEEE)
  txt_Rate:SetFontColor(Defines.Color.C_FFFFD691)
end
function PaGlobalFunc_PearlShopProductBuy_FocusOut(couponIndex)
  local self = pearlShopProductBuy
  local control = self._ui._list2_Coupon:GetContentByKey(toInt64(0, couponIndex))
  local btn_Coupon = UI.getChildControl(control, "Button_Coupon")
  local txt_Title = UI.getChildControl(btn_Coupon, "StaticText_CouponName")
  local txt_Rate = UI.getChildControl(btn_Coupon, "StaticText_CouponRate")
  txt_Title:SetFontColor(Defines.Color.C_FFB2B9D4)
  txt_Rate:SetFontColor(Defines.Color.C_FFB2B9D4)
  btn_Coupon:setRenderTexture(btn_Coupon:getBaseTexture())
end
registerEvent("FromClient_luaLoadComplete", "FromClient_PearlShopProductBuyInit")

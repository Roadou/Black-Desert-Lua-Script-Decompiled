local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_PLT = CppEnums.CashPurchaseLimitType
Panel_IngameCashShop_MakePaymentsFromCart:SetShow(false)
Panel_IngameCashShop_MakePaymentsFromCart:setGlassBackground(true)
Panel_IngameCashShop_MakePaymentsFromCart:ActiveMouseEventEffect(true)
local MakePaymentsFromCart = {
  _button_Win_Close = UI.getChildControl(Panel_IngameCashShop_MakePaymentsFromCart, "Button_Win_Close"),
  _button_Close = UI.getChildControl(Panel_IngameCashShop_MakePaymentsFromCart, "Button_Cancle"),
  _button_Confirm = UI.getChildControl(Panel_IngameCashShop_MakePaymentsFromCart, "Button_Confirm"),
  _staticText_GoodsTotalPriceValue = UI.getChildControl(Panel_IngameCashShop_MakePaymentsFromCart, "StaticText_GoodsTotalPriceValue"),
  _static_LeftBG = UI.getChildControl(Panel_IngameCashShop_MakePaymentsFromCart, "Static_LeftBG"),
  _static_TotalBG = UI.getChildControl(Panel_IngameCashShop_MakePaymentsFromCart, "Static_BuyLineBG"),
  _text_TotalPrice = UI.getChildControl(Panel_IngameCashShop_MakePaymentsFromCart, "StaticText_TotalPrice"),
  _static_PearlIcon = UI.getChildControl(Panel_IngameCashShop_MakePaymentsFromCart, "Static_GoodsTotalPearlIcon"),
  _text_TotalPriceValue = UI.getChildControl(Panel_IngameCashShop_MakePaymentsFromCart, "StaticText_GoodsTotalPriceValue"),
  goodsMaxCount = 20,
  SlotCols = 2,
  goodsListPool = {},
  _totalPrice = Defines.s64_const.s64_0
}
function MakePaymentsFromCart:initialize()
  local slotStartX = 15
  local slotStartY = 50
  local slotGapX = 335
  local slotGapY = 60
  local slotRows = (self.goodsMaxCount - 1) / self.SlotCols
  for goods_Idx = 0, self.goodsMaxCount - 1 do
    local col = goods_Idx % self.SlotCols
    local row = math.floor(goods_Idx / self.SlotCols)
    local posX = slotStartX + slotGapX * col
    local posY = slotStartY + slotGapY * row
    local tempSlot = {}
    tempSlot.goodsBG = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop_MakePaymentsFromCart, "Template_Static_ItemSlotBG", Panel_IngameCashShop_MakePaymentsFromCart, "IngameCashShop_MakePaymentsFromCart_Static_ItemSlotBG_" .. goods_Idx)
    tempSlot.iconBG = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop_MakePaymentsFromCart, "Template_Static_GoodsSlotBG", tempSlot.goodsBG, "IngameCashShop_MakePaymentsFromCart_iconBG_" .. goods_Idx)
    tempSlot.icon = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop_MakePaymentsFromCart, "Template_Static_GoodsSlot", tempSlot.goodsBG, "IngameCashShop_MakePaymentsFromCart_icon_" .. goods_Idx)
    tempSlot.name = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop_MakePaymentsFromCart, "Template_StaticText_GoodsName", tempSlot.goodsBG, "IngameCashShop_MakePaymentsFromCart_itemName_" .. goods_Idx)
    tempSlot.pearlIcon = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop_MakePaymentsFromCart, "Template_Static_GoodsPearlIcon", tempSlot.goodsBG, "IngameCashShop_MakePaymentsFromCart_PearlIcon_" .. goods_Idx)
    tempSlot.price = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop_MakePaymentsFromCart, "Template_StaticText_GoodsPriceValue", tempSlot.goodsBG, "IngameCashShop_MakePaymentsFromCart_Price_" .. goods_Idx)
    tempSlot.count = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop_MakePaymentsFromCart, "Template_StaticText_BuyCount", tempSlot.goodsBG, "IngameCashShop_MakePaymentsFromCart_CountTitle_" .. goods_Idx)
    tempSlot.goodsBG:SetPosX(posX)
    tempSlot.goodsBG:SetPosY(posY)
    tempSlot.goodsBG:SetShow(false)
    self.goodsListPool[goods_Idx] = tempSlot
  end
end
function MakePaymentsFromCart:update()
  for goods_Idx = 0, self.goodsMaxCount - 1 do
    self.goodsListPool[goods_Idx].goodsBG:SetShow(false)
  end
  local cartListCount = getIngameCashMall():getCartListCount()
  for goods_Idx = 0, cartListCount - 1 do
    local slot = self.goodsListPool[goods_Idx]
    local cashProduct = getIngameCashMall():getCartItemByIndex(goods_Idx)
    cashProduct:applySelectedItem()
    local sumPrice = cashProduct:getSelectedItemPrice() * toInt64(0, cashProduct:getCount())
    local cashProductSSW = cashProduct:getCashProductStaticStatus()
    slot.goodsBG:SetShow(true)
    slot.icon:ChangeTextureInfoName("Icon/" .. cashProductSSW:getIconPath())
    slot.name:SetTextMode(UI_TM.eTextMode_LimitText)
    slot.name:SetText(cashProductSSW:getName())
    slot.price:SetText(makeDotMoney(sumPrice))
    slot.count:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_MAKEPAYMENTSFROMCART_COUNT", "getCount", cashProduct:getCount()))
  end
  local totalSumPrice = toInt64(0, 0)
  for index = 0, cartListCount - 1 do
    local selectItem = getIngameCashMall():getCartItemByIndex(index)
    selectItem:applySelectedItem()
    totalSumPrice = totalSumPrice + selectItem:getSelectedItemPrice() * toInt64(0, selectItem:getCount())
  end
  self._staticText_GoodsTotalPriceValue:SetText(makeDotMoney(totalSumPrice))
  self._totalPrice = totalSumPrice
end
function MakePaymentsFromCart:SetPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_IngameCashShop_MakePaymentsFromCart:GetSizeX()
  local panelSizeY = Panel_IngameCashShop_MakePaymentsFromCart:GetSizeY()
  Panel_IngameCashShop_MakePaymentsFromCart:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Panel_IngameCashShop_MakePaymentsFromCart:SetPosY(scrSizeY / 2 - panelSizeY / 2)
end
function MakePaymentsFromCart:WindowSize()
  local cartListCount = getIngameCashMall():getCartListCount()
  local slotGapY = 60
  local BGGapY = 50
  local controlGapY = 5
  local btnGapY = 36
  local cartListYPanelSize = 370
  local cartListYSlotBGSize = 245
  local startSlotCount = math.ceil(cartListCount / 2)
  local lastSlotCount = math.ceil((cartListCount - 8) / 2)
  if cartListCount <= 8 then
    Panel_IngameCashShop_MakePaymentsFromCart:SetSize(Panel_IngameCashShop_MakePaymentsFromCart:GetSizeX(), cartListYPanelSize)
    self._static_LeftBG:SetSize(self._static_LeftBG:GetSizeX(), cartListYSlotBGSize)
  else
    for i = 0, lastSlotCount do
      Panel_IngameCashShop_MakePaymentsFromCart:SetSize(Panel_IngameCashShop_MakePaymentsFromCart:GetSizeX(), cartListYPanelSize)
      self._static_LeftBG:SetSize(self._static_LeftBG:GetSizeX(), cartListYSlotBGSize)
      cartListYPanelSize = cartListYPanelSize + slotGapY
      cartListYSlotBGSize = cartListYSlotBGSize + slotGapY
    end
  end
  self._static_TotalBG:SetPosY(self._static_LeftBG:GetSizeY() + BGGapY)
  self._text_TotalPrice:SetPosY(self._static_TotalBG:GetPosY() + controlGapY)
  self._static_PearlIcon:SetPosY(self._static_TotalBG:GetPosY() + controlGapY)
  self._text_TotalPriceValue:SetPosY(self._static_TotalBG:GetPosY() + controlGapY)
  self._button_Close:SetPosY(self._static_TotalBG:GetPosY() + btnGapY)
  self._button_Confirm:SetPosY(self._static_TotalBG:GetPosY() + btnGapY)
  self._static_TotalBG:ComputePos()
  self._text_TotalPrice:ComputePos()
  self._static_PearlIcon:ComputePos()
  self._text_TotalPriceValue:ComputePos()
  self._button_Close:ComputePos()
  self._button_Confirm:ComputePos()
end
function MakePaymentsFromCart:registMessageHandler()
  self._button_Win_Close:addInputEvent("Mouse_LUp", "HandleClicked_IngameCashShop_MakePaymentsFromCart_Close()")
  self._button_Close:addInputEvent("Mouse_LUp", "HandleClicked_IngameCashShop_MakePaymentsFromCart_Close()")
  self._button_Confirm:addInputEvent("Mouse_LUp", "HandleClicked_IngameCashShop_MakePaymentsFromCart_NoCouponConfirm()")
end
function MakePaymentsFromCart:Close()
  Panel_IngameCashShop_MakePaymentsFromCart:SetShow(false)
end
function HandleClicked_IngameCashShop_MakePaymentsFromCart_Close()
  MakePaymentsFromCart:Close()
end
function HandleClicked_IngameCashShop_MakePaymentsFromCart_NoCouponConfirm()
  local messageboxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_MAKEPAYMENTFROMCART_NOCOUPON")
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageboxMemo,
    functionYes = HandleClicked_IngameCashShop_MakePaymentsFromCart_Confirm,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
  if nil ~= PaGlobalFunc_CashMileage_GetShow and PaGlobalFunc_CashMileage_GetShow() then
    PaGlobal_CashMileage_Close()
  end
end
function HandleClicked_IngameCashShop_MakePaymentsFromCart_Confirm()
  local self = MakePaymentsFromCart
  local pearl = Defines.s64_const.s64_0
  local pearlItemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, getPearlSlotNo())
  if nil ~= pearlItemWrapper then
    pearl = pearlItemWrapper:get():getCount_s64()
  end
  if pearl < self._totalPrice then
    _InGameShopBuy_Confirm_LackMoney(CppEnums.CashProductCategory.eCashProductCategory_Normal)
    MakePaymentsFromCart:Close()
    return
  end
  local itemResult = getIngameCashMall():requestBuyCart()
  MakePaymentsFromCart:Close()
  if 0 == itemResult then
    InGameShop_CartClear()
  end
end
function FGlobal_IngameCashShop_MakePaymentsFromCart_Open()
  MakePaymentsFromCart:update()
  MakePaymentsFromCart:SetPosition()
  MakePaymentsFromCart:WindowSize()
  Panel_IngameCashShop_MakePaymentsFromCart:SetShow(true)
  if true == _ContentsGroup_PearlShopMileage and true == PaGlobal_CashMileage_IsOpenCheck() then
    PaGlobal_CashMileage_ChangeConsumePearl(Int64toInt32(MakePaymentsFromCart._totalPrice))
  end
end
function FGlobal_IngameCashShop_MakePaymentsFromCart_Close()
  MakePaymentsFromCart:Close()
end
MakePaymentsFromCart:initialize()
MakePaymentsFromCart:registMessageHandler()

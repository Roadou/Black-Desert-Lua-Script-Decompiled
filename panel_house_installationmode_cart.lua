local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
Panel_House_InstallationMode_Cart:SetShow(false)
local HouseInstallationCart = {
  bg_BuyPearl = UI.getChildControl(Panel_House_InstallationMode_Cart, "Static_BuyPearlBG"),
  have_PearlIcon = UI.getChildControl(Panel_House_InstallationMode_Cart, "Static_NowPearlIcon"),
  have_PearlValue = UI.getChildControl(Panel_House_InstallationMode_Cart, "StaticText_NowPearlCount"),
  btn_BuyPearl = UI.getChildControl(Panel_House_InstallationMode_Cart, "Button_BuyPearl"),
  bg_Cart = UI.getChildControl(Panel_House_InstallationMode_Cart, "Static_CartBG"),
  cart_Title = UI.getChildControl(Panel_House_InstallationMode_Cart, "StaticText_CartTitle"),
  bg_cartList = UI.getChildControl(Panel_House_InstallationMode_Cart, "Static_CartListBG"),
  scroll = UI.getChildControl(Panel_House_InstallationMode_Cart, "Scroll_CartList"),
  bg_BuyCart = UI.getChildControl(Panel_House_InstallationMode_Cart, "Static_CartBuyBG"),
  bg_BuyCartPearl = UI.getChildControl(Panel_House_InstallationMode_Cart, "Static_CartTotal_PearlBG"),
  sum_Title = UI.getChildControl(Panel_House_InstallationMode_Cart, "StaticText_CartTotal_Title"),
  sum_PearlIcon = UI.getChildControl(Panel_House_InstallationMode_Cart, "Static_CartTotal_PearlIcon"),
  sum_PearlValue = UI.getChildControl(Panel_House_InstallationMode_Cart, "StaticText_CartTotal_PearlCount"),
  btn_ClearCart = UI.getChildControl(Panel_House_InstallationMode_Cart, "Button_CartClear"),
  btn_BuyCartItem = UI.getChildControl(Panel_House_InstallationMode_Cart, "Button_CartBuy"),
  _isModeShow = false,
  SlotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createCash = true,
    createCash = true
  },
  slotUIPool = {},
  maxSlotCount = 14,
  hasItemCount = 0,
  nowInterval = 0,
  maxInterval = 0
}
local Template = {
  cashIconBG = UI.getChildControl(Panel_House_InstallationMode_Cart, "Template_Static_CashIconBG")
}
function HouseInstallationCart:Initialize()
  local function setGroup()
    self.bg_BuyPearl:AddChild(self.have_PearlIcon)
    self.bg_BuyPearl:AddChild(self.have_PearlValue)
    self.bg_BuyPearl:AddChild(self.btn_BuyPearl)
    Panel_House_InstallationMode_Cart:RemoveControl(self.have_PearlIcon)
    Panel_House_InstallationMode_Cart:RemoveControl(self.have_PearlValue)
    Panel_House_InstallationMode_Cart:RemoveControl(self.btn_BuyPearl)
    self.have_PearlIcon:SetPosX(5)
    self.have_PearlIcon:SetPosY(7)
    self.have_PearlValue:SetPosX(30)
    self.have_PearlValue:SetPosY(5)
    self.btn_BuyPearl:SetPosX(125)
    self.btn_BuyPearl:SetPosY(5)
    self.btn_BuyPearl:SetShow(false)
    self.bg_Cart:AddChild(self.cart_Title)
    self.bg_Cart:AddChild(self.bg_cartList)
    self.bg_Cart:AddChild(self.bg_BuyCart)
    self.bg_Cart:AddChild(self.scroll)
    Panel_House_InstallationMode_Cart:RemoveControl(self.cart_Title)
    Panel_House_InstallationMode_Cart:RemoveControl(self.bg_cartList)
    Panel_House_InstallationMode_Cart:RemoveControl(self.bg_BuyCart)
    Panel_House_InstallationMode_Cart:RemoveControl(self.scroll)
    self.cart_Title:SetPosX(0)
    self.cart_Title:SetPosY(25)
    self.bg_cartList:SetPosX(10)
    self.bg_cartList:SetPosY(35)
    self.bg_BuyCart:SetPosX(10)
    self.bg_BuyCart:SetPosY(430)
    self.scroll:SetPosX(170)
    self.scroll:SetPosY(40)
    self.bg_BuyCart:AddChild(self.bg_BuyCartPearl)
    self.bg_BuyCart:AddChild(self.btn_ClearCart)
    self.bg_BuyCart:AddChild(self.btn_BuyCartItem)
    Panel_House_InstallationMode_Cart:RemoveControl(self.bg_BuyCartPearl)
    Panel_House_InstallationMode_Cart:RemoveControl(self.btn_ClearCart)
    Panel_House_InstallationMode_Cart:RemoveControl(self.btn_BuyCartItem)
    self.bg_BuyCartPearl:SetPosX(5)
    self.bg_BuyCartPearl:SetPosY(5)
    self.btn_ClearCart:SetPosX(5)
    self.btn_ClearCart:SetPosY(40)
    self.btn_BuyCartItem:SetPosX(70)
    self.btn_BuyCartItem:SetPosY(40)
    self.bg_BuyCartPearl:AddChild(self.sum_Title)
    self.bg_BuyCartPearl:AddChild(self.sum_PearlIcon)
    self.bg_BuyCartPearl:AddChild(self.sum_PearlValue)
    Panel_House_InstallationMode_Cart:RemoveControl(self.sum_Title)
    Panel_House_InstallationMode_Cart:RemoveControl(self.sum_PearlIcon)
    Panel_House_InstallationMode_Cart:RemoveControl(self.sum_PearlValue)
    self.sum_Title:SetPosX(10)
    self.sum_Title:SetPosY(5)
    self.sum_PearlIcon:SetPosX(56)
    self.sum_PearlIcon:SetPosY(7)
    self.sum_PearlValue:SetPosX(80)
    self.sum_PearlValue:SetPosY(5)
    HouseInstallationCart.scrollCtrlBTN = UI.getChildControl(HouseInstallationCart.scroll, "Scroll_CtrlButton")
  end
  setGroup()
  local SlotStartX = 25
  local SlotStartY = 5
  local SlotGapX = 60
  local SlotGapY = 55
  local SlotCols = 2
  for slot_Idx = 0, self.maxSlotCount - 1 do
    local tempArray = {}
    local col = slot_Idx % SlotCols
    local row = math.floor(slot_Idx / SlotCols)
    local posX = SlotStartX + SlotGapX * col
    local posY = SlotStartY + SlotGapY * row
    local created_SlotBG = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, self.bg_cartList, "Panel_House_InstallationCart_SlotBG_" .. slot_Idx)
    CopyBaseProperty(Template.cashIconBG, created_SlotBG)
    created_SlotBG:SetShow(false)
    created_SlotBG:SetPosX(posX)
    created_SlotBG:SetPosY(posY)
    tempArray.SlotBG = created_SlotBG
    local slot = {}
    SlotItem.new(slot, "Panel_House_InstallationCart_SlotItem_" .. slot_Idx, slot_Idx, created_SlotBG, self.SlotConfig)
    slot:createChild()
    slot.icon:SetPosX(3)
    slot.icon:SetPosY(3)
    slot.icon:addInputEvent("Mouse_LUp", "HandleClicked_InstallationModeCart_ItemSlot(" .. slot_Idx .. ")")
    slot.icon:addInputEvent("Mouse_DownScroll", "_InstallationModeCart_ScrollUpdate( true )")
    slot.icon:addInputEvent("Mouse_UpScroll", "_InstallationModeCart_ScrollUpdate( false )")
    tempArray.slotItem = slot
    self.slotUIPool[slot_Idx] = tempArray
  end
end
function HouseInstallationCart:SetPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_House_InstallationMode_Cart:GetSizeX()
  local panelSizeY = Panel_House_InstallationMode_Cart:GetSizeY()
  Panel_House_InstallationMode_Cart:SetPosX(scrSizeX - panelSizeX - 10)
  Panel_House_InstallationMode_Cart:SetPosY(10)
end
function HouseInstallationCart:SetCartCount()
  self.hasItemCount = housing_getShoppingBasketItemCount()
end
function HouseInstallationCart:SetScroll()
  local dataCount = self.hasItemCount
  local countByline = self.maxSlotCount / 2
  local totalLine = math.ceil(dataCount / 2)
  local interval = totalLine
  if dataCount > self.maxSlotCount then
    self.scroll:SetShow(true)
  else
    self.scroll:SetShow(false)
  end
  if interval < 0 then
    interval = 0
  end
  self.maxInterval = interval
  self.nowInterval = 0
  self.scroll:SetInterval(self.maxInterval)
  local pagePercent = countByline / totalLine * 100
  local scrollSizeY = self.scroll:GetSizeY()
  local btn_scrollSizeY = scrollSizeY / 100 * pagePercent
  if btn_scrollSizeY < 20 then
    btn_scrollSizeY = 20
  end
  if scrollSizeY < btn_scrollSizeY then
    btn_scrollSizeY = scrollSizeY
  end
  self.scrollCtrlBTN:SetSize(self.scrollCtrlBTN:GetSizeX(), btn_scrollSizeY)
  self.scroll:SetInterval(self.maxInterval)
end
function _InstallationModeCart_ScrollUpdate(isDown)
  local self = HouseInstallationCart
  local interval = self.nowInterval
  if true == isDown then
    if interval < self.maxInterval then
      interval = interval + 1
      self.scroll:ControlButtonDown()
    else
      return
    end
  elseif interval > 0 then
    interval = interval - 1
    self.scroll:ControlButtonUp()
  else
    return
  end
  self.nowInterval = interval
  self:Update(self.nowInterval)
end
function HouseInstallationCart:Update(nowInterval)
  for slot_Idx = 0, self.maxSlotCount - 1 do
    local uiPool = self.slotUIPool[slot_Idx]
    uiPool.SlotBG:SetShow(false)
    uiPool.slotItem:clearItem()
    uiPool.slotItem.icon:addInputEvent("Mouse_On", "")
    uiPool.slotItem.icon:addInputEvent("Mouse_Out", "")
  end
  local s64_havePearls = 0
  local pearlItemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, getPearlSlotNo())
  if nil ~= pearlItemWrapper then
    s64_havePearls = pearlItemWrapper:get():getCount_s64()
  end
  self.have_PearlValue:SetText(makeDotMoney(s64_havePearls))
  self.sum_PearlValue:SetText("0")
  if 0 == self.hasItemCount then
    return
  end
  local s64_SumPearls = toInt64(0, 0)
  for idx = 0, self.hasItemCount - 1 do
    local productNoRaw = housing_getShoppingBasketItemByIndex(idx)
    local cPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(productNoRaw)
    s64_SumPearls = s64_SumPearls + cPSSW:getPrice()
  end
  self.sum_PearlValue:SetText(makeDotMoney(s64_SumPearls))
  local startIdx = nowInterval * 2
  for slot_Idx = startIdx, self.hasItemCount - 1 do
    local uiIdx = slot_Idx - startIdx
    local uiPool = self.slotUIPool[uiIdx]
    local productNoRaw = housing_getShoppingBasketItemByIndex(slot_Idx)
    local cPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(productNoRaw)
    local itemSSW = cPSSW:getItemByIndex(0)
    uiPool.SlotBG:SetShow(true)
    uiPool.slotItem:setItemByStaticStatus(itemSSW, 0)
    uiPool.slotItem.icon:SetShow(true)
    uiPool.slotItem.icon:addInputEvent("Mouse_On", "InstallationModeCart_ShowToolTip(" .. productNoRaw .. ", " .. uiIdx .. ")")
    uiPool.slotItem.icon:addInputEvent("Mouse_Out", "InstallationModeCart_HideToolTip()")
    if uiIdx == self.maxSlotCount - 1 then
      return
    end
  end
end
function InstallationModeCart_ShowToolTip(productNoRaw, uiIdx)
  local self = HouseInstallationCart
  local cPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(productNoRaw)
  local itemSSW = cPSSW:getItemByIndex(0)
  local Uislot = self.slotUIPool[uiIdx]
  Panel_Tooltip_Item_Show(itemSSW, Uislot.slotItem.icon, true, false)
end
function InstallationModeCart_HideToolTip()
  Panel_Tooltip_Item_hideTooltip()
end
function FGlobal_House_InstallationModeCart_Update()
  HouseInstallationCart:UpdateAll()
end
function HouseInstallationCart:UpdateAll()
  self:SetCartCount()
  self:SetScroll()
  self:Update(self.nowInterval)
end
function HandleClicked_InstallationModeCart_BuyPearl()
  FGlobal_IngameCashShop_PearlCharge_Open()
end
function HandleClicked_InstallationModeCart_BuyItemAll()
  local buyCartDo = function()
    housing_buyShoppinBasketItems()
  end
  local messageBoxMemo = ""
  if getSelfPlayer():get():isMyHouseVisiting() then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_CART_BUYITEMALL_MSGMEMO1")
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_CART_BUYITEMALL_MSGMEMO2")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = buyCartDo,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleClicked_InstallationModeCart_Clear()
  housing_clearShoppingBasketItems()
  HouseInstallationCart:UpdateAll()
end
function FGlobal_House_InstallationModeCart_Update()
  HouseInstallationCart:UpdateAll()
end
function FGlobal_House_InstallationModeCart_Open()
  if getContentsServiceType() ~= CppEnums.ContentsServiceType.eContentsServiceType_Commercial then
    return
  end
  HouseInstallationCart:SetPosition()
  HouseInstallationCart:UpdateAll()
  Panel_House_InstallationMode_Cart:SetShow(true)
end
function FGlobal_House_InstallationModeCart_Close()
  Panel_House_InstallationMode_Cart:SetShow(false)
end
function HandleClicked_InstallationModeCart_ItemSlot(slotIndex)
  housing_clearShoppingBasketItemByIndex(slotIndex)
  HouseInstallationCart:UpdateAll()
end
function HouseInstallationCart:registEventHandler()
  self.btn_BuyPearl:addInputEvent("Mouse_LUp", "HandleClicked_InstallationModeCart_BuyPearl()")
  self.btn_BuyCartItem:addInputEvent("Mouse_LUp", "HandleClicked_InstallationModeCart_BuyItemAll()")
  self.btn_ClearCart:addInputEvent("Mouse_LUp", "HandleClicked_InstallationModeCart_Clear()")
  self.bg_cartList:addInputEvent("Mouse_DownScroll", "_InstallationModeCart_ScrollUpdate( true )")
  self.bg_cartList:addInputEvent("Mouse_UpScroll", "_InstallationModeCart_ScrollUpdate( false )")
end
HouseInstallationCart:Initialize()
HouseInstallationCart:registEventHandler()

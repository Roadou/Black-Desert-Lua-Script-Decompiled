local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
Panel_House_InstallationMode_Cart:SetShow(false)
PaGlobal_HouseInstallationCart = {
  _ui = {
    _bg_BuyPearl = UI.getChildControl(Panel_House_InstallationMode_Cart, "Static_BuyPearlBG"),
    _bg_Cart = UI.getChildControl(Panel_House_InstallationMode_Cart, "Static_CartBG"),
    _bg_Interior = UI.getChildControl(Panel_House_InstallationMode_Cart, "Static_Total_InteriorPointBG")
  },
  _template = {
    _cashIconBG = UI.getChildControl(Panel_House_InstallationMode_Cart, "Template_Static_CashIconBG")
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createCash = true,
    createCash = true
  },
  _isModeShow = false,
  _slotUIPool = {},
  _maxSlotCount = 10,
  _slotCols = 5,
  _hasItemCount = 0,
  _nowInterval = 0,
  _maxInterval = 0
}
function PaGlobal_HouseInstallationCart:initialize()
  local function setGroup()
    self._ui = {
      _cartList = UI.getChildControl(self._ui._bg_Cart, "Static_CartList"),
      _scroll = UI.getChildControl(self._ui._bg_Cart, "Scroll_CartList"),
      _bg_BuyCart = UI.getChildControl(self._ui._bg_Cart, "Static_BuyCartBG"),
      _scrollGroup = {},
      _buyCart = {},
      _have_PearlIcon = UI.getChildControl(self._ui._bg_BuyPearl, "Static_Have_PearlIcon"),
      _have_PearlText = UI.getChildControl(self._ui._bg_BuyPearl, "StaticText_HavePearl"),
      _have_PearlValue = UI.getChildControl(self._ui._bg_BuyPearl, "StaticText_HavePearlValue"),
      _btn_BuyPearl = UI.getChildControl(self._ui._bg_BuyPearl, "Button_BuyPearl"),
      _interiorText = UI.getChildControl(self._ui._bg_Interior, "StaticText_Total_InteriorPoint"),
      _interiorValue = UI.getChildControl(self._ui._bg_Interior, "StaticText_Total_InteriorPointValue"),
      _btn_ClearCart = UI.getChildControl(self._ui._bg_Cart, "Button_ClearCart"),
      _btn_BuyCart = UI.getChildControl(self._ui._bg_Cart, "Button_BuyCart")
    }
    self._ui._buyCart = {
      _sum_PearlIcon = UI.getChildControl(self._ui._bg_BuyCart, "Static_CartTotal_PearlIcon"),
      _sum_Title = UI.getChildControl(self._ui._bg_BuyCart, "StaticText_CartTotal_Title"),
      _sum_PearlValue = UI.getChildControl(self._ui._bg_BuyCart, "StaticText_CartTotal_PearlValue")
    }
    self._ui._scrollGroup = {
      _scrollCtrlBTN = UI.getChildControl(self._ui._scroll, "Scroll_CtrlButton")
    }
    UIScroll.InputEvent(self._ui._scroll, "PaGlobal_HouseInstallationCart:scrollUpdate")
    UIScroll.InputEventByControl(self._ui._scrollGroup._scrollCtrlBTN, "PaGlobal_HouseInstallationCart:scrollUpdate")
    self._ui._scrollGroup._scrollCtrlBTN:addInputEvent("Mouse_LPress", "PaGlobal_HouseInstallationCart:scrollBtn()")
    self._ui._scroll:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallationCart:scrollBtn()")
  end
  setGroup()
  local SlotStartX = 5
  local SlotStartY = 5
  local SlotGapX = 55
  local SlotGapY = 55
  for slot_Idx = 0, self._maxSlotCount - 1 do
    local tempArray = {}
    local col = slot_Idx % self._slotCols
    local row = math.floor(slot_Idx / self._slotCols)
    local posX = SlotStartX + SlotGapX * col
    local posY = SlotStartY + SlotGapY * row
    local created_SlotBG = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, self._ui._cartList, "Panel_House_InstallationCart_SlotBG_" .. slot_Idx)
    CopyBaseProperty(self._template._cashIconBG, created_SlotBG)
    created_SlotBG:SetShow(false)
    created_SlotBG:SetPosX(posX)
    created_SlotBG:SetPosY(posY)
    tempArray.SlotBG = created_SlotBG
    local slot = {}
    SlotItem.new(slot, "Panel_House_InstallationCart_SlotItem_" .. slot_Idx, slot_Idx, created_SlotBG, self._slotConfig)
    slot:createChild()
    slot.icon:SetPosX(2)
    slot.icon:SetPosY(2)
    slot.icon:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallationCart:itemSlot(" .. slot_Idx .. ")")
    slot.icon:addInputEvent("Mouse_DownScroll", "PaGlobal_HouseInstallationCart:scrollUpdate( true )")
    slot.icon:addInputEvent("Mouse_UpScroll", "PaGlobal_HouseInstallationCart:scrollUpdate( false )")
    tempArray.slotItem = slot
    self._slotUIPool[slot_Idx] = tempArray
  end
end
function PaGlobal_HouseInstallationCart:update(nowInterval)
  for slot_Idx = 0, self._maxSlotCount - 1 do
    local uiPool = self._slotUIPool[slot_Idx]
    uiPool.SlotBG:SetShow(true)
    uiPool.slotItem:clearItem()
    uiPool.slotItem.icon:addInputEvent("Mouse_On", "")
    uiPool.slotItem.icon:addInputEvent("Mouse_Out", "")
  end
  local s64_havePearls = 0
  local pearlItemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, getPearlSlotNo())
  if nil ~= pearlItemWrapper then
    s64_havePearls = pearlItemWrapper:get():getCount_s64()
  end
  self._ui._have_PearlValue:SetText(makeDotMoney(s64_havePearls))
  self._ui._buyCart._sum_PearlValue:SetText("0")
  self._ui._interiorValue:SetText(ToClient_GetVisitingBuyExpectPlusInteriorPoint())
  if 0 == self._hasItemCount then
    return
  end
  local s64_SumPearls = toInt64(0, 0)
  local interiorTotalPoint = 0
  for idx = 0, self._hasItemCount - 1 do
    local cPSSW = housing_getShoppingBasketItemByIndex_New(idx)
    if nil ~= cPSSW then
      local itemSSW = cPSSW:getItemByIndex(0)
      s64_SumPearls = s64_SumPearls + cPSSW:getPrice()
    end
  end
  self._ui._buyCart._sum_PearlValue:SetText(makeDotMoney(s64_SumPearls))
  local startIdx = nowInterval * self._slotCols
  for slot_Idx = startIdx, self._hasItemCount - 1 do
    local uiIdx = slot_Idx - startIdx
    local uiPool = self._slotUIPool[uiIdx]
    local cPSSW = housing_getShoppingBasketItemByIndex_New(slot_Idx)
    if nil ~= cPSSW then
      local itemSSW = cPSSW:getItemByIndex(0)
      uiPool.SlotBG:SetShow(true)
      uiPool.slotItem:setItemByStaticStatus(itemSSW, 0)
      uiPool.slotItem.icon:SetShow(true)
      uiPool.slotItem.icon:addInputEvent("Mouse_On", "PaGlobal_HouseInstallationCart:showToolTip(" .. slot_Idx .. ", " .. uiIdx .. ")")
      uiPool.slotItem.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    end
    Panel_Tooltip_Item_hideTooltip()
    if uiIdx == self._maxSlotCount - 1 then
      return
    end
  end
end
function PaGlobal_HouseInstallationCart:setPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_House_InstallationMode_Cart:GetSizeX()
  local panelSizeY = Panel_House_InstallationMode_Cart:GetSizeY()
  Panel_House_InstallationMode_Cart:SetPosX(scrSizeX - panelSizeX - 10)
  Panel_House_InstallationMode_Cart:SetPosY(10)
end
function PaGlobal_HouseInstallationCart:setCartCount()
  self._hasItemCount = housing_getShoppingBasketItemCount()
end
function PaGlobal_HouseInstallationCart:setScroll()
  local dataCount = self._hasItemCount
  local countByline = self._maxSlotCount / self._slotCols
  local totalLine = math.ceil(dataCount / self._slotCols)
  local interval = totalLine
  if dataCount > self._maxSlotCount then
    self._ui._scroll:SetShow(true)
  else
    self._ui._scroll:SetShow(false)
  end
  if interval < 0 then
    interval = 0
  end
  self._maxInterval = interval
  self._nowInterval = 0
  self._ui._scroll:SetInterval(self._maxInterval)
  local pagePercent = countByline / totalLine * 100
  local scrollSizeY = self._ui._scroll:GetSizeY()
  local btn_scrollSizeY = scrollSizeY / 100 * pagePercent
  if btn_scrollSizeY < 20 then
    btn_scrollSizeY = 20
  end
  if scrollSizeY < btn_scrollSizeY then
    btn_scrollSizeY = scrollSizeY
  end
  self._ui._scrollGroup._scrollCtrlBTN:SetSize(self._ui._scrollGroup._scrollCtrlBTN:GetSizeX(), btn_scrollSizeY)
  self._ui._scroll:SetInterval(self._maxInterval)
end
function PaGlobal_HouseInstallationCart:updateAll()
  self:setCartCount()
  self:setScroll()
  self:update(self._nowInterval)
end
function FGlobal_House_InstallationModeCart_Open()
  if getContentsServiceType() ~= CppEnums.ContentsServiceType.eContentsServiceType_Commercial then
    return
  end
  local resourceType = getGameServiceType()
  if CppEnums.GameServiceType.eGameServiceType_GT_REAL == resourceType or CppEnums.GameServiceType.eGameServiceType_GT_ALPHA == resourceType then
    return
  end
  PaGlobal_HouseInstallationCart:setPosition()
  PaGlobal_HouseInstallationCart:updateAll()
  Panel_House_InstallationMode_Cart:SetShow(true)
end
function FGlobal_House_InstallationModeCart_Close()
  Panel_House_InstallationMode_Cart:SetShow(false)
end
function FGlobal_House_InstallationModeCart_Update()
  PaGlobal_HouseInstallationCart:updateAll()
end
function FGlobal_House_InstallationModeCart_InteriorPointUpdate()
  PaGlobal_HouseInstallationCart._ui._interiorValue:SetText(ToClient_GetVisitingBuyExpectPlusInteriorPoint())
end
function PaGlobal_HouseInstallationCart:buyPearl()
  FGlobal_IngameCashShop_PearlCharge_Open()
end
function PaGlobal_HouseInstallationCart:buyItemAll()
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
    functionYes = housing_buyShoppinBasketItems,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_HouseInstallationCart:clear()
  housing_clearShoppingBasketItems()
  PaGlobal_HouseInstallationCart:updateAll()
  PaGlobal_HouseInstallationCart._ui._interiorValue:SetText(0)
end
function PaGlobal_HouseInstallationCart:scrollUpdate(isDown)
  local self = PaGlobal_HouseInstallationCart
  local interval = self._nowInterval
  if true == isDown then
    if interval < self._maxInterval then
      interval = interval + 1
      self._ui._scroll:ControlButtonDown()
    else
      return
    end
  elseif interval > 0 then
    interval = interval - 1
    self._ui._scroll:ControlButtonUp()
  else
    return
  end
  self._nowInterval = interval
  self:update(self._nowInterval)
end
function PaGlobal_HouseInstallationCart:scrollBtn()
  local posPer = self._ui._scroll:GetControlPos()
  local viewRow = 2
  local totalRow = math.ceil(self._hasItemCount / (self._maxSlotCount / 2))
  local targetRow = math.floor((totalRow - viewRow) * posPer)
  self._nowInterval = targetRow
  self:update(self._nowInterval)
end
function PaGlobal_HouseInstallationCart:itemSlot(slotIndex)
  housing_clearShoppingBasketItemByIndex(slotIndex)
  PaGlobal_HouseInstallationCart:updateAll()
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_HouseInstallationCart:showToolTip(slotIndex, uiIdx)
  local self = PaGlobal_HouseInstallationCart
  local cPSSW = housing_getShoppingBasketItemByIndex_New(slotIndex)
  if nil ~= cPSSW then
    local itemSSW = cPSSW:getItemByIndex(0)
    local Uislot = self._slotUIPool[uiIdx]
    Panel_Tooltip_Item_Show(itemSSW, Uislot.slotItem.icon, true, false)
  end
end
function PaGlobal_HouseInstallationCart:registEventHandler()
  self._ui._btn_BuyPearl:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallationCart:buyPearl()")
  self._ui._btn_BuyCart:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallationCart:buyItemAll()")
  self._ui._btn_ClearCart:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallationCart:clear()")
  self._ui._cartList:addInputEvent("Mouse_DownScroll", "PaGlobal_HouseInstallationCart:scrollUpdate( true )")
  self._ui._cartList:addInputEvent("Mouse_UpScroll", "PaGlobal_HouseInstallationCart:scrollUpdate( false )")
end
PaGlobal_HouseInstallationCart:initialize()
PaGlobal_HouseInstallationCart:registEventHandler()

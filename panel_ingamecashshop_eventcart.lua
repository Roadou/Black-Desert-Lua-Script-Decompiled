local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local UI_EventCart = CppEnums.EventCartDiscountType
Panel_IngameCashShop_EventCart:SetShow(false)
local isEventCartOpen = ToClient_IsContentsGroupOpen("379")
function FGlobal_IngameCashShopEventCart_IsContentsOpen()
  return isEventCartOpen
end
local EventCart = {
  _list2 = UI.getChildControl(Panel_IngameCashShop_EventCart, "List2_ItemList"),
  btn_X = UI.getChildControl(Panel_IngameCashShop_EventCart, "Button_Win_Close"),
  btn_Confirm = UI.getChildControl(Panel_IngameCashShop_EventCart, "Button_Buy"),
  btn_Gift = UI.getChildControl(Panel_IngameCashShop_EventCart, "Button_Gift"),
  btn_Cancle = UI.getChildControl(Panel_IngameCashShop_EventCart, "Button_ResetAll"),
  point_Tooltip = UI.getChildControl(Panel_IngameCashShop_EventCart, "StaticText_TooltipBg"),
  point_Btn_Question = UI.getChildControl(Panel_IngameCashShop_EventCart, "Button_Question"),
  point_Caution = UI.getChildControl(Panel_IngameCashShop_EventCart, "Static_DescBg"),
  BottomBg = UI.getChildControl(Panel_IngameCashShop_EventCart, "Static_BottomBg"),
  InventorySlotTypeBg = UI.getChildControl(Panel_IngameCashShop_EventCart, "Static_SlotListBG"),
  btn_Radio_List = UI.getChildControl(Panel_IngameCashShop_EventCart, "RadioButton_List"),
  btn_Radio_Slot = UI.getChildControl(Panel_IngameCashShop_EventCart, "RadioButton_Slot"),
  maxSaleTxt = nil,
  maxSaleTxt = nil,
  nextSaleTxt = nil,
  disCountPriveTxt = nil,
  beforePriceTxt = nil,
  currentDiscountValue = nil,
  DropArrow = nil,
  itemCount = nil,
  cautionTxt = nil,
  disCountValue = {
    [0] = 0,
    0
  },
  AnimationBg = nil,
  Ruler = nil,
  point_TooltipList = Array.new(),
  eventCartList = {},
  eventKey = {},
  currentTab = 0,
  preTab = 0,
  eventOpenType = -1,
  eventDiscountType = UI_EventCart.eEventCartDiscountType_Count,
  isTooltipSet = false,
  maxGage = 0,
  oneMakingGage = 0,
  gageList = Array.new(),
  beforPrice = 0,
  isCalculate = false,
  currentColor = 0,
  InventorySlotList = Array.new(),
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchnat = true,
    createCash = true,
    createClassEquipBg = true
  }
}
local maxPpointCount = 10
local startGagePosition = 77
local endGagePosition = 748
local gageSize = endGagePosition - startGagePosition
local avataEquipSlotNoList = {
  [0] = CppEnums.EquipSlotNo.avatarHelm,
  CppEnums.EquipSlotNo.avatarChest,
  CppEnums.EquipSlotNo.avatarGlove,
  CppEnums.EquipSlotNo.avatarBoots,
  CppEnums.EquipSlotNo.avatarWeapon,
  CppEnums.EquipSlotNo.avatarSubWeapon,
  CppEnums.EquipSlotNo.avatarAwakenWeapon,
  CppEnums.EquipSlotNo.avatarUnderWear
}
local avataEquipSlotCount = #avataEquipSlotNoList + 1
local maxEventCartItemCount = 20
local ChangeArrow = {
  [0] = -268,
  -469
}
local arrowTexture = {
  [0] = {
    270,
    149,
    403,
    269
  },
  {
    136,
    149,
    269,
    269
  },
  {
    2,
    149,
    135,
    269
  }
}
local eventType = {_listType = 0, _slotType = 1}
local function arrow_changeTexture(arrow, count)
  local self = EventCart
  if self.currentColor == count then
    return
  else
    self.currentColor = count
  end
  local control = arrow
  control:ChangeTextureInfoName("new_ui_common_forlua/window/ingamecashshop/cashshop_sale_01.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, arrowTexture[count][1], arrowTexture[count][2], arrowTexture[count][3], arrowTexture[count][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function IngameCashShopEventCart_Init()
  local self = EventCart
  Panel_IngameCashShop_EventCart:RegisterUpdateFunc("IngameCashShopEventCartUpdatePerFrame")
  self.btn_Confirm:addInputEvent("Mouse_LUp", "IngameCashShopEventCart_Buy( )")
  self.btn_Confirm:SetShow(true)
  self.btn_Gift:addInputEvent("Mouse_LUp", "IngameCashShopEventCart_Gift( )")
  self.btn_Gift:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_DOGIFT"))
  self.btn_Gift:SetShow(true == _ContentsGroup_PearlShopGift)
  self.btn_Radio_List:addInputEvent("Mouse_LUp", "IngameCashShopEventCart_ChangeTab(0, false)")
  self.btn_Radio_Slot:addInputEvent("Mouse_LUp", "IngameCashShopEventCart_ChangeTab(1, false)")
  self.btn_Cancle:addInputEvent("Mouse_LUp", "IngameCashShopEventCart_Clear( true )")
  self.btn_Cancle:SetShow(true)
  if true == _ContentsGroup_PearlShopGift then
    self.btn_Confirm:SetSpanSize(-110, 15)
    self.btn_Cancle:SetSpanSize(110, 15)
  else
    self.btn_Confirm:SetSpanSize(-55, 15)
    self.btn_Cancle:SetSpanSize(55, 15)
  end
  local list2Control = UI.getChildControl(Panel_IngameCashShop_EventCart, "List2_ItemList")
  local list2Contents = UI.getChildControl(list2Control, "List2_1_Content")
  local itemIcon = UI.getChildControl(list2Contents, "Static_Icon")
  local createSlot = {}
  SlotItem.new(createSlot, "IngameCashShop_EventCartIcon", 0, itemIcon, self.slotConfig)
  createSlot:createChild()
  self._list2:changeAnimationSpeed(10)
  self._list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "IngameCashShopEventCart_ListUpdate")
  self._list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._list2:getElementManager():clearKey()
  self.btn_X:addInputEvent("Mouse_LUp", "IngameCashShopEventCart_Close( )")
  self.btn_X:SetShow(true)
  self.point_Btn_Question:addInputEvent("Mouse_On", "PaGlobal_Event_Point_Tooltip(true)")
  self.point_Btn_Question:addInputEvent("Mouse_Out", "PaGlobal_Event_Point_Tooltip(false)")
  self.maxSaleTxt = UI.getChildControl(self.BottomBg, "StaticText_MaxSale")
  self.nextSaleTxt = UI.getChildControl(self.BottomBg, "StaticText_SaleDesc")
  self.disCountPriveTxt = UI.getChildControl(self.BottomBg, "StaticText_DisCountPriveValue")
  self.beforePriceTxt = UI.getChildControl(self.BottomBg, "StaticText_BeforePriceValue")
  self.currentDiscountValue = UI.getChildControl(self.BottomBg, "StaticText_CurrentDiscountValue")
  self.DropArrow = UI.getChildControl(self.BottomBg, "Static_DropArrow")
  self.itemCount = UI.getChildControl(self.BottomBg, "StaticText_Title")
  self.AnimationBg = UI.getChildControl(self.BottomBg, "Static_AnimationBg")
  self.Ruler = UI.getChildControl(self.AnimationBg, "StaticText_Ruler")
  arrow_changeTexture(self.DropArrow, 0)
  self.AnimationBg:SetRectClipOnArea(float2(0, 0), float2(200, 22))
  self.Ruler:SetPosX(0)
  self.gageList = Array.new()
  for ii = 0, maxPpointCount do
    local StaticText_Value = {}
    StaticText_Value = UI.getChildControl(self.Ruler, "StaticText_Value_" .. ii)
    StaticText_Value:SetShow(true)
    self.gageList[ii] = StaticText_Value
  end
  self.point_Tooltip:SetShow(false)
  self.cautionTxt = UI.getChildControl(self.point_Caution, "StaticText_Desc")
  self.cautionTxt:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.cautionTxt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCART_MAINCAUTION", "itemcount", tostring(maxEventCartItemCount)))
  local prevSizeY = self.point_Caution:GetSizeY()
  local textSizeY = self.cautionTxt:GetTextSizeY()
  self.point_Caution:SetSize(self.point_Caution:GetSizeX(), textSizeY + 15)
  if prevSizeY < textSizeY then
    Panel_IngameCashShop_EventCart:SetSize(Panel_IngameCashShop_EventCart:GetSizeX(), Panel_IngameCashShop_EventCart:GetSizeY() + (textSizeY + 15 - prevSizeY))
    self.cautionTxt:ComputePos()
    self.btn_Confirm:ComputePos()
    self.btn_Gift:ComputePos()
    self.btn_Cancle:ComputePos()
  end
  self.InventorySlotTypeBg:SetShow(true)
  local count = avataEquipSlotCount
  for ii = 0, count - 1 do
    local slot = {
      _icon = {},
      _productNo = 0
    }
    local createSlot
    slot._productNo = 0
    if 0 == ii then
      createSlot = UI.getChildControl(self.InventorySlotTypeBg, "Static_HelmSlotBg")
    elseif 1 == ii then
      createSlot = UI.getChildControl(self.InventorySlotTypeBg, "Static_ArmorSlotBg")
    elseif 2 == ii then
      createSlot = UI.getChildControl(self.InventorySlotTypeBg, "Static_GloveSlotBg")
    elseif 3 == ii then
      createSlot = UI.getChildControl(self.InventorySlotTypeBg, "Static_BootsSlotBg")
    elseif 4 == ii then
      createSlot = UI.getChildControl(self.InventorySlotTypeBg, "Static_MainWeaponSlotBg")
    elseif 5 == ii then
      createSlot = UI.getChildControl(self.InventorySlotTypeBg, "Static_SubWeaponSlotBg")
    elseif 6 == ii then
      createSlot = UI.getChildControl(self.InventorySlotTypeBg, "Static_AwakenWeaponSlotBg")
    else
      if 7 == ii then
        createSlot = UI.getChildControl(self.InventorySlotTypeBg, "Static_UnderwareSlotBg")
      else
      end
    end
    SlotItem.new(slot._icon, "EquipSlot" .. ii, 0, createSlot, self.slotConfig)
    slot._icon:createChild()
    self.InventorySlotList[ii] = slot
  end
end
function IngameCashShopEventCartUpdatePerFrame(deltaTime)
  if false == Panel_IngameCashShop_EventCart:IsShow() then
    return
  end
  local self = EventCart
  if true == self.isCalculate then
    if self.maxGage < self.beforPrice then
      self.beforPrice = self.maxGage
    end
    local nextPosition = self.beforPrice * self.oneMakingGage * -1
    local currentPosition = self.Ruler:GetPosX()
    local calculatePosition
    if nextPosition < currentPosition then
      local movePoint = (currentPosition - nextPosition) * deltaTime
      if movePoint < 1 then
        movePoint = 1
      end
      calculatePosition = currentPosition - movePoint
      if nextPosition >= calculatePosition then
        calculatePosition = nextPosition
        self.isCalculate = false
      end
      if calculatePosition <= ChangeArrow[1] then
        arrow_changeTexture(self.DropArrow, 2)
      elseif calculatePosition <= ChangeArrow[0] then
        arrow_changeTexture(self.DropArrow, 1)
      end
    else
      local movePoint = (nextPosition - currentPosition) * deltaTime
      if movePoint < 1 then
        movePoint = 1
      end
      calculatePosition = currentPosition + movePoint
      if nextPosition <= calculatePosition then
        calculatePosition = nextPosition
        self.isCalculate = false
      end
      if calculatePosition > ChangeArrow[0] then
        arrow_changeTexture(self.DropArrow, 0)
      elseif calculatePosition > ChangeArrow[1] then
        arrow_changeTexture(self.DropArrow, 1)
      end
    end
    self.Ruler:SetPosX(calculatePosition)
  end
end
function InitGageBar()
  local self = EventCart
  local eventWrapper = ToClient_GetEventCategoryStaticStatusWrapperByKeyRaw(self.eventKey[self.currentTab])
  if nil == eventWrapper then
    return false
  end
  self.eventCartList = Array.new()
  local size = eventWrapper:getEventSize()
  self.maxGage = eventWrapper:getEventlDiscountCelling(size - 1)
  local makingSize = self.maxGage / maxPpointCount
  self.oneMakingGage = (endGagePosition - startGagePosition) / self.maxGage
  for ii = 1, maxPpointCount do
    self.gageList[ii]:SetText(makingSize * ii)
  end
  self.Ruler:SetPosX(0)
  return true
end
function ToolBgSet()
  local self = EventCart
  local eventWrapper = ToClient_GetEventCategoryStaticStatusWrapperByKeyRaw(self.eventKey[self.currentTab])
  if nil == eventWrapper then
    return false
  end
  self.eventCartList = Array.new()
  local size = eventWrapper:getEventSize()
  self.point_Tooltip:SetSize(self.point_Tooltip:GetSizeX(), 30 + size * 25)
  for ii = 0, size - 1 do
    local eventText = {}
    eventText = UI.createAndCopyBasePropertyControl(self.point_Tooltip, "StaticText_EventDiscount", self.point_Tooltip, "StaticText_EventDiscount_" .. ii)
    if self.eventDiscountType == UI_EventCart.eEventCartDiscountType_Subtraction then
      eventText:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_EVENTCART_DISCOUNTSTEP", "pearl", tostring(eventWrapper:getEventlDiscountCelling(ii)), "discountpearl", tostring(eventWrapper:getEventlDiscountPrice(ii))))
    elseif self.eventDiscountType == UI_EventCart.eEventCartDiscountType_Rate then
      eventText:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_EVENTCART_NEXTAPPLYDISCOUNTBYRATE", "pearl", tostring(eventWrapper:getEventlDiscountCelling(ii)), "discountpearl", tostring(string.format("%.0f", eventWrapper:getEventlDiscountPrice(ii) / 10000))))
    end
    eventText:SetPosY(30 + ii * 25)
    eventText:SetShow(true)
    self.point_TooltipList[ii] = eventText
  end
  return true
end
function PaGlobal_Event_Point_Tooltip(isShow)
  local self = EventCart
  if false == self.isTooltipSet then
    self.point_Tooltip:SetShow(false)
    return
  end
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local eventCartPosX = Panel_IngameCashShop_EventCart:GetPosX()
  local eventCartPosY = Panel_IngameCashShop_EventCart:GetPosY()
  local eventCartSizeX = Panel_IngameCashShop_EventCart:GetSizeX()
  local eventCartSizeY = Panel_IngameCashShop_EventCart:GetSizeY()
  local point_TooltipSizeX = self.point_Tooltip:GetSizeX()
  local point_TooltipSizeY = self.point_Tooltip:GetSizeY()
  local setPosX = 0 - point_TooltipSizeX
  local setPosY = 0
  if eventCartPosX - point_TooltipSizeX < 0 then
    setPosX = eventCartSizeX
  end
  if screenSizeX < eventCartPosX + eventCartSizeX then
    setPosX = 0 - point_TooltipSizeX
  end
  if eventCartPosY < 0 then
    setPosY = -1 * eventCartPosY
  end
  if screenSizeY < eventCartPosY + point_TooltipSizeY then
    setPosY = screenSizeY - (eventCartPosY + point_TooltipSizeY)
  end
  self.point_Tooltip:SetPosX(setPosX)
  self.point_Tooltip:SetPosY(setPosY)
  self.point_Tooltip:SetShow(isShow)
end
function IngameCashShopEventCart_ListUpdate(contents, key)
  local self = EventCart
  local idx = Int64toInt32(key)
  local txt_Title = UI.getChildControl(contents, "StaticText_Name")
  local txt_Price = UI.getChildControl(contents, "StaticText_PriceValue")
  local btn_Delete = UI.getChildControl(contents, "List2_Button_MemoList_RemoveMemo")
  local slot_iconBG = UI.getChildControl(contents, "Static_Slot_IconBG")
  local slot_icon = UI.getChildControl(contents, "Static_Icon")
  local createSlot = {}
  SlotItem.reInclude(createSlot, "IngameCashShop_EventCartIcon", 0, slot_icon, self.slotConfig)
  local cashProduct
  cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(idx)
  if nil ~= cashProduct then
    txt_Title:SetShow(true)
    txt_Title:SetTextMode(UI_TM.eTextMode_LimitText)
    txt_Title:SetText(cashProduct:getName())
    txt_Price:SetShow(true)
    txt_Price:SetText(makeDotMoney(cashProduct:getOriginalPrice()))
    slot_iconBG:SetShow(true)
    local item = cashProduct:getItemByIndex(0)
    createSlot:setItemByStaticStatus(item, 1, -1, false)
    contents:SetIgnore(false)
    contents:addInputEvent("Mouse_LUp", "IngameCashShopEventCart_Selected(" .. idx .. ")")
    btn_Delete:addInputEvent("Mouse_LUp", "IngameCashShopEventCart_Delete(" .. idx .. ")")
  end
end
function IngameCashShopEventCart_ShowItemToolTip(isShow, cashProductKeyRaw, index)
  local self = EventCart
  if true == isShow then
    local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(cashProductKeyRaw)
    local itemWrapper = cashProduct:getItemByIndex(index)
    Panel_Tooltip_Item_Show(itemWrapper, Panel_IngameCashShop_EventCart, true)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function IngameCashShopEventCart_Selected(productNoRaw)
  FGlobal_CashShop_SetEquip_Update(productNoRaw)
  FGlobal_CashShop_SetEquip_SelectedItem(productNoRaw)
end
function IngameCashShopEventCart_Update(productNoRaw, index)
  if true == InGameShopBuy_IsOpen() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantInsertOrDeleteEventCartItemOnPopUp"))
    return false
  end
  local self = EventCart
  local cashProduct
  if index ~= self.currentTab then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantPushItemOnEventCartDifferent"))
    return false
  end
  if Panel_IngameCashShop_EventCart:IsShow() and nil ~= productNoRaw then
    cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNoRaw)
    if nil == cashProduct then
      return false
    end
    local rv = getIngameCashMall():pushEventCart(productNoRaw, self.currentTab)
    if 0 == rv then
      if eventType._listType == self.currentTab then
        self._list2:getElementManager():pushKey(productNoRaw)
      else
        if eventType._slotType == self.currentTab then
          local count = avataEquipSlotCount
          for ii = 0, count - 1 do
            local equipCashProductNo = getIngameCashMall():getEventCartSlotListByIndex(avataEquipSlotNoList[ii], self.currentTab)
            if productNoRaw == equipCashProductNo then
              local item = cashProduct:getItemByIndex(0)
              self.InventorySlotList[ii]._icon:setItemByStaticStatus(item, 1, -1, false)
              self.InventorySlotList[ii]._icon.icon:addInputEvent("Mouse_RUp", "IngameCashShopEventCart_Delete(" .. productNoRaw .. ")")
              self.InventorySlotList[ii]._productNo = productNoRaw
            elseif 0 == equipCashProductNo then
              self.InventorySlotList[ii]._icon:clearItem()
              self.InventorySlotList[ii]._icon.icon:removeInputEvent("Mouse_RUp")
              self.InventorySlotList[ii]._productNo = 0
            end
          end
        else
        end
      end
      IngameCashShopEventCart_UpdatePrice()
      ToClient_RequestRecommendList(productNoRaw)
    end
  end
end
function IngameCashShopEventCart_Delete(productNoRaw)
  if true == InGameShopBuy_IsOpen() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantInsertOrDeleteEventCartItemOnPopUp"))
    return false
  end
  local self = EventCart
  if Panel_IngameCashShop_EventCart:IsShow() then
    local index = getIngameCashMall():popEventCart(productNoRaw, self.currentTab)
    if -1 ~= index then
      if eventType._listType == self.currentTab then
        self._list2:getElementManager():removeByIndex(index)
      else
        if eventType._slotType == self.currentTab then
          local count = avataEquipSlotCount
          for ii = 0, count - 1 do
            if productNoRaw == self.InventorySlotList[ii]._productNo then
              self.InventorySlotList[ii]._icon:clearItem()
              self.InventorySlotList[ii]._icon.icon:removeInputEvent("Mouse_RUp")
              self.InventorySlotList[ii]._productNo = 0
            end
          end
        else
        end
      end
      IngameCashShopEventCart_UpdatePrice()
    end
  end
end
function IngameCashShopEventCart_CheckBTN(checkType)
  self._list2:SetShow(true)
  IngameCashShopEventCart_Update()
end
function IngameCashShopEventCart_Open(enventKey, enventSlotKey)
  local self = EventCart
  if not isEventCartOpen then
    return
  end
  if Panel_IngameCashShop:IsShow() then
    if 0 == enventKey and 0 == enventSlotKey then
      return
    end
    local listOpen = true
    local slotOpen = true
    local eventListWrapper = ToClient_GetEventCategoryStaticStatusWrapperByKeyRaw(enventKey)
    if nil ~= eventListWrapper then
      local isSellinPeriod = eventListWrapper:isSellinPeriod()
      local isDiscountPeriod = eventListWrapper:isDiscountPeriod()
      if true == isSellinPeriod and false == isDiscountPeriod then
        listOpen = false
      end
    else
      listOpen = false
    end
    local eventSlotWrapper = ToClient_GetEventCategoryStaticStatusWrapperByKeyRaw(enventSlotKey)
    if nil ~= eventSlotWrapper then
      local isSellinPeriod = eventSlotWrapper:isSellinPeriod()
      local isDiscountPeriod = eventSlotWrapper:isDiscountPeriod()
      if true == isSellinPeriod and false == isDiscountPeriod then
        slotOpen = false
      end
    else
      slotOpen = false
    end
    if false == listOpen and false == slotOpen then
      return
    end
    if true == listOpen then
      self.eventKey[0] = enventKey
      self.btn_Radio_List:SetMonoTone(false)
      self.btn_Radio_List:SetEnable(true)
      self.btn_Radio_List:SetShow(true)
      self.btn_Radio_Slot:SetSpanSize(206, 45)
    else
      self.btn_Radio_List:SetMonoTone(true)
      self.btn_Radio_List:SetEnable(false)
      self.btn_Radio_List:SetShow(false)
      self.btn_Radio_Slot:SetSpanSize(9, 45)
    end
    if true == slotOpen then
      self.eventKey[1] = enventSlotKey
      self.btn_Radio_Slot:SetMonoTone(false)
      self.btn_Radio_Slot:SetEnable(true)
      self.btn_Radio_Slot:SetShow(true)
    else
      self.btn_Radio_Slot:SetMonoTone(true)
      self.btn_Radio_Slot:SetEnable(false)
      self.btn_Radio_Slot:SetShow(false)
    end
    Panel_IngameCashShop_EventCart:SetShow(true)
    if true == listOpen then
      IngameCashShopEventCart_ChangeTab(0, true)
    else
      IngameCashShopEventCart_ChangeTab(1, true)
    end
    local screenSizeX = getScreenSizeX()
    local screenSizeY = getScreenSizeY()
    local positionX = screenSizeX - Panel_IngameCashShop_EventCart:GetSizeX()
    local positionY = screenSizeY / 2 - Panel_IngameCashShop_EventCart:GetSizeY() / 2
    Panel_IngameCashShop_EventCart:SetPosX(positionX)
    Panel_IngameCashShop_EventCart:SetPosY(positionY)
  end
end
function IngameCashShopEventCart_Close()
  local self = EventCart
  if Panel_IngameCashShop_EventCart:IsShow() then
    IngameCashShopEventCart_Clear()
    Panel_IngameCashShop_EventCart:SetShow(false)
    InGameShopBuy_Close()
  end
end
function IngameCashShopEventCart_Buy()
  local self = EventCart
  if 0 ~= getIngameCashMall():getEventCartListCount(self.currentTab) then
    FGlobal_InGameShopBuy_Open(0, false, false, false, true)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantBuyEventCartEmpty"))
  end
end
function IngameCashShopEventCart_Gift()
  local self = EventCart
  if false == FGlobal_CheckGiftLevel_IngameCashShop() then
    return
  end
  if 0 ~= getIngameCashMall():getEventCartListCount(self.currentTab) then
    FGlobal_InGameShopBuy_Open(0, true, false, false, true)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantBuyEventCartEmpty"))
  end
end
function IngameCashShopEventCart_ChangeTab(index, isOpen)
  local self = EventCart
  self.preTab = self.currentTab
  self.currentTab = index
  if self.preTab == self.currentTab and false == isOpen then
    return
  end
  local eventWrapper = ToClient_GetEventCategoryStaticStatusWrapperByKeyRaw(self.eventKey[self.currentTab])
  local isSellinPeriod = eventWrapper:isSellinPeriod()
  local isDiscountPeriod = eventWrapper:isDiscountPeriod()
  if eventType._listType == index then
    self.cautionTxt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCART_MAINCAUTION", "itemcount", tostring(maxEventCartItemCount)))
    if true == isOpen then
      self.btn_Radio_List:SetCheck(true)
      self.btn_Radio_Slot:SetCheck(false)
    end
    self._list2:SetShow(true)
    self.InventorySlotTypeBg:SetShow(false)
    local count = avataEquipSlotCount
    for ii = 0, count - 1 do
      self.InventorySlotList[ii]._icon.icon:SetShow(false)
    end
    self.eventDiscountType = eventWrapper:getDiscountType()
    if true == isSellinPeriod and true == isDiscountPeriod then
      self.disCountPriveTxt:SetShow(true)
      local maxSaleString
      if self.eventDiscountType == UI_EventCart.eEventCartDiscountType_Subtraction then
        maxSaleString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCART_POSSIBLEMAXDISCOUNT", "maxpearl", tostring(eventWrapper:getEventlDiscountPrice(eventWrapper:getEventSize() - 1)))
      elseif self.eventDiscountType == UI_EventCart.eEventCartDiscountType_Rate then
        maxSaleString = ""
      end
      self.maxSaleTxt:SetText(maxSaleString)
    else
      self.maxSaleTxt:SetShow(false)
    end
  else
    if eventType._slotType == index then
      self.cautionTxt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCART_MAINCAUTION", "itemcount", tostring(avataEquipSlotCount)))
      if true == isOpen then
        self.btn_Radio_List:SetCheck(false)
        self.btn_Radio_Slot:SetCheck(true)
      end
      self._list2:SetShow(false)
      self.InventorySlotTypeBg:SetShow(true)
      local count = avataEquipSlotCount
      for ii = 0, count - 1 do
        self.InventorySlotList[ii]._icon.icon:SetShow(true)
      end
      self.eventDiscountType = eventWrapper:getDiscountType()
      if true == isSellinPeriod and true == isDiscountPeriod then
        self.disCountPriveTxt:SetShow(true)
        local maxSaleString
        if self.eventDiscountType == UI_EventCart.eEventCartDiscountType_Subtraction then
          maxSaleString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCART_POSSIBLEMAXDISCOUNT", "maxpearl", tostring(eventWrapper:getEventlDiscountPrice(eventWrapper:getEventSize() - 1)))
        elseif self.eventDiscountType == UI_EventCart.eEventCartDiscountType_Rate then
          maxSaleString = ""
        end
        self.maxSaleTxt:SetText(maxSaleString)
      else
        self.maxSaleTxt:SetShow(false)
      end
    else
    end
  end
  IngameCashShopEventCart_UpdatePrice()
  self.isTooltipSet = ToolBgSet()
  InitGageBar()
end
function IngameCashShopEventCart_UpdatePrice()
  local self = EventCart
  if nil == self.currentTab then
    return
  end
  if nil == self.eventKey[self.currentTab] then
    return
  end
  local eventWrapper = ToClient_GetEventCategoryStaticStatusWrapperByKeyRaw(self.eventKey[self.currentTab])
  if nil == eventWrapper then
    return
  end
  local isSellinPeriod = eventWrapper:isSellinPeriod()
  local isDiscountPeriod = eventWrapper:isDiscountPeriod()
  local beforPrice = getIngameCashMall():getEventCartTotalPrice(self.currentTab)
  local discountPrice = getIngameCashMall():getEventCartAlpplyDiscountTotalPrice(self.eventKey[self.currentTab], self.currentTab)
  self.beforePriceTxt:SetText(tostring(Int64toInt32(beforPrice)))
  if eventType._slotType == self.currentTab then
    self.itemCount:SetShow(false)
  else
    self.itemCount:SetShow(true)
    self.itemCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_EVENTCART_ITEMCOUNT") .. " : " .. tostring(getIngameCashMall():getEventCartItemListCount(self.currentTab)) .. "/" .. tostring(maxEventCartItemCount))
  end
  if true == isSellinPeriod and true == isDiscountPeriod then
    self.disCountPriveTxt:SetShow(true)
    self.nextSaleTxt:SetShow(true)
    local nextDiscountPrice = getIngameCashMall():getEventCartNextDiscountPrice(self.eventKey[self.currentTab], self.currentTab)
    local nextCellingPrice = getIngameCashMall():getEventCartNextCellingPrice(self.eventKey[self.currentTab], self.currentTab)
    local nextSaleString
    if self.eventDiscountType == UI_EventCart.eEventCartDiscountType_Subtraction then
      self.disCountPriveTxt:SetText(tostring(discountPrice))
      self.currentDiscountValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCART_PEARL", "pearl", tostring(beforPrice - discountPrice)))
      self.disCountValue[self.currentTab] = tostring(beforPrice - discountPrice)
      nextSaleString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_EVENTCART_NEXTAPPLYDISCOUNT", "pearl", tostring(nextCellingPrice - beforPrice), "discountpearl", tostring(nextDiscountPrice))
    elseif self.eventDiscountType == UI_EventCart.eEventCartDiscountType_Rate then
      if 0 ~= discountPrice and 0 ~= beforPrice then
        self.disCountPriveTxt:SetText(tostring(Int64toInt32(discountPrice)))
        if 0 == Int64toInt32(discountPrice) then
          self.currentDiscountValue:SetText("0%")
        else
          local size = eventWrapper:getEventSize()
          local discountPercent = 0
          for ii = 0, size - 1 do
            local celling = eventWrapper:getEventlDiscountCelling(ii)
            if Int64toInt32(celling) <= Int64toInt32(beforPrice) then
              discountPercent = eventWrapper:getEventlDiscountPrice(ii) / 10000
            end
          end
          if eventWrapper:getEventlDiscountCelling(size - 1) <= Int64toInt32(beforPrice) then
            discountPercent = eventWrapper:getEventlDiscountPrice(size - 1) / 10000
          end
          self.currentDiscountValue:SetText(tostring(string.format("%.0f", discountPercent)) .. "%")
          self.disCountValue[self.currentTab] = string.format("%.0f", discountPercent)
        end
        nextSaleString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_EVENTCART_DISCOUNTSTEPBYRATE", "pearl", tostring(nextCellingPrice - beforPrice), "discountpearl", tostring(string.format("%.0f", Int64toInt32(nextDiscountPrice) / 10000)))
      else
        self.disCountPriveTxt:SetText(0)
        self.currentDiscountValue:SetText(0)
      end
    end
    if tostring(-2) == tostring(nextCellingPrice) then
      self.nextSaleTxt:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_EVENTCART_APPLYMAXDISCOUNT"))
    elseif tostring(-1) == tostring(nextCellingPrice) then
      self.nextSaleTxt:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_EVENTCART_CANTAPPLYDISCOUNT"))
    else
      self.nextSaleTxt:SetText(nextSaleString)
    end
    self.beforPrice = Int64toInt32(beforPrice)
    self.isCalculate = true
  else
    self.disCountPriveTxt:SetShow(false)
    self.nextSaleTxt:SetShow(false)
  end
end
function IngameCashShopEventCart_Clear(isButton)
  if true == isButton and true == InGameShopBuy_IsOpen() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantInsertOrDeleteEventCartItemOnPopUp"))
    return
  end
  local self = EventCart
  self._list2:getElementManager():clearKey()
  getIngameCashMall():clearEventCart()
  IngameCashShopEventCart_UpdatePrice()
  local count = avataEquipSlotCount
  for ii = 0, count - 1 do
    if 0 ~= self.InventorySlotList[ii]._productNo then
      self.InventorySlotList[ii]._icon:clearItem()
      self.InventorySlotList[ii]._icon.icon:removeInputEvent("Mouse_RUp")
      self.InventorySlotList[ii]._productNo = 0
    end
  end
end
function FGlobal_IngameCashShopEventCart_Confirm(currentTab)
  local self = EventCart
  getIngameCashMall():requestBuyItemByEventCart(-1, 0, self.eventKey[currentTab], currentTab)
end
function FGlobal_IngameCashShopEventCartGift_Confirm(currentTab)
  local self = EventCart
  getIngameCashMall():requestBuyGiftForListByEventCart(self.eventKey[currentTab], currentTab)
end
function FGlobal_IngameCashShopEventCart_TotalPrice()
  local self = EventCart
  return getIngameCashMall():getEventCartAlpplyDiscountTotalPrice(self.eventKey[self.currentTab], self.currentTab)
end
function FGlobal_IngameCashShopEventCart_TotalPriceByIndex(currentTab)
  local self = EventCart
  return getIngameCashMall():getEventCartAlpplyDiscountTotalPrice(self.eventKey[currentTab], currentTab)
end
function FGlobal_IngameCashShop_EventCart_DiscountValue(currentTab)
  local self = EventCart
  return self.disCountValue[currentTab]
end
function FGlobal_IngameCashShop_EventCart_EventType(currentTab)
  local self = EventCart
  local eventWrapper = ToClient_GetEventCategoryStaticStatusWrapperByKeyRaw(self.eventKey[self.currentTab])
  return eventWrapper:getDiscountType()
end
function FGlobal_IngameCashShop_EventCart_SelectedTab()
  return EventCart.currentTab
end
function FromClient_buyCompleteCashShopEventCart(isGift, toCharacterName)
  local self = EventCart
  IngameCashShopEventCart_Clear()
  InGameShop_UpdateCash()
  FGlobal_InGameShop_UpdateByBuy()
  InGameShopBuy_Close()
  if isGift then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_NOTIFYCOMPLETEBUYPRODUCT_GIFT", "toCharacterName", toCharacterName))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_NOTIFYCOMPLETE_ACK"))
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_CONFIRM_PEARLBAG"))
  end
end
IngameCashShopEventCart_Init()
registerEvent("FromClient_buyCompleteCashShopEventCart", "FromClient_buyCompleteCashShopEventCart")

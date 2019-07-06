local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
Panel_IngameCashShop_GoodsTooltip:SetShow(false)
Panel_IngameCashShop_GoodsTooltip:setGlassBackground(true)
Panel_IngameCashShop_GoodsTooltip:ActiveMouseEventEffect(true)
local GoodsTooltipInfo = {
  SlotBG = UI.getChildControl(Panel_IngameCashShop_GoodsTooltip, "Static_GoodsSlotBG"),
  Slot = UI.getChildControl(Panel_IngameCashShop_GoodsTooltip, "Static_GoodsSlot"),
  Name = UI.getChildControl(Panel_IngameCashShop_GoodsTooltip, "StaticText_GoodsName"),
  BindType = UI.getChildControl(Panel_IngameCashShop_GoodsTooltip, "StaticText_GoodsBindType"),
  ClassType = UI.getChildControl(Panel_IngameCashShop_GoodsTooltip, "StaticText_GoodsClassType"),
  EnchantLimitedType = UI.getChildControl(Panel_IngameCashShop_GoodsTooltip, "StaticText_GoodsLimitedType"),
  SalesPeriod = UI.getChildControl(Panel_IngameCashShop_GoodsTooltip, "StaticText_GoodsSalesPeriod"),
  DiscountPeriod = UI.getChildControl(Panel_IngameCashShop_GoodsTooltip, "StaticText_GoodsDiscountPeriod"),
  Desc = UI.getChildControl(Panel_IngameCashShop_GoodsTooltip, "StaticText_GoodsDesc"),
  Warning = UI.getChildControl(Panel_IngameCashShop_GoodsTooltip, "StaticText_Warning"),
  ItemListTitle = UI.getChildControl(Panel_IngameCashShop_GoodsTooltip, "StaticText_ItemListTitle"),
  PackingItemUIPool = {},
  PackingItemUIMaxCount = 0,
  itemSlotMaxCount = 20,
  SelectedProductKeyRaw = -1
}
local TemplateTooltipInfo = {
  PackingItemSlotBG = UI.getChildControl(Panel_IngameCashShop_GoodsTooltip, "Static_ItemSlotBG"),
  PackingItemSlot = UI.getChildControl(Panel_IngameCashShop_GoodsTooltip, "Static_ItemSlot"),
  PackingItemName = UI.getChildControl(Panel_IngameCashShop_GoodsTooltip, "StaticText_ItemName")
}
function GoodsTooltipInfo:Initialize()
  self.Name:SetAutoResize(true)
  self.Name:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.Desc:SetAutoResize(true)
  self.Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.Desc:SetFontColor(UI_color.C_FFC4A68A)
  self.BindType:SetShow(false)
  self.ClassType:SetShow(false)
  self.EnchantLimitedType:SetShow(false)
  self.SalesPeriod:SetShow(false)
  self.Warning:SetShow(false)
  self.BindType:SetFontColor(UI_color.C_FF748CAB)
  self.ClassType:SetFontColor(UI_color.C_FF999999)
  self.EnchantLimitedType:SetFontColor(UI_color.C_FF999999)
  self.DiscountPeriod:SetFontColor(UI_color.C_FF748CAB)
  self.Warning:SetFontColor(UI_color.C_FFF26A6A)
  local startPosY = 25
  local PosYGap = 25
  local itemNamePosX = 40
  for itemIdx = 0, self.itemSlotMaxCount do
    local tempSlot = {}
    local CreatePackingItemBG = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, self.ItemListTitle, "CashShop_GoodsTooltipInfo_PackingItemBG_" .. itemIdx)
    CopyBaseProperty(TemplateTooltipInfo.PackingItemSlotBG, CreatePackingItemBG)
    CreatePackingItemBG:SetPosX(15)
    CreatePackingItemBG:SetPosY(startPosY)
    CreatePackingItemBG:SetShow(false)
    tempSlot.SlotBG = CreatePackingItemBG
    local CreatePackingItem = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreatePackingItemBG, "CashShop_GoodsTooltipInfo_PackingItem_" .. itemIdx)
    CopyBaseProperty(TemplateTooltipInfo.PackingItemSlot, CreatePackingItem)
    CreatePackingItem:SetPosX(0)
    CreatePackingItem:SetPosY(0)
    CreatePackingItem:SetShow(false)
    tempSlot.Slot = CreatePackingItem
    local CreatePackingItemName = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreatePackingItemBG, "CashShop_GoodsTooltipInfo_PackingItemName_" .. itemIdx)
    CopyBaseProperty(TemplateTooltipInfo.PackingItemName, CreatePackingItemName)
    CreatePackingItemName:SetPosX(itemNamePosX)
    CreatePackingItemName:SetPosY(0)
    CreatePackingItemName:SetAutoResize(true)
    CreatePackingItemName:SetTextMode(UI_TM.eTextMode_AutoWrap)
    CreatePackingItemName:SetText("\236\149\132\236\157\180\237\133\156\236\157\180\235\166\132\236\157\180 \235\130\152\236\152\181\235\139\136\235\139\164 \236\149\188\237\149\152\237\149\152\237\149\152")
    CreatePackingItemName:SetShow(false)
    tempSlot.ItemName = CreatePackingItemName
    startPosY = startPosY + PosYGap
    self.PackingItemUIPool[itemIdx] = tempSlot
  end
end
function GoodsTooltipInfo:Update()
  for itemIdx = 0, self.itemSlotMaxCount do
    local itemUI = self.PackingItemUIPool[itemIdx]
    itemUI.SlotBG:SetShow(false)
    itemUI.Slot:SetShow(false)
    itemUI.ItemName:SetShow(false)
  end
  local productNoRaw = self.SelectedProductKeyRaw
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNoRaw)
  self.Slot:ChangeTextureInfoName("Icon/" .. cashProduct:getIconPath())
  self.Name:SetText(cashProduct:getName())
  local isEnchantable = 0
  local isBind = 0
  local isEnableClass = 0
  for itemIdx = 0, cashProduct:getItemListCount() - 1 do
    local itemSSW = cashProduct:getItemByIndex(itemIdx)
    if itemSSW:isEquipable() then
      local _isEnchantable = itemSSW:get():isEnchantable()
      if _isEnchantable then
        isEnchantable = isEnchantable + 1
      end
    end
    local itemBindType = itemSSW:get()._vestedType:getItemKey()
    if 1 == itemBindType or 2 == itemBindType then
      isBind = isBind + 1
    end
    local isAllClass = true
    local classNameList
    for idx = 0, getCharacterClassCount() - 1 do
      local className = getCharacterClassName(idx)
      if nil ~= className and "" ~= className and " " ~= className and itemSSW:get()._usableClassType:isOn(idx) then
        isEnableClass = isEnableClass + 1
      end
    end
    local itemUI = self.PackingItemUIPool[itemIdx]
    local itemCount_S64 = cashProduct:getItemCountByIndex(itemIdx)
    local itemCount_S32 = Int64toInt32(itemCount_S64)
    if 1 == itemCount_S32 then
      itemCount_S32 = ""
    end
    itemUI.SlotBG:SetShow(true)
    itemUI.Slot:ChangeTextureInfoName("icon/" .. itemSSW:getIconPath())
    itemUI.Slot:SetText(tostring(itemCount_S32))
    itemUI.Slot:SetShow(true)
    local nameColorGrade = itemSSW:getGradeType()
    if 0 == nameColorGrade then
      itemUI.ItemName:SetFontColor(UI_color.C_FFFFFFFF)
    elseif 1 == nameColorGrade then
      itemUI.ItemName:SetFontColor(4284350320)
    elseif 2 == nameColorGrade then
      itemUI.ItemName:SetFontColor(4283144191)
    elseif 3 == nameColorGrade then
      itemUI.ItemName:SetFontColor(4294953010)
    elseif 4 == nameColorGrade then
      itemUI.ItemName:SetFontColor(4294929408)
    else
      itemUI.ItemName:SetFontColor(UI_color.C_FFFFFFFF)
    end
    itemUI.ItemName:SetText(itemSSW:getName())
    itemUI.ItemName:SetShow(true)
  end
  local itemListCount = cashProduct:getItemListCount()
  local subItemListCount = itemListCount + cashProduct:getSubItemListCount()
  for itemIdx = itemListCount, subItemListCount - 1 do
    local itemSSW = cashProduct:getSubItemByIndex(itemIdx - itemListCount)
    if itemSSW:isEquipable() then
      local _isEnchantable = itemSSW:get():isEnchantable()
      if _isEnchantable then
        isEnchantable = isEnchantable + 1
      end
    end
    local itemBindType = itemSSW:get()._vestedType:getItemKey()
    if 1 == itemBindType or 2 == itemBindType then
      isBind = isBind + 1
    end
    local isAllClass = true
    local classNameList
    for idx = 0, getCharacterClassCount() - 1 do
      local className = getCharacterClassName(idx)
      if nil ~= className and "" ~= className and " " ~= className and itemSSW:get()._usableClassType:isOn(idx) then
        isEnableClass = isEnableClass + 1
      end
    end
    local itemUI = self.PackingItemUIPool[itemIdx]
    local itemCount_S64 = cashProduct:getSubItemCountByIndex(itemIdx - itemListCount)
    local itemCount_S32 = Int64toInt32(itemCount_S64)
    if 1 == itemCount_S32 then
      itemCount_S32 = ""
    end
    itemUI.SlotBG:SetShow(true)
    itemUI.Slot:ChangeTextureInfoName("icon/" .. itemSSW:getIconPath())
    itemUI.Slot:SetText(tostring(itemCount_S32))
    itemUI.Slot:SetShow(true)
    local nameColorGrade = itemSSW:getGradeType()
    if 0 == nameColorGrade then
      itemUI.ItemName:SetFontColor(UI_color.C_FFFFFFFF)
    elseif 1 == nameColorGrade then
      itemUI.ItemName:SetFontColor(4284350320)
    elseif 2 == nameColorGrade then
      itemUI.ItemName:SetFontColor(4283144191)
    elseif 3 == nameColorGrade then
      itemUI.ItemName:SetFontColor(4294953010)
    elseif 4 == nameColorGrade then
      itemUI.ItemName:SetFontColor(4294929408)
    else
      itemUI.ItemName:SetFontColor(UI_color.C_FFFFFFFF)
    end
    itemUI.ItemName:SetText(itemSSW:getName())
    itemUI.ItemName:SetShow(true)
  end
  if isBind > 0 then
    local vestedDesc = IngameShopDetailInfo_ConvertFromCategoryToVestedDesc(cashProduct)
    if nil ~= vestedDesc then
      self.BindType:SetText(vestedDesc)
      self.BindType:SetShow(true)
    else
      self.BindType:SetShow(false)
    end
  else
    self.BindType:SetShow(false)
  end
  local classDesc = IngameShopDetailInfo_ConvertFromCategoryToClassDesc(cashProduct)
  if nil ~= classDesc then
    self.ClassType:SetText(classDesc)
    self.ClassType:SetShow(true)
  else
    self.ClassType:SetShow(false)
  end
  if isEnchantable > 0 then
    self.EnchantLimitedType:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSTOOLTIP_ENCHANTLIMITEDTYPE"))
    self.EnchantLimitedType:SetShow(true)
  else
    self.EnchantLimitedType:SetText("")
    self.EnchantLimitedType:SetShow(false)
  end
  if not cashProduct:isApplyDiscount() then
    self.DiscountPeriod:SetShow(false)
  else
    local endDiscountTimeValue = PATime(cashProduct:getEndDiscountTime():get_s64())
    local endDiscountTime = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTTIME", "GetYear", tostring(endDiscountTimeValue:GetYear()), "GetMonth", tostring(endDiscountTimeValue:GetMonth()), "GetDay", tostring(endDiscountTimeValue:GetDay())) .. " " .. string.format("%.02d", endDiscountTimeValue:GetHour()) .. ":" .. string.format("%.02d", endDiscountTimeValue:GetMinute())
    self.DiscountPeriod:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSTOOLTIP_DISCOUNT", "endDiscountTime", endDiscountTime))
    self.DiscountPeriod:SetShow(true)
  end
  self.Desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSTOOLTIP_PRODUCTDESC", "getDescription", cashProduct:getDescription()))
  local tradeDesc = IngameShopDetailInfo_ConvertFromCategoryToTradeDesc(cashProduct)
  if nil ~= tradeDesc then
    self.Warning:SetTextMode(UI_TM.eTextMode_AutoWrap)
    self.Warning:SetText(tradeDesc)
    self.Warning:SetShow(true)
  else
    self.Warning:SetShow(false)
  end
  local controlPosY = 14
  self.SlotBG:SetPosY(controlPosY)
  self.Slot:SetPosY(controlPosY)
  self.Name:SetPosY(controlPosY + 1)
  controlPosY = controlPosY + self.Name:GetSizeY() * 2.2
  if self.BindType:GetShow() then
    self.BindType:SetPosY(controlPosY)
    controlPosY = controlPosY + self.BindType:GetSizeY()
  end
  if self.ClassType:GetShow() then
    self.ClassType:SetPosY(controlPosY)
    controlPosY = controlPosY + self.ClassType:GetSizeY()
  end
  if self.EnchantLimitedType:GetShow() then
    self.EnchantLimitedType:SetPosY(controlPosY)
    controlPosY = controlPosY + self.EnchantLimitedType:GetSizeY()
  end
  if self.SalesPeriod:GetShow() then
    self.SalesPeriod:SetPosY(controlPosY)
    controlPosY = controlPosY + self.SalesPeriod:GetSizeY()
  end
  if self.DiscountPeriod:GetShow() then
    self.DiscountPeriod:SetPosY(controlPosY)
    controlPosY = controlPosY + self.DiscountPeriod:GetSizeY()
  end
  if self.Desc:GetShow() then
    self.Desc:SetPosY(controlPosY)
    controlPosY = controlPosY + self.Desc:GetTextSizeY() + 5
  end
  if self.Warning:GetShow() then
    self.Warning:SetPosY(controlPosY)
    controlPosY = controlPosY + self.Warning:GetTextSizeY()
  end
  if self.ItemListTitle:GetShow() then
    self.ItemListTitle:SetPosY(controlPosY)
    controlPosY = controlPosY + self.ItemListTitle:GetSizeY()
  end
  local itemListStartPosY = 22
  for itemIdx = 0, subItemListCount - 1 do
    local itemUI = self.PackingItemUIPool[itemIdx]
    if itemUI.SlotBG:GetShow() then
      itemUI.SlotBG:SetPosY(itemListStartPosY)
      itemListStartPosY = itemListStartPosY + itemUI.SlotBG:GetSizeY() + 3
    end
  end
  controlPosY = controlPosY + itemListStartPosY - 22
  Panel_IngameCashShop_GoodsTooltip:SetSize(Panel_IngameCashShop_GoodsTooltip:GetSizeX(), controlPosY + 10)
end
function GoodsTooltipInfo:Open()
  self:Update()
  Panel_IngameCashShop_GoodsTooltip:SetShow(true)
end
function GoodsTooltipInfo:SetPosition(icon, isChoose, scrollArea)
  local itemShow = Panel_IngameCashShop_GoodsTooltip:GetShow()
  if not itemShow then
    return
  end
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local itemPosX = Panel_IngameCashShop_GoodsTooltip:GetSizeX()
  local itemPosY = Panel_IngameCashShop_GoodsTooltip:GetSizeY()
  local posX = icon:GetParentPosX()
  local posY = icon:GetParentPosY()
  if parent then
    posX = icon:getParent():GetParentPosX()
    posY = icon:getParent():GetParentPosY() - 500
  end
  local isLeft = posX > screenSizeX / 2
  local isTop = posY > screenSizeY / 2
  local tooltipSize = {width = 0, height = 0}
  local tooltipEquipped = {width = 0, height = 0}
  local sumSize = {width = 0, height = 0}
  if Panel_IngameCashShop_GoodsTooltip:GetShow() then
    tooltipSize.width = Panel_IngameCashShop_GoodsTooltip:GetSizeX()
    tooltipSize.height = Panel_IngameCashShop_GoodsTooltip:GetSizeY()
    sumSize.width = sumSize.width + tooltipSize.width
    sumSize.height = math.max(sumSize.height, tooltipSize.height)
  end
  if not isLeft then
    posX = posX + icon:GetSizeX()
  end
  if isTop then
    posY = posY + icon:GetSizeY()
    local yDiff = posY - sumSize.height
    if yDiff < 0 then
      posY = posY - yDiff
    end
  else
    local yDiff = screenSizeY - (posY + sumSize.height)
    if yDiff < 0 then
      posY = posY + yDiff
    end
  end
  if Panel_IngameCashShop_GoodsTooltip:GetShow() then
    if isLeft then
      posX = posX - tooltipSize.width
    end
    local yTmp = posY
    if isTop then
      yTmp = yTmp - tooltipSize.height
    end
    if true == isChoose then
      posX = scrollArea:GetSizeX() + 20
      yTmp = scrollArea:GetPosY()
    end
    Panel_IngameCashShop_GoodsTooltip:SetPosX(posX)
    Panel_IngameCashShop_GoodsTooltip:SetPosY(yTmp)
  end
end
function FGlobal_CashShop_GoodsTooltipInfo_Open(productKeyRaw, slotIcon, isChoose, scrollArea)
  local self = GoodsTooltipInfo
  self.SelectedProductKeyRaw = productKeyRaw
  self:Open()
  self:SetPosition(slotIcon, isChoose, scrollArea)
end
function FGlobal_CashShop_GoodsTooltipInfo_Close()
  Panel_IngameCashShop_GoodsTooltip:SetShow(false)
end
GoodsTooltipInfo:Initialize()

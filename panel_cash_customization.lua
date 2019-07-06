local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_BUFFTYPE = CppEnums.UserChargeType
Panel_Cash_Customization:SetShow(false)
Panel_Cash_Customization:SetIgnore(true)
Panel_Cash_Customization:setGlassBackground(true)
Panel_Cash_Customization:ActiveMouseEventEffect(true)
Panel_Cash_Customization_BuyItem:SetShow(false)
Panel_Cash_Customization_BuyItem:setGlassBackground(true)
Panel_Cash_Customization_BuyItem:ActiveMouseEventEffect(true)
local CashCustomization = {
  myProduct_panelBG = UI.getChildControl(Panel_Cash_Customization, "Static_BG"),
  myProduct_Title = UI.getChildControl(Panel_Cash_Customization, "StaticText_Title"),
  isAble = UI.getChildControl(Panel_Cash_Customization, "Static_IsAble"),
  BTN_Apply = UI.getChildControl(Panel_Cash_Customization, "Button_ApplyCustomization"),
  BTN_Close = UI.getChildControl(Panel_Cash_Customization, "Button_Close"),
  BTN_BuyGoods = UI.getChildControl(Panel_Cash_Customization, "Button_BuyGoods"),
  PearlBox = UI.getChildControl(Panel_Cash_Customization, "Static_PearlBox"),
  PearlIcon = UI.getChildControl(Panel_Cash_Customization, "Static_NowPearlIcon"),
  PearlValue = UI.getChildControl(Panel_Cash_Customization, "StaticText_NowPearlCount"),
  BTN_BuyPearl = UI.getChildControl(Panel_Cash_Customization, "Button_BuyPearl"),
  ItemUiPOOL = {},
  ItemUiMaxCount = 0
}
local CashCumaBuy = {
  bg = UI.getChildControl(Panel_Cash_Customization_BuyItem, "Static_BG"),
  bg_notify = UI.getChildControl(Panel_Cash_Customization_BuyItem, "Static_NotifyBG"),
  staticText_notify = UI.getChildControl(Panel_Cash_Customization_BuyItem, "StaticText_Notify"),
  BTN_Confirm = UI.getChildControl(Panel_Cash_Customization_BuyItem, "Button_Confirm"),
  BTN_Cancle = UI.getChildControl(Panel_Cash_Customization_BuyItem, "Button_Cancle"),
  ItemUiPOOL = {},
  ItemUiMaxCount = 0,
  ItemListRow = -1,
  SelectedItemNo = -1,
  ApplyType = ""
}
local TemplateUI = {
  ItemBG = UI.getChildControl(Panel_Cash_Customization, "Template_Static_ItemBG"),
  ItemNameBG = UI.getChildControl(Panel_Cash_Customization, "Template_StaticText_ItemNameBG"),
  ItemName = UI.getChildControl(Panel_Cash_Customization, "Template_StaticText_ItemName"),
  ItemPeriod = UI.getChildControl(Panel_Cash_Customization, "Template_StaticText_Period")
}
local TemplateBuyPanelUI = {
  ItemBG = UI.getChildControl(Panel_Cash_Customization_BuyItem, "Template_Static_ItemBG"),
  ItemNameBG = UI.getChildControl(Panel_Cash_Customization_BuyItem, "Template_StaticText_ItemNameBG"),
  ItemName = UI.getChildControl(Panel_Cash_Customization_BuyItem, "Template_StaticText_ItemName"),
  ItemPeriod = UI.getChildControl(Panel_Cash_Customization_BuyItem, "Template_StaticText_Period"),
  ItemPrice = UI.getChildControl(Panel_Cash_Customization_BuyItem, "Template_StaticText_ItemPrice"),
  PearlIcon = UI.getChildControl(Panel_Cash_Customization_BuyItem, "Template_Static_PearlIcon"),
  BTN_ItemSelected = UI.getChildControl(Panel_Cash_Customization_BuyItem, "Template_RadioButton_SelectedItem")
}
local CashCustomizationData = {}
local CashCustomizationDataCount = 0
function CashCustomization:Initialize()
  self.myProduct_panelBG:AddChild(self.myProduct_Title)
  Panel_Cash_Customization:RemoveControl(self.myProduct_Title)
  self.PearlBox:AddChild(self.PearlIcon)
  self.PearlBox:AddChild(self.PearlValue)
  self.PearlBox:AddChild(self.BTN_BuyPearl)
  Panel_Cash_Customization:RemoveControl(self.PearlIcon)
  Panel_Cash_Customization:RemoveControl(self.PearlValue)
  Panel_Cash_Customization:RemoveControl(self.BTN_BuyPearl)
  self.PearlIcon:SetPosX(5)
  self.PearlIcon:SetPosY(5)
  self.PearlValue:SetPosX(30)
  self.PearlValue:SetPosY(2)
  self.BTN_BuyPearl:SetPosX(self.PearlBox:GetSizeX() - self.BTN_BuyPearl:GetSizeX() - 3)
  self.BTN_BuyPearl:SetPosY(3)
  self.BTN_BuyPearl:SetShow(false)
  TemplateUI.ItemName:SetTextMode(UI_TM.eTextMode_LimitText)
  TemplateBuyPanelUI.ItemName:SetTextMode(UI_TM.eTextMode_AutoWrap)
  local myInvenMoney = getSelfPlayer():get():getCashInventory():getMoney_s64()
  self.PearlValue:SetText(makeDotMoney(myInvenMoney))
end
function CashCustomization:Update()
  CashCustomizationData = {}
  for idx, itemUi in pairs(self.ItemUiPOOL) do
    itemUi.ItemBG:SetShow(false)
  end
  local startPosY = 47
  local slotYGap = 75
  local sizeY = 0
  local idx = 0
  local invenItem
  for invenIdx = 0, ToClient_InventoryGetSize(CppEnums.ItemWhereType.eInventory) - 1 do
    invenItem = ToClient_GetInventoryItemByProductCategory(CppEnums.ItemWhereType.eInventory, CppEnums.ItemProductCategory.eItemProductCategory_Customize, invenIdx)
    if invenItem ~= nil then
      CashCustomizationData[idx] = {}
      CashCustomizationData[idx].name = invenItem:getStaticStatus():getName()
      CashCustomizationData[idx].slotNo = invenIdx
      CashCustomizationData[idx].itemWhereType = CppEnums.ItemWhereType.eInventory
      CashCustomizationData[idx].itemKey = invenItem:get():getKey():getItemKey()
      CashCustomizationData[idx].count = invenItem:get():getCount_s64()
      idx = idx + 1
    end
  end
  local cashInvenItem
  for cashInvenIdx = 0, ToClient_InventoryGetSize(CppEnums.ItemWhereType.eCashInventory) - 1 do
    cashInvenItem = ToClient_GetInventoryItemByProductCategory(CppEnums.ItemWhereType.eCashInventory, CppEnums.ItemProductCategory.eItemProductCategory_Customize, cashInvenIdx)
    if cashInvenItem ~= nil then
      CashCustomizationData[idx] = {}
      CashCustomizationData[idx].name = cashInvenItem:getStaticStatus():getName()
      CashCustomizationData[idx].slotNo = cashInvenIdx
      CashCustomizationData[idx].itemWhereType = CppEnums.ItemWhereType.eCashInventory
      CashCustomizationData[idx].itemKey = cashInvenItem:get():getKey():getItemKey()
      CashCustomizationData[idx].count = cashInvenItem:get():getCount_s64()
      idx = idx + 1
    end
  end
  local productSize = getIngameCashMall():getCashProductListCountByCategory(CppEnums.CashProductCategory.eCashProductCategory_Beauty, 2)
  local product
  for productIdx = 0, productSize - 1 do
    product = getIngameCashMall():getCashProductStaticStatusByCategory(CppEnums.CashProductCategory.eCashProductCategory_Beauty, 2, productIdx)
    if product ~= nil then
      local doHaveItem = false
      for idx, data in pairs(CashCustomizationData) do
        local itemCount = product:getItemCountByIndex(0)
        if itemCount ~= nil and itemCount > Defines.s64_const.s64_0 then
          local itemKey = product:getItemByIndex(0):get()._key:getItemKey()
          if data.itemKey == itemKey then
            doHaveItem = true
            break
          end
        end
      end
      if not doHaveItem then
        CashCustomizationData[idx] = {}
        CashCustomizationData[idx].productNo = product:getNoRaw()
        CashCustomizationData[idx].name = product:getName()
        CashCustomizationData[idx].pearlPrice = product:getPrice()
        CashCustomizationData[idx].count = Defines.s64_const.s64_0
        idx = idx + 1
      end
    end
  end
  CashCustomizationDataCount = #CashCustomizationData + 1
  for cumaIdx = 0, CashCustomizationDataCount - 1 do
    if nil == self.ItemUiPOOL[cumaIdx] then
      local tempSlot = {}
      local CreateItemBG = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, self.myProduct_panelBG, "CashCustomization_ItemBG_" .. cumaIdx)
      CopyBaseProperty(TemplateUI.ItemBG, CreateItemBG)
      CreateItemBG:SetPosX(5)
      CreateItemBG:SetPosY(80)
      CreateItemBG:SetShow(false)
      tempSlot.ItemBG = CreateItemBG
      local CreateItemNameBG = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, CreateItemBG, "CashCustomization_ItemNameBG_" .. cumaIdx)
      CopyBaseProperty(TemplateUI.ItemNameBG, CreateItemNameBG)
      CreateItemNameBG:SetPosX(5)
      CreateItemNameBG:SetPosY(5)
      CreateItemNameBG:SetShow(true)
      tempSlot.ItemNameBG = CreateItemNameBG
      local CreateItemName = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreateItemBG, "CashCustomization_ItemName_" .. cumaIdx)
      CopyBaseProperty(TemplateUI.ItemName, CreateItemName)
      CreateItemName:SetPosX(5)
      CreateItemName:SetPosY(5)
      CreateItemName:SetShow(true)
      tempSlot.ItemName = CreateItemName
      local CreateItemPeriod = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreateItemBG, "CashCustomization_ItemPeriod_" .. cumaIdx)
      CopyBaseProperty(TemplateUI.ItemPeriod, CreateItemPeriod)
      CreateItemPeriod:SetPosX(10)
      CreateItemPeriod:SetPosY(35)
      CreateItemPeriod:SetShow(true)
      tempSlot.ItemPeriod = CreateItemPeriod
      self.ItemUiPOOL[cumaIdx] = tempSlot
      self.ItemUiMaxCount = self.ItemUiMaxCount + 1
    end
    local UiBase = self.ItemUiPOOL[cumaIdx]
    UiBase.ItemBG:SetShow(true)
    UiBase.ItemBG:SetPosY(startPosY)
    if CashCustomizationData[cumaIdx] ~= nil and Defines.s64_const.s64_0 < CashCustomizationData[cumaIdx].count then
      UiBase.ItemName:SetFontColor(UI_color.C_FFE7E7E7)
      UiBase.ItemName:SetText(CashCustomizationData[cumaIdx].name .. "(" .. tostring(CashCustomizationData[cumaIdx].count) .. ")")
      UiBase.ItemPeriod:SetFontColor(UI_color.C_FFE7E7E7)
      if CashCustomizationData[cumaIdx].count == 0 then
        UiBase.ItemPeriod:SetFontColor(UI_color.C_FF999999)
        UiBase.ItemPeriod:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CASH_CUSTOMIZATION_ITEMPERIOD2"))
      else
        UiBase.ItemPeriod:SetText("")
      end
    else
      UiBase.ItemName:SetFontColor(UI_color.C_FF999999)
      if CashCustomizationData[cumaIdx] ~= nil then
        UiBase.ItemName:SetText(CashCustomizationData[cumaIdx].name)
      else
        UiBase.ItemName:SetText("")
      end
      UiBase.ItemPeriod:SetFontColor(UI_color.C_FF999999)
      UiBase.ItemPeriod:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CASH_CUSTOMIZATION_ITEMPERIOD2"))
    end
    startPosY = startPosY + slotYGap
    sizeY = sizeY + UiBase.ItemBG:GetSizeY() + 5
    self.myProduct_panelBG:SetSize(self.myProduct_panelBG:GetSizeX(), sizeY + 85)
  end
end
function FGlobal_CashCustom_CashBgSizeY()
  return CashCustomization.myProduct_panelBG:GetSizeY()
end
function CashCumaBuy:Update(applyType)
  CashCustomizationData = {}
  for idx, itemUi in pairs(self.ItemUiPOOL) do
    itemUi.ItemBG:SetShow(false)
  end
  CashCustomizationDataCount = 0
  CashCumaBuy.ApplyType = applyType
  local idx = 0
  if applyType == "inven" then
    local invenItem
    for invenIdx = 0, ToClient_InventoryGetSize(CppEnums.ItemWhereType.eInventory) - 1 do
      invenItem = ToClient_GetInventoryItemByProductCategory(CppEnums.ItemWhereType.eInventory, CppEnums.ItemProductCategory.eItemProductCategory_Customize, invenIdx)
      if invenItem ~= nil then
        CashCustomizationData[idx] = {}
        CashCustomizationData[idx].name = invenItem:getStaticStatus():getName()
        CashCustomizationData[idx].slotNo = invenIdx
        CashCustomizationData[idx].itemWhereType = CppEnums.ItemWhereType.eInventory
        CashCustomizationData[idx].count = invenItem:get():getCount_s64()
        idx = idx + 1
      end
    end
    local cashInvenItem
    for cashInvenIdx = 0, ToClient_InventoryGetSize(CppEnums.ItemWhereType.eCashInventory) - 1 do
      cashInvenItem = ToClient_GetInventoryItemByProductCategory(CppEnums.ItemWhereType.eCashInventory, CppEnums.ItemProductCategory.eItemProductCategory_Customize, cashInvenIdx)
      if cashInvenItem ~= nil then
        CashCustomizationData[idx] = {}
        CashCustomizationData[idx].name = cashInvenItem:getStaticStatus():getName()
        CashCustomizationData[idx].slotNo = cashInvenIdx
        CashCustomizationData[idx].itemWhereType = CppEnums.ItemWhereType.eCashInventory
        CashCustomizationData[idx].count = cashInvenItem:get():getCount_s64()
        idx = idx + 1
      end
    end
    CashCustomizationDataCount = #CashCustomizationData + 1
  elseif applyType == "pearl" then
    local productSize = getIngameCashMall():getCashProductListCountByCategory(CppEnums.CashProductCategory.eCashProductCategory_Pearl, CppEnums.CashProductCategoryNo_Undefined)
    local product
    for productIdx = 0, productSize - 1 do
      product = getIngameCashMall():getCashProductStaticStatusByCategory(CppEnums.CashProductCategory.eCashProductCategory_Pearl, CppEnums.CashProductCategoryNo_Undefined, productIdx)
      if product ~= nil then
        CashCustomizationData[idx] = {}
        CashCustomizationData[idx].name = product:getName()
        CashCustomizationData[idx].productNo = product:getNoRaw()
        CashCustomizationData[idx].cashPrice = product:getCashPrice()
        CashCustomizationData[idx].count = 0
        idx = idx + 1
      end
    end
    CashCustomizationDataCount = #CashCustomizationData + 1
  else
    local productSize = getIngameCashMall():getCashProductListCountByCategory(CppEnums.CashProductCategory.eCashProductCategory_Beauty, 2)
    local product
    for productIdx = 0, productSize - 1 do
      product = getIngameCashMall():getCashProductStaticStatusByCategory(CppEnums.CashProductCategory.eCashProductCategory_Beauty, 2, productIdx)
      if product ~= nil then
        CashCustomizationData[idx] = {}
        CashCustomizationData[idx].name = product:getName()
        CashCustomizationData[idx].productNo = product:getNoRaw()
        CashCustomizationData[idx].pearlPrice = product:getPrice()
        CashCustomizationData[idx].count = 0
        idx = idx + 1
      end
    end
    CashCustomizationDataCount = #CashCustomizationData + 1
  end
  if true == _ContentsGroup_RenewUI_Customization then
    CashCustomizationDataCount = CashCustomizationDataCount - 1
  end
  if applyType == "inven" then
    self.staticText_notify:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CASH_CUSTOMIZATION_STATICTEXT_NOTIFY1"))
  else
    self.staticText_notify:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CASH_CUSTOMIZATION_STATICTEXT_NOTIFY2"))
  end
  local slotStartX = 15
  local slotStartY = 110
  local slotGapX = 255
  local slotGapY = 75
  local slotCols = 2
  local slotRows = (CashCustomizationDataCount - 1) / slotCols
  for cumaIdx = 0, CashCustomizationDataCount - 1 do
    if nil == self.ItemUiPOOL[cumaIdx] then
      local tempSlot = {}
      local CreateItemBG = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Cash_Customization_BuyItem, "CashCustomizationBuy_ItemBG_" .. cumaIdx)
      CopyBaseProperty(TemplateBuyPanelUI.ItemBG, CreateItemBG)
      CreateItemBG:SetPosX(25)
      CreateItemBG:SetPosY(80)
      CreateItemBG:SetShow(false)
      tempSlot.ItemBG = CreateItemBG
      local CreateItemNameBG = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, CreateItemBG, "CashCustomizationBuy_ItemNameBG_" .. cumaIdx)
      CopyBaseProperty(TemplateBuyPanelUI.ItemNameBG, CreateItemNameBG)
      CreateItemNameBG:SetPosX(5)
      CreateItemNameBG:SetPosY(5)
      CreateItemNameBG:SetShow(true)
      tempSlot.ItemNameBG = CreateItemNameBG
      local CreateItemSelectBTN = UI.createControl(UI_PUCT.PA_UI_CONTROL_RADIOBUTTON, CreateItemBG, "CashCustomizationBuy_ItemSelectBTN_" .. cumaIdx)
      CopyBaseProperty(TemplateBuyPanelUI.BTN_ItemSelected, CreateItemSelectBTN)
      CreateItemSelectBTN:SetPosX(5)
      CreateItemSelectBTN:SetPosY(17)
      CreateItemSelectBTN:SetShow(true)
      tempSlot.ItemSelectBTN = CreateItemSelectBTN
      local CreateItemName = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreateItemBG, "CashCustomizationBuy_ItemName_" .. cumaIdx)
      CopyBaseProperty(TemplateBuyPanelUI.ItemName, CreateItemName)
      CreateItemName:SetPosX(20)
      CreateItemName:SetPosY(3)
      CreateItemName:SetShow(true)
      tempSlot.ItemName = CreateItemName
      local CreateItemPeriod = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreateItemBG, "CashCustomizationBuy_ItemPeriod_" .. cumaIdx)
      CopyBaseProperty(TemplateBuyPanelUI.ItemPeriod, CreateItemPeriod)
      CreateItemPeriod:SetPosX(10)
      CreateItemPeriod:SetPosY(35)
      CreateItemPeriod:SetShow(true)
      CreateItemPeriod:SetText("")
      tempSlot.ItemPeriod = CreateItemPeriod
      local CreatePearlIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, CreateItemBG, "CashCustomizationBuy_PearlIcon_" .. cumaIdx)
      CopyBaseProperty(TemplateBuyPanelUI.PearlIcon, CreatePearlIcon)
      CreatePearlIcon:SetPosX(10)
      CreatePearlIcon:SetPosY(47)
      CreatePearlIcon:SetShow(true)
      tempSlot.PearlIcon = CreatePearlIcon
      local CreateItemPrice = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreateItemBG, "CashCustomizationBuy_ItemPrice_" .. cumaIdx)
      CopyBaseProperty(TemplateBuyPanelUI.ItemPrice, CreateItemPrice)
      CreateItemPrice:SetPosX(40)
      CreateItemPrice:SetPosY(47)
      CreateItemPrice:SetShow(true)
      tempSlot.ItemPrice = CreateItemPrice
      self.ItemUiPOOL[cumaIdx] = tempSlot
      self.ItemUiMaxCount = self.ItemUiMaxCount + 1
    end
    local col = cumaIdx % slotCols
    local row = math.floor(cumaIdx / slotCols)
    local posX = slotStartX + slotGapX * col
    local posY = slotStartY + slotGapY * row
    self.ItemListRow = row
    local UiBase = self.ItemUiPOOL[cumaIdx]
    UiBase.ItemBG:SetPosX(posX)
    UiBase.ItemBG:SetPosY(posY)
    UiBase.ItemBG:SetShow(true)
    UiBase.ItemName:SetFontColor(UI_color.C_FFE7E7E7)
    if applyType == "inven" then
      UiBase.ItemName:SetText(CashCustomizationData[cumaIdx].name .. "(" .. tostring(CashCustomizationData[cumaIdx].count) .. ")")
    else
      UiBase.ItemName:SetText(CashCustomizationData[cumaIdx].name)
    end
    UiBase.ItemPeriod:SetFontColor(UI_color.C_FF999999)
    if applyType == "inven" then
      UiBase.PearlIcon:SetShow(false)
      UiBase.ItemPrice:SetShow(false)
    elseif applyType == "pearl" then
      UiBase.ItemPeriod:SetText("")
      UiBase.ItemPeriod:SetShow(false)
      UiBase.PearlIcon:SetShow(false)
      UiBase.ItemPrice:SetText(makeDotMoney(CashCustomizationData[cumaIdx].cashPrice))
      UiBase.ItemPrice:SetShow(true)
    else
      UiBase.ItemPeriod:SetText("")
      UiBase.ItemPeriod:SetShow(false)
      UiBase.PearlIcon:SetShow(true)
      UiBase.ItemPrice:SetText(makeDotMoney(CashCustomizationData[cumaIdx].pearlPrice))
      UiBase.ItemPrice:SetShow(true)
    end
    UiBase.ItemSelectBTN:addInputEvent("Mouse_LUp", "HandleClicked_CashCustomization_SelectItem( " .. cumaIdx .. " )")
    UiBase.ItemName:addInputEvent("Mouse_LUp", "HandleClicked_CashCustomization_SelectItem( " .. cumaIdx .. " )")
    UiBase.ItemNameBG:addInputEvent("Mouse_LUp", "HandleClicked_CashCustomization_SelectItem( " .. cumaIdx .. " )")
  end
  self.bg:SetSize(self.bg:GetSizeX(), self.bg_notify:GetSizeY() + 15 + (self.ItemListRow + 1) * (TemplateBuyPanelUI.ItemBG:GetSizeY() + 5))
end
function CashCustomization_SetPosition()
  local self = CashCustomization
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_Cash_Customization:GetSizeX()
  local panelSizeY = Panel_Cash_Customization:GetSizeY()
  Panel_Cash_Customization:SetSize(panelSizeX, scrSizeY - TemplateUI.ItemBG:GetSizeY())
  Panel_Cash_Customization:SetPosX(scrSizeX - panelSizeX)
  Panel_Cash_Customization:SetPosY(TemplateUI.ItemBG:GetSizeY() - 10)
  self.BTN_BuyGoods:SetPosX(10)
  self.BTN_BuyGoods:SetPosY(self.myProduct_panelBG:GetSizeY() - 30)
  self.PearlBox:SetPosX(panelSizeX - self.PearlBox:GetSizeX() - 5)
  self.PearlBox:SetPosY(self.myProduct_panelBG:GetSizeY() - 30)
  self.myProduct_panelBG:SetPosY(10)
  self.isAble:SetPosX(self.myProduct_panelBG:GetPosX() - self.isAble:GetSizeX() * 1.5)
  self.isAble:SetPosY(self.myProduct_panelBG:GetPosY())
  self.BTN_Apply:ComputePos()
  self.BTN_Close:ComputePos()
end
function CashCustomizationBuy_SetPosition()
  local self = CashCumaBuy
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  Panel_Cash_Customization_BuyItem:SetSize(Panel_Cash_Customization_BuyItem:GetSizeX(), (self.ItemListRow + 1) * TemplateBuyPanelUI.ItemBG:GetSizeY() + 175)
  local panelSizeX = Panel_Cash_Customization_BuyItem:GetSizeX()
  local panelSizeY = Panel_Cash_Customization_BuyItem:GetSizeY()
  Panel_Cash_Customization_BuyItem:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Panel_Cash_Customization_BuyItem:SetPosY(scrSizeY / 2 - panelSizeY / 2)
  self.BTN_Confirm:ComputePos()
  self.BTN_Cancle:ComputePos()
end
function _ingameCustomization_CheckBuff()
  local self = CashCustomization
  local selfPlayer = getSelfPlayer()
  local customizationPackageTime = selfPlayer:get():isApplyChargeSkill(UI_BUFFTYPE.eUserChargeType_CustomizationPackage)
  if customizationPackageTime then
    self.isAble:SetShow(true)
  else
    self.isAble:SetShow(false)
  end
end
function _ingameCustomization_BuffTooltip(isShow)
  local self = CashCustomization
  if true == isShow then
    local selfPlayer = getSelfPlayer()
    local customizationPackageTime = selfPlayer:get():getUserChargeTime(UI_BUFFTYPE.eUserChargeType_CustomizationPackage)
    local uiControl = self.isAble
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_CASH_CUSTOMIZATION_BUFFTOOLTIP_NAME")
    local desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CASH_CUSTOMIZATION_BUFFTOOLTIP_DESC", "customizationPackageTime", convertStringFromDatetime(toInt64(0, customizationPackageTime)))
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function CashCustomization_Open()
  local self = CashCustomization
  _ingameCustomization_CheckBuff()
  self:Update()
  CashCustomization_SetPosition()
  Panel_Cash_Customization:SetShow(true)
  Panel_Cash_Customization:SetAlpha(0)
  audioPostEvent_SystemUi(1, 32)
  _AudioPostEvent_SystemUiForXBOX(1, 32)
  local myInvenMoney = getSelfPlayer():get():getCashInventory():getMoney_s64()
  self.PearlValue:SetText(makeDotMoney(myInvenMoney))
  UIAni.AlphaAnimation(1, Panel_Cash_Customization, 0, 0.2)
  if false == _ContentsGroup_RenewUI_Customization then
    historyTableRePosY(true)
  end
end
function CashCumaBuy_Open(applyType)
  local self = CashCumaBuy
  self:Update(applyType)
  CashCustomizationBuy_SetPosition()
  Panel_Cash_Customization_BuyItem:SetShow(true)
end
function CashCumaBuy_Close()
  local self = CashCumaBuy
  self.SelectedItemNo = -1
  for idx = 0, self.ItemUiMaxCount - 1 do
    local UiBase = self.ItemUiPOOL[idx]
    UiBase.ItemSelectBTN:SetCheck(false)
  end
  Panel_Cash_Customization_BuyItem:SetShow(false)
end
function HandleClicked_CashCustomization_Buy(itemId)
end
function HandleClicked_CashCustomization_Apply()
  local self = CashCumaBuy
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local invenSlotNo = 0
  local customizationPackageTime = selfPlayer:get():isApplyChargeSkill(UI_BUFFTYPE.eUserChargeType_CustomizationPackage)
  if customizationPackageTime then
    ToClient_InGameSaveCustomizationData(true, invenSlotNo, CppEnums.ItemWhereType.eCount)
    return
  end
  local isApplyingCustomizationFreeBuff = selfPlayer:get():isApplyingCustomizationFreeBuff()
  if isApplyingCustomizationFreeBuff then
    ToClient_InGameSaveCustomizationData(true, invenSlotNo, CppEnums.ItemWhereType.eCount)
    return
  end
  if 0 < ToClient_InventorySizeByProductCategory(CppEnums.ItemWhereType.eInventory, CppEnums.ItemProductCategory.eItemProductCategory_Customize) then
    if true == _ContentsGroup_RenewUI_Customization then
      CashCumaBuy_OpenForConsole()
    else
      CashCumaBuy_Open("inven")
    end
  elseif 0 < ToClient_InventorySizeByProductCategory(CppEnums.ItemWhereType.eCashInventory, CppEnums.ItemProductCategory.eItemProductCategory_Customize) then
    if true == _ContentsGroup_RenewUI_Customization then
      CashCumaBuy_OpenForConsole()
    else
      CashCumaBuy_Open("inven")
    end
  elseif true == _ContentsGroup_RenewUI_Customization then
    ToClient_InGameSaveCustomizationData(true, invenSlotNo, CppEnums.ItemWhereType.eCount)
  else
    CashCumaBuy_Open("purchase")
  end
end
function CashCumaBuy_OpenForConsole()
  local idx = 0
  CashCustomizationData = {}
  local invenItem
  for invenIdx = 0, ToClient_InventoryGetSize(CppEnums.ItemWhereType.eInventory) - 1 do
    invenItem = ToClient_GetInventoryItemByProductCategory(CppEnums.ItemWhereType.eInventory, CppEnums.ItemProductCategory.eItemProductCategory_Customize, invenIdx)
    if invenItem ~= nil then
      CashCustomizationData[idx] = {}
      CashCustomizationData[idx].name = invenItem:getStaticStatus():getName()
      CashCustomizationData[idx].slotNo = invenIdx
      CashCustomizationData[idx].itemWhereType = CppEnums.ItemWhereType.eInventory
      CashCustomizationData[idx].count = invenItem:get():getCount_s64()
      idx = idx + 1
    end
  end
  local cashInvenItem
  for cashInvenIdx = 0, ToClient_InventoryGetSize(CppEnums.ItemWhereType.eCashInventory) - 1 do
    cashInvenItem = ToClient_GetInventoryItemByProductCategory(CppEnums.ItemWhereType.eCashInventory, CppEnums.ItemProductCategory.eItemProductCategory_Customize, cashInvenIdx)
    if cashInvenItem ~= nil then
      CashCustomizationData[idx] = {}
      CashCustomizationData[idx].name = cashInvenItem:getStaticStatus():getName()
      CashCustomizationData[idx].slotNo = cashInvenIdx
      CashCustomizationData[idx].itemWhereType = CppEnums.ItemWhereType.eCashInventory
      CashCustomizationData[idx].count = cashInvenItem:get():getCount_s64()
      idx = idx + 1
    end
  end
  if idx < 1 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHATNEW_NO_HAVE_ITEM"))
    return
  end
  local function useConfirm()
    ToClient_InGameSaveCustomizationData(false, CashCustomizationData[0].slotNo, CashCustomizationData[0].itemWhereType)
  end
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_USEITEM_MESSAGEBOX_TITLE"),
    content = CashCustomizationData[0].name,
    functionYes = useConfirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function HandleClicked_CashCustomization_SelectItem(itemId)
  local self = CashCumaBuy
  self.SelectedItemNo = itemId
  for idx = 0, self.ItemUiMaxCount - 1 do
    local UiBase = self.ItemUiPOOL[idx]
    UiBase.ItemSelectBTN:SetCheck(false)
    if idx == itemId then
      UiBase.ItemSelectBTN:SetCheck(true)
    end
  end
end
function HandleClicked_CashCumaBuy_Confirm()
  local self = CashCumaBuy
  if -1 == self.SelectedItemNo then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CASH_CUSTOMIZATION_NOSELECT"))
    return
  end
  local msgTitle = PAGetString(Defines.StringSheet_GAME, "EXCHANGE_TEXT_STATE_FINAL_CHECK")
  local msgContent = ""
  if CashCumaBuy.ApplyType == "inven" then
    msgContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CASH_CUSTOMIZATION_MSGCONTENT_APPLY", "itemName", CashCustomizationData[self.SelectedItemNo].name)
  else
    msgContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CASH_CUSTOMIZATION_MSGCONTENT_BUY", "itemBuy", CashCustomizationData[self.SelectedItemNo].name)
  end
  local messageboxData = {
    title = msgTitle,
    content = msgContent,
    functionYes = ToClient_CashCumaBuy_Confirm_Do,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function ToClient_CashCumaBuy_Confirm_Do()
  local self = CashCumaBuy
  if CashCumaBuy.ApplyType == "inven" then
    ToClient_InGameSaveCustomizationData(false, CashCustomizationData[self.SelectedItemNo].slotNo, CashCustomizationData[self.SelectedItemNo].itemWhereType)
  elseif CashCumaBuy.ApplyType == "goods" then
    getIngameCashMall():requestBuyItem(CashCustomizationData[self.SelectedItemNo].productNo, 1, CashCustomizationData[self.SelectedItemNo].pearlPrice, CppEnums.BuyItemReqTrType.eBuyItemReqTrType_UiUpdate, toInt64(0, -1), 0, 0)
  elseif CashCumaBuy.ApplyType == "pearl" then
    getIngameCashMall():requestBuyItem(CashCustomizationData[self.SelectedItemNo].productNo, 1, CashCustomizationData[self.SelectedItemNo].cashPrice, CppEnums.BuyItemReqTrType.eBuyItemReqTrType_UiUpdate, toInt64(0, -1), 0, 0)
  else
    getIngameCashMall():requestBuyItem(CashCustomizationData[self.SelectedItemNo].productNo, 1, CashCustomizationData[self.SelectedItemNo].pearlPrice, CppEnums.BuyItemReqTrType.eBuyItemReqTrType_ImmediatelyUse, toInt64(0, -1), 0, 0)
  end
end
function CashCustomization:registEventHandler()
  self.BTN_Apply:addInputEvent("Mouse_LUp", "HandleClicked_CashCustomization_Apply()")
  self.BTN_Close:addInputEvent("Mouse_LUp", "IngameCustomize_Hide()")
  self.BTN_BuyGoods:addInputEvent("Mouse_LUp", "CashCumaBuy_Open('goods')")
  self.BTN_BuyPearl:addInputEvent("Mouse_LUp", "FGlobal_IngameCashShop_PearlCharge_Open()")
  self.isAble:addInputEvent("Mouse_On", "_ingameCustomization_BuffTooltip( true )")
  self.isAble:addInputEvent("Mouse_Out", "_ingameCustomization_BuffTooltip( false )")
end
function CashCustomization:registMessageHandler()
end
function CashCumaBuy:registEventHandler()
  self.BTN_Confirm:addInputEvent("Mouse_LUp", "HandleClicked_CashCumaBuy_Confirm()")
  self.BTN_Cancle:addInputEvent("Mouse_LUp", "CashCumaBuy_Close()")
end
function CashCumaBuy:registMessageHandler()
end
CashCustomization:Initialize()
CashCustomization:registEventHandler()
CashCustomization:registMessageHandler()
CashCumaBuy:registEventHandler()
CashCumaBuy:registMessageHandler()
function FromClient_NotifyCustomizingChange()
  local self = CashCustomization
  self:Update()
  CashCustomization_SetPosition()
  local myInvenMoney = getSelfPlayer():get():getCashInventory():getMoney_s64()
  self.PearlValue:SetText(makeDotMoney(myInvenMoney))
  CashCumaBuy_Close()
  _ingameCustomization_CheckBuff()
end
registerEvent("FromClient_NotifyCustomizingChange", "FromClient_NotifyCustomizingChange")

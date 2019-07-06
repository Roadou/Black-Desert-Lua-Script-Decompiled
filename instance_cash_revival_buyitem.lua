Instance_Cash_Revival_BuyItem:SetShow(false)
Instance_Cash_Revival_BuyItem:setGlassBackground(true)
Instance_Cash_Revival_BuyItem:ActiveMouseEventEffect(true)
local CashRevivalBuy = {
  bg = UI.getChildControl(Instance_Cash_Revival_BuyItem, "Static_BG"),
  bg_notify = UI.getChildControl(Instance_Cash_Revival_BuyItem, "Static_NotifyBG"),
  staticText_notify = UI.getChildControl(Instance_Cash_Revival_BuyItem, "StaticText_Notify"),
  BTN_Confirm = UI.getChildControl(Instance_Cash_Revival_BuyItem, "Button_Confirm"),
  BTN_Cancel = UI.getChildControl(Instance_Cash_Revival_BuyItem, "Button_Cancel"),
  ItemUiPOOL = {},
  ItemUiMaxCount = 0,
  ItemListRow = -1,
  SelectedItemNo = -1
}
local TemplateBuyPanelUI = {
  ItemBG = UI.getChildControl(Instance_Cash_Revival_BuyItem, "Template_Static_ItemBG"),
  ItemNameBG = UI.getChildControl(Instance_Cash_Revival_BuyItem, "Template_StaticText_ItemNameBG"),
  ItemName = UI.getChildControl(Instance_Cash_Revival_BuyItem, "Template_StaticText_ItemName"),
  ItemPeriod = UI.getChildControl(Instance_Cash_Revival_BuyItem, "Template_StaticText_Period"),
  ItemPrice = UI.getChildControl(Instance_Cash_Revival_BuyItem, "Template_StaticText_ItemPrice"),
  PearlIcon = UI.getChildControl(Instance_Cash_Revival_BuyItem, "Template_Static_PearlIcon"),
  BTN_ItemSelected = UI.getChildControl(Instance_Cash_Revival_BuyItem, "Template_RadioButton_SelectedItem")
}
local UI_color = Defines.Color
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local CashRevivalData = {}
local CashRevivalCount = 0
local _selectSpawnType = enRespawnType.respawnType_None
function CashRevivalBuy:Update()
  CashRevivalData = {}
  for idx, itemUi in pairs(self.ItemUiPOOL) do
    itemUi.ItemBG:SetShow(false)
  end
  CashRevivalDataCount = 0
  local idx = 0
  local cashInvenItem
  for cashInvenIdx = 0, ToClient_InventoryGetSize(CppEnums.ItemWhereType.eCashInventory) - 1 do
    cashInvenItem = ToClient_GetInventoryItemByProductCategory(CppEnums.ItemWhereType.eCashInventory, CppEnums.ItemProductCategory.eItemProductCategory_Revival, cashInvenIdx)
    if cashInvenItem ~= nil then
      CashRevivalData[idx] = {}
      CashRevivalData[idx].name = cashInvenItem:getStaticStatus():getName()
      CashRevivalData[idx].slotNo = cashInvenIdx
      CashRevivalData[idx].itemWhereType = CppEnums.ItemWhereType.eCashInventory
      CashRevivalData[idx].count = cashInvenItem:get():getCount_s64()
      if cashInvenItem:getExpirationDate():isIndefinite() then
        CashRevivalData[idx].expirationDate = nil
      else
        local timeValue = PATime(cashInvenItem:getExpirationDate():get_s64())
        local timeStr = tostring(timeValue:GetYear()) .. "." .. tostring(timeValue:GetMonth()) .. "." .. tostring(timeValue:GetDay())
        CashRevivalData[idx].expirationDate = timeStr
      end
      idx = idx + 1
    end
  end
  CashRevivalDataCount = #CashRevivalData + 1
  self.staticText_notify:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_Cash_Revival_BuyItem_UseAbleItem_Notify_Msg"))
  local slotStartX = 15
  local slotStartY = 110
  local slotGapX = 255
  local slotGapY = 75
  local slotCols = 2
  local slotRows = (CashRevivalDataCount - 1) / slotCols
  for itemIdx = 0, CashRevivalDataCount - 1 do
    if nil == self.ItemUiPOOL[itemIdx] then
      local tempSlot = {}
      local CreateItemBG = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Instance_Cash_Revival_BuyItem, "CashRevivalBuy_ItemBG_" .. itemIdx)
      CopyBaseProperty(TemplateBuyPanelUI.ItemBG, CreateItemBG)
      CreateItemBG:SetPosX(25)
      CreateItemBG:SetPosY(80)
      CreateItemBG:SetShow(false)
      tempSlot.ItemBG = CreateItemBG
      local CreateItemNameBG = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, CreateItemBG, "CashRevivalBuy_ItemNameBG_" .. itemIdx)
      CopyBaseProperty(TemplateBuyPanelUI.ItemNameBG, CreateItemNameBG)
      CreateItemNameBG:SetPosX(5)
      CreateItemNameBG:SetPosY(5)
      CreateItemNameBG:SetShow(true)
      tempSlot.ItemNameBG = CreateItemNameBG
      local CreateItemSelectBTN = UI.createControl(UI_PUCT.PA_UI_CONTROL_RADIOBUTTON, CreateItemBG, "CashRevivalBuy_ItemSelectBTN_" .. itemIdx)
      CopyBaseProperty(TemplateBuyPanelUI.BTN_ItemSelected, CreateItemSelectBTN)
      CreateItemSelectBTN:SetPosX(5)
      CreateItemSelectBTN:SetPosY(7)
      CreateItemSelectBTN:SetShow(true)
      tempSlot.ItemSelectBTN = CreateItemSelectBTN
      local CreateItemName = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreateItemBG, "CashRevivalBuy_ItemName_" .. itemIdx)
      CopyBaseProperty(TemplateBuyPanelUI.ItemName, CreateItemName)
      CreateItemName:SetPosX(20)
      CreateItemName:SetPosY(3)
      CreateItemName:SetShow(true)
      tempSlot.ItemName = CreateItemName
      local CreateItemPeriod = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreateItemBG, "CashRevivalBuy_ItemPeriod_" .. itemIdx)
      CopyBaseProperty(TemplateBuyPanelUI.ItemPeriod, CreateItemPeriod)
      CreateItemPeriod:SetPosX(10)
      CreateItemPeriod:SetPosY(35)
      CreateItemPeriod:SetShow(true)
      tempSlot.ItemPeriod = CreateItemPeriod
      local CreatePearlIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, CreateItemBG, "CashRevivalBuy_PearlIcon_" .. itemIdx)
      CopyBaseProperty(TemplateBuyPanelUI.PearlIcon, CreatePearlIcon)
      CreatePearlIcon:SetPosX(10)
      CreatePearlIcon:SetPosY(40)
      CreatePearlIcon:SetShow(true)
      tempSlot.PearlIcon = CreatePearlIcon
      local CreateItemPrice = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreateItemBG, "CashRevivalBuy_ItemPrice_" .. itemIdx)
      CopyBaseProperty(TemplateBuyPanelUI.ItemPrice, CreateItemPrice)
      CreateItemPrice:SetPosX(40)
      CreateItemPrice:SetPosY(35)
      CreateItemPrice:SetShow(true)
      tempSlot.ItemPrice = CreateItemPrice
      self.ItemUiPOOL[itemIdx] = tempSlot
      self.ItemUiMaxCount = self.ItemUiMaxCount + 1
    end
    local col = itemIdx % slotCols
    local row = math.floor(itemIdx / slotCols)
    local posX = slotStartX + slotGapX * col
    local posY = slotStartY + slotGapY * row
    self.ItemListRow = row
    local UiBase = self.ItemUiPOOL[itemIdx]
    UiBase.ItemBG:SetPosX(posX)
    UiBase.ItemBG:SetPosY(posY)
    UiBase.ItemBG:SetShow(true)
    UiBase.ItemName:SetFontColor(UI_color.C_FFE7E7E7)
    UiBase.ItemName:SetText(CashRevivalData[itemIdx].name .. "(" .. tostring(CashRevivalData[itemIdx].count) .. ")")
    UiBase.ItemPeriod:SetFontColor(UI_color.C_FF999999)
    if nil == CashRevivalData[itemIdx].expirationDate then
      UiBase.ItemPeriod:SetShow(false)
    else
      UiBase.ItemPeriod:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_Cash_Revival_BuyItem_ItemPeriod", "itemExpirationDate", CashRevivalData[itemIdx].expirationDate))
      UiBase.ItemPeriod:SetShow(true)
    end
    UiBase.PearlIcon:SetShow(false)
    UiBase.ItemPrice:SetShow(false)
    UiBase.ItemSelectBTN:addInputEvent("Mouse_LUp", "HandleClicked_CashRevival_SelectItem( " .. itemIdx .. " )")
    UiBase.ItemName:addInputEvent("Mouse_LUp", "HandleClicked_CashRevival_SelectItem( " .. itemIdx .. " )")
    UiBase.ItemNameBG:addInputEvent("Mouse_LUp", "HandleClicked_CashRevival_SelectItem( " .. itemIdx .. " )")
  end
  self.bg:SetSize(self.bg:GetSizeX(), self.bg_notify:GetSizeY() + 15 + (self.ItemListRow + 1) * (TemplateBuyPanelUI.ItemBG:GetSizeY() + 5))
end
function CashRevivalBuy_SetPosition()
  local self = CashRevivalBuy
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  Instance_Cash_Revival_BuyItem:SetSize(Instance_Cash_Revival_BuyItem:GetSizeX(), (self.ItemListRow + 1) * TemplateBuyPanelUI.ItemBG:GetSizeY() + 175)
  local panelSizeX = Instance_Cash_Revival_BuyItem:GetSizeX()
  local panelSizeY = Instance_Cash_Revival_BuyItem:GetSizeY()
  Instance_Cash_Revival_BuyItem:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Instance_Cash_Revival_BuyItem:SetPosY(scrSizeY / 2 - panelSizeY / 2)
  self.BTN_Confirm:ComputePos()
  self.BTN_Cancel:ComputePos()
end
function CashRevivalBuy_Open(respawnType)
  _selectSpawnType = respawnType
  local self = CashRevivalBuy
  CashRevivalBuy:Update()
  CashRevivalBuy_SetPosition()
  Instance_Cash_Revival_BuyItem:SetShow(true)
end
function CashRevivalBuy_Close()
  Instance_Cash_Revival_BuyItem:SetShow(false)
  Panel_Cash_Customization_BuyItem:SetShow(false)
end
function HandleClicked_CashRevival_SelectItem(itemId)
  local self = CashRevivalBuy
  self.SelectedItemNo = itemId
  for idx = 0, self.ItemUiMaxCount - 1 do
    local UiBase = self.ItemUiPOOL[idx]
    UiBase.ItemSelectBTN:SetCheck(false)
    if idx == itemId then
      UiBase.ItemSelectBTN:SetCheck(true)
    end
  end
end
function HandleClicked_Buy_CashRevivalItem(respawnType)
  _selectSpawnType = respawnType
  local self = CashRevivalBuy
  local msgTitle = PAGetString(Defines.StringSheet_GAME, "EXCHANGE_TEXT_STATE_FINAL_CHECK")
  local msgContent = ""
  local cPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(getRevivalItem())
  msgContent = PAGetStringParam2(Defines.StringSheet_GAME, "Lua_Cash_Revival_BuyItem_Confirm_RevialBuyPearl", "RevivalItemName", cPSSW:getName(), "PearlPrice", tostring(cPSSW:getPrice()))
  local messageboxData = {
    title = msgTitle,
    content = msgContent,
    functionYes = ToClient_Buy_CashRevivalBuy_Do,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function ToClient_Buy_CashRevivalBuy_Do()
  local cPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(getRevivalItem())
  getIngameCashMall():requestBuyItem(cPSSW:getNoRaw(), 1, cPSSW:getPrice(), CppEnums.BuyItemReqTrType.eBuyItemReqTrType_ImmediatelyUse, toInt64(0, -1), 0, 0)
end
function HandleClicked_Apply_CashRevivalItem(respawnType)
  _selectSpawnType = respawnType
  local self = CashRevivalBuy
  local msgTitle = PAGetString(Defines.StringSheet_GAME, "EXCHANGE_TEXT_STATE_FINAL_CHECK")
  local msgContent = ""
  local idx = 0
  self.SelectedItemNo = 0
  CashRevivalData = {}
  local cashInvenItem
  for cashInvenIdx = 0, ToClient_InventoryGetSize(CppEnums.ItemWhereType.eCashInventory) - 1 do
    cashInvenItem = ToClient_GetInventoryItemByProductCategory(CppEnums.ItemWhereType.eCashInventory, CppEnums.ItemProductCategory.eItemProductCategory_Revival, cashInvenIdx)
    if cashInvenItem ~= nil then
      CashRevivalData[idx] = {}
      CashRevivalData[idx].name = cashInvenItem:getStaticStatus():getName()
      CashRevivalData[idx].slotNo = cashInvenIdx
      CashRevivalData[idx].itemWhereType = CppEnums.ItemWhereType.eCashInventory
      CashRevivalData[idx].count = cashInvenItem:get():getCount_s64()
    end
  end
  msgContent = PAGetStringParam1(Defines.StringSheet_GAME, "Lua_Cash_Revival_BuyItem_Confirm_ThisItemApply", "cashItemName", CashRevivalData[self.SelectedItemNo].name)
  local messageboxData = {
    title = msgTitle,
    content = msgContent,
    functionYes = ToClient_CashRevivalBuy_Confirm_Do,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function HandleClicked_CashRevivalBuy_Confirm()
  local self = CashRevivalBuy
  if self.SelectedItemNo < 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ITEMSELECT_TEXT"))
    return
  end
  local msgTitle = PAGetString(Defines.StringSheet_GAME, "EXCHANGE_TEXT_STATE_FINAL_CHECK")
  local msgContent = ""
  msgContent = PAGetStringParam1(Defines.StringSheet_GAME, "Lua_Cash_Revival_BuyItem_Confirm_ThisItemApply", "cashItemName", CashRevivalData[self.SelectedItemNo].name)
  local messageboxData = {
    title = msgTitle,
    content = msgContent,
    functionYes = ToClient_CashRevivalBuy_Confirm_Do,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function ToClient_CashRevivalBuy_Confirm_Do()
  local self = CashRevivalBuy
  deadMessage_Revival(_selectSpawnType, CashRevivalData[self.SelectedItemNo].slotNo, CashRevivalData[self.SelectedItemNo].itemWhereType, getSelfPlayer():getRegionKey(), false, toInt64(0, 0))
  CashRevivalBuy_Close()
end
function FromClient_NotifyCacheRespawn()
  local self = CashRevivalBuy
  local msgTitle = PAGetString(Defines.StringSheet_GAME, "EXCHANGE_TEXT_STATE_FINAL_CHECK")
  local msgContent = ""
  local idx = 0
  self.SelectedItemNo = 0
  CashRevivalData = {}
  local cashInvenItem
  for cashInvenIdx = 0, ToClient_InventoryGetSize(CppEnums.ItemWhereType.eCashInventory) - 1 do
    cashInvenItem = ToClient_GetInventoryItemByProductCategory(CppEnums.ItemWhereType.eCashInventory, CppEnums.ItemProductCategory.eItemProductCategory_Revival, cashInvenIdx)
    if cashInvenItem ~= nil then
      CashRevivalData[idx] = {}
      CashRevivalData[idx].name = cashInvenItem:getStaticStatus():getName()
      CashRevivalData[idx].slotNo = cashInvenIdx
      CashRevivalData[idx].itemWhereType = CppEnums.ItemWhereType.eCashInventory
      CashRevivalData[idx].count = cashInvenItem:get():getCount_s64()
    end
  end
  ToClient_CashRevivalBuy_Confirm_Do()
end
function CashRevivalBuy:registEventHandler()
  self.BTN_Confirm:addInputEvent("Mouse_LUp", "HandleClicked_CashRevivalBuy_Confirm()")
  self.BTN_Cancel:addInputEvent("Mouse_LUp", "CashRevivalBuy_Close()")
end
CashRevivalBuy:registEventHandler()
registerEvent("FromClient_NotifyCacheRespawn", "FromClient_NotifyCacheRespawn")

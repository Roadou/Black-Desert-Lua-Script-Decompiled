Panel_Window_Extraction_Caphras:SetShow(false)
PaGlobal_Extraction_Caphras = {
  _ui = {
    _btn_Close = UI.getChildControl(Panel_Window_Extraction_Caphras, "Button_CloseIcon"),
    _btn_Puri = UI.getChildControl(Panel_Window_Extraction_Caphras, "Button_Extraction"),
    _bg_Main = UI.getChildControl(Panel_Window_Extraction_Caphras, "Static_Bg"),
    _bg_Bottom = UI.getChildControl(Panel_Window_Extraction_Caphras, "Static_BottomBg")
  },
  _fromWhereType = -1,
  _fromSlotNo = -1,
  _moneyWhereType = 0,
  _savedCount = 0,
  _resultWhereType = -1,
  _resultSlotNo = -1,
  _fromSlotOn = false,
  _resultSlotOn = false,
  _isAniStart = false,
  _const_ani_time = 3,
  _delta_ani_time = 0,
  _slotConfig = {
    createBorder = false,
    createCount = true,
    createCooltime = false,
    createCooltimeText = false,
    createCash = true,
    createEnchant = true,
    createQuickslotBagIcon = false
  }
}
function PaGlobal_Extraction_Caphras:SetPosition()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  if screenSizeY <= 800 then
    Panel_Window_Extraction_Caphras:SetPosY(screenSizeY / 2 - Panel_Window_Extraction_Caphras:GetSizeY() / 2)
  else
    Panel_Window_Extraction_Caphras:SetPosY(screenSizeY / 2 - Panel_Window_Extraction_Caphras:GetSizeY() / 2)
  end
  Panel_Window_Extraction_Caphras:SetPosX(screenSizeX / 2 - Panel_Window_Extraction_Caphras:GetSizeX() / 2)
end
function PaGlobal_Extraction_Caphras_Open()
  PaGlobal_Extraction_Caphras:Open()
end
function PaGlobal_Extraction_Caphras:Open()
  PaGlobal_Extraction_Caphras:Clear()
  warehouse_requestInfoFromNpc()
  Inventory_SetFunctor(PaGlobal_ExtractionCaphras_Filter, PaGlobal_ExtractionCaphras_RClick, PaGlobal_ExtractionCaphras_Close, nil)
  InventoryWindow_Show()
  self._ui._text_InvenMoney:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  self._ui._text_WareHouseMoney:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
  self._ui._radio_Inven:SetEnableArea(0, 0, self._ui._radio_Inven:GetTextSizeX() + 30, 25)
  self._ui._radio_Warehouse:SetEnableArea(0, 0, self._ui._radio_Warehouse:GetTextSizeX() + 30, 25)
  if false == Panel_Window_Extraction_Caphras:GetShow() then
    PaGlobal_Extraction_Caphras:SetPosition()
  end
  Panel_Window_Extraction_Caphras:SetShow(true)
end
function PaGlobal_Extraction_Caphras:Clear()
  self._fromSlotNo = -1
  self._fromWhereType = -1
  self._resultSlotNo = -1
  self._resultWhereType = -1
  self._fromSlotOn = false
  self._resultSlotOn = false
  self._ui._icon_items:clearItem()
  self._ui._icon_result:clearItem()
  self._ui._radio_Inven:SetCheck(true)
  self._ui._radio_Warehouse:SetCheck(false)
  self._moneyWhereType = 0
  self._delta_ani_time = 0
  self._isAniStart = false
  self._ui._btn_Puri:SetIgnore(false)
  self._ui._btn_Puri:SetMonoTone(false)
  Panel_Tooltip_Item_hideTooltip()
  self._ui._txt_ExtractionPrice:SetShow(false)
  self._ui._bg_itemSlot:EraseAllEffect()
  self._ui._bg_resultItemSlot:EraseAllEffect()
end
function PaGlobal_ExtractionCaphras_Close()
  PaGlobal_Extraction_Caphras:Close()
end
function PaGlobal_Extraction_Caphras:Close()
  self._ui._icon_items:clearItem()
  HandleClicked_InventoryWindow_Close()
  Panel_Window_Extraction_Caphras:SetShow(false)
end
function PaGlobal_Extraction_Caphras:ClickMoneyWhereType(isInventory)
  if true == isInventory then
    self._moneyWhereType = CppEnums.ItemWhereType.eInventory
  else
    self._moneyWhereType = CppEnums.ItemWhereType.eWarehouse
  end
end
function FromClient_ExtractionCaphras_EventWarehouseUpdate(value)
  local self = PaGlobal_Extraction_Caphras
  if true == Panel_Window_Extraction_Caphras:GetShow() then
    self._ui._text_WareHouseMoney:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
  end
end
function PaGlobal_Extraction_Caphras:Initialize()
  self._ui._bg_itemSlot = UI.getChildControl(self._ui._bg_Main, "Static_ItemSlotBg")
  self._ui._bg_resultItemSlot = UI.getChildControl(self._ui._bg_Main, "Static_ResultItemSlotBg")
  self._ui._bg_Deco = UI.getChildControl(self._ui._bg_Main, "Static_Deco")
  self._ui._txt_ExtractionPrice = UI.getChildControl(self._ui._bg_Main, "StaticText_ExtractionPrice")
  self._ui._radio_Inven = UI.getChildControl(self._ui._bg_Main, "RadioButton_InvenMoney")
  self._ui._text_InvenMoney = UI.getChildControl(self._ui._bg_Main, "StaticText_InvenMoney")
  self._ui._radio_Warehouse = UI.getChildControl(self._ui._bg_Main, "RadioButton_WarehouseMoney")
  self._ui._text_WareHouseMoney = UI.getChildControl(self._ui._bg_Main, "StaticText_WarehouseMoney")
  self._ui._radio_Inven:addInputEvent("Mouse_LUp", "PaGlobal_Extraction_Caphras:ClickMoneyWhereType(true)")
  self._ui._radio_Warehouse:addInputEvent("Mouse_LUp", "PaGlobal_Extraction_Caphras:ClickMoneyWhereType(false)")
  self._ui._btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_Extraction_Caphras:Close()")
  self._ui._btn_Puri:addInputEvent("Mouse_LUp", "PaGlobal_Extraction_Caphras:RequestPuri()")
  self._ui._icon_items = {}
  SlotItem.new(self._ui._icon_items, "feeItem", nil, self._ui._bg_itemSlot, self._slotConfig)
  self._ui._icon_items:createChild()
  self._ui._icon_items.icon:addInputEvent("Mouse_On", "PaGlobal_ExtractionCaphras_ShowToolTip(true)")
  self._ui._icon_items.icon:addInputEvent("Mouse_Out", "PaGlobal_ExtractionCaphras_ShowToolTip(false)")
  self._ui._icon_items.icon:addInputEvent("Mouse_RUp", "PaGlobal_Extraction_Caphras:ClearItemSlot()")
  self._ui._icon_items:clearItem()
  self._ui._icon_result = {}
  SlotItem.new(self._ui._icon_result, "resultItem", nil, self._ui._bg_resultItemSlot, self._slotConfig)
  self._ui._icon_result:createChild()
  self._ui._icon_result.icon:addInputEvent("Mouse_On", "PaGlobal_ExtractionCaphras_ResultShowToolTip(true)")
  self._ui._icon_result.icon:addInputEvent("Mouse_Out", "PaGlobal_ExtractionCaphras_ResultShowToolTip(false)")
  self._ui._icon_result:clearItem()
  self._ui._text_desc = UI.getChildControl(self._ui._bg_Bottom, "StaticText_Desc")
  self._ui._text_desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._text_desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CAPHRAS_DESC"))
  local prevSizeY = self._ui._bg_Bottom:GetSizeY()
  local textSizeY = self._ui._text_desc:GetTextSizeY()
  self._ui._bg_Bottom:SetSize(self._ui._bg_Bottom:GetSizeX(), textSizeY + 15)
  if prevSizeY < textSizeY then
    Panel_Window_Extraction_Caphras:SetSize(Panel_Window_Extraction_Caphras:GetSizeX(), Panel_Window_Extraction_Caphras:GetSizeY() + textSizeY - prevSizeY + 10)
    self._ui._text_desc:ComputePos()
  end
  self._ui._txt_ExtractionPrice:SetShow(false)
  registerEvent("EventWarehouseUpdate", "FromClient_ExtractionCaphras_EventWarehouseUpdate")
  registerEvent("FromClient_ExtracCaphrasItem", "FromClient_ExtracCaphrasItem")
  Panel_Window_Extraction_Caphras:RegisterUpdateFunc("Update_RequestAni_Caphras")
end
function Update_RequestAni_Caphras(delta)
  local self = PaGlobal_Extraction_Caphras
  if false == self._isAniStart then
    return
  end
  self._delta_ani_time = self._delta_ani_time + delta
  if self._const_ani_time < self._delta_ani_time then
    self._delta_ani_time = 0
    local itemWrapper = getInventoryItemByType(0, self._fromSlotNo)
    if nil ~= itemWrapper then
      local isCaphrasPrice = itemWrapper:getExtractCaphrasPrice()
      ToClient_ExtractCaphras(0, self._fromSlotNo, self._moneyWhereType, 0, isCaphrasPrice)
    end
    self._ui._btn_Puri:SetIgnore(false)
    self._ui._btn_Puri:SetMonoTone(false)
    self._resultSlotNo = self._fromSlotNo
    self._resultWhereType = self._fromWhereType
    self._isAniStart = false
  end
end
function PaGlobal_Extraction_Caphras:RequestPuri()
  if self._fromSlotNo < 0 or 0 > self._fromWhereType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTIONCAPHRAS_TARGET_EMPTY"))
    return
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTIONCAPHRAS_ALERT"),
    functionYes = function()
      self._delta_ani_time = 0
      self._isAniStart = true
      self._ui._bg_itemSlot:AddEffect("fUI_Purification_01B", false, 0, 0)
      self._ui._bg_resultItemSlot:AddEffect("fUI_Purification_02B", false, 0, 0)
      self._ui._btn_Puri:SetIgnore(true)
      self._ui._btn_Puri:SetMonoTone(true)
      audioPostEvent_SystemUi(5, 17)
    end,
    functionNo = function()
    end,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_Extraction_Caphras:ClearItemSlot()
  if true == self._isAniStart then
    return
  end
  self._fromSlotNo = -1
  self._fromWhereType = -1
  self._fromSlotOn = false
  self._ui._icon_items:clearItem()
  if false == self._resultSlotOn then
    self._ui._icon_result:clearItem()
  end
  self._ui._txt_ExtractionPrice:SetShow(false)
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_ExtractionCaphras_RClick(slotNo, itemWrapper, count, invenType)
  local self = PaGlobal_Extraction_Caphras
  if nil == itemWrapper then
    return
  end
  local tempKey = itemWrapper:get():getKey()
  local staticStatus = itemWrapper:getStaticStatus()
  local isCaphrasCount = itemWrapper:getExtractCaphrasCount()
  local isCaphrasPrice = itemWrapper:getExtractCaphrasPrice()
  if nil == staticStatus then
    return
  end
  if true == self._isAniStart then
    return
  end
  self._ui._icon_items:setItemByStaticStatus(staticStatus, Defines.s64_const.s64_1)
  if toInt64(0, 0) == isCaphrasCount then
    isCaphrasCount = toInt64(0, 1)
  end
  self._savedCount = isCaphrasCount
  self._fromSlotNo = slotNo
  self._fromWhereType = invenType
  self._fromSlotOn = true
  self._resultSlotOn = false
  self._resultSlotNo = -1
  self._resultWhereType = -1
  local prevStatic = getItemEnchantStaticStatus(ItemEnchantKey(721003))
  self._ui._icon_result:clearItem()
  if prevStatic ~= nil then
    self._ui._icon_result:setItemByStaticStatus(prevStatic, isCaphrasCount)
    self._ui._txt_ExtractionPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXTRACTIONCAPHRAS_VIEW_PRICE", "price", makeDotMoney(isCaphrasPrice)))
    self._ui._txt_ExtractionPrice:SetShow(true)
  end
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_ExtractionCaphras_Filter(slotNo, notUse_itemWrappers, whereType)
  local self = PaGlobal_Extraction_Caphras
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  local equipSlotNo = itemWrapper:getStaticStatus():getEquipSlotNo()
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  local isCaphras = itemWrapper:isExtractionCaphras()
  if isCaphras then
    return false
  else
    return true
  end
end
function PaGlobal_ExtractionCaphras_ShowToolTip(isShow)
  local self = PaGlobal_Extraction_Caphras
  if false == self._fromSlotOn then
    return
  end
  local itemWrapper = getInventoryItemByType(self._fromWhereType, self._fromSlotNo)
  if true == isShow then
    Panel_Tooltip_Item_SetPosition(0, self._ui._bg_itemSlot, "Purification")
    Panel_Tooltip_Item_Show(itemWrapper, Panel_Window_Extraction_Caphras, false, true, nil)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function PaGlobal_ExtractionCaphras_ResultShowToolTip(isShow)
  local self = PaGlobal_Extraction_Caphras
  if false == self._resultSlotOn then
    return
  end
  local itemWrapper = getInventoryItemByType(self._resultWhereType, self._resultSlotNo)
  if true == isShow then
    Panel_Tooltip_Item_SetPosition(0, self._ui._bg_resultItemSlot, "Purification")
    Panel_Tooltip_Item_Show(itemWrapper, Panel_Window_Extraction_Caphras, false, true, nil)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function FromClient_ExtracCaphrasItem(whereType, slotNo, variedCount, isSuccess)
  if nil == getSelfPlayer() then
    return
  end
  local self = PaGlobal_Extraction_Caphras
  if isSuccess then
    local itemWrapper = getInventoryItemByType(whereType, slotNo)
    if nil == itemWrapper then
      return
    end
    self._ui._text_InvenMoney:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
    self._ui._text_WareHouseMoney:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXTRACTIONCAPHRAS_EXTRACTION_COUNT_ACK", "count", tostring(self._savedCount)))
    PaGlobal_Extraction_Caphras:Clear()
    Inventory_SetFunctor(PaGlobal_ExtractionCaphras_Filter, PaGlobal_ExtractionCaphras_RClick, PaGlobal_ExtractionCaphras_Close, nil)
    self._ui._txt_ExtractionPrice:SetShow(false)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CAPHRAS_FAILED_ACK"))
    PaGlobal_Extraction_Caphras:Clear()
  end
end
PaGlobal_Extraction_Caphras:Initialize()

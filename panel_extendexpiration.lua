Panel_ExtendExpiration:SetShow(false)
local ExtendExpiration = {
  ui = {
    _txt_Guide = UI.getChildControl(Panel_ExtendExpiration, "Static_GuideText"),
    _static_Effect = UI.getChildControl(Panel_ExtendExpiration, "Static_Effect"),
    _static_materialSlot = UI.getChildControl(Panel_ExtendExpiration, "Static_Slot_0"),
    _static_Slot = UI.getChildControl(Panel_ExtendExpiration, "Static_Slot_1"),
    _desc = UI.getChildControl(Panel_ExtendExpiration, "Static_GuideText"),
    _btn_materialPlus = UI.getChildControl(Panel_ExtendExpiration, "Button_CountPlus"),
    _btn_materialMinus = UI.getChildControl(Panel_ExtendExpiration, "Button_CountMinus"),
    _btn_Confirm = UI.getChildControl(Panel_ExtendExpiration, "Button_Confirm"),
    _btn_Cancel = UI.getChildControl(Panel_ExtendExpiration, "Button_Cancel"),
    _btn_Close = UI.getChildControl(Panel_ExtendExpiration, "Button_Win_Close"),
    _btn_Question = UI.getChildControl(Panel_ExtendExpiration, "Button_Question"),
    material = {},
    item = {}
  },
  config = {
    materialWhereType = 0,
    materialSlotNo = 0,
    materialCount = toInt64(0, 0),
    materialMaxCount = toInt64(0, 0),
    materialExtendExpirationType = 0,
    targetWhereType = 0,
    targetSlotNo = 0,
    isSetItem = false,
    extendExpirationDo = false
  },
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createCash = true,
    createExpiration = true
  },
  materialSlotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createCash = true,
    createExpiration = false
  }
}
function ExtendExpiration:Init()
  SlotItem.new(self.ui.material, "ExtendExpirationmaterialItem_" .. 0, 0, self.ui._static_materialSlot, self.materialSlotConfig)
  self.ui.material:createChild()
  SlotItem.new(self.ui.item, "ExtendExpirationItem_" .. 0, 0, self.ui._static_Slot, self.slotConfig)
  self.ui.item:createChild()
  self.ui._desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self.ui._desc:SetText(self.ui._desc:GetText())
  if 30 < self.ui._desc:GetTextSizeY() then
    self.ui._desc:SetSize(self.ui._desc:GetSizeX(), self.ui._desc:GetTextSizeY() + 10)
  else
    self.ui._desc:SetSize(self.ui._desc:GetSizeX(), 30)
  end
  self.ui._btn_Question:SetShow(false)
end
function ExtendExpiration:registEventHandler()
  self.ui.item.icon:addInputEvent("Mouse_RUp", "HandleClicked_ExtendExpiration_UnSetItem()")
  self.ui._btn_materialPlus:addInputEvent("Mouse_LUp", "HandleClicked_ExtendExpiration_ChangeMaterialCount( true )")
  self.ui._btn_materialMinus:addInputEvent("Mouse_LUp", "HandleClicked_ExtendExpiration_ChangeMaterialCount( false )")
  self.ui._btn_Confirm:addInputEvent("Mouse_LUp", "HandleClicked_ExtendExpiration_Do()")
  self.ui._btn_Cancel:addInputEvent("Mouse_LUp", "HandleClicked_ExtendExpiration_Close()")
  self.ui._btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_ExtendExpiration_Close()")
end
function ExtendExpiration:registMessageHandler()
  if false == _ContentsGroup_RenewUI then
    registerEvent("FromClient_ClickedExtendExpirationPeriodMaterial", "FromClient_ClickedExtendExpirationPeriodMaterial")
  end
  registerEvent("FromClient_SucceedExtendedExpirationPeriod", "FromClient_SucceedExtendedExpirationPeriod")
  Panel_ExtendExpiration:RegisterUpdateFunc("ExtendExpiration_TimeChecker")
end
function ExtendExpiration:Close()
  Panel_ExtendExpiration:SetShow(false)
  ExtendExpiration.config.materialWhereType = 0
  ExtendExpiration.config.materialSlotNo = 0
  ExtendExpiration.config.materialCount = toInt64(0, 0)
  ExtendExpiration.config.materialMaxCount = toInt64(0, 0)
  ExtendExpiration.config.materialExtendExpirationType = 0
  ExtendExpiration.config.isSetItem = false
  ExtendExpiration.config.targetWhereType = 0
  ExtendExpiration.config.targetSlotNo = 0
  ExtendExpiration.config.extendExpirationDo = false
  ExtendExpiration.ui.material:clearItem()
  ExtendExpiration.ui.item:clearItem()
  Inventory_SetFunctor(nil, nil, nil, nil)
  if false == _ContentsGroup_RenewUI then
    Equipment_SetShow(true)
  end
end
function ExtendExpiration_Inventory_Filter(slotNo, itemWrapper, currentWhereType)
  local itemSSW = itemWrapper:getStaticStatus()
  local isExtendedExpiration = itemSSW:isExtendedExpirationPeriod()
  local extendExpirationType = itemSSW:getExtendExpirationPeriodType()
  local isMatchType = ExtendExpiration.config.materialExtendExpirationType == extendExpirationType
  if isExtendedExpiration and isMatchType then
    return false
  else
    return true
  end
end
local function _ExtendExpiration_Inventory_Rclick()
  local itemWrapper = getInventoryItemByType(ExtendExpiration.config.targetWhereType, ExtendExpiration.config.targetSlotNo)
  ExtendExpiration.ui.item:setItem(itemWrapper)
  ExtendExpiration.config.isSetItem = true
end
function ExtendExpiration_Inventory_Rclick(slotNo, itemWrapper, count_s64, inventoryType)
  ExtendExpiration.config.targetWhereType = inventoryType
  ExtendExpiration.config.targetSlotNo = slotNo
  local materialItemWrapper = getInventoryItemByType(ExtendExpiration.config.materialWhereType, ExtendExpiration.config.materialSlotNo)
  local materialItemSSW = materialItemWrapper:getStaticStatus()
  local materialItemEnchantKey = ItemEnchantKey(materialItemWrapper:get():getKey():get())
  local targetItemWrapper = getInventoryItemByType(inventoryType, slotNo)
  ExtendExpiration.config.materialMaxCount = targetItemWrapper:getMaxUsableExtendedExpirationMaterialCount(materialItemEnchantKey)
  local isOverExtendedExpiration = targetItemWrapper:isOverExtendedExpirationPeriod(materialItemEnchantKey, ExtendExpiration.config.materialMaxCount)
  if true == isOverExtendedExpiration then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_EXTENDEXPIRATION_DONT_OVERPERIOD")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = _ExtendExpiration_Inventory_Rclick,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    _ExtendExpiration_Inventory_Rclick()
  end
end
function ExtendExpiration_Close()
  ExtendExpiration:Close()
end
function HandleClicked_ExtendExpiration_Close()
  ExtendExpiration:Close()
end
function HandleClicked_ExtendExpiration_UnSetItem()
  ExtendExpiration.config.targetWhereType = 0
  ExtendExpiration.config.targetSlotNo = 0
  ExtendExpiration.config.isSetItem = false
  ExtendExpiration.ui.item:clearItem()
  Inventory_SetFunctor(ExtendExpiration_Inventory_Filter, ExtendExpiration_Inventory_Rclick, ExtendExpiration_Close, nil)
end
function HandleClicked_ExtendExpiration_ChangeMaterialCount(isPlus)
  if true ~= ExtendExpiration.config.isSetItem then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_EXTENDEXPIRATION_SELECTITEM"))
    return
  end
  local nowCount = ExtendExpiration.config.materialCount
  local maxCount = ExtendExpiration.config.materialMaxCount
  if isPlus then
    if nowCount >= maxCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_EXTENDEXPIRATION_EXPIRATION_MAX"))
      return
    end
    ExtendExpiration.config.materialCount = ExtendExpiration.config.materialCount + toInt64(0, 1)
  else
    if nowCount <= toInt64(0, 1) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_EXTENDEXPIRATION_EXPIRATION_MIN"))
      return
    end
    ExtendExpiration.config.materialCount = ExtendExpiration.config.materialCount - toInt64(0, 1)
  end
  ExtendExpiration.ui.material.count:SetText(tostring(ExtendExpiration.config.materialCount))
end
function HandleClicked_ExtendExpiration_Do()
  if ExtendExpiration.config.isSetItem then
    ExtendExpiration.config.extendExpirationDo = true
    ExtendExpiration.ui._static_Effect:EraseAllEffect()
    ExtendExpiration.ui._static_Effect:AddEffect("fUI_Dress_Extraction03", false, 0, 0)
  else
    return
  end
end
function FromClient_ClickedExtendExpirationPeriodMaterial(materialWhereType, materialSlotNo)
  local materialItemWrapper = getInventoryItemByType(materialWhereType, materialSlotNo)
  local materialItemSSW = materialItemWrapper:getStaticStatus()
  local function doitExtendExpiration()
    ExtendExpiration.ui.material:setItemByStaticStatus(materialItemSSW, toInt64(0, 1), nil, nil, nil)
    ExtendExpiration.config.materialWhereType = materialWhereType
    ExtendExpiration.config.materialSlotNo = materialSlotNo
    ExtendExpiration.config.materialCount = toInt64(0, 1)
    ExtendExpiration.config.materialExtendExpirationType = materialItemSSW:getExtendExpirationPeriodType()
    Panel_ExtendExpiration:SetShow(true)
    Panel_ExtendExpiration:ComputePos()
    Inventory_SetFunctor(ExtendExpiration_Inventory_Filter, ExtendExpiration_Inventory_Rclick, ExtendExpiration_Close, nil)
    local isStackable = materialItemSSW:isStackable()
    ExtendExpiration.ui._btn_materialMinus:SetShow(isStackable)
    ExtendExpiration.ui._btn_materialPlus:SetShow(isStackable)
  end
  doitExtendExpiration()
end
function FromClient_SucceedExtendedExpirationPeriod(targetWhereType, targetSlotNo)
  local targetItemWrapper = getInventoryItemByType(targetWhereType, targetSlotNo)
  if nil ~= targetItemWrapper then
    local targetItemName = targetItemWrapper:getStaticStatus():getName()
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXTENDEXPIRATION_SUCCEEDEXTENDPERIOD", "name", targetItemName))
  end
end
local elapsTime = 0
function ExtendExpiration_TimeChecker(deltaTime)
  if true == ExtendExpiration.config.isSetItem and true == ExtendExpiration.config.extendExpirationDo then
    elapsTime = elapsTime + deltaTime
    if elapsTime >= 2.5 then
      local targetWhereType = ExtendExpiration.config.targetWhereType
      local targetSlotNo = ExtendExpiration.config.targetSlotNo
      local materialWhereType = ExtendExpiration.config.materialWhereType
      local materialSlotNo = ExtendExpiration.config.materialSlotNo
      local materialCount = ExtendExpiration.config.materialCount
      ToClient_ExtendExpirationPeriod(targetWhereType, targetSlotNo, materialWhereType, materialSlotNo, materialCount)
      elapsTime = 0
      ExtendExpiration.ui._static_Effect:EraseAllEffect()
      ExtendExpiration_Close()
    end
  end
end
ExtendExpiration:Init()
ExtendExpiration:registEventHandler()
ExtendExpiration:registMessageHandler()

Panel_Window_ClothInventory:SetShow(false, false)
Panel_Window_ClothInventory:setMaskingChild(true)
Panel_Window_ClothInventory:ActiveMouseEventEffect(true)
Panel_Window_ClothInventory:setGlassBackground(true)
Panel_Window_ClothInventory:RegisterShowEventFunc(true, "ClothInventoryShowAni()")
Panel_Window_ClothInventory:RegisterShowEventFunc(false, "ClothInventoryHideAni()")
function ClothInventoryShowAni()
end
function ClothInventoryHideAni()
end
local clothInven = {
  textureBg = UI.getChildControl(Panel_Window_ClothInventory, "Static_BG"),
  slotBg = UI.getChildControl(Panel_Window_ClothInventory, "Static_Slot"),
  btnQuestion = UI.getChildControl(Panel_Window_ClothInventory, "Button_Question"),
  btnClose = UI.getChildControl(Panel_Window_ClothInventory, "Button_Close"),
  textTitle = UI.getChildControl(Panel_Window_ClothInventory, "StaticText_Title"),
  descBg = UI.getChildControl(Panel_Window_ClothInventory, "Static_DescBg"),
  desc = UI.getChildControl(Panel_Window_ClothInventory, "StaticText_Desc"),
  btnChangeAll = UI.getChildControl(Panel_Window_ClothInventory, "Button_ChangeAll"),
  config = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  bg = {},
  slot = {},
  bagSize = 0,
  fromWhereType = nil,
  fromSlotNo = nil,
  bagWhereType = nil,
  bagSlotNo = nil,
  inventoryBagType = nil
}
clothInven.btnQuestion:SetShow(false)
clothInven.desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
clothInven.desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CLOTHINVENTORY_DESC"))
function FromClient_ShowInventoryBag(bagType, bagSize, fromWhereType, fromSlotNo)
  local self = clothInven
  local _title = ""
  self.inventoryBagType = bagType
  if CppEnums.InventoryBagType.eInventoryBagType_Cash == bagType then
    bagType = CppEnums.ItemWhereType.eCashInventory
    _title = PAGetString(Defines.StringSheet_GAME, "LUA_CLOTHINVENTORY_PEARLTITLE")
    self.descBg:SetShow(true)
    self.desc:SetShow(true)
  elseif CppEnums.InventoryBagType.eInventoryBagType_Equipment == bagType then
    bagType = CppEnums.ItemWhereType.eInventory
    _title = PAGetString(Defines.StringSheet_GAME, "LUA_CLOTHINVENTORY_TITLE")
    self.descBg:SetShow(true)
    self.desc:SetShow(true)
  elseif CppEnums.InventoryBagType.eInventoryBagType_Misc == bagType then
    bagType = CppEnums.ItemWhereType.eInventory
    _title = PAGetString(Defines.StringSheet_GAME, "LUA_MISC_INVENTORY_TITLE")
    self.descBg:SetShow(false)
    self.desc:SetShow(false)
  elseif CppEnums.InventoryBagType.eInventoryBagType_MiscForCash == bagType then
    bagType = CppEnums.ItemWhereType.eCashInventory
    _title = PAGetString(Defines.StringSheet_GAME, "LUA_MISC_INVENTORY_FORPEARL_TITLE")
    self.descBg:SetShow(false)
    self.desc:SetShow(false)
  end
  self.textTitle:SetText(_title)
  self.bagWhereType = bagType
  for index = 0, bagSize - 1 do
    if nil == self.bg[index] then
      self.bg[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_ClothInventory, "ColothInventory_SlotBg_" .. index)
      CopyBaseProperty(self.slotBg, self.bg[index])
      self.bg[index]:SetPosX(25 + index % 4 * 50)
      self.bg[index]:SetPosY(60 + math.floor(index / 4) * 50)
      self.bg[index]:SetShow(true)
      if nil == self.slot[index] then
        self.slot[index] = {}
        SlotItem.new(self.slot[index], "ClothInventory_", index, self.bg[index], self.config)
        self.slot[index]:createChild()
      end
    end
    local itemWrapper = getInventoryBagItemByType(fromWhereType, fromSlotNo, index)
    if nil ~= itemWrapper then
      self.slot[index]:setItem(itemWrapper, index)
      self.slot[index].icon:addInputEvent("Mouse_On", "ShowTooltip_ClothInven(" .. fromWhereType .. ", " .. fromSlotNo .. ", " .. index .. ")")
      self.slot[index].icon:addInputEvent("Mouse_Out", "ShowTooltip_ClothInven()")
      self.slot[index].icon:addInputEvent("Mouse_RUp", "ClothInven_HandleInventoryBagSlotRClick(" .. fromWhereType .. ", " .. fromSlotNo .. ", " .. index .. ", " .. bagType .. ")")
    else
      self.slot[index]:clearItem()
      self.slot[index].icon:removeInputEvent("Mouse_On")
      self.slot[index].icon:removeInputEvent("Mouse_Out")
      self.slot[index].icon:removeInputEvent("Mouse_RUp")
    end
  end
  for bgIndex, bg in ipairs(self.bg) do
    bg:SetShow(bgIndex < bagSize)
  end
  for slotIndex, slot in ipairs(self.slot) do
    slot.icon:SetShow(slotIndex < bagSize)
  end
  self.textureBg:SetSize(self.textureBg:GetSizeX(), math.ceil(bagSize / 4) * 45 + (math.ceil(bagSize / 4) - 1) * 5 + 10)
  self.descBg:SetSize(self.descBg:GetSizeX(), self.desc:GetTextSizeY() + 15)
  self.descBg:SetPosY(self.textureBg:GetPosY() + self.textureBg:GetSizeY() + 5)
  self.desc:SetPosY(self.descBg:GetPosY() + 5)
  if self.descBg:GetShow() then
    Panel_Window_ClothInventory:SetSize(Panel_Window_ClothInventory:GetSizeX(), self.descBg:GetPosY() + self.desc:GetTextSizeY() + 60)
  else
    Panel_Window_ClothInventory:SetSize(Panel_Window_ClothInventory:GetSizeX(), self.textureBg:GetPosY() + self.textureBg:GetSizeY() + 60)
  end
  local useChangeAllButton = self.inventoryBagType == CppEnums.InventoryBagType.eInventoryBagType_Equipment or self.inventoryBagType == CppEnums.InventoryBagType.eInventoryBagType_Cash
  self.btnChangeAll:SetShow(useChangeAllButton)
  if not useChangeAllButton then
    Panel_Window_ClothInventory:SetSize(Panel_Window_ClothInventory:GetSizeX(), Panel_Window_ClothInventory:GetSizeY() - self.btnChangeAll:GetSizeY())
  end
  self.btnChangeAll:ComputePos()
  Panel_Window_ClothInventory:SetPosX(Panel_Window_Inventory:GetPosX() - Panel_Window_ClothInventory:GetSizeX())
  Panel_Window_ClothInventory:SetPosY(Panel_Window_Inventory:GetPosY() + 80)
  Panel_Window_ClothInventory:SetShow(true, true)
  self.bagSize = bagSize
  self.fromWhereType = fromWhereType
  self.fromSlotNo = fromSlotNo
  Inventory_SetFunctor(ClothInven_Filter, ClothInven_HandleInventorySlotRClick, nil, nil)
  Panel_Tooltip_Item_hideTooltip()
end
function ClothInven_ChangeItem()
  if not Panel_Window_ClothInventory:GetShow() then
    return
  end
  local self = clothInven
  for index = 0, self.bagSize - 1 do
    self.slot[index]:clearItem()
    local itemWrapper = getInventoryBagItemByType(self.fromWhereType, self.fromSlotNo, index)
    if nil ~= itemWrapper then
      self.slot[index]:setItem(itemWrapper, index)
      self.slot[index].icon:addInputEvent("Mouse_On", "ShowTooltip_ClothInven(" .. self.fromWhereType .. ", " .. self.fromSlotNo .. ", " .. index .. ")")
      self.slot[index].icon:addInputEvent("Mouse_Out", "ShowTooltip_ClothInven()")
      self.slot[index].icon:addInputEvent("Mouse_RUp", "ClothInven_HandleInventoryBagSlotRClick(" .. self.fromWhereType .. ", " .. self.fromSlotNo .. ", " .. index .. ", " .. self.bagWhereType .. ")")
    else
      self.slot[index]:clearItem()
      self.slot[index].icon:removeInputEvent("Mouse_On")
      self.slot[index].icon:removeInputEvent("Mouse_Out")
      self.slot[index].icon:removeInputEvent("Mouse_RUp")
    end
  end
  FGlobal_UpdateInventoryWeight()
end
function ClothInven_Filter(slotNo, itemWrapper, count, inventoryType)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return true
  end
  local self = clothInven
  local itemSSW = itemWrapper:getStaticStatus()
  if not itemSSW:get():checkToPushToInventoryBag() then
    return true
  end
  if CppEnums.InventoryBagType.eInventoryBagType_Misc == self.inventoryBagType and false == itemSSW:isUserVested() and true == itemWrapper:get():isVested() then
    return true
  end
  if not ToClient_CheckToPushToInventoryBag(self.fromWhereType, self.fromSlotNo, self.fromWhereType, slotNo) then
    return true
  end
  if self.inventoryBagType == CppEnums.InventoryBagType.eInventoryBagType_Misc or self.inventoryBagType == CppEnums.InventoryBagType.eInventoryBagType_MiscForCash then
    return false
  end
  local myClass = selfPlayer:getClassType()
  local isEuqipItem = itemSSW:isEquipable()
  local isUsableItem = itemSSW:get()._usableClassType:isOn(myClass)
  local isPushableItem = itemWrapper:isPushableInventoryBag()
  if isEuqipItem and isUsableItem and isPushableItem then
    return false
  end
  return true
end
function ClothInven_HandleInventorySlotRClick(slotNo, itemWrapper, count, inventoryType)
  local itemStatic = itemWrapper:getStaticStatus()
  if not itemStatic:get():checkToPushToInventoryBag() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CLOTHINVENTORY_INPUTALERT"))
    return
  end
  local itemCount = itemWrapper:get():getCount_s64()
  local useNumberPad = itemStatic:isStackable() and Int64toInt32(itemCount) > 1
  if useNumberPad then
    Panel_NumberPad_Show(true, itemCount, nil, function(inputNumber)
      ToClient_ReqPushInventoryItemToInventoryBag(inventoryType, slotNo, clothInven.fromWhereType, clothInven.fromSlotNo, inputNumber)
    end)
  else
    ToClient_ReqPushInventoryItemToInventoryBag(inventoryType, slotNo, clothInven.fromWhereType, clothInven.fromSlotNo, 1)
  end
end
function ClothInven_HandleInventoryBagSlotRClick(fromWhereType, fromSlotNo, bagIndex, bagWhereType)
  local itemWrapper = getInventoryBagItemByType(fromWhereType, fromSlotNo, bagIndex)
  if not itemWrapper then
    return
  end
  local itemCount = itemWrapper:get():getCount_s64()
  local useNumberPad = itemWrapper:getStaticStatus():isStackable() and Int64toInt32(itemCount) > 1
  if useNumberPad then
    Panel_NumberPad_Show(true, itemCount, nil, function(inputNumber)
      ToClient_ReqPopInventoryBagItemToInventory(fromWhereType, fromSlotNo, bagIndex, bagWhereType, inputNumber)
    end)
  else
    ToClient_ReqPopInventoryBagItemToInventory(fromWhereType, fromSlotNo, bagIndex, bagWhereType, 1)
  end
end
function ClothInven_ChangeAllItem()
  ToClient_ReqEquipItemFromInventoryBag(clothInven.fromWhereType, clothInven.fromSlotNo)
end
function ShowTooltip_ClothInven(fromWhereType, fromSlotNo, index)
  if nil == fromWhereType then
    Panel_Tooltip_Item_hideTooltip()
    return
  end
  local itemWrapper = getInventoryBagItemByType(fromWhereType, fromSlotNo, index)
  local itemNo = getInventoryBagItemNoByType(fromWhereType, fromSlotNo, index)
  if nil ~= itemWrapper then
    Panel_Tooltip_Item_Show(itemWrapper, clothInven.slot[index].icon, false, true, nil, nil, nil, nil, "InventoryBag", itemNo)
  end
end
function ClothInventory_Close()
  if Panel_Window_ClothInventory:GetShow() then
    Panel_Window_ClothInventory:SetShow(false, false)
    Inventory_SetFunctor()
  end
end
clothInven.btnClose:addInputEvent("Mouse_LUp", "ClothInventory_Close()")
clothInven.btnChangeAll:addInputEvent("Mouse_LUp", "ClothInven_ChangeAllItem()")
registerEvent("FromClient_ShowInventoryBag", "FromClient_ShowInventoryBag")
registerEvent("FromClient_UpdateInventoryBag", "ClothInven_ChangeItem")
registerEvent("EventEquipItem", "ClothInven_ChangeItem")
registerEvent("EventUnEquipItemToInventory", "ClothInven_ChangeItem")

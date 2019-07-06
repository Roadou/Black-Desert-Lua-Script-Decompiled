local _panel = Instance_Widget_BetterEquipment
local UI_color = Defines.Color
local BetterEquipment = {
  _ui = {
    stc_slotBG = UI.getChildControl(_panel, "Static_SlotBG"),
    desc = UI.getChildControl(_panel, "StaticText_Desc"),
    stc_title = UI.getChildControl(_panel, "StaticText_Title"),
    stc_bgList = nil,
    stc_baseList = nil,
    txt_nameList = nil,
    stc_iconList = nil,
    slot_effect = {}
  },
  _panelSize = {
    sizeX = 350,
    siezY = 45,
    slotSize = 42,
    txtSizeX = 280,
    txtSizeY = 20,
    txtSpanX = 55,
    txtSpanY = 0
  },
  _maxEquipCount = 7,
  _betterEquipList = nil
}
function BetterEquipment:open()
  _panel:SetShow(true)
end
function BetterEquipment:close()
  _panel:SetShow(false)
end
function BetterEquipment:initialize()
  local self = BetterEquipment
  local slotConfig = {
    createIcon = true,
    createBorder = false,
    createCount = true,
    createClassEquipBG = true,
    createCash = true
  }
  self._ui.stc_bgList = {}
  self._ui.stc_baseList = {}
  self._ui.txt_nameList = {}
  self._ui.stc_iconList = {}
  self._ui.stc_titleDesc = UI.getChildControl(self._ui.stc_title, "StaticText_TitleDesc")
  for index = 1, self._maxEquipCount do
    self._ui.stc_bgList[index] = UI.cloneControl(self._ui.stc_slotBG, _panel, "Static_SlotBG_" .. index)
    self._ui.stc_baseList[index] = UI.getChildControl(self._ui.stc_bgList[index], "Static_Base")
    self._ui.txt_nameList[index] = UI.getChildControl(self._ui.stc_bgList[index], "StaticText_ItemName")
    self._ui.txt_nameList[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui.stc_bgList[index]:SetPosY(index * 51)
    self._ui.stc_bgList[index]:SetShow(true)
    local slot = {}
    SlotItem.new(slot, "slotIcon_" .. index, index, self._ui.stc_bgList[index], slotConfig)
    slot:createChild()
    self._ui.stc_iconList[index] = slot
    Panel_Tooltip_Item_SetPosition(index, slot, "betterItemList")
  end
  local leftPos = self._ui.desc:GetPosX() + self._ui.desc:GetTextSizeX()
  local rightPos = self._ui.stc_titleDesc:GetPosX() - 50
  if leftPos > rightPos then
    local distance = leftPos - rightPos
    local totalSize = self._ui.stc_title:GetSizeX() + distance
    self._ui.stc_title:SetSize(totalSize, self._ui.stc_title:GetSizeY())
    self._ui.stc_titleDesc:SetPosX(self._ui.stc_titleDesc:GetPosX() + distance)
  end
  self:close()
end
function BetterEquipment:registerEventHandler()
  registerEvent("FromClient_InventoryUpdate", "FromClient_InventoryUpdate_BetterEquipment")
end
function PaGlobalFunc_GetAccesoryWorseEquipment_Key(itemWrapper)
  local equipType = itemWrapper:getStaticStatus():getEquipType()
  local firstEquipOffence = 0
  local firstEquipDeffence = 0
  local secondEquipOffence = 0
  local secondEquipDeffence = 0
  local acc
  if 16 == equipType then
    equipItemWrapper = ToClient_getEquipmentItem(8)
    if nil ~= equipItemWrapper then
      firstEquipOffence = (equipItemWrapper:getStaticStatus():getMinDamage(0) + equipItemWrapper:getStaticStatus():getMaxDamage(0)) / 2
      firstEquipDeffence = equipItemWrapper:getStaticStatus():getDefence()
    end
    equipItemWrapper2 = ToClient_getEquipmentItem(9)
    if nil ~= equipItemWrapper2 then
      secondEquipOffence = (equipItemWrapper2:getStaticStatus():getMinDamage(0) + equipItemWrapper2:getStaticStatus():getMaxDamage(0)) / 2
      secondEquipDeffence = equipItemWrapper2:getStaticStatus():getDefence()
    end
    if nil ~= equipItemWrapper and nil ~= equipItemWrapper2 then
      local firstEquipStat = firstEquipOffence + firstEquipDeffence
      local secondEquipStat = secondEquipOffence + secondEquipDeffence
      if firstEquipStat > secondEquipStat then
        acc = 9
      else
        acc = 8
      end
    elseif nil == equipItemWrapper and nil ~= equipItemWrapper2 then
      acc = 8
    elseif nil ~= equipItemWrapper and nil == equipItemWrapper2 then
      acc = 9
    else
      acc = 8
    end
  elseif 17 == equipType then
    equipItemWrapper = ToClient_getEquipmentItem(10)
    if nil ~= equipItemWrapper then
      firstEquipOffence = (equipItemWrapper:getStaticStatus():getMinDamage(0) + equipItemWrapper:getStaticStatus():getMaxDamage(0)) / 2
      firstEquipDeffence = equipItemWrapper:getStaticStatus():getDefence()
    end
    equipItemWrapper2 = ToClient_getEquipmentItem(11)
    if nil ~= equipItemWrapper2 then
      secondEquipOffence = (equipItemWrapper2:getStaticStatus():getMinDamage(0) + equipItemWrapper2:getStaticStatus():getMaxDamage(0)) / 2
      secondEquipDeffence = equipItemWrapper2:getStaticStatus():getDefence()
    end
    if nil ~= equipItemWrapper and nil ~= equipItemWrapper2 then
      local firstEquipStat = firstEquipOffence + firstEquipDeffence
      local secondEquipStat = secondEquipOffence + secondEquipDeffence
      if firstEquipStat > secondEquipStat then
        acc = 11
      else
        acc = 10
      end
    elseif nil == equipItemWrapper and nil ~= equipItemWrapper2 then
      acc = 10
    elseif nil ~= equipItemWrapper and nil == equipItemWrapper2 then
      acc = 11
    else
      acc = 10
    end
  end
  return acc
end
function BetterEquipment:checkBetterItem(itemWrapper, whereType, slotNo)
  local ret = false
  if false == itemWrapper:checkConditions() then
    return false
  end
  local itemSSW = itemWrapper:getStaticStatus()
  if nil == itemSSW then
    return ret
  end
  local isServantEquip = itemSSW:isUsableServant()
  local isEquip = itemSSW:isEquipable()
  if not isServantEquip and true == isEquip then
    local currentEndurance = itemWrapper:get():getEndurance()
    local offencePoint = 0
    local defencePoint = 0
    local equipOffencePoint = 0
    local equipDefencePoint = 0
    local matchEquip = false
    local isAccessory = false
    offencePoint, defencePoint, equipOffencePoint, equipDefencePoint, matchEquip, isAccessory = _inventory_updateSlot_compareSpec(whereType, slotNo, isAccessory)
    if nil ~= defencePoint and nil ~= offencePoint and currentEndurance > 0 and true == matchEquip and defencePoint + offencePoint > equipDefencePoint + equipOffencePoint then
      ret = true
    end
  end
  return ret
end
function BetterEquipment_MouseOn(index, isOn)
  Panel_Tooltip_Item_Show_GeneralStatic(index, "betterItemList", isOn, false)
end
function BetterEquipment_EquipClick(whereType, slotNo)
  local self = BetterEquipment
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil ~= itemWrapper then
    local equipType = itemWrapper:getStaticStatus():getEquipType()
    if 16 == equipType or 17 == equipType then
      local accSlotNo = PaGlobalFunc_GetAccesoryWorseEquipment_Key(itemWrapper)
      inventoryUseItem(whereType, slotNo, accSlotNo, false)
    else
      inventoryUseItem(whereType, slotNo, nil, true)
    end
  end
  for ii = 1, #self._ui.stc_iconList do
    Panel_Tooltip_Item_Show_GeneralStatic(ii, "betterItemList", false, false)
  end
end
function PaGlobalFunc_BetterEquipment_EquipKeyUp()
  local self = BetterEquipment
  if nil ~= self._betterEquipList[1] then
    BetterEquipment_EquipClick(CppEnums.ItemWhereType.eInstanceInventory, self._betterEquipList[1])
  end
end
function PaGlobalFunc_BetterEquipment_EquipAuto()
  local self = BetterEquipment
  if nil ~= self._betterEquipList[1] then
    BetterEquipment_EquipClick(CppEnums.ItemWhereType.eInstanceInventory, self._betterEquipList[1])
    self._betterEquipList[1] = nil
  end
end
function BetterEquipment:convert_itemGradeColor(grade)
  if 0 == grade then
    return 4293388263
  elseif 1 == grade then
    return 4288921664
  elseif 2 == grade then
    return 4283938018
  elseif 3 == grade then
    return 4293904710
  elseif 4 == grade then
    return 4294929482
  else
    return UI_color.C_FFFFFFFF
  end
end
function FromClient_InventoryUpdate_BetterEquipment()
  local self = BetterEquipment
  self._betterEquipList = {}
  local whereType = CppEnums.ItemWhereType.eInstanceInventory
  local inventory = getSelfPlayer():get():getInventory(whereType)
  if nil == inventory then
    return
  end
  local invenMaxSize = inventory:sizeXXX()
  for ii = 0, invenMaxSize - 1 do
    local itemWrapper = getInventoryItemByType(whereType, ii)
    if nil ~= itemWrapper and self:checkBetterItem(itemWrapper, whereType, ii) then
      self._betterEquipList[#self._betterEquipList + 1] = ii
    end
  end
  if #self._betterEquipList > 0 then
    self:open()
    local descIndex = math.min(#self._betterEquipList, self._maxEquipCount)
  else
    self:close()
  end
  for ii = 1, self._maxEquipCount do
    if ii <= #self._betterEquipList then
      local itemWrapper = getInventoryItemByType(whereType, self._betterEquipList[ii])
      local itemSSW = itemWrapper:getStaticStatus()
      self._ui.stc_iconList[ii]._name = itemSSW:getName()
      self._ui.stc_iconList[ii]._item = itemSSW:get()._key:get()
      self._ui.stc_iconList[ii]:setItemByStaticStatus(itemSSW, itemWrapper:getCount())
      local itemGrade = itemSSW:getGradeType()
      local itemGradeColor = self:convert_itemGradeColor(itemGrade)
      self._ui.txt_nameList[ii]:SetText(tostring(itemSSW:getName()))
      self._ui.txt_nameList[ii]:SetFontColor(itemGradeColor)
      self._ui.stc_iconList[ii].icon:SetPosX(self._ui.stc_baseList[ii]:GetPosX())
      self._ui.stc_iconList[ii].icon:SetPosY(self._ui.stc_baseList[ii]:GetPosY())
      self._ui.stc_iconList[ii].icon:SetSize(self._ui.stc_baseList[ii]:GetSizeX(), self._ui.stc_baseList[ii]:GetSizeY())
      self._ui.stc_iconList[ii].icon:addInputEvent("Mouse_On", "BetterEquipment_MouseOn(" .. ii .. ", true)")
      self._ui.stc_iconList[ii].icon:addInputEvent("Mouse_Out", "BetterEquipment_MouseOn(" .. ii .. ", false)")
      self._ui.stc_iconList[ii].icon:addInputEvent("Mouse_LUp", "BetterEquipment_EquipClick(" .. whereType .. "," .. self._betterEquipList[ii] .. ")")
      self._ui.stc_iconList[ii].icon:addInputEvent("Mouse_RUp", "BetterEquipment_EquipClick(" .. whereType .. "," .. self._betterEquipList[ii] .. ")")
      self._ui.stc_bgList[ii]:addInputEvent("Mouse_LUp", "BetterEquipment_EquipClick(" .. whereType .. "," .. self._betterEquipList[ii] .. ")")
      self._ui.stc_bgList[ii]:addInputEvent("Mouse_RUp", "BetterEquipment_EquipClick(" .. whereType .. "," .. self._betterEquipList[ii] .. ")")
      self._ui.stc_bgList[ii]:SetShow(true)
      if nil ~= self._ui.slot_effect[ii] then
        self._ui.stc_iconList[ii].icon:EraseEffect(self._ui.slot_effect[ii])
      end
      self._ui.slot_effect[ii] = self._ui.stc_iconList[ii].icon:AddEffect("fUI_BetterItemAura01", true, 0, 0)
    else
      self._ui.txt_nameList[ii]:SetText(" ")
      self._ui.stc_iconList[ii]:clearItem()
      self._ui.stc_iconList[ii].icon:EraseAllEffect()
      self._ui.stc_bgList[ii]:SetShow(false)
    end
  end
end
function PaGlobalFunc_BetterEquipment_LuaLoadComplete()
  local self = BetterEquipment
  self:initialize()
  self:registerEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_BetterEquipment_LuaLoadComplete")

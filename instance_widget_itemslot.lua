local _panel = Instance_Widget_ItemSlot
local ItemSlot = {
  _ui = {
    slot = {}
  },
  _maxSlot = 4,
  _inventroyType = -1,
  _inventroySize = -1,
  _itemData = {},
  _slotData = {
    [0] = {
      _slotType = CppEnums.QuickSlotType.eInstanceItem,
      _key = 723154
    },
    [1] = {
      _slotType = CppEnums.QuickSlotType.eInstanceItem,
      _key = 56140
    },
    [2] = {
      _slotType = CppEnums.QuickSlotType.eInstanceItem,
      _key = 56138
    },
    [3] = {
      _slotType = CppEnums.QuickSlotType.eInstanceItem,
      _key = 723160
    },
    [4] = {
      _slotType = CppEnums.QuickSlotType.eInstanceItem,
      _key = 723156
    }
  },
  slotConfig_Item = {
    createIcon = true,
    createBorder = false,
    createCount = true,
    createCooltime = true,
    createCooltimeText = true,
    createEnchant = true
  },
  slotConfig_Skill = {
    createIcon = true,
    createEffect = true,
    createFG = false,
    createFGDisabled = false,
    createLevel = false,
    createLearnButton = false,
    createCooltime = true,
    createCooltimeText = true,
    template = {effect}
  },
  _allowItemType = 2,
  _isGameEnd = false,
  _quickSlotIndexGap = 10
}
function ItemSlot:initialize()
  self:createSlot()
  if false == _ContentsGroup_RenewUI_Skill then
    self.slotConfig_Skill.template.effect = UI.getChildControl(Instance_Window_Skill, "Static_Icon_Skill_Effect")
  else
    self.slotConfig_Skill.template.effect = PaGlobalFunc_Skill_GetEffectControl()
  end
  self._inventroyType = Inventory_GetCurrentInventoryType()
  self._inventroySize = getSelfPlayer():get():getInventorySlotCount(true) - 1
  for slotNo, value in pairs(self._slotData) do
    self:setSlotData(slotNo, self:getQuickSlotInfo(slotNo), true)
  end
  self:registEventHandler()
end
function ItemSlot:registEventHandler()
  registerEvent("FromClient_InventoryUpdate", "FromClient_ItemSlot_UpdateInventory")
  registerEvent("FromClient_BattleRoyaleWinner", "FromClient_BattleRoyal_PlayEnd_ItemSlot")
  _panel:RegisterUpdateFunc("FromClient_ItemSlot_UpdatePerFrame")
end
function ItemSlot:open()
  if _panel:GetShow() == true then
    self:close()
    return
  end
  _panel:SetShow(true)
end
function ItemSlot:close()
  _panel:SetShow(false)
end
function ItemSlot:setSlotData(slotNo, quickSlotInfo, isInit)
  if true == isInit and (nil == quickSlotInfo or CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type) then
    return
  end
  local slotType = CppEnums.QuickSlotType.eEmpty
  local key = -1
  if CppEnums.QuickSlotType.eInstanceItem == quickSlotInfo._type or CppEnums.QuickSlotType.eItem == quickSlotInfo._type or CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type then
    slotType = CppEnums.QuickSlotType.eInstanceItem
    key = quickSlotInfo._itemKey:getItemKey()
  elseif CppEnums.QuickSlotType.eSkill == quickSlotInfo._type then
    slotType = CppEnums.QuickSlotType.eSkill
    key = quickSlotInfo._skillKey:getSkillNo()
  end
  self._slotData[slotNo]._slotType = slotType
  self._slotData[slotNo]._key = key
end
function ItemSlot:updateInventory()
  self:clearItemAll()
  for i = 1, self._inventroySize do
    self:addItemWrapper(i)
  end
  self:updateSlot()
end
function ItemSlot:updateSlot()
  for i = 0, self._maxSlot do
    self:updateSlotAt(i)
  end
end
function ItemSlot:updateSlotAt(slotNo)
  local slot = self._ui.slot[slotNo]
  self:initSlotData(slot)
  self:ChangeSlotEnchantKeyColor(false, slot)
  self:setSlot(slotNo, self._slotData[slotNo])
end
function ItemSlot:updateCoolTime(fDeltaTime)
  if fDeltaTime <= 0 then
    return
  end
  for i = 0, self._maxSlot do
    if CppEnums.QuickSlotType.eInstanceItem == self._ui.slot[i]._slotType then
      self:updateItemCoolTime(i)
    elseif CppEnums.QuickSlotType.eSkill == self._ui.slot[i]._slotType then
      self:updateSkillCoolTime(i)
    end
  end
end
function ItemSlot:updateItemCoolTime(slotNo)
  local item = self._ui.slot[slotNo]._item
  if nil == item then
    return
  end
  if 0 < item._itemCount then
    local remainTime = 0
    local itemReuseTime = 0
    local realRemainTime = 0
    local initRemainTime = 0
    if CppEnums.TInventorySlotNoUndefined ~= item.inventoryIdx then
      remainTime = getItemCooltime(self._inventroyType, item.inventoryIdx)
      itemReuseTime = getItemReuseCycle(self._inventroyType, item.inventoryIdx) * 0.001
      realRemainTime = remainTime * itemReuseTime
      initRemainTime = realRemainTime - realRemainTime % 1 + 1
    end
    if remainTime > 0 then
      item.cooltime:UpdateCoolTime(remainTime)
      item.cooltime:SetShow(true)
      item.cooltimeText:SetText(Time_Formatting_ShowTop(initRemainTime))
      if itemReuseTime >= initRemainTime then
        item.cooltimeText:SetShow(true)
      else
        item.cooltimeText:SetShow(false)
      end
    elseif item.cooltime:GetShow() then
      item.cooltime:SetShow(false)
      item.cooltimeText:SetShow(false)
      audioPostEvent_SystemUi(2, 1)
    end
  else
    item.icon:SetMonoTone(true)
    item.cooltime:SetShow(false)
    item.cooltimeText:SetShow(false)
  end
end
function ItemSlot:updateSkillCoolTime(slotNo)
  local skill = self._ui.slot[slotNo]._skill
  if nil == skill then
    return
  end
  local quickSlotInfo = self:getQuickSlotInfo(slotNo)
  if nil == quickSlotInfo then
    skill.icon:SetMonoTone(true)
    skill.cooltime:SetShow(false)
    skill.cooltimeText:SetShow(false)
    return
  end
  local isLearned = ToClient_isLearnedSkill(quickSlotInfo._skillKey:getSkillNo())
  if true == isLearned then
    local skillStaticWrapper = getSkillStaticStatus(quickSlotInfo._skillKey:getSkillNo(), quickSlotInfo._skillKey:getLevel())
    if nil ~= skillStaticWrapper then
      if skillStaticWrapper:isUsableSkill() then
        skill.icon:SetMonoTone(false)
      else
        skill.icon:SetMonoTone(true)
      end
    end
    local remainTime = getSkillCooltime(quickSlotInfo._skillKey:get())
    local skillReuseTime = skillStaticWrapper:get()._reuseCycle / 1000
    local realRemainTime = remainTime * skillReuseTime
    local intRemainTime = realRemainTime - realRemainTime % 1 + 1
    if remainTime > 0 then
      skill.cooltime:UpdateCoolTime(remainTime)
      skill.cooltime:SetShow(true)
      skill.cooltimeText:SetText(Time_Formatting_ShowTop(intRemainTime))
      if skillReuseTime >= intRemainTime then
        skill.cooltimeText:SetShow(true)
      else
        skill.cooltimeText:SetShow(false)
      end
    elseif skill.cooltime:GetShow() then
      skill.cooltime:SetShow(false)
      skill.cooltimeText:SetShow(false)
      local skillSlotPosX = skill.cooltime:GetParentPosX()
      local skillSlotPosY = skill.cooltime:GetParentPosY()
      Instance_CoolTime_Effect_Slot:SetShow(true, true)
      Instance_CoolTime_Effect_Slot:SetIgnore(true)
      Instance_CoolTime_Effect_Slot:AddEffect("fUI_Skill_Cooltime01", false, 2.5, 7)
      Instance_CoolTime_Effect_Slot:SetPosX(skillSlotPosX - 7)
      Instance_CoolTime_Effect_Slot:SetPosY(skillSlotPosY - 8)
    end
  else
    skill.icon:SetMonoTone(true)
    skill.cooltime:SetShow(false)
    skill.cooltimeText:SetShow(false)
  end
end
function ItemSlot:addItemWrapper(index)
  local itemWrapper = getInventoryItemByType(self._inventroyType, index)
  if nil == itemWrapper then
    return
  end
  local itemSSW = itemWrapper:getStaticStatus()
  local itemType = itemSSW:getItemType()
  if self._allowItemType ~= itemType then
    return
  end
  local itemKey = itemWrapper:get():getKey():getItemKey()
  if nil == self._itemData[itemKey] then
    self._itemData[itemKey] = {}
    self._itemData[itemKey]._count = 0
  end
  local item = self._itemData[itemKey]
  item.itemKey = itemKey
  item._count = item._count + Int64toInt32(itemWrapper:get():getCount_s64())
  item.inventoryIdx = index
end
function ItemSlot:slotUse(slotNo)
  if true == self._isGameEnd then
    return
  end
  local slot = self._ui.slot[slotNo]
  if CppEnums.QuickSlotType.eInstanceItem == slot._slotType then
    self:itemUse(slotNo)
  elseif CppEnums.QuickSlotType.eSkill == slot._slotType then
    self:skillUse(slotNo)
  end
end
function ItemSlot:itemUse(slotNo)
  local slot = self._ui.slot[slotNo]
  local item = slot._item
  local _itemCount = item._itemCount
  if _itemCount > 0 then
    if restrictedActionForUseItem() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_CANT_USEITEM"))
      return
    end
    if false == item.cooltime:GetShow() then
      audioPostEvent_SystemUi(8, 2)
      _AudioPostEvent_SystemUiForXBOX(8, 2)
      item.icon:AddEffect("fUI_SkillButton01", false, 0, 0)
      item.icon:AddEffect("UI_SkillButton01", false, 0, 0)
    end
    inventoryUseItem(self._inventroyType, item.inventoryIdx, nil, true)
  end
end
function ItemSlot:skillUse(slotNo)
  local quickSlotInfo = self:getQuickSlotInfo(slotNo)
  if nil == quickSlotInfo then
    return
  end
  self:useQuickSlot(slotNo)
end
function ItemSlot:createSlot()
  for i = 0, self._maxSlot do
    do
      local slotControl = UI.getChildControl(_panel, "Static_Slot_" .. i)
      local slot = {
        _slotType = CppEnums.QuickSlotType.eEmpty,
        _item = nil,
        _skill = nil
      }
      slot.background = slotControl
      slot.keyBg = UI.getChildControl(slotControl, "Static_key_bg_" .. i)
      slot.keyTxt = UI.getChildControl(slot.keyBg, "Static_keyTxt_" .. i)
      slot.keyTxt:SetText(ItemSlot:getKeybinder(i))
      function slot:setItem(slotNo, slotData)
        if CppEnums.QuickSlotType.eInstanceItem ~= self._slotType then
          if CppEnums.QuickSlotType.eSkill == self._slotType then
            self._skill:destroyChild()
            Panel_SkillTooltip_Hide()
            self._skill = nil
          end
          self._slotType = CppEnums.QuickSlotType.eInstanceItem
          local itemSlot = {}
          SlotItem.new(itemSlot, "slotItem_" .. slotNo, slotNo, slotControl, ItemSlot.slotConfig_Item)
          itemSlot:createChild()
          itemSlot.icon:SetPosX(2)
          itemSlot.icon:SetPosY(2)
          self.background:removeInputEvent("Mouse_LUp")
          itemSlot.icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_ItemSlot_MouseLUp(" .. slotNo .. ")")
          itemSlot.icon:addInputEvent("Mouse_PressMove", "PaGlobalFunc_ItemSlot_MousePressMove(" .. slotNo .. ")")
          itemSlot.icon:SetEnableDragAndDrop(true)
          itemSlot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. slotNo .. ", \"ItemSlot\", true)")
          itemSlot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. slotNo .. ", \"ItemSlot\", false)")
          Panel_Tooltip_Item_SetPosition(slotNo, itemSlot, "ItemSlot")
          self._item = itemSlot
        end
        ItemSlot:setSlotItem(slotNo, slotData)
      end
      function slot:setSkill(slotNo, slotData)
        if CppEnums.QuickSlotType.eSkill ~= self._slotType then
          if CppEnums.QuickSlotType.eInstanceItem == self._slotType then
            UI.deleteControl(self._item.icon)
            Panel_Tooltip_Item_hideTooltip()
            self._item = nil
          end
          self._slotType = CppEnums.QuickSlotType.eSkill
          local skillSlot = {}
          SlotSkill.new(skillSlot, slotNo, slotControl, ItemSlot.slotConfig_Skill)
          skillSlot.icon:SetPosX(2)
          skillSlot.icon:SetPosY(2)
          self.background:removeInputEvent("Mouse_LUp")
          skillSlot.icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_ItemSlot_MouseLUp(" .. slotNo .. ")")
          skillSlot.icon:addInputEvent("Mouse_PressMove", "PaGlobalFunc_ItemSlot_MousePressMove(" .. slotNo .. ")")
          skillSlot.icon:SetEnableDragAndDrop(true)
          skillSlot.icon:addInputEvent("Mouse_On", "Panel_SkillTooltip_Show(" .. slotNo .. ", false, \"ItemSlot\")")
          skillSlot.icon:addInputEvent("Mouse_Out", "Panel_SkillTooltip_Hide()")
          Panel_SkillTooltip_SetPosition(slotNo, skillSlot.icon, "ItemSlot")
          self.keyTxt:AddEffect("UI_SkillButton01", false, 0, 0)
          self.keyTxt:AddEffect("fUI_Repair01", false, 0, 0)
          self.keyBg:AddEffect("fUI_Light", false, 0, 0)
          self._skill = skillSlot
        end
        ItemSlot:setSlotSkill(slotNo, slotData)
      end
      function slot:setEmpty(slotNo)
        if CppEnums.QuickSlotType.eInstanceItem == self._slotType then
          UI.deleteControl(self._item.icon)
          Panel_Tooltip_Item_hideTooltip()
          self._item = nil
        elseif CppEnums.QuickSlotType.eSkill == self._slotType then
          self._skill:destroyChild()
          Panel_SkillTooltip_Hide()
          self._skill = nil
        end
        self.background:addInputEvent("Mouse_LUp", "PaGlobalFunc_ItemSlot_MouseLUp(" .. slotNo .. ")")
        self._slotType = CppEnums.QuickSlotType.eEmpty
      end
      self._ui.slot[i] = slot
    end
  end
end
function ItemSlot:setSlot(slotNo, slotData)
  if CppEnums.QuickSlotType.eInstanceItem == slotData._slotType then
    self._ui.slot[slotNo]:setItem(slotNo, slotData)
  elseif CppEnums.QuickSlotType.eSkill == slotData._slotType then
    self._ui.slot[slotNo]:setSkill(slotNo, slotData)
  else
    self._ui.slot[slotNo]:setEmpty(slotNo)
  end
end
function ItemSlot:setSlotItem(slotNo, slotData)
  local item = self._itemData[slotData._key]
  if nil == item then
    self:setSlotItemEmpty(slotNo, slotData._key)
    return
  end
  local itemWrapper = getInventoryItemByType(self._inventroyType, item.inventoryIdx)
  if nil == itemWrapper then
    self:setSlotItemEmpty(slotNo, slotData._key)
    return
  end
  local slot = self._ui.slot[slotNo]
  slot._item:setItem(itemWrapper)
  slot._item.inventoryIdx = item.inventoryIdx
  slot._item._itemCount = item._count
  slot._item.icon:SetMonoTone(false)
  self:ChangeSlotEnchantKeyColor(true, slot)
  slot._item._item = item.itemKey
  slot._item.count:SetShow(true)
  slot._item.count:SetText(tostring(item._count))
  slot.key = slotData._key
end
function ItemSlot:setSlotItemEmpty(slotNo, key)
  local slot = self._ui.slot[slotNo]
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(key))
  if nil == itemSSW then
    return
  end
  slot._item:setItemByStaticStatus(itemSSW)
  slot._item.icon:SetMonoTone(true)
  slot.key = key
  self:initSlotData(slot)
end
function ItemSlot:setSlotSkill(slotNo, slotData)
  if nil == slotData then
    return
  end
  local skillTypeStaticWrapper = getSkillTypeStaticStatus(slotData._key)
  if nil == skillTypeStaticWrapper then
    return
  end
  local slot = self._ui.slot[slotNo]
  slot.key = slotData._key
  slot._skill:setSkillTypeStatic(skillTypeStaticWrapper)
end
function ItemSlot:clearItemAll()
  for key, value in pairs(self._itemData) do
    value.itemKey = key
    value._count = 0
    value.inventoryIdx = -1
  end
end
function ItemSlot:initSlotData(slot)
  if nil ~= slot._item then
    slot._item.inventoryIdx = -1
    slot._item._itemCount = 0
    slot._item._item = nil
  end
end
function ItemSlot:ChangeSlotEnchantKeyColor(isActive, slot)
  if true == isActive then
    slot.keyTxt:SetFontColor(Defines.Color.C_FFFFFFFF)
  else
    slot.keyTxt:SetFontColor(Defines.Color.C_FF888888)
  end
end
function ItemSlot:mousePressMove(slotNo)
  if nil ~= getSelfPlayer() and CppEnums.ClassType.ClassType_Temp1 == getSelfPlayer():getClassType() then
    return
  end
  local slot = self._ui.slot[slotNo]
  if CppEnums.QuickSlotType.eInstanceItem == slot._slotType then
    self:mousePressMove_Item(slotNo)
  elseif CppEnums.QuickSlotType.eSkill == slot._slotType then
    self:mousePressMove_Skill(slotNo)
  end
end
function ItemSlot:mousePressMove_Item(slotNo)
  local slotData = self._slotData[slotNo]
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(slotData._key))
  if nil == itemSSW then
    return
  end
  DragManager:setDragInfo(_panel, nil, slotNo, "Icon/" .. itemSSW:getIconPath(), PaGlobalFunc_ItemSlot_GroudClick, nil)
end
function ItemSlot:mousePressMove_Skill(slotNo)
  local slotData = self._slotData[slotNo]
  local skillTypeSSW = getSkillTypeStaticStatus(slotData._key)
  if nil == skillTypeSSW then
    return
  end
  DragManager:setDragInfo(_panel, nil, slotNo, "Icon/" .. skillTypeSSW:getIconPath(), PaGlobalFunc_ItemSlot_GroudClick, nil)
end
function ItemSlot:mouseLUp(slotIndex, isKeyDown)
  if nil ~= getSelfPlayer() and CppEnums.ClassType.ClassType_Temp1 == getSelfPlayer():getClassType() then
    return
  end
  if DragManager.dragStartPanel == Instance_Window_Inventory then
    self:dragInventoryItemSlot(slotIndex, DragManager.dragSlotInfo)
  elseif DragManager.dragStartPanel == _panel then
    self:dragChangeSlot(slotIndex, DragManager.dragSlotInfo)
  elseif DragManager.dragStartPanel == Instance_QuickSlot then
    self:dragQuickSlot(slotIndex, DragManager.dragSlotInfo)
  end
  if nil ~= DragManager.dragStartPanel then
    audioPostEvent_SystemUi(0, 8)
    _AudioPostEvent_SystemUiForXBOX(0, 8)
    DragManager:clearInfo()
    if true == isKeyDown and CppEnums.QuickSlotType.eSkill == self._ui.slot[slotIndex]._slotType then
      self:skillUse(slotIndex)
    end
    return
  end
  self:slotUse(slotIndex)
end
function ItemSlot:dragInventoryItemSlot(slotIndex, inventoryIdx)
  local itemWrapper = getInventoryItemByType(self._inventroyType, inventoryIdx)
  if nil == itemWrapper then
    return
  end
  local itemSSW = itemWrapper:getStaticStatus()
  local itemType = itemSSW:getItemType()
  if self._allowItemType ~= itemType then
    return
  end
  local itemKey = itemWrapper:get():getKey():getItemKey()
  local slotNo = self:getFindSlotNo(CppEnums.QuickSlotType.eInstanceItem, itemKey)
  if nil ~= slotNo then
    self._slotData[slotNo]._key = -1
  end
  self._slotData[slotIndex]._slotType = CppEnums.QuickSlotType.eInstanceItem
  self._slotData[slotIndex]._key = itemKey
  self:updateSlotAt(slotIndex)
end
function ItemSlot:dragChangeSlot(slotIndex, dragIndex)
  self._slotData[slotIndex], self._slotData[dragIndex] = self._slotData[dragIndex], self._slotData[slotIndex]
  quickSlot_Swap(self._quickSlotIndexGap + slotIndex, self._quickSlotIndexGap + dragIndex)
  self:updateSlotAt(slotIndex)
  self:updateSlotAt(dragIndex)
end
function ItemSlot:dragQuickSlot(itemSlotIndex, quickSlotIndex)
  local calculateSlotIndex = self._quickSlotIndexGap + itemSlotIndex
  local itemSlotQuickInfo = getQuickSlotItem(calculateSlotIndex)
  if (nil == itemSlotQuickInfo or CppEnums.QuickSlotType.eEmpty == itemSlotQuickInfo._type) and CppEnums.QuickSlotType.eInstanceItem == self._slotData[itemSlotIndex]._slotType then
    local itemData = self._itemData[self._slotData[itemSlotIndex]._key]
    if nil ~= itemData and 0 < itemData._count then
      quickSlot_RegistItem(calculateSlotIndex, Inventory_GetCurrentInventoryType(), itemData.inventoryIdx)
    end
  end
  local quickSlotInfo = getQuickSlotItem(quickSlotIndex)
  if nil == quickSlotInfo or CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type then
    local slotData = PaGlobalFunc_quickSlot_GetSlotData(quickSlotIndex)
    if nil ~= slotData then
      self._slotData[itemSlotIndex]._slotType = slotData._slotType
      self._slotData[itemSlotIndex]._key = slotData._key
    end
  else
    PaGlobalFunc_quickSlot_SetSlotData(quickSlotIndex, self._slotData[itemSlotIndex]._slotType, self._slotData[itemSlotIndex]._key)
    self:setSlotData(itemSlotIndex, quickSlotInfo, false)
  end
  quickSlot_Swap(calculateSlotIndex, quickSlotIndex)
  self:updateSlotAt(itemSlotIndex)
end
function ItemSlot:getFindSlotNo(_slotType, _key)
  local slotData
  for i = 0, self._maxSlot do
    slotData = self._slotData[i]
    if _slotType == slotData._slotType and _key == slotData._key then
      return i
    end
  end
  return nil
end
function ItemSlot:getQuickSlotInfo(slotNo)
  return getQuickSlotItem(self._quickSlotIndexGap + slotNo)
end
function ItemSlot:useQuickSlot(slotNo)
  quickSlot_UseSlot(self._quickSlotIndexGap + slotNo)
end
function ItemSlot:getKeybinder(slotNo)
  local strKey
  if 0 == slotNo then
    strKey = keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_ServantOrder1)
  elseif 1 == slotNo then
    strKey = keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_ServantOrder2)
  elseif 2 == slotNo then
    strKey = keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_ServantOrder3)
  elseif 3 == slotNo then
    strKey = keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_ServantOrder4)
  elseif 4 == slotNo then
    strKey = keyCustom_GetString_UiKey(CppEnums.UiInputType.UiInputType_Mail)
  end
  return strKey
end
function FromClient_ItemSlot_Init()
  ItemSlot:initialize()
  ItemSlot:open()
end
function PaGlobalFunc_ItemSlot_Open()
  ItemSlot:open()
end
function PaGlobalFunc_ItemSlot_Close()
  ItemSlot:close()
end
function FromClient_ItemSlot_UpdateInventory()
  ItemSlot:updateInventory()
end
function PaGlobalFunc_ItemSlot_Use(idx)
  ItemSlot:mouseLUp(idx, true)
end
function FromClient_ItemSlot_UpdatePerFrame(fDeltaTime)
  ItemSlot:updateCoolTime(fDeltaTime)
end
function FromClient_BattleRoyal_PlayEnd_ItemSlot()
  ItemSlot._isGameEnd = true
  _panel:ClearUpdateLuaFunc()
end
function PaGlobalFunc_ItemSlot_MousePressMove(slotIndex)
  ItemSlot:mousePressMove(slotIndex)
end
function PaGlobalFunc_ItemSlot_MouseLUp(slotIndex)
  ItemSlot:mouseLUp(slotIndex, false)
end
function PaGlobalFunc_ItemSlot_GetSkillNo(slotNo)
  if CppEnums.QuickSlotType.eSkill ~= ItemSlot._slotData[slotNo]._slotType then
    return -1
  end
  return ItemSlot._slotData[slotNo]._key
end
function PaGlobalFunc_ItemSlot_GroudClick(whereType, slotIndex)
end
function PaGlobalFunc_ItemSlot_GetSlotData(slotNo)
  return ItemSlot._slotData[slotNo]
end
function PaGlobalFunc_ItemSlot_GetItemData(itemKey)
  return ItemSlot._itemData[itemKey]
end
function PaGlobalFunc_ItemSlot_RefreshQuickSlotInfo(slotNo)
  ItemSlot:setSlotData(slotNo, ItemSlot:getQuickSlotInfo(slotNo), false)
  ItemSlot:updateSlotAt(slotNo)
end
function PaGlobalFunc_ItemSlot_SetSlotData(slotNo, slotType, key)
  ItemSlot._slotData[slotNo]._slotType = slotType
  ItemSlot._slotData[slotNo]._key = key
  ItemSlot:updateSlotAt(slotNo)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_ItemSlot_Init")

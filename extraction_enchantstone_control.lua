function ExtractionEnchantStone_InvenFiler_MainItem(slotNo, itemWrapper, whereType)
  if nil == itemWrapper then
    return true
  end
  local itemSSW = itemWrapper:getStaticStatus():get()
  local equipSlotNo = itemWrapper:getStaticStatus():getEquipSlotNo()
  local isNotAccessories = false
  if itemWrapper:getStaticStatus():isGuildStockable() then
    return true
  end
  if itemWrapper:isCash() then
    return true
  end
  local enchantDifficulty = itemWrapper:getStaticStatus():getEnchantDifficulty()
  if __eEnchantDifficulty_None == enchantDifficulty or __eEnchantDifficulty_NotExtractHard == enchantDifficulty then
    return true
  end
  if false == itemWrapper:getStaticStatus():isExtractable() then
    return true
  end
  if true == ToClient_Inventory_CheckItemLock(slotNo, Inventory_GetCurrentInventoryType()) then
    return true
  end
  if false == (equipSlotNo >= 7 and equipSlotNo <= 13) then
    isNotAccessories = true
  end
  if itemWrapper:getStaticStatus():isUsableServant() then
    isNotAccessories = true
  end
  return false == (0 < itemSSW._key:getEnchantLevel() and itemSSW._key:getEnchantLevel() < 16 and isNotAccessories)
end
function ExtractionEnchantStone_InteractortionFromInventory(slotNo, itemWrapper, count_s64, inventoryType)
  local self = PaGlobal_ExtractionEnchantStone
  if self._uiEquipItem.icon then
    audioPostEvent_SystemUi(0, 16)
    self._uiEquipItem.icon:AddEffect("UI_Button_Hide", false, 0, 0)
    self._uiEquipItem.slot_On:SetShow(true)
    self._uiEquipItem.slot_Nil:SetShow(false)
    self._uiEffectCircle:ResetVertexAni()
    self._uiEffectCircle:SetVertexAniRun("Ani_Color_On", true)
    self._uiEffectCircle:SetVertexAniRun("Ani_Rotate_New", true)
    self._uiButtonApply:SetIgnore(false)
    self._uiButtonApply:SetMonoTone(false)
  end
  self._uiEquipItem.empty = false
  self._targetWhereType = inventoryType
  self._targetSlotNo = slotNo
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  self._uiEquipItem:setItem(itemWrapper)
  self._uiEquipItem.icon:addInputEvent("Mouse_On", "PaGlobal_ExtractionEnchantStone_ShowTooltip(true)")
  self._uiEquipItem.icon:addInputEvent("Mouse_Out", "PaGlobal_ExtractionEnchantStone_ShowTooltip(false)")
  local ItemEnchantStaticStatus = itemWrapper:getStaticStatus():get()
  local blackStone_Count = ItemEnchantStaticStatus._key:getEnchantLevel()
  self._thisIsWeapone = ItemEnchantStaticStatus:isWeapon() or ItemEnchantStaticStatus:isSubWeapon() or ItemEnchantStaticStatus:isAwakenWeapon()
  if self._thisIsWeapone then
    if blackStone_Count >= 8 then
      blackStone_Count = "?"
    end
  elseif blackStone_Count >= 6 then
    blackStone_Count = "?"
  end
  self._uiTextBlackStoneCount:SetText(blackStone_Count)
  if itemWrapper:getStaticStatus():get():isWeapon() or itemWrapper:getStaticStatus():get():isSubWeapon() or itemWrapper:getStaticStatus():get():isAwakenWeapon() then
    self._uiIconBlackStoneWeapon:SetShow(true)
    self._uiIconBlackStoneWeapon:SetMonoTone(true)
    self._uiIconBlackStoneArmor:SetShow(false)
    self._uiTextBlackStoneCount:SetShow(true)
  else
    self._uiIconBlackStoneWeapon:SetShow(false)
    self._uiIconBlackStoneArmor:SetShow(true)
    self._uiIconBlackStoneArmor:SetMonoTone(true)
    self._uiTextBlackStoneCount:SetShow(true)
  end
  Inventory_SetFunctor(ExtractionEnchantStone_InvenFiler_MainItem, ExtractionEnchantStone_InteractortionFromInventory, ExtractionEnchantStone_WindowClose, nil)
end
function PaGlobal_ExtractionEnchantStone:handleMRUpEquipSlot()
  self._uiEffectCircle:ResetVertexAni()
  self._uiEffectCircle:SetVertexAniRun("Ani_Color_Off", true)
  self._uiEffectCircle:SetVertexAniRun("Ani_Rotate_New", true)
  self:clear()
  Inventory_SetFunctor(ExtractionEnchantStone_InvenFiler_MainItem, ExtractionEnchantStone_InteractortionFromInventory, ExtractionEnchantStone_WindowClose, nil)
end
function PaGlobal_ExtractionEnchantStone:applyReady()
  local messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_APPLYREADY")
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = messageContent,
    functionYes = function()
      ToClient_ExtractBlackStone(self._targetWhereType, self._targetSlotNo)
      Panel_Window_Extraction_EnchantStone:RegisterUpdateFunc("ExtractionEnchant_CheckTime")
      audioPostEvent_SystemUi(5, 10)
      FGlobal_MiniGame_RequestExtraction()
      PaGlobal_TutorialManager:handleApplyExtractionEnchantStone()
    end,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobal_ExtractionEnchantStone:registMessageHandler()
  registerEvent("FromClient_ExtractionEnchant_Success", "ExtractionEnchant_Success")
end
function ExtractionEnchant_Success()
  local self = PaGlobal_ExtractionEnchantStone
  self._currentTime = 0
  self._doExtracting = true
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_ExtractionEnchantStone:successXXX()
  self._doExtracting = false
  self._currentTime = 0
  PaGlobal_ExtractionEnchantStone:resultShow()
  PaGlobal_ExtractionEnchantStone:clear()
end
function PaGlobal_ExtractionEnchantStone_ShowTooltip(isShow)
  local self = PaGlobal_ExtractionEnchantStone
  if true == isShow then
    local itemWrapper = getInventoryItemByType(self._targetWhereType, self._targetSlotNo)
    local control = Panel_Window_Extraction_EnchantStone
    Panel_Tooltip_Item_Show(itemWrapper, control, false, true, nil, nil, nil)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end

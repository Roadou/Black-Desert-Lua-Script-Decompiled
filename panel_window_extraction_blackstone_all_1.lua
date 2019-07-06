function PaGlobal_Extraction_Blackstone_All:initialize()
  if true == self._initialize then
    return
  end
  self._isConsole = ToClient_isConsole()
  self:controlAll_Init()
  self:controlPc_Init()
  self:controlConsole_Init()
  self:setUiSetting()
  self:setNotice()
  self._ui._icon_items = {}
  SlotItem.new(self._ui._icon_items, "feeItem", nil, self._ui.stc_extractionSlot, self._slotConfig)
  self._ui._icon_items:createChild()
  self._ui._icon_items.icon:addInputEvent("Mouse_On", "PaGlobal_Extraction_Blackstone_All_ShowToolTip(true)")
  self._ui._icon_items.icon:addInputEvent("Mouse_Out", "PaGlobal_Extraction_Blackstone_All_ShowToolTip(false)")
  self._ui._icon_items.icon:addInputEvent("Mouse_RUp", "HandleEventRUp_Extraction_Blackstone_All_ClearItemSlot()")
  self._ui._icon_items:clearItem()
  self._ui._icon_result = {}
  SlotItem.new(self._ui._icon_result, "resultItem", nil, self._ui.stc_resultSlot, self._slotConfig)
  self._ui._icon_result:createChild()
  self._ui._icon_result.icon:addInputEvent("Mouse_On", "PaGlobal_Extraction_Blackstone_All_ResultShowToolTip(true)")
  self._ui._icon_result.icon:addInputEvent("Mouse_Out", "PaGlobal_Extraction_Blackstone_All_ResultShowToolTip(false)")
  self._ui._icon_result:clearItem()
  self:registEventHandler()
  self:validate()
  self._initialize = true
end
function PaGlobal_Extraction_Blackstone_All:controlAll_Init()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
  local leftMainArea = UI.getChildControl(Panel_Window_Extraction_EnchantStone_All, "Static_LeftMainImageArea")
  self._ui.stc_extractionSlot = UI.getChildControl(leftMainArea, "Static_ExtractionItemSlot")
  self._ui.stc_resultSlot = UI.getChildControl(leftMainArea, "Static_ExtractionResultSlot")
  self._ui.stc_effectCircle = UI.getChildControl(leftMainArea, "Static_ExtractionImage")
  local leftBottomArea = UI.getChildControl(Panel_Window_Extraction_EnchantStone_All, "Static_LeftBottomDescArea")
  self._ui.stc_leftBottomDese = UI.getChildControl(leftBottomArea, "StaticText_LeftBottomDesc")
  local leftBtnArea = UI.getChildControl(Panel_Window_Extraction_EnchantStone_All, "Static_LeftBottomButtonArea")
  self._ui.btn_skipAni = UI.getChildControl(leftBtnArea, "CheckButton_SkipAni")
  local rightArea = UI.getChildControl(Panel_Window_Extraction_EnchantStone_All, "Static_RightArea")
  self._ui.list2_extractableItem = UI.getChildControl(rightArea, "List2_ExtractableItemList")
end
function PaGlobal_Extraction_Blackstone_All:controlPc_Init()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
  local titleBar = UI.getChildControl(Panel_Window_Extraction_EnchantStone_All, "Static_TitlebarArea")
  self._ui_pc.btn_question = UI.getChildControl(titleBar, "Button_Question")
  self._ui_pc.btn_close = UI.getChildControl(titleBar, "Button_Close")
  local leftBtnArea = UI.getChildControl(Panel_Window_Extraction_EnchantStone_All, "Static_LeftBottomButtonArea")
  self._ui_pc.btn_extraction = UI.getChildControl(leftBtnArea, "Button_Extraction")
end
function PaGlobal_Extraction_Blackstone_All:controlConsole_Init()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
end
function PaGlobal_Extraction_Blackstone_All:setUiSetting()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
  if false == PaGlobal_Extraction_Blackstone_All._isConsole then
  else
  end
  FromClient_Extraction_Blackstone_All_ReSizePanel()
end
function PaGlobal_Extraction_Blackstone_All:registEventHandler()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
  Panel_Window_Extraction_EnchantStone_All:RegisterShowEventFunc(true, "PaGlobal_Extraction_Blackstone_All_ShowAni()")
  Panel_Window_Extraction_EnchantStone_All:RegisterShowEventFunc(false, "PaGlobal_Extraction_Blackstone_All_HideAni()")
  registerEvent("onScreenResize", "FromClient_Extraction_Blackstone_All_ReSizePanel")
  registerEvent("FromClient_ExtractionEnchant_Success", "FromClient_Extraction_Blackstone_All_ExtractionEnchant_Success")
  self._ui.list2_extractableItem:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "HandleEventLUp_Extraction_Blackstone_All_ListControlCreate")
  self._ui.list2_extractableItem:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  registerEvent("FromClient_InventoryUpdate", "PaGlobal_Extraction_Blackstone_All_UpdateList")
  registerEvent("EventEquipmentUpdate", "PaGlobal_Extraction_Blackstone_All_UpdateList")
  if false == self._isConsole then
    self._ui_pc.btn_close:addInputEvent("Mouse_LUp", "PaGlobal_Extraction_Blackstone_All_Close()")
    self._ui_pc.btn_question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowExtractionEnchantStone\" )")
    self._ui_pc.btn_question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelWindowExtractionEnchantStone\", \"true\")")
    self._ui_pc.btn_question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelWindowExtractionEnchantStone\", \"false\")")
    self._ui_pc.btn_extraction:addInputEvent("Mouse_LUp", "HandleEventLUp_Extraction_Blackstone_All_ExtractionButton()")
    self._ui.btn_skipAni:addInputEvent("Mouse_LUp", "HandleEventLUp_Extraction_Blackstone_All_SkipAniButton()")
  else
  end
end
function PaGlobal_Extraction_Blackstone_All:prepareOpen()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
  self:updateExtractionList()
  PaGlobal_Extraction_Blackstone_All:open()
end
function PaGlobal_Extraction_Blackstone_All:open()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
  Panel_Window_Extraction_EnchantStone_All:SetShow(true, true)
end
function PaGlobal_Extraction_Blackstone_All:prepareClose()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
  Panel_Window_Extraction_EnchantStone_All:ClearUpdateLuaFunc()
  PaGlobal_Extraction_Blackstone_All:close()
end
function PaGlobal_Extraction_Blackstone_All:close()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
  Panel_Window_Extraction_EnchantStone_All:SetShow(false, false)
end
function PaGlobal_Extraction_Blackstone_All:update()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
end
function PaGlobal_Extraction_Blackstone_All:validate()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
  self:allValidate()
  self:pcValidate()
  self:consoleValidate()
end
function PaGlobal_Extraction_Blackstone_All:allValidate()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
  self._ui.stc_extractionSlot:isValidate()
  self._ui.stc_resultSlot:isValidate()
  self._ui.stc_leftBottomDese:isValidate()
  self._ui.btn_skipAni:isValidate()
  self._ui.list2_extractableItem:isValidate()
  self._ui.stc_effectCircle:isValidate()
end
function PaGlobal_Extraction_Blackstone_All:pcValidate()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
  self._ui_pc.btn_question:isValidate()
  self._ui_pc.btn_close:isValidate()
  self._ui_pc.btn_extraction:isValidate()
end
function PaGlobal_Extraction_Blackstone_All:consoleValidate()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
end
function PaGlobal_Extraction_Blackstone_All:updateExtractionList()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
  self._ui.list2_extractableItem:getElementManager():clearKey()
  self._blackStoneCnt = 0
  self._equipCnt = 0
  local EquipNoMin = CppEnums.EquipSlotNo.rightHand
  local EquipNoMax = CppEnums.EquipSlotNo.equipSlotNoCount
  for equipNo = EquipNoMin, EquipNoMax do
    local itemWrapper = ToClient_getEquipmentItem(equipNo)
    if false == self:filterEquipItem(equipNo, itemWrapper) then
      self._blackStoneCnt = self._blackStoneCnt + 1
      self._equipCnt = self._equipCnt + 1
      self._ui.list2_extractableItem:getElementManager():pushKey(toInt64(0, self._blackStoneCnt))
      self._equipNo[self._blackStoneCnt] = equipNo
      local enchantLevel = itemWrapper:getStaticStatus():get()._key:getEnchantLevel()
      self._itemInfo.name[self._blackStoneCnt] = HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemWrapper:getStaticStatus():getName()
      self._itemInfo.iconPath[self._blackStoneCnt] = itemWrapper:getStaticStatus():getIconPath()
      local isEquipAble = itemWrapper:getStaticStatus():isEquipable()
      local isCash = itemWrapper:getStaticStatus():get():isCash()
      local isAccessory = CppEnums.ItemClassifyType.eItemClassify_Accessory == itemWrapper:getStaticStatus():getItemClassify()
      local balksCnt = itemWrapper:getStaticStatus():getExtractionCount_s64()
      local cronsCnt = itemWrapper:getStaticStatus():getCronCount_s64()
      self._itemInfo.itemEnchantLevle[self._blackStoneCnt] = PaGlobal_Extraction_Blackstone_All:getEnchantText(isEquipAble, isCash, isAccessory, balksCnt, cronsCnt, enchantLevel)
    end
  end
  local whereType = CppEnums.ItemWhereType.eInventory
  local inventory = getSelfPlayer():get():getInventory(whereType)
  if nil == inventory then
    return
  end
  local invenMaxSize = inventory:sizeXXX()
  for slotNo = 0, invenMaxSize - 1 do
    local itemWrapper = getInventoryItemByType(whereType, slotNo)
    if false == self:filterInvenItem(slotNo, itemWrapper) then
      self._blackStoneCnt = self._blackStoneCnt + 1
      self._ui.list2_extractableItem:getElementManager():pushKey(toInt64(0, self._blackStoneCnt))
      local enchantLevel = itemWrapper:getStaticStatus():get()._key:getEnchantLevel()
      self._itemInfo.name[self._blackStoneCnt] = HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemWrapper:getStaticStatus():getName()
      self._itemInfo.iconPath[self._blackStoneCnt] = itemWrapper:getStaticStatus():getIconPath()
      self._itemInfo.slotNo[self._blackStoneCnt] = slotNo
      local isEquipAble = itemWrapper:getStaticStatus():isEquipable()
      local isCash = itemWrapper:getStaticStatus():get():isCash()
      local isAccessory = CppEnums.ItemClassifyType.eItemClassify_Accessory == itemWrapper:getStaticStatus():getItemClassify()
      local balksCnt = itemWrapper:getStaticStatus():getExtractionCount_s64()
      local cronsCnt = itemWrapper:getStaticStatus():getCronCount_s64()
      self._itemInfo.itemEnchantLevle[self._blackStoneCnt] = PaGlobal_Extraction_Blackstone_All:getEnchantText(isEquipAble, isCash, isAccessory, balksCnt, cronsCnt, enchantLevel)
    end
  end
  for index = 1, self._blackStoneCnt do
    self._itemInfo.isExtractionEquip[index] = false
  end
end
function PaGlobal_Extraction_Blackstone_All:filterInvenItem(slotNo, itemWrapper)
  if nil == itemWrapper then
    return true
  end
  local itemSSW = itemWrapper:getStaticStatus():get()
  local equipSlotNo = itemWrapper:getStaticStatus():getEquipSlotNo()
  local isNotAccessories = false
  local isNotCashItem = true
  if 7 ~= equipSlotNo and 8 ~= equipSlotNo and 9 ~= equipSlotNo and 10 ~= equipSlotNo and 11 ~= equipSlotNo and 12 ~= equipSlotNo and 13 ~= equipSlotNo then
    isNotAccessories = true
  end
  if itemWrapper:getStaticStatus():isUsableServant() then
    isNotAccessories = true
  end
  if itemWrapper:getStaticStatus():isGuildStockable() then
    isNotAccessories = false
  end
  if itemWrapper:isCash() then
    isNotCashItem = false
  end
  local enchantDifficulty = itemWrapper:getStaticStatus():getEnchantDifficulty()
  if __eEnchantDifficulty_None == enchantDifficulty or __eEnchantDifficulty_NotExtractHard == enchantDifficulty then
    isNotAccessories = false
  end
  return false == (0 < itemSSW._key:getEnchantLevel() and itemSSW._key:getEnchantLevel() < 16 and isNotAccessories and isNotCashItem)
end
function PaGlobal_Extraction_Blackstone_All:filterEquipItem(slotNo, itemWrapper)
  if nil == itemWrapper then
    return true
  end
  local itemSSW = itemWrapper:getStaticStatus():get()
  local equipSlotNo = itemWrapper:getStaticStatus():getEquipSlotNo()
  local isNotAccessories = false
  local isNotCashItem = true
  if 7 ~= equipSlotNo and 8 ~= equipSlotNo and 9 ~= equipSlotNo and 10 ~= equipSlotNo and 11 ~= equipSlotNo and 12 ~= equipSlotNo and 13 ~= equipSlotNo then
    isNotAccessories = true
  end
  if itemWrapper:getStaticStatus():isUsableServant() then
    isNotAccessories = true
  end
  if itemWrapper:getStaticStatus():isGuildStockable() then
    isNotAccessories = false
  end
  if itemWrapper:isCash() then
    isNotCashItem = false
  end
  local enchantDifficulty = itemWrapper:getStaticStatus():getEnchantDifficulty()
  if __eEnchantDifficulty_None == enchantDifficulty or __eEnchantDifficulty_NotExtractHard == enchantDifficulty then
    isNotAccessories = false
  end
  return false == (0 < itemSSW._key:getEnchantLevel() and itemSSW._key:getEnchantLevel() < 16 and isNotAccessories and isNotCashItem)
end
function PaGlobal_Extraction_Blackstone_All:setExtractionIcon(slotNo, itemWrapper)
  if nil == Panel_Window_Extraction_EnchantStone_All or nil == itemWrapper then
    return
  end
  local tempKey = itemWrapper:get():getKey()
  local staticStatus = itemWrapper:getStaticStatus()
  local itemEnchantStaticStatus = itemWrapper:getStaticStatus():get()
  local blackStone_Count = itemEnchantStaticStatus._key:getEnchantLevel()
  if nil == staticStatus or true == self._isAniStart then
    return
  end
  self._thisIsWeapone = itemEnchantStaticStatus:isWeapon() or itemEnchantStaticStatus:isSubWeapon() or itemEnchantStaticStatus:isAwakenWeapon()
  if self._thisIsWeapone then
    if blackStone_Count >= 8 then
      blackStone_Count = "?"
    end
  elseif blackStone_Count >= 6 then
    blackStone_Count = "?"
  end
  self._ui._icon_items:setItemByStaticStatus(staticStatus, Defines.s64_const.s64_1)
  if toInt64(0, 0) == blackStone_Count then
    blackStone_Count = toInt64(0, 1)
  end
  self._savedCount = blackStone_Count
  self._fromSlotNo = slotNo
  self._fromWhereType = CppEnums.ItemWhereType.eInventory
  self._fromSlotOn = true
  self._resultSlotOn = false
  self._resultSlotNo = -1
  self._resultWhereType = -1
  local prevStatic
  if itemWrapper:getStaticStatus():get():isWeapon() or itemWrapper:getStaticStatus():get():isSubWeapon() or itemWrapper:getStaticStatus():get():isAwakenWeapon() then
    prevStatic = getItemEnchantStaticStatus(ItemEnchantKey(16001))
    self._isWeapon = true
  else
    prevStatic = getItemEnchantStaticStatus(ItemEnchantKey(16002))
    self._isWeapon = false
  end
  self._ui._icon_result:clearItem()
  if prevStatic ~= nil then
    self._ui._icon_result:setItemByStaticStatus(prevStatic, blackStone_Count)
  end
  if false == self._isConsole then
    self._ui_pc.btn_extraction:SetEnable(true)
    self._ui_pc.btn_extraction:SetMonoTone(false)
  else
  end
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_Extraction_Blackstone_All:clear()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
  self._targetWhereType = -1
  self._targetSlotNo = -1
  self._ui._icon_items:clearItem()
  self._ui._icon_result:clearItem()
  self._currentTime = 0
  self._isAniStart = false
  if false == self._isConsole then
    self._ui_pc.btn_extraction:SetEnable(false)
    self._ui_pc.btn_extraction:SetMonoTone(false)
  else
  end
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_Extraction_Blackstone_All:setNotice()
  if nil == Panel_Window_Extraction_EnchantStone_All then
    return
  end
  self._ui.stc_leftBottomDese:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.stc_leftBottomDese:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_EXTRACTIONGUIDE"))
  if self._ui.stc_leftBottomDese:GetSizeY() < self._ui.stc_leftBottomDese:GetTextSizeY() then
    local sizeY = self._ui.stc_leftBottomDese:GetTextSizeY() - self._ui.stc_leftBottomDese:GetSizeY()
    self._ui.stc_leftBottomDese:SetSize(self._ui.stc_leftBottomDese:GetSizeX(), self._ui.stc_leftBottomDese:GetSizeY() + sizeY)
    Panel_Window_Extraction_EnchantStone_All:SetSize(Panel_Window_Extraction_EnchantStone_All:GetSizeX(), Panel_Window_Extraction_EnchantStone_All:GetSizeY() + sizeY)
    local leftBottomArea = UI.getChildControl(Panel_Window_Extraction_EnchantStone_All, "Static_LeftBottomDescArea")
    leftBottomArea:SetSize(leftBottomArea:GetSizeX(), leftBottomArea:GetSizeY() + sizeY)
    local rightArea = UI.getChildControl(Panel_Window_Extraction_EnchantStone_All, "Static_RightArea")
    rightArea:SetSize(rightArea:GetSizeX(), rightArea:GetSizeY() + sizeY)
    self._ui.list2_extractableItem:SetSize(self._ui.list2_extractableItem:GetSizeX(), self._ui.list2_extractableItem:GetSizeY() + sizeY)
    local leftBottomArea = UI.getChildControl(Panel_Window_Extraction_EnchantStone_All, "Static_LeftBottomButtonArea")
    leftBottomArea:ComputePos()
    leftBottomArea:ComputePos()
    rightArea:ComputePos()
    FromClient_Extraction_Blackstone_All_ReSizePanel()
  end
end
function PaGlobal_Extraction_Blackstone_All:getEnchantText(isEquipable, isCash, isAccessory, balksCnt, cronsCnt, enchantLev)
  local enchantText = ""
  if true == isEquipable and enchantLev > 0 and enchantLev < 16 then
    enchantText = "+" .. tostring(enchantLev)
  elseif true == isEquipable and 16 == enchantLev then
    enchantText = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1")
  elseif true == isEquipable and 17 == enchantLev then
    enchantText = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2")
  elseif true == isEquipable and 18 == enchantLev then
    enchantText = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3")
  elseif true == isEquipable and 19 == enchantLev then
    enchantText = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4")
  elseif true == isEquipable and 20 == enchantLev then
    enchantText = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5")
  else
    enchantText = ""
  end
  if true == isAccessory then
    if 1 == enchantLev then
      enchantText = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1")
    elseif 2 == enchantLev then
      enchantText = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2")
    elseif 3 == enchantLev then
      enchantText = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3")
    elseif 4 == enchantLev then
      enchantText = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4")
    elseif 5 == enchantLev then
      enchantText = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5")
    end
  end
  if true == isCash then
    enchantText = ""
  end
  if false == isCash and nil ~= balksCnt and toInt64(0, 0) ~= balksCnt and nil ~= cronsCnt and toInt64(0, 0) ~= cronsCnt then
    enchantText = ""
  end
  return enchantText
end

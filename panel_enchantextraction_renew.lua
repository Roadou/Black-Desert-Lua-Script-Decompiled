Panel_EnchantExtraction_Renew:SetShow(false)
Panel_EnchantExtraction_Renew:ActiveMouseEventEffect(true)
Panel_EnchantExtraction_Renew:setMaskingChild(true)
Panel_EnchantExtraction_Renew:setGlassBackground(true)
Panel_EnchantExtraction_Renew:RegisterShowEventFunc(true, "EnchantExtractionShowAni()")
Panel_EnchantExtraction_Renew:RegisterShowEventFunc(false, "EnchantExtractionHideAni()")
function EnchantExtractionShowAni()
end
function EnchantExtractionHideAni()
end
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local enchantExtraction = {
  control = {
    btn_Close = UI.getChildControl(Panel_EnchantExtraction_Renew, "Button_Close"),
    effect_Arrow = UI.getChildControl(Panel_EnchantExtraction_Renew, "Static_BackEffect"),
    effect_Process = UI.getChildControl(Panel_EnchantExtraction_Renew, "Static_ProcessEffect"),
    slot_1 = UI.getChildControl(Panel_EnchantExtraction_Renew, "equipIcon_1"),
    slot_2 = UI.getChildControl(Panel_EnchantExtraction_Renew, "equipIcon_2"),
    enchantCount = UI.getChildControl(Panel_EnchantExtraction_Renew, "StaticText_Slot2"),
    descBg = UI.getChildControl(Panel_EnchantExtraction_Renew, "Static_CommentBG"),
    stc_bottomBG = UI.getChildControl(Panel_EnchantExtraction_Renew, "Static_Bottom"),
    stc_extractionButtonArea = UI.getChildControl(Panel_EnchantExtraction_Renew, "Static_ExtractionButtonArea")
  },
  slotConfig = {createIcon = true, createBorder = true},
  _elapsTime = 4,
  _doExtraction = false,
  _blacksmithIcon = {},
  _balksIcon = {},
  _fromWhereType,
  _fromSlotNo,
  _selectSlotNo,
  _inventoryOpen = false
}
function enchantExtraction:Init()
  self.control.desc = UI.getChildControl(self.control.descBg, "StaticText_Desc")
  SlotItem.new(self._blacksmithIcon, "Static_Icon_1", 0, self.control.slot_1, self.slotConfig)
  self._blacksmithIcon:createChild()
  self._blacksmithIcon.icon:SetPosX(0)
  self._blacksmithIcon.icon:SetPosY(0)
  SlotItem.new(self._balksIcon, "Static_Icon_2", 0, self.control.slot_2, self.slotConfig)
  self._balksIcon:createChild()
  self._balksIcon.icon:SetPosX(0)
  self._balksIcon.icon:SetPosY(0)
  self.control.txt_exitKey = UI.getChildControl(self.control.stc_bottomBG, "StaticText_KeyGuideCancel_ConsoleUI")
  self.control.txt_selectKey = UI.getChildControl(self.control.stc_bottomBG, "StaticText_KeyGuideSelect_ConsoleUI")
  self.control.keyGuides = {
    self.control.txt_exitKey,
    self.control.txt_selectKey
  }
  self.control._txt_extractionButton = UI.getChildControl(self.control.stc_extractionButtonArea, "StaticText_ExtrationKey")
  self.control._txt_extractionButton:SetPosX(self.control.stc_extractionButtonArea:GetSizeX() / 2 - (self.control._txt_extractionButton:GetSizeX() + self.control._txt_extractionButton:GetTextSizeX() + 10) / 2)
  self.control.desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self.control.desc:SetText(self.control.desc:GetText())
  if 50 < self.control.desc:GetTextSizeY() then
    self.control.descBg:SetSize(self.control.descBg:GetSizeX(), self.control.desc:GetTextSizeY() + 10)
    Panel_EnchantExtraction_Renew:SetSize(Panel_EnchantExtraction_Renew:GetSizeX(), self.control.descBg:GetPosY() + self.control.descBg:GetSizeY() + 15)
    self.control.descBg:ComputePos()
    self.control.desc:ComputePos()
  end
  self.control.enchantCount:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
end
function HandleClicked_Extraction()
  local self = enchantExtraction
  if nil == self._selectSlotNo then
    return
  end
  local itemWrapper = getInventoryItemByType(self._fromWhereType, self._selectSlotNo)
  if nil == itemWrapper then
    return
  end
  local function goExtraction()
    self._doExtraction = true
    self.control.effect_Arrow:SetShow(true)
    self.control.effect_Arrow:AddEffect("fUI_Extraction01", false)
    audioPostEvent_SystemUi(5, 11)
    _AudioPostEvent_SystemUiForXBOX(5, 11)
    self._elapsTime = 0
  end
  local failCount = getSelfPlayer():get():getEnchantFailCount()
  local enchantParam1 = itemWrapper:getStaticStatus():getContentsEventParam1()
  local messageBoxMemo = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_MSGDESC", "enchantParam", enchantParam1, "failCount", failCount, "failCount2", failCount)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_MSGTITLE"),
    content = messageBoxMemo,
    functionYes = goExtraction,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function Panel_EnchantExtraction_Renew_Show()
  local self = enchantExtraction
  self:alignKeyGuides()
  if not Panel_EnchantExtraction_Renew:GetShow() then
    if _ContentsGroup_isUsedNewEnchant == false then
      PaGlobal_Enchant:show()
    end
    Panel_EnchantExtraction_Renew:SetShow(true)
    Inventory_SetFunctor(EnchantExtraction_Filter, EnchantExtraction_SetItem, nil, nil)
  end
  local failCount = getSelfPlayer():get():getEnchantFailCount()
  self.control.enchantCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_2", "count", "+" .. failCount))
  enchantExtraction:DataInit()
  if _ContentsGroup_isUsedNewEnchant == false then
    local isHave, isExistCash = PaGlobal_Enchant:SecretExtractionCheck()
    if isExistCash then
      FGlobal_CashInventoryOpen_ByEnchant()
    end
  end
  ToClient_padSnapSetTargetPanel(Panel_EnchantExtraction_Renew)
end
function enchantExtraction:alignKeyGuides()
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self.control.keyGuides, self.control.stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function enchantExtraction:DataInit()
  self._elapsTime = 4
  self._doExtraction = false
  self._selectSlotNo = nil
  self._fromWhereType = nil
  self._fromSlotNo = nil
  self._blacksmithIcon:clearItem()
  self._balksIcon:clearItem()
  self.control.effect_Arrow:EraseAllEffect()
  self._blacksmithIcon.icon:addInputEvent("Mouse_On", "")
  self._balksIcon.icon:addInputEvent("Mouse_On", "")
end
function EnchantExtraction_Filter(slotNo, itemWrappers, whereType)
  local self = enchantExtraction
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  local itemSSW = itemWrapper:getStaticStatus()
  local failCount = getSelfPlayer():get():getEnchantFailCount()
  if CppEnums.ContentsEventType.ContentsType_ConvertEnchantFailCountToItem == itemSSW:get():getContentsEventType() then
    local maxEnchantParam = itemSSW:getContentsEventParam1()
    return failCount > maxEnchantParam
  else
    return true
  end
end
function EnchantExtraction_SetItem(slotNo, itemWrapper, count, inventoryType)
  local self = enchantExtraction
  self._blacksmithIcon:setItem(itemWrapper)
  self._blacksmithIcon.icon:SetShow(true)
  self._selectSlotNo = slotNo
  local balksItemItemKey
  local failCount = getSelfPlayer():get():getEnchantFailCount()
  local itemFailCount = failCount
  if itemFailCount > 100 then
    balksItemItemKey = itemFailCount + 288900
  else
    balksItemItemKey = itemFailCount + 17799
  end
  local balsksItemSSW = getItemEnchantStaticStatus(ItemEnchantKey(balksItemItemKey))
  self._balksIcon:setItemByStaticStatus(balsksItemSSW, 1)
  self._blacksmithIcon.icon:addInputEvent("Mouse_On", "EnchantExtraction_IconOverShow(" .. 0 .. ")")
  self._blacksmithIcon.icon:addInputEvent("Mouse_Out", "EnchantExtraction_IconOverHide()")
  self._balksIcon.icon:addInputEvent("Mouse_On", "EnchantExtraction_IconOverShow(" .. 1 .. ")")
  self._balksIcon.icon:addInputEvent("Mouse_Out", "EnchantExtraction_IconOverHide()")
  self._fromWhereType = inventoryType
  self._fromSlotNo = slotNo
end
function Panel_EnchantExtraction_Renew_Close()
  Panel_EnchantExtraction_Renew:SetShow(false)
  if true == enchantExtraction._inventoryOpen then
    enchantExtraction._inventoryOpen = false
    Inventory_SetFunctor()
    return
  end
  if _ContentsGroup_isUsedNewEnchant == true then
    if true == PaGlobal_Enchant:isEnchantTab() then
      PaGlobal_Enchant:didShowEnchantTab(false)
    elseif true == PaGlobal_Enchant:isCronEnchantTab() then
      PaGlobal_Enchant:didShowCronEnchantTab()
    end
  else
    PaGlobal_Enchant:enchantFailCount()
  end
end
function FGlobal_EnchantExtraction_JustClose()
  Panel_EnchantExtraction_Renew:SetShow(false)
end
function EnchantExtraction_IconOverShow(controlId)
  local self = enchantExtraction
  local control
  if 0 == controlId then
    control = self._blacksmithIcon.icon
    local itemWrapper = getInventoryItemByType(self._fromWhereType, self._fromSlotNo)
    Panel_Tooltip_Item_Show(itemWrapper, control, false, true, nil, nil, nil)
  elseif 1 == controlId then
    control = self._balksIcon.icon
    local failCount = getSelfPlayer():get():getEnchantFailCount()
    local itemFailCount = failCount
    local balksItemItemKey
    if itemFailCount > 100 then
      balksItemItemKey = itemFailCount + 288900
    else
      balksItemItemKey = itemFailCount + 17799
    end
    local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(balksItemItemKey))
    Panel_Tooltip_Item_Show(itemSSW, control, true, false, nil, nil, nil)
  end
end
function EnchantExtraction_IconOverHide()
  Panel_Tooltip_Item_hideTooltip()
end
function FromClient_ConvertEnchantFailItemToCount(fromWhereType, fromSlotNo)
  local function doItemUse()
    ToClient_ConvertEnchantFailItemToCount(fromWhereType, fromSlotNo)
  end
  local failCount = getSelfPlayer():get():getEnchantFailCount()
  local itemWrapper = getInventoryItemByType(fromWhereType, fromSlotNo)
  if failCount > 0 then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_VALKS_NOUSE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_4"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    local messageBoxMemo = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_3", "failCount", failCount, "itemName", itemWrapper:getStaticStatus():getName())
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_4"),
      content = messageBoxMemo,
      functionYes = doItemUse,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function EnchantExtraction_updateTime(deltaTime)
  local self = enchantExtraction
  self._elapsTime = self._elapsTime + deltaTime
  if self._elapsTime > 3 then
    if false == self._doExtraction then
      return
    end
    self.control.effect_Arrow:SetShow(false)
    self.control.effect_Process:SetShow(false)
    self.control.slot_2:AddEffect("UI_ItemEnchant01", false, -5, -5)
    self._blacksmithIcon.icon:SetShow(false)
    self._doExtraction = false
    self._elapsTime = 0
    ToClient_ConvertEnchantFailCountToItem(self._fromWhereType, self._fromSlotNo)
    self.control.enchantCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_2", "count", "0"))
  end
end
function FromClient_ConvertEnchantFailCountToItemAck()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_5"))
  Panel_EnchantExtraction_Renew_Close()
end
function FromClient_ConvertEnchantFailItemToCountAck()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_6"))
  if false == _ContentsGroup_RenewUI_SpiritEnchant then
    if _ContentsGroup_isUsedNewEnchant == true then
      PaGlobal_Enchant:setEnchantFailCount()
    else
      PaGlobal_Enchant:enchantFailCount()
    end
  end
end
function FromClient_ConvertEnchantFailCountToItem(fromWhereType, fromSlotNo)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT"))
    return
  end
  local failCount = getSelfPlayer():get():getEnchantFailCount()
  if nil == failCount or failCount <= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CANNOT_ENCHANT_EXTRACTION"))
    return
  end
  enchantExtraction._inventoryOpen = true
  Panel_EnchantExtraction_Renew_Show()
  local itemWrapper = getInventoryItemByType(fromWhereType, fromSlotNo)
  EnchantExtraction_SetItem(fromSlotNo, itemWrapper, 1, fromWhereType)
end
function enchantExtraction:registerEvent()
  Panel_EnchantExtraction_Renew:RegisterUpdateFunc("EnchantExtraction_updateTime")
  registerEvent("FromClient_ConvertEnchantFailCountToItem", "FromClient_ConvertEnchantFailCountToItem")
  registerEvent("FromClient_ConvertEnchantFailItemToCount", "FromClient_ConvertEnchantFailItemToCount")
  registerEvent("FromClient_ConvertEnchantFailCountToItemAck", "FromClient_ConvertEnchantFailCountToItemAck")
  registerEvent("FromClient_ConvertEnchantFailItemToCountAck", "FromClient_ConvertEnchantFailItemToCountAck")
  self.control.btn_Close:addInputEvent("Mouse_LUp", "Panel_EnchantExtraction_Renew_Close()")
  Panel_EnchantExtraction_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_X, "HandleClicked_Extraction()")
end
enchantExtraction:Init()
enchantExtraction:registerEvent()

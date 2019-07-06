local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
Panel_FixEquip:setMaskingChild(true)
Panel_FixEquip:RegisterShowEventFunc(true, "FixEquip_ShowAni()")
Panel_FixEquip:RegisterShowEventFunc(false, "FixEquip_HideAni()")
PaGlobal_FixEquip = {
  _slotConfig = {
    createIcon = false,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true
  },
  _uiButtonApply = UI.getChildControl(Panel_FixEquip, "Button_Apply"),
  _uiButtonApplyCash = UI.getChildControl(Panel_FixEquip, "Button_CashItemUse"),
  _uiFixHelp = UI.getChildControl(Panel_FixEquip, "StaticText_HelpDesc"),
  _uiItemFix = UI.getChildControl(Panel_FixEquip, "RadioButton_OnlyItem"),
  _uiMoneyItemFix = UI.getChildControl(Panel_FixEquip, "RadioButton_ItemMoneyRecovery"),
  _uiEquipPrice = UI.getChildControl(Panel_FixEquip, "StaticText_EquipPrice"),
  _uiStreamRecovery = UI.getChildControl(Panel_FixEquip, "CheckButton_StreamRecovery"),
  _uiChkInven = UI.getChildControl(Panel_FixEquip, "RadioButton_Icon_Money"),
  _uiChkWarehouse = UI.getChildControl(Panel_FixEquip, "RadioButton_Icon_Money2"),
  _uiTxtInven = UI.getChildControl(Panel_FixEquip, "Static_Text_Money"),
  _uiTxtWarehouse = UI.getChildControl(Panel_FixEquip, "Static_Text_Money2"),
  _uiButtonQuestion = UI.getChildControl(Panel_FixEquip, "Button_Question"),
  _slot_0_Notice = UI.getChildControl(Panel_FixEquip, "StaticText_Notice_Slot_0"),
  _slot_1_Notice = UI.getChildControl(Panel_FixEquip, "StaticText_Notice_Slot_1"),
  _enduranceText = UI.getChildControl(Panel_FixEquip, "StaticText_UseLimit_endurance"),
  _enduranceGauge = UI.getChildControl(Panel_FixEquip, "Static_UseLimit_endurance_gage"),
  _enduranceMax = UI.getChildControl(Panel_FixEquip, "Progress2_MaxEndurance"),
  _enduranceGaugeValue = UI.getChildControl(Panel_FixEquip, "Progress_UseLimit_endurance_gage_value"),
  _enduranceValue = UI.getChildControl(Panel_FixEquip, "StaticText_UseLimit_endurance_value"),
  _enduranceIcon = UI.getChildControl(Panel_FixEquip, "Static_endurance_Icon"),
  _fixEquipData = {
    slotNoMain,
    whereTypeMain,
    whereTypeSub,
    itemKeySub
  },
  _slotMain = nil,
  _slotSub = nil,
  _slotMainTbl = {},
  _slotSubTbl = {},
  _s64_allWeight,
  _useCash,
  _onlyMoneyCheck = false,
  _moneyItemCheck = false,
  _onlyItemCheck,
  _memoryFlagRecoveryCount = 0
}
function PaGlobal_FixEquip:initialize()
  self._uiStreamRecovery:SetShow(true)
  self._uiStreamRecovery:SetEnableArea(0, 0, self._uiStreamRecovery:GetSizeX() + self._uiStreamRecovery:GetTextSizeX() + 10, self._uiStreamRecovery:GetSizeY())
  self._onlyItemCheck = self._uiItemFix:IsCheck()
  self._uiButtonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelFixEquip\" )")
  self._uiButtonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelFixEquip\", \"true\")")
  self._uiButtonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelFixEquip\", \"false\")")
  local btnButtonApplySizeX = self._uiButtonApply:GetSizeX() + 23
  local btnButtonApplyTextPosX = btnButtonApplySizeX - btnButtonApplySizeX / 2 - self._uiButtonApply:GetTextSizeX() / 2
  self._uiButtonApply:SetTextSpan(btnButtonApplyTextPosX, 5)
  local btnButtonApplyCashSizeX = self._uiButtonApplyCash:GetSizeX() + 23
  local btnButtonApplyCashTextPosX = btnButtonApplyCashSizeX - btnButtonApplyCashSizeX / 2 - self._uiButtonApplyCash:GetTextSizeX() / 2
  self._uiButtonApplyCash:SetTextSpan(btnButtonApplyCashTextPosX, 5)
  self._enduranceGaugeValue:SetAniSpeed(0)
  self._enduranceMax:SetAniSpeed(0)
  self._enduranceText:SetShow(false)
  self._enduranceGauge:SetShow(false)
  self._enduranceMax:SetShow(false)
  self._enduranceGaugeValue:SetShow(false)
  self._enduranceValue:SetShow(false)
  self._enduranceIcon:SetShow(false)
end
function PaGlobal_FixEquip:fixEquip_FixHelp()
  self._uiFixHelp:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._uiFixHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_FIXHELP"))
  self._uiFixHelp:SetSize(self._uiFixHelp:GetSizeX(), self._uiFixHelp:GetTextSizeY() + 10)
  Panel_FixEquip:SetSize(Panel_FixEquip:GetSizeX(), self._uiFixHelp:GetTextSizeY() + 570)
end
function PaGlobal_FixEquip:fixEquip_clearData()
  self._slotMain:clearItem()
  self._slotMain.empty = true
  self._slotMain.whereType = nil
  self._slotMain.slotNo = nil
  self._slotMain.itemKey = nil
  self._slotSub:clearItem()
  self._slotSub.empty = true
  self._slotSub.whereType = nil
  self._slotSub.slotNo = nil
  self._slotSub.itemKey = nil
  self._uiButtonApply:SetIgnore(true)
  self._uiButtonApply:SetMonoTone(true)
  self._uiButtonApply:SetEnable(false)
  self._uiButtonApply:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_REPAIR_MAXENDURANCE"))
  self._uiButtonApply:SetAlpha(0.85)
  self._uiButtonApplyCash:SetMonoTone(true)
  self._uiButtonApplyCash:SetAlpha(0.85)
  self._enduranceText:SetShow(false)
  self._enduranceGauge:SetShow(false)
  self._enduranceMax:SetShow(false)
  self._enduranceGaugeValue:SetShow(false)
  self._enduranceValue:SetShow(false)
  self._enduranceIcon:SetShow(false)
  PaGlobal_FixEquip:fixEquip_MouseEvent_OutSlots_Done(true)
end
function PaGlobal_FixEquip:fixEquip_clearDataOnlySub()
  self._slotSub:clearItem()
  self._slotSub.empty = true
  self._slotSub.whereType = nil
  self._slotSub.slotNo = nil
  self._slotSub.itemKey = nil
  self._uiButtonApply:SetIgnore(true)
  self._uiButtonApply:SetMonoTone(true)
  self._uiButtonApply:SetEnable(false)
  self._uiButtonApply:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_REPAIR_MAXENDURANCE"))
  self._uiButtonApply:SetAlpha(0.85)
  self._uiButtonApplyCash:SetMonoTone(true)
  self._uiButtonApplyCash:SetAlpha(0.85)
  PaGlobal_FixEquip:fixEquip_MouseEvent_OutSlots_Done(false)
end
function PaGlobal_FixEquip:fixEquip_clearDataStreamRecovery(isOn, str)
  _PA_LOG("\236\154\177", "PaGlobal_FixEquip:fixEquip_clearDataStreamRecovery( isOn ) " .. tostring(isOn) .. " - " .. tostring(str))
  if isOn then
    self._uiStreamRecovery:SetIgnore(false)
    self._uiStreamRecovery:SetMonoTone(false)
    self._uiStreamRecovery:SetEnable(true)
    self._uiStreamRecovery:SetAlpha(1)
  else
    self._uiStreamRecovery:SetIgnore(true)
    self._uiStreamRecovery:SetMonoTone(true)
    self._uiStreamRecovery:SetEnable(false)
    self._uiStreamRecovery:SetAlpha(0.85)
    self._uiStreamRecovery:SetCheck(false)
  end
end
function PaGlobal_FixEquip:fixEquip_MouseEvent_OutSlots_Done(isDone)
  if isDone == true then
    self._slotMain.icon:addInputEvent("Mouse_RUp", "PaGlobal_FixEquip:fixEquip_OutSlots( true )")
    self._slotSub.icon:addInputEvent("Mouse_RUp", "PaGlobal_FixEquip:fixEquip_OutSlots( false )")
  else
    self._slotSub.icon:addInputEvent("Mouse_RUp", "PaGlobal_FixEquip:fixEquip_OutSlots( false )")
  end
end
function PaGlobal_FixEquip:fixEquip_createControl()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local invenMoney = selfPlayer:get():getInventory():getMoney_s64()
  self._slotMainTbl.icon = UI.getChildControl(Panel_FixEquip, "Static_Slot_0")
  SlotItem.new(self._slotMainTbl, "Slot_0", 0, Panel_FixEquip, self._slotConfig)
  self._slotMainTbl:createChild()
  self._slotMainTbl.empty = true
  self._slotMainTbl.icon:addInputEvent("Mouse_On", "PaGlobal_FixEquip:panel_FixEquipMouseOnEvent(0, \"FixEquip\", true)")
  self._slotMainTbl.icon:addInputEvent("Mouse_Out", "PaGlobal_FixEquip:panel_FixEquipMouseOnEvent(0, \"FixEquip\", false)")
  Panel_Tooltip_Item_SetPosition(0, self._slotMainTbl, "FixEquip")
  self._slotMain = self._slotMainTbl
  self._slotSubTbl.icon = UI.getChildControl(Panel_FixEquip, "Static_Slot_1")
  SlotItem.new(self._slotSubTbl, "Slot_1", 1, Panel_FixEquip, self._slotConfig)
  self._slotSubTbl:createChild()
  self._slotSubTbl.empty = true
  self._slotSubTbl.icon:addInputEvent("Mouse_On", "PaGlobal_FixEquip:panel_FixEquipMouseOnEvent(1, \"FixEquip\", true)")
  self._slotSubTbl.icon:addInputEvent("Mouse_Out", "PaGlobal_FixEquip:panel_FixEquipMouseOnEvent(1, \"FixEquip\", false)")
  Panel_Tooltip_Item_SetPosition(1, self._slotSubTbl, "FixEquip")
  self._slotSub = self._slotSubTbl
  if isGameTypeEnglish() then
    self._uiItemFix:SetSpanSize(-165, 220)
    self._uiMoneyItemFix:SetSpanSize(-165, 245)
  else
    self._uiItemFix:SetSpanSize(-20, 210)
    self._uiMoneyItemFix:SetSpanSize(-20, 240)
  end
  self._uiTxtInven:SetText(makeDotMoney(invenMoney))
  self._uiTxtWarehouse:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
  self._uiItemFix:SetCheck(true)
  PaGlobal_FixEquip:fixEquip_clearData()
end
function PaGlobal_FixEquip:panel_FixEquipMouseOnEvent(index, type, isMouseOn)
  if self._slotMainTbl.empty then
    if index == 0 then
      if isMouseOn == true then
        self._slot_1_Notice:SetShow(true)
        self._slot_1_Notice:SetTextMode(UI_TM.eTextMode_AutoWrap)
        self._slot_1_Notice:SetAutoResize(true)
        self._slot_1_Notice:SetSize(220, 86)
        self._slot_1_Notice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_REPAIR_MAXENDURANCE_GUIDE1"))
        self._slot_1_Notice:SetSize(self._slot_1_Notice:GetSizeX() + 5, self._slot_1_Notice:GetSizeY() + 30)
      else
        self._slot_1_Notice:SetShow(false)
      end
    end
  else
    Panel_Tooltip_Item_Show_GeneralNormal(index, type, isMouseOn)
  end
  if self._slotSubTbl.empty then
    if index == 1 then
      if isMouseOn == true then
        self._slot_0_Notice:SetShow(true)
        self._slot_0_Notice:SetTextMode(UI_TM.eTextMode_AutoWrap)
        self._slot_0_Notice:SetAutoResize(true)
        self._slot_0_Notice:SetSize(220, 86)
        self._slot_0_Notice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_GETITEM"))
        self._slot_0_Notice:SetSize(self._slot_0_Notice:GetSizeX() + 5, self._slot_0_Notice:GetSizeY() + 30)
      else
        self._slot_0_Notice:SetShow(false)
      end
    end
  else
    Panel_Tooltip_Item_Show_GeneralNormal(index, type, isMouseOn)
  end
end
function PaGlobal_FixEquip:isReadyToReapirMaxEndurance()
  if nil == self._slotMain.slotNo then
    return false
  end
  if nil == self._slotSub.slotNo then
    return false
  end
  return true
end
function PaGlobal_FixEquip:isCheckSlot()
  if nil == self._slotMain.slotNo then
    return false
  end
  return true
end
function PaGlobal_FixEquip:useCashBtnEffectDelete()
  self._uiButtonApplyCash:EraseAllEffect()
  self._uiButtonApplyCash:SetMonoTone(true)
  self._uiButtonApplyCash:SetAlpha(0.85)
  self._uiButtonApplyCash:addInputEvent("Mouse_LUp", "")
  local hasCashItem = doHaveContentsItem(27, 0, false)
  local isReady = PaGlobal_FixEquip:isReadyToReapirMaxEndurance()
  if isReady == true then
    self._uiButtonApply:SetIgnore(false)
    self._uiButtonApply:SetMonoTone(false)
    self._uiButtonApply:SetEnable(true)
    self._uiButtonApply:SetAlpha(1)
    self._uiButtonApply:addInputEvent("Mouse_LUp", "PaGlobal_FixEquip:fixEquip_ApplyButton( false )")
    if true == hasCashItem then
      self._uiButtonApplyCash:SetMonoTone(false)
      self._uiButtonApplyCash:SetAlpha(1)
      self._uiButtonApplyCash:addInputEvent("Mouse_LUp", "PaGlobal_FixEquip:fixEquip_ApplyButton( true )")
    else
      self._uiButtonApplyCash:addInputEvent("Mouse_LUp", "PaGlobal_EasyBuy:Open( 7 )")
    end
  else
    self._uiButtonApply:EraseAllEffect()
    self._uiButtonApply:SetIgnore(true)
    self._uiButtonApply:SetMonoTone(true)
    self._uiButtonApply:SetEnable(false)
    self._uiButtonApply:SetAlpha(0.85)
    if true == hasCashItem then
      self._uiButtonApplyCash:addInputEvent("Mouse_LUp", "")
    else
      self._uiButtonApplyCash:addInputEvent("Mouse_LUp", "PaGlobal_EasyBuy:Open(7)")
    end
    self._uiButtonApply:addInputEvent("Mouse_LUp", "")
  end
end
function PaGlobal_FixEquip:isFixEquip_SubSlotItemKey()
  return self._fixEquipData.itemKeySub
end
function PaGlobal_FixEquip:isRepeatRepair()
  return self._uiStreamRecovery:IsCheck()
end
function PaGlobal_FixEquip:fixEquipContinue(slotNo)
  local selfPlayer = getSelfPlayer()
  local mainItemWrapper = getInventoryItemByType(self._fixEquipData.whereTypeMain, self._fixEquipData.slotNoMain)
  if nil == mainItemWrapper then
    return
  end
  if nil == selfPlayer then
    return
  end
  local invenMoney = selfPlayer:get():getInventory():getMoney_s64()
  if self._useCash then
    local doHaveCashItem = doHaveContentsItem(27, 0, false)
    if not doHaveCashItem and self._useCash then
      self._uiButtonApplyCash:EraseAllEffect()
      self._uiButtonApplyCash:SetMonoTone(true)
      self._uiButtonApplyCash:SetAlpha(0.85)
      self._uiButtonApplyCash:addInputEvent("Mouse_LUp", "PaGlobal_EasyBuy:Open(7)")
      return
    end
  end
  if getSelfPlayer():get():getCurrentWeight_s64() < self._s64_allWeight then
    self._s64_allWeight = getSelfPlayer():get():getCurrentWeight_s64()
  else
    return
  end
  local moneyWhereType = CppEnums.ItemWhereType.eInventory
  if self._uiChkInven:IsCheck() then
    moneyWhereType = CppEnums.ItemWhereType.eInventory
  else
    moneyWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  if mainItemWrapper:checkToRepairItemMaxEndurance() then
    repair_MaxEndurance(self._fixEquipData.whereTypeMain, self._fixEquipData.slotNoMain, self._fixEquipData.whereTypeSub, slotNo, moneyWhereType, self._useCash)
  else
    PaGlobal_FixEquip:fixEquipData_Clear()
  end
end
function PaGlobal_FixEquip:fixEquipData_Clear()
  self._fixEquipData.slotNoMain = nil
  self._fixEquipData.whereTypeMain = nil
  self._fixEquipData.whereTypeSub = nil
  self._fixEquipData.itemKeySub = nil
  self._s64_allWeight = nil
  self._useCash = nil
end
function PaGlobal_FixEquip:fGlobal_closeFix()
  if true == Panel_FixEquip:GetShow() then
    self._uiButtonApply:EraseAllEffect()
    local savedSubSlotNo = self._slotSub.slotNo
    local savedMainSlotNo = self._slotMain.slotNo
    if nil == savedMainSlotNo then
      return
    end
    local itemMainWrapper = getInventoryItem(savedMainSlotNo)
    local mainSlotEndurance = FixEquip_InvenFiler_MainItem(self._slotMain.slotNo, itemMainWrapper)
    if true == mainSlotEndurance and nil ~= savedMainSlotNo then
      PaGlobal_FixEquip:fixEquip_clearData()
      Inventory_SetFunctor(FixEquip_InvenFiler_MainItem, Panel_FixEquip_InteractortionFromInventory, FixEquip_CloseButton, nil)
      return
    end
    if nil == savedSubSlotNo then
      return
    end
    local inventory = getSelfPlayer():get():getInventory()
    local inventoryType = Inventory_GetCurrentInventoryType()
    local itemWrapper = getInventoryItem(savedSubSlotNo)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      local itemKey = itemSSW:get()._key
      local itemCount = inventory:getItemCount_s64(itemKey)
      self._slotSub:setItem(itemWrapper)
    else
      self._slotSub:clearItem()
      self._slotSub.empty = true
      PaGlobal_FixEquip:fixEquip_clearDataOnlySub()
    end
  end
end
function PaGlobal_FixEquip:fixEquipItem_registEventHandler()
  local self = PaGlobal_FixEquip
  self._uiItemFix:addInputEvent("Mouse_LUp", "PaGlobal_FixEquip:handleClicked_FixType( 1 )")
  self._uiMoneyItemFix:addInputEvent("Mouse_LUp", "PaGlobal_FixEquip:handleClicked_FixType( 2 )")
  self._uiMoneyItemFix:addInputEvent("Mouse_On", "FixEquip_SimpleTooltips( true, 0 )")
  self._uiMoneyItemFix:addInputEvent("Mouse_Out", "FixEquip_SimpleTooltips( false )")
  self._uiItemFix:addInputEvent("Mouse_On", "FixEquip_SimpleTooltips( true, 1 )")
  self._uiItemFix:addInputEvent("Mouse_Out", "FixEquip_SimpleTooltips( false )")
  self._uiButtonApplyCash:addInputEvent("Mouse_On", "FixEquip_SimpleTooltips( true, 2 )")
  self._uiButtonApplyCash:addInputEvent("Mouse_Out", "FixEquip_SimpleTooltips( false )")
  self._uiStreamRecovery:addInputEvent("Mouse_On", "FixEquip_SimpleTooltips( true, 3 )")
  self._uiStreamRecovery:addInputEvent("Mouse_Out", "FixEquip_SimpleTooltips( false )")
  self._enduranceIcon:addInputEvent("Mouse_On", "FixEquip_SimpleTooltips( true, 4 )")
  self._enduranceIcon:addInputEvent("Mouse_Out", "FixEquip_SimpleTooltips( false, 4 )")
end
function PaGlobal_FixEquip:handleClicked_FixType(fixType)
  local self = PaGlobal_FixEquip
  if 1 == fixType then
    self._onlyItemCheck = self._uiItemFix:IsCheck()
    self._onlyMoneyCheck = false
    self._moneyItemCheck = false
    self._uiFixHelp:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._uiFixHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_ITEMFIX_HELP"))
    self._uiStreamRecovery:SetCheck(false)
    PaGlobal_FixEquip:fixEquip_CancelButton()
  elseif 2 == fixType then
    self._moneyItemCheck = self._uiMoneyItemFix:IsCheck()
    self._onlyMoneyCheck = false
    self._onlyItemCheck = false
    self._uiFixHelp:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._uiFixHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_MONEYITEMFIX_HELP"))
    self._uiStreamRecovery:SetCheck(false)
    PaGlobal_FixEquip:fixEquip_CancelButton()
  end
end
function PaGlobal_FixEquip:StreamRecoveryStop()
  self._uiStreamRecovery:SetCheck(false)
end
function FixEquip_SimpleTooltips(isShow, fixType)
  local self = PaGlobal_FixEquip
  local name, desc, uiControl
  if 0 == fixType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_TOOLTIP_MONEYITEM_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_TOOLTIP_MONEYITEM_DESC")
    uiControl = self._uiMoneyItemFix
  elseif 1 == fixType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_TOOLTIP_ONLYITEM_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_TOOLTIP_ONLYITEM_DESC")
    uiControl = self._uiItemFix
  elseif 2 == fixType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_TOOLTIP_APPLYCASH_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_TOOLTIP_APPLYCASH_DESC")
    uiControl = self._uiButtonApplyCash
  elseif 3 == fixType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_STREAMRECOVERY_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_STREAMRECOVERY_TOOLTIP_DESC")
    uiControl = self._uiStreamRecovery
  elseif 4 == fixType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_ENDURANCE_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_ENDURANCE_TOOLTIP_DESC")
    uiControl = self._enduranceIcon
  end
  if isShow == true then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
PaGlobal_FixEquip:initialize()
PaGlobal_FixEquip:fixEquip_FixHelp()
PaGlobal_FixEquip:fixEquip_createControl()
PaGlobal_FixEquip:fixEquipItem_registEventHandler()

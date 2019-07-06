function Panel_FixEquip_InteractortionFromInventory(slotNo, itemWrapper, count, inventoryType)
  local self = PaGlobal_FixEquip
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  if nil == itemWrapper then
    return
  end
  if Panel_FixEquip:GetShow() and false == self._checkHasItemJewel and false == self._slotMain.empty and true == self._slotSub.empty and true == Panel_FixEquip_checkHasItemJewel(slotNo, itemWrapper, count, inventoryType) then
    PaGlobal_FixEquip._checkHasItemJewel = false
    return
  end
  self._checkHasItemJewel = false
  self._enduranceGauge:SetShow(true)
  self._enduranceMax:SetShow(true)
  self._enduranceGaugeValue:SetShow(true)
  self._enduranceValue:SetShow(true)
  if self._slotMain.empty then
    self._slotMain:setItem(itemWrapper)
    self._slotMain.empty = false
    self._slotMain.whereType = inventoryType
    self._slotMain.slotNo = slotNo
    self._slotMain.itemKey = itemWrapper:get():getKey()
    local maxEndurance = itemWrapper:getStaticStatus():get():getMaxEndurance()
    local dynamicMaxEndurance = itemWrapper:get():getMaxEndurance()
    local endurance = itemWrapper:get():getEndurance()
    self._memoryCrystalRecoveryCount = itemWrapper:getRepairMaxEnduranceCount()
    self._memoryFlagRecoveryCount = itemWrapper:getStaticStatus():get()._repairEnduranceCount
    self._enduranceGaugeValue:SetAniSpeed(0)
    self._enduranceMax:SetAniSpeed(0)
    self._enduranceGaugeValue:SetProgressRate(endurance / maxEndurance * 100)
    self._enduranceMax:SetProgressRate(dynamicMaxEndurance / maxEndurance * 100)
    self._enduranceValue:SetText(endurance .. " / " .. dynamicMaxEndurance .. "  [" .. maxEndurance .. "]")
    Inventory_SetFunctor(FixEquip_InvenFiler_SubItem, Panel_FixEquip_InteractortionFromInventory, FixEquip_Close, nil)
    self._uiEquipPrice:SetShow(false)
  elseif self._slotSub.empty then
    self._slotSub:setItem(itemWrapper)
    self._enduranceText:SetShow(true)
    self._enduranceIcon:SetShow(true)
    self._slotSub.empty = false
    self._slotSub.whereType = inventoryType
    self._slotSub.slotNo = slotNo
    self._slotSub.itemKey = itemWrapper:get():getKey():getItemKey()
    if 44195 == self._slotSub.itemKey then
      self._enduranceText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FIXEQUIP_RECOVERYCOUNT", "count", tostring(self._memoryFlagRecoveryCount)))
    elseif 9750 == self._slotSub.itemKey then
      self._enduranceText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FIXEQUIP_RECOVERYCOUNT", "count", tostring(5)))
    elseif 721008 == self._slotSub.itemKey or 721031 == self._slotSub.itemKey then
      self._enduranceText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FIXEQUIP_RECOVERYCOUNT", "count", tostring(self._memoryCrystalRecoveryCount)))
    else
      self._enduranceText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FIXEQUIP_RECOVERYCOUNT", "count", tostring(10)))
    end
    if self._moneyItemCheck then
      local fixEquipPrice = itemWrapper:getMoneyToRepairItemMaxEndurance(self._slotMain.itemKey)
      if fixEquipPrice > toInt64(0, 0) then
        self._uiEquipPrice:SetShow(true)
        self._uiEquipPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FIXEQUIP_NEEDMONEY", "fixEquipPrice", makeDotMoney(fixEquipPrice)))
      else
        self._uiEquipPrice:SetShow(false)
      end
    else
      self._uiEquipPrice:SetShow(false)
    end
  else
    UI.ASSERT(false, "Client data, UI data is Mismatch!!!!!")
    return
  end
  self._uiButtonApplyCash:EraseAllEffect()
  self._uiButtonApplyCash:SetMonoTone(true)
  self._uiButtonApplyCash:SetAlpha(0.85)
  local hasCashItem = doHaveContentsItem(27, 0, false)
  if hasCashItem then
    self._uiButtonApplyCash:addInputEvent("Mouse_LUp", "")
  else
    self._uiButtonApplyCash:addInputEvent("Mouse_LUp", "PaGlobal_EasyBuy:Open( 7 )")
  end
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
    PaGlobal_FixEquip:fixEquip_clearDataStreamRecovery(true, "Panel_FixEquip_InteractortionFromInventory")
  else
    self._uiButtonApply:EraseAllEffect()
    self._uiButtonApply:SetIgnore(true)
    self._uiButtonApply:SetMonoTone(true)
    self._uiButtonApply:SetEnable(false)
    self._uiButtonApply:SetAlpha(0.85)
    self._uiButtonApply:addInputEvent("Mouse_LUp", "")
  end
  PaGlobal_FixEquip:fixEquip_MouseEvent_OutSlots_Done(true)
end
function PaGlobal_FixEquip:fixEquipMoneyUpdate()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if not Panel_FixEquip:IsShow() then
    return
  end
  local invenMoney = selfPlayer:get():getInventory():getMoney_s64()
  PaGlobal_FixEquip._uiTxtInven:SetText(makeDotMoney(invenMoney))
  PaGlobal_FixEquip._uiTxtWarehouse:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
  if self._slotMain.whereType == nil then
    return
  end
  if self._slotMain.slotNo == nil then
    return
  end
  local itemWrapper = getInventoryItemByType(self._slotMain.whereType, self._slotMain.slotNo)
  if nil == itemWrapper then
    self._enduranceText:SetShow(false)
    self._enduranceGauge:SetShow(false)
    self._enduranceMax:SetShow(false)
    self._enduranceGaugeValue:SetShow(false)
    self._enduranceValue:SetShow(false)
    self._enduranceIcon:SetShow(false)
    return
  end
  local maxEndurance = itemWrapper:getStaticStatus():get():getMaxEndurance()
  local dynamicMaxEndurance = itemWrapper:get():getMaxEndurance()
  local endurance = itemWrapper:get():getEndurance()
  self._enduranceMax:SetAniSpeed(1)
  self._enduranceMax:SetProgressRate(dynamicMaxEndurance / maxEndurance * 100)
  self._enduranceGaugeValue:SetAniSpeed(1)
  self._enduranceGaugeValue:SetProgressRate(endurance / maxEndurance * 100)
  self._enduranceValue:SetText(endurance .. " / " .. dynamicMaxEndurance .. "  [" .. maxEndurance .. "]")
  if maxEndurance <= dynamicMaxEndurance then
    self._enduranceText:SetShow(false)
    self._enduranceGauge:SetShow(false)
    self._enduranceMax:SetShow(false)
    self._enduranceGaugeValue:SetShow(false)
    self._enduranceValue:SetShow(false)
    self._enduranceIcon:SetShow(false)
  end
end
function PaGlobal_FixEquip:fixEquip_ApplyButton(isHelpRepair)
  local funcYesExe
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local dontFix = function()
    PaGlobal_FixEquip:fGlobal_closeFix()
    return
  end
  local moneyWhereType = CppEnums.ItemWhereType.eInventory
  if self._uiChkInven:IsCheck() then
    moneyWhereType = CppEnums.ItemWhereType.eInventory
  else
    moneyWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  local function doFixEquipMaxEndurance()
    self._fixEquipData.slotNoMain = self._slotMain.slotNo
    self._fixEquipData.whereTypeMain = self._slotMain.whereType
    self._fixEquipData.whereTypeSub = self._slotSub.whereType
    self._fixEquipData.itemKeySub = self._slotSub.itemKey
    self._s64_allWeight = getSelfPlayer():get():getCurrentWeight_s64()
    self._useCash = isHelpRepair
    repair_MaxEndurance(self._slotMain.whereType, self._slotMain.slotNo, self._slotSub.whereType, self._slotSub.slotNo, moneyWhereType, isHelpRepair)
    self:fixEquipMoneyUpdate()
    return
  end
  local function doFixEquipOnlyMoney()
    repair_MaxEndurance(self._slotMain.whereType, self._slotMain.slotNo, 0, 0, isHelpRepair)
    self:fixEquipMoneyUpdate()
    PaGlobal_FixEquip:fGlobal_closeFix()
    return
  end
  local function doFixEquipMoneyItem()
    self._fixEquipData.slotNoMain = self._slotMain.slotNo
    self._fixEquipData.whereTypeMain = self._slotMain.whereType
    self._fixEquipData.whereTypeSub = self._slotSub.whereType
    self._fixEquipData.itemKeySub = self._slotSub.itemKey
    self._s64_allWeight = getSelfPlayer():get():getCurrentWeight_s64()
    self._useCash = isHelpRepair
    repair_MaxEndurance(self._slotMain.whereType, self._slotMain.slotNo, self._slotSub.whereType, self._slotSub.slotNo, moneyWhereType, isHelpRepair)
    self:fixEquipMoneyUpdate()
    return
  end
  funcYesExe = doFixEquipMoneyItem
  if nil ~= self._slotMain.slotNo and nil ~= self._slotSub.slotNo then
    local hasCashItem = doHaveContentsItem(27, 0, false)
    if false == hasCashItem and true == isHelpRepair then
      self._uiButtonApplyCash:EraseAllEffect()
      self._uiButtonApplyCash:SetMonoTone(true)
      self._uiButtonApplyCash:SetAlpha(0.85)
      self._uiButtonApplyCash:addInputEvent("Mouse_LUp", "PaGlobal_EasyBuy:Open( 7 )")
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_USECASHALL"))
      return
    end
    local itemWrapper = getInventoryItemByType(self._slotMain.whereType, self._slotMain.slotNo)
    local memoryFlagRecoveryCount = itemWrapper:getStaticStatus():get()._repairEnduranceCount
    local memoryFlagCrystalRecoverycount = itemWrapper:getRepairMaxEnduranceCount()
    local isMemoryFlag = self._slotSub.itemKey == 44195
    local isDriganFlag = self._slotSub.itemKey == 9750
    local isCrystalFlag = 721008 == self._slotSub.itemKey or 721031 == self._slotSub.itemKey
    local maxEndurance
    local currentEndurance = itemWrapper:get():getEndurance()
    if false == itemWrapper:getStaticStatus():get():isUnbreakable() then
      maxEndurance = itemWrapper:getStaticStatus():get():getMaxEndurance()
    end
    if self._onlyItemCheck then
      if isMemoryFlag and true == isHelpRepair then
        contentString = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_ONLYITEMCHECK_CONTENTSTRING") .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FIXEQUIP_CONTROL_MAXENDURANCERECOVERYCOUNT", "count", memoryFlagRecoveryCount * 4)
      elseif isMemoryFlag and false == isHelpRepair then
        contentString = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_ONLYITEMCHECK_CONTENTSTRING") .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FIXEQUIP_CONTROL_MAXENDURANCERECOVERYCOUNT", "count", memoryFlagRecoveryCount)
      elseif isDriganFlag and true == isHelpRepair then
        contentString = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_ONLYITEMCHECK_CONTENTSTRING") .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FIXEQUIP_CONTROL_MAXENDURANCERECOVERYCOUNT", "count", tostring(20))
      elseif isDriganFlag and false == isHelpRepair then
        contentString = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_ONLYITEMCHECK_CONTENTSTRING") .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FIXEQUIP_CONTROL_MAXENDURANCERECOVERYCOUNT", "count", tostring(5))
      elseif isCrystalFlag then
        local recoveryCount = memoryFlagCrystalRecoverycount
        if isHelpRepair then
          recoveryCount = math.min(100, memoryFlagCrystalRecoverycount * 4)
        end
        contentString = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_ONLYITEMCHECK_CONTENTSTRING") .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FIXEQUIP_CONTROL_MAXENDURANCERECOVERYCOUNT", "count", tostring(recoveryCount))
      elseif isHelpRepair then
        contentString = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_ONLYITEMCHECK_CONTENTSTRING") .. PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_CONTROL_MAXENDURANCERECOVERY_FIX_COUNT_30")
      else
        contentString = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_ONLYITEMCHECK_CONTENTSTRING") .. PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_CONTROL_MAXENDURANCERECOVERY_FIX_COUNT_10")
      end
    elseif self._moneyItemCheck then
      contentString = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_MONEYITEMCHECK_CONTENTSTRING")
    end
    if true == isHelpRepair and maxEndurance - currentEndurance < 15 then
      contentString = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_DURABILITY_SHORTAGE") .. contentString
    end
    local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
    local messageboxData = {
      title = titleString,
      content = contentString,
      functionYes = funcYesExe,
      functionCancel = dontFix,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    PaGlobal_FixEquip:fGlobal_closeFix()
  end
end
function FixEquip_InvenFiler_MainItem(slotNo, itemWrapper)
  local self = PaGlobal_FixEquip
  if nil == itemWrapper then
    return true
  end
  isAble = itemWrapper:checkToRepairItemMaxEndurance()
  return not isAble
end
function FixEquip_InvenFiler_SubItem(slotNo, itemWrapper, inventoryType)
  local self = PaGlobal_FixEquip
  if nil == itemWrapper then
    return true
  end
  local isAble = false
  local repairItemKey = self._slotMain.itemKey
  if nil == repairItemKey then
    return true
  end
  if itemWrapper:checkToRepairItemMaxEnduranceWithMoneyAndItem(repairItemKey) and (self._slotMain.slotNo ~= slotNo or self._slotMain.whereType ~= inventoryType) then
    isAble = true
  end
  return not isAble
end
function PaGlobal_FixEquip:fixEquip_GetMainSlotNo()
  return self._slotMain.slotNo
end
function PaGlobal_FixEquip:fixEquip_GetSubSlotNo()
  return self._slotSub.slotNo
end
function PaGlobal_FixEquip:fixEquip_OutSlots(outSlotType)
  if true == outSlotType then
    PaGlobal_FixEquip:fixEquip_clearData()
    Inventory_SetFunctor(FixEquip_InvenFiler_MainItem, Panel_FixEquip_InteractortionFromInventory, FixEquip_CloseButton, nil)
    self._enduranceText:SetShow(false)
    self._enduranceGauge:SetShow(false)
    self._enduranceMax:SetShow(false)
    self._enduranceGaugeValue:SetShow(false)
    self._enduranceValue:SetShow(false)
    self._enduranceIcon:SetShow(false)
  else
    PaGlobal_FixEquip:fixEquip_clearDataOnlySub()
  end
  self._uiEquipPrice:SetShow(false)
  PaGlobal_FixEquip:fixEquip_clearDataStreamRecovery(false, "fixEquip_OutSlots")
  self._enduranceText:SetShow(false)
  self._enduranceIcon:SetShow(false)
end
function PaGlobal_FixEquip:fixEquip_Show()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local invenMoney = selfPlayer:get():getInventory():getMoney_s64()
  PaGlobal_FixEquip:fixEquip_clearData()
  if Panel_FixEquip:IsShow() == false then
    Panel_FixEquip:SetShow(true, false)
    Inventory_SetFunctor(FixEquip_InvenFiler_MainItem, Panel_FixEquip_InteractortionFromInventory, FixEquip_CloseButton, nil)
    InventoryWindow_Show()
    Inventory_PosLoadMemory()
    Panel_Window_Inventory:SetPosX(getScreenSizeX() - Panel_Window_Inventory:GetSizeX())
    Panel_Equipment:SetPosX(10)
    PaGlobal_FixEquip:fixEquip_FixHelp()
    audioPostEvent_SystemUi(1, 0)
  else
    self:fixEquipExit()
  end
  self._uiChkInven:SetCheck(false)
  self._uiChkWarehouse:SetCheck(true)
  self._uiTxtInven:SetText(makeDotMoney(invenMoney))
  self._uiTxtWarehouse:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
  self._checkHasItemJewel = false
  PaGlobal_FixEquip:fixEquipData_Clear()
  FixEquip_Resize()
end
function FixEquip_Close()
  local self = PaGlobal_FixEquip
  if false == Panel_FixEquip:IsShow() then
    return
  end
  Panel_FixEquip:SetShow(false, true)
  Inventory_SetFunctor(Repair_InvenFilter, Repair_InvenRClick, handleMClickedRepairExitButton, nil)
  Inventory_PosLoadMemory()
  Equipment_BesideInvenPos()
  PaGlobal_FixEquip:fixEquip_clearData()
  self._uiItemFix:SetCheck(true)
  self._uiMoneyItemFix:SetCheck(false)
  PaGlobal_FixEquip:fixEquipData_Clear()
end
function PaGlobal_FixEquip:fixEquipExit()
  FixEquip_Close()
end
function FixEquip_HideAni()
  UIAni.AlphaAnimation(0, Panel_FixEquip, 0, 0.15):SetHideAtEnd(true)
  audioPostEvent_SystemUi(1, 1)
end
function Panel_FixEquip_checkHasItemJewel(slotNo, itemWrapper, count, inventoryType)
  local function repairConfirm()
    PaGlobal_FixEquip._checkHasItemJewel = true
    Panel_FixEquip_InteractortionFromInventory(slotNo, itemWrapper, count, inventoryType)
  end
  if true == itemWrapper:hasItemJewel() then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_CONTROL_CHECKHASITEMJEWEL_DESC"),
      functionYes = repairConfirm,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return true
  else
    return false
  end
end
function FixEquip_Resize()
  local scrY = getScreenSizeY()
  if Panel_Window_Repair:GetShow() then
    local dialogY = Panel_Window_Repair:GetSizeY()
    local fixeEquipPosY = (scrY - dialogY) / 2 - Panel_FixEquip:GetSizeY() / 2
    Panel_FixEquip:SetPosY(fixeEquipPosY)
  end
end
registerEvent("onScreenResize", "FixEquip_Resize")
function PaGlobal_FixEquip:fixEquip_CancelButton()
  PaGlobal_FixEquip:fixEquip_clearData()
  Inventory_SetFunctor(FixEquip_InvenFiler_MainItem, Panel_FixEquip_InteractortionFromInventory, FixEquip_CloseButton, nil)
end
function PaGlobal_FixEquip:handleMClickedFixEquipItemButton()
  if true == Panel_FixEquip:GetShow() then
    self._onlyItemCheck = true
    self._moneyItemCheck = false
    self:fixEquipExit()
  else
    self._onlyItemCheck = true
    self._moneyItemCheck = false
    self._uiEquipPrice:SetShow(false)
    PaGlobal_FixEquip:fixEquip_Show()
  end
  self._enduranceText:SetShow(false)
  self._enduranceGauge:SetShow(false)
  self._enduranceMax:SetShow(false)
  self._enduranceGaugeValue:SetShow(false)
  self._enduranceValue:SetShow(false)
  self._enduranceIcon:SetShow(false)
  self._enduranceMax:SetAniSpeed(0)
  self._enduranceGaugeValue:SetAniSpeed(0)
end

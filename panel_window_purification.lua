Panel_Purification:SetShow(false)
PuriManager = {
  _ui = {
    _btn_Close = UI.getChildControl(Panel_Purification, "Button_CloseIcon"),
    _btn_Puri = UI.getChildControl(Panel_Purification, "Button_Purification"),
    _bg_Main = UI.getChildControl(Panel_Purification, "Static_Bg"),
    _bg_Bottom = UI.getChildControl(Panel_Purification, "Static_BottomBg"),
    _chk_AniSkip = nil
  },
  _fromWhereType = -1,
  _fromSlotNo = -1,
  _moneyWhereType = 0,
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
  },
  _purificationPrice = 100000
}
function PuriManager:SetPosition()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  if screenSizeY <= 800 then
    Panel_Purification:SetPosY(screenSizeY / 2 - Panel_Purification:GetSizeY() / 2 - 30)
  else
    Panel_Purification:SetPosY(screenSizeY / 2 - Panel_Purification:GetSizeY() / 2 - 100)
  end
  Panel_Purification:SetPosX(screenSizeX / 2 - Panel_Purification:GetSizeX() / 2)
end
function PuriManager:Open()
  warehouse_requestInfoFromNpc()
  PuriManager:Clear()
  self:RadioButtonCheck()
  HandleClicked_Inventory_WeakenEnchant_Open()
  Panel_Window_Inventory:SetShow(true)
  Inventory_SetFunctor(PaGlobal_Purification_Filter, PaGlobal_Purification_RClick, PaGlobal_Purification_Close, nil)
  self._ui._text_InvenMoney:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  self._ui._text_WareHouseMoney:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
  self._ui._radio_Inven:SetEnableArea(0, 0, self._ui._radio_Inven:GetTextSizeX() + 30, 25)
  self._ui._radio_Warehouse:SetEnableArea(0, 0, self._ui._radio_Warehouse:GetTextSizeX() + 30, 25)
  if false == Panel_Purification:GetShow() then
    PuriManager:SetPosition()
  end
  Panel_Purification:SetShow(true)
end
function PuriManager:Clear()
  self._fromSlotNo = -1
  self._fromWhereType = -1
  self._resultSlotNo = -1
  self._resultWhereType = -1
  self._fromSlotOn = false
  self._resultSlotOn = false
  self._ui._icon_items:clearItem()
  self._ui._icon_result:clearItem()
  self._moneyWhereType = 0
  self._delta_ani_time = 0
  self._isAniStart = false
  self._ui._btn_Puri:SetIgnore(false)
  self._ui._btn_Puri:SetMonoTone(false)
  if false == ToClient_isConsole() and nil ~= self._ui._chk_AniSkip then
    self._ui._chk_AniSkip:SetCheck(false)
  end
  self._ui._bg_itemSlot:EraseAllEffect()
  self._ui._bg_resultItemSlot:EraseAllEffect()
end
function PaGlobal_Purification_Close()
  PuriManager:Close()
end
function PuriManager:Close()
  self._ui._icon_items:clearItem()
  HandleClicked_InventoryWindow_Close()
  Panel_Purification:SetShow(false)
end
function PuriManager:ClickMoneyWhereType(isInventory)
  if true == isInventory then
    self._moneyWhereType = CppEnums.ItemWhereType.eInventory
  else
    self._moneyWhereType = CppEnums.ItemWhereType.eWarehouse
  end
end
function FromClient_Purification_EventWarehouseUpdate(value)
  local self = PuriManager
  if true == Panel_Purification:GetShow() then
    self._ui._text_WareHouseMoney:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
  end
end
function PuriManager:Initialize()
  self._ui._bg_itemSlot = UI.getChildControl(self._ui._bg_Main, "Static_ItemSlotBg")
  self._ui._bg_resultItemSlot = UI.getChildControl(self._ui._bg_Main, "Static_ResultItemSlotBg")
  self._ui._bg_Deco = UI.getChildControl(self._ui._bg_Main, "Static_Deco")
  self._ui._radio_Inven = UI.getChildControl(self._ui._bg_Main, "RadioButton_InvenMoney")
  self._ui._text_InvenMoney = UI.getChildControl(self._ui._bg_Main, "StaticText_InvenMoney")
  self._ui._radio_Warehouse = UI.getChildControl(self._ui._bg_Main, "RadioButton_WarehouseMoney")
  self._ui._text_WareHouseMoney = UI.getChildControl(self._ui._bg_Main, "StaticText_WarehouseMoney")
  self._ui._radio_Inven:SetCheck(true)
  self._ui._radio_Warehouse:SetCheck(false)
  self._ui._radio_Inven:addInputEvent("Mouse_LUp", "PuriManager:ClickMoneyWhereType(true)")
  self._ui._radio_Warehouse:addInputEvent("Mouse_LUp", "PuriManager:ClickMoneyWhereType(false)")
  self._ui._btn_Close:addInputEvent("Mouse_LUp", "PuriManager:Close()")
  self._ui._btn_Puri:addInputEvent("Mouse_LUp", "PuriManager:RequestPuri()")
  if false == ToClient_isConsole() then
    self._ui._chk_AniSkip = UI.getChildControl(Panel_Purification, "CheckButton_Skip")
    self._ui._chk_AniSkip:SetShow(true)
    self._ui._chk_AniSkip:SetEnableArea(0, 0, self._ui._chk_AniSkip:GetTextSizeX() + 20, 20)
    self._ui._chk_AniSkip:addInputEvent("Mouse_On", "HandleEventOnOut_PuriManager_CheckButton(true)")
    self._ui._chk_AniSkip:addInputEvent("Mouse_Out", "HandleEventOnOut_PuriManager_CheckButton(false)")
  end
  self._ui._icon_items = {}
  SlotItem.new(self._ui._icon_items, "feeItem", nil, self._ui._bg_itemSlot, self._slotConfig)
  self._ui._icon_items:createChild()
  self._ui._icon_items.icon:addInputEvent("Mouse_On", "PaGlobal_Purification_ShowToolTip(true)")
  self._ui._icon_items.icon:addInputEvent("Mouse_Out", "PaGlobal_Purification_ShowToolTip(false)")
  self._ui._icon_items.icon:addInputEvent("Mouse_RUp", "PuriManager:ClearItemSlot()")
  self._ui._icon_items:clearItem()
  self._ui._icon_result = {}
  SlotItem.new(self._ui._icon_result, "resultItem", nil, self._ui._bg_resultItemSlot, self._slotConfig)
  self._ui._icon_result:createChild()
  self._ui._icon_result.icon:addInputEvent("Mouse_On", "PaGlobal_Purification_ResultShowToolTip(true)")
  self._ui._icon_result.icon:addInputEvent("Mouse_Out", "PaGlobal_Purification_ResultShowToolTip(false)")
  self._ui._icon_result:clearItem()
  self._ui._text_desc = UI.getChildControl(self._ui._bg_Bottom, "StaticText_Desc")
  self._ui._text_desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._text_desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PURIFICATION_DESC"))
  local prevSizeY = self._ui._bg_Bottom:GetSizeY()
  local textSizeY = self._ui._text_desc:GetTextSizeY()
  self._ui._bg_Bottom:SetSize(self._ui._bg_Bottom:GetSizeX(), textSizeY + 15)
  if prevSizeY < textSizeY then
    Panel_Purification:SetSize(Panel_Purification:GetSizeX(), Panel_Purification:GetSizeY() + textSizeY - prevSizeY + 10)
    self._ui._text_desc:ComputePos()
  end
  registerEvent("FromClient_notifyWeakenEnchantSuccess", "FromClient_notifyWeakenEnchantSuccess")
  registerEvent("EventWarehouseUpdate", "FromClient_Purification_EventWarehouseUpdate")
  Panel_Purification:RegisterUpdateFunc("Update_RequestAni")
end
function Update_RequestAni(delta)
  local self = PuriManager
  if false == self._isAniStart then
    return
  end
  self._delta_ani_time = self._delta_ani_time + delta
  local skipCheck = false
  skipCheck = nil ~= self._ui._chk_AniSkip and true == self._ui._chk_AniSkip:IsCheck()
  if self._const_ani_time < self._delta_ani_time or true == skipCheck then
    self._delta_ani_time = 0
    ToClient_WeakenEncantByNpc(self._fromWhereType, self._fromSlotNo, self._moneyWhereType)
    self._ui._btn_Puri:SetIgnore(false)
    self._ui._btn_Puri:SetMonoTone(false)
    self._resultSlotNo = self._fromSlotNo
    self._resultWhereType = self._fromWhereType
    self._isAniStart = false
  end
end
function PuriManager:RequestPuri()
  if self._fromSlotNo < 0 or 0 > self._fromWhereType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PURIFICATION_TARGET_EMPTY"))
    return
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_PURIFICATION_ALERT"),
    functionYes = function()
      self._delta_ani_time = 0
      self._isAniStart = true
      local skipCheck = false
      skipCheck = nil ~= self._ui._chk_AniSkip and true == self._ui._chk_AniSkip:IsCheck()
      if skipCheck then
        self._ui._bg_resultItemSlot:AddEffect("fUI_Purification_02A", false, 0, 0)
      else
        self._ui._bg_itemSlot:AddEffect("fUI_Purification_01A", false, 0, 0)
        self._ui._bg_resultItemSlot:AddEffect("fUI_Purification_02A", false, 0, 0)
      end
      self._ui._btn_Puri:SetIgnore(true)
      self._ui._btn_Puri:SetMonoTone(true)
      audioPostEvent_SystemUi(5, 17)
      _AudioPostEvent_SystemUiForXBOX(5, 17)
    end,
    functionNo = function()
    end,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PuriManager:ClearItemSlot()
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
end
function PuriManager:RadioButtonCheck()
  if nil == getSelfPlayer then
    return
  end
  local invenMoney = getSelfPlayer():get():getInventory():getMoney_s64()
  local warehouseMoney = warehouse_moneyFromNpcShop_s64()
  if invenMoney < toInt64(0, self._purificationPrice) and warehouseMoney >= toInt64(0, self._purificationPrice) then
    self._ui._radio_Inven:SetCheck(false)
    self._ui._radio_Warehouse:SetCheck(true)
  end
  self:ClickMoneyWhereType(self._ui._radio_Inven:IsCheck())
end
function PaGlobal_Purification_RClick(slotNo, itemWrapper, count, invenType)
  local self = PuriManager
  local tempKey = itemWrapper:get():getKey()
  local staticStatus = itemWrapper:getStaticStatus()
  if nil == staticStatus then
    return
  end
  if true == self._isAniStart then
    return
  end
  self._ui._icon_items:setItemByStaticStatus(staticStatus, Defines.s64_const.s64_1)
  self._fromSlotNo = slotNo
  self._fromWhereType = invenType
  self._fromSlotOn = true
  self._resultSlotOn = false
  self._resultSlotNo = -1
  self._resultWhereType = -1
  local prevStatic = staticStatus:getPrevItemEnchantStaticStatus()
  self._ui._icon_result:clearItem()
  if prevStatic ~= nil then
    self._ui._icon_result:setItemByStaticStatus(prevStatic, Defines.s64_const.s64_1)
    self._ui._bg_resultItemSlot:SetMonoTone(true)
  end
end
function PaGlobal_Purification_Filter(slotNo, notUse_itemWrappers, whereType)
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  if itemWrapper:isWeakenEnchantItem() then
    return false
  else
    return true
  end
end
function PaGlobal_Purification_ShowToolTip(isShow)
  local self = PuriManager
  if false == self._fromSlotOn then
    return
  end
  local itemWrapper = getInventoryItemByType(self._fromWhereType, self._fromSlotNo)
  if true == isShow then
    Panel_Tooltip_Item_SetPosition(0, self._ui._bg_itemSlot, "Purification")
    Panel_Tooltip_Item_Show(itemWrapper, Panel_Purification, false, true, nil)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function PaGlobal_Purification_ResultShowToolTip(isShow)
  local self = PuriManager
  if false == self._resultSlotOn then
    return
  end
  local itemWrapper = getInventoryItemByType(self._resultWhereType, self._resultSlotNo)
  if true == isShow then
    Panel_Tooltip_Item_SetPosition(0, self._ui._bg_resultItemSlot, "Purification")
    Panel_Tooltip_Item_Show(itemWrapper, Panel_Purification, false, true, nil)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function HandleEventOnOut_PuriManager_CheckButton(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_PURIFICATION_TOOLTIP_NAME")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SKIPENCHANT_TOOLTIP_DESC_CAPHRAS")
  TooltipSimple_Show(PuriManager._ui._chk_AniSkip, name, desc)
end
function FromClient_notifyWeakenEnchantSuccess()
  local self = PuriManager
  audioPostEvent_SystemUi(5, 16)
  _AudioPostEvent_SystemUiForXBOX(5, 16)
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PURIFICATION_SUCCESS"))
  self._fromSlotOn = false
  self._fromSlotNo = -1
  self._fromWhereType = -1
  self._resultSlotOn = true
  self._ui._icon_items:clearItem()
  self._ui._icon_result:clearItem()
  self._ui._bg_resultItemSlot:SetMonoTone(false)
  local itemWrapper = getInventoryItemByType(self._resultWhereType, self._resultSlotNo)
  local staticStatus = itemWrapper:getStaticStatus()
  self._ui._icon_result:setItemByStaticStatus(staticStatus, Defines.s64_const.s64_1)
  self._ui._text_InvenMoney:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  self._ui._text_WareHouseMoney:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
end
PuriManager:Initialize()

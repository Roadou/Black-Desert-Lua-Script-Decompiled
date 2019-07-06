function PaGlobal_ExtractionSystem:initialize()
  if true == PaGlobal_ExtractionSystem._initialize then
    return
  end
  local self_ext = PaGlobal_ExtractionSystem
  local uiControl = self_ext._ui
  uiControl.stc_ExtractionSystem = UI.getChildControl(Panel_Tab_ExtractSystem_Renew, "Static_ExtractionSystem")
  uiControl.stc_SacrificeItemSlotBG = UI.getChildControl(uiControl.stc_ExtractionSystem, "Static_SacrificeSlotBG")
  uiControl.stc_CatalystItemSlotBG = UI.getChildControl(uiControl.stc_ExtractionSystem, "Static_CatalystSlotBG")
  uiControl.stc_ExtractionItemSlotBG_1 = UI.getChildControl(uiControl.stc_ExtractionSystem, "Static_ExtractSlotBG_1")
  uiControl.stc_ExtractionItemSlotBG_2 = UI.getChildControl(uiControl.stc_ExtractionSystem, "Static_ExtractSlotBG_2")
  uiControl.stc_ExtractionBG = UI.getChildControl(uiControl.stc_ExtractionSystem, "Static_ExtractionBG")
  uiControl.txt_CatalystNeed = UI.getChildControl(uiControl.stc_ExtractionSystem, "StaticText_CatalystNeed")
  uiControl.stc_ButtonBG = UI.getChildControl(uiControl.stc_ExtractionSystem, "Button_Center")
  uiControl.stc_KeyGuideY = UI.getChildControl(uiControl.stc_ButtonBG, "StaticText_KeyGuide")
  uiControl.txt_CatalystNeed:SetShow(false)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign({
    uiControl.stc_KeyGuideY
  }, uiControl.stc_ButtonBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_CENTER)
  local slotConfig = {
    createIcon = true,
    createBorder = false,
    createCount = false,
    createEnchant = true,
    createCash = false
  }
  local slotConfig_Catalyst = {
    createIcon = true,
    createBorder = false,
    createCount = true,
    createEnchant = true,
    createCash = false
  }
  uiControl.slot_SacrificeItem.icon = UI.getChildControl(uiControl.stc_SacrificeItemSlotBG, "Static_Slot")
  SlotItem.new(uiControl.slot_SacrificeItem, "Slot_Sacrifice", 0, Panel_Tab_ExtractSystem_Renew, slotConfig)
  uiControl.slot_SacrificeItem:createChild()
  uiControl.slot_CatalystItem.icon = UI.getChildControl(uiControl.stc_CatalystItemSlotBG, "Static_Slot")
  SlotItem.new(uiControl.slot_CatalystItem, "Slot_Catalyst", 0, Panel_Tab_ExtractSystem_Renew, slotConfig_Catalyst)
  uiControl.slot_CatalystItem:createChild()
  uiControl.slot_ExtractItem_1.icon = UI.getChildControl(uiControl.stc_ExtractionItemSlotBG_1, "Static_Slot")
  SlotItem.new(uiControl.slot_ExtractItem_1, "Slot_Extract_1", 0, Panel_Tab_ExtractSystem_Renew, slotConfig)
  uiControl.slot_ExtractItem_1:createChild()
  uiControl.slot_ExtractItem_2.icon = UI.getChildControl(uiControl.stc_ExtractionItemSlotBG_2, "Static_Slot")
  SlotItem.new(uiControl.slot_ExtractItem_2, "Slot_Extract_2", 0, Panel_Tab_ExtractSystem_Renew, slotConfig)
  uiControl.slot_ExtractItem_2:createChild()
  PaGlobal_ExtractionSystem:clearAllItemSlot()
  for i = 1, 4 do
    PaGlobal_ExtractionSystem._currentInfo[i].itemKey = 0
    PaGlobal_ExtractionSystem._currentInfo[i].whereType = 0
    PaGlobal_ExtractionSystem._currentInfo[i].slotNo = 0
  end
  self_ext:registEventHandler()
  local moveTarget = UI.getChildControl(Panel_Window_Extract_Renew, "Static_SystemGroup")
  moveTarget:SetShow(false)
  moveTarget:MoveChilds(moveTarget:GetID(), Panel_Tab_ExtractSystem_Renew)
  deletePanel(Panel_Tab_ExtractSystem_Renew:GetID())
  self_ext._initialize = true
end
function PaGlobal_ExtractionSystem:registEventHandler()
  local uiControl = PaGlobal_ExtractionSystem._ui
  registerEvent("FromClient_GetExtractResult", "FromClient_ExtractSystem_GetExtractResult")
end
function PaGlobal_ExtractionSystem:setInventory_ForSacrificeItem()
  Inventory_SetFunctor(PaGlobal_ExtractionSystem_Fillter_ForSacrificeTarget, PaGlobal_ExtractionSystem_MouseRUpExtractItem, nil)
end
function PaGlobal_ExtractionSystem:setInventory_ForCatalystItem()
  Inventory_SetFunctor(PaGlobal_ExtractionSystem_Fillter_ForCatalystTarget, PaGlobal_ExtractionSystem_MouseRUpCatalystItem, nil)
end
function PaGlobal_ExtractionSystem:setInventory_AllBlocking()
  Inventory_SetFunctor(PaGlobal_ExtractionSystem_Fillter_AllBlock, nil, nil)
end
function PaGlobal_ExtractionSystem:setItemToExtractSlot()
  local sacrificeItemkey = PaGlobal_ExtractionSystem._currentInfo[1].itemKey
  local catalystItemKey = PaGlobal_ExtractionSystem._currentInfo[2].itemKey
  if nil == sacrificeItemkey then
    return
  end
  if -1 == sacrificeItemkey or -1 == catalystItemKey then
    PaGlobal_ExtractionSystem:clearExtractItemSlot()
    return
  end
  local ItemKey_1 = ToClient_ExtractToItemEnchantKey(sacrificeItemkey, 0)
  local ItemKey_2 = ToClient_ExtractToItemEnchantKey(sacrificeItemkey, 1)
  PaGlobal_ExtractionSystem._ui.slot_ExtractItem_1:setItemByStaticStatus(getItemEnchantStaticStatus(ItemKey_1))
  PaGlobal_ExtractionSystem._ui.slot_ExtractItem_2:setItemByStaticStatus(getItemEnchantStaticStatus(ItemKey_2))
  PaGlobal_ExtractionSystem._ui.slot_ExtractItem_1.icon:SetMonoTone(true)
  PaGlobal_ExtractionSystem._ui.slot_ExtractItem_2.icon:SetMonoTone(true)
  PaGlobal_ExtractionSystem._currentInfo[3].itemKey = ItemKey_1
  PaGlobal_ExtractionSystem._currentInfo[4].itemKey = ItemKey_2
  PaGlobal_ExtractionSystem:buttonEnable(PaGlobal_ExtractionSystem._ui.stc_KeyGuideY)
  PaGlobal_ExtractionSystem._ui.stc_ExtractionBG:SetMonoTone(false)
  PaGlobal_ExtractionSystem:effectFunction(2)
end
function PaGlobal_ExtractionSystem:setCatalystItem()
  local whereType = PaGlobal_ExtractionSystem._currentInfo[1].whereType
  local slotNo = PaGlobal_ExtractionSystem._currentInfo[1].slotNo
  if -1 == whereType or -1 == slotNo then
    return
  end
  local selfPlayerInventory = getSelfPlayer():get():getInventoryByType(whereType)
  if nil == selfPlayerInventory then
    return
  end
  if -1 ~= PaGlobal_ExtractionSystem._currentInfo[1].itemKey then
    PaGlobal_ExtractionSystem._catalystItemKey = ToClient_ExtractNeedItemEnchantKey(PaGlobal_ExtractionSystem._currentInfo[1].itemKey)
  end
  local catalystItemSlotNo = selfPlayerInventory:getSlot(PaGlobal_ExtractionSystem._catalystItemKey)
  if 255 == catalystItemSlotNo then
    local itemSSW = getItemEnchantStaticStatus(PaGlobal_ExtractionSystem._catalystItemKey)
    PaGlobal_ExtractionSystem._ui.txt_CatalystNeed:SetText(PAGetStringParam1(Defines.StringSheet_RESOURCE, "PANEL_EXTRACTIONSYSTEM_NEEDCATALYST", "itemName", itemSSW:getName()))
    PaGlobal_ExtractionSystem._ui.txt_CatalystNeed:SetShow(true)
    PaGlobal_ExtractionSystem._ui.slot_CatalystItem:setItemByStaticStatus(itemSSW)
    PaGlobal_ExtractionSystem._ui.slot_CatalystItem.icon:SetMonoTone(true)
    PaGlobal_ExtractionSystem._ui.slot_CatalystItem.count:SetText("0")
    PaGlobal_ExtractionSystem._ui.slot_CatalystItem.count:SetFontColor(Defines.Color.C_FFFF0000)
    PaGlobal_ExtractionSystem:clearExtractItemSlot()
    PaGlobal_ExtractionSystem:setInventory_ForSacrificeItem()
  else
    PaGlobal_ExtractionSystem._ui.txt_CatalystNeed:SetShow(false)
    PaGlobal_ExtractionSystem._ui.slot_CatalystItem.icon:SetMonoTone(false)
    PaGlobal_ExtractionSystem._ui.slot_CatalystItem.count:SetText("1")
    PaGlobal_ExtractionSystem._ui.slot_CatalystItem.count:SetFontColor(Defines.Color.C_FFFFFFFF)
    PaGlobal_ExtractionSystem_MouseRUpCatalystItem(catalystItemSlotNo, nil, nil, PaGlobal_ExtractionSystem._currentInfo[1].whereType)
  end
end
function PaGlobal_ExtractionSystem:completeExtractSetSlot()
  local sacrificeItemkey = PaGlobal_ExtractionSystem._currentInfo[1].itemKey
  local catalystItemKey = PaGlobal_ExtractionSystem._currentInfo[2].itemKey
  if nil == sacrificeItemkey then
    return
  end
  if -1 == sacrificeItemkey or -1 == catalystItemKey then
    return
  end
  local ItemKey_1 = ToClient_ExtractToItemEnchantKey(sacrificeItemkey, 0)
  local ItemKey_2 = ToClient_ExtractToItemEnchantKey(sacrificeItemkey, 1)
  PaGlobal_ExtractionSystem._ui.slot_ExtractItem_1:setItemByStaticStatus(getItemEnchantStaticStatus(ItemKey_1))
  PaGlobal_ExtractionSystem._ui.slot_ExtractItem_2:setItemByStaticStatus(getItemEnchantStaticStatus(ItemKey_2))
  PaGlobal_ExtractionSystem._ui.slot_ExtractItem_1.icon:SetMonoTone(false)
  PaGlobal_ExtractionSystem._ui.slot_ExtractItem_2.icon:SetMonoTone(false)
  PaGlobal_ExtractionSystem._ui.stc_ExtractionBG:SetMonoTone(true)
  PaGlobal_ExtractionSystem:clearSacrificeItemSlot()
  PaGlobal_ExtractionSystem:clearCatalystItemSlot()
  PaGlobal_ExtractionSystem:buttonDisable(PaGlobal_ExtractionSystem._ui.stc_KeyGuideY)
end
function PaGlobal_ExtractionSystem:clearExtractItemSlot()
  PaGlobal_ExtractionSystem._ui.slot_ExtractItem_1:clearItem()
  PaGlobal_ExtractionSystem._ui.slot_ExtractItem_2:clearItem()
  PaGlobal_ExtractionSystem._ui.slot_ExtractItem_1.icon:EraseAllEffect()
  PaGlobal_ExtractionSystem._ui.slot_ExtractItem_2.icon:EraseAllEffect()
  PaGlobal_ExtractionSystem._ui.stc_ExtractionBG:SetMonoTone(true)
  PaGlobal_ExtractionSystem._currentInfo[3].itemKey = -1
  PaGlobal_ExtractionSystem._currentInfo[3].whereType = -1
  PaGlobal_ExtractionSystem._currentInfo[3].slotNo = -1
  PaGlobal_ExtractionSystem._currentInfo[4].itemKey = -1
  PaGlobal_ExtractionSystem._currentInfo[4].whereType = -1
  PaGlobal_ExtractionSystem._currentInfo[4].slotNo = -1
  PaGlobal_ExtractionSystem:buttonDisable(PaGlobal_ExtractionSystem._ui.stc_KeyGuideY)
end
function PaGlobal_ExtractionSystem:clearSacrificeItemSlot()
  PaGlobal_ExtractionSystem._ui.slot_SacrificeItem:clearItem()
  PaGlobal_ExtractionSystem._ui.slot_SacrificeItem.icon:EraseAllEffect()
  PaGlobal_ExtractionSystem._currentInfo[1].itemKey = -1
  PaGlobal_ExtractionSystem._currentInfo[1].whereType = -1
  PaGlobal_ExtractionSystem._currentInfo[1].slotNo = -1
end
function PaGlobal_ExtractionSystem:clearCatalystItemSlot()
  PaGlobal_ExtractionSystem._ui.slot_CatalystItem:clearItem()
  PaGlobal_ExtractionSystem._ui.slot_CatalystItem.icon:EraseAllEffect()
  PaGlobal_ExtractionSystem._currentInfo[2].itemKey = -1
  PaGlobal_ExtractionSystem._currentInfo[2].whereType = -1
  PaGlobal_ExtractionSystem._currentInfo[2].slotNo = -1
end
function PaGlobal_ExtractionSystem:clearAllItemSlot()
  PaGlobal_ExtractionSystem:clearExtractItemSlot()
  PaGlobal_ExtractionSystem:clearSacrificeItemSlot()
  PaGlobal_ExtractionSystem:clearCatalystItemSlot()
  PaGlobal_ExtractionSystem._ui.txt_CatalystNeed:SetShow(false)
  PaGlobal_ExtractionSystem._ui.slot_CatalystItem.icon:SetIgnore(false)
  PaGlobal_ExtractionSystem._ui.slot_SacrificeItem.icon:SetIgnore(false)
end
function PaGlobal_ExtractionSystem:effectFunction(type)
  if 1 == type then
    PaGlobal_ExtractionSystem._ui.slot_ExtractItem_1.icon:AddEffect("UI_ItemEnchant01", false, -6, -6)
    PaGlobal_ExtractionSystem._ui.slot_ExtractItem_2.icon:AddEffect("UI_ItemEnchant01", false, -6, -6)
  elseif 2 == type then
    PaGlobal_ExtractionSystem._ui.stc_CatalystItemSlotBG:AddEffect("fUI_Gamos_Extraction_01A", false, 0, -110)
    PaGlobal_ExtractionSystem._ui.stc_CatalystItemSlotBG:AddEffect("fUI_Gamos_Extraction_02A", false, 0, 0)
  end
end
function PaGlobal_ExtractionSystem:buttonEnable(control)
  control:SetIgnore(false)
  control:SetMonoTone(false)
  control:SetColor(Defines.Color.C_FFFFFFFF)
  control:SetText(control:GetText())
  control:SetFontColor(Defines.Color.C_FFFFFFFF)
end
function PaGlobal_ExtractionSystem:buttonDisable(control)
  control:SetIgnore(true)
  control:SetMonoTone(true)
end
function PaGlobal_ExtractionSystem:open()
  PaGlobal_ExtractionSystem:clearAllItemSlot()
  PaGlobal_ExtractionSystem:setInventory_ForSacrificeItem()
  PaGlobalFunc_InventoryInfo_Open(1)
end
function PaGlobal_ExtractionSystem:clear()
  if true == PaGlobal_ExtractionSystem._isAnimation then
    PaGlobal_ExtractionSystem._isAnimation = false
    PaGlobal_ExtractionSystem._current_AniTime = 0
    PaGlobal_ExtractionSystem._ui.stc_SacrificeItemSlotBG:EraseAllEffect()
    Panel_Window_ExtractionSystem:ClearUpdateLuaFunc()
  end
  PaGlobal_ExtractionSystem._ui.stc_CatalystItemSlotBG:EraseAllEffect()
end

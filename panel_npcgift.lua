local PaGlobal_NpcGift = {
  _ui = {
    _presentBtn = UI.getChildControl(Panel_NpcGift, "Button_Present"),
    _confessionBtn = UI.getChildControl(Panel_NpcGift, "Button_Confession"),
    _closeBtn = UI.getChildControl(Panel_NpcGift, "Button_Close"),
    _iconDetail = UI.getChildControl(Panel_NpcGift, "StaticText_DetailIcon"),
    _detailDesc = UI.getChildControl(Panel_NpcGift, "StaticText_DetailDesc"),
    _slot_PresentItem = {},
    _interestItemListBG = UI.getChildControl(Panel_NpcGift, "Static_InterestItemListBg"),
    _slot_InterestItemList = {}
  },
  _inventoryType = 0,
  _slotNo = 0,
  _count = 0,
  _presentItemName = "",
  _interestItemCount = 5
}
local slotConfig = {
  createIcon = false,
  createBorder = true,
  createCount = true,
  createEnchant = true,
  createCash = true
}
function PaGlobal_NpcGift:init()
  Panel_NpcGift:SetShow(false)
  self._ui._slot_PresentItem.icon = UI.getChildControl(Panel_NpcGift, "Static_PresentItemSlot")
  SlotItem.new(self._ui._slot_PresentItem, "PresentItem", 0, Panel_NpcGift, slotConfig)
  self._ui._slot_PresentItem:createChild()
  self._ui._slot_PresentItem.empty = true
  self._ui._slot_PresentItem:clearItem()
  self._ui._slot_PresentItem.border:SetSize(42, 42)
  Panel_Tooltip_Item_SetPosition(0, self._ui._slot_PresentItem, "NpcGift")
  for idx = 0, self._interestItemCount - 1 do
    local itemSlot = {}
    itemSlot.icon = UI.getChildControl(self._ui._interestItemListBG, "Static_InterestItemSlot" .. tostring(idx))
    SlotItem.new(itemSlot, "InterestItemSlot_" .. tostring(idx), 0, Panel_NpcGift, slotConfig)
    itemSlot:createChild()
    itemSlot.empty = true
    itemSlot:clearItem()
    itemSlot.border:SetSize(42, 42)
    Panel_Tooltip_Item_SetPosition(idx, itemSlot, "NpcIntertestGift")
    self._ui._slot_InterestItemList[idx] = itemSlot
  end
  self._ui._detailDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._detailDesc:SetText(self._ui._detailDesc:GetText())
  self._ui._detailDesc:SetSize(self._ui._detailDesc:GetSizeX(), self._ui._detailDesc:GetTextSizeY() + 5)
  self._ui._detailDesc:ComputePos()
end
function PaGlobal_NpcGift:setItemToSlot(uiSlot, itemSS, count)
  uiSlot.icon:AddEffect("UI_Button_Hide", false, 0, 0)
  uiSlot.empty = false
  uiSlot.icon:SetMonoTone(false)
  uiSlot:setItemByStaticStatus(itemSS, count, -1)
end
function PaGlobal_NpcGift:open()
  Panel_NpcGift:SetShow(true)
  InventoryWindow_Show()
  Inventory_SetFunctor(FGlobal_Enchant_FileterForNpcGift, FGlobal_NpcGift_RClickForTargetItem, FGlobal_NpcGift_Close, nil)
  self._ui._slot_PresentItem:clearItem()
  self._ui._slot_PresentItem.empty = true
  self._count = 0
  self._inventoryType = 0
  self._slotNo = 0
  local interestitemSize = ToClient_getInterestNpcGiftSize()
  for idx = 0, interestitemSize - 1 do
    self._ui._slot_InterestItemList[idx]:clearItem()
    if idx == self._interestItemCount then
      break
    end
    local itemSS = ToClient_getInterestNpcGift(idx)
    if nil ~= itemSS then
      self:setItemToSlot(self._ui._slot_InterestItemList[idx], itemSS, 1)
    end
  end
end
function PaGlobal_NpcGift:close()
  Panel_NpcGift:SetShow(false)
  InventoryWindow_Close()
  Inventory_SetFunctor(nil, nil, nil, nil)
end
function FGlobal_NpcGift_RClickForTargetItem(slotNo, itemWrapper, count, inventoryType)
  if nil == itemWrapper then
    return
  end
  local self = PaGlobal_NpcGift
  self._inventoryType = inventoryType
  self._slotNo = slotNo
  self._presentItemName = itemWrapper:getStaticStatus():getName()
  self._count = 0
  if 1 == count then
    FGlobal_NpcGift_ItemSetting(count)
  else
    Panel_NumberPad_Show(true, count, 0, FGlobal_NpcGift_ItemSetting)
  end
end
function FGlobal_NpcGift_ItemSetting(count)
  local self = PaGlobal_NpcGift
  self._count = count
  local itemWrapper = getInventoryItemByType(self._inventoryType, self._slotNo)
  if nil == itemWrapper then
    return
  end
  self:setItemToSlot(self._ui._slot_PresentItem, itemWrapper:getStaticStatus(), count)
end
function FGlobal_NpcGift_PopupMessage()
  local self = PaGlobal_NpcGift
  if 0 == self._count then
    return
  end
  local messageBoxtitle = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local messageBoxMemo = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NPC_GIFT_CONFIRM", "itemName", tostring(self._presentItemName), "count", tostring(self._count))
  local messageBoxData = {
    title = messageBoxtitle,
    content = messageBoxMemo,
    functionYes = FGlobal_NpcGift_Confirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData, "middle")
end
function FGlobal_NpcGift_Propose()
  ToClient_proposeToNpc()
end
function FGlobal_NpcGift_Confirm()
  local self = PaGlobal_NpcGift
  ToClient_giveNpcGift(self._inventoryType, self._slotNo, self._count)
end
function FGlobal_NpcGift_Open()
  PaGlobal_NpcGift:open()
  FGlobal_NpcGift_TooltipShow(false)
end
function FGlobal_NpcGift_Close()
  PaGlobal_NpcGift:close()
  FGlobal_NpcGift_TooltipShow(false)
end
function FGlobal_NpcGift_OnPresentTooltip()
  local self = PaGlobal_NpcGift
  if 0 == self._inventoryType and 0 == self._slotNo then
    return
  end
  local itemWrapper = getInventoryItemByType(self._inventoryType, self._slotNo)
  if nil == itemWrapper then
    return
  end
  Panel_Tooltip_Item_Show(itemWrapper:getStaticStatus(), PaGlobal_NpcGift._ui._slot_PresentItem.icon, true, false)
end
function FGlobal_NpcGift_OnTooltip(idx)
  local needSS = ToClient_getInterestNpcGift(idx)
  if nil == needSS then
    return
  end
  Panel_Tooltip_Item_Show(needSS, PaGlobal_NpcGift._ui._slot_InterestItemList[idx].icon, true, false)
end
function FGlobal_NpcGift_OutTooltip()
  Panel_Tooltip_Item_hideTooltip()
end
function FGlobal_Enchant_FileterForNpcGift(slotNo, notUse_itemWrappers, whereType)
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  return false == itemWrapper:checkToGiveNpc()
end
function FGlobal_NpcGift_TooltipShow(isShow)
  PaGlobal_NpcGift._ui._detailDesc:SetShow(isShow)
end
function FromClient_luaLoadComplete_NpcGift()
  PaGlobal_NpcGift:init()
  PaGlobal_NpcGift:registEventHandler()
end
function FromClient_NpcGiftSend()
  local self = PaGlobal_NpcGift
  self._count = 0
  self._inventoryType = 0
  self._slotNo = -1
  self._ui._slot_PresentItem.empty = true
  self._ui._slot_PresentItem:clearItem()
end
function FromClient_SuccessProposeToNpc(npcName)
  PaGlobal_NpcGift:close()
  local message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SUCCESS_PROPOSETONPC", "name", npcName)
  Proc_ShowMessage_Ack(message)
  if false == _ContentsGroup_NewUI_Dialog_All then
    PaGlobal_SetProposeToNpc()
  else
    PaGlobalFunc_DialogList_All_SetProposeToNpc()
  end
end
function PaGlobal_NpcGift:registEventHandler()
  local ui = self._ui
  ui._presentBtn:addInputEvent("Mouse_LUp", "FGlobal_NpcGift_PopupMessage()")
  ui._confessionBtn:addInputEvent("Mouse_LUp", "FGlobal_NpcGift_Propose()")
  ui._closeBtn:addInputEvent("Mouse_LUp", "FGlobal_NpcGift_Close()")
  ui._slot_PresentItem.icon:addInputEvent("Mouse_On", "FGlobal_NpcGift_OnPresentTooltip()")
  ui._slot_PresentItem.icon:addInputEvent("Mouse_Out", "FGlobal_NpcGift_OutTooltip()")
  for idx = 0, self._interestItemCount - 1 do
    ui._slot_InterestItemList[idx].icon:addInputEvent("Mouse_On", "FGlobal_NpcGift_OnTooltip(" .. idx .. ")")
    ui._slot_InterestItemList[idx].icon:addInputEvent("Mouse_Out", "FGlobal_NpcGift_OutTooltip()")
  end
  ui._iconDetail:addInputEvent("Mouse_On", "FGlobal_NpcGift_TooltipShow(true)")
  ui._iconDetail:addInputEvent("Mouse_Out", "FGlobal_NpcGift_TooltipShow(false)")
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_NpcGift")
registerEvent("FromClient_VaryIntimacy_Dialog", "FromClient_NpcGiftSend")
registerEvent("FromClient_SuccessProposeToNpc", "FromClient_SuccessProposeToNpc")

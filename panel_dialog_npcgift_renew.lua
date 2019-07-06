local _panel = Panel_Dialog_NpcGift_Renew
local NpcGift = {
  _ui = {
    _bottomBG = UI.getChildControl(_panel, "Static_BottomBg"),
    _questionBtn = UI.getChildControl(_panel, "Button_Question"),
    _closeBtn = UI.getChildControl(_panel, "Button_Close"),
    _iconDetail = UI.getChildControl(_panel, "StaticText_DetailIcon"),
    _detailDesc = UI.getChildControl(_panel, "StaticText_DetailDesc"),
    _slot_PresentItem = {},
    _interestItemListBG = UI.getChildControl(_panel, "Static_InterestItemListBg"),
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
function NpcGift:init()
  _panel:SetShow(false)
  self._ui._presentBtn = UI.getChildControl(self._ui._bottomBG, "Button_Present")
  self._ui._confessionBtn = UI.getChildControl(self._ui._bottomBG, "Button_Confession")
  self._ui._presentConsoleTxt = UI.getChildControl(self._ui._bottomBG, "StaticText_Present_ConsoleUI")
  self._ui._confessionConsoleTxt = UI.getChildControl(self._ui._bottomBG, "StaticText_Confession_ConsoleUI")
  self._ui._detailConsoleTxt = UI.getChildControl(self._ui._bottomBG, "StaticText_Detail_ConsoleUI")
  local isXbox = ToClient_isConsole()
  self._ui._presentBtn:SetShow(not isXbox)
  self._ui._confessionBtn:SetShow(not isXbox)
  self._ui._presentConsoleTxt:SetShow(isXbox)
  self._ui._confessionConsoleTxt:SetShow(isXbox)
  self._ui._detailConsoleTxt:SetShow(isXbox)
  self._ui._slot_PresentItem.icon = UI.getChildControl(_panel, "Static_PresentItemSlot")
  SlotItem.new(self._ui._slot_PresentItem, "PresentItem", 0, _panel, slotConfig)
  self._ui._slot_PresentItem:createChild()
  self._ui._slot_PresentItem.empty = true
  self._ui._slot_PresentItem:clearItem()
  self._ui._slot_PresentItem.border:SetSize(42, 42)
  Panel_Tooltip_Item_SetPosition(0, self._ui._slot_PresentItem, "NpcGift")
  for idx = 0, self._interestItemCount - 1 do
    local itemSlot = {}
    itemSlot.icon = UI.getChildControl(self._ui._interestItemListBG, "Static_InterestItemSlot" .. tostring(idx))
    SlotItem.new(itemSlot, "InterestItemSlot_" .. tostring(idx), 0, _panel, slotConfig)
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
function NpcGift:setItemToSlot(uiSlot, itemSS, count)
  uiSlot.icon:AddEffect("UI_Button_Hide", false, 0, 0)
  uiSlot.empty = false
  uiSlot.icon:SetMonoTone(false)
  uiSlot:setItemByStaticStatus(itemSS, count, -1)
end
function NpcGift:open()
  _panel:SetShow(true)
  self._ui._slot_PresentItem:clearItem()
  self._ui._slot_PresentItem.empty = true
  self._count = 0
  local interestitemSize = ToClient_getInterestNpcGiftSize()
  local slotIndex = 0
  for idx = 0, interestitemSize - 1 do
    self._ui._slot_InterestItemList[idx]:clearItem()
    if idx == self._interestItemCount then
      break
    end
    local itemSS = ToClient_getInterestNpcGift(idx)
    if nil ~= itemSS and nil ~= itemSS:get() then
      self:setItemToSlot(self._ui._slot_InterestItemList[slotIndex], itemSS, 1)
      slotIndex = slotIndex + 1
    end
  end
end
function NpcGift:close()
  _panel:SetShow(false)
  if true == _ContentsGroup_RenewUI then
    PaGlobalFunc_MainDialog_ReOpen(true)
  end
end
function PaGlobalFunc_NpcGift_RClickForTargetItem(slotNo, itemWrapper, count, inventoryType)
  if nil == itemWrapper then
    return
  end
  local self = NpcGift
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
  local self = NpcGift
  self._count = count
  local itemWrapper = getInventoryItemByType(self._inventoryType, self._slotNo)
  if nil == itemWrapper then
    return
  end
  self:setItemToSlot(self._ui._slot_PresentItem, itemWrapper:getStaticStatus(), count)
end
function FGlobal_NpcGift_PopupMessage()
  local self = NpcGift
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
  resultProposeToNpc()
end
function FGlobal_NpcGift_Confirm()
  local self = NpcGift
  ToClient_giveNpcGift(self._inventoryType, self._slotNo, self._count)
end
function FGlobal_NpcGift_Open()
  NpcGift:open()
  FGlobal_NpcGift_TooltipShow(false)
end
function PaGlobalFunc_NpcGift_Close()
  NpcGift:close()
  FGlobal_NpcGift_TooltipShow(false)
end
function PaGlobalFunc_NpcGift_ShowPresentTooltip()
  local self = NpcGift
  local itemWrapper = getInventoryItemByType(self._inventoryType, self._slotNo)
  if nil == itemWrapper then
    return
  end
  Panel_Tooltip_Item_Show(itemWrapper:getStaticStatus(), NpcGift._ui._slot_PresentItem.icon, true, false)
end
function PaGlobalFunc_NpcGift_ShowTooltip(idx)
  local needSS = ToClient_getInterestNpcGift(idx)
  Panel_Tooltip_Item_Show(needSS, NpcGift._ui._slot_InterestItemList[idx].icon, true, false)
end
function PaGlobalFunc_NpcGift_HideTooltip()
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobalFunc_NpcGift_FilterGift(slotNo, notUse_itemWrappers, whereType)
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
  NpcGift._ui._detailDesc:SetShow(isShow)
end
function FromClient_luaLoadComplete_NpcGift()
  local self = NpcGift
  self:init()
  self:registEventHandler()
  self:registMessageHandler()
end
function FromClient_NpcGiftSend()
  local self = NpcGift
  self._count = 0
  self._inventoryType = 0
  self._slotNo = -1
  self._ui._slot_PresentItem.empty = true
  self._ui._slot_PresentItem:clearItem()
end
function FromClient_SuccessProposeToNpc(npcName)
  NpcGift:close()
  local message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SUCCESS_PROPOSETONPC", "name", npcName)
  Proc_ShowMessage_Ack(message)
  if true == _ContentsGroup_RenewUI then
    local npcWord = ToClient_getNpcProposeTalk()
    PaGlobalFunc_MainDialog_Right_ReOpenWithOtherMent(npcWord)
  else
    PaGlobal_SetProposeToNpc()
  end
end
function NpcGift:registEventHandler()
  local ui = self._ui
  self._ui._presentBtn:addInputEvent("Mouse_LUp", "FGlobal_NpcGift_PopupMessage()")
  self._ui._confessionBtn:addInputEvent("Mouse_LUp", "FGlobal_NpcGift_Propose()")
  if true == ToClient_IsDevelopment() then
    self._ui._presentConsoleTxt:addInputEvent("Mouse_LUp", "FGlobal_NpcGift_PopupMessage()")
    self._ui._presentConsoleTxt:SetIgnore(false)
    self._ui._confessionConsoleTxt:addInputEvent("Mouse_LUp", "FGlobal_NpcGift_Propose()")
    self._ui._confessionConsoleTxt:SetIgnore(false)
  end
  ui._closeBtn:addInputEvent("Mouse_LUp", "PaGlobalFunc_NpcGift_Close()")
  ui._slot_PresentItem.icon:addInputEvent("Mouse_On", "PaGlobalFunc_NpcGift_ShowPresentTooltip()")
  ui._slot_PresentItem.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_NpcGift_HideTooltip()")
  for idx = 0, self._interestItemCount - 1 do
    ui._slot_InterestItemList[idx].icon:addInputEvent("Mouse_On", "PaGlobalFunc_NpcGift_ShowTooltip(" .. idx .. ")")
    ui._slot_InterestItemList[idx].icon:addInputEvent("Mouse_Out", "PaGlobalFunc_NpcGift_HideTooltip()")
  end
  ui._iconDetail:addInputEvent("Mouse_On", "FGlobal_NpcGift_TooltipShow(true)")
  ui._iconDetail:addInputEvent("Mouse_Out", "FGlobal_NpcGift_TooltipShow(false)")
  if true == ToClient_isConsole() then
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "FGlobal_NpcGift_Propose()")
  end
end
function NpcGift:registMessageHandler()
  registerEvent("FromClient_VaryIntimacy_Dialog", "FromClient_NpcGiftSend")
  registerEvent("FromClient_SuccessProposeToNpc", "FromClient_SuccessProposeToNpc")
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_NpcGift")

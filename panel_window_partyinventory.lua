Panel_Window_PartyInventory:SetShow(false, false)
Panel_Window_PartyInventory:ActiveMouseEventEffect(true)
Panel_Window_PartyInventory:setMaskingChild(true)
Panel_Window_PartyInventory:setGlassBackground(true)
partyInven = {
  itemSlot = UI.getChildControl(Panel_Window_PartyInventory, "Static_Slot0"),
  invenWeightTxt = UI.getChildControl(Panel_Window_PartyInventory, "Static_Text_Weight"),
  slotBackground = Array.new(),
  slots = Array.new(),
  _listPool = {},
  slotCount = 10,
  _slotsCols = 5,
  _slotsRows = 0,
  slotStartX = 10,
  slotStartY = 10,
  slotGapX = 42,
  slotGapY = 47,
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true
  }
}
local btnPartyInven
local btnClose = UI.getChildControl(Panel_Window_PartyInventory, "Button_Win_Close")
local btnQuestion = UI.getChildControl(Panel_Window_PartyInventory, "StaticText_Desc")
function partyInven:Init()
  if false == _ContentsGroup_RemasterUI_Party then
    btnPartyInven = UI.getChildControl(Panel_Party, "Button_PartyInven")
  else
    btnPartyInven = UI.getChildControl(Panel_Widget_Party, "Button_PartyInven")
  end
  for listIdx = 0, self.slotCount - 1 do
    local slot = {}
    slot.empty = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_PartyInventory, "PartyInventory_Slot_Base_" .. listIdx)
    CopyBaseProperty(self.itemSlot, slot.empty)
    slot.empty:SetShow(true)
    local row = math.floor(listIdx / self._slotsCols)
    local col = listIdx % self._slotsCols
    slot.empty:SetPosX(self.slotStartX + self.slotGapX * col)
    slot.empty:SetPosY(self.slotStartY + self.slotGapY * row)
    self.slotBackground[listIdx] = slot
  end
  for ii = 0, self.slotCount - 1 do
    local slot = {}
    SlotItem.new(slot, "ItemIcon_" .. ii, ii, Panel_Window_PartyInventory, self._slotConfig)
    slot:createChild()
    local row = math.floor(ii / self._slotsCols)
    local col = ii % self._slotsCols
    slot.icon:SetPosX(self.slotStartX + self.slotGapX * col)
    slot.icon:SetPosY(self.slotStartY + self.slotGapY * row)
    slot.icon:SetSize(35, 35)
    slot.border:SetSize(35, 35)
    slot.count:SetHorizonRight()
    slot.count:SetVerticalBottom()
    slot.count:SetSpanSize(5, 2)
    self.slots[ii] = slot
  end
  btnQuestion:SetEnableArea(0, 0, 130, 20)
end
function partyInven:Clear()
  for listIdx = 0, self.slotCount - 1 do
    local slot = self.slots[listIdx]
    slot:clearItem()
  end
end
function partyInven:Update()
  for listIdx = 0, self.slotCount - 1 do
    local slot = self.slots[listIdx]
    slot:clearItem()
  end
  for slotIndex = 0, self.slotCount - 1 do
    local itemWrapper = ToClient_GetPartyInventory(slotIndex)
    local getPossible = ToClient_IsLootable(slotIndex)
    if nil ~= itemWrapper then
      local slot = self.slots[slotIndex]
      slot:setItem(itemWrapper)
      if getPossible then
        slot.icon:SetMonoTone(false)
      else
        slot.icon:SetMonoTone(true)
      end
      slot.icon:addInputEvent("Mouse_RUp", "partyInven_slotItemRClick( " .. slotIndex .. ", " .. tostring(getPossible) .. " )")
      slot.icon:addInputEvent("Mouse_On", "partyInven_slotItemOn( " .. slotIndex .. " )")
      slot.icon:addInputEvent("Mouse_Out", "partyInven_slotItemOff()")
    end
  end
  local currentWeight = ToClient_GetCurrentWeight()
  self.invenWeightTxt:SetText(string.format("%.0f", currentWeight / 10000) .. "/50" .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT"))
end
function FromClient_ChangePartyInventory()
  btnPartyInven:EraseAllEffect()
  btnPartyInven:AddEffect("fUI_Party_Inventory_01A", false, 0, 0)
  partyInven:Update()
end
function partyInven_slotItemRClick(slotNo, getType)
  local itemWrapper = ToClient_GetPartyInventory(slotNo)
  if nil == itemWrapper then
    return
  end
  local getPcInven = function(slotNo, itemCount)
    ToClient_GetPartyItem(itemCount, slotNo)
    partyInven:Update()
  end
  if not getType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYINVENTORY_ACCESS_ACK"), 3)
    return
  end
  local itemCount_s64 = itemWrapper:get():getCount_s64()
  if 1 ~= itemCount_s64 then
    Panel_NumberPad_Show(true, itemCount_s64, slotNo, getPcInven)
  else
    ToClient_GetPartyItem(1, slotNo)
    partyInven:Update()
  end
end
function partyInven_slotItemOn(slotNo)
  local self = partyInven
  local slot = self.slots[slotNo]
  local itemWrapper = ToClient_GetPartyInventory(slotNo)
  if nil == itemWrapper then
    return
  end
  Panel_Tooltip_Item_Show(itemWrapper, slot.icon, false, true, nil)
end
function partyInven_slotItemOff()
  Panel_Tooltip_Item_hideTooltip()
end
function FGlobal_PartyInventoryOpen()
  local partyNum = RequestParty_getPartyMemberCount()
  if 0 == partyNum then
    return
  end
  local lootType = RequestParty_getPartyLootType()
  if 4 ~= lootType then
    return
  end
  Panel_Window_PartyInventory:SetShow(true)
  partyInven:Update()
end
function FGlobal_PartyInventoryClose()
  Panel_Window_PartyInventory:SetShow(false)
end
function PartyInventorySimpleTooltip(isShow)
  local name, desc, uiControl
  name = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYINVENTORY_TOOLTIP_NAME")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYINVENTORY_TOOLTIP_DESC")
  uiControl = btnQuestion
  if isShow == true then
    registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function partyInven:registEventHandler()
  btnPartyInven:addInputEvent("Mouse_LUp", "FGlobal_PartyInventoryOpen()")
  btnClose:addInputEvent("Mouse_LUp", "FGlobal_PartyInventoryClose()")
  btnQuestion:addInputEvent("Mouse_On", "PartyInventorySimpleTooltip( true )")
  btnQuestion:addInputEvent("Mouse_Out", "PartyInventorySimpleTooltip( false )")
  btnQuestion:setTooltipEventRegistFunc("PartyInventorySimpleTooltip( true )")
end
function partyInven:registMessageHandler()
  registerEvent("FromClient_ChangePartyInventory", "FromClient_ChangePartyInventory")
end
partyInven:Init()
partyInven:registEventHandler()
partyInven:registMessageHandler()

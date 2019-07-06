Instance_Looting:SetShow(false, false)
Instance_Looting:setMaskingChild(true)
Instance_Looting:ActiveMouseEventEffect(true)
Instance_Looting:setGlassBackground(true)
Instance_Looting:RegisterShowEventFunc(true, "LootingShowAni()")
Instance_Looting:RegisterShowEventFunc(false, "LootingHideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
Panel_Looting_Value_isCloseLooting = false
local looting = {
  MAX_LOOTING_SLOT_COUNT = 12,
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true
  },
  config = {
    slotCount = MAX_LOOTING_SLOT_COUNT,
    slotCols = 4,
    slotRows = 0,
    slotBGStartX = 11,
    slotBGStartY = 57,
    slotStartX = 13,
    slotStartY = 59,
    slotGapX = 47,
    slotGapY = 47
  },
  slots = Array.new(),
  selectSlotNo = -1,
  remainItemCnt = 0
}
local _buttonCancel = UI.getChildControl(Instance_Looting, "Button_Cancel")
local _buttonLootAll = UI.getChildControl(Instance_Looting, "Button_LootAll")
local _buttonLootAllToServant = UI.getChildControl(Instance_Looting, "Button_LootAllToServant")
_buttonCancel:addInputEvent("Mouse_LUp", "Panel_Looting_buttonCancel_Mouse_Click()")
_buttonLootAll:addInputEvent("Mouse_LUp", "Panel_Looting_buttonLootAll_Mouse_Click( true )")
_buttonLootAllToServant:addInputEvent("Mouse_LUp", "Panel_Looting_buttonLootAllToServant_Mouse_Click()")
registerEvent("EventLootingWindowUpdate", "Panel_Looting_Update")
registerEvent("EventLootingCancel", "Panel_Looting_Cancel")
function LootingShowAni()
  Instance_Looting:SetAlpha(0)
  UIAni.AlphaAnimation(1, Instance_Looting, 0, 0.15)
  Panel_Looting_Value_isCloseLooting = false
end
function LootingHideAni()
end
function looting:init()
  for ii = 1, looting.MAX_LOOTING_SLOT_COUNT do
    local row = math.floor((ii - 1) / looting.config.slotCols)
    local col = (ii - 1) % looting.config.slotCols
    local looting_SlotBGBase = UI.getChildControl(Instance_Looting, "Static_Texture_Slot_Background")
    local looting_SlotBG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Instance_Looting, "looting_SlotBG_" .. ii)
    CopyBaseProperty(looting_SlotBGBase, looting_SlotBG)
    local slotNo = ii - 1
    local slot = {}
    SlotItem.new(slot, "Looting_item_" .. slotNo, slotNo, Instance_Looting, looting.slotConfig)
    slot:createChild()
    slot.icon:addInputEvent("Mouse_RUp", "Panel_Looting_SlotRClick(" .. slotNo .. ")")
    slot.icon:addInputEvent("Mouse_LUp", "Panel_Looting_SlotLClick(" .. slotNo .. ")")
    slot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"looting\",true)")
    slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"looting\",false)")
    Panel_Tooltip_Item_SetPosition(slotNo, slot, "looting")
    looting_SlotBG:SetPosX(looting.config.slotBGStartX + looting.config.slotGapX * col)
    looting_SlotBG:SetPosY(looting.config.slotBGStartY + looting.config.slotGapY * row + 3)
    looting_SlotBG:SetShow(true)
    looting_SlotBG:SetIgnore(false)
    slot.icon:SetPosX(looting.config.slotStartX + looting.config.slotGapX * col)
    slot.icon:SetPosY(looting.config.slotStartY + looting.config.slotGapY * row + 3)
    slot.icon:SetIgnore(false)
    looting.slots[ii] = slot
  end
end
local function closePanelLooting()
  if Instance_Looting:IsShow() then
    Instance_Looting:SetShow(false, false)
    _buttonLootAll:ClearDisableTime()
    CheckChattingInput()
    if Instance_Looting:IsShow() == false then
      Panel_Looting_Value_isCloseLooting = true
    end
  end
end
function Panel_Looting_Update(empty)
  if true == _ContentsGroup_RenewUI then
    looting_pickAllItemToPlayer()
    audioPostEvent_SystemUi(3, 9)
    _AudioPostEvent_SystemUiForXBOX(3, 9)
    return
  end
  if 1 == empty then
    Panel_Looting_Value_isCloseLooting = true
    Panel_Tooltip_Item_Show_GeneralNormal(looting.selectSlotNo, "looting", false)
    closePanelLooting()
  else
    Instance_Looting:SetShow(true, true)
    Panel_Looting_Value_isCloseLooting = false
  end
  if looting_isPickItemToServant() then
    Instance_Looting:SetSize(210, 288)
    _buttonLootAllToServant:SetShow(true)
    _buttonLootAllToServant:SetPosY(215)
    _buttonCancel:SetPosY(248)
    _buttonLootAll:SetPosY(248)
  else
    Instance_Looting:SetSize(210, 255)
    _buttonLootAllToServant:SetShow(false)
    _buttonLootAllToServant:ComputePos()
    _buttonCancel:ComputePos()
    _buttonLootAll:ComputePos()
  end
  local lootingCount = looting_getItemCount()
  looting.remainItemCnt = 0
  for ii = 1, looting.MAX_LOOTING_SLOT_COUNT do
    local slot = looting.slots[ii]
    local itemWrapper = looting_getItem(ii - 1)
    if nil ~= itemWrapper then
      slot:setItem(itemWrapper)
      looting.remainItemCnt = looting.remainItemCnt + 1
    else
      if ii - 1 == looting.selectSlotNo then
        Panel_Tooltip_Item_Show_GeneralNormal(looting.selectSlotNo, "looting", false)
      end
      slot:clearItem()
    end
  end
end
function Panel_Looting_PickupBySlot(slotNo)
  local self = looting
  self.selectSlotNo = slotNo
  local itemWrapper = looting_getItem(slotNo)
  if nil == itemWrapper then
    return
  end
  local s64_count = itemWrapper:get():getCount_s64()
  local itemKey = itemWrapper:get():getKey():getItemKey()
  local itemName = itemWrapper:getStaticStatus():getName()
  if 1 == itemKey then
    Panel_Looting_Pickup(s64_count, slotNo)
  else
    Panel_NumberPad_Show(true, s64_count, slotNo, Panel_Looting_Pickup)
  end
  audioPostEvent_SystemUi(3, 6)
  _AudioPostEvent_SystemUiForXBOX(3, 6)
end
function Panel_Looting_Pickup(s64_count, slotNo)
  looting_slotClick(slotNo, s64_count)
end
function Panel_Looting_SlotRClick(slotNo)
  Panel_Looting_PickupBySlot(slotNo)
end
function Panel_Looting_SlotLClick(slotNo)
  Panel_Looting_PickupBySlot(slotNo)
end
function Panel_Looting_buttonLootAll_Mouse_Click(isMouseEvent)
  if not isMouseEvent then
    if not _buttonLootAll:checkAutoDisableTime() then
      return
    end
    _buttonLootAll:DoAutoDisableTime()
  end
  looting.selectSlotNo = -1
  looting_pickAllItemToPlayer()
  audioPostEvent_SystemUi(3, 9)
  _AudioPostEvent_SystemUiForXBOX(3, 9)
end
function Panel_Looting_buttonLootAllToServant_Mouse_Click()
  looting.selectSlotNo = -1
  looting_pickAllItemToServant()
end
function Panel_Looting_buttonCancel_Mouse_Click()
  local dropType = looting_getDropType()
  if CppEnums.DropType.Type_CollectInfo == dropType or CppEnums.DropType.Type_Harvest == dropType then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_LOOT_MEMO")
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_LOOT_TITLE"),
      content = messageBoxMemo,
      functionYes = Panel_Looting_buttonCancel_Mouse_ClickXXX,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    Panel_Looting_buttonCancel_Mouse_ClickXXX()
  end
end
function Panel_Looting_buttonCancel_Mouse_ClickXXX()
  closePanelLooting()
  looting_cancel()
  local actor = interaction_getInteractable()
  if actor ~= nil then
    Interaction_Show(actor)
  end
end
function Panel_Looting_Cancel()
  looting.selectSlotNo = -1
  closePanelLooting()
  looting_cancel()
  Panel_Tooltip_Item_hideTooltip()
  local actor = interaction_getInteractable()
  if actor ~= nil then
    Interaction_Show(actor)
  end
end
function Panel_Looting_PickAll()
  looting.selectSlotNo = -1
  closePanelLooting()
end
function Panel_Looting_Show()
  looting.selectSlotNo = -1
  Instance_Looting:SetShow(true, true)
  Interaction_Close()
end
looting:init()

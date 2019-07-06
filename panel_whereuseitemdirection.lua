Panel_WhereUseItemDirection:SetShow(false, false)
Panel_WhereUseItemDirection:SetDragAll(true)
local whereUseItem = {
  _slot = UI.getChildControl(Panel_WhereUseItemDirection, "Static_Slot"),
  stc_soulGroup = UI.getChildControl(Panel_WhereUseItemDirection, "Static_SoulGroup"),
  stc_smallSoulCollector = nil,
  stc_smallSoulCollectorFull = nil,
  txt_soulCollector = nil,
  txt_soulCollectorFull = nil,
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true
  },
  currentItemKey = nil,
  slotNo = nil,
  saveItemSSW = nil,
  widgetItemKey = nil,
  slot = nil,
  currentMonsterGroupKey = nil,
  cachedSoulCollector = nil,
  _cachePanelSizeX = 0
}
local weightOver
if false == _ContentsGroup_RemasterUI_Main_Alert then
  weightOver = UI.getChildControl(Panel_Endurance, "StaticText_WeightOver")
else
  weightOver = nil
end
local self = whereUseItem
function WhereUseItemDirectionInit()
  self.stc_smallSoulCollector = UI.getChildControl(self.stc_soulGroup, "Static_SmallSoulCollector")
  self.stc_smallSoulCollectorFull = UI.getChildControl(self.stc_soulGroup, "Static_SmallSoulCollectorFull")
  self.txt_soulCollector = UI.getChildControl(self.stc_smallSoulCollector, "StaticText_Count")
  self.txt_soulCollectorFull = UI.getChildControl(self.stc_smallSoulCollectorFull, "StaticText_Count")
  self.slot = {}
  SlotItem.new(self.slot, "ItemSlot", 0, self._slot, self._slotConfig)
  self.slot:createChild()
  self.slot.icon:SetPosX(self.slot.icon:GetPosX() + 12)
  self.slot.icon:SetPosY(self.slot.icon:GetPosY() + 3)
  self.slot.count:SetHorizonCenter()
  self.slot.count:SetVerticalBottom()
  self.slot.count:SetSpanSize(0, -28)
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    if Panel_HorseEndurance:GetShow() or Panel_CarriageEndurance:GetShow() or Panel_ShipEndurance:GetShow() then
      if PcEnduranceToggle() then
        Panel_WhereUseItemDirection:SetPosX(getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - 280)
        Panel_WhereUseItemDirection:SetPosY(FGlobal_Panel_Radar_GetSizeY() - 180)
      else
        Panel_WhereUseItemDirection:SetPosX(getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - 190)
        Panel_WhereUseItemDirection:SetPosY(FGlobal_Panel_Radar_GetSizeY() - 180)
      end
    else
      Panel_WhereUseItemDirection:SetPosX(getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - 70)
      Panel_WhereUseItemDirection:SetPosY(FGlobal_Panel_Radar_GetSizeY() - 180)
    end
  else
    Panel_WhereUseItemDirection:SetPosX(getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - 70)
    Panel_WhereUseItemDirection:SetPosY(FGlobal_Panel_Radar_GetSizeY() - 180)
  end
  self._cachePanelSizeX = Panel_WhereUseItemDirection:GetPosX()
end
function WhereUseItemDirectionRestore(itemKey, slotNo, itemCount)
  self.widgetItemKey = itemKey
  WhereUseItemDirectionUpdate(self.saveItemSSW, self.slotNo)
  self.slot.count:SetHorizonCenter()
  self.slot.count:SetVerticalBottom()
  self.slot.count:SetSpanSize(0, -28)
end
local _key
function WhereUseItemDirectionUpdate(itemSSW, slotNo, isShow)
  if nil == itemSSW or nil == slotNo then
    return
  end
  local inventory = getSelfPlayer():get():getInventory()
  local inventoryType = Inventory_GetCurrentInventoryType()
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  if nil == itemWrapper then
    WhereUseItemDirectionClose()
    return
  end
  local itemSSWrapper = itemWrapper:getStaticStatus()
  if not itemSSWrapper:isExchangeItemNPC() and not itemWrapper:isSoulCollector() and false == itemWrapper:getStaticStatus():getItemType() then
    return
  end
  self.saveItemSSW = itemSSW
  if nil ~= itemSSW then
    if nil ~= isShow then
      Panel_WhereUseItemDirection:SetShow(true)
      _key = itemSSW:get()._key:get()
    elseif _key ~= itemSSW:get()._key:get() then
      itemSSW = whereUseItem:getFindItemSSW(_key)
      self.saveItemSSW = itemSSW
      if nil == itemSSW then
        return
      end
    end
    local itemKey = itemSSW:get()._key
    self.currentItemKey = itemKey
    s64_inventoryItemCount = inventory:getItemCount_s64(itemKey)
    if toInt64(0, 0) == s64_inventoryItemCount then
      WhereUseItemDirectionClose()
    end
    if itemWrapper:isSoulCollector() then
      self:UpdateSoulCollector(itemWrapper)
      self.stc_soulGroup:SetShow(true)
    else
      self.slot:setItemByStaticStatus(itemSSW, Int64toInt32(s64_inventoryItemCount))
      self.stc_soulGroup:SetShow(false)
    end
    if self.widgetItemKey == _key then
      self.slot.icon:EraseAllEffect()
      self.slot.icon:AddEffect("fUI_Light", false, 0, 0)
    end
    self.slot.icon:addInputEvent("Mouse_RUp", "WhereUseItemDirectionClose()")
    self.slot.icon:addInputEvent("Mouse_On", "WhereUseItemDirectionSlotItemOn()")
    self.slot.icon:addInputEvent("Mouse_Out", "WhereUseItemDirectionSlotItemOff()")
  end
end
function whereUseItem:getFindItemSSW(itemKey)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return nil
  end
  local invenUseSize = selfPlayer:get():getInventorySlotCount(false)
  for i = __eTInventorySlotNoUseStart, invenUseSize + __eTInventorySlotNoUseStart do
    local itemWrapper = getInventoryItem(i)
    if nil ~= itemWrapper then
      local invenItemSSW = itemWrapper:getStaticStatus()
      if invenItemSSW:get()._key:get() == itemKey then
        return invenItemSSW
      end
    end
  end
  return nil
end
function whereUseItem:UpdateSoulCollector(itemWrapper)
  if nil == itemWrapper then
    return
  end
  local itemSSW = itemWrapper:getStaticStatus()
  if nil == itemSSW then
    return
  end
  self.currentMonsterGroupKey = itemSSW:get()._contentsEventParam1
  local soulCount = itemWrapper:getSoulCollectorCount()
  local soulMax = itemWrapper:getSoulCollectorMaxCount()
  if nil == soulCount or nil == soulMax then
    return
  end
  if soulCount < soulMax then
    self.slot:setItemByStaticStatus(itemSSW, itemWrapper:get():getCount_s64(), -1, false, false, true, soulCount, soulMax, true)
    if soulCount > soulMax * 0.9 then
      self.cachedSoulCollector = self:countAllSoulCollector()
    else
      self:countAllSoulCollector()
    end
    return
  end
  local foundSoulCollector = {}
  foundSoulCollector = self:countAllSoulCollector()
  if nil ~= self.cachedSoulCollector and #self.cachedSoulCollector > 0 then
    local loopCount = math.min(#foundSoulCollector, #self.cachedSoulCollector)
    for ii = 1, loopCount do
      if foundSoulCollector[ii].count ~= self.cachedSoulCollector[ii].count then
        self.slotNo = foundSoulCollector[ii].slotNo
        local nextSoulCollector = getInventoryItem(self.slotNo)
        self.saveItemSSW = nextSoulCollector:getStaticStatus()
        self.cachedSoulCollector = {}
        WhereUseItemDirectionUpdate(self.saveItemSSW, self.slotNo, true)
        break
      end
    end
  else
    self.cachedSoulCollector = self:countAllSoulCollector()
    self.slot:setItemByStaticStatus(itemSSW, itemWrapper:get():getCount_s64(), -1, false, false, true, soulCount, soulMax, true)
  end
end
function whereUseItem:countAllSoulCollector()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local invenUseSize = selfPlayer:get():getInventorySlotCount(false)
  local countSoulCollector = 0
  local countFullSoulCollector = 0
  local foundSoulCollector = {}
  for ii = __eTInventorySlotNoUseStart, invenUseSize + __eTInventorySlotNoUseStart do
    local itemWrapper = getInventoryItem(ii)
    if nil ~= itemWrapper and itemWrapper:isSoulCollector() then
      local invenItemSSW = itemWrapper:getStaticStatus()
      local monsterGroupKey = invenItemSSW:get()._contentsEventParam1
      if self.currentMonsterGroupKey == monsterGroupKey then
        foundSoulCollector[#foundSoulCollector + 1] = {
          slotNo = ii,
          count = itemWrapper:getSoulCollectorCount()
        }
        countSoulCollector = countSoulCollector + 1
        local soulCount = itemWrapper:getSoulCollectorCount()
        local soulMax = itemWrapper:getSoulCollectorMaxCount()
        if soulCount >= soulMax then
          countFullSoulCollector = countFullSoulCollector + 1
        end
      end
    end
  end
  self.txt_soulCollector:SetText(tostring(countSoulCollector - countFullSoulCollector))
  self.txt_soulCollectorFull:SetText(tostring(countFullSoulCollector))
  return foundSoulCollector
end
function PcEnduranceToggle()
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    return weightOver:GetShow()
  else
    return false
  end
end
function whereUseItemDirectionPosition()
  local targetPanel = Panel_Radar
  if nil ~= Panel_WorldMiniMap and true == Panel_WorldMiniMap:GetShow() then
    targetPanel = Panel_WorldMiniMap
  end
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    if Panel_HorseEndurance:GetShow() or Panel_CarriageEndurance:GetShow() or Panel_ShipEndurance:GetShow() then
      if PcEnduranceToggle() then
        Panel_WhereUseItemDirection:SetPosX(getScreenSizeX() - targetPanel:GetSizeX() - 280)
        Panel_WhereUseItemDirection:SetPosY(targetPanel:GetSizeY() - 100)
      else
        Panel_WhereUseItemDirection:SetPosX(getScreenSizeX() - targetPanel:GetSizeX() - 190)
        Panel_WhereUseItemDirection:SetPosY(targetPanel:GetSizeY() - 100)
      end
    else
      Panel_WhereUseItemDirection:SetPosX(getScreenSizeX() - targetPanel:GetSizeX() - 150)
      Panel_WhereUseItemDirection:SetPosY(targetPanel:GetSizeY() - 100)
    end
  else
    Panel_WhereUseItemDirection:SetPosX(getScreenSizeX() - targetPanel:GetSizeX() - 80)
    Panel_WhereUseItemDirection:SetPosY(targetPanel:GetPosY() + targetPanel:GetSizeY() - Panel_WhereUseItemDirection:GetSizeY())
  end
  if nil ~= self.slotNo then
    local itemWrapper = getInventoryItemByType(Inventory_GetCurrentInventoryType(), self.slotNo)
    if nil ~= itemWrapper and itemWrapper:isSoulCollector() then
      Panel_WhereUseItemDirection:SetPosX(Panel_WhereUseItemDirection:GetPosX() - 60, Panel_WhereUseItemDirection:GetPosY())
    end
  end
end
function FGlobal_WhereUseITemDirectionOpen(itemSSW, slotNo)
  self.slotNo = slotNo
  if nil == itemSSW then
    UI.ASSERT_NAME(nil ~= itemSSW, "itemSSW\234\176\128 nil\236\158\133\235\139\136\235\139\164.", "\234\185\128\236\157\152\236\167\132")
    return
  end
  whereUseItemDirectionPosition()
  WhereUseItemDirectionUpdate(itemSSW, slotNo, true)
  self.slot.count:SetHorizonCenter()
  self.slot.count:SetVerticalBottom()
  self.slot.count:SetTextHorizonCenter()
  self.slot.count:SetSpanSize(0, -28)
end
function WhereUseItemDirectionClose()
  Panel_WhereUseItemDirection:SetShow(false)
  WhereUseItemDirectionSlotItemOff()
end
function WhereUseItemDirectionSlotItemOn()
  local itemStaticWrapper = getItemEnchantStaticStatus(self.currentItemKey)
  Panel_Tooltip_Item_Show(itemStaticWrapper, self.slot.icon, true, false)
end
function WhereUseItemDirectionSlotItemOff()
  Panel_Tooltip_Item_hideTooltip()
end
function whereUseItem_registMessageHandler()
  registerEvent("EventAddItemToInventory", "WhereUseItemDirectionRestore")
end
WhereUseItemDirectionInit()
whereUseItem_registMessageHandler()
registerEvent("onScreenResize", "whereUseItemDirectionPosition")
registerEvent("FromClient_RenderModeChangeState", "WhereUseItemDirectionRestore")

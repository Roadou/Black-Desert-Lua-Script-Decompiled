Panel_Widget_DropItem:SetShow(false)
PaGlobal_DropItem = {
  _ui = {
    _closeButton = UI.getChildControl(Panel_Widget_DropItem, "Button_Win_Close"),
    _regionTitle = UI.getChildControl(Panel_Widget_DropItem, "StaticText_RegionTitle"),
    _templeteSlotBg = UI.getChildControl(Panel_Widget_DropItem, "Static_ItemSlotBg"),
    _buttonDropItem = UI.getChildControl(Panel_Widget_DropItem, "Button_DropItemOpen"),
    _slotBg = {},
    _slot = {}
  },
  _slotConfig = {createIcon = true, createBorder = true},
  _maxCount = 60,
  _currentRegionKey = nil
}
function PaGlobal_DropItem:Init()
  for index = 0, self._maxCount - 1 do
    self._ui._slotBg[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Widget_DropItem, "_DropItem_SlotBg_" .. index)
    CopyBaseProperty(self._ui._templeteSlotBg, self._ui._slotBg[index])
    self._ui._slotBg[index]:SetShow(false)
    self._ui._slotBg[index]:SetPosX(self._ui._templeteSlotBg:GetPosX() + index % 6 * 50)
    self._ui._slotBg[index]:SetPosY(self._ui._templeteSlotBg:GetPosY() + math.floor(index / 6) * 50 + 5)
    local slot = {}
    SlotItem.new(slot, "DropItemSlot_" .. index, index, self._ui._slotBg[index], self._slotConfig)
    slot:createChild()
    slot.icon:addInputEvent("Mouse_On", "PaGlobal_DropItem:ItemTooltip_Show(" .. index .. ")")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobal_DropItem:ItemTooltip_Hide()")
    self._ui._slot[index] = slot
  end
  self._ui._closeButton:addInputEvent("Mouse_LUp", "PaGlobal_DropItem:Close()")
  self._ui._buttonDropItem:addInputEvent("Mouse_LUp", "PaGlobal_DropItem:OpenDropItemAll()")
end
function PaGlobal_DropItem:Open()
  Panel_Widget_DropItem:SetShow(true)
end
function PaGlobal_DropItem:Close()
  Panel_Widget_DropItem:SetShow(false)
end
function PaGlobal_DropItem:OpenDropItemAll()
  if nil ~= self._currentRegionKey then
    FGlobal_DropItemWindow_Open(self._currentRegionKey)
  end
end
function FGlobal_DropItemOpen()
  local self = PaGlobal_DropItem
  if Panel_Widget_DropItem:GetShow() then
    self:Close()
    return
  end
  self:Update()
  self:Open()
end
function PaGlobal_DropItem:Update()
  local currentRegionKey = FGlobal_GetRegionKey_ByDropItem()
  local itemCount = ToClient_GetRegionDropItemSize(currentRegionKey)
  if itemCount > 0 then
    self._currentRegionKey = currentRegionKey
    for index = 0, self._maxCount - 1 do
      if index < itemCount then
        local itemSSW = ToClient_GetRegionDropItemWrapper(self._currentRegionKey, index)
        self._ui._slot[index]:setItemByStaticStatus(itemSSW)
        self._ui._slotBg[index]:SetShow(true)
      else
        self._ui._slotBg[index]:SetShow(false)
      end
    end
    local sizeY = math.floor(itemCount / 6)
    Panel_Widget_DropItem:SetSize(Panel_Widget_DropItem:GetSizeX(), self._ui._slotBg[itemCount - 1]:GetPosY() + self._ui._slotBg[itemCount - 1]:GetSizeY() + 56)
    self._ui._buttonDropItem:ComputePos()
  else
    return
  end
  local regionWrapper = getRegionInfoWrapper(self._currentRegionKey)
  if nil == regionWrapper then
    return
  end
  self._ui._regionTitle:SetText(regionWrapper:getAreaName())
end
function PaGlobal_DropItem:ItemTooltip_Show(index)
  local itemSSW = ToClient_GetRegionDropItemWrapper(self._currentRegionKey, index)
  if nil ~= itemSSW then
    Panel_Tooltip_Item_SetPosition(index, self._ui._slot[index], "dropItem")
    Panel_Tooltip_Item_Show(itemSSW, Panel_Widget_DropItem, true)
  end
end
function PaGlobal_DropItem:ItemTooltip_Hide()
  Panel_Tooltip_Item_hideTooltip()
end
PaGlobal_DropItem:Init()

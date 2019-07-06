Panel_Window_DropItem:SetShow(false)
PaGlobal_WorldDropItem = {
  _ui = {
    _closeButton = UI.getChildControl(Panel_Window_DropItem, "Button_Win_Close"),
    _list2Region = UI.getChildControl(Panel_Window_DropItem, "List2_Region"),
    _frameDropItem = UI.getChildControl(Panel_Window_DropItem, "Frame_RegionDropItem"),
    _topDescBg = UI.getChildControl(Panel_Window_DropItem, "Static_TopArea"),
    _bottomDescBg = UI.getChildControl(Panel_Window_DropItem, "Static_DescBg"),
    _autoNaviButton = UI.getChildControl(Panel_Window_DropItem, "Button_Navi"),
    _frameContent = nil,
    _itemGroupUi = {
      [0] = nil,
      [1] = nil,
      [2] = nil,
      [3] = nil
    },
    _weaponSlotTempleteBg = nil,
    _armorSlotTempleteBg = nil,
    _accessorySlotTempleteBg = nil,
    _etcSlotTempleteBg = nil,
    _slotBg = {
      [0] = {},
      [1] = {},
      [2] = {},
      [3] = {}
    },
    _slot = {
      [0] = {},
      [1] = {},
      [2] = {},
      [3] = {}
    }
  },
  _slotConfig = {createIcon = true, createBorder = true},
  _selectedRegionKey = nil,
  _itemKeyByType = {
    [0] = {},
    [1] = {},
    [2] = {},
    [3] = {}
  },
  _maxSlot = 40
}
function PaGlobal_WorldDropItem:Init()
  local control = self._ui
  control._selectedRegionName = UI.getChildControl(control._topDescBg, "StaticText_SelectedRegionName")
  self._ui._selectedRegionName:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  control._needAp = UI.getChildControl(control._topDescBg, "StaticText_NeedAp")
  control._frameContent = UI.getChildControl(control._frameDropItem, "Frame_1_Content")
  control._itemGroupUi[0] = UI.getChildControl(control._frameContent, "Static_WeaponGroup")
  control._title[0] = UI.getChildControl(control._itemGroupUi[0], "StaticText_WeaponTitle")
  control._weaponSlotTempleteBg = UI.getChildControl(control._itemGroupUi[0], "Static_ItemSlotBg")
  control._itemGroupUi[1] = UI.getChildControl(control._frameContent, "Static_ArmorGroup")
  control._title[1] = UI.getChildControl(control._itemGroupUi[1], "StaticText_ArmorTitle")
  control._armorSlotTempleteBg = UI.getChildControl(control._itemGroupUi[1], "Static_ItemSlotBg")
  control._itemGroupUi[2] = UI.getChildControl(control._frameContent, "Static_AccessoryGroup")
  control._title[2] = UI.getChildControl(control._itemGroupUi[2], "StaticText_AccessoryTitle")
  control._accessorySlotTempleteBg = UI.getChildControl(control._itemGroupUi[2], "Static_ItemSlotBg")
  control._itemGroupUi[3] = UI.getChildControl(control._frameContent, "Static_EtcGroup")
  control._title[3] = UI.getChildControl(control._itemGroupUi[3], "StaticText_EtcTitle")
  control._etcSlotTempleteBg = UI.getChildControl(control._itemGroupUi[3], "Static_ItemSlotBg")
  control._scroll = UI.getChildControl(control._frameDropItem, "Frame_1_VerticalScroll")
  control._list2Region:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "DropItemRegion_ControlCreate")
  control._list2Region:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  for index = 0, ToClient_RegionDropItem_GetRegionKeySize() - 1 do
    local regionKey_s64 = ToClient_RegionDropItem_GetRegionKeyByIndex(index)
    control._list2Region:getElementManager():pushKey(regionKey_s64)
  end
  for index = 0, self._maxSlot - 1 do
    control._slotBg[0][index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control._itemGroupUi[0], "DropItem_WeaponSlotBg_" .. index)
    CopyBaseProperty(control._weaponSlotTempleteBg, control._slotBg[0][index])
    control._slotBg[0][index]:SetPosX(20 + index % 7 * 55)
    control._slotBg[0][index]:SetPosY(55 + math.floor(index / 7) * 55)
    control._slotBg[0][index]:SetShow(false)
    control._slot[0][index] = {}
    SlotItem.new(control._slot[0][index], "DropItem_WeaponSlot_" .. index, index, control._slotBg[0][index], self._slotConfig)
    control._slot[0][index]:createChild()
    control._slot[0][index].icon:addInputEvent("Mouse_On", "PaGlobal_WorldDropItem:ItemTooltip_Show(" .. 0 .. "," .. index .. ")")
    control._slot[0][index].icon:addInputEvent("Mouse_Out", "PaGlobal_WorldDropItem:ItemTooltip_Hide()")
    control._slotBg[1][index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control._itemGroupUi[1], "DropItem_ArmorSlotBg_" .. index)
    CopyBaseProperty(control._weaponSlotTempleteBg, control._slotBg[1][index])
    control._slotBg[1][index]:SetPosX(20 + index % 7 * 55)
    control._slotBg[1][index]:SetPosY(55 + math.floor(index / 7) * 55)
    control._slotBg[1][index]:SetShow(false)
    control._slot[1][index] = {}
    SlotItem.new(control._slot[1][index], "DropItem_ArmorSlot_" .. index, index, control._slotBg[1][index], self._slotConfig)
    control._slot[1][index]:createChild()
    control._slot[1][index].icon:addInputEvent("Mouse_On", "PaGlobal_WorldDropItem:ItemTooltip_Show(" .. 1 .. "," .. index .. ")")
    control._slot[1][index].icon:addInputEvent("Mouse_Out", "PaGlobal_WorldDropItem:ItemTooltip_Hide()")
    control._slotBg[2][index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control._itemGroupUi[2], "DropItem_AccessorySlotBg_" .. index)
    CopyBaseProperty(control._weaponSlotTempleteBg, control._slotBg[2][index])
    control._slotBg[2][index]:SetPosX(20 + index % 7 * 55)
    control._slotBg[2][index]:SetPosY(55 + math.floor(index / 7) * 55)
    control._slotBg[2][index]:SetShow(false)
    control._slot[2][index] = {}
    SlotItem.new(control._slot[2][index], "DropItem_AccessorySlot_" .. index, index, control._slotBg[2][index], self._slotConfig)
    control._slot[2][index]:createChild()
    control._slot[2][index].icon:addInputEvent("Mouse_On", "PaGlobal_WorldDropItem:ItemTooltip_Show(" .. 2 .. "," .. index .. ")")
    control._slot[2][index].icon:addInputEvent("Mouse_Out", "PaGlobal_WorldDropItem:ItemTooltip_Hide()")
    control._slotBg[3][index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control._itemGroupUi[3], "DropItem_EtcSlotBg_" .. index)
    CopyBaseProperty(control._weaponSlotTempleteBg, control._slotBg[3][index])
    control._slotBg[3][index]:SetPosX(20 + index % 7 * 55)
    control._slotBg[3][index]:SetPosY(55 + math.floor(index / 7) * 55)
    control._slotBg[3][index]:SetShow(false)
    control._slot[3][index] = {}
    SlotItem.new(control._slot[3][index], "DropItem_EtcSlot_" .. index, index, control._slotBg[3][index], self._slotConfig)
    control._slot[3][index]:createChild()
    control._slot[3][index].icon:addInputEvent("Mouse_On", "PaGlobal_WorldDropItem:ItemTooltip_Show(" .. 3 .. "," .. index .. ")")
    control._slot[3][index].icon:addInputEvent("Mouse_Out", "PaGlobal_WorldDropItem:ItemTooltip_Hide()")
  end
  control._closeButton:addInputEvent("Mouse_LUp", "PaGlobal_WorldDropItem:Close()")
  control._autoNaviButton:addInputEvent("Mouse_LUp", "PaGlobal_WorldDropItem:SetNavi()")
end
function DropItemRegion_ControlCreate(content, key)
  local regionButton = UI.getChildControl(content, "RadioButton_RegionName")
  local focusEffect = UI.getChildControl(content, "Static_Focus")
  regionButton:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local self = PaGlobal_WorldDropItem
  local regionKey = Int64toInt32(key)
  if self._selectedRegionKey == regionKey then
    focusEffect:SetShow(true)
    regionButton:SetFontColor(Defines.Color.C_FFFFEEA0)
  else
    focusEffect:SetShow(false)
    regionButton:SetFontColor(Defines.Color.C_FFC4BEBE)
  end
  local regionInfo = getRegionInfoWrapper(regionKey)
  if nil ~= regionInfo then
    local regionName = regionInfo:getAreaName()
    regionButton:SetText(regionName)
    focusEffect:SetShow(regionKey == self._selectedRegionKey)
    regionButton:addInputEvent("Mouse_LUp", "PaGlobal_WorldDropItem:HandleClicked_Region(" .. regionKey .. ")")
  end
end
function PaGlobal_WorldDropItem:HandleClicked_Region(regionKey)
  local prevSelectRegionkey = self._selectedRegionKey
  self._selectedRegionKey = regionKey
  self._ui._list2Region:requestUpdateByKey(toInt64(0, regionKey))
  if nil ~= prevSelectRegionkey then
    self._ui._list2Region:requestUpdateByKey(toInt64(0, prevSelectRegionkey))
  end
  PaGlobal_WorldDropItem:SetDropItem(regionKey)
end
function PaGlobal_WorldDropItem:SetDropItem(regionKey)
  local regionInfo = getRegionInfoWrapper(regionKey)
  self._ui._selectedRegionName:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DROPITEM_SELECTEDAREA", "areaName", regionInfo:getAreaName()))
  local needAttackPoint = ToClient_RegionDropItem_GetNeedAttackPoint(regionKey)
  if nil ~= needAttackPoint then
    self._ui._needAp:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DROPITEM_ATTACKPOINT_TEXT", "apCount", tostring(needAttackPoint)))
  end
  local itemCount = ToClient_GetRegionDropItemSize(regionKey)
  if itemCount > 0 then
    for iIndex = 0, 3 do
      self._itemKeyByType[iIndex] = {}
    end
    for index = 0, itemCount - 1 do
      local itemSSW = ToClient_GetRegionDropItemWrapper(regionKey, index)
      local itemKey = itemSSW:get()._key:get()
      if itemSSW:isEquipable() then
        if itemSSW:get():isWeapon() or itemSSW:get():isSubWeapon() or itemSSW:get():isAwakenWeapon() then
          table.insert(self._itemKeyByType[0], itemKey)
        elseif CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
          table.insert(self._itemKeyByType[2], itemKey)
        else
          table.insert(self._itemKeyByType[1], itemKey)
        end
      else
        table.insert(self._itemKeyByType[3], itemKey)
      end
    end
  end
  self:Slot_Init()
  local control = self._ui
  local nextPosY = 0
  for index = 0, 3 do
    if 0 < #self._itemKeyByType[index] then
      control._itemGroupUi[index]:SetShow(true)
      control._itemGroupUi[index]:SetPosY(nextPosY)
      local posY = 0
      for sIndex = 1, #self._itemKeyByType[index] do
        control._slotBg[index][sIndex - 1]:SetShow(true)
        local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._itemKeyByType[index][sIndex]))
        control._slot[index][sIndex - 1]:setItemByStaticStatus(itemSSW)
      end
      nextPosY = nextPosY + control._slotBg[index][#self._itemKeyByType[index] - 1]:GetPosY() + 50
    else
      control._itemGroupUi[index]:SetShow(false)
    end
  end
  local contentSize = math.max(330, nextPosY)
  control._frameContent:SetSize(control._frameContent:GetSizeX(), contentSize)
  control._scroll:SetShow(contentSize > 330)
  control._scroll:SetInterval(contentSize / 100 * 1.2)
  control._scroll:GetControlButton():SetSize(control._scroll:GetControlButton():GetSizeX(), math.min(325, 325 / contentSize * 250))
  control._frameDropItem:UpdateContentScroll()
  control._scroll:SetControlTop()
  control._frameDropItem:UpdateContentPos()
end
function PaGlobal_WorldDropItem:Slot_Init()
  local control = self._ui
  for tIndex = 0, 3 do
    for index = 0, self._maxSlot - 1 do
      control._slotBg[tIndex][index]:SetShow(false)
    end
  end
end
function PaGlobal_WorldDropItem:SetNavi()
  if nil == self._selectedRegionKey then
    return
  end
  local regionInfo = getRegionInfoWrapper(self._selectedRegionKey)
  if regionInfo:hasBaseWaypoint() then
    local pos3D = regionInfo:getPosition()
    ToClient_DeleteNaviGuideByGroup(0)
    ToClient_WorldMapNaviStart(pos3D, NavigationGuideParam(), false, false)
  elseif 249 == self._selectedRegionKey then
    local pos3D = float3(-337181.94, 10127, -248922)
    ToClient_DeleteNaviGuideByGroup(0)
    ToClient_WorldMapNaviStart(pos3D, NavigationGuideParam(), false, false)
  elseif 948 == self._selectedRegionKey then
    local pos3D = float3(32478, -8076, 254519)
    ToClient_DeleteNaviGuideByGroup(0)
    ToClient_WorldMapNaviStart(pos3D, NavigationGuideParam(), false, false)
  elseif 949 == self._selectedRegionKey then
    local pos3D = float3(143790, -7280, 423527)
    ToClient_DeleteNaviGuideByGroup(0)
    ToClient_WorldMapNaviStart(pos3D, NavigationGuideParam(), false, false)
  elseif 688 == self._selectedRegionKey or 689 == self._selectedRegionKey then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DROPITEM_DESERTALERT"))
  end
end
function PaGlobal_WorldDropItem:ItemTooltip_Show(itemType, index)
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._itemKeyByType[itemType][index + 1]))
  if nil ~= itemSSW then
    Panel_Tooltip_Item_SetPosition(index, self._ui._slot[index], "dropItem")
    Panel_Tooltip_Item_Show(itemSSW, Panel_Window_DropItem, true)
  end
end
function PaGlobal_WorldDropItem:ItemTooltip_Hide()
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_WorldDropItem:Open()
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
  Panel_Window_DropItem:SetShow(true)
end
function PaGlobal_WorldDropItem:Close()
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
  Panel_Window_DropItem:SetShow(false)
  Panel_Tooltip_Item_hideTooltip()
end
function FGlobal_DropItemWindow_Open(regionKey)
  local self = PaGlobal_WorldDropItem
  self:Open()
  if nil == regionKey then
    regionKey = Int64toInt32(ToClient_RegionDropItem_GetRegionKeyByIndex(0))
  end
  self:HandleClicked_Region(regionKey)
end
PaGlobal_WorldDropItem:Init()

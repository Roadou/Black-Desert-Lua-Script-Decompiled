local expeditionAreaSelectInfo = {
  _ui = {
    _button_close = UI.getChildControl(Panel_SubjugationAreaSelect, "Button_Win_Close"),
    _button_cancel = UI.getChildControl(Panel_SubjugationAreaSelect, "Button_Cancel"),
    _button_select = UI.getChildControl(Panel_SubjugationAreaSelect, "Button_Select"),
    _list2_region = UI.getChildControl(Panel_SubjugationAreaSelect, "List2_AreaList"),
    _bg_subTitle = UI.getChildControl(Panel_SubjugationAreaSelect, "Static_TopSubTitleBG"),
    _text_areaName = nil,
    _text_travel = nil,
    _frame_itemList = UI.getChildControl(Panel_SubjugationAreaSelect, "Frame_ItemList"),
    _itemGroup = Array.new(),
    _frame_content = nil,
    _frame_scroll = nil
  },
  _selectIndex = nil,
  _selectGroupKey = nil,
  _itemKeyByType = {
    [0] = {},
    [1] = {},
    [2] = {},
    [3] = {}
  },
  _slotConfig = {createIcon = true, createBorder = true},
  _groupKeyList = nil,
  _dropItemSlot = Array.new(),
  _config = {_maxSlot = 30}
}
function expeditionAreaSelectInfo:initialize()
  self:createControl()
  Panel_SubjugationAreaSelect:SetShow(false)
end
function expeditionAreaSelectInfo:createControl()
  self._ui._text_areaName = UI.getChildControl(self._ui._bg_subTitle, "StaticText_SelectAreaName")
  self._ui._text_travel = UI.getChildControl(self._ui._bg_subTitle, "StaticText_Travel")
  self._ui._frame_scroll = UI.getChildControl(self._ui._frame_itemList, "Frame_1_VerticalScroll")
  self._ui._frame_content = UI.getChildControl(self._ui._frame_itemList, "Frame_1_Content")
  self._ui._itemGroup[0] = UI.getChildControl(self._ui._frame_content, "Static_WeaponGroup")
  self._ui._itemGroup[1] = UI.getChildControl(self._ui._frame_content, "Static_ArmorGroup")
  self._ui._itemGroup[2] = UI.getChildControl(self._ui._frame_content, "Static_AccessoryGroup")
  self._ui._itemGroup[3] = UI.getChildControl(self._ui._frame_content, "Static_EtcGroup")
  self._ui._list2_region:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_ExpeditionAreaSelectInfo_CreateControlList2")
  self._ui._list2_region:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  for ii = 0, 3 do
    self._dropItemSlot[ii] = Array.new()
    for jj = 0, self._config._maxSlot - 1 do
      local slot = {}
      local baseSlotBg = UI.getChildControl(self._ui._itemGroup[ii], "Static_ItemSlotBg")
      slot.background = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._itemGroup[ii], "DropItemBG_" .. jj)
      CopyBaseProperty(baseSlotBg, slot.background)
      slot.background:SetPosX(20 + jj % 6 * 55)
      slot.background:SetPosY(35 + math.floor(jj / 6) * 55)
      slot.background:SetShow(false)
      SlotItem.new(slot, "DropItemIcon_" .. jj, jj, slot.background, self._slotConfig)
      slot:createChild()
      slot.icon:SetPosX(0)
      slot.icon:SetPosY(0)
      slot.icon:SetShow(true)
      slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_ExpeditionAreaSelectInfo_ItemTooltip_Show(" .. ii .. "," .. jj .. ")")
      slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_ExpeditionAreaSelectInfo_ItemTooltip_Hide()")
      self._dropItemSlot[ii][jj] = slot
    end
  end
  self._ui._button_close:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionAreaSelectInfo_Close()")
  self._ui._button_cancel:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionAreaSelectInfo_Close()")
  self._ui._button_select:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionAreaSelectInfo_Select()")
  registerEvent("FromClient_setExpeditionGroupKey", "FromClient_setExpeditionGroupKey")
  ToClient_getExpeditionGroupKey()
end
function expeditionAreaSelectInfo:slotRefresh()
  for ii = 0, 3 do
    for jj = 0, self._config._maxSlot - 1 do
      local slot = self._dropItemSlot[ii][jj]
      slot:clearItem()
      slot.background:SetShow(false)
    end
  end
end
function expeditionAreaSelectInfo:open()
  PaGlobalFunc_ExpeditionAreaSelectInfo_Click(0)
  Panel_SubjugationAreaSelect:SetShow(true)
end
function expeditionAreaSelectInfo:close()
  self._selectIndex = nil
  Panel_SubjugationAreaSelect:SetShow(false)
end
function PaGlobalFunc_ExpeditionAreaSelectInfo_Open(index)
  local self = expeditionAreaSelectInfo
  self:open()
  self._selectIndex = index
end
function PaGlobalFunc_ExpeditionAreaSelectInfo_Close()
  local self = expeditionAreaSelectInfo
  self:close()
end
function PaGlobalFunc_ExpeditionAreaSelectInfo_Select()
  if false == Panel_SubjugationAreaSelect:IsShow() then
    return
  end
  local self = expeditionAreaSelectInfo
  PaGlobalFunc_ExpeditionSettingInfo_SelectAreaSet(self._selectIndex, self._selectGroupKey, nil, true)
  self:close()
end
function PaGlobalFunc_ExpeditionAreaSelectInfo_CreateControlList2(content, index)
  local self = expeditionAreaSelectInfo
  local regionButton = UI.getChildControl(content, "RadioButton_RegionName")
  local focusEffect = UI.getChildControl(content, "Static_Focus")
  regionButton:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local groupKey = Int64toInt32(index)
  if self._selectGroupKey == groupKey then
    focusEffect:SetShow(true)
    regionButton:SetFontColor(Defines.Color.C_FFFFEEA0)
  else
    focusEffect:SetShow(false)
    regionButton:SetFontColor(Defines.Color.C_FFC4BEBE)
  end
  local regionWrapper = ToClient_getExpeditionRegionWrapper(groupKey)
  if nil ~= regionWrapper then
    regionButton:SetText(regionWrapper:getGroupName())
    regionButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionAreaSelectInfo_Click(" .. groupKey .. ")")
  end
end
function PaGlobalFunc_ExpeditionAreaSelectInfo_Click(groupKey)
  local self = expeditionAreaSelectInfo
  if groupKey == self._selectGroupKey then
    return
  end
  local prevSelectGroupKey = self._selectGroupKey
  self._selectGroupKey = groupKey
  self._ui._list2_region:requestUpdateByKey(self._selectGroupKey)
  if nil ~= prevSelectGroupKey then
    self._ui._list2_region:requestUpdateByKey(prevSelectGroupKey)
  end
  local regionWrapper = ToClient_getExpeditionRegionWrapper(groupKey)
  if nil == regionWrapper then
    return
  end
  local TravelPoint = regionWrapper:getRecommendCombatPoint()
  self._ui._text_travel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXPEDITION_RECOMMEND_COMBATPOINT", "value", tostring(TravelPoint)))
  local selectRegionName = regionWrapper:getGroupName()
  self._ui._text_areaName:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXPEDITION_SELECT_REGION", "regionName", tostring(selectRegionName)))
  local dropItemList = regionWrapper:getDropItemList()
  if nil == dropItemList then
    return
  end
  for ii = 0, 3 do
    self._itemKeyByType[ii] = {}
  end
  for ii = 0, #dropItemList do
    local itemEnchantKey = dropItemList[ii]
    local itemSSW = getItemEnchantStaticStatus(itemEnchantKey)
    if nil ~= itemSSW then
      if true == itemSSW:isEquipable() then
        if true == itemSSW:get():isWeapon() or true == itemSSW:get():isSubWeapon() or true == itemSSW:get():isAwakenWeapon() then
          table.insert(self._itemKeyByType[0], itemEnchantKey)
        elseif CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
          table.insert(self._itemKeyByType[2], itemEnchantKey)
        else
          table.insert(self._itemKeyByType[1], itemEnchantKey)
        end
      else
        table.insert(self._itemKeyByType[3], itemEnchantKey)
      end
    end
  end
  self:slotRefresh()
  local nextPosY = 0
  for ii = 0, 3 do
    if 0 < #self._itemKeyByType[ii] then
      self._ui._itemGroup[ii]:SetShow(true)
      self._ui._itemGroup[ii]:SetPosY(nextPosY)
      for jj = 1, #self._itemKeyByType[ii] do
        local itemSSW = getItemEnchantStaticStatus(self._itemKeyByType[ii][jj])
        self._dropItemSlot[ii][jj - 1]:setItemByStaticStatus(itemSSW)
        self._dropItemSlot[ii][jj - 1].background:SetShow(true)
      end
      nextPosY = nextPosY + self._dropItemSlot[ii][#self._itemKeyByType[ii] - 1].background:GetPosY() + 50
    else
      self._ui._itemGroup[ii]:SetShow(false)
    end
  end
  local frameMaxSizeY = math.max(330, nextPosY)
  self._ui._frame_content:SetSize(self._ui._frame_content:GetSizeX(), frameMaxSizeY)
  self._ui._frame_scroll:SetShow(frameMaxSizeY > 330)
  self._ui._frame_scroll:SetInterval(frameMaxSizeY / 100 * 1.2)
  self._ui._frame_scroll:GetControlButton():SetSize(self._ui._frame_scroll:GetControlButton():GetSizeX(), math.min(325, 325 / frameMaxSizeY * 250))
  self._ui._frame_itemList:UpdateContentScroll()
  self._ui._frame_scroll:SetControlTop()
  self._ui._frame_itemList:UpdateContentPos()
end
function PaGlobalFunc_ExpeditionAreaSelectInfo_ItemTooltip_Show(itemType, itemIndex)
  local self = expeditionAreaSelectInfo
  local itemSSW = getItemEnchantStaticStatus(self._itemKeyByType[itemType][itemIndex + 1])
  if nil ~= itemSSW then
    Panel_Tooltip_Item_Show(itemSSW, Panel_SubjugationAreaSelect, true)
  end
end
function PaGlobalFunc_ExpeditionAreaSelectInfo_ItemTooltip_Hide()
  Panel_Tooltip_Item_hideTooltip()
end
function FromClient_setExpeditionGroupKey(regionKey)
  local self = expeditionAreaSelectInfo
  local regionWrapper = ToClient_getExpeditionRegionWrapper(regionKey)
  if nil ~= regionWrapper then
    self._ui._list2_region:getElementManager():pushKey(regionWrapper:getGroupKey())
  end
end
expeditionAreaSelectInfo:initialize()

PaGlobal_ConsoleQuickMenuSetting = {
  _inventoryData = {},
  _skillData = {},
  _functionTypeData = {},
  _socialActionData = {},
  _ui = {
    _staticIcon = {},
    _staticTextName = {},
    _buttonPosition = {},
    _buttonPositionIcon = {},
    _buttonPositionRemoveIcon = {},
    _rightBg = UI.getChildControl(Panel_QuickMenuCustom, "Static_RightBg"),
    _list2Skill,
    _list2Menu,
    _frameItem,
    _list2SocialAction,
    _slots = {},
    _static_BottomBg = UI.getChildControl(Panel_QuickMenuCustom, "Static_BottomBg"),
    _staticText_Select = nil,
    _ringBg = UI.getChildControl(Panel_QuickMenuCustom_RightRing, "Static_RingBg"),
    _oneSlotBg = UI.getChildControl(Panel_QuickMenuCustom_RightRing, "Static_OneSlotBg"),
    _ringCrossHair = UI.getChildControl(Panel_QuickMenuCustom_RightRing, "Static_CrossHair"),
    _crossHairText = UI.getChildControl(Panel_QuickMenuCustom_RightRing, "StaticText_CrossText"),
    _registerModeBlackBg = UI.getChildControl(Panel_QuickMenuCustom_RightRing, "Static_BlackBg"),
    _RSGuideBg = UI.getChildControl(Panel_QuickMenuCustom_RightRing, "Static_GuideBg")
  },
  _registMode = {
    _isStart = false,
    _isRemoveStart = false,
    _stickPosition = __eQuickMenuStickPosition_Count,
    _index = -1
  },
  _listMaxCount = 8,
  _curPosition = 1,
  _curPage = 1,
  _curGroup = __eQuickMenuDpadGroup_Count,
  _curCategory = 0,
  _startColumn = 0,
  _curItemIndex = 0,
  _isRegisterQuickMenu = false
}
function PaGlobal_ConsoleQuickMenuSetting:GoCategory(category)
  self._ui._list2Skill:SetShow(false)
  self._ui._list2Menu:SetShow(false)
  self._ui._bgItem:SetShow(false)
  self._ui._list2SocialAction:SetShow(false)
  if __eQuickMenuDataType_Skill == category then
    self._ui._list2Skill:SetShow(true)
  elseif __eQuickMenuDataType_Item == category then
    self._ui._bgItem:SetShow(true)
  elseif __eQuickMenuDataType_Function == category then
    self._ui._list2Menu:SetShow(true)
  elseif __eQuickMenuDataType_SocialAction == category then
    self._ui._list2SocialAction:SetShow(true)
  end
  PaGlobal_ConsoleQuickMenuCustom_HighlightCategory(category)
end
function PaGlobal_ConsoleQuickMenuSetting:initializeUI()
  self._ui._staticText_Select = UI.getChildControl(self._ui._static_BottomBg, "StaticText_Select")
  self._ui._staticText_Exit = UI.getChildControl(self._ui._static_BottomBg, "StaticText_Exit")
  local tempBtnGroup = {
    self._ui._staticText_Select,
    self._ui._staticText_Exit
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_LEFT)
  for ii = 0, __eQuickMenuStickPosition_Count - 1 do
    self._ui._buttonPosition[ii] = UI.getChildControl(self._ui._ringBg, "Button_Templete" .. tostring(ii))
    self._ui._buttonPosition[ii]:addInputEvent("Mouse_LUp", "PaGlobal_ConsoleQuickMenuSetting:quitRegistQuickMenu( " .. ii .. ")")
    self._ui._buttonPositionIcon[ii] = UI.getChildControl(self._ui._buttonPosition[ii], "Static_Icon")
    self._ui._buttonPositionRemoveIcon[ii] = UI.getChildControl(self._ui._buttonPosition[ii], "Static_MinusIcon")
  end
  self._ui._registerModeSelectItem = UI.getChildControl(self._ui._ringBg, "StaticText_SelectMenu")
  self._ui._registerModeSelectItemIcon = UI.getChildControl(self._ui._registerModeSelectItem, "Static_Icon")
  self._ui._changeSlot = UI.getChildControl(Panel_QuickMenuCustom_RightRing, "StaticText_ChangeSlot")
  if true == ToClient_isPS4() then
    self._ui._stc_LTGuide = UI.getChildControl(Panel_QuickMenuCustom_RightRing, "Static_LT_PS")
  else
    self._ui._stc_LTGuide = UI.getChildControl(Panel_QuickMenuCustom_RightRing, "Static_LT_XB")
  end
  local tabBg = UI.getChildControl(Panel_QuickMenuCustom, "Static_TabBg")
  UI.getChildControl(tabBg, "RadioButton_Skill"):addInputEvent("Mouse_LUp", "PaGlobal_ConsoleQuickMenuSetting:GoCategory(" .. __eQuickMenuDataType_Skill .. ")")
  UI.getChildControl(tabBg, "RadioButton_Item"):addInputEvent("Mouse_LUp", "PaGlobal_ConsoleQuickMenuSetting:GoCategory(" .. __eQuickMenuDataType_Item .. ")")
  UI.getChildControl(tabBg, "RadioButton_Menu"):addInputEvent("Mouse_LUp", "PaGlobal_ConsoleQuickMenuSetting:GoCategory(" .. __eQuickMenuDataType_Function .. ")")
  UI.getChildControl(tabBg, "RadioButton_Social"):addInputEvent("Mouse_LUp", "PaGlobal_ConsoleQuickMenuSetting:GoCategory(" .. __eQuickMenuDataType_SocialAction .. ")")
  self._ui._list2Skill = UI.getChildControl(self._ui._rightBg, "List2_Skillt")
  self._ui._list2Menu = UI.getChildControl(self._ui._rightBg, "List2_Menu")
  self._ui._bgItem = UI.getChildControl(self._ui._rightBg, "Static_ItemMenuBg")
  self._ui._scrollItem = UI.getChildControl(self._ui._bgItem, "Scroll_Inventory")
  self._ui._bgItemTemplate = UI.getChildControl(self._ui._bgItem, "Static_ItemSlotBg_Template")
  self._ui._list2SocialAction = UI.getChildControl(self._ui._rightBg, "List2_SocialAction")
  self._ui._list2Skill:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "QuickMenuSeting_List2Event_SKill")
  self._ui._list2Menu:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "QuickMenuSeting_List2Event_Menu")
  self._ui._list2SocialAction:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "QuickMenuSeting_List2Event_SocialAction")
  self._ui._list2Skill:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._list2Menu:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._list2SocialAction:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  local rowMax = 8
  local colMax = 9
  local row = 0
  local col = 0
  local offset = 54
  local bgs = {}
  for index = 1, rowMax * colMax do
    local bg = UI.createAndCopyBasePropertyControl(self._ui._bgItem, "Static_ItemSlotBg_Template", self._ui._bgItem, "Item_" .. index)
    bg:SetPosX(row * offset)
    bg:SetPosY(col * offset)
    if row < rowMax - 1 then
      row = row + 1
    else
      row = 0
      col = col + 1
    end
    bgs[#bgs + 1] = bg
  end
  for index = 1, rowMax * colMax do
    local slot = {}
    local param = {
      createIcon = true,
      createBorder = true,
      createCount = true,
      createEnchant = true,
      createClassEquipBG = true,
      createEnduranceIcon = true,
      createCash = true
    }
    local item = SlotItem.new(slot, index, 0, bgs[index], param)
    item:createChild()
    UIScroll.InputEventByControl(bgs[index], "PaGlobal_ConsoleQuickMenuSetting_scrollInventory")
    UIScroll.InputEventByControl(item.icon, "PaGlobal_ConsoleQuickMenuSetting_scrollInventory")
    if index < colMax then
      bgs[index]:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobal_ConsoleQuickMenuSetting_scrollInventory(true)")
    elseif index > colMax * (rowMax - 1) then
      bgs[index]:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobal_ConsoleQuickMenuSetting_scrollInventory(false)")
    end
    self._ui._slots[index] = item
  end
  self._ui._ringBg:SetShow(true)
  self._ui._oneSlotBg:SetShow(false)
  self._ui._RSGuideText = UI.getChildControl(self._ui._RSGuideBg, "StaticText_GuideText")
  self._ui._RSGuideText:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._RSGuideText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX_RINGMENUSETTING_RSKEYGUIDE"))
end
function PaGlobal_ConsoleQuickMenuSetting:showSelectKeyGuideA(show, index)
  if nil == show then
    show = false
  end
  self._curItemIndex = index
  self._ui._staticText_Select:SetShow(show)
end
function PaGlobal_ConsoleQuickMenuSetting:startRegistQuickMenu(type, index)
  if self:isRegisterOrRemoveMode() then
    return
  end
  self._registMode._isStart = true
  self._registMode._stickPosition = __eQuickMenuStickPosition_Count
  local data
  if __eQuickMenuDataType_Item == type then
    data = self._inventoryData[index]
  elseif __eQuickMenuDataType_Skill == type then
    data = self._skillData[index]
  elseif __eQuickMenuDataType_Function == type then
    data = self._functionTypeData[index]
  elseif __eQuickMenuDataType_SocialAction == type then
    data = self._socialActionData[index]
  end
  self._registMode._settingData = data
  self:ShowBlackBg(true, data)
end
function PaGlobal_ConsoleQuickMenuSetting:startRegistRemoveQuickMenu()
  if self:isRegisterOrRemoveMode() then
    return
  end
  self._registMode._isStart = false
  self._registMode._isRemoveStart = true
  self._registMode._stickPosition = __eQuickMenuStickPosition_Count
  self._registMode._settingData = nil
  self:ShowBlackBg(true, data)
  self:showRemoveIcon(true)
end
function PaGlobal_ConsoleQuickMenuSetting:ShowBlackBg(show, data)
  self._ui._RSGuideBg:SetShow(show)
  self._ui._registerModeBlackBg:SetShow(show)
  self._ui._ringCrossHair:SetShow(not show)
  self._ui._registerModeSelectItem:SetShow(show)
  self._ui._changeSlot:SetShow(not show)
  self:setCenterSlotIconAtregisterMode(data)
end
function PaGlobal_ConsoleQuickMenuSetting:setCenterSlotIconAtregisterMode(data)
  local control = self._ui._registerModeSelectItemIcon
  if nil ~= data then
    if __eQuickMenuDataType_Skill == data._type then
      PaGlobal_ConsoleQuickMenu:setIcon(control, data._icon)
    elseif __eQuickMenuDataType_Item == data._type then
      PaGlobal_ConsoleQuickMenu:setIcon(control, data._icon)
    elseif __eQuickMenuDataType_Function == data._type then
      PaGlobal_ConsoleQuickMenu:setIcon(control, data._icon, data._uv)
    elseif __eQuickMenuDataType_SocialAction == data._type then
      PaGlobal_ConsoleQuickMenu:setIcon(control, data._icon)
    else
      PaGlobal_ConsoleQuickMenu:setIcon(control)
    end
  else
    PaGlobal_ConsoleQuickMenu:setIcon(control)
  end
end
function PaGlobal_ConsoleQuickMenuSetting:SetSkillDataMonoTone(index)
end
function PaGlobal_ConsoleQuickMenuSetting:isRegisterOrRemoveMode()
  if true == self._registMode._isRemoveStart or true == self._registMode._isStart then
    return true
  end
  return false
end
function PaGlobal_ConsoleQuickMenuSetting:quitRegistQuickMenu(executePosition)
  local registData = self._registMode._settingData
  self:clearRegistCustomSetting()
  if nil == executePosition or __eQuickMenuStickPosition_Count == executePosition then
    return
  end
  if nil == registData then
    return
  end
  self:registQuickMenu(registData, executePosition)
  PaGlobal_ConsoleQuickMenu:setWidget()
  self._isRegisterQuickMenu = true
end
function PaGlobal_ConsoleQuickMenuSetting:quitRegistRemoveQuickMenu(executePosition)
  local removeData = self._registMode._settingData
  self:clearRegistCustomSetting()
  if nil == executePosition or __eQuickMenuStickPosition_Count == executePosition then
    return
  end
  if nil == removeData then
    return
  end
  local rv = ToClient_removeQuickMenu(self._curGroup, executePosition)
  if true == rv then
    self:updateIcon(nil, executePosition)
  end
  _AudioPostEvent_SystemUiForXBOX(52, 1)
  PaGlobal_ConsoleQuickMenu:setWidget()
  self._isRegisterQuickMenu = true
end
function PaGlobal_ConsoleQuickMenuSetting:clearRegistCustomSetting()
  self._registMode._isStart = false
  self._registMode._isRemoveStart = false
  self._registMode._stickPosition = __eQuickMenuStickPosition_Count
  self._registMode._settingData = nil
  self:ShowBlackBg(false)
  self:showRemoveIcon(false)
end
function PaGlobal_ConsoleQuickMenuSetting:registQuickMenu(data, position)
  if nil == data then
    return
  end
  if __eQuickMenuDataType_Skill == data._type then
    self:registSkill(data, position)
  elseif __eQuickMenuDataType_Item == data._type then
    self:registItem(data, position)
  elseif __eQuickMenuDataType_Function == data._type then
    self:registFunctionType(data, position)
  elseif __eQuickMenuDataType_SocialAction == data._type then
    self:registSocialAction(data, position)
  end
end
function PaGlobal_ConsoleQuickMenuSetting:registItem(data, position)
  if nil == data then
    return
  end
  local rv = ToClient_registQuickMenuItem(self._curGroup, position, data._whereType, data._slotNo)
  if true == rv then
    self:updateIcon(data, position)
  end
end
function PaGlobal_ConsoleQuickMenuSetting:registSkill(data, position)
  if nil == data then
    return
  end
  local rv = ToClient_registQuickMenuSkill(self._curGroup, position, data._skillKey)
  if true == rv then
    self:updateIcon(data, position)
  end
end
function PaGlobal_ConsoleQuickMenuSetting:registFunctionType(data, position)
  if nil == data then
    return
  end
  local rv = ToClient_registQuickMenuFunctionType(self._curGroup, position, data._enumType)
  if true == rv then
    self:updateIcon(data, position)
  end
end
function PaGlobal_ConsoleQuickMenuSetting:registSocialAction(data, position)
  if nil == data then
    return
  end
  local rv = ToClient_registQuickMenuSocialAction(self._curGroup, position, data._socialKey)
  if true == rv then
    self:updateIcon(data, position)
  end
end
function PaGlobal_ConsoleQuickMenuSetting:setRemoveMode(state)
  if true == state then
    self:startRegistRemoveQuickMenu()
  else
    self:clearRegistCustomSetting()
  end
end
function PaGlobal_ConsoleQuickMenuSetting:showRemoveIcon(state)
  for ii = 0, __eQuickMenuStickPosition_Count - 1 do
    self._ui._buttonPositionRemoveIcon[ii]:SetShow(state)
  end
end
function PaGlobal_ConsoleQuickMenuSetting:updateIcon(data, position)
  local control = self._ui._buttonPositionIcon[position]
  if nil == control then
    return
  end
  if nil == data then
    PaGlobal_ConsoleQuickMenu:setIcon(control)
    return
  end
  if __eQuickMenuDataType_Skill == data._type then
    PaGlobal_ConsoleQuickMenu:setIcon(control, data._icon)
  elseif __eQuickMenuDataType_Item == data._type then
    PaGlobal_ConsoleQuickMenu:setIcon(control, data._icon)
  elseif __eQuickMenuDataType_Function == data._type then
    PaGlobal_ConsoleQuickMenu:setIcon(control, data._icon, data._uv)
  elseif __eQuickMenuDataType_SocialAction == data._type then
    PaGlobal_ConsoleQuickMenu:setIcon(control, data._icon)
  end
end
function PaGlobal_ConsoleQuickMenuSetting:setFunctionTypeData()
  self._functionTypeData = {}
  if nil == PaGlobal_ConsoleQuickMenu._functionTypeList or nil == PaGlobal_ConsoleQuickMenu._functionTypeList._icon or nil == PaGlobal_ConsoleQuickMenu._functionTypeList._icon[__eQuickMenuDataType_Function] or nil == PaGlobal_ConsoleQuickMenu._functionTypeList._name or nil == PaGlobal_ConsoleQuickMenu._functionTypeList._name[__eQuickMenuDataType_Function] then
    return
  end
  if true == ToClient_isPS4() then
    PaGlobal_ConsoleQuickMenu_SetMenuPs4()
  end
  for index = 0, PaGlobal_ConsoleQuickMenu._functionTypeCount do
    if true == PaGlobal_ConsoleQuickMenu._functionTypeList._ContentOption[__eQuickMenuDataType_Function][index] then
      local iconUV = PaGlobal_ConsoleQuickMenu._functionTypeList._icon[__eQuickMenuDataType_Function][index]
      uv = {
        _x1 = iconUV._x1,
        _y1 = iconUV._y1,
        _x2 = iconUV._x2,
        _y2 = iconUV._y2
      }
      self._functionTypeData[#self._functionTypeData + 1] = {
        _type = __eQuickMenuDataType_Function,
        _enumType = index,
        _name = PaGlobal_ConsoleQuickMenu._functionTypeList._name[__eQuickMenuDataType_Function][index],
        _icon = PaGlobal_ConsoleQuickMenu._functionTypeList._icon[__eQuickMenuDataType_Function][index]._path,
        _uv = uv
      }
    end
  end
end
function PaGlobal_ConsoleQuickMenuSetting:setInventoryData()
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return nil
  end
  self._inventoryData = {}
  local useStartSlot = inventorySlotNoUserStart()
  local inventorysize = ToClient_InventoryGetSize(CppEnums.ItemWhereType.eInventory)
  for slotNo = useStartSlot, inventorysize - 1 do
    local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, slotNo)
    if nil ~= itemWrapper and false == itemWrapper:empty() and true == ToClient_isVaildItemRegistQuickMenu(itemWrapper:getStaticStatus()) then
      self._inventoryData[#self._inventoryData + 1] = {
        _type = __eQuickMenuDataType_Item,
        _whereType = CppEnums.ItemWhereType.eInventory,
        _slotNo = slotNo,
        _name = itemWrapper:getStaticStatus():getName(),
        _icon = "Icon/" .. itemWrapper:getStaticStatus():getIconPath()
      }
    end
  end
  inventorysize = ToClient_InventoryGetSize(CppEnums.ItemWhereType.eCashInventory)
  for slotNo = useStartSlot, inventorysize - 1 do
    local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, slotNo)
    if nil ~= itemWrapper and false == itemWrapper:empty() and true == ToClient_isVaildItemRegistQuickMenu(itemWrapper:getStaticStatus()) then
      self._inventoryData[#self._inventoryData + 1] = {
        _type = __eQuickMenuDataType_Item,
        _whereType = CppEnums.ItemWhereType.eCashInventory,
        _slotNo = slotNo,
        _name = itemWrapper:getStaticStatus():getName(),
        _icon = "Icon/" .. itemWrapper:getStaticStatus():getIconPath()
      }
    end
  end
end
function PaGlobal_ConsoleQuickMenuSetting:setSkillData()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local classType = selfPlayer:getClassType()
  if classType < 0 then
    return
  end
  self._skillData = {}
  local cellTable = getCombatSkillTree(classType)
  if nil == cellTable then
    return
  end
  self:setSkillCellTableData(cellTable)
  if true == ToClient_IsContentsGroupOpen("901") then
    cellTable = getAwakeningWeaponSkillTree(classType)
    if nil == cellTable then
      return
    end
    self:setSkillCellTableData(cellTable)
  end
end
function PaGlobal_ConsoleQuickMenuSetting:setSkillCellTableData(cellTable)
  local cols = cellTable:capacityX()
  local rows = cellTable:capacityY()
  for row = 0, rows - 1 do
    for col = 0, cols - 1 do
      local cell = cellTable:atPointer(col, row)
      local skillNo = cell._skillNo
      if true == cell:isSkillType() and false == PaGlobalFunc_Skill_IsBlockByConsoleSkill(skillNo) then
        local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
        local skillTypeStatic = skillTypeStaticWrapper:get()
        if nil ~= skillTypeStaticWrapper and true == skillTypeStaticWrapper:isValidLocalizing() and nil ~= skillTypeStatic and true == skillTypeStatic._isSettableQuickSlot then
          local skillLevelInfo = getSkillLevelInfo(skillNo)
          local skillLearndLevel = getLearnedSkillLevel(skillTypeStaticWrapper)
          if nil ~= skillLevelInfo and true == skillLevelInfo._usable then
            self._skillData[#self._skillData + 1] = {
              _type = __eQuickMenuDataType_Skill,
              _skillKey = skillLevelInfo._skillKey:get(),
              _skillNo = skillNo,
              _name = skillTypeStaticWrapper:getName(),
              _icon = "Icon/" .. skillTypeStaticWrapper:getIconPath()
            }
          end
        end
      end
    end
  end
end
function PaGlobal_ConsoleQuickMenuSetting:setSocialActionData()
  self._socialActionData = {}
  for ii = 0, ToClient_getSocialActionInfoList() - 1 do
    local socialActionInfo = ToClient_getSocialActionInfoByIndex(ii)
    local sASS = socialActionInfo:getStaticStatus()
    local socialKey = sASS:getKey()
    self._socialActionData[#self._socialActionData + 1] = {
      _type = __eQuickMenuDataType_SocialAction,
      _socialKey = socialKey,
      _name = sASS:getName(),
      _icon = "Icon/" .. sASS:getIconPath()
    }
  end
end
function PaGlobal_ConsoleQuickMenuSetting:setSkillUi()
  self._ui._list2Skill:getElementManager():clearKey()
  for index = 1, #self._skillData do
    if 1 == index % 2 then
      self._ui._list2Skill:getElementManager():pushKey(toInt64(0, index))
    end
  end
end
function QuickMenuSeting_List2Event_SKill(content, key)
  local id = Int64toInt32(key)
  local skillData = {
    [0] = PaGlobal_ConsoleQuickMenuSetting._skillData[id],
    PaGlobal_ConsoleQuickMenuSetting._skillData[id + 1]
  }
  for ii = 0, 1 do
    local radiobutton = UI.getChildControl(content, "RadioButton_SkillSlotBg_" .. ii)
    local name = UI.getChildControl(content, "StaticText_SkillName_" .. ii)
    local bg = UI.getChildControl(content, "Static_SlotBg_" .. ii)
    local slot = UI.getChildControl(content, "Static_Slot_" .. ii)
    local dataReady = nil ~= skillData[ii]
    radiobutton:SetShow(dataReady)
    name:SetShow(dataReady)
    bg:SetShow(dataReady)
    slot:SetShow(dataReady)
    if true == dataReady then
      slot:ChangeTextureInfoName(skillData[ii]._icon)
      name:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      name:SetText(skillData[ii]._name)
      radiobutton:addInputEvent("Mouse_LUp", "PaGlobal_ConsoleQuickMenuSetting:startRegistQuickMenu(" .. __eQuickMenuDataType_Skill .. "," .. id + ii .. "  )")
    end
  end
end
function PaGlobal_ConsoleQuickMenuSetting:setInventoryUi()
  local rowMax = 8
  local colMax = 9
  local row = 0
  local col = 0
  local offset = 54
  for index = 1, rowMax * colMax do
    local dataIndex = index + self._startColumn * rowMax
    local data = self._inventoryData[dataIndex]
    local item = self._ui._slots[index]
    if nil ~= data then
      local itemWrapper = getInventoryItemByType(data._whereType, data._slotNo)
      if nil ~= itemWrapper and false == itemWrapper:empty() and true == ToClient_isVaildItemRegistQuickMenu(itemWrapper:getStaticStatus()) then
        item:setItem(itemWrapper, data._slotNo, false, false)
        item.icon:addInputEvent("Mouse_On", "PaGlobal_ConsoleQuickMenuSetting:showSelectKeyGuideA(true," .. index .. ")")
        item.icon:addInputEvent("Mouse_LUp", "PaGlobal_ConsoleQuickMenuSetting:startRegistQuickMenu(" .. __eQuickMenuDataType_Item .. "," .. dataIndex .. "  )")
      else
        item.icon:addInputEvent("Mouse_On", "PaGlobal_ConsoleQuickMenuSetting:showSelectKeyGuideA(false," .. index .. ")")
        item:clearItem()
      end
    else
      item.icon:addInputEvent("Mouse_On", "PaGlobal_ConsoleQuickMenuSetting:showSelectKeyGuideA(false," .. index .. ")")
      item:clearItem()
    end
  end
end
function PaGlobal_ConsoleQuickMenuSetting_scrollInventory(isUp)
  local self = PaGlobal_ConsoleQuickMenuSetting
  local startIndex = UIScroll.ScrollEvent(self._ui._scrollItem, isUp, 9, 192, 1 + self._startColumn * 8, 8)
  local newColumn = math.floor(startIndex / 8)
  if nil ~= self._curItemIndex and self._startColumn ~= newColumn then
    local rowMax = 8
    local dataIndex = self._curItemIndex + newColumn * rowMax
    local data = self._inventoryData[dataIndex]
    if nil ~= data then
      PaGlobal_ConsoleQuickMenuSetting:showSelectKeyGuideA(true, self._curItemIndex)
    else
      PaGlobal_ConsoleQuickMenuSetting:showSelectKeyGuideA(false, self._curItemIndex)
    end
  end
  self._startColumn = newColumn
  self:setInventoryUi()
end
function PaGlobal_ConsoleQuickMenuSetting:setFunctionTypeUi()
  self._ui._list2Menu:getElementManager():clearKey()
  for index = 1, #self._functionTypeData do
    if 1 == index % 3 then
      self._ui._list2Menu:getElementManager():pushKey(toInt64(0, index))
    end
  end
end
function QuickMenuSeting_List2Event_Menu(content, key)
  local id = Int64toInt32(key)
  local functionData = {
    PaGlobal_ConsoleQuickMenuSetting._functionTypeData[id],
    PaGlobal_ConsoleQuickMenuSetting._functionTypeData[id + 1],
    PaGlobal_ConsoleQuickMenuSetting._functionTypeData[id + 2]
  }
  local btns = {
    UI.getChildControl(content, "Button_1"),
    UI.getChildControl(content, "Button_2"),
    UI.getChildControl(content, "Button_3")
  }
  local stc_icons = {}
  local txt_title = {}
  for ii = 1, #btns do
    stc_icons[ii] = UI.getChildControl(btns[ii], "Static_MenuIcon")
    txt_title[ii] = UI.getChildControl(btns[ii], "StaticText_Menu")
    local dataReady = nil ~= functionData[ii]
    btns[ii]:SetShow(dataReady)
    if true == dataReady then
      PaGlobal_ConsoleQuickMenu:setIcon(stc_icons[ii], functionData[ii]._icon, functionData[ii]._uv)
      btns[ii]:addInputEvent("Mouse_LUp", "PaGlobal_ConsoleQuickMenuSetting:startRegistQuickMenu(" .. __eQuickMenuDataType_Function .. "," .. id + (ii - 1) .. "  )")
      txt_title[ii]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      txt_title[ii]:SetAutoResize(true)
      txt_title[ii]:SetText(functionData[ii]._name)
      txt_title[ii]:SetPosY(btns[ii]:GetPosY() + btns[ii]:GetSizeY() / 2 - txt_title[ii]:GetTextSizeY() / 2)
      txt_title[ii]:SetTextSpan(0, (txt_title[ii]:GetSizeY() - txt_title[ii]:GetTextSizeY()) * 0.5)
    end
  end
end
function PaGlobal_ConsoleQuickMenuSetting:setSocialActionUi()
  self._ui._list2SocialAction:getElementManager():clearKey()
  for index = 1, #self._socialActionData do
    if 1 == index % 3 then
      self._ui._list2SocialAction:getElementManager():pushKey(toInt64(0, index))
    end
  end
end
function QuickMenuSeting_List2Event_SocialAction(content, key)
  local id = Int64toInt32(key)
  local functionData = {
    PaGlobal_ConsoleQuickMenuSetting._socialActionData[id],
    PaGlobal_ConsoleQuickMenuSetting._socialActionData[id + 1],
    PaGlobal_ConsoleQuickMenuSetting._socialActionData[id + 2]
  }
  local btns = {
    UI.getChildControl(content, "Button_1"),
    UI.getChildControl(content, "Button_2"),
    UI.getChildControl(content, "Button_3")
  }
  local stc_icons = {}
  local txt_title = {}
  for ii = 1, #btns do
    stc_icons[ii] = UI.getChildControl(btns[ii], "Static_MenuIcon")
    txt_title[ii] = UI.getChildControl(btns[ii], "StaticText_Menu")
    local dataReady = nil ~= functionData[ii]
    btns[ii]:SetShow(dataReady)
    if true == dataReady then
      stc_icons[ii]:ChangeTextureInfoName(functionData[ii]._icon)
      btns[ii]:addInputEvent("Mouse_LUp", "PaGlobal_ConsoleQuickMenuSetting:startRegistQuickMenu(" .. __eQuickMenuDataType_SocialAction .. "," .. id + (ii - 1) .. "  )")
      txt_title[ii]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      txt_title[ii]:SetAutoResize(true)
      txt_title[ii]:SetText(functionData[ii]._name)
      txt_title[ii]:SetPosY(btns[ii]:GetPosY() + btns[ii]:GetSizeY() / 2 - txt_title[ii]:GetTextSizeY() / 2)
      txt_title[ii]:SetTextSpan(0, (txt_title[ii]:GetSizeY() - txt_title[ii]:GetTextSizeY()) * 0.5)
    end
  end
end
function PaGlobal_ConsoleQuickMenuSetting:UpdateData()
  self:setSkillData()
  self:setInventoryData()
  self:setFunctionTypeData()
  self:setSocialActionData()
end
function PaGlobal_ConsoleQuickMenuSetting:UpdateUi()
  self:setSkillUi()
  self:setInventoryUi()
  self:setFunctionTypeUi()
  self:setSocialActionUi()
end
function FromClient_ConsoleQuickMenu_OpenCustomPage(currentSettingGroup)
  if currentSettingGroup < 0 or currentSettingGroup >= __eQuickMenuDpadGroup_Count then
    return
  end
  local self = PaGlobal_ConsoleQuickMenuSetting
  FromClient_ConsoleQuickMenu_Close()
  Panel_QuickMenuCustom:SetShow(true)
  self:UpdateData()
  self:UpdateUi()
  self._curGroup = currentSettingGroup
  Panel_QuickMenuCustom_RightRing:SetShow(true)
  self:SetUICusttomSettingCurrentGroup(currentSettingGroup)
  self:rotateDpadCrossHair(currentSettingGroup)
  PaGlobal_ConsoleQuickMenuSetting:ShowBlackBg(false)
  if true == _ContentsGroup_RenewUI_Chatting and true == Panel_Widget_Chatting_Renew:GetShow() then
    PaGlobalFunc_ChattingInfo_Close()
  end
  if nil == _blueprintQuickMenuWhenOpen then
    _blueprintQuickMenuWhenOpen = {}
  end
  self:clearRegistCustomSetting()
  self:showRemoveIcon(false)
end
local _crossHairUV = {
  [0] = {
    97,
    1,
    192,
    96
  },
  {
    1,
    1,
    96,
    96
  },
  {
    193,
    1,
    288,
    96
  },
  {
    289,
    1,
    384,
    96
  }
}
local _crossHairURL = "renewal/function/console_function_ringmenu_01.dds"
function PaGlobal_ConsoleQuickMenuSetting:rotateDpadCrossHair(group)
  local control = PaGlobal_ConsoleQuickMenuSetting._ui._ringCrossHair
  UI.changeTextureUV(control, _crossHairURL, _crossHairUV[group % 4])
  if group < __eQuickMenuDpadGroup_Count / 2 then
    self._ui._stc_LTGuide:SetShow(false)
  else
    self._ui._stc_LTGuide:SetShow(true)
  end
end
function PaGlobal_ConsoleQuickMenuSetting:SetUICusttomSettingCurrentGroup(group)
  local groupInfo = PaGlobal_ConsoleQuickMenu:GetCurrentGroupInfo(group)
  for position, info in ipairs(groupInfo) do
    local control = self._ui._buttonPositionIcon[position - 1]
    if nil == control then
      return
    end
    PaGlobal_ConsoleQuickMenu:setIcon(control, info._icon, info._uv)
  end
end
function FGlobal_ConsoleQuickMenuSetting_RegistMode()
  local self = PaGlobal_ConsoleQuickMenuSetting
  local registPosition = ToClient_checkQuickMenuCurrentPosition()
  if __eQuickMenuStickPosition_Count == registPosition then
    if __eQuickMenuStickPosition_Count ~= self._registMode._stickPosition then
      self:quitRegistQuickMenu(self._registMode._stickPosition)
      _AudioPostEvent_SystemUiForXBOX(52, 1)
    end
  else
    self._registMode._stickPosition = registPosition
  end
  PaGlobal_ConsoleQuickMenuSetting:updatePosition(registPosition)
end
function FGlobal_ConsoleQuickMenuSetting_RemoveMode()
  local self = PaGlobal_ConsoleQuickMenuSetting
  local registPosition = ToClient_checkQuickMenuCurrentPosition()
  if __eQuickMenuStickPosition_Count == registPosition then
    if __eQuickMenuStickPosition_Count ~= self._registMode._stickPosition then
      self:quitRegistRemoveQuickMenu(self._registMode._stickPosition)
    end
  else
    self._registMode._stickPosition = registPosition
    self._registMode._settingData = ToClient_getAtQuickMenu(self._curGroup, self._registMode._stickPosition)
    local data = PaGlobal_ConsoleQuickMenu:GetPositionInfo(self._registMode._settingData)
    self:setCenterSlotIconAtregisterMode(data)
  end
  PaGlobal_ConsoleQuickMenuSetting:updatePosition(registPosition)
end
function PaGlobal_ConsoleQuickMenuSetting:updatePosition(registPosition)
  if __eQuickMenuStickPosition_Count == registPosition then
    for _, control in pairs(self._ui._buttonPosition) do
      control:SetMonoTone(false)
      control:SetCheck(false)
    end
    self._ui._registerModeSelectItem:SetText("")
  else
    for _, control in pairs(self._ui._buttonPosition) do
      control:SetMonoTone(true)
      control:SetCheck(false)
    end
    self._ui._buttonPosition[registPosition]:SetMonoTone(false)
    self._ui._buttonPosition[registPosition]:SetCheck(true)
    local string = PaGlobal_ConsoleQuickMenu:GetCurrentQuickMenuName(self._curGroup, self._registMode._stickPosition)
    self._ui._registerModeSelectItem:SetText(string)
    self._ui._RSGuideBg:SetShow(false)
  end
end
function FromClient_ConsoleQuickMenuSetting_luaLoadComplete()
  PaGlobal_ConsoleQuickMenuSetting:initializeUI()
  PaGlobal_ConsoleQuickMenuSetting:GoCategory(__eQuickMenuDataType_Item)
end
function FGlobal_ConsoleQuickMenu_PerFrame()
  if true == PaGlobal_ConsoleQuickMenuSetting._registMode._isStart then
    FGlobal_ConsoleQuickMenuSetting_RegistMode()
  else
    if true == PaGlobal_ConsoleQuickMenuSetting._registMode._isRemoveStart then
      FGlobal_ConsoleQuickMenuSetting_RemoveMode()
    else
    end
  end
end
function FGlobal_ConsoleQuickMenuSetting_Close()
  if PaGlobal_ConsoleQuickMenuSetting:isRegisterOrRemoveMode() then
    PaGlobal_ConsoleQuickMenuSetting:clearRegistCustomSetting()
    return
  end
  Panel_QuickMenuCustom:SetShow(false)
  Panel_QuickMenuCustom_RightRing:SetShow(false)
  if true == PaGlobal_ConsoleQuickMenuSetting._isRegisterQuickMenu then
    PaGlobal_ConsoleQuickMenuSetting._isRegisterQuickMenu = false
    local selfPlayer = getSelfPlayer()
    if nil ~= selfPlayer then
      selfPlayer:saveCurrentDataForGameExit()
    end
  end
end
function FGlobal_ConsoleQuickMenu_ChangeDpadGroup(left)
  local self = PaGlobal_ConsoleQuickMenuSetting
  local changeGroup = self._curGroup
  if left == false then
    changeGroup = (PaGlobal_ConsoleQuickMenuSetting._curGroup + 1) % __eQuickMenuDpadGroup_Count
  else
    changeGroup = (PaGlobal_ConsoleQuickMenuSetting._curGroup - 1) % __eQuickMenuDpadGroup_Count
  end
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  self._curGroup = changeGroup
  self:SetUICusttomSettingCurrentGroup(changeGroup)
  self:rotateDpadCrossHair(changeGroup)
end
function FGlobal_ConsoleQuickMenu_LTGroupToggle()
  local self = PaGlobal_ConsoleQuickMenuSetting
  local changeGroup = self._curGroup
  if changeGroup > 3 then
    changeGroup = changeGroup - __eQuickMenuDpadGroup_Count / 2
  else
    changeGroup = changeGroup + __eQuickMenuDpadGroup_Count / 2
  end
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  self._curGroup = changeGroup
  self:SetUICusttomSettingCurrentGroup(changeGroup)
  self:rotateDpadCrossHair(changeGroup)
end
function Toggle_QuickMenuSetting_forPadEventFunc(left)
  if true == left then
    PaGlobal_ConsoleQuickMenuSetting._curCategory = PaGlobal_ConsoleQuickMenuSetting._curCategory - 1
  else
    PaGlobal_ConsoleQuickMenuSetting._curCategory = PaGlobal_ConsoleQuickMenuSetting._curCategory + 1
  end
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  PaGlobal_ConsoleQuickMenuSetting._curCategory = PaGlobal_ConsoleQuickMenuSetting._curCategory % 4
  PaGlobal_ConsoleQuickMenuSetting:GoCategory(PaGlobal_ConsoleQuickMenuSetting._curCategory)
  PaGlobal_ConsoleQuickMenuSetting:showSelectKeyGuideA(true)
end
function PaGlobal_QuickMenuSetting_GetShow()
  return Panel_QuickMenuCustom:GetShow()
end
function Toggle_QuickMenuSetting_removeMode()
  if false == PaGlobal_ConsoleQuickMenuSetting._registMode._isRemoveStart then
    PaGlobal_ConsoleQuickMenuSetting:setRemoveMode(true)
  else
    PaGlobal_ConsoleQuickMenuSetting:setRemoveMode(false)
  end
end
Panel_QuickMenuCustom:registerPadEvent(__eConsoleUIPadEvent_RT, "FGlobal_ConsoleQuickMenu_ChangeDpadGroup(false)")
Panel_QuickMenuCustom:registerPadEvent(__eConsoleUIPadEvent_LT, "FGlobal_ConsoleQuickMenu_LTGroupToggle(false)")
Panel_QuickMenuCustom:registerPadEvent(__eConsoleUIPadEvent_LB, "Toggle_QuickMenuSetting_forPadEventFunc(true)")
Panel_QuickMenuCustom:registerPadEvent(__eConsoleUIPadEvent_RB, "Toggle_QuickMenuSetting_forPadEventFunc(false)")
Panel_QuickMenuCustom:registerPadEvent(__eConsoleUIPadEvent_Y, "Toggle_QuickMenuSetting_removeMode()")
Panel_QuickMenuCustom:RegisterUpdateFunc("FGlobal_ConsoleQuickMenu_PerFrame")
registerEvent("FromClient_luaLoadComplete", "FromClient_ConsoleQuickMenuSetting_luaLoadComplete")
registerEvent("FromClient_ConsoleQuickMenu_OpenCustomPage", "FromClient_ConsoleQuickMenu_OpenCustomPage")

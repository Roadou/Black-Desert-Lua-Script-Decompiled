PaGlobal_ConsoleQuickMenu = {
  _widgetForceClose = false,
  _inventoryData = {},
  _skillData = {},
  _functionTypeData = {},
  _ui = {
    _quickMenuPosition = {},
    _quickMenuPositionIcon = {},
    _quickMenuPositionSlot = {},
    _staticCircleLine = UI.getChildControl(Panel_QuickMenu, "Static_CircleLine"),
    _staticDeco = UI.getChildControl(Panel_QuickMenu, "Static_Deco"),
    _staticIconName = UI.getChildControl(Panel_QuickMenu, "Static_SelectedButton"),
    _staticTextIconNameDesc = UI.getChildControl(Panel_QuickMenu, "StaticText_SelectedButtonTitleDesc"),
    _staticTextIconDesc = UI.getChildControl(Panel_QuickMenu, "StaticText_SelectedButtonDesc"),
    _centerDeco = UI.getChildControl(Panel_QuickMenu, "Static_CenterDeco"),
    _line = {},
    _rightMenuPanel = {}
  },
  _curGroup = 0,
  _center = {_x = 0, _y = 0},
  _isAnimating = false,
  _registMode = {
    _isStart = false,
    _stickPosition = __eQuickMenuStickPosition_Count,
    _index = -1
  },
  _textureIcon = {
    _center = {
      [0] = {
        _x1 = 623,
        _y1 = 399,
        _x2 = 933,
        _y2 = 709
      },
      [1] = {
        _x1 = 399,
        _y1 = 88,
        _x2 = 709,
        _y2 = 398
      },
      [2] = {
        _x1 = 1,
        _y1 = 399,
        _x2 = 311,
        _y2 = 709
      },
      [3] = {
        _x1 = 312,
        _y1 = 399,
        _x2 = 622,
        _y2 = 709
      },
      [4] = {
        _x1 = 623,
        _y1 = 399,
        _x2 = 933,
        _y2 = 709
      },
      [5] = {
        _x1 = 399,
        _y1 = 88,
        _x2 = 709,
        _y2 = 398
      },
      [6] = {
        _x1 = 1,
        _y1 = 399,
        _x2 = 311,
        _y2 = 709
      },
      [7] = {
        _x1 = 312,
        _y1 = 399,
        _x2 = 622,
        _y2 = 709
      }
    },
    _bottom = {
      [0] = {
        _x1 = 399,
        _y1 = 710,
        _x2 = 485,
        _y2 = 796
      },
      [1] = {
        _x1 = 399,
        _y1 = 797,
        _x2 = 485,
        _y2 = 883
      },
      [2] = {
        _x1 = 486,
        _y1 = 710,
        _x2 = 572,
        _y2 = 796
      },
      [3] = {
        _x1 = 486,
        _y1 = 797,
        _x2 = 572,
        _y2 = 883
      },
      [4] = {
        _x1 = 399,
        _y1 = 710,
        _x2 = 485,
        _y2 = 796
      },
      [5] = {
        _x1 = 399,
        _y1 = 797,
        _x2 = 485,
        _y2 = 883
      },
      [6] = {
        _x1 = 486,
        _y1 = 710,
        _x2 = 572,
        _y2 = 796
      },
      [7] = {
        _x1 = 486,
        _y1 = 797,
        _x2 = 572,
        _y2 = 883
      }
    }
  },
  _slotConfig = {
    createIcon = true,
    createCount = true,
    createEnchant = false,
    createCooltime = true,
    createExpiration = true,
    createExpirationBG = true,
    createExpiration2h = true,
    createClassEquipBG = true,
    createEnduranceIcon = true,
    createCooltimeText = true,
    createCash = true,
    createItemLock = true,
    createBagIcon = true,
    createSoulComplete = true
  },
  _maxMenuTabType = 4,
  _widgetState = {},
  _widgetStateEnum = {
    None = 0,
    Exist = 1,
    Cooltime = 2,
    Empty = 3
  },
  _ringMoveCheck = false,
  _beforePositon = -1
}
function PaGlobal_ConsoleQuickMenu:initializeUI()
  local centerX, centerY, radius
  local uiScale = ToClient_getGameOptionControllerWrapper():getUIScale()
  for ii = 0, __eQuickMenuStickPosition_Count - 1 do
    self._ui._quickMenuPosition[ii] = UI.getChildControl(Panel_QuickMenu, "Button_Templete" .. tostring(ii))
    self._ui._quickMenuPositionIcon[ii] = UI.getChildControl(self._ui._quickMenuPosition[ii], "Static_Icon")
    self._ui._quickMenuPositionSlot[ii] = {}
    SlotItem.new(self._ui._quickMenuPositionSlot[ii], "QuickPosition_Slot_" .. ii, ii, self._ui._quickMenuPosition[ii], self._slotConfig)
    self._ui._quickMenuPositionSlot[ii]:createChild()
    self._ui._quickMenuPositionSlot[ii].icon:SetSize(self._ui._quickMenuPositionIcon[ii]:GetSizeX(), self._ui._quickMenuPositionIcon[ii]:GetSizeY())
    self._ui._quickMenuPositionSlot[ii].icon:SetPosX(self._ui._quickMenuPositionIcon[ii]:GetPosX())
    self._ui._quickMenuPositionSlot[ii].icon:SetPosY(self._ui._quickMenuPositionIcon[ii]:GetPosY())
    self._ui._quickMenuPositionSlot[ii].cooltime:SetSize(self._ui._quickMenuPositionSlot[ii].icon:GetSizeX(), self._ui._quickMenuPositionSlot[ii].icon:GetSizeY())
    radius = self._ui._quickMenuPositionSlot[ii].cooltime:GetSizeX() * 0.5 * uiScale
    centerX = self._ui._quickMenuPositionSlot[ii].cooltime:GetPosX() + 22
    centerY = self._ui._quickMenuPositionSlot[ii].cooltime:GetPosY() + 22
    self._ui._quickMenuPositionSlot[ii].cooltime:SetCircularClip(radius, float2(centerX, centerY))
  end
  self._ui._center = UI.getChildControl(Panel_QuickMenu, "Static_CenterPoint")
  if true == ToClient_isPS4() then
    self._ui._stc_LTGuide = UI.getChildControl(Panel_QuickMenu, "Static_LT_PS")
  else
    self._ui._stc_LTGuide = UI.getChildControl(Panel_QuickMenu, "Static_LT_XB")
  end
  for ii = 0, __eQuickMenuStickPosition_Count - 1 do
    self._ui._line[ii] = UI.getChildControl(self._ui._center, "Static_Line" .. ii)
    self._ui._line[ii]:SetShow(false)
  end
  self._ui._widget = {}
  self._widgetState = {}
  for group = 0, __eQuickMenuDpadGroup_Count - 1 do
    local bg = UI.getChildControl(Panel_Widget_QuickMenu, "Static_Bg" .. tostring(group))
    self._ui._widget[group] = {}
    self._ui._widget[group]._pad = UI.getChildControl(bg, "Static_Pad")
    self._ui._widget[group]._slotBg = UI.getChildControl(bg, "Static_SlotBg")
    self._ui._widget[group]._slot = {}
    SlotItem.new(self._ui._widget[group]._slot, "QuickGroup_Slot_" .. group, group, bg, self._slotConfig)
    self._ui._widget[group]._slot:createChild()
    self._ui._widget[group]._slot.icon:SetPosY(self._ui._widget[group]._slotBg:GetPosY() + 2)
    self._ui._widget[group]._slot.icon:SetPosX(self._ui._widget[group]._slotBg:GetPosX() + 2)
    self._ui._widget[group]._slot.cooltime:SetSize(self._ui._widget[group]._slotBg:GetSizeX(), self._ui._widget[group]._slotBg:GetSizeY())
    centerX = self._ui._widget[group]._slot.cooltime:GetPosX() + 22
    centerY = self._ui._widget[group]._slot.cooltime:GetPosY() + 22
    radius = self._ui._widget[group]._slot.cooltime:GetSizeX() * 0.5 * uiScale
    self._ui._widget[group]._slot.cooltime:SetCircularClip(radius, float2(centerX, centerY))
    self._ui._widget[group]._selected = UI.getChildControl(bg, "Static_SelectedPad")
    self._ui._widget[group]._ring = UI.getChildControl(bg, "Static_Ring")
    self._ui._widget[group]._ringPosition = {}
    self._widgetState[group] = {}
    for position = 0, __eQuickMenuStickPosition_Count - 1 do
      self._ui._widget[group]._ringPosition[position] = UI.getChildControl(self._ui._widget[group]._ring, "Static_" .. tostring(position))
      self._widgetState[group][position] = nil
    end
  end
  self._ui._rightMenuPanel._stc_LeftBg = UI.getChildControl(Panel_QuickMenuCustom, "Static_LeftBg")
  self._ui._rightMenuPanel._txt_RingMenuDesc = UI.getChildControl(self._ui._rightMenuPanel._stc_LeftBg, "StaticText_RingMenuDesc")
  self._ui._rightMenuPanel._txt_RingMenuDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._rightMenuPanel._txt_RingMenuDesc:SetAutoResize(true)
  self._ui._rightMenuPanel._txt_RingMenuDesc:SetText(self._ui._rightMenuPanel._txt_RingMenuDesc:GetText())
  self._ui._rightMenuPanel._txt_QuickSlotDesc = UI.getChildControl(self._ui._rightMenuPanel._stc_LeftBg, "StaticText_QuickSlotDesc")
  self._ui._rightMenuPanel._txt_QuickSlotDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._rightMenuPanel._txt_QuickSlotDesc:SetAutoResize(true)
  self._ui._rightMenuPanel._txt_QuickSlotDesc:SetText(self._ui._rightMenuPanel._txt_QuickSlotDesc:GetText())
  self._ui._rightMenuPanel._txt_ChangeMenuDesc = UI.getChildControl(self._ui._rightMenuPanel._stc_LeftBg, "StaticText_ChangeMenuDesc")
  self._ui._rightMenuPanel._txt_ChangeMenuDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._rightMenuPanel._txt_ChangeMenuDesc:SetAutoResize(true)
  self._ui._rightMenuPanel._txt_ChangeMenuDesc:SetText(self._ui._rightMenuPanel._txt_ChangeMenuDesc:GetText())
  self._ui._rightMenuPanel._stc_TabBg = UI.getChildControl(Panel_QuickMenuCustom, "Static_TabBg")
  self._ui._rightMenuPanel._btn_TabBtn = {}
  self._ui._rightMenuPanel._btn_TabBtn[__eQuickMenuDataType_Item] = UI.getChildControl(self._ui._rightMenuPanel._stc_TabBg, "RadioButton_Item")
  self._ui._rightMenuPanel._btn_TabBtn[__eQuickMenuDataType_Skill] = UI.getChildControl(self._ui._rightMenuPanel._stc_TabBg, "RadioButton_Skill")
  self._ui._rightMenuPanel._btn_TabBtn[__eQuickMenuDataType_Function] = UI.getChildControl(self._ui._rightMenuPanel._stc_TabBg, "RadioButton_Menu")
  self._ui._rightMenuPanel._btn_TabBtn[__eQuickMenuDataType_SocialAction] = UI.getChildControl(self._ui._rightMenuPanel._stc_TabBg, "RadioButton_Social")
end
function PaGlobal_ConsoleQuickMenu:setCoolTime(slot, quickMenu)
  slot.count:SetShow(false)
  slot.icon:SetMonoTone(false)
  if __eQuickMenuDataType_Skill == quickMenu._type then
    local skillStaticWrapper = getSkillStaticStatus(quickMenu._skillKey:getSkillNo(), 1)
    if nil == skillStaticWrapper then
      return
    end
    local remainTime = ToClient_getSkillCooltimebySkillNo(quickMenu._skillKey:getSkillNo())
    local skillReuseTime = skillStaticWrapper:get()._reuseCycle / 1000
    local realRemainTime = remainTime * skillReuseTime
    local intRemainTime = realRemainTime - realRemainTime % 1 + 1
    if remainTime > 0 then
      slot.cooltime:UpdateCoolTime(remainTime)
      slot.cooltime:SetShow(true)
      slot.cooltimeText:SetText(Time_Formatting_ShowTop(intRemainTime))
      if skillReuseTime >= intRemainTime then
        slot.cooltimeText:SetShow(true)
      else
        slot.cooltimeText:SetShow(false)
      end
    else
      slot.cooltime:SetShow(false)
      slot.cooltimeText:SetShow(false)
    end
  elseif __eQuickMenuDataType_Item == quickMenu._type then
    local itemStaticStatusWrapper = getItemEnchantStaticStatus(quickMenu._itemKey)
    if nil == itemStaticStatusWrapper then
      return
    end
    local whereType
    if true == itemStaticStatusWrapper:get():isCash() then
      whereType = CppEnums.ItemWhereType.eCashInventory
    else
      whereType = CppEnums.ItemWhereType.eInventory
    end
    local selfPlayer = getSelfPlayer():get()
    local inventory = selfPlayer:getInventoryByType(whereType)
    local slotNo = inventory:getSlot(quickMenu._itemKey)
    local itemWrapper = getInventoryItemByType(whereType, slotNo)
    if nil ~= itemWrapper then
      local itemCount = Int64toInt32(itemWrapper:get():getCount_s64())
      if itemCount > 0 then
        slot.count:SetShow(true)
        slot.count:SetText(itemCount)
        slot.icon:SetMonoTone(false)
      else
        slot.count:SetShow(false)
        slot.icon:SetMonoTone(true)
      end
    else
      slot.count:SetShow(false)
      slot.icon:SetMonoTone(true)
    end
    if 0 == itemCount then
      return
    end
    local remainTime = getItemCooltime(whereType, slotNo)
    local itemReuseTime = getItemReuseCycle(whereType, slotNo) / 1000
    local realRemainTime = remainTime * itemReuseTime
    local intRemainTime = realRemainTime - realRemainTime % 1 + 1
    if remainTime > 0 then
      slot.cooltime:UpdateCoolTime(remainTime)
      slot.cooltime:SetShow(true)
      slot.cooltimeText:SetText(Time_Formatting_ShowTop(intRemainTime))
      if itemReuseTime >= intRemainTime then
        slot.cooltimeText:SetShow(true)
        PaGlobal_TutorialManager:handleUpdateQuickSlotPerFrame(slot, quickMenu._itemKey:getItemKey())
      else
        slot.cooltimeText:SetShow(false)
      end
    elseif slot.cooltime:GetShow() then
      slot.cooltime:SetShow(false)
      slot.cooltimeText:SetShow(false)
    end
  elseif slot.cooltime:GetShow() then
    slot.cooltime:SetShow(false)
    slot.cooltimeText:SetShow(false)
  end
end
function PaGlobal_ConsoleQuickMenu:setWidgetRingPosition(group, position, control)
  local quickMenu = ToClient_getAtQuickMenu(group, position)
  local beforeState = self._widgetState[group][position]
  local currentState = self._widgetStateEnum.None
  if __eQuickMenuDataType_Empty == quickMenu._type then
    currentState = self._widgetStateEnum.None
  else
    currentState = self._widgetStateEnum.Exist
  end
  if __eQuickMenuDataType_Skill == quickMenu._type then
    local skillStaticWrapper = getSkillStaticStatus(quickMenu._skillKey:getSkillNo(), 1)
    if nil == skillStaticWrapper then
      return
    end
    local remainTime = ToClient_getSkillCooltimebySkillNo(quickMenu._skillKey:getSkillNo())
    if remainTime > 0 then
      currentState = self._widgetStateEnum.Cooltime
    end
  elseif __eQuickMenuDataType_Item == quickMenu._type then
    local itemStaticStatusWrapper = getItemEnchantStaticStatus(quickMenu._itemKey)
    if nil == itemStaticStatusWrapper then
      return
    end
    local whereType
    if true == itemStaticStatusWrapper:get():isCash() then
      whereType = CppEnums.ItemWhereType.eCashInventory
    else
      whereType = CppEnums.ItemWhereType.eInventory
    end
    local selfPlayer = getSelfPlayer():get()
    local inventory = selfPlayer:getInventoryByType(whereType)
    local slotNo = inventory:getSlot(quickMenu._itemKey)
    local itemWrapper = getInventoryItemByType(whereType, slotNo)
    local remainTime = getItemCooltime(whereType, slotNo)
    if remainTime > 0 then
      currentState = self._widgetStateEnum.Cooltime
    end
    if nil ~= itemWrapper then
      local itemCount = Int64toInt32(itemWrapper:get():getCount_s64())
      if itemCount <= 0 then
        currentState = self._widgetStateEnum.Empty
      end
    else
      currentState = self._widgetStateEnum.Empty
    end
  end
  if currentState ~= beforeState then
    self._widgetState[group][position] = currentState
    self:setWidgetState(control, self._widgetState[group][position])
  end
end
function PaGlobal_ConsoleQuickMenu:setWidgetState(control, state)
  control:ChangeTextureInfoName("Renewal/Function/Console_Function_RingMenu_01.dds")
  if state == self._widgetStateEnum.None then
    control:SetShow(false)
  elseif state == self._widgetStateEnum.Exist then
    control:getBaseTexture():setUV(setTextureUV_Func(control, 333, 97, 342, 106))
    control:SetShow(true)
  elseif state == self._widgetStateEnum.Cooltime then
    control:getBaseTexture():setUV(setTextureUV_Func(control, 343, 97, 352, 106))
    control:SetShow(true)
  elseif state == self._widgetStateEnum.Empty then
    control:getBaseTexture():setUV(setTextureUV_Func(control, 353, 97, 362, 106))
    control:SetShow(true)
  end
  control:setRenderTexture(control:getBaseTexture())
end
function FGlobal_Console_Widget_QuickMenuCustom_UpdatePerFrame(deltaTime)
  local self = PaGlobal_ConsoleQuickMenu
  for group = 0, __eQuickMenuDpadGroup_Count - 1 do
    if true == ToClient_isQuickMenuQuickMode(group) then
      local quickSlot = ToClient_getQuickModeValue(group)
      local slot = self._ui._widget[group]._slot
      self:setCoolTime(slot, quickSlot)
    else
      for position = 0, __eQuickMenuStickPosition_Count - 1 do
        self:setWidgetRingPosition(group, position, self._ui._widget[group]._ringPosition[position])
      end
    end
  end
end
function PaGlobal_ConsoleQuickMenuCustom_HighlightCategory(category)
  self = PaGlobal_ConsoleQuickMenu
  for ii = 0, self._maxMenuTabType - 1 do
    self._ui._rightMenuPanel._btn_TabBtn[ii]:SetFontColor(Defines.Color.C_FF888888)
  end
  self._ui._rightMenuPanel._btn_TabBtn[category]:SetFontColor(Defines.Color.C_FFEEEEEE)
end
function PaGlobal_ConsoleQuickMenu:setButtonPos(selectedIndex)
  if self._isAnimating then
    return
  end
  self._center.x = self._ui._center:GetPosX()
  self._center.y = self._ui._center:GetPosY()
  local angle = 2 * math.pi / 8 * 5
  local angleOffset = 2 * math.pi / 8
  for index = 0, 7 do
    angle = angle + angleOffset
    if selectedIndex == index then
      local x = 205 * math.cos(angle)
      local y = 205 * math.sin(angle)
      self._ui._quickMenuPosition[index]:SetPosX(self._center.x + x - 47)
      self._ui._quickMenuPosition[index]:SetPosY(self._center.y + y - 47)
      self._ui._line[index]:SetShow(false)
    else
      local x = 185 * math.cos(angle)
      local y = 185 * math.sin(angle)
      self._ui._quickMenuPosition[index]:SetPosX(self._center.x + x - 47)
      self._ui._quickMenuPosition[index]:SetPosY(self._center.y + y - 47)
      self._ui._line[index]:SetShow(false)
    end
  end
end
function PaGlobal_ConsoleQuickMenu:moveButtonAni(currentPosition)
  if nil == currentPosition or currentPosition < 0 or currentPosition >= __eQuickMenuStickPosition_Count then
    return
  end
  local control = self._ui._quickMenuPosition[currentPosition]
  local buttonMoveAni = control:addMoveAnimation(0, 0.1, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  buttonMoveAni:SetStartPosition(control:GetPosX(), control:GetPosY())
  buttonMoveAni:SetEndPosition(self._center.x - 47, self._center.y - 47)
  buttonMoveAni.IsChangeChild = true
  control:CalcUIAniPos(buttonMoveAni)
  buttonMoveAni:SetDisableWhileAni(true)
  for index, value in pairs(self._ui._line) do
    value:SetShow(false)
  end
  self._isAnimating = true
end
function PaGlobal_ConsoleQuickMenu:clearButtonAni()
  for index, value in pairs(self._ui._quickMenuPosition) do
    value:ResetAndClearVertexAni()
  end
end
function QuickMenu_ShowAni()
  UIAni.AlphaAnimation(1, Panel_QuickMenu, 0, 0.1)
  local aniInfo1 = Panel_QuickMenu:addScaleAnimation(0, 0.1, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.9)
  aniInfo1:SetEndScale(1)
  aniInfo1.AxisX = Panel_QuickMenu:GetSizeX() / 2
  aniInfo1.AxisY = Panel_QuickMenu:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
end
function QuickMenu_HideAni()
  local aniInfo = UIAni.AlphaAnimation(0, Panel_QuickMenu, 0.1, 0.2)
  aniInfo:SetHideAtEnd(true)
end
function FGlobal_ConsoleQuickMenu_IsShow()
  return Panel_QuickMenu:GetShow()
end
function FGlobal_ConsoleQuickMenuCustom_IsShow()
  return Panel_QuickMenuCustom:GetShow()
end
function PaGlobal_ConsoleQuickMenu:Open(currentGroup)
  if currentGroup < 0 or currentGroup >= __eQuickMenuDpadGroup_Count then
    return
  end
  if true == Panel_QuickMenuCustom:GetShow() then
    return
  end
  self._curGroup = currentGroup
  self:SetUICurrentGroup(currentGroup)
  self._isAnimating = false
  PaGlobal_ConsoleQuickMenu:clearButtonAni()
  self:setButtonPos(__eQuickMenuStickPosition_Count)
  self:CrossTextureChange(currentGroup)
  Panel_QuickMenu:SetPosY((getOriginScreenSizeY() - Panel_QuickMenu:GetSizeY()) / 2)
  Panel_QuickMenu:SetShow(true, true)
  _AudioPostEvent_SystemUiForXBOX(52, 0)
  self._ui._staticTextIconNameDesc:SetText("")
  self._ui._staticCircleLine:EraseAllEffect()
  self._ui._staticCircleLine:AddEffect("fUI_Console_Rudder_01A", false, 0, 0)
end
function FromClient_ConsoleQuickMenu_Close(currentPosition)
  local self = PaGlobal_ConsoleQuickMenu
  if nil == self then
    return
  end
  self._beforePositon = -1
  PaGlobal_ConsoleQuickMenu:moveButtonAni(currentPosition)
  _AudioPostEvent_SystemUiForXBOX(52, 2)
  Panel_QuickMenu:SetShow(false, false)
end
function PaGlobal_ConsoleQuickMenu:SetUICurrentGroup(group)
  local groupInfo = self:GetCurrentGroupInfo(group)
  for position, info in ipairs(groupInfo) do
    if nil == self._ui._quickMenuPositionSlot[position - 1].icon then
      return
    end
    local control = self._ui._quickMenuPositionSlot[position - 1].icon
    control:ChangeTextureInfoName(info._icon)
    if nil ~= info._uv then
      control:getBaseTexture():setUV(setTextureUV_Func(control, info._uv._x1, info._uv._y1, info._uv._x2, info._uv._y2))
    else
      control:getBaseTexture():setUV(0, 0, 1, 1)
    end
    control:setRenderTexture(control:getBaseTexture())
  end
end
function PaGlobal_ConsoleQuickMenu:GetPositionInfo(quickMenu)
  if nil == quickMenu then
    return nil
  end
  local name = ""
  local icon = ""
  local uv
  if __eQuickMenuDataType_Skill == quickMenu._type then
    local skillTypeStaticWrapper = getSkillTypeStaticStatus(quickMenu._skillKey:getSkillNo())
    if nil ~= skillTypeStaticWrapper then
      name = skillTypeStaticWrapper:getName()
      icon = "Icon/" .. skillTypeStaticWrapper:getIconPath()
    end
  elseif __eQuickMenuDataType_Item == quickMenu._type then
    local itemStaticStatusWrapper = getItemEnchantStaticStatus(quickMenu._itemKey)
    if nil ~= itemStaticStatusWrapper then
      name = itemStaticStatusWrapper:getName()
      icon = "Icon/" .. itemStaticStatusWrapper:getIconPath()
    end
  elseif __eQuickMenuDataType_Function == quickMenu._type then
    name = self._functionTypeList._name[__eQuickMenuDataType_Function][quickMenu._functionType]
    icon = self._functionTypeList._icon[__eQuickMenuDataType_Function][quickMenu._functionType]._path
    local iconUV = self._functionTypeList._icon[__eQuickMenuDataType_Function][quickMenu._functionType]
    uv = {
      _x1 = iconUV._x1,
      _y1 = iconUV._y1,
      _x2 = iconUV._x2,
      _y2 = iconUV._y2
    }
  elseif __eQuickMenuDataType_SocialAction == quickMenu._type then
    for ii = 0, ToClient_getSocialActionInfoList() - 1 do
      local socialActionInfo = ToClient_getSocialActionInfoByIndex(ii)
      local sASS = socialActionInfo:getStaticStatus()
      local socialKey = sASS:getKey()
      if socialKey == quickMenu._socialActionKey then
        name = sASS:getName()
        icon = "Icon/" .. sASS:getIconPath()
        break
      end
    end
  end
  return {
    _name = name,
    _icon = icon,
    _uv = uv,
    _type = quickMenu._type
  }
end
function PaGlobal_ConsoleQuickMenu:GetCurrentGroupInfo(group)
  if group < 0 or group >= __eQuickMenuDpadGroup_Count then
    return
  end
  local table = {}
  for position = 0, __eQuickMenuStickPosition_Count - 1 do
    local quickMenu = ToClient_getAtQuickMenu(group, position)
    if nil == quickMenu then
      return
    end
    table[#table + 1] = self:GetPositionInfo(quickMenu)
  end
  return table
end
function PaGlobal_ConsoleQuickMenu:GetCurrentQuickMenuName(group, position)
  if group < 0 or group >= __eQuickMenuDpadGroup_Count then
    return ""
  end
  local table = {}
  local quickMenu = ToClient_getAtQuickMenu(group, position)
  if nil == quickMenu then
    return ""
  end
  local name = ""
  if __eQuickMenuDataType_Skill == quickMenu._type then
    local skillTypeStaticWrapper = getSkillTypeStaticStatus(quickMenu._skillKey:getSkillNo())
    if nil ~= skillTypeStaticWrapper then
      name = skillTypeStaticWrapper:getName()
    end
  elseif __eQuickMenuDataType_Item == quickMenu._type then
    local itemStaticStatusWrapper = getItemEnchantStaticStatus(quickMenu._itemKey)
    if nil ~= itemStaticStatusWrapper then
      name = itemStaticStatusWrapper:getName()
    end
  elseif __eQuickMenuDataType_Function == quickMenu._type then
    name = self._functionTypeList._name[__eQuickMenuDataType_Function][quickMenu._functionType]
  end
  return name
end
function PaGlobal_ConsoleQuickMenu:setIcon(control, icon, uv)
  if nil == control then
    return
  end
  control:SetShow(false)
  if nil == icon then
    return
  end
  control:ChangeTextureInfoName(icon)
  if nil ~= uv then
    control:getBaseTexture():setUV(setTextureUV_Func(control, uv._x1, uv._y1, uv._x2, uv._y2))
  else
    control:getBaseTexture():setUV(0, 0, 1, 1)
  end
  control:setRenderTexture(control:getBaseTexture())
  control:SetShow(true)
end
function PaGlobal_ConsoleQuickMenu:setAsyncIcon(control, icon)
  if nil == control then
    return
  end
  control:SetShow(false)
  if nil == icon then
    return
  end
  control:ChangeTextureInfoNameAsync(icon)
  local x1, y1, x2, y2 = setTextureUV_Func(control, 0, 0, 44, 44)
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
  control:SetShow(true)
end
function PaGlobal_ConsoleQuickMenu:CrossTextureChange(currentGroup)
  local bottomControl = self._ui._staticIconName
  local iconPathData1 = self._textureIcon._bottom[currentGroup]
  bottomControl:ChangeTextureInfoName("Renewal/Function/Console_Function_RingMenu.dds")
  bottomControl:getBaseTexture():setUV(setTextureUV_Func(bottomControl, iconPathData1._x1, iconPathData1._y1, iconPathData1._x2, iconPathData1._y2))
  bottomControl:setRenderTexture(bottomControl:getBaseTexture())
  local centerControl = self._ui._centerDeco
  local iconPathData2 = self._textureIcon._center[currentGroup]
  centerControl:ChangeTextureInfoName("Renewal/Function/Console_Function_RingMenu.dds")
  centerControl:getBaseTexture():setUV(setTextureUV_Func(centerControl, iconPathData2._x1, iconPathData2._y1, iconPathData2._x2, iconPathData2._y2))
  centerControl:setRenderTexture(centerControl:getBaseTexture())
  if currentGroup < __eQuickMenuDpadGroup_Count / 2 then
    self._ui._stc_LTGuide:SetShow(false)
  else
    self._ui._stc_LTGuide:SetShow(true)
  end
end
function PaGlobal_ConsoleQuickMenu:setWidget()
  if nil == self._ui._widget then
    return
  end
  for group = 0, __eQuickMenuDpadGroup_Count - 1 do
    local widget = self._ui._widget[group]
    if ToClient_isQuickMenuQuickMode(group) then
      widget._ring:SetShow(false)
      widget._slot.icon:SetShow(true)
    else
      widget._ring:SetShow(true)
      widget._slot.icon:SetShow(false)
    end
  end
  for group = 0, __eQuickMenuDpadGroup_Count - 1 do
    local widget = self._ui._widget[group]
    if ToClient_isQuickMenuQuickMode(group) then
      widget._ring:SetShow(false)
      widget._slot.icon:SetShow(true)
      local quickSlot = ToClient_getQuickModeValue(group)
      local quickSlotInfo = self:GetPositionInfo(quickSlot)
      if __eQuickMenuDataType_Item == quickSlotInfo._type then
        local itemStaticStatusWrapper = getItemEnchantStaticStatus(quickSlot._itemKey)
        if nil == itemStaticStatusWrapper then
          return
        end
        local whereType
        if true == itemStaticStatusWrapper:get():isCash() then
          whereType = CppEnums.ItemWhereType.eCashInventory
        else
          whereType = CppEnums.ItemWhereType.eInventory
        end
        local selfPlayer = getSelfPlayer():get()
        local inventory = selfPlayer:getInventoryByType(whereType)
        local slotNo = inventory:getSlot(quickSlot._itemKey)
        local itemWrapper = getInventoryItemByType(whereType, slotNo)
        if nil ~= itemWrapper then
          widget._slot:setItem(itemWrapper)
        end
        self:setAsyncIcon(widget._slot.icon, quickSlotInfo._icon)
      elseif __eQuickMenuDataType_Skill == quickSlotInfo._type then
        self:setAsyncIcon(widget._slot.icon, quickSlotInfo._icon)
      elseif __eQuickMenuDataType_SocialAction == quickSlotInfo._type then
        self:setAsyncIcon(widget._slot.icon, quickSlotInfo._icon)
      else
        self:setIcon(widget._slot.icon, quickSlotInfo._icon, quickSlotInfo._uv)
      end
    end
  end
end
function FromClient_ConsoleQuickMenu_luaLoadComplete()
  PaGlobal_ConsoleQuickMenu:initializeUI()
  PaGlobal_ConsoleQuickMenu:setDefaultSetting()
  PaGlobal_ConsoleQuickMenu:setWidget()
  Panel_Widget_QuickMenu:SetShow(true)
  ToClient_setAvailableInputWidget(true)
  registerEvent("FromClient_ConsoleQuickMenu_OpenCustomPage", "FromClient_ConsoleQuickMenu_OpenCustomPage")
  registerEvent("FromClient_ConsoleQuickMenu_Open", "FromClient_ConsoleQuickMenu_Open")
  registerEvent("FromClient_ConsoleQuickMenu_Close", "FromClient_ConsoleQuickMenu_Close")
  registerEvent("FromClient_ConsoleQuickMenu_Execute", "FromClient_ConsoleQuickMenu_Execute")
  registerEvent("FromClient_ConsoleQuickMenu_Selecting", "FromClient_ConsoleQuickMenu_Selecting")
  registerEvent("EventProcessorInputModeChange", "FGlobal_InputModeChangeForQuickMenu")
end
function FromClient_ConsoleQuickMenu_Open(group)
  PaGlobal_ConsoleQuickMenu:Open(group)
end
function FromClient_ConsoleQuickMenu_Execute(position)
end
function FromClient_ConsoleQuickMenu_Selecting(group, position)
  local self = PaGlobal_ConsoleQuickMenu
  if __eQuickMenuStickPosition_Count == position then
    for ii = 0, __eQuickMenuStickPosition_Count do
      local control = PaGlobal_ConsoleQuickMenu._ui._quickMenuPosition[ii]
      if control == nil then
        break
      end
      control:SetMonoTone(false)
      control:SetCheck(false)
    end
  else
    for ii = 0, __eQuickMenuStickPosition_Count do
      local control = PaGlobal_ConsoleQuickMenu._ui._quickMenuPosition[ii]
      if control == nil then
        break
      end
      control:SetMonoTone(true)
      control:SetCheck(false)
    end
    local name = PaGlobal_ConsoleQuickMenu:GetCurrentQuickMenuName(PaGlobal_ConsoleQuickMenu._curGroup, position)
    PaGlobal_ConsoleQuickMenu._ui._staticTextIconNameDesc:SetText(name)
    PaGlobal_ConsoleQuickMenu._ui._quickMenuPosition[position]:SetMonoTone(false)
    PaGlobal_ConsoleQuickMenu._ui._quickMenuPosition[position]:SetCheck(true)
    if false == self._ringMoveCheck and self._beforePositon ~= position then
      _AudioPostEvent_SystemUiForXBOX(51, 6)
      self._ringMoveCheck = true
      self._beforePositon = position
      self._ui._staticDeco:EraseAllEffect()
      self._ui._staticDeco:AddEffect("", false, self._ui._quickMenuPosition[position]:GetPosX() + (self._ui._quickMenuPosition[position]:GetSizeX() - self._ui._staticDeco:GetSizeX()) * 0.5, self._ui._quickMenuPosition[position]:GetPosY() + (self._ui._quickMenuPosition[position]:GetSizeY() - self._ui._staticDeco:GetSizeY()) * 0.5)
      self._ui._quickMenuPosition[position]:EraseAllEffect()
      self._ui._quickMenuPosition[position]:AddEffect("", false, 0, 0)
      self._ui._quickMenuPositionIcon[position]:EraseAllEffect()
      self._ui._quickMenuPositionIcon[position]:AddEffect("fUI_Console_Rudder_02A", false, 0, 0)
    end
  end
  self._ringMoveCheck = false
  for position = 0, __eQuickMenuStickPosition_Count - 1 do
    local quickSlot = ToClient_getAtQuickMenu(group, position)
    local slot = PaGlobal_ConsoleQuickMenu._ui._quickMenuPositionSlot[position]
    PaGlobal_ConsoleQuickMenu:setCoolTime(slot, quickSlot)
  end
end
function FGlobal_InputModeChangeForQuickMenu(prevMode, currentMode)
  if true == PaGlobal_ConsoleQuickMenu._widgetForceClose then
    return
  end
  if currentMode == CppEnums.EProcessorInputMode.eProcessorInputMode_GameMode then
    Panel_Widget_QuickMenu:SetShow(true)
  else
    if currentMode == CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode then
      PaGlobalFunc_ConsoleKeyGuide_PopGuide()
    end
    Panel_Widget_QuickMenu:SetShow(false)
  end
end
Panel_Widget_QuickMenu:RegisterUpdateFunc("FGlobal_Console_Widget_QuickMenuCustom_UpdatePerFrame")
Panel_QuickMenu:RegisterShowEventFunc(true, "QuickMenu_ShowAni()")
Panel_QuickMenu:RegisterShowEventFunc(false, "QuickMenu_HideAni()")
registerEvent("FromClient_luaLoadComplete", "FromClient_ConsoleQuickMenu_luaLoadComplete")

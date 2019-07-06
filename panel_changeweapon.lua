Panel_ChangeWeapon:SetShow(false)
Panel_ChangeWeapon:setMaskingChild(true)
Panel_ChangeWeapon:setGlassBackground(true)
Panel_ChangeWeapon:RegisterShowEventFunc(true, "Panel_ChangeWeapon_ShowAni()")
Panel_ChangeWeapon:RegisterShowEventFunc(false, "Panel_ChangeWeapon_HideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local title = UI.getChildControl(Panel_ChangeWeapon, "StaticText_Title")
local btn_CloseIcon = UI.getChildControl(Panel_ChangeWeapon, "Button_CloseIcon")
local btn_Close = UI.getChildControl(Panel_ChangeWeapon, "Button_Close")
local btn_Apply = UI.getChildControl(Panel_ChangeWeapon, "Button_Apply")
local runEffect = UI.getChildControl(Panel_ChangeWeapon, "Static_BackEffect")
local equipIcon = UI.getChildControl(Panel_ChangeWeapon, "equipIcon_1")
local avatarIcon = UI.getChildControl(Panel_ChangeWeapon, "equipIcon_2")
local _buttonQuestion = UI.getChildControl(Panel_ChangeWeapon, "Button_Question")
_buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"ClothExchange\" )")
_buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"ClothExchange\", \"true\")")
_buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"ClothExchange\", \"false\")")
_buttonQuestion:SetShow(false)
local equipSlot = {}
local avatarSlot = {}
local selectedItemSlotNo, selectedItemWhere
local elapsTime = 0
local doChange = false
local resultItemKey = 0
local isChangeDoing = false
local slotConfig = {
  createIcon = true,
  createBorder = true,
  createCount = true,
  createCash = false,
  createEnchant = true
}
local function initiallize()
  btn_Apply:addInputEvent("Mouse_LUp", "WeaponChange_ApplyChangeItem()")
  btn_Close:addInputEvent("Mouse_LUp", "WeaponChange_Close()")
  btn_CloseIcon:addInputEvent("Mouse_LUp", "WeaponChange_Close()")
  SlotItem.new(equipSlot, "ChangeWeapon_equipSlot", 0, equipIcon, slotConfig)
  equipSlot:createChild()
  equipSlot.icon:SetPosX(0)
  equipSlot.icon:SetPosY(0)
  equipSlot.icon:addInputEvent("Mouse_On", "WeaponChange_IconOver( true, " .. 0 .. " )")
  equipSlot.icon:addInputEvent("Mouse_Out", "WeaponChange_IconOver( false, " .. 0 .. " )")
  SlotItem.new(avatarSlot, "ChangeWeapon_avatarSlot", 0, avatarIcon, slotConfig)
  avatarSlot:createChild()
  avatarSlot.icon:SetPosX(0)
  avatarSlot.icon:SetPosY(0)
  avatarSlot.icon:addInputEvent("Mouse_On", "WeaponChange_IconOver( true, " .. 1 .. " )")
  avatarSlot.icon:addInputEvent("Mouse_Out", "WeaponChange_IconOver( false, " .. 1 .. " )")
  runEffect:SetShow(false)
  btn_Apply:SetShow(true)
  btn_Close:SetShow(false)
  btn_Apply:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHANGEWEAPON_EXCHANGE"))
  local btnApplySizeX = btn_Apply:GetSizeX() + 23
  local btnApplyTextPosX = btnApplySizeX - btnApplySizeX / 2 - btn_Apply:GetTextSizeX() / 2
  btn_Apply:SetTextSpan(btnApplyTextPosX, 6)
end
initiallize()
function Panel_ChangeWeapon_ShowAni()
  UIAni.fadeInSCR_Down(Panel_ChangeWeapon)
  local aniInfo1 = Panel_ChangeWeapon:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_ChangeWeapon:GetSizeX() / 2
  aniInfo1.AxisY = Panel_ChangeWeapon:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_ChangeWeapon:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_ChangeWeapon:GetSizeX() / 2
  aniInfo2.AxisY = Panel_ChangeWeapon:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_ChangeWeapon_HideAni()
  Panel_ChangeWeapon:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_ChangeWeapon, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local materialWhereType, materialSlotno
function FromClient_UseItemExchangeToClass(whereType, SlotNo)
  selectedItemSlotNo = nil
  selectedItemWhere = nil
  elapsTime = 0
  doChange = false
  resultItemKey = 0
  btn_Apply:SetShow(true)
  btn_Close:SetShow(false)
  runEffect:SetShow(false)
  btn_Apply:SetMonoTone(true)
  btn_Apply:SetEnable(false)
  btn_Apply:SetIgnore(true)
  avatarSlot.icon:EraseAllEffect()
  materialWhereType = whereType
  materialSlotno = SlotNo
  Panel_ChangeWeapon:SetShow(true, true)
  Inventory_SetFunctor(WeaponChange_SetFilter, WeaponChange_Rclick, nil, nil)
  Inventory_SetShow(true)
end
function WeaponChange_SetFilter(slotNo, itemWrapper, whereType)
  local itemKey = itemWrapper:get():getKey()
  local changeItemWrapper = getExchangeItem(whereType, slotNo, materialWhereType, materialSlotno)
  if nil == changeItemWrapper then
    return true
  else
    local itemSSW = changeItemWrapper:getStaticStatus()
    local equipType = itemSSW:getEquipType()
    local itemWrapper = getInventoryItemByType(materialWhereType, materialSlotno)
    local filterClassType = itemWrapper:getStaticStatus():getContentsEventParam1()
    local classType = getSelfPlayer():getClassType()
    local itemStaticStatus = getInventoryItemByType(whereType, slotNo):getStaticStatus()
    if -1 == filterClassType then
      if CppEnums.ClassType.ClassType_NinjaMan == classType then
        if 56 == equipType then
          return false
        end
      elseif CppEnums.ClassType.ClassType_NinjaWomen == classType and 55 == equipType then
        return false
      end
      return itemStaticStatus:get()._usableClassType:isOn(classType)
    else
      if CppEnums.ClassType.ClassType_NinjaMan == filterClassType then
        if 56 == equipType then
          return false
        end
      elseif CppEnums.ClassType.ClassType_NinjaWomen == filterClassType and 55 == equipType then
        return false
      end
      return itemStaticStatus:get()._usableClassType:isOn(filterClassType)
    end
  end
end
function WeaponChange_Rclick(slotNo, itemWrapper, count_s64, inventoryType)
  selectedItemSlotNo = slotNo
  selectedItemWhere = inventoryType
  elapsTime = 0
  equipSlot:clearItem()
  equipSlot:setItem(itemWrapper)
  btn_Apply:SetMonoTone(false)
  btn_Apply:SetEnable(true)
  btn_Apply:SetIgnore(false)
  local itemKey = itemWrapper:get():getKey()
  local toItemWrapper = getExchangeItem(inventoryType, slotNo, materialWhereType, materialSlotno)
  if nil ~= toItemWrapper then
    resultItemKey = toItemWrapper:get():getKey():getItemKey()
    avatarSlot:clearItem()
    avatarSlot:setItemByStaticStatus(toItemWrapper:getStaticStatus(), 1, nil, nil, true)
    avatarSlot.icon:SetMonoTone(true)
  end
end
function WeaponChange_ApplyChangeItem()
  if nil == selectedItemWhere or nil == selectedItemSlotNo then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHANGEWEAPON_SELECTITEM"))
    return
  end
  local function changeGo()
    elapsTime = 0
    doChange = true
    isChangeDoing = true
    audioPostEvent_SystemUi(13, 15)
    _AudioPostEvent_SystemUiForXBOX(13, 15)
    runEffect:SetShow(true)
    btn_Apply:SetMonoTone(true)
    btn_Apply:SetEnable(false)
    btn_Apply:SetIgnore(true)
    Inventory_SetFunctor(WeaponChange_SetFilterIgnore, nil, nil, nil)
  end
  local meterialItemWrapper = getInventoryItemByType(selectedItemWhere, selectedItemSlotNo)
  local materialItemName = meterialItemWrapper:getStaticStatus():getName()
  local itemKey = meterialItemWrapper:get():getKey()
  local toItemWrapper = getExchangeItem(selectedItemWhere, selectedItemSlotNo, materialWhereType, materialSlotno)
  local resultItemName = toItemWrapper:getStaticStatus():getName()
  local _title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHANGEWEAPON_TITLE")
  local _contenet = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_CHANGEITEM_MESSAGEDESC", "materialItem", materialItemName, "resultItem", resultItemName)
  local messageBoxData = {
    title = _title,
    content = _contenet,
    functionYes = changeGo,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function WeaponChange_SetFilterIgnore()
  return true
end
function FromClient_WeaponChange(itemSSW)
  equipSlot:clearItem()
  avatarSlot:clearItem()
  selectedItemSlotNo = nil
  selectedItemWhere = nil
  elapsTime = 0
  doChange = false
  resultItemKey = itemSSW:get()._key
  avatarSlot:setItemByStaticStatus(itemSSW, 1, nil, nil, true)
  avatarSlot.icon:SetMonoTone(false)
end
function WeaponChange_IconOver(isShow, controlId)
  if isShow then
    local control
    if 0 == controlId then
      if nil == selectedItemWhere or nil == selectedItemSlotNo then
        return
      end
      control = equipSlot.icon
      local itemWrapper = getInventoryItemByType(selectedItemWhere, selectedItemSlotNo)
      Panel_Tooltip_Item_Show(itemWrapper, control, false, true, nil, nil, nil, nil, "WeaponChange", selectedItemSlotNo)
    elseif 1 == controlId then
      control = avatarSlot.icon
      local toItemWrapper = getExchangeItem(selectedItemWhere, selectedItemSlotNo, materialWhereType, materialSlotno)
      if nil ~= toItemWrapper then
        local itemSSW = toItemWrapper:getStaticStatus()
        Panel_Tooltip_Item_Show(itemSSW, control, true, false, nil, nil, nil)
      end
    else
      return
    end
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function WeaponChange_Close()
  if true == isChangeDoing then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHANGEITEM_DONOT_CLOSE"))
    return
  end
  equipSlot:clearItem()
  avatarSlot:clearItem()
  selectedItemSlotNo = nil
  selectedItemWhere = nil
  elapsTime = 0
  doChange = false
  resultItemKey = 0
  isChangeDoing = false
  btn_Apply:SetShow(true)
  btn_Close:SetShow(false)
  runEffect:SetShow(false)
  Inventory_SetFunctor(nil, nil, nil, nil)
  Panel_ChangeWeapon:SetShow(false, false)
end
function WeaponChange_updateTime(deltaTime)
  elapsTime = elapsTime + deltaTime
  if elapsTime > 3 then
    if nil == selectedItemSlotNo or nil == selectedItemWhere or false == doChange then
      return
    end
    runEffect:SetShow(false)
    avatarSlot.icon:AddEffect("UI_ItemEnchant01", false, -5, -5)
    exchangeItemToClass(selectedItemWhere, selectedItemSlotNo, materialWhereType, materialSlotno)
    doChange = false
    isChangeDoing = false
    btn_Apply:SetShow(false)
    btn_Close:SetShow(true)
  end
  if elapsTime > 4 then
    elapsTime = 0
  end
end
function FGlobal_WeaponChange_IsDoing()
  return isChangeDoing
end
function FromClient_UseItemExchangeToClassNotify()
  WeaponChange_Close()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHANGEWEAPON_SUCCESS_CHANGEITEM"))
end
Panel_ChangeWeapon:RegisterUpdateFunc("WeaponChange_updateTime")
registerEvent("FromClient_UseItemExchangeToClass", "FromClient_UseItemExchangeToClass")
registerEvent("FromClient_UseItemExchangeToClassNotify", "FromClient_UseItemExchangeToClassNotify")

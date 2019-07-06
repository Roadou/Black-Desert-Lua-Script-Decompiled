function PaGlobal_Barter:initialize()
  if true == PaGlobal_Barter._initialize then
    return
  end
  PaGlobal_Barter._isConsole = ToClient_isConsole()
  local _stc_titleBg = UI.getChildControl(Panel_Window_Barter, "Static_TitleBg")
  PaGlobal_Barter._ui._txt_titleName = UI.getChildControl(_stc_titleBg, "StaticText_TitleName")
  PaGlobal_Barter._ui._btn_close = UI.getChildControl(_stc_titleBg, "Button_Close")
  PaGlobal_Barter._ui.normal.stc_Group = UI.getChildControl(Panel_Window_Barter, "Static_NormalGroup")
  PaGlobal_Barter._ui.special.stc_Group = UI.getChildControl(Panel_Window_Barter, "Static_SpecialGroup")
  for i = 0, 1 do
    local control
    if 0 == i then
      control = PaGlobal_Barter._ui.normal
    elseif 1 == i then
      control = PaGlobal_Barter._ui.special
    end
    control.stc_TopBG = UI.getChildControl(control.stc_Group, "Static_TopBg")
    control.txt_CountTitle = UI.getChildControl(control.stc_TopBG, "StaticText_CountTitle")
    if 0 == i then
      control.txt_CountValue = UI.getChildControl(control.stc_TopBG, "StaticText_CountValue")
    end
    control.stc_ArrowDeco = UI.getChildControl(control.stc_Group, "Static_ArrowDeco")
    control.stc_MyItemSlot = UI.getChildControl(control.stc_Group, "Static_MyItmeSlot")
    control.stc_NpcItemSlot = UI.getChildControl(control.stc_Group, "Static_NpcItemSlot")
    control.txt_MyItemName = UI.getChildControl(control.stc_Group, "StaticText_MyItemName")
    control.txt_NpcItemName = UI.getChildControl(control.stc_Group, "StaticText_NpcItemName")
    control.stc_DescBg = UI.getChildControl(control.stc_Group, "Static_DescBg")
    control.txt_desc = UI.getChildControl(control.stc_DescBg, "StaticText_Desc")
    control.txt_desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    control.txt_desc:SetText(control.txt_desc:GetText())
  end
  if false == PaGlobal_Barter._isConsole then
    PaGlobal_Barter._ui.special.btn_Skip = UI.getChildControl(PaGlobal_Barter._ui.special.stc_Group, "Button_Skip")
    PaGlobal_Barter._ui.special.btn_Exchange = UI.getChildControl(PaGlobal_Barter._ui.special.stc_Group, "Button_Exchange")
    PaGlobal_Barter._ui.normal.btn_ExchangeOne = UI.getChildControl(PaGlobal_Barter._ui.normal.stc_Group, "Button_ExchangeOne")
    PaGlobal_Barter._ui.normal.btn_ExchangeContinue = UI.getChildControl(PaGlobal_Barter._ui.normal.stc_Group, "Button_ExchangeContinuance")
  else
  end
  PaGlobal_Barter:registEventHandler()
  PaGlobal_Barter:validate()
  PaGlobal_Barter._initialize = true
end
function PaGlobal_Barter:registEventHandler()
  if nil == Panel_Window_Barter then
    return
  end
  PaGlobal_Barter._ui._btn_close:addInputEvent("Mouse_LUp", "PaGlobal_Barter_Close()")
  PaGlobal_Barter._ui.special.btn_Skip:addInputEvent("Mouse_LUp", "HandleEventLUp_Bater_RequestSkip()")
  PaGlobal_Barter._ui.special.btn_Exchange:addInputEvent("Mouse_LUp", "HandleEventLUp_Barter_RequestDoBarter(true, true)")
  PaGlobal_Barter._ui.normal.btn_ExchangeOne:addInputEvent("Mouse_LUp", "HandleEventLUp_Barter_RequestDoBarter(false, true)")
  PaGlobal_Barter._ui.normal.btn_ExchangeContinue:addInputEvent("Mouse_LUp", "HandleEvnetLUp_Barter_SelectExchangeCount()")
  registerEvent("FromClient_SuccessDoBarter", "FromClient_Barter_SuccessDoBarter")
end
function PaGlobal_Barter:updateItemInfo()
  if nil == Panel_Window_Barter then
    return
  end
  local barterWrapper = ToClient_barterWrapper(PaGlobal_Barter._regionKey)
  local specialWrapper = ToClient_specialBarterWrapper(PaGlobal_Barter._regionKey)
  PaGlobal_Barter._ui.normal.stc_Group:SetShow(false)
  PaGlobal_Barter._ui.special.stc_Group:SetShow(false)
  local myType, npcType, control, wrapper
  if nil ~= specialWrapper then
    PaGlobal_Barter._selectType = PaGlobal_Barter._eSelectType.special
    myType = PaGlobal_Barter._eTooltipType.mySpecial
    npcType = PaGlobal_Barter._eTooltipType.npcSpecial
    control = PaGlobal_Barter._ui.special
    wrapper = specialWrapper
  elseif nil ~= barterWrapper then
    PaGlobal_Barter._selectType = PaGlobal_Barter._eSelectType.normal
    myType = PaGlobal_Barter._eTooltipType.myNormal
    npcType = PaGlobal_Barter._eTooltipType.npcNormal
    control = PaGlobal_Barter._ui.normal
    wrapper = barterWrapper
    local currentCount = wrapper:getExchangeCurrentCount()
    local maxCount = wrapper:getExchangeMaxCount()
    PaGlobal_Barter._ui.normal.txt_CountValue:SetText(tostring(maxCount - currentCount) .. " / " .. tostring(maxCount))
  else
    return false
  end
  control.stc_Group:SetShow(true)
  local myItemKey = wrapper:getFromItemEnchantKey()
  if nil == myItemKey then
    return
  end
  if nil == PaGlobal_Barter._slot[myType] then
    PaGlobal_Barter._slot[myType] = PaGlobal_Barter:createSlot(control.stc_MyItemSlot, 1)
  end
  local myItemSSW = getItemEnchantStaticStatus(myItemKey)
  PaGlobal_Barter._slot[myType]:setItemByStaticStatus(myItemSSW, wrapper:getFromItemCount())
  control.txt_MyItemName:SetText(myItemSSW:getName())
  control.stc_MyItemSlot:addInputEvent("Mouse_On", "HandleEventOn_Barter_ItemTooltipShow(" .. myType .. ")")
  control.stc_MyItemSlot:addInputEvent("Mouse_Out", "HandleEventOn_Barter_ItemTooltipHide()")
  PaGlobal_Barter._cacheEnchantKey[myType] = wrapper:getFromItemEnchantKey()
  local npcItemKey = wrapper:getToItemEnchantKey()
  if nil == npcItemKey then
    return
  end
  if nil == PaGlobal_Barter._slot[npcType] then
    PaGlobal_Barter._slot[npcType] = PaGlobal_Barter:createSlot(control.stc_NpcItemSlot, 1)
  end
  local npcItemSSW = getItemEnchantStaticStatus(npcItemKey)
  PaGlobal_Barter._slot[npcType]:setItemByStaticStatus(npcItemSSW, wrapper:getToItemCount())
  control.txt_NpcItemName:SetText(npcItemSSW:getName())
  control.stc_NpcItemSlot:addInputEvent("Mouse_On", "HandleEventOn_Barter_ItemTooltipShow(" .. npcType .. ")")
  control.stc_NpcItemSlot:addInputEvent("Mouse_Out", "HandleEventOn_Barter_ItemTooltipHide()")
  PaGlobal_Barter._cacheEnchantKey[npcType] = wrapper:getToItemEnchantKey()
  PaGlobal_Barter._myItemCount = ToClient_InventoryGetItemCount(myItemKey)
  local isSpecial = wrapper:getFromItemCount() > PaGlobal_Barter._myItemCount and nil ~= specialWrapper
  local isNormal = wrapper:getFromItemCount() > PaGlobal_Barter._myItemCount and nil ~= barterWrapper
  PaGlobal_Barter._ui.special.btn_Skip:SetIgnore(isSpecial)
  PaGlobal_Barter._ui.special.btn_Exchange:SetIgnore(isSpecial)
  PaGlobal_Barter._ui.special.btn_Skip:SetMonoTone(isSpecial)
  PaGlobal_Barter._ui.special.btn_Exchange:SetMonoTone(isSpecial)
  PaGlobal_Barter._ui.normal.btn_ExchangeOne:SetIgnore(isNormal)
  PaGlobal_Barter._ui.normal.btn_ExchangeContinue:SetIgnore(isNormal)
  PaGlobal_Barter._ui.normal.btn_ExchangeOne:SetMonoTone(isNormal)
  PaGlobal_Barter._ui.normal.btn_ExchangeContinue:SetMonoTone(isNormal)
  return true
end
function PaGlobal_Barter:setWhereType(whereType)
  if nil == Panel_Window_Barter then
    return
  end
  if nil ~= whereType then
    PaGlobal_Barter._itemWhereType = whereType
  end
end
function PaGlobal_Barter:createSlot(parent, index)
  local slot = {}
  SlotItem.new(slot, "itemIcon", index, parent, PaGlobal_Barter._slotConfig)
  slot:createChild()
  slot.icon:SetPosX(0)
  slot.icon:SetPosY(0)
  slot.icon:SetShow(true)
  slot.icon:SetIgnore(true)
  return slot
end
function PaGlobal_Barter:clearData()
  for k, v in pairs(PaGlobal_Barter._eTooltipType) do
    if nil ~= PaGlobal_Barter._slot[k] then
      PaGlobal_Barter._slot[k]:clearItem()
    end
    PaGlobal_Barter._cacheEnchantKey[k] = ItemEnchantKey(0)
  end
  PaGlobal_Barter._regionKey = RegionKey(0)
  PaGlobal_Barter._actorKey = nil
  PaGlobal_Barter._myItemCount = -1
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_Barter:prepareOpen()
  if false == _ContentsGroup_Barter then
    return
  end
  if nil == Panel_Window_Barter then
    return
  end
  if false == PaGlobal_Barter:updateItemInfo() then
    PaGlobal_Barter:clearData()
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoBarterInfoNotExist"))
    return
  end
  PaGlobal_Barter:open()
end
function PaGlobal_Barter:open()
  if false == _ContentsGroup_Barter then
    return
  end
  if nil == Panel_Window_Barter then
    return
  end
  Panel_Window_Barter:SetShow(true)
end
function PaGlobal_Barter:prepareClose()
  if nil == Panel_Window_Barter then
    return
  end
  PaGlobal_Barter:clearData()
  PaGlobal_Barter._itemWhereType = nil
  PaGlobal_Barter:close()
end
function PaGlobal_Barter:close()
  if nil == Panel_Window_Barter then
    return
  end
  Panel_Window_Barter:SetShow(false)
end
function PaGlobal_Barter:update()
  if nil == Panel_Window_Barter then
    return
  end
end
function PaGlobal_Barter:validate()
  if nil == Panel_Window_Barter then
    return
  end
  PaGlobal_Barter._ui._txt_titleName:isValidate()
  PaGlobal_Barter._ui._btn_close:isValidate()
  PaGlobal_Barter._ui.normal.stc_Group:isValidate()
  PaGlobal_Barter._ui.special.stc_Group:isValidate()
  for i = 0, 1 do
    local control
    if 0 == i then
      control = PaGlobal_Barter._ui.normal
      control.txt_CountValue:isValidate()
    elseif 1 == i then
      control = PaGlobal_Barter._ui.special
    end
    control.stc_TopBG:isValidate()
    control.txt_CountTitle:isValidate()
    control.stc_ArrowDeco:isValidate()
    control.stc_MyItemSlot:isValidate()
    control.stc_NpcItemSlot:isValidate()
    control.txt_MyItemName:isValidate()
    control.txt_NpcItemName:isValidate()
    control.stc_DescBg:isValidate()
    control.txt_desc:isValidate()
  end
  PaGlobal_Barter._ui.special.btn_Skip:isValidate()
  PaGlobal_Barter._ui.special.btn_Exchange:isValidate()
  PaGlobal_Barter._ui.normal.btn_ExchangeOne:isValidate()
  PaGlobal_Barter._ui.normal.btn_ExchangeContinue:isValidate()
end

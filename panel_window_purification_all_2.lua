function PaGlobalFunc_Purification_All_Open()
  if nil == Panel_Purification_All and true == Panel_Purification_All:GetShow() then
    return
  end
  PaGlobal_Purification_All:prepareOpen()
end
function HandleEventLUp_Purification_All_Close()
  if nil == Panel_Purification_All and false == Panel_Purification_All:GetShow() then
    return
  end
  PaGlobal_Purification_All:prepareClose()
end
function HandleEventRUp_Purification_All_InvenSlotRClick(slotNo, itemWrapper, count, invenType)
  if nil == Panel_Purification_All then
    return
  end
  local tempKey = itemWrapper:get():getKey()
  local staticStatus = itemWrapper:getStaticStatus()
  if nil == staticStatus or true == PaGlobal_Purification_All._isAniStart then
    return
  end
  PaGlobal_Purification_All._itemSlotBg_Icon:setItemByStaticStatus(staticStatus, Defines.s64_const.s64_1)
  PaGlobal_Purification_All._fromSlotIdx = slotNo
  PaGlobal_Purification_All._fromWhereType = invenType
  PaGlobal_Purification_All._fromSlotOn = true
  PaGlobal_Purification_All._resultSlotOn = false
  PaGlobal_Purification_All._resultSlotIdx = -1
  PaGlobal_Purification_All._resultWhereType = -1
  local prevStatic = staticStatus:getPrevItemEnchantStaticStatus()
  PaGlobal_Purification_All._resultSlotBg_Icon:clearItem()
  if nil ~= prevStatic then
    PaGlobal_Purification_All._resultSlotBg_Icon:setItemByStaticStatus(prevStatic, Defines.s64_const.s64_1)
    PaGlobal_Purification_All._ui._stc_ResultSlotBg:SetMonoTone(true)
  end
end
function FromClient_Purification_All_MoneyUpdate()
  if nil == Panel_Purification_All then
    return
  end
  PaGlobal_Purification_All:moneyUpdate()
end
function HandleEventLUp_Purification_All_CheckMoneyButton(value)
  if nil == Panel_Purification_All and false == Panel_Purification_All:GetShow() then
    return
  end
  PaGlobal_Purification_All:checkMoneyButton(value)
end
function HandleEventLUp_Purification_All_RequestPurification()
  if nil == Panel_Purification_All and false == Panel_Purification_All:GetShow() then
    return
  end
  PaGlobal_Purification_All:requestPurification()
end
function PaGlobalFunc_Purification_All_RequestPurificationAni(delta)
  if nil == Panel_Purification_All and false == Panel_Purification_All:GetShow() then
    return
  end
  if false == PaGlobal_Purification_All._isAniStart then
    return
  end
  PaGlobal_Purification_All._ui._btn_CheckAniSkip:SetIgnore(true)
  PaGlobal_Purification_All._ui._btn_Radio_Inven:SetIgnore(true)
  PaGlobal_Purification_All._ui._btn_Radio_Ware:SetIgnore(true)
  PaGlobal_Purification_All._delta_ani_time = PaGlobal_Purification_All._delta_ani_time + delta
  local skipCheck = false
  if true == PaGlobal_Purification_All._ui._btn_CheckAniSkip:IsCheck() then
    skipCheck = true
  end
  if PaGlobal_Purification_All._CONST_ANI_TIME < PaGlobal_Purification_All._delta_ani_time or true == skipCheck then
    PaGlobal_Purification_All._delta_ani_time = 0
    ToClient_WeakenEncantByNpc(PaGlobal_Purification_All._fromWhereType, PaGlobal_Purification_All._fromSlotIdx, PaGlobal_Purification_All._moneyWhereType)
    if false == PaGlobal_Purification_All._isConsole then
      PaGlobal_Purification_All._ui._btn_Purify_Pc:SetIgnore(false)
    end
    PaGlobal_Purification_All._resultSlotIdx = PaGlobal_Purification_All._fromSlotIdx
    PaGlobal_Purification_All._resultWhereType = PaGlobal_Purification_All._fromWhereType
    PaGlobal_Purification_All._isAniStart = false
    Panel_Purification_All:ClearUpdateLuaFunc()
  end
end
function PaGlobalFunc_Purification_All_InventoryFilter(slotNo, notUse_itemWrappers, whereType)
  if nil == Panel_Purification_All then
    return
  end
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  if itemWrapper:isWeakenEnchantItem() then
    return false
  else
    return true
  end
end
function HandleEventOnOut_Purification_All_AniButtonTooltipPC(isShow)
  if nil == Panel_Purification_All and false == Panel_Purification_All:GetShow() and false == PaGlobal_Purification_All._isConsole then
    return
  end
  if true == isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_PURIFICATION_TOOLTIP_NAME")
    local desc = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SKIPENCHANT_TOOLTIP_DESC_CAPHRAS")
    TooltipSimple_Show(PaGlobal_Purification_All._ui._btn_CheckAniSkip, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function HandleEventOnOut_Purification_All_ShowToolTipPC(isShow, idx)
  if nil == Panel_Purification_All and false == PaGlobal_Purification_All._isConsole then
    return
  end
  if false == isShow then
    Panel_Tooltip_Item_hideTooltip()
    return
  elseif 0 == idx then
    if false == PaGlobal_Purification_All._fromSlotOn then
      return
    end
    local itemWrapper = getInventoryItemByType(PaGlobal_Purification_All._fromWhereType, PaGlobal_Purification_All._fromSlotIdx)
    Panel_Tooltip_Item_SetPosition(0, PaGlobal_Purification_All._ui._stc_ItemSlotBg, "Purification")
    Panel_Tooltip_Item_Show(itemWrapper, Panel_Purification_All, false, true, nil)
  else
    if false == PaGlobal_Purification_All._resultSlotOn then
      return
    end
    local itemWrapper = getInventoryItemByType(PaGlobal_Purification_All._resultWhereType, PaGlobal_Purification_All._resultSlotIdx)
    Panel_Tooltip_Item_SetPosition(0, PaGlobal_Purification_All._ui._stc_ResultSlotBg, "Purification")
    Panel_Tooltip_Item_Show(itemWrapper, Panel_Purification_All, false, true, nil)
  end
end
function FromClient_Purification_All_Resize()
  if nil == Panel_Purification_All then
    return
  end
  PaGlobal_Purification_All:resize()
end
function HandleEventRUp_Purification_All_DataClear()
  if nil == Panel_Purification_All and false == Panel_Purification_All:GetShow() then
    return
  end
  if true == PaGlobal_Purification_All._isAniStart then
    return
  end
  PaGlobal_Purification_All:dataClear()
end
function FromClient_Purification_All_EnchantSuccess()
  if nil == Panel_Purification_All then
    return
  end
  PaGlobal_Purification_All:audioPostEvent(5, 16, PaGlobal_Purification_All._isConsole)
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PURIFICATION_SUCCESS"))
  PaGlobal_Purification_All._fromSlotOn = false
  PaGlobal_Purification_All._fromSlotIdx = -1
  PaGlobal_Purification_All._fromWhereType = -1
  PaGlobal_Purification_All._resultSlotOn = true
  PaGlobal_Purification_All._itemSlotBg_Icon:clearItem()
  PaGlobal_Purification_All._resultSlotBg_Icon:clearItem()
  PaGlobal_Purification_All._ui._stc_ResultSlotBg:SetMonoTone(false)
  PaGlobal_Purification_All._ui._btn_CheckAniSkip:SetIgnore(false)
  PaGlobal_Purification_All._ui._btn_Radio_Inven:SetIgnore(false)
  PaGlobal_Purification_All._ui._btn_Radio_Ware:SetIgnore(false)
  PaGlobal_Purification_All._ui._btn_Purify_Pc:SetIgnore(false)
  PaGlobal_Purification_All._ui._btn_Purify_Pc:SetMonoTone(false)
  local itemWrapper = getInventoryItemByType(PaGlobal_Purification_All._resultWhereType, PaGlobal_Purification_All._resultSlotIdx)
  local staticStatus = itemWrapper:getStaticStatus()
  PaGlobal_Purification_All._resultSlotBg_Icon:setItemByStaticStatus(staticStatus, Defines.s64_const.s64_1)
  FromClient_Purification_All_MoneyUpdate()
end

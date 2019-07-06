function PaGlobalFunc_Barter_ShowTooltip(regionKeyRaw, index)
  local normalBarter, panel, itemSSW
  normalBarter = ToClient_barterWrapperRaw(regionKeyRaw)
  if nil == normalBarter then
    return
  end
  panel = PaGlobal_WorldMapBarterInfo._panelList[regionKeyRaw]
  if nil == panel then
    return
  end
  if 0 == index then
    itemSSW = getItemEnchantStaticStatus(normalBarter:getFromItemEnchantKey())
  else
    itemSSW = getItemEnchantStaticStatus(normalBarter:getToItemEnchantKey())
  end
  if nil == itemSSW then
    return
  end
  Panel_Tooltip_Item_Show(itemSSW, panel, true, false)
end
function PaGlobalFunc_Barter_HideTooltip()
  Panel_Tooltip_Item_hideTooltip()
end
function FromClient_InitBarterInfo(barterUI, regionKey)
  if nil == Panel_Worldmap_BarterInfo then
    return
  end
  local normalBarter = ToClient_barterWrapper(regionKey)
  local specialBarter = ToClient_specialBarterWrapper(regionKey)
  local uiNormal = UI.getChildControl(barterUI, "Static_Normal")
  local nMySlotBG = UI.getChildControl(uiNormal, "Static_MyItemBG")
  local nNpcSlotBG = UI.getChildControl(uiNormal, "Static_NpcItemBG")
  local uiSpecial = UI.getChildControl(barterUI, "Static_Special")
  if nil == normalBarter then
    barterUI:SetShow(false)
  else
    barterUI:SetShow(true)
    local slot = {_fromSlot = nil, _toSlot = nil}
    local itemSSW
    slot._fromSlot = PaGlobal_WorldMapBarterInfo:createSlot(nMySlotBG, 0)
    itemSSW = getItemEnchantStaticStatus(normalBarter:getFromItemEnchantKey())
    slot._fromSlot:setItemByStaticStatus(itemSSW, normalBarter:getFromItemCount())
    slot._fromSlot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Barter_ShowTooltip(" .. tostring(regionKey:get()) .. ", 0)")
    slot._fromSlot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_Barter_HideTooltip( )")
    slot._toSlot = PaGlobal_WorldMapBarterInfo:createSlot(nNpcSlotBG, 1)
    itemSSW = getItemEnchantStaticStatus(normalBarter:getToItemEnchantKey())
    slot._toSlot:setItemByStaticStatus(itemSSW, normalBarter:getToItemCount())
    slot._toSlot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Barter_ShowTooltip(" .. tostring(regionKey:get()) .. ", 1)")
    slot._toSlot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_Barter_HideTooltip( )")
    PaGlobal_WorldMapBarterInfo._panelList[regionKey:get()] = barterUI
    uiNormal:SetShow(true)
  end
  if nil == specialBarter then
    uiSpecial:SetShow(false)
  else
    uiSpecial:SetShow(true)
  end
end

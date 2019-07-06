function FromClient_Itemwarp_UseNotify(whereType, slotNo, regionKey)
  PaGlobal_Itemwarp:itemUseNotify(whereType, slotNo, regionKey)
end
function HandleEventLUp_Itemwarp_GotoSelectTown(regionKey)
  PaGlobal_Itemwarp:gotoSelectTown(regionKey)
end
function FromClient_Itemwarp_UseNotify(whereType, slotNo, regionKey)
  PaGlobal_Itemwarp:itemUseNotify(whereType, slotNo, regionKey)
end
function ItemWarp_SetectTown(regionIndex)
  local prevSelectkey = PaGlobal_Itemwarp._selectTownKey
  PaGlobal_Itemwarp._selectTownKey = regionIndex
  PaGlobal_Itemwarp._ui.list2_Town:requestUpdateByKey(toInt64(0, regionIndex))
  PaGlobal_Itemwarp._ui.list2_Town:requestUpdateByKey(toInt64(0, prevSelectkey))
end
function Panel_ItemWarp_Close()
  PaGlobal_Itemwarp:prepareClose()
end
function Panel_ItemWarp_ShowAni()
  Panel_ItemWarp:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_ItemWarp, 0, 0.3)
end
function Panel_ItemWarp_HideAni()
  local ani1 = UIAni.AlphaAnimation(0, Panel_ItemWarp, 0, 0.2)
  ani1:SetHideAtEnd(true)
end
Panel_ItemWarp:RegisterShowEventFunc(true, "Panel_ItemWarp_ShowAni()")
Panel_ItemWarp:RegisterShowEventFunc(false, "Panel_ItemWarp_HideAni()")

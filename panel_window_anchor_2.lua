function HandleEventLUp_Anchor_SelectType(eSelectType)
  if eSelectType == PaGlobal_Anchor._eSelectButtonType.sailor then
    return
  elseif eSelectType == PaGlobal_Anchor._eSelectButtonType.barter then
    PaGlobal_Barter._itemWhereType = CppEnums.ItemWhereType.eServantInventory
    PaGlobal_Barter_Open(PaGlobal_Anchor._actorKey, PaGlobal_Anchor._regionKey)
  else
    return
  end
end
function FromClient_UpdateNearBarterNPC(isShow, actorKey, regionKey)
  if nil == Panel_Widget_ServantButton then
    return
  end
  Panel_Widget_ServantButton:SetShow(isShow)
  if true == isShow then
    PaGlobal_Anchor._actorKey = actorKey
    PaGlobal_Anchor._regionKey = regionKey
  else
    PaGlobal_Anchor:prepareClose()
    PaGlobal_Barter_Close()
  end
end
function PaGlobal_Anchor_FromClient_RideOff()
  Panel_Widget_ServantButton:SetShow(false)
  PaGlobal_Anchor:prepareClose()
  PaGlobal_Barter_Close()
end
function PaGloabl_Anchor_ShowAni()
  if nil == Panel_Window_Anchor then
    return
  end
end
function PaGloabl_Anchor_HideAni()
  if nil == Panel_Window_Anchor then
    return
  end
end

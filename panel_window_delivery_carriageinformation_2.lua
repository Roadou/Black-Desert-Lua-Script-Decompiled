function HandleEventMO_DeliveryCarriageInformation_ShowItemTooltip(idx, isOn)
  UI.ASSERT_NAME(nil ~= idx, "HandleEventMO_DeliveryCarriageInformation_ShowItemTooltip idx\234\176\128 nil", "\234\185\128\236\157\152\236\167\132")
  UI.ASSERT_NAME(nil ~= isOn, "HandleEventMO_DeliveryCarriageInformation_ShowItemTooltip isOn\234\176\128 nil", "\234\185\128\236\157\152\236\167\132")
  Panel_Tooltip_Item_Show_GeneralNormal(idx, "DeliveryCarriageInformation", isOn)
end
function HandleEventScroll_DeliveryCarriageInformation_UpdateSlot(isScrollUp)
  UI.ASSERT_NAME(nil ~= isScrollUp, "HandleEventScroll_DeliveryCarriageInformation_UpdateSlot isScrollUp nil", "\234\185\128\236\157\152\236\167\132")
  if nil == Panel_Window_Delivery_CarriageInformation then
    return
  end
  local deliveryList = ToClient_NewDeliveryGetDelivererByObjectId(PaGlobal_CarriageInformation._objectID)
  if nil == deliveryList then
    return
  end
  local deliveryCount = deliveryList:getDeliveryItemCount()
  PaGlobal_CarriageInformation.startSlotNo = UIScroll.ScrollEvent(PaGlobal_CarriageInformation._ui.scroll, isScrollUp, PaGlobal_CarriageInformation.config.slotCount, deliveryCount, PaGlobal_CarriageInformation.startSlotNo, 1)
  PaGlobal_CarriageInformation:updateSlot()
end
function DeliveryCarriageInformationWindow_Open(objectID)
  if nil == Panel_Window_Delivery_CarriageInformation then
    return
  end
  PaGlobal_CarriageInformation:prepareOpen(objectID)
end
function DeliveryCarriageInformationWindow_Close()
  if nil == Panel_Window_Delivery_CarriageInformation then
    return
  end
  PaGlobal_CarriageInformation:prepareClose()
end
function PaGlobal_DeliveryCarriageInformation_ShowAni()
  if nil == Panel_Window_Delivery_CarriageInformation then
    return
  end
  local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
  Panel_Window_Delivery_CarriageInformation:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_Window_Delivery_CarriageInformation, 0, 0.15)
  local aniInfo1 = Panel_Window_Delivery_CarriageInformation:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_Window_Delivery_CarriageInformation:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_Delivery_CarriageInformation:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Window_Delivery_CarriageInformation:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_Delivery_CarriageInformation:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_Delivery_CarriageInformation:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function PaGlobal_DeliveryCarriageInformation_HideAni()
  if nil == Panel_Window_Delivery_CarriageInformation then
    return
  end
  Panel_Window_Delivery_CarriageInformation:ChangeSpecialTextureInfoName("")
  Panel_Window_Delivery_CarriageInformation:SetAlpha(1)
  UIAni.AlphaAnimation(0, Panel_Window_Delivery_CarriageInformation, 0, 0.1)
end

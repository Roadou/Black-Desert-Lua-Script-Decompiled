function DeliveryInformationWindow_Open()
  if nil == PaGlobal_DeliveryInformation then
    return
  end
  PaGlobal_DeliveryInformation:prepareOpen()
end
function DeliveryInformationWindow_Close()
  if nil == PaGlobal_DeliveryInformation then
    return
  end
  PaGlobal_DeliveryInformation:prepareClose()
end
function HandleEventLUp_DeliveryInformation_Refresh(_type)
  if nil == PaGlobal_DeliveryInformation then
    return
  end
  PaGlobal_DeliveryInformation.scrollIndex = 0
  PaGlobal_DeliveryInformation:updateSlot()
end
function HandleEventMO_DeliveryInformation_ShowDeliveryTime(idx, isOn)
  UI.ASSERT_NAME(nil ~= idx, "HandleEventMO_DeliveryInformation_ShowDeliveryTime idx nil", "\234\185\128\236\157\152\236\167\132")
  UI.ASSERT_NAME(nil ~= isOn, "HandleEventMO_DeliveryInformation_ShowDeliveryTime isOn nil", "\234\185\128\236\157\152\236\167\132")
  if false == isOn then
    TooltipSimple_Hide()
    return
  end
  local contents = PaGlobal_DeliveryInformation._ui.list2:GetContentByKey(toInt64(0, idx))
  if nil == contents then
    return
  end
  local deliveryInfo = ToClient_NewDeliveryListItemByIndex(idx)
  if nil == deliveryInfo then
    return
  end
  local registerTime = deliveryInfo.registerDate
  local deliveryTime = toInt64(0, deliveryInfo.deliveryTime)
  local currentTime = getServerUtc64()
  local control = UI.getChildControl(contents, "StaticText_List2_Destination")
  local name = PAGetString(Defines.StringSheet_RESOURCE, "WORLDMAP_WOKRPROGRESS_TXT_REMAINTIME")
  local desc = ""
  if currentTime < registerTime + deliveryTime then
    local leftTime = registerTime + deliveryTime - currentTime
    leftTime = Int64toInt32(leftTime)
    desc = Util.Time.timeFormatting_Minute(leftTime)
  else
    desc = PAGetString(Defines.StringSheet_RESOURCE, "DELIVERY_INFORMATION_BTN_COMPLETE")
  end
  TooltipSimple_Show(control, name, desc)
end
function InputMLOn_DeliveryInformation_RemainTimeTooltip(key, isTrue)
  if true == isTrue then
    local control = PaGlobal_DeliveryInformation._ui.list2
    local contents = control:GetContentByKey(toInt64(0, key))
    if nil ~= contents then
      local remainTime = UI.getChildControl(contents, "StaticText_CarriageNumber")
      TooltipSimple_Show(remainTime, "", remainTime:GetText())
    end
  else
    TooltipSimple_Hide()
  end
end
function HandleEventLUp_DeliveryInformation_CheckBox()
  PaGlobal_DeliveryInformation:updateSlot()
end
function PaGlobalFunc_DeliveryInformation_Receive(delivererIndex, itemIndex)
  UI.ASSERT_NAME(nil ~= delivererIndex, "PaGlobalFunc_DeliveryInformation_Receive delivererIndex nil", "\236\157\180\236\136\152\236\162\133")
  UI.ASSERT_NAME(nil ~= itemIndex, "PaGlobalFunc_DeliveryInformation_Receive itemIndex nil", "\236\157\180\236\136\152\236\162\133")
  local delivererInfo = ToClient_NewDeliveryGetDeliverer(delivererIndex)
  if nil == delivererInfo then
    return
  end
  local itemNo = delivererInfo:getDeliveryItemNo(itemIndex)
  ToClient_NewDeliveryItemRecieveReq(PaGlobal_DeliveryInformation.currentWaypointKey, itemNo:get())
end
function PaGlobalFunc_DeliveryInformation_ReceiveAll()
  ToClient_NewDeliveryItemRecieveAllReq(PaGlobal_DeliveryInformation.currentWaypointKey)
end
function PaGlobalFunc_DeliveryInformation_Cancel(delivererIndex, itemIndex)
  UI.ASSERT_NAME(nil ~= delivererIndex, "PaGlobalFunc_DeliveryInformation_Cancel delivererIndex nil", "\236\157\180\236\136\152\236\162\133")
  UI.ASSERT_NAME(nil ~= itemIndex, "PaGlobalFunc_DeliveryInformation_Cancel itemIndex nil", "\236\157\180\236\136\152\236\162\133")
  local delivererInfo = ToClient_NewDeliveryGetDeliverer(delivererIndex)
  if nil == delivererInfo then
    return
  end
  local itemNo = delivererInfo:getDeliveryItemNo(itemIndex)
  ToClient_NewDeliveryItemCancelReq(itemNo:get())
end
function HandleEventMO_DeliveryInformation_ItemTooltipShow(delivererIndex, itemIndex, isOn)
  UI.ASSERT_NAME(nil ~= delivererIndex, "HandleEventMO_DeliveryInformation_ItemTooltipShow delivererIndex nil", "\236\157\180\236\136\152\236\162\133")
  UI.ASSERT_NAME(nil ~= itemIndex, "HandleEventMO_DeliveryInformation_ItemTooltipShow itemIndex nil", "\236\157\180\236\136\152\236\162\133")
  UI.ASSERT_NAME(nil ~= isOn, "HandleEventMO_DeliveryInformation_ItemTooltipShow isOn nil", "\236\157\180\236\136\152\236\162\133")
  if false == isOn then
    Panel_Tooltip_Item_hideTooltip()
    return
  end
  local key = itemIndex * 10 + delivererIndex
  local contents = PaGlobal_DeliveryInformation._ui.list2:GetContentByKey(toInt64(0, key))
  if nil == contents then
    return
  end
  local itemIcon = UI.getChildControl(contents, "Static_List2_Slot")
  local delivererInfo = ToClient_NewDeliveryGetDeliverer(delivererIndex)
  if nil == delivererInfo then
    return
  end
  local itemNo = delivererInfo:getDeliveryItemNo(itemIndex)
  local itemWrapper = delivererInfo:getDeliveryItemWrapper(itemIndex)
  local itemSSW = itemWrapper:getStaticStatus()
  Panel_Tooltip_Item_Show(itemSSW, itemIcon, true, false, nil, nil, true, nil, "Delivery", itemNo:get())
end
function PaGlobalFunc_DeliveryInformation_Update(deltaTime)
  PaGlobal_DeliveryInformation._updateCurrentTime = PaGlobal_DeliveryInformation._updateCurrentTime + deltaTime
  if PaGlobal_DeliveryInformation._updateCurrentTime - PaGlobal_DeliveryInformation._updatePastTime < 1 then
    return
  end
  PaGlobal_DeliveryInformation._updatePastTime = PaGlobal_DeliveryInformation._updateCurrentTime
  local size = PaGlobal_DeliveryInformation._ui.list2:getSize()
  for ii = 0, size - 1 do
  end
end
function FromClient_DeliveryReceiveItemClear()
  if nil == PaGlobal_DeliveryInformation then
    return
  end
  PaGlobal_DeliveryInformation.scrollIndex = PaGlobal_DeliveryInformation._ui.list2:getCurrenttoIndex()
  PaGlobal_DeliveryInformation:updateSlot()
end
function DeliveryInformation_UpdateSlotData()
  if nil == Panel_Window_Delivery_Information then
    return
  end
  if false == Panel_Window_Delivery_Information:IsShow() then
    return
  end
  PaGlobal_DeliveryInformation._ui.list2:getElementManager():clearKey()
  PaGlobal_DeliveryInformation:updateSlot()
end
function FromClient_DeliveryInformation_InActiveDeleteButton(index)
  PaGlobal_DeliveryInformation:updateSlot()
end
function PaGlobal_DeliveryInformation_ShowAni()
  if nil == Panel_Window_Delivery_Information then
    return
  end
  Panel_Window_Delivery_Information:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_Window_Delivery_Information, 0.05, 0.15)
  local aniInfo1 = Panel_Window_Delivery_Information:addScaleAnimation(0, 0.08, __ePAUIAnimAdvance_CosHalfPI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1)
  aniInfo1.AxisX = Panel_Window_Delivery_Information:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_Delivery_Information:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = false
  local aniInfo2 = Panel_Window_Delivery_Information:addScaleAnimation(0.08, 0.15, __ePAUIAnimAdvance_CosHalfPI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_Delivery_Information:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_Delivery_Information:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = false
end
function PaGlobal_DeliveryInformation_HideAni()
  if nil == Panel_Window_Delivery_Information then
    return
  end
  Panel_Window_Delivery_Information:ChangeSpecialTextureInfoName("")
  Panel_Window_Delivery_Information:SetAlpha(1)
  UIAni.AlphaAnimation(0, Panel_Window_Delivery_Information, 0, 0.1)
end

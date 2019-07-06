function PaGlobalFunc_DeliveryInformationView_Update()
  if nil == Panel_Window_Delivery_InformationView then
    return
  end
  PaGlobal_InformationView._startSlotNo = 0
  PaGlobal_InformationView:update()
end
function DeliveryInformationView_Open()
  if nil == Panel_Window_Delivery_InformationView then
    return
  end
  PaGlobal_InformationView:prepareOpen()
end
function DeliveryInformationView_Close()
  if nil == Panel_Window_Delivery_InformationView then
    return
  end
  PaGlobal_InformationView:prepareClose()
end
function HandleEventLUp_DeliveryInformationView_Refresh()
  delivery_refreshClear()
  delivery_requsetList()
  if nil == Panel_Window_Delivery_InformationView then
    return
  end
  PaGlobal_InformationView._startSlotNo = 0
  PaGlobal_InformationView:update()
end
function HandleEventMO_DeliveryInformationView_TooltipShow(idx, isOn)
  UI.ASSERT_NAME(nil ~= idx, "HandleEventMO_DeliveryInformationView_TooltipShow idx nil", "\234\185\128\236\157\152\236\167\132")
  UI.ASSERT_NAME(nil ~= isOn, "HandleEventMO_DeliveryInformationView_TooltipShow isOn nil", "\234\185\128\236\157\152\236\167\132")
  if nil == Panel_Window_Delivery_InformationView then
    return
  end
  if false == isOn then
    Panel_Tooltip_Item_hideTooltip()
    return
  end
  local control = PaGlobal_InformationView._ui.list2
  local contents = control:GetContentByKey(toInt64(0, idx))
  if nil == contents then
    return
  end
  local delivererIndex = idx % 10
  local itemIndex = math.floor(idx / 10)
  local delivererInfo = ToClient_NewDeliveryGetDeliverer(delivererIndex)
  if nil == delivererInfo then
    return
  end
  local itemWrapper = delivererInfo:getDeliveryItemWrapper(itemIndex)
  if nil == itemWrapper then
    return
  end
  local itemNo = delivererInfo:getDeliveryItemNo(itemIndex)
  local itemIcon = UI.getChildControl(contents, "Static_List2_Slot")
  local itemSSW = itemWrapper:getStaticStatus()
  Panel_Tooltip_Item_Show(itemSSW, itemIcon, true, false, nil, nil, true, nil, "Delivery", itemNo:get())
end

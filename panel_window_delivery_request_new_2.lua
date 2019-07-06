function DeliveryRequestWindow_Open()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  PaGlobal_Delivery_Request:prepareOpen()
end
function DeliveryRequestWindow_Close()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  PaGlobal_Delivery_Request:prepareClose()
end
function HandleEventLUp_DeliveryRequest_ShowToWaypointKey()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  local waypointList = PaGlobal_Delivery_Request._ui.comboBox_Destination:GetListControl()
  waypointList:addInputEvent("Mouse_LUp", "HandleEventLUp_DeliveryRequest_SelectToWaypointKey()")
  PaGlobal_Delivery_Request._ui.comboBox_Destination:ToggleListbox()
end
function HandleEventLUp_DeliveryRequest_SelectToWaypointKey()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  local waypointKeyList = ToClient_NewDeliveryGetListWaypointKey(DeliveryInformation_WaypointKey())
  if nil ~= waypointKeyList then
    local size = waypointKeyList:size()
    local selectIndex = PaGlobal_Delivery_Request._ui.comboBox_Destination:GetSelectIndex()
    local waypoint = waypointKeyList:atPointer(selectIndex)
    if nil == waypoint then
      return
    end
    PaGlobal_Delivery_Request._ui.comboBox_Destination:SetSelectItemIndex(selectIndex)
    PaGlobal_Delivery_Request.selectWaypointKey = waypointKeyList:atPointer(selectIndex):getWaypointKey()
    PaGlobal_Delivery_Request._ui.comboBox_Destination:ToggleListbox()
    PaGlobal_Delivery_Request:update()
    PaGlobal_Delivery_Request:updateCarriage(PaGlobal_Delivery_Request.selectWaypointKey)
  end
end
function HandleEventLUp_DeliveryRequest_ShowToDeliverer()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  local carriageList = PaGlobal_Delivery_Request._ui.comboBox_Carriage:GetListControl()
  carriageList:addInputEvent("Mouse_LUp", "HandleEnvetLUp_DeliveryRequest_SelectToDeliverer()")
  PaGlobal_Delivery_Request._ui.comboBox_Carriage:ToggleListbox()
end
function HandleEnvetLUp_DeliveryRequest_SelectToDeliverer()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  local selectIndex = PaGlobal_Delivery_Request._ui.comboBox_Carriage:GetSelectIndex()
  local selectKey = PaGlobal_Delivery_Request._ui.comboBox_Carriage:GetSelectKey()
  local deliverer = ToClient_NewDeliveryGetWaitingDeliverer(selectKey)
  if nil == deliverer then
    return
  end
  PaGlobal_Delivery_Request._ui.comboBox_Carriage:SetSelectItemIndex(selectIndex)
  PaGlobal_Delivery_Request.selectDeliverer = selectKey
  PaGlobal_Delivery_Request._ui.comboBox_Carriage:ToggleListbox()
  PaGlobal_Delivery_Request:update()
end
function HandleEventLUp_DeliveryRequest_SendCheckNode()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  local packingItemCount = ToClient_NewDeliveryGetPackCount()
  if packingItemCount < 1 then
    return
  end
  local selectedDestination = PaGlobal_Delivery_Request._ui.comboBox_Destination:GetSelectIndex()
  local selectedCarriage = PaGlobal_Delivery_Request._ui.comboBox_Carriage:GetSelectIndex()
  if -1 == selectedDestination then
    local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
    local messageboxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_PLZSELECT_DESTINATION")
    local messageboxData = {
      title = messageboxTitle,
      content = messageboxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
    return
  elseif -1 == selectedCarriage then
    local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
    local messageboxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERYNEW_SELECT_CARRIAGE")
    local messageboxData = {
      title = messageboxTitle,
      content = messageboxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
    return
  end
  if false == ToClient_NewDeliveryIsLinkedWaypoint(DeliveryInformation_WaypointKey(), PaGlobal_Delivery_Request.selectWaypointKey) then
    local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_NOTLINKEDWAYPOINT_TITLE")
    local messageboxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_NOTLINKEDWAYPOINT_MSG")
    local messageboxData = {
      title = messageboxTitle,
      content = messageboxMemo,
      functionYes = PaGlobal_DeliveryRequest_Send,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
    return
  end
  PaGlobal_DeliveryRequest_Send()
end
function PaGlobal_DeliveryRequest_Send()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  local selectedCarriage = PaGlobal_Delivery_Request._ui.comboBox_Carriage:GetSelectKey()
  ToClient_NewDeliveryItemAddReq(DeliveryInformation_WaypointKey(), PaGlobal_Delivery_Request.selectWaypointKey, selectedCarriage)
end
function HandleEventRUp_DeliveryRequest_SlotRClick(slotNo)
  UI.ASSERT_NAME(nil ~= slotNo, "HandleEventRUp_DeliveryRequest_SlotRClick slotNo nil", "\236\157\180\236\136\152\236\162\133")
  if nil == Panel_Window_Delivery_Request then
    return
  end
  ToClient_NewDeliveryPopPack(slotNo)
  PaGlobal_Delivery_Request:update()
  FromClient_WarehouseUpdate()
end
function FromClient_DeliveryRequestItemClear()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  PaGlobal_Delivery_Request:update()
end
function FromClient_DeliveryItemState(state)
  UI.ASSERT_NAME(nil ~= state, "FromClient_DeliveryItemState state nil", "\234\185\128\236\157\152\236\167\132")
  if nil == Panel_Window_Delivery_Request then
    return
  end
  if 0 == state then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_DELIVERYITEMSTATE_WAIT"))
  elseif 1 == state then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_DELIVERYITEMSTATE_START"))
  elseif 2 == state then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_DELIVERYITEMSTATE_COMPLETE"))
  end
end
function PaGlobal_DeliveryRequest_ShowAni()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  local UI_color = Defines.Color
  Panel_Window_Delivery_Request:ChangeSpecialTextureInfoName("")
  Panel_Window_Delivery_Request:SetShowWithFade(__ePAUIAniType_FadeOut)
  local aniInfo1 = Panel_Window_Delivery_Request:addColorAnimation(0, 0.15, __ePAUIAnimAdvance_SinHalfPI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
function PaGlobal_DeliveryRequest_HideAni()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  UIAni.fadeInSCR_Down(Panel_Window_Delivery_Request)
end

function PaGlobal_Delivery_Request:initialize()
  if true == PaGlobal_Delivery_Request._initialize then
    return
  end
  Panel_Window_Delivery_Request:ActiveMouseEventEffect(true)
  Panel_Window_Delivery_Request:setMaskingChild(true)
  Panel_Window_Delivery_Request:setGlassBackground(true)
  PaGlobal_Delivery_Request._ui.slotBG = UI.getChildControl(Panel_Window_Delivery_Request, "Static_SlotBG")
  PaGlobal_Delivery_Request._ui.button_Close = UI.getChildControl(Panel_Window_Delivery_Request, "Button_Close")
  PaGlobal_Delivery_Request._ui._buttonQuestion = UI.getChildControl(Panel_Window_Delivery_Request, "Button_Question")
  PaGlobal_Delivery_Request._ui.rdo_send = UI.getChildControl(Panel_Window_Delivery_Request, "RadioButton_Send")
  PaGlobal_Delivery_Request._ui.button_Information = UI.getChildControl(Panel_Window_Delivery_Request, "Button_Cancel_Recieve")
  PaGlobal_Delivery_Request._ui.static_RequestBakcground = UI.getChildControl(Panel_Window_Delivery_Request, "Static_Sample_Background")
  PaGlobal_Delivery_Request._ui.staticGoldIcon = UI.getChildControl(Panel_Window_Delivery_Request, "StaticText_Gold_Icon_Total_Charge")
  PaGlobal_Delivery_Request._ui.staticText_WayPointPenalty = UI.getChildControl(Panel_Window_Delivery_Request, "StaticText_WayPointPenalty")
  PaGlobal_Delivery_Request._ui.staticText_Total_Title = UI.getChildControl(Panel_Window_Delivery_Request, "StaticText_Title_TotalCount")
  PaGlobal_Delivery_Request._ui.staticText_TotalCount = UI.getChildControl(Panel_Window_Delivery_Request, "StaticText_Value_Total_Count")
  PaGlobal_Delivery_Request._ui.staticText_TotalFee = UI.getChildControl(Panel_Window_Delivery_Request, "StaticText_Value_Total_Fee")
  PaGlobal_Delivery_Request._ui.staticText_TotalDeliverer = UI.getChildControl(Panel_Window_Delivery_Request, "StaticText_Value_CarriageCount")
  PaGlobal_Delivery_Request._ui.staticText_WeightCount = UI.getChildControl(Panel_Window_Delivery_Request, "StaticText_Value_WeighCount")
  PaGlobal_Delivery_Request._ui.button_Send = UI.getChildControl(Panel_Window_Delivery_Request, "Button_Send")
  PaGlobal_Delivery_Request._ui.comboBox_Carriage = UI.getChildControl(Panel_Window_Delivery_Request, "Combobox_Carriage")
  PaGlobal_Delivery_Request._ui.comboBox_Destination = UI.getChildControl(Panel_Window_Delivery_Request, "Combobox_Destination")
  PaGlobal_Delivery_Request._ui.stc_DestinationList = UI.getChildControl(PaGlobal_Delivery_Request._ui.comboBox_Destination, "Combobox_List")
  PaGlobal_Delivery_Request._ui.deliveryHelpBG = UI.getChildControl(Panel_Window_Delivery_Request, "Static_HelpBG")
  PaGlobal_Delivery_Request._ui.deliveryHelpDesc = UI.getChildControl(Panel_Window_Delivery_Request, "StaticText_HelpDesc")
  PaGlobal_Delivery_Request.config.slotRows = PaGlobal_Delivery_Request.config.slotCount / PaGlobal_Delivery_Request.config.slotCols
  for ii = 0, PaGlobal_Delivery_Request.config.slotCount - 1 do
    PaGlobal_Delivery_Request.slotbgs[ii] = UI.createControl(__ePAUIControl_Static, Panel_Window_Delivery_Request, "StaticSlotBG_" .. ii)
    CopyBaseProperty(PaGlobal_Delivery_Request._ui.slotBG, PaGlobal_Delivery_Request.slotbgs[ii])
    local slot = {}
    slot.slotNo = ii
    local row = math.floor(slot.slotNo / PaGlobal_Delivery_Request.config.slotCols)
    local col = slot.slotNo % PaGlobal_Delivery_Request.config.slotCols
    slot.panel = Panel_Window_Delivery_Request
    PaGlobal_Delivery_Request.slotbgs[ii]:SetPosX(PaGlobal_Delivery_Request.config.slotStartX + PaGlobal_Delivery_Request.config.slotGapX * col)
    PaGlobal_Delivery_Request.slotbgs[ii]:SetPosY(PaGlobal_Delivery_Request.config.slotStartY + PaGlobal_Delivery_Request.config.slotGapY * row)
    slot.base = {}
    SlotItem.new(slot.base, "ItemSlot_" .. slot.slotNo, slot.slotNo, PaGlobal_Delivery_Request.slotbgs[ii], PaGlobal_Delivery_Request.slotConfig)
    slot.base:createChild()
    slot.base.icon:SetVerticalMiddle()
    slot.base.icon:SetHorizonCenter()
    slot.base.icon:addInputEvent("Mouse_RUp", "HandleEventRUp_DeliveryRequest_SlotRClick(" .. ii .. ")")
    slot.base.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. ii .. ", \"DeliveryRequest\",true)")
    slot.base.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. ii .. ", \"DeliveryRequest\",false)")
    slot.base.icon:SetIgnore(false)
    slot.base.icon:SetShow(true)
    Panel_Tooltip_Item_SetPosition(ii, slot.base, "DeliveryRequest")
    PaGlobal_Delivery_Request.slots[ii] = slot
  end
  UI.deleteControl(PaGlobal_Delivery_Request._ui.slotBG)
  PaGlobal_Delivery_Request._ui.slotBG = nil
  Panel_Window_Delivery_Request:SetChildIndex(PaGlobal_Delivery_Request._ui.comboBox_Carriage, 999)
  Panel_Window_Delivery_Request:SetChildIndex(PaGlobal_Delivery_Request._ui.comboBox_Destination, 9999)
  PaGlobal_Delivery_Request._ui.comboBox_Carriage:setListTextHorizonCenter()
  PaGlobal_Delivery_Request._ui.comboBox_Destination:setListTextHorizonCenter()
  PaGlobal_Delivery_Request:registEventHandler()
  PaGlobal_Delivery_Request:validate()
  PaGlobal_Delivery_Request._initialize = true
end
function PaGlobal_Delivery_Request:registEventHandler()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  Panel_Window_Delivery_Request:RegisterShowEventFunc(true, "PaGlobal_DeliveryRequest_ShowAni()")
  Panel_Window_Delivery_Request:RegisterShowEventFunc(false, "PaGlobal_DeliveryRequest_HideAni()")
  PaGlobal_Delivery_Request._ui.button_Close:addInputEvent("Mouse_LUp", "DeliveryRequestWindow_Close()")
  PaGlobal_Delivery_Request._ui._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle(\"DeliveryRequest\")")
  PaGlobal_Delivery_Request._ui._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show(\"DeliveryRequest\", \"true\")")
  PaGlobal_Delivery_Request._ui._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show(\"DeliveryRequest\", \"false\")")
  PaGlobal_Delivery_Request._ui.button_Information:addInputEvent("Mouse_LUp", "DeliveryInformationWindow_Open()")
  PaGlobal_Delivery_Request._ui.comboBox_Destination:addInputEvent("Mouse_LUp", "HandleEventLUp_DeliveryRequest_ShowToWaypointKey()")
  PaGlobal_Delivery_Request._ui.comboBox_Carriage:addInputEvent("Mouse_LUp", "HandleEventLUp_DeliveryRequest_ShowToDeliverer()")
  PaGlobal_Delivery_Request._ui.button_Send:addInputEvent("Mouse_LUp", "HandleEventLUp_DeliveryRequest_SendCheckNode()")
  registerEvent("FromClient_MoveDeliveryItem", "FromClient_DeliveryItemState")
  registerEvent("FromClient_DeliveryRequestItemClear", "FromClient_DeliveryRequestItemClear")
end
function PaGlobal_Delivery_Request:prepareOpen()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  Warehouse_SetIgnoreMoneyButton(true)
  PaGlobal_Delivery_Request._ui.deliveryHelpDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_Delivery_Request._ui.deliveryHelpDesc:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_DELIVERY_HELPDESC"))
  PaGlobal_Delivery_Request._ui.deliveryHelpBG:SetSize(385, PaGlobal_Delivery_Request._ui.deliveryHelpDesc:GetTextSizeY() + 5)
  PaGlobal_Delivery_Request._ui.staticText_Total_Title:SetPosY(PaGlobal_Delivery_Request._ui.deliveryHelpBG:GetPosY() + PaGlobal_Delivery_Request._ui.deliveryHelpBG:GetSizeY() + 5)
  PaGlobal_Delivery_Request._ui.staticText_TotalCount:SetPosY(PaGlobal_Delivery_Request._ui.deliveryHelpBG:GetPosY() + PaGlobal_Delivery_Request._ui.deliveryHelpBG:GetSizeY() + 5)
  PaGlobal_Delivery_Request._ui.staticText_TotalFee:SetPosY(PaGlobal_Delivery_Request._ui.staticText_Total_Title:GetPosY() + PaGlobal_Delivery_Request._ui.staticText_Total_Title:GetSizeY())
  PaGlobal_Delivery_Request._ui.staticGoldIcon:SetPosY(PaGlobal_Delivery_Request._ui.staticText_Total_Title:GetPosY() + PaGlobal_Delivery_Request._ui.staticText_Total_Title:GetSizeY() + 3)
  PaGlobal_Delivery_Request._ui.rdo_send:SetCheck(true)
  DeliveryInformationWindow_Close()
  PaGlobal_Delivery_Request._ui.comboBox_Carriage:DeleteAllItem()
  PaGlobal_Delivery_Request._ui.comboBox_Carriage:AddItem(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_DELIVERER"))
  PaGlobal_Delivery_Request._ui.comboBox_Carriage:SetSelectItemIndex(0)
  PaGlobal_Delivery_Request._ui.comboBox_Destination:DeleteAllItem()
  PaGlobal_Delivery_Request._ui.comboBox_Destination:AddItem(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_SELECT_TO_REGION"))
  PaGlobal_Delivery_Request._ui.comboBox_Destination:SetSelectItemIndex(0)
  PaGlobal_Delivery_Request.selectWaypointKey = 0
  PaGlobal_Delivery_Request.selectDeliverer = -1
  ToClient_NewDeliveryClearPack()
  PaGlobal_Delivery_Request:clearSlot()
  PaGlobal_Delivery_Request:updateCarriage()
  PaGlobal_Delivery_Request:updateDestination()
  PaGlobal_Delivery_Request:update()
  PaGlobal_Delivery_Request:open()
  FGlobal_WarehouseTownListCheck()
end
function PaGlobal_Delivery_Request:open()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  if true == Panel_Window_Delivery_Request:GetShow() then
    return
  end
  Panel_Window_Delivery_Request:ChangeSpecialTextureInfoName("")
  Panel_Window_Delivery_Request:SetAlphaExtraChild(1)
  Panel_Window_Delivery_Request:SetShow(true, false)
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:increaseLayer(true)
    WorldMapPopupManager:push(Panel_Window_Delivery_Request, true)
  end
end
function PaGlobal_Delivery_Request:prepareClose()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  ToClient_NewDeliveryClearPack()
  if ToClient_WorldMapIsShow() then
    if Panel_Window_Delivery_Request:GetShow() then
      WorldMapPopupManager:pop()
    end
  elseif Panel_Window_Delivery_Request:GetShow() then
    Panel_Window_Delivery_Request:ChangeSpecialTextureInfoName("")
    Panel_Window_Delivery_Request:SetShow(false, false)
  end
  FromClient_WarehouseUpdate()
  FGlobal_WarehouseTownListCheck()
end
function PaGlobal_Delivery_Request:update()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  local delivererInfo
  local currentCount = 0
  if -1 ~= PaGlobal_Delivery_Request.selectDeliverer then
    delivererInfo = ToClient_NewDeliveryGetDeliverer(PaGlobal_Delivery_Request.selectDeliverer)
    if nil ~= delivererInfo then
      currentCount = delivererInfo:getDeliveryItemCount()
    end
  end
  local totalCount = 0
  local totalPrice = 0
  totalPrice = Int64toInt32(Toclient_NewDeliveryGetPackItemTotalPrice(DeliveryInformation_WaypointKey(), PaGlobal_Delivery_Request.selectWaypointKey))
  totalCount = currentCount + ToClient_NewDeliveryGetPackCount()
  PaGlobal_Delivery_Request._ui.staticText_TotalCount:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DELIVERYNEW_PACKINGCOUNT", "packingCount", tostring(totalCount), "totalCount", 20))
  PaGlobal_Delivery_Request._ui.staticText_TotalFee:SetText("" .. makeDotMoney(totalPrice))
  if 0 ~= PaGlobal_Delivery_Request.selectWaypointKey then
    if true == ToClient_NewDeliveryIsLinkedWaypoint(DeliveryInformation_WaypointKey(), PaGlobal_Delivery_Request.selectWaypointKey) then
      PaGlobal_Delivery_Request._ui.staticText_WayPointPenalty:SetShow(false)
    else
      PaGlobal_Delivery_Request._ui.staticText_WayPointPenalty:SetShow(true)
    end
  else
    PaGlobal_Delivery_Request._ui.staticText_WayPointPenalty:SetShow(false)
  end
  PaGlobal_Delivery_Request._ui.staticText_Total_Title:ComputePos()
  PaGlobal_Delivery_Request._ui.staticText_TotalCount:ComputePos()
  PaGlobal_Delivery_Request._ui.staticText_TotalFee:ComputePos()
  local selectedCarriageIndex = PaGlobal_Delivery_Request._ui.comboBox_Carriage:GetSelectIndex()
  local selectedCarriageKey = PaGlobal_Delivery_Request._ui.comboBox_Carriage:GetSelectKey()
  local maxCarriageWeight = ToClient_NewDeliveryGetMaxWeightPerCarriage()
  if -1 ~= selectedCarriageIndex then
    local remainWeight = ToClient_NewDeliveryGetRemainWeight(selectedCarriageKey)
    PaGlobal_Delivery_Request._ui.staticText_WeightCount:SetText(tostring(math.floor(remainWeight / 10000)) .. "/" .. tostring(maxCarriageWeight / 10000) .. " LT")
  else
    PaGlobal_Delivery_Request._ui.staticText_WeightCount:SetText("0/" .. tostring(maxCarriageWeight / 10000) .. " LT")
  end
  PaGlobal_Delivery_Request:clearSlot()
  for ii = 0, PaGlobal_Delivery_Request.config.slotCount - 1 do
    local itemWrapper = ToClient_NewDeliveryGetPackItemBySlotNo(ii)
    if nil ~= itemWrapper then
      PaGlobal_Delivery_Request.slots[ii].base:setItem(itemWrapper)
    end
  end
end
function PaGlobal_Delivery_Request:updateDestination()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  PaGlobal_Delivery_Request._ui.comboBox_Destination:DeleteAllItem()
  local waypointKeyList = ToClient_NewDeliveryGetListWaypointKey(DeliveryInformation_WaypointKey(), false)
  if nil ~= waypointKeyList then
    local size = waypointKeyList:size()
    if 0 == size then
      PaGlobal_Delivery_Request._ui.comboBox_Destination:SetSelectItemIndex(0)
      PaGlobal_Delivery_Request._ui.comboBox_Destination:AddItem(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_NOT_CONNECT_REGION"))
      return
    end
    for ii = 0, size - 1 do
      PaGlobal_Delivery_Request._ui.comboBox_Destination:AddItem(waypointKeyList:atPointer(ii):getName())
    end
  end
end
function PaGlobal_Delivery_Request:updateCarriage(destination)
  if nil == Panel_Window_Delivery_Request then
    return
  end
  local selectedCarriageIndex = PaGlobal_Delivery_Request._ui.comboBox_Carriage:GetSelectIndex()
  local selectedCarriageKey = PaGlobal_Delivery_Request._ui.comboBox_Carriage:GetSelectKey()
  PaGlobal_Delivery_Request._ui.comboBox_Carriage:DeleteAllItem()
  local size = ToClient_NewDeliveryGetDelivererCount()
  local usableCount = 0
  local isSaveSelected = true
  for ii = 0, size - 1 do
    local delivererInfo = ToClient_NewDeliveryGetWaitingDeliverer(ii)
    local isView = false
    if nil ~= delivererInfo then
      if 0 < delivererInfo:getDeliveryItemCount() and nil ~= destination then
        local nowToRegionKey = getRegionInfoByRegionKey(delivererInfo:getToRegionKey()):getRegionKey()
        local nowFromRegionKey = getRegionInfoByRegionKey(delivererInfo:getFromRegionKey()):getRegionKey()
        local regionKey = ToClient_getRegionInfoWrapperByWaypoint(PaGlobal_DeliveryInformation.currentWaypointKey):getRegionKey()
        local destRegionKey = ToClient_getRegionInfoWrapperByWaypoint(destination):getRegionKey()
        if nowToRegionKey == destRegionKey and regionKey == nowFromRegionKey then
          isView = true
        else
          local selectedDelivererInfo = ToClient_NewDeliveryGetWaitingDeliverer(selectedCarriageKey)
          if nil ~= selectedDelivererInfo and selectedDelivererInfo:getDeliveryIndex() == delivererInfo:getDeliveryIndex() and -1 ~= delivererInfo:getDeliveryIndex() then
            isSaveSelected = false
          end
        end
      else
        isView = true
      end
    end
    if true == isView then
      local str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DELIVERYNEW_NUMBEROF_CARRIAGE", "number", tostring(ii + 1))
      PaGlobal_Delivery_Request._ui.comboBox_Carriage:AddItemWithKey(str, ii)
      usableCount = usableCount + 1
    end
  end
  PaGlobal_Delivery_Request._ui.staticText_TotalDeliverer:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DELIVERYNEW_REMAIN_SENDCOUNT", "count", tostring(usableCount)))
  if 0 == usableCount then
    PaGlobal_Delivery_Request._ui.comboBox_Carriage:SetSelectItemIndex(-1)
    PaGlobal_Delivery_Request._ui.comboBox_Carriage:AddItem(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERYNEW_NOT_CARRIAGE"))
    PaGlobal_Delivery_Request._ui.comboBox_Carriage:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_DELIVERER"))
  elseif nil ~= destination and true == isSaveSelected then
    PaGlobal_Delivery_Request._ui.comboBox_Carriage:SetSelectItemIndex(selectedCarriageIndex)
  elseif false == isSaveSelected then
    PaGlobal_Delivery_Request._ui.comboBox_Carriage:SetSelectItemIndex(-1)
    PaGlobal_Delivery_Request._ui.comboBox_Carriage:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_DELIVERER"))
  end
end
function PaGlobal_Delivery_Request:clearSlot()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  for ii = 0, PaGlobal_Delivery_Request.config.slotCount - 1 do
    PaGlobal_Delivery_Request.slots[ii].base:clearItem()
  end
end
function DeliveryRequest_PushPackingItem(warehouseSlotNo, s64_count)
  UI.ASSERT_NAME(nil ~= warehouseSlotNo, "DeliveryRequest_PushPackingItem warehouseSlotNo nil", "\236\157\180\236\136\152\236\162\133")
  UI.ASSERT_NAME(nil ~= s64_count, "DeliveryRequest_PushPackingItem s64_count nil", "\236\157\180\236\136\152\236\162\133")
  if nil == Panel_Window_Delivery_Request then
    return
  end
  if s64_count < Defines.s64_const.s64_1 then
    return
  end
  local selectedCarriageIndex = PaGlobal_Delivery_Request._ui.comboBox_Carriage:GetSelectIndex()
  local selectedCarriageKey = PaGlobal_Delivery_Request._ui.comboBox_Carriage:GetSelectKey()
  if -1 == selectedCarriageIndex then
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
  warehouse_requestInfo(DeliveryInformation_WaypointKey())
  ToClient_NewDeliveryPushPack(selectedCarriageKey, warehouseSlotNo, s64_count)
  PaGlobal_Delivery_Request:update()
  FromClient_WarehouseUpdate()
end
function DeliveryRequest_UpdateRequestSlotData()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  PaGlobal_Delivery_Request:update()
end
function PaGlobalFunc_PanelDelivery_GetShow()
  if nil == Panel_Window_Delivery_Request or nil == Panel_Window_Delivery_Information then
    return false
  else
    Panel_Window_Delivery_Request:GetShow()
    Panel_Window_Delivery_Information:GetShow()
    return Panel_Window_Delivery_Request:GetShow() or Panel_Window_Delivery_Information:GetShow()
  end
end
function PaGlobal_Delivery_Request:validate()
  if nil == Panel_Window_Delivery_Request then
    return
  end
  PaGlobal_Delivery_Request._ui.button_Close:isValidate()
  PaGlobal_Delivery_Request._ui._buttonQuestion:isValidate()
  PaGlobal_Delivery_Request._ui.rdo_send:isValidate()
  PaGlobal_Delivery_Request._ui.button_Information:isValidate()
  PaGlobal_Delivery_Request._ui.static_RequestBakcground:isValidate()
  PaGlobal_Delivery_Request._ui.staticGoldIcon:isValidate()
  PaGlobal_Delivery_Request._ui.staticText_WayPointPenalty:isValidate()
  PaGlobal_Delivery_Request._ui.staticText_Total_Title:isValidate()
  PaGlobal_Delivery_Request._ui.staticText_TotalCount:isValidate()
  PaGlobal_Delivery_Request._ui.staticText_TotalFee:isValidate()
  PaGlobal_Delivery_Request._ui.staticText_WeightCount:isValidate()
  PaGlobal_Delivery_Request._ui.staticText_TotalDeliverer:isValidate()
  PaGlobal_Delivery_Request._ui.button_Send:isValidate()
  PaGlobal_Delivery_Request._ui.comboBox_Destination:isValidate()
  PaGlobal_Delivery_Request._ui.comboBox_Carriage:isValidate()
  PaGlobal_Delivery_Request._ui.deliveryHelpBG:isValidate()
  PaGlobal_Delivery_Request._ui.deliveryHelpDesc:isValidate()
end

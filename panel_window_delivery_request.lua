local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UCT = CppEnums.PA_UI_CONTROL_TYPE
Panel_Window_Delivery_Request:ActiveMouseEventEffect(true)
Panel_Window_Delivery_Request:setMaskingChild(true)
Panel_Window_Delivery_Request:setGlassBackground(true)
Panel_Window_Delivery_Request:RegisterShowEventFunc(true, "DeliveryRequestShowAni()")
Panel_Window_Delivery_Request:RegisterShowEventFunc(false, "DeliveryRequestHideAni()")
function DeliveryRequestShowAni()
  UIAni.fadeInSCR_Down(Panel_Window_Delivery_Request)
end
function DeliveryRequestHideAni()
  Panel_Window_Delivery_Request:ChangeSpecialTextureInfoName("")
  Panel_Window_Delivery_Request:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_Delivery_Request:addColorAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local deliveryRequest = {
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  config = {
    slotCount = 40,
    slotCols = 8,
    slotRows = 0,
    slotStartX = 25,
    slotStartY = 280,
    slotGapX = 55,
    slotGapY = 55,
    fontColor = UI_color.C_FFFFFFFF
  },
  slotBG = UI.getChildControl(Panel_Window_Delivery_Request, "Static_SlotBG"),
  button_Close = UI.getChildControl(Panel_Window_Delivery_Request, "Button_Close"),
  _buttonQuestion = UI.getChildControl(Panel_Window_Delivery_Request, "Button_Question"),
  rdo_send = UI.getChildControl(Panel_Window_Delivery_Request, "RadioButton_Send"),
  button_Information = UI.getChildControl(Panel_Window_Delivery_Request, "Button_Cancel_Recieve"),
  static_RequestBakcground = UI.getChildControl(Panel_Window_Delivery_Request, "Static_Sample_Background"),
  staticGoldIcon = UI.getChildControl(Panel_Window_Delivery_Request, "StaticText_Gold_Icon_Total_Charge"),
  staticText_WayPointPenalty = UI.getChildControl(Panel_Window_Delivery_Request, "StaticText_WayPointPenalty"),
  staticText_Total_Title = UI.getChildControl(Panel_Window_Delivery_Request, "StaticText_Title_TotalCount"),
  staticText_TotalCount = UI.getChildControl(Panel_Window_Delivery_Request, "StaticText_Value_Total_Count"),
  staticText_TotalFee = UI.getChildControl(Panel_Window_Delivery_Request, "StaticText_Value_Total_Fee"),
  button_Send = UI.getChildControl(Panel_Window_Delivery_Request, "Button_Send"),
  comboBox_Destination = UI.getChildControl(Panel_Window_Delivery_Request, "Combobox_Destination"),
  comboBox_Carriage = UI.getChildControl(Panel_Window_Delivery_Request, "Combobox_Carriage"),
  deliveryHelpBG = UI.getChildControl(Panel_Window_Delivery_Request, "Static_HelpBG"),
  deliveryHelpDesc = UI.getChildControl(Panel_Window_Delivery_Request, "StaticText_HelpDesc"),
  slots = Array.new(),
  slotbgs = Array.new(),
  selectWaypointKey = 0,
  selectCarriageKeyRaw = 0,
  distance = 0
}
function deliveryRequest:registMessageHandler()
  registerEvent("FromClient_MoveDeliveryItem", "FromClient_DeliveryItemState")
end
function deliveryRequest:registEventHandler()
  self.button_Close:addInputEvent("Mouse_LUp", "DeliveryRequestWindow_Close()")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"DeliveryRequest\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"DeliveryRequest\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"DeliveryRequest\", \"false\")")
  self.button_Information:addInputEvent("Mouse_LUp", "ShowInformationWindow()")
  self.comboBox_Destination:setListTextHorizonCenter()
  self.comboBox_Destination:addInputEvent("Mouse_LUp", "DeliveryRequest_ShowToWaypointKey()")
  self.comboBox_Carriage:setListTextHorizonCenter()
  self.comboBox_Carriage:addInputEvent("Mouse_LUp", "DeliveryRequest_ShowToCarriage()")
  self.button_Send:addInputEvent("Mouse_LUp", "DeliveryRequest_Send_CheckNode()")
end
function deliveryRequest:init()
  UI.ASSERT(nil ~= self.button_Close and "number" ~= type(self.button_Close), "Button_Close")
  UI.ASSERT(nil ~= self.button_Information and "number" ~= type(self.button_Information), "Button_Cancel_Recieve")
  UI.ASSERT(nil ~= self.static_RequestBakcground and "number" ~= type(self.static_RequestBakcground), "Static_Sample_Background")
  UI.ASSERT(nil ~= self.staticText_TotalCount and "number" ~= type(self.staticText_TotalCount), "StaticText_Value_Total_Count")
  UI.ASSERT(nil ~= self.staticText_TotalFee and "number" ~= type(self.staticText_TotalFee), "StaticText_Value_Total_Fee")
  UI.ASSERT(nil ~= self.button_Send and "number" ~= type(self.button_Send), "Button_Send")
  UI.ASSERT(nil ~= self.comboBox_Destination and "number" ~= type(self.comboBox_Destination), "Combobox_Destination")
  UI.ASSERT(nil ~= self.comboBox_Carriage and "number" ~= type(self.comboBox_Carriage), "Combobox_Carriage")
  self.config.slotRows = self.config.slotCount / self.config.slotCols
  for ii = 0, self.config.slotCount - 1 do
    self.slotbgs[ii] = UI.createControl(UCT.PA_UI_CONTROL_STATIC, Panel_Window_Delivery_Request, "StaticSlotBG_" .. ii)
    CopyBaseProperty(self.slotBG, self.slotbgs[ii])
    local slot = {}
    slot.slotNo = ii
    local row = math.floor(slot.slotNo / self.config.slotCols)
    local col = slot.slotNo % self.config.slotCols
    slot.panel = Panel_Window_Delivery_Request
    self.slotbgs[ii]:SetPosX(self.config.slotStartX + self.config.slotGapX * col)
    self.slotbgs[ii]:SetPosY(self.config.slotStartY + self.config.slotGapY * row)
    slot.base = {}
    SlotItem.new(slot.base, "ItemSlot_" .. slot.slotNo, slot.slotNo, self.slotbgs[ii], self.slotConfig)
    slot.base:createChild()
    slot.base.icon:SetVerticalMiddle()
    slot.base.icon:SetHorizonCenter()
    slot.base.icon:addInputEvent("Mouse_RUp", "DeliveryRequest_SlotRClick(" .. ii .. ")")
    slot.base.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. ii .. ", \"DeliveryRequest\",true)")
    slot.base.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. ii .. ", \"DeliveryRequest\",false)")
    slot.base.icon:SetIgnore(false)
    slot.base.icon:SetShow(true)
    Panel_Tooltip_Item_SetPosition(ii, slot.base, "DeliveryRequest")
    self.slots[ii] = slot
  end
  UI.deleteControl(self.slotBG)
  self.slotBG = nil
  Panel_Window_Delivery_Request:SetChildIndex(self.comboBox_Carriage, Panel_Window_Delivery_Request:getChildControlCount())
  Panel_Window_Delivery_Request:SetChildIndex(self.comboBox_Destination, Panel_Window_Delivery_Request:getChildControlCount())
end
function deliveryRequest:update()
  local basePrice = 0
  local baseTradePrice = 0
  local totalCount = 0
  local tatalPrice = 0
  local packingItemCount = delivery_packCountType(false)
  local packingTradeItemCount = delivery_packCountType(true)
  if 0 ~= self.selectCarriageKeyRaw then
    basePrice = delivery_baseFee(DeliveryInformation_WaypointKey(), self.selectWaypointKey, self.selectCarriageKeyRaw, false)
    baseTradePrice = delivery_baseFee(DeliveryInformation_WaypointKey(), self.selectWaypointKey, self.selectCarriageKeyRaw, true)
    tatalPrice = packingItemCount * basePrice + packingTradeItemCount * baseTradePrice
    totalCount = packingItemCount + packingTradeItemCount
  end
  self.staticText_TotalCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_DeliveryRequest_packingCount", "packingCount", tostring(totalCount)))
  self.staticText_TotalFee:SetText("" .. makeDotMoney(tatalPrice))
  if 0 ~= self.selectWaypointKey then
    if not delivery_linkedWayPoint(DeliveryInformation_WaypointKey(), self.selectWaypointKey) then
      self.staticText_WayPointPenalty:SetShow(true)
    else
      self.staticText_WayPointPenalty:SetShow(false)
    end
  else
    self.staticText_WayPointPenalty:SetShow(false)
  end
  self.staticText_Total_Title:ComputePos()
  self.staticText_TotalCount:ComputePos()
  self.staticText_TotalFee:ComputePos()
  self:clearSlot()
  for ii = 0, self.config.slotCount - 1 do
    local itemWrapper = delivery_packItem(ii)
    if nil ~= itemWrapper then
      self.slots[ii].base:setItem(itemWrapper)
    end
  end
end
function deliveryRequest:updateDestination()
  self.comboBox_Destination:DeleteAllItem()
  local waypointKeyList = delivery_listWaypointKey(DeliveryInformation_WaypointKey(), false)
  if nil ~= waypointKeyList then
    local size = waypointKeyList:size()
    if size == 0 then
      self.comboBox_Destination:SetSelectItemIndex(0)
      self.comboBox_Destination:AddItem(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_NOT_CONNECT_REGION"))
      return
    end
    for ii = 0, size - 1 do
      self.comboBox_Destination:AddItem(waypointKeyList:atPointer(ii):getName())
    end
  end
end
function deliveryRequest:updateCarriageTypeList()
  self.comboBox_Carriage:DeleteAllItem()
  local carriageList = delivery_listCarriage(DeliveryInformation_WaypointKey(), self.selectWaypointKey, false)
  local size = carriageList:size()
  if size == 0 then
    self.comboBox_Carriage:SetSelectItemIndex(0)
    self.comboBox_Carriage:AddItem(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_SELECT_REGION"))
    return
  end
  for ii = 0, size - 1 do
    self.comboBox_Carriage:AddItem(carriageList:atPointer(ii):getName())
  end
end
function deliveryRequest:clearSlot()
  for ii = 0, self.config.slotCount - 1 do
    self.slots[ii].base:clearItem()
  end
end
function DeliveryRequest_PushPackingItem(warehouseSlotNo, s64_count)
  if s64_count < Defines.s64_const.s64_1 then
    return
  end
  local self = deliveryRequest
  warehouse_requestInfo(DeliveryInformation_WaypointKey())
  delivery_pushPack(warehouseSlotNo, s64_count)
  self:update()
  FromClient_WarehouseUpdate()
end
function DeliveryRequest_UpdateRequestSlotData()
  local self = deliveryRequest
  self:update()
end
function DeliveryRequest_Send_CheckNode()
  local self = deliveryRequest
  local packingItemCount = delivery_packCountType(false)
  local packingTradeItemCount = delivery_packCountType(true)
  if packingItemCount + packingTradeItemCount < 1 then
    return
  end
  local selected_Destination = self.comboBox_Destination:GetSelectIndex()
  local selected_Carriage = self.comboBox_Carriage:GetSelectIndex()
  if -1 == selected_Destination or -1 == selected_Carriage then
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
  end
  if not delivery_linkedWayPoint(DeliveryInformation_WaypointKey(), self.selectWaypointKey) then
    local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_NOTLINKEDWAYPOINT_TITLE")
    local messageboxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_NOTLINKEDWAYPOINT_MSG")
    local messageboxData = {
      title = messageboxTitle,
      content = messageboxMemo,
      functionYes = DeliveryRequest_Send,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    DeliveryRequest_Send()
  end
end
function DeliveryRequest_Send()
  local self = deliveryRequest
  delivery_request(DeliveryInformation_WaypointKey(), self.selectWaypointKey, self.selectCarriageKeyRaw)
end
function DeliveryRequest_ShowToWaypointKey()
  local self = deliveryRequest
  local waypointList = self.comboBox_Destination:GetListControl()
  waypointList:addInputEvent("Mouse_LUp", "DeliveryRequest_SelectToWaypointKey()")
  self.comboBox_Destination:ToggleListbox()
end
function DeliveryRequest_SelectToWaypointKey()
  local self = deliveryRequest
  local waypointKeyList = delivery_listWaypointKey(DeliveryInformation_WaypointKey(), false)
  if nil ~= waypointKeyList then
    local size = waypointKeyList:size()
    local selectIndex = self.comboBox_Destination:GetSelectIndex()
    local waypoint = waypointKeyList:atPointer(selectIndex)
    if nil == waypoint then
      return
    end
    self.comboBox_Carriage:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_DELIVERER"))
    self.comboBox_Destination:SetSelectItemIndex(selectIndex)
    self.selectWaypointKey = waypointKeyList:atPointer(selectIndex):getWaypointKey()
    self.comboBox_Destination:ToggleListbox()
    self:updateCarriageTypeList()
    self:update()
  end
end
function DeliveryRequest_ShowToCarriage()
  local self = deliveryRequest
  local carriageList = self.comboBox_Carriage:GetListControl()
  carriageList:addInputEvent("Mouse_LUp", "DeliveryRequest_SelectCarriageType()")
  self.comboBox_Carriage:ToggleListbox()
end
function DeliveryRequest_SelectCarriageType()
  if -1 == deliveryRequest.comboBox_Destination:GetSelectIndex() then
    return
  end
  local self = deliveryRequest
  local carriageList = delivery_listCarriage(DeliveryInformation_WaypointKey(), self.selectWaypointKey, false)
  if nil == carriageList then
    return
  end
  local size = carriageList:size()
  local selectIndex = self.comboBox_Carriage:GetSelectIndex()
  if -1 == selectIndex then
    return
  end
  self.comboBox_Carriage:SetSelectItemIndex(selectIndex)
  self.selectCarriageKeyRaw = carriageList:atPointer(selectIndex):getCharacterKeyRaw()
  self.comboBox_Carriage:ToggleListbox()
  self:update()
end
function DeliveryRequestWindow_Open()
  Warehouse_SetIgnoreMoneyButton(true)
  deliveryRequest.deliveryHelpDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  deliveryRequest.deliveryHelpDesc:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_DELIVERY_HELPDESC"))
  deliveryRequest.deliveryHelpBG:SetSize(385, deliveryRequest.deliveryHelpDesc:GetTextSizeY() + 5)
  deliveryRequest.staticText_Total_Title:SetPosY(deliveryRequest.deliveryHelpBG:GetPosY() + deliveryRequest.deliveryHelpBG:GetSizeY() + 5)
  deliveryRequest.staticText_TotalCount:SetPosY(deliveryRequest.deliveryHelpBG:GetPosY() + deliveryRequest.deliveryHelpBG:GetSizeY() + 5)
  deliveryRequest.staticText_TotalFee:SetPosY(deliveryRequest.staticText_Total_Title:GetPosY() + deliveryRequest.staticText_Total_Title:GetSizeY())
  deliveryRequest.staticGoldIcon:SetPosY(deliveryRequest.staticText_Total_Title:GetPosY() + deliveryRequest.staticText_Total_Title:GetSizeY() + 3)
  deliveryRequest.rdo_send:SetCheck(true)
  DeliveryInformationWindow_Close()
  if not Panel_Window_Delivery_Request:IsShow() then
    Panel_Window_Delivery_Request:ChangeSpecialTextureInfoName("")
    Panel_Window_Delivery_Request:SetAlphaExtraChild(1)
    Panel_Window_Delivery_Request:SetShow(true, false)
    if ToClient_WorldMapIsShow() then
      WorldMapPopupManager:increaseLayer(true)
      WorldMapPopupManager:push(Panel_Window_Delivery_Request, true)
    end
  end
  local self = deliveryRequest
  self.comboBox_Destination:DeleteAllItem()
  self.comboBox_Destination:AddItem(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_SELECT_TO_REGION"))
  self.comboBox_Destination:SetSelectItemIndex(0)
  self.comboBox_Carriage:DeleteAllItem()
  self.comboBox_Carriage:AddItem(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_DELIVERER"))
  self.comboBox_Carriage:SetSelectItemIndex(0)
  self.selectCarriageKeyRaw = 0
  self.selectWaypointKey = 0
  clearDeliveryPack()
  self:clearSlot()
  self:updateDestination()
  self:update()
  FGlobal_WarehouseTownListCheck()
end
function DeliveryRequestWindow_Close()
  clearDeliveryPack()
  if ToClient_WorldMapIsShow() then
    if Panel_Window_Delivery_Request:GetShow() then
      WorldMapPopupManager:pop()
    end
  elseif Panel_Window_Delivery_Request:GetShow() then
    Panel_Window_Delivery_Request:ChangeSpecialTextureInfoName("")
    Panel_Window_Delivery_Request:SetShow(false, false)
    FromClient_WarehouseUpdate()
  end
  FGlobal_WarehouseTownListCheck()
end
function ShowInformationWindow()
  DeliveryInformationWindow_Open()
end
function DeliveryRequest_SlotRClick(slotNo)
  local self = deliveryRequest
  delivery_popPack(slotNo)
  self:update()
  FromClient_WarehouseUpdate()
end
function FromClient_DeliveryItemState(state)
  if 0 == state then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_DELIVERYITEMSTATE_WAIT"))
  elseif 1 == state then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_DELIVERYITEMSTATE_START"))
  elseif 2 == state then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_DELIVERYITEMSTATE_COMPLETE"))
  end
end
function PaGlobalFunc_PanelDelivery_GetShow()
  if nil ~= Panel_Window_Delivery_Request and nil ~= Panel_Window_Delivery_Information then
    return Panel_Window_Delivery_Request:GetShow() or Panel_Window_Delivery_Information:GetShow()
  else
    return false
  end
end
deliveryRequest:init()
deliveryRequest:registEventHandler()
deliveryRequest:registMessageHandler()

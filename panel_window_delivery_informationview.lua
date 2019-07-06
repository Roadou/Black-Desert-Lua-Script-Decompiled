Panel_Window_Delivery_InformationView:ActiveMouseEventEffect(true)
Panel_Window_Delivery_InformationView:setMaskingChild(true)
Panel_Window_Delivery_InformationView:setGlassBackground(true)
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local deliveryInformationView = {
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  config = {
    slotCount = 7,
    slotStartX = 10,
    slotStartY = 70,
    slotGapY = 70,
    slotIconStartX = 5,
    slotIconStartY = 8,
    slotCarriageTypeStartX = 88,
    slotCarriageTypeStartY = 8,
    slotDepartureStartX = 65,
    slotDepartureStartY = 31,
    slotDestinationStartX = 215,
    slotDestinationStartY = 31,
    slotArrowStartX = 180,
    slotArrowStartY = 34,
    slotButtonStartX = 320,
    slotButtonStartY = 5
  },
  const = {
    deliveryProgressTypeRequest = 0,
    deliveryProgressTypeIng = 1,
    deliveryProgressTypeComplete = 2
  },
  _staticBackground = UI.getChildControl(Panel_Window_Delivery_InformationView, "Static_Bakcground"),
  _buttonClose = UI.getChildControl(Panel_Window_Delivery_InformationView, "Button_Win_Close"),
  _buttonQuestion = UI.getChildControl(Panel_Window_Delivery_InformationView, "Button_Question"),
  _buttonRefresh = UI.getChildControl(Panel_Window_Delivery_InformationView, "Button_Refresh"),
  _textCount = UI.getChildControl(Panel_Window_Delivery_InformationView, "StaticText_DeliveryCount"),
  _defaultNotify = UI.getChildControl(Panel_Window_Delivery_InformationView, "StaticText_Empty_List"),
  _slots = Array.new(),
  list2 = UI.getChildControl(Panel_Window_Delivery_InformationView, "List2_DeliveryItemListView"),
  _startSlotNo = 0,
  _slotMaxSize = 100
}
function deliveryInformationView:registMessageHandler()
  registerEvent("EventDeliveryInfoUpdate", "DeliveryInformationView_Update")
  registerEvent("FromClient_MoveDeliveryItem", "DeliveryInformationView_Update")
end
function deliveryInformationView:registEventHandler()
  self._buttonClose:addInputEvent("Mouse_LUp", "DeliveryInformationView_Close()")
  self._buttonRefresh:addInputEvent("Mouse_LUp", "DeliveryInformationView_Refresh()")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"DeliveryInformation\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"DeliveryInformation\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"DeliveryInformation\", \"false\")")
end
function deliveryInformationView:init()
  local minSize = float2()
  minSize.x = 100
  minSize.y = 50
  local list2 = UI.getChildControl(Panel_Window_Delivery_InformationView, "List2_DeliveryItemListView")
  local list2_Content = UI.getChildControl(list2, "List2_1_Content")
  local slot = {}
  list2:setMinScrollBtnSize(minSize)
  local list2_ItemSlot = UI.getChildControl(list2_Content, "Static_List2_Slot")
  SlotItem.new(slot, "DeliveryView_Slot_Icon_", 0, list2_ItemSlot, self.slotConfig)
  slot:createChild()
  slot.icon:SetPosX(4)
  slot.icon:SetPosY(1)
  self.list2:changeAnimationSpeed(10)
  self.list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "DeliveryView_ListControlCreate")
  self.list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
local deliveryCountCache = 0
function deliveryInformationView:update()
  self._defaultNotify:SetShow(true)
  local deliveryList = delivery_listAll()
  if nil == deliveryList then
    return
  end
  local deliveryCount = deliveryList:size()
  self._textCount:SetText("(" .. deliveryCount .. "/" .. self._slotMaxSize .. ")")
  self.list2:moveIndex(deliveryCount)
  if deliveryCount > deliveryCountCache then
    for idx = deliveryCountCache, deliveryCount - 1 do
      local deliveryInfo = deliveryList:atPointer(idx)
      if nil ~= deliveryInfo then
        self.list2:getElementManager():pushKey(toInt64(0, idx))
      end
    end
  else
    for idx = deliveryCount, deliveryCountCache - 1 do
      self.list2:getElementManager():removeKey(toInt64(0, idx))
    end
  end
  deliveryCountCache = deliveryCount
  if 0 == deliveryCount then
    return
  end
  self._defaultNotify:SetShow(false)
  self.list2:moveTopIndex()
end
function DeliveryInformationView_Refresh()
  delivery_refreshClear()
  delivery_requsetList()
end
function DeliveryInformationView_Update()
  local self = deliveryInformationView
  self._startSlotNo = 0
  self:update()
end
function DeliveryInformationView_Open()
  local self = deliveryInformationView
  if Panel_Window_Delivery_InformationView:GetShow() then
    return
  end
  delivery_requsetList()
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:increaseLayer(true)
    WorldMapPopupManager:push(Panel_Window_Delivery_InformationView, true)
    Panel_Window_Delivery_InformationView:SetPosX(getScreenSizeX() - Panel_Window_Delivery_InformationView:GetSizeX() - 10)
    Panel_Window_Delivery_InformationView:SetPosY(getScreenSizeY() / 2 - Panel_Window_Delivery_InformationView:GetSizeY() / 2)
  end
  DeliveryInformationView_Update()
  Panel_Window_Delivery_InformationView:SetAlphaExtraChild(1)
  Panel_Window_Delivery_InformationView:SetShow(true, true)
end
function DeliveryInformationView_Close()
  if not Panel_Window_Delivery_InformationView:GetShow() then
    return
  end
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:pop()
  end
  Panel_Window_Delivery_InformationView:ChangeSpecialTextureInfoName("")
  Panel_Window_Delivery_InformationView:SetShow(false, false)
end
function DeliveryView_ListControlCreate(content, key)
  local self = deliveryInformationView
  local index = Int64toInt32(key)
  local deliveryList = delivery_listAll()
  local deliveryInfo = deliveryList:atPointer(index)
  local itemWrapper = deliveryInfo:getItemWrapper()
  local itemBG = UI.getChildControl(content, "Static_List2_ItemBG")
  itemBG:SetPosX(5)
  itemBG:SetPosY(5)
  local slot = {}
  local itemSlot = UI.getChildControl(content, "Static_List2_Slot")
  itemSlot:SetShow(true)
  itemSlot:SetPosX(8)
  itemSlot:SetPosY(17)
  itemSlot:SetSize(40, 40)
  SlotItem.reInclude(slot, "DeliveryView_Slot_Icon_", 0, itemSlot, self.slotConfig)
  slot:setItem(itemWrapper)
  local carriageType = UI.getChildControl(content, "StaticText_List2_CarriageType")
  carriageType:SetShow(true)
  if 1 == deliveryInfo:getCarriageType() then
    carriageType:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_DeliveryInformation_carriageType_carriage"))
  elseif 2 == deliveryInfo:getCarriageType() then
    carriageType:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_DeliveryInformation_carriageType_Transport"))
  elseif 3 == deliveryInfo:getCarriageType() then
    carriageType:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_DeliveryInformation_carriageType_TradeShip"))
  else
    carriageType:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_DeliveryInformation_carriageType_carriage"))
  end
  carriageType:SetPosY(37)
  local departure = UI.getChildControl(content, "StaticText_List2_Departure")
  departure:SetShow(true)
  departure:SetText(deliveryInfo:getFromRegionName())
  departure:SetPosY(17)
  local destination = UI.getChildControl(content, "StaticText_List2_Destination")
  destination:SetShow(true)
  destination:SetText(deliveryInfo:getToRegionName())
  destination:SetPosY(17)
  local btn_Ready = UI.getChildControl(content, "Button_List2_Ready")
  btn_Ready:SetShow(false)
  btn_Ready:SetPosX(335)
  btn_Ready:SetPosY(17)
  local btn_Ing = UI.getChildControl(content, "Button_List2_Ing")
  btn_Ing:SetShow(false)
  btn_Ing:SetPosX(335)
  btn_Ing:SetPosY(17)
  local btn_Complete = UI.getChildControl(content, "Button_List2_Complete")
  btn_Complete:SetShow(false)
  btn_Complete:SetPosX(335)
  btn_Complete:SetPosY(17)
  if self.const.deliveryProgressTypeRequest == deliveryInfo:getProgressType() then
    btn_Ready:SetShow(true)
  elseif self.const.deliveryProgressTypeIng == deliveryInfo:getProgressType() then
    btn_Ing:SetShow(true)
  else
    btn_Complete:SetShow(true)
  end
  local arrow = UI.getChildControl(content, "Static_List2_Arrow")
  arrow:SetShow(true)
  arrow:SetPosX(departure:GetPosX() + departure:GetTextSizeX() + 10)
  arrow:SetPosY(departure:GetPosY() + 2)
  destination:SetPosX(arrow:GetPosX() + arrow:GetSizeX() + 10)
  slot.icon:addInputEvent("Mouse_On", "DeliveryItemView_Tooltip_Show(" .. index .. ", true)")
  slot.icon:addInputEvent("Mouse_Out", "DeliveryItemView_Tooltip_Show(" .. index .. ", false)")
end
function DeliveryItemView_Tooltip_Show(idx, isOn)
  local self = deliveryInformationView
  if false == isOn then
    Panel_Tooltip_Item_hideTooltip()
  end
  local control = self.list2
  local contents = control:GetContentByKey(toInt64(0, idx))
  if nil ~= contents then
    local itemIcon = UI.getChildControl(contents, "Static_List2_Slot")
    if true == isOn then
      local deliveryList = delivery_listAll()
      local deliveryInfo = deliveryList:atPointer(idx)
      local itemWrapper = deliveryInfo:getItemWrapper()
      local itemSSW = itemWrapper:getStaticStatus()
      Panel_Tooltip_Item_Show(itemSSW, itemIcon, true, false, nil, nil, true, nil, "Delivery", deliveryInfo:getItemNo())
    end
  end
end
deliveryInformationView:init()
deliveryInformationView:registEventHandler()
deliveryInformationView:registMessageHandler()

Panel_Window_Delivery_Information:ActiveMouseEventEffect(true)
Panel_Window_Delivery_Information:setMaskingChild(true)
Panel_Window_Delivery_Information:setGlassBackground(true)
Panel_Window_Delivery_Information:RegisterShowEventFunc(true, "DeliveryInformationShowAni()")
Panel_Window_Delivery_Information:RegisterShowEventFunc(false, "DeliveryInformationHideAni()")
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
function DeliveryInformationShowAni()
  Panel_Window_Delivery_Information:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_Window_Delivery_Information, 0.05, 0.15)
  local aniInfo1 = Panel_Window_Delivery_Information:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1)
  aniInfo1.AxisX = Panel_Window_Delivery_Information:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_Delivery_Information:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = false
  local aniInfo2 = Panel_Window_Delivery_Information:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_Delivery_Information:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_Delivery_Information:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = false
end
function DeliveryInformationHideAni()
  Panel_Window_Delivery_Information:ChangeSpecialTextureInfoName("")
  Panel_Window_Delivery_Information:SetAlpha(1)
  UIAni.AlphaAnimation(0, Panel_Window_Delivery_Information, 0, 0.1)
end
local deliveryInformation = {
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  const = {
    deliveryProgressTypeRequest = 0,
    deliveryProgressTypeIng = 1,
    deliveryProgressTypeComplete = 2
  },
  panel_Background = UI.getChildControl(Panel_Window_Delivery_Information, "Static_Bakcground"),
  button_Close = UI.getChildControl(Panel_Window_Delivery_Information, "Button_Win_Close"),
  buttonQuestion = UI.getChildControl(Panel_Window_Delivery_Information, "Button_Question"),
  button_Request = UI.getChildControl(Panel_Window_Delivery_Information, "Button_Send"),
  rdo_information = UI.getChildControl(Panel_Window_Delivery_Information, "RadioButton_Information"),
  button_ReceiveAll = UI.getChildControl(Panel_Window_Delivery_Information, "Button_ReceiveAll"),
  radiobutton_trans_list = UI.getChildControl(Panel_Window_Delivery_Information, "RadioButton_Tranlist"),
  radiobutton_alltrans_list = UI.getChildControl(Panel_Window_Delivery_Information, "RadioButton_AllTranlist"),
  check_Cancel = UI.getChildControl(Panel_Window_Delivery_Information, "CheckButton_Cancel"),
  check_Recieve = UI.getChildControl(Panel_Window_Delivery_Information, "CheckButton_Recieve"),
  empty_List = UI.getChildControl(Panel_Window_Delivery_Information, "StaticText_Empty_List"),
  list2 = UI.getChildControl(Panel_Window_Delivery_Information, "List2_DeliveryItemList"),
  currentWaypointKey = 0,
  scrollIndex = 0,
  deliveryList = nil
}
function deliveryInformation:registMessageHandler()
  registerEvent("FromClient_MoveDeliveryItem", "DeliveryInformation_UpdateSlotData")
end
function deliveryInformation:registEventHandler()
  self.button_Close:addInputEvent("Mouse_LUp", "DeliveryInformationWindow_Close()")
  self.buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"DeliveryInformation\" )")
  self.button_Request:addInputEvent("Mouse_LUp", "DeliveryRequestWindow_Open()")
  self.radiobutton_trans_list:addInputEvent("Mouse_LUp", "DeliveryInformation_Refresh(" .. 1 .. ")")
  self.radiobutton_alltrans_list:addInputEvent("Mouse_LUp", "DeliveryInformation_Refresh(" .. 2 .. ")")
  self.button_ReceiveAll:addInputEvent("Mouse_LUp", "Delivery_Receive_All()")
  self.buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"DeliveryInformation\", \"true\")")
  self.buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"DeliveryInformation\", \"false\")")
  self.check_Cancel:addInputEvent("Mouse_LUp", "DeliveryInformation_UpdateSlotData()")
  self.check_Recieve:addInputEvent("Mouse_LUp", "DeliveryInformation_UpdateSlotData()")
  self.check_Recieve:SetAutoDisableTime(4)
end
function deliveryInformation:init()
  local minSize = float2()
  minSize.x = 100
  minSize.y = 50
  local list2 = UI.getChildControl(Panel_Window_Delivery_Information, "List2_DeliveryItemList")
  local list2_Content = UI.getChildControl(list2, "List2_1_Content")
  local slot = {}
  list2:setMinScrollBtnSize(minSize)
  local list2_ItemSlot = UI.getChildControl(list2_Content, "Static_List2_Slot")
  SlotItem.new(slot, "Delivery_Slot_Icon_", 0, list2_ItemSlot, self.slotConfig)
  slot:createChild()
  slot.icon:SetPosX(9)
  slot.icon:SetPosY(9)
  self.list2:changeAnimationSpeed(10)
  self.list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "Delivery_ListControlCreate")
  self.list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self.check_Cancel:SetCheck(true)
  self.check_Recieve:SetCheck(true)
  self.check_Cancel:SetEnableArea(0, 0, self.check_Cancel:GetSizeX() + self.check_Cancel:GetTextSizeX() + 8, self.check_Cancel:GetSizeY())
  self.check_Recieve:SetEnableArea(0, 0, self.check_Cancel:GetSizeX() + self.check_Cancel:GetTextSizeX() + 8, self.check_Cancel:GetSizeY())
  local screenSizeX = getScreenSizeX()
  if self.check_Recieve:GetTextSizeX() > screenSizeX / 38 then
    self.check_Cancel:SetSpanSize(self.check_Cancel:GetSpanSize().x + self.check_Recieve:GetTextSizeX() - screenSizeX / 64, self.check_Cancel:GetSpanSize().y)
  end
  self.radiobutton_trans_list:SetCheck(true)
  self.radiobutton_alltrans_list:SetCheck(false)
end
local deliveryCountCache = 0
function deliveryInformation:updateSlot()
  if self.radiobutton_trans_list:IsCheck() then
    self.deliveryList = delivery_list(DeliveryInformation_WaypointKey())
  else
    self.deliveryList = delivery_listAll()
  end
  if nil == self.deliveryList then
    self.empty_List:SetShow(true)
    return
  else
    self.empty_List:SetShow(false)
  end
  local deliveryCount = self.deliveryList:size()
  if deliveryCount > deliveryCountCache then
    for idx = deliveryCountCache, deliveryCount - 1 do
      local deliveryInfo = self.deliveryList:atPointer(idx)
      if self.radiobutton_trans_list:IsCheck() then
        if self.check_Cancel:IsCheck() and self.const.deliveryProgressTypeRequest == deliveryInfo:getProgressType() or self.check_Cancel:IsCheck() and self.const.deliveryProgressTypeIng == deliveryInfo:getProgressType() or self.check_Recieve:IsCheck() and self.const.deliveryProgressTypeComplete == deliveryInfo:getProgressType() then
          if nil ~= deliveryInfo then
            self.list2:getElementManager():pushKey(toInt64(0, idx))
          end
        else
          self.list2:getElementManager():removeKey(toInt64(0, idx))
        end
      elseif nil ~= deliveryInfo then
        self.list2:getElementManager():pushKey(toInt64(0, idx))
      else
        self.list2:getElementManager():removeKey(toInt64(0, idx))
      end
    end
  else
    for idx = deliveryCount, deliveryCountCache - 1 do
      self.list2:getElementManager():removeKey(toInt64(0, idx))
    end
  end
  deliveryCountCache = deliveryCount
  if 0 == deliveryCount then
    self.empty_List:SetShow(true)
  else
    self.empty_List:SetShow(false)
  end
  self.list2:moveIndex(self.scrollIndex)
end
function DeliveryInformation_WaypointKey()
  local self = deliveryInformation
  return self.currentWaypointKey
end
function DeliveryInformation_SlotIndex(slotNo)
  local self = deliveryInformation
  return slotNo
end
function DeliveryInformation_UpdateSlotData()
  if not Panel_Window_Delivery_Information:IsShow() then
    return
  end
  local self = deliveryInformation
  if nil ~= DeliveryInformation_WaypointKey() then
    if self.radiobutton_trans_list:IsCheck() then
      self.deliveryList = delivery_list(DeliveryInformation_WaypointKey())
    else
      self.deliveryList = delivery_listAll()
    end
  end
  self.list2:getElementManager():clearKey()
  deliveryCountCache = 0
  self:updateSlot()
end
function DeliveryInformationWindow_Open()
  if true == _ContentsGroup_RenewUI_ItemMarketPlace_Only and Panel_Window_MarketPlace_WalletInventory:GetShow() then
    PaGlobalFunc_MarketWallet_ForceClose()
  end
  DeliveryRequestWindow_Close()
  Warehouse_SetIgnoreMoneyButton(true)
  local self = deliveryInformation
  self.radiobutton_trans_list:SetCheck(true)
  self.radiobutton_alltrans_list:SetCheck(false)
  self.rdo_information:SetCheck(true)
  if not Panel_Window_Delivery_Information:IsShow() then
    Panel_Window_Delivery_Information:SetAlphaExtraChild(1)
    Panel_Window_Delivery_Information:SetShow(true, false)
    delivery_requsetList()
    if ToClient_WorldMapIsShow() then
      WorldMapPopupManager:increaseLayer(true)
      WorldMapPopupManager:push(Panel_Window_Delivery_Information, true)
    end
  end
  self:updateSlot()
  Panel_Window_Delivery_Information:SetPosX(Panel_Window_Warehouse:GetPosX() - Panel_Window_Delivery_Information:GetSizeX())
  Panel_Window_Delivery_Information:SetPosY(Panel_Window_Warehouse:GetPosY())
  Panel_Window_Delivery_Request:SetPosX(Panel_Window_Warehouse:GetPosX() - Panel_Window_Delivery_Information:GetSizeX())
  Panel_Window_Delivery_Request:SetPosY(Panel_Window_Warehouse:GetPosY())
  if Panel_Window_Delivery_Information:GetPosX() <= 0 then
    Panel_Window_Delivery_Information:SetPosX(3)
    if true == Panel_Window_Warehouse:GetShow() then
      Panel_Window_Warehouse:SetPosX(Panel_Window_Delivery_Information:GetSizeX() + 20)
    end
  end
  if Panel_Window_Delivery_Request:GetPosX() <= 0 then
    Panel_Window_Delivery_Request:SetPosX(3)
    if true == Panel_Window_Warehouse:GetShow() then
      Panel_Window_Warehouse:SetPosX(Panel_Window_Delivery_Request:GetSizeX() + 20)
    end
  end
  self.list2:moveTopIndex()
  self.scrollIndex = 0
  FGlobal_WarehouseTownListCheck()
end
function DeliveryInformationWindow_Close()
  if ToClient_WorldMapIsShow() then
    if Panel_Window_Delivery_Information:GetShow() then
      WorldMapPopupManager:pop()
    end
  elseif Panel_Window_Delivery_Information:GetShow() then
    Panel_Window_Delivery_Information:ChangeSpecialTextureInfoName("")
    Panel_Window_Delivery_Information:SetShow(false, false)
    WorldMapPopupManager:pop()
  end
  local self = deliveryInformation
  self.list2:getElementManager():clearKey()
  deliveryCountCache = 0
  self.radiobutton_trans_list:SetCheck(true)
  self.radiobutton_alltrans_list:SetCheck(false)
  FGlobal_WarehouseTownListCheck()
end
function DeliveryInformation_Refresh(_type)
  delivery_refreshClear()
  delivery_requsetList()
end
function DeliveryInformation_OpenPanelFromWorldmap(waypointKey)
  local self = deliveryInformation
  self.currentWaypointKey = waypointKey
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:increaseLayer(true)
    WorldMapPopupManager:push(Panel_Window_Delivery_Information, true)
  end
  DeliveryInformationWindow_Open()
end
function DeliveryInformation_OpenPanelFromDialog()
  local self = deliveryInformation
  self.currentWaypointKey = getCurrentWaypointKey()
  Warehouse_OpenPanelFromDialogWithoutInventory(getCurrentWaypointKey(), CppEnums.WarehoouseFromType.eWarehoouseFromType_Npc)
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local basePosY = screenSizeY / 2 - Panel_Window_Warehouse:GetSizeY() / 2
  local posY = math.min(screenSizeY - 280, basePosY + Panel_Window_Warehouse:GetSizeY()) - Panel_Window_Warehouse:GetSizeY()
  posY = math.max(0, posY)
  local spanSizeY = posY - basePosY
  Panel_Window_Warehouse:SetVerticalMiddle()
  Panel_Window_Warehouse:SetHorizonCenter()
  Panel_Window_Warehouse:SetSpanSize(100, spanSizeY)
  DeliveryInformationWindow_Open()
end
function Delivery_Cancel(index)
  local self = deliveryInformation
  self.deliveryList = delivery_list(self.currentWaypointKey)
  local deliveryInfo = self.deliveryList:atPointer(index)
  local itemNo = deliveryInfo:getItemNo()
  delivery_cancelbyItemNo(itemNo)
  self:updateSlot()
end
function Delivery_Receive(index)
  local self = deliveryInformation
  self.deliveryList = delivery_list(self.currentWaypointKey)
  local deliveryInfo = self.deliveryList:atPointer(index)
  local itemNo = deliveryInfo:getItemNo()
  delivery_receiveItemNo(itemNo)
  self:updateSlot()
end
function Delivery_Receive_All()
  delivery_receiveAll(DeliveryInformation_WaypointKey())
  deliveryCountCache = 0
end
function Delivery_ListControlCreate(content, key)
  local self = deliveryInformation
  local index = Int64toInt32(key)
  if self.radiobutton_trans_list:IsCheck() then
    self.deliveryList = delivery_list(DeliveryInformation_WaypointKey())
  else
    self.deliveryList = delivery_listAll()
  end
  local deliveryInfo = self.deliveryList:atPointer(index)
  local itemWrapper = deliveryInfo:getItemWrapper()
  if nil == itemWrapper then
    return
  end
  local itemBG = UI.getChildControl(content, "Static_List2_ItemBG")
  itemBG:SetPosX(10)
  itemBG:SetPosY(10)
  local slot = {}
  local itemSlot = UI.getChildControl(content, "Static_List2_Slot")
  itemSlot:SetShow(true)
  itemSlot:SetPosX(8)
  itemSlot:SetPosY(8)
  itemSlot:SetSize(40, 40)
  SlotItem.reInclude(slot, "Delivery_Slot_Icon_", 0, itemSlot, self.slotConfig)
  slot:setItem(itemWrapper)
  local carriageType = UI.getChildControl(content, "StaticText_List2_CarriageType")
  carriageType:SetShow(true)
  carriageType:SetPosX(70)
  carriageType:SetPosY(37)
  if 1 == deliveryInfo:getCarriageType() then
    carriageType:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_DeliveryInformation_carriageType_carriage"))
  elseif 2 == deliveryInfo:getCarriageType() then
    carriageType:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_DeliveryInformation_carriageType_Transport"))
  elseif 3 == deliveryInfo:getCarriageType() then
    carriageType:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_DeliveryInformation_carriageType_TradeShip"))
  else
    carriageType:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_DeliveryInformation_carriageType_carriage"))
  end
  local departure = UI.getChildControl(content, "StaticText_List2_Departure")
  departure:SetShow(true)
  departure:SetText(deliveryInfo:getFromRegionName())
  departure:SetPosX(70)
  departure:SetPosY(17)
  local arrow = UI.getChildControl(content, "Static_List2_Arrow")
  arrow:SetShow(true)
  arrow:SetPosX(departure:GetPosX() + departure:GetTextSizeX() + 10)
  arrow:SetPosY(19)
  local itemNo = deliveryInfo:getItemNo()
  local destination = UI.getChildControl(content, "StaticText_List2_Destination")
  destination:SetShow(true)
  destination:SetText(deliveryInfo:getToRegionName())
  destination:SetPosX(arrow:GetPosX() + arrow:GetSizeX() + 10)
  destination:SetPosY(17)
  local receive = UI.getChildControl(content, "Button_List2_Receive")
  receive:SetPosX(355)
  receive:SetPosY(17)
  local cancel = UI.getChildControl(content, "Button_List2_Cancel")
  cancel:SetPosX(355)
  cancel:SetPosY(17)
  local Ready = UI.getChildControl(content, "Button_List2_Ready")
  Ready:SetPosX(355)
  Ready:SetPosY(17)
  local Ing = UI.getChildControl(content, "Button_List2_Ing")
  Ing:SetPosX(355)
  Ing:SetPosY(17)
  local Complete = UI.getChildControl(content, "Button_List2_Complete")
  Complete:SetPosX(355)
  Complete:SetPosY(17)
  if self.radiobutton_trans_list:IsCheck() then
    Ready:SetShow(false)
    Ing:SetShow(false)
    Complete:SetShow(false)
    if self.const.deliveryProgressTypeRequest == deliveryInfo:getProgressType() then
      receive:SetShow(false)
      cancel:SetShow(true)
    else
      cancel:SetShow(false)
      receive:SetShow(true)
    end
  else
    cancel:SetShow(false)
    receive:SetShow(false)
    if self.const.deliveryProgressTypeRequest == deliveryInfo:getProgressType() then
      Ready:SetShow(true)
      Ing:SetShow(false)
      Complete:SetShow(false)
    elseif self.const.deliveryProgressTypeIng == deliveryInfo:getProgressType() then
      Ready:SetShow(false)
      Ing:SetShow(true)
      Complete:SetShow(false)
    else
      Ready:SetShow(false)
      Ing:SetShow(false)
      Complete:SetShow(true)
    end
  end
  receive:addInputEvent("Mouse_LUp", "Delivery_Receive(" .. index .. " )")
  cancel:addInputEvent("Mouse_LUp", "Delivery_Cancel(" .. index .. " )")
  slot.icon:addInputEvent("Mouse_On", "DeliveryItem_Tooltip_Show(" .. index .. ", true)")
  slot.icon:addInputEvent("Mouse_Out", "DeliveryItem_Tooltip_Show(" .. index .. ", false)")
  if index > self.scrollIndex then
    self.scrollIndex = index - 8
  else
    self.scrollIndex = index
  end
end
function DeliveryItem_Tooltip_Show(idx, isOn)
  if false == isOn then
    Panel_Tooltip_Item_hideTooltip()
  end
  local self = deliveryInformation
  local control = self.list2
  local contents = control:GetContentByKey(toInt64(0, idx))
  if nil ~= contents then
    local itemIcon = UI.getChildControl(contents, "Static_List2_Slot")
    if true == isOn then
      if self.radiobutton_trans_list:IsCheck() then
        self.deliveryList = delivery_list(DeliveryInformation_WaypointKey())
      else
        self.deliveryList = delivery_listAll()
      end
      local deliveryInfo = self.deliveryList:atPointer(idx)
      local itemWrapper = deliveryInfo:getItemWrapper()
      local itemSSW = itemWrapper:getStaticStatus()
      Panel_Tooltip_Item_Show(itemSSW, itemIcon, true, false, nil, nil, true, nil, "Delivery", deliveryInfo:getItemNo())
    end
  end
end
deliveryInformation:init()
deliveryInformation:registEventHandler()
deliveryInformation:registMessageHandler()

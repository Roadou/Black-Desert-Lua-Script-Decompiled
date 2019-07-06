Panel_Window_Delivery_CarriageInformation:ActiveMouseEventEffect(true)
Panel_Window_Delivery_CarriageInformation:setMaskingChild(true)
Panel_Window_Delivery_CarriageInformation:setGlassBackground(true)
Panel_Window_Delivery_CarriageInformation:RegisterShowEventFunc(true, "DeliveryCarriageInformationShowAni()")
Panel_Window_Delivery_CarriageInformation:RegisterShowEventFunc(false, "DeliveryCarriageInformationHideAni()")
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
function DeliveryCarriageInformationShowAni()
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
function DeliveryCarriageInformationHideAni()
  Panel_Window_Delivery_CarriageInformation:ChangeSpecialTextureInfoName("")
  Panel_Window_Delivery_CarriageInformation:SetAlpha(1)
  UIAni.AlphaAnimation(0, Panel_Window_Delivery_CarriageInformation, 0, 0.1)
end
local deliveryCarriageInformation = {
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true
  },
  config = {
    slotCount = 4,
    slotStartX = 15,
    slotStartY = 60,
    slotGapY = 65,
    slotIconStartX = 5,
    slotIconStartY = 8,
    slotCarriageTypeStartX = 88,
    slotCarriageTypeStartY = 8,
    slotDepartureStartX = 65,
    slotDepartureStartY = 21,
    slotDestinationStartX = 215,
    slotDestinationStartY = 21,
    slotArrowStartX = 180,
    slotArrowStartY = 23,
    slotButtonStartX = 330,
    slotButtonStartY = 5
  },
  const = {
    deliveryProgressTypeRequest = 0,
    deliveryProgressTypeIng = 1,
    deliveryProgressTypeComplete = 2
  },
  panel_Background = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "Static_Bakcground"),
  button_Close = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "Button_Close"),
  _buttonQuestion = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "Button_Question"),
  empty_List = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "StaticText_Empty_List"),
  scroll = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "Scroll_1"),
  slots = Array.new(),
  startSlotNo = 0
}
function deliveryCarriageInformation:registMessageHandler()
end
function deliveryCarriageInformation:registEventHandler()
  UIScroll.InputEvent(self.scroll, "DeliveryCarriageInformation_ScrollEvent")
  UIScroll.InputEventByControl(self.panel_Background, "DeliveryCarriageInformation_ScrollEvent")
  self.button_Close:addInputEvent("Mouse_LUp", "DeliveryCarriageInformationWindow_Close()")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"DeliveryCarriageinformation\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"DeliveryCarriageinformation\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"DeliveryCarriageinformation\", \"false\")")
end
function deliveryCarriageInformation:init()
  local static_Slot = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "Static_Slot")
  local static_Item = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "Static_ItemIcon")
  local static_Arrow = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "Static_Arrow")
  local staticText_Departure = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "StaticText_Departure")
  local staticText_Destination = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "StaticText_Destination")
  UI.ASSERT(nil ~= self.panel_Background and "number" ~= type(self.panel_Background), "Static_Bakcground")
  UI.ASSERT(nil ~= self.button_Close and "number" ~= type(self.button_Close), "Button_Close")
  UI.ASSERT(nil ~= self.scroll and "number" ~= type(self.scroll), "Scroll_1")
  UI.ASSERT(nil ~= static_Slot and "number" ~= type(static_Slot), "Static_Slot")
  UI.ASSERT(nil ~= static_Item and "number" ~= type(static_Item), "Static_ItemIcon")
  UI.ASSERT(nil ~= static_Arrow and "number" ~= type(static_Arrow), "Static_Arrow")
  UI.ASSERT(nil ~= staticText_Departure and "number" ~= type(staticText_Departure), "StaticText_Departure")
  UI.ASSERT(nil ~= staticText_Destination and "number" ~= type(staticText_Destination), "StaticText_Destination")
  for ii = 0, self.config.slotCount - 1 do
    local slot = {}
    slot.slotNo = ii
    slot.panel = Panel_Window_Delivery_CarriageInformation
    slot.base = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_Delivery_CarriageInformation, "Delivery_Slot_" .. slot.slotNo)
    CopyBaseProperty(static_Slot, slot.base)
    slot.departure = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.base, "Delivery_Slot_Departure_" .. slot.slotNo)
    CopyBaseProperty(staticText_Departure, slot.departure)
    slot.destination = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.base, "Delivery_Slot_Destination_" .. slot.slotNo)
    CopyBaseProperty(staticText_Destination, slot.destination)
    slot.static_Arrow = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, slot.base, "Delivery_Slot_Arrow_" .. slot.slotNo)
    CopyBaseProperty(static_Arrow, slot.static_Arrow)
    slot.icon = {}
    SlotItem.new(slot.icon, "Delivery_Slot_Icon_" .. slot.slotNo, slot.slotNo, slot.base, self.slotConfig)
    slot.icon:createChild()
    slot.base:SetPosX(self.config.slotStartX)
    slot.base:SetPosY(self.config.slotStartY + self.config.slotGapY * slot.slotNo)
    slot.icon.icon:SetPosX(self.config.slotIconStartX)
    slot.icon.icon:SetPosY(self.config.slotIconStartY)
    slot.static_Arrow:SetIgnore(true)
    slot.base:SetShow(true)
    slot.icon.icon:SetShow(true)
    slot.icon.icon:SetEnable(true)
    slot.departure:SetShow(true)
    slot.destination:SetShow(true)
    slot.static_Arrow:SetShow(true)
    UIScroll.InputEventByControl(slot.base, "DeliveryCarriageInformation_ScrollEvent")
    UIScroll.InputEventByControl(slot.icon.icon, "DeliveryCarriageInformation_ScrollEvent")
    slot.icon.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. ii .. ", \"DeliveryCarriageInformation\",true)")
    slot.icon.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. ii .. ", \"DeliveryCarriageInformation\",false)")
    Panel_Tooltip_Item_SetPosition(ii, slot.icon, "DeliveryCarriageInformation")
    slot.base:SetShow(false)
    self.slots[ii] = slot
  end
  self.scroll:SetControlPos(0)
end
function deliveryCarriageInformation:updateSlot()
  for ii = 0, self.config.slotCount - 1 do
    local slot = self.slots[ii]
    slot.slotNo = -1
    slot.base:SetShow(false)
  end
  local deliveryList = deliveryCarriage_dlieveryList(self.objectID)
  if nil == deliveryList then
    self.empty_List:SetShow(true)
    return
  else
    self.empty_List:SetShow(false)
  end
  local deliveryCount = deliveryList:size()
  if 0 == deliveryCount then
    self.empty_List:SetShow(true)
    return
  else
    self.empty_List:SetShow(false)
  end
  local showSlot = 0
  for ii = self.startSlotNo, deliveryCount - 1 do
    if showSlot < self.config.slotCount then
      local deliveryInfo = deliveryList:atPointer(ii)
      if nil ~= deliveryInfo then
        local itemWrapper = deliveryInfo:getItemWrapper(ii)
        if nil ~= itemWrapper then
          local slot = self.slots[showSlot]
          slot.icon:setItem(itemWrapper)
          slot.slotNo = ii
          slot.departure:SetText(deliveryInfo:getFromRegionName(ii))
          slot.destination:SetText(deliveryInfo:getToRegionName(ii))
          slot.base:SetShow(true)
          showSlot = showSlot + 1
          slot.departure:SetPosX(slot.icon.icon:GetPosX() + slot.icon.icon:GetSizeX() + 10)
          slot.departure:SetPosY(self.config.slotDepartureStartY)
          slot.static_Arrow:SetPosX(slot.departure:GetPosX() + slot.departure:GetTextSizeX() + 10)
          slot.static_Arrow:SetPosY(self.config.slotArrowStartY)
          slot.destination:SetPosX(slot.static_Arrow:GetPosX() + slot.static_Arrow:GetSizeX() + 10)
          slot.destination:SetPosY(self.config.slotDestinationStartY)
        end
      end
    end
  end
  UIScroll.SetButtonSize(self.scroll, self.config.slotCount, deliveryCount)
end
function DeliveryCarriageInformation_ScrollEvent(isScrollUp)
  local self = deliveryCarriageInformation
  local deliveryList = deliveryCarriage_dlieveryList(self.objectID)
  if nil == deliveryList then
    return
  end
  local deliveryCount = deliveryList:size()
  self.startSlotNo = UIScroll.ScrollEvent(self.scroll, isScrollUp, self.config.slotCount, deliveryCount, self.startSlotNo, 1)
  self:updateSlot()
end
function DeliveryCarriageInformationWindow_Open(objectID)
  local deliveryList = deliveryCarriage_dlieveryList(objectID)
  if nil == deliveryList then
    return
  end
  Panel_Window_Delivery_CarriageInformation:ChangeSpecialTextureInfoName("")
  Panel_Window_Delivery_CarriageInformation:SetAlphaExtraChild(1)
  Panel_Window_Delivery_CarriageInformation:SetShow(true, false)
  local self = deliveryCarriageInformation
  self.startSlotNo = 0
  self.objectID = objectID
  self:updateSlot()
  self.scroll:SetControlPos(0)
end
function DeliveryCarriageInformationWindow_Close()
  if Panel_Window_Delivery_CarriageInformation:GetShow() then
    Panel_Window_Delivery_CarriageInformation:ChangeSpecialTextureInfoName("")
    Panel_Window_Delivery_CarriageInformation:SetShow(false, false)
  end
end
function DeliveryCarriageInformation_SlotIndex(slotNo)
  local self = deliveryCarriageInformation
  return self.slots[slotNo].slotNo
end
function DeliveryCarriageInformation_ObjectID()
  local self = deliveryCarriageInformation
  return self.objectID
end
deliveryCarriageInformation:init()
deliveryCarriageInformation:registEventHandler()
deliveryCarriageInformation:registMessageHandler()

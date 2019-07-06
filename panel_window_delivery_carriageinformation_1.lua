function PaGlobal_CarriageInformation:initialize()
  if true == PaGlobal_CarriageInformation._initialize then
    return
  end
  Panel_Window_Delivery_CarriageInformation:ActiveMouseEventEffect(true)
  Panel_Window_Delivery_CarriageInformation:setMaskingChild(true)
  Panel_Window_Delivery_CarriageInformation:setGlassBackground(true)
  PaGlobal_CarriageInformation._ui.panelBackground = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "Static_Bakcground")
  PaGlobal_CarriageInformation._ui.buttonClose = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "Button_Close")
  PaGlobal_CarriageInformation._ui.buttonQuestion = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "Button_Question")
  PaGlobal_CarriageInformation._ui.emptyList = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "StaticText_Empty_List")
  PaGlobal_CarriageInformation._ui.scroll = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "Scroll_1")
  PaGlobal_CarriageInformation._ui.txt_Title = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "StaticText_Title")
  PaGlobal_CarriageInformation._ui.stc_Slot = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "Static_Slot")
  PaGlobal_CarriageInformation._ui.stc_Arrow = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "Static_Arrow")
  PaGlobal_CarriageInformation._ui.txt_Departure = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "StaticText_Departure")
  PaGlobal_CarriageInformation._ui.txt_Destination = UI.getChildControl(Panel_Window_Delivery_CarriageInformation, "StaticText_Destination")
  for ii = 0, PaGlobal_CarriageInformation.config.slotCount - 1 do
    local slot = {}
    slot.slotNo = ii
    slot.panel = Panel_Window_Delivery_CarriageInformation
    slot.base = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_Delivery_CarriageInformation, "Delivery_Slot_" .. slot.slotNo)
    CopyBaseProperty(PaGlobal_CarriageInformation._ui.stc_Slot, slot.base)
    slot.departure = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.base, "Delivery_Slot_Departure_" .. slot.slotNo)
    CopyBaseProperty(PaGlobal_CarriageInformation._ui.txt_Departure, slot.departure)
    slot.destination = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.base, "Delivery_Slot_Destination_" .. slot.slotNo)
    CopyBaseProperty(PaGlobal_CarriageInformation._ui.txt_Destination, slot.destination)
    slot.static_Arrow = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, slot.base, "Delivery_Slot_Arrow_" .. slot.slotNo)
    CopyBaseProperty(PaGlobal_CarriageInformation._ui.stc_Arrow, slot.static_Arrow)
    slot.icon = {}
    SlotItem.new(slot.icon, "Delivery_Slot_Icon_" .. slot.slotNo, slot.slotNo, slot.base, PaGlobal_CarriageInformation.slotConfig)
    slot.icon:createChild()
    slot.base:SetPosX(PaGlobal_CarriageInformation.config.slotStartX)
    slot.base:SetPosY(PaGlobal_CarriageInformation.config.slotStartY + PaGlobal_CarriageInformation.config.slotGapY * slot.slotNo)
    slot.icon.icon:SetPosX(PaGlobal_CarriageInformation.config.slotIconStartX)
    slot.icon.icon:SetPosY(PaGlobal_CarriageInformation.config.slotIconStartY)
    slot.static_Arrow:SetIgnore(true)
    slot.base:SetShow(true)
    slot.icon.icon:SetShow(true)
    slot.icon.icon:SetEnable(true)
    slot.departure:SetShow(true)
    slot.destination:SetShow(true)
    slot.static_Arrow:SetShow(true)
    UIScroll.InputEventByControl(slot.base, "HandleEventScroll_DeliveryCarriageInformation_UpdateSlot")
    UIScroll.InputEventByControl(slot.icon.icon, "HandleEventScroll_DeliveryCarriageInformation_UpdateSlot")
    slot.icon.icon:addInputEvent("Mouse_On", "HandleEventMO_DeliveryCarriageInformation_ShowItemTooltip(" .. ii .. ",true)")
    slot.icon.icon:addInputEvent("Mouse_Out", "HandleEventMO_DeliveryCarriageInformation_ShowItemTooltip(" .. ii .. ",false)")
    Panel_Tooltip_Item_SetPosition(ii, slot.icon, "DeliveryCarriageInformation")
    slot.base:SetShow(false)
    PaGlobal_CarriageInformation.slots[ii] = slot
  end
  PaGlobal_CarriageInformation._ui.scroll:SetControlPos(0)
  PaGlobal_CarriageInformation:registEventHandler()
  PaGlobal_CarriageInformation:validate()
  PaGlobal_CarriageInformation._initialize = true
end
function PaGlobal_CarriageInformation:registEventHandler()
  if nil == Panel_Window_Delivery_CarriageInformation then
    return
  end
  UIScroll.InputEvent(PaGlobal_CarriageInformation._ui.scroll, "HandleEventScroll_DeliveryCarriageInformation_UpdateSlot")
  UIScroll.InputEventByControl(PaGlobal_CarriageInformation._ui.panelBackground, "HandleEventScroll_DeliveryCarriageInformation_UpdateSlot")
  PaGlobal_CarriageInformation._ui.buttonClose:addInputEvent("Mouse_LUp", "DeliveryCarriageInformationWindow_Close()")
  PaGlobal_CarriageInformation._ui.buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"DeliveryCarriageinformation\" )")
  PaGlobal_CarriageInformation._ui.buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"DeliveryCarriageinformation\", \"true\")")
  PaGlobal_CarriageInformation._ui.buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"DeliveryCarriageinformation\", \"false\")")
  Panel_Window_Delivery_CarriageInformation:RegisterShowEventFunc(true, "PaGlobal_DeliveryCarriageInformation_ShowAni()")
  Panel_Window_Delivery_CarriageInformation:RegisterShowEventFunc(false, "PaGlobal_DeliveryCarriageInformation_HideAni()")
end
function PaGlobal_CarriageInformation:prepareOpen(objectID)
  UI.ASSERT_NAME(nil ~= objectID, "PaGlobal_CarriageInformation:prepareOpen objectID nil", "\234\185\128\236\157\152\236\167\132")
  if nil == Panel_Window_Delivery_CarriageInformation then
    return
  end
  local deliveryList = ToClient_NewDeliveryGetDelivererByObjectId(objectID)
  if nil == deliveryList then
    return
  end
  PaGlobal_CarriageInformation._ui.txt_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DELIVERYNEW_CARRIAGETITLE_WITHINDEX", "number", deliveryList:getDeliveryIndex() + 1))
  Panel_Window_Delivery_CarriageInformation:ChangeSpecialTextureInfoName("")
  Panel_Window_Delivery_CarriageInformation:SetAlphaExtraChild(1)
  PaGlobal_CarriageInformation.startSlotNo = 0
  PaGlobal_CarriageInformation._objectID = objectID
  PaGlobal_CarriageInformation:updateSlot()
  PaGlobal_CarriageInformation._ui.scroll:SetControlPos(0)
  PaGlobal_CarriageInformation:open()
end
function PaGlobal_CarriageInformation:open()
  if nil == Panel_Window_Delivery_CarriageInformation then
    return
  end
  Panel_Window_Delivery_CarriageInformation:SetShow(true, false)
end
function PaGlobal_CarriageInformation:prepareClose()
  if nil == Panel_Window_Delivery_CarriageInformation then
    return
  end
  if false == Panel_Window_Delivery_CarriageInformation:GetShow() then
    return
  end
  Panel_Window_Delivery_CarriageInformation:ChangeSpecialTextureInfoName("")
  PaGlobal_CarriageInformation:close()
end
function PaGlobal_CarriageInformation:close()
  if nil == Panel_Window_Delivery_CarriageInformation then
    return
  end
  Panel_Window_Delivery_CarriageInformation:SetShow(false, false)
end
function PaGlobal_CarriageInformation:validate()
  if nil == Panel_Window_Delivery_CarriageInformation then
    return
  end
  PaGlobal_CarriageInformation._ui.panelBackground:isValidate()
  PaGlobal_CarriageInformation._ui.buttonClose:isValidate()
  PaGlobal_CarriageInformation._ui.buttonQuestion:isValidate()
  PaGlobal_CarriageInformation._ui.emptyList:isValidate()
  PaGlobal_CarriageInformation._ui.scroll:isValidate()
end
function PaGlobal_CarriageInformation:updateSlot()
  if nil == Panel_Window_Delivery_CarriageInformation then
    return
  end
  for ii = 0, PaGlobal_CarriageInformation.config.slotCount - 1 do
    local slot = PaGlobal_CarriageInformation.slots[ii]
    slot.slotNo = -1
    slot.base:SetShow(false)
  end
  local delivererInfo = ToClient_NewDeliveryGetDelivererByObjectId(PaGlobal_CarriageInformation._objectID)
  if nil == delivererInfo then
    PaGlobal_CarriageInformation._ui.emptyList:SetShow(true)
    return
  else
    PaGlobal_CarriageInformation._ui.emptyList:SetShow(false)
  end
  local deliveryCount = delivererInfo:getDeliveryItemCount()
  if 0 == deliveryCount then
    PaGlobal_CarriageInformation._ui.emptyList:SetShow(true)
    return
  else
    PaGlobal_CarriageInformation._ui.emptyList:SetShow(false)
  end
  local showSlot = 0
  for ii = PaGlobal_CarriageInformation.startSlotNo, deliveryCount - 1 do
    if showSlot < PaGlobal_CarriageInformation.config.slotCount then
      local itemWrapper = delivererInfo:getDeliveryItemWrapper(ii)
      if nil ~= itemWrapper then
        local slot = PaGlobal_CarriageInformation.slots[showSlot]
        slot.icon:setItem(itemWrapper)
        slot.slotNo = ii
        slot.departure:SetText(ToClient_regionKeyToName(delivererInfo:getFromRegionKey()))
        slot.destination:SetText(ToClient_regionKeyToName(delivererInfo:getToRegionKey()))
        slot.base:SetShow(true)
        showSlot = showSlot + 1
        slot.departure:SetPosX(slot.icon.icon:GetPosX() + slot.icon.icon:GetSizeX() + 10)
        slot.departure:SetPosY(PaGlobal_CarriageInformation.config.slotDepartureStartY)
        slot.static_Arrow:SetPosX(slot.departure:GetPosX() + slot.departure:GetTextSizeX() + 10)
        slot.static_Arrow:SetPosY(PaGlobal_CarriageInformation.config.slotArrowStartY)
        slot.destination:SetPosX(slot.static_Arrow:GetPosX() + slot.static_Arrow:GetSizeX() + 10)
        slot.destination:SetPosY(PaGlobal_CarriageInformation.config.slotDestinationStartY)
      end
    end
  end
  UIScroll.SetButtonSize(PaGlobal_CarriageInformation._ui.scroll, PaGlobal_CarriageInformation.config.slotCount, deliveryCount)
end
function DeliveryCarriageInformation_SlotIndex(slotNo)
  if nil == Panel_Window_Delivery_CarriageInformation then
    return
  end
  UI.ASSERT_NAME(nil ~= slotNo, "DeliveryCarriageInformation_SlotIndex slotNo nil", "\234\185\128\236\157\152\236\167\132")
  return PaGlobal_CarriageInformation.slots[slotNo].slotNo
end
function DeliveryCarriageInformation_ObjectID()
  if nil == Panel_Window_Delivery_CarriageInformation then
    return
  end
  return PaGlobal_CarriageInformation._objectID
end

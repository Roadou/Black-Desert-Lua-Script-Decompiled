function PaGlobal_InformationView:initialize()
  if true == PaGlobal_InformationView._initialize then
    return
  end
  Panel_Window_Delivery_InformationView:ActiveMouseEventEffect(true)
  Panel_Window_Delivery_InformationView:setMaskingChild(true)
  Panel_Window_Delivery_InformationView:setGlassBackground(true)
  PaGlobal_InformationView._ui._staticBackground = UI.getChildControl(Panel_Window_Delivery_InformationView, "Static_Bakcground")
  PaGlobal_InformationView._ui._buttonClose = UI.getChildControl(Panel_Window_Delivery_InformationView, "Button_Win_Close")
  PaGlobal_InformationView._ui._buttonQuestion = UI.getChildControl(Panel_Window_Delivery_InformationView, "Button_Question")
  PaGlobal_InformationView._ui._buttonRefresh = UI.getChildControl(Panel_Window_Delivery_InformationView, "Button_Refresh")
  PaGlobal_InformationView._ui._textCount = UI.getChildControl(Panel_Window_Delivery_InformationView, "StaticText_DeliveryCount")
  PaGlobal_InformationView._ui._defaultNotify = UI.getChildControl(Panel_Window_Delivery_InformationView, "StaticText_Empty_List")
  PaGlobal_InformationView._ui.list2 = UI.getChildControl(Panel_Window_Delivery_InformationView, "List2_DeliveryItemListView")
  PaGlobal_InformationView._ui.emptyList = UI.getChildControl(Panel_Window_Delivery_InformationView, "StaticText_Empty_List")
  local minSize = float2()
  minSize.x = 100
  minSize.y = 50
  local list2_Content = UI.getChildControl(PaGlobal_InformationView._ui.list2, "List2_1_Content")
  local slot = {}
  PaGlobal_InformationView._ui.list2:setMinScrollBtnSize(minSize)
  local list2_ItemSlot = UI.getChildControl(list2_Content, "Static_List2_Slot")
  SlotItem.new(slot, "DeliveryView_Slot_Icon_", 0, list2_ItemSlot, PaGlobal_InformationView.slotConfig)
  slot:createChild()
  slot.icon:SetPosX(4)
  slot.icon:SetPosY(1)
  PaGlobal_InformationView._ui.list2:changeAnimationSpeed(10)
  PaGlobal_InformationView._ui.list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "DeliveryView_ListControlCreate_New")
  PaGlobal_InformationView._ui.list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  PaGlobal_InformationView:registEventHandler()
  PaGlobal_InformationView:validate()
  PaGlobal_InformationView._initialize = true
end
function PaGlobal_InformationView:registEventHandler()
  if nil == Panel_Window_Delivery_InformationView then
    return
  end
  registerEvent("EventDeliveryInfoUpdate", "PaGlobalFunc_DeliveryInformationView_Update")
  registerEvent("FromClient_MoveDeliveryItem", "PaGlobalFunc_DeliveryInformationView_Update")
  PaGlobal_InformationView._ui._buttonClose:addInputEvent("Mouse_LUp", "DeliveryInformationView_Close()")
  PaGlobal_InformationView._ui._buttonRefresh:addInputEvent("Mouse_LUp", "HandleEventLUp_DeliveryInformationView_Refresh()")
  PaGlobal_InformationView._ui._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"DeliveryInformation\" )")
  PaGlobal_InformationView._ui._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"DeliveryInformation\", \"true\")")
  PaGlobal_InformationView._ui._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"DeliveryInformation\", \"false\")")
end
function PaGlobal_InformationView:prepareOpen()
  if nil == Panel_Window_Delivery_InformationView then
    return
  end
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
  PaGlobalFunc_DeliveryInformationView_Update()
  Panel_Window_Delivery_InformationView:SetAlphaExtraChild(1)
  PaGlobal_InformationView:open()
end
function PaGlobal_InformationView:open()
  if nil == Panel_Window_Delivery_InformationView then
    return
  end
  Panel_Window_Delivery_InformationView:SetShow(true, true)
end
function PaGlobal_InformationView:prepareClose()
  if nil == Panel_Window_Delivery_InformationView then
    return
  end
  if false == Panel_Window_Delivery_InformationView:GetShow() then
    return
  end
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:pop()
  end
  Panel_Window_Delivery_InformationView:ChangeSpecialTextureInfoName("")
  Panel_Window_Delivery_Information:close()
end
function PaGlobal_InformationView:close()
  if nil == Panel_Window_Delivery_InformationView then
    return
  end
  Panel_Window_Delivery_InformationView:SetShow(false, false)
end
function PaGlobal_InformationView:update()
  if nil == Panel_Window_Delivery_InformationView then
    return
  end
  PaGlobal_InformationView._ui._defaultNotify:SetShow(true)
  local deliveryCount = ToClient_NewDeliveryListSize()
  PaGlobal_InformationView._ui._textCount:SetText("(" .. deliveryCount .. "/" .. PaGlobal_InformationView._slotMaxSize .. ")")
  PaGlobal_InformationView._ui.list2:moveIndex(deliveryCount)
  PaGlobal_InformationView._ui.list2:getElementManager():clearKey()
  if 0 == deliveryCount then
    PaGlobal_InformationView._ui.emptyList:SetShow(true)
    return
  end
  local delivererCount = ToClient_NewDeliveryGetDelivererCount()
  for ii = 0, delivererCount - 1 do
    local delivererInfo = ToClient_NewDeliveryGetDeliverer(ii)
    if nil ~= delivererInfo then
      local itemCount = delivererInfo:getDeliveryItemCount()
      for itemIdx = 0, itemCount - 1 do
        PaGlobal_InformationView._ui.list2:getElementManager():pushKey(toInt64(0, itemIdx * 10 + ii))
      end
    end
  end
  PaGlobal_InformationView._ui._defaultNotify:SetShow(false)
  PaGlobal_InformationView._ui.list2:moveTopIndex()
end
function PaGlobal_InformationView:validate()
  if nil == Panel_Window_Delivery_InformationView then
    return
  end
  PaGlobal_InformationView._ui._staticBackground:isValidate()
  PaGlobal_InformationView._ui._buttonClose:isValidate()
  PaGlobal_InformationView._ui._buttonQuestion:isValidate()
  PaGlobal_InformationView._ui._buttonRefresh:isValidate()
  PaGlobal_InformationView._ui._textCount:isValidate()
  PaGlobal_InformationView._ui._defaultNotify:isValidate()
  PaGlobal_InformationView._ui.list2:isValidate()
end
function DeliveryView_ListControlCreate_New(content, key)
  UI.ASSERT_NAME(nil ~= content, "DeliveryView_ListControlCreate content nil", "\236\157\180\236\136\152\236\162\133")
  UI.ASSERT_NAME(nil ~= key, "DeliveryView_ListControlCreate key nil", "\236\157\180\236\136\152\236\162\133")
  if nil == Panel_Window_Delivery_InformationView then
    return
  end
  local slotKey = Int64toInt32(key)
  local delivererIndex = slotKey % 10
  local itemIndex = math.floor(slotKey / 10)
  local delivererInfo = ToClient_NewDeliveryGetDeliverer(delivererIndex)
  if nil == delivererInfo then
    return
  end
  local itemWrapper = delivererInfo:getDeliveryItemWrapper(itemIndex)
  if nil == itemWrapper then
    return
  end
  local itemBG = UI.getChildControl(content, "Static_List2_ItemBG")
  itemBG:SetPosX(5)
  itemBG:SetPosY(5)
  local slot = {}
  local itemSlot = UI.getChildControl(content, "Static_List2_Slot")
  itemSlot:SetShow(true)
  itemSlot:SetPosX(8)
  itemSlot:SetPosY(17)
  itemSlot:SetSize(40, 40)
  SlotItem.reInclude(slot, "DeliveryView_Slot_Icon_", 0, itemSlot, PaGlobal_InformationView.slotConfig)
  slot:setItem(itemWrapper)
  local remainTime = UI.getChildControl(content, "StaticText_List2_CarriageType")
  local registerTime = delivererInfo:getRegisterDate()
  local deliveryTime = toInt64(0, delivererInfo:getDeliveryTime())
  local currentTime = getServerUtc64()
  local leftTime = delivererInfo:getRemainTime()
  remainTime:SetShow(true)
  remainTime:SetShow(true)
  remainTime:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  if 0 ~= leftTime then
    remainTime:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DELIVERY_REMAINTIME", "number", tostring(delivererIndex + 1) .. "", "time", Util.Time.timeFormatting_Minute(leftTime)))
  else
    remainTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DELIVERYNEW_NUMBEROF_CARRIAGE", "number", tostring(delivererIndex + 1)))
  end
  if true == remainTime:IsLimitText() then
    remainTime:addInputEvent("Mouse_On", "InputMLOn_DeliveryInformationView_RemainTimeTooltip(" .. slotKey .. ", true)")
    remainTime:addInputEvent("Mouse_Out", "InputMLOn_DeliveryInformationView_RemainTimeTooltip(" .. slotKey .. ", false)")
  end
  local departure = UI.getChildControl(content, "StaticText_List2_Departure")
  departure:SetShow(true)
  departure:SetText(ToClient_regionKeyToName(delivererInfo:getFromRegionKey()))
  departure:SetPosY(17)
  local destination = UI.getChildControl(content, "StaticText_List2_Destination")
  destination:SetShow(true)
  destination:SetText(ToClient_regionKeyToName(delivererInfo:getToRegionKey()))
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
  local currentTime = getServerUtc64()
  btn_Ready:SetShow(false)
  btn_Ing:SetShow(false)
  btn_Complete:SetShow(false)
  if true == delivererInfo:isCancelable(delivererInfo:getToRegionKey(), currentTime) then
    btn_Ready:SetShow(true)
  elseif true == delivererInfo:isReceivable(delivererInfo:getToRegionKey(), currentTime) then
    btn_Complete:SetShow(true)
  else
    btn_Ing:SetShow(true)
  end
  local arrow = UI.getChildControl(content, "Static_List2_Arrow")
  arrow:SetShow(true)
  arrow:SetPosX(departure:GetPosX() + departure:GetTextSizeX() + 10)
  arrow:SetPosY(departure:GetPosY() + 2)
  destination:SetPosX(arrow:GetPosX() + arrow:GetSizeX() + 10)
  slot.icon:addInputEvent("Mouse_On", "HandleEventMO_DeliveryInformationView_TooltipShow(" .. slotKey .. ", true)")
  slot.icon:addInputEvent("Mouse_Out", "HandleEventMO_DeliveryInformationView_TooltipShow(" .. slotKey .. ", false)")
end
function InputMLOn_DeliveryInformationView_RemainTimeTooltip(key, isTrue)
  if true == isTrue then
    local control = PaGlobal_InformationView._ui.list2
    local contents = control:GetContentByKey(toInt64(0, key))
    if nil ~= contents then
      local remainTime = UI.getChildControl(contents, "StaticText_List2_CarriageType")
      TooltipSimple_Show(remainTime, "", remainTime:GetText())
    end
  else
    TooltipSimple_Hide()
  end
end

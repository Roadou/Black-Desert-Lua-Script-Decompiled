function PaGlobal_DeliveryInformation:initialize()
  if true == PaGlobal_DeliveryInformation._initialize then
    return
  end
  local _panel = Panel_Window_Delivery_Information
  PaGlobal_DeliveryInformation._ui.panelBackground = UI.getChildControl(_panel, "Static_Bakcground")
  PaGlobal_DeliveryInformation._ui.buttonClose = UI.getChildControl(_panel, "Button_Win_Close")
  PaGlobal_DeliveryInformation._ui.buttonQuestion = UI.getChildControl(_panel, "Button_Question")
  PaGlobal_DeliveryInformation._ui.buttonRequest = UI.getChildControl(_panel, "Button_Send")
  PaGlobal_DeliveryInformation._ui.rdo_information = UI.getChildControl(_panel, "RadioButton_Information")
  PaGlobal_DeliveryInformation._ui.buttonReceiveAll = UI.getChildControl(_panel, "Button_ReceiveAll")
  PaGlobal_DeliveryInformation._ui.radiobutton_transferList = UI.getChildControl(_panel, "RadioButton_Tranlist")
  PaGlobal_DeliveryInformation._ui.radiobutton_allTransferList = UI.getChildControl(_panel, "RadioButton_AllTranlist")
  PaGlobal_DeliveryInformation._ui.emptyList = UI.getChildControl(_panel, "StaticText_Empty_List")
  PaGlobal_DeliveryInformation._ui.list2 = UI.getChildControl(_panel, "List2_DeliveryItemList")
  PaGlobal_DeliveryInformation._ui.check_Recieve = UI.getChildControl(_panel, "CheckButton_Recieve")
  PaGlobal_DeliveryInformation._ui.check_Cancel = UI.getChildControl(_panel, "CheckButton_Cancel")
  local minSize = float2()
  minSize.x = 100
  minSize.y = 50
  local list2 = UI.getChildControl(_panel, "List2_DeliveryItemList")
  local list2_Content = UI.getChildControl(list2, "List2_1_Content")
  local slot = {}
  list2:setMinScrollBtnSize(minSize)
  local list2_ItemSlot = UI.getChildControl(list2_Content, "Static_List2_Slot")
  SlotItem.new(slot, "Delivery_Slot_Icon_", 0, list2_ItemSlot, PaGlobal_DeliveryInformation.slotConfig)
  slot:createChild()
  slot.icon:SetPosX(9)
  slot.icon:SetPosY(9)
  PaGlobal_DeliveryInformation._ui.list2:changeAnimationSpeed(10)
  PaGlobal_DeliveryInformation._ui.list2:registEvent(__ePAUIList2EventType_LuaChangeContent, "Delivery_ListControlCreate")
  PaGlobal_DeliveryInformation._ui.list2:createChildContent(__ePAUIList2ElementManagerType_List)
  _panel:ActiveMouseEventEffect(true)
  _panel:setMaskingChild(true)
  _panel:setGlassBackground(true)
  PaGlobal_DeliveryInformation._ui.check_Recieve:SetCheck(true)
  PaGlobal_DeliveryInformation._ui.check_Cancel:SetCheck(true)
  PaGlobal_DeliveryInformation._ui.radiobutton_transferList:SetCheck(true)
  PaGlobal_DeliveryInformation._ui.radiobutton_allTransferList:SetCheck(false)
  PaGlobal_DeliveryInformation:registEventHandler()
  PaGlobal_DeliveryInformation:validate()
  PaGlobal_DeliveryInformation._initialize = true
end
function PaGlobal_DeliveryInformation:registEventHandler()
  if nil == Panel_Window_Delivery_Information then
    return
  end
  PaGlobal_DeliveryInformation._ui.buttonClose:addInputEvent("Mouse_LUp", "DeliveryInformationWindow_Close()")
  PaGlobal_DeliveryInformation._ui.buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"DeliveryInformation\" )")
  PaGlobal_DeliveryInformation._ui.buttonRequest:addInputEvent("Mouse_LUp", "DeliveryRequestWindow_Open()")
  PaGlobal_DeliveryInformation._ui.radiobutton_transferList:addInputEvent("Mouse_LUp", "HandleEventLUp_DeliveryInformation_Refresh(1)")
  PaGlobal_DeliveryInformation._ui.radiobutton_allTransferList:addInputEvent("Mouse_LUp", "HandleEventLUp_DeliveryInformation_Refresh(2)")
  PaGlobal_DeliveryInformation._ui.buttonReceiveAll:addInputEvent("Mouse_LUp", "PaGlobalFunc_DeliveryInformation_ReceiveAll()")
  PaGlobal_DeliveryInformation._ui.buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"DeliveryInformation\", \"true\")")
  PaGlobal_DeliveryInformation._ui.buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"DeliveryInformation\", \"false\")")
  PaGlobal_DeliveryInformation._ui.check_Recieve:addInputEvent("Mouse_LUp", "HandleEventLUp_DeliveryInformation_CheckBox()")
  PaGlobal_DeliveryInformation._ui.check_Cancel:addInputEvent("Mouse_LUp", "HandleEventLUp_DeliveryInformation_CheckBox()")
  Panel_Window_Delivery_Information:RegisterShowEventFunc(true, "PaGlobal_DeliveryInformation_ShowAni()")
  Panel_Window_Delivery_Information:RegisterShowEventFunc(false, "PaGlobal_DeliveryInformation_HideAni()")
  registerEvent("FromClient_MoveDeliveryItem", "DeliveryInformation_UpdateSlotData")
  registerEvent("FromClient_DeliveryReceiveItemClear", "FromClient_DeliveryReceiveItemClear")
  registerEvent("FromClient_InActiveDeleteButton", "FromClient_DeliveryInformation_InActiveDeleteButton")
end
function PaGlobal_DeliveryInformation:prepareOpen()
  if nil == Panel_Window_Delivery_Information then
    return
  end
  if true == _ContentsGroup_RenewUI_ItemMarketPlace_Only and Panel_Window_MarketPlace_WalletInventory:GetShow() then
    PaGlobalFunc_MarketWallet_ForceClose()
  end
  DeliveryRequestWindow_Close()
  Warehouse_SetIgnoreMoneyButton(true)
  PaGlobal_DeliveryInformation._ui.radiobutton_transferList:SetCheck(true)
  PaGlobal_DeliveryInformation._ui.radiobutton_allTransferList:SetCheck(false)
  PaGlobal_DeliveryInformation._ui.rdo_information:SetCheck(true)
  if not Panel_Window_Delivery_Information:IsShow() then
    Panel_Window_Delivery_Information:SetAlphaExtraChild(1)
    Panel_Window_Delivery_Information:SetShow(true, false)
    delivery_requsetList()
    if ToClient_WorldMapIsShow() then
      WorldMapPopupManager:increaseLayer(true)
      WorldMapPopupManager:push(Panel_Window_Delivery_Information, true)
    end
  end
  PaGlobal_DeliveryInformation:updateSlot()
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
  PaGlobal_DeliveryInformation._ui.list2:moveTopIndex()
  PaGlobal_DeliveryInformation.scrollIndex = 0
  FGlobal_WarehouseTownListCheck()
end
function PaGlobal_DeliveryInformation:open()
  if nil == Panel_Window_Delivery_Information then
    return
  end
end
function PaGlobal_DeliveryInformation:prepareClose()
  if nil == Panel_Window_Delivery_Information then
    return
  end
  PaGlobal_DeliveryInformation._ui.list2:getElementManager():clearKey()
  PaGlobal_DeliveryInformation._ui.radiobutton_transferList:SetCheck(true)
  PaGlobal_DeliveryInformation._ui.radiobutton_allTransferList:SetCheck(false)
  PaGlobal_DeliveryInformation:close()
end
function PaGlobal_DeliveryInformation:close()
  if nil == Panel_Window_Delivery_Information then
    return
  end
  if ToClient_WorldMapIsShow() then
    if Panel_Window_Delivery_Information:GetShow() then
      WorldMapPopupManager:pop()
    end
  elseif Panel_Window_Delivery_Information:GetShow() then
    Panel_Window_Delivery_Information:ChangeSpecialTextureInfoName("")
    Panel_Window_Delivery_Information:SetShow(false, false)
    WorldMapPopupManager:pop()
  end
end
function PaGlobal_DeliveryInformation:updateSlot()
  if nil == Panel_Window_Delivery_Information then
    return
  end
  PaGlobal_DeliveryInformation._ui.emptyList:SetShow(false)
  PaGlobal_DeliveryInformation._ui.list2:getElementManager():clearKey()
  PaGlobal_DeliveryInformation._ui.check_Recieve:SetShow(PaGlobal_DeliveryInformation._ui.radiobutton_transferList:IsCheck())
  PaGlobal_DeliveryInformation._ui.check_Cancel:SetShow(PaGlobal_DeliveryInformation._ui.radiobutton_transferList:IsCheck())
  local delivererCount = ToClient_NewDeliveryGetDelivererCount()
  if PaGlobal_DeliveryInformation._ui.radiobutton_transferList:IsCheck() then
    local regionKey = ToClient_NewDeliveryGetRegionKey(PaGlobal_DeliveryInformation.currentWaypointKey)
    local deliveryCount = ToClient_NewDeliveryListSizeByRegionKey(regionKey)
    if 0 == deliveryCount then
      PaGlobal_DeliveryInformation._ui.emptyList:SetShow(true)
      return
    end
    for ii = 0, delivererCount - 1 do
      local delivererInfo = ToClient_NewDeliveryGetDeliverer(ii)
      if nil ~= delivererInfo then
        local currentTime = getServerUtc64()
        if regionKey:get() == delivererInfo:getFromRegionKey():get() then
          if true == delivererInfo:isCancelable(regionKey, currentTime) and true == PaGlobal_DeliveryInformation._ui.check_Cancel:IsCheck() then
            local itemCount = delivererInfo:getDeliveryItemCount()
            for itemIdx = 0, itemCount - 1 do
              PaGlobal_DeliveryInformation._ui.list2:getElementManager():pushKey(toInt64(0, itemIdx * 10 + ii))
            end
          end
        elseif regionKey:get() == delivererInfo:getToRegionKey():get() and true == delivererInfo:isReceivable(regionKey, currentTime) and true == PaGlobal_DeliveryInformation._ui.check_Recieve:IsCheck() then
          local itemCount = delivererInfo:getDeliveryItemCount()
          for itemIdx = 0, itemCount - 1 do
            PaGlobal_DeliveryInformation._ui.list2:getElementManager():pushKey(toInt64(0, itemIdx * 10 + ii))
          end
        end
      end
    end
  else
    local deliveryCount = ToClient_NewDeliveryListSize()
    if 0 == deliveryCount then
      PaGlobal_DeliveryInformation._ui.emptyList:SetShow(true)
      return
    end
    for ii = 0, delivererCount - 1 do
      local delivererInfo = ToClient_NewDeliveryGetDeliverer(ii)
      if nil ~= delivererInfo then
        local itemCount = delivererInfo:getDeliveryItemCount()
        for itemIdx = 0, itemCount - 1 do
          PaGlobal_DeliveryInformation._ui.list2:getElementManager():pushKey(toInt64(0, itemIdx * 10 + ii))
        end
      end
    end
  end
  PaGlobal_DeliveryInformation._ui.list2:moveIndex(PaGlobal_DeliveryInformation.scrollIndex)
end
function PaGlobal_DeliveryInformation:validate()
  if nil == Panel_Window_Delivery_Information then
    return
  end
  PaGlobal_DeliveryInformation._ui.panelBackground:isValidate()
  PaGlobal_DeliveryInformation._ui.buttonClose:isValidate()
  PaGlobal_DeliveryInformation._ui.buttonQuestion:isValidate()
  PaGlobal_DeliveryInformation._ui.buttonRequest:isValidate()
  PaGlobal_DeliveryInformation._ui.rdo_information:isValidate()
  PaGlobal_DeliveryInformation._ui.buttonReceiveAll:isValidate()
  PaGlobal_DeliveryInformation._ui.radiobutton_transferList:isValidate()
  PaGlobal_DeliveryInformation._ui.radiobutton_allTransferList:isValidate()
  PaGlobal_DeliveryInformation._ui.emptyList:isValidate()
  PaGlobal_DeliveryInformation._ui.list2:isValidate()
end
function Delivery_ListControlCreate(content, key)
  UI.ASSERT_NAME(nil ~= content, "Delivery_ListControlCreate content nil", "\236\157\180\236\136\152\236\162\133")
  UI.ASSERT_NAME(nil ~= key, "Delivery_ListControlCreate key nil", "\236\157\180\236\136\152\236\162\133")
  local slotKey = Int64toInt32(key)
  local delivererIndex = slotKey % 10
  local itemIndex = math.floor(slotKey / 10)
  local currentTime = getServerUtc64()
  local regionKey = ToClient_NewDeliveryGetRegionKey(PaGlobal_DeliveryInformation.currentWaypointKey)
  local delivererInfo = ToClient_NewDeliveryGetDeliverer(delivererIndex)
  if nil == delivererInfo then
    return
  end
  local itemWrapper = delivererInfo:getDeliveryItemWrapper(itemIndex)
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
  SlotItem.reInclude(slot, "Delivery_Slot_Icon_", 0, itemSlot, PaGlobal_DeliveryInformation.slotConfig)
  slot:setItem(itemWrapper)
  local departure = UI.getChildControl(content, "StaticText_List2_Departure")
  departure:SetShow(true)
  departure:SetText(ToClient_regionKeyToName(delivererInfo:getFromRegionKey()))
  departure:SetPosX(70)
  departure:SetPosY(17)
  local arrow = UI.getChildControl(content, "Static_List2_Arrow")
  arrow:SetShow(true)
  arrow:SetPosX(departure:GetPosX() + departure:GetTextSizeX() + 10)
  arrow:SetPosY(19)
  local destination = UI.getChildControl(content, "StaticText_List2_Destination")
  destination:SetShow(true)
  destination:SetText(ToClient_regionKeyToName(delivererInfo:getToRegionKey()))
  destination:SetPosX(arrow:GetPosX() + arrow:GetSizeX() + 10)
  destination:SetPosY(17)
  local carriageNumber = UI.getChildControl(content, "StaticText_CarriageNumber")
  local leftTime = delivererInfo:getRemainTime()
  carriageNumber:SetShow(true)
  carriageNumber:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  if 0 ~= leftTime then
    carriageNumber:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DELIVERY_REMAINTIME", "number", tostring(delivererIndex + 1) .. "", "time", Util.Time.timeFormatting_Minute(leftTime)))
  else
    carriageNumber:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DELIVERYNEW_NUMBEROF_CARRIAGE", "number", tostring(delivererIndex + 1)))
  end
  if true == carriageNumber:IsLimitText() then
    carriageNumber:addInputEvent("Mouse_On", "InputMLOn_DeliveryInformation_RemainTimeTooltip(" .. slotKey .. ", true)")
    carriageNumber:addInputEvent("Mouse_Out", "InputMLOn_DeliveryInformation_RemainTimeTooltip(" .. slotKey .. ", false)")
  end
  carriageNumber:SetPosX(70)
  carriageNumber:SetPosY(40)
  local receive = UI.getChildControl(content, "Button_List2_Receive")
  receive:SetPosX(355)
  receive:SetPosY(17)
  local cancel = UI.getChildControl(content, "Button_List2_Cancel")
  cancel:SetPosX(355)
  cancel:SetPosY(17)
  local ready = UI.getChildControl(content, "Button_List2_Ready")
  ready:SetPosX(355)
  ready:SetPosY(17)
  local ing = UI.getChildControl(content, "Button_List2_Ing")
  ing:SetPosX(355)
  ing:SetPosY(17)
  local complete = UI.getChildControl(content, "Button_List2_Complete")
  complete:SetPosX(355)
  complete:SetPosY(17)
  if PaGlobal_DeliveryInformation._ui.radiobutton_transferList:IsCheck() then
    ready:SetShow(false)
    ing:SetShow(false)
    complete:SetShow(false)
    if true == delivererInfo:isCancelable(regionKey, currentTime) then
      receive:SetShow(false)
      cancel:SetShow(true)
    elseif true == delivererInfo:isReceivable(regionKey, currentTime) then
      receive:SetShow(true)
      cancel:SetShow(false)
    else
      receive:SetShow(false)
      cancel:SetShow(false)
    end
  else
    receive:SetShow(false)
    cancel:SetShow(false)
    if true == delivererInfo:isCancelable(delivererInfo:getToRegionKey(), currentTime) then
      ready:SetShow(true)
      ing:SetShow(false)
      complete:SetShow(false)
    elseif true == delivererInfo:isReceivable(delivererInfo:getToRegionKey(), currentTime) then
      ready:SetShow(false)
      ing:SetShow(false)
      complete:SetShow(true)
    else
      ready:SetShow(false)
      ing:SetShow(true)
      complete:SetShow(false)
    end
  end
  receive:addInputEvent("Mouse_LUp", "PaGlobalFunc_DeliveryInformation_Receive(" .. delivererIndex .. ", " .. itemIndex .. " )")
  cancel:addInputEvent("Mouse_LUp", "PaGlobalFunc_DeliveryInformation_Cancel(" .. delivererIndex .. ", " .. itemIndex .. ")")
  slot.icon:addInputEvent("Mouse_On", "HandleEventMO_DeliveryInformation_ItemTooltipShow(" .. delivererIndex .. ", " .. itemIndex .. ", true)")
  slot.icon:addInputEvent("Mouse_Out", "HandleEventMO_DeliveryInformation_ItemTooltipShow(" .. delivererIndex .. ", " .. itemIndex .. ", false)")
  if slotKey > PaGlobal_DeliveryInformation.scrollIndex then
    PaGlobal_DeliveryInformation.scrollIndex = slotKey - 8
  else
    PaGlobal_DeliveryInformation.scrollIndex = slotKey
  end
end
function DeliveryInformation_OpenPanelFromWorldmap(waypointKey)
  if true == Panel_Window_Delivery_Information:GetShow() then
    return
  end
  UI.ASSERT_NAME(nil ~= waypointKey, "DeliveryInformation_OpenPanelFromWorldmap waypointKey nil", "\234\185\128\236\157\152\236\167\132")
  PaGlobal_DeliveryInformation.currentWaypointKey = waypointKey
  DeliveryInformationWindow_Open()
end
function DeliveryInformation_WaypointKey()
  if nil == PaGlobal_DeliveryInformation then
    return
  end
  return PaGlobal_DeliveryInformation.currentWaypointKey
end
function DeliveryInformation_SlotIndex(slotNo)
  UI.ASSERT_NAME(nil ~= slotNo, "DeliveryInformation_SlotIndex slotNo nil", "\234\185\128\236\157\152\236\167\132")
  return slotNo
end
function DeliveryInformation_OpenPanelFromDialog()
  if nil == PaGlobal_DeliveryInformation then
    return
  end
  if nil == Panel_Window_Warehouse then
    return
  end
  PaGlobal_DeliveryInformation.currentWaypointKey = getCurrentWaypointKey()
  Warehouse_OpenPanelFromDialogWithoutInventory(getCurrentWaypointKey(), CppEnums.WarehoouseFromType.eWarehoouseFromType_Npc)
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

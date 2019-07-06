function PaGlobal_Purification_All:initialize()
  if true == PaGlobal_Purification_All._initailize then
    return
  end
  PaGlobal_Purification_All._ui._stc_Title = UI.getChildControl(Panel_Purification_All, "StaticText_Title")
  PaGlobal_Purification_All._ui._btn_Close_Pc = UI.getChildControl(PaGlobal_Purification_All._ui._stc_Title, "Button_Close_PCUI")
  PaGlobal_Purification_All._ui._stc_MainBg = UI.getChildControl(Panel_Purification_All, "Static_Bg")
  PaGlobal_Purification_All._ui._stc_ItemSlotBg = UI.getChildControl(PaGlobal_Purification_All._ui._stc_MainBg, "Static_ItemSlotBg")
  PaGlobal_Purification_All._ui._stc_ResultSlotBg = UI.getChildControl(PaGlobal_Purification_All._ui._stc_MainBg, "Static_ResultItemSlotBg")
  PaGlobal_Purification_All._ui._stc_DescBg = UI.getChildControl(PaGlobal_Purification_All._ui._stc_MainBg, "Static_Desc")
  PaGlobal_Purification_All._ui._txt_EnchantBefore = UI.getChildControl(PaGlobal_Purification_All._ui._stc_DescBg, "StaticText_Before")
  PaGlobal_Purification_All._ui._txt_EnchantAfter = UI.getChildControl(PaGlobal_Purification_All._ui._stc_DescBg, "StaticText_After")
  PaGlobal_Purification_All._ui._txt_SubDesc = UI.getChildControl(PaGlobal_Purification_All._ui._stc_DescBg, "StaticText_SubDesc")
  PaGlobal_Purification_All._ui._btn_Purify_Pc = UI.getChildControl(Panel_Purification_All, "Button_Purification_PCUI")
  PaGlobal_Purification_All._ui._stc_KeyGuide_X = UI.getChildControl(Panel_Purification_All, "Static_KeyGuide_X_ConsoleUI")
  PaGlobal_Purification_All._ui._stc_BottomBg = UI.getChildControl(Panel_Purification_All, "Static_BottomBg")
  PaGlobal_Purification_All._ui._stc_BottomDesc = UI.getChildControl(PaGlobal_Purification_All._ui._stc_BottomBg, "StaticText_Desc")
  PaGlobal_Purification_All._ui._btn_CheckAniSkip = UI.getChildControl(Panel_Purification_All, "CheckButton_Skip")
  PaGlobal_Purification_All._ui._btn_Radio_Inven = UI.getChildControl(Panel_Purification_All, "RadioButton_InvenMoney")
  PaGlobal_Purification_All._ui._txt_InvenMoney = UI.getChildControl(PaGlobal_Purification_All._ui._btn_Radio_Inven, "StaticText_InvenMoney")
  PaGlobal_Purification_All._ui._btn_Radio_Ware = UI.getChildControl(Panel_Purification_All, "RadioButton_WarehouseMoney")
  PaGlobal_Purification_All._ui._txt_WareMoney = UI.getChildControl(PaGlobal_Purification_All._ui._btn_Radio_Ware, "StaticText_WarehouseMoney")
  PaGlobal_Purification_All._ui._stc_Bottom_KeyGuides = UI.getChildControl(Panel_Purification_All, "Static_BottomButton_ConsoleUI")
  PaGlobal_Purification_All._ui._stc_KeyGuide_Cancel = UI.getChildControl(PaGlobal_Purification_All._ui._stc_Bottom_KeyGuides, "StaticText_KeyGuideCancel_ConsoleUI")
  PaGlobal_Purification_All._ui._stc_KeyGuide_Select = UI.getChildControl(PaGlobal_Purification_All._ui._stc_Bottom_KeyGuides, "StaticText_KeyGuideSelect_ConsoleUI")
  PaGlobal_Purification_All._itemSlotBg_Icon = {}
  SlotItem.new(PaGlobal_Purification_All._itemSlotBg_Icon, "feeItem", nil, PaGlobal_Purification_All._ui._stc_ItemSlotBg, PaGlobal_Purification_All._slotConfig)
  PaGlobal_Purification_All._itemSlotBg_Icon:createChild()
  PaGlobal_Purification_All._itemSlotBg_Icon:clearItem()
  PaGlobal_Purification_All._itemSlotBg_Icon.icon:SetHorizonCenter()
  PaGlobal_Purification_All._itemSlotBg_Icon.icon:SetVerticalMiddle()
  PaGlobal_Purification_All._resultSlotBg_Icon = {}
  SlotItem.new(PaGlobal_Purification_All._resultSlotBg_Icon, "resultItem", nil, PaGlobal_Purification_All._ui._stc_ResultSlotBg, PaGlobal_Purification_All._slotConfig)
  PaGlobal_Purification_All._resultSlotBg_Icon:createChild()
  PaGlobal_Purification_All._resultSlotBg_Icon:clearItem()
  PaGlobal_Purification_All._resultSlotBg_Icon.icon:SetHorizonCenter()
  PaGlobal_Purification_All._resultSlotBg_Icon.icon:SetVerticalMiddle()
  PaGlobal_Purification_All._keyGudieList = {
    PaGlobal_Purification_All._ui._stc_KeyGuide_Select,
    PaGlobal_Purification_All._ui._stc_KeyGuide_Cancel
  }
  PaGlobal_Purification_All._ui._txt_EnchantBefore:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PURIFICATION_ALL_ENCHANT_GRADE", "param", "15"))
  PaGlobal_Purification_All._ui._txt_EnchantAfter:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PURIFICATION_ALL_ENCHANT_GRADE", "param", "14"))
  PaGlobal_Purification_All._ui._stc_BottomDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_Purification_All._ui._stc_BottomDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PURIFICATION_DESC"))
  local textY = PaGlobal_Purification_All._ui._stc_BottomDesc:GetTextSizeY()
  local bottomBgSizeY = PaGlobal_Purification_All._ui._stc_BottomBg:GetSizeY()
  if textY < bottomBgSizeY then
    PaGlobal_Purification_All._ui._stc_BottomBg:SetSize(PaGlobal_Purification_All._ui._stc_BottomBg:GetSizeX(), textY + 20)
    PaGlobal_Purification_All._ui._stc_BottomDesc:SetSize(PaGlobal_Purification_All._ui._stc_BottomDesc:GetSizeX(), bottomBgSizeY - 20)
    local gap = bottomBgSizeY - PaGlobal_Purification_All._ui._stc_BottomBg:GetSizeY()
    Panel_Purification_All:SetSize(Panel_Purification_All:GetSizeX(), Panel_Purification_All:GetSizeY() - gap)
  else
    PaGlobal_Purification_All._ui._stc_BottomBg:SetSize(PaGlobal_Purification_All._ui._stc_BottomBg:GetSizeX(), PaGlobal_Purification_All._MAXBOTTOMBGSIZE)
    PaGlobal_Purification_All._ui._stc_BottomDesc:SetSize(PaGlobal_Purification_All._ui._stc_BottomDesc:GetSizeX(), PaGlobal_Purification_All._MAXBOTTOMBGSIZE - 20)
    Panel_Purification_All:SetSize(Panel_Purification_All:GetSizeX(), PaGlobal_Purification_All._MAXPANELSIZEY)
  end
  PaGlobal_Purification_All._isConsole = ToClient_isConsole()
  if true == PaGlobal_Purification_All._isConsole then
    PaGlobal_Purification_All._ui._stc_Bottom_KeyGuides:SetPosY(Panel_Purification_All:GetSizeY() - 10)
    PaGlobal_Purification_All._ui._stc_Bottom_KeyGuides:SetSpanSize(PaGlobal_Purification_All._ui._stc_Bottom_KeyGuides:GetSpanSize().x, -50)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_Purification_All._keyGudieList, PaGlobal_Purification_All._ui._stc_Bottom_KeyGuides, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
    PaGlobal_Purification_All._ui._stc_Bottom_KeyGuides:SetShow(true)
    PaGlobal_Purification_All._ui._stc_KeyGuide_X:SetShow(true)
    PaGlobal_Purification_All._ui._btn_Close_Pc:SetShow(false)
  else
    PaGlobal_Purification_All._ui._btn_Purify_Pc:SetShow(true)
    PaGlobal_Purification_All._ui._stc_Bottom_KeyGuides:SetShow(false)
    PaGlobal_Purification_All._ui._stc_KeyGuide_X:SetShow(false)
    PaGlobal_Purification_All._ui._btn_Close_Pc:SetShow(true)
  end
  PaGlobal_Purification_All._ui._btn_Radio_Inven:SetCheck(true)
  PaGlobal_Purification_All:vaildate()
  PaGlobal_Purification_All:registerEventHandler()
end
function PaGlobal_Purification_All:vaildate()
  if nil == Panel_Purification_All then
    return
  end
  PaGlobal_Purification_All._ui._stc_Title:isValidate()
  PaGlobal_Purification_All._ui._btn_Close_Pc:isValidate()
  PaGlobal_Purification_All._ui._stc_MainBg:isValidate()
  PaGlobal_Purification_All._ui._stc_ItemSlotBg:isValidate()
  PaGlobal_Purification_All._ui._stc_ResultSlotBg:isValidate()
  PaGlobal_Purification_All._ui._stc_DescBg:isValidate()
  PaGlobal_Purification_All._ui._txt_EnchantBefore:isValidate()
  PaGlobal_Purification_All._ui._txt_EnchantAfter:isValidate()
  PaGlobal_Purification_All._ui._txt_SubDesc:isValidate()
  PaGlobal_Purification_All._ui._btn_Purify_Pc:isValidate()
  PaGlobal_Purification_All._ui._stc_KeyGuide_X:isValidate()
  PaGlobal_Purification_All._ui._stc_BottomBg:isValidate()
  PaGlobal_Purification_All._ui._stc_BottomDesc:isValidate()
  PaGlobal_Purification_All._ui._btn_CheckAniSkip:isValidate()
  PaGlobal_Purification_All._ui._btn_Radio_Inven:isValidate()
  PaGlobal_Purification_All._ui._txt_InvenMoney:isValidate()
  PaGlobal_Purification_All._ui._btn_Radio_Ware:isValidate()
  PaGlobal_Purification_All._ui._txt_WareMoney:isValidate()
  PaGlobal_Purification_All._ui._stc_Bottom_KeyGuides:isValidate()
  PaGlobal_Purification_All._ui._stc_KeyGuide_Cancel:isValidate()
  PaGlobal_Purification_All._ui._stc_KeyGuide_Select:isValidate()
  PaGlobal_Purification_All._initailize = true
end
function PaGlobal_Purification_All:registerEventHandler()
  if nil ~= Panel_Purification_All and true == PaGlobal_Purification_All._initailize then
    registerEvent("onScreenResize", "FromClient_Purification_All_Resize()")
    registerEvent("EventWarehouseUpdate", "FromClient_Purification_All_MoneyUpdate()")
    registerEvent("FromClient_notifyWeakenEnchantSuccess", "FromClient_Purification_All_EnchantSuccess()")
    if true == PaGlobal_Purification_All._isConsole then
      Panel_Purification_All:registerPadEvent(__eConsoleUIPadEvent_Up_X, " HandleEventLUp_Purification_All_RequestPurification() ")
      PaGlobal_Purification_All._ui._btn_Radio_Inven:registerPadEvent(__eConsoleUIPadEvent_Up_A, " HandleEventLUp_Purification_All_CheckMoneyButton( true )")
      PaGlobal_Purification_All._ui._btn_Radio_Ware:registerPadEvent(__eConsoleUIPadEvent_Up_A, " HandleEventLUp_Purification_All_CheckMoneyButton( false )")
      PaGlobal_Purification_All._ui._stc_ItemSlotBg:registerPadEvent(__eConsoleUIPadEvent_Up_A, " HandleEventRUp_Purification_All_DataClear()")
    else
      PaGlobal_Purification_All._ui._btn_Radio_Inven:addInputEvent("Mouse_LUp", " HandleEventLUp_Purification_All_CheckMoneyButton( true )")
      PaGlobal_Purification_All._ui._btn_Radio_Ware:addInputEvent("Mouse_LUp", " HandleEventLUp_Purification_All_CheckMoneyButton( false )")
      PaGlobal_Purification_All._ui._btn_Close_Pc:addInputEvent("Mouse_LUp", "HandleEventLUp_Purification_All_Close()")
      PaGlobal_Purification_All._ui._btn_Purify_Pc:addInputEvent("Mouse_LUp", "HandleEventLUp_Purification_All_RequestPurification()")
      PaGlobal_Purification_All._ui._btn_CheckAniSkip:addInputEvent("Mouse_On", "HandleEventOnOut_Purification_All_AniButtonTooltipPC( true )")
      PaGlobal_Purification_All._ui._btn_CheckAniSkip:addInputEvent("Mouse_Out", "HandleEventOnOut_Purification_All_AniButtonTooltipPC( false )")
      PaGlobal_Purification_All._itemSlotBg_Icon.icon:addInputEvent("Mouse_On", "HandleEventOnOut_Purification_All_ShowToolTipPC( true, 0 )")
      PaGlobal_Purification_All._itemSlotBg_Icon.icon:addInputEvent("Mouse_Out", "HandleEventOnOut_Purification_All_ShowToolTipPC( false )")
      PaGlobal_Purification_All._itemSlotBg_Icon.icon:addInputEvent("Mouse_RUp", "HandleEventRUp_Purification_All_DataClear()")
      PaGlobal_Purification_All._resultSlotBg_Icon.icon:addInputEvent("Mouse_On", "HandleEventOnOut_Purification_All_ShowToolTipPC( true, 1 )")
      PaGlobal_Purification_All._resultSlotBg_Icon.icon:addInputEvent("Mouse_Out", "HandleEventOnOut_Purification_All_ShowToolTipPC( false )")
    end
  end
end
function PaGlobal_Purification_All:prepareOpen()
  if nil == Panel_Purification_All and true == Panel_Purification_All:GetShow() then
    return
  end
  warehouse_requestInfoFromNpc()
  local invenMoney = getSelfPlayer():get():getInventory():getMoney_s64()
  local wareMoney = warehouse_moneyFromNpcShop_s64()
  local fee = toInt64(0, PaGlobal_Purification_All._purificationPrice)
  if invenMoney < fee and wareMoney >= fee then
    PaGlobal_Purification_All._ui._btn_Radio_Inven:SetCheck(false)
    PaGlobal_Purification_All._ui._btn_Radio_Ware:SetCheck(true)
  end
  PaGlobal_Purification_All._ui._btn_CheckAniSkip:SetCheck(false)
  PaGlobal_Purification_All:checkMoneyButton(PaGlobal_Purification_All._ui._btn_Radio_Inven:IsCheck())
  PaGlobal_Purification_All:dataClear()
  PaGlobal_Purification_All:moneyUpdate()
  InventoryWindow_Show()
  Inventory_SetFunctor(PaGlobalFunc_Purification_All_InventoryFilter, HandleEventRUp_Purification_All_InvenSlotRClick, HandleEventLUp_Purification_All_Close, nil)
  PaGlobal_Purification_All:resize()
  PaGlobal_Purification_All:open()
  if true == PaGlobal_Purification_All._isConsole then
    ToClient_padSnapSetTargetPanel(Panel_Window_Inventory)
  end
end
function PaGlobal_Purification_All:open()
  if nil == Panel_Purification_All and true == Panel_Purification_All:GetShow() then
    return
  end
  Panel_Purification_All:SetShow(true)
end
function PaGlobal_Purification_All:dataClear()
  if nil == Panel_Purification_All then
    return
  end
  Panel_Tooltip_Item_hideTooltip()
  TooltipSimple_Hide()
  PaGlobal_Purification_All._fromWhereType = -1
  PaGlobal_Purification_All._fromSlotIdx = -1
  PaGlobal_Purification_All._fromSlotOn = false
  PaGlobal_Purification_All._resultWhereType = -1
  PaGlobal_Purification_All._resultSlotIdx = -1
  PaGlobal_Purification_All._resultSlotOn = false
  PaGlobal_Purification_All._isAniStart = false
  PaGlobal_Purification_All._delta_ani_time = 0
  if false == PaGlobal_Purification_All._isConsole then
    PaGlobal_Purification_All._ui._btn_Purify_Pc:SetIgnore(false)
  end
  PaGlobal_Purification_All._ui._btn_Radio_Inven:SetIgnore(false)
  PaGlobal_Purification_All._ui._btn_Radio_Ware:SetIgnore(false)
  PaGlobal_Purification_All._ui._btn_CheckAniSkip:SetIgnore(false)
  PaGlobal_Purification_All._itemSlotBg_Icon:clearItem()
  PaGlobal_Purification_All._resultSlotBg_Icon:clearItem()
  PaGlobal_Purification_All._ui._stc_ItemSlotBg:EraseAllEffect()
  PaGlobal_Purification_All._ui._stc_ResultSlotBg:EraseAllEffect()
  if false == PaGlobal_Purification_All._isConsole then
    PaGlobal_Purification_All._ui._btn_Purify_Pc:SetMonoTone(false)
  end
end
function PaGlobal_Purification_All:prepareClose()
  if nil == Panel_Purification_All and false == Panel_Purification_All:GetShow() then
    return
  end
  PaGlobal_Purification_All:dataClear()
  Panel_Purification_All:ClearUpdateLuaFunc()
  HandleClicked_InventoryWindow_Close()
  PaGlobal_Purification_All:close()
end
function PaGlobal_Purification_All:close()
  if nil == Panel_Purification_All and false == Panel_Purification_All:GetShow() then
    return
  end
  Panel_Purification_All:SetShow(false)
end
function PaGlobal_Purification_All:moneyUpdate()
  if nil == Panel_Purification_All and false == Panel_Purification_All:GetShow() then
    return
  end
  if nil ~= getSelfPlayer() then
    local invenMoney = getSelfPlayer():get():getInventory():getMoney_s64()
    local wareMoney = warehouse_moneyFromNpcShop_s64()
    PaGlobal_Purification_All._ui._txt_WareMoney:SetText(makeDotMoney(wareMoney))
    PaGlobal_Purification_All._ui._txt_InvenMoney:SetText(makeDotMoney(invenMoney))
  end
end
function PaGlobal_Purification_All:checkMoneyButton(value)
  if nil == Panel_Purification_All and false == Panel_Purification_All:GetShow() then
    return
  end
  if true == value then
    PaGlobal_Purification_All._moneyWhereType = CppEnums.ItemWhereType.eInventory
  else
    PaGlobal_Purification_All._moneyWhereType = CppEnums.ItemWhereType.eWarehouse
  end
end
function PaGlobal_Purification_All:requestPurification()
  if PaGlobal_Purification_All._fromSlotIdx < 0 or 0 > PaGlobal_Purification_All._fromWhereType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PURIFICATION_TARGET_EMPTY"))
    return
  end
  local ConfirmPuri = function()
    local invenMoney = getSelfPlayer():get():getInventory():getMoney_s64()
    local wareMoney = warehouse_moneyFromNpcShop_s64()
    local fee = toInt64(0, PaGlobal_Purification_All._purificationPrice)
    if invenMoney < fee and true == PaGlobal_Purification_All._ui._btn_Radio_Inven:IsCheck() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Money"))
      return
    elseif wareMoney < fee and true == PaGlobal_Purification_All._ui._btn_Radio_Ware:IsCheck() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Money"))
      return
    end
    Panel_Purification_All:RegisterUpdateFunc("PaGlobalFunc_Purification_All_RequestPurificationAni")
    PaGlobal_Purification_All._delta_ani_time = 0
    PaGlobal_Purification_All._isAniStart = true
    local skipCheck = false
    if true == PaGlobal_Purification_All._ui._btn_CheckAniSkip:IsCheck() then
      skipCheck = true
    end
    if true == skipCheck then
      PaGlobal_Purification_All._ui._stc_ResultSlotBg:AddEffect("fUI_Purification_02A", false, 0, 0)
    else
      PaGlobal_Purification_All._ui._stc_ItemSlotBg:AddEffect("fUI_Purification_01A", false, 0, 0)
      PaGlobal_Purification_All._ui._stc_ResultSlotBg:AddEffect("fUI_Purification_02A", false, 0, 0)
    end
    if false == PaGlobal_Purification_All._isConsole then
      PaGlobal_Purification_All._ui._btn_Purify_Pc:SetIgnore(true)
      PaGlobal_Purification_All._ui._btn_Purify_Pc:SetMonoTone(true)
    else
      ToClient_padSnapSetTargetPanel(Panel_Window_Inventory)
    end
    PaGlobal_Purification_All:audioPostEvent(5, 17, PaGlobal_Purification_All._isConsole)
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_PURIFICATION_ALERT"),
    functionYes = ConfirmPuri,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_Purification_All:audioPostEvent(idx, value, isConsole)
  if nil == Panel_Purification_All then
    return
  end
  if true == PaGlobal_Purification_All._isConsole and true == isConsole then
    _AudioPostEvent_SystemUiForXBOX(idx, value)
  elseif false == PaGlobal_Purification_All._isConsole and false == isConsole then
    audioPostEvent_SystemUi(idx, value)
  end
end
function PaGlobal_Purification_All:resize()
  if nil == Panel_Purification_All then
    return
  end
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local height = 30
  if screenSizeY <= 800 then
    if false == PaGlobal_Purification_All._isConsole then
      height = 50
    else
      height = 30
    end
  elseif false == PaGlobal_Purification_All._isConsole then
    height = 120
  else
    height = 100
  end
  Panel_Purification_All:SetPosY(screenSizeY / 2 - Panel_Purification_All:GetSizeY() / 2 - height)
  Panel_Purification_All:SetPosX(screenSizeX / 2 - Panel_Purification_All:GetSizeX() / 2)
end

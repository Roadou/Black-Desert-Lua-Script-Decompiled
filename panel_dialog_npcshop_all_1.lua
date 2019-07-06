function PaGlobal_NPCShop_ALL:initialize()
  PaGlobal_NPCShop_ALL._ui._stc_TitleBg = UI.getChildControl(Panel_Dialog_NPCShop_All, "Static_Title_BG")
  PaGlobal_NPCShop_ALL._ui._stc_SubBg = UI.getChildControl(Panel_Dialog_NPCShop_All, "Static_SubBg")
  PaGlobal_NPCShop_ALL._ui._pc._btn_Close = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._stc_TitleBg, "Button_Close_PCUI")
  PaGlobal_NPCShop_ALL._ui._pc._btn_Question = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._stc_TitleBg, "Button_Question_PCUI")
  PaGlobal_NPCShop_ALL._ui._pc._stc_TabGroup = UI.getChildControl(Panel_Dialog_NPCShop_All, "StaticText_Tap_Group_PCUI")
  PaGlobal_NPCShop_ALL._ui._pc._btn_Radio_Buy = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._pc._stc_TabGroup, "RadioButton_Tab_Buy")
  PaGlobal_NPCShop_ALL._ui._pc._btn_Radio_Sell = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._pc._stc_TabGroup, "RadioButton_Tab_Sell")
  PaGlobal_NPCShop_ALL._ui._pc._btn_Radio_Repurchase = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._pc._stc_TabGroup, "RadioButton_Tab_Repurchase")
  PaGlobal_NPCShop_ALL._ui._pc._btn_Buy = UI.getChildControl(Panel_Dialog_NPCShop_All, "Button_Command_PCUI")
  PaGlobal_NPCShop_ALL._ui._pc._btn_BuySome = UI.getChildControl(Panel_Dialog_NPCShop_All, "Button_BuySome_PCUI")
  PaGlobal_NPCShop_ALL._ui._pc._btn_SellAll = UI.getChildControl(Panel_Dialog_NPCShop_All, "Button_SellAll_PCUI")
  PaGlobal_NPCShop_ALL._ui._console._stc_TabGroup_Console = UI.getChildControl(Panel_Dialog_NPCShop_All, "StaticText_Tap_Group_ConsoleUI")
  PaGlobal_NPCShop_ALL._ui._console._btn_TabGroup_LT = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._console._stc_TabGroup_Console, "Static_LT")
  PaGlobal_NPCShop_ALL._ui._console._btn_TabGroup_RT = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._console._stc_TabGroup_Console, "Static_RT")
  PaGlobal_NPCShop_ALL._ui._console._btn_Radio_Buy_Console = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._console._stc_TabGroup_Console, "RadioButton_Buy")
  PaGlobal_NPCShop_ALL._ui._console._btn_Radio_Sell_Console = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._console._stc_TabGroup_Console, "RadioButton_Sell")
  PaGlobal_NPCShop_ALL._ui._console._btn_Radio_Repurchase_Console = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._console._stc_TabGroup_Console, "RadioButton_Re_Buy")
  PaGlobal_NPCShop_ALL._ui._console._stc_KeyGuide = UI.getChildControl(Panel_Dialog_NPCShop_All, "Static_Key_Guide_ConsoleUI")
  PaGlobal_NPCShop_ALL._ui._console._stc_Key_Purchase = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._console._stc_KeyGuide, "StaticText_A_ConsoleUI")
  PaGlobal_NPCShop_ALL._ui._console._stc_Key_Purchase_All = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._console._stc_KeyGuide, "StaticText_A2_ConsoleUI")
  PaGlobal_NPCShop_ALL._ui._console._stc_Key_Purchase_All:SetShow(false)
  PaGlobal_NPCShop_ALL._ui._console._stc_Key_Detail = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._console._stc_KeyGuide, "StaticText_XForDetail_ConsoleUI")
  PaGlobal_NPCShop_ALL._ui._console._stc_Key_Move = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._console._stc_KeyGuide, "StaticText_Move_ConsoleUI")
  PaGlobal_NPCShop_ALL._ui._console._stc_Key_Cancel = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._console._stc_KeyGuide, "StaticText_Cancel_ConsoleUI")
  PaGlobal_NPCShop_ALL._ui._stc_SelectBar = UI.getChildControl(Panel_Dialog_NPCShop_All, "Static_TapSelectBar")
  PaGlobal_NPCShop_ALL._ui._list2_Item_List = UI.getChildControl(Panel_Dialog_NPCShop_All, "List2_ItemList")
  PaGlobal_NPCShop_ALL._ui._list2_Content = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._list2_Item_List, "List2_1_Content")
  PaGlobal_NPCShop_ALL._ui._btn_Radio_LeftTemplete = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._list2_Content, "RadioButton_1")
  PaGlobal_NPCShop_ALL._ui._stc_ItemSlot_LeftTemplete = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._btn_Radio_LeftTemplete, "Static_Item_Slot")
  PaGlobal_NPCShop_ALL._ui._btn_Radio_LeftTemplete:SetShow(false)
  PaGlobal_NPCShop_ALL._ui._btn_Radio_RightTemplete = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._list2_Content, "RadioButton_2")
  PaGlobal_NPCShop_ALL._ui._stc_ItemSlot_RightTemplete = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._btn_Radio_RightTemplete, "Static_Item_Slot")
  PaGlobal_NPCShop_ALL._ui._btn_Radio_RightTemplete:SetShow(false)
  PaGlobal_NPCShop_ALL._ui._stc_Scroll_Vertical = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._list2_Item_List, "List2_1_VerticalScroll")
  PaGlobal_NPCShop_ALL._ui._stc_Scroll_Horizontal = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._list2_Item_List, "List2_1_HorizontalScroll")
  PaGlobal_NPCShop_ALL._ui._stc_player_Silver = UI.getChildControl(Panel_Dialog_NPCShop_All, "Static_Silver")
  PaGlobal_NPCShop_ALL._ui._btn_Check_Inven = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._stc_player_Silver, "CheckButton_Inven")
  PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._stc_player_Silver, "CheckButton_Warehouse")
  PaGlobal_NPCShop_ALL._ui._txt_Silver_Inven = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._stc_player_Silver, "StaticText_Inventory")
  PaGlobal_NPCShop_ALL._ui._txt_Silver_Storage = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._stc_player_Silver, "StaticText_Storage")
  PaGlobal_NPCShop_ALL._ui._stc_Guild_Silver = UI.getChildControl(Panel_Dialog_NPCShop_All, "Static_GuildSilver")
  PaGlobal_NPCShop_ALL._ui._btn_Check_Inven_Guild = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._stc_Guild_Silver, "CheckButton_Inven")
  PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse_Guild = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._stc_Guild_Silver, "CheckButton_Storage")
  PaGlobal_NPCShop_ALL._ui._txt_Silver_Inven_Guild = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._stc_Guild_Silver, "StaticText_Inventory")
  PaGlobal_NPCShop_ALL._ui._txt_Silver_Storage_Guild = UI.getChildControl(PaGlobal_NPCShop_ALL._ui._stc_Guild_Silver, "StaticText_Storage")
  PaGlobal_NPCShop_ALL._isConsole = ToClient_isConsole()
  PaGlobal_NPCShop_ALL._ui._btn_Check_Inven_Guild:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_GUILDMONEY"))
  PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse_Guild:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_NPCSHOP_GUILDPRICELIMITED"))
  local itemImageLeftSlot = {}
  local itemImageRightSlot = {}
  SlotItem.new(itemImageLeftSlot, "Left_Item_Icon_", 0, PaGlobal_NPCShop_ALL._ui._stc_ItemSlot_LeftTemplete, PaGlobal_NPCShop_ALL._slotConfig)
  SlotItem.new(itemImageRightSlot, "Right_Item_Icon_", 0, PaGlobal_NPCShop_ALL._ui._stc_ItemSlot_RightTemplete, PaGlobal_NPCShop_ALL._slotConfig)
  itemImageLeftSlot:createChild()
  itemImageRightSlot:createChild()
  itemImageLeftSlot.icon:SetPosY(2)
  itemImageRightSlot.icon:SetPosY(2)
  itemImageLeftSlot.icon:SetPosX(2)
  itemImageRightSlot.icon:SetPosX(2)
  PaGlobal_NPCShop_ALL._NPCSHOP_BUYBTN_POSX = PaGlobal_NPCShop_ALL._ui._pc._btn_Radio_Buy:GetSpanSize().x
  PaGlobal_NPCShop_ALL._NPCSHOP_SELLBTN_POSX = PaGlobal_NPCShop_ALL._ui._pc._btn_Radio_Sell:GetSpanSize().x
  PaGlobal_NPCShop_ALL._keyGuideList = {
    PaGlobal_NPCShop_ALL._ui._console._stc_Key_Move,
    PaGlobal_NPCShop_ALL._ui._console._stc_Key_Detail,
    PaGlobal_NPCShop_ALL._ui._console._stc_Key_Purchase,
    PaGlobal_NPCShop_ALL._ui._console._stc_Key_Cancel
  }
  if true == PaGlobal_NPCShop_ALL._isConsole then
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_NPCShop_ALL._keyGuideList, PaGlobal_NPCShop_ALL._ui._console._stc_KeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
    PaGlobal_NPCShop_ALL._ui._console._stc_TabGroup_Console:SetShow(true)
    PaGlobal_NPCShop_ALL._ui._console._btn_TabGroup_RT:SetShow(true)
    PaGlobal_NPCShop_ALL._ui._console._btn_TabGroup_LT:SetShow(true)
    PaGlobal_NPCShop_ALL._ui._pc._btn_Close:SetShow(false)
    PaGlobal_NPCShop_ALL._ui._pc._btn_Question:SetShow(false)
    PaGlobal_NPCShop_ALL._ui._pc._btn_Buy:SetShow(false)
    PaGlobal_NPCShop_ALL._ui._pc._btn_BuySome:SetShow(false)
    PaGlobal_NPCShop_ALL._ui._pc._btn_SellAll:SetShow(false)
    Panel_Dialog_NPCShop_All:SetSize(Panel_Dialog_NPCShop_All:GetSizeX(), PaGlobal_NPCShop_ALL._PANALSIZEY_CONSOLE)
    PaGlobal_NPCShop_ALL._ui._stc_SubBg:SetSize(PaGlobal_NPCShop_ALL._ui._stc_SubBg:GetSizeX(), PaGlobal_NPCShop_ALL._SUBBGSIZEY_CONSOLE)
    PaGlobal_NPCShop_ALL._ui._console._stc_KeyGuide:SetPosY(Panel_Dialog_NPCShop_All:GetSizeY() + Panel_Dialog_NPCShop_All:GetSpanSize().x - 15)
  else
    for _, v in pairs(PaGlobal_NPCShop_ALL._keyGuideList) do
      if nil ~= v then
        v:SetShow(false)
      end
    end
    PaGlobal_NPCShop_ALL._ui._console._stc_TabGroup_Console:SetShow(false)
    PaGlobal_NPCShop_ALL._ui._console._btn_TabGroup_RT:SetShow(false)
    PaGlobal_NPCShop_ALL._ui._console._btn_TabGroup_LT:SetShow(false)
    Panel_Dialog_NPCShop_All:SetSize(Panel_Dialog_NPCShop_All:GetSizeX(), PaGlobal_NPCShop_ALL._PANALSIZEY_PC)
    PaGlobal_NPCShop_ALL._ui._stc_SubBg:SetSize(PaGlobal_NPCShop_ALL._ui._stc_SubBg:GetSizeX(), PaGlobal_NPCShop_ALL._SUBBGSIZEY_PC)
  end
  PaGlobal_NPCShop_ALL:validate()
  PaGlobal_NPCShop_ALL._initialize = true
  PaGlobal_NPCShop_ALL:registerEventHandler()
end
function PaGlobal_NPCShop_ALL:registerEventHandler()
  Panel_Dialog_NPCShop_All:RegisterShowEventFunc(true, "PaGlobalFunc_NPCShop_ALL_SetANI( true )")
  Panel_Dialog_NPCShop_All:RegisterShowEventFunc(false, "PaGlobalFunc_NPCShop_ALL_SetANI( false )")
  registerEvent("EventNpcShopUpdate", "FromClient_NPCShop_ALL_Open()")
  registerEvent("EventNpcShopUpdate", "FromClient_NPCShop_ALL_PushKeyToList2()")
  registerEvent("FromClient_InventoryUpdate", "FromClient_NPCShop_ALL_UpdateMoneyWithContent")
  registerEvent("EventWarehouseUpdate", "FromClient_NPCShop_ALL_UpdateMoneyWithContent")
  registerEvent("UpdateGuildPriceLimit", "FromClient_NPCShop_ALL_UpdateMoneyWithContent")
  registerEvent("onScreenResize", "FromClient_NPCShop_ALL_Resize")
  PaGlobal_NPCShop_ALL._ui._list2_Item_List:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FromClient_NPCShop_ALL_UpdateContent")
  PaGlobal_NPCShop_ALL._ui._list2_Item_List:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  PaGlobal_NPCShop_ALL._radioButton_Tab[0] = PaGlobal_NPCShop_ALL._ui._pc._btn_Radio_Buy
  PaGlobal_NPCShop_ALL._radioButton_Tab[1] = PaGlobal_NPCShop_ALL._ui._pc._btn_Radio_Sell
  PaGlobal_NPCShop_ALL._radioButton_Tab[2] = PaGlobal_NPCShop_ALL._ui._pc._btn_Radio_Repurchase
  if true == PaGlobal_NPCShop_ALL._isConsole then
    Panel_Dialog_NPCShop_All:ActiveMouseEventEffect(false)
    Panel_Dialog_NPCShop_All:registerPadEvent(__eConsoleUIPadEvent_LT, "PaGlobalFunc_NPCShop_ALL_ChangeTapByPad(-1)")
    Panel_Dialog_NPCShop_All:registerPadEvent(__eConsoleUIPadEvent_RT, "PaGlobalFunc_NPCShop_ALL_ChangeTapByPad(1)")
    PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventLUp_NPCShop_ALL_CheckBoxToggle( 0 )")
    PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventLUp_NPCShop_ALL_CheckBoxToggle( 1 )")
  else
    PaGlobal_NPCShop_ALL._ui._pc._btn_Close:addInputEvent("Mouse_LUp", "HandleEventLUp_NPCShop_ALL_Close( true )")
    PaGlobal_NPCShop_ALL._ui._pc._btn_Question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"NpcShop\" )")
    PaGlobal_NPCShop_ALL._ui._pc._btn_Question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"NpcShop\", \"true\")")
    PaGlobal_NPCShop_ALL._ui._pc._btn_Question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"NpcShop\", \"false\")")
    for index = 0, 2 do
      PaGlobal_NPCShop_ALL._radioButton_Tab[index]:addInputEvent("Mouse_LUp", "HandleEventLUp_NPCShop_ALL_TabButtonClick(" .. index .. ")")
    end
    Panel_Dialog_NPCShop_All:ActiveMouseEventEffect(true)
    PaGlobal_NPCShop_ALL._ui._pc._btn_Buy:addInputEvent("Mouse_LUp", "HandleEventLUp_NPCShop_ALL_BuyOrSellItem()")
    PaGlobal_NPCShop_ALL._ui._pc._btn_BuySome:addInputEvent("Mouse_LUp", "HandleEventLUp_NPCShop_ALL_BuySome()")
    PaGlobal_NPCShop_ALL._ui._pc._btn_SellAll:addInputEvent("Mouse_LUp", "HandleEventLUp_NPCShop_ALL_SellItemAll()")
    PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:addInputEvent("Mouse_LUp", "HandleEventLUp_NPCShop_ALL_CheckBoxToggle( 0 )")
    PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:addInputEvent("Mouse_LUp", "HandleEventLUp_NPCShop_ALL_CheckBoxToggle( 1 )")
  end
  HandleEventLUp_NPCShop_ALL_Close(false)
end
function PaGlobal_NPCShop_ALL:validate()
  if nil == Panel_Dialog_NPCShop_All then
    return
  end
  PaGlobal_NPCShop_ALL._ui._stc_TitleBg:isValidate()
  PaGlobal_NPCShop_ALL._ui._stc_SubBg:isValidate()
  PaGlobal_NPCShop_ALL._ui._pc._btn_Close:isValidate()
  PaGlobal_NPCShop_ALL._ui._pc._btn_Question:isValidate()
  PaGlobal_NPCShop_ALL._ui._pc._stc_TabGroup:isValidate()
  PaGlobal_NPCShop_ALL._ui._pc._btn_Radio_Buy:isValidate()
  PaGlobal_NPCShop_ALL._ui._pc._btn_Radio_Sell:isValidate()
  PaGlobal_NPCShop_ALL._ui._pc._btn_Radio_Repurchase:isValidate()
  PaGlobal_NPCShop_ALL._ui._pc._btn_Buy:isValidate()
  PaGlobal_NPCShop_ALL._ui._pc._btn_BuySome:isValidate()
  PaGlobal_NPCShop_ALL._ui._pc._btn_SellAll:isValidate()
  PaGlobal_NPCShop_ALL._ui._console._stc_TabGroup_Console:isValidate()
  PaGlobal_NPCShop_ALL._ui._console._btn_TabGroup_LT:isValidate()
  PaGlobal_NPCShop_ALL._ui._console._btn_TabGroup_RT:isValidate()
  PaGlobal_NPCShop_ALL._ui._console._btn_Radio_Buy_Console:isValidate()
  PaGlobal_NPCShop_ALL._ui._console._btn_Radio_Sell_Console:isValidate()
  PaGlobal_NPCShop_ALL._ui._console._btn_Radio_Repurchase_Console:isValidate()
  PaGlobal_NPCShop_ALL._ui._console._stc_KeyGuide:isValidate()
  PaGlobal_NPCShop_ALL._ui._console._stc_Key_Purchase:isValidate()
  PaGlobal_NPCShop_ALL._ui._console._stc_Key_Purchase_All:isValidate()
  PaGlobal_NPCShop_ALL._ui._console._stc_Key_Detail:isValidate()
  PaGlobal_NPCShop_ALL._ui._console._stc_Key_Move:isValidate()
  PaGlobal_NPCShop_ALL._ui._console._stc_Key_Cancel:isValidate()
  PaGlobal_NPCShop_ALL._ui._stc_SelectBar:isValidate()
  PaGlobal_NPCShop_ALL._ui._list2_Item_List:isValidate()
  PaGlobal_NPCShop_ALL._ui._list2_Content:isValidate()
  PaGlobal_NPCShop_ALL._ui._btn_Radio_LeftTemplete:isValidate()
  PaGlobal_NPCShop_ALL._ui._stc_ItemSlot_LeftTemplete:isValidate()
  PaGlobal_NPCShop_ALL._ui._btn_Radio_LeftTemplete:isValidate()
  PaGlobal_NPCShop_ALL._ui._btn_Radio_RightTemplete:isValidate()
  PaGlobal_NPCShop_ALL._ui._stc_ItemSlot_RightTemplete:isValidate()
  PaGlobal_NPCShop_ALL._ui._btn_Radio_RightTemplete:isValidate()
  PaGlobal_NPCShop_ALL._ui._stc_Scroll_Vertical:isValidate()
  PaGlobal_NPCShop_ALL._ui._stc_Scroll_Horizontal:isValidate()
  PaGlobal_NPCShop_ALL._ui._stc_player_Silver:isValidate()
  PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:isValidate()
  PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:isValidate()
  PaGlobal_NPCShop_ALL._ui._txt_Silver_Inven:isValidate()
  PaGlobal_NPCShop_ALL._ui._txt_Silver_Storage:isValidate()
  PaGlobal_NPCShop_ALL._ui._stc_Guild_Silver:isValidate()
  PaGlobal_NPCShop_ALL._ui._btn_Check_Inven_Guild:isValidate()
  PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse_Guild:isValidate()
  PaGlobal_NPCShop_ALL._ui._txt_Silver_Inven_Guild:isValidate()
  PaGlobal_NPCShop_ALL._ui._txt_Silver_Storage_Guild:isValidate()
end
function PaGlobal_NPCShop_ALL:prepareOpen()
  if nil == Panel_Dialog_NPCShop_All or true == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  local talker = dialog_getTalker()
  PaGlobal_NPCShop_ALL._value._isCamping = PaGlobal_Camp:getIsCamping()
  if nil == talker and (false == PaGlobal_NPCShop_ALL._value._isCamping or nil == PaGlobal_NPCShop_ALL._value._isCamping) then
    return
  end
  if false == PaGlobal_NPCShop_ALL._value._isCamping or nil == PaGlobal_NPCShop_ALL._value._isCamping then
    local actorProxyWrapper = getNpcActor(talker:getActorKey())
    if nil ~= actorProxyWrapper then
      local actorProxy = actorProxyWrapper:get()
      local characterStaticStatus = actorProxy:getCharacterStaticStatus()
      if true == characterStaticStatus:isTradeMerchant() then
        return
      end
    end
  end
  if true == global_IsTrading then
    return
  end
  PaGlobal_NPCShop_ALL._value._currentTabIndex = PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY
  PaGlobal_NPCShop_ALL._radioButton_Tab[PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY]:SetFontColor(PaGlobal_NPCShop_ALL._TABCOLORSELECTED)
  PaGlobal_NPCShop_ALL._value._selectedSlotIndex = nil
  PaGlobal_NPCShop_ALL:update()
  PaGlobal_NPCShop_ALL:open(true)
end
function PaGlobal_NPCShop_ALL:update()
  PaGlobal_NPCShop_ALL:PushKeyToList2(PaGlobal_NPCShop_ALL._value._currentTabIndex)
  PaGlobal_NPCShop_ALL:UpdateMoney()
  PaGlobal_NPCShop_ALL:controlInit()
  PaGlobal_NPCShop_ALL:checkInit()
  Inventory_SetFunctor(PaGlobalFunc_NPCShop_ALL_IsExchangeItem, HandleEventRUp_NPCShop_ALL_InvenItemRClick, HandleEventLUp_NPCShop_ALL_Close, nil)
  PaGlobal_NPCShop_ALL:inventoryShow()
  PaGlobal_NPCShop_ALL:resize()
end
function PaGlobal_NPCShop_ALL:PushKeyToList2()
  if nil == Panel_Dialog_NPCShop_All then
    return
  end
  if nil == PaGlobal_NPCShop_ALL._value._currentTabIndex or PaGlobal_NPCShop_ALL._value._currentTabIndex < PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY or PaGlobal_NPCShop_ALL._value._currentTabIndex > PaGlobal_NPCShop_ALL._ENUMTABINDEXREBUY then
    UI.ASSERT(false, [[
======== [LOVELYK2] =======
Wrong NpcShop Tab Index!! : ]] .. PaGlobal_NPCShop_ALL._value._currentTabIndex)
    return
  end
  local currentItemSize = 0
  local isItemSizeChanged = false
  local toIndex = PaGlobal_NPCShop_ALL._ui._list2_Item_List:getCurrenttoIndex()
  if PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex then
    currentItemSize = npcShop_getBuyCount()
  elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXSELL == PaGlobal_NPCShop_ALL._value._currentTabIndex then
    currentItemSize = npcShop_getSellCount()
  else
    currentItemSize = npcShop_getRepurchaseCount()
  end
  if currentItemSize ~= PaGlobal_NPCShop_ALL._value._itemListSize then
    PaGlobal_NPCShop_ALL._value._itemListSize = currentItemSize
    isItemSizeChanged = true
  end
  if PaGlobal_NPCShop_ALL._value._lastTabIndex ~= PaGlobal_NPCShop_ALL._value._currentTabIndex or true == isItemSizeChanged then
    PaGlobal_NPCShop_ALL._ui._list2_Item_List:getElementManager():clearKey()
    for ii = 0, currentItemSize do
      if 1 == ii % PaGlobal_NPCShop_ALL._config._slotCols then
        PaGlobal_NPCShop_ALL._ui._list2_Item_List:getElementManager():pushKey(toInt64(0, ii))
      end
    end
  elseif PaGlobal_NPCShop_ALL._value._lastTabIndex == PaGlobal_NPCShop_ALL._value._currentTabIndex then
    for ii = 0, currentItemSize do
      if 1 == ii % PaGlobal_NPCShop_ALL._config._slotCols then
        PaGlobal_NPCShop_ALL._ui._list2_Item_List:requestUpdateByKey(toInt64(0, ii))
      end
    end
  end
  local commandText = {}
  commandText[0] = PAGetString(Defines.StringSheet_GAME, "NPCSHOP_BUY")
  commandText[1] = PAGetString(Defines.StringSheet_GAME, "NPCSHOP_SELL")
  commandText[2] = PAGetString(Defines.StringSheet_GAME, "NPCSHOP_REPURCHASE")
  PaGlobal_NPCShop_ALL._ui._pc._btn_Buy:SetText(commandText[PaGlobal_NPCShop_ALL._value._currentTabIndex])
end
function PaGlobal_NPCShop_ALL:updateContentData(content, key)
  if nil == getSelfPlayer() then
    return
  end
  local key32 = Int64toInt32(key)
  local itemPrice_s64
  local inventory = getSelfPlayer():get():getInventory()
  for ii = 0, PaGlobal_NPCShop_ALL._config._slotCols - 1 do
    local dataIndex = key32 + (ii - 1)
    local shopItemWrapper, s64_inventoryItemCount
    PaGlobal_NPCShop_ALL:createItem(content, dataIndex, ii + 1)
    if dataIndex < PaGlobal_NPCShop_ALL._value._itemListSize then
      if PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex then
        shopItemWrapper = npcShop_getItemBuy(dataIndex)
      elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXSELL == PaGlobal_NPCShop_ALL._value._currentTabIndex then
        shopItemWrapper = npcShop_getItemSell(dataIndex)
        s64_inventoryItemCount = inventory:getItemCount_s64(shopItemWrapper:getStaticStatus():get()._key)
      else
        shopItemWrapper = npcShop_getItemRepurchase(dataIndex)
      end
      if nil ~= shopItemWrapper then
        local shopItem = shopItemWrapper:get()
        if PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex then
          itemPrice_s64 = shopItem:getItemPriceWithOption()
          PaGlobal_NPCShop_ALL:setItem(dataIndex, shopItemWrapper:getStaticStatus(), shopItem.leftCount_s64, itemPrice_s64, s64_inventoryItemCount, shopItem:getItemUsablePeriod(), shopItem:getNeedIntimacy())
        elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXSELL == PaGlobal_NPCShop_ALL._value._currentTabIndex then
          itemPrice_s64 = shopItem:getItemSellPriceWithOption()
          PaGlobal_NPCShop_ALL:setItem(dataIndex, shopItemWrapper:getStaticStatus(), shopItem.leftCount_s64, itemPrice_s64, s64_inventoryItemCount, shopItem:getItemUsablePeriod())
        else
          itemPrice_s64 = shopItem.price_s64
          PaGlobal_NPCShop_ALL:setItem(dataIndex, shopItemWrapper:getStaticStatus(), shopItem.leftCount_s64, itemPrice_s64, s64_inventoryItemCount, shopItem:getItemUsablePeriod(), shopItem:getNeedIntimacy())
        end
      end
    else
      local btn = UI.getChildControl(content, "RadioButton_" .. ii + 1)
      btn:SetShow(false)
    end
  end
  PaGlobal_NPCShop_ALL._value._lastTabIndex = PaGlobal_NPCShop_ALL._value._currentTabIndex
end
function PaGlobal_NPCShop_ALL:controlInit()
  if nil == Panel_Dialog_NPCShop_All then
    return
  end
  for ii = 0, 2 do
    if ii == PaGlobal_NPCShop_ALL._value._currentTabIndex then
      PaGlobal_NPCShop_ALL._radioButton_Tab[ii]:SetCheck(true)
      PaGlobal_NPCShop_ALL._radioButton_Tab[ii]:SetFontColor(PaGlobal_NPCShop_ALL._TABCOLORSELECTED)
      local selectBarSapnX = PaGlobal_NPCShop_ALL._radioButton_Tab[ii]:GetSpanSize().x
      local selectBarSapnY = PaGlobal_NPCShop_ALL._ui._stc_SelectBar:GetSpanSize().y
      PaGlobal_NPCShop_ALL._ui._stc_SelectBar:SetSpanSize(selectBarSapnX, selectBarSapnY)
    else
      PaGlobal_NPCShop_ALL._radioButton_Tab[ii]:SetCheck(false)
      PaGlobal_NPCShop_ALL._radioButton_Tab[ii]:SetFontColor(PaGlobal_NPCShop_ALL._TABCOLORBASE)
    end
  end
  if true == PaGlobal_NPCShop_ALL._isConsole then
    if PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex then
      PaGlobal_NPCShop_ALL._ui._console._stc_Key_Purchase:SetText(PAGetString(Defines.StringSheet_GAME, "NPCSHOP_BUY"))
    elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXSELL == PaGlobal_NPCShop_ALL._value._currentTabIndex then
      PaGlobal_NPCShop_ALL._ui._console._stc_Key_Purchase:SetText(PAGetString(Defines.StringSheet_GAME, "NPCSHOP_SELL"))
    else
      PaGlobal_NPCShop_ALL._ui._console._stc_Key_Purchase:SetText(PAGetString(Defines.StringSheet_GAME, "NPCSHOP_REPURCHASE"))
    end
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_NPCShop_ALL._keyGuideList, PaGlobal_NPCShop_ALL._ui._console._stc_KeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  end
  PaGlobal_NPCShop_ALL:multiPurposeBtn_ShowToggle()
  local talker = dialog_getTalker()
  if nil ~= talker then
    local actorProxyWrapper = getNpcActor(talker:getActorKey())
    if nil ~= actorProxyWrapper then
      local buyBtnSpanPosY = PaGlobal_NPCShop_ALL._radioButton_Tab[PaGlobal_NPCShop_ALL._ENUMTABINDEXREBUY]:GetSpanSize().y
      local characterSSW = actorProxyWrapper:getCharacterStaticStatusWrapper()
      if characterSSW:isSellingNormalShop() then
        PaGlobal_NPCShop_ALL._radioButton_Tab[PaGlobal_NPCShop_ALL._ENUMTABINDEXSELL]:SetShow(true)
        PaGlobal_NPCShop_ALL._radioButton_Tab[PaGlobal_NPCShop_ALL._ENUMTABINDEXREBUY]:SetShow(true)
        PaGlobal_NPCShop_ALL._radioButton_Tab[PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY]:SetSpanSize(PaGlobal_NPCShop_ALL._NPCSHOP_BUYBTN_POSX, buyBtnSpanPosY)
      else
        PaGlobal_NPCShop_ALL._radioButton_Tab[PaGlobal_NPCShop_ALL._ENUMTABINDEXSELL]:SetShow(false)
        PaGlobal_NPCShop_ALL._radioButton_Tab[PaGlobal_NPCShop_ALL._ENUMTABINDEXREBUY]:SetShow(false)
        PaGlobal_NPCShop_ALL._radioButton_Tab[PaGlobal_NPCShop_ALL._ENUMTABINDEXREBUY]:SetFontColor(PaGlobal_NPCShop_ALL._TABCOLORSELECTED)
        PaGlobal_NPCShop_ALL._radioButton_Tab[PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY]:SetSpanSize(PaGlobal_NPCShop_ALL._NPCSHOP_SELLBTN_POSX, buyBtnSpanPosY)
      end
    end
  elseif PaGlobal_NPCShop_ALL._value._isCamping then
    PaGlobal_NPCShop_ALL._radioButton_Tab[PaGlobal_NPCShop_ALL._ENUMTABINDEXSELL]:SetShow(false)
    PaGlobal_NPCShop_ALL._radioButton_Tab[PaGlobal_NPCShop_ALL._ENUMTABINDEXREBUY]:SetShow(false)
    PaGlobal_NPCShop_ALL._radioButton_Tab[PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY]:SetSpanSize(PaGlobal_NPCShop_ALL._NPCSHOP_SELLBTN_POSX, buyBtnSpanPosY)
  end
  local selectBarSapnX = PaGlobal_NPCShop_ALL._radioButton_Tab[PaGlobal_NPCShop_ALL._value._currentTabIndex]:GetSpanSize().x
  local selectBarSapnY = PaGlobal_NPCShop_ALL._ui._stc_SelectBar:GetSpanSize().y
  PaGlobal_NPCShop_ALL._ui._stc_SelectBar:SetSpanSize(selectBarSapnX, selectBarSapnY)
end
function PaGlobal_NPCShop_ALL:open(showAni)
  if nil == Panel_Dialog_NPCShop_All or true == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:audioPostEvent(1, 0, false)
  if nil == showAni then
    Panel_Dialog_NPCShop_All:SetShow(true, false)
    return
  else
    Panel_Dialog_NPCShop_All:SetShow(true, showAni)
  end
end
function PaGlobal_NPCShop_ALL:resize()
  if nil == Panel_Dialog_NPCShop_All then
    return
  end
  if Panel_Window_Inventory:GetShow() then
    local screenSizeX = getScreenSizeX()
    local screenSizeY = getScreenSizeY()
    local startPosX = screenSizeX - Panel_Window_Inventory:GetSizeX() - 60 - Panel_Dialog_NPCShop_All:GetSizeX()
    if startPosX > 0 then
      Panel_Dialog_NPCShop_All:SetPosX(startPosX)
    else
      Panel_Dialog_NPCShop_All:SetHorizonLeft()
    end
    if screenSizeY <= 800 then
      Panel_Dialog_NPCShop_All:SetPosY(screenSizeY / 2 - Panel_Dialog_NPCShop_All:GetSizeY() / 2 - 30)
    else
      Panel_Dialog_NPCShop_All:SetPosY(screenSizeY / 2 - Panel_Dialog_NPCShop_All:GetSizeY() / 2 - 100)
    end
    PaGlobal_NPCShop_ALL._pos._toolTipPosX = Panel_Dialog_NPCShop_All:GetPosX() + Panel_Dialog_NPCShop_All:GetSizeX() + Panel_Dialog_NPCShop_All:GetSpanSize().x
    PaGlobal_NPCShop_ALL._pos._toolTipPosY = Panel_Dialog_NPCShop_All:GetPosY() + PaGlobal_NPCShop_ALL._ui._list2_Item_List:GetPosY()
  end
end
function PaGlobal_NPCShop_ALL:setAni(switch)
  if nil == Panel_Dialog_NPCShop_All then
    return
  end
  if true == switch then
    PaGlobal_NPCShop_ALL:audioPostEvent(1, 1, true)
    Panel_Dialog_NPCShop_All:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Dialog_NPCShop_All, 0, 0.3)
  else
    local ani1 = UIAni.AlphaAnimation(0, Panel_Dialog_NPCShop_All, 0, 0.2)
    ani1:SetHideAtEnd(true)
  end
end
function PaGlobal_NPCShop_ALL:prepareClose(showAni)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL._ui._list2_Item_List:getElementManager():clearKey()
  PaGlobal_NPCShop_ALL._value._lastTabIndex = nil
  PaGlobal_NPCShop_ALL._value._currentTabIndex = nil
  PaGlobal_NPCShop_ALL._value._scrollPos = nil
  PaGlobal_NPCShop_ALL._createdItemSlot = {}
  PaGlobal_NPCShop_ALL._value._itemListSize = 0
  Panel_Tooltip_Item_hideTooltip()
  InventoryWindow_Close()
  Inventory_SetFunctor(nil, nil, nil, nil)
  if true == showAni or true == PaGlobal_NPCShop_ALL._isConsole then
    ReqeustDialog_retryTalk()
  end
  if PaGlobal_Camp:getIsCamping() then
    InventoryWindow_Close()
    PaGlobal_Camp:open()
  end
  PaGlobal_NPCShop_ALL:close(showAni)
end
function PaGlobal_NPCShop_ALL:close(showAni)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:audioPostEvent(1, 1, PaGlobal_NPCShop_ALL._isConsole)
  if nil == showAni then
    Panel_Dialog_NPCShop_All:SetShow(false, false)
    return
  else
    Panel_Dialog_NPCShop_All:SetShow(false, showAni)
  end
end
function PaGlobal_NPCShop_ALL:tabButtonClick(idx)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  Panel_Tooltip_Item_hideTooltip()
  for ii = 0, 2 do
    if ii == idx then
      PaGlobal_NPCShop_ALL._radioButton_Tab[ii]:SetCheck(true)
      PaGlobal_NPCShop_ALL._radioButton_Tab[ii]:SetFontColor(PaGlobal_NPCShop_ALL._TABCOLORSELECTED)
      local selectBarSapnX = PaGlobal_NPCShop_ALL._radioButton_Tab[ii]:GetSpanSize().x
      local selectBarSapnY = PaGlobal_NPCShop_ALL._ui._stc_SelectBar:GetSpanSize().y
      PaGlobal_NPCShop_ALL._ui._stc_SelectBar:SetSpanSize(selectBarSapnX, selectBarSapnY)
    else
      PaGlobal_NPCShop_ALL._radioButton_Tab[ii]:SetCheck(false)
      PaGlobal_NPCShop_ALL._radioButton_Tab[ii]:SetFontColor(PaGlobal_NPCShop_ALL._TABCOLORBASE)
    end
  end
  if true == PaGlobal_NPCShop_ALL._isConsole then
    if PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY == idx then
      PaGlobal_NPCShop_ALL._ui._console._stc_Key_Purchase:SetText(PAGetString(Defines.StringSheet_GAME, "NPCSHOP_BUY"))
    elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXSELL == idx then
      PaGlobal_NPCShop_ALL._ui._console._stc_Key_Purchase:SetText(PAGetString(Defines.StringSheet_GAME, "NPCSHOP_SELL"))
    elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXREBUY == idx then
      PaGlobal_NPCShop_ALL._ui._console._stc_Key_Purchase:SetText(PAGetString(Defines.StringSheet_GAME, "NPCSHOP_REPURCHASE"))
    end
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_NPCShop_ALL._keyGuideList, PaGlobal_NPCShop_ALL._ui._console._stc_KeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  end
  if idx ~= PaGlobal_NPCShop_ALL._value._currentTabIndex then
    PaGlobal_NPCShop_ALL._value._selectedSlotIndex = nil
    PaGlobal_NPCShop_ALL._value._lastTabIndex = PaGlobal_NPCShop_ALL._value._currentTabIndex
    PaGlobal_NPCShop_ALL._value._currentTabIndex = idx
    if 2 == idx then
      ToClient_NpcShop_UpdateRepurchaseList()
    elseif false == PaGlobal_NPCShop_ALL._ui._stc_Scroll_Vertical:GetShow() then
      PaGlobal_NPCShop_ALL._ui._stc_Scroll_Vertical:SetEnable(true)
      PaGlobal_NPCShop_ALL._ui._stc_Scroll_Vertical:SetMonoTone(false)
      PaGlobal_NPCShop_ALL._ui._stc_Scroll_Vertical:SetShow(true)
    end
    PaGlobal_NPCShop_ALL._ui._stc_Scroll_Vertical:SetControlPos(0)
    PaGlobal_NPCShop_ALL._value._scrollPos = PaGlobal_NPCShop_ALL._ui._stc_Scroll_Vertical:GetControlPos()
    PaGlobal_NPCShop_ALL:PushKeyToList2()
  end
  PaGlobal_NPCShop_ALL:multiPurposeBtn_ShowToggle()
  PaGlobal_NPCShop_ALL:checkInit()
end
function PaGlobal_NPCShop_ALL:UpdateMoney()
  if true == _ContentsGroup_InvenUpdateCheck and false == Panel_Window_NpcShop:GetShow() then
    return
  end
  if npcShop_isGuildShopContents() then
    local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
    if nil ~= myGuildListInfo then
      PaGlobal_NPCShop_ALL._ui._stc_player_Silver:SetShow(false)
      PaGlobal_NPCShop_ALL._ui._stc_Guild_Silver:SetShow(true)
      PaGlobal_NPCShop_ALL._ui._btn_Check_Inven_Guild:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_NPCSHOP_GUILDPRICELIMITED"))
      PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse_Guild:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_GUILDMONEY"))
      if nil ~= getSelfPlayer() then
        if false == getSelfPlayer():get():isGuildMaster() and true == getSelfPlayer():get():getGuildIsPriceLimit() then
          PaGlobal_NPCShop_ALL._ui._txt_Silver_Inven_Guild:SetText(makeDotMoney(getSelfPlayer():get():getGuildPriceLimit()))
        else
          PaGlobal_NPCShop_ALL._ui._txt_Silver_Inven_Guild:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_USEGUILDFUNDS_UNLIMITED"))
        end
      end
      PaGlobal_NPCShop_ALL._ui._txt_Silver_Storage_Guild:SetText(makeDotMoney(myGuildListInfo:getGuildBusinessFunds_s64()))
    else
      PaGlobal_NPCShop_ALL._ui._stc_player_Silver:SetShow(false)
      PaGlobal_NPCShop_ALL._ui._stc_Guild_Silver:SetShow(false)
      return
    end
  elseif nil ~= getSelfPlayer() then
    PaGlobal_NPCShop_ALL._ui._stc_Guild_Silver:SetShow(false)
    PaGlobal_NPCShop_ALL._ui._stc_player_Silver:SetShow(true)
    PaGlobal_NPCShop_ALL._ui._txt_Silver_Inven:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
    PaGlobal_NPCShop_ALL._ui._txt_Silver_Storage:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
    if not ToClient_HasWareHouseFromNpc() then
      PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:SetShow(false)
      PaGlobal_NPCShop_ALL._ui._txt_Silver_Storage:SetShow(false)
    else
      PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:SetShow(true)
      PaGlobal_NPCShop_ALL._ui._txt_Silver_Storage:SetShow(true)
    end
  end
end
function PaGlobal_NPCShop_ALL:UpdateMoneyWithContent()
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  PaGlobal_NPCShop_ALL:UpdateMoney()
  PaGlobal_NPCShop_ALL:PushKeyToList2()
end
function PaGlobal_NPCShop_ALL:checkBoxToggle(check)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
    return
  end
  if true == PaGlobal_NPCShop_ALL._isConsole then
    if 0 == check then
      if false == PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:IsCheck() then
        PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:SetCheck(false)
      else
        PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:SetCheck(true)
      end
    elseif false == PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:IsCheck() then
      PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:SetCheck(false)
    else
      PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:SetCheck(true)
    end
  else
    if 0 == check then
      if true == PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:IsCheck() then
        PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:SetCheck(false)
        PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:SetCheck(true)
      else
        PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:SetCheck(true)
      end
    elseif true == PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:IsCheck() then
      PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:SetCheck(false)
      PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:SetCheck(true)
    else
      PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:SetCheck(true)
    end
    if Panel_NumberPad_IsPopUp() and Panel_NumberPad_IsType("NpcShop_BuySome") then
      PaGlobal_NPCShop_ALL:buySome()
    end
  end
end
function PaGlobal_NPCShop_ALL:buySome()
  if nil == PaGlobal_NPCShop_ALL._value._selectedSlotIndex or nil == getSelfPlayer() then
    return
  end
  local shopItemWrapper = npcShop_getItemBuy(PaGlobal_NPCShop_ALL._value._selectedSlotIndex)
  local shopItem = shopItemWrapper:get()
  local itemEnchantStaticStatus = shopItemWrapper:getStaticStatus():get()
  local money_s64 = getSelfPlayer():get():getInventory():getMoney_s64()
  local s64_allWeight = Int64toInt32(getSelfPlayer():get():getCurrentWeight_s64())
  local s64_maxWeight = Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64())
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:IsCheck() then
    money_s64 = warehouse_moneyFromNpcShop_s64()
  end
  if true == npcShop_isGuildShopContents() then
    if not PaGlobal_NPCShop_ALL:guildCheckByBuy() then
      return
    end
    money_s64 = myGuildListInfo:getGuildBusinessFunds_s64()
    if money_s64 < shopItem:getItemPriceWithOption() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_NPCSHOP_GUILDPRICELIMITED_NOMONEY"))
      return
    end
  end
  if money_s64 < shopItem:getItemPriceWithOption() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Money"))
    return
  end
  local s64_maxMoneyNumber = money_s64 / shopItem:getItemPriceWithOption()
  local s64_maxWeightNumber = Defines.s64_const.s64_0
  local itemWeight
  if PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:IsCheck() then
    itemWeight = itemEnchantStaticStatus._weight - Int64toInt32(shopItem:getItemPriceWithOption()) * 2
  else
    itemWeight = itemEnchantStaticStatus._weight
  end
  if s64_allWeight < s64_maxWeight then
    s64_maxWeightNumber = toInt64(0, math.floor((s64_maxWeight - s64_allWeight) / itemWeight))
  end
  if s64_maxMoneyNumber < s64_maxWeightNumber or s64_maxWeightNumber < Defines.s64_const.s64_0 then
    s64_maxWeightNumber = s64_maxMoneyNumber
  end
  if 0 < shopItem:getNeedIntimacy() then
    local talker = dialog_getTalker()
    local intimacyValue = talker:getIntimacy()
    local reduceIntimacyValue = math.abs(shopItem:getItemIntimacy())
    local maxNumber = toInt64(0, math.floor(intimacyValue / reduceIntimacyValue))
    if 0 == reduceIntimacyValue then
      s64_maxMoneyNumber = toInt64(0, 0)
    elseif maxNumber < s64_maxMoneyNumber then
      s64_maxMoneyNumber = maxNumber
    end
    if s64_maxWeightNumber > maxNumber then
      s64_maxWeightNumber = maxNumber
    end
  end
  if true == PaGlobal_NPCShop_ALL._isConsole then
    if true == shopItemWrapper:getStaticStatus():get():isStackableXXX() then
      Panel_NumberPad_Show(true, s64_maxMoneyNumber, nil, HandleEventLUp_NPCShop_ALL_BuyOrSellItem, nil, nil, nil, nil, s64_maxWeightNumber)
      Panel_NumberPad_SetType("NpcShop_BuySome")
    else
      PaGlobal_NPCShop_ALL:buyOrSellItem()
    end
  else
    Panel_NumberPad_Show(true, s64_maxMoneyNumber, param, HandleEventLUp_NPCShop_ALL_BuyOrSellItem, nil, nil, nil, nil, s64_maxWeightNumber)
    Panel_NumberPad_SetType("NpcShop_BuySome")
  end
end
function PaGlobal_NPCShop_ALL:sellItemAll()
  if nil == PaGlobal_NPCShop_ALL._value._selectedSlotIndex or nil == getSelfPlayer() then
    return
  end
  local selectedIndex = PaGlobal_NPCShop_ALL._value._selectedSlotIndex
  local shopItemWrapper = npcShop_getItemSell(selectedIndex)
  local shopItem = shopItemWrapper:get()
  local inventory = getSelfPlayer():get():getInventory()
  local shopItemSSW = npcShop_getItemWrapperByShopSlotNo(selectedIndex)
  local s64_inventoryItemCount = inventory:getItemCount_s64(shopItemWrapper:getStaticStatus():get()._key)
  local itemCount = Int64toInt32(s64_inventoryItemCount)
  local pricePiece = Int64toInt32(shopItemSSW:getSellPriceCalculate(shopItem:getItemPriceOption()))
  local totalPrice = pricePiece * itemCount
  local toWhereType = CppEnums.ItemWhereType.eInventory
  local itemSSW = npcShop_getItemWrapperByShopSlotNo(selectedIndex)
  local shopItemEndurance = itemSSW:get():getEndurance()
  local isSocketed = false
  local itemKeyForTradeInfo = shopItemWrapper:getStaticStatus():get()._key:get()
  local tradeMasterInfo = getItemMarketMasterByItemEnchantKey(itemKeyForTradeInfo)
  if npcShop_isGuildShopContents() then
    toWhereType = CppEnums.ItemWhereType.eGuildWarehouse
  elseif PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:IsCheck() then
    toWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  local function SellMessageShow()
    if true == PaGlobal_NPCShop_ALL._isConsole then
      Panel_NumberPad_Show(true, s64_inventoryItemCount, selectedIndex, PaGlobalFunc_NPCShop_ALL_ConfirmSellAll)
    else
      PaGlobalFunc_NPCShop_ALL_ConfirmSellAll(itemCount, selectedIndex)
    end
  end
  local function sellAllDoit()
    local socketMaxCount = ToClient_GetMaxItemSocketCount()
    for jewelIndex = 0, socketMaxCount - 1 do
      local itemEnchantSSW = itemSSW:getPushedItem(jewelIndex)
      if nil ~= itemEnchantSSW then
        isSocketed = true
      end
    end
    if true == isSocketed then
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_1")
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"),
        content = messageBoxMemo,
        functionYes = SellMessageShow,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    else
      SellMessageShow()
    end
  end
  if nil ~= tradeMasterInfo and 0 ~= shopItemEndurance then
    if totalPrice >= 500000 and toWhereType ~= CppEnums.ItemWhereType.eGuildWarehouse and not ToClient_HasWareHouseFromNpc() then
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_HIGHWEIGHT_WARNING_FOR_ITEMMARKET")
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"),
        content = messageBoxMemo,
        functionYes = sellAllDoit,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    elseif true == _ContentsGroup_RenewUI_ItemMarketPlace then
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_ITEMMARKET_USE_MSGMEMO")
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"),
        content = messageBoxMemo,
        functionYes = sellAllDoit,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    else
      sellAllDoit()
    end
  elseif totalPrice >= 500000 and toWhereType ~= CppEnums.ItemWhereType.eGuildWarehouse and not ToClient_HasWareHouseFromNpc() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_HIGHWEIGHT_WARNING")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"),
      content = messageBoxMemo,
      functionYes = sellAllDoit,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    sellAllDoit()
  end
  DragManager:clearInfo()
  PaGlobal_NPCShop_ALL._value._scrollPos = PaGlobal_NPCShop_ALL._ui._stc_Scroll_Vertical:GetControlPos()
end
function PaGlobal_NPCShop_ALL:inventoryShow()
  if nil == Panel_Dialog_NPCShop_All then
    return
  end
  if false == PaGlobal_NPCShop_ALL._isConsole and true == _ContentsGroup_RenewUI_ItemMarketPlace_Only and true == Panel_Window_MarketPlace_WalletInventory:GetShow() then
    PaGlobalFunc_MarketWallet_ForceClose()
  end
  UIAni.fadeInSCRDialog_Left(Panel_Window_Inventory)
  InventoryWindow_Show()
  PaGlobal_NPCShop_ALL:audioPostEvent(1, 0, false)
end
function PaGlobal_NPCShop_ALL:checkInit()
  if true == npcShop_isGuildShopContents() then
    return
  end
  if PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:IsCheck() then
    return
  end
  if ToClient_HasWareHouseFromNpc() then
    PaGlobal_NPCShop_ALL._ui._txt_Silver_Storage:SetShow(true)
    PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:SetShow(true)
    if toInt64(0, 0) == warehouse_moneyFromNpcShop_s64() then
      PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:SetCheck(true)
      PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:SetCheck(false)
    else
      PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:SetCheck(false)
      PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:SetCheck(true)
    end
  else
    PaGlobal_NPCShop_ALL._ui._txt_Silver_Storage:SetShow(false)
    PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:SetShow(false)
    PaGlobal_NPCShop_ALL._ui._btn_Check_Inven:SetCheck(true)
    PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:SetCheck(false)
  end
end
function PaGlobal_NPCShop_ALL:setIsCamping(isCamping)
  if nil == Panel_Dialog_NPCShop_All then
    return
  end
  PaGlobal_NPCShop_ALL._value._isCamping = isCamping
end
function PaGlobal_NPCShop_ALL:buyOrSellItem(inputNumber)
  if nil == PaGlobal_NPCShop_ALL._value._selectedSlotIndex or nil == getSelfPlayer() then
    return
  end
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  local toWhereType = CppEnums.ItemWhereType.eInventory
  local isCamping = PaGlobal_NPCShop_ALL._value._isCamping
  local selectedIndex = PaGlobal_NPCShop_ALL._value._selectedSlotIndex
  local selectedSlot = PaGlobal_NPCShop_ALL._createdItemSlot[selectedIndex]
  if PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:IsCheck() then
    fromWhereType = CppEnums.ItemWhereType.eWarehouse
    toWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  if PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex then
    PaGlobal_NPCShop_ALL._value._inputNumber = inputNumber
    local buyCount = inputNumber
    local shopItemWrapper = npcShop_getItemBuy(selectedIndex)
    local shopItemPrice = shopItemWrapper:get():getItemPriceWithOption()
    local myInvenMoney = getSelfPlayer():get():getInventory():getMoney_s64()
    local myWarehouseMoney = warehouse_moneyFromNpcShop_s64()
    local hasIntimacy = shopItemWrapper:getStaticStatus():hasMenatlCardKey()
    local shopItem = shopItemWrapper:get()
    local selectItemName = shopItemWrapper:getStaticStatus():getName()
    local totalPrice = shopItemPrice * inputNumber
    if true == hasIntimacy then
      return
    end
    if npcShop_isGuildShopContents() then
      fromWhereType = CppEnums.ItemWhereType.eGuildWarehouse
      if not PaGlobal_NPCShop_ALL:guildCheckByBuy() then
        return
      end
      local selfPlayer = getSelfPlayer()
      if nil ~= selfPlayer and false == selfPlayer:get():isGuildMaster() then
        local isPriceLimit = selfPlayer:get():getGuildIsPriceLimit()
        local myGuildPriceLimit = selfPlayer:get():getGuildPriceLimit()
        if Panel_NumberPad_IsPopUp() and Panel_NumberPad_IsType("NpcShop_BuySome") then
          if true == isPriceLimit and totalPrice > myGuildPriceLimit then
            Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_NPCSHOP_GUILDPRICELIMITED_NOMONEY"))
            return
          end
        elseif true == isPriceLimit and shopItemPrice > myGuildPriceLimit then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_NPCSHOP_GUILDPRICELIMITED_NOMONEY"))
          return
        end
      end
    end
    if Panel_NumberPad_IsPopUp() and Panel_NumberPad_IsType("NpcShop_BuySome") then
      local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_BUY_ALERT_TITLE")
      local contentString = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_NPCSHOP_BUY_ALERT_1", "item", tostring(selectItemName), "number", tostring(buyCount), "price", makeDotMoney(totalPrice))
      local messageboxData = {
        title = titleString,
        content = contentString,
        functionYes = PaGlobalFunc_NPCShop_ALL_ConfirmBuySome,
        functionCancel = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      if buyCount > toInt64(0, 499) or totalPrice > toInt64(0, 99999) then
        MessageBox.showMessageBox(messageboxData)
      else
        npcShop_doBuy(selectedIndex, buyCount, fromWhereType, 0, isCamping)
      end
    else
      local rv = 0
      rv = npcShop_doBuy(selectedIndex, 1, fromWhereType, 0, isCamping)
      local shopItemKey = shopItemWrapper:getStaticStatus():get()._key:getItemKey()
      if shopItemKey >= 30000 and shopItemKey < 40000 and 0 == rv then
        if PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:IsCheck() and shopItemPrice < myInvenMoney then
          selectedSlot.btn:SetIgnore(true)
          selectedSlot.icon.icon:SetMonoTone(true)
          selectedSlot.price:SetMonoTone(true)
          selectedSlot.remainCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_ALREADYHASINTIMACY"))
        elseif PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:IsCheck() and shopItemPrice < myWarehouseMoney then
          selectedSlot.btn:SetIgnore(true)
          selectedSlot.icon.icon:SetMonoTone(true)
          selectedSlot.price:SetMonoTone(true)
          selectedSlot.remainCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_ALREADYHASINTIMACY"))
        end
      end
    end
  elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXSELL == PaGlobal_NPCShop_ALL._value._currentTabIndex then
    do
      local shopItemWrapper = npcShop_getItemSell(selectedIndex)
      if nil == shopItemWrapper:get() then
        PaGlobal_NPCShop_ALL._value._selectedSlotIndex = nil
        return
      end
      local shopItem = shopItemWrapper:get()
      local shopItemSSW = npcShop_getItemWrapperByShopSlotNo(selectedIndex)
      local shopItemEndurance = shopItemSSW:get():getEndurance()
      local pricePiece = Int64toInt32(shopItemSSW:getSellPriceCalculate(shopItem:getItemPriceOption()))
      local itemKeyForTradeInfo = shopItemWrapper:getStaticStatus():get()._key:get()
      local tradeMasterInfo = getItemMarketMasterByItemEnchantKey(itemKeyForTradeInfo)
      local inventory = getSelfPlayer():get():getInventory()
      local s64_inventoryItemCount = inventory:getItemCount_s64(shopItemWrapper:getStaticStatus():get()._key)
      local itemCount32 = Int64toInt32(s64_inventoryItemCount)
      if npcShop_isGuildShopContents() then
        if not PaGlobal_NPCShop_ALL:guildCheckByBuy() then
          return
        end
        toWhereType = CppEnums.ItemWhereType.eGuildWarehouse
      end
      local function sellConfirm()
        npcShop_doSellByItemNo(selectedIndex, 1, toWhereType, isCamping)
        if nil == PaGlobal_NPCShop_ALL._value._sellingItemKey then
          PaGlobal_NPCShop_ALL._value._sellingItemKey = itemKeyForTradeInfo
        end
        if itemCount32 <= 1 or PaGlobal_NPCShop_ALL._value._sellingItemKey ~= itemKeyForTradeInfo then
          PaGlobal_NPCShop_ALL._value._selectedSlotIndex = nil
          PaGlobal_NPCShop_ALL._value._sellingItemKey = nil
        end
      end
      local function sellDoit()
        local itemSSW = npcShop_getItemWrapperByShopSlotNo(selectedIndex)
        local isSocketed = false
        local socketMaxCount = ToClient_GetMaxItemSocketCount()
        for jewelIndex = 0, socketMaxCount - 1 do
          local itemEnchantSSW = itemSSW:getPushedItem(jewelIndex)
          if nil ~= itemEnchantSSW then
            isSocketed = true
          end
        end
        if true == isSocketed then
          local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_1")
          local messageBoxData = {
            title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"),
            content = messageBoxMemo,
            functionYes = sellConfirm,
            functionNo = MessageBox_Empty_function,
            priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
          }
          MessageBox.showMessageBox(messageBoxData)
        else
          sellConfirm()
        end
        if CppEnums.ItemWhereType.eWarehouse == toWhereType then
          Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_MONEYFORWAREHOUSE_ACK", "getMoney", makeDotMoney(pricePiece)), 6)
        end
      end
      if nil ~= tradeMasterInfo and 0 ~= shopItemEndurance then
        local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_ITEMMARKET_USE_MSGMEMO")
        local messageBoxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"),
          content = messageBoxMemo,
          functionYes = sellDoit,
          functionNo = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageBoxData)
      else
        sellDoit()
      end
    end
  elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXREBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex then
    npcShop_doRepurchase(selectedIndex, fromWhereType, isCamping)
    PaGlobal_NPCShop_ALL._value._selectedSlotIndex = nil
  end
  DragManager:clearInfo()
  PaGlobal_NPCShop_ALL._value._scrollPos = PaGlobal_NPCShop_ALL._ui._stc_Scroll_Vertical:GetControlPos()
end
function PaGlobal_NPCShop_ALL:guildCheckByBuy()
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DIALOGUE_NPCSHOP_GUILD1"))
    return false
  end
  local guildGrade = myGuildInfo:getGuildGrade()
  if 0 == guildGrade then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DIALOGUE_NPCSHOP_GUILD2"))
    return false
  end
  if nil == getSelfPlayer() then
    return
  end
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  local isSupplyOfficer = getSelfPlayer():get():isGuildSupplyOfficer()
  return true
end
function PaGlobal_NPCShop_ALL:audioPostEvent(idx, value, isConsole)
  if nil == Panel_Dialog_NPCShop_All then
    return
  end
  if true == PaGlobal_NPCShop_ALL._isConsole and true == isConsole then
    _AudioPostEvent_SystemUiForXBOX(idx, value)
  elseif false == PaGlobal_NPCShop_ALL._isConsole and false == isConsole then
    audioPostEvent_SystemUi(idx, value)
  end
end
function PaGlobal_NPCShop_ALL:changeTapByPad(idx)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() or false == PaGlobal_NPCShop_ALL._isConsole then
    return
  end
  PaGlobal_NPCShop_ALL:audioPostEvent(51, 7, true)
  local activeTabCount = 0
  for _, v in pairs(PaGlobal_NPCShop_ALL._radioButton_Tab) do
    if nil ~= v and v:GetShow() then
      activeTabCount = activeTabCount + 1
    end
  end
  if 1 == activeTabCount then
    return
  end
  local resultTab = PaGlobal_NPCShop_ALL._value._currentTabIndex + idx
  if resultTab <= -1 then
    resultTab = 2
  elseif resultTab >= 3 then
    resultTab = 0
  else
    PaGlobal_NPCShop_ALL:tabButtonClick(resultTab)
    return
  end
  PaGlobal_NPCShop_ALL:tabButtonClick(resultTab)
end
function PaGlobal_NPCShop_ALL:ShowToolTipByPad(selectedIndex, show)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() or false == PaGlobal_NPCShop_ALL._isConsole then
    return
  end
  PaGlobal_NPCShop_ALL._value._selectedSlotIndex = selectedIndex
  if true == show then
    local shopItemWrapper
    if PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex then
      shopItemWrapper = npcShop_getItemBuy(selectedIndex)
    elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXSELL == PaGlobal_NPCShop_ALL._value._currentTabIndex then
      shopItemWrapper = npcShop_getItemSell(selectedIndex)
    elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXREBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex then
      shopItemWrapper = npcShop_getItemRepurchase(selectedIndex)
    end
    if nil == shopItemWrapper then
      return
    end
    local itemSSW = shopItemWrapper:getStaticStatus()
    PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.Item, 0, getScreenSizeX())
    PaGlobal_NPCShop_ALL:audioPostEvent(50, 0, true)
  else
    PaGlobalFunc_TooltipInfo_Close()
  end
end
function PaGlobal_NPCShop_ALL:multiPurposeBtn_ShowToggle()
  if nil == Panel_Dialog_NPCShop_All or true == PaGlobal_NPCShop_ALL._isConsole then
    return
  end
  if PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex then
    PaGlobal_NPCShop_ALL._ui._pc._btn_BuySome:SetShow(true)
    PaGlobal_NPCShop_ALL._ui._pc._btn_SellAll:SetShow(false)
  elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXSELL == PaGlobal_NPCShop_ALL._value._currentTabIndex then
    PaGlobal_NPCShop_ALL._ui._pc._btn_SellAll:SetShow(true)
    PaGlobal_NPCShop_ALL._ui._pc._btn_BuySome:SetShow(false)
  else
    PaGlobal_NPCShop_ALL._ui._pc._btn_BuySome:SetShow(false)
    PaGlobal_NPCShop_ALL._ui._pc._btn_SellAll:SetShow(false)
  end
end
function PaGlobal_NPCShop_ALL:onRSlotClicked(slotIdx)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() or true == PaGlobal_NPCShop_ALL.isConsole then
    return
  end
  PaGlobal_NPCShop_ALL:onSlotClicked(slotIdx)
  PaGlobal_NPCShop_ALL:buyOrSellItem()
  PaGlobal_NPCShop_ALL._value._selectedSlotIndex = nil
end
function PaGlobal_NPCShop_ALL:InvenItemRClick(idx)
  if nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() then
  end
  local itemWrapper = getInventoryItem(idx)
  local itemCount
  if nil ~= itemWrapper then
    itemCount = itemWrapper:get():getCount_s64()
    if Defines.s64_const.s64_1 == itemCount then
      PaGlobalFunc_NPCShop_ALL_InvenItemSell(1, idx)
    else
      Panel_NumberPad_Show(true, itemCount, idx, PaGlobalFunc_NPCShop_ALL_InvenItemSell)
    end
  end
end
function PaGlobal_NPCShop_ALL:InvenItemSell(itemCount, idx)
  if nil == idx or nil == Panel_Dialog_NPCShop_All or false == Panel_Dialog_NPCShop_All:GetShow() or true == PaGlobal_NPCShop_ALL.isConsole then
    return
  end
  local playerWrapper = getSelfPlayer()
  if nil == playerWrapper then
    return
  end
  local e100Percent = 1000000
  local itemWrapper = getInventoryItem(idx)
  local itemSSW = itemWrapper:getStaticStatus()
  local itemEndurance = itemWrapper:get():getEndurance()
  local sellPrice_64 = itemWrapper:getSellPriceCalculate(e100Percent)
  local sellPrice_32 = Int64toInt32(sellPrice_64)
  local itemCount_32 = Int64toInt32(itemCount)
  local sellPrice = sellPrice_32 * itemCount_32
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  local toWhereType = CppEnums.ItemWhereType.eInventory
  if npcShop_isGuildShopContents() then
    if not PaGlobal_NPCShop_ALL:guildCheckByBuy() then
      return
    end
    toWhereType = CppEnums.ItemWhereType.eGuildWarehouse
  elseif PaGlobal_NPCShop_ALL._ui._btn_Check_Warehouse:IsCheck() then
    toWhereType = CppEnums.ItemWhereType.eWarehouse
  else
    toWhereType = CppEnums.ItemWhereType.eInventory
  end
  local function sellConfirm()
    playerWrapper:get():requestSellItem(idx, itemCount, fromWhereType, toWhereType, PaGlobal_NPCShop_ALL._value._isCamping)
    if CppEnums.ItemWhereType.eWarehouse == toWhereType then
      Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_MONEYFORWAREHOUSE_ACK", "getMoney", makeDotMoney(sellPrice)), 6)
    end
  end
  local function sellDoit()
    warehouse_requestInfo(getCurrentWaypointKey())
    local isSocketed = false
    local socketMaxCount = ToClient_GetMaxItemSocketCount()
    for jewelIndex = 0, socketMaxCount - 1 do
      local itemEnchantSSW = itemWrapper:getPushedItem(jewelIndex)
      if nil ~= itemEnchantSSW then
        isSocketed = true
      end
    end
    if true == isSocketed then
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_1")
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"),
        content = messageBoxMemo,
        functionYes = sellConfirm,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    else
      playerWrapper:get():requestSellItem(idx, itemCount, fromWhereType, toWhereType, PaGlobal_NPCShop_ALL._value._isCamping)
    end
    if CppEnums.ItemWhereType.eWarehouse == toWhereType then
      Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_MONEYFORWAREHOUSE_ACK", "getMoney", makeDotMoney(sellPrice)), 6)
    end
  end
  if false == _ContentsGroup_RenewUI_ItemMarketPlace then
    sellDoit()
    return
  end
  local itemKeyForTradeInfo = itemWrapper:getStaticStatus():get()._key:get()
  local tradeMasterInfo = getItemMarketMasterByItemEnchantKey(itemKeyForTradeInfo)
  if nil ~= tradeMasterInfo and 0 ~= itemEndurance then
    if sellPrice >= 500000 and toWhereType ~= CppEnums.ItemWhereType.eGuildWarehouse and not ToClient_HasWareHouseFromNpc() then
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_HIGHWEIGHT_WARNING_FOR_ITEMMARKET")
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"),
        content = messageBoxMemo,
        functionYes = sellDoit,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    elseif true == _ContentsGroup_RenewUI_ItemMarketPlace then
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_ITEMMARKET_USE_MSGMEMO")
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"),
        content = messageBoxMemo,
        functionYes = sellDoit,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    end
  elseif sellPrice >= 500000 and toWhereType ~= CppEnums.ItemWhereType.eGuildWarehouse and not ToClient_HasWareHouseFromNpc() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_HIGHWEIGHT_WARNING")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"),
      content = messageBoxMemo,
      functionYes = sellDoit,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    sellDoit()
  end
  PaGlobal_NPCShop_ALL._value._scrollPos = PaGlobal_NPCShop_ALL._ui._stc_Scroll_Vertical:GetControlPos()
end
function PaGlobal_NPCShop_ALL:createItem(content, dataIndex, col)
  local item = {
    btn = nil,
    dataIndex = nil,
    text = nil,
    desc = nil,
    price = nil,
    slot = nil,
    icon = {},
    coinIcon = nil,
    isStackable = nil
  }
  item.btn = UI.getChildControl(content, "RadioButton_" .. col)
  item.dataIndex = dataIndex
  item.text = UI.getChildControl(item.btn, "StaticText_Name")
  item.desc = UI.getChildControl(item.btn, "StaticText_Desc")
  item.price = UI.getChildControl(item.btn, "StaticText_Price")
  item.slot = UI.getChildControl(item.btn, "Static_Item_Slot")
  item.coinIcon = UI.getChildControl(item.btn, "Static_PriceIcon")
  if true == PaGlobal_NPCShop_ALL._isConsole then
    item.btn:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_NPCShop_ALL_BuySomeOrSellByPad(" .. dataIndex .. ")")
    item.btn:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_NPCShop_ALL_ShowToolTipByPad(" .. dataIndex .. ", true )")
  else
    item.btn:addInputEvent("Mouse_LUp", "HandleEventLUp_NPCShop_ALL_OnSlotClicked(" .. dataIndex .. ")")
    item.btn:addInputEvent("Mouse_RUp", "HandleEventLUp_NPCShop_ALL_OnRSlotClicked(" .. dataIndex .. ")")
    item.btn:addInputEvent("Mouse_On", "HandleEventOnOut_NPCShop_ALL_ShowToolTipByMouse(" .. dataIndex .. ",true)")
    item.btn:addInputEvent("Mouse_Out", "HandleEventOnOut_NPCShop_ALL_ShowToolTipByMouse(" .. dataIndex .. ",false)")
  end
  PaGlobal_NPCShop_ALL._createdItemSlot[dataIndex] = item
end
function PaGlobal_NPCShop_ALL:setItem(dataIndex, itemStaticWrapper, s64_stackCount, s64_price, s64_invenCount, rentTime, Intimacy, disable)
  if nil == Panel_Dialog_NPCShop_All and nil == PaGlobal_NPCShop_ALL._createdItemSlot[dataIndex] and nil == itemStaticWrapper then
    return
  end
  local npc
  local characterKey = 0
  local count = 0
  local intimacyValue = 0
  local createdSlot = PaGlobal_NPCShop_ALL._createdItemSlot
  if false == PaGlobal_NPCShop_ALL._value._isCamping or nil == PaGlobal_NPCShop_ALL._value._isCamping then
    npc = dialog_getTalker()
    characterKey = npc:getCharacterKey()
    count = getIntimacyInformationCount(characterKey)
    intimacyValue = npc:getIntimacy()
  end
  local enable = PaGlobal_NPCShop_ALL._CONST.s64_0 ~= s64_stackCount and not disable
  local hasIntimacy = itemStaticWrapper:hasMenatlCardKey()
  createdSlot[dataIndex].text:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  createdSlot[dataIndex].text:SetText(itemStaticWrapper:getName())
  createdSlot[dataIndex].price:SetText(makeDotMoney(s64_price))
  createdSlot[dataIndex].desc:SetFontColor(PaGlobal_NPCShop_ALL._COLORCANBUY)
  if enable then
    createdSlot[dataIndex].text:SetFontColor(PaGlobal_NPCShop_ALL._UI_COLOR.C_FFFFFFFF)
  else
    createdSlot[dataIndex].text:SetFontColor(PaGlobal_NPCShop_ALL._UI_COLOR.C_FFAAAAAA)
  end
  if PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex then
    if nil ~= PaGlobal_NPCShop_ALL._value._selectedSlotIndex then
      createdSlot[PaGlobal_NPCShop_ALL._value._selectedSlotIndex].btn:SetCheck(true)
    end
  elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXSELL == PaGlobal_NPCShop_ALL._value._currentTabIndex and nil ~= PaGlobal_NPCShop_ALL._value._selectedSlotIndex then
    createdSlot[PaGlobal_NPCShop_ALL._value._selectedSlotIndex].btn:SetCheck(true)
  end
  if 0 == dataIndex % 2 or 0 == dataIndex then
    SlotItem.reInclude(createdSlot[dataIndex].icon, "Left_Item_Icon_", 0, createdSlot[dataIndex].slot, PaGlobal_NPCShop_ALL._slotConfig)
  else
    SlotItem.reInclude(createdSlot[dataIndex].icon, "Right_Item_Icon_", 0, createdSlot[dataIndex].slot, PaGlobal_NPCShop_ALL._slotConfig)
  end
  createdSlot[dataIndex].icon:setItemByStaticStatus(itemStaticWrapper)
  if false == PaGlobal_NPCShop_ALL._isConsole then
    createdSlot[dataIndex].icon.icon:addInputEvent("Mouse_On", "HandleEventOnOut_NPCShop_ALL_ShowToolTipByMouse(" .. dataIndex .. ",true)")
    createdSlot[dataIndex].icon.icon:addInputEvent("Mouse_Out", "HandleEventOnOut_NPCShop_ALL_ShowToolTipByMouse(" .. dataIndex .. ",false)")
    Panel_Tooltip_Item_SetPosition(dataIndex, createdSlot[dataIndex].icon, "shop")
  end
  local strCount = string.format("%d", Int64toInt32(s64_stackCount))
  if s64_stackCount < PaGlobal_NPCShop_ALL._CONST.s64_0 then
    local itemType = itemStaticWrapper:getItemType()
    if PaGlobal_NPCShop_ALL._ENUMTABINDEXSELL == PaGlobal_NPCShop_ALL._value._currentTabIndex then
      if 17 == itemType then
        createdSlot[dataIndex].desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NPCSHOP_USELESSITEM"))
      else
        createdSlot[dataIndex].desc:SetText("")
      end
    elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex then
      createdSlot[dataIndex].desc:SetText(PAGetString(Defines.StringSheet_GAME, "NPCSHOP_SOLDOUT"))
    end
    createdSlot[dataIndex].icon.icon:SetMonoTone(false)
    createdSlot[dataIndex].price:SetMonoTone(false)
    createdSlot[dataIndex].coinIcon:SetMonoTone(false)
    createdSlot[dataIndex].desc:SetMonoTone(false)
  else
    createdSlot[dataIndex].desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "NPCSHOP_REMAIN_COUNT", "count", strCount))
  end
  if nil ~= rentTime and rentTime > 0 then
    createdSlot[dataIndex].desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEM_ABLE_RENTTIME", "itemRentTime", rentTime))
  end
  if nil ~= Intimacy and Intimacy > 0 and (false == PaGlobal_NPCShop_ALL._value._isCamping or nil == PaGlobal_NPCShop_ALL._value._isCamping) then
    createdSlot[dataIndex].desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "NPCSHOP_NEED_INTIMACY", "intimacy", Intimacy))
    if Intimacy > intimacyValue then
      createdSlot[dataIndex].slot:SetMonoTone(true)
      createdSlot[dataIndex].price:SetMonoTone(true)
      createdSlot[dataIndex].coinIcon:SetMonoTone(true)
      createdSlot[dataIndex].desc:SetMonoTone(true)
    end
  end
  local craftType
  local lifeminLevel = 0
  craftType = itemStaticWrapper:get():getLifeExperienceType()
  lifeminLevel = itemStaticWrapper:get():getLifeMinLevel(craftType)
  if lifeminLevel > 0 then
    local myLifeLevel = getSelfPlayer():get():getLifeExperienceLevel(craftType)
    if lifeminLevel > myLifeLevel then
      createdSlot[dataIndex].desc:SetFontColor(PaGlobal_NPCShop_ALL._COLORCANNOTBUY)
      createdSlot[dataIndex].desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_EQUIP_IMPOSSIBLE"))
    else
      createdSlot[dataIndex].desc:SetFontColor(PaGlobal_NPCShop_ALL._COLORCANBUY)
      createdSlot[dataIndex].desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_EQUIP_POSSIBLE"))
    end
  end
  local itemStatic = itemStaticWrapper:get()
  createdSlot[dataIndex].isStackable = itemStatic:isStackableXXX()
  if nil ~= s64_invenCount and createdSlot[dataIndex].isStackable == true then
    local strCount = string.format("%d", Int64toInt32(s64_invenCount))
    createdSlot[dataIndex].desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "NPCSHOP_HAVE_COUNT", "count", strCount))
  end
  if true == hasIntimacy then
    createdSlot[dataIndex].btn:SetIgnore(true)
    createdSlot[dataIndex].icon.icon:SetMonoTone(true)
    createdSlot[dataIndex].price:SetMonoTone(true)
    createdSlot[dataIndex].coinIcon:SetMonoTone(true)
    createdSlot[dataIndex].desc:SetShow(true)
    createdSlot[dataIndex].desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_ALREADYHASINTIMACY"))
  else
    createdSlot[dataIndex].btn:SetIgnore(false)
    createdSlot[dataIndex].icon.icon:SetMonoTone(false)
    createdSlot[dataIndex].price:SetMonoTone(false)
    createdSlot[dataIndex].coinIcon:SetMonoTone(false)
  end
  local moneyItemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, getMoneySlotNo())
  local myInvenMoney_s64 = toInt64(0, 0)
  if nil ~= moneyItemWrapper then
    myInvenMoney_s64 = moneyItemWrapper:get():getCount_s64()
  end
  local myWareHouseMoney_s64 = warehouse_moneyFromNpcShop_s64()
  if npcShop_isGuildShopContents() then
    local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
    if nil ~= myGuildListInfo then
      if PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex and s64_price > myGuildListInfo:getGuildBusinessFunds_s64() then
        createdSlot[dataIndex].price:SetFontColor(PaGlobal_NPCShop_ALL._COLORCANNOTBUY)
      else
        createdSlot[dataIndex].price:SetFontColor(PaGlobal_NPCShop_ALL._COLORCANBUY)
      end
    else
      createdSlot[dataIndex].price:SetFontColor(PaGlobal_NPCShop_ALL._COLORCANNOTBUY)
    end
  elseif PaGlobal_NPCShop_ALL._ENUMTABINDEXBUY == PaGlobal_NPCShop_ALL._value._currentTabIndex and s64_price > myInvenMoney_s64 and s64_price > myWareHouseMoney_s64 then
    createdSlot[dataIndex].price:SetFontColor(PaGlobal_NPCShop_ALL._COLORCANNOTBUY)
  else
    createdSlot[dataIndex].price:SetFontColor(PaGlobal_NPCShop_ALL._COLORCANBUY)
  end
  createdSlot[dataIndex].btn:SetShow(true)
  createdSlot[dataIndex].btn:SetCheck(false)
end
function PaGlobal_NPCShop_ALL:onSlotClicked(slotIdx)
  if nil == Panel_Dialog_NPCShop_All or true == PaGlobal_NPCShop_ALL._isConsole then
    return
  end
  if PaGlobal_NPCShop_ALL._value._selectedSlotIndex ~= slotIdx then
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  end
  if nil ~= slotIdx then
    PaGlobal_NPCShop_ALL._value._selectedSlotIndex = slotIdx
    if false == PaGlobal_NPCShop_ALL._createdItemSlot[slotIdx].isStackable then
      PaGlobal_NPCShop_ALL._ui._pc._btn_BuySome:SetMonoTone(true)
      PaGlobal_NPCShop_ALL._ui._pc._btn_BuySome:SetEnable(false)
      PaGlobal_NPCShop_ALL._ui._pc._btn_SellAll:SetMonoTone(true)
      PaGlobal_NPCShop_ALL._ui._pc._btn_SellAll:SetEnable(false)
    else
      PaGlobal_NPCShop_ALL._ui._pc._btn_BuySome:SetEnable(true)
      PaGlobal_NPCShop_ALL._ui._pc._btn_BuySome:SetMonoTone(false)
      PaGlobal_NPCShop_ALL._ui._pc._btn_SellAll:SetEnable(true)
      PaGlobal_NPCShop_ALL._ui._pc._btn_SellAll:SetMonoTone(false)
    end
  end
end

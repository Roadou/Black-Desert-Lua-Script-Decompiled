local _panel = Panel_Dialog_NPCShop
local Panel_Dialog_NPCShop_Info = {
  _initialize = false,
  _ui = {
    static_BG = nil,
    static_Title_BG = nil,
    staticText_Title_Icon_Text = nil,
    static_BG_Inner = nil,
    staticText_Tap_Group = nil,
    static_LT = nil,
    static_RT = nil,
    radioButton_Buy = nil,
    radioButton_Sell = nil,
    radioButton_Re_Buy = nil,
    radioButton_Tab = {},
    static_Line = nil,
    frame_Item_List = nil,
    frame_Content = nil,
    radioButton_Left_templete = nil,
    static_Item_Slot_Left_templete = nil,
    staticText_Name_Left_templete = nil,
    staticText_Desc_Left_templete = nil,
    staticText_Price_Left_templete = nil,
    static_PriceIcon_Left_templete = nil,
    radioButton_Right_templete = nil,
    static_Item_Slot_Right_templete = nil,
    staticText_Name_Right_templete = nil,
    staticText_Desc_Right_templete = nil,
    staticText_Price_Right_templete = nil,
    static_PriceIcon_Right_templete = nil,
    frame_VerticalScroll = nil,
    frame_HorizontalScroll = nil,
    static_Silver = nil,
    button_Inventory = nil,
    staticText_Inventory = nil,
    button_Storage = nil,
    staticText_Storage = nil,
    static_Line = nil,
    chk_invenMoney = nil,
    chk_warehouseMoney = nil,
    stc_guildSilver = nil,
    static_Key_Guide_ConsoleUI = nil,
    staticText_Move_ConsoleUI = nil,
    staticText_Cancel_ConsoleUI = nil,
    staticText_SomeOrAll_ConsoleUI = nil,
    staticText_BuyOrSell_ConsoleUI = nil
  },
  _config = {
    slotCount = 14,
    slotRows = 0,
    slotCols = 2
  },
  _space = {
    itemButtonSpaceY = 0,
    itemButtonSizeY = 0,
    tabButtonSizeX = 0,
    tabButtonSpaceX = 160
  },
  _pos = {toolTipPosX = 0, toolTipPosY = 0},
  _value = {
    isCamping = false,
    lastSelectedSlotIndex = nil,
    selectedSlotIndex = nil,
    selectedSlotKeyValue = nil,
    lastTabIndex = 0,
    lastStartSlotNo = 0,
    startSlotIndex = 0,
    lastScrollValue = 0,
    inputNumber = 0,
    itemListSize = 0,
    enableTrade = false,
    enableSell = false,
    tabCount = 3,
    prevSlotNo = nil
  },
  _enum = {
    etabIndexBuy = 0,
    etabIndexSell = 1,
    etabIndexRepurchase = 2
  },
  _text = {
    textHaveInvenMoney = PAGetString(Defines.StringSheet_RESOURCE, "SHOP_TXT_MYMONEY"),
    textHaveStorageMoney = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKET_ICON_MONEY2"),
    textShop = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_WINDOWTITLE")
  },
  _slots = {},
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = false,
    createCash = true,
    createEnchant = true,
    createEnduranceIcon = true
  },
  _showAniIsPlaying = false,
  _currentTabIndex = 0,
  _iconOriPosX = 245
}
local UI_color = Defines.Color
local _const = Defines.s64_const
local _buttonAIsPressed = false
local _elapsedTime = 0
local _buttonHoldThreshold = 0.3
local ItemSlotTemplete = {}
function ItemSlotTemplete:New()
  local slot = {
    selected = false,
    slotNo = 0,
    keyValue = -1,
    showInvenCount = false,
    isStackable = false,
    radioButton = nil,
    item_Slot = nil,
    staticText_Name = nil,
    staticText_Desc = nil,
    staticText_Price = nil
  }
  function slot:setPos(row)
    local shopInfo = Panel_Dialog_NPCShop_Info
    local spanX = self.radioButton:GetSpanSize().x
    local newSpanY = (row + 1) * shopInfo._space.itemButtonSpaceY + row * shopInfo._space.itemButtonSizeY
    self.radioButton:SetSpanSize(spanX, newSpanY)
  end
  function slot:setItem(itemStaticWrapper, s64_stackCount, s64_price, s64_invenCount, rentTime, Intimacy, disable)
    local shopInfo = Panel_Dialog_NPCShop_Info
    local talker
    local characterKey = 0
    local count = 0
    local intimacyValue = 0
    if false == shopInfo._value.isCamping or nil == shopInfo._value.isCamping then
      talker = dialog_getTalker()
      characterKey = talker:getCharacterKey()
      count = getIntimacyInformationCount(characterKey)
      intimacyValue = talker:getIntimacy()
    end
    local enable = _const.s64_0 ~= s64_stackCount and not disable
    local hasIntimacy = itemStaticWrapper:hasMenatlCardKey()
    self.staticText_Name:SetText(itemStaticWrapper:getName())
    self.staticText_Desc:SetFontColor(UI_color.C_FFFFFFFF)
    if enable then
      self.staticText_Name:SetFontColor(UI_color.C_FFFFFFFF)
    else
      self.staticText_Name:SetFontColor(UI_color.C_FFAAAAAA)
    end
    self.icon:setItemByStaticStatus(itemStaticWrapper)
    self.icon.icon:SetMonoTone(not enable)
    self.staticText_Price:SetText(makeDotMoney(s64_price))
    local posXGap = math.max(0, self.staticText_Price:GetTextSizeX() - self.staticText_Price:GetSizeX())
    local priceIconPosX = math.min(self.static_PriceIcon:GetPosX(), self.static_PriceIcon:GetPosX() - posXGap)
    self.static_PriceIcon:SetPosX(priceIconPosX)
    local strCount = string.format("%d", Int64toInt32(s64_stackCount))
    if s64_stackCount < _const.s64_0 then
      self.staticText_Desc:SetText("")
      self.icon.icon:SetMonoTone(false)
      self.staticText_Price:SetMonoTone(false)
    else
      self.staticText_Desc:SetFontColor(UI_color.C_FF3BD3FF)
      self.staticText_Desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "NPCSHOP_REMAIN_COUNT", "count", strCount))
    end
    if nil ~= rentTime and rentTime > 0 then
      self.staticText_Desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEM_ABLE_RENTTIME", "itemRentTime", rentTime))
    end
    if nil ~= Intimacy and Intimacy > 0 and (false == shopInfo._value.isCamping or nil == shopInfo._value.isCamping) then
      self.staticText_Desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "NPCSHOP_NEED_INTIMACY", "intimacy", Intimacy))
      if Intimacy > intimacyValue then
        self.staticText_Desc:SetFontColor(UI_color.C_FFBA2737)
        self.icon.icon:SetMonoTone(true)
        self.staticText_Price:SetMonoTone(true)
        self.static_PriceIcon:SetMonoTone(true)
        self.staticText_Desc:SetMonoTone(true)
      end
    end
    local craftType
    local gather = 0
    fishing = 1
    hunting = 2
    cooking = 3
    alchemy = 4
    manufacture = 5
    training = 6
    trade = 7
    local lifeminLevel = 0
    local lifeType = {
      [0] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_GATHERING"),
      [1] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_FISHING"),
      [2] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_HUNTING"),
      [3] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_COOKING"),
      [4] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_ALCHEMY"),
      [5] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_PROCESSING"),
      [6] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_OBEDIENCE"),
      [7] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE")
    }
    local craftType = itemStaticWrapper:get():getLifeExperienceType()
    local lifeminLevel = itemStaticWrapper:get():getLifeMinLevel(craftType)
    if lifeminLevel > 0 then
      local myLifeLevel = getSelfPlayer():get():getLifeExperienceLevel(craftType)
      if lifeminLevel > myLifeLevel then
        self.staticText_Desc:SetFontColor(UI_color.C_FFF26A6A)
        self.staticText_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_EQUIP_IMPOSSIBLE"))
      else
        self.staticText_Desc:SetFontColor(UI_color.C_FF3BD3FF)
        self.staticText_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_EQUIP_POSSIBLE"))
      end
    end
    local itemStatic = itemStaticWrapper:get()
    self.isStackable = itemStatic:isStackableXXX()
    if nil ~= s64_invenCount then
      if self.isStackable == true then
        local strCount = string.format("%d", Int64toInt32(s64_invenCount))
        self.staticText_Desc:SetFontColor(UI_color.C_FFEE7001)
        self.staticText_Desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "NPCSHOP_HAVE_COUNT", "count", strCount))
        self.showInvenCount = true
      else
        local strCount = string.format("%d", Int64toInt32(s64_invenCount))
        self.staticText_Desc:SetFontColor(UI_color.C_FFEE7001)
        self.staticText_Desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "NPCSHOP_HAVE_COUNT", "count", strCount))
        self.showInvenCount = false
      end
    else
      self.showInvenCount = false
    end
    if hasIntimacy then
      self.radioButton:SetIgnore(true)
      self.icon.icon:SetMonoTone(true)
      self.staticText_Name:SetMonoTone(true)
      self.staticText_Price:SetMonoTone(true)
      self.staticText_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_ALREADYHASINTIMACY"))
    else
      self.radioButton:SetIgnore(false)
      self.icon.icon:SetMonoTone(false)
      self.staticText_Name:SetMonoTone(false)
      self.staticText_Price:SetMonoTone(false)
      self.staticText_Desc:SetMonoTone(false)
    end
    local tempSizeX = self.staticText_Desc:GetPosX() + self.staticText_Desc:GetTextSizeX()
    local tempPosX = shopInfo._iconOriPosX
    if tempSizeX > shopInfo._iconOriPosX then
      tempPosX = tempPosX + (tempSizeX - shopInfo._iconOriPosX) + 10
    end
    self.static_PriceIcon:SetPosX(tempPosX)
    self.keyValue = itemStatic._key:get()
    self:setShow(true)
  end
  function slot:setShow(bShow)
    bShow = bShow or false
    self.radioButton:SetShow(bShow)
    self.staticText_Name:SetShow(bShow)
    self.staticText_Price:SetShow(bShow)
    self.static_PriceIcon:SetShow(bShow)
    self.staticText_Desc:SetShow(bShow)
    self.item_Slot:SetShow(bShow)
    self.icon.icon:SetShow(bShow)
  end
  function slot:setSelect(bSelect)
    self.selected = bSelect
    if true == _ContentsGroup_RenewUI_NpcShop then
      self.radioButton:SetCheck(bSelect)
    end
  end
  function slot:clearItem()
    self:setSelect(false)
    self:setShow(false)
    self.keyValue = -1
  end
  return slot
end
function Panel_Dialog_NPCShop_Info:registerMessageHandler()
  _panel:RegisterShowEventFunc(true, "PaGlobalFunc_Dialog_NPCShop_ShowAni()")
  _panel:RegisterShowEventFunc(false, "PaGlobalFunc_Dialog_NPCShop_HideAni()")
  _panel:RegisterUpdateFunc("FromClient_Dialog_NPCShop_UpdatePerFrame")
  registerEvent("onScreenResize", "FromClient_onScreenResize_Dialog_NPCShop")
  registerEvent("EventNpcShopUpdate", "FromClient_Dialog_NPCShop_UpdateContent")
  registerEvent("FromClient_InventoryUpdate", "FromClient_Dialog_NPCShop_UpdateMoney")
  registerEvent("EventWarehouseUpdate", "FromClient_Dialog_NPCShop_UpdateMoneyWarehouse")
  registerEvent("UpdateGuildPriceLimit", "FromClient_Dialog_NPCShop_UpdateGuildPriceLimit")
  registerEvent("FromClient_PadSnapChangeTarget", "FromClient_Dialog_NPCShop_PadSnapChangeTarget")
  registerEvent("FromClient_PadSnapChangePanel", "FromClient_Dialog_NPCShop_PadSnapChangePanel")
end
function Panel_Dialog_NPCShop_Info:registEventHandler()
  for index = 0, 2 do
    self._ui.radioButton_Tab[index]:addInputEvent("Mouse_LUp", "PaGlobalFunc_Dialog_NPCShop_TabButtonClick(" .. index .. ")")
  end
  self._ui.staticText_Cancel_ConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_Dialog_NPCShop_Close()")
  self._ui.staticText_BuyOrSell_ConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_Dialog_NPCShop_BuyOrSellItem()")
  self._ui.staticText_SomeOrAll_ConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_Dialog_NPCShop_BuySomeOrSellAllItem()")
  self._ui.button_Inventory:addInputEvent("Mouse_LUp", "Input_Dialog_NPCShop_ClickedOnToggle(true)")
  self._ui.button_Storage:addInputEvent("Mouse_LUp", "Input_Dialog_NPCShop_ClickedOnToggle(false)")
end
function Panel_Dialog_NPCShop_Info:initialize()
  self._initialize = true
  self:close()
  self:childControl()
  self:initValue()
  self:createSlot()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Dialog_NPCShop_Info:initValue()
  self._config.slotRows = self._config.slotCount / self._config.slotCols
  self._value.lastTabIndex = self._enum.etabIndexBuy
end
function Panel_Dialog_NPCShop_Info:childControl()
  self._ui.static_BG = UI.getChildControl(_panel, "Static_BG")
  self._ui.static_Title_BG = UI.getChildControl(_panel, "Static_Title_BG")
  self._ui.staticText_Title_Icon_Text = UI.getChildControl(self._ui.static_Title_BG, "StaticText_Title_Icon_Text")
  self._ui.static_BG_Inner = UI.getChildControl(_panel, "Static_BG_Inner")
  self._ui.staticText_Tap_Group = UI.getChildControl(_panel, "StaticText_Tap_Group")
  self._ui.static_LT = UI.getChildControl(self._ui.staticText_Tap_Group, "Static_LT")
  self._ui.static_RT = UI.getChildControl(self._ui.staticText_Tap_Group, "Static_RT")
  self._ui.radioButton_Buy = UI.getChildControl(self._ui.staticText_Tap_Group, "RadioButton_Buy")
  self._ui.radioButton_Sell = UI.getChildControl(self._ui.staticText_Tap_Group, "RadioButton_Sell")
  self._ui.radioButton_Re_Buy = UI.getChildControl(self._ui.staticText_Tap_Group, "RadioButton_Re_Buy")
  self._ui.radioButton_Tab[0] = self._ui.radioButton_Buy
  self._ui.radioButton_Tab[1] = self._ui.radioButton_Sell
  self._ui.radioButton_Tab[2] = self._ui.radioButton_Re_Buy
  self._space.tabButtonSizeX = self._ui.radioButton_Buy:GetSizeX()
  self._ui.frame_Item_List = UI.getChildControl(_panel, "Frame_Item_List")
  self._ui.frame_Content = UI.getChildControl(self._ui.frame_Item_List, "Frame_Content")
  self._ui.radioButton_Left_templete = UI.getChildControl(self._ui.frame_Content, "RadioButton_Left")
  self._ui.static_Item_Slot_Left_templete = UI.getChildControl(self._ui.radioButton_Left_templete, "Static_Item_Slot_Left")
  self._ui.staticText_Name_Left_templete = UI.getChildControl(self._ui.radioButton_Left_templete, "StaticText_Name_Left")
  self._ui.staticText_Desc_Left_templete = UI.getChildControl(self._ui.radioButton_Left_templete, "StaticText_Desc_Left")
  self._ui.staticText_Price_Left_templete = UI.getChildControl(self._ui.radioButton_Left_templete, "StaticText_Price_Left")
  self._ui.static_PriceIcon_Left_templete = UI.getChildControl(self._ui.radioButton_Left_templete, "Static_PriceIcon_Left")
  self._ui.radioButton_Right_templete = UI.getChildControl(self._ui.frame_Content, "RadioButton_Right")
  self._ui.static_Item_Slot_Right_templete = UI.getChildControl(self._ui.radioButton_Right_templete, "Static_Item_Slot_Right")
  self._ui.staticText_Name_Right_templete = UI.getChildControl(self._ui.radioButton_Right_templete, "StaticText_Name_Right")
  self._ui.staticText_Desc_Right_templete = UI.getChildControl(self._ui.radioButton_Right_templete, "StaticText_Desc_Right")
  self._ui.staticText_Price_Right_templete = UI.getChildControl(self._ui.radioButton_Right_templete, "StaticText_Price_Right")
  self._ui.static_PriceIcon_Right_templete = UI.getChildControl(self._ui.radioButton_Right_templete, "Static_PriceIcon_Right")
  self._ui.radioButton_Left_templete:SetShow(false)
  self._ui.static_Item_Slot_Left_templete:SetShow(false)
  self._ui.staticText_Name_Left_templete:SetShow(false)
  self._ui.staticText_Desc_Left_templete:SetShow(false)
  self._ui.staticText_Price_Left_templete:SetShow(false)
  self._ui.static_PriceIcon_Left_templete:SetShow(false)
  self._ui.radioButton_Right_templete:SetShow(false)
  self._ui.static_Item_Slot_Right_templete:SetShow(false)
  self._ui.staticText_Name_Right_templete:SetShow(false)
  self._ui.staticText_Desc_Right_templete:SetShow(false)
  self._ui.staticText_Price_Right_templete:SetShow(false)
  self._ui.static_PriceIcon_Right_templete:SetShow(false)
  self._space.itemButtonSpaceY = self._ui.radioButton_Left_templete:GetSpanSize().y
  self._space.itemButtonSizeY = self._ui.radioButton_Left_templete:GetSizeY()
  self._ui.frame_VerticalScroll = UI.getChildControl(self._ui.frame_Item_List, "Frame_VerticalScroll")
  self._ui.static_Silver = UI.getChildControl(_panel, "Static_Silver")
  self._ui.button_Inventory = UI.getChildControl(self._ui.static_Silver, "Button_Inventory")
  self._ui.staticText_Inventory = UI.getChildControl(self._ui.static_Silver, "StaticText_Inventory")
  self._ui.button_Storage = UI.getChildControl(self._ui.static_Silver, "Button_Storage")
  self._ui.staticText_Storage = UI.getChildControl(self._ui.static_Silver, "StaticText_Storage")
  self._ui.chk_invenMoney = UI.getChildControl(self._ui.static_Silver, "CheckButton_Inven")
  self._ui.chk_warehouseMoney = UI.getChildControl(self._ui.static_Silver, "CheckButton_Warehouse")
  self._ui.stc_guildSilver = UI.getChildControl(_panel, "Static_GuildSilver")
  self._ui.btn_allowance = UI.getChildControl(self._ui.stc_guildSilver, "Button_Allowance")
  self._ui.btn_guildFund = UI.getChildControl(self._ui.stc_guildSilver, "Button_Storage")
  self._ui.txt_myAllowanceValue = UI.getChildControl(self._ui.stc_guildSilver, "StaticText_Inventory")
  self._ui.txt_guildSilverValue = UI.getChildControl(self._ui.stc_guildSilver, "StaticText_Storage")
  self._ui.static_Key_Guide_ConsoleUI = UI.getChildControl(_panel, "Static_Key_Guide_ConsoleUI")
  self._ui.staticText_Move_ConsoleUI = UI.getChildControl(self._ui.static_Key_Guide_ConsoleUI, "StaticText_Move_ConsoleUI")
  self._ui.staticText_Cancel_ConsoleUI = UI.getChildControl(self._ui.static_Key_Guide_ConsoleUI, "StaticText_Cancel_ConsoleUI")
  self._ui.staticText_SomeOrAll_ConsoleUI = UI.getChildControl(self._ui.static_Key_Guide_ConsoleUI, "StaticText_A2_ConsoleUI")
  self._ui.staticText_BuyOrSell_ConsoleUI = UI.getChildControl(self._ui.static_Key_Guide_ConsoleUI, "StaticText_A_ConsoleUI")
  self._ui.staticText_XForDetail_ConsoleUI = UI.getChildControl(self._ui.static_Key_Guide_ConsoleUI, "StaticText_XForDetail_ConsoleUI")
  self._ui.stc_cirprogressBG = UI.getChildControl(self._ui.staticText_SomeOrAll_ConsoleUI, "Static_CircleProgress_PressBG")
  self._ui.cirprogress_buttonHold = UI.getChildControl(self._ui.stc_cirprogressBG, "CircularProgress_Press")
  local keyGuideList = {
    self._ui.staticText_BuyOrSell_ConsoleUI,
    self._ui.staticText_XForDetail_ConsoleUI,
    self._ui.staticText_Move_ConsoleUI,
    self._ui.staticText_Cancel_ConsoleUI
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuideList, self._ui.static_Key_Guide_ConsoleUI, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Panel_Dialog_NPCShop_Info:open(showAni)
  _elapsedTime = 0
  self._ui.stc_cirprogressBG:SetShow(false)
  if nil == showAni then
    _panel:SetShow(true, false)
    return
  else
    _panel:SetShow(true, showAni)
  end
end
function Panel_Dialog_NPCShop_Info:close(showAni)
  if nil == showAni then
    _panel:SetShow(false, false)
    return
  else
    _panel:SetShow(false, showAni)
  end
end
function Panel_Dialog_NPCShop_Info:resize()
  _panel:ComputePos()
  if Panel_Window_Inventory:GetShow() then
    local screenX = getScreenSizeX()
    local startPosX = getScreenSizeX() - Panel_Window_Inventory:GetSizeX() - 60 - _panel:GetSizeX()
    if startPosX > 0 then
      _panel:SetPosX(startPosX)
    else
      _panel:SetHorizonLeft()
    end
  end
  self._pos.toolTipPosX = _panel:GetPosX() + _panel:GetSizeX() + _panel:GetSpanSize().x
  self._pos.toolTipPosY = _panel:GetPosY() + self._ui.frame_Item_List:GetPosY()
end
function Panel_Dialog_NPCShop_Info:update()
end
function Panel_Dialog_NPCShop_Info:createSlot()
  local index = 0
  for row = 0, self._config.slotRows - 1 do
    for col = 0, self._config.slotCols - 1 do
      index = row * self._config.slotCols + col
      local strId = "" .. row .. "_" .. col
      local slot = ItemSlotTemplete:New()
      slot.slotNo = index
      if index % 2 == 0 then
        slot.radioButton = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui.frame_Content, "Content_Item_Button_" .. strId)
        CopyBaseProperty(self._ui.radioButton_Left_templete, slot.radioButton)
        slot.item_Slot = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.radioButton, "Content_Item_Slot_" .. strId)
        CopyBaseProperty(self._ui.static_Item_Slot_Left_templete, slot.item_Slot)
        slot.staticText_Name = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.radioButton, "Content_Item_Name_" .. strId)
        CopyBaseProperty(self._ui.staticText_Name_Left_templete, slot.staticText_Name)
        slot.staticText_Desc = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.radioButton, "Content_Item_Desc_" .. strId)
        CopyBaseProperty(self._ui.staticText_Desc_Left_templete, slot.staticText_Desc)
        slot.staticText_Price = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.radioButton, "Content_Item_Prce_" .. strId)
        CopyBaseProperty(self._ui.staticText_Price_Left_templete, slot.staticText_Price)
        slot.staticText_Name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
        slot.static_PriceIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.radioButton, "Content_PriceIcon_" .. strId)
        CopyBaseProperty(self._ui.static_PriceIcon_Left_templete, slot.static_PriceIcon)
      else
        slot.radioButton = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui.frame_Content, "Content_Item_Button_" .. strId)
        CopyBaseProperty(self._ui.radioButton_Right_templete, slot.radioButton)
        slot.item_Slot = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.radioButton, "Content_Item_Slot_" .. strId)
        CopyBaseProperty(self._ui.static_Item_Slot_Right_templete, slot.item_Slot)
        slot.staticText_Name = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.radioButton, "Content_Item_Name_" .. strId)
        CopyBaseProperty(self._ui.staticText_Name_Right_templete, slot.staticText_Name)
        slot.staticText_Desc = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.radioButton, "Content_Item_Desc_" .. strId)
        CopyBaseProperty(self._ui.staticText_Desc_Right_templete, slot.staticText_Desc)
        slot.staticText_Price = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.radioButton, "Content_Item_Prce_" .. strId)
        CopyBaseProperty(self._ui.staticText_Price_Right_templete, slot.staticText_Price)
        slot.staticText_Name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
        slot.static_PriceIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.radioButton, "Content_PriceIcon_" .. strId)
        CopyBaseProperty(self._ui.static_PriceIcon_Right_templete, slot.static_PriceIcon)
      end
      slot.radioButton:addInputEvent("Mouse_On", "PaGlobalFunc_Dialog_NPCShop_OnSlotClickedWithTooltip(" .. index .. ")")
      slot.radioButton:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_Dialog_NPCShop_BuySomeOrSellAllItem(" .. index .. ")")
      slot.radioButton:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_Dialog_NPCShop_ShowTooltip(" .. index .. ", true)")
      slot.radioButton:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_Dialog_NPCShop_ScrollEvent( true )")
      slot.radioButton:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_Dialog_NPCShop_ScrollEvent( false )")
      slot.icon = {}
      SlotItem.new(slot.icon, "Content_Item_Icon" .. index, index, slot.item_Slot, self._slotConfig)
      slot.icon:createChild()
      slot:setPos(row)
      slot:setShow(true)
      self._slots[index] = slot
      if row == 0 then
        slot.radioButton:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_Dialog_NPCShop_ScrollEvent( true )")
      elseif row == self._config.slotRows - 1 then
        slot.radioButton:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_Dialog_NPCShop_ScrollEvent( false )")
      end
    end
  end
end
function Panel_Dialog_NPCShop_Info:updateContent(updateForce)
  if nil == self._value.lastTabIndex or self._value.lastTabIndex < self._enum.etabIndexBuy or self._value.lastTabIndex > self._enum.etabIndexRepurchase then
    UI.ASSERT(false, [[
======== [LOVELYK2] =======
Wrong NpcShop Tab Index!! : ]] .. self._value.lastTabIndex)
    return
  end
  self:open(false)
  self:setPosTabButton()
  self._value.prevSlotNo = nil
  self._value.itemListSize = 0
  if self._enum.etabIndexBuy == self._value.lastTabIndex then
    self._value.itemListSize = npcShop_getBuyCount()
  elseif self._enum.etabIndexSell == self._value.lastTabIndex then
    self._value.itemListSize = npcShop_getSellCount()
  else
    self._value.itemListSize = npcShop_getRepurchaseCount()
  end
  self:setKeyguide()
  if self._value.itemListSize <= 0 then
    for index = 0, self._config.slotCount - 1 do
      self._slots[index]:clearItem()
    end
    PaGlobalFunc_Dialog_NPCShop_OnSlotClicked()
    self._ui.frame_VerticalScroll:SetEnable(false)
    self._ui.frame_VerticalScroll:SetMonoTone(true)
    self._ui.frame_VerticalScroll:SetShow(false)
    return
  end
  if updateForce or self._value.startSlotIndex ~= self._value.lastStartSlotNo then
    self:updateContentData()
  end
  UIScroll.SetButtonSize(self._ui.frame_VerticalScroll, self._config.slotCount, self._value.itemListSize)
  if self._value.itemListSize == self._value.startSlotIndex + self._config.slotRows then
    self._ui.frame_VerticalScroll:SetControlBottom()
  end
  PaGlobal_TutorialManager:handleNpcShopUpdateContent()
end
function Panel_Dialog_NPCShop_Info:updateContentData()
  if self._enum.etabIndexBuy ~= self._value.lastTabIndex and self._value.itemListSize >= self._config.slotRows and self._value.itemListSize < self._value.startSlotIndex + self._config.slotRows then
    self._value.startSlotIndex = self._value.startSlotIndex
    self._ui.frame_VerticalScroll:SetControlBottom()
  end
  self._value.lastStartSlotNo = self._value.startSlotIndex
  local newSelectSlot
  if nil ~= self._value.selectedSlotIndex and self._enum.etabIndexRepurchase ~= self._value.lastTabIndex then
    local maxSlotNo = math.min(self._value.startSlotIndex + self._config.slotCount, self._value.itemListSize)
    local lastSelectedSlotNo = self._slots[self._value.selectedSlotIndex].slotNo
    if lastSelectedSlotNo >= self._value.startSlotIndex and maxSlotNo > lastSelectedSlotNo then
      newSelectSlot = lastSelectedSlotNo - self._value.startSlotIndex
    end
    PaGlobalFunc_Dialog_NPCShop_OnSlotClicked()
  end
  local inventory = getSelfPlayer():get():getInventory()
  for index = 0, self._config.slotCount - 1 do
    local slot = self._slots[index]
    slot.slotNo = self._value.startSlotIndex + index
    if slot.slotNo < self._value.itemListSize then
      local shopItemWrapper, s64_inventoryItemCount
      if self._enum.etabIndexBuy == self._value.lastTabIndex then
        shopItemWrapper = npcShop_getItemBuy(slot.slotNo)
      elseif self._enum.etabIndexSell == self._value.lastTabIndex then
        shopItemWrapper = npcShop_getItemSell(slot.slotNo)
        s64_inventoryItemCount = inventory:getItemCount_s64(shopItemWrapper:getStaticStatus():get()._key)
      else
        slot.slotNo = self._value.itemListSize - slot.slotNo - 1
        shopItemWrapper = npcShop_getItemRepurchase(slot.slotNo)
      end
      local itemPrice_s64
      if nil ~= shopItemWrapper then
        local shopItem = shopItemWrapper:get()
        if self._enum.etabIndexSell == self._value.lastTabIndex then
          itemPrice_s64 = shopItem:getItemSellPriceWithOption()
          slot:setItem(shopItemWrapper:getStaticStatus(), shopItem.leftCount_s64, itemPrice_s64, s64_inventoryItemCount, shopItem:getItemUsablePeriod())
        elseif self._enum.etabIndexBuy == self._value.lastTabIndex then
          itemPrice_s64 = shopItem:getItemPriceWithOption()
          slot:setItem(shopItemWrapper:getStaticStatus(), shopItem.leftCount_s64, itemPrice_s64, s64_inventoryItemCount, shopItem:getItemUsablePeriod(), shopItem:getNeedIntimacy())
        elseif self._enum.etabIndexRepurchase == self._value.lastTabIndex then
          itemPrice_s64 = shopItem.price_s64
          slot:setItem(shopItemWrapper:getStaticStatus(), shopItem.leftCount_s64, itemPrice_s64, s64_inventoryItemCount, shopItem:getItemUsablePeriod(), shopItem:getNeedIntimacy())
        end
        if true == _ContentsGroup_RenewUI_NpcShop then
        else
          slot.icon.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. slot.slotNo .. ",\"shop\", true, nil," .. self._pos.toolTipPosX .. "," .. self._pos.toolTipPosY .. ")")
          slot.icon.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. slot.slotNo .. ",\"shop\", false, nil," .. self._pos.toolTipPosX .. "," .. self._pos.toolTipPosY .. ")")
        end
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
          if self._enum.etabIndexBuy == self._value.lastTabIndex and itemPrice_s64 > myGuildListInfo:getGuildBusinessFunds_s64() then
            slot.staticText_Price:SetFontColor(UI_color.C_FFBA2737)
          else
            slot.staticText_Price:SetFontColor(UI_color.C_FFE7E7E7)
          end
        else
          slot.staticText_Price:SetFontColor(UI_color.C_FFBA2737)
        end
      elseif self._enum.etabIndexBuy == self._value.lastTabIndex and itemPrice_s64 > myInvenMoney_s64 and itemPrice_s64 > myWareHouseMoney_s64 then
        slot.staticText_Price:SetFontColor(UI_color.C_FFBA2737)
      else
        slot.staticText_Price:SetFontColor(UI_color.C_FFE7E7E7)
      end
    else
      slot:clearItem()
    end
  end
  if nil ~= newSelectSlot then
    PaGlobalFunc_Dialog_NPCShop_OnSlotClicked(newSelectSlot)
  elseif self._value.selectedSlotIndex then
    local lastSelectedSlot = self._slots[self._value.selectedSlotIndex]
    if lastSelectedSlot.keyValue ~= self._value.selectedSlotKeyValue then
      PaGlobalFunc_Dialog_NPCShop_OnSlotClicked()
    end
  end
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    self._ui.staticText_Title_Icon_Text:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_WINDOWTITLE"))
    return
  end
end
function Panel_Dialog_NPCShop_Info:perFrameUpdate()
end
function Panel_Dialog_NPCShop_Info:preShow()
  if not PaGlobalFunc_Dialog_NPCShop_GetShow() then
    local self = Panel_Dialog_NPCShop_Info
    InventoryWindow_Show()
    self:resize()
    self:controlInit()
    self:checkInit()
    self._currentTabIndex = 0
  end
end
function Panel_Dialog_NPCShop_Info:controlInit()
  self:clearTabButton()
  self:setPosTabButton()
  self._value.lastTabIndex = self._enum.etabIndexBuy
  self._ui.radioButton_Tab[self._enum.etabIndexBuy]:SetCheck(true)
  self._ui.radioButton_Tab[self._enum.etabIndexBuy]:SetMonoTone(true)
  self._ui.radioButton_Tab[self._enum.etabIndexBuy]:SetFontColor(UI_color.C_FFFFFFFF)
  self._ui.radioButton_Tab[self._enum.etabIndexSell]:SetMonoTone(false)
  self._ui.radioButton_Tab[self._enum.etabIndexRepurchase]:SetMonoTone(false)
  self._ui.radioButton_Tab[self._enum.etabIndexBuy]:SetText(PAGetString(Defines.StringSheet_GAME, "NPCSHOP_BUY"))
  self._ui.radioButton_Tab[self._enum.etabIndexSell]:SetText(PAGetString(Defines.StringSheet_GAME, "NPCSHOP_SELL"))
  self._ui.radioButton_Tab[self._enum.etabIndexRepurchase]:SetText(PAGetString(Defines.StringSheet_GAME, "NPCSHOP_REPURCHASE"))
  PaGlobalFunc_Dialog_NPCShop_OnSlotClicked()
  self._value.lastScrollValue = 0
  self._value.lastStartSlotNo = 0
  self._value.startSlotIndex = 0
  for index = 0, self._config.slotCount - 1 do
    self._slots[index]:clearItem()
  end
  self:setKeyguide()
  local talker = dialog_getTalker()
  if nil ~= talker then
    local actorProxyWrapper = getNpcActor(talker:getActorKey())
    if nil ~= actorProxyWrapper then
      local characterSSW = actorProxyWrapper:getCharacterStaticStatusWrapper()
      if characterSSW:isSellingNormalShop() then
        self._value.enableSell = true
        self._ui.radioButton_Tab[self._enum.etabIndexSell]:SetShow(true)
        self._ui.radioButton_Tab[self._enum.etabIndexRepurchase]:SetShow(true)
      else
        self._value.enableSell = false
        self._ui.radioButton_Tab[self._enum.etabIndexSell]:SetShow(false)
        self._ui.radioButton_Tab[self._enum.etabIndexRepurchase]:SetShow(false)
      end
      if npcShop_isGuildShopContents() then
        self._ui.static_Silver:SetShow(false)
        self._ui.stc_guildSilver:SetShow(true)
      else
        self._ui.static_Silver:SetShow(true)
        self._ui.stc_guildSilver:SetShow(false)
      end
    elseif self._value.isCamping then
      self._value.enableSell = false
      self._ui.radioButton_Tab[self._enum.etabIndexSell]:SetShow(false)
      self._ui.radioButton_Tab[self._enum.etabIndexRepurchase]:SetShow(false)
    end
  end
end
function Panel_Dialog_NPCShop_Info:setKeyguide(snappedOnToggle)
  if true == snappedOnToggle then
    self._ui.staticText_BuyOrSell_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GENERIC_KEYGUIDE_XBOX_SELECT"))
    self._ui.staticText_BuyOrSell_ConsoleUI:SetMonoTone(false)
    self._ui.staticText_XForDetail_ConsoleUI:SetShow(false)
  elseif self._enum.etabIndexBuy == self._value.lastTabIndex then
    self._ui.staticText_BuyOrSell_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "NPCSHOP_BUY"))
  elseif self._enum.etabIndexSell == self._value.lastTabIndex then
    self._ui.staticText_BuyOrSell_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "NPCSHOP_SELL"))
  else
    self._ui.staticText_BuyOrSell_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "NPCSHOP_REPURCHASE"))
  end
  self._ui.staticText_SomeOrAll_ConsoleUI:SetShow(false)
  local keyGuideList = {
    self._ui.staticText_BuyOrSell_ConsoleUI,
    self._ui.staticText_XForDetail_ConsoleUI,
    self._ui.staticText_Move_ConsoleUI,
    self._ui.staticText_Cancel_ConsoleUI
  }
  if 1 > self._value.itemListSize or true == snappedOnToggle then
    self._ui.staticText_XForDetail_ConsoleUI:SetShow(false)
    keyGuideList[2] = self._ui.staticText_Move_ConsoleUI
    keyGuideList[3] = self._ui.staticText_Cancel_ConsoleUI
    keyGuideList[4] = nil
  else
    self._ui.staticText_XForDetail_ConsoleUI:SetShow(true)
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuideList, self._ui.static_Key_Guide_ConsoleUI, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Panel_Dialog_NPCShop_Info:clearTabButton()
  for key, value in pairs(self._ui.radioButton_Tab) do
    value:SetFontColor(UI_color.C_FF888888)
    value:SetMonoTone(true)
    value:SetCheck(false)
  end
end
function Panel_Dialog_NPCShop_Info:setPosTabButton()
  local tabCount = 0
  local tabButton = {}
  for index = 0, 2 do
    if self._ui.radioButton_Tab[index]:GetShow() then
      tabButton[index] = self._ui.radioButton_Tab[index]
      tabCount = tabCount + 1
    end
  end
  self._value.tabCount = tabCount
  self:updateTabLTRT()
  local BaseX = _panel:GetPosX()
  local sizeX = _panel:GetSizeX()
  local startPosX = sizeX / 2 - (tabCount * (self._space.tabButtonSizeX / 2) + (tabCount - 1) * (self._space.tabButtonSpaceX / 2))
  for index = 0, tabCount - 1 do
    tabButton[index]:SetPosX(startPosX + index * (self._space.tabButtonSizeX + self._space.tabButtonSpaceX))
  end
end
function Panel_Dialog_NPCShop_Info:updateTabLTRT()
  if self._value.tabCount < 2 then
    self._ui.static_LT:SetShow(false)
    self._ui.static_RT:SetShow(false)
  else
    self._ui.static_LT:SetShow(true)
    self._ui.static_RT:SetShow(true)
  end
end
function Panel_Dialog_NPCShop_Info:guildCheckByBuy()
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
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  local isSupplyOfficer = getSelfPlayer():get():isGuildSupplyOfficer()
  return true
end
function Panel_Dialog_NPCShop_Info:sellConfirm()
  return playerWrapper:get():requestSellItem(slotNo, itemCount, fromWhereType, toWhereType, self._value.isCamping)
end
function Panel_Dialog_NPCShop_Info:checkInit()
  if true == npcShop_isGuildShopContents() then
    return
  end
  if self._ui.chk_invenMoney:IsCheck() then
    return
  end
  if ToClient_HasWareHouseFromNpc() then
    if toInt64(0, 0) == warehouse_moneyFromNpcShop_s64() then
      self._ui.chk_invenMoney:SetCheck(true)
      self._ui.chk_warehouseMoney:SetCheck(false)
    else
      self._ui.chk_invenMoney:SetCheck(false)
      self._ui.chk_warehouseMoney:SetCheck(true)
    end
    self._ui.chk_warehouseMoney:SetShow(true)
    self._ui.staticText_Storage:SetShow(true)
  else
    self._ui.chk_warehouseMoney:SetShow(false)
    self._ui.staticText_Storage:SetShow(false)
    self._ui.chk_invenMoney:SetCheck(true)
    self._ui.chk_warehouseMoney:SetCheck(false)
  end
end
function Panel_Dialog_NPCShop_Info:updateGuildPriceLimit()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  self._ui.btn_guildFund:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_GUILDMONEY"))
  self._ui.txt_guildSilverValue:SetText(makeDotMoney(myGuildListInfo:getGuildBusinessFunds_s64()))
  self._ui.chk_invenMoney:SetCheck(false)
  self._ui.chk_warehouseMoney:SetCheck(false)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if false == selfPlayer:get():isGuildMaster() and true == selfPlayer:get():getGuildIsPriceLimit() then
    self._ui.txt_myAllowanceValue:SetText(makeDotMoney(selfPlayer:get():getGuildPriceLimit()))
  else
    self._ui.txt_myAllowanceValue:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_USEGUILDFUNDS_UNLIMITED"))
  end
end
function PaGlobalFunc_Dialog_NPCShop_Open()
  local self = Panel_Dialog_NPCShop_Info
end
function PaGlobalFunc_Dialog_NPCShop_Close()
  if Panel_ProductNote:GetShow() then
    Panel_ProductNote:SetShow(false, false)
    return
  end
  if _panel:GetShow() then
    _panel:SetShow(false, false)
    _AudioPostEvent_SystemUiForXBOX(1, 1)
    Inventory_SetFunctor(nil, nil, nil, nil)
    InventoryWindow_Close()
    PaGlobal_TutorialManager:handleNpcShopWindowClose()
    Panel_Tooltip_Item_hideTooltip()
    if PaGlobal_Camp:getIsCamping() then
      InventoryWindow_Close()
      PaGlobal_Camp:open()
    end
  end
end
function PaGlobalFunc_Dialog_NPCShop_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_Dialog_NPCShop_IsShow()
  return _panel:IsShow()
end
function PaGlobalFunc_Dialog_NPCShop_ExitButton()
  if PaGlobalFunc_Dialog_NPCShop_GetShow() then
    _panel:SetShow(false, false)
    _AudioPostEvent_SystemUiForXBOX(1, 1)
    InventoryWindow_Close()
    ReqeustDialog_retryTalk()
    PaGlobal_TutorialManager:handleNpcShopWindowClose()
    if PaGlobal_Camp:getIsCamping() then
      InventoryWindow_Close()
      PaGlobal_Camp:open()
    end
  end
end
function PaGlobalFunc_Dialog_NPCShop_GetNPCShop()
  local self = Panel_Dialog_NPCShop_Info
  return self
end
function PaGlobalFunc_Dialog_NPCShop_InvenFilter_IsExchangeItem(slotNo, itemWrapper)
  if nil == itemWrapper then
    return true
  end
  local isVested = itemWrapper:get():isVested()
  local isPersonalTrade = itemWrapper:getStaticStatus():isPersonalTrade()
  if isUsePcExchangeInLocalizingValue() then
    local isFilter = isVested and isPersonalTrade
    if isFilter then
      return isFilter
    end
  end
  local whereType = Inventory_GetCurrentInventoryType()
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  local isAble = npcShop_IsItemExchangeWithSystem(itemWrapper:get():getKey())
  return not isAble
end
function PaGlobalFunc_Dialog_NPCShop_InvenRClick(slotNo)
  local itemWrapper = getInventoryItem(slotNo)
  if nil ~= itemWrapper then
    itemCount = itemWrapper:get():getCount_s64()
    if Defines.s64_const.s64_1 == itemCount then
      PaGlobalFunc_Dialog_NPCShop_InvenRClick_SellItem(1, slotNo)
    else
      Panel_NumberPad_Show(true, itemCount, slotNo, PaGlobalFunc_Dialog_NPCShop_InvenRClick_SellItem)
    end
  end
end
function PaGlobalFunc_Dialog_NPCShop_InvenRClick_SellItem(itemCount, slotNo)
  local self = Panel_Dialog_NPCShop_Info
  local playerWrapper = getSelfPlayer()
  if nil == playerWrapper then
    return
  end
  local e100Percent = 1000000
  local itemWrapper = getInventoryItem(slotNo)
  local itemSSW = itemWrapper:getStaticStatus()
  local itemEndurance = itemWrapper:get():getEndurance()
  local sellPrice_64 = itemWrapper:getSellPriceCalculate(e100Percent)
  local sellPrice_32 = Int64toInt32(sellPrice_64)
  local itemCount_32 = Int64toInt32(itemCount)
  local sellPrice = sellPrice_32 * itemCount_32
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  local toWhereType = CppEnums.ItemWhereType.eInventory
  if npcShop_isGuildShopContents() then
    if not self:guildCheckByBuy() then
      return
    end
    toWhereType = CppEnums.ItemWhereType.eGuildWarehouse
  elseif self._ui.chk_warehouseMoney:IsCheck() or sellPrice >= 500000 and ToClient_HasWareHouseFromNpc() then
    toWhereType = CppEnums.ItemWhereType.eWarehouse
  else
    toWhereType = CppEnums.ItemWhereType.eInventory
  end
  local function sellDoit()
    warehouse_requestInfo(getCurrentWaypointKey())
    local isSocketed = false
    local function sellConfirm()
      playerWrapper:get():requestSellItem(slotNo, itemCount, fromWhereType, toWhereType, self._value.isCamping)
    end
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
      playerWrapper:get():requestSellItem(slotNo, itemCount, fromWhereType, toWhereType, self._value.isCamping)
    end
    if sellPrice >= 500000 and toWhereType ~= CppEnums.ItemWhereType.eGuildWarehouse and ToClient_HasWareHouseFromNpc() then
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
end
function PaGlobalFunc_Dialog_NPCShop_SellConfirm()
  local self = Panel_Dialog_NPCShop_Info
  self:sellConfirm()
end
function PaGlobalFunc_Dialog_NPCShop_TabButtonClick(tabIndex)
  local self = Panel_Dialog_NPCShop_Info
  Panel_Tooltip_Item_hideTooltip()
  self:clearTabButton()
  if tabIndex ~= self._value.lastTabIndex then
    PaGlobalFunc_Dialog_NPCShop_OnSlotClicked()
    self._value.lastTabIndex = tabIndex
    self._ui.radioButton_Tab[tabIndex]:SetFontColor(UI_color.C_FFFFFFFF)
    self._ui.radioButton_Tab[tabIndex]:SetMonoTone(false)
    if 2 == tabIndex then
      ToClient_NpcShop_UpdateRepurchaseList()
    else
      self._ui.frame_VerticalScroll:SetEnable(true)
      self._ui.frame_VerticalScroll:SetMonoTone(false)
      self._ui.frame_VerticalScroll:SetShow(true)
    end
    self._ui.frame_VerticalScroll:SetControlPos(0)
    self._value.lastStartSlotNo = 0
    self._value.startSlotIndex = 0
    self:updateContent(true)
  end
  self:setKeyguide()
  self:checkInit()
  ToClient_padSnapResetControl()
  PaGlobal_TutorialManager:handleNpcShopTabButtonClick(tabIndex)
end
function PaGlobalFunc_Dialog_NPCShop_OnSlotClickedWithTooltip(index)
  local self = Panel_Dialog_NPCShop_Info
  local slot
  if self._value.lastSelectedSlotIndex ~= index then
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  end
  self._value.lastSelectedSlotIndex = self._value.selectedSlotIndex
  self._value.selectedSlotIndex = index
  if nil ~= self._value.lastSelectedSlotIndex then
    self._value.enableTrade = false
    local slot = self._slots[self._value.lastSelectedSlotIndex]
    if nil ~= slot then
      slot:setSelect(false)
      slot.radioButton:addInputEvent("Mouse_LUp", "")
      self._ui.staticText_SomeOrAll_ConsoleUI:SetEnable(false)
      self._ui.staticText_SomeOrAll_ConsoleUI:SetMonoTone(true)
      self._ui.staticText_BuyOrSell_ConsoleUI:SetEnable(false)
      self._ui.staticText_BuyOrSell_ConsoleUI:SetMonoTone(true)
    end
  end
  if nil ~= index then
    self._value.enableTrade = true
    self._value.selectedSlotIndex = index
    local slot = self._slots[self._value.selectedSlotIndex]
    slot:setSelect(true)
    self._value.selectedSlotKeyValue = slot.keyValue
    self._ui.staticText_BuyOrSell_ConsoleUI:SetEnable(true)
    self._ui.staticText_BuyOrSell_ConsoleUI:SetMonoTone(false)
    if slot.isStackable == false then
      if true == _ContentsGroup_RenewUI_NpcShop then
        slot.radioButton:addInputEvent("Mouse_LUp", "")
      end
      self._ui.staticText_SomeOrAll_ConsoleUI:SetEnable(false)
      self._ui.staticText_SomeOrAll_ConsoleUI:SetMonoTone(true)
    else
      self._ui.staticText_SomeOrAll_ConsoleUI:SetEnable(true)
      self._ui.staticText_SomeOrAll_ConsoleUI:SetMonoTone(false)
      if self._enum.etabIndexBuy == self._value.lastTabIndex then
      elseif self._enum.etabIndexSell == self._value.lastTabIndex then
      else
        slot.radioButton:addInputEvent("Mouse_LUp", "")
      end
    end
    if true == self._slots[index].staticText_Name:IsLimitText() then
      slotNo = self._value.startSlotIndex + index
      local shopItemWrapper = self:getShopItemWrapperFromSlotNo(slotNo)
      if nil ~= shopItemWrapper then
        PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemSSWrapper, shopItemWrapper:getStaticStatus(), Defines.TooltipTargetType.ItemNameOnly, slot.radioButton)
      end
    end
  else
    PaGlobalFunc_FloatingTooltip_Close()
  end
end
function Input_Dialog_NPCShop_ShowTooltip(index, isShow)
  local self = Panel_Dialog_NPCShop_Info
  if isShow then
    slotNo = self._value.startSlotIndex + index
    local shopItemWrapper = self:getShopItemWrapperFromSlotNo(slotNo)
    if nil ~= shopItemWrapper then
      local itemSSW = shopItemWrapper:getStaticStatus()
      PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.Item, 0, getScreenSizeX())
      _AudioPostEvent_SystemUiForXBOX(50, 0)
    end
  else
    PaGlobalFunc_TooltipInfo_Close()
  end
end
function Panel_Dialog_NPCShop_Info:getShopItemWrapperFromSlotNo(slotNo)
  local shopItemWrapper
  if self._enum.etabIndexBuy == self._value.lastTabIndex then
    shopItemWrapper = npcShop_getItemBuy(slotNo)
  elseif self._enum.etabIndexSell == self._value.lastTabIndex then
    shopItemWrapper = npcShop_getItemSell(slotNo)
  else
    shopItemWrapper = npcShop_getItemRepurchase(self._value.itemListSize - slotNo - 1)
  end
  return shopItemWrapper
end
function Input_Dialog_NPCShop_PressedA()
end
function Input_Dialog_NPCShop_ReleasedA()
end
function InputMOn_Dialog_NPCShop_SnappedOnToggle(isOn)
  local self = Panel_Dialog_NPCShop_Info
  self:setKeyguide(isOn)
end
function Input_Dialog_NPCShop_ClickedOnToggle(isInven)
  local self = Panel_Dialog_NPCShop_Info
  self._ui.chk_invenMoney:SetCheck(true == isInven)
  self._ui.chk_warehouseMoney:SetCheck(false == isInven)
end
function PaGlobalFunc_Dialog_NPCShop_OnSlotClicked(slotIdx)
  local self = Panel_Dialog_NPCShop_Info
  local slot
  if self._value.lastSelectedSlotIndex ~= slotIdx then
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  end
  self._value.lastSelectedSlotIndex = self._value.selectedSlotIndex
  self._value.selectedSlotIndex = slotIdx
  if nil ~= self._value.lastSelectedSlotIndex then
    self._value.enableTrade = false
    local slot = self._slots[self._value.lastSelectedSlotIndex]
    if nil ~= slot then
      slot:setSelect(false)
      slot.radioButton:addInputEvent("Mouse_LUp", "")
      self._ui.staticText_SomeOrAll_ConsoleUI:SetEnable(false)
      self._ui.staticText_SomeOrAll_ConsoleUI:SetMonoTone(true)
      self._ui.staticText_BuyOrSell_ConsoleUI:SetEnable(false)
      self._ui.staticText_BuyOrSell_ConsoleUI:SetMonoTone(true)
    end
  end
  if nil ~= slotIdx then
    self._value.enableTrade = true
    self._value.selectedSlotIndex = slotIdx
    local slot = self._slots[self._value.selectedSlotIndex]
    slot:setSelect(true)
    self._value.selectedSlotKeyValue = slot.keyValue
    self._ui.staticText_BuyOrSell_ConsoleUI:SetEnable(true)
    self._ui.staticText_BuyOrSell_ConsoleUI:SetMonoTone(false)
    if slot.isStackable == false then
      if true == _ContentsGroup_RenewUI_NpcShop then
        slot.radioButton:addInputEvent("Mouse_LUp", "")
      end
      self._ui.staticText_SomeOrAll_ConsoleUI:SetEnable(false)
      self._ui.staticText_SomeOrAll_ConsoleUI:SetMonoTone(true)
    else
      self._ui.staticText_SomeOrAll_ConsoleUI:SetEnable(true)
      self._ui.staticText_SomeOrAll_ConsoleUI:SetMonoTone(false)
      if self._enum.etabIndexBuy == self._value.lastTabIndex then
      elseif self._enum.etabIndexSell == self._value.lastTabIndex then
      else
        slot.radioButton:addInputEvent("Mouse_LUp", "")
      end
    end
  else
  end
end
function PaGlobalFunc_Dialog_NPCShop_OnRSlotClicked(slotIdx)
  PaGlobalFunc_Dialog_NPCShop_OnSlotClicked(slotIdx)
  PaGlobalFunc_Dialog_NPCShop_BuyOrSellItem()
end
function PaGlobalFunc_Dialog_NPCShop_BuySomeOrSellAllItem(index)
  local self = Panel_Dialog_NPCShop_Info
  self._ui.stc_cirprogressBG:SetShow(false)
  if nil ~= index then
    self._value.selectedSlotIndex = index
  end
  warehouse_requestInfo(getCurrentWaypointKey())
  if nil ~= self._value.selectedSlotIndex then
    local slot = self._slots[self._value.selectedSlotIndex]
    if self._enum.etabIndexBuy == self._value.lastTabIndex then
      PaGlobalFunc_Dialog_NPCShop_BuySome()
    elseif self._enum.etabIndexSell == self._value.lastTabIndex then
      PaGlobalFunc_Dialog_NpcShop_SellItemAll()
    elseif self._enum.etabIndexRepurchase == self._value.lastTabIndex then
      PaGlobalFunc_Dialog_NPCShop_BuyOrSellItem()
    end
  else
  end
end
function PaGlobalFunc_Dialog_NPCShop_BuyOrSellItem()
  local self = Panel_Dialog_NPCShop_Info
  if nil ~= self._value.selectedSlotIndex then
    do
      local slot = self._slots[self._value.selectedSlotIndex]
      if self._enum.etabIndexBuy == self._value.lastTabIndex then
        local fromWhereType = 0
        local shopItemWrapper = npcShop_getItemBuy(slot.slotNo)
        local shopItemPrice = shopItemWrapper:get():getItemPriceWithOption()
        local myInvenMoney = getSelfPlayer():get():getInventory():getMoney_s64()
        local myWarehouseMoney = warehouse_moneyFromNpcShop_s64()
        local hasIntimacy = shopItemWrapper:getStaticStatus():hasMenatlCardKey()
        if hasIntimacy then
          return
        end
        if self._ui.chk_invenMoney:IsCheck() then
          fromWhereType = 2
        end
        if npcShop_isGuildShopContents() then
          fromWhereType = CppEnums.ItemWhereType.eGuildWarehouse
          if not self:guildCheckByBuy() then
            return
          end
          local selfPlayer = getSelfPlayer()
          if nil ~= selfPlayer and false == selfPlayer:get():isGuildMaster() then
            local isPriceLimit = selfPlayer:get():getGuildIsPriceLimit()
            local myGuildPriceLimit = selfPlayer:get():getGuildPriceLimit()
            if true == isPriceLimit and shopItemPrice > myGuildPriceLimit then
              Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_NPCSHOP_GUILDPRICELIMITED_NOMONEY"))
              return
            end
          end
        end
        local rv = 0
        rv = npcShop_doBuy(slot.slotNo, 1, fromWhereType, 0, self._value.isCamping)
        local shopItemKey = shopItemWrapper:getStaticStatus():get()._key:getItemKey()
        if shopItemKey >= 30000 and shopItemKey < 40000 and 0 == rv then
          local self = slot
          if Panel_Dialog_NPCShop_Info._ui.chk_invenMoney:IsCheck() and shopItemPrice < myInvenMoney then
            self.radioButton:SetIgnore(true)
            self.item_Slot:SetMonoTone(true)
            self.staticText_Name:SetMonoTone(true)
            self.staticText_Desc:SetMonoTone(true)
            self.staticText_Price:SetMonoTone(true)
            self.static_PriceIcon:SetMonoTone(true)
          elseif Panel_Dialog_NPCShop_Info._ui.chk_warehouseMoney:IsCheck() and shopItemPrice < myWarehouseMoney then
            self.radioButton:SetIgnore(true)
            self.item_Slot:SetMonoTone(true)
            self.staticText_Name:SetMonoTone(true)
            self.staticText_Desc:SetMonoTone(true)
            self.staticText_Price:SetMonoTone(true)
            self.static_PriceIcon:SetMonoTone(true)
          end
        end
      elseif self._enum.etabIndexSell == self._value.lastTabIndex then
        do
          local shopItemWrapper = npcShop_getItemSell(slot.slotNo)
          local shopItem = shopItemWrapper:get()
          local shopItemSSW = npcShop_getItemWrapperByShopSlotNo(slot.slotNo)
          local shopItemEndurance = shopItemSSW:get():getEndurance()
          local pricePiece = Int64toInt32(shopItemSSW:getSellPriceCalculate(shopItem:getItemPriceOption()))
          local inventory = getSelfPlayer():get():getInventory()
          local s64_inventoryItemCount = inventory:getItemCount_s64(shopItemWrapper:getStaticStatus():get()._key)
          local toWhereType = 0
          if self._ui.chk_warehouseMoney:IsCheck() then
            toWhereType = 2
          end
          if npcShop_isGuildShopContents() then
            if not self:guildCheckByBuy() then
              return
            end
            toWhereType = CppEnums.ItemWhereType.eGuildWarehouse
          elseif self._ui.chk_warehouseMoney:IsCheck() or pricePiece >= 500000 and ToClient_HasWareHouseFromNpc() then
            toWhereType = 2
          end
          local function sellDoit()
            local itemSSW = npcShop_getItemWrapperByShopSlotNo(slot.slotNo)
            local isSocketed = false
            warehouse_requestInfo(getCurrentWaypointKey())
            local function sellConfirm(count)
              npcShop_doSellByItemNo(slot.slotNo, count, toWhereType, self._value.isCamping)
            end
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
                functionYes = function()
                  Panel_NumberPad_Show(true, s64_inventoryItemCount, slot.slotNo, sellConfirm)
                end,
                functionNo = MessageBox_Empty_function,
                priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
              }
              MessageBox.showMessageBox(messageBoxData)
            else
              Panel_NumberPad_Show(true, s64_inventoryItemCount, slot.slotNo, sellConfirm)
            end
            if pricePiece >= 500000 and ToClient_HasWareHouseFromNpc() then
              Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_MONEYFORWAREHOUSE_ACK", "getMoney", makeDotMoney(pricePiece)), 6)
            end
          end
          if true == _ContentsGroup_RenewUI_ItemMarketPlace then
            local itemKeyForTradeInfo = shopItemWrapper:getStaticStatus():get()._key:get()
            local tradeMasterInfo = getItemMarketMasterByItemEnchantKey(itemKeyForTradeInfo)
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
          else
            sellDoit()
          end
        end
      else
        if self._enum.etabIndexRepurchase == self._value.lastTabIndex then
          local fromWhereType = 0
          if self._ui.chk_warehouseMoney:IsCheck() then
            fromWhereType = 2
          end
          if npcShop_isGuildShopContents() then
            fromWhereType = CppEnums.ItemWhereType.eGuildWarehouse
            if not self:guildCheckByBuy() then
              return
            end
          end
          if slot.slotNo == self._value.prevSlotNo then
            return
          end
          self._value.prevSlotNo = slot.slotNo
          npcShop_doRepurchase(slot.slotNo, fromWhereType, self._value.isCamping)
        else
        end
      end
    end
  end
  DragManager:clearInfo()
end
function PaGlobalFunc_Dialog_NPCShop_BuySome()
  local self = Panel_Dialog_NPCShop_Info
  local shopItemWrapper = npcShop_getItemBuy(self._value.startSlotIndex + self._value.selectedSlotIndex)
  local shopItem = shopItemWrapper:get()
  local itemEnchantStaticStatus = shopItemWrapper:getStaticStatus():get()
  local money_s64 = getSelfPlayer():get():getInventory():getMoney_s64()
  local s64_allWeight = Int64toInt32(getSelfPlayer():get():getCurrentWeight_s64())
  local s64_maxWeight = Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64())
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if self._ui.chk_warehouseMoney:IsCheck() then
    money_s64 = warehouse_moneyFromNpcShop_s64()
  end
  if npcShop_isGuildShopContents() then
    if not self:guildCheckByBuy() then
      return
    end
    money_s64 = myGuildListInfo:getGuildBusinessFunds_s64()
  end
  if money_s64 < shopItem:getItemPriceWithOption() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Money"))
    return
  end
  local s64_maxMoneyNumber = money_s64 / shopItem:getItemPriceWithOption()
  local s64_maxWeightNumber = Defines.s64_const.s64_0
  local itemWeight
  if self._ui.chk_invenMoney:IsCheck() then
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
  if true == self:checkBuyPossible() then
    if shopItemWrapper:getStaticStatus():get():isStackableXXX() then
      Panel_NumberPad_Show(true, s64_maxMoneyNumber, nil, PaGlobalFunc_Dialog_NpcShop_BuySome_ConfirmFunction, nil, nil, nil, nil, s64_maxWeightNumber)
      Panel_NumberPad_SetType("NpcShop_BuySome")
    else
      PaGlobalFunc_Dialog_NpcShop_BuySome_ConfirmFunction(Defines.s64_const.s64_1)
    end
  end
end
function Panel_Dialog_NPCShop_Info:checkBuyPossible()
  local buyPossible = false
  local moneyItemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, getMoneySlotNo())
  local myInvenMoney_s64 = toInt64(0, 0)
  if nil ~= moneyItemWrapper then
    myInvenMoney_s64 = moneyItemWrapper:get():getCount_s64()
  end
  local myWareHouseMoney_s64 = warehouse_moneyFromNpcShop_s64()
  local itemPrice_s64, shopItemWrapper
  local slot = self._slots[self._value.selectedSlotIndex]
  if nil == slot then
    return
  end
  if self._enum.etabIndexBuy == self._value.lastTabIndex then
    shopItemWrapper = npcShop_getItemBuy(slot.slotNo)
  elseif self._enum.etabIndexSell == self._value.lastTabIndex then
    shopItemWrapper = npcShop_getItemSell(slot.slotNo)
  else
    slot.slotNo = self._value.itemListSize - slot.slotNo - 1
    shopItemWrapper = npcShop_getItemRepurchase(slot.slotNo)
  end
  if nil == shopItemWrapper then
    return
  end
  local shopItem = shopItemWrapper:get()
  if self._enum.etabIndexSell == self._value.lastTabIndex then
    itemPrice_s64 = shopItem:getItemSellPriceWithOption()
  elseif self._enum.etabIndexBuy == self._value.lastTabIndex then
    itemPrice_s64 = shopItem:getItemPriceWithOption()
  elseif self._enum.etabIndexRepurchase == self._value.lastTabIndex then
    itemPrice_s64 = shopItem.price_s64
  end
  if npcShop_isGuildShopContents() then
    local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
    if nil ~= myGuildListInfo then
      if self._enum.etabIndexBuy == self._value.lastTabIndex and itemPrice_s64 > myGuildListInfo:getGuildBusinessFunds_s64() then
        buyPossible = false
      else
        buyPossible = true
      end
    else
      buyPossible = false
      slot.staticText_Price:SetFontColor(UI_color.C_FFBA2737)
    end
  elseif self._enum.etabIndexBuy == self._value.lastTabIndex and myInvenMoney_s64 < itemPrice_s64 and myWareHouseMoney_s64 < itemPrice_s64 then
    buyPossible = false
  else
    buyPossible = true
  end
  return buyPossible
end
function PaGlobalFunc_Dialog_NpcShop_BuySome_ConfirmFunction(inputNumber, param)
  local self = Panel_Dialog_NPCShop_Info
  self._value.inputNumber = inputNumber
  local slot = self._slots[self._value.selectedSlotIndex]
  local buyCount = self._value.inputNumber
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  if self._ui.chk_warehouseMoney:IsCheck() then
    fromWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  local shopItemWrapper = npcShop_getItemBuy(slot.slotNo)
  local shopItem = shopItemWrapper:get()
  local selectItem = shopItemWrapper:getStaticStatus():getName()
  local totalPrice = shopItem:getItemPriceWithOption() * inputNumber
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_BUY_ALERT_TITLE")
  local contentString = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_NPCSHOP_BUY_ALERT_1", "item", tostring(selectItem), "number", tostring(self._value.inputNumber), "price", makeDotMoney(totalPrice))
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = PaGlobalFunc_Dialog_NpcShop_BuySome_Do,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  if npcShop_isGuildShopContents() then
    fromWhereType = CppEnums.ItemWhereType.eGuildWarehouse
    if not self:guildCheckByBuy() then
      return
    end
    local selfPlayer = getSelfPlayer()
    if nil ~= selfPlayer and false == selfPlayer:get():isGuildMaster() then
      local isPriceLimit = selfPlayer:get():getGuildIsPriceLimit()
      local myGuildPriceLimit = selfPlayer:get():getGuildPriceLimit()
      if true == isPriceLimit and totalPrice > myGuildPriceLimit then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_NPCSHOP_GUILDPRICELIMITED_NOMONEY"))
        return
      end
    end
  end
  if toInt64(0, 499) < self._value.inputNumber or totalPrice > toInt64(0, 99999) then
    MessageBox.showMessageBox(messageboxData)
  else
    npcShop_doBuy(slot.slotNo, buyCount, fromWhereType, 0, self._value.isCamping)
  end
end
function PaGlobalFunc_Dialog_NpcShop_BuySome_Do()
  local self = Panel_Dialog_NPCShop_Info
  local buyCount = self._value.inputNumber
  local slot = self._slots[self._value.selectedSlotIndex]
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  if self._ui.chk_warehouseMoney:IsCheck() then
    fromWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  if npcShop_isGuildShopContents() then
    fromWhereType = CppEnums.ItemWhereType.eGuildWarehouse
    if not self:guildCheckByBuy() then
      return
    end
  end
  npcShop_doBuy(slot.slotNo, buyCount, fromWhereType, 0, self._value.isCamping)
end
function PaGlobalFunc_Dialog_NpcShop_SellItemAll()
  local self = Panel_Dialog_NPCShop_Info
  if nil ~= self._value.selectedSlotIndex then
    do
      local slot = self._slots[self._value.selectedSlotIndex]
      local shopItemWrapper = npcShop_getItemSell(slot.slotNo)
      local shopItem = shopItemWrapper:get()
      local inventory = getSelfPlayer():get():getInventory()
      local s64_inventoryItemCount = inventory:getItemCount_s64(shopItemWrapper:getStaticStatus():get()._key)
      local shopItemSSW = npcShop_getItemWrapperByShopSlotNo(slot.slotNo)
      local itemCount = Int64toInt32(s64_inventoryItemCount)
      local pricePiece = Int64toInt32(shopItemSSW:getSellPriceCalculate(shopItem:getItemPriceOption()))
      local toWhereType = 0
      local sellPrice = pricePiece * itemCount
      local function sellAllDoit()
        if npcShop_isGuildShopContents() then
          toWhereType = CppEnums.ItemWhereType.eGuildWarehouse
        elseif self._ui.chk_warehouseMoney:IsCheck() or sellPrice >= 500000 and ToClient_HasWareHouseFromNpc() then
          toWhereType = 2
        end
        local itemSSW = npcShop_getItemWrapperByShopSlotNo(slot.slotNo)
        local shopItemEndurance = itemSSW:get():getEndurance()
        local isSocketed = false
        local function sellConfirm(count, slotNo)
          if slotNo == self._value.prevSlotNo then
            return
          end
          self._value.prevSlotNo = slotNo
          warehouse_requestInfo(getCurrentWaypointKey())
          npcShop_doSellByItemNo(slotNo, count, toWhereType, self._value.isCamping)
          if sellPrice >= 500000 and ToClient_HasWareHouseFromNpc() then
            Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_MONEYFORWAREHOUSE_ACK", "getMoney", makeDotMoney(toInt64(0, pricePiece) * count)), 6)
          end
        end
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
            functionYes = function()
              Panel_NumberPad_Show(true, s64_inventoryItemCount, slot.slotNo, sellConfirm)
            end,
            functionNo = MessageBox_Empty_function,
            priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
          }
          MessageBox.showMessageBox(messageBoxData)
        else
          Panel_NumberPad_Show(true, s64_inventoryItemCount, slot.slotNo, sellConfirm)
        end
      end
      local itemKeyForTradeInfo = shopItemWrapper:getStaticStatus():get()._key:get()
      local tradeMasterInfo = getItemMarketMasterByItemEnchantKey(itemKeyForTradeInfo)
      if nil ~= tradeMasterInfo and 0 ~= shopItemEndurance then
        if sellPrice >= 500000 and toWhereType ~= CppEnums.ItemWhereType.eGuildWarehouse and not ToClient_HasWareHouseFromNpc() then
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
      elseif sellPrice >= 500000 and toWhereType ~= CppEnums.ItemWhereType.eGuildWarehouse and not ToClient_HasWareHouseFromNpc() then
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
    end
  end
  DragManager:clearInfo()
end
function PaGlobalFunc_Dialog_NPCShop_ScrollEvent(isUpScroll)
  local self = Panel_Dialog_NPCShop_Info
  local beforeSlotIndex = self._value.startSlotIndex
  self._value.startSlotIndex = UIScroll.ScrollEvent(self._ui.frame_VerticalScroll, isUpScroll, self._config.slotRows, self._value.itemListSize, self._value.startSlotIndex, self._config.slotCols)
  if self._value.startSlotIndex < self._config.slotCols then
    self._value.startSlotIndex = self._value.startSlotIndex * self._config.slotCols
  end
  if (ToClient_isConsole() or ToClient_IsDevelopment()) and beforeSlotIndex ~= self._value.startSlotIndex then
    ToClient_padSnapIgnoreGroupMove()
  end
  Panel_Tooltip_Item_hideTooltip()
  PaGlobalFunc_FloatingTooltip_Close()
  self:updateContent(false)
end
function PaGlobalFunc_Dialog_NPCShop_ShowAni()
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  _panel:SetAlpha(0)
  UIAni.AlphaAnimation(1, _panel, 0, 0.3)
end
function PaGlobalFunc_Dialog_NPCShop_HideAni()
  local ani1 = UIAni.AlphaAnimation(0, _panel, 0, 0.2)
  ani1:SetHideAtEnd(true)
end
function PaGlobalFunc_Dialog_NPCShop_IsExchangeItem(slotNo, itemWrapper)
  if nil == itemWrapper then
    return true
  end
  local isVested = itemWrapper:get():isVested()
  local isPersonalTrade = itemWrapper:getStaticStatus():isPersonalTrade()
  if isUsePcExchangeInLocalizingValue() then
    local isFilter = isVested and isPersonalTrade
    if isFilter then
      return isFilter
    end
  end
  local whereType = Inventory_GetCurrentInventoryType()
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  local isAble = npcShop_IsItemExchangeWithSystem(itemWrapper:get():getKey())
  return not isAble
end
function FromClient_Init_Dialog_NPCShop()
  local self = Panel_Dialog_NPCShop_Info
  self:initialize()
  self:resize()
end
function FromClient_onScreenResize_Dialog_NPCShop()
  local self = Panel_Dialog_NPCShop_Info
  self:resize()
end
function FromClient_Dialog_NPCShop_UpdateContent()
  local self = Panel_Dialog_NPCShop_Info
  local talker = dialog_getTalker()
  self._value.isCamping = PaGlobal_Camp:getIsCamping()
  if nil == talker and (false == self._value.isCamping or nil == self._value.isCamping) then
    return
  end
  if false == self._value.isCamping or nil == self._value.isCamping then
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
  self:preShow()
  self._ui.frame_VerticalScroll:SetControlPos(0)
  Inventory_SetFunctor(PaGlobalFunc_Dialog_NPCShop_IsExchangeItem, PaGlobalFunc_Dialog_NPCShop_InvenRClick, PaGlobalFunc_Dialog_NPCShop_Close, nil)
  self:updateContent(true)
  FromClient_Dialog_NPCShop_UpdateMoney()
  FromClient_Dialog_NPCShop_UpdateMoneyWarehouse()
  FromClient_Dialog_NPCShop_UpdateGuildPriceLimit()
end
function FromClient_Dialog_NPCShop_UpdateMoney()
  if true == _ContentsGroup_InvenUpdateCheck and false == PaGlobalFunc_Dialog_NPCShop_GetShow() then
    return
  end
  local self = Panel_Dialog_NPCShop_Info
  self._ui.radioButton_Buy:SetEnable(true)
  self._ui.radioButton_Buy:SetMonoTone(false)
  if not npcShop_isGuildShopContents() then
    self._ui.staticText_Inventory:SetShow(true)
    self._ui.staticText_Inventory:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
    self._ui.button_Inventory:SetShow(true)
    self._ui.button_Inventory:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKET_ICON_MONEY"))
    self._ui.button_Inventory:SetIgnore(false)
    self._ui.button_Inventory:SetEnable(true)
    if not ToClient_HasWareHouseFromNpc() then
      self._ui.button_Storage:SetShow(false)
      self._ui.staticText_Storage:SetShow(false)
    else
      self._ui.button_Storage:SetShow(true)
      self._ui.staticText_Storage:SetShow(true)
    end
  else
    self:updateGuildPriceLimit()
  end
end
function FromClient_Dialog_NPCShop_UpdateMoneyWarehouse()
  local self = Panel_Dialog_NPCShop_Info
  if not npcShop_isGuildShopContents() then
    self._ui.staticText_Storage:SetShow(true)
    self._ui.staticText_Storage:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
    self._ui.button_Storage:SetShow(true)
    self._ui.button_Storage:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKET_ICON_MONEY2"))
    self._ui.button_Storage:SetIgnore(false)
    self._ui.button_Storage:SetEnable(true)
    if not ToClient_HasWareHouseFromNpc() then
      self._ui.button_Storage:SetShow(false)
      self._ui.staticText_Storage:SetShow(false)
    else
      self._ui.button_Storage:SetShow(true)
      self._ui.staticText_Storage:SetShow(true)
      self._ui.button_Storage:SetIgnore(false)
      self._ui.button_Storage:SetEnable(true)
    end
  end
end
function FromClient_Dialog_NPCShop_UpdateGuildPriceLimit()
  local self = Panel_Dialog_NPCShop_Info
  self:updateGuildPriceLimit()
end
function FromClient_Dialog_NPCShop_UpdatePerFrame(deltaTime)
  local self = Panel_Dialog_NPCShop_Info
  if true == _buttonAIsPressed then
    _elapsedTime = _elapsedTime + deltaTime
    self._ui.cirprogress_buttonHold:SetProgressRate(_elapsedTime / _buttonHoldThreshold * 100)
    if _buttonHoldThreshold < _elapsedTime then
      _elapsedTime = 0
      _buttonAIsPressed = false
      self._ui.cirprogress_buttonHold:SetProgressRate(0)
      PaGlobalFunc_Dialog_NPCShop_BuySomeOrSellAllItem()
    end
  end
end
function Toggle_NPCShopTab_forPadEventFunc(value)
  _AudioPostEvent_SystemUiForXBOX(51, 7)
  local self = Panel_Dialog_NPCShop_Info
  if self._value.tabCount == 1 then
    return
  end
  self._currentTabIndex = self._currentTabIndex + value
  if self._currentTabIndex < 0 then
    self._currentTabIndex = 2
  elseif self._currentTabIndex > 2 then
    self._currentTabIndex = 0
  end
  PaGlobalFunc_Dialog_NPCShop_TabButtonClick(self._currentTabIndex)
end
function FromClient_Dialog_NPCShop_PadSnapChangeTarget(fromControl, toControl)
  if false == _panel:GetShow() then
    return
  end
  if nil ~= toControl then
    local snappedOnToggle = "Button_Storage" == toControl:GetID() or "Button_Inventory" == toControl:GetID()
    Panel_Dialog_NPCShop_Info:setKeyguide(snappedOnToggle)
  end
end
function FromClient_Dialog_NPCShop_PadSnapChangePanel(fromPanel, toPanel)
  if nil ~= toPanel and _panel:GetKey() == toPanel:GetKey() then
    local self = Panel_Dialog_NPCShop_Info
    self:updateTabLTRT()
  end
end
_panel:registerPadEvent(__eConsoleUIPadEvent_LT, "Toggle_NPCShopTab_forPadEventFunc(-1)")
_panel:registerPadEvent(__eConsoleUIPadEvent_RT, "Toggle_NPCShopTab_forPadEventFunc(1)")
registerEvent("FromClient_luaLoadComplete", "FromClient_Init_Dialog_NPCShop")

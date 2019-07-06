Panel_Window_NpcShop:SetShow(false, false)
Panel_Window_NpcShop:ActiveMouseEventEffect(true)
Panel_Window_NpcShop:setGlassBackground(true)
local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
npcShop = {
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = false,
    createCash = true,
    createEnchant = true,
    createEnduranceIcon = true
  },
  config = {
    slotCount = 14,
    slotCols = 2,
    slotRows = 0,
    slotStartX = 25,
    slotStartY = 117,
    slotGapX = 10,
    slotGapY = 5,
    pricePosX = 265,
    pricePosY = 30,
    remainCountPosX = 40,
    remainCountPosY = 30,
    trendPosX = 285,
    trendPosY = 20,
    iconPosX = 4,
    iconPosY = 4,
    invenCountX = 260,
    invenCountY = 10,
    rentTimePosX = 248,
    rentTimePosY = 10
  },
  commandText = {
    [0] = PAGetString(Defines.StringSheet_GAME, "NPCSHOP_BUY"),
    PAGetString(Defines.StringSheet_GAME, "NPCSHOP_SELL"),
    PAGetString(Defines.StringSheet_GAME, "NPCSHOP_REPURCHASE")
  },
  template = {
    panel = UI.getChildControl(Panel_Window_NpcShop, "blackpanel"),
    button = UI.getChildControl(Panel_Window_NpcShop, "Button_List"),
    buttonSelected = UI.getChildControl(Panel_Window_NpcShop, "Button_List_Effect"),
    staticCurrentPrice = UI.getChildControl(Panel_Window_NpcShop, "StaticText_CurrentPrice"),
    static_CoinIcon = UI.getChildControl(Panel_Window_NpcShop, "Static_CoinIcon"),
    staticRemainCount = UI.getChildControl(Panel_Window_NpcShop, "StaticText_RemainCount"),
    staticTrend = UI.getChildControl(Panel_Window_NpcShop, "StaticText_Trend"),
    staticInvenCount = UI.getChildControl(Panel_Window_NpcShop, "StaticText_InventoryCount"),
    inputCart = UI.getChildControl(Panel_Window_NpcShop, "Button_InputCart"),
    staticRentTime = UI.getChildControl(Panel_Window_NpcShop, "StaticText_RentTime")
  },
  tabIndexBuy = 0,
  tabIndexSell = 1,
  tabIndexRepurchase = 2,
  lastTabIndex = nil,
  selectedSlotIndex = nil,
  lastSelectedSlotIndex = nil,
  selectedSlotKeyValue = nil,
  lastScrollValue = 0,
  lastStartSlotNo = 0,
  _itemListSize = 0,
  _startSlotIndex = 0,
  _inputNumber = 0,
  slots = {},
  radioButtons = {
    [0] = UI.getChildControl(Panel_Window_NpcShop, "RadioButton_Tab_Buy"),
    UI.getChildControl(Panel_Window_NpcShop, "RadioButton_Tab_Sell"),
    UI.getChildControl(Panel_Window_NpcShop, "RadioButton_Tab_Repurchase")
  },
  windowTitle = UI.getChildControl(Panel_Window_NpcShop, "Static_Text_Title"),
  buttonClose = UI.getChildControl(Panel_Window_NpcShop, "Button_Win_Close"),
  buttonQuestion = UI.getChildControl(Panel_Window_NpcShop, "Button_Question"),
  buttonBuy = UI.getChildControl(Panel_Window_NpcShop, "Button_Command"),
  buttonBuySome = UI.getChildControl(Panel_Window_NpcShop, "Button_BuySome"),
  buttonSellAll = UI.getChildControl(Panel_Window_NpcShop, "Button_SellAll"),
  scroll = UI.getChildControl(Panel_Window_NpcShop, "Scroll_Slot_List"),
  staticMoney = UI.getChildControl(Panel_Window_NpcShop, "Static_Text_Money"),
  staticWarehouseMoney = UI.getChildControl(Panel_Window_NpcShop, "Static_Text_Money2"),
  myGuildPriceLimitValue = UI.getChildControl(Panel_Window_NpcShop, "Static_Text_Money3"),
  myGuildMoneyValue = UI.getChildControl(Panel_Window_NpcShop, "StaticText_GuildMoney"),
  checkButton_Inventory = UI.getChildControl(Panel_Window_NpcShop, "RadioButton_Money"),
  checkButton_Warehouse = UI.getChildControl(Panel_Window_NpcShop, "RadioButton_Money2"),
  _isCamping = false
}
local orgButtonBuySome = UI.getChildControl(Panel_Window_NpcShop, "Button_BuySome")
local floor = math.floor
local _npcShopHelp_BG = UI.getChildControl(Panel_Window_NpcShop, "Static_NpcShopDesc_BG")
local _npcShopHelp = UI.getChildControl(Panel_Window_NpcShop, "StaticText_NpcShopDesc")
local inventxt = UI.getChildControl(Panel_Window_NpcShop, "StaticText_Inven")
local warehousetxt = UI.getChildControl(Panel_Window_NpcShop, "StaticText_Warehouse")
local npcShop_BuyBtn_PosX = npcShop.radioButtons[npcShop.tabIndexBuy]:GetPosX()
local npcShop_SellBtn_PosX = npcShop.radioButtons[npcShop.tabIndexSell]:GetPosX()
Panel_Window_NpcShop.npcShop = npcShop
function FGlobal_NpcShop_GetNpcShop()
  return npcShop
end
function npcShop:init()
  self.config.slotRows = self.config.slotCount / self.config.slotCols
  self.lastTabIndex = self.tabIndexBuy
  self.radioButtons[0]:SetTextMode(UI_TM.eTextMode_LimitText)
  self.radioButtons[1]:SetTextMode(UI_TM.eTextMode_LimitText)
  self.radioButtons[2]:SetTextMode(UI_TM.eTextMode_LimitText)
  self.radioButtons[0]:SetText(PAGetString(Defines.StringSheet_RESOURCE, "SHOP_BTN_TAPBUY"))
  self.radioButtons[1]:SetText(PAGetString(Defines.StringSheet_RESOURCE, "SHOP_BTN_TAPSELL"))
  self.radioButtons[2]:SetText(PAGetString(Defines.StringSheet_RESOURCE, "SHOP_BTN_TAPREBUY"))
  local isBuyLimit = self.radioButtons[0]:IsLimitText()
  local isSellLimit = self.radioButtons[1]:IsLimitText()
  local isRepurchase = self.radioButtons[2]:IsLimitText()
  if isBuyLimit then
    self.radioButtons[0]:addInputEvent("Mouse_On", "PaGlobal_NpcShop:Simpletooltips(true, 0)")
    self.radioButtons[0]:addInputEvent("Mouse_Out", "PaGlobal_NpcShop:Simpletooltips(false)")
  end
  if isSellLimit then
    self.radioButtons[1]:addInputEvent("Mouse_On", "PaGlobal_NpcShop:Simpletooltips(true, 1)")
    self.radioButtons[1]:addInputEvent("Mouse_Out", "PaGlobal_NpcShop:Simpletooltips(false)")
  end
  if isRepurchase then
    self.radioButtons[2]:addInputEvent("Mouse_On", "PaGlobal_NpcShop:Simpletooltips(true, 2)")
    self.radioButtons[2]:addInputEvent("Mouse_Out", "PaGlobal_NpcShop:Simpletooltips(false)")
  end
  local btnBuySizeX = self.radioButtons[0]:GetSizeX() + 15
  local btnBuyTextPosX = btnBuySizeX - btnBuySizeX / 2 - self.radioButtons[0]:GetTextSizeX() / 2
  self.radioButtons[0]:SetTextSpan(btnBuyTextPosX, 7)
  local btnSellSizeX = self.radioButtons[1]:GetSizeX() + 15
  local btnSellTextPosX = btnSellSizeX - btnSellSizeX / 2 - self.radioButtons[1]:GetTextSizeX() / 2
  self.radioButtons[1]:SetTextSpan(btnSellTextPosX, 7)
  local btnRepurchaseSizeX = self.radioButtons[2]:GetSizeX() + 15
  local btnRepurchaseTextPosX = btnRepurchaseSizeX - btnRepurchaseSizeX / 2 - self.radioButtons[2]:GetTextSizeX() / 2
  self.radioButtons[2]:SetTextSpan(btnRepurchaseTextPosX, 7)
  _npcShopHelp:SetTextMode(UI_TM.eTextMode_AutoWrap)
end
local _const = Defines.s64_const
function npcShop:createSlot()
  local index = 1
  for ii = 1, self.config.slotRows do
    for jj = 1, self.config.slotCols do
      index = (ii - 1) * self.config.slotCols + jj
      local strId = "" .. ii .. "_" .. jj
      local slot = {
        selected = false,
        slotNo = 0,
        keyValue = -1,
        showInvenCount = false,
        isStackable = false
      }
      slot.slotNo = index - 1
      slot.button = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_Window_NpcShop, "NpcShop_Button_" .. strId)
      CopyBaseProperty(self.template.button, slot.button)
      slot.button:addInputEvent("Mouse_LUp", "NpcShop_OnSlotClicked(" .. index .. ")")
      slot.button:addInputEvent("Mouse_RUp", "NpcShop_OnRSlotClicked(" .. index .. ")")
      slot.button:addInputEvent("Mouse_UpScroll", "NpcShop_ScrollEvent( true )")
      slot.button:addInputEvent("Mouse_DownScroll", "NpcShop_ScrollEvent( false )")
      npcShop.template.panel:addInputEvent("Mouse_UpScroll", "NpcShop_ScrollEvent( true )")
      npcShop.template.panel:addInputEvent("Mouse_DownScroll", "NpcShop_ScrollEvent( false )")
      slot.price = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_NpcShop, "StaticText_Price_" .. strId)
      CopyBaseProperty(self.template.staticCurrentPrice, slot.price)
      slot.coinIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_NpcShop, "Static_CoinIcon_" .. strId)
      CopyBaseProperty(self.template.static_CoinIcon, slot.coinIcon)
      slot.remainCount = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_NpcShop, "StaticText_RemainCount_" .. strId)
      CopyBaseProperty(self.template.staticRemainCount, slot.remainCount)
      slot.trend = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_NpcShop, "StaticText_Trend_" .. strId)
      CopyBaseProperty(self.template.staticTrend, slot.trend)
      slot.icon = {}
      SlotItem.new(slot.icon, "ShopItem_" .. index, index, Panel_Window_NpcShop, self.slotConfig)
      slot.icon:createChild()
      slot.selectEffect = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_NpcShop, "Button_Effect_" .. strId)
      CopyBaseProperty(self.template.buttonSelected, slot.selectEffect)
      slot.invenCount = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_NpcShop, "StaticText_InventoryCount" .. strId)
      CopyBaseProperty(self.template.staticInvenCount, slot.invenCount)
      slot.rentTime = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_NpcShop, "StaticText_RentTime_" .. strId)
      CopyBaseProperty(self.template.staticRentTime, slot.rentTime)
      function slot:setPos(posX, posY, param)
        self.button:SetPosX(posX)
        self.button:SetPosY(posY)
        if isGameTypeTH() or isGameTypeID() then
          param.pricePosX = 308
        else
          param.pricePosX = 308
        end
        self.price:SetPosX(posX + param.pricePosX)
        self.price:SetPosY(posY + param.pricePosY)
        self.coinIcon:SetPosY(posY + param.pricePosY)
        self.remainCount:SetPosX(posX + param.remainCountPosX + 20)
        self.remainCount:SetPosY(posY + param.remainCountPosY)
        self.trend:SetPosX(posX + param.trendPosX)
        self.trend:SetPosY(posY + param.trendPosY)
        self.icon.icon:SetPosX(posX + param.iconPosX)
        self.icon.icon:SetPosY(posY + param.iconPosY)
        self.selectEffect:SetPosX(posX)
        self.selectEffect:SetPosY(posY)
        self.invenCount:SetPosX(posX + param.invenCountX)
        self.invenCount:SetPosY(posY + param.invenCountY)
        self.rentTime:SetPosX(posX + param.rentTimePosX)
        self.rentTime:SetPosY(posY + param.rentTimePosY)
      end
      function slot:setItem(itemStaticWrapper, s64_stackCount, s64_price, s64_invenCount, rentTime, Intimacy, disable)
        if nil == itemStaticWrapper then
          UI.ASSERT_NAME(false, "itemStaticWrapper \234\176\128 nil \236\158\133\235\139\136\235\139\164.", "\234\185\128\236\157\152\236\167\132")
          return
        end
        local talker
        local characterKey = 0
        local count = 0
        local intimacyValue = 0
        if false == npcShop._isCamping or nil == npcShop._isCamping then
          talker = dialog_getTalker()
          characterKey = talker:getCharacterKey()
          count = getIntimacyInformationCount(characterKey)
          intimacyValue = talker:getIntimacy()
        end
        local enable = _const.s64_0 ~= s64_stackCount and not disable
        local hasIntimacy = itemStaticWrapper:hasMenatlCardKey()
        self.button:SetTextMode(UI_TM.eTextMode_Limit_AutoWrap)
        self.button:SetText(itemStaticWrapper:getName())
        if enable then
          self.button:SetFontColor(UI_color.C_FFFFFFFF)
        else
          self.button:SetFontColor(UI_color.C_FFAAAAAA)
        end
        self.icon:setItemByStaticStatus(itemStaticWrapper)
        self.icon.icon:SetMonoTone(not enable)
        self.price:SetText(makeDotMoney(s64_price))
        self.coinIcon:SetPosX(self.price:GetPosX() - (self.price:GetTextSizeX() - self.price:GetSizeX() + self.coinIcon:GetSizeX() + 10))
        local strCount = string.format("%d", Int64toInt32(s64_stackCount))
        self.remainCount:SetFontColor(UI_color.C_FF3BD3FF)
        self.remainCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "NPCSHOP_REMAIN_COUNT", "count", strCount))
        if s64_stackCount < _const.s64_0 then
          local itemType = itemStaticWrapper:getItemType()
          if 17 == itemType and npcShop.tabIndexSell == npcShop.lastTabIndex then
            self.remainCount:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NPCSHOP_USELESSITEM"))
          elseif npcShop.tabIndexSell ~= npcShop.lastTabIndex then
            self.remainCount:SetText(PAGetString(Defines.StringSheet_GAME, "NPCSHOP_SOLDOUT"))
          else
            self.remainCount:SetText("")
          end
          self.icon.icon:SetMonoTone(false)
          self.trend:SetMonoTone(false)
          self.price:SetMonoTone(false)
          self.coinIcon:SetMonoTone(false)
          self.remainCount:SetMonoTone(false)
        end
        if nil ~= rentTime and rentTime > 0 then
          self.rentTime:SetShow(true)
          self.rentTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEM_ABLE_RENTTIME", "itemRentTime", rentTime))
        else
          self.rentTime:SetText("")
          self.rentTime:SetShow(false)
        end
        if nil ~= Intimacy and Intimacy > 0 and (false == npcShop._isCamping or nil == npcShop._isCamping) then
          self.remainCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "NPCSHOP_NEED_INTIMACY", "intimacy", Intimacy))
          if Intimacy > intimacyValue then
            self.icon.icon:SetMonoTone(true)
            self.trend:SetMonoTone(true)
            self.price:SetMonoTone(true)
            self.coinIcon:SetMonoTone(true)
            self.remainCount:SetMonoTone(true)
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
            self.remainCount:SetFontColor(UI_color.C_FFF26A6A)
            self.remainCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_EQUIP_IMPOSSIBLE"))
          else
            self.remainCount:SetFontColor(UI_color.C_FF3BD3FF)
            self.remainCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_EQUIP_POSSIBLE"))
          end
        end
        local itemStatic = itemStaticWrapper:get()
        self.isStackable = itemStatic:isStackableXXX()
        if nil ~= s64_invenCount then
          if self.isStackable == true then
            local strCount = string.format("%d", Int64toInt32(s64_invenCount))
            self.invenCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "NPCSHOP_HAVE_COUNT", "count", strCount))
            self.invenCount:SetShow(true)
            self.showInvenCount = true
          else
            self.invenCount:SetShow(false)
            self.showInvenCount = false
          end
        else
          self.invenCount:SetShow(false)
          self.showInvenCount = false
        end
        if hasIntimacy then
          self.button:SetIgnore(true)
          self.icon.icon:SetMonoTone(true)
          self.trend:SetMonoTone(true)
          self.price:SetMonoTone(true)
          self.coinIcon:SetMonoTone(true)
          self.remainCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_ALREADYHASINTIMACY"))
        else
          self.button:SetIgnore(false)
          self.icon.icon:SetMonoTone(false)
          self.trend:SetMonoTone(false)
          self.price:SetMonoTone(false)
          self.coinIcon:SetMonoTone(false)
        end
        self.keyValue = itemStatic._key:get()
        self:setShow(true)
      end
      function slot:setShow(bShow)
        bShow = bShow or false
        self.button:SetShow(bShow)
        self.price:SetShow(bShow)
        self.coinIcon:SetShow(bShow)
        self.remainCount:SetShow(bShow)
        self.trend:SetShow(false)
        self.icon.icon:SetShow(bShow)
        self.selectEffect:SetShow(bShow and self.selected)
        self.invenCount:SetShow(bShow and self.showInvenCount)
        self.rentTime:SetShow(bShow)
      end
      function slot:setSelect(bSelect)
        self.selectEffect:SetShow(bSelect)
        self.selected = bSelect
      end
      function slot:clearItem()
        self:setSelect(false)
        self:setShow(false)
        self.keyValue = -1
      end
      local posX = self.config.slotStartX + (slot.button:GetSizeX() + self.config.slotGapX) * (jj - 1)
      local posY = self.config.slotStartY + (slot.button:GetSizeY() + self.config.slotGapY) * (ii - 1)
      slot:setPos(posX, posY, self.config)
      self.slots[index] = slot
    end
  end
end
function SellAll_ShowToggle()
  if npcShop.tabIndexSell == npcShop.lastTabIndex then
    npcShop.buttonSellAll:SetShow(true)
    npcShop.buttonSellAll:ComputePos()
  else
    npcShop.buttonSellAll:SetShow(false)
  end
end
function BuySome_ShowToggle()
  local self = npcShop
  if self.tabIndexBuy == self.lastTabIndex then
    self.buttonBuySome:SetShow(true)
    self.buttonBuySome:SetEnable(false)
    self.buttonBuySome:SetMonoTone(true)
    self.buttonBuySome:ComputePos()
  else
    self.buttonBuySome:SetShow(false)
  end
end
function npcShop:controlInit()
  self.radioButtons[self.tabIndexBuy]:SetCheck(true)
  self.radioButtons[self.tabIndexSell]:SetCheck(false)
  self.radioButtons[self.tabIndexRepurchase]:SetCheck(false)
  self.lastTabIndex = self.tabIndexBuy
  NpcShop_OnSlotClicked()
  self.lastScrollValue = 0
  self.lastStartSlotNo = 0
  self._startSlotIndex = 0
  for _, slot in pairs(self.slots) do
    slot:clearItem()
  end
  SellAll_ShowToggle()
  BuySome_ShowToggle()
  local talker = dialog_getTalker()
  if nil ~= talker then
    local actorProxyWrapper = getNpcActor(talker:getActorKey())
    if nil ~= actorProxyWrapper then
      local characterSSW = actorProxyWrapper:getCharacterStaticStatusWrapper()
      if characterSSW:isSellingNormalShop() then
        self.radioButtons[self.tabIndexSell]:SetShow(true)
        self.radioButtons[self.tabIndexRepurchase]:SetShow(true)
        self.radioButtons[self.tabIndexBuy]:SetPosX(npcShop_BuyBtn_PosX)
      else
        self.radioButtons[self.tabIndexSell]:SetShow(false)
        self.radioButtons[self.tabIndexRepurchase]:SetShow(false)
        self.radioButtons[self.tabIndexBuy]:SetPosX(npcShop_BuyBtn_PosX)
      end
      if npcShop_isGuildShopContents() then
        _npcShopHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_HELPDESC_GUILD"))
      else
        _npcShopHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_HELPDESC"))
      end
    end
  elseif self._isCamping then
    self.radioButtons[self.tabIndexSell]:SetShow(false)
    self.radioButtons[self.tabIndexRepurchase]:SetShow(false)
    self.radioButtons[self.tabIndexBuy]:SetPosX(npcShop_BuyBtn_PosX)
    _npcShopHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CAMPNPCSHOP_HELPDESC"))
  end
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  if screenSizeY <= 800 then
    Panel_Window_NpcShop:SetPosY(screenSizeY / 2 - Panel_Window_NpcShop:GetSizeY() / 2 - 30)
  else
    Panel_Window_NpcShop:SetPosY(screenSizeY / 2 - Panel_Window_NpcShop:GetSizeY() / 2 - 100)
  end
  self.buttonBuySome:ComputePos()
end
function npcShop:updateContent(updateForce)
  if nil == npcShop then
    return
  end
  local self = npcShop
  updateForce = updateForce or true
  if nil == self.lastTabIndex or self.lastTabIndex < self.tabIndexBuy or self.lastTabIndex > self.tabIndexRepurchase then
    UI.ASSERT(false, [[
======== [LOVELYK2] =======
Wrong NpcShop Tab Index!! : ]] .. self.lastTabIndex)
    return
  end
  if npcShop.buttonSellAll:GetTextSizeX() > npcShop.buttonSellAll:GetSizeX() then
    npcShop.buttonSellAll:SetSize(npcShop.buttonSellAll:GetTextSizeX() + 10, npcShop.buttonSellAll:GetSizeY())
    npcShop.buttonSellAll:ComputePos()
  end
  Panel_Window_NpcShop:SetShow(true, false)
  if self.tabIndexBuy == self.lastTabIndex then
    self._itemListSize = npcShop_getBuyCount()
  elseif self.tabIndexSell == self.lastTabIndex then
    self._itemListSize = npcShop_getSellCount()
  else
    self._itemListSize = npcShop_getRepurchaseCount()
  end
  self.buttonBuy:SetText(self.commandText[self.lastTabIndex])
  if self._itemListSize <= 0 then
    for _, slot in pairs(self.slots) do
      slot:clearItem()
    end
    NpcShop_OnSlotClicked()
    self.scroll:SetEnable(false)
    self.scroll:SetMonoTone(true)
    self.scroll:SetShow(false)
    return
  end
  if updateForce or self._startSlotIndex ~= self.lastStartSlotNo then
    if self.tabIndexBuy ~= self.lastTabIndex and self._itemListSize >= self.config.slotRows and self._itemListSize < self._startSlotIndex + self.config.slotRows then
      self._startSlotIndex = self._startSlotIndex - 1
      self.scroll:SetControlBottom()
    end
    self.lastStartSlotNo = self._startSlotIndex
    local newSelectSlot
    if nil ~= self.selectedSlotIndex and self.tabIndexRepurchase ~= self.lastTabIndex then
      local maxSlotNo = math.min(self._startSlotIndex + self.config.slotCount, self._itemListSize)
      local lastSelectedSlotNo = self.slots[self.selectedSlotIndex].slotNo
      if lastSelectedSlotNo >= self._startSlotIndex and maxSlotNo > lastSelectedSlotNo then
        newSelectSlot = lastSelectedSlotNo - self._startSlotIndex + 1
      end
      NpcShop_OnSlotClicked()
    end
    local inventory = getSelfPlayer():get():getInventory()
    for ii = 1, self.config.slotCount do
      local slot = self.slots[ii]
      slot.slotNo = self._startSlotIndex + ii - 1
      if slot.slotNo < self._itemListSize then
        local shopItemWrapper, s64_inventoryItemCount
        if self.tabIndexBuy == self.lastTabIndex then
          shopItemWrapper = npcShop_getItemBuy(slot.slotNo)
        elseif self.tabIndexSell == self.lastTabIndex then
          shopItemWrapper = npcShop_getItemSell(slot.slotNo)
          s64_inventoryItemCount = inventory:getItemCount_s64(shopItemWrapper:getStaticStatus():get()._key)
        else
          slot.slotNo = self._itemListSize - self._startSlotIndex - ii
          shopItemWrapper = npcShop_getItemRepurchase(slot.slotNo)
        end
        local itemPrice_s64
        if nil ~= shopItemWrapper then
          local shopItem = shopItemWrapper:get()
          if self.tabIndexSell == self.lastTabIndex then
            itemPrice_s64 = shopItem:getItemSellPriceWithOption()
            slot:setItem(shopItemWrapper:getStaticStatus(), shopItem.leftCount_s64, itemPrice_s64, s64_inventoryItemCount, shopItem:getItemUsablePeriod())
          elseif self.tabIndexBuy == self.lastTabIndex then
            itemPrice_s64 = shopItem:getItemPriceWithOption()
            slot:setItem(shopItemWrapper:getStaticStatus(), shopItem.leftCount_s64, itemPrice_s64, s64_inventoryItemCount, shopItem:getItemUsablePeriod(), shopItem:getNeedIntimacy())
          else
            itemPrice_s64 = shopItem.price_s64
            slot:setItem(shopItemWrapper:getStaticStatus(), shopItem.leftCount_s64, itemPrice_s64, s64_inventoryItemCount, shopItem:getItemUsablePeriod(), shopItem:getNeedIntimacy())
          end
          if self.tabIndexBuy == self.lastTabIndex and _const.s64_0 == shopItem.leftCount_s64 then
            slot.button:addInputEvent("Mouse_LUp", "")
            slot.button:addInputEvent("Mouse_RUp", "")
          else
            slot.button:addInputEvent("Mouse_LUp", "NpcShop_OnSlotClicked(" .. ii .. ")")
            slot.button:addInputEvent("Mouse_RUp", "NpcShop_OnRSlotClicked(" .. ii .. ")")
          end
          slot.button:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. slot.slotNo .. ",\"shop\", true)")
          slot.button:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. slot.slotNo .. ",\"shop\", false)")
          slot.icon.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. slot.slotNo .. ",\"shop\", true)")
          slot.icon.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. slot.slotNo .. ",\"shop\", false)")
          Panel_Tooltip_Item_SetPosition(slot.slotNo, slot.icon, "shop")
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
            if self.tabIndexBuy == self.lastTabIndex and itemPrice_s64 > myGuildListInfo:getGuildBusinessFunds_s64() then
              slot.price:SetFontColor(UI_color.C_FFD20000)
            else
              slot.price:SetFontColor(UI_color.C_FFE7E7E7)
            end
          else
            slot.price:SetFontColor(UI_color.C_FFD20000)
          end
        elseif self.tabIndexBuy == self.lastTabIndex and itemPrice_s64 > myInvenMoney_s64 and itemPrice_s64 > myWareHouseMoney_s64 then
          slot.price:SetFontColor(UI_color.C_FFD20000)
        else
          slot.price:SetFontColor(UI_color.C_FFE7E7E7)
        end
      else
        slot:clearItem()
      end
    end
    if nil ~= newSelectSlot then
      NpcShop_OnSlotClicked(newSelectSlot)
    elseif self.selectedSlotIndex then
      local lastSelectedSlot = self.slots[self.selectedSlotIndex]
      if lastSelectedSlot.keyValue ~= self.selectedSlotKeyValue then
        NpcShop_OnSlotClicked()
      end
    end
    local dialogData = ToClient_GetCurrentDialogData()
    if nil == dialogData then
      npcShop.windowTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_WINDOWTITLE"))
      return
    end
    local npcTitle = dialogData:getContactNpcTitle()
    local npcName = dialogData:getContactNpcName()
    npcShop.windowTitle:SetText(npcTitle .. " " .. npcName)
  end
  UIScroll.SetButtonSize(self.scroll, self.config.slotCount, self._itemListSize)
  if self._itemListSize == self._startSlotIndex + self.config.slotRows then
    self.scroll:SetControlBottom()
  end
  PaGlobal_TutorialManager:handleNpcShopUpdateContent()
end
function FGlobal_NpcShop_GetRadioButtonByIndex(radioButtonIndex)
  local radioButton = npcShop.radioButtons[radioButtonIndex]
  if nil == radioButton then
    return nil
  end
  return radioButton
end
function NpcShop_OnSlotClicked(slotIdx)
  local self = npcShop
  local slot
  if self.lastSelectedSlotIndex ~= slotIdx then
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  end
  self.lastSelectedSlotIndex = slotIdx
  self.selectedSlotKeyValue = -1
  if nil ~= self.selectedSlotIndex then
    slot = self.slots[self.selectedSlotIndex]
    slot:setSelect(false)
    self.buttonBuy:SetEnable(false)
    self.buttonBuy:SetMonoTone(true)
    self.buttonSellAll:SetEnable(false)
    self.buttonSellAll:SetMonoTone(true)
    self.buttonBuySome:SetEnable(false)
    self.buttonBuySome:SetMonoTone(true)
  end
  if nil ~= slotIdx then
    slot = self.slots[slotIdx]
    slot:setSelect(true)
    self.selectedSlotKeyValue = slot.keyValue
    self.buttonBuy:SetEnable(true)
    self.buttonBuy:SetMonoTone(false)
    self.buttonSellAll:SetEnable(true)
    self.buttonSellAll:SetMonoTone(false)
    self.buttonBuy:SetShow(true)
    self.buttonBuySome:SetEnable(false)
    self.buttonBuySome:SetMonoTone(true)
    if slot.isStackable == false then
      self.buttonBuySome:SetShow(false)
      self.buttonSellAll:SetEnable(false)
      self.buttonSellAll:SetMonoTone(true)
    elseif self.tabIndexBuy == self.lastTabIndex then
      CopyBaseProperty(orgButtonBuySome, self.buttonBuySome)
      self.buttonBuySome:SetShow(true)
      self.buttonBuySome:SetEnable(true)
      self.buttonBuySome:SetMonoTone(false)
      self.buttonSellAll:SetEnable(true)
      self.buttonSellAll:SetMonoTone(false)
    end
  end
  self.buttonBuySome:SetPosX(npcShop.buttonBuy:GetPosX())
  self.selectedSlotIndex = slotIdx
end
function NpcShop_OnRSlotClicked(slotIdx)
  NpcShop_OnSlotClicked(slotIdx)
  NpcShop_BuyOrSellItem()
end
function NpcShop_TabButtonClick(tabIndex)
  local self = npcShop
  if tabIndex ~= self.lastTabIndex then
    NpcShop_OnSlotClicked()
    self.lastTabIndex = tabIndex
    if 0 == tabIndex then
      self.scroll:SetEnable(true)
      self.scroll:SetMonoTone(false)
      self.scroll:SetShow(true)
    elseif 1 == tabIndex then
      self.scroll:SetEnable(true)
      self.scroll:SetMonoTone(false)
      self.scroll:SetShow(true)
    elseif 2 == tabIndex then
      ToClient_NpcShop_UpdateRepurchaseList()
    end
    self.scroll:SetControlPos(0)
    self.lastStartSlotNo = 0
    self._startSlotIndex = 0
    self:updateContent(true)
  end
  SellAll_ShowToggle()
  BuySome_ShowToggle()
  NpcShop_CheckInit()
  PaGlobal_TutorialManager:handleNpcShopTabButtonClick(tabIndex)
end
function NpcShop_ScrollEvent(isUpScroll)
  local self = npcShop
  self._startSlotIndex = UIScroll.ScrollEvent(self.scroll, isUpScroll, self.config.slotRows, self._itemListSize, self._startSlotIndex, self.config.slotCols)
  if self._startSlotIndex < self.config.slotCols then
    self._startSlotIndex = self._startSlotIndex * self.config.slotCols
  end
  Panel_Tooltip_Item_hideTooltip()
  self:updateContent(false)
end
function NpcShop_UpdateContent()
  local talker = dialog_getTalker()
  npcShop._isCamping = PaGlobal_Camp:getIsCamping()
  if nil == talker and (false == npcShop._isCamping or nil == npcShop._isCamping) then
    return
  end
  if false == npcShop._isCamping or nil == npcShop._isCamping then
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
  NpcShop_WindowShow()
  npcShop.scroll:SetControlPos(0)
  npcShop:updateContent(true)
  Inventory_SetFunctor(Panel_NpcShop_InvenFilter_IsExchangeItem, Panel_NpcShop_InvenRClick, NpcShop_WindowClose, nil)
  NpcShop_UpdateMoney()
  NpcShop_UpdateMoneyWarehouse()
  UpdateGuildPriceLimit()
end
function NpcShop_UpdateMoneyWithContent()
  NpcShop_UpdateMoney()
  if true == Panel_Window_NpcShop:GetShow() then
    local self = npcShop
    self:updateContent()
  end
end
function NpcShop_UpdateMoneyWarehouseWithContent()
  NpcShop_UpdateMoneyWarehouse()
  if true == Panel_Window_NpcShop:GetShow() then
    local self = npcShop
    self:updateContent()
  end
end
function NpcShop_UpdateMoney()
  if true == _ContentsGroup_InvenUpdateCheck and false == Panel_Window_NpcShop:GetShow() then
    return
  end
  npcShop.buttonBuy:SetEnable(true)
  npcShop.buttonBuy:SetMonoTone(false)
  if npcShop_isGuildShopContents() then
    npcShop.staticMoney:SetShow(false)
    npcShop.checkButton_Inventory:SetShow(false)
    npcShop.checkButton_Warehouse:SetShow(false)
    npcShop.checkButton_Warehouse:SetShow(false)
    npcShop.staticWarehouseMoney:SetShow(false)
    npcShop.myGuildPriceLimitValue:SetShow(true)
    npcShop.myGuildMoneyValue:SetShow(true)
  else
    npcShop.staticMoney:SetShow(true)
    npcShop.staticMoney:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
    npcShop.checkButton_Inventory:SetShow(true)
    npcShop.checkButton_Inventory:SetEnableArea(0, 0, 230, npcShop.checkButton_Inventory:GetSizeY())
    if not ToClient_HasWareHouseFromNpc() then
      npcShop.checkButton_Warehouse:SetShow(false)
      npcShop.staticWarehouseMoney:SetShow(false)
      npcShop.myGuildPriceLimitValue:SetShow(false)
      npcShop.myGuildMoneyValue:SetShow(false)
    else
      npcShop.checkButton_Warehouse:SetShow(true)
      npcShop.checkButton_Warehouse:SetEnableArea(0, 0, 230, npcShop.checkButton_Warehouse:GetSizeY())
      npcShop.staticWarehouseMoney:SetShow(true)
      npcShop.myGuildPriceLimitValue:SetShow(false)
      npcShop.myGuildMoneyValue:SetShow(false)
    end
  end
end
function NpcShop_UpdateMoneyWarehouse()
  if npcShop_isGuildShopContents() then
    npcShop.myGuildMoneyValue:SetShow(true)
    local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
    if nil == myGuildListInfo then
      npcShop.myGuildMoneyValue:SetText("")
      return
    end
    npcShop.myGuildMoneyValue:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_GUILDMONEY") .. " : " .. makeDotMoney(myGuildListInfo:getGuildBusinessFunds_s64()))
    npcShop.myGuildPriceLimitValue:SetShow(true)
  else
    if not ToClient_HasWareHouseFromNpc() then
      npcShop.checkButton_Warehouse:SetShow(false)
      npcShop.staticWarehouseMoney:SetShow(false)
      npcShop.myGuildPriceLimitValue:SetShow(false)
    else
      npcShop.checkButton_Warehouse:SetShow(true)
      npcShop.staticWarehouseMoney:SetShow(true)
      npcShop.myGuildPriceLimitValue:SetShow(false)
    end
    npcShop.checkButton_Warehouse:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_WAREHOUSE_IN_MONEY"))
    npcShop.staticWarehouseMoney:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
  end
end
function UpdateGuildPriceLimit()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if nil == ToClient_GetMyGuildInfoWrapper() then
    npcShop.myGuildPriceLimitValue:SetShow(false)
    return
  end
  if nil ~= selfPlayer and true == npcShop.myGuildPriceLimitValue:GetShow() then
    if false == selfPlayer:get():isGuildMaster() and true == selfPlayer:get():getGuildIsPriceLimit() then
      npcShop.myGuildPriceLimitValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WINDOW_NPCSHOP_GUILDPRICELIMITED_VALUE", "price", makeDotMoney(selfPlayer:get():getGuildPriceLimit())))
    else
      npcShop.myGuildPriceLimitValue:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_NPCSHOP_GUILDPRICEUNLIMITED"))
    end
  end
end
function NpcShop_BuyOrSellItem()
  local self = npcShop
  if nil ~= self.selectedSlotIndex then
    do
      local slot = self.slots[self.selectedSlotIndex]
      if self.tabIndexBuy == self.lastTabIndex then
        local fromWhereType = 0
        local shopItemWrapper = npcShop_getItemBuy(slot.slotNo)
        local shopItemPrice = shopItemWrapper:get():getItemPriceWithOption()
        local myInvenMoney = getSelfPlayer():get():getInventory():getMoney_s64()
        local myWarehouseMoney = warehouse_moneyFromNpcShop_s64()
        local hasIntimacy = shopItemWrapper:getStaticStatus():hasMenatlCardKey()
        if hasIntimacy then
          return
        end
        if self.checkButton_Warehouse:IsCheck() then
          fromWhereType = 2
        end
        if npcShop_isGuildShopContents() then
          fromWhereType = CppEnums.ItemWhereType.eGuildWarehouse
          if not npcShop_GuildCheckByBuy() then
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
        rv = npcShop_doBuy(slot.slotNo, 1, fromWhereType, 0, self._isCamping)
        local shopItemKey = shopItemWrapper:getStaticStatus():get()._key:getItemKey()
        if shopItemKey >= 30000 and shopItemKey < 40000 and 0 == rv then
          local self = slot
          if npcShop.checkButton_Inventory:IsCheck() and shopItemPrice < myInvenMoney then
            self.button:SetIgnore(true)
            self.icon.icon:SetMonoTone(true)
            self.trend:SetMonoTone(true)
            self.price:SetMonoTone(true)
            self.remainCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_ALREADYHASINTIMACY"))
          elseif npcShop.checkButton_Warehouse:IsCheck() and shopItemPrice < myWarehouseMoney then
            self.button:SetIgnore(true)
            self.icon.icon:SetMonoTone(true)
            self.trend:SetMonoTone(true)
            self.price:SetMonoTone(true)
            self.remainCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_ALREADYHASINTIMACY"))
          end
        end
      elseif self.tabIndexSell == self.lastTabIndex then
        do
          local shopItemWrapper = npcShop_getItemSell(slot.slotNo)
          local shopItem = shopItemWrapper:get()
          local shopItemSSW = npcShop_getItemWrapperByShopSlotNo(slot.slotNo)
          local shopItemEndurance = shopItemSSW:get():getEndurance()
          local pricePiece = Int64toInt32(shopItemSSW:getSellPriceCalculate(shopItem:getItemPriceOption()))
          local toWhereType = 0
          if self.checkButton_Warehouse:IsCheck() then
            toWhereType = 2
          end
          if npcShop_isGuildShopContents() then
            if not npcShop_GuildCheckByBuy() then
              return
            end
            toWhereType = CppEnums.ItemWhereType.eGuildWarehouse
          end
          local function sellDoit()
            local itemSSW = npcShop_getItemWrapperByShopSlotNo(slot.slotNo)
            local isSocketed = false
            local function sellConfirm()
              npcShop_doSellByItemNo(slot.slotNo, 1, toWhereType, self._isCamping)
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
                functionYes = sellConfirm,
                functionNo = MessageBox_Empty_function,
                priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
              }
              MessageBox.showMessageBox(messageBoxData)
            else
              npcShop_doSellByItemNo(slot.slotNo, 1, toWhereType, self._isCamping)
              self.buttonBuy:SetEnable(false)
              self.buttonBuy:SetMonoTone(false)
              self.buttonSellAll:SetEnable(false)
              self.buttonSellAll:SetMonoTone(false)
            end
            if 2 == toWhereType then
              Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_MONEYFORWAREHOUSE_ACK", "getMoney", makeDotMoney(pricePiece)), 6)
            end
          end
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
        end
      elseif self.tabIndexRepurchase == self.lastTabIndex then
        local fromWhereType = 0
        if self.checkButton_Warehouse:IsCheck() then
          fromWhereType = 2
        end
        if npcShop_isGuildShopContents() then
          fromWhereType = CppEnums.ItemWhereType.eGuildWarehouse
          if not npcShop_GuildCheckByBuy() then
            return
          end
        end
        npcShop_doRepurchase(slot.slotNo, fromWhereType, self._isCamping)
        self.buttonBuy:SetEnable(false)
        self.buttonBuy:SetMonoTone(false)
      end
    end
  end
  DragManager:clearInfo()
end
function NpcShop_SellItemAll()
  local self = npcShop
  if nil ~= self.selectedSlotIndex then
    do
      local slot = self.slots[self.selectedSlotIndex]
      local shopItemWrapper = npcShop_getItemSell(slot.slotNo)
      local shopItem = shopItemWrapper:get()
      local inventory = getSelfPlayer():get():getInventory()
      local s64_inventoryItemCount = inventory:getItemCount_s64(shopItemWrapper:getStaticStatus():get()._key)
      local shopItemSSW = npcShop_getItemWrapperByShopSlotNo(slot.slotNo)
      local itemCount = Int64toInt32(s64_inventoryItemCount)
      local pricePiece = Int64toInt32(shopItemSSW:getSellPriceCalculate(shopItem:getItemPriceOption()))
      local toWhereType = CppEnums.ItemWhereType.eInventory
      local sellPrice = pricePiece * itemCount
      local function sellAllDoit()
        if npcShop_isGuildShopContents() then
          toWhereType = CppEnums.ItemWhereType.eGuildWarehouse
        elseif self.checkButton_Warehouse:IsCheck() then
          toWhereType = 2
        end
        local itemSSW = npcShop_getItemWrapperByShopSlotNo(slot.slotNo)
        local isSocketed = false
        local function sellConfirm()
          npcShop_doSellAll(slot.keyValue, toWhereType, self._isCamping)
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
            functionYes = sellConfirm,
            functionNo = MessageBox_Empty_function,
            priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
          }
          MessageBox.showMessageBox(messageBoxData)
        else
          npcShop_doSellAll(slot.keyValue, toWhereType, self._isCamping)
          if 2 == toWhereType then
            Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_MONEYFORWAREHOUSE_ACK", "getMoney", makeDotMoney(sellPrice)), 6)
          end
        end
      end
      local shopItemEndurance = shopItemSSW:get():getEndurance()
      local itemKeyForTradeInfo = shopItemWrapper:getStaticStatus():get()._key:get()
      local tradeMasterInfo = getItemMarketMasterByItemEnchantKey(itemKeyForTradeInfo)
      if nil ~= tradeMasterInfo and 0 ~= shopItemEndurance then
        if sellPrice >= 500000 and toWhereType ~= CppEnums.ItemWhereType.eGuildWarehouse and not ToClient_HasWareHouseFromNpc() and false == _ContentsGroup_RenewUI_ItemMarketPlace then
          local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_HIGHWEIGHT_WARNING_FOR_ITEMMARKET")
          local messageBoxData = {
            title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"),
            content = messageBoxMemo,
            functionYes = sellAllDoit,
            functionNo = MessageBox_Empty_function,
            priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
          }
          MessageBox.showMessageBox(messageBoxData)
        else
          local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_ITEMMARKET_USE_MSGMEMO")
          local messageBoxData = {
            title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"),
            content = messageBoxMemo,
            functionYes = sellAllDoit,
            functionNo = MessageBox_Empty_function,
            priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
          }
          MessageBox.showMessageBox(messageBoxData)
        end
      elseif sellPrice >= 500000 and toWhereType ~= CppEnums.ItemWhereType.eGuildWarehouse and not ToClient_HasWareHouseFromNpc() and false == _ContentsGroup_RenewUI_ItemMarketPlace then
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
function NpcShop_BuySome()
  local self = npcShop
  local shopItemWrapper = npcShop_getItemBuy(self._startSlotIndex + self.selectedSlotIndex - 1)
  local shopItem = shopItemWrapper:get()
  local itemEnchantStaticStatus = shopItemWrapper:getStaticStatus():get()
  local money_s64 = getSelfPlayer():get():getInventory():getMoney_s64()
  local s64_allWeight = Int64toInt32(getSelfPlayer():get():getCurrentWeight_s64())
  local s64_maxWeight = Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64())
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if self.checkButton_Warehouse:IsCheck() then
    money_s64 = warehouse_moneyFromNpcShop_s64()
  end
  if npcShop_isGuildShopContents() then
    if not npcShop_GuildCheckByBuy() then
      return
    end
    money_s64 = myGuildListInfo:getGuildBusinessFunds_s64()
  end
  local s64_maxMoneyNumber = money_s64 / shopItem:getItemPriceWithOption()
  local s64_maxWeightNumber = Defines.s64_const.s64_0
  local itemWeight
  if self.checkButton_Inventory:IsCheck() then
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
    if s64_maxMoneyNumber > maxNumber then
      s64_maxMoneyNumber = maxNumber
    end
    if s64_maxWeightNumber > maxNumber then
      s64_maxWeightNumber = maxNumber
    end
  end
  Panel_NumberPad_Show(true, s64_maxMoneyNumber, param, NpcShop_BuySome_ConfirmFunction, nil, nil, nil, nil, s64_maxWeightNumber)
  Panel_NumberPad_SetType("NpcShop_BuySome")
end
function NpcShop_BuySome_ConfirmFunction(inputNumber, param)
  local self = npcShop
  self._inputNumber = inputNumber
  local slot = self.slots[self.selectedSlotIndex]
  local buyCount = self._inputNumber
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  if self.checkButton_Warehouse:IsCheck() then
    fromWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  local shopItemWrapper = npcShop_getItemBuy(slot.slotNo)
  local shopItem = shopItemWrapper:get()
  local selectItem = shopItemWrapper:getStaticStatus():getName()
  local totalPrice = shopItem:getItemPriceWithOption() * inputNumber
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_BUY_ALERT_TITLE")
  local contentString = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_NPCSHOP_BUY_ALERT_1", "item", tostring(selectItem), "number", tostring(self._inputNumber), "price", makeDotMoney(totalPrice))
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = NpcShop_BuySome_Do,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  if npcShop_isGuildShopContents() then
    fromWhereType = CppEnums.ItemWhereType.eGuildWarehouse
    if not npcShop_GuildCheckByBuy() then
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
  if toInt64(0, 499) < self._inputNumber or totalPrice > toInt64(0, 99999) then
    MessageBox.showMessageBox(messageboxData)
  else
    npcShop_doBuy(slot.slotNo, buyCount, fromWhereType, 0, self._isCamping)
  end
  self.buttonBuy:SetEnable(false)
  self.buttonBuy:SetMonoTone(true)
end
function NpcShop_BuySome_Do()
  local self = npcShop
  local buyCount = self._inputNumber
  local slot = self.slots[self.selectedSlotIndex]
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  if self.checkButton_Warehouse:IsCheck() then
    fromWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  if npcShop_isGuildShopContents() then
    fromWhereType = CppEnums.ItemWhereType.eGuildWarehouse
    if not npcShop_GuildCheckByBuy() then
      return
    end
  end
  npcShop_doBuy(slot.slotNo, buyCount, fromWhereType, 0, self._isCamping)
end
function npcShop:registEventHandler()
  self.buttonClose:addInputEvent("Mouse_LUp", "handleClickedNpcShow_WindowClose()")
  self.buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"NpcShop\" )")
  self.buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"NpcShop\", \"true\")")
  self.buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"NpcShop\", \"false\")")
  self.buttonBuy:addInputEvent("Mouse_LUp", "NpcShop_BuyOrSellItem()")
  self.buttonBuySome:addInputEvent("Mouse_LUp", "NpcShop_BuySome()")
  self.buttonSellAll:addInputEvent("Mouse_LUp", "NpcShop_SellItemAll()")
  self.checkButton_Inventory:addInputEvent("Mouse_LUp", "NpcShop_CheckFromMoney( 0 )")
  self.checkButton_Inventory:addInputEvent("Mouse_On", "CheckButton_Inventory_ShowText()")
  self.checkButton_Inventory:addInputEvent("Mouse_Out", "CheckButton_Inventory_HideText()")
  self.checkButton_Warehouse:addInputEvent("Mouse_LUp", "NpcShop_CheckFromMoney( 1 )")
  self.checkButton_Warehouse:addInputEvent("Mouse_On", "CheckButton_Warehouse_ShowText()")
  self.checkButton_Warehouse:addInputEvent("Mouse_Out", "CheckButton_Warehouse_HideText()")
  UIScroll.InputEvent(self.scroll, "NpcShop_ScrollEvent")
  Panel_Window_NpcShop:addInputEvent("Mouse_UpScroll", "")
  Panel_Window_NpcShop:addInputEvent("Mouse_DownScroll", "")
  for idx, btn in pairs(self.radioButtons) do
    btn:addInputEvent("Mouse_LUp", "NpcShop_TabButtonClick(" .. idx .. ")")
  end
end
function CheckButton_Inventory_ShowText()
  inventxt:SetShow(true)
end
function CheckButton_Inventory_HideText()
  inventxt:SetShow(false)
end
function CheckButton_Warehouse_ShowText()
  if npcShop_isGuildShopContents() then
    warehousetxt:SetShow(false)
  else
    warehousetxt:SetShow(true)
  end
end
function CheckButton_Warehouse_HideText()
  warehousetxt:SetShow(false)
end
function NpcShop_WindowClose()
  if Panel_Window_NpcShop:GetShow() then
    Panel_Window_NpcShop:SetShow(false, false)
    InventoryWindow_Close()
    audioPostEvent_SystemUi(1, 1)
    PaGlobal_TutorialManager:handleNpcShopWindowClose()
    if PaGlobal_Camp:getIsCamping() then
      InventoryWindow_Close()
      PaGlobal_Camp:open()
    end
  end
end
function handleClickedNpcShow_WindowClose()
  if Panel_Window_NpcShop:GetShow() then
    Panel_Window_NpcShop:SetShow(false, false)
    InventoryWindow_Close()
    audioPostEvent_SystemUi(1, 1)
    ReqeustDialog_retryTalk()
    PaGlobal_TutorialManager:handleNpcShopWindowClose()
    if PaGlobal_Camp:getIsCamping() then
      InventoryWindow_Close()
      PaGlobal_Camp:open()
    end
  end
end
function NpcShop_WindowShow()
  if true == _ContentsGroup_RenewUI_ItemMarketPlace_Only and Panel_Window_MarketPlace_WalletInventory:GetShow() then
    PaGlobalFunc_MarketWallet_ForceClose()
  end
  if not Panel_Window_NpcShop:GetShow() then
    npcShop:controlInit()
    InventoryWindow_Show()
    audioPostEvent_SystemUi(1, 0)
    NpcShop_CheckInit()
  end
end
function Panel_NpcShop_InvenFilter_IsExchangeItem(slotNo, itemWrapper)
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
local itemCount
function Panel_NpcShop_InvenRClick(slotNo)
  local itemWrapper = getInventoryItem(slotNo)
  if nil ~= itemWrapper then
    itemCount = itemWrapper:get():getCount_s64()
    if Defines.s64_const.s64_1 == itemCount then
      Panel_NpcShop_InvenRClick_SellItem(1, slotNo)
    else
      Panel_NumberPad_Show(true, itemCount, slotNo, Panel_NpcShop_InvenRClick_SellItem)
    end
  end
end
function PaGlobal_NpcShop:Simpletooltips(isShow, tipType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  local self = npcShop
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "SHOP_BTN_TAPBUY")
    control = self.radioButtons[0]
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "SHOP_BTN_TAPSELL")
    control = self.radioButtons[1]
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "SHOP_BTN_TAPREBUY")
    control = self.radioButtons[2]
  end
  TooltipSimple_Show(control, name, desc)
end
function Panel_NpcShop_InvenRClick_SellItem(itemCount, slotNo)
  local self = npcShop
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
    if not npcShop_GuildCheckByBuy() then
      return
    end
    toWhereType = CppEnums.ItemWhereType.eGuildWarehouse
  elseif self.checkButton_Warehouse:IsCheck() then
    toWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  local function sellDoit()
    local isSocketed = false
    local function sellConfirm()
      playerWrapper:get():requestSellItem(slotNo, itemCount, fromWhereType, toWhereType, self._isCamping)
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
      playerWrapper:get():requestSellItem(slotNo, itemCount, fromWhereType, toWhereType, self._isCamping)
    end
    if 2 == toWhereType then
      Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_MONEYFORWAREHOUSE_ACK", "getMoney", makeDotMoney(sellPrice)), 6)
    end
  end
  local itemKeyForTradeInfo = itemWrapper:getStaticStatus():get()._key:get()
  local tradeMasterInfo = getItemMarketMasterByItemEnchantKey(itemKeyForTradeInfo)
  if nil ~= tradeMasterInfo and 0 ~= itemEndurance then
    if sellPrice >= 500000 and toWhereType ~= CppEnums.ItemWhereType.eGuildWarehouse and not ToClient_HasWareHouseFromNpc() and false == _ContentsGroup_RenewUI_ItemMarketPlace then
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_HIGHWEIGHT_WARNING_FOR_ITEMMARKET")
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"),
        content = messageBoxMemo,
        functionYes = sellDoit,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    else
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
  elseif sellPrice >= 500000 and toWhereType ~= CppEnums.ItemWhereType.eGuildWarehouse and not ToClient_HasWareHouseFromNpc() and false == _ContentsGroup_RenewUI_ItemMarketPlace then
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
function npcShop:registMessageHandler()
  registerEvent("EventNpcShopUpdate", "NpcShop_UpdateContent")
  registerEvent("FromClient_InventoryUpdate", "NpcShop_UpdateMoneyWithContent")
  registerEvent("EventWarehouseUpdate", "NpcShop_UpdateMoneyWarehouseWithContent")
  registerEvent("UpdateGuildPriceLimit", "UpdateGuildPriceLimit")
end
function NpcShop_CheckInit()
  local self = npcShop
  if self.checkButton_Inventory:IsCheck() then
    return
  end
  if ToClient_HasWareHouseFromNpc() then
    if toInt64(0, 0) == warehouse_moneyFromNpcShop_s64() then
      self.checkButton_Inventory:SetCheck(true)
      self.checkButton_Warehouse:SetCheck(false)
    else
      self.checkButton_Inventory:SetCheck(false)
      self.checkButton_Warehouse:SetCheck(true)
    end
    self.checkButton_Warehouse:SetShow(true)
    self.staticWarehouseMoney:SetShow(true)
    self.myGuildPriceLimitValue:SetShow(true)
  else
    self.checkButton_Warehouse:SetShow(false)
    self.staticWarehouseMoney:SetShow(false)
    self.myGuildPriceLimitValue:SetShow(false)
    self.checkButton_Inventory:SetCheck(true)
    self.checkButton_Warehouse:SetCheck(false)
  end
end
function NpcShop_CheckFromMoney(check)
  local self = npcShop
  if 0 == check then
    if self.checkButton_Inventory:IsCheck() then
      self.checkButton_Warehouse:SetCheck(false)
    else
      self.checkButton_Warehouse:SetCheck(true)
    end
  elseif self.checkButton_Warehouse:IsCheck() then
    self.checkButton_Inventory:SetCheck(false)
  else
    self.checkButton_Inventory:SetCheck(true)
  end
  if Panel_NumberPad_IsPopUp() and Panel_NumberPad_IsType("NpcShop_BuySome") then
    NpcShop_BuySome()
  end
end
function npcShop_GuildCheckByBuy()
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
function npcShop:setIsCamping(isCamping)
  self._isCamping = isCamping
end
npcShop:init()
npcShop:createSlot()
npcShop:registEventHandler()
npcShop:registMessageHandler()

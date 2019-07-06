local _panel = Panel_TradeMarket_Graph
local TradeMarketGraph = {
  _ui = {
    stc_TitleBg = UI.getChildControl(_panel, "Static_TitleBg"),
    stc_Title = nil,
    stc_LeftBg = UI.getChildControl(_panel, "Static_LeftBg"),
    list_TradeItem = UI.getChildControl(_panel, "List2_TradeItem"),
    stc_BottomBg = UI.getChildControl(_panel, "Static_BottomBG"),
    stc_ItemDetailBG = UI.getChildControl(_panel, "Static_ItemDetailBG")
  },
  _itemEnchantKey = {},
  _itemShopIndex = {},
  _itemKeyTable = {},
  _maxPriceTable = {},
  _minPriceTable = {},
  _commerceBtnTable = {},
  _enCommerceIndex = -1,
  _isSellPanel = false,
  _byWorldMap = false,
  _currentNPCType = 1,
  _currentCommerceIdx = 1,
  _commerceBtnGapY = 60,
  _isShowItemDetail = false,
  _itemTooltipSizeY = {
    [1] = 343,
    [2] = 285,
    [3] = 285
  },
  _maxPricePosX = -1,
  _minPricePosX = -1,
  _maxPricePosY = 0,
  _minPricePosY = 9999999,
  _graphIntervalValue = 8,
  _conditionColorList = {},
  _conditionList = {}
}
local _commerceStringTable = {
  [enCommerceType.enCommerceType_Luxury_Miscellaneous] = PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_BTN_MISCELL"),
  [enCommerceType.enCommerceType_Luxury] = PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_BTN_LUXURY"),
  [enCommerceType.enCommerceType_Grocery] = PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_BTN_GROCERY"),
  [enCommerceType.enCommerceType_Cloth] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TRADEMARKET_GRAPH_BTN_CLOTH"),
  [enCommerceType.enCommerceType_ObjectSaint] = PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_BTN_OBJECT"),
  [enCommerceType.enCommerceType_MilitarySupplies] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TRADEMARKET_GRAPH_BTN_MILITARYSUPPLIES"),
  [enCommerceType.enCommerceType_Medicine] = PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_BTN_MEDICINE"),
  [enCommerceType.enCommerceType_SeaFood] = PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_BTN_SEAFOOD"),
  [enCommerceType.enCommerceType_RawMaterial] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TRADEMARKET_GRAPH_BTN_RAWMATERIAL"),
  [enCommerceType.enCommerceType_Max] = PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_BTN_ALL")
}
local _dialogSceneIndex = {
  [enCommerceType.enCommerceType_Luxury_Miscellaneous] = 8,
  [enCommerceType.enCommerceType_Luxury] = 7,
  [enCommerceType.enCommerceType_Grocery] = 5,
  [enCommerceType.enCommerceType_Cloth] = 10,
  [enCommerceType.enCommerceType_ObjectSaint] = 11,
  [enCommerceType.enCommerceType_MilitarySupplies] = 12,
  [enCommerceType.enCommerceType_Medicine] = 6,
  [enCommerceType.enCommerceType_SeaFood] = 14,
  [enCommerceType.enCommerceType_RawMaterial] = 13,
  [enCommerceType.enCommerceType_Max] = 0
}
function TradeMarketGraph:init()
  self._ui.stc_Title = UI.getChildControl(self._ui.stc_TitleBg, "StaticText_Title")
  self._ui.txt_AConsole = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_A_ConsoleUI")
  self._ui.txt_YConsole = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_Y_ConsoleUI")
  self._ui.txt_YConsole:SetShow(false)
  self._ui.stc_detailIcon = UI.getChildControl(self._ui.stc_ItemDetailBG, "Static_ItemDetailIcon")
  self._ui.txt_detailName = UI.getChildControl(self._ui.stc_ItemDetailBG, "StaticText_ItemDetailName")
  self._ui.txt_detailDesc = UI.getChildControl(self._ui.stc_ItemDetailBG, "StaticText_ItemDetailDesc")
  self._ui.txt_detailDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.stc_priceInfoBG = UI.getChildControl(self._ui.stc_ItemDetailBG, "Static_PriceInfoBG")
  self._ui.txt_detailCurrentPrice = UI.getChildControl(self._ui.stc_priceInfoBG, "StaticText_CurrentPriceDetail")
  self._ui.txt_detailCurrentRate = UI.getChildControl(self._ui.stc_priceInfoBG, "StaticText_CurrentPriceRate")
  self._ui.txt_detailHighestPrice = UI.getChildControl(self._ui.stc_priceInfoBG, "StaticText_HighestPrice")
  self._ui.txt_detailLowestPrice = UI.getChildControl(self._ui.stc_priceInfoBG, "StaticText_LowestPrice")
  self._ui.txt_detailOriginPrice = UI.getChildControl(self._ui.stc_priceInfoBG, "StaticText_BasicPrice")
  self._ui.stc_expireTimeBG = UI.getChildControl(self._ui.stc_ItemDetailBG, "Static_ExpireTimeBG")
  self._ui.txt_detailExpireTime = UI.getChildControl(self._ui.stc_expireTimeBG, "StaticText_ExpireTime")
  self._ui.txt_itemDetailCondition = UI.getChildControl(self._ui.stc_ItemDetailBG, "StaticText_ItemDetailCondition")
  self._ui.stc_detailDescLine = UI.getChildControl(self._ui.stc_ItemDetailBG, "Static_HorizontalLine2")
  PaGlobalFunc_ConsoleKeyGuide_SetAlign({
    self._ui.txt_AConsole
  }, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self._ui.buttonTemplate = UI.getChildControl(self._ui.stc_LeftBg, "RadioButton_Template")
  for idx = 1, enCommerceType.enCommerceType_Max - 1 do
    local commerceBtn = {}
    local commerceText = {}
    commerceBtn = UI.createAndCopyBasePropertyControl(self._ui.stc_LeftBg, "RadioButton_Template", self._ui.stc_LeftBg, "CommerceButton_" .. idx)
    commerceText = UI.createAndCopyBasePropertyControl(self._ui.buttonTemplate, "StaticText_CommerceType", commerceBtn, "StaticText_CommerceType_" .. idx)
    commerceText:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    commerceText:SetText(_commerceStringTable[idx])
    if commerceText:IsLimitText() then
      commerceText:SetSize(160, commerceText:GetSizeY())
      commerceText:SetText(_commerceStringTable[idx])
    end
    commerceBtn:SetPosY(commerceBtn:GetPosY() + (idx - 1) * self._commerceBtnGapY)
    commerceBtn:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_TradeMarketGraph_ShowCommerceType(" .. idx .. ")")
    commerceBtn:addInputEvent("Mouse_On", "InputMO_TradeMarketGraph_SetKeyGuide(true)")
    self._commerceBtnTable[idx] = commerceBtn
  end
  self:registEvent()
  PaGlobal_TradeMarketGraph_OnScreenResize()
end
function TradeMarketGraph:registEvent()
  self._ui.list_TradeItem:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_TradeMarketGraph_CreateList")
  self._ui.list_TradeItem:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  registerEvent("onScreenResize", "PaGlobal_TradeMarketGraph_OnScreenResize")
  registerEvent("EventNpcTradeShopGraphRefresh", "PaGlobal_TradeMarketGraph_GraphRefresh")
end
function TradeMarketGraph:open()
  self:SetFirstBtnIdx()
  PaGlobal_TradeMarketGraph_ShowCommerceType(self._currentCommerceIdx)
  self._isShowItemDetail = false
  self._ui.stc_ItemDetailBG:SetShow(self._isShowItemDetail)
  _panel:SetShow(true)
end
function TradeMarketGraph:close()
  _panel:SetShow(false)
end
function TradeMarketGraph:update()
  for idx = 1, enCommerceType.enCommerceType_Max - 1 do
    if nil ~= self._commerceBtnTable[idx] then
      self._commerceBtnTable[idx]:SetCheck(idx == self._currentCommerceIdx)
    end
  end
  local commerceCount = 0
  if 1 == self._currentNPCType then
    commerceCount = PaGlobal_TradeMarketGraph_CheckEmptyData(self._currentCommerceIdx)
  else
    commerceCount = npcShop_getCommerceItemSize(self._currentCommerceIdx)
  end
  self._maxPriceTable = {}
  self._minPriceTable = {}
  self._ui.list_TradeItem:getElementManager():clearKey()
  for itemIdx = 0, commerceCount - 1 do
    local itemKey = npcShop_GetCommerceItemByIndexAndSellOrBuy(self._currentCommerceIdx, self._currentNPCType, itemIdx)
    self._itemKeyTable[itemIdx] = itemKey
    if 0 ~= itemKey then
      self._ui.list_TradeItem:getElementManager():pushKey(toInt64(0, itemIdx))
    end
  end
  local avaliableTabCount = 0
  local itemCount = 0
  for idx = 1, enCommerceType.enCommerceType_Max - 1 do
    if 1 == self._currentNPCType then
      itemCount = PaGlobal_TradeMarketGraph_CheckEmptyData(idx)
    else
      itemCount = npcShop_getCommerceItemSize(idx)
    end
    if itemCount > 0 then
      self._commerceBtnTable[idx]:SetShow(true)
      self._commerceBtnTable[idx]:SetPosY(10 + avaliableTabCount * self._commerceBtnGapY)
      avaliableTabCount = avaliableTabCount + 1
    else
      self._commerceBtnTable[idx]:SetShow(false)
    end
  end
end
function TradeMarketGraph:updateShopIndex()
  local sellCount = npcShop_getBuyCount()
  local commerceIndex = 0
  local itemOrderIndex = 0
  for index = 1, sellCount do
    if -1 ~= self._currentCommerceIdx then
      itemOrderIndex = index - 1
      local itemwrapper = npcShop_getItemBuy(itemOrderIndex)
      local itemStatus = itemwrapper:getStaticStatus()
      local itemCommerceType = itemStatus:getCommerceType()
      if itemCommerceType == self._currentCommerceIdx or enCommerceType.enCommerceType_Max == self._currentCommerceIdx then
        if commerceIndex > 8 then
          return
        end
        self._itemShopIndex[commerceIndex] = itemOrderIndex
        commerceIndex = commerceIndex + 1
      end
    end
  end
end
function TradeMarketGraph:SetFirstBtnIdx()
  local itemCount = 0
  local firstBtnIdx = 0
  for idx = 1, enCommerceType.enCommerceType_Max - 1 do
    if 1 == self._currentNPCType then
      itemCount = PaGlobal_TradeMarketGraph_CheckEmptyData(idx)
    else
      itemCount = npcShop_getCommerceItemSize(idx)
    end
    if itemCount > 0 then
      firstBtnIdx = idx
      self._currentCommerceIdx = firstBtnIdx
      break
    else
      self._currentCommerceIdx = 1
    end
  end
end
function InputMLUp_TradeMarketGraph_BasketItem(index)
  local self = TradeMarketGraph
  local param = {
    [0] = self._itemKeyTable[index],
    [1] = self._itemShopIndex[index],
    [2] = true,
    [3] = self._currentCommerceIdx
  }
  local tradeItemWrapper = npcShop_getTradeItem(param[0])
  local buyableStack = tradeItemWrapper:get():calculateRemainCount()
  if true == PaGlobal_TradeMarketBasket_CheckBasketItem(param[0]) then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketBuyList_Already_Exist_In_Barket"))
    return
  end
  Panel_NumberPad_Show(true, buyableStack, param, PaGlobal_TradeMarketBasket_AddConfirm)
end
function PaGlobal_TradeMarketGraph_ToggleItemDetailDesc(index)
  local self = TradeMarketGraph
  self._isShowItemDetail = not self._isShowItemDetail
  if false == self._isShowItemDetail then
    self._ui.stc_ItemDetailBG:SetShow(false)
    return
  end
  local itemKey = self._itemKeyTable[index]
  local itemESSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
  local sellRate = string.format("%.f", npcShop_GetTradeGraphRateOfPrice(itemKey))
  local tradeItemWrapper = npcShop_getTradeItem(itemKey)
  local sellPrice = tradeItemWrapper:getTradeSellPrice()
  local needLifeLevel = tradeItemWrapper:get():getNeedLifeLevel()
  local needLifeType = tradeItemWrapper:get():getNeedLifeType()
  local originalPrice = itemESSW:getOriginalPriceByInt64()
  local buyableStack = tradeItemWrapper:getRemainStackCount()
  local priceRate_Value = PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TradeMarketGraph_SellRate", "Percent", tostring(sellRate))
  if 100 < tonumber(tostring(sellRate)) then
    priceRate_Value = "<PAColor0xFFFFCE22>" .. priceRate_Value .. "\226\150\178"
  else
    priceRate_Value = "<PAColor0xFFF26A6A>" .. priceRate_Value .. "\226\150\188"
  end
  self._ui.stc_detailIcon:ChangeTextureInfoNameAsync("Icon/" .. itemESSW:getIconPath())
  self._ui.txt_detailName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_detailName:SetText(itemESSW:getName())
  self._ui.txt_detailDesc:SetText(itemESSW:getDescription())
  self._ui.txt_detailCurrentPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_CURRENTPRICE", "price", makeDotMoney(sellPrice)))
  self._ui.txt_detailCurrentRate:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_CURRENTVALUE", "value", priceRate_Value))
  if -1 ~= self._minPriceTable[index] then
    self._ui.txt_detailHighestPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_HIGHESTPRICE", "price", makeDotMoney(self._minPriceTable[index])))
  else
    self._ui.txt_detailHighestPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_HIGHESTPRICE", "price", "-"))
  end
  if -1 ~= self._maxPriceTable[index] then
    self._ui.txt_detailLowestPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_LOWESTPRICE", "price", makeDotMoney(self._maxPriceTable[index])))
  else
    self._ui.txt_detailLowestPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_LOWESTPRICE", "price", "-"))
  end
  self._ui.txt_detailOriginPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_ORIGINALPRICE", "price", makeDotMoney(originalPrice)))
  local expiretime = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_WARRANTY", "expirationPeriod", tostring(tradeItemWrapper:getStaticStatus():get()._expirationPeriod / 60))
  self._ui.txt_detailExpireTime:SetText(expiretime)
  self._ui.txt_itemDetailCondition:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_itemDetailCondition:SetText(TradeMarketGraph._conditionList[index])
  self._ui.txt_itemDetailCondition:SetFontColor(TradeMarketGraph._conditionColorList[index])
  if 1 == self._currentNPCType then
    self._ui.stc_expireTimeBG:SetShow(true)
    self._ui.stc_priceInfoBG:SetSpanSize(0, self._ui.stc_expireTimeBG:GetSizeY())
  else
    self._ui.stc_expireTimeBG:SetShow(false)
    self._ui.stc_priceInfoBG:SetSpanSize(0, 0)
  end
  local descLinePosY = self._ui.txt_detailDesc:GetPosY() + self._ui.txt_detailDesc:GetTextSizeY() + 7
  self._ui.stc_detailDescLine:SetPosY(descLinePosY)
  local tooltipSizeY = self._itemTooltipSizeY[self._currentNPCType] + self._ui.txt_detailDesc:GetTextSizeY() + self._ui.txt_itemDetailCondition:GetTextSizeY()
  self._ui.stc_ItemDetailBG:SetSize(self._ui.stc_ItemDetailBG:GetSizeX(), tooltipSizeY)
  self._ui.stc_ItemDetailBG:ComputePos()
  self._ui.stc_priceInfoBG:ComputePos()
  self._ui.stc_expireTimeBG:ComputePos()
  self._ui.stc_ItemDetailBG:SetShow(true)
end
function inputMOut_TradeMarketGraph_ItemDetailDescOff(index)
  local self = TradeMarketGraph
  self._isShowItemDetail = false
  self._ui.stc_ItemDetailBG:SetShow(self._isShowItemDetail)
end
function PaGlobal_TradeMarketGraph_GraphRefresh()
  local self = TradeMarketGraph
  PaGlobal_TradeMarketGraph_ShowCommerceType(self._currentCommerceIdx)
end
function PaGlobal_TradeMarketGraph_OnScreenResize()
  local self = TradeMarketGraph
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local panelSizeX = _panel:GetSizeX()
  local panelSizeY = _panel:GetSizeY()
  _panel:SetSize(panelSizeX, screenSizeY)
  _panel:ComputePos()
  self._ui.stc_TitleBg:ComputePos()
  self._ui.stc_BottomBg:ComputePos()
end
function PaGlobal_TradeMarketGraph_Open(isSellPanel, isTerritorySupply)
  local self = TradeMarketGraph
  if true == isSellPanel then
    self._currentNPCType = 2
  else
    self._currentNPCType = 1
  end
  if true == isTerritorySupply then
    self._ui.stc_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_7"))
    self._currentNPCType = 3
  else
    self._ui.stc_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_8"))
  end
  self._byWorldMap = false
  self:open()
end
function PaGlobal_TradeMarketGraph_OpenByWorldMap()
  local self = TradeMarketGraph
  self._byWorldMap = true
  self:open()
end
function PaGlobal_TradeMarketGraph_Close()
  local self = TradeMarketGraph
  self:close()
end
function PaGlobal_TradeMarketGraph_Init()
  local self = TradeMarketGraph
  self:init()
end
function PaGlobal_TradeMarketGraph_CreateList(content, key)
  local self = TradeMarketGraph
  local itemIdx = Int64toInt32(key)
  local stc_Bg = UI.getChildControl(content, "Static_Bg")
  local txt_ItemName = UI.getChildControl(content, "StaticText_ItemName")
  local stc_ItemSlotBg = UI.getChildControl(content, "Static_ItmeSlotBg")
  local stc_ItemIcon = UI.getChildControl(stc_ItemSlotBg, "Static_ItemIcon")
  local txt_CurrentPrice = UI.getChildControl(content, "StaticText_CurrentPrice")
  local txt_LeftCount = UI.getChildControl(content, "StaticText_LeftCount")
  local txt_Price = UI.getChildControl(content, "StaticText_Price")
  local txt_Rate = UI.getChildControl(content, "StaticText_Rate")
  local txt_LeftTime = UI.getChildControl(content, "StaticText_LeftTime")
  local txt_Condition = UI.getChildControl(content, "StaticText_Condition")
  local graph_Panel = UI.getChildControl(content, "graph_panel")
  local graph_CurrentPoint = UI.getChildControl(content, "graph_currentPoint")
  local graph_LowestPoint = UI.getChildControl(content, "graph_LowestPoint")
  local graph_HighestPoint = UI.getChildControl(content, "graph_highestPoint")
  local graph_BaseLine = UI.getChildControl(content, "graph_baseline")
  local itemKey = self._itemKeyTable[itemIdx]
  local itemESSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
  local sellRate = string.format("%.f", npcShop_GetTradeGraphRateOfPrice(itemKey))
  local tradeItemWrapper = npcShop_getTradeItem(itemKey)
  local sellPrice = tradeItemWrapper:getTradeSellPrice()
  local needLifeLevel = tradeItemWrapper:get():getNeedLifeLevel()
  local needLifeType = tradeItemWrapper:get():getNeedLifeType()
  local originalPrice64 = itemESSW:getOriginalPriceByInt64()
  local originalPrice = Int64toInt32(originalPrice64)
  local upperPrice = tradeItemWrapper:getUpperLimitPrice()
  local underprice = tradeItemWrapper:getUnderLimitPrice()
  local buyableStack = tradeItemWrapper:getRemainStackCount()
  local variablePrice
  local priceRate_Value = PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TradeMarketGraph_SellRate", "Percent", tostring(sellRate))
  if 100 < tonumber(tostring(sellRate)) then
    priceRate_Value = "<PAColor0xFFFFCE22>" .. priceRate_Value .. "\226\150\178"
  else
    priceRate_Value = "<PAColor0xFFF26A6A>" .. priceRate_Value .. "\226\150\188"
  end
  local conditionLevel = PaGlobalFunc_CharacterLifeInfo_CraftLevel_Replace(needLifeLevel + 1)
  local conditionTypeName = CppEnums.LifeExperienceString[needLifeType]
  local buyingConditionValue = ""
  if 0 == needLifeLevel or nil == needLifeLevel then
    buyingConditionValue = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_NOPE")
    txt_Condition:SetFontColor(Defines.Color.C_FFC4BEBE)
    TradeMarketGraph._conditionColorList[itemIdx] = Defines.Color.C_FFC4BEBE
  else
    local playerThisCraftLevel = getSelfPlayer():get():getLifeExperienceLevel(needLifeType)
    if needLifeLevel < playerThisCraftLevel then
      txt_Condition:SetFontColor(Defines.Color.C_FFC4BEBE)
      TradeMarketGraph._conditionColorList[itemIdx] = Defines.Color.C_FFC4BEBE
    else
      txt_Condition:SetFontColor(Defines.Color.C_FF775555)
      TradeMarketGraph._conditionColorList[itemIdx] = Defines.Color.C_FF775555
    end
    buyingConditionValue = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_BUYINGCONDITION", "conditionTypeName", conditionTypeName, "conditionLevel", conditionLevel)
  end
  TradeMarketGraph._conditionList[itemIdx] = buyingConditionValue
  txt_ItemName:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  txt_ItemName:SetText(itemESSW:getName())
  txt_Rate:SetText(priceRate_Value)
  txt_Price:SetText(makeDotMoney(sellPrice))
  stc_ItemIcon:ChangeTextureInfoNameAsync("Icon/" .. itemESSW:getIconPath())
  txt_Condition:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  if 1 == self._currentNPCType then
    txt_Condition:SetText(buyingConditionValue)
    txt_Condition:SetShow(true)
    txt_LeftCount:ComputePos()
    txt_LeftCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_SUPPLYCOUNT", "leftCount", tostring(buyableStack)))
    txt_LeftCount:SetShow(true)
    txt_LeftTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_WARRANTY", "expirationPeriod", tostring(tradeItemWrapper:getStaticStatus():get()._expirationPeriod / 60)))
    txt_LeftTime:SetShow(true)
  elseif 2 == self._currentNPCType then
    txt_LeftCount:SetShow(false)
    txt_Condition:SetShow(false)
    txt_LeftTime:SetShow(false)
  elseif 3 == self._currentNPCType then
    local _s64_leftCount = tradeItemWrapper:getLeftCount()
    if Defines.s64_const.s64_0 == _s64_leftCount then
      local leftCountTextSizeY = txt_LeftCount:GetTextSizeY()
      txt_LeftCount:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      txt_LeftCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_5"))
      if txt_LeftCount:IsAutoWrapText() then
        txt_LeftCount:SetPosY(txt_LeftCount:GetPosY() - (txt_LeftCount:GetTextSizeY() - leftCountTextSizeY) / 2)
      else
        txt_LeftCount:ComputePos()
      end
    else
      local _leftCount = Int64toInt32(_s64_leftCount)
      txt_LeftCount:ComputePos()
      txt_LeftCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_SUPPLYCOUNT", "leftCount", _leftCount))
    end
    txt_LeftCount:SetShow(true)
    txt_Condition:SetShow(false)
    txt_LeftTime:SetShow(false)
  end
  local intervalPosY = graph_Panel:GetSizeY() / 2
  local priceCountSize = tradeItemWrapper:getGraphSize()
  self._minPricePosY = 9999
  self._maxPricePosY = -9999
  self._minPricePosX = -1
  self._maxPricePosX = -1
  local drawPos = tradeItemWrapper:getGraphPosAt(0)
  if nil == drawPos then
    return
  end
  self._minPricePosX = self._graphIntervalValue
  self._maxPricePosX = self._graphIntervalValue
  graph_Panel:ClearGraphList()
  graph_Panel:setGraphBasePos(intervalPosY)
  graph_Panel:SetGraphMode(true)
  for count = 1, priceCountSize do
    drawPos = tradeItemWrapper:getGraphPosAt(count - 1)
    if 100 < drawPos.y then
      drawPos.y = 100
    end
    if drawPos.y < -100 then
      drawPos.y = -100
    end
    if 0 < drawPos.y then
      variablePrice = upperPrice - originalPrice
    else
      variablePrice = originalPrice - underprice
    end
    drawPos.x = self._graphIntervalValue * count
    local yPos = drawPos.y * intervalPosY / 100
    local pricePercent = drawPos.y
    drawPos.y = PaGlobal_TradeMarketGraph_CalculateY(intervalPosY, yPos)
    graph_Panel:AddGraphPos(drawPos)
    if self._maxPricePosY <= drawPos.y then
      self._maxPriceTable[itemIdx] = originalPrice + variablePrice * pricePercent / 100
      self._maxPricePosX = drawPos.x
      self._maxPricePosY = drawPos.y
    end
    if self._minPricePosY > drawPos.y then
      self._minPricePosX = drawPos.x
      self._minPricePosY = drawPos.y
      self._minPriceTable[itemIdx] = originalPrice + variablePrice * pricePercent / 100
    end
  end
  graph_Panel:interpolationGraph()
  graph_BaseLine:SetPosX(graph_Panel:GetPosX())
  graph_BaseLine:SetPosY(graph_Panel:GetPosY() + graph_Panel:GetSizeY() / 2)
  graph_BaseLine:SetShow(true)
  graph_CurrentPoint:SetPosX(graph_Panel:GetPosX() + drawPos.x - graph_CurrentPoint:GetSizeX() / 2)
  graph_CurrentPoint:SetPosY(graph_Panel:GetPosY() + drawPos.y - graph_CurrentPoint:GetSizeX() / 2)
  graph_CurrentPoint:SetShow(tradeItemWrapper:isTradableItem())
  graph_LowestPoint:SetShow(false)
  graph_HighestPoint:SetShow(false)
  if priceCountSize > 2 then
    if drawPos.y ~= self._minPricePosY then
      local graphPosY = graph_Panel:getinterpolationGraphValue(self._minPricePosX)
      self._minPricePosX = graph_Panel:GetPosX() + self._minPricePosX - graph_LowestPoint:GetSizeX() / 2
      graph_LowestPoint:SetPosX(self._minPricePosX)
      graph_LowestPoint:SetPosY(graph_Panel:GetPosY() + graphPosY - graph_LowestPoint:GetSizeY() / 2)
      graph_LowestPoint:SetShow(true)
    else
      self._minPriceTable[itemIdx] = -1
    end
    if drawPos.y ~= self._maxPricePosY then
      local graphPosY = graph_Panel:getinterpolationGraphValue(self._maxPricePosX)
      self._maxPricePosX = graph_Panel:GetPosX() + self._maxPricePosX - graph_HighestPoint:GetSizeX() / 2
      graph_HighestPoint:SetPosX(self._maxPricePosX)
      graph_HighestPoint:SetPosY(graph_Panel:GetPosY() + graphPosY - graph_HighestPoint:GetSizeY() / 2)
      graph_HighestPoint:SetShow(true)
    else
      self._maxPriceTable[itemIdx] = -1
    end
  else
    self._maxPriceTable[itemIdx] = -1
    self._maxPriceTable[itemIdx] = -1
  end
  stc_Bg:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
  stc_Bg:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobal_TradeMarketGraph_ToggleItemDetailDesc(" .. itemIdx .. ")")
  if 1 == self._currentNPCType and Int64toInt32(buyableStack) > 0 then
    stc_Bg:registerPadEvent(__eConsoleUIPadEvent_Up_A, "InputMLUp_TradeMarketGraph_BasketItem(" .. itemIdx .. ")")
  end
  stc_Bg:addInputEvent("Mouse_On", "InputMO_TradeMarketGraph_SetKeyGuide(false)")
  stc_Bg:addInputEvent("Mouse_Out", "inputMOut_TradeMarketGraph_ItemDetailDescOff(false)")
end
function InputMO_TradeMarketGraph_SetKeyGuide(isSelectShow)
  local self = TradeMarketGraph
  if false == isSelectShow and 2 == self._currentNPCType then
    self._ui.txt_AConsole:SetShow(false)
  else
    self._ui.txt_AConsole:SetShow(true)
  end
end
function PaGlobal_TradeMarketGraph_CalculateY(src, dest)
  if src <= dest then
    dest = dest - src
  elseif src >= dest then
    dest = src - dest
  else
    dest = src
  end
  return dest
end
function PaGlobal_TradeMarketGraph_ShowCommerceType(commerceIdx)
  local self = TradeMarketGraph
  self._currentCommerceIdx = commerceIdx
  self:updateShopIndex()
  self:update()
end
function PaGlobal_TradeMarketGraph_CheckEmptyData(commerceType)
  local commerceItemSize = npcShop_getCommerceItemSize(commerceType)
  local uiCount = 0
  for idx = 1, commerceItemSize do
    local boolValue = npcShop_luaGetCommerceItemByIndexAndCheckSellOrBuy(commerceType, idx)
    if true == boolValue then
      uiCount = uiCount + 1
    end
  end
  return uiCount
end
function npcShop_luaGetCommerceItemByIndexAndCheckSellOrBuy(commerceType, index)
  local self = TradeMarketGraph
  local itemKey = npcShop_GetCommerceItemByIndex(commerceType, index - 1)
  local checkResult = false
  if 0 ~= itemKey then
    if 1 == self._currentNPCType then
      checkResult = npcShop_CheckBuyFromNPCItem(itemKey)
    elseif 2 == self._currentNPCType then
      checkResult = npcShop_CheckSellToNPCItem(itemKey)
    elseif 3 == self._currentNPCType then
      checkResult = true
    else
      UI.ASSERT(false, "\235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \234\176\146\236\158\133\235\139\136\235\139\164.")
    end
  end
  return checkResult
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_TradeMarketGraph_Init")

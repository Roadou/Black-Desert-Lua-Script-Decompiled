local _panel
local MarketPlacePriceList = {
  _ui = {},
  _currnetPrice = 0,
  _standPrice = 0,
  _totalSellCount = 0,
  _totalBuyCount = 0,
  _standardIndex = nil,
  _highestBuyBiddingPirce = 0,
  _lowestSellBiddingPrice = 0,
  _highestBuyBiddingIndex = 0,
  _lowestSellBiddingIndex = 0,
  _firstScrollIndex = 0,
  _selectindex = nil,
  _beforeindex = nil,
  _biddingMinPrice_s64 = 0,
  _biddingMaxPrice_s64 = 0
}
function MarketPlacePriceList:initialize()
  self:createControl()
end
function MarketPlacePriceList:createControl()
  self._ui._list2_SelectThing:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_MarketPlacePriceList_List2CreateControl")
  self._ui._list2_SelectThing:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._verticalScroll = UI.getChildControl(self._ui._list2_SelectThing, "List2_1_VerticalScroll")
end
function PaGlobal_MarketPlacePriceList_ChangePanel(isSell)
  local self = MarketPlacePriceList
  if true == isSell then
    _panel = Panel_Window_MarketPlace_SellManagement
  else
    _panel = Panel_Window_MarketPlace_BuyManagement
  end
  self._ui._list2_SelectThing = UI.getChildControl(_panel, "List2_ItemList")
  PaGlobalFunc_MarketPlacePriceList_Initialize()
end
function PaGlobal_MarketPlacePriceList_Cancel()
  if nil ~= _panel then
    _panel:SetShow(false)
  end
end
function PaGlobal_MarketPlacePriceList_GetShow()
  if nil ~= _panel then
    return _panel:GetShow()
  end
end
function PaGlobalFunc_MarketPlacePriceList_List2CreateControl(content, value)
  local self = MarketPlacePriceList
  local index = Int64toInt32(value)
  local button_UpPrice = UI.getChildControl(content, "Button_UpPrice")
  local button_DownPrice = UI.getChildControl(content, "Button_DownPrice")
  local Button_StandPrice = UI.getChildControl(content, "Button_StandPrice")
  local selectFocus = UI.getChildControl(content, "StaticText_Select")
  local txt_StandPrice = UI.getChildControl(content, "StaticText_Price")
  local stc_highestPriceIcon = UI.getChildControl(content, "Static_HighestPriceIcon")
  local stc_lowestPriceIcon = UI.getChildControl(content, "Static_LowestPriceIcon")
  local stc_leftIconPos = UI.getChildControl(content, "Static_LeftIconPos")
  local stc_rightIconPos = UI.getChildControl(content, "Static_RightIconPos")
  local biddingInfo = ToClient_GetBiddingInfoByIndex(index)
  local price_s64 = ToClient_GetBiddingPriceByIndex(index)
  local sellCount = Int64toInt32(biddingInfo:getSellCount())
  local buyCount = Int64toInt32(biddingInfo:getBuyCount())
  button_UpPrice:SetShow(false)
  button_DownPrice:SetShow(false)
  Button_StandPrice:SetShow(false)
  selectFocus:SetShow(false)
  stc_highestPriceIcon:SetShow(price_s64 == MarketPlacePriceList._biddingMaxPrice_s64)
  stc_lowestPriceIcon:SetShow(price_s64 == MarketPlacePriceList._biddingMinPrice_s64)
  if true == Panel_Window_MarketPlace_BuyManagement:GetShow() then
    button_UpPrice:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlaceBuy_SelectPriceByIndex(" .. index .. ")")
    button_DownPrice:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlaceBuy_SelectPriceByIndex(" .. index .. ")")
    Button_StandPrice:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlaceBuy_SelectPriceByIndex(" .. index .. ")")
    if true == PaGlobal_TutorialPhase_IsTutorial() then
      if price_s64 == self._currnetPrice then
        sellCount = 10
      else
        sellCount = 0
        buyCount = 0
      end
    end
  elseif true == Panel_Window_MarketPlace_SellManagement:GetShow() then
    button_UpPrice:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlaceSell_SelectPriceByIndex(" .. index .. ")")
    button_DownPrice:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlaceSell_SelectPriceByIndex(" .. index .. ")")
    Button_StandPrice:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlaceSell_SelectPriceByIndex(" .. index .. ")")
  end
  if nil ~= self._ui._selectindex and false == PaGlobal_TutorialPhase_IsTutorial() then
    PaGlobal_MarketPlaceSelectList_SetFocus(self._ui._selectindex)
  end
  button_UpPrice:SetText("")
  button_DownPrice:SetText("")
  txt_StandPrice:SetText(makeDotMoney(price_s64))
  if price_s64 == self._currnetPrice then
    if sellCount > 0 then
      button_UpPrice:SetShow(true)
      button_UpPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_BIDDINGCOUNT_SELL", "count", tostring(sellCount)))
    elseif buyCount > 0 then
      button_DownPrice:SetShow(true)
      button_DownPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_BIDDINGCOUNT_BUY", "count", tostring(buyCount)))
    else
      button_UpPrice:SetShow(true)
    end
  elseif price_s64 < self._currnetPrice then
    button_DownPrice:SetShow(true)
    if buyCount > 0 then
      button_DownPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_BIDDINGCOUNT_BUY", "count", tostring(buyCount)))
    end
  else
    button_UpPrice:SetShow(true)
    if sellCount > 0 then
      button_UpPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_BIDDINGCOUNT_SELL", "count", tostring(sellCount)))
    end
  end
  if 0 < button_UpPrice:GetTextSizeX() then
    local result = txt_StandPrice:GetTextSizeX() / 2 + button_UpPrice:GetTextSizeX() + 20
    if result > 152 then
      button_UpPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_BIDDINGCOUNT", "count", tostring(sellCount)))
    end
  end
  if 0 < button_DownPrice:GetTextSizeX() then
    local result = txt_StandPrice:GetTextSizeX() / 2 + button_DownPrice:GetTextSizeX() + 20
    if result > 152 then
      button_DownPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_BIDDINGCOUNT", "count", tostring(buyCount)))
    end
  end
  if sellCount > 0 then
    stc_lowestPriceIcon:SetSpanSize(stc_rightIconPos:GetSpanSize().x, stc_lowestPriceIcon:GetSpanSize().y)
    stc_highestPriceIcon:SetSpanSize(stc_rightIconPos:GetSpanSize().x, stc_highestPriceIcon:GetSpanSize().y)
  elseif buyCount > 0 then
    stc_lowestPriceIcon:SetSpanSize(stc_leftIconPos:GetSpanSize().x, stc_lowestPriceIcon:GetSpanSize().y)
    stc_highestPriceIcon:SetSpanSize(stc_leftIconPos:GetSpanSize().x, stc_highestPriceIcon:GetSpanSize().y)
  else
    stc_lowestPriceIcon:SetSpanSize(stc_leftIconPos:GetSpanSize().x, stc_lowestPriceIcon:GetSpanSize().y)
    stc_highestPriceIcon:SetSpanSize(stc_rightIconPos:GetSpanSize().x, stc_highestPriceIcon:GetSpanSize().y)
  end
  stc_lowestPriceIcon:ComputePos()
  stc_highestPriceIcon:ComputePos()
  if price_s64 <= self._standPrice then
    txt_StandPrice:SetFontColor(Defines.Color.C_FF96B8DF)
  else
    txt_StandPrice:SetFontColor(Defines.Color.C_FFFE475B)
  end
  if price_s64 == self._standPrice then
    txt_StandPrice:SetFontColor(Defines.Color.C_FFEEEEEE)
  end
end
function MarketPlacePriceList:setStartPrice()
  local size = ToClient_GetBiddingListSize()
  if 0 == self._totalSellCount and 0 == self._totalBuyCount then
    return self._standPrice
  end
  if 0 < self._totalSellCount then
    return self._lowestSellBiddingPrice
  end
  if 0 < self._totalBuyCount then
    return self._highestBuyBiddingPirce
  end
end
function PaGlobalFunc_MarketPlacePriceList_Initialize()
  MarketPlacePriceList:initialize()
end
function PaGlobalFunc_MarketPlacePriceList_Open(standardPrice_s64, minPrice, maxPrice, isSell)
  local self = MarketPlacePriceList
  Panel_NumberPad_Close()
  ClearFocusEdit()
  self._ui._selectindex = nil
  self._ui_beforeindex = nil
  self._biddingMinPrice_s64 = minPrice
  self._biddingMaxPrice_s64 = maxPrice
  self:clear()
  self._standPrice = standardPrice_s64
  self:updateList()
  local tradeControl
  if true == isSell then
    tradeControl = PaGlobalFunc_MarketPlaceSell_GetPanel()
  else
    tradeControl = PaGlobalFunc_MarketPlaceBuy_GetPanel()
  end
  PaGlobalFunc_MarketPlaceBuy_SetItemCount(self._totalSellCount)
end
function MarketPlacePriceList:clear()
  self._standardIndex = nil
  self._standPrice = 0
  self._ui._list2_SelectThing:getElementManager():clearKey()
  self._totalSellCount = 0
  self._totalBuyCount = 0
  self._highestBuyBiddingIndex = 0
  self._lowestSellBiddingIndex = 0
  self._highestBuyBiddingPirce = toInt64(0, 0)
  self._lowestSellBiddingPrice = toInt64(0, 0)
end
function MarketPlacePriceList:updateList()
  local size = ToClient_GetBiddingListSize()
  for ii = 0, size - 1 do
    local biddingInfo = ToClient_GetBiddingInfoByIndex(ii)
    local sellCount = Int64toInt32(biddingInfo:getSellCount())
    local buyCount = Int64toInt32(biddingInfo:getBuyCount())
    local price_s64 = ToClient_GetBiddingPriceByIndex(ii)
    self._totalSellCount = self._totalSellCount + sellCount
    self._totalBuyCount = self._totalBuyCount + buyCount
    if self._standPrice == price_s64 then
      self._standardIndex = ii
    end
    if sellCount > 0 and (price_s64 < self._lowestSellBiddingPrice or toInt64(0, 0) == self._lowestSellBiddingPrice) then
      self._lowestSellBiddingPrice = price_s64
      self._lowestSellBiddingIndex = ii
    end
    if buyCount > 0 and (price_s64 > self._highestBuyBiddingPirce or toInt64(0, 0) == self._highestBuyBiddingPirce) then
      self._highestBuyBiddingPirce = price_s64
      self._highestBuyBiddingIndex = ii
    end
  end
  self._currnetPrice = self:setStartPrice()
  for ii = 0, size - 1 do
    self._ui._list2_SelectThing:getElementManager():pushKey(ii)
  end
  if true == PaGlobal_TutorialPhase_IsTutorial() then
    PaGlobal_MarketPlaceSelectList_ListMoveIndex(0)
  end
end
function PaGlobalFunc_MarketPlacePriceList_SetDefaultIndex(isSell)
  local self = MarketPlacePriceList
  if nil == isSell then
    _PA_ASSERT(false, "isSell \236\157\184\236\158\144\235\138\148 \237\149\132\236\136\152 \236\158\133\235\139\136\235\139\164. !! : PaGlobal_MarketPlacePriceList_GetDefaultIndex()")
    return
  end
  local size = ToClient_GetBiddingListSize()
  if true == isSell then
    if toInt64(0, 0) < self._lowestSellBiddingPrice then
      self._lowestSellBiddingIndex = math.min(size - 1, self._lowestSellBiddingIndex + 1)
      PaGlobalFunc_MarketPlaceSell_SelectPriceByIndex(self._lowestSellBiddingIndex)
      self._firstScrollIndex = self._lowestSellBiddingIndex
      PaGlobal_MarketPlaceSelectList_SetFocus(self._firstScrollIndex)
    else
      PaGlobalFunc_MarketPlaceSell_SelectPriceByIndex(0)
      self._firstScrollIndex = 0
    end
  elseif toInt64(0, 0) < self._lowestSellBiddingPrice then
    PaGlobalFunc_MarketPlaceBuy_SelectPriceByIndex(self._lowestSellBiddingIndex)
    self._firstScrollIndex = self._lowestSellBiddingIndex
  elseif toInt64(0, 0) < self._highestBuyBiddingPirce then
    self._highestBuyBiddingIndex = math.max(0, self._highestBuyBiddingIndex - 1)
    PaGlobalFunc_MarketPlaceBuy_SelectPriceByIndex(self._highestBuyBiddingIndex)
    self._firstScrollIndex = self._highestBuyBiddingIndex
  else
    PaGlobalFunc_MarketPlaceBuy_SelectPriceByIndex(size - 1)
    self._firstScrollIndex = size - 1
  end
  if nil ~= self._standardIndex then
    self._firstScrollIndex = math.max(0, self._firstScrollIndex - 6)
    self._ui._list2_SelectThing:moveIndex(self._firstScrollIndex)
  end
  if true == PaGlobal_TutorialPhase_IsTutorial() then
    self._ui._list2_SelectThing:moveIndex(0)
  end
end
function PaGlobal_MarketPlaceSelectList_ListMoveIndex(index)
  local self = MarketPlacePriceList
  self._ui._list2_SelectThing:moveIndex(index)
end
function PaGlobal_MarketPlaceSelectList_SetFocus(index)
  local self = MarketPlacePriceList
  local controlSpecial = self._ui._list2_SelectThing
  local contentsSpecial = self._ui._list2_SelectThing:GetContentByKey(toInt64(0, index))
  if nil ~= self._ui._beforeindex then
    local beforecontentsSpecial = self._ui._list2_SelectThing:GetContentByKey(toInt64(0, self._ui._beforeindex))
    if nil ~= beforecontentsSpecial then
      local selectFocus = UI.getChildControl(beforecontentsSpecial, "StaticText_Select")
      selectFocus:SetShow(false)
    end
  end
  self._ui._beforeindex = index
  self._ui._selectindex = index
  if nil ~= contentsSpecial then
    local selectFocus = UI.getChildControl(contentsSpecial, "StaticText_Select")
    selectFocus:SetShow(true)
  end
end
function PaGlobal_MarketPlaceSelectList_StandardPriceIndex()
  return MarketPlacePriceList._standardIndex
end

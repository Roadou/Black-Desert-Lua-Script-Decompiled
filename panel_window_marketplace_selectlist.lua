local _panel = Panel_Window_MarketPlace_SelectList
_panel:ignorePadSnapMoveToOtherPanel()
local MarketPlaceSelectList = {
  _ui = {
    _button_WinClose = UI.getChildControl(_panel, "Button_Win_Close"),
    _txt_Title = UI.getChildControl(_panel, "StaticText_Title"),
    _list2_SelectThing = UI.getChildControl(_panel, "List2_ItemList")
  },
  _selectType = 0,
  _standardPrice_s64 = toInt64(0, 0)
}
function MarketPlaceSelectList:initialize()
  self:createControl()
end
function MarketPlaceSelectList:createControl()
  self._ui._txt_Title:SetText("")
  self._ui._list2_SelectThing:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_MarketPlaceSelectList_List2CreateControl")
  self._ui._list2_SelectThing:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._button_WinClose:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceSelectList_Cancel()")
end
function PaGlobal_MarketPlaceSelectList_Cancel()
  _panel:SetShow(false)
end
function PaGlobal_MarketPlaceSelectList_GetShow()
  return _panel:GetShow()
end
function MarketPlaceSelectList:setButtonActive(button, isShow, text, inputEvent)
  button:SetShow(isShow)
  if true == isShow then
    button:SetText(text)
    button:addInputEvent("Mouse_LUp", inputEvent)
  else
    button:removeInputEvent("Mouse_LUp")
  end
end
function PaGlobalFunc_MarketPlaceSelectList_List2CreateControl(content, value)
  local self = MarketPlaceSelectList
  local buttonBuy = UI.getChildControl(content, "Button_Buy")
  local buttonSell = UI.getChildControl(content, "Button_Sell")
  local buttonEnchantLevel = UI.getChildControl(content, "Button_Enchant")
  local txtAddPrice = UI.getChildControl(content, "StaticText_AddPrice")
  txtAddPrice:SetShow(false)
  if 0 == self._selectType then
    local index = Int64toInt32(value)
    local price_s64 = ToClient_getWorldMarketBuyBiddingLstPrice(index)
    if price_s64 > self._standardPrice_s64 then
      self:setButtonActive(buttonBuy, true, makeDotMoney(price_s64), "PaGlobalFunc_MarketPlaceBuy_SelectPriceByIndex(" .. index .. ")")
      self:setButtonActive(buttonSell, false)
      self:setButtonActive(buttonEnchantLevel, false)
    elseif price_s64 < self._standardPrice_s64 then
      self:setButtonActive(buttonBuy, false)
      self:setButtonActive(buttonSell, true, makeDotMoney(price_s64), "PaGlobalFunc_MarketPlaceBuy_SelectPriceByIndex(" .. index .. ")")
      self:setButtonActive(buttonEnchantLevel, false)
    else
      self:setButtonActive(buttonSell, false)
      self:setButtonActive(buttonBuy, false)
      self:setButtonActive(buttonEnchantLevel, true, makeDotMoney(price_s64), "PaGlobalFunc_MarketPlaceBuy_SelectPriceByIndex(" .. index .. ")")
    end
  elseif 1 == self._selectType then
    local index = Int64toInt32(value)
    local price_s64 = ToClient_getWorldMarketSellBiddingLstPrice(index)
    if price_s64 > self._standardPrice_s64 then
      self:setButtonActive(buttonBuy, true, makeDotMoney(price_s64), "PaGlobalFunc_MarketPlaceSell_SelectPriceByIndex(" .. index .. ")")
      self:setButtonActive(buttonSell, false)
      self:setButtonActive(buttonEnchantLevel, false)
    elseif price_s64 < self._standardPrice_s64 then
      self:setButtonActive(buttonBuy, false)
      self:setButtonActive(buttonSell, true, makeDotMoney(price_s64), "PaGlobalFunc_MarketPlaceSell_SelectPriceByIndex(" .. index .. ")")
      self:setButtonActive(buttonEnchantLevel, false)
    else
      self:setButtonActive(buttonSell, false)
      self:setButtonActive(buttonBuy, false)
      self:setButtonActive(buttonEnchantLevel, true, makeDotMoney(price_s64), "PaGlobalFunc_MarketPlaceSell_SelectPriceByIndex(" .. index .. ")")
    end
  elseif 2 == self._selectType then
    buttonBuy:SetShow(false)
    buttonSell:SetShow(false)
    buttonEnchantLevel:SetShow(true)
    local enchantLevel = Int64toInt32(value)
    buttonEnchantLevel:SetText("+" .. tostring(enchantLevel))
    buttonBuy:removeInputEvent("Mouse_LUp")
    buttonSell:removeInputEvent("Mouse_LUp")
    buttonEnchantLevel:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlaceBuy_SelectEnchantLevel(" .. enchantLevel .. ", true )")
  end
end
function PaGlobalFunc_MarketPlaceSelectList_Initialize()
  MarketPlaceSelectList:initialize()
end
function PaGlobalFunc_MarketPlaceSelectList_Open(selectListType, standardPrice_s64, startIndex, endIndex)
  if false == (selectListType >= 0 and selectListType < 3) then
    return
  end
  local self = MarketPlaceSelectList
  self._standardPrice_s64 = standardPrice_s64
  Panel_NumberPad_Close()
  ClearFocusEdit()
  self._selectType = selectListType
  local titleStr
  if 0 == selectListType then
    titleStr = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_SELECTLIST_TITLE_1")
  elseif 1 == selectListType then
    titleStr = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_SELECTLIST_TITLE_2")
  elseif 2 == selectListType then
    titleStr = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_SELECTLIST_TITLE_3")
  end
  self._ui._txt_Title:SetText(titleStr)
  self._ui._list2_SelectThing:getElementManager():clearKey()
  local standardIndex = 0
  for ii = startIndex, endIndex do
    self._ui._list2_SelectThing:getElementManager():pushKey(ii)
    if 0 == self._selectType then
      local index = Int64toInt32(ii)
      local price_s64 = ToClient_getWorldMarketBuyBiddingLstPrice(index)
      if standardPrice_s64 == price_s64 then
        standardIndex = ii
      end
    elseif 1 == self._selectType then
      local index = Int64toInt32(ii)
      local price_s64 = ToClient_getWorldMarketSellBiddingLstPrice(index)
      if standardPrice_s64 == price_s64 then
        standardIndex = ii
      end
    end
  end
  if 0 ~= standardIndex then
    self._ui._list2_SelectThing:moveIndex(standardIndex - 6)
  end
  _panel:SetShow(true)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_MarketPlaceSelectList_Initialize")

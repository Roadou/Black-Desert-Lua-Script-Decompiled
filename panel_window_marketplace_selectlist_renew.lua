local _panel = Panel_Window_MarketPlace_SelectList
_panel:ignorePadSnapMoveToOtherPanel()
local MarketPlaceSelectList = {
  _ui = {
    _txt_Title = UI.getChildControl(_panel, "StaticText_Title"),
    _list2_SelectThing = UI.getChildControl(_panel, "List2_ItemList"),
    _keyGuideBG = UI.getChildControl(_panel, "Static_KeyguideBG")
  },
  _selectType = 0,
  _standardPrice_s64 = toInt64(0, 0),
  _keyGuideAlign = {}
}
function MarketPlaceSelectList:initialize()
  self:createControl()
end
function MarketPlaceSelectList:createControl()
  self._ui._txt_Title:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txt_Title:SetText("")
  self._ui._list2_SelectThing:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_MarketPlaceSelectList_List2CreateControl")
  self._ui._list2_SelectThing:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.btnExit = UI.getChildControl(self._ui._keyGuideBG, "StaticText_B_ConsoleUI")
  self._ui.btnConfirm = UI.getChildControl(self._ui._keyGuideBG, "StaticText_A_ConsoleUI")
  self._keyGuideAlign = {
    self._ui.btnConfirm,
    self._ui.btnExit
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._keyGuideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
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
  content:SetSize(self._ui._list2_SelectThing:GetSizeX(), content:GetSizeY())
  local buttonBuy = UI.getChildControl(content, "Button_Buy")
  local buttonSell = UI.getChildControl(content, "Button_Sell")
  local buttonEnchantLevel = UI.getChildControl(content, "Button_Enchant")
  local txtSellCount = UI.getChildControl(content, "StaticText_SellingCount")
  local txtBuyCount = UI.getChildControl(content, "StaticText_BuyingCount")
  local index = Int64toInt32(value)
  local price_s64 = ToClient_GetBiddingPriceByIndex(index)
  if 0 == self._selectType then
    self:setButtonActive(buttonBuy, false)
    self:setButtonActive(buttonSell, true, makeDotMoney(price_s64), "PaGlobalFunc_MarketPlaceBuy_SelectPriceByIndex(" .. index .. ")")
    self:setButtonActive(buttonEnchantLevel, false)
  elseif 1 == self._selectType then
    self:setButtonActive(buttonBuy, true, makeDotMoney(price_s64), "PaGlobalFunc_MarketPlaceSell_SelectPriceByIndex(" .. index .. ")")
    self:setButtonActive(buttonSell, false)
    self:setButtonActive(buttonEnchantLevel, false)
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
  txtSellCount:SetShow(false)
  txtBuyCount:SetShow(false)
  if 0 == self._selectType or 1 == self._selectType then
    local biddingInfo = ToClient_GetBiddingInfoByIndex(index)
    local sellCount = Int64toInt32(biddingInfo:getSellCount())
    if sellCount > 0 then
      txtSellCount:SetShow(true)
      txtSellCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WINDOW_MARKETPLACE_TOTALTRADECOUNT_SUB", "count", tostring(sellCount)))
    end
    local buyCount = Int64toInt32(biddingInfo:getBuyCount())
    if buyCount > 0 then
      txtBuyCount:SetShow(true)
      txtBuyCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WINDOW_MARKETPLACE_TOTALTRADECOUNT_SUB", "count", tostring(buyCount)))
    end
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
  local titleStr, panelSizeX
  if 0 == selectListType then
    titleStr = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_SELECTLIST_TITLE_1")
    panelSizeX = 470
  elseif 1 == selectListType then
    titleStr = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_SELECTLIST_TITLE_2")
    panelSizeX = 470
  elseif 2 == selectListType then
    titleStr = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_SELECTLIST_TITLE_3")
    panelSizeX = 310
  end
  local priceTitle = UI.getChildControl(_panel, "Static_TitleBG")
  self._ui._list2_SelectThing:SetSize(panelSizeX - 20, self._ui._list2_SelectThing:GetSizeY())
  self._ui._txt_Title:SetSize(panelSizeX - 20, self._ui._txt_Title:GetSizeY())
  self._ui._txt_Title:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txt_Title:SetText(titleStr)
  if 2 == selectListType then
    self._ui._list2_SelectThing:SetPosY(40 + self._ui._txt_Title:GetTextSizeY())
    _panel:SetSize(panelSizeX, self._ui._list2_SelectThing:GetSizeY() + self._ui._txt_Title:GetTextSizeY() + 100)
    priceTitle:SetShow(false)
  else
    self._ui._list2_SelectThing:SetPosY(80 + self._ui._txt_Title:GetTextSizeY())
    _panel:SetSize(panelSizeX, self._ui._list2_SelectThing:GetSizeY() + self._ui._txt_Title:GetTextSizeY() + 140)
    priceTitle:SetShow(true)
    priceTitle:ComputePos()
  end
  _panel:ComputePos()
  self._ui._keyGuideBG:ComputePos()
  self._ui._list2_SelectThing:getElementManager():clearKey()
  for ii = startIndex, endIndex do
    self._ui._list2_SelectThing:getElementManager():pushKey(ii)
  end
  _panel:SetShow(true)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_MarketPlaceSelectList_Initialize")

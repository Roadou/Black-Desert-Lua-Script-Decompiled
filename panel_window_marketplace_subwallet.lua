local _panel = Panel_Window_MarketPlace_SubWallet
local MarketPlace_SubWallet = {
  _ui = {
    stc_Main = UI.getChildControl(_panel, "Static_Main"),
    btn_Close = UI.getChildControl(_panel, "Button_Win_Close")
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  _slotConfigWallet = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  _biddingTabIdx = {sell = 0, buy = 1},
  _selectedBiddingTabIndex = 0,
  _pearlItemLimitCount = {crurrent = 0, sellcount = 0},
  _prevItemIndex = 0
}
function PaGlobalFunc_SubWallet_Get()
  return MarketPlace_SubWallet
end
function PaGlobalFunc_SubWallet_Init()
  local self = MarketPlace_SubWallet
  self:initControl()
  self:initEvent()
end
function MarketPlace_SubWallet:initControl()
  self._ui.btn_Buy = UI.getChildControl(self._ui.stc_Main, "RadioButton_Buy")
  self._ui.btn_Sell = UI.getChildControl(self._ui.stc_Main, "RadioButton_Sell")
  self._ui.btn_Sell:SetCheck(true)
  self._ui.txt_BuyCount = UI.getChildControl(self._ui.stc_Main, "StaticText_BuyCount")
  self._ui.txt_SellCount = UI.getChildControl(self._ui.stc_Main, "StaticText_SellCount")
  self._ui.txt_ReserveTitle = UI.getChildControl(self._ui.stc_Main, "StaticText_ReserveTitle")
  self._ui.txt_ReserveValue = UI.getChildControl(self._ui.stc_Main, "StaticText_ReserveValue")
  self._ui.txt_CompleteTitle = UI.getChildControl(self._ui.stc_Main, "StaticText_CompleteTitle")
  self._ui.txt_CompleteValue = UI.getChildControl(self._ui.stc_Main, "StaticText_CompleteValue")
  self._ui.list2_BiddingItem = UI.getChildControl(self._ui.stc_Main, "List2_ItemMarket")
  local list2_Content = UI.getChildControl(self._ui.list2_BiddingItem, "List2_1_Content")
  local slot = {}
  local list2_ItemSlot = UI.getChildControl(list2_Content, "Template_Static_Slot")
  SlotItem.new(slot, "Wallet_ItemBiddingList", 0, list2_ItemSlot, self._slotConfigWallet)
  slot:createChild()
  slot = {}
end
function MarketPlace_SubWallet:initEvent()
  self._ui.list2_BiddingItem:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_MarketPlace_SubWallet_CreateControlMyBiddingList")
  self._ui.list2_BiddingItem:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.btn_Buy:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_SubWallet_OpenMyBuyTab()")
  self._ui.btn_Sell:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_SubWallet_OpenMySellTab()")
  self._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_SubWallet_Close()")
  registerEvent("FromClient_responseGetMyBiddingList", "FromClient_MarketPlace_SubWallet_responseGetMyBiddingList")
  registerEvent("FromClient_responseWithdrawBuyBidding", "FromClient_MarketPlace_SubWallet_responseWithdrawBuyBidding")
  registerEvent("FromClient_responseCalculateBuyBidding", "FromClient_MarketPlace_SubWallet_responseCalculateBuyBidding")
  registerEvent("FromClient_responseWithdrawSellBidding", "FromClient_MarketPlace_SubWallet_responseWithdrawSellBidding")
  registerEvent("FromClient_responseCalculateSellBidding", "FromClient_MarketPlace_SubWallet_responseCalculateSellBidding")
end
function PaGlobalFunc_MarketPlace_SubWallet_CreateControlMyBiddingList(contents, key)
  local self = MarketPlace_SubWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_SubWallet")
    return
  end
  local idx = Int64toInt32(key)
  local bg_ItemSlot = UI.getChildControl(contents, "Template_Static_Slot")
  local slot = {}
  SlotItem.reInclude(slot, "Wallet_ItemBiddingList", 0, bg_ItemSlot, self._slotConfig)
  slot.icon:EraseAllEffect()
  slot.icon:addInputEvent("Mouse_On", "")
  slot.icon:addInputEvent("Mouse_Out", "")
  local txt_ItemName = UI.getChildControl(contents, "Template_StaticText_ItemName")
  local txt_ItemPrice = UI.getChildControl(contents, "Template_StaticText_BasePriceValue")
  local txt_ItemCount = UI.getChildControl(contents, "Template_StaticText_Count")
  local btn_Calculate = UI.getChildControl(contents, "Template_Button_Recieve")
  local btn_Withdraw = UI.getChildControl(contents, "Template_Button_Cancel")
  local txt_RegisterTitle, txt_RegisterCount, txt_CompleteTitle, txt_CompleteCount
  if self._selectedBiddingTabIndex == self._biddingTabIdx.sell then
    local itemInfo = getWorldMarketSellBiddingListByIdx(idx)
    if nil == itemInfo then
      _PA_ASSERT(false, "\236\160\149\235\179\180\234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : getWorldMarketSellBiddingListByIdx( idx )")
      return
    end
    local itemSSW = itemInfo:getItemEnchantStaticStatusWrapper()
    local enchantLevel = itemSSW:get()._key:getEnchantLevel()
    local chooseEnchantLevel = itemInfo:getChooseEnchantLevel()
    local nameColorGrade = itemSSW:getGradeType()
    local pricePerOne = itemInfo:getPricePerOne()
    local addEnchantPrice = itemInfo:getAddEnchantPrice()
    local leftCount = itemInfo:getLeftCount()
    local sellNo = itemInfo:getSellNo()
    local soldCount = itemInfo:getSoldCount()
    local isSealed = itemInfo:isSealed()
    slot:setItemByStaticStatus(itemSSW, 0, -1, false, itemSSW:get():isCash(), false, 0, 0, nil, true, isSealed)
    slot.isEmpty = false
    local nameColor = PaGlobalFunc_MarketPlace_SetNameColor(nameColorGrade)
    txt_ItemName:SetFontColor(nameColor)
    local itemNameStr = PaGlobalFunc_MarketPlace_setNameAndEnchantLevel(chooseEnchantLevel, itemSSW:getItemType(), itemSSW:getName(), itemSSW:getItemClassify())
    txt_ItemName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    txt_ItemName:SetText(itemNameStr)
    txt_ItemPrice:SetText(makeDotMoney(pricePerOne + addEnchantPrice))
    txt_ItemCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_REGIST_COUNT") .. " : " .. tostring(leftCount + soldCount) .. " / " .. PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_SELL_COMPLETE") .. " : " .. tostring(soldCount))
    btn_Calculate:addInputEvent("Mouse_LUp", "PaGlobal_SubWallet_SellBidding_Calculate(" .. idx .. ")")
    btn_Withdraw:addInputEvent("Mouse_LUp", "PaGlobal_SubWallet_SellBidding_WithdrawSetCount(" .. idx .. ")")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_SubWallet_BiddingListSlotToolTip(" .. idx .. "," .. self._biddingTabIdx.sell .. ")")
    slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    btn_Calculate:SetShow(Int64toInt32(soldCount) > 0)
    btn_Withdraw:SetShow(0 == Int64toInt32(soldCount))
  elseif self._selectedBiddingTabIndex == self._biddingTabIdx.buy then
    local itemInfo = getWorldMarketBuyBiddingListByIdx(idx)
    if nil == itemInfo then
      _PA_ASSERT(false, "\236\160\149\235\179\180\234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : getWorldMarketBuyBiddingListByIdx( idx )")
      return
    end
    local itemSSW = itemInfo:getItemEnchantStaticStatusWrapper()
    local enchantLevel = itemSSW:get()._key:getEnchantLevel()
    local chooseEnchantLevel = itemInfo:getChooseEnchantLevel()
    local nameColorGrade = itemSSW:getGradeType()
    local pricePerOne = itemInfo:getPricePerOne()
    local leftCount = itemInfo:getLeftCount()
    local buyNo = itemInfo:getBuyNo()
    local boughtCount = itemInfo:getBoughtCount()
    local registerMoneyCount = itemInfo:getRegisterMoneyCount()
    slot:setItemByStaticStatus(itemSSW, 0, -1, false, nil, false, 0, 0, nil, true)
    slot.isEmpty = false
    local nameColor = PaGlobalFunc_MarketPlace_SetNameColor(nameColorGrade)
    txt_ItemName:SetFontColor(nameColor)
    local itemNameStr = PaGlobalFunc_MarketPlace_setNameAndEnchantLevel(chooseEnchantLevel, itemSSW:getItemType(), itemSSW:getName(), itemSSW:getItemClassify())
    txt_ItemName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    txt_ItemName:SetText(itemNameStr)
    txt_ItemPrice:SetText(makeDotMoney(registerMoneyCount))
    txt_ItemCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_BUYBIDDING_COUNT") .. " : " .. tostring(leftCount + boughtCount) .. " / " .. PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_BUY_COMPLATE") .. " : " .. tostring(boughtCount))
    btn_Calculate:addInputEvent("Mouse_LUp", "PaGlobal_SubWallet_BuyBidding_Calculate(" .. idx .. ")")
    btn_Withdraw:addInputEvent("Mouse_LUp", "PaGlobal_SubWallet_BuyBidding_WithdrawSetCount(" .. idx .. ")")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_SubWallet_BiddingListSlotToolTip(" .. idx .. "," .. self._biddingTabIdx.buy .. ")")
    slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    btn_Calculate:SetShow(Int64toInt32(boughtCount) > 0)
    btn_Withdraw:SetShow(0 == Int64toInt32(boughtCount))
  end
end
function MarketPlace_SubWallet:updateMyInfo()
  local silverInfo = getWorldMarketSilverInfo()
  PaGlobalFunc_ItemMarket_UpdateMyInfo()
  PaGlobalFunc_MarketPlace_WalletInventoryMoney(silverInfo)
end
function MarketPlace_SubWallet:updateWallet()
  local boughtCount, boughtLeftCount = self:getBoughtBiddingCount()
  local soldCount, soldLeftCount = self:getSoldBiddingCount()
  self._ui.txt_BuyCount:SetText(boughtCount)
  self._ui.txt_BuyCount:SetShow(boughtCount > 0)
  self._ui.txt_SellCount:SetText(soldCount)
  self._ui.txt_SellCount:SetShow(soldCount > 0)
end
function PaGlobalFunc_MarketPlace_SubWallet_BiddingListSlotToolTip(idx, biddingType)
  local self = MarketPlace_SubWallet
  local itemMyWalletInfo
  if self._biddingTabIdx.sell == biddingType then
    itemMyWalletInfo = getWorldMarketSellBiddingListByIdx(idx)
  elseif self._biddingTabIdx.buy == biddingType then
    itemMyWalletInfo = getWorldMarketBuyBiddingListByIdx(idx)
  end
  local itemWrapper = itemMyWalletInfo:getItemEnchantStaticStatusWrapper()
  local content = self._ui.list2_BiddingItem:GetContentByKey(idx)
  local slot = UI.getChildControl(content, "Template_Static_Slot")
  if nil == itemWrapper then
    return
  end
  if nil == slot then
    return
  end
  PaGlobalFunc_MarketPlace_ShowToolTip(itemWrapper, slot, false)
end
function MarketPlace_SubWallet:getSoldBiddingCount()
  local itemListCount = getWorldMarketSellBiddingListCount()
  local soldCount = 0
  local leftCount = 0
  for idx = 0, itemListCount - 1 do
    local itemInfo = getWorldMarketSellBiddingListByIdx(idx)
    if nil == itemInfo then
      _PA_ASSERT(false, "\236\160\149\235\179\180\234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : getWorldMarketSellBiddingListByIdx( idx )")
      return
    end
    soldCount = soldCount + Int64toInt32(itemInfo:getSoldCount())
    leftCount = leftCount + Int64toInt32(itemInfo:getLeftCount())
  end
  return soldCount, leftCount
end
function MarketPlace_SubWallet:getBoughtBiddingCount()
  local itemListCount = getWorldMarketBuyBiddingListCount()
  local boughtCount = 0
  local leftCount = 0
  for idx = 0, itemListCount - 1 do
    local itemInfo = getWorldMarketBuyBiddingListByIdx(idx)
    if nil == itemInfo then
      _PA_ASSERT(false, "\236\160\149\235\179\180\234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : getWorldMarketBuyBiddingListByIdx( idx )")
      return
    end
    boughtCount = boughtCount + Int64toInt32(itemInfo:getBoughtCount())
    leftCount = leftCount + Int64toInt32(itemInfo:getLeftCount())
  end
  return boughtCount, leftCount
end
function MarketPlace_SubWallet:updateBiddingItemList()
  local itemListCount = 0
  self._ui.list2_BiddingItem:getElementManager():clearKey()
  self._ui.btn_Buy:SetCheck(false)
  self._ui.btn_Sell:SetCheck(false)
  if self._selectedBiddingTabIndex == self._biddingTabIdx.sell then
    itemListCount = getWorldMarketSellBiddingListCount()
    local soldCount, leftCount = self:getSoldBiddingCount()
    self._ui.btn_Sell:SetCheck(true)
    self._ui.txt_ReserveTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_SELL_WAIT"))
    self._ui.txt_ReserveValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_VALUE_COUNT", "count", leftCount))
    self._ui.txt_CompleteTitle:SetText("  /  " .. PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_SELL_COMPLATE"))
    self._ui.txt_CompleteValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_VALUE_COUNT", "count", soldCount))
    self._ui.btn_Buy:SetFontColor(Defines.Color.C_FF9397A7)
    self._ui.btn_Sell:SetFontColor(Defines.Color.C_FFFFFFFF)
  elseif self._selectedBiddingTabIndex == self._biddingTabIdx.buy then
    itemListCount = getWorldMarketBuyBiddingListCount()
    local boughtCount, leftCount = self:getBoughtBiddingCount()
    self._ui.btn_Buy:SetCheck(true)
    self._ui.txt_ReserveTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_BUY_WAIT"))
    self._ui.txt_ReserveValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_VALUE_COUNT", "count", leftCount))
    self._ui.txt_CompleteTitle:SetText("  /  " .. PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_BUY_COMPLATE"))
    self._ui.txt_CompleteValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_VALUE_COUNT", "count", boughtCount))
    self._ui.btn_Buy:SetFontColor(Defines.Color.C_FFFFFFFF)
    self._ui.btn_Sell:SetFontColor(Defines.Color.C_FF9397A7)
  end
  if nil ~= self._ui.txt_ReserveValue and nil ~= self._ui.txt_CompleteValue then
    self._ui.txt_ReserveValue:SetPosX(self._ui.txt_ReserveTitle:GetPosX() + self._ui.txt_ReserveTitle:GetTextSizeX() + 10)
    self._ui.txt_CompleteTitle:SetPosX(self._ui.txt_ReserveValue:GetPosX() + self._ui.txt_ReserveValue:GetTextSizeX())
    self._ui.txt_CompleteValue:SetPosX(self._ui.txt_CompleteTitle:GetPosX() + self._ui.txt_CompleteTitle:GetTextSizeX() + 10)
  end
  if itemListCount > 0 then
    self._ui.list2_BiddingItem:SetShow(true)
  else
    self._ui.list2_BiddingItem:SetShow(false)
  end
  for idx = 0, itemListCount - 1 do
    self._ui.list2_BiddingItem:getElementManager():pushKey(toInt64(0, idx))
  end
  self._ui.list2_BiddingItem:requestUpdateVisible()
end
function MarketPlace_SubWallet:setOpenPanel()
  local marketMainPanel = PaGlobalFunc_Marketplace_GetPanel()
  local scrSizeX = getScreenSizeX()
  _panel:SetPosX(marketMainPanel:GetPosX() + marketMainPanel:GetSizeX() / 4)
  _panel:SetPosY(marketMainPanel:GetPosY() + marketMainPanel:GetSizeY() / 5)
end
function PaGlobalFunc_MarketPlace_SubWallet_OpenMySellTab()
  local self = MarketPlace_SubWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_SubWallet")
    return
  end
  ToClient_requestMyBiddingListByWorldMarket()
  self:biddingOpen(self._biddingTabIdx.sell)
end
function PaGlobalFunc_MarketPlace_SubWallet_OpenMyBuyTab()
  local self = MarketPlace_SubWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_SubWallet")
    return
  end
  ToClient_requestMyBiddingListByWorldMarket()
  self:biddingOpen(self._biddingTabIdx.buy)
end
function InputMLUp_MarketPlace_SubWallet_TabToggle()
  local self = MarketPlace_SubWallet
  if nil == self then
    return
  end
  if false == _panel:GetShow() then
    PaGlobalFunc_SubWallet_Open()
  else
    PaGlobalFunc_SubWallet_Close()
  end
end
function FromClient_MarketPlace_SubWallet_responseGetMyBiddingList()
  local self = MarketPlace_SubWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_SubWallet")
    return
  end
  self:biddingOpen(self._selectedBiddingTabIndex)
  self:updateWallet()
  self:updateMyInfo()
end
function FromClient_MarketPlace_SubWallet_responseCalculateBuyBidding()
  local self = MarketPlace_SubWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_SubWallet")
    return
  end
  self:biddingOpen(self._biddingTabIdx.buy)
  self:updateWallet()
  self:updateMyInfo()
  self._ui.list2_BiddingItem:moveIndex(self._prevItemIndex)
  self._prevItemIndex = 0
end
function FromClient_MarketPlace_SubWallet_responseWithdrawBuyBidding()
  local self = MarketPlace_SubWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_SubWallet")
    return
  end
  self:biddingOpen(self._biddingTabIdx.buy)
  self:updateWallet()
  self:updateMyInfo()
  self._ui.list2_BiddingItem:moveIndex(self._prevItemIndex)
  self._prevItemIndex = 0
end
function FromClient_MarketPlace_SubWallet_responseCalculateSellBidding()
  local self = MarketPlace_SubWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_SubWallet")
    return
  end
  self:biddingOpen(self._biddingTabIdx.sell)
  self:updateWallet()
  self:updateMyInfo()
  self._ui.list2_BiddingItem:moveIndex(self._prevItemIndex)
  self._prevItemIndex = 0
end
function FromClient_MarketPlace_SubWallet_responseWithdrawSellBidding()
  local self = MarketPlace_SubWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_SubWallet")
    return
  end
  self:biddingOpen(self._biddingTabIdx.sell)
  self:updateWallet()
  self:updateMyInfo()
  self._ui.list2_BiddingItem:moveIndex(self._prevItemIndex)
  self._prevItemIndex = 0
end
function MarketPlace_SubWallet:biddingOpen(tabIdx)
  local self = MarketPlace_SubWallet
  if nil == self then
    return
  end
  self._selectedBiddingTabIndex = tabIdx
  self:updateBiddingItemList()
end
function Paglobal_SubWallet_UpdateBiddingList()
  local self = MarketPlace_SubWallet
  if nil == self then
    return
  end
  if self._selectedBiddingTabIndex == self._biddingTabIdx.buy then
    PaGlobalFunc_MarketPlace_SubWallet_OpenMyBuyTab()
  elseif self._selectedBiddingTabIndex == self._biddingTabIdx.sell then
    PaGlobalFunc_MarketPlace_SubWallet_OpenMySellTab()
  end
end
function PaGlobal_SubWallet_SellBidding_Calculate(idx)
  local self = MarketPlace_SubWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_SubWallet")
    return
  end
  self._prevItemIndex = self._ui.list2_BiddingItem:getCurrenttoIndex()
  local UI_BUFFTYPE = CppEnums.UserChargeType
  local itemInfo = getWorldMarketSellBiddingListByIdx(idx)
  local itemSSW = itemInfo:getItemEnchantStaticStatusWrapper()
  if nil == itemSSW then
    return
  end
  local isPremiumUser = false
  if true == getSelfPlayer():get():isApplyChargeSkill(UI_BUFFTYPE.eUserChargeType_PremiumPackage) then
    isPremiumUser = true
  end
  local isCountryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_SELL_PCROOM_MEMO", "forPremium", requestGetRefundPercentForPremiumPackage())
  local function calculateExcute()
    ToClient_requestCalculateSellBiddingToWorldMarket(itemInfo:getSellNo())
  end
  if false == isPremiumUser and false == itemSSW:get():isCash() then
    FromClient_ValuePackageIcon()
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
    local messageBoxMemo = isCountryTypeSet
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = calculateExcute,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "middle")
  else
    calculateExcute()
  end
end
function PaGlobal_SubWallet_SellBidding_WithdrawSetCount(idx)
  local self = MarketPlace_SubWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_SubWallet")
    return
  end
  self._prevItemIndex = self._ui.list2_BiddingItem:getCurrenttoIndex()
  local itemInfo = getWorldMarketSellBiddingListByIdx(idx)
  local leftCount = itemInfo:getLeftCount()
  local sellNo = itemInfo:getSellNo()
  Panel_NumberPad_Show(true, leftCount, sellNo, PaGlobal_SubWallet_SellBidding_Withdraw)
end
function PaGlobal_SubWallet_SellBidding_Withdraw(inputNumber, sellNo)
  ToClient_requestWithdrawSellBiddingToWorldMarket(sellNo, inputNumber)
end
function PaGlobal_SubWallet_BuyBidding_Calculate(idx)
  local self = MarketPlace_SubWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_SubWallet")
    return
  end
  self._prevItemIndex = self._ui.list2_BiddingItem:getCurrenttoIndex()
  local itemInfo = getWorldMarketBuyBiddingListByIdx(idx)
  local leftCount = itemInfo:getLeftCount()
  local buyNo = itemInfo:getBuyNo()
  ToClient_requestCalculateBuyBiddingToWorldMarket(buyNo)
end
function PaGlobal_SubWallet_BuyBidding_WithdrawSetCount(idx)
  local self = MarketPlace_SubWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_SubWallet")
    return
  end
  self._prevItemIndex = self._ui.list2_BiddingItem:getCurrenttoIndex()
  FromClient_ValuePackageIcon()
  local itemInfo = getWorldMarketBuyBiddingListByIdx(idx)
  local leftCount = itemInfo:getLeftCount()
  local buyNo = itemInfo:getBuyNo()
  Panel_NumberPad_Show(true, leftCount, buyNo, PaGlobal_SubWallet_BuyBidding_Withdraw)
end
function PaGlobal_SubWallet_BuyBidding_Withdraw(inputNumber, buyNo)
  ToClient_requestWithdrawBuyBiddingToWorldMarket(buyNo, inputNumber)
end
function PaGlobalFunc_SubWallet_Open()
  local self = MarketPlace_SubWallet
  PaGlobalFunc_MarketPlace_SubWallet_OpenMyBuyTab()
  self:setOpenPanel()
  self:open()
end
function PaGlobalFunc_SubWallet_Close()
  local self = MarketPlace_SubWallet
  TooltipSimple_Hide()
  self:close()
end
function PaGlobalFunc_SubWallet_IsShow()
  return _panel:GetShow()
end
function MarketPlace_SubWallet:open()
  _panel:SetShow(true)
end
function MarketPlace_SubWallet:close()
  _panel:SetShow(false)
end

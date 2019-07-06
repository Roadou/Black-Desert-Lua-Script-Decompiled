local _panel = Panel_Window_MarketPlace_Main
local _mainBg = UI.getChildControl(_panel, "Static_Wallet")
local UI_color = Defines.Color
local MarketPlace_Wallet = {
  _ui = {
    stc_LeftBg = UI.getChildControl(_mainBg, "Static_LeftBg"),
    list2_History = UI.getChildControl(_mainBg, "List2_History"),
    stc_Main = UI.getChildControl(_mainBg, "Static_Main"),
    txt_NoSerchResult = nil
  },
  _config = {
    slotCount = 50,
    slotCols = 5,
    slotRows = 0,
    slotStartX = 0,
    slotStartY = 0,
    slotGapX = 47,
    slotGapY = 47,
    maxItem = __eTMarketPlaceWalletInventorySlotNoMax
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
  _viewType = {slot = 1, list = 0},
  _selectedBiddingTabIndex = 0,
  _selectedViewType = 1,
  _startInvenSlotIndex = 0,
  _currentSlotNo = 0,
  _currentSlotIdx = 0,
  _prevItemIdx = -1,
  _pearlItemLimitCount = {crurrent = 0, sellcount = 0},
  _prevScrollIndex = 0
}
function PaGlobalFunc_Wallet_Get()
  return MarketPlace_Wallet
end
function PaGlobalFunc_Wallet_Init()
  local self = MarketPlace_Wallet
  self:initData()
  self:initControl()
  self:initEvent()
end
function MarketPlace_Wallet:initControl()
  self._ui.stc_WalletStatBg = UI.getChildControl(self._ui.stc_LeftBg, "Static_WalletStatBg")
  self._ui.txt_MarketMoneyValue = UI.getChildControl(self._ui.stc_WalletStatBg, "StaticText_MarketInvenValue")
  self._ui.txt_MarketWeightValue = UI.getChildControl(self._ui.stc_WalletStatBg, "StaticText_MarketWeightValue")
  self._ui.txt_MarketTaxBonus = UI.getChildControl(self._ui.stc_WalletStatBg, "StaticText_TaxBonus")
  self._ui.stc_ItemListBg = UI.getChildControl(self._ui.stc_LeftBg, "Static_ItemListBg")
  self._ui.btn_List = UI.getChildControl(self._ui.stc_ItemListBg, "RadioButton_List")
  self._ui.btn_Slot = UI.getChildControl(self._ui.stc_ItemListBg, "RadioButton_Slot")
  self._ui.stc_blockBG = UI.getChildControl(self._ui.stc_ItemListBg, "Static_BlockBG")
  self._ui.btn_goToRegistItem = UI.getChildControl(self._ui.stc_blockBG, "Button_Go_To_RegistItem")
  self._ui.txt_registItemDesc = UI.getChildControl(self._ui.stc_blockBG, "StaticText_Desc")
  self._ui.txt_registItemDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_registItemDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_WALLET_BLOCKBG_DESC"))
  self._ui.stc_ItemSlotBg = UI.getChildControl(self._ui.stc_ItemListBg, "Static_ItmeSlotBg")
  self._ui.template_ItemSlot = UI.getChildControl(self._ui.stc_ItemSlotBg, "Static_ItemBg_Template")
  self._ui.scroll_ItemSlot = UI.getChildControl(self._ui.stc_ItemSlotBg, "Scroll_ItemSlot")
  self._ui.list2_WalletItem = UI.getChildControl(self._ui.stc_ItemListBg, "List2_ItemList")
  self._ui.btn_Buy = UI.getChildControl(self._ui.stc_Main, "RadioButton_Buy")
  self._ui.btn_Sell = UI.getChildControl(self._ui.stc_Main, "RadioButton_Sell")
  self._ui.txt_BuyCount = UI.getChildControl(self._ui.stc_Main, "StaticText_BuyCount")
  self._ui.txt_SellCount = UI.getChildControl(self._ui.stc_Main, "StaticText_SellCount")
  self._ui.btn_RecieveAll = UI.getChildControl(self._ui.stc_Main, "Button_RecieveAll")
  self._ui.txt_ReserveTitle = UI.getChildControl(self._ui.stc_Main, "StaticText_ReserveTitle")
  self._ui.txt_ReserveValue = UI.getChildControl(self._ui.stc_Main, "StaticText_ReserveValue")
  self._ui.txt_CompleteTitle = UI.getChildControl(self._ui.stc_Main, "StaticText_CompleteTitle")
  self._ui.txt_CompleteValue = UI.getChildControl(self._ui.stc_Main, "StaticText_CompleteValue")
  self._ui.list2_BiddingItem = UI.getChildControl(self._ui.stc_Main, "List2_ItemMarket")
  self._ui.txt_NoSerchResult = UI.getChildControl(_panel, "StaticText_NoSearchResult")
  self._ui.stc_pearlItemLimitCount = UI.getChildControl(self._ui.stc_LeftBg, "Static_PearlItemLimitCount")
  self._ui.stc_helpDesc = UI.getChildControl(self._ui.stc_pearlItemLimitCount, "Static_Help_PearlItemLimitCount")
  self._ui.template_ItemSlot:SetShow(false)
  local list2_Content = UI.getChildControl(self._ui.list2_BiddingItem, "List2_1_Content")
  local slot = {}
  local list2_ItemSlot = UI.getChildControl(list2_Content, "Template_Static_Slot")
  SlotItem.new(slot, "Wallet_ItemBiddingList", 0, list2_ItemSlot, self._slotConfigWallet)
  slot:createChild()
  list2_Content = UI.getChildControl(self._ui.list2_WalletItem, "List2_1_Content")
  slot = {}
  list2_ItemSlot = UI.getChildControl(list2_Content, "Static_ItemSlotBg")
  SlotItem.new(slot, "Wallet_InvenItemList", 0, list2_ItemSlot, self._slotConfigWallet)
  slot:createChild()
  self._config.slotStartX = self._ui.template_ItemSlot:GetPosX()
  self._config.slotStartY = self._ui.template_ItemSlot:GetPosY()
  self._config.slotCount = self._config.slotCount - self:itemListType()
  self._slot = Array.new()
  for ii = 0, self._config.slotCount - 1 do
    local slot = {}
    slot.background = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_ItemSlotBg, "ItemSlotBg_" .. ii)
    CopyBaseProperty(self._ui.template_ItemSlot, slot.background)
    slot.background:SetPosX(self._config.slotStartX + math.floor(ii % self._config.slotCols) * self._config.slotGapX)
    slot.background:SetPosY(self._config.slotStartY + math.floor(ii / self._config.slotCols) * self._config.slotGapY)
    slot.background:SetShow(true)
    SlotItem.new(slot, "ItemSlot_" .. ii, ii, slot.background, self._slotConfigWallet)
    slot:createChild()
    slot.icon:SetShow(true)
    slot.icon:SetEnableArea(0, 0, slot.icon:GetSizeX() - 10, slot.icon:GetSizeY() - 10)
    UIScroll.InputEventByControl(slot.icon, "PaGlobalFunc_MarketPlace_Wallet_Scroll")
    self._slot[ii] = slot
  end
end
function MarketPlace_Wallet:itemListType()
  if false == isGameTypeTR() and false == isGameTypeEnglish() then
    return 0
  end
  PaGlobalFunc_Wallet_UpdatePearlItemLimitCount()
  self._ui.stc_listMainBG = UI.getChildControl(self._ui.stc_ItemListBg, "Static_ListMainBG")
  self._ui.stc_helpDesc:addInputEvent("Mouse_On", "MarketWallet_ListType_TooltipShow(true, 2)")
  self._ui.stc_helpDesc:addInputEvent("Mouse_Out", "MarketWallet_ListType_TooltipShow(false)")
  self._ui.stc_pearlItemLimitCount:SetShow(true)
  local removeSizeY = 45
  local removeSlotCount = 5
  local changeSizeControlList = {
    self._ui.stc_ItemListBg,
    self._ui.stc_listMainBG,
    self._ui.stc_ItemSlotBg,
    self._ui.list2_WalletItem,
    self._ui.scroll_ItemSlot,
    self._ui.stc_blockBG
  }
  for i = 1, #changeSizeControlList do
    changeSizeControlList[i]:SetSize(changeSizeControlList[i]:GetSizeX(), changeSizeControlList[i]:GetSizeY() - removeSizeY)
  end
  self._ui.stc_ItemListBg:ComputePos()
  return removeSlotCount
end
function PaGlobalFunc_Wallet_UpdatePearlItemLimitCount()
  if false == isGameTypeTR() and false == isGameTypeEnglish() then
    return
  end
  local self = MarketPlace_Wallet
  local GetMaxPearlLimitedCount = ToClient_GetMaxPearlLimitedCount() + ToClient_GetAddPearlLimitedCount()
  local currentCount = ToClient_GetCurrentPearlLimitedCount()
  self._ui.txt_LimitDesc = UI.getChildControl(self._ui.stc_pearlItemLimitCount, "StaticText_LimitDesc")
  self._ui.txt_LimitCount = UI.getChildControl(self._ui.stc_pearlItemLimitCount, "StaticText_LimitCount")
  self._ui.txt_LimitDesc:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui.txt_LimitDesc:SetText(self._ui.txt_LimitDesc:GetText())
  self._ui.txt_LimitCount:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MARKETPLACE_PEARLITEMLIMIT_COUNT", "COUNT", currentCount, "TOTAL", GetMaxPearlLimitedCount))
  if true == self._ui.txt_LimitDesc:IsLimitText() then
    self._ui.txt_LimitDesc:addInputEvent("Mouse_On", "MarketWallet_ListType_TooltipShow(true, 3)")
    self._ui.txt_LimitDesc:addInputEvent("Mouse_Out", "MarketWallet_ListType_TooltipShow(false)")
  end
  self._pearlItemLimitCount.crurrent = currentCount
end
function MarketPlace_Wallet:initEvent()
  UIScroll.InputEvent(self._ui.scroll_ItemSlot, "PaGlobalFunc_MarketPlace_Wallet_Scroll")
  UIScroll.InputEventByControl(self._ui.stc_ItemSlotBg, "PaGlobalFunc_MarketPlace_Wallet_Scroll")
  self._ui.list2_BiddingItem:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_MarketPlace_Wallet_CreateControlMyBiddingList")
  self._ui.list2_BiddingItem:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.list2_WalletItem:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_MarketPlace_Wallet_CreateControlWalletItemList")
  self._ui.list2_WalletItem:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.list2_History:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_MarketPlace_Wallet_CreateControlHistroyList")
  self._ui.list2_History:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.btn_Buy:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_Wallet_OpenMyBuyTab()")
  self._ui.btn_Sell:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_Wallet_OpenMySellTab()")
  self._ui.btn_RecieveAll:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlcae_Wallet_RecieveAll()")
  self._ui.btn_Slot:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_Wallet_SelectView(1)")
  self._ui.btn_List:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_Wallet_SelectView(0)")
  self._ui.btn_List:addInputEvent("Mouse_On", "MarketWallet_ListType_TooltipShow(true, 0)")
  self._ui.btn_List:addInputEvent("Mouse_Out", "MarketWallet_ListType_TooltipShow(false)")
  self._ui.btn_Slot:addInputEvent("Mouse_On", "MarketWallet_ListType_TooltipShow(true, 1)")
  self._ui.btn_Slot:addInputEvent("Mouse_Out", "MarketWallet_ListType_TooltipShow(false)")
  self._ui.txt_MarketTaxBonus:addInputEvent("Mouse_On", "PaGlobal_MarketPlace_Wallet_TaxTooltip(true)")
  self._ui.txt_MarketTaxBonus:addInputEvent("Mouse_Out", "PaGlobal_MarketPlace_Wallet_TaxTooltip(false)")
  registerEvent("FromClient_responseGetMyBiddingList", "FromClient_MarketPlace_Wallet_responseGetMyBiddingList")
  registerEvent("FromClient_responseWithdrawBuyBidding", "FromClient_MarketPlace_Wallet_responseWithdrawBuyBidding")
  registerEvent("FromClient_responseCalculateBuyBidding", "FromClient_MarketPlace_Wallet_responseCalculateBuyBidding")
  registerEvent("FromClient_responseWithdrawSellBidding", "FromClient_MarketPlace_Wallet_responseWithdrawSellBidding")
  registerEvent("FromClient_responseCalculateSellBidding", "FromClient_MarketPlace_Wallet_responseCalculateSellBidding")
  registerEvent("FromClient_noticeMyBiddingList", "FromClient_MarketPlace_Wallet_noticeMyBiddingList")
end
function MarketPlace_Wallet:initData()
  self._config.slotRows = self._config.slotCount / self._config.slotCols
  self._maxSlotRow = math.floor((self._config.slotCount - 1) / self._config.slotCols)
end
function MarketWallet_ListType_TooltipShow(isShow, isType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local self = MarketPlace_Wallet
  local name, desc, control
  if 0 == isType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_TOOLTIP_LISTTYPE_LIST_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_TOOLTIP_LISTTYPE_LIST_DESC")
    control = self._ui.btn_List
  elseif 1 == isType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_TOOLTIP_LISTTYPE_SLOT_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_TOOLTIP_LISTTYPE_SLOT_DESC")
    control = self._ui.btn_Slot
  elseif 2 == isType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_PEARLITEMLIMIT_DESC")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_PEARLITEMLIMIT_DESC")
    control = self._ui.stc_helpDesc
  elseif 3 == isType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_PEARLITEMLIMIT_DESC")
    desc = ""
    control = self._ui.stc_helpDesc
  end
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_MarketPlace_Wallet_TaxTooltip(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TAXBONUS_TOOLTIPS_NAME")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TAXBONUS_TOOLTIPS_DESC")
  control = MarketPlace_Wallet._ui.txt_MarketTaxBonus
  TooltipSimple_Show(control, name, desc)
end
function PaGlobalFunc_MarketPlace_Wallet_Scroll(isUp)
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  local prevSlotIndex = self._startInvenSlotIndex
  self._startInvenSlotIndex = UIScroll.ScrollEvent(self._ui.scroll_ItemSlot, isUp, self._config.slotRows, self._config.maxItem, self._startInvenSlotIndex, self._config.slotCols)
  if prevSlotIndex == 0 and self._startInvenSlotIndex == 0 then
    return
  end
  ToClient_padSnapIgnoreGroupMove()
  Panel_Tooltip_Item_hideTooltip()
  self:updateWallet()
end
function PaGlobalFunc_MarketPlace_Wallet_CreateControlHistroyList(contents, key)
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_Wallet")
    return
  end
  local idx = Int64toInt32(key)
  local txt_Date = UI.getChildControl(contents, "StaticText_Date")
  local txt_Content = UI.getChildControl(contents, "StaticText_Content")
  local history = ToClient_getWorldMarketHistoryByIndex(idx)
  local historyType = ToClient_getWorldMarketHistoryTypeByIndex(idx)
  txt_Content:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  txt_Content:SetFontColor(self:setHistoryColor(historyType))
  local len = string.len(history)
  local numStart, numEnd = string.find(history, "%d+.%d+.%d+ %d+:%d+")
  local date = string.sub(history, numStart, numEnd)
  local content = string.sub(history, numEnd + 1, len)
  txt_Date:SetText(date)
  txt_Content:SetText(content)
  txt_Content:addInputEvent("Mouse_On", "")
  txt_Content:addInputEvent("Mouse_Out", "")
  if true == txt_Content:IsLimitText() then
    txt_Content:SetIgnore(false)
    txt_Content:addInputEvent("Mouse_On", "PaGlobalFunc_Wallet_HistoryToolTipShow(" .. idx .. ")")
    txt_Content:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  end
end
function MarketPlace_Wallet:setHistoryColor(historyType)
  local color = Defines.Color.C_FFEEEEEE
  if historyType == __eWorldMarket_HistoryType_Buy then
    color = Defines.Color.C_FF96D4FC
  elseif historyType == __eWorldMarket_HistoryType_BuyBidding then
    color = Defines.Color.C_FF96D4FC
  elseif historyType == __eWorldMarket_HistoryType_BuyBiddingFail then
  elseif historyType == __eWorldMarket_HistoryType_BuyBiddingCal then
  elseif historyType == __eWorldMarket_HistoryType_BuyBiddingWithdraw then
  elseif historyType == __eWorldMarket_HistoryType_Sell then
    color = Defines.Color.C_FFF26A6A
  elseif historyType == __eWorldMarket_HistoryType_SellBidding then
    color = Defines.Color.C_FFF26A6A
  elseif historyType == __eWorldMarket_HistoryType_SellBiddingFail then
  elseif historyType == __eWorldMarket_HistoryType_SellBiddingCal then
  elseif historyType == __eWorldMarket_HistoryType_SellBiddingWithdarw then
  else
    if historyType == __eWorldMarket_HistoryType_Count then
    else
    end
  end
  return color
end
function PaGlobalFunc_Wallet_HistoryToolTipShow(idx)
  local self = MarketPlace_Wallet
  local content = self._ui.list2_History:GetContentByKey(idx)
  if nil == content then
    return
  end
  local txt_Content = UI.getChildControl(content, "StaticText_Content")
  if nil == txt_Content then
    return
  end
  TooltipSimple_Show(txt_Content, "", txt_Content:GetText())
end
function PaGlobalFunc_MarketPlace_Wallet_CreateControlWalletItemList(contents, key)
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_Wallet")
    return
  end
  local idx = Int64toInt32(key)
  local btn_Slot = UI.getChildControl(contents, "Button_ItemSlot")
  local stc_ItemSlotBg = UI.getChildControl(contents, "Static_ItemSlotBg")
  local txt_Name = UI.getChildControl(contents, "StaticText_ItemName")
  txt_Name:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  local slot = {}
  SlotItem.reInclude(slot, "Wallet_InvenItemList", 0, stc_ItemSlotBg, self._slotConfigWallet)
  slot.icon:EraseAllEffect()
  slot.icon:addInputEvent("Mouse_On", "")
  slot.icon:addInputEvent("Mouse_Out", "")
  btn_Slot:addInputEvent("Mouse_On", "")
  btn_Slot:addInputEvent("Mouse_Out", "")
  local itemMyWalletInfo, itemWrapper
  if true == PaGlobal_TutorialPhase_IsTutorial() then
    itemWrapper = PaGlobal_TutorialPhase_MarketPlace_GetItemSSW()
  else
    itemMyWalletInfo = getWorldMarketMyWalletListByIdx(idx)
    itemWrapper = itemMyWalletInfo:getItemEnchantStaticStatusWrapper()
  end
  if nil ~= itemWrapper then
    local itemCount, isSealed
    if true == PaGlobal_TutorialPhase_IsTutorial() then
      itemCount = 1
      isSealed = false
    else
      itemCount = itemMyWalletInfo:getItemCount()
      isSealed = itemMyWalletInfo:isSealed()
    end
    slot:clearItem()
    slot:setItemByStaticStatus(itemWrapper, itemCount, -1, false, nil, false, 0, 0, nil, true, isSealed)
    btn_Slot:addInputEvent("Mouse_LUp", "PaGlobalFunc_Wallet_SellItem(" .. idx .. ")")
    btn_Slot:addInputEvent("Mouse_RUp", "PaGlobalFunc_Wallet_SellItem(" .. idx .. ")")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_Wallet_WalletListSlotToolTip(" .. idx .. ")")
    slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    local nameColorGrade = itemWrapper:getGradeType()
    local nameColor = PaGlobalFunc_MarketPlace_SetNameColor(nameColorGrade)
    txt_Name:SetFontColor(nameColor)
    local itemNameStr = PaGlobalFunc_MarketPlace_setNameAndEnchantLevel(itemWrapper:get()._key:getEnchantLevel(), itemWrapper:getItemType(), itemWrapper:getName(), itemWrapper:getItemClassify())
    txt_Name:SetText(itemNameStr)
    if true == txt_Name:IsLimitText() then
      btn_Slot:addInputEvent("Mouse_On", "PaGlobalFunc_Wallet_WalletListTextToolTipShow(" .. idx .. ")")
      btn_Slot:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
      btn_Slot:setTooltipEventRegistFunc("PaGlobalFunc_Wallet_WalletListTextToolTipShow(" .. idx .. ")")
    end
  end
end
function PaGlobalFunc_Wallet_WalletListTextToolTipShow(idx)
  local self = MarketPlace_Wallet
  local content = self._ui.list2_WalletItem:GetContentByKey(idx)
  if nil == content then
    return
  end
  local txt_Content = UI.getChildControl(content, "StaticText_ItemName")
  TooltipSimple_Show(txt_Content, txt_Content:GetText())
end
function PaGlobalFunc_MarketPlace_Wallet_CreateControlMyBiddingList(contents, key)
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_Wallet")
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
    btn_Calculate:addInputEvent("Mouse_LUp", "PaGlobal_SellBidding_Calculate(" .. idx .. ")")
    btn_Withdraw:addInputEvent("Mouse_LUp", "PaGlobal_SellBidding_WithdrawSetCount(" .. idx .. ")")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_Wallet_BiddingListSlotToolTip(" .. idx .. "," .. self._biddingTabIdx.sell .. ")")
    slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    btn_Calculate:SetShow(Int64toInt32(soldCount) > 0)
    btn_Withdraw:SetShow(0 == Int64toInt32(soldCount))
  elseif self._selectedBiddingTabIndex == self._biddingTabIdx.buy then
    local itemInfo = getWorldMarketBuyBiddingListByIdx(idx)
    if nil == itemInfo and false == PaGlobal_TutorialPhase_IsTutorial() then
      _PA_ASSERT(false, "\236\160\149\235\179\180\234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : getWorldMarketBuyBiddingListByIdx( idx )")
      return
    end
    local itemSSW, enchantLevel, chooseEnchantLevel, nameColorGrade, pricePerOne, leftCount, buyNo, boughtCount, registerMoneyCount
    if true == PaGlobal_TutorialPhase_IsTutorial() and nil ~= PaGlobal_TutorialPhase_MarketPlace_GetItemSSW() then
      itemInfo = PaGlobal_Tutorial_GetItemInfo()
      itemSSW = PaGlobal_TutorialPhase_MarketPlace_GetItemSSW()
      nameColorGrade = itemSSW:getGradeType()
      chooseEnchantLevel = 0
      leftCount = 1
      boughtCount = 0
      registerMoneyCount = itemInfo:getStandPrice()
    else
      itemSSW = itemInfo:getItemEnchantStaticStatusWrapper()
      enchantLevel = itemSSW:get()._key:getEnchantLevel()
      chooseEnchantLevel = itemInfo:getChooseEnchantLevel()
      nameColorGrade = itemSSW:getGradeType()
      pricePerOne = itemInfo:getPricePerOne()
      leftCount = itemInfo:getLeftCount()
      buyNo = itemInfo:getBuyNo()
      boughtCount = itemInfo:getBoughtCount()
      registerMoneyCount = itemInfo:getRegisterMoneyCount()
    end
    slot:setItemByStaticStatus(itemSSW, 0, -1, false, nil, false, 0, 0, nil, true)
    slot.isEmpty = false
    local nameColor = PaGlobalFunc_MarketPlace_SetNameColor(nameColorGrade)
    txt_ItemName:SetFontColor(nameColor)
    local itemNameStr = PaGlobalFunc_MarketPlace_setNameAndEnchantLevel(chooseEnchantLevel, itemSSW:getItemType(), itemSSW:getName(), itemSSW:getItemClassify())
    txt_ItemName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    txt_ItemName:SetText(itemNameStr)
    txt_ItemPrice:SetText(makeDotMoney(registerMoneyCount))
    txt_ItemCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_BUYBIDDING_COUNT") .. " : " .. tostring(leftCount + boughtCount) .. " / " .. PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLET_BUY_COMPLATE") .. " : " .. tostring(boughtCount))
    btn_Calculate:addInputEvent("Mouse_LUp", "PaGlobal_BuyBidding_Calculate(" .. idx .. ")")
    btn_Withdraw:addInputEvent("Mouse_LUp", "PaGlobal_BuyBidding_WithdrawSetCount(" .. idx .. ")")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_Wallet_BiddingListSlotToolTip(" .. idx .. "," .. self._biddingTabIdx.buy .. ")")
    slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    btn_Calculate:SetShow(Int64toInt32(boughtCount) > 0)
    btn_Withdraw:SetShow(0 == Int64toInt32(boughtCount))
  end
end
function PaGlobalFunc_Wallet_UpdateMyInfo()
  local self = MarketPlace_Wallet
  self:updateMyInfo()
end
function MarketPlace_Wallet:updateMyInfo()
  if nil == getSelfPlayer() then
    return
  end
  local battleFP = getSelfPlayer():get():getBattleFamilyPoint()
  local lifeFP = getSelfPlayer():get():getLifeFamilyPoint()
  local etcFP = getSelfPlayer():get():getEtcFamilyPoint()
  local isTotalFamilyPoint = battleFP + lifeFP + etcFP
  local isTaxBonus = 0
  local currentWeight = getWorldMarketCurrentWeight()
  local maxWeight = getWorldMarketMaxWeight()
  local silverInfo = getWorldMarketSilverInfo()
  local _const = Defines.s64_const
  local s64_allWeight_div = toInt64(0, currentWeight)
  local s64_maxWeight_div = toInt64(0, maxWeight)
  local str_AllWeight = string.format("%.1f", Int64toInt32(s64_allWeight_div) / 10)
  local str_MaxWeight = string.format("%.0f", Int64toInt32(s64_maxWeight_div) / 10)
  self._ui.txt_MarketMoneyValue:SetText(makeDotMoney(silverInfo:getItemCount()))
  self._ui.txt_MarketWeightValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_VOLUME_VT_PARAM_NONCOLOR", "Weight", str_AllWeight .. " / " .. str_MaxWeight))
  local player = getSelfPlayer():get()
  local premium = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_PremiumPackage)
  local applyPremium = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_PremiumPackage)
  if isTotalFamilyPoint >= 1000 and isTotalFamilyPoint <= 3999 then
    isTaxBonus = 0.5
  elseif isTotalFamilyPoint >= 4000 and isTotalFamilyPoint <= 6999 then
    isTaxBonus = 1
  elseif isTotalFamilyPoint >= 7000 then
    isTaxBonus = 1.5
  end
  if true == applyPremium then
    isTaxBonus = isTaxBonus + 30
  end
  self._ui.txt_MarketTaxBonus:SetText(tostring(isTaxBonus) .. "%")
  self._ui.txt_MarketTaxBonus:SetEnableArea(0, 0, self._ui.txt_MarketTaxBonus:GetSizeX() + self._ui.txt_MarketTaxBonus:GetTextSizeX() + 10, 25)
  PaGlobalFunc_MarketPlace_WalletInventoryMoney(silverInfo)
end
function MarketPlace_Wallet:updateWallet()
  if self._viewType.slot == self._selectedViewType then
    self:updateWallet_Slot()
  elseif self._viewType.list == self._selectedViewType then
    self:updateWallet_List()
  end
  local boughtCount, boughtLeftCount = self:getBoughtBiddingCount()
  local soldCount, soldLeftCount = self:getSoldBiddingCount()
  self._ui.txt_BuyCount:SetText(boughtCount)
  self._ui.txt_BuyCount:SetShow(boughtCount > 0)
  self._ui.txt_SellCount:SetText(soldCount)
  self._ui.txt_SellCount:SetShow(soldCount > 0)
  if -1 ~= self._prevItemIdx then
    self._ui.list2_BiddingItem:moveIndex(self._prevItemIdx)
  end
end
function MarketPlace_Wallet:updateWallet_Slot()
  local walletItemCount = getWorldMarketMyWalletListCount()
  local slotNoList = Array.new()
  slotNoList:fill(0, self._config.maxItem)
  MarketPlace_Wallet:EmptyWalletShow()
  for slotIdx = 0, self._config.slotCount - 1 do
    local slot = self._slot[slotIdx]
    local slotNo = slotIdx + self._startInvenSlotIndex
    slot:clearItem()
    slot.slotNo = slotNo
    slot.icon:EraseAllEffect()
    slot.icon:addInputEvent("Mouse_RUp", "")
    slot.icon:addInputEvent("Mouse_LUp", "")
    slot.icon:addInputEvent("Mouse_On", "")
    slot.icon:addInputEvent("Mouse_Out", "")
    if walletItemCount > slotNo then
      local itemMyWalletInfo = getWorldMarketMyWalletListByIdx(slotNo)
      local itemWrapper = itemMyWalletInfo:getItemEnchantStaticStatusWrapper()
      if nil ~= itemWrapper then
        slot:setItemByStaticStatus(itemWrapper, itemMyWalletInfo:getItemCount(), -1, false, nil, false, 0, 0, nil, true, itemMyWalletInfo:isSealed())
        slot.icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_Wallet_SellItem(" .. slotNo .. ")")
        slot.icon:addInputEvent("Mouse_RUp", "PaGlobalFunc_Wallet_SellItem(" .. slotNo .. ")")
        slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_Wallet_ShowToolTip(" .. slotNo .. "," .. slotIdx .. ")")
        slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
      end
    end
  end
  UIScroll.SetButtonSize(self._ui.scroll_ItemSlot, self._config.slotCount, self._config.maxItem)
end
function PaGlobalFunc_MarketPlace_Wallet_BiddingListSlotToolTip(idx, biddingType)
  local self = MarketPlace_Wallet
  local itemMyWalletInfo
  if self._biddingTabIdx.sell == biddingType then
    itemMyWalletInfo = getWorldMarketSellBiddingListByIdx(idx)
  elseif self._biddingTabIdx.buy == biddingType then
    itemMyWalletInfo = getWorldMarketBuyBiddingListByIdx(idx)
  end
  if nil == itemMyWalletInfo then
    return
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
function PaGlobalFunc_MarketPlace_Wallet_WalletListSlotToolTip(idx)
  local self = MarketPlace_Wallet
  local itemMyWalletInfo = getWorldMarketMyWalletListByIdx(idx)
  local itemWrapper = itemMyWalletInfo:getItemEnchantStaticStatusWrapper()
  local content = self._ui.list2_WalletItem:GetContentByKey(idx)
  local slot = UI.getChildControl(content, "Static_ItemSlotBg")
  if nil == itemWrapper then
    return
  end
  if nil == slot then
    return
  end
  PaGlobalFunc_MarketPlace_ShowToolTip(itemWrapper, slot, false)
end
function PaGlobalFunc_MarketPlace_Wallet_ShowToolTip(slotNo, slotIdx)
  local self = MarketPlace_Wallet
  local itemMyWalletInfo = getWorldMarketMyWalletListByIdx(slotNo)
  local itemWrapper = itemMyWalletInfo:getItemEnchantStaticStatusWrapper()
  local slot = self._slot[slotIdx]
  if nil == itemWrapper then
    return
  end
  if nil == slot then
    return
  end
  PaGlobalFunc_MarketPlace_ShowToolTip(itemWrapper, slot.icon, false)
end
function MarketPlace_Wallet:updateWallet_List()
  if true == PaGlobal_TutorialPhase_IsTutorial() then
    return
  end
  local walletItemCount = getWorldMarketMyWalletListCount()
  MarketPlace_Wallet:EmptyWalletShow()
  self._prevScrollIndex = self._ui.list2_WalletItem:getCurrenttoIndex()
  self._ui.list2_WalletItem:getElementManager():clearKey()
  local size = math.min(walletItemCount, self._config.maxItem)
  for index = 0, size - 1 do
    self._ui.list2_WalletItem:getElementManager():pushKey(toInt64(0, index))
  end
  self._ui.list2_WalletItem:requestUpdateVisible()
  self._ui.list2_WalletItem:moveIndex(self._prevScrollIndex)
end
function PaGlobalFunc_Wallet_SellItem(slotIndex)
  FromClient_ValuePackageIcon()
  local itemMyWalletInfo = getWorldMarketMyWalletListByIdx(slotIndex)
  if nil ~= itemMyWalletInfo then
    ToClient_requestDetailOneItemByWorldMarket(itemMyWalletInfo:getEnchantKey(), itemMyWalletInfo:isSealed())
  end
end
function MarketPlace_Wallet:EmptyWalletShow()
  local walletItemCount = getWorldMarketMyWalletListCount()
  if nil ~= PaGlobal_TutorialPhase_MarketPlace and true == PaGlobal_TutorialPhase_IsTutorial() then
    walletItemCount = 1
  end
  if walletItemCount > 0 then
    self._ui.stc_blockBG:SetShow(false)
    self._ui.btn_goToRegistItem:SetShow(false)
    self._ui.btn_goToRegistItem:addInputEvent("Mouse_LUp", "")
    self._ui.stc_blockBG:addInputEvent("Mouse_LUp", "")
  else
    self._ui.stc_blockBG:SetShow(true)
    self._ui.btn_goToRegistItem:SetShow(true)
    self._ui.btn_goToRegistItem:addInputEvent("Mouse_LUp", "InputMLUp_MarketPlace_WalletOpen()")
    self._ui.stc_blockBG:addInputEvent("Mouse_LUp", "InputMLUp_MarketPlace_WalletOpen()")
  end
  self._ui.stc_blockBG:SetAlpha(0.9)
end
function PaGlobalFunc_Wallet_Update()
  local self = MarketPlace_Wallet
  self:updateWallet()
  self:updateHistory()
  self:updateMyInfo()
  self:biddingOpen(self._selectedBiddingTabIndex)
end
function MarketPlace_Wallet:getSoldBiddingCount()
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
function MarketPlace_Wallet:getBoughtBiddingCount()
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
function MarketPlace_Wallet:updateBiddingItemList()
  local itemListCount = 0
  self._ui.list2_BiddingItem:getElementManager():clearKey()
  self._ui.btn_Buy:SetCheck(false)
  self._ui.btn_Sell:SetCheck(false)
  if self._selectedBiddingTabIndex == self._biddingTabIdx.sell then
    itemListCount = getWorldMarketSellBiddingListCount()
    local soldCount, leftCount = self:getSoldBiddingCount()
    self._ui.btn_RecieveAll:SetShow(soldCount > 0)
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
    if true == PaGlobal_TutorialPhase_IsTutorial() then
      itemListCount = 1
      boughtCount = 0
      leftCount = 1
    end
    self._ui.btn_RecieveAll:SetShow(boughtCount > 0)
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
  if -1 ~= self._prevItemIdx then
    self._ui.list2_BiddingItem:moveIndex(self._prevItemIdx)
  end
end
function PaGlobalFunc_MarketPlace_Wallet_SelectView(viewType)
  local self = MarketPlace_Wallet
  self._selectedViewType = viewType
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMarketPlaceSlotType, viewType, CppEnums.VariableStorageType.eVariableStorageType_User)
  self._ui.stc_ItemSlotBg:SetShow(self._viewType.slot == self._selectedViewType)
  self._ui.list2_WalletItem:SetShow(self._viewType.list == self._selectedViewType)
  self._ui.btn_Slot:SetCheck(self._viewType.slot == self._selectedViewType)
  self._ui.btn_List:SetCheck(self._viewType.list == self._selectedViewType)
  self._startInvenSlotIndex = 0
  self._ui.scroll_ItemSlot:SetControlPos(0)
  self:updateWallet()
end
function MarketPlace_Wallet:updateHistory()
  local historyCount = ToClient_getWorldMarketHistorySize()
  self._ui.list2_History:getElementManager():clearKey()
  for index = historyCount - 1, 0, -1 do
    self._ui.list2_History:getElementManager():pushKey(toInt64(0, index))
  end
  self._ui.list2_History:requestUpdateVisible()
end
function PaGlobalFunc_MarketPlace_Wallet_OpenMySellTab()
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  ToClient_CalculateAllMyBiddingCancel()
  ToClient_requestMyBiddingListByWorldMarket()
  self:updateHistory()
  self:biddingOpen(self._biddingTabIdx.sell)
end
function PaGlobalFunc_MarketPlace_Wallet_OpenMyBuyTab()
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  ToClient_CalculateAllMyBiddingCancel()
  ToClient_requestMyBiddingListByWorldMarket()
  self:updateHistory()
  self:biddingOpen(self._biddingTabIdx.buy)
end
local toggle = true
function PaGlobalFunc_MarketPlace_Wallet_TabToggle()
  local self = MarketPlace_Wallet
  if true == toggle then
    PaGlobalFunc_MarketPlace_Wallet_OpenMyBuyTab()
  else
    PaGlobalFunc_MarketPlace_Wallet_OpenMySellTab()
  end
  toggle = not toggle
  _AudioPostEvent_SystemUiForXBOX(51, 7)
end
function PaGlobalFunc_MarketPlcae_Wallet_RecieveAll()
  if nil == getSelfPlayer() then
    return
  end
  local self = MarketPlace_Wallet
  local isBuy = self._ui.btn_Buy:IsCheck()
  local UI_BUFFTYPE = CppEnums.UserChargeType
  local isPremiumUser = false
  if true == getSelfPlayer():get():isApplyChargeSkill(UI_BUFFTYPE.eUserChargeType_PremiumPackage) then
    isPremiumUser = true
  end
  local function recieveAll()
    ToClient_CalculateAllMyBidding(isBuy)
  end
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
  local messageBoxMemo
  if true == isBuy then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_RECIEVEALL_BUY")
  elseif false == isPremiumUser then
    messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_SELL_PCROOM_MEMO2", "forPremium", requestGetRefundPercentForPremiumPackage())
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_RECIEVEALL_SELL")
  end
  local messageBoxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = recieveAll,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData, "middle")
end
function FromClient_MarketPlace_Wallet_noticeMyBiddingList(itemEnchantKey, noticeType)
  local itemStaticStatus = getItemEnchantStaticStatus(ItemEnchantKey(itemEnchantKey))
  if nil == itemStaticStatus then
    return
  end
  local itemNameStr = PaGlobalFunc_MarketPlace_setNameAndEnchantLevel(itemStaticStatus:get()._key:getEnchantLevel(), itemStaticStatus:getItemType(), itemStaticStatus:getName(), itemStaticStatus:getItemClassify())
  local str
  if 0 == noticeType then
    str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_NOTICE_SUCCESS_SELLBIDDING", "itemName", itemNameStr)
  elseif 1 == noticeType then
    str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_NOTICE_SUCCESS_BUYBIDDING", "itemName", itemNameStr)
  else
    return
  end
  PaGlobalFunc_Widget_Alert_Check_MarketPlaceMyBiddingUpdate(str)
end
function FromClient_MarketPlace_Wallet_responseGetMyBiddingList()
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_Wallet")
    return
  end
  self:biddingOpen(self._selectedBiddingTabIndex)
  self:updateWallet()
  self:updateHistory()
  self:updateMyInfo()
end
function FromClient_MarketPlace_Wallet_responseCalculateBuyBidding()
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_Wallet")
    return
  end
  self:biddingOpen(self._biddingTabIdx.buy)
  self:updateWallet()
  self:updateHistory()
  self:updateMyInfo()
end
function FromClient_MarketPlace_Wallet_responseWithdrawBuyBidding()
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_Wallet")
    return
  end
  self:biddingOpen(self._biddingTabIdx.buy)
  self:updateWallet()
  self:updateHistory()
  self:updateMyInfo()
end
function FromClient_MarketPlace_Wallet_responseCalculateSellBidding()
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_Wallet")
    return
  end
  ToClient_requestMyWalletList()
  self:biddingOpen(self._biddingTabIdx.sell)
  self:updateWallet()
  self:updateHistory()
  self:updateMyInfo()
end
function FromClient_MarketPlace_Wallet_responseWithdrawSellBidding()
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace_Wallet")
    return
  end
  ToClient_requestMyWalletList()
  self:biddingOpen(self._biddingTabIdx.sell)
  self:updateWallet()
  self:updateHistory()
  self:updateMyInfo()
end
function MarketPlace_Wallet:biddingOpen(tabIdx)
  local self = MarketPlace_Wallet
  self._selectedBiddingTabIndex = tabIdx
  self:updateBiddingItemList()
end
function PaGlobal_SellBidding_Calculate(idx)
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  local UI_BUFFTYPE = CppEnums.UserChargeType
  local itemInfo = getWorldMarketSellBiddingListByIdx(idx)
  local itemSSW = itemInfo:getItemEnchantStaticStatusWrapper()
  if nil == itemSSW then
    return
  end
  self._prevItemIdx = idx
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
function PaGlobal_SellBidding_WithdrawSetCount(idx)
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self._prevItemIdx = idx
  local itemInfo = getWorldMarketSellBiddingListByIdx(idx)
  local leftCount = itemInfo:getLeftCount()
  local sellNo = itemInfo:getSellNo()
  Panel_NumberPad_Show(true, leftCount, sellNo, PaGlobal_SellBidding_Withdraw)
end
function PaGlobal_SellBidding_Withdraw(inputNumber, sellNo)
  ToClient_requestWithdrawSellBiddingToWorldMarket(sellNo, inputNumber)
end
function PaGlobal_BuyBidding_Calculate(idx)
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self._prevItemIdx = idx
  local itemInfo = getWorldMarketBuyBiddingListByIdx(idx)
  local leftCount = itemInfo:getLeftCount()
  local buyNo = itemInfo:getBuyNo()
  ToClient_requestCalculateBuyBiddingToWorldMarket(buyNo)
end
function PaGlobal_BuyBidding_WithdrawSetCount(idx)
  local self = MarketPlace_Wallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self._prevItemIdx = idx
  FromClient_ValuePackageIcon()
  local itemInfo = getWorldMarketBuyBiddingListByIdx(idx)
  local leftCount = itemInfo:getLeftCount()
  local buyNo = itemInfo:getBuyNo()
  Panel_NumberPad_Show(true, leftCount, buyNo, PaGlobal_BuyBidding_Withdraw)
end
function PaGlobal_BuyBidding_Withdraw(inputNumber, buyNo)
  ToClient_requestWithdrawBuyBiddingToWorldMarket(buyNo, inputNumber)
end
function PaGlobal_SellBidding_ForTutorial()
  local self = MarketPlace_Wallet
  self._ui.stc_blockBG:SetShow(false)
  self._ui.list2_WalletItem:getElementManager():clearKey()
  self._ui.list2_WalletItem:getElementManager():pushKey(toInt64(0, 0))
end
function PaGlobalFunc_Wallet_Open()
  local self = MarketPlace_Wallet
  if false == _panel:GetShow() then
    _PA_ASSERT(false, "\235\169\148\236\157\184 \237\140\168\235\132\144\236\157\180 \236\151\180\235\160\164\236\158\136\236\167\128 \236\149\138\236\157\128\235\141\176 \236\149\132\236\157\180\237\133\156 \235\167\136\236\188\147\236\157\132 \236\151\180\235\160\164\234\179\160 \237\150\136\236\138\181\235\139\136\235\139\164. : \237\140\168\235\132\144 : Panel_Window_MarketPlace_Main")
    return
  end
  self._prevItemIdx = -1
  self._startInvenSlotIndex = 0
  self._prevScrollIndex = 0
  self._ui.list2_WalletItem:moveIndex(self._prevScrollIndex)
  self._ui.scroll_ItemSlot:SetControlPos(0)
  self._ui.txt_NoSerchResult:SetShow(false)
  local isSortType = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eMarketPlaceSlotType)
  PaGlobalFunc_MarketPlace_Wallet_SelectView(isSortType)
  self:updateHistory()
  self:open()
end
function PaGlobalFunc_Wallet_Close()
  local self = MarketPlace_Wallet
  if false == _panel:GetShow() then
    _PA_ASSERT(false, "\235\169\148\236\157\184 \237\140\168\235\132\144\236\157\180 \236\151\180\235\160\164\236\158\136\236\167\128 \236\149\138\236\157\128\235\141\176 \236\149\132\236\157\180\237\133\156 \235\167\136\236\188\147\236\157\132 \236\151\180\235\160\164\234\179\160 \237\150\136\236\138\181\235\139\136\235\139\164. : \237\140\168\235\132\144 : Panel_Window_MarketPlace_Main")
    return
  end
  if true == Panel_Window_MarketPlace_TutorialSelect:GetShow() then
    PaGlobal_MarketPlaceTutorialSelect:prepareClose()
    return
  end
  TooltipSimple_Hide()
  self._selectedViewType = 1
  self:close()
  ToClient_CalculateAllMyBiddingCancel()
end
function MarketPlace_Wallet:open()
  _mainBg:SetShow(true)
end
function MarketPlace_Wallet:close()
  _mainBg:SetShow(false)
end

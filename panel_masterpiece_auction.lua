Panel_Window_MasterpieceAuction:SetShow(false, false)
Panel_Window_MasterpieceAuction:setMaskingChild(true)
Panel_Window_MasterpieceAuction:ActiveMouseEventEffect(true)
Panel_Window_MasterpieceAuction:setGlassBackground(true)
Panel_Window_MasterpieceAuction:RegisterShowEventFunc(true, "MasterpieceAuction_ShowAni()")
Panel_Window_MasterpieceAuction:RegisterShowEventFunc(false, "MasterpieceAuction_HideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_TM = CppEnums.TextMode
function MasterpieceAuction_ShowAni()
  audioPostEvent_SystemUi(1, 30)
  _AudioPostEvent_SystemUiForXBOX(1, 30)
  UIAni.fadeInSCR_Down(Panel_Window_MasterpieceAuction)
  local aniInfo1 = Panel_Window_MasterpieceAuction:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_Window_MasterpieceAuction:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_MasterpieceAuction:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Window_MasterpieceAuction:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_MasterpieceAuction:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_MasterpieceAuction:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function MasterpieceAuction_HideAni()
  audioPostEvent_SystemUi(1, 31)
  _AudioPostEvent_SystemUiForXBOX(1, 31)
  FGlobal_MasterPieceAuction_Reset()
  Panel_Window_MasterpieceAuction:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_MasterpieceAuction:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
PaGlobal_MasterpieceAuction = {
  _ui = {
    _btn_Close = UI.getChildControl(Panel_Window_MasterpieceAuction, "Button_Close"),
    _but_Question = UI.getChildControl(Panel_Window_MasterpieceAuction, "Button_Question"),
    _radioBtnList = UI.getChildControl(Panel_Window_MasterpieceAuction, "RadioButton_ItemList"),
    _radioBtnMyBid = UI.getChildControl(Panel_Window_MasterpieceAuction, "RadioButton_MyBidList"),
    _staticBtnReload = UI.getChildControl(Panel_Window_MasterpieceAuction, "Button_AddFriend"),
    _staticLeftBG = UI.getChildControl(Panel_Window_MasterpieceAuction, "Static_LeftBG"),
    _staticCenterBG = UI.getChildControl(Panel_Window_MasterpieceAuction, "Static_CenterBG01"),
    _list2_LeftContent = UI.getChildControl(Panel_Window_MasterpieceAuction, "List2_LeftContent"),
    _staticMoneyBG = UI.getChildControl(Panel_Window_MasterpieceAuction, "Static_ListBG"),
    _staticTextWareHouse = UI.getChildControl(Panel_Window_MasterpieceAuction, "StaticText_Warehouse"),
    _staticTextMoney = UI.getChildControl(Panel_Window_MasterpieceAuction, "StaticText_Money"),
    _staticRightBG = UI.getChildControl(Panel_Window_MasterpieceAuction, "Static_RightBG"),
    _list2_RightContent = UI.getChildControl(Panel_Window_MasterpieceAuction, "List2_RightContent"),
    _staticTextDescTitle = UI.getChildControl(Panel_Window_MasterpieceAuction, "StaticText_DescTitle"),
    _staticTextDescBG = UI.getChildControl(Panel_Window_MasterpieceAuction, "StaticText_DescBg"),
    _txt_BottomDesc = UI.getChildControl(Panel_Window_MasterpieceAuction, "StaticText_BottomDesc"),
    _staticTextCenterLeftTime = nil,
    _staticTextItemName = nil,
    _staticTextItemAuthor = nil,
    _staticTextItemStory = nil,
    _staticTextCurrentPrice = nil,
    _staticTextCurrentPriceValue = nil,
    _staticTextMinimumBidPrice = nil,
    _staticTextReady = nil,
    _staticBottomBG = nil,
    _staticAuctionItemSlot = nil,
    _editPriceInput = nil,
    _btn_Bid = nil
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  _bidType = {
    _bidNone = 0,
    _bidTry = 1,
    _bidFail = 2,
    _bidSuccess = 3
  },
  _slotItem = {},
  _editPrice = toInt64(0, 0),
  _selectTabIndex = 0,
  _selectListIndex = 0,
  _list2LineCount = 2,
  _bidTypeIndex = 0,
  _masterpieceCountCache = 0,
  _itemTooltipDesc = {}
}
local isOpenEscMenu = false
function PaGlobal_MasterpieceAuction:initialize()
  self._ui._staticTextCenterLeftTime = UI.getChildControl(self._ui._staticCenterBG, "StaticText_LeftTime")
  self._ui._staticTextItemName = UI.getChildControl(self._ui._staticCenterBG, "StaticText_MasterpieceName")
  self._ui._staticTextItemAuthor = UI.getChildControl(self._ui._staticCenterBG, "StaticText_MasterpieceAuthor")
  self._ui._staticTextItemStory = UI.getChildControl(self._ui._staticCenterBG, "StaticText_MasterpieceStory")
  self._ui._staticTextCurrentPrice = UI.getChildControl(self._ui._staticCenterBG, "StaticText_CurrentPrice_Title")
  self._ui._staticTextCurrentPriceValue = UI.getChildControl(self._ui._staticCenterBG, "StaticText_CurrentPrice_Value")
  self._ui._staticTextMinimumBidPrice = UI.getChildControl(self._ui._staticCenterBG, "StaticText_MinimunBidPrice")
  self._ui._staticTextReady = UI.getChildControl(self._ui._staticCenterBG, "StaticText_MasterpieceReady")
  self._ui._staticBottomBG = UI.getChildControl(self._ui._staticCenterBG, "Static_BottomBg")
  self._ui._staticAuctionItemSlot = UI.getChildControl(self._ui._staticCenterBG, "Static_AuctionItemSlot")
  self._ui._editPriceInput = UI.getChildControl(self._ui._staticCenterBG, "Edit_PriceInput")
  self._ui._btn_Bid = UI.getChildControl(self._ui._staticCenterBG, "Button_Bid")
  self._ui._staticTextReady:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MASTERPIECE_READY"))
  SlotItem.new(self._slotItem, "MasterpieceAuction_Slot_Icon_", 0, self._ui._staticAuctionItemSlot, self._slotConfig)
  self._slotItem:createChild()
  self._slotItem.icon:SetPosX(35)
  self._slotItem.icon:SetPosY(32)
  local list2 = UI.getChildControl(Panel_Window_MasterpieceAuction, "List2_RightContent")
  local list2_Content = UI.getChildControl(list2, "List2_1_Content")
  local slot = {}
  local slot2 = {}
  local list2_ItemSlot = UI.getChildControl(list2_Content, "Static_ItemSlotBg1")
  local list2_ItemSlot2 = UI.getChildControl(list2_Content, "Static_ItemSlotBg2")
  SlotItem.new(slot, "MasterpieceAuction_RightSlot_LeftIcon_", 0, list2_ItemSlot, self._slotConfig)
  slot:createChild()
  SlotItem.new(slot2, "MasterpieceAuction_RightSlot_RightIcon_", 0, list2_ItemSlot2, self._slotConfig)
  slot2:createChild()
  self._ui._list2_RightContent:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "MasterpieceAution_RightContent_ListControlCreate")
  self._ui._list2_RightContent:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._editPriceInput:SetNumberMode(true)
  self._ui._but_Question:SetShow(false)
  self._ui._staticTextDescBG:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui._staticTextDescBG:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MASTERPIECEAUCTION_MYBIDITEMINFO"))
  self._ui._txt_BottomDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui._txt_BottomDesc:setPadding(CppEnums.Padding.ePadding_Left, 10)
  self._ui._txt_BottomDesc:setPadding(CppEnums.Padding.ePadding_Top, 5)
  self._ui._txt_BottomDesc:setPadding(CppEnums.Padding.ePadding_Right, 10)
  self._ui._txt_BottomDesc:setPadding(CppEnums.Padding.ePadding_Bottom, 5)
  self._ui._txt_BottomDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MASTERPIECE_AUCTION_BOTTOMDESC"))
  self._ui._txt_BottomDesc:SetSize(self._ui._txt_BottomDesc:GetSizeX(), self._ui._txt_BottomDesc:GetTextSizeY() + 15)
end
function PaGlobal_MasterpieceAuction:open()
  local self = PaGlobal_MasterpieceAuction
  if false == Panel_Window_MasterpieceAuction:GetShow() then
    Panel_Window_MasterpieceAuction:SetShow(true, true)
    PaGlobal_MasterpieceAuction:setPos()
  end
  local myAuctionInfo = RequestGetAuctionInfo()
  local itemListCount = myAuctionInfo:getItemAuctionListCount()
  self._selectTabIndex = 0
  self._ui._radioBtnList:SetCheck(true)
  self._ui._radioBtnMyBid:SetCheck(false)
  self._ui._staticTextCenterLeftTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MASTERPIECE_LEFTTIME", "time", tostring(Util.Time.timeFormatting_Minute(0))))
  self._ui._staticTextMinimumBidPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MASTERPIECE_MINIMUM_BID_PRICE", "price", tostring(makeDotMoney(0))))
  if 0 ~= itemListCount then
    PaGlobal_MasterpieceAuction:information(0)
  end
  PaGlobal_MasterpieceAuction:selectTabMouseEvent(0)
  PaGlobal_MasterpieceAuction:update(self._selectTabIndex)
end
function PaGlobal_MasterpieceAuction:close()
  audioPostEvent_SystemUi(1, 31)
  _AudioPostEvent_SystemUiForXBOX(1, 31)
  Panel_Window_MasterpieceAuction:SetShow(false)
  Panel_Tooltip_Item_hideTooltip()
  FGlobal_MasterPieceAuction_Reset()
  local self = PaGlobal_MasterpieceAuction
  self._ui._list2_RightContent:getElementManager():clearKey()
  self._masterpieceCountCache = 0
end
function PaGlobal_MasterpieceAuction:setPos()
  Panel_Window_MasterpieceAuction:SetPosX(getScreenSizeX() / 2 - Panel_Window_MasterpieceAuction:GetSizeX() / 2)
  Panel_Window_MasterpieceAuction:SetPosY(getScreenSizeY() / 2 - Panel_Window_MasterpieceAuction:GetSizeY() / 2 - 50)
end
function PaGlobal_MasterpieceAuction:update(tabIndex)
  local myAuctionInfo = RequestGetAuctionInfo()
  if 0 == tabIndex then
    local itemListCount = myAuctionInfo:getItemAuctionListCount()
    if 0 == itemListCount then
      PaGlobal_MasterpieceAuction:showList_Left(false)
    else
      PaGlobal_MasterpieceAuction:showList_Left(true)
    end
    self._ui._list2_LeftContent:getElementManager():clearKey()
    for itemCount = 0, itemListCount - 1 do
      self._ui._list2_LeftContent:getElementManager():pushKey(toInt64(0, itemCount))
    end
  elseif 1 == tabIndex then
    local bidItemListCount = myAuctionInfo:getMyItemBidListCount()
    bidItemListCount = math.floor(bidItemListCount / self._list2LineCount + 1 / self._list2LineCount)
    if 0 == bidItemListCount then
      PaGlobal_MasterpieceAuction:showList_Right(false)
    else
      PaGlobal_MasterpieceAuction:showList_Right(true)
    end
    self._ui._list2_RightContent:getElementManager():clearKey()
    if bidItemListCount > self._masterpieceCountCache then
      for index = self._masterpieceCountCache, bidItemListCount - 1 do
        self._ui._list2_RightContent:getElementManager():pushKey(toInt64(0, index))
      end
    else
      for index = bidItemListCount, self._masterpieceCountCache - 1 do
        self._ui._list2_RightContent:getElementManager():removeKey(toInt64(0, index))
      end
    end
    self._masterpieceCountCache = bidItemListCount
  end
end
function MasterpieceAution_LeftContent_ListControlCreate(content, key)
  local index = Int64toInt32(key)
  local radioBtn = UI.getChildControl(content, "RadioButton_LeftContentBg")
  local myAuctionInfo = RequestGetAuctionInfo()
  local goodsInfo = myAuctionInfo:getItemAuctionListAt(index)
  if nil == goodsInfo then
    return
  end
  local itemWrapper = goodsInfo:getItem()
  local itemSSW = itemWrapper:getStaticStatus()
  local self = PaGlobal_MasterpieceAuction
  if index == self._selectListIndex then
    radioBtn:SetCheck(true)
  else
    radioBtn:SetCheck(false)
  end
  radioBtn:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  radioBtn:SetText(itemSSW:getName())
  radioBtn:addInputEvent("Mouse_LUp", "PaGlobal_MasterpieceAuction:information( " .. index .. " )")
end
function PaGlobal_MasterpieceAuction:information(index)
  local myAuctionInfo = RequestGetAuctionInfo()
  local goodsInfo = myAuctionInfo:getItemAuctionListAt(index)
  local auctionType = myAuctionInfo:getAuctionType()
  local itemWrapper = goodsInfo:getItem()
  local itemSSW = itemWrapper:getStaticStatus()
  local leftTime_u64 = goodsInfo:getExpireTime_u64() / toUint64(0, 1000)
  local highPrice_s64 = goodsInfo:getHighPrice_s64()
  local lowPrice_s64 = goodsInfo:getLowPrice_s64()
  local isBiddable = goodsInfo:isBiddable()
  local isEnd = goodsInfo:isAuctionEnd()
  self._ui._staticTextItemName:SetText(itemSSW:getName())
  self._slotItem:setItemByStaticStatus(itemSSW)
  self._slotItem.icon:addInputEvent("Mouse_On", "PaGlobal_MasterpieceAuction:tooltipShow(" .. index .. "," .. auctionType .. ")")
  self._slotItem.icon:addInputEvent("Mouse_Out", "PaGlobal_MasterpieceAuction:tooltipHide()")
  local minimumBidPrice = 0
  if false == isEnd then
    self._ui._staticTextCenterLeftTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MASTERPIECE_LEFTTIME", "time", tostring(Util.Time.timeFormatting_Minute(Int64toInt32(leftTime_u64)))))
    if 0 == Int64toInt32(highPrice_s64) then
      self._ui._staticTextCurrentPrice:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MASTERPIECE_LOWPRICE"))
      self._ui._staticTextCurrentPriceValue:SetText(makeDotMoney(lowPrice_s64))
      minimumBidPrice = ToClient_calculateMinimumBidPrice(lowPrice_s64)
      self._ui._staticTextMinimumBidPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MASTERPIECE_MINIMUM_BID_PRICE", "price", tostring(makeDotMoney(minimumBidPrice))))
    else
      self._ui._staticTextCurrentPrice:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MASTERPIECE_CURRENTBIDPRICE"))
      self._ui._staticTextCurrentPriceValue:SetText(makeDotMoney(highPrice_s64))
      minimumBidPrice = ToClient_calculateMinimumBidPrice(highPrice_s64)
      self._ui._staticTextMinimumBidPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MASTERPIECE_MINIMUM_BID_PRICE", "price", tostring(makeDotMoney(minimumBidPrice))))
    end
    self._ui._btn_Bid:addInputEvent("Mouse_LUp", "PaGlobal_MasterpieceAuction:bidItem(" .. index .. ",isBiddable)")
  end
  self._ui._editPriceInput:addInputEvent("Mouse_LUp", "PaGlobal_MasterpieceAuction:setPrice(" .. index .. ")")
  self._ui._editPriceInput:SetText("0")
  local itemAuthor = goodsInfo:getExhibitor()
  self._ui._staticTextItemAuthor:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MASTERPIECEAUCTION_ITEMAUTHOR", "itemAuthor", itemAuthor))
  local itemDesc = goodsInfo:getDescription()
  self._ui._staticTextItemStory:SetTextMode(__eTextMode_Limit_AutoWrap)
  self._ui._staticTextItemStory:setLineCountByLimitAutoWrap(7)
  self._ui._staticTextItemStory:SetText(itemDesc)
  if self._ui._staticTextItemStory:IsLimitText() then
    self._ui._staticTextItemStory:SetEnableArea(0, 0, self._ui._staticTextItemStory:GetPosX(), self._ui._staticTextItemStory:GetTextSizeY())
    self._ui._staticTextItemStory:addInputEvent("Mouse_On", "MasterpieceAution_SimpleTooltip( true, " .. index .. ")")
    self._ui._staticTextItemStory:addInputEvent("Mouse_Out", "MasterpieceAution_SimpleTooltip( false )")
  end
  self._selectListIndex = index
end
function MasterpieceAution_SimpleTooltip(isShow, index)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local myAuctionInfo = RequestGetAuctionInfo()
  local goodsInfo = myAuctionInfo:getItemAuctionListAt(index)
  local self = PaGlobal_MasterpieceAuction
  local name, desc, control
  name = tostring(goodsInfo:getExhibitor())
  desc = tostring(goodsInfo:getDescription())
  control = self._ui._staticTextItemStory
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_MasterpieceAuction:tooltipShow(index, auctionType)
  Panel_Tooltip_Item_SetPosition(index, self._slotItem, "masterpiecdAuction")
  Panel_Tooltip_Item_Show_GeneralStatic(index, "masterpiecdAuction", true, auctionType)
end
function PaGlobal_MasterpieceAuction:tooltipHide()
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_MasterpieceAuction:setPrice(index)
  local function setEditText(inputNumber)
    self._ui._editPriceInput:SetText(makeDotMoney(inputNumber))
    self._editPrice = inputNumber
  end
  local s64_maxNumber = warehouse_moneyFromNpcShop_s64()
  Panel_NumberPad_Show(true, s64_maxNumber, 0, setEditText)
end
function PaGlobal_MasterpieceAuction:bidItem(index, isBiddable)
  if isBiddable then
    PaGlobal_MasterpieceAuction:update(self._selectTabIndex)
    return
  end
  local myAuctionInfo = RequestGetAuctionInfo()
  if nil == myAuctionInfo then
    return
  end
  local goodsInfo = myAuctionInfo:getItemAuctionListAt(index)
  if nil == goodsInfo then
    return
  end
  local function bidItemAuction()
    RequestBidAuction(index, self._editPrice)
    self._editPrice = toInt64(0, 0)
    self._ui._editPriceInput:SetText("0")
    PaGlobal_MasterpieceAuction:update(self._selectTabIndex)
  end
  local highPrice = goodsInfo:getHighPrice_s64()
  if highPrice < self._editPrice then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_MASTERPIECEAUCTION_DESC")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MASTERPIECEAUCTION_NAME"),
      content = messageBoxMemo,
      functionYes = bidItemAuction,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    self._bidTypeIndex = self._bidType._bidTry
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MASTERPIECE_PRICEALERT"))
  end
end
function MasterpieceAution_RightContent_ListControlCreate(content, key)
  local index = Int64toInt32(key)
  local self = PaGlobal_MasterpieceAuction
  local listBG1 = UI.getChildControl(content, "Static_MyBiddingListBg1")
  local itemSlot1 = UI.getChildControl(content, "Static_ItemSlotBg1")
  local bidItemName1 = UI.getChildControl(content, "StaticText_BidItemName1")
  local bidCondition1 = UI.getChildControl(content, "Static_BidCondition1")
  local leftTime1 = UI.getChildControl(content, "StaticText_LeftTime1")
  local bidMoney1 = UI.getChildControl(content, "StaticText_BidMoney1")
  local btnAuction1 = UI.getChildControl(content, "Button_Auction1")
  local priceBG1 = UI.getChildControl(content, "Static_PriceBg1")
  local btnMyBidPrice1 = UI.getChildControl(content, "StaticText_BidPriceTitle1")
  local listBG2 = UI.getChildControl(content, "Static_MyBiddingListBg2")
  local itemSlot2 = UI.getChildControl(content, "Static_ItemSlotBg2")
  local bidItemName2 = UI.getChildControl(content, "StaticText_BidItemName2")
  local bidCondition2 = UI.getChildControl(content, "Static_BidCondition2")
  local leftTime2 = UI.getChildControl(content, "StaticText_LeftTime2")
  local bidMoney2 = UI.getChildControl(content, "StaticText_BidMoney2")
  local btnAuction2 = UI.getChildControl(content, "Button_Auction2")
  local priceBG2 = UI.getChildControl(content, "Static_PriceBg2")
  local btnMyBidPrice2 = UI.getChildControl(content, "StaticText_BidPriceTitle2")
  local listBG, itemSlot, bidItemName, bidCondition, leftTime, bidMoney, btnAuction, priceBG, btnMyBidPrice
  for i = index * self._list2LineCount, index * self._list2LineCount + self._list2LineCount - 1 do
    if 0 == i % 2 then
      listBG = listBG1
      itemSlot = itemSlot1
      bidItemName = bidItemName1
      bidCondition = bidCondition1
      leftTime = leftTime1
      bidMoney = bidMoney1
      btnAuction = btnAuction1
      priceBG = priceBG1
      btnMyBidPrice = btnMyBidPrice1
    else
      listBG = listBG2
      itemSlot = itemSlot2
      bidItemName = bidItemName2
      bidCondition = bidCondition2
      leftTime = leftTime2
      bidMoney = bidMoney2
      btnAuction = btnAuction2
      priceBG = priceBG2
      btnMyBidPrice = btnMyBidPrice2
    end
    listBG:SetShow(false)
    itemSlot:SetShow(false)
    bidItemName:SetShow(false)
    bidCondition:SetShow(false)
    leftTime:SetShow(false)
    bidMoney:SetShow(false)
    btnAuction:SetShow(false)
    priceBG:SetShow(false)
    btnMyBidPrice:SetShow(false)
    local myAuctionInfo = RequestGetAuctionInfo()
    local auctionType = myAuctionInfo:getAuctionType()
    local goodsInfo = myAuctionInfo:getMyItemBidListAt(i)
    if nil == goodsInfo then
      return
    end
    priceBG:SetShow(true)
    btnMyBidPrice:SetShow(true)
    listBG:SetShow(true)
    local leftTime_u64 = goodsInfo:getExpireTime_u64() / toUint64(0, 1000)
    local highPrice_s64 = goodsInfo:getUpperBidPrice_s64()
    local myPrice_s64 = goodsInfo:getMyBidPrice_s64()
    local isBiddable = goodsInfo:isSuccessBid()
    local isEnd = goodsInfo:isAuctionEnd()
    if isBiddable or false == isEnd then
      local itemWrapper = goodsInfo:getItem()
      local itemSSW = itemWrapper:getStaticStatus()
      local slot = {}
      itemSlot:SetShow(true)
      if 0 == i % 2 then
        SlotItem.reInclude(slot, "MasterpieceAuction_RightSlot_LeftIcon_", 0, itemSlot, self._slotConfig)
      else
        SlotItem.reInclude(slot, "MasterpieceAuction_RightSlot_RightIcon_", 0, itemSlot, self._slotConfig)
      end
      slot:createChild()
      slot:setItemByStaticStatus(itemSSW)
      slot.icon:SetShow(true)
      slot.icon:SetPosX(slot.icon:GetPosX())
      slot.icon:addInputEvent("Mouse_On", "PaGlobal_MasterpieceAuction:tooltipShow(" .. i .. "," .. auctionType .. ")")
      slot.icon:addInputEvent("Mouse_Out", "PaGlobal_MasterpieceAuction:tooltipHide()")
      bidItemName:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
      bidItemName:SetText(itemSSW:getName())
      bidItemName:SetShow(true)
      self._itemTooltipDesc[i] = itemSSW:getName()
      if bidItemName:IsLimitText() then
        bidItemName:addInputEvent("Mouse_On", "PaGlobal_MasterpieceAuction:itemTooptip( true, " .. i .. " )")
        bidItemName:addInputEvent("Mouse_Out", "PaGlobal_MasterpieceAuction:itemTooptip( false )")
      end
      leftTime:SetText(tostring(Util.Time.timeFormatting_Minute(Int64toInt32(leftTime_u64))))
      leftTime:SetShow(true)
      bidMoney:SetText(makeDotMoney(myPrice_s64))
      bidMoney:SetShow(true)
      if highPrice_s64 > myPrice_s64 then
        btnAuction:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MASTERPIECE_RECIEVEMONEY"))
        btnAuction:addInputEvent("Mouse_LUp", "PaGlobal_MasterpieceAuction:cancelBidorSell(" .. i .. ")")
        btnAuction:SetShow(true)
      elseif isBiddable then
        btnAuction:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MASTERPIECE_RECIEVEITEM"))
        btnAuction:addInputEvent("Mouse_LUp", "PaGlobal_MasterpieceAuction:getSuccessItemorMoney(" .. i .. ")")
        btnAuction:SetShow(true)
      else
        btnAuction:SetShow(false)
      end
    else
      bidMoney:SetText(makeDotMoney(myPrice_s64))
      bidMoney:SetShow(true)
      btnAuction:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MASTERPIECE_RECIEVEMONEY"))
      btnAuction:addInputEvent("Mouse_LUp", "PaGlobal_MasterpieceAuction:cancelBidorSell(" .. i .. ")")
      btnAuction:SetShow(true)
    end
  end
end
function FGlobal_MasterpieceAuction_OpenAuctionItemNotNpc()
  local self = PaGlobal_MasterpieceAuction
  self._ui._radioBtnMyBid:SetShow(false)
  self._ui._btn_Bid:SetShow(false)
  self._ui._editPriceInput:SetShow(false)
  self._ui._staticBtnReload:SetShow(false)
  self._ui._radioBtnList:SetIgnore(true)
  self._ui._staticMoneyBG:SetShow(false)
  self._ui._staticTextWareHouse:SetShow(false)
  self._ui._staticTextMoney:SetShow(false)
  isOpenEscMenu = true
  if isOpenEscMenu then
    self._ui._txt_BottomDesc:SetShow(true)
    Panel_Window_MasterpieceAuction:SetSize(682, 640 + self._ui._txt_BottomDesc:GetTextSizeY() + 20)
  end
  FromClient_MasterPieceAuction_WarehouseUpdate()
  ToClient_getAuctionItemFromNoNpc(1001, 0, 0)
end
function FGlobal_MasterPieceAuction_IsOpenEscMenu()
  return isOpenEscMenu
end
function FGlobal_MasterPieceAuction_Reset()
  local self = PaGlobal_MasterpieceAuction
  self._ui._radioBtnMyBid:SetShow(true)
  self._ui._btn_Bid:SetShow(true)
  self._ui._editPriceInput:SetShow(true)
  self._ui._staticBtnReload:SetShow(true)
  self._ui._radioBtnList:SetIgnore(false)
  self._ui._staticMoneyBG:SetShow(true)
  self._ui._staticTextWareHouse:SetShow(true)
  self._ui._staticTextMoney:SetShow(true)
  local wareHouseMoney = warehouse_moneyFromNpcShop_s64()
  self._ui._staticTextMoney:SetText(makeDotMoney(wareHouseMoney))
  isOpenEscMenu = false
  self._ui._txt_BottomDesc:SetShow(false)
  Panel_Window_MasterpieceAuction:SetSize(682, 640)
end
function PaGlobal_MasterpieceAuction:itemTooptip(isShow, index)
  if isShow == false then
    TooltipSimple_Hide()
    return
  end
  TooltipSimple_Show(Panel_Window_MasterpieceAuction, self._itemTooltipDesc[index])
end
function PaGlobal_MasterpieceAuction:cancelBidorSell(index)
  RequestAuction_CancelGoods(index)
  self._bidTypeIndex = self._bidType._bidFail
end
function PaGlobal_MasterpieceAuction:getSuccessItemorMoney(index)
  RequestAuction_GetGoods(index)
  self._bidTypeIndex = self._bidType._bidSuccess
end
function FromClient_ResponseAuction_UpdateAuctionList()
  local self = PaGlobal_MasterpieceAuction
  local myAuctionInfo = RequestGetAuctionInfo()
  local auctionType = myAuctionInfo:getAuctionType()
  warehouse_requestInfoFromNpc()
  if CppEnums.AuctionTabType.AuctionTab_SellItem == auctionType or CppEnums.AuctionTabType.AuctionTab_MySellPage == auctionType or isOpenEscMenu == true then
    PaGlobal_MasterpieceAuction:open()
  else
    PaGlobal_MasterpieceAuction:update(self._selectTabIndex)
    PaGlobal_MasterpieceAuction:bidTypeMessage(self._bidTypeIndex)
  end
end
function FromClient_BidAuctionGoods(goodsType, param1, param2)
  RequestAuctionListPage()
  if 0 ~= goodsType then
    return
  end
  local bidSuccess = param2
  if bidSuccess then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MASTERPIECEAUCTION_BIDTYPEMESSAGE_1"))
  end
end
function PaGlobal_MasterpieceAuction:showList_Left(isShow)
  self._ui._staticLeftBG:SetShow(true)
  self._ui._staticCenterBG:SetShow(true)
  self._ui._list2_LeftContent:SetShow(isShow)
  self._ui._staticTextReady:SetShow(false == isShow)
  self._ui._staticTextItemName:SetShow(isShow)
  self._ui._staticTextItemAuthor:SetShow(isShow)
  self._ui._staticTextItemStory:SetShow(isShow)
  self._ui._staticTextCurrentPrice:SetShow(isShow)
  self._ui._staticTextCurrentPriceValue:SetShow(isShow)
  self._ui._staticBottomBG:SetShow(isShow)
  self._slotItem.icon:SetShow(isShow)
  self._ui._staticRightBG:SetShow(false)
  self._ui._list2_RightContent:SetShow(false)
  self._ui._editPriceInput:SetIgnore(false)
  self._ui._staticTextDescTitle:SetShow(false)
  self._ui._btn_Bid:SetIgnore(false == isShow)
  self._ui._staticTextDescBG:SetShow(false)
  if isOpenEscMenu then
    self._ui._txt_BottomDesc:SetShow(true)
    Panel_Window_MasterpieceAuction:SetSize(682, 640 + self._ui._txt_BottomDesc:GetTextSizeY() + 20)
  else
    self._ui._staticTextMoney:SetShow(true)
    self._ui._staticMoneyBG:SetShow(true)
    self._ui._staticTextWareHouse:SetShow(true)
  end
  local wareHouseMoney = warehouse_moneyFromNpcShop_s64()
  self._ui._staticTextMoney:SetText(makeDotMoney(wareHouseMoney))
  self._ui._txt_BottomDesc:ComputePos()
  self._ui._staticTextDescBG:ComputePos()
end
function PaGlobal_MasterpieceAuction:showList_Right(isShow)
  self._ui._list2_RightContent:SetShow(isShow)
  self._ui._staticRightBG:SetShow(true)
  self._ui._staticTextDescTitle:SetShow(true)
  self._ui._staticTextDescBG:SetShow(true)
  self._ui._staticTextMoney:SetShow(false)
  self._ui._staticMoneyBG:SetShow(false)
  self._ui._staticTextWareHouse:SetShow(false)
  self._ui._staticLeftBG:SetShow(false)
  self._ui._list2_LeftContent:SetShow(false)
  self._ui._staticCenterBG:SetShow(false)
  self._ui._staticTextReady:SetShow(false)
  self._ui._txt_BottomDesc:SetShow(false)
  Panel_Window_MasterpieceAuction:SetSize(682, 640)
  self._ui._txt_BottomDesc:ComputePos()
  self._ui._staticTextDescBG:ComputePos()
end
function PaGlobal_MasterpieceAuction:selectTab(index)
  self._selectTabIndex = index
  PaGlobal_MasterpieceAuction:selectTabMouseEvent(self._selectTabIndex)
  if 0 == index then
    RequestAuctionListPage()
  elseif 1 == index then
    RequestBiddingPage()
  end
end
function PaGlobal_MasterpieceAuction:selectTabMouseEvent(index)
  self._ui._staticBtnReload:addInputEvent("Mouse_LUp", "PaGlobal_MasterpieceAuction:selectTab(" .. index .. ")")
end
function FromClient_MasterPieceAuction_WarehouseUpdate()
  local self = PaGlobal_MasterpieceAuction
  local wareHouseMoney = warehouse_moneyFromNpcShop_s64()
  self._ui._staticTextMoney:SetText(makeDotMoney(wareHouseMoney))
end
function PaGlobal_MasterpieceAuction:bidTypeMessage(index)
  if 2 == index then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MASTERPIECEAUCTION_BIDTYPEMESSAGE_" .. index))
  end
  self._bidTypeIndex = self._bidType._bidNone
end
function PaGlobal_MasterpieceAuction:registerEvent()
  registerEvent("FromClient_ResponseAuction_UpdateAuctionList", "FromClient_ResponseAuction_UpdateAuctionList")
  registerEvent("FromClient_BidAuctionGoods", "FromClient_BidAuctionGoods")
  registerEvent("EventWarehouseUpdate", "FromClient_MasterPieceAuction_WarehouseUpdate")
  self._ui._list2_LeftContent:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "MasterpieceAution_LeftContent_ListControlCreate")
  self._ui._list2_LeftContent:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._radioBtnList:addInputEvent("Mouse_LUp", "PaGlobal_MasterpieceAuction:selectTab(" .. 0 .. ")")
  self._ui._radioBtnMyBid:addInputEvent("Mouse_LUp", "PaGlobal_MasterpieceAuction:selectTab(" .. 1 .. ")")
  self._ui._btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_MasterpieceAuction:close()")
end
PaGlobal_MasterpieceAuction:registerEvent()
PaGlobal_MasterpieceAuction:initialize()

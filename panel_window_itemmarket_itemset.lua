local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_BUFFTYPE = CppEnums.UserChargeType
Panel_Window_ItemMarket_ItemSet:SetShow(false)
Panel_Window_ItemMarket_ItemSet:SetDragEnable(true)
function ItemMarketItemSetShowAni()
end
function ItemMarketItemSetHideAni()
end
local ItemMarketItemSet = {
  panelBG = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "Static_PanelBG"),
  btn_Close = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "Button_Win_Close"),
  btn_Question = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "Button_Question"),
  btn_RegistItem = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "Button_RegistItem"),
  registItemCount = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "StaticText_RegistItemCount_Value"),
  saleItemCount = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "StaticText_SaleItemCount_Value"),
  RegistDelayNotify = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "StaticText_RegistDelayNotify"),
  waitingCount = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "StaticText_WaitingCount_Value"),
  invenMoney = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "Static_Text_Money"),
  warehouseMoney = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "Static_Text_Money2"),
  btn_Inven = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "RadioButton_Icon_Money"),
  btn_Warehouse = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "RadioButton_Icon_Money2"),
  bottomDesc = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "StaticText_BottomDesc"),
  btn_GetAll = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "Button_GetAllItem"),
  _list2 = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "List2_ItemMarket_ItemSet"),
  startIdx = 0,
  totalCount = 0,
  ItemListUiPool = {},
  ItemListMaxCount = 7,
  slotConfing = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true,
    createClassEquipBG = true
  },
  _buttonQuestion = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "Button_Question"),
  escMenuSaveValue = false
}
local bgTexture = {
  [0] = {
    [0] = {
      134,
      2,
      198,
      60
    },
    {
      110,
      265,
      174,
      323
    },
    {
      110,
      325,
      174,
      383
    }
  },
  {
    [0] = {
      1,
      123,
      65,
      181
    },
    {
      68,
      123,
      65,
      181
    },
    {
      134,
      123,
      198,
      181
    }
  },
  {
    [0] = {
      310,
      440,
      374,
      498
    },
    {
      377,
      440,
      441,
      498
    },
    {
      444,
      440,
      508,
      498
    }
  }
}
local currentMyTerritoryKey = function()
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    return -1
  end
  return regionInfoWrapper:getTerritoryKeyRaw()
end
local territoryKey = {
  [0] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_0")),
  [1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_1")),
  [2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_2")),
  [3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_3")),
  [4] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_4")),
  [5] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_5")),
  [6] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_6")),
  [7] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_7"))
}
function ItemMarketItemSet:Initialize()
  self.panelBG:setGlassBackground(true)
  self.panelBG:ActiveMouseEventEffect(true)
  local minSize = float2()
  minSize.x = 100
  minSize.y = 50
  local list2Control = UI.getChildControl(Panel_Window_ItemMarket_ItemSet, "List2_ItemMarket_ItemSet")
  local list2Content = UI.getChildControl(list2Control, "List2_1_Content")
  local createSlot = {}
  list2Control:setMinScrollBtnSize(minSize)
  local itemlist_Slot = UI.getChildControl(list2Content, "Template_Static_Slot")
  SlotItem.new(createSlot, "ItemMarketItemSet_ItemListSlotItem", 0, itemlist_Slot, self.slotConfing)
  createSlot:createChild()
  createSlot.icon:SetPosX(4)
  createSlot.icon:SetPosY(1)
  self._list2:changeAnimationSpeed(10)
  self._list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "ItemmarketItemSet_ListUpdate")
  self._list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self.bottomDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.bottomDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKETSET_BOTTOM_DESC"))
  self.btn_GetAll:addInputEvent("Mouse_LUp", "ItemMarketSetItem_GetAllItemCheck()")
  self.btn_GetAll:addInputEvent("Mouse_On", "ItemMarketSetItem_GetAllItem_Simpletooltip(true)")
  self.btn_GetAll:addInputEvent("Mouse_Out", "ItemMarketSetItem_GetAllItem_Simpletooltip()")
end
function ItemmarketItemSet_ListUpdate(contents, key)
  local self = ItemMarketItemSet
  local idx = Int64toInt32(key)
  local replaceCount = function(num)
    if nil ~= num then
      local count = Int64toInt32(num)
      if 0 == count then
        count = "-"
      else
        count = makeDotMoney(num)
      end
      return count
    else
      return "-"
    end
  end
  local ItemBG = UI.getChildControl(contents, "Template_Static_ItemBG")
  ItemBG:setNotImpactScrollEvent(true)
  local ItemPeriodEndBG = UI.getChildControl(contents, "Template_Static_ItemBG_PeriodEnd")
  local SlotBG = UI.getChildControl(contents, "Template_Static_SlotBG")
  SlotBG:SetShow(true)
  local createSlot = {}
  local itemlist_Slot = UI.getChildControl(contents, "Template_Static_Slot")
  itemlist_Slot:SetShow(true)
  SlotItem.reInclude(createSlot, "ItemMarketItemSet_ItemListSlotItem", 0, itemlist_Slot, self.slotConfing)
  local ItemName = UI.getChildControl(contents, "Template_StaticText_ItemName")
  ItemName:SetShow(true)
  ItemName:SetTextMode(UI_TM.eTextMode_AutoWrap)
  local AveragePrice_Title = UI.getChildControl(contents, "Template_Static_AveragePrice_TitleIcon")
  AveragePrice_Title:SetShow(true)
  AveragePrice_Title:SetMonoTone(true)
  local AveragePrice_Value = UI.getChildControl(contents, "Template_StaticText_AveragePrice_Value")
  AveragePrice_Value:SetShow(true)
  local SoldOut = UI.getChildControl(contents, "Template_StaticText_SoldOut")
  local RecentPrice_Title = UI.getChildControl(contents, "Template_Static_RecentPrice_TitleIcon")
  RecentPrice_Title:SetShow(true)
  RecentPrice_Title:SetMonoTone(true)
  local RecentPrice_Value = UI.getChildControl(contents, "Template_StaticText_RecentPrice_Value")
  RecentPrice_Value:SetShow(true)
  local SellPrice_Title = UI.getChildControl(contents, "Template_Static_SellPrice_TitleIcon")
  SellPrice_Title:SetShow(true)
  SellPrice_Title:SetColor(4286940549)
  local SellPrice_Value = UI.getChildControl(contents, "Template_StaticText_SellPrice_Value")
  SellPrice_Value:SetShow(true)
  local RegistPeriod_Title = UI.getChildControl(contents, "Template_Static_RegistPeriod_TitleIcon")
  RegistPeriod_Title:SetShow(true)
  RegistPeriod_Title:SetColor(4286940549)
  local RegistPeriod_Value = UI.getChildControl(contents, "Template_StaticText_RegistPeriod_Value")
  RegistPeriod_Value:SetShow(true)
  local BTN_RegistCancle = UI.getChildControl(contents, "Template_Button_RegistCancle")
  BTN_RegistCancle:SetShow(true)
  local BTN_Withdrawals = UI.getChildControl(contents, "Template_Button_Withdrawals")
  BTN_Withdrawals:SetShow(true)
  local BTN_Settlement = UI.getChildControl(contents, "Templete_Button_Settlement")
  BTN_Settlement:SetShow(true)
  local RegistTerritoryText = UI.getChildControl(contents, "MultilineText_RegistTerritoryText")
  local SellCountIcon = UI.getChildControl(contents, "Template_Static_SellCountIcon")
  SellCountIcon:SetShow(true)
  SellCountIcon:SetColor(4286940549)
  local SellCountValue = UI.getChildControl(contents, "Template_StaticText_SellCountValue")
  SellCountValue:SetShow(true)
  local SellCompleteIcon = UI.getChildControl(contents, "Template_Static_SellCompleteIcon")
  SellCompleteIcon:SetShow(true)
  SellCompleteIcon:SetColor(4286940549)
  local SellCompleteValue = UI.getChildControl(contents, "Template_StaticText_SellCompleteValue")
  SellCompleteValue:SetShow(true)
  local PrivateItemIcon = UI.getChildControl(contents, "Static_PassIcon")
  PrivateItemIcon:SetPosX(AveragePrice_Title:GetPosX() - PrivateItemIcon:GetSizeX() - 10)
  PrivateItemIcon:SetPosY(AveragePrice_Title:GetPosY())
  local currentTerritoryKey = currentMyTerritoryKey()
  local myItemInfo = getItemMarketMyItemByIndex(idx)
  if nil ~= myItemInfo then
    ItemBG:SetShow(true)
    local iess = myItemInfo:getItemEnchantStaticStatusWrapper()
    _PA_ASSERT(nil ~= iess, "myItemInfo \236\149\132\236\157\180\237\133\156 \234\179\160\236\160\149\236\160\149\235\179\180\234\176\128 \234\188\173 \236\158\136\236\150\180\236\149\188\237\149\169\235\139\136\235\139\164")
    if nil ~= iess then
      local nameColorGrade = iess:getGradeType()
      local nameColor
      if 0 == nameColorGrade then
        nameColor = UI_color.C_FFEFEFEF
      elseif 1 == nameColorGrade then
        nameColor = 4284350320
      elseif 2 == nameColorGrade then
        nameColor = 4283144191
      elseif 3 == nameColorGrade then
        nameColor = 4294953010
      elseif 4 == nameColorGrade then
        nameColor = 4294929408
      else
        nameColor = UI_color.C_FFFFFFFF
      end
      ItemName:SetFontColor(nameColor)
      local enchantLevel = iess:get()._key:getEnchantLevel()
      if 1 == iess:getItemType() and enchantLevel > 15 then
        ItemName:SetText(HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. iess:getName())
      elseif enchantLevel > 0 and CppEnums.ItemClassifyType.eItemClassify_Accessory == iess:getItemClassify() then
        ItemName:SetText(HighEnchantLevel_ReplaceString(enchantLevel + 15) .. " " .. iess:getName())
      else
        ItemName:SetText(iess:getName())
      end
      PrivateItemIcon:SetShow(myItemInfo:isPrivateItem())
      createSlot:setItemByStaticStatus(iess, myItemInfo:getCount(), -1, false)
      createSlot.icon:addInputEvent("Mouse_On", "_ItemMarketItemSet_ShowToolTip( " .. idx .. " )")
      createSlot.icon:addInputEvent("Mouse_Out", "_ItemMarketItemSet_HideToolTip()")
      createSlot.icon:SetShow(true)
      createSlot.icon:SetPosX(0)
      createSlot.icon:SetPosY(0)
      AveragePrice_Title:addInputEvent("Mouse_On", "ItemMarketItemSet_ToolTip( true,\t" .. idx .. ", 0 )")
      AveragePrice_Title:addInputEvent("Mouse_Out", "ItemMarketItemSet_ToolTip( false,\t" .. idx .. ", 0 )")
      RecentPrice_Title:addInputEvent("Mouse_On", "ItemMarketItemSet_ToolTip( true,\t" .. idx .. ", 1 )")
      RecentPrice_Title:addInputEvent("Mouse_Out", "ItemMarketItemSet_ToolTip( false,\t" .. idx .. ", 1 )")
      SellPrice_Title:addInputEvent("Mouse_On", "ItemMarketItemSet_ToolTip( true,\t" .. idx .. ", 5 )")
      SellPrice_Title:addInputEvent("Mouse_Out", "ItemMarketItemSet_ToolTip( false,\t" .. idx .. ", 5 )")
      RegistPeriod_Title:addInputEvent("Mouse_On", "ItemMarketItemSet_ToolTip( true,\t" .. idx .. ", 3 )")
      RegistPeriod_Title:addInputEvent("Mouse_Out", "ItemMarketItemSet_ToolTip( false,\t" .. idx .. ", 3 )")
      SellCountIcon:addInputEvent("Mouse_On", "ItemMarketItemSet_ToolTip( true,\t" .. idx .. ", 4 )")
      SellCountIcon:addInputEvent("Mouse_Out", "ItemMarketItemSet_ToolTip( false,\t" .. idx .. ", 4 )")
      SellCompleteIcon:addInputEvent("Mouse_On", "ItemMarketItemSet_ToolTip( true,\t" .. idx .. ", 2 )")
      SellCompleteIcon:addInputEvent("Mouse_Out", "ItemMarketItemSet_ToolTip( false,\t" .. idx .. ", 2 )")
      BTN_Withdrawals:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketItemSet_ItemWithdrawals( " .. iess:get()._key:get() .. "," .. idx .. " )")
      RegistPeriod_Value:SetFontColor(Defines.Color.C_FF6C7DE4)
      local periodSecond = ItemMarketSecondTimeConvert(myItemInfo:getDisplayedEndDate())
      if toInt64(0, 0) == periodSecond then
        RegistPeriod_Value:SetFontColor(Defines.Color.C_FFD20000)
        ItemPeriodEndBG:SetShow(true)
      else
        RegistPeriod_Value:SetFontColor(Defines.Color.C_FF6C7DE4)
        ItemPeriodEndBG:SetShow(false)
      end
      RegistPeriod_Value:SetText(converStringFromLeftDateTime(myItemInfo:getDisplayedEndDate()))
      SellCountValue:SetText(Int64toInt32(myItemInfo:getTotalCount()))
      SellCompleteValue:SetText(makeDotMoney(myItemInfo:getTradedTotalPrice()))
      BTN_RegistCancle:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketItemSet_RegistCancle( " .. iess:get()._key:get() .. "," .. idx .. " )")
      BTN_Settlement:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketItemSet_ItemSettlement( " .. iess:get()._key:get() .. "," .. idx .. " )")
      BTN_RegistCancle:addInputEvent("Mouse_On", "")
      BTN_RegistCancle:addInputEvent("Mouse_Out", "")
      local leftBeginDate_s64 = converStringFromLeftDateTime(myItemInfo:getDisplayedBeginDate())
      if myItemInfo:isTraded() and 0 == Int64toInt32(myItemInfo:getTotalPrice()) then
        _ItemMarketItemSet_ChangeBgTexture(1, idx)
        ItemPeriodEndBG:SetShow(false)
        BTN_RegistCancle:SetShow(false)
        BTN_Withdrawals:SetShow(true)
        BTN_Settlement:SetShow(false)
      elseif myItemInfo:isTraded() and 0 < Int64toInt32(myItemInfo:getTradedTotalPrice()) and 0 < Int64toInt32(myItemInfo:getTotalPrice()) then
        _ItemMarketItemSet_ChangeBgTexture(0, idx)
        BTN_Settlement:SetShow(true)
        BTN_RegistCancle:SetShow(false)
        BTN_Withdrawals:SetShow(false)
      else
        _ItemMarketItemSet_ChangeBgTexture(2, idx)
        BTN_RegistCancle:SetShow(true)
        BTN_Withdrawals:SetShow(false)
        BTN_Settlement:SetShow(false)
        local highItemPrice = requestDoBroadcastRegister(myItemInfo:getTotalPrice())
        local waitingItem = myItemInfo:isWaiting()
        if waitingItem == false then
          BTN_RegistCancle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTCANCEL"))
        else
          BTN_RegistCancle:addInputEvent("Mouse_LUp", "")
          BTN_RegistCancle:addInputEvent("Mouse_On", "_ItemMarketItemSet_SimpleToolTip(true, " .. idx .. ")")
          BTN_RegistCancle:addInputEvent("Mouse_Out", "_ItemMarketItemSet_SimpleToolTip(false)")
          BTN_RegistCancle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTWAITCANCEL"))
        end
      end
      local summaryInfo = getItemMarketSummaryInClientByItemEnchantKey(iess:get()._key:get())
      _PA_ASSERT(nil ~= summaryInfo, "summaryInfo \236\160\149\235\179\180\234\176\128 \234\188\173 \236\158\136\236\150\180\236\149\188\237\149\169\235\139\136\235\139\164")
      local temp_recentPrice
      if nil ~= summaryInfo then
        temp_recentPrice = summaryInfo:getLastTradedOnePrice()
      end
      local masterInfo = getItemMarketMasterByItemEnchantKey(iess:get()._key:get())
      local marketConditions
      if nil ~= masterInfo then
        marketConditions = (masterInfo:getMinPrice() + masterInfo:getMaxPrice()) / toInt64(0, 2)
      end
      AveragePrice_Value:SetText(replaceCount(marketConditions))
      RecentPrice_Value:SetText(replaceCount(temp_recentPrice))
      SellPrice_Value:SetText(replaceCount(myItemInfo:getTotalPrice()))
      local _isSelfTerritory = false
      local _territoryKey = myItemInfo:getTerritoryKey()
      if currentTerritoryKey == _territoryKey then
        _isSelfTerritory = true
      end
      if true == ToClient_WorldMapIsShow() or false == _isSelfTerritory or ItemMarketItemSet.escMenuSaveValue then
        BTN_RegistCancle:SetShow(false)
        BTN_Withdrawals:SetShow(false)
        BTN_Settlement:SetShow(false)
        local _territoryKey = myItemInfo:getTerritoryKey()
        local registTerritoryName
        registTerritoryName = ""
        for i = 0, 7 do
          if i == _territoryKey then
            registTerritoryName = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TEXT_REGISTTERRITORY", "territoryKey", territoryKey[i])
          end
        end
        RegistTerritoryText:SetText(registTerritoryName)
        if 5 == getGameServiceType() or 6 == getGameServiceType() then
          RegistTerritoryText:SetSize(140, 20)
          RegistTerritoryText:SetHorizonRight()
          RegistTerritoryText:SetSpanSize(5, 10)
        end
        RegistTerritoryText:SetShow(true)
        if myItemInfo:isTraded() and 0 == Int64toInt32(myItemInfo:getTotalPrice()) then
          if true == ToClient_WorldMapIsShow() or ItemMarketItemSet.escMenuSaveValue then
            RegistTerritoryText:SetPosY(18)
            RegistTerritoryText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_SELLCOMPLETE"))
          else
            RegistTerritoryText:SetShow(false)
            BTN_Withdrawals:SetShow(true)
          end
        end
      else
        RegistTerritoryText:SetShow(false)
      end
    end
  end
end
function ItemMarketItemSet:SetPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_Window_ItemMarket_ItemSet:GetSizeX()
  local panelSizeY = Panel_Window_ItemMarket_ItemSet:GetSizeY()
  Panel_Window_ItemMarket_ItemSet:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Panel_Window_ItemMarket_ItemSet:SetPosY(scrSizeY / 2 - panelSizeY / 2)
end
local currentMyTerritoryKey = function()
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    return -1
  end
  return regionInfoWrapper:getTerritoryKeyRaw()
end
local myItemCountCache = 0
function ItemMarketItemSet:Update()
  local itemCount = getItemMarketMyItemsCount()
  local countryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTDELAYNOTIFY", "forPremium", requestGetRefundPercentForPremiumPackage())
  if 5 == getGameServiceType() or 6 == getGameServiceType() then
    countryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTDELAYNOTIFY_JP", "forPcRoom", requestGetRefundPercentForPcRoom())
  elseif isGameTypeEnglish() then
    countryTypeSet = ""
  else
    countryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTDELAYNOTIFY", "forPremium", requestGetRefundPercentForPremiumPackage())
  end
  self.registItemCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTITEMCOUNT", "itemCount", itemCount))
  self.RegistDelayNotify:SetText(countryTypeSet)
  local saleCount = 0
  self.totalCount = getItemMarketMyItemsCount()
  for idx = 0, self.totalCount - 1 do
    local myItemInfo = getItemMarketMyItemByIndex(idx)
    if nil ~= myItemInfo and myItemInfo:isTraded() and 0 == Int64toInt32(myItemInfo:getTotalPrice()) then
      saleCount = saleCount + 1
    end
  end
  local waitingCount = 0
  for idx = 0, self.totalCount - 1 do
    local myItemInfo = getItemMarketMyItemByIndex(idx)
    if nil ~= myItemInfo and myItemInfo:isWaiting() == true then
      waitingCount = waitingCount + 1
    end
  end
  self.saleItemCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTITEMCOUNT", "itemCount", tostring(saleCount)))
  self.waitingCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTITEMCOUNT", "itemCount", tostring(waitingCount)))
  local myItemCount = getItemMarketMyItemsCount()
  if myItemCount > myItemCountCache then
    for idx = myItemCountCache, myItemCount - 1 do
      self._list2:getElementManager():pushKey(toInt64(0, idx))
    end
  else
    for idx = myItemCount, myItemCountCache - 1 do
      self._list2:getElementManager():removeKey(toInt64(0, idx))
    end
  end
  myItemCountCache = myItemCount
  self._list2:requestUpdateVisible()
end
function ItemMarketSecondTimeConvert(s64_datetime)
  local leftDate = getLeftSecond_TTime64(s64_datetime)
  local s64_dayCycle = toInt64(0, 86400)
  local s64_hourCycle = toInt64(0, 3600)
  local s64_minuteCycle = toInt64(0, 60)
  local s64_day = leftDate / s64_dayCycle
  local s64_hour = (leftDate - s64_dayCycle * s64_day) / s64_hourCycle
  local s64_minute = (leftDate - s64_dayCycle * s64_day - s64_hourCycle * s64_hour) / s64_minuteCycle
  local s64_Second = leftDate - s64_dayCycle * s64_day - s64_hourCycle * s64_hour - s64_minuteCycle * s64_minute
  local strDate = ""
  if s64_day > Defines.s64_const.s64_0 and s64_hour > Defines.s64_const.s64_0 then
    strDate = s64_day + s64_hour
  elseif s64_day > Defines.s64_const.s64_0 then
    strDate = s64_day
  elseif s64_hour > Defines.s64_const.s64_0 then
    strDate = s64_hour + s64_minute
  elseif s64_minute > Defines.s64_const.s64_0 then
    strDate = s64_minute + s64_Second
  elseif s64_Second >= Defines.s64_const.s64_0 then
    strDate = s64_Second
  end
  return strDate
end
function ItemMarketItemSet:Open(escMenu)
  ItemMarketItemSet.escMenuSaveValue = escMenu
  if ToClient_WorldMapIsShow() or escMenu then
    requestItemMarketMyItems(true, false)
  else
    requestItemMarketMyItems(false, false)
  end
  ItemMarketItemSet:SetPosition()
  ItemMarketItemSet:Update()
  Panel_Window_ItemMarket_ItemSet:SetShow(true, true)
end
function _ItemMarketItemSet_ShowToolTip(idx)
  local self = ItemMarketItemSet
  if nil == idx then
    _ItemMarketItemSet_HideToolTip()
    return
  end
  local contents = self._list2:GetContentByKey(toInt64(0, idx))
  if nil ~= contents then
    local item_Slot = UI.getChildControl(contents, "Template_Static_Slot")
    local myItemInfo = getItemMarketMyItemByIndex(idx)
    if myItemInfo:isTraded() then
      local itemWrapper = getItemMarketMyItemByIndex(idx):getItemEnchantStaticStatusWrapper()
      Panel_Tooltip_Item_Show(itemWrapper, item_Slot, true, false, nil)
    else
      local itemWrapper = getItemMarketMyItemByIndex(idx):getItemWrapper()
      Panel_Tooltip_Item_Show(itemWrapper, item_Slot, false, true, nil)
    end
  end
end
function _ItemMarketItemSet_HideToolTip()
  Panel_Tooltip_Item_hideTooltip()
  TooltipSimple_Hide()
end
function _ItemMarketItemSet_ChangeBgTexture(bgType, idx)
  local self = ItemMarketItemSet
  do return end
  local contents = self._list2:GetContentByKey(toInt64(0, idx))
  if nil ~= contents then
    local ItemBG = UI.getChildControl(contents, "Template_Static_ItemBG")
    ItemBG:ChangeTextureInfoName("New_UI_Common_forLua/Window/ItemMarket/ItemMarket_00.dds")
    ItemBG:ChangeOnTextureInfoName("New_UI_Common_forLua/Window/ItemMarket/ItemMarket_00.dds")
    ItemBG:ChangeClickTextureInfoName("New_UI_Common_forLua/Window/ItemMarket/ItemMarket_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(ItemBG, bgTexture[bgType][0][1], bgTexture[bgType][0][2], bgTexture[bgType][0][3], bgTexture[bgType][0][4])
    ItemBG:getBaseTexture():setUV(x1, y1, x2, y2)
    ItemBG:setRenderTexture(ItemBG:getBaseTexture())
    local x1, y1, x2, y2 = setTextureUV_Func(ItemBG, bgTexture[bgType][1][1], bgTexture[bgType][1][2], bgTexture[bgType][1][3], bgTexture[bgType][1][4])
    ItemBG:getOnTexture():setUV(x1, y1, x2, y2)
    local x1, y1, x2, y2 = setTextureUV_Func(ItemBG, bgTexture[bgType][2][1], bgTexture[bgType][2][2], bgTexture[bgType][2][3], bgTexture[bgType][2][4])
    ItemBG:getClickTexture():setUV(x1, y1, x2, y2)
  end
end
function HandleClicked_ItemMarketItemSet_RegistCancle(itemEnchantKeyRaw, index)
  if Panel_Win_System:GetShow() then
    return
  end
  local self = ItemMarketItemSet
  local function doCancel()
    requestCancelMyRegistedItemForItemMarket(itemEnchantKeyRaw, index)
    return
  end
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTCANCEL_DO")
  local messageBoxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = doCancel,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData, "middle")
end
function HandleClicked_ItemMarketItemSet_ItemWithdrawals(itemEnchantKeyRaw, index)
  if Panel_Win_System:GetShow() then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local myItemInfo = getItemMarketMyItemByIndex(index)
  if nil == myItemInfo then
    return
  end
  local iess = myItemInfo:getItemEnchantStaticStatusWrapper()
  if nil == iess then
    return
  end
  local isPremiumUser = false
  if true == selfPlayer:get():isApplyChargeSkill(UI_BUFFTYPE.eUserChargeType_PremiumPackage) then
    isPremiumUser = true
  end
  local isCountryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_PCROOMMEMO", "forPremium", requestGetRefundPercentForPremiumPackage())
  if 5 == getGameServiceType() or 6 == getGameServiceType() then
    isCountryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_PCROOMMEMO_JP", "pcRoom", requestGetRefundPercentForPcRoom())
  end
  local itemTotalPrice = myItemInfo:getTradedTotalPrice()
  local function ItemWithdrawalsExecute()
    local toWhereType = CppEnums.ItemWhereType.eInventory
    if ItemMarketItemSet.btn_Warehouse:IsCheck() or toInt64(0, 500000) <= itemTotalPrice then
      toWhereType = CppEnums.ItemWhereType.eWarehouse
    end
    requestWithdrawSellingItemMoneyForItemMarket(itemEnchantKeyRaw, index, toWhereType)
  end
  if false == isPremiumUser and false == iess:get():isCash() then
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
    local messageBoxMemo = isCountryTypeSet
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = ItemWithdrawalsExecute,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "middle")
  else
    ItemWithdrawalsExecute()
  end
end
function ItemMarketSetItem_GetAllItemCheck()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if 0 == getItemMarketMyItemsCount() then
    return
  end
  local isPremiumUser = false
  if true == selfPlayer:get():isApplyChargeSkill(UI_BUFFTYPE.eUserChargeType_PremiumPackage) then
    isPremiumUser = true
  end
  local isCountryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKETSET_GETALLITEMDESC_MEMOBOX", "forPremium", requestGetRefundPercentForPremiumPackage())
  if isGameTypeJapan() then
    isCountryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_PCROOMMEMO_JP", "pcRoom", requestGetRefundPercentForPcRoom())
  end
  if false == isPremiumUser then
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
    local messageBoxMemo = isCountryTypeSet
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = ItemMarketSetItem_GetAllItem,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    ItemMarketSetItem_GetAllItem()
  end
end
function ItemMarketSetItem_GetAllItem()
  local myItemCount = getItemMarketMyItemsCount()
  local toWhereType
  for i = 0, myItemCount - 1 do
    local myItemInfo = getItemMarketMyItemByIndex(i)
    if nil ~= myItemInfo then
      local iess = myItemInfo:getItemEnchantStaticStatusWrapper()
      if nil ~= iess and myItemInfo:isTraded() then
        toWhereType = CppEnums.ItemWhereType.eInventory
        if ItemMarketItemSet.btn_Warehouse:IsCheck() or toInt64(0, 500000) <= myItemInfo:getTradedTotalPrice() then
          toWhereType = CppEnums.ItemWhereType.eWarehouse
        end
        requestWithdrawSellingItemMoneyForItemMarket(iess:get()._key:get(), i, toWhereType)
      end
    end
  end
  requestItemMarketMyItems(false, false)
  ItemMarketItemSet:Update()
end
function HandleClicked_ItemMarketItemSet_ItemSettlement(itemEnchantKeyRaw, index)
  if Panel_Win_System:GetShow() then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local myItemInfo = getItemMarketMyItemByIndex(index)
  if nil == myItemInfo then
    return
  end
  local iess = myItemInfo:getItemEnchantStaticStatusWrapper()
  if nil == iess then
    return
  end
  local isPremiumUser = false
  if true == selfPlayer:get():isApplyChargeSkill(UI_BUFFTYPE.eUserChargeType_PremiumPackage) then
    isPremiumUser = true
  end
  local isCountryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_PCROOMMEMO", "forPremium", requestGetRefundPercentForPremiumPackage())
  if isGameTypeJapan() then
    isCountryTypeSet = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_PCROOMMEMO_JP", "pcRoom", requestGetRefundPercentForPcRoom())
  end
  local function doSettlement()
    local toWhereType = CppEnums.ItemWhereType.eInventory
    local myItemInfo = getItemMarketMyItemByIndex(index)
    local itemTotalPrice = myItemInfo:getTradedTotalPrice()
    if ItemMarketItemSet.btn_Warehouse:IsCheck() or itemTotalPrice >= toInt64(0, 500000) then
      toWhereType = CppEnums.ItemWhereType.eWarehouse
    end
    requestWithdrawSellingItemMoneyForItemMarket(itemEnchantKeyRaw, index, toWhereType)
    requestItemMarketMyItems(false, false)
    ItemMarketItemSet:Update()
  end
  if false == isPremiumUser and not iess:get():isCash() then
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
    local messageBoxMemo = isCountryTypeSet
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = doSettlement,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "middle")
  else
    doSettlement()
  end
end
function HandleClicked_ItemMarketRegistItem_Open()
  FGlobal_ItemMarketRegistItem_Open()
end
function HandleClicked_ItemMarketItemSet_Close()
  FGlobal_ItemMarketItemSet_Close()
end
function ItemMarketItemSet_ToolTip(isShow, idx, iconType)
  local self = ItemMarketItemSet
  local name = ""
  local desc = ""
  local uiControl
  local contents = self._list2:GetContentByKey(toInt64(0, idx))
  if nil ~= contents then
    local averagePrice_Title = UI.getChildControl(contents, "Template_Static_AveragePrice_TitleIcon")
    local recentPrice_Title = UI.getChildControl(contents, "Template_Static_RecentPrice_TitleIcon")
    local sellPrice_Title = UI.getChildControl(contents, "Template_Static_SellPrice_TitleIcon")
    local registPeriod_Title = UI.getChildControl(contents, "Template_Static_RegistPeriod_TitleIcon")
    local sellCountIcon = UI.getChildControl(contents, "Template_Static_SellCountIcon")
    local sellCompleteIcon = UI.getChildControl(contents, "Template_Static_SellCompleteIcon")
    if 0 == iconType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_AVGPRICE_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_AVGPRICE_DESC")
      uiControl = averagePrice_Title
    elseif 1 == iconType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_RECENTPRICE_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_RECENTPRICE_DESC")
      uiControl = recentPrice_Title
    elseif 2 == iconType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_SELLPRICE_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_SELLPRICE_DESC")
      uiControl = sellPrice_Title
    elseif 3 == iconType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_REGISTPERIOD_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_REGISTPERIOD_DESC")
      uiControl = registPeriod_Title
    elseif 4 == iconType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_SELLCOUNTITEM_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_SELLCOUNTITEM_DESC")
      uiControl = sellCountIcon
    elseif 5 == iconType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_SELLCOMPLETE_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_SELLCOMPLETE_DESC")
      uiControl = sellCompleteIcon
    end
    if true == isShow then
      TooltipSimple_Show(uiControl, name, desc)
    else
      TooltipSimple_Hide()
    end
  else
    TooltipSimple_Hide()
  end
end
function FGlobal_ItemMarketMyItems_Update()
  ItemMarketItemSet:SetPosition()
  ItemMarketItemSet:Update()
end
function FGlobal_ItemMarketItemSet_Open()
  if Panel_Window_ItemMarket_ItemSet:GetShow() then
    return
  end
  if Panel_Window_ItemMarket:GetShow() then
    FGolbal_ItemMarketNew_Close()
  end
  if Panel_ItemMarket_AlarmList:GetShow() then
    FGlobal_ItemMarketAlarmList_Close()
  end
  if Panel_Window_ItemMarket_BuyConfirm:GetShow() then
    FGlobal_ItemMarket_BuyConfirm_Close()
  end
  if Panel_Window_ItemMarket_RegistItem:GetShow() then
    FGlobal_ItemMarketRegistItem_Close()
  end
  if Panel_ItemMarket_PreBid_Manager:GetShow() then
    FGlobal_ItemMarketPreBid_Manager_Close()
  end
  local self = ItemMarketItemSet
  self.invenMoney:SetShow(true)
  self.warehouseMoney:SetShow(true)
  self.btn_Inven:SetShow(true)
  self.btn_Inven:SetEnableArea(0, 0, 215, self.btn_Inven:GetSizeY())
  self.btn_Warehouse:SetShow(true)
  self.btn_Warehouse:SetEnableArea(0, 0, 215, self.btn_Warehouse:GetSizeY())
  self.btn_Inven:SetCheck(false)
  self.btn_Warehouse:SetCheck(true)
  if not _ContentsGroup_RenewUI_ItemMarketPlace_Only then
    self.btn_RegistItem:SetShow(true)
  else
    self.btn_RegistItem:SetShow(false)
  end
  self.btn_GetAll:SetShow(true)
  self:SetPosition()
  self:Open()
end
function FGlobal_ItemMarketItemSet_Open_ForWorldMap(escMenu)
  local self = ItemMarketItemSet
  if Panel_Window_ItemMarket_ItemSet:GetShow() then
    return
  end
  if Panel_Window_ItemMarket:GetShow() then
    FGolbal_ItemMarketNew_Close()
  end
  if Panel_Window_ItemMarket_BuyConfirm:GetShow() then
    FGlobal_ItemMarket_BuyConfirm_Close()
  end
  self.invenMoney:SetShow(false)
  self.warehouseMoney:SetShow(false)
  self.btn_Inven:SetShow(false)
  self.btn_Warehouse:SetShow(false)
  self.btn_RegistItem:SetShow(false)
  self.btn_GetAll:SetShow(false)
  self:SetPosition()
  self:Open(escMenu)
  if Panel_Window_ItemMarket:IsUISubApp() then
    Panel_Window_ItemMarket_ItemSet:OpenUISubApp()
  end
  if Panel_Window_ItemMarket:GetShow() then
    FGolbal_ItemMarketNew_Close()
  end
end
function ItemMarketItemSet_SimpleToolTips(tipType, isShow)
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_INVEN_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_INVEN_DESC")
    control = ItemMarketItemSet.btn_Inven
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_WAREHOUSE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_WAREHOUSE_DESC")
    control = ItemMarketItemSet.btn_Warehouse
  end
  if true == isShow then
    registTooltipControl(control, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function FGlobal_ItemMarketItemSet_Close()
  _ItemMarketItemSet_HideToolTip()
  Panel_Window_ItemMarket_ItemSet:SetShow(false, false)
  Panel_Window_ItemMarket_ItemSet:CloseUISubApp()
end
function ItemMarketItemSet_UpdateMoney()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_UPDATEMONEY_ACK"), 5)
end
function ItemMarketItemSet_UpdateMoneyByWarehouse()
  ItemMarketItemSet.invenMoney:SetText(makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()))
  ItemMarketItemSet.warehouseMoney:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
end
function ItemMarketSetItem_GetAllItem_Simpletooltip(isShow)
  if nil == isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKETITEMSET_SIMPLETOOLTIP_GETALLITEM_NAME")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKETITEMSET_SIMPLETOOLTIP_GETALLITEM_DESC")
  control = ItemMarketItemSet.btn_GetAll
  TooltipSimple_Show(control, name, desc)
end
function _ItemMarketItemSet_SimpleToolTip(isShow, idx)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local self = ItemMarketItemSet
  local name, desc, control
  local control = self._list2
  local contents = control:GetContentByKey(toInt64(0, idx))
  local BTN_RegistCancle = UI.getChildControl(contents, "Template_Button_RegistCancle")
  name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTWAITCANCEL")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_REGISTWAIT_DESC")
  control = BTN_RegistCancle
  TooltipSimple_Show(control, name, desc)
end
function ItemMarketItemSet:registEventHandler()
  self.btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketItemSet_Close()")
  self.btn_RegistItem:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketRegistItem_Open()")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"ItemMarket\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"ItemMarket\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"ItemMarket\", \"false\")")
  self.btn_Inven:addInputEvent("Mouse_On", "ItemMarketItemSet_SimpleToolTips( 0, true )")
  self.btn_Inven:addInputEvent("Mouse_Out", "ItemMarketItemSet_SimpleToolTips( false )")
  self.btn_Warehouse:addInputEvent("Mouse_On", "ItemMarketItemSet_SimpleToolTips( 1, true )")
  self.btn_Warehouse:addInputEvent("Mouse_Out", "ItemMarketItemSet_SimpleToolTips( false )")
  self.btn_Inven:setTooltipEventRegistFunc("ItemMarketItemSet_SimpleToolTips( 0, true )")
  self.btn_Warehouse:setTooltipEventRegistFunc("ItemMarketItemSet_SimpleToolTips( 1, true )")
end
function ItemMarketItemSet:registMessageHandler()
  registerEvent("FromClient_InventoryUpdate", "ItemMarketItemSet_UpdateMoneyByWarehouse")
  registerEvent("EventWarehouseUpdate", "ItemMarketItemSet_UpdateMoneyByWarehouse")
  registerEvent("FromClient_WarehousePushMoney", "ItemMarketItemSet_UpdateMoney")
end
ItemMarketItemSet:Initialize()
ItemMarketItemSet:registEventHandler()
ItemMarketItemSet:registMessageHandler()

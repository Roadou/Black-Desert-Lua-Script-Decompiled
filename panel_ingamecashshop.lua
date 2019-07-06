local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_PLT = CppEnums.CashPurchaseLimitType
local UI_CCC = CppEnums.CashProductCategory
local IM = CppEnums.EProcessorInputMode
local UI_SERVICE_RESOURCE = CppEnums.ServiceResourceType
Panel_IngameCashShop:SetShow(false, false)
local renderMode = RenderModeWrapper.new(100, {
  Defines.RenderMode.eRenderMode_InGameCashShop
}, false)
local inGameShop = {
  _config = {
    _slot = {
      _startX = 15,
      _startY = 238,
      _gapY = 70
    },
    _tab = {
      _startX = 719,
      _startY = 0,
      _gapY = 56,
      _gapYY = 65
    },
    _item = {
      _startX = 0,
      _startY = 25,
      _gapX = 35
    },
    _relatedItem = {
      _startX = 0,
      _startY = 25,
      _gapX = 35
    },
    _desc = {_startY = 140, _gapY = 25},
    _subButton = {_startY = 87, _gapY = 38},
    _subButtonSize = {_BigX = 303, _SmallX = 121}
  },
  _const = {
    _sortTypeAsc = 1,
    _sortTypeDesc = 2,
    _cashProductCategoryNo_Undefined = -1
  },
  _hotAndNewStartPosX,
  _hotAndNew_Showable_New = true,
  _hotAndNew_Showable_Hot = true,
  _hotAndNew_Showable_Event = true,
  _hotAndNew_Showable_Sale = true,
  _hotAndNew_Showable_Limited = true,
  _static_TopLineBG = UI.getChildControl(Panel_IngameCashShop, "Static_TopLineBG"),
  _static_PromotionBanner = UI.getChildControl(Panel_IngameCashShop, "Static_PromotionBanner"),
  _static_GradationTop = UI.getChildControl(Panel_IngameCashShop, "Static_Gradation_Top"),
  _static_GradationBottom = UI.getChildControl(Panel_IngameCashShop, "Static_Gradation_Bottom"),
  _staticText_CashCount = UI.getChildControl(Panel_IngameCashShop, "StaticText_NowCashCount"),
  _staticText_PearlCount = UI.getChildControl(Panel_IngameCashShop, "StaticText_NowPearlCount"),
  _staticText_SilverCount = UI.getChildControl(Panel_IngameCashShop, "StaticText_SilverCount"),
  _staticText_MileageCount = UI.getChildControl(Panel_IngameCashShop, "StaticText_MileageCount"),
  _static_SideLineLeft = UI.getChildControl(Panel_IngameCashShop, "Static_SideLineLeft"),
  _static_SideLineRight = UI.getChildControl(Panel_IngameCashShop, "Static_SideLineRight"),
  _scroll_IngameCash = UI.getChildControl(Panel_IngameCashShop, "Scroll_IngameCash"),
  _static_ScrollArea = UI.getChildControl(Panel_IngameCashShop, "Static_ScrollArea"),
  _static_ScrollArea1 = UI.getChildControl(Panel_IngameCashShop, "Static_ScrollArea_1"),
  _static_ScrollArea2 = UI.getChildControl(Panel_IngameCashShop, "Static_ScrollArea_2"),
  _static_Construction = UI.getChildControl(Panel_IngameCashShop, "Static_Construction"),
  _edit_Search = UI.getChildControl(Panel_IngameCashShop, "Edit_GoodsName"),
  _button_Search = UI.getChildControl(Panel_IngameCashShop, "Button_Search"),
  _combo_Class = UI.getChildControl(Panel_IngameCashShop, "Combobox_ClassSort"),
  _combo_Sort = UI.getChildControl(Panel_IngameCashShop, "Combobox_PriceSort"),
  _combo_SubFilter = UI.getChildControl(Panel_IngameCashShop, "Combobox_SubFilter"),
  _haveCashBoxBG = UI.getChildControl(Panel_IngameCashShop, "Static_HaveCashBoxBG"),
  _pearlBox = UI.getChildControl(Panel_IngameCashShop, "Static_PearlBox"),
  _nowPearlIcon = UI.getChildControl(Panel_IngameCashShop, "Static_NowPearlIcon"),
  _silverBox = UI.getChildControl(Panel_IngameCashShop, "Static_SilverBox"),
  _silver = UI.getChildControl(Panel_IngameCashShop, "Static_SilverIcon"),
  _mileageBox = UI.getChildControl(Panel_IngameCashShop, "Static_MileageBox"),
  _mileage = UI.getChildControl(Panel_IngameCashShop, "Static_MileageIcon"),
  _cashBox = UI.getChildControl(Panel_IngameCashShop, "Static_CashBox"),
  _nowCash = UI.getChildControl(Panel_IngameCashShop, "Static_CashIcon"),
  _btn_BuyPearl = UI.getChildControl(Panel_IngameCashShop, "Button_BuyPearl"),
  _btn_BuyDaum = UI.getChildControl(Panel_IngameCashShop, "Button_BuyDaum"),
  _btn_RefreshCash = UI.getChildControl(Panel_IngameCashShop, "Button_RefreshCash"),
  _btn_HowUsePearl = UI.getChildControl(Panel_IngameCashShop, "Button_PearlHowUse"),
  _radioButton_New = UI.getChildControl(Panel_IngameCashShop, "RadioButton_New"),
  _radioButton_Hot = UI.getChildControl(Panel_IngameCashShop, "RadioButton_Hot"),
  _radioButton_Event = UI.getChildControl(Panel_IngameCashShop, "RadioButton_Event"),
  _radioButton_Sale = UI.getChildControl(Panel_IngameCashShop, "RadioButton_Sale"),
  _radioButton_Limited = UI.getChildControl(Panel_IngameCashShop, "RadioButton_Limited"),
  _remainHotDealTime = UI.getChildControl(Panel_IngameCashShop, "StaticText_RemainHotDealTime"),
  desc = {
    _static_ItemNameCombo = nil,
    _staticText_Title = nil,
    _static_SlotBG = nil,
    _static_Slot = nil,
    _static_Desc = nil,
    _staticText_ProductInfo_Title = nil,
    _staticText_PurchaseLimit = nil,
    _static_VestedDesc = nil,
    _static_TradeDesc = nil,
    _static_ClassDesc = nil,
    _static_WarningDesc = nil,
    _static_DiscountPeriodDesc = nil,
    _static_ItemListTitle = nil,
    _static_RelatedItemTitle = nil,
    _static_PearlIcon = nil,
    _static_PearOriginalPrice = nil,
    _static_PearlPrice = nil,
    _btn_BigBuy = nil,
    _btn_BigBuy_M = nil,
    _btn_BigBuy_C = nil,
    _btn_BigBuy_Silver = nil,
    _btn_BigCart = nil,
    _btn_BigGift = nil,
    _btn_BigECart = nil,
    _btn_BigECartSlot = nil
  },
  _subItemButton = Array.new(),
  _subItemCount = 20,
  _endSunPositionY = 0,
  _bigButtonCount = 0,
  _smallButtonCount = 0,
  _skipCount = 0,
  _itemCount = 20,
  _items = Array.new(),
  _relatedItems = Array.new(),
  _comboList = Array.new(),
  _listComboCount = 1,
  _listComboIncludeDummyCount = 1,
  itemDescDetailSize = 0,
  _chooseProductList = Array.new(),
  _chooseProductListCount = 10,
  _chooseProductClickList = Array.new(),
  _endChoosePositionY = 0,
  _openFunction = false,
  _openProductKeyRaw = -1,
  _categoryWeb = nil,
  _promotionWeb = nil,
  _promotionSizeY = 0,
  _promotionTab = {},
  _myCartTab = {},
  _tabCount = getCashMainCategorySize(),
  _slotCount = 30,
  _sortCount = 3,
  _slots = Array.new(),
  _tabs = Array.new(),
  _subTapSelect = nil,
  _list = Array.new(),
  _listCount = 0,
  _currentTab = nil,
  _previousTab = nil,
  _openByEventAlarm = false,
  _currentPos = 0,
  _position = 0,
  _maxDescSize = 200,
  _checkTab = false,
  _pricePosX = 0,
  _currentIndex = 0,
  _isClick = false,
  _isSubItemClick = false,
  _categoryProductKeyRaw = -1,
  _currentProductKeyRaw = -1,
  _cashProductNoData = -1,
  _cashProductIndex = 1,
  _ViewingRecommend = false,
  _static_EquipSlots = Array.new(),
  _isSubTabShow = false,
  _isHotAndNewOpen = false,
  _isForcedOpenSaleTab = false,
  _hotDealTabIndex = 2,
  _isHotDealOpen = false,
  _isOpenFromHotDeal = false,
  defaultPearlIconSize = 0,
  defaultOriginalPriceSize = 0,
  defaultPriceArrowSize = 0
}
inGameShop._scrollBTN_IngameCash = UI.getChildControl(inGameShop._scroll_IngameCash, "Scroll_CtrlButton")
inGameShop._combo_ClassList = UI.getChildControl(inGameShop._combo_Class, "Combobox_List")
inGameShop._combo_SubFilterList = UI.getChildControl(inGameShop._combo_SubFilter, "Combobox_List")
inGameShop._combo_SortList = UI.getChildControl(inGameShop._combo_Sort, "Combobox_List")
inGameShop._goodDescBG = UI.getChildControl(inGameShop._static_ScrollArea, "Static_GoodsDescBG")
inGameShop._hotAndNewControlList = {
  [0] = inGameShop._radioButton_New,
  [1] = inGameShop._radioButton_Hot,
  [2] = inGameShop._radioButton_Event,
  [3] = inGameShop._radioButton_Sale,
  [4] = inGameShop._radioButton_Limited
}
inGameShop._hotAndNewShowableList = {
  [0] = inGameShop._hotAndNew_Showable_New,
  [1] = inGameShop._hotAndNew_Showable_Hot,
  [2] = inGameShop._hotAndNew_Showable_Event,
  [3] = inGameShop._hotAndNew_Showable_Sale,
  [4] = inGameShop._hotAndNew_Showable_Limited
}
local _AllBG = UI.getChildControl(Panel_IngameCashShop, "Static_AllBG")
local tabId = {
  promotionTab = 0,
  cart = inGameShop._tabCount + 1
}
local tabIndexList = Array.new()
local tabIndexInfo = {
  DisplayOrder = 1,
  NoRaw = 2,
  TabImageNo = 3,
  IconPath = 4,
  CategoryType = 5
}
local tabIconTexture1 = {
  [0] = {
    0,
    0,
    38,
    38
  },
  {
    39,
    0,
    77,
    38
  },
  {
    78,
    0,
    122,
    43
  }
}
local tagTexture = {
  [0] = {
    0,
    0,
    0,
    0
  },
  {
    4,
    3,
    238,
    67
  },
  {
    4,
    70,
    238,
    134
  },
  {
    278,
    246,
    512,
    310
  },
  {
    4,
    204,
    238,
    268
  },
  {
    274,
    443,
    508,
    507
  },
  {
    4,
    137,
    238,
    201
  },
  {
    139,
    433,
    373,
    497
  }
}
local soldoutTexture = {
  0,
  0,
  234,
  64
}
local contry = {
  kr = 0,
  jp = 1,
  ru = 2,
  kr2 = 3,
  tw = 4,
  tr = 5,
  id = 6,
  na = 7,
  sa = 8
}
local cashIconType = {
  cash = 0,
  pearl = 1,
  mileage = 2,
  silver = 3
}
local cashIconTexture = {
  [cashIconType.cash] = {
    [0] = {
      21,
      24,
      40,
      43
    },
    {
      61,
      24,
      80,
      43
    },
    {
      21,
      24,
      40,
      43
    },
    {
      1,
      24,
      20,
      43
    },
    {
      21,
      24,
      40,
      43
    },
    {
      21,
      24,
      40,
      43
    },
    {
      21,
      24,
      40,
      43
    },
    {
      41,
      24,
      60,
      43
    },
    {
      41,
      24,
      60,
      43
    }
  },
  [cashIconType.pearl] = {
    [0] = {
      81,
      24,
      100,
      43
    },
    {
      81,
      24,
      100,
      43
    },
    {
      81,
      24,
      100,
      43
    },
    {
      81,
      24,
      100,
      43
    },
    {
      81,
      24,
      100,
      43
    },
    {
      81,
      24,
      100,
      43
    },
    {
      81,
      24,
      100,
      43
    },
    {
      81,
      24,
      100,
      43
    },
    {
      81,
      24,
      100,
      43
    }
  },
  [cashIconType.mileage] = {
    [0] = {
      1,
      1,
      23,
      23
    },
    {
      1,
      1,
      23,
      23
    },
    {
      1,
      1,
      23,
      23
    },
    {
      70,
      1,
      92,
      23
    },
    {
      1,
      1,
      23,
      23
    },
    {
      47,
      1,
      69,
      23
    },
    {
      24,
      1,
      46,
      23
    },
    {
      24,
      1,
      46,
      23
    },
    {
      1,
      1,
      23,
      23
    }
  },
  [cashIconType.silver] = {
    [0] = {
      0,
      0,
      30,
      30
    },
    {
      0,
      0,
      30,
      30
    },
    {
      0,
      0,
      30,
      30
    },
    {
      0,
      0,
      30,
      30
    },
    {
      0,
      0,
      30,
      30
    },
    {
      0,
      0,
      30,
      30
    },
    {
      0,
      0,
      30,
      30
    },
    {
      0,
      0,
      30,
      30
    },
    {
      0,
      0,
      30,
      30
    }
  }
}
local subFilterList = {
  furnitureSet = 0,
  furnitureOnePiece = 1,
  Chandelier = 2,
  floor = 3,
  wall = 4,
  furnitureEtc = 5,
  avartarSet = 6,
  avartarOnePiece = 7,
  underWear = 8,
  accessoryHead = 9,
  accessoryEyes = 10,
  accessoryMouse = 11
}
local subFilterCount = 12
local subFilterListReplace = {
  [subFilterList.furnitureSet] = {
    id = 1,
    str = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_FURNITURE_FURNITURESET")
  },
  [subFilterList.furnitureOnePiece] = {
    id = 2,
    str = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_TAB_4")
  },
  [subFilterList.Chandelier] = {
    id = 3,
    str = PAGetString(Defines.StringSheet_GAME, "HOUSINGMODE_OBJECT_CHANDELIER")
  },
  [subFilterList.floor] = {
    id = 4,
    str = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_FURNITURE_FLOOR")
  },
  [subFilterList.wall] = {
    id = 5,
    str = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_FURNITURE_WALL")
  },
  [subFilterList.furnitureEtc] = {
    id = 6,
    str = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_FURNITURE_FURNITUREETC")
  },
  [subFilterList.avartarSet] = {
    id = 11,
    str = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_AVARTAR_AVARTARSET")
  },
  [subFilterList.avartarOnePiece] = {
    id = 12,
    str = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_AVARTAR_AVARTAR_PIECE")
  },
  [subFilterList.underWear] = {
    id = 13,
    str = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_UNDERWEAR")
  },
  [subFilterList.accessoryHead] = {
    id = 14,
    str = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_HEAD")
  },
  [subFilterList.accessoryEyes] = {
    id = 15,
    str = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_EYES")
  },
  [subFilterList.accessoryMouse] = {
    id = 16,
    str = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_MOUSE")
  }
}
local eCountryType = CppEnums.CountryType
local gameServiceType = getGameServiceType()
local isKorea = eCountryType.NONE == gameServiceType or eCountryType.DEV == gameServiceType or eCountryType.KOR_ALPHA == gameServiceType or eCountryType.KOR_REAL == gameServiceType or eCountryType.KOR_TEST == gameServiceType
local isNaver = CppEnums.MembershipType.naver == getMembershipType()
local nilIconPath = "New_Icon/03_ETC/item_unknown.dds"
local nilProductIconPath = "New_Icon/09_Cash/03_Product/00021034.dds"
local disCountSetUse = false
local isTaiwanNation = false
function InGameShop_GameTypeCheck()
  if isGameTypeEnglish() then
    disCountSetUse = true
  else
    disCountSetUse = false
  end
  if isGameTypeTaiwan() then
    isTaiwanNation = true
  elseif isGameTypeTR() or isGameTypeTH() or isGameTypeID() then
    isTaiwanNation = true
  elseif isGameTypeKorea() then
    isTaiwanNation = true
  else
    isTaiwanNation = false
  end
end
local function tag_changeTexture(slot, tagType)
  local control = slot.tag
  if 7 == tagType then
    control:ChangeTextureInfoName("new_ui_common_forlua/window/ingamecashshop/CashShop_04.dds")
  else
    control:ChangeTextureInfoName("new_ui_common_forlua/window/ingamecashshop/CashShop_03.dds")
  end
  local x1, y1, x2, y2 = setTextureUV_Func(control, tagTexture[tagType][1], tagTexture[tagType][2], tagTexture[tagType][3], tagTexture[tagType][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
local function sale_changeTexture(slot)
  local control = slot.soldout
  control:ChangeTextureInfoName("new_ui_common_forlua/window/ingamecashshop/CashShop_SoldOutBanner_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, soldoutTexture[1], soldoutTexture[2], soldoutTexture[3], soldoutTexture[4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function cashIcon_changeTexture(control, contry)
  control:ChangeTextureInfoName("Combine/Icon/Combine_Cashshop_Icon_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, cashIconTexture[cashIconType.cash][contry][1], cashIconTexture[cashIconType.cash][contry][2], cashIconTexture[cashIconType.cash][contry][3], cashIconTexture[cashIconType.cash][contry][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function cashIcon_changeTextureForList(control, contry, iconType)
  local cashIconPath = ""
  if cashIconType.cash == iconType or cashIconType.pearl == iconType or cashIconType.mileage == iconType then
    cashIconPath = "Combine/Icon/Combine_Cashshop_Icon_00.dds"
  elseif cashIconType.silver == iconType then
    cashIconPath = "new_ui_common_forlua/window/inventory/silver.dds"
  end
  control:ChangeTextureInfoName(cashIconPath)
  local x1, y1, x2, y2 = setTextureUV_Func(control, cashIconTexture[iconType][contry][1], cashIconTexture[iconType][contry][2], cashIconTexture[iconType][contry][3], cashIconTexture[iconType][contry][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function InGameShop_SortTap(lhs, rhs)
  return lhs[1] < rhs[1]
end
function inGameShop:sortTapData()
  table.sort(tabIndexList, InGameShop_SortTap)
end
function inGameShop:init()
  local tabConfig = self._config._tab
  local slotConfig = self._config._slot
  local maxSlotCount = self._slotCount
  local count = 0
  local classCount = getCharacterClassCount()
  self._combo_Class:setListTextHorizonCenter()
  self._combo_Sort:setListTextHorizonCenter()
  self._combo_SubFilter:setListTextHorizonCenter()
  self._combo_Class:DeleteAllItem()
  self._combo_Class:AddItemWithKey(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_CLASSBASE"), getCharacterClassCount())
  for ii = 0, classCount - 1 do
    local classType = getCharacterClassTypeByIndex(ii)
    local className = getCharacterClassName(classType)
    if nil ~= className and "" ~= className and " " ~= className then
      self._combo_Class:AddItemWithKey(className, classType)
      count = count + 1
    end
  end
  self._combo_ClassList:SetSize(self._combo_ClassList:GetSizeX(), count * 25)
  self._combo_ClassList:SetEnableArea(0, 0, self._combo_ClassList:GetSizeX(), count * 25)
  local classControl = self._combo_Class:GetListControl()
  classControl:SetItemQuantity(count + 1)
  self._combo_SubFilter:DeleteAllItem()
  for idx = 0, subFilterCount - 1 do
    self._combo_SubFilter:AddItemWithKey(subFilterListReplace[idx].str, subFilterListReplace[idx].id)
  end
  self._combo_SubFilterList:SetSize(self._combo_SubFilterList:GetSizeX(), subFilterCount * 20)
  self._combo_SubFilterList:SetEnableArea(0, 0, self._combo_SubFilterList:GetSizeX(), subFilterCount * 20)
  local subFilterControl = self._combo_SubFilter:GetListControl()
  subFilterControl:SetItemQuantity(subFilterCount)
  self._combo_Sort:DeleteAllItem()
  for ii = 0, self._sortCount - 1 do
    self._combo_Sort:AddItemWithKey(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_SORT_" .. ii), ii)
  end
  self._combo_SortList:SetSize(self._combo_SortList:GetSizeX(), self._sortCount * 20)
  self._combo_SortList:SetEnableArea(0, 0, self._combo_SortList:GetSizeX(), self._sortCount * 20)
  local sortControl = self._combo_Sort:GetListControl()
  sortControl:SetItemQuantity(self._sortCount)
  for dd = 1, getCashMainCategorySize() do
    local mainTabInfo = ToClient_GetMainCategoryStaticStatusWrapperByKeyRaw(dd)
    if nil ~= mainTabInfo then
      tabIndexList[dd] = {
        mainTabInfo:getDisplayOrder(),
        mainTabInfo:getNoRaw(),
        mainTabInfo:getTabImageNo(),
        mainTabInfo:getIconPath(),
        mainTabInfo:getCategoryType(),
        mainTabInfo:getEventKey(),
        mainTabInfo:getEventSlotKey()
      }
    end
  end
  self:sortTapData()
  for ii = 1, self._tabCount do
    local tab = {}
    tab.static = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "RadioButton_CategoryTab_" .. tostring(tostring(tabIndexList[ii][3])), Panel_IngameCashShop, "InGameShop_Tab_" .. ii)
    tab.text = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "StaticText_Category", tab.static, "InGameShop_Text_" .. ii)
    tab.text:SetTextMode(UI_TM.eTextMode_AutoWrap)
    tab.static:SetText("")
    tab.icon = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "Static_ButtonIcon_0", tab.static, "InGameShop_Tab_Icon_" .. ii)
    _ingameCash_SetTabIconTexture(tab.icon, ii, 0)
    tab.text:SetText(getCashCategoryName(tabIndexList[ii][2], CppEnums.CashProductCategoryNo_Undefined))
    tab.static:addInputEvent("Mouse_LUp", "InGameShop_TabEvent(" .. ii .. ")")
    tab.static:addInputEvent("Mouse_On", "_inGameShop_TabOnOut_ChangeTexture( true, " .. ii .. ")")
    tab.static:addInputEvent("Mouse_Out", "_inGameShop_TabOnOut_ChangeTexture( false, " .. ii .. ")")
    tab.static:SetShow(true)
    self._tabs[ii] = tab
    self._tabs[ii]._subTab = Array.new()
    local subCategoryCount = getCashMiddleCategorySize(tabIndexList[ii][2])
    for jj = 1, subCategoryCount do
      local subtab = {}
      subtab.static = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "Static_SubCategory", Panel_IngameCashShop, "InGameShop_SubTab_" .. ii .. "_" .. jj)
      subtab.text = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "StaticText_SubCategoryName", subtab.static, "InGameShop_SubTabText_" .. ii .. "_" .. jj)
      subtab.text:SetTextMode(UI_TM.eTextMode_LimitText)
      subtab.text:SetText(getCashCategoryName(tabIndexList[ii][2], jj))
      local isSubTabLimit = subtab.text:IsLimitText()
      if isSubTabLimit then
        subtab.text:addInputEvent("Mouse_On", "InGameShop_SubTab_Tooltip(true, " .. ii .. ", " .. jj .. ")")
        subtab.text:addInputEvent("Mouse_Out", "InGameShop_SubTab_Tooltip(false)")
      else
        subtab.text:addInputEvent("Mouse_On", "")
        subtab.text:addInputEvent("Mouse_Out", "")
      end
      subtab.text:addInputEvent("Mouse_LUp", "InGameShop_SubTabEvent(" .. ii .. ", " .. jj .. ")")
      subtab.static:SetShow(false)
      subtab.text:SetShow(false)
      self._tabs[ii]._subTab[jj] = subtab
    end
  end
  local subTapSelect = {}
  subTapSelect.static = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "Static_SelectedSubCategory", Panel_IngameCashShop, "InGameShop_SubTabSelect_" .. 1)
  subTapSelect.static:SetShow(false)
  self._subTapSelect = subTapSelect
  local promotionTab = {}
  promotionTab.static = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "RadioButton_CategoryTab_0", Panel_IngameCashShop, "InGameShop_PromotionTab")
  promotionTab.icon = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "Static_ButtonIcon_0", promotionTab.static, "InGameShop_PromotionTab_Icon")
  promotionTab.static:SetPosX(tabConfig._startX)
  promotionTab.static:SetPosY(5)
  promotionTab.static:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_PROMOTIONTAB_FIRST"))
  _ingameCash_SetTabIconTexture(promotionTab.icon, tabId.promotionTab, 0)
  promotionTab.static:SetShow(true)
  self._promotionTab = promotionTab
  self._hotAndNewStartPosX = self._radioButton_New:GetPosX()
  for ii = 0, maxSlotCount - 1 do
    local slot = {}
    slot.productNoRaw = nil
    slot.static = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_Static_GoodsBG", self._static_ScrollArea, "InGameShop_Slot_" .. ii)
    slot.productIcon = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_Static_ProductImage", slot.static, "InGameShop_Slot_ProductIcon_" .. ii)
    slot.discountRate = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_StaticText_SaleValue", slot.static, "InGameShop_Slot_ProductDiscountRate_" .. ii)
    slot.tag = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_Static_GoodsHighlightLine", slot.static, "InGameShop_Slot_Tag_" .. ii)
    slot.soldout = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_Static_GoodsSoldout", slot.static, "InGameShop_Slot_Soldout_" .. ii)
    slot.iconBG = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_Static_SlotBG", slot.static, "InGameShop_Slot_IconBG_" .. ii)
    slot.icon = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_Static_Slot", slot.iconBG, "InGameShop_Slot_Icon_" .. ii)
    slot.name = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_StaticText_ItemName", slot.static, "InGameShop_Slot_Name_" .. ii)
    slot.discount = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_StaticText_DiscountPeriod", slot.static, "InGameShop_Slot_DiscountPeriod_" .. ii)
    slot.pearlIcon = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_Static_PearlIcon", slot.static, "InGameShop_Slot_PearlIcon_" .. ii)
    slot.originalPrice = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_StaticText_ItemOriginalPrice", slot.pearlIcon, "InGameShop_Slot_OriginalPrice_" .. ii)
    slot.priceArrow = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_StaticText_ItemPriceArrow", slot.originalPrice, "InGameShop_Slot_PriceArrow_" .. ii)
    slot.price = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_StaticText_ItemPrice", slot.static, "InGameShop_Slot_Price_" .. ii)
    slot.buttonBuy = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_Button_Buy", slot.static, "InGameShop_Slot_Buy_" .. ii)
    slot.buttonGift = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_Button_Gift", slot.static, "InGameShop_Slot_Gift_" .. ii)
    slot.buttonCart = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "TemplateList_Button_Cart", slot.static, "InGameShop_Slot_Cart_" .. ii)
    slot.static:SetChildOrder(slot.tag:GetKey(), slot.discountRate:GetKey())
    slot.static:SetChildOrder(slot.iconBG:GetKey(), slot.discountRate:GetKey())
    slot.static:SetPosX(0)
    slot.static:SetPosY(slotConfig._gapY * ii)
    slot.discount:SetTextMode(UI_TM.eTextMode_Limit_AutoWrap)
    slot.name:SetTextMode(UI_TM.eTextMode_Limit_AutoWrap)
    slot.productIcon:addInputEvent("Mouse_LUp", "IngameCashShop_SelectedItem(" .. ii .. ", 0" .. ")")
    slot.productIcon:addInputEvent("Mouse_UpScroll", "InGameShop_ScrollEvent( true )")
    slot.productIcon:addInputEvent("Mouse_DownScroll", "InGameShop_ScrollEvent( false )")
    slot.static:addInputEvent("Mouse_UpScroll", "InGameShop_ScrollEvent( true )")
    slot.static:addInputEvent("Mouse_DownScroll", "InGameShop_ScrollEvent( false )")
    slot.static:addInputEvent("Mouse_LUp", "IngameCashShop_SelectedItem(" .. ii .. ", 0" .. ")")
    slot.buttonCart:addInputEvent("Mouse_LUp", "IngameCashShop_CartItem(" .. ii .. ")")
    slot.buttonGift:addInputEvent("Mouse_LUp", "IngameCashShop_GiftItem(" .. ii .. ")")
    slot.buttonBuy:addInputEvent("Mouse_LUp", "IngameCashShop_BuyItem(" .. ii .. ")")
    slot.originalPrice:SetPosX(slot.pearlIcon:GetSizeX() + 3)
    slot.originalPrice:SetPosY(1)
    slot.originalPrice:SetLineRender(true)
    slot.originalPrice:SetFontColor(UI_color.C_FF626262)
    slot.price:SetSpanSize(10, 8)
    slot.priceArrow:SetPosY(slot.originalPrice:GetPosY() + 7)
    slot.tag:SetShow(true)
    slot.soldout:SetShow(false)
    slot.static:SetShow(false)
    slot.discountRate:SetShow(false)
    self._slots[ii] = slot
  end
  self._pricePosX = self._slots[0].price:GetPosX()
  self.defaultPearlIconSize = self._slots[0].pearlIcon:GetSpanSize().x
  self.defaultOriginalPriceSize = self._slots[0].originalPrice:GetSpanSize().x
  self.defaultPriceArrowSize = self._slots[0].priceArrow:GetSpanSize().x
  local myCartTab = {}
  myCartTab.static = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "RadioButton_CartTab", Panel_IngameCashShop, "InGameShop_MyCartTab")
  myCartTab.icon = UI.createAndCopyBasePropertyControl(Panel_IngameCashShop, "Static_ButtonIcon_0", myCartTab.static, "InGameShop_MyCartTab_Icon")
  myCartTab.static:SetPosX(tabConfig._startX)
  myCartTab.static:SetPosY(tabConfig._startY + tabConfig._gapY * (tabId.cart - 1))
  myCartTab.static:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_MYCARTTAB"))
  myCartTab.static:SetShow(true)
  _ingameCash_SetTabIconTexture(myCartTab.icon, tabId.cart, 0)
  self._myCartTab = myCartTab
  Panel_IngameCashShop:SetChildIndex(self._combo_Class, 9900)
  Panel_IngameCashShop:SetChildIndex(self._combo_Sort, 9900)
  Panel_IngameCashShop:SetChildIndex(self._combo_SubFilter, 9900)
  self._static_GradationTop:SetPosX(slotConfig._startX)
  self._static_GradationTop:SetPosY(slotConfig._startY)
  self._static_GradationBottom:SetPosX(slotConfig._startX)
  self._static_GradationBottom:SetPosY(self._static_ScrollArea:GetSizeY() + self._static_ScrollArea:GetPosY() - self._static_GradationBottom:GetSizeY())
  FGlobal_Init_IngameCashShop_NewCart(slotConfig._gapY)
  local scrSizeY = getScreenSizeY()
  self._promotionWeb = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_IngameCashShop, "IngameCashShop_PromotionWebLink")
  self._promotionWeb:SetShow(true)
  self._promotionWeb:SetPosX(0)
  self._promotionWeb:SetPosY(0)
  self._promotionWeb:SetSize(709, scrSizeY - 95)
  _AllBG:SetSize(_AllBG:GetSizeX(), scrSizeY - 95)
  self._promotionWeb:ResetUrl()
  Panel_IngameCashShop:SetChildIndex(self._promotionWeb, 9900)
  self._categoryWeb = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, self._static_PromotionBanner, "IngameCashShop_CategoryWebLink")
  self._categoryWeb:SetShow(true)
  self._categoryWeb:SetPosX(0)
  self._categoryWeb:SetPosY(0)
  self._categoryWeb:SetSize(686, 178)
  self._categoryWeb:ResetUrl()
  self._categoryWeb:addInputEvent("Mouse_Out", "ToClient_CategoryWebFocusOut()")
  self._static_PromotionBanner:SetChildIndex(self._categoryWeb, 9900)
  if isGameTypeKorea() then
    cashIcon_changeTexture(self._nowCash, contry.kr)
  elseif isGameTypeJapan() then
    cashIcon_changeTexture(self._nowCash, contry.jp)
  elseif isGameTypeRussia() then
    cashIcon_changeTexture(self._nowCash, contry.ru)
  elseif isGameTypeKR2() then
    cashIcon_changeTexture(self._nowCash, contry.kr2)
    self._btn_BuyPearl:SetShow(false)
    self._cashBox:SetShow(false)
    self._nowCash:SetShow(false)
    self._btn_BuyDaum:SetShow(false)
    self._btn_RefreshCash:SetShow(false)
    self._staticText_CashCount:SetShow(false)
  elseif isGameTypeTaiwan() then
    cashIcon_changeTexture(self._nowCash, contry.tw)
  elseif isGameTypeTR() then
    cashIcon_changeTexture(self._nowCash, contry.tr)
  elseif isGameTypeID() then
    cashIcon_changeTexture(self._nowCash, contry.id)
  elseif isGameTypeSA() or isGameTypeEnglish() then
    cashIcon_changeTexture(self._nowCash, contry.na)
  else
    cashIcon_changeTexture(self._nowCash, contry.kr)
  end
  self._nowPearlIcon:addInputEvent("Mouse_On", "InGameShop_MoneyIcon_Tooltip(true,\t\t0)")
  self._nowPearlIcon:addInputEvent("Mouse_Out", "InGameShop_MoneyIcon_Tooltip(false,\t0)")
  self._mileage:addInputEvent("Mouse_On", "InGameShop_MoneyIcon_Tooltip(true,\t\t1)")
  self._mileage:addInputEvent("Mouse_Out", "InGameShop_MoneyIcon_Tooltip(false,\t1)")
  self._nowCash:addInputEvent("Mouse_On", "InGameShop_MoneyIcon_Tooltip(true,\t\t2)")
  self._nowCash:addInputEvent("Mouse_Out", "InGameShop_MoneyIcon_Tooltip(false,\t2)")
  self._btn_HowUsePearl:addInputEvent("Mouse_LUp", "InGameShop_HowUsePearlShop()")
  self._staticText_SilverCount:SetShow(false)
  self._silverBox:SetShow(false)
  self._silver:SetShow(false)
  _AllBG:SetShow(true)
  Panel_IngameCashShop:SetChildIndex(_AllBG, 9800)
  self._scroll_IngameCash:SetShow(false)
  FGlobal_ClearCandidate()
  inGameShop:isGTServerCheckControl()
end
function inGameShop:isCheckOverlapText(slot)
  local sizeX = slot.pearlIcon:GetPosX() + slot.pearlIcon:GetSizeX() + slot.originalPrice:GetTextSizeX() + slot.priceArrow:GetSizeX()
  local priceSizeX = slot.price:GetPosX() + slot.price:GetSizeX() - slot.price:GetTextSizeX()
  if sizeX >= priceSizeX then
    return true
  end
  return false
end
function inGameShop:isGTServerCheckControl()
  if isGameTypeGT() then
    self._btn_HowUsePearl:SetShow(false)
    self._nowCash:SetShow(false)
    self._staticText_CashCount:SetShow(false)
    self._btn_BuyDaum:SetShow(false)
    self._btn_RefreshCash:SetShow(false)
    self._nowPearlIcon:SetShow(false)
    self._staticText_PearlCount:SetShow(false)
    self._btn_BuyPearl:SetShow(false)
    self._pearlBox:SetShow(false)
    self._cashBox:SetShow(false)
    self._staticText_MileageCount:SetSpanSize(30, 20)
    self._mileageBox:SetSpanSize(20, 15)
    self._mileage:SetSpanSize(110, 20)
  end
end
function FGlobal_CashShop_tabInfo_Return()
  return tabIndexList
end
function inGameShop:RemakeSubFilter(tabIdx)
  local condition = false
  local defaultName = ""
  local settingDefaultName = ""
end
function inGameShop:updateMoney()
  local selfProxy = getSelfPlayer():get()
  local cash = selfProxy:getCash()
  local pearl = Defines.s64_const.s64_0
  local mileage = Defines.s64_const.s64_0
  local pearlItemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, getPearlSlotNo())
  if nil ~= pearlItemWrapper then
    pearl = pearlItemWrapper:get():getCount_s64()
  end
  local mileageItemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, getMileageSlotNo())
  if nil ~= mileageItemWrapper then
    mileage = mileageItemWrapper:get():getCount_s64()
  end
  self._staticText_CashCount:SetText(makeDotMoney(cash))
  self._staticText_PearlCount:SetText(makeDotMoney(pearl))
  self._staticText_MileageCount:SetText(makeDotMoney(mileage))
  return cash, pearl, mileage
end
function inGameShop:getMaxPosition()
  if -1 ~= self._openProductKeyRaw and nil ~= self._openProductKeyRaw then
    return (self._listCount - 1) * self._config._slot._gapY + self._slots[0].static:GetSizeY() - self._static_ScrollArea:GetSizeY() + self._goodDescBG:GetSizeY()
  else
    return (self._listCount - 1) * self._config._slot._gapY + self._slots[0].static:GetSizeY() - self._static_ScrollArea:GetSizeY()
  end
end
function inGameShop:isSelectProductGroup(productNoRaw)
  if self._openProductKeyRaw == productNoRaw then
    return true
  end
  for key, value in pairs(self._comboList) do
    if value == productNoRaw then
      return true
    end
  end
  return false
end
function inGameShop:setElement(index, productNoRaw, slot)
  local maxSlotCount = self._slotCount
  if nil == productNoRaw then
    return false
  end
  local subGroup = 0
  if -1 ~= self._openProductKeyRaw then
    local selectSubItem = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(self._openProductKeyRaw)
    if nil ~= selectSubItem and 0 ~= selectSubItem:getOfferGroup() then
      subGroup = selectSubItem:getOfferGroup()
    end
  end
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNoRaw)
  if nil == cashProduct then
    return false
  end
  slot.productNoRaw = productNoRaw
  local cashGroup = cashProduct:getOfferGroup()
  if 0 ~= cashGroup and subGroup == cashGroup then
    cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(self._openProductKeyRaw)
    productNoRaw = self._openProductKeyRaw
  end
  if self:isSelectProductGroup(productNoRaw) then
    InGameShop_ProductListContent_ChangeTexture(slot, true)
  else
    InGameShop_ProductListContent_ChangeTexture(slot, false)
  end
  if nil == cashProduct:getPackageIcon() then
    slot.productIcon:ChangeTextureInfoName(nilProductIconPath)
  else
    slot.productIcon:ChangeTextureInfoName(cashProduct:getPackageIcon())
  end
  slot.productIcon:SetMonoTone(false)
  slot.soldout:SetShow(false)
  local limitType = cashProduct:getCashPurchaseLimitType()
  if UI_PLT.None ~= limitType then
    local limitCount = cashProduct:getCashPurchaseCount()
    local mylimitCount = getIngameCashMall():getRemainingLimitCount(cashProduct:getNoRaw())
    if limitCount > 0 and mylimitCount == 0 then
      slot.soldout:SetShow(true)
      sale_changeTexture(slot)
      slot.productIcon:SetMonoTone(true)
    end
  end
  tag_changeTexture(slot, cashProduct:getTag())
  if nil == cashProduct:getIconPath() then
    slot.icon:ChangeTextureInfoName("Icon/" .. nilIconPath)
  else
    slot.icon:ChangeTextureInfoName("Icon/" .. cashProduct:getIconPath())
  end
  slot.icon:addInputEvent("Mouse_On", "InGameShop_ProductShowToolTip( " .. cashProduct:getNoRaw() .. ", " .. index .. " )")
  slot.icon:addInputEvent("Mouse_Out", "FGlobal_CashShop_GoodsTooltipInfo_Close()")
  slot.name:SetText(cashProduct:getDisplayName())
  slot.price:SetText(makeDotMoney(cashProduct:getPrice()))
  slot.price:SetPosX(self._pricePosX + 3, slot.price:GetPosY())
  slot.originalPrice:SetShow(false)
  slot.priceArrow:SetShow(false)
  slot.discount:SetText(cashProduct:getDescription())
  slot.discountRate:SetShow(false)
  if cashProduct:isApplyDiscount() then
    local startDiscountTimeValue = PATime(cashProduct:getStartDiscountTime():get_s64())
    local endDiscountTimeValue = PATime(cashProduct:getEndDiscountTime():get_s64())
    local startDiscountTime = tostring(startDiscountTimeValue:GetYear()) .. "." .. tostring(startDiscountTimeValue:GetMonth()) .. "." .. tostring(startDiscountTimeValue:GetDay())
    local endDiscountTime = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTTIME", "GetYear", tostring(endDiscountTimeValue:GetYear()), "GetMonth", tostring(endDiscountTimeValue:GetMonth()), "GetDay", tostring(endDiscountTimeValue:GetDay())) .. " " .. string.format("%.02d", endDiscountTimeValue:GetHour()) .. ":" .. string.format("%.02d", endDiscountTimeValue:GetMinute())
    local countryKind = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTTIME", "GetYear", tostring(endDiscountTimeValue:GetYear()), "GetMonth", tostring(endDiscountTimeValue:GetMonth()), "GetDay", tostring(endDiscountTimeValue:GetDay())) .. " " .. string.format("%.02d", endDiscountTimeValue:GetHour()) .. ":" .. string.format("%.02d", endDiscountTimeValue:GetMinute())
    local remainTime = convertStringFromDatetime(cashProduct:getRemainDiscountTime())
    if true == disCountSetUse then
      countryKind = remainTime
    else
      countryKind = endDiscountTime
    end
    slot.discount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_DISCOUNT", "endDiscountTime", countryKind))
    slot.originalPrice:SetText(makeDotMoney(cashProduct:getOriginalPrice()))
    slot.originalPrice:SetShow(true)
    slot.priceArrow:SetPosX(slot.originalPrice:GetTextSizeX() + 3)
    slot.priceArrow:SetShow(true)
    if true == inGameShop:isCheckOverlapText(slot) then
      local addPos = 10
      slot.pearlIcon:SetSpanSize(self.defaultPearlIconSize + addPos, slot.pearlIcon:GetSpanSize().y)
      slot.originalPrice:SetSpanSize(self.defaultOriginalPriceSize + addPos, slot.originalPrice:GetSpanSize().y)
      slot.priceArrow:SetSpanSize(self.defaultPriceArrowSize + addPos, slot.priceArrow:GetSpanSize().y)
    end
    slot.discountRate:SetShow(0 ~= cashProduct:getDiscountPercent())
    slot.discountRate:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CASHSHOP_DISPLAYPERCET", "percent", cashProduct:getDiscountPercent()))
  end
  local tagType = cashProduct:getTag()
  if (4 == tagType or 5 == tagType) and not cashProduct:isApplyDiscount() and cashProduct:isDefinedDiscount() then
    slot.tag:SetShow(false)
  else
    slot.tag:SetShow(true)
  end
  slot.buttonBuy:SetShow(false)
  slot.buttonGift:SetShow(false)
  slot.buttonCart:SetShow(false)
  InGameShop_ProductListContent_ChangeMoneyIconTexture(slot, cashProduct:getMainCategory(), cashProduct:isMoneyPrice(), false)
  local limitType = cashProduct:getCashPurchaseLimitType()
  if UI_CCC.eCashProductCategory_Pearl == cashProduct:getMainCategory() then
    slot.buttonBuy:SetMonoTone(false)
    slot.buttonGift:SetMonoTone(true)
    slot.buttonCart:SetMonoTone(true)
    slot.buttonBuy:SetEnable(true)
    slot.buttonGift:SetEnable(false)
    slot.buttonCart:SetEnable(false)
  elseif UI_CCC.eCashProductCategory_Mileage == cashProduct:getMainCategory() then
    if UI_PLT.None ~= limitType then
      local limitCount = cashProduct:getCashPurchaseCount()
      local mylimitCount = getIngameCashMall():getRemainingLimitCount(cashProduct:getNoRaw())
      if limitCount > 0 then
        slot.buttonBuy:SetMonoTone(false)
        slot.buttonGift:SetMonoTone(true)
        slot.buttonCart:SetMonoTone(true)
        slot.buttonBuy:SetEnable(true)
        slot.buttonGift:SetEnable(false)
        slot.buttonCart:SetEnable(false)
        if mylimitCount <= 0 then
          slot.buttonBuy:SetMonoTone(true)
          slot.buttonCart:SetMonoTone(true)
          slot.buttonBuy:SetEnable(false)
          slot.buttonCart:SetEnable(false)
        end
      else
        slot.buttonBuy:SetMonoTone(true)
        slot.buttonGift:SetMonoTone(true)
        slot.buttonCart:SetMonoTone(true)
        slot.buttonBuy:SetEnable(false)
        slot.buttonGift:SetEnable(false)
        slot.buttonCart:SetEnable(false)
      end
    else
      slot.buttonBuy:SetMonoTone(false)
      slot.buttonGift:SetMonoTone(true)
      slot.buttonCart:SetMonoTone(true)
      slot.buttonBuy:SetEnable(true)
      slot.buttonGift:SetEnable(false)
      slot.buttonCart:SetEnable(false)
    end
  elseif UI_PLT.None ~= limitType then
    local limitCount = cashProduct:getCashPurchaseCount()
    local mylimitCount = getIngameCashMall():getRemainingLimitCount(cashProduct:getNoRaw())
    if limitCount > 0 then
      slot.buttonBuy:SetMonoTone(false)
      slot.buttonGift:SetMonoTone(true)
      slot.buttonCart:SetMonoTone(false)
      slot.buttonBuy:SetEnable(true)
      slot.buttonGift:SetEnable(false)
      slot.buttonCart:SetEnable(true)
      if mylimitCount <= 0 then
        slot.buttonBuy:SetMonoTone(true)
        slot.buttonCart:SetMonoTone(true)
        slot.buttonBuy:SetEnable(false)
        slot.buttonCart:SetEnable(false)
      end
    else
      slot.buttonBuy:SetMonoTone(true)
      slot.buttonGift:SetMonoTone(true)
      slot.buttonCart:SetMonoTone(true)
      slot.buttonBuy:SetEnable(false)
      slot.buttonGift:SetEnable(false)
      slot.buttonCart:SetEnable(false)
    end
  else
    slot.buttonBuy:SetMonoTone(false)
    slot.buttonGift:SetMonoTone(false)
    slot.buttonCart:SetMonoTone(false)
    slot.buttonBuy:SetEnable(true)
    slot.buttonGift:SetEnable(true)
    slot.buttonCart:SetEnable(true)
  end
  slot.static:SetShow(true)
  if 0 >= self._currentPos then
    self._static_GradationTop:SetShow(false)
  else
    self._static_GradationTop:SetShow(true == self:isGradationShowAble())
  end
  if self:getMaxPosition() <= self._currentPos then
    self._static_GradationBottom:SetShow(false)
  else
  end
  return true
end
function inGameShop:updateSlot()
  local maxSlotCount = self._slotCount
  local index = 0
  local pos = 0
  local areaSizeY = self._static_ScrollArea:GetSizeY()
  local slotSize = self._slots[0].static:GetSizeY()
  local gapBetweenList = self._config._slot._gapY
  local gap = self._config._slot._gapY - slotSize
  for _, slot in pairs(self._slots) do
    slot.static:SetShow(false)
  end
  for ii = 0, self._listCount - 1 do
    local productNoRaw = self._list[ii]
    local slot = self._slots[index]
    if nil == slot then
      return
    end
    slot.static:SetShow(false)
    if pos > self._currentPos + areaSizeY then
    elseif self._currentPos < pos + slotSize and self:setElement(index, productNoRaw, slot) then
      slot.static:SetPosY(pos - self._currentPos)
      index = index + 1
    end
    if self:isSelectProductGroup(productNoRaw) then
      self._goodDescBG:SetShow(false)
      if self._goodDescBG:GetSizeY() < self._maxDescSize and self._position + areaSizeY < pos + slot.static:GetSizeY() + self._goodDescBG:GetSizeY() and 1 < self._goodDescBG:GetSizeY() then
        self._position = pos + slot.static:GetSizeY() + self._goodDescBG:GetSizeY() - areaSizeY
        self._scroll_IngameCash:SetControlPos(self._position / self:getMaxPosition())
      end
      if self._currentPos < pos + slot.static:GetSizeY() + self._goodDescBG:GetSizeY() and pos + slot.static:GetSizeY() < self._currentPos + areaSizeY and 1 < self._goodDescBG:GetSizeY() then
        self._goodDescBG:SetPosY(pos - self._currentPos + slot.static:GetSizeY())
        self._goodDescBG:SetShow(true)
        if 0 < inGameShop._currentTab and inGameShop._currentTab <= getCashMainCategorySize() and true == FGlobal_IngameCashShopEventCart_IsContentsOpen() then
          if 0 < tabIndexList[inGameShop._currentTab][6] and 0 < tabIndexList[inGameShop._currentTab][7] then
            self.desc._btn_BigGift:SetSpanSize(140, 10)
            self.desc._btn_BigECart:SetSpanSize(100, 10)
            self.desc._btn_BigECartSlot:SetSpanSize(60, 10)
          elseif 0 < tabIndexList[inGameShop._currentTab][7] then
            self.desc._btn_BigGift:SetSpanSize(100, 10)
            self.desc._btn_BigECartSlot:SetSpanSize(60, 10)
          elseif 0 < tabIndexList[inGameShop._currentTab][6] then
            self.desc._btn_BigGift:SetSpanSize(100, 10)
            self.desc._btn_BigECart:SetSpanSize(60, 10)
          else
            self.desc._btn_BigGift:SetSpanSize(100, 10)
            self.desc._btn_BigECart:SetSpanSize(60, 10)
            self.desc._btn_BigECartSlot:SetSpanSize(60, 10)
          end
        else
          self.desc._btn_BigGift:SetSpanSize(100, 10)
          self.desc._btn_BigECart:SetSpanSize(60, 10)
          self.desc._btn_BigECartSlot:SetSpanSize(60, 10)
        end
        self.desc._btn_BigCart:SetSpanSize(60, 10)
        self.desc._btn_BigBuy:SetSpanSize(20, 10)
        self.desc._btn_BigBuy_C:SetSpanSize(20, 10)
        self.desc._btn_BigBuy_M:SetSpanSize(20, 10)
        self.desc._btn_BigBuy_Silver:SetSpanSize(20, 10)
        self.desc._static_PearlIcon:SetSpanSize(155, 60)
        self.desc._static_PearlPrice:SetSpanSize(30, 60)
        self.desc._static_PearOriginalPrice:SetSpanSize(self._goodDescBG:GetSizeX() - 153, 59)
      end
      pos = pos + self._goodDescBG:GetSizeY()
    end
    pos = pos + gapBetweenList
  end
end
function inGameShop:initTabPos()
  local tabPosIndex = 1
  self._isHotDealOpen = ToClient_IsHotDealTime()
  for ii = 1, self._tabCount do
    local tabConfig = self._config._tab
    local tab = self._tabs[ii]
    tab.static:SetPosX(tabConfig._startX)
    tab.static:SetPosY(tabConfig._startY + tabConfig._gapY * (tabPosIndex - 1))
    tab.text:SetPosX(40)
    tab.text:SetPosY(5)
    if false == self._isHotDealOpen and ii == self._hotDealTabIndex then
      tab.static:SetShow(false)
    else
      tab.static:SetShow(true)
      tabPosIndex = tabPosIndex + 1
    end
  end
end
function inGameShop:update()
  if Panel_IngameCashShop_NewCart:GetShow() then
    FGlobal_Close_IngameCashShop_NewCart()
  end
  self:updateMoney()
  local initMaxCount = 30
  for ii = 0, initMaxCount - 1 do
    local slot = self._slots[ii]
    slot.productNoRaw = nil
    slot.static:SetShow(false)
  end
  self:updateSlot()
end
function inGameShop:registMessageHandler()
  Panel_IngameCashShop:RegisterUpdateFunc("InGameCashshopUpdatePerFrame")
  self._static_ScrollArea:addInputEvent("Mouse_UpScroll", "InGameShop_ScrollEvent( true  )")
  self._static_ScrollArea:addInputEvent("Mouse_DownScroll", "InGameShop_ScrollEvent( false )")
  self._button_Search:addInputEvent("Mouse_LUp", "InGameShop_Search()")
  self._edit_Search:addInputEvent("Mouse_LUp", "InGameShop_ResetSearchText()")
  self._edit_Search:RegistReturnKeyEvent("InGameShop_Search()")
  self._scrollBTN_IngameCash:addInputEvent("Mouse_LPress", "HandleClicked_InGameShop_SetScrollIndexByLClick()")
  self._scrollBTN_IngameCash:addInputEvent("Mouse_LUp", "HandleClicked_InGameShop_SetScrollIndexByLClick()")
  self._scroll_IngameCash:addInputEvent("Mouse_LUp", "HandleClicked_InGameShop_SetScrollIndexByLClick()")
  self._combo_Class:addInputEvent("Mouse_LUp", "InGameShop_OpenClassList()")
  self._combo_Sort:addInputEvent("Mouse_LUp", "InGameShop_OpenSorList()")
  self._combo_SubFilter:addInputEvent("Mouse_LUp", "InGameShop_OpenSubFilterList()")
  self._combo_Class:GetListControl():addInputEvent("Mouse_LUp", "InGameShop_SelectClass()")
  self._combo_Sort:GetListControl():addInputEvent("Mouse_LUp", "InGameShop_SelectSort()")
  self._combo_SubFilter:GetListControl():addInputEvent("Mouse_LUp", "InGameShop_SelectSubFilter()")
  inGameShop._goodDescBG:addInputEvent("Mouse_UpScroll", "InGameShop_ScrollEvent( true )")
  inGameShop._goodDescBG:addInputEvent("Mouse_DownScroll", "InGameShop_ScrollEvent( false )")
  self._promotionTab.static:addInputEvent("Mouse_LUp", "InGameShop_Promotion_Open()")
  self._promotionTab.static:addInputEvent("Mouse_On", "InGameShop_ShowSimpleToolTip( true, " .. 0 .. " )")
  self._promotionTab.static:addInputEvent("Mouse_Out", "InGameShop_ShowSimpleToolTip( false, " .. 0 .. "  )")
  self._myCartTab.static:addInputEvent("Mouse_LUp", "InGameShop_CartToggle()")
  self._myCartTab.static:addInputEvent("Mouse_On", "InGameShop_ShowSimpleToolTip( true, " .. 1 .. " )")
  self._myCartTab.static:addInputEvent("Mouse_Out", "InGameShop_ShowSimpleToolTip( false, " .. 1 .. "  )")
  self._btn_BuyDaum:addInputEvent("Mouse_LUp", "InGameShop_BuyDaumCash()")
  self._btn_RefreshCash:addInputEvent("Mouse_LUp", "InGameShop_RefreshCash()")
  self._btn_BuyPearl:addInputEvent("Mouse_LUp", "InGameShop_BuyPearl()")
  for index = 0, #self._hotAndNewControlList do
    self._hotAndNewControlList[index]:addInputEvent("Mouse_LUp", "InGameShop_SubTabEvent(1, " .. index + 1 .. ")")
  end
end
function inGameShop:registEventHandler()
  registerEvent("onScreenResize", "InGameShop_Resize")
  registerEvent("FromClient_UpdateCashShop", "InGameShop_UpdateCashShop")
  registerEvent("FromClient_UpdateCash", "InGameShop_UpdateCash")
  registerEvent("EventSelfPlayerPreDead", "InGameShop_OuterEventForDead")
  registerEvent("ToClient_RequestShowProduct", "ToClient_RequestShowProduct")
  registerEvent("FromClient_InventoryUpdate", "InGameShop_UpdateCash")
  registerEvent("FromClient_ShowRecommendProductByComplete", "FromClient_ShowRecommendProductByComplete")
  registerEvent("FromClient_BlockCashShop", "FromClient_BlockCashShop")
end
function inGameShop:initData()
  self._list = Array.new()
  self._listCount = 0
  getIngameCashMall():setCashProductNoRawFilterList()
  self._listCount = getIngameCashMall():getCashProductFilterListCount()
  for ii = 0, self._listCount - 1 do
    self._list[ii] = getIngameCashMall():getCashProductNoRawFromFilterList(ii)
  end
  InGameShop_SetScroll()
end
function CheckCashProduct(cashProduct)
  if not cashProduct:isMallDisplayable() then
    return false
  end
  if not cashProduct:isBuyable() then
    return false
  end
  return true
end
function InGameShop_TabEvent(tab)
  local self = inGameShop
  FGlobal_IngameCashShop_SelectedItemReset()
  if self._tabs[tab] then
    Panel_IngameCashShop:SetChildIndex(self._tabs[tab].static, 9900)
  end
  self._previousTab = self._currentTab
  self._currentTab = tab
  if self._currentTab > 0 and self._currentTab <= getCashMainCategorySize() then
    getIngameCashMall():setCurrentCategory(tabIndexList[self._currentTab][2])
  end
  FGlobal_CashShop_SetEquip_BGToggle(tab)
  if tab > 0 and tab <= self._tabCount then
    _inGameShop_TabOnOut_ChangeTexture(false, self._currentTab)
    if self._previousTab > 0 and self._previousTab <= self._tabCount then
      _inGameShop_TabOnOut_ChangeTexture(false, self._previousTab)
    end
    if not self._promotionTab.static:IsCheck() then
      _inGameShop_TabOnOut_ChangeTexture(false, tabId.promotionTab)
      InGameShop_Promotion_Close()
    end
    if not self._myCartTab.static:IsCheck() then
      _inGameShop_TabOnOut_ChangeTexture(false, tabId.cart)
      FGlobal_Close_IngameCashShop_NewCart()
    end
  end
  getIngameCashMall():setCurrentSubTab(-1)
  _AllBG:SetShow(false)
  ClearFocusEdit()
  makeSubTab(tab)
  self._currentPos = 0
  self._position = 0
  self._scroll_IngameCash:SetControlPos(0)
  getIngameCashMall():setSearchText("")
  getIngameCashMall():setCurrentClass(-1)
  getIngameCashMall():setCurrentSort(-1)
  getIngameCashMall():setCurrentSubFilter(-1)
  self._combo_Class:SetSelectItemIndex(0)
  self._combo_Sort:SetSelectItemIndex(0)
  if UI_CCC.eCashProductCategory_Costumes == tabIndexList[tab][5] then
    local classCount = getCharacterClassCount()
    local selfClassType = getSelfPlayer():getClassType()
    local myClassIndex = -1
    for ii = 0, classCount - 1 do
      local classType = getCharacterClassTypeByIndex(ii)
      if selfClassType == classType then
        myClassIndex = ii
        break
      end
    end
    if -1 ~= myClassIndex then
      self._combo_Class:SetSelectItemIndex(myClassIndex + 1)
      self._combo_Class:SetText(getCharacterClassName(selfClassType))
      getIngameCashMall():setCurrentClass(selfClassType)
    end
  end
  self:initData()
  self:update()
  if not self._categoryWeb:GetShow() then
    self._categoryWeb:SetShow(true)
  end
  if self._currentTab > 0 and self._currentTab <= getCashMainCategorySize() then
    if (0 < tabIndexList[tab][6] or 0 < tabIndexList[tab][7]) and true == FGlobal_IngameCashShopEventCart_IsContentsOpen() then
      local eventListWrapper = ToClient_GetEventCategoryStaticStatusWrapperByKeyRaw(tabIndexList[tab][6])
      local eventSlotWrapper = ToClient_GetEventCategoryStaticStatusWrapperByKeyRaw(tabIndexList[tab][7])
      if nil ~= eventListWrapper or nil ~= eventSlotWrapper then
        if self._previousTab ~= self._currentTab then
          IngameCashShopEventCart_Clear()
        end
        IngameCashShopEventCart_Open(tabIndexList[tab][6], tabIndexList[tab][7])
      end
    else
      IngameCashShopEventCart_Close()
    end
  else
    IngameCashShopEventCart_Close()
  end
  if false == Panel_Window_RecommandGoods:GetShow() and true == _ContentsGroup_Recommend then
    PaGlobal_RecommendGoods:Open()
    self._categoryWeb:SetShow(false)
  end
  if 1 == tab then
    InGameShop_OpenHotAndNewList()
    InGameShop_PosSetHotAndNewButton()
  else
    InGameShop_CloseHotAndNewList()
  end
  if true == self._isSubTabShow then
    local highlightCategoryNo = getHighLightCategoryNo(tabIndexList[self._currentTab][2])
    local isExist = nil ~= self._tabs[self._currentTab]._subTab[highlightCategoryNo]
    if true == isExist then
      InGameShop_SubTabEvent(tab, highlightCategoryNo)
    end
  end
  if tab == self._hotDealTabIndex then
    self._combo_Class:SetShow(false)
    self._remainHotDealTime:SetShow(true)
  else
    self._combo_Class:SetShow(true)
    self._remainHotDealTime:SetShow(false)
  end
end
function InGameShop_OpenHotAndNewList()
  local self = inGameShop
  local slotConfig = self._config._slot
  if true == self._isHotAndNewOpen then
    return
  end
  for index = 0, #self._hotAndNewControlList do
    self._hotAndNewControlList[index]:SetShow(self._hotAndNewShowableList[index])
  end
  self._static_ScrollArea:SetPosY(self._radioButton_Sale:GetPosY() + self._radioButton_Sale:GetSizeY() + 60)
  local remainingSizeY = _ingameCashShop_SetViewListCount()
  self._static_GradationBottom:SetPosY(self._static_ScrollArea:GetSizeY() + self._static_ScrollArea:GetPosY() - 50)
  self._scroll_IngameCash:SetPosY(self._static_ScrollArea:GetPosY())
  self._scroll_IngameCash:SetSize(self._scroll_IngameCash:GetSizeX(), remainingSizeY * 0.98)
  self._static_ScrollArea:SetSize(self._static_ScrollArea:GetSizeX(), remainingSizeY * 0.98)
  self._static_ScrollArea1:SetPosY(0)
  self._static_ScrollArea1:SetSize(self._static_ScrollArea1:GetSizeX(), self._static_ScrollArea:GetPosY())
  self._static_ScrollArea2:SetPosY(self._static_ScrollArea:GetPosY() + self._static_ScrollArea:GetSizeY())
  self._static_ScrollArea2:SetSize(self._static_ScrollArea2:GetSizeX(), 1000)
  self._static_GradationTop:SetPosY(self._static_ScrollArea:GetPosY())
  self._static_GradationBottom:SetPosY(self._static_ScrollArea:GetSizeY() + self._static_ScrollArea:GetPosY() - self._static_GradationBottom:GetSizeY())
  self._static_TopLineBG:SetPosY(self._radioButton_Sale:GetPosY() + self._radioButton_Sale:GetSizeY() + 10)
  self._edit_Search:SetPosY(self._radioButton_Sale:GetPosY() + self._radioButton_Sale:GetSizeY() + 15)
  self._button_Search:SetPosY(self._radioButton_Sale:GetPosY() + self._radioButton_Sale:GetSizeY() + 15)
  self._combo_Class:SetPosY(self._radioButton_Sale:GetPosY() + self._radioButton_Sale:GetSizeY() + 18)
  self._isHotAndNewOpen = true
end
function InGameShop_CloseHotAndNewList()
  local self = inGameShop
  if false == self._isHotAndNewOpen then
    return
  end
  for index = 0, #self._hotAndNewControlList do
    self._hotAndNewControlList[index]:SetShow(false)
  end
  self._static_ScrollArea:SetPosY(self._radioButton_Sale:GetPosY() + self._radioButton_Sale:GetSizeY() + 10)
  self._scroll_IngameCash:SetPosY(self._static_ScrollArea:GetPosY())
  local remainingSizeY = _ingameCashShop_SetViewListCount()
  self._static_GradationBottom:SetPosY(self._static_ScrollArea:GetSizeY() + self._static_ScrollArea:GetPosY() - 50)
  self._scroll_IngameCash:SetPosY(self._static_ScrollArea:GetPosY())
  self._scroll_IngameCash:SetSize(self._scroll_IngameCash:GetSizeX(), remainingSizeY * 0.98)
  self._static_ScrollArea:SetSize(self._static_ScrollArea:GetSizeX(), remainingSizeY * 0.98)
  self._static_ScrollArea1:SetPosY(0)
  self._static_ScrollArea1:SetSize(self._static_ScrollArea1:GetSizeX(), self._static_ScrollArea:GetPosY())
  self._static_ScrollArea2:SetPosY(self._static_ScrollArea:GetPosY() + self._static_ScrollArea:GetSizeY())
  self._static_ScrollArea2:SetSize(self._static_ScrollArea2:GetSizeX(), 1000)
  self._static_GradationTop:SetPosY(self._static_ScrollArea:GetPosY())
  self._static_GradationBottom:SetPosY(self._static_ScrollArea:GetSizeY() + self._static_ScrollArea:GetPosY() - self._static_GradationBottom:GetSizeY())
  self._static_TopLineBG:SetPosY(self._radioButton_Sale:GetPosY() + 1)
  self._edit_Search:SetPosY(self._radioButton_Sale:GetPosY() + 6)
  self._button_Search:SetPosY(self._radioButton_Sale:GetPosY() + 6)
  self._combo_Class:SetPosY(self._radioButton_Sale:GetPosY() + 9)
  self._isHotAndNewOpen = false
end
function InGameShop_CheckHotAndNewButton(isShow, index)
  local self = inGameShop
  self._hotAndNewShowableList[index - 1] = isShow
end
function InGameShop_PosSetHotAndNewButton()
  local self = inGameShop
  local startPosX = self._hotAndNewStartPosX
  for index = 0, #self._hotAndNewControlList do
    if true == self._hotAndNewControlList[index]:GetShow() then
      self._hotAndNewControlList[index]:SetPosX(startPosX)
      startPosX = startPosX + self._hotAndNewControlList[index]:GetSizeX() + 5
    end
  end
end
function makeSubTab(tabIndex)
  local self = inGameShop
  setPosCloseSubTab()
  if self._currentTab == self._previousTab and true == self._checkTab then
    self._checkTab = false
    return
  end
  if nil == tabIndex then
    return
  end
  if not (tabIndex > 0) or not (tabIndex <= getCashMainCategorySize()) then
    return
  end
  local subCategoryCount = getCashMiddleCategorySize(tabIndexList[tabIndex][2])
  if 0 == subCategoryCount then
    return
  end
  self._checkTab = true
  setPosOpenSubTab(tabIndex)
end
function setPosOpenSubTab(tabIndex)
  local self = inGameShop
  local tabConfig = self._config._tab
  local statPosX = self._tabs[tabIndex].static:GetPosX()
  local statPosY = self._tabs[tabIndex].static:GetPosY() + tabConfig._gapY + 10
  local subCategoryCount = getCashMiddleCategorySize(tabIndexList[tabIndex][2])
  local showCountii = 0
  for ii = 1, subCategoryCount do
    if nil ~= self._tabs[tabIndex]._subTab[ii] then
      self._tabs[tabIndex]._subTab[ii].static:SetPosX(statPosX)
      self._tabs[tabIndex]._subTab[ii].static:SetPosY(statPosY + showCountii * 25)
      self._tabs[tabIndex]._subTab[ii].static:SetShow(true)
      self._tabs[tabIndex]._subTab[ii].text:SetPosX(0)
      self._tabs[tabIndex]._subTab[ii].text:SetPosY(0)
      self._tabs[tabIndex]._subTab[ii].text:SetShow(true)
      showCountii = showCountii + 1
    end
  end
  local lastPosY = statPosY + 25 * (showCountii - 1) + 15
  local subTabSize = 25 * showCountii
  local tabPosIndex = tabIndex + 1
  for jj = tabIndex + 1, self._tabCount do
    local tab = self._tabs[jj]
    tab.static:SetPosX(tabConfig._startX)
    tab.static:SetPosY(lastPosY + tabConfig._gapY * (tabPosIndex - (tabIndex + 1)))
    tab.text:SetPosX(40)
    tab.text:SetPosY(5)
    if false == self._isHotDealOpen and jj == self._hotDealTabIndex then
      tab.static:SetShow(false)
    else
      tab.static:SetShow(true)
      tabPosIndex = tabPosIndex + 1
    end
  end
  self._myCartTab.static:SetPosX(tabConfig._startX)
  if false == self._isHotDealOpen then
    self._myCartTab.static:SetPosY(tabConfig._startY + subTabSize + tabConfig._gapY * (tabId.cart - 2))
  else
    self._myCartTab.static:SetPosY(tabConfig._startY + subTabSize + tabConfig._gapY * (tabId.cart - 1))
  end
  self._isSubTabShow = true
end
function setPosCloseSubTab()
  local self = inGameShop
  local tabConfig = self._config._tab
  self:initTabPos()
  self._myCartTab.static:SetPosX(tabConfig._startX)
  if false == self._isHotDealOpen then
    self._myCartTab.static:SetPosY(tabConfig._startY + tabConfig._gapY * (tabId.cart - 2))
  else
    self._myCartTab.static:SetPosY(tabConfig._startY + tabConfig._gapY * (tabId.cart - 1))
  end
  self._subTapSelect.static:SetShow(false)
  local mainCatogorySize = getCashMainCategorySize()
  for jj = 1, mainCatogorySize do
    local subCategoryCount = getCashMiddleCategorySize(tabIndexList[jj][2])
    for ii = 1, subCategoryCount do
      if nil ~= self._tabs[jj]._subTab[ii] then
        self._tabs[jj]._subTab[ii].static:SetShow(false)
        self._tabs[jj]._subTab[ii].text:SetShow(false)
      end
    end
  end
  self._isSubTabShow = false
  for index = 0, #self._hotAndNewControlList do
    self._hotAndNewControlList[index]:SetCheck(false)
  end
end
function InGameShop_SubTabEvent(mainTab, subTab)
  local self = inGameShop
  FGlobal_IngameCashShop_SelectedItemReset()
  self._currentPos = 0
  self._position = 0
  self._scroll_IngameCash:SetControlPos(0)
  local selectPosX = self._tabs[mainTab]._subTab[subTab].static:GetPosX()
  local selectPosY = self._tabs[mainTab]._subTab[subTab].static:GetPosY()
  self._subTapSelect.static:SetPosX(selectPosX)
  self._subTapSelect.static:SetPosY(selectPosY)
  self._subTapSelect.static:SetShow(true == self._isSubTabShow)
  getIngameCashMall():setCurrentSubTab(subTab)
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self:initData()
  self:update()
  if 1 == mainTab then
    for index = 0, #self._hotAndNewControlList do
      self._hotAndNewControlList[index]:SetCheck(index + 1 == subTab)
    end
  end
end
function InGameShop_SetScroll()
  local self = inGameShop
  local scrollSizeY = self._scroll_IngameCash:GetSizeY()
  local pagePercent = self._slotCount / self._listCount * 100
  local btn_scrollSizeY = scrollSizeY / 100 * pagePercent
  if btn_scrollSizeY < 10 then
    btn_scrollSizeY = 10
  end
  if scrollSizeY <= btn_scrollSizeY then
    btn_scrollSizeY = scrollSizeY * 0.99
  end
  if btn_scrollSizeY < 20 then
    btn_scrollSizeY = 50
  end
  if not self._openFunction then
    if self._slotCount < self._listCount then
      self._scroll_IngameCash:SetShow(true)
    else
      self._scroll_IngameCash:SetShow(false)
    end
  end
  self._openFunction = false
  self._scrollBTN_IngameCash:SetSize(self._scrollBTN_IngameCash:GetSizeX(), btn_scrollSizeY)
  self._scroll_IngameCash:SetInterval(self._listCount - self._slotCount)
  self._scroll_IngameCash:SetControlTop()
  self._scrollBTN_IngameCash:SetPosX(-3)
end
function inGameShop:RadioReset()
  self._promotionTab.static:SetCheck(false)
  for ii = 1, self._tabCount do
    local tabConfig = self._config._tab
    local tab = self._tabs[ii]
    tab.static:SetCheck(false)
  end
  self._myCartTab.static:SetCheck(false)
end
function InGameShop_BuyPearl()
  local self = inGameShop
  local pearlBox = 0
  for ii = 1, self._tabCount do
    if tabIndexList[ii][5] == UI_CCC.eCashProductCategory_Pearl then
      pearlBox = ii
    end
  end
  if 0 == pearlBox then
    return
  end
  self:RadioReset()
  self._tabs[pearlBox].static:SetCheck(true)
  InGameShop_TabEvent(pearlBox)
  if self._promotionWeb:GetShow() then
    InGameShop_Promotion_Close()
  end
  if Panel_IngameCashShop_NewCart:GetShow() then
    FGlobal_Close_IngameCashShop_NewCart()
  end
end
function InGameShop_ReShowByHideUI()
  local self = inGameShop
  self:RadioReset()
  self._tabs[self._tabCount].static:SetCheck(true)
  InGameShop_TabEvent(self._tabCount)
end
function InGameShop_BuyDaumCash()
  if ToClient_isConsole() then
    if true == ToClient_isPS4() then
      ToClient_openPS4Store()
    else
      ToClient_XboxShowStore()
    end
  else
    FGlobal_BuyDaumCash()
  end
end
function InGameShop_RefreshCash()
  local selfProxy = getSelfPlayer():get()
  local cash = selfProxy:setRefreshCash()
  if not isNaver then
    cashShop_requestCash()
  end
end
function InGameShop_Search()
  local self = inGameShop
  local search = self._edit_Search:GetEditText()
  if nil == search or "" == search or PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_SERACHWORD") == search then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SEARCH_ACK"))
    return
  end
  self._edit_Search:SetEditText(search, true)
  ClearFocusEdit()
  self._currentPos = 0
  self._position = 0
  getIngameCashMall():setSearchText(search)
  FGlobal_IngameCashShop_SelectedItemReset()
  self:initData()
  self:update()
end
function Recommend_CashItem(type)
  local self = inGameShop
  local categoryType = 0
  local tabIndex = 0
  if Recommend_TYPE.TYPE_INVENTORY == type or Recommend_TYPE.TYPE_WEIGHT == type then
    categoryType = UI_CCC.eCashProductCategory_Normal
  elseif Recommend_TYPE.TYPE_PET == type then
    categoryType = UI_CCC.eCashProductCategory_Pet
  end
  if 0 == categoryType then
    return
  end
  for ii = 1, self._tabCount do
    if tabIndexList[ii][5] == categoryType then
      tabIndex = tabIndexList[ii][1]
    end
  end
  if 0 == tabIndex then
    return
  end
  self:RadioReset()
  self._tabs[tabIndex].static:SetCheck(true)
  if Recommend_TYPE.TYPE_INVENTORY == type then
    InGameShop_TabEvent(tabIndex)
    self._edit_Search:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_FIND_BAG"), true)
    InGameShop_Search()
  elseif Recommend_TYPE.TYPE_PET == type then
    InGameShop_TabEvent(tabIndex)
  elseif Recommend_TYPE.TYPE_WEIGHT then
    InGameShop_TabEvent(tabIndex)
    self._edit_Search:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_FIND_WEIGHT"), true)
    InGameShop_Search()
  end
  InGameShop_Promotion_Close()
end
function InGameShop_ResetSearchText()
  local self = inGameShop
  local search = self._edit_Search:GetEditText()
  if nil == search or PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_SERACHWORD") == search then
    self._edit_Search:SetEditText("", true)
  end
end
function InGameShop_CartToggle()
  local self = inGameShop
  self._previousTab = self._currentTab
  self._currentTab = tabId.cart
  if FGlobal_IsShow_IngameCashShop_NewCart() then
  else
    if self._promotionWeb:GetShow() then
      self._promotionWeb:SetShow(false)
    end
    if Panel_IngameCashShop_GoodsDetailInfo:GetShow() then
      InGameShopDetailInfo_Close()
    end
    if not self._categoryWeb:GetShow() then
      self._categoryWeb:SetShow(true)
    end
    for ii = 1, self._tabCount do
      _ingameCash_SetTabIconTexture(self._tabs[ii].icon, ii, 0)
    end
    if not self._promotionTab.static:IsCheck() then
      _ingameCash_SetTabIconTexture(self._promotionTab.icon, tabId.promotionTab, 0)
    end
    if not self._myCartTab.static:IsCheck() then
      _ingameCash_SetTabIconTexture(self._myCartTab.icon, tabId.cart, 0)
    else
      _ingameCash_SetTabIconTexture(self._myCartTab.icon, tabId.cart, 2)
    end
    FGlobal_Open_IngameCashShop_NewCart()
    Panel_IngameCashShop:SetChildIndex(self._myCartTab.static, 9900)
    self._scroll_IngameCash:SetShow(false)
  end
  InGameShop_CloseHotAndNewList()
  IngameCashShopEventCart_Close()
  makeSubTab(tabId.cart)
end
function InGameShop_ScrollEvent(isUp)
  local self = inGameShop
  local maxCount = self._listCount
  if isUp then
    self._position = self._position - self._config._slot._gapY
    if self._position < 0 then
      self._position = 0
    end
  else
    local listSize = self:getMaxPosition()
    if listSize < 0 then
      return
    end
    self._position = self._position + self._config._slot._gapY
    if listSize < self._position then
      self._position = listSize
    end
  end
  self._scroll_IngameCash:SetControlPos(self._position / self:getMaxPosition())
  self:update()
end
function InGameShop_ProductShowToolTip(productKeyRaw, uiIdx, isChoose)
  local self = inGameShop
  local slotIcon = self._slots[uiIdx].icon
  local scrollArea = self._static_ScrollArea
  FGlobal_CashShop_GoodsTooltipInfo_Open(productKeyRaw, slotIcon, isChoose, scrollArea)
end
function InGameShop_ShowSimpleToolTip(isShow, buttonType)
  local self = inGameShop
  local name = ""
  local desc = ""
  local uiControl, tabIdx
  if 0 == buttonType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TOOLTIPS_PROMOTION")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TOOLTIPS_PROMOTION_DESC")
    uiControl = self._promotionTab.static
    tabIdx = tabId.promotionTab
  elseif 1 == buttonType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TOOLTIPS_MYCART")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TOOLTIPS_MYCART_DESC")
    uiControl = self._myCartTab.static
    tabIdx = tabId.cart
  end
  if true == isShow then
    TooltipSimple_Show(uiControl, name, desc)
    _inGameShop_TabOnOut_ChangeTexture(true, tabIdx)
  else
    TooltipSimple_Hide()
    _inGameShop_TabOnOut_ChangeTexture(false, tabIdx)
  end
end
function InGameShop_Promotion_Open()
  local self = inGameShop
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  self._previousTab = self._currentTab
  self._currentTab = tabId.promotionTab
  Panel_IngameCashShop:SetChildIndex(self._promotionTab.static, 9900)
  Panel_IngameCashShop:SetChildIndex(self._promotionTab.icon, 9900)
  self._promotionWeb:SetPosX(5)
  self._promotionWeb:SetPosY(5)
  self._promotionWeb:SetSize(self._promotionWeb:GetSizeX(), self._promotionSizeY)
  self._promotionWeb:SetShow(true)
  self._scroll_IngameCash:SetShow(false)
  for ii = 1, self._tabCount do
    _ingameCash_SetTabIconTexture(self._tabs[ii].icon, ii, 0)
  end
  self._myCartTab.static:SetCheck(false)
  FGlobal_Close_IngameCashShop_NewCart()
  _ingameCash_SetTabIconTexture(self._myCartTab.icon, tabId.cart, 0)
  _ingameCash_SetTabIconTexture(self._promotionTab.icon, tabId.promotionTab, 2)
  IngameCashShopEventCart_Close()
  makeSubTab(tabId.promotionTab)
  PaGlobal_RecommendGoods:Close()
  InGameShop_CloseHotAndNewList()
  self._combo_Class:SetShow(true)
  self._remainHotDealTime:SetShow(false)
end
function InGameShop_Promotion_Close()
  local self = inGameShop
  self._promotionWeb:SetShow(false)
  self._openFunction = false
end
function InGameShop_ProductListContent_ChangeTexture(slot, isSelected)
  slot.static:ChangeTextureInfoName("new_ui_common_forlua/window/ingamecashshop/cashshop_01.dds")
  local x1, y1, x2, y2 = 0, 0, 0, 0
  if true == isSelected then
    x1, y1, x2, y2 = setTextureUV_Func(slot.static, 193, 410, 268, 476)
  else
    x1, y1, x2, y2 = setTextureUV_Func(slot.static, 47, 5, 122, 71)
  end
  slot.static:getBaseTexture():setUV(x1, y1, x2, y2)
  slot.static:setRenderTexture(slot.static:getBaseTexture())
end
function InGameShop_ProductListContent_ChangeMoneyIconTexture(slot, categoryIdx, isEnableSilver, isDesc)
  local serviceContry, iconType
  if isGameTypeKorea() then
    serviceContry = contry.kr
  elseif isGameTypeJapan() then
    serviceContry = contry.jp
  elseif isGameTypeRussia() then
    serviceContry = contry.ru
  elseif isGameTypeKR2() then
    serviceContry = contry.kr2
  elseif isGameTypeEnglish() then
    serviceContry = contry.na
  elseif isGameTypeTR() then
    serviceContry = contry.tr
  elseif isGameTypeSA() then
    serviceContry = contry.sa
  elseif isGameTypeID() then
    serviceContry = contry.id
  else
    serviceContry = contry.kr
  end
  if UI_CCC.eCashProductCategory_Pearl == categoryIdx then
    iconType = cashIconType.cash
  elseif UI_CCC.eCashProductCategory_Mileage == categoryIdx then
    iconType = cashIconType.mileage
  else
    iconType = cashIconType.pearl
  end
  if isEnableSilver then
    iconType = cashIconType.silver
  end
  if isDesc then
    cashIcon_changeTextureForList(slot, serviceContry, iconType)
  else
    cashIcon_changeTextureForList(slot.pearlIcon, serviceContry, iconType)
  end
end
function HandleClicked_InGameShop_SetScrollIndexByLClick()
  local self = inGameShop
  self._position = self._scroll_IngameCash:GetControlPos() * self:getMaxPosition()
  self:update()
end
function FGlobal_InGameShop_IsSelectedSearchName()
  local self = inGameShop
  local selectedEditControll = UI.getFocusEdit()
  return nil ~= selectedEditControll and selectedEditControll:GetKey() == self._edit_Search:GetKey()
end
function FGlobal_InGameCashShop_GetSearchEdit()
  return inGameShop._edit_Search
end
function _ingameCash_SetTabIconTexture(control, tabIdx, status)
  local self = inGameShop
  local categorySize = getCashMainCategorySize()
  if tabIdx >= 1 and tabIdx <= categorySize then
    control:ChangeTextureInfoName(tabIndexList[tabIdx][4])
  elseif tabId.promotionTab == tabIdx then
    control:ChangeTextureInfoName("new_ui_common_forlua/window/ingamecashshop/cashshopmenu/CashShopMenu_00.dds")
  elseif tabId.cart == tabIdx then
    control:ChangeTextureInfoName("new_ui_common_forlua/window/ingamecashshop/cashshopmenu/CashShopMenu_10.dds")
  end
  local x1, y1, x2, y2 = setTextureUV_Func(control, tabIconTexture1[status][1], tabIconTexture1[status][2], tabIconTexture1[status][3], tabIconTexture1[status][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function _inGameShop_TabOnOut_ChangeTexture(isOn, tabIdx)
  local self = inGameShop
  local control
  if tabIdx > 0 and tabIdx < self._tabCount + 1 then
    control = self._tabs[tabIdx]
  elseif tabId.promotionTab == tabIdx then
    control = self._promotionTab
  elseif tabId.cart == tabIdx then
    control = self._myCartTab
  else
    return
  end
  local controlBeforState = not control.static:IsCheck()
  if isOn then
    _ingameCash_SetTabIconTexture(control.icon, tabIdx, 1)
  elseif controlBeforState then
    _ingameCash_SetTabIconTexture(control.icon, tabIdx, 0)
  else
    _ingameCash_SetTabIconTexture(control.icon, tabIdx, 2)
  end
end
function FGlobal_InGameShop_UpdateByBuy()
  inGameShop:update()
end
function FGlobal_InGameShop_OpenByEventAlarm()
  if isGameTypeGT() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TESTSERVER_CAUTION"))
    return
  end
  if true == ToClient_isBlockedCashShop() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoChangeCashProduct"))
    return
  end
  ToClient_SaveUiInfo(false)
  if isFlushedUI() then
    return
  end
  if not FGlobal_IsCommercialService() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_NOTUSE"))
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_CASHSHOP"))
    return
  end
  if Panel_IngameCashShop:GetShow() then
    return
  end
  if nil == getIngameCashMall() then
    return false
  end
  if getIngameCashMall():isShow() then
    return
  end
  if not getIngameCashMall():show() then
    return
  end
  audioPostEvent_SystemUi(1, 39)
  _AudioPostEvent_SystemUiForXBOX(1, 39)
  if not isNaver then
    cashShop_requestCash()
  end
  cashShop_requestCashShopList()
  PaymentPassword_Close()
  SetUIMode(Defines.UIMode.eUIMode_InGameCashShop)
  renderMode:set()
  getIngameCashMall():clearEquipViewList()
  getIngameCashMall():changeViewMyCharacter()
  local self = inGameShop
  _ingameCashShop_SetViewListCount()
  if not _ContentsGroup_RenewUI_PearlShop then
    cashShop_Controller_Open()
  end
  FGlobal_CashShop_SetEquip_Open()
  for ii = 1, self._tabCount do
    self._tabs[ii].static:SetCheck(false)
  end
  self._openFunction = true
  self._static_Construction:ComputePos()
  self._static_Construction:SetShow(false)
  Panel_IngameCashShop:SetShow(true)
  self._scroll_IngameCash:SetShow(false)
  local SALangType = "pt"
  if UI_SERVICE_RESOURCE.eServiceResourceType_ES == getGameServiceResType() then
    SALangType = "es"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_PT == getGameServiceResType() then
    SALangType = "pt"
  end
  local scrSizeY = getScreenSizeY()
  local categoryUrl = ""
  local promotionUrl = ""
  if isGameTypeKorea() then
    if CppEnums.CountryType.KOR_ALPHA == getGameServiceType() then
      promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_DEV_URL_PROMOTIONURL")
      categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_DEV_URL_CATEGORYURL")
    elseif CppEnums.CountryType.KOR_REAL == getGameServiceType() then
      promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL")
      categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL")
    end
  elseif isGameTypeTaiwan() then
    if CppEnums.CountryType.TW_ALPHA == getGameServiceType() then
      promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TW_ALPHA")
      categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_TW_ALPHA")
    elseif CppEnums.CountryType.TW_REAL == getGameServiceType() then
      promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TW")
      categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_TW")
    end
  elseif isGameTypeKR2() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_KR2")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_KR2")
  elseif CppEnums.CountryType.SA_ALPHA == getGameServiceType() then
    promotionUrl = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_SA_ALPHA", "lang", SALangType)
    categoryUrl = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_SA_ALPHA", "lang", SALangType)
  elseif CppEnums.CountryType.SA_REAL == getGameServiceType() then
    promotionUrl = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_SA", "lang", SALangType)
    categoryUrl = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_SA", "lang", SALangType)
  elseif CppEnums.CountryType.TR_ALPHA == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TR_ALPHA")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_TR_ALPHA")
  elseif CppEnums.CountryType.TR_REAL == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TR")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_TR")
  elseif CppEnums.CountryType.TH_ALPHA == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TH_ALPHA")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_TH_ALPHA")
  elseif CppEnums.CountryType.TH_REAL == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TH")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_TH")
  elseif CppEnums.CountryType.ID_ALPHA == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_ID_ALPHA")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_ID_ALPHA")
  elseif CppEnums.CountryType.ID_REAL == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_ID")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_ID")
  elseif CppEnums.CountryType.RUS_ALPHA == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_RUS_ALPHA")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_RUS_ALPHA")
  elseif CppEnums.CountryType.RUS_REAL == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_RUS")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_RUS")
  else
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL")
  end
  FGlobal_SetCandidate()
  self._categoryWeb:SetUrl(self._categoryWeb:GetSizeX(), self._categoryWeb:GetSizeY(), categoryUrl, false, isTaiwanNation)
  self._categoryWeb:SetShow(true)
  self._categoryWeb:SetIME()
  self._promotionWeb:SetUrl(self._promotionWeb:GetSizeX(), self._promotionSizeY, promotionUrl, false, isTaiwanNation)
  _AllBG:SetSize(_AllBG:GetSizeX(), self._promotionSizeY)
  self._promotionWeb:SetIME()
  self._openByEventAlarm = true
end
function FGlobal_InGameShop_OpenInventory()
  Inventory_SetFunctor(IngameCashShop_PearlBoxFilter, IngameCashShop_PearlBox_Open, nil, nil)
  InventoryWindow_Show(true, true)
end
function IngameCashShop_PearlBoxFilter(slotNo, itemWrapper, count, inventoryType)
  if itemWrapper:getStaticStatus():isPearlBox() then
    return false
  else
    return true
  end
end
function IngameCashShop_PearlBox_Open(slotNo, itemWrapper, count, inventoryType)
  local function doOpen()
    Inventory_UseItemTargetSelf(inventoryType, slotNo, nil)
  end
  if nil ~= PaGlobalFunc_CashMileage_GetShow and PaGlobalFunc_CashMileage_GetShow() then
    PaGlobal_CashMileage_Close()
  end
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_OPEN_PEARLBOX")
  local messageBoxData = {
    title = messageTitle,
    content = messageBoxMemo,
    functionYes = doOpen,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function IngameCashShop_Descinit()
  local self = inGameShop.desc
  self._staticText_Title = UI.getChildControl(inGameShop._goodDescBG, "StaticText_GoodsTitle")
  self._static_SlotBG = UI.getChildControl(inGameShop._goodDescBG, "Static_GoodsSlotBG")
  self._static_Slot = UI.getChildControl(inGameShop._goodDescBG, "Static_GoodsSlot")
  self._static_Desc = UI.getChildControl(inGameShop._goodDescBG, "StaticText_GoodsDesc")
  self._staticText_ProductInfo_Title = UI.getChildControl(inGameShop._goodDescBG, "StaticText_ProductInfo_Title")
  self._staticText_PurchaseLimit = UI.getChildControl(inGameShop._goodDescBG, "StaticText_PurchaseLimit")
  self._static_VestedDesc = UI.getChildControl(inGameShop._goodDescBG, "StaticText_VestedDesc")
  self._static_TradeDesc = UI.getChildControl(inGameShop._goodDescBG, "StaticText_TradeDesc")
  self._static_ClassDesc = UI.getChildControl(inGameShop._goodDescBG, "StaticText_ClassDesc")
  self._static_WarningDesc = UI.getChildControl(inGameShop._goodDescBG, "StaticText_WarningDesc")
  self._static_DiscountPeriodDesc = UI.getChildControl(inGameShop._goodDescBG, "StaticText_DiscountPeriod")
  self._static_ItemListTitle = UI.getChildControl(inGameShop._goodDescBG, "StaticText_ItemListTitle")
  self._static_RelatedItemTitle = UI.getChildControl(inGameShop._goodDescBG, "StaticText_RelatedItemTitle")
  self._static_PearlIcon = UI.getChildControl(inGameShop._goodDescBG, "Static_DescPearlIcon")
  self._static_PearlPrice = UI.getChildControl(inGameShop._goodDescBG, "StaticText_DescItemPrice")
  self._static_PearOriginalPrice = UI.getChildControl(inGameShop._goodDescBG, "StaticText_DescItemOriginalPrice")
  self._btn_BigBuy = UI.getChildControl(inGameShop._goodDescBG, "Button_BigBuy")
  self._btn_BigBuy_M = UI.getChildControl(inGameShop._goodDescBG, "Button_BigBuy_M")
  self._btn_BigBuy_C = UI.getChildControl(inGameShop._goodDescBG, "Button_BigBuy_C")
  self._btn_BigBuy_Silver = UI.getChildControl(inGameShop._goodDescBG, "Button_BigBuy_Silver")
  self._btn_BigCart = UI.getChildControl(inGameShop._goodDescBG, "Button_BigCart")
  self._btn_BigGift = UI.getChildControl(inGameShop._goodDescBG, "Button_BigGift")
  self._btn_BigECart = UI.getChildControl(inGameShop._goodDescBG, "Button_BigECart")
  self._btn_BigECartSlot = UI.getChildControl(inGameShop._goodDescBG, "Button_BigECartSlot")
  self._staticText_Title:SetAutoResize(true)
  self._static_Desc:SetAutoResize(true)
  self._staticText_Title:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._static_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._static_Desc:SetFontColor(UI_color.C_FFC4A68A)
  self._staticText_PurchaseLimit:SetFontColor(UI_color.C_FF748CAB)
  self._static_VestedDesc:SetFontColor(UI_color.C_FF748CAB)
  self._static_TradeDesc:SetFontColor(UI_color.C_FFF26A6A)
  self._static_ClassDesc:SetFontColor(UI_color.C_FF999999)
  self._static_WarningDesc:SetFontColor(UI_color.C_FFF26A6A)
  self._static_DiscountPeriodDesc:SetFontColor(UI_color.C_FF748CAB)
  local itemConfig = inGameShop._config._item
  for ii = 0, inGameShop._itemCount - 1 do
    local slot = {}
    slot.iconBG = UI.createAndCopyBasePropertyControl(inGameShop._goodDescBG, "Static_ItemSlotBG", self._static_ItemListTitle, "InGameShopDetailInfo_Item_" .. ii)
    slot.icon = UI.createAndCopyBasePropertyControl(inGameShop._goodDescBG, "Static_ItemSlot", slot.iconBG, "InGameShopDetailInfo_Item_Icon_" .. ii)
    slot.iconBG:SetPosX(itemConfig._startX + itemConfig._gapX * ii)
    slot.iconBG:SetPosY(itemConfig._startY)
    inGameShop._items[ii] = slot
  end
  local selfPanel = inGameShop
  local subItemCount = selfPanel._subItemCount
  selfPanel._endSunPositionY = 0
  selfPanel._bigButtonCount = 0
  selfPanel._smallButtonCount = 0
  selfPanel._skipCount = 0
  for kk = 1, subItemCount do
    local subitem = {}
    subitem.productNo = 0
    subitem.static = UI.createAndCopyBasePropertyControl(inGameShop._goodDescBG, "RadioButton_Category", inGameShop._goodDescBG, "InGameShop_subItem_" .. kk)
    subitem.static:SetText("-")
    subitem.static:SetShow(false)
    subitem.static:SetIgnore(true)
    subitem.static:addInputEvent("Mouse_LUp", "InGameShop_subItemEvent(" .. kk .. ")")
    selfPanel._subItemButton[kk] = subitem
  end
  local chooseProductListCount = inGameShop._chooseProductListCount
  for jj = 0, chooseProductListCount - 1 do
    local chooseProduct = {}
    chooseProduct.staticBG = UI.createAndCopyBasePropertyControl(inGameShop._goodDescBG, "RadioButton_Banner", inGameShop._goodDescBG, "InGameShop_ChooseCashBG_" .. jj)
    chooseProduct.staticBG:SetShow(false)
    chooseProduct.staticBG:addInputEvent("Mouse_UpScroll", "InGameShop_ScrollEvent( true )")
    chooseProduct.staticBG:addInputEvent("Mouse_DownScroll", "InGameShop_ScrollEvent( false )")
    chooseProduct.staticAddPlusBtn = UI.createAndCopyBasePropertyControl(inGameShop._goodDescBG, "Button_ChooseCountPlus", inGameShop._goodDescBG, "InGameShop_ChooseCountPlus_" .. jj)
    chooseProduct.staticAddPlusBtn:SetShow(false)
    chooseProduct.staticAddPlusBtn:addInputEvent("Mouse_LUp", "InGameShop_ChooseCashClickEvent(" .. jj .. ", true )")
    chooseProduct.staticAddMinusBtn = UI.createAndCopyBasePropertyControl(inGameShop._goodDescBG, "Button_ChooseCountMinus", inGameShop._goodDescBG, "InGameShop_ChooseCountMinus_" .. jj)
    chooseProduct.staticAddMinusBtn:SetShow(false)
    chooseProduct.staticAddMinusBtn:addInputEvent("Mouse_LUp", "InGameShop_ChooseCashClickEvent(" .. jj .. ", false )")
    chooseProduct.staticEditCount = UI.createAndCopyBasePropertyControl(inGameShop._goodDescBG, "Edit_ChooseCount", inGameShop._goodDescBG, "InGameShop_ChooseCount_" .. jj)
    chooseProduct.staticEditCount:SetShow(false)
    chooseProduct.staticEditCount:SetIgnore(true)
    selfPanel._chooseProductList[jj] = chooseProduct
  end
  local slotNoList = {
    [0] = 17,
    [1] = 14,
    [2] = 15,
    [3] = 16
  }
  for ii = 0, 3 do
    selfPanel._static_EquipSlots[ii] = {
      _slotIcon = UI.createAndCopyBasePropertyControl(inGameShop._goodDescBG, "Static_EquipSlotIcons_" .. ii, inGameShop._goodDescBG, "InGameShop_EquipSlotIcons_" .. ii),
      _slotNo = slotNoList[ii]
    }
  end
end
function IngameCashShop_DescUpdate()
  local self = inGameShop.desc
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(inGameShop._openProductKeyRaw)
  if nil == cashProduct then
    return
  end
  for ii = 0, inGameShop._itemCount - 1 do
    local slot = inGameShop._items[ii]
    slot.iconBG:SetShow(false)
  end
  local itemListCount = cashProduct:getItemListCount()
  local itemConfig = inGameShop._config._relatedItem
  if itemListCount < 10 then
    itemConfig._startX = 0
    itemConfig._gapX = 35
  else
    itemConfig._startX = -7
    itemConfig._gapX = 33
  end
  for ii = 0, itemListCount - 1 do
    local slot = inGameShop._items[ii]
    local item = cashProduct:getItemByIndex(ii)
    local itemCount = cashProduct:getItemCountByIndex(ii)
    local itemGrade = item:getGradeType()
    slot.iconBG:SetPosX(itemConfig._startX + itemConfig._gapX * ii)
    slot.iconBG:SetPosY(itemConfig._startY)
    slot.icon:ChangeTextureInfoName("icon/" .. item:getIconPath())
    slot.icon:SetText(tostring(itemCount))
    slot.icon:addInputEvent("Mouse_On", "InGameShop_ShowItemToolTip( true, " .. ii .. " )")
    slot.icon:addInputEvent("Mouse_Out", "InGameShop_ShowItemToolTip( false, " .. ii .. " )")
    slot.iconBG:SetShow(true)
  end
  local subItemListCount = itemListCount + cashProduct:getSubItemListCount()
  for ii = itemListCount, subItemListCount - 1 do
    local slot = inGameShop._items[ii]
    local item = cashProduct:getSubItemByIndex(ii - itemListCount)
    local itemCount = cashProduct:getSubItemCountByIndex(ii - itemListCount)
    local itemGrade = item:getGradeType()
    slot.iconBG:SetPosX(itemConfig._startX + itemConfig._gapX * ii)
    slot.iconBG:SetPosY(itemConfig._startY)
    slot.icon:ChangeTextureInfoName("icon/" .. item:getIconPath())
    slot.icon:SetText(tostring(itemCount))
    slot.icon:addInputEvent("Mouse_On", "InGameShop_ShowSubItemToolTip( true, " .. ii - itemListCount .. " )")
    slot.icon:addInputEvent("Mouse_Out", "InGameShop_ShowSubItemToolTip( false, " .. ii - itemListCount .. " )")
    slot.iconBG:SetShow(true)
  end
  self._static_RelatedItemTitle:SetShow(false)
  local descCount = 0
  local descConfig = inGameShop._config._desc
  local subConfig = inGameShop._config._subButton
  self._static_VestedDesc:SetText("")
  self._static_TradeDesc:SetText("")
  self._static_ClassDesc:SetText("")
  self._static_WarningDesc:SetText("")
  self._static_DiscountPeriodDesc:SetText("")
  self._static_PearOriginalPrice:SetText("")
  self._static_Slot:ChangeTextureInfoName("Icon/" .. cashProduct:getIconPath())
  self._staticText_Title:SetText(cashProduct:getDisplayName())
  if cashProduct:isApplyDiscount() then
    self._static_PearOriginalPrice:SetFontColor(UI_color.C_FF626262)
    self._static_PearOriginalPrice:SetText(makeDotMoney(cashProduct:getOriginalPrice()) .. " <PAColor0xffefefef>" .. PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_ARROW") .. "<PAOldColor> ")
  end
  self._static_PearlPrice:SetText(makeDotMoney(cashProduct:getPrice()))
  self._static_Desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_STATIC_DESC", "getDes", cashProduct:getDescription()))
  InGameShop_ProductListContent_ChangeMoneyIconTexture(self._static_PearlIcon, cashProduct:getMainCategory(), cashProduct:isMoneyPrice(), true)
  InGameShop_ProductInfo_ChangeMoneyIconTexture(cashProduct:getMainCategory(), cashProduct:isMoneyPrice())
  local buttonSizeY = subConfig._gapY * (inGameShop._endSunPositionY + 1)
  if 1 == inGameShop._listComboCount then
    buttonSizeY = 0
  end
  local optionDesc_PosY = subConfig._startY + buttonSizeY + self._staticText_Title:GetTextSizeY()
  if cashProduct:isChooseCash() then
    optionDesc_PosY = optionDesc_PosY + inGameShop._endChoosePositionY
  end
  self._staticText_ProductInfo_Title:SetPosY(optionDesc_PosY - 35)
  self._static_SlotBG:SetPosY(optionDesc_PosY - 10)
  self._static_Slot:SetPosY(optionDesc_PosY - 10)
  self._static_Desc:SetPosY(optionDesc_PosY - 10)
  optionDesc_PosY = optionDesc_PosY + self._static_Desc:GetTextSizeY() + 35
  self._staticText_PurchaseLimit:SetText("")
  local limitType = cashProduct:getCashPurchaseLimitType()
  if UI_PLT.None ~= limitType then
    local limitCount = cashProduct:getCashPurchaseCount()
    local mylimitCount = getIngameCashMall():getRemainingLimitCount(inGameShop._openProductKeyRaw)
    local typeString = ""
    if UI_PLT.AtCharacter == limitType then
      typeString = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_CHARACTER")
    elseif UI_PLT.AtAccount == limitType then
      typeString = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_FAMILY")
    end
    if 0 < cashProduct:getLimitedType() then
      self._staticText_PurchaseLimit:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_PURCHASELIMIT", "typeString", typeString, "limitCount", limitCount, "mylimitCount", mylimitCount) .. " (" .. cashProduct:getLimitedTypeDesc() .. ")")
    else
      self._staticText_PurchaseLimit:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_PURCHASELIMIT", "typeString", typeString, "limitCount", limitCount, "mylimitCount", mylimitCount))
    end
    self._staticText_PurchaseLimit:SetFontColor(UI_color.C_FFF26A6A)
    self._staticText_PurchaseLimit:SetPosY(optionDesc_PosY + descConfig._gapY * descCount)
    descCount = descCount + 1
  end
  local vestedDesc = IngameShopDetailInfo_ConvertFromCategoryToVestedDesc(cashProduct)
  if nil ~= vestedDesc then
    self._static_VestedDesc:SetText(vestedDesc)
    self._static_VestedDesc:SetPosY(optionDesc_PosY + descConfig._gapY * descCount)
    descCount = descCount + 1
  end
  local tradeDesc = IngameShopDetailInfo_ConvertFromCategoryToTradeDesc(cashProduct)
  if nil ~= tradeDesc then
    self._static_TradeDesc:SetText(tradeDesc)
    self._static_TradeDesc:SetPosY(optionDesc_PosY + descConfig._gapY * descCount)
    descCount = descCount + 1
  end
  local classDesc = IngameShopDetailInfo_ConvertFromCategoryToClassDesc(cashProduct)
  if nil ~= classDesc then
    self._static_ClassDesc:SetText(classDesc)
    self._static_ClassDesc:SetPosY(optionDesc_PosY + descConfig._gapY * descCount)
    descCount = descCount + 1
  end
  if cashProduct:isApplyDiscount() then
    local startDiscountTimeValue = PATime(cashProduct:getStartDiscountTime():get_s64())
    local endDiscountTimeValue = PATime(cashProduct:getEndDiscountTime():get_s64())
    local startDiscountTime = tostring(startDiscountTimeValue:GetYear()) .. "." .. tostring(startDiscountTimeValue:GetMonth()) .. "." .. tostring(startDiscountTimeValue:GetDay())
    local endDiscountTime = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTTIME", "GetYear", tostring(endDiscountTimeValue:GetYear()), "GetMonth", tostring(endDiscountTimeValue:GetMonth()), "GetDay", tostring(endDiscountTimeValue:GetDay())) .. " " .. string.format("%.02d", endDiscountTimeValue:GetHour()) .. ":" .. string.format("%.02d", endDiscountTimeValue:GetMinute())
    if true == disCountSetUse then
      endDiscountTime = convertStringFromDatetime(cashProduct:getRemainDiscountTime())
    else
      endDiscountTime = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTTIME", "GetYear", tostring(endDiscountTimeValue:GetYear()), "GetMonth", tostring(endDiscountTimeValue:GetMonth()), "GetDay", tostring(endDiscountTimeValue:GetDay())) .. " " .. string.format("%.02d", endDiscountTimeValue:GetHour()) .. ":" .. string.format("%.02d", endDiscountTimeValue:GetMinute())
    end
    self._static_DiscountPeriodDesc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTPERIODDESC", "endDiscountTime", endDiscountTime))
    local remainDay = calculateDayFromDateDay(cashProduct:getRemainDiscountTime())
    if 0 == Int64toInt32(remainDay) and false == disCountSetUse then
      local remainStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DISCOUNT_REMAINTIME", "remainTime", convertStringFromDatetime(cashProduct:getRemainDiscountTime()))
      self._static_DiscountPeriodDesc:SetFontColor(UI_color.C_FFFF0000)
      self._static_DiscountPeriodDesc:SetText(remainStr)
    end
    self._static_DiscountPeriodDesc:SetPosY(optionDesc_PosY + descConfig._gapY * descCount)
    descCount = descCount + 1
  end
  self._static_ItemListTitle:SetPosY(optionDesc_PosY + descConfig._gapY * descCount)
  descCount = descCount + 1
  optionDesc_PosY = optionDesc_PosY + inGameShop._items[0].iconBG:GetSizeY() + 20
  inGameShop.itemDescDetailSize = optionDesc_PosY + descConfig._gapY * descCount
  inGameShop._maxDescSize = inGameShop.itemDescDetailSize
  local limitType = cashProduct:getCashPurchaseLimitType()
  if UI_CCC.eCashProductCategory_Pearl == cashProduct:getMainCategory() then
    self._btn_BigBuy_C:SetMonoTone(false)
    self._btn_BigGift:SetMonoTone(true)
    self._btn_BigCart:SetMonoTone(true)
    self._btn_BigBuy_C:SetEnable(true)
    self._btn_BigBuy:SetShow(false)
    self._btn_BigBuy_M:SetShow(false)
    self._btn_BigBuy_C:SetShow(true)
    self._btn_BigBuy_Silver:SetShow(false)
    self._btn_BigGift:SetEnable(false)
    self._btn_BigCart:SetEnable(false)
    self._btn_BigBuy_C:SetSpanSize(20, 10)
    self._btn_BigBuy_M:SetSpanSize(20, 10)
  elseif UI_CCC.eCashProductCategory_Mileage == cashProduct:getMainCategory() then
    self._btn_BigBuy:SetShow(false)
    self._btn_BigBuy_M:SetShow(true)
    self._btn_BigBuy_C:SetShow(false)
    self._btn_BigBuy_Silver:SetShow(false)
    if UI_PLT.AtCharacter == limitType or UI_PLT.AtAccount == limitType then
      local limitCount = cashProduct:getCashPurchaseCount()
      local mylimitCount = getIngameCashMall():getRemainingLimitCount(cashProduct:getNoRaw())
      if limitCount > 0 then
        self._btn_BigBuy_M:SetMonoTone(false)
        self._btn_BigGift:SetMonoTone(true)
        self._btn_BigCart:SetMonoTone(true)
        self._btn_BigBuy_M:SetEnable(true)
        self._btn_BigGift:SetEnable(false)
        self._btn_BigCart:SetEnable(false)
        if mylimitCount <= 0 then
          self._btn_BigBuy_M:SetMonoTone(true)
          self._btn_BigBuy_M:SetEnable(false)
        end
      else
        self._btn_BigBuy_M:SetMonoTone(true)
        self._btn_BigGift:SetMonoTone(true)
        self._btn_BigCart:SetMonoTone(true)
        self._btn_BigBuy_M:SetEnable(false)
        self._btn_BigGift:SetEnable(false)
        self._btn_BigCart:SetEnable(false)
      end
    else
      self._btn_BigBuy_M:SetMonoTone(false)
      self._btn_BigGift:SetMonoTone(true)
      self._btn_BigCart:SetMonoTone(true)
      self._btn_BigBuy_M:SetEnable(true)
      self._btn_BigGift:SetEnable(false)
      self._btn_BigCart:SetEnable(false)
    end
    self._btn_BigGift:SetSpanSize(100, 10)
    self._btn_BigCart:SetSpanSize(60, 10)
    self._btn_BigBuy:SetSpanSize(20, 10)
    self._btn_BigBuy_C:SetSpanSize(20, 10)
    self._btn_BigBuy_M:SetSpanSize(20, 10)
  else
    if UI_PLT.AtCharacter == limitType or UI_PLT.AtAccount == limitType then
      local limitCount = cashProduct:getCashPurchaseCount()
      local mylimitCount = getIngameCashMall():getRemainingLimitCount(cashProduct:getNoRaw())
      if limitCount > 0 then
        self._btn_BigBuy:SetMonoTone(false)
        self._btn_BigGift:SetMonoTone(true)
        self._btn_BigCart:SetMonoTone(false)
        self._btn_BigBuy:SetEnable(true)
        self._btn_BigGift:SetEnable(false)
        self._btn_BigCart:SetEnable(true)
        if mylimitCount <= 0 then
          self._btn_BigBuy:SetMonoTone(true)
          self._btn_BigCart:SetMonoTone(true)
          self._btn_BigBuy:SetEnable(false)
          self._btn_BigCart:SetEnable(false)
        end
      else
        self._btn_BigBuy:SetMonoTone(true)
        self._btn_BigGift:SetMonoTone(true)
        self._btn_BigCart:SetMonoTone(true)
        self._btn_BigBuy:SetEnable(false)
        self._btn_BigGift:SetEnable(false)
        self._btn_BigCart:SetEnable(false)
      end
    else
      self._btn_BigBuy:SetMonoTone(false)
      self._btn_BigGift:SetMonoTone(false)
      self._btn_BigCart:SetMonoTone(false)
      self._btn_BigBuy:SetEnable(true)
      self._btn_BigGift:SetEnable(true)
      self._btn_BigCart:SetEnable(true)
    end
    self._btn_BigGift:SetSpanSize(100, 10)
    self._btn_BigCart:SetSpanSize(60, 10)
    self._btn_BigBuy:SetSpanSize(20, 10)
    self._btn_BigBuy_C:SetSpanSize(20, 10)
    self._btn_BigBuy_M:SetSpanSize(20, 10)
    self._btn_BigBuy_M:SetShow(false)
    self._btn_BigBuy_C:SetShow(false)
  end
  if cashProduct:isMoneyPrice() then
    self._btn_BigBuy:SetShow(false)
    self._btn_BigBuy_Silver:SetShow(true)
    if true == self._btn_BigBuy:IsEnable() then
      self._btn_BigBuy_Silver:SetEnable(true)
      self._btn_BigBuy_Silver:SetMonoTone(false)
    else
      self._btn_BigBuy_Silver:SetEnable(false)
      self._btn_BigBuy_Silver:SetMonoTone(true)
    end
    self._btn_BigCart:SetEnable(false)
    self._btn_BigCart:SetMonoTone(true)
  else
    self._btn_BigBuy_Silver:SetShow(false)
  end
  if cashProduct:isChooseCash() then
    self._btn_BigGift:SetMonoTone(true)
    self._btn_BigCart:SetMonoTone(true)
    self._btn_BigGift:SetEnable(false)
    self._btn_BigCart:SetEnable(false)
  end
  self._btn_BigCart:SetShow(true)
  self._btn_BigECart:SetShow(false)
  self._btn_BigECartSlot:SetShow(false)
  local evantType = cashProduct:getEventCartType()
  if 0 < inGameShop._currentTab and inGameShop._currentTab <= getCashMainCategorySize() and true == FGlobal_IngameCashShopEventCart_IsContentsOpen() then
    local isOnListButton = 0 == evantType or 1 == evantType
    local isOnSlotButton = 0 == evantType or 2 == evantType
    local eventListKey = tabIndexList[inGameShop._currentTab][6]
    local eventSlotKey = tabIndexList[inGameShop._currentTab][7]
    local isOpenEventList = IngameCashShop_CheckOpenEventCart(eventListKey)
    local isOpenEventSlot = IngameCashShop_CheckOpenEventCart(eventSlotKey)
    if eventListKey > 0 and true == isOpenEventList and eventSlotKey > 0 and true == isOpenEventSlot then
      self._btn_BigECart:SetShow(true)
      self._btn_BigECartSlot:SetShow(true)
      self._btn_BigECart:SetMonoTone(false == isOnListButton)
      self._btn_BigECartSlot:SetMonoTone(false == isOnSlotButton)
      self._btn_BigECart:SetEnable(isOnListButton)
      self._btn_BigECartSlot:SetEnable(isOnSlotButton)
      self._btn_BigCart:SetShow(false)
    elseif eventSlotKey > 0 and true == isOpenEventSlot then
      self._btn_BigECart:SetShow(false)
      self._btn_BigECartSlot:SetShow(true)
      self._btn_BigECart:SetMonoTone(true)
      self._btn_BigECartSlot:SetMonoTone(false == isOnSlotButton)
      self._btn_BigECart:SetEnable(false)
      self._btn_BigECartSlot:SetEnable(isOnSlotButton)
      self._btn_BigCart:SetShow(false)
    elseif eventListKey > 0 and true == isOpenEventList then
      self._btn_BigECart:SetShow(true)
      self._btn_BigECartSlot:SetShow(false)
      self._btn_BigECart:SetMonoTone(false == isOnListButton)
      self._btn_BigECartSlot:SetMonoTone(false)
      self._btn_BigECart:SetEnable(isOnListButton)
      self._btn_BigECartSlot:SetEnable(false)
      self._btn_BigCart:SetShow(false)
    end
  end
  for _, slotIcon in pairs(inGameShop._static_EquipSlots) do
    slotIcon._slotIcon:SetPosY(optionDesc_PosY)
  end
  local isBuyShow = false == cashProduct:hasBuyConditions()
  if true == _ContentsGroup_PearlShopGift then
    self._btn_BigGift:SetShow(isBuyShow)
  else
    self._btn_BigGift:SetShow(false)
  end
  self._btn_BigCart:SetShow(isBuyShow)
  self._btn_BigGift:addInputEvent("Mouse_LUp", "IngameCashShop_DescSelectedGiftItem(" .. inGameShop._openProductKeyRaw .. ")")
  self._btn_BigCart:addInputEvent("Mouse_LUp", "IngameCashShop_DescSelectedCartItem(" .. inGameShop._openProductKeyRaw .. ")")
  self._btn_BigBuy:addInputEvent("Mouse_LUp", "IngameCashShop_DescSelectedBuyItem(" .. inGameShop._openProductKeyRaw .. ")")
  self._btn_BigBuy_C:addInputEvent("Mouse_LUp", "IngameCashShop_DescSelectedBuyItem(" .. inGameShop._openProductKeyRaw .. ")")
  self._btn_BigBuy_M:addInputEvent("Mouse_LUp", "IngameCashShop_DescSelectedBuyItem(" .. inGameShop._openProductKeyRaw .. ")")
  self._btn_BigECart:addInputEvent("Mouse_LUp", "IngameCashShop_DescSelectedEcartItem(" .. inGameShop._openProductKeyRaw .. ", 0)")
  self._btn_BigECartSlot:addInputEvent("Mouse_LUp", "IngameCashShop_DescSelectedEcartItem(" .. inGameShop._openProductKeyRaw .. ", 1)")
  self._btn_BigBuy_Silver:addInputEvent("Mouse_LUp", "IngameCashShop_DescSelectedBuyItem(" .. inGameShop._openProductKeyRaw .. ")")
end
function IngameCashShop_CheckOpenEventCart(enventKey)
  local eventListWrapper = ToClient_GetEventCategoryStaticStatusWrapperByKeyRaw(enventKey)
  if nil ~= eventListWrapper then
    local isSellinPeriod = eventListWrapper:isSellinPeriod()
    local isDiscountPeriod = eventListWrapper:isDiscountPeriod()
    if true == isSellinPeriod and false == isDiscountPeriod then
      return false
    end
    return true
  end
  return false
end
function IngameCashShop_initSubItemButton()
  inGameShop._comboList = Array.new()
  inGameShop._endSunPositionY = 0
  inGameShop._bigButtonCount = 0
  inGameShop._smallButtonCount = 0
  inGameShop._skipCount = 0
  for ii = 1, inGameShop._subItemCount do
    inGameShop._subItemButton[ii].static:SetText("-")
    if ii == 1 then
      inGameShop._subItemButton[ii].static:SetCheck(true)
    else
      inGameShop._subItemButton[ii].static:SetCheck(false)
    end
    inGameShop._subItemButton[ii].static:SetIgnore(true)
    inGameShop._subItemButton[ii].static:SetShow(false)
    inGameShop._subItemButton[ii].productNo = 0
    inGameShop._subItemButton[ii].static:SetSize(131, 38)
    inGameShop._subItemButton[ii].static:SetPosX(30)
    inGameShop._subItemButton[ii].static:SetPosY(40)
  end
end
function IngameCashShop_initDescData(cashProduct)
  if nil == cashProduct then
    return
  end
  IngameCashShop_initSubItemButton()
  local self = inGameShop.desc
  inGameShop._comboList = Array.new()
  inGameShop._listComboCount = 1
  inGameShop._listComboIncludeDummyCount = 1
  local offergroup = cashProduct:getOfferGroup()
  local count = 0
  if 0 ~= offergroup then
    count = getIngameCashMall():getCashProductStaticStatusGroupListCount(offergroup)
  end
  for ii = 0, count - 1 do
    local cashProduct = getIngameCashMall():getCashProductStaticStatusGroupByIndex(offergroup, ii)
    if nil ~= cashProduct and IngameCashShop_filterData(cashProduct) then
      inGameShop._comboList[inGameShop._listComboCount] = cashProduct:getNoRaw()
      inGameShop._listComboCount = inGameShop._listComboCount + 1
      if 1 == cashProduct:getDisplayFilterKey() or 11 == cashProduct:getDisplayFilterKey() then
        inGameShop._bigButtonCount = inGameShop._bigButtonCount + 1
      else
        inGameShop._smallButtonCount = inGameShop._smallButtonCount + 1
      end
    end
  end
  IngameCashShop_sortData()
  local configButton = inGameShop._config
  local positionBX = 0
  local positionBY = 0
  local positionSX = 0
  local positionSY = 0
  local nextY = 0
  local divide = 0
  local sizeX = 0
  local gapXpos = 0
  if 0 ~= inGameShop._bigButtonCount then
    inGameShop._skipCount = inGameShop._bigButtonCount % 2
  end
  self._staticText_Title:SetText(cashProduct:getDisplayName())
  local titleSizeY = self._staticText_Title:GetTextSizeY() + 20
  for ii = 1, inGameShop._listComboCount do
    if nil ~= inGameShop._comboList[ii] then
      local subProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(inGameShop._comboList[ii])
      if nil ~= subProduct then
        if ii == inGameShop._bigButtonCount + 1 and 0 ~= inGameShop._bigButtonCount then
          nextY = positionBY + 1
        end
        if 1 == subProduct:getDisplayFilterKey() or 11 == subProduct:getDisplayFilterKey() then
          local productName = subProduct:getDisplaySubName()
          if subProduct:isApplyDiscount() then
            productName = "<PAColor0xfface400>" .. productName
          elseif 5 == subProduct:getTag() then
            productName = "<PAColor0xff33c5b3>" .. productName
          end
          if inGameShop._cashProductNoData == inGameShop._subItemButton[ii].productNo then
            inGameShop._cashProductIndex = ii
          end
          sizeX = configButton._subButtonSize._BigX
          divide = 2
          inGameShop._subItemButton[ii].static:SetSize(sizeX, configButton._subButton._gapY)
          if (ii - 1) % divide == 0 then
            positionBX = ii - 1
            positionBY = math.floor(ii / divide)
            gapXpos = 0
          else
            gapXpos = 1
          end
          inGameShop._subItemButton[ii].static:SetPosX(30 + (ii - 1 - positionBX) * sizeX - gapXpos)
          inGameShop._subItemButton[ii].static:SetPosY(titleSizeY + positionBY * configButton._subButton._gapY)
          inGameShop._subItemButton[ii].static:SetTextMode(UI_TM.eTextMode_LimitText)
          inGameShop._subItemButton[ii].static:SetText(productName)
          inGameShop._subItemButton[ii].static:SetShow(true)
          inGameShop._subItemButton[ii].static:SetIgnore(false)
          inGameShop._subItemButton[ii].productNo = inGameShop._comboList[ii]
        else
          local productName = subProduct:getDisplaySubName()
          if subProduct:isApplyDiscount() then
            productName = "<PAColor0xfface400>" .. productName
          elseif 5 == subProduct:getTag() then
            productName = "<PAColor0xff33c5b3>" .. productName
          end
          sizeX = configButton._subButtonSize._SmallX
          divide = 5
          inGameShop._subItemButton[ii + inGameShop._skipCount].static:SetSize(sizeX, configButton._subButton._gapY)
          local realCount = ii - inGameShop._bigButtonCount
          if (realCount - 1) % divide == 0 then
            positionSX = realCount - 1
            positionSY = nextY + math.floor(realCount / divide)
          end
          inGameShop._subItemButton[ii + inGameShop._skipCount].static:SetPosX(30 + (realCount - 1 - positionSX) * sizeX)
          inGameShop._subItemButton[ii + inGameShop._skipCount].static:SetPosY(titleSizeY + positionSY * configButton._subButton._gapY)
          inGameShop._subItemButton[ii + inGameShop._skipCount].static:SetTextMode(UI_TM.eTextMode_LimitText)
          inGameShop._subItemButton[ii + inGameShop._skipCount].static:SetText(productName)
          inGameShop._subItemButton[ii + inGameShop._skipCount].static:SetShow(true)
          inGameShop._subItemButton[ii + inGameShop._skipCount].static:SetIgnore(false)
          inGameShop._subItemButton[ii + inGameShop._skipCount].productNo = inGameShop._comboList[ii]
        end
      end
    end
  end
  inGameShop._endSunPositionY = positionSY
  if 0 == inGameShop._smallButtonCount then
    inGameShop._endSunPositionY = positionBY
  end
  if 0 < inGameShop._bigButtonCount then
    divide = 2
    local subButtonCount = math.ceil(inGameShop._bigButtonCount / divide) * divide
    for ii = inGameShop._bigButtonCount + 1, subButtonCount do
      inGameShop._subItemButton[ii].static:SetShow(true)
      sizeX = configButton._subButtonSize._BigX
      inGameShop._subItemButton[ii].static:SetSize(sizeX, configButton._subButton._gapY)
      inGameShop._subItemButton[ii].static:SetPosX(30 + (ii - 1 - positionBX) * sizeX - 1)
      inGameShop._subItemButton[ii].static:SetPosY(titleSizeY + positionBY * configButton._subButton._gapY)
    end
    inGameShop._listComboIncludeDummyCount = subButtonCount
  end
  if 0 < inGameShop._smallButtonCount then
    divide = 5
    local subButtonCount = math.ceil(inGameShop._smallButtonCount / divide) * divide
    for ii = inGameShop._smallButtonCount + 1 + inGameShop._bigButtonCount + inGameShop._skipCount, subButtonCount + inGameShop._bigButtonCount + inGameShop._skipCount do
      inGameShop._subItemButton[ii].static:SetShow(true)
      sizeX = configButton._subButtonSize._SmallX
      inGameShop._subItemButton[ii].static:SetSize(sizeX, configButton._subButton._gapY)
      realCount = ii - (inGameShop._bigButtonCount + inGameShop._skipCount)
      inGameShop._subItemButton[ii].static:SetPosX(30 + (realCount - 1 - positionSX) * sizeX)
      inGameShop._subItemButton[ii].static:SetPosY(titleSizeY + positionSY * configButton._subButton._gapY)
    end
    inGameShop._listComboIncludeDummyCount = subButtonCount + inGameShop._bigButtonCount + inGameShop._skipCount
  end
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(inGameShop._openProductKeyRaw)
  if nil == cashProduct then
    return
  end
  inGameShop._endChoosePositionY = 0
  inGameShop._chooseProductClickList = nil
  getIngameCashMall():clearChooseProductCount()
  if cashProduct:isChooseCash() then
    local validChooseCashProduct = cashProduct:chooseCashCount()
    local nextLine = -1
    inGameShop._chooseProductClickList = Array.new()
    for ii = 0, inGameShop._chooseProductListCount - 1 do
      local radioBenner = inGameShop._chooseProductList[ii]
      if ii < validChooseCashProduct then
        local chooseCashProduct = cashProduct:getChooseCashByIndex(ii)
        if nil == chooseCashProduct then
          return
        end
        if 0 == ii % 3 then
          nextLine = nextLine + 1
        end
        radioBenner.staticAddPlusBtn:SetShow(true)
        radioBenner.staticAddPlusBtn:SetIgnore(false)
        radioBenner.staticAddPlusBtn:SetPosX(200 + 220 * (ii % 3))
        radioBenner.staticAddPlusBtn:SetPosY(titleSizeY + 10 + 59 * nextLine)
        radioBenner.staticAddMinusBtn:SetShow(true)
        radioBenner.staticAddMinusBtn:SetIgnore(false)
        radioBenner.staticAddMinusBtn:SetPosX(200 + 220 * (ii % 3))
        radioBenner.staticAddMinusBtn:SetPosY(titleSizeY + 27 + 59 * nextLine)
        radioBenner.staticEditCount:SetShow(true)
        radioBenner.staticEditCount:SetText("0")
        radioBenner.staticEditCount:SetPosX(165 + 220 * (ii % 3))
        radioBenner.staticEditCount:SetPosY(titleSizeY + 9 + 59 * nextLine)
        radioBenner.staticBG:SetShow(true)
        radioBenner.staticBG:ChangeTextureInfoName(chooseCashProduct:getPackageIcon())
        radioBenner.staticBG:SetIgnore(false)
        radioBenner.staticBG:SetPosX(10 + 220 * (ii % 3))
        radioBenner.staticBG:SetPosY(titleSizeY + 59 * nextLine)
        radioBenner.staticBG:addInputEvent("Mouse_On", "InGameShop_ProductShowToolTip( " .. chooseCashProduct:getNoRaw() .. ", " .. ii .. ", true )")
        radioBenner.staticBG:addInputEvent("Mouse_Out", "FGlobal_CashShop_GoodsTooltipInfo_Close()")
        radioBenner.staticBG:addInputEvent("Mouse_LUp", "InGameShop_ChooseCashView(" .. chooseCashProduct:getNoRaw() .. ")")
      else
        radioBenner.staticBG:SetShow(false)
        radioBenner.staticBG:SetIgnore(true)
        radioBenner.staticAddPlusBtn:SetShow(false)
        radioBenner.staticAddPlusBtn:SetIgnore(true)
        radioBenner.staticAddMinusBtn:SetShow(false)
        radioBenner.staticAddMinusBtn:SetIgnore(true)
        radioBenner.staticEditCount:SetShow(false)
        radioBenner.staticEditCount:SetText("0")
      end
      inGameShop._chooseProductClickList[ii] = 0
    end
    inGameShop._endChoosePositionY = inGameShop._endChoosePositionY + 59 * (nextLine + 1)
  else
    for ii = 0, inGameShop._chooseProductListCount - 1 do
      local radioBenner = inGameShop._chooseProductList[ii]
      radioBenner.staticBG:SetShow(false)
      radioBenner.staticBG:SetIgnore(true)
      radioBenner.staticAddPlusBtn:SetShow(false)
      radioBenner.staticAddPlusBtn:SetIgnore(true)
      radioBenner.staticAddMinusBtn:SetShow(false)
      radioBenner.staticAddMinusBtn:SetIgnore(true)
      radioBenner.staticEditCount:SetShow(false)
      radioBenner.staticEditCount:SetText("0")
    end
  end
end
function IngameCashShop_filterData(cashProduct)
  local self = inGameShop
  if not CheckCashProduct(cashProduct) then
    return false
  end
  return true
end
function IngameCashShop_SortCash(lhs, rhs)
  local self = inGameShop
  local lhsNo, rhsNo, lhsOrder, rhsOrder, lhsFilter, rhsFilter
  local lhsWrapper = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(lhs)
  if nil ~= lhsWrapper then
    lhsNo = lhsWrapper:getNoRaw()
    lhsOrder = lhsWrapper:getOrder()
    lhsFilter = lhsWrapper:getDisplayFilterKey()
  end
  local rhsWrapper = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(rhs)
  if nil ~= rhsWrapper then
    rhsNo = rhsWrapper:getNoRaw()
    rhsOrder = rhsWrapper:getOrder()
    rhsFilter = rhsWrapper:getDisplayFilterKey()
  end
  if lhsFilter == rhsFilter then
    if lhsOrder == rhsOrder then
      return lhsNo < rhsNo
    else
      return lhsOrder < rhsOrder
    end
  else
    return lhsFilter < rhsFilter
  end
end
function IngameCashShop_sortData()
  local self = inGameShop
  table.sort(self._comboList, IngameCashShop_SortCash)
end
function HandleClicked_IngameCashShop_ShowSubList()
  local self = inGameShop.desc
end
function HandleClicked_IngameCashShop_SelectedSubList()
  local self = inGameShop.desc
  IngameCashShop_DescUpdate()
end
function InGameShop_ShowItemToolTip(isShow, index)
  local self = inGameShop
  if true == isShow then
    local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(self._openProductKeyRaw)
    local itemWrapper = cashProduct:getItemByIndex(index)
    local slotIcon = self._items[index].icon
    Panel_Tooltip_Item_Show(itemWrapper, slotIcon, true, false, nil)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function InGameShop_ShowSubItemToolTip(isShow, index)
  local self = inGameShop
  if true == isShow then
    local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(self._openProductKeyRaw)
    local itemWrapper = cashProduct:getSubItemByIndex(index)
    local slotIcon = self._items[index + cashProduct:getSubItemListCount()].icon
    Panel_Tooltip_Item_Show(itemWrapper, slotIcon, true, false, nil)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function IngameCashShop_SelectedItem(index, bValue)
  local self = inGameShop
  local slot = self._slots[index]
  self._currentProductKeyRaw = slot.productNoRaw
  local prevIndex = -1
  if self._openProductKeyRaw == slot.productNoRaw and index == self._currentIndex then
    self._isClick = true
  elseif self._isSubItemClick and self._currentProductKeyRaw == self._categoryProductKeyRaw then
    self._isClick = true
  else
    self._isClick = false
  end
  if self._currentProductKeyRaw ~= self._categoryProductKeyRaw then
    self._isSubItemClick = false
  end
  self._currentIndex = index
  if self._openProductKeyRaw == slot.productNoRaw or self._isSubItemClick then
    return
  end
  audioPostEvent_SystemUi(1, 0)
  _AudioPostEvent_SystemUiForXBOX(1, 0)
  FGlobal_SpecialMoveSettingCheck()
  IngameCashShop_SelectedItemXXX(slot.productNoRaw, nil, bValue)
  local tempSaveProductKeyRaw = slot.productNoRaw
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(tempSaveProductKeyRaw)
  if nil ~= cashProduct and cashProduct:isMoneyPrice() then
    IngameCashShop_StartTerritory = selfPlayerCurrentTerritory()
    ToClient_RequestCurrentMainTownRegionWarehouseInfo()
  end
end
IngameCashShop_StartTerritory = nil
function IngameCashShop_SelectedItemXXX(productNoRaw, isForcePositionSet, bValue)
  local self = inGameShop
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNoRaw)
  if nil == cashProduct then
    return
  end
  local prevPos = 0
  local prevKeyRaw = self._openProductKeyRaw
  for ii = 0, self._listCount - 1 do
    local productNoRawInList = self._list[ii]
    if self:isSelectProductGroup(productNoRaw) or productNoRawInList == productNoRaw then
      prevPos = prevPos - self._position
      break
    end
    if self:isSelectProductGroup(productNoRawInList) then
      prevPos = prevPos + self._goodDescBG:GetSizeY()
    end
    prevPos = prevPos + self._config._slot._gapY
  end
  self._openProductKeyRaw = productNoRaw
  self._goodDescBG:SetShow(true)
  IngameCashShop_initDescData(cashProduct)
  if isForcePositionSet then
    local pos = 0
    for ii = 0, self._listCount - 1 do
      local productNoRaw = self._list[ii]
      if self:isSelectProductGroup(productNoRaw) then
        if pos > 100 then
          pos = pos - 100
        end
        if prevPos < pos then
          pos = pos - self._goodDescBG:GetSizeY()
        end
        self._position = pos
        self._currentPos = self._position
        if self:getMaxPosition() < self._position then
          self._position = self:getMaxPosition()
        end
        self._scroll_IngameCash:SetControlPos(self._position / self:getMaxPosition())
        break
      end
      pos = pos + self._config._slot._gapY
    end
  else
    local pos = 0
    for ii = 0, self._listCount - 1 do
      local productNoRaw = self._list[ii]
      if self:isSelectProductGroup(productNoRaw) then
        if -1 == prevKeyRaw then
          break
        end
        pos = pos - prevPos
        local listSize = self:getMaxPosition()
        if listSize < 0 or pos < 0 then
          self._position = 0
          break
        end
        self._position = pos
        if listSize < self._position then
          self._position = listSize
        end
        self._currentPos = self._position
        if self:getMaxPosition() < self._position then
          self._position = self:getMaxPosition()
        end
        self._scroll_IngameCash:SetControlPos(self._position / self:getMaxPosition())
        break
      end
      pos = pos + self._config._slot._gapY
    end
  end
  self._goodDescBG:SetSize(self._goodDescBG:GetSizeX(), 1)
  IngameCashShop_DescUpdate()
  if UI_CCC.eCashProductCategory_Costumes == tabIndexList[self._currentTab][5] then
    if false == Return_CashShopController_FirstIgnore() or 1 == inGameShop._listComboCount then
      FGlobal_CashShop_SetEquip_Update(productNoRaw)
      FGlobal_CashShop_SetEquip_SelectedItem(productNoRaw)
    end
  else
    FGlobal_CashShop_SetEquip_Update(productNoRaw)
    FGlobal_CashShop_SetEquip_SelectedItem(productNoRaw)
  end
  PaGlobal_RecommendEngine_CashVeiw(productNoRaw, bValue)
  self._ViewingRecommend = bValue
  self:update()
end
function InGameShop_subItemEvent(index)
  local self = inGameShop
  self._isSubItemClick = true
  self._categoryProductKeyRaw = self._currentProductKeyRaw
  if index > 0 and index < self._listComboCount + self._skipCount and 0 ~= inGameShop._subItemButton[index].productNo then
    inGameShop._openProductKeyRaw = inGameShop._subItemButton[index].productNo
    IngameCashShop_DescUpdate()
    FGlobal_CashShop_SetEquip_Update(inGameShop._subItemButton[index].productNo)
    PaGlobal_RecommendEngine_CashVeiw(inGameShop._subItemButton[index].productNo, self._ViewingRecommend)
    self:update()
  end
end
function FGlobal_IngameCashShop_SelectedItemReset()
  local self = inGameShop
  self._openProductKeyRaw = -1
  self._goodDescBG:SetShow(false)
  self._goodDescBG:SetSize(self._goodDescBG:GetSizeX(), 1)
  local listSize = self:getMaxPosition()
  if listSize >= self._static_ScrollArea:GetSizeY() and listSize < self._currentPos then
    self._position = self:getMaxPosition()
    self._scroll_IngameCash:SetControlPos(1)
  end
  self:update()
  self._goodDescBG:SetShow(false)
  IngameCashShop_initSubItemButton()
end
function InGameShop_ChooseCashClickEvent(index, isUp)
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(inGameShop._openProductKeyRaw)
  if nil == cashProduct then
    return
  end
  local validChooseCount = cashProduct:chooseCashCount()
  local mustChooseCount = cashProduct:mustChooseCount()
  local isChooseDuplicate = cashProduct:isChooseDuplicaite()
  local checkCount = 0
  local isEnable = false
  for ii = 0, validChooseCount - 1 do
    checkCount = checkCount + inGameShop._chooseProductClickList[ii]
  end
  if checkCount == mustChooseCount and true == isUp then
    local radioBenner = inGameShop._chooseProductList[index]
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CASHSHOP_CHOOSECOUNTOVER"))
    return
  else
    if true == isUp then
      if false == isChooseDuplicate then
        if 1 == inGameShop._chooseProductClickList[index] then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CASHSHOP_CHOOSECOUNTDUPLICATE"))
          return
        else
          inGameShop._chooseProductClickList[index] = inGameShop._chooseProductClickList[index] + 1
        end
      else
        inGameShop._chooseProductClickList[index] = inGameShop._chooseProductClickList[index] + 1
      end
    else
      if 0 == inGameShop._chooseProductClickList[index] then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CASHSHOP_CHOOSECOUNTMINIMUM"))
        return
      end
      inGameShop._chooseProductClickList[index] = inGameShop._chooseProductClickList[index] - 1
    end
    local radioBenner = inGameShop._chooseProductList[index]
    radioBenner.staticEditCount:SetText(inGameShop._chooseProductClickList[index])
  end
  getIngameCashMall():setChooseProductCount(index, isUp)
end
function InGameShop_ChooseCashView(productNoRaw)
  FGlobal_CashShop_SetEquip_Update(productNoRaw)
  FGlobal_CashShop_SetEquip_SelectedItem(productNoRaw)
end
function FGlobal_IngameCashShopCashCheckList_ReturnValue()
  return inGameShop._chooseProductClickList
end
function FGlobal_Update_IngameCashShop_CartEffect()
  local self = inGameShop
  self._myCartTab.static:EraseAllEffect()
  self._myCartTab.static:AddEffect("fUI_CashShop_BasketButton", false, 0, 0)
end
function IngameCashShop_CartItem(index)
  local self = inGameShop
  local slot = self._slots[index]
  local tempSaveProductKeyRaw = slot.productNoRaw
  if -1 ~= inGameShop._openProductKeyRaw then
    if inGameShop._openProductKeyRaw == slot.productNoRaw then
      tempSaveProductKeyRaw = slot.productNoRaw
    elseif self:isSelectProductGroup(slot.productNoRaw) then
      tempSaveProductKeyRaw = self._openProductKeyRaw
    else
      tempSaveProductKeyRaw = slot.productNoRaw
    end
  else
    tempSaveProductKeyRaw = slot.productNoRaw
  end
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(tempSaveProductKeyRaw)
  if nil == cashProduct then
    return
  end
  if false == getIngameCashMall():checkPushableInCart(tempSaveProductKeyRaw, 1) then
    return
  end
  local function doAnotherClassItem()
    local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(slot.productNoRaw)
    if nil == cashProduct then
      return
    end
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CARTITEM_ACK", "getName", cashProduct:getName()))
    FGlobal_PushCart_IngameCashShop_NewCart(tempSaveProductKeyRaw, 1)
    return
  end
  if cashProduct:doHaveDisplayClass() and not cashProduct:isClassTypeUsable(getSelfPlayer():getClassType()) then
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_ALERT")
    local messageBoxMemo = "<PAColor0xffd0ee68>[" .. PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_MATHCLASS") .. "]\n" .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CARTITEM_MSGMEMO", "getName", productName) .. "<PAOldColor>"
    messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = doAnotherClassItem,
      functionNo = _InGameShopBuy_Confirm_Cancel,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CARTITEM_ACK", "getName", cashProduct:getName()))
    FGlobal_PushCart_IngameCashShop_NewCart(tempSaveProductKeyRaw, 1)
  end
end
function IngameCashShop_DescSelectedCartItem(productKeyRaw)
  local self = inGameShop
  local tempSaveProductKeyRaw = productKeyRaw
  if -1 ~= inGameShop._openProductKeyRaw then
    if inGameShop._openProductKeyRaw == productKeyRaw then
      tempSaveProductKeyRaw = productKeyRaw
    elseif self:isSelectProductGroup(productKeyRaw) then
      tempSaveProductKeyRaw = self._openProductKeyRaw
    else
      tempSaveProductKeyRaw = productKeyRaw
    end
  else
    tempSaveProductKeyRaw = productKeyRaw
  end
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(tempSaveProductKeyRaw)
  if nil == cashProduct then
    return
  end
  if false == getIngameCashMall():checkPushableInCart(tempSaveProductKeyRaw, 1) then
    return
  end
  local function doAnotherClassItem()
    local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productKeyRaw)
    if nil == cashProduct then
      return
    end
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CARTITEM_ACK", "getName", cashProduct:getName()))
    FGlobal_PushCart_IngameCashShop_NewCart(tempSaveProductKeyRaw, 1)
    return
  end
  if cashProduct:doHaveDisplayClass() and not cashProduct:isClassTypeUsable(getSelfPlayer():getClassType()) then
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_ALERT")
    local messageBoxMemo = "<PAColor0xffd0ee68>[" .. PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_MATHCLASS") .. "]\n" .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CARTITEM_MSGMEMO", "getName", productName) .. "<PAOldColor>"
    messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = doAnotherClassItem,
      functionNo = _InGameShopBuy_Confirm_Cancel,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CARTITEM_ACK", "getName", cashProduct:getName()))
    FGlobal_PushCart_IngameCashShop_NewCart(tempSaveProductKeyRaw, 1)
  end
  ToClient_RequestRecommendList(productKeyRaw)
end
function IngameCashShop_CheckGiftLevel()
  local selfplayer = getSelfPlayer()
  if nil == selfplayer then
    return false
  end
  local limitLevel = ToClient_getGiftLevelLimited()
  local myLevel = selfplayer:get():getLevel()
  if limitLevel > myLevel then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_LIMIT_20LEVEL", "level", limitLevel))
    return false
  end
  if not _ContentsGroup_PearlShopGift then
    return false
  end
  return true
end
function IngameCashShop_GiftItem(index)
  local self = inGameShop
  local slot = self._slots[index]
  if false == IngameCashShop_CheckGiftLevel() then
    return
  end
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(slot.productNoRaw)
  if nil == cashProduct then
    return
  end
  local tempSaveProductKeyRaw = slot.productNoRaw
  if -1 ~= inGameShop._openProductKeyRaw then
    if inGameShop._openProductKeyRaw == slot.productNoRaw then
      tempSaveProductKeyRaw = slot.productNoRaw
    elseif self:isSelectProductGroup(slot.productNoRaw) then
      tempSaveProductKeyRaw = self._openProductKeyRaw
    else
      tempSaveProductKeyRaw = slot.productNoRaw
    end
  else
    tempSaveProductKeyRaw = slot.productNoRaw
  end
  FGlobal_InGameShopBuy_Open(tempSaveProductKeyRaw, true)
  IngameCashShopCoupon_Close()
end
function IngameCashShop_DescSelectedGiftItem(productNoRaw)
  local self = inGameShop
  local selfplayer = getSelfPlayer()
  if nil == selfplayer then
    return
  end
  local limitLevel = 50
  local myLevel = selfplayer:get():getLevel()
  if myLevel < 50 and (isGameTypeEnglish() or isGameTypeTH() or isGameTypeID()) then
    limitLevel = 50
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_LIMIT_20LEVEL", "level", limitLevel))
    return
  end
  if myLevel < 56 and (isGameTypeSA() or isGameTypeTR()) then
    limitLevel = 56
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_LIMIT_20LEVEL", "level", limitLevel))
    return
  end
  if myLevel < 56 and isGameTypeTaiwan() then
    limitLevel = 56
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_LIMIT_20LEVEL", "level", limitLevel))
    return
  end
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNoRaw)
  if nil == cashProduct then
    return
  end
  local tempSaveProductKeyRaw = productNoRaw
  if -1 ~= inGameShop._openProductKeyRaw then
    if inGameShop._openProductKeyRaw == productNoRaw then
      tempSaveProductKeyRaw = productNoRaw
    elseif self:isSelectProductGroup(productNoRaw) then
      tempSaveProductKeyRaw = self._openProductKeyRaw
    else
      tempSaveProductKeyRaw = productNoRaw
    end
  else
    tempSaveProductKeyRaw = productNoRaw
  end
  FGlobal_InGameShopBuy_Open(tempSaveProductKeyRaw, true)
end
function IngameCashShop_DescSelectedEcartItem(productNoRaw, index)
  if true == IngameCashShopEventCart_Update(productNoRaw, index) then
    ToClient_RequestRecommendList(productNoRaw)
  end
end
function IngameCashShop_BuyItem(index)
  local self = inGameShop
  local slot = self._slots[index]
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(slot.productNoRaw)
  if nil == cashProduct then
    return
  end
  local tempSaveProductKeyRaw = slot.productNoRaw
  if -1 ~= inGameShop._openProductKeyRaw then
    if inGameShop._openProductKeyRaw == slot.productNoRaw then
      tempSaveProductKeyRaw = slot.productNoRaw
    elseif self:isSelectProductGroup(slot.productNoRaw) then
      tempSaveProductKeyRaw = self._openProductKeyRaw
    else
      tempSaveProductKeyRaw = slot.productNoRaw
    end
  else
    tempSaveProductKeyRaw = slot.productNoRaw
  end
  local mainCategory = cashProduct:getMainCategory()
  local categoryType = 0
  for ii = 1, self._tabCount do
    if tabIndexList[ii][2] == mainCategory then
      categoryType = tabIndexList[ii][5]
    end
  end
  local isCouponOpen = false
  local isPearlTab = UI_CCC.eCashProductCategory_Pearl == categoryType
  if true == isPearlTab and true == isKorea and true == isNaver then
    local naverLink = "http://black.game.naver.com/black/billing/shop/index.daum"
    ToClient_OpenChargeWebPage(naverLink, true)
  else
    isCouponOpen = FGlobal_InGameShopBuy_Open(tempSaveProductKeyRaw, false)
  end
  if UI_CCC.eCashProductCategory_Pearl == categoryType or UI_CCC.eCashProductCategory_Mileage == categoryType then
    IngameCashShopCoupon_Close()
  elseif true == isCouponOpen then
    IngameCashShopCoupon_Open(0)
  end
  ToClient_RequestRecommendList(productNoRaw)
end
function IngameCashShop_DescSelectedBuyItem(productNoRaw)
  local self = inGameShop
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNoRaw)
  if nil == cashProduct then
    return
  end
  local tempSaveProductKeyRaw = productNoRaw
  if -1 ~= inGameShop._openProductKeyRaw then
    if inGameShop._openProductKeyRaw == productNoRaw then
      tempSaveProductKeyRaw = productNoRaw
    elseif self:isSelectProductGroup(productNoRaw) then
      tempSaveProductKeyRaw = self._openProductKeyRaw
    else
      tempSaveProductKeyRaw = productNoRaw
    end
  else
    tempSaveProductKeyRaw = productNoRaw
  end
  local mainCategory = cashProduct:getMainCategory()
  local categoryType = 0
  local pearlBox = 0
  for ii = 1, self._tabCount do
    if tabIndexList[ii][2] == mainCategory then
      categoryType = tabIndexList[ii][5]
    end
    if tabIndexList[ii][5] == UI_CCC.eCashProductCategory_Pearl then
      pearlBox = ii
    end
  end
  if UI_CCC.eCashProductCategory_Pearl ~= categoryType and UI_CCC.eCashProductCategory_Mileage ~= categoryType then
    local myPearlCount = Defines.s64_const.s64_0
    local pearlItemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, getPearlSlotNo())
    if nil ~= pearlItemWrapper then
      myPearlCount = pearlItemWrapper:get():getCount_s64()
    end
  elseif UI_CCC.eCashProductCategory_Pearl == categoryType then
    local cash = getSelfPlayer():get():getCash()
    if cash < cashProduct:getOriginalPrice() and (true ~= cashProduct:isApplyDiscount() or not (cash >= cashProduct:getDiscountPrice())) then
      local MessgeBox_Yes = function()
        InGameShop_BuyDaumCash()
      end
      local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYCASHMEGBOX_TITLE")
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYCASHMEGBOX_DESC")
      local messageBoxData = {
        title = messageTitle,
        content = messageBoxMemo,
        functionYes = MessgeBox_Yes,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
      return
    end
  end
  local isCouponOpen = false
  local isPearlTab = UI_CCC.eCashProductCategory_Pearl == categoryType
  if true == isPearlTab and true == isKorea and true == isNaver then
    local naverLink = "http://black.game.naver.com/black/billing/shop/index.daum"
    ToClient_OpenChargeWebPage(naverLink, true)
  else
    isCouponOpen = FGlobal_InGameShopBuy_Open(tempSaveProductKeyRaw, false)
  end
  if UI_CCC.eCashProductCategory_Pearl == categoryType or UI_CCC.eCashProductCategory_Mileage == categoryType or true == cashProduct:isMoneyPrice() then
    IngameCashShopCoupon_Close()
  else
    if true == isCouponOpen then
      IngameCashShopCoupon_Open(0, productNoRaw)
    end
    if true == _ContentsGroup_PearlShopMileage and true == PaGlobal_CashMileage_IsOpenCheck() then
      PaGlobal_CashMileage_ChangeConsumePearl(Int64toInt32(cashProduct:getPrice()))
    end
  end
  ToClient_RequestRecommendList(productNoRaw)
end
function InGameShop_OpenClassList()
  local self = inGameShop
  local list = self._combo_Class:GetListControl()
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self._combo_Class:ToggleListbox()
end
function InGameShop_SelectClass()
  local self = inGameShop
  local selectIndex = self._combo_Class:GetSelectIndex()
  if -1 == selectIndex then
    return
  end
  self._goodDescBG:SetShow(false)
  if getCharacterClassCount() == self._combo_Class:GetSelectKey() and 0 == self._combo_Class:GetSelectIndex() then
    getIngameCashMall():setCurrentClass(-1)
  else
    getIngameCashMall():setCurrentClass(self._combo_Class:GetSelectKey())
  end
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self._combo_Class:SetSelectItemIndex(selectIndex)
  self._currentPos = 0
  self._position = 0
  self._scroll_IngameCash:SetControlPos(0)
  self._goodDescBG:SetSize(self._goodDescBG:GetSizeX(), 1)
  self:initData()
  self:update()
end
function InGameShop_OpenSorList()
  local self = inGameShop
  local list = self._combo_Sort:GetListControl()
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self._combo_Sort:ToggleListbox()
end
function InGameShop_SelectSort()
  local self = inGameShop
  local selectIndex = self._combo_Sort:GetSelectIndex()
  if -1 == selectIndex then
    return
  end
  self._goodDescBG:SetShow(false)
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self._combo_Sort:SetSelectItemIndex(selectIndex)
  if 0 == self._combo_Sort:GetSelectKey() then
    getIngameCashMall():setCurrentSort(-1)
  else
    getIngameCashMall():setCurrentSort(self._combo_Sort:GetSelectKey())
  end
  self._currentPos = 0
  self._position = 0
  self._scroll_IngameCash:SetControlPos(0)
  self._goodDescBG:SetSize(self._goodDescBG:GetSizeX(), 1)
  self:initData()
  self:update()
end
function InGameShop_OpenSubFilterList()
  local self = inGameShop
  local list = self._combo_SubFilter:GetListControl()
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self._combo_SubFilter:ToggleListbox()
end
function InGameShop_SelectSubFilter()
  local self = inGameShop
  local selectIndex = self._combo_SubFilter:GetSelectIndex()
  if -1 == selectIndex then
    return
  end
  self._goodDescBG:SetShow(false)
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self._combo_SubFilter:SetSelectItemIndex(selectIndex)
  if 0 == self._combo_SubFilter:GetSelectKey() then
    getIngameCashMall():setCurrentSubFilter(-1)
  else
    getIngameCashMall():setCurrentSubFilter(self._combo_SubFilter:GetSelectKey())
  end
  self._currentPos = 0
  self._position = 0
  self._scroll_IngameCash:SetControlPos(0)
  self._goodDescBG:SetSize(self._goodDescBG:GetSizeX(), 1)
  self:initData()
  self:update()
end
local isFirstRespone = true
function InGameShop_UpdateCashShop()
  local self = inGameShop
  self._static_Construction:SetShow(false)
  if PaGlobal_RecommendManager:isFromRecommend() then
    PaGlobal_RecommendManager:UsedFromRecommend()
    return
  end
  if self._openByEventAlarm then
    self:RadioReset()
    self._tabs[1].static:SetCheck(true)
    InGameShop_TabEvent(1)
  else
    Panel_IngameCashShop:SetChildIndex(self._promotionTab.static, 9900)
  end
end
function InGameShop_UpdateCash()
  local self = inGameShop
  local cash, pearl, mileage = self:updateMoney()
  return cash, pearl, mileage
end
function InGameShop_OuterEventByAttacked()
  if Panel_IngameCashShop:GetShow() then
    InGameShop_CloseActual()
  end
end
function InGameShop_OuterEventForDead()
  InGameShop_CloseActual()
end
function InGameShop_Resize()
  local self = inGameShop
  local slotConfig = self._config._slot
  local tabConfig = self._config._tab
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_IngameCashShop:GetSizeX()
  local panelSizeY = Panel_IngameCashShop:GetSizeY()
  Panel_IngameCashShop:SetPosX(40)
  Panel_IngameCashShop:SetPosY(0)
  Panel_IngameCashShop:SetSize(Panel_IngameCashShop:GetSizeX(), scrSizeY)
  self._static_SideLineLeft:SetSize(self._static_SideLineLeft:GetSizeX(), scrSizeY)
  self._static_SideLineRight:SetSize(self._static_SideLineRight:GetSizeX(), scrSizeY)
  self._staticText_CashCount:ComputePos()
  self._staticText_PearlCount:ComputePos()
  self._staticText_SilverCount:ComputePos()
  self._staticText_MileageCount:ComputePos()
  self._haveCashBoxBG:ComputePos()
  self._pearlBox:ComputePos()
  self._nowPearlIcon:ComputePos()
  self._btn_BuyPearl:ComputePos()
  self._silverBox:ComputePos()
  self._silver:ComputePos()
  self._mileageBox:ComputePos()
  self._mileage:ComputePos()
  self._cashBox:ComputePos()
  self._nowCash:ComputePos()
  self._btn_BuyDaum:ComputePos()
  self._btn_RefreshCash:ComputePos()
  self._btn_HowUsePearl:ComputePos()
  if true == isKorea and true == isNaver then
    self._staticText_CashCount:SetShow(false)
    self._cashBox:SetShow(false)
    self._nowCash:SetShow(false)
    self._btn_BuyDaum:SetShow(false)
    self._btn_RefreshCash:SetShow(false)
  end
  tabConfig._startY = self._promotionTab.static:GetPosY() + self._promotionTab.static:GetSizeY() - 20
  if true == self._isHotDealOpen then
    self._myCartTab.static:SetPosY(tabConfig._startY + tabConfig._gapY * (tabId.cart - 2))
  else
    self._myCartTab.static:SetPosY(tabConfig._startY + tabConfig._gapY * (tabId.cart - 1))
  end
  self:initTabPos()
  local remainingSizeY = _ingameCashShop_SetViewListCount()
  self._static_GradationBottom:SetPosX(slotConfig._startX)
  self._static_GradationBottom:SetPosY(self._static_ScrollArea:GetSizeY() + self._static_ScrollArea:GetPosY() - 50)
  self._scroll_IngameCash:SetSize(self._scroll_IngameCash:GetSizeX(), remainingSizeY * 0.98)
  self._static_ScrollArea:SetSize(self._static_ScrollArea:GetSizeX(), remainingSizeY * 0.98)
  self._static_ScrollArea1:SetPosY(0)
  self._static_ScrollArea1:SetSize(self._static_ScrollArea1:GetSizeX(), self._static_ScrollArea:GetPosY())
  self._static_ScrollArea2:SetPosY(self._static_ScrollArea:GetPosY() + self._static_ScrollArea:GetSizeY())
  self._static_ScrollArea2:SetSize(self._static_ScrollArea2:GetSizeX(), 1000)
  local cartPosX = Panel_IngameCashShop:GetPosX() + slotConfig._startX
  local cartPosY = Panel_IngameCashShop:GetPosY() + slotConfig._startY
  FGlobal_InitPos_IngameCashShop_NewCart(cartPosX, cartPosY, remainingSizeY, self._static_TopLineBG:GetSizeY() + self._haveCashBoxBG:GetSpanSize().y)
  self._promotionWeb:SetSize(self._promotionWeb:GetSizeX(), self._promotionSizeY)
  self._static_GradationTop:SetPosX(slotConfig._startX)
  self._static_GradationTop:SetPosY(slotConfig._startY)
  self._static_GradationBottom:SetPosX(slotConfig._startX)
  self._static_GradationBottom:SetPosY(self._static_ScrollArea:GetSizeY() + self._static_ScrollArea:GetPosY() - self._static_GradationBottom:GetSizeY())
  Panel_IngameCashShop:SetChildIndex(self._promotionWeb, 9900)
  _AllBG:SetSize(_AllBG:GetSizeX(), getScreenSizeY() - 95)
  local _btn_SizeX = self._btn_HowUsePearl:GetSizeX() + 23
  local _btn_TextSizeX = _btn_SizeX - _btn_SizeX / 2 - self._btn_HowUsePearl:GetTextSizeX() / 2
  self._btn_HowUsePearl:SetTextSpan(_btn_TextSizeX, 4)
end
function _ingameCashShop_SetViewListCount()
  local self = inGameShop
  local scrSizeY = getScreenSizeY()
  local areaPosY = self._static_ScrollArea:GetPosY()
  local banner = self._static_PromotionBanner:GetPosY() + self._static_PromotionBanner:GetSizeY()
  local bannerEndGap = self._static_TopLineBG:GetPosY() - (self._static_PromotionBanner:GetPosY() + self._static_PromotionBanner:GetSizeY())
  local filterFize = self._static_TopLineBG:GetSizeY() + (self._static_TopLineBG:GetPosY() - (self._static_PromotionBanner:GetPosY() + self._static_PromotionBanner:GetSizeY()))
  local endGap = areaPosY - (self._static_TopLineBG:GetPosY() + self._static_TopLineBG:GetSizeY())
  local chargeSize = self._haveCashBoxBG:GetSpanSize().y + self._haveCashBoxBG:GetSizeY()
  local fixedHeight = banner + bannerEndGap + filterFize + endGap + chargeSize
  self._promotionSizeY = scrSizeY - endGap - chargeSize - self._static_PromotionBanner:GetPosY()
  local gapBetweenList = self._config._slot._gapY
  local remainingSizeY = scrSizeY - fixedHeight
  local possiableList = math.floor(remainingSizeY / gapBetweenList)
  self._slotCount = possiableList + 1
  return remainingSizeY
end
local cumulatedTime = 0
function InGameCashshopUpdatePerFrame(deltaTime)
  local self = inGameShop
  if true == disCountSetUse then
    cumulatedTime = cumulatedTime + deltaTime
    if cumulatedTime > 1 then
      cumulatedTime = 0
      CashShopUpdateRamainedTimePerSecond()
    end
  end
  InGameCashshopDescUpdate(deltaTime)
  if true == PaGlobal_Recommend_PopUp._isRequestShow then
    if Panel_Window_RecommandGoods_PopUp:GetShow() then
      PaGlobal_Recommend_PopUp._isRequestShow = false
    else
      PaGlobal_Recommend_PopUp:Open()
    end
  end
  if true == self._remainHotDealTime:GetShow() then
    local timeData = ToClient_getRemainHotDealTime()
    local remainTime = convertStringFromDatetime(timeData)
    local desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CASHPRODUCTHOTDEAL_REMAINTIME", "remainTime", remainTime)
    self._remainHotDealTime:SetText(desc)
  end
end
function CashShopUpdateRamainedTimePerSecond()
  local self = inGameShop
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(self._openProductKeyRaw)
  if nil == cashProduct then
    return
  end
  local itemCount = cashProduct:getItemListCount()
  for ii = 0, itemCount - 1 do
    local remainTime = cashProduct:getRemainDiscountTime()
    if cashProduct:isApplyDiscount() then
      self.desc._static_DiscountPeriodDesc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTPERIODDESC", "endDiscountTime", convertStringFromDatetime(remainTime)))
    end
  end
end
function InGameCashshopDescUpdate(deltaTime)
  local self = inGameShop
  if self._position == self._currentPos and self._maxDescSize == self._goodDescBG:GetSizeY() and self:getMaxPosition() < self._position + 2 then
    self._static_GradationBottom:SetShow(false)
  else
    self._static_GradationBottom:SetShow(true == self:isGradationShowAble())
  end
  self._currentPos = self._currentPos + (self._position - self._currentPos) * deltaTime * 15
  if math.abs(self._position - self._currentPos) < 1 then
    self._currentPos = self._position
  end
  if false == self._isClick then
    if -1 ~= self._openProductKeyRaw then
      self._goodDescBG:SetSize(self._goodDescBG:GetSizeX(), self._goodDescBG:GetSizeY() + (self._maxDescSize - self._goodDescBG:GetSizeY()) * deltaTime * 3)
      if self._maxDescSize - self._goodDescBG:GetSizeY() < 1 then
        self._goodDescBG:SetSize(self._goodDescBG:GetSizeX(), self._maxDescSize)
      end
    end
  elseif self._isClick then
    if self._goodDescBG:GetSizeY() > 1.5 then
      self._goodDescBG:SetSize(self._goodDescBG:GetSizeX(), self._goodDescBG:GetSizeY() - self._goodDescBG:GetSizeY() * deltaTime * 3)
      if self:getMaxPosition() - self._position < self._config._slot._gapY and self._scroll_IngameCash:GetShow() then
        self._position = self._position - self._goodDescBG:GetSizeY() * deltaTime * 3
      end
    else
      self._goodDescBG:SetSize(self._goodDescBG:GetSizeX(), 1)
      if self._isSubItemClick then
        InGameShop_subItemEvent(1)
        self._isSubItemClick = false
        for ii = 1, inGameShop._subItemCount do
          if ii == 1 then
            inGameShop._subItemButton[ii].static:SetCheck(true)
          else
            inGameShop._subItemButton[ii].static:SetCheck(false)
          end
        end
      end
    end
    self._currentIndex = nil
  end
  for _, control in pairs(inGameShop.desc) do
    control:SetShow(0 < control:GetPosY() + control:GetSizeY() and control:GetPosY() + control:GetSizeY() < self._goodDescBG:GetSizeY())
    IngameCashShop_DescUpdate()
  end
  if 1 < inGameShop._listComboIncludeDummyCount then
    for ii = 1, inGameShop._listComboIncludeDummyCount do
      local sunItem = inGameShop._subItemButton[ii].static
      sunItem:SetShow(0 < sunItem:GetPosY() + sunItem:GetSizeY() and sunItem:GetPosY() + sunItem:GetSizeY() < self._goodDescBG:GetSizeY())
    end
  end
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(inGameShop._openProductKeyRaw)
  if nil ~= cashProduct and cashProduct:isChooseCash() then
    local validChooseCashProduct = cashProduct:chooseCashCount()
    for ii = 0, validChooseCashProduct - 1 do
      local chooseProduct = inGameShop._chooseProductList[ii]
      chooseProduct.staticBG:SetShow(0 < chooseProduct.staticBG:GetPosY() + chooseProduct.staticBG:GetSizeY() and chooseProduct.staticBG:GetPosY() + chooseProduct.staticBG:GetSizeY() < self._goodDescBG:GetSizeY())
      chooseProduct.staticAddPlusBtn:SetShow(0 < chooseProduct.staticAddPlusBtn:GetPosY() + chooseProduct.staticAddPlusBtn:GetSizeY() and chooseProduct.staticAddPlusBtn:GetPosY() + chooseProduct.staticAddPlusBtn:GetSizeY() < self._goodDescBG:GetSizeY())
      chooseProduct.staticAddMinusBtn:SetShow(0 < chooseProduct.staticAddMinusBtn:GetPosY() + chooseProduct.staticAddMinusBtn:GetSizeY() and chooseProduct.staticAddMinusBtn:GetPosY() + chooseProduct.staticAddMinusBtn:GetSizeY() < self._goodDescBG:GetSizeY())
      chooseProduct.staticEditCount:SetShow(0 < chooseProduct.staticEditCount:GetPosY() + chooseProduct.staticEditCount:GetSizeY() and chooseProduct.staticEditCount:GetPosY() + chooseProduct.staticEditCount:GetSizeY() < self._goodDescBG:GetSizeY())
    end
  end
  for key, slot in pairs(inGameShop._static_EquipSlots) do
    local slotIcon = slot._slotIcon
    if nil ~= cashProduct and false == cashProduct:isChooseCash() and true == cashProduct:isShowSlotIcon(slot._slotNo) then
      slotIcon:SetShow(0 < slotIcon:GetPosY() + slotIcon:GetSizeY() and slotIcon:GetPosY() + slotIcon:GetSizeY() < self._goodDescBG:GetSizeY())
    else
      slotIcon:SetShow(false)
    end
  end
  IngameCashShop_DescUpdate()
  self:updateSlot()
end
function inGameShop:isClearToOpen()
  if isGameTypeGT() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TESTSERVER_CAUTION"))
    return false
  end
  if isDeadInWatchingMode() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CASHSHOPOPENALERT_INDEAD"))
    return false
  end
  if true == ToClient_getJoinGuildBattle() then
    return false
  end
  if true == ToClient_getJoinGuildBattle() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CASHSHOPOPENALERT_INDEAD"))
    return false
  end
  if true == ToClient_SniperGame_IsPlaying() then
    return false
  end
  if ToClient_IsConferenceMode() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_NOTUSE"))
    return false
  end
  if not FGlobal_IsCommercialService() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_NOTUSE"))
    return false
  end
  if Panel_IngameCashShop:GetShow() then
    return false
  end
  if nil == getIngameCashMall() then
    return false
  end
  if getIngameCashMall():isShow() then
    return false
  end
  return true
end
function InGameShop_SetHotDeal()
  local self = inGameShop
  self._isOpenFromHotDeal = true
end
function InGameShop_Open()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if true == ToClient_isBlockedCashShop() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoChangeCashProduct"))
    return
  end
  if not inGameShop:isClearToOpen() then
    return
  end
  PaGlobalFunc_FullScreenFade_RunAfterFadeIn(InGameShop_OpenActual)
end
function InGameShop_OpenActual()
  if true == _ContentsGroup_RenewUI_PearlShop and true == _ContentsGroup_XB_Obt then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NOTAVAILABLE_NOW"))
    return
  end
  PaGlobalFunc_FullScreenFade_FadeOut()
  if not inGameShop:isClearToOpen() then
    return
  end
  if not getIngameCashMall():show() then
    return
  end
  ToClient_SaveUiInfo(false)
  PaGlobal_IngameCashShop_OtherPanels_Close()
  if Panel_Win_System:GetShow() then
    allClearMessageData()
  end
  audioPostEvent_SystemUi(1, 39)
  _AudioPostEvent_SystemUiForXBOX(1, 39)
  if not isNaver then
    cashShop_requestCash()
  end
  cashShop_requestCashShopList()
  SetUIMode(Defines.UIMode.eUIMode_InGameCashShop)
  renderMode:set()
  FGlobal_CashShop_SetEquip_CouponEffectCheck()
  getIngameCashMall():clearEquipViewList()
  getIngameCashMall():changeViewMyCharacter()
  local self = inGameShop
  _ingameCashShop_SetViewListCount()
  if not _ContentsGroup_RenewUI_PearlShop then
    cashShop_Controller_Open()
  end
  FGlobal_CashShop_SetEquip_Open()
  for ii = 1, self._tabCount do
    self._tabs[ii].static:SetCheck(false)
  end
  FGlobal_HideWorkerTooltip()
  TooltipSimple_Hide()
  FGlobal_Hide_Tooltip_Work(nil, true)
  self._openFunction = true
  self._static_Construction:ComputePos()
  self._static_Construction:SetShow(false)
  if _ContentsGroup_RenewUI_PearlShop then
    PaGlobalFunc_PearlShopCategoryOpen(true)
    PaGlobalFunc_PearlShopDisplayController_ResetWeather()
  else
    Panel_IngameCashShop:SetShow(true)
  end
  Panel_Tooltip_Item_hideTooltip()
  Panel_Tooltip_Item_chattingLinkedItemClick_hideTooltip()
  self._promotionTab.static:SetCheck(true)
  self._scroll_IngameCash:SetShow(false)
  local scrSizeY = getScreenSizeY()
  local SALangType = "pt"
  if UI_SERVICE_RESOURCE.eServiceResourceType_ES == getGameServiceResType() then
    SALangType = "es"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_PT == getGameServiceResType() then
    SALangType = "pt"
  end
  local categoryUrl = ""
  local promotionUrl = ""
  if isGameTypeKorea() then
    if CppEnums.CountryType.KOR_ALPHA == getGameServiceType() then
      promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_DEV_URL_PROMOTIONURL")
      categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_DEV_URL_CATEGORYURL")
    elseif CppEnums.CountryType.KOR_REAL == getGameServiceType() then
      promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL")
      categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL")
    end
  elseif isGameTypeTaiwan() then
    if CppEnums.CountryType.TW_ALPHA == getGameServiceType() then
      promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TW_ALPHA")
      categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_TW_ALPHA")
    elseif CppEnums.CountryType.TW_REAL == getGameServiceType() then
      promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TW")
      categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_TW")
    end
  elseif isGameTypeKR2() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_KR2")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_KR2")
  elseif CppEnums.CountryType.SA_ALPHA == getGameServiceType() then
    promotionUrl = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_SA_ALPHA", "lang", SALangType)
    categoryUrl = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_SA_ALPHA", "lang", SALangType)
  elseif CppEnums.CountryType.SA_REAL == getGameServiceType() then
    promotionUrl = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_SA", "lang", SALangType)
    categoryUrl = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_SA", "lang", SALangType)
  elseif CppEnums.CountryType.TR_ALPHA == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TR_ALPHA")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_TR_ALPHA")
  elseif CppEnums.CountryType.TR_REAL == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TR")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_TR")
  elseif CppEnums.CountryType.TH_ALPHA == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TH_ALPHA")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_TH_ALPHA")
  elseif CppEnums.CountryType.TH_REAL == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TH")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_TH")
  elseif CppEnums.CountryType.ID_ALPHA == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_ID_ALPHA")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_ID_ALPHA")
  elseif CppEnums.CountryType.ID_REAL == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_ID")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_ID")
  elseif CppEnums.CountryType.RUS_ALPHA == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_RUS_ALPHA")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_RUS_ALPHA")
  elseif CppEnums.CountryType.RUS_REAL == getGameServiceType() then
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_RUS")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_RUS")
  else
    promotionUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL")
    categoryUrl = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL")
  end
  if true == isGameTypeKorea() then
    serviceContry = contry.kr
  elseif true == isGameTypeJapan() then
    serviceContry = contry.jp
  elseif true == isGameTypeRussia() then
    serviceContry = contry.ru
  elseif true == isGameTypeKR2() then
    serviceContry = contry.kr2
  elseif true == isGameTypeEnglish() then
    serviceContry = contry.na
  elseif true == isGameTypeTR() then
    serviceContry = contry.tr
  elseif true == isGameTypeSA() then
    serviceContry = contry.sa
  elseif true == isGameTypeID() then
    serviceContry = contry.na
  else
    serviceContry = contry.kr
  end
  cashIcon_changeTextureForList(self._mileage, serviceContry, cashIconType.mileage)
  if not ToClient_isConsole() then
    FGlobal_SetCandidate()
    self._categoryWeb:SetUrl(self._categoryWeb:GetSizeX(), self._categoryWeb:GetSizeY(), categoryUrl, false, isTaiwanNation)
    self._categoryWeb:SetShow(false)
    self._categoryWeb:SetIME()
    self._promotionWeb:SetUrl(self._promotionWeb:GetSizeX(), self._promotionSizeY, promotionUrl, false, isTaiwanNation)
    _AllBG:SetSize(_AllBG:GetSizeX(), self._promotionSizeY)
    self._promotionWeb:SetIME()
    InGameShop_Promotion_Open()
  end
  FGlobal_SpecialMoveSettingCheck()
  FGlobal_BuffTooltipOff()
  self._ViewingRecommend = false
  if true == isFirstRespone then
    for ii = 1, self._tabCount do
      getIngameCashMall():setCurrentCategory(tabIndexList[ii][2])
      local subCategoryCount = getCashMiddleCategorySize(tabIndexList[ii][2])
      for jj = 1, subCategoryCount do
        getIngameCashMall():setSearchText("")
        getIngameCashMall():setCurrentClass(-1)
        getIngameCashMall():setCurrentSort(-1)
        getIngameCashMall():setCurrentSubFilter(-1)
        getIngameCashMall():setCurrentSubTab(jj)
        getIngameCashMall():setCashProductNoRawFilterList()
        if getIngameCashMall():getCashProductFilterListCount() <= 0 then
          self._tabs[ii]._subTab[jj] = nil
        end
        if 1 == ii then
          InGameShop_CheckHotAndNewButton(getIngameCashMall():getCashProductFilterListCount() > 0, jj)
        end
      end
    end
    isFirstRespone = false
  end
  if true == self._isOpenFromHotDeal then
    self._promotionTab.static:SetCheck(false)
    self._tabs[self._hotDealTabIndex].static:SetCheck(true)
    InGameShop_TabEvent(self._hotDealTabIndex)
    self._isOpenFromHotDeal = false
  end
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_CASHSHOP")
  if true == self._isForcedOpenSaleTab then
    InGameShop_GotoSaleTab()
  end
  self._isForcedOpenSaleTab = false
end
function FGlobal_CheckPromotionTab()
  local self = inGameShop
  self._promotionTab.static:SetCheck(true)
end
function inGameShop:isClearToClose()
  if not Panel_IngameCashShop:GetShow() and not Panel_IngameCashShop_BuyOrGift:GetShow() and not Panel_IngameCashShop_NewCart:GetShow() and not Panel_IngameCashShop_GoodsDetailInfo:GetShow() and not Panel_IngameCashShop_Password:GetShow() and not Panel_IngameCashShop_SetEquip:GetShow() and not Panel_IngameCashShop_Controller:GetShow() then
    return false
  end
  return true
end
function InGameShop_Close()
  if not inGameShop:isClearToClose() then
    return
  end
  PaGlobalFunc_FullScreenFade_RunAfterFadeIn(InGameShop_CloseActual)
end
function InGameShop_CloseActual()
  PaGlobalFunc_FullScreenFade_FadeOut()
  if not inGameShop:isClearToClose() then
    return
  end
  local self = inGameShop
  if nil ~= getIngameCashMall() then
    getIngameCashMall():clearEquipViewList()
    getIngameCashMall():changeViewMyCharacter()
    getIngameCashMall():hide()
  end
  FGlobal_CashShop_SetEquip_Close()
  cashShop_Controller_Close()
  if nil ~= Panel_Window_MarketPlace_Function and true == Panel_Window_MarketPlace_Function:GetShow() then
    SetUIMode(Defines.UIMode.eUIMode_ItemMarket)
  else
    SetUIMode(Defines.UIMode.eUIMode_Default)
  end
  renderMode:reset()
  if Panel_QnAWebLink:GetShow() then
    FGlobal_QnAWebLink_Close()
  end
  if Panel_Window_Inventory:GetShow() and false == _ContentsGroup_RenewUI then
    InventoryWindow_Close()
    Inventory_SetFunctor(nil, nil, nil, nil)
    if Panel_Equipment:GetShow() then
      EquipmentWindow_Close()
    end
  end
  Panel_Tooltip_Item_hideTooltip()
  Panel_Tooltip_Item_chattingLinkedItemClick_hideTooltip()
  if Panel_Win_System:GetShow() then
    allClearMessageData()
  end
  if Panel_IngameCashShop_Coupon:GetShow() then
    IngameCashShopCoupon_Close()
  end
  if Panel_IngameCashShop_EventCart:GetShow() then
    IngameCashShopEventCart_Close()
  end
  if Panel_Window_RecommandGoods_PopUp:GetShow() then
    Panel_Window_RecommandGoods_PopUp:Close()
  end
  if Panel_ChangeWeapon:GetShow() then
    WeaponChange_Close()
  end
  if Panel_IngameCashShop_NewCart:GetShow() then
    FGlobal_Close_IngameCashShop_NewCart()
  end
  if nil ~= PaGlobalFunc_CashMileage_GetShow and PaGlobalFunc_CashMileage_GetShow() then
    PaGlobal_CashMileage_Close()
  end
  if false == _ContentsGroup_RemasterUI_Main_Alert and false == ToClient_isConsole() then
    FGlobal_RightBottomIconReposition()
  end
  if not ToClient_isConsole() then
    self._promotionWeb:ResetUrl()
    self._categoryWeb:ResetUrl()
  end
  if true == Panel_IngameCashShop_BuyOrGift:GetShow() then
    InGameShopBuy_Close()
  end
  self._promotionWeb:SetShow(false)
  self._categoryWeb:SetShow(false)
  self._openProductKeyRaw = -1
  self._goodDescBG:SetShow(false)
  _AllBG:SetShow(true)
  self._openFunction = false
  self._openByEventAlarm = false
  ClearFocusEdit()
  if _ContentsGroup_RenewUI_PearlShop then
    PaGlobalFunc_PearlShopCategoryClose()
    PaGlobalFunc_PearlShopClose()
    PaGlobalFunc_PearlShopProductBuyClose()
    PaGlobalFunc_PearlShopProductInfoClose()
    PaGlobalFunc_PearlShop_ClassFilter_Hidden()
    PaGlobalFunc_WebControl_Close()
  else
    Panel_IngameCashShop:SetShow(false)
  end
  FGlobal_ClearCandidate()
  FGlobal_CashShop_GoodsTooltipInfo_Close()
  Panel_IngameCashShop_HowUsePearlShop_Close()
  reloadGameUI()
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
function InGameShop_UpdateCartButton()
  local cartListCount = getIngameCashMall():getCartListCount()
  inGameShop._myCartTab.static:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_UPDATECART", "cartListCount", cartListCount))
end
function ToClient_RequestShowProduct(productNo, price, bValue)
  local self = inGameShop
  if not Panel_IngameCashShop:GetShow() then
    InGameShop_OpenActual()
  end
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNo)
  if nil ~= cashProduct then
    local isAdultPeople = ToClient_isAdultUser()
    local isAdultProduct = cashProduct:isAdultProduct()
    if not isAdultPeople and isAdultProduct then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TEENWORLD_DONTBUY"))
      return
    end
    local category = cashProduct:getMainCategory()
    local tabIndex = 0
    for ii = 1, self._tabCount do
      if category == tabIndexList[ii][2] then
        tabIndex = ii
      end
    end
    if 0 == tabIndex then
      return
    end
    self:RadioReset()
    self._tabs[tabIndex].static:SetCheck(true)
    InGameShop_TabEvent(tabIndex)
    self._promotionWeb:SetShow(false)
    self._combo_Class:SetSelectItemIndex(0)
    getIngameCashMall():setCurrentClass(-1)
    InGameShop_SelectClass()
    self:RadioReset()
    if nil ~= self._tabs[tabIndex] then
      self._tabs[tabIndex].static:SetCheck(true)
    end
    inGameShop._cashProductNoData = productNo
    IngameCashShop_SelectedItemXXX(productNo, true, bValue)
    for ii = 1, inGameShop._listComboCount do
      if nil ~= inGameShop._comboList[ii] and inGameShop._subItemButton[ii].productNo == productNo then
        inGameShop._cashProductIndex = ii
      end
    end
    inGameShop._subItemButton[1].static:SetCheck(false)
    inGameShop._subItemButton[inGameShop._cashProductIndex].static:SetCheck(true)
    InGameShop_subItemEvent(inGameShop._cashProductIndex)
  end
end
function ToClient_CategoryWebFocusOut()
  local self = inGameShop
  self._categoryWeb:FocusOut()
end
function InGameShop_HowUsePearlShop()
  Panel_IngameCashShop_HowUsePearlShop_Open()
end
function FGlobal_CheckEditBox_IngameCashShop(uiEditBox)
  local self = inGameShop
  return nil ~= uiEditBox and nil ~= self._edit_Search and uiEditBox:GetKey() == self._edit_Search:GetKey() and Panel_IngameCashShop:GetShow()
end
function FGlobal_EscapeEditBox_IngameCashShop()
  local self = inGameShop
  ClearFocusEdit(self._edit_Search)
end
function FGlobal_CheckGiftLevel_IngameCashShop()
  return IngameCashShop_CheckGiftLevel()
end
function InGameShop_MoneyIcon_Tooltip(isShow, tipType)
  local self = inGameShop
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_MONEYICON_TOOLTIP_PEARL_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_MONEYICON_TOOLTIP_PEARL_DESC")
    control = self._nowPearlIcon
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_MONEYICON_TOOLTIP_MILEAGE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_MONEYICON_TOOLTIP_MILEAGE_DESC")
    control = self._mileage
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_MONEYICON_TOOLTIP_DAUMCASH_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_MONEYICON_TOOLTIP_DAUMCASH_DESC")
    if isGameTypeTR() then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_MONEYICON_TOOLTIP_DAUMCASH_NAME_TR")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_MONEYICON_TOOLTIP_DAUMCASH_DESC_TR")
    elseif isGameTypeTH() then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_MONEYICON_TOOLTIP_DAUMCASH_NAME_TH")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_MONEYICON_TOOLTIP_DAUMCASH_DESC_TH")
    elseif isGameTypeID() then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_MONEYICON_TOOLTIP_DAUMCASH_NAME_ID")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_MONEYICON_TOOLTIP_DAUMCASH_DESC_ID")
    end
    control = self._nowCash
  end
  if isShow == true then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function InGameShop_SubTab_Tooltip(isShow, ii, jj)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local self = inGameShop
  local name, desc, control
  name = getCashCategoryName(tabIndexList[ii][2], jj)
  control = self._tabs[ii]._subTab[jj].text
  TooltipSimple_Show(control, name, desc)
end
inGameShop:init()
InGameShop_GameTypeCheck()
IngameCashShop_Descinit()
inGameShop:registEventHandler()
inGameShop:registMessageHandler()
inGameShop:initTabPos()
renderMode:setClosefunctor(renderMode, InGameShop_Close)
function FromClient_ShowRecommendProductByComplete()
  PaGlobal_Recommend_PopUp._isRequestShow = true
end
function FromClient_BlockCashShop(isBlock)
  if Panel_IngameCashShop:GetShow() and true == isBlock then
    local messageBoxMemo = PAGetString(Defines.StringSheet_SymbolNo, "eErrNoChangeCashProduct")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
      content = messageBoxMemo,
      functionYes = InGameShop_Close,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function InGameShop_GotoSaleTab()
  local self = inGameShop
  self._myCartTab.static:SetCheck(false)
  self._promotionTab.static:SetCheck(false)
  for ii = 1, self._tabCount do
    self._tabs[ii].static:SetCheck(1 == ii)
  end
  InGameShop_TabEvent(1)
  if false == self._isSubTabShow then
    makeSubTab(1)
  end
  if true == self._hotAndNewShowableList[3] then
    InGameShop_SubTabEvent(1, 4)
  end
end
function PaGlobalFunc_InGameCashShop_ForcedOpenSaleTab()
  local self = inGameShop
  self._isForcedOpenSaleTab = true
end
function inGameShop:isGradationShowAble()
  if false == self._goodDescBG:GetShow() then
    return true
  else
    return false
  end
end
function PaGlobal_IngameCashShop_OtherPanels_Close()
  if nil ~= Panel_IngameCashShop_EasyPayment and Panel_IngameCashShop_EasyPayment:IsShow() then
    Panel_IngameCashShop_EasyPayment:SetShow(false, false)
  end
  if nil ~= IngameCashShopCoupon_Close then
    IngameCashShopCoupon_Close(false)
  end
  if nil ~= PaGlobalFunc_CashMileage_GetShow and PaGlobalFunc_CashMileage_GetShow() and nil ~= PaGlobal_CashMileage_Close then
    PaGlobal_CashMileage_Close()
  end
  if nil ~= FGlobal_WebHelper_ForceClose then
    FGlobal_WebHelper_ForceClose()
  end
  if nil ~= InventoryWindow_Close then
    InventoryWindow_Close()
  end
  if nil ~= InGameShopBuy_Close then
    InGameShopBuy_Close()
  end
  if nil ~= PaymentPassword_Close then
    PaymentPassword_Close()
  end
  if nil ~= PaGlobal_RecommendGoods then
    PaGlobal_RecommendGoods:Close()
  end
  if nil ~= PaGlobal_Recommend_PopUp then
    PaGlobal_Recommend_PopUp:Close()
  end
end

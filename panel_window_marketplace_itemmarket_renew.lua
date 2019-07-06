local _panel = Panel_Window_MarketPlace_Main
local _mainBg = UI.getChildControl(_panel, "Static_MarketPlace")
local UI_color = Defines.Color
local ItemMarket = {
  _ui = {
    stc_LeftBg = UI.getChildControl(_mainBg, "Static_LeftBg"),
    stc_SearchBg = UI.getChildControl(_mainBg, "Static_SearchBg"),
    stc_MainBg = UI.getChildControl(_mainBg, "Static_Main"),
    txt_NoSerchResult = nil
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  _itemListType = {
    categoryList = 1,
    detailListByCategory = 2,
    detailListByKey = 3,
    hotListByCategory = 4
  },
  _tooltipType = {
    main = 0,
    detail = 1,
    selected = 2,
    hot = 3
  },
  _specialCategory = {saleList = 999, hotList = 9999},
  _hotListType = {down = 1, up = 2},
  _categoryIdxMap = {},
  _selectedMainKey = -1,
  _selectedSubKey = -1,
  _currentListType = nil,
  _isSelectItem = false,
  _sellInfoItemEnchantKeyRaw = 0,
  _categoryTexture = {},
  _isSearchItemTemp = false,
  _isItemListSort = false,
  _isRegistCountUpperSort = false
}
function PaGlobalFunc_ItemMarket_SearchResultClose()
  local self = ItemMarket
  self._ui.txt_NoSerchResult:SetShow(false)
end
function PaGlobalFunc_ItemMarket_Get()
  return ItemMarket
end
function PaGlobalFunc_ItemMarket_IsSubListOpen()
  local self = ItemMarket
  return self._ui.list_MarketItemList_Sub:GetShow()
end
function ItemMarket:categoryIconInit()
  local isWakenWeaponOpen = ToClient_IsContentsGroupOpen("901")
  local isAlchemyStoneOpen = ToClient_IsContentsGroupOpen("35")
  if not isWakenWeaponOpen then
    if not isAlchemyStoneOpen then
      self._categoryTexture = {
        [0] = {
          [0] = {
            2,
            83,
            27,
            108
          }
        },
        {
          [0] = {
            29,
            83,
            54,
            108
          }
        },
        {
          [0] = {
            83,
            83,
            108,
            108
          }
        },
        {
          [0] = {
            110,
            83,
            135,
            108
          }
        },
        {
          [0] = {
            137,
            83,
            162,
            108
          }
        },
        {
          [0] = {
            164,
            83,
            189,
            108
          }
        },
        {
          [0] = {
            29,
            110,
            54,
            135
          }
        },
        {
          [0] = {
            191,
            83,
            216,
            108
          }
        },
        {
          [0] = {
            218,
            83,
            243,
            108
          }
        },
        {
          [0] = {
            2,
            110,
            27,
            135
          }
        },
        {
          [0] = {
            56,
            110,
            81,
            135
          }
        },
        {
          [0] = {
            83,
            110,
            108,
            135
          }
        },
        {
          [0] = {
            137,
            110,
            162,
            135
          }
        },
        {
          [0] = {
            164,
            110,
            189,
            135
          }
        },
        {
          [0] = {
            191,
            110,
            216,
            135
          }
        },
        [999] = {
          [0] = {
            218,
            110,
            243,
            135
          }
        },
        [9999] = {
          [0] = {
            218,
            110,
            243,
            135
          }
        }
      }
    else
      self._categoryTexture = {
        [0] = {
          [0] = {
            2,
            83,
            27,
            108
          }
        },
        {
          [0] = {
            29,
            83,
            54,
            108
          }
        },
        {
          [0] = {
            83,
            83,
            108,
            108
          }
        },
        {
          [0] = {
            110,
            83,
            135,
            108
          }
        },
        {
          [0] = {
            137,
            83,
            162,
            108
          }
        },
        {
          [0] = {
            164,
            83,
            189,
            108
          }
        },
        {
          [0] = {
            29,
            110,
            54,
            135
          }
        },
        {
          [0] = {
            191,
            83,
            216,
            108
          }
        },
        {
          [0] = {
            218,
            83,
            243,
            108
          }
        },
        {
          [0] = {
            110,
            110,
            135,
            135
          }
        },
        {
          [0] = {
            2,
            110,
            27,
            135
          }
        },
        {
          [0] = {
            56,
            110,
            81,
            135
          }
        },
        {
          [0] = {
            83,
            110,
            108,
            135
          }
        },
        {
          [0] = {
            137,
            110,
            162,
            135
          }
        },
        {
          [0] = {
            164,
            110,
            189,
            135
          }
        },
        {
          [0] = {
            191,
            110,
            216,
            135
          }
        },
        [999] = {
          [0] = {
            218,
            110,
            243,
            135
          }
        },
        [9999] = {
          [0] = {
            218,
            110,
            243,
            135
          }
        }
      }
    end
  elseif not isAlchemyStoneOpen then
    self._categoryTexture = {
      [0] = {
        [0] = {
          2,
          83,
          27,
          108
        }
      },
      {
        [0] = {
          29,
          83,
          54,
          108
        }
      },
      {
        [0] = {
          56,
          83,
          81,
          108
        }
      },
      {
        [0] = {
          83,
          83,
          108,
          108
        }
      },
      {
        [0] = {
          110,
          83,
          135,
          108
        }
      },
      {
        [0] = {
          137,
          83,
          162,
          108
        }
      },
      {
        [0] = {
          164,
          83,
          189,
          108
        }
      },
      {
        [0] = {
          29,
          110,
          54,
          135
        }
      },
      {
        [0] = {
          191,
          83,
          216,
          108
        }
      },
      {
        [0] = {
          218,
          83,
          243,
          108
        }
      },
      {
        [0] = {
          2,
          110,
          27,
          135
        }
      },
      {
        [0] = {
          56,
          110,
          81,
          135
        }
      },
      {
        [0] = {
          83,
          110,
          108,
          135
        }
      },
      {
        [0] = {
          137,
          110,
          162,
          135
        }
      },
      {
        [0] = {
          164,
          110,
          189,
          135
        }
      },
      {
        [0] = {
          191,
          110,
          216,
          135
        }
      },
      [999] = {
        [0] = {
          218,
          110,
          243,
          135
        }
      },
      [9999] = {
        [0] = {
          218,
          110,
          243,
          135
        }
      }
    }
  else
    self._categoryTexture = {
      [0] = {
        [0] = {
          2,
          83,
          27,
          108
        }
      },
      {
        [0] = {
          29,
          83,
          54,
          108
        }
      },
      {
        [0] = {
          56,
          83,
          81,
          108
        }
      },
      {
        [0] = {
          83,
          83,
          108,
          108
        }
      },
      {
        [0] = {
          110,
          83,
          135,
          108
        }
      },
      {
        [0] = {
          137,
          83,
          162,
          108
        }
      },
      {
        [0] = {
          164,
          83,
          189,
          108
        }
      },
      {
        [0] = {
          29,
          110,
          54,
          135
        }
      },
      {
        [0] = {
          191,
          83,
          216,
          108
        }
      },
      {
        [0] = {
          218,
          83,
          243,
          108
        }
      },
      {
        [0] = {
          110,
          110,
          135,
          135
        }
      },
      {
        [0] = {
          2,
          110,
          27,
          135
        }
      },
      {
        [0] = {
          56,
          110,
          81,
          135
        }
      },
      {
        [0] = {
          83,
          110,
          108,
          135
        }
      },
      {
        [0] = {
          137,
          110,
          162,
          135
        }
      },
      {
        [0] = {
          164,
          110,
          189,
          135
        }
      },
      {
        [0] = {
          191,
          110,
          216,
          135
        }
      },
      [999] = {
        [0] = {
          218,
          110,
          243,
          135
        }
      },
      [9999] = {
        [0] = {
          218,
          110,
          243,
          135
        }
      }
    }
  end
end
function PaGlobalFunc_ItemMarket_Init()
  local self = ItemMarket
  self:initControl()
  self:initEvent()
  self:categoryIconInit()
end
function ItemMarket:initControl()
  self._ui.stc_WalletStatBg = UI.getChildControl(self._ui.stc_LeftBg, "Static_WalletStatBg")
  self._ui.txt_MarketInvenMoneyValue = UI.getChildControl(self._ui.stc_WalletStatBg, "StaticText_MarketInvenValue")
  self._ui.txt_MarketInvenWeightValue = UI.getChildControl(self._ui.stc_WalletStatBg, "StaticText_MarketWeightValue")
  self._ui.stc_CategoryListBg = UI.getChildControl(self._ui.stc_LeftBg, "Static_CategoryListBg")
  self._ui.list_ItemCategory = UI.getChildControl(self._ui.stc_CategoryListBg, "List2_ItemMarket_Category")
  self._ui.edit_ItemName = UI.getChildControl(self._ui.stc_SearchBg, "Edit_ItemName")
  self._ui.btn_Search = UI.getChildControl(self._ui.edit_ItemName, "Button_Search")
  self._ui.list_search = UI.getChildControl(self._ui.edit_ItemName, "List2_searchList")
  self._ui.checkBtn_FavoriteOnOff = UI.getChildControl(self._ui.stc_SearchBg, "Button_FavoriteOnOff")
  self._ui.btn_InMarketRegist = UI.getChildControl(self._ui.stc_SearchBg, "Button_InMarketRegist")
  self._ui.checkBtn_SerchType = UI.getChildControl(self._ui.stc_SearchBg, "CheckButton_SearchType")
  self._ui.btn_SortRegistItemCount = UI.getChildControl(self._ui.stc_MainBg, "Button_SortRegistItemCount")
  self._ui.checkBtn_SortAcerageTradePrice = UI.getChildControl(self._ui.stc_MainBg, "CheckButton_SortAverageTradePrice")
  self._ui.list_MarketItemList = UI.getChildControl(self._ui.stc_MainBg, "List2_ItemMarket_Main")
  self._ui.btn_BackPage = UI.getChildControl(self._ui.stc_MainBg, "Button_BackPage")
  self._ui.btn_SetRegistAlarm = UI.getChildControl(self._ui.stc_MainBg, "Button_SetRegistAlarm")
  self._ui.stc_SelectedItemBg = UI.getChildControl(self._ui.stc_MainBg, "Static_SelectedItemBg")
  self._ui.btn_ItemList = UI.getChildControl(self._ui.stc_SelectedItemBg, "Button_ItemList")
  self._ui.stc_SlotBg = UI.getChildControl(self._ui.stc_SelectedItemBg, "Static_SlotBG")
  self._ui.stc_Slot = UI.getChildControl(self._ui.stc_SelectedItemBg, "Static_Slot")
  self._ui.txt_ItemName = UI.getChildControl(self._ui.stc_SelectedItemBg, "Template_StaticText_ItemName")
  self._ui.txt_BasePriceValue = UI.getChildControl(self._ui.stc_SelectedItemBg, "StaticText_BasePriceValue")
  self._ui.txt_CountValue = UI.getChildControl(self._ui.stc_SelectedItemBg, "StaticText_CountValue")
  self._ui.list_MarketItemList_Sub = UI.getChildControl(self._ui.stc_MainBg, "List2_ItemMarket_Sub")
  self._ui.txt_NoSerchResult = UI.getChildControl(_mainBg, "StaticText_NoSearchResult")
  local list2_Content = UI.getChildControl(self._ui.list_MarketItemList, "List2_1_Content")
  local slot = {}
  local list2_ItemSlot = UI.getChildControl(list2_Content, "Template_Static_Slot")
  SlotItem.new(slot, "ItemList", 0, list2_ItemSlot, self._slotConfig)
  slot:createChild()
  list2_Content = UI.getChildControl(self._ui.list_MarketItemList_Sub, "List2_1_Content")
  slot = {}
  list2_ItemSlot = UI.getChildControl(list2_Content, "Template_Static_Slot")
  SlotItem.new(slot, "ItemListSub", 0, list2_ItemSlot, self._slotConfig)
  slot:createChild()
  slot = {}
  list2_ItemSlot = UI.getChildControl(self._ui.stc_SelectedItemBg, "Static_Slot")
  SlotItem.new(slot, "SelectItem", 0, list2_ItemSlot, self._slotConfig)
  slot:createChild()
  self._ui.edit_ItemName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false)
end
function ItemMarket:initEvent()
  self._ui.btn_InMarketRegist:addInputEvent("Mouse_LUp", "InputMLUp_MarketPlace_OpenMyWalletTab()")
  self._ui.btn_BackPage:addInputEvent("Mouse_LUp", "PaGlobalFunc_ItemMarket_BackPage()")
  self._ui.list_ItemCategory:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_ItemMarket_CreateControlCategoryList")
  self._ui.list_ItemCategory:createChildContent(CppEnums.PAUIList2ElementManagerType.tree)
  self._ui.list_MarketItemList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_ItemMarket_CreateControlMarketItemList")
  self._ui.list_MarketItemList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.list_MarketItemList_Sub:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_ItemMarket_CreateControlMarketItemSubList")
  self._ui.list_MarketItemList_Sub:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.btn_SortRegistItemCount:addInputEvent("Mouse_LUp", "PaGlobalFunc_ItemMarket_RegistCountSort()")
  self._ui.btn_SortRegistItemCount:addInputEvent("Mouse_On", "_itemMarket_ShowIconToolTip(true, " .. 12 .. ")")
  self._ui.btn_SortRegistItemCount:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  self._ui.checkBtn_FavoriteOnOff:addInputEvent("Mouse_LUp", "PaGlobalFunc_ItemMarket_FavoriteCheckOnOff()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LTPress_X, "PaGlobalFunc_ItemMarket_EditItemNameClear()")
  if ToClient_IsDevelopment() then
    self._ui.edit_ItemName:RegistReturnKeyEvent("PaGlobalFunc_ItemMarket_FindItemName()")
  else
    self._ui.edit_ItemName:setXboxVirtualKeyBoardEndEvent("PaGlobalFunc_ItemMarket_FindItemName")
  end
  self._ui.list_search:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_ItemMarket_CreateControlMarketSearchList")
  self._ui.list_search:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  registerEvent("FromClient_responseHotListByWorldMarket", "FromClient_responseHotListByWorldMarket")
  registerEvent("FromClient_responseListByWorldMarket", "FromClient_ItemMarket_ResponseList")
  registerEvent("FromClient_responseDetailListByWorldMarketByGroupNo", "FromClient_ItemMarket_ResponseDetailListByCategory")
  registerEvent("FromClient_responseDetailListByWorldMarketByItemKey", "FromClient_ItemMarket_ResponseDetailListByKey")
  registerEvent("FromClient_NotifyCompleteWorldMarketSearchList", "FromClient_NotifyCompleteWorldMarketSearchList")
end
function PaGlobalFunc_ItemMarket_RegistCountSort()
  local self = ItemMarket
  self._isRegistCountUpperSort = not self._isRegistCountUpperSort
  local isUpper = self._isRegistCountUpperSort
  TooltipSimple_Hide()
  self:changeTextureBySort(self._ui.btn_SortRegistItemCount, isUpper)
  ToClient_RegistCountSortWorldMarketList(isUpper)
end
function ItemMarket:changeTextureBySort(control, isUpper)
  local uv = {
    [0] = {
      [0] = {
        137,
        61,
        204,
        90
      },
      [1] = {
        137,
        175,
        204,
        204
      }
    },
    [1] = {
      [0] = {
        137,
        1,
        204,
        30
      },
      [1] = {
        137,
        31,
        204,
        60
      }
    }
  }
  local x1, y1, x2, y2
  if true == isUpper then
    x1, y1, x2, y2 = setTextureUV_Func(control, uv[0][0][1], uv[0][0][2], uv[0][0][3], uv[0][0][4])
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    x1, y1, x2, y2 = setTextureUV_Func(control, uv[0][1][1], uv[0][1][2], uv[0][1][3], uv[0][1][4])
    control:getOnTexture():setUV(x1, y1, x2, y2)
  else
    x1, y1, x2, y2 = setTextureUV_Func(control, uv[1][0][1], uv[1][0][2], uv[1][0][3], uv[1][0][4])
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    x1, y1, x2, y2 = setTextureUV_Func(control, uv[1][1][1], uv[1][1][2], uv[1][1][3], uv[1][1][4])
    control:getOnTexture():setUV(x1, y1, x2, y2)
  end
  control:setRenderTexture(control:getBaseTexture())
end
function FGlobal_FavoriteItem_Search(text, enchantKey)
  local self = ItemMarket
  self._isSelectItem = false
  InputMLUp_ItemMarket_RequestDetailListByKey(enchantKey)
end
function _itemMarket_FavoriteItemRegist()
  local self = ItemMarket
  local text = ""
  if true == self._isSelectItem then
    text = self._ui.txt_ItemName:GetText()
    self._ui.edit_ItemName:SetEditText(text)
    local clickItem_SSW = getItemEnchantStaticStatus(ItemEnchantKey(self._sellInfoItemEnchantKeyRaw))
    FGlobal_ItemMarket_FavoriteItem_Regist(text, self._sellInfoItemEnchantKeyRaw)
    self._isSelectItem = false
    return
  elseif true == self._ui.edit_ItemName:GetShow() then
    text = self._ui.edit_ItemName:GetEditText()
  end
  if nil == text or "" == text or PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME") == text then
    return
  end
  local itemMarketSummaryCount = getItemMarketCategorySummaryInClientCount()
  if itemMarketSummaryCount > 0 then
    FGlobal_ItemMarket_FavoriteItem_Regist(text, nil)
    self._isSelectItem = false
  end
end
function FGlobal_ItemMarket_FavoriteItemRegiste()
  _itemMarket_FavoriteItemRegist()
end
function PaGlobalFunc_ItemMarket_FavoriteBtn_CheckOff()
  local self = ItemMarket
  self._ui.checkBtn_FavoriteOnOff:SetCheck(false)
end
function PaGlobalFunc_ItemMarket_FavoriteCheckOnOff()
  local self = ItemMarket
  if true == self._ui.checkBtn_FavoriteOnOff:IsCheck() then
    FGlobal_ItemMarket_FavoriteItem_Open()
  else
    FGlobal_ItemMarket_FavoriteItem_Close()
  end
end
function PaGlobalFunc_ItemMarket_BackPage()
  local self = ItemMarket
  local subKey = self._selectedSubKey
  self._selectedSubKey = -1
  self._isItemListSort = true
  InputMLUp_ItemMarket_SubCategoryList(subKey)
end
function PaGlobalFunc_ItemMarket_CreateControlMarketItemSubList(contents, key)
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  local idx = Int64toInt32(key)
  local bg_ItemSlot = UI.getChildControl(contents, "Template_Static_Slot")
  local slot = {}
  SlotItem.reInclude(slot, "ItemListSub", 0, bg_ItemSlot, self._slotConfig)
  slot.icon:EraseAllEffect()
  local txt_ItemName = UI.getChildControl(contents, "Template_StaticText_ItemName")
  local btn_ButtonBg = UI.getChildControl(contents, "Template_Button_ItemList")
  local txt_ItemBasePrice = UI.getChildControl(contents, "Template_StaticText_BasePriceValue")
  local txt_ItemCount = UI.getChildControl(contents, "Template_StaticText_CountValue")
  slot.icon:addInputEvent("Mouse_On", "")
  slot.icon:addInputEvent("Mouse_Out", "")
  btn_ButtonBg:addInputEvent("Mouse_LUp", "")
  local itemInfo
  if self._itemListType.detailListByKey == self._currentListType then
    itemInfo = getWorldMarketDetailListByIdx(idx)
  elseif self._itemListType.hotListByCategory == self._currentListType then
    itemInfo = getWorldMarketHotListByIdx(idx)
  end
  if nil == itemInfo then
    _PA_ASSERT(false, "\236\160\149\235\179\180\234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : getWorldMarketListByIdx( idx )")
    return
  end
  local itemSSW = itemInfo:getItemEnchantStaticStatusWrapper()
  if nil == itemSSW then
    return
  end
  btn_ButtonBg:SetColor(Defines.Color.C_FFFFFFFF)
  if self._itemListType.hotListByCategory == self._currentListType then
    if self._hotListType.down == itemInfo:getFluctuationType() then
      btn_ButtonBg:SetColor(Defines.Color.C_FF96D4FC)
    elseif self._hotListType.up == itemInfo:getFluctuationType() then
      btn_ButtonBg:SetColor(Defines.Color.C_FFF26A6A)
    end
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_ItemMarket_ShowToolTip( " .. idx .. ", 3 )")
  else
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_ItemMarket_ShowToolTip( " .. idx .. ", 1 )")
  end
  local enchantLevel = itemSSW:get()._key:getEnchantLevel()
  local nameColorGrade = itemSSW:getGradeType()
  local itemCount = itemInfo:getItemCount()
  local itemBasePrice = itemInfo:getPricePerOne()
  local totalTradeCount = itemInfo:getTotalTradeCount()
  local maxEnchantLevel = itemInfo:getEnchantMaxLevel()
  local minEnchantLevel = itemInfo:getEnchantMinLevel()
  slot:setItemByStaticStatus(itemSSW, 0, -1, false, nil, false, 0, 0, nil)
  slot.isEmpty = false
  local nameColor = self:setNameColor(nameColorGrade)
  txt_ItemName:SetFontColor(nameColor)
  local itemNameStr = self:setNameAndEnchantLevel(enchantLevel, itemSSW:getItemType(), itemSSW:getName(), itemSSW:getItemClassify())
  if minEnchantLevel ~= maxEnchantLevel then
    itemNameStr = itemNameStr .. "( +" .. minEnchantLevel .. " ~ +" .. maxEnchantLevel .. " ) "
  end
  txt_ItemName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_ItemName:SetText(itemNameStr)
  txt_ItemBasePrice:SetText(makeDotMoney(itemBasePrice))
  txt_ItemCount:SetText(tostring(itemCount))
  slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
  btn_ButtonBg:addInputEvent("Mouse_LUp", "InputMLUp_ItemMarket_RequestBiddingList(" .. idx .. ")")
  PaGlobalFunc_MarketPlace_ConsoleAssist_SetSubList(self._currentListType, idx)
end
function PaGlobalFunc_ItemMarket_CreateControlMarketSearchList(contents, key)
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  local idx = Int64toInt32(key)
  local txt_ItemName = UI.getChildControl(contents, "StaticText_RecommandWord")
  local itemNameStr = ToClient_getSearchWorldMarketItemName(idx)
  txt_ItemName:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  txt_ItemName:SetText(itemNameStr)
  txt_ItemName:addInputEvent("Mouse_LUp", "InputMLUp_ItemMarket_SearchItemList(" .. idx .. ")")
  UI.setLimitTextAndAddTooltip(txt_ItemName)
end
function PaGlobalFunc_ItemMarket_CreateControlMarketItemList(contents, key)
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  local idx = Int64toInt32(key)
  local bg_ItemSlot = UI.getChildControl(contents, "Template_Static_Slot")
  local slot = {}
  SlotItem.reInclude(slot, "ItemList", 0, bg_ItemSlot, self._slotConfig)
  slot.icon:EraseAllEffect()
  local txt_ItemName = UI.getChildControl(contents, "Template_StaticText_ItemName")
  local btn_ButtonBg = UI.getChildControl(contents, "Template_Button_ItemList")
  local txt_ItemBasePrice = UI.getChildControl(contents, "Template_StaticText_BasePriceValue")
  local txt_ItemCount = UI.getChildControl(contents, "Template_StaticText_CountValue")
  local itemInfo = getWorldMarketListByIdx(idx)
  if nil == itemInfo then
    _PA_ASSERT(false, "\236\160\149\235\179\180\234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : getWorldMarketListByIdx( idx )")
    return
  end
  local itemSSW = itemInfo:getItemEnchantStaticStatusWrapper()
  local enchantLevel = itemSSW:get()._key:getEnchantLevel()
  local nameColorGrade = itemSSW:getGradeType()
  local itemCount = itemInfo:getItemCount()
  local standCount = itemInfo:getStandPrice()
  slot:setItemByStaticStatus(itemSSW)
  slot.isEmpty = false
  local nameColor = self:setNameColor(nameColorGrade)
  txt_ItemName:SetFontColor(nameColor)
  txt_ItemName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_ItemName:SetText(tostring(itemSSW:getName()))
  txt_ItemBasePrice:SetText(makeDotMoney(standCount))
  txt_ItemCount:SetText(tostring(itemCount))
  PaGlobalFunc_MarketPlace_ConsoleAssist_SetMainList(idx)
  btn_ButtonBg:addInputEvent("Mouse_LUp", "InputMLUp_ItemMarket_RequestDetailListByKey(" .. itemInfo:getItemKeyRaw() .. ")")
end
function PaGlobalFunc_ItemMarket_ShowToolTip_SelectSlot(itemKey)
  local self = ItemMarket
  slot = self._ui.stc_Slot
  itemInfo = getWorldMarketListByItemKey(itemKey)
  if nil == slot or nil == itemInfo then
    return
  end
  local itemSSW = itemInfo:getItemEnchantStaticStatusWrapper()
  PaGlobalFunc_MarketPlace_ShowToolTip(itemSSW, slot, true)
end
function PaGlobalFunc_ItemMarket_ShowToolTip(idx, tooltipType)
  local self = ItemMarket
  local list, itemInfo, slot, contents
  if self._tooltipType.main == Int64toInt32(tooltipType) then
    list = self._ui.list_MarketItemList
    itemInfo = getWorldMarketListByIdx(idx)
    contents = list:GetContentByKey(toInt64(0, idx))
    slot = UI.getChildControl(contents, "Template_Static_Slot")
  elseif self._tooltipType.detail == Int64toInt32(tooltipType) then
    list = self._ui.list_MarketItemList_Sub
    itemInfo = getWorldMarketDetailListByIdx(idx)
    contents = list:GetContentByKey(toInt64(0, idx))
    slot = UI.getChildControl(contents, "Template_Static_Slot")
  elseif self._tooltipType.hot == Int64toInt32(tooltipType) then
    list = self._ui.list_MarketItemList_Sub
    itemInfo = getWorldMarketHotListByIdx(idx)
    contents = list:GetContentByKey(toInt64(0, idx))
    slot = UI.getChildControl(contents, "Template_Static_Slot")
  end
  if nil == slot or nil == itemInfo then
    return
  end
  local itemSSW = itemInfo:getItemEnchantStaticStatusWrapper()
  PaGlobalFunc_MarketPlace_ShowToolTip(itemSSW, slot, true)
end
function PaGlobalFunc_ItemMarket_CreateControlCategoryList(contents, key)
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  local idx = Int64toInt32(key)
  local indexMap = self._categoryIdxMap[idx]
  local categoryInfo
  local btn_MainCategory = UI.getChildControl(contents, "Template_RadioButton_CategoryBar")
  local btn_CategoryIcon = UI.getChildControl(contents, "Template_RadioButton_CategoryIcon")
  local btn_SubCategory = UI.getChildControl(contents, "Template_RadioButton_SubCategoryBar")
  local stc_Arrow = UI.getChildControl(btn_SubCategory, "Template_Static_Arrow")
  if indexMap._isMain then
    btn_CategoryIcon:ChangeTextureInfoName("Renewal/UI_Icon/Console_Icon_ItemMarket_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(btn_CategoryIcon, self._categoryTexture[indexMap._index][0][1], self._categoryTexture[indexMap._index][0][2], self._categoryTexture[indexMap._index][0][3], self._categoryTexture[indexMap._index][0][4])
    btn_CategoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    btn_CategoryIcon:setRenderTexture(btn_CategoryIcon:getBaseTexture())
    if self._specialCategory.hotList == indexMap._index then
      btn_CategoryIcon:ChangeTextureInfoName("Renewal/UI_Icon/Console_Icon_ItemMarket_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(btn_CategoryIcon, self._categoryTexture[self._specialCategory.hotList][0][1], self._categoryTexture[self._specialCategory.hotList][0][2], self._categoryTexture[self._specialCategory.hotList][0][3], self._categoryTexture[self._specialCategory.hotList][0][4])
      btn_CategoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
      btn_CategoryIcon:setRenderTexture(btn_CategoryIcon:getBaseTexture())
    end
  end
  btn_MainCategory:SetCheck(idx == self._selectedMainKey)
  btn_MainCategory:SetShow(false)
  btn_SubCategory:SetShow(false)
  btn_CategoryIcon:SetShow(false)
  if true == indexMap._isMain then
    if self._specialCategory.hotList == indexMap._index then
      btn_MainCategory:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_HOTLISTTITME"))
      btn_MainCategory:SetShow(true)
      btn_CategoryIcon:SetShow(true)
      btn_MainCategory:addInputEvent("Mouse_LUp", "InputMLUp_ItemMarket_SpecialCategoryList(" .. self._specialCategory.hotList .. ")")
    elseif self._specialCategory.saleList == indexMap._index then
    else
      categoryInfo = ToClient_GetItemMarketCategoryAt(indexMap._index)
      local mainValue = categoryInfo:getMainCategoryValue()
      btn_MainCategory:SetText(mainValue:getCategoryName())
      btn_MainCategory:SetShow(true)
      btn_CategoryIcon:SetShow(true)
      btn_MainCategory:addInputEvent("Mouse_LUp", "InputMLUp_ItemMarket_MainCategoryList(" .. idx .. ")")
    end
    btn_SubCategory:SetCheck(false)
  elseif false == indexMap._isMain then
    categoryInfo = ToClient_GetItemMarketCategoryAt(indexMap._index)
    local subValue = categoryInfo:getSubCategoryAt(indexMap._subIndex)
    btn_SubCategory:SetText(subValue:getCategoryName())
    btn_SubCategory:SetShow(true)
    btn_SubCategory:SetFontColor(UI_color.C_FF8B7455)
    btn_SubCategory:addInputEvent("Mouse_LUp", "InputMLUp_ItemMarket_SubCategoryList(" .. idx .. ")")
  end
end
function InputMLUp_ItemMarket_SpecialCategoryList(idx)
  local self = ItemMarket
  local keyElement
  self._sellInfoItemEnchantKeyRaw = 0
  for key, value in pairs(self._categoryIdxMap) do
    if true == value._isMain then
      keyElement = self._ui.list_ItemCategory:getElementManager():getByKey(toInt64(0, key), false)
      if true == keyElement:getIsOpen() then
        self._ui.list_ItemCategory:getElementManager():toggle(toInt64(0, key))
      end
    end
  end
  self._selectedMainKey = idx
  if self._specialCategory.saleList == idx then
  elseif self._specialCategory.hotList == idx then
    self._ui.list_ItemCategory:getElementManager():toggle(toInt64(0, 9999))
    ToClient_requestHotListToWorldMarket()
  end
end
function ItemMarket:setSelectSlot(itemKey)
  local itemInfo = getWorldMarketListByItemKey(itemKey)
  if nil == itemInfo then
    if 0 == itemKey then
      _PA_LOG("\236\139\160\236\167\128\236\152\129", "itemKey\234\176\128 0\236\158\133\235\139\136\235\139\164! \234\184\137\235\147\177\235\157\189 \236\131\129\237\146\136\236\157\180 \236\149\132\235\139\136\235\157\188\235\169\180 \235\172\184\236\160\156\234\176\128 \236\158\136\236\138\181\235\139\136\235\139\164.")
    else
      _PA_LOG("\236\139\160\236\167\128\236\152\129", "\236\149\132\236\157\180\237\133\156 \237\130\164\234\176\146\236\157\180 \236\156\160\237\154\168\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164: getWorldMarketListByItemKey(" .. tostring(itemKey) .. ")")
    end
    InputMLUp_ItemMarket_SpecialCategoryList(9999)
    self._isSearchItemTemp = true
    return
  end
  self._isSearchItemTemp = false
  local itemSSW = itemInfo:getItemEnchantStaticStatusWrapper()
  local nameColorGrade = itemSSW:getGradeType()
  local itemCount = itemInfo:getItemCount()
  local totalTradeCount = itemInfo:getTotalTradeCount()
  local bg_ItemSlot = self._ui.stc_Slot
  local slot = {}
  SlotItem.reInclude(slot, "SelectItem", 0, bg_ItemSlot, self._slotConfig)
  slot.icon:EraseAllEffect()
  slot:setItemByStaticStatus(itemSSW)
  slot.isEmpty = false
  local nameColor = self:setNameColor(nameColorGrade)
  self._ui.txt_ItemName:SetFontColor(nameColor)
  self._ui.txt_ItemName:SetText(tostring(itemSSW:getName()))
  self._ui.txt_BasePriceValue:SetText(tostring(totalTradeCount))
  self._ui.txt_CountValue:SetText(tostring(itemCount))
  slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_ItemMarket_ShowToolTip_SelectSlot( " .. itemKey .. ")")
  slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
end
function PaGlobalFunc_MarketPlace_setNameAndEnchantLevel(enchantLevel, itemType, itemName, itemClassify)
  return ItemMarket:setNameAndEnchantLevel(enchantLevel, itemType, itemName, itemClassify)
end
function PaGlobalFunc_ItemMarket_EditItemNameClear()
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  if false == self._ui.edit_ItemName:GetShow() then
    return
  end
  self._ui.edit_ItemName:SetEditText("", true)
  SetFocusEdit(self._ui.edit_ItemName)
  PaGlobalFunc_ItemMarket_SearchItemListClear()
end
function PaGlobalFunc_ItemMarket_FindItemName(str)
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  local inputKeyword = ""
  if nil == str then
    inputKeyword = self._ui.edit_ItemName:GetEditText()
  else
    inputKeyword = str
    self._ui.edit_ItemName:SetEditText(str)
  end
  if nil == inputKeyword then
    return
  end
  ClearFocusEdit()
  if "" ~= inputKeyword and PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME") ~= inputKeyword then
    ToClient_searchWorldMarketItem(inputKeyword)
    PaGlobalFunc_ItemMarket_FindItemRequest()
  else
    PaGlobalFunc_ItemMarket_SearchItemListClear()
    return
  end
end
function PaGlobalFunc_ItemMarket_FindItemRequest()
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  local inputKeyword = self._ui.edit_ItemName:GetEditText()
  local size = string.len(inputKeyword)
  ToClient_requestSearchListByWorldMarket()
end
function PaGlobalFunc_ItemMarket_SearchItemListClear()
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  self._ui.list_search:SetShow(false)
  ToClient_clearSearchWorldMarketItemKey()
end
function ItemMarket:setNameAndEnchantLevel(enchantLevel, itemType, itemName, itemClassify)
  local nameStr = itemName
  if 1 == itemType and enchantLevel > 15 then
    nameStr = HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemName
  elseif enchantLevel > 0 and CppEnums.ItemClassifyType.eItemClassify_Accessory == itemClassify then
    nameStr = HighEnchantLevel_ReplaceString(enchantLevel + 15) .. " " .. itemName
  elseif 0 ~= enchantLevel then
    nameStr = "+" .. enchantLevel .. " " .. itemName
  end
  return nameStr
end
function PaGlobalFunc_MarketPlace_SetNameColor(nameColorGrade)
  return ItemMarket:setNameColor(nameColorGrade)
end
function PaGlobalFunc_MarketPlace_SetNameColor_Desc(nameColorGrade)
  return ItemMarket:setNameColor_Desc(nameColorGrade)
end
function ItemMarket:setNameColor(nameColorGrade)
  local nameColor
  if 0 == nameColorGrade then
    nameColor = UI_color.C_FFFFFFFF
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
  return nameColor
end
function ItemMarket:setNameColor_Desc(nameColorGrade)
  local nameColor
  if 0 == nameColorGrade then
    nameColor = "<PAColor0xffc4bebe>"
  elseif 1 == nameColorGrade then
    nameColor = "<PAColor0xFF5DFF70>"
  elseif 2 == nameColorGrade then
    nameColor = "<PAColor0xFF4B97FF>"
  elseif 3 == nameColorGrade then
    nameColor = "<PAColor0xFFFFC832>"
  elseif 4 == nameColorGrade then
    nameColor = "<PAColor0xFFFF6C00>"
  else
    nameColor = "<PAColor0xffc4bebe>"
  end
  return nameColor
end
function InputMLUp_ItemMarket_MainCategoryList(index)
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  for key, value in pairs(self._categoryIdxMap) do
    if true == value._isMain then
      local keyElement = self._ui.list_ItemCategory:getElementManager():getByKey(toInt64(0, key), false)
      keyElement:setIsOpen(false)
    end
  end
  if self._selectedMainKey ~= index then
    self._selectedMainKey = index
    self._ui.list_ItemCategory:getElementManager():toggle(toInt64(0, index))
  else
    self._selectedMainKey = -1
  end
  self._ui.list_ItemCategory:getElementManager():refillKeyList()
  local heightIndex = self._ui.list_ItemCategory:getIndexByKey(toInt64(0, index))
  self._ui.list_ItemCategory:moveIndex(heightIndex)
  local indexMap = self._categoryIdxMap[index]
  local categoryInfo = ToClient_GetItemMarketCategoryAt(indexMap._index)
  local categoryValue = categoryInfo:getMainCategoryValue()
  local filterLineCount = categoryInfo:getFilterListCount(0)
  selectMarketCategory(categoryValue:getCategoryNo(), -1)
  self._ui.list_ItemCategory:requestUpdateByKey(toInt64(0, index))
  if false == ToClient_padSnapNotifyList2TreeToggle(index) then
    ToClient_padSnapResetPanelControl(Panel_Window_MarketPlace_Main)
  end
end
function InputMLUp_ItemMarket_SubCategoryList(index)
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  self._ui.list_MarketItemList:moveTopIndex()
  local indexMap = self._categoryIdxMap[index]
  if nil == indexMap then
    InputMLUp_ItemMarket_SpecialCategoryList(9999)
    return
  end
  local categoryInfo = ToClient_GetItemMarketCategoryAt(indexMap._index)
  local filterLineCount = categoryInfo:getFilterListCount(0)
  local prevSelectedSubKey = self._selectedSubKey
  local mainCategoryValue = categoryInfo:getMainCategoryValue()
  local subCategoryValue = categoryInfo:getSubCategoryAt(indexMap._subIndex)
  if self._selectedSubKey ~= index then
    self._selectedSubKey = index
  else
    self._selectedSubKey = -1
  end
  if 0 == filterLineCount then
  else
  end
  ToClient_requestListByWorldMarket(mainCategoryValue, subCategoryValue)
  if -1 ~= prevSelectedSubKey then
    self._ui.list_ItemCategory:requestUpdateByKey(toInt64(0, prevSelectedSubKey))
  end
  self._ui.list_ItemCategory:requestUpdateByKey(toInt64(0, index))
end
function PaGlobalFunc_ItemMarket_Update()
  local self = ItemMarket
  self._ui.list_ItemCategory:getElementManager():clearKey()
  self._ui.list_MarketItemList:getElementManager():clearKey()
  self._ui.list_MarketItemList_Sub:getElementManager():clearKey()
  self._ui.stc_SelectedItemBg:SetShow(false)
  self._ui.btn_BackPage:SetShow(false)
  self._ui.btn_SetRegistAlarm:SetShow(false)
  self._ui.checkBtn_SortAcerageTradePrice:SetShow(false)
  self._ui.btn_SortRegistItemCount:SetShow(false)
  self._ui.txt_NoSerchResult:SetShow(true)
  self._ui.txt_NoSerchResult:ComputePos()
  local mainElement = self._ui.list_ItemCategory:getElementManager():getMainElement()
  local categoryCount = ToClient_GetItemMarketCategoryListCount()
  local keyIdx = 0
  mainElement:createChild(toInt64(0, 9999))
  self._categoryIdxMap[9999] = {_isMain = true, _index = 9999}
  for mainIdx = 0, categoryCount - 1 do
    local categoryInfo = ToClient_GetItemMarketCategoryAt(mainIdx)
    self._categoryIdxMap[keyIdx] = {_isMain = true, _index = mainIdx}
    local treeElement = mainElement:createChild(toInt64(0, keyIdx))
    treeElement:setIsOpen(false)
    keyIdx = keyIdx + 1
    local subCategoryCount = categoryInfo:getSubCategoryListCount()
    for subIdx = 0, subCategoryCount - 1 do
      self._categoryIdxMap[keyIdx] = {
        _isMain = false,
        _index = mainIdx,
        _subIndex = subIdx
      }
      local subTreeElement = treeElement:createChild(toInt64(0, keyIdx))
      keyIdx = keyIdx + 1
    end
  end
  self._ui.list_ItemCategory:getElementManager():refillKeyList()
end
function PaGlobalFunc_ItemMarket_UpdateMyInfo()
  local self = ItemMarket
  local currentWeight = getWorldMarketCurrentWeight()
  local maxWeight = getWorldMarketMaxWeight()
  local silverInfo = getWorldMarketSilverInfo()
  local walletItemCount = getWorldMarketMyWalletListCount()
  local _const = Defines.s64_const
  local s64_allWeight_div = toInt64(0, currentWeight)
  local s64_maxWeight_div = toInt64(0, maxWeight)
  local str_AllWeight = string.format("%.1f", Int64toInt32(s64_allWeight_div) / 10)
  local str_MaxWeight = string.format("%.0f", Int64toInt32(s64_maxWeight_div) / 10)
  self._ui.txt_MarketInvenMoneyValue:SetText(makeDotMoney(silverInfo:getItemCount()))
  self._ui.txt_MarketInvenWeightValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_VOLUME_VT_PARAM_NONCOLOR", "Weight", str_AllWeight .. " / " .. str_MaxWeight))
end
function PaGlobalFunc_ItemMarket_UpdateItemList()
  local self = ItemMarket
  local itemListCount = 0
  local list
  if true == self._isItemListSort then
    self._isItemListSort = false
    PaGlobalFunc_ItemMarket_RegistCountSort()
    return
  end
  self:buttonSetShow()
  if self._itemListType.categoryList == self._currentListType then
    itemListCount = getWorldMarketListCount()
    list = self._ui.list_MarketItemList
  elseif self._itemListType.detailListByKey == self._currentListType then
    itemListCount = getWorldMarketDetailListCount()
    list = self._ui.list_MarketItemList_Sub
  elseif self._itemListType.detailListByCategory == self._currentListType then
    list = self._ui.list_MarketItemList
  elseif self._itemListType.hotListByCategory == self._currentListType then
    itemListCount = getWorldMarketHotListCount()
    list = self._ui.list_MarketItemList_Sub
  end
  if nil == list then
    _PA_ASSERT(false, "\237\131\128\236\158\133\236\151\144 \235\167\158\235\138\148 \235\166\172\236\138\164\237\138\184\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  if itemListCount > 0 then
    list:SetShow(true)
    self._ui.txt_NoSerchResult:SetShow(false)
  else
    list:SetShow(false)
    self._ui.btn_SortRegistItemCount:SetShow(false)
    self._ui.txt_NoSerchResult:SetShow(true)
    self._ui.txt_NoSerchResult:ComputePos()
  end
  list:getElementManager():clearKey()
  for idx = 0, itemListCount - 1 do
    list:getElementManager():pushKey(toInt64(0, idx))
  end
  list:requestUpdateVisible()
end
function ItemMarket:buttonSetShow()
  self._ui.list_MarketItemList:SetShow(false)
  self._ui.list_MarketItemList_Sub:SetShow(false)
  self._ui.stc_SelectedItemBg:SetShow(false)
  self._ui.btn_BackPage:SetShow(false)
  self._ui.btn_SetRegistAlarm:SetShow(false)
  self._ui.btn_SortRegistItemCount:SetShow(false)
  self._ui.checkBtn_SortAcerageTradePrice:SetShow(false)
  if self._itemListType.categoryList == self._currentListType then
    self._ui.btn_SortRegistItemCount:SetShow(true)
  elseif self._itemListType.detailListByKey == self._currentListType then
    self._ui.stc_SelectedItemBg:SetShow(true)
    self._ui.btn_BackPage:SetShow(true)
  elseif self._itemListType.detailListByCategory == self._currentListType then
  elseif self._itemListType.hotListByCategory == self._currentListType then
  end
  if true == self._isSearchItemTemp then
    self._ui.stc_SelectedItemBg:SetShow(false)
  end
  self._ui.btn_BackPage:SetShow(false)
end
function PaGlobalFunc_ItemMarket_isHotCategory()
  local self = ItemMarket
  return __eWorldMarketCategoryType_Hot == self:getCurrentCategoryType()
end
function ItemMarket:getCurrentCategoryType()
  local categoryType = __eWorldMarketCategoryType_Count
  if self._itemListType.categoryList == self._currentListType then
    categoryType = __eWorldMarketCategoryType_Main
  elseif self._itemListType.detailListByKey == self._currentListType then
    categoryType = __eWorldMarketCategoryType_Sub
  elseif self._itemListType.hotListByCategory == self._currentListType then
    categoryType = __eWorldMarketCategoryType_Hot
  end
  return categoryType
end
function FromClient_responseHotListByWorldMarket()
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  self._currentListType = 4
  PaGlobalFunc_ItemMarket_UpdateItemList()
end
function FromClient_ItemMarket_ResponseList()
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  self._currentListType = 1
  PaGlobalFunc_ItemMarket_UpdateItemList()
end
function FromClient_ItemMarket_ResponseDetailListByCategory()
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  self._currentListType = 2
  PaGlobalFunc_ItemMarket_UpdateItemList()
end
function FromClient_ItemMarket_ResponseDetailListByKey()
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  self._currentListType = 3
  PaGlobalFunc_ItemMarket_UpdateItemList()
end
function FromClient_NotifyCompleteWorldMarketSearchList()
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  local list = self._ui.list_search
  if nil == list then
    _PA_ASSERT(false, "\237\131\128\236\158\133\236\151\144 \235\167\158\235\138\148 \235\166\172\236\138\164\237\138\184\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local listSize = ToClient_getSearchWorldMarketItemListSize()
  list:getElementManager():clearKey()
  for idx = 0, listSize - 1 do
    list:getElementManager():pushKey(toInt64(0, idx))
  end
  list:requestUpdateVisible()
end
function InputMLUp_ItemMarket_RequestDetailListByKey(itemKey)
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  self:setSelectSlot(itemKey)
  self._isSelectItem = true
  self._sellInfoItemEnchantKeyRaw = itemKey
  ToClient_requestDetailListByWorldMarketByItemKey(itemKey)
  PaGlobalFunc_ItemMarket_SearchItemListClear()
  ToClient_clearSearchWorldMarketItemKey()
end
function InputMLUp_ItemMarket_RequestBiddingList(idx)
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  local itemInfo
  if self._itemListType.detailListByKey == self._currentListType then
    itemInfo = getWorldMarketDetailListByIdx(idx)
  elseif self._itemListType.hotListByCategory == self._currentListType then
    itemInfo = getWorldMarketHotListByIdx(idx)
  end
  if nil == itemInfo then
    _PA_ASSERT(false, "\236\160\149\235\179\180\234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : getWorldMarketListByIdx( idx )")
    return
  end
  local itemEnchantKey = itemInfo:getEnchantKey()
  ToClient_requestGetBiddingList(itemEnchantKey, true, PaGlobalFunc_ItemMarket_isHotCategory())
  PaGlobalFunc_ItemMarket_SearchItemListClear()
end
function InputMLUp_ItemMarket_SearchItemList(idx)
  local self = ItemMarket
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : ItemMarket")
    return
  end
  local itemKey = ToClient_getSearchWorldMarketItemKey(idx)
  InputMLUp_ItemMarket_RequestDetailListByKey(itemKey)
end
function ItemMarket:itemSubListOpen()
  PaGlobalFunc_ItemMarket_UpdateItemList()
end
function ItemMarket:itemSubListClose()
end
function ItemMarket:itemListOpen()
  PaGlobalFunc_ItemMarket_UpdateItemList()
end
function ItemMarket:itemListClose()
end
function PaGlobalFunc_ItemMarket_OnBuyComplete()
  local self = ItemMarket
  InputMLUp_ItemMarket_RequestDetailListByKey(self._sellInfoItemEnchantKeyRaw)
end
function PaGlobalFunc_ItemMarket_Open()
  local self = ItemMarket
  if false == _panel:GetShow() then
    _PA_ASSERT(false, "\235\169\148\236\157\184 \237\140\168\235\132\144\236\157\180 \236\151\180\235\160\164\236\158\136\236\167\128 \236\149\138\236\157\128\235\141\176 \236\149\132\236\157\180\237\133\156 \235\167\136\236\188\147\236\157\132 \236\151\180\235\160\164\234\179\160 \237\150\136\236\138\181\235\139\136\235\139\164. : \237\140\168\235\132\144 : Panel_Window_MarketPlace_Main")
    return
  end
  ToClient_padSnapResetControl()
  self:open()
end
function PaGlobalFunc_ItemMarket_Close()
  local self = ItemMarket
  if false == _panel:GetShow() then
    _PA_ASSERT(false, "\235\169\148\236\157\184 \237\140\168\235\132\144\236\157\180 \236\151\180\235\160\164\236\158\136\236\167\128 \236\149\138\236\157\128\235\141\176 \236\149\132\236\157\180\237\133\156 \235\167\136\236\188\147\236\157\132 \236\151\180\235\160\164\234\179\160 \237\150\136\236\138\181\235\139\136\235\139\164. : \237\140\168\235\132\144 : Panel_Window_MarketPlace_Main")
    return
  end
  self._ui.txt_NoSerchResult:SetShow(false)
  self:close()
end
function ItemMarket:open()
  self._selectedMainKey = -1
  self._selectedSubKey = -1
  self._currentListType = nil
  _mainBg:SetShow(true)
  self._ui.edit_ItemName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false)
  PaGlobalFunc_ItemMarket_SearchItemListClear()
  PaGlobalFunc_ItemMarket_Update()
  InputMLUp_ItemMarket_SpecialCategoryList(9999)
end
function ItemMarket:close()
  _mainBg:SetShow(false)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_MarketPlace_Init")

local pearlShopCategory = {
  _init = false,
  _panel = Panel_Pearlshop_Category,
  _ui = {
    _mainCategoryGroupControl = nil,
    _mainCategoryControlList = {},
    _mainCategoryControlListSize = getCashMainCategorySize(),
    _subCategoryGroupControl = nil,
    _subCategoryControlList = {},
    _subCategoryControlListSize = 30,
    _bottomControl,
    _selectControl,
    _couponControl,
    _pearlControl = nil,
    stc_bannerArea = UI.getChildControl(Panel_Pearlshop_Category, "Static_BannerArea"),
    stc_selectLines = {}
  },
  _mainCategoryUV = {
    [0] = {
      [true] = {
        x1 = 79,
        y1 = 298,
        x2 = 117,
        y2 = 336
      },
      [false] = {
        x1 = 79,
        y1 = 181,
        x2 = 117,
        y2 = 219
      }
    },
    [1] = {
      [true] = {
        x1 = 196,
        y1 = 298,
        x2 = 234,
        y2 = 336
      },
      [false] = {
        x1 = 196,
        y1 = 181,
        x2 = 234,
        y2 = 219
      }
    },
    [2] = {
      [true] = {
        x1 = 118,
        y1 = 376,
        x2 = 156,
        y2 = 414
      },
      [false] = {
        x1 = 118,
        y1 = 259,
        x2 = 156,
        y2 = 297
      }
    },
    [3] = {
      [true] = {
        x1 = 196,
        y1 = 337,
        x2 = 234,
        y2 = 375
      },
      [false] = {
        x1 = 196,
        y1 = 220,
        x2 = 234,
        y2 = 258
      }
    },
    [4] = {
      [true] = {
        x1 = 157,
        y1 = 376,
        x2 = 195,
        y2 = 414
      },
      [false] = {
        x1 = 157,
        y1 = 259,
        x2 = 195,
        y2 = 297
      }
    },
    [5] = {
      [true] = {
        x1 = 118,
        y1 = 298,
        x2 = 156,
        y2 = 336
      },
      [false] = {
        x1 = 118,
        y1 = 181,
        x2 = 156,
        y2 = 219
      }
    },
    [6] = {
      [true] = {
        x1 = 1,
        y1 = 337,
        x2 = 39,
        y2 = 375
      },
      [false] = {
        x1 = 1,
        y1 = 220,
        x2 = 39,
        y2 = 258
      }
    },
    [7] = {
      [true] = {
        x1 = 40,
        y1 = 337,
        x2 = 78,
        y2 = 375
      },
      [false] = {
        x1 = 40,
        y1 = 220,
        x2 = 78,
        y2 = 258
      }
    },
    [8] = {
      [true] = {
        x1 = 79,
        y1 = 337,
        x2 = 117,
        y2 = 375
      },
      [false] = {
        x1 = 79,
        y1 = 220,
        x2 = 117,
        y2 = 258
      }
    },
    [9] = {
      [true] = {
        x1 = 157,
        y1 = 337,
        x2 = 195,
        y2 = 375
      },
      [false] = {
        x1 = 157,
        y1 = 220,
        x2 = 195,
        y2 = 258
      }
    },
    [10] = {
      [true] = {
        x1 = 118,
        y1 = 337,
        x2 = 156,
        y2 = 375
      },
      [false] = {
        x1 = 118,
        y1 = 220,
        x2 = 156,
        y2 = 258
      }
    }
  },
  _mainCategoryGapY = 10,
  _selectedMainCategoryIndex = -1,
  _selectedSubCategoryIndex = -1,
  _promitionWeb = nil,
  _bannerIsReady = {},
  _keyGuideAlign = {},
  _controlList = {},
  _isDailyStampShow = false
}
local isOn = false
function pearlShopCategory:initMainCategory()
  local group = UI.getChildControl(self._panel, "Static_MainMenuGroup")
  self._ui._mainCategoryGroupControl = group
  self._panel:registerPadEvent(__eConsoleUIPadEvent_LTPress_Y, "PaGlobalFunc_PearlShopDisplayController_ChangeWeather()")
  local template = UI.getChildControl(group, "Static_MainMenu")
  template:SetShow(false)
  local indexList = {}
  local tempControlList = {}
  for i = 0, self._ui._mainCategoryControlListSize - 1 do
    local control = UI.cloneControl(template, group, "Static_MainMenu" .. i)
    local buttonControl = UI.getChildControl(control, "RadioButton_MainMenu_Category")
    local info = ToClient_GetMainCategoryStaticStatusWrapperByKeyRaw(i + 1)
    local title = getCashCategoryName(info:getNoRaw(), CppEnums.CashProductCategoryNo_Undefined)
    tempControlList[i] = control
    buttonControl:ChangeTextureInfoName("renewal/ETC/Console_ETC_CashShop_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(buttonControl, self._mainCategoryUV[i][isOn].x1, self._mainCategoryUV[i][isOn].y1, self._mainCategoryUV[i][isOn].x2, self._mainCategoryUV[i][isOn].y2)
    buttonControl:getBaseTexture():setUV(x1, y1, x2, y2)
    buttonControl:setRenderTexture(buttonControl:getBaseTexture())
    local sortInfo = {}
    sortInfo._index = i
    sortInfo._displayOrder = info:getDisplayOrder()
    buttonControl:addInputEvent("Mouse_LUp", "PaGlobalFunc_PearlShopCategorySelectMainCategory(" .. i .. ")")
    buttonControl:addInputEvent("Mouse_On", "PaGlobalFunc_PearlShopCategoryFocusMainCategory(" .. i .. ")")
    buttonControl:addInputEvent("Mouse_Out", "PaGlobalFunc_PearlShopCategoryFocusOutMainCategory(" .. i .. ")")
    buttonControl:SetText(title)
    if nil ~= sortInfo._displayOrder then
      table.insert(indexList, sortInfo)
    end
  end
  local doSort = function(a, b)
    return a._displayOrder < b._displayOrder
  end
  table.sort(indexList, doSort)
  local uiIndex = 0
  for _, data in pairs(indexList) do
    if nil ~= tempControlList[data._index] then
      self._ui._mainCategoryControlList[uiIndex] = tempControlList[data._index]
      local control = tempControlList[data._index]
      control:SetPosY(template:GetPosY() + (template:GetSizeY() + self._mainCategoryGapY + 5) * uiIndex)
      control:SetShow(true)
      uiIndex = uiIndex + 1
    end
  end
  self._controlList = tempControlList
end
function pearlShopCategory:initSubCategory()
  local group = UI.getChildControl(self._panel, "Static_SubMenuGroup")
  self._ui._subCategoryGroupControl = group
  local template = UI.getChildControl(group, "Static_SubMenu")
  template:SetShow(false)
  for i = 0, self._ui._subCategoryControlListSize - 1 do
    local control = UI.cloneControl(template, group, "Static_SubMenu" .. i)
    self._ui._subCategoryControlList[i] = control
    control:SetPosY(template:GetPosY() + (template:GetSizeY() + 5 + self._mainCategoryGapY) * i)
    local buttonControl = UI.getChildControl(control, "RadioButton_SubMenu_Category")
    local SelectControl = UI.getChildControl(buttonControl, "Static_SelectMarker")
    buttonControl:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_PearlShopCategorySelectSubCategory(" .. i .. ")")
    buttonControl:addInputEvent("Mouse_On", "PaGlobalFunc_PearlShopCategoryFocusSubCategory(" .. i .. ")")
  end
end
function pearlShopCategory:initBannerArea()
  self._ui.stc_bannerBGs = {
    [0] = UI.getChildControl(self._ui.stc_bannerArea, "Static_TopBanner"),
    [1] = UI.getChildControl(self._ui.stc_bannerArea, "Static_BottomLBanner"),
    [2] = UI.getChildControl(self._ui.stc_bannerArea, "Static_BottomRBanner")
  }
  self._ui.web_banners = {}
  for ii = 0, #self._ui.stc_bannerBGs do
    self._ui.web_banners[ii] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, self._ui.stc_bannerBGs[ii], "web_Banner" .. ii)
    self._ui.web_banners[ii]:SetSize(self._ui.stc_bannerBGs[ii]:GetSizeX() - 20, self._ui.stc_bannerBGs[ii]:GetSizeY() - 20)
    self._ui.web_banners[ii]:SetHorizonCenter()
    self._ui.web_banners[ii]:SetVerticalMiddle()
    self._ui.web_banners[ii]:ResetUrl()
    self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_LB, "Input_PearlShopCategory_ToWebBanner(\"LB\", " .. ii .. ")")
    self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_RB, "Input_PearlShopCategory_ToWebBanner(\"RB\", " .. ii .. ")")
    self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "Input_PearlShopCategory_ToWebBanner(\"CLICK\", " .. ii .. ")")
    self._ui.web_banners[ii]:addInputEvent("Mouse_On", "InputMOn_PearlShopCategory_OverBanner(true)")
    self._ui.web_banners[ii]:addInputEvent("Mouse_Out", "InputMOn_PearlShopCategory_OverBanner(false)")
    if true == ToClient_isPS4() then
      self._ui.web_banners[ii]:SetIgnore(true)
      self._ui.stc_bannerBGs[ii]:SetIgnore(true)
      self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_LB, "")
      self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_RB, "")
      self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
      self._ui.web_banners[ii]:addInputEvent("Mouse_On", "")
      self._ui.web_banners[ii]:addInputEvent("Mouse_Out", "")
    end
  end
  self._bannerIsReady = {}
  local keyGuideLB = UI.getChildControl(self._ui.stc_bannerBGs[0], "StaticText_KeyGuideLB")
  local keyGuideRB = UI.getChildControl(self._ui.stc_bannerBGs[0], "StaticText_KeyGuideRB")
  self._ui.stc_bannerBGs[0]:SetChildIndex(keyGuideLB, self._ui.stc_bannerBGs[0]:GetChildSize())
  self._ui.stc_bannerBGs[0]:SetChildIndex(keyGuideRB, self._ui.stc_bannerBGs[0]:GetChildSize())
end
function pearlShopCategory:getPromotionUrl()
  if isGameTypeKorea() then
    return PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL")
  elseif isGameTypeTaiwan() then
    if CppEnums.CountryType.TW_ALPHA == getGameServiceType() then
      return PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TW_ALPHA")
    elseif CppEnums.CountryType.TW_REAL == getGameServiceType() then
      return PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TW")
    end
  elseif isGameTypeKR2() then
    return PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_KR2")
  elseif CppEnums.CountryType.SA_ALPHA == getGameServiceType() then
    return PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_SA_ALPHA", "lang", SALangType)
  elseif CppEnums.CountryType.SA_REAL == getGameServiceType() then
    return PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_SA", "lang", SALangType)
  elseif CppEnums.CountryType.TR_ALPHA == getGameServiceType() then
    return PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TR_ALPHA")
  elseif CppEnums.CountryType.TR_REAL == getGameServiceType() then
    return PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TR")
  elseif CppEnums.CountryType.TH_ALPHA == getGameServiceType() then
    return PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TH_ALPHA")
  elseif CppEnums.CountryType.TH_REAL == getGameServiceType() then
    return PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_TH")
  elseif CppEnums.CountryType.ID_ALPHA == getGameServiceType() then
    return PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_ID_ALPHA")
  elseif CppEnums.CountryType.ID_REAL == getGameServiceType() then
    return PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_ID")
  else
    return PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL")
  end
end
function pearlShopCategory:initialize()
  if self._init then
    return
  end
  self._init = true
  self:initMainCategory()
  self:initSubCategory()
  self:initBannerArea()
  local bottomControl = UI.getChildControl(self._panel, "Static_BottomBg")
  self._ui._bottomControl = bottomControl
  self._ui._selectControl = UI.getChildControl(bottomControl, "StaticText_Select_ConsoleUI")
  self._ui._exitControl = UI.getChildControl(bottomControl, "StaticText_Exit_ConsoleUI")
  self._ui._couponControl = UI.getChildControl(bottomControl, "StaticText_Coupon_ConsoleUI")
  local pearlBgControl = UI.getChildControl(bottomControl, "Static_MoneyType2BG")
  self._ui._pearlControl = UI.getChildControl(pearlBgControl, "StaticText_MoneyType_Price1")
  local loyaltyBgControl = UI.getChildControl(bottomControl, "Static_MoneyType2BG_2")
  self._ui._loyaltyControl = UI.getChildControl(loyaltyBgControl, "StaticText_MoneyType_Price1")
  local bannerControl = UI.getChildControl(self._panel, "Static_RightBannerBg")
  bannerControl:SetShow(false)
  self._keyGuideAlign = {
    self._ui._couponControl,
    self._ui._selectControl,
    self._ui._exitControl
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._bottomControl, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self._panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobal_PearlShopCoupon_Open()")
  registerEvent("FromClient_UpdateCashShop", "PaGlobalFunc_PearlShopCategoryUpdate")
  registerEvent("FromClient_UpdateCash", "PaGlobalFunc_PearlShopCategoryUpdate")
  registerEvent("FromClient_InventoryUpdate", "PaGlobalFunc_PearlShopCategoryUpdate")
  registerEvent("FromClient_WebUIBannerIsReadyForXBOX", "FromClient_WebUIBannerIsReadyforXBOX_PearlCategory")
  registerEvent("FromClient_WebUIBannerEventForXBOX", "FromClient_WebUIBannerEventForXBOX_PearlShopCategory")
end
function PaGlobalFunc_PearlShopCategoryCheckShow()
  return pearlShopCategory:checkShow()
end
function pearlShopCategory:checkShow()
  return self._panel:GetShow()
end
function PaGlobalFunc_PearlShopCategoryBack()
  pearlShopCategory:back()
end
function pearlShopCategory:back()
  if true == Panel_PearlShop_Coupon:GetShow() then
    PaGlobal_PearlShopCoupon_Close()
  else
    self:close()
    InGameShop_Close()
    if nil ~= Panel_Window_DailyStamp_Renew and self._isDailyStampShow then
      self._isDailyStampShow = false
      PaGlobalFunc_DailyStamp_Open()
    end
  end
end
function pearlShopCategory:focusOutMainCategory(index)
  self._controlList[index]:SetEnable(true)
end
function PaGlobalFunc_PearlShopCategoryFocusOutMainCategory(index)
  pearlShopCategory:focusOutMainCategory(index)
end
function PaGlobalFunc_PearlShopCategoryFocusMainCategory(index)
  if pearlShopCategory:focusMainCategory(index) then
    return pearlShopCategory:update()
  end
end
function pearlShopCategory:focusMainCategory(index)
  self._selectedMainCategoryIndex = index
  self._selectedSubCategoryIndex = -1
  if 0 < getCashMiddleCategorySize(index + 1) then
    self._controlList[index]:SetEnable(false)
  end
  return true
end
function PaGlobalFunc_PearlShopCategorySelectMainCategory(index)
  pearlShopCategory:selectMainCategory(index)
end
function pearlShopCategory:selectMainCategory(index)
  if not self:checkValidMainCategory(index) then
    return
  end
  if 0 < getCashMiddleCategorySize(index + 1) then
    self._controlList[index]:SetEnable(false)
    return
  end
  self:gotoNextStep()
end
function pearlShopCategory:checkValidMainCategory(index)
  return index >= 0 and index < getCashMainCategorySize()
end
function PaGlobalFunc_PearlShopCategoryFocusSubCategory(index)
  if pearlShopCategory:focusSubCategory(index) then
    return pearlShopCategory:update()
  end
end
function pearlShopCategory:focusSubCategory(index)
  self._selectedSubCategoryIndex = index
  return true
end
function PaGlobalFunc_PearlShopCategorySelectSubCategory(selectedIndex)
  pearlShopCategory:selectSubCategory(selectedIndex)
end
function pearlShopCategory:checkValidSubCategory(subCategoryIndex)
  if not self:checkValidMainCategory(self._selectedMainCategoryIndex) then
    return false
  end
  local mainCategoryInfo = ToClient_GetMainCategoryStaticStatusWrapperByKeyRaw(self._selectedMainCategoryIndex + 1)
  if not mainCategoryInfo then
    return false
  end
  return subCategoryIndex >= 0 and subCategoryIndex < getCashMiddleCategorySize(mainCategoryInfo:getNoRaw())
end
function pearlShopCategory:selectSubCategory(index)
  if not self:checkValidSubCategory(index) then
    return
  end
  self:gotoNextStep()
end
function pearlShopCategory:gotoNextStep(productNo64)
  if not self:checkValidMainCategory(self._selectedMainCategoryIndex) then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  getIngameCashMall():setCurrentCategory(self._selectedMainCategoryIndex + 1)
  PaGlobalFunc_PearlShop_ClassFilter_Hidden()
  if self:checkValidSubCategory(self._selectedSubCategoryIndex) then
    getIngameCashMall():setCurrentSubTab(self._selectedSubCategoryIndex + 1)
    if CppEnums.CashProductCategory.eCashProductCategory_Costumes == self._selectedMainCategoryIndex + 1 then
      local selfClassType
      if nil ~= productNo64 then
        local CPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(productNo64)
        local itemCount = CPSSW:getInnerItemListCount()
        for itemIdx = 0, itemCount - 1 do
          local itemSSW = CPSSW:getInnerItemByIndex(itemIdx)
          if itemSSW:isEquipable() and 44 ~= itemSSW:getEquipType() then
            local classCount = getCharacterClassCount()
            for classIdx = 0, classCount - 1 do
              local classType = getCharacterClassTypeByIndex(classIdx)
              if true == itemSSW:get()._usableClassType:isOn(classType) then
                selfClassType = classType
                break
              end
            end
          end
        end
      end
      if nil == selfClassType then
        selfClassType = getSelfPlayer():getClassType()
      end
      getIngameCashMall():setCurrentClass(selfClassType)
      PaGlobalFunc_setClassFilter(selfClassType)
      PaGlobalFunc_PearlShop_ClassFilter_Reveal()
    else
    end
  else
    getIngameCashMall():setCurrentSubTab(CppEnums.CashProductCategoryNo_Undefined)
  end
  if ToClient_isConsole() and 0 == self._selectedMainCategoryIndex then
    if true == ToClient_isPS4() then
      return ToClient_openPS4Store()
    else
      return ToClient_XboxShowStore()
    end
  end
  self:showXXX(false)
  PaGlobalFunc_PearlShopOpen(true, productNo64)
end
function pearlShopCategory:getCurrentCategoryTitle()
  if self:checkValidSubCategory(self._selectedSubCategoryIndex) then
    return getCashCategoryName(self._selectedMainCategoryIndex + 1, self._selectedSubCategoryIndex + 1)
  end
  return getCashCategoryName(self._selectedMainCategoryIndex + 1, CppEnums.CashProductCategoryNo_Undefined)
end
function PaGlobalFunc_PearlShopCategoryGetCurrentCategoryTitle()
  return pearlShopCategory:getCurrentCategoryTitle()
end
function pearlShopCategory:updateMainCategory(isOnBanner)
  for i = 0, self._ui._mainCategoryControlListSize - 1 do
    local control = self._ui._mainCategoryControlList[i]
    local buttonControl = UI.getChildControl(control, "RadioButton_MainMenu_Category")
    local isOn = false
    buttonControl:ChangeTextureInfoName("renewal/ETC/Console_ETC_CashShop_00.dds")
    local info = ToClient_GetMainCategoryStaticStatusWrapperByKeyRaw(self._selectedMainCategoryIndex + 1)
    if nil ~= info and i + 1 == info:getDisplayOrder() and not isOnBanner then
      isOn = true
      buttonControl:SetFontColor(4293848814)
    else
      isOn = false
      buttonControl:SetFontColor(4284835174)
    end
    local x1, y1, x2, y2 = setTextureUV_Func(buttonControl, self._mainCategoryUV[i][isOn].x1, self._mainCategoryUV[i][isOn].y1, self._mainCategoryUV[i][isOn].x2, self._mainCategoryUV[i][isOn].y2)
    buttonControl:getBaseTexture():setUV(x1, y1, x2, y2)
    buttonControl:setRenderTexture(buttonControl:getBaseTexture())
  end
end
function pearlShopCategory:updateSubCategory()
  if not self:checkValidMainCategory(self._selectedMainCategoryIndex) then
    return
  end
  local mainInfo = ToClient_GetMainCategoryStaticStatusWrapperByKeyRaw(self._selectedMainCategoryIndex + 1)
  local subCategorySize = getCashMiddleCategorySize(mainInfo:getNoRaw())
  local mainGroup = UI.getChildControl(self._panel, "Static_MainMenuGroup")
  local mainGrupFocusBG = UI.getChildControl(mainGroup, "Static_FocusBG")
  if subCategorySize > 0 then
    self._ui._subCategoryGroupControl:SetShow(true)
    for i = 0, self._ui._subCategoryControlListSize - 1 do
      local control = self._ui._subCategoryControlList[i]
      local showFlag = mainInfo and i < getCashMiddleCategorySize(mainInfo:getNoRaw())
      control:SetShow(showFlag)
      if showFlag then
        local buttonControl = UI.getChildControl(control, "RadioButton_SubMenu_Category")
        local title = getCashCategoryName(mainInfo:getNoRaw(), i + 1)
        if i == self._selectedSubCategoryIndex then
          buttonControl:SetFontColor(4293848814)
        else
          buttonControl:SetFontColor(4284835174)
        end
        buttonControl:SetText(title)
      end
    end
    local maincateroryIndex = mainInfo:getDisplayOrder() - 1
    mainGrupFocusBG:SetPosY(self._ui._mainCategoryControlList[maincateroryIndex]:GetPosY() - 2)
    mainGrupFocusBG:SetShow(true)
  else
    self._ui._subCategoryGroupControl:SetShow(false)
    mainGrupFocusBG:SetShow(false)
  end
end
function pearlShopCategory:checkLeafCategorySelected()
  if self:checkValidMainCategory(self._selectedMainCategoryIndex) then
    local info = ToClient_GetMainCategoryStaticStatusWrapperByKeyRaw(self._selectedMainCategoryIndex + 1)
    if info then
      if getCashMiddleCategorySize(info:getNoRaw()) <= 0 then
        return true
      else
        return self:checkValidSubCategory(self._selectedSubCategoryIndex)
      end
    end
  end
  return false
end
function pearlShopCategory:updateButton()
  self._ui._selectControl:SetShow(self:checkLeafCategorySelected())
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._bottomControl, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function pearlShopCategory:update()
  if not self._init then
    return
  end
  self:updateMainCategory()
  self:updateSubCategory()
  self:updatePearl()
  self:updateButton()
end
function PaGlobalFunc_PearlShopCategoryUpdate()
  return pearlShopCategory:update()
end
function pearlShopCategory:updatePearl()
  local pearl = toInt64(0, 0)
  local pearlItem = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, getPearlSlotNo())
  if pearlItem then
    pearl = pearlItem:get():getCount_s64()
  end
  self._ui._pearlControl:SetText(makeDotMoney(pearl))
  local mileage = toInt64(0, 0)
  local mileageItem = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, getMileageSlotNo())
  if mileageItem then
    mileage = mileageItem:get():getCount_s64()
  end
  self._ui._loyaltyControl:SetText(makeDotMoney(mileage))
end
function pearlShopCategory:showXXX(flag)
  self._ui._mainCategoryGroupControl:SetShow(flag)
  self._ui._subCategoryGroupControl:SetShow(flag)
  self._ui._bottomControl:SetShow(flag)
  self._ui.stc_bannerArea:SetShow(flag)
end
function pearlShopCategory:open(initIndexFlag)
  self:showXXX(true)
  if false == self:checkShow() then
    self._selectedMainCategoryIndex = 0
    self._selectedSubCategoryIndex = -1
    local mainGroup = UI.getChildControl(self._panel, "Static_MainMenuGroup")
    local mainGrupFocusBG = UI.getChildControl(mainGroup, "Static_FocusBG")
    mainGrupFocusBG:SetShow(false)
    self._ui._subCategoryGroupControl:SetShow(false)
  end
  getIngameCashMall():clearEquipViewList()
  getIngameCashMall():changeViewMyCharacter()
  getIngameCashMall():hide()
  getIngameCashMall():show()
  if not self:checkShow() then
    self._panel:SetShow(true)
  end
  local mainGroup = UI.getChildControl(self._panel, "Static_MainMenuGroup")
  local subGroup = UI.getChildControl(self._panel, "Static_SubMenuGroup")
  if true == _ContentsGroup_Console_WebBanner then
    local domainURL = ""
    if nil ~= ToClient_getXBoxBannerURL then
      domainURL = ToClient_getXBoxBannerURL()
    end
    if nil == domainURL or "" == domainURL then
      domainURL = "https://dev-game-portal.xbox.playblackdesert.com/Banner?bannerType="
    else
      domainURL = "https://" .. domainURL .. "/Banner?bannerType="
    end
    domainURL = domainURL .. "1&bannerPosition="
    PaGlobalFunc_PearlShopOpen(false)
    if true == initIndexFlag then
      for ii = 0, #self._ui.web_banners do
        self._ui.web_banners[ii]:ResetUrl()
        self._ui.web_banners[ii]:SetUrl(self._ui.web_banners[ii]:GetSizeX(), self._ui.web_banners[ii]:GetSizeY(), domainURL .. tostring(ii), false, true)
      end
      self._bannerIsReady = {}
    end
    self._ui.stc_bannerArea:SetShow(true)
    mainGroup:SetPosY(460)
    subGroup:SetPosY(460)
  else
    self._ui.stc_bannerArea:SetShow(false)
    mainGroup:SetPosY(50)
    subGroup:SetPosY(50)
  end
end
function PaGlobalFunc_PearlShopCategoryOpen(initIndexFlag)
  pearlShopCategory:update()
  pearlShopCategory:open(initIndexFlag)
end
function pearlShopCategory:close()
  getIngameCashMall():setCurrentCategory(0)
  getIngameCashMall():setCurrentSubTab(CppEnums.CashProductCategoryNo_Undefined)
  self._ui._subCategoryGroupControl:SetShow(false)
  PaGlobalFunc_ConsoleKeyGuide_PopGuide()
  self._panel:SetShow(false)
end
function PaGlobalFunc_PearlShopCategoryClose()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  pearlShopCategory:close()
  for ii = 0, #pearlShopCategory._ui.web_banners do
    pearlShopCategory._ui.web_banners[ii]:ResetUrl()
  end
  pearlShopCategory._bannerIsReady = {}
end
function pearlShopCategory:changePlatformSpecKey()
end
function Input_PearlShopCategory_ToWebBanner(key, bannerIndex)
  local self = pearlShopCategory
  if "CLICK" == key and not self._bannerIsReady[bannerIndex] then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WEBCONTROL_PAGE_NOT_READY"))
    return
  end
  self._ui.web_banners[bannerIndex]:TriggerEvent("FromClient_GamePadInputForWebBanner", key)
end
function FromClient_WebUIBannerIsReadyforXBOX_PearlCategory(bannerType, bannerPos)
  local self = pearlShopCategory
  if 1 == bannerType then
    self._bannerIsReady[bannerPos] = true
  end
end
function FromClient_WebUIBannerEventForXBOX_PearlShopCategory(linkType, link)
  local self = pearlShopCategory
  if false == Panel_Pearlshop_Category:GetShow() then
    return
  end
  if Defines.ConsoleBannerLinkType.InGameWeb == linkType then
    PaGlobalFunc_WebControl_Open(link)
  elseif Defines.ConsoleBannerLinkType.PearlShopItem == linkType then
    self:requestProductByProductNo(tonumber(link))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WEBCONTROL_PAGE_NOT_READY"))
  end
end
function pearlShopCategory:requestProductByProductNo(productNo64)
  local cashProductWrapper = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNo64)
  if nil ~= cashProductWrapper then
    local isAdultPeople = ToClient_isAdultUser()
    local isAdultProduct = cashProductWrapper:isAdultProduct()
    if not isAdultPeople and isAdultProduct then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TEENWORLD_DONTBUY"))
      return
    else
      self._selectedMainCategoryIndex = cashProductWrapper:getMainCategory() - 1
      self._selectedSubCategoryIndex = cashProductWrapper:getMiddleCategory() - 1
      self:gotoNextStep(productNo64)
    end
  end
end
function InputMOn_PearlShopCategory_OverBanner(isOn)
  local self = pearlShopCategory
  if isOn then
    self:updateMainCategory(isOn)
  else
    self:updateMainCategory()
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._bottomControl, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function FromClient_PearlShopCategoryInit()
  pearlShopCategory:initialize()
  ToClient_setPearlShopUIPanel_XX(Panel_Pearlshop_Category)
end
function PaGlobalFunc_PearlShopCategory_CheckDailyStampOpened(flag)
  pearlShopCategory._isDailyStampShow = flag
end
registerEvent("FromClient_luaLoadComplete", "FromClient_PearlShopCategoryInit")

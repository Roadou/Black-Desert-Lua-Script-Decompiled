Panel_PearlShop_DisplayController:SetShow(false)
local pearlShopDisplayController = {
  _ui = {
    stc_petMenuBG = UI.getChildControl(Panel_PearlShop_DisplayController, "Static_PetMenuBG"),
    stc_petMenuDesc = nil,
    stc_outfitMenuBG = UI.getChildControl(Panel_PearlShop_DisplayController, "Static_OutfitMenuBG"),
    stc_outfitBtnList = {},
    stc_outfitBtnToggleEffect = {},
    stc_outfitBtnOnEffect = nil
  },
  OUTFIT_BUTTON_TYPE = {
    RESET_OUTFIT = 1,
    UNDERWEAR = 2,
    HIDE_OUTFIT = 3,
    TIED_HAIR = 4,
    HIDE_HELMET = 5,
    CLOSE_HELMET = 6,
    SHOW_CLOAK = 7,
    POSE_BATTLE = 8,
    IS_AWAKEN = 9
  },
  _outfitBtnCnt = 9,
  _outfitBtnFuncList = {},
  _outfitBtnDescList = {},
  _outfitBtnIsOnList = {},
  _isOutfitLBDown = false,
  _curOutfitBtnIndex = 1,
  _outfitDurability = 100,
  _categoryNo_Pet = 7,
  _subCategoryNo_Pet = 1,
  _categoryNo_Outfit = 4,
  _curMainCategory = -1,
  _curMiddleCategory = -1,
  _productNoRaw = -1,
  _subProductNoRaw = -1,
  _beforSetClass = -1,
  _nowSetClass = -1,
  _curWeatherIndex = 1,
  _weatherTypeCount = 6,
  _isAvatarProduct = false,
  _panel = Panel_PearlShop_DisplayController
}
function pearlShopDisplayController:initControl()
  self._ui.stc_outfitBtnBG = UI.getChildControl(self._ui.stc_outfitMenuBG, "Static_UtilityBtnBG")
  local btnType = self.OUTFIT_BUTTON_TYPE
  self._ui.stc_outfitBtnList[btnType.RESET_OUTFIT] = UI.getChildControl(self._ui.stc_outfitBtnBG, "Static_Button_RESET_OUTFIT")
  self._ui.stc_outfitBtnList[btnType.UNDERWEAR] = UI.getChildControl(self._ui.stc_outfitBtnBG, "Static_Button_UNDERWEAR")
  self._ui.stc_outfitBtnList[btnType.HIDE_OUTFIT] = UI.getChildControl(self._ui.stc_outfitBtnBG, "Static_Button_HIDE_OUTFIT")
  self._ui.stc_outfitBtnList[btnType.TIED_HAIR] = UI.getChildControl(self._ui.stc_outfitBtnBG, "Static_Button_TIED_HAIR")
  self._ui.stc_outfitBtnList[btnType.HIDE_HELMET] = UI.getChildControl(self._ui.stc_outfitBtnBG, "Static_Button_HIDE_HELMET")
  self._ui.stc_outfitBtnList[btnType.CLOSE_HELMET] = UI.getChildControl(self._ui.stc_outfitBtnBG, "Static_Button_CLOSE_HELMET")
  self._ui.stc_outfitBtnList[btnType.SHOW_CLOAK] = UI.getChildControl(self._ui.stc_outfitBtnBG, "Static_Button_SHOW_CLOAK")
  self._ui.stc_outfitBtnList[btnType.POSE_BATTLE] = UI.getChildControl(self._ui.stc_outfitBtnBG, "Static_Button_POSE_BATTLE")
  self._ui.stc_outfitBtnList[btnType.IS_AWAKEN] = UI.getChildControl(self._ui.stc_outfitBtnBG, "Static_Button_IS_AWAKEN")
  self._ui.stc_outfitBtnOnEffect = UI.getChildControl(self._ui.stc_outfitBtnBG, "Static_BtnOnEffect")
  for index = 1, self._outfitBtnCnt do
    self._ui.stc_outfitBtnToggleEffect[index] = UI.getChildControl(self._ui.stc_outfitBtnList[index], "Static_ToggleEffect")
  end
  self._ui.stc_outfitBtnA = UI.getChildControl(self._ui.stc_outfitBtnBG, "Static_ButtonConfirm")
  self._ui.txt_outfitBtnDesc = UI.getChildControl(self._ui.stc_outfitBtnBG, "StaticText_ButtonDesc")
  self._ui.stc_outfitSliderBG = UI.getChildControl(self._ui.stc_outfitMenuBG, "Static_DurabilityBG")
  self._ui.slider_outfitDurability = UI.getChildControl(self._ui.stc_outfitSliderBG, "Slider_Durability")
  self._ui.progress_outfitDurability = UI.getChildControl(self._ui.slider_outfitDurability, "Progress2_1")
  self._ui.slider_outfitBtn = UI.getChildControl(self._ui.slider_outfitDurability, "Slider_DisplayButton")
  self._ui.stc_petLookDesc = UI.getChildControl(self._ui.stc_petMenuBG, "StaticText_PetLookChange")
  self._ui.stc_petLookDescSub = UI.getChildControl(self._ui.stc_petMenuBG, "StaticText_PetLookChange_Sub")
  self._ui.stc_petLB = UI.getChildControl(self._ui.stc_petMenuBG, "Static_LB")
  self._ui.stc_petRB = UI.getChildControl(self._ui.stc_petMenuBG, "Static_RB")
  self._ui.stc_petLookDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND"))
  self._ui.stc_petLookDescSub:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND_DEFAULT_OPTION"))
end
function pearlShopDisplayController:registEventHandler()
  registerEvent("onScreenResize", "FromClient_PearlShopDisplayController_OnScreenResize")
  registerEvent("FromClient_ChangeAwakenWeapon", "FromClient_PearlShopDisplayController_ChangeAwakenWeapon")
end
function pearlShopDisplayController:initialize()
  self._outfitBtnFuncList = {
    [self.OUTFIT_BUTTON_TYPE.RESET_OUTFIT] = {btnToggleFunc = PaGlobalFunc_PearlShopDisplayController_ToggleRESET_OUTFIT},
    [self.OUTFIT_BUTTON_TYPE.UNDERWEAR] = {btnToggleFunc = PaGlobalFunc_PearlShopDisplayController_ToggleUNDERWEAR},
    [self.OUTFIT_BUTTON_TYPE.HIDE_OUTFIT] = {btnToggleFunc = PaGlobalFunc_PearlShopDisplayController_ToggleHIDE_OUTFIT},
    [self.OUTFIT_BUTTON_TYPE.TIED_HAIR] = {btnToggleFunc = PaGlobalFunc_PearlShopDisplayController_ToggleTIED_HAIR},
    [self.OUTFIT_BUTTON_TYPE.HIDE_HELMET] = {btnToggleFunc = PaGlobalFunc_PearlShopDisplayController_ToggleHIDE_HELMET},
    [self.OUTFIT_BUTTON_TYPE.CLOSE_HELMET] = {btnToggleFunc = PaGlobalFunc_PearlShopDisplayController_ToggleCLOSE_HELMET},
    [self.OUTFIT_BUTTON_TYPE.SHOW_CLOAK] = {btnToggleFunc = PaGlobalFunc_PearlShopDisplayController_ToggleSHOW_CLOAK},
    [self.OUTFIT_BUTTON_TYPE.POSE_BATTLE] = {btnToggleFunc = PaGlobalFunc_PearlShopDisplayController_TogglePOSE_BATTLE},
    [self.OUTFIT_BUTTON_TYPE.IS_AWAKEN] = {btnToggleFunc = PaGlobalFunc_PearlShopDisplayController_ToggleIS_AWAKEN}
  }
  self._outfitBtnDescList = {
    [self.OUTFIT_BUTTON_TYPE.RESET_OUTFIT] = {
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_ALLDOFF")
    },
    [self.OUTFIT_BUTTON_TYPE.UNDERWEAR] = {
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SHOWUNDERWEAR")
    },
    [self.OUTFIT_BUTTON_TYPE.HIDE_OUTFIT] = {
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HIDEAVATAR")
    },
    [self.OUTFIT_BUTTON_TYPE.TIED_HAIR] = {
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HIDHAIR")
    },
    [self.OUTFIT_BUTTON_TYPE.HIDE_HELMET] = {
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HIDEHELM")
    },
    [self.OUTFIT_BUTTON_TYPE.CLOSE_HELMET] = {
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_OPENHELM")
    },
    [self.OUTFIT_BUTTON_TYPE.SHOW_CLOAK] = {
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIP_CLOAK_NAME")
    },
    [self.OUTFIT_BUTTON_TYPE.POSE_BATTLE] = {
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_TOOLTIP_WARSTANCE")
    },
    [self.OUTFIT_BUTTON_TYPE.IS_AWAKEN] = {
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_AWAKENWEAPON")
    }
  }
  self:initControl()
  self:registEventHandler()
  self:onScreenResize()
  for index = 1, self._outfitBtnCnt do
    self._outfitBtnIsOnList[index] = false
  end
end
function PaGlobalFunc_PearlShopDisplayController_ToggleRESET_OUTFIT()
  local self = pearlShopDisplayController
  self._beforSetClass = -2
  getIngameCashMall():clearEquipViewList()
  PaGlobalFunc_PearlShopDisplayController_ResetOutfitDurability()
end
function PaGlobalFunc_PearlShopDisplayController_ToggleUNDERWEAR(isShow)
  local self = pearlShopDisplayController
  if nil == isShow then
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.UNDERWEAR] = not self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.UNDERWEAR]
  else
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.UNDERWEAR] = isShow
  end
  if true == self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.HIDE_OUTFIT] and true == self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.UNDERWEAR] then
    PaGlobalFunc_PearlShopDisplayController_ToggleHIDE_OUTFIT(false)
  end
  PaGlobalFunc_PearlShopDisplayController_ResetOutfitDurability()
  getIngameCashMall():setIsShowUnderwear(self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.UNDERWEAR])
end
function PaGlobalFunc_PearlShopDisplayController_ToggleHIDE_OUTFIT(isShow)
  local self = pearlShopDisplayController
  if nil == isShow then
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.HIDE_OUTFIT] = not self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.HIDE_OUTFIT]
  else
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.HIDE_OUTFIT] = isShow
  end
  if true == self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.HIDE_OUTFIT] and true == self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.UNDERWEAR] then
    PaGlobalFunc_PearlShopDisplayController_ToggleUNDERWEAR(false)
  end
  getIngameCashMall():setIsShowWithoutAvatar(self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.HIDE_OUTFIT])
end
function PaGlobalFunc_PearlShopDisplayController_ToggleTIED_HAIR(isShow)
  local self = pearlShopDisplayController
  if nil == isShow then
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.TIED_HAIR] = not self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.TIED_HAIR]
    getIngameCashMall():setFaceVisibleHair(self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.TIED_HAIR])
  else
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.TIED_HAIR] = isShow
    getIngameCashMall():setFaceVisibleHair(isShow)
  end
end
function PaGlobalFunc_PearlShopDisplayController_ToggleHIDE_HELMET(isShow)
  local self = pearlShopDisplayController
  if nil == isShow then
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.HIDE_HELMET] = not self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.HIDE_HELMET]
    getIngameCashMall():setIsShowWithoutHelmet(self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.HIDE_HELMET])
  else
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.HIDE_HELMET] = isShow
    getIngameCashMall():setIsShowWithoutHelmet(isShow)
  end
end
function PaGlobalFunc_PearlShopDisplayController_ToggleCLOSE_HELMET(isShow)
  local self = pearlShopDisplayController
  if nil == isShow then
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.CLOSE_HELMET] = not self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.CLOSE_HELMET]
    getIngameCashMall():setIsShowBattleHelmet(self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.CLOSE_HELMET])
  else
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.CLOSE_HELMET] = isShow
    getIngameCashMall():setIsShowBattleHelmet(isShow)
  end
end
function PaGlobalFunc_PearlShopDisplayController_ToggleSHOW_CLOAK(isShow)
  local self = pearlShopDisplayController
  if nil == isShow then
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.SHOW_CLOAK] = not self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.SHOW_CLOAK]
    getIngameCashMall():setIsShowCloak(self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.SHOW_CLOAK])
  else
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.SHOW_CLOAK] = isShow
    getIngameCashMall():setIsShowCloak(isShow)
  end
end
function PaGlobalFunc_PearlShopDisplayController_ToggleIS_AWAKEN(isShow)
  local self = pearlShopDisplayController
  if nil == isShow then
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.IS_AWAKEN] = not self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.IS_AWAKEN]
    getIngameCashMall():setAwakenWeaponView(self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.IS_AWAKEN])
  else
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.IS_AWAKEN] = isShow
    getIngameCashMall():setAwakenWeaponView(isShow)
  end
end
function PaGlobalFunc_PearlShopDisplayController_TogglePOSE_BATTLE(isShow)
  local self = pearlShopDisplayController
  if nil == isShow then
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.POSE_BATTLE] = not self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.POSE_BATTLE]
    getIngameCashMall():setBattleView(self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.POSE_BATTLE])
  else
    self._outfitBtnIsOnList[self.OUTFIT_BUTTON_TYPE.POSE_BATTLE] = isShow
    getIngameCashMall():setBattleView(isShow)
  end
end
function pearlShopDisplayController:isUnderWearItem(productNoRaw)
  local CPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(productNoRaw)
  local count = CPSSW:getInnerItemListCount()
  for key = 0, count - 1 do
    local itemSSW = CPSSW:getInnerItemByIndex(key)
    local itemType = itemSSW:getEquipSlotNo()
    if CppEnums.EquipSlotNo.avatarUnderWear == itemType then
      return true
    end
  end
  return false
end
function pearlShopDisplayController:isAccessaryItem(productNoRaw)
  local CPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(productNoRaw)
  local count = CPSSW:getInnerItemListCount()
  for key = 0, count - 1 do
    local itemSSW = CPSSW:getInnerItemByIndex(key)
    local itemType = itemSSW:getEquipSlotNo()
    if CppEnums.EquipSlotNo.faceDecoration1 == itemType or CppEnums.EquipSlotNo.faceDecoration2 == itemType or CppEnums.EquipSlotNo.faceDecoration3 == itemType then
      return true
    end
  end
  return false
end
function PaGlobalFunc_PearlShopDisplayController_ExcuteOutfitFunction()
  local self = pearlShopDisplayController
  local excuteFunc
  excuteFunc = self._outfitBtnFuncList[self._curOutfitBtnIndex].btnToggleFunc
  if nil ~= excuteFunc and "function" == type(excuteFunc) then
    excuteFunc()
  end
  for index = 1, self._outfitBtnCnt do
    self._ui.stc_outfitBtnToggleEffect[index]:SetShow(self._outfitBtnIsOnList[index])
  end
end
function PaGlobalFunc_PearlShopDisplayController_ChangeOutfitButtonIndex(addIndex)
  local self = pearlShopDisplayController
  if self._curOutfitBtnIndex + addIndex > self._outfitBtnCnt then
    self._curOutfitBtnIndex = 1
  elseif self._curOutfitBtnIndex + addIndex < 1 then
    self._curOutfitBtnIndex = self._outfitBtnCnt
  else
    self._curOutfitBtnIndex = self._curOutfitBtnIndex + addIndex
  end
  self._ui.txt_outfitBtnDesc:SetText(self._outfitBtnDescList[self._curOutfitBtnIndex].desc)
  self._ui.stc_outfitBtnOnEffect:SetPosX(self._ui.stc_outfitBtnList[self._curOutfitBtnIndex]:GetPosX())
end
function PaGlobalFunc_PearlShopDisplayController_GetOutfitLBDown()
  local self = pearlShopDisplayController
  return self._isOutfitLBDown
end
function PaGlobalFunc_PearlShopDisplayController_LBInput(isDown)
  local self = pearlShopDisplayController
  if true == isDown then
    PaGlobalFunc_PearlShopDisplayController_InputPetLookChange(false)
  end
  if false == self._ui.stc_outfitMenuBG:GetShow() then
    return
  end
  self._isOutfitLBDown = isDown
  self._isPetLBDown = false
  self._ui.slider_outfitDurability:ChangeTextureInfoNameAsync("renewal/function/console_function_00.dds")
  self._ui.progress_outfitDurability:ChangeTextureInfoNameAsync("renewal/function/console_function_00.dds")
  self._ui.slider_outfitBtn:ChangeTextureInfoNameAsync("renewal/function/console_function_00.dds")
  PaGlobalFunc_PearlShopEnableKeyGuide(not self._isOutfitLBDown)
  if true == self._isOutfitLBDown then
    self._curOutfitBtnIndex = 1
    self._ui.stc_outfitBtnA:SetShow(true)
    self._ui.stc_outfitBtnOnEffect:SetShow(true)
    self._ui.stc_outfitBtnOnEffect:SetPosX(self._ui.stc_outfitBtnList[self._curOutfitBtnIndex]:GetPosX())
    self._ui.txt_outfitBtnDesc:SetShow(true)
    self._ui.txt_outfitBtnDesc:SetText(self._outfitBtnDescList[self._curOutfitBtnIndex].desc)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.slider_outfitDurability, 269, 80, 292, 94)
    self._ui.slider_outfitDurability:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.slider_outfitDurability:setRenderTexture(self._ui.slider_outfitDurability:getBaseTexture())
    x1, y1, x2, y2 = setTextureUV_Func(self._ui.progress_outfitDurability, 317, 80, 340, 94)
    self._ui.progress_outfitDurability:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.progress_outfitDurability:setRenderTexture(self._ui.progress_outfitDurability:getBaseTexture())
    x1, y1, x2, y2 = setTextureUV_Func(self._ui.slider_outfitBtn, 117, 158, 137, 178)
    self._ui.slider_outfitBtn:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.slider_outfitBtn:setRenderTexture(self._ui.slider_outfitBtn:getBaseTexture())
  else
    self._ui.stc_outfitBtnA:SetShow(false)
    self._ui.stc_outfitBtnOnEffect:SetShow(false)
    self._ui.txt_outfitBtnDesc:SetShow(false)
    self._panel:registerPadEvent(__eConsoleUIPadEvent_A, "")
    self._panel:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "")
    self._panel:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.slider_outfitDurability, 245, 80, 268, 94)
    self._ui.slider_outfitDurability:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.slider_outfitDurability:setRenderTexture(self._ui.slider_outfitDurability:getBaseTexture())
    x1, y1, x2, y2 = setTextureUV_Func(self._ui.progress_outfitDurability, 293, 80, 316, 94)
    self._ui.progress_outfitDurability:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.progress_outfitDurability:setRenderTexture(self._ui.progress_outfitDurability:getBaseTexture())
    x1, y1, x2, y2 = setTextureUV_Func(self._ui.slider_outfitBtn, 95, 154, 115, 174)
    self._ui.slider_outfitBtn:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.slider_outfitBtn:setRenderTexture(self._ui.slider_outfitBtn:getBaseTexture())
  end
end
function PaGlobalFunc_PearlShopDisplayController_OutfitDurabilityControl(value)
  local self = pearlShopDisplayController
  if false == self._ui.stc_outfitMenuBG:GetShow() then
    return
  end
  if self._outfitDurability + value < 0 then
    self._outfitDurability = 0
  elseif self._outfitDurability + value > 100 then
    self._outfitDurability = 100
  else
    self._outfitDurability = self._outfitDurability + value
  end
  self:updateOutfitDurability()
end
function PaGlobalFunc_PearlShopDisplayController_ResetOutfitDurability()
  local self = pearlShopDisplayController
  self._outfitDurability = 100
  self:updateOutfitDurability()
end
function pearlShopDisplayController:updateOutfitDurability()
  self._ui.progress_outfitDurability:SetProgressRate(self._outfitDurability)
  local sliderBtnPosX = self._ui.progress_outfitDurability:GetPosX() + self._ui.progress_outfitDurability:GetSizeX() * (self._outfitDurability / 100)
  self._ui.slider_outfitBtn:SetPosX(sliderBtnPosX - 12)
  getIngameCashMall():setEquipmentEndurancePercents(self._outfitDurability / 100)
end
function PaGlobalFunc_PearlShopDisplayController_InputPetLookChange(isToNext)
  local self = pearlShopDisplayController
  if self._categoryNo_Pet ~= self._curMainCategory or self._subCategoryNo_Pet ~= self._curMiddleCategory then
    return
  end
  self._isOutfitLBDown = false
  local cashMallInfo = getIngameCashMall()
  if true == isToNext then
    if cashMallInfo:IsEndOfTierPet() then
      return
    else
      cashMallInfo:changeViewNextTierPet()
    end
  elseif cashMallInfo:IsStartOfTierPet() then
    return
  else
    cashMallInfo:changeViewPrevTierPet()
  end
  if cashMallInfo:IsStartOfTierPet() then
    self._ui.stc_petLB:SetShow(false)
    self._ui.stc_petLookDescSub:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND_DEFAULT_OPTION"))
  else
    self._ui.stc_petLB:SetShow(true)
    self._ui.stc_petLookDescSub:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND_OPTION"))
  end
  if cashMallInfo:IsEndOfTierPet() then
    self._ui.stc_petRB:SetShow(false)
  else
    self._ui.stc_petRB:SetShow(true)
  end
end
function PaGlobalFunc_PearlShopDisplayController_ResetWeather()
  local self = pearlShopDisplayController
  local nowTime = getIngameCashMall():getWeatherTime()
  getIngameCashMall():setWeatherTime(6, nowTime)
  self._curWeatherIndex = 1
end
function PaGlobalFunc_PearlShopDisplayController_ChangeWeather()
  local self = pearlShopDisplayController
  self._curWeatherIndex = self._curWeatherIndex + 1
  if self._curWeatherIndex > self._weatherTypeCount then
    self._curWeatherIndex = 1
  end
  local weatherTime
  if 1 == self._curWeatherIndex then
    weatherTime = 0
  elseif 2 == self._curWeatherIndex then
    weatherTime = 3
  elseif 3 == self._curWeatherIndex then
    weatherTime = 7
  elseif 4 == self._curWeatherIndex then
    weatherTime = 11
  elseif 5 == self._curWeatherIndex then
    weatherTime = 15
  elseif 6 == self._curWeatherIndex then
    weatherTime = 19
  end
  if nil ~= weatherTime then
    getIngameCashMall():setWeatherTime(6, weatherTime)
  end
end
function pearlShopDisplayController:setCharacterEquip()
  local CPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(self._productNoRaw)
  if nil == CPSSW then
    return
  end
  if CPSSW:isShowWindowItemKey() then
    self._nowSetClass = -1
    self._beforSetClass = -2
    getIngameCashMall():changeViewCharacter(self._productNoRaw)
    return
  end
  local itemCount = CPSSW:getInnerItemListCount()
  local checkClass = -1
  local itemType
  local hasEquipment = false
  local hasUsableServant = false
  local myClass = getSelfPlayer():getClassType()
  local servantType = -1
  self._isAvatarProduct = false
  local listClass = {}
  for classIdx = 0, getCharacterClassCount() - 1 do
    local classType = getCharacterClassTypeByIndex(classIdx)
    listClass[classType] = true
  end
  for itemIdx = 0, itemCount - 1 do
    local itemSSW = CPSSW:getInnerItemByIndex(itemIdx)
    if itemSSW:isUsableServant() then
      hasUsableServant = true
      if itemSSW:get():isServantTypeUsable(CppEnums.ServantKind.Type_Ship) or itemSSW:get():isServantTypeUsable(CppEnums.ServantKind.Type_Raft) then
        servantType = CppEnums.ServantKind.Type_Ship
      elseif itemSSW:get():isServantTypeUsable(CppEnums.ServantKind.Type_TwoWheelCarriage) or itemSSW:get():isServantTypeUsable(CppEnums.ServantKind.Type_FourWheeledCarriage) then
        servantType = CppEnums.ServantKind.Type_FourWheeledCarriage
      elseif itemSSW:get():isServantTypeUsable(CppEnums.ServantKind.Type_Horse) then
        servantType = CppEnums.ServantKind.Type_Horse
      elseif itemSSW:get():isServantTypeUsable(CppEnums.ServantKind.Type_FishingBoat) then
        servantType = CppEnums.ServantKind.Type_FishingBoat
      elseif itemSSW:get():isServantTypeUsable(CppEnums.ServantKind.Type_Camel) then
        servantType = CppEnums.ServantKind.Type_Camel
      elseif itemSSW:get():isServantTypeUsable(CppEnums.ServantKind.Type_Donkey) then
        servantType = CppEnums.ServantKind.Type_Donkey
      end
    elseif itemSSW:isEquipable() then
      if 44 == itemSSW:getEquipType() then
        hasEquipment = false
      else
        hasEquipment = true
      end
      for classType, _ in pairs(listClass) do
        if false == itemSSW:get()._usableClassType:isOn(classType) then
          listClass[classType] = nil
        end
      end
    end
  end
  if true == listClass[myClass] then
    checkClass = myClass
  else
    for key, _ in pairs(listClass) do
      checkClass = key
      break
    end
  end
  PaGlobalFunc_PearlShopDisplayController_ToggleUNDERWEAR(false)
  if true == hasEquipment and false == hasUsableServant then
    self._nowSetClass = checkClass
    if self._beforSetClass ~= self._nowSetClass then
      self._beforSetClass = self._nowSetClass
      local cartProductKeyList = Array.new()
      local cartListCount = getIngameCashMall():getViewListCount()
      for equipItem_Idx = 0, cartListCount - 1 do
        local iGCSelectedItem = getIngameCashMall():getViewItemByIndex(equipItem_Idx)
        local CPSSW = iGCSelectedItem:getCashProductStaticStatus()
        cartProductKeyList:push_back(CPSSW:getNoRaw())
      end
      for key, noRaw in pairs(cartProductKeyList) do
        local CPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(noRaw)
        local itemCount = CPSSW:getInnerItemListCount()
        for itemIdx = 0, itemCount - 1 do
          local itemSSW = CPSSW:getInnerItemByIndex(itemIdx)
          if itemSSW:isEquipable() and false == itemSSW:get()._usableClassType:isOn(self._nowSetClass) then
            getIngameCashMall():popProductInEquipCart(noRaw)
            break
          end
        end
      end
      if myClass == self._nowSetClass then
        getIngameCashMall():changeViewMyCharacter()
      else
        local characterSSW = getCharacterStaticStatusWrapperByClassType(self._nowSetClass)
        local characterKeyRaw = characterSSW:getCharacterKey()
        getIngameCashMall():changeViewPlayerCharacter(characterKeyRaw)
      end
    end
    if self:isUnderWearItem(self._productNoRaw) then
      PaGlobalFunc_PearlShopDisplayController_ToggleUNDERWEAR(true)
    end
    if self:isAccessaryItem(self._productNoRaw) then
    end
    getIngameCashMall():pushProductInEquipCart(self._productNoRaw)
    self._isAvatarProduct = true
  elseif true == hasUsableServant then
    if -1 == servantType then
      return
    end
    local cartProductKeyList = Array.new()
    local cartListCount = getIngameCashMall():getViewListCount()
    for equipItem_Idx = 0, cartListCount - 1 do
      local iGCSelectedItem = getIngameCashMall():getViewItemByIndex(equipItem_Idx)
      local CPSSW = iGCSelectedItem:getCashProductStaticStatus()
      cartProductKeyList:push_back(CPSSW:getNoRaw())
    end
    for key, noRaw in pairs(cartProductKeyList) do
      local CPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(noRaw)
      local itemCount = CPSSW:getInnerItemListCount()
      for itemIdx = 0, itemCount - 1 do
        local itemSSW = CPSSW:getInnerItemByIndex(itemIdx)
        if itemSSW:isEquipable() and false == itemSSW:get()._usableClassType:isOn(servantType) then
          getIngameCashMall():popProductInEquipCart(noRaw)
          break
        end
      end
    end
    local characterKeyRaw = getIngameCashMall():getDelegateServantKey(servantType)
    getIngameCashMall():clearEquipViewList()
    getIngameCashMall():changeViewVehicleCharacter(characterKeyRaw)
    getIngameCashMall():pushProductInEquipCart(self._productNoRaw)
    self._beforSetClass = -2
    self._nowSetClass = -1
  else
    self._beforSetClass = -2
    self._nowSetClass = -1
    getIngameCashMall():changeViewCharacter(self._productNoRaw)
  end
end
function pearlShopDisplayController:showAvailableMenu()
  local CPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(self._productNoRaw)
  if nil == CPSSW then
    return
  end
  self._curMainCategory = CPSSW:getMainCategory()
  self._curMiddleCategory = CPSSW:getMiddleCategory()
  if self._categoryNo_Pet == self._curMainCategory and self._subCategoryNo_Pet == self._curMiddleCategory then
    self._ui.stc_petMenuBG:SetShow(true)
    self._ui.stc_petLB:SetShow(false)
    self._ui.stc_petRB:SetShow(true)
    self._ui.stc_petLookDescSub:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND_DEFAULT_OPTION"))
  else
    self._ui.stc_petMenuBG:SetShow(false)
  end
  if self._categoryNo_Outfit == self._curMainCategory or true == self._isAvatarProduct then
    local isAwakenWeaponContentsOpen = {
      [CppEnums.ClassType.ClassType_Warrior] = ToClient_IsContentsGroupOpen("901"),
      [CppEnums.ClassType.ClassType_Ranger] = ToClient_IsContentsGroupOpen("902"),
      [CppEnums.ClassType.ClassType_Sorcerer] = ToClient_IsContentsGroupOpen("903"),
      [CppEnums.ClassType.ClassType_Giant] = ToClient_IsContentsGroupOpen("904"),
      [CppEnums.ClassType.ClassType_Tamer] = ToClient_IsContentsGroupOpen("905"),
      [CppEnums.ClassType.ClassType_BladeMaster] = ToClient_IsContentsGroupOpen("906"),
      [CppEnums.ClassType.ClassType_BladeMasterWomen] = ToClient_IsContentsGroupOpen("907"),
      [CppEnums.ClassType.ClassType_Valkyrie] = ToClient_IsContentsGroupOpen("908"),
      [CppEnums.ClassType.ClassType_Wizard] = ToClient_IsContentsGroupOpen("909"),
      [CppEnums.ClassType.ClassType_WizardWomen] = ToClient_IsContentsGroupOpen("910"),
      [CppEnums.ClassType.ClassType_NinjaMan] = ToClient_IsContentsGroupOpen("911"),
      [CppEnums.ClassType.ClassType_NinjaWomen] = ToClient_IsContentsGroupOpen("912"),
      [CppEnums.ClassType.ClassType_DarkElf] = ToClient_IsContentsGroupOpen("913"),
      [CppEnums.ClassType.ClassType_Combattant] = ToClient_IsContentsGroupOpen("914"),
      [CppEnums.ClassType.ClassType_CombattantWomen] = ToClient_IsContentsGroupOpen("918"),
      [CppEnums.ClassType.ClassType_Lahn] = ToClient_IsContentsGroupOpen("916"),
      [CppEnums.ClassType.ClassType_Orange] = ToClient_IsContentsGroupOpen("942"),
      [__eClassType_ShyWaman] = ToClient_IsContentsGroupOpen("1366")
    }
    self._ui.stc_outfitBtnList[self.OUTFIT_BUTTON_TYPE.IS_AWAKEN]:SetShow(isAwakenWeaponContentsOpen[self._nowSetClass])
    if true == isAwakenWeaponContentsOpen[self._nowSetClass] then
      self._outfitBtnCnt = self.OUTFIT_BUTTON_TYPE.IS_AWAKEN
      local btnSizeX = self._ui.stc_outfitBtnList[self.OUTFIT_BUTTON_TYPE.IS_AWAKEN]:GetSizeX()
      self._ui.stc_outfitBtnList[self.OUTFIT_BUTTON_TYPE.IS_AWAKEN]:SetPosX(self._ui.stc_outfitBtnList[self.OUTFIT_BUTTON_TYPE.POSE_BATTLE]:GetPosX() + btnSizeX + 3)
      self._ui.stc_outfitBtnA:SetPosX(self._ui.stc_outfitBtnList[self.OUTFIT_BUTTON_TYPE.IS_AWAKEN]:GetPosX() + btnSizeX)
    else
      self._outfitBtnCnt = self.OUTFIT_BUTTON_TYPE.POSE_BATTLE
      self._ui.stc_outfitBtnA:SetPosX(self._ui.stc_outfitBtnList[self.OUTFIT_BUTTON_TYPE.IS_AWAKEN]:GetPosX())
    end
    self._ui.stc_outfitMenuBG:SetShow(true)
  else
    self._ui.stc_outfitMenuBG:SetShow(false)
  end
end
function PaGlobalFunc_PearlShopDisplayController_SetProductNoRaw(productNoRaw)
  local self = pearlShopDisplayController
  self._productNoRaw = productNoRaw
  self:update()
end
function PaGlobalFunc_PearlShopDisplayController_Update()
  local self = pearlShopDisplayController
  self:update()
end
function pearlShopDisplayController:updateToggleEffect()
  for index = 1, self._outfitBtnCnt do
    self._ui.stc_outfitBtnToggleEffect[index]:SetShow(self._outfitBtnIsOnList[index])
  end
end
function pearlShopDisplayController:update()
  self:setCharacterEquip()
  self:showAvailableMenu()
  self:updateToggleEffect()
  PaGlobalFunc_PearlShopDisplayController_ResetOutfitDurability()
end
function PaGlobalFunc_PearlShopDisplayController_Open()
  local self = pearlShopDisplayController
  self:open()
end
function pearlShopDisplayController:open()
  self._productNoRaw = -1
  self._isOutfitLBDown = false
  self._isPetLBDown = false
  self._nowSetClass = -1
  self._beforSetClass = -2
  PaGlobalFunc_PearlShopDisplayController_ResetOutfitDurability()
  PaGlobalFunc_PearlShopDisplayController_LBInput(false)
  for index = 1, self._outfitBtnCnt do
    self._outfitBtnIsOnList[index] = false
  end
  PaGlobalFunc_PearlShopDisplayController_TogglePOSE_BATTLE(true)
  PaGlobalFunc_PearlShopDisplayController_ToggleHIDE_HELMET(false)
  self:updateToggleEffect()
  getIngameCashMall():setEquipmentEndurancePercents(1)
  self._ui.stc_petMenuBG:SetShow(false)
  self._ui.stc_outfitMenuBG:SetShow(false)
  self._ui.stc_outfitBtnOnEffect:SetShow(false)
  self._panel:SetShow(true)
  self:showAvailableMenu()
end
function PaGlobalFunc_PearlShopDisplayController_Close()
  local self = pearlShopDisplayController
  self:close()
end
function pearlShopDisplayController:close()
  PaGlobalFunc_PearlShopDisplayController_ResetOutfitDurability()
  self._panel:SetShow(false)
end
function FromClient_PearlShopDisplayControllerInit()
  pearlShopDisplayController:initialize()
  ToClient_setPearlShopUIPanel_XX(Panel_PearlShop_DisplayController)
end
function pearlShopDisplayController:onScreenResize()
  local posX = Panel_PearlShop:GetPosX() + Panel_PearlShop:GetSizeX() + 30
  self._panel:SetPosX(posX)
end
function FromClient_PearlShopDisplayController_OnScreenResize()
  pearlShopDisplayController:onScreenResize()
end
function FromClient_PearlShopDisplayController_ChangeAwakenWeapon(isAwakenWeaponView)
  PaGlobalFunc_PearlShopDisplayController_ToggleIS_AWAKEN(isAwakenWeaponView)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_PearlShopDisplayControllerInit")

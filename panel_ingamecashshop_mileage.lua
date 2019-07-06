local MILEAGE_TYPE = {CHARGED = 0, CONSUMED = 1}
local CHALLENGE_TYPE = {
  NONE = 0,
  IMMEDIATELY = 1,
  DAILY = 2,
  CUMULATEDMINUTE = 3,
  WEEKLY = 4,
  MONTHLY = 5,
  COUNT = 6
}
local CHALLENGE_STEP = {
  PROGRESS = 0,
  REWARDED = 1,
  COMPLETED = 2
}
local PERIOD_INFO = {
  [CHALLENGE_TYPE.NONE] = "",
  [CHALLENGE_TYPE.IMMEDIATELY] = "",
  [CHALLENGE_TYPE.DAILY] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_MILEAGE_DAILY_PERIODINFO"),
  [CHALLENGE_TYPE.CUMULATEDMINUTE] = "",
  [CHALLENGE_TYPE.WEEKLY] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_MILEAGE_WEEKLY_PERIODINFO"),
  [CHALLENGE_TYPE.MONTHLY] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_MILEAGE_MONTHLY_PERIODINFO"),
  [CHALLENGE_TYPE.COUNT] = ""
}
local CashMileage = {
  _ui = {
    _topGroup = nil,
    _tabBtnGroup = nil,
    _contentsGroup = {
      [MILEAGE_TYPE.CHARGED] = nil,
      [MILEAGE_TYPE.CONSUMED] = nil
    },
    _stc_centerBg = nil,
    _list2_mileage = {},
    _staticText_noChallenge = nil,
    _staticText_resetInfo = nil,
    _staticText_periodInfo = nil,
    _mileageTabBtnGroup = {},
    _tabTypeBtnGroup = {}
  },
  _otherUi = {
    _btn_Coupon = nil,
    _btn_StampCoupon = nil,
    _btn_FirstIgnore = nil,
    _btn_SaleGoods = nil,
    _btn_Mileage = nil,
    _static_DiscountPrice = nil
  },
  _tabShowCnt = 0,
  _nowTabShowCnt = 0,
  _initialize = false,
  _typeBtnCnt = 0,
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true,
    createCount = true,
    createCash = true,
    createEnduranceIcon = true
  },
  _mileageSlots = {
    [MILEAGE_TYPE.CHARGED] = {},
    [MILEAGE_TYPE.CONSUMED] = {}
  },
  _mileageDefaultKey = MILEAGE_TYPE.CHARGED,
  _mileageDefaultType = {
    [MILEAGE_TYPE.CHARGED] = -1,
    [MILEAGE_TYPE.CONSUMED] = -1
  },
  _mileageInfo = {},
  _mileageInfoCnt = 0,
  _maxSlotCnt = 7,
  _nowProgressKeyGroup = {
    [MILEAGE_TYPE.CHARGED] = -1,
    [MILEAGE_TYPE.CONSUMED] = -1
  },
  _nowDay = ToClient_GetToday(),
  _nowMileageInfoKey = -1,
  _nowTabInfoKey = -1,
  _showPearlPrice = -1,
  _nowConfirmKey = -1,
  _nowObtainedPearl = 0,
  _nowUsedPearl = 0,
  _panelSizeY = 0,
  _centerBGSizeY = 0
}
function CashMileage:initialize()
  if nil == Panel_IngameCashShop_Mileage then
    return false
  end
  CashMileage._tabShowCnt = 0
  CashMileage._nowTabShowCnt = 0
  CashMileage._initialize = false
  CashMileage._typeBtnCnt = 0
  CashMileage._mileageSlots = {
    [MILEAGE_TYPE.CHARGED] = {},
    [MILEAGE_TYPE.CONSUMED] = {}
  }
  CashMileage._mileageDefaultKey = MILEAGE_TYPE.CHARGED
  CashMileage._mileageDefaultType = {
    [MILEAGE_TYPE.CHARGED] = -1,
    [MILEAGE_TYPE.CONSUMED] = -1
  }
  CashMileage._mileageInfo = {}
  CashMileage._mileageInfoCnt = 0
  CashMileage._maxSlotCnt = 7
  CashMileage._nowProgressKeyGroup = {
    [MILEAGE_TYPE.CHARGED] = -1,
    [MILEAGE_TYPE.CONSUMED] = -1
  }
  CashMileage._nowDay = ToClient_GetToday()
  CashMileage._nowMileageInfoKey = -1
  CashMileage._nowTabInfoKey = -1
  CashMileage._showPearlPrice = -1
  CashMileage._nowConfirmKey = -1
  CashMileage._nowObtainedPearl = 0
  CashMileage._nowUsedPearl = 0
  CashMileage._panelSizeY = 0
  CashMileage._centerBGSizeY = 0
  self._ui._topGroup = UI.getChildControl(Panel_IngameCashShop_Mileage, "Static_TopGroup")
  self._ui._tabBtnGroup = UI.getChildControl(Panel_IngameCashShop_Mileage, "Static_Tap_Btn_Group")
  self._ui._contentsGroup = {
    [MILEAGE_TYPE.CHARGED] = UI.getChildControl(Panel_IngameCashShop_Mileage, "Static_Charged_Group"),
    [MILEAGE_TYPE.CONSUMED] = UI.getChildControl(Panel_IngameCashShop_Mileage, "Static_Consumed_Group")
  }
  self._ui._stc_centerBg = UI.getChildControl(Panel_IngameCashShop_Mileage, "Static_Center_Bg")
  self._ui._staticText_noChallenge = UI.getChildControl(Panel_IngameCashShop_Mileage, "StaticText_NoChallenge")
  self._ui._staticText_resetInfo = UI.getChildControl(Panel_IngameCashShop_Mileage, "StaticText_ResetInfo")
  self._ui._staticText_periodInfo = UI.getChildControl(Panel_IngameCashShop_Mileage, "StaticText_PeriodInfo")
  self._otherUi._btn_Coupon = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_Coupon")
  self._otherUi._btn_StampCoupon = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_StampCoupon")
  self._otherUi._btn_FirstIgnore = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_FirstIgnore")
  self._otherUi._btn_SaleGoods = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_SaleGoods")
  self._otherUi._btn_Mileage = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_Mileage")
  self._otherUi._static_DiscountPrice = UI.getChildControl(Panel_IngameCashShop_BuyOrGift, "StaticText_DiscountGoodsPrice")
  self._panelSizeY = Panel_IngameCashShop_Mileage:GetSizeY()
  self._centerBGSizeY = self._ui._stc_centerBg:GetSizeY()
  self._ui.btn_Close = UI.getChildControl(self._ui._topGroup, "Button_Win_Close")
  self._ui.btn_Charged = UI.getChildControl(self._ui._tabBtnGroup, "RadioButton_Charged")
  self._ui.btn_Consumed = UI.getChildControl(self._ui._tabBtnGroup, "RadioButton_Consumed")
  self._ui._mileageTabBtnGroup[MILEAGE_TYPE.CHARGED] = self._ui.btn_Charged
  self._ui._mileageTabBtnGroup[MILEAGE_TYPE.CONSUMED] = self._ui.btn_Consumed
  local chargedTabGroup = UI.getChildControl(self._ui._contentsGroup[MILEAGE_TYPE.CHARGED], "Static_Type_Btn_Group")
  self._ui._tabTypeBtnGroup[MILEAGE_TYPE.CHARGED] = {}
  self._ui._tabTypeBtnGroup[MILEAGE_TYPE.CHARGED][CHALLENGE_TYPE.MONTHLY] = UI.getChildControl(chargedTabGroup, "RadioButton_Monthly")
  self._ui._tabTypeBtnGroup[MILEAGE_TYPE.CHARGED][CHALLENGE_TYPE.WEEKLY] = UI.getChildControl(chargedTabGroup, "RadioButton_Weekly")
  self._ui._tabTypeBtnGroup[MILEAGE_TYPE.CHARGED][CHALLENGE_TYPE.DAILY] = UI.getChildControl(chargedTabGroup, "RadioButton_Daily")
  self._tabShowCnt = self._tabShowCnt + 1
  local consumedTabGroup = UI.getChildControl(self._ui._contentsGroup[MILEAGE_TYPE.CONSUMED], "Static_Type_Btn_Group")
  self._ui._tabTypeBtnGroup[MILEAGE_TYPE.CONSUMED] = {}
  self._ui._tabTypeBtnGroup[MILEAGE_TYPE.CONSUMED][CHALLENGE_TYPE.MONTHLY] = UI.getChildControl(consumedTabGroup, "RadioButton_Monthly")
  self._ui._tabTypeBtnGroup[MILEAGE_TYPE.CONSUMED][CHALLENGE_TYPE.WEEKLY] = UI.getChildControl(consumedTabGroup, "RadioButton_Weekly")
  self._ui._tabTypeBtnGroup[MILEAGE_TYPE.CONSUMED][CHALLENGE_TYPE.DAILY] = UI.getChildControl(consumedTabGroup, "RadioButton_Daily")
  self._tabShowCnt = self._tabShowCnt + 1
  self._ui._list2_mileage[MILEAGE_TYPE.CHARGED] = UI.getChildControl(self._ui._contentsGroup[MILEAGE_TYPE.CHARGED], "List2_MileageList")
  self._ui._list2_mileage[MILEAGE_TYPE.CONSUMED] = UI.getChildControl(self._ui._contentsGroup[MILEAGE_TYPE.CONSUMED], "List2_MileageList")
  if nil ~= ToClient_GetCurrentPearlObtainedTotal() then
    self._nowObtainedPearl = ToClient_GetCurrentPearlObtainedTotal()
  end
  if nil ~= ToClient_GetCurrentPearlUsedTotal() then
    self._nowUsedPearl = ToClient_GetCurrentPearlUsedTotal()
  end
  self:registControlEventHandler()
  self._initialize = true
  self:dayChange()
  self:update(MILEAGE_TYPE.CONSUMED)
end
function CashMileage:childComputePos()
  if nil == Panel_IngameCashShop_Mileage then
    return false
  end
  self._ui._stc_centerBg:ComputePos()
  self._ui._tabBtnGroup:ComputePos()
  for key, value in pairs(self._ui._contentsGroup) do
    value:ComputePos()
  end
  self._ui._staticText_noChallenge:ComputePos()
  self._ui._staticText_resetInfo:ComputePos()
end
function CashMileage:dayChange()
  if nil == Panel_IngameCashShop_Mileage then
    return
  end
  self._nowTabShowCnt = self._tabShowCnt
  self:challengeBtnGroupCheck(MILEAGE_TYPE.CONSUMED)
  self:challengeBtnGroupCheck(MILEAGE_TYPE.CHARGED)
  if self._nowTabShowCnt < 2 then
    self._ui._tabBtnGroup:SetShow(false)
    if Panel_IngameCashShop_Mileage:GetSizeY() ~= self._panelSizeY - self._ui._tabBtnGroup:GetSizeY() then
      Panel_IngameCashShop_Mileage:SetSize(Panel_IngameCashShop_Mileage:GetSizeX(), self._panelSizeY - self._ui._tabBtnGroup:GetSizeY())
      self:childComputePos()
    end
  else
    self._ui._tabBtnGroup:SetShow(true)
    Panel_IngameCashShop_Mileage:SetSize(Panel_IngameCashShop_Mileage:GetSizeX(), self._panelSizeY)
    if Panel_IngameCashShop_Mileage:GetSizeY() ~= self._panelSizeY then
      Panel_IngameCashShop_Mileage:SetSize(Panel_IngameCashShop_Mileage:GetSizeX(), self._panelSizeY)
      self:childComputePos()
    end
  end
  self._ui._staticText_resetInfo:SetText("")
  self:update(self._nowMileageInfoKey, self._nowTabInfoKey)
  if true == PaGlobal_CashMileage_IsOpenCheck() then
    if 90 == self._otherUi._btn_Coupon:GetSpanSize().y then
      self._otherUi._btn_Mileage:SetShow(true)
      self._otherUi._btn_Mileage:SetSpanSize(10, 90)
      self._otherUi._btn_Coupon:SetSpanSize(10, 130)
      self._otherUi._btn_StampCoupon:SetSpanSize(10, 170)
      self._otherUi._btn_FirstIgnore:SetSpanSize(10, 170)
      self._otherUi._btn_SaleGoods:SetSpanSize(10, 210)
    elseif 140 == self._otherUi._btn_Coupon:GetSpanSize().y then
      self._otherUi._btn_Mileage:SetShow(true)
      self.btn_Mileage:SetSpanSize(10, 140)
      self.btn_Coupon:SetSpanSize(10, 180)
      self.btn_StampCoupon:SetSpanSize(10, 220)
      self.btn_FirstIgnore:SetSpanSize(10, 220)
    end
  end
end
function CashMileage:registControlEventHandler()
  if nil == Panel_IngameCashShop_Mileage then
    return false
  end
  self._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_CashMileage_Close()")
  self._ui.btn_Charged:addInputEvent("Mouse_LUp", "PaGlobal_CashMileage_Update(" .. MILEAGE_TYPE.CHARGED .. ")")
  self._ui.btn_Consumed:addInputEvent("Mouse_LUp", "PaGlobal_CashMileage_Update(" .. MILEAGE_TYPE.CONSUMED .. ")")
  local chargedTabGroup = self._ui._tabTypeBtnGroup[MILEAGE_TYPE.CHARGED]
  chargedTabGroup[CHALLENGE_TYPE.MONTHLY]:addInputEvent("Mouse_LUp", "PaGlobal_CashMileage_Type_Update(" .. CHALLENGE_TYPE.MONTHLY .. ")")
  chargedTabGroup[CHALLENGE_TYPE.WEEKLY]:addInputEvent("Mouse_LUp", "PaGlobal_CashMileage_Type_Update(" .. CHALLENGE_TYPE.WEEKLY .. ")")
  chargedTabGroup[CHALLENGE_TYPE.DAILY]:addInputEvent("Mouse_LUp", "PaGlobal_CashMileage_Type_Update(" .. CHALLENGE_TYPE.DAILY .. ")")
  local consumedTabGroup = self._ui._tabTypeBtnGroup[MILEAGE_TYPE.CONSUMED]
  consumedTabGroup[CHALLENGE_TYPE.MONTHLY]:addInputEvent("Mouse_LUp", "PaGlobal_CashMileage_Type_Update(" .. CHALLENGE_TYPE.MONTHLY .. ")")
  consumedTabGroup[CHALLENGE_TYPE.WEEKLY]:addInputEvent("Mouse_LUp", "PaGlobal_CashMileage_Type_Update(" .. CHALLENGE_TYPE.WEEKLY .. ")")
  consumedTabGroup[CHALLENGE_TYPE.DAILY]:addInputEvent("Mouse_LUp", "PaGlobal_CashMileage_Type_Update(" .. CHALLENGE_TYPE.DAILY .. ")")
  for index = 0, #self._ui._list2_mileage do
    self._ui._list2_mileage[index]:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_CashMileage_ListCreate")
    self._ui._list2_mileage[index]:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
    self._ui._list2_mileage[index]:ComputePos()
  end
end
function CashMileage:registEventHandler()
  registerEvent("onScreenResize", "PaGlobal_CashMileage_OnResize")
  registerEvent("FromClient_InventoryUpdate", "FromClient_CashMileage_InventoryUpdate")
  registerEvent("FromClient_NotifyCompleteBuyProduct", "FromClient_CashMileage_NotifyCompleteBuyProduct")
  registerEvent("FromClient_UpdatePearlMileage", "FromClient_CashMileage_UpdatePearlMileage")
  registerEvent("FromClient_SelectRandomItem", "FromClient_CashMileage_SelectRandomItem")
  registerEvent("FromClient_ChallengeReward_UpdateText", "FromClient_CashMileage_UpdateText")
  registerEvent("FromClient_AttendanceTimer", "FromClient_CashMileage_AttendanceTimer")
end
function PaGlobal_CashMileage_ConfirmReward()
  local self = CashMileage
  local itemKey = self._nowConfirmKey
  if nil == self._mileageInfo[itemKey] then
    return
  end
  if CHALLENGE_STEP.REWARDED ~= self._mileageInfo[itemKey].nowStep then
    return
  end
  ToClient_AcceptReward_ButtonClicked(self._mileageInfo[itemKey]:getKey(), 0)
end
function PaGlobal_CashMileage_ApplyReward(itemKey)
  local self = CashMileage
  if self._nowDay ~= ToClient_GetToday() then
    self._nowDay = ToClient_GetToday()
    self:dayChange()
    return
  end
  if nil == self._mileageInfo[itemKey] then
    return
  end
  if CHALLENGE_STEP.REWARDED ~= self._mileageInfo[itemKey].nowStep then
    return
  end
  self._nowConfirmKey = itemKey
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_ALERT")
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_MILEAGE_CONFIRM_MESSAGE")
  local messageBoxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = PaGlobal_CashMileage_ConfirmReward,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function CashMileage:open()
  if false == PaGlobal_CashMileage_IsOpenCheck() then
    return
  end
  PaGlobal_CashMileage_OnResize()
  Panel_IngameCashShop_Mileage:SetShow(true)
end
function CashMileage:close()
  self._showPearlPrice = -1
  self._initialize = false
  TooltipSimple_Hide()
  if nil ~= Panel_IngameCashShop_Mileage then
    reqCloseUI(Panel_IngameCashShop_Mileage, false)
  end
end
function CashMileage:refreshRewardInfo(mileageType, challengeType)
  self._mileageInfo = {}
  self._mileageInfoCnt = 0
  local tempCnt = 0
  if mileageType == MILEAGE_TYPE.CHARGED then
    tempCnt = ToClient_GetRewardedPearlObtainedCount(challengeType)
    for ii = 0, tempCnt - 1 do
      self._mileageInfo[self._mileageInfoCnt] = ToClient_GetRewardedPearlObtainedAt(challengeType, ii)
      self._mileageInfo[self._mileageInfoCnt].nowStep = CHALLENGE_STEP.REWARDED
      self._mileageInfoCnt = self._mileageInfoCnt + 1
    end
    self._nowProgressKeyGroup[mileageType] = self._mileageInfoCnt
    tempCnt = ToClient_GetProgressPearlObtainedCount(challengeType)
    for ii = 0, tempCnt - 1 do
      self._mileageInfo[self._mileageInfoCnt] = ToClient_GetProgressPearlObtainedAt(challengeType, ii)
      self._mileageInfo[self._mileageInfoCnt].nowStep = CHALLENGE_STEP.PROGRESS
      self._mileageInfoCnt = self._mileageInfoCnt + 1
    end
    tempCnt = ToClient_GetCompletedPearlObtainedCount(challengeType)
    for ii = 0, tempCnt - 1 do
      self._mileageInfo[self._mileageInfoCnt] = ToClient_GetCompletedPearlObtainedAt(challengeType, ii)
      self._mileageInfo[self._mileageInfoCnt].nowStep = CHALLENGE_STEP.COMPLETED
      self._mileageInfoCnt = self._mileageInfoCnt + 1
    end
  elseif mileageType == MILEAGE_TYPE.CONSUMED then
    tempCnt = ToClient_GetRewardedPearlUsedCount(challengeType)
    for ii = 0, tempCnt - 1 do
      self._mileageInfo[self._mileageInfoCnt] = ToClient_GetRewardedPearlUsedAt(challengeType, ii)
      self._mileageInfo[self._mileageInfoCnt].nowStep = CHALLENGE_STEP.REWARDED
      self._mileageInfoCnt = self._mileageInfoCnt + 1
    end
    self._nowProgressKeyGroup[mileageType] = self._mileageInfoCnt
    tempCnt = ToClient_GetProgressPearlUsedCount(challengeType)
    for ii = 0, tempCnt - 1 do
      self._mileageInfo[self._mileageInfoCnt] = ToClient_GetProgressPearlUsedAt(challengeType, ii)
      self._mileageInfo[self._mileageInfoCnt].nowStep = CHALLENGE_STEP.PROGRESS
      self._mileageInfoCnt = self._mileageInfoCnt + 1
    end
    tempCnt = ToClient_GetCompletedPearlUsedCount(challengeType)
    for ii = 0, tempCnt - 1 do
      self._mileageInfo[self._mileageInfoCnt] = ToClient_GetCompletedPearlUsedAt(challengeType, ii)
      self._mileageInfo[self._mileageInfoCnt].nowStep = CHALLENGE_STEP.COMPLETED
      self._mileageInfoCnt = self._mileageInfoCnt + 1
    end
  end
end
function CashMileage:checkChallengeCnt(mileageType, challengeType)
  local tempCnt = 0
  local tempBtn = self._ui._tabTypeBtnGroup[mileageType][challengeType]
  if mileageType == MILEAGE_TYPE.CHARGED then
    tempCnt = tempCnt + ToClient_GetRewardedPearlObtainedCount(challengeType)
    tempCnt = tempCnt + ToClient_GetProgressPearlObtainedCount(challengeType)
    tempCnt = tempCnt + ToClient_GetCompletedPearlObtainedCount(challengeType)
  elseif mileageType == MILEAGE_TYPE.CONSUMED then
    tempCnt = tempCnt + ToClient_GetRewardedPearlUsedCount(challengeType)
    tempCnt = tempCnt + ToClient_GetProgressPearlUsedCount(challengeType)
    tempCnt = tempCnt + ToClient_GetCompletedPearlUsedCount(challengeType)
  end
  return tempCnt
end
function CashMileage:challengeBtnGroupCheck(mileageType)
  if nil == Panel_IngameCashShop_Mileage then
    return false
  end
  local tempTypeBtnGroup = self._ui._tabTypeBtnGroup[mileageType]
  tempTypeBtnGroup[CHALLENGE_TYPE.MONTHLY]:SetPosX(0)
  tempTypeBtnGroup[CHALLENGE_TYPE.WEEKLY]:SetPosX(0)
  tempTypeBtnGroup[CHALLENGE_TYPE.DAILY]:SetPosX(0)
  tempTypeBtnGroup[CHALLENGE_TYPE.MONTHLY]:SetCheck(false)
  tempTypeBtnGroup[CHALLENGE_TYPE.WEEKLY]:SetCheck(false)
  tempTypeBtnGroup[CHALLENGE_TYPE.DAILY]:SetCheck(false)
  self._typeBtnCnt = 0
  local tempMonthly = self:checkChallengeCnt(mileageType, CHALLENGE_TYPE.MONTHLY)
  local tempWeekly = self:checkChallengeCnt(mileageType, CHALLENGE_TYPE.WEEKLY)
  local tempDaily = self:checkChallengeCnt(mileageType, CHALLENGE_TYPE.DAILY)
  self._mileageDefaultType[mileageType] = -1
  if tempMonthly > 0 then
    tempTypeBtnGroup[CHALLENGE_TYPE.MONTHLY]:SetPosX((tempTypeBtnGroup[CHALLENGE_TYPE.MONTHLY]:GetSizeX() + 5) * self._typeBtnCnt)
    self._typeBtnCnt = self._typeBtnCnt + 1
    tempTypeBtnGroup[CHALLENGE_TYPE.MONTHLY]:SetShow(true)
    if -1 == self._mileageDefaultType[mileageType] then
      self._mileageDefaultType[mileageType] = CHALLENGE_TYPE.MONTHLY
    end
  else
    tempTypeBtnGroup[CHALLENGE_TYPE.MONTHLY]:SetShow(false)
  end
  if tempWeekly > 0 then
    tempTypeBtnGroup[CHALLENGE_TYPE.WEEKLY]:SetPosX((tempTypeBtnGroup[CHALLENGE_TYPE.WEEKLY]:GetSizeX() + 5) * self._typeBtnCnt)
    self._typeBtnCnt = self._typeBtnCnt + 1
    tempTypeBtnGroup[CHALLENGE_TYPE.WEEKLY]:SetShow(true)
    if -1 == self._mileageDefaultType[mileageType] then
      self._mileageDefaultType[mileageType] = CHALLENGE_TYPE.WEEKLY
    end
  else
    tempTypeBtnGroup[CHALLENGE_TYPE.WEEKLY]:SetShow(false)
  end
  if tempDaily > 0 then
    tempTypeBtnGroup[CHALLENGE_TYPE.DAILY]:SetPosX((tempTypeBtnGroup[CHALLENGE_TYPE.DAILY]:GetSizeX() + 5) * self._typeBtnCnt)
    self._typeBtnCnt = self._typeBtnCnt + 1
    tempTypeBtnGroup[CHALLENGE_TYPE.DAILY]:SetShow(true)
    if -1 == self._mileageDefaultType[mileageType] then
      self._mileageDefaultType[mileageType] = CHALLENGE_TYPE.DAILY
    end
  else
    tempTypeBtnGroup[CHALLENGE_TYPE.DAILY]:SetShow(false)
  end
  local totalChallengeCnt = tempMonthly + tempWeekly + tempDaily
  if totalChallengeCnt < 1 then
    if nil ~= self._ui._mileageTabBtnGroup[mileageType] then
      self._ui._mileageTabBtnGroup[mileageType]:SetShow(false)
    end
    self._nowTabShowCnt = self._nowTabShowCnt - 1
  else
    self._mileageDefaultKey = mileageType
  end
end
function CashMileage:update(mileageType, tabIndex)
  if nil == Panel_IngameCashShop_Mileage then
    return false
  end
  if nil == mileageType or -1 == mileageType or mileageType > #self._ui._mileageTabBtnGroup then
    mileageType = MILEAGE_TYPE.CHARGED
  end
  if nil == tabIndex or -1 == tabIndex then
    tabIndex = self._mileageDefaultType[mileageType]
    if nil == tabIndex or -1 == tabIndex then
      return
    end
  end
  if nil ~= ToClient_GetCurrentPearlObtainedTotal() then
    self._nowObtainedPearl = ToClient_GetCurrentPearlObtainedTotal()
  end
  if nil ~= ToClient_GetCurrentPearlUsedTotal() then
    self._nowUsedPearl = ToClient_GetCurrentPearlUsedTotal()
  end
  self._nowMileageInfoKey = mileageType
  self._nowTabInfoKey = tabIndex
  self._ui._tabTypeBtnGroup[self._nowMileageInfoKey][CHALLENGE_TYPE.MONTHLY]:SetCheck(false)
  self._ui._tabTypeBtnGroup[self._nowMileageInfoKey][CHALLENGE_TYPE.WEEKLY]:SetCheck(false)
  self._ui._tabTypeBtnGroup[self._nowMileageInfoKey][CHALLENGE_TYPE.DAILY]:SetCheck(false)
  if nil ~= self._ui._tabTypeBtnGroup[self._nowMileageInfoKey][tabIndex] then
    self._ui._tabTypeBtnGroup[self._nowMileageInfoKey][tabIndex]:SetCheck(true)
  end
  for ii = 0, #self._ui._mileageTabBtnGroup do
    if ii == self._nowMileageInfoKey then
      self._ui._mileageTabBtnGroup[ii]:SetCheck(true)
      self._ui._contentsGroup[ii]:SetShow(true)
    else
      self._ui._mileageTabBtnGroup[ii]:SetCheck(false)
      self._ui._contentsGroup[ii]:SetShow(false)
    end
  end
  self._mileageSlots[self._nowMileageInfoKey] = {}
  self:refreshRewardInfo(self._nowMileageInfoKey, self._nowTabInfoKey)
  local resetInfoText = ""
  local periodInfoText = ""
  local resetInfoControl = self._ui._staticText_resetInfo
  local periodInfoControl = self._ui._staticText_periodInfo
  if nil ~= self._mileageInfo[0] then
    resetInfoText = self._mileageInfo[0]:getDesc() .. "\n"
  end
  periodInfoText = PERIOD_INFO[tabIndex] .. [[


]] .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INGAMECASHSHOP_MILEAGE_ALERTINFO")
  resetInfoControl:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  resetInfoControl:SetText(resetInfoText)
  resetInfoControl:SetSize(resetInfoControl:GetSizeX(), resetInfoControl:GetTextSizeY())
  periodInfoControl:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  periodInfoControl:SetText(periodInfoText)
  periodInfoControl:SetSize(periodInfoControl:GetSizeX(), periodInfoControl:GetTextSizeY())
  periodInfoControl:SetSpanSize(periodInfoControl:GetSpanSize().x, resetInfoControl:GetSpanSize().y + resetInfoControl:GetTextSizeY() + 3)
  Panel_IngameCashShop_Mileage:SetSize(Panel_IngameCashShop_Mileage:GetSizeX(), 600 + resetInfoControl:GetTextSizeY() + periodInfoControl:GetTextSizeY() + 10)
  resetInfoControl:ComputePos()
  periodInfoControl:ComputePos()
  self._ui._list2_mileage[self._nowMileageInfoKey]:getElementManager():clearKey()
  if 0 < self._mileageInfoCnt then
    self._ui._staticText_noChallenge:SetShow(false)
    for ii = 0, self._mileageInfoCnt - 1 do
      if nil ~= self._mileageInfo[ii] then
        self._mileageSlots[self._nowMileageInfoKey][ii] = {}
        self._ui._list2_mileage[self._nowMileageInfoKey]:getElementManager():pushKey(toInt64(0, ii))
      end
    end
  else
    self._ui._staticText_noChallenge:SetShow(true)
  end
  self._nowConfirmKey = -1
end
function PaGlobal_CashMileage_ListCreate(content, key)
  if nil == Panel_IngameCashShop_Mileage then
    return false
  end
  local self = CashMileage
  local key32 = Int64toInt32(key)
  if nil == self._mileageInfo[key32] then
    return
  end
  local stc_contentArea = UI.getChildControl(content, "List2_Content_Bg")
  local stctxt_title = UI.getChildControl(stc_contentArea, "StaticText_MileageTitle")
  local btn_action = UI.getChildControl(stc_contentArea, "Button_Reward")
  local stc_rewardRateBg = UI.getChildControl(stc_contentArea, "Static_RewardGage_Bg")
  local stc_rewardComplete = UI.getChildControl(stc_contentArea, "Static_RewardGage_Complete")
  local progress_rewardRate = UI.getChildControl(stc_contentArea, "Progress2_RewardGage")
  local progress_rewardRateLater = UI.getChildControl(stc_contentArea, "Progress2_RewardGage_Later")
  local stctxt_rewardValue = UI.getChildControl(stc_contentArea, "StaticText_RewardValue")
  local stctxt_rewarded = UI.getChildControl(stc_contentArea, "StaticText_RewardedText")
  local stc_rewardedIcon = UI.getChildControl(stc_contentArea, "Static_RewardedIcon")
  local gapX = 3
  stc_rewardRateBg:SetShow(false)
  progress_rewardRate:SetShow(false)
  progress_rewardRateLater:SetShow(false)
  stctxt_rewardValue:SetShow(false)
  btn_action:SetShow(false)
  stctxt_rewarded:SetShow(false)
  stc_rewardComplete:SetShow(false)
  stc_rewardedIcon:SetShow(false)
  stctxt_title:SetText(self._mileageInfo[key32]:getName())
  local itemCnt = self._mileageInfo[key32]:getBaseRewardCount()
  for ii = 0, self._maxSlotCnt - 1 do
    local itemSlotBg = UI.getChildControl(stc_contentArea, "Static_ItemSlotBg_" .. ii)
    if nil ~= itemSlotBg then
      itemSlotBg:SetPosX(30 + (itemSlotBg:GetSizeX() + gapX) * ii)
      if ii < itemCnt then
        local baseReward = self._mileageInfo[key32]:getBaseRewardAt(ii)
        if nil ~= baseReward then
          local slot = {}
          slot.empty = itemSlotBg
          SlotItem.reInclude(slot, "ItemSlot", ii, slot.empty, self._slotConfig)
          slot.icon:SetShow(true)
          local slotOption = {}
          slotOption._type = baseReward._type
          if __eRewardExp == baseReward._type then
            slotOption._exp = baseReward._experience
          elseif __eRewardSkillExp == baseReward._type then
            slotOption._exp = baseReward._skillExperience
          elseif __eRewardLifeExp == baseReward._type then
            slotOption._exp = baseReward._productExperience
          elseif __eRewardItem == baseReward._type then
            slotOption._item = baseReward:getItemEnchantKey()
            slotOption._count = baseReward._itemCount
            local selfPlayer = getSelfPlayer()
            if nil ~= selfPlayer then
              local classType = selfPlayer:getClassType()
              slotOption._isEquipable = baseReward:isEquipable(classType)
            end
          elseif __eRewardIntimacy == baseReward._type then
            slotOption._character = baseReward:getIntimacyCharacter()
            slotOption._value = baseReward._intimacyValue
          end
          self._mileageSlots[self._nowMileageInfoKey][key32][ii] = slot
          self:setCashMileageRewardShow(key32, ii, slotOption)
        end
      else
        local tempIcon = UI.getChildControl(itemSlotBg, "Static_ItemSlot")
        tempIcon:SetShow(false)
      end
    end
  end
  if self._mileageInfo[key32].nowStep == CHALLENGE_STEP.PROGRESS then
    local x1, y1, x2, y2 = setTextureUV_Func(stc_contentArea, 1, 108, 114, 160)
    local nowAttainment = 0
    stc_contentArea:getBaseTexture():setUV(x1, y1, x2, y2)
    stc_contentArea:setRenderTexture(stc_contentArea:getBaseTexture())
    if self._nowMileageInfoKey == MILEAGE_TYPE.CHARGED then
      if self._nowTabInfoKey == CHALLENGE_TYPE.DAILY then
        nowAttainment = Int64toInt32(ToClient_GetCurrentPearlObtainedDaily())
      elseif self._nowTabInfoKey == CHALLENGE_TYPE.WEEKLY then
        nowAttainment = Int64toInt32(ToClient_GetCurrentPearlObtainedWeekly())
      elseif self._nowTabInfoKey == CHALLENGE_TYPE.MONTHLY then
        nowAttainment = Int64toInt32(ToClient_GetCurrentPearlObtainedMonthly())
      end
    elseif self._nowMileageInfoKey == MILEAGE_TYPE.CONSUMED then
      if self._nowTabInfoKey == CHALLENGE_TYPE.DAILY then
        nowAttainment = Int64toInt32(ToClient_GetCurrentPearlUsedDaily())
      elseif self._nowTabInfoKey == CHALLENGE_TYPE.WEEKLY then
        nowAttainment = Int64toInt32(ToClient_GetCurrentPearlUsedWeekly())
      elseif self._nowTabInfoKey == CHALLENGE_TYPE.MONTHLY then
        nowAttainment = Int64toInt32(ToClient_GetCurrentPearlUsedMonthly())
      end
    end
    local nowGoal = self._mileageInfo[key32]:getCompleteParam1()
    local isGoal = false
    local rate = math.floor(nowAttainment / nowGoal * 100)
    progress_rewardRate:SetProgressRate(rate)
    if rate < 100 then
      stctxt_rewardValue:SetText(nowAttainment .. "/" .. nowGoal)
      progress_rewardRateLater:SetProgressRate(rate)
      if toInt64(0, 0) < toInt64(0, self._showPearlPrice) and MILEAGE_TYPE.CONSUMED == self._nowMileageInfoKey then
        rate = math.floor((self._showPearlPrice + nowAttainment) / nowGoal * 100)
        progress_rewardRateLater:SetShow(true)
        if rate >= 100 then
          stc_rewardComplete:SetShow(true)
        end
        stctxt_rewardValue:SetText(nowAttainment .. " <PAColor0xFF5DFF70>(+" .. self._showPearlPrice .. ")<PAOldColor> /" .. nowGoal)
        progress_rewardRateLater:SetProgressRate(rate)
      else
        progress_rewardRateLater:SetShow(false)
      end
      stctxt_rewardValue:SetPosY(progress_rewardRate:GetPosY() + progress_rewardRate:GetSizeY() / 2 - stctxt_rewardValue:GetSizeY() / 2)
      progress_rewardRate:SetShow(true)
      stctxt_rewardValue:SetShow(true)
      stc_rewardRateBg:SetShow(true)
      btn_action:SetIgnore(true)
    else
      local x1, y1, x2, y2 = setTextureUV_Func(stc_contentArea, 1, 55, 114, 107)
      stc_contentArea:getBaseTexture():setUV(x1, y1, x2, y2)
      stc_contentArea:setRenderTexture(stc_contentArea:getBaseTexture())
      btn_action:SetShow(true)
      btn_action:SetIgnore(false)
      btn_action:addInputEvent("Mouse_LUp", "PaGlobal_CashMileage_ApplyReward(" .. key32 .. ")")
    end
  elseif self._mileageInfo[key32].nowStep == CHALLENGE_STEP.REWARDED then
    local x1, y1, x2, y2 = setTextureUV_Func(stc_contentArea, 1, 55, 114, 107)
    stc_contentArea:getBaseTexture():setUV(x1, y1, x2, y2)
    stc_contentArea:setRenderTexture(stc_contentArea:getBaseTexture())
    btn_action:SetShow(true)
    btn_action:SetIgnore(false)
    btn_action:addInputEvent("Mouse_LUp", "PaGlobal_CashMileage_ApplyReward(" .. key32 .. ")")
  elseif self._mileageInfo[key32].nowStep == CHALLENGE_STEP.COMPLETED then
    local x1, y1, x2, y2 = setTextureUV_Func(stc_contentArea, 1, 1, 115, 54)
    stc_contentArea:getBaseTexture():setUV(x1, y1, x2, y2)
    stc_contentArea:setRenderTexture(stc_contentArea:getBaseTexture())
    stc_rewardedIcon:SetShow(true)
    stctxt_rewarded:SetShow(true)
  end
end
function CashMileage:checkMileageRewarded()
  if nil == Panel_IngameCashShop_Mileage then
    return
  end
  local tempCnt = 0
  tempCnt = tempCnt + ToClient_GetRewardedPearlObtainedCount(CHALLENGE_TYPE.MONTHLY)
  tempCnt = tempCnt + ToClient_GetRewardedPearlObtainedCount(CHALLENGE_TYPE.DAILY)
  tempCnt = tempCnt + ToClient_GetRewardedPearlObtainedCount(CHALLENGE_TYPE.WEEKLY)
  tempCnt = tempCnt + ToClient_GetRewardedPearlUsedCount(CHALLENGE_TYPE.MONTHLY)
  tempCnt = tempCnt + ToClient_GetRewardedPearlUsedCount(CHALLENGE_TYPE.WEEKLY)
  tempCnt = tempCnt + ToClient_GetRewardedPearlUsedCount(CHALLENGE_TYPE.DAILY)
  local self = CashMileage
  self._otherUi._btn_Mileage:EraseAllEffect()
  if tempCnt > 0 then
    self._otherUi._btn_Mileage:AddEffect("fUI_Coupon_01B", true, 0, 0)
  end
end
function CashMileage:setCashMileageRewardShow(contentIndex, slotIndex, reward)
  if nil == Panel_IngameCashShop_Mileage then
    return false
  end
  uiSlot = self._mileageSlots[self._nowMileageInfoKey][contentIndex][slotIndex]
  if nil ~= uiSlot then
    if __eRewardExp == reward._type then
      uiSlot.count:SetText("")
      uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    elseif __eRewardSkillExp == reward._type then
      uiSlot.count:SetText("")
      uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
    elseif __eRewardLifeExp == reward._type then
      uiSlot.count:SetText("")
      uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    elseif __eRewardItem == reward._type then
      local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(reward._item))
      if nil ~= itemStatic then
        uiSlot:setItemByStaticStatus(itemStatic, reward._count)
        uiSlot._item = reward._item
      end
      uiSlot.icon:addInputEvent("Mouse_On", "PaGlobal_CashMileage_ShowToolTip(" .. contentIndex .. "," .. slotIndex .. ",true)")
      uiSlot.icon:addInputEvent("Mouse_Out", "PaGlobal_CashMileage_ShowToolTip(" .. contentIndex .. "," .. slotIndex .. ",false)")
    elseif __eRewardIntimacy == reward._type then
      uiSlot.count:SetText(tostring(reward._value))
      uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
    else
      uiSlot.icon:addInputEvent("Mouse_On", "")
      uiSlot.icon:addInputEvent("Mouse_Out", "")
    end
  else
  end
end
function PaGlobal_CashMileage_ShowToolTip(contentIndex, slotIndex, isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  if nil == Panel_IngameCashShop_Mileage then
    return false
  end
  local self = CashMileage
  local uiSlot = self._mileageSlots[self._nowMileageInfoKey][contentIndex][slotIndex]
  local slotIcon = uiSlot.icon
  local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(uiSlot._item))
  local name = itemStatic:getName()
  local desc = itemStatic:getDescription()
  if true == isShow then
    TooltipSimple_Show(slotIcon, name, desc)
  end
end
function FromClient_CashMileage_NotifyCompleteBuyProduct()
  local self = CashMileage
  self._showPearlPrice = -1
  self:checkMileageRewarded()
  if self._nowUsedPearl ~= ToClient_GetCurrentPearlUsedTotal() then
    if MILEAGE_TYPE.CONSUMED == self._nowMileageInfoKey then
      self:update(self._nowMileageInfoKey, self._nowTabInfoKey)
    else
      self:update(MILEAGE_TYPE.CONSUMED)
    end
  else
    return
  end
  if true == PaGlobalFunc_CashMileage_GetShow() then
    self:close()
  end
end
function PaGlobal_CashMileage_ChangeConsumePearl(pearlValue)
  PaGlobalFunc_CashMileage_CheckLoadUI()
  PaGlobal_CashMileage_OnResize()
  local self = CashMileage
  if true == Panel_IngameCashShop_Coupon:GetShow() and false == self._otherUi._static_DiscountPrice:GetShow() then
    Panel_IngameCashShop_Coupon:SetPosX(getScreenSizeX() / 2 - Panel_IngameCashShop_Coupon:GetSizeX() / 2)
    Panel_IngameCashShop_Coupon:SetPosY(90)
  end
  self._showPearlPrice = pearlValue
  if MILEAGE_TYPE.CONSUMED == self._nowMileageInfoKey then
    self:update(self._nowMileageInfoKey, self._nowTabInfoKey)
  else
    self:update(MILEAGE_TYPE.CONSUMED)
  end
  if false == PaGlobalFunc_CashMileage_GetShow() then
    self:open()
  end
  local moveKey = self._ui._list2_mileage[MILEAGE_TYPE.CONSUMED]:getIndexByKey(toInt64(0, self._nowProgressKeyGroup[MILEAGE_TYPE.CONSUMED]))
  self._ui._list2_mileage[MILEAGE_TYPE.CONSUMED]:moveIndex(moveKey)
end
function PaGlobal_CashMileage_OnResize()
  if nil == Panel_IngameCashShop_Mileage then
    return
  end
  if Panel_IngameCashShop_BuyOrGift:GetShow() then
    Panel_IngameCashShop_Mileage:SetPosX(Panel_IngameCashShop_BuyOrGift:GetPosX() + Panel_IngameCashShop_BuyOrGift:GetSizeX())
    Panel_IngameCashShop_Mileage:SetPosY(getScreenSizeY() / 2 - Panel_IngameCashShop_Mileage:GetSizeY() / 2)
  elseif Panel_IngameCashShop_MakePaymentsFromCart:GetShow() then
    Panel_IngameCashShop_Mileage:SetPosX(Panel_IngameCashShop_MakePaymentsFromCart:GetPosX() + Panel_IngameCashShop_MakePaymentsFromCart:GetSizeX())
    Panel_IngameCashShop_Mileage:SetPosY(getScreenSizeY() / 2 - Panel_IngameCashShop_Mileage:GetSizeY() / 2)
  else
    Panel_IngameCashShop_Mileage:SetPosX(getScreenSizeX() - Panel_IngameCashShop_Mileage:GetSizeX() - 150)
    Panel_IngameCashShop_Mileage:SetPosY(150)
  end
  if getScreenSizeX() - Panel_IngameCashShop_Mileage:GetSizeX() < Panel_IngameCashShop_Mileage:GetPosX() then
    Panel_IngameCashShop_Mileage:SetPosX(getScreenSizeX() - Panel_IngameCashShop_Mileage:GetSizeX() - 150)
    Panel_IngameCashShop_Mileage:SetPosY(150)
  end
end
function FromClient_CashMileage_UpdatePearlMileage()
  local self = CashMileage
  self:checkMileageRewarded()
  if self._nowDay ~= ToClient_GetToday() then
    self._nowDay = ToClient_GetToday()
    self:dayChange()
  end
end
function FromClient_CashMileage_AttendanceTimer()
  local self = CashMileage
  if self._nowDay ~= ToClient_GetToday() then
    self._nowDay = ToClient_GetToday()
    self:checkMileageRewarded()
    self:dayChange()
  end
end
function FromClient_CashMileage_UpdateText()
  local self = CashMileage
  self:checkMileageRewarded()
  self:update(self._nowMileageInfoKey, self._nowTabInfoKey)
end
function FromClient_CashMileage_InventoryUpdate()
  local self = CashMileage
  self:checkMileageRewarded()
  if self._nowObtainedPearl ~= ToClient_GetCurrentPearlObtainedTotal() then
    self:update(MILEAGE_TYPE.CHARGED)
  elseif self._nowUsedPearl ~= ToClient_GetCurrentPearlUsedTotal() then
    self:update(MILEAGE_TYPE.CONSUMED)
  end
end
function PaGlobal_CashMileage_Update(mileageType)
  if nil == mileageType then
    return
  end
  local self = CashMileage
  self:update(mileageType)
end
function PaGlobal_CashMileage_Type_Update(tabIndex)
  if nil == tabIndex then
    return
  end
  local self = CashMileage
  self:update(self._nowMileageInfoKey, tabIndex)
end
function PaGlobal_CashMileage_Open()
  PaGlobalFunc_CashMileage_CheckLoadUI()
  local self = CashMileage
  self:update(self._mileageDefaultKey)
  self:open()
end
function PaGlobal_CashMileage_IsOpenCheck()
  if true == _ContentsGroup_PearlShopMileage then
    local tempCnt = 0
    tempCnt = tempCnt + ToClient_GetRewardedPearlObtainedCount(CHALLENGE_TYPE.MONTHLY)
    tempCnt = tempCnt + ToClient_GetProgressPearlObtainedCount(CHALLENGE_TYPE.MONTHLY)
    tempCnt = tempCnt + ToClient_GetCompletedPearlObtainedCount(CHALLENGE_TYPE.MONTHLY)
    tempCnt = tempCnt + ToClient_GetRewardedPearlObtainedCount(CHALLENGE_TYPE.WEEKLY)
    tempCnt = tempCnt + ToClient_GetProgressPearlObtainedCount(CHALLENGE_TYPE.WEEKLY)
    tempCnt = tempCnt + ToClient_GetCompletedPearlObtainedCount(CHALLENGE_TYPE.WEEKLY)
    tempCnt = tempCnt + ToClient_GetRewardedPearlObtainedCount(CHALLENGE_TYPE.DAILY)
    tempCnt = tempCnt + ToClient_GetProgressPearlObtainedCount(CHALLENGE_TYPE.DAILY)
    tempCnt = tempCnt + ToClient_GetCompletedPearlObtainedCount(CHALLENGE_TYPE.DAILY)
    tempCnt = tempCnt + ToClient_GetRewardedPearlUsedCount(CHALLENGE_TYPE.MONTHLY)
    tempCnt = tempCnt + ToClient_GetProgressPearlUsedCount(CHALLENGE_TYPE.MONTHLY)
    tempCnt = tempCnt + ToClient_GetCompletedPearlUsedCount(CHALLENGE_TYPE.MONTHLY)
    tempCnt = tempCnt + ToClient_GetRewardedPearlUsedCount(CHALLENGE_TYPE.WEEKLY)
    tempCnt = tempCnt + ToClient_GetProgressPearlUsedCount(CHALLENGE_TYPE.WEEKLY)
    tempCnt = tempCnt + ToClient_GetCompletedPearlUsedCount(CHALLENGE_TYPE.WEEKLY)
    tempCnt = tempCnt + ToClient_GetRewardedPearlUsedCount(CHALLENGE_TYPE.DAILY)
    tempCnt = tempCnt + ToClient_GetProgressPearlUsedCount(CHALLENGE_TYPE.DAILY)
    tempCnt = tempCnt + ToClient_GetCompletedPearlUsedCount(CHALLENGE_TYPE.DAILY)
    if tempCnt > 0 then
      return true
    end
  end
  return false
end
function FromClient_CashMileage_SelectRandomItem()
  local self = CashMileage
  self:close()
end
function PaGlobal_CashMileage_Close()
  local self = CashMileage
  self:close()
end
function FromClient_CashMileage_luaLoadComplete()
  local self = CashMileage
  self:registEventHandler()
end
function PaGlobalFunc_CashMileage_CheckLoadUI()
  local rv = reqLoadUI("UI_Data/Window/IngameCashShop/Panel_IngameCashShop_Mileage.XML", "Panel_IngameCashShop_Mileage", Defines.UIGroup.PAGameUIGroup_WorldMap_Contents, SETRENDERMODE_BITSET_INGAMECASHSHOP())
  if nil ~= rv and 0 ~= rv then
    Panel_IngameCashShop_Mileage = rv
    rv = nil
    CashMileage:initialize()
  end
end
function PaGlobalFunc_CashMileage_GetShow()
  if nil == Panel_IngameCashShop_Mileage then
    return false
  end
  return Panel_IngameCashShop_Mileage:GetShow()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_CashMileage_luaLoadComplete")

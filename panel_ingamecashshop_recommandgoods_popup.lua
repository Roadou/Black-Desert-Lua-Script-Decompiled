local UI_TM = CppEnums.TextMode
Panel_Window_RecommandGoods_PopUp:SetShow(false)
PaGlobal_Recommend_PopUp = {
  _ui = {
    _topBg = UI.getChildControl(Panel_Window_RecommandGoods_PopUp, "Static_TopBg"),
    _mainBG = UI.getChildControl(Panel_Window_RecommandGoods_PopUp, "Static_Bg"),
    _close = UI.getChildControl(Panel_Window_RecommandGoods_PopUp, "Button_Close"),
    _btn_Left = UI.getChildControl(Panel_Window_RecommandGoods_PopUp, "Button_Left"),
    _btn_Right = UI.getChildControl(Panel_Window_RecommandGoods_PopUp, "Button_Right"),
    _chk_TodayNoShow = UI.getChildControl(Panel_Window_RecommandGoods_PopUp, "CheckButton_TodayNoShow")
  },
  _maxPage = 0,
  _currentPage = 0,
  _CONST_MAX_PAGE_SIZE = 4,
  _isRequestShow = false
}
function PaGlobal_Recommend_PopUp:Initialize()
  self._ui._goodsBG = {
    [0] = UI.getChildControl(PaGlobal_Recommend_PopUp._ui._mainBG, "Static_TempBg0"),
    [1] = UI.getChildControl(PaGlobal_Recommend_PopUp._ui._mainBG, "Static_TempBg1"),
    [2] = UI.getChildControl(PaGlobal_Recommend_PopUp._ui._mainBG, "Static_TempBg2"),
    [3] = UI.getChildControl(PaGlobal_Recommend_PopUp._ui._mainBG, "Static_TempBg3"),
    [4] = UI.getChildControl(PaGlobal_Recommend_PopUp._ui._mainBG, "Static_TempBg4"),
    [5] = UI.getChildControl(PaGlobal_Recommend_PopUp._ui._mainBG, "Static_TempBg5")
  }
  self._ui._goodsImage = {
    [0] = UI.getChildControl(self._ui._goodsBG[0], "Static_BannerImage"),
    [1] = UI.getChildControl(self._ui._goodsBG[1], "Static_BannerImage"),
    [2] = UI.getChildControl(self._ui._goodsBG[2], "Static_BannerImage"),
    [3] = UI.getChildControl(self._ui._goodsBG[3], "Static_BannerImage"),
    [4] = UI.getChildControl(self._ui._goodsBG[4], "Static_BannerImage"),
    [5] = UI.getChildControl(self._ui._goodsBG[5], "Static_BannerImage")
  }
  self._ui._goodsName = {
    [0] = UI.getChildControl(self._ui._goodsBG[0], "StaticText_GoodsName"),
    [1] = UI.getChildControl(self._ui._goodsBG[1], "StaticText_GoodsName"),
    [2] = UI.getChildControl(self._ui._goodsBG[2], "StaticText_GoodsName"),
    [3] = UI.getChildControl(self._ui._goodsBG[3], "StaticText_GoodsName"),
    [4] = UI.getChildControl(self._ui._goodsBG[4], "StaticText_GoodsName"),
    [5] = UI.getChildControl(self._ui._goodsBG[5], "StaticText_GoodsName")
  }
  self._ui._goodsPrice = {
    [0] = UI.getChildControl(self._ui._goodsBG[0], "StaticText_Price"),
    [1] = UI.getChildControl(self._ui._goodsBG[1], "StaticText_Price"),
    [2] = UI.getChildControl(self._ui._goodsBG[2], "StaticText_Price"),
    [3] = UI.getChildControl(self._ui._goodsBG[3], "StaticText_Price"),
    [4] = UI.getChildControl(self._ui._goodsBG[4], "StaticText_Price"),
    [5] = UI.getChildControl(self._ui._goodsBG[5], "StaticText_Price")
  }
  self._ui._radioBtn = {
    [0] = UI.getChildControl(self._ui._mainBG, "RadioButton_TempPage0"),
    [1] = UI.getChildControl(self._ui._mainBG, "RadioButton_TempPage1"),
    [2] = UI.getChildControl(self._ui._mainBG, "RadioButton_TempPage2"),
    [3] = UI.getChildControl(self._ui._mainBG, "RadioButton_TempPage3")
  }
  self._ui._close:addInputEvent("Mouse_LUp", "PaGlobal_Recommend_PopUp:Close()")
  self._ui._btn_Left:addInputEvent("Mouse_LUp", "PaGlobal_Recommend_PopUp:Click_Slide(true)")
  self._ui._btn_Right:addInputEvent("Mouse_LUp", "PaGlobal_Recommend_PopUp:Click_Slide(false)")
  self._ui._mainBG:addInputEvent("Mouse_UpScroll", "PaGlobal_Recommend_PopUp:Click_Slide(true)")
  self._ui._mainBG:addInputEvent("Mouse_DownScroll", "PaGlobal_Recommend_PopUp:Click_Slide(false)")
  for ii = 0, 5 do
    self._ui._goodsBG[ii]:addInputEvent("Mouse_UpScroll", "PaGlobal_Recommend_PopUp:Click_Slide(true)")
    self._ui._goodsBG[ii]:addInputEvent("Mouse_DownScroll", "PaGlobal_Recommend_PopUp:Click_Slide(false)")
    self._ui._goodsName[ii]:SetIgnore(true)
    self._ui._goodsImage[ii]:SetIgnore(true)
    self._ui._goodsPrice[ii]:SetIgnore(true)
  end
  self._ui._chk_TodayNoShow:addInputEvent("Mouse_LUp", "PaGlobal_Recommend_PopUp_Check_NoShowToday()")
  self._ui._chk_TodayNoShow:SetEnableArea(0, 0, self._ui._chk_TodayNoShow:GetSizeX() + self._ui._chk_TodayNoShow:GetTextSizeX() + 10, self._ui._chk_TodayNoShow:GetSizeY())
end
function PaGlobal_Recommend_PopUp_Check_NoShowToday()
  local _year = ToClient_GetThisYear()
  local _month = ToClient_GetThisMonth()
  local _day = ToClient_GetToday()
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListTime(__eInGameCashShopGoodsPopUp, _year, _month, _day, 0, 0, 0, CppEnums.VariableStorageType.eVariableStorageType_User)
  Panel_Window_RecommandGoods_PopUp:SetShow(false, true)
end
function PaGlobal_Recommend_PopUp:Clear()
  for ii = 0, 5 do
    self._ui._goodsBG[ii]:SetShow(false)
  end
  self._maxPage = 0
  self._currentPage = 0
end
function PaGlobal_Recommend_PopUp:Open()
  if false == _ContentsGroup_Recommend then
    return
  end
  local _year = ToClient_GetThisYear()
  local _month = ToClient_GetThisMonth()
  local _day = ToClient_GetToday()
  local dayCheck = ToClient_getGameUIManagerWrapper():getLuaCacheDataListTime(__eInGameCashShopGoodsPopUp)
  local self = PaGlobal_Recommend_PopUp
  if nil ~= dayCheck then
    local savedYear = dayCheck:GetYear()
    local savedMonth = dayCheck:GetMonth()
    local savedDay = dayCheck:GetDay()
    if _year == savedYear and _month == savedMonth and _day == savedDay and nil == isLevelUp then
      return
    end
  end
  self:Clear()
  if false == self:Update() then
    return
  end
  Panel_Window_RecommandGoods_PopUp:SetPosX(getScreenSizeX() / 2 - Panel_Window_RecommandGoods_PopUp:GetSizeX() / 2)
  Panel_Window_RecommandGoods_PopUp:SetPosY(getScreenSizeY() / 2 - Panel_Window_RecommandGoods_PopUp:GetSizeY() / 2)
  Panel_Window_RecommandGoods_PopUp:SetShow(true)
  self._isRequestShow = false
end
function PaGlobal_Recommend_PopUp:Update()
  local uiRow = 0
  local size = ToClient_getCashBuyRecommendList()
  if 0 == size then
    return false
  end
  self._maxPage = math.floor(size / 6)
  if self._CONST_MAX_PAGE_SIZE - 1 < self._maxPage then
    self._maxPage = self._CONST_MAX_PAGE_SIZE - 1
  end
  local loopStart = self._currentPage * 6
  local loopEnd = loopStart + 5
  if loopEnd > self._maxPage then
  end
  for ii = loopStart, loopEnd do
    local productNo = ToClient_getRecommendBuyCashProductNoByIndex(ii)
    local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNo)
    if nil ~= cashProduct then
      self._ui._goodsBG[uiRow]:SetShow(true)
      self._ui._goodsName[uiRow]:SetTextMode(UI_TM.eTextMode_AutoWrap)
      self._ui._goodsName[uiRow]:SetText(tostring(cashProduct:getName()))
      self._ui._goodsPrice[uiRow]:SetText(tostring(cashProduct:getPrice()))
      self._ui._goodsImage[uiRow]:ChangeTextureInfoName(cashProduct:getPackageIcon())
      self._ui._goodsBG[uiRow]:addInputEvent("Mouse_LUp", "PaGlobal_RecommendGoods:GoToProduct(" .. productNo .. "," .. "2" .. ")")
      self._ui._goodsImage[uiRow]:addInputEvent("Mouse_LUp", "PaGlobal_RecommendGoods:GoToProduct(" .. productNo .. "," .. "2" .. ")")
      uiRow = uiRow + 1
    end
  end
  if 0 == self._currentPage then
    self._ui._btn_Left:SetShow(false)
  else
    self._ui._btn_Left:SetShow(true)
  end
  if self._maxPage <= self._currentPage then
    self._ui._btn_Right:SetShow(false)
  else
    self._ui._btn_Right:SetShow(true)
  end
  for ii = 0, self._maxPage do
    local jj = self._maxPage - ii
    self._ui._radioBtn[ii]:SetShow(true)
    self._ui._radioBtn[ii]:addInputEvent("Mouse_LUp", "PaGlobal_Recommend_PopUp:Click_Radio(" .. jj .. ")")
    self._ui._radioBtn[ii]:SetCheck(false)
  end
  self._ui._radioBtn[self._maxPage - self._currentPage]:SetCheck(true)
  return true
end
function PaGlobal_Recommend_PopUp:Close()
  Panel_Window_RecommandGoods_PopUp:SetShow(false)
end
function PaGlobal_Recommend_PopUp:Clear_OnlyProduct()
  for ii = 0, 5 do
    self._ui._goodsBG[ii]:SetShow(false)
  end
end
function PaGlobal_Recommend_PopUp:Click_Slide(isLeft)
  if true == isLeft then
    self._currentPage = math.max(0, self._currentPage - 1)
  else
    self._currentPage = math.min(self._currentPage + 1, self._maxPage)
  end
  self:Clear_OnlyProduct()
  self:Update()
end
function PaGlobal_Recommend_PopUp:Click_Radio(value)
  self._currentPage = value
  self:Clear_OnlyProduct()
  self:Update()
end
PaGlobal_Recommend_PopUp:Initialize()

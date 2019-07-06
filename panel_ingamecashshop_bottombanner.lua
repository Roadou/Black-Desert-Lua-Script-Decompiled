Panel_Ingamecashshop_BottomBanner:SetShow(false)
local PaGlobal_BottomBanner = {
  _ui = {
    _stc_IngameBanner = UI.getChildControl(Panel_Ingamecashshop_BottomBanner, "Static_BannerArea")
  },
  _web = nil,
  _luaLoadAfterTime = 0,
  _savedCheck = false,
  _isNotControlWeb = true
}
function IngameCashshop_BottomBanner_ShowAni()
  local ImageMoveAni = Panel_Ingamecashshop_BottomBanner:addMoveAnimation(2, 2.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni:SetStartPosition(getScreenSizeX() - Panel_Ingamecashshop_BottomBanner:GetSizeX() - 10, getScreenSizeY() - 10)
  ImageMoveAni:SetEndPosition(getScreenSizeX() - Panel_Ingamecashshop_BottomBanner:GetSizeX() - 10, getScreenSizeY() - Panel_Ingamecashshop_BottomBanner:GetSizeY() - 10)
  ImageMoveAni.IsChangeChild = true
  Panel_Ingamecashshop_BottomBanner:CalcUIAniPos(ImageMoveAni)
  ImageMoveAni:SetDisableWhileAni(true)
end
function IngameCashshop_BottomBanner_HideAni()
  local ImageMoveAni = Panel_Ingamecashshop_BottomBanner:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni:SetStartPosition(getScreenSizeX() - Panel_Ingamecashshop_BottomBanner:GetSizeX() - 10, getScreenSizeY() - Panel_Ingamecashshop_BottomBanner:GetSizeY() - 10)
  ImageMoveAni:SetEndPosition(getScreenSizeX() - Panel_Ingamecashshop_BottomBanner:GetSizeX() + 10, getScreenSizeY() + 10)
  ImageMoveAni.IsChangeChild = true
  Panel_Ingamecashshop_BottomBanner:CalcUIAniPos(ImageMoveAni)
  ImageMoveAni:SetDisableWhileAni(true)
  ImageMoveAni:SetHideAtEnd(false)
end
function PaGlobal_BottomBanner:Init()
  Panel_Ingamecashshop_BottomBanner:RegisterShowEventFunc(true, "IngameCashshop_BottomBanner_ShowAni()")
  Panel_Ingamecashshop_BottomBanner:RegisterShowEventFunc(false, "IngameCashshop_BottomBanner_HideAni()")
  self._ui._txt_todayNoShow = UI.getChildControl(self._ui._stc_IngameBanner, "StaticText_TodayNoShow")
  Panel_Ingamecashshop_BottomBanner:SetSpanSize(-400, -400)
  if ToClient_IsDevelopment() then
    self._isNotControlWeb = true
  end
  _web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Ingamecashshop_BottomBanner, "Web_Ingamecashshop_BottomBanner")
  _web:SetSize(323, 242)
  _web:SetPosX(0)
  _web:SetPosY(0)
  _web:SetShow(false == self._isNotControlWeb)
  self._ui._stc_IngameBanner:SetShow(self._isNotControlWeb)
  self._ui._stc_IngameBanner:addInputEvent("Mouse_LUp", "PaGlobal_HandleClicked_BloodAltar_Open()")
  self._ui._txt_todayNoShow:SetShow(self._isNotControlWeb)
  self._ui._txt_todayNoShow:addInputEvent("Mouse_LUp", "PaGlobal_BottomBanner_CheckForDay()")
end
function PaGlobal_BottomBanner:Open()
  local _selfPlayer = getSelfPlayer()
  if nil == _selfPlayer then
    return
  end
  local _myLevel = _selfPlayer:get():getLevel()
  if _myLevel < 20 then
    return
  end
  if false == _ContentsGroup_Altar then
    return
  end
  Panel_Ingamecashshop_BottomBanner:SetShow(true, true)
  local url = "http://dev-cashshop.pearlabyss.com/CashShop/Banner/BottomBanner"
  if isGameTypeKorea() then
    url = "http://dev-cashshop.pearlabyss.com/CashShop/Banner/BottomBanner"
  elseif CppEnums.CountryType.TW_ALPHA == getGameServiceType() then
    url = "http://game-portal-qa.blackdesert.com.tw/CashShop/Banner/BottomBanner"
  elseif CppEnums.CountryType.TW_REAL == getGameServiceType() then
    url = "https://game-portal.blackdesert.com.tw/CashShop/Banner/BottomBanner"
  elseif CppEnums.CountryType.TR_ALPHA == getGameServiceType() then
    url = "http://game-portal-qa.tr.playblackdesert.com/CashShop/Banner/BottomBanner"
  elseif CppEnums.CountryType.TR_REAL == getGameServiceType() then
    url = "https://game-portal.tr.playblackdesert.com/CashShop/Banner/BottomBanner"
  elseif CppEnums.CountryType.TH_ALPHA == getGameServiceType() then
    url = "http://game-portal-qa.th.playblackdesert.com/CashShop/Banner/BottomBanner"
  elseif CppEnums.CountryType.TH_REAL == getGameServiceType() then
    url = "https://game-portal.th.playblackdesert.com/CashShop/Banner/BottomBanner"
  elseif CppEnums.CountryType.ID_ALPHA == getGameServiceType() then
    url = "http://game-portal-qa.sea.playblackdesert.com/CashShop/Banner/BottomBanner"
  elseif CppEnums.CountryType.ID_REAL == getGameServiceType() then
    url = "https://game-portal.sea.playblackdesert.com/CashShop/Banner/BottomBanner"
  elseif CppEnums.CountryType.RUS_ALPHA == getGameServiceType() then
    url = "http://game-portal-qa.ru.playblackdesert.com/CashShop/Banner/BottomBanner"
  elseif CppEnums.CountryType.RUS_REAL == getGameServiceType() then
    url = "https://game-portal.ru.playblackdesert.com/CashShop/Banner/BottomBanner"
  else
    url = "http://dev-cashshop.pearlabyss.com/CashShop/Banner/BottomBanner"
  end
  if false == self._isNotControlWeb then
    _web:SetUrl(323, 242, url, false, true)
  end
end
function PaGlobal_BottomBanner_Open()
  local _year = ToClient_GetThisYear()
  local _month = ToClient_GetThisMonth()
  local _day = ToClient_GetToday()
  local dayCheck = ToClient_getGameUIManagerWrapper():getLuaCacheDataListTime(__eBottomIngamecashshopBanner)
  local self = PaGlobal_BottomBanner
  if false == _ContentsGroup_Altar then
    return
  end
  if nil ~= dayCheck then
    local savedYear = dayCheck:GetYear()
    local savedMonth = dayCheck:GetMonth()
    local savedDay = dayCheck:GetDay()
    if _year == savedYear and _month == savedMonth and _day == savedDay and nil == isLevelUp then
      return
    end
  end
  self._luaLoadAfterTime = 0
  self._savedCheck = true
  Panel_Ingamecashshop_BottomBanner:RegisterUpdateFunc("PaGlobal_BottomBanner_PerFrame")
  PaGlobal_BottomBanner:Open()
end
function PaGlobal_BottomBanner_EnterMarni()
  local enterMarni = function()
    if false == IsSelfPlayerWaitAction() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_WAITACTION_ALERT"))
      return
    end
    PaGlobal_HandleClicked_BloodAltar_Open()
  end
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_BATTLEROYAL_ENTERANCE")
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_BATTLEROYAL_ENTERANCE_DESC")
  local messageBoxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = enterMarni,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_BottomBanner_PerFrame(deltaTime)
  local self = PaGlobal_BottomBanner
  self._luaLoadAfterTime = self._luaLoadAfterTime + deltaTime
  if Panel_Ingamecashshop_BottomBanner:IsShow() and self._luaLoadAfterTime > 8 and true == self._savedCheck then
    IngameCashshop_BottomBanner_HideAni()
    self._savedCheck = false
  end
  if self._luaLoadAfterTime >= 10.5 and self._luaLoadAfterTime <= 11 then
    PaGlobal_BottomBanner_ResetURL()
    Panel_Ingamecashshop_BottomBanner:ClearUpdateLuaFunc()
    PaGlobal_BottomBanner_Close()
  end
end
function PaGlobal_BottomBanner:Close()
  Panel_Ingamecashshop_BottomBanner:SetShow(false, false)
end
function PaGlobal_BottomBanner_Close()
  PaGlobal_BottomBanner:Close()
end
function PaGlobal_BottomBanner_ResetURL()
  if false == self._isNotControlWeb then
    _web:ResetUrl()
  end
end
function PaGlobal_BottomBanner_CheckForDay()
  local _year = ToClient_GetThisYear()
  local _month = ToClient_GetThisMonth()
  local _day = ToClient_GetToday()
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListTime(__eBottomIngamecashshopBanner, _year, _month, _day, 0, 0, 0, CppEnums.VariableStorageType.eVariableStorageType_User)
  Panel_Ingamecashshop_BottomBanner:SetShow(false, true)
end
function PaGlobal_BottomBanner_FromClient_luaLoadComplete()
  PaGlobal_BottomBanner:Init()
  PaGlobal_BottomBanner_Open()
end
function PaGlobal_BottomBanner:RegisterEvent()
  registerEvent("FromClient_luaLoadComplete", "PaGlobal_BottomBanner_FromClient_luaLoadComplete")
end
PaGlobal_BottomBanner:RegisterEvent()

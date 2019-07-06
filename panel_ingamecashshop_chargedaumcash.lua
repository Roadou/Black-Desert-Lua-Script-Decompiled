local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local preUIMode = Defines.UIMode.eUIMode_InGameCashShop
local UI_SERVICE_RESOURCE = CppEnums.ServiceResourceType
Panel_IngameCashShop_ChargeDaumCash:SetShow(false)
Panel_IngameCashShop_ChargeDaumCash:setGlassBackground(true)
Panel_IngameCashShop_ChargeDaumCash:ActiveMouseEventEffect(true)
local termsofDaumCash = {
  panelTitle = UI.getChildControl(Panel_IngameCashShop_ChargeDaumCash, "StaticText_Title")
}
local eCountryType = CppEnums.CountryType
local gameServiceType = getGameServiceType()
local isKorea = eCountryType.NONE == gameServiceType or eCountryType.DEV == gameServiceType or eCountryType.KOR_ALPHA == gameServiceType or eCountryType.KOR_REAL == gameServiceType or eCountryType.KOR_TEST == gameServiceType
local isNaver = CppEnums.MembershipType.naver == getMembershipType()
Panel_IngameCashShop_ChargeDaumCash:RegisterShowEventFunc(true, "Panel_IngameCashShop_ChargeDaumCash_ShowAni()")
Panel_IngameCashShop_ChargeDaumCash:RegisterShowEventFunc(false, "Panel_IngameCashShop_ChargeDaumCash_HideAni()")
function Panel_IngameCashShop_ChargeDaumCash_ShowAni()
  UIAni.fadeInSCR_Down(Panel_IngameCashShop_ChargeDaumCash)
  local aniInfo1 = Panel_IngameCashShop_ChargeDaumCash:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_IngameCashShop_ChargeDaumCash:GetSizeX() / 2
  aniInfo1.AxisY = Panel_IngameCashShop_ChargeDaumCash:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_IngameCashShop_ChargeDaumCash:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_IngameCashShop_ChargeDaumCash:GetSizeX() / 2
  aniInfo2.AxisY = Panel_IngameCashShop_ChargeDaumCash:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_IngameCashShop_ChargeDaumCash_HideAni()
  Panel_IngameCashShop_ChargeDaumCash:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_IngameCashShop_ChargeDaumCash, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local _btn_Close = UI.getChildControl(Panel_IngameCashShop_ChargeDaumCash, "Button_Close")
local _Web
function Panel_IngameCashShop_ChargeDaumCash_Initialize()
  local self = termsofDaumCash
  _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_IngameCashShop_ChargeDaumCash, "WebControl_ChargeDaumCash_WebLink")
  _Web:SetShow(true)
  _Web:SetPosX(43)
  _Web:SetPosY(63)
  _Web:SetSize(917, 586)
  _Web:ResetUrl()
  self.panelTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_PANELTITLE"))
  if isGameTypeTR() then
    self.panelTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INGAMECASHSHOP_TERMSOFDAUMCASH_TITLE_TR"))
  elseif isGameTypeTH() then
    self.panelTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INGAMECASHSHOP_TERMSOFDAUMCASH_TITLE_TH"))
  elseif isGameTypeID() then
    self.panelTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INGAMECASHSHOP_TERMSOFDAUMCASH_TITLE_ID"))
  end
end
Panel_IngameCashShop_ChargeDaumCash_Initialize()
local preScreenMode = 0
function chargeDaumCash_Open()
  local self = termsofDaumCash
  local url
  local langType = "EN"
  local SALangType = "PT"
  if UI_SERVICE_RESOURCE.eServiceResourceType_EN == getGameServiceResType() then
    langType = "EN"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_FR == getGameServiceResType() then
    langType = "FR"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_DE == getGameServiceResType() then
    langType = "DE"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_TR == getGameServiceResType() then
    langType = "TR"
  end
  if UI_SERVICE_RESOURCE.eServiceResourceType_ES == getGameServiceResType() then
    SALangType = "es"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_PT == getGameServiceResType() then
    SALangType = "pt"
  end
  preScreenMode = ToClient_getGameOptionControllerWrapper():getScreenMode()
  if isGameServiceTypeKorReal() then
    if isNaver then
      url = "http://black.game.naver.com/black/billing/shop/index.daum"
    else
      url = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_URL1")
    end
  elseif CppEnums.GameServiceType.eGameServiceType_DEV == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_URL2")
  elseif isGameTypeEnglish() then
    if isSteamClient() then
      if not isSteamInGameOverlayEnabled() then
        local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STEAM_ALERT")
        local messageBoxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
          content = messageBoxMemo,
          functionYes = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageBoxData)
        return
      end
      ToClient_requestCashChargeAuthSessionTicket()
      local ticket = getSteamAuthSessionTicket()
      url = "https://www.blackdesertonline.com/steam/DaumCash.html?appId=582660&steamTicket=" .. ticket .. "&lang=" .. langType
      steamOverlayToWebPage(url)
      return
    elseif CppEnums.GameServiceType.eGameServiceType_NA_ALPHA == getGameServiceType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_NA_TEST", "langType", langType)
    elseif CppEnums.GameServiceType.eGameServiceType_NA_REAL == getGameServiceType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_NA_REAL", "langType", langType)
    end
  elseif CppEnums.CountryType.TW_ALPHA == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_TW_TEST")
  elseif CppEnums.CountryType.TW_REAL == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_TW_REAL")
  elseif isGameTypeSA() then
    local ticket = ToClient_GetAuthToken()
    local isUserID = ToClient_GetUserId()
    url = "https://blackdesert.playredfox.com/black_desert/shop?i=" .. isUserID .. "&t=" .. ticket .. "&locale=" .. SALangType
    ToClient_OpenChargeWebPage(url, false)
    return
  elseif CppEnums.CountryType.TR_ALPHA == getGameServiceType() then
    if isSteamClient() then
      if not isSteamInGameOverlayEnabled() then
        local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STEAM_ALERT")
        local messageBoxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
          content = messageBoxMemo,
          functionYes = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageBoxData)
        return
      end
      ToClient_requestCashChargeAuthSessionTicket()
      local isUserID = ToClient_GetUserId()
      local ticket = getSteamAuthSessionTicket()
      url = "http://alpha-payment.tr.playblackdesert.com/Pay/Steam?accountNo=" .. isUserID .. "&sessionTicket=" .. ticket .. "&lang=" .. langType
      steamOverlayToWebPage(url)
      return
    else
      local userID = ToClient_GetUserId()
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_TR_TEST", "userid", userID)
    end
  elseif CppEnums.CountryType.TR_REAL == getGameServiceType() then
    if isSteamClient() then
      if not isSteamInGameOverlayEnabled() then
        local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STEAM_ALERT")
        local messageBoxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
          content = messageBoxMemo,
          functionYes = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageBoxData)
        return
      end
      ToClient_requestCashChargeAuthSessionTicket()
      local userID = ToClient_GetUserId()
      local ticket = getSteamAuthSessionTicket()
      url = "http://payment.tr.playblackdesert.com/Pay/Steam?accountNo=" .. userID .. "&sessionTicket=" .. ticket .. "&lang=" .. langType
      steamOverlayToWebPage(url)
      return
    else
      local userID = ToClient_GetUserId()
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_TR_REAL", "userid", userID)
    end
  elseif CppEnums.CountryType.TH_ALPHA == getGameServiceType() then
    local userID = ToClient_GetUserId()
    url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_TH_TEST", "userid", userID)
  elseif CppEnums.CountryType.TH_REAL == getGameServiceType() then
    local userID = ToClient_GetUserId()
    url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_TH_REAL", "userid", userID)
  elseif CppEnums.CountryType.ID_ALPHA == getGameServiceType() then
    local userID = ToClient_GetUserId()
    url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_ID_TEST", "userid", userID)
  elseif CppEnums.CountryType.ID_REAL == getGameServiceType() then
    local userID = ToClient_GetUserId()
    url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_ID_REAL", "userid", userID)
  elseif isGameTypeJapan() then
    local userID = ToClient_GetUserId()
    url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEPMANGCASH_URL_URL", "userid", userID)
  elseif CppEnums.CountryType.RUS_ALPHA == getGameServiceType() then
    local userID = ToClient_GetUserId()
    url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEPMANGCASH_URL_RU_TEST", "userid", userID)
  elseif CppEnums.CountryType.RUS_REAL == getGameServiceType() then
    local userID = ToClient_GetUserId()
    url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEPMANGCASH_URL_RU_REAL", "userid", userID)
  else
    url = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_URL2")
  end
  ToClient_OpenChargeWebPage(url, false)
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_NOTIFY_CHARGEDAUMCASH")
  if isGameTypeTR() then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_NOTIFY_CHARGEDAUMCASH_TR")
  elseif isGameTypeTH() then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_NOTIFY_CHARGEDAUMCASH_TH")
  elseif isGameTypeID() then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_NOTIFY_CHARGEDAUMCASH_ID")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = IngameCashShop_ChargeComplete,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function IngameCashShop_ChargeComplete()
  ToClient_ChargeComplete()
  InGameShop_RefreshCash()
  if 0 == preScreenMode then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_CHANGESCREENMODE_FULL")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
      content = messageBoxMemo,
      functionYes = ToClient_ChangePreScreenMode,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function chargeDaumCash_Close()
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
  Panel_IngameCashShop_ChargeDaumCash:SetShow(false, false)
end
function HandleClicked_ChargeDaumCash_Close()
  if not isNaver then
    cashShop_requestCash()
  end
  chargeDaumCash_Close()
end
function FGlobal_BuyDaumCash()
  chargeDaumCash_Open()
end
function FromClient_NeedPublishCash()
  local messageboxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_NEEDPUBLISHCASH")
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYPEARLBOX_CONFIRM"),
    content = messageboxMemo,
    functionYes = FGlobal_BuyDaumCash,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function FromClient_SteamCashChargeAuthTicketReady()
  local url
  local langType = "EN"
  if UI_SERVICE_RESOURCE.eServiceResourceType_EN == getGameServiceResType() then
    langType = "EN"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_FR == getGameServiceResType() then
    langType = "FR"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_DE == getGameServiceResType() then
    langType = "DE"
  end
  local ticket = getSteamAuthSessionTicket()
  url = "https://www.blackdesertonline.com/steam/DaumCash.html?appId=582660&steamTicket=" .. ticket .. "&lang=" .. langType
  steamOverlayToWebPage(url)
end
_btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_ChargeDaumCash_Close()")
registerEvent("FromClient_NeedPublishCash", "FromClient_NeedPublishCash")
registerEvent("FromClient_SteamCashChargeAuthTicketReady", "FromClient_SteamCashChargeAuthTicketReady")

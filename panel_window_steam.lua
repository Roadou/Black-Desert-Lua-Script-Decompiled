local UI_SERVICE_RESOURCE = CppEnums.ServiceResourceType
function PaGlobal_Steam_Redemption()
  local url
  local langType = "EN"
  if UI_SERVICE_RESOURCE.eServiceResourceType_EN == getGameServiceResType() then
    langType = "EN"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_FR == getGameServiceResType() then
    langType = "FR"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_DE == getGameServiceResType() then
    langType = "DE"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_ES == getGameServiceResType() then
    langType = "es"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_PT == getGameServiceResType() then
    langType = "pt"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_TR == getGameServiceResType() then
    langType = "TR"
  end
  if isSteamClient() and not isSteamInGameOverlayEnabled() then
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
  if isGameTypeEnglish() then
    if isSteamClient() then
      ToClient_requestRedeemAuthSessionTicket()
      local ticket = getSteamAuthSessionTicket()
      url = "https://www.blackdesertonline.com/steam/UserInfo.html?appId=582660&steamTicket=" .. ticket .. "&lang=" .. langType
      steamOverlayToWebPage(url)
      return
    else
      url = "https://www.blackdesertonline.com/myinfo/"
      ToClient_OpenChargeWebPage(url, false)
      return
    end
  elseif isGameTypeSA() then
    local ticket = ToClient_GetAuthToken()
    local isUserID = ToClient_GetUserId()
    url = "https://blackdesert.playredfox.com/black_desert/myaccount?i=" .. isUserID .. "&t=" .. ticket .. "&locale=" .. langType
    ToClient_OpenChargeWebPage(url, false)
    return
  elseif isGameTypeTR() and isSteamClient() then
    ToClient_requestRedeemAuthSessionTicket()
    local userID = ToClient_GetUserId()
    local userNo = getUserNoByLobby()
    local ticket = getSteamAuthSessionTicket()
    if CppEnums.CountryType.TR_REAL == getGameServiceType() then
      url = "https://payment.tr.playblackdesert.com/Pay/Steam/WebStorage?accountNo=" .. userID .. "&userNo=" .. tostring(userNo) .. "&sessionTicket=" .. ticket .. "&lang=" .. langType
    else
      url = "http://alpha-payment.tr.playblackdesert.com/Pay/Steam/WebStorage?accountNo=" .. userID .. "&userNo=" .. tostring(userNo) .. "&sessionTicket=" .. ticket .. "&lang=" .. langType
    end
    steamOverlayToWebPage(url)
  end
end
function FromClient_SteamRedeemAuthTicketReady()
  local url
  local langType = "EN"
  if UI_SERVICE_RESOURCE.eServiceResourceType_EN == getGameServiceResType() then
    langType = "EN"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_FR == getGameServiceResType() then
    langType = "FR"
  elseif UI_SERVICE_RESOURCE.eServiceResourceType_DE == getGameServiceResType() then
    langType = "DE"
  end
  if isGameTypeEnglish() then
    local ticket = getSteamAuthSessionTicket()
    url = "https://www.blackdesertonline.com/steam/UserInfo.html?appId=582660&steamTicket=" .. ticket .. "&lang=" .. langType
    steamOverlayToWebPage(url)
  end
end
registerEvent("FromClient_SteamRedeemAuthTicketReady", "FromClient_SteamRedeemAuthTicketReady")

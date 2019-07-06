Panel_Twitch:SetShow(false)
PaGlobal_Twitch = {
  _ui = {
    _btnClose = UI.getChildControl(Panel_Twitch, "Button_Win_Close"),
    _checkPopUp = UI.getChildControl(Panel_Twitch, "CheckButton_PopUp")
  },
  isPopUpContentsEnable = ToClient_IsContentsGroupOpen("240")
}
function PaGlobal_Twitch:Init()
  self._ui._btnClose:addInputEvent("Mouse_LUp", "PaGlobal_Twitch:CloseWindow()")
  self._ui._checkPopUp:SetShow(false)
end
function PaGlobal_Twitch:ShowWindow()
  Panel_Twitch:SetShow(false)
  Panel_Twitch:SetPosX(getScreenSizeX() / 2 - Panel_Twitch:GetSizeX() / 2)
  Panel_Twitch:SetPosY(getScreenSizeY() / 2 - Panel_Twitch:GetSizeY() / 2)
  local twitchUrlReturn = PaGlobal_Twitch:TwitchUrlReturn()
  if nil ~= twitchUrlReturn then
    ToClient_OpenChargeWebPage(twitchUrlReturn, false)
  end
end
function PaGlobal_Twitch:CloseWindow()
  Panel_Twitch:SetShow(false, false)
end
function PaGlobal_Twitch:TwitchUrlReturn()
  local isNationType = "kr"
  if isGameTypeKorea() then
    isNationType = "kr"
  elseif isGameTypeJapan() then
    isNationType = "jp"
  elseif isGameTypeRussia() then
    isNationType = "ru"
  elseif isGameTypeEnglish() then
    if CppEnums.ServiceResourceType.eServiceResourceType_EN == ToClient_getResourceType() then
      isNationType = "en"
    elseif CppEnums.ServiceResourceType.eServiceResourceType_FR == ToClient_getResourceType() then
      isNationType = "fr"
    elseif CppEnums.ServiceResourceType.eServiceResourceType_DE == ToClient_getResourceType() then
      isNationType = "de"
    else
      isNationType = "en"
    end
  elseif isGameTypeTaiwan() then
    isNationType = "tw"
  elseif isGameTypeSA() then
    if CppEnums.ServiceResourceType.eServiceResourceType_ES == ToClient_getResourceType() then
      isNationType = "es"
    elseif CppEnums.ServiceResourceType.eServiceResourceType_PT == ToClient_getResourceType() then
      isNationType = "pt"
    else
      isNationType = "pt"
    end
  elseif isGameTypeTR() then
    isNationType = "tr"
  elseif isGameTypeTH() then
    isNationType = "th"
  elseif isGameTypeID() then
    isNationType = "id"
  else
    _PA_LOG("\236\160\149\237\131\156\234\179\164", "\236\131\136\235\161\156\236\154\180 \234\181\173\234\176\128 \237\131\128\236\158\133\236\157\180 \236\182\148\234\176\128\235\144\152\236\151\136\236\156\188\235\139\136 \236\157\180 \235\161\156\234\183\184\235\165\188 \235\176\156\234\178\172\237\149\152\235\169\180 \237\149\180\235\139\185 \235\139\180\235\139\185\236\158\144\236\151\144\234\178\140 \236\149\140\235\160\164\236\163\188\236\132\184\236\154\148 \234\188\173!!!")
    isNationType = "kr"
  end
  local url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TWITCH_DOMAIN_LINK", "nation", isNationType)
  return url
end
PaGlobal_Twitch:Init()

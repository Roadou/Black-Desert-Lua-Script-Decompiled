local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local preUIMode = Defines.UIMode.eUIMode_InGameCashShop
Panel_TermsofGameUse:SetShow(false, false)
Panel_TermsofGameUse:ActiveMouseEventEffect(true)
Panel_TermsofGameUse:setGlassBackground(true)
Panel_TermsofGameUse:RegisterShowEventFunc(true, "Panel_TermsofGameUse_ShowAni()")
Panel_TermsofGameUse:RegisterShowEventFunc(false, "Panel_TermsofGameUse_HideAni()")
function Panel_TermsofGameUse_ShowAni()
  UIAni.fadeInSCR_Down(Panel_TermsofGameUse)
  local aniInfo1 = Panel_TermsofGameUse:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_TermsofGameUse:GetSizeX() / 2
  aniInfo1.AxisY = Panel_TermsofGameUse:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_TermsofGameUse:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_TermsofGameUse:GetSizeX() / 2
  aniInfo2.AxisY = Panel_TermsofGameUse:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_TermsofGameUse_HideAni()
  Panel_TermsofGameUse:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_TermsofGameUse, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local _btn_Close = UI.getChildControl(Panel_TermsofGameUse, "Button_Close")
local _btn_Agree = UI.getChildControl(Panel_TermsofGameUse, "Button_Agree")
local _Web
function Panel_TermsofGameUse_Initialize()
  _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_TermsofGameUse, "WebControl_TermsofGameUse_WebLink")
  _Web:SetShow(true)
  _Web:SetPosX(19)
  _Web:SetPosY(78)
  _Web:SetSize(900, 586)
  _Web:ResetUrl()
end
Panel_TermsofGameUse_Initialize()
function FGlobal_TermsofGameUse_Open()
  local isTermsString = PAGetString(Defines.StringSheet_GAME, "LUA_TERMSOFGAMEUSE_URL_TW")
  if isGameTypeKorea() then
    if CppEnums.CountryType.KOR_ALPHA == getGameServiceType() then
      isTermsString = PAGetString(Defines.StringSheet_GAME, "LUA_TERMSOFGAMEUSE_DEV_URL")
    elseif CppEnums.CountryType.KOR_REAL == getGameServiceType() then
      isTermsString = PAGetString(Defines.StringSheet_GAME, "LUA_TERMSOFGAMEUSE_URL")
    end
  elseif isGameTypeTaiwan() then
    if CppEnums.CountryType.TW_ALPHA == getGameServiceType() then
      isTermsString = PAGetString(Defines.StringSheet_GAME, "LUA_TERMSOFGAMEUSE_URL_TW_ALPHA")
    elseif CppEnums.CountryType.TW_REAL == getGameServiceType() then
      isTermsString = PAGetString(Defines.StringSheet_GAME, "LUA_TERMSOFGAMEUSE_URL_TW")
    end
  elseif isGameTypeGT() then
    isTermsString = "https://game-portal.global-lab.playblackdesert.com/Policy/"
  elseif CppEnums.CountryType.RUS_ALPHA == getGameServiceType() then
    isTermsString = PAGetString(Defines.StringSheet_GAME, "LUA_TERMSOFGAMEUSE_URL_RUS_ALPHA")
  elseif CppEnums.CountryType.RUS_REAL == getGameServiceType() then
    isTermsString = PAGetString(Defines.StringSheet_GAME, "LUA_TERMSOFGAMEUSE_URL_RUS")
  else
    isTermsString = PAGetString(Defines.StringSheet_GAME, "LUA_TERMSOFGAMEUSE_URL")
  end
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  Panel_TermsofGameUse:SetShow(true, true)
  _Web:SetUrl(900, 586, isTermsString, false, false)
end
function TermsofGameUse_Close()
  _Web:ResetUrl()
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
  Panel_TermsofGameUse:SetShow(false, false)
end
function HandleClicked_TermsofGameUse_Close()
  TermsofGameUse_Close()
end
function HandleClicked_TermsofGameUse_Next()
  TermsofGameUse_Close()
  FGlobal_Panel_Login_Enter()
end
function FGlobal_HandleClicked_TermsofGameUse_Next()
  HandleClicked_TermsofGameUse_Next()
end
function FGlobal_TermsofGameUse_Close()
  TermsofGameUse_Close()
end
_btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_TermsofGameUse_Close()")
_btn_Agree:addInputEvent("Mouse_LUp", "HandleClicked_TermsofGameUse_Next()")

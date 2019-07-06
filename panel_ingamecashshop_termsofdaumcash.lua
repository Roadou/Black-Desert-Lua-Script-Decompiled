local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local preUIMode = Defines.UIMode.eUIMode_InGameCashShop
Panel_IngameCashShop_TermsofDaumCash:SetShow(false)
Panel_IngameCashShop_TermsofDaumCash:setGlassBackground(true)
Panel_IngameCashShop_TermsofDaumCash:ActiveMouseEventEffect(true)
local termsofDaumCash = {
  panelTitle = UI.getChildControl(Panel_IngameCashShop_TermsofDaumCash, "StaticText_Title")
}
Panel_IngameCashShop_TermsofDaumCash:RegisterShowEventFunc(true, "Panel_IngameCashShop_TermsofDaumCash_ShowAni()")
Panel_IngameCashShop_TermsofDaumCash:RegisterShowEventFunc(false, "Panel_IngameCashShop_TermsofDaumCash_HideAni()")
function Panel_IngameCashShop_TermsofDaumCash_ShowAni()
  UIAni.fadeInSCR_Down(Panel_IngameCashShop_TermsofDaumCash)
  local aniInfo1 = Panel_IngameCashShop_TermsofDaumCash:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_IngameCashShop_TermsofDaumCash:GetSizeX() / 2
  aniInfo1.AxisY = Panel_IngameCashShop_TermsofDaumCash:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_IngameCashShop_TermsofDaumCash:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_IngameCashShop_TermsofDaumCash:GetSizeX() / 2
  aniInfo2.AxisY = Panel_IngameCashShop_TermsofDaumCash:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_IngameCashShop_TermsofDaumCash_HideAni()
  Panel_IngameCashShop_TermsofDaumCash:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_IngameCashShop_TermsofDaumCash, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local _btn_Close = UI.getChildControl(Panel_IngameCashShop_TermsofDaumCash, "Button_Close")
local _Web
function Panel_IngameCashShop_TermsofDaumCash_Initialize()
  _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_IngameCashShop_TermsofDaumCash, "WebControl_TermsofDaumCash_WebLink")
  _Web:SetShow(true)
  _Web:SetPosX(43)
  _Web:SetPosY(63)
  _Web:SetSize(500, 552)
  _Web:ResetUrl()
end
Panel_IngameCashShop_TermsofDaumCash_Initialize()
function termsofDaumCash_FirstUsePearl_Open(type)
  local self = termsofDaumCash
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  local url = ""
  if isGameServiceTypeKorReal() then
    if 0 == type then
      url = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TERMSOFDAUMCASH_URL_URL1")
    end
  elseif 1 == type then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TERMSOFDAUMCASH_URL_URL2")
  end
  _Web:SetSize(500, 552)
  _Web:SetUrl(500, 552, url)
  local panelTitleString = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TERMSOFDAUMCASH")
  if isGameTypeTR() then
    panelTitleString = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TERMSOFDAUMCASH_TR")
  elseif isGameTypeTH() then
    panelTitleString = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TERMSOFDAUMCASH_TH")
  elseif isGameTypeID() then
    panelTitleString = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TERMSOFDAUMCASH_ID")
  end
  self.panelTitle:SetText(panelTitleString)
  Panel_IngameCashShop_TermsofDaumCash:SetShow(true, true)
end
function termsofDaumCash_Close()
  _Web:ResetUrl()
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
  Panel_IngameCashShop_TermsofDaumCash:SetShow(false, false)
end
function HandleClicked_TermsofDaumCash_Close()
  termsofDaumCash_Close()
end
function HandleClicked_TermsofDaumCash_Next()
  termsofDaumCash_Close()
end
function FromClient_AcceptGeneralConditions()
  if isGameServiceTypeKorReal() then
    termsofDaumCash_FirstUsePearl_Open(0)
  else
    termsofDaumCash_FirstUsePearl_Open(1)
  end
end
_btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_TermsofDaumCash_Close()")
registerEvent("FromClient_AcceptGeneralConditions", "FromClient_AcceptGeneralConditions")

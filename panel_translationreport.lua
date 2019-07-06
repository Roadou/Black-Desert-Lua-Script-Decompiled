local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_TranslationReport:SetShow(false, false)
local _btn_Close = UI.getChildControl(Panel_TranslationReport, "Button_Close")
local _translationReportWebControl
function Panel_TranslationReport_init()
  _translationReportWebControl = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_TranslationReport, "WebControl_TranslationReport")
  _translationReportWebControl:SetShow(true)
  _translationReportWebControl:SetPosX(15)
  _translationReportWebControl:SetPosY(50)
  _translationReportWebControl:SetSize(700, 610)
  _translationReportWebControl:ResetUrl()
end
function Panel_TranslationReport:Open(staticType, key1, key2, key3, textNo)
  if isGameTypeGT() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TESTSERVER_CAUTION"))
    return
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local url = PaGlobal_URL_Check(worldNo)
  local serviceType = getGameServiceType()
  if CppEnums.CountryType.KOR_REAL == serviceType or CppEnums.CountryType.KOR_ALPHA == serviceType then
    return
  end
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  Panel_TranslationReport:SetShow(true)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local userNo = selfPlayer:get():getUserNo()
  local cryptKey = selfPlayer:get():getWebAuthenticKeyCryptString()
  local serviceResourceType = ToClient_getResourceType()
  url = url .. "/Translation" .. "?userNo=" .. tostring(userNo) .. "&certKey=" .. tostring(cryptKey) .. "&translationKey1=" .. tostring(key1) .. "&translationKey2=" .. tostring(key2) .. "&translationKey3=" .. tostring(key3) .. "&textNo=" .. tostring(textNo) .. "&serviceResourceType=" .. tostring(serviceResourceType) .. "&staticType=" .. tostring(staticType)
  _translationReportWebControl:SetUrl(700, 610, url, false, true)
  _translationReportWebControl:SetIME(true)
  _translationReportWebControl:SetHorizonCenter(0)
  _translationReportWebControl:SetVerticalTop()
  _translationReportWebControl:SetSpanSize(0, 50)
  _translationReportWebControl:ComputePos()
  Panel_TranslationReport:SetPosX(getScreenSizeX() / 2 - Panel_TranslationReport:GetSizeX() / 2, getScreenSizeY() / 2 - Panel_TranslationReport:GetSizeY() / 2)
end
function Panel_TranslationReport:Close()
  FGlobal_ClearCandidate()
  _translationReportWebControl:ResetUrl()
  Panel_TranslationReport:SetShow(false)
end
function TranslationReport_Opne(staticType, key1, key2, key3, textNo)
  Panel_TranslationReport:Open(staticType, key1, key2, key3, textNo)
end
function TranslationReport_Close()
  Panel_TranslationReport:Close()
end
function Panel_TranslationReport:RegisterEvent()
  _btn_Close:addInputEvent("Mouse_LUp", "TranslationReport_Close()")
  registerEvent("FromClient_TranslationReport", "TranslationReport_Opne")
  registerEvent("FromClient_luaLoadComplete", "Panel_TranslationReport_init")
end
Panel_TranslationReport:RegisterEvent()

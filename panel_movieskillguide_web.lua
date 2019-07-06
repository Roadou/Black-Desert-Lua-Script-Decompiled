local UI_TM = CppEnums.TextMode
PaGlobal_MovieSkillGuide_Web = {
  btn_Close = UI.getChildControl(Panel_MovieSkillGuide_Web, "Button_Close")
}
local _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_MovieSkillGuide_Web, "WebControl_MovieSkillGuideWeb_WebLink")
_Web:SetShow(true)
_Web:SetPosX(12)
_Web:SetPosY(68)
_Web:SetSize(320, 430)
_Web:ResetUrl()
function PaGlobal_MovieSkillGuide_Web:init()
  self.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_MovieSkillGuide_Web:Close()")
end
function PaGlobal_MovieSkillGuide_Web:Open()
  local serviceType = getGameServiceType()
  local languageType = ToClient_getResourceType()
  local classType = getSelfPlayer():getClassType()
  if nil == serviceType or nil == languageType or nil == classType then
    return
  end
  local serviceTypeString = Defines.ServiceTypeToString[serviceType]
  local languageTypeString = Defines.LanguageTypeToString[languageType]
  if "DV" == serviceTypeString then
    serviceTypeString = "KR"
  end
  if "DV" == languageTypeString then
    languageTypeString = "KR"
  end
  local _guideWebURL = "https://www.playblackdesert.tv/Guide/?"
  _guideWebURL = _guideWebURL .. "serviceType=" .. serviceTypeString .. "&languageType=" .. languageTypeString .. "&classType=" .. tostring(classType) .. "#skill"
  ToClient_OpenChargeWebPage(_guideWebURL, false)
end
function PaGlobal_MovieSkillGuide_Web:Close()
  Panel_MovieSkillGuide_Web:SetShow(false)
  _Web:ResetUrl()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
end
PaGlobal_MovieSkillGuide_Web:init()

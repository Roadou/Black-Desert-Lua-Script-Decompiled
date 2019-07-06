local UI_TM = CppEnums.TextMode
PaGlobal_MovieGuide_Web = {
  btn_Close = UI.getChildControl(Panel_MovieGuide_Web, "Button_Close")
}
local _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_MovieGuide_Web, "WebControl_MovieGuideWeb_WebLink")
_Web:SetShow(true)
_Web:SetPosX(12)
_Web:SetPosY(50)
_Web:SetSize(320, 430)
_Web:ResetUrl()
function PaGlobal_MovieGuide_Web:init()
  self.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_MovieGuide_Web:Close()")
end
function PaGlobal_MovieGuide_Web:Open()
  local serviceType = getGameServiceType()
  local languageType = ToClient_getResourceType()
  if nil == serviceType or nil == languageType then
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
  _guideWebURL = _guideWebURL .. "serviceType=" .. serviceTypeString .. "&languageType=" .. languageTypeString
  ToClient_OpenChargeWebPage(_guideWebURL, false)
end
function PaGlobal_MovieGuide_Web:Close()
  Panel_MovieGuide_Web:SetShow(false)
  _Web:ResetUrl()
end
function PaGlobal_MovieGuide_Web:GuideWebCodeExecute(titleName, youtubeUrl)
end
PaGlobal_MovieGuide_Web:init()

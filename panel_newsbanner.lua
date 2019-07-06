local _panel = Panel_NewsBanner
local NewsBanner = {
  _ui = {
    stc_bannerArea = UI.getChildControl(_panel, "Static_BannerArea"),
    stc_keyguideBG = UI.getChildControl(_panel, "Static_KeyguideBG")
  },
  _currentBannerPage = 1,
  _bannerIsReady = {}
}
local screenX = getScreenSizeX()
local screenY = getScreenSizeY()
local self = NewsBanner
function NewsBanner:init()
  self._ui.stc_keyguideB = UI.getChildControl(self._ui.stc_keyguideBG, "StaticText_B_ConsoleUI")
  self._ui.stc_keyguideA = UI.getChildControl(self._ui.stc_keyguideBG, "StaticText_A_ConsoleUI")
  local keyGuides = {
    self._ui.stc_keyguideA,
    self._ui.stc_keyguideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.stc_keyguideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  if false == _ContentsGroup_Console_WebBanner then
    self._ui.stc_bannerArea:SetShow(false)
    return
  end
  self._ui.stc_bannerArea:SetShow(true)
  self._ui.stc_bannerBGs = {
    [0] = UI.getChildControl(self._ui.stc_bannerArea, "Static_TopBanner"),
    [1] = UI.getChildControl(self._ui.stc_bannerArea, "Static_MidBanner"),
    [2] = UI.getChildControl(self._ui.stc_bannerArea, "Static_BottomBanner")
  }
  self._ui.web_banners = {}
  for ii = 0, #self._ui.stc_bannerBGs do
    self._ui.web_banners[ii] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, self._ui.stc_bannerBGs[ii], "web_topBanner" .. ii)
    self._ui.web_banners[ii]:ResetUrl()
    self._ui.web_banners[ii]:SetSize(self._ui.stc_bannerBGs[ii]:GetSizeX() - 20, self._ui.stc_bannerBGs[ii]:GetSizeY() - 20)
    self._ui.web_banners[ii]:SetHorizonCenter()
    self._ui.web_banners[ii]:SetVerticalMiddle()
    self._ui.web_banners[ii]:addInputEvent("Mouse_On", "InputMOn_NewsBanner_OverWebBanner(true)")
    self._ui.web_banners[ii]:addInputEvent("Mouse_Out", "InputMOn_NewsBanner_OverWebBanner(false)")
    self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_LB, "Input_NewsBanner_ToWebBanner(\"LB\", " .. ii .. ")")
    self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_RB, "Input_NewsBanner_ToWebBanner(\"RB\", " .. ii .. ")")
    self._ui.stc_bannerBGs[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "Input_NewsBanner_ToWebBanner(\"CLICK\", " .. ii .. ")")
  end
  local keyGuideLB = UI.getChildControl(self._ui.stc_bannerBGs[1], "StaticText_KeyGuideLB")
  local keyGuideRB = UI.getChildControl(self._ui.stc_bannerBGs[1], "StaticText_KeyGuideRB")
  self._ui.stc_bannerBGs[1]:SetChildIndex(keyGuideLB, self._ui.stc_bannerBGs[1]:GetChildSize())
  self._ui.stc_bannerBGs[1]:SetChildIndex(keyGuideRB, self._ui.stc_bannerBGs[1]:GetChildSize())
  self:registEventHandler()
end
function NewsBanner:initBanners()
  local domainURL = ""
  if nil ~= ToClient_getXBoxBannerURL then
    domainURL = ToClient_getXBoxBannerURL()
  end
  if nil == domainURL or "" == domainURL then
    domainURL = "https://dev-game-portal.xbox.playblackdesert.com/Banner?bannerType="
  else
    domainURL = "https://" .. domainURL .. "/Banner?bannerType="
  end
  domainURL = domainURL .. "0&bannerPosition="
  for ii = 0, #self._ui.stc_bannerBGs do
    self._ui.web_banners[ii]:ResetUrl()
    self._ui.web_banners[ii]:SetUrl(self._ui.web_banners[ii]:GetSizeX(), self._ui.web_banners[ii]:GetSizeY(), domainURL .. tostring(ii), false, true)
  end
end
function NewsBanner:registEventHandler()
  registerEvent("FromClient_WebUIBannerEventForXBOX", "FromClient_WebUIBannerEventForXBOX_NewsBanner")
  registerEvent("FromClient_WebUIBannerIsReadyForXBOX", "FromClient_WebUIBannerIsReadyForXBOX_NewsBanner")
  registerEvent("onScreenResize", "PaGlobal_NewsBanner_Resize")
end
function PaGlobalFunc_NewsBanner_Open()
  if true == ToClient_isPS4 then
    return
  end
  Panel_NewsBanner:SetShow(true)
  self:initBanners()
end
function PaGlobalFunc_NewsBanner_Close()
  for ii = 0, #self._ui.stc_bannerBGs do
    self._ui.web_banners[ii]:ResetUrl()
  end
  Panel_NewsBanner:SetShow(false)
end
function InputMOn_NewsBanner_OverWebBanner(isOn)
  local self = NewsBanner
  self._ui.stc_keyguideA:SetShow(isOn)
  local keyGuides = {
    self._ui.stc_keyguideA,
    self._ui.stc_keyguideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.stc_keyguideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Input_NewsBanner_ToWebBanner(key, bannerIndex)
  local self = NewsBanner
  if "CLICK" == key and not self._bannerIsReady[bannerIndex] then
    MessageBox.showMessageBox({
      content = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WEBCONTROL_PAGE_NOT_READY"),
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    })
    return
  end
  self._ui.web_banners[bannerIndex]:TriggerEvent("FromClient_GamePadInputForWebBanner", key)
end
function FromClient_WebUIBannerEventForXBOX_NewsBanner(linkType, link)
  if false == Panel_NewsBanner:GetShow() then
    return
  end
  if Defines.ConsoleBannerLinkType.InGameWeb == linkType then
    PaGlobalFunc_WebControl_Open(link)
  else
    MessageBox.showMessageBox({
      content = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WEBCONTROL_PAGE_NOT_READY"),
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    })
  end
end
function FromClient_WebUIBannerIsReadyForXBOX_NewsBanner(bannerType, bannerIndex)
  local self = NewsBanner
  if 0 == bannerType then
    self._bannerIsReady[bannerIndex] = true
  end
end
function PaGlobal_NewsBanner_Resize()
  if false == _panel:IsShow() then
    return
  end
  local resizedRatioY = getScreenSizeY() / _panel:GetSizeY()
  local self = NewsBanner
  _panel:SetSize(getScreenSizeX(), getScreenSizeY())
  self._ui.stc_RightBg:SetSize(self._ui.stc_RightBg:GetSizeX(), getScreenSizeY())
  self._ui.stc_RightBg:SetPosX(getScreenSizeX() - self._ui.stc_RightBg:GetSizeX())
  self._ui.stc_leftBg:ComputePos()
  self._ui.list_Server:SetSize(self._ui.list_Server:GetSizeX(), self._ui.list_Server:GetSizeY() * resizedRatioY)
  self._ui.txt_Select_ConsoleUI:SetPosY(self._ui.txt_Select_ConsoleUI:GetPosY() * resizedRatioY)
  self._ui.txt_Back_ConsoleUI:SetPosY(self._ui.txt_Back_ConsoleUI:GetPosY() * resizedRatioY)
end
function PaGlobal_NewsBanner_Init()
  local self = NewsBanner
  self:init()
  PaGlobal_NewsBanner_Resize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_NewsBanner_Init")

local UI_TM = CppEnums.TextMode
PaGlobal_MovieSkillGuide_Weblist = {
  btn_Close = UI.getChildControl(Panel_MovieSkillGuide_Weblist, "Button_Close"),
  txt_Title = UI.getChildControl(Panel_MovieSkillGuide_Weblist, "StaticText_Title")
}
local _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_MovieSkillGuide_Weblist, "WebControl_MovieGuideList_WebLink")
_Web:SetShow(true)
_Web:SetPosX(11)
_Web:SetPosY(50)
_Web:SetSize(640, 544)
_Web:ResetUrl()
function PaGlobal_MovieSkillGuide_Weblist:init()
  self.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_MovieSkillGuide_Weblist:Close()")
end
function PaGlobal_MovieSkillGuide_Weblist:Open(title, youtubeURL, strKey)
  if nil ~= title then
    self.txt_Title:SetText(tostring(title))
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local cryptKey = getSelfPlayer():get():getWebAuthenticKeyCryptString()
  local userNo = getSelfPlayer():get():getUserNo()
  local url = PaGlobal_URL_Check(worldNo)
  Panel_MovieSkillGuide_Weblist:SetPosX(getScreenSizeX() / 2 - Panel_MovieSkillGuide_Weblist:GetSizeX() / 2)
  Panel_MovieSkillGuide_Weblist:SetPosY(getScreenSizeY() / 2 - Panel_MovieSkillGuide_Weblist:GetSizeY() / 2)
  if nil ~= url then
    local realURL = url .. "/MovieGuide/Index/IngameSkillPop?ComboDesc=" .. tostring(strKey) .. "&YoutubeUrl=" .. youtubeURL .. "&userNo=" .. tostring(userNo) .. "&certKey=" .. tostring(cryptKey)
    _Web:SetUrl(640, 544, realURL, false, true)
  end
  Panel_MovieSkillGuide_Weblist:SetShow(true)
end
function PaGlobal_MovieSkillGuide_Weblist:Close()
  Panel_MovieSkillGuide_Weblist:SetShow(false)
  _Web:ResetUrl()
end
PaGlobal_MovieSkillGuide_Weblist:init()

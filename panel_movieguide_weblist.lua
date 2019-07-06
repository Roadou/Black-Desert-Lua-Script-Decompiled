local UI_TM = CppEnums.TextMode
PaGlobal_MovieGuide_Weblist = {
  btn_Close = UI.getChildControl(Panel_MovieGuide_Weblist, "Button_Close"),
  txt_Title = UI.getChildControl(Panel_MovieGuide_Weblist, "StaticText_Title")
}
local _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_MovieGuide_Weblist, "WebControl_MovieGuideList_WebLink")
_Web:SetShow(true)
_Web:SetPosX(12)
_Web:SetPosY(50)
_Web:SetSize(640, 480)
_Web:ResetUrl()
function PaGlobal_MovieGuide_Weblist:init()
  self.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_MovieGuide_Weblist:Close()")
end
function PaGlobal_MovieGuide_Weblist:Open(title, youtubeURL)
  if nil ~= title then
    self.txt_Title:SetText(tostring(title))
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local cryptKey = getSelfPlayer():get():getWebAuthenticKeyCryptString()
  local userNo = getSelfPlayer():get():getUserNo()
  local url = PaGlobal_URL_Check(worldNo)
  Panel_MovieGuide_Weblist:SetPosX(getScreenSizeX() / 2 - Panel_MovieGuide_Weblist:GetSizeX() / 2)
  Panel_MovieGuide_Weblist:SetPosY(getScreenSizeY() / 2 - Panel_MovieGuide_Weblist:GetSizeY() / 2)
  if nil ~= url then
    local realUrl = url .. "/MovieGuide/Index/IngameMoviePop?YoutubeUrl=" .. youtubeURL .. "&userNo=" .. tostring(userNo) .. "&certKey=" .. tostring(cryptKey)
    _Web:SetUrl(640, 480, realUrl, false, true)
  end
  Panel_MovieGuide_Weblist:SetShow(true)
end
function PaGlobal_MovieGuide_Weblist:Close()
  Panel_MovieGuide_Weblist:SetShow(false)
  _Web:ResetUrl()
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:pop()
  end
end
PaGlobal_MovieGuide_Weblist:init()

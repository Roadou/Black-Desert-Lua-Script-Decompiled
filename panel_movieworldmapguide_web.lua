local UI_TM = CppEnums.TextMode
PaGlobal_MovieWorldMapGuide_Web = {
  btn_Close = UI.getChildControl(Panel_MovieWorldMapGuide_Web, "Button_Close")
}
local _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_MovieWorldMapGuide_Web, "WebControl_MovieGuideWeb_WebLink")
_Web:SetShow(true)
_Web:SetPosX(12)
_Web:SetPosY(50)
_Web:SetSize(260, 210)
_Web:ResetUrl()
function PaGlobal_MovieWorldMapGuide_Web:init()
  self.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_MovieWorldMapGuide_Web:Close()")
end
function PaGlobal_MovieWorldMapGuide_Web:Open()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local cryptKey = getSelfPlayer():get():getWebAuthenticKeyCryptString()
  local userNo = getSelfPlayer():get():getUserNo()
  local movieGuideWeb = PaGlobal_URL_Check(worldNo)
  Panel_MovieWorldMapGuide_Web:SetPosX(getScreenSizeX() / 2 - Panel_MovieWorldMapGuide_Web:GetSizeX() / 2)
  Panel_MovieWorldMapGuide_Web:SetPosY(getScreenSizeY() / 2 - Panel_MovieWorldMapGuide_Web:GetSizeY() / 2)
  if nil ~= movieGuideWeb then
    local url = movieGuideWeb .. "/MovieGuide/Index/WorldMapGuide?userNo=" .. tostring(userNo) .. "&certKey=" .. tostring(cryptKey)
    _Web:SetUrl(260, 210, url, false, true)
    Panel_MovieWorldMapGuide_Web:SetShow(true)
  end
end
function PaGlobal_MovieWorldMapGuide_Web:Close()
  Panel_MovieWorldMapGuide_Web:SetShow(false)
  _Web:ResetUrl()
  PaGlobal_MovieGuide_Weblist:Close()
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:pop()
  end
end
function PaGlobal_MovieWorldMapGuide_Web:GuideWebCodeExecute(titleName, youtubeUrl)
end
PaGlobal_MovieWorldMapGuide_Web:init()

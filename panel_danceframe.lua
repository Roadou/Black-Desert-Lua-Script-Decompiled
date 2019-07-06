DanceFrame = {
  _web = {}
}
function DanceFrame:initalize()
  self._web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_DanceFrame, "WebControl_EventNotify_WebLink")
  self._web:SetShow(true)
  self._web:SetPosX(11)
  self._web:SetPosY(50)
  self._web:SetSize(918, 655)
  self._web:ResetUrl()
end
function FGlobal_DanceFrame_Open()
  DanceFrame:open()
end
function FGlobal_DanceFrame_Close()
  DanceFrame:close()
end
function DanceFrame:open()
  Panel_DanceFrame:SetShow(true, true)
  Panel_DanceFrame:SetPosX(getScreenSizeX() / 2 - Panel_DanceFrame:GetSizeX() / 2)
  Panel_DanceFrame:SetPosY(getScreenSizeY() / 2 - Panel_DanceFrame:GetSizeY() / 2)
  local url = "http://10.32.129.20/DanceEdit"
  self._web:SetUrl(918, 655, url)
end
function DanceFrame:close()
  Panel_DanceFrame:SetShow(false, false)
  Panel_DanceFrame:CloseUISubApp()
  self._web:ResetUrl()
end
DanceFrame:initalize()
registerEvent("FromClient_OpenDanceFrame", "FGlobal_DanceFrame_Open")

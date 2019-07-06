local IM = CppEnums.EProcessorInputMode
Panel_Copyright:SetShow(false)
local PaGlobal_Copyright = {
  btn_Close = UI.getChildControl(Panel_Copyright, "Button_Win_Close"),
  _Web = nil
}
local screenSizeX = getScreenSizeX()
local screenSizeY = getScreenSizeY()
function PaGlobal_Copyright:init()
  self._Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Copyright, "WebControl_Copyright_WebLink")
  self._Web:SetShow(true)
  self._Web:SetVerticalMiddle()
  self._Web:SetHorizonCenter()
  self._Web:SetSize(screenSizeX, screenSizeY)
  self._Web:ResetUrl()
  self.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_Copyright_Close()")
end
function PaGlobal_Copyright_ShowWindow()
  local self = PaGlobal_Copyright
  Panel_Copyright:SetShow(true)
  screenSizeX = getScreenSizeX()
  screenSizeY = getScreenSizeY()
  Panel_Copyright:SetSize(screenSizeX, screenSizeY)
  Panel_Copyright:SetPosX(0)
  Panel_Copyright:SetPosY(0)
  self._Web:SetSize(screenSizeX, screenSizeY)
  self._Web:ComputePos()
  self._Web:SetUrl(screenSizeX, screenSizeY, "coui://UI_Data/UI_Html/copyright.html", false, true)
end
function PaGlobal_Copyright_Close()
  local self = PaGlobal_Copyright
  Panel_Copyright:SetShow(false)
  self._Web:ResetUrl()
end
PaGlobal_Copyright:init()

Instance_ScreenShot_For_Desktop:SetShow(false)
local UI_TM = CppEnums.TextMode
local ScreenShotSize = {
  _btn_ScreenShot_Win_Close = UI.getChildControl(Instance_ScreenShot_For_Desktop, "Button_Win_Close"),
  _screenShotBG = UI.getChildControl(Instance_ScreenShot_For_Desktop, "Static_BG"),
  _txt_ScreenShotDesc = UI.getChildControl(Instance_ScreenShot_For_Desktop, "StaticText_ScreenShotDesc"),
  _btn_ScreenShotApply = UI.getChildControl(Instance_ScreenShot_For_Desktop, "Button_Confirm"),
  _btn_ScreenShotCancel = UI.getChildControl(Instance_ScreenShot_For_Desktop, "Button_AlarmCancel")
}
function PaGlobal_Panel_ScreenShot_For_Desktop_Init()
  local self = ScreenShotSize
  local screenShotFileName = getRecentScreenShotFileName()
  self._txt_ScreenShotDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  if nil == screenShotFileName or "" == screenShotFileName then
    self._txt_ScreenShotDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SCREENSHOTFORDESKTOP_DESC"))
  else
    self._txt_ScreenShotDesc:SetText(tostring(screenShotFileName) .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SCREENSHOTFORDESKTOP_DESC"))
  end
  self._screenShotBG:SetSize(self._screenShotBG:GetSizeX(), self._txt_ScreenShotDesc:GetTextSizeY() + 40)
  Instance_ScreenShot_For_Desktop:SetSize(Instance_ScreenShot_For_Desktop:GetSizeX(), self._screenShotBG:GetSizeY() + 110)
  self._btn_ScreenShot_Win_Close:addInputEvent("Mouse_LUp", "PaGlobal_Panel_ScreenShot_For_Desktop_Close()")
  self._btn_ScreenShotApply:addInputEvent("Mouse_LUp", "PaGlobal_Panel_ScreenShot_For_Desktop_Apply()")
  self._btn_ScreenShotCancel:addInputEvent("Mouse_LUp", "PaGlobal_Panel_ScreenShot_For_Desktop_OpenFolder()")
end
function PaGlobal_Panel_ScreenShot_For_Desktop_Position()
  local self = ScreenShotSize
  Instance_ScreenShot_For_Desktop:ComputePos()
  self._btn_ScreenShotApply:ComputePos()
  self._btn_ScreenShotCancel:ComputePos()
end
function PaGlobal_Panel_ScreenShot_For_Desktop_Open()
  local self = ScreenShotSize
  local screenShotFileName = getRecentScreenShotFileName()
  self._txt_ScreenShotDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  if nil == screenShotFileName or "" == screenShotFileName then
    self._txt_ScreenShotDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SCREENSHOTFORDESKTOP_DESC"))
  else
    self._txt_ScreenShotDesc:SetText(tostring(screenShotFileName) .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SCREENSHOTFORDESKTOP_DESC"))
  end
  local textSizeY = self._txt_ScreenShotDesc:GetTextSizeY()
  self._screenShotBG:SetSize(self._screenShotBG:GetSizeX(), textSizeY + 40)
  Instance_ScreenShot_For_Desktop:SetSize(Instance_ScreenShot_For_Desktop:GetSizeX(), self._screenShotBG:GetSizeY() + 104)
  Instance_ScreenShot_For_Desktop:SetShow(true)
end
function PaGlobal_Panel_ScreenShot_For_Desktop_Close()
  Instance_ScreenShot_For_Desktop:SetShow(false)
end
function PaGlobal_Panel_ScreenShot_For_Desktop_Apply()
  local filepath = getRecentScreenShotFileName()
  setWallpaper(filepath)
  PaGlobal_Panel_ScreenShot_For_Desktop_Close()
end
function PaGlobal_Panel_ScreenShot_For_Desktop_OpenFolder()
  ToClient_OpenDirectory(CppEnums.OpenDirectoryType.DirectoryType_ScreenShot)
end
PaGlobal_Panel_ScreenShot_For_Desktop_Init()
registerEvent("onScreenResize", "PaGlobal_Panel_ScreenShot_For_Desktop_Position")

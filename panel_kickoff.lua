Panel_KickOff:SetShow(false)
local UI_TM = CppEnums.TextMode
local kickOff = {
  _txt_Title = UI.getChildControl(Panel_KickOff, "StaticText_Title"),
  _btn_KickOff_Win_Close = UI.getChildControl(Panel_KickOff, "Button_Win_Close"),
  _screenShotBG = UI.getChildControl(Panel_KickOff, "Static_BG"),
  _txt_KickOffDesc = UI.getChildControl(Panel_KickOff, "StaticText_KickOffDesc"),
  _btn_KickOffApply = UI.getChildControl(Panel_KickOff, "Button_Confirm"),
  _btn_KickOffCancel = UI.getChildControl(Panel_KickOff, "Button_AlarmCancel"),
  savedIsType = 1
}
function PaGlobal_Panel_KickOff_Init()
  local self = kickOff
  self._txt_KickOffDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._txt_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BDOKR2_B"))
  self._screenShotBG:SetSize(self._screenShotBG:GetSizeX(), self._txt_KickOffDesc:GetTextSizeY() + 20)
  Panel_KickOff:SetSize(Panel_KickOff:GetSizeX(), self._screenShotBG:GetSizeY() + 110)
  self._btn_KickOff_Win_Close:addInputEvent("Mouse_LUp", "PaGlobal_Panel_KickOff_Close()")
  self._btn_KickOffApply:addInputEvent("Mouse_LUp", "PaGlobal_Panel_KickOff_Apply()")
  self._btn_KickOffCancel:addInputEvent("Mouse_LUp", "PaGlobal_Panel_KickOff_OpenFolder()")
end
function PaGlobal_Panel_KickOff_Position()
  local self = kickOff
  Panel_KickOff:ComputePos()
  self._btn_KickOffApply:ComputePos()
  self._btn_KickOffCancel:ComputePos()
end
function FromClient_AntiAddiction(isType)
  local self = kickOff
  self.savedIsType = isType
  PaGlobal_Panel_KickOff_Open(isType)
end
function PaGlobal_Panel_KickOff_Open(isType)
  local self = kickOff
  local screenShotFileName = getRecentScreenShotFileName()
  if 1 == isType then
    self._txt_KickOffDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BDOKR2_C"))
  elseif 2 == isType then
    self._txt_KickOffDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BDOKR2_D"))
  elseif 3 == isType then
    self._txt_KickOffDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BDOKR2_E"))
  elseif 4 == isType then
    self._txt_KickOffDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BDOKR2_E"))
  else
    connectToGameByChina()
    return
  end
  local textSizeY = self._txt_KickOffDesc:GetTextSizeY()
  self._screenShotBG:SetSize(self._screenShotBG:GetSizeX(), textSizeY + 40)
  Panel_KickOff:SetSize(Panel_KickOff:GetSizeX(), self._screenShotBG:GetSizeY() + 94)
  PaGlobal_Panel_KickOff_Position()
  Panel_KickOff:SetShow(true)
end
function PaGlobal_Panel_KickOff_Close()
  Panel_KickOff:SetShow(false)
end
function PaGlobal_Panel_KickOff_Apply()
  local self = kickOff
  if 4 == self.savedIsType then
    exitGameClient(1)
  else
    connectToGameByChina()
    PaGlobal_Panel_KickOff_Close()
  end
end
PaGlobal_Panel_KickOff_Init()
registerEvent("onScreenResize", "PaGlobal_Panel_KickOff_Position")
registerEvent("FromClient_AntiAddiction", "FromClient_AntiAddiction")

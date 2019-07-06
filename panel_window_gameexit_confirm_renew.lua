PaGlobal_registerPanelOnBlackBackground(Panel_Window_GameExit_Confirm)
local Window_GameExit_ConfirmInfo = {
  _ui = {
    _staticText_Title = UI.getChildControl(Panel_Window_GameExit_Confirm, "StaticText_Title"),
    _button_Confirm = UI.getChildControl(Panel_Window_GameExit_Confirm, "Button_Confirm"),
    _button_Cancel = UI.getChildControl(Panel_Window_GameExit_Confirm, "Button_Cancel"),
    _checkBox_Tray = UI.getChildControl(Panel_Window_GameExit_Confirm, "CheckButton_Tray"),
    _staticText_TrayHelp = UI.getChildControl(Panel_Window_GameExit_Confirm, "StaticText_TrayHelp"),
    _staticText_GameExit = UI.getChildControl(Panel_Window_GameExit_Confirm, "StaticText_GameExit")
  },
  _config = {
    _exitType_Exit = 0,
    _exitType_Tray = 1,
    _exitType_CharacterSelect = 2
  }
}
function Window_GameExit_ConfirmInfo:SetDescByExitType(exitType)
  if self._config._exitType_Exit == exitType then
    self._ui._staticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "GAME_EXIT_MESSAGEBOX_TITLE"))
    self._ui._staticText_GameExit:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_DISCONNECT"))
    self._ui._staticText_TrayHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITTRAY_TRAYHELP"))
  elseif self._config._exitType_Tray == exitType then
    self._ui._staticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITCONFIRM_TITLE"))
    self._ui._staticText_GameExit:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_GAMEEXIT_TRAY_ASK2"))
    self._ui._staticText_TrayHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_TRAYLIMIT"))
  elseif self._config._exitType_CharacterSelect == exitType then
    self._ui._staticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHARACTERSELECT_NAME_TEXT"))
    self._ui._staticText_GameExit:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_BACK_TO_CHARACTERSELECT_Q"))
  else
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "\236\162\133\235\163\140 \237\131\128\236\158\133\236\157\180 \236\158\152\235\170\187\235\144\144\236\138\181\235\139\136\235\139\164.")
  end
end
function Window_GameExit_ConfirmInfo:SetButtonEventByExitType(exitType)
  if self._config._exitType_Exit == exitType then
    self._ui._staticText_TrayHelp:SetShow(false)
    self._ui._button_Confirm:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExitConfirm_ExitButton()")
    Panel_Window_GameExit_Confirm:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_GameExitConfirm_ExitButton()")
  elseif self._config._exitType_Tray == exitType then
    self._ui._button_Confirm:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExitConfirm_TrayButton()")
  elseif self._config._exitType_CharacterSelect == exitType then
    self._ui._button_Confirm:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExitConfirm_CharacterSelectButton()")
    Panel_Window_GameExit_Confirm:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_GameExitConfirm_CharacterSelectButton()")
  else
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "\236\162\133\235\163\140 \237\131\128\236\158\133\236\157\180 \236\158\152\235\170\187\235\144\144\236\138\181\235\139\136\235\139\164.")
  end
end
function PaGlobalFunc_GameExitConfirm_ExitButton()
  local self = Window_GameExit_ConfirmInfo
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  PaGlobalFunc_GameExit_ExitHandler(0)
  PaGlobalFunc_GameExitConfirm_SetShow(false, false)
end
function PaGlobalFunc_GameExitConfirm_TrayButton()
  local self = Window_GameExit_ConfirmInfo
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  PaGlobalFunc_GameExitConfirm_SetShow(false, false)
end
function PaGlobalFunc_GameExitConfirm_CharacterSelectButton()
  PaGlobalFunc_GameExit_ExitHandler(1)
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  PaGlobalFunc_GameExitConfirm_SetShow(false, false)
end
function Window_GameExit_ConfirmInfo:Initialize()
  self:InitControl()
  self:InitEvent()
end
function Window_GameExit_ConfirmInfo:InitControl()
  self._ui._staticText_TrayHelp:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._staticText_TrayHelp:SetAutoResize(true)
  self._ui._staticText_GameExit:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._staticText_TrayHelp:SetAutoResize(true)
  if _ContentsGroup_isConsolePadControl then
    self._ui._staticText_TrayHelp:SetShow(false)
    self._ui._checkBox_Tray:SetShow(false)
  end
end
function Window_GameExit_ConfirmInfo:InitEvent()
  self._ui._button_Cancel:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExitConfirm_SetShow(false,false)")
end
function PaGlobalFunc_FromClient_GameExitConfirm_luaLoadComplete()
  local self = Window_GameExit_ConfirmInfo
  self:Initialize()
end
function PaGlobalFunc_GameExitConfirm_OpenByExitType(exitType)
  local self = Window_GameExit_ConfirmInfo
  self:SetDescByExitType(exitType)
  self:SetButtonEventByExitType(exitType)
  PaGlobalFunc_GameExitConfirm_SetShow(true, true)
end
function PaGlobalFunc_GameExitConfirm_SetShow(isShow, isAni)
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  Panel_Window_GameExit_Confirm:SetShow(isShow, isAni)
end
function PaGlobalFunc_GameExitConfirm_GetShow()
  return Panel_Window_GameExit_Confirm:GetShow()
end
function PaGlobalFunc_GameExitConfirm_Toggle()
  PaGlobalFunc_GameExitConfirm_SetShow(not PaGlobalFunc_GameExitConfirm_GetShow(), false)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_GameExitConfirm_luaLoadComplete")

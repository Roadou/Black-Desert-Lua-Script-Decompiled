function PaGlobal_TrayConfirm:initialize()
  if true == PaGlobal_TrayConfirm._initialize then
    return
  end
  PaGlobal_TrayConfirm._ui._txtTitle = UI.getChildControl(Instance_TrayConfirm, "StaticText_Title")
  PaGlobal_TrayConfirm._ui._txtCheckDesc = UI.getChildControl(Instance_TrayConfirm, "StaticText_GameExit")
  PaGlobal_TrayConfirm._ui._txtTrayHelp = UI.getChildControl(Instance_TrayConfirm, "StaticText_TrayHelp")
  PaGlobal_TrayConfirm._ui._chkTray = UI.getChildControl(Instance_TrayConfirm, "CheckButton_Tray")
  PaGlobal_TrayConfirm._ui._btnConfirm = UI.getChildControl(Instance_TrayConfirm, "Button_Confirm")
  PaGlobal_TrayConfirm._ui._btnCancel = UI.getChildControl(Instance_TrayConfirm, "Button_Cancle")
  PaGlobal_TrayConfirm._ui._txtTrayHelp:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_TrayConfirm._ui._txtTrayHelp:SetAutoResize(true)
  PaGlobal_TrayConfirm._ui._txtTrayHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITTRAY_TRAYHELP"))
  PaGlobal_TrayConfirm:registEventHandler()
  PaGlobal_TrayConfirm:validate()
  PaGlobal_TrayConfirm._initialize = true
end
function PaGlobal_TrayConfirm:registEventHandler()
  PaGlobal_TrayConfirm._ui._btnConfirm:addInputEvent("Mouse_LUp", "HandleEventLUp_TrayConfirm()")
  PaGlobal_TrayConfirm._ui._btnCancel:addInputEvent("Mouse_LUp", "HandleEventLUp_TrayConfirmClose()")
  registerEvent("EventGameWindowClose", "FromClient_TrayConfirmWindowClose")
  registerEvent("FromClient_TrayIconMessageBox", "FromClient_TrayConfirmTrayIcon")
end
function PaGlobal_TrayConfirm:prepareOpen()
end
function PaGlobal_TrayConfirm:open()
  Instance_TrayConfirm:SetShow(true)
end
function PaGlobal_TrayConfirm:prepareClose()
end
function PaGlobal_TrayConfirm:close()
  Instance_TrayConfirm:SetShow(false)
end
function PaGlobal_TrayConfirm:update()
end
function PaGlobal_TrayConfirm:validate()
  PaGlobal_TrayConfirm._ui._txtTitle:isValidate()
  PaGlobal_TrayConfirm._ui._txtCheckDesc:isValidate()
  PaGlobal_TrayConfirm._ui._txtTrayHelp:isValidate()
  PaGlobal_TrayConfirm._ui._chkTray:isValidate()
  PaGlobal_TrayConfirm._ui._btnConfirm:isValidate()
  PaGlobal_TrayConfirm._ui._btnCancel:isValidate()
end
function PaGlobal_TrayConfirm:checkGameClose()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_EXITCONFIRM_FAILED"))
end
function PaGlobal_TrayConfirm:checkGameTray()
  PaGlobal_TrayConfirm._ui._txtTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITCONFIRM_TITLE"))
  PaGlobal_TrayConfirm._ui._txtCheckDesc:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_GAMEEXIT_TRAY_ASK2"))
  PaGlobal_TrayConfirm:open()
end
function PaGlobal_TrayConfirm:confirm()
  if PaGlobal_TrayConfirm._ui._chkTray:IsCheck() then
    ToClient_CheckTrayIcon()
  else
    ToClient_UnCheckTrayIcon()
  end
  PaGlobal_TrayConfirm:close()
end

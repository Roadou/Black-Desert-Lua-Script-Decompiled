function HandleEventLUp_TrayConfirm()
  PaGlobal_TrayConfirm:confirm()
end
function HandleEventLUp_TrayConfirmClose()
  PaGlobal_TrayConfirm:close()
end
function FromClient_TrayConfirmWindowClose()
  PaGlobal_TrayConfirm:checkGameClose()
end
function FromClient_TrayConfirmTrayIcon()
  PaGlobal_TrayConfirm:checkGameTray()
end

function PaGlobal_ConsoleUIOffset_Open()
  ConsoleUIOffset._ui.stc_informationDesc:SetShow(nil ~= Panel_Lobby_UserSetting)
  ConsoleUIOffset:open()
end
function PaGlobal_ConsoleUIOffset_Close()
  ConsoleUIOffset:close()
end
if nil ~= Panel_Login_Renew then
  ConsoleUIOffset:init()
end

function FromWeb_WebPageError(url, statusCode)
  if statusCode ~= 200 then
    _PA_LOG("LUA", "url : " .. tostring(url))
  end
end
registerEvent("FromWeb_WebPageError", "FromWeb_WebPageError")
function FromClient_WebNotifyProcessProblemToUser()
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_WEBUI_RELOAD_CONFIRM_MESSAGE"),
    functionYes = FromClient_WebNotifyProcessProblemToUser_MessageBox_Yes,
    functionNo = FromClient_WebNotifyProcessProblemToUser_MessageBox_No,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FromClient_WebNotifyProcessProblemToUser_MessageBox_Yes()
  ToClient_resetWebUI()
end
function FromClient_WebNotifyProcessProblemToUser_MessageBox_No()
  ToClient_resetWebUICancel()
end
registerEvent("FromClient_WebNotifyProcessProblemToUser", "FromClient_WebNotifyProcessProblemToUser")

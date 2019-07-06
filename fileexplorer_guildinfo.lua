function FromClient_OpenExplorer_GuildInfo(title, defaultName, paramList)
  local paramCount = 0
  for key, value in pairs(paramList) do
    paramCount = paramCount + 1
  end
  if 0 ~= paramCount or "" ~= title then
    return
  end
  local filterType = {
    "bmp,jpg,png,gif,jpeg"
  }
  FileExplorer_Open(PAGetString(Defines.StringSheet_RESOURCE, "FILEEXPLORER_TITLE"), 0, filterType)
  FileExplorer_NotUseFilterComboBox(false)
  FileExplorer_setEditTextMaxInput(50)
  FileExplorer_CustomConfirmFunction(OnGuildInfoFunction)
  FileExplorer_CustomCancelFunction(closeFileSelectionRequest)
  refreshFileList()
end
function closeFileSelectionRequest()
  FromClient_FinishiFileSelectionRequest()
end
function OnGuildInfoFunction(text)
  if text == "" then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_NONAME")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  local currentPath = FileExplorer_getCurrentPath()
  local fullPath = currentPath .. "\\" .. text
  if not isCorrectFile(text) then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_LOAD_FAILED")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    FromClient_getExplorerData(fullPath)
  end
  closeExplorer()
end
registerEvent("FromClient_OpenExplorer", "FromClient_OpenExplorer_GuildInfo")

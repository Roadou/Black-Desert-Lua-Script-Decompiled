function OpenExplorerSaveCustomizing()
  InitExplorerOption(PAGetString(Defines.StringSheet_RESOURCE, "FILEEXPLORER_TITLE"))
  FileExplorer_CustomConfirmFunction(SaveCustomData)
  refreshFileList()
end
function OpenExplorerLoadCustomizing()
  InitExplorerOption(PAGetString(Defines.StringSheet_RESOURCE, "FILEEXPLORER_TITLE"))
  FileExplorer_CustomConfirmFunction(LoadCustomData)
  refreshFileList()
end
function InitExplorerOption(titleName)
  local FilterType = {"None"}
  FileExplorer_Open(titleName, 0, FilterType)
  FileExplorerSetFilterBoxAtIndex(0)
  FileExplorerAddPathToCurrentPath("Customization")
  FileExplorer_NotUseFilterComboBox(false)
  FileExplorer_SetEditText("CustomizationData")
  FileExplorer_setEditTextMaxInput(100)
end
function LoadCustomData(text)
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
  local loadPath = FileExplorer_getCurrentPath()
  if not isExistCustomizationFile(text, loadPath) then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_LOAD_FAILED")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_APPLY")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = LoadCustomYesBtn,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
  closeExplorer()
end
function LoadCustomYesBtn()
  local text = FileExplorer_GetEditText()
  local loadPath = FileExplorer_getCurrentPath()
  loadCustomizationData(text, loadPath)
end
function SaveCustomData(text)
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
  local savePath = FileExplorer_getCurrentPath()
  if isExistCustomizationFile(text, savePath) then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_SAVE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = SaveCustomYesBtn,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    SaveCustomizationFile(text, savePath)
  end
  closeExplorer()
end
function SaveCustomYesBtn()
  local text = FileExplorer_GetEditText()
  local savePath = FileExplorer_getCurrentPath()
  SaveCustomizationFile(text, savePath)
end
function SaveCustomizationFile(strFileName, savePath)
  if not saveCustomizationData(strFileName, savePath) then
    local errorString = "" .. strFileName .. " - " .. PAGetString(Defines.StringSheet_SymbolNo, "eErrNoInvalidFileNameToSave")
    Event_MessageBox_NotifyMessage(errorString)
  end
end
function FromClient_OnDownloadFromWeb_Customizing(path, filename)
  if nil == string.find(filename, ".bdc", -4) then
    return
  end
  loadCustomizationData(filename, path)
end
registerEvent("FromClient_OnDownloadFromWeb", "FromClient_OnDownloadFromWeb_Customizing")

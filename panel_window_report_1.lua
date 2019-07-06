function PaGlobal_Report:initialize()
  if true == PaGlobal_Report._initialize then
    return
  end
  PaGlobal_Report._ui._stc_Main = UI.getChildControl(Panel_Window_Report, "Static_Main")
  for i = 1, PaGlobal_Report._value.classifyCount do
    PaGlobal_Report._ui._rdo_Classifys[i] = UI.getChildControl(PaGlobal_Report._ui._stc_Main, "RadioButton_" .. i)
  end
  PaGlobal_Report._ui._edit_Contents = UI.getChildControl(PaGlobal_Report._ui._stc_Main, "MultilineEdit_Content")
  PaGlobal_Report._ui.stc_BottomBG = UI.getChildControl(Panel_Window_Report, "Static_BottomBg")
  PaGlobal_Report._ui.stc_ConsoleUI_Y = UI.getChildControl(PaGlobal_Report._ui.stc_BottomBG, "StaticText_Y_ConsoleUI")
  PaGlobal_Report._ui.stc_ConsoleUI_A = UI.getChildControl(PaGlobal_Report._ui.stc_BottomBG, "StaticText_A_ConsoleUI")
  PaGlobal_Report._ui.stc_ConsoleUI_B = UI.getChildControl(PaGlobal_Report._ui.stc_BottomBG, "StaticText_B_ConsoleUI")
  local keyGuides = {
    PaGlobal_Report._ui.stc_ConsoleUI_Y,
    PaGlobal_Report._ui.stc_ConsoleUI_A,
    PaGlobal_Report._ui.stc_ConsoleUI_B
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, PaGlobal_Report._ui.stc_BottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  PaGlobal_Report._ui._edit_Contents:SetMaxInput(120)
  PaGlobal_Report._ui._edit_Contents:SetMaxEditLine(10)
  PaGlobal_Report._ui._edit_Contents:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_Report:registEventHandler()
  PaGlobal_Report._initialize = true
end
function PaGlobal_Report:registEventHandler()
  if nil == Panel_Window_Report then
    return
  end
  for i = 1, PaGlobal_Report._value.classifyCount do
    PaGlobal_Report._ui._rdo_Classifys[i]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventAUp_Report_SelectClassify(" .. i .. ")")
  end
  Panel_Window_Report:registerPadEvent(__eConsoleUIPadEvent_Up_X, "HandleEventXUp_Report_SetFocusEdit()")
  Panel_Window_Report:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "HandleEventYUp_Report_ReportingConfirm() ")
  PaGlobal_Report._ui._edit_Contents:setXboxVirtualKeyBoardEndEvent("HandleEvent_Report_VirtualKeyboardEnd")
end
function PaGlobal_Report:prepareOpen()
  if nil == Panel_Window_Report then
    return
  end
  PaGlobal_Report._value.classify = nil
  PaGlobal_Report._ui._edit_Contents:SetEditText(PaGlobal_Report._string.default)
  PaGlobal_Report:open()
end
function PaGlobal_Report:open()
  if nil == Panel_Window_Report then
    return
  end
  Panel_Window_Report:SetShow(true)
end
function PaGlobal_Report:prepareClose()
  if nil == Panel_Window_Report then
    return
  end
  if nil ~= PaGlobal_Report._value.classify then
    PaGlobal_Report._ui._rdo_Classifys[PaGlobal_Report._value.classify]:SetUnchecked()
  end
  PaGlobal_Report:close()
end
function PaGlobal_Report:close()
  if nil == Panel_Window_Report then
    return
  end
  Panel_Window_Report:SetShow(false)
end
function PaGlobal_Report:SetFocusEdit()
  if nil == Panel_Window_Report then
    return
  end
  if PaGlobal_Report._string.default == PaGlobal_Report._ui._edit_Contents:GetEditText() then
    PaGlobal_Report._ui._edit_Contents:SetEditText("")
  end
  SetFocusEdit(PaGlobal_Report._ui._edit_Contents)
end
function PaGlobal_Report:EndFocusEdit()
  if nil == Panel_Window_Report then
    return
  end
  CheckChattingInput()
  ClearFocusEdit()
  PaGlobal_Report._ui._edit_Contents:SetEditText(PaGlobal_Report._ui._edit_Contents)
end
function PaGlobal_Report:ReportingConfirm()
  if nil == Panel_Window_Report then
    return
  end
  if nil == PaGlobal_Report._value.classify then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_REPORT_SELECTTYPE"))
    return
  end
  local contentString = PaGlobal_Report._ui._edit_Contents:GetEditText()
  if PaGlobal_Report._string.default == contentString or "" == contentString then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_REPORT_CONTENTTITLE"))
    return
  end
  local reportConfirmYes = function()
    PaGlobal_Report:prepareClose()
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_REPORT_RECEIVEREPORT"))
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_REPORT_TITLE"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_REPORT_MESSAGECONFIRM"),
    functionYes = reportConfirmYes,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_Report:VirtualKeyboardEnd()
  if nil == Panel_Window_Report then
    return
  end
  CheckChattingInput()
  ClearFocusEdit()
  PaGlobal_Report._ui._edit_Contents:SetEditText(PaGlobal_Report._ui._edit_Contents)
end
function PaGlobal_Report:SetClassify(classify)
  if nil == Panel_Window_Report then
    return
  end
  PaGlobal_Report._value.classify = classify
end
function PaGlobal_Report:CheckUIEdit(classify)
  if nil == Panel_Window_Report then
    return
  end
  return nil ~= targetUI and targetUI:GetKey() == PaGlobal_Report._ui._edit_Contents:GetKey()
end

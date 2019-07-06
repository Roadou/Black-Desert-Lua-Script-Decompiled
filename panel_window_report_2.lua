function HandleEventAUp_Report_SelectClassify(classify)
  if nil == Panel_Window_Report then
    return
  end
  PaGlobal_Report:SetClassify(classify)
end
function HandleEventXUp_Report_SetFocusEdit()
  if nil == Panel_Window_Report then
    return
  end
  PaGlobal_Report:SetFocusEdit()
end
function HandleEventYUp_Report_ReportingConfirm()
  if nil == Panel_Window_Report then
    return
  end
  PaGlobal_Report:ReportingConfirm()
end
function HandleEvent_Report_VirtualKeyboardEnd()
  if nil == Panel_Window_Report then
    return
  end
  PaGlobal_Report:VirtualKeyboardEnd()
end
function PaGloabl_Report_CheckUIEdit(targetUI)
  if nil == Panel_Window_Report then
    return
  end
  PaGlobal_Report:CheckUIEdit()
end
function PaGloabl_Report_EndFocusEdit()
  if nil == Panel_Window_Report then
    return
  end
  PaGlobal_Report:EndFocusEdit()
end
function PaGloabl_Report_Open()
  if nil == Panel_Window_Report then
    return
  end
  PaGlobal_Report:prepareOpen()
end
function PaGloabl_Report_Close()
  if nil == Panel_Window_Report then
    return
  end
  PaGlobal_Report:prepareClose()
end

function FromClient_UIKeyguide_PadSnapChangePanel(fromPanel, toPanel)
  Panel_WidgetUIKeyguide:SetShow(false)
  PaGlobal_UIKeyguide._currentTargetPanel = toPanel
  if nil == PaGlobal_UIKeyguide._currentTargetPanel then
    return
  end
  PaGlobal_UIKeyguide._currentTargetGuideBg = toPanel:GetKeyguideBg()
  if nil == PaGlobal_UIKeyguide._currentTargetGuideBg then
    return
  end
  Panel_WidgetUIKeyguide:SetSize(PaGlobal_UIKeyguide._currentTargetGuideBg:GetSizeX(), PaGlobal_UIKeyguide._currentTargetGuideBg:GetSizeY())
  Panel_WidgetUIKeyguide:SetPosXY(PaGlobal_UIKeyguide._currentTargetGuideBg:GetPosX() + toPanel:GetPosX(), PaGlobal_UIKeyguide._currentTargetGuideBg:GetPosY() + toPanel:GetPosY())
  for _, control in ipairs(PaGlobal_UIKeyguide._keyGuideList) do
    if nil ~= control then
      control:ComputePos()
    end
  end
  for index, value in ipairs(PaGlobal_UIKeyguide._currentKeyguidetypeList) do
    PaGlobal_UIKeyguide._currentKeyguidetypeList[index] = false
  end
end
function FromClient_UIKeyguide_PadSnapChangeTarget()
  for index, value in ipairs(PaGlobal_UIKeyguide._currentKeyguidetypeList) do
    PaGlobal_UIKeyguide._currentKeyguidetypeList[index] = false
  end
end
function FromClient_UIKeyguide_ChangePadKeyGuide(padType, str)
  if "" == str then
    return
  end
  if __eConsoleUIPadEvent_Up_A == padType or __eConsoleUIPadEvent_A == padType then
    PaGlobal_UIKeyguide._currentKeyguidetypeList[1] = true
    PaGlobal_UIKeyguide._ui.stc_A_Keyguide:SetText(str)
  elseif __eConsoleUIPadEvent_Up_Y == padType or __eConsoleUIPadEvent_Y == padType then
    PaGlobal_UIKeyguide._currentKeyguidetypeList[2] = true
    PaGlobal_UIKeyguide._ui.stc_Y_Keyguide:SetText(str)
  elseif __eConsoleUIPadEvent_Up_X == padType or __eConsoleUIPadEvent_X == padType then
    PaGlobal_UIKeyguide._currentKeyguidetypeList[3] = true
    PaGlobal_UIKeyguide._ui.stc_X_Keyguide:SetText(str)
  elseif __eConsoleUIPadEvent_Up_B == padType or __eConsoleUIPadEvent_B == padType then
    PaGlobal_UIKeyguide._currentKeyguidetypeList[4] = true
    PaGlobal_UIKeyguide._ui.stc_B_Keyguide:SetText(str)
  end
end
function FromClient_UIKeyguide_PushPadKeyGuideEnd()
  if nil == PaGlobal_UIKeyguide._currentTargetGuideBg then
    return
  end
  if nil ~= PaGlobal_UIKeyguide._currentTargetPanel and true == PaGlobal_UIKeyguide._currentTargetPanel:IsSetCloseEvent() then
    PaGlobal_UIKeyguide._currentKeyguidetypeList[4] = true
    PaGlobal_UIKeyguide._ui.stc_B_Keyguide:SetText("Close")
  end
  for index, value in ipairs(PaGlobal_UIKeyguide._keyGuideList) do
    if nil ~= value then
      value:SetShow(PaGlobal_UIKeyguide._currentKeyguidetypeList[index])
    end
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_UIKeyguide._keyGuideList, Panel_WidgetUIKeyguide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  Panel_WidgetUIKeyguide:SetShow(true)
end

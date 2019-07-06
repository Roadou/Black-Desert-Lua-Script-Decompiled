if nil == UI then
  UI = {}
end
local debugText
debugPanel = UI.createPanel("DebugaaPanel", 9999)
debugPanel:SetSize(500, 20)
debugPanel:SetHorizonRight()
debugPanel:SetVerticalTop()
debugPanel:setFlushAble(false)
debugText = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, debugPanel, "StaticText_Debug")
debugText:SetSize(500, 20)
debugText:SetTextVerticalTop()
local dbgMsgLog = Array.new()
if nil == UI then
  UI = {}
end
function UI.debugMessage(msg)
  if 30 < dbgMsgLog:length() then
    dbgMsgLog:pop_front()
  end
  dbgMsgLog:push_back(msg)
  debugText:SetText(dbgMsgLog:toString())
end
function DebugPanel_MouseOn()
  debugPanel:SetSize(500, getScreenSizeY())
  debugText:SetSize(500, getScreenSizeY())
end
function DebugPanel_MouseOut()
  debugPanel:SetSize(500, 20)
  debugText:SetSize(500, 20)
end
debugPanel:addInputEvent("Mouse_On", "DebugPanel_MouseOn()")
debugPanel:addInputEvent("Mouse_Out", "DebugPanel_MouseOut()")

function PaGlobal_RandomMatch:initialize()
  if true == PaGlobal_RandomMatch._initialize then
    return
  end
  if nil == LobbyInstance_Widget_RandomMatch then
    return
  end
  PaGlobal_RandomMatch._ui._btnCancel = UI.getChildControl(LobbyInstance_Widget_RandomMatch, "Button_Cancel")
  PaGlobal_RandomMatch:registEventHandler()
  PaGlobal_RandomMatch:validate()
  LobbyInstance_Widget_RandomMatch:SetShow(false)
  PaGlobal_RandomMatch._isSearch = false
  PaGlobal_RandomMatch._initialize = true
end
function PaGlobal_RandomMatch:registEventHandler()
  if nil == PaGlobal_RandomMatch then
    return
  end
  PaGlobal_RandomMatch._ui._btnCancel:addInputEvent("Mouse_LUp", "PaGlobalFunc_RandomMatch_SearchCancel()")
  registerEvent("FromClient_RandomMatchAck", "FromClient_LobbyInstance_RandomMatchAck")
end
function PaGlobal_RandomMatch:open()
  if nil == LobbyInstance_Widget_RandomMatch then
    return
  end
  LobbyInstance_Widget_RandomMatch:SetShow(true)
end
function PaGlobal_RandomMatch:close()
  if nil == LobbyInstance_Widget_RandomMatch then
    return
  end
  LobbyInstance_Widget_RandomMatch:SetShow(false)
end
function PaGlobal_RandomMatch:validate()
  if nil == PaGlobal_RandomMatch then
    return
  end
  PaGlobal_RandomMatch._ui._btnCancel:isValidate()
end

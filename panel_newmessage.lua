Panel_NewMessage:SetShow(false, false)
PaGlobal_NewMessage = {
  _ui = {
    _btnClose = UI.getChildControl(Panel_NewMessage, "Button_Close"),
    _btnEnter = UI.getChildControl(Panel_NewMessage, "Button_Open"),
    _staticTitle = UI.getChildControl(Panel_NewMessage, "StaticTitle"),
    _staticText = UI.getChildControl(Panel_NewMessage, "StaticText")
  }
}
function PaGlobal_NewMessage:SetShow(isShow)
  self._isShow = isShow
  self._ui._btnClose:SetShow(isShow)
  self._ui._btnEnter:SetShow(isShow)
  self._ui._staticTitle:SetShow(isShow)
  self._ui._staticText:SetShow(isShow)
end
function PaGlobal_NewMessage:Initialize()
  self._ui._btnClose:addInputEvent("Mouse_LUp", "PaGlobal_NewMessage:Close()")
  self._ui._btnEnter:addInputEvent("Mouse_LUp", "PaGlobal_NewMessage:Open()")
  self._ui._staticText:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  self._ui._staticText:setLineCountByLimitAutoWrap(1)
end
function PaGlobal_NewMessage:Show()
  Panel_NewMessage:SetShow(true, true)
  if false == PaGlobal_NewMessage._isShow then
  end
end
function PaGlobal_NewMessage:Open()
  PaGlobal_NewMessage:Close()
  if true == _ContentsGroup_NewUI_Friend_All then
    PaGlobal_FriendList_Show_All()
  else
    FGlobal_FriendList_Show()
  end
end
function PaGlobal_NewMessage:Close()
  Panel_NewMessage:SetShow(false, true)
  if true == PaGlobal_NewMessage._isShow then
  end
end
function PaGlobal_NewMessage:Popup(userName, text)
  PaGlobal_NewMessage:Show()
  if false == self._isShow then
    self:SetShow(true)
  end
  self._ui._staticTitle:SetText(userName)
  self._ui._staticText:SetText(text)
end
function FGlobal_FriendList_Popup(userName, text)
  PaGlobal_NewMessage:Popup(userName, text)
end
function FGlobal_NewMessage_Close()
  PaGlobal_NewMessage:Close()
end
function FromClient_NotifyNewMessage(userName, text)
  PaGlobal_NewMessage:Popup(userName, text)
end
function FromClient_luaLoadComplete_NewMessage()
  ToClient_GetFriendList()
end
PaGlobal_NewMessage:Initialize()
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_NewMessage")
registerEvent("FromClient_NotifyNewMessage", "FromClient_NotifyNewMessage")

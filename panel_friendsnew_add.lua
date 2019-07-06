local _panel = Panel_FriendList_Add
_panel:ignorePadSnapMoveToOtherPanel()
local FriendListAdd = {
  _ui = {
    stc_CenterBg = UI.getChildControl(_panel, "Static_CenterBg"),
    stc_Bottom = UI.getChildControl(_panel, "Static_Bottom")
  },
  _keyguide = {}
}
function FriendListAdd:init()
  self._ui.edit_Nickname = UI.getChildControl(self._ui.stc_CenterBg, "Edit_Nickname")
  self._keyguide = {
    UI.getChildControl(self._ui.stc_Bottom, "StaticText_Cancel"),
    UI.getChildControl(self._ui.stc_Bottom, "StaticText_Apply")
  }
  self._ui.edit_Nickname:setXboxVirtualKeyBoardEndEvent("PaGlobal_FriendListAdd_EnterAddFriend")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobal_FriendListAdd_SetFocusEdit()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_FriendListAdd_SendAddFriend()")
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguide, self._ui.stc_Bottom, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  PaGlobal_registerPanelOnBlackBackground(_panel)
end
function FriendListAdd:open()
  self._ui.edit_Nickname:SetEditText("")
  _panel:SetShow(true)
end
function FriendListAdd:close()
  _panel:SetShow(false)
end
function PaGlobal_FriendListAdd_Open()
  local self = FriendListAdd
  self:open()
end
function PaGlobal_FriendListAdd_Close()
  local self = FriendListAdd
  self:close()
end
function PaGlobal_FriendListAdd_Init()
  local self = FriendListAdd
  self:init()
end
function PaGlobal_FriendListAdd_SetFocusEdit()
  local self = FriendListAdd
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  ClearFocusEdit()
  SetFocusEdit(self._ui.edit_Nickname)
  self._ui.edit_Nickname:SetEditText(self._ui.edit_Nickname:GetEditText(), true)
end
function PaGlobal_FriendListAdd_EnterAddFriend(str)
  local self = FriendListAdd
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self._ui.edit_Nickname:SetEditText(str, true)
  ClearFocusEdit()
  self._ui.edit_Nickname:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobal_FriendListAdd_SetFocusEdit()")
end
function PaGlobal_FriendListAdd_SendAddFriend()
  local self = FriendListAdd
  local friendStr = self._ui.edit_Nickname:GetEditText()
  if "" == friendStr then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_DETECTPLAYER_ERRORMSG_PLAYERNAME_NIL"),
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "FRIEND_TEXT_TITLE"),
    content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_XBOX_FRIEND_ADD_ALERT", "characterName", tostring(friendStr)),
    functionYes = PaGlobal_FriendListAdd_EnterAddFriendFunctionYes,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_FriendListAdd_EnterAddFriendFunctionYes()
  local self = FriendListAdd
  requestFriendList_addFriend(self._ui.edit_Nickname:GetEditText(), true)
  PaGlobal_FriendListAdd_Close()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_FriendListAdd_Init")

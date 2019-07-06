function PaGlobal_Chatting_FunctionList_ExcuteChattingFunc(index)
  if 0 ~= index and nil ~= PaGlobal_Chatting_FunctionList._chatFunc[index]._excuteFunc then
    PaGlobal_Chatting_FunctionList._chatFunc[index]._excuteFunc()
    PaGlobal_Chatting_FunctionList:prepareClose()
  end
end
function PaGlobal_Chatting_FunctionList_BlockList_Open()
  PaGlobal_Chatting_BlockList:prepareOpen()
end
function PaGlobal_Chatting_FunctionList_ViewProfileForPS()
  local xuid
  xuid = PaGlobalFunc_ChattingHistory_GetSelectedSenderXuid()
  if nil == xuid or xuid == "" then
    return
  end
  ToClient_showXboxFriendProfile(xuid)
end
function PaGlobal_Chatting_FunctionList_Wispher()
  local name = PaGlobalFunc_ChattingHistory_GetSelectedSender(ToClient_getChatNameType())
  if nil == name then
    return
  end
  PaGlobalFunc_ChattingInfo_DirectWhisperToNick(name)
end
function PaGlobal_Chatting_FunctionList_InviteParty()
  if false == ToClient_isCommunicationAllowed() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    ToClient_showPrivilegeError()
    return
  end
  local name = PaGlobalFunc_ChattingHistory_GetSelectedSenderForPartyInvite(ToClient_getChatNameType())
  if nil == name then
    return
  end
  RequestParty_inviteCharacter(name)
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERACTION_ACK_INVITE", "targetName", name))
end
function PaGlobal_Chatting_FunctionList_BlockUser()
  local famillyName = PaGlobalFunc_ChattingHistory_GetSelectedSender(1)
  if nil == famillyName then
    return
  end
  local curTabIndex = PaGlobalFunc_ChattingHistory_GetCurrentTabIndex()
  if nil == curTabIndex then
    return
  end
  local function chatBlock()
    ToClient_RequestBlockCharacter(curTabIndex - 1, famillyName)
  end
  local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHNATNEW_INTERCEPTION_MEMO", "clickedName", famillyName)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_CHNATNEW_INTERCEPTION_TITLE"),
    content = messageContent,
    functionYes = chatBlock,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_Chatting_FunctionList_AddFriend()
  local friendStr = PaGlobalFunc_ChattingHistory_GetSelectedSender(ToClient_getChatNameType())
  if "" == friendStr then
    return
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "FRIEND_TEXT_TITLE"),
    content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_XBOX_FRIEND_ADD_ALERT", "characterName", tostring(friendStr)),
    functionYes = PaGlobalFunc_ChattingInfo_AddFriend,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_ChattingInfo_AddFriend()
  local friendStr = PaGlobalFunc_ChattingHistory_GetSelectedSender(ToClient_getChatNameType())
  if "" == friendStr then
    return
  end
  requestFriendList_addFriend(friendStr, true)
end

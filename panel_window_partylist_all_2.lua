function PaGlobalFunc_PartyList_All_Open()
  PaGlobal_PartyList_All:prepareOpen()
end
function PaGlobalFunc_PartyList_All_Close()
  PaGlobal_PartyList_All:prepareClose()
end
function PaGlobalFunc_PartyList_All_Update()
  if nil == Panel_PartyList_All then
    return
  end
  if true == ToClient_isConsole() and true == Panel_PartyList_All:GetShow() then
    _AudioPostEvent_SystemUiForXBOX(50, 0)
  end
  ToClient_RequestListPartyRecruitment()
end
function HandleEventLUp_PartyList_All_SearchEdit()
  if nil == Panel_PartyList_All then
    return
  end
  SetFocusEdit(PaGlobal_PartyList_All._ui.edit_search)
  PaGlobal_PartyList_All._ui.edit_search:SetEditText(PaGlobal_PartyList_All._ui.edit_search:GetEditText(), true)
end
function HandleEventLUp_PartyList_All_DoSearch()
  if nil == Panel_PartyList_All then
    return
  end
  local msg = PaGlobal_PartyList_All._ui.edit_search:GetEditText()
  if "" == msg then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_SEARCHALERT"))
    return
  end
  local serverNo = 0
  ToClient_FilteredPartyRecruitmentList(serverNo, msg)
  ClearFocusEdit()
end
function HandleEventLUp_PartyList_All_Reset()
  if nil == Panel_PartyList_All then
    return
  end
  local serverNo = 0
  local msg = ""
  PaGlobal_PartyList_All._ui.edit_search:SetEditText(msg)
  ToClient_FilteredPartyRecruitmentList(serverNo, msg)
end
function PadEventXUp_PatyList_All_RecruiteShow()
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
  if false == PaGlobal_PartyList_All._canInvite then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FAVORITE_ALREADYREGIST"))
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  PaGlobalFunc_PartyRecruite_All_Open()
end
function HandleEventOn_PartyList_All_OnSelectButton(id, eType)
  if nil == Panel_PartyList_All then
    return
  end
  local partyWrapper = PaGlobal_PartyList_All._partySortTable[id]
  if nil == partyWrapper then
    return
  end
  PaGlobal_PartyList_All:setButtonText(eType)
end
function HandleEventLUp_PartyList_All_ClickSelectButton(index, eType, param1, param2)
  if nil == Panel_PartyList_All then
    return
  end
  local partyWrapper = PaGlobal_PartyList_All._partySortTable[index]
  if nil == partyWrapper then
    return
  end
  PaGlobal_PartyList_All:doAction(index, eType, param1, param2)
end
function HandleEventLUp_PartyList_All_Advertising(index)
  if nil == Panel_PartyList_All then
    return
  end
  if nil == index then
    return
  end
  local partyWrapper = ToClient_GetRecruitmentPartyListAt(index)
  if nil ~= partyWrapper then
    local adMsg = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_PARTYLIST_ADDVERSTISING_ADMSG", "title", partyWrapper:getTitle(), "level", partyWrapper:getMinLevel(), "count", partyWrapper:getCurrentCount())
    chatting_sendMessage("", adMsg, CppEnums.ChatType.World)
  end
end
function HandleEventLUp_PartyList_All_Cancle()
  if nil == Panel_PartyList_All then
    return
  end
  local party_Cancel = function()
    ToClient_RequestCancelRecruitPartyMember()
  end
  local memoTitle = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_MSGCANCELTITLE")
  local memoContent = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_MSGCANCELCONTENT")
  local messageBoxData = {
    title = memoTitle,
    content = memoContent,
    functionYes = party_Cancel,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleEventLUp_PartyList_All_Support(index)
  if nil == Panel_PartyList_All then
    return
  end
  if nil == index then
    return
  end
  local partyWrapper = ToClient_GetRecruitmentPartyListAt(index)
  if nil == partyWrapper then
    return
  end
  local partyNo = partyWrapper:getPartyNo()
  local serverNo = partyWrapper:getServerNo()
  local function requestJoinPartyRecruitment()
    if PaGlobalFunc_PartList_All_IsBlockedLeader(partyWrapper:getXuid()) then
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE")
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
        content = messageBoxMemo,
        functionYes = MessageBox_Empty_function,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    else
      ToClient_RequestJoinPartyRecruitment(partyNo, serverNo)
    end
  end
  local function requestBreakPartyRecruitment()
    ToClient_RequestBreakPartyRecruitment(partyNo, serverNo)
  end
  if ToClient_SelfPlayerIsGM() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_BREAK_PARTYRECRUITMENT_BY_MASTER")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = requestBreakPartyRecruitment,
      functionNo = requestJoinPartyRecruitment,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if PaGlobalFunc_PartList_All_IsBlockedLeader(partyWrapper:getXuid()) then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    ToClient_RequestJoinPartyRecruitment(partyNo, serverNo)
  end
end
function PaGlobalFunc_PartList_All_IsBlockedLeader(xuid)
  return ToClient_IsBlockedLeaderFromMe(xuid)
end
function HandleEventLUp_PartyList_All_WhisperToLeader(index)
  if nil == Panel_PartyList_All then
    return
  end
  if nil == index then
    return
  end
  local partyWrapper = ToClient_GetRecruitmentPartyListAt(index)
  if nil == partyWrapper then
    return
  end
  local leaderName = partyWrapper:getLeaderCharacterName()
  local title = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_MSGWHISPERTITLE")
  local content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PARTYLIST_MSGWHISPERDESC", "name", leaderName)
  local function party_Whisper()
    FGlobal_ChattingInput_ShowWhisper(leaderName)
  end
  local messageBoxData = {
    title = title,
    content = content,
    functionYes = party_Whisper,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleEventLUp_PartyList_All_MoveServer(serverNo, partyNo)
  if nil == Panel_PartyList_All then
    return
  end
  if nil == serverNo or nil == partyNo then
    return
  end
  local serverCount = getGameWorldServerDataCount()
  local curChannelData = getCurrentChannelServerData()
  local curWorldData = getGameWorldServerDataByWorldNo(curChannelData._worldNo)
  local channelCount = getGameChannelServerDataCount(curWorldData._worldNo)
  local channelName = getChannelName(curChannelData._worldNo, serverNo)
  local serverIndex
  for sIndex = 0, serverCount - 1 do
    for index = 0, channelCount - 1 do
      local serverData = getGameChannelServerDataByIndex(sIndex, index)
      if nil ~= serverData then
        local _serverNo = serverData._serverNo
        if serverNo == _serverNo then
          serverIndex = index
          break
        end
      end
    end
  end
  local function moveServer()
    if nil ~= serverIndex then
      gameExit_MoveChannel(serverIndex)
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELWAIT_MSG")
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"),
        content = messageBoxMemo,
        functionYes = nil,
        functionClose = nil,
        exitButton = true,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    end
  end
  local function requestBreakPartyRecruitment()
    ToClient_RequestBreakPartyRecruitment(partyNo, serverNo)
  end
  if ToClient_SelfPlayerIsGM() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_BREAK_PARTYRECRUITMENT_BY_MASTER")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = requestBreakPartyRecruitment,
      functionNo = moveServer,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  local memoTitle = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_MOVESERVER")
  local memoContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PARTYLIST_MSGMOVESERVERCONTENT", "serverName", channelName)
  local messageBoxData = {
    title = memoTitle,
    content = memoContent,
    functionYes = moveServer,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FromClient_PartyList_All_ResponsePartyRecruitmentInfo(param1)
  if nil == Panel_PartyList_All then
    return
  end
  if nil == param1 then
    return
  end
  if 0 == param1 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_REGISTALERT"))
  elseif 1 == param1 then
  elseif 2 == param1 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_CANCELALERT"))
  end
  PaGlobal_PartyList_All:update()
end
function FromClient_PartyList_All_RequestPartyJoin(guestActorKey, characterName, level, classType)
  if nil == Panel_PartyList_All then
    return
  end
  if nil == characterName or nil == classType then
    return
  end
  local function partyJoin()
    if true == ToClient_isConsole() then
      _AudioPostEvent_SystemUiForXBOX(50, 1)
    end
    RequestParty_inviteCharacter(characterName)
  end
  local className = getClassName(classType)
  local memoTitle = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLISTRECRUITE_ALERTTITLE")
  local memoContent = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_PARTYLISTRECRUITE_ALERTCONTENT", "name", characterName, "class", className, "level", level)
  local messageBoxData = {
    title = memoTitle,
    content = memoContent,
    functionYes = partyJoin,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FromClient_PartyList_All_Resize()
  if nil == Panel_PartyList_All then
    return
  end
  PaGlobal_PartyList_All:resize()
end
function PaGlobalFunc_PartyList_All_CheckUiEdit(targetUI)
  if nil == Panel_PartyList_All then
    return false
  end
  if nil == targetUI then
    return false
  end
  return targetUI:GetKey() == PaGlobal_PartyList_All._ui.edit_search:GetKey()
end
function PaGlobalFunc_PartyList_All_ClearFocusEdit()
  ClearFocusEdit()
  CheckChattingInput()
end

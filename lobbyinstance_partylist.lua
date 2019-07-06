Panel_PartyList:SetShow(false, false)
Panel_PartyList:setGlassBackground(true)
Panel_PartyList:SetDragAll(true)
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
local _stcMessageBG = UI.getChildControl(Panel_PartyList, "Static_MessageBG")
local partyList = {
  control = {
    _btnClose = UI.getChildControl(Panel_PartyList, "Button_Close"),
    _btnRecruite = UI.getChildControl(Panel_PartyList, "Button_Recruite"),
    _btnReload = UI.getChildControl(Panel_PartyList, "Button_Reload"),
    _editSearch = UI.getChildControl(Panel_PartyList, "Edit_Search"),
    _btnSearch = UI.getChildControl(Panel_PartyList, "Button_Search"),
    _btnReset = UI.getChildControl(Panel_PartyList, "Button_Reset"),
    _list2PartyList = UI.getChildControl(Panel_PartyList, "List2_PartyList"),
    _txtMessage = UI.getChildControl(_stcMessageBG, "StaticText_Message")
  }
}
function partyList:checkBlocked(index)
  local partyWrapper = ToClient_GetRecruitmentPartyListAt(index)
  if nil == partyWrapper then
    return false
  end
  local isBlocked = partyWrapper:isBlocked()
  local curChannelData = getCurrentChannelServerData()
  local myPartyNo = ToClient_GetPartyNo()
  local myServerNo = curChannelData._serverNo
  local partyNo = partyWrapper:getPartyNo()
  local serverNo = partyWrapper:getServerNo()
  if isBlocked and myPartyNo == partyNo and myServerNo == serverNo then
    return true
  elseif isBlocked then
    return false
  end
  return true
end
function partyList:Update()
  self.control._list2PartyList:getElementManager():clearKey()
  local partyListCount = ToClient_GetRecruitmentPartyListCount()
  if partyListCount > 0 then
    for index = 0, partyListCount - 1 do
      if partyList:checkBlocked(index) then
        self.control._list2PartyList:getElementManager():pushKey(toInt64(0, index))
      end
    end
  end
  ClearFocusEdit()
  FGlobal_PartyListClearFocusEdit()
end
function PartyListControlCreate(control, key)
  local bg = UI.getChildControl(control, "Static_Bg")
  local myBg = UI.getChildControl(control, "Static_MyServerBg")
  local content = UI.getChildControl(control, "StaticText_Content")
  local level = UI.getChildControl(control, "StaticText_Level")
  local count = UI.getChildControl(control, "StaticText_Count")
  local leader = UI.getChildControl(control, "StaticText_PartyLeader")
  local server = UI.getChildControl(control, "StaticText_ServerName")
  local btnSupport = UI.getChildControl(control, "Button_Support")
  local btnAd = UI.getChildControl(control, "Button_Advertise")
  btnAd:SetAutoDisableTime(60)
  content:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  bg:SetShow(true)
  myBg:SetShow(false)
  local _key = Int64toInt32(key)
  local partyWrapper = ToClient_GetRecruitmentPartyListAt(_key)
  if nil ~= partyWrapper then
    if partyWrapper:isBlocked() then
      content:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BLOCKED_PARTYRECRUITMENT_BY_MASTER"))
    else
      content:SetText(partyWrapper:getTitle())
    end
    level:SetText(tostring(partyWrapper:getMinLevel()))
    count:SetText(partyWrapper:getCurrentCount() .. "/5")
    leader:SetText(partyWrapper:getLeaderCharacterName())
    local serverNo = partyWrapper:getServerNo()
    local curChannelData = getCurrentChannelServerData()
    local currentServerNo = curChannelData._serverNo
    local channelName = getChannelName(curChannelData._worldNo, serverNo)
    local curWorldData = getGameWorldServerDataByWorldNo(curChannelData._worldNo)
    local channelMoveableGlobalTime = getChannelMoveableTime(curWorldData._worldNo)
    local channelMoveableRemainTime = getChannelMoveableRemainTime(curWorldData._worldNo)
    local restrictedServerNo = curWorldData._restrictedServerNo
    local partyNo = partyWrapper:getPartyNo()
    server:SetText(channelName)
    btnSupport:SetShow(false)
    btnAd:SetShow(false)
    leader:addInputEvent("Mouse_LUp", "")
    leader:addInputEvent("Mouse_RUp", "")
    local isPartyEmpty = ToClient_IsPartyEmpty()
    local isPartyLeader = RequestParty_isLeader()
    local myPartyNo = ToClient_GetPartyNo()
    if currentServerNo == serverNo then
      if myPartyNo == partyNo then
        if isPartyLeader then
          btnSupport:SetShow(true)
          btnSupport:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_CANCEL"))
          btnSupport:addInputEvent("Mouse_LUp", "PartyList_Cancel()")
          btnAd:SetShow(true)
          btnAd:addInputEvent("Mouse_LUp", "PartyList_Advertising(" .. _key .. ")")
          leader:addInputEvent("Mouse_LUp", "")
          leader:addInputEvent("Mouse_RUp", "")
          content:SetFontColor(Defines.Color.C_FFFFF3AF)
          level:SetFontColor(Defines.Color.C_FFFFF3AF)
          count:SetFontColor(Defines.Color.C_FFFFF3AF)
          leader:SetFontColor(Defines.Color.C_FFFFF3AF)
          server:SetFontColor(Defines.Color.C_FFFFF3AF)
          btnSupport:SetFontColor(Defines.Color.C_FFFFF3AF)
        end
      elseif isPartyEmpty then
        btnSupport:SetShow(true)
        btnSupport:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_SUPPORT"))
        btnSupport:addInputEvent("Mouse_LUp", "PartyList_Support(" .. _key .. ")")
        leader:addInputEvent("Mouse_LUp", "PartyList_WhisperToLeader(" .. _key .. ")")
        leader:addInputEvent("Mouse_RUp", "PartyList_WhisperToLeader(" .. _key .. ")")
      end
      bg:SetShow(false)
      myBg:SetShow(true)
    else
      local busyState = 0
      local channelCount = getGameChannelServerDataCount(curWorldData._worldNo)
      if channelCount > 0 then
        for index = 0, channelCount - 1 do
          local serverData = getGameChannelServerDataByWorldNo(curWorldData._worldNo, index)
          if nil ~= serverData and serverData._serverNo == serverNo then
            busyState = serverData._busyState
            break
          end
        end
      end
      local isAdmission = true
      local isSiegeBeing = deadMessage_isSiegeBeingMyChannel()
      local isInSiegeBattle = deadMessage_isInSiegeBattle()
      if true == isSiegeBeing and false == isInSiegeBattle then
        isAdmission = true
      elseif restrictedServerNo ~= 0 and toInt64(0, 0) ~= channelMoveableGlobalTime then
        if restrictedServerNo == currentServerNo then
          isAdmission = true
        elseif channelMoveableRemainTime > toInt64(0, 0) then
          isAdmission = false
        else
          isAdmission = true
        end
      end
      isAdmission = isAdmission and 0 ~= busyState
      if isAdmission and isPartyEmpty then
        btnSupport:SetShow(true)
        btnSupport:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_MOVESERVER"))
        btnSupport:addInputEvent("Mouse_LUp", "PartyList_MoveServer(" .. serverNo .. ", " .. partyNo .. ")")
        leader:addInputEvent("Mouse_LUp", "PartyList_WhisperToLeader(" .. _key .. ")")
        leader:addInputEvent("Mouse_RUp", "PartyList_WhisperToLeader(" .. _key .. ")")
      end
    end
  end
end
function PartyList_WhisperToLeader(index)
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
function PartyList_Advertising(index)
  local partyWrapper = ToClient_GetRecruitmentPartyListAt(index)
  if nil ~= partyWrapper then
    local adMsg = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_PARTYLIST_BATTLEROYAL_ADMSG", "title", partyWrapper:getTitle(), "mapname", PAGetString(Defines.StringSheet_GAME, "BATTLE_ROYALE_REWARD_MAIL_SENDER"), "count", partyWrapper:getCurrentCount())
    chatting_sendMessage("", adMsg, CppEnums.ChatType.World)
  end
end
function PartyList_Cancel()
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
function PartList_IsBlockedLeader(xuid)
  return ToClient_IsBlockedLeaderFromMe(xuid)
end
function PartyList_Support(index)
  local partyWrapper = ToClient_GetRecruitmentPartyListAt(index)
  if nil == partyWrapper then
    return
  end
  local partyNo = partyWrapper:getPartyNo()
  local serverNo = partyWrapper:getServerNo()
  local function requestJoinPartyRecruitment()
    if PartList_IsBlockedLeader(partyWrapper:getXuid()) then
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
  if PartList_IsBlockedLeader(partyWrapper:getXuid()) then
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
function PartyList_MoveServer(serverNo, partyNo)
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
function partyList:Show()
  audioPostEvent_SystemUi(1, 29)
  Panel_PartyList:SetShow(true, true)
  ToClient_RequestListPartyRecruitment()
  Panel_PartyList:SetPosX(getScreenSizeX() / 2 - Panel_PartyList:GetSizeX() / 2)
  Panel_PartyList:SetPosY(getScreenSizeY() / 2 - Panel_PartyList:GetSizeY() / 2 - 100)
  HandleClicked_PartyList_Reset()
end
function partyList:Hide()
  audioPostEvent_SystemUi(1, 1)
  Panel_PartyList:SetShow(false, false)
  ClearFocusEdit()
  FGlobal_PartyListClearFocusEdit()
end
function FGlobal_CheckPartyListUiEdit(targetUI)
  return nil ~= targetUI and targetUI:GetKey() == partyList.control._editSearch:GetKey()
end
function FGlobal_PartyListClearFocusEdit()
  ClearFocusEdit()
  CheckChattingInput()
end
function FGlobal_PartyList_ShowToggle()
  if Panel_PartyList:GetShow() then
    partyList:Hide()
  else
    partyList:Show()
  end
  partyList.control._txtMessage:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  partyList.control._txtMessage:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_RULE_9"))
end
function FromClient_ResponsePartyRecruitmentInfo(param1)
  if 0 == param1 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_REGISTALERT"))
  elseif 1 == param1 then
  elseif 2 == param1 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_CANCELALERT"))
  end
  partyList:Update()
end
function FromClient_RequestPartyJoin(guestActorKey, characterName, level, classType)
  local function partyJoin()
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
function PartyList_Update()
  ToClient_RequestListPartyRecruitment()
end
function HandleClicked_PartyList_SearchEdit()
  local self = partyList
  SetFocusEdit(self.control._editSearch)
  self.control._editSearch:SetEditText(self.control._editSearch:GetEditText(), true)
end
function HandleClicked_PartyList_DoSearch()
  local self = partyList
  local msg = self.control._editSearch:GetEditText()
  if "" == msg then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_SEARCHALERT"))
    return
  end
  local serverNo = 0
  ToClient_FilteredPartyRecruitmentList(serverNo, msg)
end
function HandleClicked_PartyList_Reset()
  local serverNo = 0
  local msg = ""
  partyList.control._editSearch:SetEditText(msg)
  ToClient_FilteredPartyRecruitmentList(serverNo, msg)
end
function partyList:RegisterEvent()
  registerEvent("FromClient_ResponsePartyRecruitmentInfo", "FromClient_ResponsePartyRecruitmentInfo")
  registerEvent("FromClient_RequestPartyJoin", "FromClient_RequestPartyJoin")
  self.control._list2PartyList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PartyListControlCreate")
  self.control._list2PartyList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self.control._btnRecruite:addInputEvent("Mouse_LUp", "FGlobal_PartyListRecruite_Show()")
  self.control._btnClose:addInputEvent("Mouse_LUp", "FGlobal_PartyList_ShowToggle()")
  self.control._btnReload:addInputEvent("Mouse_LUp", "PartyList_Update()")
  self.control._editSearch:addInputEvent("Mouse_LUp", "HandleClicked_PartyList_SearchEdit()")
  self.control._btnSearch:addInputEvent("Mouse_LUp", "HandleClicked_PartyList_DoSearch()")
  self.control._btnReset:addInputEvent("Mouse_LUp", "HandleClicked_PartyList_Reset()")
end
partyList:RegisterEvent()

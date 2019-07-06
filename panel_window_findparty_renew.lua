local Panel_Window_FindParty_info = {
  _ui = {
    list2_PartyList = nil,
    static_BottomBG = nil,
    staticText_Y_ConsoleUI = nil,
    staticText_X_ConsoleUI = nil,
    staticText_A_ConsoleUI = nil,
    staticText_B_ConsoleUI = nil
  },
  _value = {canInvite = true},
  _config = {},
  _enum = {
    eTYPE_RECRUITE_NONE = -1,
    eTYPE_RECRUITE = 0,
    eTYPE_RECRUITE_CANCEL = 1,
    eTYPE_CHANGE_SERVER = 2,
    eTYPE_ADVERTISING = 3,
    eALIGN_TYPE_LEFT = 0,
    eALIGN_TYPE_RIGHT = 1,
    eALIGN_TYPE_CENTER = 2
  },
  _string = {
    recruite = "",
    recruiteCancel = "",
    changeServer = ""
  },
  _keyGuideControl = {
    [__eConsoleUIPadEvent_A] = nil,
    [__eConsoleUIPadEvent_X] = nil
  },
  _keyGuideAlign = {},
  _partySortTable = {}
}
function Panel_Window_FindParty_info:registEventHandler()
  Panel_PartyList:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_FindParty_RecruiteShow()")
  Panel_PartyList:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_FindParty_ReLoad()")
  registerEvent("FromClient_ResponsePartyRecruitmentInfo", "FromClientw_FindParty_RecruitmentInfo")
  registerEvent("FromClient_RequestPartyJoin", "FromClientw_FindParty_Join")
  registerEvent("ResponseParty_createPartyList", "PaGlobalFunc_FindParty_Update")
  registerEvent("ResponseParty_withdraw", "PaGlobalFunc_FindParty_Update")
  registerEvent("onScreenResize", "FromCliente_FindParty_Resize")
end
function Panel_Window_FindParty_info:initialize()
  self:childControl()
  self:initValue()
  self:initString()
  self:resize()
  self:registEventHandler()
end
function Panel_Window_FindParty_info:initValue()
  self._value.canInvite = true
end
function Panel_Window_FindParty_info:initString()
  self._string.recruite = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_SUPPORT")
  self._string.recruiteCancel = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_CANCEL")
  self._string.changeServer = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_MOVESERVER")
end
function Panel_Window_FindParty_info:resize()
  Panel_PartyList:ComputePos()
end
function Panel_Window_FindParty_info:childControl()
  self._ui.static_BottomBG = UI.getChildControl(Panel_PartyList, "Static_BottomBG")
  self._ui.staticText_Y_ConsoleUI = UI.getChildControl(self._ui.static_BottomBG, "StaticText_Y_ConsoleUI")
  self._ui.staticText_X_ConsoleUI = UI.getChildControl(self._ui.static_BottomBG, "StaticText_X_ConsoleUI")
  self._ui.staticText_A_ConsoleUI = UI.getChildControl(self._ui.static_BottomBG, "StaticText_A_ConsoleUI")
  self._ui.staticText_B_ConsoleUI = UI.getChildControl(self._ui.static_BottomBG, "StaticText_B_ConsoleUI")
  self._keyGuideControl[__eConsoleUIPadEvent_A] = self._ui.staticText_A_ConsoleUI
  self._keyGuideControl[__eConsoleUIPadEvent_X] = self._ui.staticText_X_ConsoleUI
  self._keyGuideAlign = {
    self._ui.staticText_Y_ConsoleUI,
    self._ui.staticText_X_ConsoleUI,
    self._ui.staticText_A_ConsoleUI,
    self._ui.staticText_B_ConsoleUI
  }
  self._ui.list2_PartyList = UI.getChildControl(Panel_PartyList, "List2_PartyList")
  self._ui.list2_PartyList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_FindParty_List")
  self._ui.list2_PartyList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function Panel_Window_FindParty_info:checkAddAlready(index, isPartyLeader)
  local partyWrapper = self._partySortTable[index]
  if nil == partyWrapper then
    return
  end
  local myPartyNo = ToClient_GetPartyNo()
  local partyNo = partyWrapper._getPartyNo
  if true == isPartyLeader and myPartyNo == partyNo then
    self._value.canInvite = false
  end
end
function Panel_Window_FindParty_info:checkBlocked(index)
  local partyWrapper = self._partySortTable[index]
  if nil == partyWrapper then
    return false
  end
  local isBlocked = partyWrapper._isBlocked
  local partyNo = partyWrapper._getPartyNo
  local serverNo = partyWrapper._getServerNo
  local myPartyNo = ToClient_GetPartyNo()
  local curChannelData = getCurrentChannelServerData()
  local myServerNo = curChannelData._serverNo
  if isBlocked and myPartyNo == partyNo and myServerNo == serverNo then
    return true
  elseif isBlocked then
    return false
  end
  return true
end
function Panel_Window_FindParty_info:updateContent()
  self._ui.list2_PartyList:getElementManager():clearKey()
  local isPartyLeader = RequestParty_isLeader()
  self._value.canInvite = true
  self:reloadPartyData()
  local partyListCount = ToClient_GetRecruitmentPartyListCount() + 10
  if partyListCount > 0 then
    for index = 0, partyListCount - 1 do
      if true == self:checkBlocked(index) then
        self:checkAddAlready(index, isPartyLeader)
        self._ui.list2_PartyList:getElementManager():pushKey(toInt64(0, index))
      end
    end
  end
  ClearFocusEdit()
  FGlobal_PartyListClearFocusEdit()
  self:setButtonText()
end
function Panel_Window_FindParty_info:open()
  if false == Panel_PartyList:GetShow() then
    _AudioPostEvent_SystemUiForXBOX(1, 29)
  end
  if true == ToClient_isPS4() and false == ToClient_isUserCreateContentsAllowed() then
    ToClient_SystemMsgDialogPS4(__ePS4SystemMsgDialogType_TRC_PSN_UGC_RESTRICTION)
    return
  end
  Panel_PartyList:SetShow(true)
end
function Panel_Window_FindParty_info:close()
  Panel_PartyList:SetShow(false)
end
function Panel_Window_FindParty_info:setKeyGuidePos()
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui.static_BottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Panel_Window_FindParty_info:setButtonText(eType)
  if self._enum.eTYPE_RECRUITE_NONE == eType then
    self._keyGuideControl[__eConsoleUIPadEvent_A]:SetShow(false)
  elseif self._enum.eTYPE_RECRUITE == eType then
    self._keyGuideControl[__eConsoleUIPadEvent_A]:SetText(self._string.recruite)
    self._keyGuideControl[__eConsoleUIPadEvent_A]:SetShow(true)
  elseif self._enum.eTYPE_RECRUITE_CANCEL == eType then
    self._keyGuideControl[__eConsoleUIPadEvent_A]:SetText(self._string.recruiteCancel)
    self._keyGuideControl[__eConsoleUIPadEvent_A]:SetShow(true)
  elseif self._enum.eTYPE_CHANGE_SERVER == eType then
    self._keyGuideControl[__eConsoleUIPadEvent_A]:SetText(self._string.changeServer)
    self._keyGuideControl[__eConsoleUIPadEvent_A]:SetShow(true)
  else
    self._keyGuideControl[__eConsoleUIPadEvent_A]:SetText(self._string.recruite)
    self._keyGuideControl[__eConsoleUIPadEvent_A]:SetShow(false)
  end
  if false == self._value.canInvite then
    self._keyGuideControl[__eConsoleUIPadEvent_X]:SetShow(false)
  else
    self._keyGuideControl[__eConsoleUIPadEvent_X]:SetShow(true)
  end
  self:setKeyGuidePos()
end
function Panel_Window_FindParty_info:doAction(index, eType, serverNo, partyNo)
  if self._enum.eTYPE_RECRUITE == eType then
    self:support(index)
  elseif self._enum.eTYPE_RECRUITE_CANCEL == eType then
    self:recruiteCancel()
  elseif self._enum.eTYPE_CHANGE_SERVER == eType then
    self:moveServer(serverNo, partyNo)
  end
end
function Panel_Window_FindParty_info:advertising(index)
  local partyWrapper = self._partySortTable[index]
  if nil == partyWrapper then
    return
  end
  local adMsg = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_PARTYLIST_ADDVERSTISING_ADMSG", "title", partyWrapper._getTitle, "level", partyWrapper._getMinLevel, "count", partyWrapper._getCurrentCount)
  chatting_sendMessage("", adMsg, CppEnums.ChatType.World)
end
function Panel_Window_FindParty_info:isBlockedLeader(xuid)
  return ToClient_IsBlockedLeaderFromMe(xuid)
end
function Panel_Window_FindParty_info:support(index)
  local partyWrapper = self._partySortTable[index]
  if nil == partyWrapper then
    return
  end
  local partyNo = partyWrapper._getPartyNo
  local serverNo = partyWrapper._getServerNo
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
  local function requestJoinPartyRecruitment()
    if self:isBlockedLeader(partyWrapper._getXuid) then
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
  if self:isBlockedLeader(partyWrapper._getXuid) then
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
function Panel_Window_FindParty_info:recruiteCancel()
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
function Panel_Window_FindParty_info:moveServer(serverNo, partyNo)
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
function PaGlobalFunc_FindParty_GetShow()
  return Panel_PartyList:GetShow()
end
function PaGlobalFunc_FindParty_Open()
  local self = Panel_Window_FindParty_info
  self:open()
end
function PaGlobalFunc_FindParty_Close()
  local self = Panel_Window_FindParty_info
  self:close()
end
function PaGlobalFunc_FindParty_Show()
  PaGlobalFunc_FindParty_ReLoad()
  local self = Panel_Window_FindParty_info
  self:updateContent()
  self:open()
end
function PaGlobalFunc_FindParty_Exit()
  local self = Panel_Window_FindParty_info
  self:close()
  PaGlobalFunc_FindPartyRecruite_ExitAll()
end
function PaGlobalFunc_FindParty_RecruiteShow()
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
  local self = Panel_Window_FindParty_info
  if false == self._value.canInvite then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FAVORITE_ALREADYREGIST"))
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  PaGlobalFunc_FindPartyRecruite_Show()
end
function PaGlobalFunc_FindParty_Update()
  if true == PaGlobalFunc_FindParty_GetShow() then
    ToClient_RequestListPartyRecruitment()
  end
end
function PaGlobalFunc_FindParty_ReLoad()
  if Panel_PartyList:GetShow() then
    _AudioPostEvent_SystemUiForXBOX(50, 0)
  end
  ToClient_RequestListPartyRecruitment()
end
function PaGlobalFunc_FindParty_OnSelectButton(id, eType)
  local self = Panel_Window_FindParty_info
  local partyWrapper = self._partySortTable[id]
  if nil == partyWrapper then
    return
  end
  self:setButtonText(eType)
end
function PaGlobalFunc_FindParty_ClickSelectButton(index, eType, param1, param2)
  local self = Panel_Window_FindParty_info
  local partyWrapper = self._partySortTable[index]
  if nil == partyWrapper then
    return
  end
  self:doAction(index, eType, param1, param2)
end
function PaGlobalFunc_FindParty_List(list_content, key)
  local self = Panel_Window_FindParty_info
  local id = Int64toInt32(key)
  local partyWrapper = self._partySortTable[id]
  if nil == partyWrapper then
    return
  end
  local static_Bg = UI.getChildControl(list_content, "Static_Bg")
  local staticText_AdDesc = UI.getChildControl(list_content, "StaticText_AdDesc")
  local staticText_Level = UI.getChildControl(list_content, "StaticText_Level")
  local staticText_MemberCount = UI.getChildControl(list_content, "StaticText_MemberCount")
  local staticText_Leader = UI.getChildControl(list_content, "StaticText_Leader")
  local staticText_Server = UI.getChildControl(list_content, "StaticText_Server")
  list_content:addInputEvent("Mouse_LUp", "")
  list_content:addInputEvent("Mouse_On", "")
  staticText_AdDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  if true == partyWrapper._isBlocked then
    staticText_AdDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BLOCKED_PARTYRECRUITMENT_BY_MASTER"))
  else
    staticText_AdDesc:SetText(partyWrapper._getTitle)
  end
  staticText_Level:SetText(tostring(partyWrapper._getMinLevel))
  staticText_MemberCount:SetText(partyWrapper._getCurrentCount .. "/5")
  staticText_Leader:SetText(partyWrapper._getLeaderCharacterName)
  local serverNo = partyWrapper._getServerNo
  local curChannelData = getCurrentChannelServerData()
  local currentServerNo = curChannelData._serverNo
  local channelName = getChannelName(curChannelData._worldNo, serverNo)
  local curWorldData = getGameWorldServerDataByWorldNo(curChannelData._worldNo)
  local channelMoveableGlobalTime = getChannelMoveableTime(curWorldData._worldNo)
  local channelMoveableRemainTime = getChannelMoveableRemainTime(curWorldData._worldNo)
  local restrictedServerNo = curWorldData._restrictedServerNo
  local partyNo = partyWrapper._getPartyNo
  if nil ~= channelName then
    staticText_Server:SetText(channelName)
  end
  static_Bg:addInputEvent("Mouse_On", "PaGlobalFunc_FindParty_OnSelectButton(" .. id .. "," .. self._enum.eTYPE_RECRUITE_NONE .. ")")
  static_Bg:addInputEvent("Mouse_LUp", "")
  local isPartyEmpty = ToClient_IsPartyEmpty()
  local isPartyLeader = RequestParty_isLeader()
  local myPartyNo = ToClient_GetPartyNo()
  if currentServerNo == serverNo then
    if myPartyNo == partyNo then
      if isPartyLeader then
        static_Bg:addInputEvent("Mouse_On", "PaGlobalFunc_FindParty_OnSelectButton(" .. id .. "," .. self._enum.eTYPE_RECRUITE_CANCEL .. ")")
        static_Bg:addInputEvent("Mouse_LUp", "PaGlobalFunc_FindParty_ClickSelectButton(" .. id .. "," .. self._enum.eTYPE_RECRUITE_CANCEL .. ")")
        staticText_Level:SetFontColor(Defines.Color.C_FFFFF3AF)
        staticText_MemberCount:SetFontColor(Defines.Color.C_FFFFF3AF)
        staticText_Leader:SetFontColor(Defines.Color.C_FFFFF3AF)
        staticText_Server:SetFontColor(Defines.Color.C_FFFFF3AF)
      end
    elseif isPartyEmpty then
      static_Bg:addInputEvent("Mouse_On", "PaGlobalFunc_FindParty_OnSelectButton(" .. id .. "," .. self._enum.eTYPE_RECRUITE .. ")")
      static_Bg:addInputEvent("Mouse_LUp", "PaGlobalFunc_FindParty_ClickSelectButton(" .. id .. "," .. self._enum.eTYPE_RECRUITE .. ")")
    end
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
      static_Bg:addInputEvent("Mouse_On", "PaGlobalFunc_FindParty_OnSelectButton(" .. id .. "," .. self._enum.eTYPE_RECRUITE .. ")")
      static_Bg:addInputEvent("Mouse_LUp", "PaGlobalFunc_FindParty_ClickSelectButton(" .. id .. "," .. self._enum.eTYPE_RECRUITE .. "," .. serverNo .. "," .. partyNo .. ")")
    end
  end
end
function Panel_Window_FindParty_info:reloadPartyData()
  local partyListCount = ToClient_GetRecruitmentPartyListCount()
  local self = Panel_Window_FindParty_info
  local sortPointer = 0
  local curChannelData = getCurrentChannelServerData()
  local currentServerNo = curChannelData._serverNo
  self._partySortTable = {}
  for index = 0, partyListCount do
    local partyWrapper = ToClient_GetRecruitmentPartyListAt(index)
    if nil ~= partyWrapper then
      local partyData = {}
      partyData._isBlocked = partyWrapper:isBlocked()
      partyData._getTitle = partyWrapper:getTitle()
      partyData._getMinLevel = partyWrapper:getMinLevel()
      partyData._getCurrentCount = partyWrapper:getCurrentCount()
      partyData._getLeaderCharacterName = partyWrapper:getLeaderCharacterName()
      partyData._getServerNo = partyWrapper:getServerNo()
      partyData._getPartyNo = partyWrapper:getPartyNo()
      partyData._getXuid = partyWrapper:getXuid()
      partyData._realIndex = index
      if currentServerNo == partyData._getServerNo then
        if sortPointer == index then
          self._partySortTable[sortPointer] = partyData
        else
          local tempData = self._partySortTable[sortPointer]
          self._partySortTable[sortPointer] = partyData
          self._partySortTable[index] = tempData
        end
        sortPointer = sortPointer + 1
      else
        self._partySortTable[index] = partyData
      end
    end
  end
end
function FromClient_FindParty_Init()
  local self = Panel_Window_FindParty_info
  self:initialize()
end
function FromClientw_FindParty_RecruitmentInfo(param1)
  if 0 == param1 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_REGISTALERT"))
  elseif 1 == param1 then
  elseif 2 == param1 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_CANCELALERT"))
  end
  local self = Panel_Window_FindParty_info
  self:updateContent()
end
function FromClientw_FindParty_Join(guestActorKey, characterName, level, classType)
  local function partyJoin()
    _AudioPostEvent_SystemUiForXBOX(50, 1)
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
function FromCliente_FindParty_Resize()
  Panel_Window_FindParty_info:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_FindParty_Init")

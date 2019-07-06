function PaGlobal_PartyList_All:initialize()
  if true == PaGlobal_PartyList_All._initialize then
    return
  end
  self:controlAll_Init()
  self:controlPc_Init()
  self:controlConsole_Init()
  self:controlSetShow()
  self:registEventHandler()
  self:validate()
  self._initialize = true
end
function PaGlobal_PartyList_All:controlAll_Init()
  if nil == Panel_PartyList_All then
    return
  end
  Panel_PartyList_All:SetShow(false, false)
  Panel_PartyList_All:setGlassBackground(true)
  Panel_PartyList_All:SetDragAll(true)
  Panel_PartyList_All:SetIgnore(false)
  self._ui.stc_titleBar = UI.getChildControl(Panel_PartyList_All, "Static_MainTitleBar")
  self._ui.stc_topBg = UI.getChildControl(Panel_PartyList_All, "Static_TopBg_PCUI")
  self._ui.edit_search = UI.getChildControl(self._ui.stc_topBg, "Edit_Search")
  self._ui.btn_search = UI.getChildControl(self._ui.edit_search, "Button_Search")
end
function PaGlobal_PartyList_All:controlPc_Init()
  if nil == Panel_PartyList_All then
    return
  end
  self._ui_pc.btn_close = UI.getChildControl(self._ui.stc_titleBar, "Button_Close_PCUI")
  self._ui_pc.btn_question = UI.getChildControl(self._ui.stc_titleBar, "Button_Question_PCUI")
  self._ui_pc.btn_popUp = UI.getChildControl(self._ui.stc_titleBar, "CheckButton_PopUp_PCUI")
  self._ui_pc.btn_reload = UI.getChildControl(self._ui.stc_topBg, "Button_Reload")
  self._ui_pc.btn_recruite = UI.getChildControl(self._ui.stc_topBg, "Button_Recruite")
  self._ui_pc.btn_reset = UI.getChildControl(self._ui.stc_topBg, "Button_Reset")
  self._ui_pc.stc_listTitleBg = UI.getChildControl(Panel_PartyList_All, "Static_TitleBg_PCUI")
  self._ui_pc.list2_party = UI.getChildControl(Panel_PartyList_All, "List2_PartyList_PCUI")
end
function PaGlobal_PartyList_All:controlConsole_Init()
  if nil == Panel_PartyList_All then
    return
  end
  self._ui_console.stc_listTitleBg = UI.getChildControl(Panel_PartyList_All, "Static_TitleBg_ConsoleUI")
  self._ui_console.stc_bottomBg = UI.getChildControl(Panel_PartyList_All, "Static_BottomBG_ConsoleUI")
  self._ui_console.stc_Y_ConsoleUI = UI.getChildControl(self._ui_console.stc_bottomBg, "StaticText_Y_ConsoleUI")
  self._ui_console.stc_X_ConsoleUI = UI.getChildControl(self._ui_console.stc_bottomBg, "StaticText_X_ConsoleUI")
  self._ui_console.stc_A_ConsoleUI = UI.getChildControl(self._ui_console.stc_bottomBg, "StaticText_A_ConsoleUI")
  self._ui_console.stc_B_ConsoleUI = UI.getChildControl(self._ui_console.stc_bottomBg, "StaticText_B_ConsoleUI")
  self._ui_console.stc_search_LT = UI.getChildControl(self._ui.stc_topBg, "Static_SearchIconLT")
  self._ui_console.stc_search_X = UI.getChildControl(self._ui.stc_topBg, "Static_SearchIconX")
  self._keyGuideControl[__eConsoleUIPadEvent_A] = self._ui_console.stc_A_ConsoleUI
  self._keyGuideControl[__eConsoleUIPadEvent_X] = self._ui_console.stc_X_ConsoleUI
  self._keyGuideAlign = {
    self._ui_console.stc_Y_ConsoleUI,
    self._ui_console.stc_X_ConsoleUI,
    self._ui_console.stc_A_ConsoleUI,
    self._ui_console.stc_B_ConsoleUI
  }
  self._canInvite = true
  self._string.recruite = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_SUPPORT")
  self._string.recruiteCancel = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_CANCEL")
  self._string.changeServer = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_MOVESERVER")
  self._ui_console.list2_party = UI.getChildControl(Panel_PartyList_All, "List2_PartyList_ConsoleUI")
end
function PaGlobal_PartyList_All:controlSetShow()
  if nil == Panel_PartyList_All then
    return
  end
  if false == ToClient_isConsole() then
    self._ui_pc.btn_close:SetShow(true)
    self._ui_pc.btn_question:SetShow(false)
    self._ui_pc.btn_popUp:SetShow(false)
    self._ui_pc.btn_reload:SetShow(true)
    self._ui_pc.btn_recruite:SetShow(true)
    self._ui_pc.btn_reset:SetShow(true)
    self._ui_pc.stc_listTitleBg:SetShow(true)
    self._ui_pc.list2_party:SetShow(true)
    self._ui_console.stc_listTitleBg:SetShow(false)
    self._ui_console.stc_bottomBg:SetShow(false)
    self._ui_console.stc_search_LT:SetShow(false)
    self._ui_console.stc_search_X:SetShow(false)
    self._ui_console.list2_party:SetShow(false)
  else
    self._ui_pc.btn_close:SetShow(false)
    self._ui_pc.btn_question:SetShow(false)
    self._ui_pc.btn_popUp:SetShow(false)
    self._ui_pc.btn_reload:SetShow(false)
    self._ui_pc.btn_recruite:SetShow(false)
    self._ui_pc.btn_reset:SetShow(false)
    self._ui_pc.stc_listTitleBg:SetShow(false)
    self._ui_pc.list2_party:SetShow(false)
    self._ui_console.stc_listTitleBg:SetShow(true)
    self._ui_console.stc_bottomBg:SetShow(true)
    self._ui_console.stc_Y_ConsoleUI:SetShow(true)
    self._ui_console.stc_X_ConsoleUI:SetShow(true)
    self._ui_console.stc_A_ConsoleUI:SetShow(true)
    self._ui_console.stc_B_ConsoleUI:SetShow(true)
    self._ui_console.stc_search_LT:SetShow(true)
    self._ui_console.stc_search_X:SetShow(true)
    self._ui_console.list2_party:SetShow(true)
  end
end
function PaGlobal_PartyList_All:resize()
  if nil == Panel_PartyList_All then
    return
  end
  Panel_PartyList_All:SetPosX(getScreenSizeX() / 2 - Panel_PartyList_All:GetSizeX() / 2)
  Panel_PartyList_All:SetPosY(getScreenSizeY() / 2 - Panel_PartyList_All:GetSizeY() / 2 - 100)
  if false == ToClient_isConsole() then
    self._ui.edit_search:SetSize(840, 50)
    self._ui.edit_search:SetSpanSize(270, 0)
  else
    self._ui.edit_search:SetSize(1220, 50)
    self._ui.edit_search:SetSpanSize(10, 0)
  end
  Panel_PartyList_All:ComputePos()
  self._ui.edit_search:ComputePos()
  self._ui.btn_search:ComputePos()
  self._ui_pc.btn_close:ComputePos()
  self._ui_pc.btn_question:ComputePos()
  self._ui_pc.btn_popUp:ComputePos()
  self._ui_pc.btn_reload:ComputePos()
  self._ui_pc.btn_recruite:ComputePos()
  self._ui_pc.btn_reset:ComputePos()
  self._ui_pc.stc_listTitleBg:ComputePos()
  self._ui_pc.list2_party:ComputePos()
  self._ui_console.stc_listTitleBg:ComputePos()
  self._ui_console.stc_bottomBg:ComputePos()
  self._ui_console.stc_search_LT:ComputePos()
  self._ui_console.stc_search_X:ComputePos()
  self._ui_console.list2_party:ComputePos()
end
function PaGlobal_PartyList_All:prepareOpen()
  if nil == Panel_PartyList_All then
    return
  end
  if false == _ContentsGroup_NewUI_PartyFind_All then
    return
  end
  if true == ToClient_isPS4() and false == ToClient_isUserCreateContentsAllowed() then
    ToClient_SystemMsgDialogPS4(__ePS4SystemMsgDialogType_TRC_PSN_UGC_RESTRICTION)
    return
  end
  ToClient_RequestListPartyRecruitment()
  HandleEventLUp_PartyList_All_Reset()
  PaGlobal_PartyList_All:resize()
  PaGlobal_PartyList_All:open()
end
function PaGlobal_PartyList_All:open()
  if nil == Panel_PartyList_All then
    return
  end
  audioPostEvent_SystemUi(1, 29)
  Panel_PartyList_All:SetShow(true)
end
function PaGlobal_PartyList_All:prepareClose()
  if nil == Panel_PartyList_All then
    return
  end
  PaGlobalFunc_PartyList_All_ClearFocusEdit()
  if nil ~= PaGlobalFunc_PartyRecruite_All_GetShow and true == PaGlobalFunc_PartyRecruite_All_GetShow() then
    PaGlobalFunc_PartyRecruite_All_Close()
  end
  audioPostEvent_SystemUi(1, 1)
  PaGlobal_PartyList_All:close()
end
function PaGlobal_PartyList_All:close()
  if nil == Panel_PartyList_All then
    return
  end
  Panel_PartyList_All:SetShow(false)
end
function PaGlobal_PartyList_All:update()
  if nil == Panel_PartyList_All then
    return
  end
  if false == ToClient_isConsole() then
    self._ui_pc.list2_party:getElementManager():clearKey()
    local partyListCount = ToClient_GetRecruitmentPartyListCount()
    if partyListCount > 0 then
      for index = 0, partyListCount - 1 do
        if true == self:checkBlocked(index) then
          self._ui_pc.list2_party:getElementManager():pushKey(toInt64(0, index))
        end
      end
    end
  else
    self._ui_console.list2_party:getElementManager():clearKey()
    self._canInvite = true
    local partyListCount = ToClient_GetRecruitmentPartyListCount()
    local isPartyLeader = RequestParty_isLeader()
    self:reloadPartyData()
    if partyListCount > 0 then
      for index = 0, partyListCount - 1 do
        if true == self:checkBlocked(index) then
          self:checkAddAlready(index, isPartyLeader)
          self._ui_console.list2_party:getElementManager():pushKey(toInt64(0, index))
        end
      end
    end
    self:setButtonText()
  end
  PaGlobalFunc_PartyList_All_ClearFocusEdit()
end
function PaGlobal_PartyList_All:validate()
  if nil == Panel_PartyList_All then
    return
  end
  self._ui.stc_titleBar:isValidate()
  self._ui.stc_topBg:isValidate()
  self._ui.edit_search:isValidate()
  self._ui.btn_search:isValidate()
  if false == ToClient_isConsole() then
    self._ui_pc.btn_close:isValidate()
    self._ui_pc.btn_question:isValidate()
    self._ui_pc.btn_popUp:isValidate()
    self._ui_pc.btn_reload:isValidate()
    self._ui_pc.btn_recruite:isValidate()
    self._ui_pc.btn_reset:isValidate()
    self._ui_pc.stc_listTitleBg:isValidate()
    self._ui_pc.list2_party:isValidate()
  else
    self._ui_console.stc_listTitleBg:isValidate()
    self._ui_console.stc_bottomBg:isValidate()
    self._ui_console.list2_party:isValidate()
    self._ui_console.stc_Y_ConsoleUI:isValidate()
    self._ui_console.stc_X_ConsoleUI:isValidate()
    self._ui_console.stc_A_ConsoleUI:isValidate()
    self._ui_console.stc_B_ConsoleUI:isValidate()
    self._ui_console.stc_search_LT:isValidate()
    self._ui_console.stc_search_X:isValidate()
  end
end
function PaGlobal_PartyList_All:registEventHandler()
  if nil == Panel_PartyList_All then
    return
  end
  if false == ToClient_isConsole() then
    self._ui_pc.btn_reset:addInputEvent("Mouse_LUp", "HandleEventLUp_PartyList_All_Reset()")
    self._ui.edit_search:addInputEvent("Mouse_LUp", "HandleEventLUp_PartyList_All_SearchEdit()")
    self._ui.btn_search:addInputEvent("Mouse_LUp", "HandleEventLUp_PartyList_All_DoSearch()")
    self._ui_pc.btn_recruite:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyRecruite_All_Open()")
    self._ui_pc.btn_reload:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyList_All_Update()")
    self._ui_pc.btn_close:addInputEvent("Mouse_LUp", "PaGlobalFunc_PartyList_All_Close()")
    self._ui_pc.list2_party:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_PartyList_All_ControlCreate")
    self._ui_pc.list2_party:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  else
    Panel_PartyList_All:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PadEventXUp_PatyList_All_RecruiteShow()")
    Panel_PartyList_All:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_PartyList_All_Update()")
    Panel_PartyList_All:registerPadEvent(__eConsoleUIPadEvent_LTPress_X, "HandleEventLUp_PartyList_All_SearchEdit()")
    if ToClient_IsDevelopment() then
      self._ui.edit_search:RegistReturnKeyEvent("HandleEventLUp_PartyList_All_DoSearch()")
    else
      self._ui.edit_search:setXboxVirtualKeyBoardEndEvent("HandleEventLUp_PartyList_All_DoSearch")
    end
    self._ui_console.list2_party:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_PartyList_All_ControlCreate")
    self._ui_console.list2_party:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  end
  registerEvent("ResponseParty_createPartyList", "PaGlobalFunc_PartyList_All_Update")
  registerEvent("ResponseParty_withdraw", "PaGlobalFunc_PartyList_All_Update")
  registerEvent("FromClient_ResponsePartyRecruitmentInfo", "FromClient_PartyList_All_ResponsePartyRecruitmentInfo")
  registerEvent("FromClient_RequestPartyJoin", "FromClient_PartyList_All_RequestPartyJoin")
  registerEvent("onScreenResize", "FromClient_PartyList_All_Resize")
end
function PaGlobal_PartyList_All:checkBlocked(index)
  if nil == index then
    _PA_ASSERT(false, "PaGlobal_PartyList_All:checkBlocked .. \237\140\140\237\139\176 \235\170\168\236\167\145\236\160\149\235\179\180\236\157\152 index\234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164.")
    return false
  end
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
function PaGlobal_PartyList_All:checkAddAlready(index, isPartyLeader)
  if nil == index or nil == isPartyLeader then
    _PA_ASSERT(false, "PaGlobal_PartyList_All:checkAddAlready .. index \235\152\144\235\138\148 isPartyLeader \234\176\146\236\157\180 \235\147\164\236\150\180\236\152\164\236\167\128 \236\149\138\236\149\132 _canInvite \236\132\164\236\160\149\236\157\180 \235\144\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164.")
    return
  end
  local partyWrapper = self._partySortTable[index]
  if nil == partyWrapper then
    return
  end
  local myPartyNo = ToClient_GetPartyNo()
  local partyNo = partyWrapper._getPartyNo
  if true == isPartyLeader and myPartyNo == partyNo then
    self._canInvite = false
  end
end
function PaGlobal_PartyList_All:setButtonText(eType)
  if nil == Panel_PartyList_All then
    return
  end
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
  if false == self._canInvite then
    self._keyGuideControl[__eConsoleUIPadEvent_X]:SetShow(false)
  else
    self._keyGuideControl[__eConsoleUIPadEvent_X]:SetShow(true)
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui_console.stc_bottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobal_PartyList_All:doAction(index, eType, serverNo, partyNo)
  if self._enum.eTYPE_RECRUITE == eType then
    self:support(index)
  elseif self._enum.eTYPE_RECRUITE_CANCEL == eType then
    self:recruiteCancel()
  elseif self._enum.eTYPE_CHANGE_SERVER == eType then
    self:moveServer(serverNo, partyNo)
  end
end
function PaGlobal_PartyList_All:isBlockedLeader(xuid)
  return ToClient_IsBlockedLeaderFromMe(xuid)
end
function PaGlobal_PartyList_All:support(index)
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
function PaGlobal_PartyList_All:recruiteCancel()
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
function PaGlobal_PartyList_All:moveServer(serverNo, partyNo)
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
function PaGlobal_PartyList_All:reloadPartyData()
  local partyListCount = ToClient_GetRecruitmentPartyListCount()
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
function PaGlobalFunc_PartyList_All_ControlCreate(control, key)
  local bg = UI.getChildControl(control, "Static_Bg")
  local content = UI.getChildControl(control, "StaticText_Content")
  local level = UI.getChildControl(control, "StaticText_Level")
  local count = UI.getChildControl(control, "StaticText_Count")
  local leader = UI.getChildControl(control, "StaticText_PartyLeader")
  local server = UI.getChildControl(control, "StaticText_ServerName")
  local _key = Int64toInt32(key)
  local partyWrapper = ToClient_GetRecruitmentPartyListAt(_key)
  if nil == partyWrapper then
    return
  end
  local myBg, btnSupport, btnAd
  if false == ToClient_isConsole() then
    myBg = UI.getChildControl(control, "Static_MyServerBg")
    btnSupport = UI.getChildControl(control, "Button_Support")
    btnAd = UI.getChildControl(control, "Button_Advertise")
    myBg:SetShow(false)
    btnAd:SetAutoDisableTime(60)
    btnAd:SetShow(false)
    btnSupport:SetShow(false)
  else
    control:addInputEvent("Mouse_LUp", "")
    control:addInputEvent("Mouse_On", "")
    bg:addInputEvent("Mouse_On", "HandleEventOn_PartyList_All_OnSelectButton(" .. _key .. "," .. PaGlobal_PartyList_All._enum.eTYPE_RECRUITE_NONE .. ")")
    bg:addInputEvent("Mouse_LUp", "")
  end
  bg:SetShow(true)
  level:SetText(tostring(partyWrapper:getMinLevel()))
  count:SetText(partyWrapper:getCurrentCount() .. "/5")
  leader:SetText(partyWrapper:getLeaderCharacterName())
  content:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  if partyWrapper:isBlocked() then
    content:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BLOCKED_PARTYRECRUITMENT_BY_MASTER"))
  else
    content:SetText(partyWrapper:getTitle())
  end
  local serverNo = partyWrapper:getServerNo()
  local curChannelData = getCurrentChannelServerData()
  local currentServerNo = curChannelData._serverNo
  local channelName = getChannelName(curChannelData._worldNo, serverNo)
  local curWorldData = getGameWorldServerDataByWorldNo(curChannelData._worldNo)
  local channelMoveableGlobalTime = getChannelMoveableTime(curWorldData._worldNo)
  local channelMoveableRemainTime = getChannelMoveableRemainTime(curWorldData._worldNo)
  local restrictedServerNo = curWorldData._restrictedServerNo
  local partyNo = partyWrapper:getPartyNo()
  if nil ~= channelName then
    server:SetText(channelName)
  end
  leader:addInputEvent("Mouse_LUp", "")
  leader:addInputEvent("Mouse_RUp", "")
  local isPartyEmpty = ToClient_IsPartyEmpty()
  local isPartyLeader = RequestParty_isLeader()
  local myPartyNo = ToClient_GetPartyNo()
  if currentServerNo == serverNo then
    if myPartyNo == partyNo then
      if true == isPartyLeader then
        if false == ToClient_isConsole() then
          btnSupport:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_CANCEL"))
          btnSupport:addInputEvent("Mouse_LUp", "HandleEventLUp_PartyList_All_Cancle()")
          btnAd:addInputEvent("Mouse_LUp", "HandleEventLUp_PartyList_All_Advertising(" .. _key .. ")")
          btnSupport:SetShow(true)
          btnAd:SetShow(true)
          btnAd:SetIgnore(false)
          content:SetFontColor(Defines.Color.C_FFFFF3AF)
          btnSupport:SetFontColor(Defines.Color.C_FFFFF3AF)
        else
          bg:addInputEvent("Mouse_On", "HandleEventOn_PartyList_All_OnSelectButton(" .. _key .. "," .. PaGlobal_PartyList_All._enum.eTYPE_RECRUITE_CANCEL .. ")")
          bg:addInputEvent("Mouse_LUp", "HandleEventLUp_PartyList_All_ClickSelectButton(" .. _key .. "," .. PaGlobal_PartyList_All._enum.eTYPE_RECRUITE_CANCEL .. ")")
        end
        level:SetFontColor(Defines.Color.C_FFFFF3AF)
        count:SetFontColor(Defines.Color.C_FFFFF3AF)
        leader:SetFontColor(Defines.Color.C_FFFFF3AF)
        server:SetFontColor(Defines.Color.C_FFFFF3AF)
      end
      if false == ToClient_isConsole() then
        myBg:SetSize(1110, 40)
        myBg:SetSpanSize(50, 0)
        bg:SetSize(1110, 40)
        bg:SetSpanSize(50, 5)
      end
    else
      if true == isPartyEmpty then
        if false == ToClient_isConsole() then
          btnSupport:SetShow(true)
          btnSupport:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_SUPPORT"))
          btnSupport:addInputEvent("Mouse_LUp", "HandleEventLUp_PartyList_All_Support(" .. _key .. ")")
          leader:SetIgnore(false)
          leader:addInputEvent("Mouse_LUp", "HandleEventLUp_PartyList_All_WhisperToLeader(" .. _key .. ")")
          leader:addInputEvent("Mouse_RUp", "HandleEventLUp_PartyList_All_WhisperToLeader(" .. _key .. ")")
        else
          bg:addInputEvent("Mouse_On", "HandleEventOn_PartyList_All_OnSelectButton(" .. _key .. "," .. PaGlobal_PartyList_All._enum.eTYPE_RECRUITE .. ")")
          bg:addInputEvent("Mouse_LUp", "HandleEventLUp_PartyList_All_ClickSelectButton(" .. _key .. "," .. PaGlobal_PartyList_All._enum.eTYPE_RECRUITE .. ")")
        end
      end
      if false == ToClient_isConsole() then
        myBg:SetSize(1158, 40)
        myBg:SetSpanSize(2, 0)
        bg:SetSize(1158, 40)
        bg:SetSpanSize(2, 5)
      end
    end
    if false == ToClient_isConsole() then
      myBg:SetShow(true)
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
      if false == ToClient_isConsole() then
        btnSupport:SetShow(true)
        btnSupport:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLIST_MOVESERVER"))
        btnSupport:addInputEvent("Mouse_LUp", "HandleEventLUp_PartyList_All_MoveServer(" .. serverNo .. ", " .. partyNo .. ")")
        leader:addInputEvent("Mouse_LUp", "HandleEventLUp_PartyList_All_WhisperToLeader(" .. _key .. ")")
        leader:addInputEvent("Mouse_RUp", "HandleEventLUp_PartyList_All_WhisperToLeader(" .. _key .. ")")
      else
        bg:addInputEvent("Mouse_On", "HandleEventOn_PartyList_All_OnSelectButton(" .. _key .. "," .. PaGlobal_PartyList_All._enum.eTYPE_RECRUITE .. ")")
        bg:addInputEvent("Mouse_LUp", "HandleEventLUp_PartyList_All_ClickSelectButton(" .. _key .. "," .. PaGlobal_PartyList_All._enum.eTYPE_RECRUITE .. "," .. serverNo .. "," .. partyNo .. ")")
      end
    end
  end
end

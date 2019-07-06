local _panel = Panel_Widget_Chatting_Renew
local CHAT_TYPE = CppEnums.ChatType
local _isInitialized = false
local ChattingInfo = {
  _ui = {
    stc_BG = UI.getChildControl(_panel, "Static_BG"),
    stc_highlight = nil,
    edit_chatContent = nil,
    stc_triangleLeft = nil,
    stc_triangleRight = nil,
    stc_channelList = {},
    stc_keyGuide = nil,
    txt_keyGuideX = nil,
    stc_whisperBG = UI.getChildControl(_panel, "Static_WhisperBG"),
    txt_keyGuideLTA = nil,
    txt_keyGuideLTX = nil,
    edit_whisperTarget = nil,
    stc_macroBG = UI.getChildControl(_panel, "Static_MacroListBG"),
    list2_macro = nil,
    stc_selectedMacro = nil
  },
  _curChatMsgCnt = 0,
  _sentChatMsgCnt = 0,
  lastChatHistory = "",
  _lastChatType = CHAT_TYPE.Public,
  _curWhisperMsgCnt = 0,
  permissions = Array.new(),
  _availableChannelList = {},
  _currentChatTypeIndex = 1,
  maxEditInput = 100,
  linkedItemCount = 0,
  maxLinkedItemCount = 1,
  linkedItemData = {
    [0] = nil
  },
  _keyguideAlign = {},
  _currentMacro = 0,
  _macroList = {},
  _macroMaxCount = 10
}
local _chatTypeUV = {
  [CHAT_TYPE.Undefine] = nil,
  [CHAT_TYPE.Notice] = {
    2,
    218,
    80,
    244
  },
  [CHAT_TYPE.World] = {
    2,
    137,
    80,
    163
  },
  [CHAT_TYPE.Public] = {
    2,
    83,
    80,
    109
  },
  [CHAT_TYPE.Private] = {
    2,
    29,
    80,
    55
  },
  [CHAT_TYPE.System] = {
    2,
    191,
    80,
    217
  },
  [CHAT_TYPE.Party] = {
    2,
    164,
    80,
    190
  },
  [CHAT_TYPE.Guild] = {
    2,
    110,
    80,
    136
  },
  [CHAT_TYPE.Client] = nil,
  [CHAT_TYPE.Alliance] = {
    54,
    96,
    108,
    120
  },
  [CHAT_TYPE.Friend] = nil,
  [CHAT_TYPE.GameInfo3] = nil,
  [CHAT_TYPE.WorldWithItem] = {
    2,
    2,
    80,
    28
  },
  [CHAT_TYPE.Battle] = nil,
  [CHAT_TYPE.LocalWar] = {
    140,
    2,
    218,
    28
  },
  [CHAT_TYPE.RolePlay] = {
    140,
    29,
    218,
    55
  },
  [CHAT_TYPE.NoticeOnlyTop] = nil,
  [CHAT_TYPE.Arsha] = {
    140,
    56,
    218,
    82
  },
  [CHAT_TYPE.Team] = {
    2,
    56,
    80,
    82
  },
  [CHAT_TYPE.Count] = nil
}
local isLocalWar = ToClient_IsContentsGroupOpen("43")
local isArsha = ToClient_IsContentsGroupOpen("227")
local isSavageDefence = ToClient_IsContentsGroupOpen("249")
local isWolrdChat = ToClient_IsContentsGroupOpen("231")
function FromClient_luaLoadComplete_Chatting_Init()
  ChattingInfo:initialize()
end
local isDirectChattingInput = false
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Chatting_Init")
registerEvent("FromClient_DirectChattingInputForXBox", "FromClient_DirectChattingInputForXBox")
function FromClient_DirectChattingInputForXBox(inputType)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if false == inputType then
    isDirectChattingInput = true
  else
    if false == ToClient_isCheckRenderModeGame() then
      return
    end
    if true == _panel:GetShow() then
      Input_ChattingInfo_OnPadX()
      return
    end
    if nil == GetFocusEdit() then
      isDirectChattingInput = true
      PaGlobalFunc_ChattingInfo_Open()
    end
  end
end
function ChattingInfo:initialize()
  self._ui.stc_highlight = UI.getChildControl(self._ui.stc_BG, "Static_Highlight")
  self._ui.edit_chatContent = UI.getChildControl(self._ui.stc_BG, "Edit_Input")
  self._ui.stc_triangleLeft = UI.getChildControl(self._ui.stc_BG, "Static_TriangleLeft")
  self._ui.stc_triangleRight = UI.getChildControl(self._ui.stc_BG, "Static_TriangleRight")
  self._ui.stc_keyGuide = UI.getChildControl(_panel, "Static_KeyGuide")
  self._ui.txt_keyGuideB = UI.getChildControl(self._ui.stc_keyGuide, "StaticText_KeyGuideB")
  self._ui.txt_keyGuideA = UI.getChildControl(self._ui.stc_keyGuide, "StaticText_KeyGuideA")
  self._ui.txt_keyGuideX = UI.getChildControl(self._ui.stc_keyGuide, "StaticText_KeyGuideX")
  self._ui.txt_keyGuideY = UI.getChildControl(self._ui.stc_keyGuide, "StaticText_KeyGuideY")
  self._ui.txt_keyGuideRT = UI.getChildControl(self._ui.stc_keyGuide, "StaticText_KeyGuideRT")
  self._ui.txt_keyGuideLTA = UI.getChildControl(self._ui.stc_keyGuide, "StaticText_KeyGuideLTA")
  self._ui.txt_keyGuideLTX = UI.getChildControl(self._ui.stc_keyGuide, "StaticText_KeyGuideLTX")
  self._ui.txt_keyGuideLTX:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_XBOX_PROFILE"))
  self._ui.txt_keyGuideDPadUD = UI.getChildControl(self._ui.stc_keyGuide, "StaticText_KeyGuideDPadUpDown")
  self._ui.txt_keyGuideDPadLR = UI.getChildControl(self._ui.stc_keyGuide, "StaticText_KeyGuideDPadLeftRight")
  self._keyguideAlign = {
    self._ui.txt_keyGuideLTA,
    self._ui.txt_keyGuideLTX,
    self._ui.txt_keyGuideDPadUD,
    self._ui.txt_keyGuideDPadLR,
    self._ui.txt_keyGuideRT,
    self._ui.txt_keyGuideY,
    self._ui.txt_keyGuideA,
    self._ui.txt_keyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguideAlign, self._ui.stc_keyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_BOTTOM)
  self.permissions:resize(CHAT_TYPE.Count, false)
  self._ui.edit_whisperTarget = UI.getChildControl(self._ui.stc_whisperBG, "Edit_WhisperTarget")
  self._ui.txt_keyGuideXForWhisper = UI.getChildControl(self._ui.stc_whisperBG, "StaticText_KeyGuideXForWhisper")
  for ii = 1, CHAT_TYPE.Count - 1 do
    self._ui.stc_channelList[ii] = UI.getChildControl(self._ui.stc_BG, "Static_Channel_" .. ii)
  end
  self._ui.list2_macro = UI.getChildControl(self._ui.stc_macroBG, "List2_Macro")
  self._ui.list2_macro:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_ChattingInfo_PushMacro")
  self._ui.list2_macro:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.stc_selectedMacro = UI.getChildControl(self._ui.stc_macroBG, "Static_SelectionBox")
  self:initMacroList()
  self:registEventHandler()
  self:registMessageHandler()
  if isGameTypeKorea() then
    self.maxEditInput = 200
  elseif isGameTypeEnglish() then
    self.maxEditInput = 100
  else
    self.maxEditInput = 100
  end
  self._ui.edit_chatContent:SetMaxInput(self.maxEditInput)
  self._ui.edit_whisperTarget:SetMaxInput(self.maxEditInput)
  _isInitialized = true
end
function ChattingInfo:initMacroList()
  self._macroList = {}
  self._macroList[0] = ""
  for ii = 1, self._macroMaxCount do
    self._macroList[ii] = PAGetString(Defines.StringSheet_GAME, "GAME_BASIC_DIALOGUE_" .. ii)
    self._ui.list2_macro:getElementManager():pushKey(ii)
  end
end
function ChattingInfo:registEventHandler()
  if true == ToClient_isConsole() and false == ToClient_IsDevelopment() then
    self._ui.edit_whisperTarget:setXboxVirtualKeyBoardEndEvent("PaGlobalFunc_ChattingInfo_WhisperName")
    self._ui.edit_chatContent:setXboxVirtualKeyBoardEndEvent("Input_ChattingInfo_OnVirtualKeyboardEnd")
  else
    self._ui.edit_whisperTarget:RegistReturnKeyEvent("PaGlobalFunc_ChattingInfo_WhisperName()")
    self._ui.edit_chatContent:RegistReturnKeyEvent("Input_ChattingInfo_OnVirtualKeyboardEnd()")
  end
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_ChattingInfo_PressedEnter()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_ChattingInfo_OnPadX()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Y, "InputPadY_ChattingInfo_MacroShowToggle(true)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "InputPadY_ChattingInfo_MacroShowToggle(false)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_YPress_DpadUp, "InputPadX_ChattingInfo_MacroMoveSelect(true)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_YPress_DpadDown, "InputPadX_ChattingInfo_MacroMoveSelect(false)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LTPress_A, "Input_ChattingInfo_PressedLTA()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LTPress_X, "Input_ChattingInfo_PressedLTX()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RT, "Input_ChattingInfo_PressedRT()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "Input_ChattingInfo_SetNextChatType(false)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "Input_ChattingInfo_SetNextChatType(true)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "Input_ChattingInfo_SelectInHistory(true)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "Input_ChattingInfo_SelectInHistory(false)")
  registerEvent("EventChatInputClose", "PaGlobalFunc_ChattingInfo_Close")
  registerEvent("EventChatPermissionChanged", "PaGlobalFunc_ChattingInfo_UpdatePermission")
end
function ChattingInfo:registMessageHandler()
end
function PaGlobalFunc_ChattingInfo_PushMacro(content, key)
  local self = ChattingInfo
  local index = Int64toInt32(key)
  local stc_BG = UI.getChildControl(content, "Static_MacroBG")
  local txt_macro = UI.getChildControl(stc_BG, "StaticText_MacroTemplate")
  txt_macro:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  txt_macro:SetText(self._macroList[index])
end
function PaGlobalFunc_ChattingInfo_GetShow()
  return Panel_Widget_Chatting_Renew:GetShow()
end
function PaGlobalFunc_ChattingInfo_Open()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  PaGlobalFunc_ChattingViewer_Off()
  ChattingInfo:open()
  if true == isDirectChattingInput then
    Input_ChattingInfo_OnPadX()
  end
  if _panel:GetShow() then
    PaGlobalFunc_ChattingViewer_Off()
  end
  isDirectChattingInput = false
end
function ChattingInfo:open()
  if _panel:GetShow() then
    return
  end
  close_WindowPanelList()
  if MessageBox.isPopUp() then
    postProcessMessageData()
  end
  if Panel_QuickMenuCustom_RightRing:GetShow() then
    PanelEscapeFunc_QuickMenuCustom()
  end
  if Panel_Window_VoiceChat:GetShow() then
    PaGlobalFunc_VoiceChat_Close()
  end
  if PaGlobal_MailDetail_GetShow() then
    PaGlobal_MailDetail_Close()
  end
  if Panel_Window_Mail_Renew:GetShow() then
    Mail_Close()
  end
  if Panel_Window_Menu_Renew:GetShow() then
    Panel_Window_Menu_ShowToggle()
  end
  if Panel_Window_Knowledge_Renew:GetShow() then
    PaGlobalFunc_Window_Knowledge_Exit()
  end
  FGlobal_PetList_Close(true)
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    PaGlobalFunc_WorkerManager_All_Close()
  else
    PaGlobalFunc_WorkerManager_Close()
  end
  if PaGlobalFunc_AlchemyKnowledgeCheckShow() then
    PaGlobalFunc_AlchemyKnowledgeClose()
  end
  if PaGlobalFunc_ManufactureCheckShow() then
    PaGlobalFunc_ManufactureClose()
  end
  _panel:SetShow(true)
  PaGlobalFunc_ChattingInfo_UpdatePermission()
  self:setChatTypeTo(self._availableChannelList[self._currentChatTypeIndex])
  self._ui.stc_macroBG:SetShow(false)
  if chatting_isBlocked() then
    local blockString = convertStringFromDatetime(chatting_blockedEndDatetime())
    local blockReason = tostring(chatting_blockedReasonMemo())
    local tempString = PAGetStringParam2(Defines.StringSheet_GAME, "CHATTING_BLOCK_TIME_REASON", "time", blockString, "reason", blockReason)
    self._ui.edit_chatContent:SetText("<PAColor0xFF888888>" .. tempString .. "<PAOldColor>")
  end
  chatting_startAction()
  self._curChatMsgCnt = chatting_getMessageHistoryCount()
  self._curWhisperMsgCnt = chatting_getTargetHistoryCount()
  ToClient_ClearLinkedGuildList()
  PaGlobalFunc_ChattingHistory_Open(self._availableChannelList[self._currentChatTypeIndex])
  _AudioPostEvent_SystemUiForXBOX(51, 7)
end
function PaGlobalFunc_ChattingInfo_WhisperTo(name)
  local self = ChattingInfo
  self:whisperToNick(name)
  self:aimForWhisper(false)
end
function Input_ChattingInfo_PressedLTA()
  local self = ChattingInfo
  if false == self._ui.txt_keyGuideLTA:GetShow() then
    return
  end
  PaGlobal_Chatting_FunctionList:prepareOpen()
end
function Input_ChattingInfo_PressedLTX()
  local self = ChattingInfo
  if false == self._ui.txt_keyGuideLTX:GetShow() then
    return
  end
  if false == ToClient_isPS4() then
    return
  end
  PaGlobal_Chatting_FunctionList_ViewProfileForPS()
end
function PaGlobalFunc_ChattingInfo_DirectWhisperToNick(targetName)
  local self = ChattingInfo
  if nil == targetName then
    return
  end
  if "$Unknown$" == targetName then
    targetName = ""
    return
  end
  self:setChatTypeTo(CHAT_TYPE.Private)
  self._ui.edit_whisperTarget:SetEditText(targetName)
  self._ui.stc_whisperBG:SetSize(self._ui.edit_whisperTarget:GetTextSizeX() + 110, self._ui.stc_whisperBG:GetSizeY())
  self._ui.txt_keyGuideXForWhisper:ComputePos()
  self:aimForWhisper(false)
end
function PaGlobalFunc_ChattingInfo_WhisperName(targetName)
  local self = ChattingInfo
  if true == ToClient_isConsole() and false == ToClient_IsDevelopment() then
    self._ui.edit_whisperTarget:SetEditText(targetName)
  end
  ClearFocusEdit()
  self:aimForWhisper(false)
end
function Input_ChattingInfo_HistoryHide()
  local self = ChattingInfo
  if not PaGlobalFunc_ChattingHistory_GetShow() then
    return
  end
  PaGlobalFunc_ChattingHistory_Close()
end
function InputPadY_ChattingInfo_MacroShowToggle(isShow)
  local self = ChattingInfo
  self._ui.stc_macroBG:SetShow(isShow)
  if false == isShow then
    self:speakMacro(self._currentMacro)
    _AudioPostEvent_SystemUiForXBOX(50, 0)
  end
end
function ChattingInfo:speakMacro(index)
  if self.maxEditInput > string.len(self._ui.edit_chatContent:GetEditText()) then
    self._ui.edit_chatContent:SetEditText(self._ui.edit_chatContent:GetEditText() .. self._macroList[index])
  end
end
function InputPadX_ChattingInfo_MacroMoveSelect(isUp)
  local self = ChattingInfo
  if isUp then
    self._currentMacro = self._currentMacro - 1
    _AudioPostEvent_SystemUiForXBOX(51, 4)
  else
    self._currentMacro = self._currentMacro + 1
    _AudioPostEvent_SystemUiForXBOX(51, 4)
  end
  if self._currentMacro < 0 then
    self._currentMacro = self._macroMaxCount
  elseif self._macroMaxCount < self._currentMacro then
    self._currentMacro = 0
  end
  self._ui.stc_selectedMacro:SetPosY(31 + 31 * (self._currentMacro - 1))
end
function ChattingInfo:aimForWhisper(isWhisper)
  self._ui.stc_whisperBG:SetShow(CHAT_TYPE.Private == self._availableChannelList[self._currentChatTypeIndex])
  self._ui.txt_keyGuideXForWhisper:SetShow(isWhisper)
  self._ui.stc_highlight:SetShow(not isWhisper)
  self._ui.txt_keyGuideX:SetShow(not isWhisper)
end
function PaGlobalFunc_ChattingInfo_PressedEnter(str)
  if false == _panel:GetShow() then
    return
  end
  if false == ToClient_isCommunicationAllowed() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    ToClient_showPrivilegeError()
    return
  end
  if true == ToClient_ChatRestrictionPS4() then
    ToClient_SystemMsgDialogPS4(__ePS4SystemMsgDialogType_TRC_PSN_CHAT_RESTRICTION)
    return
  end
  if nil ~= str then
    ChattingInfo._ui.edit_chatContent:SetEditText(str)
  end
  if 0 == string.len(ChattingInfo._ui.edit_chatContent:GetEditText()) then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  PaGlobalFunc_ChattingInfo_CancelAction()
  ChattingInfo:sendMessage()
  ClearFocusEdit()
  if false == PaGlobalFunc_ChattingHistory_GetShow() then
    PaGlobalFunc_ChattingInfo_Close()
  end
end
function Input_ChattingInfo_PressedRT()
  local self = ChattingInfo
  _AudioPostEvent_SystemUiForXBOX(51, 7)
  self._curWhisperMsgCnt = self._curWhisperMsgCnt - 1
  if self._curWhisperMsgCnt < 0 then
    self._curWhisperMsgCnt = chatting_getTargetHistoryCount() - 1
  end
  local whisperHistory = chatting_getTargetHistoryByIndex(self._curWhisperMsgCnt)
  if nil ~= whisperHistory then
    self:setChatTypeTo(CHAT_TYPE.Private)
    self._ui.edit_whisperTarget:SetEditText(whisperHistory)
    _AudioPostEvent_SystemUiForXBOX(51, 7)
  else
    local string = PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_CHATTING_NO_REPLY")
    Proc_ShowMessage_Ack(string)
  end
end
function ChattingInfo:sendMessage()
  if self.permissions[self._availableChannelList[self._currentChatTypeIndex]] then
    local target = self._ui.edit_whisperTarget:GetEditText()
    local message = self._ui.edit_chatContent:GetEditText()
    chatting_sendMessage(target, message, self._availableChannelList[self._currentChatTypeIndex])
    chatting_saveMessageHistory(target, message)
    self._ui.edit_chatContent:SetEditText("", true)
  end
end
function PaGlobalFunc_ChattingInfo_Close()
  if not _isInitialized then
    return
  end
  PaGlobalFunc_ChattingViewer_On()
  ChattingInfo:close()
end
function ChattingInfo:close()
  if not _isInitialized then
    return
  end
  ClearFocusEdit()
  ToClient_ClearLinkedItemList()
  ToClient_ClearLinkedGuildList()
  PaGlobalFunc_ChattingInfo_CancelMessage()
  PaGlobalFunc_ChattingInfo_CancelAction()
  self:clearLinkedItem()
  PaGlobalFunc_ChattingHistory_Close()
  _panel:SetShow(false)
end
function ChattingInfo:clearLinkedItem()
  self.linkedItemCount = 0
  for ii = 0, self.maxLinkedItemCount - 1 do
    self.linkedItemData[ii] = nil
  end
  if nil ~= self._ui.edit_chatContent then
    self._ui.edit_chatContent:SetCursorMove(true)
  end
end
function PaGlobalFunc_ChattingInfo_CancelAction()
  local self = ChattingInfo
  local message = self._ui.edit_chatContent:GetEditText()
  if "" == message then
    chatting_cancelAction()
  end
end
function PaGlobalFunc_ChattingInfo_CancelMessage()
  local self = ChattingInfo
  self.curChatMsgCnt = self._sentChatMsgCnt
  self._ui.edit_chatContent:SetEditText("", true)
end
function PaGlobalFunc_ChattingInfo_CheckRemoveLinkedItem()
  local self = ChattingInfo
  if CHAT_TYPE.World ~= self._lastChatType and CHAT_TYPE.Guild ~= self._lastChatType and CHAT_TYPE.Public ~= self._lastChatType and CHAT_TYPE.Party ~= self._lastChatType and CHAT_TYPE.WorldWithItem ~= self._lastChatType and CHAT_TYPE.Private ~= self._lastChatType then
    return
  end
  if self.linkedItemCount <= 0 then
    return
  end
  local str = self._ui.edit_chatContent:GetEditText()
  local editStrLen = string.len(str)
  if editStrLen < self.linkedItemData[self.linkedItemCount].endPos then
    if 0 == self.linkedItemData[self.linkedItemCount].startPos then
      self._ui.edit_chatContent:SetEditText("", true)
    else
      self._ui.edit_chatContent:SetEditText(string.sub(str, 1, self.linkedItemData[self.linkedItemCount].startPos), true)
    end
    ToClient_ClearLinkedItemList()
    self:clearLinkedItem()
  end
end
function ChattingInfo:clearLinkedItem()
  self.linkedItemCount = 0
  for i = 0, self.maxLinkedItemCount - 1 do
    self.linkedItemData[i] = nil
  end
  self._ui.edit_chatContent:SetCursorMove(true)
end
function Input_ChattingInfo_OnPadX()
  local self = ChattingInfo
  if false == ToClient_isCommunicationAllowed() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    ToClient_showPrivilegeError()
    return
  end
  if true == ToClient_ChatRestrictionPS4() then
    ToClient_SystemMsgDialogPS4(__ePS4SystemMsgDialogType_TRC_PSN_CHAT_RESTRICTION)
    return
  end
  PaGlobalFunc_ChattingViewer_Off()
  isDirectChattingInput = false
  if true == self._ui.txt_keyGuideXForWhisper:GetShow() then
    SetFocusEdit(self._ui.edit_whisperTarget)
  else
    SetFocusEdit(self._ui.edit_chatContent)
  end
end
function Input_ChattingInfo_OnVirtualKeyboardEnd(str)
  if nil ~= str then
    ChattingInfo._ui.edit_chatContent:SetEditText(str)
  end
  ClearFocusEdit()
  if true == ToClient_isConsole() then
    PaGlobalFunc_ChattingInfo_PressedEnter()
  end
end
function Input_ChattingInfo_OnPadB()
  ClearFocusEdit()
end
function Input_ChattingInfo_OnPadBNotEditting()
  if 0 < string.len(ChattingInfo._ui.edit_chatContent:GetText()) then
    PaGlobalFunc_ChattingInfo_CancelAction()
    PaGlobalFunc_ChattingInfo_CancelMessage()
    return
  end
  Input_ChattingInfo_HistoryHide()
  PaGlobalFunc_ChattingInfo_Close()
end
function Input_ChattingInfo_ChangeHistoryTab(isNext)
  if not PaGlobalFunc_ChattingHistory_GetShow() then
    return
  end
  Input_ChatHistory_ChangeToNextTab(isNext)
end
function Input_ChattingInfo_SelectInHistory(isUp)
  if not PaGlobalFunc_ChattingHistory_GetShow() then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(51, 4)
  ToClient_padSnapIgnoreGroupMove()
  Input_ChatHistory_SelectInList(isUp)
end
function ChattingInfo:setChatTypeTo(targetChatType)
  if not self.permissions[targetChatType] then
    return
  end
  local chatTypeFound = false
  for ii = 1, #self._availableChannelList do
    if self._availableChannelList[ii] == targetChatType then
      chatTypeFound = true
      self._currentChatTypeIndex = ii
    end
  end
  if not chatTypeFound then
    return
  end
  self:aimForWhisper(targetChatType == CHAT_TYPE.Private)
  self:updateChannelIcon()
end
function Input_ChattingInfo_SetNextChatType(isNext)
  ToClient_padSnapIgnoreGroupMove()
  local self = ChattingInfo
  if isNext then
    self._currentChatTypeIndex = self._currentChatTypeIndex + 1
  else
    self._currentChatTypeIndex = self._currentChatTypeIndex - 1
  end
  if self._currentChatTypeIndex > #self._availableChannelList then
    self._currentChatTypeIndex = 1
  elseif self._currentChatTypeIndex < 1 then
    self._currentChatTypeIndex = #self._availableChannelList
  end
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  local chatType = self._availableChannelList[self._currentChatTypeIndex]
  self:aimForWhisper(chatType == CHAT_TYPE.Private)
  self:updateChannelIcon()
end
function ChattingInfo:updateChannelIcon()
  for ii = 1, CHAT_TYPE.Count - 1 do
    self._ui.stc_channelList[ii]:SetShow(false)
  end
  local chatType = self._availableChannelList[self._currentChatTypeIndex]
  if nil ~= _chatTypeUV[chatType] then
    self._ui.stc_channelList[chatType]:SetShow(true)
  end
end
function ChatInput_CheckCurrentUiEdit(targetUI)
  return nil ~= targetUI and (targetUI:GetKey() == ChattingInfo._ui.edit_chatContent:GetKey() or targetUI:GetKey() == ChattingInfo._ui.edit_whisperTarget:GetKey())
end
function CheckChattingInput()
  if _panel:IsShow() then
    return true
  end
  return false
end
function PaGlobalFunc_ChattingInfo_UpdatePermission()
  local self = ChattingInfo
  local selfPlayerWrapper = getSelfPlayer()
  self.permissions:resize(CHAT_TYPE.Count, false)
  if nil ~= selfPlayerWrapper then
    self.permissions[CHAT_TYPE.World] = true
    self.permissions[CHAT_TYPE.Public] = true
    self.permissions[CHAT_TYPE.Private] = true
    local myLevel = getSelfPlayer():get():getLevel()
    if isGameServiceTypeDev() then
      self.permissions[CHAT_TYPE.WorldWithItem] = true
      self.permissions[CHAT_TYPE.RolePlay] = true
    elseif isGameTypeKorea() then
      self.permissions[CHAT_TYPE.WorldWithItem] = true
    elseif isGameTypeJapan() then
      self.permissions[CHAT_TYPE.WorldWithItem] = true
    elseif isGameTypeEnglish() then
      if myLevel < 20 then
        self.permissions[CHAT_TYPE.WorldWithItem] = false
      else
        self.permissions[CHAT_TYPE.WorldWithItem] = true
      end
      self.permissions[CHAT_TYPE.RolePlay] = true
    elseif isGameTypeTaiwan() then
      if myLevel < 20 then
        self.permissions[CHAT_TYPE.WorldWithItem] = false
      else
        self.permissions[CHAT_TYPE.WorldWithItem] = true
      end
    elseif isGameTypeTR() or isGameTypeTH() or isGameTypeID() then
      if myLevel < 20 then
        self.permissions[CHAT_TYPE.WorldWithItem] = false
      else
        self.permissions[CHAT_TYPE.WorldWithItem] = isWolrdChat
      end
    else
      self.permissions[CHAT_TYPE.WorldWithItem] = isWolrdChat
    end
    if selfPlayerWrapper:get():isGuildMember() then
      self.permissions[CHAT_TYPE.Guild] = true
    end
    if selfPlayerWrapper:get():hasParty() then
      self.permissions[CHAT_TYPE.Party] = true
    end
    if isArsha then
      self.permissions[CHAT_TYPE.Arsha] = true
    end
    if true == isLocalWar or true == isArsha or true == isSavageDefence then
      self.permissions[CHAT_TYPE.Team] = true
    end
  end
  self._availableChannelList = {}
  for ii = 1, #self.permissions do
    if true == self.permissions[ii] then
      self._availableChannelList[#self._availableChannelList + 1] = ii
    end
  end
end
function PaGlobalFunc_ChattingInfo_SetShowFunctionKeyGuide(isSender)
  local self = ChattingInfo
  if false == _panel:GetShow() then
    return
  end
  ChattingInfo._ui.txt_keyGuideLTA:SetShow(true)
  ChattingInfo._ui.txt_keyGuideLTX:SetShow(isSender and ToClient_isPS4())
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguideAlign, self._ui.stc_keyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_BOTTOM, nil, 10)
end
local lastWhispersId = ""
local lastWhispersTick = 0
local lastPartyTick = 0
local lastGuildTick = 0
function ChatInput_SetLastWhispersUserId(WhispersId)
  lastWhispersId = WhispersId
end
function ChatInput_SetLastWhispersTick()
  lastWhispersTick = getTickCount32()
end
function ChatInput_GetLastWhispersUserId()
  return lastWhispersId
end
function ChatInput_GetLastWhispersTick()
  return lastWhispersTick
end
function ChatInput_SetLastPartyTick()
  lastPartyTick = getTickCount32()
end
function ChatInput_GetLastPartyTick()
  return lastPartyTick
end
function ChatInput_SetLastGuildTick()
  lastGuildTick = getTickCount32()
end
function ChatInput_GetLastGuildTick()
  return lastGuildTick
end
function isFocusInChatting()
  local focusEdit = GetFocusEdit()
  local editControl = ChattingInfo._ui.edit_chatContent
  local whisperControl = ChattingInfo._ui.edit_whisperTarget
  if nil == focusEdit then
    return false
  end
  if focusEdit:GetID() == editControl:GetID() or focusEdit:GetID() == whisperControl:GetID() then
    return true
  end
  return false
end

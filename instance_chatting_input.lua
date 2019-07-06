Instance_Chatting_Input:SetShow(false, false)
Instance_Chatting_Input:SetDragEnable(true)
Instance_Chatting_Input:SetDragAll(true)
Instance_Chatting_Input:RegisterShowEventFunc(true, "ChattingShowAni()")
Instance_Chatting_Input:RegisterShowEventFunc(false, "ChattingHideAni()")
local sentChatMsgCnt = 0
local curChatMsgCnt = 0
local lastChatHistory = ""
local sentWhisperMsgCnt = 0
local curWhisperMsgCnt = 0
local lastWhisperHistory = ""
local IM = CppEnums.EProcessorInputMode
local VCK = CppEnums.VirtualKeyCode
local UI_CT = CppEnums.ChatType
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local isLocalWar = ToClient_IsContentsGroupOpen("43")
local isArsha = ToClient_IsContentsGroupOpen("227")
local isSavageDefence = ToClient_IsContentsGroupOpen("249")
local isWolrdChat = ToClient_IsContentsGroupOpen("231")
local chatInput = {
  config = {
    startPosX = 7,
    startPosY = 7,
    btnPosYGap = 21,
    toggleType = {
      chattingMacro = 0,
      socialAction = 1,
      emoticon = 2
    }
  },
  control = {
    edit = UI.getChildControl(Instance_Chatting_Input, "Edit_ChatMessage"),
    dragButton = UI.getChildControl(Instance_Chatting_Input, "Button_Drag"),
    buttons = Array.new(),
    whisperEdit = UI.getChildControl(Instance_Chatting_Input, "Edit_WhisperName"),
    noticeShortcut = UI.getChildControl(Instance_Chatting_Input, "StaticText_Notice_Shortcut"),
    whisperNotice = UI.getChildControl(Instance_Chatting_Input, "StaticText_Whisper_Notice"),
    macroButton = UI.getChildControl(Instance_Chatting_Input, "RadioButton_Macro"),
    socialButton = UI.getChildControl(Instance_Chatting_Input, "RadioButton_SocialAction"),
    nameTypeButton = UI.getChildControl(Instance_Chatting_Input, "Button_ChangeNameDisplay"),
    arabicCheckButton = UI.getChildControl(Instance_Chatting_Input, "CheckBox_DropTrash"),
    radioButton_Emoticon = UI.getChildControl(Instance_Chatting_Input, "RadioButton_Emoticon")
  },
  buttonIds = {
    [0] = nil,
    [1] = "Button_Anounce",
    [2] = "Button_World",
    [3] = "Button_Normal",
    [4] = "Button_Whisper",
    [5] = "Button_System",
    [6] = "Button_Party",
    [7] = "Button_Guild",
    [9] = "Button_GuildAlliance"
  },
  permissions = Array.new(),
  lastChatType = UI_CT.Public,
  isChatTypeChangedMode = false,
  maxEditInput = 100,
  linkedItemCount = 0,
  maxLinkedItemCount = 1,
  linkedItemData = {
    [0] = nil
  }
}
local checkFocusWhisperEdit = false
local toChangeChatType = UI_CT.Public
function AllowChangeInputMode()
  return not Instance_Chatting_Input:IsShow()
end
function CheckChattingInput()
  if Instance_Chatting_Input:IsShow() then
    SetFocusChatting()
    return true
  end
  return false
end
function getCanChangeChatType(chatType)
  return chatInput.buttonIds[chatType]
end
function getChatPermissions(chatType)
  return chatInput.permissions[chatType]
end
function SetFocusChatting()
  SetFocusEdit(chatInput.control.edit)
end
function FromClient_GroundMouseClickForChatting()
  return CheckChattingInput()
end
function isFocusInChatting()
  local focusEdit = GetFocusEdit()
  local editControl = chatInput.control.edit
  local whisperControl = chatInput.control.whisperEdit
  if nil == focusEdit then
    return false
  end
  if focusEdit:GetID() == editControl:GetID() or focusEdit:GetID() == whisperControl:GetID() then
    return true
  end
  return false
end
local chatShortCutKey = {
  -1,
  VCK.KeyCode_2,
  VCK.KeyCode_1,
  VCK.KeyCode_3,
  -1,
  VCK.KeyCode_4,
  VCK.KeyCode_5,
  -1,
  VCK.KeyCode_7,
  -1,
  -1,
  -1,
  -1,
  -1
}
local chatShortCutKey_Value = {
  -1,
  2,
  1,
  3,
  -1,
  4,
  5,
  -1,
  7,
  -1,
  -1,
  6,
  -1,
  -1,
  8,
  -1,
  9,
  0
}
chatInput.control.dragButton:SetShow(false)
function ChattingShowAni()
  Instance_Chatting_Input:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo = Instance_Chatting_Input:addColorAnimation(0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo.IsChangeChild = true
  local aniInfo1 = Instance_Chatting_Input:addScaleAnimation(0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.1)
  aniInfo1:SetEndScale(1.25)
  aniInfo1.AxisX = Instance_Chatting_Input:GetSizeX() / 2
  aniInfo1.AxisY = Instance_Chatting_Input:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Instance_Chatting_Input:addScaleAnimation(0.12, 0.18, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.25)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Instance_Chatting_Input:GetSizeX() / 2
  aniInfo2.AxisY = Instance_Chatting_Input:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function ChattingHideAni()
  Instance_Chatting_Input:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo3 = Instance_Chatting_Input:addColorAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo3:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo3.IsChangeChild = true
  aniInfo3:SetHideAtEnd(true)
  aniInfo3:SetDisableWhileAni(true)
end
local lastMemoryChatType = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eMemoryRecentChat)
function chatInput:init()
  for idx, strId in pairs(self.buttonIds) do
    if nil ~= strId then
      local button = UI.getChildControl(Instance_Chatting_Input, strId)
      button:SetPosX(self.config.startPosX)
      button:SetPosY(self.config.startPosY)
      button:SetShow(false)
      self.control.buttons[idx] = button
    end
  end
  if isGameTypeKorea() then
    self.maxEditInput = 100
  elseif isGameTypeEnglish() then
    self.maxEditInput = 350
  else
    self.maxEditInput = 100
  end
  if 0 == lastMemoryChatType or 4 == lastMemoryChatType or 14 == lastMemoryChatType then
    lastMemoryChatType = self.lastChatType
  else
    lastMemoryChatType = lastMemoryChatType
  end
  if 4 == lastMemoryChatType then
    self.control.whisperEdit:SetShow(false)
    self.control.whisperNotice:SetShow(false)
    self.control.nameTypeButton:SetShow(false)
    self.control.macroButton:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 10)
    self.control.socialButton:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 40)
    self.control.radioButton_Emoticon:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 70)
  end
  if nil == self.control.buttons[lastMemoryChatType] then
    self.control.buttons[3]:SetShow(true)
  else
    self.control.buttons[lastMemoryChatType]:SetShow(true)
  end
  if true == ToClient_IsDevelopment() or true == isGameServiceTypeTurkey() then
    self.control.edit:SetUseHarfBuzz(true)
    self.control.arabicCheckButton:SetShow(true)
  else
    self.control.edit:SetUseHarfBuzz(false)
    self.control.arabicCheckButton:SetShow(false)
  end
  if true == ToClient_getUseHarfBuzz() then
    self.control.arabicCheckButton:SetCheck(true)
  else
    self.control.arabicCheckButton:SetCheck(false)
  end
  self.control.edit:SetMaxInput(self.maxEditInput)
  self.permissions:resize(#self.buttonIds, false)
  self.control.whisperNotice:SetSize(270, 20)
  self.control.whisperNotice:SetText(PAGetString(Defines.StringSheet_GAME, "CHATTING_WHISPER_NOTICE"))
end
function chatInput:checkLoad()
  UI.ASSERT(nil ~= self.control.edit and "PAUIEdit" == self.control.edit.__name, "Can't Find Control " .. self.control.edit.__name)
  UI.ASSERT(nil ~= self.control.dragButton and "PAUIButton" == self.control.dragButton.__name, "Can't Find Control " .. self.control.dragButton.__name)
  for _, ctrl in pairs(self.control.buttons) do
    UI.ASSERT(nil ~= ctrl and "PAUIButton" == ctrl.__name, "Can't Find Control " .. ctrl.__name)
  end
end
function chatInput:clearLinkedItem()
  self.linkedItemCount = 0
  for i = 0, self.maxLinkedItemCount - 1 do
    self.linkedItemData[i] = nil
  end
  self.control.edit:SetCursorMove(true)
end
function ChatInput_TypeButtonClicked(chatType)
  if 12 == chatType and not isWolrdChat then
    return
  end
  local self = chatInput
  local button = self.control.buttons[chatType]
  if self.isChatTypeChangedMode then
    local permission = self.permissions[chatType]
    if permission then
      for _, btn in pairs(self.control.buttons) do
        btn:SetShow(false)
      end
      button:SetShow(true)
      button:SetPosY(self.config.startPosY)
      self.isChatTypeChangedMode = false
      SetFocusEdit(self.control.edit)
      checkFocusWhisperEdit = false
      if self.lastChatType == UI_CT.World or self.lastChatType == UI_CT.Guild or self.lastChatType == UI_CT.Public or self.lastChatType == UI_CT.Party or self.lastChatType == UI_CT.WorldWithItem then
        self.control.edit:SetEditText("", true)
        ToClient_ClearLinkedItemList()
        chatInput:clearLinkedItem()
      end
      ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMemoryRecentChat, chatType, CppEnums.VariableStorageType.eVariableStorageType_User)
      self.lastChatType = chatType
      toChangeChatType = chatType
      self.control.macroButton:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 10)
      self.control.socialButton:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 40)
      self.control.radioButton_Emoticon:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 70)
      if UI_CT.Private == chatType then
        self.control.whisperEdit:SetShow(true)
        self.control.whisperNotice:SetPosX(self.control.whisperEdit:GetPosX() - 50)
        self.control.whisperNotice:SetPosY(self.control.whisperEdit:GetPosY() - 25)
        self.control.whisperNotice:SetShow(true)
        self.control.macroButton:SetPosX(self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX())
        self.control.socialButton:SetPosX(self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX() + 30)
        self.control.radioButton_Emoticon:SetPosX(self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX() + 60)
        self.control.nameTypeButton:SetShow(true)
        self.control.nameTypeButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHAT_NAMETYPE_" .. ToClient_getChatNameType()))
      else
        self.control.whisperEdit:SetShow(false)
        self.control.whisperNotice:SetShow(false)
        self.control.nameTypeButton:SetShow(false)
        self.control.macroButton:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 10)
        self.control.socialButton:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 40)
        self.control.radioButton_Emoticon:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 70)
      end
    end
  else
    local posY = self.config.startPosY
    for idx, btn in pairs(self.control.buttons) do
      if true == isWolrdChat then
        if idx ~= chatType and self.permissions[idx] then
          posY = posY - self.config.btnPosYGap
          btn:SetPosY(posY)
          btn:SetShow(true)
        end
      elseif idx ~= chatType and idx ~= 12 and self.permissions[idx] then
        posY = posY - self.config.btnPosYGap
        btn:SetPosY(posY)
        btn:SetShow(true)
      end
    end
    self.isChatTypeChangedMode = true
  end
end
function ChatInput_ChangeChatType_Immediately(chatType)
  if 12 == chatType and not isWolrdChat then
    return
  end
  local self = chatInput
  local permission = self.permissions[chatType]
  local button = self.control.buttons[chatType]
  if self.lastChatType ~= chatType and permission then
    for _, btn in pairs(self.control.buttons) do
      btn:SetShow(false)
    end
    button:SetShow(true)
    button:SetPosY(self.config.startPosY)
    SetFocusEdit(self.control.edit)
    checkFocusWhisperEdit = false
    if self.lastChatType == UI_CT.World or self.lastChatType == UI_CT.Guild or self.lastChatType == UI_CT.Public or self.lastChatType == UI_CT.Party or self.lastChatType == UI_CT.WorldWithItem or self.lastChatType == UI_CT.Arsha or self.lastChatType == UI_CT.Team then
      self.control.edit:SetEditText("", true)
      ToClient_ClearLinkedItemList()
      chatInput:clearLinkedItem()
    end
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMemoryRecentChat, chatType, CppEnums.VariableStorageType.eVariableStorageType_User)
    self.lastChatType = chatType
    self.control.macroButton:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 10)
    self.control.socialButton:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 40)
    self.control.radioButton_Emoticon:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 70)
    if UI_CT.Private == chatType then
      self.control.whisperEdit:SetShow(true)
      self.control.whisperNotice:SetPosX(self.control.whisperEdit:GetPosX() - 50)
      self.control.whisperNotice:SetPosY(self.control.whisperEdit:GetPosY() - 25)
      self.control.whisperNotice:SetShow(true)
      self.control.macroButton:SetPosX(self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX())
      self.control.socialButton:SetPosX(self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX() + 30)
      self.control.radioButton_Emoticon:SetPosX(self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX() + 60)
      self.control.nameTypeButton:SetShow(true)
      self.control.nameTypeButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHAT_NAMETYPE_" .. ToClient_getChatNameType()))
    else
      self.control.whisperEdit:SetShow(false)
      self.control.whisperNotice:SetShow(false)
      self.control.nameTypeButton:SetShow(false)
      self.control.macroButton:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 10)
      self.control.socialButton:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 40)
      self.control.radioButton_Emoticon:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 70)
    end
  end
end
function ChatInput_UpdatePermission()
  local self = chatInput
  local selfPlayerWrapper = getSelfPlayer()
  self.permissions:resize(#self.buttonIds, false)
  if nil ~= selfPlayerWrapper then
    self.permissions[UI_CT.World] = true
    self.permissions[UI_CT.Public] = true
    self.permissions[UI_CT.Private] = true
    local myLevel = getSelfPlayer():get():getLevel()
    if isGameServiceTypeDev() then
      self.permissions[UI_CT.WorldWithItem] = true
      self.permissions[UI_CT.RolePlay] = true
    elseif isGameTypeKorea() then
      self.permissions[UI_CT.WorldWithItem] = true
    elseif isGameTypeJapan() then
      self.permissions[UI_CT.WorldWithItem] = true
    elseif isGameTypeEnglish() then
      if myLevel < 20 then
        self.permissions[UI_CT.WorldWithItem] = false
      else
        self.permissions[UI_CT.WorldWithItem] = true
      end
      self.permissions[UI_CT.RolePlay] = true
    elseif isGameTypeTaiwan() then
      if myLevel < 20 then
        self.permissions[UI_CT.WorldWithItem] = false
      else
        self.permissions[UI_CT.WorldWithItem] = true
      end
    elseif isGameTypeTR() or isGameTypeTH() or isGameTypeID() then
      if myLevel < 20 then
        self.permissions[UI_CT.WorldWithItem] = false
      else
        self.permissions[UI_CT.WorldWithItem] = isWolrdChat
      end
    else
      self.permissions[UI_CT.WorldWithItem] = isWolrdChat
    end
    if selfPlayerWrapper:get():isGuildMember() then
      self.permissions[UI_CT.Guild] = true
    end
    if selfPlayerWrapper:get():hasParty() then
      self.permissions[UI_CT.Party] = true
    end
    if isArsha then
      self.permissions[UI_CT.Arsha] = true
    end
    if true == isLocalWar or true == isArsha or true == isSavageDefence then
      self.permissions[UI_CT.Team] = true
    end
    if _ContentsGroup_guildAlliance then
      self.permissions[UI_CT.Alliance] = true
    end
  end
  for chatType, btn in pairs(self.control.buttons) do
    local perm = self.permissions[chatType]
    local disAllowed = not self.permissions[chatType]
    btn:SetMonoTone(disAllowed)
  end
end
function chatInput:registEventHandler()
  for chatType, button in pairs(self.control.buttons) do
    button:addInputEvent("Mouse_On", "ChatInput_TypeButtonOn(" .. chatType .. ")")
    button:addInputEvent("Mouse_Out", "ChatInput_TypeButtonOut(" .. chatType .. ")")
    button:addInputEvent("Mouse_LUp", "ChatInput_TypeButtonClicked(" .. chatType .. ")")
  end
  self.control.edit:RegistReturnKeyEvent("ChatInput_PressedEnter()")
end
function ChatInput_SendMessage()
  local self = chatInput
  local memoryChatType = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eMemoryRecentChat)
  if 0 == memoryChatType or 4 == memoryChatType then
    memoryChatType = self.lastChatType
  else
  end
  if self.permissions[memoryChatType] then
    local target = self.control.whisperEdit:GetEditText()
    local message = self.control.edit:GetEditText()
    chatting_sendMessage(target, message, memoryChatType)
    chatting_saveMessageHistory(target, message)
  end
  self.control.edit:SetEditText("", true)
end
function ChatInput_CancelMessage()
  local self = chatInput
  curChatMsgCnt = sentChatMsgCnt
  self.control.edit:SetEditText("", true)
end
function ChatInput_PressedEnter()
  if Instance_Chatting_Input:IsShow() then
    ChatInput_CancelAction()
    ChatInput_SendMessage()
    ChatInput_Close()
    ClearFocusEdit()
  end
end
function ChatInput_PressedUp()
  if checkFocusWhisperEdit then
    curWhisperMsgCnt = curWhisperMsgCnt - 1
    if curWhisperMsgCnt < 0 then
      curWhisperMsgCnt = chatting_getTargetHistoryCount() - 1
    end
    local whisperHistory = chatting_getTargetHistoryByIndex(curWhisperMsgCnt)
    if nil ~= whisperHistory then
      chatInput.control.whisperEdit:SetEditText(whisperHistory, true)
    end
  else
    curChatMsgCnt = curChatMsgCnt - 1
    if curChatMsgCnt < 0 then
      curChatMsgCnt = chatting_getMessageHistoryCount() - 1
    end
    local messageHistory = chatting_getMessageHistoryByIndex(curChatMsgCnt)
    if nil ~= messageHistory then
      chatInput.control.edit:SetEditText(messageHistory, true)
    end
  end
end
function ChatInput_TypeButtonOn(chatType)
  if 12 == chatType and not isWolrdChat then
    return
  end
  local self = chatInput
  local button = self.control.buttons[chatType]
  self.control.noticeShortcut:SetColor(Defines.Color.C_FF000000)
  self.control.noticeShortcut:SetPosX(button:GetPosX() - self.control.noticeShortcut:GetSizeX())
  self.control.noticeShortcut:SetPosY(button:GetPosY() - 10)
  self.control.noticeShortcut:SetText("(ALT + " .. tostring(chatShortCutKey_Value[chatType]) .. ")")
  self.control.noticeShortcut:SetShow(true)
end
function ChatInput_TypeButtonOut(chatType)
  local self = chatInput
  self.control.noticeShortcut:SetShow(false)
end
function ChatInput_CheckReservedKey()
  local self = chatInput
  local chatMessage = self.control.edit:GetEditText()
  local chatMessageLength = string.len(chatMessage)
  for chatType, KeyCode in pairs(chatShortCutKey) do
    if -1 ~= KeyCode and isKeyDown_Once(KeyCode) then
      toChangeChatType = chatType
    end
  end
  if self.isChatTypeChangedMode then
    ChatInput_TypeButtonClicked(toChangeChatType)
  elseif isKeyPressed(VCK.KeyCode_MENU) and (isKeyDown_Once(VCK.KeyCode_0) or isKeyDown_Once(VCK.KeyCode_1) or isKeyDown_Once(VCK.KeyCode_2) or isKeyDown_Once(VCK.KeyCode_3) or isKeyDown_Once(VCK.KeyCode_4) or isKeyDown_Once(VCK.KeyCode_5) or isKeyDown_Once(VCK.KeyCode_6) or isKeyDown_Once(VCK.KeyCode_7) or isKeyDown_Once(VCK.KeyCode_8) or isKeyDown_Once(VCK.KeyCode_9)) then
    ChatInput_ChangeChatType_Immediately(toChangeChatType)
  end
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
function ChatInput_IsInstantCommand_Whisper(str)
  return str == "/w" or str == "/\227\133\136" or str == "/whisper" or str == "/\234\183\147\236\134\141\235\167\144" or str == "/\234\183\147"
end
function ChatInput_IsInstantCommand_Reply(str)
  return str == "/r" or str == "/\227\132\177" or str == "/reply" or str == "/\235\140\128\235\139\181" or str == "/\235\140\128"
end
function ChatInput_IsInstantCommand_Normal(str)
  return str == "/s" or str == "/\227\132\180" or str == "/\236\157\188\235\176\152" or str == "/\236\157\188"
end
function ChatInput_IsInstantCommand_World(str)
  return str == "/y" or str == "/\227\133\155" or str == "/yell" or str == "/\236\153\184\236\185\168" or str == "/\236\153\184"
end
function ChatInput_IsInstantCommand_Party(str)
  return str == "/p" or str == "/\227\133\148" or str == "/party" or str == "/\237\140\140\237\139\176" or str == "/\237\140\140"
end
function ChatInput_IsInstantCommand_Guild(str)
  return str == "/g" or str == "/\227\133\142" or str == "/guild" or str == "/\234\184\184\235\147\156" or str == "/\234\184\184"
end
function ChatInput_IsInstantCommand_WithItem(str)
  return str == "/a" or str == "/\227\133\129" or str == "/all" or str == "/\236\160\132\236\178\180" or str == "/\236\160\132"
end
function ChatInput_IsInstantCommand_Arsha(str)
  return str == "/c" or str == "/\227\133\138" or str == "/arsha" or str == "/\236\149\132\235\165\180\236\131\164"
end
function ChatInput_IsInstantCommand_Team(str)
  return str == "/t" or str == "/\227\133\133" or str == "/team" or str == "/\237\140\128"
end
function ChatInput_IsInstantCommand_Alliance(str)
  return str == "/u" or str == "/\227\133\149" or str == "/alliance" or str == "/\236\151\176\237\149\169"
end
function moveChatInput(moveTo)
  local isChanged = false
  local tempValue = 0
  local memoryChatType = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eMemoryRecentChat)
  local addValue = 1
  if false == moveTo then
    addValue = -1
  end
  local toChatType = memoryChatType + addValue
  while false == isChanged and tempValue < 50 do
    if true == moveTo and toChatType >= CppEnums.ChatType.Count then
      toChatType = CppEnums.ChatType.World
    elseif false == moveTo and toChatType <= 0 then
      toChatType = CppEnums.ChatType.Count - 1
    end
    ChatInput_ChangeChatType_Immediately(toChatType)
    local isButtonValid = getCanChangeChatType(toChatType)
    local isPermission = getChatPermissions(toChatType)
    if false == isPermission or nil == isButtonValid or "" == isButtonValid or toChatType == CppEnums.ChatType.System or toChatType == CppEnums.ChatType.Notice then
      isChanged = false
      toChatType = toChatType + addValue
    else
      isChanged = true
    end
    tempValue = tempValue + 1
  end
  audioPostEvent_SystemUi(1, 17)
end
function ChatInput_CheckInstantCommand()
  local self = chatInput
  local chatMessage = self.control.edit:GetEditText()
  local chatMessageLength = string.len(chatMessage)
  chatMessage = string.lower(string.sub(chatMessage, 1, chatMessageLength - 1))
  local isWhisper = ChatInput_IsInstantCommand_Whisper(chatMessage)
  local isReply = ChatInput_IsInstantCommand_Reply(chatMessage)
  local isProcess = false
  if ChatInput_IsInstantCommand_Normal(chatMessage) then
    toChangeChatType = CppEnums.ChatType.Public
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMemoryRecentChat, CppEnums.ChatType.Public, CppEnums.VariableStorageType.eVariableStorageType_User)
    isProcess = true
  elseif ChatInput_IsInstantCommand_World(chatMessage) then
    toChangeChatType = CppEnums.ChatType.World
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMemoryRecentChat, CppEnums.ChatType.World, CppEnums.VariableStorageType.eVariableStorageType_User)
    isProcess = true
  elseif ChatInput_IsInstantCommand_Party(chatMessage) then
    toChangeChatType = CppEnums.ChatType.Party
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMemoryRecentChat, CppEnums.ChatType.Party, CppEnums.VariableStorageType.eVariableStorageType_User)
    isProcess = true
  elseif ChatInput_IsInstantCommand_Guild(chatMessage) then
    toChangeChatType = CppEnums.ChatType.Guild
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMemoryRecentChat, CppEnums.ChatType.Guild, CppEnums.VariableStorageType.eVariableStorageType_User)
    isProcess = true
  elseif ChatInput_IsInstantCommand_WithItem(chatMessage) then
    toChangeChatType = CppEnums.ChatType.WorldWithItem
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMemoryRecentChat, CppEnums.ChatType.WorldWithItem, CppEnums.VariableStorageType.eVariableStorageType_User)
    isProcess = true
  elseif ChatInput_IsInstantCommand_Arsha(chatMessage) then
    toChangeChatType = CppEnums.ChatType.Arsha
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMemoryRecentChat, CppEnums.ChatType.Arsha, CppEnums.VariableStorageType.eVariableStorageType_User)
    isProcess = true
  elseif ChatInput_IsInstantCommand_Team(chatMessage) then
    toChangeChatType = CppEnums.ChatType.Team
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMemoryRecentChat, CppEnums.ChatType.Team, CppEnums.VariableStorageType.eVariableStorageType_User)
    isProcess = true
  elseif ChatInput_IsInstantCommand_Alliance(chatMessage) then
    toChangeChatType = CppEnums.ChatType.Alliance
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMemoryRecentChat, CppEnums.ChatType.Team, CppEnums.VariableStorageType.eVariableStorageType_User)
    isProcess = true
  elseif isWhisper or isReply then
    toChangeChatType = CppEnums.ChatType.Private
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMemoryRecentChat, CppEnums.ChatType.Private, CppEnums.VariableStorageType.eVariableStorageType_User)
    isProcess = true
  elseif UI_CT.Private == self.lastChatType and checkFocusWhisperEdit then
    SetFocusEdit(self.control.edit)
    checkFocusWhisperEdit = false
  end
  if isProcess then
    if self.isChatTypeChangedMode then
      ChatInput_TypeButtonClicked(toChangeChatType)
    else
      ChatInput_ChangeChatType_Immediately(toChangeChatType)
    end
    self.control.edit:SetEditText("", true)
    if isWhisper or isReply then
      if "" == lastWhispersId then
        isReply = false
        isWhisper = true
      end
      if isWhisper then
        self.control.whisperEdit:SetEditText("", true)
        SetFocusEdit(self.control.whisperEdit)
        checkFocusWhisperEdit = true
      elseif isReply then
        self.control.whisperEdit:SetEditText(lastWhispersId, true)
        SetFocusEdit(self.control.edit)
        checkFocusWhisperEdit = false
      end
    end
  end
end
function FGlobal_ChatInput_CheckReply()
  if "" == lastWhispersId then
    return false
  end
  return true
end
function FGlobal_ChatInput_Reply(isReply)
  local self = chatInput
  if isReply then
    self.control.whisperEdit:SetEditText(lastWhispersId, true)
    SetFocusEdit(self.control.edit)
    checkFocusWhisperEdit = false
  end
end
function ChatInput_Show()
  if Instance_Chatting_Input:IsShow() then
    return
  end
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
  if true == ToClient_ChatRestrictionPS4() then
    ToClient_SystemMsgDialogPS4(__ePS4SystemMsgDialogType_TRC_PSN_CHAT_RESTRICTION)
    return
  end
  local self = chatInput
  SetFocusEdit(chatInput.control.edit)
  local isLastChatType = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eMemoryRecentChat)
  if 0 ~= isLastChatType and 4 ~= isLastChatType then
    self.lastChatType = isLastChatType
  end
  Instance_Chatting_Input:SetShow(true, true)
  self.control.macroButton:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 10)
  self.control.socialButton:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 40)
  self.control.radioButton_Emoticon:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 70)
  if UI_CT.Private == self.lastChatType then
    self.control.macroButton:SetPosX(self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX())
    self.control.socialButton:SetPosX(self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX() + 30)
    self.control.radioButton_Emoticon:SetPosX(self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX() + 60)
    self.control.nameTypeButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHAT_NAMETYPE_" .. ToClient_getChatNameType()))
  else
    self.control.macroButton:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 10)
    self.control.socialButton:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 40)
    self.control.radioButton_Emoticon:SetPosX(self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 70)
  end
  self.control.macroButton:SetCheck(false)
  if Instance_Chat_SocialMenu:GetShow() then
    self.control.socialButton:SetCheck(true)
  else
    self.control.socialButton:SetCheck(false)
  end
  if _ContentsGroup_Emoticon and 0 < ToClient_getEmoticonInfoList() then
    self.control.radioButton_Emoticon:SetShow(true)
    self.control.radioButton_Emoticon:SetCheck(PaGlobalFunc_ChatEmoticon_GetShow())
  else
    self.control.radioButton_Emoticon:SetShow(false)
  end
  if chatting_isBlocked() then
    local blockString = convertStringFromDatetime(chatting_blockedEndDatetime())
    local blockReason = tostring(chatting_blockedReasonMemo())
    local tempString = PAGetStringParam2(Defines.StringSheet_GAME, "CHATTING_BLOCK_TIME_REASON", "time", blockString, "reason", blockReason)
    self.control.edit:SetText("<PAColor0xFF888888>" .. tempString)
  end
  chatting_startAction()
  curChatMsgCnt = chatting_getMessageHistoryCount()
  curWhisperMsgCnt = chatting_getTargetHistoryCount()
  ToClient_ClearLinkedGuildList()
end
function ChatInput_CancelAction()
  local self = chatInput
  local message = self.control.edit:GetEditText()
  if "" == message then
    chatting_cancelAction()
  end
end
function ChatInput_addEmoticon(inputStr)
  if false == Instance_Chatting_Input:IsShow() then
    return
  end
  if nil == inputStr or "" == inputStr then
    return
  end
  local self = chatInput
  ReleaseImeComposition()
  local message = self.control.edit:GetEditText()
  if chatInput.control.edit:GetEditTextSize() + string.len(inputStr) <= chatInput.maxEditInput then
    self.control.edit:SetEditText(message .. inputStr, true)
  end
end
function ChatInput_Close()
  ClearFocusEdit()
  ToClient_ClearLinkedItemList()
  ToClient_ClearLinkedGuildList()
  chatInput:clearLinkedItem()
  if Instance_Chatting_Input:IsShow() then
    Instance_Chatting_Input:SetShow(false, true)
    Instance_Chatting_Macro:SetShow(false)
    PaGlobalFunc_ChatEmoticon_Close()
  end
end
function ChatInput_CheckCurrentUiEdit(targetUI)
  return nil ~= targetUI and (targetUI:GetKey() == chatInput.control.edit:GetKey() or targetUI:GetKey() == chatInput.control.whisperEdit:GetKey())
end
function ChatInput_ChangeInputFocus()
  local self = chatInput
  if UI_CT.Private == self.lastChatType then
    if not checkFocusWhisperEdit then
      SetFocusEdit(self.control.whisperEdit)
      checkFocusWhisperEdit = true
    else
      SetFocusEdit(self.control.edit)
      checkFocusWhisperEdit = false
    end
  end
end
function HandleClicked_ToggleChatMacro(number)
  if chatInput.config.toggleType.chattingMacro == number then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_SHADOWARENA_CHATMACROCLICK"))
  elseif chatInput.config.toggleType.socialAction == number then
    FGlobal_SocialAction_ShowToggle()
  elseif chatInput.config.toggleType.emoticon == number then
    PaGlobalFunc_Emoticon_ShowToggle()
  end
end
function HandleClicked_clickNameType()
  local self = chatInput
  local preNameType = ToClient_getChatNameType()
  if preNameType == 1 then
    self.control.nameTypeButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHAT_NAMETYPE_0"))
    ToClient_setChatNameType(0)
  elseif preNameType == 0 then
    self.control.nameTypeButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHAT_NAMETYPE_1"))
    ToClient_setChatNameType(1)
  end
end
function HandleClicked_checkArabicType()
  local self = chatInput
  if true == self.control.arabicCheckButton:IsCheck() then
    ToClient_setUseHarfBuzz(true)
  else
    ToClient_setUseHarfBuzz(false)
  end
end
function HandleOver_Tooltip(isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local self = chatInput
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_INPUT_ARABIC")
  desc = ""
  control = self.control.arabicCheckButton
  TooltipSimple_Show(control, name, desc)
end
function FGlobal_Chatting_Macro_SetCHK(show)
  if true == show then
    chatInput.control.macroButton:SetCheck(true)
  else
    chatInput.control.macroButton:SetCheck(false)
  end
end
function FGlobal_SocialAction_SetCHK(show)
  if true == show then
    chatInput.control.socialButton:SetCheck(true)
  else
    chatInput.control.socialButton:SetCheck(false)
  end
end
function PaGlobalFunc_ChatEmoticon_SetCheck(show)
  chatInput.control.radioButton_Emoticon:SetCheck(show)
end
function FGlobal_ChattingcheckArabicType(check)
  local self = chatInput
  self.control.arabicCheckButton:SetCheck(check)
end
function isChatInputLinkedItem(itemWrapper)
  if nil == itemWrapper then
    return
  end
  local itemSSW = itemWrapper:getStaticStatus()
  local itemName = itemSSW:getName()
  local linkedItemPos = {startPos = 0, endPos = 0}
  local oldStr = chatInput.control.edit:GetEditText()
  linkedItemPos.startPos = chatting_linkedItemRealPos(oldStr)
  local newStr = oldStr .. "[" .. itemName .. "]"
  linkedItemPos.endPos = chatting_linkedItemRealPos(newStr)
  ReleaseImeComposition()
  chatInput.control.edit:SetEditText(newStr, true)
  if chatInput.control.edit:GetEditTextSize() <= chatInput.maxEditInput then
    chatInput.linkedItemData[chatInput.linkedItemCount] = linkedItemPos
    return true
  else
    chatInput.control.edit:SetEditText(oldStr, true)
    return false
  end
end
function FGlobal_ChattingInput_LinkedItemByInventory(slotNo, inventoryType)
  if UI_CT.World ~= chatInput.lastChatType and UI_CT.Guild ~= chatInput.lastChatType and UI_CT.Public ~= chatInput.lastChatType and UI_CT.Party ~= chatInput.lastChatType and UI_CT.WorldWithItem ~= chatInput.lastChatType and UI_CT.Private ~= chatInput.lastChatType then
    return
  end
  if chatInput.maxLinkedItemCount <= chatInput.linkedItemCount then
    return
  end
  chatInput.linkedItemCount = chatInput.linkedItemCount + 1
  local selfProxy = getSelfPlayer():get()
  local inventory = selfProxy:getInventory()
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  if isChatInputLinkedItem(itemWrapper) then
    chatInput.control.edit:SetCursorMove(false)
    chatInput.control.edit:SetCursorPosIndex(0)
    ToClient_SetLinkedItemByInventory(inventoryType, slotNo, chatInput.linkedItemData[chatInput.linkedItemCount].startPos, chatInput.linkedItemData[chatInput.linkedItemCount].endPos)
  end
  _PA_LOG("COMPE_CHAT", "FGlobal_ChattingInput_LinkedItemByInventory" .. tostring(inventoryType) .. tostring(slotNo))
end
function FGlobal_ChattingInput_ShowWhisper(characterName)
  ChatInput_Show()
  ChatInput_ChangeChatType_Immediately(4)
  if "$Unknown$" == characterName then
    characterName = " "
  end
  chatInput.control.whisperEdit:SetEditText(characterName, true)
  chatInput.control.nameTypeButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHAT_NAMETYPE_" .. ToClient_getChatNameType()))
end
function PaGlobal_ChattingInput_SendWhisper(whisperCharacterName, whisperFamilyname)
  local nameType = ToClient_getChatNameType()
  if nameType == 0 then
    FGlobal_ChattingInput_ShowWhisper(whisperCharacterName)
  elseif nameType == 1 then
    FGlobal_ChattingInput_ShowWhisper(whisperFamilyname)
  end
end
function ChatInput_CheckRemoveLinkedItem()
  if UI_CT.World ~= chatInput.lastChatType and UI_CT.Guild ~= chatInput.lastChatType and UI_CT.Public ~= chatInput.lastChatType and UI_CT.Party ~= chatInput.lastChatType and UI_CT.WorldWithItem ~= chatInput.lastChatType and UI_CT.Private ~= chatInput.lastChatType then
    return
  end
  if chatInput.linkedItemCount <= 0 then
    return
  end
  local str = chatInput.control.edit:GetEditText()
  local editStrLen = string.len(str)
  if editStrLen < chatInput.linkedItemData[chatInput.linkedItemCount].endPos then
    if 0 == chatInput.linkedItemData[chatInput.linkedItemCount].startPos then
      chatInput.control.edit:SetEditText("", true)
    else
      chatInput.control.edit:SetEditText(string.sub(str, 1, chatInput.linkedItemData[chatInput.linkedItemCount].startPos), true)
    end
    ToClient_ClearLinkedItemList()
    chatInput:clearLinkedItem()
  end
end
function ChatInput_Resize()
  Instance_Chatting_Input:SetSize(352, 30)
  Instance_Chatting_Input:ComputePos()
end
function FromClient_Init_ChatInput()
  local self = chatInput
  self:init()
  self:checkLoad()
  self:registEventHandler()
  self.control.macroButton:addInputEvent("Mouse_LUp", "HandleClicked_ToggleChatMacro(0)")
  self.control.socialButton:addInputEvent("Mouse_LUp", "HandleClicked_ToggleChatMacro(1)")
  self.control.radioButton_Emoticon:addInputEvent("Mouse_LUp", "HandleClicked_ToggleChatMacro(2)")
  self.control.nameTypeButton:addInputEvent("Mouse_LUp", "HandleClicked_clickNameType()")
  self.control.arabicCheckButton:addInputEvent("Mouse_LUp", "HandleClicked_checkArabicType()")
  self.control.arabicCheckButton:addInputEvent("Mouse_On", "HandleOver_Tooltip(true)")
  self.control.arabicCheckButton:addInputEvent("Mouse_Out", "HandleOver_Tooltip(false)")
end
registerEvent("EventChatPermissionChanged", "ChatInput_UpdatePermission")
registerEvent("EventChatInputClose", "ChatInput_Close")
registerEvent("onScreenResize", "ChatInput_Resize")
registerEvent("FromClient_GroundMouseClick", "FromClient_GroundMouseClickForChatting")
registerEvent("FromClient_luaLoadComplete", "FromClient_Init_ChatInput")

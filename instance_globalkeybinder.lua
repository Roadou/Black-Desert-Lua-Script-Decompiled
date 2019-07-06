local IM = CppEnums.EProcessorInputMode
local VCK = CppEnums.VirtualKeyCode
local UIMode = Defines.UIMode
local fastPinDelta = 0
function PaGlobal_GlobalKeyBinder.Process_GameMode()
  DragManager:clearInfo()
end
function PaGlobal_GlobalKeyBinder.Process_UIMode_DeadMessage(deltaTime)
  if false == _ContentsGroup_RenewUI_DeadMessage then
    if GlobalKeyBinder_CheckCustomKeyPressed(CppEnums.UiInputType.UiInputType_Chat) then
      ChatInput_Show()
      return
    end
    if GlobalKeyBinder_CheckCustomKeyPressed(CppEnums.UiInputType.UiInputType_Guild) then
      local guildWrapper = ToClient_GetMyGuildInfoWrapper()
      if nil ~= guildWrapper then
        local guildGrade = guildWrapper:getGuildGrade()
        if 0 == guildGrade then
          if false == Panel_ClanList:IsShow() then
            audioPostEvent_SystemUi(1, 36)
            _AudioPostEvent_SystemUiForXBOX(1, 36)
            FGlobal_ClanList_Open()
          else
            audioPostEvent_SystemUi(1, 31)
            _AudioPostEvent_SystemUiForXBOX(1, 31)
            FGlobal_ClanList_Close()
          end
        else
          local isPanelGuildShow = false
          if nil == PaGlobal_GuildPanelLoad_GetShowPanelGuildMain then
            isPanelGuildShow = Panel_Window_Guild:IsShow()
          else
            isPanelGuildShow = PaGlobal_GuildPanelLoad_GetShowPanelGuildMain()
          end
          if false == isPanelGuildShow and not Instance_DeadMessage:GetShow() then
            audioPostEvent_SystemUi(1, 36)
            _AudioPostEvent_SystemUiForXBOX(1, 36)
            GuildManager:Show()
          else
            audioPostEvent_SystemUi(1, 31)
            _AudioPostEvent_SystemUiForXBOX(1, 31)
            GuildManager:Hide()
          end
        end
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_NO_GUILD"))
      end
      if Instance_DeadMessage:GetShow() then
        GuildManager:Hide()
      end
    end
  else
    if GlobalKeyBinder_CheckCustomKeyPressed(CppEnums.UiInputType.UiInputType_Chat) then
      return
    end
    if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
      PaGlobalFunc_ResurrerectionItem_Close()
    end
  end
end
function PaGlobal_GlobalKeyBinder.Process_UIMode_PreventMoveNSkill(deltaTime)
end
function PaGlobal_GlobalKeyBinder.Process_UIMode_GameExit(deltaTime)
  if not getEscHandle() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
    if false == _ContentsGroup_RenewUI_ExitGame then
      if true == Panel_Window_DeliveryForGameExit:GetShow() then
        FGlobal_DeliveryForGameExit_Show(false)
        return
      elseif true == Panel_Event_100Day:GetShow() then
        FGlobal_Event_100Day_Close()
      elseif true == Panel_ChannelSelect:GetShow() then
        FGlobal_ChannelSelect_Hide()
      else
        GameExitShowToggle(false)
      end
    else
      if true == PaGlobalFunc_GameExitConfirm_GetShow() then
        PaGlobalFunc_GameExitConfirm_SetShow(false, false)
        return
      end
      if true == _ContentsGroup_RenewUI_ServerSelect then
        if true == PaGlobalFunc_ServerSelect_GetShow() then
          PaGlobalFunc_ServerSelect_Close()
          return
        end
      elseif true == Panel_ChannelSelect:GetShow() then
        FGlobal_ChannelSelect_Hide()
        return
      end
      if true == PaGlobalFunc_GameExit_GetShow() then
        PaGlobalFunc_GameExit_SetShow(false, false)
      end
      if true == PaGlobalFunc_GameExitCharMove_GetShow() then
        PaGlobalFunc_GameExitCharMove_SetShow(false, false)
      end
    end
  end
end
function PaGlobal_GlobalKeyBinder.Process_UIMode_KeyCustom_ActionKey(deltaTime)
  local isEnd = false
  local inputType
  if true == _ContentsGroup_isNewOption and true == PaGlobal_Option:isOpen() then
    inputType = PaGlobal_Option:GetKeyCustomInputType()
  else
    inputType = KeyCustom_Action_GetInputType()
  end
  if nil == inputType or inputType < 0 then
    setKeyCustomizing(false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
    return
  end
  if isKeyUpFor(CppEnums.VirtualKeyCode.KeyCode_ESCAPE) then
    isEnd = true
  elseif isKeyUpFor(CppEnums.VirtualKeyCode.KeyCode_DELETE) then
    keyCustom_Clear_ActionKey(inputType)
    isEnd = true
  elseif keyCustom_CheckAndSet_ActionKey(inputType) then
    isEnd = true
  end
  if isEnd then
    setKeyCustomizing(false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
    if true == _ContentsGroup_isNewOption and true == PaGlobal_Option:isOpen() then
      PaGlobal_Option:CompleteKeyCustomMode()
      return
    end
    KeyCustom_Action_UpdateButtonText_Key()
    KeyCustom_Action_KeyButtonCheckReset(inputType)
  end
end
function PaGlobal_GlobalKeyBinder.Process_UIMode_KeyCustom_ActionPad(deltaTime)
  local isEnd = false
  local inputType
  if nil ~= PaGlobal_Option and true == PaGlobal_Option:isOpen() then
    inputType = PaGlobal_Option:GetKeyCustomInputType()
  else
    inputType = KeyCustom_Action_GetInputType()
  end
  if nil == inputType or inputType < 0 then
    setKeyCustomizing(false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
    return
  end
  if isKeyUpFor(CppEnums.VirtualKeyCode.KeyCode_ESCAPE) then
    isEnd = true
  elseif isKeyUpFor(CppEnums.VirtualKeyCode.KeyCode_DELETE) then
    keyCustom_Clear_ActionPad(inputType)
    isEnd = true
  elseif keyCustom_CheckAndSet_ActionPad(inputType) then
    isEnd = true
  end
  if isEnd then
    setKeyCustomizing(false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
    PaGlobal_Option:CompleteKeyCustomMode()
  end
end
function PaGlobal_GlobalKeyBinder.Process_UIMode_KeyCustom_UiKey(deltaTime)
  local isEnd = false
  local inputType
  if true == _ContentsGroup_isNewOption and true == PaGlobal_Option:isOpen() then
    inputType = PaGlobal_Option:GetKeyCustomInputType()
  else
    inputType = KeyCustom_Ui_GetInputType()
  end
  if nil == inputType or inputType < 0 then
    setKeyCustomizing(false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
    return
  end
  if isKeyUpFor(CppEnums.VirtualKeyCode.KeyCode_ESCAPE) then
    isEnd = true
  elseif isKeyUpFor(CppEnums.VirtualKeyCode.KeyCode_DELETE) then
    keyCustom_Clear_UiKey(inputType)
    isEnd = true
  elseif keyCustom_CheckAndSet_UiKey(inputType) then
    isEnd = true
  end
  if isEnd then
    setKeyCustomizing(false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
    if true == _ContentsGroup_isNewOption and true == PaGlobal_Option:isOpen() then
      PaGlobal_Option:CompleteKeyCustomMode()
      return
    end
    KeyCustom_Ui_UpdateButtonText_Key()
    KeyCustom_Ui_KeyButtonCheckReset(inputType)
  end
end
function PaGlobal_GlobalKeyBinder.Process_UIMode_KeyCustom_UiPad(deltaTime)
  local isEnd = false
  local inputType
  if true == _ContentsGroup_isNewOption and true == PaGlobal_Option:isOpen() then
    inputType = PaGlobal_Option:GetKeyCustomInputType()
  else
    inputType = KeyCustom_Ui_GetInputType()
  end
  if nil == inputType or inputType < 0 then
    setKeyCustomizing(false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
    return
  end
  if isKeyUpFor(CppEnums.VirtualKeyCode.KeyCode_ESCAPE) then
    isEnd = true
  elseif isKeyUpFor(CppEnums.VirtualKeyCode.KeyCode_DELETE) then
    keyCustom_Clear_UiPad(inputType)
    isEnd = true
  elseif keyCustom_CheckAndSet_UiPad(inputType) then
    isEnd = true
  end
  if isEnd then
    setKeyCustomizing(false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
    if true == _ContentsGroup_isNewOption and true == PaGlobal_Option:isOpen() then
      PaGlobal_Option:CompleteKeyCustomMode()
      return
    end
    KeyCustom_Ui_UpdateButtonText_Pad()
    KeyCustom_Ui_PadButtonCheckReset(inputType)
  end
end
function PaGlobal_GlobalKeyBinder.Process_UIMode_KeyCustom_ActionPadFunc1(deltaTime)
  local isEnd = false
  if isKeyUpFor(CppEnums.VirtualKeyCode.KeyCode_ESCAPE) then
    isEnd = true
  elseif isKeyUpFor(CppEnums.VirtualKeyCode.KeyCode_DELETE) then
    keyCustom_Clear_ActionPadFunc1(inputType)
    isEnd = true
  elseif keyCustom_CheckAndSet_ActionPadFunc1(inputType) then
    isEnd = true
  end
  if isEnd then
    setKeyCustomizing(false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
    if true == _ContentsGroup_isNewOption and true == PaGlobal_Option:isOpen() then
      PaGlobal_Option:CompleteKeyCustomMode()
      return
    end
    KeyCustom_Action_UpdateButtonText_Pad()
    KeyCustom_Action_FuncPadButtonCheckReset(0)
  end
end
function PaGlobal_GlobalKeyBinder.Process_UIMode_KeyCustom_ActionPadFunc2(deltaTime)
  local isEnd = false
  if isKeyUpFor(CppEnums.VirtualKeyCode.KeyCode_ESCAPE) then
    isEnd = true
  elseif isKeyUpFor(CppEnums.VirtualKeyCode.KeyCode_DELETE) then
    keyCustom_Clear_ActionPadFunc2(inputType)
    isEnd = true
  elseif keyCustom_CheckAndSet_ActionPadFunc2(inputType) then
    isEnd = true
  end
  if isEnd then
    setKeyCustomizing(false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
    if true == _ContentsGroup_isNewOption and true == PaGlobal_Option:isOpen() then
      PaGlobal_Option:CompleteKeyCustomMode()
      return
    end
    KeyCustom_Action_UpdateButtonText_Pad()
    KeyCustom_Action_FuncPadButtonCheckReset(1)
  end
end
function PaGlobal_GlobalKeyBinder.Process_UIMode_PopupItem()
  if not getEscHandle() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
    Panel_UseItem_ShowToggle_Func()
  end
end
function PaGlobal_GlobalKeyBinder.Process_UIMode_SkillWindow(delataTime)
  if false == _ContentsGroup_RenewUI then
    return
  end
  if not getEscHandle() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) or GlobalKeyBinder_CheckCustomKeyPressed(CppEnums.UiInputType.UiInputType_Skill) then
    audioPostEvent_SystemUi(1, 23)
    _AudioPostEvent_SystemUiForXBOX(1, 17)
    PaGlobalFunc_Skill_Close()
  end
end
function PaGlobal_GlobalKeyBinder.Process_UIMode_EventNotify(deltaTime)
  if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
    EventNotifyContent_Close()
    CheckChattingInput()
    SetUIMode(Defines.UIMode.eUIMode_Default)
  end
end
function PaGlobal_GlobalKeyBinder.Process_UiModeNotInput()
  if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
  end
end
function PaGlobal_GlobalKeyBinder.Process_ChattingMacro()
  if false == isKeyPressed(VCK.KeyCode_MENU) then
    return false
  end
  if false == isKeyPressed(VCK.KeyCode_SHIFT) then
    return false
  end
  local ii
  for ii = VCK.KeyCode_0, VCK.KeyCode_9 do
    local key = ii - VCK.KeyCode_0 - 1
    if key < 0 then
      key = VCK.KeyCode_9 - VCK.KeyCode_0
    end
    if isKeyDown_Once(ii) and "" ~= ToClient_getMacroChatMessage(key) then
      ToClient_executeChatMacro(key)
      return true
    end
  end
  return false
end
function PaGlobal_GlobalKeyBinder.Process_UIMode_SkillkeyBinder(deltaTime)
  local ii
  local quickSlot1 = CppEnums.ActionInputType.ActionInputType_QuickSlot1
  local quickSlot10 = CppEnums.ActionInputType.ActionInputType_QuickSlot10
  for ii = quickSlot1, quickSlot10 do
    if keyCustom_IsDownOnce_Action(ii) then
      QuickSlot_Click(tostring(ii - quickSlot1))
      return
    end
  end
end
function PaGlobal_GlobalKeyBinder.Process_Normal(deltaTime)
  if MessageBox.isPopUp() then
    local pcKey = GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_RETURN) or GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_SPACE)
    if pcKey and not _ContentsGroup_RenewUI then
      MessageBox.keyProcessEnter()
      setUiInputProcessed(VCK.KeyCode_RETURN)
      setUiInputProcessed(VCK.KeyCode_SPACE)
      return true
    elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
      MessageBox.keyProcessEscape()
      return true
    end
  elseif Instance_Chatting_Macro:GetShow() then
    if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
      FGlobal_Chatting_Macro_ShowToggle()
      FGlobal_Chatting_Macro_SetCHK(false)
      CheckChattingInput()
      return true
    end
  elseif Instance_Chat_SocialMenu:GetShow() then
    if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
      if Instance_Chatting_Input:GetShow() then
        ChatInput_CancelAction()
        ChatInput_CancelMessage()
        ChatInput_Close()
      else
        FGlobal_SocialAction_SetCHK(false)
        FGlobal_SocialAction_ShowToggle()
        CheckChattingInput()
      end
      return true
    end
  elseif Instance_Chat_SubMenu:GetShow() then
    if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
      Instance_Chat_SubMenu:SetShow(false)
      return true
    end
  elseif Panel_NumberPad_IsPopUp() then
    if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_F) then
      Panel_NumberPad_ButtonAllSelect_Mouse_Click(0)
      setUiInputProcessed(VCK.KeyCode_F)
    elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_RETURN) or GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_SPACE) or keyCustom_IsDownOnce_Action(CppEnums.ActionInputType.ActionInputType_Interaction) then
      Panel_NumberPad_ButtonConfirm_Mouse_Click()
      setUiInputProcessed(VCK.KeyCode_RETURN)
      setUiInputProcessed(VCK.KeyCode_SPACE)
      keyCustom_KeyProcessed_Action(CppEnums.ActionInputType.ActionInputType_Interaction)
    elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
      Panel_NumberPad_ButtonCancel_Mouse_Click()
    end
    Panel_NumberPad_NumberKey_Input()
    return true
  elseif nil ~= getSelfPlayer() and getSelfPlayer():get():isShowWaitComment() then
    if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
      EventSelfPlayerWaitCommentClose()
      return true
    end
    if _ContentsGroup_RenewUI and Instance_Chatting_Input:GetShow() and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
      ChatInput_Close()
      return true
    end
  end
  FGlobal_QASupportDamageWriter_Update()
  return false
end
function PaGlobal_GlobalKeyBinder.Process_ChattingInputMode()
  uiEdit = GetFocusEdit()
  if nil == uiEdit then
    return false
  end
  if ChatInput_CheckCurrentUiEdit(uiEdit) then
    if true == _ContentsGroup_RenewUI_Chatting then
      if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
        Input_ChattingInfo_OnPadB()
      elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_BACK) then
        PaGlobalFunc_ChattingInfo_CheckRemoveLinkedItem()
      end
    elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_RETURN) then
      if true == _ContentsGroup_isConsoleTest then
        if true == _ContentsGroup_RenewUI_Chatting then
          PaGlobalFunc_ChattingInfo_PressedEnter()
        else
          ChatInput_PressedEnter()
        end
      end
    elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_UP) then
      if ToClient_isComposition() then
        return
      end
      if true == _ContentsGroup_isConsoleTest then
      else
        ChatInput_PressedUp()
      end
    elseif isKeyPressed(VCK.KeyCode_MENU) then
      ChatInput_CheckReservedKey()
    elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_TAB) then
      ChatInput_ChangeInputFocus()
    elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
      if ToClient_isComposition() then
        return
      end
      ChatInput_CancelAction()
      ChatInput_CancelMessage()
      ChatInput_Close()
      ClearFocusEdit()
    elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_SPACE) then
      ChatInput_CheckInstantCommand()
    elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_BACK) or isKeyPressed(VCK.KeyCode_BACK) then
      ChatInput_CheckRemoveLinkedItem()
    elseif GlobalKeyBinder_CheckCustomKeyPressed(CppEnums.UiInputType.UiInputType_ChatTabNext) then
      moveChatTab(true)
    elseif GlobalKeyBinder_CheckCustomKeyPressed(CppEnums.UiInputType.UiInputType_ChatTabPrev) then
      moveChatTab(false)
    end
  elseif FGlobal_ChattingFilter_UiEdit(uiEdit) then
    if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
      FGlobal_ChattingFilter_ClearFocusEdit()
    end
    return true
  end
  if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
    ClearFocusEdit()
  end
  return false
end
function CommonWindowFunction(uiInputType, Function, param)
  if true == GlobalKeyBinder_CheckCustomKeyPressed(uiInputType) then
    Function(param)
    return true
  end
end
function PaGlobal_GlobalKeyBinder:Process_InstanceKey(deltaTime)
  if keyCustom_IsDownOnce_Action(CppEnums.ActionInputType.ActionInputType_ServantOrder1) then
    PaGlobalFunc_ItemSlot_Use(0)
  elseif keyCustom_IsDownOnce_Action(CppEnums.ActionInputType.ActionInputType_ServantOrder2) then
    PaGlobalFunc_ItemSlot_Use(1)
  elseif keyCustom_IsDownOnce_Action(CppEnums.ActionInputType.ActionInputType_ServantOrder3) then
    PaGlobalFunc_ItemSlot_Use(2)
  elseif keyCustom_IsDownOnce_Action(CppEnums.ActionInputType.ActionInputType_ServantOrder4) then
    PaGlobalFunc_ItemSlot_Use(3)
  elseif GlobalKeyBinder_CheckCustomKeyPressed(CppEnums.UiInputType.UiInputType_Mail) then
    PaGlobalFunc_ItemSlot_Use(4)
  elseif isKeyUpFor(VCK.KeyCode_G) then
    PaGlobalFunc_BetterEquipment_EquipKeyUp()
  elseif isKeyUpFor(VCK.KeyCode_TAB) then
    PaGlobalFunc_BR_MiniMap_Open()
  end
  if isKeyPressed(VCK.KeyCode_MENU) then
    PaGlobal_QuickSlot_ChangeViewType(1)
  else
    PaGlobal_QuickSlot_ChangeViewType(0)
  end
end
function PaGlobal_GlobalKeyBinder.Process_UIMode_CommonWindow(deltaTime)
  if CommonWindowFunction(__eUiInputType_Chat, Process_UIMode_CommonWindow_Chatting) then
    return
  end
  if CommonWindowFunction(__eUiInputType_PositionNotify, Process_UIMode_CommonWindow_PositionNotify, fastPinDelta) then
    return
  end
  if CommonWindowFunction(__eUiInputType_ChatTabNext, moveChatTab, true) then
    return
  end
  if CommonWindowFunction(__eUiInputType_ChatTabPrev, moveChatTab, false) then
    return
  end
  if CommonWindowFunction(__eUIInputType_PossessionByBlackSpirit, Process_UIMode_CommonWindow_PossessionByBlackSpirit) then
    return
  end
  if CommonWindowFunction(__eUiInputType_Inventory, Process_UIMode_CommonWindow_Inventory) then
    return
  end
  if CommonWindowFunction(__eUiInputType_WorldMap, PaGlobalFunc_BR_MiniMap_Open) then
    return
  end
  fastPinDelta = fastPinDelta + deltaTime
  if fastPinDelta > 10 then
    fastPinDelta = 10
  end
  PaGlobal_GlobalKeyBinder:Process_InstanceKey(deltaTime)
  if isKeyPressed(VCK.KeyCode_SHIFT) and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_OEM_7) then
    if FGlobal_ChatInput_CheckReply() then
      ChatInput_Show()
      ChatInput_CheckInstantCommand()
      FGlobal_ChatInput_Reply(true)
      ChatInput_ChangeChatType_Immediately(4)
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHATTINGINPUT_NONEREPLYTARGET"))
    end
    return
  end
  if nil ~= Instance_Interaction and Instance_Interaction:IsShow() or nil ~= Panel_Widget_PanelInteraction_Renew and Panel_Widget_PanelInteraction_Renew:IsShow() then
    local keyCode
    if _ContentsGroup_isConsoleTest and isPadInputIn() then
      keyCode = FGlobal_Interaction_CheckAndGetPressedKeyCode_Xbox(deltaTime)
    else
      keyCode = FGlobal_Interaction_CheckAndGetPressedKeyCode()
    end
    if nil ~= keyCode then
      Interaction_ExecuteByKeyMapping(keyCode)
    end
  end
  if keyCustom_IsDownOnce_Action(CppEnums.ActionInputType.ActionInputType_Interaction) and Instance_Looting:IsShow() then
    Panel_Looting_buttonLootAll_Mouse_Click(false)
    Panel_Tooltip_Item_hideTooltip()
  end
  if isKeyPressed(VCK.KeyCode_MENU) and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_C) then
    if not isPvpEnable() then
      if true == ToClient_isConsole() then
        local selfProxy = getSelfPlayer()
        if nil ~= selfProxy and selfProxy:get():getLevel() < 50 then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_NOLEVEL_ACK"))
          return
        end
      end
      return
    else
      requestTogglePvP()
      return
    end
  end
  if isKeyPressed(VCK.KeyCode_MENU) and GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_B) then
    requestBlackSpritSkill()
    return
  end
  if true == _ContentsGroup_NewCloseManager then
    close_escape_WindowPanelList()
  else
    Toclient_processCheckEscapeKey()
  end
end
function PaGlobal_GlobalKeyBinder.Process_CheckEscape()
  if true == getEscHandle() or false == GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
    return
  end
  if selfPlayerIsFreeCamStateInCompetitionArea() then
    selfPlayerCloseFreecam()
    return
  end
  if Panel_EventNotify:GetShow() then
    FGlobal_NpcNavi_Hide()
    EventNotify_Close()
    return
  end
  if Instance_WatchingMode:GetShow() then
    return
  end
  if false == _ContentsGroup_RenewUI_Skill then
    if true == Panel_MovieSkillGuide_Web:GetShow() then
      if true == Panel_MovieSkillGuide_Weblist:GetShow() then
        PaGlobal_MovieSkillGuide_Weblist:Close()
        return
      else
        PaGlobal_MovieSkillGuide_Web:Close()
        return
      end
    end
    if true == Panel_MovieSkillGuide_Weblist:GetShow() then
      PaGlobal_MovieSkillGuide_Weblist:Close()
      return
    end
  elseif true == PaGlobalFunc_Skill_GetShow() then
    PaGlobalFunc_Skill_Close()
    return
  end
  if Instance_ChatOption:GetShow() then
    ChattingOption_Close()
    return
  end
  if Panel_CustomizingAlbum:GetShow() == true then
    CustomizingAlbum_Close()
  end
  local checkShowWindow = check_ShowWindow()
  if checkShowWindow then
    close_WindowPanelList()
    FGlobal_NpcNavi_Hide()
    return
  end
  if checkShowWindow and FGlobal_NpcNavi_IsShowCheck() then
    close_WindowPanelList()
    FGlobal_NpcNavi_Hide()
    return
  elseif not checkShowWindow and FGlobal_NpcNavi_IsShowCheck() then
    FGlobal_NpcNavi_Hide()
    return
  elseif checkShowWindow and not FGlobal_NpcNavi_IsShowCheck() then
    close_WindowPanelList()
    return
  else
    Panel_Menu_ShowToggle()
  end
end
function PaGlobal_GlobalKeyBinder.Process_Default(deltaTime)
end

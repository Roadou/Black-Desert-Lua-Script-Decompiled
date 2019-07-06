local closeTypeBitSet = {
  none = PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_CantClose
  }),
  attacked = PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Escape,
    Defines.CloseType.eCloseType_Attacked
  }),
  attackedOnly = PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Attacked
  }),
  default = PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Escape
  }),
  forceOnly = PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Force
  })
}
function addCloseExceptionList()
  if nil ~= PaGlobalFunc_GetDamagePanel_Count then
    for index = 1, PaGlobalFunc_GetDamagePanel_Count() do
      if nil ~= PaGlobalFunc_GetDamagePanel(index) then
        table.insert(panel_exceptionList, PaGlobalFunc_GetDamagePanel(index))
      end
    end
  end
end
function closeExceptionListInitialize()
  for index, panel in pairs(PaGlobal_panelExceptionList) do
    if nil ~= panel then
      panel:RegisterCloseLuaFunc(closeTypeBitSet.none, "")
    end
  end
  panel_exceptionList = nil
  PaGlobal_panelExceptionList = nil
end
function registerCloseLuaEvent(panel, closeFlag, closeFunc)
  if nil == panel or nil == closeFlag or nil == closeFunc then
    return
  end
  panel:RegisterCloseLuaFunc(closeFlag, closeFunc)
end
function registerClosePanelList()
  registerCloseLuaEvent(Instance_ChatOption, closeTypeBitSet.default, "PanelCloseFunc_ChatOption()")
  registerCloseLuaEvent(Instance_Chatting_Input, closeTypeBitSet.default, "PanelCloseFunc_ChattingInput()")
  registerCloseLuaEvent(Instance_MessageBox, closeTypeBitSet.default, "PanelCloseFunc_MessageBox()")
  registerCloseLuaEvent(Instance_Tooltip_Item_chattingLinkedItem, closeTypeBitSet.default, "Panel_Tooltip_Item_chattingLinkedItem_hideTooltip()")
  registerCloseLuaEvent(Instance_Chatting_Color, closeTypeBitSet.default, "ChattingColor_Hide()")
  registerCloseLuaEvent(Instance_Tooltip_Item_chattingLinkedItemClick, closeTypeBitSet.default, "Panel_Tooltip_Item_chattingLinkedItemClick_hideTooltip()")
  registerCloseLuaEvent(Panel_PartyList, closeTypeBitSet.default, "PanelCloseFunc_FindParty_Close()")
  registerCloseLuaEvent(Panel_PartyRecruite, closeTypeBitSet.default, "PartyListRecruite_Close()")
  registerCloseLuaEvent(Instance_Window_NumberPad, closeTypeBitSet.default, "Panel_NumberPad_Close()")
  registerCloseLuaEvent(Instance_TrayConfirm, closeTypeBitSet.default, "PanelCloseFunc_TrayConfirm()")
  registerCloseLuaEvent(Panel_Window_cOption, closeTypeBitSet.default, "PanelCloseFunc_Option()")
  registerCloseLuaEvent(Panel_Copyright, closeTypeBitSet.default, "PaGlobal_Copyright_Close()")
  registerCloseLuaEvent(LobbyInstance_WebControl, closeTypeBitSet.default, "PanelCloseFunc_WebControl()")
  registerCloseLuaEvent(LobbyInstance_RoomMessageBox, closeTypeBitSet.default, "PaGlobalFunc_RoomMessageBox_ButtonClickCancel()")
  registerCloseLuaEvent(LobbyInstance_RoomPassword, closeTypeBitSet.default, "RoomPassword_Cancel()")
  registerCloseLuaEvent(LobbyInstance_BattleRoyalRank_Web, closeTypeBitSet.default, "PaGlobal_BattleRoyalRank_WebClose()")
  registerCloseLuaEvent(Instance_MessageBox, closeTypeBitSet.attacked, "MessageBox_Empty_function()")
  registerCloseLuaEvent(Instance_ChatOption, closeTypeBitSet.attacked, "ChattingOption_Close()")
  registerCloseLuaEvent(Instance_Chat_SocialMenu, closeTypeBitSet.default, "FGlobal_SocialAction_ShowToggle()")
  registerCloseLuaEvent(Instance_Window_RewardList, closeTypeBitSet.default, "PaGlobal_RewardList_Close()")
  registerCloseLuaEvent(LobbyInstance_Window_MyInfo, closeTypeBitSet.default, "PaGlobalFunc_lobbyMyInfo_Close()")
  registerCloseLuaEvent(LobbyInstance_Window_ModeBranch, closeTypeBitSet.default, "PaGlobal_ModeBranch_Close()")
  registerCloseLuaEvent(LobbyInstance_Window_Guide, closeTypeBitSet.default, "PaGlobal_Guide_Close()")
end
function PaGlobalFunc_KeyboardHelpClose()
  Panel_KeyboardHelp:SetShow(false)
end
function PaGlobalFunc_Panel_QuickMenuCustomClose()
  Panel_QuickMenuCustom:SetShow(false)
  Panel_QuickMenuCustom_RightRing:SetShow(false)
end
function PaGlobalFunc_GameExitClose()
  GameExitShowToggle(true)
  FGlobal_ChannelSelect_Hide()
  Panel_GameExit_sendGameDelayExitCancel()
end
function PanelCloseFunc_FindParty_Close()
  if false == _ContentsGroup_RenewUI_Party then
    FGlobal_PartyList_ShowToggle()
  else
    PaGlobalFunc_FindParty_Exit()
  end
end
registerEvent("FromClient_luaLoadComplete", "initCloseFunction")
function initCloseFunction()
  _PA_LOG("\236\157\180\235\139\164\237\152\156", "initCloseFunction Start")
  CloseManager_RegisterExeptionList()
  closeExceptionListInitialize()
  registerClosePanelList()
end
function checkAllPanelSetCloseFunction()
  local result = Toclient_checkCloseEventSet()
  if true ~= result then
    UI.ASSERT(false, " \237\140\168\235\132\144\236\151\144 ,close \237\149\168\236\136\152\234\176\128 \236\133\139\237\140\133\235\144\152\236\167\128 \236\149\138\236\149\152\236\138\181\235\139\136\235\139\164 !! close \234\176\128 \236\160\149\236\131\129\236\158\145\235\143\153\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164 ")
    UI.ASSERT(false, " \237\149\180\235\139\185 \237\140\168\235\132\144\236\157\132 globalCloseManager_Renew.lua \236\152\136\236\153\184 \235\166\172\236\138\164\237\138\184\236\151\144 \236\182\148\234\176\128\237\149\152\234\177\176\235\130\152 close \237\149\168\236\136\152\235\165\188 \235\147\177\235\161\157\237\149\180\236\163\188\236\132\184\236\154\148 ")
  end
  _PA_LOG("\236\157\180\235\139\164\237\152\156", "\236\156\160\237\154\168\236\132\177 \234\178\128\236\130\172 \235\129\157")
end
function FromClient_EscapeEtcClose()
  Panel_Tooltip_Item_hideTooltip()
  Panel_Tooltip_Item_chattingLinkedItem_hideTooltip()
  Panel_Tooltip_Item_chattingLinkedItemClick_hideTooltip()
  Panel_SkillTooltip_Hide()
  TooltipSimple_Hide()
  TooltipCommon_Hide()
  if Panel_LowLevelGuide_Value_IsCheckMoviePlay == 1 then
    FGlobal_Panel_LowLevelGuide_MovePlay_FindWay()
  elseif Panel_LowLevelGuide_Value_IsCheckMoviePlay == 2 then
    FGlobal_Panel_LowLevelGuide_MovePlay_LearnSkill()
  elseif Panel_LowLevelGuide_Value_IsCheckMoviePlay == 3 then
    FGlobal_Panel_LowLevelGuide_MovePlay_FindTarget()
  elseif Panel_LowLevelGuide_Value_IsCheckMoviePlay == 4 then
    FGlobal_Panel_LowLevelGuide_MovePlay_AcceptQuest()
  elseif Panel_LowLevelGuide_Value_IsCheckMoviePlay == 99 then
    FGlobal_Panel_LowLevelGuide_MovePlay_BlackSpirit()
  end
end
function FromClient_CancelByAttacked()
  close_attacked_WindowPanelList()
end
function check_ShowWindow()
  return ToClient_isShownClosePanel()
end
function close_WindowPanelList()
  Toclient_closeAllPanelByState(Defines.CloseType.eCloseType_Escape, false)
end
function close_force_WindowPanelList()
  Toclient_closeAllPanelByState(Defines.CloseType.eCloseType_Force, true)
end
function close_escape_WindowPanelList()
  Toclient_processCheckEscapeKey()
end
local _cancelByAttackIsCalled = false
function PaGlobalFunc_CancelByAttackIsCalled()
  return _cancelByAttackIsCalled
end
function close_attacked_WindowPanelList()
  if false == _ContentsGroup_RenewUI_Chatting and false == AllowChangeInputMode() then
    return
  end
  _cancelByAttackIsCalled = true
  RenderModeAllClose()
  ToClient_PopBlackSpiritFlush()
  Toclient_closeAllPanelByState(Defines.CloseType.eCloseType_Attacked, false)
  _cancelByAttackIsCalled = false
end
function getCurrentCloseType()
  return Toclient_getCurrentCloseType()
end
function PanelCloseFunc_Option()
  GameOption_Cancel()
  TooltipSimple_Hide()
end
initCloseFunction()
registerEvent("FromClient_luaLoadCompleteLateUdpate", "checkAllPanelSetCloseFunction")
registerEvent("FromClient_EscapeEtcClose", "FromClient_EscapeEtcClose")
registerEvent("progressEventCancelByAttacked", "FromClient_CancelByAttacked")
function PanelCloseFunc_LocalWarInfo_Close()
  if false == _ContentsGroup_RenewUI_LocalWar then
    FGlobal_LocalWarInfo_Close()
  else
    PaGlobalFunc_LocalWarInfo_Exit()
  end
end
function PanelCloseFunc_ImprovementInfo_Discard()
  PaGlobalFunc_ImprovementInfo_Discard()
end
function PanelCloseFunc_EventNotify()
  FGlobal_NpcNavi_Hide()
  EventNotify_Close()
end
function PanelCloseFunc_MasterpieceAuction()
  if FGlobal_MasterPieceAuction_IsOpenEscMenu() then
    PaGlobal_MasterpieceAuction:close()
    return
  end
end
function PanelCloseFunc_Skill()
  if false == _ContentsGroup_RenewUI_Skill then
    HandleMLUp_SkillWindow_Close()
  else
    PaGlobalFunc_Skill_Close()
  end
end
function PanelCloseFunc_ChatOption()
  ChattingOption_Close()
end
function PanelCloseFunc_ChattingInput()
  ChatInput_Close()
end
function PanelCloseFunc_Inventory()
  InventoryWindow_Close()
  if Instance_Window_Equipment:GetShow() then
    Equipment_SetShow(false)
  end
end
function PanelCloseFunc_Looting()
end
function PanelCloseFunc_MessageBox()
  messageBox_CloseButtonUp()
end
function PanelCloseFunc_Equip_Close()
  if Instance_Window_Inventory:GetShow(true) then
    PanelCloseFunc_Inventory()
  else
    Equipment_SetShow(false)
  end
end
function PanelCloseFunc_WebControl()
  Panel_WebHelper_ShowToggle()
end
function PanelCloseFunc_TrayConfirm()
  if nil == PaGlobal_TrayConfirm then
    return
  end
  PaGlobal_TrayConfirm:close()
end

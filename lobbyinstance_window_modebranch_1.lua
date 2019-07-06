function PaGlobal_ModeBranch:initialize()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  if true == PaGlobal_ModeBranch._initialize then
    return
  end
  PaGlobal_ModeBranch._ui._txt_branchDesc:SetText("")
  PaGlobal_ModeBranch._ui._txt_branchDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  for index = 1, 3 do
    PaGlobal_ModeBranch._ui._stcModeBg[index] = UI.getChildControl(PaGlobal_ModeBranch._ui._stc_BranchMiddleGroup, "Static_Branch_" .. index .. "BG")
    PaGlobal_ModeBranch._ui._radiobtn[index] = UI.getChildControl(PaGlobal_ModeBranch._ui._stcModeBg[index], "Radiobutton_Branch")
    PaGlobal_ModeBranch._ui._stcLockbtn[index] = UI.getChildControl(PaGlobal_ModeBranch._ui._stcModeBg[index], "Static_Branch_Lock")
    PaGlobal_ModeBranch._ui._txtLockdesc[index] = UI.getChildControl(PaGlobal_ModeBranch._ui._stcModeBg[index], "StaticText_Branch_LockDesc")
  end
  PaGlobal_ModeBranch:resizePanel()
  PaGlobal_ModeBranch:registEventHandler()
end
function PaGlobal_ModeBranch:registEventHandler()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  for index = 1, #PaGlobal_ModeBranch._ui._stcModeBg do
    PaGlobal_ModeBranch._ui._radiobtn[index]:addInputEvent("Mouse_On", "HandleEventOnOut_ModeBranch_SelectedBtn(" .. index .. ",true)")
    PaGlobal_ModeBranch._ui._radiobtn[index]:addInputEvent("Mouse_Out", "HandleEventOnOut_ModeBranch_SelectedBtn(" .. index .. ",false)")
    PaGlobal_ModeBranch._ui._txtLockdesc[index]:addInputEvent("Mouse_On", "HandleEventOnOut_ModeBranch_SelectedBtn(" .. index .. ",true)")
    PaGlobal_ModeBranch._ui._txtLockdesc[index]:addInputEvent("Mouse_Out", "HandleEventOnOut_ModeBranch_SelectedBtn(" .. index .. ",false)")
  end
  PaGlobal_ModeBranch._ui._btn_close:addInputEvent("Mouse_LUp", "HandleEventLUp_ModeBranch_CloseBtn()")
  registerEvent("onScreenResize", "PaGlobal_ModeBranch_ResizePanel")
end
function PaGlobal_ModeBranch:open()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  local nowSeasonScore = ToClient_GetBattleRoyaleCurrentSeasonScore(PaGlobal_ModeBranch._selectedMode)
  if nil == nowSeasonScore then
    return
  end
  nowSeasonScore = Int64toInt32(nowSeasonScore)
  PaGlobal_ModeBranch:resizePanel()
  for index = 1, #PaGlobal_ModeBranch._ui._stcModeBg do
    HandleEventOnOut_ModeBranch_SelectedBtn(#PaGlobal_ModeBranch._ui._stcModeBg - index, false)
    local limitTierKey = PaGlobal_ModeBranch._limitTier[index]
    local tierWrapper = ToClient_GetBattleRoyaleTierByIndex(limitTierKey - 1)
    local needPoint = tierWrapper:getRankScore()
    local isSearch = false
    if nil ~= PaGlobalFunc_RandomMatch_GetSearchStatus then
      isSearch = PaGlobalFunc_RandomMatch_GetSearchStatus()
    end
    if true == isSearch then
      PaGlobal_ModeBranch._ui._radiobtn[index]:addInputEvent("Mouse_LUp", "")
      PaGlobal_ModeBranch._ui._radiobtn[index]:SetMonoTone(true)
      PaGlobal_ModeBranch._ui._stcLockbtn[index]:SetShow(true)
    elseif nowSeasonScore >= needPoint then
      PaGlobal_ModeBranch._ui._radiobtn[index]:addInputEvent("Mouse_LUp", "HandleEventLUp_ModeBranch_SelectedBtn(" .. index .. ")")
      PaGlobal_ModeBranch._ui._radiobtn[index]:SetMonoTone(false)
      PaGlobal_ModeBranch._ui._stcLockbtn[index]:SetShow(false)
      PaGlobal_ModeBranch._ui._txtLockdesc[index]:SetShow(false)
    else
      PaGlobal_ModeBranch._ui._radiobtn[index]:addInputEvent("Mouse_LUp", "")
      PaGlobal_ModeBranch._ui._radiobtn[index]:SetMonoTone(true)
      PaGlobal_ModeBranch._ui._stcLockbtn[index]:SetShow(true)
      PaGlobal_ModeBranch._ui._txtLockdesc[index]:SetShow(true)
      PaGlobal_ModeBranch._ui._txtLockdesc[index]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MODEBRANCH_BETTING_CONDITION", "tier", tierWrapper:getTitle()))
    end
  end
  LobbyInstance_Window_ModeBranch:SetShow(true)
end
function PaGlobal_ModeBranch:close()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  PaGlobal_ModeBranch._selectedMode = nil
  PaGlobal_ModeBranch:resetRadiobutton()
  if true == PaGlobalFunc_Leave_GetIsRandom() then
    PaGlobalFunc_Leave_SetIsRandom(false)
  else
  end
  if true == ToClient_IsLoadingInstanceField() then
    FaGlobal_result_on()
  end
  PaGlobal_ModeBranch._ui._txt_branchDesc:SetText("")
  LobbyInstance_Window_ModeBranch:SetShow(false)
end
function PaGlobal_ModeBranch:resizePanel()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  local screenX, screenY
  screenX = getScreenSizeX()
  screenY = getScreenSizeY()
  if screenY <= PaGlobal_ModeBranch._originalPanelSizeY + 20 then
    LobbyInstance_Window_ModeBranch:SetPosY(30)
    LobbyInstance_Window_ModeBranch:SetSize(screenX, LobbyInstance_Window_ModeBranch:GetSizeY())
  elseif screenY <= PaGlobal_ModeBranch._originalPanelSizeY + 170 then
    LobbyInstance_Window_ModeBranch:SetPosY(PaGlobal_ModeBranch._originalPanelPosY * 0.2)
    LobbyInstance_Window_ModeBranch:SetSize(screenX, LobbyInstance_Window_ModeBranch:GetSizeY())
  else
    LobbyInstance_Window_ModeBranch:SetPosY(150)
    LobbyInstance_Window_ModeBranch:SetSize(screenX, LobbyInstance_Window_ModeBranch:GetSizeY())
  end
  for index = 1, 3 do
    PaGlobal_ModeBranch._ui._radiobtn[index]:ComputePos()
  end
  PaGlobal_ModeBranch._ui._txt_branchDesc:ComputePos()
  PaGlobal_ModeBranch._ui._stc_BranchMiddleGroup:ComputePos()
  LobbyInstance_Window_ModeBranch:ComputePos()
end
function PaGlobal_ModeBranch:resetRadiobutton()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  for index = 1, #PaGlobal_ModeBranch._ui._stcModeBg do
    PaGlobal_ModeBranch._ui._radiobtn[index]:SetCheck(false)
  end
end
function PaGlobal_ModeBranch_SoloPlay()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  if false == PaGlobal_ModeBranch:checkBettingKey() then
    return
  end
  if true == ToClient_isInstanceFieldServer() and _ContentsGroup_RedDesert then
    ToClient_BattleRoyaleJoinQueue(__eBattleRoyaleMode_Solo, PaGlobal_ModeBranch._selectedBettingKey)
  else
    ToClient_RejoinBattleRoyale(PaGlobal_ModeBranch._selectedBettingKey)
  end
end
function PaGlobal_ModeBranch_PartyPlay()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  local partyCount = RequestParty_getPartyMemberCount()
  if partyCount > 0 then
    for i = 0, partyCount - 1 do
      if RequestParty_isSelfPlayer(i) then
        local data = RequestParty_getPartyMemberAt(i)
        if false == data._isMaster then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_NOPARTYBOSS"))
          PaGlobal_ModeBranch_Close()
          return
        end
        break
      end
    end
    if partyCount > 3 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_PARTYPLAY_MAX"))
      PaGlobal_ModeBranch_Close()
      return
    end
  end
  if false == PaGlobal_ModeBranch:checkBettingKey() then
    return
  end
  if true == ToClient_isInstanceFieldServer() and _ContentsGroup_RedDesert then
    ToClient_BattleRoyaleJoinQueue(__eBattleRoyaleMode_Team, PaGlobal_ModeBranch._selectedBettingKey)
  else
    ToClient_RejoinBattleRoyale(PaGlobal_ModeBranch._selectedBettingKey)
  end
end
function PaGlobal_ModeBranch:checkBettingKey()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  local result = false
  if nil == PaGlobal_ModeBranch._selectedBettingKey then
    return result
  end
  local bettingScore = PaGlobal_ModeBranch._selectedBettingKey:get()
  if nil == bettingScore then
    return result
  end
  if nil ~= PaGlobal_ModeBranch._selectedMode then
  elseif false == (__eBattleRoyaleMode_Solo == PaGlobal_ModeBranch._selectedMode or __eBattleRoyaleMode_Team == PaGlobal_ModeBranch._selectedMode) then
    return result
  end
  local nowSeasonScore = ToClient_GetBattleRoyaleCurrentSeasonScore(PaGlobal_ModeBranch._selectedMode)
  if nil == nowSeasonScore then
    return result
  end
  nowSeasonScore = Int64toInt32(nowSeasonScore)
  if bettingScore <= nowSeasonScore then
    result = true
  end
  return result
end
function PaGlobal_ModeBranch_PartyMessageCheck()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  local partyCount = RequestParty_getPartyMemberCount()
  if partyCount < 3 then
    FGlobal_PartyList_ShowToggle()
  end
  PaGlobal_ModeBranch_Close()
end
function PaGlobal_ModeBranch_SoloMessageCheck()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  PaGlobal_ModeBranch_Close()
end
function PaGlobal_ModeBranch:returnNowModeValue()
  if nil == PaGlobal_ModeBranch._selectedBettingKey then
    PaGlobal_ModeBranch._selectedBettingKey = 2
  end
  local bettingKeyindex = 0
  for index = 1, #PaGlobal_ModeBranch._ui._stcModeBg do
    local bettingKeyData = ToClient_GetBettingScoreKey(index - 1)
    if nil ~= bettingKeyData and bettingKeyData:get() == PaGlobal_ModeBranch._selectedBettingKey:get() then
      bettingKeyindex = index - 1
    end
  end
  return PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MODEBRANCH_BETTINGKEY" .. bettingKeyindex .. "_TITLE")
end
function PaGlobal_ModeBranch_MessageBox_SoloPlay()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  local modeValue = PaGlobal_ModeBranch:returnNowModeValue()
  local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_SOLOPLAY_RENEW_MSG", "mode", modeValue)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_BATTLEROYAL_ENTER"),
    content = messageContent,
    functionYes = PaGlobal_ModeBranch_SoloPlay,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_ModeBranch_MessageBox_RandomPartyPlay()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  local modeValue = PaGlobal_ModeBranch:returnNowModeValue()
  local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_PARTYPLAY_RENEW_MSG", "mode", modeValue)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_BATTLEROYAL_ENTER"),
    content = messageContent,
    functionYes = PaGlobalFunc_ModeBranch_RandomPartyPlay,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_ModeBranch_RandomPartyPlay()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  if false == PaGlobal_ModeBranch:checkBettingKey() then
    return
  end
  PaGlobalFunc_RandomMatch_SearchStart(PaGlobal_ModeBranch._selectedBettingKey)
end
function PaGlobal_ModeBranch_MessageBox_PartyPlay()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  local partyCount = RequestParty_getPartyMemberCount()
  local messageContent = ""
  local modeValue = PaGlobal_ModeBranch:returnNowModeValue()
  if partyCount < 3 then
    messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_PARTYPLAY_RENEW_ALERTMSG", "mode", modeValue)
  else
    messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_PARTYPLAY_RENEW_MSG", "mode", modeValue)
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_BATTLEROYAL_ENTER"),
    content = messageContent,
    functionYes = PaGlobal_ModeBranch_PartyPlay,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_ModeBranch_ResizePanel()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  PaGlobal_ModeBranch:resizePanel()
end
function PaGlobal_ModeBranch_Open(mode)
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  if nil == mode then
    return
  end
  PaGlobal_ModeBranch._selectedMode = mode
  PaGlobal_ModeBranch:open()
end
function PaGlobal_ModeBranch_Close()
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  PaGlobal_ModeBranch:close()
end

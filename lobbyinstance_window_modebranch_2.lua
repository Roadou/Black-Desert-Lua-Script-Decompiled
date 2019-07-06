function HandleEventLUp_ModeBranch_SelectedBtn(index)
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  if nil == index then
    return
  end
  local selectBettingKeyData = ToClient_GetBettingScoreKey(index - 1)
  if nil == selectBettingKeyData then
    return
  end
  local selectBettingKey = selectBettingKeyData
  if nil == selectBettingKey then
    return
  end
  PaGlobal_ModeBranch._selectedBettingKey = selectBettingKey
  if __eBattleRoyaleMode_Solo == PaGlobal_ModeBranch._selectedMode then
    PaGlobal_ModeBranch_MessageBox_SoloPlay()
  elseif __eBattleRoyaleMode_Team == PaGlobal_ModeBranch._selectedMode then
    if false == PaGlobalFunc_Leave_GetIsRandom() then
      PaGlobal_ModeBranch_MessageBox_PartyPlay()
    else
      PaGlobal_ModeBranch_MessageBox_RandomPartyPlay()
    end
  else
    return
  end
end
function HandleEventOnOut_ModeBranch_SelectedBtn(index, isMouseOver)
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  if nil == index or nil == isMouseOver then
    return
  end
  if nil == PaGlobal_ModeBranch._ui._radiobtn[index] then
    return
  end
  local selectBettingKeyData = ToClient_GetBettingScoreKey(index - 1)
  if nil == selectBettingKeyData then
    return
  end
  if true == isMouseOver then
    local descText = PaGlobal_ModeBranch._modeDesc[index]
    if nil ~= descText then
      PaGlobal_ModeBranch._ui._txt_branchDesc:SetText(descText)
    end
  end
end
function HandleEventLUp_ModeBranch_CloseBtn()
  PaGlobal_ModeBranch:close()
end

function PaGlobalFunc_LobbyInstance_RandomMatchOpen()
  if nil == PaGlobal_RandomMatch then
    return
  end
  PaGlobal_RandomMatch:open()
end
function FromClient_LobbyInstance_RandomMatchAck(isSuccess)
  if nil == LobbyInstance_Widget_RandomMatch then
    return
  end
  if nil == LobbyInstance_Window_ModeBranch then
    return
  end
  if nil == isSuccess then
    UI.ASSERT_NAME(false, "RandomMatch nil\234\176\146\236\157\180 \235\147\164\236\150\180\236\152\164\235\169\180 \236\149\136\235\144\169\235\139\136\235\139\164.", "\234\185\128\236\157\152\236\167\132")
  end
  if true == isSuccess then
    if false == LobbyInstance_Window_ModeBranch:GetShow() then
      return
    end
    PaGlobal_RandomMatch._isSearch = true
    PaGlobal_ModeBranch_Close()
    PaGlobalFunc_LobbyInstance_RandomMatchOpen()
  else
    PaGlobal_RandomMatch._isSearch = false
    PaGlobal_RandomMatch:close()
  end
  PaGlobalFunc_Leave_SetIsRandom(false)
end
function PaGlobalFunc_RandomMatch_GetSearchStatus()
  return PaGlobal_RandomMatch._isSearch
end
function PaGlobalFunc_RandomMatch_SearchStart(scoreKey)
  if true == PaGlobal_RandomMatch._isSearch then
    return
  end
  UI.ASSERT_NAME(nil ~= scoreKey, "PaGlobalFunc_RandomMatch_SearchStart scroeKey\234\176\128 nil", "\234\185\128\236\157\152\236\167\132")
  if nil == scoreKey then
    return
  end
  ToClient_JoinRandomParty(scoreKey)
end
function PaGlobalFunc_RandomMatch_SearchCancel()
  if false == PaGlobal_RandomMatch._isSearch then
    return
  end
  ToClient_CancelRandomParty()
end

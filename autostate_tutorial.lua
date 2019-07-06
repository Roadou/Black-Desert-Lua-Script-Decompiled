AutoState_Tutorial = {
  _state = AutoStateType.TUTORIAL,
  _curMsgIndex = 0
}
function AutoState_Tutorial:init()
end
function AutoState_Tutorial:start()
  PaGlobal_AutoQuestMsg._accessBlackSpiritClick = AutoState_Tutorial_AccessBlackSpiritclick
  self._curMsgIndex = 0
  AutoState_Tutorial_AccessBlackSpiritclick()
end
function AutoState_Tutorial:update(deltaTime)
end
function AutoState_Tutorial:endProc()
  PaGlobal_AutoQuestMsg._accessBlackSpiritClick = nil
  self._curMsgIndex = 0
end
function AutoState_Tutorial_AccessBlackSpiritclick()
  local self = AutoState_Tutorial
  if 0 == self._curMsgIndex then
    FGlobal_AutoQuestBlackSpiritMessage("[TEST] \237\138\156\237\134\160\235\166\172\236\150\188 \236\139\156\236\158\145. \235\178\132\237\138\188 \235\136\132\235\165\180\235\169\180 \235\139\164\236\157\140 \235\169\148\236\132\184\236\167\128 \235\130\152\236\152\181\235\139\136\235\139\164. ")
  elseif 1 == self._curMsgIndex then
    FGlobal_AutoQuestBlackSpiritMessage("[TEST] \237\138\156\237\134\160\235\166\172\236\150\188 \236\132\164\235\170\133, ...\235\182\136\235\157\188\235\182\136\235\157\188....")
  elseif 2 == self._curMsgIndex then
    FGlobal_AutoQuestBlackSpiritMessage("[TEST] \237\138\156\237\134\160\235\166\172\236\150\188 \236\132\164\235\170\133 \235\129\157 \237\149\156\235\178\136\235\141\148 \235\178\132\237\138\188 \235\136\132\235\165\180\235\169\180 \236\167\132\237\150\137 \237\149\160 \234\186\188\236\151\144\236\154\148. ")
  else
    Auto_TransferState(AutoStateType.EXCEPTION_GUIDE)
    return
  end
  self._curMsgIndex = self._curMsgIndex + 1
end

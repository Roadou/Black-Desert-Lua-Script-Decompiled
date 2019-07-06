function FGlobal_Show_WillJoinBattleGround_Alert(sec)
  local msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WILLUNJOIN_BATTLEGROUND_BY_BOSSMONSTER", "sec", sec)
  FGlobal_Show_AlertMessage(msg, 4)
end
registerEvent("FromClient_WillUnjoinBattleGround", "FGlobal_Show_WillJoinBattleGround_Alert")

function FromClient_AutoStart()
  if false == _ContentsGroup_RenewUI then
    PaGlobal_AutoManager:start(false)
  end
end
function FromClient_AutoStop()
  PaGlobal_AutoManager:stop()
end
function FromClient_Auto_StartNaviMove()
  local navi = ToClient_currentNaviisMainQuest()
  if navi or AutoState_Move:isReservation() == true then
    Auto_TransferState(AutoStateType.MOVE)
  end
end
function FromClient_Auto_EndNaviMove()
  if ToClient_getAutoMode() == CppEnums.Client_AutoControlStateType.BATTLE then
    Auto_TransferState(AutoStateType.HUNT)
    return
  end
  if PaGlobal_AutoManager._stateUnit ~= nil and PaGlobal_AutoManager._stateUnit._state == AutoStateType.MOVE and AutoState_Move:isReservation() == true then
    FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_EXCEPTIONCONDITION"))
    PaGlobal_AutoManager:stop()
    return
  end
  if ToClient_getNaviEndPointDist() < 200 and Auto_FindNearQuestMonster() == true then
    Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
  else
    Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
  end
end
function FromClient_Auto_EndNaviMove_dueUserControl()
end
function FromClient_Auto_SomeQuestClear(questNo)
  Auto_QuestClearNotify(questNo)
end
function FromClient_Auto_FindWayEnd()
  FromClient_Auto_EndNaviMove()
end
function FromClient_Auto_NotifyChangetoBattle_dueMobBlockWay()
  AutoState_Hunt:setReserveReason(AutoHuntState_Type.EXISTNEARMONSTER)
  Auto_TransferState(AutoStateType.HUNT)
end
function FromClient_Auto_NotifyDead()
  Auto_TransferState(AutoStateType.DEAD)
end
function FromClient_Auto_NotifyRevive()
  if PaGlobal_AutoManager._ActiveState == true then
    Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
  end
end
registerEvent("FromClient_Auto_StartNaviMove", "FromClient_Auto_StartNaviMove")
registerEvent("FromClient_Auto_EndNaviMove", "FromClient_Auto_EndNaviMove")
registerEvent("FromClient_Auto_EndNaviMove_dueUserControl", "FromClient_Auto_EndNaviMove_dueUserControl")
registerEvent("FromClient_Auto_SomeQuestClear", "FromClient_Auto_SomeQuestClear")
registerEvent("FromClient_AutoStart", "FromClient_AutoStart")
registerEvent("FromClient_AutoStop", "FromClient_AutoStop")
registerEvent("FromClient_Auto_FindWayEnd", "FromClient_Auto_FindWayEnd")
registerEvent("FromClient_Auto_NotifyChangetoBattle_dueMobBlockWay", "FromClient_Auto_NotifyChangetoBattle_dueMobBlockWay")
registerEvent("FromClient_Auto_NotifyDead", "FromClient_Auto_NotifyDead")
registerEvent("FromClient_Auto_NotifyRevive", "FromClient_Auto_NotifyRevive")

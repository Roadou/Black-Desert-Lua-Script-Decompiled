function FromClient_WatchTimer_BattleRoyaleStateChanged(state)
  if 2 == state then
    PaGlobalFunc_WatchTimer_Open()
  end
end
function FromClient_WatchTimer_BattleRoyaleRecord()
  PaGlobalFunc_WatchTimer_Close()
end
function FromClient_WatchTimer_ClassChangeBattleRoyale()
  PaGlobal_WatchTimer:checkClass()
end
function FromClient_WatchTimer_onScreenResize()
  PaGlobal_WatchTimer:onScreenResize()
end
registerEvent("FromClient_ClassChangeBattleRoyale", "FromClient_WatchTimer_ClassChangeBattleRoyale")
registerEvent("FromClient_BattleRoyaleStateChanged", "FromClient_WatchTimer_BattleRoyaleStateChanged")
registerEvent("FromClient_BattleRoyaleRecord", "FromClient_WatchTimer_BattleRoyaleRecord")
registerEvent("onScreenResize", "FromClient_WatchTimer_onScreenResize")

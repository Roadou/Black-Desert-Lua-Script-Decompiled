function PaGlobal_GuideMessage_UpdatePerFrame(deltaTime)
  PaGlobal_GuideMessage:updateTimer(deltaTime)
  PaGlobal_GuideMessage:updateCheckCurrentState()
end
function FromClient_GuideMessage_BattleRoyaleStateChanged(state)
  if 2 ~= state then
    return
  end
  PaGlobal_GuideMessage:startTimer()
end
function FromClient_GuideMessage_ClassChangeBattleRoyale()
  PaGlobal_GuideMessage:endStateTwo()
end

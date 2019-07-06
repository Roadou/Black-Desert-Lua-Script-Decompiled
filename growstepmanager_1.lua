function PaGlobal_GrowStepManager:initialize()
  if true == PaGlobal_GrowStepManager._initialize then
    return
  end
  PaGlobal_GrowStepManager:registerEventHandler()
  PaGlobal_GrowStepManager._initialize = true
end
function PaGlobal_GrowStepManager:registerEventHandler()
  if false == _ContentsGroup_ESCMenu_Remake then
    registerEvent("FromClient_notifyUpdateGrowStep", "FromClient_GrowStepManager_notifyUpdateGrowStep")
  end
end

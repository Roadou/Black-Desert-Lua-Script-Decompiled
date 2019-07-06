function PaGlobalFunc_DialogIntimacy_All_Open()
  PaGlobal_DialogIntimacy_All:prepareOpen()
end
function PaGlobalFunc_DialogIntimacy_All_Close()
  PaGlobal_DialogIntimacy_All:prepareClose()
end
function HandleEventOnOut_DialogIntimacy_All_CircleTooltip(isShow)
end
function PaGloabl_PaGlobal_DialogIntimacy_All_ShowAni()
  if nil == Panel_Npc_Intimacy_All then
    return
  end
end
function PaGloabl_PaGlobal_DialogIntimacy_All_HideAni()
  if nil == Panel_Npc_Intimacy_All then
    return
  end
end
function FromClient_DialogIntimacy_All_VaryIntimacy()
  PaGlobalFunc_DialogIntimacy_All_VaryIntimacy()
end
function PaGlobalFunc_DialogIntimacy_All_VaryIntimacy()
  if Defines.UIMode.eUIMode_NpcDialog == GetUIMode() then
    PaGlobal_DialogIntimacy_All:intimacyValueUpdate()
  end
end

local _swapSetShowTable = {}
function checkHpAlertPostEvent()
  PaGlobalFunc_MainStatus_CheckHpAlertPostEvent()
end
function FGlobal_DangerAlert_Show(isShow)
  PaGlobalFunc_MainStatus_DangerAlertShow(isShow)
end
function PaGlobalFunc_MainStatusInfo_DangerAlertShow(isShow)
  PaGlobalFunc_MainStatus_DangerAlertShow(isShow)
end
function Panel_MainStatus_User_Bar_Onresize()
  FromClient_MainStatus_OnResize()
end
function Panel_SelfPlayerExpGage_SetShow(isShow, isAni)
  PaGlobalFunc_MainStatus_SetShow(isShow)
end
function PaGlobalFunc_MainStatusInfo_Open()
  if true == PaGlobalFunc_MainStatus_GetShow() then
    return
  end
  PaGlobalFunc_MainStatus_SetShow(true)
end
function PaGlobalFunc_MainStatusInfo_Close()
  PaGlobalFunc_MainStatus_SetShow(false)
end
function FGlobal_ImmediatelyResurrection(resurrFunc)
  PaGlobalFunc_MainStatus_ImmediatelyResurrection(resurrFunc)
end
function Panel_MainStatus_User_Bar_CharacterInfoWindowUpdate()
  PaGlobalFunc_MainStatus_CharacterInfoWindowUpdate()
end
function PaGlobalFunc_MainStatusInfo_UpdateHPAndMP()
  PaGlobalFunc_MainStatus_UpdateHP()
  PaGlobalFunc_MainStatus_UpdateMP()
end
function PvpMode_ShowButton(isShow)
  PaGlobalFunc_MainStatus_ShowPVPButton(isShow)
end
function FGlobal_ClassResource_SetShowControl(isShow)
end
function FromClient_MainStatus_SwapUIOption(isRemaster)
end

local UIMode = Defines.UIMode
local IM = CppEnums.EProcessorInputMode
function appear_blackSpirit(questNo, blackSpiritUIType)
  ToClient_SaveUiInfo(false)
  close_WindowPanelList()
  local preUIMode = GetUIMode()
  SetUIMode(UIMode.eUIMode_NpcDialog_Dummy)
  local callSummon = RequestAppearBlackSpirit(questNo, blackSpiritUIType)
  if callSummon then
    if true == _ContentsGroup_RenewUI_Dailog then
      PaGlobalFunc_MainDialog_Close()
      PaGlobalFunc_Dialog_Main_SetRenderMode()
    elseif false == _ContentsGroup_NewUI_Dialog_All then
      Panel_Npc_Dialog:SetShow(false)
      FGlobal_Dialog_renderMode:set()
    else
      PaGlobalFunc_DialogMain_All_ShowToggle(false)
      PaGlobal_DialogMain_All._renderMode:set()
    end
    ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_BLACKSPIRIT")
  else
    SetUIMode(preUIMode)
    ToClient_PopBlackSpiritFlush()
    if true == _ContentsGroup_RenewUI_Dailog then
      PaGlobalFunc_MainDialog_Close()
    elseif false == _ContentsGroup_NewUI_Dialog_All then
      Panel_Npc_Dialog:SetShow(false)
    else
      PaGlobalFunc_DialogMain_All_ShowToggle(false)
    end
  end
end
registerEvent("appear_blackSpirit", "appear_blackSpirit")

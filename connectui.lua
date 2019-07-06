eConnectUiType = {
  eConnectUi_Undefined = -1,
  eConnectUi_BlackStone = 0,
  eConnectUi_Socket = 1,
  eConnectUi_Beer = 2,
  eConnectUi_Improve = 3,
  eConnectUi_DyePalette = 4,
  eConnectUi_AchievementBook1 = 5,
  eConnectUi_AchievementBook2 = 6,
  eConnectUi_AchievementBook3 = 7,
  eConnectUi_AchievementBook4 = 8,
  eConnectUi_AchievementBook5 = 9,
  eConnectUi_AchievementBook6 = 10,
  eConnectUi_AchievementBook7 = 11,
  eConnectUi_AchievementBook8 = 12,
  eConnectUi_AchievementBook9 = 13,
  eConnectUi_AchievementBook10 = 14,
  eConnectUi_TravelBook1 = 15,
  eConnectUi_HorseBook1 = 16,
  eConnectUi_HorseBook2 = 17,
  eConnectUi_Count = 18
}
function ConnectUI(connectUiType)
  if eConnectUiType.eConnectUi_BlackStone == connectUiType then
    if false == ToClient_IsGrowStepOpen(__eGrowStep_enchant) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GROWSTEP_IS_NOT_OPEN"))
      return
    end
    if not IsSelfPlayerWaitAction() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT"))
      return
    end
    ToClient_AddBlackSpiritFlush(0, true, CppEnums.EFlush_BlackSpirit_Ui_Type.eFlush_BlackSpirit_Ui_ItemEnchant)
  elseif eConnectUiType.eConnectUi_Socket == connectUiType then
    if false == ToClient_IsGrowStepOpen(__eGrowStep_enchantSocket) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GROWSTEP_IS_NOT_OPEN"))
      return
    end
    if not IsSelfPlayerWaitAction() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT"))
      return
    end
    ToClient_AddBlackSpiritFlush(0, true, CppEnums.EFlush_BlackSpirit_Ui_Type.eFlush_BlackSpirit_Ui_Socket)
  elseif eConnectUiType.eConnectUi_Beer == connectUiType then
    if true == _ContentsGroup_NewUI_WorkerManager_All then
      PaGlobalFunc_WorkerManager_All_ShowToggle()
    else
      FGlobal_WorkerManger_ShowToggle()
    end
  elseif eConnectUiType.eConnectUi_Improve == connectUiType then
    if false == ToClient_IsGrowStepOpen(__eGrowStep_improveItem) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GROWSTEP_IS_NOT_OPEN"))
      return
    end
    if not IsSelfPlayerWaitAction() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT"))
      return
    end
    ToClient_AddBlackSpiritFlush(0, true, CppEnums.EFlush_BlackSpirit_Ui_Type.eFlush_BlackSpirit_Ui_Improve)
  elseif eConnectUiType.eConnectUi_DyePalette == connectUiType then
    HandleClicked_Inventory_Palette_Open()
  elseif eConnectUiType.eConnectUi_AchievementBook1 == connectUiType then
    PaGlobalFunc_Achievement_Open(1)
  elseif eConnectUiType.eConnectUi_AchievementBook2 == connectUiType then
    PaGlobalFunc_Achievement_Open(2)
  elseif eConnectUiType.eConnectUi_AchievementBook3 == connectUiType then
    PaGlobalFunc_Achievement_Open(3)
  elseif eConnectUiType.eConnectUi_AchievementBook4 == connectUiType then
    PaGlobalFunc_Achievement_Open(4)
  elseif eConnectUiType.eConnectUi_AchievementBook5 == connectUiType then
    PaGlobalFunc_Achievement_Open(5)
  elseif eConnectUiType.eConnectUi_AchievementBook6 == connectUiType then
    PaGlobalFunc_Achievement_Open(6)
  elseif eConnectUiType.eConnectUi_AchievementBook7 == connectUiType then
    PaGlobalFunc_Achievement_Open(7)
  elseif eConnectUiType.eConnectUi_AchievementBook8 == connectUiType then
    PaGlobalFunc_Achievement_Open(8)
  elseif eConnectUiType.eConnectUi_AchievementBook9 == connectUiType then
    PaGlobalFunc_Achievement_Open(9)
  elseif eConnectUiType.eConnectUi_AchievementBook10 == connectUiType then
    PaGlobalFunc_Achievement_Open(10)
  elseif eConnectUiType.eConnectUi_TravelBook1 == connectUiType then
    PaGlobalFunc_Achievement_Open(11)
  elseif eConnectUiType.eConnectUi_HorseBook1 == connectUiType then
    PaGlobalFunc_Achievement_Open(12)
  else
    if eConnectUiType.eConnectUi_HorseBook2 == connectUiType then
      PaGlobalFunc_Achievement_Open(13)
    else
    end
  end
end

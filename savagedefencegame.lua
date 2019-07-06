local UI_TM = CppEnums.TextMode
local nextWaveCount = 0
function FromClient_StartSavageDefenceWave()
  nextWaveCount = ToClient_SavageDefenceNextWave()
  local nextwaveTime = ToClient_SavageDefenceNextTime()
  if nextWaveCount == 1 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_START"))
  end
  local isMsg = {
    main = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEGAME_MESSAGE", "time", tostring(nextwaveTime), "wave", tostring(nextWaveCount)),
    sub = "",
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect(isMsg, 6, 67)
end
function FromClient_EndSavageDefenceWave(isMaxProcess)
  if false == isMaxProcess then
    local Msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_FAIL_END"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_MOVE_CHANNEL"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(Msg, 5, 73, false)
  else
    local Msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_SUCCESS_GAME"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_MOVE_CHANNEL"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(Msg, 5, 72, false)
  end
end
function FromClient_SavageDefenceNotifyBossMonster(charactername)
end
function FromClient_UpdateSavageDefenceData(remainTime)
  SavageDefenceWave_UpdateWaveTime(remainTime, nextWaveCount)
end
function FromClient_OpenSavageDefenceUI()
  SavageDefenceMember_Open(true)
  SavageDefenceTowerHp_Open()
  SavageDefenceWave_Open()
  nextWaveCount = ToClient_SavageDefenceNextWave()
end
function FromClient_AlertAbusingRound()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEGAME_ROUNDALERT"))
end
FromClient_OpenSavageDefenceUI()
registerEvent("FromClient_joinSavageDefence", "FromClient_OpenSavageDefenceUI")
registerEvent("FromClient_StartSavageDefenceWave", "FromClient_StartSavageDefenceWave")
registerEvent("FromClient_AlertAbusingRound", "FromClient_AlertAbusingRound")
registerEvent("FromClient_EndSavageDefenceWave", "FromClient_EndSavageDefenceWave")
registerEvent("FromClient_SavageDefenceNotifyBossMonster", "FromClient_SavageDefenceNotifyBossMonster")
registerEvent("FromClient_UpdateSavageDefenceData", "FromClient_UpdateSavageDefenceData")

Panel_SavageDefenceWave:SetShow(false)
local SavageDefenceWave = {
  _wavecount = UI.getChildControl(Panel_SavageDefenceWave, "StaticText_WaveCount"),
  _waveTime = UI.getChildControl(Panel_SavageDefenceWave, "StaticText_WaveTime"),
  _nextwavecount = -1,
  _remainTime = -1,
  _alertMsg = false
}
function SavageDefenceWave_Open()
  if not ToClient_getPlayNowSavageDefence() then
    return
  end
  SavageDefenceWave._alertMsg = false
  SavageDefenceWave._wavecount:SetText("0")
  SavageDefenceWave._waveTime:SetText("00 : 00")
  Panel_SavageDefenceWave:SetShow(true)
  SavageDefenceWave:SetPosition()
end
function SavageDefenceWave:SetPosition()
  local pivotY = Panel_SavageDefenceShop:GetSizeX() / 2 - 20
end
function SavageDefenceWave_UpdateWaveData(wavecount)
  SavageDefenceWave._wavecount:SetText(tostring(wavecount))
end
function SavageDefenceWave_UpdateWaveTime(deltaTime, wavecount)
  if deltaTime < 0 then
    deltaTime = 0
  end
  if SavageDefenceWave._alertMsg == false and SavageDefenceWave._nextwavecount == 1 and deltaTime <= 0 then
    SavageDefenceWave._alertMsg = true
    local Msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_WAVE_START"),
      sub = "",
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(Msg, 5, 74, false)
  end
  if SavageDefenceWave._nextwavecount ~= wavecount then
    SavageDefenceWave._nextwavecount = wavecount
    SavageDefenceWave._wavecount:SetText(tostring(wavecount))
  end
  if SavageDefenceWave._remainTime ~= deltaTime then
    SavageDefenceWave._waveTime:SetText(SavageDefenceWave_GetTimeFormat(deltaTime))
    SavageDefenceWave._remainTime = deltaTime
  end
end
function SavageDefenceWave_GetTimeFormat(remainTime)
  local strminute = "00"
  local standardMinute = 60
  local remainSeconds = remainTime % standardMinute
  local remainMinute = remainTime - remainSeconds
  if remainTime >= standardMinute then
    strminute = SavageDefenceWave_GetTimeUnit(remainMinute / standardMinute)
  end
  local strsecond = SavageDefenceWave_GetTimeUnit(remainSeconds)
  return strminute .. " : " .. strsecond
end
function SavageDefenceWave_GetTimeUnit(timedata)
  local str = "00"
  if timedata < 10 then
    str = "0" .. tostring(timedata)
  else
    str = tostring(timedata)
  end
  return str
end
function SavageDefenceWave_jumpWave(index)
  ToClient_RequestWaveJumpReq(index)
end

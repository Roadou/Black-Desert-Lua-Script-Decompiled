local MGKT = CppEnums.MiniGameKeyType
local UI_color = Defines.Color
local ui = {
  _timingBG = UI.getChildControl(Panel_MiniGame_Timing, "Static_Timing_BG"),
  _timingProgress = UI.getChildControl(Panel_MiniGame_Timing, "Progress2_Timing"),
  _timingProgress_Head = nil,
  _timing = UI.getChildControl(Panel_MiniGame_Timing, "Static_Timing"),
  _helpArrow = UI.getChildControl(Panel_MiniGame_Timing, "Static_Arrows"),
  _spaceBar = UI.getChildControl(Panel_MiniGame_Timing, "Static_SpaceBar"),
  _spaceBar_Eff = UI.getChildControl(Panel_MiniGame_Timing, "Static_SpaceBar_Eff"),
  _purposeText = UI.getChildControl(Panel_MiniGame_Timing, "StaticText_Purpose"),
  _result_Good = UI.getChildControl(Panel_MiniGame_Timing, "Static_Result_Good"),
  _result_Bad = UI.getChildControl(Panel_MiniGame_Timing, "Static_Result_Bad"),
  _resultText = UI.getChildControl(Panel_MiniGame_Timing, "StaticText_ResultTxt")
}
local _math_random = math.random
local _math_randomSeed = math.randomseed
local _math_lerp = Util.Math.Lerp
local define = {
  progressBar_SpeedPerSec = 0.95,
  progressBar_speedValue3 = 0.9,
  progressBar_speedValue2 = 0.1,
  progressBar_speedValue1 = 0,
  timing_min = 0.3,
  timing_max = 0.4,
  timing_Middle = 0.75,
  timing_Movingmax = 0.95,
  timing_movingSpeed = 2,
  timing_Speed = 2,
  endAnimationTime = 2
}
local currentTimingValue = 0
local currentProgressValue = 0
local isUpTiming = true
local isUpProgress = true
local doMoving = true
local playMode = 0
local progressBarSpeed = 0
local sumTime = 0
local isWin = false
local buoy_WinCount = 0
local isBarMoveStart = false
local function initValue()
  isBarMoveStart = false
  isUpTiming = true
  isUpProgress = true
  sumTime = 0
  progressBarSpeed = 0
end
local function init_Buoy()
  ui._timingProgress_Head = UI.getChildControl(ui._timingProgress, "Progress2_1_Timing_Head")
  Panel_MiniGame_Timing:SetShow(false, false)
  Panel_MiniGame_Timing:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
end
function ScreenSize_RePosition_BuoyGame()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_MiniGame_Timing:SetPosX(scrX / 2 + 200)
  Panel_MiniGame_Timing:SetPosY(scrY / 2 - 150)
end
local function endUIShow_Buoy(controlText, controlResult, color, text, aniText)
  ui._resultText:ResetVertexAni()
  ui._resultText:SetVertexAniRun("Ani_Color_empty", true)
  ui._resultText:SetVertexAniRun("Ani_Color_1", true)
  ui._resultText:SetVertexAniRun("Ani_Scale_0", true)
  ui._resultText:SetVertexAniRun("Ani_Scale_1", true)
  ui._resultText:SetVertexAniRun("Ani_Scale_End", true)
  ui._resultText:SetVertexAniRun("Ani_Color_End", true)
  controlText:SetShow(true)
  controlText:SetText(text)
  controlText:SetFontColor(color)
  controlResult:SetShow(true)
  controlResult:ResetVertexAni()
  controlResult:SetVertexAniRun(aniText .. "_Ani", true)
  controlResult:SetVertexAniRun(aniText .. "_ScaleAni", true)
end
local function successUIShow()
  endUIShow_Buoy(ui._resultText, ui._result_Good, UI_color.C_FF96D4FC, PAGetString(Defines.StringSheet_GAME, "Lua_Minigame_Buoy_0"), "Good")
end
local function failedUIShow_Buoy()
  endUIShow_Buoy(ui._resultText, ui._result_Bad, UI_color.C_FFF26A6A, PAGetString(Defines.StringSheet_GAME, "Lua_Minigame_Buoy_1"), "Bad")
end
local function timing_update_Buoy(deltaTime)
  local sizeY = ui._timingProgress:GetSizeY() * (define.timing_min + (define.timing_max - define.timing_min) * currentTimingValue)
  ui._timing:SetSize(ui._timing:GetSizeX(), sizeY)
  local percent = 1 - define.timing_Middle
  ui._timing:SetPosY(percent * ui._timingProgress:GetSizeY() - sizeY / 2)
  ui._helpArrow:SetPosY(percent * ui._timingProgress:GetSizeY() - ui._helpArrow:GetSizeY() / 2)
  ui._spaceBar:SetPosY(percent * ui._timingProgress:GetSizeY() - ui._spaceBar:GetSizeY() / 2)
  ui._spaceBar_Eff:SetPosY(percent * ui._timingProgress:GetSizeY() - ui._spaceBar_Eff:GetSizeY() / 2)
end
local function progressbar_update_Buoy(deltaTime)
  ui._timingProgress:SetProgressRate(currentProgressValue * 100)
  ui._timingProgress:SetCurrentProgressRate(currentProgressValue * 100)
end
local function playingUpdate_Buoy(deltaTime)
  if false == isBarMoveStart then
    return
  end
  if isUpTiming then
    currentTimingValue = currentTimingValue + deltaTime * define.timing_Speed
    if currentTimingValue > 1 then
      currentTimingValue = 2 - currentTimingValue
      isUpTiming = false
    end
  else
    currentTimingValue = currentTimingValue - deltaTime * define.timing_Speed
    if currentTimingValue < 0 then
      currentTimingValue = -currentTimingValue
      isUpTiming = true
    end
  end
  if isUpProgress then
    sumTime = sumTime + deltaTime * define.progressBar_SpeedPerSec
    if sumTime > 1 then
      sumTime = 1
      isUpProgress = false
    end
  else
    sumTime = sumTime - deltaTime * define.progressBar_SpeedPerSec
    if sumTime <= 0 then
      sumTime = 0
      isUpProgress = true
      failedUIShow_Buoy()
      playMode = 2
      sumTime = 0
      isWin = false
      getSelfPlayer():get():SetMiniGameResult(1)
    end
  end
  currentProgressValue = sumTime * sumTime * sumTime * define.progressBar_speedValue3
  currentProgressValue = currentProgressValue + sumTime * sumTime * define.progressBar_speedValue2
  currentProgressValue = currentProgressValue + sumTime * define.progressBar_speedValue1
  if currentProgressValue >= 1 then
    currentProgressValue = 1
  elseif currentProgressValue <= 0 then
    currentProgressValue = 0
  end
  timing_update_Buoy(deltaTime)
  progressbar_update_Buoy(deltaTime)
end
local function endTimeUpdate_Buoy(deltaTime)
  if false == isBarMoveStart then
    return
  end
  sumTime = sumTime + deltaTime
  if define.endAnimationTime <= sumTime then
    Panel_Minigame_Buoy_End_UI()
    playMode = 3
    isBarMoveStart = false
    initValue()
    for key, value in pairs(ui) do
      value:SetShow(false)
    end
  end
end
function Panel_Minigame_Buoy_Start()
  _math_randomSeed(os.time())
  ui._resultText:ResetVertexAni()
  ui._resultText:SetAlpha(0)
  ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_Minigame_Buoy_2"))
  Panel_MiniGame_Timing:SetShow(true, false)
  currentTimingValue = _math_random(0, 100) / 100
  currentProgressValue = 0
  isUpTiming = true
  isUpProgress = true
  sumTime = 0
  playMode = 1
  for key, value in pairs(ui) do
    value:SetShow(false)
  end
  isBarMoveStart = false
end
function Panel_Minigame_Buoy_ResetCount()
  buoy_WinCount = 0
end
function Panel_Minigame_Buoy_End()
  Panel_MiniGame_Timing:SetShow(false, false)
end
function Panel_Minigame_Buoy_End_UI()
  if isWin then
    getSelfPlayer():get():SetMiniGameResult(0)
  else
    getSelfPlayer():get():SetMiniGameResult(1)
  end
end
local realEndTime = 0
local function realEndTimeUpdate_Buoy(deltaTime)
  realEndTime = realEndTime + deltaTime
  if realEndTime > 2 and buoy_WinCount < 3 then
    playMode = 1
  end
  if buoy_WinCount >= 3 then
    FGlobal_MiniGame_Buoy()
    ToClient_MinigameResult(3, true)
    playMode = 0
  end
end
local failTime = 0
local function failTimer(deltaTime)
  if isWin then
    return
  end
  failTime = failTime + deltaTime
  if failTime > 0.6 and buoy_WinCount < 3 then
    playMode = 1
    failTime = 0
  end
end
function Panel_Minigame_Buoy_Perframe(deltaTime)
  if 4 == playMode then
    realEndTimeUpdate_Buoy(deltaTime)
  elseif playMode == 3 then
    failTimer(deltaTime)
  elseif playMode == 2 then
    endTimeUpdate_Buoy(deltaTime)
  elseif playMode == 1 then
    playingUpdate_Buoy(deltaTime)
  end
end
function Panel_MiniGame_Buoy_WaitInitMode()
  playMode = 4
  realEndTime = 0
end
function Panel_Minigame_Buoy_Freeze(keyType)
  if playMode ~= 1 then
    return
  end
  if false == isBarMoveStart then
    for key, value in pairs(ui) do
      if "_result_Good" ~= key and "_result_Bad" ~= key and "_resultText" ~= key then
        value:SetShow(true)
      end
    end
    getSelfPlayer():get():SetMiniGameResult(2)
    isBarMoveStart = true
    return
  end
  if MGKT.MiniGameKeyType_Space == keyType and Panel_MiniGame_Timing:IsShow() and 1 == playMode then
    local minValue = ui._timing:GetPosY() - ui._timingProgress:GetPosY()
    local maxValue = minValue + ui._timing:GetSizeY()
    local checkPos = ui._timingProgress_Head:GetPosY() + ui._timingProgress_Head:GetSizeY() / 2
    playMode = 2
    sumTime = 0
    isWin = minValue <= checkPos and maxValue >= checkPos
    if isWin then
      audioPostEvent_SystemUi(11, 1)
      endUIShow_Buoy(ui._resultText, ui._result_Good, UI_color.C_FF96D4FC, PAGetString(Defines.StringSheet_GAME, "Lua_Minigame_Buoy_0"), "Good")
      getSelfPlayer():get():SetMiniGameResult(0)
      buoy_WinCount = buoy_WinCount + 1
    else
      audioPostEvent_SystemUi(11, 2)
      endUIShow_Buoy(ui._resultText, ui._result_Bad, UI_color.C_FFF26A6A, PAGetString(Defines.StringSheet_GAME, "Lua_Minigame_Buoy_1"), "Bad")
      getSelfPlayer():get():SetMiniGameResult(1)
    end
  end
end
init_Buoy()
registerEvent("onScreenResize", "ScreenSize_RePosition_BuoyGame")

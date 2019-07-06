local MGKT = CppEnums.MiniGameKeyType
local UI_color = Defines.Color
Mingame_Panel_Timing_Value_isPressed = false
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
  endAnimationTime = 1
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
local function init()
  ui._timingProgress_Head = UI.getChildControl(ui._timingProgress, "Progress2_1_Timing_Head")
  Panel_MiniGame_Timing:SetShow(false, false)
  Panel_MiniGame_Timing:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
  Mingame_Panel_Timing_Value_isPressed = false
end
function ScreenSize_RePosition_TimingGame()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_MiniGame_Timing:SetPosX(scrX / 2 + 200)
  Panel_MiniGame_Timing:SetPosY(scrY / 2 - 150)
end
local function endUIShow(controlText, controlResult, color, text, aniText)
  ui._resultText:ResetVertexAni()
  ui._resultText:SetVertexAniRun("Ani_Color_empty", true)
  ui._resultText:SetVertexAniRun("Ani_Color_1", true)
  ui._resultText:SetVertexAniRun("Ani_Scale_0", true)
  ui._resultText:SetVertexAniRun("Ani_Scale_1", true)
  ui._resultText:SetVertexAniRun("Ani_Scale_End", true)
  ui._resultText:SetVertexAniRun("Ani_Color_End", true)
  _PA_LOG("\236\157\180\235\172\184\236\162\133", tostring(text))
  controlText:SetShow(true)
  controlText:SetText(text)
  controlText:SetFontColor(color)
  controlResult:SetShow(true)
  controlResult:ResetVertexAni()
  controlResult:SetVertexAniRun(aniText .. "_Ani", true)
  controlResult:SetVertexAniRun(aniText .. "_ScaleAni", true)
end
local function successUIShow()
  audioPostEvent_SystemUi(11, 1)
  endUIShow(ui._resultText, ui._result_Good, UI_color.C_FF96D4FC, PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_TIMING_GOODTIMING"), "Good")
end
local function failedUIShow()
  audioPostEvent_SystemUi(11, 2)
  endUIShow(ui._resultText, ui._result_Bad, UI_color.C_FFF26A6A, PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_ROPE_FAILED"), "Bad")
end
local function timing_update(deltaTime)
  local sizeY = ui._timingProgress:GetSizeY() * (define.timing_min + (define.timing_max - define.timing_min) * currentTimingValue)
  ui._timing:SetSize(ui._timing:GetSizeX(), sizeY)
  local percent = 1 - define.timing_Middle
  ui._timing:SetPosY(percent * ui._timingProgress:GetSizeY() - sizeY / 2)
  ui._helpArrow:SetPosY(percent * ui._timingProgress:GetSizeY() - ui._helpArrow:GetSizeY() / 2)
  ui._spaceBar:SetPosY(percent * ui._timingProgress:GetSizeY() - ui._spaceBar:GetSizeY() / 2)
  ui._spaceBar_Eff:SetPosY(percent * ui._timingProgress:GetSizeY() - ui._spaceBar_Eff:GetSizeY() / 2)
end
local function progressbar_update(deltaTime)
  ui._timingProgress:SetProgressRate(currentProgressValue * 100)
  ui._timingProgress:SetCurrentProgressRate(currentProgressValue * 100)
end
local function playingUpdate(deltaTime)
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
      failedUIShow()
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
  timing_update(deltaTime)
  progressbar_update(deltaTime)
end
local function endTimeUpdate(deltaTime)
  sumTime = sumTime + deltaTime
  if define.endAnimationTime <= sumTime then
    Panel_Minigame_Timing_End_UI()
    playMode = 3
    return
  end
end
function Panel_Minigame_Timing_Start()
  _math_randomSeed(os.time())
  ui._resultText:ResetVertexAni()
  ui._resultText:SetAlpha(0)
  ui._resultText:SetShow(false)
  ui._result_Good:SetShow(false)
  ui._result_Bad:SetShow(false)
  Panel_MiniGame_Timing:SetShow(true, false)
  currentTimingValue = _math_random(0, 100) / 100
  currentProgressValue = 0
  isUpTiming = true
  isUpProgress = true
  sumTime = 0
  playMode = 1
  Mingame_Panel_Timing_Value_isPressed = false
end
function Panel_Minigame_Timing_End()
  Panel_MiniGame_Timing:SetShow(false, false)
end
function Panel_Minigame_Timing_End_UI()
  if isWin then
    getSelfPlayer():get():SetMiniGameResult(2)
  else
    getSelfPlayer():get():SetMiniGameResult(3)
  end
  Panel_MiniGame_Timing:SetShow(false, false)
end
function Panel_Minigame_Timing_Perframe(deltaTime)
  if playMode == 2 then
    endTimeUpdate(deltaTime)
  elseif playMode == 1 then
    playingUpdate(deltaTime)
  end
end
function Panel_Minigame_Timing_Freeze(keyType)
  if MGKT.MiniGameKeyType_Space == keyType and Panel_MiniGame_Timing:IsShow() and Mingame_Panel_Timing_Value_isPressed == false then
    local minValue = ui._timing:GetPosY() - ui._timingProgress:GetPosY()
    local maxValue = minValue + ui._timing:GetSizeY()
    local checkPos = ui._timingProgress_Head:GetPosY() + ui._timingProgress_Head:GetSizeY() / 2
    playMode = 2
    sumTime = 0
    isWin = minValue <= checkPos and maxValue >= checkPos
    if isWin then
      audioPostEvent_SystemUi(11, 1)
      endUIShow(ui._resultText, ui._result_Good, UI_color.C_FF96D4FC, PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_TIMING_GOODTIMING"), "Good")
      getSelfPlayer():get():SetMiniGameResult(0)
    else
      audioPostEvent_SystemUi(11, 2)
      endUIShow(ui._resultText, ui._result_Bad, UI_color.C_FFF26A6A, PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_ROPE_FAILED"), "Bad")
      getSelfPlayer():get():SetMiniGameResult(1)
    end
    Mingame_Panel_Timing_Value_isPressed = true
  end
end
init()
registerEvent("onScreenResize", "ScreenSize_RePosition_TimingGame")

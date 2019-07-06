local MGKT = CppEnums.MiniGameKeyType
local UI_color = Defines.Color
local MiniGame_Buoy = {
  _ui = {
    stc_TimingBG = UI.getChildControl(Panel_MiniGame_Timing, "Static_Timing_BG"),
    txt_Purpose = UI.getChildControl(Panel_MiniGame_Timing, "StaticText_Purpose"),
    stc_Result_Good = UI.getChildControl(Panel_MiniGame_Timing, "Static_Result_Good"),
    stc_Result_Bad = UI.getChildControl(Panel_MiniGame_Timing, "Static_Result_Bad"),
    txt_Result = UI.getChildControl(Panel_MiniGame_Timing, "StaticText_Result_Text")
  },
  _isGameStart = false
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
function MiniGame_Buoy:init()
  Panel_MiniGame_Timing:SetShow(false, false)
  self._ui.progress2_Timing = UI.getChildControl(self._ui.stc_TimingBG, "Progress2_Timing")
  self._ui.stc_TimingProgress_Head = UI.getChildControl(self._ui.progress2_Timing, "Progress2_1_Timing_Head")
  self._ui.stc_Timing = UI.getChildControl(self._ui.stc_TimingBG, "Static_Timing")
  self._ui.stc_GuideLine = UI.getChildControl(self._ui.stc_TimingBG, "Static_Guide_Line")
  Panel_MiniGame_Timing:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
end
function ScreenSize_RePosition_BuoyGame()
  local self = MiniGame_Buoy
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_MiniGame_Timing:SetPosX(0)
  Panel_MiniGame_Timing:SetPosY(0)
  for _, v in pairs(self._ui) do
    v:ComputePos()
  end
end
function MiniGame_Buoy:endUIShow_Buoy(controlText, controlResult, color, text, aniText)
  self._ui.txt_Result:ResetVertexAni()
  self._ui.txt_Result:SetVertexAniRun("Ani_Color_empty", true)
  self._ui.txt_Result:SetVertexAniRun("Ani_Color_1", true)
  self._ui.txt_Result:SetVertexAniRun("Ani_Scale_0", true)
  self._ui.txt_Result:SetVertexAniRun("Ani_Scale_1", true)
  self._ui.txt_Result:SetVertexAniRun("Ani_Scale_End", true)
  self._ui.txt_Result:SetVertexAniRun("Ani_Color_End", true)
  controlText:SetShow(true)
  controlText:SetText(text)
  controlText:SetFontColor(color)
  controlResult:SetShow(true)
  controlResult:ResetVertexAni()
  controlResult:SetVertexAniRun(aniText .. "_Ani", true)
  controlResult:SetVertexAniRun(aniText .. "_ScaleAni", true)
end
function MiniGame_Buoy:successUIShow()
  self:endUIShow_Buoy(self._ui.txt_Result, self._ui.stc_Result_Good, UI_color.C_FF96D4FC, PAGetString(Defines.StringSheet_GAME, "Lua_Minigame_Buoy_0"), "Good")
end
function MiniGame_Buoy:failedUIShow_Buoy()
  self:endUIShow_Buoy(self._ui.txt_Result, self._ui.stc_Result_Bad, UI_color.C_FFF26A6A, PAGetString(Defines.StringSheet_GAME, "Lua_Minigame_Buoy_1"), "Bad")
end
function MiniGame_Buoy:timing_update_Buoy(deltaTime)
  local sizeY = self._ui.progress2_Timing:GetSizeY() * (define.timing_min + (define.timing_max - define.timing_min) * currentTimingValue)
  self._ui.stc_Timing:SetSize(self._ui.stc_Timing:GetSizeX(), sizeY)
  local percent = 1 - define.timing_Middle
  self._ui.stc_Timing:SetPosY(percent * self._ui.progress2_Timing:GetSizeY() - sizeY / 2)
  self._ui.stc_GuideLine:SetPosY(percent * self._ui.progress2_Timing:GetSizeY() - self._ui.stc_GuideLine:GetSizeY() / 2)
end
function MiniGame_Buoy:progressbar_update_Buoy(deltaTime)
  self._ui.progress2_Timing:SetProgressRate(currentProgressValue * 100)
  self._ui.progress2_Timing:SetCurrentProgressRate(currentProgressValue * 100)
end
function MiniGame_Buoy:playingUpdate_Buoy(deltaTime)
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
      self:failedUIShow_Buoy()
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
  self:timing_update_Buoy(deltaTime)
  self:progressbar_update_Buoy(deltaTime)
end
function MiniGame_Buoy:endTimeUpdate_Buoy(deltaTime)
  if false == isBarMoveStart then
    return
  end
  sumTime = sumTime + deltaTime
  if define.endAnimationTime <= sumTime then
    Panel_Minigame_Buoy_End_UI()
    playMode = 3
    isBarMoveStart = false
    initValue()
    for key, value in pairs(self._ui) do
      value:SetShow(false)
    end
  end
end
function Panel_Minigame_Buoy_Start()
  local self = MiniGame_Buoy
  PaGlobal_ConsoleQuickMenu:widgetClose()
  Panel_ConsoleKeyGuide:SetShow(false)
  _math_randomSeed(getTickCount32())
  self._isGameStart = true
  self._ui.txt_Result:ResetVertexAni()
  self._ui.txt_Result:SetAlpha(0)
  self._ui.txt_Purpose:SetShow(true)
  if _ContentsGroup_isConsolePadControl then
    self._ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_TIMING_STOP"))
  else
  end
  Panel_MiniGame_Timing:SetShow(true, false)
  currentTimingValue = _math_random(0, 100) / 100
  currentProgressValue = 0
  isUpTiming = true
  isUpProgress = true
  sumTime = 0
  playMode = 1
  for key, value in pairs(self._ui) do
    value:SetShow(false)
  end
  isBarMoveStart = false
end
function Panel_Minigame_Buoy_ResetCount()
  buoy_WinCount = 0
end
function Panel_Minigame_Buoy_End()
  local self = MiniGame_Buoy
  self._isGameStart = false
  PaGlobal_ConsoleQuickMenu:widgetOpen()
  Panel_ConsoleKeyGuide:SetShow(true)
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
function MiniGame_Buoy:realEndTimeUpdate_Buoy(deltaTime)
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
function MiniGame_Buoy:failTimer(deltaTime)
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
  local self = MiniGame_Buoy
  if 4 == playMode then
    self:realEndTimeUpdate_Buoy(deltaTime)
  elseif playMode == 3 then
    self:failTimer(deltaTime)
  elseif playMode == 2 then
    self:endTimeUpdate_Buoy(deltaTime)
  elseif playMode == 1 then
    self:playingUpdate_Buoy(deltaTime)
  end
end
function Panel_MiniGame_Buoy_WaitInitMode()
  playMode = 4
  realEndTime = 0
end
function Panel_Minigame_Buoy_Freeze(isJumpPressed)
  local self = MiniGame_Buoy
  if playMode ~= 1 then
    return
  end
  if false == isBarMoveStart then
    for key, value in pairs(self._ui) do
      if "stc_Result_Good" ~= key and "stc_Result_Bad" ~= key and "txt_Result" ~= key then
        value:SetShow(true)
      end
    end
    getSelfPlayer():get():SetMiniGameResult(2)
    isBarMoveStart = true
    return
  end
  if true == isJumpPressed and Panel_MiniGame_Timing:IsShow() and 1 == playMode then
    local minValue = self._ui.stc_Timing:GetPosY() - self._ui.progress2_Timing:GetPosY()
    local maxValue = minValue + self._ui.stc_Timing:GetSizeY()
    local checkPos = self._ui.stc_TimingProgress_Head:GetPosY() + self._ui.stc_TimingProgress_Head:GetSizeY() / 2
    playMode = 2
    sumTime = 0
    isWin = minValue <= checkPos and maxValue >= checkPos
    if isWin then
      audioPostEvent_SystemUi(11, 1)
      self:endUIShow_Buoy(self._ui.txt_Result, self._ui.stc_Result_Good, UI_color.C_FF96D4FC, PAGetString(Defines.StringSheet_GAME, "Lua_Minigame_Buoy_0"), "Good")
      getSelfPlayer():get():SetMiniGameResult(0)
      buoy_WinCount = buoy_WinCount + 1
    else
      audioPostEvent_SystemUi(11, 2)
      self:endUIShow_Buoy(self._ui.txt_Result, self._ui.stc_Result_Bad, UI_color.C_FFF26A6A, PAGetString(Defines.StringSheet_GAME, "Lua_Minigame_Buoy_1"), "Bad")
      getSelfPlayer():get():SetMiniGameResult(1)
    end
  end
end
function MiniGame_Buoy_PadPress()
  local isJumpPressed = false
  if keyCustom_IsDownOnce_Action(CppEnums.ActionInputType.ActionInputType_Jump) then
    isJumpPressed = true
  end
  Panel_Minigame_Buoy_Freeze(isJumpPressed)
end
function FromClient_luaLoadComplete_MiniGame_Buoy_Init()
  local self = MiniGame_Buoy
  self:init()
end
registerEvent("onScreenResize", "ScreenSize_RePosition_BuoyGame")
registerEvent("EventActionMiniGamePadDownOnce", "MiniGame_Buoy_PadPress")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MiniGame_Buoy_Init")

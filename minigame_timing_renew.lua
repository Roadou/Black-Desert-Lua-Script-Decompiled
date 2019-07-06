local MGKT = CppEnums.MiniGameKeyType
local UI_color = Defines.Color
Mingame_Panel_Timing_Value_isPressed = false
local MiniGame_Timing = {
  _ui = {
    stc_TimingBG = UI.getChildControl(Panel_MiniGame_Timing, "Static_Timing_BG"),
    txt_Purpose = UI.getChildControl(Panel_MiniGame_Timing, "StaticText_Purpose"),
    stc_Result_Good = UI.getChildControl(Panel_MiniGame_Timing, "Static_Result_Good"),
    stc_Result_Bad = UI.getChildControl(Panel_MiniGame_Timing, "Static_Result_Bad"),
    txt_Result = UI.getChildControl(Panel_MiniGame_Timing, "StaticText_Result_Text"),
    txt_Command = UI.getChildControl(Panel_MiniGame_Timing, "Static_Command_Info")
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
function MiniGame_Timing:init()
  Panel_MiniGame_Timing:SetShow(false, false)
  self._ui.progress2_Timing = UI.getChildControl(self._ui.stc_TimingBG, "Progress2_Timing")
  self._ui.stc_TimingProgress_Head = UI.getChildControl(self._ui.progress2_Timing, "Progress2_1_Timing_Head")
  self._ui.stc_Timing = UI.getChildControl(self._ui.stc_TimingBG, "Static_Timing")
  self._ui.stc_GuideLine = UI.getChildControl(self._ui.stc_TimingBG, "Static_Guide_Line")
  Panel_MiniGame_Timing:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
  Mingame_Panel_Timing_Value_isPressed = false
end
function ScreenSize_RePosition_TimingGame()
  local self = MiniGame_Timing
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_MiniGame_Timing:SetSize(scrX, scrY)
  Panel_MiniGame_Timing:SetPosX(0)
  Panel_MiniGame_Timing:SetPosY(0)
  for _, v in pairs(self._ui) do
    v:ComputePos()
  end
  self._ui.stc_Result_Good:SetPosX(scrX / 2 - self._ui.stc_Result_Good:GetSizeX() / 2)
  self._ui.stc_Result_Bad:SetPosX(scrX / 2 - self._ui.stc_Result_Bad:GetSizeX() / 2)
end
function MiniGame_Timing:endUIShow(controlText, controlResult, color, text, aniText)
  self._ui.txt_Result:ResetVertexAni()
  self._ui.txt_Result:SetVertexAniRun("Ani_Color_empty", true)
  self._ui.txt_Result:SetVertexAniRun("Ani_Color_1", true)
  self._ui.txt_Result:SetVertexAniRun("Ani_Scale_0", true)
  self._ui.txt_Result:SetVertexAniRun("Ani_Scale_1", true)
  self._ui.txt_Result:SetVertexAniRun("Ani_Scale_End", true)
  self._ui.txt_Result:SetVertexAniRun("Ani_Color_End", true)
  self._ui.txt_Command:SetShow(false)
  controlText:SetShow(true)
  controlText:SetText(text)
  controlText:SetFontColor(color)
  controlResult:SetShow(true)
  controlResult:ResetVertexAni()
  controlResult:SetVertexAniRun(aniText .. "_Ani", true)
  controlResult:SetVertexAniRun(aniText .. "_ScaleAni", true)
end
function MiniGame_Timing:successUIShow()
  audioPostEvent_SystemUi(11, 1)
  self:endUIShow(self._ui.txt_Result, self._ui.stc_Result_Good, UI_color.C_FF96D4FC, PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_TIMING_GOODTIMING"), "Good")
end
function MiniGame_Timing:failedUIShow()
  audioPostEvent_SystemUi(11, 2)
  self:endUIShow(self._ui.txt_Result, self._ui.stc_Result_Bad, UI_color.C_FFF26A6A, PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_ROPE_FAILED"), "Bad")
end
function MiniGame_Timing:timing_update(deltaTime)
  local sizeY = self._ui.progress2_Timing:GetSizeY() * (define.timing_min + (define.timing_max - define.timing_min) * currentTimingValue)
  self._ui.stc_Timing:SetSize(self._ui.stc_Timing:GetSizeX(), sizeY)
  local percent = 1 - define.timing_Middle
  self._ui.stc_Timing:SetPosY(percent * self._ui.progress2_Timing:GetSizeY() - sizeY / 2)
  self._ui.stc_GuideLine:SetPosY(percent * self._ui.progress2_Timing:GetSizeY() - self._ui.stc_GuideLine:GetSizeY() / 2)
end
function MiniGame_Timing:progressbar_update(deltaTime)
  self._ui.progress2_Timing:SetProgressRate(currentProgressValue * 100)
  self._ui.progress2_Timing:SetCurrentProgressRate(currentProgressValue * 100)
end
function MiniGame_Timing:playingUpdate(deltaTime)
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
      self:failedUIShow()
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
  self:timing_update(deltaTime)
  self:progressbar_update(deltaTime)
end
function MiniGame_Timing:endTimeUpdate(deltaTime)
  sumTime = sumTime + deltaTime
  if define.endAnimationTime <= sumTime then
    Panel_Minigame_Timing_End_UI()
    playMode = 3
    return
  end
end
function Panel_Minigame_Timing_Start()
  local self = MiniGame_Timing
  PaGlobal_ConsoleQuickMenu:widgetClose()
  ScreenSize_RePosition_TimingGame()
  _math_randomSeed(getTickCount32())
  self._ui.txt_Purpose:SetShow(false)
  self._ui.txt_Result:ResetVertexAni()
  self._ui.txt_Result:SetAlpha(0)
  self._ui.txt_Result:SetShow(false)
  self._ui.stc_Result_Good:SetShow(false)
  self._ui.stc_Result_Bad:SetShow(false)
  self._ui.txt_Command:SetShow(true)
  self._ui.txt_Command:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_PRESS_B"))
  currentTimingValue = _math_random(0, 100) / 100
  currentProgressValue = 0
  isUpTiming = true
  isUpProgress = true
  sumTime = 0
  playMode = 1
  Mingame_Panel_Timing_Value_isPressed = false
  self._isGameStart = true
  Panel_MiniGame_Timing:SetShow(true, false)
  Panel_ConsoleKeyGuide:SetShow(false)
end
function Panel_Minigame_Timing_End()
  local self = MiniGame_Timing
  self._isGameStart = false
  PaGlobal_ConsoleQuickMenu:widgetOpen()
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
  local self = MiniGame_Timing
  if playMode == 2 then
    self:endTimeUpdate(deltaTime)
  elseif playMode == 1 then
    self:playingUpdate(deltaTime)
  end
end
function Panel_Minigame_Timing_Freeze(keyType)
  local self = MiniGame_Timing
  if false == self._isGameStart then
    return
  end
  if MGKT.MiniGameKeyType_Space == keyType and Panel_MiniGame_Timing:IsShow() and Mingame_Panel_Timing_Value_isPressed == false then
    local minValue = self._ui.stc_Timing:GetPosY() - self._ui.progress2_Timing:GetPosY()
    local maxValue = minValue + self._ui.stc_Timing:GetSizeY()
    local checkPos = self._ui.stc_TimingProgress_Head:GetPosY() + self._ui.stc_TimingProgress_Head:GetSizeY() / 2
    playMode = 2
    sumTime = 0
    isWin = minValue <= checkPos and maxValue >= checkPos
    if isWin then
      audioPostEvent_SystemUi(11, 1)
      self:endUIShow(self._ui.txt_Result, self._ui.stc_Result_Good, UI_color.C_FF96D4FC, PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_TIMING_GOODTIMING"), "Good")
      getSelfPlayer():get():SetMiniGameResult(0)
    else
      audioPostEvent_SystemUi(11, 2)
      self:endUIShow(self._ui.txt_Result, self._ui.stc_Result_Bad, UI_color.C_FFF26A6A, PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_ROPE_FAILED"), "Bad")
      getSelfPlayer():get():SetMiniGameResult(1)
    end
    Mingame_Panel_Timing_Value_isPressed = true
  end
end
function Panel_Minigame_Pad_Timing_Freeze()
  local self = MiniGame_Timing
  if false == self._isGameStart then
    return
  end
  local isJumpPressed = false
  if keyCustom_IsDownOnce_Action(CppEnums.ActionInputType.ActionInputType_Jump) then
    isJumpPressed = true
  end
  if true == isJumpPressed and Panel_MiniGame_Timing:IsShow() and Mingame_Panel_Timing_Value_isPressed == false then
    local minValue = self._ui.stc_Timing:GetPosY() - self._ui.progress2_Timing:GetPosY()
    local maxValue = minValue + self._ui.stc_Timing:GetSizeY()
    local checkPos = self._ui.stc_TimingProgress_Head:GetPosY() + self._ui.stc_TimingProgress_Head:GetSizeY() / 2
    playMode = 2
    sumTime = 0
    isWin = minValue <= checkPos and maxValue >= checkPos
    if isWin then
      audioPostEvent_SystemUi(11, 1)
      self:endUIShow(self._ui.txt_Result, self._ui.stc_Result_Good, UI_color.C_FF96D4FC, PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_TIMING_GOODTIMING"), "Good")
      getSelfPlayer():get():SetMiniGameResult(0)
    else
      audioPostEvent_SystemUi(11, 2)
      self:endUIShow(self._ui.txt_Result, self._ui.stc_Result_Bad, UI_color.C_FFF26A6A, PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_ROPE_FAILED"), "Bad")
      getSelfPlayer():get():SetMiniGameResult(1)
    end
    Mingame_Panel_Timing_Value_isPressed = true
  end
end
function FromClient_luaLoadComplete_MiniGame_Timing_Init()
  local self = MiniGame_Timing
  self:init()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MiniGame_Timing_Init")
registerEvent("EventActionMiniGamePadDownOnce", "Panel_Minigame_Pad_Timing_Freeze")
registerEvent("onScreenResize", "ScreenSize_RePosition_TimingGame")

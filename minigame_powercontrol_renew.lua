Panel_MiniGame_PowerControl:SetShow(false)
local MGKT = CppEnums.MiniGameKeyType
local MGT = CppEnums.MiniGameType
local MiniGame_PowerControl = {
  _ui = {
    stc_Cow_BG = UI.getChildControl(Panel_MiniGame_PowerControl, "Static_Cow_BG"),
    stc_PC_Control_BG = UI.getChildControl(Panel_MiniGame_PowerControl, "Static_PC_Control_BG"),
    stc_Console_Control_BG = UI.getChildControl(Panel_MiniGame_PowerControl, "Static_Console_Control_BG"),
    stc_Milk_Bottle_BG = UI.getChildControl(Panel_MiniGame_PowerControl, "Static_Milk_Bottle_BG"),
    stc_Timer_BG = UI.getChildControl(Panel_MiniGame_PowerControl, "Static_Timer_BG"),
    stc_Result_Success = UI.getChildControl(Panel_MiniGame_PowerControl, "Static_Result_Success"),
    stc_Result_Failed = UI.getChildControl(Panel_MiniGame_PowerControl, "Static_Result_Failed"),
    txt_Purpose = UI.getChildControl(Panel_MiniGame_PowerControl, "StaticText_Purpose")
  },
  _isGameStart = false
}
local gameMode = 0
local directionType = 0
local milkRate = -1
local leftMilkyRate = 1
local rightMilkyRate = 1
local isPlayingMilky = false
local currTime = -1
local gameEndTimer = 21
local endTimer = 0
local isSuccess = false
local isFullMilk = false
local isPressed_L = false
local isPressed_R = false
local elapsTime = 0
function MiniGame_PowerControl:init()
  self._ui.stc_Gauge_L_BG = UI.getChildControl(self._ui.stc_Cow_BG, "Static_PowerGauge_BG_L")
  self._ui.stc_Gauge_R_BG = UI.getChildControl(self._ui.stc_Cow_BG, "Static_PowerGauge_BG_R")
  self._ui.stc_GaugeDanger_L = UI.getChildControl(self._ui.stc_Cow_BG, "Static_Danger_L")
  self._ui.stc_GaugeDanger_R = UI.getChildControl(self._ui.stc_Cow_BG, "Static_Danger_R")
  self._ui.stc_Gauge_L = UI.getChildControl(self._ui.stc_Cow_BG, "Progress2_PowerGauge_L")
  self._ui.stc_Gauge_R = UI.getChildControl(self._ui.stc_Cow_BG, "Progress2_PowerGauge_R")
  self._ui.stc_GaugeDeco_L = UI.getChildControl(self._ui.stc_Cow_BG, "Static_Cow_Deco_L")
  self._ui.stc_GaugeDeco_R = UI.getChildControl(self._ui.stc_Cow_BG, "Static_Cow_Deco_R")
  self._ui.stc_Milky_L = UI.getChildControl(self._ui.stc_Cow_BG, "Static_MilkyLeft")
  self._ui.stc_Milky_R = UI.getChildControl(self._ui.stc_Cow_BG, "Static_MilkyRight")
  self._ui.txt_GameTimer = UI.getChildControl(self._ui.stc_Timer_BG, "StaticText_Timer")
  self._ui.progress2_Milk = UI.getChildControl(self._ui.stc_Milk_Bottle_BG, "Progress2_Milk")
  self._ui.txt_MilkyRate = UI.getChildControl(self._ui.stc_Milk_Bottle_BG, "StaticText_MilkyRate")
  if _ContentsGroup_isConsolePadControl then
    self._ui.stc_LTButton = UI.getChildControl(self._ui.stc_Console_Control_BG, "Static_LT")
    self._ui.stc_RTButton = UI.getChildControl(self._ui.stc_Console_Control_BG, "Static_RT")
    self._ui.stc_PC_Control_BG:SetShow(false)
  else
    self._ui.stc_Mouse_L = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_L_Btn_L")
    self._ui.stc_Mouse_L_R = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_L_Btn_R")
    self._ui.stc_Mouse_R = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_R_Btn_R")
    self._ui.stc_Mouse_R_L = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_R_Btn_L")
    self._ui.stc_MouseBody_L = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_MouseBody_L")
    self._ui.stc_MouseBody_R = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_MouseBody_R")
    self._ui.stc_Console_Control_BG:SetShow(false)
  end
  self._ui.stc_Gauge_L:SetProgressRate(100)
  self._ui.stc_Gauge_R:SetProgressRate(100)
  leftMilkyRate = 100
  rightMilkyRate = 100
  directionType = 0
  milkRate = 0
  gameEndTimer = 31
  endTimer = 0
  elapsTime = 0
  if _ContentsGroup_isConsolePadControl then
    AddMiniGameKeyPress(MGT.MiniGameType_14, MiniGame_PowerControl_PadPressDown)
    AddMiniGameKeyUp(MGT.MiniGameType_14, MiniGame_PowerControl_PadPressUp)
  else
    AddMiniGameKeyPress(MGT.MiniGameType_14, MiniGame_PowerControl_PressDown)
    AddMiniGameKeyUp(MGT.MiniGameType_14, MiniGame_PowerControl_PressUp)
  end
end
function MiniGame_PowerControl:onKeyDown(keyType)
  if MGKT.MiniGameKeyType_M0 == keyType then
    isPressed_L = true
  elseif MGKT.MiniGameKeyType_M1 == keyType then
    isPressed_R = true
  end
end
function MiniGame_PowerControl:onKeyUp(keyType)
  if MGKT.MiniGameKeyType_M0 == keyType then
    _AudioPostEvent_SystemUiForXBOX(11, 5)
    isPressed_L = false
    directionType = 1
    self._ui.stc_Gauge_L_BG:SetAlpha(0.6)
    self._ui.stc_Gauge_L:SetAlpha(0.6)
    self._ui.stc_GaugeDeco_L:SetAlpha(0.6)
    self._ui.stc_Gauge_R_BG:SetAlpha(1)
    self._ui.stc_Gauge_R:SetAlpha(1)
    self._ui.stc_GaugeDeco_R:SetAlpha(1)
  elseif MGKT.MiniGameKeyType_M1 == keyType then
    _AudioPostEvent_SystemUiForXBOX(11, 5)
    isPressed_R = false
    directionType = 0
    self._ui.stc_Gauge_L_BG:SetAlpha(1)
    self._ui.stc_Gauge_L:SetAlpha(1)
    self._ui.stc_GaugeDeco_L:SetAlpha(1)
    self._ui.stc_Gauge_R_BG:SetAlpha(0.6)
    self._ui.stc_Gauge_R:SetAlpha(0.6)
    self._ui.stc_GaugeDeco_R:SetAlpha(0.6)
  end
end
function MiniGame_PowerControl_PadPressUp(keyType)
  local self = MiniGame_PowerControl
  if false == isPlayingMilky or true == isSuccess then
    return
  end
  if __eQuickTimeEventPadType_LT == keyType then
    keyType = MGKT.MiniGameKeyType_M0
  elseif __eQuickTimeEventPadType_RT == keyType then
    keyType = MGKT.MiniGameKeyType_M1
  end
  self:onKeyUp(keyType)
end
function MiniGame_PowerControl_PadPressDown(keyType)
  local self = MiniGame_PowerControl
  if false == isPlayingMilky or true == isSuccess then
    return
  end
  if __eQuickTimeEventPadType_LT == keyType then
    keyType = MGKT.MiniGameKeyType_M0
  elseif __eQuickTimeEventPadType_RT == keyType then
    keyType = MGKT.MiniGameKeyType_M1
  end
  self:onKeyDown(keyType)
end
function MiniGame_PowerControl_PressUp(keyType)
  local self = MiniGame_PowerControl
  if false == isPlayingMilky or true == isSuccess then
    return
  end
  self:onKeyUp(keyType)
end
function MiniGame_PowerControl_PressDown(keyType)
  local self = MiniGame_PowerControl
  if false == isPlayingMilky or true == isSuccess then
    return
  end
  self:onKeyDown(keyType)
end
function Panel_MiniGame_PowerControl_Start()
  local self = MiniGame_PowerControl
  self:init()
  for key, v in pairs(self._ui) do
    if "stc_PC_Control_BG" ~= key and "stc_Console_Control_BG" ~= key then
      v:SetShow(true)
    end
    v:ComputePos()
  end
  self._ui.stc_Gauge_L_BG:SetAlpha(1)
  self._ui.stc_Gauge_L:SetAlpha(1)
  self._ui.stc_GaugeDeco_L:SetAlpha(1)
  self._ui.stc_Gauge_R_BG:SetAlpha(0.6)
  self._ui.stc_Gauge_R:SetAlpha(0.6)
  self._ui.stc_GaugeDeco_R:SetAlpha(0.6)
  self._ui.txt_GameTimer:SetShow(true)
  self._ui.stc_Milky_L:SetShow(false)
  self._ui.stc_Milky_R:SetShow(false)
  self._ui.progress2_Milk:SetProgressRate(milkRate)
  self._ui.stc_Result_Success:SetShow(false)
  self._ui.stc_Result_Failed:SetShow(false)
  Panel_MiniGame_PowerControl:SetShow(true)
  self._ui.txt_Purpose:SetShow(true)
  Panel_ConsoleKeyGuide:SetShow(false)
  PaGlobal_ConsoleQuickMenu:widgetClose()
  if _ContentsGroup_isConsolePadControl then
    self._ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_MINIGAME_MILKCOW_READY2"))
  else
  end
  isPlayingMilky = true
  isSuccess = false
end
function Panel_MiniGame_PowerControl_End()
  local self = MiniGame_PowerControl
  self._isGameStart = false
  getSelfPlayer():get():SetMiniGameResult(4)
  Panel_ConsoleKeyGuide:SetShow(true)
  PaGlobal_ConsoleQuickMenu:widgetOpen()
  Panel_MiniGame_PowerControl:SetShow(false)
  isPlayingMilky = false
  isSuccess = false
end
function Panel_MIniGame_PowerControl_Result(deltaTime)
  local self = MiniGame_PowerControl
  endTimer = endTimer + deltaTime
  local _endTimer = math.floor(endTimer)
  gameEndTimer = 0
  self._ui.txt_GameTimer:SetText("")
  if false == isSuccess then
    if milkRate <= 99 and _endTimer < 0.01 then
      Panel_MiniGame_PowerControl_Failed()
    elseif milkRate == 100 and _endTimer < 0.01 then
      Panel_MiniGame_PowerControl_Success()
    end
  end
  if _endTimer >= 2 then
    Panel_MiniGame_PowerControl_End()
  end
end
function Panel_MiniGame_PowerControl_Success()
  local self = MiniGame_PowerControl
  if false == isSuccess then
    isSuccess = true
    self._ui.stc_Cow_BG:SetShow(false)
    self._ui.stc_PC_Control_BG:SetShow(false)
    self._ui.stc_Console_Control_BG:SetShow(false)
    self._ui.stc_Timer_BG:SetShow(false)
    self._ui.txt_Purpose:SetShow(false)
  else
    return
  end
  _AudioPostEvent_SystemUiForXBOX(11, 13)
  isFullMilk = true
  if true == isPlayingMilky then
    ToClient_MinigameResult(1, true)
    FGlobal_MiniGame_PowerControl()
  end
  isPlayingMilky = false
  self._ui.txt_GameTimer:SetShow(false)
  getSelfPlayer():get():SetMiniGameResult(0)
  self._ui.stc_Result_Success:ResetVertexAni()
  self._ui.stc_Result_Success:SetVertexAniRun("Good_Ani", true)
  self._ui.stc_Result_Success:SetShow(true)
end
function Panel_MiniGame_PowerControl_Failed()
  local self = MiniGame_PowerControl
  self._ui.stc_Cow_BG:SetShow(false)
  self._ui.stc_PC_Control_BG:SetShow(false)
  self._ui.stc_Console_Control_BG:SetShow(false)
  self._ui.stc_Timer_BG:SetShow(false)
  isPlayingMilky = false
  directionType = -1
  isPressed_L = false
  isPressed_R = false
  self._ui.txt_GameTimer:SetShow(false)
  self._ui.stc_Result_Success:SetShow(false)
  getSelfPlayer():get():SetMiniGameResult(1)
  self._ui.stc_Result_Failed:ResetVertexAni()
  self._ui.stc_Result_Failed:SetVertexAniRun("Bad_Ani", true)
  self._ui.stc_Result_Failed:SetShow(true)
  self._ui.txt_Purpose:SetShow(false)
  if true == isPlayingMilky then
    ToClient_MinigameResult(1, false)
    _AudioPostEvent_SystemUiForXBOX(11, 2)
  end
end
local leftMilkyRate_Timer = 0
local rightMilkyRate_Timer = 0
function MiniGame_PowerControl:updateRightMilky(value)
  rightMilkyRate = math.max(math.min(rightMilkyRate + value, 100), 0)
  self._ui.stc_Gauge_R:SetProgressRate(rightMilkyRate)
  self._ui.stc_GaugeDanger_L:SetAlpha(0.88 - leftMilkyRate * 0.01)
end
function MiniGame_PowerControl:updateLeftMilky(value)
  leftMilkyRate = math.max(math.min(leftMilkyRate + value, 100), 0)
  self._ui.stc_Gauge_L:SetProgressRate(leftMilkyRate)
  self._ui.stc_GaugeDanger_R:SetAlpha(0.88 - rightMilkyRate * 0.01)
end
function Panel_MiniGame_PowerControl_MouseClick_UpdateFunc(deltaTime)
  local self = MiniGame_PowerControl
  elapsTime = elapsTime + deltaTime
  if elapsTime < 0.016666666666666666 then
    return
  end
  elapsTime = 0
  currTime = currTime + deltaTime
  gameEndTimer = gameEndTimer - deltaTime
  local _gameEndTimer = math.floor(gameEndTimer)
  self._ui.txt_MilkyRate:SetText(math.floor(milkRate) .. " %")
  if isPressed_L and 0 == directionType then
    self:updateLeftMilky(-175 * deltaTime)
    self:updateRightMilky(65 * deltaTime)
    milkRate = milkRate + 0.3 * (deltaTime * 60)
    if _ContentsGroup_isConsolePadControl then
    else
      ui._mouse_L:ResetVertexAni()
      ui._mouse_L:SetVertexAniRun("Ani_Color_Left", true)
    end
    self._ui.stc_Milky_L:SetShow(true)
    self._ui.stc_Milky_R:SetShow(false)
    self._ui.progress2_Milk:SetProgressRate(milkRate)
  elseif isPressed_R and 1 == directionType then
    self:updateRightMilky(-175 * deltaTime)
    self:updateLeftMilky(65 * deltaTime)
    milkRate = milkRate + 0.3 * (deltaTime * 60)
    if _ContentsGroup_isConsolePadControl then
    else
      self._ui.stc_Mouse_R:ResetVertexAni()
      self._ui.stc_Mouse_R:SetVertexAniRun("Ani_Color_Right", true)
    end
    self._ui.stc_Milky_L:SetShow(false)
    self._ui.stc_Milky_R:SetShow(true)
    self._ui.progress2_Milk:SetProgressRate(milkRate)
  else
    self:updateLeftMilky(65 * deltaTime)
    self:updateRightMilky(65 * deltaTime)
    self._ui.stc_Milky_L:SetShow(false)
    self._ui.stc_Milky_R:SetShow(false)
  end
  if isPlayingMilky == true then
    self._ui.txt_GameTimer:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_POWERCONTROL_REMAINTIME", "gameEndTimer", _gameEndTimer))
  end
  isFullMilk = false
  if milkRate >= 100 then
    milkRate = 100
    isFullMilk = true
  end
  if _gameEndTimer <= 0 or true == isFullMilk then
    Panel_MIniGame_PowerControl_Result(deltaTime)
  end
  if isSuccess then
    return
  elseif leftMilkyRate <= 1 then
    Panel_MiniGame_PowerControl_Failed()
  elseif rightMilkyRate <= 1 then
    Panel_MiniGame_PowerControl_Failed()
  end
end
function FromClient_luaLoadComplete_MiniGame_PowerControl_Init()
  local self = MiniGame_PowerControl
  self:init()
end
function ScreenSize_RePosition_PowerControl()
  local self = MiniGame_PowerControl
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  local gapY = (getOriginScreenSizeY() - scrY) / 2
  Panel_MiniGame_PowerControl:SetPosY(200 + gapY)
  for _, v in pairs(self._ui) do
    v:ComputePos()
  end
end
registerEvent("onScreenResize", "ScreenSize_RePosition_PowerControl")
Panel_MiniGame_PowerControl:RegisterUpdateFunc("Panel_MiniGame_PowerControl_MouseClick_UpdateFunc")
registerEvent("EventActionMiniGamePadDownOnce", "MiniGame_PowerControl_PadPressDown")
registerEvent("EventActionMiniGamePadUp", "MiniGame_PowerControl_PadPressUp")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MiniGame_PowerControl_Init")

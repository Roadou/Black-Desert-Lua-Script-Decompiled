local MGKT = CppEnums.MiniGameKeyType
local MiniGame_Gradient = {
  _ui = {
    stc_gaugeBG = UI.getChildControl(Panel_Minigame_Gradient, "Static_GaugeBG"),
    stc_GaugeBar = UI.getChildControl(Panel_Minigame_Gradient, "Static_GaugeBar"),
    stc_GaugeBar_Caution = UI.getChildControl(Panel_Minigame_Gradient, "Static_GaugeBar_Caution"),
    stc_PC_Control_BG = UI.getChildControl(Panel_Minigame_Gradient, "Static_PC_Control_BG"),
    stc_Console_Control_BG = UI.getChildControl(Panel_Minigame_Gradient, "Static_Console_Control_BG"),
    txt_Purpose = UI.getChildControl(Panel_Minigame_Gradient, "StaticText_Purpose")
  }
}
local gaugebarUV = {
  [1] = {
    499,
    1,
    508,
    36
  },
  [2] = {
    499,
    38,
    508,
    73
  }
}
local gradientIconUV = {
  [1] = {
    284,
    158,
    327,
    201
  },
  [2] = {
    284,
    114,
    327,
    157
  }
}
local _math_random = math.random
local _math_randomseed = math.randomseed
local _math_lerp = Util.Math.Lerp
local ClickDirection = {
  None = 0,
  Left = -1,
  Right = 1
}
local define = {
  sequenceClickTimeSpan = 1,
  ClickTimeSpanMaxWeight = 0.35,
  ClickTimeSpanMinWeight = 0.15,
  speedWeight = 1,
  gageSize = Panel_Minigame_Gradient:GetSizeX()
}
local data = {
  currentPos = 0.5,
  lastClickTime = 0,
  lastClickDirection = 0,
  currentSpeed = 0
}
local isGradientPlay = false
function MiniGame_Gradient:init()
  Panel_Minigame_Gradient:SetShow(false)
  self._ui.stc_Result_Good = UI.getChildControl(self._ui.stc_gaugeBG, "Static_Result_Good")
  self._ui.stc_Result_Bad = UI.getChildControl(self._ui.stc_gaugeBG, "Static_Result_Bad")
  self._ui.stc_Gradient_Icon = UI.getChildControl(self._ui.stc_GaugeBar, "Static_Gradient_Icon")
  if _ContentsGroup_isConsolePadControl then
    self._ui.stc_LTButton = UI.getChildControl(self._ui.stc_Console_Control_BG, "Static_LT")
    self._ui.stc_RTButton = UI.getChildControl(self._ui.stc_Console_Control_BG, "Static_RT")
    self._ui.stc_Console_Control_BG:SetShow(true)
    self._ui.stc_PC_Control_BG:SetShow(false)
    self._ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GRADIENT_KEY_INFO"))
  else
    self._ui.stc_MLButton_L = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_L_Btn_L")
    self._ui.stc_LButton_R = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_L_Btn_R")
    self._ui.stc_RButton_R = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_R_Btn_R")
    self._ui.stc_RButton_L = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_R_Btn_L")
    self._ui.stc_stc_mouseBody_L = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_MouseBody_L")
    self._ui.stc_stc_mouseBody_R = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_MouseBody_R")
    self._ui.stc_Console_Control_BG:SetShow(false)
    self._ui.stc_PC_Control_BG:SetShow(true)
  end
end
function Panel_Minigame_Gradient_Start(isRace)
  local self = MiniGame_Gradient
  PaGlobal_ConsoleQuickMenu:widgetClose()
  Panel_ConsoleKeyGuide:SetShow(false)
  Panel_Minigame_Gradient:SetShow(true)
  Panel_Minigame_Gradient:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
  local centerPos = self._ui.stc_gaugeBG:GetPosX() + self._ui.stc_gaugeBG:GetSizeX() / 2
  self._ui.stc_GaugeBar:SetPosX(centerPos)
  self._ui.stc_GaugeBar_Caution:SetPosX(centerPos)
  self._ui.stc_GaugeBar_Caution:SetShow(false)
  self._ui.stc_GaugeBar:SetShow(true)
  _math_randomseed(getTickCount32())
  local speed = _math_random()
  data.currentSpeed = (speed - 0.5) / 4
  data.lastClickDirection = ClickDirection.None
  data.lastClickTime = 0
  data.currentPos = 0.5
  isGradientPlay = true
  if true == FGlobal_isPlaying_CartRace() then
    define.sequenceClickTimeSpan = 0.5
    define.ClickTimeSpanMaxWeight = 1.45
    define.ClickTimeSpanMinWeight = 0.85
    define.speedWeight = 8
  else
    define.sequenceClickTimeSpan = 1
    define.ClickTimeSpanMaxWeight = 0.35
    define.ClickTimeSpanMinWeight = 0.15
    define.speedWeight = 1
  end
end
function MiniGame_GaugeBarMoveCalc(fDeltaTime)
  local self = MiniGame_Gradient
  data.lastClickTime = data.lastClickTime + fDeltaTime
  local currentPos = data.currentPos + data.currentSpeed * fDeltaTime
  if currentPos < 0 then
    currentPos = 0
    getSelfPlayer():get():SetMiniGameResult(0)
  elseif currentPos > 1 then
    currentPos = 1
    getSelfPlayer():get():SetMiniGameResult(3)
  end
  data.currentPos = currentPos
  data.currentSpeed = data.currentSpeed - (0.5 - currentPos) * define.speedWeight * fDeltaTime
  local redArea = 80
  local controlPos = _math_lerp(self._ui.stc_gaugeBG:GetPosX(), self._ui.stc_gaugeBG:GetPosX() + self._ui.stc_gaugeBG:GetSizeX(), currentPos)
  local left_Bad_Start = self._ui.stc_gaugeBG:GetPosX() + redArea
  local right_Bad_Start = self._ui.stc_gaugeBG:GetPosX() + self._ui.stc_gaugeBG:GetSizeX() - redArea
  if controlPos > right_Bad_Start or controlPos < left_Bad_Start then
    self._ui.stc_GaugeBar_Caution:SetShow(true)
    self._ui.stc_GaugeBar:SetShow(false)
  elseif controlPos > right_Bad_Start + redArea or controlPos < left_Bad_Start - redArea then
    if self._ui.stc_Result_Bad:GetShow() == false then
      _AudioPostEvent_SystemUiForXBOX(11, 2)
      self._ui.stc_Result_Bad:SetShow(true)
      self._ui.stc_Result_Good:SetShow(false)
      self._ui.stc_Result_Bad:ResetVertexAni()
      self._ui.stc_Result_Bad:SetVertexAniRun("Bad_Ani", true)
      self._ui.stc_Result_Bad:SetVertexAniRun("Bad_ScaleAni", true)
      if controlPos < left_Bad_Start then
        _AudioPostEvent_SystemUiForXBOX(11, 2)
        getSelfPlayer():get():SetMiniGameResult(1)
      else
        _AudioPostEvent_SystemUiForXBOX(11, 2)
        getSelfPlayer():get():SetMiniGameResult(2)
      end
    end
  else
    _PA_LOG("\236\155\144\236\132\160", "\236\149\132\236\157\180\236\189\152 \236\155\144\236\131\129\237\131\156")
    self._ui.stc_GaugeBar_Caution:SetShow(false)
    self._ui.stc_GaugeBar:SetShow(true)
    if self._ui.stc_Result_Good:GetShow() == false then
      audioPostEvent_SystemUi(11, 1)
      _AudioPostEvent_SystemUiForXBOX(11, 1)
      getSelfPlayer():get():SetMiniGameResult(4)
      self._ui.stc_Result_Bad:SetShow(false)
      self._ui.stc_Result_Good:SetShow(true)
      self._ui.stc_Result_Good:ResetVertexAni()
      self._ui.stc_Result_Good:SetVertexAniRun("Good_Ani", true)
      self._ui.stc_Result_Good:SetVertexAniRun("Good_ScaleAni", true)
    end
  end
  self._ui.stc_GaugeBar:SetPosX(controlPos)
  self._ui.stc_GaugeBar_Caution:SetPosX(controlPos)
end
function ScreenSize_RePosition_Gradient()
  local self = MiniGame_Gradient
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  for _, v in pairs(self._ui) do
    v:ComputePos()
  end
end
function Panel_Minigame_Gradient_End()
  local self = MiniGame_Gradient
  PaGlobal_ConsoleQuickMenu:widgetOpen()
  Panel_ConsoleKeyGuide:SetShow(true)
  Panel_Minigame_Gradient:SetShow(false)
  isGradientPlay = false
end
function MiniGame_Gradient:Panel_Minigame_Gradient_GaugeMove_Left()
  local lastClickDirection = data.lastClickDirection
  data.lastClickDirection = ClickDirection.Left
  local speedWeight = define.ClickTimeSpanMinWeight
  if ClickDirection.Left == lastClickDirection and data.lastClickTime < define.sequenceClickTimeSpan then
    speedWeight = _math_lerp(define.ClickTimeSpanMaxWeight, define.ClickTimeSpanMinWeight, data.lastClickTime / define.sequenceClickTimeSpan)
    data.lastClickDirection = ClickDirection.None
  end
  data.currentSpeed = data.currentSpeed * 1.1 - speedWeight
  data.lastClickTime = 0
  if _ContentsGroup_isConsolePadControl then
  else
    self._ui.stc_LButton_L:ResetVertexAni()
    self._ui.stc_LButton_L:SetVertexAniRun("Ani_Color_Left", true)
  end
end
function MiniGame_Gradient:Panel_Minigame_Gradient_GaugeMove_Right()
  local lastClickDirection = data.lastClickDirection
  data.lastClickDirection = ClickDirection.Right
  local speedWeight = define.ClickTimeSpanMinWeight
  if ClickDirection.Right == lastClickDirection and data.lastClickTime < define.sequenceClickTimeSpan then
    speedWeight = _math_lerp(define.ClickTimeSpanMaxWeight, define.ClickTimeSpanMinWeight, data.lastClickTime / define.sequenceClickTimeSpan)
    data.lastClickDirection = ClickDirection.None
  end
  data.currentSpeed = data.currentSpeed * 1.1 + speedWeight
  data.lastClickTime = 0
  if _ContentsGroup_isConsolePadControl then
  else
    self._ui.stc_RButton_R:ResetVertexAni()
    self._ui.stc_RButton_R:SetVertexAniRun("Ani_Color_Right", true)
  end
end
function MiniGame_Gradient_KeyPress(keyType)
  local self = MiniGame_Gradient
  if not isGradientPlay then
    return
  end
  if MGKT.MiniGameKeyType_M0 == keyType then
    self:Panel_Minigame_Gradient_GaugeMove_Left()
  elseif MGKT.MiniGameKeyType_M1 == keyType then
    self:Panel_Minigame_Gradient_GaugeMove_Right()
  end
end
function MiniGame_Gradient_PadPress(keyType)
  local self = MiniGame_Gradient
  if not isGradientPlay then
    return
  end
  if __eQuickTimeEventPadType_LT == keyType then
    self:Panel_Minigame_Gradient_GaugeMove_Left()
  elseif __eQuickTimeEventPadType_RT == keyType then
    self:Panel_Minigame_Gradient_GaugeMove_Right()
  end
end
function FromClient_luaLoadComplete_MiniGame_Gradient_Init()
  local self = MiniGame_Gradient
  self:init()
end
registerEvent("onScreenResize", "ScreenSize_RePosition_Gradient")
registerEvent("EventActionMiniGameKeyDownOnce", "MiniGame_Gradient_KeyPress")
registerEvent("EventActionMiniGamePadDownOnce", "MiniGame_Gradient_PadPress")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MiniGame_Gradient_Init")

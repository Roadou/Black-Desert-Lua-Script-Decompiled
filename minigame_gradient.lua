Panel_Minigame_Gradient:SetShow(false, false)
local MGKT = CppEnums.MiniGameKeyType
local _LButton_L = UI.getChildControl(Panel_Minigame_Gradient, "Static_L_Btn_L")
local _RButton_R = UI.getChildControl(Panel_Minigame_Gradient, "Static_R_Btn_R")
local _gaugeBG = UI.getChildControl(Panel_Minigame_Gradient, "Static_GaugeBG")
local _gaugeBar = UI.getChildControl(Panel_Minigame_Gradient, "Static_GaugeBar")
local _fontGood = UI.getChildControl(Panel_Minigame_Gradient, "Static_Result_Good")
local _fontBad = UI.getChildControl(Panel_Minigame_Gradient, "Static_Result_Bad")
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
_gaugeBar:SetPosY(4)
local data = {
  currentPos = 0.5,
  lastClickTime = 0,
  lastClickDirection = 0,
  currentSpeed = 0
}
local isGradientPlay = false
function MiniGame_GaugeBarMoveCalc(fDeltaTime)
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
  local controlPos = _math_lerp(33, 250, currentPos)
  if controlPos < 90 or controlPos > 195 then
    if _fontBad:GetShow() == false then
      audioPostEvent_SystemUi(11, 2)
      _fontBad:SetShow(true, true)
      _fontGood:SetShow(false, true)
      _fontBad:ResetVertexAni()
      _fontBad:SetVertexAniRun("Bad_Ani", true)
      _fontBad:SetVertexAniRun("Bad_ScaleAni", true)
      if controlPos < 90 then
        audioPostEvent_SystemUi(11, 2)
        getSelfPlayer():get():SetMiniGameResult(1)
      else
        audioPostEvent_SystemUi(11, 2)
        getSelfPlayer():get():SetMiniGameResult(2)
      end
    end
  elseif _fontGood:GetShow() == false then
    audioPostEvent_SystemUi(11, 1)
    getSelfPlayer():get():SetMiniGameResult(4)
    _fontBad:SetShow(false, true)
    _fontGood:SetShow(true, true)
    _fontGood:ResetVertexAni()
    _fontGood:SetVertexAniRun("Good_Ani", true)
    _fontGood:SetVertexAniRun("Good_ScaleAni", true)
  end
  _gaugeBar:SetPosX(controlPos)
end
function Panel_Minigame_Gradient_Start(isRace)
  Panel_Minigame_Gradient:SetShow(true, false)
  Panel_Minigame_Gradient:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
  local centerPos = getScreenSizeX() / 2 - Panel_Minigame_Gradient:GetSizeX() / 2
  _gaugeBar:SetPosX(centerPos)
  _math_randomseed(os.time())
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
function Panel_Minigame_Gradient_End()
  Panel_Minigame_Gradient:SetShow(false, false)
  isGradientPlay = false
end
local function Panel_Minigame_Gradient_GaugeMove_Left()
  local lastClickDirection = data.lastClickDirection
  data.lastClickDirection = ClickDirection.Left
  local speedWeight = define.ClickTimeSpanMinWeight
  if ClickDirection.Left == lastClickDirection and data.lastClickTime < define.sequenceClickTimeSpan then
    speedWeight = _math_lerp(define.ClickTimeSpanMaxWeight, define.ClickTimeSpanMinWeight, data.lastClickTime / define.sequenceClickTimeSpan)
    data.lastClickDirection = ClickDirection.None
  end
  data.currentSpeed = data.currentSpeed - speedWeight
  data.lastClickTime = 0
  _LButton_L:ResetVertexAni()
  _LButton_L:SetVertexAniRun("Ani_Color_Left", true)
end
local function Panel_Minigame_Gradient_GaugeMove_Right()
  local lastClickDirection = data.lastClickDirection
  data.lastClickDirection = ClickDirection.Right
  local speedWeight = define.ClickTimeSpanMinWeight
  if ClickDirection.Right == lastClickDirection and data.lastClickTime < define.sequenceClickTimeSpan then
    speedWeight = _math_lerp(define.ClickTimeSpanMaxWeight, define.ClickTimeSpanMinWeight, data.lastClickTime / define.sequenceClickTimeSpan)
    data.lastClickDirection = ClickDirection.None
  end
  data.currentSpeed = data.currentSpeed + speedWeight
  data.lastClickTime = 0
  _RButton_R:ResetVertexAni()
  _RButton_R:SetVertexAniRun("Ani_Color_Right", true)
end
function MiniGame_Gradient_KeyPress(keyType)
  if not isGradientPlay then
    return
  end
  if MGKT.MiniGameKeyType_M0 == keyType then
    Panel_Minigame_Gradient_GaugeMove_Left()
  elseif MGKT.MiniGameKeyType_M1 == keyType then
    Panel_Minigame_Gradient_GaugeMove_Right()
  end
end
registerEvent("EventActionMiniGameKeyDownOnce", "MiniGame_Gradient_KeyPress")

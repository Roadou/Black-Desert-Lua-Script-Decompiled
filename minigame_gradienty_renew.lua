Panel_MiniGame_Gradient_Y:SetShow(false, false)
local MGKT = CppEnums.MiniGameKeyType
local ui = {
  _keyUp = UI.getChildControl(Panel_MiniGame_Gradient_Y, "Static_Key_Up"),
  _keyDown = UI.getChildControl(Panel_MiniGame_Gradient_Y, "Static_Key_Down"),
  _keyUp_Eff = UI.getChildControl(Panel_MiniGame_Gradient_Y, "Static_Key_Up_Eff"),
  _keyDown_Eff = UI.getChildControl(Panel_MiniGame_Gradient_Y, "Static_Key_Down_Eff"),
  _gaugeBG = UI.getChildControl(Panel_MiniGame_Gradient_Y, "Static_GradientY_BG"),
  _gaugeCursor = UI.getChildControl(Panel_MiniGame_Gradient_Y, "Static_GradientY_Cur"),
  _fontGood = UI.getChildControl(Panel_MiniGame_Gradient_Y, "Static_Result_Good"),
  _fontBad = UI.getChildControl(Panel_MiniGame_Gradient_Y, "Static_Result_Bad"),
  _txt_purpose = UI.getChildControl(Panel_MiniGame_Gradient_Y, "StaticText_Purpose")
}
local KeyDirection = {
  None = 0,
  Up = -1,
  Down = 1
}
local _math_random = math.random
local _math_randomseed = math.randomseed
local _math_lerp = Util.Math.Lerp
local define = {
  sequenceClickTimeSpan = 1.1,
  ClickTimeSpanMaxWeight = 0.25,
  ClickTimeSpanMinWeight = 0.15,
  speedWeight = 5,
  gageSize = Panel_MiniGame_Gradient_Y:GetSizeY()
}
local data = {
  currentPos = 0.5,
  lastClickTime = 0,
  lastKeyDirection = 0,
  currentSpeed = 0
}
local isGradientYPlay = false
function MiniGame_GaugeBarMoveCalcY(fDeltaTime)
  data.lastClickTime = data.lastClickTime + fDeltaTime
  local currentPos = data.currentPos + data.currentSpeed * fDeltaTime
  if currentPos < 0 then
    currentPos = 0
  elseif currentPos > 1 then
    currentPos = 1
  end
  data.currentPos = currentPos
  data.currentSpeed = data.currentSpeed - (0.5 - currentPos) * define.speedWeight * fDeltaTime
  local controlPos = _math_lerp(7, 254, currentPos)
  if controlPos < 58 or controlPos > 184 then
    if ui._fontBad:GetShow() == false then
      _AudioPostEvent_SystemUiForXBOX(11, 2)
      ui._fontBad:SetShow(true, true)
      ui._fontGood:SetShow(false, true)
      ui._fontBad:ResetVertexAni()
      ui._fontBad:SetVertexAniRun("Bad_Ani", true)
      ui._fontBad:SetVertexAniRun("Bad_ScaleAni", true)
      if controlPos < 58 then
        _AudioPostEvent_SystemUiForXBOX(11, 2)
        getSelfPlayer():get():SetMiniGameResult(1)
      elseif controlPos > 184 then
        _AudioPostEvent_SystemUiForXBOX(11, 2)
        getSelfPlayer():get():SetMiniGameResult(2)
      end
    end
  elseif ui._fontGood:GetShow() == false then
    _AudioPostEvent_SystemUiForXBOX(11, 1)
    ui._fontBad:SetShow(false, true)
    ui._fontGood:SetShow(true, true)
    ui._fontGood:ResetVertexAni()
    ui._fontGood:SetVertexAniRun("Good_Ani", true)
    ui._fontGood:SetVertexAniRun("Good_ScaleAni", true)
  end
  ui._gaugeCursor:SetPosY(controlPos)
end
function Panel_Minigame_GradientY_Start()
  if _ContentsGroup_isConsolePadControl then
    ui._txt_purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_HORSEDROP_0"))
  else
  end
  PaGlobal_ConsoleQuickMenu:widgetClose()
  Panel_MiniGame_Gradient_Y:SetShow(true, false)
  Panel_MiniGame_Gradient_Y:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
  local centerPos = getScreenSizeX() / 2 - Panel_MiniGame_Gradient_Y:GetSizeX() / 2
  ui._txt_purpose:SetShow(true)
  ui._keyUp_Eff:SetShow(false)
  ui._keyDown_Eff:SetShow(false)
  ui._gaugeCursor:SetPosX(ui._gaugeBG:GetPosX() + ui._gaugeBG:GetSizeX() / 2 - ui._gaugeCursor:GetSizeX() / 2)
  ui._gaugeCursor:SetPosY(centerPos)
  _math_randomseed(getTickCount32())
  local speed = _math_random()
  data.currentSpeed = (speed - 0.35) / 1.6
  data.lastKeyDirection = KeyDirection.None
  data.lastClickTime = 0
  data.currentPos = 0.5
  isGradientYPlay = true
end
function Panel_Minigame_GradientY_End()
  PaGlobal_ConsoleQuickMenu:widgetOpen()
  Panel_MiniGame_Gradient_Y:SetShow(false, false)
  isGradientYPlay = false
end
local function Panel_Minigame_GradientY_GaugeMove_Up()
  local lastKeyDirection = data.lastKeyDirection
  data.lastKeyDirection = KeyDirection.Up
  local speedWeight = define.ClickTimeSpanMinWeight
  if KeyDirection.Up == lastKeyDirection and data.lastClickTime < define.sequenceClickTimeSpan then
    speedWeight = _math_lerp(define.ClickTimeSpanMaxWeight, define.ClickTimeSpanMinWeight, data.lastClickTime / define.sequenceClickTimeSpan)
    data.lastKeyDirection = KeyDirection.None
  end
  data.currentSpeed = data.currentSpeed - speedWeight
  data.lastClickTime = 0
  ui._keyUp:ResetVertexAni()
  ui._keyUp:SetVertexAniRun("Ani_Color_Up", true)
  ui._keyUp_Eff:SetShow(true)
  ui._keyUp_Eff:ResetVertexAni()
  ui._keyUp_Eff:SetVertexAniRun("Ani_Color_UpEff", true)
end
local function Panel_Minigame_GradientY_GaugeMove_Down()
  local lastKeyDirection = data.lastKeyDirection
  data.lastKeyDirection = KeyDirection.Down
  local speedWeight = define.ClickTimeSpanMinWeight
  if KeyDirection.Down == lastKeyDirection and data.lastClickTime < define.sequenceClickTimeSpan then
    speedWeight = _math_lerp(define.ClickTimeSpanMaxWeight, define.ClickTimeSpanMinWeight, data.lastClickTime / define.sequenceClickTimeSpan)
    data.lastKeyDirection = KeyDirection.None
  end
  data.currentSpeed = data.currentSpeed + speedWeight
  data.lastClickTime = 0
  ui._keyDown:ResetVertexAni()
  ui._keyDown:SetVertexAniRun("Ani_Color_Down", true)
  ui._keyDown_Eff:SetShow(true)
  ui._keyDown_Eff:ResetVertexAni()
  ui._keyDown_Eff:SetVertexAniRun("Ani_Color_DownEff", true)
end
function MiniGame_GradientY_KeyPress(keyType)
  if not isGradientYPlay then
    return
  end
  if MGKT.MiniGameKeyType_W == keyType then
    Panel_Minigame_GradientY_GaugeMove_Up()
  elseif MGKT.MiniGameKeyType_S == keyType then
    Panel_Minigame_GradientY_GaugeMove_Down()
  end
end
function MiniGame_GradientY_PadKeyPress(keyType)
  if not isGradientYPlay then
    return
  end
  if __eQuickTimeEventPadType_B == keyType then
    Panel_Minigame_GradientY_GaugeMove_Up()
  elseif __eQuickTimeEventPadType_A == keyType then
    Panel_Minigame_GradientY_GaugeMove_Down()
  end
end
registerEvent("EventActionMiniGameKeyDownOnce", "MiniGame_GradientY_KeyPress")
registerEvent("EventActionMiniGamePadDownOnce", "MiniGame_GradientY_PadKeyPress")

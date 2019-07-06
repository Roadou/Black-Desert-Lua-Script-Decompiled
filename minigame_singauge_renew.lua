local MGKT = CppEnums.MiniGameKeyType
local UIColor = Defines.Color
Panel_SinGauge:SetShow(false, false)
local gameOptionActionKey = {
  Forward = 0,
  Back = 1,
  Left = 2,
  Right = 3,
  Attack = 4,
  SubAttack = 5,
  Dash = 6,
  Jump = 7
}
local _math_random = math.random
local _math_randomSeed = math.randomseed
local _sinGaugeBG = UI.getChildControl(Panel_SinGauge, "Static_SinGaugeBG")
local _sinGaugeBar = UI.getChildControl(Panel_SinGauge, "Static_SinGauge")
local _sinGaugeBarEffect = UI.getChildControl(Panel_SinGauge, "Static_SinGaugeEffect")
local _spaceBar = UI.getChildControl(Panel_SinGauge, "Static_SpaceBar")
local _spaceBarEff = UI.getChildControl(Panel_SinGauge, "Static_SpaceBar_Eff")
local _sinGauge_Result_Perfect = UI.getChildControl(Panel_SinGauge, "Static_Result_Perfect")
local _sinGauge_Result_Good = UI.getChildControl(Panel_SinGauge, "Static_Result_Good")
local _sinGauge_Result_Bad = UI.getChildControl(Panel_SinGauge, "Static_Result_Bad")
local _txt_Purpose = UI.getChildControl(Panel_SinGauge, "StaticText_Purpose")
local _txt_Checking_Count = UI.getChildControl(Panel_SinGauge, "StaticText_Checking_Count")
local gaugeBarSizeX = 0
local gaugeIsGrowing = true
local checkGaugeCount = 0
local preTick = getTickCount32()
local sinGaugeBarStart = false
local isFinished = true
local gaugeSize = 266
local actionString = ""
if getGamePadEnable() then
  actionString = keyCustom_GetString_ActionPad(gameOptionActionKey.Jump)
else
  actionString = keyCustom_GetString_ActionKey(gameOptionActionKey.Jump)
end
_spaceBar:SetText(actionString)
function SinGauge_RePosition()
  screenX = getOriginScreenSizeX()
  screenY = getOriginScreenSizeY()
  sizeX = Panel_SinGauge:GetSizeX() / 2
  sizeY = Panel_SinGauge:GetSizeY() / 2
  Panel_SinGauge:SetPosX(screenX / 2 - sizeX)
  Panel_SinGauge:SetPosY(screenY / 2 - 180)
end
local function SinGaugeBar_OnFail()
  if isFinished then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(11, 7)
  isFinished = true
  getSelfPlayer():get():SetMiniGameResult(0)
  _sinGauge_Result_Bad:ResetVertexAni()
  _sinGauge_Result_Bad:SetVertexAniRun("Bad_Ani", true)
  _sinGauge_Result_Bad:SetVertexAniRun("Bad_ScaleAni", true)
  _sinGauge_Result_Bad:SetVertexAniRun("Bad_AniEnd", true)
  _sinGauge_Result_Bad:SetShow(true)
end
local gaugeSpeed = 0.8
function SinGaugeBar_UpdateGauge()
  local currentTick = getTickCount32()
  local deltaTick = currentTick - preTick
  local deltaTime = deltaTick / 1000 * gaugeSpeed
  if 3 == checkGaugeCount then
    SinGaugeBar_OnFail()
  end
  if false == isFinished and sinGaugeBarStart == true then
    if gaugeBarSizeX >= 0 and gaugeIsGrowing == true and gaugeBarSizeX < gaugeSize then
      gaugeBarSizeX = gaugeBarSizeX + (gaugeBarSizeX + 1) / gaugeSize * gaugeSize * 10 * deltaTime
      if gaugeBarSizeX > gaugeSize then
        gaugeBarSizeX = gaugeSize
        gaugeIsGrowing = false
      end
      _sinGaugeBar:SetSize(gaugeBarSizeX, 16)
    elseif gaugeIsGrowing == false and gaugeBarSizeX > 10 and checkGaugeCount < 5 then
      gaugeBarSizeX = gaugeBarSizeX - (gaugeBarSizeX + 1) / gaugeSize * gaugeSize * 2.5 * deltaTime
      if gaugeBarSizeX < 10 then
        gaugeBarSizeX = 0
        gaugeIsGrowing = true
        checkGaugeCount = checkGaugeCount + 1
        _txt_Checking_Count:SetText("(" .. checkGaugeCount .. "/3)")
      end
      _sinGaugeBar:SetSize(gaugeBarSizeX, 16)
    elseif gaugeIsGrowing == true and gaugeBarSizeX >= gaugeSize then
      gaugeIsGrowing = false
      gaugeBarSizeX = gaugeSize
    elseif gaugeIsGrowing == false and gaugeBarSizeX <= 0 and checkGaugeCount < 5 then
      gaugeIsGrowing = true
      gaugeBarSizeX = 0
      checkGaugeCount = checkGaugeCount + 1
      _txt_Checking_Count:SetText("(" .. checkGaugeCount .. "/3)")
    end
  end
  preTick = currentTick
end
function Panel_Minigame_SinGauge_Start()
  _math_randomSeed(getTickCount32())
  gaugeSpeed = 0.88 + _math_random(0, 200) / 1000 + getSelfPlayer():get():getFishGrade() * 0.03
  if _ContentsGroup_isConsolePadControl then
    _txt_Purpose:SetText(PAGetString(Defines.StringSheet_RESOURCE, "LUA_XBOX1_GLOBALMANUAL_FISHING_GAUGESTOP"))
  else
  end
  _txt_Checking_Count:SetText("(0/3)")
  isFinished = false
  gaugeBarSizeX = 0
  _sinGaugeBar:SetSize(0, 16)
  _sinGaugeBarEffect:AddEffect("UI_Fishing_Aura01", false, 0, 0)
  Panel_SinGauge:SetShow(true, false)
  Panel_SinGauge:RegisterUpdateFunc("SinGaugeBar_UpdateGauge")
  _sinGauge_Result_Bad:SetShow(false)
  _sinGauge_Result_Good:SetShow(false)
  _sinGauge_Result_Perfect:SetShow(false)
  sinGaugeBarStart = true
  checkGaugeCount = 0
  gaugeIsGrowing = true
  preTick = getTickCount32()
end
function Panel_Minigame_SinGauge_End()
  PaGlobal_ConsoleQuickMenu:widgetOpen()
  Panel_SinGauge:SetShow(false, false)
  _sinGaugeBarEffect:EraseAllEffect()
  isFinished = true
  sinGaugeBarStart = false
end
function MiniGame_SinGauge_KeyPress(keyType)
  if isFinished then
    return
  end
  if MGKT.MiniGameKeyType_Space == keyType then
    _sinGaugeBar:SetSize(gaugeBarSizeX, 16)
    sinGaugeBarStart = false
    if gaugeSize == gaugeBarSizeX then
      _AudioPostEvent_SystemUiForXBOX(11, 0)
      _AudioPostEvent_SystemUiForXBOX(11, 13)
      getSelfPlayer():get():SetMiniGameResult(3)
      isFinished = true
      _sinGauge_Result_Perfect:ResetVertexAni()
      _sinGauge_Result_Perfect:SetVertexAniRun("Perfect_Ani", true)
      _sinGauge_Result_Perfect:SetVertexAniRun("Perfect_ScaleAni", true)
      _sinGauge_Result_Perfect:SetVertexAniRun("Perfect_AniEnd", true)
      _sinGauge_Result_Perfect:SetShow(true)
    elseif gaugeBarSizeX > 167 then
      _AudioPostEvent_SystemUiForXBOX(11, 0)
      _AudioPostEvent_SystemUiForXBOX(11, 13)
      getSelfPlayer():get():SetMiniGameResult(11)
      isFinished = true
      _sinGauge_Result_Good:ResetVertexAni()
      _sinGauge_Result_Good:SetVertexAniRun("Good_Ani", true)
      _sinGauge_Result_Good:SetVertexAniRun("Good_ScaleAni", true)
      _sinGauge_Result_Good:SetVertexAniRun("Good_AniEnd", true)
      _sinGauge_Result_Good:SetShow(true)
    else
      SinGaugeBar_OnFail()
    end
  end
end
function MiniGame_SinGauge_PadKeyPress(keyType)
  if isFinished then
    return
  end
  if __eQuickTimeEventPadType_A == keyType then
    MiniGame_SinGauge_KeyPress(MGKT.MiniGameKeyType_Space)
  end
end
registerEvent("onScreenResize", "SinGauge_RePosition")
registerEvent("EventActionMiniGameKeyDownOnce", "MiniGame_SinGauge_KeyPress")
registerEvent("EventActionMiniGamePadDownOnce", "MiniGame_SinGauge_PadKeyPress")
SinGauge_RePosition()

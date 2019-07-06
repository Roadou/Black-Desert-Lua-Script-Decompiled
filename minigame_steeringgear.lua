Panel_SteeringWheel:SetShow(false, false)
local MGKT = CppEnums.MiniGameKeyType
local purposeText = UI.getChildControl(Panel_SteeringWheel, "StaticText_Purpose")
local _LButton_L = UI.getChildControl(Panel_SteeringWheel, "Static_L_Btn_L")
local _RButton_R = UI.getChildControl(Panel_SteeringWheel, "Static_R_Btn_R")
local _marble = UI.getChildControl(Panel_SteeringWheel, "Static_Marble")
local _fontGood = UI.getChildControl(Panel_SteeringWheel, "Static_Result_Good")
local _fontBad = UI.getChildControl(Panel_SteeringWheel, "Static_Result_Bad")
local _math_random = math.random
local _math_randomseed = math.randomseed
local _math_lerp = Util.Math.Lerp
local ClickDirection = {
  None = 0,
  Left = -1,
  Right = 1,
  baseX = 141,
  baseY = 154,
  startX = 40,
  startY = 66
}
local vector = 1
local speed = 0.5
local isSteering = false
local deltaTime = 0
local isSuccess = true
function MiniGame_SteeringWhellMoveCalc(fDeltaTime)
  if not isSteering then
    return
  end
  deltaTime = deltaTime + fDeltaTime
  if deltaTime < 3 then
    purposeText:SetText("\236\157\180\236\131\129\234\184\176\235\165\152\235\165\188 \235\167\140\235\130\172\236\138\181\235\139\136\235\139\164. \236\132\156\235\145\152\235\159\172 \236\161\176\237\131\128\235\165\156\236\157\132 \236\158\161\236\149\132\236\163\188\236\132\184\236\154\148!(" .. math.ceil(3 - deltaTime) .. " \236\180\136)")
    return
  end
  if ClickDirection.startX < 38 or ClickDirection.startX > 243 then
    purposeText:SetText("\236\139\164\237\140\168")
    isSteering = false
    isSuccess = false
    return
  end
  if deltaTime > 8 and isSuccess then
    purposeText:SetText("\236\157\180\236\131\129\234\184\176\235\165\152\235\165\188 \235\172\180\236\130\172\237\158\136 \237\151\164\236\179\144\235\130\152\234\176\148\236\138\181\235\139\136\235\139\164.")
    if deltaTime > 9.1 then
      isSteering = false
    end
    return
  end
  speed = speed * 1.01
  purposeText:SetText("\236\139\156\236\158\145")
  local posX = (ClickDirection.startX - ClickDirection.baseX) * math.cos(fDeltaTime * vector * speed) - (ClickDirection.startY - ClickDirection.baseY) * math.sin(fDeltaTime * vector * speed) + ClickDirection.baseX
  local posY = (ClickDirection.startX - ClickDirection.baseX) * math.sin(fDeltaTime * vector * speed) + (ClickDirection.startY - ClickDirection.baseY) * math.cos(fDeltaTime * vector * speed) + ClickDirection.baseY
  ClickDirection.startX = posX
  ClickDirection.startY = posY
  _marble:SetPosX(ClickDirection.startX - 21)
  _marble:SetPosY(ClickDirection.startY - 21)
end
function Panel_Minigame_SteeringWheel_Init()
  speed = 0.5
  ClickDirection.startX = 40
  ClickDirection.startY = 66
  deltaTime = 0
  isSuccess = true
end
function Panel_Minigame_SteeringWheel_Start()
  Panel_Minigame_SteeringWheel_Init()
  local randomAngle = math.random(0, 45) + 22.5
  local randomRadian = math.rad(randomAngle)
  local posX = (ClickDirection.startX - ClickDirection.baseX) * math.cos(randomRadian) - (ClickDirection.startY - ClickDirection.baseY) * math.sin(randomRadian) + ClickDirection.baseX
  local posY = (ClickDirection.startX - ClickDirection.baseX) * math.sin(randomRadian) + (ClickDirection.startY - ClickDirection.baseY) * math.cos(randomRadian) + ClickDirection.baseY
  ClickDirection.startX = posX
  ClickDirection.startY = posY
  _marble:SetPosX(ClickDirection.startX - 21)
  _marble:SetPosY(ClickDirection.startY - 21)
  if randomAngle > 45 then
    vector = -1
  else
    vector = 1
  end
  purposeText:SetText("\236\139\156\236\158\145")
  isSteering = true
  Panel_SteeringWheel:SetShow(true, true)
  Panel_SteeringWheel:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
end
function Panel_Minigame_SteeringWheel_End()
  if isSuccess then
    getSelfPlayer():get():SetMiniGameResult(0)
  else
    getSelfPlayer():get():SetMiniGameResult(1)
  end
  Panel_SteeringWheel:SetShow(false, false)
end
local function Panel_Minigame_SteeringWheel_GaugeMove_Left()
  local randomSpeed = (math.random(0, 3) + 1) / 10
  if vector > 0 then
    if randomSpeed > speed then
      speed = math.max(randomSpeed - speed, 0.1)
      vector = -1
    else
      speed = math.max(speed - randomSpeed, 0.1)
    end
  else
    speed = speed + randomSpeed
  end
  _LButton_L:ResetVertexAni()
  _LButton_L:SetVertexAniRun("Ani_Color_Left", true)
end
local function Panel_Minigame_SteeringWheel_GaugeMove_Right()
  local randomSpeed = (math.random(0, 3) + 1) / 10
  if vector < 0 then
    if randomSpeed > speed then
      speed = math.max(randomSpeed - speed, 0.1)
      vector = 1
    else
      speed = math.max(speed - randomSpeed, 0.1)
    end
  else
    speed = speed + randomSpeed
  end
  _RButton_R:ResetVertexAni()
  _RButton_R:SetVertexAniRun("Ani_Color_Right", true)
end
function MiniGame_SteeringWheel_KeyPress(keyType)
  if not isSteering then
    return
  end
  if MGKT.MiniGameKeyType_M0 == keyType then
    Panel_Minigame_SteeringWheel_GaugeMove_Left()
  elseif MGKT.MiniGameKeyType_M1 == keyType then
    Panel_Minigame_SteeringWheel_GaugeMove_Right()
  end
end
registerEvent("EventActionMiniGameKeyDownOnce", "MiniGame_SteeringWheel_KeyPress")

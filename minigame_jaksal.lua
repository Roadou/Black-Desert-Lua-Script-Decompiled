local MGKT = CppEnums.MiniGameKeyType
local UI_color = Defines.Color
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
Panel_MiniGame_Jaksal:SetShow(false, false)
Panel_MiniGame_Jaksal:setMaskingChild(true)
local ui = {
  _fish = UI.getChildControl(Panel_MiniGame_Jaksal, "Static_Fish"),
  _water = UI.getChildControl(Panel_MiniGame_Jaksal, "Static_Water"),
  _crossHair = UI.getChildControl(Panel_MiniGame_Jaksal, "Static_Crosshair"),
  _jaksal = UI.getChildControl(Panel_MiniGame_Jaksal, "Static_Jaksal"),
  _gaugeFishPower = UI.getChildControl(Panel_MiniGame_Jaksal, "Progress2_FishGauge"),
  _gaugeJaksalPower = UI.getChildControl(Panel_MiniGame_Jaksal, "CircularProgress_JaksalGauge"),
  _result_Success = UI.getChildControl(Panel_MiniGame_Jaksal, "Static_Result_Success"),
  _result_Failed = UI.getChildControl(Panel_MiniGame_Jaksal, "Static_Result_Failed"),
  _fishGet = UI.getChildControl(Panel_MiniGame_Jaksal, "Static_FishGet"),
  _jaksalCount = UI.getChildControl(Panel_MiniGame_Jaksal, "StaticText_JaksalCount"),
  _endTimer = UI.getChildControl(Panel_MiniGame_Jaksal, "StaticText_EndTimer")
}
ui._water:setGlassBackground(true)
local fishMoveData = {
  position = float2(0, 0),
  rotate = 0,
  destPosition = float2(300, 0),
  escapePower = 1,
  escapePowerDecreasePerSec = 0.9,
  escapePowerIncreasePerSec = 0.1,
  fishRePositionTime = 0
}
local enumJaksal = {
  wait = 0,
  powerUp = 1,
  fullPower = 2,
  powerDown = 3,
  shot = 4
}
local sumTime = 0
local currentPercent = 0
local resetTimer = 0
local jaksalStep = enumJaksal.wait
local jaksalShotWaitTime = 0
local jaksalCount = 15
local isEndTimer = 60
local isStoppedGame = false
local isCatched = false
local jaksalFailCheck = true
function Panel_MiniGame_Jaksal_Start()
  Panel_MiniGame_Jaksal:SetShow(true, false)
  ui._fish:SetIgnore(false)
  Panel_MiniGame_Jaksal:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
  ui._crossHair:SetIgnore(true)
  ui._fishGet:SetShow(false)
  fishMoveData.position.x = ui._water:GetPosX() + math.random(0, ui._water:GetSizeX())
  fishMoveData.position.y = ui._water:GetPosY() + math.random(0, ui._water:GetSizeY())
  ui._fish:SetShow(true)
  ui._fish:SetPosX(fishMoveData.position.x)
  ui._fish:SetPosY(fishMoveData.position.y)
  ui._fish:SetColor(Defines.Color.C_FF000000)
  ui._result_Failed:SetShow(false)
  ui._result_Failed:SetAlpha(0)
  ui._result_Success:SetShow(false)
  ui._result_Success:ResetVertexAni()
  ui._result_Success:SetAlpha(0)
  ui._endTimer:ResetVertexAni()
  ui._jaksalCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAMEJAKSAL_JaksalCount", "JaksalCount", jaksalCount))
  setForceMoveCamera(true)
  isStoppedGame = false
  jaksalFailCheck = true
end
function Panel_MiniGame_Jaksal_End()
  jaksalCount = 15
  sumTime = 0
  currentPercent = 0
  resetTimer = 0
  jaksalShotWaitTime = 0
  fishMoveData.escapePower = 1
  isEndTimer = 60
  ui._water:EraseAllEffect()
  Panel_MiniGame_Jaksal:SetShow(false, false)
  isStoppedGame = false
  jaksalFailCheck = true
  setForceMoveCamera(false)
end
local rotateToDirection = function(rotate, deltaTime)
  return float2(math.cos(rotate) * deltaTime, math.sin(rotate) * deltaTime)
end
local getLength = function(float2Value)
  return math.pow(float2Value.x * float2Value.x + float2Value.y * float2Value.y, 0.5)
end
local function normalize(float2Value)
  local length = getLength(float2Value)
  return float2(float2Value.x / length, float2Value.y / length)
end
local function changeDestPosition(useImprovedEscape, updateForce)
  local jaksalPosX = ui._crossHair:GetPosX() + ui._crossHair:GetSizeX() / 2
  local jaksalPosY = ui._crossHair:GetPosY() + ui._crossHair:GetSizeY() / 2
  local jaksalToFishVector = float2(fishMoveData.position.x - jaksalPosX, fishMoveData.position.y - jaksalPosY)
  local fishToDestLength = getLength(jaksalToFishVector)
  if fishToDestLength < 100 then
    if useImprovedEscape then
      jaksalToFishVector = normalize(jaksalToFishVector)
      fishMoveData.destPosition.x = fishMoveData.destPosition.x + jaksalToFishVector.x * 100
      fishMoveData.destPosition.y = fishMoveData.destPosition.y + jaksalToFishVector.y * 100
    else
      fishMoveData.destPosition.x = jaksalPosX + math.random(-400, 400)
      fishMoveData.destPosition.y = jaksalPosY + math.random(-400, 400)
      if fishMoveData.destPosition.x < 0 or ui._water:GetSizeX() < fishMoveData.destPosition.x then
        fishMoveData.destPosition.x = math.random(0, ui._water:GetSizeX())
      end
      if fishMoveData.destPosition.y < 0 or ui._water:GetSizeY() < fishMoveData.destPosition.y then
        fishMoveData.destPosition.y = math.random(0, ui._water:GetSizeY())
      end
    end
    return true
  end
  if updateForce or fishMoveData.destPosition.x < 0 or ui._water:GetSizeX() < fishMoveData.destPosition.x then
    fishMoveData.destPosition.x = math.random(0, ui._water:GetSizeX())
  end
  if updateForce or fishMoveData.destPosition.y < 0 or ui._water:GetSizeY() < fishMoveData.destPosition.y then
    fishMoveData.destPosition.y = math.random(0, ui._water:GetSizeY())
  end
  return false
end
local function rotatePerFrame(startPosition, endPosition, deltaTime, useImprovedEscape, fishToDestLength)
  local direction = float2(endPosition.x - startPosition.x, endPosition.y - startPosition.y)
  local rotate = math.atan2(direction.y, direction.x)
  local rotateA = rotate - fishMoveData.rotate - math.pi * 2
  local rotateB = rotate - fishMoveData.rotate
  local rotateC = rotate - fishMoveData.rotate + math.pi * 2
  rotate = rotateA
  if math.abs(rotateB) < math.abs(rotate) then
    rotate = rotateB
  end
  if math.abs(rotateC) < math.abs(rotate) then
    rotate = rotateC
  end
  local rotateSpeed = 1.5
  if useImprovedEscape and fishToDestLength then
    rotateSpeed = 15
  end
  local rotatePercent = deltaTime * rotateSpeed * fishMoveData.escapePower
  if rotatePercent > 1 then
    rotatePercent = 1
  end
  fishMoveData.rotate = fishMoveData.rotate + rotate * rotatePercent
  if math.pi < fishMoveData.rotate then
    fishMoveData.rotate = fishMoveData.rotate - math.pi * 2
  end
  if fishMoveData.rotate < -math.pi then
    fishMoveData.rotate = fishMoveData.rotate + math.pi * 2
  end
end
local function updateCrossHair()
  local posX = getMousePosX() - Panel_MiniGame_Jaksal:GetPosX() - ui._crossHair:GetSizeX() / 2 + 5
  local posY = getMousePosY() - Panel_MiniGame_Jaksal:GetPosY() - ui._crossHair:GetSizeY() / 2 + 5
  if posX < ui._water:GetPosX() then
    posX = ui._water:GetPosX()
  elseif posX > ui._water:GetPosX() + ui._water:GetSizeX() - ui._crossHair:GetSizeX() then
    posX = ui._water:GetPosX() + ui._water:GetSizeX() - ui._crossHair:GetSizeX()
  end
  if posY < ui._water:GetPosY() then
    posY = ui._water:GetPosY()
  elseif posY > ui._water:GetPosY() + ui._water:GetSizeY() - ui._crossHair:GetSizeY() then
    posY = ui._water:GetPosY() + ui._water:GetSizeY() - ui._crossHair:GetSizeY()
  end
  ui._crossHair:SetPosX(posX)
  ui._crossHair:SetPosY(posY)
end
local function updateEscapePower(fishToDestLength, deltaTime)
  ui._gaugeFishPower:SetProgressRate((1 - (1 - fishMoveData.escapePower) * 2) * 100)
end
function Panel_MiniGame_PerFrameUpdate(deltaTime)
  local useImprovedEscape = true
  updateCrossHair()
  fishMoveData.fishRePositionTime = fishMoveData.fishRePositionTime + deltaTime
  if isStoppedGame == false then
    isEndTimer = isEndTimer - deltaTime
    if 50 >= math.floor(isEndTimer) then
      ui._endTimer:SetVertexAniRun("Ani_Color_Alert", true)
    else
      ui._endTimer:ResetVertexAni()
    end
  end
  local isForceUpdate = false
  if fishMoveData.fishRePositionTime > 1 then
    isForceUpdate = true
    fishMoveData.fishRePositionTime = fishMoveData.fishRePositionTime - 1
  end
  local fishToDestLength = changeDestPosition(useImprovedEscape, isForceUpdate)
  updateEscapePower(fishToDestLength, deltaTime)
  rotatePerFrame(fishMoveData.position, fishMoveData.destPosition, deltaTime, useImprovedEscape, fishToDestLength)
  Panel_MiniGame_FillGaugeUpdate(deltaTime, fishToDestLength)
  local speedValue = 200
  if fishToDestLength then
    speedValue = 300
    ui._fish:SetColor(Defines.Color.C_FFD20000)
    isCatched = true
  else
    ui._fish:SetColor(Defines.Color.C_FF7F7F7F)
    isCatched = false
  end
  local moveValue = rotateToDirection(fishMoveData.rotate, deltaTime * speedValue * fishMoveData.escapePower)
  fishMoveData.position.x = fishMoveData.position.x + moveValue.x
  fishMoveData.position.y = fishMoveData.position.y + moveValue.y
  ui._fish:SetPosX(fishMoveData.position.x - ui._fish:GetSizeX() / 2)
  ui._fish:SetPosY(fishMoveData.position.y - ui._fish:GetSizeY() / 2)
  ui._fish:SetRotate(fishMoveData.rotate)
  ui._endTimer:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAMEJAKSAL_EndTimer", "IsEndTimer", math.floor(isEndTimer)))
  if (math.floor(isEndTimer) <= 0 or jaksalCount < 0) and true == jaksalFailCheck then
    Panel_MiniGame_Jaksal_Failed()
    jaksalFailCheck = false
  end
end
function Panel_MiniGame_FillGaugeUpdate(deltaTime, shotSuccess)
  sumTime = sumTime + deltaTime
  if sumTime > 3 then
    sumTime = 3
  end
  ui._gaugeJaksalPower:SetProgressRate(sumTime * 100)
  if sumTime >= 1 then
    ui._gaugeJaksalPower:SetColor(Defines.Color.C_FFFFFFFF)
  else
    ui._gaugeJaksalPower:SetColor(Defines.Color.C_FFD20000)
  end
end
function Panel_MiniGame_Jaksal_KeyPressCheck(keyType)
  local posX = getMousePosX() - Panel_MiniGame_Jaksal:GetPosX() - ui._jaksal:GetSizeX() / 2
  local posY = getMousePosY() - Panel_MiniGame_Jaksal:GetPosY() - ui._jaksal:GetSizeY() / 2 + 13
  if MGKT.MiniGameKeyType_Space == keyType and sumTime >= 2 and isStoppedGame == false then
    jaksalCount = jaksalCount - 1
    local jaksalPosX = ui._crossHair:GetPosX() + ui._crossHair:GetSizeX() / 2
    local jaksalPosY = ui._crossHair:GetPosY() + ui._crossHair:GetSizeY() / 2
    local jaksalToFishVector = float2(fishMoveData.position.x - jaksalPosX, fishMoveData.position.y - jaksalPosY)
    local fishToDestLength = getLength(jaksalToFishVector)
    if fishToDestLength < 100 then
      fishMoveData.escapePower = fishMoveData.escapePower - 0.05
      render_setChromaticBlur(70, 0.15)
      render_setPointBlur(0.025, 0.15)
      render_setColorBypass(0.3, 0.1)
      ui._fish:ResetVertexAni()
      ui._fish:SetVertexAniRun("Ani_Color_Damage", true)
    end
    if fishMoveData.escapePower <= 0.5 then
      fishMoveData.escapePower = 0.5
      Panel_MiniGame_Jaksal_Success()
    elseif jaksalCount <= 0 then
      Panel_MiniGame_Jaksal_Failed()
    end
    sumTime = 0
    ui._jaksalCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAMEJAKSAL_JaksalCount", "JaksalCount", jaksalCount))
    ui._jaksal:SetShow(true)
    ui._jaksal:ResetVertexAni()
    ui._jaksal:SetVertexAniRun("Ani_Color_Show", true)
    ui._jaksal:SetVertexAniRun("Ani_Color_Hide", true)
    ui._jaksal:ChangeTextureInfoName("new_ui_common_forlua/widget/instance/minigame_jaksal_spear.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(ui._jaksal, 0, 0, 100, 60)
    ui._jaksal:getBaseTexture():setUV(x1, y1, x2, y2)
    ui._jaksal:setRenderTexture(ui._jaksal:getBaseTexture())
    ui._jaksal:SetPosX(posX)
    ui._jaksal:SetPosY(posY)
  end
end
function Panel_MiniGame_Jaksal_Success()
  ui._result_Success:SetShow(true)
  ui._result_Success:ResetVertexAni()
  ui._result_Success:SetVertexAniRun("Ani_Scale_Result_Success_empty", true)
  ui._result_Success:SetVertexAniRun("Ani_Scale_Result_Success", true)
  ui._result_Success:SetVertexAniRun("Ani_Color_Result_Success_empty", true)
  ui._result_Success:SetVertexAniRun("Ani_Color_Result_Success", true)
  ui._fish:SetShow(false)
  ui._fishGet:SetShow(true)
  getSelfPlayer():get():SetMiniGameResult(0)
  isEndTimer = isEndTimer
  isStoppedGame = true
  setForceMoveCamera(false)
end
function Panel_MiniGame_Jaksal_Failed()
  ui._result_Failed:SetShow(true)
  ui._result_Failed:SetVertexAniRun("Ani_Scale_Result_Failed_empty", true)
  ui._result_Failed:SetVertexAniRun("Ani_Scale_Result_Failed", true)
  ui._result_Failed:SetVertexAniRun("Ani_Color_Result_Failed_empty", true)
  ui._result_Failed:SetVertexAniRun("Ani_Color_Result_Failed", true)
  getSelfPlayer():get():SetMiniGameResult(1)
  isStoppedGame = true
  setForceMoveCamera(false)
end

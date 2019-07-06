PaGlobal_SniperGame = {
  _ui = {
    _panel = nil,
    _hole = nil,
    _blackboxes = {},
    _crossHair = nil,
    _deviationMark = nil,
    _deviationHit = {},
    _deviationMiss = {},
    _resultMessage = nil,
    _breathContainer = nil,
    _breath = nil,
    _breathBlue = nil,
    _breathYellow = nil,
    _debugText = nil,
    _deviationMarkForDebug = nil,
    _impactPointForDebug = nil,
    _middlePointDev = nil,
    _fade = nil,
    _fadeCircle = nil
  },
  _breathXOffset = 4,
  _resultMessageShowTime = 0,
  _breathAndContainerRatio = 1,
  _showDebugInfo = false,
  _lensEffectX = nil,
  _lensEffectY = nil,
  _startAniTimePassed = 0,
  _startAniIsPlaying = false,
  _startAniTimeLimit = 0.3,
  _startAniDelay = 0.05,
  centerX = 0,
  centerY = 0
}
local _holeTargetX, _holeTargetY
local _holeSize = 2600
local _holeAniSpeed = 500
local _bestRadius = 50
local _bestRadiusThreshold = 5
local _minRadius = 10
local _maxRadius = 150
local _lensDistortionPower = 1.3
local _lensDistortionSize = 0.8
local _defaultFOV = 0.701622367
local _desiredFOV = 0.17
PaGlobal_SniperGame.centerX = getScreenSizeX() * 0.5
PaGlobal_SniperGame.centerY = getScreenSizeY() * 0.5
local self = PaGlobal_SniperGame
local setTextureUV = function(iconControl, leftX, topY, rightX, bottomY)
end
local addClosingAnimation = function(control, duration, scaleRate)
  if nil == Panel_SniperGame then
    return
  end
  local xSize = control:GetSizeX()
  local ySize = control:GetSizeY()
  local anim1 = control:addMoveAnimation(0, duration, 4)
  anim1:SetStartPosition(control:GetPosX(), control:GetPosY())
  anim1:SetEndPosition(control:GetPosX() - xSize * scaleRate * 0.5, control:GetPosY() - ySize * scaleRate * 0.5)
  local anim3 = control:addScaleAnimation(0, duration, 4)
  anim3:SetStartScale(1)
  anim3:SetEndScale(1 + scaleRate)
end
function PaGlobal_SniperGame:Open()
  if nil == Panel_SniperGame then
    return
  end
  Panel_SniperGame:SetShow(true)
end
function PaGlobal_SniperGame_Close()
  PaGlobal_SniperGame:Close()
end
function PaGlobal_SniperGame:Close()
  if nil == Panel_SniperGame then
    return
  end
  ToClient_SniperGame_StopLensDistortion()
  Panel_SniperGame:SetShow(false)
end
function PaGlobal_SniperGame:OnScreenResize(screenSizeX, screenSizeY)
  if nil == Panel_SniperGame then
    return
  end
  local ui = self._ui
  ui._panel:SetSize(screenSizeX, screenSizeY)
  ui._panel:SetPosXY(0, 0)
  self.centerX = ui._panel:GetPosX() + ui._panel:GetSizeX() * 0.5
  self.centerY = ui._panel:GetPosY() + ui._panel:GetSizeY() * 0.5
  _holeSize = screenSizeY * 2.5
  ui._hole:SetSize(_holeSize, _holeSize)
  ui._breathContainer:ComputePos()
  ui._fade:SetSize(screenSizeX, screenSizeY)
  ui._fade:SetPosXY(0, 0)
  ui._fadeCircle:SetSize(screenSizeX * 1.3, screenSizeX * 1.3)
  ui._blackboxes[1]:SetSize(screenSizeX + _holeSize * 3, _holeSize)
  ui._blackboxes[2]:SetSize(_holeSize, screenSizeY + _holeSize * 3)
  ui._blackboxes[3]:SetSize(screenSizeX + _holeSize * 3, _holeSize)
  ui._blackboxes[4]:SetSize(_holeSize, screenSizeY + _holeSize * 3)
  ui._blackboxes[1]:SetSpanSize(0, -(_holeSize - 5))
  ui._blackboxes[2]:SetSpanSize(-(_holeSize - 5), 0)
  ui._blackboxes[3]:SetSpanSize(0, -(_holeSize - 5))
  ui._blackboxes[4]:SetSpanSize(-(_holeSize - 5), 0)
  ui._blackboxes[1]:ComputePos()
  ui._blackboxes[2]:ComputePos()
  ui._blackboxes[3]:ComputePos()
  ui._blackboxes[4]:ComputePos()
  _targetRestrictX = getScreenSizeX() * 0.2
  _targetRestrictY = getScreenSizeY() * 0.2
end
function PaGlobal_SniperGame_FadeIn()
  if nil == Panel_SniperGame then
    return
  end
  self._ui._panel:SetShow(true)
  self._startAniIsPlaying = true
  _holeAniSpeed = 500
  self._ui._hole:SetPosXY(getScreenSizeX() * 0.8 - _holeSize * 0.5, getScreenSizeY())
  self._ui._hole:SetShow(true)
  self._ui._hole:SetAlphaExtraChild(0)
  self._ui._fadeCircle:SetAlpha(1)
  self._ui._fadeCircle:ComputePos()
  self._ui._fadeCircle:SetShow(true)
  self:ShowFade()
  self:FadeIn()
  self._ui._breathContainer:SetShow(false)
  _lensDistortionPower = 1
end
function PaGlobal_SniperGame_FadeOut()
  if nil == Panel_SniperGame then
    return
  end
  _lensDistortionPower = 1.3
  self:FadeOut()
  self._ui._hole:SetAlphaExtraChild(1)
  self._ui._fadeCircle:SetShow(false)
end
function PaGlobal_SniperGame:ShowFade()
  if nil == Panel_SniperGame then
    return
  end
  self._ui._fade:SetSize(getScreenSizeX(), getScreenSizeY())
  self._ui._fade:SetPosXY(0, 0)
  self._ui._fade:SetAlpha(1)
  self._ui._fade:ResetVertexAni()
  self._ui._fade:SetShow(true)
end
function PaGlobal_SniperGame:FadeIn()
  if nil == Panel_SniperGame then
    return
  end
  self._ui._fade:ResetVertexAni()
  local aniData = self._ui._fade:addColorAnimation(0, self._startAniTimeLimit, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  aniData:SetStartColor(Defines.Color.C_00000000)
  aniData:SetEndColor(Defines.Color.C_FF000000)
  aniData:SetHideAtEnd(false)
end
function PaGlobal_SniperGame:FadeOut()
  if nil == Panel_SniperGame then
    return
  end
  self._ui._fade:ResetVertexAni()
  local aniData = self._ui._fade:addColorAnimation(self._startAniDelay, self._startAniTimeLimit + self._startAniDelay, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  aniData:SetStartColor(Defines.Color.C_FF000000)
  aniData:SetEndColor(Defines.Color.C_00000000)
  aniData:SetHideAtEnd(true)
end
function PaGlobal_SniperGame:StartSearchMode(withAnimation)
  if nil == Panel_SniperGame then
    return
  end
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  self._ui._crossHair:SetShow(false)
  self._ui._deviationMark:SetShow(false)
  self._startAniIsPlaying = false
  self:OnScreenResize(screenSizeX, screenSizeY)
  self:UpdatePerFrame(0)
  if withAnimation then
    PaGlobal_SniperGame_FadeOut()
  end
  _holeAniSpeed = 500
  self:setHoleTarget(screenSizeX * 0.5, screenSizeY * 0.5)
  Panel_SniperGame:SetShow(true)
end
function PaGlobal_SniperGame:EndSearchMode()
end
function PaGlobal_SniperGame:HideCrossHair()
  if nil == Panel_SniperGame then
    return
  end
  self._ui._crossHair:SetShow(false)
end
function PaGlobal_SniperGame:StartAimMiniGame()
  if nil == Panel_SniperGame then
    return
  end
  _holeAniSpeed = 100
  self._ui._crossHair:SetShow(true)
  self._ui._deviationMark:SetShow(true)
end
function PaGlobal_SniperGame:EndAimMiniGame()
  if nil == Panel_SniperGame then
    return
  end
  self._ui._crossHair:SetShow(false)
  self._ui._deviationMark:SetShow(false)
  self:setHoleTarget(getScreenSizeX() * 0.5, getScreenSizeY() * 0.5)
end
function PaGlobal_SniperGame:UpdatePerFrame(deltaTime)
  if nil == Panel_SniperGame then
    return
  end
  local ui = self._ui
  if true == self._startAniIsPlaying then
    ui._debugText:SetShow(false)
    self:animateHolePos(deltaTime)
    return
  end
  local gameInfo = ToClient_SniperGame_GetGameInfo()
  local crossHairPosX = self.centerX + gameInfo:getXOffset()
  local crossHairPosY = self.centerY + gameInfo:getYOffset()
  local gameState = ToClient_SniperGame_GetGameState()
  ui._crossHair:SetPosXY(crossHairPosX - ui._crossHair:GetSizeX() * 0.5, crossHairPosY - ui._crossHair:GetSizeY() * 0.5)
  ui._deviationMark:SetPosXY(crossHairPosX, crossHairPosY)
  if true == ui._crossHair:GetShow() then
    self:setHoleTarget(crossHairPosX, crossHairPosY)
  else
    self:setHoleTarget(self.centerX, self.centerY)
  end
  self:SetCircularPositioning(math.abs(gameInfo:getRadius() - _bestRadius) * 2 + 16)
  if __eSniperGameState_AimMiniGame == gameState then
    self:animateHolePos(deltaTime)
    if true == gameInfo:isCrossHairOnTarget() then
      if true == self._ui._deviationMiss[1]:GetShow() then
        for ii = 1, #self._ui._deviationHit do
          self._ui._deviationHit[ii]:SetShow(true)
          self._ui._deviationMiss[ii]:SetShow(false)
        end
      end
    elseif true == self._ui._deviationHit[1]:GetShow() then
      for ii = 1, #self._ui._deviationHit do
        self._ui._deviationHit[ii]:SetShow(false)
        self._ui._deviationMiss[ii]:SetShow(true)
      end
    end
  elseif __eSniperGameState_Searching == gameState or __eSniperGameState_RecoverBreath == gameState then
    self:animateHolePos(deltaTime)
  end
  local breathGaugeSize = gameInfo:getRemainedBreathing() / 5
  if breathGaugeSize < 0 then
    breathGaugeSize = 0
  end
  self:UpdateBreathingGauge(gameState, breathGaugeSize, deltaTime)
  if true == ToClient_IsDevelopment() then
    if false == self._showDebugInfo then
      ui._debugText:SetShow(false)
      ui._middlePointDev:SetShow(false)
    else
      ui._debugText:SetShow(true)
      ui._middlePointDev:SetShow(true)
      ui._middlePointDev:SetPosXY(self.centerX - ui._middlePointDev:GetSizeX() / 2, self.centerY - ui._middlePointDev:GetSizeY() / 2)
      local characterWrapper = ToClient_SniperGame_GetHittedCharacterActor()
      local debugMessage = ""
      if nil ~= characterWrapper then
        local selfPlayer = getSelfPlayer()
        local actorKey = characterWrapper:get():getActorKeyRaw()
        local name = characterWrapper:getName()
        local targetPos = characterWrapper:get():getPosition()
        local distance = -1
        if nil ~= selfPlayer then
          local selfPos = selfPlayer:get():getPosition()
          selfPos.x = selfPos.x - targetPos.x
          selfPos.y = selfPos.y - targetPos.y
          selfPos.z = selfPos.z - targetPos.z
          distance = math.sqrt(selfPos.x * selfPos.x + selfPos.y * selfPos.y + selfPos.z * selfPos.z)
        end
        local hitPartName = ToClient_SniperGame_GetHitPartName_DEV()
        if nil == hitPartName then
          hitPartName = "\236\151\134\236\157\140"
        end
        local distanceStr = string.format("%.3f", distance)
        local desiredFOV = string.format("%.3f", ToClient_SniperGame_GetDeisredFOV())
        local currentAccuracy = ToClient_SniperGame_GetShootAccuracy()
        local remainedBreath = string.format("%.3f", gameInfo:getRemainedBreathing())
        debugMessage = [[

ActorKey : ]] .. actorKey .. [[

Name : ]] .. name .. [[

Distance : ]] .. distanceStr .. [[

HitPart : ]] .. hitPartName .. [[

FOV : ]] .. desiredFOV .. "\n\236\160\149\237\153\149\235\143\132 : " .. currentAccuracy .. "\n\237\152\184\237\157\161 : " .. remainedBreath
      else
        debugMessage = "\237\131\128\234\178\159 \236\151\134\236\157\140"
      end
      ui._debugText:SetText(debugMessage)
      ui._debugText:SetPosXY(self.centerX + 250, self.centerY - 250)
    end
  end
end
function PaGlobal_SniperGame:SetCircularPositioning(radius)
  if nil == Panel_SniperGame then
    return
  end
  local count = #self._ui._deviationHit
  for ii = 1, count do
    self:SetImageRotateAndPos(ii, count, self._ui._deviationHit[ii], radius)
    self:SetImageRotateAndPos(ii, count, self._ui._deviationMiss[ii], radius)
  end
end
function PaGlobal_SniperGame:SetImageRotateAndPos(index, count, control, radius)
  if nil == Panel_SniperGame then
    return
  end
  if nil == control or nil == count or count < 1 or nil == index or index < 1 or nil == radius then
    return
  end
  local portion = (index - 1) / count
  control:SetPosXY(math.sin(2 * math.pi * portion) * radius - control:GetSizeX() * 0.5, math.cos(2 * math.pi * portion) * -radius - control:GetSizeY() * 0.5)
  control:SetRotate(2 * math.pi * portion)
end
function PaGlobal_SniperGame:UpdateBreathingGauge(gameState, gaugeSize, deltaTime)
  if nil == Panel_SniperGame then
    return
  end
  local container = self._ui._breathContainer
  local containerSizeX = container:GetSizeX()
  local offsetX = container:GetSizeX() * (1 - self._breathAndContainerRatio) / 2
  local maxSizeX = containerSizeX * self._breathAndContainerRatio
  local gauge
  if __eSniperGameState_AimMiniGame == gameState then
    self._ui._breathYellow:SetShow(true)
    self._ui._breathBlue:SetShow(false)
    gauge = self._ui._breathYellow
  else
    self._ui._breathYellow:SetShow(false)
    self._ui._breathBlue:SetShow(true)
    gauge = self._ui._breathBlue
  end
  local maxSizeY = gauge:GetSizeY()
  gauge:SetPosX(offsetX)
  gauge:SetSize(maxSizeX * gaugeSize, maxSizeY)
  gauge:SetSize(maxSizeX * gaugeSize, maxSizeY)
  if gaugeSize > 0.99 then
    container:SetShow(false)
  else
    container:SetShow(true)
  end
end
local _targetRestrictX = getScreenSizeX() * 0.2
local _targetRestrictY = getScreenSizeY() * 0.2
function PaGlobal_SniperGame:setHoleTarget(xx, yy)
  if xx < _targetRestrictX then
    _holeTargetX = _targetRestrictX
  elseif xx > getScreenSizeX() - _targetRestrictX then
    _holeTargetX = getScreenSizeX() - _targetRestrictX
  else
    _holeTargetX = xx
  end
  if yy < _targetRestrictY then
    _holeTargetY = _targetRestrictY
  elseif yy > getScreenSizeY() - _targetRestrictY then
    _holeTargetY = getScreenSizeY() - _targetRestrictY
  else
    _holeTargetY = yy
  end
  _holeTargetX = _holeTargetX - _holeSize * 0.5
  _holeTargetY = _holeTargetY - _holeSize * 0.5
end
function PaGlobal_SniperGame:animateHolePos(deltaTime)
  if nil == Panel_SniperGame then
    return
  end
  local control = self._ui._hole
  if nil == control or nil == _holeTargetY or nil == _holeTargetX then
    return
  end
  local currentPosX = control:GetPosX()
  local currentPosY = control:GetPosY()
  local distanceX = _holeTargetX - currentPosX
  local distanceY = _holeTargetY - currentPosY
  local accX = distanceX / 100 * deltaTime * _holeAniSpeed
  local accY = distanceY / 100 * deltaTime * _holeAniSpeed
  control:SetPosXY(currentPosX + accX, currentPosY + accY)
  self:animateLensEffect(deltaTime)
end
function PaGlobal_SniperGame:animateLensEffect(deltaTime)
  if nil == Panel_SniperGame then
    return
  end
  local control = self._ui._hole
  local screenPosX = control:GetParentPosX() + _holeSize * 0.5
  local screenPosY = control:GetParentPosY() + _holeSize * 0.5
  local screenRelativePosX = screenPosX / getScreenSizeX()
  local screenRelativePosY = screenPosY / getScreenSizeY()
  local powerNegate = _lensDistortionPower - 1
  if _lensDistortionPower > 1 then
    local distX = math.abs(getScreenSizeX() * 0.5 - screenPosX) / (getScreenSizeX() * 0.5)
    local distY = math.abs(getScreenSizeY() * 0.5 - screenPosY) / (getScreenSizeY() * 0.5)
    local scale = math.max(distX, distY)
    powerNegate = powerNegate * scale * scale
  end
  ToClient_SniperGame_SetLensDistortion(_lensDistortionSize, _lensDistortionPower - powerNegate, screenRelativePosX, screenRelativePosY)
end
function PaGlobal_SniperGame:Initialize()
  if nil == Panel_SniperGame then
    return
  end
  PaGlobal_SniperGame._ui._panel = Panel_SniperGame
  PaGlobal_SniperGame._ui._hole = UI.getChildControl(Panel_SniperGame, "Static_BG_SniperGame")
  PaGlobal_SniperGame._ui._blackboxes = {}
  PaGlobal_SniperGame._ui._crossHair = UI.getChildControl(Panel_SniperGame, "Static_CrossHair")
  PaGlobal_SniperGame._ui._deviationMark = UI.getChildControl(Panel_SniperGame, "Static_Deviation")
  PaGlobal_SniperGame._ui._deviationHit = {}
  PaGlobal_SniperGame._ui._deviationMiss = {}
  PaGlobal_SniperGame._ui._resultMessage = UI.getChildControl(Panel_SniperGame, "StaticText_ResultMessage")
  PaGlobal_SniperGame._ui._breathContainer = UI.getChildControl(Panel_SniperGame, "Static_BG_BreathContainer")
  PaGlobal_SniperGame._ui._debugText = UI.getChildControl(Panel_SniperGame, "MultilineText_Debug")
  PaGlobal_SniperGame._ui._deviationMarkForDebug = UI.getChildControl(Panel_SniperGame, "Static_Deviation_ForResult")
  PaGlobal_SniperGame._ui._middlePointDev = UI.getChildControl(Panel_SniperGame, "Static_MiddlePoint_ForDev")
  PaGlobal_SniperGame._ui._fade = UI.getChildControl(Panel_SniperGame, "Static_Fade")
  self._ui._blackboxes = {
    UI.getChildControl(self._ui._hole, "Static_BlackBox1"),
    UI.getChildControl(self._ui._hole, "Static_BlackBox2"),
    UI.getChildControl(self._ui._hole, "Static_BlackBox3"),
    UI.getChildControl(self._ui._hole, "Static_BlackBox4")
  }
  self._ui._deviationHit[1] = UI.getChildControl(self._ui._deviationMark, "Static_DeviationHit1")
  self._ui._deviationMiss[1] = UI.getChildControl(self._ui._deviationMark, "Static_DeviationMiss1")
  for ii = 2, 4 do
    self._ui._deviationHit[ii] = UI.cloneControl(self._ui._deviationHit[1], self._ui._deviationMark, "Static_DeviationHitClone" .. ii)
    self._ui._deviationMiss[ii] = UI.cloneControl(self._ui._deviationMiss[1], self._ui._deviationMark, "Static_DeviationMissClone" .. ii)
  end
  self._breathAndContainerRatio = 1 - self._breathXOffset * 2 / self._ui._breathContainer:GetSizeX()
  self._ui._breathBlue = UI.getChildControl(self._ui._breathContainer, "Static_BG_BreathBlue")
  self._ui._breathYellow = UI.getChildControl(self._ui._breathContainer, "Static_BG_BreathYellow")
  self._ui._breath = self._ui._breathYellow
  self._ui._breathBlue:SetSize(self._ui._breathBlue:GetSizeX(), self._ui._breathContainer:GetSizeY() * 0.5)
  self._ui._breathBlue:ComputePos()
  self._ui._breathYellow:SetSize(self._ui._breathYellow:GetSizeX(), self._ui._breathContainer:GetSizeY() * 0.5)
  self._ui._breathYellow:ComputePos()
  self._ui._impactPointForDebug = UI.getChildControl(self._ui._deviationMarkForDebug, "Static_ImpactPoint")
  self._ui._impactPointForDebug:SetPosXY(30, 30)
  self._ui._deviationMark:SetShow(false)
  self._ui._crossHair:SetShow(false)
  self._ui._breathBlue:SetShow(false)
  self._ui._breathYellow:SetShow(true)
  self._ui._breathContainer:SetShow(true)
  self._ui._deviationMarkForDebug:SetShow(false)
  self._ui._impactPointForDebug:SetShow(false)
  if true == ToClient_IsDevelopment() then
    self._ui._debugText:SetShow(true)
    self._ui._middlePointDev:SetShow(true)
  else
    self._ui._debugText:SetShow(false)
    self._ui._middlePointDev:SetShow(false)
  end
  self._ui._fade:SetSize(getScreenSizeX(), getScreenSizeY())
  self._ui._fade:SetPosXY(0, 0)
  self._ui._fadeCircle = UI.getChildControl(self._ui._hole, "Static_FadeCircle")
  ToClient_SniperGame_SetMaxRangeForCrossHair(500)
  ToClient_SniperGame_SetCrossHairRadiusParam(_minRadius, _maxRadius, _bestRadius - _bestRadiusThreshold, _bestRadius + _bestRadiusThreshold)
  ToClient_SniperGame_SetRotationSensitivity(2.0E-4)
  Panel_SniperGame:RegisterUpdateFunc("FGlobal_Update_SniperGame_PerFrame")
  registerCloseLuaEvent(Panel_SniperGame, PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Attacked
  }), "PaGlobalFunc_SniperGame_EndSniperGame()")
end
function PaGlobal_SniperGame:StartShootingAnimation(duration, scaleRate)
  local ui = self._ui
  addClosingAnimation(ui._hole, duration, scaleRate)
end
function FGlobal_Update_SniperGame_PerFrame(deltaTime)
  self:UpdatePerFrame(deltaTime)
end
function ToggleSniperDebugInfo()
  if true == self._showDebugInfo then
    self._showDebugInfo = false
  else
    self._showDebugInfo = true
  end
end

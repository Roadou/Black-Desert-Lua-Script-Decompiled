local PadSnapTargetEffect = {
  _ui = {
    _rectangleEffect = UI.getChildControl(Panel_PadSnapTargetEffect, "Static_SnapHighlight")
  },
  _targetControl = nil,
  _targetSizeXYRatio = 0,
  _animateTimeLimit = 0.2,
  _animateTime = 0,
  _sinCurveTheta = 0
}
function PadSnapTargetEffect:set(control)
  self:reset()
  if nil == control then
    return
  end
  self._ui._rectangleEffect:SetShow(true)
end
function PadSnapTargetEffect:changeTarget(control)
  if nil ~= control then
    self:show()
    self:set(control)
  else
    self:hide()
  end
  self._targetControl = control
end
function PadSnapTargetEffect:reset()
  self._ui._rectangleEffect:SetShow(false)
  self._animateTime = 0
  self._sinCurveTheta = 0
end
function PadSnapTargetEffect:isAvailableUpdate()
  if false == self._ui._rectangleEffect:GetShow() then
    return false
  end
  if nil == self._targetControl then
    return false
  elseif __ePadSnapAttrType_NoTargetEffect == self._targetControl:getPadSnapAttrType() then
    return false
  end
  return true
end
function PadSnapTargetEffect:update(deltaTime)
  self._animateTime = self._animateTime - deltaTime
  if false == self:isAvailableUpdate() then
    self:reset()
  else
    local value = math.sin(self._sinCurveTheta)
    local adjustedValue = value * 15
    self._ui._rectangleEffect:SetSize(self._targetControl:GetSizeX() + 9 + adjustedValue * 2, self._targetControl:GetSizeY() + 9 + adjustedValue * 2)
    self._ui._rectangleEffect:SetPosX(self._targetControl:GetParentPosX() - 4 - adjustedValue)
    self._ui._rectangleEffect:SetPosY(self._targetControl:GetParentPosY() - 4 - adjustedValue)
    self._ui._rectangleEffect:SetAlpha(1 - value)
    self._sinCurveTheta = self._sinCurveTheta + deltaTime * 4
    if math.pi * 0.5 < self._sinCurveTheta then
      self:reset()
    end
  end
end
function PadSnapTargetEffect:show()
  Panel_PadSnapTargetEffect:SetShow(true)
end
function PadSnapTargetEffect:hide()
  Panel_PadSnapTargetEffect:SetShow(false)
end
function FromClient_PadSnapTargetEffect_UpdatePerframe(deltaTime)
  PadSnapTargetEffect:update(deltaTime)
end
function FromClient_PadSnapTargetEffect_PadSnapChangeTarget(fromControl, toControl)
  PadSnapTargetEffect:changeTarget(toControl)
end
registerEvent("FromClient_PadSnapChangeTarget", "FromClient_PadSnapTargetEffect_PadSnapChangeTarget")
Panel_PadSnapTargetEffect:RegisterUpdateFunc("FromClient_PadSnapTargetEffect_UpdatePerframe")
Panel_PadSnapTargetEffect:SetOffsetIgnorePanel(true)

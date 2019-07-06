PaGlobal_SniperGame_Result = {
  _ui = {
    _resultBg = UI.getChildControl(Panel_SniperGame_Result, "Static_Result_Bg"),
    _deviationMark = nil,
    _impactPoint = nil,
    _resultMessage = nil
  },
  _impactPosX = nil,
  _impactPosY = nil
}
local _initialized = false
function PaGlobal_SniperGame_Result:Initialize()
  local ui = self._ui
  ui._deviationMark = UI.getChildControl(ui._resultBg, "Static_DeviationMark")
  ui._impactPoint = UI.getChildControl(ui._deviationMark, "Static_ImpactPoint")
  ui._resultMessage = UI.getChildControl(ui._resultBg, "StaticText_ResultMessage")
  _initialized = true
end
function PaGlobal_SniperGame_Result:Open()
  Panel_SniperGame_Result:SetSize(getScreenSizeX(), getScreenSizeY())
  self._ui._resultBg:ComputePos()
  Panel_SniperGame_Result:SetShow(true)
end
function PaGlobal_SniperGame_Result_Close()
  PaGlobal_SniperGame_Result:Close()
end
function PaGlobal_SniperGame_Result:Close()
  Panel_SniperGame_Result:SetShow(false)
end
function PaGlobal_SniperGame_Result:OnScreenResize(screenSizeX, screenSizeY)
  Panel_SniperGame_Result:SetSize(screenSizeX, screenSizeY)
  Panel_SniperGame_Result:SetPosXY(0, 0)
  if _initialized then
    self._ui._resultBg:ComputePos()
    self._ui._impactPoint:ComputePos()
    self._ui._resultMessage:ComputePos()
  end
end
function PaGlobal_SniperGame_Result:ClearResult()
  local ui = self._ui
  ui._impactPoint:SetShow(false)
  self:UpdateResultText(3, nil)
end
function PaGlobal_SniperGame_Result:UpdateResultText(resultType, hitPartType)
  local ui = self._ui
  local textPosX = ui._deviationMark:GetPosX()
  local textPosY = ui._deviationMark:GetPosY()
  local resultMessage = ""
  local fontColor = Defines.Color.C_FF797979
  if 1 == resultType then
    if 1 == hitPartType then
      resultMessage = "Critical Shot!"
      fontColor = Defines.Color.C_FFE50D0D
    elseif 2 == hitPartType then
      resultMessage = "Hit!"
    elseif 3 == hitPartType then
      resultMessage = "Hit!"
    else
      resultMessage = "Miss"
    end
  elseif 2 == resultType then
    resultMessage = "Miss"
  else
    resultMessage = "Miss"
    self._impactPosX = nil
    self._impactPosY = nil
  end
  ui._resultMessage:SetText(resultMessage)
  ui._resultMessage:SetSize(ui._resultMessage:GetTextSizeX(), ui._resultMessage:GetTextSizeY())
  ui._resultMessage:SetFontColor(fontColor)
  if nil ~= self._impactPosX and nil ~= self._impactPosY then
    ui._resultMessage:SetPosXY(ui._deviationMark:GetPosX() + self._impactPosX - (ui._resultMessage:GetTextSizeX() - ui._impactPoint:GetSizeX()) * 0.5, ui._deviationMark:GetPosY() + self._impactPosY + 50)
  else
    ui._resultMessage:ComputePos()
  end
end
function PaGlobal_SniperGame_Result:UpdateBulletPos(isMissed, deviationDiameter, desiredScreenPos, hittedScreenPos)
  local ui = self._ui
  self._impactPosX = nil
  self._impactPosY = nil
  ui._deviationMark:SetSize(deviationDiameter, deviationDiameter)
  ui._deviationMark:ComputePos()
  local errX = hittedScreenPos.x - desiredScreenPos.x
  local errY = hittedScreenPos.y - desiredScreenPos.y
  local errLength = math.sqrt(errX * errX + errY * errY)
  local aimPaperRadius = ui._resultBg:GetSizeX() / 2
  if errLength >= aimPaperRadius - 10 and true == isMissed then
    return false
  end
  self._impactPosX = (deviationDiameter - ui._impactPoint:GetSizeX()) / 2 + errX
  self._impactPosY = (deviationDiameter - ui._impactPoint:GetSizeY()) / 2 + errY
  ui._impactPoint:SetPosXY(self._impactPosX, self._impactPosY)
  ui._impactPoint:SetShow(true)
  return true
end
function PaGlobal_SniperGame_Result:UpdateMissResult(deviationDiameter, desiredScreenPos, hittedScreenPos)
  local isBulletPosSet = self:UpdateBulletPos(true, deviationDiameter, desiredScreenPos, hittedScreenPos)
  if true == isBulletPosSet then
    self:UpdateResultText(2, nil)
  else
    self:UpdateResultText(3, nil)
  end
end
function PaGlobal_SniperGame_Result:UpdateShootResult(deviationDiameter, desiredScreenPos, hittedScreenPos, hitPartType)
  self:UpdateBulletPos(false, deviationDiameter, desiredScreenPos, hittedScreenPos)
  self:UpdateResultText(1, hitPartType)
end

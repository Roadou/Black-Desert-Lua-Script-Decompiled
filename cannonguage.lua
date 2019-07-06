Panel_CannonGauge:SetShow(false)
local progress = UI.getChildControl(Panel_CannonGauge, "CannonGaugeBar")
local _txt_StaminaMax = UI.getChildControl(Panel_CannonGauge, "StaticText_CannonGaugeMax")
local elapsTime = 0
function ConnonGauge_FrameUpdate(deltaTime)
  elapsTime = elapsTime + deltaTime
  local nowPower = ToClient_getCommonGauge()
  local maxPower = ToClient_getMaxCommonGauge()
  local percent = nowPower / maxPower * 100
  if 100 == math.floor(percent) then
    return
  end
  _txt_StaminaMax:SetText(string.format("%d", math.ceil(percent)))
  progress:SetProgressRate(percent)
  progress:SetCurrentProgressRate(percent)
end
function FGlobal_CannonGauge_Open()
  Panel_CannonGauge:SetShow(true)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
end
function FGlobal_CannonGauge_Close()
  Panel_CannonGauge:SetShow(false)
end
function FromClient_CannonGauge_onScreenResize()
  Panel_CannonGauge:ComputePos()
end
registerEvent("onScreenResize", "FromClient_CannonGauge_onScreenResize")
Panel_CannonGauge:RegisterUpdateFunc("ConnonGauge_FrameUpdate")

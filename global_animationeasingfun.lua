function PaGlobal_AnimationEasingFun_linear(timeDelta)
  return timeDelta
end
function PaGlobal_AnimationEasingFun_easeInQuad(timeDelta)
  return timeDelta * timeDelta
end
function PaGlobal_AnimationEasingFun_easeOutQuad(timeDelta)
  return timeDelta * (2 - timeDelta)
end
function PaGlobal_AnimationEasingFun_easeInOutQuad(timeDelta)
  timeDelta = timeDelta * 2
  if timeDelta < 1 then
    return 0.5 * timeDelta * timeDelta
  end
  timeDelta = timeDelta - 1
  return -0.5 * (timeDelta * (timeDelta - 2) - 1)
end
function PaGlobal_AnimationEasingFun_easeInCubic(timeDelta)
  return timeDelta * timeDelta * timeDelta
end
function PaGlobal_AnimationEasingFun_easeOutCubic(timeDelta)
  timeDelta = timeDelta - 1
  return timeDelta * timeDelta * timeDelta + 1
end
function PaGlobal_AnimationEasingFun_easeInOutCubic(timeDelta)
  if timeDelta < 0.5 then
    return 4 * timeDelta * timeDelta * timeDelta
  end
  timeDelta = timeDelta - 1
  return 4 * timeDelta * timeDelta * timeDelta + 1
end
function PaGlobal_AnimationEasingFun_easeInQuart(timeDelta)
  return timeDelta * timeDelta * timeDelta * timeDelta
end
function PaGlobal_AnimationEasingFun_easeOutQuart(timeDelta)
  timeDelta = timeDelta - 1
  return 1 - timeDelta * timeDelta * timeDelta * timeDelta
end
function PaGlobal_AnimationEasingFun_easeInOutQuart(timeDelta)
  if timeDelta < 0.5 then
    return 8 * timeDelta * timeDelta * timeDelta * timeDelta
  end
  timeDelta = timeDelta - 1
  return 1 - 8 * timeDelta * timeDelta * timeDelta * timeDelta
end
function PaGlobal_AnimationEasingFun_easeInQuint(timeDelta)
  return timeDelta * timeDelta * timeDelta * timeDelta * timeDelta
end
function PaGlobal_AnimationEasingFun_easeOutQuint(timeDelta)
  timeDelta = timeDelta - 1
  return 1 + timeDelta * timeDelta * timeDelta * timeDelta * timeDelta
end
function PaGlobal_AnimationEasingFun_easeInOutQuint(timeDelta)
  timeDelta = timeDelta / 1 / 2
  if timeDelta < 1 then
    return 0.5 * timeDelta * timeDelta * timeDelta * timeDelta * timeDelta
  end
  timeDelta = timeDelta - 2
  return 0.5 * (timeDelta * timeDelta * timeDelta * timeDelta * timeDelta + 2)
end
function PaGlobal_AnimationEasingFun_easeInBack(timeDelta)
  local s = 1.70158
  return timeDelta * timeDelta * ((s + 1) * timeDelta - s)
end
function PaGlobal_AnimationEasingFun_easeOutBack(timeDelta)
  local s = 1.70158
  timeDelta = timeDelta - 1
  return timeDelta * timeDelta * ((s + 1) * timeDelta + s) + 1
end
function PaGlobal_AnimationEasingFun_easeInOutBack(timeDelta)
  local s = 1.70158
  timeDelta = timeDelta / 1 / 2
  if timeDelta < 1 then
    s = s * 1.525
    return 0.5 * (timeDelta * timeDelta * ((s + 1) * timeDelta - s))
  end
  timeDelta = timeDelta - 2
  local postFix = timeDelta
  s = s * 1.525
  return 0.5 * (postFix * timeDelta * ((s + 1) * timeDelta + s) + 2)
end
function PaGlobal_AnimationEasingFun_easeOutBounce(timeDelta)
  if timeDelta < 0.36363636363636365 then
    return 7.5625 * timeDelta * timeDelta
  elseif timeDelta < 0.7272727272727273 then
    timeDelta = timeDelta - 0.5454545454545454
    local postFix = timeDelta
    return 7.5625 * postFix * timeDelta + 0.75
  elseif timeDelta < 0.9090909090909091 then
    timeDelta = timeDelta - 0.8181818181818182
    local postFix = timeDelta
    return 7.5625 * postFix * timeDelta + 0.9375
  else
    timeDelta = timeDelta - 0.9545454545454546
    local postFix = timeDelta
    return 7.5625 * postFix * timeDelta + 0.984375
  end
end
function PaGlobal_AnimationEasingFun_easeInBounce(timeDelta)
  return 1 - PaGlobal_AnimationEasingFun_easeOutBounce(1 - timeDelta)
end
function PaGlobal_AnimationEasingFun_easeInOutBounce(timeDelta)
  if timeDelta < 0.5 then
    return PaGlobal_AnimationEasingFun_easeInBounce(timeDelta * 2) * 0.5
  else
    return PaGlobal_AnimationEasingFun_easeOutBounce(timeDelta * 2 - 1) * 0.5 + 0.5
  end
end
function PaGlobal_AnimationEasingFun_easeOutQuadFragments(timeDelta, fragments)
  local fixtimeDelta = timeDelta - 1.2
  return -fragments * fixtimeDelta * fixtimeDelta + fragments
end
function PaGlobal_UpdateRectClipOnArea_Animation(controlList, activeControlNo, lastActiveControlNo, targetTime, currentTime)
  local normalized = currentTime / targetTime
  if normalized > 1 then
    normalized = 1
  end
  local posY = controlList[1]._title:GetPosY()
  for idx, control in ipairs(controlList) do
    control._title:SetPosY(posY)
    posY = posY + control._title:GetSizeY() + 2
    control._desc:SetPosY(posY)
    local animatedSizeY = 0
    if idx == activeControlNo then
      animatedSizeY = normalized * control._desc:GetSizeY()
    elseif lastActiveControlNo == idx then
      animatedSizeY = control._desc:GetSizeY() * (1 - normalized)
    else
      animatedSizeY = 0
    end
    control._desc:SetRectClipOnArea(float2(0, 0), float2(control._desc:GetSizeX(), animatedSizeY))
    posY = posY + animatedSizeY + 5
  end
end

local enumRate = {
  rate_40over = 0,
  rate_20over = 1,
  rate_else = 2
}
local rateType = enumRate.rate_40over
function SelfPlayer_HpCheck_SoundFunction(actorKeyRaw, hp, maxHp)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  if false == actorProxyWrapper:get():isSelfPlayer() then
    return
  end
  local rate = hp / maxHp * 100
  local currRateType
  if rate >= 40 then
    currRateType = enumRate.rate_40over
  elseif rate >= 20 then
    currRateType = enumRate.rate_20over
  else
    currRateType = enumRate.rate_else
  end
  if currRateType == rateType then
    return
  end
  if currRateType < rateType then
    rateType = currRateType
    return
  end
  rateType = currRateType
  if enumRate.rate_20over == rateType then
  elseif enumRate.rate_else == rateType then
  end
end
registerEvent("hpChanged", "SelfPlayer_HpCheck_SoundFunction")

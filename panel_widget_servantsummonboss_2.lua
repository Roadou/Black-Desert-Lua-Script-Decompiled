function PaGlobal_ServantSummonBoss_Open()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  if false == PaGlobal_ServantSummonBoss._initialize then
    return
  end
  PaGlobal_ServantSummonBoss:prepareOpen()
end
function PaGlobal_ServantSummonBoss_Close()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  PaGlobal_ServantSummonBoss:prepareClose()
end
function PaGlobal_ServantSummonBoss_GetShow()
  if nil == Panel_Widget_ServantSummonBoss then
    return false
  end
  return Panel_Widget_ServantSummonBoss:GetShow()
end
function FromClient_ServantSummonBoss_RenderModeChangeState(prevRenderModeList, nextRenderModeList)
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  PaGlobal_ServantSummonBoss_Open()
end
function FromClient_ServantSummonBoss_EventSelfPlayerCarrierChanged(vehicleActorKeyRaw)
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local selfProxy = getSelfPlayer():get()
  if nil == selfProxy then
    return
  end
  local actorKeyRaw = selfProxy:getRideVehicleActorKeyRaw()
  if nil == actorKeyRaw then
    return
  end
  local vehicleProxy = getVehicleActor(actorKeyRaw)
  if nil == vehicleProxy then
    return
  end
  local vehicleType = vehicleProxy:get():getVehicleType()
  if CppEnums.VehicleType.Type_BossMonster == vehicleType then
    if nil ~= Panel_HorseHp and true == Panel_HorseHp:GetShow() then
      HorseHP_Close()
    end
    if nil ~= Panel_HorseMp and true == Panel_HorseMp:GetShow() then
      HorseMP_Close()
    end
    PaGlobal_ServantSummonBoss_Open()
    return
  end
  local characterActorProxyWrapper = getCharacterActor(vehicleActorKeyRaw)
  if nil == characterActorProxyWrapper then
    PaGlobal_ServantSummonBoss_Close()
    return
  end
end
function FromClient_ServantSummonBoss_EventSelfServantUpdate()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  PaGlobal_ServantSummonBoss:update()
end
function HandleEventOn_ServantSummonBoss_HpBar()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  PaGlobal_ServantSummonBoss._ui._txt_hp:SetShow(true)
end
function HandleEventOut_ServantSummonBoss_HpBar()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  PaGlobal_ServantSummonBoss._ui._txt_hp:SetShow(false)
end
function FromClient_ServantSummonBoss_EventSelfPlayerRideOn()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  PaGlobal_ServantSummonBoss_Open()
end
function FromClient_ServantSummonBoss_EventSelfPlayerRideOff()
  if nil == Panel_Widget_ServantSummonBoss then
    return
  end
  PaGlobal_ServantSummonBoss_Close()
end

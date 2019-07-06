local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_VT = CppEnums.VehicleType
Panel_Cannon_Renew:SetShow(false, false)
Panel_Cannon_Value_IsCannon = false
local progresssBG = UI.getChildControl(Panel_Cannon_Renew, "Cannon_ProgresssBG")
local progresss = UI.getChildControl(Panel_Cannon_Renew, "Progress2_1")
local progresss_Head = UI.getChildControl(progresss, "Progress2_1_Bar_Head")
local arrowProgressBG = UI.getChildControl(Panel_Cannon_Renew, "Arrow_ProgresssBG")
local arrowProgress = UI.getChildControl(Panel_Cannon_Renew, "ArrowProgress2_1")
local arrowProgress_Head = UI.getChildControl(arrowProgress, "Progress2_1_Bar_Head")
local flameProgressBG = UI.getChildControl(Panel_Cannon_Renew, "FlameThrower_ProgresssBG")
local flameProgress = UI.getChildControl(Panel_Cannon_Renew, "FlameThrowerProgress2_1")
local flameProgress_Head = UI.getChildControl(flameProgress, "Progress2_1_Bar_Head")
local shootCount = UI.getChildControl(Panel_Cannon_Renew, "StaticText_ShootCount")
local vehicle_actorKeyRaw = 0
function CannonShowAni()
  local aniInfo1 = Panel_Cannon_Renew:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.05)
  aniInfo1.AxisX = Panel_Cannon_Renew:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Cannon_Renew:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Cannon_Renew:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.05)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Cannon_Renew:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Cannon_Renew:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function CannonHideAni()
  Panel_Cannon_Renew:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Cannon_Renew:addColorAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local cannon = {}
function FromClient_Cannon_ProgressUpdate()
  if 0 == vehicle_actorKeyRaw then
    return
  end
  cannon = getVehicleActor(vehicle_actorKeyRaw)
  local isVehicleType = cannon:get():getVehicleType()
  if CppEnums.VehicleType.Type_Cannon == isVehicleType or CppEnums.VehicleType.Type_PracticeCannon == isVehicleType or CppEnums.VehicleType.Type_SailingBoat == isVehicleType or CppEnums.VehicleType.Type_PersonalBattleShip == isVehicleType or CppEnums.VehicleType.Type_PersonTradeShip == isVehicleType or CppEnums.VehicleType.Type_PersonalBoat == isVehicleType or CppEnums.VehicleType.Type_CashPersonalBattleShip == isVehicleType or CppEnums.VehicleType.Type_CashPersonalTradeShip == isVehicleType then
    local mp = cannon:get():getMp()
    local maxMp = cannon:get():getMaxMp()
    local nowCoolTime = mp / maxMp * 100
    progresss:SetAniSpeed(0.5)
    progresss:SetProgressRate(nowCoolTime)
  elseif CppEnums.VehicleType.Type_ThrowFire == isVehicleType then
    local mp = cannon:get():getMp()
    local maxMp = cannon:get():getMaxMp()
    local nowCoolTime = mp / maxMp * 100
    flameProgress:SetAniSpeed(0.5)
    flameProgress:SetProgressRate(nowCoolTime)
  elseif CppEnums.VehicleType.Type_ThrowStone == isVehicleType then
    local mp = cannon:get():getMp()
    local maxMp = cannon:get():getMaxMp()
    local nowCoolTime = mp / maxMp * 100
    arrowProgress:SetAniSpeed(0.5)
    arrowProgress:SetProgressRate(nowCoolTime)
  else
    return
  end
end
function FromClient_Cannon_Show(actorKeyRaw)
  if Panel_Cannon_Renew:GetShow() then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local seatPosition = selfPlayer:get():getVehicleSeatIndex()
  local isVehicleType = getVehicleActor(actorKeyRaw):get():getVehicleType()
  progresssBG:SetShow(false)
  progresss:SetShow(false)
  progresss_Head:SetShow(false)
  arrowProgressBG:SetShow(false)
  arrowProgress:SetShow(false)
  arrowProgress_Head:SetShow(false)
  flameProgress:SetShow(false)
  flameProgressBG:SetShow(false)
  flameProgress_Head:SetShow(false)
  vehicle_actorKeyRaw = actorKeyRaw
  if CppEnums.VehicleType.Type_Cannon == isVehicleType or CppEnums.VehicleType.Type_PracticeCannon == isVehicleType then
    Panel_Cannon_Renew:SetShow(true, true)
    progresssBG:SetShow(true)
    progresss:SetShow(true)
    progresss_Head:SetShow(true)
    Panel_Cannon_Value_IsCannon = true
    cannon = getVehicleActor(vehicle_actorKeyRaw)
    local mp = cannon:get():getMp()
    local maxMp = cannon:get():getMaxMp()
    local nowCoolTime = mp / maxMp * 100
    progresss:SetProgressRate(nowCoolTime)
  elseif CppEnums.VehicleType.Type_SailingBoat == isVehicleType or CppEnums.VehicleType.Type_PersonalBattleShip == isVehicleType or CppEnums.VehicleType.Type_PersonTradeShip == isVehicleType or CppEnums.VehicleType.Type_PersonalBoat == isVehicleType or CppEnums.VehicleType.Type_CashPersonalBattleShip == isVehicleType or CppEnums.VehicleType.Type_CashPersonalTradeShip == isVehicleType then
    if 0 ~= seatPosition and 13 ~= seatPosition and 4 ~= seatPosition and 3 ~= seatPosition and 1 ~= seatPosition and 2 ~= seatPosition then
      Panel_Cannon_Renew:SetShow(true, true)
      progresssBG:SetShow(true)
      progresss:SetShow(true)
      progresss_Head:SetShow(true)
      Panel_Cannon_Value_IsCannon = true
      cannon = getVehicleActor(vehicle_actorKeyRaw)
      local mp = cannon:get():getMp()
      local maxMp = cannon:get():getMaxMp()
      local nowCoolTime = mp / maxMp * 100
      progresss:SetProgressRate(nowCoolTime)
    end
  elseif CppEnums.VehicleType.Type_ThrowStone == isVehicleType then
    Panel_Cannon_Renew:SetShow(true, true)
    arrowProgressBG:SetShow(true)
    arrowProgress:SetShow(true)
    arrowProgress_Head:SetShow(true)
    Panel_Cannon_Value_IsCannon = true
    cannon = getVehicleActor(vehicle_actorKeyRaw)
    local mp = cannon:get():getMp()
    local maxMp = cannon:get():getMaxMp()
    local nowCoolTime = mp / maxMp * 100
    arrowProgress:SetProgressRate(nowCoolTime)
  elseif CppEnums.VehicleType.Type_ThrowFire == isVehicleType then
    Panel_Cannon_Renew:SetShow(true, true)
    flameProgress:SetShow(true)
    flameProgressBG:SetShow(true)
    flameProgress_Head:SetShow(true)
    Panel_Cannon_Value_IsCannon = true
    cannon = getVehicleActor(vehicle_actorKeyRaw)
    local mp = cannon:get():getMp()
    local maxMp = cannon:get():getMaxMp()
    local nowCoolTime = mp / maxMp * 100
    flameProgress:SetProgressRate(nowCoolTime)
  elseif CppEnums.VehicleType.Type_Train == isVehicleType then
    if 0 == seatPosition then
      Panel_Cannon_Renew:SetShow(false, false)
    elseif 1 == seatPosition then
      Panel_Cannon_Renew:SetShow(true, true)
    end
  else
    return
  end
end
function FromClient_Cannon_Hide()
  if not Panel_Cannon_Renew:GetShow() then
    return
  end
  Panel_Cannon_Renew:SetShow(false, false)
  FGlobal_CannonGauge_Close()
  Panel_Cannon_Value_IsCannon = false
end
function FromClient_UpdateCannonBallCount(count, VehicleTpye)
  if not Panel_Cannon_Renew:GetShow() then
    return
  end
  local shootCountValue = Int64toInt32(count)
  shootCount:SetShow(true)
  shootCount:SetText(shootCountValue)
end
registerEvent("EventSelfPlayerRideOn", "FromClient_Cannon_Show")
registerEvent("EventSelfPlayerRideOff", "FromClient_Cannon_Hide")
registerEvent("FromClient_RideVehicleMpUpdate", "FromClient_Cannon_ProgressUpdate")
registerEvent("FromClient_UpdateCannonBallCount", "FromClient_UpdateCannonBallCount")

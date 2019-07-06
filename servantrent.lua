local ServantRent = {_enabled = _ContentsGroup_ServantRent}
function ServantRent:checkEnabled()
  return self._enabled
end
function PaGlobalFunc_ServantRentCheckEnabled()
  return ServantRent:checkEnabled()
end
function ServantRent:checkToShowRegisterForRentButton(servantInfo)
  if not self._enabled then
    return false
  end
  if isSiegeStable() then
    return false
  end
  if not getSelfPlayer() then
    return false
  end
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  if not regionInfo then
    return false
  end
  if regionInfo:getAreaName() ~= servantInfo:getRegionName() then
    return false
  end
  local availableTypeTable = {
    CppEnums.VehicleType.Type_Horse,
    CppEnums.VehicleType.Type_Donkey,
    CppEnums.VehicleType.Type_Camel,
    CppEnums.VehicleType.Type_RidableBabyElephant
  }
  local availableVehicleTypeFlag = false
  for i = 1, #availableTypeTable do
    if servantInfo:getVehicleType() == availableTypeTable[i] then
      availableVehicleTypeFlag = true
      break
    end
  end
  if not availableVehicleTypeFlag then
    return false
  end
  local unavailableStateTable = {
    CppEnums.ServantStateType.Type_Mating,
    CppEnums.ServantStateType.Type_RegisterMarket,
    CppEnums.ServantStateType.Type_RegisterMating,
    CppEnums.ServantStateType.Type_SkillTraining,
    CppEnums.ServantStateType.Type_StallionTraining
  }
  for i = 1, #unavailableStateTable do
    if servantInfo:getStateType() == unavailableStateTable[i] then
      return false
    end
  end
  local hasRentOwnerFlag = false
  if nil ~= servantInfo then
    hasRentOwnerFlag = Defines.s64_const.s64_0 < servantInfo:getRentOwnerNo()
  end
  if hasRentOwnerFlag then
    return false
  end
  return true
end
function PaGlobalFunc_ServantRentCheckToShowRegisterForRentButton(servantInfo)
  return ServantRent:checkToShowRegisterForRentButton(servantInfo)
end
function ServantRent:checkToShowReturnButton(servantInfo)
  if not self._enabled then
    return false
  end
  if isSiegeStable() then
    return false
  end
  if not getSelfPlayer() then
    return false
  end
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  if not regionInfo then
    return false
  end
  if regionInfo:getAreaName() ~= servantInfo:getRegionName() then
    return false
  end
  local availableTypeTable = {
    CppEnums.VehicleType.Type_Horse,
    CppEnums.VehicleType.Type_Donkey,
    CppEnums.VehicleType.Type_Camel,
    CppEnums.VehicleType.Type_RidableBabyElephant
  }
  local availableVehicleTypeFlag = false
  for i = 1, #availableTypeTable do
    if servantInfo:getVehicleType() == availableTypeTable[i] then
      availableVehicleTypeFlag = true
      break
    end
  end
  if not availableVehicleTypeFlag then
    return false
  end
  local unavailableStateTable = {
    CppEnums.ServantStateType.Type_Mating,
    CppEnums.ServantStateType.Type_RegisterMarket,
    CppEnums.ServantStateType.Type_RegisterMating,
    CppEnums.ServantStateType.Type_SkillTraining,
    CppEnums.ServantStateType.Type_StallionTraining
  }
  for i = 1, #unavailableStateTable do
    if servantInfo:getStateType() == unavailableStateTable[i] then
      return false
    end
  end
  local hasRentOwnerFlag = false
  if nil ~= servantInfo then
    hasRentOwnerFlag = Defines.s64_const.s64_0 < servantInfo:getRentOwnerNo()
  end
  if not hasRentOwnerFlag then
    return false
  end
  return true
end
function PaGlobalFunc_ServantRentCheckToShowReturnButton(servantInfo)
  return ServantRent:checkToShowReturnButton(servantInfo)
end

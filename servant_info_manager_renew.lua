local UI_VT = CppEnums.VehicleType
local ENUM_NEW_VT = {
  HORSE = 0,
  CARRIAGE = 1,
  SHIP = 2,
  WORKSHIP = 3,
  LINKHORSE = 4
}
local CONVERT_VT = {
  [CppEnums.VehicleType.Type_Horse] = ENUM_NEW_VT.HORSE,
  [CppEnums.VehicleType.Type_Camel] = ENUM_NEW_VT.HORSE,
  [CppEnums.VehicleType.Type_Donkey] = ENUM_NEW_VT.HORSE,
  [CppEnums.VehicleType.Type_Elephant] = ENUM_NEW_VT.HORSE,
  [CppEnums.VehicleType.Type_RidableBabyElephant] = ENUM_NEW_VT.HORSE,
  [CppEnums.VehicleType.Type_Carriage] = ENUM_NEW_VT.CARRIAGE,
  [CppEnums.VehicleType.Type_CowCarriage] = ENUM_NEW_VT.CARRIAGE,
  [CppEnums.VehicleType.Type_Train] = ENUM_NEW_VT.CARRIAGE,
  [CppEnums.VehicleType.Type_RepairableCarriage] = ENUM_NEW_VT.CARRIAGE,
  [CppEnums.VehicleType.Type_Boat] = ENUM_NEW_VT.SHIP,
  [CppEnums.VehicleType.Type_Raft] = ENUM_NEW_VT.SHIP,
  [CppEnums.VehicleType.Type_FishingBoat] = ENUM_NEW_VT.SHIP,
  [CppEnums.VehicleType.Type_SailingBoat] = ENUM_NEW_VT.WORKSHIP,
  [CppEnums.VehicleType.Type_PersonalBattleShip] = ENUM_NEW_VT.WORKSHIP,
  [CppEnums.VehicleType.Type_PersonTradeShip] = ENUM_NEW_VT.WORKSHIP,
  [CppEnums.VehicleType.Type_PersonalBoat] = ENUM_NEW_VT.WORKSHIP,
  [CppEnums.VehicleType.Type_CashPersonalBattleShip] = ENUM_NEW_VT.WORKSHIP,
  [CppEnums.VehicleType.Type_CashPersonalTradeShip] = ENUM_NEW_VT.WORKSHIP
}
local Servant_Info_Manager_info = {
  _showFunc = {
    [ENUM_NEW_VT.HORSE] = nil,
    [ENUM_NEW_VT.CARRIAGE] = nil,
    [ENUM_NEW_VT.SHIP] = nil,
    [ENUM_NEW_VT.WORKSHIP] = nil
  },
  _exitFunc = {
    [ENUM_NEW_VT.HORSE] = nil,
    [ENUM_NEW_VT.CARRIAGE] = nil,
    [ENUM_NEW_VT.SHIP] = nil,
    [ENUM_NEW_VT.WORKSHIP] = nil
  },
  _getShowFunc = {
    [ENUM_NEW_VT.HORSE] = nil,
    [ENUM_NEW_VT.CARRIAGE] = nil,
    [ENUM_NEW_VT.SHIP] = nil,
    [ENUM_NEW_VT.WORKSHIP] = nil
  },
  _updateFunc = {
    [ENUM_NEW_VT.HORSE] = nil,
    [ENUM_NEW_VT.CARRIAGE] = nil,
    [ENUM_NEW_VT.SHIP] = nil,
    [ENUM_NEW_VT.WORKSHIP] = nil
  },
  _updateHpFunc = {
    [ENUM_NEW_VT.HORSE] = nil,
    [ENUM_NEW_VT.CARRIAGE] = nil,
    [ENUM_NEW_VT.SHIP] = nil,
    [ENUM_NEW_VT.WORKSHIP] = nil
  },
  _updateMpFunc = {
    [ENUM_NEW_VT.HORSE] = nil,
    [ENUM_NEW_VT.CARRIAGE] = nil,
    [ENUM_NEW_VT.SHIP] = nil,
    [ENUM_NEW_VT.WORKSHIP] = nil
  },
  _updateEquipFunc = {
    [ENUM_NEW_VT.HORSE] = nil,
    [ENUM_NEW_VT.CARRIAGE] = nil,
    [ENUM_NEW_VT.SHIP] = nil,
    [ENUM_NEW_VT.WORKSHIP] = nil,
    [ENUM_NEW_VT.LINKHORSE] = nil
  },
  _changeEquipFunc = {
    [ENUM_NEW_VT.HORSE] = nil,
    [ENUM_NEW_VT.CARRIAGE] = nil,
    [ENUM_NEW_VT.SHIP] = nil,
    [ENUM_NEW_VT.WORKSHIP] = nil,
    [ENUM_NEW_VT.LINKHORSE] = nil
  },
  _value = {actorKeyRaw = nil}
}
function Servant_Info_Manager_info:registerMessageHandler()
  registerEvent("FromClient_OpenServantInformation", "PaGlobalFunc_ServantInfo_BeforOpenByActorKeyRaw")
  registerEvent("EventSelfServantUpdate", "PaGlobalFunc_ServantInfo_Update")
  registerEvent("EventSelfServantUpdateOnlyHp", "PaGlobalFunc_ServantInfo_UpdateHp")
  registerEvent("EventSelfServantUpdateOnlyMp", "PaGlobalFunc_ServantInfo_UpdateMp")
  registerEvent("EventServantEquipmentUpdate", "PaGlobalFunc_ServantInfo_UpdateEquip")
  registerEvent("EventServantEquipItem", "PaGlobalFunc_ServantInfo_ChangeEquip")
  registerEvent("FromClient_SelfVehicleLevelUp", "PaGlobalFunc_ServantInfo_SelfVehicleLevelUp")
end
function Servant_Info_Manager_info:initialize()
  self:initValue()
  self:initFunction()
  self:registerMessageHandler()
end
function Servant_Info_Manager_info:initValue()
  self._value.actorKeyRaw = nil
end
function Servant_Info_Manager_info:initFunction()
  self._showFunc[ENUM_NEW_VT.HORSE] = PaGlobalFunc_HorseInfo_Show
  self._showFunc[ENUM_NEW_VT.CARRIAGE] = PaGlobalFunc_CarriageInfo_Show
  self._showFunc[ENUM_NEW_VT.SHIP] = PaGlobalFunc_ShipInfo_Show
  self._showFunc[ENUM_NEW_VT.WORKSHIP] = PaGlobalFunc_ShipInfo_Show
  self._exitFunc[ENUM_NEW_VT.HORSE] = PaGlobalFunc_HorseInfo_Exit
  self._exitFunc[ENUM_NEW_VT.CARRIAGE] = PaGlobalFunc_CarriageInfo_Exit
  self._exitFunc[ENUM_NEW_VT.SHIP] = PaGlobalFunc_ShipInfo_Exit
  self._exitFunc[ENUM_NEW_VT.WORKSHIP] = PaGlobalFunc_ShipInfo_Exit
  self._getShowFunc[ENUM_NEW_VT.HORSE] = PaGlobalFunc_HorseInfo_GetShow
  self._getShowFunc[ENUM_NEW_VT.CARRIAGE] = PaGlobalFunc_CarriageInfo_GetShow
  self._getShowFunc[ENUM_NEW_VT.SHIP] = PaGlobalFunc_ShipInfo_GetShow
  self._getShowFunc[ENUM_NEW_VT.WORKSHIP] = PaGlobalFunc_ShipInfo_GetShow
  self._updateFunc[ENUM_NEW_VT.HORSE] = PaGlobalFunc_HorseInfo_Update
  self._updateFunc[ENUM_NEW_VT.CARRIAGE] = PaGlobalFunc_CarriageInfo_Update
  self._updateFunc[ENUM_NEW_VT.SHIP] = PaGlobalFunc_ShipInfo_Update
  self._updateFunc[ENUM_NEW_VT.WORKSHIP] = PaGlobalFunc_ShipInfo_Update
  self._updateHpFunc[ENUM_NEW_VT.HORSE] = PaGlobalFunc_HorseInfo_UpdateHp
  self._updateHpFunc[ENUM_NEW_VT.CARRIAGE] = PaGlobalFunc_CarriageInfo_UpdateHp
  self._updateHpFunc[ENUM_NEW_VT.SHIP] = PaGlobalFunc_ShipInfo_UpdateHp
  self._updateHpFunc[ENUM_NEW_VT.WORKSHIP] = PaGlobalFunc_ShipInfo_UpdateHp
  self._updateMpFunc[ENUM_NEW_VT.HORSE] = PaGlobalFunc_HorseInfo_UpdateMp
  self._updateMpFunc[ENUM_NEW_VT.CARRIAGE] = PaGlobalFunc_CarriageInfo_UpdateMp
  self._updateMpFunc[ENUM_NEW_VT.SHIP] = PaGlobalFunc_ShipInfo_UpdateMp
  self._updateMpFunc[ENUM_NEW_VT.WORKSHIP] = PaGlobalFunc_ShipInfo_UpdateMp
  self._updateEquipFunc[ENUM_NEW_VT.HORSE] = PaGlobalFunc_HorseInfo_UpdateEquipMent
  self._updateEquipFunc[ENUM_NEW_VT.CARRIAGE] = PaGlobalFunc_CarriageInfo_UpdateEquipMent
  self._updateEquipFunc[ENUM_NEW_VT.SHIP] = PaGlobalFunc_ShipInfo_UpdateEquipMent
  self._updateEquipFunc[ENUM_NEW_VT.WORKSHIP] = PaGlobalFunc_ShipInfo_UpdateEquipMent
  self._updateEquipFunc[ENUM_NEW_VT.LINKHORSE] = PaGlobalFunc_LinkHorseInfo_UpdateEquipMent
  self._changeEquipFunc[ENUM_NEW_VT.HORSE] = PaGlobalFunc_HorseInfo_ChangequipMent
  self._changeEquipFunc[ENUM_NEW_VT.CARRIAGE] = PaGlobalFunc_CarriageInfo_ChangequipMent
  self._changeEquipFunc[ENUM_NEW_VT.SHIP] = PaGlobalFunc_ShipInfo_ChangequipMent
  self._changeEquipFunc[ENUM_NEW_VT.WORKSHIP] = PaGlobalFunc_ShipInfo_ChangequipMent
  self._changeEquipFunc[ENUM_NEW_VT.LINKHORSE] = PaGlobalFunc_LinkHorseInfo_ChangequipMent
end
function Servant_Info_Manager_info:open(openType)
  local openfunc
  openfunc = self._showFunc[openType]
  if nil ~= openfunc then
    openfunc(self._value.actorKeyRaw, openType)
  end
end
function Servant_Info_Manager_info:close()
  for key, exitfunc in pairs(self._exitFunc) do
    if nil ~= exitfunc then
      exitfunc()
    end
  end
end
function Servant_Info_Manager_info:getshow()
  for key, getshow in pairs(self._getShowFunc) do
    if nil ~= getshow and true == getshow() then
      return true
    end
  end
  return false
end
function Servant_Info_Manager_info:update()
  for key, getshow in pairs(self._getShowFunc) do
    if nil ~= getshow and true == getshow() and nil ~= self._updateFunc[key] then
      self._updateFunc[key]()
    end
  end
end
function Servant_Info_Manager_info:updateHp()
  for key, getshow in pairs(self._getShowFunc) do
    if nil ~= getshow and true == getshow() and nil ~= self._updateHpFunc[key] then
      self._updateHpFunc[key]()
    end
  end
end
function Servant_Info_Manager_info:updateMp()
  for key, getshow in pairs(self._getShowFunc) do
    if nil ~= getshow and true == getshow() and nil ~= self._updateMpFunc[key] then
      self._updateMpFunc[key]()
    end
  end
end
function Servant_Info_Manager_info:updateEquip()
  for key, getshow in pairs(self._getShowFunc) do
    if nil ~= getshow and true == getshow() and nil ~= self._updateEquipFunc[key] then
      self._updateEquipFunc[key]()
    end
  end
end
function Servant_Info_Manager_info:changeEquip(slotNo)
  for key, getshow in pairs(self._getShowFunc) do
    if nil ~= getshow and true == getshow() and nil ~= self._changeEquipFunc[key] then
      self._changeEquipFunc[key](slotNo)
    end
  end
end
function PaGlobalFunc_ServantInfo_GetShow()
  local self = Servant_Info_Manager_info
  return self:getshow()
end
function PaGlobalFunc_ServantInfo_Open(openType)
  local self = Servant_Info_Manager_info
  self:open(openType)
end
function PaGlobalFunc_ServantInfo_Close()
  local self = Servant_Info_Manager_info
  self:close()
end
function PaGlobalFunc_ServantInfo_Show(openType)
  local self = Servant_Info_Manager_info
  self:open(openType)
end
function PaGlobalFunc_ServantInfo_Exit()
  local self = Servant_Info_Manager_info
  self:close()
end
function PaGlobalFunc_ServantInfo_BeforOpenByActorKeyRaw(actorKeyRaw)
  local self = Servant_Info_Manager_info
  self._value.actorKeyRaw = actorKeyRaw
  local servantWrapper = getServantInfoFromActorKey(actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  local isSelfVehicle = servantWrapper:isSelfVehicle()
  local vehicleType = servantWrapper:getVehicleType()
  if servantWrapper:isGuildServant() then
    if false == servantWrapper:isMyGuildServant() then
      return
    end
  elseif false == isSelfVehicle then
    return
  end
  if nil == CONVERT_VT[vehicleType] then
    return
  end
  local openType = CONVERT_VT[vehicleType]
  if nil == openType then
    return
  end
  PaGlobalFunc_ServantInfo_Show(openType)
end
function PaGlobalFunc_ServantInfo_Update()
  local self = Servant_Info_Manager_info
  self:update()
end
function PaGlobalFunc_ServantInfo_UpdateHp()
  local self = Servant_Info_Manager_info
  self:updateHp()
end
function PaGlobalFunc_ServantInfo_UpdateMp()
  local self = Servant_Info_Manager_info
  self:updateMp()
end
function PaGlobalFunc_ServantInfo_UpdateEquip()
  local self = Servant_Info_Manager_info
  self:updateEquip()
end
function PaGlobalFunc_ServantInfo_ChangeEquip(slotNo)
  local self = Servant_Info_Manager_info
  self:changeEquip(slotNo)
end
function PaGlobalFunc_ServantInfo_SelfVehicleLevelUp(variedHp, variedMp, variedWeight_s64, variedAcceleration, variedSpeed, variedCornering, variedBrake)
end
function FromClient_ServantInfo_Init()
  local self = Servant_Info_Manager_info
  self:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_ServantInfo_Init")

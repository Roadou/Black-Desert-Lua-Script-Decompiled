Panel_Window_GuildStableRegister:SetShow(false, false)
Panel_Window_GuildStableRegister:setMaskingChild(true)
Panel_Window_GuildStableRegister:ActiveMouseEventEffect(true)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local guildStableRegister = {
  _staticIcon = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_Icon"),
  _staticHp = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_Hp"),
  _staticHpValue = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_HpValue"),
  _staticMp = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_Stamina"),
  _staticMpValue = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_StaminaValue"),
  _staticWeight = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_Weight"),
  _staticWeightValue = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_WeightValue"),
  _staticLife = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_Life"),
  _staticLifeValue = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_LifeValue"),
  _statusBack = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_StatusBack"),
  _staticMaxMoveSpeed = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_MaxMoveSpeed"),
  _staticMaxMoveSpeedValue = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_MaxMoveSpeedValue"),
  _staticAcceleration = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_Acceleration"),
  _staticAccelerationValue = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_AccelerationValue"),
  _staticCorneringSpeed = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_CorneringSpeed"),
  _staticCorneringSpeedValue = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_CorneringSpeedValue"),
  _staticBrakeSpeed = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_BrakeSpeed"),
  _staticBrakeSpeedValue = UI.getChildControl(Panel_Window_GuildStableRegister, "Static_BrakeSpeedValue"),
  _desc = UI.getChildControl(Panel_Window_GuildStableRegister, "StaticText_Desc"),
  _editEditName = UI.getChildControl(Panel_Window_GuildStableRegister, "Edit_Naming"),
  _buttonOk = UI.getChildControl(Panel_Window_GuildStableRegister, "Button_Yes"),
  _buttonClose = UI.getChildControl(Panel_Window_GuildStableRegister, "Button_No"),
  _inventoryType = nil,
  _inventorySlotNo = nil,
  _characterKey = nil,
  _level = nil,
  _type = nil
}
function guildStableRegister:init()
  self._editEditName:SetMaxInput(getGameServiceTypeServantNameLength())
  self._staticIcon:SetShow(true)
  self._staticHp:SetShow(true)
  self._staticHpValue:SetShow(true)
  self._staticMp:SetShow(true)
  self._staticMpValue:SetShow(true)
  self._staticWeight:SetShow(true)
  self._staticWeightValue:SetShow(true)
  self._staticLife:SetShow(false)
  self._staticLifeValue:SetShow(false)
  self._staticMaxMoveSpeed:SetShow(true)
  self._staticMaxMoveSpeedValue:SetShow(true)
  self._staticAcceleration:SetShow(true)
  self._staticAccelerationValue:SetShow(true)
  self._staticCorneringSpeed:SetShow(true)
  self._staticCorneringSpeedValue:SetShow(true)
  self._staticBrakeSpeed:SetShow(true)
  self._staticBrakeSpeedValue:SetShow(true)
  self._editEditName:SetShow(true)
  self._buttonOk:SetShow(true)
  self._buttonClose:SetShow(true)
end
function guildStableRegister:update()
  local servantInfo
  servantInfo = stable_getServantByCharacterKey(self._characterKey, self._level)
  if nil == servantInfo then
    return
  end
  local vehicleType = servantInfo:getVehicleType()
  if CppEnums.VehicleType.Type_Carriage == vehicleType or CppEnums.VehicleType.Type_CowCarriage == vehicleType or CppEnums.VehicleType.Type_RepairableCarriage then
    self._staticHp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEREGISTER_CARRIAGE_HP"))
    self._staticMp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEREGISTER_CARRIAGE_MP"))
    self._staticLife:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEREGISTER_CARRIAGE_LIFE"))
  else
    self._staticHp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEREGISTER_HP"))
    self._staticMp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEREGISTER_MP"))
    self._staticLife:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEREGISTER_LIFE"))
  end
  self._editEditName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_EDITBOX_COMMENT"), true)
  self._staticIcon:ChangeTextureInfoName(servantInfo:getIconPath1())
  self._staticHpValue:SetText(makeDotMoney(servantInfo:getMaxHp()))
  self._staticMpValue:SetText(makeDotMoney(servantInfo:getMaxMp()))
  self._staticWeightValue:SetText(makeDotMoney(servantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000))
  self._staticMaxMoveSpeedValue:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / 10000) .. "%")
  self._staticAccelerationValue:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration) / 10000) .. "%")
  self._staticCorneringSpeedValue:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / 10000) .. "%")
  self._staticBrakeSpeedValue:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / 10000) .. "%")
  if servantInfo:isPeriodLimit() then
    self._staticLifeValue:SetText(servantInfo:getStaticExpiredTime() / 60 / 60 / 24 .. PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFETIME"))
  else
    self._staticLifeValue:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFEVALUE"))
  end
end
function guildStableRegister:registEventHandler()
  self._buttonOk:addInputEvent("Mouse_LUp", "GuildStableRegister_Register()")
  self._buttonClose:addInputEvent("Mouse_LUp", "GuildStableRegister_Close()")
  self._editEditName:addInputEvent("Mouse_LUp", "GuildStableRegister_ClearEdit()")
end
function guildStableRegister:registMessageHandler()
  registerEvent("FromClient_ServantRegisterToAuction", "GuildStableRegister_Close")
  registerEvent("onScreenResize", "GuildStableRegister_Resize")
end
function GuildStableRegister_Resize()
  local self = guildStableRegister
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  Panel_Window_GuildStableRegister:ComputePos()
  self._staticIcon:ComputePos()
  self._staticHp:ComputePos()
  self._staticHpValue:ComputePos()
  self._staticMp:ComputePos()
  self._staticMpValue:ComputePos()
  self._staticWeight:ComputePos()
  self._staticWeightValue:ComputePos()
  self._staticLife:ComputePos()
  self._staticLifeValue:ComputePos()
  self._staticMaxMoveSpeed:ComputePos()
  self._staticMaxMoveSpeedValue:ComputePos()
  self._staticAcceleration:ComputePos()
  self._staticAccelerationValue:ComputePos()
  self._staticCorneringSpeed:ComputePos()
  self._staticCorneringSpeedValue:ComputePos()
  self._staticBrakeSpeed:ComputePos()
  self._staticBrakeSpeedValue:ComputePos()
end
function GuildStableRegister_OpenByTaming()
  local self = guildStableRegister
  local characterKey = stable_getTamingServantCharacterKey()
  if nil == characterKey then
    return
  end
  self._type = CppEnums.ServantRegist.eEventType_Taming
  self._characterKey = characterKey
  self._level = 1
  self._minPrice = nil
  self._maxPrice = nil
  GuildStableRegister_Open()
end
function GuildStableRegister_Register()
  audioPostEvent_SystemUi(0, 0)
  local self = guildStableRegister
  local name = self._editEditName:GetEditText()
  if CppEnums.ServantRegist.eEventType_Taming == self._type then
    stable_register("aaaaa")
  else
    guildStable_registerByItem(self._inventoryType, self._inventorySlotNo, name)
  end
  GuildStableRegister_Close()
  FGlobal_GuildStableList_CloseTamingBg()
end
function GuildStableRegister_ClearEdit()
  local self = guildStableRegister
  self._editEditName:SetEditText("", true)
  SetFocusEdit(self._editEditName)
end
function GuildStableRegister_OpenByInventory(inventoryType, inventorySlotNo)
  local self = guildStableRegister
  local itemWrapper = getInventoryItemByType(inventoryType, inventorySlotNo)
  if nil == itemWrapper then
    return
  end
  self._type = CppEnums.ServantRegist.eEventType_Inventory
  self._inventoryType = inventoryType
  self._inventorySlotNo = inventorySlotNo
  self._characterKey = itemWrapper:getStaticStatus():getObjectKey()
  self._level = 1
  GuildStableRegister_Open()
end
function GuildStableRegister_RegisterType(isShow)
  local self = guildStableRegister
  self._staticHp:SetShow(isShow)
  self._staticHpValue:SetShow(isShow)
  self._staticMp:SetShow(isShow)
  self._staticMpValue:SetShow(isShow)
  self._staticWeight:SetShow(isShow)
  self._staticWeightValue:SetShow(isShow)
  self._staticLife:SetShow(false)
  self._staticLifeValue:SetShow(false)
  self._staticMaxMoveSpeed:SetShow(isShow)
  self._staticMaxMoveSpeedValue:SetShow(isShow)
  self._staticAcceleration:SetShow(isShow)
  self._staticAccelerationValue:SetShow(isShow)
  self._staticCorneringSpeed:SetShow(isShow)
  self._staticCorneringSpeedValue:SetShow(isShow)
  self._staticBrakeSpeed:SetShow(isShow)
  self._staticBrakeSpeedValue:SetShow(isShow)
end
function GuildStableRegister_Open()
  local self = guildStableRegister
  self:update()
  if CppEnums.ServantRegist.eEventType_Taming == self._type then
    self._editEditName:SetShow(false)
    self._desc:SetShow(true)
    GuildStableRegister_RegisterType(false)
  else
    self._editEditName:SetShow(true)
    self._desc:SetShow(false)
    GuildStableRegister_RegisterType(true)
  end
  Panel_Window_GuildStableRegister:SetShow(true)
end
function GuildStableRegister_Close()
  audioPostEvent_SystemUi(0, 0)
  if not Panel_Window_GuildStableRegister:GetShow() then
    return
  end
  audioPostEvent_SystemUi(1, 1)
  Panel_Window_GuildStableRegister:SetShow(false)
end
guildStableRegister:init()
guildStableRegister:registEventHandler()
guildStableRegister:registMessageHandler()
GuildStableRegister_Resize()

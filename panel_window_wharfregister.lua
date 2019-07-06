Panel_Window_WharfRegister:SetShow(false, false)
Panel_Window_WharfRegister:setMaskingChild(true)
Panel_Window_WharfRegister:ActiveMouseEventEffect(true)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local IM = CppEnums.EProcessorInputMode
local wharfRegister = {
  _const = {createType_Inventory = 0, createType_ChangeName = 1},
  _staticIcon = UI.getChildControl(Panel_Window_WharfRegister, "Static_Icon"),
  _staticHp = UI.getChildControl(Panel_Window_WharfRegister, "Static_Hp"),
  _staticHpValue = UI.getChildControl(Panel_Window_WharfRegister, "Static_HpValue"),
  _staticWeight = UI.getChildControl(Panel_Window_WharfRegister, "Static_Weight"),
  _staticWeightValue = UI.getChildControl(Panel_Window_WharfRegister, "Static_WeightValue"),
  _staticStamina = UI.getChildControl(Panel_Window_WharfRegister, "Static_Stamina"),
  _staticStaminaValue = UI.getChildControl(Panel_Window_WharfRegister, "Static_StaminaValue"),
  _staticMaxMoveSpeed = UI.getChildControl(Panel_Window_WharfRegister, "Static_MaxMoveSpeed"),
  _staticMaxMoveSpeedValue = UI.getChildControl(Panel_Window_WharfRegister, "Static_MaxMoveSpeedValue"),
  _staticAcceleration = UI.getChildControl(Panel_Window_WharfRegister, "Static_Acceleration"),
  _staticAccelerationValue = UI.getChildControl(Panel_Window_WharfRegister, "Static_AccelerationValue"),
  _staticCorneringSpeed = UI.getChildControl(Panel_Window_WharfRegister, "Static_CorneringSpeed"),
  _staticCorneringSpeedValue = UI.getChildControl(Panel_Window_WharfRegister, "Static_CorneringSpeedValue"),
  _staticBrakeSpeed = UI.getChildControl(Panel_Window_WharfRegister, "Static_BrakeSpeed"),
  _staticBrakeSpeedValue = UI.getChildControl(Panel_Window_WharfRegister, "Static_BrakeSpeedValue"),
  _editEditName = UI.getChildControl(Panel_Window_WharfRegister, "Edit_Naming"),
  _buttonOk = UI.getChildControl(Panel_Window_WharfRegister, "Button_Yes"),
  _buttonClose = UI.getChildControl(Panel_Window_WharfRegister, "Button_No"),
  _buttonQuestion = UI.getChildControl(Panel_Window_WharfRegister, "Button_Question"),
  _staticCreateServantNameBG = UI.getChildControl(Panel_Window_WharfRegister, "Static_NamingPolicyBG"),
  _staticCreateServantNameTitle = nil,
  _staticCreateServantName = nil,
  _inventoryType = nil,
  _inventorySlotNo = nil,
  _characterKey = nil,
  _level = nil,
  _type = nil
}
wharfRegister._staticCreateServantNameTitle = UI.getChildControl(wharfRegister._staticCreateServantNameBG, "StaticText_NamingPolicyTitle")
wharfRegister._staticCreateServantName = UI.getChildControl(wharfRegister._staticCreateServantNameBG, "StaticText_NamingPolicy")
function wharfRegister:init()
  self._editEditName:SetMaxInput(getGameServiceTypeServantNameLength())
  self._staticIcon:SetShow(true)
  self._staticHp:SetShow(true)
  self._staticHpValue:SetShow(true)
  self._staticWeight:SetShow(true)
  self._staticWeightValue:SetShow(true)
  self._staticStamina:SetShow(true)
  self._staticStaminaValue:SetShow(true)
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
  if isGameTypeEnglish() or isGameTypeTaiwan() or isGameTypeTR() or isGameTypeTH() or isGameTypeID() then
    self._staticCreateServantName:SetTextMode(UI_TM.eTextMode_AutoWrap)
    self._staticCreateServantName:SetShow(true)
    self._staticCreateServantNameBG:SetShow(true)
    self._staticCreateServantNameTitle:SetShow(true)
  else
    self._staticCreateServantName:SetShow(false)
    self._staticCreateServantNameBG:SetShow(false)
    self._staticCreateServantNameTitle:SetShow(false)
  end
  if isGameTypeEnglish() or isGameTypeTaiwan() then
    self._staticCreateServantName:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_EN"))
  elseif isGameTypeTR() then
    self._staticCreateServantName:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_TR"))
  elseif isGameTypeTH() then
    self._staticCreateServantName:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_TH"))
  elseif isGameTypeID() then
    self._staticCreateServantName:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_ID"))
  end
end
function wharfRegister:update()
  local servantInfo = stable_getServantByCharacterKey(self._characterKey, self._level)
  if nil == servantInfo then
    return
  end
  if CppEnums.VehicleType.Type_PersonTradeShip == servantInfo:getVehicleType() or CppEnums.VehicleType.Type_PersonalBoat == servantInfo:getVehicleType() or CppEnums.VehicleType.Type_PersonalBattleShip == servantInfo:getVehicleType() then
    self._staticStamina:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVANT_SHIPINFO_MP"))
  else
    self._staticStamina:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_HEART"))
  end
  self._editEditName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_EDITBOX_COMMENT"), true)
  self._staticIcon:ChangeTextureInfoName(servantInfo:getIconPath1())
  self._staticHpValue:SetText(makeDotMoney(servantInfo:getMaxHp()))
  self._staticStaminaValue:SetText(makeDotMoney(servantInfo:getMaxMp()))
  self._staticWeightValue:SetText(makeDotMoney(servantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000))
  self._staticMaxMoveSpeedValue:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / 10000) .. "%")
  self._staticAccelerationValue:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration) / 10000) .. "%")
  self._staticCorneringSpeedValue:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / 10000) .. "%")
  self._staticBrakeSpeedValue:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / 10000) .. "%")
end
function wharfRegister:registEventHandler()
  self._buttonOk:addInputEvent("Mouse_LUp", "WharfRegister_Register()")
  self._buttonClose:addInputEvent("Mouse_LUp", "WharfRegister_Close()")
  self._editEditName:addInputEvent("Mouse_LUp", "WharfRegister_ClearEdit()")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowStableRegister\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelWindowStableRegister\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelWindowStableRegister\", \"false\")")
end
function wharfRegister:registMessageHandler()
  registerEvent("onScreenResize", "WharfRegister_Resize")
end
function WharfRegister_Resize()
  local self = wharfRegister
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  Panel_Window_WharfRegister:ComputePos()
  self._staticIcon:ComputePos()
  self._staticHp:ComputePos()
  self._staticHpValue:ComputePos()
  self._staticWeight:ComputePos()
  self._staticWeightValue:ComputePos()
  self._staticMaxMoveSpeed:ComputePos()
  self._staticMaxMoveSpeedValue:ComputePos()
  self._staticAcceleration:ComputePos()
  self._staticAccelerationValue:ComputePos()
  self._staticCorneringSpeed:ComputePos()
  self._staticCorneringSpeedValue:ComputePos()
  self._staticBrakeSpeed:ComputePos()
  self._staticBrakeSpeedValue:ComputePos()
end
function WharfRegister_Register()
  audioPostEvent_SystemUi(0, 0)
  local self = wharfRegister
  local name = self._editEditName:GetEditText()
  if self._const.createType_Inventory == self._type then
    stable_registerByItem(self._inventoryType, self._inventorySlotNo, name)
  elseif self._const.createType_ChangeName == self._type then
    stable_changeName(WharfList_SelectSlotNo(), name)
  else
    UI.ASSERT(false, "\236\151\144\235\159\172!")
  end
  ClearFocusEdit()
  self._editEditName:SetEditText("", true)
  WharfRegister_Close()
end
function WharfRegister_ClearEdit()
  local self = wharfRegister
  self._editEditName:SetEditText("", true)
end
function WharfRegister_OpenByInventory(inventoryType, inventorySlotNo)
  local self = wharfRegister
  local itemWrapper = getInventoryItemByType(inventoryType, inventorySlotNo)
  if nil == itemWrapper then
    return
  end
  self._type = self._const.createType_Inventory
  self._inventoryType = inventoryType
  self._inventorySlotNo = inventorySlotNo
  self._characterKey = itemWrapper:getStaticStatus():getObjectKey()
  self._level = 1
  WharfRegister_Open()
end
function WharfRegister_OpenByChangeName()
  local self = wharfRegister
  local servantInfo = stable_getServant(WharfList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  self._type = self._const.createType_ChangeName
  self._characterKey = servantInfo:getCharacterKey()
  self._level = servantInfo:getLevel()
  WharfRegister_Open()
end
function WharfRegister_Open()
  if Panel_Window_WharfRegister:GetShow() then
    return
  end
  local self = wharfRegister
  self:update()
  Panel_Window_WharfRegister:SetShow(true)
end
function WharfRegister_Close()
  audioPostEvent_SystemUi(0, 0)
  if not Panel_Window_WharfRegister:GetShow() then
    return
  end
  audioPostEvent_SystemUi(1, 1)
  Panel_Window_WharfRegister:SetShow(false)
end
wharfRegister:init()
wharfRegister:registEventHandler()
wharfRegister:registMessageHandler()
WharfRegister_Resize()

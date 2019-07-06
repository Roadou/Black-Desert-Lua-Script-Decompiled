local ServantRentPromoteAuth = {
  _init = false,
  _panel = Panel_Stable_PromoteAuth,
  _ui = {
    icon,
    hp,
    stamina,
    weight,
    life,
    maxMoveSpeed,
    acceleration,
    corneringSpeed,
    brakeSpeed,
    userNameEdit
  }
}
function ServantRentPromoteAuth:initialize()
  if self._init then
    return false
  end
  self._init = true
  self._ui.icon = UI.getChildControl(self._panel, "Static_Icon")
  self._ui.hp = UI.getChildControl(self._panel, "Static_HpValue")
  self._ui.stamina = UI.getChildControl(self._panel, "Static_StaminaValue")
  self._ui.weight = UI.getChildControl(self._panel, "Static_WeightValue")
  self._ui.life = UI.getChildControl(self._panel, "Static_LifeValue")
  self._ui.maxMoveSpeed = UI.getChildControl(self._panel, "Static_MaxMoveSpeedValue")
  self._ui.acceleration = UI.getChildControl(self._panel, "Static_AccelerationValue")
  self._ui.corneringSpeed = UI.getChildControl(self._panel, "Static_CorneringSpeedValue")
  self._ui.brakeSpeed = UI.getChildControl(self._panel, "Static_BrakeSpeedValue")
  self._ui.userNameEdit = UI.getChildControl(self._panel, "Edit_Naming")
  self._ui.userNameEdit:SetMaxInput(getGameServiceTypeUserNickNameLength())
  self._ui.userNameEdit:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_PROMOTEAUTH_EDITBOXDESC"), true)
  self._ui.userNameEdit:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteAuthClearEdit()")
  self._ui.userNameEdit:RegistReturnKeyEvent("PaGlobalFunc_ServantRentPromoteAuthRegister()")
  local yesButton = UI.getChildControl(self._panel, "Button_Yes")
  yesButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteAuthRegister()")
  local cancelButton = UI.getChildControl(self._panel, "Button_No")
  cancelButton:addInputEvent("Mouse_LUp", "PaGlobalFunc_ServantRentPromoteAuthClose()")
end
function PaGlobalFunc_ServantRentPromoteAuthInit()
  ServantRentPromoteAuth:initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_ServantRentPromoteAuthInit")
function ServantRentPromoteAuth:clearEdit()
  self._ui.userNameEdit:SetEditText("", true)
end
function PaGlobalFunc_ServantRentPromoteAuthClearEdit()
  return ServantRentPromoteAuth:clearEdit()
end
function ServantRentPromoteAuth:checkShow()
  return self._panel:GetShow()
end
function ServantRentPromoteAuth:close()
  if self:checkShow() then
    self._panel:SetShow(false)
  end
end
function PaGlobalFunc_ServantRentPromoteAuthClose()
  ServantRentPromoteAuth:clearEdit()
  ServantRentPromoteAuth:close()
end
function ServantRentPromoteAuth:open(servantNo)
  if self:checkShow() then
    return
  end
  local info = stable_getServantByServantNo(servantNo)
  if not info then
    return
  end
  self._ui.icon:ChangeTextureInfoName(info:getIconPath1())
  self._ui.icon:SetShow(true)
  self._ui.hp:SetText(makeDotMoney(info:getHp()) .. " / " .. makeDotMoney(info:getMaxHp()))
  self._ui.stamina:SetText(makeDotMoney(info:getMp()) .. " / " .. makeDotMoney(info:getMaxMp()))
  self._ui.weight:SetText(makeDotMoney(info:getMaxWeight_s64() / Defines.s64_const.s64_10000))
  self._ui.life:SetText(info:isPeriodLimit() and convertStringFromDatetime(info:getExpiredTime()) or PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFEVALUE"))
  local maxMoveSpeedPercent = info:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / CppDefine.e1Percent
  self._ui.maxMoveSpeed:SetText(string.format("%.1f", maxMoveSpeedPercent) .. "%")
  local accelerationPercent = info:getStat(CppEnums.ServantStatType.Type_Acceleration) / CppDefine.e1Percent
  self._ui.acceleration:SetText(string.format("%.1f", accelerationPercent) .. "%")
  local corneringSpeedPercent = info:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / CppDefine.e1Percent
  self._ui.corneringSpeed:SetText(string.format("%.1f", corneringSpeedPercent) .. "%")
  local breakSpeedPercent = info:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / CppDefine.e1Percent
  self._ui.brakeSpeed:SetText(string.format("%.1f", breakSpeedPercent) .. "%")
  self._ui.userNameEdit:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_PROMOTEAUTH_EDITBOXDESC"), true)
  self._servantNo = servantNo
  self._panel:SetPosX(getScreenSizeX() / 2 - self._panel:GetSizeX() / 2)
  self._panel:SetPosY(getScreenSizeY() / 2 - self._panel:GetSizeY() / 2 - 20)
  self._panel:SetShow(true)
  return true
end
function PaGlobalFunc_ServantRentPromoteAuthOpen(servantNo)
  if true == Panel_Stable_PromoteAuth:GetShow() then
    Panel_Stable_PromoteAuth:SetShow(false)
  end
  return ServantRentPromoteAuth:open(servantNo)
end
function ServantRentPromoteAuth:register()
  local info = stable_getServantByServantNo(self._servantNo)
  if not info then
    return false
  end
  ToClient_RegisterServantForRent(self._servantNo, self._ui.userNameEdit:GetEditText())
  return true
end
function PaGlobalFunc_ServantRentPromoteAuthRegister()
  return ServantRentPromoteAuth:register()
end

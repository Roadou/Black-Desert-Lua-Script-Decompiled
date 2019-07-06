local AutoTraining_Alarm = {
  _percentage = 0,
  _playerIsAutoTraining = false,
  _const = nil,
  _playerWrapper = nil,
  _s64_needExp = nil,
  _s64_exp = nil,
  _messageAt90Shown = false,
  _messageBoxData = {
    title = nil,
    content = nil,
    functionApply = nil,
    priority = nil,
    exitButton = false
  }
}
function AutoTraining_Alarm:initialize()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  self._playerWrapper = selfPlayer:get()
  if nil == self._playerWrapper then
    return
  end
  self._const = Defines.s64_const
  self._messageBoxData.title = PAGetString(Defines.StringSheet_GAME, "LUA_AUTOTRAININGWARNING_TITLE")
  self._messageBoxData.content = PAGetString(Defines.StringSheet_GAME, "LUA_AUTOTRAININGWARNING_CONTENT")
  self._messageBoxData.functionApply = PAGlobal_AutoTraining_Alarm_OnMessageConfirm
  self._messageBoxData.priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
end
function PAGlobal_AutoTraining_Alarm_OnAutoTrainingStart()
  local self = AutoTraining_Alarm
  self._playerIsAutoTraining = true
  self._s64_needExp = self._playerWrapper:getNeedExp_s64()
  self._s64_exp = self._playerWrapper:getExp_s64()
  self._messageAt90Shown = false
  registerEvent("FromClient_SelfPlayerExpChanged", "PAGlobal_AutoTraining_Alarm_CheckForExp")
  PAGlobal_AutoTraining_Alarm_CheckForExp()
end
function PAGlobal_AutoTraining_Alarm_CheckForExp()
  local selfPlayer = getSelfPlayer()
  local player = selfPlayer:get()
  local blackSpiritTraining = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_BlackSpritTraining)
  local blackSpiritSkillTraining = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_BlackSpritSkillTraining)
  if blackSpiritSkillTraining and not blackSpiritTraining then
    return
  end
  local self = AutoTraining_Alarm
  if false == self._playerIsAutoTraining or nil == self._const or nil == self._s64_needExp or nil == self._s64_exp then
    return
  end
  self._s64_exp = self._playerWrapper:getExp_s64()
  local rate = Int64toInt32(self._s64_exp * Defines.s64_const.s64_100 / self._s64_needExp)
  if rate >= 90 and false == self._messageAt90Shown then
    self._messageAt90Shown = true
    MessageBox.showMessageBox(self._messageBoxData)
  elseif rate >= 98 then
    self._playerIsAutoTraining = false
    self._s64_needExp = nil
    self._s64_exp = nil
    MessageBox.showMessageBox(self._messageBoxData)
    unregisterEvent("FromClient_SelfPlayerExpChanged", "PAGlobal_AutoTraining_Alarm_CheckForExp")
  end
end
function PAGlobal_AutoTraining_Alarm_OnAutoTrainingEnd()
  local self = AutoTraining_Alarm
  self._playerIsAutoTraining = false
  self._s64_needExp = nil
  self._s64_exp = nil
  unregisterEvent("FromClient_SelfPlayerExpChanged", "PAGlobal_AutoTraining_Alarm_CheckForExp")
end
function PAGlobal_AutoTraining_Alarm_OnMessageConfirm()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_AutoTraining_Alarm_luaLoadComplete")
function FromClient_AutoTraining_Alarm_luaLoadComplete()
  AutoTraining_Alarm:initialize()
end

PaGlobal_GardenWorkerManagement = {
  _ui = {
    _txt_regieonTitle = nil,
    _stc_gardenIcon = nil,
    _txt_gardenName = nil,
    _txt_movementLeftTime = nil,
    _txt_movementDistance = nil,
    _txt_movementSpeed = nil,
    _txt_workerLuck = nil,
    _list2_workerList = nil,
    _static_BottomBg = nil,
    _static_KeyGuide_DoWork = nil,
    _static_KeyGuide_Select = nil,
    _static_KeyGuide_Close = nil
  },
  _workerInfoList = {},
  _householdIndex = 0,
  _currentWorkerIndex = 0,
  _currentFocusWorkerIndex = 0,
  _keyGuideAlign = {},
  _initialize = false
}
runLua("UI_Data/Script/Widget/Housing/Console/Panel_Window_GardenWorkerManagement_Renew_1.lua")
runLua("UI_Data/Script/Widget/Housing/Console/Panel_Window_GardenWorkerManagement_Renew_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_GardenWorkerManagementInit")
function FromClient_GardenWorkerManagementInit()
  PaGlobal_GardenWorkerManagement:initialize()
end

PaGlobal_BloodAltar_All = {
  _ui = {
    stc_TitleBG = nil,
    txt_Title = nil,
    btn_PC_Close = nil,
    btn_PC_Question = nil,
    txt_ProcessTitle = nil,
    list_Stage = nil
  },
  _selectStageIndex = -1,
  _currentStageIndex = -1,
  _listCount = -1,
  _isRetry = false,
  _initialize = false
}
runLua("UI_Data/Script/Window/BloodAltar/Panel_Window_BloodAltar_All_1.lua")
runLua("UI_Data/Script/Window/BloodAltar/Panel_Window_BloodAltar_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_BloodAltar_Initialize")
function FromClient_BloodAltar_Initialize()
  PaGlobal_BloodAltar_All:initialize()
end

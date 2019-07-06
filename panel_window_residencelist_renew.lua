PaGlobal_ResidenceList = {
  _ui = {
    _list2_residence = nil,
    _stc_keyguideBG = nil,
    _stc_keyguideX = nil,
    _stc_keyguideB = nil
  },
  _dwellingCount = nil,
  _totalResidenceCount = nil,
  _residenceDataList = {},
  _residencePosList = {},
  _RESIDENCE_TYPE = {
    DWELLING = 0,
    VILLA = 1,
    GUILDHOUSE = 2
  },
  _keyGuideAlign = {},
  _initialize = false
}
runLua("UI_Data/Script/Widget/Housing/Console/Panel_Window_ResidenceList_Renew_1.lua")
runLua("UI_Data/Script/Widget/Housing/Console/Panel_Window_ResidenceList_Renew_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_ResidenceListInit")
function FromClient_ResidenceListInit()
  PaGlobal_ResidenceList:initialize()
end

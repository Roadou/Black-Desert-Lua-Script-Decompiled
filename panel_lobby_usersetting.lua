PaGlobal_LobbyUserSetting = {
  _ui = {
    stc_mainBG = UI.getChildControl(Panel_Lobby_UserSetting, "Static_MainBG"),
    stc_bottomBg = UI.getChildControl(Panel_Lobby_UserSetting, "Static_BottomBg"),
    stc_offsetGroup = nil,
    stc_HDRSliderGroup = nil,
    stc_HDRImage = nil,
    txt_keyGuideA = nil,
    txt_keyGuideB = nil,
    txt_keyGuideY = nil,
    txt_offsetTitle = nil,
    txt_offsetDesc = nil,
    txt_HDRSliderTitle = nil,
    txt_HDRSliderDesc = nil,
    txt_setLater = nil,
    _HDRSlider = nil,
    _HDRProgress = nil
  },
  _originPanelSizeY = 650,
  _sliderValueMin = 50,
  _sliderValueMax = 150,
  _initialize = false,
  _currentStep = 1,
  _configStep = {HDR = 1, count = 2}
}
runLua("UI_Data/Script/Window/FirstLogin/Panel_Lobby_UserSetting_1.lua")
runLua("UI_Data/Script/Window/FirstLogin/Panel_Lobby_UserSetting_2.lua")

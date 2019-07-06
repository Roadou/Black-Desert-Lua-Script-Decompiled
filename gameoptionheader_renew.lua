local CONTROL = CppEnums.PA_UI_CONTROL_TYPE
OPTION_TYPE = {
  RADIOBUTTON = 0,
  CHECKBUTTON = 1,
  SLIDER = 2,
  KEYCUSTOMIZE = 3,
  OTHER = 4
}
PaGlobal_Option = {
  GRAPHIC = {
    VeryVeryLow = 6,
    VeryLow = 0,
    Low = 1,
    Medium = 2,
    High = 3,
    VeryHigh = 4,
    VeryVeryHigh = 5,
    UltraHigh = 8,
    UltraLow = 7
  },
  ALERT = {
    ChangeRegion = 0,
    NormalTrade = 1,
    RoyalTrade = 2,
    FitnessLevelUp = 3,
    TerritoryWar = 4,
    GuildWar = 5,
    OtherPlayerGetItem = 6,
    ItemMarket = 7,
    LifeLevelUp = 8,
    GuildQuestMessage = 9,
    NearMonster = 10,
    OtherMarket = 11,
    EnchantSuccess = 12,
    EnchantFail = 13
  },
  _ui = {
    _frame = UI.getChildControl(Panel_Window_Option_Main, "Frame_Option"),
    _frameContent = UI.getChildControl(UI.getChildControl(Panel_Window_Option_Main, "Frame_Option"), "Frame_1_Content"),
    _bottomBg = UI.getChildControl(Panel_Window_Option_Main, "Static_BottomBg"),
    _titleBg = UI.getChildControl(Panel_Window_Option_Main, "Static_TitleBg")
  },
  _list2 = {
    _curCategory = nil,
    _curFrame = nil,
    _tree2IndexMap = {},
    _selectedKey = nil,
    _selectedSubKey = nil
  },
  _controlCache = {
    [OPTION_TYPE.RADIOBUTTON] = {},
    [OPTION_TYPE.CHECKBUTTON] = {},
    [OPTION_TYPE.SLIDER] = {},
    [OPTION_TYPE.KEYCUSTOMIZE] = {},
    [OPTION_TYPE.OTHER] = {}
  },
  _currentFrame = nil,
  _userInitScreenResolution = {width = 0, height = 0},
  _findStrings = {},
  _keyCustomPadMode = nil,
  _keyCustomInputType = nil,
  _resetCheck = nil,
  _availableResolutionList = nil,
  _screenResolutionCount = nil,
  _fpsTextControl = {},
  _sliderButtonString = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_CURRENT_SLIDERVALUE") .. " <PAColor0xffddcd82>",
  _radioButtonOnString = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_SWITCHON"),
  _radioButtonOffString = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_SWITCHOFF")
}
PaGlobal_Option._elements = {
  AimAssist = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AimAssist",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_CONVENIENCE_AimAssist_DESC"
  },
  UseNewQuickSlot = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_UseNewQuickSlot",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_CONVENIENCE_UseNewQuickSlot_DESC"
  },
  EnableSimpleUI = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_EnableSimpleUI",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_CONVENIENCE_EnableSimpleUI_DESC"
  },
  IsOnScreenSaver = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_IsOnScreenSaver",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_CONVENIENCE_IsOnScreenSaver_DESC"
  },
  UIFontSizeType = {
    _defaultValue = 0,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "PANEL_NEWGAMEOPTION_UIFontSizeType",
    _desc = ""
  },
  ShowNavPathEffectType = {
    _defaultValue = 1,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "PANEL_NEWGAMEOPTION_ShowNavPathEffectType",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_CONVENIENCE_AimAssist_DESC"
  },
  RefuseRequests = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_RefuseRequests",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ETC_RefuseRequests_DESC"
  },
  IsPvpRefuse = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_IsPvpRefuse",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ETC_IsPvpRefuse_DESC"
  },
  IsExchangeRefuse = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_IsExchangeRefuse",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ETC_IsExchangeRefuse_DESC"
  },
  RotateRadarMode = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_RotateRadarMode",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ETC_RotateRadarMode_DESC"
  },
  HideWindowByAttacked = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_HideWindowByAttacked",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ETC_HideWindowByAttacked_DESC"
  },
  AudioResourceType = {
    _defaultValue = 0,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  ServiceResourceType = {
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  UseChattingFilter = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  ChatChannelType = {
    _defaultValue = 0,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  SelfPlayerNameTagVisible = {
    _defaultValue = 0,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "PANEL_NEWGAMEOPTION_FUNCTION_VIEW_CHARACTERNAMETITLE",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_VIEW_SelfPlayerNameTagVisible_DESC_0"
  },
  OtherPlayerNameTagVisible = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  PartyPlayerNameTagVisible = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  GuildPlayerNameTagVisible = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  RankingPlayerNameTagVisible = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  GuideLineZoneChange = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  GuideLineQuestNPC = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  GuideLineNpcIntimacy = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  GuideLineWarAlly = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  GuideLineNonWarPlayer = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  GuideLineEnemy = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  GuideLineGuild = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  GuideLineParty = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  GuideLinePartyMemberEffect = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  PetRender = {
    _defaultValue = 1,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  FairyRender = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  MaidView = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _title = "",
    _desc = ""
  },
  ShowReputation = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  RenderHitEffect = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  DamageMeter = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  ShowComboGuide = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  HideMastOnCarrier = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  WorkerVisible = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  WorldMapOpenType = {
    _defaultValue = 3,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  WorldmapCameraPitchType = {
    _defaultValue = 1,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  TextureQuality = {
    _defaultValue = 1,
    _type = OPTION_TYPE.RADIOBUTTON,
    _isPictureTooltipOn = true,
    _title = "",
    _desc = ""
  },
  GraphicOption = {
    _defaultValue = 2,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  AntiAliasing = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _isPictureTooltipOn = true,
    _title = "",
    _desc = ""
  },
  SSAO = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _isPictureTooltipOn = true,
    _title = "",
    _desc = ""
  },
  PostFilter = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  Tessellation = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _isPictureTooltipOn = true,
    _title = "",
    _desc = ""
  },
  Dof = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _isPictureTooltipOn = true,
    _title = "",
    _desc = ""
  },
  Representative = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _isPictureTooltipOn = true,
    _title = "",
    _desc = ""
  },
  CharacterEffect = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  SnowPoolOnlyInSafeZone = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  BloodEffect = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  LensBlood = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  AutoOptimization = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  AutoOptimizationFrameLimit = {
    _defaultValue = 0.33333,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 60,
    _title = "",
    _desc = ""
  },
  UpscaleEnable = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  SelfPlayerOnlyEffect = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  NearestPlayerOnlyEffect = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  SelfPlayerOnlyLantern = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  PresentLock = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  ShowStackHp = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  UseEffectFrameOptimization = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  EffectFrameOptimization = {
    _defaultValue = 0.03,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0.1,
    _sliderValueMax = 25,
    _title = "",
    _desc = ""
  },
  UsePlayerEffectDistOptimization = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_UsePlayerEffectDistOptimization",
    _desc = "PANEL_NEWGAMEOPTION_PERFORMANCE_OPTIMIZEBETA_UsePlayerEffectDistOptimization_DESC"
  },
  PlayerEffectDistOptimization = {
    _defaultValue = 0.5,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 10,
    _sliderValueMax = 50,
    _title = "__playerDistOptiimizationDesc",
    _desc = ""
  },
  UseCharacterUpdateFrameOptimize = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  UseOtherPlayerUpdate = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_UseOtherPlayerUpdate",
    _desc = "PANEL_NEWGAMEOPTION_PERFORMANCE_OPTIMIZEBETA_UseOtherPlayerUpdate_DESC"
  },
  Fov = {
    _defaultValue = 0.33333,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 40,
    _sliderValueMax = 70,
    _settingRightNow = true,
    _title = "",
    _desc = ""
  },
  CameraEffectMaster = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _title = "PANEL_NEWGAMEOPTION_CameraEffectMaster",
    _desc = "PANEL_NEWGAMEOPTION_GRAPHIC_CameraEffectMaster_DESC"
  },
  CameraShakePower = {
    _defaultValue = 0.5,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _title = "",
    _desc = ""
  },
  MotionBlurPower = {
    _defaultValue = 0.1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _title = "",
    _desc = ""
  },
  CameraTranslatePower = {
    _defaultValue = 0.5,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _title = "",
    _desc = ""
  },
  CameraFovPower = {
    _defaultValue = 0.5,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _title = "",
    _desc = ""
  },
  LUT = {
    _defaultValue = 8,
    _type = CONTROL.PA_UI_CONTROL_BUTTON,
    _settingRightNow = true,
    _title = "",
    _desc = ""
  },
  HDRDisplayGamma = {
    _defaultValue = 0.5,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 50,
    _sliderValueMax = 150,
    _settingRightNow = true,
    _title = "PANEL_GAMEOPTION_HDR_GAMMA_TITLE",
    _desc = "PANEL_GAMEOPTION_HDR_GAMMA"
  },
  HDRDisplayMaxNits = {
    _defaultValue = 0.5,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 500,
    _sliderValueMax = 10000,
    _settingRightNow = true,
    _title = "PANEL_GAMEOPTION_HDR_NITS_TITLE",
    _desc = "PANEL_GAMEOPTION_HDR_BRIGHT"
  },
  UltraHighDefinition = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _settingRightNow = true,
    _title = "PANEL_GAMEOPTION_4K_TITLE",
    _desc = "PANEL_GAMEOPTION_4K_DESC"
  },
  MouseInvertX = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  MouseInvertY = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  MouseSensitivityX = {
    _defaultValue = 0.473684,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _title = "",
    _desc = ""
  },
  MouseSensitivityY = {
    _defaultValue = 0.473684,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _title = "",
    _desc = ""
  },
  GameMouseMode = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  IsUIModeMouseLock = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  GamePadEnable = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_GamePadEnable",
    _desc = "PANEL_NEWGAMEOPTION_INTERFACE_PAD_GamePadEnable_DESC"
  },
  UseGamePadQuickTurn = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_QUICKTURNUSE",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_QUICKTURNUSEDESC"
  },
  GamePadVibration = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_GamePadVibration",
    _desc = "PANEL_NEWGAMEOPTION_INTERFACE_PAD_GamePadVibration_DESC"
  },
  GamePadInvertX = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_GamePadInvertX",
    _desc = "PANEL_NEWGAMEOPTION_INTERFACE_PAD_GamePadInvertX_DESC"
  },
  GamePadInvertY = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_GamePadInvertY",
    _desc = "PANEL_NEWGAMEOPTION_INTERFACE_PAD_GamePadInvertY_DESC"
  },
  GamePadSensitivityX = {
    _defaultValue = 0.473684,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _title = "PANEL_NEWGAMEOPTION_INTERFACE_PAD_GamePadSensitivityX",
    _desc = ""
  },
  GamePadSensitivityY = {
    _defaultValue = 0.315789,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _title = "PANEL_NEWGAMEOPTION_INTERFACE_PAD_GamePadSensitivityY",
    _desc = ""
  },
  ConsolePadKeyType = {
    _defaultValue = 2,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "PANEL_NEWGAMEOPTION_PADCAMERATYPE",
    _desc = ""
  },
  ScreenShotQuality = {
    _defaultValue = 0,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  ScreenShotFormat = {
    _defaultValue = 1,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  WatermarkAlpha = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 20,
    _sliderValueMax = 100,
    _title = "",
    _desc = ""
  },
  WatermarkScale = {
    _defaultValue = 1,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  WatermarkPosition = {
    _defaultValue = 3,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  WatermarkService = {
    _defaultValue = 0,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  ScreenMode = {
    _defaultValue = 2,
    _isChangeDisplay = true,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  ScreenResolution = {
    _isChangeDisplay = true,
    _type = CONTROL.PA_UI_CONTROL_COMBOBOX,
    _comboBoxList = nil,
    _title = "",
    _desc = ""
  },
  CropModeEnable = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "",
    _desc = ""
  },
  CropModeScaleX = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 50,
    _sliderValueMax = 100,
    _title = "",
    _desc = ""
  },
  CropModeScaleY = {
    _defaultValue = 0.6,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 50,
    _sliderValueMax = 100,
    _title = "",
    _desc = ""
  },
  UIScale = {
    _defaultValue = 0.3333,
    _isChangeDisplay = true,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 50,
    _sliderValueMax = 200,
    _title = "",
    _desc = ""
  },
  GammaValue = {
    _defaultValue = 0.5,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 50,
    _sliderValueMax = 150,
    _settingRightNow = true,
    _title = "PANEL_NEWGAMEOPTION_GammaValue",
    _desc = "PANEL_GAMEOPTION_HDR_GAMMA"
  },
  ContrastValue = {
    _defaultValue = 0.7,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = -50,
    _sliderValueMax = 50,
    _settingRightNow = true,
    _title = "",
    _desc = ""
  },
  EffectAlpha = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 30,
    _sliderValueMax = 100,
    _title = "",
    _desc = ""
  },
  SkillPostEffect = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _title = "",
    _desc = ""
  },
  ColorBlind = {
    _defaultValue = 0,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  BlackSpiritNotice = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_BlackSpiritNotice",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_BlackSpiritNotice_DESC"
  },
  ShowCashAlert = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_ShowCashAlert",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_ShowCashAlert_DESC"
  },
  ShowGuildLoginMessage = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_ShowGuildLoginMessage",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_ShowGuildLoginMessage_DESC"
  },
  EnableMusic = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _settingRightNow = true,
    _title = "",
    _desc = ""
  },
  EnableSound = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _settingRightNow = true,
    _title = "",
    _desc = ""
  },
  EnableEnv = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _settingRightNow = true,
    _title = "",
    _desc = ""
  },
  EnableRidingSound = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _settingRightNow = true,
    _title = "",
    _desc = ""
  },
  EnableWhisperMusic = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _settingRightNow = true,
    _title = "",
    _desc = ""
  },
  EnableTraySoundOnOff = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _settingRightNow = true,
    _title = "",
    _desc = ""
  },
  BattleSoundType = {
    _defaultValue = false,
    _type = OPTION_TYPE.CHECKBUTTON,
    _settingRightNow = true,
    _title = "PANEL_NEWGAMEOPTION_BattleSoundType",
    _desc = ""
  },
  EnableAudioFairy = {
    _defaultValue = 1,
    _type = OPTION_TYPE.RADIOBUTTON,
    _title = "",
    _desc = ""
  },
  VolumeMaster = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _settingRightNow = true,
    _title = "PANEL_NEWGAMEOPTION_VolumeMaster",
    _desc = "PANEL_NEWGAMEOPTION_SOUND_VOLUME_VolumeMaster_DESC"
  },
  VolumeMusic = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _settingRightNow = true,
    _title = "PANEL_NEWGAMEOPTION_VolumeMusic",
    _desc = "PANEL_NEWGAMEOPTION_SOUND_VOLUME_VolumeMusic_DESC"
  },
  VolumeFx = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _settingRightNow = true,
    _title = "PANEL_NEWGAMEOPTION_VolumeFx",
    _desc = "PANEL_NEWGAMEOPTION_SOUND_VOLUME_VolumeFx_DESC"
  },
  VolumeEnv = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _settingRightNow = true,
    _title = "PANEL_NEWGAMEOPTION_VolumeEnv",
    _desc = "PANEL_NEWGAMEOPTION_SOUND_VOLUME_VolumeEnv_DESC"
  },
  VolumeDlg = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _settingRightNow = true,
    _title = "PANEL_NEWGAMEOPTION_VolumeDlg",
    _desc = "PANEL_NEWGAMEOPTION_SOUND_VOLUME_VolumeDlg_DESC"
  },
  VolumeHitFxVolume = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _settingRightNow = true,
    _title = "PANEL_NEWGAMEOPTION_VolumeHitFxVolume",
    _desc = "PANEL_NEWGAMEOPTION_SOUND_VOLUME_VolumeHitFxVolume_DESC"
  },
  VolumeHitFxWeight = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _settingRightNow = true,
    _title = "PANEL_NEWGAMEOPTION_VolumeHitFxWeight",
    _desc = "PANEL_NEWGAMEOPTION_SOUND_VOLUME_VolumeHitFxWeight_DESC"
  },
  VolumeOtherPlayer = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _settingRightNow = true,
    _title = "PANEL_NEWGAMEOPTION_VolumeOtherPlayer",
    _desc = "PANEL_NEWGAMEOPTION_SOUND_VOLUME_VolumeOtherPlayer_DESC"
  },
  VolumeFairy = {
    _defaultValue = 0.5,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 0,
    _sliderValueMax = 100,
    _settingRightNow = true,
    _title = "",
    _desc = ""
  },
  AlertNormalTrade = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AlertNormalTrade",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_AlertNormalTrade_DESC"
  },
  AlertRoyalTrade = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AlertRoyalTrade",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_AlertRoyalTrade_DESC"
  },
  AlertOtherPlayerGetItem = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AlertOtherPlayerGetItem_XBOX_Title",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_AlertOtherPlayerGetItem_XBOX_DESC"
  },
  AlertLifeLevelUp = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AlertLifeLevelUp",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_AlertLifeLevelUp_DESC"
  },
  AlertItemMarket = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AlertItemMarket",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_AlertItemMarket_DESC"
  },
  AlertOtherMarket = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AlertOtherMarket",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_AlertOtherMarket_DESC"
  },
  AlertChangeRegion = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AlertChangeRegion",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_AlertChangeRegion_DESC"
  },
  AlertFitnessLevelUp = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AlertFitnessLevelUp",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_AlertFitnessLevelUp_DESC"
  },
  AlertTerritoryWar = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AlertTerritoryWar",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_AlertTerritoryWar_DESC"
  },
  AlertGuildWar = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AlertGuildWar",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_AlertGuildWar_DESC"
  },
  AlertEnchantSuccess = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AlertEnchantSuccess",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_AlertEnchantSuccess_DESC"
  },
  AlertEnchantFail = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AlertEnchantFail",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_AlertEnchantFail_DESC"
  },
  AlertGuildQuestMessage = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AlertGuildQuestMessage",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_AlertGuildQuestMessage_DESC"
  },
  AlertNearMonster = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AlertNearMonster",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ALERT_AlertNearMonster_DESC"
  },
  AutoRunCamera = {
    _defaultValue = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "PANEL_NEWGAMEOPTION_AutoRunCamera",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ETC_AutoRunCamera_DESC"
  },
  AutoRunCameraRotation = {
    _defaultValue = 1,
    _type = OPTION_TYPE.SLIDER,
    _sliderValueMin = 10,
    _sliderValueMax = 30,
    _title = "PANEL_NEWGAMEOPTION_AutoRunCameraRotation",
    _desc = "PANEL_NEWGAMEOPTION_FUNCTION_ETC_AutoRunCameraRotation_DESC"
  },
  KeyCustomMode = {
    _defaultValue = 0,
    _type = OPTION_TYPE.RADIOBUTTON,
    _settingRightNow = true,
    _title = "",
    _desc = ""
  },
  PadFunction1 = {
    actionInputType = "PadFunction1",
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  PadFunction2 = {
    actionInputType = "PadFunction2",
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionMoveFront = {
    actionInputType = 0,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionMoveBack = {
    actionInputType = 1,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionMoveLeft = {
    actionInputType = 2,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionMoveRight = {
    actionInputType = 3,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionAttack1 = {
    actionInputType = 4,
    _type = OPTION_TYPE.KEYCUSTOMIZE,
    _title = "PANEL_NEWGAMEOPTION_INTERFACE_ACTION_Mouse_LB_2"
  },
  ActionAttack2 = {
    actionInputType = 5,
    _type = OPTION_TYPE.KEYCUSTOMIZE,
    _title = "PANEL_NEWGAMEOPTION_INTERFACE_ACTION_Mouse_RB_2"
  },
  ActionDash = {
    actionInputType = 6,
    _type = OPTION_TYPE.KEYCUSTOMIZE,
    _title = "PANEL_NEWGAMEOPTION_INTERFACE_ACTION_Shift_1"
  },
  ActionJump = {
    actionInputType = 7,
    _type = OPTION_TYPE.KEYCUSTOMIZE,
    _title = "PANEL_NEWGAMEOPTION_ActionJump"
  },
  ActionInteraction = {
    actionInputType = 8,
    _type = OPTION_TYPE.KEYCUSTOMIZE,
    _title = "PANEL_NEWGAMEOPTION_ActionInteraction"
  },
  ActionAutoRun = {
    actionInputType = 9,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionWeaponInOut = {
    actionInputType = 10,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionCameraReset = {
    actionInputType = 11,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionCrouchOrSkill = {
    actionInputType = 12,
    _type = OPTION_TYPE.KEYCUSTOMIZE,
    _title = "PANEL_NEWGAMEOPTION_ActionCrouchOrSkill"
  },
  ActionGrabOrGuard = {
    actionInputType = 13,
    _type = OPTION_TYPE.KEYCUSTOMIZE,
    _title = "PANEL_NEWGAMEOPTION_ActionGrabOrGuard"
  },
  ActionKick = {
    actionInputType = 14,
    _type = OPTION_TYPE.KEYCUSTOMIZE,
    _title = "PANEL_NEWGAMEOPTION_ActionKick"
  },
  ActionServantOrder1 = {
    actionInputType = 15,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionServantOrder2 = {
    actionInputType = 16,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionServantOrder3 = {
    actionInputType = 17,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionServantOrder4 = {
    actionInputType = 18,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot1 = {
    actionInputType = 19,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot2 = {
    actionInputType = 20,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot3 = {
    actionInputType = 21,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot4 = {
    actionInputType = 22,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot5 = {
    actionInputType = 23,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot6 = {
    actionInputType = 24,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot7 = {
    actionInputType = 25,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot8 = {
    actionInputType = 26,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot9 = {
    actionInputType = 27,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot10 = {
    actionInputType = 28,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot11 = {
    actionInputType = 29,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot12 = {
    actionInputType = 30,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot13 = {
    actionInputType = 31,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot14 = {
    actionInputType = 32,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot15 = {
    actionInputType = 33,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot16 = {
    actionInputType = 34,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot17 = {
    actionInputType = 35,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot18 = {
    actionInputType = 36,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot19 = {
    actionInputType = 37,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionQuickSlot20 = {
    actionInputType = 38,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionComplicated0 = {
    actionInputType = 39,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionComplicated1 = {
    actionInputType = 40,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionComplicated2 = {
    actionInputType = 41,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionComplicated3 = {
    actionInputType = 42,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionAutoMoveWalkMode = {
    actionInputType = 43,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionCameraUp = {
    actionInputType = 44,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionCameraDown = {
    actionInputType = 45,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionCameraLeft = {
    actionInputType = 46,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionCameraRight = {
    actionInputType = 47,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionCameraRotateGameMode = {
    actionInputType = 48,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionPushToTalk = {
    actionInputType = 49,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ActionWalkMode = {
    actionInputType = 50,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiCursorOnOff = {
    uiInputType = 0,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiHelp = {
    uiInputType = 1,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiMentalKnowledge = {
    uiInputType = 2,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiInventory = {
    uiInputType = 3,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiBlackSpirit = {
    uiInputType = 4,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiChat = {
    uiInputType = 5,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiPlayerInfo = {
    uiInputType = 6,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiSkill = {
    uiInputType = 7,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiWorldMap = {
    uiInputType = 8,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiDyeing = {
    uiInputType = 9,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiProductionNote = {
    uiInputType = 10,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiManufacture = {
    uiInputType = 11,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiGuild = {
    uiInputType = 12,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiMail = {
    uiInputType = 13,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiFriendList = {
    uiInputType = 14,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiPresent = {
    uiInputType = 15,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiQuestHistory = {
    uiInputType = 16,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiCashShop = {
    uiInputType = 18,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiBeautyShop = {
    uiInputType = 19,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiAlchemyStone = {
    uiInputType = 20,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiHouse = {
    uiInputType = 21,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiWorker = {
    uiInputType = 22,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiPet = {
    uiInputType = 23,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiMaid = {
    uiInputType = 24,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiServant = {
    uiInputType = 25,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiGuildServant = {
    uiInputType = 26,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiDeleteNavigation = {
    uiInputType = 27,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiCameraSpeedUp = {
    uiInputType = 28,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiCameraSpeedDown = {
    uiInputType = 29,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiPositionNotify = {
    uiInputType = 30,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiInteraction1 = {
    uiInputType = 31,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiInteraction2 = {
    uiInputType = 32,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiInteraction3 = {
    uiInputType = 33,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiInteraction4 = {
    uiInputType = 34,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiInteraction5 = {
    uiInputType = 35,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiChatTabPrev = {
    uiInputType = 36,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  UiChatTabNext = {
    uiInputType = 37,
    _type = OPTION_TYPE.KEYCUSTOMIZE
  },
  ChatFilterNotice = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_NOTICE_TITLE",
    _desc = "LUA_CHATOPTION_TOOLTIP_NOTICE_DESC"
  },
  ChatFilterWorld = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_WORLD_TITLE",
    _desc = "LUA_CHATOPTION_TOOLTIP_WORLD_DESC"
  },
  ChatFilterPublic = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_NORMAL_TITLE",
    _desc = "LUA_CHATOPTION_TOOLTIP_NORMAL_DESC"
  },
  ChatFilterWhisper = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_WHISPER_TITLE",
    _desc = "LUA_CHATOPTION_TOOLTIP_WHISPER_DESC"
  },
  ChatFilterParty = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_PARTY_TITLE",
    _desc = "LUA_CHATOPTION_TOOLTIP_PARTY_DESC"
  },
  ChatFilterGuild = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_GUILD_TITLE",
    _desc = "LUA_CHATOPTION_TOOLTIP_GUILD_DESC"
  },
  ChatFilterServer = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_SERVER_TITLE",
    _desc = "LUA_CHATOPTION_TOOLTIP_SERVER_DESC"
  },
  ChatFilterBattle = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_COMBAT_TITLE",
    _desc = "LUA_CHATOPTION_TOOLTIP_COMBAT_DESC"
  },
  ChatFilterTeam = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_TEAM_TITLE",
    _desc = "LUA_CHATOPTION_TOOLTIP_TEAM_DESC"
  },
  ChatFilterSystemAll = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_SYSTEM_TITLE",
    _desc = "LUA_CHATOPTION_TOOLTIP_SYSTEM_NORMAL_DESC"
  },
  ChatFilterSystemPrivateItem = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_SYSTEM_PERSONITEM_TITLE",
    _isSystemChat = true,
    _desc = "LUA_CHATOPTION_TOOLTIP_SYSTEM_PERSONITEM_DESC"
  },
  ChatFilterSystemPartyItem = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_SYSTEM_PARTYITEM_TITLE",
    _isSystemChat = true,
    _desc = "LUA_CHATOPTION_TOOLTIP_SYSTEM_PARTYITEM_DESC"
  },
  ChatFilterSystemMarket = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_SYSTEM_ITEMMARKET_TITLE",
    _isSystemChat = true,
    _desc = "LUA_CHATOPTION_TOOLTIP_SYSTEM_ITEMMARKET_DESC"
  },
  ChatFilterSystemWorker = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_SYSTEM_WORKER_TITLE",
    _isSystemChat = true,
    _desc = "LUA_CHATOPTION_TOOLTIP_SYSTEM_WORKER_DESC"
  },
  ChatFilterSystemHarvest = {
    _defaultValue = true,
    _settingRightNow = true,
    _type = OPTION_TYPE.CHECKBUTTON,
    _title = "LUA_CHATOPTION_TOOLTIP_SYSTEM_HARVEST_TITLE",
    _isSystemChat = true,
    _desc = "LUA_CHATOPTION_TOOLTIP_SYSTEM_HARVEST_DESC"
  }
}
PaGlobal_Option._frames = {
  Performance = {
    Optimize = {
      {
        _element = PaGlobal_Option._elements.UsePlayerEffectDistOptimization
      },
      {
        _element = PaGlobal_Option._elements.PlayerEffectDistOptimization
      },
      {
        _element = PaGlobal_Option._elements.UseOtherPlayerUpdate
      }
    },
    OptimizeBeta = {},
    GraphicQuality = {},
    Camera = {},
    Npc = {}
  },
  Graphic = {
    Window = {},
    Quality = {},
    Effect = {
      {
        _element = PaGlobal_Option._elements.GammaValue,
        _contentsOption = not getHdrDiplayEnable()
      }
    },
    Camera = {},
    ScreenShot = {},
    HDR = {
      {
        _element = PaGlobal_Option._elements.HDRDisplayGamma,
        _contentsOption = getHdrDiplayEnable()
      },
      {
        _element = PaGlobal_Option._elements.HDRDisplayMaxNits,
        _contentsOption = getHdrDiplayEnable()
      },
      {
        _element = PaGlobal_Option._elements.UltraHighDefinition,
        _contentsOption = isXBoxDevice_X()
      }
    }
  },
  Sound = {
    OnOff = {},
    Volume = {
      {
        _element = PaGlobal_Option._elements.VolumeMaster
      },
      {
        _element = PaGlobal_Option._elements.VolumeMusic
      },
      {
        _element = PaGlobal_Option._elements.VolumeFx
      },
      {
        _element = PaGlobal_Option._elements.VolumeEnv
      },
      {
        _element = PaGlobal_Option._elements.VolumeDlg
      },
      {
        _element = PaGlobal_Option._elements.BattleSoundType
      }
    }
  },
  Function = {
    Convenience = {},
    View = {},
    Alert = {
      {
        _element = PaGlobal_Option._elements.AlertItemMarket
      },
      {
        _element = PaGlobal_Option._elements.AlertEnchantSuccess
      },
      {
        _element = PaGlobal_Option._elements.AlertEnchantFail
      },
      {
        _element = PaGlobal_Option._elements.AlertGuildQuestMessage
      }
    },
    Worldmap = {},
    Nation = {},
    Etc = {
      {
        _element = PaGlobal_Option._elements.CameraEffectMaster
      },
      {
        _element = PaGlobal_Option._elements.ShowNavPathEffectType
      },
      {
        _element = PaGlobal_Option._elements.RefuseRequests
      },
      {
        _element = PaGlobal_Option._elements.IsPvpRefuse
      },
      {
        _element = PaGlobal_Option._elements.IsExchangeRefuse
      },
      {
        _element = PaGlobal_Option._elements.RotateRadarMode
      },
      {
        _element = PaGlobal_Option._elements.HideWindowByAttacked
      },
      {
        _element = PaGlobal_Option._elements.AutoRunCamera
      },
      {
        _element = PaGlobal_Option._elements.AutoRunCameraRotation
      },
      {
        _element = PaGlobal_Option._elements.ShowGuildLoginMessage
      }
    }
  },
  Interface = {
    ChattingFilter = {
      {
        _element = PaGlobal_Option._elements.ChatFilterNotice
      },
      {
        _element = PaGlobal_Option._elements.ChatFilterWorld
      },
      {
        _element = PaGlobal_Option._elements.ChatFilterPublic
      },
      {
        _element = PaGlobal_Option._elements.ChatFilterWhisper
      },
      {
        _element = PaGlobal_Option._elements.ChatFilterParty
      },
      {
        _element = PaGlobal_Option._elements.ChatFilterGuild
      },
      {
        _element = PaGlobal_Option._elements.ChatFilterServer
      },
      {
        _element = PaGlobal_Option._elements.ChatFilterBattle
      },
      {
        _element = PaGlobal_Option._elements.ChatFilterTeam
      },
      {
        _element = PaGlobal_Option._elements.ChatFilterSystemAll
      },
      {
        _element = PaGlobal_Option._elements.ChatFilterSystemPrivateItem
      },
      {
        _element = PaGlobal_Option._elements.ChatFilterSystemPartyItem
      },
      {
        _element = PaGlobal_Option._elements.ChatFilterSystemMarket
      },
      {
        _element = PaGlobal_Option._elements.ChatFilterSystemWorker
      },
      {
        _element = PaGlobal_Option._elements.ChatFilterSystemHarvest
      }
    },
    Action = {
      {
        _element = PaGlobal_Option._elements.ActionAttack1
      },
      {
        _element = PaGlobal_Option._elements.ActionAttack2
      },
      {
        _element = PaGlobal_Option._elements.ActionDash
      },
      {
        _element = PaGlobal_Option._elements.ActionJump
      },
      {
        _element = PaGlobal_Option._elements.ActionInteraction
      },
      {
        _element = PaGlobal_Option._elements.ActionCrouchOrSkill
      },
      {
        _element = PaGlobal_Option._elements.ActionGrabOrGuard
      },
      {
        _element = PaGlobal_Option._elements.ActionKick
      }
    },
    UI = {},
    QuickSlot = {},
    Function = {},
    Mouse = {},
    Pad = {
      {
        _element = PaGlobal_Option._elements.GamePadVibration
      },
      {
        _element = PaGlobal_Option._elements.UseGamePadQuickTurn
      },
      {
        _element = PaGlobal_Option._elements.GamePadInvertX
      },
      {
        _element = PaGlobal_Option._elements.GamePadInvertY
      },
      {
        _element = PaGlobal_Option._elements.GamePadSensitivityX
      },
      {
        _element = PaGlobal_Option._elements.GamePadSensitivityY
      },
      {
        _element = PaGlobal_Option._elements.ConsolePadKeyType
      }
    }
  }
}
if true == ToClient_isConsole() then
  PaGlobal_Option._elements.TextureQuality._defaultValue = 0
  PaGlobal_Option._elements.ConsolePadKeyType._defaultValue = 2
end
isChecked_SkillCommand = true
function PaGlobal_Option:Get(optionName)
  local option = self._elements[optionName]
  if nil == option then
    return false
  end
  local value = option._initValue
  if nil ~= option._applyValue then
    value = option._applyValue
  end
  if nil == value then
    _PA_LOG("\237\155\132\236\167\132", "[GameOption][GET] \234\176\146\236\157\132 \236\150\187\236\150\180 \236\152\164\235\138\148\235\141\176 \236\139\164\237\140\168\237\150\136\236\138\181\235\139\136\235\139\164.  Name : " .. optionName)
  end
  return value
end
function PaGlobal_Option._elements.AimAssist:set(value)
  setAimAssist(value)
end
function PaGlobal_Option._elements.UseNewQuickSlot:set(value)
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eNewQuickSlot, value, CppEnums.VariableStorageType.eVariableStorageType_User)
end
function PaGlobal_Option._elements.EnableSimpleUI:set(value)
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer then
    if 5 < selfPlayer:get():getLevel() then
      setEnableSimpleUI(value)
    else
      setEnableSimpleUI(false)
    end
  else
    setEnableSimpleUI(false)
  end
end
function PaGlobal_Option._elements.IsOnScreenSaver:set(value)
  setIsOnScreenSaver(value)
end
function PaGlobal_Option._elements.UIFontSizeType:set(value)
  setUIFontSizeType(value)
  local addFontSize = convertUIFontTypeToUIFontSize(value)
  ToClient_getFontWrapper("BaseFont_10"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_Glow"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_10_Bold"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_10_Normal"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_10_Line"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_10_Glow"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_8"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_8_Bold"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_8_Line"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_8_Glow"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_7_Bold"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_6"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_12"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_12_Yellow"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_12_Bold"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_12_Glow"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_14_Bold"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("SubTitleFont_14"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("SubTitleFont_14_Bold"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("SubTitleFont_14_Glow"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("TitleFont_18"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_18_Glow"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("TitleFont_22"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_22_Glow"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("HeaderFont_26"):changeCurrentFontSizeBeMore(addFontSize)
  ToClient_getFontWrapper("BaseFont_26_Glow"):changeCurrentFontSizeBeMore(addFontSize)
end
function PaGlobal_Option._elements.ShowNavPathEffectType:set(value)
  setShowNavPathEffectType(value)
end
function PaGlobal_Option._elements.RefuseRequests:set(value)
  setRefuseRequests(value)
end
function PaGlobal_Option._elements.IsPvpRefuse:set(value)
  setIsPvpRefuse(value)
end
function PaGlobal_Option._elements.IsExchangeRefuse:set(value)
  setIsExchangeRefuse(value)
end
function PaGlobal_Option._elements.RotateRadarMode:set(value)
  setRotateRadarMode(value)
end
function PaGlobal_Option._elements.HideWindowByAttacked:set(value)
  setHideWindowByAttacked(value)
end
function PaGlobal_Option._elements.AutoRunCamera:set(value)
  setAutoRunCamera(value)
end
function PaGlobal_Option._elements.AutoRunCameraRotation:set(value)
  setAutoRunCameraRotation(value)
end
function PaGlobal_Option._elements.AudioResourceType:set(value)
  setAudioResourceType(PaGlobal_Option:radioButtonMapping_AudioResourceType(value))
end
function PaGlobal_Option._elements.ServiceResourceType:set(value)
  if false == ToClient_isAvailableChangeServiceType() then
    return
  end
  ToClient_saveServiceResourceType(PaGlobal_Option:radioButtonMapping_ServiceResourceType(value))
end
function PaGlobal_Option._elements.UseChattingFilter:set(value)
  setUseChattingFilter(value)
end
function PaGlobal_Option._elements.ChatChannelType:set(value)
  if false == ToClient_isAvailableChangeServiceType() then
    return
  end
  local chatType = PaGlobal_Option:radioButtonMapping_ChatChannelType(value)
  ToClient_saveChatChannelType(chatType)
  if CppEnums.LangType.LangType_AE == chatType then
    ToClient_setUseHarfBuzz(true)
    if nil ~= FGlobal_ChattingcheckArabicType then
      FGlobal_ChattingcheckArabicType(true)
    end
  else
    ToClient_setUseHarfBuzz(false)
    if nil ~= FGlobal_ChattingcheckArabicType then
      FGlobal_ChattingcheckArabicType(false)
    end
  end
end
function PaGlobal_Option._elements.SelfPlayerNameTagVisible:set(value)
  setSelfPlayerNameTagVisible(value)
end
function PaGlobal_Option._elements.OtherPlayerNameTagVisible:set(value)
  if true == value then
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow
  else
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_ImportantShow
  end
  setOtherPlayerNameTagVisible(value)
end
function PaGlobal_Option._elements.PartyPlayerNameTagVisible:set(value)
  if true == value then
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow
  else
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_ImportantShow
  end
  setPartyPlayerNameTagVisible(value)
end
function PaGlobal_Option._elements.GuildPlayerNameTagVisible:set(value)
  if true == value then
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow
  else
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_ImportantShow
  end
  setGuildPlayerNameTagVisible(value)
end
function PaGlobal_Option._elements.RankingPlayerNameTagVisible:set(value)
  if true == value then
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow
  else
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_NoShow
  end
  setRankingPlayerNameTagVisible(value)
end
function PaGlobal_Option._elements.GuideLineZoneChange:set(value)
  setRenderPlayerColor("ZoneChange", value)
end
function PaGlobal_Option._elements.GuideLineQuestNPC:set(value)
  setShowQuestActorColor(value)
end
function PaGlobal_Option._elements.GuideLineNpcIntimacy:set(value)
  setShowHumanRelation(value)
end
function PaGlobal_Option._elements.GuideLineWarAlly:set(value)
  setRenderPlayerColor("WarAlly", value)
end
function PaGlobal_Option._elements.GuideLineNonWarPlayer:set(value)
  setRenderPlayerColor("NonWarPlayer", value)
end
function PaGlobal_Option._elements.GuideLineEnemy:set(value)
  setRenderPlayerColor("Enemy", value)
end
function PaGlobal_Option._elements.GuideLineGuild:set(value)
  setRenderPlayerColor("Guild", value)
end
function PaGlobal_Option._elements.GuideLineParty:set(value)
  setRenderPlayerColor("Party", value)
end
function PaGlobal_Option._elements.GuideLinePartyMemberEffect:set(value)
  ToClient_getGameOptionControllerWrapper():setRenderHitEffectParty(value)
end
function PaGlobal_Option._elements.PetRender:set(value)
  setPetRender(value)
end
function PaGlobal_Option._elements.FairyRender:set(value)
  setFairyRender(value)
end
function PaGlobal_Option._elements.MaidView:set(value)
  local maidViewElement = PaGlobal_Option._elements.MaidView
  local maxMaidValue = maidViewElement._sliderValueMax
  setMaidView(value * maxMaidValue)
end
function PaGlobal_Option._elements.ShowReputation:set(value)
  return setShowStatTier(value)
end
function PaGlobal_Option._elements.RenderHitEffect:set(value)
  setRenderHitEffect(value)
end
function PaGlobal_Option._elements.DamageMeter:set(value)
  setOnDamageMeter(value)
end
function PaGlobal_Option._elements.ShowComboGuide:set(value)
  setShowComboGuide(value)
  if nil ~= Panel_MovieTheater_320 then
    Panel_MovieTheater320_JustClose()
  end
end
function PaGlobal_Option._elements.HideMastOnCarrier:set(value)
  setHideMastOnCarrier(value)
end
function PaGlobal_Option._elements.WorkerVisible:set(value)
  ToClient_setWorkerVisible(value)
end
function PaGlobal_Option._elements.WorldMapOpenType:set(value)
  setWorldmapOpenType(value)
end
function PaGlobal_Option._elements.WorldmapCameraPitchType:set(value)
  setWorldMapCameraPitchType(value)
end
function PaGlobal_Option._elements.TextureQuality:set(value)
  setTextureQuality(PaGlobal_Option:radioButtonMapping_TextureQuality(value))
end
function PaGlobal_Option._elements.GraphicOption:set(value)
  setGraphicOption(PaGlobal_Option:radioButtonMapping_GraphicOption(value))
end
function PaGlobal_Option._elements.AntiAliasing:set(value)
  setAntiAliasing(value)
end
function PaGlobal_Option._elements.SSAO:set(value)
  setSSAO(value)
end
function PaGlobal_Option._elements.PostFilter:set(value)
  if true == value then
    setPostFilter(2)
  else
    setPostFilter(1)
  end
end
function PaGlobal_Option._elements.Tessellation:set(value)
  setTessellation(value)
end
function PaGlobal_Option._elements.Dof:set(value)
  setDof(value)
end
function PaGlobal_Option._elements.Representative:set(value)
  setRepresentative(value)
end
function PaGlobal_Option._elements.CharacterEffect:set(value)
  setCharacterEffect(value)
end
function PaGlobal_Option._elements.SnowPoolOnlyInSafeZone:set(value)
  setSnowPoolOnlyInSafeZone(value)
end
function PaGlobal_Option._elements.BloodEffect:set(value)
  if true == value then
    setBloodEffect(2)
  else
    setBloodEffect(0)
  end
end
function PaGlobal_Option._elements.LensBlood:set(value)
  setLensBlood(value)
end
function PaGlobal_Option._elements.AutoOptimization:set(value)
  setAutoOptimization(value)
end
function PaGlobal_Option._elements.AutoOptimizationFrameLimit:set(value)
  local convertedFrame = math.ceil(value * 60)
  local autoOptimization = PaGlobal_Option._elements.AutoOptimization
  local check = autoOptimization._initValue
  if nil ~= autoOptimization._curValue then
    check = autoOptimization._curValue
  elseif nil ~= autoOptimization._applyValue then
    check = autoOptimization._applyValue
  end
  if true == check then
    setAutoOptimizationFrameLimit(convertedFrame)
  end
end
function PaGlobal_Option._elements.UpscaleEnable:set(value)
  setUpscaleEnable(value)
end
function PaGlobal_Option._elements.PresentLock:set(value)
  setPresentLock(value)
end
function PaGlobal_Option._elements.UseEffectFrameOptimization:set(value)
  setUseOptimizationEffectFrame(value)
end
function PaGlobal_Option._elements.EffectFrameOptimization:set(value)
  local convertedFrame = value * 24.9 + 0.1
  local useEffectFrameOptimization = PaGlobal_Option._elements.UseEffectFrameOptimization
  local check = useEffectFrameOptimization._initValue
  if nil ~= useEffectFrameOptimization._curValue then
    check = useEffectFrameOptimization._curValue
  elseif nil ~= useEffectFrameOptimization._applyValue then
    check = useEffectFrameOptimization._applyValue
  end
  if true == check then
    setEffectFrameEffectOptimization(convertedFrame)
  end
end
function PaGlobal_Option._elements.UsePlayerEffectDistOptimization:set(value)
  setUsePlayerOptimizationEffectFrame(value)
end
function PaGlobal_Option._elements.PlayerEffectDistOptimization:set(value)
  local convertedFrame = value * 40 + 10
  local usePlayerEffectDistOptimization = PaGlobal_Option._elements.UsePlayerEffectDistOptimization
  local check = usePlayerEffectDistOptimization._initValue
  if nil ~= usePlayerEffectDistOptimization._curValue then
    check = usePlayerEffectDistOptimization._curValue
  elseif nil ~= usePlayerEffectDistOptimization._applyValue then
    check = usePlayerEffectDistOptimization._applyValue
  end
  if true == check then
    setPlayerEffectFrameEffectOptimization(convertedFrame * 100)
  end
end
function PaGlobal_Option._elements.UseCharacterUpdateFrameOptimize:set(value)
  setUseCharacterDistUpdate(value)
end
function PaGlobal_Option._elements.UseOtherPlayerUpdate:set(value)
  FromClient_OtherPlayeUpdate(value, true)
end
function PaGlobal_Option._elements.Fov:set(value)
  value = value * 30 + 40
  setFov(value)
end
function PaGlobal_Option._elements.CameraEffectMaster:set(value)
  setCameraMasterPower(value)
end
function PaGlobal_Option._elements.CameraShakePower:set(value)
  setCameraShakePower(value)
end
function PaGlobal_Option._elements.MotionBlurPower:set(value)
  setMotionBlurPower(value)
end
function PaGlobal_Option._elements.CameraTranslatePower:set(value)
  setCameraTranslatePower(value)
end
function PaGlobal_Option._elements.CameraFovPower:set(value)
  setCameraFovPower(value)
end
function PaGlobal_Option._elements.MouseInvertX:set(value)
  setMouseInvertX(value)
end
function PaGlobal_Option._elements.MouseInvertY:set(value)
  setMouseInvertY(value)
end
function PaGlobal_Option._elements.MouseSensitivityX:set(value)
  local convertedValue = value * 1.9 + 0.1
  setMouseSensitivityX(convertedValue)
end
function PaGlobal_Option._elements.MouseSensitivityY:set(value)
  local convertedValue = value * 1.9 + 0.1
  setMouseSensitivityY(convertedValue)
end
function PaGlobal_Option._elements.GameMouseMode:set(value)
  setGameMouseMode(value)
end
function PaGlobal_Option._elements.IsUIModeMouseLock:set(value)
  setIsUIModeMouseLock(value)
end
function PaGlobal_Option._elements.GamePadEnable:set(value)
  setGamePadEnable(value)
end
function PaGlobal_Option._elements.GamePadVibration:set(value)
  setGamePadVibration(value)
end
function PaGlobal_Option._elements.GamePadInvertX:set(value)
  setGamePadInvertX(value)
end
function PaGlobal_Option._elements.GamePadInvertY:set(value)
  setGamePadInvertY(value)
end
function PaGlobal_Option._elements.GamePadSensitivityX:set(value)
  local convertedValue = value * 1.9 + 0.1
  setGamePadSensitivityX(convertedValue)
end
function PaGlobal_Option._elements.GamePadSensitivityY:set(value)
  local convertedValue = value * 1.9 + 0.1
  setGamePadSensitivityY(convertedValue)
end
function PaGlobal_Option._elements.ConsolePadKeyType:set(value)
  if true == _ContentsGroup_isConsoleTest then
    if 0 == value then
      setConsoleKeyType(1)
    elseif 1 == value then
      setConsoleKeyType(2)
    else
      _PA_LOG("\236\162\133\237\152\132", "\236\158\152\235\170\187\235\144\156 \236\152\181\236\133\152 value \236\158\133\235\139\136\235\139\164!! : " .. tostring(value))
    end
  end
end
function PaGlobal_Option._elements.ScreenShotQuality:set(value)
  setScreenShotQuality(value)
end
function PaGlobal_Option._elements.ScreenShotFormat:set(value)
  setScreenShotFormat(value)
end
function PaGlobal_Option._elements.WatermarkAlpha:set(value)
  setWatermarkAlpha(value)
end
function PaGlobal_Option._elements.WatermarkScale:set(value)
  setWatermarkScale(value)
end
function PaGlobal_Option._elements.WatermarkPosition:set(value)
  setWatermarkPosition(value)
end
function PaGlobal_Option._elements.WatermarkService:set(value)
  setWatermarkService(value)
end
function PaGlobal_Option._elements.ScreenMode:set(value)
  setScreenMode(value)
  ischangedeplay = true
end
function PaGlobal_Option._elements.ScreenResolution:set(value)
  local width = 1280
  local height = 720
  if -1 == value then
    width = PaGlobal_Option._userInitScreenResolution.width
    height = PaGlobal_Option._userInitScreenResolution.height
  else
    width = PaGlobal_Option._availableResolutionList:getDisplayModeWidth(value)
    height = PaGlobal_Option._availableResolutionList:getDisplayModeHeight(value)
  end
  setScreenResolution(width, height)
end
function PaGlobal_Option._elements.CropModeEnable:set(value)
  setCropModeEnable(value)
end
function PaGlobal_Option._elements.CropModeScaleX:set(value)
  local convertedScale = 0.5 + value * 0.5
  local cropModeEnable = PaGlobal_Option:Get("CropModeEnable")
  local cropModeScaleX = convertedScale
  local cropModeScaleY = PaGlobal_Option:Get("CropModeScaleY")
  if cropModeScaleX > 0.95 and cropModeScaleY > 0.95 and true == cropModeEnable then
    PaGlobal_Option:SetXXX("CropModeEnable", false)
  end
  if true == cropModeEnable then
    setCropModeScaleX(convertedScale)
  end
end
function PaGlobal_Option._elements.CropModeScaleY:set(value)
  local convertedScale = 0.5 + value * 0.5
  local cropModeEnable = PaGlobal_Option:Get("CropModeEnable")
  local cropModeScaleX = PaGlobal_Option:Get("CropModeScaleX")
  local cropModeScaleY = convertedScale
  if cropModeScaleX > 0.95 and cropModeScaleY > 0.95 and true == cropModeEnable then
    PaGlobal_Option:SetXXX("CropModeEnable", false)
  end
  if true == cropModeEnable then
    setCropModeScaleY(convertedScale)
  end
end
function PaGlobal_Option._elements.UIScale:set(value)
  local interval = PaGlobal_Option._elements.UIScale._sliderValueMax - PaGlobal_Option._elements.UIScale._sliderValueMin
  local convertedValue = (PaGlobal_Option._elements.UIScale._sliderValueMin + interval * value) * 0.01
  convertedValue = math.floor((convertedValue + 0.002) * 100) / 100
  setUIScale(convertedValue)
end
function PaGlobal_Option._elements.GammaValue:set(value)
  value = PaGlobal_Option:FromSliderValueToRealValue(value, PaGlobal_Option._elements.GammaValue._sliderValueMin, PaGlobal_Option._elements.GammaValue._sliderValueMax)
  value = value * 0.01
  setHdrDisplayGamma(value)
end
function PaGlobal_Option._elements.ContrastValue:set(value)
  setContrastValue(value)
end
function PaGlobal_Option._elements.EffectAlpha:set(value)
  value = PaGlobal_Option:FromSliderValueToRealValue(value, PaGlobal_Option._elements.EffectAlpha._sliderValueMin, PaGlobal_Option._elements.EffectAlpha._sliderValueMax)
  value = value * 0.01
  setEffectAlpha(value)
end
function PaGlobal_Option._elements.SkillPostEffect:set(value)
  setSkillPostEffect(value)
end
function PaGlobal_Option._elements.ColorBlind:set(value)
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eColorBlindMode, value, CppEnums.VariableStorageType.eVariableStorageType_User)
  ToClient_ChangeColorBlindMode(value)
  FGlobal_Radar_SetColorBlindMode()
  FGlobal_ChangeEffectCheck()
  FGlobal_Window_Servant_ColorBlindUpdate()
  UIMain_QuestUpdate()
end
function PaGlobal_Option._elements.BlackSpiritNotice:set(value)
  setBlackSpiritNotice(value)
end
function PaGlobal_Option._elements.ShowCashAlert:set(value)
  setShowCashAlert(not value)
end
function PaGlobal_Option._elements.ShowGuildLoginMessage:set(value)
  setShowGuildLoginMessage(value)
end
function PaGlobal_Option._elements.LUT:set(LUT)
  setCameraLUTFilter(LUT)
end
function PaGlobal_Option._elements.LUT:GetButtonText(LUT)
  local filterName = getCameraLUTFilterName(LUT)
  local filterString = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_PHOTOFILTER_" .. filterName)
  if filterName == LUTRecommandationName or filterName == LUTRecommandationName2 then
    filterString = filterString .. "  <PAColor0xffffce22>[" .. PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_RECOMMANDATION") .. "]<PAOldColor>"
  end
  return filterString
end
function PaGlobal_Option._elements.LUT:GetButtonListSize(value)
  return getCameraLUTFilterSize()
end
function PaGlobal_Option._elements.EnableMusic:set(value)
  setEnableSoundMusic(value)
end
function PaGlobal_Option._elements.EnableSound:set(value)
  setEnableSoundFx(value)
end
function PaGlobal_Option._elements.EnableEnv:set(value)
  setEnableSoundEnv(value)
end
function PaGlobal_Option._elements.EnableRidingSound:set(value)
  setEnableRidingSound(value)
end
function PaGlobal_Option._elements.EnableWhisperMusic:set(value)
  setEnableSoundWhisper(value)
end
function PaGlobal_Option._elements.EnableTraySoundOnOff:set(value)
  setEnableSoundTray(value)
end
function PaGlobal_Option._elements.BattleSoundType:set(value)
  if true == value then
    setEnableBattleSoundType(1)
  else
    setEnableBattleSoundType(0)
  end
end
function PaGlobal_Option._elements.EnableAudioFairy:set(value)
  setEnableFairySound(value)
end
function PaGlobal_Option._elements.VolumeMaster:set(value)
  setVolumeParamMaster(value * 100)
end
function PaGlobal_Option._elements.VolumeMusic:set(value)
  setVolumeParamMusic(value * 100)
end
function PaGlobal_Option._elements.VolumeFx:set(value)
  setVolumeParamFx(value * 100)
end
function PaGlobal_Option._elements.VolumeEnv:set(value)
  setVolumeParamEnv(value * 100)
end
function PaGlobal_Option._elements.VolumeDlg:set(value)
  setVolumeParamDialog(value * 100)
end
function PaGlobal_Option._elements.VolumeHitFxVolume:set(value)
  setVolumeParamHitFxVolume(value * 100)
end
function PaGlobal_Option._elements.VolumeHitFxWeight:set(value)
  setVolumeParamHitFxWeight(value * 100)
end
function PaGlobal_Option._elements.VolumeOtherPlayer:set(value)
  setVolumeParamOtherPlayer(value * 100)
end
function PaGlobal_Option._elements.VolumeFairy:set(value)
  setVolumeFairy(value * 100)
end
function PaGlobal_Option._elements.AlertNormalTrade:set(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.NormalTrade, not value)
end
function PaGlobal_Option._elements.AlertRoyalTrade:set(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.RoyalTrade, not value)
end
function PaGlobal_Option._elements.AlertOtherPlayerGetItem:set(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.OtherPlayerGetItem, not value)
end
function PaGlobal_Option._elements.AlertLifeLevelUp:set(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.LifeLevelUp, not value)
end
function PaGlobal_Option._elements.AlertItemMarket:set(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.ItemMarket, not value)
end
function PaGlobal_Option._elements.AlertOtherMarket:set(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.OtherMarket, not value)
end
function PaGlobal_Option._elements.AlertChangeRegion:set(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.ChangeRegion, not value)
end
function PaGlobal_Option._elements.AlertFitnessLevelUp:set(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.FitnessLevelUp, not value)
end
function PaGlobal_Option._elements.AlertTerritoryWar:set(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.TerritoryWar, not value)
end
function PaGlobal_Option._elements.AlertGuildWar:set(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.GuildWar, not value)
end
function PaGlobal_Option._elements.AlertEnchantSuccess:set(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.EnchantSuccess, not value)
end
function PaGlobal_Option._elements.AlertEnchantFail:set(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.EnchantFail, not value)
end
function PaGlobal_Option._elements.AlertGuildQuestMessage:set(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.GuildQuestMessage, not value)
end
function PaGlobal_Option._elements.AlertNearMonster:set(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.NearMonster, not value)
end
function PaGlobal_Option._elements.SelfPlayerOnlyEffect:set(value)
  setSelfPlayerOnlyEffect(value)
end
function PaGlobal_Option._elements.NearestPlayerOnlyEffect:set(value)
  setNearestPlayerOnlyEffect(value)
end
function PaGlobal_Option._elements.SelfPlayerOnlyLantern:set(value)
  setSelfPlayerOnlyLantern(value)
end
function PaGlobal_Option._elements.ShowStackHp:set(value)
  if true == _ContentsGroup_StackingHpBar then
    setShowStackHp(GameOptionApply_CharacterNameTag_StackHpBar(value))
  end
end
function ConsolePadType(value)
  selfPlayerSetConsolePadType(value)
end
function PaGlobal_Option._elements.HDRDisplayGamma:set(value)
  value = PaGlobal_Option:FromSliderValueToRealValue(value, PaGlobal_Option._elements.HDRDisplayGamma._sliderValueMin, PaGlobal_Option._elements.HDRDisplayGamma._sliderValueMax)
  value = value * 0.01
  setHdrDisplayGamma(value)
end
function PaGlobal_Option._elements.HDRDisplayMaxNits:set(value)
  value = PaGlobal_Option:FromSliderValueToRealValue(value, PaGlobal_Option._elements.HDRDisplayMaxNits._sliderValueMin, PaGlobal_Option._elements.HDRDisplayMaxNits._sliderValueMax)
  setHdrDisplayMaxNits(value)
end
function PaGlobal_Option._elements.UltraHighDefinition:set(value)
  _PA_LOG("\237\155\132\236\167\132", "UltraHighDefinition value : " .. tostring(value))
  local wrapper = ToClient_getGameOptionControllerWrapper()
  local currentMode = wrapper:getIsUHDMode()
  local rv = setUltraHighDefinition(value)
  if currentMode == value then
    return
  end
  if true == rv then
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = "When you restart the game, it changes to resolution.",
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  elseif true == value then
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = "The monitor does not support 4k resolution",
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
end
function PaGlobal_Option._elements.UseGamePadQuickTurn:set(value)
  setGamePadQuickTurn(value)
end
function PaGlobal_Option._elements.ChatFilterNotice:set(value)
  local chat = ToClient_getChattingPanel(0)
  chat:setShowChatType(CppEnums.ChatType.Notice, value)
end
function PaGlobal_Option._elements.ChatFilterWorld:set(value)
  local chat = ToClient_getChattingPanel(0)
  chat:setShowChatType(CppEnums.ChatType.WorldWithItem, value)
end
function PaGlobal_Option._elements.ChatFilterPublic:set(value)
  local chat = ToClient_getChattingPanel(0)
  chat:setShowChatType(CppEnums.ChatType.Public, value)
end
function PaGlobal_Option._elements.ChatFilterWhisper:set(value)
  local chat = ToClient_getChattingPanel(0)
  chat:setShowChatType(CppEnums.ChatType.Private, value)
end
function PaGlobal_Option._elements.ChatFilterParty:set(value)
  local chat = ToClient_getChattingPanel(0)
  chat:setShowChatType(CppEnums.ChatType.Party, value)
end
function PaGlobal_Option._elements.ChatFilterGuild:set(value)
  local chat = ToClient_getChattingPanel(0)
  chat:setShowChatType(CppEnums.ChatType.Guild, value)
end
function PaGlobal_Option._elements.ChatFilterServer:set(value)
  local chat = ToClient_getChattingPanel(0)
  chat:setShowChatType(CppEnums.ChatType.World, value)
end
function PaGlobal_Option._elements.ChatFilterBattle:set(value)
  local chat = ToClient_getChattingPanel(0)
  chat:setShowChatType(CppEnums.ChatType.Battle, value)
end
function PaGlobal_Option._elements.ChatFilterTeam:set(value)
  local chat = ToClient_getChattingPanel(0)
  chat:setShowChatType(CppEnums.ChatType.Team, value)
end
function PaGlobal_Option._elements.ChatFilterSystemAll:set(value)
  local chat = ToClient_getChattingPanel(0)
  chat:setShowChatType(CppEnums.ChatType.System, value)
end
function PaGlobal_Option._elements.ChatFilterSystemPrivateItem:set(value)
  local chat = ToClient_getChattingPanel(0)
  if true == chat:isShowChatType(CppEnums.ChatType.System) then
    chat:setShowChatSystemType(CppEnums.ChatSystemType.PrivateItem, value)
  end
end
function PaGlobal_Option._elements.ChatFilterSystemPartyItem:set(value)
  local chat = ToClient_getChattingPanel(0)
  if true == chat:isShowChatType(CppEnums.ChatType.System) then
    chat:setShowChatSystemType(CppEnums.ChatSystemType.PartyItem, value)
  end
end
function PaGlobal_Option._elements.ChatFilterSystemMarket:set(value)
  local chat = ToClient_getChattingPanel(0)
  if true == chat:isShowChatType(CppEnums.ChatType.System) then
    chat:setShowChatSystemType(CppEnums.ChatSystemType.Market, value)
  end
end
function PaGlobal_Option._elements.ChatFilterSystemWorker:set(value)
  local chat = ToClient_getChattingPanel(0)
  if true == chat:isShowChatType(CppEnums.ChatType.System) then
    chat:setShowChatSystemType(CppEnums.ChatSystemType.Worker, value)
  end
end
function PaGlobal_Option._elements.ChatFilterSystemHarvest:set(value)
  local chat = ToClient_getChattingPanel(0)
  if true == chat:isShowChatType(CppEnums.ChatType.System) then
    chat:setShowChatSystemType(CppEnums.ChatSystemType.Harvest, value)
  end
end
function PaGlobal_Option._elements.AimAssist:get(wrapper)
  return wrapper:getAimAssist()
end
function PaGlobal_Option._elements.UseNewQuickSlot:get(wrapper)
  return ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eNewQuickSlot)
end
function PaGlobal_Option._elements.EnableSimpleUI:get(wrapper)
  return wrapper:getEnableSimpleUI()
end
function PaGlobal_Option._elements.IsOnScreenSaver:get(wrapper)
  return wrapper:getEnableSimpleUI()
end
function PaGlobal_Option._elements.UIFontSizeType:get(wrapper)
  return wrapper:getUIFontSizeType()
end
function PaGlobal_Option._elements.ShowNavPathEffectType:get(wrapper)
  return wrapper:getShowNavPathEffectType()
end
function PaGlobal_Option._elements.RefuseRequests:get(wrapper)
  return wrapper:getRefuseRequests()
end
function PaGlobal_Option._elements.IsPvpRefuse:get(wrapper)
  return wrapper:getPvpRefuse()
end
function PaGlobal_Option._elements.IsExchangeRefuse:get(wrapper)
  return wrapper:getIsExchangeRefuse()
end
function PaGlobal_Option._elements.RotateRadarMode:get(wrapper)
  return wrapper:getRadarRotateMode()
end
function PaGlobal_Option._elements.HideWindowByAttacked:get(wrapper)
  return wrapper:getHideWindowByAttacked()
end
function PaGlobal_Option._elements.AutoRunCamera:get(wrapper)
  return wrapper:getAutoRunCamera()
end
function PaGlobal_Option._elements.AutoRunCameraRotation:get(wrapper)
  return wrapper:getAutoRunCameraRotation()
end
function PaGlobal_Option._elements.AudioResourceType:get(wrapper)
  return PaGlobal_Option:radioButtonMapping_AudioResourceType(wrapper:getAudioResourceType(), true)
end
function PaGlobal_Option._elements.ServiceResourceType:get(wrapper)
  return PaGlobal_Option:radioButtonMapping_ServiceResourceType(wrapper:getServiceResType(), true)
end
function PaGlobal_Option._elements.UseChattingFilter:get(wrapper)
  return wrapper:getUseChattingFilter()
end
function PaGlobal_Option._elements.ChatChannelType:get(wrapper)
  return PaGlobal_Option:radioButtonMapping_ChatChannelType(wrapper:getChatLanguageType(), true)
end
function PaGlobal_Option._elements.SelfPlayerNameTagVisible:get(wrapper)
  return wrapper:getSelfPlayerNameTagVisible()
end
function PaGlobal_Option._elements.OtherPlayerNameTagVisible:get(wrapper)
  return CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow == wrapper:getOtherPlayerNameTagVisible()
end
function PaGlobal_Option._elements.PartyPlayerNameTagVisible:get(wrapper)
  return CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow == wrapper:getPartyPlayerNameTagVisible()
end
function PaGlobal_Option._elements.GuildPlayerNameTagVisible:get(wrapper)
  return CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow == wrapper:getGuildPlayerNameTagVisible()
end
function PaGlobal_Option._elements.RankingPlayerNameTagVisible:get(wrapper)
  return CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow == wrapper:getRankingPlayerNameTagVisible()
end
function PaGlobal_Option._elements.GuideLineZoneChange:get(wrapper)
  return wrapper:getRenderPlayerColor("ZoneChange")
end
function PaGlobal_Option._elements.GuideLineQuestNPC:get(wrapper)
  return wrapper:getShowQuestActorColor()
end
function PaGlobal_Option._elements.GuideLineNpcIntimacy:get(wrapper)
  return wrapper:getShowHumanRelation()
end
function PaGlobal_Option._elements.GuideLineWarAlly:get(wrapper)
  return wrapper:getRenderPlayerColor("WarAlly")
end
function PaGlobal_Option._elements.GuideLineNonWarPlayer:get(wrapper)
  return wrapper:getRenderPlayerColor("NonWarPlayer")
end
function PaGlobal_Option._elements.GuideLineEnemy:get(wrapper)
  return wrapper:getRenderPlayerColor("Enemy")
end
function PaGlobal_Option._elements.GuideLineGuild:get(wrapper)
  return wrapper:getRenderPlayerColor("Guild")
end
function PaGlobal_Option._elements.GuideLineParty:get(wrapper)
  return wrapper:getRenderPlayerColor("Party")
end
function PaGlobal_Option._elements.GuideLinePartyMemberEffect:get(wrapper)
  return wrapper:getRenderHitEffectParty()
end
function PaGlobal_Option._elements.PetRender:get(wrapper)
  return wrapper:getPetRender()
end
function PaGlobal_Option._elements.FairyRender:get(wrapper)
  return wrapper:getFairyRender()
end
function PaGlobal_Option._elements.MaidView:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getMaidView(), 0, wrapper:getMaidMaxCount())
end
function PaGlobal_Option._elements.ShowReputation:get(wrapper)
  return wrapper:getShowStatTier()
end
function PaGlobal_Option._elements.RenderHitEffect:get(wrapper)
  return wrapper:getRenderHitEffect()
end
function PaGlobal_Option._elements.DamageMeter:get(wrapper)
  return wrapper:getOnDamageMeter()
end
function PaGlobal_Option._elements.ShowComboGuide:get(wrapper)
  return wrapper:getShowComboGuide()
end
function PaGlobal_Option._elements.HideMastOnCarrier:get(wrapper)
  return wrapper:getHideMastOnCarrier()
end
function PaGlobal_Option._elements.WorkerVisible:get(wrapper)
  return wrapper:getWorkerVisible()
end
function PaGlobal_Option._elements.WorldMapOpenType:get(wrapper)
  return wrapper:getWorldmapOpenType()
end
function PaGlobal_Option._elements.WorldmapCameraPitchType:get(wrapper)
  return wrapper:getWorldMapCameraPitchType()
end
function PaGlobal_Option._elements.TextureQuality:get(wrapper)
  return PaGlobal_Option:radioButtonMapping_TextureQuality(wrapper:getTextureQuality(), true)
end
function PaGlobal_Option._elements.GraphicOption:get(wrapper)
  return PaGlobal_Option:radioButtonMapping_GraphicOption(wrapper:getGraphicOption(), true)
end
function PaGlobal_Option._elements.AntiAliasing:get(wrapper)
  return wrapper:getAntiAliasing()
end
function PaGlobal_Option._elements.SSAO:get(wrapper)
  return wrapper:getSSAO()
end
function PaGlobal_Option._elements.PostFilter:get(wrapper)
  return wrapper:getPostFilter() == 2
end
function PaGlobal_Option._elements.Tessellation:get(wrapper)
  return wrapper:getTessellation()
end
function PaGlobal_Option._elements.Dof:get(wrapper)
  return wrapper:getDof()
end
function PaGlobal_Option._elements.Representative:get(wrapper)
  return wrapper:getRepresentative()
end
function PaGlobal_Option._elements.CharacterEffect:get(wrapper)
  return wrapper:getCharacterEffect()
end
function PaGlobal_Option._elements.SnowPoolOnlyInSafeZone:get(wrapper)
  return wrapper:getSnowPoolOnlyInSafeZone()
end
function PaGlobal_Option._elements.BloodEffect:get(wrapper)
  return wrapper:getBloodEffect() == 2
end
function PaGlobal_Option._elements.LensBlood:get(wrapper)
  return wrapper:getLensBlood()
end
function PaGlobal_Option._elements.AutoOptimization:get(wrapper)
  return wrapper:getAutoOptimization()
end
function PaGlobal_Option._elements.AutoOptimizationFrameLimit:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getAutoOptimizationFrameLimit(), 0, 60)
end
function PaGlobal_Option._elements.UpscaleEnable:get(wrapper)
  return wrapper:getUpscaleEnable()
end
function PaGlobal_Option._elements.PresentLock:get(wrapper)
  return wrapper:getPresentLock()
end
function PaGlobal_Option._elements.UseEffectFrameOptimization:get(wrapper)
  return wrapper:getUseOptimizationEffectFrame()
end
function PaGlobal_Option._elements.EffectFrameOptimization:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getEffectFrameEffectOptimization(), 0.1, 25)
end
function PaGlobal_Option._elements.UsePlayerEffectDistOptimization:get(wrapper)
  return wrapper:getUsePlayerOptimizationEffectFrame()
end
function PaGlobal_Option._elements.PlayerEffectDistOptimization:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getPlayerEffectFrameEffectOptimization() * 0.01, 10, 50)
end
function PaGlobal_Option._elements.UseCharacterUpdateFrameOptimize:get(wrapper)
  return wrapper:getUseCharacterDistUpdate()
end
function PaGlobal_Option._elements.UseOtherPlayerUpdate:get(wrapper)
  return true ~= wrapper:getUseOtherPlayerUpdate()
end
function PaGlobal_Option._elements.Fov:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getFov(), 40, 70)
end
function PaGlobal_Option._elements.CameraEffectMaster:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getCameraMasterPower(), 0, 1)
end
function PaGlobal_Option._elements.CameraShakePower:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getCameraShakePower(), 0, 1)
end
function PaGlobal_Option._elements.MotionBlurPower:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getMotionBlurPower(), 0, 1)
end
function PaGlobal_Option._elements.CameraTranslatePower:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getCameraTranslatePower(), 0, 1)
end
function PaGlobal_Option._elements.CameraFovPower:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getCameraFovPower(), 0, 1)
end
function PaGlobal_Option._elements.MouseInvertX:get(wrapper)
  return wrapper:getMouseInvertX()
end
function PaGlobal_Option._elements.MouseInvertY:get(wrapper)
  return wrapper:getMouseInvertY()
end
function PaGlobal_Option._elements.MouseSensitivityX:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getMouseSensitivityX(), 0.1, 2)
end
function PaGlobal_Option._elements.MouseSensitivityY:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getMouseSensitivityY(), 0.1, 2)
end
function PaGlobal_Option._elements.GameMouseMode:get(wrapper)
  return wrapper:getGameMouseMode()
end
function PaGlobal_Option._elements.IsUIModeMouseLock:get(wrapper)
  return wrapper:getUIModeMouseLock()
end
function PaGlobal_Option._elements.GamePadEnable:get(wrapper)
  return wrapper:getGamePadEnable()
end
function PaGlobal_Option._elements.GamePadVibration:get(wrapper)
  return wrapper:getGamePadVibration()
end
function PaGlobal_Option._elements.GamePadInvertX:get(wrapper)
  return wrapper:getGamePadInvertX()
end
function PaGlobal_Option._elements.GamePadInvertY:get(wrapper)
  return wrapper:getGamePadInvertY()
end
function PaGlobal_Option._elements.GamePadSensitivityX:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getGamePadSensitivityX(), 0.1, 2)
end
function PaGlobal_Option._elements.GamePadSensitivityY:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getGamePadSensitivityY(), 0.1, 2)
end
function PaGlobal_Option._elements.ConsolePadKeyType:get(wrapper)
  local keyType = wrapper:getConsoleKeyType()
  if 1 == keyType then
    return 0
  elseif 2 == keyType then
    return 1
  end
end
function PaGlobal_Option._elements.ScreenShotQuality:get(wrapper)
  return wrapper:getScreenShotQuality()
end
function PaGlobal_Option._elements.ScreenShotFormat:get(wrapper)
  return wrapper:getScreenShotFormat()
end
function PaGlobal_Option._elements.WatermarkAlpha:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getWatermarkAlpha(), 0, 1)
end
function PaGlobal_Option._elements.WatermarkScale:get(wrapper)
  return wrapper:getWatermarkScale()
end
function PaGlobal_Option._elements.WatermarkPosition:get(wrapper)
  return wrapper:getWatermarkPosition()
end
function PaGlobal_Option._elements.WatermarkService:get(wrapper)
  return wrapper:getWatermarkService()
end
function PaGlobal_Option._elements.ScreenMode:get(wrapper)
  return wrapper:getScreenMode()
end
function PaGlobal_Option._elements.ScreenResolution:get(wrapper)
  return false
end
function PaGlobal_Option._elements.CropModeEnable:get(wrapper)
  return wrapper:getCropModeEnable()
end
function PaGlobal_Option._elements.CropModeScaleX:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getCropModeScaleX(), 0.5, 1)
end
function PaGlobal_Option._elements.CropModeScaleY:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getCropModeScaleY(), 0.5, 1)
end
function PaGlobal_Option._elements.UIScale:get(wrapper)
  if true == UI.checkResolution4KForXBox() then
    PaGlobal_Option._elements.UIScale._initValue = 2
  end
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getUIScale(), 0.5, 2)
end
function PaGlobal_Option._elements.GammaValue:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getHdrDisplayGamma(), PaGlobal_Option._elements.GammaValue._sliderValueMin * 0.01, PaGlobal_Option._elements.GammaValue._sliderValueMax * 0.01)
end
function PaGlobal_Option._elements.ContrastValue:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getContrastValue(), 0, 1)
end
function PaGlobal_Option._elements.EffectAlpha:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getEffectAlpha(), 0.3, 1)
end
function PaGlobal_Option._elements.SkillPostEffect:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getSkillPostEffect(), 0, 1)
end
function PaGlobal_Option._elements.ColorBlind:get(wrapper)
  return ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
end
function PaGlobal_Option._elements.BlackSpiritNotice:get(wrapper)
  return wrapper:getBlackSpiritNotice()
end
function PaGlobal_Option._elements.ShowCashAlert:get(wrapper)
  return not wrapper:getCashAlert()
end
function PaGlobal_Option._elements.ShowGuildLoginMessage:get(wrapper)
  return wrapper:getShowGuildLoginMessage()
end
function PaGlobal_Option._elements.LUT:get(wrapper)
  return wrapper:getCameraLUTFilter()
end
function PaGlobal_Option._elements.EnableMusic:get(wrapper)
  return wrapper:getEnableMusic()
end
function PaGlobal_Option._elements.EnableSound:get(wrapper)
  return wrapper:getEnableSound()
end
function PaGlobal_Option._elements.EnableEnv:get(wrapper)
  return wrapper:getEnableEnvSound()
end
function PaGlobal_Option._elements.EnableRidingSound:get(wrapper)
  return wrapper:getEnableRidingSound()
end
function PaGlobal_Option._elements.EnableWhisperMusic:get(wrapper)
  return wrapper:getEnableWhisperSound()
end
function PaGlobal_Option._elements.EnableTraySoundOnOff:get(wrapper)
  return wrapper:getEnableTraySound()
end
function PaGlobal_Option._elements.BattleSoundType:get(wrapper)
  if 0 == wrapper:getEnableBattleSoundType() then
    return false
  else
    return true
  end
end
function PaGlobal_Option._elements.EnableAudioFairy:get(wrapper)
  return wrapper:getEnableFairySound()
end
function PaGlobal_Option._elements.VolumeMaster:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getMasterVolume(), 0, 100)
end
function PaGlobal_Option._elements.VolumeMusic:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getMusicVolume(), 0, 100)
end
function PaGlobal_Option._elements.VolumeFx:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getFxVolume(), 0, 100)
end
function PaGlobal_Option._elements.VolumeEnv:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getEnvSoundVolume(), 0, 100)
end
function PaGlobal_Option._elements.VolumeDlg:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getDialogueVolume(), 0, 100)
end
function PaGlobal_Option._elements.VolumeHitFxVolume:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getHitFxVolume(), 0, 100)
end
function PaGlobal_Option._elements.VolumeHitFxWeight:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getHitFxWeight(), 0, 100)
end
function PaGlobal_Option._elements.VolumeOtherPlayer:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getOtherPlayerVolume(), 0, 100)
end
function PaGlobal_Option._elements.VolumeFairy:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getFairyVolume(), 0, 100)
end
function PaGlobal_Option._elements.AlertNormalTrade:get(wrapper)
  return not ToClient_GetMessageFilter(PaGlobal_Option.ALERT.NormalTrade)
end
function PaGlobal_Option._elements.AlertRoyalTrade:get(wrapper)
  return not ToClient_GetMessageFilter(PaGlobal_Option.ALERT.RoyalTrade)
end
function PaGlobal_Option._elements.AlertOtherPlayerGetItem:get(wrapper)
  return not ToClient_GetMessageFilter(PaGlobal_Option.ALERT.OtherPlayerGetItem)
end
function PaGlobal_Option._elements.AlertLifeLevelUp:get(wrapper)
  return not ToClient_GetMessageFilter(PaGlobal_Option.ALERT.LifeLevelUp)
end
function PaGlobal_Option._elements.AlertItemMarket:get(wrapper)
  return not ToClient_GetMessageFilter(PaGlobal_Option.ALERT.ItemMarket)
end
function PaGlobal_Option._elements.AlertOtherMarket:get(wrapper)
  return not ToClient_GetMessageFilter(PaGlobal_Option.ALERT.OtherMarket)
end
function PaGlobal_Option._elements.AlertChangeRegion:get(wrapper)
  return not ToClient_GetMessageFilter(PaGlobal_Option.ALERT.ChangeRegion)
end
function PaGlobal_Option._elements.AlertFitnessLevelUp:get(wrapper)
  return not ToClient_GetMessageFilter(PaGlobal_Option.ALERT.FitnessLevelUp)
end
function PaGlobal_Option._elements.AlertTerritoryWar:get(wrapper)
  return not ToClient_GetMessageFilter(PaGlobal_Option.ALERT.TerritoryWar)
end
function PaGlobal_Option._elements.AlertGuildWar:get(wrapper)
  return not ToClient_GetMessageFilter(PaGlobal_Option.ALERT.GuildWar)
end
function PaGlobal_Option._elements.AlertEnchantSuccess:get(wrapper)
  return not ToClient_GetMessageFilter(PaGlobal_Option.ALERT.EnchantSuccess)
end
function PaGlobal_Option._elements.AlertEnchantFail:get(wrapper)
  return not ToClient_GetMessageFilter(PaGlobal_Option.ALERT.EnchantFail)
end
function PaGlobal_Option._elements.AlertGuildQuestMessage:get(wrapper)
  return not ToClient_GetMessageFilter(PaGlobal_Option.ALERT.GuildQuestMessage)
end
function PaGlobal_Option._elements.AlertNearMonster:get(wrapper)
  return not ToClient_GetMessageFilter(PaGlobal_Option.ALERT.NearMonster)
end
function PaGlobal_Option._elements.SelfPlayerOnlyEffect:get(wrapper)
  return wrapper:getSelfPlayerOnlyEffect()
end
function PaGlobal_Option._elements.NearestPlayerOnlyEffect:get(wrapper)
  return wrapper:getNearestPlayerOnlyEffect()
end
function PaGlobal_Option._elements.SelfPlayerOnlyLantern:get(wrapper)
  return wrapper:getSelfPlayerOnlyLantern()
end
function PaGlobal_Option._elements.ShowStackHp:get(wrapper)
  return wrapper:getIsShowHpBar()
end
function PaGlobal_Option._elements.HDRDisplayGamma:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getHdrDisplayGamma(), PaGlobal_Option._elements.HDRDisplayGamma._sliderValueMin * 0.01, PaGlobal_Option._elements.HDRDisplayGamma._sliderValueMax * 0.01)
end
function PaGlobal_Option._elements.HDRDisplayMaxNits:get(wrapper)
  return PaGlobal_Option:FromRealValueToSliderValue(wrapper:getHdrDisplayMaxNits(), PaGlobal_Option._elements.HDRDisplayMaxNits._sliderValueMin, PaGlobal_Option._elements.HDRDisplayMaxNits._sliderValueMax)
end
function PaGlobal_Option._elements.UltraHighDefinition:get(wrapper)
  return wrapper:getIsUHDMode()
end
function PaGlobal_Option._elements.UseGamePadQuickTurn:get(wrapper)
  return wrapper:getGamePadUseQuickTurn()
end
function PaGlobal_Option._elements.ChatFilterNotice:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatType(CppEnums.ChatType.Notice)
end
function PaGlobal_Option._elements.ChatFilterWorld:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatType(CppEnums.ChatType.WorldWithItem)
end
function PaGlobal_Option._elements.ChatFilterPublic:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatType(CppEnums.ChatType.Public)
end
function PaGlobal_Option._elements.ChatFilterWhisper:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatType(CppEnums.ChatType.Private)
end
function PaGlobal_Option._elements.ChatFilterParty:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatType(CppEnums.ChatType.Party)
end
function PaGlobal_Option._elements.ChatFilterGuild:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatType(CppEnums.ChatType.Guild)
end
function PaGlobal_Option._elements.ChatFilterServer:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatType(CppEnums.ChatType.World)
end
function PaGlobal_Option._elements.ChatFilterBattle:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatType(CppEnums.ChatType.Battle)
end
function PaGlobal_Option._elements.ChatFilterTeam:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatType(CppEnums.ChatType.Team)
end
function PaGlobal_Option._elements.ChatFilterSystemAll:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatType(CppEnums.ChatType.System)
end
function PaGlobal_Option._elements.ChatFilterSystemPrivateItem:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatSystemType(CppEnums.ChatSystemType.PrivateItem)
end
function PaGlobal_Option._elements.ChatFilterSystemPartyItem:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatSystemType(CppEnums.ChatSystemType.PartyItem)
end
function PaGlobal_Option._elements.ChatFilterSystemMarket:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatSystemType(CppEnums.ChatSystemType.Market)
end
function PaGlobal_Option._elements.ChatFilterSystemWorker:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatSystemType(CppEnums.ChatSystemType.Worker)
end
function PaGlobal_Option._elements.ChatFilterSystemHarvest:get()
  local chat = ToClient_getChattingPanel(0)
  return chat:isShowChatSystemType(CppEnums.ChatSystemType.Harvest)
end
local elements = PaGlobal_Option._elements
elements.UIFontSizeType._radioButtonMapping = {}
elements.ShowNavPathEffectType._radioButtonMapping = {
  [0] = {
    _string = "PANEL_NEWGAMEOPTION_FUNCTION_ETC_ShowNavPathEffectType_0"
  },
  [1] = {
    _string = "PANEL_NEWGAMEOPTION_FUNCTION_ETC_ShowNavPathEffectType_1"
  },
  [2] = {
    _string = "PANEL_NEWGAMEOPTION_FUNCTION_ETC_ShowNavPathEffectType_2"
  },
  [3] = {
    _string = "PANEL_NEWGAMEOPTION_FUNCTION_ETC_ShowNavPathEffectType_3"
  },
  ["_count"] = 4
}
elements.AudioResourceType._radioButtonMapping = {_count = 11}
elements.ServiceResourceType._radioButtonMapping = {}
elements.ChatChannelType._radioButtonMapping = {}
elements.SelfPlayerNameTagVisible._radioButtonMapping = {}
elements.PetRender._radioButtonMapping = {}
elements.FairyRender._radioButtonMapping = {}
elements.WorldMapOpenType._radioButtonMapping = {}
elements.WorldmapCameraPitchType._radioButtonMapping = {}
elements.TextureQuality._radioButtonMapping = {}
elements.GraphicOption._radioButtonMapping = {}
elements.ScreenShotQuality._radioButtonMapping = {}
elements.ScreenShotFormat._radioButtonMapping = {}
elements.WatermarkScale._radioButtonMapping = {}
elements.WatermarkPosition._radioButtonMapping = {}
elements.WatermarkService._radioButtonMapping = {}
elements.ScreenMode._radioButtonMapping = {}
elements.ColorBlind._radioButtonMapping = {}
elements.BattleSoundType._radioButtonMapping = {}
elements.ConsolePadKeyType._radioButtonMapping = {
  [0] = {
    _string = "PANEL_NEWGAMEOPTION_CAMERATYPE_MANUAL"
  },
  [1] = {
    _string = "PANEL_NEWGAMEOPTION_CAMERATYPE_AUTO"
  },
  ["_count"] = 2
}

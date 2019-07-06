local CONTROL = CppEnums.PA_UI_CONTROL_TYPE
PaGlobal_Option = {
  UIMODE = {
    Main = 1,
    Category = 2,
    Search = 3
  },
  SPEC = {
    LowNormal = 1,
    MidNormal = 2,
    HighNormal = 3,
    HighestNormal = 4,
    LowSiege = 5,
    MidSiege = 6,
    HighSiege = 7,
    HighestSiege = 8
  },
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
  _tooltip = {
    ResetAll = {},
    SaveSetting = {},
    Apply = {},
    Cancel = {},
    Confirm = {},
    Home = {},
    CustomSave = {},
    ResetFrame = {}
  },
  _ui = {
    _staticMainTopBg = UI.getChildControl(Panel_Window_cOption, "Static_MainTopBg"),
    _staticSubTopBg = UI.getChildControl(Panel_Window_cOption, "Static_SubTopBg"),
    _staticMainBg = UI.getChildControl(Panel_Window_cOption, "Static_MainBg"),
    _staticSpecBG = nil,
    _staticCategoryBG = nil,
    _list2 = nil,
    _listSearchBg = UI.getChildControl(Panel_Window_cOption, "List2_Search"),
    _specDescTable = {},
    _categoryTitleTable = {},
    _categoryDescTable = {},
    _atFieldString = nil
  },
  _list2 = {
    _curCategory = nil,
    _curFrame = nil,
    _tree2IndexMap = {},
    _selectedKey = nil,
    _selectedSubKey = nil
  },
  _frames = {
    Performance = {
      Optimize = Panel_Performance_Optimize,
      GraphicQuality = Panel_Performance_GraphicQuality,
      Camera = Panel_Performance_Camera,
      Npc = Panel_Performance_Npc
    },
    Graphic = {
      Window = Panel_Graphic_Window,
      Quality = Panel_Graphic_Quality,
      Effect = Panel_Graphic_Effect,
      Camera = Panel_Graphic_Camera,
      ScreenShot = Panel_Graphic_ScreenShot,
      HDR = Panel_Graphic_HDR
    },
    Sound = {OnOff = Panel_Sound_OnOff, Volume = Panel_Sound_Volume},
    Function = {
      Convenience = Panel_Function_Convenience,
      View = Panel_Function_View,
      Alert = Panel_Function_Alert,
      Worldmap = Panel_Function_Worldmap,
      Nation = Panel_Function_Nation,
      Etc = Panel_Function_Etc
    },
    Interface = {
      Action = Panel_Interface_Action,
      UI = Panel_Interface_UI,
      QuickSlot = Panel_Interface_QuickSlot,
      Function = Panel_Interface_Function,
      Mouse = Panel_Interface_Mouse,
      Pad = Panel_Interface_Pad
    }
  },
  _functions = {},
  _searchElementTable = {},
  _elements = {
    AimAssist = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    UseNewQuickSlot = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    EnableSimpleUI = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    IsOnScreenSaver = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    UIFontSizeType = {
      _defaultValue = 0,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ShowNavPathEffectType = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    RefuseRequests = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    IsPvpRefuse = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    IsExchangeRefuse = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    RotateRadarMode = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    HideWindowByAttacked = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AudioResourceType = {
      _defaultValue = 0,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ServiceResourceType = {
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UseChattingFilter = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    ChatChannelType = {
      _defaultValue = 0,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    SelfPlayerNameTagVisible = {
      _defaultValue = 0,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    OtherPlayerNameTagVisible = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    PartyPlayerNameTagVisible = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    GuildPlayerNameTagVisible = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    RankingPlayerNameTagVisible = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    GuideLineZoneChange = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    GuideLineQuestNPC = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    GuideLineNpcIntimacy = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    GuideLineWarAlly = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    GuideLineNonWarPlayer = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    GuideLineEnemy = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    GuideLineGuild = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    GuideLineParty = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    PetRender = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    FairyRender = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    TentRender = {
      _defaultValue = 0,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    MaidView = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100
    },
    ShowReputation = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    RenderHitEffect = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON,
      _isPictureTooltipOn = true
    },
    DamageMeter = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    ShowComboGuide = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    HideMastOnCarrier = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    WorldMapOpenType = {
      _defaultValue = 3,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    WorldmapCameraPitchType = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    TextureQuality = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON,
      _isPictureTooltipOn = true
    },
    GraphicOption = {
      _defaultValue = 2,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    AntiAliasing = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON,
      _isPictureTooltipOn = true
    },
    SSAO = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON,
      _isPictureTooltipOn = true
    },
    PostFilter = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    Tessellation = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON,
      _isPictureTooltipOn = true
    },
    Dof = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON,
      _isPictureTooltipOn = true
    },
    Representative = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON,
      _isPictureTooltipOn = true
    },
    CharacterEffect = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    SnowPoolOnlyInSafeZone = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    BloodEffect = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    LensBlood = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AutoOptimization = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AutoOptimizationFrameLimit = {
      _defaultValue = 0.33333,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 60
    },
    UpscaleEnable = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    SelfPlayerOnlyEffect = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    NearestPlayerOnlyEffect = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    PresentLock = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    ShowStackHp = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    UseEffectFrameOptimization = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    EffectFrameOptimization = {
      _defaultValue = 0.03,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0.1,
      _sliderValueMax = 25
    },
    UsePlayerEffectDistOptimization = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    PlayerEffectDistOptimization = {
      _defaultValue = 0.5,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 10,
      _sliderValueMax = 50
    },
    UseCharacterUpdateFrameOptimize = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    UseOtherPlayerUpdate = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    Fov = {
      _defaultValue = 0.33333,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100,
      _settingRightNow = true
    },
    CameraEffectMaster = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100
    },
    CameraShakePower = {
      _defaultValue = 0.5,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100
    },
    MotionBlurPower = {
      _defaultValue = 0.1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100
    },
    CameraTranslatePower = {
      _defaultValue = 0.5,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100
    },
    CameraFovPower = {
      _defaultValue = 0.5,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100
    },
    LUT = {
      _defaultValue = 8,
      _controlType = CONTROL.PA_UI_CONTROL_BUTTON,
      _settingRightNow = true
    },
    HDRDisplayGamma = {
      _defaultValue = 0.5,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0.5,
      _sliderValueMax = 1.5,
      _settingRightNow = true
    },
    HDRDisplayMaxNits = {
      _defaultValue = 0.5,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 500,
      _sliderValueMax = 10000,
      _settingRightNow = true
    },
    UltraHighDefinition = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    MouseInvertX = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    MouseInvertY = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    MouseSensitivityX = {
      _defaultValue = 0.473684,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100
    },
    MouseSensitivityY = {
      _defaultValue = 0.473684,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100
    },
    GameMouseMode = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    IsUIModeMouseLock = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    GamePadEnable = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    GamePadVibration = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    GamePadInvertX = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    GamePadInvertY = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    UseLedAnimation = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    GamePadSensitivityX = {
      _defaultValue = 0.473684,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100
    },
    GamePadSensitivityY = {
      _defaultValue = 0.315789,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100
    },
    ConsolePadKeyType = {
      _defaultValue = 0,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ScreenShotQuality = {
      _defaultValue = 0,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ScreenShotFormat = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    WatermarkAlpha = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 20,
      _sliderValueMax = 100
    },
    WatermarkScale = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    WatermarkPosition = {
      _defaultValue = 3,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    WatermarkService = {
      _defaultValue = 0,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ScreenMode = {
      _defaultValue = 2,
      _isChangeDisplay = true,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ScreenResolution = {
      _isChangeDisplay = true,
      _controlType = CONTROL.PA_UI_CONTROL_COMBOBOX,
      _comboBoxList = nil
    },
    CropModeEnable = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    CropModeScaleX = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 50,
      _sliderValueMax = 100
    },
    CropModeScaleY = {
      _defaultValue = 0.6,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 50,
      _sliderValueMax = 100
    },
    UIScale = {
      _defaultValue = 0.3333,
      _isChangeDisplay = true,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 50,
      _sliderValueMax = 200
    },
    GammaValue = {
      _defaultValue = 0.5,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = -50,
      _sliderValueMax = 50,
      _settingRightNow = true
    },
    ContrastValue = {
      _defaultValue = 0.7,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = -50,
      _sliderValueMax = 50,
      _settingRightNow = true
    },
    EffectAlpha = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 30,
      _sliderValueMax = 100
    },
    SkillPostEffect = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100
    },
    ColorBlind = {
      _defaultValue = 0,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    BlackSpiritNotice = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    ShowCashAlert = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    ShowGuildLoginMessage = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    EnableMusic = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON,
      _settingRightNow = true
    },
    EnableSound = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON,
      _settingRightNow = true
    },
    EnableEnv = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON,
      _settingRightNow = true
    },
    EnableWhisperMusic = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON,
      _settingRightNow = true
    },
    EnableTraySoundOnOff = {
      _defaultValue = false,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON,
      _settingRightNow = true
    },
    BattleSoundType = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON,
      _settingRightNow = true
    },
    EnableAudioFairy = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    VolumeMaster = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100,
      _settingRightNow = true
    },
    VolumeMusic = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100,
      _settingRightNow = true
    },
    VolumeFx = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100,
      _settingRightNow = true
    },
    VolumeEnv = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100,
      _settingRightNow = true
    },
    VolumeDlg = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100,
      _settingRightNow = true
    },
    VolumeHitFxVolume = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100,
      _settingRightNow = true
    },
    VolumeHitFxWeight = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100,
      _settingRightNow = true
    },
    VolumeOtherPlayer = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100,
      _settingRightNow = true
    },
    VolumeFairy = {
      _defaultValue = 0.5,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 0,
      _sliderValueMax = 100,
      _settingRightNow = true
    },
    AlertNormalTrade = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AlertRoyalTrade = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AlertOtherPlayerGetItem = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AlertLifeLevelUp = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AlertItemMarket = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AlertOtherMarket = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AlertChangeRegion = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AlertFitnessLevelUp = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AlertTerritoryWar = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AlertGuildWar = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AlertEnchantSuccess = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AlertEnchantFail = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AlertGuildQuestMessage = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AlertNearMonster = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    ShowRightBottomAlarm = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AutoRunCamera = {
      _defaultValue = true,
      _controlType = CONTROL.PA_UI_CONTROL_CHECKBUTTON
    },
    AutoRunCameraRotation = {
      _defaultValue = 1,
      _controlType = CONTROL.PA_UI_CONTROL_SLIDER,
      _sliderValueMin = 10,
      _sliderValueMax = 30
    },
    KeyCustomMode = {
      _defaultValue = 0,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON,
      _settingRightNow = true
    },
    PadFunction1 = {
      actionInputType = "PadFunction1",
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    PadFunction2 = {
      actionInputType = "PadFunction2",
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionMoveFront = {
      actionInputType = 0,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionMoveBack = {
      actionInputType = 1,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionMoveLeft = {
      actionInputType = 2,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionMoveRight = {
      actionInputType = 3,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionAttack1 = {
      actionInputType = 4,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionAttack2 = {
      actionInputType = 5,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionDash = {
      actionInputType = 6,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionJump = {
      actionInputType = 7,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionInteraction = {
      actionInputType = 8,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionAutoRun = {
      actionInputType = 9,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionWeaponInOut = {
      actionInputType = 10,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionCameraReset = {
      actionInputType = 11,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionCrouchOrSkill = {
      actionInputType = 12,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionGrabOrGuard = {
      actionInputType = 13,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionKick = {
      actionInputType = 14,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionServantOrder1 = {
      actionInputType = 15,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionServantOrder2 = {
      actionInputType = 16,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionServantOrder3 = {
      actionInputType = 17,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionServantOrder4 = {
      actionInputType = 18,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot1 = {
      actionInputType = 19,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot2 = {
      actionInputType = 20,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot3 = {
      actionInputType = 21,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot4 = {
      actionInputType = 22,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot5 = {
      actionInputType = 23,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot6 = {
      actionInputType = 24,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot7 = {
      actionInputType = 25,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot8 = {
      actionInputType = 26,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot9 = {
      actionInputType = 27,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot10 = {
      actionInputType = 28,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot11 = {
      actionInputType = 29,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot12 = {
      actionInputType = 30,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot13 = {
      actionInputType = 31,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot14 = {
      actionInputType = 32,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot15 = {
      actionInputType = 33,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot16 = {
      actionInputType = 34,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot17 = {
      actionInputType = 35,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot18 = {
      actionInputType = 36,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot19 = {
      actionInputType = 37,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionQuickSlot20 = {
      actionInputType = 38,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionComplicated0 = {
      actionInputType = 39,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionComplicated1 = {
      actionInputType = 40,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionComplicated2 = {
      actionInputType = 41,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionComplicated3 = {
      actionInputType = 42,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionAutoMoveWalkMode = {
      actionInputType = 43,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionCameraUp = {
      actionInputType = 44,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionCameraDown = {
      actionInputType = 45,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionCameraLeft = {
      actionInputType = 46,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionCameraRight = {
      actionInputType = 47,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionCameraRotateGameMode = {
      actionInputType = 48,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionPushToTalk = {
      actionInputType = 49,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    ActionWalkMode = {
      actionInputType = 50,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiCursorOnOff = {
      uiInputType = 0,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiHelp = {
      uiInputType = 1,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiMentalKnowledge = {
      uiInputType = 2,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiInventory = {
      uiInputType = 3,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiBlackSpirit = {
      uiInputType = 4,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiChat = {
      uiInputType = 5,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiPlayerInfo = {
      uiInputType = 6,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiSkill = {
      uiInputType = 7,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiWorldMap = {
      uiInputType = 8,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiDyeing = {
      uiInputType = 9,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiProductionNote = {
      uiInputType = 10,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiManufacture = {
      uiInputType = 11,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiGuild = {
      uiInputType = 12,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiMail = {
      uiInputType = 13,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiFriendList = {
      uiInputType = 14,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiPresent = {
      uiInputType = 15,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiQuestHistory = {
      uiInputType = 16,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiCashShop = {
      uiInputType = 18,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiBeautyShop = {
      uiInputType = 19,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiAlchemyStone = {
      uiInputType = 20,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiHouse = {
      uiInputType = 21,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiWorker = {
      uiInputType = 22,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiPet = {
      uiInputType = 23,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiMaid = {
      uiInputType = 24,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiServant = {
      uiInputType = 25,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiGuildServant = {
      uiInputType = 26,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiDeleteNavigation = {
      uiInputType = 27,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiCameraSpeedUp = {
      uiInputType = 28,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiCameraSpeedDown = {
      uiInputType = 29,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiPositionNotify = {
      uiInputType = 30,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiInteraction1 = {
      uiInputType = 31,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiInteraction2 = {
      uiInputType = 32,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiInteraction3 = {
      uiInputType = 33,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiInteraction4 = {
      uiInputType = 34,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiInteraction5 = {
      uiInputType = 35,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiChatTabPrev = {
      uiInputType = 36,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiChatTabNext = {
      uiInputType = 37,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiAdventureBook = {
      uiInputType = 47,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    },
    UiBlackGift = {
      uiInputType = 48,
      _controlType = CONTROL.PA_UI_CONTROL_RADIOBUTTON
    }
  },
  _userInitScreenResolution = {width = 0, height = 0},
  _findStrings = {},
  _keyCustomPadMode = nil,
  _keyCustomInputType = nil,
  _resetCheck = nil,
  _availableResolutionList = nil,
  _screenResolutionCount = nil,
  _fpsTextControl = {}
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
function PaGlobal_Option._functions.AimAssist(value)
  setAimAssist(value)
end
function PaGlobal_Option._functions.UseNewQuickSlot(value)
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eNewQuickSlot, value, CppEnums.VariableStorageType.eVariableStorageType_User)
end
function PaGlobal_Option._functions.EnableSimpleUI(value)
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
function PaGlobal_Option._functions.IsOnScreenSaver(value)
  setIsOnScreenSaver(value)
end
function PaGlobal_Option._functions.UIFontSizeType(value)
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
function PaGlobal_Option._functions.ShowNavPathEffectType(value)
  setShowNavPathEffectType(value)
end
function PaGlobal_Option._functions.RefuseRequests(value)
  setRefuseRequests(value)
end
function PaGlobal_Option._functions.IsPvpRefuse(value)
  setIsPvpRefuse(value)
end
function PaGlobal_Option._functions.IsExchangeRefuse(value)
  setIsExchangeRefuse(value)
end
function PaGlobal_Option._functions.RotateRadarMode(value)
  setRotateRadarMode(value)
end
function PaGlobal_Option._functions.HideWindowByAttacked(value)
  setHideWindowByAttacked(value)
end
function PaGlobal_Option._functions.ShowRightBottomAlarm(value)
  setShowRightBottomAlarm(value)
end
function PaGlobal_Option._functions.AutoRunCamera(value)
  setAutoRunCamera(value)
end
function PaGlobal_Option._functions.AutoRunCameraRotation(value)
  setAutoRunCameraRotation(value)
end
function PaGlobal_Option._functions.AudioResourceType(value)
  setAudioResourceType(PaGlobal_Option:radioButtonMapping_AudioResourceType(value))
end
function PaGlobal_Option._functions.ServiceResourceType(value)
  if false == ToClient_isAvailableChangeServiceType() then
    return
  end
  ToClient_saveServiceResourceType(PaGlobal_Option:radioButtonMapping_ServiceResourceType(value))
end
function PaGlobal_Option._functions.UseChattingFilter(value)
  setUseChattingFilter(value)
end
function PaGlobal_Option._functions.ChatChannelType(value)
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
function PaGlobal_Option._functions.SelfPlayerNameTagVisible(value)
  setSelfPlayerNameTagVisible(value)
end
function PaGlobal_Option._functions.OtherPlayerNameTagVisible(value)
  if true == value then
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow
  else
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_ImportantShow
  end
  setOtherPlayerNameTagVisible(value)
end
function PaGlobal_Option._functions.PartyPlayerNameTagVisible(value)
  if true == value then
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow
  else
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_ImportantShow
  end
  setPartyPlayerNameTagVisible(value)
end
function PaGlobal_Option._functions.GuildPlayerNameTagVisible(value)
  if true == value then
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow
  else
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_ImportantShow
  end
  setGuildPlayerNameTagVisible(value)
end
function PaGlobal_Option._functions.RankingPlayerNameTagVisible(value)
  if true == value then
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow
  else
    value = CppEnums.VisibleNameTagType.eVisibleNameTagType_NoShow
  end
  setRankingPlayerNameTagVisible(value)
end
function PaGlobal_Option._functions.GuideLineZoneChange(value)
  setRenderPlayerColor("ZoneChange", value)
end
function PaGlobal_Option._functions.GuideLineQuestNPC(value)
  setShowQuestActorColor(value)
end
function PaGlobal_Option._functions.GuideLineNpcIntimacy(value)
  setShowHumanRelation(value)
end
function PaGlobal_Option._functions.GuideLineWarAlly(value)
  setRenderPlayerColor("WarAlly", value)
end
function PaGlobal_Option._functions.GuideLineNonWarPlayer(value)
  setRenderPlayerColor("NonWarPlayer", value)
end
function PaGlobal_Option._functions.GuideLineEnemy(value)
  setRenderPlayerColor("Enemy", value)
end
function PaGlobal_Option._functions.GuideLineGuild(value)
  setRenderPlayerColor("Guild", value)
end
function PaGlobal_Option._functions.GuideLineParty(value)
  setRenderPlayerColor("Party", value)
end
function PaGlobal_Option._functions.GuideLinePartyMemberEffect(value)
  ToClient_getGameOptionControllerWrapper():setRenderHitEffectParty(value)
end
function PaGlobal_Option._functions.PetRender(value)
  setPetRender(value)
end
function PaGlobal_Option._functions.FairyRender(value)
  if 0 == value then
    setFairyRender(true)
  else
    setFairyRender(false)
  end
end
function PaGlobal_Option._functions.TentRender(value)
  if 0 == value then
    setHideOtherPlayerTent(false)
  else
    setHideOtherPlayerTent(true)
  end
end
function PaGlobal_Option._functions.MaidView(value)
  local maidViewElement = PaGlobal_Option._elements.MaidView
  local maxMaidValue = maidViewElement._sliderValueMax
  setMaidView(value * maxMaidValue)
end
function PaGlobal_Option._functions.ShowReputation(value)
  return setShowStatTier(value)
end
function PaGlobal_Option._functions.RenderHitEffect(value)
  setRenderHitEffect(value)
  FGlobal_SetMamageShow()
end
function PaGlobal_Option._functions.DamageMeter(value)
  setOnDamageMeter(value)
end
function PaGlobal_Option._functions.ShowComboGuide(value)
  setShowComboGuide(value)
  if nil ~= Panel_MovieTheater_320 then
    Panel_MovieTheater320_JustClose()
  end
end
function PaGlobal_Option._functions.HideMastOnCarrier(value)
  setHideMastOnCarrier(value)
end
function PaGlobal_Option._functions.WorldMapOpenType(value)
  setWorldmapOpenType(value)
end
function PaGlobal_Option._functions.WorldmapCameraPitchType(value)
  setWorldMapCameraPitchType(value)
end
function PaGlobal_Option._functions.TextureQuality(value)
  setTextureQuality(PaGlobal_Option:radioButtonMapping_TextureQuality(value))
end
function PaGlobal_Option._functions.GraphicOption(value)
  setGraphicOption(PaGlobal_Option:radioButtonMapping_GraphicOption(value))
end
function PaGlobal_Option._functions.AntiAliasing(value)
  setAntiAliasing(value)
end
function PaGlobal_Option._functions.SSAO(value)
  setSSAO(value)
end
function PaGlobal_Option._functions.PostFilter(value)
  if true == value then
    setPostFilter(2)
  else
    setPostFilter(1)
  end
end
function PaGlobal_Option._functions.Tessellation(value)
  setTessellation(value)
end
function PaGlobal_Option._functions.Dof(value)
  setDof(value)
end
function PaGlobal_Option._functions.Representative(value)
  setRepresentative(value)
end
function PaGlobal_Option._functions.CharacterEffect(value)
  setCharacterEffect(value)
end
function PaGlobal_Option._functions.SnowPoolOnlyInSafeZone(value)
  setSnowPoolOnlyInSafeZone(value)
end
function PaGlobal_Option._functions.BloodEffect(value)
  if true == value then
    setBloodEffect(2)
  else
    setBloodEffect(0)
  end
end
function PaGlobal_Option._functions.LensBlood(value)
  setLensBlood(value)
end
function PaGlobal_Option._functions.AutoOptimization(value)
  setAutoOptimization(value)
end
function PaGlobal_Option._functions.AutoOptimizationFrameLimit(value)
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
function PaGlobal_Option._functions.UpscaleEnable(value)
  setUpscaleEnable(value)
end
function PaGlobal_Option._functions.PresentLock(value)
  setPresentLock(value)
end
function PaGlobal_Option._functions.UseEffectFrameOptimization(value)
  setUseOptimizationEffectFrame(value)
end
function PaGlobal_Option._functions.EffectFrameOptimization(value)
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
function PaGlobal_Option._functions.UsePlayerEffectDistOptimization(value)
  setUsePlayerOptimizationEffectFrame(value)
end
function PaGlobal_Option._functions.PlayerEffectDistOptimization(value)
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
function PaGlobal_Option._functions.UseCharacterUpdateFrameOptimize(value)
  setUseCharacterDistUpdate(value)
end
function PaGlobal_Option._functions.UseOtherPlayerUpdate(value)
  FromClient_OtherPlayeUpdate(value, true)
end
function PaGlobal_Option._functions.Fov(value)
  value = value * 30 + 40
  setFov(value)
end
function PaGlobal_Option._functions.CameraEffectMaster(value)
  setCameraMasterPower(value)
end
function PaGlobal_Option._functions.CameraShakePower(value)
  setCameraShakePower(value)
end
function PaGlobal_Option._functions.MotionBlurPower(value)
  setMotionBlurPower(value)
end
function PaGlobal_Option._functions.CameraTranslatePower(value)
  setCameraTranslatePower(value)
end
function PaGlobal_Option._functions.CameraFovPower(value)
  setCameraFovPower(value)
end
function PaGlobal_Option._functions.MouseInvertX(value)
  setMouseInvertX(value)
end
function PaGlobal_Option._functions.MouseInvertY(value)
  setMouseInvertY(value)
end
function PaGlobal_Option._functions.MouseSensitivityX(value)
  local convertedValue = value * 1.9 + 0.1
  setMouseSensitivityX(convertedValue)
end
function PaGlobal_Option._functions.MouseSensitivityY(value)
  local convertedValue = value * 1.9 + 0.1
  setMouseSensitivityY(convertedValue)
end
function PaGlobal_Option._functions.GameMouseMode(value)
  setGameMouseMode(value)
end
function PaGlobal_Option._functions.IsUIModeMouseLock(value)
  setIsUIModeMouseLock(value)
end
function PaGlobal_Option._functions.GamePadEnable(value)
  setGamePadEnable(value)
end
function PaGlobal_Option._functions.GamePadVibration(value)
  setGamePadVibration(value)
end
function PaGlobal_Option._functions.GamePadInvertX(value)
  setGamePadInvertX(value)
end
function PaGlobal_Option._functions.GamePadInvertY(value)
  setGamePadInvertY(value)
end
function PaGlobal_Option._functions.GamePadSensitivityX(value)
  local convertedValue = value * 1.8 + 0.2
  setGamePadSensitivityX(convertedValue)
end
function PaGlobal_Option._functions.GamePadSensitivityY(value)
  local convertedValue = value * 1.8 + 0.2
  setGamePadSensitivityY(convertedValue)
end
function PaGlobal_Option._functions.ConsolePadKeyType(value)
  if true == _ContentsGroup_isConsoleTest then
    setConsoleKeyType(value)
  end
end
function PaGlobal_Option._functions.ScreenShotQuality(value)
  setScreenShotQuality(value)
end
function PaGlobal_Option._functions.ScreenShotFormat(value)
  setScreenShotFormat(value)
end
function PaGlobal_Option._functions.WatermarkAlpha(value)
  setWatermarkAlpha(value)
end
function PaGlobal_Option._functions.WatermarkScale(value)
  setWatermarkScale(value)
end
function PaGlobal_Option._functions.WatermarkPosition(value)
  setWatermarkPosition(value)
end
function PaGlobal_Option._functions.WatermarkService(value)
  setWatermarkService(value)
end
function PaGlobal_Option._functions.ScreenMode(value)
  setScreenMode(value)
  ischangedeplay = true
end
function PaGlobal_Option._functions.ScreenResolution(value)
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
function PaGlobal_Option._functions.CropModeEnable(value)
  setCropModeEnable(value)
end
function PaGlobal_Option._functions.CropModeScaleX(value)
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
function PaGlobal_Option._functions.CropModeScaleY(value)
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
function PaGlobal_Option._functions.UIScale(value)
  local interval = PaGlobal_Option._elements.UIScale._sliderValueMax - PaGlobal_Option._elements.UIScale._sliderValueMin
  local convertedValue = (PaGlobal_Option._elements.UIScale._sliderValueMin + interval * value) * 0.01
  convertedValue = math.floor((convertedValue + 0.002) * 100) / 100
  setUIScale(convertedValue)
end
function PaGlobal_Option._functions.GammaValue(value)
  setGammaValue(value)
end
function PaGlobal_Option._functions.ContrastValue(value)
  setContrastValue(value)
end
function PaGlobal_Option._functions.EffectAlpha(value)
  value = PaGlobal_Option:FromSliderValueToRealValue(value, PaGlobal_Option._elements.EffectAlpha._sliderValueMin, PaGlobal_Option._elements.EffectAlpha._sliderValueMax)
  value = value * 0.01
  setEffectAlpha(value)
end
function PaGlobal_Option._functions.SkillPostEffect(value)
  setSkillPostEffect(value)
end
function PaGlobal_Option._functions.ColorBlind(value)
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eColorBlindMode, value, CppEnums.VariableStorageType.eVariableStorageType_User)
  ToClient_ChangeColorBlindMode(value)
  FGlobal_Radar_SetColorBlindMode()
  FGlobal_Window_Servant_ColorBlindUpdate()
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    FGlobal_ChangeEffectCheck()
    UIMain_QuestUpdate()
  end
end
function PaGlobal_Option._functions.BlackSpiritNotice(value)
  setBlackSpiritNotice(value)
end
function PaGlobal_Option._functions.ShowCashAlert(value)
  setShowCashAlert(not value)
end
function PaGlobal_Option._functions.ShowGuildLoginMessage(value)
  setShowGuildLoginMessage(value)
end
function PaGlobal_Option._functions.LUT(LUT)
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
function PaGlobal_Option._functions.EnableMusic(value)
  setEnableSoundMusic(value)
end
function PaGlobal_Option._functions.EnableSound(value)
  setEnableSoundFx(value)
end
function PaGlobal_Option._functions.EnableEnv(value)
  setEnableSoundEnv(value)
end
function PaGlobal_Option._functions.EnableRidingSound(value)
  setEnableRidingSound(value)
end
function PaGlobal_Option._functions.EnableWhisperMusic(value)
  setEnableSoundWhisper(value)
end
function PaGlobal_Option._functions.EnableTraySoundOnOff(value)
  setEnableSoundTray(value)
end
function PaGlobal_Option._functions.BattleSoundType(value)
  setEnableBattleSoundType(value)
end
function PaGlobal_Option._functions.EnableAudioFairy(value)
  setEnableFairySound(value)
end
function PaGlobal_Option._functions.VolumeMaster(value)
  setVolumeParamMaster(value * 100)
end
function PaGlobal_Option._functions.VolumeMusic(value)
  setVolumeParamMusic(value * 100)
end
function PaGlobal_Option._functions.VolumeFx(value)
  setVolumeParamFx(value * 100)
end
function PaGlobal_Option._functions.VolumeEnv(value)
  setVolumeParamEnv(value * 100)
end
function PaGlobal_Option._functions.VolumeDlg(value)
  setVolumeParamDialog(value * 100)
end
function PaGlobal_Option._functions.VolumeHitFxVolume(value)
  setVolumeParamHitFxVolume(value * 100)
end
function PaGlobal_Option._functions.VolumeHitFxWeight(value)
  setVolumeParamHitFxWeight(value * 100)
end
function PaGlobal_Option._functions.VolumeOtherPlayer(value)
  setVolumeParamOtherPlayer(value * 100)
end
function PaGlobal_Option._functions.VolumeFairy(value)
  setVolumeFairy(value * 100)
end
function PaGlobal_Option._functions.AlertNormalTrade(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.NormalTrade, not value)
end
function PaGlobal_Option._functions.AlertRoyalTrade(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.RoyalTrade, not value)
end
function PaGlobal_Option._functions.AlertOtherPlayerGetItem(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.OtherPlayerGetItem, not value)
end
function PaGlobal_Option._functions.AlertLifeLevelUp(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.LifeLevelUp, not value)
end
function PaGlobal_Option._functions.AlertItemMarket(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.ItemMarket, not value)
end
function PaGlobal_Option._functions.AlertOtherMarket(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.OtherMarket, not value)
end
function PaGlobal_Option._functions.AlertChangeRegion(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.ChangeRegion, not value)
end
function PaGlobal_Option._functions.AlertFitnessLevelUp(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.FitnessLevelUp, not value)
end
function PaGlobal_Option._functions.AlertTerritoryWar(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.TerritoryWar, not value)
end
function PaGlobal_Option._functions.AlertGuildWar(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.GuildWar, not value)
end
function PaGlobal_Option._functions.AlertEnchantSuccess(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.EnchantSuccess, not value)
end
function PaGlobal_Option._functions.AlertEnchantFail(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.EnchantFail, not value)
end
function PaGlobal_Option._functions.AlertGuildQuestMessage(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.GuildQuestMessage, not value)
end
function PaGlobal_Option._functions.AlertNearMonster(value)
  ToClient_SetMessageFilter(PaGlobal_Option.ALERT.NearMonster, not value)
end
function PaGlobal_Option._functions.SelfPlayerOnlyEffect(value)
  setSelfPlayerOnlyEffect(value)
end
function PaGlobal_Option._functions.NearestPlayerOnlyEffect(value)
  setNearestPlayerOnlyEffect(value)
end
function PaGlobal_Option._functions.SelfPlayerOnlyLantern(value)
  setSelfPlayerOnlyLantern(value)
end
function PaGlobal_Option._functions.ShowStackHp(value)
  if true == _ContentsGroup_StackingHpBar then
    setShowStackHp(GameOptionApply_CharacterNameTag_StackHpBar(value))
  end
end
function ConsolePadType(value)
  selfPlayerSetConsolePadType(value)
end
function PaGlobal_Option._functions.HDRDisplayGamma(value)
  value = PaGlobal_Option:FromSliderValueToRealValue(value, PaGlobal_Option._elements.HDRDisplayGamma._sliderValueMin, PaGlobal_Option._elements.HDRDisplayGamma._sliderValueMax)
  setHdrDisplayGamma(value)
end
function PaGlobal_Option._functions.HDRDisplayMaxNits(value)
  value = PaGlobal_Option:FromSliderValueToRealValue(value, PaGlobal_Option._elements.HDRDisplayMaxNits._sliderValueMin, PaGlobal_Option._elements.HDRDisplayMaxNits._sliderValueMax)
  setHdrDisplayMaxNits(value)
end
function PaGlobal_Option._functions.UltraHighDefinition(value)
  _PA_LOG("\237\155\132\236\167\132", "UltraHighDefinition value : " .. tostring(value))
  setUltraHighDefinition(value)
end
function PaGlobal_Option._functions.UseLedAnimation(value)
  setUseLedAnimation(value)
end

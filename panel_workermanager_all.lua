PaGlobal_WorkerManager_All = {
  _panel = nil,
  _commonUI = {
    stc_ButtonBG = nil,
    stc_InfoBG = nil,
    stc_CommonButtonBG = nil,
    stc_WorkerInfoButtonBG = nil,
    stc_TitleBG = nil,
    stc_RightGroup = nil,
    stc_BottomGroup = nil,
    list_Worker = nil,
    stc_SortInfo = nil,
    btn_Reset = nil,
    btn_Fire = nil,
    btn_Promote = nil,
    btn_RestoreAll = nil,
    btn_RepeatAll = nil,
    btn_ResetUpgradeCnt = nil,
    btn_ImmediatlyComplete = nil,
    stc_WorkerSkillBg = nil,
    stc_UpgradeBg = nil,
    stc_DescBg = nil,
    stc_TabLine = nil,
    stc_WokerImageBG = nil,
    stc_WorkerImage = nil,
    txt_WorkerTitle = nil,
    txt_Node = nil,
    txt_WorkerState = nil,
    stc_RemainTimeProgressBg = nil,
    progress_RemainTimeProgress = nil,
    txt_WorkingNameCount = nil,
    txt_WorkingSpeedTitle = nil,
    txt_MovingSpeedTitle = nil,
    txt_LuckTitle = nil,
    txt_EnergyTitle = nil,
    txt_WorkingSpeedValue = nil,
    txt_MovingSpeedValue = nil,
    txt_LuckValue = nil,
    txt_EnergyValue = nil,
    tabText = {
      rdo_Command = nil,
      rdo_Skill = nil,
      rdo_Promote = nil
    },
    skillSlot = {},
    upgradeSlot = {},
    stc_RestoreItemBG = nil,
    btn_RestoreItemClose = nil,
    slider_RestoreSlider = nil,
    stc_GuideRestoreAll = nil,
    btn_SliderBtn = nil
  },
  _consoleUI = {
    stc_BottomBG = nil,
    keyGuide = {
      buttonX = nil,
      buttonA = nil,
      buttonB = nil
    }
  },
  _pcUI = {
    stc_TopBG = nil,
    btn_WorkRestore = nil,
    btn_RepeatWork = nil,
    btn_ChangeSkill = nil,
    btn_Close = nil,
    btn_PopUp = nil,
    btn_FireCheckedWorker = nil
  },
  _config = {
    _skillSlotCount = 8,
    _upgradeSlotCount = 3,
    _tab = {
      _Command = 0,
      _Skill = 1,
      _Promote = 2,
      _TabCount = 3
    },
    _workerGrade = {
      _Informal = 0,
      _Normal = 1,
      _Skilled = 2,
      _Expert = 3,
      _Master = 4,
      _All = 5
    },
    _workType = {
      _HouseCraft = 0,
      _LargeCraft = 1,
      _PlantWork = 2,
      _Building = 3,
      _RegionWork = 4,
      _upgrade = 5,
      _harvest = 6
    },
    _workerUpgradeTextureType = {
      _Fail = 0,
      _Upgradable = 1,
      _InActivation = 2
    },
    _workerGradeString = {
      [0] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_0"),
      [1] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_1"),
      [2] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_2"),
      [3] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_3"),
      [4] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_4"),
      [5] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL")
    },
    _workerTownString = {
      [0] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL")
    },
    _fontColor = {
      _upgrade_Inactivation = 4283587437,
      _upgrade_NormalLevel = 4294294074,
      _upgrade_NormalState = 4293848814,
      _upgrade_Fail = 4293848814
    }
  },
  _selectedTab = 0,
  _selectedWorker = 0,
  _filterTown = nil,
  _filterGrade = nil,
  _townList = {},
  _gradeList = {},
  _workerList = {},
  _workerCount = 0,
  _elapsedTime = 0,
  _isShowMessage = nil,
  _isPopUpContentsEnable = nil,
  _RTButtonCheck = false,
  _workerCheckList = {},
  _isWorkerChecked = false,
  _restoreItemMaxCount = 5,
  _restoreItemHasCount = 0,
  _restoreItemSlot = {},
  _sliderStartIdx = 0,
  _selectedUiIndex = nil,
  _startIndex = 1,
  _initialize = false
}
runLua("UI_Data/Script/Window/WorkerManager/Panel_WorkerManager_All_1.lua")
runLua("UI_Data/Script/Window/WorkerManager/Panel_WorkerManager_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_WorkerManager_All_Init")
function FromClient_WorkerManager_All_Init()
  PaGlobal_WorkerManager_All:initialize()
end

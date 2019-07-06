PaGlobal_DailyStamp_All = {
  _ui = {
    stc_mainTitleBg = nil,
    stc_centerBg = nil,
    stc_topBg = nil,
    txt_attendence = nil,
    stc_buttonGroup = nil,
    stc_buttonSlot = nil,
    txt_day = nil,
    stc_iconBG = nil,
    stc_stamp = nil,
    stc_bottomBg = nil,
    txt_eventPeriod = nil,
    txt_acceptPeriod = nil,
    txt_eventAlert = nil,
    txt_weekEndDesc = nil,
    stc_tabBar = nil
  },
  _ui_pc = {btn_close = nil, btn_tabTitle = nil},
  _ui_console = {
    stc_topBg = nil,
    stc_tabTitle = nil,
    stc_iconLB = nil,
    stc_iconRB = nil,
    stc_keyGuideBg = nil,
    stc_guideB = nil,
    stc_guideA = nil,
    stc_guideX = nil
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createClassEquipBG = true,
    createCash = true
  },
  _goodItemSlotConfig = {
    createIcon = true,
    createBorder = false,
    createCount = true,
    createClassEquipBG = true,
    createCash = true
  },
  _tabTitlePosition = {
    [1] = {415},
    [2] = {265, 565},
    [3] = {
      205,
      415,
      625
    }
  },
  _rewardCount = 35,
  _tabIndex = 1,
  _firstTabIndex = 1,
  _dayControl = {},
  _tabControl = {},
  _prevAttendanceCount = {},
  _animationTabIndex = nil,
  _animationdayIndex = {},
  _animationTime = 0,
  _nextDayShow = false,
  _secondAttendanceCheck = false,
  _attendanceTimeCheck = false,
  _isDailyChallengeShow = false,
  _yesterdayTabCount = 0,
  _dailyStampCount = 0,
  _dailyStampKeys = nil,
  _eventPeriodTxt = "",
  _acceptPeriodTxt = "",
  _keyGuideAlign = {},
  _initialize = false
}
runLua("UI_Data/Script/Window/DailyStamp/Panel_Window_DailyStamp_All_1.lua")
runLua("UI_Data/Script/Window/DailyStamp/Panel_Window_DailyStamp_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_DailyStamp_All_Init")
function FromClient_DailyStamp_All_Init()
  PaGlobal_DailyStamp_All:initialize()
end

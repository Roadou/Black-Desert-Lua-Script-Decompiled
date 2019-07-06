PaGlobal_WorkerAuction_All = {
  _ui = {
    _stc_TitleBg = nil,
    _stc_MainBg = nil,
    _btn_QuestionPC = nil,
    _btn_ClosePC = nil,
    _stc_RadioGroupBg = nil,
    _rdo_MarketList = nil,
    _rdo_Register = nil,
    _rdo_MyRegister = nil,
    _btn_LB_KeyGuide = nil,
    _btn_RB_KeyGuide = nil,
    _stc_PageBg = nil,
    _txt_PageValue = nil,
    _btn_LeftPage = nil,
    _btn_RightPage = nil,
    _btn_Left_KeyGuide = nil,
    _btn_Right_KeyGuide = nil,
    _stc_SelectBar = nil,
    _stc_ListSlotTemplete = nil,
    _stc_Bottom_KeyGuide = nil,
    _stc_A_KeyGuide = nil,
    _stc_B_KeyGuide = nil,
    _stc_X_KeyGuide = nil,
    _rdo_InvenMoney = nil,
    _rdo_WareMoney = nil,
    _txt_InvenMoney = nil,
    _txt_WareMoney = nil
  },
  _config = {
    _startX = 10,
    _startY = nil,
    _gapY = 8,
    _maxSlotCount = 4,
    _maxSkillCount = 7,
    _REGIST_WORKER_FEE = 30
  },
  _plantKey = nil,
  _workerAuctionInfo = nil,
  _slotList = {},
  _skillIconList = {},
  _radioTabList = {},
  _keyGuides = {},
  _selectedTab = nil,
  _selectedWorker = nil,
  _currentPage = 1,
  _maxPage = 1,
  _ENUMTABINDEX_MARKETLIST = 0,
  _ENUMTABINDEX_REGISTER = 1,
  _ENUMTABINDEX_MYREGISTER = 2,
  _TABCOLOR_SELECTED = Defines.Color.C_FFFFEDD4,
  _TABCOLOR_BASE = Defines.Color.C_FF585453,
  _COLOR_DISABLED = Defines.Color.C_FF5A5A5A,
  _COLOR_ACTIVE = Defines.Color.C_FFDDC39E,
  _COLOR_TIER_1 = Defines.Color.C_FFB9C2DC,
  _COLOR_TIER_2 = Defines.Color.C_FF83A543,
  _COLOR_TIER_3 = Defines.Color.C_FF438DCC,
  _COLOR_TIER_4 = Defines.Color.C_FFF5BA3A,
  _COLOR_TIER_5 = Defines.Color.C_FFD05D48,
  _initialize = false,
  _isConsole = false
}
runLua("UI_Data/Script/Window/Auction/Panel_Window_WorkerAuction_All_1.lua")
runLua("UI_Data/Script/Window/Auction/Panel_Window_WorkerAuction_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_WorkerAuction_All_Init")
function FromClient_WorkerAuction_All_Init()
  PaGlobal_WorkerAuction_All:initialize()
end

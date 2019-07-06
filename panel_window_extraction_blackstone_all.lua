PaGlobal_Extraction_Blackstone_All = {
  _ui = {
    stc_extractionSlot = nil,
    stc_resultSlot = nil,
    stc_leftBottomDese = nil,
    btn_skipAni = nil,
    list2_extractableItem = nil,
    stc_effectCircle = nil
  },
  _ui_pc = {
    btn_question = nil,
    btn_close = nil,
    btn_extraction = nil
  },
  _ui_console = {
    btn_extraction = nil,
    stc_bottomBtn = nil,
    btn_select = nil,
    btn_close = nil
  },
  _initialize = false,
  _isConsole = false,
  _isAniSkip = false,
  _targetWhereType = nil,
  _targetSlotNo = nil,
  _thisIsWeapone = nil,
  _currentTime = 0,
  _maxTime = 4,
  _slotConfig = {
    createIcon = false,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true
  },
  _equipCnt = 0,
  _equipNo = {},
  _itemInfo = {
    name = {},
    iconPath = {},
    slotNo = {},
    itemEnchantLevle = {},
    isExtractionEquip = {false}
  },
  _blackStoneCnt = 0,
  _listControl = {},
  _preSelectKey = nil,
  _curSelectKey = nil,
  _isAniStart = false,
  _isWeapon = false,
  _extractionEnchantStone_ResultShowTime = 0
}
runLua("UI_Data/Script/Window/BlackSmith/Panel_Window_Extraction_Blackstone_All_1.lua")
runLua("UI_Data/Script/Window/BlackSmith/Panel_Window_Extraction_Blackstone_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_Extraction_Blackstone_AllInit")
function FromClient_Extraction_Blackstone_AllInit()
  PaGlobal_Extraction_Blackstone_All:initialize()
end

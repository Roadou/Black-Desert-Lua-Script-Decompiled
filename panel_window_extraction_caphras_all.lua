PaGlobal_Extraction_Caphras_All = {
  _ui = {
    stc_extractableItemSlot = nil,
    stc_resultItmeSlot = nil,
    stc_moneyArea = nil,
    stc_moneyIcon = nil,
    stc_money = nil,
    btn_inven = nil,
    stc_invenMoney = nil,
    btn_warehouse = nil,
    stc_warehouseMoney = nil,
    stc_noticeDesc = nil,
    btn_aniSkip = nil,
    list2_extractableItem = nil
  },
  _ui_pc = {btn_close = nil, btn_extraction = nil},
  _ui_console = {
    stc_bottom = nil,
    btn_extraction = nil,
    btn_select = nil,
    btn_close = nil
  },
  _initialize = false,
  _isConsole = false,
  _isSkipAni = false,
  _caphrasCnt = nil,
  _scrollIdx = nil,
  _isAniStart = false,
  _const_ani_time = 3,
  _delta_ani_time = 0,
  _equipCnt = 0,
  _equipNo = {},
  _itemInfo = {
    name = {},
    iconPath = {},
    slotNo = {},
    itemEnchantLevle = {},
    isExtractionEquip = {false}
  },
  _fromWhereType = -1,
  _fromSlotNo = -1,
  _moneyWhereType = 0,
  _savedCount = 0,
  _resultWhereType = -1,
  _resultSlotNo = -1,
  _fromSlotOn = false,
  _resultSlotOn = false,
  _slotConfig = {
    createBorder = false,
    createCount = true,
    createCooltime = false,
    createCooltimeText = false,
    createCash = true,
    createEnchant = true,
    createQuickslotBagIcon = false
  },
  _preSelectKey = nil,
  _curSelectKey = nil,
  _listControl = {},
  _invenMoney,
  _warehouseMoney,
  _extractionPrice,
  _isNoMoney
}
runLua("UI_Data/Script/Window/BlackSmith/Panel_Window_Extraction_Caphras_All_1.lua")
runLua("UI_Data/Script/Window/BlackSmith/Panel_Window_Extraction_Caphras_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_Extraction_Caphras_AllInit")
function FromClient_Extraction_Caphras_AllInit()
  PaGlobal_Extraction_Caphras_All:initialize()
end

PaGlobal_Purification_All = {
  _ui = {
    _stc_Title = nil,
    _btn_Close_Pc = nil,
    _stc_MainBg = nil,
    _stc_ItemSlotBg = nil,
    _stc_ResultSlotBg = nil,
    _stc_DescBg = nil,
    _txt_EnchantBefore = nil,
    _txt_EnchantAfter = nil,
    _txt_SubDesc = nil,
    _stc_KeyGuide_X = nil,
    _btn_Purify_Pc = nil,
    _stc_BottomBg = nil,
    _txt_MainDesc = nil,
    _stc_Bottom_KeyGuides = nil,
    _stc_KeyGuide_Cancel = nil,
    _stc_KeyGuide_Select = nil,
    _btn_CheckAniSkip = nil,
    _btn_Radio_Inven = nil,
    _btn_Radio_Ware = nil,
    _txt_InvenMoney = nil,
    _txt_WareMoney = nil
  },
  _itemSlotBg_Icon = nil,
  _resultSlotBg_Icon = nil,
  _slotConfig = {
    createBorder = false,
    createCount = true,
    createCooltime = false,
    createCooltimeText = false,
    createCash = true,
    createEnchant = true,
    createQuickslotBagIcon = false
  },
  _keyGudieList = {},
  _fromWhereType = -1,
  _fromSlotIdx = -1,
  _fromSlotOn = false,
  _resultWhereType = -1,
  _resultSlotIdx = -1,
  _resultSlotOn = false,
  _purificationPrice = 100000,
  _moneyWhereType = -1,
  _isAniStart = false,
  _CONST_ANI_TIME = 3,
  _delta_ani_time = 0,
  _MAXBOTTOMBGSIZE = 130,
  _MAXPANELSIZEY = 840,
  _initialize = false,
  _isConsole = false
}
runLua("UI_Data/Script/Window/Purification/Panel_Window_Purification_All_1.lua")
runLua("UI_Data/Script/Window/Purification/Panel_Window_Purification_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_PurificationAllInit")
function FromClient_PurificationAllInit()
  PaGlobal_Purification_All:initialize()
end

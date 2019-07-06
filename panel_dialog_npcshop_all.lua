PaGlobal_NPCShop_ALL = {
  _ui = {
    _stc_TitleBg = nil,
    _stc_SubBg = nil,
    _pc = {
      _stc_TabGroup = nil,
      _btn_Close = nil,
      _btn_Question = nil,
      _btn_Radio_Buy = nil,
      _btn_Radio_Sell = nil,
      _btn_Radio_Repurchase = nil,
      _btn_Buy = nil,
      _btn_BuySome = nil,
      _btn_SellAll = nil
    },
    _console = {
      _stc_TabGroup_Console = nil,
      _btn_TabGroup_LT = nil,
      _btn_TabGroup_RT = nil,
      _btn_Radio_Buy_Console = nil,
      _btn_Radio_Sell_Console = nil,
      _btn_Radio_Repurchase_Console = nil,
      _stc_KeyGuide = nil,
      _stc_Key_Purchase = nil,
      _stc_Key_Purchase_All = nil,
      _stc_Key_Detail = nil,
      _stc_Key_Move = nil,
      _stc_Key_Cancel = nil
    },
    _stc_SelectBar = nil,
    _list2_Item_List = nil,
    _list2_Content = nil,
    _btn_Radio_LeftTemplete = nil,
    _btn_Radio_RightTemplete = nil,
    _stc_Scroll_Vertical = nil,
    _stc_Scroll_Horizontal = nil,
    _stc_player_Silver = nil,
    _btn_Check_Inven = nil,
    _btn_Check_Warehouse = nil,
    _txt_Silver_Inven = nil,
    _txt_Silver_Storage = nil,
    _stc_Guild_Silver = nil,
    _btn_Check_Inven_Guild = nil,
    _btn_Check_Warehouse_Guild = nil,
    _txt_Silver_Inven_Guild = nil,
    _txt_Silver_Storage_Guild = nil
  },
  _radioButton_Tab = {},
  _createdItemSlot = {},
  _keyGuideList = {},
  _config = {_slotCols = 2},
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = false,
    createCash = true,
    createEnchant = true,
    createEnduranceIcon = true
  },
  _pos = {_toolTipPosX = 0, _toolTipPosY = 0},
  _value = {
    _isCamping = false,
    _selectedSlotIndex = nil,
    _lastTabIndex = nil,
    _currentTabIndex = nil,
    _inputNumber = 0,
    _itemListSize = 0,
    _sellingItemKey = nil
  },
  _ENUMTABINDEXBUY = 0,
  _ENUMTABINDEXSELL = 1,
  _ENUMTABINDEXREBUY = 2,
  _CONST = Defines.s64_const,
  _UI_COLOR = Defines.Color,
  _TABCOLORBASE = Defines.Color.C_FF585453,
  _TABCOLORSELECTED = Defines.Color.C_FFFFEDD4,
  _COLORCANNOTBUY = Defines.Color.C_FFD05D48,
  _COLORCANBUY = Defines.Color.C_FFDDC39E,
  _PANALSIZEY_PC = 790,
  _SUBBGSIZEY_PC = 730,
  _PANALSIZEY_CONSOLE = 740,
  _SUBBGSIZEY_CONSOLE = 680,
  _NPCSHOP_BUYBTN_POSX = 0,
  _NPCSHOP_SELLBTN_POSX = 0,
  _isConsole = false,
  _initialize = false
}
runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_NPCShop_All_1.lua")
runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_NPCShop_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_NPCShopInit")
function FromClient_NPCShopInit()
  PaGlobal_NPCShop_ALL:initialize()
end

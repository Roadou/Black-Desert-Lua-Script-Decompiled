PaGlobal_MaidList_All = {
  _ui = {
    stc_title = nil,
    txt_noMaidFound = nil,
    txt_maidCount = nil,
    txt_maidCountValue = nil,
    list2_maid = nil,
    stc_tabBar = nil
  },
  _ui_pc = {
    btn_close = nil,
    stc_tabBg = nil,
    btn_radios = {},
    btn_warehouse = nil,
    btn_market = nil,
    btn_marketPlace = nil,
    btn_pcRoom = nil
  },
  _ui_console = {
    stc_tabBg = nil,
    rdo_tabs = {},
    stc_keyGuideLB = nil,
    stc_keyGuideRB = nil,
    stc_keyGuideAreaBg = nil,
    stc_selectA = nil,
    stc_cancleB = nil
  },
  _currentTab = 1,
  _maidData = nil,
  _isConsole = false,
  _initialize = false
}
runLua("UI_Data/Script/Widget/Maid/Panel_Window_MaidList_All_1.lua")
runLua("UI_Data/Script/Widget/Maid/Panel_Window_MaidList_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_PaGlobal_MaidList_All_Init")
function FromClient_PaGlobal_MaidList_All_Init()
  PaGlobal_MaidList_All:initialize()
end

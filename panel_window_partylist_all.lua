PaGlobal_PartyList_All = {
  _ui = {
    stc_titleBar = nil,
    stc_topBg = nil,
    edit_search = nil,
    btn_search = nil
  },
  _ui_pc = {
    btn_close = nil,
    btn_question = nil,
    btn_popUp = nil,
    btn_reload = nil,
    btn_recruite = nil,
    btn_reset = nil,
    stc_listTitleBg = nil,
    list2_party = nil
  },
  _ui_console = {
    stc_listTitleBg = nil,
    stc_bottomBg = nil,
    stc_Y_ConsoleUI = nil,
    stc_X_ConsoleUI = nil,
    stc_A_ConsoleUI = nil,
    stc_B_ConsoleUI = nil,
    stc_search_LT = nil,
    stc_search_X = nil,
    list2_party = nil
  },
  _canInvite = true,
  _enum = {
    eTYPE_RECRUITE_NONE = -1,
    eTYPE_RECRUITE = 0,
    eTYPE_RECRUITE_CANCEL = 1,
    eTYPE_CHANGE_SERVER = 2,
    eTYPE_ADVERTISING = 3,
    eALIGN_TYPE_LEFT = 0,
    eALIGN_TYPE_RIGHT = 1,
    eALIGN_TYPE_CENTER = 2
  },
  _string = {
    recruite = "",
    recruiteCancel = "",
    changeServer = ""
  },
  _keyGuideControl = {
    [__eConsoleUIPadEvent_A] = nil,
    [__eConsoleUIPadEvent_X] = nil
  },
  _keyGuideAlign = {},
  _partySortTable = {},
  _snappedOnThisPanel = false,
  _initialize = false
}
runLua("UI_Data/Script/Window/Party/Panel_Window_PartyList_All_1.lua")
runLua("UI_Data/Script/Window/Party/Panel_Window_PartyList_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_PaGlobal_PartyList_All_Init")
function FromClient_PaGlobal_PartyList_All_Init()
  PaGlobal_PartyList_All:initialize()
end

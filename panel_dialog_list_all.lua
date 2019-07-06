PaGlobal_DialogList_All = {
  _ui = {
    stc_title = nil,
    stc_mainBg = nil,
    txt_npcTitle = nil,
    frame_dialog = nil,
    frame_content = nil,
    frame_text = nil,
    frame_scroll = nil,
    stc_dialogGroup = nil,
    stc_dialogList = {},
    btn_dialogList = {},
    stc_splitTabBg = nil,
    btn_splitRadiolist = {},
    stc_selectBar = nil
  },
  _ui_pc = {
    stc_spaceBar = nil,
    stc_pageGroup = nil,
    btn_before = nil,
    btn_next = nil,
    txt_page = nil
  },
  _ui_console = {
    stc_bottomBg = nil,
    stc_iconA = nil,
    stc_iconB = nil,
    stc_iconLB = nil,
    stc_iconRB = nil
  },
  _dialogListCount = 0,
  _dialogMaxPage = 1,
  _dialogMaxCount = 10,
  _curPage = 1,
  _selectIndex = 0,
  _panelMinimumSizeX = 525,
  _panelMinimumSizeY = 210,
  _dialogSizeY = 55,
  _frameContentSizeY = 0,
  _isQuestComplete = false,
  _isAbleDisplayQuest = false,
  _isReContactDialog = false,
  _isQuestView = false,
  _isExchangeButtonIndex = {},
  _btnSplitString = {},
  _initialize = false
}
runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_List_All_1.lua")
runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_List_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_DialogList_All_Init")
function FromClient_DialogList_All_Init()
  PaGlobal_DialogList_All:initialize()
end

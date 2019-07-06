PaGlobal_Achievement_BookShelf = {
  _ui = {
    _stc_topArea = UI.getChildControl(Panel_Window_Achievement_BookShelf, "Static_TopArea"),
    _stc_centerArea = UI.getChildControl(Panel_Window_Achievement_BookShelf, "Static_CenterArea"),
    _stc_familyWidget = UI.getChildControl(Panel_Window_Achievement_BookShelf, "Static_FamilyStat_Widget")
  },
  _CHAPTER_ICON_CNT = 4,
  _BOOK_AREA_CNT = 4,
  _BOOK_POS_X = 15,
  _journalChapterCnt = 0,
  _journalGroupCnt = 0,
  _selectedJournalGroup = 1,
  _journalControlList = {},
  _initialize = false,
  _journalGroupIndexList = {},
  _MAX_CALLING_COUNT = 20,
  _BOOK_POS_Y = {
    [0] = 32,
    [1] = 175,
    [2] = 316,
    [3] = 456
  }
}
runLua("UI_Data/Script/Window/Achievement/Panel_Window_Achievement_BookShelf_1.lua")
runLua("UI_Data/Script/Window/Achievement/Panel_Window_Achievement_BookShelf_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_Achievement_BookShelf_Init")
function FromClient_Achievement_BookShelf_Init()
  PaGlobal_Achievement_BookShelf:initialize()
end

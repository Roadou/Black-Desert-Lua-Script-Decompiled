PaGlobal_Menu_Remake = {
  _ui = {},
  _hotKeyFunction = {},
  _headerHotKeyGroup = {},
  _headerHotKey = {},
  _headerMenuFunction = {},
  _customizeHeaderMenuGroup = {},
  _menuHotKeyGroup = {},
  _menuHotKey = {},
  _selectMenuIndex = 0,
  _subMenuHotKeyGroup = {},
  _searchResult = {},
  _searchResultGroup = {},
  _beforeSearchMenuMode = nil,
  _beforeSearchSelectedMenuIndex = 0,
  _beforeSearchSubMenuIndex = nil,
  _MAX_SUBMENU = 10,
  _MAX_HEADERMENU = 8,
  _MAX_LINE_SHOWHEADER = 8,
  _headerTitleGrid = {
    normal = {
      x1 = 52,
      y1 = 1,
      x2 = 102,
      y2 = 51
    },
    customize = {
      x1 = 307,
      y1 = 52,
      x2 = 357,
      y2 = 102
    },
    ddsUrl = "Combine/Frame/Combine_Frame_00.dds"
  },
  _headerGrid = {
    normal = {
      x1 = 370,
      y1 = 42,
      x2 = 410,
      y2 = 82
    },
    on = {
      x1 = 411,
      y1 = 42,
      x2 = 451,
      y2 = 82
    },
    ddsUrl = "Combine/Btn/Combine_Btn_00.dds"
  },
  _menuGrid = {
    normal = {
      x1 = 256,
      y1 = 1,
      x2 = 306,
      y2 = 51
    },
    on = {
      x1 = 307,
      y1 = 1,
      x2 = 357,
      y2 = 51
    },
    click = {
      x1 = 358,
      y1 = 1,
      x2 = 408,
      y2 = 51
    },
    ddsUrl = "Combine/Frame/Combine_Frame_00.dds"
  },
  _subMenuGrid = {
    normal = {
      x1 = 460,
      y1 = 154,
      x2 = 510,
      y2 = 204
    },
    on = {
      x1 = 307,
      y1 = 1,
      x2 = 357,
      y2 = 51
    },
    ddsUrl = "Combine/Frame/Combine_Frame_00.dds"
  },
  _searchMenuGrid = {
    normal = {
      x1 = 256,
      y1 = 1,
      x2 = 306,
      y2 = 51
    },
    on = {
      x1 = 307,
      y1 = 1,
      x2 = 357,
      y2 = 51
    },
    ddsUrl = "Combine/Frame/Combine_Frame_00.dds"
  },
  _nowMenuMode = "",
  _nowMenuIndex = 0,
  _nowSelectedMenuIndex = 0,
  _CONFIRM_KEY = CppEnums.VirtualKeyCode.KeyCode_RETURN,
  _SEARCH_KEY = CppEnums.VirtualKeyCode.KeyCode_TAB,
  _ARROW_KEY = {
    CppEnums.VirtualKeyCode.KeyCode_LEFT,
    CppEnums.VirtualKeyCode.KeyCode_UP,
    CppEnums.VirtualKeyCode.KeyCode_RIGHT,
    CppEnums.VirtualKeyCode.KeyCode_DOWN
  },
  _isCustomizeMode = false,
  _selected_customize_headerIndex = 0,
  _isLeft = true,
  _contentsGroup = {
    _isPearlOpen = CppEnums.ContentsServiceType.eContentsServiceType_Commercial == getContentsServiceType() and not _isTestServer,
    _isLocalwarOpen = ToClient_IsContentsGroupOpen("43"),
    _isBlackSpiritAdventure = ToClient_IsContentsGroupOpen("1015"),
    _isBlackSpiritAdventureForPc = ToClient_IsContentsGroupOpen("1021"),
    _webAlbumOpen = _ContentsGroup_webAlbumOpen,
    _photoGalleryOpen = ToClient_IsContentsGroupOpen("213"),
    _remoteControlOpen = ToClient_IsContentsGroupOpen("241"),
    _isTradeEventOpen = ToClient_IsContentsGroupOpen("26"),
    _joinCheckOpen = ToClient_IsContentsGroupOpen("1025"),
    _isMercenaryOpen = ToClient_IsContentsGroupOpen("245"),
    _isMonsterRanking = ToClient_IsContentsGroupOpen("275"),
    _isSavageOpen = ToClient_IsContentsGroupOpen("249"),
    _isContentsArsha = ToClient_IsContentsGroupOpen("227"),
    _partyListOpen = ToClient_IsContentsGroupOpen("254"),
    _isFreeFight = ToClient_IsContentsGroupOpen("255"),
    _isBlackSpiritAdventure2 = ToClient_IsContentsGroupOpen("277"),
    _isMasterpieceOpen = ToClient_IsContentsGroupOpen("270"),
    _isSiegeEnable = ToClient_IsContentsGroupOpen("21"),
    _isMemoOpen = _ContentsGroup_isMemoOpen,
    _isDropItemOpen = ToClient_IsContentsGroupOpen("337"),
    _isTeamDuelOpen = ToClient_IsContentsGroupOpen("350"),
    _isButtonShortCut = ToClient_IsContentsGroupOpen("351"),
    _isBlackDesertLab = _ContentsGroup_BlackDesertLab or 0 == getServiceNationType(),
    _isTestServer = isGameTypeGT(),
    _isExpeditionOpen = _ContentsGroup_Expedition,
    _isAchievementBookshelfOpen = _ContentsGroup_AchievementQuest,
    _isRedDesert = _ContentsGroup_RedDesert,
    _isMarketPlaceOpen = _ContentsGroup_RenewUI_ItemMarketPlace,
    _isBattleFieldVolunteer = _ContentsGroup_BattleFieldVolunteer,
    _isFairyOpen = _ContentsGroup_isFairy,
    _isAlchemyStoneEnble = ToClient_IsContentsGroupOpen("35"),
    _isAlchemyFigureHeadEnble = ToClient_IsContentsGroupOpen("44"),
    _isInfinityDefence = _ContentsGroup_InfinityDefence
  },
  _conditionGroup = {},
  numberKeySetting = {
    [1] = CppEnums.VirtualKeyCode.KeyCode_1,
    [2] = CppEnums.VirtualKeyCode.KeyCode_2,
    [3] = CppEnums.VirtualKeyCode.KeyCode_3,
    [4] = CppEnums.VirtualKeyCode.KeyCode_4,
    [5] = CppEnums.VirtualKeyCode.KeyCode_5,
    [6] = CppEnums.VirtualKeyCode.KeyCode_6,
    [7] = CppEnums.VirtualKeyCode.KeyCode_7,
    [8] = CppEnums.VirtualKeyCode.KeyCode_8,
    [9] = CppEnums.VirtualKeyCode.KeyCode_9,
    [10] = CppEnums.VirtualKeyCode.KeyCode_0
  },
  numberPadKeySetting = {
    [1] = CppEnums.VirtualKeyCode.KeyCode_NUMPAD1,
    [2] = CppEnums.VirtualKeyCode.KeyCode_NUMPAD2,
    [3] = CppEnums.VirtualKeyCode.KeyCode_NUMPAD3,
    [4] = CppEnums.VirtualKeyCode.KeyCode_NUMPAD4,
    [5] = CppEnums.VirtualKeyCode.KeyCode_NUMPAD5,
    [6] = CppEnums.VirtualKeyCode.KeyCode_NUMPAD6,
    [7] = CppEnums.VirtualKeyCode.KeyCode_NUMPAD7,
    [8] = CppEnums.VirtualKeyCode.KeyCode_NUMPAD8,
    [9] = CppEnums.VirtualKeyCode.KeyCode_NUMPAD9,
    [10] = CppEnums.VirtualKeyCode.KeyCode_NUMPAD0
  },
  _keyString = {
    [CppEnums.VirtualKeyCode.KeyCode_ESCAPE] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Esc"),
    [CppEnums.VirtualKeyCode.KeyCode_F1] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F1"),
    [CppEnums.VirtualKeyCode.KeyCode_F2] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F2"),
    [CppEnums.VirtualKeyCode.KeyCode_F3] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F3"),
    [CppEnums.VirtualKeyCode.KeyCode_F4] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F4"),
    [CppEnums.VirtualKeyCode.KeyCode_F5] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F5"),
    [CppEnums.VirtualKeyCode.KeyCode_F6] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F6"),
    [CppEnums.VirtualKeyCode.KeyCode_F7] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F7"),
    [CppEnums.VirtualKeyCode.KeyCode_F8] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F8"),
    [CppEnums.VirtualKeyCode.KeyCode_F9] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F9"),
    [CppEnums.VirtualKeyCode.KeyCode_F10] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F10"),
    [CppEnums.VirtualKeyCode.KeyCode_F11] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F11"),
    [CppEnums.VirtualKeyCode.KeyCode_F12] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F12"),
    [CppEnums.VirtualKeyCode.KeyCode_1] = "1",
    [CppEnums.VirtualKeyCode.KeyCode_2] = "2",
    [CppEnums.VirtualKeyCode.KeyCode_3] = "3",
    [CppEnums.VirtualKeyCode.KeyCode_4] = "4",
    [CppEnums.VirtualKeyCode.KeyCode_5] = "5",
    [CppEnums.VirtualKeyCode.KeyCode_6] = "6",
    [CppEnums.VirtualKeyCode.KeyCode_7] = "7",
    [CppEnums.VirtualKeyCode.KeyCode_8] = "8",
    [CppEnums.VirtualKeyCode.KeyCode_9] = "9",
    [CppEnums.VirtualKeyCode.KeyCode_0] = "0",
    [CppEnums.VirtualKeyCode.KeyCode_NUMPAD1] = "1",
    [CppEnums.VirtualKeyCode.KeyCode_NUMPAD2] = "2",
    [CppEnums.VirtualKeyCode.KeyCode_NUMPAD3] = "3",
    [CppEnums.VirtualKeyCode.KeyCode_NUMPAD4] = "4",
    [CppEnums.VirtualKeyCode.KeyCode_NUMPAD5] = "5",
    [CppEnums.VirtualKeyCode.KeyCode_NUMPAD6] = "6",
    [CppEnums.VirtualKeyCode.KeyCode_NUMPAD7] = "7",
    [CppEnums.VirtualKeyCode.KeyCode_NUMPAD8] = "8",
    [CppEnums.VirtualKeyCode.KeyCode_NUMPAD9] = "9",
    [CppEnums.VirtualKeyCode.KeyCode_NUMPAD0] = "0",
    [CppEnums.VirtualKeyCode.KeyCode_TAB] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Tab"),
    [CppEnums.VirtualKeyCode.KeyCode_Q] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Q"),
    [CppEnums.VirtualKeyCode.KeyCode_W] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_W"),
    [CppEnums.VirtualKeyCode.KeyCode_E] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_E"),
    [CppEnums.VirtualKeyCode.KeyCode_R] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_R"),
    [CppEnums.VirtualKeyCode.KeyCode_T] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_T"),
    [CppEnums.VirtualKeyCode.KeyCode_Y] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Y"),
    [CppEnums.VirtualKeyCode.KeyCode_U] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_U"),
    [CppEnums.VirtualKeyCode.KeyCode_I] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_I"),
    [CppEnums.VirtualKeyCode.KeyCode_O] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_O"),
    [CppEnums.VirtualKeyCode.KeyCode_P] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_P"),
    [CppEnums.VirtualKeyCode.KeyCode_A] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_A"),
    [CppEnums.VirtualKeyCode.KeyCode_S] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_S"),
    [CppEnums.VirtualKeyCode.KeyCode_D] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_D"),
    [CppEnums.VirtualKeyCode.KeyCode_F] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_F"),
    [CppEnums.VirtualKeyCode.KeyCode_G] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_G"),
    [CppEnums.VirtualKeyCode.KeyCode_H] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_H"),
    [CppEnums.VirtualKeyCode.KeyCode_J] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_J"),
    [CppEnums.VirtualKeyCode.KeyCode_K] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_K"),
    [CppEnums.VirtualKeyCode.KeyCode_L] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_L"),
    [CppEnums.VirtualKeyCode.KeyCode_RETURN] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Enter"),
    [CppEnums.VirtualKeyCode.KeyCode_SHIFT] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Shift"),
    [CppEnums.VirtualKeyCode.KeyCode_Z] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Z"),
    [CppEnums.VirtualKeyCode.KeyCode_X] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_X"),
    [CppEnums.VirtualKeyCode.KeyCode_C] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_C"),
    [CppEnums.VirtualKeyCode.KeyCode_V] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_V"),
    [CppEnums.VirtualKeyCode.KeyCode_B] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_B"),
    [CppEnums.VirtualKeyCode.KeyCode_N] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_N"),
    [CppEnums.VirtualKeyCode.KeyCode_M] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_M"),
    [CppEnums.VirtualKeyCode.KeyCode_SHIFT] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Shift"),
    [CppEnums.VirtualKeyCode.KeyCode_SPACE] = PAGetString(Defines.StringSheet_GAME, "InputCustomizer_Space")
  },
  DEFAULT_HEADER_MENU_INDEX = {
    1,
    14,
    16,
    57,
    59,
    76,
    75,
    74
  },
  UIOPTION_TYPE_MENU = {
    [1] = __eRemakeMenu0,
    [2] = __eRemakeMenu1,
    [3] = __eRemakeMenu2,
    [4] = __eRemakeMenu3,
    [5] = __eRemakeMenu4,
    [6] = __eRemakeMenu5,
    [7] = __eRemakeMenu6,
    [8] = __eRemakeMenu7
  },
  DEFAULT_MENU_DDS = "combine/etc/combine_etc_escmenu_00.dds"
}
runLua("UI_Data/Script/Widget/Menu/Panel_Widget_Menu_Remake_1.lua")
runLua("UI_Data/Script/Widget/Menu/Panel_Widget_Menu_Remake_2.lua")
runLua("UI_Data/Script/Widget/Menu/Panel_Widget_Menu_Remake_3.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_Menu_RemakeInit")
function FromClient_Menu_RemakeInit()
  PaGlobal_Menu_Remake:initialize()
end

PaGlobal_LifeRanking_All = {
  _ui = {
    stc_TitleBG = nil,
    btn_Close = nil,
    btn_Question = nil,
    stc_RankingTypeBG = nil,
    stc_KeyGuideLB = nil,
    stc_KeyGuideRB = nil,
    stc_RankingIcons = {},
    txt_CurRankingTypeTitle = nil,
    stc_LeftBG = nil,
    stc_GradeBG = nil,
    stc_CurRankingIconBG = nil,
    txt_CurRankingGradeValue = nil,
    txt_CurRankingType = nil,
    stc_GradeBar = nil,
    stc_GradeBarArrow = nil,
    txt_CurRankingDesc = nil,
    stc_MyRanking = nil,
    txt_MyRanking_Title = {},
    txt_MyRanking_Value = {},
    stc_ListTitleBG = nil,
    txt_CharacterNameTitle = nil,
    list2_Ranking = nil,
    txt_Comment = nil,
    stc_BottomBG = nil,
    txt_KeyGuide_A = nil,
    txt_KeyGuide_B = nil,
    tooltipBG = nil,
    tooltipName = nil,
    tooltipDesc = nil
  },
  _MAX_RANKTYPE_COUNT = 13,
  _tabName = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_GATHER"),
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_FISH"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_HUNT"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_COOK"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_ALCHEMY"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_MANUFACTURE"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_HORSE"),
    [7] = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_TRADE"),
    [8] = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_GROWTH"),
    [9] = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_TAB_SAIL"),
    [10] = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_WEALTH"),
    [11] = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_COMBAT"),
    [12] = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_LOCALWAR"),
    [13] = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_NAK_PVPMATCH_NAME")
  },
  _rankTypeName = {
    [0] = "GATHERING",
    "FISHING",
    "HUNT",
    "COOK",
    "ALCHEMY",
    "CRAFTING",
    "TRAINING",
    "TRADE",
    "FARMING",
    "SAILING",
    "WEALTH",
    "GROWTH",
    "REDWAR"
  },
  _listUpdate = {
    [0] = false,
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = false,
    [10] = false,
    [11] = false,
    [12] = false,
    [13] = false
  },
  _rankIconTextureUV = {
    [0] = {
      _x1 = 130,
      _y1 = 1,
      _x2 = 165,
      _y2 = 31
    },
    [1] = {
      _x1 = 130,
      _y1 = 32,
      _x2 = 165,
      _y2 = 62
    },
    [2] = {
      _x1 = 130,
      _y1 = 63,
      _x2 = 165,
      _y2 = 93
    }
  },
  _keyGuideGroup = {},
  _rankerData = {},
  _selectedTabIdx = 0,
  _listCount = nil,
  _rankTitleGapSizeY = 40,
  _defaultTooltipSizeX = 0,
  _initialize = false,
  _serverChange = true,
  _gradeFontColor = {
    A = Defines.Color.C_FFD05D48,
    B = Defines.Color.C_FFF5BA3A,
    C = Defines.Color.C_FF83A543,
    D = Defines.Color.C_FF4898D0,
    E = Defines.Color.C_FFB9C2DC
  },
  _rankFontColor = {
    [0] = Defines.Color.C_FFFFDD00,
    [1] = Defines.Color.C_FFD7E6F4,
    [2] = Defines.Color.C_FFF5BA3A
  },
  _defaultFontColor = Defines.Color.C_FFDDC39E
}
runLua("UI_Data/Script/Window/LifeRanking/Panel_LifeRanking_All_1.lua")
runLua("UI_Data/Script/Window/LifeRanking/Panel_LifeRanking_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_LifeRanking_All_Init")
function FromClient_LifeRanking_All_Init()
  PaGlobal_LifeRanking_All:initialize()
end

local UI_TYPE = CppEnums.PA_UI_CONTROL_TYPE
local ENT = CppEnums.ExplorationNodeType
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local __existMentalInfo = {
  [1] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 38,
    y1 = 197,
    x2 = 74,
    y2 = 233
  },
  [5001] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 1,
    y1 = 197,
    x2 = 37,
    y2 = 233
  },
  [10001] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 75,
    y1 = 197,
    x2 = 111,
    y2 = 233
  },
  [20001] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 75,
    y1 = 197,
    x2 = 111,
    y2 = 233
  },
  [25001] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 75,
    y1 = 197,
    x2 = 111,
    y2 = 233
  },
  [30001] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 112,
    y1 = 197,
    x2 = 148,
    y2 = 233
  }
}
local __extraMentalInfo = {
  [4] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [9] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [45] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 475,
    y1 = 38,
    x2 = 511,
    y2 = 74
  },
  [43] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 475,
    y1 = 38,
    x2 = 511,
    y2 = 74
  },
  [61] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 475,
    y1 = 38,
    x2 = 511,
    y2 = 74
  },
  [16] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [38] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [34] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [60] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [386] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [388] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [109] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [103] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [104] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [116] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [127] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [139] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [150] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [181] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [153] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [155] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [156] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [166] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [167] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [169] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [344] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 475,
    y1 = 38,
    x2 = 511,
    y2 = 74
  },
  [354] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [351] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [399] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [400] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [482] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [483] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [484] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [350] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [337] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [340] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [333] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [465] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [467] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [470] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [414] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [419] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [430] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [440] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [444] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [451] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [454] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [458] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [461] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [457] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [314] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [327] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [329] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [183] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [113] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [182] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [381] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [464] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [421] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [450] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [733] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [864] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [597] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [632] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [968] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [903] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [1064] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [1001] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [1044] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [1088] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [1156] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [1234] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [593] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [628] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [749] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [667] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [697] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [732] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [740] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [891] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [958] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [902] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [971] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [1063] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [1013] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [879] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [1026] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [878] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [865] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [1051] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [1111] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [1146] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [1149] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [1165] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [1241] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [1257] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [1286] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [587] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [622] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [656] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [669] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [671] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [1235] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [582] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [617] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [826] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [651] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [661] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [677] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [685] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [695] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [639] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [1090] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [496] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 401,
    y1 = 1,
    x2 = 437,
    y2 = 37
  },
  [497] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 401,
    y1 = 1,
    x2 = 437,
    y2 = 37
  },
  [613] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 401,
    y1 = 1,
    x2 = 437,
    y2 = 37
  },
  [11] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 401,
    y1 = 1,
    x2 = 437,
    y2 = 37
  },
  [877] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 401,
    y1 = 1,
    x2 = 437,
    y2 = 37
  },
  [1094] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 401,
    y1 = 1,
    x2 = 437,
    y2 = 37
  },
  [1102] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 1,
    x2 = 363,
    y2 = 37
  },
  [1105] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [1111] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [1109] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [1104] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [1106] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 290,
    y1 = 75,
    x2 = 326,
    y2 = 111
  },
  [1126] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 112,
    x2 = 363,
    y2 = 148
  },
  [1359] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 75,
    x2 = 363,
    y2 = 111
  },
  [1284] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 253,
    y1 = 149,
    x2 = 289,
    y2 = 185
  }
}
local __npcType = {
  [1] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 327,
    y1 = 38,
    x2 = 363,
    y2 = 74
  },
  [2] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 253,
    y1 = 75,
    x2 = 289,
    y2 = 111
  },
  [3] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 290,
    y1 = 1,
    x2 = 326,
    y2 = 37
  },
  [4] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 290,
    y1 = 38,
    x2 = 326,
    y2 = 74
  },
  [5] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 290,
    y1 = 75,
    x2 = 326,
    y2 = 111
  },
  [6] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 290,
    y1 = 112,
    x2 = 326,
    y2 = 148
  },
  [7] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 253,
    y1 = 1,
    x2 = 289,
    y2 = 37
  },
  [8] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 253,
    y1 = 38,
    x2 = 289,
    y2 = 74
  },
  [10] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 253,
    y1 = 149,
    x2 = 289,
    y2 = 185
  },
  [14] = {
    _text = "New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds",
    x1 = 401,
    y1 = 1,
    x2 = 437,
    y2 = 37
  }
}
function FromClient_CreateKnowledge(knowledgeStatic)
  local mentalCardStaticWrapper = knowledgeStatic:FromClient_getKnowledgeInfo()
  local isUniqueTexture = false
  local textureData = __existMentalInfo[mentalCardStaticWrapper:getMainThemeKeyRaw()]
  if nil == textureData then
    textureData = __existMentalInfo[1]
  end
  local extraTextureData = __extraMentalInfo[mentalCardStaticWrapper:getKey()]
  if nil ~= extraTextureData then
    textureData = extraTextureData
    isUniqueTexture = true
  end
  local npcShopType = __npcType[mentalCardStaticWrapper:getOwnerNpcShopType()]
  if nil ~= npcShopType then
    textureData = npcShopType
    isUniqueTexture = true
  end
  knowledgeStatic:ChangeTextureInfoName(textureData._text)
  local x1, y1, x2, y2 = setTextureUV_Func(knowledgeStatic, textureData.x1, textureData.y1, textureData.x2, textureData.y2)
  knowledgeStatic:getBaseTexture():setUV(x1, y1, x2, y2)
  knowledgeStatic:setRenderTexture(knowledgeStatic:getBaseTexture())
  local uiHintStatic = knowledgeStatic:FromClient_getKnowledgeHint()
  local uiHintQuestionStatic = knowledgeStatic:FromClient_getKnowledgeHintQuestion()
  if mentalCardStaticWrapper:isHasCard() then
    if isUniqueTexture then
      knowledgeStatic:SetMonoTone(false)
      knowledgeStatic:SetColor(UI_color.C_FFFFFFFF)
    else
      knowledgeStatic:SetMonoTone(false)
      knowledgeStatic:SetColor(UI_color.C_FF40D7FD)
    end
    uiHintQuestionStatic:ChangeTextureInfoName("New_UI_Common_ForLua/Default/Default_Etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(uiHintQuestionStatic, 102, 60, 110, 68)
    uiHintQuestionStatic:getBaseTexture():setUV(x1, y1, x2, y2)
    uiHintQuestionStatic:setRenderTexture(uiHintQuestionStatic:getBaseTexture())
    uiHintStatic:SetText(mentalCardStaticWrapper:getName())
  else
    if isUniqueTexture then
      knowledgeStatic:SetMonoTone(true)
      knowledgeStatic:SetColor(UI_color.C_88FFFFFF)
    else
      knowledgeStatic:SetMonoTone(false)
      knowledgeStatic:SetColor(UI_color.C_88FFFFFF)
    end
    uiHintQuestionStatic:SetAlpha(1)
    uiHintQuestionStatic:ChangeTextureInfoName("New_UI_Common_ForLua/Widget/WorldMap/WorldMap_Etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(uiHintQuestionStatic, 130, 128, 156, 163)
    uiHintQuestionStatic:getBaseTexture():setUV(x1, y1, x2, y2)
    uiHintQuestionStatic:setRenderTexture(uiHintQuestionStatic:getBaseTexture())
    uiHintStatic:SetTextMode(UI_TM.eTextMode_AutoWrap)
    uiHintStatic:SetText(mentalCardStaticWrapper:getKeyword())
    uiHintStatic:SetSize(uiHintStatic:GetSizeX(), uiHintStatic:GetTextSizeY() + 20)
  end
  uiHintStatic:SetSize(uiHintStatic:GetTextSizeX() + 40, uiHintStatic:GetSizeY())
  uiHintStatic:SetShow(false)
  uiHintQuestionStatic:SetShow(true)
end
function FromClient_OnWorldMapKnowledge(knowledgeStatic)
  local uiHintStatic = knowledgeStatic:FromClient_getKnowledgeHint()
  local uiHintQuestionStatic = knowledgeStatic:FromClient_getKnowledgeHintQuestion()
  uiHintStatic:SetShow(true)
  uiHintQuestionStatic:SetAlpha(0)
  if isLuaLoadingComplete then
  end
end
function FromClient_OutWorldMapKnowledge(knowledgeStatic)
  local uiHintStatic = knowledgeStatic:FromClient_getKnowledgeHint()
  local uiHintQuestionStatic = knowledgeStatic:FromClient_getKnowledgeHintQuestion()
  uiHintStatic:SetShow(false)
  uiHintQuestionStatic:SetAlpha(1)
  if isLuaLoadingComplete then
    TooltipSimple_Hide()
  end
end
function FGlobal_AddEffect_WorldmapKnowledge(knowledgeStaticKeyRaw)
  local uiKnowledgeStatic = Toclient_FindUiKnowledgeStaticByKeyRaw(knowledgeStaticKeyRaw)
  if nil ~= uiKnowledgeStatic then
    uiKnowledgeStatic:EraseAllEffect()
    uiKnowledgeStatic:AddEffect("UI_ItemInstall", true, 0, 0)
    uiKnowledgeStatic:AddEffect("UI_ArrowMark02", true, 0, -40)
  end
end
registerEvent("FromClient_CreateKnowledge", "FromClient_CreateKnowledge")
registerEvent("FromClient_OnWorldMapKnowledge", "FromClient_OnWorldMapKnowledge")
registerEvent("FromClient_OutWorldMapKnowledge", "FromClient_OutWorldMapKnowledge")

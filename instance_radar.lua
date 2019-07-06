Instance_Radar:SetIgnore(true)
Instance_Radar:setGlassBackground(true)
Instance_Radar:RegisterShowEventFunc(true, "RadarShowAni()")
Instance_Radar:RegisterShowEventFunc(false, "RadarHideAni()")
local radarType = {
  radarType_none = 0,
  radarType_hide = 1,
  radarType_allymonster = 2,
  radarType_normalMonster = 3,
  radarType_namedMonster = 4,
  radarType_bossMonster = 5,
  radarType_normalMonsterQuestTarget = 6,
  radarType_namedMonsterQuestTarget = 7,
  radarType_bossMonsterQuestTarget = 8,
  radarType_lordManager = 9,
  radarType_skillTrainner = 10,
  radarType_tradeMerchantNpc = 11,
  radarType_nodeManager = 12,
  radarType_normalNpc = 13,
  radarType_warehouseNpc = 14,
  radarType_potionNpc = 15,
  radarType_weaponNpc = 16,
  radarType_horseNpc = 17,
  radarType_workerNpc = 18,
  radarType_jewelNpc = 19,
  radarType_furnitureNpc = 20,
  radarType_collectNpc = 21,
  radarType_shipNpc = 22,
  radarType_alchemyNpc = 23,
  radarType_fishNpc = 24,
  radarType_guild = 25,
  radarType_guildShop = 26,
  radarType_itemTrader = 27,
  radarType_TerritorySupply = 28,
  radarType_TerritoryTrade = 29,
  radarType_Cook = 30,
  radarType_Wharf = 31,
  radarType_itemRepairer = 32,
  radarType_shopMerchantNpc = 33,
  radarType_ImportantNpc = 34,
  radarType_QuestAcceptable = 35,
  radarType_QuestProgress = 36,
  radarType_QuestComplete = 37,
  radarType_unknownNpc = 38,
  radarType_partyMember = 39,
  radarType_guildMember = 40,
  radarType_normalPlayer = 41,
  radarType_isHorse = 42,
  radarType_isDonkey = 43,
  radarType_isCamel = 44,
  radarType_isElephant = 45,
  radarType_isBabyElePhant = 46,
  radarType_isShip = 47,
  radarType_isCarriage = 48,
  radarType_installation = 49,
  radarType_kingGuildTent = 50,
  radarType_lordGuildTent = 51,
  radarType_villageGuildTent = 52,
  radarType_selfDeadBody = 53,
  radarType_advancedBase = 54,
  radarType_Raft = 55,
  radarType_Boat = 56,
  radarType_FishingBoat = 57,
  radarType_PersonalTradeShip = 58,
  radarType_GalleyShip = 59,
  radarType_PersonalBattleShip = 60,
  radarType_huntingMonster = 61,
  radarType_huntingMonsterQuestTarget = 62,
  radarType_Count = 63
}
local template = {
  [radarType.radarType_none] = nil,
  [radarType.radarType_hide] = UI.getChildControl(Instance_Radar, "icon_hide"),
  [radarType.radarType_allymonster] = UI.getChildControl(Instance_Radar, "icon_horse"),
  [radarType.radarType_normalMonster] = UI.getChildControl(Instance_Radar, "icon_monsterGeneral_normal"),
  [radarType.radarType_namedMonster] = UI.getChildControl(Instance_Radar, "icon_monsterNamed_normal"),
  [radarType.radarType_bossMonster] = UI.getChildControl(Instance_Radar, "icon_monsterBoss_normal"),
  [radarType.radarType_normalMonsterQuestTarget] = UI.getChildControl(Instance_Radar, "icon_monsterGeneral_quest"),
  [radarType.radarType_namedMonsterQuestTarget] = UI.getChildControl(Instance_Radar, "icon_monsterNamed_quest"),
  [radarType.radarType_bossMonsterQuestTarget] = UI.getChildControl(Instance_Radar, "icon_monsterBoss_quest"),
  [radarType.radarType_lordManager] = UI.getChildControl(Instance_Radar, "icon_npc_lordManager"),
  [radarType.radarType_skillTrainner] = UI.getChildControl(Instance_Radar, "icon_npc_skillTrainner"),
  [radarType.radarType_tradeMerchantNpc] = UI.getChildControl(Instance_Radar, "icon_npc_trader"),
  [radarType.radarType_nodeManager] = UI.getChildControl(Instance_Radar, "icon_npc_nodeManager"),
  [radarType.radarType_normalNpc] = nil,
  [radarType.radarType_warehouseNpc] = UI.getChildControl(Instance_Radar, "icon_npc_warehouse"),
  [radarType.radarType_potionNpc] = UI.getChildControl(Instance_Radar, "icon_npc_potion"),
  [radarType.radarType_weaponNpc] = UI.getChildControl(Instance_Radar, "icon_npc_storeArmor"),
  [radarType.radarType_horseNpc] = UI.getChildControl(Instance_Radar, "icon_npc_horse"),
  [radarType.radarType_workerNpc] = UI.getChildControl(Instance_Radar, "icon_npc_worker"),
  [radarType.radarType_jewelNpc] = UI.getChildControl(Instance_Radar, "icon_npc_jewel"),
  [radarType.radarType_furnitureNpc] = UI.getChildControl(Instance_Radar, "icon_npc_furniture"),
  [radarType.radarType_collectNpc] = UI.getChildControl(Instance_Radar, "icon_npc_collect"),
  [radarType.radarType_shipNpc] = UI.getChildControl(Instance_Radar, "icon_npc_ship"),
  [radarType.radarType_alchemyNpc] = UI.getChildControl(Instance_Radar, "icon_npc_alchemy"),
  [radarType.radarType_fishNpc] = UI.getChildControl(Instance_Radar, "icon_npc_fish"),
  [radarType.radarType_guild] = UI.getChildControl(Instance_Radar, "icon_npc_guild"),
  [radarType.radarType_guildShop] = UI.getChildControl(Instance_Radar, "icon_npc_guildShop"),
  [radarType.radarType_itemTrader] = UI.getChildControl(Instance_Radar, "icon_npc_itemTrader"),
  [radarType.radarType_TerritorySupply] = UI.getChildControl(Instance_Radar, "icon_npc_territorySupply"),
  [radarType.radarType_TerritoryTrade] = UI.getChildControl(Instance_Radar, "icon_npc_territoryTrade"),
  [radarType.radarType_Cook] = UI.getChildControl(Instance_Radar, "icon_npc_cook"),
  [radarType.radarType_Wharf] = UI.getChildControl(Instance_Radar, "icon_npc_wharf"),
  [radarType.radarType_itemRepairer] = UI.getChildControl(Instance_Radar, "icon_npc_repairer"),
  [radarType.radarType_shopMerchantNpc] = UI.getChildControl(Instance_Radar, "icon_npc_shop"),
  [radarType.radarType_ImportantNpc] = UI.getChildControl(Instance_Radar, "icon_npc_important"),
  [radarType.radarType_QuestAcceptable] = UI.getChildControl(Instance_Radar, "icon_quest_accept"),
  [radarType.radarType_QuestProgress] = UI.getChildControl(Instance_Radar, "icon_quest_doing"),
  [radarType.radarType_QuestComplete] = UI.getChildControl(Instance_Radar, "icon_quest_clear"),
  [radarType.radarType_unknownNpc] = UI.getChildControl(Instance_Radar, "icon_npc_unknown"),
  [radarType.radarType_partyMember] = UI.getChildControl(Instance_Radar, "icon_partyMember"),
  [radarType.radarType_guildMember] = UI.getChildControl(Instance_Radar, "icon_guildMember"),
  [radarType.radarType_normalPlayer] = UI.getChildControl(Instance_Radar, "icon_player"),
  [radarType.radarType_isHorse] = UI.getChildControl(Instance_Radar, "icon_horse"),
  [radarType.radarType_isDonkey] = UI.getChildControl(Instance_Radar, "icon_donkey"),
  [radarType.radarType_isShip] = UI.getChildControl(Instance_Radar, "icon_ship"),
  [radarType.radarType_isCarriage] = UI.getChildControl(Instance_Radar, "icon_carriage"),
  [radarType.radarType_isCamel] = UI.getChildControl(Instance_Radar, "icon_camel"),
  [radarType.radarType_isElephant] = nil,
  [radarType.radarType_isBabyElePhant] = UI.getChildControl(Instance_Radar, "icon_babyElephant"),
  [radarType.radarType_installation] = UI.getChildControl(Instance_Radar, "icon_tent"),
  [radarType.radarType_kingGuildTent] = UI.getChildControl(Instance_Radar, "icon_tent"),
  [radarType.radarType_lordGuildTent] = UI.getChildControl(Instance_Radar, "icon_tent"),
  [radarType.radarType_villageGuildTent] = UI.getChildControl(Instance_Radar, "icon_tent"),
  [radarType.radarType_selfDeadBody] = UI.getChildControl(Instance_Radar, "icon_deadbody"),
  [radarType.radarType_advancedBase] = UI.getChildControl(Instance_Radar, "icon_Outpost"),
  [radarType.radarType_Raft] = UI.getChildControl(Instance_Radar, "icon_Raft"),
  [radarType.radarType_Boat] = UI.getChildControl(Instance_Radar, "icon_Boat"),
  [radarType.radarType_FishingBoat] = UI.getChildControl(Instance_Radar, "icon_FishingBoat"),
  [radarType.radarType_PersonalTradeShip] = UI.getChildControl(Instance_Radar, "icon_PersonalTradeShip"),
  [radarType.radarType_GalleyShip] = UI.getChildControl(Instance_Radar, "icon_GalleyShip"),
  [radarType.radarType_PersonalBattleShip] = UI.getChildControl(Instance_Radar, "icon_PersonalBattleShip"),
  [radarType.radarType_huntingMonster] = UI.getChildControl(Instance_Radar, "icon_monsterHunting_normal"),
  [radarType.radarType_huntingMonsterQuestTarget] = UI.getChildControl(Instance_Radar, "icon_monsterHunting_quest")
}
local typeDepth = {
  [radarType.radarType_none] = 0,
  [radarType.radarType_hide] = 0,
  [radarType.radarType_allymonster] = -5,
  [radarType.radarType_normalMonster] = -2,
  [radarType.radarType_namedMonster] = -10,
  [radarType.radarType_bossMonster] = -12,
  [radarType.radarType_normalMonsterQuestTarget] = -3,
  [radarType.radarType_namedMonsterQuestTarget] = -11,
  [radarType.radarType_bossMonsterQuestTarget] = -13,
  [radarType.radarType_huntingMonster] = -11,
  [radarType.radarType_huntingMonsterQuestTarget] = -12,
  [radarType.radarType_lordManager] = -14,
  [radarType.radarType_skillTrainner] = -15,
  [radarType.radarType_tradeMerchantNpc] = -16,
  [radarType.radarType_nodeManager] = -17,
  [radarType.radarType_normalNpc] = -2,
  [radarType.radarType_warehouseNpc] = -7,
  [radarType.radarType_potionNpc] = -8,
  [radarType.radarType_weaponNpc] = -9,
  [radarType.radarType_horseNpc] = -6,
  [radarType.radarType_workerNpc] = -10,
  [radarType.radarType_jewelNpc] = -11,
  [radarType.radarType_furnitureNpc] = -12,
  [radarType.radarType_collectNpc] = -13,
  [radarType.radarType_shipNpc] = -5,
  [radarType.radarType_alchemyNpc] = -4,
  [radarType.radarType_fishNpc] = -3,
  [radarType.radarType_guild] = -21,
  [radarType.radarType_guildShop] = -25,
  [radarType.radarType_itemTrader] = -26,
  [radarType.radarType_TerritorySupply] = -23,
  [radarType.radarType_TerritoryTrade] = -22,
  [radarType.radarType_Cook] = -24,
  [radarType.radarType_Wharf] = -20,
  [radarType.radarType_itemRepairer] = -33,
  [radarType.radarType_shopMerchantNpc] = -34,
  [radarType.radarType_ImportantNpc] = -32,
  [radarType.radarType_QuestAcceptable] = -41,
  [radarType.radarType_QuestProgress] = -40,
  [radarType.radarType_QuestComplete] = -42,
  [radarType.radarType_unknownNpc] = -2,
  [radarType.radarType_partyMember] = -90,
  [radarType.radarType_guildMember] = -80,
  [radarType.radarType_normalPlayer] = -1,
  [radarType.radarType_isHorse] = -100,
  [radarType.radarType_isDonkey] = -100,
  [radarType.radarType_isShip] = -100,
  [radarType.radarType_isCarriage] = -100,
  [radarType.radarType_isCamel] = -100,
  [radarType.radarType_isElephant] = -100,
  [radarType.radarType_isBabyElePhant] = -100,
  [radarType.radarType_installation] = -20,
  [radarType.radarType_kingGuildTent] = -20,
  [radarType.radarType_lordGuildTent] = -20,
  [radarType.radarType_villageGuildTent] = -20,
  [radarType.radarType_selfDeadBody] = -40,
  [radarType.radarType_advancedBase] = -30,
  [radarType.radarType_Raft] = -100,
  [radarType.radarType_Boat] = -100,
  [radarType.radarType_FishingBoat] = -100,
  [radarType.radarType_PersonalTradeShip] = -100,
  [radarType.radarType_GalleyShip] = -100,
  [radarType.radarType_PersonalBattleShip] = -100
}
local UI_color = Defines.Color
local colorBlindNone = {
  [radarType.radarType_allymonster] = UI_color.C_FFB22300,
  [radarType.radarType_normalMonster] = UI_color.C_FFB22300,
  [radarType.radarType_namedMonster] = UI_color.C_FFB22300,
  [radarType.radarType_bossMonster] = UI_color.C_FFB22300,
  [radarType.radarType_huntingMonster] = UI_color.C_FFB22300,
  [radarType.radarType_normalMonsterQuestTarget] = UI_color.C_FFEE9900,
  [radarType.radarType_namedMonsterQuestTarget] = UI_color.C_FFEE9900,
  [radarType.radarType_bossMonsterQuestTarget] = UI_color.C_FFEE9900,
  [radarType.radarType_huntingMonsterQuestTarget] = UI_color.C_FFEE9900
}
local colorBlindRed = {
  [radarType.radarType_allymonster] = UI_color.C_FFD85300,
  [radarType.radarType_normalMonster] = UI_color.C_FFD85300,
  [radarType.radarType_namedMonster] = UI_color.C_FFD85300,
  [radarType.radarType_bossMonster] = UI_color.C_FFD85300,
  [radarType.radarType_huntingMonster] = UI_color.C_FFD85300,
  [radarType.radarType_normalMonsterQuestTarget] = UI_color.C_FFFFE866,
  [radarType.radarType_namedMonsterQuestTarget] = UI_color.C_FFFFE866,
  [radarType.radarType_bossMonsterQuestTarget] = UI_color.C_FFFFE866,
  [radarType.radarType_huntingMonsterQuestTarget] = UI_color.C_FFFFE866
}
local colorBlindGreen = {
  [radarType.radarType_allymonster] = UI_color.C_FFD82800,
  [radarType.radarType_normalMonster] = UI_color.C_FFD82800,
  [radarType.radarType_namedMonster] = UI_color.C_FFD82800,
  [radarType.radarType_bossMonster] = UI_color.C_FFD82800,
  [radarType.radarType_huntingMonster] = UI_color.C_FFD82800,
  [radarType.radarType_normalMonsterQuestTarget] = UI_color.C_FFFFE866,
  [radarType.radarType_namedMonsterQuestTarget] = UI_color.C_FFFFE866,
  [radarType.radarType_bossMonsterQuestTarget] = UI_color.C_FFFFE866,
  [radarType.radarType_huntingMonsterQuestTarget] = UI_color.C_FFFFE866
}
local weatherUVForNormal = {
  ["_texture"] = "new_ui_common_forlua/widget/rader/minimap_00.dds",
  [0] = {
    43,
    133,
    62,
    152
  },
  [1] = {
    171,
    187,
    188,
    205
  },
  [2] = {
    78,
    206,
    98,
    226
  }
}
local citadelUVForNormal = {
  ["_texture"] = "new_ui_common_forlua/window/guild/guild_00.dds",
  [0] = {
    312,
    31,
    332,
    51
  },
  [1] = {
    291,
    31,
    311,
    51
  },
  [2] = {
    291,
    31,
    311,
    51
  }
}
local siegeArearUVForNormal = {
  ["_texture"] = "new_ui_common_forlua/window/guild/guild_00.dds",
  [0] = {
    166,
    1,
    186,
    21
  },
  [1] = {
    187,
    1,
    207,
    21
  },
  [2] = {
    249,
    31,
    269,
    51
  }
}
local villageWarUVForNormal = {
  ["_texture"] = "New_UI_Common_forLua/Window/Guild/Guild_00.dds",
  [0] = {
    333,
    31,
    353,
    51
  },
  [1] = {
    354,
    31,
    374,
    51
  }
}
local terrainUVForNormal = {
  ["_texture"] = "new_ui_common_forlua/default/default_etc_01.dds",
  [0] = {
    73,
    170,
    93,
    190,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_NORMAL")
  },
  [1] = {
    52,
    170,
    72,
    190,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_ROAD")
  },
  [2] = {
    108,
    177,
    128,
    197,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_SNOW")
  },
  [3] = {
    129,
    177,
    149,
    197,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_DESERT")
  },
  [4] = {
    150,
    177,
    170,
    197,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_SWAMP")
  },
  [5] = {
    73,
    170,
    93,
    190,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_OBJECT")
  },
  [6] = {
    171,
    177,
    191,
    197,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_WATER")
  },
  [7] = {
    73,
    170,
    93,
    190,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_GRASS")
  },
  [8] = {
    171,
    156,
    191,
    176,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_DEEPWATER")
  },
  [9] = {
    171,
    135,
    191,
    155,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_AIR")
  }
}
local glowFontForNormal = {
  _region = "BaseFont_12_Glow",
  _regionNode = "BaseFont_8_Glow",
  _regionWar = "BaseFont_8_Glow"
}
local weatherUVForRemaster = {
  ["_texture"] = "Renewal/UI_Icon/Console_Icon_03.dds",
  [0] = {
    43,
    171,
    63,
    191
  },
  [1] = {
    22,
    171,
    42,
    191
  },
  [2] = {
    1,
    171,
    21,
    191
  }
}
local citadelUVForRemaster = {
  ["_texture"] = "Renewal/UI_Icon/Console_Icon_03.dds",
  [0] = {
    64,
    129,
    84,
    149
  },
  [1] = {
    43,
    129,
    63,
    149
  },
  [2] = {
    64,
    171,
    84,
    191
  }
}
local siegeAreaUVForRemaster = {
  ["_texture"] = "Renewal/UI_Icon/Console_Icon_03.dds",
  [0] = {
    64,
    171,
    84,
    191
  },
  [1] = {
    43,
    129,
    63,
    149
  },
  [2] = {
    64,
    129,
    84,
    149
  }
}
local villageWarUVForRemaster = {
  ["_texture"] = "Renewal/UI_Icon/Console_Icon_03.dds",
  [0] = {
    1,
    129,
    21,
    149
  },
  [1] = {
    22,
    129,
    42,
    149
  }
}
local terrainUVForRemaster = {
  ["_texture"] = "Renewal/UI_Icon/Console_Icon_03.dds",
  [0] = {
    1,
    150,
    21,
    170,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_NORMAL")
  },
  [1] = {
    22,
    150,
    42,
    170,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_ROAD")
  },
  [2] = {
    43,
    150,
    63,
    170,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_SNOW")
  },
  [3] = {
    64,
    150,
    84,
    170,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_DESERT")
  },
  [4] = {
    85,
    150,
    105,
    170,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_SWAMP")
  },
  [5] = {
    1,
    150,
    21,
    170,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_OBJECT")
  },
  [6] = {
    106,
    129,
    126,
    149,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_WATER")
  },
  [7] = {
    85,
    150,
    105,
    170,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_GRASS")
  },
  [8] = {
    85,
    129,
    105,
    149,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_DEEPWATER")
  },
  [9] = {
    106,
    150,
    126,
    170,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_AIR")
  },
  [10] = {
    106,
    129,
    126,
    149,
    PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_OCEAN")
  }
}
local glowFontForRemaster = {
  _region = "SubTitleFont_14",
  _regionNode = "BaseFont_10",
  _regionWar = "BaseFont_10"
}
local weatherUV = {}
local citadelUV = {}
local siegeAreaUV = {}
local villageWarUV = {}
local terrainUV = {}
local glowFont = {}
if true == _ContentsGroup_RemasterUI_Radar then
  weatherUV = weatherUVForRemaster
  citadelUV = citadelUVForRemaster
  siegeAreaUV = siegeAreaUVForRemaster
  villageWarUV = villageWarUVForRemaster
  terrainUV = terrainUVForRemaster
  glowFont = glowFontForRemaster
else
  weatherUV = weatherUVForNormal
  citadelUV = citadelUVForNormal
  siegeAreaUV = siegeArearUVForNormal
  villageWarUV = villageWarUVForNormal
  terrainUV = terrainUVForNormal
  glowFont = glowFontForNormal
end
local CGT = CppEnums.CharacterGradeType
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TM = CppEnums.TextMode
local UI_RT = CppEnums.RegionType
local isDrag = false
local alphaValue = 1
local simpleUIAlpha = 0
local radarText = UI.getChildControl(Instance_Radar, "StaticText_radarText")
local radar_Background = UI.getChildControl(Instance_Radar, "radar_Background")
local radar_SizeSlider = UI.getChildControl(Instance_Radar, "Slider_MapSize")
local radar_SizeBtn = UI.getChildControl(radar_SizeSlider, "Slider_MapSize_Btn")
local radar_AlphaScrl = UI.getChildControl(Instance_Radar, "Slider_RadarAlpha")
local radar_AlphaBtn = UI.getChildControl(radar_AlphaScrl, "RadarAlpha_CtrlBtn")
local radar_OverName = UI.getChildControl(Instance_Radar, "Static_OverName")
local radar_MiniMapScl = UI.getChildControl(Instance_Radar, "Button_SizeControl")
local radar_regionName = UI.getChildControl(Instance_Radar, "StaticText_RegionName")
local radar_regionNodeName = UI.getChildControl(Instance_Radar, "StaticText_RegionNodeName")
local radar_regionWarName = UI.getChildControl(Instance_Radar, "StaticText_RegionWarName")
local radar_DangerIcon = UI.getChildControl(Instance_Radar, "Static_DangerArea")
local redar_DangerAletText = UI.getChildControl(Instance_Radar, "StaticText_MonsterAlert")
local radar_DangetAlertBg = UI.getChildControl(Instance_Radar, "Static_Alert")
local radar_WarAlert = UI.getChildControl(Instance_Radar, "StaticText_WarAlert")
local radar_GuildTeamBattleAlert = UI.getChildControl(Instance_Radar, "StaticText_GuildTeamBattleAlert")
local radar_ChangeBtn = UI.getChildControl(Instance_Radar, "Button_Swap")
local radar_SequenceAni = UI.getChildControl(Instance_Radar, "Static_SequenceAni")
radar_regionName:SetAutoResize(true)
radar_regionName:SetNotAbleMasking(true)
radar_regionNodeName:SetShow(false)
radar_regionWarName:SetShow(false)
redar_DangerAletText:SetShow(false)
radar_DangetAlertBg:SetShow(false)
radar_WarAlert:SetShow(false)
radar_GuildTeamBattleAlert:SetShow(false)
local function radarAlert_Resize()
  if redar_DangerAletText:GetSizeY() < redar_DangerAletText:GetTextSizeY() then
    redar_DangerAletText:SetSize(Instance_Radar:GetSizeX() - 60, redar_DangerAletText:GetSizeY() + 20)
  else
    redar_DangerAletText:SetSize(Instance_Radar:GetSizeX() - 60, redar_DangerAletText:GetSizeY())
  end
  if radar_WarAlert:GetSizeY() < radar_WarAlert:GetTextSizeY() then
    radar_WarAlert:SetSize(Instance_Radar:GetSizeX() - 60, radar_WarAlert:GetSizeY() + 20)
  else
    radar_WarAlert:SetSize(Instance_Radar:GetSizeX() - 60, radar_WarAlert:GetSizeY())
  end
  if radar_GuildTeamBattleAlert:GetSizeY() < radar_GuildTeamBattleAlert:GetTextSizeY() then
    radar_GuildTeamBattleAlert:SetSize(Instance_Radar:GetSizeX() - 60, radar_GuildTeamBattleAlert:GetSizeY() + 20)
  else
    radar_GuildTeamBattleAlert:SetSize(Instance_Radar:GetSizeX() - 60, radar_GuildTeamBattleAlert:GetSizeY())
  end
  redar_DangerAletText:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  redar_DangerAletText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RADER_NEARMONSTERALERT"))
  redar_DangerAletText:ComputePos()
  radar_WarAlert:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  radar_WarAlert:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_WAR_NO_MONSTER"))
  radar_WarAlert:ComputePos()
  radar_GuildTeamBattleAlert:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  radar_GuildTeamBattleAlert:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_GUILDTEAMBATTLE_ALERT"))
  radar_GuildTeamBattleAlert:ComputePos()
end
radarAlert_Resize()
local Panel_OrigSizeX = 320
local Panel_OrigSizeY = 320
local Panel_ReciprocalOrigSizeX = 1 / Panel_OrigSizeX
local Panel_ReciprocalOrigSizeY = 1 / Panel_OrigSizeY
local wheelCount = 0.5
local cacheSimpleUI_ShowButton = true
local isMouseOn = false
local scaleMinValue = 50
local scaleMaxValue = 150
local useLanternAlertTime = 0
local beforSafeZone = false
local beforeCombatZone = false
local beforeArenaZone = false
local beforeDesertZone = false
local currentSafeZone = false
local nodeWarRegionName
local balenciaPart2 = ToClient_IsContentsGroupOpen("65")
radar_Background:SetAlpha(0)
local _siegeAttackPosition
local _OnSiegeRide = false
local _const_siegeAttackHitArea, RadarMap_UpdatePixelRate
local UCT_STATICTEXT = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT
local terrainNotice = UI.getChildControl(Instance_Radar, "Static_Notice")
local terrainNoticeStyle = UI.getChildControl(Instance_Radar, "StaticText_Notice")
local terrainNoticeText = UI.createControl(UCT_STATICTEXT, terrainNotice, "terrainNoticeText")
local textInfo = ""
Instance_Radar:SetChildIndex(terrainNotice, 9999)
CopyBaseProperty(terrainNoticeStyle, terrainNoticeText)
UI.deleteControl(terrainNoticeStyle)
terrainNoticeStyle = nil
terrainNoticeText:SetSpanSize(10, 0)
local floor = math.floor
local atan2 = math.atan2
local max = math.max
local min = math.min
local PI = math.pi
local RegionData_IngameTime = 0
local RegionData_RealIngameTime = 0
local dayCycle = 86400
local QuestArrowHalfSize = 0
local battleRoyale = {
  _ui = {
    mapLine_current = radarMap.controls.mapLine_current,
    mapLine_next = radarMap.controls.mapLine_next,
    iconPlayer = radarMap.controls.icon_SelfPlayer,
    circleFrame = radarMap.controls.radar_circleFrame,
    circleDangerFrame = radarMap.controls.radar_circleDangerFrame
  },
  eZoneType = {
    non = 0,
    safeZone = 1,
    warringZone = 2,
    dangerZone = 3
  },
  playerInfo = {
    _beforePos = float3(0, 0, 0)
  },
  lostRegionInfo = {
    currentPos = float2(0, 0),
    currentRadius = 9999999,
    beforeSector = float2(0, 0),
    nextPos = float2(0, 0),
    nextRadius = 9999999,
    isCallNextRegion = false
  },
  _currentZoneType = 0,
  _lostRegionDeltaTime = 0,
  _lostRegionRefreshTime = 1,
  _calculateSectorSize = 128,
  _sectorRatio = 0.01,
  _sectorSize = 12800
}
local checkLoad = function()
  local radarControl = radarMap.controls
  local SPI = radarControl.icon_SelfPlayer
  UI.ASSERT(SPI:GetSizeX() == SPI:GetSizeY(), "[Radar.lua] icon_SelfPlayer MEST BE 'square'")
end
local function updateWorldMapDistance(mapRadius)
  local config = radarMap.config
  config.mapRadius = min(max(mapRadius, scaleMinValue), scaleMaxValue)
  radarMap.worldDistanceToPixelRate = config.mapRadiusByPixel / config.mapRadius
  ToClient_setRadorUIDistanceToPixelRate(radarMap.worldDistanceToPixelRate * 0.02)
  RadarMap_UpdatePixelRate()
end
function Radar_updateWorldMapDistance_Reset()
  radarMap.config.mapRadius = radarMap.config.constMapRadius
  FGlobal_Radar_updateWorldMapDistance_Relative(1.3)
end
function FGlobal_Radar_updateWorldMapDistance_Relative(value)
  updateWorldMapDistance(radarMap.config.mapRadius + radarMap.config.constMapRadius * value)
  local percents = radarMap.config.mapRadius - scaleMinValue
  percents = max(min(percents, 100), 0)
  radar_SizeSlider:SetControlPos(100 - percents)
  ToClient_SetRaderScale(radar_SizeSlider:GetControlPos())
  ToClient_SaveUiInfo(false)
end
function FGlobal_Radar_UpdateWorldMapDistance(value)
end
local function controlAlignForNomal()
  radarMap.scaleRateWidth = Instance_Radar:GetSizeX() * Panel_ReciprocalOrigSizeX
  radarMap.scaleRateHeight = Instance_Radar:GetSizeY() * Panel_ReciprocalOrigSizeY
  local scl_minus = radarMap.controls.radar_Minus
  local scl_plus = radarMap.controls.radar_Plus
  radar_SizeSlider:SetScale(radarMap.scaleRateWidth, 1)
  scl_plus:SetPosX(scl_minus:GetPosX() + scl_minus:GetSizeX() + radar_SizeSlider:GetSizeX() + 15)
  local alpha_plus = radarMap.controls.radar_AlphaPlus
  local alpha_minus = radarMap.controls.radar_AlphaMinus
  radar_AlphaScrl:SetScale(1, radarMap.scaleRateHeight)
  alpha_minus:SetPosY(alpha_plus:GetPosY() + radar_AlphaScrl:GetSizeY() + alpha_minus:GetSizeY() + 5)
  local resetIcon = radarMap.controls.radar_Reset
  resetIcon:SetVerticalBottom()
  resetIcon:SetHorizonRight()
  radar_MiniMapScl:SetVerticalBottom()
  radar_DangerIcon:ComputePos()
  radar_regionWarName:ComputePos()
end
local function controlAlignForRemaster()
  if false == Instance_Radar:GetShow() then
    return
  end
  radarMap.scaleRateWidth = Instance_Radar:GetSizeX() * Panel_ReciprocalOrigSizeX
  radarMap.scaleRateHeight = Instance_Radar:GetSizeY() * Panel_ReciprocalOrigSizeY
  local alphaScrlScaleY = radarMap.scaleRateHeight + (radarMap.scaleRateHeight - 1) * 0.5
  radar_AlphaScrl:SetScale(1, alphaScrlScaleY)
  local resetIcon = radarMap.controls.radar_Reset
  local scl_plus = radarMap.controls.radar_Plus
  local scl_minus = radarMap.controls.radar_Minus
  radar_regionName:SetHorizonCenter()
  radar_DangerIcon:ComputePos()
  radar_regionWarName:ComputePos()
  radar_regionNodeName:ComputePos()
  scl_plus:ComputePos()
  scl_minus:ComputePos()
  radar_MiniMapScl:SetVerticalBottom()
  radar_AlphaScrl:SetPosY(scl_minus:GetPosY() + scl_minus:GetSizeY() + 10)
  resetIcon:SetPosX(scl_plus:GetPosX() + 2)
  resetIcon:SetPosY(scl_plus:GetPosY() - resetIcon:GetSizeY() - 5)
  radar_MiniMapScl:SetPosX(radar_MiniMapScl:GetPosX() + 10 * radarMap.scaleRateWidth)
  radar_MiniMapScl:SetPosY(radar_MiniMapScl:GetPosY() - 10 * radarMap.scaleRateHeight)
end
local function controlAlign()
  if true == _ContentsGroup_RemasterUI_Radar then
    controlAlignForRemaster()
  else
    controlAlignForNomal()
  end
end
local MAX_WIDTH = 512
local MAX_HEIGHT = 512
local isInCircleSpace = function(playerPos, center, radius)
  local x = math.abs(playerPos.x - center.x)
  local y = math.abs(playerPos.z - center.y)
  local distance = math.sqrt(math.pow(x, 2) + math.pow(y, 2))
  if radius > distance then
    return true
  end
  return false
end
local function updateCurrentPosZone()
  local playerPos = battleRoyale.playerInfo._beforePos
  local currentPos = battleRoyale.lostRegionInfo.currentPos
  local currentRadius = battleRoyale.lostRegionInfo.currentRadius
  local nextPos = battleRoyale.lostRegionInfo.nextPos
  local nextRadius = battleRoyale.lostRegionInfo.nextRadius
  local strText = ""
  if true == isInCircleSpace(playerPos, nextPos, nextRadius) then
    if battleRoyale.eZoneType.safeZone ~= battleRoyale._currentZoneType then
      battleRoyale._currentZoneType = battleRoyale.eZoneType.safeZone
      strText = "LUA_BATTLEROYAL_RADAR_SAFEZONE"
      local msg = {
        main = PAGetString(Defines.StringSheet_GAME, strText),
        sub = ""
      }
      Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect(msg, nil, 2)
      radar_regionName:SetFontColor(4292276981)
      radar_regionName:useGlowFont(true, glowFont._region, 4281961144)
      radar_regionName:SetText(PAGetString(Defines.StringSheet_GAME, strText))
    end
  elseif true == isInCircleSpace(playerPos, currentPos, currentRadius) then
    if battleRoyale.eZoneType.warringZone ~= battleRoyale._currentZoneType then
      battleRoyale._currentZoneType = battleRoyale.eZoneType.warringZone
      local bgNum = 2
      local fontColor = 4294495693
      local glowFontColor = 4286580487
      if true == battleRoyale.lostRegionInfo.isCallNextRegion then
        strText = "LUA_BATTLEROYAL_RADAR_WARRNINGZONE"
        fontColor = 4294495693
        glowFontColor = 4286580487
        bgNum = 2
      else
        strText = "LUA_BATTLEROYAL_RADAR_SAFEZONE"
        fontColor = 4292276981
        glowFontColor = 4281961144
        bgNum = 2
      end
      local msg = {
        main = PAGetString(Defines.StringSheet_GAME, strText),
        sub = ""
      }
      Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect(msg, nil, bgNum)
      radar_regionName:SetFontColor(fontColor)
      radar_regionName:useGlowFont(true, glowFont._region, glowFontColor)
      radar_regionName:SetText(PAGetString(Defines.StringSheet_GAME, strText))
    end
  elseif battleRoyale.eZoneType.dangerZone ~= battleRoyale._currentZoneType then
    battleRoyale._currentZoneType = battleRoyale.eZoneType.dangerZone
    strText = "LUA_BATTLEROYAL_RADAR_DANGERZONE"
    local msg = {
      main = PAGetString(Defines.StringSheet_GAME, strText),
      sub = ""
    }
    Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect(msg, nil, 1)
    radar_regionName:SetFontColor(4294495693)
    radar_regionName:useGlowFont(true, glowFont._region, 4286580487)
    radar_regionName:SetText(PAGetString(Defines.StringSheet_GAME, strText))
  end
end
function battleRoyale:setAnimationCircleFrame(isSafe)
  self._ui.circleFrame:SetShow(isSafe)
  self._ui.circleDangerFrame:SetShow(not isSafe)
end
local getCalculateOffsetPos = function(playerPos, regionPos)
  local x = math.abs(playerPos.x - regionPos.x)
  local y = math.abs(playerPos.z - regionPos.z)
  if regionPos.x < playerPos.x then
    x = -x
  end
  if regionPos.z < playerPos.z then
    y = -y
  end
  return float2(x, y)
end
local function getCalculateRegionCenterPos(playerPos, regionPos, imageSize)
  local convertRegionPos = float3(regionPos.x, 0, regionPos.y)
  local playerSector = convertPosToSector(playerPos)
  local regionSector = convertPosToSector(convertRegionPos)
  local playerInPos = convertPosToInSectorPos(playerPos)
  local regionInPos = convertPosToInSectorPos(convertRegionPos)
  local sectorOffset = getCalculateOffsetPos(playerSector, regionSector)
  local inSectorOffset = getCalculateOffsetPos(playerInPos, regionInPos)
  local x = sectorOffset.x * imageSize + inSectorOffset.x / battleRoyale._sectorSize * imageSize
  local y = sectorOffset.y * imageSize + inSectorOffset.y / battleRoyale._sectorSize * imageSize
  return float2(x, y)
end
local function getCalculateRadius(regionRadius, imageSize)
  local radius = regionRadius * battleRoyale._sectorRatio * imageSize / battleRoyale._calculateSectorSize
  return radius + radius * 0.11
end
local function getLostRegionStartPos(calculateRadius)
  local iconPlayer = battleRoyale._ui.iconPlayer
  local x = iconPlayer:GetPosX() + iconPlayer:GetSizeX() * 0.5 - calculateRadius
  local y = iconPlayer:GetPosY() + iconPlayer:GetSizeY() * 0.5 - calculateRadius
  return float2(x, y)
end
local function updateCurrentLostRegionInfo()
  local playerPos = battleRoyale.playerInfo._beforePos
  local regionPos = battleRoyale.lostRegionInfo.currentPos
  local regionRadius = battleRoyale.lostRegionInfo.currentRadius
  local imageSize = PaGlobal_RadarMapBG_getConstImageSize()
  local calPos = getCalculateRegionCenterPos(playerPos, regionPos, imageSize)
  local calRadius = getCalculateRadius(regionRadius, imageSize)
  local startPos = getLostRegionStartPos(calRadius)
  if false == battleRoyale.lostRegionInfo.isCallNextRegion then
    battleRoyale._ui.mapLine_next:SetShow(true)
    battleRoyale._ui.mapLine_next:SetPosXY(startPos.x + calPos.x, startPos.y - calPos.y)
    battleRoyale._ui.mapLine_next:SetSize(calRadius * 2, calRadius * 2)
    return
  end
  battleRoyale._ui.mapLine_current:SetShow(true)
  battleRoyale._ui.mapLine_current:SetPosXY(startPos.x + calPos.x, startPos.y - calPos.y)
  battleRoyale._ui.mapLine_current:SetSize(calRadius * 2, calRadius * 2)
end
local function updateNextLostRegionInfo()
  if false == battleRoyale.lostRegionInfo.isCallNextRegion then
    return
  end
  local playerPos = battleRoyale.playerInfo._beforePos
  local regionPos = battleRoyale.lostRegionInfo.nextPos
  local regionRadius = battleRoyale.lostRegionInfo.nextRadius
  local imageSize = PaGlobal_RadarMapBG_getConstImageSize()
  local calPos = getCalculateRegionCenterPos(playerPos, regionPos, imageSize)
  local calRadius = getCalculateRadius(regionRadius, imageSize)
  local startPos = getLostRegionStartPos(calRadius)
  battleRoyale._ui.mapLine_next:SetShow(true)
  battleRoyale._ui.mapLine_next:SetPosXY(startPos.x + calPos.x, startPos.y - calPos.y)
  battleRoyale._ui.mapLine_next:SetSize(calRadius * 2, calRadius * 2)
end
local function updateLostRegion(deltaTime)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  battleRoyale.playerInfo._beforePos = selfPlayer:get():getPosition()
  updateCurrentLostRegionInfo()
  updateNextLostRegionInfo()
  updateCurrentPosZone()
  battleRoyale._lostRegionDeltaTime = battleRoyale._lostRegionDeltaTime + deltaTime
  if battleRoyale._lostRegionDeltaTime < battleRoyale._lostRegionRefreshTime then
    return
  end
  battleRoyale._lostRegionDeltaTime = 0
  local currentPos = ToClient_GetCurrentRegionCenter()
  local currentRadius = ToClient_GetCurrentRegionRadius()
  local nextPos = ToClient_GetNextRegionCenter()
  local nextRadius = ToClient_GetNextRegionRadius()
  if currentRadius <= 0 and nextRadius <= 0 then
    return
  end
  if currentPos.x == battleRoyale.lostRegionInfo.currentPos.x and currentPos.y == battleRoyale.lostRegionInfo.currentPos.y and currentRadius == battleRoyale.lostRegionInfo.currentRadius and nextPos.x == battleRoyale.lostRegionInfo.nextPos.x and nextPos.y == battleRoyale.lostRegionInfo.nextPos.y and nextRadius == battleRoyale.lostRegionInfo.nextRadius then
    return
  end
  battleRoyale.lostRegionInfo.currentPos = currentPos
  battleRoyale.lostRegionInfo.currentRadius = currentRadius
  battleRoyale.lostRegionInfo.nextPos = nextPos
  battleRoyale.lostRegionInfo.nextRadius = nextRadius
  if currentPos.x == nextPos.x and currentPos.y == nextPos.y and currentRadius == nextRadius then
    battleRoyale._ui.mapLine_current:SetShow(false)
  end
end
function FromClient_MapSizeScale()
  local origEndX = Instance_Radar:GetPosX() + Instance_Radar:GetSizeX()
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  if MAX_WIDTH >= origEndX - mousePosX and origEndX - mousePosX >= Panel_OrigSizeX then
    Instance_Radar:SetPosX(mousePosX)
    Instance_Radar:SetSize(origEndX - mousePosX, Instance_Radar:GetSizeY())
    radarMap.controls.radar_Background:SetPosX(0)
    radarMap.controls.radar_Background:SetSize(origEndX - mousePosX, Instance_Radar:GetSizeY())
  end
  if MAX_HEIGHT >= mousePosY - Instance_Radar:GetPosY() and mousePosY - Instance_Radar:GetPosY() >= Panel_OrigSizeY then
    Instance_Radar:SetSize(Instance_Radar:GetSizeX(), mousePosY - Instance_Radar:GetPosY())
    radarMap.controls.radar_Background:SetSize(Instance_Radar:GetSizeX(), mousePosY - Instance_Radar:GetPosY())
  end
  local SPI = radarMap.controls.icon_SelfPlayer
  local halfSelfSizeX = SPI:GetSizeX() / 2
  local halfSelfSizeY = SPI:GetSizeY() / 2
  local halfSizeX = Instance_Radar:GetSizeX() / 2
  local halfSizeY = Instance_Radar:GetSizeY() / 2
  SPI:SetPosX(halfSizeX - halfSelfSizeX)
  SPI:SetPosY(halfSizeY - halfSelfSizeY)
  radarMap.pcPosBaseControl.x = SPI:GetPosX() + halfSelfSizeX
  radarMap.pcPosBaseControl.y = SPI:GetPosY() + halfSelfSizeY
  ToClient_setRadorUICenterPosition(int2(radarMap.pcPosBaseControl.x, radarMap.pcPosBaseControl.y))
  controlAlign()
  NpcNavi_Reset_Posistion()
  TownNpcIcon_Resize()
  Panel_PlayerEndurance_Position()
  Panel_CarriageEndurance_Position()
  Panel_HorseEndurance_Position()
  Panel_ShipEndurance_Position()
  if false == _ContentsGroup_RemasterUI_Main_RightTop then
    FGlobal_PersonalIcon_ButtonPosUpdate()
  else
    FromClient_Widget_FunctionButton_Resize()
  end
  FromClient_MainQuestWidget_ResetPosition()
  if false == _ContentsGroup_RemasterUI_QuestWidget then
    PaGlobalFunc_Quest_UpdatePosition()
  end
  ToClient_SaveUiInfo(false)
  radarAlert_Resize()
end
function Radar_IconsSetAlpha(alpha)
  local actorAlpha = max(min(alpha + 0.2, 1), 0.7)
  for _, areaQuest in pairs(radarMap.areaQuests) do
    areaQuest.icon_QuestArea:SetAlpha(actorAlpha)
    areaQuest.icon_QuestArrow:SetAlpha(actorAlpha)
  end
  radarMap.controls.icon_SelfPlayer:SetAlpha(actorAlpha)
  RadarMapBG_SetAlphaValue(alphaValue)
end
function Radar_CalcAlaphValue(alpha)
  alphaValue = max(min(alpha, 1), 0)
  radar_AlphaScrl:SetControlPos(100 * (1 - alphaValue))
  alphaValue = alphaValue + (1 - alphaValue) * 0.5
  return alphaValue
end
function Radar_updateWorldMap_AlphaControl(alpha)
  alphaValue = Radar_CalcAlaphValue(1 - radar_AlphaScrl:GetControlPos() + alpha)
  Radar_IconsSetAlpha(alphaValue)
  ToClient_SetRaderAlpha(radar_AlphaScrl:GetControlPos())
  ToClient_SaveUiInfo(false)
end
function FGlobal_ReloadRadarAlphaValue()
  alphaValue = Radar_CalcAlaphValue(alphaValue)
  Radar_IconsSetAlpha(alphaValue)
end
function Radar_updateWorldMap_AlphaControl_Init()
  local alphaSlideValue = 1 - radar_AlphaScrl:GetControlPos()
  alphaSlideValue = Radar_CalcAlaphValue(alphaSlideValue)
  Radar_IconsSetAlpha(alphaSlideValue)
  alphaValue = alphaSlideValue
end
function Radar_updateWorldMap_AlphaControl_Scrl()
  Radar_updateWorldMap_AlphaControl_Init()
  ToClient_SetRaderAlpha(radar_AlphaScrl:GetControlPos())
  ToClient_SaveUiInfo(false)
end
function Radar_updateWorldMap_ScaleControl_Scrl()
  local scaleSlideValue = 1 - radar_SizeSlider:GetControlPos()
  updateWorldMapDistance(scaleMinValue + scaleSlideValue * 100)
  NpcNavi_Reset_Posistion()
  ToClient_SetRaderScale(radar_SizeSlider:GetControlPos())
  ToClient_SaveUiInfo(false)
end
function Radar_updateWorldMap_ScaleControl_Wheel(isUp)
  if true == isUp then
    if wheelCount > 0 then
      wheelCount = wheelCount - 0.05
      updateWorldMapDistance(radarMap.config.mapRadius + wheelCount * 100)
    end
  elseif wheelCount < 1 then
    wheelCount = wheelCount + 0.05
    updateWorldMapDistance(radarMap.config.mapRadius + wheelCount * 100)
  end
  local percents = wheelCount * 100
  radar_SizeSlider:SetControlPos(100 - percents)
  NpcNavi_Reset_Posistion()
end
function Radar_SetRotateMode(isRotate)
  radarMap.isRotateMode = isRotate
  local rot = 0
  if isRotate then
    rot = PI
  else
    resetRadarActorListRotateValue()
    resetPinRotate()
  end
  local radarControl = radarMap.controls
  radarControl.radar_Background:SetParentRotCalc(isRotate)
  radarControl.icon_SelfPlayer:SetRotate(rot)
  FGlobal_GuildPinRotateMode(isRotate)
  FGlobal_PinRotateMode(isRotate)
  RadarBackground_SetRotateMode(isRotate)
end
local pinX, pinZ
function Radar_PinUpdate(isAlways)
  SendPingInfo_ToClient(isAlways)
end
function Radar_MouseOn()
  isMouseOn = true
end
function Radar_MouseOut()
  isMouseOn = false
end
function FGlobal_Radar_HandleMouseOn()
  PaGlobal_TutorialManager:handleRadarMouseOn()
end
GLOBAL_CHECK_WORLDMINIMAP = false
function RadarMap_Background_MouseRUp()
  if true == GLOBAL_CHECK_WORLDMINIMAP then
    return
  end
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  local posX = mousePosX - Instance_Radar:GetPosX()
  local posZ = mousePosY - Instance_Radar:GetPosY() - Instance_Radar:GetSizeY()
  if 0 ~= ToClient_GetMyTeamNoLocalWar() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_LOCALWAR_CANTNAVI_ACK"))
    return
  end
  if getSelfPlayer():get():getLevel() < 11 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TUTORIAL_PROGRSS_ACK"))
    FGlobal_QuestWidget_UpdateList()
    return
  end
  if ToClient_IsShowNaviGuideGroup(0) then
    radar_MiniMapScl:AddEffect("fUI_Button_Hide", false, posX, posZ)
    ToClient_DeleteNaviGuideByGroup(0)
  else
    radar_MiniMapScl:AddEffect("fUI_Button_Hide", false, posX, posZ)
    local posX = mousePosX - Instance_Radar:GetPosX()
    local posY = mousePosY - Instance_Radar:GetPosY()
    local intervalX = posX - (radarMap.controls.icon_SelfPlayer:GetPosX() + radarMap.controls.icon_SelfPlayer:GetSizeX() / 2)
    local intervalZ = radarMap.controls.icon_SelfPlayer:GetPosY() + radarMap.controls.icon_SelfPlayer:GetSizeY() / 2 - posY
    intervalX = intervalX * (100 / (radarMap.worldDistanceToPixelRate * 2))
    intervalZ = intervalZ * (100 / (radarMap.worldDistanceToPixelRate * 2))
    local selfPlayerControlPos = radarMap.pcPosBaseControl
    local dist = intervalX - selfPlayerControlPos.x
    local disty = intervalZ - selfPlayerControlPos.y
    local tempPos = float2(dist, disty)
    local camRot = getCameraRotation()
    if radarMap.isRotateMode then
      tempPos:rotate(camRot + PI)
    end
    local selfPosition = getSelfPlayer():get3DPos()
    local float3Pos = float3(selfPosition.x + tempPos.x, 0, selfPosition.z + tempPos.y)
    float3Pos.y = selfPosition.y
    ToClient_WorldMapNaviStart(float3Pos, NavigationGuideParam(), false, true)
    audioPostEvent_SystemUi(0, 14)
    _AudioPostEvent_SystemUiForXBOX(0, 14)
  end
end
local function controlInit()
  local radarControl = radarMap.controls
  local SPI = radarControl.icon_SelfPlayer
  radarMap.pcPosBaseControl.x = SPI:GetPosX() + SPI:GetSizeX() / 2
  radarMap.pcPosBaseControl.y = SPI:GetPosY() + SPI:GetSizeY() / 2
  ToClient_setRadorUICenterPosition(int2(radarMap.pcPosBaseControl.x, radarMap.pcPosBaseControl.y))
  Instance_Radar:RegisterUpdateFunc("RadarMap_UpdatePerFrame")
  controlAlign()
  RadarMap_Init()
  radarControl.radar_Plus:SetAlpha(0)
  radarControl.radar_Minus:SetAlpha(0)
  radar_SizeBtn:SetAlpha(0)
  radar_SizeSlider:SetAlpha(0)
  radarControl.radar_AlphaPlus:SetAlpha(0)
  radarControl.radar_AlphaMinus:SetAlpha(0)
  radar_AlphaBtn:SetAlpha(0)
  radar_AlphaScrl:SetAlpha(0)
  radarControl.radar_Reset:SetAlpha(0)
  radarControl.radar_Close:SetAlpha(0)
  radar_MiniMapScl:SetAlpha(0)
  radar_SequenceAni:SetAlpha(0)
  radarControl.icon_SelfPlayer:SetRotate(PI)
  radar_ChangeBtn:SetShow(false)
  radar_SequenceAni:SetShow(false)
  radar_regionName:SetText("")
  radar_AlphaScrl:SetControlPos(ToClient_GetRaderAlpha() * 100)
  Radar_updateWorldMap_AlphaControl_Init()
  radar_SizeSlider:SetControlPos(ToClient_GetRaderScale() * 100)
  local scaleSlideValue = 1 - radar_SizeSlider:GetControlPos()
  updateWorldMapDistance(scaleMinValue + scaleSlideValue * 100)
  radarAlert_Resize()
  Instance_Radar:ChangeSpecialTextureInfoName("Renewal/PcRemaster/Remaster_Minimap_Mask02__599.dds")
  Instance_Radar:setMaskingChild(true)
end
function TerrainInfo_ShowBubble(isShow)
  local terraintype = selfPlayerNaviMaterial()
  local radarControl = radarTime.controls
  if terraintype == 0 then
    textInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_NORMAL")
    roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_NORMAL")
  elseif terraintype == 1 then
    textInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_ROAD")
    roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_ROAD")
  elseif terraintype == 2 then
    textInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_SNOW")
    roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_SNOW")
  elseif terraintype == 3 then
    textInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_DESERT")
    roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_DESERT")
  elseif terraintype == 4 then
    textInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_SWAMP")
    roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_SWAMP")
  elseif terraintype == 5 then
    textInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_OBJECT")
    roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_OBJECT")
  elseif terraintype == 6 then
    textInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_WATER")
    roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_WATER")
  elseif terraintype == 7 then
    textInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_GRASS")
    roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_GRASS")
  elseif terraintype == 8 then
    textInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_DEEPWATER")
    roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_DEEPWATER")
  elseif terraintype == 9 then
    textInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_AIR")
    roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_AIR")
  else
    if nil ~= getSelfPlayer() then
      return
    end
    local isOcean = getSelfPlayer():getCurrentRegionInfo():isOcean()
    if isOcean then
      textInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_OCEAN")
      roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_OCEAN")
    else
      textInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAININFO_NORMAL")
      roadInfo = PAGetString(Defines.StringSheet_GAME, "LUA_RADAR_TERRAINTYPE_NORMAL")
    end
  end
  name = roadInfo
  desc = textInfo
  uiControl = radarTime.controls.terrainInfo
  if true == isShow then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function RadarScale_SimpleTooltips(isShow)
  local name, desc, uiControl
  name = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_RADER_MINIMAP_NAME")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_RADER_MINIMAP_DESC")
  uiControl = radar_MiniMapScl
  registTooltipControl(uiControl, Instance_Tooltip_SimpleText)
  if true == isShow then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function RadarShowAni()
  Instance_Radar:ResetVertexAni()
  local aniInfo1 = Instance_Radar:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartPosition(getScreenSizeX(), Instance_Radar:GetPosY())
  aniInfo1:SetEndPosition(getScreenSizeX() - Instance_Radar:GetSizeX() - Instance_Radar:GetSpanSize().x, Instance_Radar:GetPosY())
  aniInfo1.IsChangeChild = true
end
function RadarHideAni()
  Instance_Radar:ResetVertexAni()
  local aniInfo1 = Instance_Radar:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartPosition(Instance_Radar:GetPosX(), Instance_Radar:GetPosY())
  aniInfo1:SetEndPosition(Instance_Radar:GetPosX() + 600, Instance_Radar:GetPosY())
  aniInfo1.IsChangeChild = true
end
function SortRadar_IconIndex()
  local mapButton = radarMap.controls
  Instance_Radar:SetChildIndex(radar_SizeSlider, 9999)
  Instance_Radar:SetChildIndex(radar_AlphaScrl, 9999)
  Instance_Radar:SetChildIndex(mapButton.radar_Reset, 9999)
  Instance_Radar:SetChildIndex(radar_MiniMapScl, 9999)
end
function radarMap:getIdleIcon()
  local iconPool = self.iconPool
  if 0 < iconPool:length() then
    return iconPool:pop_back()
  else
    self.iconCreateCount = self.iconCreateCount + 1
    local make_Icon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Instance_Radar, "Static_Icon_" .. self.iconCreateCount)
    return make_Icon
  end
end
function radarMap:returnIconToPool(icon)
  self.iconPool:push_back(icon)
end
function radarMap:getIdleQuest()
  local questPool = self.questIconPool
  if 0 < questPool:length() then
    return questPool:pop_back()
  else
    self.questCreateCount = self.questCreateCount + 1
    local iconQuestArea = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Instance_Radar, "Static_QuestArea_" .. self.questCreateCount)
    local iconQuestArrow = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Instance_Radar, "Static_QuestArrow_" .. self.questCreateCount)
    CopyBaseProperty(self.template.area_quest, iconQuestArea)
    CopyBaseProperty(self.template.area_quest_guideArrow, iconQuestArrow)
    iconQuestArea:SetShow(false)
    iconQuestArrow:SetShow(false)
    iconQuestArea:SetSize(self.template.area_quest:GetSizeX(), self.template.area_quest:GetSizeY())
    iconQuestArrow:SetPosX(self.pcPosBaseControl.x - iconQuestArrow:GetSizeX() / 2)
    iconQuestArrow:SetPosY(self.pcPosBaseControl.y - iconQuestArrow:GetSizeY() / 2)
    iconQuestArrow:SetSize(self.template.area_quest_guideArrow:GetSizeX(), self.template.area_quest_guideArrow:GetSizeY())
    QuestArrowHalfSize = iconQuestArrow:GetSizeY() / 2
    local questIcon = {icon_QuestArea = iconQuestArea, icon_QuestArrow = iconQuestArrow}
    return questIcon
  end
end
function radarMap:returnQuestToPool(questIcon)
  self.questIconPool:push_back(questIcon)
end
function showUseLanternToolTip(param)
  local itemWrapper = ToClient_getEquipmentItem(13)
  if nil == itemWrapper and true == param and useLanternAlertTime < 100 then
    FGlobal_ShowUseLantern(true)
    useLanternAlertTime = useLanternAlertTime + 1
  else
    FGlobal_ShowUseLantern(false)
  end
end
local function RadarMap_UpdateSelfPlayerPerFrame()
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return
  end
  local selfPlayer = selfPlayerWrapper:get()
  if nil == selfPlayer then
    return
  end
  local selfPlayerIcon = radarMap.controls.icon_SelfPlayer
  if false == radarMap.isRotateMode then
    selfPlayerIcon:SetRotate(getCameraRotation())
  else
    Instance_Radar:SetRotate(-getCameraRotation() + PI)
  end
  local pcInfo = radarMap.pcInfo
  local selfPlayerPos = pcInfo.position
  selfPlayerPos.x = selfPlayer:getPositionX()
  selfPlayerPos.y = selfPlayer:getPositionY()
  selfPlayerPos.z = selfPlayer:getPositionZ()
  pcInfo.s64_teamNo = selfPlayerWrapper:getTeamNo_s64()
  radarMap.template.area_siegeAttackHit:SetShow(true)
end
function FromClient_setSiegeAttackAreaPosition(position)
  _siegeAttackPosition = position
  _OnSiegeRide = true
end
local getPosBaseControl = function(actorPosition)
  local selfPlayerPos = radarMap.pcInfo.position
  local selfPlayerControlPos = radarMap.pcPosBaseControl
  local dx = (actorPosition.x - selfPlayerPos.x) * 0.01
  local dz = (selfPlayerPos.z - actorPosition.z) * 0.01
  local distanceSq = dx * dx + dz * dz
  local dxPerPixel = dx * radarMap.worldDistanceToPixelRate + selfPlayerControlPos.x
  local dyPerPixel = dz * radarMap.worldDistanceToPixelRate + selfPlayerControlPos.y
  local radius = radarMap.config.mapRadius
  local radiusSq = radius * radius
  return distanceSq < radiusSq, dxPerPixel, dyPerPixel
end
local getPosQuestControl = function(areaQuest)
  local selfPlayerPos = radarMap.pcInfo.position
  local selfPlayerControlPos = radarMap.pcPosBaseControl
  local dx = (areaQuest.x - selfPlayerPos.x) * 0.01
  local dz = (selfPlayerPos.z - areaQuest.z) * 0.01
  local distanceSq = dx * dx + dz * dz
  local dxPerPixel = dx * radarMap.worldDistanceToPixelRate * 2 + selfPlayerControlPos.x
  local dyPerPixel = dz * radarMap.worldDistanceToPixelRate * 2 + selfPlayerControlPos.y
  local radius = radarMap.config.mapRadius + areaQuest.radius * 0.01
  return distanceSq <= radius * radius, dxPerPixel, dyPerPixel
end
local RadarMap_DestoryQuestIcons = function()
  for idx, areaQuest in pairs(radarMap.areaQuests) do
    if nil ~= areaQuest then
      areaQuest.icon_QuestArea:SetShow(false)
      areaQuest.icon_QuestArrow:SetShow(false)
      radarMap:returnQuestToPool(areaQuest)
    end
  end
  radarMap.areaQuests = {}
end
function RadarMap_UpdatePixelRate()
  for _, areaQuest in pairs(radarMap.areaQuests) do
    local size = floor(radarMap.worldDistanceToPixelRate * areaQuest.radius * 0.02)
    areaQuest.icon_QuestArea:SetSize(size, size)
  end
end
local function RadarMap_UpdateQuestAreaPositionPerFrame()
  local enableHalfSize = 12
  local sizeX = Instance_Radar:GetSizeX()
  local sizeY = Instance_Radar:GetSizeY()
  local halfSizeX = sizeX * 0.5
  local halfSizeY = sizeY * 0.5
  local halfSizeXSq = halfSizeX * halfSizeX
  sizeY = sizeY * 0.9
  local camRot = getCameraRotation()
  local camRotAddedPI = camRot + PI
  local radarPosX = Instance_Radar:GetPosX()
  local radarPosY = Instance_Radar:GetPosY()
  local selfPlayerControlPos = radarMap.pcPosBaseControl
  local rotateMode = radarMap.isRotateMode
  local selfPcInfo = radarMap.pcInfo
  local selfPlayerPos = selfPcInfo.position
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  local centerPosX = radarPosX + halfSizeX - 5
  local centerPosY = radarPosY + halfSizeY + 15
  local distancex = mousePosX - centerPosX
  local distancey = mousePosY - centerPosY
  local distanceSq = distancex * distancex + distancey * distancey
  local IsViewSelfPlayerFunc = ToClient_IsViewSelfPlayer
  local areaQuestsContainer = radarMap.areaQuests
  for _, areaQuest in pairs(areaQuestsContainer) do
    local questAreaIcon = areaQuest.icon_QuestArea
    local questArrowIcon = areaQuest.icon_QuestArrow
    local isShow, posX, posY = getPosQuestControl(areaQuest)
    if isShow then
      local areaSize = questAreaIcon:GetSizeX()
      local areaHalfSize = areaSize * 0.5
      local distx = posX - selfPlayerControlPos.x
      local disty = posY - selfPlayerControlPos.y
      local tempPos = float2(distx, disty)
      if rotateMode then
        tempPos:rotate(camRotAddedPI)
      end
      local floorAreaHalfSize = floor(areaHalfSize)
      posX = posX - floorAreaHalfSize
      posY = posY - floorAreaHalfSize
      questAreaIcon:SetPosX(posX)
      questAreaIcon:SetPosY(posY)
      questAreaIcon:SetEnableArea(tempPos.x - distx, tempPos.y - disty, tempPos.x - distx + areaSize, tempPos.y - disty + areaSize)
      questAreaIcon:SetRectClip(float2(-posX, -posY), float2(radarPosX + sizeX - questAreaIcon:GetParentPosX(), radarPosY + sizeY - questAreaIcon:GetPosY()))
    else
      questArrowIcon:SetPosX((sizeX - questArrowIcon:GetSizeX()) * 0.5)
      questArrowIcon:SetPosY((sizeY - questArrowIcon:GetSizeY()) * 0.5)
      local dx = selfPlayerPos.x - areaQuest.x
      local dy = selfPlayerPos.z - areaQuest.z
      local radian = atan2(dx, dy)
      local arrowIconRotate = radian
      local arrowCalcRotate = -radian
      if rotateMode then
        arrowIconRotate = radian - camRotAddedPI
        arrowCalcRotate = -radian - camRotAddedPI
      end
      questArrowIcon:SetRotate(arrowIconRotate)
      questAreaIcon:SetParentRotCalc(rotateMode)
      local tempPos = float2(0, QuestArrowHalfSize)
      tempPos:rotate(-arrowIconRotate)
      questArrowIcon:SetEnableArea(QuestArrowHalfSize + tempPos.x - enableHalfSize, QuestArrowHalfSize + tempPos.y - enableHalfSize, QuestArrowHalfSize + tempPos.x + enableHalfSize, QuestArrowHalfSize + tempPos.y + enableHalfSize)
    end
    if halfSizeXSq > distanceSq then
      questAreaIcon:SetIgnore(false)
      if isQuestDescShow then
        Panel_QuestInfo:SetShow(true, true)
      end
    else
      questAreaIcon:SetIgnore(true)
    end
    questAreaIcon:SetShow(isShow)
    local questArrowIconShow = false
    if not isShow then
      local pos = float3(selfPlayerPos.x, selfPlayerPos.y, selfPlayerPos.z)
      if true == IsViewSelfPlayerFunc(pos) then
        questArrowIconShow = not isShow
      end
    end
    questArrowIcon:SetShow(questArrowIconShow)
  end
end
function RadarMap_DestoryOtherActor(actorKeyRaw)
  local actorIcon = radarMap.actorIcons[actorKeyRaw]
  if nil ~= actorIcon then
    actorIcon:SetShow(false)
    radarMap:returnIconToPool(actorIcon)
    radarMap.actorIcons[actorKeyRaw] = nil
  end
end
function Radar_ChangeTexture_On()
  RadarText:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_RADER_RADER") .. "-" .. PAGetString(Defines.StringSheet_GAME, "PANEL_RADER_MOVE_DRAG"))
end
function Radar_ChangeTexture_Off()
  RadarText:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_RADER_RADER"))
end
function Panel_Radar_ShowToggle()
  local isShow = Instance_Radar:IsShow()
  if isShow then
    Instance_Radar:SetShow(false)
    RadarBackground_Hide()
  else
    Instance_Radar:SetShow(true)
    RadarBackground_Show()
  end
end
local iconPartyMemberArrow = {}
local function partyMemberArrowIcon(index, isShow)
  if nil == iconPartyMemberArrow[index] then
    if false == isShow then
      return
    end
    iconPartyMemberArrow[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Instance_Radar, "Static_PartyMemberArrow_" .. index)
    CopyBaseProperty(radarMap.template.area_quest_guideArrow, iconPartyMemberArrow[index])
    iconPartyMemberArrow[index]:SetColor(Defines.Color.C_FF00C0D7)
    iconPartyMemberArrow[index]:SetEnable(true)
    iconPartyMemberArrow[index]:SetIgnore(true)
    Instance_Radar:SetChildIndex(iconPartyMemberArrow[index], 9999)
    iconPartyMemberArrow[index]:SetParentRotCalc(radarMap.isRotateMode)
  end
  iconPartyMemberArrow[index]:SetShow(isShow)
  if true == isShow then
    iconPartyMemberArrow[index]:SetPosX(radarMap.pcPosBaseControl.x - iconPartyMemberArrow[index]:GetSizeX() / 2)
    iconPartyMemberArrow[index]:SetPosY(radarMap.pcPosBaseControl.y - iconPartyMemberArrow[index]:GetSizeY() / 2)
    iconPartyMemberArrow[index]:SetSize(radarMap.template.area_quest_guideArrow:GetSizeX(), radarMap.template.area_quest_guideArrow:GetSizeY())
    local memberData = RequestParty_getPartyMemberAt(index)
    local dx = radarMap.pcInfo.position.x - memberData:getPositionX()
    local dy = radarMap.pcInfo.position.z - memberData:getPositionZ()
    local radian = atan2(dx, dy)
    iconPartyMemberArrow[index]:SetRotate(radian)
    iconPartyMemberArrow[index]:SetParentRotCalc(radarMap.isRotateMode)
    Instance_Radar:SetChildIndex(iconPartyMemberArrow[index], 9999)
  end
end
local function partyMemberIconPerFrame()
  local partyMemberCount = FGlobal_PartyMemberCount()
  for i = 0, 4 do
    partyMemberArrowIcon(i, false)
  end
  if false == _ContentsGroup_RemasterUI_Party then
    if partyMemberCount <= 0 or false == Panel_Party:GetShow() then
      return
    end
  elseif partyMemberCount <= 0 or false == PaGlobalFunc_PartyWidget_GetShow() then
    return
  end
  for index = 0, partyMemberCount - 1 do
    local memberData = RequestParty_getPartyMemberAt(index)
    if nil ~= memberData then
      local isNearPartyMember = getPlayerActor(memberData:getActorKey())
      if nil == isNearPartyMember then
        partyMemberArrowIcon(index, true)
      else
        partyMemberArrowIcon(index, false)
      end
    else
      partyMemberArrowIcon(index, false)
    end
  end
end
local getPosBaseControl2 = function(actorPosition)
  local selfPlayerPos = radarMap.pcInfo.position
  local selfPlayerControlPos = radarMap.pcPosBaseControl
  local dx = (actorPosition.x - selfPlayerPos.x) * 0.01
  local dz = (selfPlayerPos.z - actorPosition.z) * 0.01
  local distanceSq = (dx * dx + dz * dz) * 2
  local dxPerPixel = dx * radarMap.worldDistanceToPixelRate * 2 + selfPlayerControlPos.x
  local dyPerPixel = dz * radarMap.worldDistanceToPixelRate * 2 + selfPlayerControlPos.y
  local radius = radarMap.config.mapRadius
  local radiusSq = radius * radius
  return distanceSq < radiusSq, dxPerPixel, dyPerPixel
end
local function RadarMap_UpdateSelfPlayerNavigationGuide()
  local color = float4(1, 0.8, 0.6, 1)
  local colorBG = float4(0.6, 0.2, 0.2, 0.3)
  local radarBackground = radarMap.controls.radar_Background
  ToClient_clearShowAALineList()
  local pathSize = ToClient_getRenderPathSize()
  local getRenderPathByIndexFunc = ToClient_getRenderPathByIndex
  local unRenderCount = 0
  for ii = 0, pathSize - 1 do
    local pathPosition = getRenderPathByIndexFunc(ii)
    local isShow, posX, posY = getPosBaseControl2(pathPosition)
    ToClient_addShowAALineList(float3(posX, posY, 0))
    if not isShow then
      unRenderCount = unRenderCount + 1
      if unRenderCount >= 5 then
        break
      end
    else
      unRenderCount = 0
    end
  end
  ToClient_setColorShowAALineList(color)
  ToClient_setBGColorShowAALineList(colorBG)
end
local reposition_CenterPos = function()
  local SPI = radarMap.controls.icon_SelfPlayer
  local halfSelfSizeX = SPI:GetSizeX() / 2
  local halfSelfSizeY = SPI:GetSizeY() / 2
  local radarBackground = radarMap.controls.radar_Background
  local panelCenter = float2(radarBackground:GetSizeX() * 0.5, radarBackground:GetSizeY() * 0.5)
  SPI:SetPosX(panelCenter.x - halfSelfSizeX)
  SPI:SetPosY(panelCenter.y - halfSelfSizeY)
  radarMap.pcPosBaseControl.x = SPI:GetPosX() + halfSelfSizeX
  radarMap.pcPosBaseControl.y = SPI:GetPosY() + halfSelfSizeY
  ToClient_setRadorUICenterPosition(int2(radarMap.pcPosBaseControl.x, radarMap.pcPosBaseControl.y))
  ToClient_SetRadarCenterPos(float2(radarMap.pcPosBaseControl.x, radarMap.pcPosBaseControl.y))
end
local chattingAlertTimeCheck = 60
local strongMonsterCheckDistance = 3500
function RadarMap_UpdatePerFrame(deltaTime)
  RadarMap_UpdateSelfPlayerPerFrame()
  RadarMap_UpdateSelfPlayerNavigationGuide()
  RadarMap_UpdateSiegeAttackArea()
  RadarBackground_updatePerFrame(deltaTime)
  partyMemberIconPerFrame()
  _OnSiegeRide = false
  if ToClient_GetState_EnemyOnMyBoatAlert() then
    FGlobal_EnemyAlert_OnShip_Show()
  end
  updateLostRegion(deltaTime)
end
function TimeBar_UpdatePerFrame(deltaTime)
end
function FGlobal_ChattingAlert_Call()
end
local textAniTime = 0
local isAnimation = false
function StrongMonsterByNear(deltaTime)
  textAniTime = textAniTime + deltaTime
  if FromClient_DetectsOfStrongMonster(strongMonsterCheckDistance) then
    local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
    local isSafeZone = regionInfo:get():isSafeZone()
    if textAniTime < 2 and false == isAnimation and not currentSafeZone then
      redar_DangerAletText:SetShow(true)
      local aniInfo = UIAni.AlphaAnimation(1, redar_DangerAletText, 0, 0.4)
      isAnimation = true
    elseif textAniTime > 2 and textAniTime < 5 and isAnimation then
      local aniInfo = UIAni.AlphaAnimation(0, redar_DangerAletText, 0, 0.4)
      aniInfo:SetHideAtEnd(true)
      isAnimation = false
    elseif textAniTime > 5 then
      textAniTime = 0
    end
    if not radar_DangetAlertBg:GetShow() and not currentSafeZone then
      radar_DangetAlertBg:SetShow(true)
    end
  else
    redar_DangerAletText:SetShow(false)
    radar_DangetAlertBg:SetShow(false)
  end
end
function RadarMap_UpdateSiegeAttackArea()
  if _OnSiegeRide == false or _OnSiegeRide == true then
    radarMap.template.area_siegeAttackHit:SetShow(false)
    return
  end
  local position = _siegeAttackPosition
  local hitArea = radarMap.template.area_siegeAttackHit
  local selfPlayerPos = radarMap.pcInfo.position
  local selfPlayerControlPos = radarMap.pcPosBaseControl
  local dx = (position.x - selfPlayerPos.x) * 0.01
  local dz = (selfPlayerPos.z - position.z) * 0.01
  local dxPerPixel = dx * radarMap.worldDistanceToPixelRate * 2 + selfPlayerControlPos.x
  local dyPerPixel = dz * radarMap.worldDistanceToPixelRate * 2 + selfPlayerControlPos.y
  local areaSize = hitArea:GetSizeX()
  local areaHalfSize = areaSize * 0.5
  local posX = dxPerPixel - floor(areaHalfSize)
  local posY = dyPerPixel - floor(areaHalfSize)
  local currentRate = RadarMap_GetDistanceToPixelRate()
  _const_siegeAttackHitArea = floor(currentRate * 48)
  hitArea:SetSize(_const_siegeAttackHitArea, _const_siegeAttackHitArea)
  hitArea:SetPosX(posX)
  hitArea:SetPosY(posY)
  hitArea:SetDepth(-2)
  hitArea:SetParentRotCalc(radarMap.isRotateMode)
end
function RadarMap_SimpleUIUpdatePerFrame(deltaTime)
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  local isUiMode = CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode == getInputMode() or CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode == getInputMode()
  local IsMouseOver = mousePosX > Instance_Radar:GetPosX() - 20 and mousePosX < Instance_Radar:GetPosX() + Instance_Radar:GetSizeX() + 20 and mousePosY > Instance_Radar:GetPosY() - 20 and mousePosY < Instance_Radar:GetPosY() + Instance_Radar:GetSizeY() + 20
  isUiMode = isUiMode and IsMouseOver
  if IsMouseOver then
    simpleUIAlpha = 1
  end
  UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.timeNum, 5 * deltaTime)
  UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.radar_Plus, 5 * deltaTime)
  UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.radar_Minus, 5 * deltaTime)
  UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.radar_Reset, 5 * deltaTime)
  UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_AlphaScrl, 5 * deltaTime)
  UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_AlphaBtn, 5 * deltaTime)
  UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_MiniMapScl, 5 * deltaTime)
  if false == _ContentsGroup_RemasterUI_Radar then
    UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.radar_AlphaPlus, 5 * deltaTime)
    UIAni.perFrameAlphaAnimation(simpleUIAlpha, radarMap.controls.radar_AlphaMinus, 5 * deltaTime)
    UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_SizeSlider, 5 * deltaTime)
    UIAni.perFrameAlphaAnimation(simpleUIAlpha, radar_SizeBtn, 5 * deltaTime)
  end
end
registerEvent("FromClient_setSiegeAttackAreaPosition", "FromClient_setSiegeAttackAreaPosition")
function RadarMap_GetDistanceToPixelRate()
  return radarMap.worldDistanceToPixelRate
end
function RadarMap_GetSelfPosInRadar()
  return radarMap.pcPosBaseControl
end
function RadarMap_GetScaleRateWidth()
  return radarMap.scaleRateWidth
end
function RadarMap_GetScaleRateHeight()
  return radarMap.scaleRateHeight
end
function HandleClicked_RadarResize()
  ToClient_SaveUiInfo(false)
end
function RadarMap_InitPanel()
  ToClient_setRadarType(false)
  ToClient_setRadorUIPanel(Instance_Radar)
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eRadarSwap, false, CppEnums.VariableStorageType.eVariableStorageType_User)
  Radar_updateWorldMap_AlphaControl(1)
  ToClient_setRadorUIViewDistanceRate(7225)
  ToCleint_InitializeRadarActorPool(1000)
end
checkLoad()
controlInit()
RadarMap_InitPanel()
registerEvent("EventActorDelete", "RadarMap_DestoryOtherActor")
Instance_Radar:addInputEvent("Mouse_On", "Radar_ChangeTexture_On()")
Instance_Radar:addInputEvent("Mouse_Out", "Radar_ChangeTexture_Off()")
Instance_Radar:addInputEvent("Mouse_LUp", "ResetPos_WidgetButton()")
function RadarMap_EnableSimpleUI_Force_Over()
  RadarMap_EnableSimpleUI(true)
end
function RadarMap_EnableSimpleUI_Force_Out()
  RadarMap_EnableSimpleUI(false)
end
registerEvent("EventSimpleUIEnable", "RadarMap_EnableSimpleUI_Force_Over")
registerEvent("EventSimpleUIDisable", "RadarMap_EnableSimpleUI_Force_Out")
function RadarMap_EnableSimpleUI(isEnable)
  cacheSimpleUI_ShowButton = true
end
if getEnableSimpleUI() then
end
function RadarMap_SetDragMode(isSet)
  isDrag = isSet
end
function resetRadarActorListRotateValue()
  local actorList
  for Key, value in pairs(typeDepth) do
    actorList = FromClient_getRadarIconList(Key)
    for key, control in pairs(actorList) do
      control:SetRotate(0)
    end
  end
end
function FGlobal_Radar_SetColorBlindMode()
  local ActorIconList
  local isColorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  if 0 == isColorBlindMode then
    for key, value in pairs(colorBlindNone) do
      ActorIconList = FromClient_getRadarIconList(key)
      for key, control in pairs(ActorIconList) do
        control:SetColor(value)
      end
    end
  elseif 1 == isColorBlindMode then
    for key, value in pairs(colorBlindRed) do
      ActorIconList = FromClient_getRadarIconList(key)
      for key, control in pairs(ActorIconList) do
        control:SetColor(value)
      end
    end
  elseif 2 == isColorBlindMode then
    for key, value in pairs(colorBlindGreen) do
      ActorIconList = FromClient_getRadarIconList(key)
      for key, control in pairs(ActorIconList) do
        control:SetColor(value)
      end
    end
  end
end
function FromClient_RadarUICreated(actorKeyRaw, control, actorProxyWrapper, radarTypeValue)
  control:SetSize(10, 10)
  local base = template[radarTypeValue]
  local isColorBlindType = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  if radarType.radarType_bossMonster ~= radarTypeValue and radarType.radarType_partyMember ~= radarTypeValue then
    return
  end
  if nil ~= base then
    CopyBaseProperty(base, control)
    control:SetShow(true)
    if 0 == isColorBlindType then
      if radarType.radarType_allymonster == radarTypeValue then
        control:SetColor(UI_color.C_FFB22300)
      elseif radarType.radarType_normalMonster == radarTypeValue then
        control:SetColor(UI_color.C_FFB22300)
      elseif radarType.radarType_namedMonster == radarTypeValue then
        control:SetColor(UI_color.C_FFB22300)
      elseif radarType.radarType_bossMonster == radarTypeValue then
        control:SetColor(UI_color.C_FFB22300)
      elseif radarType.radarType_huntingMonster == radarTypeValue then
        control:SetColor(UI_color.C_FFB22300)
      elseif radarType.radarType_normalMonsterQuestTarget == radarTypeValue then
        control:SetColor(UI_color.C_FFEE9900)
      elseif radarType.radarType_namedMonsterQuestTarget == radarTypeValue then
        control:SetColor(UI_color.C_FFEE9900)
      elseif radarType.radarType_bossMonsterQuestTarget == radarTypeValue then
        control:SetColor(UI_color.C_FFEE9900)
      elseif radarType.radarType_huntingMonsterQuestTarget == radarTypeValue then
        control:SetColor(UI_color.C_FFEE9900)
      end
    elseif 1 == isColorBlindType then
      if radarType.radarType_allymonster == radarTypeValue then
        control:SetColor(UI_color.C_FFD85300)
      elseif radarType.radarType_normalMonster == radarTypeValue then
        control:SetColor(UI_color.C_FFD85300)
      elseif radarType.radarType_namedMonster == radarTypeValue then
        control:SetColor(UI_color.C_FFD85300)
      elseif radarType.radarType_bossMonster == radarTypeValue then
        control:SetColor(UI_color.C_FFD85300)
      elseif radarType.radarType_huntingMonster == radarTypeValue then
        control:SetColor(UI_color.C_FFD85300)
      elseif radarType.radarType_normalMonsterQuestTarget == radarTypeValue then
        control:SetColor(UI_color.C_FFFFE866)
      elseif radarType.radarType_namedMonsterQuestTarget == radarTypeValue then
        control:SetColor(UI_color.C_FFFFE866)
      elseif radarType.radarType_bossMonsterQuestTarget == radarTypeValue then
        control:SetColor(UI_color.C_FFFFE866)
      elseif radarType.radarType_huntingMonsterQuestTarget == radarTypeValue then
        control:SetColor(UI_color.C_FFFFE866)
      end
    elseif 2 == isColorBlindType then
      if radarType.radarType_allymonster == radarTypeValue then
        control:SetColor(UI_color.C_FFD82800)
      elseif radarType.radarType_normalMonster == radarTypeValue then
        control:SetColor(UI_color.C_FFD82800)
      elseif radarType.radarType_namedMonster == radarTypeValue then
        control:SetColor(UI_color.C_FFD82800)
      elseif radarType.radarType_bossMonster == radarTypeValue then
        control:SetColor(UI_color.C_FFD82800)
      elseif radarType.radarType_huntingMonster == radarTypeValue then
        control:SetColor(UI_color.C_FFD82800)
      elseif radarType.radarType_normalMonsterQuestTarget == radarTypeValue then
        control:SetColor(UI_color.C_FFFFE866)
      elseif radarType.radarType_namedMonsterQuestTarget == radarTypeValue then
        control:SetColor(UI_color.C_FFFFE866)
      elseif radarType.radarType_bossMonsterQuestTarget == radarTypeValue then
        control:SetColor(UI_color.C_FFFFE866)
      elseif radarType.radarType_huntingMonsterQuestTarget == radarTypeValue then
        control:SetColor(UI_color.C_FFFFE866)
      end
    end
  else
    control:SetShow(false)
  end
  monsterTitle = nil
  SortRadar_IconIndex()
  ToClient_setRadorUICenterPosition(int2(radarMap.pcPosBaseControl.x, radarMap.pcPosBaseControl.y))
  control:SetDepth(typeDepth[radarTypeValue])
  control:addInputEvent("Mouse_RUp", "RadarMap_Background_MouseRUp()")
end
function FromClient_radarTypeChanged(actorKeyRaw, targetUI, radarTypeValue)
  local templateUI = template[radarTypeValue]
  if nil == templateUI then
    targetUI:SetShow(false)
    return
  end
  if radarType.radarType_bossMonster ~= radarTypeValue and radarType.radarType_partyMember ~= radarTypeValue then
    return
  end
  CopyBaseProperty(templateUI, targetUI)
  local isColorBlindType = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  if 0 == isColorBlindType then
    if radarType.radarType_allymonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFB22300)
    elseif radarType.radarType_normalMonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFB22300)
    elseif radarType.radarType_namedMonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFB22300)
    elseif radarType.radarType_bossMonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFB22300)
    elseif radarType.radarType_huntingMonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFB22300)
    elseif radarType.radarType_normalMonsterQuestTarget == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFEE9900)
    elseif radarType.radarType_namedMonsterQuestTarget == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFEE9900)
    elseif radarType.radarType_bossMonsterQuestTarget == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFEE9900)
    elseif radarType.radarType_huntingMonsterQuestTarget == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFEE9900)
    end
  elseif 1 == isColorBlindType then
    if radarType.radarType_allymonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFD85300)
    elseif radarType.radarType_normalMonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFD85300)
    elseif radarType.radarType_namedMonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFD85300)
    elseif radarType.radarType_bossMonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFD85300)
    elseif radarType.radarType_huntingMonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFD85300)
    elseif radarType.radarType_normalMonsterQuestTarget == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFFFE866)
    elseif radarType.radarType_namedMonsterQuestTarget == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFFFE866)
    elseif radarType.radarType_bossMonsterQuestTarget == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFFFE866)
    elseif radarType.radarType_huntingMonsterQuestTarget == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFFFE866)
    end
  elseif 2 == isColorBlindType then
    if radarType.radarType_allymonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFD82800)
    elseif radarType.radarType_normalMonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFD82800)
    elseif radarType.radarType_namedMonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFD82800)
    elseif radarType.radarType_bossMonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFD82800)
    elseif radarType.radarType_huntingMonster == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFD82800)
    elseif radarType.radarType_normalMonsterQuestTarget == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFFFE866)
    elseif radarType.radarType_namedMonsterQuestTarget == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFFFE866)
    elseif radarType.radarType_bossMonsterQuestTarget == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFFFE866)
    elseif radarType.radarType_huntingMonsterQuestTarget == radarTypeValue then
      targetUI:SetColor(UI_color.C_FFFFE866)
    end
  end
  targetUI:SetDepth(typeDepth[radarTypeValue])
end
registerEvent("FromClient_RadorTypeChanged", "FromClient_radarTypeChanged")
registerEvent("FromClient_RadorUICreated", "FromClient_RadarUICreated")
function CalcPositionUseToTextUI(targetUIposX, targetUIposY, textUI)
  if Instance_Radar:GetSizeX() < targetUIposX + textUI:GetTextSizeX() then
    textUI:SetPosX(Instance_Radar:GetSizeX() - textUI:GetTextSizeX())
  else
    textUI:SetPosX(targetUIposX)
  end
  if Instance_Radar:GetPosY() > targetUIposY - textUI:GetTextSizeY() then
    textUI:SetPosY(Instance_Radar:GetPosY())
  else
    textUI:SetPosY(targetUIposY - textUI:GetTextSizeY())
  end
end
function PaGlobal_Radar_WarAlert(isShow)
  radar_WarAlert:SetShow(isShow)
end
function PaGlobal_Radar_GuildTeamBattleAlert(isShow)
  radar_GuildTeamBattleAlert:SetShow(isShow)
end
function RadarResizeByReset(resetRadarScale)
  if false == resetRadarScale then
    local RadarCurrentSizeX = Instance_Radar:GetSizeX()
    local RadarCurrentSizeY = Instance_Radar:GetSizeY()
    Instance_Radar:SetSize(RadarCurrentSizeX, RadarCurrentSizeY)
  else
    Instance_Radar:SetSize(Panel_OrigSizeX, Panel_OrigSizeY)
  end
  radarMap.controls.radar_Background:SetPosX(0)
  radarMap.controls.radar_Background:SetSize(Panel_OrigSizeX, Panel_OrigSizeY)
  Instance_Radar:ComputePos()
  local SPI = radarMap.controls.icon_SelfPlayer
  local halfSelfSizeX = SPI:GetSizeX() / 2
  local halfSelfSizeY = SPI:GetSizeY() / 2
  local halfSizeX = Instance_Radar:GetSizeX() / 2
  local halfSizeY = Instance_Radar:GetSizeY() / 2
  SPI:SetPosX(halfSizeX - halfSelfSizeX)
  SPI:SetPosY(halfSizeY - halfSelfSizeY)
  radarMap.pcPosBaseControl.x = SPI:GetPosX() + halfSelfSizeX
  radarMap.pcPosBaseControl.y = SPI:GetPosY() + halfSelfSizeY
  ToClient_setRadorUICenterPosition(int2(radarMap.pcPosBaseControl.x, radarMap.pcPosBaseControl.y))
  controlAlign()
  NpcNavi_Reset_Posistion()
  TownNpcIcon_Resize()
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    Panel_PlayerEndurance_Position()
    Panel_CarriageEndurance_Position()
    Panel_HorseEndurance_Position()
    Panel_ShipEndurance_Position()
  end
  if false == _ContentsGroup_RemasterUI_Main_RightTop then
    FGlobal_PersonalIcon_ButtonPosUpdate()
  else
    FromClient_Widget_FunctionButton_Resize()
  end
  FromClient_MainQuestWidget_ResetPosition()
  if false == _ContentsGroup_RemasterUI_QuestWidget then
    PaGlobalFunc_Quest_UpdatePosition()
  end
  ToClient_SaveUiInfo(false)
  radarAlert_Resize()
end
function FGlobal_ResetRadarUI(resetRadarScale)
  RadarResizeByReset(resetRadarScale)
  radar_AlphaScrl:SetControlPos(ToClient_GetRaderAlpha() * 100)
  Radar_updateWorldMap_AlphaControl_Init()
  radar_SizeSlider:SetControlPos(ToClient_GetRaderScale() * 100)
  local scaleSlideValue = 1 - radar_SizeSlider:GetControlPos()
  updateWorldMapDistance(scaleMinValue + scaleSlideValue * 100)
end
function Radar_luaLoadComplete()
  controlAlign()
  PaGlobal_Radar_GuildTeamBattleAlert(false)
  radarAlert_Resize()
  if false == ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eRadarSwap) then
    if 0 <= ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_RadarMap, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow) then
      Instance_Radar:SetShow(ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_RadarMap, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow))
    else
      Instance_Radar:SetShow(true, false)
    end
  end
  battleRoyale._ui.mapLine_current:SetShow(false)
  battleRoyale._ui.mapLine_next:SetShow(false)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
end
function PaGlobalFunc_Radar_Resize()
  controlAlign()
  radarAlert_Resize()
  reposition_CenterPos()
end
function FromClient_Radar_LostRegionInfo()
  battleRoyale.lostRegionInfo.isCallNextRegion = true
  local msg = {
    main = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_NEXTCIRCLE_MESSAGE"),
    sub = ""
  }
  Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect(msg, 6, 3)
end
registerEvent("FromClient_luaLoadComplete", "Radar_luaLoadComplete")
registerEvent("FromClient_ChangeRadarRotateMode", "Radar_SetRotateMode")
registerEvent("onScreenResize", "PaGlobalFunc_Radar_Resize")
registerEvent("FromClinet_LostRegionInfo", "FromClient_Radar_LostRegionInfo")

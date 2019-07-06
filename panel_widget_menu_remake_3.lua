function PaGlobal_Menu_Remake:SetSubmenuHotKeyInfo()
  PaGlobal_Menu_Remake._menuHotKey = {}
  PaGlobal_Menu_Remake._menuHotKey = {
    [1] = {
      hotKey = CppEnums.VirtualKeyCode.KeyCode_F1,
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_CATEGORY_1"),
      subMenu = {
        [1] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_HELP"),
          func = FGlobal_Panel_WebHelper_ShowToggle,
          isContentOpen = not PaGlobal_Menu_Remake._contentsGroup._isTestServer,
          index = 1,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 2,
            y1 = 457,
            x2 = 57,
            y2 = 512
          }
        },
        [2] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_PRODUCTION"),
          func = Panel_ProductNote_ShowToggle,
          isContentOpen = not PaGlobal_Menu_Remake._contentsGroup._isTestServer,
          index = 2,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 344,
            y1 = 59,
            x2 = 399,
            y2 = 114
          }
        },
        [3] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_KEYBOARD_HELP"),
          func = FGlobal_KeyboardHelpShow,
          isContentOpen = true,
          index = 58,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 458,
            y1 = 173,
            x2 = 513,
            y2 = 228
          }
        },
        [4] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_LIFE_RANK"),
          func = PaGlobalFunc_Menu_All_LifeRanker_Open,
          isContentOpen = true,
          index = 46,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 458,
            y1 = 230,
            x2 = 513,
            y2 = 285
          }
        },
        [5] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_GUILD_RANK"),
          func = GuildRank_Web_Show,
          isContentOpen = not PaGlobal_Menu_Remake._contentsGroup._isTestServer,
          index = 47,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 173,
            y1 = 515,
            x2 = 228,
            y2 = 570
          }
        },
        [6] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_MONSTER_RANK"),
          func = FGlobal_MonsterRanking_Open,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isMonsterRanking,
          index = 48,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 515,
            y1 = 401,
            x2 = 570,
            y2 = 456
          }
        },
        [7] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_VOLUNTEER_RANK"),
          func = PaGlobal_VolunteerRankWeb_Open,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isBattleFieldVolunteer,
          index = 49,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 344,
            y1 = 515,
            x2 = 399,
            y2 = 570
          }
        },
        [8] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_COPYRIGHT"),
          func = PaGlobal_Copyright_ShowWindow,
          isContentOpen = true,
          index = 29,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 572,
            y1 = 2,
            x2 = 627,
            y2 = 57
          }
        }
      },
      ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
      ddsGrid = {
        x1 = 2,
        y1 = 457,
        x2 = 57,
        y2 = 512
      },
      isContentOpen = nil
    },
    [2] = {
      hotKey = CppEnums.VirtualKeyCode.KeyCode_F2,
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_CATEGORY_2"),
      subMenu = {
        [1] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_MYINFO"),
          func = HandleEventLUp_MenuRemake_Myinfo,
          isContentOpen = true,
          index = 7,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 59,
            y1 = 59,
            x2 = 114,
            y2 = 114
          }
        },
        [2] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_SKILL"),
          func = HandleEventLUp_MenuRemake_Skill,
          isContentOpen = ToClient_IsGrowStepOpen(__eGrowStep_skillWindow),
          index = 9,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 173,
            y1 = 2,
            x2 = 228,
            y2 = 57
          }
        },
        [3] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_INVENTORY"),
          func = HandleEventLUp_MenuRemake_Inventory,
          isContentOpen = true,
          index = 8,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 401,
            y1 = 59,
            x2 = 456,
            y2 = 114
          }
        },
        [4] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_MENTAL_KNOWLEDGE"),
          func = HandleEventLUp_MenuRemake_MentalKnowledge,
          isContentOpen = true,
          index = 24,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 173,
            y1 = 230,
            x2 = 228,
            y2 = 285
          }
        },
        [5] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_SELECT_CHARACTER"),
          func = Panel_GameExit_ClickSelectCharacter,
          isContentOpen = isGameTypeEnglish() or isGameServiceTypeDev(),
          index = 12,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 401,
            y1 = 2,
            x2 = 456,
            y2 = 57
          }
        },
        [6] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_BEAUTY"),
          func = HandleEventLUp_MenuRemake_Beauty,
          isContentOpen = CppEnums.ContentsServiceType.eContentsServiceType_Commercial == getContentsServiceType() and not PaGlobal_Menu_Remake._contentsGroup._isTestServer,
          index = 63,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 344,
            y1 = 116,
            x2 = 399,
            y2 = 171
          }
        },
        [7] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_DYE"),
          func = HandleEventLUp_MenuRemake_Dyeing,
          isContentOpen = true,
          index = 64,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 287,
            y1 = 401,
            x2 = 342,
            y2 = 456
          }
        },
        [8] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_COLORMIX"),
          func = Panel_ColorBalance_Show,
          isContentOpen = true,
          index = 67,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 515,
            y1 = 287,
            x2 = 570,
            y2 = 342
          }
        },
        [9] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_ESCAPE"),
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          func = HandleEventLUp_MenuRemake_Escape,
          isContentOpen = nil,
          ddsGrid = {
            x1 = 572,
            y1 = 59,
            x2 = 627,
            y2 = 114
          },
          index = 76
        }
      },
      ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
      ddsGrid = {
        x1 = 59,
        y1 = 59,
        x2 = 114,
        y2 = 114
      },
      isContentOpen = nil
    },
    [3] = {
      hotKey = CppEnums.VirtualKeyCode.KeyCode_F3,
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_CATEGORY_5"),
      subMenu = {
        [1] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_CHALLENGE"),
          func = HandleEventLUp_MenuRemake_Present,
          isContentOpen = true,
          index = 26,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 515,
            y1 = 116,
            x2 = 570,
            y2 = 171
          }
        },
        [2] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_TOTAL_REWARD"),
          func = PaGlobal_TotalReward_Open,
          isContentOpen = true,
          index = 27,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 515,
            y1 = 173,
            x2 = 570,
            y2 = 228
          }
        },
        [3] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_DAILYSTAMP"),
          func = PaGlobalFunc_Menu_All_DailyStamp_Open,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._joinCheckOpen,
          isConditionOpen = not PaGlobal_Menu_Remake._contentsGroup._isTestServer and PaGlobal_Menu_Remake._conditionGroup._isDailyStampOpen,
          index = 31,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 59,
            y1 = 116,
            x2 = 114,
            y2 = 171
          }
        },
        [4] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_BLACKSPIRIT_ADVANTURE"),
          func = FGlobal_BlackSpiritAdventure_Open,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isBlackSpiritAdventure and not PaGlobal_Menu_Remake._contentsGroup._isTestServer,
          index = 28,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 116,
            y1 = 457,
            x2 = 171,
            y2 = 512
          }
        }
      },
      isContentOpen = nil,
      ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
      ddsGrid = {
        x1 = 515,
        y1 = 116,
        x2 = 570,
        y2 = 171
      }
    },
    [4] = {
      hotKey = CppEnums.VirtualKeyCode.KeyCode_F4,
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_CATEGORY_3"),
      subMenu = {
        [1] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_PEARLSHOP"),
          func = HandleEventLUp_MenuRemake_CashShop,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isPearlOpen,
          index = 14,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 515,
            y1 = 458,
            x2 = 570,
            y2 = 513
          }
        },
        [2] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_ITEMMARKET"),
          func = HandleEventLUp_MenuRemake_Market,
          isContentOpen = not _ContentsGroup_RenewUI_ItemMarketPlace_Only,
          index = 15,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 287,
            y1 = 2,
            x2 = 342,
            y2 = 57
          }
        },
        [3] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_MARKETPLACE"),
          func = PaGlobalFunc_MarketPlace_Open,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isMarketPlaceOpen,
          index = 16,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 287,
            y1 = 2,
            x2 = 342,
            y2 = 57
          }
        },
        [4] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_MASTERPIECT_AUCTION"),
          func = FGlobal_MasterpieceAuction_OpenAuctionItemNotNpc,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isMasterpieceOpen,
          index = 18,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 572,
            y1 = 116,
            x2 = 627,
            y2 = 171
          }
        }
      },
      ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
      ddsGrid = {
        x1 = 515,
        y1 = 458,
        x2 = 570,
        y2 = 513
      },
      isContentOpen = nil
    },
    [5] = {
      hotKey = CppEnums.VirtualKeyCode.KeyCode_F5,
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_CATEGORY_4"),
      subMenu = {
        [1] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_BLACKSPIRIT"),
          func = HandleEventLUp_MenuRemake_BlackSpirit,
          isContentOpen = true,
          index = 22,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 515,
            y1 = 230,
            x2 = 570,
            y2 = 285
          }
        },
        [2] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_ACHIEVEMENT_BOOKSHELF"),
          func = PaGlobal_Achievement_BookShelf_Open,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isAchievementBookshelfOpen and ToClient_IsGrowStepOpen(__eGrowStep_oldBook),
          index = 19,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 401,
            y1 = 515,
            x2 = 456,
            y2 = 570
          }
        },
        [3] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_WORLDMAP"),
          func = HandleEventLUp_MenuRemake_WorldMap,
          isContentOpen = true,
          index = 20,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 116,
            y1 = 2,
            x2 = 171,
            y2 = 51
          }
        },
        [4] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_DROPITEM"),
          func = FGlobal_DropItemWindow_Open,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isDropItemOpen,
          index = 3,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 2,
            y1 = 344,
            x2 = 57,
            y2 = 399
          }
        },
        [5] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_BOSS_ALERT"),
          func = PaGlobal_BossAlertSet_Show,
          isConditionOpen = PaGlobal_Menu_Remake._conditionGroup._isBossAlert,
          isContentOpen = _ContetnsGroup_BossAlert,
          index = 4,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 458,
            y1 = 401,
            x2 = 513,
            y2 = 456
          }
        },
        [6] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_PERSONAL_MONSTER"),
          func = PaGlobalFunc_PersonalMonster_Open,
          isContentOpen = _ContentsGroup_NodeBoss,
          index = 25,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 515,
            y1 = 59,
            x2 = 570,
            y2 = 114
          }
        },
        [7] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_QUEST"),
          func = HandleEventLUp_MenuRemake_QuestHistory,
          isConditionOpen = PaGlobal_Menu_Remake._conditionGroup._isQuestOpen,
          isContentOpen = true,
          index = 23,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 59,
            y1 = 2,
            x2 = 114,
            y2 = 57
          }
        }
      },
      ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
      ddsGrid = {
        x1 = 116,
        y1 = 2,
        x2 = 171,
        y2 = 57
      },
      isContentOpen = nil
    },
    [6] = {
      hotKey = CppEnums.VirtualKeyCode.KeyCode_F6,
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_CATEGORY_6"),
      subMenu = {
        [1] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_FISH_ENCYCLOPEDIA"),
          func = FGlobal_FishEncyclopedia_Open,
          isContentOpen = true,
          index = 5,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 401,
            y1 = 287,
            x2 = 456,
            y2 = 342
          }
        },
        [2] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_TRADEMARKET"),
          func = HandleEventLUp_MenuRemake_TradeEvent,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isTradeEventOpen and ToClient_IsGrowStepOpen(__eGrowStep_trade),
          index = 6,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 401,
            y1 = 173,
            x2 = 456,
            y2 = 228
          }
        },
        [3] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_MANUFACTURE"),
          func = HandleEventLUp_MenuRemake_Manufacture,
          isContentOpen = ToClient_IsGrowStepOpen(__eGrowStep_manufacture),
          index = 34,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 116,
            y1 = 59,
            x2 = 171,
            y2 = 114
          }
        },
        [4] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_WORKER"),
          func = PaGlobalFunc_Menu_All_WorkerManager_Open,
          isContentOpen = ToClient_IsGrowStepOpen(__eGrowStep_worker),
          index = 35,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 2,
            y1 = 230,
            x2 = 57,
            y2 = 285
          }
        },
        [5] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_MYHOUSE"),
          func = FGlobal_HousingList_Open,
          isContentOpen = ToClient_IsGrowStepOpen(__eGrowStep_worker),
          index = 36,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 344,
            y1 = 2,
            x2 = 399,
            y2 = 57
          }
        },
        [6] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_GARDEN_FIELD"),
          func = FGlobal_HarvestList_Open,
          isContentOpen = true,
          index = 37,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 287,
            y1 = 287,
            x2 = 342,
            y2 = 342
          }
        },
        [7] = {
          title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ALCHEMYSTONE_TITLE"),
          func = FGlobal_AlchemyStone_Open,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isAlchemyStoneEnble,
          index = 79,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 457,
            y1 = 2,
            x2 = 512,
            y2 = 57
          }
        },
        [8] = {
          title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INVENTORY_TOTEMBUTTON"),
          func = FGlobal_AlchemyFigureHead_Open,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isAlchemyFigureHeadEnble,
          index = 80,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 458,
            y1 = 515,
            x2 = 513,
            y2 = 570
          }
        }
      },
      ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
      ddsGrid = {
        x1 = 2,
        y1 = 230,
        x2 = 57,
        y2 = 285
      },
      isContentOpen = nil
    },
    [7] = {
      hotKey = CppEnums.VirtualKeyCode.KeyCode_F7,
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_CATEGORY_7"),
      subMenu = {
        [1] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_LOCALWAR"),
          func = HandleEventLUp_MenuRemake_Localwar,
          isConditionOpen = PaGlobal_Menu_Remake._conditionGroup._isLocalwarOpen,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isLocalwarOpen and ToClient_IsGrowStepOpen(__eGrowStep_localWar),
          index = 39,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 401,
            y1 = 344,
            x2 = 456,
            y2 = 399
          }
        },
        [2] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_FREEFIGHT"),
          func = HandleEventLUp_MenuRemake_FreeFight,
          isConditionOpen = PaGlobal_Menu_Remake._conditionGroup._isFreeFight,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isFreeFight and ToClient_IsGrowStepOpen(__eGrowStep_freeFight),
          index = 40,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 230,
            y1 = 515,
            x2 = 285,
            y2 = 570
          }
        },
        [3] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_PERSONAL_BATTLE"),
          func = HandleEventLUp_MenuRemake_Personalbattle,
          isConditionOpen = PaGlobal_Menu_Remake._conditionGroup._isTeamDuelOpen,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isTeamDuelOpen and ToClient_IsGrowStepOpen(__eGrowStep_teamDuel),
          index = 41,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 287,
            y1 = 515,
            x2 = 342,
            y2 = 570
          }
        },
        [4] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_WAVE"),
          func = HandleEventLUp_MenuRemake_Wave,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isSavageOpen and ToClient_IsGrowStepOpen(__eGrowStep_savageDefence),
          index = 42,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 344,
            y1 = 344,
            x2 = 399,
            y2 = 399
          }
        },
        [5] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_COMPETITION"),
          func = HandleEventLUp_MenuRemake_Competitiongame,
          isConditionOpen = PaGlobal_Menu_Remake._conditionGroup._isContentsArsha,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isContentsArsha and ToClient_IsGrowStepOpen(__eGrowStep_arsha),
          index = 43,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 344,
            y1 = 230,
            x2 = 399,
            y2 = 285
          }
        },
        [6] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_SIEGE"),
          func = HandleEventLUp_MenuRemake_Siege,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isSiegeEnable and ToClient_IsGrowStepOpen(__eGrowStep_guildWarInfo),
          index = 44,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 116,
            y1 = 344,
            x2 = 171,
            y2 = 399
          }
        },
        [7] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_BLOODALTAR_TITLE"),
          func = HandleEventLUp_MenuRemake_InfinityDefence,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isInfinityDefence,
          index = 83,
          ddsUrl = "combine/icon/combine_title_icon_00.dds",
          ddsGrid = {
            x1 = 515,
            y1 = 572,
            x2 = 570,
            y2 = 627
          }
        }
      },
      ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
      ddsGrid = {
        x1 = 401,
        y1 = 344,
        x2 = 456,
        y2 = 399
      },
      isContentOpen = nil
    },
    [8] = {
      hotKey = CppEnums.VirtualKeyCode.KeyCode_F8,
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_CATEGORY_8"),
      subMenu = {
        [1] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_FINDNPC"),
          func = NpcNavi_ShowToggle,
          isContentOpen = true,
          index = 21,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 2,
            y1 = 401,
            x2 = 57,
            y2 = 456
          }
        },
        [2] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_MEMO"),
          func = function()
            PaGlobal_Memo:ListOpen()
          end,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isMemoOpen,
          index = 55,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 344,
            y1 = 401,
            x2 = 399,
            y2 = 456
          }
        },
        [3] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_PET"),
          func = FGlobal_PetListNew_Toggle,
          isConditionOpen = PaGlobal_Menu_Remake._conditionGroup._isPetOpen,
          isContentOpen = true,
          index = 10,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 116,
            y1 = 230,
            x2 = 171,
            y2 = 285
          }
        },
        [4] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_FAIRY"),
          func = HandleEventLUp_MenuRemake_Fairy,
          isConditionOpen = PaGlobal_Menu_Remake._conditionGroup._isFairyOpen,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isFairyOpen,
          index = 11,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 287,
            y1 = 344,
            x2 = 342,
            y2 = 399
          }
        },
        [5] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_MAID"),
          func = PaGlobalFunc_Menu_All_MaidList_Open,
          isConditionOpen = PaGlobal_Menu_Remake._conditionGroup._isMaidOpen,
          isContentOpen = _ContentsGroup_Maid,
          index = 17,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 59,
            y1 = 344,
            x2 = 114,
            y2 = 399
          }
        },
        [6] = {
          title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CAMP_TITLE"),
          func = HandleEventLUp_MenuRemake_Camp,
          isContentOpen = true,
          isConditionOpen = PaGlobal_Menu_Remake._conditionGroup._isCampOpen,
          index = 81,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 230,
            y1 = 344,
            x2 = 285,
            y2 = 399
          }
        }
      },
      ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
      ddsGrid = {
        x1 = 2,
        y1 = 401,
        x2 = 57,
        y2 = 456
      },
      isContentOpen = nil
    },
    [9] = {
      hotKey = CppEnums.VirtualKeyCode.KeyCode_F9,
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_CATEGORY_9"),
      subMenu = {
        [1] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_GUILD"),
          func = PaGlobalFunc_Menu_All_Guild_Open,
          isContentOpen = true,
          index = 51,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 2,
            y1 = 287,
            x2 = 57,
            y2 = 342
          }
        },
        [2] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_FRIEND"),
          func = function()
            GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_FriendList)
          end,
          isContentOpen = true,
          index = 52,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 287,
            y1 = 173,
            x2 = 342,
            y2 = 228
          }
        },
        [3] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_FIND_PARTY"),
          func = PaGlobalFunc_Menu_All_PartyList_Show,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._partyListOpen,
          index = 53,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 230,
            y1 = 116,
            x2 = 285,
            y2 = 171
          }
        },
        [4] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_SOCIAL_ACTION"),
          func = FGlobal_SocialAction_ShowToggle,
          isContentOpen = true,
          index = 13,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 458,
            y1 = 458,
            x2 = 513,
            y2 = 513
          }
        },
        [5] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_BEAUTY_ALBUM"),
          func = HandleEventLUp_MenuRemake_BeautyAlbum,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._webAlbumOpen and not PaGlobal_Menu_Remake._contentsGroup._isTestServer,
          index = 65,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 173,
            y1 = 457,
            x2 = 228,
            y2 = 512
          }
        },
        [6] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_CHATTING_FILTER"),
          func = FGlobal_ChattingFilterList_Open,
          isContentOpen = true,
          index = 54,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 458,
            y1 = 344,
            x2 = 513,
            y2 = 399
          }
        },
        [7] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_TWITCH"),
          func = function()
            PaGlobal_Twitch:ShowWindow()
          end,
          isContentOpen = not PaGlobal_Menu_Remake._contentsGroup._isTestServer,
          index = 56,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 116,
            y1 = 515,
            x2 = 171,
            y2 = 570
          }
        },
        [8] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_EXTRACTIONGAME"),
          func = PaGlobal_Steam_Redemption,
          isContentOpen = (isGameTypeEnglish() or isGameTypeSA() or isGameTypeTR() or isGameServiceTypeDev()) and not PaGlobal_Menu_Remake._contentsGroup._isTestServer,
          index = 32,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 572,
            y1 = 173,
            x2 = 627,
            y2 = 228
          }
        },
        [9] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_EXPIRIENCE_WIKI"),
          func = PaGlobal_ExpirienceWiki_Open,
          isContentOpen = _ContentsGroup_ExpirienceWiki,
          index = 77,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 458,
            y1 = 287,
            x2 = 513,
            y2 = 342
          }
        }
      },
      ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
      ddsGrid = {
        x1 = 287,
        y1 = 173,
        x2 = 342,
        y2 = 228
      },
      isContentOpen = nil
    },
    [10] = {
      hotKey = CppEnums.VirtualKeyCode.KeyCode_F10,
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_CATEGORY_10"),
      subMenu = {
        [1] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_OPTION"),
          func = showGameOption,
          isContentOpen = true,
          index = 57,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 59,
            y1 = 230,
            x2 = 114,
            y2 = 285
          }
        },
        [2] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_INTERFACE_EDIT"),
          func = FGlobal_UiSet_Open,
          isContentOpen = true,
          index = 59,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 515,
            y1 = 2,
            x2 = 570,
            y2 = 57
          }
        },
        [3] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_SHORTCUT"),
          func = FGlobal_ButtonShortcuts_Open,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isButtonShortCut,
          index = 60,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 287,
            y1 = 457,
            x2 = 342,
            y2 = 512
          }
        },
        [4] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_LANGUAGE"),
          func = FGlobal_GameOptionOpen,
          isContentOpen = isGameTypeEnglish() or isGameServiceTypeDev(),
          index = 61,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 572,
            y1 = 230,
            x2 = 627,
            y2 = 285
          }
        },
        [5] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_SAVE_SETTING"),
          func = PaGlobal_Panel_SaveSetting_Show,
          isContentOpen = not PaGlobal_Menu_Remake._contentsGroup._isTestServer,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 401,
            y1 = 401,
            x2 = 456,
            y2 = 456
          },
          index = 62
        },
        [6] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_GAMEEND"),
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          func = GameExitShowToggle,
          isContentOpen = nil,
          ddsGrid = {
            x1 = 2,
            y1 = 116,
            x2 = 57,
            y2 = 171
          },
          index = 74
        },
        [7] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_CHANGESERVER"),
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          func = FGlobal_ChannelSelect_Show,
          isContentOpen = nil,
          ddsGrid = {
            x1 = 287,
            y1 = 230,
            x2 = 342,
            y2 = 285
          },
          index = 75
        }
      },
      ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
      ddsGrid = {
        x1 = 59,
        y1 = 230,
        x2 = 114,
        y2 = 285
      },
      isContentOpen = nil
    },
    [11] = {
      hotKey = CppEnums.VirtualKeyCode.KeyCode_F11,
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_CATEGORY_11"),
      subMenu = {
        [1] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_NOTICE"),
          func = HandleEventLUp_MenuRemake_Notice,
          isContentOpen = isGameTypeEnglish() and not PaGlobal_Menu_Remake._contentsGroup._isTestServer,
          index = 68,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 457,
            y1 = 116,
            x2 = 512,
            y2 = 171
          }
        },
        [2] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_UPDATE"),
          func = HandleEventLUp_MenuRemake_Update,
          isContentOpen = (isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeTR() or isGameTypeID() or isGameTypeTH() or isGameServiceTypeDev()) and not PaGlobal_Menu_Remake._contentsGroup._isTestServer,
          index = 69,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 59,
            y1 = 287,
            x2 = 114,
            y2 = 342
          }
        },
        [3] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_EVENT"),
          func = HandleEventLUp_MenuRemake_Event,
          isContentOpen = not PaGlobal_Menu_Remake._contentsGroup._isTestServer,
          index = 70,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 173,
            y1 = 401,
            x2 = 228,
            y2 = 456
          }
        },
        [4] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_KNOWN_ISSUE"),
          func = HandleEventLUp_MenuRemake_KnownIssue,
          isContentOpen = (isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeTH() or isGameTypeID()) and not PaGlobal_Menu_Remake._contentsGroup._isTestServer,
          index = 71,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 515,
            y1 = 344,
            x2 = 570,
            y2 = 399
          }
        },
        [5] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_BLACKDESERT_LAB"),
          func = HandleEventLUp_MenuRemake_BlackDesertLab,
          isContentOpen = PaGlobal_Menu_Remake._contentsGroup._isBlackDesertLab,
          index = 72,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 59,
            y1 = 457,
            x2 = 114,
            y2 = 512
          }
        },
        [6] = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_REMAKE_MENU_MAIL"),
          func = HandleEventUp_MenuRemake_Mail,
          isContentOpen = true,
          index = 73,
          ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
          ddsGrid = {
            x1 = 2,
            y1 = 173,
            x2 = 57,
            y2 = 228
          }
        }
      },
      ddsUrl = "Combine/Icon/Combine_Title_Icon_00.dds",
      ddsGrid = {
        x1 = 457,
        y1 = 116,
        x2 = 512,
        y2 = 171
      },
      isContentOpen = nil
    }
  }
end
function PaGlobal_Menu_Remake:setMenuGrid(isMode)
  if true == isMode then
    PaGlobal_Menu_Remake._headerGrid = {
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
    }
    PaGlobal_Menu_Remake._menuGrid = {
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
    }
    PaGlobal_Menu_Remake._subMenuGrid = {
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
    }
  else
    PaGlobal_Menu_Remake._headerGrid = {
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
    }
    PaGlobal_Menu_Remake._menuGrid = {
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
    }
    PaGlobal_Menu_Remake._subMenuGrid = {
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
    }
  end
end
function PaGlobal_Menu_Remake:setMenuOpenWayBtn()
  if 0 == ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eMenuOpenWay) then
    local textureDDS = PaGlobal_Menu_Remake.DEFAULT_MENU_DDS
    PaGlobal_Menu_Remake._ui.btn_openway:ChangeTextureInfoName(textureDDS)
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._ui.btn_openway, 23, 57, 43, 78)
    PaGlobal_Menu_Remake._ui.btn_openway:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGlobal_Menu_Remake._ui.btn_openway:setRenderTexture(PaGlobal_Menu_Remake._ui.btn_openway:getBaseTexture())
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._ui.btn_openway, 23, 79, 43, 100)
    PaGlobal_Menu_Remake._ui.btn_openway:getOnTexture():setUV(x1, y1, x2, y2)
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._ui.btn_openway, 23, 101, 43, 122)
    PaGlobal_Menu_Remake._ui.btn_openway:getClickTexture():setUV(x1, y1, x2, y2)
  else
    local textureDDS = PaGlobal_Menu_Remake.DEFAULT_MENU_DDS
    PaGlobal_Menu_Remake._ui.btn_openway:ChangeTextureInfoName(textureDDS)
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._ui.btn_openway, 44, 57, 64, 78)
    PaGlobal_Menu_Remake._ui.btn_openway:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGlobal_Menu_Remake._ui.btn_openway:setRenderTexture(PaGlobal_Menu_Remake._ui.btn_openway:getBaseTexture())
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._ui.btn_openway, 44, 79, 64, 100)
    PaGlobal_Menu_Remake._ui.btn_openway:getOnTexture():setUV(x1, y1, x2, y2)
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_Menu_Remake._ui.btn_openway, 44, 101, 64, 122)
    PaGlobal_Menu_Remake._ui.btn_openway:getClickTexture():setUV(x1, y1, x2, y2)
  end
  PaGlobal_Menu_Remake:hideTooltip()
end
function PaGlobalFunc_Menu_All_PartyList_Show()
  if true == _ContentsGroup_NewUI_PartyFind_All then
    PaGlobalFunc_PartyList_All_Open()
  else
    FGlobal_PartyList_ShowToggle()
  end
end
function PaGlobalFunc_Menu_All_MaidList_Open()
  if true == _ContentsGroup_NewUI_Maid_All then
    PaGlobalFunc_MaidList_All_Open()
  else
    MaidList_Open()
  end
end
function PaGlobalFunc_Menu_All_DailyStamp_Open()
  if true == _ContentsGroup_NewUI_DailyStamp_All then
    PaGlobalFunc_DailyStamp_All_Open()
  else
    DailyStamp_ShowToggle()
  end
end
function PaGlobalFunc_Menu_All_WorkerManager_Open()
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    PaGlobalFunc_WorkerManager_All_ShowToggle()
  else
    FGlobal_WorkerManger_ShowToggle()
  end
end
function PaGlobalFunc_Menu_All_Guild_Open()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_Guild)
end
function PaGlobalFunc_Menu_All_LifeRanker_Open()
  if false == _ContentsGroup_NewUI_LifeRanking_All then
    FGlobal_LifeRanking_Open()
  else
    PaGlobal_LifeRanking_Open_All()
  end
end

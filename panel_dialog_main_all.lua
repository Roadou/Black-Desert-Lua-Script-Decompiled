PaGlobal_DialogMain_All = {
  _ui = {
    radio_func = nil,
    radio_back = nil,
    radio_exit = nil,
    stc_selectBar = nil,
    stc_tutorialArrow = nil
  },
  _ui_pc = {stc_spaceBar = nil, btn_blackSpiritSkillSelect = nil},
  _ui_console = {
    stc_iconLB = nil,
    stc_iconRB = nil,
    stc_iconA = nil
  },
  _blackSpiritButtonPos = {
    eBlackSpiritButtonType_Quest = 0,
    eBlackSpiritButtonType_Enchant = 1,
    eBlackSpiritButtonType_Socket = 2,
    eBlackSpiritButtonType_Improve = 3,
    eBlackSpiritButtonType_Count = 4
  },
  _filterRadioButton = {
    [0] = nil,
    [1] = nil,
    [2] = nil,
    [3] = nil
  },
  _filterRadioButtonString = {
    [1] = nil,
    [2] = nil,
    [3] = nil
  },
  _iconUpdateType = {
    CppEnums.ContentsType.Contents_IntimacyGame,
    CppEnums.ContentsType.Contents_Quest,
    CppEnums.ContentsType.Contents_NewQuest,
    CppEnums.ContentsType.Contents_Shop,
    CppEnums.ContentsType.Contents_Repair,
    CppEnums.ContentsType.Contents_Stable,
    CppEnums.ContentsType.Contents_Auction,
    CppEnums.ContentsType.Contents_Guild,
    CppEnums.ContentsType.Contents_NpcGift,
    CppEnums.ContentsType.Contents_Warehouse,
    CppEnums.ContentsType.Contents_TerritorySupply,
    CppEnums.ContentsType.Contents_SupplyShop,
    CppEnums.ContentsType.Contents_Extract,
    CppEnums.ContentsType.Contents_NewItemMarket,
    CppEnums.ContentsType.Contents_GuildShop,
    CppEnums.ContentsType.Contents_Transfer,
    CppEnums.ContentsType.Contents_WeakenEnchant,
    CppEnums.ContentsType.Contents_LordMenu,
    CppEnums.ContentsType.Contents_Skill,
    CppEnums.ContentsType.Contents_Enchant,
    CppEnums.ContentsType.Contents_Socket,
    CppEnums.ContentsType.Contents_HelpDesk,
    CppEnums.ContentsType.Contents_Improve,
    CppEnums.ContentsType.Contents_Awaken,
    CppEnums.ContentsType.Contents_Explore,
    CppEnums.ContentsType.Contents_MinorLordMenu
  },
  _funcBtnTexturePath = "Combine/Icon/Combine_Dialogue_Icon_00.dds",
  _funcBtnTextureUV = {
    [CppEnums.ContentsType.Contents_IntimacyGame] = {
      base = {
        x1 = 124,
        y1 = 1,
        x2 = 164,
        y2 = 41
      },
      on = {
        x1 = 124,
        y1 = 83,
        x2 = 164,
        y2 = 123
      },
      click = {
        x1 = 124,
        y1 = 83,
        x2 = 164,
        y2 = 123
      }
    },
    [CppEnums.ContentsType.Contents_Quest] = {
      base = {
        x1 = 1,
        y1 = 1,
        x2 = 41,
        y2 = 41
      },
      on = {
        x1 = 1,
        y1 = 83,
        x2 = 41,
        y2 = 123
      },
      click = {
        x1 = 1,
        y1 = 83,
        x2 = 41,
        y2 = 123
      }
    },
    [CppEnums.ContentsType.Contents_NewQuest] = {
      base = {
        x1 = 1,
        y1 = 1,
        x2 = 41,
        y2 = 41
      },
      on = {
        x1 = 1,
        y1 = 83,
        x2 = 41,
        y2 = 123
      },
      click = {
        x1 = 1,
        y1 = 83,
        x2 = 41,
        y2 = 123
      }
    },
    [CppEnums.ContentsType.Contents_Shop] = {
      base = {
        x1 = 42,
        y1 = 1,
        x2 = 82,
        y2 = 41
      },
      on = {
        x1 = 42,
        y1 = 83,
        x2 = 82,
        y2 = 123
      },
      click = {
        x1 = 42,
        y1 = 83,
        x2 = 82,
        y2 = 123
      }
    },
    [CppEnums.ContentsType.Contents_Repair] = {
      base = {
        x1 = 247,
        y1 = 124,
        x2 = 287,
        y2 = 164
      },
      on = {
        x1 = 247,
        y1 = 206,
        x2 = 287,
        y2 = 246
      },
      click = {
        x1 = 247,
        y1 = 206,
        x2 = 287,
        y2 = 246
      }
    },
    [CppEnums.ContentsType.Contents_Stable] = {
      base = {
        x1 = 83,
        y1 = 247,
        x2 = 123,
        y2 = 287
      },
      on = {
        x1 = 83,
        y1 = 329,
        x2 = 123,
        y2 = 369
      },
      click = {
        x1 = 83,
        y1 = 329,
        x2 = 123,
        y2 = 369
      }
    },
    [9.1] = {
      base = {
        x1 = 1,
        y1 = 247,
        x2 = 41,
        y2 = 287
      },
      on = {
        x1 = 1,
        y1 = 329,
        x2 = 41,
        y2 = 369
      },
      click = {
        x1 = 1,
        y1 = 329,
        x2 = 41,
        y2 = 369
      }
    },
    [CppEnums.ContentsType.Contents_Auction] = {
      base = {
        x1 = 206,
        y1 = 247,
        x2 = 246,
        y2 = 287
      },
      on = {
        x1 = 206,
        y1 = 329,
        x2 = 246,
        y2 = 369
      },
      click = {
        x1 = 206,
        y1 = 329,
        x2 = 246,
        y2 = 369
      }
    },
    [CppEnums.ContentsType.Contents_Guild] = {
      base = {
        x1 = 411,
        y1 = 1,
        x2 = 451,
        y2 = 41
      },
      on = {
        x1 = 411,
        y1 = 83,
        x2 = 451,
        y2 = 123
      },
      click = {
        x1 = 411,
        y1 = 83,
        x2 = 451,
        y2 = 123
      }
    },
    [CppEnums.ContentsType.Contents_NpcGift] = {
      base = {
        x1 = 83,
        y1 = 124,
        x2 = 123,
        y2 = 164
      },
      on = {
        x1 = 83,
        y1 = 206,
        x2 = 123,
        y2 = 246
      },
      click = {
        x1 = 83,
        y1 = 206,
        x2 = 123,
        y2 = 246
      }
    },
    [CppEnums.ContentsType.Contents_Warehouse] = {
      base = {
        x1 = 288,
        y1 = 124,
        x2 = 328,
        y2 = 164
      },
      on = {
        x1 = 288,
        y1 = 206,
        x2 = 328,
        y2 = 246
      },
      click = {
        x1 = 288,
        y1 = 206,
        x2 = 328,
        y2 = 246
      }
    },
    [CppEnums.ContentsType.Contents_TerritorySupply] = {
      base = {
        x1 = 370,
        y1 = 124,
        x2 = 410,
        y2 = 164
      },
      on = {
        x1 = 370,
        y1 = 206,
        x2 = 410,
        y2 = 246
      },
      click = {
        x1 = 370,
        y1 = 206,
        x2 = 410,
        y2 = 246
      }
    },
    [CppEnums.ContentsType.Contents_SupplyShop] = {
      base = {
        x1 = 370,
        y1 = 124,
        x2 = 410,
        y2 = 164
      },
      on = {
        x1 = 370,
        y1 = 206,
        x2 = 410,
        y2 = 246
      },
      click = {
        x1 = 370,
        y1 = 206,
        x2 = 410,
        y2 = 246
      }
    },
    [CppEnums.ContentsType.Contents_Extract] = {
      base = {
        x1 = 493,
        y1 = 1,
        x2 = 533,
        y2 = 41
      },
      on = {
        x1 = 493,
        y1 = 83,
        x2 = 533,
        y2 = 123
      },
      click = {
        x1 = 493,
        y1 = 83,
        x2 = 533,
        y2 = 123
      }
    },
    [CppEnums.ContentsType.Contents_NewItemMarket] = {
      base = {
        x1 = 165,
        y1 = 1,
        x2 = 205,
        y2 = 41
      },
      on = {
        x1 = 165,
        y1 = 83,
        x2 = 205,
        y2 = 123
      },
      click = {
        x1 = 165,
        y1 = 83,
        x2 = 205,
        y2 = 123
      }
    },
    [CppEnums.ContentsType.Contents_GuildShop] = {
      base = {
        x1 = 329,
        y1 = 1,
        x2 = 369,
        y2 = 41
      },
      on = {
        x1 = 329,
        y1 = 83,
        x2 = 369,
        y2 = 123
      },
      click = {
        x1 = 329,
        y1 = 83,
        x2 = 369,
        y2 = 123
      }
    },
    [CppEnums.ContentsType.Contents_Transfer] = {
      base = {
        x1 = 329,
        y1 = 124,
        x2 = 369,
        y2 = 164
      },
      on = {
        x1 = 329,
        y1 = 206,
        x2 = 369,
        y2 = 246
      },
      click = {
        x1 = 329,
        y1 = 206,
        x2 = 369,
        y2 = 246
      }
    },
    [CppEnums.ContentsType.Contents_WeakenEnchant] = {
      base = {
        x1 = 452,
        y1 = 124,
        x2 = 492,
        y2 = 164
      },
      on = {
        x1 = 452,
        y1 = 206,
        x2 = 492,
        y2 = 246
      },
      click = {
        x1 = 452,
        y1 = 206,
        x2 = 492,
        y2 = 246
      }
    },
    [CppEnums.ContentsType.Contents_LordMenu] = {
      base = {
        x1 = 493,
        y1 = 124,
        x2 = 533,
        y2 = 164
      },
      on = {
        x1 = 493,
        y1 = 206,
        x2 = 533,
        y2 = 246
      },
      click = {
        x1 = 493,
        y1 = 206,
        x2 = 533,
        y2 = 246
      }
    },
    [CppEnums.ContentsType.Contents_Skill] = {
      base = {
        x1 = 42,
        y1 = 247,
        x2 = 82,
        y2 = 287
      },
      on = {
        x1 = 42,
        y1 = 329,
        x2 = 82,
        y2 = 369
      },
      click = {
        x1 = 42,
        y1 = 329,
        x2 = 82,
        y2 = 369
      }
    },
    [CppEnums.ContentsType.Contents_Enchant] = {
      base = {
        x1 = 1,
        y1 = 124,
        x2 = 41,
        y2 = 164
      },
      on = {
        x1 = 1,
        y1 = 206,
        x2 = 41,
        y2 = 246
      },
      click = {
        x1 = 1,
        y1 = 206,
        x2 = 41,
        y2 = 246
      }
    },
    [CppEnums.ContentsType.Contents_Socket] = {
      base = {
        x1 = 124,
        y1 = 124,
        x2 = 164,
        y2 = 164
      },
      on = {
        x1 = 124,
        y1 = 206,
        x2 = 164,
        y2 = 246
      },
      click = {
        x1 = 124,
        y1 = 206,
        x2 = 164,
        y2 = 246
      }
    },
    [CppEnums.ContentsType.Contents_HelpDesk] = {
      base = {
        x1 = 206,
        y1 = 1,
        x2 = 246,
        y2 = 41
      },
      on = {
        x1 = 206,
        y1 = 83,
        x2 = 246,
        y2 = 123
      },
      click = {
        x1 = 206,
        y1 = 83,
        x2 = 246,
        y2 = 123
      }
    },
    [CppEnums.ContentsType.Contents_Improve] = {
      base = {
        x1 = 247,
        y1 = 124,
        x2 = 287,
        y2 = 164
      },
      on = {
        x1 = 247,
        y1 = 206,
        x2 = 287,
        y2 = 246
      },
      click = {
        x1 = 247,
        y1 = 206,
        x2 = 287,
        y2 = 246
      }
    },
    [CppEnums.ContentsType.Contents_Awaken] = {
      base = {
        x1 = 42,
        y1 = 247,
        x2 = 82,
        y2 = 287
      },
      on = {
        x1 = 42,
        y1 = 329,
        x2 = 82,
        y2 = 369
      },
      click = {
        x1 = 42,
        y1 = 329,
        x2 = 82,
        y2 = 369
      }
    },
    [CppEnums.ContentsType.Contents_Explore] = {
      base = {
        x1 = 206,
        y1 = 1,
        x2 = 246,
        y2 = 41
      },
      on = {
        x1 = 206,
        y1 = 83,
        x2 = 246,
        y2 = 123
      },
      click = {
        x1 = 206,
        y1 = 83,
        x2 = 246,
        y2 = 123
      }
    },
    [CppEnums.ContentsType.Contents_MinorLordMenu] = {
      base = {
        x1 = 370,
        y1 = 1,
        x2 = 410,
        y2 = 41
      },
      on = {
        x1 = 370,
        y1 = 83,
        x2 = 410,
        y2 = 123
      },
      click = {
        x1 = 370,
        y1 = 83,
        x2 = 410,
        y2 = 123
      }
    }
  },
  _shopType = {
    eShopType_None = 0,
    eShopType_Potion = 1,
    eShopType_Weapon = 2,
    eShopType_Jewel = 3,
    eShopType_Furniture = 4,
    eShopType_Collect = 5,
    eShopType_Fish = 6,
    eShopType_Worker = 7,
    eShopType_Alchemy = 8,
    eShopType_Cook = 9,
    eShopType_PC = 10,
    eShopType_Grocery = 11,
    eShopType_RandomShop = 12,
    eShopType_DayRandomShop = 13,
    eShopType_Count = 14
  },
  _mainDialog = {},
  _funcBtnList = {},
  _tradeIndex = -1,
  _maxFuncBtnIndex = 10,
  _selectDialogFuncIndex = nil,
  _indexWorkerShopClicked = nil,
  _ignoreShowDialog = false,
  _showCheck_Once = false,
  _isFirstShowTooltip = true,
  _handleClickedQuestComplete = false,
  _isAuctionDialog = false,
  _isDialogNewQuest = false,
  _isSkillTutorial = false,
  _isAllowTutorialPanelShow = false,
  _renderMode = RenderModeWrapper.new(100, {
    Defines.RenderMode.eRenderMode_Dialog
  }, false),
  _initialize = false
}
runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_Main_All_1.lua")
runLua("UI_Data/Script/Widget/Dialogue/Panel_Dialog_Main_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_PaGlobal_DialogMain_All_Init")
function FromClient_PaGlobal_DialogMain_All_Init()
  PaGlobal_DialogMain_All:initialize()
end

local UI_TM = CppEnums.TextMode
local UI_classType = CppEnums.ClassType
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
local UIMode = Defines.UIMode
Panel_SkillCommand:setMaskingChild(true)
Panel_SkillCommand:ActiveMouseEventEffect(true)
Panel_SkillCommand:setGlassBackground(true)
Panel_SkillCommand:RegisterShowEventFunc(true, "Panel_SkkillCommand_ShowAni()")
Panel_SkillCommand:RegisterShowEventFunc(false, "Panel_SkkillCommand_HideAni()")
local skillCommand = {
  _config = {
    pos = {
      gapY = 35,
      startX = 0,
      startY = 0
    }
  },
  _copyCommand = {},
  _slots = Array.new(),
  skilldatatable = {},
  skillCount = 0,
  lvupSkillCount = 0,
  recommandSkillCount = 0,
  skillCommand = {},
  skillCommandControl = {},
  skillCommandCount = 0,
  elapsedTime = 0,
  skillCommandIndex = {},
  skillCommandShowkeep = {},
  color = Defines.Color.C_FF444444,
  viewableMaxSkillCount = 11,
  skillNameSizeX = 0,
  isLevelUp = false,
  sizeUpCount = 0,
  cooltimeSkill = {},
  _weaponType = 0,
  _isServantRide = false,
  _actorKeyRaw = nil
}
local servantSkillList = {
  _commonList = {
    44,
    46,
    47,
    48,
    4,
    3,
    8,
    9,
    10,
    20,
    21,
    22,
    23,
    24,
    28,
    32,
    33,
    34,
    35,
    25,
    31,
    55
  },
  _forShaiList = {
    64,
    62,
    63,
    61
  }
}
local classSkillList = {
  [CppEnums.ClassType.ClassType_Warrior] = {
    normal = {
      [1022] = {
        1022,
        1130,
        1131,
        1132,
        2835
      },
      [305] = {
        305,
        306,
        2844
      },
      [1028] = {
        1028,
        1080,
        1081,
        1082,
        2852
      },
      [1021] = {
        1021,
        1127,
        1128,
        1129,
        2834
      },
      [1440] = {
        1440,
        1441,
        1442,
        2849
      }
    },
    awaken = {
      [1733] = {
        1733,
        1734,
        1735,
        1736
      },
      [1759] = {
        1759,
        1760,
        1761,
        1762
      },
      [1765] = {
        1765,
        1766,
        1767,
        1768
      },
      [1751] = {
        1751,
        1752,
        1753
      },
      [1748] = {1748}
    }
  },
  [CppEnums.ClassType.ClassType_SnowBucks] = {},
  [CppEnums.ClassType.ClassType_Ranger] = {
    normal = {
      [1016] = {
        1016,
        1116,
        1257,
        2863
      },
      [1015] = {
        1015,
        1113,
        1114,
        1115,
        318,
        1112,
        2862
      },
      [1008] = {
        1008,
        1099,
        1100,
        1101,
        2858
      },
      [1013] = {
        1013,
        1110,
        1254,
        1255,
        2861
      },
      [1007] = {
        1007,
        1095,
        1096,
        1097,
        1098,
        2857
      }
    },
    awaken = {
      [1857] = {
        1857,
        1858,
        1859,
        1860
      },
      [1879] = {
        1879,
        1880,
        1881,
        1882
      },
      [1875] = {
        1875,
        1876,
        1877,
        1878
      },
      [1886] = {
        1886,
        1887,
        1888
      },
      [1890] = {
        1890,
        1891,
        1892
      }
    }
  },
  [CppEnums.ClassType.ClassType_Sorcerer] = {
    normal = {
      [1049] = {
        1049,
        1185,
        1186,
        1187,
        2870
      },
      [380] = {
        380,
        171,
        2885
      },
      [1417] = {
        1417,
        1418,
        2887
      },
      [1056] = {
        1056,
        1202,
        1203,
        583,
        2876
      },
      [1052] = {
        1052,
        1195,
        93,
        2873
      }
    },
    awaken = {
      [1780] = {
        1780,
        1781,
        1782
      },
      [1785] = {
        1785,
        1786,
        1787,
        1788
      },
      [1802] = {
        1802,
        1803,
        1804
      },
      [1793] = {
        1793,
        1794,
        1795,
        1796
      },
      [1798] = {
        1798,
        1799,
        1800
      }
    }
  },
  [CppEnums.ClassType.ClassType_Lahn] = {
    normal = {
      [2950] = {
        2950,
        2978,
        2979,
        2980,
        2981,
        3303
      },
      [2972] = {
        2972,
        3020,
        3021,
        3318
      },
      [2954] = {
        2954,
        2990,
        2991,
        3307
      },
      [2960] = {
        2960,
        2998,
        2999
      },
      [2952] = {
        2952,
        2982,
        2983,
        2984,
        2985,
        2986,
        3305
      }
    },
    awaken = {
      [3267] = {
        3267,
        3268,
        3269,
        3270
      },
      [3276] = {
        3276,
        3277,
        3278,
        3279
      },
      [3284] = {
        3284,
        3285,
        3286
      },
      [3287] = {
        3287,
        3288,
        3289
      },
      [3296] = {3296}
    }
  },
  [CppEnums.ClassType.ClassType_Giant] = {
    normal = {
      [1038] = {
        1038,
        1159,
        1291,
        1292,
        2893
      },
      [1033] = {
        1033,
        1151,
        1152,
        2890
      },
      [1034] = {
        1034,
        1153,
        1154,
        1155,
        2891
      },
      [314] = {
        314,
        315,
        316,
        317,
        295,
        2904
      },
      [1044] = {
        1044,
        1175,
        1176,
        1177,
        1178,
        1179,
        2898
      }
    },
    awaken = {
      [1823] = {
        1823,
        1824,
        1825,
        1826
      },
      [1830] = {
        1830,
        1831,
        1832,
        1833
      },
      [1834] = {
        1834,
        1835,
        1836
      },
      [1837] = {
        1837,
        1838,
        1839,
        1840
      },
      [1846] = {1846}
    }
  },
  [CppEnums.ClassType.ClassType_Tamer] = {
    normal = {
      [1941] = {1941},
      [1069] = {
        1069,
        1230,
        1231,
        2925
      },
      [129] = {
        129,
        130,
        131,
        132,
        205,
        2930
      },
      [133] = {
        133,
        134,
        135,
        2920
      },
      [1074] = {
        1074,
        1246,
        1247,
        1248,
        1249,
        1295,
        2929
      }
    },
    awaken = {
      [1910] = {
        1910,
        1911,
        1912
      },
      [1918] = {
        1918,
        1919,
        1920,
        1921
      },
      [1913] = {
        1913,
        1914,
        1915,
        1916
      },
      [1922] = {
        1922,
        1928,
        1929
      },
      [1930] = {
        1930,
        1931,
        1932
      }
    }
  },
  [CppEnums.ClassType.ClassType_ShyWomen] = {
    normal = {
      [3851] = {
        3851,
        3852,
        3853,
        3854
      },
      [3891] = {
        3891,
        3892,
        3893
      },
      [3862] = {
        3862,
        3863,
        3864,
        3865,
        3866
      },
      [3885] = {3885},
      [3875] = {
        3875,
        3876,
        3877,
        3878
      }
    }
  },
  [CppEnums.ClassType.ClassType_Shy] = {},
  [CppEnums.ClassType.ClassType_Combattant] = {
    normal = {
      [2449] = {
        2449,
        2450,
        2451,
        3033
      },
      [2528] = {
        2528,
        2529,
        2530,
        2531,
        3047
      },
      [2491] = {
        2491,
        2492,
        2493,
        2494,
        2495,
        3039
      },
      [2496] = {
        2496,
        2497,
        2498,
        2499,
        2500,
        3040
      },
      [2443] = {
        2443,
        2444,
        2445
      }
    },
    awaken = {
      [2562] = {
        2562,
        2563,
        2564,
        2565
      },
      [2566] = {
        2566,
        2567,
        2568,
        2569
      },
      [2570] = {
        2570,
        2571,
        2572,
        2573
      },
      [2574] = {
        2574,
        2575,
        2576
      },
      [2577] = {
        2577,
        2578,
        2579
      }
    }
  },
  [CppEnums.ClassType.ClassType_BladeMaster] = {
    normal = {
      [1296] = {
        1296,
        1297,
        1298,
        3163
      },
      [1275] = {
        1275,
        1276,
        1277,
        3160
      },
      [1445] = {
        1445,
        1446,
        1447,
        3169
      },
      [401] = {
        401,
        402,
        403,
        415,
        416,
        3172
      },
      [1455] = {1455, 1456}
    },
    awaken = {
      [2004] = {
        2004,
        2005,
        2006,
        2007
      },
      [2008] = {
        2008,
        2009,
        2010,
        2011
      },
      [2015] = {
        2015,
        2016,
        2017
      },
      [2018] = {
        2018,
        2019,
        2020
      },
      [2000] = {
        2000,
        2001,
        2002,
        2003
      }
    }
  },
  [CppEnums.ClassType.ClassType_BladeMasterWomen] = {
    normal = {
      [1555] = {
        1555,
        1556,
        1557,
        3185
      },
      [1535] = {
        1535,
        1536,
        1537,
        3182
      },
      [1572] = {
        1572,
        1573,
        1574,
        3191
      },
      [1582] = {
        1582,
        1583,
        1584,
        1585,
        1586,
        3194
      },
      [1591] = {1591, 1592}
    },
    awaken = {
      [2040] = {
        2040,
        2041,
        2042,
        2043
      },
      [2044] = {
        2044,
        2045,
        2046,
        2047
      },
      [2050] = {
        2050,
        2051,
        2052,
        2053
      },
      [2058] = {
        2058,
        2059,
        2060
      },
      [2061] = {
        2061,
        2062,
        2063
      }
    }
  },
  [CppEnums.ClassType.ClassType_CombattantWomen] = {
    normal = {
      [2674] = {
        2674,
        2675,
        2676,
        2677,
        3062
      },
      [2706] = {
        2706,
        2707,
        2708,
        2709,
        3068
      },
      [2652] = {
        2652,
        2653,
        2654,
        2655,
        3057
      },
      [2761] = {2761},
      [2723] = {
        2723,
        2724,
        2725,
        2726,
        2727,
        3070
      }
    },
    awaken = {
      [2799] = {
        2799,
        2800,
        2801,
        2802
      },
      [2781] = {
        2781,
        2782,
        2783,
        2791
      },
      [2784] = {
        2784,
        2785,
        2786
      },
      [2788] = {
        2788,
        2789,
        2790
      },
      [2793] = {
        2793,
        2794,
        2795
      }
    }
  },
  [CppEnums.ClassType.ClassType_Valkyrie] = {
    normal = {
      [1490] = {
        1490,
        1491,
        1492,
        1493,
        3209
      },
      [750] = {
        750,
        751,
        752,
        753,
        3220
      },
      [1485] = {
        1485,
        1486,
        3204
      },
      [776] = {
        776,
        777,
        778,
        779,
        3213
      },
      [732] = {
        732,
        733,
        734,
        735,
        3202
      }
    },
    awaken = {
      [1955] = {
        1955,
        1956,
        1957
      },
      [1958] = {
        1958,
        1959,
        1960,
        1961
      },
      [1963] = {
        1963,
        1964,
        1965,
        1966
      },
      [1972] = {
        1972,
        1973,
        1974
      },
      [1975] = {
        1975,
        1976,
        1977
      }
    }
  },
  [CppEnums.ClassType.ClassType_NinjaWomen] = {
    normal = {
      [966] = {
        966,
        967,
        968,
        969,
        970,
        3112
      },
      [958] = {
        958,
        959,
        960,
        961,
        3110
      },
      [962] = {
        962,
        963,
        964,
        965,
        3111
      },
      [949] = {
        949,
        950,
        951,
        1624,
        1625,
        3108
      },
      [985] = {
        985,
        986,
        987,
        3115
      }
    },
    awaken = {
      [2125] = {
        2125,
        2126,
        2127
      },
      [2140] = {
        2140,
        2141,
        2142
      },
      [2144] = {2144},
      [2145] = {
        2145,
        2146,
        2147,
        2148
      },
      [2154] = {
        2154,
        2155,
        2156,
        2157
      }
    }
  },
  [CppEnums.ClassType.ClassType_NinjaMan] = {
    normal = {
      [958] = {
        958,
        959,
        960,
        961,
        3110
      },
      [949] = {
        949,
        950,
        951,
        1624,
        1625,
        3108
      },
      [1685] = {
        1685,
        1686,
        1687,
        3129
      },
      [1678] = {
        1678,
        1679,
        1680,
        3125
      },
      [1698] = {
        1698,
        1699,
        1700,
        3126
      }
    },
    awaken = {
      [2088] = {
        2088,
        2089,
        2090,
        2091
      },
      [2092] = {
        2092,
        2093,
        2094
      },
      [2097] = {
        2097,
        2098,
        2099
      },
      [2101] = {2101},
      [2117] = {
        2117,
        2118,
        2119
      }
    }
  },
  [CppEnums.ClassType.ClassType_DarkElf] = {
    normal = {
      [2254] = {
        2254,
        2255,
        2256,
        3079
      },
      [2262] = {
        2262,
        2294,
        2295,
        3081
      },
      [2268] = {
        2268,
        2340,
        2363,
        3075
      },
      [2257] = {
        2257,
        2333,
        2334,
        2335,
        3088
      },
      [2269] = {
        2269,
        2270,
        2271,
        2272,
        2273,
        3089
      }
    },
    awaken = {
      [2417] = {2417},
      [2399] = {
        2399,
        2400,
        2401
      },
      [2403] = {
        2403,
        2404,
        2405
      },
      [2406] = {
        2406,
        2407,
        2408
      },
      [2409] = {
        2409,
        2410,
        2411,
        2402
      }
    }
  },
  [CppEnums.ClassType.ClassType_Wizard] = {
    normal = {
      [818] = {
        818,
        819,
        820,
        821,
        3132
      },
      [822] = {
        822,
        823,
        824,
        825,
        826,
        3133
      },
      [790] = {
        790,
        791,
        792,
        3131
      },
      [827] = {
        827,
        828,
        829,
        830,
        3135
      },
      [865] = {
        865,
        866,
        867
      }
    },
    awaken = {
      [2212] = {2212},
      [2225] = {
        2225,
        2226,
        2227,
        2228
      },
      [2229] = {
        2229,
        2230,
        2231
      },
      [2236] = {
        2236,
        2237,
        2238
      },
      [2232] = {
        2232,
        2233,
        2234,
        2235
      }
    }
  },
  [CppEnums.ClassType.ClassType_Kunoichi] = {
    normal = {
      [966] = {
        966,
        967,
        968,
        969,
        970,
        3112
      },
      [958] = {
        958,
        959,
        960,
        961,
        3110
      },
      [962] = {
        962,
        963,
        964,
        965,
        3111
      },
      [949] = {
        949,
        950,
        951,
        1624,
        1625,
        3108
      },
      [985] = {
        985,
        986,
        987,
        3115
      }
    },
    awaken = {
      [2125] = {
        2125,
        2126,
        2127
      },
      [2140] = {
        2140,
        2141,
        2142
      },
      [2144] = {2144},
      [2145] = {
        2145,
        2146,
        2147,
        2148
      },
      [2154] = {
        2154,
        2155,
        2156,
        2157
      }
    }
  },
  [CppEnums.ClassType.ClassType_WizardWomen] = {
    normal = {
      [818] = {
        818,
        819,
        820,
        821,
        3132
      },
      [822] = {
        822,
        823,
        824,
        825,
        826,
        3133
      },
      [790] = {
        790,
        791,
        792,
        3131
      },
      [827] = {
        827,
        828,
        829,
        830,
        3135
      },
      [865] = {
        865,
        866,
        867
      }
    },
    awaken = {
      [2166] = {2166},
      [2183] = {
        2183,
        2184,
        2185
      },
      [2197] = {
        2197,
        2198,
        2199
      },
      [2190] = {
        2190,
        2191,
        2192
      },
      [2193] = {
        2193,
        2194,
        2195,
        2196
      }
    }
  },
  [CppEnums.ClassType.ClassType_Orange] = {
    normal = {
      [3417] = {
        3417,
        3418,
        3419,
        3420,
        3421,
        3422
      },
      [3339] = {
        3339,
        3340,
        3341,
        3342
      },
      [3367] = {
        3367,
        3368,
        3369,
        3370,
        3371,
        3372
      },
      [3448] = {
        3448,
        3449,
        3450,
        3451,
        3452,
        3453
      },
      [3373] = {
        3373,
        3374,
        3375,
        3376
      }
    },
    awaken = {
      [3458] = {3458},
      [3934] = {
        3934,
        3935,
        3936,
        3937
      },
      [3924] = {
        3924,
        3925,
        3926
      },
      [3944] = {
        3944,
        3945,
        3946
      },
      [3929] = {
        3929,
        3930,
        3931,
        3932
      },
      [3916] = {
        3916,
        3917,
        3918,
        3919
      }
    }
  }
}
function Panel_SkkillCommand_ShowAni()
end
function Panel_SkkillCommand_HideAni()
end
function skillCommand:Init()
  for i = 0, self.viewableMaxSkillCount - 1 do
    local slot = {}
    slot._mainBG = UI.createAndCopyBasePropertyControl(Panel_SkillCommand, "Static_C_SkillBG", Panel_SkillCommand, "skillCommand_mainBG_" .. i)
    slot._blueBG = UI.createAndCopyBasePropertyControl(Panel_SkillCommand, "Static_C_SkillBlueBG", slot._mainBG, "skillCommand_blueBG_" .. i)
    slot._yellowBG = UI.createAndCopyBasePropertyControl(Panel_SkillCommand, "Static_C_SkillYellowBG", slot._mainBG, "skillCommand_yellowBG_" .. i)
    slot._skillIcon = UI.createAndCopyBasePropertyControl(Panel_SkillCommand, "Static_C_SkillIcon", slot._mainBG, "skillCommand_skillIcon_" .. i)
    slot._skillName = UI.createAndCopyBasePropertyControl(Panel_SkillCommand, "StaticText_C_SkillName", slot._mainBG, "skillCommand_skillName_" .. i)
    slot._skillCommandBody = UI.createAndCopyBasePropertyControl(Panel_SkillCommand, "Static_SkillCommandBody", slot._mainBG, "skillCommand_skillCommandBody_" .. i)
    slot._skillCommand = UI.createAndCopyBasePropertyControl(Panel_SkillCommand, "StaticText_C_SkillCommand", slot._mainBG, "skillCommand_skillCommand_" .. i)
    slot._mainBG:SetShow(false)
    slot._blueBG:SetShow(false)
    slot._yellowBG:SetShow(false)
    slot._skillIcon:SetShow(false)
    slot._skillName:SetShow(false)
    slot._skillCommandBody:SetShow(false)
    slot._skillCommand:SetShow(false)
    slot._mainBG:addInputEvent("Mouse_LUp", "SkillCommand_Click(" .. i .. ")")
    self._slots[i] = slot
  end
  SkillCommnad_SetSkillTable(CppEnums.ClassType.ClassType_ShyWomen == getSelfPlayer():getClassType())
  Panel_SkillCommand:SetSize(300, 250)
end
function skillCommand:Open(actorKeyRaw)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if false == questList_isClearQuest(21117, 2) and 1 >= getSelfPlayer():get():getLevel() then
    return
  end
  if 0 == self.skillCount then
    return
  end
  for i = 0, self.skillCount - 1 do
    local slot = self._slots[i]
    local slotConfig = self._config.pos
    slot._mainBG:SetShow(true)
    slot._skillIcon:SetShow(true)
    slot._skillName:SetShow(true)
    slot._skillCommandBody:SetShow(true)
    slot._blueBG:SetShow(false)
    slot._yellowBG:SetShow(false)
  end
  self.sizeUpCount = 0
  Panel_SkillCommand:SetSize(300, 250)
  if nil ~= actorKeyRaw then
    SkillCommand_SetServantSkill(actorKeyRaw)
  else
    skillCommand:SetSkill()
  end
  Panel_SkillCommand:SetShow(true)
  if true == _ContentsGroup_RenewUI_Main then
    Panel_SkillCommand:SetShow(false)
  end
end
function skillCommand:getSkillNoFromGroup(skillNo)
  if nil == skillNo then
    return skillNo
  end
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  if nil ~= skillLevelInfo then
    local skillGroup
    skillGroup = classSkillList[getSelfPlayer():getClassType()].normal
    if nil ~= skillGroup and nil ~= skillGroup[skillNo] then
      local leanSkill = skillNo
      for value, skillKey in pairs(skillGroup[skillNo]) do
        local isLearned = ToClient_isLearnedSkill(skillKey)
        if true == isLearned then
          leanSkill = skillKey
        end
      end
      skillNo = leanSkill
    end
    skillGroup = classSkillList[getSelfPlayer():getClassType()].awaken
    if nil ~= skillGroup and nil ~= skillGroup[skillNo] then
      local leanSkill = skillNo
      for value, skillKey in pairs(skillGroup[skillNo]) do
        local isLearned = ToClient_isLearnedSkill(skillKey)
        if true == isLearned then
          leanSkill = skillKey
        end
      end
      skillNo = leanSkill
    end
  end
  return skillNo
end
function FromClient_SkillCommandList(skillNo, isAwaken)
  local self = skillCommand
  if isAwaken then
    if 2 ~= self._weaponType then
      return
    end
  elseif 1 == self._weaponType or 0 == self._weaponType then
  else
    return
  end
  if 0 < #self.skilldatatable then
    local skillCheck = false
    for index = 1, #self.skilldatatable do
      if self.skilldatatable[index] == skillNo then
        skillCheck = true
      end
    end
    if not skillCheck then
      table.insert(self.skilldatatable, skillNo)
      self.recommandSkillCount = self.recommandSkillCount + 1
    end
  else
    table.insert(self.skilldatatable, skillNo)
    self.recommandSkillCount = self.recommandSkillCount + 1
  end
  self.skillCommandShowkeep[self.lvupSkillCount + self.recommandSkillCount - 1] = false
  self.elapsedTime = 0
end
function FromClient_SkillCommandListonLevelUp(skillNo, isAwaken)
  local self = skillCommand
  if isAwaken then
    if 2 == self._weaponType then
      FromClient_SkillCommandDataSet()
    end
    return
  elseif 1 == self._weaponType or 0 == self._weaponType then
  else
    return
  end
  if 0 < #self.skilldatatable then
    local skillCheck = false
    for index = 1, #self.skilldatatable do
      if self.skilldatatable[index] == skillNo then
        skillCheck = true
      end
    end
    if not skillCheck then
      table.insert(self.skilldatatable, skillNo)
      self.lvupSkillCount = self.lvupSkillCount + 1
    end
  else
    table.insert(self.skilldatatable, skillNo)
    self.lvupSkillCount = self.lvupSkillCount + 1
  end
  self.skillCommandShowkeep[self.lvupSkillCount - 1] = true
  self.elapsedTime = 0
end
function FromClient_CheckLevelUpforSkillCommand()
  skillCommand.lvupSkillCount = 0
  SkillCommand_Reset()
end
function FromClient_SkillCommandDataSet()
  SkillCommand_Reset()
  if nil == getSelfPlayer() then
    return
  end
  local pcPosition = getSelfPlayer():get():getPosition()
  local regionInfo = getRegionInfoByPosition(pcPosition)
  if regionInfo:get():isSafeZone() then
    return
  end
  local self = skillCommand
  if true == skillCommand._isServantRide and nil ~= self._actorKeyRaw then
    self.skillCount = SkillCommand_GetServantSkillCount(self._actorKeyRaw)
  else
    ToClient_RequestCommandList()
    self.skillCount = self.recommandSkillCount + self.lvupSkillCount
  end
  if 0 == self.skillCount then
    return
  end
  if isChecked_SkillCommand then
    if true == skillCommand._isServantRide and nil ~= self._actorKeyRaw then
      self:Open(self._actorKeyRaw)
    else
      self:Open()
    end
  end
  self.lvupSkillCount = 0
end
function SkillCommand_SetSkillShow(skillNo, isShow)
  if false == _ContentsGroup_SkillEffect then
    return
  end
  if nil == skillNo or nil == isShow then
    return
  end
  local self = skillCommand
  if true == isShow then
    for index, value in pairs(self.cooltimeSkill) do
      if value == skillNo then
        table.remove(self.cooltimeSkill, index)
      end
    end
  else
    local skillCheck = false
    for index, value in pairs(self.cooltimeSkill) do
      if value == skillNo then
        skillCheck = true
      end
    end
    if false == skillCheck then
      table.insert(self.cooltimeSkill, skillNo)
    end
  end
  local sortFunc = function(a, b)
    return a < b
  end
  table.sort(self.cooltimeSkill, sortFunc)
  local skillAddCnt = 0
  self.sizeUpCount = 0
  for i = 0, self.skillCount - 1 do
    local slot = self._slots[i]
    local isDoubleSize = false
    local skillNo = self.skilldatatable[i + 1]
    local skillKey = self:getSkillNoFromGroup(skillNo)
    local isShow = true
    for index, value in pairs(self.cooltimeSkill) do
      if skillKey == value then
        isShow = false
      end
    end
    local skillTypeWrapper = getSkillTypeStaticStatus(skillKey)
    if nil ~= skillTypeWrapper then
      local name = skillTypeWrapper:getName()
      if nil ~= name then
        slot._skillName:SetText(name)
      end
    end
  end
end
function skillCommand:SetSkill()
  for i = 0, self.skillCount - 1 do
    local skillWrapper = getSkillCommandStatus(self.skilldatatable[i + 1])
    local skillKey = self:getSkillNoFromGroup(self.skilldatatable[i + 1])
    local skillTypeWrapper = getSkillTypeStaticStatus(skillKey)
    local name = ""
    local iconPath = ""
    if nil ~= skillTypeWrapper then
      name = skillTypeWrapper:getName()
      iconPath = skillTypeWrapper:getIconPath()
    else
      name = skillWrapper:getName()
      iconPath = skillWrapper:getIconPath()
    end
    local slot = self._slots[i]
    slot._skillIcon:ChangeTextureInfoNameAsync("Icon/" .. iconPath)
    slot._skillIcon:SetMonoTone(false)
    slot._skillName:SetText(name)
    self.skillNameSizeX = math.max(self.skillNameSizeX, slot._skillName:GetPosX() + slot._skillName:GetTextSizeX())
  end
  local maxBgSizeX = 0
  for i = 0, self.skillCount - 1 do
    local skillWrapper = getSkillCommandStatus(self.skilldatatable[i + 1])
    local command = skillWrapper:getCommand()
    local slot = self._slots[i]
    local isDoubleSize = false
    self.skillCommand[i] = 0
    self.skillCommandControl[i] = {}
    command = SkillCommand_SearchCommand(command, i, self.skilldatatable[i + 1])
    slot._skillCommandBody:SetPosX(self.skillNameSizeX)
    self._slots[i]._mainBG:SetPosY(0 + (i + self.sizeUpCount) * 30 + i * 2)
    if Panel_SkillCommand:GetSizeX() < slot._skillCommandBody:GetPosX() + slot._skillCommandBody:GetSizeX() then
      if slot._skillCommandBody:GetPosX() + slot._skillCommandBody:GetSizeX() > 500 then
        Panel_SkillCommand:SetSize(400, 250)
      end
      isDoubleSize = skillCommand:CommandControl_RePos(i)
    end
    slot.isDoubleSize = isDoubleSize
    if true == isDoubleSize then
      slot._skillName:SetPosY(15)
      slot._skillIcon:SetPosY(17)
      self.sizeUpCount = self.sizeUpCount + 1
    else
      slot._skillIcon:SetPosY(2)
      slot._skillName:SetPosY(0)
    end
    maxBgSizeX = math.max(maxBgSizeX, self.skillNameSizeX + slot._skillCommandBody:GetSizeX())
  end
  for i = 0, self.skillCount - 1 do
    local slot = self._slots[i]
    slot._mainBG:SetSize(maxBgSizeX, slot._skillCommandBody:GetSizeY())
    slot._blueBG:SetSize(maxBgSizeX, slot._skillCommandBody:GetSizeY())
    slot._yellowBG:SetSize(maxBgSizeX, slot._skillCommandBody:GetSizeY())
  end
  for i = 0, self.skillCount - 1 do
    if self.skillCommandShowkeep[i] then
      self._slots[i]._blueBG:SetShow(true)
    end
  end
end
function skillCommand:CommandControl_RePos(index)
  local slot = self._slots[index]
  local basePosX = slot._skillCommandBody:GetPosX()
  local tempPosX = 5
  local skillCommandSizeX = Panel_SkillCommand:GetSizeX() - slot._skillCommandBody:GetPosX()
  local skillCommandSizeY = 30
  local isDoubleSize = false
  for controlCountIndex = 0, #self.skillCommandControl[index] do
    local controlPos = self.skillCommandControl[index][controlCountIndex]:GetPosX() + self.skillCommandControl[index][controlCountIndex]:GetSizeX() + basePosX
    local continue = false
    if skillCommandSizeX < tempPosX + self.skillCommandControl[index][controlCountIndex]:GetSizeX() then
      skillCommandSizeX = tempPosX + self.skillCommandControl[index][controlCountIndex]:GetSizeX()
      if 5 == tempPosX then
        continue = true
      end
    end
    if controlPos > Panel_SkillCommand:GetSizeX() and false == continue then
      self.skillCommandControl[index][controlCountIndex]:SetPosX(tempPosX)
      self.skillCommandControl[index][controlCountIndex]:SetPosY(self.skillCommandControl[index][controlCountIndex]:GetPosY() + 30)
      tempPosX = tempPosX + self.skillCommandControl[index][controlCountIndex]:GetSizeX() + 5
      skillCommandSizeY = 60
      isDoubleSize = true
    end
  end
  slot._skillCommandBody:SetSize(skillCommandSizeX, skillCommandSizeY)
  return isDoubleSize
end
function SkillCommand_StringMatchForConvert(commandIndex, stringIndex, plusIndex)
  local returnValue
  if nil ~= commandIndex then
    returnValue = 0
    if nil ~= stringIndex then
      if stringIndex < commandIndex then
        returnValue = 1
      end
      if nil ~= plusIndex and plusIndex < math.min(commandIndex, stringIndex) then
        returnValue = 2
      end
    elseif nil ~= plusIndex and plusIndex < commandIndex then
      returnValue = 2
    end
  elseif nil ~= stringIndex then
    returnValue = 1
    if nil ~= plusIndex and plusIndex < stringIndex then
      returnValue = 2
    end
  elseif nil ~= plusIndex then
    returnValue = 2
  end
  return returnValue
end
function skillCommand:commandControlRePos(controlType, text, uiIndex)
  local tempControl
  tempControl = self.skillCommandControl[uiIndex][self.skillCommand[uiIndex]]
  tempControl:SetPosY(0)
  if 0 == controlType then
    if "LB" ~= text and "RB" ~= text then
      tempControl:SetText(text)
      tempControl:SetSize(tempControl:GetTextSizeX() + 10, tempControl:GetSizeY())
      tempControl:SetPosY(2)
    end
  elseif 1 == controlType then
    tempControl:SetText(text)
    tempControl:SetSize(tempControl:GetTextSizeX() + 10, tempControl:GetSizeY())
  elseif 2 == controlType then
    tempControl:SetPosY(6)
  end
  tempControl:SetShow(true)
  local tempPosX = self._slots[uiIndex]._skillCommandBody:GetSizeX()
  tempControl:SetPosX(tempPosX)
  self._slots[uiIndex]._skillCommandBody:SetSize(tempPosX + tempControl:GetSizeX() + 5, self._slots[uiIndex]._skillCommandBody:GetSizeY())
  self.skillCommand[uiIndex] = self.skillCommand[uiIndex] + 1
end
function skillCommand:commandControlSet(controlType, text, uiIndex)
  local tempControl
  if 0 == controlType then
    if "LB" == text then
      tempControl = UI.createAndCopyBasePropertyControl(Panel_SkillCommand, "Static_CommandLMouse", self._slots[uiIndex]._skillCommandBody, "Static_CommandLMouse_" .. uiIndex .. "_" .. self.skillCommand[uiIndex])
    elseif "RB" == text then
      tempControl = UI.createAndCopyBasePropertyControl(Panel_SkillCommand, "Static_CommandRMouse", self._slots[uiIndex]._skillCommandBody, "Static_CommandRMouse_" .. uiIndex .. "_" .. self.skillCommand[uiIndex])
    else
      tempControl = UI.createAndCopyBasePropertyControl(Panel_SkillCommand, "StaticText_CommandBg", self._slots[uiIndex]._skillCommandBody, "StaticText_CommandBG_" .. uiIndex .. "_" .. self.skillCommand[uiIndex])
      tempControl:SetText(text)
      tempControl:SetSize(tempControl:GetTextSizeX() + 10, tempControl:GetSizeY())
      tempControl:SetPosY(2)
    end
  elseif 1 == controlType then
    tempControl = UI.createAndCopyBasePropertyControl(Panel_SkillCommand, "StaticText_Command", self._slots[uiIndex]._skillCommandBody, "StaticText_Command_" .. uiIndex .. "_" .. self.skillCommand[uiIndex])
    tempControl:SetText(text)
    tempControl:SetSize(tempControl:GetTextSizeX() + 10, tempControl:GetSizeY())
  elseif 2 == controlType then
    tempControl = UI.createAndCopyBasePropertyControl(Panel_SkillCommand, "Static_CommandPlus", self._slots[uiIndex]._skillCommandBody, "Static_CommandPlus_" .. uiIndex .. "_" .. self.skillCommand[uiIndex])
    tempControl:SetPosY(6)
  end
  tempControl:SetShow(true)
  local tempPosX = self._slots[uiIndex]._skillCommandBody:GetSizeX()
  tempControl:SetPosX(tempPosX)
  self._slots[uiIndex]._skillCommandBody:SetSize(tempPosX + tempControl:GetSizeX() + 5, self._slots[uiIndex]._skillCommandBody:GetSizeY())
  self.skillCommandControl[uiIndex][self.skillCommand[uiIndex]] = tempControl
  self.skillCommand[uiIndex] = self.skillCommand[uiIndex] + 1
end
function SkillCommand_RePosCommand(command, index, skillNo)
  local self = skillCommand
  local commandIndex = string.find(command, "<")
  local stringIndex = string.find(command, "[%[]")
  local plusIndex = string.find(command, "+")
  local swapIndex = SkillCommand_StringMatchForConvert(commandIndex, stringIndex, plusIndex)
  if 0 == swapIndex then
    local text = string.sub(command, commandIndex + 1, string.find(command, ">") - 1)
    self:commandControlRePos(0, text, index)
    command = string.gsub(command, "<" .. text .. ">", "", 1)
  elseif 1 == swapIndex then
    local text = string.sub(command, stringIndex + 1, string.find(command, "[%]]") - 1)
    self:commandControlRePos(1, text, index)
    command = string.gsub(command, "[%[]" .. text .. "[%]]", "", 1)
  elseif 2 == swapIndex then
    local text = string.sub(command, plusIndex, plusIndex)
    self:commandControlRePos(2, text, index)
    command = string.gsub(command, "+", "", 1)
  else
    return
  end
  command = SkillCommand_RePosCommand(command, index, skillNo)
end
function SkillCommand_SearchCommand(command, index, skillNo)
  local self = skillCommand
  local commandIndex = string.find(command, "<")
  local stringIndex = string.find(command, "[%[]")
  local plusIndex = string.find(command, "+")
  local swapIndex = SkillCommand_StringMatchForConvert(commandIndex, stringIndex, plusIndex)
  if 0 == swapIndex then
    local text = string.sub(command, commandIndex + 1, string.find(command, ">") - 1)
    self:commandControlSet(0, text, index)
    command = string.gsub(command, "<" .. text .. ">", "", 1)
  elseif 1 == swapIndex then
    local text = string.sub(command, stringIndex + 1, string.find(command, "[%]]") - 1)
    self:commandControlSet(1, text, index)
    command = string.gsub(command, "[%[]" .. text .. "[%]]", "", 1)
  elseif 2 == swapIndex then
    local text = string.sub(command, plusIndex, plusIndex)
    self:commandControlSet(2, text, index)
    command = string.gsub(command, "+", "", 1)
  else
    return
  end
  command = SkillCommand_SearchCommand(command, index, skillNo)
end
function SkillCommand_UpdateTime(updateTime)
  local self = skillCommand
  if not self.isLevelUp then
    return
  end
  if nil == self.skilldatatable then
    SkillCommand_Reset()
    return
  end
  self.elapsedTime = self.elapsedTime + updateTime
  if self.elapsedTime > 30 then
    self.lvupSkillCount = 0
    SkillCommand_Reset()
    FromClient_SkillCommandDataSet()
    self.elapsedTime = 0
    self.isLevelUp = false
    for i = 0, self.skillCount - 1 do
      self._slots[i]._blueBG:SetShow(false)
    end
  end
end
function SkillCommand_Reset()
  local self = skillCommand
  if 0 < self.skillCount then
    for i = 0, self.skillCount - 1 do
      self._slots[i]._mainBG:SetShow(false)
      self._slots[i]._skillIcon:SetShow(false)
      self._slots[i]._skillName:SetShow(false)
      self._slots[i]._skillCommand:SetShow(false)
      self._slots[i]._skillCommandBody:SetShow(false)
      self._slots[i]._skillCommandBody:SetSize(5, 30)
      table.remove(self.skilldatatable, self.skillCount - i)
    end
    self.skilldatatable = {}
    for index = 0, self.skillCount - 1 do
      if nil ~= self.skillCommandControl[index] then
        for controlCountIndex = 0, #self.skillCommandControl[index] do
          if nil ~= self.skillCommandControl[index][controlCountIndex] then
            UI.deleteControl(self.skillCommandControl[index][controlCountIndex])
            self.skillCommandControl[index][controlCountIndex] = nil
          end
        end
      end
    end
  end
  self.elapsedTime = 0
  self.skillCount = 0
  self.recommandSkillCount = 0
  self.skillCommand = {}
end
function SkillCommand_Click(index)
  if false == ToClient_IsGrowStepOpen(__eGrowStep_skillWindow) then
    return
  end
  if false == _ContentsGroup_RenewUI_Skill then
    HandleMLUp_SkillWindow_OpenForLearn()
  else
    PaGlobalFunc_Skill_Open()
  end
end
function FGlobal_SkillCommand_ResetPosition()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  if Panel_SkillCommand:GetRelativePosX() == -1 and Panel_SkillCommand:GetRelativePosY() == 1 then
    local initPosX = scrX / 2 * 1.2
    local initPosY = scrY / 2 * 0.85
    Panel_SkillCommand:SetPosX(initPosX)
    Panel_SkillCommand:SetPosY(initPosY)
    changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, false, true, false)
    FGlobal_InitPanelRelativePos(Panel_SkillCommand, initPosX, initPosY)
  elseif Panel_SkillCommand:GetRelativePosX() == 0 and Panel_SkillCommand:GetRelativePosY() == 0 then
    Panel_SkillCommand:SetPosX(scrX / 2 * 1.2)
    Panel_SkillCommand:SetPosY(scrY / 2 * 0.85)
  else
    Panel_SkillCommand:SetPosX(scrX * Panel_SkillCommand:GetRelativePosX() - Panel_SkillCommand:GetSizeX() / 2)
    Panel_SkillCommand:SetPosY(scrY * Panel_SkillCommand:GetRelativePosY() - Panel_SkillCommand:GetSizeY() / 2)
  end
  FGlobal_PanelRepostionbyScreenOut(Panel_SkillCommand)
end
function ScreenReisze_RePosCommand()
  changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, false, true, false)
end
function PaGlobal_SkillCommand_CheckRegion(isShow)
  if nil == Panel_SkillCommand or nil == isShow then
    return
  end
  if false == isChecked_SkillCommand then
    return
  end
  if true == isShow then
    local selfPlayer = getSelfPlayer()
    if nil == selfPlayer then
      return
    end
    local nowRegionInfo = selfPlayer:getCurrentRegionInfo()
    if nil ~= nowRegionInfo then
      local isSaftyZone = nowRegionInfo:get():isSafeZone()
      if false == isSaftyZone then
        FromClient_SkillCommandDataSet()
      end
    end
  else
    Panel_SkillCommand:SetShow(false)
  end
end
function FromClient_RegionChange(regionData)
  if nil == regionData then
    return
  end
  if not isChecked_SkillCommand then
    return
  end
  local isSaftyZone = regionData:get():isSafeZone()
  if not isSaftyZone then
    FromClient_SkillCommandDataSet()
  end
end
function FGlobal_SkillCommand_Show(isShow)
  if isShow then
    FromClient_SkillCommandDataSet()
  end
end
function SkillCommand_LimitLevelCheck()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if not isChecked_SkillCommand then
    return
  end
  if 50 == selfPlayer:get():getLevel() then
    setShowSkillCmd(false)
    isChecked_SkillCommand = false
    GameOption_UpdateOptionChanged()
    return
  end
  skillCommand.isLevelUp = true
  FromClient_SkillCommandDataSet()
end
function SkillCommand_Effect(skillWrapper)
  if not Panel_SkillCommand:GetShow() then
    return
  end
  if false == _ContentsGroup_SkillEffect then
    return
  end
  local self = skillCommand
  if nil ~= skillWrapper then
    local skillNo = skillWrapper:getSkillNo()
    for i = 0, self.skillCount - 1 do
      local skillKey = self:getSkillNoFromGroup(self.skilldatatable[i + 1])
      if skillNo == skillKey then
        local isShow = true
        if true == isShow then
          self._slots[i]._skillIcon:EraseAllEffect()
          if nil == self._slots[i].isDoubleSize or false == self._slots[i].isDoubleSize then
            self._slots[i]._skillIcon:AddEffect("fUI_SkillCommand_01A", false, 125, 0)
          else
            self._slots[i]._skillIcon:AddEffect("fUI_SkillCommand_01B", false, 125, 0)
          end
          SkillCommand_UseEffect(i, true)
        end
      else
      end
    end
  end
end
function SkillCommand_UseEffect(index, isUse)
  local control
  control = skillCommand._slots[index]._blueBG
  if nil == control then
    return
  end
  control:SetShow(true)
  control:SetColor(Defines.Color.C_FFFFFFFF)
  local closeAni = control:addColorAnimation(0, 1.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  closeAni:SetStartColor(Defines.Color.C_FFFFFFFF)
  closeAni:SetEndColor(Defines.Color.C_99FFFFFF)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
  closeAni:SetHideAtEnd(true)
end
function FromClient_SkillCommandWeaponType(weaponType)
  local self = skillCommand
  if self._weaponType == weaponType or 0 == weaponType then
    self._weaponType = weaponType
    return
  else
    self._weaponType = weaponType
    if Panel_SkillCommand:GetShow() == true then
      FromClient_SkillCommandDataSet()
    end
  end
end
function SkillCommand_SetServantSkill(actorKeyRaw)
  local self = skillCommand
  if nil == actorKeyRaw then
    return
  end
  local servantSkillindex = SkillCommand_GetServantSkillTable(actorKeyRaw)
  local servantSkillCount = SkillCommand_GetServantSkillCount(actorKeyRaw)
  local servantWrapper = getServantInfoFromActorKey(actorKeyRaw)
  if nil == servantWrapper then
    _PA_LOG("\235\172\184\236\158\165\237\153\152", "servantWrapper is nil ")
    return
  end
  self.skillNameSizeX = 0
  for i = 0, servantSkillCount - 1 do
    local skillWrapper = servantWrapper:getSkill(servantSkillindex[i + 1])
    local iconPath = skillWrapper:getIconPath()
    local name = skillWrapper:getName()
    local slot = self._slots[i]
    slot._skillIcon:ChangeTextureInfoNameAsync("Icon/" .. iconPath)
    slot._skillName:SetText(name)
    self.skillNameSizeX = math.max(self.skillNameSizeX, slot._skillName:GetPosX() + slot._skillName:GetTextSizeX())
  end
  local maxBgSizeX = 0
  for i = 0, servantSkillCount - 1 do
    local skillWrapper = servantWrapper:getSkill(servantSkillindex[i + 1])
    local command = skillWrapper:getDescription()
    local slot = self._slots[i]
    local isDoubleSize = false
    self.skillCommand[i] = 0
    self.skillCommandControl[i] = {}
    skillCommand:commandControlSet(1, command, i)
    slot._skillCommandBody:SetPosX(self.skillNameSizeX)
    self._slots[i]._mainBG:SetPosY(0 + (i + self.sizeUpCount) * 30 + i * 2)
    if Panel_SkillCommand:GetSizeX() < slot._skillCommandBody:GetPosX() + slot._skillCommandBody:GetSizeX() and slot._skillCommandBody:GetPosX() + slot._skillCommandBody:GetSizeX() > 400 then
      Panel_SkillCommand:SetSize(400, 250)
      self.skillCommandControl[i][self.skillCommand[i] - 1]:SetSize(300, 20)
      self.skillCommandControl[i][self.skillCommand[i] - 1]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      self.skillCommandControl[i][self.skillCommand[i] - 1]:SetText(command)
      self.skillCommandControl[i][self.skillCommand[i] - 1]:SetSpanSize(4, 10)
      self._slots[i]._skillCommandBody:SetSize(310, 50)
      isDoubleSize = true
    end
    if true == isDoubleSize then
      slot._skillName:SetPosY(12)
      slot._skillIcon:SetPosY(14)
      self.sizeUpCount = self.sizeUpCount + 0.69
    else
      slot._skillIcon:SetPosY(2)
      slot._skillName:SetPosY(0)
    end
    maxBgSizeX = math.max(maxBgSizeX, self.skillNameSizeX + slot._skillCommandBody:GetSizeX())
  end
  for i = 0, servantSkillCount - 1 do
    local slot = self._slots[i]
    slot._mainBG:SetSize(maxBgSizeX, slot._skillCommandBody:GetSizeY())
    slot._blueBG:SetSize(maxBgSizeX, slot._skillCommandBody:GetSizeY())
  end
  for i = 0, servantSkillCount - 1 do
    if self.skillCommandShowkeep[i] then
      self._slots[i]._blueBG:SetShow(true)
    end
  end
end
function PaGlobal_SkillCommand_PlayerRideOn(actorKeyRaw)
  local pcPosition = getSelfPlayer():get():getPosition()
  local regionInfo = getRegionInfoByPosition(pcPosition)
  local servantWrapper
  if nil ~= skillCommand._actorKeyRaw then
    servantWrapper = getServantInfoFromActorKey(skillCommand._actorKeyRaw)
  end
  skillCommand._isServantRide = true
  if nil == actorKeyRaw then
    if nil == skillCommand._actorKeyRaw or nil == servantWrapper then
      skillCommand._isServantRide = false
      return
    end
  else
    skillCommand._actorKeyRaw = actorKeyRaw
  end
  if true == isChecked_SkillCommand then
    SkillCommand_Reset()
    skillCommand.skillCount = SkillCommand_GetServantSkillCount(skillCommand._actorKeyRaw)
    if false == regionInfo:get():isSafeZone() then
      skillCommand:Open(skillCommand._actorKeyRaw)
    end
  end
end
function PaGlobal_SkillCommand_PlayerRideOff()
  local selfPlayer = getSelfPlayer()
  skillCommand._isServantRide = false
  skillCommand._actorKeyRaw = nil
  if nil ~= selfPlayer then
    local nowRegionInfo = selfPlayer:getCurrentRegionInfo()
    FromClient_RegionChange(nowRegionInfo)
  end
end
function SkillCommand_GetServantSkillCount(actorKeyRaw)
  local servantWrapper = getServantInfoFromActorKey(actorKeyRaw)
  if nil == servantWrapper then
    return 0
  end
  local returnValue = 0
  for _, value in ipairs(servantSkillList._commonList) do
    local skillWrapper = servantWrapper:getSkill(value)
    if nil ~= skillWrapper and returnValue < 5 then
      returnValue = returnValue + 1
    end
  end
  return returnValue
end
function SkillCommand_GetServantSkillTable(actorKeyRaw)
  local servantWrapper = getServantInfoFromActorKey(actorKeyRaw)
  local returnSkillIndex = {}
  local limitCount = 0
  for _, value in ipairs(servantSkillList._commonList) do
    local skillWrapper = servantWrapper:getSkill(value)
    if nil ~= skillWrapper and limitCount < 5 then
      table.insert(returnSkillIndex, value)
      limitCount = limitCount + 1
    end
  end
  return returnSkillIndex
end
function SkillCommand_ServantInfoUpdate()
  if nil ~= skillCommand._actorKeyRaw then
    PaGlobal_SkillCommand_PlayerRideOn()
  end
end
function SkillCommnad_SetSkillTable(isShai)
  if true == isShai then
    for _, value in ipairs(servantSkillList._forShaiList) do
      table.insert(servantSkillList._commonList, value)
    end
  end
end
skillCommand:Init()
Panel_SkillCommand:RegisterUpdateFunc("SkillCommand_UpdateTime")
registerEvent("FromClient_CheckLevelUpforSkillCommand", "FromClient_CheckLevelUpforSkillCommand")
registerEvent("FromClient_SkillCommandListonLevelUp", "FromClient_SkillCommandListonLevelUp")
registerEvent("EventSelfPlayerLevelUp", "SkillCommand_LimitLevelCheck")
registerEvent("FromClient_SkillCommandList", "FromClient_SkillCommandList")
registerEvent("onScreenResize", "FGlobal_SkillCommand_ResetPosition")
registerEvent("selfPlayer_regionChanged", "FromClient_RegionChange")
registerEvent("FromClient_RenderModeChangeState", "FGlobal_SkillCommand_ResetPosition")
registerEvent("FromClient_SkillCommandWeaponType", "FromClient_SkillCommandWeaponType")
registerEvent("EventSelfPlayerRideOn", "PaGlobal_SkillCommand_PlayerRideOn")
registerEvent("EventSelfPlayerRideOff", "PaGlobal_SkillCommand_PlayerRideOff")
registerEvent("SelfPlayer_AcquireMessage", "Acquire_ProcessMessage")
registerEvent("EventSelfServantUpdate", "SkillCommand_ServantInfoUpdate")
registerEvent("EventlearnedSkill", "FromClient_SkillCommandDataSet")
registerEvent("EventSkillWindowClearSkill", "FromClient_SkillCommandDataSet")
registerEvent("EventSkillWindowClearSkillByPoint", "FromClient_SkillCommandDataSet")
registerEvent("EventSkillWindowClearSkillAll", "FromClient_SkillCommandDataSet")
registerEvent("EventSkillWindowUpdate", "FromClient_SkillCommandDataSet")

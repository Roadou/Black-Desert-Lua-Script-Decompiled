Panel_SeasonTexture:SetShow(false)
local currentMonth = ToClient_GetThisMonth()
local currentDay = ToClient_GetToday()
local isSpring, isSummer, isAutumn
local isWinter = 1 == currentMonth or 12 == currentMonth or 11 == currentMonth
local contentOpen = ToClient_isEventOn("Aurora")
local textureSize = {
  [0] = 400,
  [1] = 700,
  [2] = 1000
}
local panelList = {
  [0] = {
    [0] = Panel_EnableSkill,
    [1] = nil,
    [2] = Panel_ItemMarket_Alarm
  },
  [1] = {
    [0] = Panel_Window_Inventory,
    [1] = Panel_Window_Warehouse,
    [2] = Panel_Window_Option,
    [3] = Panel_Window_Quest_New,
    [4] = Panel_Equipment,
    [5] = Panel_Menu,
    [6] = Panel_ChannelSelect,
    [7] = Panel_Window_PetListNew,
    [8] = Panel_AlchemyFigureHead,
    [9] = Panel_AlchemyStone,
    [10] = Panel_DyePalette,
    [11] = Panel_FriendList,
    [12] = Panel_Mail_Main,
    [13] = Panel_WorkerManager,
    [14] = Panel_GuildWarInfo,
    [15] = Panel_Chatting_Filter,
    [17] = Panel_Window_ServantInfo,
    [18] = Panel_ShipInfo,
    [19] = Panel_WorkerShipInfo,
    [21] = Panel_NewKnowledge,
    [22] = Panel_Win_System,
    [23] = Panel_Window_ItemMarket_Favorite,
    [24] = Panel_Window_GuildWarInfo,
    [25] = Panel_Chat_SocialMenu,
    [26] = Panel_Window_MasterpieceAuction,
    [27] = Panel_Memo_List,
    [28] = Panel_Window_DropItem,
    [29] = Panel_ButtonShortcuts,
    [30] = Panel_SaveSetting,
    [31] = Panel_Window_BlackDesertLab,
    [32] = Panel_BossAlert_SettingV2,
    [33] = Panel_FairyInfo,
    [34] = Panel_CharacterTag,
    [35] = Panel_Window_ItemMarketAlarmList_New,
    [36] = Panel_CheckedQuestInfo,
    [37] = Panel_NpcNavi,
    [39] = Panel_Window_Extraction_EnchantStone,
    [40] = Panel_Window_Extraction_Caphras,
    [41] = Panel_Window_Extraction_Crystal,
    [42] = Panel_Window_Extraction_Cloth,
    [43] = Panel_FixEquip,
    [44] = Panel_Interest_Knowledge,
    [45] = Panel_GuildServantList,
    [46] = Panel_Window_Camp,
    [47] = Panel_WorkerShipInfo,
    [48] = Panel_Window_UnknownRandomSelect,
    [49] = Panel_ItemMarket_PreBid_Manager,
    [50] = Panel_ItemMarket_AlarmList,
    [51] = Panel_IngameCashShop_EasyPayment,
    [52] = Panel_Window_Delivery_Information,
    [54] = Panel_SetVoiceChat,
    [55] = Panel_NodeWarMenu,
    [56] = Panel_Window_Delivery_InformationView,
    [57] = Panel_Window_Enchant,
    [58] = Panel_Window_Socket,
    [59] = Panel_Improvement,
    [60] = Panel_Exchange_Item
  },
  [2] = {
    [2] = Panel_WebControl,
    [3] = Panel_KeyboardHelp,
    [4] = Panel_ProductNote,
    [5] = Panel_Window_Skill,
    [6] = Panel_Manufacture,
    [7] = Panel_FishEncyclopedia,
    [8] = Panel_Window_ItemMarket,
    [9] = Panel_GuildRank_Web,
    [10] = Panel_LifeRanking,
    [11] = Panel_EventNotify,
    [13] = Panel_Window_BlackSpiritAdventure,
    [14] = Panel_LocalWarInfo,
    [15] = Panel_GameExit,
    [16] = Panel_CustomizingAlbum,
    [17] = Panel_ScreenShotAlbum,
    [18] = Panel_Window_MonsterRanking,
    [19] = Panel_Window_BlackSpiritAdventure_2,
    [20] = Panel_Window_PersonalBattle,
    [21] = Panel_SavageDefenceInfo,
    [22] = Panel_Window_Mercenary,
    [23] = Panel_PartyList,
    [24] = Panel_Window_CardGame,
    [25] = Panel_ArmyUnitSetting,
    [26] = Panel_Window_MarketPlace_Main,
    [27] = Panel_HarvestList,
    [28] = Panel_Window_NpcShop,
    [29] = Panel_TradeEventNotice_Renewal,
    [30] = nil,
    [31] = Panel_Window_DailyChallenge,
    [32] = Panel_HousingList,
    [33] = Panel_Window_MaidList,
    [34] = Panel_Window_ItemMarket_ItemSet,
    [35] = Panel_Worker_Auction,
    [36] = Panel_GuildHouse_Auction,
    [37] = Panel_HouseControl,
    [38] = Panel_Window_ReinforceSkill,
    [39] = Panel_Window_StableMarket
  }
}
if _ContentsGroup_isNewOption then
  panelList[1][2] = Panel_Window_cOption
end
if _ContentsGroup_isUsedNewTradeEventNotice then
  panelList[2][31] = Panel_TradeEventNotice_Renewal
else
  panelList[0][1] = Panel_TradeMarket_EventInfo
end
local textureLink = {
  spring = "",
  summer = "",
  autumn = "",
  winter = "renewal/etc/Remaster_ETC_WinterUI.dds"
}
local ddsLink = ""
if isSpring then
  ddsLink = textureLink.spring
elseif isSummer then
  ddsLink = textureLink.summer
elseif isAutumn then
  ddsLink = textureLink.autumn
elseif isWinter then
  ddsLink = textureLink.winter
end
local windowTopTextureList = {
  [0] = {
    [0] = {
      _x1 = 1,
      _y1 = 286,
      _x2 = 403,
      _y2 = 348
    },
    [1] = {
      _x1 = 484,
      _y1 = 314,
      _x2 = 886,
      _y2 = 376
    },
    [2] = {
      _x1 = 1,
      _y1 = 286,
      _x2 = 403,
      _y2 = 348
    },
    [3] = {
      _x1 = 1,
      _y1 = 286,
      _x2 = 403,
      _y2 = 348
    },
    [4] = {
      _x1 = 1,
      _y1 = 286,
      _x2 = 403,
      _y2 = 348
    }
  },
  [1] = {
    [0] = {
      _x1 = 1,
      _y1 = 131,
      _x2 = 701,
      _y2 = 207
    },
    [1] = {
      _x1 = 1,
      _y1 = 208,
      _x2 = 701,
      _y2 = 284
    },
    [2] = {
      _x1 = 1,
      _y1 = 131,
      _x2 = 701,
      _y2 = 207
    },
    [3] = {
      _x1 = 1,
      _y1 = 131,
      _x2 = 701,
      _y2 = 207
    },
    [4] = {
      _x1 = 1,
      _y1 = 131,
      _x2 = 701,
      _y2 = 207
    }
  },
  [2] = {
    [0] = {
      _x1 = 1,
      _y1 = 1,
      _x2 = 1001,
      _y2 = 65
    },
    [1] = {
      _x1 = 1,
      _y1 = 66,
      _x2 = 1001,
      _y2 = 130
    },
    [2] = {
      _x1 = 1,
      _y1 = 1,
      _x2 = 1001,
      _y2 = 65
    },
    [3] = {
      _x1 = 1,
      _y1 = 1,
      _x2 = 1001,
      _y2 = 65
    },
    [4] = {
      _x1 = 1,
      _y1 = 1,
      _x2 = 1001,
      _y2 = 65
    }
  }
}
local objectList = {
  public = {
    [0] = {
      sizeX = 387,
      sizeY = 39,
      posX = 390,
      posY = 15,
      _x1 = 1,
      _y1 = 349,
      _x2 = 388,
      _y2 = 388
    },
    [1] = {
      sizeX = 67,
      sizeY = 63,
      posX = 85,
      posY = -30,
      _x1 = 752,
      _y1 = 223,
      _x2 = 819,
      _y2 = 286
    },
    [2] = {
      sizeX = 49,
      sizeY = 67,
      posX = 90,
      posY = -28,
      _x1 = 702,
      _y1 = 223,
      _x2 = 751,
      _y2 = 290
    },
    [3] = {
      sizeX = 90,
      sizeY = 56,
      posX = 250,
      posY = -20,
      _x1 = 896,
      _y1 = 145,
      _x2 = 986,
      _y2 = 201
    },
    [4] = {
      sizeX = 84,
      sizeY = 57,
      posX = 180,
      posY = -30,
      _x1 = 811,
      _y1 = 145,
      _x2 = 810,
      _y2 = 202
    },
    [5] = {
      sizeX = 108,
      sizeY = 77,
      posX = 250,
      posY = -40,
      _x1 = 702,
      _y1 = 145,
      _x2 = 810,
      _y2 = 222
    },
    [6] = {
      sizeX = 79,
      sizeY = 90,
      posX = 130,
      posY = -15,
      _x1 = 404,
      _y1 = 286,
      _x2 = 483,
      _y2 = 376
    },
    [7] = {
      sizeX = 118,
      sizeY = 53,
      posX = 350,
      posY = -25,
      _x1 = 820,
      _y1 = 203,
      _x2 = 938,
      _y2 = 256
    },
    [8] = {
      sizeX = 141,
      sizeY = 48,
      posX = 130,
      posY = -15,
      _x1 = 820,
      _y1 = 257,
      _x2 = 961,
      _y2 = 305
    },
    [9] = {
      sizeX = 52,
      sizeY = 50,
      posX = 350,
      posY = -20,
      _x1 = 939,
      _y1 = 202,
      _x2 = 991,
      _y2 = 252
    }
  }
}
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_TextureChange")
local textureControl = {}
local publicOjectControl = {}
function FromClient_luaLoadComplete_TextureChange()
  if not contentOpen then
    return
  end
  if "" == ddsLink then
    return
  end
  PaGlobal_SeasonTexture_ContentsGroupAddPanel()
  for index = 0, 2 do
    textureControl[index] = {}
    publicOjectControl[index] = {}
    for pIndex, panel in pairs(panelList[index]) do
      local temp = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, panel, "textureControl_" .. index .. "_" .. pIndex)
      temp:SetShow(true)
      temp:SetSize(panel:GetSizeX(), 62)
      temp:SetPosX(0)
      temp:SetPosY(-24)
      temp:SetIgnore(true)
      textureControl[index][pIndex] = temp
      publicOjectControl[index][pIndex] = {}
      publicOjectControl[index][pIndex].snow = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, textureControl[index][pIndex], "publicTexture_ObjectControlSnow_" .. index .. "_" .. pIndex)
      publicOjectControl[index][pIndex].tree = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, textureControl[index][pIndex], "publicTexture_ObjectControlTree_" .. index .. "_" .. pIndex)
      publicOjectControl[index][pIndex].blackSpirit = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, textureControl[index][pIndex], "publicTexture_ObjectControlSpirit_" .. index .. "_" .. pIndex)
      publicOjectControl[index][pIndex].town = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, textureControl[index][pIndex], "publicTexture_ObjectControlTown_" .. index .. "_" .. pIndex)
      publicOjectControl[index][pIndex].penguin = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, textureControl[index][pIndex], "publicTexture_ObjectControlPenguin_" .. index .. "_" .. pIndex)
      publicOjectControl[index][pIndex].snowman = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, textureControl[index][pIndex], "publicTexture_ObjectControlSnowman_" .. index .. "_" .. pIndex)
      publicOjectControl[index][pIndex].cloud = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, textureControl[index][pIndex], "publicTexture_ObjectControlCloud_" .. index .. "_" .. pIndex)
      publicOjectControl[index][pIndex].fishing = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, textureControl[index][pIndex], "publicTexture_ObjectControlFishing_" .. index .. "_" .. pIndex)
      publicOjectControl[index][pIndex].bear = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, textureControl[index][pIndex], "publicTexture_ObjectControlBear_" .. index .. "_" .. pIndex)
      publicOjectControl[index][pIndex].bird = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, textureControl[index][pIndex], "publicTexture_ObjectControlBird_" .. index .. "_" .. pIndex)
      SeasonTexture_ObjectCreate(publicOjectControl[index][pIndex].snow, 0, panel:GetSizeX())
      SeasonTexture_ObjectCreate(publicOjectControl[index][pIndex].tree, 1, panel:GetSizeX())
      SeasonTexture_ObjectCreate(publicOjectControl[index][pIndex].blackSpirit, 2, panel:GetSizeX())
      SeasonTexture_ObjectCreate(publicOjectControl[index][pIndex].town, 3, panel:GetSizeX())
      SeasonTexture_ObjectCreate(publicOjectControl[index][pIndex].penguin, 4, panel:GetSizeX())
      SeasonTexture_ObjectCreate(publicOjectControl[index][pIndex].snowman, 5, panel:GetSizeX())
      SeasonTexture_ObjectCreate(publicOjectControl[index][pIndex].cloud, 6, panel:GetSizeX())
      SeasonTexture_ObjectCreate(publicOjectControl[index][pIndex].fishing, 7, panel:GetSizeX())
      SeasonTexture_ObjectCreate(publicOjectControl[index][pIndex].bear, 8, panel:GetSizeX())
      SeasonTexture_ObjectCreate(publicOjectControl[index][pIndex].bird, 9, panel:GetSizeX())
      panel:RegisterShowPreUpdateFunc("seasonTexturChangebyPanelName")
    end
  end
  seasonTexturChangebyPanelName()
end
function SeasonTexture_ObjectCreate(control, index, panelSizeX)
  local randomPosX = panelSizeX / math.ceil(math.random(1, 10))
  local posX = math.min(randomPosX + objectList.public[index].sizeX, panelSizeX - objectList.public[index].sizeX)
  control:SetSize(objectList.public[index].sizeX, objectList.public[index].sizeY)
  control:SetPosX(posX)
  control:SetPosY(objectList.public[index].posY)
  control:SetShow(false)
  control:SetIgnore(true)
  control:ChangeTextureInfoName(ddsLink)
  local x1, y1, x2, y2 = setTextureUV_Func(control, objectList.public[index]._x1, objectList.public[index]._y1, objectList.public[index]._x2, objectList.public[index]._y2)
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function seasonTexturChangebyPanelName(currentPanelName)
  if not contentOpen then
    return
  end
  local randomPosX = math.ceil(math.random(0, 9))
  for index = 0, 2 do
    for pIndex, panel in pairs(panelList[index]) do
      if nil == currentPanelName or panel:GetID() == currentPanelName then
        local temp = textureControl[index][pIndex]
        if temp:GetSizeX() ~= panel:GetSizeX() then
          if temp:GetSizeX() < panel:GetSizeX() then
            temp:SetSize(panel:GetSizeX(), 62)
          elseif panel:GetSizeX() < temp:GetSizeX() then
            temp:SetSize(panel:GetSizeX(), 62)
          end
        end
        local rndIndex = math.floor(math.random(0, 4))
        temp:ChangeTextureInfoName(ddsLink)
        local x1, y1, x2, y2 = setTextureUV_Func(temp, windowTopTextureList[index][rndIndex]._x1, windowTopTextureList[index][rndIndex]._y1, windowTopTextureList[index][rndIndex]._x2, windowTopTextureList[index][rndIndex]._y2)
        temp:getBaseTexture():setUV(x1, y1, x2, y2)
        temp:setRenderTexture(temp:getBaseTexture())
        publicOjectControl[index][pIndex].snow:SetShow(false)
        publicOjectControl[index][pIndex].tree:SetShow(false)
        publicOjectControl[index][pIndex].blackSpirit:SetShow(false)
        publicOjectControl[index][pIndex].town:SetShow(false)
        publicOjectControl[index][pIndex].penguin:SetShow(false)
        publicOjectControl[index][pIndex].snowman:SetShow(false)
        publicOjectControl[index][pIndex].cloud:SetShow(false)
        publicOjectControl[index][pIndex].fishing:SetShow(false)
        publicOjectControl[index][pIndex].bear:SetShow(false)
        publicOjectControl[index][pIndex].bird:SetShow(false)
        if 1 == index and 6 == pIndex then
          break
        end
        local randomShow = math.floor(math.random(0, 9))
        if 0 == randomShow then
        elseif 1 == randomShow then
          publicOjectControl[index][pIndex].tree:SetShow(true)
        elseif 2 == randomShow then
          publicOjectControl[index][pIndex].blackSpirit:SetShow(true)
        elseif 3 == randomShow then
          publicOjectControl[index][pIndex].town:SetShow(true)
        elseif 4 == randomShow then
          publicOjectControl[index][pIndex].penguin:SetShow(true)
        elseif 5 == randomShow then
          publicOjectControl[index][pIndex].snowman:SetShow(true)
        elseif 6 == randomShow then
          publicOjectControl[index][pIndex].cloud:SetShow(true)
        elseif 7 == randomShow then
          publicOjectControl[index][pIndex].fishing:SetShow(true)
        elseif 8 == randomShow then
          publicOjectControl[index][pIndex].bear:SetShow(true)
        elseif 9 == randomShow then
          publicOjectControl[index][pIndex].bird:SetShow(true)
        end
        return
      end
    end
  end
end
function FGlobal_SeasonTexture_ChannelSelectPanelSizeCahnge(sizeX)
  if isLuaLoadingComplete and contentOpen and nil ~= textureControl[1][6] then
    textureControl[1][6]:SetSize(sizeX, textureControl[1][6]:GetSizeY())
  end
end
function PaGlobal_SeasonTexture_ContentsGroupAddPanel()
  if false == _ContentsGroup_PanelReload_Develop then
    panelList[2][0] = Panel_Window_Guild
    panelList[2][1] = Panel_Window_CharInfo_Status
    panelList[2][12] = Panel_Window_DailyStamp
    panelList[1][38] = Panel_Window_ServantInventory
    panelList[1][20] = Panel_Guild_NoneJoinMember
    if false == _ContentsGroup_NewUI_CreateClan_All then
      panelList[1][53] = Panel_CreateClan
    else
      panelList[1][53] = Panel_CreateClan_All
    end
    panelList[1][16] = Panel_CompetitionGame_JoinDesc
  end
end
local textureIndexList = {
  Panel_Window_Guild = 2,
  Panel_Window_CharInfo_Status = 2,
  Panel_Window_DailyStamp = 2,
  Panel_Window_ServantInventory = 1,
  Panel_Guild_NoneJoinMember = 1,
  Panel_CreateClan = 1,
  Panel_CompetitionGame_JoinDesc = 1
}
local seasonList = {}
function PaGlobal_SeasonTexture_SetPanel(panel)
  if nil == panel then
    return
  end
  local seasonData = {
    _panel = nil,
    _control = nil,
    _objectControl = nil
  }
  seasonData._panel = panel
  seasonData._control = seasonList:getTextureControl(panel)
  seasonData._objectControl = seasonList:getObjectControl(panel, seasonData._control)
  panel:RegisterShowPreUpdateFunc("PaGlobal_SeasonTexture_ShowChangePanelTexture")
  seasonList[panel:GetID()] = seasonData
end
function seasonList:getTextureControl(panel)
  UI.ASSERT_NAME(nil ~= panel, "seasonList:getTextureControl panel nil", "\236\178\156\235\167\140\234\184\176")
  local panelId = panel:GetID()
  local control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, panel, "textureControl_" .. panelId)
  control:SetShow(true)
  control:SetSize(panel:GetSizeX(), 62)
  control:SetPosX(0)
  control:SetPosY(-24)
  control:SetIgnore(true)
  return control
end
function seasonList:getObjectControl(panel, control)
  UI.ASSERT_NAME(nil ~= panel, "seasonList:getObjectControl panel nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= control, "seasonList:getObjectControl control nil", "\236\178\156\235\167\140\234\184\176")
  local panelId = panel:GetID()
  local objectControl = {}
  objectControl.snow = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control, "publicTexture_ObjectControlSnow_" .. panelId)
  objectControl.tree = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control, "publicTexture_ObjectControlTree_" .. panelId)
  objectControl.blackSpirit = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control, "publicTexture_ObjectControlSpirit_" .. panelId)
  objectControl.town = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control, "publicTexture_ObjectControlTown_" .. panelId)
  objectControl.penguin = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control, "publicTexture_ObjectControlPenguin_" .. panelId)
  objectControl.snowman = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control, "publicTexture_ObjectControlSnowman_" .. panelId)
  objectControl.cloud = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control, "publicTexture_ObjectControlCloud_" .. panelId)
  objectControl.fishing = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control, "publicTexture_ObjectControlFishing_" .. panelId)
  objectControl.bear = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control, "publicTexture_ObjectControlBear_" .. panelId)
  objectControl.bird = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control, "publicTexture_ObjectControlBird_" .. panelId)
  SeasonTexture_ObjectCreate(objectControl.snow, 0, panel:GetSizeX())
  SeasonTexture_ObjectCreate(objectControl.tree, 1, panel:GetSizeX())
  SeasonTexture_ObjectCreate(objectControl.blackSpirit, 2, panel:GetSizeX())
  SeasonTexture_ObjectCreate(objectControl.town, 3, panel:GetSizeX())
  SeasonTexture_ObjectCreate(objectControl.penguin, 4, panel:GetSizeX())
  SeasonTexture_ObjectCreate(objectControl.snowman, 5, panel:GetSizeX())
  SeasonTexture_ObjectCreate(objectControl.cloud, 6, panel:GetSizeX())
  SeasonTexture_ObjectCreate(objectControl.fishing, 7, panel:GetSizeX())
  SeasonTexture_ObjectCreate(objectControl.bear, 8, panel:GetSizeX())
  SeasonTexture_ObjectCreate(objectControl.bird, 9, panel:GetSizeX())
  return objectControl
end
function PaGlobal_SeasonTexture_ShowChangePanelTexture(currentPanelName)
  if not contentOpen then
    return
  end
  UI.ASSERT_NAME(nil ~= currentPanelName, "PaGlobal_SeasonTexture_ShowChangePanelTexture currentPanelName nil", "\236\178\156\235\167\140\234\184\176")
  if nil == currentPanelName or nil == seasonList[currentPanelName] then
    return
  end
  local seasonData = seasonList[currentPanelName]
  local panel = seasonData._panel
  local control = seasonData._control
  local objectControl = seasonData._objectControl
  if control:GetSizeX() ~= panel:GetSizeX() then
    if control:GetSizeX() < panel:GetSizeX() then
      control:SetSize(panel:GetSizeX(), 62)
    elseif panel:GetSizeX() < control:GetSizeX() then
      control:SetSize(panel:GetSizeX(), 62)
    end
  end
  local rndIndex = math.floor(math.random(0, 4))
  local index = textureIndexList[currentPanelName]
  UI.ASSERT_NAME(nil ~= index, "PaGlobal_SeasonTexture_ShowChangePanelTexture index nil", "\236\178\156\235\167\140\234\184\176")
  control:ChangeTextureInfoName(ddsLink)
  local x1, y1, x2, y2 = setTextureUV_Func(control, windowTopTextureList[index][rndIndex]._x1, windowTopTextureList[index][rndIndex]._y1, windowTopTextureList[index][rndIndex]._x2, windowTopTextureList[index][rndIndex]._y2)
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
  objectControl.snow:SetShow(false)
  objectControl.tree:SetShow(false)
  objectControl.blackSpirit:SetShow(false)
  objectControl.town:SetShow(false)
  objectControl.penguin:SetShow(false)
  objectControl.snowman:SetShow(false)
  objectControl.cloud:SetShow(false)
  objectControl.fishing:SetShow(false)
  objectControl.bear:SetShow(false)
  objectControl.bird:SetShow(false)
  local randomShow = math.floor(math.random(0, 9))
  if 0 == randomShow then
  elseif 1 == randomShow then
    objectControl.tree:SetShow(true)
  elseif 2 == randomShow then
    objectControl.blackSpirit:SetShow(true)
  elseif 3 == randomShow then
    objectControl.town:SetShow(true)
  elseif 4 == randomShow then
    objectControl.penguin:SetShow(true)
  elseif 5 == randomShow then
    objectControl.snowman:SetShow(true)
  elseif 6 == randomShow then
    objectControl.cloud:SetShow(true)
  elseif 7 == randomShow then
    objectControl.fishing:SetShow(true)
  elseif 8 == randomShow then
    objectControl.bear:SetShow(true)
  elseif 9 == randomShow then
    objectControl.bird:SetShow(true)
  end
end

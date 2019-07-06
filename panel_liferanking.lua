local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
Panel_LifeRanking:SetShow(false, false)
Panel_LifeRanking:RegisterShowEventFunc(true, "LifeRankingShowAni()")
Panel_LifeRanking:RegisterShowEventFunc(false, "LifeRankingHideAni()")
function LifeRankingShowAni()
  UIAni.fadeInSCR_Down(Panel_LifeRanking)
  local aniInfo1 = Panel_LifeRanking:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.2)
  aniInfo1.AxisX = Panel_LifeRanking:GetSizeX() / 2
  aniInfo1.AxisY = Panel_LifeRanking:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_LifeRanking:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.2)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_LifeRanking:GetSizeX() / 2
  aniInfo2.AxisY = Panel_LifeRanking:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function LifeRankingHideAni()
  local aniInfo1 = Panel_LifeRanking:addColorAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local LifeRanking = {
  _txtTitle = UI.getChildControl(Panel_LifeRanking, "StaticText_Title"),
  _btnClose = UI.getChildControl(Panel_LifeRanking, "Button_Win_Close"),
  _btnHelp = UI.getChildControl(Panel_LifeRanking, "Button_Question"),
  _scroll = UI.getChildControl(Panel_LifeRanking, "Scroll_RankingList"),
  _listBg = UI.getChildControl(Panel_LifeRanking, "Static_BG"),
  _myRanking = UI.getChildControl(Panel_LifeRanking, "StaticText_MyRanking"),
  _inMyRankRate = UI.getChildControl(Panel_LifeRanking, "Slider_InMyRank"),
  firstRanker = UI.getChildControl(Panel_LifeRanking, "StaticText_Rank_First"),
  firstRankerName = UI.getChildControl(Panel_LifeRanking, "StaticText_FirstCharacterName"),
  firstRankerGuild = UI.getChildControl(Panel_LifeRanking, "StaticText_FirstGuildName"),
  secondRanker = UI.getChildControl(Panel_LifeRanking, "StaticText_Rank_Second"),
  secondRankerName = UI.getChildControl(Panel_LifeRanking, "StaticText_SecondCharacterName"),
  secondRankerGuild = UI.getChildControl(Panel_LifeRanking, "StaticText_SecondGuildName"),
  thirdRanker = UI.getChildControl(Panel_LifeRanking, "StaticText_Rank_Third"),
  thirdRankerName = UI.getChildControl(Panel_LifeRanking, "StaticText_ThirdCharacterName"),
  thirdRankerGuild = UI.getChildControl(Panel_LifeRanking, "StaticText_ThirdGuildName"),
  _topGrade = {
    UI.getChildControl(Panel_LifeRanking, "StaticText_Grade_First"),
    UI.getChildControl(Panel_LifeRanking, "StaticText_Grade_Second"),
    UI.getChildControl(Panel_LifeRanking, "StaticText_Grade_Third")
  },
  _tab = {
    [0] = UI.getChildControl(Panel_LifeRanking, "RadioButton_Tab_Gathering"),
    [1] = UI.getChildControl(Panel_LifeRanking, "RadioButton_Tab_Fishing"),
    [2] = UI.getChildControl(Panel_LifeRanking, "RadioButton_Tab_Hunting"),
    [3] = UI.getChildControl(Panel_LifeRanking, "RadioButton_Tab_Cook"),
    [4] = UI.getChildControl(Panel_LifeRanking, "RadioButton_Tab_Alchemy"),
    [5] = UI.getChildControl(Panel_LifeRanking, "RadioButton_Tab_Manufacture"),
    [6] = UI.getChildControl(Panel_LifeRanking, "RadioButton_Tab_Mating"),
    [7] = UI.getChildControl(Panel_LifeRanking, "RadioButton_Tab_Trade"),
    [8] = UI.getChildControl(Panel_LifeRanking, "RadioButton_Tab_Growth"),
    [9] = UI.getChildControl(Panel_LifeRanking, "RadioButton_Tab_Sail"),
    [10] = UI.getChildControl(Panel_LifeRanking, "RadioButton_Tab_Wealth"),
    [11] = UI.getChildControl(Panel_LifeRanking, "RadioButton_Tab_Combat"),
    [12] = UI.getChildControl(Panel_LifeRanking, "RadioButton_Tab_LocalWar"),
    [13] = UI.getChildControl(Panel_LifeRanking, "RadioButton_Tab_Rally")
  },
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
  _createTabCount = 14,
  _createListCount = 30,
  _listCount = 0,
  _startIndex = 0,
  _selectedTabIdx = 0,
  _listPool = {},
  _posConfig = {
    _tabStartPosX = 14,
    _tabPosXGap = 100,
    _listStartPosY = 190,
    _listPosYGap = 15.5
  }
}
local rankingTabId = {
  tab_Gathering = 0,
  tab_Fishing = 1,
  tab_Hunting = 2,
  tab_Cook = 3,
  tab_Alchemy = 4,
  tab_Manufacture = 5,
  tab_Mating = 6,
  tab_Trade = 7,
  tab_Growth = 8,
  tab_Sail = 9,
  tab_Wealth = 10,
  tab_Combat = 11,
  tab_LocalWar = 12,
  tab_Rally = 13
}
LifeRanking._btnHelp:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"LifeRanking\" )")
LifeRanking._btnHelp:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"LifeRanking\", \"true\")")
LifeRanking._btnHelp:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"LifeRanking\", \"false\")")
local tooltip = {
  _bg = UI.getChildControl(Panel_LifeRanking, "Static_TooltipBG"),
  _name = UI.getChildControl(Panel_LifeRanking, "Tooltip_Name"),
  _desc = UI.getChildControl(Panel_LifeRanking, "Tooltip_Description")
}
tooltip._desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
tooltip._bg:SetIgnore(true)
local requestCount = 0
function LifeRanking_Initionalize()
  for listIdx = 0, LifeRanking._createListCount - 1 do
    local rankList = {}
    rankList.rank = UI.createAndCopyBasePropertyControl(Panel_LifeRanking, "StaticText_PlayerRank", Panel_LifeRanking, "LifeRanking_Rank_" .. listIdx)
    rankList.rank:SetPosX(47)
    rankList.rank:SetPosY(LifeRanking._posConfig._listStartPosY + LifeRanking._posConfig._listPosYGap * listIdx)
    rankList.name = UI.createAndCopyBasePropertyControl(Panel_LifeRanking, "StaticText_PlayerName", Panel_LifeRanking, "LifeRanking_Name_" .. listIdx)
    rankList.name:SetPosX(86)
    rankList.name:SetPosY(LifeRanking._posConfig._listStartPosY + LifeRanking._posConfig._listPosYGap * listIdx)
    rankList.guild = UI.createAndCopyBasePropertyControl(Panel_LifeRanking, "StaticText_AnotherGuildName", Panel_LifeRanking, "LifeRanking_Guild_" .. listIdx)
    rankList.guild:SetPosX(467)
    rankList.guild:SetPosY(LifeRanking._posConfig._listStartPosY + LifeRanking._posConfig._listPosYGap * listIdx)
    rankList.grade = UI.createAndCopyBasePropertyControl(Panel_LifeRanking, "StaticText_MyLifeGrade", Panel_LifeRanking, "LifeRanking_GradeList_" .. listIdx)
    rankList.grade:SetPosX(645)
    rankList.grade:SetPosY(LifeRanking._posConfig._listStartPosY + LifeRanking._posConfig._listPosYGap * listIdx)
    LifeRanking._listPool[listIdx] = rankList
  end
  LifeRanking._tab[0]:SetCheck(true)
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  Panel_LifeRanking:SetPosX((screenSizeX - Panel_LifeRanking:GetSizeX()) / 2)
  Panel_LifeRanking:SetPosY((screenSizeY - Panel_LifeRanking:GetSizeY()) / 2)
  Panel_LifeRanking:SetChildIndex(tooltip._bg, 9999)
  Panel_LifeRanking:SetChildIndex(tooltip._name, 9999)
  Panel_LifeRanking:SetChildIndex(tooltip._desc, 9999)
end
local rankerData = {}
function LifeRanking:Update()
  local levelFlotFunc = function(lifeRankerWrp)
    if nil == lifeRankerWrp then
      return
    end
    local _const = Defines.s64_const
    local rate = 0
    local rateDisplay = 0
    local s64_needExp = lifeRankerWrp:getNeedExp_s64()
    local s64_exp = lifeRankerWrp:getExperience_s64()
    if s64_needExp > _const.s64_10000 then
      rate = Int64toInt32(s64_exp / (s64_needExp / _const.s64_100))
    elseif _const.s64_0 ~= s64_needExp then
      rate = Int64toInt32(s64_exp * _const.s64_100 / s64_needExp)
    end
    if rate < 10 then
      rateDisplay = ".0" .. rate
    else
      rateDisplay = "." .. rate
    end
    return rateDisplay
  end
  for listIdx = 0, LifeRanking._createListCount - 1 do
    local list = LifeRanking._listPool[listIdx]
    list.rank:SetShow(false)
    list.name:SetShow(false)
    list.guild:SetShow(false)
    list.grade:SetShow(false)
    LifeRanking.firstRanker:SetShow(false)
    LifeRanking.secondRanker:SetShow(false)
    LifeRanking.thirdRanker:SetShow(false)
    LifeRanking.firstRankerName:SetShow(false)
    LifeRanking.secondRankerName:SetShow(false)
    LifeRanking.thirdRankerName:SetShow(false)
    LifeRanking.firstRankerGuild:SetShow(false)
    LifeRanking.secondRankerGuild:SetShow(false)
    LifeRanking.thirdRankerGuild:SetShow(false)
    LifeRanking._topGrade[1]:SetShow(false)
    LifeRanking._topGrade[2]:SetShow(false)
    LifeRanking._topGrade[3]:SetShow(false)
  end
  local count = 0
  local lifeType, lifeRanker, rankerMoney, myLifeRanker, servnerUserCnt, myLifeRankerRate
  if LifeRanking._selectedTabIdx <= 9 then
    LifeRanking._listCount = ToClient_GetLifeRankerCount()
    myLifeRanker = ToClient_GetLifeMyRank()
    servnerUserCnt = ToClient_GetLifeRankerUserCount()
  elseif 10 == LifeRanking._selectedTabIdx then
    LifeRanking._listCount = ToClient_GetContentsRankCount(1)
    myLifeRanker = ToClient_GetContentsMyRank(1)
    servnerUserCnt = ToClient_GetContentsRankUserCount(1)
  elseif 11 == LifeRanking._selectedTabIdx then
    LifeRanking._listCount = ToClient_GetContentsRankCount(0)
    myLifeRanker = ToClient_GetContentsMyRank(0)
    servnerUserCnt = ToClient_GetContentsRankUserCount(0)
  elseif 12 == LifeRanking._selectedTabIdx then
    LifeRanking._listCount = ToClient_GetContentsRankCount(2)
    myLifeRanker = ToClient_GetContentsMyRank(2)
    servnerUserCnt = ToClient_GetContentsRankUserCount(2)
  elseif 13 == LifeRanking._selectedTabIdx then
    LifeRanking._listCount = math.max(ToClient_GetMatchRankerCount(1), 1)
    myLifeRanker = ToClient_GetMyMatchRank(0)
    servnerUserCnt = ToClient_GetMatchRankerUserCount(0)
  end
  myLifeRankerRate = tonumber(myLifeRanker / servnerUserCnt * 100)
  rankerData = {}
  for listIdx = LifeRanking._startIndex, LifeRanking._listCount - 1 do
    if LifeRanking._selectedTabIdx <= 9 then
      lifeRanker = ToClient_GetLifeRankerAt(listIdx)
    elseif 10 == LifeRanking._selectedTabIdx then
      lifeRanker = ToClient_GetMoneyRankAt(listIdx)
    elseif 11 == LifeRanking._selectedTabIdx then
      lifeRanker = ToClient_GetBattleRankAt(listIdx)
    elseif 12 == LifeRanking._selectedTabIdx then
      lifeRanker = ToClient_GetLocalWarRankAt(listIdx)
    elseif 13 == LifeRanking._selectedTabIdx then
      lifeRanker = ToClient_GetMatchRankerAt(0, listIdx)
    end
    if nil == lifeRanker then
      break
    end
    local lifeRankerName = lifeRanker:getUserName()
    local lifeRankerCharName = lifeRanker:getCharacterName()
    local lifeRankerGuild = lifeRanker:getGuildName()
    local lifeRankerIntroDesc = lifeRanker:getUserIntroduction()
    rankerData[listIdx] = {}
    rankerData[listIdx]._name = lifeRankerName
    rankerData[listIdx]._desc = lifeRankerIntroDesc
    local lifeRankerLv
    if 13 == LifeRanking._selectedTabIdx then
      lifeRankerLv = lifeRanker:getMatchPoint()
    elseif 12 == LifeRanking._selectedTabIdx then
      lifeRankerLv = lifeRanker:getAccumulatedKillCount()
    else
      lifeRankerLv = lifeRanker:getLevel()
    end
    if count >= LifeRanking._createListCount or 0 == lifeRankerLv then
      break
    end
    local list = LifeRanking._listPool[count]
    if 0 == listIdx then
      LifeRanking.firstRanker:SetShow(true)
      LifeRanking.firstRankerName:SetShow(true)
      LifeRanking.firstRankerGuild:SetShow(true)
      LifeRanking._topGrade[1]:SetShow(true)
      LifeRanking.firstRanker:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LIFERANKING_RANK", "listIdx", listIdx + 1))
      LifeRanking.firstRankerName:SetText(lifeRankerName .. "(" .. lifeRankerCharName .. ")")
      LifeRanking.firstRankerGuild:SetText(lifeRankerGuild)
      if LifeRanking._selectedTabIdx <= 9 then
        if _ContentsGroup_isUsedNewCharacterInfo == false then
          LifeRanking._topGrade[1]:SetText(FGlobal_CraftLevel_Replace(lifeRankerLv, LifeRanking._selectedTabIdx))
        else
          LifeRanking._topGrade[1]:SetText(FGlobal_UI_CharacterInfo_Basic_Global_CraftLevelReplace(lifeRankerLv))
        end
      elseif 10 == LifeRanking._selectedTabIdx then
        LifeRanking._topGrade[1]:SetShow(false)
      elseif 11 == LifeRanking._selectedTabIdx then
        local levelFlot = levelFlotFunc(lifeRanker)
        LifeRanking._topGrade[1]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. " " .. tostring(lifeRankerLv) .. tostring(levelFlot))
      elseif 12 == LifeRanking._selectedTabIdx then
        LifeRanking._topGrade[1]:SetText(lifeRankerLv)
      elseif 13 == LifeRanking._selectedTabIdx then
        LifeRanking._topGrade[1]:SetText(lifeRankerLv)
      end
      LifeRanking.firstRanker:SetFontColor(UI_color.C_FFEF5378)
      LifeRanking.firstRankerName:SetFontColor(UI_color.C_FFEF5378)
      LifeRanking.firstRankerGuild:SetFontColor(UI_color.C_FFEF5378)
      LifeRanking._topGrade[1]:SetFontColor(UI_color.C_FFEF5378)
      LifeRanking.firstRankerName:addInputEvent("Mouse_LUp", "LifeRanking_RankerWhisper( " .. listIdx .. " )")
      LifeRanking.firstRankerName:addInputEvent("Mouse_On", "LifeRanking_Tooltip( " .. listIdx .. ")")
      LifeRanking.firstRankerName:addInputEvent("Mouse_Out", "LifeRanking_Tooltip()")
    elseif 1 == listIdx then
      LifeRanking.secondRanker:SetShow(true)
      LifeRanking.secondRankerName:SetShow(true)
      LifeRanking.secondRankerGuild:SetShow(true)
      LifeRanking._topGrade[2]:SetShow(true)
      LifeRanking.secondRanker:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LIFERANKING_RANK", "listIdx", listIdx + 1))
      LifeRanking.secondRankerName:SetText(lifeRankerName .. "(" .. lifeRankerCharName .. ")")
      LifeRanking.secondRankerGuild:SetText(lifeRankerGuild)
      if LifeRanking._selectedTabIdx <= 9 then
        if _ContentsGroup_isUsedNewCharacterInfo == false then
          LifeRanking._topGrade[2]:SetText(FGlobal_CraftLevel_Replace(lifeRankerLv, LifeRanking._selectedTabIdx))
        else
          LifeRanking._topGrade[2]:SetText(FGlobal_UI_CharacterInfo_Basic_Global_CraftLevelReplace(lifeRankerLv))
        end
      elseif 10 == LifeRanking._selectedTabIdx then
        LifeRanking._topGrade[2]:SetShow(false)
      elseif 11 == LifeRanking._selectedTabIdx then
        local levelFlot = levelFlotFunc(lifeRanker)
        LifeRanking._topGrade[2]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. " " .. tostring(lifeRankerLv) .. tostring(levelFlot))
      elseif 12 == LifeRanking._selectedTabIdx then
        LifeRanking._topGrade[2]:SetText(lifeRankerLv)
      elseif 13 == LifeRanking._selectedTabIdx then
        LifeRanking._topGrade[2]:SetText(lifeRankerLv)
      end
      LifeRanking.secondRanker:SetFontColor(UI_color.C_FF88DF00)
      LifeRanking.secondRankerName:SetFontColor(UI_color.C_FF88DF00)
      LifeRanking.secondRankerGuild:SetFontColor(UI_color.C_FF88DF00)
      LifeRanking._topGrade[2]:SetFontColor(UI_color.C_FF88DF00)
      LifeRanking.secondRankerName:addInputEvent("Mouse_LUp", "LifeRanking_RankerWhisper( " .. listIdx .. " )")
      LifeRanking.secondRankerName:addInputEvent("Mouse_On", "LifeRanking_Tooltip( " .. listIdx .. ")")
      LifeRanking.secondRankerName:addInputEvent("Mouse_Out", "LifeRanking_Tooltip()")
    elseif 2 == listIdx then
      LifeRanking.thirdRanker:SetShow(true)
      LifeRanking.thirdRankerName:SetShow(true)
      LifeRanking.thirdRankerGuild:SetShow(true)
      LifeRanking._topGrade[3]:SetShow(true)
      LifeRanking.thirdRanker:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LIFERANKING_RANK", "listIdx", listIdx + 1))
      LifeRanking.thirdRankerName:SetText(lifeRankerName .. "(" .. lifeRankerCharName .. ")")
      LifeRanking.thirdRankerGuild:SetText(lifeRankerGuild)
      if LifeRanking._selectedTabIdx <= 9 then
        if _ContentsGroup_isUsedNewCharacterInfo == false then
          LifeRanking._topGrade[3]:SetText(FGlobal_CraftLevel_Replace(lifeRankerLv, LifeRanking._selectedTabIdx))
        else
          LifeRanking._topGrade[3]:SetText(FGlobal_UI_CharacterInfo_Basic_Global_CraftLevelReplace(lifeRankerLv))
        end
      elseif 10 == LifeRanking._selectedTabIdx then
        LifeRanking._topGrade[3]:SetShow(false)
      elseif 11 == LifeRanking._selectedTabIdx then
        local levelFlot = levelFlotFunc(lifeRanker)
        LifeRanking._topGrade[3]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. " " .. tostring(lifeRankerLv) .. tostring(levelFlot))
      elseif 12 == LifeRanking._selectedTabIdx then
        LifeRanking._topGrade[3]:SetText(lifeRankerLv)
      elseif 13 == LifeRanking._selectedTabIdx then
        LifeRanking._topGrade[3]:SetText(lifeRankerLv)
      end
      LifeRanking.thirdRanker:SetFontColor(UI_color.C_FF6DC6FF)
      LifeRanking.thirdRankerName:SetFontColor(UI_color.C_FF6DC6FF)
      LifeRanking.thirdRankerGuild:SetFontColor(UI_color.C_FF6DC6FF)
      LifeRanking._topGrade[3]:SetFontColor(UI_color.C_FF6DC6FF)
      LifeRanking.thirdRankerName:addInputEvent("Mouse_LUp", "LifeRanking_RankerWhisper( " .. listIdx .. " )")
      LifeRanking.thirdRankerName:addInputEvent("Mouse_On", "LifeRanking_Tooltip( " .. listIdx .. ")")
      LifeRanking.thirdRankerName:addInputEvent("Mouse_Out", "LifeRanking_Tooltip()")
    else
      list.rank:SetShow(true)
      list.name:SetShow(true)
      list.guild:SetShow(true)
      list.grade:SetShow(true)
      list.rank:SetFontColor(UI_color.C_FFC4BEBE)
      list.name:SetFontColor(UI_color.C_FFC4BEBE)
      list.guild:SetFontColor(UI_color.C_FFC4BEBE)
      list.grade:SetFontColor(UI_color.C_FFC4BEBE)
      list.rank:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LIFERANKING_RANK", "listIdx", listIdx + 1))
      list.name:SetText(lifeRankerName .. "(" .. lifeRankerCharName .. ")")
      list.guild:SetText(lifeRankerGuild)
      if LifeRanking._selectedTabIdx <= 9 then
        if _ContentsGroup_isUsedNewCharacterInfo == false then
          list.grade:SetText(FGlobal_CraftLevel_Replace(lifeRankerLv, LifeRanking._selectedTabIdx))
        else
          list.grade:SetText(FGlobal_UI_CharacterInfo_Basic_Global_CraftLevelReplace(lifeRankerLv))
        end
      elseif 10 == LifeRanking._selectedTabIdx then
        list.grade:SetShow(false)
      elseif 11 == LifeRanking._selectedTabIdx then
        local levelFlot = levelFlotFunc(lifeRanker)
        list.grade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. " " .. tostring(lifeRankerLv) .. tostring(levelFlot))
      elseif 12 == LifeRanking._selectedTabIdx then
        list.grade:SetText(lifeRankerLv)
      elseif 13 == LifeRanking._selectedTabIdx then
        list.grade:SetText(lifeRankerLv)
      end
      list.name:addInputEvent("Mouse_LUp", "LifeRanking_RankerWhisper( " .. listIdx .. " )")
      list.name:addInputEvent("Mouse_On", "LifeRanking_Tooltip( " .. listIdx .. ")")
      list.name:addInputEvent("Mouse_Out", "LifeRanking_Tooltip()")
    end
    count = count + 1
  end
  lifeType = LifeRanking._tabName[LifeRanking._selectedTabIdx]
  local lifeRankerLv
  if 12 == LifeRanking._selectedTabIdx then
    lifeRankerLv = ToClient_GetMyAccumulatedKillCount()
  elseif 13 == LifeRanking._selectedTabIdx then
    lifeRankerLv = ToClient_GetMyMatchPoint(0)
  else
    lifeRankerLv = 1
  end
  if myLifeRanker <= 30 and lifeRankerLv > 0 then
    if 12 == LifeRanking._selectedTabIdx then
      myLifeRankGroup = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_LIFERANKING_MYRANKING2_LOCALWAR", "lifeType", lifeType, "myLifeRanker", myLifeRanker, "point", lifeRankerLv)
    else
      myLifeRankGroup = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_LIFERANKING_MYRANKING2", "lifeType", lifeType, "myLifeRanker", myLifeRanker)
    end
    LifeRanking._inMyRankRate:SetShow(false)
  elseif 0 == lifeRankerLv then
    myLifeRankGroup = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RALLYRANKING_MYRANK_NOPOINT", "rallyType", lifeType)
    LifeRanking._inMyRankRate:SetShow(false)
  else
    if myLifeRankerRate >= 0 and myLifeRankerRate <= 20 then
      lifeGrade = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_A")
    elseif myLifeRankerRate > 20 and myLifeRankerRate <= 40 then
      lifeGrade = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_B")
    elseif myLifeRankerRate > 40 and myLifeRankerRate <= 60 then
      lifeGrade = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_C")
    elseif myLifeRankerRate > 60 and myLifeRankerRate <= 80 then
      lifeGrade = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_D")
    elseif myLifeRankerRate > 80 and myLifeRankerRate <= 100 then
      lifeGrade = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_E")
    end
    myLifeRankGroup = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_LIFERANKING_GRADETYPE", "lifeType", lifeType, "lifeGrade", tostring(lifeGrade))
    LifeRanking._inMyRankRate:SetShow(true)
  end
  LifeRanking._myRanking:SetText(myLifeRankGroup)
  LifeRanking._inMyRankRate:SetControlPos(myLifeRankerRate)
end
function FromClient_ShowLifeRank()
  if _ContentsGroup_isUsedNewCharacterInfo == true and requestCount > 0 then
    requestCount = requestCount - 1
    return
  end
  audioPostEvent_SystemUi(1, 0)
  Panel_LifeRanking:SetShow(true, true)
  LifeRanking:Update()
end
function FromClient_ShowContentsRank(contentsRankType)
  if nil == contentsRankType then
    return
  end
  FromClient_ShowLifeRank()
end
function LifeRanking_SelectTab(idx)
  for listIdx = 0, LifeRanking._createListCount - 1 do
    local list = LifeRanking._listPool[listIdx]
    list.rank:SetShow(false)
    list.name:SetShow(false)
    list.guild:SetShow(false)
    list.grade:SetShow(false)
  end
  LifeRanking._startIndex = 0
  LifeRanking._selectedTabIdx = idx
  if idx <= 9 then
    ToClient_RequestLifeRanker(idx)
  elseif 10 == idx then
    ToClient_RequestContentsRank(1)
  elseif 11 == idx then
    ToClient_RequestContentsRank(0)
  elseif 12 == idx then
    ToClient_RequestContentsRank(2)
  elseif 13 == idx then
    ToClient_RequestMatchRanker(0)
  end
end
function FGlobal_LifeRanking_Open()
  if Panel_LifeRanking:GetShow() then
    Panel_LifeRanking:SetShow(false, false)
  end
  for idx, value in pairs(LifeRanking._tab) do
    LifeRanking._tab[idx]:SetCheck(false)
  end
  local setShowCount = 0
  for index = 0, 13 do
    if FGlobal_LifeRanking_CheckEnAble(index) then
      LifeRanking._tab[index]:SetShow(true)
      LifeRanking._tab[index]:SetSpanSize(35 + 35 * setShowCount + 5, 60)
      setShowCount = setShowCount + 1
    else
      LifeRanking._tab[index]:SetShow(false)
    end
  end
  LifeRanking._selectedTabIdx = 0
  LifeRanking._tab[0]:SetCheck(true)
  ToClient_RequestLifeRanker(LifeRanking._selectedTabIdx)
end
function FGlobal_LifeRanking_RequestRank(rankType)
  requestCount = requestCount + 1
  ToClient_RequestLifeRanker(rankType)
end
function FGlobal_LifeRanking_Close()
  Panel_LifeRanking:SetShow(false, false)
end
function LifeRanking_RankerWhisper(rankIdx)
  local lifeRanker
  if LifeRanking._selectedTabIdx <= 9 then
    lifeRanker = ToClient_GetLifeRankerAt(rankIdx)
  elseif 11 == LifeRanking._selectedTabIdx then
    lifeRanker = ToClient_GetBattleRankAt(rankIdx)
  elseif 10 == LifeRanking._selectedTabIdx then
    lifeRanker = ToClient_GetMoneyRankAt(rankIdx)
  elseif 12 == LifeRanking._selectedTabIdx then
    lifeRanker = ToClient_GetLocalWarRankAt(rankIdx)
  elseif 13 == LifeRanking._selectedTabIdx then
    lifeRanker = ToClient_GetMatchRankerAt(0, listIdx)
  end
  local lifeRankerCharName = lifeRanker:getCharacterName()
  FGlobal_ChattingInput_ShowWhisper(lifeRankerCharName)
end
function LifeRanking_Simpletooltips(isShow, contolNo)
  local control, name
  if isShow == true then
    contol = LifeRanking._tab[contolNo]
    name = LifeRanking._tabName[contolNo]
    registTooltipControl(contol, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(contol, name, nil)
  else
    TooltipSimple_Hide()
  end
end
function LifeRanking_Repos()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  Panel_LifeRanking:SetPosX((screenSizeX - Panel_LifeRanking:GetSizeX()) / 2)
  Panel_LifeRanking:SetPosY((screenSizeY - Panel_LifeRanking:GetSizeY()) / 2)
end
function LifeRanking_registEventHandler()
  LifeRanking._btnClose:addInputEvent("Mouse_LUp", "FGlobal_LifeRanking_Close()")
  for idx, value in pairs(LifeRanking._tab) do
    LifeRanking._tab[idx]:addInputEvent("Mouse_LUp", "LifeRanking_SelectTab( " .. idx .. " )")
    LifeRanking._tab[idx]:addInputEvent("Mouse_On", "LifeRanking_Simpletooltips( true, " .. idx .. " )")
    LifeRanking._tab[idx]:setTooltipEventRegistFunc("LifeRanking_Simpletooltips( true, " .. idx .. ")")
    LifeRanking._tab[idx]:addInputEvent("Mouse_Out", "LifeRanking_Simpletooltips( false )")
  end
end
function FromClient_ResponseMatchRank_()
  LifeRanking:Update()
end
function FGlobal_LifeRanking_CheckEnAble(rankType)
  local self = rankingTabId
  local returnValue = true
  if self.tab_Hunting == rankType then
    if ToClient_IsContentsGroupOpen("28") then
      returnValue = true
    else
      returnValue = false
    end
  elseif self.tab_Rally == rankType then
    if ToClient_IsContentsGroupOpen("38") then
      returnValue = true
    else
      returnValue = false
    end
  elseif self.tab_LocalWar == rankType then
    if ToClient_IsContentsGroupOpen("43") then
      returnValue = true
    else
      returnValue = false
    end
  elseif self.tab_Sail == rankType then
    if ToClient_IsContentsGroupOpen("83") then
      returnValue = true
    else
      returnValue = false
    end
  end
  return returnValue
end
function FGlobal_LifeRanking_Show(index)
  local rankType
  if 0 == index then
    rankType = 12
  elseif 1 == index then
    rankType = 11
  end
  if nil ~= rankType then
    FGlobal_LifeRanking_Open()
    LifeRanking_SelectTab(rankType)
    for idx, value in pairs(LifeRanking._tab) do
      LifeRanking._tab[idx]:SetCheck(false)
    end
    LifeRanking._tab[rankType]:SetCheck(true)
  end
end
function LifeRanking_registMessageHandler()
  registerEvent("onScreenResize", "LifeRanking_Repos")
  registerEvent("FromClient_ShowLifeRank", "FromClient_ShowLifeRank")
  registerEvent("FromClient_ShowContentsRank", "FromClient_ShowContentsRank")
  registerEvent("FromClient_ResponseMatchRank", "FromClient_ResponseMatchRank_")
end
local function lifeRanking_TooltipHide()
  local self = tooltip
  self._bg:SetShow(false)
  self._name:SetShow(false)
  self._desc:SetShow(false)
end
local function lifeRanking_TooltipShow(uiControl, name, desc, index)
  lifeRanking_TooltipHide()
  local self = tooltip
  self._bg:SetShow(true)
  self._name:SetShow(true)
  self._desc:SetShow(true)
  self._name:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_PLAYERINTRO", "player_name", name))
  local nameLength = math.max(150, self._name:GetTextSizeX())
  self._desc:SetSize(nameLength, self._desc:GetTextSizeY())
  self._desc:SetText(desc)
  self._bg:SetSize(nameLength + 10, self._name:GetSizeY() + self._desc:GetTextSizeY() + 15)
  local posX = 0
  local posY = 0
  if index >= 3 then
    posX = uiControl.name:GetPosX()
    posY = uiControl.name:GetPosY()
  else
    posX = uiControl:GetPosX()
    posY = uiControl:GetPosY()
  end
  self._bg:SetPosX(posX + 20)
  self._bg:SetPosY(posY + 25)
  self._name:SetPosX(self._bg:GetPosX() + 5)
  self._name:SetPosY(self._bg:GetPosY() + 5)
  self._desc:SetPosX(self._name:GetPosX())
  self._desc:SetPosY(self._name:GetPosY() + self._name:GetSizeY())
end
function LifeRanking_Tooltip(index)
  if nil == index then
    lifeRanking_TooltipHide()
    return
  end
  local name = rankerData[index]._name
  local desc = rankerData[index]._desc
  local uiControl
  if 0 == index then
    uiControl = LifeRanking.firstRankerName
  elseif 1 == index then
    uiControl = LifeRanking.secondRankerName
  elseif 2 == index then
    uiControl = LifeRanking.thirdRankerName
  else
    uiControl = LifeRanking._listPool[index]
  end
  if nil == desc or "" == desc then
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_PLAYERINTRO_NODATA")
  end
  lifeRanking_TooltipShow(uiControl, name, desc, index)
end
LifeRanking_Initionalize()
LifeRanking_registEventHandler()
LifeRanking_registMessageHandler()

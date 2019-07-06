Panel_RallyRanking:SetShow(false, false)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
function RallyRankingShowAni()
  UIAni.fadeInSCR_Down(Panel_RallyRanking)
  local aniInfo1 = Panel_RallyRanking:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.2)
  aniInfo1.AxisX = Panel_RallyRanking:GetSizeX() / 2
  aniInfo1.AxisY = Panel_RallyRanking:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_RallyRanking:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.2)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_RallyRanking:GetSizeX() / 2
  aniInfo2.AxisY = Panel_RallyRanking:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function RallyRankingHideAni()
  local aniInfo1 = Panel_RallyRanking:addColorAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local RallyRanking = {
  _btnClose = UI.getChildControl(Panel_RallyRanking, "Button_Win_Close"),
  _listBg = UI.getChildControl(Panel_RallyRanking, "Static_BG"),
  _myRanking = UI.getChildControl(Panel_RallyRanking, "StaticText_MyRanking"),
  _inMyRankRate = UI.getChildControl(Panel_RallyRanking, "Slider_InMyRank"),
  firstRanker = UI.getChildControl(Panel_RallyRanking, "StaticText_First_Rank"),
  firstRankerName = UI.getChildControl(Panel_RallyRanking, "StaticText_FirstCharacterName"),
  firstRankerGuild = UI.getChildControl(Panel_RallyRanking, "StaticText_FirstGuildName"),
  secondRanker = UI.getChildControl(Panel_RallyRanking, "StaticText_Second_Rank"),
  secondRankerName = UI.getChildControl(Panel_RallyRanking, "StaticText_SecondCharacterName"),
  secondRankerGuild = UI.getChildControl(Panel_RallyRanking, "StaticText_SecondGuildName"),
  thirdRanker = UI.getChildControl(Panel_RallyRanking, "StaticText_Third_Rank"),
  thirdRankerName = UI.getChildControl(Panel_RallyRanking, "StaticText_ThirdCharacterName"),
  thirdRankerGuild = UI.getChildControl(Panel_RallyRanking, "StaticText_ThirdGuildName"),
  _topPoint = {
    UI.getChildControl(Panel_RallyRanking, "StaticText_FirstPoint"),
    UI.getChildControl(Panel_RallyRanking, "StaticText_SecondPoint"),
    UI.getChildControl(Panel_RallyRanking, "StaticText_ThirdPoint")
  },
  _tab = {
    [0] = UI.getChildControl(Panel_RallyRanking, "RadioButton_Tab_PartyPvP"),
    [1] = UI.getChildControl(Panel_RallyRanking, "RadioButton_Tab_Race")
  },
  _tabName = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_RALLYRANKING_TAB_PARTYPVP"),
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_RALLYRANKING_TAB_RACE")
  },
  _createTabCount = 2,
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
function RallyRanking_Initionalize()
  for listIdx = 0, RallyRanking._createListCount - 1 do
    local rankList = {}
    rankList.rank = UI.createAndCopyBasePropertyControl(Panel_RallyRanking, "StaticText_PlayerRank", Panel_RallyRanking, "RallyRanking_Rank_" .. listIdx)
    rankList.rank:SetPosX(47)
    rankList.rank:SetPosY(RallyRanking._posConfig._listStartPosY + RallyRanking._posConfig._listPosYGap * listIdx)
    rankList.name = UI.createAndCopyBasePropertyControl(Panel_RallyRanking, "StaticText_PlayerName", Panel_RallyRanking, "RallyRanking_Name_" .. listIdx)
    rankList.name:SetPosX(86)
    rankList.name:SetPosY(RallyRanking._posConfig._listStartPosY + RallyRanking._posConfig._listPosYGap * listIdx)
    rankList.guild = UI.createAndCopyBasePropertyControl(Panel_RallyRanking, "StaticText_PlayerGuildName", Panel_RallyRanking, "RallyRanking_Guild_" .. listIdx)
    rankList.guild:SetPosX(467)
    rankList.guild:SetPosY(RallyRanking._posConfig._listStartPosY + RallyRanking._posConfig._listPosYGap * listIdx)
    rankList.point = UI.createAndCopyBasePropertyControl(Panel_RallyRanking, "StaticText_PlayerPoint", Panel_RallyRanking, "RallyRanking_PointList_" .. listIdx)
    rankList.point:SetPosX(645)
    rankList.point:SetPosY(RallyRanking._posConfig._listStartPosY + RallyRanking._posConfig._listPosYGap * listIdx)
    RallyRanking._listPool[listIdx] = rankList
  end
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  Panel_RallyRanking:SetPosX((screenSizeX - Panel_RallyRanking:GetSizeX()) / 2)
  Panel_RallyRanking:SetPosY((screenSizeY - Panel_RallyRanking:GetSizeY()) / 2)
end
function RallyRanking:Update()
  for listIdx = 0, RallyRanking._createListCount - 1 do
    local list = RallyRanking._listPool[listIdx]
    list.rank:SetShow(false)
    list.name:SetShow(false)
    list.guild:SetShow(false)
    list.point:SetShow(false)
    RallyRanking.firstRanker:SetShow(false)
    RallyRanking.secondRanker:SetShow(false)
    RallyRanking.thirdRanker:SetShow(false)
    RallyRanking.firstRankerName:SetShow(false)
    RallyRanking.secondRankerName:SetShow(false)
    RallyRanking.thirdRankerName:SetShow(false)
    RallyRanking.firstRankerGuild:SetShow(false)
    RallyRanking.secondRankerGuild:SetShow(false)
    RallyRanking.thirdRankerGuild:SetShow(false)
    RallyRanking._topPoint[1]:SetShow(false)
    RallyRanking._topPoint[2]:SetShow(false)
    RallyRanking._topPoint[3]:SetShow(false)
  end
  RallyRanking._listCount = ToClient_GetMatchRankerCount(RallyRanking._selectedTabIdx)
  local count = 0
  local rallyType
  for listIdx = RallyRanking._startIndex, RallyRanking._listCount - 1 do
    local rallyRanker = ToClient_GetMatchRankerAt(RallyRanking._selectedTabIdx, listIdx)
    local rallyRankerName = rallyRanker:getUserName()
    local rallyRankerCharName = rallyRanker:getCharacterName()
    local rallyRankerPoint = rallyRanker:getMatchPoint()
    local rallyRankerGuild = rallyRanker:getGuildName()
    local rallyRankerisMyGuild = rallyRanker:isGuildMember()
    if count >= RallyRanking._createListCount or 0 == rallyRankerPoint then
      break
    end
    local list = RallyRanking._listPool[count]
    if 0 == listIdx then
      RallyRanking.firstRanker:SetShow(true)
      RallyRanking.firstRankerName:SetShow(true)
      RallyRanking.firstRankerGuild:SetShow(true)
      RallyRanking._topPoint[1]:SetShow(true)
      RallyRanking.firstRanker:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RALLYRANKING_RANK", "listIdx", listIdx + 1))
      RallyRanking.firstRankerName:SetText(rallyRankerName .. "(" .. rallyRankerCharName .. ")")
      RallyRanking.firstRankerGuild:SetText(rallyRankerGuild)
      RallyRanking._topPoint[1]:SetText(rallyRankerPoint)
      RallyRanking.firstRanker:SetFontColor(UI_color.C_FFEF5378)
      RallyRanking.firstRankerName:SetFontColor(UI_color.C_FFEF5378)
      RallyRanking.firstRankerGuild:SetFontColor(UI_color.C_FFEF5378)
      RallyRanking._topPoint[1]:SetFontColor(UI_color.C_FFEF5378)
      RallyRanking.firstRankerName:addInputEvent("Mouse_LUp", "RallyRanking_RankerWhisper( " .. listIdx .. " )")
    elseif 1 == listIdx then
      RallyRanking.secondRanker:SetShow(true)
      RallyRanking.secondRankerName:SetShow(true)
      RallyRanking.secondRankerGuild:SetShow(true)
      RallyRanking._topPoint[2]:SetShow(true)
      RallyRanking.secondRanker:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RALLYRANKING_RANK", "listIdx", listIdx + 1))
      RallyRanking.secondRankerName:SetText(rallyRankerName .. "(" .. rallyRankerCharName .. ")")
      RallyRanking.secondRankerGuild:SetText(rallyRankerGuild)
      RallyRanking._topPoint[2]:SetText(rallyRankerPoint)
      RallyRanking.secondRanker:SetFontColor(UI_color.C_FF88DF00)
      RallyRanking.secondRankerName:SetFontColor(UI_color.C_FF88DF00)
      RallyRanking.secondRankerGuild:SetFontColor(UI_color.C_FF88DF00)
      RallyRanking._topPoint[2]:SetFontColor(UI_color.C_FF88DF00)
      RallyRanking.secondRankerName:addInputEvent("Mouse_LUp", "RallyRanking_RankerWhisper( " .. listIdx .. " )")
    elseif 2 == listIdx then
      RallyRanking.thirdRanker:SetShow(true)
      RallyRanking.thirdRankerName:SetShow(true)
      RallyRanking.thirdRankerGuild:SetShow(true)
      RallyRanking._topPoint[3]:SetShow(true)
      RallyRanking.thirdRanker:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RALLYRANKING_RANK", "listIdx", listIdx + 1))
      RallyRanking.thirdRankerName:SetText(rallyRankerName .. "(" .. rallyRankerCharName .. ")")
      RallyRanking.thirdRankerGuild:SetText(rallyRankerGuild)
      RallyRanking._topPoint[3]:SetText(rallyRankerPoint)
      RallyRanking.thirdRanker:SetFontColor(UI_color.C_FF6DC6FF)
      RallyRanking.thirdRankerName:SetFontColor(UI_color.C_FF6DC6FF)
      RallyRanking.thirdRankerGuild:SetFontColor(UI_color.C_FF6DC6FF)
      RallyRanking._topPoint[3]:SetFontColor(UI_color.C_FF6DC6FF)
      RallyRanking.thirdRankerName:addInputEvent("Mouse_LUp", "RallyRanking_RankerWhisper( " .. listIdx .. " )")
    else
      list.rank:SetShow(true)
      list.name:SetShow(true)
      list.guild:SetShow(true)
      list.point:SetShow(true)
      list.rank:SetFontColor(UI_color.C_FFC4BEBE)
      list.name:SetFontColor(UI_color.C_FFC4BEBE)
      list.guild:SetFontColor(UI_color.C_FFC4BEBE)
      list.point:SetFontColor(UI_color.C_FFC4BEBE)
      list.rank:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RALLYRANKING_RANK", "listIdx", listIdx + 1))
      list.name:SetText(rallyRankerName .. "(" .. rallyRankerCharName .. ")")
      list.guild:SetText(rallyRankerGuild)
      list.point:SetText(rallyRankerPoint)
      list.name:addInputEvent("Mouse_LUp", "RallyRanking_RankerWhisper( " .. listIdx .. " )")
    end
    count = count + 1
  end
  local myRallyPoint = ToClient_GetMyMatchPoint(RallyRanking._selectedTabIdx)
  local myRallyRanker = ToClient_GetMyMatchRank(RallyRanking._selectedTabIdx)
  local servnerUserCnt = ToClient_GetMatchRankerUserCount(RallyRanking._selectedTabIdx)
  local myRallyRankerRate = tonumber(myRallyRanker / servnerUserCnt * 100)
  local rallyGrade
  rallyType = RallyRanking._tabName[RallyRanking._selectedTabIdx]
  RallyRanking._inMyRankRate:SetShow(false)
  if myRallyRanker <= 30 and 0 ~= myRallyPoint then
    RallyRanking._myRanking:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_RALLYRANKING_MYRANK", "rallyType", rallyType, "myRallyRanker", myRallyRanker))
  elseif 0 == myRallyPoint then
    RallyRanking._myRanking:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RALLYRANKING_MYRANK_NOPOINT", "rallyType", rallyType))
  else
    if myRallyRankerRate >= 0 and myRallyRankerRate <= 20 then
      rallyGrade = "A"
    elseif myRallyRankerRate > 20 and myRallyRankerRate <= 40 then
      rallyGrade = "B"
    elseif myRallyRankerRate > 40 and myRallyRankerRate <= 60 then
      rallyGrade = "C"
    elseif myRallyRankerRate > 60 and myRallyRankerRate <= 80 then
      rallyGrade = "D"
    elseif myRallyRankerRate > 80 and myRallyRankerRate <= 100 then
      rallyGrade = "E"
    end
    RallyRanking._myRanking:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_RALLYRANKING_GRADETYPE", "rallyType", rallyType, "rallyGrade", rallyGrade))
    RallyRanking._inMyRankRate:SetShow(true)
    RallyRanking._inMyRankRate:SetControlPos(myRallyRankerRate)
  end
end
function RallyRanking_SelectTab(idx)
  for listIdx = 0, RallyRanking._createListCount - 1 do
    local list = RallyRanking._listPool[listIdx]
    list.rank:SetShow(false)
    list.name:SetShow(false)
    list.guild:SetShow(false)
    list.point:SetShow(false)
  end
  RallyRanking._startIndex = 0
  RallyRanking._selectedTabIdx = idx
  ToClient_RequestMatchRanker(RallyRanking._selectedTabIdx)
end
function FGlobal_RallyRanking_Open(reFresh)
  if not reFresh then
    local isMainChannel = getCurrentChannelServerData()._isMain
    local isDevServer = ToClient_IsDevelopment()
    if isMainChannel or isDevServer then
      if Panel_RallyRanking:GetShow() then
        Panel_RallyRanking:SetShow(false, false)
      end
      RallyRanking._selectedTabIdx = 0
      for idx, value in pairs(RallyRanking._tab) do
        RallyRanking._tab[idx]:SetCheck(false)
      end
      RallyRanking._tab[0]:SetCheck(true)
      ToClient_RequestMatchRanker(RallyRanking._selectedTabIdx)
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RALLYRANKING_MSG_ONLYMAINCHANNEL"))
      return
    end
  elseif true == reFresh then
    ToClient_RequestMatchRanker(RallyRanking._selectedTabIdx)
  end
end
function FGlobal_RallyRanking_Close()
  Panel_RallyRanking:SetShow(false, false)
end
function RallyRanking_RankerWhisper(rankIdx)
  local rallyRanker = ToClient_GetMatchRankerAt(RallyRanking._selectedTabIdx, rankIdx)
  local rallyRankerCharName = rallyRanker:getCharacterName()
  FGlobal_ChattingInput_ShowWhisper(rallyRankerCharName)
end
function RallyRanking_Repos()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  Panel_RallyRanking:SetPosX((screenSizeX - Panel_RallyRanking:GetSizeX()) / 2)
  Panel_RallyRanking:SetPosY((screenSizeY - Panel_RallyRanking:GetSizeY()) / 2)
end
function RallyRanking_registEventHandler()
  Panel_RallyRanking:RegisterShowEventFunc(true, "RallyRankingShowAni()")
  Panel_RallyRanking:RegisterShowEventFunc(false, "RallyRankingHideAni()")
  RallyRanking._btnClose:addInputEvent("Mouse_LUp", "FGlobal_RallyRanking_Close()")
  for idx, value in pairs(RallyRanking._tab) do
    RallyRanking._tab[idx]:addInputEvent("Mouse_LUp", "RallyRanking_SelectTab( " .. idx .. " )")
  end
  registerEvent("onScreenResize", "RallyRanking_Repos")
  Panel_RallyRanking:RegisterUpdateFunc("RallyRankingTimeCount")
end
function FromClient_ResponseMatchRank(responsed_RallyType)
  if not Panel_RallyRanking:GetShow() then
    audioPostEvent_SystemUi(1, 0)
    _AudioPostEvent_SystemUiForXBOX(1, 0)
    Panel_RallyRanking:SetShow(true, true)
  end
  RallyRanking:Update()
end
local returnTime = 0
function RallyRankingTimeCount(deltaTime)
  returnTime = returnTime + deltaTime
  if returnTime > 60 then
    returnTime = 0
    FGlobal_RallyRanking_Open(true)
  end
end
RallyRanking_Initionalize()
RallyRanking_registEventHandler()

function PaGlobal_LifeRanking_All:initialize()
  if true == PaGlobal_LifeRanking_All._initialize then
    return
  end
  PaGlobal_LifeRanking_All._ui.stc_TitleBG = UI.getChildControl(Panel_LifeRanking_All, "Static_TitleBg")
  PaGlobal_LifeRanking_All._ui.btn_Close = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_TitleBG, "Button_Close_PCUI")
  PaGlobal_LifeRanking_All._ui.btn_Question = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_TitleBG, "Button_Question_PCUI")
  PaGlobal_LifeRanking_All._ui.stc_RankingTypeBG = UI.getChildControl(Panel_LifeRanking_All, "Static_RankingTypeBG")
  PaGlobal_LifeRanking_All._ui.stc_KeyGuideLB = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_RankingTypeBG, "Static_LB_ConsoleUI")
  PaGlobal_LifeRanking_All._ui.stc_KeyGuideRB = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_RankingTypeBG, "Static_RB_ConsoleUI")
  PaGlobal_LifeRanking_All._ui.txt_CurRankingTypeTitle = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_RankingTypeBG, "StaticText_LifeTitle")
  for i = 0, PaGlobal_LifeRanking_All._MAX_RANKTYPE_COUNT - 1 do
    local typeName = tostring(PaGlobal_LifeRanking_All._rankTypeName[i])
    PaGlobal_LifeRanking_All._ui.stc_RankingIcons[i] = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_RankingTypeBG, "RadioButton_RankIcon" .. typeName)
  end
  PaGlobal_LifeRanking_All._ui.stc_LeftBG = UI.getChildControl(Panel_LifeRanking_All, "Static_LeftBG")
  PaGlobal_LifeRanking_All._ui.stc_GradeBG = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_LeftBG, "Static_GradeBG")
  PaGlobal_LifeRanking_All._ui.stc_CurRankingIconBG = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_GradeBG, "Static_RankingBg")
  PaGlobal_LifeRanking_All._ui.txt_CurRankingGradeValue = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_CurRankingIconBG, "StaticText_RankingValue")
  PaGlobal_LifeRanking_All._ui.txt_CurRankingType = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_GradeBG, "StaticText_MyRankingTitle")
  PaGlobal_LifeRanking_All._ui.stc_GradeBar = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_GradeBG, "Static_GradeBar")
  PaGlobal_LifeRanking_All._ui.stc_GradeBarArrow = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_GradeBar, "Static_Arrow")
  PaGlobal_LifeRanking_All._ui.txt_CurRankingDesc = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_GradeBG, "StaticText_MyRanking")
  PaGlobal_LifeRanking_All._ui.stc_MyRankingBG = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_LeftBG, "Static_MyRankingBG")
  local rankTitle = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_MyRankingBG, "StaticText_Title")
  local rankValue = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_MyRankingBG, "StaticText_Value")
  local defaultPosY = rankTitle:GetPosY()
  local rightTitlePosX = PaGlobal_LifeRanking_All._ui.stc_MyRankingBG:GetSizeX() / 2 + rankTitle:GetSpanSize().x
  local rightValuePosX = PaGlobal_LifeRanking_All._ui.stc_MyRankingBG:GetSizeX() - 60
  for i = 0, PaGlobal_LifeRanking_All._MAX_RANKTYPE_COUNT - 1 do
    local typeName = tostring(PaGlobal_LifeRanking_All._rankTypeName[i])
    PaGlobal_LifeRanking_All._ui.txt_MyRanking_Title[i] = UI.cloneControl(rankTitle, PaGlobal_LifeRanking_All._ui.stc_MyRankingBG, "StaticText_" .. typeName .. "_Title")
    PaGlobal_LifeRanking_All._ui.txt_MyRanking_Value[i] = UI.cloneControl(rankValue, PaGlobal_LifeRanking_All._ui.stc_MyRankingBG, "StaticText_" .. typeName .. "_Value")
    PaGlobal_LifeRanking_All._ui.txt_MyRanking_Title[i]:SetText(PaGlobal_LifeRanking_All._tabName[i])
    PaGlobal_LifeRanking_All._ui.txt_MyRanking_Title[i]:SetPosY(defaultPosY + PaGlobal_LifeRanking_All._rankTitleGapSizeY * (i % 7))
    PaGlobal_LifeRanking_All._ui.txt_MyRanking_Value[i]:SetPosY(defaultPosY + PaGlobal_LifeRanking_All._rankTitleGapSizeY * (i % 7))
    if i > 6 then
      PaGlobal_LifeRanking_All._ui.txt_MyRanking_Title[i]:SetPosX(rightTitlePosX)
      PaGlobal_LifeRanking_All._ui.txt_MyRanking_Value[i]:SetPosX(rightValuePosX)
    end
  end
  rankTitle:SetShow(false)
  rankValue:SetShow(false)
  PaGlobal_LifeRanking_All._ui.stc_ListTitleBG = UI.getChildControl(Panel_LifeRanking_All, "Static_ListTitleBg")
  PaGlobal_LifeRanking_All._ui.txt_CharacterNameTitle = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_ListTitleBG, "StaticText_CharacterName")
  PaGlobal_LifeRanking_All._ui.list2_Ranking = UI.getChildControl(Panel_LifeRanking_All, "List2_RankingListBg")
  PaGlobal_LifeRanking_All._ui.txt_Comment = UI.getChildControl(Panel_LifeRanking_All, "StaticText_Comment")
  PaGlobal_LifeRanking_All._ui.stc_BottomBG = UI.getChildControl(Panel_LifeRanking_All, "Static_BottomBg")
  PaGlobal_LifeRanking_All._ui.txt_KeyGuide_A = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_BottomBG, "StaticText_A_ConsoleUI")
  PaGlobal_LifeRanking_All._ui.txt_KeyGuide_B = UI.getChildControl(PaGlobal_LifeRanking_All._ui.stc_BottomBG, "StaticText_B_ConsoleUI")
  PaGlobal_LifeRanking_All._keyGuideGroup = {
    PaGlobal_LifeRanking_All._ui.txt_KeyGuide_A,
    PaGlobal_LifeRanking_All._ui.txt_KeyGuide_B
  }
  PaGlobal_LifeRanking_All._ui.tooltipBG = UI.getChildControl(Panel_LifeRanking_All, "Static_Tooltip")
  PaGlobal_LifeRanking_All._ui.tooltipName = UI.getChildControl(PaGlobal_LifeRanking_All._ui.tooltipBG, "StaticText_Name")
  PaGlobal_LifeRanking_All._ui.tooltipDesc = UI.getChildControl(PaGlobal_LifeRanking_All._ui.tooltipBG, "StaticText_Desc")
  PaGlobal_LifeRanking_All._ui.list2_Ranking:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  PaGlobal_LifeRanking_All._ui.list2_Ranking:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_LifeRanking_All_CreateRankingList")
  local commentPosX = PaGlobal_LifeRanking_All._ui.txt_Comment:GetPosX()
  PaGlobal_LifeRanking_All._ui.txt_Comment:SetPosX(commentPosX - PaGlobal_LifeRanking_All._ui.txt_Comment:GetTextSizeX())
  PaGlobal_LifeRanking_All._ui.txt_CurRankingDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_LifeRanking_All._ui.tooltipDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_LifeRanking_All._defaultTooltipSizeX = PaGlobal_LifeRanking_All._ui.tooltipBG:GetSizeX()
  PaGlobal_LifeRanking_All:alignTabIcons()
  PaGlobal_LifeRanking_All:prepareForPlatform()
  PaGlobal_LifeRanking_All:registEventHandler()
  PaGlobal_LifeRanking_All._initialize = true
end
function PaGlobal_LifeRanking_All:registEventHandler()
  if nil == Panel_LifeRanking_All then
    return
  end
  registerEvent("onScreenResize", "HandleEvent_LifeRanking_RePos")
  registerEvent("FromClient_ShowLifeRank", "PaGloabl_LifeRanking_UpdateAndShow_All")
  registerEvent("FromClient_ShowContentsRank", "FromClient_LifeRanking_ShowContentsRank_All")
  registerEvent("FromClient_ResponseMatchRank", "PaGloabl_LifeRanking_UpdateAndShow_All")
  registerEvent("FromClient_LifeRanking_Refresh", "FromClient_LifeRanking_Refresh_All")
  registerEvent("FromClient_UpdateLifeRanking", "FromClient_LifeRanking_Update_All")
  if true == _ContentsGroup_RenewUI then
    Panel_LifeRanking_All:registerPadEvent(__eConsoleUIPadEvent_LB, "HandleEvent_LifeRanking_MoveTab(" .. -1 .. ")")
    Panel_LifeRanking_All:registerPadEvent(__eConsoleUIPadEvent_RB, "HandleEvent_LifeRanking_MoveTab(" .. 1 .. ")")
  else
    PaGlobal_LifeRanking_All._ui.btn_Question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"LifeRanking\" )")
    PaGlobal_LifeRanking_All._ui.btn_Question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"LifeRanking\", \"true\")")
    PaGlobal_LifeRanking_All._ui.btn_Question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"LifeRanking\", \"false\")")
    PaGlobal_LifeRanking_All._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_LifeRanking_Close_All()")
    for idx = 0, PaGlobal_LifeRanking_All._MAX_RANKTYPE_COUNT - 1 do
      PaGlobal_LifeRanking_All._ui.stc_RankingIcons[idx]:addInputEvent("Mouse_LUp", "PaGlobal_LifeRanking_All:setTabTo( " .. idx .. " )")
    end
  end
end
function PaGlobal_LifeRanking_All:prepareOpen()
  if nil == Panel_LifeRanking_All and true ~= _ContentsGroup_NewUI_LifeRanking_All then
    return
  end
  PaGlobal_LifeRanking_All:setTabTo(PaGlobal_LifeRanking_All._selectedTabIdx)
  if true == PaGlobal_LifeRanking_All._serverChange then
    for idx = 0, PaGlobal_LifeRanking_All._MAX_RANKTYPE_COUNT - 1 do
      PaGlobal_LifeRanking_All._listUpdate[idx] = false
    end
    ToClient_RequestMyLifeRankRefresh()
  else
    _AudioPostEvent_SystemUiForXBOX(1, 30)
    PaGlobal_LifeRanking_All:update()
    if false == Panel_LifeRanking_All:GetShow() then
      PaGlobal_LifeRanking_All:open()
    end
  end
end
function PaGlobal_LifeRanking_All:open()
  if nil == Panel_LifeRanking_All then
    return
  end
  Panel_LifeRanking_All:SetShow(true)
end
function PaGlobal_LifeRanking_All:prepareClose()
  if nil == Panel_LifeRanking_All then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(1, 30)
  PaGlobal_LifeRanking_All:close()
end
function PaGlobal_LifeRanking_All:close()
  if nil == Panel_LifeRanking_All then
    return
  end
  Panel_LifeRanking_All:SetShow(false)
end
function PaGlobal_LifeRanking_All:update()
  if nil == Panel_LifeRanking_All then
    return
  end
  PaGlobal_LifeRanking_All:updateCurrentTab()
  PaGlobal_LifeRanking_All:updateCurrentGrade()
  if true == PaGlobal_LifeRanking_All._serverChange then
    PaGlobal_LifeRanking_All:MyLifeRankingText_Refresh()
    PaGlobal_LifeRanking_All._serverChange = false
  end
end
function PaGlobal_LifeRanking_All:alignTabIcons()
  if nil == Panel_LifeRanking_All then
    return
  end
  local maxSizeX = PaGlobal_LifeRanking_All._ui.stc_RankingTypeBG:GetSizeX()
  local totalSizeX = 0
  local gapSizeX = 30
  local posX = 0
  for i = 0, PaGlobal_LifeRanking_All._MAX_RANKTYPE_COUNT - 1 do
    local icon = PaGlobal_LifeRanking_All._ui.stc_RankingIcons[i]
    if true == icon:GetShow() then
      totalSizeX = totalSizeX + icon:GetSizeX()
      if PaGlobal_LifeRanking_All._MAX_RANKTYPE_COUNT - 1 ~= i then
        totalSizeX = totalSizeX + gapSizeX
      end
    end
  end
  posX = (maxSizeX - totalSizeX) / 2
  PaGlobal_LifeRanking_All._ui.stc_KeyGuideLB:SetPosX(posX - PaGlobal_LifeRanking_All._ui.stc_KeyGuideLB:GetSizeX() - gapSizeX)
  for i = 0, PaGlobal_LifeRanking_All._MAX_RANKTYPE_COUNT - 1 do
    local icon = PaGlobal_LifeRanking_All._ui.stc_RankingIcons[i]
    if true == icon:GetShow() then
      icon:SetPosX(posX)
      posX = posX + gapSizeX + icon:GetSizeX()
    end
  end
  PaGlobal_LifeRanking_All._ui.stc_KeyGuideRB:SetPosX(posX)
end
function PaGlobal_LifeRanking_All:prepareForPlatform()
  if nil == Panel_LifeRanking_All then
    return
  end
  if true == _ContentsGroup_RenewUI then
    PaGlobal_LifeRanking_All._ui.btn_Question:SetShow(false)
    PaGlobal_LifeRanking_All._ui.btn_Close:SetShow(false)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_LifeRanking_All._keyGuideGroup, PaGlobal_LifeRanking_All._ui.stc_BottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 30)
  else
    PaGlobal_LifeRanking_All._ui.stc_BottomBG:SetShow(false)
    PaGlobal_LifeRanking_All._ui.stc_KeyGuideLB:SetShow(false)
    PaGlobal_LifeRanking_All._ui.stc_KeyGuideRB:SetShow(false)
  end
end
function PaGlobal_LifeRanking_All:updateCurrentTab()
  if nil == Panel_LifeRanking_All then
    return
  end
  if PaGlobal_LifeRanking_All._selectedTabIdx <= 9 then
    PaGlobal_LifeRanking_All._listCount = ToClient_GetLifeRankerCount()
  elseif 10 == PaGlobal_LifeRanking_All._selectedTabIdx then
    PaGlobal_LifeRanking_All._listCount = ToClient_GetContentsRankCount(1)
  elseif 11 == PaGlobal_LifeRanking_All._selectedTabIdx then
    PaGlobal_LifeRanking_All._listCount = ToClient_GetContentsRankCount(0)
  elseif 12 == PaGlobal_LifeRanking_All._selectedTabIdx then
    PaGlobal_LifeRanking_All._listCount = ToClient_GetContentsRankCount(2)
  elseif 13 == PaGlobal_LifeRanking_All._selectedTabIdx then
    PaGlobal_LifeRanking_All._listCount = math.max(ToClient_GetMatchRankerCount(1), 1)
  end
  PaGlobal_LifeRanking_All._rankerData = {}
  PaGlobal_LifeRanking_All._ui.list2_Ranking:getElementManager():clearKey()
  for listIdx = 0, PaGlobal_LifeRanking_All._listCount do
    local lifeRanker = PaGlobal_LifeRanking_All:GetLifeRankerAt(listIdx)
    if nil == lifeRanker then
      break
    end
    local lifeRankerLv = PaGlobal_LifeRanking_All:GetLifeRankerLv(lifeRanker, PaGlobal_LifeRanking_All._selectedTabIdx)
    if 0 == lifeRankerLv then
      break
    end
    PaGlobal_LifeRanking_All._ui.list2_Ranking:getElementManager():pushKey(toInt64(0, listIdx))
  end
  if true == _ContentsGroup_RenewUI then
    ToClient_padSnapResetControl()
  end
end
function PaGlobal_LifeRanking_All:updateCurrentGrade()
  if nil == Panel_LifeRanking_All then
    return
  end
  local myLifeRanker = PaGlobal_LifeRanking_All:GetMyLifeRank(PaGlobal_LifeRanking_All._selectedTabIdx)
  local serverUserCnt = PaGlobal_LifeRanking_All:GetUserCount(PaGlobal_LifeRanking_All._selectedTabIdx)
  local myLifeRankerRate = tonumber(myLifeRanker * 100 / serverUserCnt)
  local myLifeRankGroup
  local lifeType = PaGlobal_LifeRanking_All._tabName[PaGlobal_LifeRanking_All._selectedTabIdx]
  local lifeRankerLv = PaGlobal_LifeRanking_All:CheckMyLifeLv(PaGlobal_LifeRanking_All._selectedTabIdx)
  local lifeGrade
  if myLifeRanker <= 30 and lifeRankerLv > 0 then
    if 12 == PaGlobal_LifeRanking_All._selectedTabIdx then
      myLifeRankGroup = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_LIFERANKING_MYRANKING2_LOCALWAR", "lifeType", lifeType, "myLifeRanker", myLifeRanker, "point", lifeRankerLv)
      PaGlobal_LifeRanking_All._ui.txt_CurRankingGradeValue:SetText(lifeRankerLv)
    else
      myLifeRankGroup = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_LIFERANKING_MYRANKING2", "lifeType", lifeType, "myLifeRanker", myLifeRanker)
      PaGlobal_LifeRanking_All._ui.txt_CurRankingGradeValue:SetText(myLifeRanker)
    end
    PaGlobal_LifeRanking_All._ui.stc_GradeBarArrow:SetShow(false)
    if 1 == myLifeRanker then
      PaGlobal_LifeRanking_All._ui.txt_CurRankingGradeValue:SetFontColor(PaGlobal_LifeRanking_All._rankFontColor[myLifeRanker - 1])
    elseif 2 == myLifeRanker then
      PaGlobal_LifeRanking_All._ui.txt_CurRankingGradeValue:SetFontColor(PaGlobal_LifeRanking_All._rankFontColor[myLifeRanker - 1])
    elseif 3 == myLifeRanker then
      PaGlobal_LifeRanking_All._ui.txt_CurRankingGradeValue:SetFontColor(PaGlobal_LifeRanking_All._rankFontColor[myLifeRanker - 1])
    else
      PaGlobal_LifeRanking_All._ui.txt_CurRankingGradeValue:SetFontColor(PaGlobal_LifeRanking_All._defaultFontColor)
    end
  elseif 0 == lifeRankerLv then
    myLifeRankGroup = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RALLYRANKING_MYRANK_NOPOINT", "rallyType", lifeType)
    PaGlobal_LifeRanking_All._ui.stc_GradeBarArrow:SetShow(false)
    PaGlobal_LifeRanking_All._ui.txt_CurRankingGradeValue:SetText("-")
    PaGlobal_LifeRanking_All._ui.txt_CurRankingGradeValue:SetFontColor(PaGlobal_LifeRanking_All._defaultFontColor)
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
    PaGlobal_LifeRanking_All._ui.txt_CurRankingGradeValue:SetText(lifeGrade)
    PaGlobal_LifeRanking_All._ui.txt_CurRankingGradeValue:SetFontColor(PaGlobal_LifeRanking_All._gradeFontColor[lifeGrade])
    PaGlobal_LifeRanking_All._ui.stc_GradeBarArrow:SetShow(true)
    PaGlobal_LifeRanking_All:setGradeArrowPos(myLifeRankerRate)
  end
  PaGlobal_LifeRanking_All._ui.txt_CurRankingType:SetText(lifeType)
  PaGlobal_LifeRanking_All._ui.txt_CurRankingDesc:SetText(myLifeRankGroup)
end
function PaGlobal_LifeRanking_All:setGradeArrowPos(rate)
  if nil == Panel_LifeRanking_All then
    return
  end
  if nil == rate then
    PaGlobal_LifeRanking_All._ui.stc_GradeBarArrow:SetShow(false)
  end
  local range = PaGlobal_LifeRanking_All._ui.stc_GradeBar:GetSizeX()
  local posX = range * rate / 100 - PaGlobal_LifeRanking_All._ui.stc_GradeBarArrow:GetSizeX() / 2
  PaGlobal_LifeRanking_All._ui.stc_GradeBarArrow:SetPosX(posX)
end
function PaGlobal_LifeRanking_All:MyLifeRankingText_Refresh()
  if nil == Panel_LifeRanking_All then
    return
  end
  for tab = 0, PaGlobal_LifeRanking_All._MAX_RANKTYPE_COUNT - 1 do
    if 13 == tab or 12 == tab then
      local lifeRankerLvTmp = PaGlobal_LifeRanking_All:CheckMyLifeLv(tab)
      if lifeRankerLvTmp == 0 then
        PaGlobal_LifeRanking_All._ui.txt_MyRanking_Value[tab]:SetText("-")
        return
      end
    end
    local myLifeRanking = PaGlobal_LifeRanking_All:GetMyLifeRank(tab)
    if myLifeRanking <= 30 then
      PaGlobal_LifeRanking_All._ui.txt_MyRanking_Value[tab]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LIFERANKING_RANK", "listIdx", myLifeRanking))
      if myLifeRanking > 3 then
        PaGlobal_LifeRanking_All._ui.txt_MyRanking_Value[tab]:SetFontColor(PaGlobal_LifeRanking_All._defaultFontColor)
      elseif 1 == myLifeRanking then
        PaGlobal_LifeRanking_All._ui.txt_MyRanking_Value[tab]:SetFontColor(PaGlobal_LifeRanking_All._rankFontColor[myLifeRanking - 1])
      elseif 2 == myLifeRanking then
        PaGlobal_LifeRanking_All._ui.txt_MyRanking_Value[tab]:SetFontColor(PaGlobal_LifeRanking_All._rankFontColor[myLifeRanking - 1])
      elseif 3 == myLifeRanking then
        PaGlobal_LifeRanking_All._ui.txt_MyRanking_Value[tab]:SetFontColor(PaGlobal_LifeRanking_All._rankFontColor[myLifeRanking - 1])
      else
        PaGlobal_LifeRanking_All._ui.txt_MyRanking_Value[tab]:SetFontColor(PaGlobal_LifeRanking_All._defaultFontColor)
        PaGlobal_LifeRanking_All._ui.txt_MyRanking_Value[tab]:SetText("-")
      end
    else
      local serverUserCnt = PaGlobal_LifeRanking_All:GetUserCount(tab)
      local myLifeRankerRate = tonumber(myLifeRanking * 100 / serverUserCnt)
      local gradeText = ""
      if myLifeRankerRate >= 0 and myLifeRankerRate <= 20 then
        gradeText = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_A")
      elseif myLifeRankerRate > 20 and myLifeRankerRate <= 40 then
        gradeText = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_B")
      elseif myLifeRankerRate > 40 and myLifeRankerRate <= 60 then
        gradeText = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_C")
      elseif myLifeRankerRate > 60 and myLifeRankerRate <= 80 then
        gradeText = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_D")
      elseif myLifeRankerRate > 80 and myLifeRankerRate <= 100 then
        gradeText = PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_E")
      end
      PaGlobal_LifeRanking_All._ui.txt_MyRanking_Value[tab]:SetText(gradeText)
      PaGlobal_LifeRanking_All._ui.txt_MyRanking_Value[tab]:SetFontColor(PaGlobal_LifeRanking_All._gradeFontColor[gradeText])
    end
  end
end
function PaGlobal_LifeRanking_All:LevelFlotFunc(lifeRankerWrp)
  if nil == Panel_LifeRanking_All or nil == lifeRankerWrp then
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
function PaGlobal_LifeRanking_All:RequestLifeRank(tab)
  if nil == Panel_LifeRanking_All then
    return
  end
  if tab <= 9 then
    ToClient_RequestLifeRanker(tab)
  elseif 10 == tab then
    ToClient_RequestContentsRank(1)
  elseif 11 == tab then
    ToClient_RequestContentsRank(0)
  elseif 12 == tab then
    ToClient_RequestContentsRank(2)
  elseif 13 == tab then
    ToClient_RequestMatchRanker(0)
  end
end
function PaGlobal_LifeRanking_All:GetMyLifeRank(tab)
  if nil == Panel_LifeRanking_All then
    return
  end
  local myRank = 0
  if tab <= 9 then
    myRank = ToClient_GetLifeMyRank_Param(tab)
  elseif 10 == tab then
    myRank = ToClient_GetContentsMyRank(1)
  elseif 11 == tab then
    myRank = ToClient_GetContentsMyRank(0)
  elseif 12 == tab then
    myRank = ToClient_GetContentsMyRank(2)
  elseif 13 == tab then
    myRank = ToClient_GetMyMatchRank(0)
  end
  return myRank
end
function PaGlobal_LifeRanking_All:GetUserCount(tab)
  if nil == Panel_LifeRanking_All then
    return
  end
  local userCount = 0
  if tab <= 9 then
    userCount = ToClient_GetLifeRankerUserCount()
  elseif 10 == tab then
    userCount = ToClient_GetContentsRankUserCount(1)
  elseif 11 == tab then
    userCount = ToClient_GetContentsRankUserCount(0)
  elseif 12 == tab then
    userCount = ToClient_GetContentsRankUserCount(2)
  elseif 13 == tab then
    userCount = ToClient_GetMatchRankerUserCount(0)
  end
  return userCount
end
function PaGlobal_LifeRanking_All:GetLifeRankerAt(listIdx)
  if nil == Panel_LifeRanking_All then
    return
  end
  local lifeRanker
  if PaGlobal_LifeRanking_All._selectedTabIdx <= 9 then
    lifeRanker = ToClient_GetLifeRankerAt(listIdx)
  elseif 10 == PaGlobal_LifeRanking_All._selectedTabIdx then
    lifeRanker = ToClient_GetMoneyRankAt(listIdx)
  elseif 11 == PaGlobal_LifeRanking_All._selectedTabIdx then
    lifeRanker = ToClient_GetBattleRankAt(listIdx)
  elseif 12 == PaGlobal_LifeRanking_All._selectedTabIdx then
    lifeRanker = ToClient_GetLocalWarRankAt(listIdx)
  elseif 13 == PaGlobal_LifeRanking_All._selectedTabIdx then
    lifeRanker = ToClient_GetMatchRankerAt(0, listIdx)
  end
  return lifeRanker
end
function PaGlobal_LifeRanking_All:GetLifeRankerLv(lifeRanker, tab)
  if nil == Panel_LifeRanking_All then
    return
  end
  local lifeRankerLv = 0
  if 13 == tab then
    lifeRankerLv = lifeRanker:getMatchPoint()
  elseif 12 == tab then
    lifeRankerLv = lifeRanker:getAccumulatedKillCount()
  else
    lifeRankerLv = lifeRanker:getLevel()
  end
  return lifeRankerLv
end
function PaGlobal_LifeRanking_All:CheckMyLifeLv(tab)
  if nil == Panel_LifeRanking_All then
    return
  end
  local lifeRankerLv = 0
  if 12 == tab then
    lifeRankerLv = ToClient_GetMyAccumulatedKillCount()
  elseif 13 == tab then
    lifeRankerLv = ToClient_GetMyMatchPoint(0)
  else
    lifeRankerLv = 1
  end
  return lifeRankerLv
end
function PaGlobal_LifeRanking_All:moveTabIndex(value)
  if nil == Panel_LifeRanking_All then
    return
  end
  local prevIndex = PaGlobal_LifeRanking_All._selectedTabIdx
  PaGlobal_LifeRanking_All._selectedTabIdx = PaGlobal_LifeRanking_All._selectedTabIdx + value
  if PaGlobal_LifeRanking_All._selectedTabIdx < 0 then
    PaGlobal_LifeRanking_All._selectedTabIdx = 12
  elseif PaGlobal_LifeRanking_All._selectedTabIdx > 12 then
    PaGlobal_LifeRanking_All._selectedTabIdx = 0
  end
  if nil ~= prevIndex then
    local prevIcon = PaGlobal_LifeRanking_All._ui.stc_RankingIcons[prevIndex]
    prevIcon:setRenderTexture(prevIcon:getBaseTexture())
  end
  PaGlobal_LifeRanking_All:setTabTo(PaGlobal_LifeRanking_All._selectedTabIdx)
end
function PaGlobal_LifeRanking_All:setTabTo(idx)
  if nil == Panel_LifeRanking_All then
    return
  end
  PaGlobal_LifeRanking_All._selectedTabIdx = idx
  if idx <= 9 then
    ToClient_SetLifeRankType(idx)
  end
  if PaGlobal_LifeRanking_All._serverChange == true then
    for idx = 0, PaGlobal_LifeRanking_All._MAX_RANKTYPE_COUNT - 1 do
      PaGlobal_LifeRanking_All._listUpdate[idx] = false
    end
    ToClient_RequestMyLifeRankRefresh()
  elseif false == PaGlobal_LifeRanking_All._listUpdate[idx] then
    PaGlobal_LifeRanking_All:RequestLifeRank(idx)
    PaGlobal_LifeRanking_All._listUpdate[idx] = true
  else
    PaGlobal_LifeRanking_All:update()
  end
  local curIcon = PaGlobal_LifeRanking_All._ui.stc_RankingIcons[idx]
  curIcon:setRenderTexture(curIcon:getOnTexture())
  local tabTitle = PaGlobal_LifeRanking_All._ui.txt_CurRankingTypeTitle
  tabTitle:SetText(PaGlobal_LifeRanking_All._tabName[idx])
  tabTitle:SetSize(tabTitle:GetTextSizeX())
  tabTitle:SetPosX(curIcon:GetPosX() + curIcon:GetSizeX() / 2 - tabTitle:GetSizeX() / 2)
end
function PaGlobal_LifeRanking_All:setRankIcon(control, rank)
  if nil == Panel_LifeRanking_All or nil == control or nil == rank then
    return
  end
  control:ChangeTextureInfoName("renewal/etc/console_etc_ranking.dds")
  local texUV = PaGlobal_LifeRanking_All._rankIconTextureUV[rank]
  local x1, y1, x2, y2 = setTextureUV_Func(control, texUV._x1, texUV._y1, texUV._x2, texUV._y2)
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function PaGlobal_LifeRanking_All:validate()
  if nil == Panel_LifeRanking_All then
    return
  end
  for _, control in pairs(PaGlobal_LifeRanking_All._ui) do
    control:isValidate()
  end
end
function PaGlobal_LifeRanking_All:RankerWhisper(listIdx)
  if nil == Panel_LifeRanking_All then
    return
  end
  local lifeRanker
  lifeRanker = PaGlobal_LifeRanking_All:GetLifeRankerAt(listIdx)
  if nil == lifeRanker then
    return
  end
  local lifeRankerCharName = lifeRanker:getCharacterName()
  if true == _ContentsGroup_RenewUI then
    PaGlobalFunc_ChattingHistory_Open(CppEnums.ChatType.Private)
    PaGlobalFunc_ChattingInfo_Open()
    PaGlobalFunc_ChattingInfo_WhisperTo(lifeRankerCharName)
  else
    FGlobal_ChattingInput_ShowWhisper(lifeRankerCharName)
  end
end
function PaGlobal_LifeRanking_All:TooltipHide()
  if nil == Panel_LifeRanking_All then
    return
  end
  PaGlobal_LifeRanking_All._ui.tooltipBG:SetShow(false)
  PaGlobal_LifeRanking_All._ui.tooltipName:SetShow(false)
  PaGlobal_LifeRanking_All._ui.tooltipDesc:SetShow(false)
end
function PaGlobal_LifeRanking_All:TooltipShow(uiControl, name, desc, index)
  if nil == Panel_LifeRanking_All then
    return
  end
  PaGlobal_LifeRanking_All._ui.tooltipBG:SetShow(true)
  PaGlobal_LifeRanking_All._ui.tooltipName:SetShow(true)
  PaGlobal_LifeRanking_All._ui.tooltipDesc:SetShow(true)
  PaGlobal_LifeRanking_All._ui.tooltipName:SetText(name .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_PLAYERINTRO"))
  PaGlobal_LifeRanking_All._ui.tooltipDesc:SetText(desc)
  local sizeX = PaGlobal_LifeRanking_All._ui.tooltipBG:GetSizeX()
  local sizeY = PaGlobal_LifeRanking_All._ui.tooltipDesc:GetTextSizeY() + PaGlobal_LifeRanking_All._ui.tooltipDesc:GetPosY() + 20
  PaGlobal_LifeRanking_All._ui.tooltipBG:SetSize(sizeX, sizeY)
  PaGlobal_LifeRanking_All._ui.tooltipDesc:ComputePos()
  local posX = uiControl:GetPosX() + PaGlobal_LifeRanking_All._ui.list2_Ranking:GetPosX() + 40
  local posY = uiControl:GetPosY() + PaGlobal_LifeRanking_All._ui.list2_Ranking:GetPosY() + 40
  PaGlobal_LifeRanking_All._ui.tooltipBG:SetPosX(posX)
  PaGlobal_LifeRanking_All._ui.tooltipBG:SetPosY(posY)
end
function PaGlobal_LifeRanking_All:Tooltip(index)
  if nil == Panel_LifeRanking_All then
    return
  end
  if nil == index then
    PaGlobal_LifeRanking_All:TooltipHide()
    return
  end
  local uiControl = PaGlobal_LifeRanking_All._ui.list2_Ranking:GetContentByKey(toInt64(0, index))
  local name = PaGlobal_LifeRanking_All._rankerData[index]._name
  local desc = PaGlobal_LifeRanking_All._rankerData[index]._desc
  if nil == desc or "" == desc then
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_PLAYERINTRO_NODATA")
  end
  PaGlobal_LifeRanking_All:TooltipShow(uiControl, name, desc, index)
end
function PaGlobal_LifeRanking_All_CreateRankingList(control, listIdx64)
  local listIdx = Int64toInt32(listIdx64)
  local lifeRanker = PaGlobal_LifeRanking_All:GetLifeRankerAt(listIdx)
  if nil == lifeRanker then
    control:SetShow(false)
    return
  end
  local rankText = UI.getChildControl(control, "StaticText_Rank_Value")
  local nameText = UI.getChildControl(control, "StaticText_CharacterName")
  local guildText = UI.getChildControl(control, "StaticText_GuildName")
  local gradeText = UI.getChildControl(control, "StaticText_Grade_Value")
  local rankIcon = UI.getChildControl(control, "Static_RankIcon")
  local button = UI.getChildControl(control, "Static_BG")
  local lifeRankerLv = PaGlobal_LifeRanking_All:GetLifeRankerLv(lifeRanker, PaGlobal_LifeRanking_All._selectedTabIdx)
  local lifeRankerName = lifeRanker:getUserName()
  local lifeRankerCharName = lifeRanker:getCharacterName()
  local lifeRankerGuild = lifeRanker:getGuildName()
  local lifeRankerIntroDesc = lifeRanker:getUserIntroduction()
  if listIdx <= 2 then
    rankIcon:SetShow(true)
    PaGlobal_LifeRanking_All:setRankIcon(rankIcon, listIdx)
    rankText:SetFontColor(PaGlobal_LifeRanking_All._rankFontColor[listIdx])
    nameText:SetFontColor(PaGlobal_LifeRanking_All._rankFontColor[listIdx])
    guildText:SetFontColor(PaGlobal_LifeRanking_All._rankFontColor[listIdx])
    gradeText:SetFontColor(PaGlobal_LifeRanking_All._rankFontColor[listIdx])
  else
    rankIcon:SetShow(false)
    rankText:SetFontColor(PaGlobal_LifeRanking_All._defaultFontColor)
    nameText:SetFontColor(PaGlobal_LifeRanking_All._defaultFontColor)
    guildText:SetFontColor(PaGlobal_LifeRanking_All._defaultFontColor)
    gradeText:SetFontColor(PaGlobal_LifeRanking_All._defaultFontColor)
  end
  if 0 == lifeRankerLv then
    return false
  end
  PaGlobal_LifeRanking_All._rankerData[listIdx] = {}
  PaGlobal_LifeRanking_All._rankerData[listIdx]._name = lifeRankerName
  PaGlobal_LifeRanking_All._rankerData[listIdx]._desc = lifeRankerIntroDesc
  rankText:SetShow(true)
  nameText:SetShow(true)
  guildText:SetShow(true)
  gradeText:SetShow(true)
  rankText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LIFERANKING_RANK", "listIdx", listIdx + 1))
  nameText:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  nameText:SetText(lifeRankerName .. "(" .. lifeRankerCharName .. ")")
  guildText:SetText(lifeRankerGuild)
  if PaGlobal_LifeRanking_All._selectedTabIdx <= 9 then
    if _ContentsGroup_isUsedNewCharacterInfo == false then
      gradeText:SetText(FGlobal_CraftLevel_Replace(lifeRankerLv, PaGlobal_LifeRanking_All._selectedTabIdx))
    else
      gradeText:SetText(FGlobal_UI_CharacterInfo_Basic_Global_CraftLevelReplace(lifeRankerLv, PaGlobal_LifeRanking_All._selectedTabIdx))
    end
  elseif 10 == PaGlobal_LifeRanking_All._selectedTabIdx then
    gradeText:SetShow(false)
  elseif 11 == PaGlobal_LifeRanking_All._selectedTabIdx then
    local levelFlot = PaGlobal_LifeRanking_All:LevelFlotFunc(lifeRanker)
    gradeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. " " .. tostring(lifeRankerLv) .. tostring(levelFlot))
  elseif 12 == PaGlobal_LifeRanking_All._selectedTabIdx then
    gradeText:SetText(lifeRankerLv)
  elseif 13 == PaGlobal_LifeRanking_All._selectedTabIdx then
    gradeText:SetText(lifeRankerLv)
  end
  button:addInputEvent("Mouse_LUp", "PaGlobal_LifeRanking_All:RankerWhisper( " .. listIdx .. " )")
  button:addInputEvent("Mouse_On", "PaGlobal_LifeRanking_All:Tooltip( " .. listIdx .. ")")
  button:addInputEvent("Mouse_Out", "PaGlobal_LifeRanking_All:Tooltip()")
end
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

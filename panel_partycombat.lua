Panel_MatchResult:SetShow(false)
Panel_MatchResult:SetDragEnable(false)
Panel_MatchResult:ActiveMouseEventEffect(true)
Panel_MatchResult:setGlassBackground(true)
local isContentsEnablePvp = ToClient_IsContentsGroupOpen("38")
local isContentsEnableRace = ToClient_IsContentsGroupOpen("41")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local returnTime = 0
local partyMemberCount, isLeader, registerState
local matchType = 0
local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
local regionName = regionInfo:getAreaName()
local matchInfo = {
  config = {
    sizeX = 170,
    sizeY = 75,
    bgX = 3,
    stateBGminiX = 1,
    stateBGminiY = 0,
    stateminiX = 1,
    stateminiY = 6
  }
}
local matchResult = {
  _Button_Close = UI.getChildControl(Panel_MatchResult, "Button_Close"),
  _Ace = UI.getChildControl(Panel_MatchResult, "Icon_Ace"),
  _Title = UI.getChildControl(Panel_MatchResult, "Text_Title"),
  _Result_Title_Back_Win = UI.getChildControl(Panel_MatchResult, "Result_Title_Back_Win"),
  _Result_Title_Back_Lose = UI.getChildControl(Panel_MatchResult, "Result_Title_Back_Lose"),
  _Line_Top_Win = UI.getChildControl(Panel_MatchResult, "Line_Top_Win"),
  _Line_Bottom_Win = UI.getChildControl(Panel_MatchResult, "Line_Bottom_Win"),
  _Line_Top_Lose = UI.getChildControl(Panel_MatchResult, "Line_Top_Lose"),
  _Line_Bottom_Lose = UI.getChildControl(Panel_MatchResult, "Line_Bottom_Lose"),
  _Back_Actor = UI.getChildControl(Panel_MatchResult, "Back_Actor"),
  _TotalPoint_Ali = UI.getChildControl(Panel_MatchResult, "TotalPoint_Ali"),
  _TotalPoint_Ene = UI.getChildControl(Panel_MatchResult, "TotalPoint_Ene"),
  _EndInfo_Sec = UI.getChildControl(Panel_MatchResult, "Text_EndInfo_Sec"),
  _Icon_Class = {
    [0] = UI.getChildControl(Panel_MatchResult, "Icon_Class_Ali_1"),
    [1] = UI.getChildControl(Panel_MatchResult, "Icon_Class_Ali_2"),
    [2] = UI.getChildControl(Panel_MatchResult, "Icon_Class_Ali_3"),
    [3] = UI.getChildControl(Panel_MatchResult, "Icon_Class_Ene_1"),
    [4] = UI.getChildControl(Panel_MatchResult, "Icon_Class_Ene_2"),
    [5] = UI.getChildControl(Panel_MatchResult, "Icon_Class_Ene_3")
  },
  _Name = {
    [0] = UI.getChildControl(Panel_MatchResult, "Text_Ali_Name_1"),
    [1] = UI.getChildControl(Panel_MatchResult, "Text_Ali_Name_2"),
    [2] = UI.getChildControl(Panel_MatchResult, "Text_Ali_Name_3"),
    [3] = UI.getChildControl(Panel_MatchResult, "Text_Ene_Name_1"),
    [4] = UI.getChildControl(Panel_MatchResult, "Text_Ene_Name_2"),
    [5] = UI.getChildControl(Panel_MatchResult, "Text_Ene_Name_3")
  },
  _Kill = {
    [0] = UI.getChildControl(Panel_MatchResult, "Text_Ali_Kill_1"),
    [1] = UI.getChildControl(Panel_MatchResult, "Text_Ali_Kill_2"),
    [2] = UI.getChildControl(Panel_MatchResult, "Text_Ali_Kill_3"),
    [3] = UI.getChildControl(Panel_MatchResult, "Text_Ene_Kill_1"),
    [4] = UI.getChildControl(Panel_MatchResult, "Text_Ene_Kill_2"),
    [5] = UI.getChildControl(Panel_MatchResult, "Text_Ene_Kill_3")
  },
  _Point = {
    [0] = UI.getChildControl(Panel_MatchResult, "Text_Ali_Point_1"),
    [1] = UI.getChildControl(Panel_MatchResult, "Text_Ali_Point_2"),
    [2] = UI.getChildControl(Panel_MatchResult, "Text_Ali_Point_3"),
    [3] = UI.getChildControl(Panel_MatchResult, "Text_Ene_Point_1"),
    [4] = UI.getChildControl(Panel_MatchResult, "Text_Ene_Point_2"),
    [5] = UI.getChildControl(Panel_MatchResult, "Text_Ene_Point_3")
  },
  _Icon_Kill = {
    [0] = UI.getChildControl(Panel_MatchResult, "Icon_Kill_Ali_1"),
    [1] = UI.getChildControl(Panel_MatchResult, "Icon_Kill_Ali_2"),
    [2] = UI.getChildControl(Panel_MatchResult, "Icon_Kill_Ali_3"),
    [3] = UI.getChildControl(Panel_MatchResult, "Icon_Kill_Ene_1"),
    [4] = UI.getChildControl(Panel_MatchResult, "Icon_Kill_Ene_2"),
    [5] = UI.getChildControl(Panel_MatchResult, "Icon_Kill_Ene_3")
  },
  _Icon_Point = {
    [0] = UI.getChildControl(Panel_MatchResult, "Icon_Point_Ali_1"),
    [1] = UI.getChildControl(Panel_MatchResult, "Icon_Point_Ali_2"),
    [2] = UI.getChildControl(Panel_MatchResult, "Icon_Point_Ali_3"),
    [3] = UI.getChildControl(Panel_MatchResult, "Icon_Point_Ene_1"),
    [4] = UI.getChildControl(Panel_MatchResult, "Icon_Point_Ene_2"),
    [5] = UI.getChildControl(Panel_MatchResult, "Icon_Point_Ene_3")
  },
  _acePosX = {
    [0] = 145,
    [1] = 145,
    [2] = 145,
    [3] = 438,
    [4] = 438,
    [5] = 438
  },
  _acePosY = {
    [0] = 132,
    [1] = 185,
    [2] = 238,
    [3] = 132,
    [4] = 185,
    [5] = 238
  },
  _selfBackPosX = 16,
  _selfBackPosY = {
    [0] = 143,
    [1] = 196,
    [2] = 249,
    [3] = 143,
    [4] = 196,
    [5] = 249
  }
}
function matchInfo:initControl()
  local panel
  if false == _ContentsGroup_RemasterUI_Party then
    panel = Panel_Party
  else
    panel = Panel_Widget_Party
  end
  matchInfo._Button_Info = UI.getChildControl(panel, "Match_Button_MatchInfo")
  matchInfo._Button_Combat = UI.getChildControl(panel, "Match_Button_Combat")
  matchInfo._BG = UI.getChildControl(panel, "Match_BG")
  matchInfo._Party_Icon = UI.getChildControl(panel, "Match_Party_Icon")
  matchInfo._Party_Text = UI.getChildControl(panel, "Match_Party_Text")
  matchInfo._Party_Value = UI.getChildControl(panel, "Match_Party_Value")
  matchInfo._Time_Icon = UI.getChildControl(panel, "Match_Time_Icon")
  matchInfo._RemainTime_Text = UI.getChildControl(panel, "Match_RemainTime_Text")
  matchInfo._RemainTime_Value = UI.getChildControl(panel, "Match_RemainTime_Value")
  matchInfo._State_BG = UI.getChildControl(panel, "Match_State_BG")
  matchInfo._State = UI.getChildControl(panel, "Match_State")
  matchInfo._RegStatus_Text = UI.getChildControl(panel, "Match_RegStatus_Text")
end
function matchInfo:init(isEnableChannel)
  matchInfo:setPosition()
  Party_MatchClose()
  matchInfo._Button_Info:SetEnable(true)
  matchInfo._Button_Info:SetIgnore(false)
  matchInfo._Button_Info:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_BUTTON_INFO"))
  if nil == isEnableChannel or true == isEnableChannel then
    matchInfo._Button_Info:SetFontColor(UI_color.C_FFE7E7E7)
    matchInfo._Button_Info:SetOverFontColor(UI_color.C_FFE7E7E7)
    matchInfo._Button_Info:SetMonoTone(false)
  elseif false == isEnableChannel then
    matchInfo._Button_Info:SetFontColor(UI_color.C_FFC4BEBE)
    matchInfo._Button_Info:SetOverFontColor(UI_color.C_FFC4BEBE)
    matchInfo._Button_Info:SetMonoTone(true)
  end
  if false == _ContentsGroup_RenewUI then
    Panel_RecentMemory:SetShow(false)
  end
end
function matchInfo:setPosition()
  local backBGY = matchInfo._Button_Info:GetPosY() + 30
  matchInfo._BG:SetSize(matchInfo.config.sizeX, matchInfo.config.sizeY)
  matchInfo._BG:SetPosX(matchInfo.config.bgX)
  matchInfo._BG:SetPosY(backBGY)
  matchInfo._Party_Icon:SetPosX(matchInfo.config.bgX + 6)
  matchInfo._Party_Icon:SetPosY(backBGY + 4)
  matchInfo._Party_Text:SetPosX(matchInfo.config.bgX + 31)
  matchInfo._Party_Text:SetPosY(backBGY + 6)
  matchInfo._Time_Icon:SetPosX(matchInfo.config.bgX + 4)
  matchInfo._Time_Icon:SetPosY(backBGY + 25)
  matchInfo._RemainTime_Text:SetPosX(matchInfo.config.bgX + 31)
  matchInfo._RemainTime_Text:SetPosY(backBGY + 26)
  matchInfo._Party_Value:SetPosX(matchInfo.config.bgX + 112)
  matchInfo._Party_Value:SetPosY(backBGY + 6)
  matchInfo._RemainTime_Value:SetPosX(matchInfo.config.bgX + 112)
  matchInfo._RemainTime_Value:SetPosY(backBGY + 26)
  matchInfo._Button_Combat:SetPosX(matchInfo.config.bgX + 109)
  matchInfo._Button_Combat:SetPosY(backBGY + 47)
  if isLeader then
    matchInfo._RegStatus_Text:SetPosX(matchInfo.config.bgX + 10)
    matchInfo._RegStatus_Text:SetPosY(backBGY + 49)
  else
    matchInfo._RegStatus_Text:SetPosX(matchInfo.config.bgX + 82)
    matchInfo._RegStatus_Text:SetPosY(backBGY + 48)
  end
end
function FromClient_UpdateMatchInfo(matchType, matchState)
  local messages = {
    main = "",
    sub = "",
    addMsg = ""
  }
  if CppEnums.MatchType.Pvp == matchType then
    if 0 == matchState then
      matchInfo:updateRegisterState()
    elseif -2 == matchState then
      messages = {
        main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_NAK_NOTEAM"),
        sub = "",
        addMsg = ""
      }
      matchInfo._Button_Info:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_BUTTON_INFO"))
      matchInfo._Button_Info:SetEnable(true)
      matchInfo._Button_Info:SetIgnore(false)
      matchInfo._Button_Info:SetFontColor(UI_color.C_FFE7E7E7)
      HandleClicked_MatchClose()
      matchInfo:updateRegisterState()
    elseif 1 == matchState then
      matchInfo._State:SetFontColor(UI_color.C_FFE7E7E7)
      matchInfo._Button_Info:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_BUTTON_INFO"))
      matchInfo._Button_Info:SetEnable(true)
      matchInfo._Button_Info:SetIgnore(false)
      matchInfo._Button_Info:SetFontColor(UI_color.C_FFE7E7E7)
    elseif 2 == matchState then
      messages = {
        main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_NAK_WAITWARP"),
        sub = "",
        addMsg = ""
      }
      matchInfo._State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_WAITWARP"))
      matchInfo._State:SetFontColor(UI_color.C_FF84FFF5)
      matchInfo._State:SetEnable(false)
      HandleClicked_MatchOpen(true)
    elseif 3 == matchState then
      messages = {
        main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_NAK_WAITFIGHT"),
        sub = "",
        addMsg = ""
      }
      matchInfo._State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_WAITFIGHT"))
      matchInfo._State:SetFontColor(UI_color.C_FFFF973A)
      matchInfo._State:SetEnable(false)
      matchInfo._Button_Info:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_BUTTON_WAITFIGHT"))
      matchInfo._Button_Info:SetEnable(false)
      matchInfo._Button_Info:SetIgnore(true)
      matchInfo._Button_Info:SetFontColor(UI_color.C_FFFF973A)
      HandleClicked_MatchOpen(true)
      if false == _ContentsGroup_RenewUI then
        Panel_RecentMemory:SetShow(false)
      end
    elseif 4 == matchState then
      messages = {
        main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_NAK_STARTFIGHT"),
        sub = "",
        addMsg = ""
      }
      matchInfo._State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_STARTFIGHT"))
      matchInfo._State:SetFontColor(UI_color.C_FFFF4B4B)
      matchInfo._State:SetEnable(false)
      matchInfo._Button_Info:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_BUTTON_STARTFIGHT"))
      matchInfo._Button_Info:SetEnable(false)
      matchInfo._Button_Info:SetIgnore(true)
      matchInfo._Button_Info:SetFontColor(UI_color.C_FFFF4B4B)
      HandleClicked_MatchOpen(true)
      if false == _ContentsGroup_RenewUI then
        Panel_RecentMemory:SetShow(false)
      end
    elseif 5 == matchState then
    end
    Proc_ShowMessage_Ack_For_RewardSelect(messages, 10, 31)
  elseif CppEnums.MatchType.Race == matchType then
    local messages = {
      main = "",
      sub = "",
      addMsg = ""
    }
    if 2 == matchState then
      messages = {
        main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHINFO_RACESTARTWAITING"),
        sub = "",
        addMsg = ""
      }
      Proc_ShowMessage_Ack_For_RewardSelect(messages, 10, 41)
    elseif 3 == matchState then
      messages = {
        main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHINFO_RACEREADY"),
        sub = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHINFO_WAITING"),
        addMsg = ""
      }
      Proc_ShowMessage_Ack_For_RewardSelect(messages, 10, 39)
    end
  end
end
function FromClient_MatchPvpResult(isWin)
  local messages = {
    main = "",
    sub = "",
    addMsg = ""
  }
  if isWin then
    messages = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHRESULT_NAK_WIN"),
      sub = "",
      addMsg = ""
    }
    matchResult._Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHRESULT_TITLE_WIN"))
    matchResult._Title:SetFontColor(UI_color.C_FFE7E7E7)
    matchInfo._Button_Info:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_WIN"))
    matchInfo._Button_Info:SetFontColor(UI_color.C_FF84FFF5)
    matchInfo._State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_WIN"))
    matchInfo._State:SetFontColor(UI_color.C_FF84FFF5)
  else
    messages = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHRESULT_NAK_LOOSE"),
      sub = "",
      addMsg = ""
    }
    matchResult._Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHRESULT_TITLE_LOOSE"))
    matchResult._Title:SetFontColor(UI_color.C_FFFF4B4B)
    matchInfo._Button_Info:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_LOOSE"))
    matchInfo._Button_Info:SetFontColor(UI_color.C_FFFF4B4B)
    matchInfo._State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_LOOSE"))
    matchInfo._State:SetFontColor(UI_color.C_FFFF4B4B)
  end
  Proc_ShowMessage_Ack_For_RewardSelect(messages, 10, 31)
  HandleClicked_MatchOpen(true)
  matchResult._Result_Title_Back_Win:SetShow(false)
  matchResult._Result_Title_Back_Lose:SetShow(false)
  matchResult._Line_Top_Win:SetShow(false)
  matchResult._Line_Bottom_Win:SetShow(false)
  matchResult._Line_Top_Lose:SetShow(false)
  matchResult._Line_Bottom_Lose:SetShow(false)
  local selfPlayerName = getSelfPlayer():getName()
  local resultCount = ToClient_PvPMatchResultCount()
  local totalPointAli = 0
  local totalPointEne = 0
  for countidx = 0, resultCount - 1 do
    local tempcountidx = countidx
    local pvpResultInfo = ToClient_PvPMatchResultAt(tempcountidx)
    local resultEmpty = pvpResultInfo:isEmpty()
    local resultName = pvpResultInfo:getName()
    local resultKillCount = pvpResultInfo:getKillCount()
    local resultVariedPoint = pvpResultInfo:getVariedPoint()
    local resultTotalPoint = pvpResultInfo:getTotalPoint()
    if not resultEmpty then
      if isWin then
        if 0 == countidx then
          tempcountidx = 3
        elseif 1 == countidx then
          tempcountidx = 4
        elseif 2 == countidx then
          tempcountidx = 5
        elseif 3 == countidx then
          tempcountidx = 0
        elseif 4 == countidx then
          tempcountidx = 1
        elseif 5 == countidx then
          tempcountidx = 2
        end
      end
      if tempcountidx <= 2 then
        totalPointAli = totalPointAli + resultVariedPoint
      elseif tempcountidx >= 3 then
        totalPointEne = totalPointEne + resultVariedPoint
      end
      matchResult._Name[tempcountidx]:SetText(resultName)
      matchResult._Kill[tempcountidx]:SetText(tostring(resultKillCount))
      matchResult._Point[tempcountidx]:SetText("+" .. tostring(resultVariedPoint) .. " (" .. tostring(resultTotalPoint) .. ")")
      matchResult._Name[tempcountidx]:SetShow(false)
      matchResult._Kill[tempcountidx]:SetShow(false)
      matchResult._Point[tempcountidx]:SetShow(false)
      matchResult._Icon_Kill[tempcountidx]:SetShow(false)
      matchResult._Icon_Point[tempcountidx]:SetShow(false)
      matchResult._Icon_Class[tempcountidx]:SetShow(false)
    else
      matchResult._Name[tempcountidx]:SetShow(false)
      matchResult._Kill[tempcountidx]:SetShow(false)
      matchResult._Point[tempcountidx]:SetShow(false)
      matchResult._Icon_Kill[tempcountidx]:SetShow(false)
      matchResult._Icon_Point[tempcountidx]:SetShow(false)
      matchResult._Icon_Class[tempcountidx]:SetShow(false)
    end
  end
  matchResult._TotalPoint_Ali:SetText(tostring(totalPointAli))
  matchResult._TotalPoint_Ene:SetText(tostring(totalPointEne))
  Panel_MatchResult:SetShow(false)
end
function HandleClicked_MatchOpen(compactInfo)
  matchInfo:setPosition()
  local backBGX = matchInfo.config.bgX
  local backBGY = matchInfo._Button_Info:GetPosY() + 30
  matchInfo._BG:SetPosX(backBGX)
  matchInfo._BG:SetPosY(backBGY)
  if compactInfo then
    matchInfo._State_BG:SetPosX(backBGX + matchInfo.config.stateBGminiX)
    matchInfo._State_BG:SetPosY(backBGY + matchInfo.config.stateBGminiY)
    matchInfo._State:SetPosX(backBGX + matchInfo.config.stateminiX)
    matchInfo._State:SetPosY(backBGY + matchInfo.config.stateminiY)
    matchInfo._State_BG:SetShow(false)
    matchInfo._State:SetShow(false)
    matchInfo._RegStatus_Text:SetShow(false)
    matchInfo._BG:SetShow(false)
    matchInfo._Party_Icon:SetShow(false)
    matchInfo._Party_Text:SetShow(false)
    matchInfo._Party_Value:SetShow(false)
    matchInfo._Time_Icon:SetShow(false)
    matchInfo._RemainTime_Text:SetShow(false)
    matchInfo._RemainTime_Value:SetShow(false)
    matchInfo._Button_Combat:SetShow(false)
    matchInfo._State_BG:SetIgnore(false)
  else
    matchInfo._State_BG:SetShow(false)
    matchInfo._State:SetShow(false)
    matchInfo._RegStatus_Text:SetShow(false)
    matchInfo._BG:SetShow(false)
    matchInfo._Party_Icon:SetShow(false)
    matchInfo._Party_Text:SetShow(false)
    matchInfo._Party_Value:SetShow(false)
    matchInfo._Time_Icon:SetShow(false)
    matchInfo._RemainTime_Text:SetShow(false)
    matchInfo._RemainTime_Value:SetShow(false)
    matchInfo._Button_Combat:SetShow(false)
    matchInfo._BG:SetIgnore(false)
  end
  FGlobal_PartyListUpdate()
end
function HandleClicked_MatchClose()
  matchInfo._BG:SetShow(false)
  matchInfo._State_BG:SetShow(false)
  matchInfo._State:SetShow(false)
  matchInfo._Party_Icon:SetShow(false)
  matchInfo._Party_Text:SetShow(false)
  matchInfo._Party_Value:SetShow(false)
  matchInfo._Time_Icon:SetShow(false)
  matchInfo._RemainTime_Text:SetShow(false)
  matchInfo._RemainTime_Value:SetShow(false)
  matchInfo._RegStatus_Text:SetShow(false)
  matchInfo._Button_Combat:SetShow(false)
  FGlobal_PartyListUpdate()
end
function Party_MatchClose()
  matchInfo._BG:SetShow(false)
  matchInfo._State_BG:SetShow(false)
  matchInfo._State:SetShow(false)
  matchInfo._Party_Icon:SetShow(false)
  matchInfo._Party_Text:SetShow(false)
  matchInfo._Party_Value:SetShow(false)
  matchInfo._Time_Icon:SetShow(false)
  matchInfo._RemainTime_Text:SetShow(false)
  matchInfo._RemainTime_Value:SetShow(false)
  matchInfo._RegStatus_Text:SetShow(false)
  matchInfo._Button_Combat:SetShow(false)
end
function HandleClicked_MatchResultClose()
  Panel_MatchResult:SetShow(false)
end
function matchInfo:RequestInfo()
  ToClient_RequestMatchInfo(matchType)
  matchInfo:setPosition()
  matchInfo:updateRegisterState()
end
function HandleClicked_RequestMatchInfoOpen()
  if matchInfo._BG:GetShow() then
    HandleClicked_MatchClose()
  else
    matchInfo:RequestInfo()
  end
end
function HandleClicked_RegisterMatch()
  if 0 < ToClient_GetMyTeamNoLocalWar() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_REGISTER_MATCH"))
    return
  end
  registerState = ToClient_IsRequestedPvP()
  if registerState == false then
    ToClient_RegisterPvPMatch()
  else
    ToClient_UnRequestMatchInfo()
  end
  matchInfo:RequestInfo()
end
function matchInfo:updateRegisterState()
  registerState = ToClient_IsRequestedPvP()
  if registerState then
    matchInfo._Button_Combat:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_BUTTON_COMBAT2"))
    matchInfo._Button_Combat:SetFontColor(UI_color.C_FFFF4B4B)
    matchInfo._Button_Combat:SetOverFontColor(UI_color.C_FFFF4B4B)
    matchInfo._Button_Info:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_BUTTON_INFO2"))
    matchInfo._Button_Info:SetFontColor(UI_color.C_FFFF4B4B)
    matchInfo._Button_Info:SetOverFontColor(UI_color.C_FFFF4B4B)
    matchInfo._RegStatus_Text:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_STATUS_REG2"))
    matchInfo._RegStatus_Text:SetFontColor(UI_color.C_FFFF4B4B)
  else
    matchInfo._Button_Combat:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_BUTTON_COMBAT"))
    matchInfo._Button_Combat:SetFontColor(UI_color.C_FFE7E7E7)
    matchInfo._Button_Combat:SetOverFontColor(UI_color.C_FFE7E7E7)
    matchInfo._Button_Info:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_BUTTON_INFO"))
    matchInfo._Button_Info:SetFontColor(UI_color.C_FFE7E7E7)
    matchInfo._Button_Info:SetOverFontColor(UI_color.C_FFE7E7E7)
    matchInfo._RegStatus_Text:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_STATUS_REG"))
    matchInfo._RegStatus_Text:SetFontColor(UI_color.C_FFC4BEBE)
  end
end
function FromClient_MatchInfo(matchType, isRegister, registerCount, remainedMinute, matchState, param1)
  matchInfo:updateRegisterState()
  if CppEnums.MatchType.Pvp == matchType then
    if isRegister then
      matchInfo._Party_Value:SetText(tostring(registerCount) .. PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_PARTY_VALUE"))
      matchInfo._RemainTime_Value:SetText(tostring(remainedMinute) .. PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_REMAINTIME_VALUE"))
      HandleClicked_MatchOpen()
    else
      matchInfo_ShowMessage_Ack(1)
    end
  elseif CppEnums.MatchType.Race == matchType then
    FGlobal_RaceInfo_Open(isRegister, registerCount, remainedMinute, matchState, param1)
  end
end
function FromClient_PvPRegisterComplete(matchType)
  if CppEnums.MatchType.Pvp == matchType then
    matchInfo_ShowMessage_Ack(2)
    matchInfo:updateRegisterState()
    ResponseParty_updatePartyList()
  elseif CppEnums.MatchType.Race == matchType then
    FGlobal_RaceInfo_MessageManager(0)
  end
end
function FromClient_PvPUnRegisterComplete(matchType)
  if CppEnums.MatchType.Pvp == matchType then
    matchInfo_ShowMessage_Ack(3)
    matchInfo:updateRegisterState()
  elseif CppEnums.MatchType.Race == matchType then
    FGlobal_RaceInfo_MessageManager(1)
  end
end
function matchInfoJoinBTSimpletooltips(isShow, contolNo)
  local name, desc, control
  if isShow == true then
    if 0 == contolNo then
      control = UI.getChildControl(Panel_Party, "Match_Button_MatchInfo")
      name = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_NAK_PVPMATCH_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_NAK_PVPMATCH_DESC")
    elseif 1 == contolNo then
      control = UI.getChildControl(Panel_Party, "Match_Button_Combat")
      name = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_TOOLTIPS_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_TOOLTIPS_DESC")
    elseif 2 == contolNo then
      control = UI.getChildControl(Panel_Party, "Match_State_BG")
      name = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_NAK_PVPMATCH_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_TOOLTIPS_TIMEINFO")
    end
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function matchResultTimeCount(deltaTime)
  returnTime = returnTime + deltaTime
  local totalTime = 60 - math.ceil(returnTime)
  matchResult._EndInfo_Sec:SetText(convertStringFromDatetime(toInt64(0, totalTime)))
  if returnTime > 60 then
    returnTime = 0
    HandleClicked_MatchResultClose()
  end
end
function FGlobal_UpdatePartyState(inPartyMemberCount, inisLeader)
  if nil == inPartyMemberCount or nil == inisLeader then
    return
  end
  if inPartyMemberCount ~= partyMemberCount or inisLeader ~= isLeader then
    partyMemberCount = inPartyMemberCount
    isLeader = inisLeader
    if partyMemberCount >= 4 and true == registerState then
      ToClient_UnRequestMatchInfo()
    end
    if matchInfo._BG:GetShow() then
      matchInfo._Button_Combat:SetShow(isLeader)
    end
    matchInfo:setPosition()
    matchInfo:updateRegisterState()
  end
end
function matchInfo:registEventHandler()
  matchInfo._Button_Info:addInputEvent("Mouse_On", "matchInfoJoinBTSimpletooltips( true, 0 )")
  matchInfo._Button_Info:setTooltipEventRegistFunc("matchInfoJoinBTSimpletooltips( true, 0 )")
  matchInfo._Button_Info:addInputEvent("Mouse_Out", "matchInfoJoinBTSimpletooltips( false )")
  matchInfo._Button_Combat:addInputEvent("Mouse_On", "matchInfoJoinBTSimpletooltips( true, 1 )")
  matchInfo._Button_Combat:setTooltipEventRegistFunc("matchInfoJoinBTSimpletooltips( true, 1 )")
  matchInfo._Button_Combat:addInputEvent("Mouse_Out", "matchInfoJoinBTSimpletooltips( false )")
  matchInfo._State_BG:addInputEvent("Mouse_On", "matchInfoJoinBTSimpletooltips( true, 2 )")
  matchInfo._State_BG:setTooltipEventRegistFunc("matchInfoJoinBTSimpletooltips( true, 2 )")
  matchInfo._State_BG:addInputEvent("Mouse_Out", "matchInfoJoinBTSimpletooltips( false )")
  matchInfo._Button_Info:addInputEvent("Mouse_LUp", "HandleClicked_RequestMatchInfoOpen()")
  matchInfo._BG:addInputEvent("Mouse_LUp", "HandleClicked_MatchClose()")
  matchInfo._Button_Combat:addInputEvent("Mouse_LUp", "HandleClicked_RegisterMatch()")
  matchResult._Button_Close:addInputEvent("Mouse_LUp", "HandleClicked_MatchResultClose()")
end
function matchInfo:registMessageHandler()
  registerEvent("FromClient_UpdateMatchInfo", "FromClient_UpdateMatchInfo")
  registerEvent("FromClient_MatchPvpResult", "FromClient_MatchPvpResult")
  registerEvent("FromClient_MatchInfo", "FromClient_MatchInfo")
  registerEvent("FromClient_PvPRegisterComplete", "FromClient_PvPRegisterComplete")
  registerEvent("FromClient_PvPUnRegisterComplete", "FromClient_PvPUnRegisterComplete")
  Panel_MatchResult:RegisterUpdateFunc("matchResultTimeCount")
end
function matchInfo_ShowMessage_Ack(showMsgType)
  if 0 == showMsgType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MSG_ONLYMAINCHANNEL"))
  elseif 1 == showMsgType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MSG_NOREGISTERINFO"))
  elseif 2 == showMsgType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MSG_REGISTERMATCH"))
  elseif 3 == showMsgType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MSG_UNREGISTERMATCH"))
  end
end
function isShow_PartyMatchBg()
  local sizeY = 0
  if matchInfo._BG:GetShow() then
    sizeY = matchInfo._BG:GetSizeY() + 10
  end
  return sizeY
end
matchInfo:initControl()
if isContentsEnablePvp then
  matchInfo:init()
  matchInfo:updateRegisterState()
  matchInfo:registEventHandler()
else
  Party_MatchClose()
end
if isContentsEnablePvp or isContentsEnableRace then
  matchInfo:registMessageHandler()
end

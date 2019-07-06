local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
local isLocalwarOpen = ToClient_IsContentsGroupOpen("43")
local _txt_LocalWarTime = UI.getChildControl(Panel_CompetitionGame_Team, "StaticText_TimeLine")
local _txt_CompetitionGameTeamA = UI.getChildControl(Panel_CompetitionGame_Team, "StaticText_TeamBlackDesert")
local _txt_CompetitionGameTeamB = UI.getChildControl(Panel_CompetitionGame_Team, "StaticText_TeamRedDesert")
local _txt_TeamA = UI.getChildControl(Panel_CompetitionGame_Team, "StaticText_MyTeamBlack")
local _txt_TeamB = UI.getChildControl(Panel_CompetitionGame_Team, "StaticText_MyTeamRed")
local _txt_ScoreTeamA = UI.getChildControl(Panel_CompetitionGame_Team, "StaticText_RoundScore_Black")
local _txt_ScoreTeamB = UI.getChildControl(Panel_CompetitionGame_Team, "StaticText_RoundScore_Red")
local _icon_TeamBlackBuff = UI.getChildControl(Panel_CompetitionGame_Team, "Static_BlackTeamBuff")
local _icon_TeamRedBuff = UI.getChildControl(Panel_CompetitionGame_Team, "Static_RedTeamBuff")
_icon_TeamBlackBuff:SetShow(false)
_icon_TeamRedBuff:SetShow(false)
local saveAScore = 0
local saveBScore = 0
local teamCheck = false
function CompetitionGameTeam_MyTeam_Init()
  local team = ""
  _txt_TeamA:SetShow(false)
  _txt_TeamB:SetShow(false)
  if 0 == ToClient_CompetitionMatchType() then
    if 1 == ToClient_GetMyTeamNo() then
      _txt_TeamA:SetShow(true)
    elseif 2 == ToClient_GetMyTeamNo() then
      _txt_TeamB:SetShow(true)
    end
  else
    Panel_CompetitionGame_Team:SetShow(false)
  end
end
function CompetitionGameTeam_Show()
  if 1 == ToClient_CompetitionMatchType() then
    CompetitionGameTeam_Hide()
    return
  end
  if not Panel_CompetitionGame_Team:GetShow() then
    Panel_CompetitionGame_Team:SetShow(true)
  else
    CompetitionGameTeam_Hide()
    return
  end
end
function CompetitionGameTeam_Hide()
  if Panel_CompetitionGame_Team:GetShow() then
    Panel_CompetitionGame_Team:GetShow(false)
  end
end
function FGlobal_CompetitionGameTeam_Show()
  if -2 == ToClient_GetMyTeamNo() then
    CompetitionGameTeam_Hide()
    return
  end
  saveAScore = 0
  saveBScore = 0
  CompetitionGameTeam_Show()
  CompetitionGameTeam_Update()
end
function CompetitionGameTeam_Update()
  local teamA = 0
  local teamB = 0
  local isTeam = ToClient_GetMyTeamNo()
  _txt_ScoreTeamA:SetShow(true)
  _txt_ScoreTeamB:SetShow(true)
  if 0 == ToClient_CompetitionMatchType() then
    teamA = ToClient_GetRoundTeamScore(1)
    teamB = ToClient_GetRoundTeamScore(2)
  else
    _txt_ScoreTeamA:SetShow(false)
    _txt_ScoreTeamB:SetShow(false)
  end
  if teamA > saveAScore then
    saveAScore = teamA
  end
  if teamB > saveBScore then
    saveBScore = teamB
  end
  local teamA_Info = ToClient_GetTeamListAt(0)
  local teamB_Info = ToClient_GetTeamListAt(1)
  local teamA_Name = ""
  local teamB_Name = ""
  if nil ~= teamA_Info and nil ~= teamB_Info then
    teamA_Name = teamA_Info:getTeamName()
    teamB_Name = teamB_Info:getTeamName()
  end
  if "" == teamA_Name or "" == teamB_Name then
    teamA_Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_A")
    teamB_Name = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_B")
  end
  _txt_CompetitionGameTeamA:SetText(teamA_Name)
  _txt_CompetitionGameTeamB:SetText(teamB_Name)
  _txt_ScoreTeamA:SetText(teamA)
  _txt_ScoreTeamB:SetText(teamB)
end
local saveLocalWarTime = 0
local delayTime = 1
local competitionGameDeltaTime = 0
function CompetitionGameTeam_TimeUpdate(deltaTime)
  competitionGameDeltaTime = competitionGameDeltaTime + deltaTime
  if delayTime <= competitionGameDeltaTime then
    local warTime = ToClient_CompetitionRemainMatchTime()
    if saveLocalWarTime > 0 and 0 == warTime then
      _txt_LocalWarTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_SOONFINISH"))
    end
    saveLocalWarTime = warTime
    if 0 == warTime then
      if 1 == ToClient_GetLocalwarState() then
        _txt_LocalWarTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_SOONFINISH"))
      end
      return
    end
    competitionGameDeltaTime = 0
    _txt_LocalWarTime:SetText(convertSecondsToClockTime(warTime))
  end
end
function FromClient_UpdateFightState(isFight)
  if nil == isFight or "" == isFight then
    return
  end
  CompetitionGameTeam_MyTeam_Init()
  if CppEnums.CompetitionFightState.eCompetitionFightState_Fight == isFight then
    local isShowTeamInfo = true
    if 1 == ToClient_CompetitionMatchType() then
      isShowTeamInfo = false
    end
    _txt_CompetitionGameTeamA:SetShow(isShowTeamInfo)
    _txt_CompetitionGameTeamB:SetShow(isShowTeamInfo)
    _txt_ScoreTeamA:SetShow(isShowTeamInfo)
    _txt_ScoreTeamB:SetShow(isShowTeamInfo)
    Panel_CompetitionGame_Team:SetShow(true)
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_FIGHTSTATE_START_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_FIGHTSTATE_START_SUB"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(message, 5, 56, false)
  elseif CppEnums.CompetitionFightState.eCompetitionFightState_Done == isFight then
    Panel_CompetitionGame_Team:SetShow(false)
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_FIGHTSTATE_STOP_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_FIGHTSTATE_STOP_SUB"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(message, 5, 57, false)
  else
    Panel_CompetitionGame_Team:SetShow(false)
  end
end
function CompetitionGameTeam_Repos()
  Panel_CompetitionGame_Team:SetPosX(getScreenSizeX() / 2 - Panel_CompetitionGame_Team:GetSizeX() / 2)
  Panel_CompetitionGame_Team:SetPosY(0)
end
function CompetitionGameTeam_Init()
  if -2 == ToClient_GetMyTeamNo() then
    CompetitionGameTeam_Hide()
    return
  end
end

local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
Panel_CompetitionTargetScoreSet:SetShow(false)
local competitionTargetScoreSet = {
  _txt_Title = UI.getChildControl(Panel_CompetitionTargetScoreSet, "StaticText_Title"),
  _btn_Set = UI.getChildControl(Panel_CompetitionTargetScoreSet, "Button_Apply"),
  _btn_Cancel = UI.getChildControl(Panel_CompetitionTargetScoreSet, "Button_Cancel"),
  _edit_TargetScore = UI.getChildControl(Panel_CompetitionTargetScoreSet, "Edit_TargetScore"),
  _txt_Desc = UI.getChildControl(Panel_CompetitionTargetScoreSet, "StaticText_Desc"),
  _changeOptionType = 0
}
function CompetitionTargetScoreSet_Init()
  local self = competitionTargetScoreSet
  self._edit_TargetScore:SetEditText("0")
  self._edit_TargetScore:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionTargetScoreSet_SettingTargetScore()")
  self._btn_Set:addInputEvent("Mouse_LUp", "CompetitionTargetScoreSet_Confirm()")
  self._btn_Cancel:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTargetScoreSet_Close()")
end
function HandleClicked_CompetitionTargetScoreSet_SettingTargetScore()
  local self = competitionTargetScoreSet
  local s64_maxNumber = 0
  if 0 == self._changeOptionType then
    s64_maxNumber = toInt64(0, 10)
  elseif 1 == self._changeOptionType then
    s64_maxNumber = toInt64(0, 3600)
  elseif 2 == self._changeOptionType then
    s64_maxNumber = toInt64(0, 65)
  elseif 3 == self._changeOptionType then
    s64_maxNumber = toInt64(0, 5)
  elseif 4 == self._changeOptionType then
    s64_maxNumber = toInt64(0, 60)
  end
  Panel_NumberPad_Show(true, s64_maxNumber, param, CompetitionTargetScoreSet_ConfirmFunction)
end
function CompetitionTargetScoreSet_ConfirmFunction(inputNumber, param)
  local self = competitionTargetScoreSet
  self._edit_TargetScore:SetEditText(Int64toInt32(inputNumber))
end
function CompetitionTargetScoreSet_Confirm()
  local self = competitionTargetScoreSet
  local score_s32 = self._edit_TargetScore:GetEditText()
  if nil == score_s32 or "" == score_s32 then
    return
  end
  if 0 == self._changeOptionType then
    FGlobal_CompetitionGameForHost_TargetScore(score_s32)
  elseif 1 == self._changeOptionType then
    FGlobal_CompetitionGameForHost_TimeLimit(score_s32)
  elseif 2 == self._changeOptionType then
    FGlobal_CompetitionGameForHost_LevelLimit(score_s32)
  elseif 3 == self._changeOptionType then
    FGlobal_CompetitionGameForHost_PartyMemberCount(score_s32)
  elseif 4 == self._changeOptionType then
    FGlobal_CompetitionGameForHost_MaxWaitTime(score_s32)
  end
  FGlobal_CompetitionTargetScoreSet_Close()
end
function FGlobal_CompetitionTargetScoreSet_Open(changeOptionType)
  local self = competitionTargetScoreSet
  Panel_CompetitionTargetScoreSet:SetShow(true)
  self._changeOptionType = changeOptionType
  if 0 == self._changeOptionType then
    self._txt_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TITLE_TARGETSCORE"))
    self._edit_TargetScore:SetEditText(ToClient_GetTargetScore())
  elseif 1 == self._changeOptionType then
    self._txt_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TITLE_TIMELIMIT"))
    self._edit_TargetScore:SetEditText(ToClient_CompetitionMatchTimeLimit())
  elseif 2 == self._changeOptionType then
    self._txt_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TITLE_LEVELLIMIT"))
    self._edit_TargetScore:SetEditText(ToClient_GetLevelLimit())
  elseif 3 == self._changeOptionType then
    self._txt_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TITLE_PARTYMEMBERCOUNT"))
    self._edit_TargetScore:SetEditText(ToClient_GetMaxPartyMemberCount())
  elseif 4 == self._changeOptionType then
    self._txt_Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_COMPETITIONGAME_WAITTIME_NUMBER"))
    self._edit_TargetScore:SetEditText(ToClient_GetMaxWaitTime())
  end
  self._txt_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONTARGETSCORESET_DESC"))
end
function FGlobal_CompetitionTargetScoreSet_Close()
  Panel_CompetitionTargetScoreSet:SetShow(false)
end
CompetitionTargetScoreSet_Init()

local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
Panel_CompetitionTeamSet:SetShow(false)
local competitionTeamSet = {
  _btn_Set = UI.getChildControl(Panel_CompetitionTeamSet, "Button_Apply"),
  _btn_Cancel = UI.getChildControl(Panel_CompetitionTeamSet, "Button_Cancel"),
  _edit_Name = UI.getChildControl(Panel_CompetitionTeamSet, "Edit_Nickname"),
  _txt_Desc = UI.getChildControl(Panel_CompetitionTeamSet, "StaticText_Desc"),
  _savedIdx = -1,
  _savedObserver = false
}
function CompetitionTeamSet_Init()
  local self = competitionTeamSet
  self._edit_Name:SetEditText("0")
  self._txt_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONTEAMSET_DESC"))
  self._edit_Name:addInputEvent("Mouse_LUp", "HandleClicked_CompetitionTeamSet_SettingTeamNo()")
  self._btn_Set:addInputEvent("Mouse_LUp", "CompetitionTeamSet_Confirm()")
  self._btn_Cancel:addInputEvent("Mouse_LUp", "FGlobal_CompetitionTeamSet_Close()")
end
function HandleClicked_CompetitionTeamSet_SettingTeamNo()
  local s64_maxNumber = toInt64(0, 2)
  Panel_NumberPad_Show(true, s64_maxNumber, param, CompetitionTeamSet_ConfirmFunction)
end
function CompetitionTeamSet_ConfirmFunction(inputNumber, param)
  local self = competitionTeamSet
  self._edit_Name:SetEditText(Int64toInt32(inputNumber))
end
function CompetitionTeamSet_Confirm()
  local self = competitionTeamSet
  local teamNo_s32 = self._edit_Name:GetEditText()
  if nil == teamNo_s32 or "" == teamNo_s32 then
    return
  end
  FGlobal_CompetitionGameForHost_ChangeTeam(teamNo_s32, self._savedIdx, self._savedObserver)
  FGlobal_CompetitionTeamSet_Close()
end
function FGlobal_CompetitionTeamSet_Open(idx, teamNo, isObserver)
  local self = competitionTeamSet
  self._savedIdx = idx
  self._savedObserver = isObserver
  Panel_CompetitionTeamSet:SetShow(true)
  self._edit_Name:SetEditText(teamNo)
end
function FGlobal_CompetitionTeamSet_Close()
  Panel_CompetitionTeamSet:SetShow(false)
end
CompetitionTeamSet_Init()

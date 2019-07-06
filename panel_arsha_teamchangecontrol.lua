local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
Panel_Arsha_TeamChangeControl:SetShow(false)
local arshaPvPTeamSet = {
  _btn_Set = UI.getChildControl(Panel_Arsha_TeamChangeControl, "Button_Apply"),
  _btn_Cancel = UI.getChildControl(Panel_Arsha_TeamChangeControl, "Button_Cancel"),
  _btn_SetTeamA = UI.getChildControl(Panel_Arsha_TeamChangeControl, "Radiobutton_SetTeamA"),
  _btn_SetTeamB = UI.getChildControl(Panel_Arsha_TeamChangeControl, "Radiobutton_SetTeamB"),
  _btn_SetTeamWait = UI.getChildControl(Panel_Arsha_TeamChangeControl, "Radiobutton_SetTeamWait"),
  _txt_Desc = UI.getChildControl(Panel_Arsha_TeamChangeControl, "StaticText_Desc"),
  _savedIdx = -1,
  _savedObserver = false
}
function ArshaPvP_TeamChangeControl_Init()
  local self = arshaPvPTeamSet
  self._txt_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._txt_Desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ARSHA_TEAMCHANGECONTROL_DESC"))
  self._btn_Set:addInputEvent("Mouse_LUp", "ArshaPvP_TeamChangeControl_Confirm()")
  self._btn_Cancel:addInputEvent("Mouse_LUp", "FGlobal_ArshaPvP_TeamChangeControl_Close()")
end
function ArshaPvP_TeamChangeControl_Confirm()
  local self = arshaPvPTeamSet
  local teamNo_s32 = 0
  if self._btn_SetTeamA:IsCheck() then
    teamNo_s32 = 1
  elseif self._btn_SetTeamB:IsCheck() then
    teamNo_s32 = 2
  elseif self._btn_SetTeamWait:IsCheck() then
    teamNo_s32 = 0
  end
  FGlobal_ArshaPvP_ChangeTeam(teamNo_s32, self._savedIdx, self._savedObserver)
  FGlobal_ArshaPvP_TeamChangeControl_Close()
end
function FGlobal_ArshaPvP_TeamChangeControl_Open(idx, userNo_Str, isObserver)
  local self = arshaPvPTeamSet
  self._savedIdx = userNo_Str
  self._savedObserver = isObserver
  Panel_Arsha_TeamChangeControl:SetShow(true)
  self._btn_SetTeamA:SetCheck(false)
  self._btn_SetTeamB:SetCheck(false)
  self._btn_SetTeamWait:SetCheck(true)
end
function FGlobal_ArshaPvP_TeamChangeControl_Close()
  Panel_Arsha_TeamChangeControl:SetShow(false)
end
ArshaPvP_TeamChangeControl_Init()

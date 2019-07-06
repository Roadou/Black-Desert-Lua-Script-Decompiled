local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
Panel_Window_ArshaTeamNameChange:SetShow(false)
local arshaTeamNameSet = {
  _txt_Edit_A = UI.getChildControl(Panel_Window_ArshaTeamNameChange, "Edit_TeamA_Name"),
  _txt_Edit_B = UI.getChildControl(Panel_Window_ArshaTeamNameChange, "Edit_TeamB_Name"),
  _btn_Change = UI.getChildControl(Panel_Window_ArshaTeamNameChange, "Button_Admin"),
  _btn_Close = UI.getChildControl(Panel_Window_ArshaTeamNameChange, "Button_Close"),
  txt_teamA = UI.getChildControl(Panel_Window_ArshaTeamNameChange, "StaticText_ATeam"),
  txt_teamB = UI.getChildControl(Panel_Window_ArshaTeamNameChange, "StaticText_BTeam")
}
function Panel_Window_TeamNameChangeControl_Init()
  local self = arshaTeamNameSet
  self._btn_Change:addInputEvent("Mouse_LUp", "ArshaPvP_TeamNameChangeControl_Confirm()")
  self._btn_Close:addInputEvent("Mouse_LUp", "FGlobal_TeamNameChangeControl_Close()")
  self.txt_teamA:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_A_TEAM"))
  self.txt_teamB:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_B_TEAM"))
end
function ArshaPvP_TeamNameChangeControl_Confirm()
  local self = arshaTeamNameSet
  local nameA = self._txt_Edit_A:GetEditText()
  local nameB = self._txt_Edit_B:GetEditText()
  ToClient_changeTeamName(nameA, nameB)
  local teamA_Info = ToClient_GetTeamListAt(0)
  local teamB_Info = ToClient_GetTeamListAt(1)
  if teamA_Info == nil or teamB_Info == nil then
    FGlobal_TeamNameChangeControl_Close()
    return
  end
  local teamA_Name = teamA_Info:getTeamName()
  local teamB_Name = teamB_Info:getTeamName()
  self._txt_Edit_A:SetEditText(teamA_Name)
  self._txt_Edit_B:SetEditText(teamB_Name)
  FGlobal_TeamNameChangeControl_Close()
end
function FGlobal_ArshaNameClearFocusEdit_A()
  ClearFocusEdit()
  CheckChattingInput()
end
function FGlobal_CheckArshaNameUiEdit_A(targetUI)
  local self = arshaTeamNameSet
  return nil ~= targetUI and targetUI:GetKey() == self._txt_Edit_A:GetKey()
end
function FGlobal_ArshaNameClearFocusEdit_B()
  ClearFocusEdit()
  CheckChattingInput()
end
function FGlobal_CheckArshaNameUiEdit_B(targetUI)
  local self = arshaTeamNameSet
  return nil ~= targetUI and targetUI:GetKey() == self._txt_Edit_B:GetKey()
end
function FGlobal_TeamNameChangeControl_Open()
  Panel_Window_ArshaTeamNameChange:SetShow(true)
end
function FGlobal_TeamNameChangeControl_Close()
  Panel_Window_ArshaTeamNameChange:SetShow(false)
end
Panel_Window_TeamNameChangeControl_Init()

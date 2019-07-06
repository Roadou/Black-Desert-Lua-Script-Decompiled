PaGlobal_Guild_OneOnOne_Request = {
  _ui = {
    _panel = Panel_Guild_OneOnOneRequest,
    _radio_RuleTitle = UI.getChildControl(Panel_Guild_OneOnOneRequest, "RadioButton_RuleTitle"),
    _radio_ResultTitle = UI.getChildControl(Panel_Guild_OneOnOneRequest, "RidioButton_ResultTitle"),
    _staticBG_RuleTitle = UI.getChildControl(Panel_Guild_OneOnOneRequest, "Static_RuleBg"),
    _staticBG_ResultTitle = UI.getChildControl(Panel_Guild_OneOnOneRequest, "Static_ResultBg"),
    _btnConfirm = UI.getChildControl(Panel_Guild_OneOnOneRequest, "Button_Confirm"),
    _btnCancel = UI.getChildControl(Panel_Guild_OneOnOneRequest, "Button_Cancel"),
    _staticText_DefenceGuildName = UI.getChildControl(Panel_Guild_OneOnOneRequest, "StaticText_GuildName"),
    _staticText_RequestDesc = UI.getChildControl(Panel_Guild_OneOnOneRequest, "StaticText_OneOnOneDesc")
  }
}
local animationTime = 0.3
local currentTime = 0
function FGlobal_Guild_OneOnOne_Request_UpdatePerFrame(deltaTime)
  if animationTime < currentTime then
    return
  end
  currentTime = currentTime + deltaTime
  local ui = PaGlobal_Guild_OneOnOne_Request._ui
  if ui._radio_RuleTitle:IsChecked() then
    PaGlobal_UpdateRectClipOnArea_Animation(ui._controlList, 1, 2, animationTime, currentTime)
  elseif ui._radio_ResultTitle:IsChecked() then
    PaGlobal_UpdateRectClipOnArea_Animation(ui._controlList, 2, 1, animationTime, currentTime)
  end
end
function PaGlobal_Guild_OneOnOne_Request:Open()
  local ui = self._ui
  Panel_Guild_OneOnOneRequest:SetShow(true)
  local guildName = ToClient_GetCurrentTerritoryOccupant_Name()
  if nil == guildName or "" == guildName then
    ui._staticText_DefenceGuildName:SetShow(false)
    ui._staticText_RequestDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUEST_DESC"))
    return
  end
  ui._staticText_DefenceGuildName:SetShow(true)
  ui._staticText_DefenceGuildName:SetText("[" .. guildName .. "]")
  if true == ToClient_IsCurrentTerritoryOccupant_Alliance() then
    ui._staticText_RequestDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTDESC_ALLIANCE"))
  else
    ui._staticText_RequestDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REQUESTDESC_GUILD"))
  end
end
function PaGlobal_Guild_OneOnOne_Request:Clear()
  self._ui._editPlayerName1:SetEditText("")
end
function PaGlobal_Guild_OneOnOne_Request:Close()
  Panel_Guild_OneOnOneRequest:SetShow(false)
end
function PaGlobal_Guild_OneOnOne_Request:Confirm()
  local ui = self._ui
  if __eGuildTeamBattleState_Requesting ~= ToClient_GetGuildTeamBattleState() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_NOTTIMEFORREQUEST"))
    return
  end
  local playerName1 = ui._editPlayerName1:GetEditText()
  local playerName2 = ui._editPlayerName2:GetEditText()
  ToClient_RequestGuildTeamBattle(playerName1, playerName2)
end
function PaGlobal_Guild_OneOnOne_Request:Cancel()
  self:Clear()
  self:Close()
end
function PaGlobal_Guild_OneOnOne_Request:ClearAnimation(radioIndex)
  currentTime = 0
end
function FromClient_Guild_OneOnOne_Request_Initialize()
  local ui = PaGlobal_Guild_OneOnOne_Request._ui
  local staticMainBg = UI.getChildControl(Panel_Guild_OneOnOneRequest, "Static_MainBg")
  ui._editPlayerName1 = UI.getChildControl(staticMainBg, "Edit_User_Name")
  ui._editPlayerName2 = UI.getChildControl(staticMainBg, "Edit_User_Name_2")
  local staticTextRule = UI.getChildControl(ui._staticBG_RuleTitle, "StaticText_RuleDesc")
  staticTextRule:SetSize(staticTextRule:GetSizeX(), staticTextRule:GetTextSizeY() + 20)
  ui._staticBG_RuleTitle:SetSize(ui._staticBG_RuleTitle:GetSizeX(), staticTextRule:GetSizeY())
  local staticTextResult = UI.getChildControl(ui._staticBG_ResultTitle, "StaticText_ResultDesc")
  staticTextResult:SetSize(staticTextResult:GetSizeX(), staticTextResult:GetTextSizeY() + 20)
  ui._staticBG_ResultTitle:SetSize(ui._staticBG_ResultTitle:GetSizeX(), staticTextResult:GetSizeY())
  ui._controlList = {
    {
      _desc = ui._staticBG_RuleTitle,
      _title = ui._radio_RuleTitle,
      _pos = 1
    },
    {
      _desc = ui._staticBG_ResultTitle,
      _title = ui._radio_ResultTitle,
      _pos = 0
    }
  }
  ui._btnConfirm:addInputEvent("Mouse_LUp", "PaGlobal_Guild_OneOnOne_Request:Confirm()")
  ui._btnCancel:addInputEvent("Mouse_LUp", "PaGlobal_Guild_OneOnOne_Request:Cancel()")
  ui._radio_RuleTitle:addInputEvent("Mouse_LUp", "PaGlobal_Guild_OneOnOne_Request:ClearAnimation(1)")
  ui._radio_ResultTitle:addInputEvent("Mouse_LUp", "PaGlobal_Guild_OneOnOne_Request:ClearAnimation(2)")
  ui._radio_RuleTitle:SetCheck(true)
end
function FGlobal_OpenGuildTeamBattle_RequestPanel_Open()
  if __eGuildTeamBattleState_Requesting ~= ToClient_GetGuildTeamBattleState() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoGuildTeamBattleNotTimeToPlay"))
    return
  end
  PaGlobal_Guild_OneOnOne_Request:Clear()
  PaGlobal_Guild_OneOnOne_Request:Open()
end
function FGlobal_GuildTeamBattle_CloseRequestPanel()
  PaGlobal_Guild_OneOnOne_Request:Clear()
  PaGlobal_Guild_OneOnOne_Request:Close()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_Guild_OneOnOne_Request_Initialize")
registerEvent("FromClient_OpenGuildTeamBattle_RequestPanel", "FGlobal_OpenGuildTeamBattle_RequestPanel_Open")
registerEvent("FromClient_GuildTeamBattle_RequestDone", "FGlobal_GuildTeamBattle_CloseRequestPanel")
Panel_Guild_OneOnOneRequest:RegisterUpdateFunc("FGlobal_Guild_OneOnOne_Request_UpdatePerFrame")

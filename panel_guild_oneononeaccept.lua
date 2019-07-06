PaGlobal_Guild_OneOnOne_Accept = {
  _ui = {
    _panel = Panel_Guild_OneOnOneAccept,
    _radio_RuleTitle = UI.getChildControl(Panel_Guild_OneOnOneAccept, "RadioButton_RuleTitle"),
    _radio_ResultTitle = UI.getChildControl(Panel_Guild_OneOnOneAccept, "RidioButton_ResultTitle"),
    _staticBG_RuleTitle = UI.getChildControl(Panel_Guild_OneOnOneAccept, "Static_RuleBg"),
    _staticBG_ResultTitle = UI.getChildControl(Panel_Guild_OneOnOneAccept, "Static_ResultBg"),
    _btnConfirm = UI.getChildControl(Panel_Guild_OneOnOneAccept, "Button_Confirm"),
    _btnCancel = UI.getChildControl(Panel_Guild_OneOnOneAccept, "Button_Cancel"),
    _staticText_LeftTime = UI.getChildControl(Panel_Guild_OneOnOneAccept, "StaticText_LeftTime"),
    _staticText_AttackGuildName = UI.getChildControl(Panel_Guild_OneOnOneAccept, "StaticText_GuildName"),
    _staticText_AcceptDesc = UI.getChildControl(Panel_Guild_OneOnOneAccept, "StaticText_OneOnOneDesc")
  }
}
local animationTime = 0.3
local currentTime = 0
function FGlobal_Guild_OneOnOne_Accept_UpdatePerFrame(deltaTime)
  if animationTime < currentTime then
    return
  end
  currentTime = currentTime + deltaTime
  local ui = PaGlobal_Guild_OneOnOne_Accept._ui
  if ui._radio_RuleTitle:IsChecked() then
    PaGlobal_UpdateRectClipOnArea_Animation(ui._controlList, 1, 2, animationTime, currentTime)
  elseif ui._radio_ResultTitle:IsChecked() then
    PaGlobal_UpdateRectClipOnArea_Animation(ui._controlList, 2, 1, animationTime, currentTime)
  end
end
function PaGlobal_Guild_OneOnOne_Accept:Open()
  local ui = self._ui
  Panel_Guild_OneOnOneAccept:SetShow(true)
  local attackTeamInfo = ToClient_GetGuildTeamBattleAttackTeam()
  if nil == attackTeamInfo then
    return
  end
  ui._staticText_AttackGuildName:SetText("[" .. attackTeamInfo:getTeamName() .. "]")
  if true == attackTeamInfo:isAlliance() then
    ui._staticText_AcceptDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ACCEPTDESC_ALLIANCE"))
  else
    ui._staticText_AcceptDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_ACCEPTDESC_GUILD"))
  end
end
function PaGlobal_Guild_OneOnOne_Accept:Close()
  Panel_Guild_OneOnOneAccept:SetShow(false)
end
function PaGlobal_Guild_OneOnOne_Accept:UpdateClock(remainSec)
  self._ui._staticText_LeftTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REMAINSEC", "sec", remainSec))
end
function PaGlobal_Guild_OneOnOne_Accept:Confirm()
  local ui = self._ui
  local playerName1 = ui._editPlayerName1:GetEditText()
  local playerName2 = ui._editPlayerName2:GetEditText()
  ToClient_AcceptGuildTeamBattle(playerName1, playerName2)
end
function PaGlobal_Guild_OneOnOne_Accept:Reject()
  ToClient_RejectGuildTeamBattle()
  Panel_Guild_OneOnOneAccept:SetShow(false)
end
function PaGlobal_Guild_OneOnOne_Accept:ClearAnimation(radioIndex)
  currentTime = 0
end
function FromClient_Guild_OneOnOne_Accept_Initialize()
  local ui = PaGlobal_Guild_OneOnOne_Accept._ui
  local staticMainBg = UI.getChildControl(Panel_Guild_OneOnOneAccept, "Static_MainBg")
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
  ui._btnConfirm:addInputEvent("Mouse_LUp", "PaGlobal_Guild_OneOnOne_Accept:Confirm()")
  ui._btnCancel:addInputEvent("Mouse_LUp", "PaGlobal_Guild_OneOnOne_Accept:Reject()")
  ui._radio_RuleTitle:addInputEvent("Mouse_LUp", "PaGlobal_Guild_OneOnOne_Accept:ClearAnimation(1)")
  ui._radio_ResultTitle:addInputEvent("Mouse_LUp", "PaGlobal_Guild_OneOnOne_Accept:ClearAnimation(2)")
  ui._radio_RuleTitle:SetCheck(true)
end
function FromClient_GuildTeamBattle_AcceptOpen()
  PaGlobal_Guild_OneOnOne_Accept:Open()
end
function FGlobal_GuildTeamBattle_CloseAcceptPanel(attackGuildNo, defenceGuildNo)
  PaGlobal_Guild_OneOnOne_Accept:Close()
end
function FGlobal_Update_Guild_OneOnOneAcceptTime(state, remainSec)
  if __eGuildTeamBattleState_Accepting ~= state then
    return
  end
  PaGlobal_Guild_OneOnOne_Accept:UpdateClock(remainSec)
end
function FGlobal_Close_GuildTeamBattleAcceptPanel()
  PaGlobal_Guild_OneOnOne_Accept:Close()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_REJECT_DONE"))
end
registerEvent("FromClient_luaLoadComplete", "FromClient_Guild_OneOnOne_Accept_Initialize")
registerEvent("FromClient_GuildTeamBattle_AcceptOpen", "FromClient_GuildTeamBattle_AcceptOpen")
registerEvent("FromClient_GuildTeamBattle_AcceptDone", "FGlobal_GuildTeamBattle_CloseAcceptPanel")
registerEvent("FromClient_UpdateGuildTeamBattleTime", "FGlobal_Update_Guild_OneOnOneAcceptTime")
registerEvent("FromClient_GuildTeamBattle_RejectDone", "FGlobal_Close_GuildTeamBattleAcceptPanel")
Panel_Guild_OneOnOneAccept:RegisterUpdateFunc("FGlobal_Guild_OneOnOne_Accept_UpdatePerFrame")

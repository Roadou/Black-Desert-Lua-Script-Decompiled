local _panel = Panel_Window_GuildRegistSoldier
local guildRegistSoldier = {
  _ui = {
    editName = UI.getChildControl(_panel, "Edit_Naming"),
    desc = UI.getChildControl(_panel, "StaticText_Desc"),
    btnYes = UI.getChildControl(_panel, "Button_Yes"),
    btnNo = UI.getChildControl(_panel, "Button_No")
  }
}
function guildRegistSoldier:init()
  self._ui.desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.desc:SetText(self._ui.desc:GetText())
end
function guildRegistSoldier:open()
  _panel:SetShow(true)
  self:setName()
end
function PaGlobalFunc_GuildRegistSoldier_Open()
  guildRegistSoldier:open()
end
function guildRegistSoldier:close()
  _panel:SetShow(false)
  ClearFocusEdit(self._ui.editName)
end
function PaGlobalFunc_GuildRegistSoldier_Close()
  guildRegistSoldier:close()
end
function guildRegistSoldier:setName()
  self._ui.editName:SetEditText("", false)
  SetFocusEdit(self._ui.editName)
end
function PaGlobalFunc_GuildRegistSoldier_SetName()
  guildRegistSoldier:setName()
end
function guildRegistSoldier:agreementSign()
  local familyName = self._ui.editName:GetEditText()
  if "" == familyName then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDGEGISTSOLDIER_NONAME_ALERT"))
    return
  end
  FGlobal_AgreementVolunteer_Master_Open(familyName)
  ClearFocusEdit(self._ui.editName)
  self:close()
end
function PaGlobalFunc_GuildRegistSoldier_AgreementSign()
  guildRegistSoldier:agreementSign()
end
function guildRegistSoldier:registerEvent()
  self._ui.editName:addInputEvent("Mouse_LUp", "PaGlobalFunc_GuildRegistSoldier_SetName()")
  self._ui.btnYes:addInputEvent("Mouse_LUp", "PaGlobalFunc_GuildRegistSoldier_AgreementSign()")
  self._ui.btnNo:addInputEvent("Mouse_LUp", "PaGlobalFunc_GuildRegistSoldier_Close()")
end
function FromClient_luaLoadComplete_GuildRegistSoldier()
  local self = guildRegistSoldier
  self:init()
  self:registerEvent()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_GuildRegistSoldier")

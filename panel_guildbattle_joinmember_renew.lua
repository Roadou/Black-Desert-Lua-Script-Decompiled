PaGlobal_GuildBattle_JoinMember = {
  _ui = {
    _staticInmyChannel = UI.getChildControl(Panel_GuildBattle_JoinMember, "Static_InMyChannelBG"),
    _textTitle = nil,
    _textDesc = nil
  }
}
function PaGlobal_GuildBattle_JoinMember:initialize()
  self._ui._textTitle = UI.getChildControl(self._ui._staticInmyChannel, "StaticText_Title")
  self._ui._textDesc = UI.getChildControl(self._ui._staticInmyChannel, "StaticText_Desc")
  self._ui._textTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_WAITING"))
end
function PaGlobal_GuildBattle_JoinMember:Update()
  if false == ToClient_isPersonalBattle() then
    Panel_GuildBattle_JoinMember:SetShow(false)
    return
  end
  if __eGuildBattleGameMode_Count == ToClient_GuildBattle_GetCurrentMode() then
    Panel_GuildBattle_JoinMember:SetShow(false)
    return
  end
  if 0 ~= ToClient_GuildBattle_GetCurrentState() then
    Panel_GuildBattle_JoinMember:SetShow(false)
    return
  else
    Panel_GuildBattle_JoinMember:SetShow(true)
  end
  local curChannelData = getCurrentChannelServerData()
  if nil == curChannelData then
    Panel_GuildBattle_JoinMember:SetShow(false)
    return
  end
  local inMyChannelName = getChannelName(curChannelData._worldNo, curChannelData._serverNo)
  self._ui._textDesc:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_OPENWAR_INMYCHANNEL", "inMyChannelName", inMyChannelName, "inCount", (ToClient_GetcurrentTotalJoinCount())))
end
function PaGlobal_GuildBattle_JoinMember:Show(isShow)
  Panel_GuildBattle_JoinMember:SetShow(isShow)
  if true == isShow then
    self:Update()
  end
end
function PaGlobal_GuildBattle_JoinMember:IsShow()
  return Panel_GuildBattle_JoinMember:GetShow()
end
function FromClient_UpdateGuildBattleJoinCount()
  if true == ToClient_isPersonalBattle() then
    PaGlobal_GuildBattle_JoinMember:Show(true)
  end
end
function FromClient_luaLoadComplete_GuildBattle_JoinMember()
  PaGlobal_GuildBattle_JoinMember:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_GuildBattle_JoinMember")
registerEvent("FromClient_UpdateGuildBattleJoinCount", "FromClient_UpdateGuildBattleJoinCount")

PaGlobal_GuildBattle_JoinMember = {
  _ui = {
    _staticInmyChannel = nil,
    _textTitle = nil,
    _textDesc = nil
  }
}
function PaGlobal_GuildBattle_JoinMember:initialize()
  if nil == Panel_GuildBattle_JoinMember then
    return
  end
  self._ui._staticInmyChannel = UI.getChildControl(Panel_GuildBattle_JoinMember, "Static_InMyChannelBG")
  self._ui._textTitle = UI.getChildControl(self._ui._staticInmyChannel, "StaticText_Title")
  self._ui._textDesc = UI.getChildControl(self._ui._staticInmyChannel, "StaticText_Desc")
  self._ui._textTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE_WAITING"))
end
function PaGlobal_GuildBattle_JoinMember:registMessageHandler()
  registerEvent("FromClient_UpdateGuildBattleJoinCount", "FromClient_UpdateGuildBattleJoinCount")
end
function PaGlobal_GuildBattle_JoinMember:Update()
  if nil == Panel_GuildBattle_JoinMember then
    return
  end
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
  if true == isShow then
    PaGlobal_GuildBattleJoinMember_CheckLoadUI()
    self:Update()
  else
    PaGlobal_GuildBattleJoinMember_CheckCloseUI()
  end
end
function PaGlobal_GuildBattle_JoinMember:IsShow()
  if nil == Panel_GuildBattle_JoinMember then
    return false
  end
  return Panel_GuildBattle_JoinMember:GetShow()
end
function FromClient_UpdateGuildBattleJoinCount()
  if true == ToClient_isPersonalBattle() then
    PaGlobal_GuildBattle_JoinMember:Show(true)
  end
end
function PaGlobal_GuildBattleJoinMember_CheckLoadUI()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_GuildBattle_JoinMember:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_GuildBattle_JoinMember.XML", "Panel_GuildBattle_JoinMember", Defines.UIGroup.PAGameUIGroup_Widget, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_GuildBattle_JoinMember = rv
    rv = nil
    PaGlobal_GuildBattleJoinMember_Init()
  end
  Panel_GuildBattle_JoinMember:SetShow(true)
end
function PaGlobal_GuildBattleJoinMember_CheckCloseUI()
  if false == PaGlobal_AgreementGuildMaster_GetShow() then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_GuildBattle_JoinMember:SetShow(false)
  else
    reqCloseUI(Panel_GuildBattle_JoinMember)
  end
end
function FromClient_luaLoadComplete_GuildBattle_JoinMember()
  PaGlobal_GuildBattleJoinMember_Init()
  PaGlobal_GuildBattle_JoinMember:registMessageHandler()
end
function PaGlobal_GuildBattleJoinMember_Init()
  PaGlobal_GuildBattle_JoinMember:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_GuildBattle_JoinMember")

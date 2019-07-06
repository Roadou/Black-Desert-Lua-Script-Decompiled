Panel_Guild_Ally:SetShow(false)
local Panel_GuildAlly_InfoBg = UI.getChildControl(Panel_Guild_Ally, "Static_InfoBg")
PaGlobal_GuildAlliance = {
  _ui = {
    _guildAllianceName = UI.getChildControl(Panel_GuildAlly_InfoBg, "StaticText_AllyNameValue"),
    _chairName = UI.getChildControl(Panel_GuildAlly_InfoBg, "StaticText_AllyLeaderValue"),
    _memberCount = UI.getChildControl(Panel_GuildAlly_InfoBg, "StaticText_MemberCountValue"),
    _guildList = {},
    _allianceMark = UI.getChildControl(Panel_GuildAlly_InfoBg, "Static_Ally_Icon"),
    _btnOpenOption = UI.getChildControl(Panel_GuildAlly_InfoBg, "Button_Change"),
    _allianceNotice = UI.getChildControl(Panel_Guild_Ally, "MultilineEdit_Notice"),
    _btnInitNotice = UI.getChildControl(Panel_Guild_Ally, "Button_Reset"),
    _btnSetNotice = UI.getChildControl(Panel_Guild_Ally, "Button_Notice"),
    _btnClose = UI.getChildControl(Panel_Guild_Ally, "Button_Close")
  },
  _optionUi = {
    _btnCancel = UI.getChildControl(Panel_Guild_AllyOption, "Button_Cancel"),
    _btnApply = UI.getChildControl(Panel_Guild_AllyOption, "Button_Admin")
  }
}
function PaGlobal_GuildAlliance:Initialize()
  for index = 0, 3 do
    self._ui._guildList[index] = UI.getChildControl(Panel_GuildAlly_InfoBg, "StaticText_AllyGuild_" .. tostring(index))
    self._ui._guildList[index]:SetShow(false)
  end
  self._ui._allianceNotice:SetMaxEditLine(10)
  self._ui._allianceNotice:SetMaxInput(200)
  self._ui._allianceNotice:addInputEvent("Mouse_LUp", "HandleClicked_AllianceNoticeEditSetFocus()")
  self._ui._btnClose:addInputEvent("Mouse_LUp", "PaGlobal_GuildAlliance:close()")
  self._ui._btnInitNotice:addInputEvent("Mouse_LUp", "PaGlobal_GuildAlliance:initNotice()")
  self._ui._btnSetNotice:addInputEvent("Mouse_LUp", "PaGlobal_GuildAlliance:setNotice()")
  self._ui._btnOpenOption:addInputEvent("Mouse_LUp", "PaGlobal_GuildAlliance:openOption()")
  self._ui._allianceMark:addInputEvent("Mouse_LUp", "PaGlobal_GuildAlliance:changeMark()")
end
function PaGlobal_GuildAlliance:initOption()
  self._optionUi._btnCancel:addInputEvent("Mouse_LUp", "PaGlobal_GuildAlliance:closeOption()")
  self._optionUi._btnApply:addInputEvent("Mouse_LUp", "PaGlobal_GuildAlliance:applyOption()")
end
function PaGlobal_GuildAlliance:UpdateGuildAllianceInfo()
  local guildAlliance = ToClient_GetMyGuildAllianceWrapper()
  if guildAlliance == nil then
    return
  end
  local allianceNo = guildAlliance:guildAllianceNo_s64()
  local allianceName = guildAlliance:getRepresentativeName()
  local chairName = guildAlliance:getGuildAllianceChairName()
  local memberCount = guildAlliance:getMemberCount()
  local memberUserCount = guildAlliance:getUserCount()
  local notice = guildAlliance:getNotice()
  local isSet = setGuildTextureByAllianceNo(allianceNo, self._ui._allianceMark)
  if false == isSet then
    self._ui._allianceMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui._allianceMark, 183, 1, 188, 6)
    self._ui._allianceMark:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui._allianceMark:setRenderTexture(self._ui._allianceMark:getBaseTexture())
  else
    self._ui._allianceMark:getBaseTexture():setUV(0, 0, 1, 1)
    self._ui._allianceMark:setRenderTexture(self._ui._allianceMark:getBaseTexture())
  end
  self._ui._guildAllianceName:SetText(allianceName)
  self._ui._chairName:SetText(chairName)
  self._ui._memberCount:SetText(tostring(memberUserCount) .. " / 100")
  for index = 0, memberCount - 1 do
    local member = guildAlliance:getMemberGuild(index)
    if member ~= nil then
      self._ui._guildList[index]:SetText(member:getName())
      self._ui._guildList[index]:SetShow(true)
    end
  end
  self._ui._allianceNotice:SetEnable(true)
  self._ui._allianceNotice:SetEditText(notice, false)
end
function FGlobal_GuildAllianceInfoOpen()
  local self = PaGlobal_GuildAlliance
  self:open()
end
function FGlobal_GuildAllianceInfoInit()
  local self = PaGlobal_GuildAlliance
  self:Initialize()
  self:initOption()
end
function HandleClicked_AllianceNoticeEditSetFocus()
  local self = PaGlobal_GuildAlliance
  SetFocusEdit(self._ui._allianceNotice)
  self._ui._allianceNotice:SetEditText(self._ui._allianceNotice:GetEditText(), true)
end
function PaGlobal_GuildAlliance:open()
  if not self:checkContentsGroup() then
    return
  end
  self:UpdateGuildAllianceInfo()
  Panel_Guild_Ally:SetShow(true)
end
function PaGlobal_GuildAlliance:close()
  Panel_Guild_Ally:SetShow(false)
  self:closeOption()
end
function PaGlobal_GuildAlliance:openOption()
  if not self:checkContentsGroup() then
    return
  end
  Panel_Guild_AllyOption:SetShow(true)
end
function PaGlobal_GuildAlliance:closeOption()
  Panel_Guild_AllyOption:SetShow(false)
end
function PaGlobal_GuildAlliance:applyOption()
end
function PaGlobal_GuildAlliance:changeMark()
  messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ADDMARK_MESSAGEBOX_TITLE"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ADDMARK_MESSAGEBOX_TEXT"),
    functionYes = PaGlobal_GuildAlliance.changeMarkContinue,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PA_UI_CONTROL_TYPE.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "top")
end
function PaGlobal_GuildAlliance:changeMarkContinue()
  guildMarkUpdate(true)
end
function FGlobal_GuildAllianceOnMarkChanged()
  local self = PaGlobal_GuildAlliance
  if self:isShowing() then
    self:UpdateGuildAllianceInfo()
  end
end
function PaGlobal_GuildAlliance:checkContentsGroup()
  return _ContentsGroup_guildAlliance
end
function PaGlobal_GuildAlliance:initNotice()
  ClearFocusEdit()
  ToClient_SetGuildAllianceNotice(tostring(" "))
end
function PaGlobal_GuildAlliance:setNotice()
  ClearFocusEdit()
  ToClient_SetGuildAllianceNotice(tostring(self._ui._allianceNotice:GetEditText()))
end
function PaGlobal_GuildAlliance:updateLimitMemberCount()
end
function PaGlobal_GuildAlliance:updateTaxConst()
end
function PaGlobal_GuildAlliance:isShowing()
  return Panel_Guild_Ally:GetShow()
end
function FGlobal_OnGuildAllianceUpdate()
  local self = PaGlobal_GuildAlliance
  if self:isShowing() then
    self:UpdateGuildAllianceInfo()
  end
end
registerEvent("FromClient_luaLoadComplete", "FGlobal_GuildAllianceInfoInit")
registerEvent("EventChangeGuildInfo", "FGlobal_GuildAllianceOnMarkChanged")
registerEvent("FromClient_GuildAllianceUpdate", "FGlobal_OnGuildAllianceUpdate")

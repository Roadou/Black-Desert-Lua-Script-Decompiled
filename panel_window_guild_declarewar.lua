local _panel = Panel_Window_Guild_WarDeclare
_panel:ignorePadSnapMoveToOtherPanel()
local WarDeclare = {
  _ui = {
    stc_CenterBg = UI.getChildControl(_panel, "Static_CenterBg"),
    stc_BottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  },
  _keyguide = {}
}
function WarDeclare:open()
  self._ui.txt_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  if CppEnums.GuildWarType.GuildWarType_Normal == ToClient_GetGuildWarType() then
    self._ui.txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_LETSWARHELP"))
  elseif CppEnums.GuildWarType.GuildWarType_Both == ToClient_GetGuildWarType() then
    self._ui.txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_LETSWARHELP_JP"))
  else
    self._ui.txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_LETSWARHELP"))
  end
  self._ui.edit_GuildName:SetEditText("", true)
  self._ui.stc_CenterBg:SetSize(self._ui.stc_CenterBg:GetSizeX(), self._ui.txt_Desc:GetTextSizeY() + 130)
  _panel:SetSize(_panel:GetSizeX(), self._ui.txt_Desc:GetTextSizeY() + 270)
  self._ui.stc_BottomBg:ComputePos()
  _panel:ComputePos()
  _panel:SetShow(true)
end
function WarDeclare:close()
  _panel:SetShow(false)
end
function WarDeclare:init()
  self._ui.edit_GuildName = UI.getChildControl(self._ui.stc_CenterBg, "Edit_GuildName")
  self._ui.edit_GuildName:SetMaxInput(getGameServiceTypeGuildNameLength())
  self._ui.txt_Desc = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_Desc")
  self._keyguide = {
    UI.getChildControl(self._ui.stc_BottomBg, "StaticText_X_ConsoleUI"),
    UI.getChildControl(self._ui.stc_BottomBg, "StaticText_A_ConsoleUI"),
    UI.getChildControl(self._ui.stc_BottomBg, "StaticText_B_ConsoleUI")
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguide, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 30)
  PaGlobal_registerPanelOnBlackBackground(_panel)
  self:registEvent()
end
function WarDeclare:registEvent()
  self._ui.edit_GuildName:setXboxVirtualKeyBoardEndEvent("PaGlobalFunc_WarDeclare_ClearFocusEdit")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "InputMLUp_WarDeclare_Confirm()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_WarDeclare_SetFocusEdit()")
end
function PaGlobalFunc_WarDeclare_Open()
  local self = WarDeclare
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : WarDeclare")
    return
  end
  self:open()
end
function PaGlobalFunc_WarDeclare_Close()
  local self = WarDeclare
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : WarDeclare")
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  self:close()
end
function PaGlobalFunc_WarDeclare_Init()
  local self = WarDeclare
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : WarDeclare")
    return
  end
  self:init()
end
function PaGlobalFunc_WarDeclare_SetFocusEdit()
  local self = WarDeclare
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : WarDeclare")
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  ClearFocusEdit()
  SetFocusEdit(self._ui.edit_GuildName)
  self._ui.edit_GuildName:SetEditText(self._ui.edit_GuildName:GetEditText(), true)
end
function PaGlobalFunc_WarDeclare_ClearFocusEdit(str)
  local self = WarDeclare
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : WarDeclare")
    return
  end
  self._ui.edit_GuildName:SetEditText(str, true)
  ClearFocusEdit()
  self._ui.stc_CharacterInfoBg:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_WarDeclare_SetFocusEdit()")
end
function InputMLUp_WarDeclare_Confirm()
  local self = WarDeclare
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : WarDeclare")
    return
  end
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local guildName = self._ui.edit_GuildName:GetEditText()
  local myGuildName = myGuildInfo:getName()
  local accumulateTax_s32 = Int64toInt32(myGuildInfo:getAccumulateTax())
  local accumulateCost_s32 = Int64toInt32(myGuildInfo:getAccumulateGuildHouseCost())
  local function close_function()
    self:close()
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  if accumulateTax_s32 > 0 or accumulateCost_s32 > 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_TAXFIRST"))
    ClearFocusEdit()
    close_function()
    return
  end
  if guildName == myGuildName then
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_LETSWARFAIL"),
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  elseif CppEnums.GuildWarType.GuildWarType_Both == ToClient_GetGuildWarType() then
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DECLAREWAR_DECREASEMONEY"),
      functionYes = PaGlobalFunc_WarDeclare_Confirm,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, nil, nil)
  else
    PaGlobalFunc_WarDeclare_Confirm()
  end
  ClearFocusEdit()
  close_function()
end
function PaGlobalFunc_WarDeclare_Confirm()
  local self = WarDeclare
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : WarDeclare")
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  local guildName = self._ui.edit_GuildName:GetEditText()
  ToClient_RequestDeclareGuildWar(0, guildName, false)
  self._ui.edit_GuildName:SetEditText("", true)
  self:close()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_WarDeclare_Init")

local _panel = Panel_Window_Guild_Introduction
_panel:ignorePadSnapMoveToOtherPanel()
local GuildIntro = {
  _ui = {
    txt_Title = UI.getChildControl(_panel, "StaticText_Title"),
    stc_CenterBg = UI.getChildControl(_panel, "Static_CenterBg"),
    stc_BottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  },
  _keyguide = {},
  _editTextType = {introduce = 1, notice = 2},
  _currentMaxInput = 0,
  _currentTextType = nil,
  _noticeMaxInputLimitString = nil,
  _introductionMaxInputLimitString = nil
}
function GuildIntro:open(editType)
  self._currentTextType = editType
  if self._editTextType.introduce == editType then
    self:updateIntroduce()
  elseif self._editTextType.notice == editType then
    self:updateNotice()
  end
  _panel:SetShow(true)
end
function GuildIntro:updateNotice()
  local guildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == guildInfo then
    self:close()
    return
  end
  self._currentMaxInput = 40
  self._ui.txt_Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_LIST_NOTICE_TITLE"))
  self._ui.txt_EditInfoTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_LIST_NOTICE_EDITBOX"))
  self._ui.edit_Text:SetMaxInput(40)
  self._ui.edit_Text:SetMaxEditLine(2)
  self._ui.edit_Text:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.edit_Text:SetPosY(self._ui.txt_EditInfoTitle:GetPosY() + self._ui.txt_EditInfoTitle:GetTextSizeY() + 10)
  local noticeStr = guildInfo:getGuildNotice()
  if "" == noticeStr then
    self._ui.edit_Text:SetEditText(self._noticeMaxInputLimitString)
  else
    self._ui.edit_Text:SetEditText(noticeStr)
  end
end
function GuildIntro:updateIntroduce()
  local guildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == guildInfo then
    self:close()
    return
  end
  self._currentMaxInput = 120
  self._ui.txt_Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_INTRODUCETITLE"))
  self._ui.txt_EditInfoTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDINTRODUCE_DESC"))
  self._ui.edit_Text:SetMaxInput(120)
  self._ui.edit_Text:SetMaxEditLine(10)
  self._ui.edit_Text:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.edit_Text:SetPosY(self._ui.txt_EditInfoTitle:GetPosY() + self._ui.txt_EditInfoTitle:GetTextSizeY() + 10)
  self._ui.edit_Text:SetEditText(guildInfo:getGuildIntrodution())
  local introduceStr = guildInfo:getGuildIntrodution()
  if "" == introduceStr then
    self._ui.edit_Text:SetEditText(self._introductionMaxInputLimitString)
  else
    self._ui.edit_Text:SetEditText(introduceStr)
  end
end
function GuildIntro:close(isConfirm)
  if false == isConfirm then
    _AudioPostEvent_SystemUiForXBOX(50, 3)
  end
  _panel:SetShow(false)
end
function GuildIntro:init()
  self._ui.txt_EditInfoTitle = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_GuildInfoTitle")
  self._ui.txt_EditInfoTitle:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.edit_Text = UI.getChildControl(self._ui.stc_CenterBg, "MultilineEdit_Introduce")
  self._keyguide = {
    UI.getChildControl(self._ui.stc_BottomBg, "StaticText_X_ConsoleUI"),
    UI.getChildControl(self._ui.stc_BottomBg, "StaticText_A_ConsoleUI"),
    UI.getChildControl(self._ui.stc_BottomBg, "StaticText_B_ConsoleUI")
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguide, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 30)
  self:initLimitString()
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "InputMLUp_GuildIntro_ConfirmEdit()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_GuildIntro_SetFocusEdit()")
  self._ui.edit_Text:setXboxVirtualKeyBoardEndEvent("PaGlobalFunc_GuildIntro_EndVirtualKeyboard")
  PaGlobal_registerPanelOnBlackBackground(_panel)
end
function GuildIntro:initLimitString()
  self._noticeMaxInputLimitString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDINFO_INPUT_EDITTEXT", "maxLength", 40)
  self._introductionMaxInputLimitString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDINFO_INPUT_EDITTEXT", "maxLength", 120)
end
function PaGlobalFunc_GuildIntro_OpenIntroduce()
  local self = GuildIntro
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildIntro")
    return
  end
  local textType = self._editTextType.introduce
  self:open(textType)
end
function PaGlobalFunc_GuildIntro_OpenNotice()
  local self = GuildIntro
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildIntro")
    return
  end
  local textType = self._editTextType.notice
  self:open(textType)
end
function PaGlobalFunc_GuildIntro_Close(isConfirm)
  local self = GuildIntro
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildIntro")
    return
  end
  if _panel:GetShow() then
    self:close(isConfirm)
  end
end
function PaGlobalFunc_GuildIntro_SetFocusEdit()
  local self = GuildIntro
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildIntro")
    return
  end
  local curEditText = self._ui.edit_Text:GetEditText()
  if self._noticeMaxInputLimitString == curEditText or self._introductionMaxInputLimitString == curEditText then
    self._ui.edit_Text:SetEditText("")
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  SetFocusEdit(self._ui.edit_Text)
end
function PaGlobalFunc_GuildIntro_EndFocusEdit()
  local self = GuildIntro
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildIntro")
    return
  end
  CheckChattingInput()
  ClearFocusEdit()
  self._ui.edit_Text:SetEditText(self._ui.edit_Text:GetEditText(), true)
end
function PaGlobalFunc_GuildIntro_EndVirtualKeyboard(str)
  local self = GuildIntro
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildIntro")
    return
  end
  if self._currentMaxInput < string.len(str) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrInputTooLong"))
    str = string.sub(str, 1, self._currentMaxInput)
  end
  ClearFocusEdit()
  self._ui.edit_Text:SetEditText(str, true)
end
function PaGlobalFunc_GuildIntro_CheckNoticeUiEdit(targetUI)
  local self = GuildIntro
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildIntro")
    return
  end
  return nil ~= targetUI and targetUI:GetKey() == self._ui.edit_Text:GetKey()
end
function InputMLUp_GuildIntro_ConfirmEdit()
  local self = GuildIntro
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildIntro")
    return
  end
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  if false == isGuildMaster and false == isGuildSubMaster then
    return
  end
  CheckChattingInput()
  ClearFocusEdit()
  if self._editTextType.introduce == self._currentTextType then
    ToClient_RequestSetIntrodution(tostring(self._ui.edit_Text:GetEditText()))
  elseif self._editTextType.notice == self._currentTextType then
    ToClient_RequestSetGuildNotice(tostring(self._ui.edit_Text:GetEditText()))
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  self:close(true)
end
function PaGlobalFunc_GuildIntro_Init()
  local self = GuildIntro
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildIntro")
    return
  end
  self:init()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_GuildIntro_Init")

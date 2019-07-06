local _panel = Panel_Window_ChangeName_Renew
local UIMode = Defines.UIMode
local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
_panel:SetShow(false, false)
_panel:setGlassBackground(true)
local changeName = {
  title = UI.getChildControl(_panel, "Static_Text_Title_Import"),
  desc = UI.getChildControl(_panel, "StaticText_1"),
  alert = UI.getChildControl(_panel, "StaticText_3"),
  defaultSizeY = 295
}
local _nameType
local changeNickname = {
  edit_Nickname = UI.getChildControl(_panel, "Edit_Nickname"),
  button_OK = UI.getChildControl(_panel, "Button_Apply_Import"),
  button_Cancel = UI.getChildControl(_panel, "Button_Cancel_Import")
}
function FromClient_luaLoadComplete_ChangeNameInit()
  changeNickname:init()
end
function changeNickname:init()
  UI.ASSERT(nil ~= self.edit_Nickname and "number" ~= type(self.edit_Nickname), "Edit_Nickname")
  UI.ASSERT(nil ~= self.button_OK and "number" ~= type(self.button_OK), "Button_Apply_Import")
  UI.ASSERT(nil ~= self.button_Cancel and "number" ~= type(self.button_Cancel), "Button_Cancel_Import")
  changeName.desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  changeName.alert:SetTextMode(UI_TM.eTextMode_AutoWrap)
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_ChangeName_Edit()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "Input_ChangeName_Change()")
  local keyGuideBG = UI.getChildControl(_panel, "Static_BottomArea")
  txt_keyGuideConfirm = UI.getChildControl(keyGuideBG, "StaticText_Confirm_ConsoleUI")
  txt_keyGuideCancel = UI.getChildControl(keyGuideBG, "StaticText_Cancel_ConsoleUI")
  PaGlobalFunc_ConsoleKeyGuide_SetAlign({txt_keyGuideConfirm, txt_keyGuideCancel}, keyGuideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self.edit_Nickname:setXboxVirtualKeyBoardEndEvent("Input_ChangeName_KeyboardEnd")
  registerEvent("FromClient_ShowChangeNickname", "FromClient_ShowChangeNickname")
  registerEvent("FromClient_ChangeName", "FromClient_ChangeName")
end
function Input_ChangeName_Edit()
  if not _panel:GetShow() then
    return
  end
  local self = changeNickname
  self.edit_Nickname:SetMaxInput(getGameServiceTypeUserNickNameLength())
  SetFocusEdit(self.edit_Nickname)
end
function Input_ChangeName_Change()
  local self = changeNickname
  local name = self.edit_Nickname:GetEditText()
  local maxLength = getGameServiceTypeUserNickNameLength()
  if maxLength < string.len(name) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoNameLengthIsTooLong"))
    ChangeNickname_Close()
    return
  end
  local function toClient_ChangeName()
    if 0 == _nameType then
      ToClient_RequestChangeCharacterName(name)
    elseif 1 == _nameType then
      ToClient_RequestChangeGuildName(name)
    elseif 2 == _nameType then
      ToClient_ChangeNickName(name)
    end
    ChangeNickname_Close()
  end
  local changeType = ""
  if 0 == _nameType then
    changeType = PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_10")
  elseif 1 == _nameType then
    changeType = PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_11")
  elseif 2 == _nameType then
    changeType = PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_12")
  end
  local messageBoxMemo = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NAMECHANGE_13", "changeType", changeType, "name", name)
  local messageBoxData = {
    title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NAMECHANGE_14", "changeType", changeType),
    content = messageBoxMemo,
    functionYes = toClient_ChangeName,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function Input_ChangeName_KeyboardEnd(str)
  local self = changeNickname
  self.edit_Nickname:SetEditText(str)
  ClearFocusEdit()
end
function FromClient_ChangeName()
  if 2 == _nameType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_15"))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_1"))
  end
end
function FromClient_ShowChangeNickname(param)
  if _panel:GetShow() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_2"))
    return
  end
  _nameType = param
  local self = changeName
  if 0 == _nameType then
    self.title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_3"))
    self.desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_4"))
    self.alert:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_5"))
  elseif 1 == _nameType then
    local isGuildMaster = getSelfPlayer():get():isGuildMaster()
    if not isGuildMaster then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_6"))
      return
    end
    self.title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_7"))
    self.desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_8"))
    self.alert:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_9"))
  elseif 2 == _nameType then
    self.title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "UI_CHANGE_NICKNAME_TITLE"))
    self.desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NICKNAME_NOTIFY_1"))
    self.alert:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NICKNAME_NOTIFY_3"))
  end
  self.alert:SetTextSpan(0, (self.alert:GetSizeY() - self.alert:GetTextSizeY()) * 0.5)
  self:PanelResize_ByFontSize(_nameType)
  _panel:SetShow(true)
  changeNickname.edit_Nickname:SetEditText("")
  changeNickname.edit_Nickname:SetMaxInput(getGameServiceTypeUserNickNameLength())
  PaGlobalFunc_InventoryInfo_Close()
end
function ChangeNickname_Close()
  local self = changeNickname
  self.edit_Nickname:SetEditText("")
  if _panel:GetShow() then
    _panel:SetShow(false)
    ClearFocusEdit()
    CheckChattingInput()
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_ChangeNameInit")
function changeName:PanelResize_ByFontSize(_nameType)
end

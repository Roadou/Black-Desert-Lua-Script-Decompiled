local UIMode = Defines.UIMode
local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
Panel_ChangeNickname:SetShow(false, false)
Panel_ChangeNickname:setGlassBackground(true)
local changeName = {
  realPanelTitle = UI.getChildControl(Panel_ChangeNickname, "Static_PartLine"),
  panelSubBG = UI.getChildControl(Panel_ChangeNickname, "Static_SubFrame"),
  title = UI.getChildControl(Panel_ChangeNickname, "Static_Text_Title_Import"),
  desc = UI.getChildControl(Panel_ChangeNickname, "StaticText_1"),
  alert = UI.getChildControl(Panel_ChangeNickname, "StaticText_3"),
  defaultSizeY = 295
}
local _nameType
local changeNickname = {
  edit_Nickname = UI.getChildControl(Panel_ChangeNickname, "Edit_Nickname"),
  button_OK = UI.getChildControl(Panel_ChangeNickname, "Button_Apply_Import"),
  button_Cancel = UI.getChildControl(Panel_ChangeNickname, "Button_Cancel_Import")
}
function changeNickname:init()
  UI.ASSERT(nil ~= self.edit_Nickname and "number" ~= type(self.edit_Nickname), "Edit_Nickname")
  UI.ASSERT(nil ~= self.button_OK and "number" ~= type(self.button_OK), "Button_Apply_Import")
  UI.ASSERT(nil ~= self.button_Cancel and "number" ~= type(self.button_Cancel), "Button_Cancel_Import")
  changeName.desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  changeName.alert:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.button_OK:addInputEvent("Mouse_LUp", "handleClicked_ChangeNickname()")
  self.button_Cancel:addInputEvent("Mouse_LUp", "ChangeNickname_Close()")
  self.edit_Nickname:addInputEvent("Mouse_LUp", "handleClicked_ClickEdit()")
  registerEvent("FromClient_ShowChangeNickname", "FromClient_ShowChangeNickname")
  registerEvent("FromClient_ChangeName", "FromClient_ChangeName")
end
function handleClicked_ClickEdit()
  if not Panel_ChangeNickname:IsShow() then
    return
  end
  local self = changeNickname
  self.edit_Nickname:SetMaxInput(getGameServiceTypeUserNickNameLength())
  SetFocusEdit(self.edit_Nickname)
end
function handleClicked_ChangeNickname()
  local self = changeNickname
  local name = self.edit_Nickname:GetEditText()
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
function FromClient_ChangeName()
  if 2 == _nameType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_15"))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_1"))
  end
end
function FromClient_ShowChangeNickname(param)
  if Panel_ChangeNickname:GetShow() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_2"))
    return
  end
  _nameType = param
  local self = changeName
  if 0 == _nameType then
    self.title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_3"))
    self.desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_4"))
    local isNameChangeText = PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_5")
    if isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeTH() or isGameTypeRussia() or isGameTypeID() or isGameTypeTR() then
      isNameChangeText = PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_5") .. [[


<PAColor0xFFF26A6A>]] .. PAGetString(Defines.StringSheet_GAME, "LUA_MAKENAME_WARNING") .. "<PAOldColor>"
    else
      isNameChangeText = PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_5")
    end
    self.alert:SetText(isNameChangeText)
  elseif 1 == _nameType then
    local isGuildMaster = getSelfPlayer():get():isGuildMaster()
    if not isGuildMaster then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_6"))
      return
    end
    self.title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_7"))
    self.desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_8"))
    local isNameChangeText = PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_9")
    if isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeTH() or isGameTypeRussia() or isGameTypeID() or isGameTypeTR() then
      isNameChangeText = PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_9") .. [[


<PAColor0xFFF26A6A>]] .. PAGetString(Defines.StringSheet_GAME, "LUA_MAKENAME_WARNING") .. "<PAOldColor>"
    else
      isNameChangeText = PAGetString(Defines.StringSheet_GAME, "LUA_NAMECHANGE_9")
    end
    self.alert:SetText(isNameChangeText)
  elseif 2 == _nameType then
    self.title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "UI_CHANGE_NICKNAME_TITLE"))
    self.desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NICKNAME_NOTIFY_1"))
    local isNameChangeText = PAGetString(Defines.StringSheet_GAME, "LUA_NICKNAME_NOTIFY_3")
    if isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeTH() or isGameTypeRussia() or isGameTypeID() or isGameTypeTR() then
      isNameChangeText = PAGetString(Defines.StringSheet_GAME, "LUA_NICKNAME_NOTIFY_3") .. [[


<PAColor0xFFF26A6A>]] .. PAGetString(Defines.StringSheet_GAME, "LUA_MAKENAME_WARNING") .. "<PAOldColor>"
    else
      isNameChangeText = PAGetString(Defines.StringSheet_GAME, "LUA_NICKNAME_NOTIFY_3")
    end
    self.alert:SetText(isNameChangeText)
  end
  self:PanelResize_ByFontSize(_nameType)
  Panel_ChangeNickname:SetShow(true)
  changeNickname.edit_Nickname:SetEditText("")
  changeNickname.edit_Nickname:SetMaxInput(getGameServiceTypeUserNickNameLength())
  self.panelSubBG:SetSize(self.panelSubBG:GetSizeX(), self.desc:GetTextSizeY() + self.alert:GetTextSizeY() + 120)
  Panel_ChangeNickname:SetSize(Panel_ChangeNickname:GetSizeX(), self.realPanelTitle:GetSizeY() + self.desc:GetTextSizeY() + self.alert:GetTextSizeY() + 170)
  changeNickname.button_OK:ComputePos()
  changeNickname.button_Cancel:ComputePos()
  changeNickname.edit_Nickname:ComputePos()
  SetFocusEdit(changeNickname.edit_Nickname)
end
function ChangeNickname_Close()
  local self = changeNickname
  self.edit_Nickname:SetEditText("")
  if Panel_ChangeNickname:GetShow() then
    Panel_ChangeNickname:SetShow(false)
    ClearFocusEdit()
    CheckChattingInput()
  end
end
changeNickname:init()
function changeName:PanelResize_ByFontSize(_nameType)
  local basePosY = 140
  if 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() then
    self.alert:SetPosY(basePosY - 20)
  elseif 2 == _nameType then
    self.alert:SetPosY(basePosY + 5)
  else
    self.alert:SetPosY(basePosY)
  end
end

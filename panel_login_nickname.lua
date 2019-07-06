local UI_TM = CppEnums.TextMode
Panel_Login_Nickname:SetShow(false, false)
Panel_Login_Nickname:setGlassBackground(true)
local loginNickname = {
  edit_Nickname = UI.getChildControl(Panel_Login_Nickname, "Edit_Nickname"),
  button_OK = UI.getChildControl(Panel_Login_Nickname, "Button_Apply_Import"),
  desc1 = UI.getChildControl(Panel_Login_Nickname, "StaticText_1"),
  desc2 = UI.getChildControl(Panel_Login_Nickname, "StaticText_2"),
  desc3 = UI.getChildControl(Panel_Login_Nickname, "StaticText_3"),
  exam_Character = UI.getChildControl(Panel_Login_Nickname, "Static_Illust")
}
function loginNickname:init()
  UI.ASSERT(nil ~= self.edit_Nickname and "number" ~= type(self.edit_Nickname), "Edit_Nickname")
  UI.ASSERT(nil ~= self.button_OK and "number" ~= type(self.button_OK), "Button_Apply_Import")
  loginNickname.desc1:SetTextMode(UI_TM.eTextMode_AutoWrap)
  loginNickname.desc2:SetTextMode(UI_TM.eTextMode_AutoWrap)
  loginNickname.desc3:SetTextMode(UI_TM.eTextMode_AutoWrap)
  loginNickname.desc1:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NICKNAME_NOTIFY_1"))
  loginNickname.desc2:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NICKNAME_NOTIFY_2"))
  if isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeTH() or isGameTypeRussia() or isGameTypeID() or isGameTypeTR() then
    loginNickname.desc3:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NICKNAME_NOTIFY_3") .. [[


]] .. PAGetString(Defines.StringSheet_GAME, "LUA_MAKENAME_WARNING"))
  else
    loginNickname.desc3:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NICKNAME_NOTIFY_3"))
  end
  loginNickname.desc2:SetPosY(loginNickname.desc1:GetPosY() + loginNickname.desc1:GetTextSizeY() + 30)
  loginNickname.desc3:SetPosY(loginNickname.desc2:GetPosY() + loginNickname.desc2:GetTextSizeY() + 10)
  self.button_OK:addInputEvent("Mouse_LUp", "LoginNickname_OK()")
  self.edit_Nickname:RegistReturnKeyEvent("LoginNickname_OK()")
  registerEvent("EventCreateNickname", "LoginNickname_Open")
end
function LoginNickname_OK()
  ClearFocusEdit()
  local self = loginNickname
  lobbyNickname_createNickname(self.edit_Nickname:GetEditText())
end
function LoginNickname_OK_Callback()
  local self = loginNickname
  local createFamilyName = function()
    registerNickname()
  end
  local messageBoxContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LOGIN_NICKNAME_FIRSTCREATE", "name", self.edit_Nickname:GetEditText())
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxContent,
    functionYes = createFamilyName,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function LoginNickname_Cancel_End()
  disConnectToGame()
  GlobalExitGameClient()
end
function LoginNickname_Open()
  if Panel_Login_Nickname:GetShow() then
    return
  end
  local self = loginNickname
  self.edit_Nickname:SetEditText("")
  self.edit_Nickname:SetMaxInput(getGameServiceTypeUserNickNameLength())
  SetFocusEdit(self.edit_Nickname)
  Panel_Login_Nickname:SetSize(Panel_Login_Nickname:GetSizeX(), 185 + self.desc1:GetTextSizeY() + self.desc2:GetTextSizeY() + self.desc3:GetTextSizeY())
  Panel_Login_Nickname:SetShow(true)
  self.edit_Nickname:ComputePos()
  self.button_OK:ComputePos()
  self.exam_Character:ComputePos()
end
function LoginNickname_Close()
  local self = loginNickname
  self.edit_Nickname:SetEditText("")
  if Panel_Login_Nickname:GetShow() then
    Panel_Login_Nickname:SetShow(false)
  end
end
function FromClient_LoginNickName_OK_End()
  LoginNickname_OK_Callback()
end
function RegisterEvent()
  registerEvent("FromClient_LoginNickName_OK_End", "FromClient_LoginNickName_OK_End")
end
loginNickname:init()
RegisterEvent()

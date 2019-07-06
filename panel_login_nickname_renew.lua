local UI_TM = CppEnums.TextMode
local _panel = Panel_Login_Nickname_Renew
_panel:SetShow(false, false)
_panel:setGlassBackground(true)
local loginNickname = {
  edit_nickname = UI.getChildControl(_panel, "Edit_Nickname"),
  btn_apply = UI.getChildControl(_panel, "Button_Apply_Import"),
  stc_centerBG = UI.getChildControl(_panel, "Static_CenterBg"),
  stc_Image = UI.getChildControl(_panel, "Static_Image"),
  stc_descGroup = UI.getChildControl(_panel, "Static_DescGroup"),
  btn_Confirm = UI.getChildControl(_panel, "StaticText_ChangeName_ConsoleUI"),
  desc1 = nil,
  desc2 = nil,
  desc3 = nil,
  stc_sampleImage = UI.getChildControl(_panel, "Static_Illust")
}
function loginNickname:init()
  UI.ASSERT(nil ~= self.edit_nickname and "number" ~= type(self.edit_nickname), "Edit_Nickname")
  UI.ASSERT(nil ~= self.btn_apply and "number" ~= type(self.btn_apply), "Button_Apply_Import")
  loginNickname.desc1 = UI.getChildControl(loginNickname.stc_descGroup, "StaticText_1")
  loginNickname.desc2 = UI.getChildControl(loginNickname.stc_descGroup, "StaticText_2")
  loginNickname.desc3 = UI.getChildControl(loginNickname.stc_descGroup, "StaticText_3")
  loginNickname.desc1:SetTextMode(UI_TM.eTextMode_AutoWrap)
  loginNickname.desc2:SetTextMode(UI_TM.eTextMode_AutoWrap)
  loginNickname.desc3:SetTextMode(UI_TM.eTextMode_AutoWrap)
  loginNickname.desc1:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NICKNAME_NOTIFY_1"))
  loginNickname.desc2:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NICKNAME_NOTIFY_2"))
  loginNickname.desc3:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NICKNAME_NOTIFY_3"))
  loginNickname:setAlign()
  self.btn_apply:addInputEvent("Mouse_LUp", "LoginNickname_OK()")
  self.edit_nickname:setXboxVirtualKeyBoardEndEvent("Input_LoginNickname_KeyboardEnd")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_loginNickname_Edit()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "LoginNickname_OK()")
  registerEvent("EventCreateNickname", "LoginNickname_Open")
end
function loginNickname:setAlign()
  local gapSize = loginNickname.desc1:GetTextSizeY() + loginNickname.desc2:GetTextSizeY() + loginNickname.desc3:GetTextSizeY() - loginNickname.stc_descGroup:GetSizeY()
  _panel:SetSize(_panel:GetSizeX(), _panel:GetSizeY() + gapSize)
  loginNickname.stc_centerBG:SetSize(loginNickname.stc_centerBG:GetSizeX(), loginNickname.stc_centerBG:GetSizeY() + gapSize)
  loginNickname.stc_Image:SetPosY(loginNickname.stc_Image:GetPosY() + gapSize / 2)
  loginNickname.edit_nickname:SetPosY(loginNickname.edit_nickname:GetPosY() + gapSize)
  loginNickname.btn_Confirm:SetPosY(loginNickname.btn_Confirm:GetPosY() + gapSize)
  _panel:ComputePos()
  loginNickname.stc_centerBG:ComputePos()
end
function LoginNickname_OK()
  ClearFocusEdit()
  local self = loginNickname
  lobbyNickname_createNickname(self.edit_nickname:GetEditText())
end
function LoginNickname_OK_Callback()
  local self = loginNickname
  local createFamilyName = function()
    registerNickname()
    LoginNickname_Open(false)
  end
  local cancelFamilyName = function()
    LoginNickname_Open(false)
  end
  local messageBoxContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LOGIN_NICKNAME_FIRSTCREATE", "name", self.edit_nickname:GetEditText())
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxContent,
    functionYes = createFamilyName,
    functionNo = cancelFamilyName,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
  LoginNickname_Close(false)
end
function Input_loginNickname_Edit()
  SetFocusEdit(loginNickname.edit_nickname)
end
function Input_LoginNickname_KeyboardEnd(str)
  if getGameServiceTypeUserNickNameLength() < string.len(str) then
    str = string.sub(str, 1, getGameServiceTypeUserNickNameLength())
  end
  loginNickname.edit_nickname:SetEditText(str)
  ClearFocusEdit()
end
function LoginNickname_Cancel_End()
  disConnectToGame()
  GlobalExitGameClient()
end
function LoginNickname_Open(clearStr)
  if _panel:GetShow() then
    return
  end
  local self = loginNickname
  if nil == clearStr or true == clearStr then
    self.edit_nickname:SetEditText("")
  end
  self.edit_nickname:SetMaxInput(getGameServiceTypeUserNickNameLength())
  ClearFocusEdit()
  if nil == clearStr or true == clearStr then
    if true == ToClient_isPS4() then
      PaGlobalFunc_UserSetting_Open()
    else
      PaGlobal_ConsoleUIOffset_Open()
    end
  end
end
function PaGlobalFunc_LoginNickname_Open()
  if nil == _panel then
    return
  end
  if true == _panel:GetShow() then
    return
  end
  _panel:SetShow(true)
end
function LoginNickname_Close(clearStr)
  local self = loginNickname
  if nil == clearStr or true == clearStr then
    self.edit_nickname:SetEditText("")
  end
  if _panel:GetShow() then
    _panel:SetShow(false)
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

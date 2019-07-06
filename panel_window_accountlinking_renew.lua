local _panel = Panel_Window_AccountLinking_Renew
local UI_TM = CppEnums.TextMode
_panel:setGlassBackground(true)
local AccountLinking = {
  _ui = {
    edit_nickname = UI.getChildControl(_panel, "Edit_Nickname"),
    edit_password = UI.getChildControl(_panel, "Edit_Password"),
    txt_linkedID = UI.getChildControl(_panel, "StaticText_LinkedID"),
    btn_link = UI.getChildControl(_panel, "Button_Confirm"),
    btn_signup = UI.getChildControl(_panel, "Button_SignUp"),
    btn_unlink = UI.getChildControl(_panel, "Button_Unlink"),
    txt_descTop = UI.getChildControl(_panel, "Static_Text_LinkDescTop"),
    txt_descBottom = UI.getChildControl(_panel, "Static_Text_LinkDescBottom"),
    stc_highlight = UI.getChildControl(_panel, "Static_SnapHighlight"),
    stc_keyguideA = UI.getChildControl(_panel, "StaticText_KeyguideA")
  },
  _buttonType = {},
  _pw = "",
  _isPending = false
}
function FromClient_luaLoadComplete_AccountLinkingInit()
  AccountLinking:init()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_AccountLinkingInit")
function AccountLinking:init()
  self._ui.edit_nickname:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_AccountLinking_EditID()")
  self._ui.edit_nickname:addInputEvent("Mouse_On", "InputMOn_AccountLinking_EditID(true)")
  self._ui.edit_nickname:addInputEvent("Mouse_Out", "InputMOn_AccountLinking_EditID(false)")
  self._ui.edit_password:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_AccountLinking_EditPW()")
  self._ui.edit_password:addInputEvent("Mouse_On", "InputMOn_AccountLinking_EditPW(true)")
  self._ui.edit_password:addInputEvent("Mouse_Out", "InputMOn_AccountLinking_EditPW(false)")
  self._buttonType[1] = self._ui.btn_link
  self._buttonType[2] = self._ui.btn_signup
  self._buttonType[3] = self._ui.btn_unlink
  self._ui.btn_link:registerPadEvent(__eConsoleUIPadEvent_Up_A, "Input_AccountLinking_Link()")
  self._ui.btn_link:addInputEvent("Mouse_On", "InputMOn_AccountLinking_ToggleKeyguideA(true, 1)")
  self._ui.btn_link:addInputEvent("Mouse_Out", "InputMOn_AccountLinking_ToggleKeyguideA(false)")
  self._ui.btn_signup:registerPadEvent(__eConsoleUIPadEvent_Up_A, "Input_AccountLinking_SignUp()")
  self._ui.btn_signup:addInputEvent("Mouse_On", "InputMOn_AccountLinking_ToggleKeyguideA(true, 2)")
  self._ui.btn_signup:addInputEvent("Mouse_Out", "InputMOn_AccountLinking_ToggleKeyguideA(false)")
  self._ui.btn_unlink:registerPadEvent(__eConsoleUIPadEvent_Up_A, "Input_AccountLinking_Unlink()")
  self._ui.btn_unlink:addInputEvent("Mouse_On", "InputMOn_AccountLinking_ToggleKeyguideA(true, 3)")
  self._ui.btn_unlink:addInputEvent("Mouse_Out", "InputMOn_AccountLinking_ToggleKeyguideA(false)")
  self._ui.txt_descTop:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_descTop:SetText(self._ui.txt_descTop:GetText())
  self._ui.txt_descBottom:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_descBottom:SetText(self._ui.txt_descBottom:GetText())
  local keyGuideBG = UI.getChildControl(_panel, "Static_BottomArea")
  txt_keyGuideB = UI.getChildControl(keyGuideBG, "StaticText_KeyguideB")
  txt_keyGuideY = UI.getChildControl(keyGuideBG, "StaticText_KeyguideY")
  PaGlobalFunc_ConsoleKeyGuide_SetAlign({txt_keyGuideY, txt_keyGuideB}, keyGuideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobal_Policy_ShowWindow(false)")
  self._ui.edit_password:setXboxVirtualKeyBoardEndEvent("Input_AccountLinking_SetPW")
  registerEvent("FromClient_NotifyAccountLinkingResult", "FromClient_AccountLinking_NotifyAccountLinkingResult")
end
function PaGlobalFunc_AccountLinking_Open()
  AccountLinking:open()
end
function AccountLinking:open()
  _panel:SetShow(true)
  if PaGlobalFunc_Window_CharacterInfo_GetShow() then
    PaGlobalFunc_Window_CharacterInfo_Close()
  end
  self._pw = ""
  local id = ToClient_getXboxAccountLinkingId()
  if nil ~= id and "" ~= id then
    self._ui.txt_linkedID:SetShow(true)
    self._ui.txt_linkedID:SetText(id)
    self._ui.edit_nickname:SetShow(false)
    self._ui.edit_nickname:SetIgnore(true)
    self._ui.edit_nickname:setXboxVirtualKeyBoardEndEvent("")
    self._ui.btn_unlink:SetShow(true)
    self._ui.btn_signup:SetShow(false)
    self._ui.btn_link:SetShow(false)
  else
    self._ui.txt_linkedID:SetShow(false)
    self._ui.edit_nickname:SetShow(true)
    self._ui.edit_nickname:SetIgnore(false)
    self._ui.edit_nickname:setXboxVirtualKeyBoardEndEvent("Input_AccountLinking_SetID")
    self._ui.btn_unlink:SetShow(false)
    self._ui.btn_signup:SetShow(true)
    self._ui.btn_link:SetShow(true)
  end
end
function Input_AccountLinking_EditID()
  local self = AccountLinking
  SetFocusEdit(self._ui.edit_nickname)
end
function Input_AccountLinking_EditPW()
  local self = AccountLinking
  SetFocusEdit(self._ui.edit_password)
end
function InputMOn_AccountLinking_EditID(isOn)
  local self = AccountLinking
  if isOn then
    self._ui.stc_highlight:SetPosX(self._ui.edit_nickname:GetPosX() - 5)
    self._ui.stc_highlight:SetPosY(self._ui.edit_nickname:GetPosY() - 5)
    self._ui.stc_highlight:SetShow(true)
  else
    self._ui.stc_highlight:SetShow(false)
  end
end
function InputMOn_AccountLinking_EditPW(isOn)
  local self = AccountLinking
  if isOn then
    self._ui.stc_highlight:SetPosX(self._ui.edit_password:GetPosX() - 5)
    self._ui.stc_highlight:SetPosY(self._ui.edit_password:GetPosY() - 5)
    self._ui.stc_highlight:SetShow(true)
  else
    self._ui.stc_highlight:SetShow(false)
  end
end
function InputMOn_AccountLinking_ToggleKeyguideA(isOn, index)
  local self = AccountLinking
  local control = self._buttonType[index]
  if isOn then
    if nil ~= control then
      self._ui.stc_keyguideA:SetPosX(control:GetPosX() + control:GetSizeX() * 0.5 - self._ui.stc_keyguideA:GetSizeX() * 0.5)
      self._ui.stc_keyguideA:SetPosY(control:GetPosY() + control:GetSizeY())
      self._ui.stc_keyguideA:SetShow(true)
    end
  else
    self._ui.stc_keyguideA:SetShow(false)
  end
end
function Input_AccountLinking_Unlink()
  local self = AccountLinking
  local id = self._ui.txt_linkedID:GetText()
  local pw = self._pw
  if true == self._isPending then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_WAIT_PROCESS"))
    return
  end
  if nil == id or "" == id then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ACCOUNT_LINKING_NO_ID"))
    return
  end
  if nil == pw or "" == pw then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ACCOUNT_LINKING_NO_PW"))
    return
  end
  self._isPending = true
  ToClient_requestXboxAccountLinking(id, pw, false)
end
function Input_AccountLinking_Link()
  local self = AccountLinking
  local id = self._ui.edit_nickname:GetEditText()
  local pw = self._pw
  if true == self._isPending then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_WAIT_PROCESS"))
    return
  end
  if nil == id or "" == id then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ACCOUNT_LINKING_NO_ID"))
    return
  end
  if nil == pw or "" == pw then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ACCOUNT_LINKING_NO_PW"))
    return
  end
  self._isPending = true
  ToClient_requestXboxAccountLinking(id, pw, true)
end
function Input_AccountLinking_SignUp()
  local self = AccountLinking
  if true == self._isPending then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_WAIT_PROCESS"))
    return
  end
  ToClient_LaunchNativeWebBrowser(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ACCOUNT_LINKING_SIGNUP_NOTICE"))
end
function Input_AccountLinking_SetID(str)
  local self = AccountLinking
  if nil ~= str then
    self._ui.edit_nickname:SetEditText(str)
  end
  ClearFocusEdit()
end
function Input_AccountLinking_SetPW(str)
  local self = AccountLinking
  if nil ~= str then
    self._pw = str
  else
    self._pw = self._ui.edit_password:GetEditText()
  end
  local hiddenPW = ""
  local len = string.len(self._pw)
  for ii = 1, len do
    hiddenPW = hiddenPW .. "*"
  end
  self._ui.edit_password:SetEditText(hiddenPW)
  ClearFocusEdit()
end
function FromClient_AccountLinking_NotifyAccountLinkingResult(errMessage)
  local self = AccountLinking
  self._isPending = false
  if nil ~= errMessage and "" ~= errMessage then
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = errMessage,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
  PaGlobalFunc_AccountLinking_Close()
end
function PaGlobalFunc_AccountLinking_Close()
  local self = AccountLinking
  self._ui.edit_nickname:SetEditText("")
  self._ui.edit_password:SetEditText("")
  self._isPending = false
  ClearFocusEdit()
  if _panel:GetShow() then
    _panel:SetShow(false)
  end
end

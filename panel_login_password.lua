Panel_Login_Password:SetShow(false, false)
Panel_Login_Password:setGlassBackground(true)
local loginPassword = {
  config = {
    indexMax = 10,
    startX = 30,
    startY = 95,
    gapX = 70,
    gapY = 40,
    row = 2,
    column = 5
  },
  const = {
    type_CreatePassword = 0,
    type_Reconfirm = 1,
    type_Authentic = 2
  },
  Edit_Password = UI.getChildControl(Panel_Login_Password, "Edit_DisplayNumber"),
  StaticText_Title = UI.getChildControl(Panel_Login_Password, "Static_Text_Title_Import"),
  Button_Keypad_Back = UI.getChildControl(Panel_Login_Password, "Button_Back_Import"),
  Button_Keypad_Clear = UI.getChildControl(Panel_Login_Password, "Button_Clear_Import"),
  Button_Apply = UI.getChildControl(Panel_Login_Password, "Button_Apply_Import"),
  Button_Cancel = UI.getChildControl(Panel_Login_Password, "Button_Cancel_Import"),
  Check_PasswordView = UI.getChildControl(Panel_Login_Password, "CheckButton_NumberView"),
  BlockBG = UI.getChildControl(Panel_Login_Password, "Static_BlockBG"),
  indexs = Array.new(),
  state = 0,
  isChangeTexture = false
}
local UI_color = Defines.Color
function loginPassword:init()
  UI.ASSERT(nil ~= self.Edit_Password and "number" ~= type(self.Edit_Password), "Static_DisplayNumber_Import")
  UI.ASSERT(nil ~= self.Button_Keypad_Back and "number" ~= type(self.Button_KeyPad_Back), "Button_Back_Import")
  UI.ASSERT(nil ~= self.Button_Keypad_Clear and "number" ~= type(self.Button_KeyPad_Clea), "Button_Clear_Import")
  UI.ASSERT(nil ~= self.Button_Apply and "number" ~= type(self.Button_Apply), "Button_Apply_Import")
  UI.ASSERT(nil ~= self.Button_Cancel and "number" ~= type(self.Button_Cancel), "Button_Cancel_Import")
  UI.ASSERT(nil ~= self.StaticText_Title and "number" ~= type(self.StaticText_Title), "Static_Text_Title_Import")
  UI.ASSERT(nil ~= self.Check_PasswordView and "number" ~= type(self.Check_PasswordView), "CheckButton_NumberView")
  for ii = 0, self.config.indexMax - 1 do
    local index = {}
    index.index = ii
    index.button = UI.getChildControl(Panel_Login_Password, "Button_" .. ii .. "_Import")
    index.button:addInputEvent("Mouse_Out", "LoginPassword_ButtonMouseOut(" .. ii .. ")")
    index.button:addInputEvent("Mouse_LDown", "LoginPassword_ButtonBlind(" .. ii .. ")")
    index.button:addInputEvent("Mouse_LUp", "LoginPassword_Input(" .. ii .. ")")
    index.baseText = tostring(ii)
    UI.ASSERT(nil ~= index.button and "number" ~= type(index.button), "Button_" .. ii .. "_Import")
    self.indexs[ii] = index
  end
  self.Button_Keypad_Back:SetPosX(self.config.startX + self.config.gapX * (self.config.column - 2))
  self.Button_Keypad_Back:SetPosY(self.config.startY + self.config.gapY * self.config.row)
  self.Button_Keypad_Clear:SetPosX(self.config.startX + self.config.gapX * (self.config.column - 1))
  self.Button_Keypad_Clear:SetPosY(self.config.startY + self.config.gapY * self.config.row)
  self.Button_Keypad_Back:addInputEvent("Mouse_LUp", "LoginPassword_Input_Back()")
  self.Button_Keypad_Clear:addInputEvent("Mouse_LUp", "LoginPassword_Input_Clear()")
  self.Button_Apply:addInputEvent("Mouse_LUp", "LoginPassword_Enter()")
  self.Button_Cancel:addInputEvent("Mouse_LUp", "LoginPassword_Cancel()")
  self.Button_Apply:ActiveMouseEventEffect(true)
  self.Button_Cancel:ActiveMouseEventEffect(true)
  self.Check_PasswordView:addInputEvent("Mouse_LUp", "CheckButton_Sound()")
  self.Check_PasswordView:SetEnableArea(0, 0, self.Check_PasswordView:GetSizeX() + self.Check_PasswordView:GetTextSizeX() + 10, 25)
  self.BlockBG:SetSize(getScreenSizeX() + 500, getScreenSizeY() + 500)
  self.BlockBG:SetHorizonCenter()
  self.BlockBG:SetVerticalMiddle()
  self.BlockBG:ComputePos()
  registerEvent("EventOpenPassword", "LoginPassword_Open")
end
function LoginPassword_Open(isCreatePassword)
  LoginNickname_Close()
  if not lobbyPassword_UsePassword() then
    loginToGame()
    return
  end
  if isGameServiceTypeDev() and ToClient_UseConfigPassword() then
    loginToGame()
    return
  end
  lobbyPassword_ClearIndexString(true)
  lobbyPassword_ClearIndexString(false)
  local self = loginPassword
  local shuffleIndex = 0
  local posX = 0
  local posY = 0
  for ii = 0, self.config.indexMax - 1 do
    posX = self.config.startX + self.config.gapX * (ii % self.config.column)
    posY = self.config.startY + self.config.gapY * math.floor(ii / self.config.column)
    shuffleIndex = lobbyPassword_getShuffleIndex(ii)
    self.indexs[shuffleIndex].index = ii
    self.indexs[shuffleIndex].button:SetPosX(posX)
    self.indexs[shuffleIndex].button:SetPosY(posY)
  end
  self.Check_PasswordView:SetCheck(false)
  if isCreatePassword then
    self.state = self.const.type_CreatePassword
  else
    self.state = self.const.type_Authentic
  end
  if self.const.type_CreatePassword == self.state then
    self.StaticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "SECONDARYPASSWORD_CREATE"))
  elseif self.const.type_Authentic == self.state then
    self.StaticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "SECONDARYPASSWORD_INPUT"))
  end
  Panel_Login_ButtonDisable(true)
  LoginPassword_Update()
  if not Panel_Login_Password:GetShow() then
    Panel_Login_Password:SetShow(true)
    self.BlockBG:SetSize(getScreenSizeX() + 500, getScreenSizeY() + 500)
    self.BlockBG:SetHorizonCenter()
    self.BlockBG:SetVerticalMiddle()
  end
end
function LoginPassword_Close()
  lobbyPassword_ClearIndexString(true)
  lobbyPassword_ClearIndexString(false)
  if Panel_Login_Password:IsShow() then
    Panel_Login_Password:SetShow(false)
  end
  Panel_Login_ButtonDisable(false)
end
function LoginPassword_Enter()
  local self = loginPassword
  local isTemporary = self.const.type_Reconfirm == self.state
  if not lobbyPassword_checkPasswordLength(isTemporary) then
    return
  end
  if self.const.type_CreatePassword == self.state then
    self.state = self.const.type_Reconfirm
    self.StaticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "SECONDARYPASSWORD_IDENTIFY"))
    LoginPassword_Update()
    return
  end
  if self.const.type_Reconfirm == self.state and not lobbyPassword_isEqualPassword() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "SECONDARYPASSWORD_DIFFERENCE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "SECONDARYPASSWORD_NOTICE"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    LoginPassword_Open(true)
    return
  end
  loginToGame()
  LoginPassword_Close()
end
function LoginPassword_Cancel()
  if true == isGameServiceTypeDev() then
    lobbyPassword_ClearIndexString(true)
    lobbyPassword_ClearIndexString(false)
    Panel_Login_Password:SetShow(false)
  else
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "GAME_EXIT_MESSAGEBOX_MEMO")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "GAME_EXIT_MESSAGEBOX_TITLE"),
      content = messageBoxMemo,
      functionYes = LoginPassword_CancelEnd,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
  Panel_Login_ButtonDisable(false)
end
function LoginPassword_CancelEnd()
  disConnectToGame()
  GlobalExitGameClient()
end
function LoginPassword_ButtonBlind(index)
  local self = loginPassword
  for ii = 0, self.config.indexMax - 1 do
    self.indexs[ii].button:SetText("")
  end
  self.isChangeTexture = true
end
function LoginPassword_ButtonInit()
  local self = loginPassword
  for ii = 0, self.config.indexMax - 1 do
    self.indexs[ii].button:SetText(self.indexs[ii].baseText)
  end
  self.isChangeTexture = false
end
function LoginPassword_ButtonMouseOut(index)
  LoginPassword_ButtonInit()
end
function LoginPassword_Input(index)
  local self = loginPassword
  local isTemporary = self.const.type_Reconfirm == self.state
  local shuffleIndex = self.indexs[index].index
  LoginPassword_ButtonInit()
  lobbyPassword_AddIndexString(shuffleIndex, isTemporary)
  LoginPassword_Update()
end
function LoginPassword_Input_Back()
  local self = loginPassword
  local isTemporary = self.const.type_Reconfirm == self.state
  lobbyPassword_BackIndexString(isTemporary)
  LoginPassword_Update()
end
function LoginPassword_Input_Clear()
  local self = loginPassword
  local isTemporary = self.const.type_Reconfirm == self.state
  lobbyPassword_ClearIndexString(isTemporary)
  LoginPassword_Update()
end
function CheckButton_Sound()
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  LoginPassword_Update()
end
function LoginPassword_Update()
  local self = loginPassword
  local isTemporary = self.const.type_Reconfirm == self.state
  self.Edit_Password:SetText(lobbyPassword_GetIndexString(not self.Check_PasswordView:IsCheck(), isTemporary))
end
loginPassword:init()

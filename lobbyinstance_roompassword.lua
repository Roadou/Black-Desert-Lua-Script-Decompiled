local _panel = LobbyInstance_RoomPassword
_panel:SetShow(false, false)
_panel:setGlassBackground(true)
local roomPassword = {
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
  Button_Apply = UI.getChildControl(_panel, "Button_Apply_Import"),
  Button_Cancel = UI.getChildControl(_panel, "Button_Cancel_Import"),
  BlockBG = UI.getChildControl(_panel, "Static_BlockBG"),
  NoPadBG = UI.getChildControl(_panel, "Static_NoPadBG"),
  indexs = Array.new(),
  state = 0,
  isChangeTexture = false,
  _passwordEditBox = nil,
  _minPWCheck = 4,
  _maxPWCheck = 5
}
local UI_color = Defines.Color
function roomPassword:init()
  self.Button_Keypad_Back = UI.getChildControl(self.NoPadBG, "Button_Back_Import")
  self.Button_Keypad_Clear = UI.getChildControl(self.NoPadBG, "Button_Clear_Import")
  self.Check_PasswordView = UI.getChildControl(self.NoPadBG, "CheckButton_NumberView")
  UI.ASSERT(nil ~= self.Button_Keypad_Back and "number" ~= type(self.Button_KeyPad_Back), "Button_Back_Import")
  UI.ASSERT(nil ~= self.Button_Keypad_Clear and "number" ~= type(self.Button_KeyPad_Clear), "Button_Clear_Import")
  UI.ASSERT(nil ~= self.Button_Apply and "number" ~= type(self.Button_Apply), "Button_Apply_Import")
  UI.ASSERT(nil ~= self.Button_Cancel and "number" ~= type(self.Button_Cancel), "Button_Cancel_Import")
  UI.ASSERT(nil ~= self.Check_PasswordView and "number" ~= type(self.Check_PasswordView), "CheckButton_NumberView")
  for ii = 0, self.config.indexMax - 1 do
    local index = {}
    index.index = ii
    index.button = UI.getChildControl(self.NoPadBG, "Button_" .. ii .. "_Import")
    index.button:addInputEvent("Mouse_Out", "RoomPassword_ButtonMouseOut(" .. ii .. ")")
    index.button:addInputEvent("Mouse_LDown", "RoomPassword_ButtonBlind(" .. ii .. ")")
    index.button:addInputEvent("Mouse_LUp", "RoomPassword_Input(" .. ii .. ")")
    index.baseText = tostring(ii)
    UI.ASSERT(nil ~= index.button and "number" ~= type(index.button), "Button_" .. ii .. "_Import")
    index.button:ComputePos()
    self.indexs[ii] = index
  end
  self.Button_Apply:ActiveMouseEventEffect(true)
  self.Button_Cancel:ActiveMouseEventEffect(true)
  self.Check_PasswordView:SetEnableArea(0, 0, self.Check_PasswordView:GetSizeX() + self.Check_PasswordView:GetTextSizeX() + 10, 25)
  self.BlockBG:SetSize(getScreenSizeX() + 500, getScreenSizeY() + 500)
  self.BlockBG:SetHorizonCenter()
  self.BlockBG:SetVerticalMiddle()
  self.BlockBG:ComputePos()
  self:registEventHandler()
end
function roomPassword:registEventHandler()
  self.Button_Keypad_Back:addInputEvent("Mouse_LUp", "RoomPassword_Input_Back()")
  self.Button_Keypad_Clear:addInputEvent("Mouse_LUp", "RoomPassword_Input_Clear()")
  self.Button_Apply:addInputEvent("Mouse_LUp", "RoomPassword_Enter()")
  self.Button_Cancel:addInputEvent("Mouse_LUp", "RoomPassword_Cancel()")
  self.Check_PasswordView:addInputEvent("Mouse_LUp", "CheckButton_Sound()")
  self.BlockBG:addInputEvent("Mouse_LUp", "RoomPassword_Cancel()")
end
function RoomPassword_Open(passwordEditBox)
  local self = roomPassword
  self._passwordEditBox = passwordEditBox
  RoomPassword_Update()
  ClearFocusEdit()
  if not _panel:GetShow() then
    _panel:SetShow(true)
    self.BlockBG:SetSize(getScreenSizeX() + 500, getScreenSizeY() + 500)
    self.BlockBG:SetHorizonCenter()
    self.BlockBG:SetVerticalMiddle()
  end
end
function RoomPassword_Close()
  if _panel:IsShow() then
    local self = roomPassword
    _panel:SetShow(false)
    self._passwordEditBox = nil
  end
end
function RoomPassword_Enter()
  local self = roomPassword
  local password = self._passwordEditBox:GetEditText()
  if string.len(password) < self._minPWCheck then
    local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ROOM_TICKET_TITLE")
    local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ROOM_PW_MIN_DESC", "min", self._minPWCheck)
    local messageBoxData = {
      title = messageTitle,
      content = messageContent,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return false
  end
  RoomPassword_Close()
end
function RoomPassword_Cancel()
  _panel:SetShow(false)
end
function RoomPassword_ButtonBlind(index)
  local self = roomPassword
  for ii = 0, self.config.indexMax - 1 do
    self.indexs[ii].button:SetText("")
  end
  self.isChangeTexture = true
end
function RoomPassword_ButtonInit()
  local self = roomPassword
  for ii = 0, self.config.indexMax - 1 do
    self.indexs[ii].button:SetText(self.indexs[ii].baseText)
  end
  self.isChangeTexture = false
end
function RoomPassword_ButtonMouseOut(index)
  RoomPassword_ButtonInit()
end
function RoomPassword_Input(index)
  local self = roomPassword
  local getEditText = self._passwordEditBox:GetEditText()
  if self._maxPWCheck >= string.len(getEditText) then
    self._passwordEditBox:SetEditText(getEditText .. index)
  end
  RoomPassword_ButtonInit()
  RoomPassword_Update()
end
function RoomPassword_Input_Back()
  local self = roomPassword
  local getEditText = self._passwordEditBox:GetEditText()
  local textSize = string.len(getEditText)
  if textSize >= 1 then
    self._passwordEditBox:SetEditText(string.sub(getEditText, 1, textSize - 1))
  end
  RoomPassword_Update()
end
function RoomPassword_Input_Clear()
  local self = roomPassword
  self._passwordEditBox:SetEditText("")
  RoomPassword_Update()
end
function CheckButton_Sound()
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  RoomPassword_Update()
end
function RoomPassword_Update()
  local self = roomPassword
  local isTemporary = self.const.type_Reconfirm == self.state
  if nil ~= self._passwordEditBox then
    local posX, posY = PaGlobalFunc_RoomMessageBox_GetPasswordPos()
    _panel:SetPosX(posX)
    _panel:SetPosY(posY)
  end
end
function FromClient_RoomPassword_Init()
  local self = roomPassword
  self:init()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_RoomPassword_Init")

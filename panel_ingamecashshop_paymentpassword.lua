Panel_IngameCashShop_Password:SetShow(false, false)
Panel_IngameCashShop_Password:setGlassBackground(true)
local UI_color = Defines.Color
local paymentPassword = {
  _config = {
    indexMax = 10,
    startX = 30,
    startY = 95,
    gapX = 70,
    gapY = 40,
    row = 2,
    column = 5
  },
  _const = {
    type_CreatePassword = 0,
    type_Reconfirm = 1,
    type_Authentic = 2
  },
  _staticTextTitle = UI.getChildControl(Panel_IngameCashShop_Password, "Static_Text_Title_Import"),
  _editPassword = UI.getChildControl(Panel_IngameCashShop_Password, "Edit_DisplayNumber"),
  _checkPasswordView = UI.getChildControl(Panel_IngameCashShop_Password, "CheckButton_NumberView"),
  _buttonKeypadBack = UI.getChildControl(Panel_IngameCashShop_Password, "Button_Back_Import"),
  _buttonKeypadClear = UI.getChildControl(Panel_IngameCashShop_Password, "Button_Clear_Import"),
  _buttonApply = UI.getChildControl(Panel_IngameCashShop_Password, "Button_Apply_Import"),
  _buttonCancel = UI.getChildControl(Panel_IngameCashShop_Password, "Button_Cancel_Import"),
  BlockBG = UI.getChildControl(Panel_IngameCashShop_Password, "Static_BlockBG"),
  _staticText_Guide = UI.getChildControl(Panel_IngameCashShop_Password, "StaticText_Guide"),
  _indexs = Array.new(),
  _state = 0,
  _isChangeTexture = false,
  _function = nil
}
function paymentPassword:init()
  local config = self._config
  for ii = 0, config.indexMax - 1 do
    local index = {}
    index.index = ii
    index.button = UI.getChildControl(Panel_IngameCashShop_Password, "Button_" .. ii .. "_Import")
    index.button:addInputEvent("Mouse_Out", "PaymentPassword_ButtonMouseOut(" .. ii .. ")")
    index.button:addInputEvent("Mouse_LDown", "PaymentPassword_ButtonBlind(" .. ii .. ")")
    index.button:addInputEvent("Mouse_LUp", "PaymentPassword_Input(" .. ii .. ")")
    index.baseText = tostring(ii)
    self._indexs[ii] = index
  end
  self._buttonKeypadBack:SetPosX(config.startX + config.gapX * (config.column - 2))
  self._buttonKeypadBack:SetPosY(config.startY + config.gapY * config.row)
  self._buttonKeypadClear:SetPosX(config.startX + config.gapX * (config.column - 1))
  self._buttonKeypadClear:SetPosY(config.startY + config.gapY * config.row)
  self._checkPasswordView:SetEnableArea(0, 0, self._checkPasswordView:GetSizeX() + self._checkPasswordView:GetTextSizeX() + 10, 25)
  self._buttonApply:ActiveMouseEventEffect(true)
  self._buttonCancel:ActiveMouseEventEffect(true)
  self.BlockBG:SetSize(getScreenSizeX() + 500, getScreenSizeY() + 500)
  self.BlockBG:SetHorizonCenter()
  self.BlockBG:SetVerticalMiddle()
  self.BlockBG:ComputePos()
end
function paymentPassword:update()
  local isTemporary = self._const.type_Reconfirm == self._state
  local isBlind = not self._checkPasswordView:IsCheck()
  self._editPassword:SetText(lobbyPassword_GetIndexString(isBlind, isTemporary))
end
function paymentPassword:registEventHandler()
  self._checkPasswordView:addInputEvent("Mouse_LUp", "PaymentPassword_CheckButton()")
  self._buttonKeypadBack:addInputEvent("Mouse_LUp", "PaymentPassword_InputBack()")
  self._buttonKeypadClear:addInputEvent("Mouse_LUp", "PaymentPassword_InputClear()")
  self._buttonApply:addInputEvent("Mouse_LUp", "PayMentPassword_Confirm()")
  self._buttonCancel:addInputEvent("Mouse_LUp", "PaymentPassword_Close()")
end
function paymentPassword:registMessageHandler()
end
function PaymentPassword(contentsFunction)
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local isCreatePasword = selfPlayer:isPaymentPassword()
  local self = paymentPassword
  if not lobbyPassword_UsePassword() then
    contentsFunction()
    return
  end
  if isGameServiceTypeDev() and ToClient_UseConfigPassword() then
    contentsFunction()
    return
  end
  local isItemMarketRegist = contentsFunction == ItemMarketItemSet_RegistDo_FromPaymentPassword
  if not checkPaymentPassword() and true == isItemMarketRegist then
    contentsFunction()
    return
  end
  local title
  if isCreatePasword then
    self._state = self._const.type_CreatePassword
    title = PAGetString(Defines.StringSheet_GAME, "SECURITYPASSWORD_CREATE")
  else
    self._state = self._const.type_Authentic
    title = PAGetString(Defines.StringSheet_GAME, "SECURITYPASSWORD_INPUT")
  end
  self._checkPasswordView:SetCheck(false)
  self._staticTextTitle:SetText(title)
  lobbyPassword_ClearIndexString(true)
  lobbyPassword_ClearIndexString(false)
  local shuffleIndex = 0
  local posX = 0
  local posY = 0
  local config = self._config
  for ii = 0, config.indexMax - 1 do
    posX = config.startX + config.gapX * (ii % config.column)
    posY = config.startY + config.gapY * math.floor(ii / config.column)
    shuffleIndex = lobbyPassword_getShuffleIndex(ii)
    self._indexs[shuffleIndex].index = ii
    self._indexs[shuffleIndex].button:SetPosX(posX)
    self._indexs[shuffleIndex].button:SetPosY(posY)
  end
  self._function = contentsFunction
  self:update()
  PaymentPassword_Open()
end
function PaymentPassword_InputBack()
  local self = paymentPassword
  local isTemporary = self._const.type_Reconfirm == self._state
  lobbyPassword_BackIndexString(isTemporary)
  self:update()
end
function PaymentPassword_InputClear()
  local self = paymentPassword
  local isTemporary = self._const.type_Reconfirm == self._state
  lobbyPassword_ClearIndexString(isTemporary)
  self:update()
end
function PaymentPassword_CheckButton()
  local self = paymentPassword
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self:update()
end
function PaymentPassword_Input(index)
  local self = paymentPassword
  local isTemporary = self._const.type_Reconfirm == self._state
  local shuffleIndex = self._indexs[index].index
  lobbyPassword_AddIndexString(shuffleIndex, isTemporary)
  PaymentPassword_ButtonInit()
  self:update()
end
function PayMentPassword_Confirm()
  local self = paymentPassword
  local isTemporary = self._const.type_Reconfirm == self._state
  if not lobbyPassword_checkPasswordLength(isTemporary) then
    return
  end
  if self._const.type_CreatePassword == self._state then
    self._state = self._const.type_Reconfirm
    self._staticTextTitle:SetText(PAGetString(Defines.StringSheet_GAME, "SECURITYPASSWORD_IDENTIFY"))
    self:update()
    self._function = PaymentPassword_RegisterPayMent
    return
  elseif self._const.type_Reconfirm == self._state and not lobbyPassword_isEqualPassword() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "SECURITYPASSWORD_DIFFERENCE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "SECONDARYPASSWORD_NOTICE"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  self._function()
  self._function = nil
  PaymentPassword_Close()
end
function PaymentPassword_RegisterPayMent()
  registerPaymentPassword()
end
function PaymentPassword_ButtonInit()
  local self = paymentPassword
  for ii = 0, self._config.indexMax - 1 do
    self._indexs[ii].button:SetText(self._indexs[ii].baseText)
  end
end
function PaymentPassword_ButtonBlind(index)
  local self = paymentPassword
  for ii = 0, self._config.indexMax - 1 do
    self._indexs[ii].button:SetText("")
  end
end
function PaymentPassword_ButtonMouseOut(index)
  PaymentPassword_ButtonInit()
end
function PaymentPassword_Open()
  if Panel_IngameCashShop_Password:GetShow() then
    return
  end
  local self = paymentPassword
  Panel_IngameCashShop_Password:SetShow(true)
  self._staticText_Guide:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local beforeSizeY = self._staticText_Guide:GetTextSizeY()
  self._staticText_Guide:SetText(PAGetString(Defines.StringSheet_RESOURCE, "LUA_SECURITYPASSWORD_NOTIFY"))
  local sizeY = self._staticText_Guide:GetTextSizeY()
  if sizeY ~= beforeSizeY then
    Panel_IngameCashShop_Password:SetSize(Panel_IngameCashShop_Password:GetSizeX(), Panel_IngameCashShop_Password:GetSizeY() + 10)
    self._buttonApply:SetPosY(self._buttonApply:GetPosY() + 10)
    self._buttonCancel:SetPosY(self._buttonCancel:GetPosY() + 10)
  end
  self.BlockBG:SetSize(getScreenSizeX() + 500, getScreenSizeY() + 500)
  self.BlockBG:SetHorizonCenter()
  self.BlockBG:SetVerticalMiddle()
  self.BlockBG:ComputePos()
end
function PaymentPassword_Close()
  if not Panel_IngameCashShop_Password:GetShow() then
    return
  end
  Panel_IngameCashShop_Password:SetShow(false)
end
paymentPassword:init()
paymentPassword:registEventHandler()
paymentPassword:registMessageHandler()

Panel_ItemMarket_Password:SetShow(false)
PaGlobal_ItemMarketPassword = {
  _ui = {
    _staticTextTitle = UI.getChildControl(Panel_ItemMarket_Password, "Static_Text_Title_Import"),
    _editPassword = UI.getChildControl(Panel_ItemMarket_Password, "Edit_DisplayNumber"),
    _checkPasswordView = UI.getChildControl(Panel_ItemMarket_Password, "CheckButton_NumberView"),
    _buttonKeypadBack = UI.getChildControl(Panel_ItemMarket_Password, "Button_Back_Import"),
    _buttonKeypadClear = UI.getChildControl(Panel_ItemMarket_Password, "Button_Clear_Import"),
    _buttonApply = UI.getChildControl(Panel_ItemMarket_Password, "Button_Apply_Import"),
    _buttonCancel = UI.getChildControl(Panel_ItemMarket_Password, "Button_Cancel_Import"),
    BlockBG = UI.getChildControl(Panel_ItemMarket_Password, "Static_BlockBG")
  },
  _password = {},
  _const = {
    NonePassword = 0,
    CreatedPassword = 1,
    InputMode = 2
  },
  _state = 0,
  _maxPassward = 8,
  _minPassward = 6,
  _itemCount = 0
}
function PaGlobal_ItemMarketPassword:Init()
  for index = 1, 9 do
    UI.getChildControl(Panel_ItemMarket_Password, "Button_" .. index .. "_Import"):addInputEvent("Mouse_LUp", "PaGlobal_ItemMarketPassword:ClickedPassword( " .. index .. " )")
  end
  self._ui._checkPasswordView:addInputEvent("Mouse_LUp", "PaGlobal_ItemMarketPassword:ToggleViewPassword()")
  self._ui._buttonKeypadBack:addInputEvent("Mouse_LUp", "PaGlobal_ItemMarketPassword:ClickedPasswordDelete()")
  self._ui._buttonKeypadClear:addInputEvent("Mouse_LUp", "PaGlobal_ItemMarketPassword:ClickedPasswordClear()")
  self._ui._buttonApply:addInputEvent("Mouse_LUp", "PaGlobal_ItemMarketPassword:ClickedPasswordRegist()")
  self._ui._buttonCancel:addInputEvent("Mouse_LUp", "PaGlobal_ItemMarketPassword:ClickedCancel()")
  self._ui._checkPasswordView:SetEnableArea(0, 0, self._ui._checkPasswordView:GetSizeX() + self._ui._checkPasswordView:GetTextSizeX() + 10, 25)
  self._ui.BlockBG:SetShow(true)
  self._ui.BlockBG:SetSize(getScreenSizeX() + 500, getScreenSizeY() + 500)
  self._ui.BlockBG:SetHorizonCenter()
  self._ui.BlockBG:SetVerticalMiddle()
  self._ui.BlockBG:ComputePos()
end
function PaGlobal_ItemMarketPassword:ClickedCancel()
  if "" == self._ui._editPassword:GetEditText() then
    FGlobal_ItemMarketPassword_CanelPassword()
  end
  local password = tonumber(self._ui._editPassword:GetEditText())
  if nil == password then
    _PA_LOG("\237\155\132\236\167\132", "[PaGlobal_ItemMarketPassword] \237\140\168\236\138\164\236\155\140\235\147\156\236\151\144 \236\136\171\236\158\144\234\176\128 \236\149\132\235\139\140 \234\178\131\236\157\180 \236\158\136\236\138\181\235\139\136\235\139\164.")
    return
  end
  FGlobal_ItemMarketPassword_CanelPassword()
end
function FGlobal_ItemMarketPassword_CanelPassword()
  PaGlobal_ItemMarketPassword._ui._editPassword:SetEditText("")
  PaGlobal_ItemMarketPassword._state = PaGlobal_ItemMarketPassword._const.NonePassword
  Panel_ItemMarket_Password:SetShow(false)
end
function PaGlobal_ItemMarketPassword:ClickedPasswordRegist()
  local passwordString = self._ui._editPassword:GetEditText()
  local password = tonumber(passwordString)
  if nil == password then
    _PA_LOG("\237\155\132\236\167\132", "[PaGlobal_ItemMarketPassword] \237\140\168\236\138\164\236\155\140\235\147\156\236\151\144 \236\136\171\236\158\144\234\176\128 \236\149\132\235\139\140 \234\178\131\236\157\180 \236\158\136\236\138\181\235\139\136\235\139\164.  : " .. passwordString)
    return
  end
  if self._state == self._const.InputMode then
    FGlobal_ItemMarket_BuyWith_PrivatePasssword(tonumber(self._ui._editPassword:GetEditText()), self._itemCount)
    return
  end
  if self._maxPassward < string.len(passwordString) then
    return
  end
  if string.len(passwordString) < self._minPassward then
    return
  end
  local messageBoxMemo = "\237\152\132\236\158\172 \235\185\132\235\176\128\235\178\136\237\152\184\235\161\156 \235\172\188\237\146\136 \235\185\132\235\176\128\235\178\136\237\152\184 \236\132\164\236\160\149\237\149\152\236\139\156\234\178\160\236\138\181\235\139\136\234\185\140?"
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = FGlobal_ItemMarketPassword_ApplyPassword,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FGlobal_ItemMarketPassword_ApplyPassword()
  FGlobal_ItemMarketRegistItem_RegistPassword(tonumber(PaGlobal_ItemMarketPassword._ui._editPassword:GetEditText()))
  Panel_ItemMarket_Password:SetShow(false)
end
function PaGlobal_ItemMarketPassword:ClickedPasswordDelete()
  local password = tonumber(self._ui._editPassword:GetEditText())
  if nil == password then
    _PA_LOG("\237\155\132\236\167\132", "[PaGlobal_ItemMarketPassword] \237\140\168\236\138\164\236\155\140\235\147\156\236\151\144 \236\136\171\236\158\144\234\176\128 \236\149\132\235\139\140 \234\178\131\236\157\180 \236\158\136\236\138\181\235\139\136\235\139\164.")
    return
  end
  local deletePassword = math.floor(password * 0.1)
  if password < 10 then
    deletePassword = ""
  end
  self._ui._editPassword:SetEditText(deletePassword)
  self:update()
end
function PaGlobal_ItemMarketPassword:ClickedPasswordClear()
  self._ui._editPassword:SetEditText("")
  self:update()
end
function PaGlobal_ItemMarketPassword:ToggleViewPassword()
  self:update()
end
function PaGlobal_ItemMarketPassword:ClickedPassword(index)
  if 0 == index then
    return
  end
  local passwordString = self._ui._editPassword:GetEditText() .. tostring(index)
  local password = tonumber(passwordString)
  if nil == password then
    _PA_LOG("\237\155\132\236\167\132", "[PaGlobal_ItemMarketPassword] \237\140\168\236\138\164\236\155\140\235\147\156\236\151\144 \236\136\171\236\158\144\234\176\128 \236\149\132\235\139\140 \234\178\131\236\157\180 \236\158\136\236\138\181\235\139\136\235\139\164.")
    return
  end
  if self._maxPassward < string.len(passwordString) and self._state ~= self._const.InputMode then
    return
  end
  self._ui._editPassword:SetEditText(passwordString)
  self:update()
end
function FGlobal_ItemMarketPassword_Open(password, InputMode, itemCount)
  if password >= PaGlobal_ItemMarketPassword._minPassward then
    PaGlobal_ItemMarketPassword._state = PaGlobal_ItemMarketPassword._const.CreatedPasswords
  end
  if true == InputMode then
    PaGlobal_ItemMarketPassword._state = PaGlobal_ItemMarketPassword._const.InputMode
    PaGlobal_ItemMarketPassword._itemCount = itemCount
  end
  PaGlobal_ItemMarketPassword._ui._editPassword:SetEditText(PaGlobal_ItemMarketPassword._ui._editPassword:GetEditText())
  PaGlobal_ItemMarketPassword._ui.BlockBG:SetShow(true)
  Panel_ItemMarket_Password:SetShow(true)
  PaGlobal_ItemMarketPassword._ui.BlockBG:SetSize(getScreenSizeX() + 500, getScreenSizeY() + 500)
  PaGlobal_ItemMarketPassword._ui.BlockBG:SetHorizonCenter()
  PaGlobal_ItemMarketPassword._ui.BlockBG:SetVerticalMiddle()
  PaGlobal_ItemMarketPassword._ui.BlockBG:ComputePos()
end
function PaGlobal_ItemMarketPassword:update()
  local isBlind = not self._ui._checkPasswordView:IsCheck()
  self._ui._editPassword:SetSafeMode(isBlind)
  self._ui._editPassword:SetText(self._ui._editPassword:GetEditText())
  self._ui._editPassword:SetEditText(self._ui._editPassword:GetEditText())
end
PaGlobal_ItemMarketPassword:Init()
registerEvent("FromClient_luaLoadComplete", "PaGlobal_ItemMarketPassword:Init()")

local _panel = Panel_Window_MarketPlace_Function
local UI_color = Defines.Color
local MarketPlace_Function = {
  _ui = {
    btn_MarketPlace = UI.getChildControl(_panel, "Button_MarketPlace"),
    btn_WalletManagement = UI.getChildControl(_panel, "Button_WalletManagement"),
    btn_Tutorial = UI.getChildControl(_panel, "Button_Tutorial"),
    btn_Exit = UI.getChildControl(_panel, "Button_Exit")
  }
}
function PaGlobalFunc_MarketPlace_Function_Init()
  local self = MarketPlace_Function
  self:initControl()
  self:initEvent()
end
function MarketPlace_Function:initControl()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = _panel:GetSizeX()
  local panelSizeY = _panel:GetSizeY()
  _panel:SetSize(scrSizeX + 50, panelSizeY)
  _panel:SetPosX(0)
  _panel:SetPosY(scrSizeY - panelSizeY)
  PaGlobal_Itemmarket_Function:BottomButtonPosition()
  local btnList = {
    self._ui.btn_MarketPlace:GetTextSizeX(),
    self._ui.btn_WalletManagement:GetTextSizeX(),
    self._ui.btn_Tutorial:GetTextSizeX(),
    self._ui.btn_Exit:GetTextSizeX()
  }
  local textMaxSize = 0
  for i = 1, #btnList do
    textMaxSize = math.max(textMaxSize, btnList[i])
  end
  textMaxSize = textMaxSize + 10
  if textMaxSize > self._ui.btn_MarketPlace:GetSizeX() then
    if panelSizeX < textMaxSize * #btnList then
      self._ui.btn_WalletManagement:SetSize(math.floor(panelSizeX / #btnList) - 5, self._ui.btn_WalletManagement:GetSizeY())
      self._ui.btn_MarketPlace:SetSize(math.floor(panelSizeX / #btnList) - 5, self._ui.btn_WalletManagement:GetSizeY())
      self._ui.btn_Tutorial:SetSize(math.floor(panelSizeX / #btnList) - 5, self._ui.btn_WalletManagement:GetSizeY())
      self._ui.btn_Exit:SetSize(math.floor(panelSizeX / #btnList) - 5, self._ui.btn_WalletManagement:GetSizeY())
      UI.setLimitTextAndAddTooltip(self._ui.btn_WalletManagement)
      UI.setLimitTextAndAddTooltip(self._ui.btn_MarketPlace)
      UI.setLimitTextAndAddTooltip(self._ui.btn_Tutorial)
      UI.setLimitTextAndAddTooltip(self._ui.btn_Exit)
    else
      self._ui.btn_WalletManagement:SetSize(textMaxSize, self._ui.btn_WalletManagement:GetSizeY())
      self._ui.btn_MarketPlace:SetSize(textMaxSize, self._ui.btn_WalletManagement:GetSizeY())
      self._ui.btn_Tutorial:SetSize(textMaxSize, self._ui.btn_WalletManagement:GetSizeY())
      self._ui.btn_Exit:SetSize(textMaxSize, self._ui.btn_WalletManagement:GetSizeY())
    end
    self._ui.btn_MarketPlace:SetPosX(self._ui.btn_WalletManagement:GetPosX() - textMaxSize - 5)
    self._ui.btn_Exit:SetPosX(self._ui.btn_WalletManagement:GetPosX() + textMaxSize + 5)
  end
end
function PaGlobal_MarketPlace_Function:BottomButtonPosition()
  local self = MarketPlace_Function
  local _btnTable = {}
  local _btnCount = 0
  _btnTable[0] = self._ui.btn_MarketPlace
  _btnTable[1] = self._ui.btn_WalletManagement
  if true == PaGlobal_TutorialPhase_MarketPlace_IsActivate() then
    _btnTable[2] = self._ui.btn_Tutorial
    _btnTable[3] = self._ui.btn_Exit
  else
    self._ui.btn_Tutorial:SetShow(false)
    _btnTable[2] = self._ui.btn_Exit
  end
  if self._ui.btn_MarketPlace:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self._ui.btn_WalletManagement:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self._ui.btn_Tutorial:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self._ui.btn_Exit:GetShow() then
    _btnCount = _btnCount + 1
  end
  local sizeX = getScreenSizeX()
  local funcButtonCount = _btnCount
  local buttonSize = _btnTable[0]:GetSizeX()
  local buttonGap = 10
  local startPosX = (sizeX - (buttonSize * funcButtonCount + buttonGap * (funcButtonCount - 1))) / 2
  local posX = 0
  local jindex = 0
  for index = 0, _btnCount - 1 do
    if _btnTable[index]:GetShow() then
      posX = startPosX + (buttonSize + buttonGap) * jindex
      jindex = jindex + 1
    end
    _btnTable[index]:SetPosX(posX)
  end
end
function MarketPlace_Function:initEvent()
  self._ui.btn_MarketPlace:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_Open()")
  self._ui.btn_WalletManagement:addInputEvent("Mouse_LUp", "InputMLUp_MarketPlace_WalletOpen()")
  self._ui.btn_Tutorial:addInputEvent("Mouse_LUp", "PaGlobal_MarketPlaceTutorialSelect:prepareOpen()")
  self._ui.btn_Exit:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_Function_Close()")
end
function PaGlobalFunc_MarketPlace_Function_ClickCloseBtn()
end
function PaGlobalFunc_MarketPlace_Function_Open()
  local self = MarketPlace_Function
  self:open()
end
function PaGlobalFunc_MarketPlace_Function_Close()
  local self = MarketPlace_Function
  if true == PaGlobalFunc_MarketPlace_IsOpenFromDialog() then
    PaGlobalFunc_MarketPlace_CloseToDialog()
  elseif true == PaGlobalFunc_MarketPlace_IsOpenByMaid() then
    PaGlobalFunc_MarketPlace_CloseFromMaid()
  else
    PaGlobalFunc_MarketPlace_Close()
  end
  if true == Panel_Window_ItemMarket_Favorite:GetShow() then
    FGlobal_ItemMarket_FavoriteItem_Close()
  end
  self:close()
end
function MarketPlace_Function:open()
  _panel:SetShow(true)
end
function MarketPlace_Function:close()
  _panel:SetShow(false)
end
function PaGlobalFunc_MarketPlace_Function_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_MarketPlace_Function_SetButtonForTutorial(isSet)
  local self = MarketPlace_Function
  self._ui.btn_MarketPlace:SetIgnore(isSet)
  self._ui.btn_WalletManagement:SetIgnore(isSet)
  self._ui.btn_Tutorial:SetIgnore(isSet)
  self._ui.btn_Exit:SetIgnore(isSet)
  self._ui.btn_MarketPlace:SetMonoTone(isSet)
  self._ui.btn_WalletManagement:SetMonoTone(isSet)
  self._ui.btn_Tutorial:SetMonoTone(isSet)
  self._ui.btn_Exit:SetMonoTone(isSet)
end

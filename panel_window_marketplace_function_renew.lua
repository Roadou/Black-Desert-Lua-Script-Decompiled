local _panel = Panel_Window_MarketPlace_Function
local UI_color = Defines.Color
local MarketPlace_Function = {
  _ui = {
    btn_MarketPlace = UI.getChildControl(_panel, "Button_MarketPlace"),
    btn_WalletManagement = UI.getChildControl(_panel, "Button_WalletManagement"),
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
end
function PaGlobal_MarketPlace_Function:BottomButtonPosition()
  local self = MarketPlace_Function
  local _btnTable = {}
  local _btnCount = 0
  _btnTable[0] = self._ui.btn_MarketPlace
  _btnTable[1] = self._ui.btn_WalletManagement
  _btnTable[2] = self._ui.btn_Exit
  if self._ui.btn_MarketPlace:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self._ui.btn_WalletManagement:GetShow() then
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
  for index = 0, 2 do
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

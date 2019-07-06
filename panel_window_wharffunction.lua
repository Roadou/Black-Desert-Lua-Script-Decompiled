Panel_Window_WharfFunction:SetShow(false, false)
Panel_Window_WharfFunction:setMaskingChild(true)
Panel_Window_WharfFunction:ActiveMouseEventEffect(true)
local UI_TM = CppEnums.TextMode
local _wharfBG = UI.getChildControl(Panel_Window_WharfFunction, "Static_WharfTitle")
_wharfBG:setGlassBackground(true)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
local wharfFunction = {
  _config = {},
  _buttonRegister = UI.getChildControl(Panel_Window_WharfFunction, "Button_Register"),
  _buttonExit = UI.getChildControl(Panel_Window_WharfFunction, "Button_Exit"),
  _descBG = UI.getChildControl(Panel_Window_WharfFunction, "StaticText_DescBg")
}
function wharfFunction:init()
  self._descBG:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._descBG:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_DESC_GUILDWARF_SHIPSTOCKITEM"))
  local descTxtSizeX = self._descBG:GetTextSizeX()
  self._descBG:setPadding(CppEnums.Padding.ePadding_Left, 10)
  self._descBG:setPadding(CppEnums.Padding.ePadding_Top, 10)
  self._descBG:setPadding(CppEnums.Padding.ePadding_Right, 10)
  self._descBG:setPadding(CppEnums.Padding.ePadding_Bottom, 10)
  self._descBG:SetSize(descTxtSizeX + 20, self._descBG:GetTextSizeY() + 20)
end
function wharfFunction:SetBottomBtnPosition()
  local _btnTable = {}
  local _btnCount = 0
  _btnTable[0] = self._buttonRegister
  _btnTable[1] = self._buttonExit
  if self._buttonRegister:GetShow() then
    _btnCount = _btnCount + 1
  end
  if self._buttonExit:GetShow() then
    _btnCount = _btnCount + 1
  end
  local sizeX = getScreenSizeX()
  local funcButtonCount = _btnCount
  local buttonSize = _btnTable[0]:GetSizeX()
  local buttonGap = 10
  local startPosX = (sizeX - (buttonSize * funcButtonCount + buttonGap * (funcButtonCount - 1))) / 2
  local posX = 0
  local jindex = 0
  for index = 0, 1 do
    if _btnTable[index]:GetShow() then
      posX = startPosX + (buttonSize + buttonGap) * jindex
      jindex = jindex + 1
    end
    _btnTable[index]:SetPosX(posX)
  end
end
function wharfFunction:registEventHandler()
  self._buttonRegister:addInputEvent("Mouse_LUp", "WharfFunction_Button_RegisterReady()")
  self._buttonExit:addInputEvent("Mouse_LUp", "WharfFunction_Close()")
end
function wharfFunction:registMessageHandler()
  registerEvent("onScreenResize", "WharfFunction_Resize")
  registerEvent("FromClient_ServantUpdate", "WharfFunction_RegisterAck")
end
function WharfFunction_Resize()
  local self = wharfFunction
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  Panel_Window_WharfFunction:SetSize(screenX, Panel_Window_WharfFunction:GetSizeY())
  _wharfBG:SetSize(screenX, Panel_Window_WharfFunction:GetSizeY())
  Panel_Window_WharfFunction:ComputePos()
  _wharfBG:ComputePos()
  self._descBG:ComputePos()
  wharfFunction:SetBottomBtnPosition()
end
function WharfFunction_Button_RegisterReady()
  Inventory_SetFunctor(InvenFiler_Mapae, WharfFunction_Register, Servant_InventoryClose, nil)
  Inventory_ShowToggle()
  audioPostEvent_SystemUi(0, 0)
end
function WharfFunction_Register(slotNo, itemWrapper, count_s64, inventoryType)
  WharfRegister_OpenByInventory(inventoryType, slotNo)
end
function WharfFunction_RegisterAck()
  if GetUIMode() == Defines.UIMode.eUIMode_Default then
    return
  end
  if false == Panel_Window_WharfList:GetShow() then
    return
  end
  Inventory_SetFunctor(nil)
  InventoryWindow_Close()
  WharfRegister_Close()
  local self = wharfFunction
  self._buttonRegister:EraseAllEffect()
end
function WharfFunction_Open()
  if Panel_Window_WharfFunction:GetShow() then
    return
  end
  Servant_SceneOpen(Panel_Window_WharfFunction)
  WharfList_Open()
  local self = wharfFunction
  if stable_doHaveRegisterItem() then
    local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
    local messageboxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_WHARF_REGISTERITEM_MSG")
    local messageboxData = {
      title = messageboxTitle,
      content = messageboxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
    self._buttonRegister:EraseAllEffect()
    self._buttonRegister:AddEffect("UI_ArrowMark01", true, 25, -38)
  else
    self._buttonRegister:EraseAllEffect()
  end
end
function WharfFunction_Close()
  audioPostEvent_SystemUi(0, 0)
  local self = wharfFunction
  self._buttonRegister:EraseAllEffect()
  InventoryWindow_Close()
  WharfList_Close()
  if not Panel_Window_WharfFunction:GetShow() then
    return
  end
  Servant_SceneClose(Panel_Window_WharfFunction)
end
wharfFunction:init()
wharfFunction:registEventHandler()
wharfFunction:registMessageHandler()
WharfFunction_Resize()
wharfFunction:SetBottomBtnPosition()

Panel_Window_GuildWharfFunction:SetShow(false, false)
Panel_Window_GuildWharfFunction:setMaskingChild(true)
Panel_Window_GuildWharfFunction:ActiveMouseEventEffect(true)
local UI_TM = CppEnums.TextMode
local _wharfBG = UI.getChildControl(Panel_Window_GuildWharfFunction, "Static_WharfTitle")
_wharfBG:setGlassBackground(true)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
guildWharfFunction = {
  _config = {},
  _buttonRegister = UI.getChildControl(Panel_Window_GuildWharfFunction, "Button_Register"),
  _buttonExit = UI.getChildControl(Panel_Window_GuildWharfFunction, "Button_Exit"),
  _descBG = UI.getChildControl(Panel_Window_GuildWharfFunction, "StaticText_DescBg"),
  _isOpen = false
}
function guildWharfFunction:init()
  self._descBG:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._descBG:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_DESC_GUILDWARF_SHIPSTOCKITEM"))
  local descTxtSizeX = self._descBG:GetTextSizeX()
  self._descBG:setPadding(CppEnums.Padding.ePadding_Left, 10)
  self._descBG:setPadding(CppEnums.Padding.ePadding_Top, 10)
  self._descBG:setPadding(CppEnums.Padding.ePadding_Right, 10)
  self._descBG:setPadding(CppEnums.Padding.ePadding_Bottom, 10)
  self._descBG:SetSize(descTxtSizeX + 20, self._descBG:GetTextSizeY() + 20)
end
function guildWharfFunction:SetBottomBtnPosition()
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
function guildWharfFunction:registEventHandler()
  self._buttonRegister:addInputEvent("Mouse_LUp", "GuildWharfFunction_Button_RegisterReady()")
  self._buttonExit:addInputEvent("Mouse_LUp", "GuildWharfFunction_Close()")
end
function guildWharfFunction:registMessageHandler()
  registerEvent("onScreenResize", "GuildWharfFunction_Resize")
  registerEvent("FromClient_ServantUpdate", "GuildWharfFunction_RegisterAck")
end
function GuildWharfFunction_Resize()
  local self = guildWharfFunction
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  Panel_Window_GuildWharfFunction:SetSize(screenX, Panel_Window_GuildWharfFunction:GetSizeY())
  _wharfBG:SetSize(screenX, Panel_Window_GuildWharfFunction:GetSizeY())
  Panel_Window_GuildWharfFunction:ComputePos()
  _wharfBG:ComputePos()
  self._buttonRegister:ComputePos()
  self._buttonExit:ComputePos()
  self._descBG:ComputePos()
  guildWharfFunction:SetBottomBtnPosition()
end
function GuildWharfFunction_Button_RegisterReady()
  Inventory_SetFunctor(InvenFiler_Mapae, GuildWharfFunction_Register, Servant_InventoryClose, nil)
  Inventory_ShowToggle()
  audioPostEvent_SystemUi(0, 0)
  guildWharfFunction._buttonRegister:EraseAllEffect()
end
function GuildWharfFunction_Register(slotNo, itemWrapper, count_s64, inventoryType)
  GuildWharfRegister_OpenByInventory(inventoryType, slotNo)
end
function GuildWharfFunction_RegisterAck()
  if GetUIMode() == Defines.UIMode.eUIMode_Default then
    return
  end
  if false == Panel_Window_GuildWharf_List:GetShow() then
    return
  end
  Inventory_SetFunctor(nil)
  InventoryWindow_Close()
  GuildWharfRegister_Close()
  local self = guildWharfFunction
end
function GuildWharfFunction_Open()
  local self = guildWharfFunction
  if Panel_Window_GuildWharfFunction:GetShow() then
    return
  end
  self._isOpen = true
  Servant_SceneOpen(Panel_Window_GuildWharfFunction)
  GuildWharfList_Open()
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
function GuildWharfFunction_Close()
  audioPostEvent_SystemUi(0, 0)
  local self = guildWharfFunction
  self._buttonRegister:EraseAllEffect()
  InventoryWindow_Close()
  GuildWharfList_Close()
  if not Panel_Window_GuildWharfFunction:GetShow() then
    return
  end
  Servant_SceneClose(Panel_Window_GuildWharfFunction)
end
guildWharfFunction:init()
guildWharfFunction:registEventHandler()
guildWharfFunction:registMessageHandler()
WharfFunction_Resize()
guildWharfFunction:SetBottomBtnPosition()

Panel_Window_GuildStableFunction:SetShow(false, false)
Panel_Window_GuildStableFunction:setMaskingChild(true)
Panel_Window_GuildStableFunction:ActiveMouseEventEffect(true)
Panel_Window_GuildStableFunction:RegisterShowEventFunc(true, "")
Panel_Window_GuildStableFunction:RegisterShowEventFunc(false, "")
local _stableBG = UI.getChildControl(Panel_Window_GuildStableFunction, "Static_StableTitle")
_stableBG:setGlassBackground(true)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
guildStableFunction = {
  config = {},
  _buttonRegister = UI.getChildControl(Panel_Window_GuildStableFunction, "Button_RegisterByItem"),
  _textRegist = UI.getChildControl(Panel_Window_GuildStableFunction, "StaticText_Purpose"),
  _buttonExit = UI.getChildControl(Panel_Window_GuildStableFunction, "Button_Exit"),
  _funcBtnCount = 0,
  _funcBtnRePos = {},
  _isOpen = false
}
function guildStableFunction:init()
  guildStableFunction._textRegist:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEFUNCTION_TEXTREGIST"))
  guildStableFunction._textRegist:SetShow(false)
end
function guildStableFunction:registEventHandler()
  self._buttonRegister:addInputEvent("Mouse_LUp", "GuildStableFunction_Button_RegisterReady()")
  self._buttonExit:addInputEvent("Mouse_LUp", "GuildStableFunction_Close()")
end
function guildStableFunction:registMessageHandler()
  registerEvent("onScreenResize", "GuildStableFunction_Resize")
  registerEvent("FromClient_ServantUpdate", "GuildStableFunction_RegisterAck")
end
function GuildStableFunction_Resize()
  local self = guildStableFunction
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  Panel_Window_GuildStableFunction:SetSize(screenX, Panel_Window_GuildStableFunction:GetSizeY())
  _stableBG:SetSize(screenX, Panel_Window_GuildStableFunction:GetSizeY())
  Panel_Window_GuildStableFunction:ComputePos()
  _stableBG:ComputePos()
  self._buttonRegister:ComputePos()
  self._buttonExit:ComputePos()
  self._textRegist:ComputePos()
  self._textRegist:SetSpanSize(0, -screenY * 3 / 4)
end
function GuildStableFunction_Button_RegisterReady(slotNo)
  Inventory_SetFunctor(InvenFiler_Mapae, GuildStableFunction_Button_Register, Servant_InventoryClose, nil)
  Inventory_ShowToggle()
  audioPostEvent_SystemUi(0, 0)
end
function GuildStableFunction_Button_Register(slotNo, itemWrapper, count_s64, inventoryType)
  GuildStableRegister_OpenByInventory(inventoryType, slotNo)
end
function GuildStableFunction_RegisterAck()
  if GetUIMode() == Defines.UIMode.eUIMode_Default then
    return
  end
  if false == Panel_Window_GuildStable_List:GetShow() then
    return
  end
  Inventory_SetFunctor(nil)
  InventoryWindow_Close()
  local self = guildStableFunction
  self._buttonRegister:EraseAllEffect()
end
function GuildStableFunction_Open()
  local self = guildStableFunction
  self._isOpen = true
  Servant_SceneOpen(Panel_Window_GuildStableFunction)
  GuildStableList_Open()
  GuildStablefuncButtonRePosition()
  FGlobal_NeedGuildStableRegistItem_Print()
end
function GuildStablefuncButtonRePosition()
  local self = guildStableFunction
  self._funcBtnRePos = {}
  self._funcBtnCount = 0
  if stable_doHaveRegisterItem() then
    local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
    local messageboxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_REGISTERITEM_MSG")
    local messageboxData = {
      title = messageboxTitle,
      content = messageboxMemo,
      functionApply = FGlobal_NeedStableRegistItem_Print,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
    self._buttonRegister:EraseAllEffect()
    self._buttonRegister:AddEffect("UI_ArrowMark01", true, 25, -38)
  else
    self._buttonRegister:EraseAllEffect()
  end
  self._funcBtnRePos[self._funcBtnCount] = self._buttonRegister
  self._funcBtnCount = self._funcBtnCount + 1
  self._funcBtnRePos[self._funcBtnCount] = self._buttonExit
  self._funcBtnCount = self._funcBtnCount + 1
  local gapX = 10
  local startPosX = (getScreenSizeX() - (guildStableFunction._buttonExit:GetSizeX() * self._funcBtnCount + (self._funcBtnCount - 1) * gapX)) / 2
  for index = 0, self._funcBtnCount - 1 do
    self._funcBtnRePos[index]:SetPosX(startPosX + index * (guildStableFunction._buttonExit:GetSizeX() + gapX))
  end
end
function FGlobal_NeedGuildStableRegistItem_Print()
  local self = guildStableFunction
  if stable_doHaveRegisterItem() then
    self._textRegist:SetShow(true)
  else
    self._textRegist:SetShow(false)
  end
end
function GuildStableFunction_Close()
  audioPostEvent_SystemUi(0, 0)
  local self = guildStableFunction
  self._buttonRegister:EraseAllEffect()
  InventoryWindow_Close()
  GuildStableList_Close()
  if not Panel_Window_GuildStableFunction:GetShow() then
    return
  end
  Servant_SceneClose(Panel_Window_GuildStableFunction)
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_Bottom_FuncButtonUpdate()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    Dialog_updateButtons(true)
  else
    PaGlobalFunc_DialogMain_All_BottomFuncBtnUpdate()
  end
end
guildStableFunction:init()
guildStableFunction:registEventHandler()
guildStableFunction:registMessageHandler()
GuildStableFunction_Resize()

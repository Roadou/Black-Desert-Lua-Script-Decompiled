local Panel_Window_StableRegister_Name_info = {
  _ui = {
    static_SubFrameBG = nil,
    edit_Name = nil,
    staticText_RegisterDesc = nil,
    static_BottomKeyBG = nil,
    staticText_Confirm_ConsoleUI = nil
  },
  _value = {
    leftServantNo = nil,
    rightServantNo = nil,
    whereType = CppEnums.ItemWhereType.eWarehouse
  }
}
local randomName = {
  "Darcy",
  "Buddy",
  "Orbit",
  "Rushmore",
  "Carolina",
  "Cindy",
  "Waffles",
  "Sparky",
  "Bailey",
  "Wichita",
  "Buck"
}
function Panel_Window_StableRegister_Name_info:registEventHandler()
  Panel_Window_StableRegister_Name:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_StableRegister_Name_Register()")
  Panel_Window_StableRegister_Name:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_StableRegister_Name_NameSetfocus()")
  self._ui.edit_Name:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableRegister_Name_NameSetfocus()")
  self._ui.staticText_Confirm_ConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableRegister_Name_Register()")
  self._ui.edit_Name:setXboxVirtualKeyBoardEndEvent("PaGlobalFunc_StableRegister_Name_OnVirtualKeyboardEnd")
  Panel_Window_StableRegister_Name:ignorePadSnapMoveToOtherPanel()
end
function Panel_Window_StableRegister_Name_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_StableRegister_Name_Resize")
end
function Panel_Window_StableRegister_Name_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_StableRegister_Name_info:initValue()
  self._value.leftServantNo = nil
  self._value.rightServantNo = nil
  self._value.whereType = CppEnums.ItemWhereType.eWarehouse
end
function Panel_Window_StableRegister_Name_info:resize()
end
function Panel_Window_StableRegister_Name_info:childControl()
  self._ui.static_SubFrameBG = UI.getChildControl(Panel_Window_StableRegister_Name, "Static_SubFrameBG")
  self._ui.edit_Name = UI.getChildControl(self._ui.static_SubFrameBG, "Edit_Name")
  self._ui.edit_Name:SetMaxInput(getGameServiceTypeServantNameLength())
  self._ui.staticText_RegisterDesc = UI.getChildControl(self._ui.static_SubFrameBG, "StaticText_RegisterDesc")
  self._ui.staticText_RegisterDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.static_BottomKeyBG = UI.getChildControl(Panel_Window_StableRegister_Name, "Static_BottomKeyBG")
  self._ui.staticText_ChangeName_ConsoleUI = UI.getChildControl(self._ui.static_BottomKeyBG, "StaticText_ChangeName_ConsoleUI")
  self._ui.staticText_Confirm_ConsoleUI = UI.getChildControl(self._ui.static_BottomKeyBG, "StaticText_Confirm_ConsoleUI")
  self._ui.staticText_Cancel_ConsoleUI = UI.getChildControl(self._ui.static_BottomKeyBG, "StaticText_Cancel_ConsoleUI")
  local tempBtnGroup = {
    self._ui.staticText_ChangeName_ConsoleUI,
    self._ui.staticText_Confirm_ConsoleUI,
    self._ui.staticText_Cancel_ConsoleUI
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui.static_BottomKeyBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  if self._ui.staticText_ChangeName_ConsoleUI:GetPosX() < 10 then
    tempBtnGroup = {
      self._ui.staticText_ChangeName_ConsoleUI,
      self._ui.staticText_Confirm_ConsoleUI
    }
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui.static_BottomKeyBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
    self._ui.staticText_ChangeName_ConsoleUI:SetPosY(self._ui.staticText_ChangeName_ConsoleUI:GetPosY() - 25)
    self._ui.staticText_Confirm_ConsoleUI:SetPosY(self._ui.staticText_Confirm_ConsoleUI:GetPosY() - 25)
    self._ui.staticText_Cancel_ConsoleUI:SetPosXY(self._ui.staticText_Confirm_ConsoleUI:GetPosX(), self._ui.staticText_Cancel_ConsoleUI:GetPosY() + 15)
  end
end
function Panel_Window_StableRegister_Name_info:setContent()
  self._ui.staticText_RegisterDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_REGISTNAME_DESC"))
  self:setEditName()
end
function Panel_Window_StableRegister_Name_info:open()
  Panel_Window_StableRegister_Name:SetShow(true)
end
function Panel_Window_StableRegister_Name_info:close()
  Panel_Window_StableRegister_Name:SetShow(false)
end
function Panel_Window_StableRegister_Name_info:setEditName()
  local randIndex = getRandomValue(1, #randomName)
  self._ui.edit_Name:SetEditText(randomName[randIndex])
end
function PaGlobalFunc_StableRegister_Name_OnVirtualKeyboardEnd(str)
  local self = Panel_Window_StableRegister_Name_info
  self._ui.edit_Name:SetEditText(str)
  ClearFocusEdit()
end
function PaGlobalFunc_StableRegister_Name_GetShow()
  return Panel_Window_StableRegister_Name:GetShow()
end
function PaGlobalFunc_StableRegister_Name_Open()
  local self = Panel_Window_StableRegister_Name_info
  self:open()
end
function PaGlobalFunc_StableRegister_Name_Close()
  local self = Panel_Window_StableRegister_Name_info
  self:close()
end
function PaGlobalFunc_StableRegister_Name_Show(leftServantNo, rightServantNo, whereType)
  if nil == leftServantNo or nil == rightServantNo then
    return
  end
  local self = Panel_Window_StableRegister_Name_info
  self._value.leftServantNo = leftServantNo
  self._value.rightServantNo = rightServantNo
  self._value.whereType = whereType
  self:setContent()
  self:open()
end
function PaGlobalFunc_StableRegister_Name_Exit()
  local self = Panel_Window_StableRegister_Name_info
  if true == self._ui.edit_Name:GetFocusEdit() then
    ClearFocusEdit()
  end
  self:close()
  PaGlobalFunc_StableExchange_ShowByExchange()
end
function PaGlobalFunc_StableRegister_Name_Register()
  local self = Panel_Window_StableRegister_Name_info
  if nil == self._value.leftServantNo or nil == self._value.rightServantNo then
    return
  end
  if true == self._ui.edit_Name:GetFocusEdit() then
    ClearFocusEdit()
  end
  local name = self._ui.edit_Name:GetEditText()
  stable_mix(self._value.leftServantNo, self._value.rightServantNo, self._value.whereType, name)
  PaGlobalFunc_StableList_Update()
  self:close()
end
function PaGlobalFunc_StableRegister_Name_NameSetfocus()
  local self = Panel_Window_StableRegister_Name_info
  if true == self._ui.edit_Name:GetFocusEdit() then
    ClearFocusEdit()
  else
    SetFocusEdit(self._ui.edit_Name)
  end
end
function PaGlobalFunc_StableRegister_Name_OnVirtualKeyboardEnd(str)
  local self = Panel_Window_StableRegister_Name_info
  self._ui.edit_Name:SetEditText(str)
  ClearFocusEdit()
end
function FromClient_StableRegister_Name_Init()
  local self = Panel_Window_StableRegister_Name_info
  self:initialize()
end
function FromClient_StableRegister_Name_Resize()
  local self = Panel_Window_StableRegister_Name_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_StableRegister_Name_Init")

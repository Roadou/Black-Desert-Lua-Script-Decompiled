local _panel = Panel_Customizing_InputName
_panel:ignorePadSnapMoveToOtherPanel()
local Customization_InputNameInfo = {
  _ui = {
    _edit_InputName = UI.getChildControl(_panel, "Edit_InputName"),
    _static_KeyGuideBg = UI.getChildControl(_panel, "Static_BottomGroup_ConsoleUI"),
    _statictext_Desc = UI.getChildControl(_panel, "StaticText_Desc1")
  },
  _defaultEditText = "",
  _createSync = true
}
function PaGlobalFunc_Customization_InputName_SetCreateSync(isSync)
  local self = Customization_InputNameInfo
  self._createSync = isSync
end
function PaGlobalFunc_Customization_InputName_Confirm(str)
  local self = Customization_InputNameInfo
  if false == self._createSync then
    return
  end
  local nameStr = str
  if nil == nameStr then
    nameStr = self._ui._edit_InputName:GetEditText()
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  PaGlobalFunc_ClassSelect_CharacterCreate(nameStr)
end
function Customization_InputNameInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
  self:InitString()
end
function Customization_InputNameInfo:InitControl()
  self._ui._button_Confirm = UI.getChildControl(self._ui._static_KeyGuideBg, "Button_OK_ConsoleUI")
  self._ui._button_Cancel = UI.getChildControl(self._ui._static_KeyGuideBg, "Button_NO_ConsoleUI")
  local keyGuides = {
    self._ui._button_Confirm,
    self._ui._button_Cancel
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui._static_KeyGuideBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_CENTER)
  self._ui._edit_InputName:SetMaxInput(getGameServiceTypeCharacterNameLength())
end
function Customization_InputNameInfo:InitEvent()
  self._ui._button_Confirm:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_InputName_Confirm()")
  self._ui._button_Cancel:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_InputName_Close()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_Customization_InputName_Confirm()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_Customization_InputName_SetFocus()")
  self._ui._edit_InputName:setXboxVirtualKeyBoardEndEvent("PaGlobalFunc_Customization_InputName_KeyboardEnd")
  PaGlobal_registerPanelOnBlackBackground(_panel)
end
function Customization_InputNameInfo:InitRegister()
  registerEvent("FromClient_CreateCharacterFail", "PaGlobalFunc_FromClient_Customization_InputName_CreateCharacterFail")
end
function Customization_InputNameInfo:InitString()
  self._defaultEditText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_INPUTNAME_EDITTEXT", "maxLength", getGameServiceTypeCharacterNameLength())
  self._ui._statictext_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._statictext_Desc:SetText(self._ui._statictext_Desc:GetText())
end
function PaGlobalFunc_FromClient_Customization_InputName_CreateCharacterFail()
  PaGlobalFunc_Customization_InputName_SetCreateSync(true)
end
function PaGlobalFunc_Customization_InputName_KeyboardEnd(str)
  local self = Customization_InputNameInfo
  if getGameServiceTypeCharacterNameLength() < string.len(str) then
    str = string.sub(str, 1, getGameServiceTypeCharacterNameLength())
  end
  self._ui._edit_InputName:SetEditText(str)
  ClearFocusEdit()
  self._ui._edit_InputName:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_Customization_InputName_SetFocus()")
end
function PaGlobalFunc_Customization_InputName_SetFocus()
  local self = Customization_InputNameInfo
  if false == self._createSync then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self._ui._edit_InputName:SetEditText("")
  SetFocusEdit(self._ui._edit_InputName)
end
function PaGlobalFunc_FromClient_Customization_InputName_luaLoadComplete()
  local self = Customization_InputNameInfo
  self:Initialize()
end
function PaGlobalFunc_Customization_InputName_ForcedClose()
  ClearFocusEdit()
  PaGlobalFunc_Customization_InputName_SetCreateSync(true)
  PaGlobalFunc_Customization_SetCloseFunc(nil)
  PaGlobalFunc_Customization_SetBackEvent()
  PaGlobalFunc_Customization_InputName_SetShow(false, false)
end
function PaGlobalFunc_Customization_InputName_Close(clearStr)
  local self = Customization_InputNameInfo
  if false == PaGlobalFunc_Customization_InputName_GetShow() then
    return false
  end
  if true == self._ui._edit_InputName:GetFocusEdit() then
    ClearFocusEdit()
    return false
  end
  PaGlobalFunc_Customization_InputName_SetCreateSync(true)
  if nil == clearStr or true == clearStr then
    self._ui._edit_InputName:SetEditText("")
  end
  PaGlobalFunc_Customization_SetCloseFunc(nil)
  PaGlobalFunc_Customization_SetBackEvent()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  PaGlobalFunc_Customization_InputName_SetShow(false, false)
  return true
end
function PaGlobalFunc_Customization_InputName_Open(clearStr)
  local self = Customization_InputNameInfo
  if nil == clearStr or true == clearStr then
    self._ui._edit_InputName:SetEditText("")
    self._ui._edit_InputName:SetText(self._defaultEditText)
  end
  if true == PaGlobalFunc_Customization_InputName_GetShow() then
    return
  end
  PaGlobalFunc_Customization_SetCloseFunc(PaGlobalFunc_Customization_InputName_Close)
  PaGlobalFunc_Customization_SetBackEvent("PaGlobalFunc_Customization_InputName_Close()")
  _AudioPostEvent_SystemUiForXBOX(8, 14)
  PaGlobalFunc_Customization_InputName_SetShow(true, false)
end
function PaGlobalFunc_Customization_InputName_SetShow(isShow, isAni)
  Panel_Customizing_InputName:SetShow(isShow, isAni)
end
function PaGlobalFunc_Customization_InputName_GetShow()
  return Panel_Customizing_InputName:GetShow()
end
PaGlobalFunc_FromClient_Customization_InputName_luaLoadComplete()

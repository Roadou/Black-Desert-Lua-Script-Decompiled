Panel_Window_FairyChoiseTheReset:SetShow(false)
PaGlobal_FairyChoice = {
  _isClearSkill = false,
  _fairyAttr = false,
  _fairyNo = nil,
  _ui = {
    _close = UI.getChildControl(Panel_Window_FairyChoiseTheReset, "Button_Close"),
    _select = UI.getChildControl(Panel_Window_FairyChoiseTheReset, "Button_Select"),
    _cancel = UI.getChildControl(Panel_Window_FairyChoiseTheReset, "Button_Cancel"),
    _skillClear = UI.getChildControl(Panel_Window_FairyChoiseTheReset, "RadioButton_Skill"),
    _voiceClear = UI.getChildControl(Panel_Window_FairyChoiseTheReset, "RadioButton_Voice")
  }
}
function PaGlobal_FairyChoice:Open()
  PaGlobalFunc_fairySkill_Close()
  if PaGlobal_FairyInfo_isUnseal() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoNeedSealFairy"))
    return
  end
  PaGlobal_FairyChoice:Clear()
  PaGlobal_FairyChoice:Update()
  Panel_Window_FairyChoiseTheReset:SetShow(true)
end
function PaGlobal_FairyChoice:Close()
  Panel_Window_FairyChoiseTheReset:SetShow(false)
end
function PaGlobal_FairyChoice:Clear()
  self._isClearSkill = true
  self._fairyAttr = false
  self._ui._skillClear:SetCheck(true)
  self._ui._voiceClear:SetCheck(false)
end
function PaGlobal_FairyChoice:Update()
  PaGlobal_FairyChoice:Clear()
  self._fairyNo = PaGlobal_FairyInfo_GetFairyNo()
end
function PaGlobal_FairyChoice:RequestRebirth()
  local FunctionYes = function()
    local self = PaGlobal_FairyChoice
    if nil == self._fairyNo then
      return
    end
    if PaGlobal_FairyInfo_GetLevel() < 10 and true == self._isClearSkill then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrCantRebirthLessLevel"))
      return
    end
    ToClient_FairyRebirth(self._fairyNo, self._isClearSkill, self._fairyAttr)
    PaGlobal_FairyChoice:Close()
  end
  local _title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING")
  local _contenet = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_REBIRTH_ALERT")
  if true == self._fairyAttr then
    _contenet = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_REBIRTH_ALERT_CHANGE_VOICE")
  end
  local messageBoxData = {
    title = _title,
    content = _contenet,
    functionYes = FunctionYes,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_FairyChoice:Initialize()
  local self = PaGlobal_FairyChoice
  self._ui._close:addInputEvent("Mouse_LUp", "PaGlobal_FairyChoice:Close()")
  self._ui._cancel:addInputEvent("Mouse_LUp", "PaGlobal_FairyChoice:Close()")
  self._ui._select:addInputEvent("Mouse_LUp", "PaGlobal_FairyChoice:RequestRebirth()")
  self._ui._skillClear:addInputEvent("Mouse_LUp", "PaGlobal_FairyChoice:ClickedSkill(true)")
  self._ui._skillClear:addInputEvent("Mouse_On", "FairyReset_SimpleTooltips(true, 0)")
  self._ui._skillClear:addInputEvent("Mouse_Out", "FairyReset_SimpleTooltips(false)")
  self._ui._voiceClear:addInputEvent("Mouse_LUp", "PaGlobal_FairyChoice:ClickedSkill(false)")
  self._ui._voiceClear:addInputEvent("Mouse_On", "FairyReset_SimpleTooltips(true, 1)")
  self._ui._voiceClear:addInputEvent("Mouse_Out", "FairyReset_SimpleTooltips(false)")
  self._ui._skillClear:SetEnableArea(0, 0, self._ui._skillClear:GetSizeX() + self._ui._skillClear:GetTextSizeX() + 15, self._ui._skillClear:GetSizeY())
  self._ui._voiceClear:SetEnableArea(0, 0, self._ui._skillClear:GetSizeX() + self._ui._skillClear:GetTextSizeX() + 15, self._ui._skillClear:GetSizeY())
end
function FairyReset_SimpleTooltips(isShow, idx)
  local self = PaGlobal_FairyChoice
  local name, desc, uiControl
  if 0 == idx then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_RESET_NAME1")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_RESET_DESC1")
    uiControl = self._ui._skillClear
  elseif 1 == idx then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_RESET_NAME2")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_RESET_DESC2")
    uiControl = self._ui._voiceClear
  end
  if isShow == true then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_FairyChoice:ClickedSkill(bValue)
  if true == bValue then
    self._isClearSkill = true
    self._fairyAttr = false
  else
    self._isClearSkill = false
    self._fairyAttr = true
  end
end
function TestUpgrade()
  ToClient_FairyUpgradeRequest(PaGlobal_FairyInfo_GetFairyNo(), 0, 2, 50)
end
PaGlobal_FairyChoice:Initialize()

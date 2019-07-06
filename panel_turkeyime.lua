local VCK = CppEnums.VirtualKeyCode
Panel_TurkeyIME:SetShow(false)
PaGlobal_TurkeyIME = {
  _ui = {
    _buttonKeyboard = UI.getChildControl(Panel_TurkeyIME, "Button_Keyboard"),
    _staticInputTurkeyLan = UI.getChildControl(Panel_TurkeyIME, "Static_KeyBG"),
    _buttonTurkeyLan = {},
    _buttonTurkeyUpperLan = {}
  },
  _turkeyLanLower = {
    [1] = "\195\167",
    [2] = "\196\159",
    [3] = "\196\177",
    [4] = "\195\182",
    [5] = "\197\159",
    [6] = "\195\188"
  },
  _turkeyLanUpper = {
    [1] = "\195\135",
    [2] = "\196\158",
    [3] = "I",
    [4] = "\195\150",
    [5] = "\197\158",
    [6] = "\195\156"
  },
  _turkeyLanCount = 6,
  _isShiftMode = false
}
function PaGlobal_TurkeyIME:Init()
  self._ui._buttonKeyboard:addInputEvent("Mouse_LUp", "PaGlobal_TurkeyIME:ToggleInputTurkeyLan()")
  for ii = 1, self._turkeyLanCount do
    self._ui._buttonTurkeyLan[ii] = UI.getChildControl(self._ui._staticInputTurkeyLan, "Button_" .. ii)
    self._ui._buttonTurkeyLan[ii]:addInputEvent("Mouse_LUp", "PaGlobal_TurkeyIME:SetInputTurkeyLan(" .. ii .. ")")
    self._ui._buttonTurkeyUpperLan[ii] = UI.getChildControl(self._ui._staticInputTurkeyLan, "Button_Upper" .. ii)
    self._ui._buttonTurkeyUpperLan[ii]:addInputEvent("Mouse_LUp", "PaGlobal_TurkeyIME:SetInputTurkeyLan(" .. ii .. ")")
    self._ui._buttonTurkeyUpperLan[ii]:SetShow(false)
  end
end
function PaGlobal_TurkeyIME:ToggleInputTurkeyLan()
  if true == self._ui._staticInputTurkeyLan:GetShow() then
    self._ui._staticInputTurkeyLan:SetShow(false)
    Panel_TurkeyIME:RegisterUpdateFunc("")
  else
    self._ui._staticInputTurkeyLan:SetShow(true)
    Panel_TurkeyIME:RegisterUpdateFunc("FromClient_TurkeyInputUpdate")
  end
end
function PaGlobal_TurkeyIME:SetInputTurkeyLan(index)
  local uiEdit = GetFocusEdit()
  local turkeyLan = self:GetTurkeyLan(index)
  uiEdit:SetEditText(uiEdit:GetEditText() .. turkeyLan, true)
end
function PaGlobal_TurkeyIME:GetTurkeyLan(index)
  if index > self._turkeyLanCount or index <= 0 then
    return ""
  end
  if true == isKeyPressed(VCK.KeyCode_SHIFT) then
    return self._turkeyLanUpper[index]
  else
    return self._turkeyLanLower[index]
  end
end
function PaGlobal_TurkeyIME:UpdateShiftKey()
  local beforeState = self._isShiftMode
  if true == isKeyPressed(VCK.KeyCode_SHIFT) then
    self._isShiftMode = true
  else
    self._isShiftMode = false
  end
  if beforeState ~= self._isShiftMode then
    for ii = 1, self._turkeyLanCount do
      if true == self._isShiftMode then
        self._ui._buttonTurkeyUpperLan[ii]:SetShow(true)
      else
        self._ui._buttonTurkeyUpperLan[ii]:SetShow(false)
      end
    end
  end
end
function FromClient_TurkeyInputUpdate()
  PaGlobal_TurkeyIME:UpdateShiftKey()
end
function FromClient_OpenTurkeyInput()
  Panel_TurkeyIME:SetShow(true)
  PaGlobal_TurkeyIME._ui._staticInputTurkeyLan:SetShow(false)
  local uiEdit = GetFocusEdit()
  if uiEdit == nil then
    return
  end
  local uiEdit = GetFocusEdit()
  local uiEditPanel = uiEdit:GetParentPanel()
  local imeSizeX = PaGlobal_TurkeyIME._ui._buttonKeyboard:GetSizeX()
  Panel_TurkeyIME:SetPosX(uiEditPanel:GetPosX() + uiEdit:GetPosX() + uiEdit:GetSizeX() - imeSizeX)
  Panel_TurkeyIME:SetPosY(uiEditPanel:GetPosY() + uiEdit:GetPosY() + uiEdit:GetSizeY() + 3)
end
function FromClient_CloseTurkeyInput()
  Panel_TurkeyIME:SetShow(false)
  Panel_TurkeyIME:RegisterUpdateFunc("")
end
PaGlobal_TurkeyIME:Init()
registerEvent("FromClient_OpenTurkeyInput", "FromClient_OpenTurkeyInput")
registerEvent("FromClient_CloseTurkeyInput", "FromClient_CloseTurkeyInput")

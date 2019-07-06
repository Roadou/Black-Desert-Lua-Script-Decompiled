Instance_Window_NumberPad:SetShow(false, false)
Instance_Window_NumberPad:setMaskingChild(true)
Instance_Window_NumberPad:ActiveMouseEventEffect(true)
Instance_Window_NumberPad:setGlassBackground(true)
Instance_Window_NumberPad:RegisterShowEventFunc(true, "ExchangeNumberShowAni()")
Instance_Window_NumberPad:RegisterShowEventFunc(false, "ExchangeNumberHideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local IM = CppEnums.EProcessorInputMode
local VCK = CppEnums.VirtualKeyCode
local UI_color = Defines.Color
local strlen = string.len
local substring = string.sub
local numberPad = {
  MAX_NUMBER_BTN_COUNT = 10,
  s64_moneyMaxNumber = Defines.s64_const.s64_0,
  s64_weightMaxNumber = Defines.s64_const.s64_0,
  s64_inputNumber = Defines.s64_const.s64_0,
  param0 = nil,
  param1 = nil,
  confirmFunction,
  init_Number = false,
  _buttonNumber = Array.new(),
  _type = ""
}
local numberKeyCode = {
  VCK.KeyCode_0,
  VCK.KeyCode_1,
  VCK.KeyCode_2,
  VCK.KeyCode_3,
  VCK.KeyCode_4,
  VCK.KeyCode_5,
  VCK.KeyCode_6,
  VCK.KeyCode_7,
  VCK.KeyCode_8,
  VCK.KeyCode_9,
  VCK.KeyCode_NUMPAD0,
  VCK.KeyCode_NUMPAD1,
  VCK.KeyCode_NUMPAD2,
  VCK.KeyCode_NUMPAD3,
  VCK.KeyCode_NUMPAD4,
  VCK.KeyCode_NUMPAD5,
  VCK.KeyCode_NUMPAD6,
  VCK.KeyCode_NUMPAD7,
  VCK.KeyCode_NUMPAD8,
  VCK.KeyCode_NUMPAD9
}
local realNumber
local _textNumber = UI.getChildControl(Instance_Window_NumberPad, "Static_DisplayNumber")
_textNumber:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
_textNumber:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
local _txt_Title = UI.getChildControl(Instance_Window_NumberPad, "Static_Text_Title")
local _buttonClose = UI.getChildControl(_txt_Title, "Button_Close")
_buttonClose:addInputEvent("Mouse_LUp", "Panel_NumberPad_ButtonCancel_Mouse_Click()")
_buttonClose:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
_buttonClose:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
local _buttonCancel = UI.getChildControl(Instance_Window_NumberPad, "Button_Cancel")
_buttonCancel:addInputEvent("Mouse_LUp", "Panel_NumberPad_ButtonCancel_Mouse_Click()")
_buttonCancel:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
_buttonCancel:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
local _buttonClear = UI.getChildControl(Instance_Window_NumberPad, "Button_Clear")
_buttonClear:addInputEvent("Mouse_LUp", "Panel_NumberPad_ButtonClear_Mouse_Click()")
_buttonClear:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
_buttonClear:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
local _buttonBackSpace = UI.getChildControl(Instance_Window_NumberPad, "Button_Back")
_buttonBackSpace:addInputEvent("Mouse_LUp", "Panel_NumberPad_ButtonBackSpace_Mouse_Click(false)")
_buttonBackSpace:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
_buttonBackSpace:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
local _buttonConfirm = UI.getChildControl(Instance_Window_NumberPad, "Button_Apply")
_buttonConfirm:addInputEvent("Mouse_LUp", "Panel_NumberPad_ButtonConfirm_Mouse_Click()")
_buttonConfirm:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
_buttonConfirm:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
local _buttonMoneyAllSelect = UI.getChildControl(Instance_Window_NumberPad, "Button_MoneyAllSelect")
_buttonMoneyAllSelect:addInputEvent("Mouse_LUp", "Panel_NumberPad_ButtonAllSelect_Mouse_Click(0)")
_buttonMoneyAllSelect:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
_buttonMoneyAllSelect:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
local _buttonWeightAllSelect = UI.getChildControl(Instance_Window_NumberPad, "Button_WeightAllSelect")
_buttonWeightAllSelect:addInputEvent("Mouse_LUp", "Panel_NumberPad_ButtonAllSelect_Mouse_Click(2)")
_buttonWeightAllSelect:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
_buttonWeightAllSelect:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
local _checkButtonMaxCount = UI.getChildControl(Instance_Window_NumberPad, "CheckButton_MaxCount")
_checkButtonMaxCount:addInputEvent("Mouse_LUp", "Panel_NumberPad_ButtonAllSelect_Mouse_Click(1)")
_checkButtonMaxCount:SetCheck(false)
function numberPad:init()
  for ii = 1, numberPad.MAX_NUMBER_BTN_COUNT do
    local btn = UI.getChildControl(Instance_Window_NumberPad, "Button_" .. ii - 1)
    btn:addInputEvent("Mouse_LUp", "Panel_NumberPad_ButtonNumber_Mouse_Click(" .. ii - 1 .. ")")
    btn:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
    btn:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
    numberPad._buttonNumber[ii] = btn
  end
  confirmFunction = Panel_NumberPad_Default_ConfirmFunction
end
function Panel_NumberPad_CheckButtonShow(isShow)
  if isShow then
    numberPad._buttonNumber[1]:SetPosY(241)
    numberPad._buttonNumber[2]:SetPosY(203)
    numberPad._buttonNumber[3]:SetPosY(203)
    numberPad._buttonNumber[4]:SetPosY(203)
    numberPad._buttonNumber[5]:SetPosY(165)
    numberPad._buttonNumber[6]:SetPosY(165)
    numberPad._buttonNumber[7]:SetPosY(165)
    numberPad._buttonNumber[8]:SetPosY(127)
    numberPad._buttonNumber[9]:SetPosY(127)
    numberPad._buttonNumber[10]:SetPosY(127)
    _buttonBackSpace:SetPosY(241)
    _buttonClear:SetPosY(241)
    _buttonMoneyAllSelect:SetPosY(279)
    _buttonWeightAllSelect:SetPosY(279)
    _buttonConfirm:ComputePos()
    _buttonCancel:ComputePos()
  else
    numberPad._buttonNumber[1]:SetPosY(160)
    numberPad._buttonNumber[2]:SetPosY(128)
    numberPad._buttonNumber[3]:SetPosY(128)
    numberPad._buttonNumber[4]:SetPosY(128)
    numberPad._buttonNumber[5]:SetPosY(96)
    numberPad._buttonNumber[6]:SetPosY(96)
    numberPad._buttonNumber[7]:SetPosY(96)
    numberPad._buttonNumber[8]:SetPosY(64)
    numberPad._buttonNumber[9]:SetPosY(64)
    numberPad._buttonNumber[10]:SetPosY(64)
    _buttonBackSpace:SetPosY(160)
    _buttonClear:SetPosY(160)
    _buttonMoneyAllSelect:SetPosY(196)
    _buttonWeightAllSelect:SetPosY(196)
    _buttonConfirm:ComputePos()
    _buttonCancel:ComputePos()
  end
  _checkButtonMaxCount:SetShow(isShow)
end
function ExchangeNumberShowAni()
  UIAni.fadeInSCR_Down(Instance_Window_NumberPad)
end
function ExchangeNumberHideAni()
  Instance_Window_NumberPad:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Instance_Window_NumberPad:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
function Panel_NumberPad_Init(param0, confirmFunction, isShow, param1, param2)
  numberPad.param0 = param0
  numberPad.param1 = param1
  numberPad.param2 = param2
  numberPad.confirmFunction = confirmFunction
  numberPad.init_Number = true
  numberPad._type = ""
  realNumber = numberPad.s64_inputNumber
  _textNumber:SetEditText(tostring(numberPad.s64_inputNumber))
  _textNumber:SetNumberMode(true)
  numberPad:updateConfirmButton(true)
  if not Instance_Window_NumberPad:GetShow() then
    Instance_Window_NumberPad:SetPosX(getMousePosX())
    Instance_Window_NumberPad:SetPosY(getMousePosY())
  end
  local keyPadPosY = Instance_Window_NumberPad:GetPosY()
  keyPadPosY = keyPadPosY + Instance_Window_NumberPad:GetSizeY()
  if keyPadPosY > getScreenSizeY() then
    Instance_Window_NumberPad:SetPosY(getScreenSizeY() - Instance_Window_NumberPad:GetSizeY() - 30)
  end
  local keyPadPosX = Instance_Window_NumberPad:GetPosX()
  keyPadPosX = keyPadPosX + Instance_Window_NumberPad:GetSizeX()
  if keyPadPosX > getScreenSizeX() then
    Instance_Window_NumberPad:SetPosX(getScreenSizeX() - Instance_Window_NumberPad:GetSizeX())
  end
  if isShow then
    Panel_NumberPad_Open()
  end
end
function Panel_NumberPad_Open()
  if not Instance_Window_NumberPad:IsShow() then
    Instance_Window_NumberPad:SetShow(true, true)
  end
end
function Panel_NumberPad_Close()
  if Instance_Window_NumberPad:IsShow() then
    numberPad.s64_moneyMaxNumber = Defines.s64_const.s64_0
    numberPad.s64_weightMaxNumber = Defines.s64_const.s64_0
    numberPad.s64_inputNumber = Defines.s64_const.s64_0
    numberPad.param0 = nil
    numberPad.param1 = nil
    numberPad.param2 = nil
    numberPad.confirmFunction = nil
    Instance_Window_NumberPad:SetShow(false, true)
  end
end
function Panel_NumberPad_Show_Min(isShow, s64_minNumber, param0, confirmFunction, param1)
  if not isShow then
    Panel_NumberPad_Close()
    ClearFocusEdit()
  else
    numberPad.s64_moneyMaxNumber = Defines.s64_const.s64_max
    numberPad.s64_inputNumber = s64_minNumber
    Panel_NumberPad_Init(param0, confirmFunction, true, param1)
    SetFocusEdit(_textNumber)
    realNumber = numberPad.s64_moneyMaxNumber
    _textNumber:SetEditText(makeDotMoney(numberPad.s64_moneyMaxNumber))
  end
end
local _isExchange
function Panel_NumberPad_Show(isShow, s64_moneyMaxNumber, param0, confirmFunction, isExchange, param1, isItemMarket, param2, s64_weightMaxNumber)
  _buttonWeightAllSelect:SetShow(false)
  if nil ~= s64_weightMaxNumber then
    numberPad.s64_weightMaxNumber = s64_weightMaxNumber
    _buttonMoneyAllSelect:SetSize(185, 36)
    _buttonMoneyAllSelect:SetEnableArea(0, 0, 185, 36)
    _buttonMoneyAllSelect:ComputePos()
    Instance_Window_NumberPad:SetSize(205, 361)
    _buttonWeightAllSelect:SetShow(true)
  else
    numberPad.s64_weightMaxNumber = Defines.s64_const.s64_0
    _buttonMoneyAllSelect:SetSize(185, 36)
    _buttonMoneyAllSelect:SetEnableArea(0, 0, 185, 36)
    _buttonMoneyAllSelect:ComputePos()
    Instance_Window_NumberPad:SetSize(205, 361)
    _buttonWeightAllSelect:SetShow(false)
  end
  _isExchange = isExchange
  local maxLength = string.len(tostring(s64_moneyMaxNumber))
  _textNumber:SetMaxInput(maxLength + 1)
  if not isShow then
    Panel_NumberPad_Close()
    ClearFocusEdit()
  else
    numberPad.s64_moneyMaxNumber = s64_moneyMaxNumber
    numberPad.s64_weightMaxNumber = s64_weightMaxNumber
    if true == isItemMarket then
      numberPad.s64_inputNumber = s64_moneyMaxNumber
    elseif _checkButtonMaxCount:IsCheck() then
      numberPad.s64_inputNumber = s64_moneyMaxNumber
    else
      numberPad.s64_inputNumber = Defines.s64_const.s64_1
    end
    if Defines.s64_const.s64_1 == s64_moneyMaxNumber then
      Panel_NumberPad_Init(param0, confirmFunction, false, param1, param2)
      Panel_NumberPad_ButtonConfirm_Mouse_Click()
    else
      Panel_NumberPad_Init(param0, confirmFunction, true, param1, param2)
      SetFocusEdit(_textNumber)
      if true == isItemMarket then
        realNumber = s64_moneyMaxNumber
        _textNumber:SetEditText(makeDotMoney(s64_moneyMaxNumber))
      elseif _checkButtonMaxCount:IsCheck() then
        realNumber = s64_moneyMaxNumber
        _textNumber:SetEditText(makeDotMoney(s64_moneyMaxNumber))
      else
        realNumber = Defines.s64_const.s64_1
        _textNumber:SetEditText("1")
      end
    end
  end
  Panel_NumberPad_CheckButtonShow(true)
end
local slotNo, whereType
function Panel_NumberPad_Show_MaxCount(isShow, s64_maxNumber, param0, confirmFunction, isExchange, param1, isItemMarket)
  _isExchange = isExchange
  local maxLength = string.len(tostring(s64_maxNumber))
  _textNumber:SetMaxInput(maxLength + 1)
  _buttonWeightAllSelect:SetShow(false)
  if not isShow then
    Panel_NumberPad_Close()
    ClearFocusEdit()
  else
    numberPad.s64_moneyMaxNumber = s64_maxNumber
    if _checkButtonMaxCount:IsCheck() then
      numberPad.s64_inputNumber = s64_maxNumber
    else
      numberPad.s64_inputNumber = Defines.s64_const.s64_1
    end
    if Defines.s64_const.s64_1 == s64_maxNumber then
      Panel_NumberPad_Init(param0, confirmFunction, false, param1)
      Panel_NumberPad_ButtonConfirm_Mouse_Click()
    else
      Panel_NumberPad_Init(param0, confirmFunction, true, param1)
      SetFocusEdit(_textNumber)
      if _checkButtonMaxCount:IsCheck() then
        realNumber = s64_maxNumber
        _textNumber:SetEditText(makeDotMoney(s64_maxNumber))
      else
        realNumber = Defines.s64_const.s64_1
        _textNumber:SetEditText("1")
      end
    end
  end
  slotNo = param0
  whereType = param1
  Instance_Window_NumberPad:SetSize(205, 361)
  Panel_NumberPad_CheckButtonShow(true)
end
function Panel_NumberPad_SetMaxCount()
  Panel_NumberPad_Show_MaxCount(true, numberPad.s64_moneyMaxNumber, slotNo, Warehouse_PushFromInventoryItemXXX, nil, whereType)
end
function Panel_NumberPad_ButtonClose_Mouse_Click()
  Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
end
function Panel_NumberPad_ButtonCancel_Mouse_Click()
  Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
end
function numberPad:checkConfirmEnable()
  return Defines.s64_const.s64_0 < self.s64_inputNumber
end
function numberPad:updateConfirmButton(forceFlag)
  if forceFlag or self:checkConfirmEnable() then
    _buttonConfirm:SetEnable(true)
    _buttonConfirm:SetMonoTone(false)
    _buttonConfirm:SetFontColor(UI_color.C_FFFFFFFF)
  else
    _buttonConfirm:SetEnable(false)
    _buttonConfirm:SetMonoTone(true)
    _buttonConfirm:SetFontColor(UI_color.C_FFC4BEBE)
  end
end
function Panel_NumberPad_ButtonClear_Mouse_Click()
  numberPad.s64_inputNumber = Defines.s64_const.s64_0
  _textNumber:SetEditText("0")
  realNumber = numberPad.s64_inputNumber
  numberPad:updateConfirmButton()
end
function Panel_NumberPad_ButtonNumber_Mouse_Click(number)
  local newStr = _textNumber:GetEditText()
  if nil ~= number then
    newStr = newStr .. tostring(number)
  end
  newStr = string.gsub(newStr, ",", "")
  local s64_newNumber = tonumber64(newStr)
  local s64_MAX = numberPad.s64_moneyMaxNumber
  if true == numberPad.init_Number then
    numberPad.init_Number = false
    if nil == number then
      local length = strlen(newStr)
      newStr = substring(newStr, -1)
    else
      newStr = tostring(number)
    end
    s64_newNumber = tonumber64(newStr)
  end
  if s64_MAX < s64_newNumber then
    numberPad.s64_inputNumber = numberPad.s64_moneyMaxNumber
  elseif 0 == string.len(newStr) then
    _textNumber:SetEditText("0")
    numberPad.s64_inputNumber = 0
  else
    numberPad.s64_inputNumber = s64_newNumber
  end
  realNumber = numberPad.s64_inputNumber
  _textNumber:SetEditText(makeDotMoney(numberPad.s64_inputNumber))
  numberPad:updateConfirmButton(_isExchange)
end
function Panel_NumberPad_ButtonBackSpace_Mouse_Click(fromOnKey)
  local str = tostring(realNumber)
  local length = strlen(str)
  local newStr = ""
  if fromOnKey then
    if length >= 1 then
      newStr = substring(str, 1, length - 1)
      numberPad.s64_inputNumber = tonumber64(newStr)
      newStr = tostring(numberPad.s64_inputNumber)
    else
      newStr = "0"
      numberPad.init_Number = true
      numberPad.s64_inputNumber = Defines.s64_const.s64_0
    end
  elseif length > 1 then
    newStr = substring(str, 1, length - 1)
    numberPad.s64_inputNumber = tonumber64(newStr)
    newStr = tostring(numberPad.s64_inputNumber)
  else
    newStr = "0"
    numberPad.init_Number = true
    numberPad.s64_inputNumber = Defines.s64_const.s64_0
  end
  realNumber = numberPad.s64_inputNumber
  _textNumber:SetEditText(makeDotMoney(numberPad.s64_inputNumber))
  numberPad:updateConfirmButton()
end
function Panel_NumberPad_ButtonConfirm_Mouse_Click()
  if numberPad:checkConfirmEnable() or _isExchange == true then
    if nil ~= numberPad.confirmFunction then
      numberPad.confirmFunction(numberPad.s64_inputNumber, numberPad.param0, numberPad.param1, numberPad.param2)
    end
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  end
end
function Panel_NumberPad_ButtonAllSelect_Mouse_Click(isType)
  if 1 == isType then
    numberPad.s64_inputNumber = numberPad.s64_moneyMaxNumber
    if not _checkButtonMaxCount:IsCheck() then
      SetFocusEdit(_textNumber)
      _textNumber:SetEditText(tostring(Defines.s64_const.s64_1))
      realNumber = Defines.s64_const.s64_1
      numberPad.s64_inputNumber = Defines.s64_const.s64_1
    else
      SetFocusEdit(_textNumber)
      _textNumber:SetEditText(makeDotMoney(numberPad.s64_moneyMaxNumber))
      realNumber = numberPad.s64_moneyMaxNumber
    end
  elseif 0 == isType then
    numberPad.s64_inputNumber = numberPad.s64_moneyMaxNumber
    if Defines.s64_const.s64_1 == numberPad.s64_maxNumber then
      Panel_NumberPad_ButtonConfirm_Mouse_Click()
    else
      SetFocusEdit(_textNumber)
      _textNumber:SetEditText(makeDotMoney(numberPad.s64_moneyMaxNumber))
      realNumber = numberPad.s64_moneyMaxNumber
    end
  elseif 2 == isType then
    numberPad.s64_inputNumber = numberPad.s64_weightMaxNumber
    if Defines.s64_const.s64_1 == numberPad.s64_weightMaxNumber then
      Panel_NumberPad_ButtonConfirm_Mouse_Click()
    else
      SetFocusEdit(_textNumber)
      _textNumber:SetEditText(makeDotMoney(numberPad.s64_weightMaxNumber))
      realNumber = numberPad.s64_weightMaxNumber
    end
  end
  numberPad:updateConfirmButton()
end
function Panel_NumberPad_Mouse_Scroll_Event(isUp)
  local currentNumber_s32 = Int64toInt32(realNumber)
  local currentNumber_s64 = toInt64(0, currentNumber_s32)
  local inputNumber_s64 = currentNumber_s64
  if true == isUp then
    if currentNumber_s64 >= numberPad.s64_moneyMaxNumber then
      return
    end
    inputNumber_s64 = currentNumber_s64 + toInt64(0, 1)
  elseif false == isUp then
    if currentNumber_s32 <= 1 then
      return
    end
    inputNumber_s64 = currentNumber_s64 - toInt64(0, 1)
  end
  _textNumber:SetEditText(makeDotMoney(inputNumber_s64))
  numberPad.s64_inputNumber = inputNumber_s64
  realNumber = numberPad.s64_inputNumber
end
function Panel_NumberPad_Default_ConfirmFunction(count, param0, param1)
  Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
end
function Panel_NumberPad_IsPopUp()
  return Instance_Window_NumberPad:IsShow()
end
function Panel_NumberPad_IsType(_type)
  return numberPad._type == _type
end
function Panel_NumberPad_SetType(_type)
  numberPad._type = _type
end
function Panel_NumberPad_NumberKey_Input()
  for idx, val in ipairs(numberKeyCode) do
    if isKeyDown_Once(val) then
      Panel_NumberPad_ButtonNumber_Mouse_Click(nil)
    end
  end
  if isKeyDown_Once(VCK.KeyCode_BACK) or isKeyDown_Once(VCK.KeyCode_DELETE) then
    Panel_NumberPad_ButtonBackSpace_Mouse_Click(true)
  end
end
Instance_Window_NumberPad:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
Instance_Window_NumberPad:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
numberPad:init()

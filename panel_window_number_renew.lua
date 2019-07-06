Panel_Window_Exchange_Number:ignorePadSnapMoveToOtherPanel()
Panel_Window_Exchange_Number:SetShow(false, false)
Panel_Window_Exchange_Number:setMaskingChild(true)
Panel_Window_Exchange_Number:ActiveMouseEventEffect(true)
Panel_Window_Exchange_Number:setGlassBackground(true)
Panel_Window_Exchange_Number:RegisterShowEventFunc(true, "ExchangeNumberShowAni()")
Panel_Window_Exchange_Number:RegisterShowEventFunc(false, "ExchangeNumberHideAni()")
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
local _edit_Number = UI.getChildControl(Panel_Window_Exchange_Number, "Edit_Number")
_edit_Number:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
_edit_Number:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
local _button_Clear = UI.getChildControl(Panel_Window_Exchange_Number, "Button_Clear")
_button_Clear:addInputEvent("Mouse_LUp", "Panel_NumberPad_ButtonClear_Mouse_Click()")
_button_Clear:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
_button_Clear:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
local _button_Back = UI.getChildControl(Panel_Window_Exchange_Number, "Button_Back")
_button_Back:addInputEvent("Mouse_LUp", "Panel_NumberPad_ButtonBackSpace_Mouse_Click(false)")
_button_Back:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
_button_Back:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
local _checkButton_MaxCount = UI.getChildControl(Panel_Window_Exchange_Number, "CheckButton_MaxCount")
_checkButton_MaxCount:addInputEvent("Mouse_LUp", "Panel_NumberPad_ButtonAllSelect_Mouse_Click(1)")
if false == _ContentsGroup_RenewUI_Number then
  _checkButton_MaxCount:SetShow(true)
else
  _checkButton_MaxCount:SetShow(false)
end
local _button_AllCount = UI.getChildControl(Panel_Window_Exchange_Number, "Button_All")
_button_AllCount:addInputEvent("Mouse_LUp", "Panel_NumberPad_ButtonAllSelect_Mouse_Click(1)")
function numberPad:init()
  for ii = 1, numberPad.MAX_NUMBER_BTN_COUNT do
    local btn = UI.getChildControl(Panel_Window_Exchange_Number, "Button_" .. ii - 1)
    btn:addInputEvent("Mouse_LUp", "Panel_NumberPad_ButtonNumber_Mouse_Click(" .. ii - 1 .. ")")
    btn:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
    btn:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
    numberPad._buttonNumber[ii] = btn
  end
  confirmFunction = Panel_NumberPad_Default_ConfirmFunction
  self:adjustKeyGuidePos()
end
function numberPad:adjustKeyGuidePos()
  local keyGuideBG = UI.getChildControl(Panel_Window_Exchange_Number, "Static_BottomBG")
  local YConsoleUI = UI.getChildControl(keyGuideBG, "StaticText_Confirm_ConsoleUI")
  local BConsoleUI = UI.getChildControl(keyGuideBG, "StaticText_Cancel_ConsoleUI")
  local bgSizeX = keyGuideBG:GetSizeX()
  local totalX = YConsoleUI:GetTextSizeX() + BConsoleUI:GetTextSizeX() + 88
  if bgSizeX > totalX then
    local _keyGuideAlign = {YConsoleUI, BConsoleUI}
    local gapX = (bgSizeX - totalX) / 3
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(_keyGuideAlign, keyGuideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, 44, gapX)
  else
    local _panel = Panel_Window_Exchange_Number
    _panel:SetSize(_panel:GetSizeX(), _panel:GetSizeY() + 30)
    YConsoleUI:SetPosX(20)
    BConsoleUI:SetPosX(20)
    BConsoleUI:SetPosY(BConsoleUI:GetPosY() + 35)
  end
end
function Panel_Numberpad_Initialize()
  local self = numberPad
  self:init()
end
function Panel_NumberPad_CheckButtonShow()
  numberPad._buttonNumber[1]:ComputePos()
  numberPad._buttonNumber[2]:ComputePos()
  numberPad._buttonNumber[3]:ComputePos()
  numberPad._buttonNumber[4]:ComputePos()
  numberPad._buttonNumber[5]:ComputePos()
  numberPad._buttonNumber[6]:ComputePos()
  numberPad._buttonNumber[7]:ComputePos()
  numberPad._buttonNumber[8]:ComputePos()
  numberPad._buttonNumber[9]:ComputePos()
  numberPad._buttonNumber[10]:ComputePos()
  _button_Back:ComputePos()
  _button_Clear:ComputePos()
  if false == _ContentsGroup_RenewUI_Number then
    _checkButton_MaxCount:SetShow(true)
  else
    _checkButton_MaxCount:SetShow(false)
  end
end
function ExchangeNumberShowAni()
  UIAni.fadeInSCR_Down(Panel_Window_Exchange_Number)
end
function ExchangeNumberHideAni()
  Panel_Window_Exchange_Number:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_Exchange_Number:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
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
  _edit_Number:SetEditText(tostring(numberPad.s64_inputNumber))
  _edit_Number:SetNumberMode(true)
  numberPad:updateConfirmButton(true)
  if not Panel_Window_Exchange_Number:GetShow() then
    local snappedControl = ToClient_getSnappedControl()
    if nil ~= snappedControl then
      Panel_Window_Exchange_Number:SetPosX(getMousePosX())
      Panel_Window_Exchange_Number:SetPosY(getMousePosY())
    else
      Panel_Window_Exchange_Number:SetPosX(getScreenSizeX() / 2 - Panel_Window_Exchange_Number:GetSizeX() / 2)
      Panel_Window_Exchange_Number:SetPosY(getScreenSizeY() / 2 - Panel_Window_Exchange_Number:GetSizeY() / 2)
    end
  end
  local keyPadPosY = Panel_Window_Exchange_Number:GetPosY()
  keyPadPosY = keyPadPosY + Panel_Window_Exchange_Number:GetSizeY()
  if keyPadPosY > getScreenSizeY() then
    Panel_Window_Exchange_Number:SetPosY(getScreenSizeY() - Panel_Window_Exchange_Number:GetSizeY() - 30)
  end
  local keyPadPosX = Panel_Window_Exchange_Number:GetPosX()
  keyPadPosX = keyPadPosX + Panel_Window_Exchange_Number:GetSizeX()
  if keyPadPosX > getScreenSizeX() then
    Panel_Window_Exchange_Number:SetPosX(getScreenSizeX() - Panel_Window_Exchange_Number:GetSizeX())
  end
  if _ContentsGroup_isConsolePadControl then
    _edit_Number:SetIgnore(true)
  end
  if isShow then
    Panel_NumberPad_Open()
  end
end
function Panel_NumberPad_Open()
  if not Panel_Window_Exchange_Number:IsShow() then
    Panel_Window_Exchange_Number:SetShow(true, true)
  end
end
function Panel_NumberPad_Close()
  if Panel_Window_Exchange_Number:IsShow() then
    numberPad.s64_moneyMaxNumber = Defines.s64_const.s64_0
    numberPad.s64_weightMaxNumber = Defines.s64_const.s64_0
    numberPad.s64_inputNumber = Defines.s64_const.s64_0
    numberPad.param0 = nil
    numberPad.param1 = nil
    numberPad.param2 = nil
    numberPad.confirmFunction = nil
    Panel_Window_Exchange_Number:SetShow(false, true)
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
    if false == _ContentsGroup_isConsolePadControl then
      SetFocusEdit(edit_Number)
    end
    realNumber = numberPad.s64_moneyMaxNumber
    _edit_Number:SetEditText(makeDotMoney(numberPad.s64_moneyMaxNumber))
  end
end
local _isExchange
function Panel_NumberPad_Show(isShow, s64_moneyMaxNumber, param0, confirmFunction, isExchange, param1, isItemMarket, param2, s64_weightMaxNumber)
  if nil ~= s64_weightMaxNumber then
    numberPad.s64_weightMaxNumber = s64_weightMaxNumber
  else
    numberPad.s64_weightMaxNumber = Defines.s64_const.s64_0
  end
  _isExchange = isExchange
  local maxLength = string.len(tostring(s64_moneyMaxNumber))
  _edit_Number:SetMaxInput(maxLength + 1)
  if not isShow then
    Panel_NumberPad_Close()
    ClearFocusEdit()
  else
    numberPad.s64_moneyMaxNumber = s64_moneyMaxNumber
    if nil ~= s64_weightMaxNumber then
      numberPad.s64_weightMaxNumber = s64_weightMaxNumber
    else
      numberPad.s64_weightMaxNumber = Defines.s64_const.s64_0
    end
    if true == isItemMarket then
      numberPad.s64_inputNumber = s64_moneyMaxNumber
    else
      local value
      if Defines.s64_const.s64_0 ~= numberPad.s64_weightMaxNumber and Defines.s64_const.s64_0 ~= numberPad.s64_moneyMaxNumber then
        if numberPad.s64_weightMaxNumber < numberPad.s64_moneyMaxNumber then
          value = numberPad.s64_weightMaxNumber
        else
          value = numberPad.s64_moneyMaxNumber
        end
      elseif numberPad.s64_weightMaxNumber < numberPad.s64_moneyMaxNumber then
        value = numberPad.s64_moneyMaxNumber
      else
        value = numberPad.s64_weightMaxNumber
      end
      if _checkButton_MaxCount:IsCheck() then
        numberPad.s64_inputNumber = value
      else
        numberPad.s64_inputNumber = Defines.s64_const.s64_1
      end
    end
    if Defines.s64_const.s64_1 == s64_moneyMaxNumber then
      Panel_NumberPad_Init(param0, confirmFunction, false, param1, param2)
      Panel_NumberPad_ButtonConfirm_Mouse_Click()
    else
      Panel_NumberPad_Init(param0, confirmFunction, true, param1, param2)
      if false == _ContentsGroup_isConsolePadControl then
        SetFocusEdit(_edit_Number)
      end
      if true == isItemMarket then
        realNumber = s64_moneyMaxNumber
        _edit_Number:SetEditText(makeDotMoney(s64_moneyMaxNumber))
      else
        local value
        if Defines.s64_const.s64_0 ~= numberPad.s64_weightMaxNumber and Defines.s64_const.s64_0 ~= numberPad.s64_moneyMaxNumber then
          if numberPad.s64_weightMaxNumber < numberPad.s64_moneyMaxNumber then
            value = numberPad.s64_weightMaxNumber
          else
            value = numberPad.s64_moneyMaxNumber
          end
        elseif numberPad.s64_weightMaxNumber < numberPad.s64_moneyMaxNumber then
          value = numberPad.s64_moneyMaxNumber
        else
          value = numberPad.s64_weightMaxNumber
        end
        if _checkButton_MaxCount:IsCheck() then
          _checkButton_MaxCount:SetCheck(true)
          _edit_Number:SetEditText(makeDotMoney(value))
          realNumber = value
        else
          _checkButton_MaxCount:SetCheck(false)
          _edit_Number:SetEditText(makeDotMoney(Defines.s64_const.s64_1))
          realNumber = Defines.s64_const.s64_1
        end
      end
    end
  end
  Panel_NumberPad_CheckButtonShow(true)
end
local slotNo, whereType
function Panel_NumberPad_Show_MaxCount(isShow, s64_maxNumber, param0, confirmFunction, isExchange, param1, isItemMarket)
  _isExchange = isExchange
  local maxLength = string.len(tostring(s64_maxNumber))
  _edit_Number:SetMaxInput(maxLength + 1)
  if not isShow then
    Panel_NumberPad_Close()
    ClearFocusEdit()
  else
    numberPad.s64_weightMaxNumber = Defines.s64_const.s64_0
    numberPad.s64_moneyMaxNumber = s64_maxNumber
    if _checkButton_MaxCount:IsCheck() then
      numberPad.s64_inputNumber = s64_maxNumber
    else
      numberPad.s64_inputNumber = Defines.s64_const.s64_1
    end
    if Defines.s64_const.s64_1 == s64_maxNumber then
      Panel_NumberPad_Init(param0, confirmFunction, false, param1)
      Panel_NumberPad_ButtonConfirm_Mouse_Click()
    else
      Panel_NumberPad_Init(param0, confirmFunction, true, param1)
      if false == _ContentsGroup_isConsolePadControl then
        SetFocusEdit(_edit_Number)
      end
      if _checkButton_MaxCount:IsCheck() then
        realNumber = s64_maxNumber
        _edit_Number:SetEditText(makeDotMoney(s64_maxNumber))
      else
        realNumber = Defines.s64_const.s64_1
        _edit_Number:SetEditText("1")
      end
    end
  end
  slotNo = param0
  whereType = param1
  Panel_NumberPad_CheckButtonShow(true)
end
function Panel_NumberPad_SetMaxCount()
  Panel_NumberPad_Show_MaxCount(true, numberPad.s64_moneyMaxNumber, slotNo, Warehouse_PushFromInventoryItemXXX, nil, whereType)
end
function Panel_NumberPad_ButtonClose_Mouse_Click()
  Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
end
function Panel_NumberPad_ButtonCancel_Mouse_Click()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
end
function numberPad:checkConfirmEnable()
  return Defines.s64_const.s64_0 < self.s64_inputNumber
end
function numberPad:updateConfirmButton(forceFlag)
end
function Panel_NumberPad_ButtonClear_Mouse_Click()
  numberPad.s64_inputNumber = Defines.s64_const.s64_0
  _edit_Number:SetEditText("0")
  realNumber = numberPad.s64_inputNumber
  numberPad:updateConfirmButton()
end
function Panel_NumberPad_ButtonNumber_Mouse_Click(number)
  local newStr = _edit_Number:GetEditText()
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
    _edit_Number:SetEditText("0")
    numberPad.s64_inputNumber = 0
  else
    numberPad.s64_inputNumber = s64_newNumber
  end
  realNumber = numberPad.s64_inputNumber
  _edit_Number:SetEditText(makeDotMoney(numberPad.s64_inputNumber))
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
  _edit_Number:SetEditText(makeDotMoney(numberPad.s64_inputNumber))
  numberPad:updateConfirmButton()
end
function Panel_NumberPad_ButtonConfirm_Mouse_Click()
  if numberPad:checkConfirmEnable() or _isExchange == true then
    if nil ~= numberPad.confirmFunction then
      numberPad.confirmFunction(numberPad.s64_inputNumber, numberPad.param0, numberPad.param1, numberPad.param2)
    end
    if true == PaGlobalFunc_MoveMoneyCheck(false) then
      _AudioPostEvent_SystemUiForXBOX(6, 4)
      PaGlobalFunc_MoveMoneyCheck(true)
    else
      _AudioPostEvent_SystemUiForXBOX(1, 1)
    end
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  end
end
function Panel_NumberPad_Button_AutoAll_Mouse_Click()
  local value
  if Defines.s64_const.s64_0 ~= numberPad.s64_weightMaxNumber and Defines.s64_const.s64_0 ~= numberPad.s64_moneyMaxNumber then
    if numberPad.s64_weightMaxNumber < numberPad.s64_moneyMaxNumber then
      value = numberPad.s64_weightMaxNumber
    else
      value = numberPad.s64_moneyMaxNumber
    end
  elseif numberPad.s64_weightMaxNumber < numberPad.s64_moneyMaxNumber then
    value = numberPad.s64_moneyMaxNumber
  else
    value = numberPad.s64_weightMaxNumber
  end
  numberPad.s64_inputNumber = value
  if false == _ContentsGroup_isConsolePadControl then
    SetFocusEdit(_edit_Number)
  end
  _edit_Number:SetEditText(makeDotMoney(value))
  realNumber = value
  numberPad:updateConfirmButton()
end
function Panel_NumberPad_ButtonAllSelect_Mouse_Click(isType)
  if 1 == isType then
    numberPad.s64_inputNumber = numberPad.s64_moneyMaxNumber
    if false == _ContentsGroup_isConsolePadControl then
      SetFocusEdit(_edit_Number)
    end
    _edit_Number:SetEditText(makeDotMoney(numberPad.s64_moneyMaxNumber))
    realNumber = numberPad.s64_moneyMaxNumber
  elseif 0 == isType then
    numberPad.s64_inputNumber = numberPad.s64_moneyMaxNumber
    if Defines.s64_const.s64_1 == numberPad.s64_maxNumber then
    else
      if false == _ContentsGroup_isConsolePadControl then
        SetFocusEdit(_edit_Number)
      end
      _edit_Number:SetEditText(makeDotMoney(numberPad.s64_moneyMaxNumber))
      realNumber = numberPad.s64_moneyMaxNumber
    end
  elseif 2 == isType then
    numberPad.s64_inputNumber = numberPad.s64_weightMaxNumber
    if Defines.s64_const.s64_1 == numberPad.s64_weightMaxNumber then
    else
      if false == _ContentsGroup_isConsolePadControl then
        SetFocusEdit(_edit_Number)
      end
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
  _edit_Number:SetEditText(makeDotMoney(inputNumber_s64))
  numberPad.s64_inputNumber = inputNumber_s64
  realNumber = numberPad.s64_inputNumber
end
function Panel_NumberPad_Default_ConfirmFunction(count, param0, param1)
  Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
end
function Panel_NumberPad_IsPopUp()
  return Panel_Window_Exchange_Number:IsShow()
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
Panel_Window_Exchange_Number:addInputEvent("Mouse_UpScroll", "Panel_NumberPad_Mouse_Scroll_Event(true)")
Panel_Window_Exchange_Number:addInputEvent("Mouse_DownScroll", "Panel_NumberPad_Mouse_Scroll_Event(false)")
registerEvent("FromClient_luaLoadComplete", "Panel_Numberpad_Initialize")

local CONTROL = CppEnums.PA_UI_CONTROL_TYPE
function PaGlobal_Option:CreateFrame(category, detail)
  local optionFrame = {
    _category = category,
    _detail = detail,
    _uiFrame = nil,
    _uiFrameContent = nil,
    _uiScroll = nil
  }
  optionFrame._uiFrame = UI.getChildControl(Panel_Window_cOption, "Frame_" .. category .. "_" .. detail)
  optionFrame._uiFrameContent = optionFrame._uiFrame:GetFrameContent()
  optionFrame._uiScroll = optionFrame._uiFrame:GetVScroll()
  if nil ~= self._frames[category][detail] then
    optionFrame._uiFrameContent:MoveChilds(optionFrame._uiFrameContent:GetID(), self._frames[category][detail])
  end
  UIScroll.SetButtonSize(optionFrame._uiScroll, optionFrame._uiFrame:GetSizeY(), optionFrame._uiFrameContent:GetSizeY())
  optionFrame._uiFrame:SetShow(false)
  return optionFrame
end
function PaGlobal_Option:CreateEventControl(category, detail)
  local FRAME_CHILD_MAX = 15
  local RADIO_CHILD_MAX = 10
  local frame = self._frames[category][detail]
  frame._containElement = {}
  local lastElement = UI.getChildControlByIndex(frame._uiFrameContent, frame._uiFrameContent:getChildControlCount() - 1)
  local limitFrameSizeY = lastElement:GetSpanSize().y + lastElement:GetSizeY()
  limitFrameSizeY = limitFrameSizeY * 0.55
  local curAccumulateSize = 0
  local curAccumulateFrameSize = 0
  function CreateEventControlXXX(parent, control, controlTypeName, elementName)
    local controlName = controlTypeName .. "_" .. elementName
    local eventType = self:GetEventTypeText(self._elements[elementName]._controlType)
    local isRadioButton = CONTROL.PA_UI_CONTROL_RADIOBUTTON == self._elements[elementName]._controlType
    local isSliderButton = CONTROL.PA_UI_CONTROL_SLIDER == self._elements[elementName]._controlType
    local isButton = CONTROL.PA_UI_CONTROL_BUTTON == self._elements[elementName]._controlType
    local isComboBox = CONTROL.PA_UI_CONTROL_COMBOBOX == self._elements[elementName]._controlType
    local isCheckButton = CONTROL.PA_UI_CONTROL_CHECKBUTTON == self._elements[elementName]._controlType
    if nil == control then
      _PA_LOG("\237\155\132\236\167\132", "Control\236\157\180 \236\160\156\235\140\128\235\161\156 \236\132\164\236\160\149\236\157\180 \235\144\152\236\167\128 \236\149\138\236\149\152\236\138\181\235\139\136\235\139\164. Xml\236\157\132 \237\153\149\236\157\184\237\149\180\236\163\188\236\132\184\236\154\148. // Element Name : " .. controlName)
      return
    end
    if nil == self._elements[elementName]._eventControl then
      self._elements[elementName]._eventControl = {}
    end
    if nil == self._elements[elementName]._isScrollEnd then
      self._elements[elementName]._isScrollEnd = {}
    end
    local eventControl = self._elements[elementName]._eventControl
    local order = #eventControl + 1
    local functionText = "PaGlobal_Option:EventXXX(" .. "\"" .. controlName .. "\"" .. ", " .. order .. ", 0  ) "
    eventControl[order] = control
    eventControl[order]:addInputEvent(eventType, functionText)
    curAccumulateSize = curAccumulateFrameSize + control:GetSpanSize().y
    self._elements[elementName]._isScrollEnd[order] = limitFrameSizeY < curAccumulateSize
    if true == isCheckButton or true == isRadioButton then
      eventControl[order]:SetEnableArea(0, 0, eventControl[order]:GetSizeX() + eventControl[order]:GetTextSizeX(), eventControl[order]:GetSizeY())
    end
    if true == isSliderButton then
      if nil == self._elements[elementName]._curvalueControl then
        self._elements[elementName]._curvalueControl = {}
      end
      local sliderButton = UI.getChildControlNoneAssert(eventControl[order], "Slider_Button")
      sliderButton:addInputEvent(eventType, functionText)
      sliderButton:addInputEvent("Mouse_LUp", functionText)
      self._elements[elementName]._curvalueControl[order] = UI.getChildControlNoneAssert(parent, "StaticText_Current_" .. elementName)
    end
    if true == isComboBox then
      eventControl[order]:setListTextHorizonCenter()
      eventControl[order]:addInputEvent("Mouse_LUp", "PaGlobal_Option:EventComboBoxOpenXXX(" .. "\"" .. elementName .. "\"" .. ", " .. order .. " ) ")
      eventControl[order]:GetListControl():addInputEvent("Mouse_LUp", "PaGlobal_Option:EventXXX(" .. "\"" .. controlName .. "\"" .. ", " .. order .. " ) ")
      parent:getParent():SetChildIndex(parent, 9999)
    end
    if true == isButton then
      if nil == self._elements[elementName]._eventControlLeft or nil == self._elements[elementName]._eventControlRight then
        self._elements[elementName]._eventControlLeft = {}
        self._elements[elementName]._eventControlRight = {}
      end
      local eventControlLeft = self._elements[elementName]._eventControlLeft
      local eventControlRight = self._elements[elementName]._eventControlRight
      eventControlLeft[order] = UI.getChildControlNoneAssert(parent, controlName .. "Left")
      eventControlLeft[order]:addInputEvent(eventType, "PaGlobal_Option:EventXXX(" .. "\"" .. controlName .. "\"" .. ", " .. order .. ", 1 ) ")
      eventControlRight[order] = UI.getChildControlNoneAssert(parent, controlName .. "Right")
      eventControlRight[order]:addInputEvent(eventType, "PaGlobal_Option:EventXXX(" .. "\"" .. controlName .. "\"" .. ", " .. order .. ", 2 ) ")
    end
    for radioIndex = 1, RADIO_CHILD_MAX do
      if false == isRadioButton then
        break
      end
      local controlNameParam = controlName .. radioIndex
      local elemParam = UI.getChildControlNoneAssert(parent, controlNameParam)
      if nil == elemParam then
        break
      end
      if nil == self._elements[elementName]["_eventControl" .. radioIndex] then
        self._elements[elementName]["_eventControl" .. radioIndex] = {}
      end
      local eventControlParam = self._elements[elementName]["_eventControl" .. radioIndex]
      local order2 = #eventControlParam + 1
      local functionTextParam = "PaGlobal_Option:EventXXX(" .. "\"" .. controlName .. "\"" .. ", " .. order .. ", " .. radioIndex .. " ) "
      eventControlParam[order2] = elemParam
      eventControlParam[order2]:addInputEvent(eventType, functionTextParam)
      eventControlParam[order2]:SetEnableArea(0, 0, eventControlParam[order2]:GetSizeX() + eventControlParam[order2]:GetTextSizeX() + 10, eventControlParam[order2]:GetSizeY())
      self._elements[elementName]._eventControlCount = radioIndex
    end
    if true == self._elements[elementName]._isPictureTooltipOn then
      self:SetPictureToolTip(elementName, parent, order)
    end
    self:SpecialCreateRadioButton(elementName)
  end
  if _ContentsGroup_isConsolePadControl then
    local bg = UI.getChildControlNoneAssert(frame._uiFrameContent, "StaticText_OptionDescBg_Import")
    if nil ~= bg then
      local checkbutton_On = UI.getChildControlNoneAssert(bg, "CheckButton_On")
      local checkbutton_Off = UI.getChildControlNoneAssert(bg, "CheckButton_Off")
      checkbutton_On:SetShow(false)
      checkbutton_Off:SetShow(false)
    end
  end
  for frameIndex = 0, FRAME_CHILD_MAX do
    local bg = UI.getChildControlNoneAssert(frame._uiFrameContent, "StaticText_BgOrder" .. frameIndex .. "_Import")
    if nil == bg then
      break
    end
    curAccumulateFrameSize = bg:GetSpanSize().y
    curAccumulateSize = curAccumulateFrameSize
    local childCount = bg:getChildControlCount()
    for childIdx = 0, childCount - 1 do
      local child = UI.getChildControlByIndex(bg, childIdx)
      local childName = child:GetID()
      local strsplit = string.split(childName, "_")
      local controlname = strsplit[1]
      local elementName = strsplit[2]
      local desc = strsplit[3]
      self:FPSTextSetting(childName, child)
      if nil ~= elementName and nil ~= self._elements[elementName] and nil ~= controlname and nil ~= self:GetControlTypeByControlName(controlname) then
        CreateEventControlXXX(bg, child, controlname, elementName)
        frame._containElement[#frame._containElement + 1] = elementName
        local option = self._elements[elementName]
        option._string = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_" .. elementName)
        if nil == option._category then
          option._category = {}
        end
        local categories = option._category
        local order = #option._category + 1
        option._category[order] = {}
        option._category[order]._find = category
        option._category[order]._string = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_" .. category)
        if nil == option._detail then
          option._detail = {}
        end
        option._detail[order] = {}
        option._detail[order]._find = detail
        option._detail[order]._string = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_" .. category .. "_" .. detail)
      elseif nil ~= elementName and nil ~= self._elements[elementName] and nil ~= desc and "Desc" == desc then
        child:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
        child:SetText(child:GetText())
      elseif nil == elementName or nil ~= self._elements[elementName] then
      end
    end
  end
end
function PaGlobal_Option:SetPictureToolTip(elementName, parent, order)
  if true ~= self._elements[elementName]._isPictureTooltipOn then
    return
  end
  if nil == parent then
    return
  end
  local pictureTooltip = UI.getChildControlNoneAssert(parent, "Static_Tooltip_" .. elementName)
  if nil == pictureTooltip then
    return
  end
  if nil == self._elements[elementName]._pictureTooltipControl then
    self._elements[elementName]._pictureTooltipControl = {}
  end
  self._elements[elementName]._pictureTooltipControl[order] = pictureTooltip
  pictureTooltip:SetShow(false)
  local eventControl = self._elements[elementName]._eventControl[order]
  eventControl:addInputEvent("Mouse_On", "PaGlobal_Option:OnPictureToolTip(" .. "\"" .. elementName .. "\"" .. " ," .. order .. ")")
  eventControl:addInputEvent("Mouse_Out", "PaGlobal_Option:OutPictureToolTip(" .. "\"" .. elementName .. "\"" .. " ," .. order .. ")")
  local RADIO_CHILD_MAX = 10
  for radioIndex = 1, RADIO_CHILD_MAX do
    local radioChildEventControl = self._elements[elementName]["_eventControl" .. radioIndex]
    if nil == radioChildEventControl then
      break
    end
    local eventControl = radioChildEventControl[order]
    eventControl:addInputEvent("Mouse_On", "PaGlobal_Option:OnPictureToolTip(" .. "\"" .. elementName .. "\"" .. " ," .. order .. ")")
    eventControl:addInputEvent("Mouse_Out", "PaGlobal_Option:OutPictureToolTip(" .. "\"" .. elementName .. "\"" .. " ," .. order .. ")")
  end
end
function PaGlobal_Option:OnPictureToolTip(elementName, index)
  self._elements[elementName]._pictureTooltipControl[index]:SetShow(true)
end
function PaGlobal_Option:OutPictureToolTip(elementName, index)
  self._elements[elementName]._pictureTooltipControl[index]:SetShow(false)
end
function PaGlobal_Option:FPSTextSetting(childName, element)
  if nil == element or nil == childName then
    return
  end
  if "StaticText_FPS" == childName then
    self._fpsTextControl[#self._fpsTextControl + 1] = element
  end
end
function PaGlobal_Option:SetXXX(elementName, value)
  if nil == self._functions[elementName] then
    return false
  end
  if nil == value then
    return false
  end
  local executeResult = self._functions[elementName](value)
  if false == executeResult then
    return false
  end
  local opiton = self._elements[elementName]
  opiton._applyValue = value
  opiton._curValue = nil
  self:SetControlSetting(elementName, value)
end
function PaGlobal_Option:EventComboBoxOpenXXX(elementName, controlIndex)
  local option = self._elements[elementName]
  if option._controlType ~= CONTROL.PA_UI_CONTROL_COMBOBOX then
    _PA_LOG("\237\155\132\236\167\132", "[EventComboBoxOpenXXX][ RETURN ] combobox\234\176\128 \236\149\132\235\139\136\235\169\180 \236\151\172\234\184\176 \235\147\164\236\150\180\236\152\164\235\169\180 \236\149\136\235\144\169\235\139\136\235\139\164. controlType\236\157\132 \237\153\149\236\157\184\237\149\180\236\163\188\236\132\184\236\154\148. : " .. elementName)
    return
  end
  if option._comboBoxListCount == nil then
    _PA_LOG("\237\155\132\236\167\132", "[EventComboBoxOpenXXX][ RETURN ] _comboBoxListCount \234\176\128 \236\133\139\237\140\133 \235\144\152\236\167\128 \236\149\138\236\149\152\236\138\181\235\139\136\235\139\164. SpectialControlComboBoxInitValue() \236\151\144\236\132\156 \236\178\152\235\166\172\237\149\180\236\163\188\236\132\184\236\154\148.: " .. elementName)
    return
  end
  if option._comboBoxList == nil then
    _PA_LOG("\237\155\132\236\167\132", "[EventComboBoxOpenXXX][ RETURN ] _comboBoxList table \236\157\180 \236\133\139\237\140\133 \235\144\152\236\167\128 \236\149\138\236\149\152\236\138\181\235\139\136\235\139\164. SpectialControlComboBoxInitValue() \236\151\144\236\132\156 \236\178\152\235\166\172\237\149\180\236\163\188\236\132\184\236\154\148. : " .. elementName)
    return
  end
  local combo = option._eventControl[controlIndex]
  combo:DeleteAllItem()
  for index = 0, option._comboBoxListCount - 1 do
    combo:AddItem(option._comboBoxList[index], index)
  end
  combo:ToggleListbox()
  combo:SetShow(true)
end
function PaGlobal_Option:EventXXX(controlName, controlIndex, order, param)
  local strsplit = string.split(controlName, "_")
  if nil == strsplit[1] or nil == strsplit[2] then
    _PA_LOG("\237\155\132\236\167\132", "[EventXXX][ RETURN ] control\236\157\152 \235\178\132\237\138\188 \236\157\180\235\178\164\237\138\184\234\176\128 \236\158\152\235\170\187\235\144\152\236\151\136\236\138\181\235\139\136\235\139\164. ControlName\236\157\132 \237\153\149\236\157\184\237\149\180\236\163\188\236\132\184\236\154\148. : " .. elementName)
    return
  end
  local controlTypeName = strsplit[1]
  local elementName = strsplit[2]
  local option = self._elements[elementName]
  if "table" ~= type(option) then
    _PA_LOG("\237\155\132\236\167\132", "[EventXXX][ RETURN ] element \234\176\128 \237\133\140\236\157\180\235\184\148\236\157\180 \236\149\132\235\139\153\235\139\136\235\139\164. Header \235\165\188 \237\153\149\236\157\184\237\149\180\236\163\188\236\132\184\236\154\148.  : " .. elementName)
    return
  end
  local beforeValue = option._curValue
  local controlType = self:GetControlTypeByControlName(controlTypeName)
  if CONTROL.PA_UI_CONTROL_CHECKBUTTON == controlType then
    option._curValue = option._eventControl[controlIndex]:IsCheck()
  elseif CONTROL.PA_UI_CONTROL_RADIOBUTTON == controlType and (nil ~= option.actionInputType or nil ~= option.uiInputType) then
    self:SetKeyCustomMode(elementName)
    self:SetControlSetting(elementName, "")
  elseif CONTROL.PA_UI_CONTROL_RADIOBUTTON == controlType then
    for i, eventControl in pairs(option._eventControl) do
      eventControl:SetCheck(false)
    end
    for index = 1, option._eventControlCount do
      for _, eventControl in pairs(self._elements[elementName]["_eventControl" .. index]) do
        eventControl:SetCheck(false)
      end
    end
    option._curValue = order
    if "RadioButton_GraphicOption" == controlName and (1 == controlIndex or 2 == controlIndex) then
      if 7 == order then
        local messageBoxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_GRAPHICMODE_ALERTTITLE"),
          content = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_GRAPHICMODE_ALERTDESC"),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageBoxData)
      elseif 8 == order then
        local messageBoxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_GRAPHICMODE_ALERTTITLE"),
          content = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_GRAPHICMODE_ALERTDESC2"),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageBoxData)
      end
    end
  elseif CONTROL.PA_UI_CONTROL_SLIDER == controlType then
    option._curValue = option._eventControl[controlIndex]:GetControlPos()
  elseif CONTROL.PA_UI_CONTROL_COMBOBOX == controlType then
    local combo = option._eventControl[controlIndex]
    option._curValue = combo:GetSelectIndex()
    combo:ToggleListbox()
  elseif CONTROL.PA_UI_CONTROL_BUTTON == controlType then
    local tempindex = option._initValue
    if nil ~= option._applyValue then
      tempindex = option._applyValue
    end
    if nil ~= option._curValue then
      tempindex = option._curValue
    end
    if nil == option.GetButtonListSize then
      _PA_LOG("\237\155\132\236\167\132", "[SetControlSettingTable][ BUTTON ] GetButtonListSize \237\149\168\236\136\152\234\176\128 \235\167\140\235\147\164\236\150\180\236\167\128\236\167\128 \236\149\138\236\149\152\236\138\181\235\139\136\235\139\164. GameOptionHeader\236\151\144 \236\182\148\234\176\128\237\149\180\236\163\188\236\132\184\236\154\148. " .. elementName)
    elseif 0 == order then
      option._curValue = (tempindex + 1) % option:GetButtonListSize()
    elseif 1 == order then
      option._curValue = (tempindex - 1) % option:GetButtonListSize()
    elseif 2 == order then
      option._curValue = (tempindex + 1) % option:GetButtonListSize()
    end
  else
    _PA_LOG("\237\155\132\236\167\132", "[EventXXX][ RETURN ] \235\172\180\236\138\168 Control \236\157\184\236\167\128 \235\170\168\235\165\180\234\178\160\236\138\181\235\139\136\235\139\164. : " .. elementName)
    return
  end
  if nil == option._curValue then
    return
  end
  self:EventXXXException(elementName, option._curValue, beforeValue)
  self:SetControlSetting(elementName, option._curValue)
  if true == option._settingRightNow then
    local tempCurValue = option._curValue
    self:SetXXX(elementName, option._curValue)
    option._curValue = tempCurValue
    option._applyValue = nil
  end
  if nil ~= option._applyValue then
    if option._curValue == option._applyValue then
      option._curValue = nil
    end
  elseif option._curValue == option._initValue then
    option._curValue = nil
  end
  local applyButtonEnable = false
  for _, option in pairs(self._elements) do
    if nil ~= option._curValue then
      applyButtonEnable = true
    end
  end
  self:ApplyButtonEnable(applyButtonEnable)
  ClearFocusEdit()
end
function PaGlobal_Option:SetControlSetting(elementName, value)
  self:SetControlSettingTable(self._elements[elementName], value, elementName)
end
function PaGlobal_Option:SetControlSettingTable(option, value, elementName)
  if nil == elementName then
    elementName = ""
  end
  if "table" ~= type(option) then
    return
  end
  if nil == option._eventControl then
    return
  end
  if nil == value then
    return
  end
  if CONTROL.PA_UI_CONTROL_CHECKBUTTON == option._controlType then
    for i, eventControl in pairs(option._eventControl) do
      eventControl:SetCheck(value)
    end
  elseif (nil ~= option.actionInputType or nil ~= option.uiInputType) and CONTROL.PA_UI_CONTROL_RADIOBUTTON == option._controlType then
    for i, eventControl in pairs(option._eventControl) do
      eventControl:SetText(value)
    end
  elseif CONTROL.PA_UI_CONTROL_RADIOBUTTON == option._controlType then
    if value == 0 then
      for i, eventControl in pairs(option._eventControl) do
        eventControl:SetCheck(true)
      end
    else
      if nil == option["_eventControl" .. value] then
        _PA_LOG("\237\155\132\236\167\132", "[SetControlSettingTable][ RETURN ] \235\157\188\235\148\148\236\152\164 \235\178\132\237\138\188 \236\187\168\237\138\184\235\161\164 (eventcontrol 1~x) \236\157\180 \236\160\149\236\131\129\236\160\129\236\156\188\235\161\156 \235\167\140\235\147\164\236\150\180\236\167\128\236\167\128 \236\149\138\236\149\152\236\138\181\235\139\136\235\139\164/ xml \235\157\188\235\148\148\236\152\164 \235\178\132\237\138\188 \236\133\139\237\140\133\236\157\132 \237\153\149\236\157\184\237\149\180\236\163\188\236\132\184\236\154\148 : " .. elementName)
        return
      end
      for i, eventControl in pairs(option["_eventControl" .. value]) do
        eventControl:SetCheck(true)
      end
    end
  elseif CONTROL.PA_UI_CONTROL_SLIDER == option._controlType then
    for i, eventControl in pairs(option._eventControl) do
      eventControl:SetControlPos(value * 100)
    end
    for i, valueControl in pairs(option._curvalueControl) do
      local displayValue = self:FromSliderValueToRealValue(value, option._sliderValueMin, option._sliderValueMax)
      displayValue = math.floor(displayValue + 0.5)
      valueControl:SetText(self._sliderButtonString .. displayValue .. "<PAOldColor>")
    end
  elseif CONTROL.PA_UI_CONTROL_COMBOBOX == option._controlType then
    for i, eventControl in pairs(option._eventControl) do
      eventControl:SetSelectItemIndex(value)
    end
  else
    if CONTROL.PA_UI_CONTROL_BUTTON == option._controlType then
      if nil == option.GetButtonText then
        _PA_LOG("\237\155\132\236\167\132", "[SetControlSettingTable][ BUTTON ] GetButtonText \237\149\168\236\136\152\234\176\128 \235\167\140\235\147\164\236\150\180\236\167\128\236\167\128 \236\149\138\236\149\152\236\138\181\235\139\136\235\139\164. GameOptionHeader\236\151\144 \236\182\148\234\176\128\237\149\180\236\163\188\236\132\184\236\154\148. " .. elementName)
      else
        local buttonText = option:GetButtonText(value)
        for i, eventControl in pairs(option._eventControl) do
          eventControl:SetText(buttonText)
        end
      end
    else
    end
  end
end
function PaGlobal_Option:ResetControlSetting(elementName)
  local option = self._elements[elementName]
  self:ResetControlSettingTable(option, elementName)
end
function PaGlobal_Option:ResetControlSettingTable(option, elementName)
  if nil == elementName then
    elementName = ""
  end
  if "table" ~= type(option) then
    return
  end
  if nil == option._eventControl then
    return
  end
  if CONTROL.PA_UI_CONTROL_CHECKBUTTON == option._controlType then
    for i, eventControl in pairs(option._eventControl) do
      eventControl:SetCheck(false)
    end
  elseif CONTROL.PA_UI_CONTROL_RADIOBUTTON == option._controlType then
    for i, eventControl in pairs(option._eventControl) do
      eventControl:SetCheck(false)
    end
    if nil == option._eventControlCount or option._eventControlCount < 1 then
      return
    end
    for index = 1, option._eventControlCount do
      for i, eventControl in pairs(option["_eventControl" .. index]) do
        eventControl:SetCheck(false)
      end
    end
  elseif CONTROL.PA_UI_CONTROL_SLIDER == option._controlType then
    for i, eventControl in pairs(option._eventControl) do
      eventControl:SetControlPos(50)
    end
  elseif CONTROL.PA_UI_CONTROL_COMBOBOX == option._controlType then
  else
    if CONTROL.PA_UI_CONTROL_COMBOBOX == option._controlType then
    else
    end
  end
end
function PaGlobal_Option:SearchOption(inputString)
  local findTable = {}
  for index, option in pairs(self._elements) do
    local rv
    if nil == option._string then
      _PA_LOG("\237\155\132\236\167\132", "[SearchOption][ RETURN ] option \236\151\144 string\236\157\180 \236\132\164\236\160\149\235\144\152\236\167\128 \236\149\138\236\149\152\236\138\181\235\139\136\235\139\164. GameOptionHeader\236\151\144 \236\132\164\236\160\149\236\157\180 \235\144\152\236\150\180\236\158\136\235\138\148\236\167\128 \237\153\149\236\157\184\237\149\180\236\163\188\236\132\184\236\154\148. ")
    else
      rv = string.find(string.lower(option._string), string.lower(inputString))
    end
    if nil == option._category or nil == option._detail then
      _PA_LOG("\237\155\132\236\167\132", "[SearchOption][ RETURN ] option \236\151\144 \236\185\180\237\133\140\234\179\160\235\166\172\234\176\128 \236\132\164\236\160\149\235\144\152\236\167\128 \236\149\138\236\149\152\236\138\181\235\139\136\235\139\164. CreateEventControl \236\151\144\236\132\156 \236\158\152\235\170\187\235\144\152\236\151\136\236\138\181\235\139\136\235\139\164." .. index)
      rv = nil
    end
    if nil ~= rv then
      for order, v in pairs(option._category) do
        findTable[#findTable + 1] = {
          _elementString = option._string,
          _category = option._category[order],
          _detail = option._detail[order],
          _isScrollEnd = option._isScrollEnd[order]
        }
      end
    end
  end
  return findTable
end
function PaGlobal_Option:EventXXXException(elementName, value, beforeValue)
  if nil == self._elements[elementName].EventException then
    return
  end
  self._elements[elementName]:EventException(value, beforeValue)
end
function PaGlobal_Option._elements.ServiceResourceType:EventException(value)
  local serviceResourceType = PaGlobal_Option:radioButtonMapping_ServiceResourceType(value)
  local chatChannelType = PaGlobal_Option._elements.ChatChannelType
  if CppEnums.ServiceResourceType.eServiceResourceType_SP == serviceResourceType then
    chatChannelType._curValue = PaGlobal_Option:radioButtonMapping_ChatChannelType(CppEnums.LangType.LangType_SP, true)
  else
    chatChannelType._curValue = PaGlobal_Option:radioButtonMapping_ChatChannelType(serviceResourceType, true)
  end
  PaGlobal_Option:ResetControlSettingTable(chatChannelType)
  PaGlobal_Option:SetControlSettingTable(chatChannelType, chatChannelType._curValue)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_LANGUAGESETTING"),
    functionApply = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobal_Option._elements.ChatChannelType:EventException(value)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_LANGUAGESETTING"),
    functionApply = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobal_Option._elements.GraphicOption:EventException(value, beforeValue)
  local GraphicEnum = PaGlobal_Option.GRAPHIC
  if nil == self._curValue then
    PaGlobal_Option:SetGraphicOption(self._curValue)
  else
    if nil == beforeValue then
      beforeValue = self._initValue
    end
    if beforeValue == value then
      PaGlobal_Option:SetGraphicOption(self._curValue)
    end
    local isIncrease = value > beforeValue
    if GraphicEnum.VeryVeryLow == value then
      isIncrease = false
    end
    if GraphicEnum.VeryVeryLow == beforeValue then
      isIncrease = true
    end
    PaGlobal_Option:SetGraphicOption(value, isIncrease)
  end
end
function PaGlobal_Option:KeyCustomInitValue()
  for elementName, element in pairs(self._elements) do
    element._initValue = self:KeyCustomGetString(elementName)
  end
end
function PaGlobal_Option:GetKeyCustomInputType()
  if nil == self._keyCustomInputType then
    _PA_LOG("\237\155\132\236\167\132", "[GetKeyCustomInputType][ RETURN ] \236\157\180\236\131\129\237\149\152\235\139\164....")
    return
  end
  return self._keyCustomInputType[2] or nil
end
function PaGlobal_Option:SetKeyCustomMode(elementName)
  setKeyCustomizing(false)
  SetUIMode(Defines.UIMode.eUIMode_Default)
  self:ResetKeyCustomString()
  local option = self._elements[elementName]
  if nil ~= option.actionInputType then
    self._keyCustomInputType = {
      elementName,
      option.actionInputType
    }
    if "PadFunction1" == option.actionInputType then
      SetUIMode(Defines.UIMode.eUIMode_KeyCustom_ActionPadFunc1)
      return
    elseif "PadFunction2" == option.actionInputType then
      SetUIMode(Defines.UIMode.eUIMode_KeyCustom_ActionPadFunc2)
      return
    end
    if true == self._keyCustomPadMode then
      SetUIMode(Defines.UIMode.eUIMode_KeyCustom_ActionPad)
    else
      SetUIMode(Defines.UIMode.eUIMode_KeyCustom_ActionKey)
    end
    setKeyCustomizing(true)
  elseif nil ~= option.uiInputType then
    self._keyCustomInputType = {
      elementName,
      option.uiInputType
    }
    if true == self._keyCustomPadMode then
      SetUIMode(Defines.UIMode.eUIMode_KeyCustom_UiPad)
    else
      SetUIMode(Defines.UIMode.eUIMode_KeyCustom_UiKey)
    end
    setKeyCustomizing(true)
  end
end
function PaGlobal_Option:CompleteKeyCustomMode()
  if nil == self._keyCustomInputType then
    _PA_LOG("\237\155\132\236\167\132", "[CompleteKeyCustomMode][ RETURN ] \234\184\176\236\161\180 Option \236\176\189 \236\149\132\235\139\136\235\157\188\235\169\180 \236\157\180\236\131\129\237\149\152\235\139\164")
    return
  end
  local elementName = self._keyCustomInputType[1] or nil
  if nil == elementName then
    _PA_LOG("\237\155\132\236\167\132", "[CompleteKeyCustomMode][ RETURN ] \236\157\180\236\131\129\237\149\152\235\139\164")
    return
  end
  self._elements[elementName]._keyCustomInputType = nil
  self._elements[elementName]._curValue = ""
  self:ApplyButtonEnable(true)
  self:ResetControlSetting(elementName)
  self:ResetKeyCustomString()
end
function PaGlobal_Option:KeyCustomGetString(elementName)
  local option = self._elements[elementName]
  local keyCustomString
  if nil ~= option.uiInputType then
    if true == self._keyCustomPadMode then
      keyCustomString = keyCustom_GetString_UiPad(option.uiInputType)
    else
      keyCustomString = keyCustom_GetString_UiKey(option.uiInputType)
    end
  elseif nil ~= option.actionInputType then
    if "PadFunction1" == option.actionInputType then
      return keyCustom_GetString_ActionPadFunc1()
    end
    if "PadFunction2" == option.actionInputType then
      return keyCustom_GetString_ActionPadFunc2()
    end
    if true == self._keyCustomPadMode then
      keyCustomString = keyCustom_GetString_ActionPad(option.actionInputType)
    else
      keyCustomString = keyCustom_GetString_ActionKey(option.actionInputType)
    end
  end
  return keyCustomString
end
function PaGlobal_Option._functions.KeyCustomMode(value)
  local global = PaGlobal_Option
  local beforekeyCustomPadMode = global._keyCustomPadMode
  global._keyCustomPadMode = 1 == value
  if global._keyCustomPadMode == beforekeyCustomPadMode then
    return
  end
  global:ResetKeyCustomString()
end
function PaGlobal_Option:ResetKeyCustomString()
  for elementName, option in pairs(self._elements) do
    if nil ~= option.actionInputType or nil ~= option.uiInputType then
      self:SetControlSetting(elementName, self:KeyCustomGetString(elementName))
    end
  end
end
function PaGlobal_Option:Init()
  for catagory, details in pairs(self._frames) do
    for detail, panel in pairs(self._frames[catagory]) do
      self._frames[catagory][detail] = self:CreateFrame(catagory, detail)
    end
  end
  for catagory, details in pairs(self._frames) do
    for detail, panel in pairs(self._frames[catagory]) do
      self:CreateEventControl(catagory, detail)
    end
  end
  self:InitUi()
  self:SpectialOptionInit()
  self:ListInit()
end
function PaGlobal_Option:InitSetting()
  for name, option in pairs(self._elements) do
    if type(option) ~= "table" then
      _PA_LOG("\237\155\132\236\167\132", "[ InitSetting ] option \236\157\180 table\236\157\180 \236\149\132\235\139\153\235\139\136\235\139\164.")
    elseif option._initValue == nil then
      _PA_LOG("\237\155\132\236\167\132", "element init value\234\176\128 Null \236\158\133\235\139\136\235\139\164. " .. name)
    else
      self:ResetControlSetting(name)
      self:SetControlSetting(name, option._initValue)
    end
  end
end
function PaGlobal_Option:InitValue(gameOptionSetting)
  local elems_ = self._elements
  for i, option in pairs(elems_) do
    option._curValue = nil
    option._applyValue = nil
  end
  self._sliderButtonString = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_CURRENT_SLIDERVALUE") .. " <PAColor0xffddcd82>"
  self:SpectialControlComboBoxInitValue()
  self._keyCustomPadMode = getGamePadEnable()
  self:KeyCustomInitValue()
  if true == self._keyCustomPadMode then
    elems_.KeyCustomMode._initValue = 1
  else
    elems_.KeyCustomMode._initValue = 0
  end
  elems_.AimAssist._initValue = gameOptionSetting:getAimAssist()
  elems_.UseNewQuickSlot._initValue = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eNewQuickSlot)
  elems_.EnableSimpleUI._initValue = gameOptionSetting:getEnableSimpleUI()
  elems_.IsOnScreenSaver._initValue = gameOptionSetting:getIsOnScreenSaver()
  if nil ~= elems_.UIFontSizeType then
    elems_.UIFontSizeType._initValue = gameOptionSetting:getUIFontSizeType()
  end
  elems_.ShowNavPathEffectType._initValue = gameOptionSetting:getShowNavPathEffectType()
  elems_.RefuseRequests._initValue = gameOptionSetting:getRefuseRequests()
  elems_.IsPvpRefuse._initValue = gameOptionSetting:getPvpRefuse()
  if nil ~= elems_.IsExchangeRefuse then
    elems_.IsExchangeRefuse._initValue = gameOptionSetting:getIsExchangeRefuse()
  end
  elems_.RotateRadarMode._initValue = gameOptionSetting:getRadarRotateMode()
  elems_.HideWindowByAttacked._initValue = gameOptionSetting:getHideWindowByAttacked()
  elems_.ShowRightBottomAlarm._initValue = gameOptionSetting:getShowRightBottomAlarm()
  elems_.AudioResourceType._initValue = self:radioButtonMapping_AudioResourceType(gameOptionSetting:getAudioResourceType(), true)
  elems_.ServiceResourceType._initValue = self:radioButtonMapping_ServiceResourceType(gameOptionSetting:getServiceResType(), true)
  elems_.UseChattingFilter._initValue = gameOptionSetting:getUseChattingFilter()
  elems_.ChatChannelType._initValue = self:radioButtonMapping_ChatChannelType(gameOptionSetting:getChatLanguageType(), true)
  elems_.SelfPlayerNameTagVisible._initValue = gameOptionSetting:getSelfPlayerNameTagVisible()
  elems_.OtherPlayerNameTagVisible._initValue = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow == gameOptionSetting:getOtherPlayerNameTagVisible()
  elems_.PartyPlayerNameTagVisible._initValue = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow == gameOptionSetting:getPartyPlayerNameTagVisible()
  elems_.GuildPlayerNameTagVisible._initValue = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow == gameOptionSetting:getGuildPlayerNameTagVisible()
  elems_.RankingPlayerNameTagVisible._initValue = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow == gameOptionSetting:getRankingPlayerNameTagVisible()
  elems_.GuideLineZoneChange._initValue = gameOptionSetting:getRenderPlayerColor("ZoneChange")
  elems_.GuideLineQuestNPC._initValue = gameOptionSetting:getShowQuestActorColor()
  elems_.GuideLineNpcIntimacy._initValue = gameOptionSetting:getShowHumanRelation()
  elems_.GuideLineWarAlly._initValue = gameOptionSetting:getRenderPlayerColor("WarAlly")
  elems_.GuideLineNonWarPlayer._initValue = gameOptionSetting:getRenderPlayerColor("NonWarPlayer")
  elems_.GuideLineEnemy._initValue = gameOptionSetting:getRenderPlayerColor("Enemy")
  elems_.GuideLineGuild._initValue = gameOptionSetting:getRenderPlayerColor("Guild")
  elems_.GuideLineParty._initValue = gameOptionSetting:getRenderPlayerColor("Party")
  elems_.PetRender._initValue = gameOptionSetting:getPetRender()
  if true == gameOptionSetting:getFairyRender() then
    elems_.FairyRender._initValue = 0
  else
    elems_.FairyRender._initValue = 1
  end
  if true == (false == gameOptionSetting:getHideOtherPlayerTent()) then
    elems_.TentRender._initValue = 0
  else
    elems_.TentRender._initValue = 1
  end
  elems_.MaidView._sliderValueMax = gameOptionSetting:getMaidMaxCount()
  elems_.MaidView._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getMaidView(), 0, gameOptionSetting:getMaidMaxCount())
  local frameContent = self._frames.Function.View
  if nil ~= frameContent then
    local maidControl = UI.getChildControl(frameContent._uiFrameContent, "StaticText_BgOrder6_Import")
    local maidMaxControl = UI.getChildControl(maidControl, "StaticText_MaxMaidView")
    maidMaxControl:SetShow(true)
    maidMaxControl:SetText(tostring(gameOptionSetting:getMaidMaxCount()))
  end
  elems_.ShowReputation._initValue = gameOptionSetting:getShowStatTier()
  elems_.RenderHitEffect._initValue = gameOptionSetting:getRenderHitEffect()
  elems_.DamageMeter._initValue = gameOptionSetting:getOnDamageMeter()
  elems_.ShowComboGuide._initValue = gameOptionSetting:getShowComboGuide()
  elems_.HideMastOnCarrier._initValue = gameOptionSetting:getHideMastOnCarrier()
  elems_.WorldMapOpenType._initValue = gameOptionSetting:getWorldmapOpenType()
  elems_.WorldmapCameraPitchType._initValue = gameOptionSetting:getWorldMapCameraPitchType()
  elems_.TextureQuality._initValue = self:radioButtonMapping_TextureQuality(gameOptionSetting:getTextureQuality(), true)
  elems_.GraphicOption._initValue = self:radioButtonMapping_GraphicOption(gameOptionSetting:getGraphicOption(), true)
  self:SetGraphicOption(elems_.GraphicOption._initValue)
  elems_.AntiAliasing._initValue = gameOptionSetting:getAntiAliasing()
  elems_.SSAO._initValue = gameOptionSetting:getSSAO()
  elems_.PostFilter._initValue = 2 == gameOptionSetting:getPostFilter()
  elems_.Tessellation._initValue = gameOptionSetting:getTessellation()
  elems_.Dof._initValue = gameOptionSetting:getDof()
  elems_.Representative._initValue = gameOptionSetting:getRepresentative()
  elems_.CharacterEffect._initValue = gameOptionSetting:getCharacterEffect()
  elems_.SnowPoolOnlyInSafeZone._initValue = gameOptionSetting:getSnowPoolOnlyInSafeZone()
  elems_.BloodEffect._initValue = 2 == gameOptionSetting:getBloodEffect()
  elems_.LensBlood._initValue = gameOptionSetting:getLensBlood()
  if nil ~= elems_.ShowStackHp then
    elems_.ShowStackHp._initValue = gameOptionSetting:getIsShowHpBar()
  end
  elems_.AutoOptimization._initValue = gameOptionSetting:getAutoOptimization()
  elems_.AutoOptimizationFrameLimit._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getAutoOptimizationFrameLimit(), 0, 60)
  elems_.UpscaleEnable._initValue = gameOptionSetting:getUpscaleEnable()
  elems_.SelfPlayerOnlyEffect._initValue = gameOptionSetting:getSelfPlayerOnlyEffect()
  elems_.NearestPlayerOnlyEffect._initValue = gameOptionSetting:getNearestPlayerOnlyEffect()
  elems_.SelfPlayerOnlyLantern._initValue = gameOptionSetting:getSelfPlayerOnlyLantern()
  elems_.PresentLock._initValue = gameOptionSetting:getPresentLock()
  elems_.UseEffectFrameOptimization._initValue = gameOptionSetting:getUseOptimizationEffectFrame()
  elems_.EffectFrameOptimization._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getEffectFrameEffectOptimization(), 0.1, 25)
  elems_.UsePlayerEffectDistOptimization._initValue = gameOptionSetting:getUsePlayerOptimizationEffectFrame()
  elems_.PlayerEffectDistOptimization._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getPlayerEffectFrameEffectOptimization() / 100, 10, 50)
  elems_.UseCharacterUpdateFrameOptimize._initValue = gameOptionSetting:getUseCharacterDistUpdate()
  elems_.UseOtherPlayerUpdate._initValue = true ~= gameOptionSetting:getUseOtherPlayerUpdate()
  elems_.MouseInvertX._initValue = gameOptionSetting:getMouseInvertX()
  elems_.MouseInvertY._initValue = gameOptionSetting:getMouseInvertY()
  elems_.MouseSensitivityX._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getMouseSensitivityX(), 0.1, 2)
  elems_.MouseSensitivityY._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getMouseSensitivityY(), 0.1, 2)
  elems_.GameMouseMode._initValue = gameOptionSetting:getGameMouseMode()
  elems_.IsUIModeMouseLock._initValue = gameOptionSetting:getUIModeMouseLock()
  elems_.GamePadEnable._initValue = gameOptionSetting:getGamePadEnable()
  elems_.GamePadVibration._initValue = gameOptionSetting:getGamePadVibration()
  elems_.GamePadInvertX._initValue = gameOptionSetting:getGamePadInvertX()
  elems_.GamePadInvertY._initValue = gameOptionSetting:getGamePadInvertY()
  elems_.GamePadSensitivityX._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getGamePadSensitivityX(), 0.2, 2)
  elems_.GamePadSensitivityY._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getGamePadSensitivityY(), 0.2, 2)
  if true == _ContentsGroup_isConsoleTest then
    elems_.ConsolePadKeyType._initValue = gameOptionSetting:getConsoleKeyType()
  else
    elems_.ConsolePadKeyType._initValue = 0
  end
  elems_.LUT._initValue = gameOptionSetting:getCameraLUTFilter()
  elems_.Fov._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getFov(), 40, 70)
  elems_.CameraEffectMaster._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getCameraMasterPower(), 0, 1)
  elems_.CameraShakePower._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getCameraShakePower(), 0, 1)
  elems_.MotionBlurPower._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getMotionBlurPower(), 0, 1)
  elems_.CameraTranslatePower._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getCameraTranslatePower(), 0, 1)
  elems_.CameraFovPower._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getCameraFovPower(), 0, 1)
  elems_.ScreenShotQuality._initValue = gameOptionSetting:getScreenShotQuality()
  elems_.ScreenShotFormat._initValue = gameOptionSetting:getScreenShotFormat()
  elems_.WatermarkAlpha._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getWatermarkAlpha(), 0, 1)
  elems_.WatermarkScale._initValue = gameOptionSetting:getWatermarkScale()
  elems_.WatermarkPosition._initValue = gameOptionSetting:getWatermarkPosition()
  elems_.WatermarkService._initValue = gameOptionSetting:getWatermarkService()
  elems_.ScreenMode._initValue = gameOptionSetting:getScreenMode()
  elems_.AutoRunCamera._initValue = gameOptionSetting:getAutoRunCamera()
  elems_.AutoRunCameraRotation._initValue = gameOptionSetting:getAutoRunCameraRotation()
  elems_.ScreenResolution._initValue = self._availableResolutionList:findResolution(gameOptionSetting:getScreenResolutionWidth(), gameOptionSetting:getScreenResolutionHeight())
  if nil ~= elems_.ScreenResolution._eventControl then
    self._userInitScreenResolution.width = gameOptionSetting:getScreenResolutionWidth()
    self._userInitScreenResolution.height = gameOptionSetting:getScreenResolutionHeight()
    if -1 == elems_.ScreenResolution._initValue then
      for _, value in pairs(elems_.ScreenResolution._eventControl) do
        value:SetText(self._userInitScreenResolution.width .. "x" .. self._userInitScreenResolution.height)
      end
    else
      for _, value in pairs(elems_.ScreenResolution._eventControl) do
        value:SetText(elems_.ScreenResolution._comboBoxList[elems_.ScreenResolution._initValue])
      end
    end
  end
  local ultraResolutionWidth = 3840
  local ultraResolutionHeight = 2160
  if ultraResolutionWidth <= gameOptionSetting:getScreenResolutionWidth() and ultraResolutionHeight <= gameOptionSetting:getScreenResolutionHeight() then
    elems_.UltraHighDefinition._initValue = true
  else
    elems_.UltraHighDefinition._initValue = false
  end
  elems_.CropModeEnable._initValue = gameOptionSetting:getCropModeEnable()
  elems_.CropModeScaleX._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getCropModeScaleX(), 0.5, 1)
  elems_.CropModeScaleY._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getCropModeScaleY(), 0.5, 1)
  if _ContentsGroup_isConsoleTest then
    elems_.HDRDisplayGamma._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getHdrDisplayGamma(), PaGlobal_Option._elements.HDRDisplayGamma._sliderValueMin, PaGlobal_Option._elements.HDRDisplayGamma._sliderValueMax)
    elems_.HDRDisplayMaxNits._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getHdrDisplayMaxNits(), PaGlobal_Option._elements.HDRDisplayMaxNits._sliderValueMin, PaGlobal_Option._elements.HDRDisplayMaxNits._sliderValueMax)
  end
  elems_.UIScale._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getUIScale(), 0.5, 2)
  if true == UI.checkResolution4KForXBox() then
    elems_.UIScale._initValue = 2
  end
  elems_.GammaValue._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getGammaValue(), 0, 1)
  elems_.ContrastValue._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getContrastValue(), 0, 1)
  elems_.EffectAlpha._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getEffectAlpha(), 0.3, 1)
  elems_.SkillPostEffect._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getSkillPostEffect(), 0, 1)
  elems_.ColorBlind._initValue = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  elems_.EnableMusic._initValue = gameOptionSetting:getEnableMusic()
  elems_.EnableSound._initValue = gameOptionSetting:getEnableSound()
  elems_.EnableEnv._initValue = gameOptionSetting:getEnableEnvSound()
  elems_.EnableRidingSound._initValue = gameOptionSetting:getEnableRidingSound()
  elems_.EnableWhisperMusic._initValue = gameOptionSetting:getEnableWhisperSound()
  elems_.EnableTraySoundOnOff._initValue = gameOptionSetting:getEnableTraySound()
  elems_.BattleSoundType._initValue = gameOptionSetting:getEnableBattleSoundType()
  if true == gameOptionSetting:getEnableFairySound() then
    elems_.EnableAudioFairy._initValue = 1
  else
    elems_.EnableAudioFairy._initValue = 0
  end
  elems_.VolumeMaster._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getMasterVolume(), 0, 100)
  elems_.VolumeMusic._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getMusicVolume(), 0, 100)
  elems_.VolumeFx._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getFxVolume(), 0, 100)
  elems_.VolumeEnv._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getEnvSoundVolume(), 0, 100)
  elems_.VolumeDlg._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getDialogueVolume(), 0, 100)
  elems_.VolumeHitFxVolume._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getHitFxVolume(), 0, 100)
  elems_.VolumeHitFxWeight._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getHitFxWeight(), 0, 100)
  elems_.VolumeOtherPlayer._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getOtherPlayerVolume(), 0, 100)
  elems_.VolumeFairy._initValue = self:FromRealValueToSliderValue(gameOptionSetting:getFairyVolume(), 0, 100)
  elems_.AlertNormalTrade._initValue = not ToClient_GetMessageFilter(self.ALERT.NormalTrade)
  elems_.AlertRoyalTrade._initValue = not ToClient_GetMessageFilter(self.ALERT.RoyalTrade)
  elems_.AlertOtherPlayerGetItem._initValue = not ToClient_GetMessageFilter(self.ALERT.OtherPlayerGetItem)
  elems_.AlertLifeLevelUp._initValue = not ToClient_GetMessageFilter(self.ALERT.LifeLevelUp)
  elems_.AlertItemMarket._initValue = not ToClient_GetMessageFilter(self.ALERT.ItemMarket)
  elems_.AlertOtherMarket._initValue = not ToClient_GetMessageFilter(self.ALERT.OtherMarket)
  elems_.AlertChangeRegion._initValue = not ToClient_GetMessageFilter(self.ALERT.ChangeRegion)
  elems_.AlertFitnessLevelUp._initValue = not ToClient_GetMessageFilter(self.ALERT.FitnessLevelUp)
  elems_.AlertTerritoryWar._initValue = not ToClient_GetMessageFilter(self.ALERT.TerritoryWar)
  elems_.AlertGuildWar._initValue = not ToClient_GetMessageFilter(self.ALERT.GuildWar)
  elems_.AlertEnchantSuccess._initValue = not ToClient_GetMessageFilter(self.ALERT.EnchantSuccess)
  elems_.AlertEnchantFail._initValue = not ToClient_GetMessageFilter(self.ALERT.EnchantFail)
  elems_.AlertGuildQuestMessage._initValue = not ToClient_GetMessageFilter(self.ALERT.GuildQuestMessage)
  elems_.AlertNearMonster._initValue = not ToClient_GetMessageFilter(self.ALERT.NearMonster)
  elems_.ShowRightBottomAlarm._initValue = gameOptionSetting:getShowRightBottomAlarm()
  elems_.BlackSpiritNotice._initValue = gameOptionSetting:getBlackSpiritNotice()
  elems_.ShowCashAlert._initValue = not gameOptionSetting:getCashAlert()
  elems_.ShowGuildLoginMessage._initValue = gameOptionSetting:getShowGuildLoginMessage()
  elems_.UseLedAnimation._initValue = gameOptionSetting:getUseLedAnimation()
  self:SetSkillCommandPanel(gameOptionSetting:getShowSkillCmd())
  setRotateRadarMode(elems_.RotateRadarMode._initValue)
  setAutoRunCamera(elems_.AutoRunCamera._initValue)
  setAutoRunCameraRotation(elems_.AutoRunCameraRotation._initValue)
  FGlobal_Option_InitTentRender()
end
function FGlobal_Option_InitTentRender()
  local frameContent = PaGlobal_Option._frames.Function.View
  if nil ~= frameContent then
    local tentBG = UI.getChildControl(frameContent._uiFrameContent, "StaticText_BgOrder7_Import")
    local showTentRender = UI.getChildControl(tentBG, "RadioButton_TentRender")
    local hideTentRender = UI.getChildControl(tentBG, "RadioButton_TentRender1")
    local showTentRenderText = UI.getChildControl(showTentRender, "StaticText_Name")
    local hideTentRenderText = UI.getChildControl(hideTentRender, "StaticText_Name")
    UI.setLimitTextAndAddTooltip(showTentRenderText)
    UI.setLimitTextAndAddTooltip(hideTentRenderText)
    hideTentRender:SetEnableArea(0, 0, hideTentRender:GetSizeX() + hideTentRenderText:GetTextSizeX(), hideTentRender:GetSizeY())
    showTentRender:SetEnableArea(0, 0, showTentRender:GetSizeX() + showTentRenderText:GetTextSizeX(), showTentRender:GetSizeY())
    showTentRenderText:addInputEvent("Mouse_LUp", "PaGlobal_Option:EventXXX(\"RadioButton_TentRender\", 1, 0  )")
    hideTentRenderText:addInputEvent("Mouse_LUp", "PaGlobal_Option:EventXXX(\"RadioButton_TentRender\", 1, 1  )")
  end
end
function FGlobal_Option_InitializeOption(gameOptionSetting)
  PaGlobal_Option:InitValue(gameOptionSetting)
  PaGlobal_Option:InitSetting()
  if true == PaGlobal_Option._resetCheck then
    PaGlobal_Option._resetCheck = nil
    for elementName, option in pairs(PaGlobal_Option._elements) do
      option._curValue = nil
      option._applyValue = nil
      PaGlobal_Option:SetXXX(elementName, option._initValue)
    end
  end
end
function FGlobal_Option_luaLoadComplete()
  PaGlobal_Option:Init()
  ToClient_initGameOption()
  if isNeedGameOptionFromServer() == true then
    keyCustom_StartEdit()
  end
  if true == ToClient_isConsole() then
  end
end
function FGlobal_Option_InitializeScreenResolution(availableScreenResolution)
  PaGlobal_Option._availableResolutionList = availableScreenResolution
end
function FromClient_RefreshGameOption(gameOptionSetting)
  PaGlobal_Option._resetCheck = false
  FGlobal_Option_InitializeOption(gameOptionSetting)
end
function FromClient_OtherPlayeUpdate(isEnable, isOption)
  local isShow = isEnable
  if true == isOption then
    isEnable = false == isEnable
  else
    PaGlobal_Option:SetControlSetting("UseOtherPlayerUpdate", not isEnable)
  end
  setUseOtherPlayerUpdate(isEnable)
  if isEnable then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_PLAYERHIDEOFF"))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_PLAYERHIDEON"))
  end
end
function FromClient_CanChangeOptionAfterSec(sec)
  local msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CANTCHANGE_TIERICONOPTION_COOLTIME", "sec", sec)
  if nil ~= msg and "" ~= msg then
    Proc_ShowMessage_Ack(msg)
  end
end
function FromClient_RefreshMaidOptionInfo(gameOptionSetting)
  local elems_ = PaGlobal_Option._elements
  local curValue = PaGlobal_Option:Get("MaidView") * elems_.MaidView._sliderValueMax
  elems_.MaidView._sliderValueMax = gameOptionSetting:getMaidMaxCount()
  elems_.MaidView._initValue = PaGlobal_Option:FromRealValueToSliderValue(curValue, 0, gameOptionSetting:getMaidMaxCount())
  PaGlobal_Option:SetXXX("MaidView", PaGlobal_Option._elements.MaidView._initValue)
  local frameContent = PaGlobal_Option._frames.Function.View
  if nil ~= frameContent then
    local maidControl = UI.getChildControl(frameContent._uiFrameContent, "StaticText_BgOrder6_Import")
    local maidMaxControl = UI.getChildControl(maidControl, "StaticText_MaxMaidView")
    maidMaxControl:SetText(tostring(gameOptionSetting:getMaidMaxCount()))
  end
end
registerEvent("EventGameOptionInitGameOption", "FGlobal_Option_InitializeOption")
registerEvent("EventGameOptionInitDisplayModeList", "FGlobal_Option_InitializeScreenResolution")
registerEvent("FromClient_luaLoadComplete", "FGlobal_Option_luaLoadComplete")
registerEvent("FromClient_OtherPlayeUpdate", "FromClient_OtherPlayeUpdate")
registerEvent("FromClient_RefreshGameOption", "FromClient_RefreshGameOption")
registerEvent("FromClient_CanChangeOptionAfterSec", "FromClient_CanChangeOptionAfterSec")
registerEvent("FromClient_RefreshMaidOptionInfo", "FromClient_RefreshMaidOptionInfo")
function PaGlobal_Option:SetSkillCommandPanel(check)
  isChecked_SkillCommand = check
  if nil ~= Panel_SkillCommand then
    if isChecked_SkillCommand then
      local pcPosition = getSelfPlayer():get():getPosition()
      local regionInfo = getRegionInfoByPosition(pcPosition)
      if false == regionInfo:get():isSafeZone() then
        FGlobal_SkillCommand_Show(true)
      end
    else
      Panel_SkillCommand:SetShow(false)
    end
  end
end

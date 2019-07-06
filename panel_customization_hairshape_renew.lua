Panel_Customizing_HairShape:ignorePadSnapMoveToOtherPanel()
local Customization_HairShapeInfo = {
  _ui = {
    _static_TabGroup = UI.getChildControl(Panel_Customizing_HairShape, "Static_TabGroup"),
    _static_KeyGuideBg = UI.getChildControl(Panel_Customizing_HairShape, "Static_KeyGuideBg"),
    _static_ButtonBg = UI.getChildControl(Panel_Customizing_HairShape, "Static_ButtonGroup"),
    _button_Position = UI.getChildControl(Panel_Customizing_HairShape, "Button_Position"),
    _button_Rotation = UI.getChildControl(Panel_Customizing_HairShape, "Button_Rotation"),
    _static_PositionSliderGroup = UI.getChildControl(Panel_Customizing_HairShape, "Static_SliderGroup1"),
    _static_RotationSliderGroup = UI.getChildControl(Panel_Customizing_HairShape, "Static_SliderGroup2"),
    _static_LenghtSliderGroup = UI.getChildControl(Panel_Customizing_HairShape, "Static_SliderGroup3")
  },
  _config = {},
  _currentClassType,
  _currentUiId,
  _isExistBone = true,
  _checkTransRot = 1,
  _paramType = {},
  _paramIndex = {},
  _paramMin = {},
  _paramMax = {},
  _paramDefault = {},
  _selectedTransMin,
  _selectedTransMax,
  _currentTranslation,
  _selectedRotMin,
  _selectedRotMax,
  _currentRotation,
  _controlMode = 1,
  _isBoneControl = false
}
function Customization_HairShapeInfo:ShowBoneControls(isShow)
  self._ui._static_TabGroup:SetShow(isShow)
  self._ui._button_Position:SetShow(isShow)
  self._ui._button_Rotation:SetShow(isShow)
  for index = 0, 2 do
    self._ui._static_PositionSliderBg[index]:SetShow(isShow)
    self._ui._static_RotationSliderBg[index]:SetShow(isShow)
  end
  self._ui._checkBox_ShowPart:SetShow(isShow)
  self._ui._button_ResetPart:SetShow(isShow)
  self._ui._button_ResetAll:SetShow(isShow)
  self._ui._static_PositionSliderGroup:SetShow(isShow)
  self._ui._static_RotationSliderGroup:SetShow(isShow)
  self._ui._static_KeyGuideBg:SetPosY(Panel_Customizing_HairShape:GetPosY() + Panel_Customizing_HairShape:GetSizeY() - 50)
  if false == isShow then
    self._ui._static_LenghtSliderGroup:SetPosY(25)
    Panel_Customizing_HairShape:SetSize(Panel_Customizing_HairShape:GetSizeX(), 200)
  else
    self._ui._static_LenghtSliderGroup:SetPosY(373)
    Panel_Customizing_HairShape:SetSize(Panel_Customizing_HairShape:GetSizeX(), 548)
    Panel_Customizing_HairShape:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_Customization_HairShape_SetBoneControl(true)")
    PaGlobalFunc_Customization_HairShape_Update()
  end
end
function PaGlobalFunc_Customization_HairShape_CloseHairShapeUi()
  endPickingMode()
  PaGlobalFunc_Customization_HairShape_Close()
end
function PaGlobalFunc_Customization_HairShape_CloseHairShapeUiWithoutBoneControl()
  local self = Customization_HairShapeInfo
  endPickingMode()
  self._ui._checkBox_ShowPart:SetEnable(true)
  PaGlobalFunc_Customization_HairShape_Close()
end
function PaGlobalFunc_Customization_HairShape_OpenHairShapeUiWithoutBoneControl(classType, uiId)
  local self = Customization_HairShapeInfo
  self._ui._checkBox_ShowPart:SetEnable(false)
  self._isExistBone = false
  PaGlobalFunc_Customization_HairShape_OpenHairShapeUi(classType, uiId)
end
function PaGlobalFunc_Customization_HairShape_OpenHairShapeUi(classType, uiId)
  local self = Customization_HairShapeInfo
  self._currentClassType = classType
  self._currentUiId = uiId
  HandleClicked_Customization_HairShape_CursorSelect(self._checkTransRot)
  PaGlobalFunc_Customization_HairShape_EnableHairSlide(false)
  startHairPickingMode()
  self:ShowBoneControls(self._isExistBone)
  local defaultContentsIndex = 0
  local sliderNum = getUiSliderCount(classType, uiId, defaultContentsIndex)
  local meshParamType = 1
  local curlRange = getCurlLengthRange()
  local sliderValueBasePosX = 0
  local meshParamType = 1
  local curlRange = getCurlLengthRange()
  local sliderValueBasePosX = 0
  for sliderIndex = 0, sliderNum - 1 do
    self._paramType[sliderIndex] = getUiSliderParamType(classType, uiId, defaultContentsIndex, sliderIndex)
    self._paramIndex[sliderIndex] = getUiSliderParamIndex(classType, uiId, defaultContentsIndex, sliderIndex)
    local sliderText = getUiSliderDescName(classType, uiId, defaultContentsIndex, sliderIndex)
    local param = getParam(self._paramType[sliderIndex], self._paramIndex[sliderIndex])
    if sliderIndex >= 0 and sliderIndex < 3 then
      self._paramMin[sliderIndex] = getHairMinLength(sliderIndex)
      self._paramMax[sliderIndex] = getParamMax(classType, self._paramType[sliderIndex], self._paramIndex[sliderIndex])
      self._paramDefault[sliderIndex] = getParamDefault(classType, self._paramType[sliderIndex], self._paramIndex[sliderIndex])
      if self._paramMin[sliderIndex] == self._paramMax[sliderIndex] then
        PaGlobalFunc_Customization_HairShape_EnalbeSlide(self._ui._staticText_LengthSlider[sliderIndex], self._ui._slider_Length[sliderIndex], self._ui._staticText_LengthValue[sliderIndex], false)
      else
        PaGlobalFunc_Customization_HairShape_EnalbeSlide(self._ui._staticText_LengthSlider[sliderIndex], self._ui._slider_Length[sliderIndex], self._ui._staticText_LengthValue[sliderIndex], true)
      end
    elseif sliderIndex == 3 then
      self._paramMin[sliderIndex] = 50 - curlRange / 2
      self._paramMax[sliderIndex] = 50 + curlRange / 2
      self._paramDefault[sliderIndex] = getParamDefault(classType, self._paramType[sliderIndex], self._paramIndex[sliderIndex])
      if curlRange == 0 then
        PaGlobalFunc_Customization_HairShape_EnalbeSlide(self._ui._staticText_LengthSlider[sliderIndex], self._ui._slider_Length[sliderIndex], self._ui._staticText_LengthValue[sliderIndex], false)
      else
        PaGlobalFunc_Customization_HairShape_EnalbeSlide(self._ui._staticText_LengthSlider[sliderIndex], self._ui._slider_Length[sliderIndex], self._ui._staticText_LengthValue[sliderIndex], true)
      end
    elseif sliderIndex == 4 then
      self._paramMin[sliderIndex] = getParamMin(classType, self._paramType[sliderIndex], self._paramIndex[sliderIndex])
      self._paramMax[sliderIndex] = getParamMax(classType, self._paramType[sliderIndex], self._paramIndex[sliderIndex])
      self._paramDefault[sliderIndex] = getParamDefault(classType, self._paramType[sliderIndex], self._paramIndex[sliderIndex])
      if curlRange == 0 then
        PaGlobalFunc_Customization_HairShape_EnalbeSlide(self._ui._staticText_LengthSlider[sliderIndex], self._ui._slider_Length[sliderIndex], self._ui._staticText_LengthValue[sliderIndex], false)
      else
        PaGlobalFunc_Customization_HairShape_EnalbeSlide(self._ui._staticText_LengthSlider[sliderIndex], self._ui._slider_Length[sliderIndex], self._ui._staticText_LengthValue[sliderIndex], true)
      end
    end
    self._ui._staticText_LengthSlider[sliderIndex]:SetText(PAGetString(Defines.StringSheet_GAME, sliderText))
    self._ui._staticText_LengthValue[sliderIndex]:SetText(param)
    self:SetValueSlider(self._ui._slider_Length[sliderIndex], param, self._paramMin[sliderIndex], self._paramMax[sliderIndex])
    HandleClicked_Customization_HairShape_UpdateHairLength(sliderIndex)
  end
  PaGlobalFunc_Customization_HairShape_Open()
end
function PaGlobalFunc_Customization_HairShape_EnalbeSlide(textControl, sliderControl, currentValueControl, enable)
  local color = Defines.Color.C_FF444444
  if enable then
    color = Defines.Color.C_FFFFFFFF
  end
  sliderControl:SetMonoTone(not enable)
  sliderControl:SetEnable(enable)
  sliderControl:SetIgnore(not enable)
  textControl:SetFontColor(color)
  currentValueControl:SetFontColor(color)
end
function Customization_HairShapeInfo:CalculateSliderValue(sliderControl, valueMin, valueMax)
  local ratio = sliderControl:GetControlPos()
  local val = valueMax - valueMin
  local progress = UI.getChildControl(sliderControl, "Progress2_1")
  local button = UI.getChildControl(sliderControl, "Slider_DisplayButton")
  button:SetPosX(sliderControl:GetControlButton():GetPosX())
  local offset = math.cos(ratio * math.pi) * 2
  progress:SetProgressRate(ratio * 100 + offset)
  return ratio * val - (val - math.abs(valueMax))
end
function Customization_HairShapeInfo:SetValueSlider(sliderControl, value, valueMin, valueMax)
  local val = valueMax - valueMin
  if val ~= 0 then
    sliderControl:SetControlPos((value - valueMin) / val * 100)
  end
end
function PaGlobalFunc_Customization_HairShape_PickingHairBone()
  local self = Customization_HairShapeInfo
  PaGlobalFunc_Customization_HairShape_EnableHairSlide(true)
  self._selectedTransMin = getSelectedBoneMinTrans()
  self._selectedTransMax = getSelectedBoneMaxTrans()
  self._currentTranslation = getSelectedBoneTrans()
  self._selectedRotMin = getSelectedBoneMinRot()
  self._selectedRotMax = getSelectedBoneMaxRot()
  self._currentRotation = getSelectedBoneRot()
  if self._currentTranslation ~= nil and true == self._ui._slider_Position[0]:IsEnable() then
    self:SetValueSlider(self._ui._slider_Position[0], self._currentTranslation.x, self._selectedTransMin.x, self._selectedTransMax.x)
    self:SetValueSlider(self._ui._slider_Position[1], self._currentTranslation.y, self._selectedTransMin.y, self._selectedTransMax.y)
    self:SetValueSlider(self._ui._slider_Position[2], self._currentTranslation.z, self._selectedTransMin.z, self._selectedTransMax.z)
  end
  if self._currentRotation ~= nil and true == self._ui._slider_Rotation[0]:IsEnable() then
    self:SetValueSlider(self._ui._slider_Rotation[0], self._currentRotation.x, self._selectedRotMin.x, self._selectedRotMax.x)
    self:SetValueSlider(self._ui._slider_Rotation[1], self._currentRotation.y, self._selectedRotMin.y, self._selectedRotMax.y)
    self:SetValueSlider(self._ui._slider_Rotation[2], self._currentRotation.z, self._selectedRotMin.z, self._selectedRotMax.z)
  end
  PaGlobalFunc_Customization_HairShape_Update()
end
function PaGlobalFunc_Customization_HairShape_AdjustHairBoneTranslation(translationX, translationY, translationZ)
  local self = Customization_HairShapeInfo
  self._checkTransRot = 1
  self:SetValueSlider(self._ui._slider_Position[0], translationX, self._selectedTransMin.x, self._selectedTransMax.x)
  self:SetValueSlider(self._ui._slider_Position[1], translationY, self._selectedTransMin.y, self._selectedTransMax.y)
  self:SetValueSlider(self._ui._slider_Position[2], translationZ, self._selectedTransMin.z, self._selectedTransMax.z)
  self._currentTranslation.x = translationX
  self._currentTranslation.y = translationY
  self._currentTranslation.z = translationZ
end
function PaGlobalFunc_Customization_HairShape_AdjustHairBoneRotation(rotationX, rotationY, rotationZ)
  local self = Customization_HairShapeInfo
  self._checkTransRot = 2
  self:SetValueSlider(self._ui._slider_Rotation[0], rotationX, self._selectedRotMin.x, self._selectedRotMax.x)
  self:SetValueSlider(self._ui._slider_Rotation[1], rotationY, self._selectedRotMin.y, self._selectedRotMax.y)
  self:SetValueSlider(self._ui._slider_Rotation[2], rotationZ, self._selectedRotMin.z, self._selectedRotMax.z)
  self._currentRotation.x = rotationX
  self._currentRotation.y = rotationY
  self._currentRotation.z = rotationZ
end
function PaGlobalFunc_Customization_HairShape_EnableHairSlide(enable)
  local self = Customization_HairShapeInfo
  self._ui._button_Position:SetEnable(enable)
  self._ui._button_Rotation:SetEnable(enable)
  local color = Defines.Color.C_FF444444
  if enable then
    color = Defines.Color.C_FFFFFFFF
  end
  for index = 0, 2 do
    self._ui._slider_Rotation[index]:SetIgnore(not enable)
    self._ui._slider_Position[index]:SetIgnore(not enable)
    self._ui._slider_Rotation[index]:SetEnable(enable)
    self._ui._slider_Position[index]:SetEnable(enable)
    self._ui._slider_Rotation[index]:SetMonoTone(not enable)
    self._ui._slider_Position[index]:SetMonoTone(not enable)
    self._ui._sliderButton_Position[index]:SetMonoTone(not enable)
    self._ui._sliderButton_Rotation[index]:SetMonoTone(not enable)
    self._ui._staticText_PositionSlider[index]:SetFontColor(color)
    self._ui._staticText_RotationSlider[index]:SetFontColor(color)
  end
end
function HandleClicked_Customization_HairShape_SliderFocusOn()
  local self = Customization_HairShapeInfo
  if true == self._isExistBone then
    PaGlobalFunc_Customization_SetKeyGuide(5)
  else
    PaGlobalFunc_Customization_SetKeyGuide(6)
  end
end
function HandleClicked_Customization_HairShape_SliderFocusOut()
  local self = Customization_HairShapeInfo
  if false == self._isBoneControl and true == PaGlobalFunc_Customization_HairShape_GetShow() then
    if true == self._isExistBone then
      PaGlobalFunc_Customization_SetKeyGuide(3)
    else
      PaGlobalFunc_Customization_SetKeyGuide(7)
    end
  end
end
function HandleClicked_Customization_HairShape_ToggleShowHairBoneControlPart()
  local self = Customization_HairShapeInfo
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  showBoneControlPart(self._ui._checkBox_ShowPart:IsCheck())
end
function HandleClicked_Customization_HairShape_ClearCustomizedBoneInfo()
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  clearCustomizedBoneInfo()
end
function HandleClicked_Customization_HairShape_CursorSelect(luaControlModeIndex)
  local self = Customization_HairShapeInfo
  selectSculptingBoneTransformType(luaControlModeIndex - 1)
  self._controlMode = luaControlModeIndex
end
function HandleClicked_Customization_HairShape_UpdateHairBone(updateControlMode)
  local self = Customization_HairShapeInfo
  if self._controlMode ~= updateControlMode then
    self:UpdateHairRadioButtons(updateControlMode)
  end
  HandleClicked_Customization_HairShape_CursorSelect(updateControlMode)
  if 1 == updateControlMode then
    local x = self:CalculateSliderValue(self._ui._slider_Position[0], self._selectedTransMin.x, self._selectedTransMax.x)
    local y = self:CalculateSliderValue(self._ui._slider_Position[1], self._selectedTransMin.y, self._selectedTransMax.y)
    local z = self:CalculateSliderValue(self._ui._slider_Position[2], self._selectedTransMin.z, self._selectedTransMax.z)
    self._currentTranslation.x = x
    self._currentTranslation.y = y
    self._currentTranslation.z = z
    applyTranslationValue(x, y, z)
    self._checkTransRot = 1
  elseif 2 == updateControlMode then
    local x = self:CalculateSliderValue(self._ui._slider_Rotation[0], self._selectedRotMin.x, self._selectedRotMax.x)
    local y = self:CalculateSliderValue(self._ui._slider_Rotation[1], self._selectedRotMin.y, self._selectedRotMax.y)
    local z = self:CalculateSliderValue(self._ui._slider_Rotation[2], self._selectedRotMin.z, self._selectedRotMax.z)
    self._currentRotation.x = x
    self._currentRotation.y = y
    self._currentRotation.z = z
    applyRotationValue(x, y, z)
    self._checkTransRot = 2
  end
end
function HandleClicked_Customization_HairShape_UpdateHairLength(sliderIndex)
  local self = Customization_HairShapeInfo
  local value = PaGlobalFunc_CustomIzationCommon_GetSliderValue(self._ui._slider_Length[sliderIndex], self._paramMin[sliderIndex], self._paramMax[sliderIndex])
  setParam(self._currentClassType, self._paramType[sliderIndex], self._paramIndex[sliderIndex], value)
  self._ui._staticText_LengthValue[sliderIndex]:SetText(value)
  local progress = UI.getChildControl(self._ui._slider_Length[sliderIndex], "Progress2_1")
  local button = UI.getChildControl(self._ui._slider_Length[sliderIndex], "Slider_DisplayButton")
  local progressValue = (value - self._paramMin[sliderIndex]) / (self._paramMax[sliderIndex] - self._paramMin[sliderIndex])
  local offset = math.cos(progressValue * math.pi) * 2
  progress:SetProgressRate(progressValue * 100 + offset)
  button:SetPosX(self._ui._slider_Length[sliderIndex]:GetControlButton():GetPosX())
end
function Customization_HairShapeInfo:UpdateHairRadioButtons(updateControlMode)
  if updateControlMode == 1 then
    self._ui._button_Position:SetMonoTone(false)
    self._ui._button_Rotation:SetMonoTone(true)
  elseif updateControlMode == 2 then
    self._ui._button_Position:SetMonoTone(true)
    self._ui._button_Rotation:SetMonoTone(false)
  end
  self._controlMode = updateControlMode
end
function PaGlobalFunc_Customization_HairShape_SetBoneControl(isSet)
  local self = Customization_HairShapeInfo
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  if false == isSet then
    self._isBoneControl = false
    PaGlobalFunc_Customization_SetKeyGuide(3)
    Panel_Customizing_HairShape:ignorePadSnapUpdate(false)
    ToClient_StartOrEndShapeBoneControlStart(false)
    PaGlobalFunc_Customization_HairShape_Update()
    PaGlobalFunc_Customization_HairShape_SetShow(true)
  else
    if true ~= self._isExistBone then
      return
    end
    self._isBoneControl = true
    PaGlobalFunc_Customization_SetKeyGuide(4)
    Panel_Customizing_HairShape:ignorePadSnapUpdate(true)
    ToClient_StartOrEndShapeBoneControlStart(true)
    PaGlobalFunc_CustomizingKeyGuide_Open(PaGlobalFunc_Customization_HairShape_SetBoneControl, 0)
    PaGlobalFunc_Customization_HairShape_SetShow(false)
  end
end
function Customization_HairShapeInfo:InitControl()
  self._ui._checkBox_ShowPart = UI.getChildControl(self._ui._static_ButtonBg, "CheckButton_ShowPart")
  self._ui._checkBox_ShowPart:SetCheck(true)
  self._ui._button_ResetPart = UI.getChildControl(self._ui._static_ButtonBg, "Button_ResetPart")
  self._ui._button_ResetAll = UI.getChildControl(self._ui._static_ButtonBg, "Button_ResetAll")
  self._ui._static_PositionSliderBg = {}
  self._ui._static_PositionSliderBg[0] = UI.getChildControl(self._ui._static_PositionSliderGroup, "Static_XBg")
  self._ui._static_PositionSliderBg[1] = UI.getChildControl(self._ui._static_PositionSliderGroup, "Static_YBg")
  self._ui._static_PositionSliderBg[2] = UI.getChildControl(self._ui._static_PositionSliderGroup, "Static_ZBg")
  self._ui._staticText_PositionSlider = {}
  self._ui._staticText_PositionSlider[0] = UI.getChildControl(self._ui._static_PositionSliderBg[0], "StaticText_Title")
  self._ui._staticText_PositionSlider[1] = UI.getChildControl(self._ui._static_PositionSliderBg[1], "StaticText_Title")
  self._ui._staticText_PositionSlider[2] = UI.getChildControl(self._ui._static_PositionSliderBg[2], "StaticText_Title")
  self._ui._slider_Position = {}
  self._ui._slider_Position[0] = UI.getChildControl(self._ui._static_PositionSliderBg[0], "Slider_X")
  self._ui._slider_Position[1] = UI.getChildControl(self._ui._static_PositionSliderBg[1], "Slider_Y")
  self._ui._slider_Position[2] = UI.getChildControl(self._ui._static_PositionSliderBg[2], "Slider_Z")
  self._ui._sliderButton_Position = {}
  self._ui._sliderButton_Position[0] = UI.getChildControl(self._ui._slider_Position[0], "Slider_Button")
  self._ui._sliderButton_Position[1] = UI.getChildControl(self._ui._slider_Position[1], "Slider_Button")
  self._ui._sliderButton_Position[2] = UI.getChildControl(self._ui._slider_Position[2], "Slider_Button")
  self._ui._static_RotationSliderBg = {}
  self._ui._static_RotationSliderBg[0] = UI.getChildControl(self._ui._static_RotationSliderGroup, "Static_XBg")
  self._ui._static_RotationSliderBg[1] = UI.getChildControl(self._ui._static_RotationSliderGroup, "Static_YBg")
  self._ui._static_RotationSliderBg[2] = UI.getChildControl(self._ui._static_RotationSliderGroup, "Static_ZBg")
  self._ui._staticText_RotationSlider = {}
  self._ui._staticText_RotationSlider[0] = UI.getChildControl(self._ui._static_RotationSliderBg[0], "StaticText_Title")
  self._ui._staticText_RotationSlider[1] = UI.getChildControl(self._ui._static_RotationSliderBg[1], "StaticText_Title")
  self._ui._staticText_RotationSlider[2] = UI.getChildControl(self._ui._static_RotationSliderBg[2], "StaticText_Title")
  self._ui._slider_Rotation = {}
  self._ui._slider_Rotation[0] = UI.getChildControl(self._ui._static_RotationSliderBg[0], "Slider_X")
  self._ui._slider_Rotation[1] = UI.getChildControl(self._ui._static_RotationSliderBg[1], "Slider_Y")
  self._ui._slider_Rotation[2] = UI.getChildControl(self._ui._static_RotationSliderBg[2], "Slider_Z")
  self._ui._sliderButton_Rotation = {}
  self._ui._sliderButton_Rotation[0] = UI.getChildControl(self._ui._slider_Rotation[0], "Slider_Button")
  self._ui._sliderButton_Rotation[1] = UI.getChildControl(self._ui._slider_Rotation[1], "Slider_Button")
  self._ui._sliderButton_Rotation[2] = UI.getChildControl(self._ui._slider_Rotation[2], "Slider_Button")
  self._ui._static_LengthSliderBg = {}
  self._ui._static_LengthSliderBg[0] = UI.getChildControl(self._ui._static_LenghtSliderGroup, "Static_Length1Bg")
  self._ui._static_LengthSliderBg[1] = UI.getChildControl(self._ui._static_LenghtSliderGroup, "Static_Length2Bg")
  self._ui._static_LengthSliderBg[2] = UI.getChildControl(self._ui._static_LenghtSliderGroup, "Static_Length3Bg")
  self._ui._static_LengthSliderBg[3] = UI.getChildControl(self._ui._static_LenghtSliderGroup, "Static_WeightBg")
  self._ui._static_LengthSliderBg[4] = UI.getChildControl(self._ui._static_LenghtSliderGroup, "Static_StepBg")
  self._ui._staticText_LengthSlider = {}
  self._ui._staticText_LengthSlider[0] = UI.getChildControl(self._ui._static_LengthSliderBg[0], "StaticText_Title")
  self._ui._staticText_LengthSlider[1] = UI.getChildControl(self._ui._static_LengthSliderBg[1], "StaticText_Title")
  self._ui._staticText_LengthSlider[2] = UI.getChildControl(self._ui._static_LengthSliderBg[2], "StaticText_Title")
  self._ui._staticText_LengthSlider[3] = UI.getChildControl(self._ui._static_LengthSliderBg[3], "StaticText_Title")
  self._ui._staticText_LengthSlider[4] = UI.getChildControl(self._ui._static_LengthSliderBg[4], "StaticText_Title")
  self._ui._staticText_LengthValue = {}
  self._ui._staticText_LengthValue[0] = UI.getChildControl(self._ui._static_LengthSliderBg[0], "StaticText_Length1Value")
  self._ui._staticText_LengthValue[1] = UI.getChildControl(self._ui._static_LengthSliderBg[1], "StaticText_Length2Value")
  self._ui._staticText_LengthValue[2] = UI.getChildControl(self._ui._static_LengthSliderBg[2], "StaticText_Length3Value")
  self._ui._staticText_LengthValue[3] = UI.getChildControl(self._ui._static_LengthSliderBg[3], "StaticText_WeightValue")
  self._ui._staticText_LengthValue[4] = UI.getChildControl(self._ui._static_LengthSliderBg[4], "StaticText_StepValue")
  self._ui._slider_Length = {}
  self._ui._slider_Length[0] = UI.getChildControl(self._ui._static_LengthSliderBg[0], "Slider_Length1")
  self._ui._slider_Length[1] = UI.getChildControl(self._ui._static_LengthSliderBg[1], "Slider_Length2")
  self._ui._slider_Length[2] = UI.getChildControl(self._ui._static_LengthSliderBg[2], "Slider_Length3")
  self._ui._slider_Length[3] = UI.getChildControl(self._ui._static_LengthSliderBg[3], "Slider_Weight")
  self._ui._slider_Length[4] = UI.getChildControl(self._ui._static_LengthSliderBg[4], "Slider_Step")
  self._ui._sliderButton_Length = {}
  self._ui._sliderButton_Length[0] = UI.getChildControl(self._ui._slider_Length[0], "Slider_Button")
  self._ui._sliderButton_Length[1] = UI.getChildControl(self._ui._slider_Length[1], "Slider_Button")
  self._ui._sliderButton_Length[2] = UI.getChildControl(self._ui._slider_Length[2], "Slider_Button")
  self._ui._sliderButton_Length[3] = UI.getChildControl(self._ui._slider_Length[3], "Slider_Button")
  self._ui._sliderButton_Length[4] = UI.getChildControl(self._ui._slider_Length[4], "Slider_Button")
end
function Customization_HairShapeInfo:InitEvent()
  self._ui._button_Position:addInputEvent("Mouse_LUp", "HandleClicked_Customization_HairShape_CursorSelect(1)")
  self._ui._button_Rotation:addInputEvent("Mouse_LUp", "HandleClicked_Customization_HairShape_CursorSelect(2)")
  for index = 0, 2 do
    self._ui._slider_Position[index]:addInputEvent("Mouse_LPress", "HandleClicked_Customization_HairShape_UpdateHairBone(1)")
    self._ui._sliderButton_Position[index]:SetIgnore(true)
    self._ui._slider_Position[index]:addInputEvent("Mouse_On", "HandleClicked_Customization_HairShape_SliderFocusOn()")
    self._ui._slider_Position[index]:addInputEvent("Mouse_Out", "HandleClicked_Customization_HairShape_SliderFocusOut()")
    self._ui._slider_Rotation[index]:addInputEvent("Mouse_LPress", "HandleClicked_Customization_HairShape_UpdateHairBone(2)")
    self._ui._sliderButton_Rotation[index]:SetIgnore(true)
    self._ui._slider_Rotation[index]:addInputEvent("Mouse_On", "HandleClicked_Customization_HairShape_SliderFocusOn()")
    self._ui._slider_Rotation[index]:addInputEvent("Mouse_Out", "HandleClicked_Customization_HairShape_SliderFocusOut()")
  end
  for index = 0, 4 do
    self._ui._slider_Length[index]:addInputEvent("Mouse_LPress", "HandleClicked_Customization_HairShape_UpdateHairLength(" .. index .. ")")
    self._ui._sliderButton_Length[index]:SetIgnore(true)
    self._ui._slider_Length[index]:addInputEvent("Mouse_On", "HandleClicked_Customization_HairShape_SliderFocusOn()")
    self._ui._slider_Length[index]:addInputEvent("Mouse_Out", "HandleClicked_Customization_HairShape_SliderFocusOut()")
  end
  self._ui._checkBox_ShowPart:addInputEvent("Mouse_LUp", "HandleClicked_Customization_HairShape_ToggleShowHairBoneControlPart()")
  self._ui._button_ResetPart:addInputEvent("Mouse_LUp", "HandleClicked_Customization_HairShape_ClearCustomizedBoneInfo()")
  self._ui._button_ResetAll:addInputEvent("Mouse_LUp", "PaGlobalFunc_CustomIzationCommon_ClearGroupCustomizedBonInfoLua()")
end
function Customization_HairShapeInfo:InitRegister()
  registerEvent("EventOpenHairShapeUi", "PaGlobalFunc_Customization_HairShape_OpenHairShapeUi")
  registerEvent("EventCloseHairShapeUi", "PaGlobalFunc_Customization_HairShape_CloseHairShapeUi")
  registerEvent("EventOpenHairShapeUiWithoutBoneControl", "PaGlobalFunc_Customization_HairShape_OpenHairShapeUiWithoutBoneControl")
  registerEvent("EventCloseHairShapeUiWithoutBoneControl", "PaGlobalFunc_Customization_HairShape_CloseHairShapeUiWithoutBoneControl")
  registerEvent("EventPickingHairBone", "PaGlobalFunc_Customization_HairShape_PickingHairBone")
  registerEvent("EventAdjustHairBoneTranslation", "PaGlobalFunc_Customization_HairShape_AdjustHairBoneTranslation")
  registerEvent("EventAdjustHairBoneRotation", "PaGlobalFunc_Customization_HairShape_AdjustHairBoneRotation")
  registerEvent("EventEnableHairSlide", "PaGlobalFunc_Customization_HairShape_EnableHairSlide")
end
function Customization_HairShapeInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function PaGlobalFunc_FromClient_Customization_HairShape_luaLoadComplete()
  local self = Customization_HairShapeInfo
  self:Initialize()
end
function PaGlobalFunc_Customization_HairShape_IsBone()
  local self = Customization_HairShapeInfo
  return self._isExistBone
end
function PaGlobalFunc_Customization_HairShape_GetPanel()
  return Panel_Customizing_HairShape
end
function PaGlobalFunc_Customization_HairShape_GetShow()
  return Panel_Customizing_HairShape:GetShow()
end
function PaGlobalFunc_Customization_HairShape_SetShow(isShow, isAni)
  Panel_Customizing_HairShape:SetShow(isShow, isAni)
end
function PaGlobalFunc_Customization_HairShape_Open()
  local self = Customization_HairShapeInfo
  if true == PaGlobalFunc_Customization_HairShape_GetShow() then
    return
  end
  PaGlobalFunc_Customization_HairShape_SetShow(true, false)
  PaGlobalFunc_Customization_KeyGuideSetShow(true)
  if true == self._isExistBone then
    PaGlobalFunc_Customization_SetKeyGuide(3)
  else
    PaGlobalFunc_Customization_SetKeyGuide(7)
  end
  HandleClicked_Customization_HairShape_ToggleShowHairBoneControlPart()
  PaGlobalFunc_Customization_SetCloseFunc(PaGlobalFunc_Customization_HairShape_Close)
  PaGlobalFunc_Customization_SetBackEvent("PaGlobalFunc_Customization_HairShape_Close()")
end
function PaGlobalFunc_Customization_HairShape_Close()
  local self = Customization_HairShapeInfo
  if false == PaGlobalFunc_Customization_HairShape_GetShow() then
    return false
  end
  if true == self._isBoneControl then
    PaGlobalFunc_Customization_HairShape_SetBoneControl(false)
    return false
  end
  endPickingMode()
  self._isExistBone = true
  PaGlobalFunc_Customization_SetKeyGuide(0)
  PaGlobalFunc_Customization_SetCloseFunc(nil)
  PaGlobalFunc_Customization_SetBackEvent()
  PaGlobalFunc_Customization_HairShape_SetShow(false, false)
  return true
end
function PaGlobalFunc_Customization_HairShape_Update()
  local self = Customization_HairShapeInfo
  self._selectedTransMin = getSelectedBoneMinTrans()
  self._selectedTransMax = getSelectedBoneMaxTrans()
  self._selectedRotMin = getSelectedBoneMinRot()
  self._selectedRotMax = getSelectedBoneMaxRot()
  self:CalculateSliderValue(self._ui._slider_Position[0], self._selectedTransMin.x, self._selectedTransMax.x)
  self:CalculateSliderValue(self._ui._slider_Position[1], self._selectedTransMin.y, self._selectedTransMax.y)
  self:CalculateSliderValue(self._ui._slider_Position[2], self._selectedTransMin.z, self._selectedTransMax.z)
  self:CalculateSliderValue(self._ui._slider_Rotation[0], self._selectedRotMin.x, self._selectedRotMax.x)
  self:CalculateSliderValue(self._ui._slider_Rotation[1], self._selectedRotMin.y, self._selectedRotMax.y)
  self:CalculateSliderValue(self._ui._slider_Rotation[2], self._selectedRotMin.z, self._selectedRotMax.z)
end
PaGlobalFunc_FromClient_Customization_HairShape_luaLoadComplete()

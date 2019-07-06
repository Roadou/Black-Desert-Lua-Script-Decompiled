local RadioButton_Bone_Trans = UI.getChildControl(Panel_CustomizationTransformHair, "RadioButton_Bone_Trans")
local RadioButton_Bone_Rot = UI.getChildControl(Panel_CustomizationTransformHair, "RadioButton_Bone_Rot")
local StaticText_DefaultControl = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_DefaultControl")
local StaticText_ControlPart = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_ControlPart")
local StaticText_TransX = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_TransX")
local StaticText_TransY = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_TransY")
local StaticText_TransZ = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_TransZ")
local Slider_TransX = UI.getChildControl(Panel_CustomizationTransformHair, "Slider_TransX_Controller")
local Slider_TransY = UI.getChildControl(Panel_CustomizationTransformHair, "Slider_TransY_Controller")
local Slider_TransZ = UI.getChildControl(Panel_CustomizationTransformHair, "Slider_TransZ_Controller")
local Button_Slider_TransX = UI.getChildControl(Slider_TransX, "Slider_GammaController_Button")
local Button_Slider_TransY = UI.getChildControl(Slider_TransY, "Slider_GammaController_Button")
local Button_Slider_TransZ = UI.getChildControl(Slider_TransZ, "Slider_GammaController_Button")
local StaticText_RotX = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_RotX")
local StaticText_RotY = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_RotY")
local StaticText_RotZ = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_RotZ")
local Slider_RotX = UI.getChildControl(Panel_CustomizationTransformHair, "Slider_RotX_Controller")
local Slider_RotY = UI.getChildControl(Panel_CustomizationTransformHair, "Slider_RotY_Controller")
local Slider_RotZ = UI.getChildControl(Panel_CustomizationTransformHair, "Slider_RotZ_Controller")
local Button_Slider_RotX = UI.getChildControl(Slider_RotX, "Slider_GammaController_Button")
local Button_Slider_RotY = UI.getChildControl(Slider_RotY, "Slider_GammaController_Button")
local Button_Slider_RotZ = UI.getChildControl(Slider_RotZ, "Slider_GammaController_Button")
local SliderArr = {}
local Button_SliderArr = {}
local StaticTextArr = {}
local StaticText_CurrentValue = {}
SliderArr[1] = UI.getChildControl(Panel_CustomizationTransformHair, "Slider_Controller1")
SliderArr[2] = UI.getChildControl(Panel_CustomizationTransformHair, "Slider_Controller2")
SliderArr[3] = UI.getChildControl(Panel_CustomizationTransformHair, "Slider_Controller3")
SliderArr[4] = UI.getChildControl(Panel_CustomizationTransformHair, "Slider_Controller4")
SliderArr[5] = UI.getChildControl(Panel_CustomizationTransformHair, "Slider_Controller5")
Button_SliderArr[1] = UI.getChildControl(SliderArr[1], "Slider_GammaController_Button")
Button_SliderArr[2] = UI.getChildControl(SliderArr[2], "Slider_GammaController_Button")
Button_SliderArr[3] = UI.getChildControl(SliderArr[3], "Slider_GammaController_Button")
Button_SliderArr[4] = UI.getChildControl(SliderArr[4], "Slider_GammaController_Button")
Button_SliderArr[5] = UI.getChildControl(SliderArr[5], "Slider_GammaController_Button")
StaticTextArr[1] = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderDesc1")
StaticTextArr[2] = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderDesc2")
StaticTextArr[3] = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderDesc3")
StaticTextArr[4] = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderDesc4")
StaticTextArr[5] = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderDesc5")
StaticText_CurrentValue[1] = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderValue1")
StaticText_CurrentValue[2] = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderValue2")
StaticText_CurrentValue[3] = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderValue3")
StaticText_CurrentValue[4] = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderValue4")
StaticText_CurrentValue[5] = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderValue5")
local CheckButton_ControlPart = UI.getChildControl(Panel_CustomizationTransformHair, "CheckButton_ControlPart")
local Button_All_Reset = UI.getChildControl(Panel_CustomizationTransformHair, "Button_All_Reset")
local Button_Part_Reset = UI.getChildControl(Panel_CustomizationTransformHair, "Button_Part_Reset")
local StaticText_CurrValue_TransX = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_Slider_TransX_Left")
local StaticText_CurrValue_TransY = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_Slider_TransY_Left")
local StaticText_CurrValue_TransZ = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_Slider_TransZ_Left")
StaticText_CurrValue_TransX:SetShow(false)
StaticText_CurrValue_TransY:SetShow(false)
StaticText_CurrValue_TransZ:SetShow(false)
StaticText_DefaultControl:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONTRANSFORM_STATICTEXT_DEFAULTCONTROL"))
StaticText_ControlPart:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_CONTROLPART"))
Button_All_Reset:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_ALL_RESET"))
Button_Part_Reset:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_PART_RESET"))
CheckButton_ControlPart:SetCheck(true)
RadioButton_Bone_Trans:addInputEvent("Mouse_LUp", "CursorSelect(1)")
RadioButton_Bone_Rot:addInputEvent("Mouse_LUp", "CursorSelect(2)")
Slider_TransX:addInputEvent("Mouse_LPress", "UpdateHairBone(1)")
Slider_TransY:addInputEvent("Mouse_LPress", "UpdateHairBone(1)")
Slider_TransZ:addInputEvent("Mouse_LPress", "UpdateHairBone(1)")
Button_Slider_TransX:addInputEvent("Mouse_LPress", "UpdateHairBone(1)")
Button_Slider_TransY:addInputEvent("Mouse_LPress", "UpdateHairBone(1)")
Button_Slider_TransZ:addInputEvent("Mouse_LPress", "UpdateHairBone(1)")
Slider_RotX:addInputEvent("Mouse_LPress", "UpdateHairBone(2)")
Slider_RotY:addInputEvent("Mouse_LPress", "UpdateHairBone(2)")
Slider_RotZ:addInputEvent("Mouse_LPress", "UpdateHairBone(2)")
Button_Slider_RotX:addInputEvent("Mouse_LPress", "UpdateHairBone(2)")
Button_Slider_RotY:addInputEvent("Mouse_LPress", "UpdateHairBone(2)")
Button_Slider_RotZ:addInputEvent("Mouse_LPress", "UpdateHairBone(2)")
Slider_TransX:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Slider_TransY:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Slider_TransZ:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_Slider_TransX:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_Slider_TransY:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_Slider_TransZ:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Slider_RotX:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Slider_RotY:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Slider_RotZ:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_Slider_RotX:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_Slider_RotY:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_Slider_RotZ:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
SliderArr[1]:addInputEvent("Mouse_LPress", "UpdateHairSlider(0)")
SliderArr[2]:addInputEvent("Mouse_LPress", "UpdateHairSlider(1)")
SliderArr[3]:addInputEvent("Mouse_LPress", "UpdateHairSlider(2)")
SliderArr[4]:addInputEvent("Mouse_LPress", "UpdateHairSlider(3)")
SliderArr[5]:addInputEvent("Mouse_LPress", "UpdateHairSlider(4)")
Button_SliderArr[1]:addInputEvent("Mouse_LPress", "UpdateHairSlider(0)")
Button_SliderArr[2]:addInputEvent("Mouse_LPress", "UpdateHairSlider(1)")
Button_SliderArr[3]:addInputEvent("Mouse_LPress", "UpdateHairSlider(2)")
Button_SliderArr[4]:addInputEvent("Mouse_LPress", "UpdateHairSlider(3)")
Button_SliderArr[5]:addInputEvent("Mouse_LPress", "UpdateHairSlider(4)")
SliderArr[1]:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
SliderArr[2]:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
SliderArr[3]:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
SliderArr[4]:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
SliderArr[5]:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_SliderArr[1]:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_SliderArr[2]:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_SliderArr[3]:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_SliderArr[4]:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_SliderArr[5]:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_All_Reset:addInputEvent("Mouse_LUp", "clearGroupCustomizedBonInfoLua()")
Button_Part_Reset:addInputEvent("Mouse_LUp", "clearCustomizedBoneInfo()")
CheckButton_ControlPart:addInputEvent("Mouse_LUp", "ToggleShowHairBoneControlPart()")
if false == _ContentsGroup_RenewUI_Customization then
  registerEvent("EventOpenHairShapeUi", "OpenHairShapeUi")
  registerEvent("EventCloseHairShapeUi", "CloseHairShapeUi")
  registerEvent("EventOpenHairShapeUiWithoutBoneControl", "OpenHairShapeUiWithoutBoneControl")
  registerEvent("EventCloseHairShapeUiWithoutBoneControl", "CloseHairShapeUiWithoutBoneControl")
  registerEvent("EventPickingHairBone", "PickingHairBone")
  registerEvent("EventAdjustHairBoneTranslation", "AdjustHairBoneTranslation")
  registerEvent("EventAdjustHairBoneRotation", "AdjustHairBoneRotation")
  registerEvent("EventEnableHairSlide", "EnableHairSlide")
end
local transMin, transMax, currentTranslation, rotMin, rotMax, currentRotation
local paramType = {}
local paramIndex = {}
local SculptingUIRect = {
  left,
  top,
  right,
  bottom
}
local selectedClassType = -1
local sliderContentsStartY = 125
local sliderTextGap = 3
local contentsGapHeight = 10
local selectedClassIndex = 0
local param = {}
local paramMin = {}
local paramMax = {}
local paramDefault = {}
local iswithoutbone = true
local currentclassType = -1
local currentuiId = -1
local checktransrot = 1
local function UpdateHairBoneControls()
  if currentTranslation ~= nil then
    setValueSlider(Slider_TransX, currentTranslation.x, transMin.x, transMax.x)
    setValueSlider(Slider_TransY, currentTranslation.y, transMin.y, transMax.y)
    setValueSlider(Slider_TransZ, currentTranslation.z, transMin.z, transMax.z)
  end
  if currentRotation ~= nil then
    setValueSlider(Slider_RotX, currentRotation.x, rotMin.x, rotMax.x)
    setValueSlider(Slider_RotY, currentRotation.y, rotMin.y, rotMax.y)
    setValueSlider(Slider_RotZ, currentRotation.z, rotMin.z, rotMax.z)
  end
end
local floatString = function(floatValue)
  return string.format("%.2f", floatValue)
end
local function ShowBoneControls(show)
  StaticText_DefaultControl:SetShow(show)
  RadioButton_Bone_Trans:SetShow(show)
  StaticText_TransX:SetShow(show)
  StaticText_TransY:SetShow(show)
  StaticText_TransZ:SetShow(show)
  Slider_TransX:SetShow(show)
  Slider_TransY:SetShow(show)
  Slider_TransZ:SetShow(show)
  RadioButton_Bone_Rot:SetShow(show)
  StaticText_RotX:SetShow(show)
  StaticText_RotY:SetShow(show)
  StaticText_RotZ:SetShow(show)
  Slider_RotX:SetShow(show)
  Slider_RotY:SetShow(show)
  Slider_RotZ:SetShow(show)
  StaticText_ControlPart:SetShow(show)
  CheckButton_ControlPart:SetShow(show)
  Button_Part_Reset:SetShow(show)
  Button_All_Reset:SetShow(show)
end
local EnableSlide = function(static1, static2, slide, enable)
  local color = Defines.Color.C_FF444444
  if enable then
    color = Defines.Color.C_FFFFFFFF
  end
  slide:SetMonoTone(not enable)
  slide:SetEnable(enable)
  static1:SetFontColor(color)
  static2:SetFontColor(color)
end
local function UpdateHairRadioButtons(updateControlMode)
  if updateControlMode == 1 then
    RadioButton_Bone_Trans:SetCheck(true)
    RadioButton_Bone_Rot:SetCheck(false)
  elseif updateControlMode == 2 then
    RadioButton_Bone_Trans:SetCheck(false)
    RadioButton_Bone_Rot:SetCheck(true)
  end
end
function UpdateHairBone(updateControlMode)
  if ControlMode ~= updateControlMode then
    UpdateHairRadioButtons(updateControlMode)
  end
  CursorSelect(updateControlMode)
  if updateControlMode == 1 then
    local x = calculateSliderValue(Slider_TransX, transMin.x, transMax.x)
    local y = calculateSliderValue(Slider_TransY, transMin.y, transMax.y)
    local z = calculateSliderValue(Slider_TransZ, transMin.z, transMax.z)
    currentTranslation.x = x
    currentTranslation.y = y
    currentTranslation.z = z
    applyTranslationValue(x, y, z)
    checktransrot = 1
  elseif updateControlMode == 2 then
    local x = calculateSliderValue(Slider_RotX, rotMin.x, rotMax.x)
    local y = calculateSliderValue(Slider_RotY, rotMin.y, rotMax.y)
    local z = calculateSliderValue(Slider_RotZ, rotMin.z, rotMax.z)
    currentRotation.x = x
    currentRotation.y = y
    currentRotation.z = z
    checktransrot = 2
    applyRotationValue(x, y, z)
  end
end
function UpdateHairSlider(sliderIndex)
  local luaSliderIndex = sliderIndex + 1
  local value = getSliderValue(SliderArr[luaSliderIndex], paramMin[luaSliderIndex], paramMax[luaSliderIndex])
  setParam(selectedClassType, paramType[luaSliderIndex], paramIndex[luaSliderIndex], value)
  StaticText_CurrentValue[luaSliderIndex]:SetText(value)
  if false == Slider_TransX:IsEnable() or iswithoutbone then
    setGlobalCheck(true)
  end
end
function OpenHairShapeUi(classType, uiId)
  iswithoutbone = false
  globalcurrentclassType = classType
  globalcurrentuiId = uiId
  currentclassType = classType
  currentuiId = uiId
  selectedClassType = classType
  CameraLookEnable(false)
  CursorSelect(checktransrot)
  EnableHairSlide(false)
  startHairPickingMode()
  selectedClassType = classType
  ShowBoneControls(true)
  local defaultContentsIndex = 0
  local sliderNum = getUiSliderCount(classType, uiId, defaultContentsIndex)
  local controlPosY = 206
  StaticText_ControlPart:SetPosY(controlPosY)
  controlPosY = controlPosY + 2
  CheckButton_ControlPart:SetPosY(controlPosY)
  controlPosY = controlPosY + CheckButton_ControlPart:GetSizeY() + 5
  Button_Part_Reset:SetPosY(controlPosY)
  Button_All_Reset:SetPosY(controlPosY)
  controlPosY = controlPosY + Button_Part_Reset:GetSizeY() + contentsGapHeight
  local meshParamType = 1
  local curlRange = getCurlLengthRange()
  local sliderValueBasePosX = 0
  for sliderIndex = 0, sliderNum - 1 do
    local luaSliderIndex = sliderIndex + 1
    paramType[luaSliderIndex] = getUiSliderParamType(classType, uiId, defaultContentsIndex, sliderIndex)
    paramIndex[luaSliderIndex] = getUiSliderParamIndex(classType, uiId, defaultContentsIndex, sliderIndex)
    local sliderText = getUiSliderDescName(classType, uiId, defaultContentsIndex, sliderIndex)
    local param = getParam(paramType[luaSliderIndex], paramIndex[luaSliderIndex])
    if sliderIndex >= 0 and sliderIndex < 3 then
      paramMin[luaSliderIndex] = getHairMinLength(sliderIndex)
      paramMax[luaSliderIndex] = getParamMax(classType, paramType[luaSliderIndex], paramIndex[luaSliderIndex])
      paramDefault[luaSliderIndex] = getParamDefault(classType, paramType[luaSliderIndex], paramIndex[luaSliderIndex])
      if paramMin[luaSliderIndex] == paramMax[luaSliderIndex] then
        EnableSlide(StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], false)
      else
        EnableSlide(StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], true)
      end
    elseif sliderIndex == 3 then
      local curlRange = getCurlLengthRange()
      paramMin[luaSliderIndex] = 50 - curlRange / 2
      paramMax[luaSliderIndex] = 50 + curlRange / 2
      paramDefault[luaSliderIndex] = getParamDefault(classType, paramType[luaSliderIndex], paramIndex[luaSliderIndex])
      if curlRange == 0 then
        EnableSlide(StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], false)
      else
        EnableSlide(StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], true)
      end
    elseif sliderIndex == 4 then
      paramMin[luaSliderIndex] = getParamMin(classType, paramType[luaSliderIndex], paramIndex[luaSliderIndex])
      paramMax[luaSliderIndex] = getParamMax(classType, paramType[luaSliderIndex], paramIndex[luaSliderIndex])
      paramDefault[luaSliderIndex] = getParamDefault(classType, paramType[luaSliderIndex], paramIndex[luaSliderIndex])
      if curlRange == 0 then
        EnableSlide(StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], false)
      else
        EnableSlide(StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], true)
      end
    end
    StaticTextArr[luaSliderIndex]:SetText(PAGetString(Defines.StringSheet_GAME, sliderText))
    StaticText_CurrentValue[luaSliderIndex]:SetText(param)
    setSliderValue(SliderArr[luaSliderIndex], param, paramMin[luaSliderIndex], paramMax[luaSliderIndex])
    StaticTextArr[luaSliderIndex]:SetPosY(controlPosY)
    SliderArr[luaSliderIndex]:SetPosY(controlPosY + sliderTextGap)
    StaticText_CurrentValue[luaSliderIndex]:SetPosY(controlPosY + sliderTextGap)
    local sliderTextSizeX = StaticTextArr[luaSliderIndex]:GetPosX() + StaticTextArr[luaSliderIndex]:GetTextSizeX()
    local sliderValuePosX = StaticText_CurrentValue[luaSliderIndex]:GetPosX()
    if sliderTextSizeX > sliderValuePosX then
      sliderValueBasePosX = math.max(sliderValueBasePosX, sliderTextSizeX)
    end
    controlPosY = controlPosY + contentsGapHeight + StaticTextArr[luaSliderIndex]:GetSizeY()
  end
  if sliderValueBasePosX > 0 then
    for sliderIndex = 0, sliderNum - 1 do
      local luaSliderIndex = sliderIndex + 1
      local sliderValuePosX = StaticText_CurrentValue[luaSliderIndex]:GetPosX()
      StaticText_CurrentValue[luaSliderIndex]:SetPosX(sliderValueBasePosX + 5)
      SliderArr[luaSliderIndex]:SetSize(174 - (sliderValueBasePosX - sliderValuePosX), SliderArr[luaSliderIndex]:GetSizeY())
      SliderArr[luaSliderIndex]:SetPosX(95 + (sliderValueBasePosX - sliderValuePosX) + 5)
      paramType[luaSliderIndex] = getUiSliderParamType(classType, uiId, defaultContentsIndex, sliderIndex)
      paramIndex[luaSliderIndex] = getUiSliderParamIndex(classType, uiId, defaultContentsIndex, sliderIndex)
      local sliderParam = getParam(paramType[luaSliderIndex], paramIndex[luaSliderIndex])
      setSliderValue(SliderArr[luaSliderIndex], sliderParam, paramMin[luaSliderIndex], paramMax[luaSliderIndex])
      SliderArr[luaSliderIndex]:SetInterval(100)
    end
  end
  Panel_CustomizationTransformHair:SetSize(Panel_CustomizationTransformHair:GetSizeX(), controlPosY)
  UpdateHairRadioButtons(checktransrot)
  updateGroupFrameControls(Panel_CustomizationTransformHair:GetSizeY(), Panel_CustomizationTransformHair)
  ToggleShowHairBoneControlPart()
end
function OpenHairShapeUiWithoutBoneControl(classType, uiId)
  iswithoutbone = true
  globalcurrentclassType = classType
  globalcurrentuiId = uiId
  currentclassType = classType
  currentuiId = uiId
  selectedClassType = classType
  CameraLookEnable(false)
  ShowBoneControls(false)
  local controlPosY = 10
  local defaultContentsIndex = 0
  sliderCount = getUiSliderCount(classType, uiId, defaultContentsIndex)
  local meshParamType = 1
  local curlRange = getCurlLengthRange()
  for sliderIndex = 0, sliderCount - 1 do
    local luaSliderIndex = sliderIndex + 1
    if CppEnums.CountryType.TH_ALPHA == getGameServiceType() or CppEnums.CountryType.TH_REAL == getGameServiceType() then
      StaticText_CurrentValue[luaSliderIndex]:SetPosX(95)
      SliderArr[luaSliderIndex]:SetPosX(120)
      SliderArr[luaSliderIndex]:SetSize(144, SliderArr[luaSliderIndex]:GetSizeY())
    end
    paramType[luaSliderIndex] = getUiSliderParamType(classType, uiId, defaultContentsIndex, sliderIndex)
    paramIndex[luaSliderIndex] = getUiSliderParamIndex(classType, uiId, defaultContentsIndex, sliderIndex)
    local sliderText = getUiSliderDescName(classType, uiId, defaultContentsIndex, sliderIndex)
    local param = getParam(paramType[luaSliderIndex], paramIndex[luaSliderIndex])
    if sliderIndex >= 0 and sliderIndex < 3 then
      paramMin[luaSliderIndex] = getHairMinLength(sliderIndex)
      paramMax[luaSliderIndex] = getParamMax(classType, paramType[luaSliderIndex], paramIndex[luaSliderIndex])
      paramDefault[luaSliderIndex] = getParamDefault(classType, paramType[luaSliderIndex], paramIndex[luaSliderIndex])
      if paramMin[luaSliderIndex] == paramMax[luaSliderIndex] then
        EnableSlide(StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], false)
      else
        EnableSlide(StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], true)
      end
    elseif sliderIndex == 3 then
      paramMin[luaSliderIndex] = 50 - curlRange / 2
      paramMax[luaSliderIndex] = 50 + curlRange / 2
      paramDefault[luaSliderIndex] = getParamDefault(classType, paramType[luaSliderIndex], paramIndex[luaSliderIndex])
      if curlRange == 0 then
        EnableSlide(StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], false)
      else
        EnableSlide(StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], true)
      end
    elseif sliderIndex == 4 then
      paramMin[luaSliderIndex] = getParamMin(classType, paramType[luaSliderIndex], paramIndex[luaSliderIndex])
      paramMax[luaSliderIndex] = getParamMax(classType, paramType[luaSliderIndex], paramIndex[luaSliderIndex])
      paramDefault[luaSliderIndex] = getParamDefault(classType, paramType[luaSliderIndex], paramIndex[luaSliderIndex])
      if curlRange == 0 then
        EnableSlide(StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], false)
      else
        EnableSlide(StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], true)
      end
    end
    StaticTextArr[luaSliderIndex]:SetText(PAGetString(Defines.StringSheet_GAME, sliderText))
    StaticText_CurrentValue[luaSliderIndex]:SetText(param)
    setSliderValue(SliderArr[luaSliderIndex], param, paramMin[luaSliderIndex], paramMax[luaSliderIndex])
    StaticTextArr[luaSliderIndex]:SetPosY(controlPosY)
    SliderArr[luaSliderIndex]:SetPosY(controlPosY + sliderTextGap)
    StaticText_CurrentValue[luaSliderIndex]:SetPosY(controlPosY + sliderTextGap)
    controlPosY = controlPosY + contentsGapHeight + StaticTextArr[luaSliderIndex]:GetSizeY()
  end
  Panel_CustomizationTransformHair:SetSize(Panel_CustomizationTransformHair:GetSizeX(), controlPosY)
  updateGroupFrameControls(Panel_CustomizationTransformHair:GetSizeY(), Panel_CustomizationTransformHair)
end
function ToggleShowHairBoneControlPart()
  showBoneControlPart(CheckButton_ControlPart:IsCheck())
end
function PickingHairBone()
  EnableHairSlide(true)
  transMin = getSelectedBoneMinTrans()
  transMax = getSelectedBoneMaxTrans()
  currentTranslation = getSelectedBoneTrans()
  rotMin = getSelectedBoneMinRot()
  rotMax = getSelectedBoneMaxRot()
  currentRotation = getSelectedBoneRot()
  if currentTranslation ~= nil then
    setValueSlider(Slider_TransX, currentTranslation.x, transMin.x, transMax.x)
    setValueSlider(Slider_TransY, currentTranslation.y, transMin.y, transMax.y)
    setValueSlider(Slider_TransZ, currentTranslation.z, transMin.z, transMax.z)
  end
  if currentRotation ~= nil then
    setValueSlider(Slider_RotX, currentRotation.x, rotMin.x, rotMax.x)
    setValueSlider(Slider_RotY, currentRotation.y, rotMin.y, rotMax.y)
    setValueSlider(Slider_RotZ, currentRotation.z, rotMin.z, rotMax.z)
  end
end
function EnableHairSlide(enable)
  globalisCustomizationPicking = enable
  Slider_TransX:SetEnable(enable)
  Slider_TransY:SetEnable(enable)
  Slider_TransZ:SetEnable(enable)
  Button_Slider_TransX:SetMonoTone(not enable)
  Button_Slider_TransY:SetMonoTone(not enable)
  Button_Slider_TransZ:SetMonoTone(not enable)
  Slider_RotX:SetEnable(enable)
  Slider_RotY:SetEnable(enable)
  Slider_RotZ:SetEnable(enable)
  Button_Slider_RotX:SetMonoTone(not enable)
  Button_Slider_RotY:SetMonoTone(not enable)
  Button_Slider_RotZ:SetMonoTone(not enable)
  local color = Defines.Color.C_FF444444
  if enable then
    color = Defines.Color.C_FFFFFFFF
  end
  StaticText_CurrValue_TransX:SetFontColor(color)
  StaticText_CurrValue_TransY:SetFontColor(color)
  StaticText_CurrValue_TransZ:SetFontColor(color)
  StaticText_TransX:SetFontColor(color)
  StaticText_TransY:SetFontColor(color)
  StaticText_TransZ:SetFontColor(color)
  StaticText_RotX:SetFontColor(color)
  StaticText_RotY:SetFontColor(color)
  StaticText_RotZ:SetFontColor(color)
end
function AdjustHairBoneTranslation(translationX, translationY, translationZ)
  checktransrot = 1
  setValueSlider(Slider_TransX, translationX, transMin.x, transMax.x)
  StaticText_CurrValue_TransX:SetText(math.floor(translationX * 10) / 10)
  setValueSlider(Slider_TransY, translationY, transMin.y, transMax.y)
  StaticText_CurrValue_TransY:SetText(math.floor(translationY * 10) / 10)
  setValueSlider(Slider_TransZ, translationZ, transMin.z, transMax.z)
  StaticText_CurrValue_TransZ:SetText(math.floor(translationZ * 10) / 10)
  currentTranslation.x = translationX
  currentTranslation.y = translationY
  currentTranslation.z = translationZ
end
function AdjustHairBoneRotation(rotationX, rotationY, rotationZ)
  checktransrot = 2
  setValueSlider(Slider_RotX, rotationX, rotMin.x, rotMax.x)
  setValueSlider(Slider_RotY, rotationY, rotMin.y, rotMax.y)
  setValueSlider(Slider_RotZ, rotationZ, rotMin.z, rotMax.z)
  currentRotation.x = rotationX
  currentRotation.y = rotationY
  currentRotation.z = rotationZ
end
function CloseHairShapeUi()
  endPickingMode()
  CameraLookEnable(true)
  globalcurrentclassType = -2
  globalcurrentuiId = -2
  globalisCustomizationPicking = false
end
function CloseHairShapeUiWithoutBoneControl()
  CameraLookEnable(true)
  globalcurrentclassType = -2
  globalcurrentuiId = -2
  globalisCustomizationPicking = false
end
function HairShapeHistoryApplyUpdate()
  if globalcurrentclassType ~= currentclassType or globalcurrentuiId ~= currentuiId then
    return
  end
  if iswithoutbone then
    OpenHairShapeUiWithoutBoneControl(currentclassType, currentuiId)
  else
    OpenHairShapeUi(currentclassType, currentuiId)
    PickingHairBone()
  end
end

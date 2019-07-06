Panel_Customizing_BodyShape:ignorePadSnapMoveToOtherPanel()
local Customization_BodyBoneInfo = {
  _ui = {
    _static_ButtonBg = UI.getChildControl(Panel_Customizing_BodyShape, "Static_ButtonGroup"),
    _static_BodySliderGroup = UI.getChildControl(Panel_Customizing_BodyShape, "Static_SliderGroup1"),
    _static_ScaleSliderGroup = UI.getChildControl(Panel_Customizing_BodyShape, "Static_SliderGroup2"),
    _static_KeyGuideBg = UI.getChildControl(Panel_Customizing_BodyShape, "Static_KeyGuideBg"),
    _button_Scale = UI.getChildControl(Panel_Customizing_BodyShape, "Button_Scale")
  },
  _currentClassType,
  _currentUiId,
  _selectScaleMin,
  _selectScaleMax,
  _currentScale,
  _controlMode,
  _lastScaleMin,
  _lastScaleMax,
  _lastScale,
  _currentData = nil,
  _isBoneControl = false
}
function Customization_BodyBoneInfo:EnableBodySlide(enable)
  local color = Defines.Color.C_FF444444
  if enable then
    color = Defines.Color.C_FFFFFFFF
  end
  self._ui._staticText_ScaleSliderX_Title:SetFontColor(color)
  self._ui._staticText_ScaleSliderY_Title:SetFontColor(color)
  self._ui._staticText_ScaleSliderZ_Title:SetFontColor(color)
  self._ui._slider_ScaleX:SetMonoTone(not enable)
  self._ui._slider_ScaleY:SetMonoTone(not enable)
  self._ui._slider_ScaleZ:SetMonoTone(not enable)
  self._ui._slider_ScaleX:SetIgnore(not enable)
  self._ui._slider_ScaleY:SetIgnore(not enable)
  self._ui._slider_ScaleZ:SetIgnore(not enable)
  self._ui._slider_ScaleX:SetEnable(enable)
  self._ui._slider_ScaleY:SetEnable(enable)
  self._ui._slider_ScaleZ:SetEnable(enable)
end
function Customization_BodyBoneInfo:CalculateSliderValue(sliderControl, valueMin, valueMax)
  local ratio = sliderControl:GetControlPos()
  local val = valueMax - valueMin
  local progress = UI.getChildControl(sliderControl, "Progress2_1")
  local button = UI.getChildControl(sliderControl, "Slider_DisplayButton")
  button:SetPosX(sliderControl:GetControlButton():GetPosX())
  local offset = math.cos(ratio * math.pi) * 2
  progress:SetProgressRate(ratio * 100 + offset)
  return ratio * val - (val - math.abs(valueMax))
end
function Customization_BodyBoneInfo:SetValueSlider(sliderControl, value, valueMin, valueMax)
  local val = valueMax - valueMin
  if val ~= 0 then
    sliderControl:SetControlPos((value - valueMin) / val * 100)
  end
end
function PaGlobalFunc_Customization_BodyBone_OpenBodyShapeUi(classType, uiId)
  local self = Customization_BodyBoneInfo
  self._currentClassType = classType
  self._currentUiId = uiId
  startBodyPickingMode()
  self:EnableBodySlide(false)
  PaGlobalFunc_Customization_BodyBone_ShowBodyBoneEditor()
  if self._ui._checkBox_ShowPart:IsCheck() then
    showBoneControlPart(true)
  else
    showBoneControlPart(false)
  end
  PaGlobalFunc_Customization_BodyBone_Open()
end
function PaGlobalFunc_Customization_BodyBone_CloseBodyShapeUi()
  local self = Customization_BodyBoneInfo
  endPickingMode()
  PaGlobalFunc_Customization_BodyPose_ToggleShowPosePreCheck()
  PaGlobalFunc_Customization_BodyBone_Close()
end
function PaGlobalFunc_Customization_BodyBone_EnableBodySlide(enable)
  local self = Customization_BodyBoneInfo
  self:EnableBodySlide(enable)
end
function PaGlobalFunc_Customization_BodyBone_AdjustBodyBoneScale(scaleX, scaleY, scaleZ)
  local self = Customization_BodyBoneInfo
  self:SetValueSlider(self._ui._slider_ScaleX, scaleX, self._selectScaleMin.x, self._selectScaleMax.x)
  self:SetValueSlider(self._ui._slider_ScaleY, scaleY, self._selectScaleMin.y, self._selectScaleMax.y)
  self:SetValueSlider(self._ui._slider_ScaleZ, scaleZ, self._selectScaleMin.z, self._selectScaleMax.z)
  self._currentScale.x = scaleX
  self._currentScale.y = scaleY
  self._currentScale.z = scaleZ
end
function PaGlobalFunc_Customization_BodyBone_PickingBodyBone(customizationData)
  local self = Customization_BodyBoneInfo
  self._currentData = customizationData
  self._selectScaleMin = customizationData:getSelectedBoneScaleMin()
  self._lastScaleMin = customizationData:getSelectedBoneScaleMin()
  self._selectScaleMax = customizationData:getSelectedBoneScaleMax()
  self._lastScaleMax = customizationData:getSelectedBoneScaleMax()
  self._currentScale = customizationData:getSelectedBoneScaleValue()
  self._lastScale = customizationData:getSelectedBoneScaleValue()
  self:SetValueSlider(self._ui._slider_ScaleX, self._currentScale.x, self._selectScaleMin.x, self._selectScaleMax.x)
  self:SetValueSlider(self._ui._slider_ScaleY, self._currentScale.y, self._selectScaleMin.y, self._selectScaleMax.y)
  self:SetValueSlider(self._ui._slider_ScaleZ, self._currentScale.z, self._selectScaleMin.z, self._selectScaleMax.z)
  self:EnableBodySlide(true)
  self:SetProgressRateValue_Height()
  self:SetProgressRateValue_Weight()
  PaGlobalFunc_Customization_BodyBone_Update()
end
function PaGlobalFunc_Customization_BodyBone_ShowBodyBoneEditor()
  local self = Customization_BodyBoneInfo
  self._ui._slider_ScaleX:SetControlPos(50)
  self._ui._slider_ScaleY:SetControlPos(50)
  self._ui._slider_ScaleZ:SetControlPos(50)
  self:SetProgressRateValue_Height()
  self:SetProgressRateValue_Weight()
  setSymmetryBoneTransform(true)
  PaGlobalFunc_Customization_BodyBone_CursorSelect(3)
  self:SetHeightProgress()
  self:SetWeightProgress()
end
function Customization_BodyBoneInfo:SetProgressRateValue_Height()
  self._ui._slider_Height:SetControlPos(math.floor(getCustomizationBodyHeight() + 0.5))
  self._ui._staticText_HeightSliderValue:SetText(math.floor(getCustomizationBodyHeight() + 0.5))
end
function Customization_BodyBoneInfo:SetProgressRateValue_Weight()
  self._ui._slider_Weight:SetControlPos(math.floor(getCustomizationBodyWeight() + 0.5))
  self._ui._staticText_WeightSliderValue:SetText(math.floor(getCustomizationBodyWeight() + 0.5))
end
function Customization_BodyBoneInfo:SetHeightProgress()
  local progress = UI.getChildControl(self._ui._slider_Height, "Progress2_1")
  local button = UI.getChildControl(self._ui._slider_Height, "Slider_DisplayButton")
  local ratio = self._ui._slider_Height:GetControlPos()
  button:SetPosX(self._ui._slider_Height:GetControlButton():GetPosX())
  local offset = math.cos(ratio * math.pi) * 2
  progress:SetProgressRate(ratio * 100 + offset)
end
function Customization_BodyBoneInfo:SetWeightProgress()
  local progress = UI.getChildControl(self._ui._slider_Weight, "Progress2_1")
  local button = UI.getChildControl(self._ui._slider_Weight, "Slider_DisplayButton")
  local ratio = self._ui._slider_Weight:GetControlPos()
  button:SetPosX(self._ui._slider_Weight:GetControlButton():GetPosX())
  local offset = math.cos(ratio * math.pi) * 2
  progress:SetProgressRate(ratio * 100 + offset)
end
function PaGlobalFunc_Customization_BodyBone_UpdateBodyBoneScale()
  local self = Customization_BodyBoneInfo
  local x = self:CalculateSliderValue(self._ui._slider_ScaleX, self._selectScaleMin.x, self._selectScaleMax.x)
  local y = self:CalculateSliderValue(self._ui._slider_ScaleY, self._selectScaleMin.y, self._selectScaleMax.y)
  local z = self:CalculateSliderValue(self._ui._slider_ScaleZ, self._selectScaleMin.z, self._selectScaleMax.z)
  self._currentScale.x = x
  self._currentScale.y = y
  self._currentScale.z = z
  applyScaleValue(x, y, z)
end
function PaGlobalFunc_Customization_BodyBone_SliderOn()
  local self = Customization_BodyBoneInfo
  PaGlobalFunc_Customization_SetKeyGuide(5)
end
function PaGlobalFunc_Customization_BodyBone_SliderOut()
  local self = Customization_BodyBoneInfo
  if false == self._isBoneControl and true == PaGlobalFunc_Customization_BodyBone_GetShow() then
    PaGlobalFunc_Customization_SetKeyGuide(3)
  end
end
function PaGlobalFunc_Customization_BodyBone_UpdateBodyHeight()
  local self = Customization_BodyBoneInfo
  if true == self._ui._slider_Height:IsEnable() then
    self:SetHeightProgress()
    self._ui._staticText_HeightSliderValue:SetText(math.floor(self._ui._slider_Height:GetControlPos() * 100 + 0.5))
    applyBodyHeight(self._currentClassType, math.floor(self._ui._slider_Height:GetControlPos() * 100 + 0.5))
    if true == self._ui._slider_ScaleY:IsEnable() then
      local postScale = ToClient_getPickingCustomizedBoneScale()
      PaGlobalFunc_Customization_BodyBone_AdjustBodyBoneScale(postScale.x, postScale.y, postScale.z)
    end
  end
end
function PaGlobalFunc_Customization_BodyBone_UpdateBodyWeight()
  local self = Customization_BodyBoneInfo
  if true == self._ui._slider_Weight:IsEnable() then
    self:SetWeightProgress()
    self._ui._staticText_WeightSliderValue:SetText(math.floor(self._ui._slider_Weight:GetControlPos() * 100 + 0.5))
    applyBodyWeight(self._currentClassType, math.floor(self._ui._slider_Weight:GetControlPos() * 100 + 0.5))
    if true == self._ui._slider_ScaleY:IsEnable() then
      local postScale = ToClient_getPickingCustomizedBoneScale()
      PaGlobalFunc_Customization_BodyBone_AdjustBodyBoneScale(postScale.x, postScale.y, postScale.z)
    end
  end
end
function PaGlobalFunc_Customization_BodyBone_ToggleShowBodyBoneControlPart()
  local self = Customization_BodyBoneInfo
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  showBoneControlPart(self._ui._checkBox_ShowPart:IsCheck())
end
function PaGlobalFunc_Customization_BodyBone_CursorSelect(luaControlModeIndex)
  local self = Customization_BodyBoneInfo
  selectSculptingBoneTransformType(luaControlModeIndex - 1)
  self._controlMode = luaControlModeIndex
end
function PaGlobalFunc_Customization_BodyBone_SetBoneControl(isSet)
  local self = Customization_BodyBoneInfo
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  if false == isSet then
    self._isBoneControl = false
    PaGlobalFunc_Customization_SetKeyGuide(3)
    Panel_Customizing_BodyShape:ignorePadSnapUpdate(false)
    ToClient_StartOrEndShapeBoneControlStart(false)
    PaGlobalFunc_Customization_BodyBone_Update()
    PaGlobalFunc_Customization_BodyBone_SetShow(true)
  else
    self._isBoneControl = true
    PaGlobalFunc_Customization_SetKeyGuide(4)
    Panel_Customizing_BodyShape:ignorePadSnapUpdate(true)
    ToClient_StartOrEndShapeBoneControlStart(true)
    PaGlobalFunc_CustomizingKeyGuide_Open(PaGlobalFunc_Customization_BodyBone_SetBoneControl, 2)
    PaGlobalFunc_Customization_BodyBone_SetShow(false)
  end
end
function PaGlobalFunc_Customization_BodyBone_BoneInfoPostFunction()
  local self = Customization_BodyBoneInfo
  if false == PaGlobalFunc_Customization_BodyBone_GetShow() then
    return
  end
  self:SetProgressRateValue_Height()
  self:SetProgressRateValue_Weight()
  self:SetHeightProgress()
  self:SetWeightProgress()
  if nil == self._lastScale then
    return
  end
  self:SetValueSlider(self._ui._slider_ScaleX, self._lastScale.x, self._lastScaleMin.x, self._lastScaleMax.x)
  self:SetValueSlider(self._ui._slider_ScaleY, self._lastScale.y, self._lastScaleMin.y, self._lastScaleMax.y)
  self:SetValueSlider(self._ui._slider_ScaleZ, self._lastScale.z, self._lastScaleMin.z, self._lastScaleMax.z)
end
function PaGlobalFunc_Customization_BodyBone_ClearCustomizedBoneInfo()
  local self = Customization_BodyBoneInfo
  clearCustomizedBoneInfo()
  if nil == self._lastScale then
    return
  end
  self:SetValueSlider(self._ui._slider_ScaleX, self._lastScale.x, self._lastScaleMin.x, self._lastScaleMax.x)
  self:SetValueSlider(self._ui._slider_ScaleY, self._lastScale.y, self._lastScaleMin.y, self._lastScaleMax.y)
  self:SetValueSlider(self._ui._slider_ScaleZ, self._lastScale.z, self._lastScaleMin.z, self._lastScaleMax.z)
  _AudioPostEvent_SystemUiForXBOX(50, 1)
end
function PaGlobalFunc_Customization_BodyBone_ClearGroupCustomizedBonInfoLua()
  local self = Customization_BodyBoneInfo
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  PaGlobalFunc_CustomIzationCommon_ClearGroupCustomizedBonInfoLua()
end
function Customization_BodyBoneInfo:InitControl()
  self._ui._checkBox_ShowPart = UI.getChildControl(self._ui._static_ButtonBg, "CheckButton_ShowPart")
  self._ui._checkBox_ShowPart:SetCheck(true)
  self._ui._button_ResetPart = UI.getChildControl(self._ui._static_ButtonBg, "Button_ResetPart")
  self._ui._button_ResetAll = UI.getChildControl(self._ui._static_ButtonBg, "Button_ResetAll")
  self._ui._static_HeightSliderBg = UI.getChildControl(self._ui._static_BodySliderGroup, "Static_HeightBg")
  self._ui._static_WeightSliderBg = UI.getChildControl(self._ui._static_BodySliderGroup, "Static_WeightBg")
  self._ui._staticText_HeightSliderTitle = UI.getChildControl(self._ui._static_HeightSliderBg, "StaticText_Title")
  self._ui._staticText_WeightSliderTitle = UI.getChildControl(self._ui._static_WeightSliderBg, "StaticText_Title")
  self._ui._staticText_HeightSliderTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_HEIGHT"))
  self._ui._staticText_WeightSliderTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_WEIGHT"))
  self._ui._staticText_HeightSliderValue = UI.getChildControl(self._ui._static_HeightSliderBg, "StaticText_HeigtValue")
  self._ui._staticText_WeightSliderValue = UI.getChildControl(self._ui._static_WeightSliderBg, "StaticText_WeightValue")
  self._ui._slider_Height = UI.getChildControl(self._ui._static_HeightSliderBg, "Slider_Height")
  self._ui._slider_Weight = UI.getChildControl(self._ui._static_WeightSliderBg, "Slider_Weight")
  self._ui._sliderButton_Height = UI.getChildControl(self._ui._slider_Height, "Slider_Button")
  self._ui._sliderButton_Weight = UI.getChildControl(self._ui._slider_Weight, "Slider_Button")
  self._ui._static_ScaleSliderXBg = UI.getChildControl(self._ui._static_ScaleSliderGroup, "Static_XBg")
  self._ui._static_ScaleSliderYBg = UI.getChildControl(self._ui._static_ScaleSliderGroup, "Static_YBg")
  self._ui._static_ScaleSliderZBg = UI.getChildControl(self._ui._static_ScaleSliderGroup, "Static_ZBg")
  self._ui._staticText_ScaleSliderX_Title = UI.getChildControl(self._ui._static_ScaleSliderXBg, "StaticText_Title")
  self._ui._staticText_ScaleSliderY_Title = UI.getChildControl(self._ui._static_ScaleSliderYBg, "StaticText_Title")
  self._ui._staticText_ScaleSliderZ_Title = UI.getChildControl(self._ui._static_ScaleSliderZBg, "StaticText_Title")
  self._ui._slider_ScaleX = UI.getChildControl(self._ui._static_ScaleSliderXBg, "Slider_X")
  self._ui._slider_ScaleY = UI.getChildControl(self._ui._static_ScaleSliderYBg, "Slider_Y")
  self._ui._slider_ScaleZ = UI.getChildControl(self._ui._static_ScaleSliderZBg, "Slider_Z")
  self._ui._sliderButton_ScaleX = UI.getChildControl(self._ui._slider_ScaleX, "Slider_Button")
  self._ui._sliderButton_ScaleY = UI.getChildControl(self._ui._slider_ScaleY, "Slider_Button")
  self._ui._sliderButton_ScaleZ = UI.getChildControl(self._ui._slider_ScaleZ, "Slider_Button")
end
function Customization_BodyBoneInfo:InitEvent()
  self._ui._checkBox_ShowPart:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_BodyBone_ToggleShowBodyBoneControlPart()")
  self._ui._button_ResetPart:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_BodyBone_ClearCustomizedBoneInfo()")
  self._ui._button_ResetAll:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_BodyBone_ClearGroupCustomizedBonInfoLua()")
  self._ui._slider_Height:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_BodyBone_SliderOn( )")
  self._ui._slider_Height:addInputEvent("Mouse_Out", "PaGlobalFunc_Customization_BodyBone_SliderOut( )")
  self._ui._slider_Weight:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_BodyBone_SliderOn( )")
  self._ui._slider_Weight:addInputEvent("Mouse_Out", "PaGlobalFunc_Customization_BodyBone_SliderOut( )")
  self._ui._slider_Height:addInputEvent("Mouse_LPress", "PaGlobalFunc_Customization_BodyBone_UpdateBodyHeight()")
  self._ui._slider_Weight:addInputEvent("Mouse_LPress", "PaGlobalFunc_Customization_BodyBone_UpdateBodyWeight()")
  self._ui._sliderButton_Height:SetIgnore(true)
  self._ui._sliderButton_Weight:SetIgnore(true)
  self._ui._slider_ScaleX:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_BodyBone_SliderOn( )")
  self._ui._slider_ScaleX:addInputEvent("Mouse_Out", "PaGlobalFunc_Customization_BodyBone_SliderOut( )")
  self._ui._slider_ScaleY:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_BodyBone_SliderOn( )")
  self._ui._slider_ScaleY:addInputEvent("Mouse_Out", "PaGlobalFunc_Customization_BodyBone_SliderOut( )")
  self._ui._slider_ScaleZ:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_BodyBone_SliderOn( )")
  self._ui._slider_ScaleZ:addInputEvent("Mouse_Out", "PaGlobalFunc_Customization_BodyBone_SliderOut( )")
  self._ui._slider_ScaleX:addInputEvent("Mouse_LPress", "PaGlobalFunc_Customization_BodyBone_UpdateBodyBoneScale()")
  self._ui._slider_ScaleY:addInputEvent("Mouse_LPress", "PaGlobalFunc_Customization_BodyBone_UpdateBodyBoneScale()")
  self._ui._slider_ScaleZ:addInputEvent("Mouse_LPress", "PaGlobalFunc_Customization_BodyBone_UpdateBodyBoneScale()")
  self._ui._sliderButton_ScaleX:SetIgnore(true)
  self._ui._sliderButton_ScaleY:SetIgnore(true)
  self._ui._sliderButton_ScaleZ:SetIgnore(true)
  Panel_Customizing_BodyShape:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_Customization_BodyBone_SetBoneControl(true)")
end
function Customization_BodyBoneInfo:InitRegister()
  registerEvent("EventShowBodyBoneEditor", "PaGlobalFunc_Customization_BodyBone_ShowBodyBoneEditor")
  registerEvent("EventPickingBodyBone", "PaGlobalFunc_Customization_BodyBone_PickingBodyBone")
  registerEvent("EventAdjustBodyBoneScale", "PaGlobalFunc_Customization_BodyBone_AdjustBodyBoneScale")
  registerEvent("EventOpenBodyShapeUi", "PaGlobalFunc_Customization_BodyBone_OpenBodyShapeUi")
  registerEvent("EventCloseBodyShapeUi", "PaGlobalFunc_Customization_BodyBone_CloseBodyShapeUi")
  registerEvent("EventEnableBodySlide", "PaGlobalFunc_Customization_BodyBone_EnableBodySlide")
end
function Customization_BodyBoneInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
  PaGlobalFunc_CustomIzationCommon_PushClearGroupCustomizedBonInfoPostFunction(PaGlobalFunc_Customization_BodyBone_BoneInfoPostFunction)
end
function PaGlobalFunc_FromClient_Customization_BodyBone_luaLoadComplete()
  local self = Customization_BodyBoneInfo
  self:Initialize()
end
function PaGlobalFunc_Customization_BodyBone_Close()
  local self = Customization_BodyBoneInfo
  if false == PaGlobalFunc_Customization_BodyBone_GetShow() then
    return false
  end
  if true == self._isBoneControl then
    PaGlobalFunc_Customization_BodyBone_SetBoneControl(false)
    return false
  end
  self._currentData = nil
  endPickingMode()
  PaGlobalFunc_Customization_BodyPose_ToggleShowPosePreCheck()
  PaGlobalFunc_Customization_SetKeyGuide(0)
  PaGlobalFunc_Customization_SetCloseFunc(nil)
  PaGlobalFunc_Customization_SetBackEvent()
  PaGlobalFunc_Customization_BodyBone_SetShow(false)
  return true
end
function PaGlobalFunc_Customization_BodyBone_Open()
  if true == PaGlobalFunc_Customization_BodyBone_GetShow() then
    return
  end
  PaGlobalFunc_Customization_BodyBone_SetShow(true)
  PaGlobalFunc_Customization_KeyGuideSetShow(true)
  PaGlobalFunc_Customization_SetKeyGuide(3)
  PaGlobalFunc_Customization_BodyBone_ToggleShowBodyBoneControlPart()
  PaGlobalFunc_Customization_SetCloseFunc(PaGlobalFunc_Customization_BodyBone_Close)
  PaGlobalFunc_Customization_SetBackEvent("PaGlobalFunc_Customization_BodyBone_Close()")
end
function PaGlobalFunc_Customization_BodyBone_SetShow(isShow)
  Panel_Customizing_BodyShape:SetShow(isShow)
end
function PaGlobalFunc_Customization_BodyBone_GetShow()
  return Panel_Customizing_BodyShape:GetShow()
end
function PaGlobalFunc_Customization_BodyBone_Update()
  local self = Customization_BodyBoneInfo
  if nil == self._currentData then
    return
  end
  self:CalculateSliderValue(self._ui._slider_ScaleX, self._selectScaleMin.x, self._selectScaleMax.x)
  self:CalculateSliderValue(self._ui._slider_ScaleY, self._selectScaleMin.y, self._selectScaleMax.y)
  self:CalculateSliderValue(self._ui._slider_ScaleZ, self._selectScaleMin.z, self._selectScaleMax.z)
end
PaGlobalFunc_FromClient_Customization_BodyBone_luaLoadComplete()

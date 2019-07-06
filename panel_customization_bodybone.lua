local StaticText_DefaultControl = UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_DefaultControl")
local RadioButton_Bone_Scale = UI.getChildControl(Panel_CustomizationTransformBody, "RadioButton_Bone_Scale")
local StaticText_ScaleX = UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_ScaleX")
local StaticText_ScaleY = UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_ScaleY")
local StaticText_ScaleZ = UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_ScaleZ")
local Slider_ScaleX = UI.getChildControl(Panel_CustomizationTransformBody, "Slider_ScaleX_Controller")
local Slider_ScaleY = UI.getChildControl(Panel_CustomizationTransformBody, "Slider_ScaleY_Controller")
local Slider_ScaleZ = UI.getChildControl(Panel_CustomizationTransformBody, "Slider_ScaleZ_Controller")
local Button_Slider_ScaleX = UI.getChildControl(Slider_ScaleX, "Slider_GammaController_Button")
local Button_Slider_ScaleY = UI.getChildControl(Slider_ScaleY, "Slider_GammaController_Button")
local Button_Slider_ScaleZ = UI.getChildControl(Slider_ScaleZ, "Slider_GammaController_Button")
local StaticText_ControlPart = UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_ControlPart")
local CheckButton_ControlPart = UI.getChildControl(Panel_CustomizationTransformBody, "CheckButton_ControlPart")
local Button_All_Reset = UI.getChildControl(Panel_CustomizationTransformBody, "Button_All_Reset")
local Button_Part_Reset = UI.getChildControl(Panel_CustomizationTransformBody, "Button_Part_Reset")
local StaticText_CurrValue_ScaleX = UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_Slider_ScaleX_Left")
local StaticText_CurrValue_ScaleY = UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_Slider_ScaleY_Left")
local StaticText_CurrValue_ScaleZ = UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_Slider_ScaleZ_Left")
local Slider_Height = UI.getChildControl(Panel_CustomizationTransformBody, "Slider_Height_Controller")
local Button_Slider_Height = UI.getChildControl(Slider_Height, "Slider_GammaController_Button")
local Slider_Weight = UI.getChildControl(Panel_CustomizationTransformBody, "Slider_Weight_Controller")
local Button_Slider_Weight = UI.getChildControl(Slider_Weight, "Slider_GammaController_Button")
local StaticText_Weight = UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_Weight")
local StaticText_Height = UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_Height")
StaticText_DefaultControl:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONTRANSFORM_STATICTEXT_DEFAULTCONTROL"))
StaticText_ControlPart:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_CONTROLPART"))
Button_All_Reset:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_ALL_RESET"))
Button_Part_Reset:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_PART_RESET"))
CheckButton_ControlPart:SetCheck(true)
StaticText_Weight:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_WEIGHT"))
StaticText_Height:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_HEIGHT"))
Slider_ScaleX:addInputEvent("Mouse_LPress", "UpdateBodyBoneScale()")
Slider_ScaleY:addInputEvent("Mouse_LPress", "UpdateBodyBoneScale()")
Slider_ScaleZ:addInputEvent("Mouse_LPress", "UpdateBodyBoneScale()")
Button_Slider_ScaleX:addInputEvent("Mouse_LPress", "UpdateBodyBoneScale()")
Button_Slider_ScaleY:addInputEvent("Mouse_LPress", "UpdateBodyBoneScale()")
Button_Slider_ScaleZ:addInputEvent("Mouse_LPress", "UpdateBodyBoneScale()")
Slider_ScaleX:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Slider_ScaleY:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Slider_ScaleZ:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_Slider_ScaleX:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_Slider_ScaleY:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_Slider_ScaleZ:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Slider_Height:addInputEvent("Mouse_LPress", "UpdateBodyHeight()")
Button_Slider_Height:addInputEvent("Mouse_LPress", "UpdateBodyHeight()")
Slider_Weight:addInputEvent("Mouse_LPress", "UpdateBodyWeight()")
Button_Slider_Weight:addInputEvent("Mouse_LPress", "UpdateBodyWeight()")
Slider_Height:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_Slider_Height:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Slider_Weight:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_Slider_Weight:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_All_Reset:addInputEvent("Mouse_LUp", "clearGroupCustomizedBonInfoLua()")
Button_Part_Reset:addInputEvent("Mouse_LUp", "clearCustomizedBoneInfo()")
CheckButton_ControlPart:addInputEvent("Mouse_LUp", "ToggleShowBodyBoneControlPart()")
if false == _ContentsGroup_RenewUI_Customization then
  registerEvent("EventShowBodyBoneEditor", "ShowBodyBoneEditor")
  registerEvent("EventPickingBodyBone", "PickingBodyBone")
  registerEvent("EventAdjustBodyBoneScale", "AdjustBodyBoneScale")
  registerEvent("EventOpenBodyShapeUi", "OpenBodyShapeUi")
  registerEvent("EventCloseBodyShapeUi", "CloseBodyShapeUi")
  registerEvent("EventEnableBodySlide", "EnableBodySlide")
end
local scaleMin, scaleMax, currentScale, selectedClassType
local SculptingUIRect = {
  left,
  top,
  right,
  bottom
}
local selectedCharacterClass = -1
local sliderTextGap = 3
local contentsGapHeight = 10
local selectedClassIndex
local currentclassType = -1
local currentuiId = -1
local function InitBodyBoneControls()
  if currentScale ~= nil then
    setValueSlider(Slider_ScaleX, currentScale.x, scaleMin.x, scaleMax.x)
    setValueSlider(Slider_ScaleY, currentScale.y, scaleMin.y, scaleMax.y)
    setValueSlider(Slider_ScaleZ, currentScale.z, scaleMin.z, scaleMax.z)
  end
end
local floatString = function(floatValue)
  return string.format("%.2f", floatValue)
end
local function bonInfoPostFunction()
  Slider_Height:SetControlPos(getCustomizationBodyHeight())
  Slider_Weight:SetControlPos(getCustomizationBodyWeight())
end
pushClearGroupCustomizedBonInfoPostFunction(bonInfoPostFunction)
function UpdateBodyHeight()
  applyBodyHeight(selectedClassType, Slider_Height:GetControlPos() * 100)
  setGlobalCheck(true)
end
function UpdateBodyWeight()
  applyBodyWeight(selectedClassType, Slider_Weight:GetControlPos() * 100)
  setGlobalCheck(true)
end
function historyInit()
  bonInfoPostFunction()
  selectedClassType = getSelfPlayer():getClassType()
end
function UpdateBodyBoneScale()
  local x = calculateSliderValue(Slider_ScaleX, scaleMin.x, scaleMax.x)
  local y = calculateSliderValue(Slider_ScaleY, scaleMin.y, scaleMax.y)
  local z = calculateSliderValue(Slider_ScaleZ, scaleMin.z, scaleMax.z)
  currentScale.x = x
  currentScale.y = y
  currentScale.z = z
  applyScaleValue(x, y, z)
  StaticText_CurrValue_ScaleX:SetText(math.floor(x * 100) / 100)
  StaticText_CurrValue_ScaleY:SetText(math.floor(y * 100) / 100)
  StaticText_CurrValue_ScaleZ:SetText(math.floor(z * 100) / 100)
  StaticText_CurrValue_ScaleX:SetShow(false)
  StaticText_CurrValue_ScaleY:SetShow(false)
  StaticText_CurrValue_ScaleZ:SetShow(false)
end
function OpenBodyShapeUi(classType, uiId)
  globalcurrentclassType = classType
  globalcurrentuiId = uiId
  currentclassType = classType
  currentuiId = uiId
  selectedClassType = classType
  startBodyPickingMode()
  EnableBodySlide(false)
  ShowBodyBoneEditor()
  if CheckButton_ControlPart:IsCheck() then
    showBoneControlPart(true)
  else
    showBoneControlPart(false)
  end
end
function CloseBodyShapeUi()
  endPickingMode()
  ToggleShowPosePreCheck()
  globalcurrentclassType = -2
  globalcurrentuiId = -2
  globalisCustomizationPicking = false
end
function ShowBodyBoneEditor()
  Slider_ScaleX:SetControlPos(50)
  Slider_ScaleY:SetControlPos(50)
  Slider_ScaleZ:SetControlPos(50)
  Slider_Height:SetControlPos(getCustomizationBodyHeight())
  Slider_Weight:SetControlPos(getCustomizationBodyWeight())
  StaticText_CurrValue_ScaleX:SetText(0)
  StaticText_CurrValue_ScaleY:SetText(0)
  StaticText_CurrValue_ScaleZ:SetText(0)
  setSymmetryBoneTransform(true)
  RadioButton_Bone_Scale:SetCheck(true)
  CursorSelect(3)
  updateGroupFrameControls(Panel_CustomizationTransformBody:GetSizeY(), Panel_CustomizationTransformBody)
  StaticText_CurrValue_ScaleX:SetShow(false)
  StaticText_CurrValue_ScaleY:SetShow(false)
  StaticText_CurrValue_ScaleZ:SetShow(false)
end
function ToggleShowBodyBoneControlPart()
  showBoneControlPart(CheckButton_ControlPart:IsCheck())
end
function PickingBodyBone(customizationData)
  scaleMin = customizationData:getSelectedBoneScaleMin()
  scaleMax = customizationData:getSelectedBoneScaleMax()
  currentScale = customizationData:getSelectedBoneScaleValue()
  EnableBodySlide(true)
  InitBodyBoneControls()
end
function EnableBodySlide(enable)
  globalisCustomizationPicking = enable
  local color = Defines.Color.C_FF444444
  if enable then
    color = Defines.Color.C_FFFFFFFF
  end
  StaticText_ScaleX:SetFontColor(color)
  StaticText_ScaleY:SetFontColor(color)
  StaticText_ScaleZ:SetFontColor(color)
  Slider_ScaleX:SetMonoTone(not enable)
  Slider_ScaleY:SetMonoTone(not enable)
  Slider_ScaleZ:SetMonoTone(not enable)
  Slider_ScaleX:SetEnable(enable)
  Slider_ScaleY:SetEnable(enable)
  Slider_ScaleZ:SetEnable(enable)
  color = Defines.Color.C_FFFFFFFF
  if enable then
    color = Defines.Color.C_FF444444
  end
  Slider_Weight:SetMonoTone(enable)
  Slider_Weight:SetEnable(not enable)
  StaticText_Weight:SetFontColor(color)
  Slider_Height:SetMonoTone(enable)
  Slider_Height:SetEnable(not enable)
  StaticText_Height:SetFontColor(color)
end
function AdjustBodyBoneScale(scaleX, scaleY, scaleZ)
  local self = sculptingBoneSettingUI
  self.EditText[self.PARAM_SCALEVALX]:SetEditText(floatString(scaleX))
  self.EditText[self.PARAM_SCALEVALY]:SetEditText(floatString(scaleY))
  self.EditText[self.PARAM_SCALEVALZ]:SetEditText(floatString(scaleZ))
  setValueSlider(Slider_ScaleX, scaleX, scaleMin.x, scaleMax.x)
  setValueSlider(Slider_ScaleY, scaleY, scaleMin.y, scaleMax.y)
  setValueSlider(Slider_ScaleZ, scaleZ, scaleMin.z, scaleMax.z)
  currentScale.x = scaleX
  currentScale.y = scaleY
  currentScale.z = scaleZ
end
function BodyBoneHistoryApplyUpdate()
  if globalcurrentclassType ~= currentclassType or globalcurrentuiId ~= currentuiId then
    return
  end
  OpenBodyShapeUi(currentclassType, currentuiId)
  PickingBodyBone(ToClient_getCharacterCustomizationUiWrapper())
end

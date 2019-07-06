Panel_Customizing_BodyPose:ignorePadSnapMoveToOtherPanel()
local Customization_BodyPoseInfo = {
  _ui = {
    _static_ControlGroup = UI.getChildControl(Panel_Customizing_BodyPose, "Static_ControlGroup"),
    _static_RotationSliderGroup = UI.getChildControl(Panel_Customizing_BodyPose, "Static_SliderGroup"),
    _static_PoseGroup = UI.getChildControl(Panel_Customizing_BodyPose, "Static_PoseGroup"),
    _static_SaveGroup = UI.getChildControl(Panel_Customizing_BodyPose, "Static_SaveGroup"),
    _static_KeyGuideBg = UI.getChildControl(Panel_Customizing_BodyPose, "Static_KeyGuideBg"),
    _button_Rotation = UI.getChildControl(Panel_Customizing_BodyPose, "Button_Rotation")
  },
  _currentClassType,
  _currentUiId,
  _selectedRotMin,
  _selectedRotMax,
  _currentRotation,
  _lastRotMin,
  _lastRotMax,
  _lastRot,
  _selectedImageIndex = -1,
  _contentImage = {},
  _currentData = nil,
  _isBoneControl = false
}
function PaGlobalFunc_Customization_BodyPose_OpenPoseEditUi()
  local self = Customization_BodyPoseInfo
  PaGlobalFunc_Customization_BodyPose_EnablePoseEditSlide(false)
  startPosePickingMode()
  self:InitializePoseEditor()
  self._selectedImageIndex = -1
  self._ui._slider_RotationX:SetControlPos(50)
  self._ui._slider_RotationY:SetControlPos(50)
  self._ui._slider_RotationZ:SetControlPos(50)
  self:UpdateSavedPose()
  PaGlobalFunc_Customization_BodyPose_ToggleShowPoseBoneControlPart()
  PaGlobalFunc_Customization_BodyPose_PoseEditSymmetryChecked()
  setPresetCamera(4)
  PaGlobalFunc_Customization_BodyPose_Open()
end
function PaGlobalFunc_Customization_BodyPose_ClosePoseEditUi()
  clearAllPoseBone()
  endPickingMode()
  PaGlobalFunc_Customization_BodyPose_Close()
end
function PaGlobalFunc_Customization_BodyPose_SliderOn()
  local self = Customization_BodyPoseInfo
  PaGlobalFunc_Customization_SetKeyGuide(5)
end
function PaGlobalFunc_Customization_BodyPose_SliderOut()
  local self = Customization_BodyPoseInfo
  if false == self._isBoneControl and true == PaGlobalFunc_Customization_BodyPose_GetShow() then
    PaGlobalFunc_Customization_SetKeyGuide(3)
  end
end
function PaGlobalFunc_Customization_BodyPose_PoseEditSliderUpdate()
  local self = Customization_BodyPoseInfo
  local x = self:CalculateSliderRotation(self._ui._slider_RotationX, self._selectedRotMin.x, self._selectedRotMax.x)
  local y = self:CalculateSliderRotation(self._ui._slider_RotationY, self._selectedRotMin.y, self._selectedRotMax.y)
  local z = self:CalculateSliderRotation(self._ui._slider_RotationZ, self._selectedRotMin.z, self._selectedRotMax.z)
  self._currentRotation.x = x
  self._currentRotation.y = y
  self._currentRotation.z = z
  applyPoseRotation(x, y, z)
end
function PaGlobalFunc_Customization_BodyPose_ShowPoseEditor(show)
  local self = Customization_BodyPoseInfo
  if true == show then
    PaGlobalFunc_Customization_BodyPose_EnablePoseEditSlide(false)
    self._ui._slider_RotationX:SetControlPos(50)
    self._ui._slider_RotationY:SetControlPos(50)
    self._ui._slider_RotationZ:SetControlPos(50)
    self:UpdateSavedPose()
    PaGlobalFunc_Customization_BodyPose_ToggleShowPoseBoneControlPart()
  end
end
function PaGlobalFunc_Customization_BodyPose_AdjustPoseBoneRotation(rotationX, rotationY, rotationZ)
  local self = Customization_BodyPoseInfo
  self:SetRotationSlider(self._ui._slider_RotationX, rotationX, self._selectedRotMin.x, self._selectedRotMax.x)
  self:SetRotationSlider(self._ui._slider_RotationY, rotationY, self._selectedRotMin.y, self._selectedRotMax.y)
  self:SetRotationSlider(self._ui._slider_RotationZ, rotationZ, self._selectedRotMin.z, self._selectedRotMax.z)
  self._currentRotation.x = rotationX
  self._currentRotation.y = rotationY
  self._currentRotation.z = rotationZ
end
function PaGlobalFunc_Customization_BodyPose_SelectPoseEditorControl(customizationData)
  local self = Customization_BodyPoseInfo
  self._currentData = customizationData
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  PaGlobalFunc_Customization_BodyPose_EnablePoseEditSlide(true)
  self._selectedRotMin = customizationData:getSelectedBoneRotationMin()
  self._lastRotMin = customizationData:getSelectedBoneRotationMin()
  self._selectedRotMax = customizationData:getSelectedBoneRotationMax()
  self._lastRotMax = customizationData:getSelectedBoneRotationMax()
  self._currentRotation = customizationData:getSelectedBoneRotationValue()
  self._lastRot = customizationData:getSelectedBoneRotationValue()
  self:SetRotationSlider(self._ui._slider_RotationX, self._currentRotation.x, self._selectedRotMin.x, self._selectedRotMax.x)
  self:SetRotationSlider(self._ui._slider_RotationY, self._currentRotation.y, self._selectedRotMin.y, self._selectedRotMax.y)
  self:SetRotationSlider(self._ui._slider_RotationZ, self._currentRotation.z, self._selectedRotMin.z, self._selectedRotMax.z)
  PaGlobalFunc_Customization_BodyPose_Update()
end
function PaGlobalFunc_Customization_BodyPose_ToggleShowPosePreCheck()
  local self = Customization_BodyPoseInfo
  if self._ui._checkbox_ShowPart:IsCheck() then
    showBoneControlPart(true)
  else
    showBoneControlPart(false)
  end
end
function PaGlobalFunc_Customization_BodyPose_SavePose()
  local self = Customization_BodyPoseInfo
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  savePoseInfo()
  self:UpdateSavedPose()
end
function PaGlobalFunc_Customization_BodyPose_DeletePose()
  local self = Customization_BodyPoseInfo
  if -1 ~= self._selectedImageIndex then
    deletePoseInfo(self._selectedImageIndex)
    self:UpdateSavedPose()
    self._ui._poseSelect:SetShow(false)
    self._selectedImageIndex = -1
    PaGlobalFunc_Customization_BodyPose_ClearAllPoseBone()
    _AudioPostEvent_SystemUiForXBOX(50, 1)
  end
end
function PaGlobalFunc_Customization_BodyPose_SelectPose(imageIndex)
  local self = Customization_BodyPoseInfo
  self._selectedImageIndex = imageIndex
  if -1 == self._selectedImageIndex then
    self._ui._poseSelect:SetShow(false)
    return
  end
  self._ui._poseSelect:SetPosX(self._contentImage[imageIndex]:GetPosX() - 1)
  self._ui._poseSelect:SetPosY(self._contentImage[imageIndex]:GetPosY() - 1)
  self._ui._poseSelect:SetShow(true)
  applyPose(imageIndex)
end
function PaGlobalFunc_Customization_BodyPose_PoseEditSymmetryChecked()
  local self = Customization_BodyPoseInfo
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  setSymmetryBoneTransform(self._ui._checkbox_Symmetry:IsCheck())
end
function PaGlobalFunc_Customization_BodyPose_ToggleShowPoseBoneControlPart()
  local self = Customization_BodyPoseInfo
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  showBoneControlPart(self._ui._checkbox_ShowPart:IsCheck())
end
function PaGlobalFunc_Customization_BodyPose_EnablePoseEditSlide(enable)
  local self = Customization_BodyPoseInfo
  self._ui._slider_RotationX:SetMonoTone(not enable)
  self._ui._slider_RotationY:SetMonoTone(not enable)
  self._ui._slider_RotationZ:SetMonoTone(not enable)
  self._ui._slider_RotationX:SetIgnore(not enable)
  self._ui._slider_RotationY:SetIgnore(not enable)
  self._ui._slider_RotationZ:SetIgnore(not enable)
  self._ui._slider_RotationX:SetEnable(enable)
  self._ui._slider_RotationY:SetEnable(enable)
  self._ui._slider_RotationZ:SetEnable(enable)
end
function Customization_BodyPoseInfo:UpdateSavedPose()
  for imageIndex = 0, 9 do
    local bPoseSlotEmpty = getPoseDataEmpty(imageIndex)
    if bPoseSlotEmpty == false then
      self._contentImage[imageIndex]:SetShow(true)
    else
      self._contentImage[imageIndex]:SetShow(false)
    end
  end
end
function Customization_BodyPoseInfo:ClearContentList()
  for _, control in pairs(self._contentImage) do
    if nil ~= control then
      control:SetShow(false)
      UI.deleteControl(control)
    end
  end
  ToClient_padSnapResetControl()
  self._contentImage = {}
end
function Customization_BodyPoseInfo:InitializePoseEditor()
  self:ClearContentList()
  local texSize = 48.25
  for itemIdx = 0, 9 do
    local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, self._ui._static_PoseGroup, "Frame_Image_" .. itemIdx)
    CopyBaseProperty(self._ui._poseTemplate, tempContentImage)
    tempContentImage:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_BodyPose_SelectPose(" .. itemIdx .. ")")
    local mod = itemIdx % 4
    local divi = math.floor(itemIdx / 4)
    local texUV = {
      x1,
      y1,
      x2,
      y2
    }
    texUV.x1 = mod * texSize
    texUV.y1 = divi * texSize
    texUV.x2 = texUV.x1 + texSize
    texUV.y2 = texUV.y1 + texSize
    tempContentImage:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/cus_pose_tempsave.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(tempContentImage, texUV.x1, texUV.y1, texUV.x2, texUV.y2)
    tempContentImage:getBaseTexture():setUV(x1, y1, x2, y2)
    tempContentImage:SetPosX(25 + itemIdx % 5 * (self._ui._poseTemplate:GetSizeX() + 10))
    tempContentImage:SetPosY(15 + math.floor(itemIdx / 5) * (self._ui._poseTemplate:GetSizeY() + 10))
    tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
    tempContentImage:SetShow(true)
    self._contentImage[itemIdx] = tempContentImage
  end
end
function Customization_BodyPoseInfo:CalculateSliderRotation(sliderControl, valueMin, valueMax)
  local ratio = sliderControl:GetControlPos()
  local val = valueMax - valueMin
  local progress = UI.getChildControl(sliderControl, "Progress2_1")
  local button = UI.getChildControl(sliderControl, "Slider_DisplayButton")
  button:SetPosX(sliderControl:GetControlButton():GetPosX())
  local offset = math.cos(ratio * math.pi) * 2
  progress:SetProgressRate(ratio * 100 + offset)
  return ratio * val - (val - math.abs(valueMax))
end
function Customization_BodyPoseInfo:SetRotationSlider(sliderControl, value, valueMin, valueMax)
  local val = valueMax - valueMin
  if val ~= 0 then
    sliderControl:SetControlPos((value - valueMin) / val * 100)
  end
end
function PaGlobalFunc_Customization_BodyPose_SetBoneControl(isSet)
  local self = Customization_BodyPoseInfo
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  if false == isSet then
    self._isBoneControl = false
    PaGlobalFunc_Customization_SetKeyGuide(3)
    Panel_Customizing_BodyPose:ignorePadSnapUpdate(false)
    ToClient_StartOrEndShapeBoneControlStart(false)
    PaGlobalFunc_Customization_BodyPose_Update()
    PaGlobalFunc_Customization_BodyPose_SetShow(true)
  else
    self._isBoneControl = true
    PaGlobalFunc_Customization_SetKeyGuide(4)
    Panel_Customizing_BodyPose:ignorePadSnapUpdate(true)
    ToClient_StartOrEndShapeBoneControlStart(true)
    PaGlobalFunc_CustomizingKeyGuide_Open(PaGlobalFunc_Customization_BodyPose_SetBoneControl, 3)
    PaGlobalFunc_Customization_BodyPose_SetShow(false)
  end
end
function PaGlobalFunc_Customization_BodyPose_ClearPoseBone()
  local self = Customization_BodyPoseInfo
  self._ui._poseSelect:SetShow(false)
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  clearPoseBone()
  if nil == self._lastRot then
    return
  end
  self:SetRotationSlider(self._ui._slider_RotationX, self._lastRot.x, self._lastRotMin.x, self._lastRotMax.x)
  self:SetRotationSlider(self._ui._slider_RotationY, self._lastRot.y, self._lastRotMin.y, self._lastRotMax.y)
  self:SetRotationSlider(self._ui._slider_RotationZ, self._lastRot.z, self._lastRotMin.z, self._lastRotMax.z)
  PaGlobalFunc_Customization_BodyPose_Update()
end
function PaGlobalFunc_Customization_BodyPose_ClearAllPoseBone()
  local self = Customization_BodyPoseInfo
  self._ui._poseSelect:SetShow(false)
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  clearAllPoseBone()
  if nil == self._lastRot then
    return
  end
  self:SetRotationSlider(self._ui._slider_RotationX, self._lastRot.x, self._lastRotMin.x, self._lastRotMax.x)
  self:SetRotationSlider(self._ui._slider_RotationY, self._lastRot.y, self._lastRotMin.y, self._lastRotMax.y)
  self:SetRotationSlider(self._ui._slider_RotationZ, self._lastRot.z, self._lastRotMin.z, self._lastRotMax.z)
  PaGlobalFunc_Customization_BodyPose_Update()
end
function Customization_BodyPoseInfo:InitControl()
  self._ui._checkbox_ShowPart = UI.getChildControl(self._ui._static_ControlGroup, "CheckButton_ShowPart")
  self._ui._checkbox_ShowPart:SetCheck(true)
  self._ui._checkbox_Symmetry = UI.getChildControl(self._ui._static_ControlGroup, "CheckButton_Symmetry")
  self._ui._button_ResetPart = UI.getChildControl(self._ui._static_ControlGroup, "Button_ResetPart")
  self._ui._button_ResetAll = UI.getChildControl(self._ui._static_ControlGroup, "Button_ResetAll")
  self._ui._static_RotationSliderXBg = UI.getChildControl(self._ui._static_RotationSliderGroup, "Static_XBg")
  self._ui._static_RotationSliderYBg = UI.getChildControl(self._ui._static_RotationSliderGroup, "Static_YBg")
  self._ui._static_RotationSliderZBg = UI.getChildControl(self._ui._static_RotationSliderGroup, "Static_ZBg")
  self._ui._slider_RotationX = UI.getChildControl(self._ui._static_RotationSliderXBg, "Slider_X")
  self._ui._slider_RotationY = UI.getChildControl(self._ui._static_RotationSliderYBg, "Slider_Y")
  self._ui._slider_RotationZ = UI.getChildControl(self._ui._static_RotationSliderZBg, "Slider_Z")
  self._ui._sliderButton_RotationX = UI.getChildControl(self._ui._slider_RotationX, "Slider_Button")
  self._ui._sliderButton_RotationY = UI.getChildControl(self._ui._slider_RotationY, "Slider_Button")
  self._ui._sliderButton_RotationZ = UI.getChildControl(self._ui._slider_RotationZ, "Slider_Button")
  self._ui._poseTemplate = UI.getChildControl(self._ui._static_PoseGroup, "Button_PoseTemplate")
  self._ui._poseTemplate:SetShow(false)
  self._ui._poseSelect = UI.getChildControl(self._ui._static_PoseGroup, "Static_SelectedSlot")
  self._ui._poseSelect:SetShow(false)
  self._ui._button_Save = UI.getChildControl(self._ui._static_SaveGroup, "Button_Save")
  self._ui._button_Delete = UI.getChildControl(self._ui._static_SaveGroup, "Button_Delete")
end
function Customization_BodyPoseInfo:InitEvent()
  self._ui._button_ResetPart:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_BodyPose_ClearPoseBone()")
  self._ui._button_ResetAll:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_BodyPose_ClearAllPoseBone()")
  self._ui._slider_RotationX:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_BodyPose_SliderOn()")
  self._ui._slider_RotationX:addInputEvent("Mouse_Out", "PaGlobalFunc_Customization_BodyPose_SliderOut()")
  self._ui._slider_RotationY:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_BodyPose_SliderOn()")
  self._ui._slider_RotationY:addInputEvent("Mouse_Out", "PaGlobalFunc_Customization_BodyPose_SliderOut()")
  self._ui._slider_RotationZ:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_BodyPose_SliderOn()")
  self._ui._slider_RotationZ:addInputEvent("Mouse_Out", "PaGlobalFunc_Customization_BodyPose_SliderOut()")
  self._ui._slider_RotationX:addInputEvent("Mouse_LPress", "PaGlobalFunc_Customization_BodyPose_PoseEditSliderUpdate()")
  self._ui._slider_RotationY:addInputEvent("Mouse_LPress", "PaGlobalFunc_Customization_BodyPose_PoseEditSliderUpdate()")
  self._ui._slider_RotationZ:addInputEvent("Mouse_LPress", "PaGlobalFunc_Customization_BodyPose_PoseEditSliderUpdate()")
  self._ui._sliderButton_RotationX:SetIgnore(true)
  self._ui._sliderButton_RotationY:SetIgnore(true)
  self._ui._sliderButton_RotationZ:SetIgnore(true)
  self._ui._checkbox_ShowPart:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_BodyPose_ToggleShowPoseBoneControlPart()")
  self._ui._checkbox_Symmetry:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_BodyPose_PoseEditSymmetryChecked()")
  self._ui._button_Save:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_BodyPose_SavePose()")
  self._ui._button_Delete:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_BodyPose_DeletePose()")
  Panel_Customizing_BodyPose:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_Customization_BodyPose_SetBoneControl(true)")
end
function Customization_BodyPoseInfo:InitRegister()
  registerEvent("EventOpenPoseEditUi", "PaGlobalFunc_Customization_BodyPose_OpenPoseEditUi")
  registerEvent("EventClosePoseEditUi", "PaGlobalFunc_Customization_BodyPose_ClosePoseEditUi")
  registerEvent("EventShowPoseEditor", "PaGlobalFunc_Customization_BodyPose_ShowPoseEditor")
  registerEvent("EventAdjustPoseBoneRotation", "PaGlobalFunc_Customization_BodyPose_AdjustPoseBoneRotation")
  registerEvent("EventSelectPoseEditorControl", "PaGlobalFunc_Customization_BodyPose_SelectPoseEditorControl")
  registerEvent("EventEnablePoseEditSlide", "PaGlobalFunc_Customization_BodyPose_EnablePoseEditSlide")
end
function Customization_BodyPoseInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function PaGlobalFunc_FromClient_Customization_BodyPose_luaLoadComplete()
  local self = Customization_BodyPoseInfo
  self:Initialize()
end
function PaGlobalFunc_Customization_BodyPose_Close()
  local self = Customization_BodyPoseInfo
  if false == PaGlobalFunc_Customization_BodyPose_GetShow() then
    return false
  end
  if true == self._isBoneControl then
    PaGlobalFunc_Customization_BodyPose_SetBoneControl(false)
    return false
  end
  self._currentData = nil
  clearAllPoseBone()
  endPickingMode()
  PaGlobalFunc_Customization_SetKeyGuide(0)
  PaGlobalFunc_Customization_SetCloseFunc(nil)
  PaGlobalFunc_Customization_SetBackEvent()
  PaGlobalFunc_Customization_BodyPose_SetShow(false)
  return true
end
function PaGlobalFunc_Customization_BodyPose_Open()
  if true == PaGlobalFunc_Customization_BodyPose_GetShow() then
    return
  end
  PaGlobalFunc_Customization_BodyPose_SetShow(true)
  PaGlobalFunc_Customization_KeyGuideSetShow(true)
  PaGlobalFunc_Customization_SetKeyGuide(3)
  PaGlobalFunc_Customization_BodyPose_ToggleShowPoseBoneControlPart()
  PaGlobalFunc_Customization_SetCloseFunc(PaGlobalFunc_Customization_BodyPose_Close)
  PaGlobalFunc_Customization_SetBackEvent("PaGlobalFunc_Customization_BodyPose_Close()")
end
function PaGlobalFunc_Customization_BodyPose_SetShow(isShow)
  Panel_Customizing_BodyPose:SetShow(isShow)
end
function PaGlobalFunc_Customization_BodyPose_GetShow()
  return Panel_Customizing_BodyPose:GetShow()
end
function PaGlobalFunc_Customization_BodyPose_Update()
  local self = Customization_BodyPoseInfo
  if nil == self._currentData then
    return
  end
  self:CalculateSliderRotation(self._ui._slider_RotationX, self._selectedRotMin.x, self._selectedRotMax.x)
  self:CalculateSliderRotation(self._ui._slider_RotationY, self._selectedRotMin.y, self._selectedRotMax.y)
  self:CalculateSliderRotation(self._ui._slider_RotationZ, self._selectedRotMin.z, self._selectedRotMax.z)
end
PaGlobalFunc_FromClient_Customization_BodyPose_luaLoadComplete()

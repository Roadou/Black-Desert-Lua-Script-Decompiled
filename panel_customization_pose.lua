local rotMin, rotMax, currentRotation
local PoseEditUIRect = {
  left,
  top,
  right,
  bottom
}
local ContentImage = {}
local selectedImageIndex = -1
local StaticText_ControlType = UI.getChildControl(Panel_CustomizationPoseEdit, "StaticText_ControlType")
local StaticText_DetailControl = UI.getChildControl(Panel_CustomizationPoseEdit, "StaticText_DetailControl")
local StaticText_Symmetry = UI.getChildControl(Panel_CustomizationPoseEdit, "StaticText_Symmetry")
local StaticText_ControlPart = UI.getChildControl(Panel_CustomizationPoseEdit, "StaticText_ControlPart")
local StaticText_Y = UI.getChildControl(Panel_CustomizationPoseEdit, "StaticText_Y")
local StaticText_Z = UI.getChildControl(Panel_CustomizationPoseEdit, "StaticText_Z")
local RadioButton_Ik = UI.getChildControl(Panel_CustomizationPoseEdit, "RadioButton_Ik")
local RadioButton_Bone = UI.getChildControl(Panel_CustomizationPoseEdit, "RadioButton_Bone")
RadioButton_Bone:SetCheck(true)
RadioButton_Ik:SetShow(false)
local Button_AllReset = UI.getChildControl(Panel_CustomizationPoseEdit, "Button_All_Reset")
local Button_PartReset = UI.getChildControl(Panel_CustomizationPoseEdit, "Button_Part_Reset")
local Button_Save = UI.getChildControl(Panel_CustomizationPoseEdit, "Button_Save")
local Button_Delete = UI.getChildControl(Panel_CustomizationPoseEdit, "Button_Delete")
local Slider_X = UI.getChildControl(Panel_CustomizationPoseEdit, "Slider_X_Controller")
local Slider_Y = UI.getChildControl(Panel_CustomizationPoseEdit, "Slider_Y_Controller")
local Slider_Z = UI.getChildControl(Panel_CustomizationPoseEdit, "Slider_Z_Controller")
local StaticText_Slider_X = UI.getChildControl(Panel_CustomizationPoseEdit, "StaticText_Slider_X_Left")
local StaticText_Slider_Y = UI.getChildControl(Panel_CustomizationPoseEdit, "StaticText_Slider_Y_Left")
local StaticText_Slider_Z = UI.getChildControl(Panel_CustomizationPoseEdit, "StaticText_Slider_Z_Left")
StaticText_Slider_X:SetShow(false)
StaticText_Slider_Y:SetShow(false)
StaticText_Slider_Z:SetShow(false)
local Button_Slider_X = UI.getChildControl(Slider_X, "Slider_GammaController_Button")
local Button_Slider_Y = UI.getChildControl(Slider_Y, "Slider_GammaController_Button")
local Button_Slider_Z = UI.getChildControl(Slider_Z, "Slider_GammaController_Button")
Slider_X:addInputEvent("Mouse_LPress", "PoseEditSliderUpdate()")
Slider_Y:addInputEvent("Mouse_LPress", "PoseEditSliderUpdate()")
Slider_Z:addInputEvent("Mouse_LPress", "PoseEditSliderUpdate()")
Button_Slider_X:addInputEvent("Mouse_LPress", "PoseEditSliderUpdate()")
Button_Slider_Y:addInputEvent("Mouse_LPress", "PoseEditSliderUpdate()")
Button_Slider_Z:addInputEvent("Mouse_LPress", "PoseEditSliderUpdate()")
local CheckButton_Symmetry = UI.getChildControl(Panel_CustomizationPoseEdit, "CheckButton_Symmetry")
local CheckButton_ControlPart = UI.getChildControl(Panel_CustomizationPoseEdit, "CheckButton_ControlPart")
CheckButton_Symmetry:SetCheck(false)
CheckButton_ControlPart:SetCheck(true)
CheckButton_ControlPart:addInputEvent("Mouse_LUp", "ToggleShowPoseBoneControlPart()")
local FrameTemplate = UI.getChildControl(Panel_CustomizationPoseEdit, "Frame_Template")
local Frame_Content = UI.getChildControl(FrameTemplate, "Frame_Content")
local Frame_ContentImage = UI.getChildControl(Frame_Content, "Frame_Content_Image")
local Frame_Scroll = UI.getChildControl(FrameTemplate, "Frame_Scroll")
CheckButton_Symmetry:addInputEvent("Mouse_LUp", "PoseEditSymmetryChecked()")
Button_AllReset:addInputEvent("Mouse_LUp", "clearAllPoseBone()")
Button_PartReset:addInputEvent("Mouse_LUp", "clearPoseBone()")
Button_Save:addInputEvent("Mouse_LUp", "SavePose()")
Button_Delete:addInputEvent("Mouse_LUp", "DeletePose()")
if false == _ContentsGroup_RenewUI_Customization then
  registerEvent("EventOpenPoseEditUi", "OpenPoseEditUi")
  registerEvent("EventClosePoseEditUi", "ClosePoseEditUi")
  registerEvent("EventShowPoseEditor", "ShowPoseEditor")
  registerEvent("EventAdjustPoseBoneRotation", "AdjustPoseBoneRotation")
  registerEvent("EventSelectPoseEditorControl", "SelectPoseEditorControl")
  registerEvent("EventRepositionPoseEditCursorUI", "RepositionPoseEditCursorUI")
  registerEvent("EventEnablePoseEditSlide", "EnablePoseEditSlide")
  registerEvent("EventPoseEditBoneDrag", "PoseEditBoneDrag")
end
local function clearContentList()
  for _, content in pairs(ContentImage) do
    content:SetShow(false)
    UI.deleteControl(content)
  end
  ContentImage = {}
end
function InitializePoseEditor(customizationData)
  clearContentList()
  local texSize = 48.25
  for itemIdx = 0, 9 do
    local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Frame_Content, "Frame_Image_" .. itemIdx)
    CopyBaseProperty(Frame_ContentImage, tempContentImage)
    tempContentImage:addInputEvent("Mouse_LUp", "SelectPose(" .. itemIdx .. ")")
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
    tempContentImage:SetPosX(10 + itemIdx % 4 * (Frame_ContentImage:GetSizeX() + 10))
    tempContentImage:SetPosY(10 + math.floor(itemIdx / 4) * (Frame_ContentImage:GetSizeY() + 10))
    tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
    tempContentImage:SetShow(true)
    ContentImage[itemIdx] = tempContentImage
  end
  FrameTemplate:UpdateContentScroll()
  Frame_Scroll:SetControlTop()
  FrameTemplate:UpdateContentPos()
end
function SelectPoseEditorControl(customizationData)
  EnablePoseEditSlide(true)
  rotMin = customizationData:getSelectedBoneRotationMin()
  rotMax = customizationData:getSelectedBoneRotationMax()
  currentRotation = customizationData:getSelectedBoneRotationValue()
  setRotationSlider(Slider_X, currentRotation.x, rotMin.x, rotMax.x)
  setRotationSlider(Slider_Y, currentRotation.y, rotMin.y, rotMax.y)
  setRotationSlider(Slider_Z, currentRotation.z, rotMin.z, rotMax.z)
end
function AdjustPoseBoneRotation(rotationX, rotationY, rotationZ)
  setRotationSlider(Slider_X, rotationX, rotMin.x, rotMax.x)
  setRotationSlider(Slider_Y, rotationY, rotMin.y, rotMax.y)
  setRotationSlider(Slider_Z, rotationZ, rotMin.z, rotMax.z)
  currentRotation.x = rotationX
  currentRotation.y = rotationY
  currentRotation.z = rotationZ
end
local CheckCursorInPoseEditorUI = function()
end
function RepositionPoseEditCursorUI(posX, posY)
end
function EnablePoseEditCursor(Enable)
end
function PoseEditSymmetryChecked()
  setSymmetryBoneTransform(CheckButton_Symmetry:IsCheck())
end
function OpenPoseEditUi(uiId)
  EnablePoseEditSlide(false)
  startPosePickingMode()
  Slider_X:SetControlPos(50)
  Slider_Y:SetControlPos(50)
  Slider_Z:SetControlPos(50)
  updateGroupFrameControls(Panel_CustomizationPoseEdit:GetSizeY(), Panel_CustomizationPoseEdit)
  UpdateSavedPoses()
  Panel_CustomizationPoseEdit:SetShow(true, false)
  UseIkPoseControl(false)
  PoseEditSymmetryChecked()
  EnablePoseEditCursor(true)
  setPresetCamera(4)
end
function ClosePoseEditUi()
  clearAllPoseBone()
  endPickingMode()
end
function ShowPoseEditor(show)
  if true == show then
    EnablePoseEditSlide(false)
    Slider_X:SetControlPos(50)
    Slider_Y:SetControlPos(50)
    Slider_Z:SetControlPos(50)
    updateGroupFrameControls(Panel_CustomizationPoseEdit:GetSizeY(), Panel_CustomizationPoseEdit)
    UpdateSavedPoses()
    Panel_CustomizationPoseEdit:SetShow(show, false)
    UseIkPoseControl(false)
    PoseEditSymmetryChecked()
    EnablePoseEditCursor(show)
  else
  end
end
function UpdateSavedPoses()
  for imageIndex = 0, 9 do
    local bPoseSlotEmpty = getPoseDataEmpty(imageIndex)
    if bPoseSlotEmpty == false then
      ContentImage[imageIndex]:SetShow(true)
    else
      ContentImage[imageIndex]:SetShow(false)
    end
  end
  FrameTemplate:UpdateContentScroll()
  Frame_Scroll:SetControlTop()
  FrameTemplate:UpdateContentPos()
end
function calculateSliderRotation(SliderControl, valueMin, valueMax)
  local ratio = SliderControl:GetControlPos()
  local val = valueMax - valueMin
  return ratio * val - (val - math.abs(valueMax))
end
function setRotationSlider(SliderControl, value, valueMin, valueMax)
  local val = valueMax - valueMin
  if val ~= 0 then
    SliderControl:SetControlPos((value - valueMin) / val * 100)
  end
end
function PoseEditSliderUpdate()
  local x = calculateSliderRotation(Slider_X, rotMin.x, rotMax.x)
  local y = calculateSliderRotation(Slider_Y, rotMin.y, rotMax.y)
  local z = calculateSliderRotation(Slider_Z, rotMin.z, rotMax.z)
  currentRotation.x = x
  currentRotation.y = y
  currentRotation.z = z
  applyPoseRotation(x, y, z)
end
function PoseEditBoneDrag(bDrag)
  if true == bDrag then
    EnablePoseEditCursor(false)
  else
    EnablePoseEditCursor(true)
  end
end
function ClosePoseEditor()
  selectCustomizationControlPart(-1)
  clearAllPoseBone()
  selectedImageIndex = -1
end
function SavePose()
  savePoseInfo()
  UpdateSavedPoses()
end
function DeletePose()
  if selectedImageIndex ~= -1 then
    deletePoseInfo(selectedImageIndex)
    UpdateSavedPoses()
  end
end
function SelectPose(imageIndex)
  applyPose(imageIndex)
  selectedImageIndex = imageIndex
end
function UseIkPoseControl(useIk)
  if useIk == false then
    EnablePoseEditCursor(true)
  elseif controlType == true then
    EnablePoseEditCursor(false)
  end
  useIkPoseControl(useIk)
end
function ToggleShowPosePreCheck()
  if CheckButton_ControlPart:IsCheck() then
    showBoneControlPart(true)
  else
    showBoneControlPart(false)
  end
end
function ToggleShowPoseBoneControlPart()
  showBoneControlPart(CheckButton_ControlPart:IsCheck())
end
function EnablePoseEditSlide(enable)
  Slider_X:SetMonoTone(not enable)
  Slider_Y:SetMonoTone(not enable)
  Slider_Z:SetMonoTone(not enable)
  Slider_X:SetEnable(enable)
  Slider_Y:SetEnable(enable)
  Slider_Z:SetEnable(enable)
end

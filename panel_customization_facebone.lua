local RadioButton_Bone_Trans = UI.getChildControl(Panel_CustomizationTransform, "RadioButton_Bone_Trans")
local RadioButton_Bone_Rot = UI.getChildControl(Panel_CustomizationTransform, "RadioButton_Bone_Rot")
local RadioButton_Bone_Scale = UI.getChildControl(Panel_CustomizationTransform, "RadioButton_Bone_Scale")
local StaticText_DefaultControl = UI.getChildControl(Panel_CustomizationTransform, "StaticText_DefaultControl")
local StaticText_Symmetry = UI.getChildControl(Panel_CustomizationTransform, "StaticText_Symmetry")
local StaticText_ControlPart = UI.getChildControl(Panel_CustomizationTransform, "StaticText_ControlPart")
local StaticText_TransX = UI.getChildControl(Panel_CustomizationTransform, "StaticText_TransX")
local StaticText_TransY = UI.getChildControl(Panel_CustomizationTransform, "StaticText_TransY")
local StaticText_TransZ = UI.getChildControl(Panel_CustomizationTransform, "StaticText_TransZ")
local StaticText_RotX = UI.getChildControl(Panel_CustomizationTransform, "StaticText_RotX")
local StaticText_RotY = UI.getChildControl(Panel_CustomizationTransform, "StaticText_RotY")
local StaticText_RotZ = UI.getChildControl(Panel_CustomizationTransform, "StaticText_RotZ")
local StaticText_ScaleX = UI.getChildControl(Panel_CustomizationTransform, "StaticText_ScaleX")
local StaticText_ScaleY = UI.getChildControl(Panel_CustomizationTransform, "StaticText_ScaleY")
local StaticText_ScaleZ = UI.getChildControl(Panel_CustomizationTransform, "StaticText_ScaleZ")
local Button_All_Reset = UI.getChildControl(Panel_CustomizationTransform, "Button_All_Reset")
local Button_Part_Reset = UI.getChildControl(Panel_CustomizationTransform, "Button_Part_Reset")
local Slider_TransX = UI.getChildControl(Panel_CustomizationTransform, "Slider_TransX_Controller")
local Slider_TransY = UI.getChildControl(Panel_CustomizationTransform, "Slider_TransY_Controller")
local Slider_TransZ = UI.getChildControl(Panel_CustomizationTransform, "Slider_TransZ_Controller")
local Slider_RotX = UI.getChildControl(Panel_CustomizationTransform, "Slider_RotX_Controller")
local Slider_RotY = UI.getChildControl(Panel_CustomizationTransform, "Slider_RotY_Controller")
local Slider_RotZ = UI.getChildControl(Panel_CustomizationTransform, "Slider_RotZ_Controller")
local Slider_ScaleX = UI.getChildControl(Panel_CustomizationTransform, "Slider_ScaleX_Controller")
local Slider_ScaleY = UI.getChildControl(Panel_CustomizationTransform, "Slider_ScaleY_Controller")
local Slider_ScaleZ = UI.getChildControl(Panel_CustomizationTransform, "Slider_ScaleZ_Controller")
local Button_Slider_TransX = UI.getChildControl(Slider_TransX, "Slider_GammaController_Button")
local Button_Slider_TransY = UI.getChildControl(Slider_TransY, "Slider_GammaController_Button")
local Button_Slider_TransZ = UI.getChildControl(Slider_TransZ, "Slider_GammaController_Button")
local Button_Slider_RotX = UI.getChildControl(Slider_RotX, "Slider_GammaController_Button")
local Button_Slider_RotY = UI.getChildControl(Slider_RotY, "Slider_GammaController_Button")
local Button_Slider_RotZ = UI.getChildControl(Slider_RotZ, "Slider_GammaController_Button")
local Button_Slider_ScaleX = UI.getChildControl(Slider_ScaleX, "Slider_GammaController_Button")
local Button_Slider_ScaleY = UI.getChildControl(Slider_ScaleY, "Slider_GammaController_Button")
local Button_Slider_ScaleZ = UI.getChildControl(Slider_ScaleZ, "Slider_GammaController_Button")
local CheckButton_Symmetry = UI.getChildControl(Panel_CustomizationTransform, "CheckButton_Symmetry")
local CheckButton_ControlPart = UI.getChildControl(Panel_CustomizationTransform, "CheckButton_ControlPart")
local Static_MouseCursor = {}
Static_MouseCursor[1] = UI.getChildControl(Panel_Customization_Control, "Static_Cursor_Trans")
Static_MouseCursor[2] = UI.getChildControl(Panel_Customization_Control, "Static_Cursor_Rotate")
Static_MouseCursor[3] = UI.getChildControl(Panel_Customization_Control, "Static_Cursor_Scale")
local Static_Control_BG = UI.getChildControl(Panel_CustomizationTest, "Static_Control_BG")
local StaticText_Control_Title = UI.getChildControl(Panel_CustomizationTest, "StaticText_Control_Title")
local StaticText_Control_Name = UI.getChildControl(Panel_CustomizationTest, "StaticText_Control_Name")
local Edit_Control = UI.getChildControl(Panel_CustomizationTest, "Edit_Control")
local Button_Apply = UI.getChildControl(Panel_CustomizationTest, "Button_Apply")
local Button_Reset = UI.getChildControl(Panel_CustomizationTest, "Button_Reset")
local Button_Save = UI.getChildControl(Panel_CustomizationTest, "Button_SaveXml")
local Button_DebugRot = UI.getChildControl(Panel_CustomizationTest, "Button_DebugRot")
local Edit_DebugRotControl = UI.getChildControl(Panel_CustomizationTest, "Edit_DebugRotControl")
local Edit_PresetIndex = UI.getChildControl(Panel_CustomizationTest, "Edit_PresetIndex")
function PaGlobalFunc_CustomizationForDev_SaveBodyPreset()
  local index = Edit_PresetIndex:GetEditText()
  if true == Edit_PresetIndex:GetFocusEdit() then
    ClearFocusEdit()
  end
  local result = ToClient_CustomizationSaveBodyPreset(index)
  if false == result then
    _PA_LOG("Common", "\236\187\164\235\167\136 \237\148\132\235\166\172\236\133\139 \236\160\128\236\158\165 \236\139\164\237\140\168\237\150\136\236\138\181\235\139\136\235\139\164.")
  end
end
function PaGlobalFunc_CustomizationForDev_LoadBodyPreset()
  local index = Edit_PresetIndex:GetEditText()
  if true == Edit_PresetIndex:GetFocusEdit() then
    ClearFocusEdit()
  end
  local result = ToClient_CustomizationLoadBodyPreset(index)
  if false == result then
    _PA_LOG("Common", "\236\187\164\235\167\136 \237\148\132\235\166\172\236\133\139 \235\182\136\235\159\172\236\152\164\234\184\176 \236\139\164\237\140\168\237\150\136\236\138\181\235\139\136\235\139\164.")
  end
end
function PaGlobalFunc_CustomizationForDev_SaveFacePreset()
  local index = Edit_PresetIndex:GetEditText()
  if true == Edit_PresetIndex:GetFocusEdit() then
    ClearFocusEdit()
  end
  local result = ToClient_CustomizationSaveFacePreset(index)
  if false == result then
    _PA_LOG("Common", "\236\187\164\235\167\136 \237\148\132\235\166\172\236\133\139 \236\160\128\236\158\165 \236\139\164\237\140\168\237\150\136\236\138\181\235\139\136\235\139\164.")
  end
end
function PaGlobalFunc_CustomizationForDev_LoadFacePreset()
  local index = Edit_PresetIndex:GetEditText()
  if true == Edit_PresetIndex:GetFocusEdit() then
    ClearFocusEdit()
  end
  local result = ToClient_CustomizationLoadFacePreset(index)
  if false == result then
    _PA_LOG("Common", "\236\187\164\235\167\136 \237\148\132\235\166\172\236\133\139 \235\182\136\235\159\172\236\152\164\234\184\176 \236\139\164\237\140\168\237\150\136\236\138\181\235\139\136\235\139\164.")
  end
end
local Button_AddPresetBody = UI.getChildControl(Panel_CustomizationTest, "Button_AddPresetBody")
local Button_LoadPresetBody = UI.getChildControl(Panel_CustomizationTest, "Button_LoadPresetBody")
Button_AddPresetBody:addInputEvent("Mouse_LUp", "PaGlobalFunc_CustomizationForDev_SaveBodyPreset()")
Button_LoadPresetBody:addInputEvent("Mouse_LUp", "PaGlobalFunc_CustomizationForDev_LoadBodyPreset()")
local Button_AddPresetFace = UI.getChildControl(Panel_CustomizationTest, "Button_AddPresetFace")
local Button_LoadPresetFace = UI.getChildControl(Panel_CustomizationTest, "Button_LoadPresetFace")
Button_AddPresetFace:addInputEvent("Mouse_LUp", "PaGlobalFunc_CustomizationForDev_SaveFacePreset()")
Button_LoadPresetFace:addInputEvent("Mouse_LUp", "PaGlobalFunc_CustomizationForDev_LoadFacePreset()")
local currentuiId = -1
RadioButton_Bone_Trans:SetCheck(true)
StaticText_DefaultControl:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_SELECT_CONTROL"))
StaticText_Symmetry:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_SYMMETRY"))
StaticText_ControlPart:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_CONTROLPART"))
Button_All_Reset:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_ALL_RESET"))
Button_Part_Reset:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_PART_RESET"))
CheckButton_Symmetry:SetCheck(true)
CheckButton_ControlPart:SetCheck(true)
Static_MouseCursor[1]:SetShow(false)
Static_MouseCursor[1]:SetIgnore(true)
Static_MouseCursor[2]:SetShow(false)
Static_MouseCursor[2]:SetIgnore(true)
Static_MouseCursor[3]:SetShow(false)
Static_MouseCursor[3]:SetIgnore(true)
Edit_DebugRotControl:SetEditText("0")
Slider_TransX:addInputEvent("Mouse_LPress", "UpdateSlider( 1 )")
Slider_TransY:addInputEvent("Mouse_LPress", "UpdateSlider( 1 )")
Slider_TransZ:addInputEvent("Mouse_LPress", "UpdateSlider( 1 )")
Button_Slider_TransX:addInputEvent("Mouse_LPress", "UpdateSlider( 1 )")
Button_Slider_TransY:addInputEvent("Mouse_LPress", "UpdateSlider( 1 )")
Button_Slider_TransZ:addInputEvent("Mouse_LPress", "UpdateSlider( 1 )")
Slider_RotX:addInputEvent("Mouse_LPress", "UpdateSlider( 2 )")
Slider_RotY:addInputEvent("Mouse_LPress", "UpdateSlider( 2 )")
Slider_RotZ:addInputEvent("Mouse_LPress", "UpdateSlider( 2 )")
Button_Slider_RotX:addInputEvent("Mouse_LPress", "UpdateSlider( 2 )")
Button_Slider_RotY:addInputEvent("Mouse_LPress", "UpdateSlider( 2 )")
Button_Slider_RotZ:addInputEvent("Mouse_LPress", "UpdateSlider( 2 )")
Slider_ScaleX:addInputEvent("Mouse_LPress", "UpdateSlider( 3 )")
Slider_ScaleY:addInputEvent("Mouse_LPress", "UpdateSlider( 3 )")
Slider_ScaleZ:addInputEvent("Mouse_LPress", "UpdateSlider( 3 )")
Button_Slider_ScaleX:addInputEvent("Mouse_LPress", "UpdateSlider( 3 )")
Button_Slider_ScaleY:addInputEvent("Mouse_LPress", "UpdateSlider( 3 )")
Button_Slider_ScaleZ:addInputEvent("Mouse_LPress", "UpdateSlider( 3 )")
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
Slider_ScaleX:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Slider_ScaleY:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Slider_ScaleZ:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_Slider_ScaleX:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_Slider_ScaleY:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
Button_Slider_ScaleZ:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
CheckButton_Symmetry:addInputEvent("Mouse_LUp", "SymmetryChecked()")
CheckButton_ControlPart:addInputEvent("Mouse_LUp", "ShowControlPart()")
Button_All_Reset:addInputEvent("Mouse_LUp", "clearGroupCustomizedBonInfoLua()")
Button_Part_Reset:addInputEvent("Mouse_LUp", "clearCustomizedBoneInfo()")
Button_Reset:addInputEvent("Mouse_LUp", "resetControlParameters()")
Button_Save:addInputEvent("Mouse_LUp", "saveControlParameters()")
RadioButton_Bone_Trans:addInputEvent("Mouse_LUp", "CursorSelect(1)")
RadioButton_Bone_Rot:addInputEvent("Mouse_LUp", "CursorSelect(2)")
RadioButton_Bone_Scale:addInputEvent("Mouse_LUp", "CursorSelect(3)")
Button_DebugRot:addInputEvent("Mouse_LUp", "ApplyCharacterRotateForDebugging()")
if false == _ContentsGroup_RenewUI_Customization then
  registerEvent("EventSelectSculptingBoneControl", "SelectSculptingBoneControl")
  registerEvent("EventAdjustSculptingBoneTranslation", "AdjustSculptingBoneTranslation")
  registerEvent("EventAdjustSculptingBoneRotation", "AdjustSculptingBoneRotation")
  registerEvent("EventAdjustSculptingBoneScale", "AdjustSculptingBoneScale")
  registerEvent("EventOpenFaceShapeUi", "OpenFaceShapeUi")
  registerEvent("EventCloseFaceShapeUi", "CloseFaceShapeUi")
  registerEvent("EventShowBoneSculptingSelector", "showBoneSculptingSelector")
  registerEvent("EventSetShowCustomizationEditor", "SetShowCustomizationEditor")
  registerEvent("EventRepositionCursorUI", "RepositionCursorUI")
  registerEvent("EventSelectBoneDrag", "SelectBoneDrag")
  registerEvent("EventSelectTransformType", "SelectTransformType")
  registerEvent("EventEnableFaceSlide", "EnableFaceSlide")
end
local transMin, transMax, rotMin, rotMax, scaleMin, scaleMax, currentTranslation, currentRotation, currentScale
local SculptingUIRect = {
  left,
  top,
  right,
  bottom
}
local mouseCursorRadius = Static_MouseCursor[1]:GetSizeX()
local ControlMode = 1
local selectedGroup = 0
local selectedPart = 0
local thirtyDegree = math.pi / 10
local GroupTree = {}
local groupCount
groups = {}
local selectedCharacterClass = -1
sculptingBoneSettingUI = {
  StaticText = {},
  StaticText_String = {
    [1] = "Pick Radius",
    [2] = "Pick x y z",
    [3] = "Trans Min x y z",
    [4] = "Trans Max x y z",
    [5] = "Rot Min p y r",
    [6] = "Rot Max p y r",
    [7] = "Scale Min x y z",
    [8] = "Scale Max x y z",
    [9] = "Trans Value x y z",
    [10] = "Rot Value p y r",
    [11] = "Scale Value x y z"
  },
  STATIC_TEXT_COUNT = 11,
  EditText = {},
  ControlParam = {},
  PARAM_PICKRADIUS = 1,
  PARAM_PICKPOSX = 2,
  PARAM_PICKPOSY = 3,
  PARAM_PICKPOSZ = 4,
  PARAM_TRANSMINX = 5,
  PARAM_TRANSMINY = 6,
  PARAM_TRANSMINZ = 7,
  PARAM_TRANSMAXX = 8,
  PARAM_TRANSMAXY = 9,
  PARAM_TRANSMAXZ = 10,
  PARAM_ROTMINX = 11,
  PARAM_ROTMINY = 12,
  PARAM_ROTMINZ = 13,
  PARAM_ROTMAXX = 14,
  PARAM_ROTMAXY = 15,
  PARAM_ROTMAXZ = 16,
  PARAM_SCALEMINX = 17,
  PARAM_SCALEMINY = 18,
  PARAM_SCALEMINZ = 19,
  PARAM_SCALEMAXX = 20,
  PARAM_SCALEMAXY = 21,
  PARAM_SCALEMAXZ = 22,
  PARAM_TRANSVALX = 23,
  PARAM_TRANSVALY = 24,
  PARAM_TRANSVALZ = 25,
  PARAM_ROTVALX = 26,
  PARAM_ROTVALY = 27,
  PARAM_ROTVALZ = 28,
  PARAM_SCALEVALX = 29,
  PARAM_SCALEVALY = 30,
  PARAM_SCALEVALZ = 31,
  CONTROL_PARAM_COUNT = 31
}
function InitializeCustomizationData(customizationData, _selectedCharacterClass)
  selectedCharacterClass = _selectedCharacterClass
  InitializePoseEditor(customizationData)
  initSculptingBoneTestUI()
end
function SetControlParameters(controlIdx, value)
  groups[selectedGroup].parts[selectedPart].controls[controlIdx].controlDetails[2]:SetText(value)
end
local clearEditor = function()
  local self = sculptingBoneSettingUI
  for _, v in pairs(self.StaticText) do
    v:SetShow(false)
    UI.deleteControl(v)
  end
  self.StaticText = {}
  for _, v in pairs(self.EditText) do
    v:SetShow(false)
    UI.deleteControl(v)
  end
  self.EditText = {}
end
function initSculptingBoneTestUI()
  clearEditor()
  local self = sculptingBoneSettingUI
  local controlSpanX = 20
  local controlSpanY = 105
  for index = 1, 11 do
    self.StaticText[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_CustomizationTest, "StaticText" .. index)
    CopyBaseProperty(StaticText_Control_Name, self.StaticText[index])
    self.StaticText[index]:SetShow(false)
    self.StaticText[index]:SetText(self.StaticText_String[index])
    if index == 9 then
      controlSpanY = controlSpanY + 20
    end
    self.StaticText[index]:SetSpanSize(controlSpanX, controlSpanY + 30 * (index - 1))
  end
  controlSpanX = 150
  controlSpanY = 112
  for index = 1, self.CONTROL_PARAM_COUNT do
    self.EditText[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_EDIT, Panel_CustomizationTest, "EditText" .. index)
    CopyBaseProperty(Edit_Control, self.EditText[index])
    self.EditText[index]:SetShow(false)
    self.EditText[index]:SetEditText("0")
    if index == 23 then
      controlSpanY = controlSpanY + 20
    end
    if index == 1 then
      self.EditText[index]:SetSpanSize(controlSpanX, controlSpanY)
    else
      self.EditText[index]:SetSpanSize(controlSpanX + (index - 2) % 3 * 35, controlSpanY + 30 + math.floor((index - 2) / 3) * 30)
    end
  end
  Panel_CustomizationTest:SetShow(false, false)
end
function SetShowCustomizationEditor(show)
  Panel_CustomizationTest:SetShow(show, false)
  local self = sculptingBoneSettingUI
  for index = 1, 11 do
    self.StaticText[index]:SetShow(show)
  end
  for index = 1, self.CONTROL_PARAM_COUNT do
    self.EditText[index]:SetShow(show)
  end
end
local function initSlider()
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
  if currentScale ~= nil then
    setValueSlider(Slider_ScaleX, currentScale.x, scaleMin.x, scaleMax.x)
    setValueSlider(Slider_ScaleY, currentScale.y, scaleMin.y, scaleMax.y)
    setValueSlider(Slider_ScaleZ, currentScale.z, scaleMin.z, scaleMax.z)
  end
end
function SelectSculptingBoneControl(customizationData)
  local self = sculptingBoneSettingUI
  local radius = customizationData:getSelectedBonePickRadius()
  self.EditText[1]:SetEditText(floatString(radius))
  EnableFaceSlide(true)
  local vector = {
    x,
    y,
    z
  }
  vector = customizationData:getSelectedBoneTranslationMin()
  self.EditText[5]:SetEditText(floatString(vector.x))
  self.EditText[6]:SetEditText(floatString(vector.y))
  self.EditText[7]:SetEditText(floatString(vector.z))
  vector = customizationData:getSelectedBoneTranslationMax()
  self.EditText[8]:SetEditText(floatString(vector.x))
  self.EditText[9]:SetEditText(floatString(vector.y))
  self.EditText[10]:SetEditText(floatString(vector.z))
  vector = customizationData:getSelectedBoneRotationMin()
  self.EditText[11]:SetEditText(floatString(vector.x))
  self.EditText[12]:SetEditText(floatString(vector.y))
  self.EditText[13]:SetEditText(floatString(vector.z))
  vector = customizationData:getSelectedBoneRotationMax()
  self.EditText[14]:SetEditText(floatString(vector.x))
  self.EditText[15]:SetEditText(floatString(vector.y))
  self.EditText[16]:SetEditText(floatString(vector.z))
  vector = customizationData:getSelectedBoneScaleMin()
  self.EditText[17]:SetEditText(floatString(vector.x))
  self.EditText[18]:SetEditText(floatString(vector.y))
  self.EditText[19]:SetEditText(floatString(vector.z))
  vector = customizationData:getSelectedBoneScaleMax()
  self.EditText[20]:SetEditText(floatString(vector.x))
  self.EditText[21]:SetEditText(floatString(vector.y))
  self.EditText[22]:SetEditText(floatString(vector.z))
  transMin = customizationData:getSelectedBoneTranslationMin()
  transMax = customizationData:getSelectedBoneTranslationMax()
  rotMin = customizationData:getSelectedBoneRotationMin()
  rotMax = customizationData:getSelectedBoneRotationMax()
  scaleMin = customizationData:getSelectedBoneScaleMin()
  scaleMax = customizationData:getSelectedBoneScaleMax()
  currentTranslation = customizationData:getSelectedBoneTranslationValue()
  currentRotation = customizationData:getSelectedBoneRotationValue()
  currentScale = customizationData:getSelectedBoneScaleValue()
  initSlider()
  CursorSelect(ControlMode)
  EnableCursor(false)
end
local function UpdateRadioButtons(updateControlMode)
  if updateControlMode == 1 then
    RadioButton_Bone_Trans:SetCheck(true)
    RadioButton_Bone_Rot:SetCheck(false)
    RadioButton_Bone_Scale:SetCheck(false)
  elseif updateControlMode == 2 then
    RadioButton_Bone_Trans:SetCheck(false)
    RadioButton_Bone_Rot:SetCheck(true)
    RadioButton_Bone_Scale:SetCheck(false)
  elseif updateControlMode == 3 then
    RadioButton_Bone_Trans:SetCheck(false)
    RadioButton_Bone_Rot:SetCheck(false)
    RadioButton_Bone_Scale:SetCheck(true)
  end
end
function floatString(floatValue)
  return string.format("%.2f", floatValue)
end
function resetControlParameters()
end
function saveControlParameters()
  saveSculptingBoneXml()
end
function AdjustSculptingBoneTranslation(translationX, translationY, translationZ)
  local self = sculptingBoneSettingUI
  self.EditText[23]:SetEditText(floatString(translationX))
  self.EditText[24]:SetEditText(floatString(translationY))
  self.EditText[25]:SetEditText(floatString(translationZ))
  setValueSlider(Slider_TransX, translationX, transMin.x, transMax.x)
  setValueSlider(Slider_TransY, translationY, transMin.y, transMax.y)
  setValueSlider(Slider_TransZ, translationZ, transMin.z, transMax.z)
  currentTranslation.x = translationX
  currentTranslation.y = translationY
  currentTranslation.z = translationZ
end
function AdjustSculptingBoneRotation(rotationX, rotationY, rotationZ)
  local self = sculptingBoneSettingUI
  self.EditText[26]:SetEditText(floatString(rotationX))
  self.EditText[27]:SetEditText(floatString(rotationY))
  self.EditText[28]:SetEditText(floatString(rotationZ))
  setValueSlider(Slider_RotX, rotationX, rotMin.x, rotMax.x)
  setValueSlider(Slider_RotY, rotationY, rotMin.y, rotMax.y)
  setValueSlider(Slider_RotZ, rotationZ, rotMin.z, rotMax.z)
  currentRotation.x = rotationX
  currentRotation.y = rotationY
  currentRotation.z = rotationZ
end
function AdjustSculptingBoneScale(scaleX, scaleY, scaleZ)
  local self = sculptingBoneSettingUI
  self.EditText[29]:SetEditText(floatString(scaleX))
  self.EditText[30]:SetEditText(floatString(scaleY))
  self.EditText[31]:SetEditText(floatString(scaleZ))
  setValueSlider(Slider_ScaleX, scaleX, scaleMin.x, scaleMax.x)
  setValueSlider(Slider_ScaleY, scaleY, scaleMin.y, scaleMax.y)
  setValueSlider(Slider_ScaleZ, scaleZ, scaleMin.z, scaleMax.z)
  currentScale.x = scaleX
  currentScale.y = scaleY
  currentScale.z = scaleZ
end
function RepositioningGroupUI(groupIndex, posX, posY)
end
function RepositionCursorUI(posX, posY)
end
function SelectTransformType(transformType)
  CursorSelect(transformType + 1)
  if ControlMode == 1 then
    RadioButton_Bone_Trans:SetCheck(true)
    RadioButton_Bone_Rot:SetCheck(false)
    RadioButton_Bone_Scale:SetCheck(false)
  elseif ControlMode == 2 then
    RadioButton_Bone_Trans:SetCheck(false)
    RadioButton_Bone_Rot:SetCheck(true)
    RadioButton_Bone_Scale:SetCheck(false)
  elseif ControlMode == 3 then
    RadioButton_Bone_Trans:SetCheck(false)
    RadioButton_Bone_Rot:SetCheck(false)
    RadioButton_Bone_Scale:SetCheck(true)
  end
end
function CursorSelect(luaControlModeIndex)
  ControlMode = luaControlModeIndex
  local transformTypeIndex = luaControlModeIndex - 1
  selectSculptingBoneTransformType(transformTypeIndex)
end
function EnableCursor(Enable)
end
function EnablePick(pickEnable)
  SetShowCustomizationDetails(pickEnable)
end
function SymmetryChecked()
  setSymmetryBoneTransform(CheckButton_Symmetry:IsCheck())
end
function ShowControlPart()
  showBoneControlPart(CheckButton_ControlPart:IsCheck())
end
function CloseBoneSculptingSelector()
  showBoneSculptingSelector(false)
  EnableCursor(false)
  selectCustomizationControlPart(-1)
end
function OpenFaceShapeUi(uiId)
  globalcurrentuiId = uiId
  currentuiId = uiId
  CameraLookEnable(false)
  startFacePickingMode()
  EnableFaceSlide(false)
  showBoneSculptingSelector(true)
end
function CloseFaceShapeUi()
  CameraLookEnable(true)
  endPickingMode().globalcurrentuiId = -2
  globalisCustomizationPicking = false
end
function showBoneSculptingSelector(show)
  Slider_TransX:SetControlPos(50)
  Slider_TransY:SetControlPos(50)
  Slider_TransZ:SetControlPos(50)
  Slider_RotX:SetControlPos(50)
  Slider_RotY:SetControlPos(50)
  Slider_RotZ:SetControlPos(50)
  Slider_ScaleX:SetControlPos(50)
  Slider_ScaleY:SetControlPos(50)
  Slider_ScaleZ:SetControlPos(50)
  if true == show then
    RadioButton_Bone_Trans:SetCheck(true)
    CursorSelect(1)
    RadioButton_Bone_Rot:SetCheck(false)
    RadioButton_Bone_Scale:SetCheck(false)
    updateGroupFrameControls(Panel_CustomizationTransform:GetSizeY(), Panel_CustomizationTransform)
  end
  EnableCursor(show)
  ShowControlPart()
  SymmetryChecked()
end
function showBoneDetailedController(show)
  StaticText_Symmetry:SetShow(show)
  StaticText_ControlPart:SetShow(show)
  Slider_TransX:SetShow(show)
  Slider_TransY:SetShow(show)
  Slider_TransZ:SetShow(show)
  StaticText_TransX:SetShow(show)
  StaticText_TransY:SetShow(show)
  StaticText_TransZ:SetShow(show)
  StaticText_RotX:SetShow(show)
  StaticText_RotY:SetShow(show)
  StaticText_RotZ:SetShow(show)
  StaticText_ScaleX:SetShow(show)
  StaticText_ScaleY:SetShow(show)
  StaticText_ScaleZ:SetShow(show)
  CheckButton_Camera:SetShow(show)
  CheckButton_Symmetry:SetShow(show)
  CheckButton_ControlPart:SetShow(show)
  Static_Symmetry:SetShow(show)
  Static_ControlPart:SetShow(show)
end
function calculateSliderValue(SliderControl, valueMin, valueMax)
  local ratio = SliderControl:GetControlPos()
  local val = valueMax - valueMin
  return ratio * val - (val - math.abs(valueMax))
end
function setValueSlider(SliderControl, value, valueMin, valueMax)
  local val = valueMax - valueMin
  if val ~= 0 then
    SliderControl:SetControlPos((value - valueMin) / val * 100)
  end
end
function UpdateSlider(updateControlMode)
  if ControlMode ~= updateControlMode then
    UpdateRadioButtons(updateControlMode)
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
  elseif updateControlMode == 2 then
    local x = calculateSliderValue(Slider_RotX, rotMin.x, rotMax.x)
    local y = calculateSliderValue(Slider_RotY, rotMin.y, rotMax.y)
    local z = calculateSliderValue(Slider_RotZ, rotMin.z, rotMax.z)
    currentRotation.x = x
    currentRotation.y = y
    currentRotation.z = z
    applyRotationValue(x, y, z)
  elseif updateControlMode == 3 then
    local x = calculateSliderValue(Slider_ScaleX, scaleMin.x, scaleMax.x)
    local y = calculateSliderValue(Slider_ScaleY, scaleMin.y, scaleMax.y)
    local z = calculateSliderValue(Slider_ScaleZ, scaleMin.z, scaleMax.z)
    currentScale.x = x
    currentScale.y = y
    currentScale.z = z
    applyScaleValue(x, y, z)
  end
end
function CheckCursorInSculptingUI()
  SculptingUIRect.left = Panel_CustomizationFrame:GetPosX()
  SculptingUIRect.top = Panel_CustomizationFrame:GetPosY()
  SculptingUIRect.right = SculptingUIRect.left + Panel_CustomizationFrame:GetSizeX()
  SculptingUIRect.bottom = SculptingUIRect.top + Panel_CustomizationFrame:GetSizeY()
  if getMousePosX() >= SculptingUIRect.left - mouseCursorRadius / 2 and getMousePosY() >= SculptingUIRect.top - mouseCursorRadius / 2 and getMousePosX() <= SculptingUIRect.right + mouseCursorRadius / 2 and getMousePosY() <= SculptingUIRect.bottom + mouseCursorRadius / 2 then
    EnableCursor(false)
  else
    EnableCursor(true)
  end
end
function EnableFaceSlide(enable)
  globalisCustomizationPicking = enable
  Button_Slider_TransX:SetMonoTone(not enable)
  Button_Slider_TransY:SetMonoTone(not enable)
  Button_Slider_TransZ:SetMonoTone(not enable)
  Button_Slider_RotX:SetMonoTone(not enable)
  Button_Slider_RotY:SetMonoTone(not enable)
  Button_Slider_RotZ:SetMonoTone(not enable)
  Button_Slider_ScaleX:SetMonoTone(not enable)
  Button_Slider_ScaleY:SetMonoTone(not enable)
  Button_Slider_ScaleZ:SetMonoTone(not enable)
  Slider_TransX:SetEnable(enable)
  Slider_TransY:SetEnable(enable)
  Slider_TransZ:SetEnable(enable)
  Slider_RotX:SetEnable(enable)
  Slider_RotY:SetEnable(enable)
  Slider_RotZ:SetEnable(enable)
  Slider_ScaleX:SetEnable(enable)
  Slider_ScaleY:SetEnable(enable)
  Slider_ScaleZ:SetEnable(enable)
  local color = Defines.Color.C_FF444444
  if enable then
    color = Defines.Color.C_FFFFFFFF
  end
  StaticText_TransX:SetFontColor(color)
  StaticText_TransY:SetFontColor(color)
  StaticText_TransZ:SetFontColor(color)
  StaticText_RotX:SetFontColor(color)
  StaticText_RotY:SetFontColor(color)
  StaticText_RotZ:SetFontColor(color)
  StaticText_ScaleX:SetFontColor(color)
  StaticText_ScaleY:SetFontColor(color)
  StaticText_ScaleZ:SetFontColor(color)
end
function SelectBoneDrag(bDrag)
  if true == bDrag then
    EnableCursor(false)
  else
    EnableCursor(true)
    add_CurrentHistory()
  end
end
function ApplyCharacterRotateForDebugging()
  setCharacterRotateSpeedForDebugging(tonumber(Edit_DebugRotControl:GetEditText()))
end
function FaceBoneHistoryApplyUpdate()
  if globalcurrentuiId ~= currentuiId then
    return
  end
  SelectSculptingBoneControl(ToClient_getCharacterCustomizationUiWrapper())
end

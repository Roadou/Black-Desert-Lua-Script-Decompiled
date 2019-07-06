local FrameTemplateColor = UI.getChildControl(Panel_CustomizationSkin, "Frame_Template_Color")
local SliderText = UI.getChildControl(Panel_CustomizationSkin, "StaticText_Slider_1")
local SliderControl = UI.getChildControl(Panel_CustomizationSkin, "Slider_R_Controller")
local Button_Slider = UI.getChildControl(SliderControl, "Slider_GammaController_Button")
local Static_Collision = UI.getChildControl(Panel_CustomizationSkin, "Static_Collision")
local Static_CurrentValue = UI.getChildControl(Panel_CustomizationSkin, "Static_Text_Slider_R_Left")
local sliderParamType = 0
local sliderParamIndex = 0
local sliderParam = 0
local sliderParamMin = 0
local sliderParamMax = 255
local sliderParamDefault = 0
if false == _ContentsGroup_RenewUI then
  registerEvent("EventOpenSkinUi", "OpenSkinUi")
  registerEvent("EventCloseSkinUi", "CloseSkinUi")
end
local selectedClassType, selectedUiId
local controlOffset = 10
local contentsStartY = 0
local sliderOffset = 7
local sliderValueOffset = 10
local sliderHeight = SliderText:GetSizeY()
local currentclassType = -1
local currentuiId = -1
function OpenSkinUi(classType, uiId)
  globalcurrentclassType = classType
  globalcurrentuiId = uiId
  currentclassType = classType
  currentuiId = uiId
  selectedClassType = classType
  selectedUiId = uiId
  contentsIndex = 0
  local controlPosY = contentsStartY
  local paletteCount = getUiPaletteCount(selectedClassType, selectedUiId, contentsIndex)
  if paletteCount == 1 then
    controlPosY = controlPosY + controlOffset
    local paletteParamType = getUiPaletteParamType(selectedClassType, selectedUiId, contentsIndex)
    local paletteParamIndex = getUiPaletteParamIndex(selectedClassType, selectedUiId, contentsIndex)
    local paletteIndex = getDecorationParamMethodValue(selectedClassType, paletteParamType, paletteParamIndex)
    FrameTemplateColor:SetPosY(controlPosY)
    CreateCommonPalette(FrameTemplateColor, Static_Collision, selectedClassType, paletteParamType, paletteParamIndex, paletteIndex, true)
    local colorIndex = getParam(paletteParamType, paletteParamIndex)
    UpdatePaletteMarkPosition(colorIndex)
    local Frame_Content_Color = UI.getChildControl(FrameTemplateColor, "Frame_Content")
    Static_SelectMark_Color = UI.getChildControl(Frame_Content_Color, "Static_SelectMark")
    Frame_Content_Color:SetChildIndex(Static_SelectMark_Color, 9999)
    controlPosY = controlPosY + FrameTemplateColor:GetSizeY() + controlOffset
  end
  local sliderCount = getUiSliderCount(selectedClassType, selectedUiId, contentsIndex)
  if sliderCount == 1 then
    local sliderIndex = 0
    sliderParamType = getUiSliderParamType(selectedClassType, selectedUiId, contentsIndex, sliderIndex)
    sliderParamIndex = getUiSliderParamIndex(selectedClassType, selectedUiId, contentsIndex, sliderIndex)
    local sliderParam = getParam(sliderParamType, sliderParamIndex)
    sliderParamMin = getParamMin(selectedClassType, sliderParamType, sliderParamIndex)
    sliderParamMax = getParamMax(selectedClassType, sliderParamType, sliderParamIndex)
    sliderParamDefault = getParamDefault(selectedClassType, sliderParamType, sliderParamIndex)
    setSliderValue(SliderControl, sliderParam, sliderParamMin, sliderParamMax)
    SliderControl:addInputEvent("Mouse_LPress", "UpdateSkinSlider()")
    Button_Slider:addInputEvent("Mouse_LPress", "UpdateSkinSlider()")
    Button_Slider:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
    SliderControl:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
    local sliderDesc = getUiSliderDescName(selectedClassType, selectedUiId, contentsIndex, sliderIndex)
    SliderText:SetText(PAGetString(Defines.StringSheet_GAME, sliderDesc))
    SliderText:SetPosY(controlPosY)
    SliderText:SetShow(true)
    SliderControl:SetPosY(controlPosY + sliderOffset)
    SliderControl:SetShow(true)
    Static_CurrentValue:SetText(sliderParam)
    Static_CurrentValue:SetPosY(controlPosY + sliderValueOffset)
    Static_CurrentValue:SetShow(true)
    controlPosY = controlPosY + sliderHeight
  end
  Panel_CustomizationSkin:SetSize(Panel_CustomizationSkin:GetSizeX(), controlPosY + controlOffset)
  updateGroupFrameControls(Panel_CustomizationSkin:GetSizeY(), Panel_CustomizationSkin)
  Panel_CustomizationSkin:SetShow(true)
  FrameTemplateColor:UpdateContentScroll()
  FrameTemplateColor:UpdateContentPos()
end
function CloseSkinUi()
  globalcurrentclassType = -2
  globalcurrentuiId = -2
end
function UpdateSkinSlider()
  local value = getSliderValue(SliderControl, sliderParamMin, sliderParamMax)
  setParam(selectedClassType, sliderParamType, sliderParamIndex, value)
  Static_CurrentValue:SetText(value)
  setGlobalCheck(true)
end
function SkinHistoryApplyUpdate()
  if globalcurrentclassType ~= currentclassType or globalcurrentuiId ~= currentuiId then
    return
  end
  OpenSkinUi(currentclassType, currentuiId)
end

Panel_Customizing_CommonDecoration:ignorePadSnapMoveToOtherPanel()
local Customization_DecoInfo = {
  _ui = {
    _static_TabGroup = UI.getChildControl(Panel_Customizing_CommonDecoration, "Static_TabGroup"),
    _static_ButtonGroup = UI.getChildControl(Panel_Customizing_CommonDecoration, "Static_ButtonGroup"),
    _static_EyeDecoGroup = UI.getChildControl(Panel_Customizing_CommonDecoration, "Static_EyeDecoGroup"),
    _static_TypeGroup = UI.getChildControl(Panel_Customizing_CommonDecoration, "Static_TypeGroup"),
    _static_SliderGroup = UI.getChildControl(Panel_Customizing_CommonDecoration, "Static_SliderGroup"),
    _static_ColorGroup = UI.getChildControl(Panel_Customizing_CommonDecoration, "Static_ColorGroup"),
    _static_KeyGuideGroup = UI.getChildControl(Panel_Customizing_CommonDecoration, "Static_KeyGuideBg")
  },
  _config = {
    _buttonColumnCount = 6,
    _listTextureColumnCount = 4,
    _listColumnCount = 5,
    _imageFrameSizeY = 125,
    _listOffset = 10,
    _listColumnWidth,
    _listColumnHeight,
    _sliderOffset = 7,
    _sliderValueOffset = 10
  },
  _currentClassType,
  _currentUiId,
  _currentCheckType,
  _currentContentIndex,
  _buttonList = {},
  _typeList = {},
  _sliderControlList = {},
  _sliderButtonList = {},
  _sliderTitle = {},
  _sliderValue = {},
  _sliderParamType = {},
  _sliderParamIndex = {},
  _sliderParamIndex2 = {},
  _sliderParam = {},
  _sliderParamMin = {},
  _sliderParamMax = {},
  _sliderParamDefault = {},
  _selectedListParamType,
  _selectedListParamIndex,
  _selectedItemIndex,
  _isTattooMode = false,
  _currentSliderCount,
  _currentButtonCount = 0,
  _currentTypeCount,
  _isExpression = false,
  _isBoneControl = false,
  _currentTabIdx = 0,
  _currentTabCount = 0,
  _leftEyeToggle = true,
  _rightEyeToggle = true
}
function Customization_DecoInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function Customization_DecoInfo:InitControl()
  self._ui.txt_LBConsoleUI = UI.getChildControl(self._ui._static_TabGroup, "StaticText_LB_ConsoleUI")
  self._ui.txt_RBConsoleUI = UI.getChildControl(self._ui._static_TabGroup, "StaticText_RB_ConsoleUI")
  self._ui._checkBox_LeftEye = UI.getChildControl(self._ui._static_EyeDecoGroup, "CheckButton_Left")
  self._ui._checkBox_RightEye = UI.getChildControl(self._ui._static_EyeDecoGroup, "CheckButton_Right")
  self._ui._checkBox_LeftEye:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONEYE_EYELEFT"))
  self._ui._checkBox_RightEye:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONEYE_EYERIGHT"))
  self._ui._buttonTemplate = UI.getChildControl(self._ui._static_ButtonGroup, "Radiobutton_Tamplate")
  self._ui._buttonTemplate:SetShow(false)
  self._ui._typeTemplate = UI.getChildControl(self._ui._static_TypeGroup, "RadioButton_TypeImage_Template")
  self._ui._typeTemplate:SetShow(false)
  self._ui._typeSelect = UI.getChildControl(self._ui._static_TypeGroup, "Static_SelectedSlot")
  self._ui._typeSelect:SetShow(false)
  self._ui._static_TypeGroup:SetChildIndex(self._ui._typeSelect, 9999)
  self._ui._colorTemplate = UI.getChildControl(self._ui._static_ColorGroup, "Button_ColorTemplate")
  self._ui._colorTemplate:SetShow(false)
  self._ui._colorSelect = UI.getChildControl(self._ui._static_ColorGroup, "Static_SelectedColor")
  self._ui._static_ColorGroup:SetChildIndex(self._ui._colorSelect, 9999)
  self._ui._colorSelect:SetShow(false)
  self._ui._static_SliderBg = {}
  self._ui._staticText_SliderTitle = {}
  self._ui._staticText_SliderValue = {}
  self._ui._slider = {}
  self._ui._sliderButton = {}
  self._ui._sliderProgress = {}
  for index = 0, 6 do
    self._ui._static_SliderBg[index] = UI.getChildControl(self._ui._static_SliderGroup, "Static_SliderBg_" .. index)
    self._ui._staticText_SliderTitle[index] = UI.getChildControl(self._ui._static_SliderBg[index], "StaticText_Title")
    self._ui._staticText_SliderValue[index] = UI.getChildControl(self._ui._static_SliderBg[index], "StaticText_SliderValue")
    self._ui._slider[index] = UI.getChildControl(self._ui._static_SliderBg[index], "Slider_" .. index)
    self._ui._sliderButton[index] = UI.getChildControl(self._ui._slider[index], "Slider_DisplayButton")
    self._ui._sliderProgress[index] = UI.getChildControl(self._ui._slider[index], "Progress2_1")
  end
  self._config._listColumnWidth = self._ui._typeTemplate:GetSizeX() + self._config._listOffset
  self._config._listColumnHeight = self._ui._typeTemplate:GetSizeY() + self._config._listOffset
end
function Customization_DecoInfo:InitEvent()
  Panel_Customizing_CommonDecoration:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_Customization_Deco_MoveTab(true)")
  Panel_Customizing_CommonDecoration:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobalFunc_Customization_Deco_MoveTab(false)")
  self._ui._checkBox_LeftEye:registerPadEvent(__eConsoleUIPadEvent_A, "PaGlobalFunc_Customization_Deco_setLeftEyeDecoSlider()")
  self._ui._checkBox_RightEye:registerPadEvent(__eConsoleUIPadEvent_A, "PaGlobalFunc_Customization_Deco_setRightEyeDecoSlider()")
end
function Customization_DecoInfo:InitRegister()
  registerEvent("EventOpenCommonDecorationUi", "PaGlobalFunc_Customization_Deco_OpenCommonDecorationUi")
  registerEvent("EventCloseCommonDecorationUi", "PaGlobalFunc_Customization_Deco_CloseCommonDecorationUi")
  registerEvent("EventOpenEyeDecorationUi", "PaGlobalFunc_Customization_Deco_OpenEyeDecorationUi")
  registerEvent("EventCloseEyeDecorationUi", "PaGlobalFunc_Customization_Deco_CloseEyeDecorationUi")
  registerEvent("EventOpenTattooDecorationUi", "PaGlobalFunc_Customization_Deco_OpenTattooDecorationUi")
  registerEvent("EventCloseTattooDecorationUi", "PaGlobalFunc_Customization_Deco_CloseTattooDecorationUi")
  registerEvent("EventEnableDecorationSlide", "PaGlobalFunc_Customization_Deco_EnableDecorationSlide")
  registerEvent("EventOpenCommonExpressionUi", "PaGlobalFunc_Customization_Deco_OpenCommonExpressionUi")
  registerEvent("EventCloseCommonExpressionUi", "PaGlobalFunc_Customization_Deco_CloseCommonExpressionUi")
end
function Customization_DecoInfo:ClearRadioButton()
  for _, control in pairs(self._buttonList) do
    if nil ~= control then
      control:SetShow(false)
    end
  end
end
function Customization_DecoInfo:ClearType()
  for index = 0, 6 do
    self._ui._staticText_SliderTitle[index]:SetShow(false)
    self._ui._staticText_SliderValue[index]:SetShow(false)
    self._ui._slider[index]:SetShow(false)
    self._ui._sliderButton[index]:SetShow(false)
  end
  for _, control in pairs(self._typeList) do
    if nil ~= control then
      control:SetShow(false)
    end
  end
end
function Customization_DecoInfo:UpdateTypeFocus(itemIndex)
  local item = self._typeList[itemIndex]
  if nil == item then
    return
  end
  self._ui._typeSelect:SetShow(true)
  self._ui._typeSelect:SetPosX(item:GetPosX())
  self._ui._typeSelect:SetPosY(item:GetPosY())
  self._selectedItemIndex = itemIndex
  PaGlobalFunc_Customization_Deco_SetSelectButton(itemIndex)
end
function Customization_DecoInfo:UpdateDecorationList()
  setParam(self._currentClassType, self._selectedListParamType, self._selectedListParamIndex, self._selectedItemIndex)
  self:UpdateTypeFocus(self._selectedItemIndex)
end
function PaGlobalFunc_Customization_Deco_UpdateDecorationPose()
  local self = Customization_DecoInfo
  setParam(self._currentClassType, self._selectedListParamType, self._selectedListParamIndex, self._selectedItemIndex)
  self:UpdateTypeFocus(self._selectedItemIndex)
end
function PaGlobalFunc_Customization_Deco_SetSelectButton(itemIndex)
  local self = Customization_DecoInfo
  if true == self._isExpression then
    return
  end
  if self._selectedItemIndex == itemIndex then
    PaGlobalFunc_Customization_SetKeyGuide(6)
  else
    PaGlobalFunc_Customization_SetKeyGuide(7)
  end
end
function PaGlobalFunc_Customization_Deco_UpdateType(paramType, paramIndex, itemIndex)
  local self = Customization_DecoInfo
  self._selectedListParamType = paramType
  self._selectedListParamIndex = paramIndex
  self._selectedItemIndex = itemIndex
  if 4 == paramType then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLY_EXPRESSION")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = PaGlobalFunc_Customization_Deco_UpdateDecorationPose,
      functionNo = PaGlobalFunc_Customization_Deco_CancelDecorationPose,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "top")
    PaGlobalFunc_Customization_SetKeyGuide(-1)
    return
  end
  if self._isTattooMode then
    slideEnable = getEnableTattooSlide(self._currentClassType, self._selectedListParamType, self._selectedListParamIndex, self._selectedItemIndex)
    PaGlobalFunc_Customization_Deco_EnableDecorationSlide(slideEnable)
  end
  self:UpdateDecorationList()
end
function PaGlobalFunc_Customization_Deco_CancelDecorationPose()
  PaGlobalFunc_Customization_SetKeyGuide(7)
end
function PaGlobalFunc_Customization_Deco_UpdateDecorationPose()
  local self = Customization_DecoInfo
  setParam(self._currentClassType, self._selectedListParamType, self._selectedListParamIndex, self._selectedItemIndex)
  self:UpdateTypeFocus(self._selectedItemIndex)
  PaGlobalFunc_Customization_SetKeyGuide(7)
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  Panel_Win_System:SetShow(false)
end
function PaGlobalFunc_Customization_Deco_UpdateDecorationContents(contentsIndex, currentClassType, currentuiId)
  local self = Customization_DecoInfo
  self:ClearType()
  self._ui._static_TypeGroup:SetShow(true)
  self._ui._static_SliderGroup:SetShow(true)
  self._ui._static_ColorGroup:SetShow(true)
  self._currentContentIndex = contentsIndex
  local NoCashType = CppEnums.CustomizationNoCashType
  local NoCashDeco = CppEnums.CustomizationNoCashDeco
  if nil ~= currentclassType then
    self._currentClassType = currentClassType
  end
  if nil ~= currentuiId then
    self._currentUiId = currentuiId
  end
  local texSize = 48.25
  local listCount = getUiListCount(self._currentClassType, self._currentUiId, contentsIndex)
  if listCount == 1 then
    local listIndex = 0
    local listTexture = getUiListTextureName(self._currentClassType, self._currentUiId, contentsIndex, listIndex)
    local listParamType = getUiListParamType(self._currentClassType, self._currentUiId, contentsIndex, listIndex)
    local listParamIndex = getUiListParamIndex(self._currentClassType, self._currentUiId, contentsIndex, listIndex)
    local paramMax = getParamMax(self._currentClassType, listParamType, listParamIndex)
    if true == self._isExpression then
      paramMax = getExpressionCount(self._currentClassType) - 1
    end
    self._currentTypeCount = paramMax
    for itemIndex = 0, paramMax do
      local tempContentImage = self._typeList[itemIndex]
      if nil == tempContentImage then
        tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_TypeGroup, "Frame_Image_" .. itemIndex .. "_" .. self._currentUiId)
        CopyBaseProperty(self._ui._typeTemplate, tempContentImage)
      end
      tempContentImage:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_Deco_UpdateType(" .. listParamType .. "," .. listParamIndex .. "," .. itemIndex .. ")")
      tempContentImage:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_Deco_SetSelectButton(" .. itemIndex .. ")")
      local mod = itemIndex % self._config._listTextureColumnCount
      local divi = math.floor(itemIndex / self._config._listTextureColumnCount)
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
      tempContentImage:ChangeTextureInfoName(listTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(tempContentImage, texUV.x1, texUV.y1, texUV.x2, texUV.y2)
      tempContentImage:getBaseTexture():setUV(x1, y1, x2, y2)
      tempContentImage:SetPosX(itemIndex % self._config._listColumnCount * self._config._listColumnWidth + 10)
      tempContentImage:SetPosY(math.floor(itemIndex / self._config._listColumnCount) * self._config._listColumnHeight + 10)
      tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
      tempContentImage:SetShow(true)
      self._typeList[itemIndex] = tempContentImage
    end
    local param = getParam(listParamType, listParamIndex)
    self._selectedListParamType = listParamType
    self._selectedListParamIndex = listParamIndex
    self._selectedItemIndex = param
  else
    self._ui._static_TypeGroup:SetShow(false)
  end
  if listCount > 0 then
    self:UpdateDecorationList()
  end
  local sliderCount = getUiSliderCount(self._currentClassType, self._currentUiId, contentsIndex)
  local sliderValueBasePosX = 0
  self._currentSliderCount = sliderCount
  if 0 == sliderCount then
    self._ui._static_SliderGroup:SetShow(false)
  end
  for sliderIndex = 0, sliderCount - 1 do
    self._sliderParamType[sliderIndex] = getUiSliderParamType(self._currentClassType, self._currentUiId, contentsIndex, sliderIndex)
    self._sliderParamIndex[sliderIndex] = getUiSliderParamIndex(self._currentClassType, self._currentUiId, contentsIndex, sliderIndex)
    local sliderParam = getParam(self._sliderParamType[sliderIndex], self._sliderParamIndex[sliderIndex])
    self._sliderParamMin[sliderIndex] = getParamMin(self._currentClassType, self._sliderParamType[sliderIndex], self._sliderParamIndex[sliderIndex])
    self._sliderParamMax[sliderIndex] = getParamMax(self._currentClassType, self._sliderParamType[sliderIndex], self._sliderParamIndex[sliderIndex])
    self._sliderParamDefault[sliderIndex] = getParamDefault(self._currentClassType, self._sliderParamType[sliderIndex], self._sliderParamIndex[sliderIndex])
    PaGlobalFunc_CustomIzationCommon_SetSliderValue(self._ui._slider[sliderIndex], sliderParam, self._sliderParamMin[sliderIndex], self._sliderParamMax[sliderIndex])
    self._ui._slider[sliderIndex]:addInputEvent("Mouse_LPress", "PaGlobalFunc_Customization_Deco_UpdateSlider(" .. sliderIndex .. ")")
    self._ui._slider[sliderIndex]:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_Deco_SliderFocusOn()")
    self._ui._slider[sliderIndex]:addInputEvent("Mouse_Out", "PaGlobalFunc_Customization_Deco_SliderFocusOut()")
    local sliderDesc = getUiSliderDescName(self._currentClassType, self._currentUiId, contentsIndex, sliderIndex)
    self._ui._staticText_SliderTitle[sliderIndex]:SetText(PAGetString(Defines.StringSheet_GAME, sliderDesc))
    self._ui._staticText_SliderTitle[sliderIndex]:SetShow(true)
    self._ui._slider[sliderIndex]:SetShow(true)
    self._ui._sliderButton[sliderIndex]:SetShow(true)
    self._ui._staticText_SliderValue[sliderIndex]:SetText(sliderParam)
    self._ui._staticText_SliderValue[sliderIndex]:SetShow(true)
    PaGlobalFunc_Customization_Deco_UpdateSlider(sliderIndex)
    if nil == ToClient_getGameOptionControllerWrapper() or 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() then
    else
    end
  end
  local paletteCount = getUiPaletteCount(self._currentClassType, self._currentUiId, contentsIndex)
  if paletteCount == 1 then
    local paletteParamType = getUiPaletteParamType(self._currentClassType, self._currentUiId, contentsIndex)
    local paletteParamIndex = getUiPaletteParamIndex(self._currentClassType, self._currentUiId, contentsIndex)
    local paletteIndex = getDecorationParamMethodValue(self._currentClassType, paletteParamType, paletteParamIndex)
    PaGlobalFunc_Customization_PaletteHandle_CreateCommonPalette(self._ui._colorTemplate, self._ui._static_ColorGroup, self._ui._colorSelect, self._currentClassType, paletteParamType, paletteParamIndex, paletteIndex)
    local colorIndex = getParam(paletteParamType, paletteParamIndex)
    PaGlobalFunc_Customization_PaletteHandle_UpdateFocusBox(colorIndex)
  else
    self._ui._static_ColorGroup:SetShow(false)
    PaGlobalFunc_Customization_PaletteHandle_ClearPalette()
  end
  self:UpdatePanelSize()
  ToClient_padSnapRefreshTarget(Panel_Customizing_CommonDecoration)
end
function Customization_DecoInfo:UpdatePanelSize()
  local buttonGroup = self._ui._static_ButtonGroup
  local eyeGroup = self._ui._static_EyeDecoGroup
  local typeGroup = self._ui._static_TypeGroup
  local sliderGroup = self._ui._static_SliderGroup
  local colorGroup = self._ui._static_ColorGroup
  local VerticalCount, sizeY
  buttonGroup:SetPosY(20)
  local buttonCount = self._currentButtonCount
  VerticalCount = Int64toInt32(buttonCount / self._config._buttonColumnCount + 1)
  sizeY = VerticalCount * (self._ui._buttonTemplate:GetSizeY() + 5)
  buttonGroup:SetSize(buttonGroup:GetSizeX(), sizeY - 10)
  if false == eyeGroup:GetShow() then
    typeGroup:SetPosY(20)
    sliderGroup:SetPosY(20)
    colorGroup:SetPosY(20)
  else
    typeGroup:SetPosY(125)
    sliderGroup:SetPosY(125)
    colorGroup:SetPosY(125)
  end
  if true == typeGroup:GetShow() then
    local typeCount = self._currentTypeCount + 1
    VerticalCount = Int64toInt32(typeCount / self._config._listColumnCount + 1)
    sizeY = VerticalCount * self._config._listColumnWidth
    if 0 == typeCount % self._config._listColumnCount then
      sizeY = (VerticalCount - 1) * self._config._listColumnWidth
    end
    typeGroup:SetSize(typeGroup:GetSizeX(), sizeY + 10)
  end
  if true == typeGroup:GetShow() then
    sliderGroup:SetPosY(typeGroup:GetPosY() + typeGroup:GetSizeY())
  end
  local sliderCount = self._currentSliderCount
  sliderGroup:SetSize(sliderGroup:GetSizeX(), sliderCount * 30)
  colorGroup:SetPosY(sliderGroup:GetPosY() + sliderGroup:GetSizeY() + 20)
  if true == colorGroup:GetShow() then
    Panel_Customizing_CommonDecoration:SetSize(Panel_Customizing_CommonDecoration:GetSizeX(), colorGroup:GetPosY() + colorGroup:GetSizeY())
  else
    Panel_Customizing_CommonDecoration:SetSize(Panel_Customizing_CommonDecoration:GetSizeX(), sliderGroup:GetPosY() + sliderGroup:GetSizeY() + 20)
  end
  self._ui._static_KeyGuideGroup:SetPosY(Panel_Customizing_CommonDecoration:GetPosY() + Panel_Customizing_CommonDecoration:GetSizeY() - 50)
end
function PaGlobalFunc_Customization_Deco_OpenCommonDecorationUi(classType, uiId, checkType)
  local self = Customization_DecoInfo
  self._currentClassType = classType
  self._currentUiId = uiId
  self._currentCheckType = checkType
  self:ClearRadioButton()
  self._ui._checkBox_LeftEye:SetShow(false)
  self._ui._checkBox_RightEye:SetShow(false)
  self._ui._static_EyeDecoGroup:SetShow(false)
  local contentsCount = getUiContentsCount(classType, uiId)
  self._currentTabCount = contentsCount
  if contentsCount > 1 then
    self._ui._static_TabGroup:SetShow(true)
    local panelSizeX = Panel_Customizing_CommonDecoration:GetSizeX()
    local keyGuideSize = 42
    panelSizeX = panelSizeX - keyGuideSize * 2
    local iconSortPos = panelSizeX / (contentsCount + 1)
    for contentsIndex = 0, contentsCount - 1 do
      local tempRadioButton = self._buttonList[contentsIndex]
      if nil == tempRadioButton then
        tempRadioButton = UI.createAndCopyBasePropertyControl(self._ui._static_TabGroup, "RadioButton_Template", self._ui._static_TabGroup, "RadioButton_" .. contentsIndex)
      end
      local contentsDesc = getUiContentsDescName(classType, uiId, contentsIndex)
      PaGlobalFunc_Customization_Deco_GetIconUV(contentsDesc, tempRadioButton)
      tempRadioButton:SetPosX(iconSortPos * (contentsIndex + 1) - tempRadioButton:GetSizeX() / 2 + keyGuideSize)
      tempRadioButton:SetCheck(false)
      tempRadioButton:SetShow(true)
      self._buttonList[contentsIndex] = tempRadioButton
    end
    self._ui._static_ButtonGroup:SetShow(true)
    self._buttonList[0]:SetCheck(true)
  else
    self._ui._static_ButtonGroup:SetShow(false)
    self._ui._static_TabGroup:SetShow(false)
  end
  self._currentButtonCount = contentsCount - 1
  PaGlobalFunc_Customization_Deco_UpdateDecorationContents(0)
  PaGlobalFunc_Customization_Deco_Open()
end
function PaGlobalFunc_Customization_Deco_CloseCommonDecorationUi()
  PaGlobalFunc_Customization_PaletteHandle_ClearPalette()
  PaGlobalFunc_Customization_Deco_Close()
end
function PaGlobalFunc_Customization_Deco_OpenEyeDecorationUi(classType, uiId)
  local self = Customization_DecoInfo
  self._isExpression = false
  self._currentClassType = classType
  self._currentUiId = uiId
  self:ClearRadioButton()
  local isShai = getSelfPlayer():getClassType() == CppEnums.ClassType.ClassType_ShyWomen
  self._ui._checkBox_LeftEye:SetIgnore(isShai)
  self._ui._checkBox_RightEye:SetIgnore(isShai)
  self._ui._checkBox_LeftEye:SetMonoTone(isShai)
  self._ui._checkBox_RightEye:SetMonoTone(isShai)
  self._ui._checkBox_LeftEye:SetShow(true)
  self._ui._checkBox_RightEye:SetShow(true)
  self._ui._checkBox_LeftEye:SetCheck(true)
  self._ui._checkBox_RightEye:SetCheck(true)
  self._ui._static_EyeDecoGroup:SetShow(true)
  local contentsCount = getUiContentsCount(classType, uiId) / 2
  self._currentTabCount = contentsCount
  if contentsCount > 1 then
    self._ui._static_TabGroup:SetShow(true)
    local panelSizeX = Panel_Customizing_CommonDecoration:GetSizeX()
    local keyGuideSize = 42
    panelSizeX = panelSizeX - keyGuideSize * 2
    local iconSortPos = panelSizeX / (contentsCount + 1)
    for contentsIndex = 0, contentsCount - 1 do
      local tempRadioButton = self._buttonList[contentsIndex]
      if nil == tempRadioButton then
        tempRadioButton = UI.createAndCopyBasePropertyControl(self._ui._static_TabGroup, "RadioButton_Template", self._ui._static_TabGroup, "RadioButton_" .. contentsIndex)
      end
      local contentsDesc = getUiContentsDescName(classType, uiId, contentsIndex)
      PaGlobalFunc_Customization_Deco_GetIconUV(contentsDesc, tempRadioButton)
      tempRadioButton:SetPosX(iconSortPos * (contentsIndex + 1) - tempRadioButton:GetSizeX() / 2 + keyGuideSize)
      tempRadioButton:SetCheck(false)
      tempRadioButton:SetShow(true)
      self._buttonList[contentsIndex] = tempRadioButton
    end
    self._ui._static_ButtonGroup:SetShow(true)
    self._buttonList[0]:SetCheck(true)
  else
    self._ui._static_ButtonGroup:SetShow(false)
    self._ui._static_TabGroup:SetShow(false)
  end
  self._currentButtonCount = contentsCount - 1
  PaGlobalFunc_Customization_Deco_UpdateEyeDecoContents(0, 0)
  PaGlobalFunc_Customization_Deco_Open()
end
function PaGlobalFunc_Customization_Deco_CloseEyeDecorationUi()
  PaGlobalFunc_Customization_PaletteHandle_ClearPalette()
  PaGlobalFunc_Customization_Deco_Close()
end
function PaGlobalFunc_Customization_Deco_GetIconUV(contentsDesc, control)
  if nil == control then
    return
  end
  local baseX1, baseY1, baseX2, baseY2, onX1, onY1, onX2, onY2
  control:ChangeTextureInfoName("Renewal/Button/Console_TapBtn_01.dds")
  if "XML_CUSTOMIZATION_EYELASH" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 102, 352, 150, 400)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 102, 302, 150, 350)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_EYELINE" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 52, 352, 100, 400)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 52, 302, 100, 350)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_UNDERLINE" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 2, 352, 50, 400)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 2, 302, 50, 350)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_PUPIL" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 202, 352, 250, 400)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 202, 302, 250, 350)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_IRIS" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 152, 352, 200, 400)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 152, 302, 200, 350)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_LENS" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 252, 352, 300, 400)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 252, 302, 300, 350)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_EYE_MAKEUP" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 302, 252, 350, 300)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 302, 202, 350, 250)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_LIP" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 452, 252, 500, 300)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 452, 202, 500, 250)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_EYEBROW" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 52, 452, 100, 500)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 52, 402, 100, 450)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_BASE_EYEBROW" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 2, 452, 50, 500)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 2, 402, 50, 450)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_SIDEBURNS" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 452, 352, 500, 400)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 452, 302, 500, 350)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_MUSTACHE" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 402, 352, 450, 400)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 402, 302, 450, 350)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_BEARD" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 302, 352, 350, 400)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 302, 302, 350, 350)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_BASE_BEARD" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 352, 352, 400, 400)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 352, 302, 400, 350)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_CHEEKTOUCH" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 402, 252, 450, 300)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 402, 202, 450, 250)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_BASE" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 202, 252, 250, 300)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 202, 202, 250, 250)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_HAIR_END" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 252, 252, 300, 300)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 252, 202, 300, 250)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_IN_HAIR" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 152, 252, 200, 300)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 152, 202, 200, 250)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  elseif "XML_CUSTOMIZATION_DESIGN" == contentsDesc then
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 402, 252, 450, 300)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 402, 202, 450, 250)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  else
    baseX1, baseY1, baseX2, baseY2 = setTextureUV_Func(control, 0, 0, 1, 1)
    control:getBaseTexture():setUV(baseX1, baseY1, baseX2, baseY2)
    onX1, onY1, onX2, onY2 = setTextureUV_Func(control, 0, 0, 1, 1)
    control:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    control:getClickTexture():setUV(onX1, onY1, onX2, onY2)
  end
  control:setRenderTexture(control:getBaseTexture())
end
function PaGlobalFunc_Customization_Deco_UpdateEyeDecoContents(contentsIndex, addHistory, currentclassType, currentuiId)
  local self = Customization_DecoInfo
  self._ui._static_TypeGroup:SetShow(true)
  self._ui._static_SliderGroup:SetShow(true)
  self._ui._static_ColorGroup:SetShow(true)
  self:ClearType()
  self._currentContentIndex = contentsIndex
  if nil ~= currentclassType then
    self._currentClassType = currentclassType
  end
  if nil ~= currentuiId then
    self._currentUiId = currentuiId
  end
  local texSize = 48.25
  local listCount = getUiListCount(self._currentClassType, self._currentUiId, contentsIndex)
  if listCount == 1 then
    local listIndex = 0
    local listTexture = getUiListTextureName(self._currentClassType, self._currentUiId, contentsIndex, listIndex)
    local listParamType = getUiListParamType(self._currentClassType, self._currentUiId, contentsIndex, listIndex)
    local listParamIndex = getUiListParamIndex(self._currentClassType, self._currentUiId, contentsIndex, listIndex)
    local listParamIndex2 = getUiListParamIndex(self._currentClassType, self._currentUiId, contentsIndex + 3, listIndex)
    local paramMax = getParamMax(self._currentClassType, listParamType, listParamIndex)
    for itemIndex = 0, paramMax do
      local tempContentImage = self._typeList[itemIndex]
      if nil == tempContentImage then
        tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_TypeGroup, "Frame_Image_" .. itemIndex)
        CopyBaseProperty(self._ui._typeTemplate, tempContentImage)
      end
      tempContentImage:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_Deco_UpdateEyeDecoList(" .. listParamType .. "," .. listParamIndex .. "," .. listParamIndex2 .. "," .. itemIndex .. ")")
      tempContentImage:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_Deco_SetSelectButton(" .. itemIndex .. ")")
      local mod = itemIndex % self._config._listTextureColumnCount
      local divi = math.floor(itemIndex / self._config._listTextureColumnCount)
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
      tempContentImage:ChangeTextureInfoName(listTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(tempContentImage, texUV.x1, texUV.y1, texUV.x2, texUV.y2)
      tempContentImage:getBaseTexture():setUV(x1, y1, x2, y2)
      tempContentImage:SetPosX(itemIndex % self._config._listColumnCount * self._config._listColumnWidth + 10)
      tempContentImage:SetPosY(math.floor(itemIndex / self._config._listColumnCount) * self._config._listColumnHeight + 10)
      tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
      tempContentImage:SetShow(true)
      self._typeList[itemIndex] = tempContentImage
    end
    ToClient_padSnapRefreshTarget(Panel_Customizing_CommonDecoration)
    local param = getParam(listParamType, listParamIndex)
    self:UpdateTypeFocus(param)
    self._currentTypeCount = paramMax
  else
    self._ui._static_TypeGroup:SetShow(false)
  end
  local sliderCount = getUiSliderCount(self._currentClassType, self._currentUiId, contentsIndex)
  self._currentSliderCount = sliderCount
  if 0 == sliderCount then
    self._ui._static_SliderGroup:SetShow(false)
  end
  for sliderIndex = 0, sliderCount - 1 do
    self._sliderParamType[sliderIndex] = getUiSliderParamType(self._currentClassType, self._currentUiId, contentsIndex, sliderIndex)
    self._sliderParamIndex[sliderIndex] = getUiSliderParamIndex(self._currentClassType, self._currentUiId, contentsIndex, sliderIndex)
    self._sliderParamIndex2[sliderIndex] = getUiSliderParamIndex(self._currentClassType, self._currentUiId, contentsIndex + 3, sliderIndex)
    local sliderParam = getParam(self._sliderParamType[sliderIndex], self._sliderParamIndex[sliderIndex])
    self._sliderParamMin[sliderIndex] = getParamMin(self._currentClassType, self._sliderParamType[sliderIndex], self._sliderParamIndex[sliderIndex])
    self._sliderParamMax[sliderIndex] = getParamMax(self._currentClassType, self._sliderParamType[sliderIndex], self._sliderParamIndex[sliderIndex])
    self._sliderParamDefault[sliderIndex] = getParamDefault(self._currentClassType, self._sliderParamType[sliderIndex], self._sliderParamIndex[sliderIndex])
    self._leftEyeToggle = true
    self._rightEyeToggle = true
    PaGlobalFunc_CustomIzationCommon_SetSliderValue(self._ui._slider[sliderIndex], sliderParam, self._sliderParamMin[sliderIndex], self._sliderParamMax[sliderIndex])
    self._ui._slider[sliderIndex]:addInputEvent("Mouse_LPress", "PaGlobalFunc_Customization_Deco_UpdateEyeDecoSlider(" .. sliderIndex .. ")")
    self._ui._slider[sliderIndex]:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_Deco_SliderFocusOn()")
    self._ui._slider[sliderIndex]:addInputEvent("Mouse_Out", "PaGlobalFunc_Customization_Deco_SliderFocusOut()")
    local sliderDesc = getUiSliderDescName(self._currentClassType, self._currentUiId, contentsIndex, sliderIndex)
    self._ui._staticText_SliderTitle[sliderIndex]:SetText(PAGetString(Defines.StringSheet_GAME, sliderDesc))
    self._ui._staticText_SliderTitle[sliderIndex]:SetShow(true)
    self._ui._slider[sliderIndex]:SetShow(true)
    self._ui._sliderButton[sliderIndex]:SetShow(true)
    self._ui._staticText_SliderValue[sliderIndex]:SetText(sliderParam)
    self._ui._staticText_SliderValue[sliderIndex]:SetShow(true)
    PaGlobalFunc_Customization_Deco_UpdateSlider(sliderIndex)
  end
  local paletteCount = getUiPaletteCount(self._currentClassType, self._currentUiId, contentsIndex)
  if paletteCount == 1 then
    local paletteParamType = getUiPaletteParamType(self._currentClassType, self._currentUiId, contentsIndex)
    local paletteParamIndex = getUiPaletteParamIndex(self._currentClassType, self._currentUiId, contentsIndex)
    local paletteParamIndex2 = getUiPaletteParamIndex(self._currentClassType, self._currentUiId, contentsIndex + 3)
    local paletteIndex = getDecorationParamMethodValue(self._currentClassType, paletteParamType, paletteParamIndex)
    PaGlobalFunc_Customization_PaletteHandle_CreateEyePalette(self._ui._colorTemplate, self._ui._static_ColorGroup, self._ui._colorSelect, self._currentClassType, paletteParamType, paletteParamIndex, paletteParamIndex2, paletteIndex, self._ui._checkBox_LeftEye, self._ui._checkBox_RightEye)
    local colorIndex = getParam(paletteParamType, paletteParamIndex)
    PaGlobalFunc_Customization_PaletteHandle_UpdateFocusBox(colorIndex)
  else
    self._ui._static_ColorGroup:SetShow(false)
    PaGlobalFunc_Customization_PaletteHandle_ClearPalette()
  end
  self:UpdatePanelSize()
  ToClient_padSnapRefreshTarget(Panel_Customizing_CommonDecoration)
end
function PaGlobalFunc_Customization_Deco_OpenTattooDecorationUi(classType, uiId)
  local self = Customization_DecoInfo
  self._isExpression = false
  self._isTattooMode = true
  self._currentCheckType = 2
  PaGlobalFunc_Customization_Deco_OpenCommonDecorationUi(classType, uiId, self._currentCheckType)
  self._currentClassType = classType
  self._currentUiId = uiId
  if self._isTattooMode then
    slideEnable = getEnableTattooSlide(self._currentClassType, self._selectedListParamType, self._selectedListParamIndex, self._selectedItemIndex)
    PaGlobalFunc_Customization_Deco_EnableDecorationSlide(slideEnable)
  end
end
function PaGlobalFunc_Customization_Deco_CloseTattooDecorationUi()
  local self = Customization_DecoInfo
  self._isTattooMode = false
  PaGlobalFunc_Customization_Deco_EnableDecorationSlide(true)
  PaGlobalFunc_Customization_Deco_CloseCommonDecorationUi()
  self._currentCheckType = -1
end
function PaGlobalFunc_Customization_Deco_OpenCommonExpressionUi(classType, uiId)
  local self = Customization_DecoInfo
  self:SetExpression()
  self._isExpression = true
  self._currentCheckType = 3
  PaGlobalFunc_Customization_Deco_OpenCommonDecorationUi(classType, uiId, self._currentCheckType)
  self._currentClassType = classType
  self._currentUiId = uiId
end
function Customization_DecoInfo:SetExpression()
  local expressionIndex = getParam(4, 0)
  local expressionWeight = getParam(4, 1)
  applyExpression(expressionIndex, expressionWeight)
end
function PaGlobalFunc_Customization_Deco_CloseCommonExpressionUi()
  local self = Customization_DecoInfo
  self._isExpression = false
  applyExpression(-1, 1)
  self._currentCheckType = -1
  PaGlobalFunc_Customization_Deco_CloseCommonDecorationUi()
end
function PaGlobalFunc_Customization_Deco_SliderFocusOn()
  local self = Customization_DecoInfo
  PaGlobalFunc_Customization_SetKeyGuide(6)
end
function PaGlobalFunc_Customization_Deco_SliderFocusOut()
  local self = Customization_DecoInfo
  if false == self._isBoneControl and true == PaGlobalFunc_Customization_Deco_GetShow() then
    PaGlobalFunc_Customization_SetKeyGuide(7)
  end
end
function PaGlobalFunc_Customization_Deco_UpdateEyeDecoSlider(sliderIndex)
  local self = Customization_DecoInfo
  local value = PaGlobalFunc_CustomIzationCommon_GetSliderValue(self._ui._slider[sliderIndex], self._sliderParamMin[sliderIndex], self._sliderParamMax[sliderIndex])
  if true == self._ui._checkBox_LeftEye:IsCheck() then
    PaGlobalFunc_Customization_Deco_UpdateEyeSlider(sliderIndex, self._sliderParamIndex[sliderIndex])
  end
  if true == self._ui._checkBox_RightEye:IsCheck() then
    PaGlobalFunc_Customization_Deco_UpdateEyeSlider(sliderIndex, self._sliderParamIndex2[sliderIndex])
  end
end
function PaGlobalFunc_Customization_Deco_UpdateEyeDecoList(paramType, paramIndex, paramIndex2, itemIndex)
  local self = Customization_DecoInfo
  if true == self._ui._checkBox_LeftEye:IsCheck() then
    setParam(self._currentClassType, paramType, paramIndex, itemIndex)
  end
  if true == self._ui._checkBox_RightEye:IsCheck() then
    setParam(self._currentClassType, paramType, paramIndex2, itemIndex)
  end
  self:UpdateTypeFocus(itemIndex)
end
function PaGlobalFunc_Customization_Deco_setLeftEyeDecoSlider()
  local self = Customization_DecoInfo
  local sliderCount = getUiSliderCount(self._currentClassType, self._currentUiId, contentsIndex)
  self._leftEyeToggle = not self._leftEyeToggle
  if self._leftEyeToggle then
    for sliderIndex = 0, sliderCount - 1 do
      local param = getParam(self._sliderParamType[sliderIndex], self._sliderParamIndex[sliderIndex])
      PaGlobalFunc_CustomIzationCommon_SetSliderValue(self._ui._slider[sliderIndex], param, self._sliderParamMin[sliderIndex], self._sliderParamMax[sliderIndex])
      PaGlobalFunc_Customization_Deco_UpdateEyeSlider(sliderIndex, self._sliderParamIndex[sliderIndex])
    end
  end
end
function PaGlobalFunc_Customization_Deco_setRightEyeDecoSlider()
  local self = Customization_DecoInfo
  local sliderCount = getUiSliderCount(self._currentClassType, self._currentUiId, contentsIndex)
  self._rightEyeToggle = not self._rightEyeToggle
  if self._rightEyeToggle then
    for sliderIndex = 0, sliderCount - 1 do
      local param = getParam(self._sliderParamType[sliderIndex], self._sliderParamIndex2[sliderIndex])
      PaGlobalFunc_CustomIzationCommon_SetSliderValue(self._ui._slider[sliderIndex], param, self._sliderParamMin[sliderIndex], self._sliderParamMax[sliderIndex])
      PaGlobalFunc_Customization_Deco_UpdateEyeSlider(sliderIndex, self._sliderParamIndex2[sliderIndex])
    end
  end
end
function PaGlobalFunc_Customization_Deco_EnableDecorationSlide(enable)
  local self = Customization_DecoInfo
  local color = Defines.Color.C_FF444444
  if enable then
    color = Defines.Color.C_FFFFFFFF
  end
  for index = 0, 4 do
    self._ui._sliderButton[index]:SetMonoTone(not enable)
    self._ui._slider[index]:SetEnable(enable)
    self._ui._slider[index]:SetIgnore(not enable)
    self._ui._staticText_SliderTitle[index]:SetFontColor(color)
    self._ui._staticText_SliderValue[index]:SetFontColor(color)
  end
end
function PaGlobalFunc_FromClient_Customization_Deco_luaLoadComplete()
  local self = Customization_DecoInfo
  self:Initialize()
end
function PaGlobalFunc_Customization_Deco_Close()
  local self = Customization_DecoInfo
  if false == PaGlobalFunc_Customization_Deco_GetShow() then
    return false
  end
  if true == self._isBoneControl then
    return false
  end
  self._currentTabIdx = 0
  PaGlobalFunc_Customization_SetCloseFunc(nil)
  PaGlobalFunc_Customization_SetBackEvent()
  PaGlobalFunc_Customization_Deco_SetShow(false, false)
  return true
end
function PaGlobalFunc_Customization_Deco_Open()
  if true == PaGlobalFunc_Customization_Deco_GetShow() then
    return
  end
  PaGlobalFunc_Customization_Deco_SetShow(true, false)
  PaGlobalFunc_Customization_KeyGuideSetShow(true)
  PaGlobalFunc_Customization_SetKeyGuide(7)
  PaGlobalFunc_Customization_SetCloseFunc(PaGlobalFunc_Customization_Deco_Close)
  PaGlobalFunc_Customization_SetBackEvent("PaGlobalFunc_Customization_Deco_Close()")
end
function PaGlobalFunc_Customization_Deco_SetShow(isShow, isAni)
  Panel_Customizing_CommonDecoration:SetShow(isShow, isAni)
end
function PaGlobalFunc_Customization_Deco_GetShow()
  return Panel_Customizing_CommonDecoration:GetShow()
end
function PaGlobalFunc_Customization_Deco_UpdateSlider(sliderIndex)
  local self = Customization_DecoInfo
  local value = PaGlobalFunc_CustomIzationCommon_GetSliderValue(self._ui._slider[sliderIndex], self._sliderParamMin[sliderIndex], self._sliderParamMax[sliderIndex])
  setParam(self._currentClassType, self._sliderParamType[sliderIndex], self._sliderParamIndex[sliderIndex], value)
  self._ui._staticText_SliderValue[sliderIndex]:SetText(value)
  self._ui._sliderButton[sliderIndex]:SetPosX(self._ui._slider[sliderIndex]:GetControlButton():GetPosX())
  local offset = math.cos(value / 100 * math.pi) * 2
  value = value / self._sliderParamMax[sliderIndex] * 100
  self._ui._sliderProgress[sliderIndex]:SetProgressRate(value + offset)
end
function PaGlobalFunc_Customization_Deco_UpdateEyeSlider(sliderIndex, sliderParamIndex)
  local self = Customization_DecoInfo
  local value = PaGlobalFunc_CustomIzationCommon_GetSliderValue(self._ui._slider[sliderIndex], self._sliderParamMin[sliderIndex], self._sliderParamMax[sliderIndex])
  setParam(self._currentClassType, self._sliderParamType[sliderIndex], sliderParamIndex, value)
  self._ui._staticText_SliderValue[sliderIndex]:SetText(value)
  self._ui._sliderButton[sliderIndex]:SetPosX(self._ui._slider[sliderIndex]:GetControlButton():GetPosX())
  local offset = math.cos(value / 100 * math.pi) * 2
  value = value / self._sliderParamMax[sliderIndex] * 100
  self._ui._sliderProgress[sliderIndex]:SetProgressRate(value + offset)
end
function PaGlobalFunc_Customization_Deco_MoveTab(isLeft)
  local self = Customization_DecoInfo
  if 0 >= self._currentTabCount then
    return
  end
  if true == isLeft and 0 < self._currentTabIdx then
    self._currentTabIdx = self._currentTabIdx - 1
  elseif false == isLeft and self._currentTabIdx < self._currentTabCount - 1 then
    self._currentTabIdx = self._currentTabIdx + 1
  end
  if true == self._ui._static_EyeDecoGroup:GetShow() then
    PaGlobalFunc_Customization_Deco_UpdateEyeDecoContents(self._currentTabIdx, 0)
  else
    PaGlobalFunc_Customization_Deco_UpdateDecorationContents(self._currentTabIdx)
  end
  for idx, button in pairs(self._buttonList) do
    button:SetCheck(false)
  end
  self._buttonList[self._currentTabIdx]:SetCheck(true)
end
function PaGlobalFunc_Customization_Deco_GetPanel()
  return Panel_Customizing_CommonDecoration
end
PaGlobalFunc_FromClient_Customization_Deco_luaLoadComplete()

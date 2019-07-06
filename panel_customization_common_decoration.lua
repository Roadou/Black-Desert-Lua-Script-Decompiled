local NoCashType = CppEnums.CustomizationNoCashType
local NoCashDeco = CppEnums.CustomizationNoCashDeco
local isTattooMode = false
local FrameTemplate = UI.getChildControl(Panel_Customization_Common_Decoration, "Frame_Template")
local Frame_Content = UI.getChildControl(FrameTemplate, "Frame_Content")
local Frame_ContentImage = UI.getChildControl(Frame_Content, "Frame_Content_Image")
local Frame_Scroll = UI.getChildControl(FrameTemplate, "Frame_Scroll")
local Static_SelectMark = UI.getChildControl(Frame_Content, "Static_SelectMark")
local Static_PayMark = UI.getChildControl(Frame_Content, "Static_PayMark")
local FrameTemplateColor = UI.getChildControl(Panel_Customization_Common_Decoration, "Frame_Template_Color")
local Static_Collision = UI.getChildControl(Panel_Customization_Common_Decoration, "Static_Collision")
local RadioButton_Template = UI.getChildControl(Panel_Customization_Common_Decoration, "RadioButton_Template")
local SliderControlArr = {}
local SliderButtonArr = {}
local SliderTextArr = {}
local SliderValueArr = {}
local CheckControlArr = {}
local CheckTextArr = {}
CheckControlArr[1] = UI.getChildControl(Panel_Customization_Common_Decoration, "CheckButton_Left")
CheckControlArr[2] = UI.getChildControl(Panel_Customization_Common_Decoration, "CheckButton_Right")
CheckTextArr[1] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_EyeLeft")
CheckTextArr[2] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_EyeRight")
SliderControlArr[1] = UI.getChildControl(Panel_Customization_Common_Decoration, "Slider_Control1")
SliderControlArr[2] = UI.getChildControl(Panel_Customization_Common_Decoration, "Slider_Control2")
SliderControlArr[3] = UI.getChildControl(Panel_Customization_Common_Decoration, "Slider_Control3")
SliderControlArr[4] = UI.getChildControl(Panel_Customization_Common_Decoration, "Slider_Control4")
SliderControlArr[5] = UI.getChildControl(Panel_Customization_Common_Decoration, "Slider_Control5")
SliderControlArr[6] = UI.getChildControl(Panel_Customization_Common_Decoration, "Slider_Control6")
SliderControlArr[7] = UI.getChildControl(Panel_Customization_Common_Decoration, "Slider_Control7")
SliderButtonArr[1] = UI.getChildControl(SliderControlArr[1], "Slider_GammaController_Button")
SliderButtonArr[2] = UI.getChildControl(SliderControlArr[2], "Slider_GammaController_Button")
SliderButtonArr[3] = UI.getChildControl(SliderControlArr[3], "Slider_GammaController_Button")
SliderButtonArr[4] = UI.getChildControl(SliderControlArr[4], "Slider_GammaController_Button")
SliderButtonArr[5] = UI.getChildControl(SliderControlArr[5], "Slider_GammaController_Button")
SliderButtonArr[6] = UI.getChildControl(SliderControlArr[6], "Slider_GammaController_Button")
SliderButtonArr[7] = UI.getChildControl(SliderControlArr[7], "Slider_GammaController_Button")
SliderTextArr[1] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderText1")
SliderTextArr[2] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderText2")
SliderTextArr[3] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderText3")
SliderTextArr[4] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderText4")
SliderTextArr[5] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderText5")
SliderTextArr[6] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderText6")
SliderTextArr[7] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderText7")
SliderValueArr[1] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderValue1")
SliderValueArr[2] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderValue2")
SliderValueArr[3] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderValue3")
SliderValueArr[4] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderValue4")
SliderValueArr[5] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderValue5")
SliderValueArr[6] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderValue6")
SliderValueArr[7] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderValue7")
local sliderParamType = {}
local sliderParamIndex = {}
local sliderParamIndex2 = {}
local sliderParam = {}
local sliderParamMin = {}
local sliderParamMax = {}
local sliderParamDefault = {}
CheckTextArr[1]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONEYE_EYELEFT"))
CheckTextArr[2]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONEYE_EYERIGHT"))
if false == _ContentsGroup_RenewUI_Customization then
  registerEvent("EventOpenCommonDecorationUi", "OpenCommonDecorationUi")
  registerEvent("EventCloseCommonDecorationUi", "CloseCommonDecorationUi")
  registerEvent("EventOpenEyeDecorationUi", "OpenEyeDecorationUi")
  registerEvent("EventCloseEyeDecorationUi", "CloseEyeDecorationUi")
  registerEvent("EventOpenTattooDecorationUi", "OpenTattooDecorationUi")
  registerEvent("EventCloseTattooDecorationUi", "CloseTattooDecorationUi")
  registerEvent("EventEnableDecorationSlide", "EnableDecorationSlide")
  registerEvent("EventOpenCommonExpressionUi", "OpenCommonExpressionUi")
  registerEvent("EventCloseCommonExpressionUi", "CloseCommonExpressionUi")
end
local selectedUiId, selectedListParamType, selectedListParamIndex, selectedItemIndex
local ContentImage = {}
local PayMark = {}
local decoGroup = {}
local RadioButtonGroup = {}
local selectedDecoGroupIdx = 0
local selectedDecoPartIdx = 0
local luaSelectedDecoGroupIdx = 0
local contentsStartY = 0
local controlOffset = 10
local radioButtonStartX = 10
local radioButtonStartY = 10
local radioButtonColumnNum = 3
local radioButtonGap = 2
local radioButtonColumnWidth = RadioButton_Template:GetSizeX() + radioButtonGap
local radioButtonColumnHeight = RadioButton_Template:GetSizeY() + radioButtonGap
local imageFrameSizeY = 125
local listColumCount = 4
local listOffset = 10
local listColumnWidth = Frame_ContentImage:GetSizeX() + listOffset
local listColumnHeight = Frame_ContentImage:GetSizeY() + listOffset
local listStartX = 10
local listStartY = 10
local sliderOffset = 7
local sliderValueOffset = 10
local sliderHeight = SliderTextArr[1]:GetSizeY()
local colorPickerStartY = 370
local currentuiId = -1
checkType = -1
local currentcontentindex = -1
local function UpdateMarkPosition(shapeIdx)
  if FrameTemplate:GetShow() then
    if shapeIdx ~= -1 then
      Static_SelectMark:SetShow(true)
      Static_SelectMark:SetPosX(shapeIdx % listColumCount * listColumnWidth + listStartX)
      Static_SelectMark:SetPosY(math.floor(shapeIdx / listColumCount) * listColumnHeight + listStartY)
    else
      Static_SelectMark:SetShow(false)
    end
  end
end
local function clearRadioButtons()
  for _, rb in pairs(RadioButtonGroup) do
    rb:SetShow(false)
    UI.deleteControl(rb)
  end
  RadioButtonGroup = {}
end
local function clearContents()
  for _, content in pairs(ContentImage) do
    content:SetShow(false)
    UI.deleteControl(content)
  end
  ContentImage = {}
  for _, content in pairs(PayMark) do
    content:SetShow(false)
    UI.deleteControl(content)
  end
  PayMark = {}
  for index = 1, 7 do
    SliderControlArr[index]:SetShow(false)
    SliderTextArr[index]:SetShow(false)
    SliderValueArr[index]:SetShow(false)
  end
  Static_Collision:SetShow(false)
  FrameTemplate:SetShow(false)
  Frame_Content:SetSize(Frame_Content:GetSizeX(), 0)
end
function OpenCommonDecorationUi(uiId, checkType)
  globalcurrentuiId = uiId
  currentuiId = uiId
  if false then
    checkType = 0
  else
  end
  clearRadioButtons()
  CheckControlArr[1]:SetShow(false)
  CheckControlArr[2]:SetShow(false)
  CheckTextArr[1]:SetShow(false)
  CheckTextArr[2]:SetShow(false)
  selectedUiId = uiId
  FrameTemplateColor:SetSize(Panel_Customization_Common_Decoration:GetSizeX(), 0)
  FrameTemplateColor:SetShow(false)
  local contentsCount = getUiContentsCount(uiId)
  if contentsCount > 1 then
    for contentsIndex = 0, contentsCount - 1 do
      local luaContentsIndex = contentsIndex + 1
      local tempRadioButton = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, Panel_Customization_Common_Decoration, "RadioButton_" .. luaContentsIndex)
      CopyBaseProperty(RadioButton_Template, tempRadioButton)
      local contentsDesc = getUiContentsDescName(uiId, contentsIndex)
      tempRadioButton:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      tempRadioButton:SetText(PAGetString(Defines.StringSheet_GAME, contentsDesc))
      tempRadioButton:SetPosX(radioButtonStartX + contentsIndex % radioButtonColumnNum * radioButtonColumnWidth)
      tempRadioButton:SetPosY(radioButtonStartY + math.floor(contentsIndex / radioButtonColumnNum) * radioButtonColumnHeight)
      tempRadioButton:addInputEvent("Mouse_LUp", "UpdateDecorationContents(" .. contentsIndex .. ")")
      tempRadioButton:SetShow(true)
      RadioButtonGroup[luaContentsIndex] = tempRadioButton
    end
    local radioButtonRowCount = 1 + math.floor((contentsCount - 1) / radioButtonColumnNum)
    contentsStartY = controlOffset + radioButtonRowCount * RadioButton_Template:GetSizeY() + controlOffset
  else
    contentsStartY = controlOffset
  end
  if contentsCount > 1 then
    RadioButtonGroup[1]:SetCheck(true)
  end
  UpdateDecorationContents(0)
end
function CloseCommonDecorationUi()
  EnableDecorationSlide(true)
  clearPalette()
  globalcurrentuiId = -2
  checkType = -1
end
function CloseEyeDecorationUi()
  clearPalette()
  globalcurrentuiId = -2
  checkType = -1
end
function UpdateDecorationContents(contentsIndex, currentuiId)
  clearContents()
  currentcontentindex = contentsIndex
  if nil ~= currentuiId then
    selectedUiId = currentuiId
  end
  local texSize = 48.25
  local controlPosY = contentsStartY
  local listCount = getUiListCount(selectedUiId, contentsIndex)
  if listCount == 1 then
    local listIndex = 0
    local luaListIndex = listIndex + 1
    local listTexture = getUiListTextureName(selectedUiId, contentsIndex, listIndex)
    local listParamType = getUiListParamType(selectedUiId, contentsIndex, listIndex)
    local listParamIndex = getUiListParamIndex(selectedUiId, contentsIndex, listIndex)
    local paramMax = getParamMax(listParamType, listParamIndex)
    for itemIndex = 0, paramMax do
      local luaShapeIdx = itemIndex + 1
      local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Frame_Content, "Frame_Image_" .. itemIndex .. "_" .. selectedUiId)
      CopyBaseProperty(Frame_ContentImage, tempContentImage)
      tempContentImage:addInputEvent("Mouse_LUp", "UpdateDecorationListMessage(" .. listParamType .. "," .. listParamIndex .. "," .. itemIndex .. ")")
      local staticPayMark
      if NoCashType.eCustomizationNoCashType_Deco == listParamType and (NoCashDeco.eCustomizationNoCashDeco_FaceTattoo == listParamIndex or NoCashDeco.eCustomizationNoCashDeco_BodyTattoo == listParamIndex) then
        staticPayMark = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempContentImage, "Static_PayMark_" .. itemIndex .. "_" .. selectedUiId)
        CopyBaseProperty(Static_PayMark, staticPayMark)
      end
      local mod = itemIndex % listColumCount
      local divi = math.floor(itemIndex / listColumCount)
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
      tempContentImage:SetPosX(itemIndex % listColumCount * listColumnWidth + listStartX)
      tempContentImage:SetPosY(math.floor(itemIndex / listColumCount) * listColumnHeight + listStartY)
      tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
      if not FGlobal_IsCommercialService() and not isNormalCustomizingIndex(listParamType, listParamIndex, itemIndex) then
        tempContentImage:SetShow(false)
      elseif not isNormalCustomizingIndex(listParamType, listParamIndex, itemIndex) and not FGlobal_IsInGameMode() then
        tempContentImage:SetShow(false)
      else
        tempContentImage:SetShow(true)
      end
      if NoCashType.eCustomizationNoCashType_Deco == listParamType and (NoCashDeco.eCustomizationNoCashDeco_FaceTattoo == listParamIndex or NoCashDeco.eCustomizationNoCashDeco_BodyTattoo == listParamIndex) then
        if not isNormalCustomizingIndex(listParamType, listParamIndex, itemIndex) then
          staticPayMark:SetShow(true)
        else
          staticPayMark:SetShow(false)
        end
      end
      ContentImage[luaShapeIdx] = tempContentImage
      PayMark[luaShapeIdx] = staticPayMark
    end
    local param = getParam(listParamType, listParamIndex)
    selectedListParamType = listParamType
    selectedListParamIndex = listParamIndex
    selectedItemIndex = param
    FrameTemplate:SetShow(true)
    FrameTemplate:SetPosY(controlPosY)
    if paramMax < listColumCount then
      FrameTemplate:SetSize(FrameTemplate:GetSizeX(), imageFrameSizeY - listColumnHeight)
    else
      FrameTemplate:SetSize(FrameTemplate:GetSizeX(), imageFrameSizeY)
    end
    controlPosY = controlPosY + FrameTemplate:GetSizeY() + controlOffset
  end
  if listCount > 0 then
    UpdateDecorationList()
  end
  local sliderCount = getUiSliderCount(selectedUiId, contentsIndex)
  local sliderValueBasePosX = 0
  for sliderIndex = 0, sliderCount - 1 do
    local luaSliderIndex = sliderIndex + 1
    sliderParamType[luaSliderIndex] = getUiSliderParamType(selectedUiId, contentsIndex, sliderIndex)
    sliderParamIndex[luaSliderIndex] = getUiSliderParamIndex(selectedUiId, contentsIndex, sliderIndex)
    local sliderParam = getParam(sliderParamType[luaSliderIndex], sliderParamIndex[luaSliderIndex])
    sliderParamMin[luaSliderIndex] = getParamMin(sliderParamType[luaSliderIndex], sliderParamIndex[luaSliderIndex])
    sliderParamMax[luaSliderIndex] = getParamMax(sliderParamType[luaSliderIndex], sliderParamIndex[luaSliderIndex])
    sliderParamDefault[luaSliderIndex] = getParamDefault(sliderParamType[luaSliderIndex], sliderParamIndex[luaSliderIndex])
    setSliderValue(SliderControlArr[luaSliderIndex], sliderParam, sliderParamMin[luaSliderIndex], sliderParamMax[luaSliderIndex])
    SliderButtonArr[luaSliderIndex]:addInputEvent("Mouse_LPress", "UpdateDecorationSlider(" .. sliderIndex .. ")")
    SliderControlArr[luaSliderIndex]:addInputEvent("Mouse_LPress", "UpdateDecorationSlider(" .. sliderIndex .. ")")
    SliderButtonArr[luaSliderIndex]:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
    SliderControlArr[luaSliderIndex]:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
    local sliderDesc = getUiSliderDescName(selectedUiId, contentsIndex, sliderIndex)
    SliderTextArr[luaSliderIndex]:SetText(PAGetString(Defines.StringSheet_GAME, sliderDesc))
    SliderTextArr[luaSliderIndex]:SetPosY(controlPosY)
    SliderTextArr[luaSliderIndex]:SetShow(true)
    SliderControlArr[luaSliderIndex]:SetPosY(controlPosY + sliderOffset)
    SliderControlArr[luaSliderIndex]:SetShow(true)
    SliderValueArr[luaSliderIndex]:SetText(sliderParam)
    SliderValueArr[luaSliderIndex]:SetPosY(controlPosY + sliderValueOffset)
    SliderValueArr[luaSliderIndex]:SetShow(true)
    if nil ~= ToClient_getGameOptionControllerWrapper() then
      if 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() then
        SliderValueArr[luaSliderIndex]:SetPosX(72)
      else
        SliderValueArr[luaSliderIndex]:SetPosX(64)
      end
    end
    local sliderTextSizeX = SliderTextArr[luaSliderIndex]:GetPosX() + SliderTextArr[luaSliderIndex]:GetTextSizeX()
    local sliderValuePosX = SliderValueArr[luaSliderIndex]:GetPosX()
    if sliderTextSizeX > sliderValuePosX then
      sliderValueBasePosX = math.max(sliderValueBasePosX, sliderTextSizeX)
    end
    controlPosY = controlPosY + sliderHeight
  end
  if sliderValueBasePosX > 0 then
    for sliderIndex = 0, sliderCount - 1 do
      local luaSliderIndex = sliderIndex + 1
      local sliderValuePosX = SliderValueArr[luaSliderIndex]:GetPosX()
      SliderValueArr[luaSliderIndex]:SetPosX(sliderValueBasePosX + 5)
      SliderControlArr[luaSliderIndex]:SetSize(174 - (sliderValueBasePosX - sliderValuePosX), SliderControlArr[luaSliderIndex]:GetSizeY())
      SliderControlArr[luaSliderIndex]:SetPosX(95 + (sliderValueBasePosX - sliderValuePosX) + 5)
      local sliderParam = getParam(sliderParamType[luaSliderIndex], sliderParamIndex[luaSliderIndex])
      setSliderValue(SliderControlArr[luaSliderIndex], sliderParam, sliderParamMin[luaSliderIndex], sliderParamMax[luaSliderIndex])
      SliderControlArr[luaSliderIndex]:SetInterval(100)
    end
  end
  local paletteCount = getUiPaletteCount(selectedUiId, contentsIndex)
  if paletteCount == 1 then
    controlPosY = controlPosY + controlOffset
    local paletteParamType = getUiPaletteParamType(selectedUiId, contentsIndex)
    local paletteParamIndex = getUiPaletteParamIndex(selectedUiId, contentsIndex)
    local paletteIndex = getDecorationParamMethodValue(paletteParamType, paletteParamIndex)
    FrameTemplateColor:SetShow(true)
    FrameTemplateColor:SetPosY(controlPosY)
    CreateCommonPalette(FrameTemplateColor, Static_Collision, paletteParamType, paletteParamIndex, paletteIndex)
    local colorIndex = getParam(paletteParamType, paletteParamIndex)
    UpdatePaletteMarkPosition(colorIndex)
    local Frame_Content_Color = UI.getChildControl(FrameTemplateColor, "Frame_Content")
    Static_SelectMark_Color = UI.getChildControl(Frame_Content_Color, "Static_SelectMark")
    Frame_Content_Color:SetChildIndex(Static_SelectMark_Color, 9999)
  else
    clearPalette()
  end
  Panel_Customization_Common_Decoration:SetSize(Panel_Customization_Common_Decoration:GetSizeX(), controlPosY + FrameTemplateColor:GetSizeY() + controlOffset)
  updateGroupFrameControls(Panel_Customization_Common_Decoration:GetSizeY(), Panel_Customization_Common_Decoration)
  Panel_Customization_Common_Decoration:SetShow(true)
  FrameTemplateColor:UpdateContentScroll()
  FrameTemplateColor:UpdateContentPos()
  FrameTemplate:UpdateContentScroll()
  Frame_Scroll:SetControlTop()
  FrameTemplate:UpdateContentPos()
end
function UpdateDecorationListMessage(paramType, paramIndex, itemIndex)
  selectedListParamType = paramType
  selectedListParamIndex = paramIndex
  selectedItemIndex = itemIndex
  local fp
  if isTattooMode then
    fp = UpdateTattooAtlasList
  else
    fp = UpdateDecorationPose
  end
  if Panel_Win_System:GetShow() then
    MessageBox_Empty_function()
    allClearMessageData()
  end
  if NoCashType.eCustomizationNoCashType_Deco == paramType and (NoCashDeco.eCustomizationNoCashDeco_FaceTattoo == paramIndex or NoCashDeco.eCustomizationNoCashDeco_BodyTattoo == paramIndex) and not FGlobal_IsInGameMode() and not isNormalCustomizingIndex(selectedListParamType, selectedListParamIndex, selectedItemIndex) then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLY_CASHITEM")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = fp,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "top")
    return
  end
  if 4 == paramType then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLY_EXPRESSION")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = fp,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "top")
    return
  end
  if isTattooMode then
    slideEnable = getEnableTattooSlide(selectedListParamType, selectedListParamIndex, selectedItemIndex)
    EnableDecorationSlide(slideEnable)
  end
  UpdateDecorationList()
  add_CurrentHistory()
end
function UpdateTattooAtlasList()
  slideEnable = getEnableTattooSlide(selectedListParamType, selectedListParamIndex, selectedItemIndex)
  EnableDecorationSlide(slideEnable)
  setParam(selectedListParamType, selectedListParamIndex, selectedItemIndex)
  UpdateMarkPosition(selectedItemIndex)
end
function UpdateDecorationPose()
  setParam(selectedListParamType, selectedListParamIndex, selectedItemIndex)
  UpdateMarkPosition(selectedItemIndex)
  add_CurrentHistory()
end
function UpdateDecorationList()
  setParam(selectedListParamType, selectedListParamIndex, selectedItemIndex)
  UpdateMarkPosition(selectedItemIndex)
end
function UpdateDecorationSlider(sliderIndex)
  local luaSliderIndex = sliderIndex + 1
  local value = getSliderValue(SliderControlArr[luaSliderIndex], sliderParamMin[luaSliderIndex], sliderParamMax[luaSliderIndex])
  setParam(sliderParamType[luaSliderIndex], sliderParamIndex[luaSliderIndex], value)
  SliderValueArr[luaSliderIndex]:SetText(value)
  setGlobalCheck(true)
end
function UpdateHairDecorationSlider(sliderIndex)
end
function OpenEyeDecorationUi(uiId)
  globalcurrentuiId = uiId
  currentuiId = uiId
  checkType = 1
  clearRadioButtons()
  CheckControlArr[1]:SetShow(true)
  CheckControlArr[2]:SetShow(true)
  CheckControlArr[1]:SetCheck(true)
  CheckControlArr[2]:SetCheck(true)
  CheckTextArr[1]:SetShow(true)
  CheckTextArr[2]:SetShow(true)
  contentsStartY = 0
  contentsStartY = contentsStartY + CheckControlArr[1]:GetSizeY() + controlOffset
  selectedUiId = uiId
  FrameTemplateColor:SetSize(Panel_Customization_Common_Decoration:GetSizeX(), 1)
  local contentsCount = getUiContentsCount(uiId) / 2
  if contentsCount > 1 then
    for contentsIndex = 0, contentsCount - 1 do
      local luaContentsIndex = contentsIndex + 1
      local tempRadioButton = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, Panel_Customization_Common_Decoration, "RadioButton_" .. luaContentsIndex)
      CopyBaseProperty(RadioButton_Template, tempRadioButton)
      local contentsDesc = getUiContentsDescName(uiId, contentsIndex)
      tempRadioButton:SetText(PAGetString(Defines.StringSheet_GAME, contentsDesc))
      tempRadioButton:SetPosX(radioButtonStartX + contentsIndex % radioButtonColumnNum * radioButtonColumnWidth)
      tempRadioButton:SetPosY(contentsStartY + radioButtonStartY + math.floor(contentsIndex / radioButtonColumnNum) * radioButtonColumnHeight)
      tempRadioButton:addInputEvent("Mouse_LUp", "UpdateEyeDecorationContents(" .. contentsIndex .. ", " .. 0 .. ")")
      tempRadioButton:SetShow(true)
      RadioButtonGroup[luaContentsIndex] = tempRadioButton
    end
    local radioButtonRowCount = 1 + math.floor((contentsCount - 1) / radioButtonColumnNum)
    contentsStartY = contentsStartY + controlOffset + radioButtonRowCount * RadioButton_Template:GetSizeY() + controlOffset
  else
    contentsStartY = contentsStartY + controlOffset
  end
  if contentsCount > 1 then
    RadioButtonGroup[1]:SetCheck(true)
  end
  UpdateEyeDecorationContents(0, 0)
end
function UpdateEyeDecorationContents(contentsIndex, addHistory, currentuiId)
  clearContents()
  currentcontentindex = contentsIndex
  if nil ~= currentuiId then
    selectedUiId = currentuiId
  end
  local texSize = 48.25
  local controlPosY = contentsStartY
  local listCount = getUiListCount(selectedUiId, contentsIndex)
  if listCount == 1 then
    local listIndex = 0
    local luaListIndex = listIndex + 1
    local listTexture = getUiListTextureName(selectedUiId, contentsIndex, listIndex)
    local listParamType = getUiListParamType(selectedUiId, contentsIndex, listIndex)
    local listParamIndex = getUiListParamIndex(selectedUiId, contentsIndex, listIndex)
    local listParamIndex2 = getUiListParamIndex(selectedUiId, contentsIndex + 3, listIndex)
    FrameTemplate:SetShow(true)
    local paramMax = getParamMax(listParamType, listParamIndex)
    for itemIndex = 0, paramMax do
      local luaShapeIdx = itemIndex + 1
      local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Frame_Content, "Frame_Image_" .. itemIndex)
      CopyBaseProperty(Frame_ContentImage, tempContentImage)
      tempContentImage:addInputEvent("Mouse_LUp", "UpdateEyeDecorationList(" .. listParamType .. "," .. listParamIndex .. "," .. listParamIndex2 .. "," .. itemIndex .. ")")
      local mod = itemIndex % listColumCount
      local divi = math.floor(itemIndex / listColumCount)
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
      tempContentImage:SetPosX(itemIndex % listColumCount * listColumnWidth + listStartX)
      tempContentImage:SetPosY(math.floor(itemIndex / listColumCount) * listColumnHeight + listStartY)
      tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
      tempContentImage:SetShow(true)
      ContentImage[luaShapeIdx] = tempContentImage
    end
    local param = getParam(listParamType, listParamIndex)
    UpdateMarkPosition(param)
    FrameTemplate:SetPosY(controlPosY)
    if paramMax < listColumCount then
      FrameTemplate:SetSize(FrameTemplate:GetSizeX(), imageFrameSizeY - listColumnHeight)
    else
      FrameTemplate:SetSize(FrameTemplate:GetSizeX(), imageFrameSizeY)
    end
    controlPosY = controlPosY + FrameTemplate:GetSizeY() + controlOffset
  end
  local sliderCount = getUiSliderCount(selectedUiId, contentsIndex)
  local sliderValueBasePosX = 0
  for sliderIndex = 0, sliderCount - 1 do
    local luaSliderIndex = sliderIndex + 1
    sliderParamType[luaSliderIndex] = getUiSliderParamType(selectedUiId, contentsIndex, sliderIndex)
    sliderParamIndex[luaSliderIndex] = getUiSliderParamIndex(selectedUiId, contentsIndex, sliderIndex)
    sliderParamIndex2[luaSliderIndex] = getUiSliderParamIndex(selectedUiId, contentsIndex + 3, sliderIndex)
    local sliderParam = getParam(sliderParamType[luaSliderIndex], sliderParamIndex[luaSliderIndex])
    sliderParamMin[luaSliderIndex] = getParamMin(sliderParamType[luaSliderIndex], sliderParamIndex[luaSliderIndex])
    sliderParamMax[luaSliderIndex] = getParamMax(sliderParamType[luaSliderIndex], sliderParamIndex[luaSliderIndex])
    sliderParamDefault[luaSliderIndex] = getParamDefault(sliderParamType[luaSliderIndex], sliderParamIndex[luaSliderIndex])
    setSliderValue(SliderControlArr[luaSliderIndex], sliderParam, sliderParamMin[luaSliderIndex], sliderParamMax[luaSliderIndex])
    SliderButtonArr[luaSliderIndex]:addInputEvent("Mouse_LPress", "UpdateEyeDecorationSlider(" .. sliderIndex .. ")")
    SliderControlArr[luaSliderIndex]:addInputEvent("Mouse_LUp", "add_CurrentHistory()")
    local sliderDesc = getUiSliderDescName(selectedUiId, contentsIndex, sliderIndex)
    SliderTextArr[luaSliderIndex]:SetText(PAGetString(Defines.StringSheet_GAME, sliderDesc))
    SliderTextArr[luaSliderIndex]:SetPosY(controlPosY)
    SliderTextArr[luaSliderIndex]:SetShow(true)
    SliderControlArr[luaSliderIndex]:SetPosY(controlPosY + sliderOffset)
    SliderControlArr[luaSliderIndex]:SetShow(true)
    SliderValueArr[luaSliderIndex]:SetText(sliderParam)
    SliderValueArr[luaSliderIndex]:SetPosY(controlPosY + sliderValueOffset)
    SliderValueArr[luaSliderIndex]:SetShow(true)
    local sliderTextSizeX = SliderTextArr[luaSliderIndex]:GetPosX() + SliderTextArr[luaSliderIndex]:GetTextSizeX()
    local sliderValuePosX = SliderValueArr[luaSliderIndex]:GetPosX()
    if sliderTextSizeX > sliderValuePosX then
      sliderValueBasePosX = math.max(sliderValueBasePosX, sliderTextSizeX)
    end
    controlPosY = controlPosY + sliderHeight
  end
  if sliderValueBasePosX > 0 then
    for sliderIndex = 0, sliderCount - 1 do
      local luaSliderIndex = sliderIndex + 1
      local sliderValuePosX = SliderValueArr[luaSliderIndex]:GetPosX()
      SliderValueArr[luaSliderIndex]:SetPosX(sliderValueBasePosX + 5)
      SliderControlArr[luaSliderIndex]:SetSize(174 - (sliderValueBasePosX - sliderValuePosX), SliderControlArr[luaSliderIndex]:GetSizeY())
      SliderControlArr[luaSliderIndex]:SetPosX(95 + (sliderValueBasePosX - sliderValuePosX) + 5)
      local sliderParam = getParam(sliderParamType[luaSliderIndex], sliderParamIndex[luaSliderIndex])
      setSliderValue(SliderControlArr[luaSliderIndex], sliderParam, sliderParamMin[luaSliderIndex], sliderParamMax[luaSliderIndex])
      SliderControlArr[luaSliderIndex]:SetInterval(100)
    end
  end
  local paletteCount = getUiPaletteCount(selectedUiId, contentsIndex)
  if paletteCount == 1 then
    controlPosY = controlPosY + controlOffset
    local paletteParamType = getUiPaletteParamType(selectedUiId, contentsIndex)
    local paletteParamIndex = getUiPaletteParamIndex(selectedUiId, contentsIndex)
    local paletteParamIndex2 = getUiPaletteParamIndex(selectedUiId, contentsIndex + 3)
    local paletteIndex = getDecorationParamMethodValue(paletteParamType, paletteParamIndex)
    FrameTemplateColor:SetShow(true)
    FrameTemplateColor:SetPosY(controlPosY)
    CreateEyePalette(FrameTemplateColor, Static_Collision, paletteParamType, paletteParamIndex, paletteParamIndex2, paletteIndex, CheckControlArr[1], CheckControlArr[2])
    local colorIndex = getParam(paletteParamType, paletteParamIndex)
    UpdatePaletteMarkPosition(colorIndex)
    local Frame_Content_Color = UI.getChildControl(FrameTemplateColor, "Frame_Content")
    Static_SelectMark_Color = UI.getChildControl(Frame_Content_Color, "Static_SelectMark")
    Frame_Content_Color:SetChildIndex(Static_SelectMark_Color, 9999)
  else
    clearPalette()
  end
  Panel_Customization_Common_Decoration:SetSize(Panel_Customization_Common_Decoration:GetSizeX(), controlPosY + FrameTemplateColor:GetSizeY() + controlOffset)
  updateGroupFrameControls(Panel_Customization_Common_Decoration:GetSizeY(), Panel_Customization_Common_Decoration)
  Panel_Customization_Common_Decoration:SetShow(true)
  FrameTemplateColor:UpdateContentScroll()
  FrameTemplateColor:UpdateContentPos()
  FrameTemplate:UpdateContentScroll()
  Frame_Scroll:SetControlTop()
  FrameTemplate:UpdateContentPos()
  if addHistory == 1 then
    add_CurrentHistory()
  end
end
function UpdateEyeDecorationList(paramType, paramIndex, paramIndex2, itemIndex)
  if CheckControlArr[1]:IsCheck() == true then
    setParam(paramType, paramIndex, itemIndex)
  end
  if CheckControlArr[2]:IsCheck() == true then
    setParam(paramType, paramIndex2, itemIndex)
  end
  add_CurrentHistory()
  UpdateMarkPosition(itemIndex)
end
function UpdateEyeDecorationSlider(sliderIndex)
  local luaSliderIndex = sliderIndex + 1
  local value = getSliderValue(SliderControlArr[luaSliderIndex], sliderParamMin[luaSliderIndex], sliderParamMax[luaSliderIndex])
  if CheckControlArr[1]:IsCheck() == true then
    setParam(sliderParamType[luaSliderIndex], sliderParamIndex[luaSliderIndex], value)
  end
  if CheckControlArr[2]:IsCheck() == true then
    setParam(sliderParamType[luaSliderIndex], sliderParamIndex2[luaSliderIndex], value)
  end
  SliderValueArr[luaSliderIndex]:SetText(value)
  setGlobalCheck(true)
end
function EnableDecorationSlide(enable)
  SliderButtonArr[1]:SetMonoTone(not enable)
  SliderButtonArr[2]:SetMonoTone(not enable)
  SliderButtonArr[3]:SetMonoTone(not enable)
  SliderButtonArr[4]:SetMonoTone(not enable)
  SliderButtonArr[5]:SetMonoTone(not enable)
  local color = Defines.Color.C_FF444444
  if enable then
    color = Defines.Color.C_FFFFFFFF
  end
  SliderControlArr[1]:SetEnable(enable)
  SliderControlArr[2]:SetEnable(enable)
  SliderControlArr[3]:SetEnable(enable)
  SliderControlArr[4]:SetEnable(enable)
  SliderControlArr[5]:SetEnable(enable)
  SliderTextArr[1]:SetFontColor(color)
  SliderTextArr[2]:SetFontColor(color)
  SliderTextArr[3]:SetFontColor(color)
  SliderTextArr[4]:SetFontColor(color)
  SliderTextArr[5]:SetFontColor(color)
  SliderValueArr[1]:SetFontColor(color)
  SliderValueArr[2]:SetFontColor(color)
  SliderValueArr[3]:SetFontColor(color)
  SliderValueArr[4]:SetFontColor(color)
  SliderValueArr[5]:SetFontColor(color)
end
function OpenTattooDecorationUi(uiId)
  isTattooMode = true
  checkType = 2
  OpenCommonDecorationUi(uiId, checkType)
  globalcurrentuiId = uiId
  currentuiId = uiId
  if isTattooMode then
    slideEnable = getEnableTattooSlide(selectedListParamType, selectedListParamIndex, selectedItemIndex)
    EnableDecorationSlide(slideEnable)
  end
end
function CloseTattooDecorationUi()
  isTattooMode = false
  EnableDecorationSlide(true)
  CloseCommonDecorationUi()
  checkType = -1
end
function OpenCommonExpressionUi(uiId)
  SetExpression()
  checkType = 3
  OpenCommonDecorationUi(uiId, checkType)
  globalcurrentuiId = uiId
  currentuiId = uiId
end
function CloseCommonExpressionUi()
  applyExpression(-1, 1)
  CloseCommonDecorationUi()
  checkType = -1
end
function SetExpression()
  local expressionIndex = getParam(4, 0)
  local expressionWeight = getParam(4, 1)
  applyExpression(expressionIndex, expressionWeight)
end
function CommonDecorationHistoryApplyUpdate()
  if globalcurrentuiId ~= currentuiId then
    return
  end
  if 0 == checkType then
    UpdateDecorationContents(currentcontentindex, currentuiId)
  elseif 1 == checkType then
    UpdateEyeDecorationContents(currentcontentindex, 0, currentuiId)
  elseif 2 == checkType then
    UpdateDecorationContents(currentcontentindex, currentuiId)
  elseif 3 == checkType then
    SetExpression()
    UpdateDecorationContents(currentcontentindex, currentuiId)
  end
end

local Customization_PaletteHandleInfo = {
  _config = {_columnCount = 10, _imageSize = 25},
  _colorStatic = {},
  _checkBox_LeftEye,
  _checkBox_RightEye,
  _currentColorIndex = 0,
  _focusBox
}
function PaGlobalFunc_Customization_PaletteHandle_ClearPalette()
  local self = Customization_PaletteHandleInfo
  self:ClearPalette()
end
function Customization_PaletteHandleInfo:ClearPalette()
  for _, control in pairs(self._colorStatic) do
    if nil ~= control then
      control:SetShow(false)
      UI.deleteControl(control)
    end
  end
  ToClient_padSnapResetControl()
  self._colorStatic = {}
end
function PaGlobalFunc_Customization_PaletteHandle_CreateEyePalette(colorTempate, colorParent, focusBox, classType, paramType, paramIndex, paramIndex2, PaletteIndex, checkBoxLeft, checkBoxRight)
  local self = Customization_PaletteHandleInfo
  self:ClearPalette()
  self._checkBox_LeftEye = checkBoxLeft
  self._checkBox_RightEye = checkBoxRight
  self._focusBox = focusBox
  local count = getPaletteColorCount(PaletteIndex)
  for colorIndex = 0, count - 1 do
    local tempStatic = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, colorParent, "Static_Color_" .. colorIndex)
    CopyBaseProperty(colorTempate, tempStatic)
    tempStatic:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/cus_palette.dds")
    tempStatic:SetShow(true)
    tempStatic:SetSize(self._config._imageSize, self._config._imageSize)
    tempStatic:getBaseTexture():setUV(0, 0, 1, 1)
    tempStatic:SetPosX(25 + colorIndex % self._config._columnCount * self._config._imageSize + colorIndex % self._config._columnCount)
    tempStatic:SetPosY(math.floor(colorIndex / self._config._columnCount) * self._config._imageSize + math.floor(colorIndex / self._config._columnCount))
    tempStatic:setRenderTexture(tempStatic:getBaseTexture())
    local colorTemp = getPaletteColor(PaletteIndex, colorIndex)
    tempStatic:SetColor(Int64toInt32(colorTemp))
    tempStatic:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_PaletteHandle_SetSelectButton(" .. colorIndex .. ")")
    tempStatic:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_PaletteHandle_UpdateEyePalette(" .. classType .. "," .. paramType .. "," .. paramIndex .. "," .. paramIndex2 .. "," .. colorIndex .. ")")
    self._colorStatic[colorIndex] = tempStatic
  end
  local verticalCount = count / self._config._columnCount + 1
  colorParent:SetSize(colorParent:GetSizeX(), verticalCount * (self._config._imageSize + 2))
  colorParent:SetChildIndex(self._focusBox, 9999)
end
function PaGlobalFunc_Customization_PaletteHandle_UpdateEyePalette(classType, paramType, paramIndex, paramIndex2, colorIndex)
  local self = Customization_PaletteHandleInfo
  self._currentColorIndex = colorIndex
  self._focusBox:SetPosX(self._colorStatic[colorIndex]:GetPosX() - 2)
  self._focusBox:SetPosY(self._colorStatic[colorIndex]:GetPosY() - 2)
  self._focusBox:SetShow(true)
  if true == self._checkBox_LeftEye:IsCheck() then
    setParam(classType, paramType, paramIndex, colorIndex)
  end
  if true == self._checkBox_RightEye:IsCheck() then
    setParam(classType, paramType, paramIndex2, colorIndex)
  end
  PaGlobalFunc_Customization_PaletteHandle_SetSelectButton(colorIndex)
end
function PaGlobalFunc_Customization_PaletteHandle_CreateCommonPalette(colorTempate, colorParent, focusBox, classType, paramType, paramIndex, PaletteIndex)
  local self = Customization_PaletteHandleInfo
  self:ClearPalette()
  self._focusBox = focusBox
  local count = getPaletteColorCount(PaletteIndex)
  for colorIndex = 0, count - 1 do
    local tempStatic = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, colorParent, "Static_Color_" .. colorIndex)
    CopyBaseProperty(colorTempate, tempStatic)
    tempStatic:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/cus_palette.dds")
    tempStatic:SetShow(true)
    tempStatic:SetSize(self._config._imageSize, self._config._imageSize)
    tempStatic:getBaseTexture():setUV(0, 0, 1, 1)
    tempStatic:SetPosX(25 + colorIndex % self._config._columnCount * self._config._imageSize + colorIndex % self._config._columnCount)
    tempStatic:SetPosY(math.floor(colorIndex / self._config._columnCount) * self._config._imageSize + math.floor(colorIndex / self._config._columnCount))
    tempStatic:setRenderTexture(tempStatic:getBaseTexture())
    local colorTemp = getPaletteColor(PaletteIndex, colorIndex)
    tempStatic:SetColor(Int64toInt32(colorTemp))
    tempStatic:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_PaletteHandle_SetSelectButton(" .. colorIndex .. ")")
    tempStatic:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_PaletteHandle_UpdateCommonPalette(" .. classType .. "," .. paramType .. "," .. paramIndex .. "," .. colorIndex .. ")")
    self._colorStatic[colorIndex] = tempStatic
  end
  local verticalCount = count / self._config._columnCount + 1
  colorParent:SetSize(colorParent:GetSizeX(), verticalCount * (self._config._imageSize + 2))
  colorParent:SetChildIndex(self._focusBox, 9999)
end
function PaGlobalFunc_Customization_PaletteHandle_UpdateCommonPalette(classType, paramType, paramIndex, colorIndex)
  local self = Customization_PaletteHandleInfo
  self._currentColorIndex = colorIndex
  self._focusBox:SetPosX(self._colorStatic[colorIndex]:GetPosX() - 2)
  self._focusBox:SetPosY(self._colorStatic[colorIndex]:GetPosY() - 2)
  self._focusBox:SetShow(true)
  setParam(classType, paramType, paramIndex, colorIndex)
  PaGlobalFunc_Customization_PaletteHandle_SetSelectButton(colorIndex)
end
function PaGlobalFunc_Customization_PaletteHandle_UpdateFocusBox(colorIndex)
  local self = Customization_PaletteHandleInfo
  local colorControl = self._colorStatic[colorIndex]
  if nil == colorControl or nil == self._focusBox then
    self._focusBox:SetShow(false)
    return
  end
  self._focusBox:SetPosX(colorControl:GetPosX() - 2)
  self._focusBox:SetPosY(colorControl:GetPosY() - 2)
  self._focusBox:SetShow(true)
  self._currentColorIndex = colorIndex
end
function PaGlobalFunc_Customization_PaletteHandle_SetSelectButton(colorIndex)
  local self = Customization_PaletteHandleInfo
  if self._currentColorIndex == colorIndex then
    PaGlobalFunc_Customization_SetKeyGuide(6)
  else
    PaGlobalFunc_Customization_SetKeyGuide(7)
  end
end

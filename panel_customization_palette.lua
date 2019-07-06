local colorStatic = {}
local rgbArr = {}
local Static_SelectMark
local ColumnCount = 10
local imageSize = 25
local currentColorIndex = 0
local checkPalette = function(x, y, static)
  panel_x = 0
  panel_y = 0
  frame = static:getParent()
  panel_x = frame:GetPosX()
  panel_y = frame:GetPosY()
  frame = frame:getParent()
  panel_x = panel_x + frame:GetPosX()
  panel_y = panel_y + frame:GetPosY()
  frame = frame:getParent()
  panel_x = panel_x + frame:GetPosX()
  panel_y = panel_y + frame:GetPosY()
  frame = frame:getParent()
  panel_x = panel_x + frame:GetPosX()
  panel_y = panel_y + frame:GetPosY()
  left = static:GetPosX() + panel_x
  top = static:GetPosY() + panel_y
  right = left + static:GetSizeX()
  bottom = top + static:GetSizeY()
  if x > left and y > top and x < right and y < bottom then
    return true
  end
  return false
end
function UpdatePaletteMarkPosition(index)
  if index ~= -1 then
    Static_SelectMark:SetShow(true)
    Static_SelectMark:SetPosX(index % ColumnCount * imageSize + index % ColumnCount)
    Static_SelectMark:SetPosY(math.floor(index / ColumnCount) * imageSize + math.floor(index / ColumnCount))
  else
    Static_SelectMark:SetShow(false)
  end
end
function CreateCommonPalette(FrameTemplate, ftCollision, classType, paramType, paramIndex, PaletteIndex, isBlend)
  clearPalette()
  local Frame_Content = UI.getChildControl(FrameTemplate, "Frame_Content")
  Static_SelectMark = UI.getChildControl(Frame_Content, "Static_SelectMark")
  Static_SelectMark:SetShow(false)
  local ftContent = UI.getChildControl(FrameTemplate, "Frame_Content")
  local count = getPaletteColorCount(PaletteIndex)
  for colorIndex = 0, count - 1 do
    local luaColorIndex = colorIndex + 1
    local tempStatic = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, ftContent, "Static_Color_" .. colorIndex)
    local color = getPaletteColorRGB(PaletteIndex, colorIndex)
    tempStatic:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/cus_palette.dds")
    tempStatic:SetShow(true)
    tempStatic:SetSize(imageSize, imageSize)
    tempStatic:getBaseTexture():setUV(0, 0, 1, 1)
    tempStatic:SetPosX(colorIndex % ColumnCount * imageSize + colorIndex % ColumnCount)
    tempStatic:SetPosY(math.floor(colorIndex / ColumnCount) * imageSize + math.floor(colorIndex / ColumnCount))
    tempStatic:setRenderTexture(tempStatic:getBaseTexture())
    local colorTemp = getPaletteColor(PaletteIndex, colorIndex, classType, isBlend)
    tempStatic:SetColor(Int64toInt32(colorTemp))
    tempStatic:addInputEvent("Mouse_PressMove", "UpdateCommonPalette(" .. classType .. "," .. paramType .. "," .. paramIndex .. ")")
    tempStatic:addInputEvent("Mouse_LUp", "UpdateCommonPalette(" .. classType .. "," .. paramType .. "," .. paramIndex .. ")")
    colorStatic[luaColorIndex] = tempStatic
  end
  ftCollision:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/cus_palette.dds")
  ftCollision:getBaseTexture():setUV(0, 0, 1, 1)
  ftCollision:addInputEvent("Mouse_LPress", "UpdateCommonPalette(" .. classType .. "," .. paramType .. "," .. paramIndex .. ")")
  ftCollision:addInputEvent("Mouse_LUp", "UpdateCommonPalette(" .. classType .. "," .. paramType .. "," .. paramIndex .. ")")
  ftCollision:SetShow(true)
  ftCollision:SetPosX(FrameTemplate:GetPosX())
  ftCollision:SetPosY(FrameTemplate:GetPosY())
  ftCollision:SetAlpha(0)
  ftCollision:SetSize(imageSize * 10 + 9, math.floor(count / ColumnCount + 0.5) * imageSize + math.floor(count / ColumnCount + 0.5))
  ftCollision:setRenderTexture(ftCollision:getBaseTexture())
  FrameTemplate:SetSize(imageSize * 10 + 9, math.floor(count / ColumnCount + 0.5) * imageSize + math.floor(count / ColumnCount + 0.5))
  FrameTemplate:UpdateContentScroll()
  FrameTemplate:UpdateContentPos()
end
function UpdateCommonPalette(classType, paramType, paramIndex)
  posX = getMousePosX()
  posY = getMousePosY()
  for luaColorIndex = 1, #colorStatic do
    local colorIndex = luaColorIndex - 1
    if true == checkPalette(posX, posY, colorStatic[luaColorIndex]) then
      setParam(classType, paramType, paramIndex, colorIndex)
      UpdatePaletteMarkPosition(colorIndex)
      if currentColorIndex ~= colorIndex then
        add_CurrentHistory()
      end
      currentColorIndex = colorIndex
      return
    end
  end
end
local CheckControlArr = {}
function CreateEyePalette(FrameTemplate, ftCollision, classType, paramType, paramIndex, paramIndex2, PaletteIndex, CheckControl1, CheckControl2)
  clearPalette()
  CheckControlArr[1] = CheckControl1
  CheckControlArr[2] = CheckControl2
  local Frame_Content = UI.getChildControl(FrameTemplate, "Frame_Content")
  Static_SelectMark = UI.getChildControl(Frame_Content, "Static_SelectMark")
  Static_SelectMark:SetShow(false)
  local ftContent = UI.getChildControl(FrameTemplate, "Frame_Content")
  local count = getPaletteColorCount(PaletteIndex)
  for colorIndex = 0, count - 1 do
    local luaColorIndex = colorIndex + 1
    local tempStatic = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, ftContent, "Static_Color_" .. colorIndex)
    local color = getPaletteColorRGB(PaletteIndex, colorIndex)
    tempStatic:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/cus_palette.dds")
    tempStatic:SetShow(true)
    tempStatic:SetSize(imageSize, imageSize)
    tempStatic:getBaseTexture():setUV(0, 0, 1, 1)
    tempStatic:SetPosX(colorIndex % ColumnCount * imageSize + colorIndex % ColumnCount)
    tempStatic:SetPosY(math.floor(colorIndex / ColumnCount) * imageSize + math.floor(colorIndex / ColumnCount))
    tempStatic:setRenderTexture(tempStatic:getBaseTexture())
    local colorTemp = getPaletteColor(PaletteIndex, colorIndex, classType, false)
    tempStatic:SetColor(Int64toInt32(colorTemp))
    tempStatic:addInputEvent("Mouse_PressMove", "UpdateEyePalette(" .. classType .. "," .. paramType .. "," .. paramIndex .. "," .. paramIndex2 .. ")")
    colorStatic[luaColorIndex] = tempStatic
  end
  ftCollision:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/cus_palette.dds")
  ftCollision:getBaseTexture():setUV(0, 0, 1, 1)
  ftCollision:addInputEvent("Mouse_LPress", "UpdateEyePalette(" .. classType .. "," .. paramType .. "," .. paramIndex .. "," .. paramIndex2 .. ")")
  ftCollision:addInputEvent("Mouse_LUp", "UpdateEyePalette(" .. classType .. "," .. paramType .. "," .. paramIndex .. "," .. paramIndex2 .. ")")
  ftCollision:SetShow(true)
  ftCollision:SetPosX(FrameTemplate:GetPosX())
  ftCollision:SetPosY(FrameTemplate:GetPosY())
  ftCollision:SetAlpha(0)
  ftCollision:SetSize(imageSize * 10 + 9, math.floor(count / ColumnCount + 0.5) * imageSize + math.floor(count / ColumnCount + 0.5))
  ftCollision:setRenderTexture(ftCollision:getBaseTexture())
  FrameTemplate:SetSize(imageSize * 10 + 9, math.floor(count / ColumnCount + 0.5) * imageSize + math.floor(count / ColumnCount + 0.5))
  FrameTemplate:UpdateContentScroll()
  FrameTemplate:UpdateContentPos()
end
function UpdateEyePalette(classType, paramType, paramIndex, paramIndex2)
  posX = getMousePosX()
  posY = getMousePosY()
  for luaColorIndex = 1, #colorStatic do
    local colorIndex = luaColorIndex - 1
    if true == checkPalette(posX, posY, colorStatic[luaColorIndex]) then
      if CheckControlArr[1]:IsCheck() == true then
        setParam(classType, paramType, paramIndex, colorIndex)
      end
      if CheckControlArr[2]:IsCheck() == true then
        setParam(classType, paramType, paramIndex2, colorIndex)
      end
      UpdatePaletteMarkPosition(colorIndex)
      if currentColorIndex ~= colorIndex and (CheckControlArr[1]:IsCheck() == true or CheckControlArr[2]:IsCheck() == true) then
        add_CurrentHistory()
      end
      currentColorIndex = colorIndex
      return
    end
  end
end
function clearPalette()
  for _, content in pairs(colorStatic) do
    content:SetShow(false)
    UI.deleteControl(content)
  end
  colorStatic = {}
  rgbArr = {}
end

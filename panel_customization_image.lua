local Button_Close = UI.getChildControl(Panel_CustomizationImage, "Button_Close")
local Static_TitleBG = UI.getChildControl(Panel_CustomizationImage, "Static_ImageBG")
local StaticText_Title = UI.getChildControl(Panel_CustomizationImage, "StaticText_ImageName")
local Static_Image = UI.getChildControl(Panel_CustomizationImage, "Static_Image")
local Button_SizeControl = UI.getChildControl(Panel_CustomizationImage, "Button_SizeControl")
Panel_CustomizationImage:RegisterShowEventFunc(true, "PanelImageShowAni()")
Panel_CustomizationImage:RegisterShowEventFunc(false, "PanelImageHideAni()")
Button_Close:addInputEvent("Mouse_LUp", "closeImagePanel()")
Static_Image:addInputEvent("Mouse_PressMove", "rotateImage()")
Static_Image:addInputEvent("Mouse_LDown", "rotateStart()")
Static_Image:addInputEvent("Mouse_LUp", "rotateEnd()")
Button_SizeControl:addInputEvent("Mouse_LPress", "reSize()")
Static_Image:SetIgnore(false)
StaticText_Title:SetIgnore(true)
Static_TitleBG:SetIgnore(true)
function PanelImageShowAni()
  UIAni.fadeInSCR_MidOut(Panel_CustomizationImage)
end
function PanelImageHideAni()
  UIAni.closeAni(Panel_CustomizationImage)
end
function initImagePanel()
  local titleSizeY = Static_TitleBG:GetSizeY()
  Static_Image:SetPosY(Static_TitleBG:GetPosY() + titleSizeY + 5)
  setFixedTexturePanel(false)
  Button_SizeControl:SetRotate(-(math.pi * 0.5))
  StaticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_TEXTURE_GUIDE"))
end
function openImagePanel()
  Panel_CustomizationImage:SetShow(true, true)
  initImagePanel()
end
function closeImagePanel()
  Panel_CustomizationImage:SetShow(false, true)
end
function setFixedTexturePanel(isFixed)
  Panel_CustomizationImage:SetDragEnable(not isFixed)
  Panel_CustomizationImage:SetDragAll(not isFixed)
  Panel_CustomizationImage:SetIgnore(isFixed)
  Button_Close:SetIgnore(isFixed)
  Static_Image:SetIgnore(isFixed)
end
local mouseDragStartPos, mousePrevPos, mouseCurrentPos
function rotateStart()
  mouseDragStartPos = getMousePosY()
  mousePrevPos = mouseDragStartPos
end
function rotateEnd()
end
function loadImage(index)
  setProjectionTexture(index, Static_Image)
  StaticText_Title:SetText(string.format("customization_%.2d", index))
end
function rotateImage(value)
  local radian = value * 2 * math.pi
  Static_Image:SetRotate(radian)
end
function alphaImage(value)
  Static_Image:SetAlpha(1 - value)
end
local compValue = 2
function scaleImage(xValue, yValue)
  Static_Image:SetScale(xValue * compValue, yValue * compValue)
  local titleSize = Static_TitleBG:GetSize()
  Static_Image:SetPosY(Static_TitleBG:GetPosY() + titleSize.y + 5)
end
local limitSizeX = 100
local limitSizeY = 100
function reSize()
  local panelSizeX = Panel_CustomizationImage:GetSizeX()
  local panelSizeY = Panel_CustomizationImage:GetSizeY()
  local origEndX = Panel_CustomizationImage:GetPosX() + panelSizeX
  local origEndY = Panel_CustomizationImage:GetPosY() + panelSizeY
  local extendSizeX = getMousePosX() - origEndX
  local extendSizeY = getMousePosY() - origEndY
  local sizeX = extendSizeX + panelSizeX
  local sizeY = extendSizeY + panelSizeY
  if sizeX < limitSizeX then
    sizeX = limitSizeX
  end
  if sizeY < limitSizeY then
    sizeY = limitSizeY
  end
  Panel_CustomizationImage:SetSize(sizeX, sizeY)
  local imageSizeX = Static_Image:GetSizeX() + extendSizeX
  local imageSizeY = Static_Image:GetSizeY() + extendSizeY
  if imageSizeX < limitSizeX then
    imageSizeX = limitSizeX
  end
  if imageSizeY < limitSizeY then
    imageSizeY = limitSizeY
  end
  Static_Image:SetSize(imageSizeX, imageSizeY)
  Static_Image:ComputePos()
  Static_TitleBG:ComputePos()
  StaticText_Title:ComputePos()
  Button_SizeControl:SetVerticalBottom()
end

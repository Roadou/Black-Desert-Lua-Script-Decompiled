local Frame_ContentImage = UI.getChildControl(Panel_CustomizationExpression, "Frame_Content_Image")
local StaticText_Title = UI.getChildControl(Panel_CustomizationExpression, "StaticText_Title")
local Static_SelectMark = UI.getChildControl(Panel_CustomizationExpression, "Static_SelectMark")
StaticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONEXPRESSION_EXPRESSION"))
local textureColumnCount = 4
local ColumnCount = 5
local ImageGap = 5
local columnWidth = Frame_ContentImage:GetSizeX() + ImageGap
local columnHeight = Frame_ContentImage:GetSizeY() + ImageGap
local contentsOffsetX = 20
local contentsOffsetY = 60
local ContentImage = {}
local Button_Close = UI.getChildControl(Panel_CustomizationExpression, "Button_Close")
Button_Close:addInputEvent("Mouse_LUp", "closeExpressionUI()")
registerEvent("EventOpenExpressionUI", "openExpressionUI")
registerEvent("EventCloseExpressionUI", "closeExpressionUI")
local function UpdateMarkPosition(presetIndex)
  if presetIndex ~= -1 then
    Static_SelectMark:SetShow(true)
    Static_SelectMark:SetPosX(presetIndex % ColumnCount * columnWidth + contentsOffsetX)
    Static_SelectMark:SetPosY(math.floor(presetIndex / ColumnCount) * columnHeight + contentsOffsetY)
  else
    Static_SelectMark:SetShow(false)
  end
end
local function clearContentList()
  for _, content in pairs(ContentImage) do
    content:SetShow(false)
    UI.deleteControl(content)
  end
  ContentImage = {}
end
function createExpressionList()
  clearContentList()
  local count = getExpressionCount()
  local textureName = getExpressionTextureName()
  local texSize = 48.25
  for itemIdx = 0, count - 1 do
    local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CustomizationExpression, "Frame_Image_" .. itemIdx)
    CopyBaseProperty(Frame_ContentImage, tempContentImage)
    tempContentImage:addInputEvent("Mouse_LUp", "UpdateExpression(" .. itemIdx .. ")")
    local mod = itemIdx % textureColumnCount
    local divi = math.floor(itemIdx / textureColumnCount)
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
    tempContentImage:ChangeTextureInfoName("New_UI_Common_ForLua/Window/Lobby/" .. textureName)
    local x1, y1, x2, y2 = setTextureUV_Func(tempContentImage, texUV.x1, texUV.y1, texUV.x2, texUV.y2)
    tempContentImage:getBaseTexture():setUV(x1, y1, x2, y2)
    tempContentImage:SetPosX(itemIdx % ColumnCount * columnWidth + contentsOffsetX)
    tempContentImage:SetPosY(math.floor(itemIdx / ColumnCount) * columnHeight + contentsOffsetY)
    tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
    tempContentImage:SetShow(true)
    ContentImage[itemIdx] = tempContentImage
  end
end
function UpdateExpression(index)
  UpdateMarkPosition(index)
  applyExpression(index, 1)
end
function openExpressionUI()
  UpdateMarkPosition(-1)
  createExpressionList()
  Panel_CustomizationExpression:SetShow(true)
  CloseFrameForPoseUI()
  Panel_CustomizationExpression:SetPosX(Panel_CustomizationFrame:GetPosX())
  Panel_CustomizationExpression:SetPosY(Panel_CustomizationFrame:GetPosY())
  setPresetCamera(2)
end
function closeExpressionUI()
  if Panel_CustomizationImage:GetShow() then
    CloseTextureUi()
    return
  end
  Panel_CustomizationExpression:SetShow(false)
  Panel_CustomizationFrame:SetPosX(Panel_CustomizationExpression:GetPosX())
  Panel_CustomizationFrame:SetPosY(Panel_CustomizationExpression:GetPosY())
  clearContentList()
  CustomizationMainUIShow(true)
  selectPoseControl(0)
  setPresetCamera(10)
  applyExpression(-1, 1)
end

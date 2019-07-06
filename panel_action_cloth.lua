local Frame_ContentImage = UI.getChildControl(Panel_CustomizationCloth, "Frame_Content_Image")
local Static_Frame = UI.getChildControl(Panel_CustomizationCloth, "Static_Frame")
local StaticText_Title = UI.getChildControl(Panel_CustomizationCloth, "StaticText_Title")
local Static_SelectMark = UI.getChildControl(Panel_CustomizationCloth, "Static_SelectMark")
local Button_Close = UI.getChildControl(Panel_CustomizationCloth, "Button_Close")
local StaticText_ShowHelmet = UI.getChildControl(Panel_CustomizationCloth, "StaticText_ShowHelmet")
local CheckButton_ShowHelmet = UI.getChildControl(Panel_CustomizationCloth, "CheckButton_ShowHelmet")
StaticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONCLOTH_DRESS_FITTING"))
StaticText_ShowHelmet:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONCLOTH_SHOWHELMET"))
local textureColumnCount = 4
local ColumnCount = 5
local clothImageGap = 5
local contentsGap = 10
local columnWidth = Frame_ContentImage:GetSizeX() + clothImageGap
local columnHeight = Frame_ContentImage:GetSizeY() + clothImageGap
local frameStartY = 50
local contentsOffsetX = 20
local contentsOffsetY = 60
local image
local ContentImage = {}
Button_Close:addInputEvent("Mouse_LUp", "closeClothUI()")
CheckButton_ShowHelmet:addInputEvent("Mouse_LUp", "ShowHelmet()")
if false == _ContentsGroup_RenewUI_Customization then
  registerEvent("EventOpenClothUI", "openClothUI")
  registerEvent("EventCloseClothUI", "closeClothUI")
end
local function UpdateMarkPosition(index)
  if index ~= -1 then
    Static_SelectMark:SetShow(true)
    Static_SelectMark:SetPosX(index % ColumnCount * columnWidth + contentsOffsetX)
    Static_SelectMark:SetPosY(math.floor(index / ColumnCount) * columnHeight + contentsOffsetY)
  else
    Static_SelectMark:SetShow(false)
  end
end
function UpdateCloth(index)
  UpdateMarkPosition(index)
  applyCloth(index)
end
local function clearContentList()
  for _, content in pairs(ContentImage) do
    content:SetShow(false)
    UI.deleteControl(content)
  end
  ContentImage = {}
end
function createClothList()
  clearContentList()
  local count = getClothCount()
  local textureName = getClothTextureName()
  local texSize = 48.25
  for itemIdx = 0, count - 1 do
    local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CustomizationCloth, "Frame_Image_" .. itemIdx)
    CopyBaseProperty(Frame_ContentImage, tempContentImage)
    tempContentImage:addInputEvent("Mouse_LUp", "UpdateCloth(" .. itemIdx .. ")")
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
  local totalImageHeight = contentsGap + (math.floor((count - 1) / ColumnCount) + 1) * columnHeight
  local showHelmetStartY = frameStartY + totalImageHeight
  CheckButton_ShowHelmet:SetPosY(showHelmetStartY)
  StaticText_ShowHelmet:SetPosY(showHelmetStartY)
  local FrameSizeY = totalImageHeight + CheckButton_ShowHelmet:GetSizeY() + contentsGap
  Static_Frame:SetSize(Static_Frame:GetSizeX(), FrameSizeY)
  Panel_CustomizationCloth:SetSize(Panel_CustomizationCloth:GetSizeX(), frameStartY + FrameSizeY + contentsGap)
end
function openClothUI(showHelmet)
  UpdateMarkPosition(-1)
  createClothList()
  CheckButton_ShowHelmet:SetCheck(showHelmet)
  Panel_CustomizationCloth:SetShow(true)
  CloseFrameForPoseUI()
  Panel_CustomizationCloth:SetPosX(Panel_CustomizationFrame:GetPosX())
  Panel_CustomizationCloth:SetPosY(Panel_CustomizationFrame:GetPosY())
end
function closeClothUI()
  if Panel_CustomizationTextureMenu:GetShow() then
    CloseTextureUi()
    return
  end
  Panel_CustomizationCloth:SetShow(false)
  Panel_CustomizationFrame:SetPosX(Panel_CustomizationCloth:GetPosX())
  Panel_CustomizationFrame:SetPosY(Panel_CustomizationCloth:GetPosY())
  clearContentList()
  CustomizationMainUIShow(true)
  selectPoseControl(0)
end
function ShowHelmet()
  setShowHelmet(CheckButton_ShowHelmet:IsCheck())
end

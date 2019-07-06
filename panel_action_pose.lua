local FrameTemplate = UI.getChildControl(Panel_CustomizationMotion, "Frame_Template")
local Frame_Content = UI.getChildControl(FrameTemplate, "Frame_Content")
local Frame_ContentImage = UI.getChildControl(Frame_Content, "Frame_Content_Image")
local Frame_Scroll = UI.getChildControl(FrameTemplate, "Frame_Scroll")
local Static_SelectMark = UI.getChildControl(Frame_Content, "Static_SelectMark")
local Static_Frame = UI.getChildControl(Panel_CustomizationMotion, "Static_Frame")
local Button_Close = UI.getChildControl(Panel_CustomizationMotion, "Button_Close")
local StaticText_Title = UI.getChildControl(Panel_CustomizationMotion, "StaticText_Title")
local selectedClassType
StaticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMOTION_STATICTEXT_TITLE"))
Button_Close:addInputEvent("Mouse_LUp", "closeMotionUi()")
local textureColumnCount = 4
local ColumnCount = 4
local ImageGap = 10
local columnWidth = Frame_ContentImage:GetSizeX() + ImageGap
local columnHeight = Frame_ContentImage:GetSizeY() + ImageGap
local contentsOffsetX = 10
local contentsOffsetY = 10
local ContentImage = {}
local none = 100
local social = 1000
local combat = 2000
local MotionTable = {
  [0] = social,
  [1] = social,
  [2] = social,
  [3] = social,
  [4] = social,
  [5] = social,
  [6] = social,
  [7] = social,
  [8] = social,
  [9] = social,
  [10] = social,
  [11] = social,
  [12] = social,
  [13] = social,
  [14] = social,
  [15] = social,
  [16] = social,
  [17] = social,
  [18] = social,
  [19] = social,
  [20] = social,
  [21] = social,
  [22] = social,
  [23] = social,
  [24] = social,
  [25] = social,
  [26] = social,
  [27] = social,
  [28] = social,
  [29] = social,
  [30] = social,
  [31] = social,
  [32] = social,
  [33] = social,
  [34] = social,
  [35] = social,
  [36] = social,
  [37] = combat,
  [38] = combat,
  [39] = combat
}
if false == _ContentsGroup_RenewUI_Customization then
  registerEvent("EventOpenMotionUI", "openMotionUi")
  registerEvent("EventCloseMotionUI", "closeMotionUi")
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
local function clearContentList()
  for _, content in pairs(ContentImage) do
    content:SetShow(false)
    UI.deleteControl(content)
  end
  ContentImage = {}
end
function createMotionList()
  clearContentList()
  local count = getMotionCount(selectedClassType)
  local textureName = getMotionTextureName(selectedClassType)
  local texSize = 48.25
  for itemIdx = 0, count - 1 do
    if MotionTable[itemIdx] == social then
      local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Frame_Content, "Frame_Image_" .. itemIdx)
      CopyBaseProperty(Frame_ContentImage, tempContentImage)
      tempContentImage:addInputEvent("Mouse_LUp", "UpdateMotion(" .. itemIdx .. ")")
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
  FrameTemplate:UpdateContentScroll()
  Frame_Scroll:SetControlTop()
  FrameTemplate:UpdateContentPos()
  FrameTemplate:SetShow(true)
  Static_Frame:SetSize(Static_Frame:GetSizeX(), FrameTemplate:GetSizeY() + 20)
  Panel_CustomizationMotion:SetSize(Panel_CustomizationMotion:GetSizeX(), FrameTemplate:GetPosY() + FrameTemplate:GetSizeY() + 20)
end
function UpdateMotion(index)
  applyMotion(index)
  UpdateMarkPosition(index)
end
function openMotionUi(classType)
  UpdateMarkPosition(-1)
  clearAllPoseBone()
  selectedClassType = classType
  createMotionList()
  PaGlobal_SetIgnoreCameraLook(true)
  Panel_CustomizationMotion:SetShow(true)
  CloseFrameForPoseUI()
  Panel_CustomizationMotion:SetPosX(Panel_CustomizationFrame:GetPosX())
  Panel_CustomizationMotion:SetPosY(Panel_CustomizationFrame:GetPosY())
  setPresetCamera(4)
end
function closeMotionUi()
  if Panel_CustomizationImage:GetShow() then
    CloseTextureUi()
    return
  end
  PaGlobal_SetIgnoreCameraLook(false)
  Panel_CustomizationMotion:SetShow(false)
  Panel_CustomizationFrame:SetPosX(Panel_CustomizationMotion:GetPosX())
  Panel_CustomizationFrame:SetPosY(Panel_CustomizationMotion:GetPosY())
  applyMotion(-1)
  clearContentList()
  CustomizationMainUIShow(true)
  selectPoseControl(0)
  setPresetCamera(10)
end

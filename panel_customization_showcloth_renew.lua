Panel_Customizing_ShowOutfit:ignorePadSnapMoveToOtherPanel()
local Customization_ShowClothInfo = {
  _ui = {
    _static_TypeGroup = UI.getChildControl(Panel_Customizing_ShowOutfit, "Static_TypeGroup"),
    _checkBox_ShowHelmet = UI.getChildControl(Panel_Customizing_ShowOutfit, "CheckButton_ShowPart")
  },
  _config = {
    _textureColumnCount = 4,
    _columnCount = 5,
    _clothImageGap = 5,
    _contentsGap = 10,
    _columnWidth,
    _columnHeight,
    _contentsOffsetX = 20,
    _contentsOffsetY = 60
  },
  _selectedClassType,
  _currentContentIndex = 0,
  _contentImage = {},
  _isBoneControl = false
}
function Customization_ShowClothInfo:ClearContent()
  for _, content in pairs(self._contentImage) do
    if nil ~= content then
      content:SetShow(false)
      UI.deleteControl(content)
    end
  end
  ToClient_padSnapResetControl()
  self._contentImage = {}
end
function Customization_ShowClothInfo:UpdateFocus(index)
  if nil ~= self._contentImage[index] then
    self._ui._typeSelect:SetPosX(self._contentImage[index]:GetPosX())
    self._ui._typeSelect:SetPosY(self._contentImage[index]:GetPosY())
    self._ui._typeSelect:SetShow(true)
  else
    self._ui._typeSelect:SetShow(false)
  end
  self._currentContentIndex = index
end
function PaGlobalFunc_Customization_ShowCloth_ShowHelmet()
  local self = Customization_ShowClothInfo
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  setShowHelmet(self._ui._checkBox_ShowHelmet:IsCheck())
end
function PaGlobalFunc_Customization_ShowCloth_SetSelectButton(index)
  local self = Customization_ShowClothInfo
  if self._currentContentIndex == index then
    PaGlobalFunc_Customization_SetKeyGuide(6)
  else
    PaGlobalFunc_Customization_SetKeyGuide(7)
  end
end
function PaGlobalFunc_Customization_ShowCloth_UpdateCloth(index)
  local self = Customization_ShowClothInfo
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  self:UpdateFocus(index)
  applyCloth(index)
end
function Customization_ShowClothInfo:CreateClothlist()
  self:ClearContent()
  local count = getClothCount(self._selectedClassType)
  local textureName = getClothTextureName(self._selectedClassType)
  local texSize = 48.25
  for itemIdx = 0, count - 1 do
    local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_TypeGroup, "Frame_Image_" .. itemIdx)
    CopyBaseProperty(self._ui._radioButton_TypeTemplate, tempContentImage)
    tempContentImage:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_ShowCloth_UpdateCloth(" .. itemIdx .. ")")
    tempContentImage:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_ShowCloth_SetSelectButton(" .. itemIdx .. ")")
    local mod = itemIdx % self._config._textureColumnCount
    local divi = math.floor(itemIdx / self._config._textureColumnCount)
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
    tempContentImage:SetPosX(itemIdx % self._config._columnCount * self._config._columnWidth + self._config._contentsOffsetX)
    tempContentImage:SetPosY(-48 + math.floor(itemIdx / self._config._columnCount) * self._config._columnHeight + self._config._contentsOffsetY)
    tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
    tempContentImage:SetShow(true)
    self._contentImage[itemIdx] = tempContentImage
  end
  ToClient_padSnapRefreshTarget(self._ui._static_TypeGroup)
  local verticalCount = count / self._config._columnCount + 1
  if 0 < count % self._config._columnCount then
    verticalCount = verticalCount + 1
  end
  Panel_Customizing_ShowOutfit:SetSize(Panel_Customizing_ShowOutfit:GetSizeX(), verticalCount * self._config._columnWidth + self._config._contentsOffsetX + 20)
end
function PaGlobalFunc_Customization_ShowCloth_OpenClothUI(classType, showHelmet)
  local self = Customization_ShowClothInfo
  self._selectedClassType = classType
  self:UpdateFocus(-1)
  self:CreateClothlist()
  self._ui._checkBox_ShowHelmet:SetCheck(showHelmet)
  PaGlobalFunc_Customization_ShowCloth_ShowHelmet()
  PaGlobalFunc_Customization_ShowCloth_Open()
end
function PaGlobalFunc_Customization_ShowCloth_CloseClothUI()
  local self = Customization_ShowClothInfo
  self:ClearContent()
  selectPoseControl(0)
  PaGlobalFunc_Customization_ShowCloth_Close()
end
function Customization_ShowClothInfo:InitControl()
  self._ui._radioButton_TypeTemplate = UI.getChildControl(self._ui._static_TypeGroup, "RadioButton_TypeImage_Template")
  self._ui._radioButton_TypeTemplate:SetShow(false)
  self._ui._typeSelect = UI.getChildControl(self._ui._static_TypeGroup, "Static_SelectedSlot")
  self._ui._typeSelect:SetShow(false)
  self._config._columnHeight = self._ui._radioButton_TypeTemplate:GetSizeX() + self._config._clothImageGap
  self._config._columnWidth = self._ui._radioButton_TypeTemplate:GetSizeY() + self._config._clothImageGap
  self._ui._checkBox_ShowHelmet:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONCLOTH_SHOWHELMET"))
end
function Customization_ShowClothInfo:InitEvent()
  self._ui._checkBox_ShowHelmet:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_ShowCloth_ShowHelmet()")
end
function Customization_ShowClothInfo:InitRegister()
  registerEvent("EventOpenClothUI", "PaGlobalFunc_Customization_ShowCloth_OpenClothUI")
  registerEvent("EventCloseClothUI", "PaGlobalFunc_Customization_ShowCloth_CloseClothUI")
end
function Customization_ShowClothInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function PaGlobalFunc_FromClient_Customization_ShowCloth_luaLoadComplete()
  local self = Customization_ShowClothInfo
  self:Initialize()
end
function PaGlobalFunc_Customization_ShowCloth_Close()
  local self = Customization_ShowClothInfo
  if false == PaGlobalFunc_Customization_ShowCloth_GetShow() then
    return false
  end
  PaGlobalFunc_Customization_SetCloseFunc(nil)
  PaGlobalFunc_Customization_SetBackEvent()
  PaGlobalFunc_Customization_ShowCloth_SetShow(false, false)
  return true
end
function PaGlobalFunc_Customization_ShowCloth_Open()
  if true == PaGlobalFunc_Customization_ShowCloth_GetShow() then
    return
  end
  PaGlobalFunc_Customization_ShowCloth_SetShow(true, false)
  PaGlobalFunc_Customization_KeyGuideSetShow(true)
  PaGlobalFunc_Customization_SetKeyGuide(7)
  PaGlobalFunc_Customization_SetCloseFunc(PaGlobalFunc_Customization_ShowCloth_Close)
  PaGlobalFunc_Customization_SetBackEvent("PaGlobalFunc_Customization_ShowCloth_Close()")
end
function PaGlobalFunc_Customization_ShowCloth_SetShow(isShow, isAni)
  Panel_Customizing_ShowOutfit:SetShow(isShow, isAni)
end
function PaGlobalFunc_Customization_ShowCloth_GetShow()
  return Panel_Customizing_ShowOutfit:GetShow()
end
function PaGlobalFunc_Customization_ShowCloth_GetPanel()
  return Panel_Customizing_ShowOutfit
end
PaGlobalFunc_FromClient_Customization_ShowCloth_luaLoadComplete()

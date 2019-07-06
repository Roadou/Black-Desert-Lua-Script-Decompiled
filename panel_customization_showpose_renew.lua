Panel_Customizing_ShowPose:ignorePadSnapMoveToOtherPanel()
local Customization_ShowPoseInfo = {
  _ui = {
    _static_TypeGroup = UI.getChildControl(Panel_Customizing_ShowPose, "Static_TypeGroup")
  },
  _config = {
    _textureColumnCount = 4,
    _columnCount = 4,
    _imageGap = 6,
    _columnWidth,
    _columnHeight,
    _contentsOffsetX = 6,
    _contentsOffsetY = 6
  },
  _contentImage = {},
  _selectedClassType,
  _isBoneControl = false
}
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
function Customization_ShowPoseInfo:ClearContent()
  for _, content in pairs(self._contentImage) do
    if nil ~= content then
      content:SetShow(false)
      UI.deleteControl(content)
    end
  end
  ToClient_padSnapResetControl()
  self._contentImage = {}
end
function Customization_ShowPoseInfo:UpdateFocus(index)
  if -1 ~= index then
    self._ui._static_typeSelect:SetPosX(self._contentImage[index]:GetPosX())
    self._ui._static_typeSelect:SetPosY(self._contentImage[index]:GetPosY())
    self._ui._static_typeSelect:SetShow(true)
  else
    self._ui._static_typeSelect:SetShow(false)
  end
end
function PaGlobalFunc_Customization_ShowPose_UpdateMotion(index)
  local self = Customization_ShowPoseInfo
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  applyMotion(index)
  self:UpdateFocus(index)
end
function Customization_ShowPoseInfo:CreateMotionList()
  self:ClearContent()
  local count = getMotionCount(self._selectedClassType)
  local textureName = getMotionTextureName(self._selectedClassType)
  local texSize = 48.25
  for itemIdx = 0, count - 1 do
    if MotionTable[itemIdx] == social then
      local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_TypeGroup, "Frame_Image_" .. itemIdx)
      CopyBaseProperty(self._ui._radioButton_TypeTemplate, tempContentImage)
      tempContentImage:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_ShowPose_UpdateMotion(" .. itemIdx .. ")")
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
      tempContentImage:SetPosX(10 + itemIdx % (self._config._columnCount + 1) * self._config._columnWidth + self._config._contentsOffsetX)
      tempContentImage:SetPosY(math.floor(itemIdx / (self._config._columnCount + 1)) * self._config._columnHeight + self._config._contentsOffsetY)
      tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
      tempContentImage:SetShow(true)
      self._contentImage[itemIdx] = tempContentImage
    end
  end
  ToClient_padSnapRefreshTarget(self._ui._static_TypeGroup)
end
function PaGlobalFunc_Customization_ShowPose_OpenMotionUi(classType)
  local self = Customization_ShowPoseInfo
  self:UpdateFocus(-1)
  clearAllPoseBone()
  self._selectedClassType = classType
  self:CreateMotionList()
  setPresetCamera(4)
  PaGlobalFunc_Customization_ShowPose_Open()
end
function PaGlobalFunc_Customization_ShowPose_closeMotionUi()
  local self = Customization_ShowPoseInfo
  PaGlobalFunc_Customization_ShowPose_Close()
end
function Customization_ShowPoseInfo:InitControl()
  self._ui._radioButton_TypeTemplate = UI.getChildControl(self._ui._static_TypeGroup, "RadioButton_TypeImage_Template")
  self._ui._radioButton_TypeTemplate:SetShow(false)
  self._ui._static_typeSelect = UI.getChildControl(self._ui._static_TypeGroup, "Static_SelectedSlot")
  self._ui._static_typeSelect:SetShow(false)
  self._config._columnWidth = self._ui._radioButton_TypeTemplate:GetSizeX() + self._config._imageGap
  self._config._columnHeight = self._ui._radioButton_TypeTemplate:GetSizeY() + self._config._imageGap
end
function Customization_ShowPoseInfo:InitEvent()
end
function Customization_ShowPoseInfo:InitRegister()
  registerEvent("EventOpenMotionUI", "PaGlobalFunc_Customization_ShowPose_OpenMotionUi")
  registerEvent("EventCloseMotionUI", "PaGlobalFunc_Customization_ShowPose_closeMotionUi")
end
function Customization_ShowPoseInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function PaGlobalFunc_FromClient_Customization_ShowPose_luaLoadComplete()
  local self = Customization_ShowPoseInfo
  self:Initialize()
end
function PaGlobalFunc_Customization_ShowPose_Close()
  local self = Customization_ShowPoseInfo
  if false == PaGlobalFunc_Customization_ShowPose_GetShow() then
    return false
  end
  if true == self._isBoneControl then
    return false
  end
  applyMotion(-1)
  selectPoseControl(0)
  setPresetCamera(10)
  PaGlobalFunc_Customization_SetCloseFunc(nil)
  PaGlobalFunc_Customization_SetBackEvent()
  PaGlobalFunc_Customization_ShowPose_SetShow(false, false)
  return true
end
function PaGlobalFunc_Customization_ShowPose_Open()
  if true == PaGlobalFunc_Customization_ShowPose_GetShow() then
    return
  end
  PaGlobalFunc_Customization_ShowPose_SetShow(true, false)
  PaGlobalFunc_Customization_KeyGuideSetShow(true)
  PaGlobalFunc_Customization_SetKeyGuide(7)
  PaGlobalFunc_Customization_SetCloseFunc(PaGlobalFunc_Customization_ShowPose_Close)
  PaGlobalFunc_Customization_SetBackEvent("PaGlobalFunc_Customization_ShowPose_Close()")
end
function PaGlobalFunc_Customization_ShowPose_SetShow(isShow, isAni)
  Panel_Customizing_ShowPose:SetShow(isShow, isAni)
end
function PaGlobalFunc_Customization_ShowPose_GetShow()
  return Panel_Customizing_ShowPose:GetShow()
end
function PaGlobalFunc_Customization_ShowPose_GetPanel()
  return Panel_Customizing_ShowPose
end
PaGlobalFunc_FromClient_Customization_ShowPose_luaLoadComplete()

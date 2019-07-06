Panel_Customizing_Voice:ignorePadSnapMoveToOtherPanel()
local Customization_VoiceInfo = {
  _ui = {
    _static_TypeGroup = UI.getChildControl(Panel_Customizing_Voice, "Static_TypeGroup"),
    _static_SliderGroup = UI.getChildControl(Panel_Customizing_Voice, "Static_SliderGroup"),
    _static_motionGroup = UI.getChildControl(Panel_Customizing_Voice, "Static_PoseGroup"),
    _static_KeyGuideBg = UI.getChildControl(Panel_Customizing_Voice, "Static_KeyGuideBg")
  },
  _config = {
    _const_UsebleMotionbyServiceArea = false,
    _noCashType = CppEnums.CustomizationNoCashType,
    _noCashMesh = CppEnums.CustomizationNoCashMesh,
    _noCashDeco = CppEnums.CustomizationNoCashDeco,
    _noCashVoice = CppEnums.CustomizationNoCashVoice,
    _contentsOffsetX = 10,
    _contentsOffsetY = 60,
    _columnMaxIndex = 3,
    _textureColumnCount = 4,
    _columnCount = 5,
    _imageGap = 6,
    _columnWidth,
    _columnHeight,
    _motionImageGap = 6,
    _motionContentsOffsetX = 10,
    _motionContentsOffsetY = 10,
    _motionColumnWidth,
    _motionColumnHeight
  },
  _voiceCount = 1,
  _typeImage = {},
  _typeCount = {},
  _contentsMotionImage = {},
  _selectMotionIndex = -1,
  _isInitmotionIndex = false,
  _currentVoiceIndex = -1,
  _selectedClassType,
  _selectedVoiceIndex = -1,
  _selectedRealIndex = -1,
  _selectedInGameMode = nil,
  _isIngameMode = false,
  _columnIndex = -1,
  _lastSocialControl = nil,
  _lastCombatControl = nil,
  _isBoneControl = false
}
local none = 100
local social = 1000
local combat = 2000
local MotionTable = {
  [0] = none,
  [1] = none,
  [2] = none,
  [3] = none,
  [4] = none,
  [5] = social,
  [6] = social,
  [7] = social,
  [8] = none,
  [9] = social,
  [10] = none,
  [11] = social,
  [12] = none,
  [13] = none,
  [14] = none,
  [15] = none,
  [16] = none,
  [17] = none,
  [18] = none,
  [19] = none,
  [20] = none,
  [21] = none,
  [22] = none,
  [23] = social,
  [24] = none,
  [25] = social,
  [26] = social,
  [27] = none,
  [28] = none,
  [29] = none,
  [30] = social,
  [31] = none,
  [32] = none,
  [33] = social,
  [34] = none,
  [35] = none,
  [36] = none,
  [37] = combat,
  [38] = combat,
  [39] = combat
}
function Customization_VoiceInfo:ClearContentList()
  for _, content in pairs(self._typeImage) do
    if nil ~= content then
      content:SetShow(false)
      UI.deleteControl(content)
    end
  end
  self._typeImage = {}
  for _, content in pairs(self._typeCount) do
    if nil ~= content then
      content:SetShow(false)
      UI.deleteControl(content)
    end
  end
  self._typeCount = {}
  for _, content in pairs(self._contentsMotionImage) do
    if nil ~= content then
      content:SetShow(false)
      UI.deleteControl(content)
    end
  end
  self._contentsMotionImage = {}
  ToClient_padSnapResetControl()
end
function Customization_VoiceInfo:Voice_SetSize(index)
end
function Customization_VoiceInfo:Check_ServiceArea()
end
function Customization_VoiceInfo:UpdateVoice()
  self:UpdateVoiceFocus(self._selectedVoiceIndex)
  if true == _ContentsGroup_isContentsCustomizationVoice then
    applyVoice(self._selectedVoiceIndex, false)
  else
    applyVoice(self._selectedVoiceIndex, true)
  end
end
function PaGlobalFunc_Customization_Voice_UpdateVoiceMessage(index)
  local self = Customization_VoiceInfo
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  self:UpdateVoiceFocus(index)
  self:UpdateVoice()
  applyMotion(self._selectMotionIndex)
end
function PaGlobalFunc_Customization_Voice_Update_Motion(index)
  local self = Customization_VoiceInfo
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  self:UpdateMotionFocus(index)
  applyMotion(index)
end
function PaGlobalFunc_Customization_Voice_CreateVoiceList(inGameMode, classType)
  local self = Customization_VoiceInfo
  self:ClearContentList()
  self._isIngameMode = inGameMode
  self._selectedClassType = classType
  local texWidth = 48
  local texHeight = 48
  local texColumCount = 4
  self._voiceCount = getClassVoiceCount()
  for itemIdx = 0, self._voiceCount - 1 do
    local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_TypeGroup, "Frame_Image_" .. itemIdx)
    CopyBaseProperty(self._ui._radioButton_TypeTemplate, tempContentImage)
    tempContentImage:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_Voice_UpdateVoiceMessage(" .. itemIdx .. ")")
    tempContentImage:SetPosX(itemIdx % self._config._columnCount * self._config._columnWidth + self._config._contentsOffsetX)
    tempContentImage:SetPosY(-48 + math.floor(itemIdx / self._config._columnCount) * self._config._columnHeight + self._config._contentsOffsetY)
    tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
    tempContentImage:SetShow(true)
    tempContentImage:SetText(itemIdx + 1)
    self._typeImage[itemIdx] = tempContentImage
    self._typeCount[itemIdx] = tempVoiceCount
  end
  ToClient_padSnapRefreshTarget(self._ui._static_TypeGroup)
  self:Voice_SetSize(self._config._columnMaxIndex)
  self:Check_ServiceArea()
  self._isInitmotionIndex = false
  local lastSocialControl, lastCombatControl
  local count = getMotionCount(self._selectedClassType)
  local textureName = getMotionTextureName()
  local texSize = 48.25
  local createIndex = 0
  for itemIdx = 0, count - 1 do
    if MotionTable[itemIdx] == social then
      local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_motionGroup, "Frame_MotionImage_" .. createIndex)
      CopyBaseProperty(self._ui._radioButton_motionTemplate, tempContentImage)
      tempContentImage:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_Voice_Update_Motion(" .. itemIdx .. ")")
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
      tempContentImage:SetPosX(createIndex % self._config._columnCount * self._config._motionColumnWidth + self._config._motionContentsOffsetX)
      tempContentImage:SetPosY(math.floor(createIndex / self._config._columnCount) * self._config._motionColumnHeight + self._config._motionContentsOffsetY)
      tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
      tempContentImage:SetShow(true)
      self._contentsMotionImage[itemIdx] = tempContentImage
      createIndex = createIndex + 1
      if false == self._isInitmotionIndex then
        self._isInitmotionIndex = true
        self:UpdateMotionFocus(itemIdx)
      end
    end
  end
  ToClient_padSnapRefreshTarget(self._ui._static_motionGroup)
  createIndex = math.floor((createIndex - 1) / self._config._columnCount) * self._config._columnCount + self._config._columnCount
  for itemIdx = 0, count - 1 do
    if MotionTable[itemIdx] == combat then
      local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_motionGroup, "Frame_MotionImage_" .. createIndex)
      CopyBaseProperty(self._ui._radioButton_motionTemplate, tempContentImage)
      tempContentImage:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_Voice_Update_Motion(" .. itemIdx .. ")")
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
      tempContentImage:SetPosX(createIndex % self._config._columnCount * self._config._motionColumnWidth + self._config._motionContentsOffsetX)
      tempContentImage:SetPosY(math.floor(createIndex / self._config._columnCount) * self._config._motionColumnHeight + self._config._motionContentsOffsetY)
      tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
      tempContentImage:SetShow(true)
      self._contentsMotionImage[itemIdx] = tempContentImage
      createIndex = createIndex + 1
    end
  end
  ToClient_padSnapRefreshTarget(self._ui._static_motionGroup)
  self._ui._slider_Voice:SetControlPos(getVoicePitch())
  PaGlobalFunc_Customization_Voice_UpdateSlide()
  PaGlobalFunc_Customization_Voice_Open()
end
function PaGlobalFunc_Customization_Voice_CloseVoiceUI()
  applyMotion(-1)
  selectPoseControl(0)
  PaGlobalFunc_Customization_Voice_Close()
end
function PaGlobalFunc_Customization_Voice_ResetFocus()
  self._selectedVoiceIndex = 0
  Customization_VoiceInfo:UpdateVoiceFocus(0)
  Customization_VoiceInfo:UpdateMotionFocus(0)
end
function Customization_VoiceInfo:UpdateVoiceFocus(index)
  if -1 ~= index then
    if nil == self._typeImage[index] then
      return
    end
    self._ui._static_TypeSelect:SetShow(true)
    self._ui._static_TypeSelect:SetPosX(self._typeImage[index]:GetPosX() - 1)
    self._ui._static_TypeSelect:SetPosY(self._typeImage[index]:GetPosY() - 1)
    self._selectedVoiceIndex = index
  else
    self._ui._static_TypeSelect:SetShow(false)
  end
end
function Customization_VoiceInfo:UpdateMotionFocus(index)
  if -1 ~= index then
    if nil == self._contentsMotionImage[index] then
      return
    end
    self._ui._static_motionSelect:SetShow(true)
    self._ui._static_motionSelect:SetPosX(self._contentsMotionImage[index]:GetPosX())
    self._ui._static_motionSelect:SetPosY(self._contentsMotionImage[index]:GetPosY())
    self._selectMotionIndex = index
  else
    self._ui._static_motionSelect:SetShow(false)
  end
end
function PaGlobalFunc_Customization_Voice_UpdateSlide()
  local self = Customization_VoiceInfo
  local range = 100
  local value = self._ui._slider_Voice:GetControlPos() * range
  local slider = self._ui._slider_Voice
  local offset = math.cos(value / 100 * math.pi) * 2
  self._ui._slider_Progress:SetProgressRate(value)
  self._ui._slider_DisplayBtn:SetPosX(slider:GetControlPos() * 185)
  applyVoicePitch(value)
end
function PaGlobalFunc_Customization_Voice_SlideOn()
  local self = Customization_VoiceInfo
  PaGlobalFunc_Customization_SetKeyGuide(6)
end
function PaGlobalFunc_Customization_Voice_SlideOut()
  local self = Customization_VoiceInfo
  if false == self._isBoneControl and true == PaGlobalFunc_Customization_Voice_GetShow() then
    PaGlobalFunc_Customization_SetKeyGuide(7)
  end
end
function Customization_VoiceInfo:InitControl()
  self._ui._radioButton_TypeTemplate = UI.getChildControl(self._ui._static_TypeGroup, "RadioButton_TypeImage_Template")
  self._ui._radioButton_TypeTemplate:SetShow(false)
  self._ui._static_TypeSelect = UI.getChildControl(self._ui._static_TypeGroup, "Static_SelectedSlot")
  self._ui._static_TypeSelect:SetShow(false)
  self._config._columnWidth = self._ui._radioButton_TypeTemplate:GetSizeX() + self._config._imageGap
  self._config._columnHeight = self._ui._radioButton_TypeTemplate:GetSizeY() + self._config._imageGap
  self._ui._radioButton_motionTemplate = UI.getChildControl(self._ui._static_motionGroup, "RadioButton_TypeImage_Template")
  self._ui._radioButton_motionTemplate:SetShow(false)
  self._ui._static_motionSelect = UI.getChildControl(self._ui._static_motionGroup, "Static_SelectedSlot")
  self._ui._static_motionSelect:SetShow(false)
  self._config._motionColumnWidth = self._ui._radioButton_motionTemplate:GetSizeX() + self._config._motionImageGap
  self._config._motionColumnHeight = self._ui._radioButton_motionTemplate:GetSizeX() + self._config._motionImageGap
  self._ui._static_SliderVoiceBg = UI.getChildControl(self._ui._static_SliderGroup, "Static_VoiceBg")
  self._ui._staticText_SlierVoiceMin = UI.getChildControl(self._ui._static_SliderVoiceBg, "StaticText_Min")
  self._ui._staticText_SlierVoiceMax = UI.getChildControl(self._ui._static_SliderVoiceBg, "StaticText_Max")
  self._ui._slider_Voice = UI.getChildControl(self._ui._static_SliderVoiceBg, "Slider_Voice")
  self._ui._sliderButton_Voice = UI.getChildControl(self._ui._slider_Voice, "Slider_Button")
  self._ui._sliderButton_Voice:SetIgnore(true)
  self._ui._slider_Progress = UI.getChildControl(self._ui._slider_Voice, "Progress2_1")
  self._ui._slider_DisplayBtn = UI.getChildControl(self._ui._slider_Voice, "Slider_DisplayButton")
  if true == _ContentsGroup_isContentsCustomizationVoice then
    self._ui._slider_Voice:SetInterval(290)
  else
    self._ui._slider_Voice:SetInterval(240)
  end
end
function Customization_VoiceInfo:InitEvent()
  self._ui._slider_Voice:addInputEvent("Mouse_LPress", "PaGlobalFunc_Customization_Voice_UpdateSlide()")
  self._ui._slider_Voice:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_Voice_SlideOn()")
  self._ui._slider_Voice:addInputEvent("Mouse_Out", "PaGlobalFunc_Customization_Voice_SlideOut()")
end
function Customization_VoiceInfo:InitRegister()
  registerEvent("EventCloseVoiceUI", "PaGlobalFunc_Customization_Voice_CloseVoiceUI")
end
function Customization_VoiceInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function PaGlobalFunc_FromClient_Customization_Voice_luaLoadComplete()
  local self = Customization_VoiceInfo
  self:Initialize()
end
function PaGlobalFunc_Customization_Voice_Close()
  local self = Customization_VoiceInfo
  if false == PaGlobalFunc_Customization_Voice_GetShow() then
    return false
  end
  if true == self._isBoneControl then
    PaGlobalFunc_Customization_Voice_SetBoneControl(false)
    return false
  end
  applyMotion(-1)
  PaGlobalFunc_Customization_SetCloseFunc(nil)
  PaGlobalFunc_Customization_SetBackEvent()
  PaGlobalFunc_Customization_Voice_SetShow(false, false)
  return true
end
function PaGlobalFunc_Customization_Voice_Open()
  if true == PaGlobalFunc_Customization_Voice_GetShow() then
    return
  end
  PaGlobalFunc_Customization_Voice_SetShow(true, false)
  PaGlobalFunc_Customization_KeyGuideSetShow(true)
  PaGlobalFunc_Customization_SetKeyGuide(7)
  PaGlobalFunc_Customization_SetCloseFunc(PaGlobalFunc_Customization_Voice_Close)
  PaGlobalFunc_Customization_SetBackEvent("PaGlobalFunc_Customization_Voice_Close()")
end
function PaGlobalFunc_Customization_Voice_SetShow(isShow, isAni)
  Panel_Customizing_Voice:SetShow(isShow, isAni)
end
function PaGlobalFunc_Customization_Voice_GetShow()
  return Panel_Customizing_Voice:GetShow()
end
function PaGlobalFunc_Customization_Voice_GetPanel()
  return Panel_Customizing_Voice
end
PaGlobalFunc_FromClient_Customization_Voice_luaLoadComplete()

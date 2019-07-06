local _panel = Panel_Customizing_KeyGuide
_panel:ignorePadSnapMoveToOtherPanel()
_panel:ignorePadSnapUpdate(true)
local CustomizingKeyGuide = {
  _ui = {
    _static_MoveBg = UI.getChildControl(_panel, "Static_MoveBg"),
    _static_RotBg = UI.getChildControl(_panel, "Static_RotBg"),
    _static_ScaleBg = UI.getChildControl(_panel, "Static_ScaleBg"),
    _static_TransBg = UI.getChildControl(_panel, "Static_TransBg")
  },
  _config = {
    _hairBone = 0,
    _faceBone = 1,
    _bodyBone = 2,
    _bodyPose = 3,
    _keyGuideSizeY = 58,
    _defaultPanelSizeY = 0
  },
  _currentPanelFunc = nil,
  _currentBoneType = -1,
  _keyGuideHideCount = 0
}
function CustomizingKeyGuide:SetKeyGuideShow()
  local boneType = self._currentBoneType
  if self._config._hairBone == boneType then
    self._ui._static_RotBg:SetShow(true)
    self._ui._static_ScaleBg:SetShow(false)
    self._ui._static_TransBg:SetShow(true)
    self._keyGuideHideCount = 1
  elseif self._config._faceBone == boneType then
    self._ui._static_RotBg:SetShow(true)
    self._ui._static_ScaleBg:SetShow(true)
    self._ui._static_TransBg:SetShow(true)
    self._keyGuideHideCount = 0
  elseif self._config._bodyBone == boneType then
    self._ui._static_RotBg:SetShow(false)
    self._ui._static_ScaleBg:SetShow(true)
    self._ui._static_TransBg:SetShow(false)
    self._keyGuideHideCount = 2
  elseif self._config._bodyPose == boneType then
    self._ui._static_RotBg:SetShow(true)
    self._ui._static_ScaleBg:SetShow(false)
    self._ui._static_TransBg:SetShow(false)
    self._keyGuideHideCount = 2
  else
    _PA_ASSERT(false, "\236\187\164\236\138\164\237\132\176 \235\167\136\236\157\180\236\167\149 \237\130\164\234\176\128\236\157\180\235\147\156 \237\131\128\236\158\133\236\151\144 \236\160\149\236\157\152 \235\144\152\236\167\128 \236\149\138\236\157\128 \237\131\128\236\158\133\236\157\180 \235\147\164\236\150\180\236\153\148\236\138\181\235\139\136\235\139\164 : " .. tostring(boneType))
  end
end
function CustomizingKeyGuide:SetKeyGuidePos()
  local nextPos = self._ui._static_MoveBg:GetPosY() + self._config._keyGuideSizeY
  local keyGuideBg = {
    [0] = self._ui._static_RotBg,
    [1] = self._ui._static_ScaleBg,
    [2] = self._ui._static_TransBg
  }
  for index = 0, 2 do
    local keyGuide = keyGuideBg[index]
    if true == keyGuide:GetShow() then
      keyGuide:SetPosY(nextPos)
      nextPos = nextPos + self._config._keyGuideSizeY
    end
  end
  _panel:SetSize(_panel:GetSizeX(), self._defaultPanelSizeY - self._keyGuideHideCount * self._config._keyGuideSizeY)
  _panel:ComputePos()
end
function CustomizingKeyGuide:init()
  _panel:SetShow(false)
  self:registEvent()
  self._defaultPanelSizeY = _panel:GetSizeY()
end
function CustomizingKeyGuide:registEvent()
  _panel:RegisterUpdateFunc("PaGlobalFunc_CustomizingKeyGuide_PerFrame")
end
function CustomizingKeyGuide:open()
  self:SetKeyGuideShow()
  self:SetKeyGuidePos()
  _panel:SetShow(true)
end
function CustomizingKeyGuide:close()
  _panel:SetShow(false)
end
function PaGlobalFunc_CustomizingKeyGuide_Init()
  local self = CustomizingKeyGuide
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : CustomizingKeyGuide")
    return
  end
  self:init()
end
function PaGlobalFunc_CustomizingKeyGuide_Open(panelOpenFunc, boneType)
  local self = CustomizingKeyGuide
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : CustomizingKeyGuide")
    return
  end
  self._currentBoneType = boneType
  self._currentPanelFunc = panelOpenFunc
  self:open()
end
function PaGlobalFunc_CustomizingKeyGuide_Close()
  if false == _panel:GetShow() then
    return
  end
  local self = CustomizingKeyGuide
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : CustomizingKeyGuide")
    return
  end
  if nil ~= self._currentPanelFunc then
    self._currentPanelFunc(false)
  end
  self:close()
end
function PaGlobalFunc_CustomizingKeyGuide_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_CustomizingKeyGuide_PerFrame(deltaTime)
  if true == isPadUp(__eJoyPadInputType_RightShoulder) or true == isPadUp(__eJoyPadInputType_B) then
    PaGlobalFunc_CustomizingKeyGuide_Close()
  end
end
function PaGlobalFunc_CustomizingKeyGuide_IsShowKeyGuide()
  return PaGlobalFunc_Customization_FaceBone_GetShow() or PaGlobalFunc_Customization_BodyBone_GetShow() or PaGlobalFunc_Customization_BodyPose_GetShow()
end
PaGlobalFunc_CustomizingKeyGuide_Init()

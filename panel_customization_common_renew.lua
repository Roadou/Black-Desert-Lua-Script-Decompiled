local Customization_CommonInfo = {
  _currentClassType = -2,
  _currentuiId = -2,
  _checkSlider = false,
  _isCustomizationPicking = false,
  _clearGroupCustomizedBonInfoPostProcessList = Array.new()
}
function PaGlobalFunc_CustomIzationCommon_GetCurrentClassType()
  local self = Customization_CommonInfo
  return self._currentClassType
end
function PaGlobalFunc_CustomIzationCommon_SetCurrentClassType(classType)
  local self = Customization_CommonInfo
  self._currentClassType = classType
end
function PaGlobalFunc_CustomIzationCommon_GetCurrentUiId()
  local self = Customization_CommonInfo
  return self._currentuiId
end
function PaGlobalFunc_CustomIzationCommon_SetCurrentUiId(uiId)
  local self = Customization_CommonInfo
  self._currentuiId = uiId
end
function PaGlobalFunc_CustomIzationCommon_GetIsCheckSlider()
  local self = Customization_CommonInfo
  return self._checkSlider
end
function PaGlobalFunc_CustomIzationCommon_SetIsCheckSlider(isCheck)
  local self = Customization_CommonInfo
  self._checkSlider = isCheck
end
function PaGlobalFunc_CustomIzationCommon_GetIsCustomizationPicking()
  local self = Customization_CommonInfo
  return self._isCustomizationPicking
end
function PaGlobalFunc_CustomIzationCommon_SetIsCustomizationPicking(isPicking)
  local self = Customization_CommonInfo
  self._isCustomizationPicking = isPicking
end
function PaGlobalFunc_CustomIzationCommon_SetSliderValue(SliderControl, value, valueMin, valueMax)
  local range = valueMax - valueMin
  if value < valueMin then
    value = valueMin
  end
  if valueMax < value then
    value = valueMax
  end
  if range <= 0 then
    SliderControl:SetControlPos(50)
  else
    SliderControl:SetControlPos((value - valueMin) / range * 100)
  end
end
function PaGlobalFunc_CustomIzationCommon_GetSliderValue(SliderControl, valueMin, valueMax)
  local ratio = SliderControl:GetControlPos()
  local range = valueMax - valueMin
  if range < 0 then
    range = 0
  end
  return math.floor(ratio * range + valueMin + 0.5)
end
function PaGlobalFunc_CustomIzationCommon_PushClearGroupCustomizedBonInfoPostFunction(functor)
  local self = Customization_CommonInfo
  self._clearGroupCustomizedBonInfoPostProcessList:push_back(functor)
end
function PaGlobalFunc_CustomIzationCommon_ClearGroupCustomizedBonInfoLua()
  local self = Customization_CommonInfo
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  clearGroupCustomizedBoneInfo()
  for key, value in pairs(self._clearGroupCustomizedBonInfoPostProcessList) do
    value()
  end
end
function PaGlobalFunc_CustomIzationCommon_Add_CurrentHistory()
  local self = Customization_CommonInfo
  if false == self._isCustomizationPicking then
    self._checkSlider = false
  end
  ToClient_addHistory()
  SetHistroyList()
  setCurrentActive()
end

local CustomizingHandleInfo = {
  _ui = {
    _leafTree = {}
  },
  _currentPartCount = 0,
  _currentClassType
}
function CustomizingHandleInfo:Initialize()
  self:InitRegister()
end
function CustomizingHandleInfo:InitRegister()
  registerEvent("EventOpenCustomizationUiGroupFrame", "PaGlobalFunc_FromClient_Customization_Open")
end
function PaGlobalFunc_FromClient_Customization_Open(classType, uiGroupIndex)
  local self = CustomizingHandleInfo
  self._ui._leafTree = PaGlobalFunc_Customization_GetLeafTree()
  self._ui._currentClassType = classType
  self._currentPartCount = getUiPartCount(classType, uiGroupIndex)
  local isShai = getSelfPlayer():getClassType() == CppEnums.ClassType.ClassType_ShyWomen
  for uiPartIndex = 0, self._currentPartCount - 1 do
    local partName = getUiPartDescName(classType, uiGroupIndex, uiPartIndex)
    self._ui._leafTree[uiPartIndex]:SetText(PAGetString(Defines.StringSheet_GAME, partName))
    self._ui._leafTree[uiPartIndex]:SetShow(true)
    self._ui._leafTree[uiPartIndex]:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_ClickLeafTree(" .. uiPartIndex .. ")")
    local isBlock = 2 == uiGroupIndex and (3 == uiPartIndex or 1 == uiPartIndex)
    self._ui._leafTree[uiPartIndex]:SetIgnore(isShai and isBlock)
    self._ui._leafTree[uiPartIndex]:SetMonoTone(isShai and isBlock)
  end
end
function PaGlobalFunc_Customization_ClickLeafTree(index)
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  selectCustomizationControlPart(index)
end
function PaGlobalFunc_CustomizingHandle_luaLoadComplete()
  local self = CustomizingHandleInfo
  self:Initialize()
end
PaGlobalFunc_CustomizingHandle_luaLoadComplete()

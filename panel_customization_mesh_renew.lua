Panel_Customizing_Mesh:ignorePadSnapMoveToOtherPanel()
local Customization_MeshInfo = {
  _ui = {
    _static_TypeBg = UI.getChildControl(Panel_Customizing_Mesh, "Static_TypeGroup"),
    _meshList = {}
  },
  _config = {
    _textureColumnCount = 4,
    _meshColumnCount = 5,
    _textureSize = 48,
    _contentsOffsetX = 10,
    _contentsOffsetY = 10,
    _meshImageGap = 5,
    _columnWidth,
    _columnHeight
  },
  _currentClassType,
  _currentUiId,
  _selectedMeshIndex = -1,
  _selectedListParamType = nil,
  _selectedListParamIndex = nil,
  _selectedItemIndex = nil,
  _paramValueList = {},
  _currentMeshIndex = -1,
  _isBoneControl = false
}
function PaGlobalFunc_Customization_Mesh_UpdateMeshIndexOn(itemIndex)
  local self = Customization_MeshInfo
  if self._selectedItemIndex == itemIndex then
    PaGlobalFunc_Customization_SetKeyGuide(6)
  else
    PaGlobalFunc_Customization_SetKeyGuide(7)
  end
end
function PaGlobalFunc_Customization_Mesh_UpdateMeshIndexMessage(listParamType, listParamIndex, itemIndex)
  local self = Customization_MeshInfo
  self._selectedListParamType = listParamType
  self._selectedListParamIndex = listParamIndex
  self._selectedItemIndex = itemIndex
  local selectedParamValue = self._paramValueList[self._selectedItemIndex]
  if Panel_Win_System:GetShow() then
    MessageBox_Empty_function()
    allClearMessageData()
  end
  local messageBoxMemo
  if 0 == self._selectedListParamIndex then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLY_FACEMESH")
  elseif 1 == self._selectedListParamIndex then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLY_HAIRMESH")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = PaGlobalFunc_Customization_HairType_UpdateMeshIndex,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData, "top")
end
function PaGlobalFunc_Customization_HairType_UpdateMeshIndex()
  local self = Customization_MeshInfo
  if not PaGlobalFunc_Customization_IsInGame() and not isNormalCustomizingIndex(self._currentClassType, listParamType, listParamIndex, selectedParamValue) then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLY_CASHITEM")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = PaGlobalFunc_Customization_HairType_UpdateMeshIndexInternal,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "top")
  else
    PaGlobalFunc_Customization_HairType_UpdateMeshIndexInternal()
    self:UpdateTypeFocus(self._selectedItemIndex)
  end
end
function PaGlobalFunc_Customization_HairType_UpdateMeshIndexInternal()
  local self = Customization_MeshInfo
  local selectedParamValue = self._paramValueList[self._selectedItemIndex]
  setParam(self._currentClassType, self._selectedListParamType, self._selectedListParamIndex, selectedParamValue)
  applyInitializeToGroupCustomizedBoneInfo()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self:UpdateTypeFocus(self._selectedItemIndex)
end
function HandleClicked_Customization_Mesh_Close()
  PaGlobalFunc_Customization_Mesh_Close()
end
function Customization_MeshInfo:ClearList()
  for _, control in pairs(self._ui._meshList) do
    if nil ~= control then
      control:SetShow(false)
    end
  end
end
function HandleClicked_Customization_Mesh_Open(classType, uiId)
  local self = Customization_MeshInfo
  self._currentClassType = classType
  self._currentUiId = uiId
  self:ClearList()
  local defaultContentsIndex = 0
  local listCount = getUiListCount(classType, uiId, defaultContentsIndex)
  local detailListCount = getUiDetailListCount(classType, uiId, defaultContentsIndex)
  if listCount == 1 then
    local listIndex = 0
    local luaListIndex = listIndex + 1
    local listTexture = getUiListTextureName(classType, uiId, defaultContentsIndex, listIndex)
    local listParamType = getUiListParamType(classType, uiId, defaultContentsIndex, listIndex)
    local listParamIndex = getUiListParamIndex(classType, uiId, defaultContentsIndex, listIndex)
    local meshCount = getParamMax(classType, listParamType, listParamIndex) + 1
    local normalLastIndex = 0
    for itemIndex = 0, meshCount - 1 do
      local luaShapeIdx = itemIndex + 1
      local control = self._ui._meshList[itemIndex]
      if nil == control then
        control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_TypeBg, "HairType_Image_" .. itemIndex)
        CopyBaseProperty(self._ui._hairTypeTemplate, control)
      end
      control:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_Mesh_UpdateMeshIndexOn(" .. itemIndex .. ")")
      control:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_Mesh_UpdateMeshIndexMessage(" .. listParamType .. "," .. listParamIndex .. "," .. itemIndex .. ")")
      local col = itemIndex % self._config._textureColumnCount
      local row = math.floor(itemIndex / self._config._textureColumnCount)
      local texUV = {
        x1,
        y1,
        x2,
        y2
      }
      texUV.x1 = col * self._config._textureSize
      texUV.y1 = row * self._config._textureSize
      texUV.x2 = texUV.x1 + self._config._textureSize
      texUV.y2 = texUV.y1 + self._config._textureSize
      control:ChangeTextureInfoName(listTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(control, texUV.x1, texUV.y1, texUV.x2, texUV.y2)
      control:getBaseTexture():setUV(x1, y1, x2, y2)
      control:SetPosX(12 + itemIndex % self._config._meshColumnCount * self._config._columnWidth + self._config._contentsOffsetX)
      control:SetPosY(5 + math.floor(itemIndex / self._config._meshColumnCount) * self._config._columnHeight + self._config._contentsOffsetY)
      control:setRenderTexture(control:getBaseTexture())
      if not PaGlobalFunc_Customization_IsInGame() and not isNormalCustomizingIndex(classType, listParamType, listParamIndex, itemIndex) then
        control:SetShow(false)
      else
        control:SetShow(true)
      end
      if not isNormalCustomizingIndex(classType, listParamType, listParamIndex, itemIndex) then
      else
        normalLastIndex = normalLastIndex + 1
      end
      self._ui._meshList[itemIndex] = control
    end
    local param = getParam(listParamType, listParamIndex)
    self:UpdateTypeFocus(param)
  end
  if detailListCount == 1 then
    local detailListIndex = 0
    local luaDetailListIndex = detailListIndex + 1
    local detailListParamType = getUiDetailListParamType(classType, uiId, defaultContentsIndex, detailListIndex)
    local detailListParamIndex = getUiDetailListParamIndex(classType, uiId, defaultContentsIndex, detailListIndex)
    local currentParamValue = getParam(detailListParamType, detailListParamIndex)
    local currenelementIndex
    local defaultDetailListIndex = 0
    local meshCount = getUiDetailListElementCount(classType, uiId, defaultContentsIndex, defaultDetailListIndex)
    local normalLastIndex = 0
    for elementIndex = 0, meshCount - 1 do
      local control = self._ui._meshList[elementIndex]
      if nil == control then
        control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_TypeBg, "HairType_Image_" .. elementIndex)
        CopyBaseProperty(self._ui._hairTypeTemplate, control)
      end
      local paramValue = getUiDetailListElementParamValue(classType, uiId, defaultContentsIndex, defaultDetailListIndex, elementIndex)
      self._paramValueList[elementIndex] = paramValue
      if paramValue == currentParamValue then
        currenelementIndex = elementIndex
      end
      control:addInputEvent("Mouse_On", "PaGlobalFunc_Customization_Mesh_UpdateMeshIndexOn(" .. elementIndex .. ")")
      control:addInputEvent("Mouse_LUp", "PaGlobalFunc_Customization_Mesh_UpdateMeshIndexMessage(" .. detailListParamType .. "," .. detailListParamIndex .. "," .. elementIndex .. ")")
      local texUV = {
        x1,
        y1,
        x2,
        y2
      }
      texUV.x1 = 1
      texUV.y1 = 1
      texUV.x2 = self._config._textureSize
      texUV.y2 = self._config._textureSize
      local detailListElementTexture = getUiDetailListElementTextureName(classType, uiId, defaultContentsIndex, defaultDetailListIndex, elementIndex)
      control:ChangeTextureInfoName(detailListElementTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(control, texUV.x1, texUV.y1, texUV.x2, texUV.y2)
      control:getBaseTexture():setUV(x1, y1, x2, y2)
      control:SetPosX(12 + elementIndex % self._config._meshColumnCount * self._config._columnWidth + self._config._contentsOffsetX)
      control:SetPosY(5 + math.floor(elementIndex / self._config._meshColumnCount) * self._config._columnHeight + self._config._contentsOffsetY)
      control:setRenderTexture(control:getBaseTexture())
      if not FGlobal_IsCommercialService() and not isNormalCustomizingIndex(classType, detailListParamType, detailListParamIndex, paramValue) then
        control:SetShow(false)
      elseif not PaGlobalFunc_Customization_IsInGame() and not isNormalCustomizingIndex(classType, detailListParamType, detailListParamIndex, paramValue) then
        control:SetShow(false)
      else
        control:SetShow(true)
      end
      if not isNormalCustomizingIndex(selectedClassType, classType, detailListParamIndex, paramValue) then
      else
        normalLastIndex = normalLastIndex + 1
      end
      self._ui._meshList[elementIndex] = control
    end
    local param = getParam(detailListParamType, detailListParamIndex)
    self:UpdateTypeFocus(param)
    local meshListCount = meshCount - 1
    local VerticalCount = Int64toInt32(meshListCount / self._config._meshColumnCount + 2)
    local sizeY = VerticalCount * self._config._columnHeight
    Panel_Customizing_Mesh:SetSize(Panel_Customizing_Mesh:GetSizeX(), sizeY + 20)
    PaGlobalFunc_Customization_Mesh_Open()
  end
end
function Customization_MeshInfo:UpdateTypeFocus(itemIndex)
  local item = self._ui._meshList[itemIndex]
  if nil == item then
    return
  end
  self._ui._hairTypeSelect:SetShow(true)
  self._ui._hairTypeSelect:SetPosX(item:GetPosX() - 1)
  self._ui._hairTypeSelect:SetPosY(item:GetPosY() - 1)
  self._selectedItemIndex = itemIndex
end
function Customization_MeshInfo:InitControl()
  self._ui._hairTypeTemplate = UI.getChildControl(self._ui._static_TypeBg, "RadioButton_TypeImage_Template")
  self._ui._hairTypeTemplate:SetShow(false)
  self._ui._hairTypeSelect = UI.getChildControl(self._ui._static_TypeBg, "Static_SelectedSlot")
  self._ui._hairTypeSelect:SetShow(false)
  self._config._columnWidth = self._ui._hairTypeTemplate:GetSizeX() + self._config._meshImageGap
  self._config._columnHeight = self._ui._hairTypeTemplate:GetSizeY() + self._config._meshImageGap
end
function Customization_MeshInfo:InitEvent()
end
function Customization_MeshInfo:InitRegister()
  registerEvent("EventOpenSelectMeshUi", "HandleClicked_Customization_Mesh_Open")
  registerEvent("EventCloseSelectMeshUi", "HandleClicked_Customization_Mesh_Close")
end
function Customization_MeshInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function PaGlobalFunc_Customization_Mesh_GetShow()
  return Panel_Customizing_Mesh:GetShow()
end
function PaGlobalFunc_Customization_Mesh_SetShow(isShow, isAni)
  Panel_Customizing_Mesh:SetShow(isShow, isAni)
end
function PaGlobalFunc_Customization_Mesh_Open()
  if true == PaGlobalFunc_Customization_Mesh_GetShow() then
    return
  end
  PaGlobalFunc_Customization_Mesh_SetShow(true, false)
  PaGlobalFunc_Customization_KeyGuideSetShow(true)
  PaGlobalFunc_Customization_SetKeyGuide(7)
  PaGlobalFunc_Customization_SetCloseFunc(PaGlobalFunc_Customization_Mesh_Close)
  PaGlobalFunc_Customization_SetBackEvent("PaGlobalFunc_Customization_Mesh_Close()")
end
function PaGlobalFunc_Customization_Mesh_Close()
  local self = Customization_MeshInfo
  if false == PaGlobalFunc_Customization_Mesh_GetShow() then
    return false
  end
  if true == self._isBoneControl then
    return false
  end
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  PaGlobalFunc_Customization_SetCloseFunc(nil)
  PaGlobalFunc_Customization_SetBackEvent()
  PaGlobalFunc_Customization_Mesh_SetShow(false, false)
  return true
end
function PaGlobalFunc_FromClient_Customization_Mesh_luaLoadComplete()
  local self = Customization_MeshInfo
  self:Initialize()
end
function PaGlobalFunc_Customization_Mesh_GetPanel()
  return Panel_Customizing_Mesh
end
PaGlobalFunc_FromClient_Customization_Mesh_luaLoadComplete()

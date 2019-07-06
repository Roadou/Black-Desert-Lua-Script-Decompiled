local Frame_ContentImage = UI.getChildControl(Panel_CustomizationMesh, "Frame_Content_Image")
local Static_PayMark = UI.getChildControl(Panel_CustomizationMesh, "Static_PayMark")
local Static_SelectMark = UI.getChildControl(Panel_CustomizationMesh, "Static_SelectMark")
local paramValueList = {}
local ContentImage = {}
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local NoCashType = CppEnums.CustomizationNoCashType
local NoCashMesh = CppEnums.CustomizationNoCashMesh
local NoCashDeco = CppEnums.CustomizationNoCashDeco
local selectedMeshIndex = -1
local textureColumnCount = 4
local meshColumnCount = 5
local meshImageGap = 5
local columnWidth = Frame_ContentImage:GetSizeX() + meshImageGap
local columnHeight = Frame_ContentImage:GetSizeY() + meshImageGap
local contentsOffsetX = 10
local contentsOffsetY = 10
local texSize = 48
local selectedClassType, selectedListParamType, selectedListParamIndex, selectedItemIndex, wizardPrevFaceTypeIndex
local currentclassType = -1
local currentuiId = -1
registerEvent("EventOpenSelectMeshUi", "OpenSelectMeshUi")
registerEvent("EventCloseSelectMeshUi", "CloseSelectMeshUi")
local function UpdateSelectedMark(meshUiIndex)
  if nil == meshUiIndex then
    return
  end
  if meshUiIndex ~= -1 then
    Static_SelectMark:SetShow(true)
    Static_SelectMark:SetPosX(contentsOffsetX + meshUiIndex % meshColumnCount * columnWidth)
    Static_SelectMark:SetPosY(contentsOffsetY + math.floor(meshUiIndex / meshColumnCount) * columnHeight)
  else
    Static_SelectMark:SetShow(false)
  end
end
local function clearMeshUI()
  for _, v in pairs(ContentImage) do
    v:SetShow(false)
    UI.deleteControl(v)
  end
  ContentImage = {}
end
function CloseSelectMeshUi()
  globalcurrentclassType = -2
  globalcurrentuiId = -2
end
function OpenSelectMeshUi(classType, uiId)
  if true == _ContentsGroup_RenewUI_Customization then
    return
  end
  clearMeshUI()
  paramValueList = {}
  globalcurrentclassType = classType
  globalcurrentuiId = uiId
  currentclassType = classType
  currentuiId = uiId
  selectedClassType = classType
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
      local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CustomizationMesh, "Frame_Image_" .. itemIndex)
      CopyBaseProperty(Frame_ContentImage, tempContentImage)
      tempContentImage:addInputEvent("Mouse_LUp", "UpdateMeshIndexMessage(" .. listParamType .. "," .. listParamIndex .. "," .. itemIndex .. ")")
      local staticPayMark = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempContentImage, "Static_PayMark_" .. itemIndex)
      CopyBaseProperty(Static_PayMark, staticPayMark)
      local col = itemIndex % textureColumnCount
      local row = math.floor(itemIndex / textureColumnCount)
      local texUV = {
        x1,
        y1,
        x2,
        y2
      }
      texUV.x1 = col * texSize
      texUV.y1 = row * texSize
      texUV.x2 = texUV.x1 + texSize
      texUV.y2 = texUV.y1 + texSize
      tempContentImage:ChangeTextureInfoName(listTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(tempContentImage, texUV.x1, texUV.y1, texUV.x2, texUV.y2)
      tempContentImage:getBaseTexture():setUV(x1, y1, x2, y2)
      tempContentImage:SetPosX(itemIndex % meshColumnCount * columnWidth + contentsOffsetX)
      tempContentImage:SetPosY(math.floor(itemIndex / meshColumnCount) * columnHeight + contentsOffsetY)
      tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
      if not FGlobal_IsInGameMode() and not isNormalCustomizingIndex(selectedClassType, listParamType, listParamIndex, itemIndex) then
        tempContentImage:SetShow(false)
      else
        tempContentImage:SetShow(true)
      end
      if not isNormalCustomizingIndex(selectedClassType, listParamType, listParamIndex, itemIndex) then
        staticPayMark:SetShow(true)
      else
        staticPayMark:SetShow(false)
        normalLastIndex = normalLastIndex + 1
      end
      ContentImage[luaShapeIdx] = tempContentImage
    end
    local param = getParam(listParamType, listParamIndex)
    UpdateSelectedMark(param)
    Panel_CustomizationMesh:SetSize(Panel_CustomizationMesh:GetSizeX(), (1 + math.floor((meshCount - 1) / meshColumnCount)) * columnHeight - meshImageGap + 2 * contentsOffsetY)
    updateGroupFrameControls(Panel_CustomizationMesh:GetSizeY(), Panel_CustomizationMesh)
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
      local luaElementIndex = elementIndex + 1
      local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CustomizationMesh, "Frame_Image_" .. elementIndex)
      CopyBaseProperty(Frame_ContentImage, tempContentImage)
      local paramValue = getUiDetailListElementParamValue(classType, uiId, defaultContentsIndex, defaultDetailListIndex, elementIndex)
      paramValueList[luaElementIndex] = paramValue
      if paramValue == currentParamValue then
        currenelementIndex = elementIndex
      end
      tempContentImage:addInputEvent("Mouse_LUp", "UpdateMeshIndexMessage(" .. detailListParamType .. "," .. detailListParamIndex .. "," .. elementIndex .. ")")
      local staticPayMark = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempContentImage, "Static_PayMark_" .. elementIndex)
      CopyBaseProperty(Static_PayMark, staticPayMark)
      local texUV = {
        x1,
        y1,
        x2,
        y2
      }
      texUV.x1 = 1
      texUV.y1 = 1
      texUV.x2 = texSize
      texUV.y2 = texSize
      local detailListElementTexture = getUiDetailListElementTextureName(classType, uiId, defaultContentsIndex, defaultDetailListIndex, elementIndex)
      tempContentImage:ChangeTextureInfoName(detailListElementTexture)
      local x1, y1, x2, y2 = setTextureUV_Func(tempContentImage, texUV.x1, texUV.y1, texUV.x2, texUV.y2)
      tempContentImage:getBaseTexture():setUV(x1, y1, x2, y2)
      tempContentImage:SetPosX(elementIndex % meshColumnCount * columnWidth + contentsOffsetX)
      tempContentImage:SetPosY(math.floor(elementIndex / meshColumnCount) * columnHeight + contentsOffsetY)
      tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
      if not FGlobal_IsCommercialService() and not isNormalCustomizingIndex(selectedClassType, detailListParamType, detailListParamIndex, paramValue) then
        tempContentImage:SetShow(false)
      elseif not FGlobal_IsInGameMode() and not isNormalCustomizingIndex(selectedClassType, detailListParamType, detailListParamIndex, paramValue) then
        tempContentImage:SetShow(false)
      else
        tempContentImage:SetShow(true)
      end
      if not isNormalCustomizingIndex(selectedClassType, detailListParamType, detailListParamIndex, paramValue) then
        staticPayMark:SetShow(true)
      else
        staticPayMark:SetShow(false)
        normalLastIndex = normalLastIndex + 1
      end
      ContentImage[luaElementIndex] = tempContentImage
    end
    UpdateSelectedMark(currenelementIndex)
    wizardPrevFaceTypeIndex = currenelementIndex
    if not FGlobal_IsCommercialService() then
      Panel_CustomizationMesh:SetSize(Panel_CustomizationMesh:GetSizeX(), (1 + math.floor((normalLastIndex - 1) / meshColumnCount)) * columnHeight - meshImageGap + 2 * contentsOffsetY)
    else
      Panel_CustomizationMesh:SetSize(Panel_CustomizationMesh:GetSizeX(), (1 + math.floor((meshCount - 1) / meshColumnCount)) * columnHeight - meshImageGap + 2 * contentsOffsetY)
    end
    updateGroupFrameControls(Panel_CustomizationMesh:GetSizeY(), Panel_CustomizationMesh)
  end
end
function UpdateMeshIndexMessage(listParamType, listParamIndex, itemIndex)
  selectedListParamType = listParamType
  selectedListParamIndex = listParamIndex
  selectedItemIndex = itemIndex
  local luaSelectedItemIndex = selectedItemIndex + 1
  local selectedParamValue = paramValueList[luaSelectedItemIndex]
  if Panel_Win_System:GetShow() then
    MessageBox_Empty_function()
    allClearMessageData()
  end
  local messageBoxMemo
  if 0 == selectedListParamIndex then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLY_FACEMESH")
  elseif 1 == selectedListParamIndex then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLY_HAIRMESH")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = UpdateMeshIndex,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData, "top")
end
function UpdateMeshIndex()
  if not FGlobal_IsInGameMode() and not isNormalCustomizingIndex(selectedClassType, listParamType, listParamIndex, selectedParamValue) then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLY_CASHITEM")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = UpdateMeshIndex,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "top")
  else
    UpdateMeshIndexInternal()
    add_CurrentHistory()
  end
end
function UpdateMeshIndexInternal()
  local luaSelectedItemIndex = selectedItemIndex + 1
  local selectedParamValue = paramValueList[luaSelectedItemIndex]
  local function wizardFaceHairCheck()
    local wizardLastFaceHairIdx = #paramValueList - 1
    if CppEnums.ClassType.ClassType_Wizard == selectedClassType and (wizardLastFaceHairIdx == wizardPrevFaceTypeIndex and wizardLastFaceHairIdx ~= selectedParamValue or wizardLastFaceHairIdx ~= prevFaceTypeIndex and wizardLastFaceHairIdx == selectedParamValue) then
      faceHairCustomUpdate(false)
      setUseFaceCustomizationHair(false)
    end
    wizardPrevFaceTypeIndex = selectedParamValue
  end
  wizardFaceHairCheck()
  setParam(selectedClassType, selectedListParamType, selectedListParamIndex, selectedParamValue)
  UpdateSelectedMark(selectedItemIndex)
  applyInitializeToGroupCustomizedBoneInfo()
end
function MeshHistoryApplyUpdate()
  if globalcurrentclassType ~= currentclassType or globalcurrentuiId ~= currentuiId then
    return
  end
  OpenSelectMeshUi(currentclassType, currentuiId)
end

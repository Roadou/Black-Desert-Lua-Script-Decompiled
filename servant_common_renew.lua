function Servant_SceneOpen(panel)
  SetUIMode(Defines.UIMode.eUIMode_Stable)
  PaGlobalFunc_MainDialog_setIgnoreShowDialog(true)
  PaGlobalFunc_MainDialog_Close()
  UIAni.fadeInSCR_Down(panel)
  local npcKey = dialog_getTalkNpcKey()
  if 0 == npcKey then
    return
  end
  openClientChangeScene(npcKey, 1)
  local funcCameraName = Dialog_getFuncSceneCameraName()
  changeCameraScene(funcCameraName, 0.5)
  panel:SetShow(true)
end
function Servant_SceneClose(panel)
  SetUIMode(Defines.UIMode.eUIMode_NpcDialog)
  PaGlobalFunc_MainDialog_setIgnoreShowDialog(false)
  UIAni.fadeInSCR_Down(panel)
  panel:SetShow(false)
  local npcKey = dialog_getTalkNpcKey()
  if 0 ~= npcKey then
    closeClientChangeScene(npcKey)
  end
  local mainCameraName = Dialog_getMainSceneCameraName()
  changeCameraScene(mainCameraName, 0.5)
  PaGlobalFunc_MainDialog_ReOpen()
end
function Servant_ScenePushObject(servantInfo, beforeSceneIndex)
  if nil == servantInfo then
    return
  end
  local characterKeyRaw = servantInfo:getCharacterKeyRaw()
  local afterSceneIndex = getIndexByCharacterKey(characterKeyRaw)
  if beforeSceneIndex == afterSceneIndex then
    return beforeSceneIndex
  end
  if -1 ~= beforeSceneIndex then
    showSceneCharacter(beforeSceneIndex, false)
  end
  if -1 ~= afterSceneIndex then
    showSceneCharacter(afterSceneIndex, true)
    if not isGuildStable() then
      stable_previewEquipItem(afterSceneIndex)
    end
  end
  return afterSceneIndex
end
function Servant_ScenePopObject(sceneIndex)
  if -1 ~= sceneIndex and nil ~= sceneIndex then
    showSceneCharacter(sceneIndex, false)
  end
end
function Servant_InventoryClose()
  Inventory_SetFunctor(nil, nil, nil, nil)
  PaGlobalFunc_InventoryInfo_Close()
end
function InvenFiler_Mapae(slotNo, itemWrapper)
  if nil == itemWrapper then
    return true
  end
  local itemSSW = itemWrapper:getStaticStatus()
  if nil == itemSSW then
    return
  end
  local returnValue = true
  local isMapae = itemSSW:get():isMapae()
  local isGuildMapae = itemSSW:get():isGuildMapae()
  local itemKey = itemWrapper:get():getKey():getItemKey()
  local npcType = ToClient_GetServnatTypeFromNpc()
  if npcType ~= itemSSW:get():getMapaeServantType() then
    return true
  end
  if isGuildStable() then
    if isGuildMapae then
      returnValue = true
    else
      returnValue = false
    end
  elseif isMapae and not isGuildMapae then
    returnValue = true
  else
    returnValue = false
  end
  return not returnValue
end
function EffectFilter_Mapae(slotNo, itemWrapper)
  if nil == itemWrapper then
    return true
  end
  local itemSSW = itemWrapper:getStaticStatus()
  if nil == itemSSW then
    return
  end
  local returnValue = true
  local isMapae = itemSSW:get():isMapae()
  local isGuildMapae = itemSSW:get():isGuildMapae()
  local itemKey = itemWrapper:get():getKey():getItemKey()
  local npcType = ToClient_GetServnatTypeFromNpc()
  if npcType ~= itemSSW:get():getMapaeServantType() then
    return true
  end
  if isGuildStable() then
    if isGuildMapae then
      returnValue = true
    else
      returnValue = false
    end
  elseif isMapae and not isGuildMapae then
    returnValue = true
  else
    returnValue = false
  end
  return not returnValue
end
function Servant_Confirm(strTitle, strMessage, functionYes, functionNo)
  local messageboxData = {
    title = strTitle,
    content = strMessage,
    functionYes = functionYes,
    functionCancel = functionNo,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function Mapae_SetEffect()
  return "fUI_HorseNameCard01"
end

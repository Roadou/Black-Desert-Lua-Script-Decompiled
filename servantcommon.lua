function Servant_SceneOpen(panel)
  SetUIMode(Defines.UIMode.eUIMode_Stable)
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_setIgnoreShowDialog(true)
    PaGlobalFunc_MainDialog_Close()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    setIgnoreShowDialog(true)
    Panel_Npc_Dialog:SetShow(false)
  else
    PaGlobalFunc_DialogMain_All_SetIgnoreShowDialog(true)
    PaGlobalFunc_DialogMain_All_ShowToggle(false)
  end
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
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_setIgnoreShowDialog(false)
    PaGlobalFunc_MainDialog_ReOpen()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    setIgnoreShowDialog(false)
    Panel_Npc_Dialog:SetShow(true)
  else
    PaGlobalFunc_DialogMain_All_SetIgnoreShowDialog(false)
    PaGlobalFunc_DialogMain_All_ShowToggle(true)
  end
  UIAni.fadeInSCR_Down(panel)
  local npcKey = dialog_getTalkNpcKey()
  if 0 ~= npcKey then
    closeClientChangeScene(npcKey)
  end
  local mainCameraName = Dialog_getMainSceneCameraName()
  changeCameraScene(mainCameraName, 0.5)
  panel:SetShow(false)
end
function Servant_ScenePushObjectByKey(characterKey, beforeSceneIndex)
  if nil == characterKey then
    return
  end
  local afterSceneIndex = getIndexByCharacterKey(characterKey)
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
  Inventory_SetFunctor(nil)
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
Panel_Window_HorseLookChange:SetShow(false)
Panel_Window_HorseLookChange:ActiveMouseEventEffect(true)
Panel_Window_HorseLookChange:setGlassBackground(true)
PaGlobal_StableType = -1
PaGlobal_ServantChangeFormPanel = {
  _lookChangeMaxSlotCount = 5,
  _btnClose = UI.getChildControl(Panel_Window_HorseLookChange, "Button_Close"),
  _btnLeft = UI.getChildControl(Panel_Window_HorseLookChange, "Button_LargCraftInfo_Slide_Left"),
  _btnRight = UI.getChildControl(Panel_Window_HorseLookChange, "Button_LargCraftInfo_Slide_Right"),
  _LCSelectSlot = UI.getChildControl(Panel_Window_HorseLookChange, "Static_SelectSlot"),
  _textPage = UI.getChildControl(Panel_Window_HorseLookChange, "StaticText_Page"),
  _btnChange = UI.getChildControl(Panel_Window_HorseLookChange, "Button_LookChange"),
  _btnPremium = UI.getChildControl(Panel_Window_HorseLookChange, "Button_PremiumLookChange"),
  _btnShipChange = UI.getChildControl(Panel_Window_HorseLookChange, "Button_ShipLookChange"),
  _textCurrentLook = UI.getChildControl(Panel_Window_HorseLookChange, "StaticText_CurrentLook"),
  _comboBox = UI.getChildControl(Panel_Window_HorseLookChange, "Combobox_Tier"),
  _staticText = UI.getChildControl(Panel_Window_HorseLookChange, "Action_Title")
}
PaGlobal_ServantLookChangeSlot = {
  [1] = UI.getChildControl(Panel_Window_HorseLookChange, "Static_LookChange_Slot_1"),
  [2] = UI.getChildControl(Panel_Window_HorseLookChange, "Static_LookChange_Slot_2"),
  [3] = UI.getChildControl(Panel_Window_HorseLookChange, "Static_LookChange_Slot_3"),
  [4] = UI.getChildControl(Panel_Window_HorseLookChange, "Static_LookChange_Slot_4"),
  [5] = UI.getChildControl(Panel_Window_HorseLookChange, "Static_LookChange_Slot_5")
}
function registEventHandler()
  PaGlobal_ServantChangeFormPanel._comboBox:setListTextHorizonCenter()
  PaGlobal_ServantChangeFormPanel._btnClose:addInputEvent("Mouse_LUp", "Panel_LookChange_Close()")
  PaGlobal_ServantChangeFormPanel._btnLeft:addInputEvent("Mouse_LUp", "LookChange_Set(" .. -1 .. ")")
  PaGlobal_ServantChangeFormPanel._btnRight:addInputEvent("Mouse_LUp", "LookChange_Set(" .. 1 .. ")")
  PaGlobal_ServantChangeFormPanel._btnChange:addInputEvent("Mouse_LUp", "LookChange_ChangeConfirm()")
  PaGlobal_ServantChangeFormPanel._btnShipChange:addInputEvent("Mouse_LUp", "LookChange_ChangeConfirm()")
  PaGlobal_ServantChangeFormPanel._btnPremium:addInputEvent("Mouse_LUp", "HorseLookChange_PremiumChangeConfirm()")
  PaGlobal_ServantChangeFormPanel._comboBox:addInputEvent("Mouse_LUp", "HandleClicked_LookCombo()")
  PaGlobal_ServantChangeFormPanel._comboBox:GetListControl():addInputEvent("Mouse_LUp", "Set_LookChange()")
  PaGlobal_ServantChangeFormPanel._btnLeft:SetAutoDisableTime(0.2)
  PaGlobal_ServantChangeFormPanel._btnRight:SetAutoDisableTime(0.2)
  for index = 1, PaGlobal_ServantChangeFormPanel._lookChangeMaxSlotCount do
    PaGlobal_ServantLookChangeSlot[index]:addInputEvent("Mouse_LUp", "HandleClicked_LookSlot(" .. index - 1 .. ")")
  end
end
function Panel_LookChange_Open()
  if Panel_Window_HorseLookChange:GetShow() then
    return
  end
  if Panel_Window_StableInfo:GetShow() then
    Panel_Window_StableInfo:SetShow(false)
  end
  Panel_Window_HorseLookChange:SetShow(true)
  Panel_Window_HorseLookChange:SetPosX(getScreenSizeX() - Panel_Window_HorseLookChange:GetSizeX() - 30)
  Panel_Window_HorseLookChange:SetPosY(30)
end
function Panel_LookChange_Close()
  if PaGlobal_StableType == CppEnums.ServantType.Type_Vehicle then
    Panel_HorseLookChange_Close()
  elseif PaGlobal_StableType == CppEnums.ServantType.Type_Ship then
    Panel_WharfLookChange_Close()
  end
end
function HandleClicked_LookSlot(index)
  LookChange_Set(nil, index)
end
function LookChange_Set(isNext, index)
  if PaGlobal_StableType == CppEnums.ServantType.Type_Vehicle then
    HorseLookChange_Set(isNext, index)
  elseif PaGlobal_StableType == CppEnums.ServantType.Type_Ship then
    WharfLookChange_Set(isNext, index)
  end
end
function LookChange_ChangeConfirm()
  if PaGlobal_StableType == CppEnums.ServantType.Type_Vehicle then
    HorseLookChange_ChangeConfirm()
  elseif PaGlobal_StableType == CppEnums.ServantType.Type_Ship then
    WharfLookChange_ChangeConfirm()
  end
end
registEventHandler()

function HandlerEventLUp_ExtractionSystem_ExtractButton()
  local currentInfo = PaGlobal_ExtractionSystem._currentInfo
  if -1 ~= currentInfo[1].slotNo and -1 ~= currentInfo[2].slotNo and -1 ~= currentInfo[4].itemKey then
    local itemName = getItemEnchantStaticStatus(currentInfo[4].itemKey):getName()
    local msgBoxTitle = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_EXTRACTIONSYSTEM_TITLE")
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXTRACTIONSYSTEM_POPUPMSG", "itemName", itemName)
    local messageBoxData = {
      title = msgBoxTitle,
      content = messageBoxMemo,
      functionYes = PaGlobal_ExtractionSystem_MessageBoxYes,
      functionNo = MessageBox_Empty_function,
      exitButton = true,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function HandleEventOn_ExtractionSystem_Slot(slotNo)
  if -1 == slotNo then
    PaGlobalFunc_FloatingTooltip_Close()
    return
  end
  local currentInfo = PaGlobal_ExtractionSystem._currentInfo
  local ItemSSW = getInventoryItemByType(currentInfo[slotNo].whereType, currentInfo[slotNo].slotNo)
  if nil == ItemSSW then
    if -1 ~= currentInfo[slotNo].itemKey and nil ~= currentInfo[slotNo].itemKey then
      ItemSSW = getItemEnchantStaticStatus(currentInfo[slotNo].itemKey)
    else
      return
    end
    if nil == ItemSSW then
      return
    end
  end
  local slot
  local isItemWrapper = false
  local isEnduranceEdit = false
  if 1 == slotNo then
    slot = PaGlobal_ExtractionSystem._ui.slot_SacrificeItem.icon
    isItemWrapper = true
  elseif 2 == slotNo then
    slot = PaGlobal_ExtractionSystem._ui.slot_CatalystItem.icon
    isItemWrapper = true
  elseif 3 == slotNo then
    slot = PaGlobal_ExtractionSystem._ui.slot_ExtractItem_1.icon
    isItemWrapper = false
    isEnduranceEdit = true
  elseif 4 == slotNo then
    slot = PaGlobal_ExtractionSystem._ui.slot_ExtractItem_2.icon
    isItemWrapper = false
  end
  if nil == slot then
    PaGlobalFunc_FloatingTooltip_Close()
    return
  end
  if true == isItemWrapper then
    PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemWrapper, ItemSSW, Defines.TooltipTargetType.Item, slot)
  else
    PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemSSWrapper, ItemSSW, Defines.TooltipTargetType.Item, slot)
  end
end
function PaGlobal_ExtractionSystem_MessageBoxYes()
  PaGlobal_ExtractionSystem._ui.slot_CatalystItem.icon:SetIgnore(true)
  PaGlobal_ExtractionSystem._ui.slot_SacrificeItem.icon:SetIgnore(true)
  PaGlobal_ExtractionSystem:buttonDisable(PaGlobal_ExtractionSystem._ui.stc_KeyGuideY)
  local currentInfo = PaGlobal_ExtractionSystem._currentInfo
  ToClient_requestExtractItem(currentInfo[1].slotNo, currentInfo[2].slotNo)
end
function PaGlobal_ExtractionSystem_Fillter_ForSacrificeTarget(slotNo, notUse_itemWrappers, whereType)
  local returnValue = true
  local ItemSSW = getInventoryItemByType(whereType, slotNo)
  if nil == ItemSSW then
    return
  end
  local Item = ItemSSW:get()
  if 0 < ItemSSW:getCronEnchantFailCount() then
    return true
  end
  if true == ToClient_isExtractFromItem(Item:getKey()) then
    returnValue = false
  else
    returnValue = true
  end
  return returnValue
end
function PaGlobal_ExtractionSystem_Fillter_ForCatalystTarget(slotNo, notUse_itemWrappers, whereType)
  local returnValue = true
  local ItemSSW = getInventoryItemByType(whereType, slotNo)
  if nil == ItemSSW then
    return
  end
  local Item = ItemSSW:get()
  if -1 == PaGlobal_ExtractionSystem._currentInfo[1].itemKey then
    return
  end
  if true == ToClient_isExtractNeedItem(PaGlobal_ExtractionSystem._currentInfo[1].itemKey, Item:getKey()) then
    returnValue = false
  else
    returnValue = true
  end
  return returnValue
end
function PaGlobal_ExtractionSystem_Fillter_AllBlock(slotNo, notUse_itemWrappers, whereType)
  return true
end
function PaGlobalFunc_ExtractSYSYEM_OnPadB()
  if true == PaGlobal_ExtractionSystem._isAnimation then
    return
  end
  if -1 ~= PaGlobal_ExtractionSystem._currentInfo[1].itemKey or -1 ~= PaGlobal_ExtractionSystem._currentInfo[2].itemKey or -1 ~= PaGlobal_ExtractionSystem._currentInfo[3].itemKey or -1 ~= PaGlobal_ExtractionSystem._currentInfo[4].itemKey then
    PaGlobal_ExtractionSystem:clearAllItemSlot()
    PaGlobal_ExtractionSystem:setInventory_ForSacrificeItem()
    ToClient_padSnapSetTargetPanel(Panel_Window_Inventory)
    return false
  else
    return true
  end
end
function PaGlobal_ExtractionSystem_MouseRUpExtractItem(slotNo, itemWrapper, Count, whereType)
  local ItemSSW = getInventoryItemByType(whereType, slotNo)
  if nil == ItemSSW then
    return
  end
  PaGlobal_ExtractionSystem._ui.slot_SacrificeItem:setItemByStaticStatus(ItemSSW:getStaticStatus())
  PaGlobal_ExtractionSystem._currentInfo[1].itemKey = ItemSSW:get():getKey()
  PaGlobal_ExtractionSystem._currentInfo[1].whereType = whereType
  PaGlobal_ExtractionSystem._currentInfo[1].slotNo = slotNo
  PaGlobal_ExtractionSystem:setInventory_AllBlocking()
  PaGlobal_ExtractionSystem:setItemToExtractSlot()
  PaGlobal_ExtractionSystem:setCatalystItem()
  ToClient_padSnapSetTargetPanel(Panel_Window_Extract_Renew)
end
function PaGlobal_ExtractionSystem_MouseRUpCatalystItem(slotNo, itemWrapper, Count, whereType)
  local ItemSSW = getInventoryItemByType(whereType, slotNo)
  if -1 == PaGlobal_ExtractionSystem._currentInfo[1].itemKey then
    return
  end
  PaGlobal_ExtractionSystem._ui.slot_CatalystItem:setItemByStaticStatus(ItemSSW:getStaticStatus())
  PaGlobal_ExtractionSystem._ui.slot_CatalystItem.icon:SetMonoTone(false)
  PaGlobal_ExtractionSystem._ui.slot_CatalystItem.count:SetText("1")
  PaGlobal_ExtractionSystem._currentInfo[2].itemKey = ItemSSW:get():getKey()
  PaGlobal_ExtractionSystem._currentInfo[2].whereType = whereType
  PaGlobal_ExtractionSystem._currentInfo[2].slotNo = slotNo
  PaGlobal_ExtractionSystem:setItemToExtractSlot()
  PaGlobal_ExtractionSystem:setInventory_AllBlocking()
end
function Update_ExtractSystem_EventTimeCheck(deltaTime)
  if false == PaGlobal_ExtractionSystem._isAnimation then
    return
  end
  PaGlobal_ExtractionSystem._current_AniTime = PaGlobal_ExtractionSystem._current_AniTime + deltaTime
  if PaGlobal_ExtractionSystem._current_AniTime > 3 and true == PaGlobal_ExtractionSystem._isSoundFX then
    _AudioPostEvent_SystemUiForXBOX(5, 19)
    PaGlobal_ExtractionSystem._isSoundFX = false
  end
  if PaGlobal_ExtractionSystem._const_AniTime < PaGlobal_ExtractionSystem._current_AniTime then
    local currentInfo = PaGlobal_ExtractionSystem._currentInfo
    PaGlobal_ExtractionSystem._isAnimation = false
    PaGlobal_ExtractionSystem._ui.slot_CatalystItem.icon:SetIgnore(false)
    PaGlobal_ExtractionSystem._ui.slot_SacrificeItem.icon:SetIgnore(false)
    PaGlobal_ExtractionSystem._current_AniTime = 0
    ToClient_requestExtractItem(currentInfo[1].slotNo, currentInfo[2].slotNo)
  end
end
function FromClient_ExtractSystem_GetExtractResult(rv)
  PaGlobal_ExtractionResult:resetChildControl()
  PaGlobal_ExtractionResult:resetAnimation()
  if 0 == rv then
    _AudioPostEvent_SystemUiForXBOX(3, 2)
    local currentInfo = PaGlobal_ExtractionSystem._currentInfo
    local itemName_1, itemName_2 = "", ""
    local itemSSW_1 = getItemEnchantStaticStatus(currentInfo[3].itemKey)
    if nil ~= itemSSW_1 then
      itemName_1 = itemSSW_1:getName()
    end
    local itemSSW_2 = getItemEnchantStaticStatus(currentInfo[4].itemKey)
    if nil ~= itemSSW_2 then
      itemName_2 = itemSSW_2:getName()
    end
    local mainString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_EXTRACTIONSYSTEM_RESULTMSG", "item1", itemName_1, "itme2", itemName_2)
    PaGlobal_ExtractionResult:showResultMessage(mainString, itemName_1 .. ", " .. itemName_2, currentInfo[3].itemKey, currentInfo[4].itemKey, nil, true)
    PaGlobal_ExtractionSystem:setInventory_ForSacrificeItem()
    PaGlobal_ExtractionSystem:completeExtractSetSlot()
    PaGlobal_ExtractionSystem:effectFunction(1)
  else
    _AudioPostEvent_SystemUiForXBOX(5, 2)
    local rvString = PAGetStringSymNo(rv)
    local carphString = PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantRegistCaphrasToExtract")
    local crystalString = PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantUsePushedJewelItem")
    local title = PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTIONSYSTEM_FAIL_TITLE")
    local sub = ""
    if rvString == carphString then
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTIONSYSTEM_FAIL_DESC_1")
    elseif rvString == crystalString then
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTIONSYSTEM_FAIL_DESC_2")
    else
      sub = rvString
    end
    PaGlobal_ExtractionResult:showResultMessage(sub, title, nil, nil, nil, false)
  end
  ExtractionSystemResult_TimerReset()
  Panel_Window_Extraction_Result:RegisterUpdateFunc("ExtractionSystem_CheckResultMsgShowTime")
end
function ExtractionSystemResult_TimerReset()
  PaGlobal_ExtractionSystem._resultShowTime = 0
end
function ExtractionSystem_CheckResultMsgShowTime(DeltaTime)
  PaGlobal_ExtractionSystem._resultShowTime = PaGlobal_ExtractionSystem._resultShowTime + DeltaTime
  if PaGlobal_ExtractionSystem._resultShowTime > 3 and true == Panel_Window_Extraction_Result:GetShow() then
    Panel_Window_Extraction_Result:SetShow(false)
  end
  if PaGlobal_ExtractionSystem._resultShowTime > 5 then
    PaGlobal_ExtractionSystem._resultShowTime = 0
  end
end
function PaGlobal_ExtractionSystem_ForceClose()
  PaGlobal_ExtractionSystem:clear()
end
function PaGlobal_ExtractionSystem_ForceOpen()
  PaGlobal_ExtractionSystem:open()
end

local alchemy = {
  _init = false,
  _panel = Panel_Window_Alchemy,
  _ui = {
    cookTitleControl,
    alchemyTitleControl,
    tipControl,
    focusGroupControl,
    knowledgeButtonControl,
    selectButtonControl,
    doCookButtonControl,
    doAlchemyButtonControl,
    removeMaterialButtonControl,
    closeButtonControl,
    cookingPotFrontControl,
    cookingPotBackControl,
    alchemyPotFrontControl,
    alchemyPotBackControl,
    list2
  },
  _invenFilterItemTypes = {
    [CppEnums.ItemType.Equip] = 1
  },
  _materialCount = 5,
  _materialSlotItemTable = {},
  _materialSlotItemBgTable = {},
  _cookingMaterialEffectSlotItem = {},
  _alchemyMaterialEffectSlotItem = {},
  _knownKnowledgeOnlyFlag = false,
  _isCook = false,
  _installationType = 0,
  _focusedMaterialSlotIndex = 0,
  _buttonGapX = 10,
  _readyToSelectFlag = false
}
function alchemy:initialize()
  if self._init then
    return
  end
  self._init = true
  local titleBarControl = UI.getChildControl(self._panel, "Static_TitleBG")
  self._ui.cookTitleControl = UI.getChildControl(titleBarControl, "StaticText_CookTitle")
  self._ui.alchemyTitleControl = UI.getChildControl(titleBarControl, "StaticText_AlchemyTitle")
  self._ui.cookTitleControl:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_COOKING"))
  self._ui.alchemyTitleControl:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_ALCHEMY"))
  local leftGroupControl = UI.getChildControl(self._panel, "LeftGroup")
  for i = 1, self._materialCount do
    local slotBgControl = UI.getChildControl(leftGroupControl, "Static_Item_Slot" .. i)
    table.insert(self._materialSlotItemBgTable, slotBgControl)
    local slot = {}
    SlotItem.new(slot, "Slot" .. i, i, slotBgControl, {
      createIcon = true,
      createBorder = true,
      createCount = true,
      createCash = true
    })
    slot:createChild()
    table.insert(self._materialSlotItemTable, slot)
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_AlchemyHandleSlotFocus(" .. i .. ", true)")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_AlchemyHandleSlotFocus(" .. i .. ", false)")
    slotBgControl:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_AlchemyChangeMaterialCount(" .. i .. ", 1)")
    slotBgControl:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_AlchemyChangeMaterialCount(" .. i .. ", -1)")
  end
  local tipBgControl = UI.getChildControl(leftGroupControl, "Static_Tip")
  self._ui.tipControl = UI.getChildControl(tipBgControl, "StaticText_Tip1")
  self._ui.tipControl:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.focusGroupControl = UI.getChildControl(leftGroupControl, "Static_Focus")
  local knowledgeControl = UI.getChildControl(self._panel, "Static_List_BG")
  self._ui.list2 = UI.getChildControl(knowledgeControl, "List2_Alchemy")
  self._ui.list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_AlchemyUpdateListItem")
  self._ui.list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.knowledgeButtonControl = UI.getChildControl(self._panel, "StaticText_Knowledge_ConsoleUI")
  self._ui.selectButtonControl = UI.getChildControl(self._panel, "StaticText_Select_ConsoleUI")
  self._ui.doCookButtonControl = UI.getChildControl(self._panel, "StaticText_DoCook_ConsoleUI")
  self._ui.doAlchemyButtonControl = UI.getChildControl(self._panel, "StaticText_DoAlchemy_ConsoleUI")
  self._ui.doAlchemyButtonControl:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_REFINING"))
  self._ui.removeMaterialButtonControl = UI.getChildControl(self._panel, "StaticText_RemoveMaterial_ConsoleUI")
  self._ui.closeButtonControl = UI.getChildControl(self._panel, "StaticText_Close_ConsoleUI")
  self._ui.doCookButtonControl:addInputEvent("Mouse_LUp", "PaGlobalFunc_AlchemyDo()")
  self._ui.doAlchemyButtonControl:addInputEvent("Mouse_LUp", "PaGlobalFunc_AlchemyDo()")
  self._ui.cookingPotFrontControl = UI.getChildControl(leftGroupControl, "Static_Cook_Pot_Front")
  self._ui.cookingPotBackControl = UI.getChildControl(leftGroupControl, "Static_Cook_Pot_Back")
  self._ui.cookingPotBackControl:AddEffect("fUI_AlchemyCook01", true, 0, 0)
  self._ui.alchemyPotFrontControl = UI.getChildControl(leftGroupControl, "Static_Alchemy_Pot_Front")
  self._ui.alchemyPotBackControl = UI.getChildControl(leftGroupControl, "Static_Alchemy_Pot_Back")
  self._ui.alchemyPotBackControl:AddEffect("fUI_AlchemyCook01", true, 0, 0)
  SlotItem.new(self._cookingMaterialEffectSlotItem, "AnimPushItemCook", 0, self._ui.cookingPotBackControl, {
    createIcon = true,
    createBorder = false,
    createCash = true
  })
  self._cookingMaterialEffectSlotItem:createChild()
  self._cookingMaterialEffectSlotItem.icon:SetShow(false)
  SlotItem.new(self._alchemyMaterialEffectSlotItem, "AnimPushItemCook", 0, self._ui.alchemyPotBackControl, {
    createIcon = true,
    createBorder = false,
    createCash = true
  })
  self._alchemyMaterialEffectSlotItem:createChild()
  self._alchemyMaterialEffectSlotItem.icon:SetShow(false)
  self._panel:registerPadEvent(__eConsoleUIPadEvent_A, "PaGlobalFunc_AlchemyReadyToSelect()")
  self._panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_AlchemySelectMultipleMaterials()")
  self._panel:registerPadEvent(__eConsoleUIPadEvent_Y, "PaGlobalFunc_AlchemyDo()")
  self._panel:ignorePadSnapMoveToOtherPanel()
  registerEvent("ResponseShowAlchemy", "PaGlobalFunc_AlchemyOpen")
  registerEvent("FromClient_AlchemyFailAck", "PaGlobalFunc_AlchemyResponse")
end
function alchemy:handleSlotFocus(index, flag)
  if flag then
    self._focusedMaterialSlotIndex = index
  else
    self._focusedMaterialSlotIndex = 0
  end
  return true
end
function PaGlobalFunc_AlchemyHandleSlotFocus(index, flag)
  if alchemy:handleSlotFocus(index, flag) then
    alchemy._panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
    return alchemy:update()
  end
end
function alchemy:completeMultipleSelection()
  if PaGlobalFunc_InventoryInfo_GetShow() then
    InventoryWindow_Close()
    return true
  end
end
function PaGlobalFunc_AlchemyCompleteMultipleSelection()
  return alchemy:completeMultipleSelection()
end
function alchemy:selectMultipleMaterials()
  if not _ContentsGroup_RenewUI_Inventory then
    return false
  end
  if not self._readyToSelectFlag then
    return false
  end
  self._readyToSelectFlag = false
  PaGlobalFunc_InventoryInfo_Open()
  Inventory_SetFunctor(PaGlobalFunc_AlchemyFilter, PaGlobalFunc_AlchemyHandleInventoryRightClick, nil, nil, {func = PaGlobalFunc_AlchemyCompleteMultipleSelection})
  Inventory_updateSlotData()
  return true
end
function PaGlobalFunc_AlchemySelectMultipleMaterials()
  if alchemy:selectMultipleMaterials() then
    return alchemy:update()
  end
end
function alchemy:readyToSelect()
  self._readyToSelectFlag = true
end
function PaGlobalFunc_AlchemyReadyToSelect()
  alchemy:readyToSelect()
end
function alchemy:changeMaterialCount(materialIndex, diffCount)
  local slotNo = ToClient_AlchemyGetMaterialSlotNoByIndex(materialIndex - 1)
  ToClient_AlchemyPushItemFromInventory(slotNo, diffCount)
  return true
end
function PaGlobalFunc_AlchemyChangeMaterialCount(materialIndex, diffCount)
  if alchemy:changeMaterialCount(materialIndex, diffCount) then
    return alchemy:update()
  end
end
function alchemy:selectKnowledge(knowledgeIndex)
  local knowledge = ToClient_AlchemyGetKnowledge(knowledgeIndex)
  if knowledge then
    PaGlobalFunc_AlchemyKnowledgeOpen(knowledge)
    return true
  end
end
function PaGlobalFunc_AlchemySelectKnowledge(knowledgeIndex)
  if alchemy:selectKnowledge(knowledgeIndex) then
    return alchemy:update()
  end
end
function alchemy:handleKnowledgeFocus(flag)
  self._knowledgeFocusFlag = flag
  return true
end
function PaGlobalFunc_AlchemyHandleKnowledgeFocus(flag, knowledgeIndex)
  if nil ~= knowledgeIndex then
    alchemy._panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_AlchemyShowKnowledge(" .. knowledgeIndex .. ")")
  end
  if alchemy:handleKnowledgeFocus(flag) then
    return alchemy:update()
  end
end
function PaGlobalFunc_AlchemyShowKnowledge(knowledgeIndex)
  alchemy:selectKnowledge(knowledgeIndex)
end
function alchemy:updateListItem(content, key)
  local knowledgeIndex = Int64toInt32(key)
  local knowledge = ToClient_AlchemyGetKnowledge(knowledgeIndex)
  if not knowledge then
    return
  end
  local buttonControl = UI.getChildControl(content, "RadioButton_Item")
  buttonControl:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  buttonControl:addInputEvent("Mouse_On", "PaGlobalFunc_AlchemyHandleKnowledgeFocus(true, " .. knowledgeIndex .. ")")
  buttonControl:addInputEvent("Mouse_Out", "PaGlobalFunc_AlchemyHandleKnowledgeFocus(false)")
  local learnFlag = isLearnMentalCardForAlchemy(knowledge:getKey())
  if learnFlag then
    buttonControl:SetFontColor(Defines.Color.C_FF84FFF5)
    buttonControl:SetText(knowledge:getName())
  else
    buttonControl:SetFontColor(Defines.Color.C_FF888888)
    buttonControl:SetText("??? ( " .. knowledge:getKeyword() .. " )")
  end
  content:SetShow(true)
  return true
end
function PaGlobalFunc_AlchemyUpdateListItem(content, key)
  if alchemy:updateListItem(content, key) then
  end
end
function alchemy:checkToDo()
  if ToClient_AlchemyGetCountSlotWithMaterial() <= 0 then
    return false
  end
  if ToClient_AlchemyGetMaxMassProductionCount() < Defines.s64_const.s64_1 then
    return false
  end
  return true
end
function alchemy:alchemyXXXXX()
  if not checkAlchemyAction() then
    return false
  end
  ToClient_AlchemyDo()
  return false
end
function PaGlobalFunc_AlchemyAlchemyXXXXX()
  if alchemy:alchemyXXXXX() then
    return alchemy:update()
  end
end
function alchemy:resume()
  self:alchemyXXX(ToClient_AlchemyGetDoingAlchemyCount())
  return true
end
function PaGlobalFunc_AlchemyResume()
  if alchemy:resume() then
    return alchemy:update()
  end
end
function alchemy:alchemyXXX(count)
  if not self:checkToDo() then
    return false
  end
  if not ToClient_AlchemySetupMaterialsForMassProduction(count) then
    _PA_ASSERT(false, "setupMaterialsForMassProduction\236\157\180 \236\139\164\237\140\168\237\150\136\236\138\181\235\139\136\235\139\164. countProduction\236\157\180 ToClient_AlchemyGetMaxMassProductionCount()\235\179\180\235\139\164 \237\129\176 \234\178\131\236\157\128 \236\149\132\235\139\140\236\167\128 \237\153\149\236\157\184\237\149\180\235\179\180\236\139\156\234\184\176 \235\176\148\235\158\141\235\139\136\235\139\164.")
  end
  ToClient_AlchemyStart(self._isCook, count)
  local progressBarTimeSec = ToClient_AlchemyGetAlchemyTime(self._isCook) / 1000
  if 0 == progressBarTimeSec then
    return false
  end
  EventProgressBarShow(true, progressBarTimeSec, true == self._isCook and 7 or 9)
  audioPostEvent_SystemUi(1, 0)
  _AudioPostEvent_SystemUiForXBOX(1, 0)
  self:close()
  return false
end
function PaGlobalFunc_AlchemyAlchemyXXX(count)
  if alchemy:alchemyXXX(count) then
    return alchemy:update()
  end
end
function alchemy:doAlchemy()
  if not self:checkToDo() then
    return false
  end
  function gotoNextStep(selectedButtonIndex)
    if 1 == selectedButtonIndex then
      self:alchemyXXX(Defines.s64_const.s64_1)
    elseif 2 == selectedButtonIndex then
      self:alchemyRepeat()
    end
  end
  MessageBoxCheck.showMessageBox({
    title = PAGetString(Defines.StringSheet_GAME, self._isCook and "LUA_ALCHEMY_COOKING" or "LUA_ALCHEMY_ALCHEMY"),
    content = PAGetString(Defines.StringSheet_GAME, self._isCook and "LUA_ALCHEMY_ASK_MULTIPLE_TIMES_COOK" or "LUA_ALCHEMY_ASK_MULTIPLE_TIMES"),
    functionApply = gotoNextStep,
    functionCancel = MessageBox_Empty_function,
    buttonStrings = {
      PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_BUTTON_TEXT_ONE_TIME"),
      PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_BUTTON_TEXT_MULTIPLE_TIMES")
    },
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }, "middle")
end
function PaGlobalFunc_AlchemyDo()
  if alchemy:doAlchemy() then
    return alchemy:update()
  end
end
function alchemy:alchemyRepeat()
  if not self:checkToDo() then
    return false
  end
  function gotoNextStep()
    Panel_NumberPad_Show(true, ToClient_AlchemyGetMaxMassProductionCount(), nil, PaGlobalFunc_AlchemyAlchemyXXX)
  end
  local msgBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
    content = PAGetString(Defines.StringSheet_GAME, self._isCook and "LUA_ALCHEMY_MSGBOX_COOK_SEQUENCE_MSG" or "LUA_ALCHEMY_MSGBOX_ALCHEMY_SEQUENCE_MSG"),
    functionYes = gotoNextStep,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(msgBoxData, "middle")
  return false
end
function PaGlobalFunc_AlchemyAlchemyRepeat()
  if alchemy:alchemyRepeat() then
    return alchemy:update()
  end
end
function alchemy:toggleKnownKnowledgeOnly()
  self._knownKnowledgeOnlyFlag = not self._knownKnowledgeOnlyFlag
  return self:initKnowledge()
end
function alchemy:cancel()
  ToClient_AlchemyCancel()
  return true
end
function PaGlobalFunc_AlchemyCancel()
  if alchemy:cancel() then
    return alchemy:update()
  end
end
function alchemy:response(isSuccess, hint, alchemyType, str, bDoingMassProduction)
  if isSuccess then
    return alchemy:responseSuccess(str)
  else
    return alchemy:responseFail(hint, alchemyType, str, bDoingMassProduction)
  end
end
function PaGlobalFunc_AlchemyResponse(isSuccess, hint, alchemyType, str, bDoingMassProduction)
  if alchemy:response(isSuccess, hint, alchemyType, str, bDoingMassProduction) then
    return alchemy:update()
  end
end
function alchemy:responseSuccess(str)
  Proc_ShowMessage_Ack(str)
  return true
end
function alchemy:responseFail(hint, alchemyType, strErr, bDoingMassProduction)
  if 1 == hint or 2 == hint or 3 == hint then
    local msg = {
      main = PAGetString(Defines.StringSheet_GAME, "ALCHEMYFAIL_REASON_" .. hint),
      sub = ""
    }
    local msgType = self._isCook and 27 or 26
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 2.5, msgType)
    if true == bDoingMassProduction then
      local failMsg = PAGetString(Defines.StringSheet_GAME, self._isCook and "LUA_ALCHEMY_COOKING" or "LUA_ALCHEMY_ALCHEMY")
      local messageBoxData = {
        title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMY_MSGBOX_FAIL_TITLE", "failMsg", failMsg),
        content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMY_MSGBOX_FAIL_MEMO", "failMsg", failMsg),
        functionYes = PaGlobalFunc_AlchemyResume,
        functionNo = PaGlobalFunc_AlchemyCancel,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    end
  else
    Proc_ShowMessage_Ack(strErr)
    self:cancel()
  end
  return true
end
function alchemy:filter(slotNo, itemWrapper, whereType)
  if CppEnums.ItemWhereType.eInventory ~= whereType then
    return true
  end
  local isTradable = itemWrapper:getStaticStatus():isPersonalTrade()
  local isVested = itemWrapper:get():isVested()
  if isTradable and isVested then
    return true
  end
  if itemWrapper:get():isSeized() then
    return true
  end
  local itemType = itemWrapper:getStaticStatus():getItemType()
  if self._invenFilterItemTypes[itemType] then
    return true
  end
  local isCash = itemWrapper:getStaticStatus():get():isCash()
  if isCash then
    return true
  end
  if self._materialCount <= ToClient_AlchemyGetCountSlotWithMaterial() and not ToClient_AlchemyIsInvenSlotPushedInMaterialSlot(slotNo) then
    return true
  end
  return false
end
function PaGlobalFunc_AlchemyFilter(slotNo, itemWrapper, whereType)
  return alchemy:filter(slotNo, itemWrapper, whereType)
end
function alchemy:showEffect(slotNo)
  local materialIndex = ToClient_AlchemyGetMaterialIndexBySlotNo(slotNo)
  if materialIndex < 0 then
    return
  end
  local item = ToClient_AlchemyGetItemStaticAtMaterialSlot(materialIndex)
  if not item then
    return
  end
  local effect = self._isCook and self._cookingMaterialEffectSlotItem or self._alchemyMaterialEffectSlotItem
  effect:setItemByStaticStatus(item)
  effect.icon:SetShow(true)
  local posX = 100
  local posY = -125
  local timeRate = 1
  local aniInfo = effect.icon:addMoveAnimation(0 * timeRate, 1.5 * timeRate, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo.StartHorizonType = CppEnums.PA_UI_ALIGNHORIZON.PA_UI_HORIZON_LEFT
  aniInfo.EndHorizonType = CppEnums.PA_UI_ALIGNHORIZON.PA_UI_HORIZON_LEFT
  aniInfo:SetStartPosition(posX, posY)
  aniInfo:SetEndPosition(posX, posY + 225)
  local aniInfo2 = effect.icon:addRotateAnimation(0 * timeRate, 1.5 * timeRate, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo2:SetStartRotate(0)
  aniInfo2:SetEndRotate(1)
  aniInfo2:SetRotateCount(1)
end
function alchemy:hideEffect()
  local effect = self._isCook and self._cookingMaterialEffectSlotItem or self._alchemyMaterialEffectSlotItem
  effect.icon:SetShow(false)
end
function alchemy:insertMaterial(slotNo)
  if checkAlchemyAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_NOT_CHANGE"))
    return false
  end
  ToClient_AlchemyPushItemFromInventory(slotNo, 1)
  self:showEffect(slotNo)
  return true
end
function alchemy:handleInventoryRightClick(slotNo, itemWrapper, count)
  PaGlobalFunc_InventoryInfo_ToggleMultipleSelect(slotNo, CppEnums.ItemWhereType.eInventory)
  if ToClient_AlchemyIsInvenSlotPushedInMaterialSlot(slotNo) then
    return self:removeMaterial(slotNo)
  else
    return self:insertMaterial(slotNo)
  end
  return false
end
function PaGlobalFunc_AlchemyHandleInventoryRightClick(slotNo, itemWrapper, count)
  if alchemy:handleInventoryRightClick(slotNo, itemWrapper, count) then
    return alchemy:update()
  end
end
function alchemy:initKnowledge()
  self._ui.list2:getElementManager():clearKey()
  if self._isCook then
    ToClient_AlchemyReconstructAlchemyKnowledge(30010)
  else
    ToClient_AlchemyReconstructAlchemyKnowledge(31000)
  end
  ToClient_AlchemySetKnowledgeFilter(self._knownKnowledgeOnlyFlag)
  for i = 0, ToClient_AlchemyGetCountFilteredKnowledge() - 1 do
    self._ui.list2:getElementManager():pushKey(ToClient_AlchemyGetFilteredKnowledgeIndex(i))
  end
  return true
end
function alchemy:open(isCook, installationType)
  if self:checkShow() then
    self:close()
    return false
  end
  self._ui.cookingPotFrontControl:SetShow(isCook)
  self._ui.cookingPotBackControl:SetShow(isCook)
  self._ui.alchemyPotFrontControl:SetShow(not isCook)
  self._ui.alchemyPotBackControl:SetShow(not isCook)
  self:hideEffect()
  self._isCook = isCook
  self._installationType = installationType
  self:initKnowledge()
  self._knownKnowledgeOnlyFlag = false
  ToClient_AlchemyClearMaterialSlot()
  Inventory_SetFunctor(PaGlobalFunc_AlchemyFilter, PaGlobalFunc_AlchemyHandleInventoryRightClick, PaGlobalFunc_AlchemyClose, nil)
  FGlobal_SetInventoryDragNoUse(self._panel)
  self._panel:SetShow(true)
  return true
end
function PaGlobalFunc_AlchemyOpen(isCook, installationType)
  if alchemy:open(isCook, installationType) then
    return alchemy:update()
  end
end
function alchemy:close()
  InventoryWindow_Close()
  self._panel:SetShow(false)
end
function PaGlobalFunc_AlchemyClose()
  return alchemy:close()
end
function alchemy:updateMaterial()
  if _ContentsGroup_RenewUI_Inventory then
    PaGlobalFunc_InventoryInfo_InitMultipleSelect()
  end
  local showFocusGroupControlFlag = 0 < self._focusedMaterialSlotIndex
  self._ui.focusGroupControl:SetShow(showFocusGroupControlFlag)
  for i = 1, table.getn(self._materialSlotItemTable) do
    local slotNo = ToClient_AlchemyGetMaterialSlotNoByIndex(i - 1)
    local showMaterialFlag = CppEnums.TInventorySlotNoUndefined ~= slotNo
    if self._focusedMaterialSlotIndex == i then
      local slotItemBg = self._materialSlotItemBgTable[i]
      self._ui.focusGroupControl:SetPosX(slotItemBg:GetPosX())
      self._ui.focusGroupControl:SetPosY(slotItemBg:GetPosY())
      UI.getChildControl(self._ui.focusGroupControl, "Static_Up"):SetShow(showMaterialFlag)
      UI.getChildControl(self._ui.focusGroupControl, "Static_Down"):SetShow(showMaterialFlag)
    end
    local slotItem = self._materialSlotItemTable[i]
    if not showMaterialFlag then
      slotItem:clearItem()
    else
      if _ContentsGroup_RenewUI_Inventory then
        PaGlobalFunc_InventoryInfo_ToggleMultipleSelect(slotNo, CppEnums.ItemWhereType.eInventory)
      end
      local item = ToClient_AlchemyGetItemStaticAtMaterialSlot(i - 1)
      local count = ToClient_AlchemyGetCountItemAtMaterialSlot_s64(i - 1)
      slotItem:setItemByStaticStatus(item, count)
    end
  end
end
function alchemy:updateButton()
  local showKnowledgeFlag = not PaGlobalFunc_InventoryInfo_GetShow() and not PaGlobalFunc_AlchemyKnowledgeCheckShow() and self._knowledgeFocusFlag and self._focusedMaterialSlotIndex <= 0
  local showSelectFlag = not PaGlobalFunc_InventoryInfo_GetShow() and not PaGlobalFunc_AlchemyKnowledgeCheckShow() and not MessageBoxCheck.isPopUp()
  local showDoCookFlag = not PaGlobalFunc_InventoryInfo_GetShow() and not PaGlobalFunc_AlchemyKnowledgeCheckShow() and not MessageBoxCheck.isPopUp() and 0 < ToClient_AlchemyGetCountSlotWithMaterial() and self._isCook
  local showDoAlchemyFlag = not PaGlobalFunc_InventoryInfo_GetShow() and not PaGlobalFunc_AlchemyKnowledgeCheckShow() and not MessageBoxCheck.isPopUp() and 0 < ToClient_AlchemyGetCountSlotWithMaterial() and not self._isCook
  local showRemoveMateiralFlag = not PaGlobalFunc_InventoryInfo_GetShow() and not PaGlobalFunc_AlchemyKnowledgeCheckShow() and self:checkToPop() and not MessageBoxCheck.isPopUp()
  local showCloseFlag = not PaGlobalFunc_InventoryInfo_GetShow() and not PaGlobalFunc_AlchemyKnowledgeCheckShow() and not self:checkToPop() and not MessageBoxCheck.isPopUp()
  local nextButtonPosX = self._ui.knowledgeButtonControl:GetPosX()
  self._ui.knowledgeButtonControl:SetShow(showKnowledgeFlag)
  if showKnowledgeFlag then
    self._ui.knowledgeButtonControl:SetPosX(nextButtonPosX)
    nextButtonPosX = self._ui.knowledgeButtonControl:GetPosX() + self._ui.knowledgeButtonControl:GetSizeX() + self._ui.knowledgeButtonControl:GetTextSizeX() + self._buttonGapX
  end
  self._ui.selectButtonControl:SetShow(showSelectFlag)
  if showSelectFlag then
    self._ui.selectButtonControl:SetPosX(nextButtonPosX)
    nextButtonPosX = self._ui.selectButtonControl:GetPosX() + self._ui.selectButtonControl:GetSizeX() + self._ui.selectButtonControl:GetTextSizeX() + self._buttonGapX
  end
  self._ui.doCookButtonControl:SetShow(showDoCookFlag)
  if showDoCookFlag then
    self._ui.doCookButtonControl:SetPosX(nextButtonPosX)
    nextButtonPosX = self._ui.doCookButtonControl:GetPosX() + self._ui.doCookButtonControl:GetSizeX() + self._ui.doCookButtonControl:GetTextSizeX() + self._buttonGapX
  end
  self._ui.doAlchemyButtonControl:SetShow(showDoAlchemyFlag)
  if showDoAlchemyFlag then
    self._ui.doAlchemyButtonControl:SetPosX(nextButtonPosX)
    nextButtonPosX = self._ui.doAlchemyButtonControl:GetPosX() + self._ui.doAlchemyButtonControl:GetSizeX() + self._ui.doAlchemyButtonControl:GetTextSizeX() + self._buttonGapX
  end
  self._ui.removeMaterialButtonControl:SetShow(showRemoveMateiralFlag)
  if showRemoveMateiralFlag then
    self._ui.removeMaterialButtonControl:SetPosX(nextButtonPosX)
    nextButtonPosX = self._ui.removeMaterialButtonControl:GetPosX() + self._ui.removeMaterialButtonControl:GetSizeX() + self._ui.removeMaterialButtonControl:GetTextSizeX() + self._buttonGapX
  end
  self._ui.closeButtonControl:SetShow(showCloseFlag)
  if showCloseFlag then
    self._ui.closeButtonControl:SetPosX(nextButtonPosX)
    nextButtonPosX = self._ui.closeButtonControl:GetPosX() + self._ui.closeButtonControl:GetSizeX() + self._ui.closeButtonControl:GetTextSizeX() + self._buttonGapX
  end
end
function alchemy:update()
  self._ui.cookTitleControl:SetShow(self._isCook)
  self._ui.alchemyTitleControl:SetShow(not self._isCook)
  self:updateMaterial()
  local tip = PAGetString(Defines.StringSheet_RESOURCE, "ALCHEMY_COOK_TEXT_DESCRPITION")
  self._ui.tipControl:SetText(tip)
  self:updateButton()
  return true
end
function alchemy:removeMaterial(slotNo)
  local materialIndex = ToClient_AlchemyGetMaterialIndexBySlotNo(slotNo)
  if materialIndex >= 0 then
    ToClient_AlchemyPopMaterial(materialIndex)
    return true
  end
end
function alchemy:checkToPop()
  return 0 < ToClient_AlchemyGetCountSlotWithMaterial()
end
function alchemy:popMaterial()
  if self:checkToPop() then
    ToClient_AlchemyPopMaterial(ToClient_AlchemyGetCountSlotWithMaterial() - 1)
    return true
  end
end
function alchemy:back()
  if self:popMaterial() then
    return true
  end
  if PaGlobalFunc_InventoryInfo_GetShow() then
    return InventoryWindow_Close()
  end
  if not self:checkShow() then
    return false
  end
  alchemy:close()
end
function PaGlobalFunc_AlchemyBack()
  if alchemy:back() then
    return alchemy:update()
  end
end
function alchemy:checkShow()
  return self._panel:GetShow()
end
function PaGlobalFunc_AlchemyCheckShow()
  return alchemy:checkShow()
end
function PaGlobalFunc_AlchemyPerFrameUpdate()
  return alchemy:perFrameUpdate()
end
function alchemy:perFrameUpdate()
end
function alchemy:changePlatformSpecKey()
end
function PaGlobalFunc_AlchemyInit()
  alchemy:initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_AlchemyInit")

local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TISNU = CppEnums.TInventorySlotNoUndefined
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
Panel_NewQuickSlot:SetShow(false)
local NewQuickSlot = {
  panelPool = {},
  config = {maxPanelCount = 20, isPressMove = false},
  slotConfig_Item = {
    createIcon = true,
    createBorder = false,
    createCount = true,
    createCooltime = true,
    createCooltimeText = true,
    createCash = true,
    createEnchant = true,
    createQuickslotBagIcon = true
  },
  slotConfig_Skill = {
    createIcon = true,
    createEffect = true,
    createFG = false,
    createFGDisabled = false,
    createLevel = false,
    createLearnButton = false,
    createCooltime = true,
    createCooltimeText = true,
    template = {effect}
  },
  slotKey = {
    [0] = CppEnums.ActionInputType.ActionInputType_QuickSlot1,
    [1] = CppEnums.ActionInputType.ActionInputType_QuickSlot2,
    [2] = CppEnums.ActionInputType.ActionInputType_QuickSlot3,
    [3] = CppEnums.ActionInputType.ActionInputType_QuickSlot4,
    [4] = CppEnums.ActionInputType.ActionInputType_QuickSlot5,
    [5] = CppEnums.ActionInputType.ActionInputType_QuickSlot6,
    [6] = CppEnums.ActionInputType.ActionInputType_QuickSlot7,
    [7] = CppEnums.ActionInputType.ActionInputType_QuickSlot8,
    [8] = CppEnums.ActionInputType.ActionInputType_QuickSlot9,
    [9] = CppEnums.ActionInputType.ActionInputType_QuickSlot10,
    [10] = CppEnums.ActionInputType.ActionInputType_QuickSlot11,
    [11] = CppEnums.ActionInputType.ActionInputType_QuickSlot12,
    [12] = CppEnums.ActionInputType.ActionInputType_QuickSlot13,
    [13] = CppEnums.ActionInputType.ActionInputType_QuickSlot14,
    [14] = CppEnums.ActionInputType.ActionInputType_QuickSlot15,
    [15] = CppEnums.ActionInputType.ActionInputType_QuickSlot16,
    [16] = CppEnums.ActionInputType.ActionInputType_QuickSlot17,
    [17] = CppEnums.ActionInputType.ActionInputType_QuickSlot18,
    [18] = CppEnums.ActionInputType.ActionInputType_QuickSlot19,
    [19] = CppEnums.ActionInputType.ActionInputType_QuickSlot20
  }
}
local NewQuickSlot_PanelList = {
  [0] = Panel_NewQuickSlot_0,
  [1] = Panel_NewQuickSlot_1,
  [2] = Panel_NewQuickSlot_2,
  [3] = Panel_NewQuickSlot_3,
  [4] = Panel_NewQuickSlot_4,
  [5] = Panel_NewQuickSlot_5,
  [6] = Panel_NewQuickSlot_6,
  [7] = Panel_NewQuickSlot_7,
  [8] = Panel_NewQuickSlot_8,
  [9] = Panel_NewQuickSlot_9,
  [10] = Panel_NewQuickSlot_10,
  [11] = Panel_NewQuickSlot_11,
  [12] = Panel_NewQuickSlot_12,
  [13] = Panel_NewQuickSlot_13,
  [14] = Panel_NewQuickSlot_14,
  [15] = Panel_NewQuickSlot_15,
  [16] = Panel_NewQuickSlot_16,
  [17] = Panel_NewQuickSlot_17,
  [18] = Panel_NewQuickSlot_18,
  [19] = Panel_NewQuickSlot_19
}
local NewQuickSlot_PanelID = {
  [0] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_0,
  [1] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_1,
  [2] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_2,
  [3] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_3,
  [4] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_4,
  [5] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_5,
  [6] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_6,
  [7] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_7,
  [8] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_8,
  [9] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_9,
  [10] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_10,
  [11] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_11,
  [12] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_12,
  [13] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_13,
  [14] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_14,
  [15] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_15,
  [16] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_16,
  [17] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_17,
  [18] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_18,
  [19] = CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_19
}
local NewQuickSlot_Lock = {
  [NewQuickSlot_PanelList[0]] = false,
  [NewQuickSlot_PanelList[1]] = false,
  [NewQuickSlot_PanelList[2]] = false,
  [NewQuickSlot_PanelList[3]] = false,
  [NewQuickSlot_PanelList[4]] = false,
  [NewQuickSlot_PanelList[5]] = false,
  [NewQuickSlot_PanelList[6]] = false,
  [NewQuickSlot_PanelList[7]] = false,
  [NewQuickSlot_PanelList[8]] = false,
  [NewQuickSlot_PanelList[9]] = false,
  [NewQuickSlot_PanelList[10]] = false,
  [NewQuickSlot_PanelList[11]] = false,
  [NewQuickSlot_PanelList[12]] = false,
  [NewQuickSlot_PanelList[13]] = false,
  [NewQuickSlot_PanelList[14]] = false,
  [NewQuickSlot_PanelList[15]] = false,
  [NewQuickSlot_PanelList[16]] = false,
  [NewQuickSlot_PanelList[17]] = false,
  [NewQuickSlot_PanelList[18]] = false,
  [NewQuickSlot_PanelList[19]] = false
}
potionData = {
  hp = {
    [0] = 502,
    [1] = 513,
    [2] = 514,
    [3] = 517,
    [4] = 518,
    [5] = 519,
    [6] = 524,
    [7] = 525,
    [8] = 528,
    [9] = 529,
    [10] = 530,
    [11] = 538,
    [12] = 551,
    [13] = 552,
    [14] = 553,
    [15] = 554,
    [16] = 555,
    [17] = 17568,
    [18] = 17569,
    [19] = 17679,
    [20] = 17681,
    [21] = 17682,
    [22] = 17683,
    [23] = 17684,
    [24] = 19932,
    [25] = 19933,
    [26] = 19934,
    [27] = 19935
  },
  mp = {
    [0] = 503,
    [1] = 520,
    [2] = 521,
    [3] = 522,
    [4] = 526,
    [5] = 527,
    [6] = 515,
    [7] = 516,
    [8] = 531,
    [9] = 532,
    [10] = 533
  }
}
PaGlobal_NewQuickSlot = {}
function PaGlobal_NewQuickSlot:addSlotEffectForTutorial(panelIdx, slot, effectString, isLoop, posX, posY)
  slot.item.icon:AddEffect(effectString, isLoop, posX, posY)
  local newQuickSlotPanel = NewQuickSlot_PanelList[panelIdx]
  PaGlobal_TutorialUiManager:getUiMasking():showNewQuickSlotMasking(newQuickSlotPanel:GetPosX() + newQuickSlotPanel:GetSizeX() * 0.5, newQuickSlotPanel:GetPosY() + newQuickSlotPanel:GetSizeY() * 0.5)
end
function PaGlobal_NewQuickSlot:eraseSlotEffectForTutorial(slot)
  slot.item.icon:EraseAllEffect()
  PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
end
function FGlobal_NewQuickSlot_InitPos(updateByServer)
  for panelIdx = 0, NewQuickSlot.config.maxPanelCount - 1 do
    local slot = NewQuickSlot.panelPool[panelIdx]
    if slot.Panel:GetRelativePosX() == -1 and slot.Panel:GetRelativePosY() == -1 then
      local slot = NewQuickSlot.panelPool[panelIdx]
      local initPosX = getScreenSizeX() * 0.35 + (slot.Panel:GetSizeX() + 5) * panelIdx
      local initPosY = getScreenSizeY() - slot.Panel:GetSizeY() - 5
      slot.Panel:SetPosX(initPosX)
      slot.Panel:SetPosY(initPosY)
      if updateByServer then
        changePositionBySever(slot.Panel, NewQuickSlot_PanelID[panelIdx], false, true, false)
      end
      FGlobal_InitPanelRelativePos(slot.Panel, initPosX, initPosY)
    elseif slot.Panel:GetRelativePosX() == 0 and slot.Panel:GetRelativePosY() == 0 then
      slot.Panel:SetPosX(getScreenSizeX() * 0.35 + (slot.Panel:GetSizeX() + 5) * panelIdx)
      slot.Panel:SetPosY(getScreenSizeY() - slot.Panel:GetSizeY() - 5)
    else
      slot.Panel:SetPosX(PaGlobalFunc_CalcPositionByRelativePos(getScreenSizeX() * slot.Panel:GetRelativePosX() - slot.Panel:GetSizeX() / 2))
      slot.Panel:SetPosY(PaGlobalFunc_CalcPositionByRelativePos(getScreenSizeY() * slot.Panel:GetRelativePosY() - slot.Panel:GetSizeY() / 2))
    end
    FGlobal_PanelRepostionbyScreenOut(slot.Panel)
  end
end
function FGlobal_NewQuickSlot_Hide()
  PaGlobalFunc_NewQuickSlot_SetShow(false, false)
end
function NewQuickSlot:Init()
  if false == _ContentsGroup_RenewUI_Skill then
    NewQuickSlot.slotConfig_Skill.template.effect = UI.getChildControl(Panel_Window_Skill, "Static_Icon_Skill_Effect")
  else
    NewQuickSlot.slotConfig_Skill.template.effect = PaGlobalFunc_Skill_GetEffectControl()
  end
  for panelIdx = 0, self.config.maxPanelCount - 1 do
    self.panelPool[panelIdx] = {}
    local slot = self.panelPool[panelIdx]
    slot.Panel = NewQuickSlot_PanelList[panelIdx]
    slot.Panel:SetIgnore(false)
    slot.Panel:SetShow(false)
    slot.PanelPosX = slot.Panel:GetPosX()
    slot.PanelPosY = slot.Panel:GetPosY()
    slot.Handle = UI.createAndCopyBasePropertyControl(Panel_NewQuickSlot, "Static_Handle", slot.Panel, "NewQuickSlot_" .. panelIdx .. "_Handle")
    slot.ResetKeyBtn = UI.createAndCopyBasePropertyControl(Panel_NewQuickSlot, "Button_Reset", slot.Panel, "NewQuickSlot_" .. panelIdx .. "_ResetBtn")
    slot.SlotBG = UI.createAndCopyBasePropertyControl(Panel_NewQuickSlot, "Static_SlotBG", slot.Panel, "NewQuickSlot_" .. panelIdx .. "_SlotBG")
    slot.SkillToggle = UI.createAndCopyBasePropertyControl(Panel_NewQuickSlot, "Static_SkillToggle", slot.Panel, "NewQuickSlot_" .. panelIdx .. "_SkillToggle")
    slot.Help = UI.createAndCopyBasePropertyControl(Panel_NewQuickSlot, "Static_BubbleBox", slot.Panel, "NewQuickSlot_" .. panelIdx .. "_SlotHelp")
    local itemSlot = {}
    SlotItem.new(itemSlot, "NewQuickSlot_" .. panelIdx, panelIdx, slot.SlotBG, NewQuickSlot.slotConfig_Item)
    itemSlot:createChild()
    itemSlot.icon:addInputEvent("Mouse_LUp", "HandleClicked_NewQuickSlot_Use( " .. panelIdx .. " )")
    itemSlot.icon:addInputEvent("Mouse_PressMove", "NewQuickSlot_DragStart(" .. panelIdx .. ")")
    itemSlot.icon:SetEnableDragAndDrop(true)
    itemSlot.icon:SetIgnore(false)
    itemSlot.icon:SetPosX(1)
    itemSlot.icon:SetPosY(1)
    slot.item = itemSlot
    local skillSlot = {}
    SlotSkill.new(skillSlot, panelIdx, slot.SlotBG, NewQuickSlot.slotConfig_Skill)
    skillSlot.icon:addInputEvent("Mouse_LUp", "HandleClicked_NewQuickSlot_Use( " .. panelIdx .. " )")
    skillSlot.icon:addInputEvent("Mouse_PressMove", "NewQuickSlot_DragStart(" .. panelIdx .. ")")
    skillSlot.icon:SetEnableDragAndDrop(true)
    skillSlot.icon:SetPosX(1)
    skillSlot.icon:SetPosY(1)
    slot.skill = skillSlot
    slot.SlotKey = UI.createAndCopyBasePropertyControl(Panel_NewQuickSlot, "StaticText_Key", slot.Panel, "NewQuickSlot_" .. panelIdx .. "_SlotKey")
    slot.Handle:ComputePos()
    slot.ResetKeyBtn:SetShow(false)
    slot.Handle:SetShow(false)
    slot.keyValue = nil
    slot.ResetKeyBtn:addInputEvent("Mouse_LUp", "HandleClick_NewQuickSlot_ResetKey( " .. panelIdx .. ")")
    slot.Panel:addInputEvent("Mouse_LUp", "NewQuickSlot_PanelDragEnd()")
    slot.Panel:addInputEvent("Mouse_On", "HandleOnOut_NewQuickSlot_ShowHandle( true,\t\t" .. panelIdx .. " )")
    slot.Panel:addInputEvent("Mouse_Out", "HandleOnOut_NewQuickSlot_ShowHandle( false,\t" .. panelIdx .. " )")
  end
  FGlobal_NewQuickSlot_InitPos(true)
end
NewQuickSlot:Init()
local panelToPanelIndex = {
  [Panel_NewQuickSlot_1] = 91,
  [Panel_NewQuickSlot_2] = 92,
  [Panel_NewQuickSlot_3] = 93,
  [Panel_NewQuickSlot_4] = 94,
  [Panel_NewQuickSlot_5] = 95,
  [Panel_NewQuickSlot_6] = 96,
  [Panel_NewQuickSlot_7] = 97,
  [Panel_NewQuickSlot_8] = 98,
  [Panel_NewQuickSlot_9] = 99,
  [Panel_NewQuickSlot_0] = 100,
  [Panel_NewQuickSlot_11] = 101,
  [Panel_NewQuickSlot_12] = 102,
  [Panel_NewQuickSlot_13] = 103,
  [Panel_NewQuickSlot_14] = 104,
  [Panel_NewQuickSlot_15] = 105,
  [Panel_NewQuickSlot_16] = 106,
  [Panel_NewQuickSlot_17] = 107,
  [Panel_NewQuickSlot_18] = 108,
  [Panel_NewQuickSlot_19] = 109,
  [Panel_NewQuickSlot_10] = 110
}
function FGlobal_NewQuickSlot_CheckNewQuickSlotShowAble()
  if false == isUseNewQuickSlot() then
    return false
  elseif false == _ContentsGroup_Tutorial_Renewal and false == PaGlobal_TutorialManager:isAllowShowQuickSlot() then
    return false
  end
  return true
end
function NewQuickSlot:UpdateMain()
  for panelIdx = 0, NewQuickSlot.config.maxPanelCount - 1 do
    local slot = NewQuickSlot.panelPool[panelIdx]
    slot.Panel:SetShow(false)
    slot.item.icon:addInputEvent("Mouse_On", "")
    slot.item.icon:addInputEvent("Mouse_Out", "")
    slot.skill.icon:addInputEvent("Mouse_On", "")
    slot.skill.icon:addInputEvent("Mouse_Out", "")
  end
  if false == FGlobal_NewQuickSlot_CheckNewQuickSlotShowAble() then
    FGlobal_NewQuickSlot_Hide()
    return
  end
  for panelIdx = 0, NewQuickSlot.config.maxPanelCount - 1 do
    local quickSlotKey = panelIdx
    local quickSlotInfo = getQuickSlotItem(quickSlotKey)
    local slot = NewQuickSlot.panelPool[panelIdx]
    if false == changePositionBySever(slot.Panel, panelToPanelIndex[slot.Panel], true, false, false) then
      slot.Panel:SetShow(false)
    end
    slot.Help:SetShow(false)
    slot.SlotKey:SetText(keyCustom_GetString_ActionKey(self.slotKey[panelIdx]))
    slot.item:clearItem()
    slot.skill:clearSkill()
    slot.SkillToggle:SetShow(false)
    if CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type then
      slot.SlotKey:SetFontColor(UI_color.C_FF626262)
      slot.keyValue = nil
      slot.item.icon:SetIgnore(false)
      slot.skill.icon:SetIgnore(false)
    elseif CppEnums.QuickSlotType.eItem == quickSlotInfo._type or CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type or CppEnums.QuickSlotType.eInstanceItem == quickSlotInfo._type then
      NewQuickSlot:UpdateItem(panelIdx, quickSlotInfo)
      slot.item.icon:SetIgnore(false)
      slot.skill.icon:SetIgnore(true)
      slot.Panel:SetShow(true)
    elseif CppEnums.QuickSlotType.eSkill == quickSlotInfo._type then
      NewQuickSlot:UpdateSkill(panelIdx, quickSlotInfo)
      slot.item.icon:SetIgnore(true)
      slot.skill.icon:SetIgnore(false)
      slot.Panel:SetShow(true)
      if isToggleSkillbySkillKey(quickSlotInfo._skillKey:get()) then
        if checkToggleSkillState(quickSlotInfo._skillKey:get()) then
          slot.SkillToggle:SetShow(true)
        else
          slot.SkillToggle:SetShow(false)
        end
      end
    end
    NewQuickSlot:SafetyPosition(panelIdx)
  end
end
function NewQuickSlot:SafetyPosition(panelIdx)
  local slot = NewQuickSlot.panelPool[panelIdx]
  local isLeftOut = slot.Panel:GetPosX() < 0
  local isRightOut = getScreenSizeX() - slot.Panel:GetSizeX() < slot.Panel:GetPosX()
  local isTopOut = 0 > slot.Panel:GetPosY()
  local isBottomOut = getScreenSizeY() - slot.Panel:GetSizeY() < slot.Panel:GetPosY()
  if isLeftOut then
    slot.Panel:SetPosX(0)
  end
  if isRightOut then
    slot.Panel:SetPosX(getScreenSizeX() - slot.Panel:GetSizeX())
  end
  if isTopOut then
    slot.Panel:SetPosY(0)
  end
  if isBottomOut then
    slot.Panel:SetPosY(getScreenSizeY() - slot.Panel:GetSizeY())
  end
end
function NewQuickSlot:UpdateItem(panelIdx, quickSlotInfo)
  local slot = NewQuickSlot.panelPool[panelIdx]
  local selfPlayer = getSelfPlayer():get()
  local inventoryType = QuickSlot_GetInventoryTypeFrom(quickSlotInfo._type)
  local inventory = selfPlayer:getInventoryByType(inventoryType)
  local invenSlotNo = inventory:getSlot(quickSlotInfo._itemKey)
  local itemStaticWrapper = getItemEnchantStaticStatus(quickSlotInfo._itemKey)
  local itemName = itemStaticWrapper:getName()
  local _const = Defines.s64_const
  local s64_stackCount = _const.s64_0
  if CppEnums.TInventorySlotNoUndefined ~= invenSlotNo then
    s64_stackCount = getInventoryItemByType(inventoryType, invenSlotNo):get():getCount_s64()
  end
  if CppEnums.ContentsEventType.ContentsType_InventoryBag == itemStaticWrapper:get():getContentsEventType() then
    invenSlotNo = ToClient_GetItemNoByInventory(inventoryType, quickSlotInfo._itemNo_s64)
    local itemWrapper = getInventoryItemByType(inventoryType, invenSlotNo)
    if nil ~= itemWrapper then
      slot.item:setItem(itemWrapper, invenSlotNo)
    end
  else
    slot.item:setItemByStaticStatus(itemStaticWrapper, s64_stackCount)
  end
  slot.item.icon:SetMonoTone(_const.s64_0 == s64_stackCount)
  slot.SlotKey:SetFontColor(UI_color.C_FF88DF00)
  slot.keyValue = invenSlotNo
  slot.item.icon:SetIgnore(false)
  slot.item.icon:addInputEvent("Mouse_On", "HandleOnOut_NewQuickSlot_ItemTooltip( true, " .. panelIdx .. " )")
  slot.item.icon:addInputEvent("Mouse_Out", "HandleOnOut_NewQuickSlot_ItemTooltip( fasle, " .. panelIdx .. " )")
  slot.item.icon:setTooltipEventRegistFunc("HandleOnOut_NewQuickSlot_ItemTooltip( true, " .. panelIdx .. " )")
  if 2 < getSelfPlayer():get():getLevel() and getSelfPlayer():get():getLevel() < 40 and toInt64(0, 0) == s64_stackCount then
    local itemKey = quickSlotInfo._itemKey:get()
    local hasNotPosion = false
    for hpIdx = 0, #potionData.hp - 1 do
      if itemKey == potionData.hp[hpIdx] then
        hasNotPosion = true
        break
      end
    end
    if hasNotPosion then
      slot.Help:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUICKSLOT_HAVENT_POTION_2", "itemName", itemName))
      slot.Help:SetSize(slot.Help:GetTextSizeX() + 25, slot.Help:GetTextSizeY() + 40)
      slot.Help:SetPosX(0)
      slot.Help:SetPosY(slot.Help:GetSizeY() * -1)
      slot.Help:SetShow(true)
    end
  end
end
function NewQuickSlot:UpdateSkill(panelIdx, quickSlotInfo)
  local slot = NewQuickSlot.panelPool[panelIdx]
  local skillNo = quickSlotInfo._skillKey:getSkillNo()
  local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
  slot.skill:setSkillTypeStatic(skillTypeStaticWrapper)
  slot.SlotKey:SetFontColor(UI_color.C_FF40D7FD)
  slot.keyValue = quickSlotInfo._skillKey
  slot.skill.icon:SetIgnore(false)
  slot.skill.icon:addInputEvent("Mouse_On", "HandleOnOut_NewQuickSlot_SkillTooltip( true, " .. panelIdx .. " )")
  slot.skill.icon:addInputEvent("Mouse_Out", "HandleOnOut_NewQuickSlot_SkillTooltip( false, " .. panelIdx .. " )")
  slot.skill.icon:setTooltipEventRegistFunc("HandleOnOut_NewQuickSlot_SkillTooltip( true, " .. panelIdx .. " )")
  Panel_SkillTooltip_SetPosition(panelIdx, slot.skill.icon, "QuickSlot")
end
function NewQuickSlot_PanelGetlock(panelIdx)
  local panel = NewQuickSlot_PanelList[panelIdx]
  NewQuickSlot_Lock[panelIdx] = ToClient_getSplitQuickSlotHold(panel)
end
function NewQuickSlot_PanelDrag(panelIdx)
  NewQuickSlot.config.isPressMove = true
  if NewQuickSlot_Lock[panelIdx] then
    return
  end
  local slot = NewQuickSlot.panelPool[panelIdx]
  local posX = getMousePosX() - slot.Panel:GetSizeX() * 0.5
  local posY = getMousePosY() - slot.Panel:GetSizeY() * 0.3
  slot.PanelPosX = posX
  slot.PanelPosY = posY
  slot.Panel:SetPosX(posX)
  slot.Panel:SetPosY(posY)
  local pickUpPanelPosX = slot.Panel:GetPosX()
  local pickUpPanelPosY = slot.Panel:GetPosY()
end
function NewQuickSlot_PanelDragEnd()
  ToClient_SaveUiInfo(false)
  NewQuickSlot.config.isPressMove = false
end
function HandleOnOut_NewQuickSlot_ShowHandle(isShow, panelIdx)
  if isCharacterCameraRotateMode() then
    return
  end
  local slot = NewQuickSlot.panelPool[panelIdx]
  if isShow then
    slot.Handle:SetShow(true)
    slot.ResetKeyBtn:SetShow(true)
  else
    local panelPosX = slot.Panel:GetPosX()
    local panelPosY = slot.Panel:GetPosY()
    local panelSizeX = slot.Panel:GetSizeX()
    local panelSizeY = slot.Panel:GetSizeY()
    local mousePosX = getMousePosX()
    local mousePosY = getMousePosY()
    if panelPosX < mousePosX and mousePosX < panelPosX + panelSizeX and panelPosY < mousePosY and mousePosY < panelPosY + panelSizeY then
      return
    end
    slot.ResetKeyBtn:SetShow(false)
    slot.Handle:SetShow(false)
    slot.ResetKeyBtn:SetShow(false)
    NewQuickSlot.config.isPressMove = false
  end
end
function HandleClick_NewQuickSlot_OpenSlotMenu(panelIdx)
  local slot = NewQuickSlot.panelPool[panelIdx]
  slot.ResetKeyBtn:SetShow(not isShow)
end
function HandleClick_NewQuickSlot_UnSet(panelIdx)
  local function clearSlot()
    quickSlot_Clear(panelIdx)
  end
  local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUICKSLOT_UNSET", "slotNo", panelIdx + 1)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
    content = messageContent,
    functionYes = clearSlot,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function HandleClick_NewQuickSlot_ResetKey(panelIdx)
  local function unsetKey()
    local isActionType = true
    FGlobal_NewShortCut_SetQuickSlot(panelIdx + 19, isActionType)
  end
  local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUICKSLOT_RESETKEY", "slotNo", panelIdx + 1)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
    content = messageContent,
    functionYes = unsetKey,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function HandleOnOut_NewQuickSlot_ItemTooltip(isShow, panelIdx)
  if isShow and false == NewQuickSlot.config.isPressMove then
    local slot = NewQuickSlot.panelPool[panelIdx]
    local selfPlayer = getSelfPlayer():get()
    local quickSlotInfo = getQuickSlotItem(panelIdx)
    local itemStaticWrapper = getItemEnchantStaticStatus(quickSlotInfo._itemKey)
    registTooltipControl(slot.item.icon, Panel_Tooltip_Item)
    local inventoryType = QuickSlot_GetInventoryTypeFrom(quickSlotInfo._type)
    local invenSlotNo = ToClient_GetItemNoByInventory(inventoryType, quickSlotInfo._itemNo_s64)
    local itemWrapper = getInventoryItemByType(inventoryType, invenSlotNo)
    if nil ~= itemWrapper then
      Panel_Tooltip_Item_Show(itemWrapper, slot.item.icon, false, true, nil, nil, nil, invenSlotNo)
    end
  else
    Panel_Tooltip_Item_hideTooltip()
  end
  HandleOnOut_NewQuickSlot_ShowHandle(isShow, panelIdx)
end
function HandleOnOut_NewQuickSlot_SkillTooltip(isShow, panelIdx)
  if isShow and false == NewQuickSlot.config.isPressMove then
    local slot = NewQuickSlot.panelPool[panelIdx]
    registTooltipControl(slot.skill.icon, Panel_Tooltip_Skill)
    Panel_SkillTooltip_Show(panelIdx, false, "QuickSlot")
  else
    Panel_SkillTooltip_Hide()
  end
  HandleOnOut_NewQuickSlot_ShowHandle(isShow, panelIdx)
end
function HandleClicked_NewQuickSlot_Use(panelIdx)
  if nil == panelIdx then
    return
  end
  local slot = NewQuickSlot.panelPool[panelIdx]
  local quickSlotKey = panelIdx
  local quickSlotInfo = getQuickSlotItem(quickSlotKey)
  local tempDragInfo
  if nil == quickSlotInfo then
    return
  end
  if nil ~= DragManager.dragStartPanel then
    local isAutoSetup = false
    NewQuickSlot_DropHandler(panelIdx, isAutoSetup)
  elseif CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type then
  elseif CppEnums.QuickSlotType.eItem == quickSlotInfo._type or CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type or CppEnums.QuickSlotType.eInstanceItem == quickSlotInfo._type then
    slot.item.icon:AddEffect("fUI_SkillButton01", false, 0, 0)
    slot.item.icon:AddEffect("UI_SkillButton01", false, 0, 0)
    PaGlobal_TutorialManager:handleNewQuickSlotClick(quickSlotInfo._itemKey:getItemKey())
    local whereType = QuickSlot_GetInventoryTypeFrom(quickSlotInfo._type)
    if nil ~= slot.item.item and isNearFusionCore() and isFusionItem(whereType, slot.keyValue) then
      audioPostEvent_SystemUi(8, 2)
      burnItemToActor(whereType, slot.keyValue, 1)
      return
    end
    local inventory = getSelfPlayer():get():getInventoryByType(whereType)
    local invenSlotNo = inventory:getSlot(quickSlotInfo._itemKey)
    if invenSlotNo >= inventory:sizeXXX() then
      return
    end
    local itemWrapper = getInventoryItemByType(whereType, invenSlotNo)
    local itemEnchantWrapper = itemWrapper:getStaticStatus()
    if 2 == itemEnchantWrapper:get()._vestedType:getItemKey() and false == itemWrapper:get():isVested() then
      local function bindingItemUse()
        audioPostEvent_SystemUi(8, 2)
        quickSlot_UseSlot(panelIdx)
      end
      local messageContent
      if itemEnchantWrapper:isUserVested() then
        messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_CONTENT_USERVESTED")
      else
        messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_CONTENT")
      end
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"),
        content = messageContent,
        functionYes = bindingItemUse,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
    elseif itemEnchantWrapper:isPopupItem() then
      Panel_UserItem_PopupItem(itemEnchantWrapper, whereType, invenSlotNo)
    elseif eConnectUiType.eConnectUi_Undefined ~= itemWrapper:getStaticStatus():getConnectUi() then
      ConnectUI(itemWrapper:getStaticStatus():getConnectUi())
    else
      audioPostEvent_SystemUi(8, 2)
      quickSlot_UseSlot(panelIdx)
    end
  elseif CppEnums.QuickSlotType.eSkill == quickSlotInfo._type and not slot.skill.cooltime:GetShow() then
    local skillStaticWrapper = getSkillTypeStaticStatus(quickSlotInfo._skillKey:getSkillNo())
    if skillStaticWrapper:getUiDisplayType() then
      SpiritGuide_Show()
    end
    audioPostEvent_SystemUi(8, 2)
    slot.skill.icon:AddEffect("fUI_SkillButton01", false, 0, 0)
    slot.skill.icon:AddEffect("UI_SkillButton01", false, 0, 0)
    quickSlot_UseSlot(panelIdx)
  end
end
function NewQuickSlot_DragStart(panelIdx)
  local quickSlotInfo = getQuickSlotItem(panelIdx)
  local slot = NewQuickSlot.panelPool[panelIdx]
  if CppEnums.QuickSlotType.eItem == quickSlotInfo._type or CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type or CppEnums.QuickSlotType.eInstanceItem == quickSlotInfo._type then
    local itemStaticWrapper = getItemEnchantStaticStatus(quickSlotInfo._itemKey)
    DragManager:setDragInfo(slot.Panel, nil, panelIdx, "Icon/" .. itemStaticWrapper:getIconPath(), NewQuickSlot_DropGround, nil)
  elseif CppEnums.QuickSlotType.eSkill == quickSlotInfo._type then
    local skillTypeStaticWrapper = getSkillTypeStaticStatus(quickSlotInfo._skillKey:getSkillNo())
    DragManager:setDragInfo(slot.Panel, nil, panelIdx, "Icon/" .. skillTypeStaticWrapper:getIconPath(), NewQuickSlot_DropGround, nil)
  end
end
function NewQuickSlot_DropHandler(panelIdx, isAutoSetup)
  if nil == DragManager.dragStartPanel then
    return false
  end
  local slot = NewQuickSlot.panelPool[panelIdx]
  local posX = getMousePosX() - slot.Panel:GetSizeX() * 0.5
  local posY = getMousePosY() - slot.Panel:GetSizeY() * 0.5
  slot.PanelPosX = posX
  slot.PanelPosY = posY
  local setSuccess = false
  if DragManager.dragStartPanel == Panel_Window_Inventory then
    local itemWrapper = getInventoryItemByType(DragManager.dragWhereTypeInfo, DragManager.dragSlotInfo)
    if nil ~= itemWrapper and (itemWrapper:getStaticStatus():get():isContentsEvent() or itemWrapper:getStaticStatus():get():isItemSkill() or itemWrapper:getStaticStatus():get():isItemInterAction() or itemWrapper:getStaticStatus():get():isUseToVehicle() or itemWrapper:getStaticStatus():get():isEquipable() or itemWrapper:getStaticStatus():get():isItemTent()) then
      quickSlot_RegistItem(panelIdx, DragManager.dragWhereTypeInfo, DragManager.dragSlotInfo)
      if isAutoSetup then
        slot.Panel:SetPosX(posX)
        slot.Panel:SetPosY(posY)
        slot.Panel:SetRelativePosX(posX / getScreenSizeX())
        slot.Panel:SetRelativePosY(posY / getScreenSizeY())
      end
      setSuccess = true
    end
  elseif DragManager.dragStartPanel == Panel_Window_Skill then
    quickSlot_RegistSkill(panelIdx, DragManager.dragSlotInfo)
    if isAutoSetup then
      slot.Panel:SetPosX(posX)
      slot.Panel:SetPosY(posY)
      slot.Panel:SetRelativePosX(posX / getScreenSizeX())
      slot.Panel:SetRelativePosY(posY / getScreenSizeY())
    end
    setSuccess = true
  elseif (DragManager.dragStartPanel == NewQuickSlot_PanelList[0] or DragManager.dragStartPanel == NewQuickSlot_PanelList[1] or DragManager.dragStartPanel == NewQuickSlot_PanelList[2] or DragManager.dragStartPanel == NewQuickSlot_PanelList[3] or DragManager.dragStartPanel == NewQuickSlot_PanelList[4] or DragManager.dragStartPanel == NewQuickSlot_PanelList[5] or DragManager.dragStartPanel == NewQuickSlot_PanelList[6] or DragManager.dragStartPanel == NewQuickSlot_PanelList[7] or DragManager.dragStartPanel == NewQuickSlot_PanelList[8] or DragManager.dragStartPanel == NewQuickSlot_PanelList[9] or DragManager.dragStartPanel == NewQuickSlot_PanelList[10] or DragManager.dragStartPanel == NewQuickSlot_PanelList[11] or DragManager.dragStartPanel == NewQuickSlot_PanelList[12] or DragManager.dragStartPanel == NewQuickSlot_PanelList[13] or DragManager.dragStartPanel == NewQuickSlot_PanelList[14] or DragManager.dragStartPanel == NewQuickSlot_PanelList[15] or DragManager.dragStartPanel == NewQuickSlot_PanelList[16] or DragManager.dragStartPanel == NewQuickSlot_PanelList[17] or DragManager.dragStartPanel == NewQuickSlot_PanelList[18] or DragManager.dragStartPanel == NewQuickSlot_PanelList[19]) and panelIdx ~= DragManager.dragSlotInfo then
    quickSlot_Swap(panelIdx, DragManager.dragSlotInfo)
    setSuccess = true
  end
  audioPostEvent_SystemUi(0, 8)
  DragManager:clearInfo()
  if setSuccess then
    slot.Panel:SetShow(true)
    ToClient_SaveUiInfo(false)
  end
  return setSuccess
end
function NewQuickSlot_DropGround(whereType, panelIdx)
  quickSlot_Clear(panelIdx)
  DragManager:clearInfo()
end
function FGlobal_SetNewQuickSlot_ByGroundClick(s64_itemCount, slotNo, whereType)
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  local emptySlotIdx
  Inventory_DropEscape()
  for panelIdx = 0, NewQuickSlot.config.maxPanelCount - 1 do
    local quickSlotKey = panelIdx
    local quickSlotInfo = getQuickSlotItem(quickSlotKey)
    if CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type then
      emptySlotIdx = panelIdx
      break
    end
  end
  if nil ~= emptySlotIdx then
    local isAutoSetup = true
    local setSuccess = NewQuickSlot_DropHandler(emptySlotIdx, isAutoSetup)
    local isActionType = true
    if setSuccess then
      FGlobal_NewShortCut_SetQuickSlot(emptySlotIdx + 19, isActionType)
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEWQUICKSLOT_DONTSET"))
    end
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEWQUICKSLOT_NOTHAVEEMPTY"))
  end
  DragManager:clearInfo()
end
function FGlobal_SetNewQuickSlot_BySkillGroundClick(skillKey)
  for panelIdx = 0, NewQuickSlot.config.maxPanelCount - 1 do
    local quickSlotKey = panelIdx
    local quickSlotInfo = getQuickSlotItem(quickSlotKey)
    if CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type then
      emptySlotIdx = panelIdx
      break
    end
  end
  if nil ~= emptySlotIdx then
    local isAutoSetup = true
    NewQuickSlot_DropHandler(emptySlotIdx, isAutoSetup)
    local isActionType = true
    FGlobal_NewShortCut_SetQuickSlot(emptySlotIdx + 19, isActionType)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEWQUICKSLOT_NOTHAVEEMPTY"))
  end
  DragManager:clearInfo()
end
function FGlobal_NewQuickSlot_Update()
  NewQuickSlot:UpdateMain()
end
function FGlobal_NewQuickSlot_CheckAndSetPotion(slotNo, itemType)
  local itemWrapper = getInventoryItem(slotNo)
  if 0 == itemType then
    for panelIdx = 0, NewQuickSlot.config.maxPanelCount - 1 do
      local quickSlotInfo = getQuickSlotItem(panelIdx)
      local quickType = quickSlotInfo._type
      if CppEnums.QuickSlotType.eItem == quickType or CppEnums.QuickSlotType.eCashItem == quickType or CppEnums.QuickSlotType.eInstanceItem == quickType then
        local itemKey = quickSlotInfo._itemKey:get()
        for hpIdx = 0, #potionData.hp - 1 do
          if itemKey == potionData.hp[hpIdx] then
            return true
          end
        end
      end
    end
    local emptySlotIndex = _newQuickSlot_EmptySlot_Check()
    if nil ~= emptySlotIndex then
      quickSlot_RegistItem(emptySlotIndex, 0, slotNo)
    end
  else
    for panelIdx = 0, NewQuickSlot.config.maxPanelCount - 1 do
      local quickSlotInfo = getQuickSlotItem(panelIdx)
      local quickType = quickSlotInfo._type
      if CppEnums.QuickSlotType.eItem == quickType or CppEnums.QuickSlotType.eCashItem == quickType or CppEnums.QuickSlotType.eInstanceItem == quickType then
        local itemKey = quickSlotInfo._itemKey:get()
        for mpIdx = 0, #potionData.mp - 1 do
          if itemKey == potionData.mp[mpIdx] then
            return true
          end
        end
      end
    end
    local emptySlotIndex = _newQuickSlot_EmptySlot_Check()
    if nil ~= emptySlotIndex then
      quickSlot_RegistItem(emptySlotIndex, 0, slotNo)
    end
  end
  return false
end
function _newQuickSlot_EmptySlot_Check()
  local emptySlotNo
  for panelIdx = 0, NewQuickSlot.config.maxPanelCount - 1 do
    local quickSlotInfo = getQuickSlotItem(panelIdx)
    if CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type then
      emptySlotNo = panelIdx
      break
    end
  end
  return emptySlotNo
end
function FromClient_NewQuickSlot_Update()
  NewQuickSlot:UpdateMain()
end
function Panel_NewQuickSlot_PositionReset()
  FGlobal_NewQuickSlot_InitPos(true)
end
local onEffectTime = 0
function NewQuickSlot_UpdatePerFrame(fDeltaTime)
  if false == FGlobal_NewQuickSlot_CheckNewQuickSlotShowAble() then
    FGlobal_NewQuickSlot_Hide()
    return
  end
  if fDeltaTime <= 0 then
    return
  end
  onEffectTime = onEffectTime + fDeltaTime
  for panelIdx = 0, NewQuickSlot.config.maxPanelCount - 1 do
    local quickSlotKey = panelIdx
    local quickSlotInfo = getQuickSlotItem(quickSlotKey)
    local slot = NewQuickSlot.panelPool[panelIdx]
    if slot.Panel:GetShow() then
      if CppEnums.QuickSlotType.eItem == quickSlotInfo._type or CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type or CppEnums.QuickSlotType.eInstanceItem == quickType then
        local remainTime = 0
        local itemReuseTime = 0
        local realRemainTime = 0
        local intRemainTime = 0
        local whereType = QuickSlot_GetInventoryTypeFrom(quickSlotInfo._type)
        if UI_TISNU ~= slot.keyValue then
          remainTime = getItemCooltime(whereType, slot.keyValue)
          itemReuseTime = getItemReuseCycle(whereType, slot.keyValue) / 1000
          realRemainTime = remainTime * itemReuseTime
          intRemainTime = realRemainTime - realRemainTime % 1 + 1
        end
        if isNearFusionCore() and isFusionItem(whereType, slot.keyValue) and onEffectTime > 3 then
          slot.item.icon:EraseAllEffect()
          slot.item.icon:AddEffect("UI_ItemInstall_Gold", false, 0, 0)
        end
        if remainTime > 0 then
          slot.item.cooltime:UpdateCoolTime(remainTime)
          slot.item.cooltime:SetShow(true)
          slot.item.cooltimeText:SetText(Time_Formatting_ShowTop(intRemainTime))
          if itemReuseTime >= intRemainTime then
            slot.item.cooltimeText:SetShow(true)
          else
            slot.item.cooltimeText:SetShow(false)
          end
        elseif slot.item.cooltime:GetShow() then
          slot.item.cooltime:SetShow(false)
          slot.item.cooltimeText:SetShow(false)
          local skillSlotItemPosX = slot.item.cooltime:GetParentPosX()
          local skillSlotItemPosY = slot.item.cooltime:GetParentPosY()
          Panel_CoolTime_Effect_Item_Slot:SetShow(true, true)
          Panel_CoolTime_Effect_Item_Slot:SetIgnore(true)
          Panel_CoolTime_Effect_Item_Slot:AddEffect("fUI_Skill_Cooltime01", false, 2.5, 7)
          Panel_CoolTime_Effect_Item_Slot:SetPosX(skillSlotItemPosX - 7)
          Panel_CoolTime_Effect_Item_Slot:SetPosY(skillSlotItemPosY - 10)
        end
        PaGlobal_TutorialManager:handleUpdateNewQuickSlotPerFrame(panelIdx, slot, quickSlotInfo._itemKey:getItemKey())
      elseif CppEnums.QuickSlotType.eSkill == quickSlotInfo._type then
        local skillStaticWrapper = getSkillStaticStatus(quickSlotInfo._skillKey:getSkillNo(), quickSlotInfo._skillKey:getLevel())
        local isLearned = ToClient_isLearnedSkill(quickSlotInfo._skillKey:getSkillNo())
        if nil ~= skillStaticWrapper then
          if skillStaticWrapper:isUsableSkill() and true == isLearned then
            slot.skill.icon:SetMonoTone(false)
          else
            slot.skill.icon:SetMonoTone(true)
          end
        end
        local remainTime = getSkillCooltime(quickSlotInfo._skillKey:get())
        local skillReuseTime = skillStaticWrapper:get()._reuseCycle / 1000
        local realRemainTime = remainTime * skillReuseTime
        local intRemainTime = realRemainTime - realRemainTime % 1 + 1
        if remainTime > 0 then
          slot.skill.cooltime:UpdateCoolTime(remainTime)
          slot.skill.cooltime:SetShow(true)
          slot.skill.cooltimeText:SetText(Time_Formatting_ShowTop(intRemainTime))
          if skillReuseTime >= intRemainTime then
            slot.skill.cooltimeText:SetShow(true)
          else
            slot.skill.cooltimeText:SetShow(false)
          end
        elseif slot.skill.cooltime:GetShow() then
          slot.skill.cooltime:SetShow(false)
          slot.skill.cooltimeText:SetShow(false)
          local skillSlotPosX = slot.skill.cooltime:GetParentPosX()
          local skillSlotPosY = slot.skill.cooltime:GetParentPosY()
          Panel_CoolTime_Effect_Slot:SetShow(true, true)
          Panel_CoolTime_Effect_Slot:SetIgnore(true)
          Panel_CoolTime_Effect_Slot:AddEffect("fUI_Skill_Cooltime01", false, 2.5, 7)
          Panel_CoolTime_Effect_Slot:SetPosX(skillSlotPosX - 7)
          Panel_CoolTime_Effect_Slot:SetPosY(skillSlotPosY - 8)
        end
      end
    end
  end
  if onEffectTime > 3 then
    onEffectTime = 0
  end
end
function PaGlobalFunc_NewQuickSlot_SetShow(isShow, isAni)
  if false == _ContentsGroup_RenewUI then
    Panel_NewQuickSlot:SetShow(isShow, isAni)
  else
    Panel_NewQuickSlot:SetShow(false, false)
  end
end
registerEvent("refreshQuickSlot_ack", "FromClient_NewQuickSlot_Update")
registerEvent("FromClient_InventoryUpdate", "FromClient_NewQuickSlot_Update")
registerEvent("onScreenResize", "Panel_NewQuickSlot_PositionReset")
registerEvent("FromClient_RenderModeChangeState", "Panel_NewQuickSlot_PositionReset")

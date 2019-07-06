local UI_TM = CppEnums.TextMode
function LoadComplete_SkillWindow_Initialize()
  PaGlobal_Skill:initialize()
  PaGlobal_AwakenSkill:initalize()
  PaGlobal_SuccessionSkill:initalize()
  Skill_RegistEventHandler()
end
function SkillEvent_SkillWindow_ControlInitialize()
  local self = PaGlobal_Skill
  if self.controlInitialize then
    return
  end
  self:initTabControl_Combat()
  self:initTabControl_AwakeningWeapon()
  self:initTabControl_Succession()
  self:initTabControl_Combination(true)
  self.slotConfig.template.effect:SetShow(false)
  self.slotConfig.template.iconFG:SetShow(false)
  self.slotConfig.template.iconFGDisabled:SetShow(false)
  self.slotConfig.template.learnButton:SetShow(false)
  self.slotConfig.template.lockIcon:SetShow(false)
  self.radioButtons[self.combatTabIndex]:SetCheck(true)
  self.radioButtons[self.awakenTabIndex]:SetCheck(false)
  self.radioButtons[self.successionTabIndex]:SetCheck(false)
  HandleMLUp_SkillWindow_UpdateData(self.combatTabIndex, false, true)
  self._btn_MovieToolTipDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._btn_MovieToolTipDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SKILL_MOVIETOOLTIP"))
  self.controlInitialize = true
end
function SkillEvent_SkillWindow_LearnQuest(skillNo)
  local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
  if false == skillTypeStaticWrapper:isValidLocalizing() then
    return
  end
  local self = PaGlobal_Skill
  if nil ~= self.skillNoSlot[skillNo] then
    audioPostEvent_SystemUi(4, 2)
    self.skillNoSlot[skillNo].icon:AddEffect("UI_NewSkill01", false, 0, 0)
    self.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill01", false, 0, 0)
    PaGlobal_Window_Skill_CoolTimeSlot:skillUpdate()
  end
  UI_MAIN_checkSkillLearnable()
end
function SkillEvent_SkillWindow_ClearSkill(skillPointType)
  local strTemp1, strTemp2
  if 0 == skillPointType then
    strTemp1 = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_CLEAR_COMBAT_SKILL_TITLE")
    strTemp2 = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_CLEAR_COMBAT_SKILL_MESSAGE")
  else
    strTemp1 = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_CLEAR_PRODUCT_SKILL_TITLE")
    strTemp2 = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_CLEAR_PRODUCT_SKILL_MESSAGE")
  end
  local messageboxData = {
    title = strTemp1,
    content = strTemp2,
    functionYes = Skill_ClearSkill_ConfirmFromMessageBox,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function Handle_SkillEnable_CoolTime_Change()
  if true == Panel_EnableSkill:GetShow() then
    Panel_EnableSkill:SetShow(false)
    PaGlobal_Window_Skill_CoolTimeSlot:showFunc()
  else
    Panel_EnableSkill:SetShow(true)
    PaGlobal_Window_Skill_CoolTimeSlot:closeFunc()
  end
  Panel_SkillCombination:SetShow(false)
end
function SkillEvent_SkillWindow_ClearSkillsByPoint()
  HandleMLUp_SkillWindow_UpdateData()
end
function HandleMLUp_SkillWindow_UpdateData(tabIndex, isLearnMode, doForce)
  local self = PaGlobal_Skill
  tabIndex = tabIndex or self.lastTabIndex
  self.tabIndex = tabIndex
  isLearnMode = isLearnMode or self.lastLearnMode
  doForce = doForce or false
  if not doForce and not Panel_Window_Skill:GetShow() then
    return
  end
  self.lastTabIndex = tabIndex
  self.lastLearnMode = isLearnMode
  for index, frame in pairs(self.frames) do
    if tabIndex == index then
      frame:SetShow(true)
      PaGlobal_Skill.radioButtons[index]:SetCheck(true)
    else
      frame:SetShow(false)
      PaGlobal_Skill.radioButtons[index]:SetCheck(false)
    end
  end
  self.learnableSlotsSortList = {}
  self.learnableSlotsSortListCount = 0
  local slots = self.slots[tabIndex]
  for skillNo, slot in pairs(slots) do
    slot.iconMinus:SetShow(false)
    slot.icon:addInputEvent("Mouse_LUp", "HandleMLUp_SkillWindow_LearnButtonClick(" .. skillNo .. ")")
    slot.icon:EraseAllEffect()
    do
      local skillLevelInfo = getSkillLevelInfo(skillNo)
      if nil ~= skillLevelInfo then
        self.saved_isLearnMode = isLearnMode
        local resultAble = slot:setSkill(skillLevelInfo, isLearnMode)
        if false == resultAble then
          self.learnableSlotsSortList[self.learnableSlotsSortListCount] = skillNo
          self.learnableSlotsSortListCount = self.learnableSlotsSortListCount + 1
        end
        local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
        if false == skillLevelInfo._learnable and skillLevelInfo._usable and skillTypeStaticWrapper:get()._isSettableQuickSlot then
          slot.icon:addInputEvent("Mouse_PressMove", "HandleMLUp_SkillWindow_StartDrag(" .. skillNo .. ")")
          slot.icon:SetEnableDragAndDrop(true)
        else
          slot.icon:addInputEvent("Mouse_PressMove", "")
          slot.icon:SetEnableDragAndDrop(false)
        end
        local skillStaticWrapper = getSkillStaticStatus(skillNo, 1)
        if nil ~= skillStaticWrapper then
          local function changeTextureLockIcon(isBlockSkill)
            if isBlockSkill then
              slot.lockIcon:ChangeTextureInfoName("renewal/pcremaster/remaster_btn_00.dds")
              local x1, y1, x2, y2 = setTextureUV_Func(slot.lockIcon, 364, 177, 382, 195)
              slot.lockIcon:getBaseTexture():setUV(x1, y1, x2, y2)
              slot.lockIcon:setRenderTexture(slot.lockIcon:getBaseTexture())
              slot.lockIcon:ChangeOnTextureInfoName("renewal/pcremaster/remaster_btn_00.dds")
              local x1, y1, x2, y2 = setTextureUV_Func(slot.lockIcon, 364, 177, 382, 195)
              slot.lockIcon:getOnTexture():setUV(x1, y1, x2, y2)
              slot.lockIcon:ChangeClickTextureInfoName("renewal/pcremaster/remaster_btn_00.dds")
              local x1, y1, x2, y2 = setTextureUV_Func(slot.lockIcon, 364, 110, 382, 128)
              slot.lockIcon:getClickTexture():setUV(x1, y1, x2, y2)
            else
              slot.lockIcon:ChangeTextureInfoName("renewal/pcremaster/remaster_btn_00.dds")
              local x1, y1, x2, y2 = setTextureUV_Func(slot.lockIcon, 364, 110, 382, 128)
              slot.lockIcon:getBaseTexture():setUV(x1, y1, x2, y2)
              slot.lockIcon:setRenderTexture(slot.lockIcon:getBaseTexture())
              slot.lockIcon:ChangeOnTextureInfoName("renewal/pcremaster/remaster_btn_00.dds")
              local x1, y1, x2, y2 = setTextureUV_Func(slot.lockIcon, 383, 110, 401, 128)
              slot.lockIcon:getOnTexture():setUV(x1, y1, x2, y2)
              slot.lockIcon:ChangeClickTextureInfoName("renewal/pcremaster/remaster_btn_00.dds")
              local x1, y1, x2, y2 = setTextureUV_Func(slot.lockIcon, 364, 177, 382, 195)
              slot.lockIcon:getClickTexture():setUV(x1, y1, x2, y2)
            end
          end
          local skillTypeStaticStatusWrapper = skillStaticWrapper:getSkillTypeStaticStatusWrapper()
          if false == skillLevelInfo._learnable and skillLevelInfo._usable and skillTypeStaticStatusWrapper:isSkillCommandCheck() then
            slot.lockIcon:SetShow(true)
            local isBlockSkill = ToClient_isBlockSkillCommand(skillLevelInfo._skillKey)
            changeTextureLockIcon(isBlockSkill)
            slot.lockIcon:addInputEvent("Mouse_LUp", "Request_SkillCommandLock(" .. skillNo .. ")")
            slot.lockIcon:addInputEvent("Mouse_On", "SkillCommandTooltip(" .. skillNo .. ", " .. tabIndex .. ", true )")
            slot.lockIcon:addInputEvent("Mouse_Out", "SkillCommandTooltip(" .. skillNo .. ", " .. tabIndex .. ", false )")
            if not isBlockSkill then
              slot.lockIcon:SetShow(false)
            end
          else
            slot.lockIcon:SetShow(false)
            slot.lockIcon:addInputEvent("Mouse_LUp", "")
          end
        end
      end
      self.skillNoSlot[skillNo] = slot
    end
  end
  self:UpdateLearnableSlots()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    self.staticRemainPoint:SetShow(false)
    self.staticSkillLevel:SetShow(false)
    self.progressSkillExp:SetShow(false)
  else
    self.staticSkillLevel:SetShow(false)
    self.progressSkillExp:SetShow(false)
    local skillPointInfo = ToClient_getSkillPointInfo(0)
    if nil ~= skillPointInfo then
      self.staticRemainPoint:SetText(tostring(skillPointInfo._remainPoint .. " / " .. skillPointInfo._acquirePoint))
      self.staticRemainPoint:SetPosX(self.textSkillPoint:GetPosX() + self.textSkillPoint:GetTextSizeX() + 10)
    end
  end
  if self.isPartsSkillReset then
    self:SkillWindow_UpdateClearData()
  end
  self.awakenDesc:SetShow(false)
  PaGlobal_Window_Skill_CoolTimeSlot:skillUpdate()
end
function PAGlobalFunc_BlackSkillLock(skillNo)
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  if nil ~= skillLevelInfo then
    local isBlockSkill = ToClient_isBlockBlackSpiritSkill(skillLevelInfo._skillKey)
    if isBlockSkill then
      ToClient_enableblockBlackSpiritSkill(skillLevelInfo._skillKey)
    else
      ToClient_blockBlackSpiritSkill(skillLevelInfo._skillKey)
    end
  end
end
function Request_SkillCommandLock(skillNo)
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  if nil ~= skillLevelInfo then
    local isBlockSkill = ToClient_isBlockSkillCommand(skillLevelInfo._skillKey)
    if isBlockSkill then
      ToClient_enableSkillCommand(skillLevelInfo._skillKey)
    else
      ToClient_blockSkillCommand(skillLevelInfo._skillKey)
    end
    local function changeTextureLockIcon(isBlockSkill)
      local slot = PaGlobal_Skill.skillNoSlot[skillNo]
      if isBlockSkill then
        slot.lockIcon:ChangeTextureInfoName("renewal/pcremaster/remaster_btn_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(slot.lockIcon, 364, 177, 382, 195)
        slot.lockIcon:getBaseTexture():setUV(x1, y1, x2, y2)
        slot.lockIcon:setRenderTexture(slot.lockIcon:getBaseTexture())
        slot.lockIcon:ChangeOnTextureInfoName("renewal/pcremaster/remaster_btn_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(slot.lockIcon, 364, 177, 382, 195)
        slot.lockIcon:getOnTexture():setUV(x1, y1, x2, y2)
        slot.lockIcon:ChangeClickTextureInfoName("renewal/pcremaster/remaster_btn_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(slot.lockIcon, 364, 110, 382, 128)
        slot.lockIcon:getClickTexture():setUV(x1, y1, x2, y2)
      else
        slot.lockIcon:ChangeTextureInfoName("renewal/pcremaster/remaster_btn_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(slot.lockIcon, 364, 110, 382, 128)
        slot.lockIcon:getBaseTexture():setUV(x1, y1, x2, y2)
        slot.lockIcon:setRenderTexture(slot.lockIcon:getBaseTexture())
        slot.lockIcon:ChangeOnTextureInfoName("renewal/pcremaster/remaster_btn_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(slot.lockIcon, 383, 110, 401, 128)
        slot.lockIcon:getOnTexture():setUV(x1, y1, x2, y2)
        slot.lockIcon:ChangeClickTextureInfoName("renewal/pcremaster/remaster_btn_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(slot.lockIcon, 364, 177, 382, 195)
        slot.lockIcon:getClickTexture():setUV(x1, y1, x2, y2)
      end
    end
    changeTextureLockIcon(not isBlockSkill)
    TooltipSimple_Hide()
  end
end
function SkillCommandTooltip(skillNo, tabIndex, isShow)
  if not isShow then
    local skillLevelInfo = getSkillLevelInfo(skillNo)
    local isBlockSkill = ToClient_isBlockSkillCommand(skillLevelInfo._skillKey)
    if not isBlockSkill then
      PaGlobal_Skill.skillNoSlot[skillNo].lockIcon:SetShow(false)
    else
      PaGlobal_Skill.skillNoSlot[skillNo].lockIcon:SetShow(true)
    end
    TooltipSimple_Hide()
    return
  end
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  if nil ~= skillLevelInfo then
    local name, desc, uiControl
    local isBlockSkill = ToClient_isBlockSkillCommand(skillLevelInfo._skillKey)
    if isBlockSkill then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_COMMANDLOCK_TITLE")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_COMMANDLOCK_DESC")
    else
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_COMMANDUNLOCK_TITLE")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_COMMANDUNLOCK_DESC")
    end
    uiControl = PaGlobal_Skill.slots[tabIndex][skillNo].lockIcon
    TooltipSimple_Show(uiControl, name, desc)
  end
end
function HandleMLUp_SkillWindow_OpenForLearn()
  local self = PaGlobal_Skill
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  self.saved_isLearnMode = true
  if not Panel_Window_Skill:IsShow() then
    UIAni.fadeInSCRDialog_Down(Panel_Window_Skill)
    Panel_Window_Skill:SetShow(true, IsAniUse())
    if screenSizeX <= 1400 then
      Panel_Window_Skill:SetPosX(screenSizeX / 2 - Panel_Window_Skill:GetSizeX() / 2 - 100)
    else
      Panel_Window_Skill:SetPosX(screenSizeX / 2 - Panel_Window_Skill:GetSizeX() / 2 - 150)
    end
    Panel_Window_Skill:SetPosY(screenSizeY / 2 - Panel_Window_Skill:GetSizeY() / 2)
    EnableSkillShowFunc()
    Panel_EnableSkill_SetPosition()
    self:OpenLearnAni1()
    self:OpenLearnAni2()
  end
  HandleMLUp_SkillWindow_UpdateData(self.tabIndex, true)
  local combatCheck = self.radioButtons[self.combatTabIndex]:IsCheck()
  if combatCheck then
    self.radioButtons[self.combatTabIndex]:SetCheck(true)
    self.radioButtons[self.awakenTabIndex]:SetCheck(false)
    HandleMLUp_SkillWindow_UpdateData(self.combatTabIndex)
  else
    self.radioButtons[self.combatTabIndex]:SetCheck(false)
    self.radioButtons[self.awakenTabIndex]:SetCheck(true)
    HandleMLUp_SkillWindow_UpdateData(self.awakenTabIndex)
  end
  FGlobal_SetUrl_Tooltip_SkillForLearning()
end
function HandleMLUp_SkillWindow_Close(isManualClick)
  if Panel_Window_Skill:IsShow() then
    PaGlobal_Skill.isPartsSkillReset = false
    local self = PaGlobal_Skill
    self.lastLearnMode = true
    self.saved_isLearnMode = true
    Panel_SkillTooltip_Hide()
    UIMain_SkillPointUpdateRemove()
    Panel_Window_Skill:SetShow(false, true)
    Panel_SkillCombination:SetShow(false)
    Panel_SkillCombination._isFirstOpen = false
    Panel_SkillCombination._currentSlotIndex = -1
    Panel_Scroll:SetShow(false, false)
    FGlobal_EnableSkillCloseFunc()
    PaGlobal_Window_Skill_CoolTimeSlot:closeFunc()
    FGlobal_BlackSpiritSkillLock_Close()
    if nil ~= Panel_Npc_Dialog and true == Panel_Npc_Dialog:GetShow() then
      Dialog_updateButtons()
    end
    if nil ~= Panel_Npc_Dialog_All and true == Panel_Npc_Dialog_All:GetShow() then
      PaGlobalFunc_DialogMain_All_BottomFuncBtnUpdate()
    end
  end
  for _, value in pairs(PaGlobal_Skill.skillNoSlot) do
    value.icon:EraseAllEffect()
  end
  HelpMessageQuestion_Out()
  local vScroll = PaGlobal_Skill.frames[0]:GetVScroll()
  PaGlobal_Skill.scrollPos = 0
  FGlobal_ResetUrl_Tooltip_SkillForLearning()
  TooltipSimple_Hide()
end
function HandleMOver_SkillWindow_ToolTipHide(skillNo, SlotType, isFusion)
  if PaGlobal_Skill.skillNoCache == skillNo and PaGlobal_Skill.slotTypeCache == SlotType then
    PaGlobal_Skill.tooltipcacheCount = PaGlobal_Skill.tooltipcacheCount - 1
  else
    PaGlobal_Skill.tooltipcacheCount = 0
  end
  if PaGlobal_Skill.tooltipcacheCount <= 0 then
    Panel_SkillTooltip_Hide()
  end
  for _, value in pairs(PaGlobal_Skill.skillNoSlot) do
    value.iconMinus:SetShow(false)
  end
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  if isFusion then
    return
  end
  if nil == skillLevelInfo then
    return
  end
  local isBlockSkill = ToClient_isBlockSkillCommand(skillLevelInfo._skillKey)
  if not isBlockSkill and not Panel_Tooltip_SimpleText:GetShow() then
    local skillStaticWrapper = getSkillStaticStatus(skillNo, 1)
    if nil == skillStaticWrapper then
      return
    end
    local skillTypeStaticStatusWrapper = skillStaticWrapper:getSkillTypeStaticStatusWrapper()
    if false == skillLevelInfo._learnable and skillLevelInfo._usable and skillTypeStaticStatusWrapper:isSkillCommandCheck() then
      PaGlobal_Skill.skillNoSlot[skillNo].lockIcon:SetShow(false)
    end
  end
end
function HandleMOver_SkillWindow_ToolTipShow(skillNo, isShowNextLevel, SlotType, isFusion)
  if PaGlobal_Skill.skillNoCache == skillNo and PaGlobal_Skill.slotTypeCache == SlotType then
    PaGlobal_Skill.tooltipcacheCount = PaGlobal_Skill.tooltipcacheCount + 1
  else
    PaGlobal_Skill.skillNoCache = skillNo
    PaGlobal_Skill.slotTypeCache = SlotType
    PaGlobal_Skill.tooltipcacheCount = 1
  end
  Panel_SkillTooltip_Show(skillNo, false, SlotType)
  if false == isFusion then
    PaGlobal_Skill.skillNoSlot[skillNo].icon:EraseAllEffect()
  end
  if "SkillBoxBottom" == SlotType then
    local selectedSlot = UI.getChildControl(PaGlobal_Skill.frames[0]:GetFrameContent(), "StaticSkill_" .. skillNo)
    PaGlobal_Skill:Skill_WindowPosSet(selectedSlot:GetPosY())
  end
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  if nil == skillLevelInfo then
    return
  end
  if isFusion then
    return
  end
  if skillLevelInfo._usable then
    local isAwakenSkillBtn = PaGlobal_Skill.radioButtons[PaGlobal_Skill.awakenTabIndex]:IsCheck()
    local isSuccessionSkillBtn = PaGlobal_Skill.radioButtons[PaGlobal_Skill.successionTabIndex]:IsCheck()
    local slots
    if isAwakenSkillBtn then
      slots = PaGlobal_Skill.slots[PaGlobal_Skill.awakenTabIndex]
    elseif isSuccessionSkillBtn then
      slots = PaGlobal_Skill.slots[PaGlobal_Skill.successionTabIndex]
    else
      slots = PaGlobal_Skill.slots[PaGlobal_Skill.combatTabIndex]
    end
    local skillStaticWrapper = getSkillStaticStatus(skillNo, 1)
    if nil == skillStaticWrapper then
      return
    end
    if not skillStaticWrapper:isAutoLearnSkillByLevel() and not skillStaticWrapper:isLearnSkillByItem() and skillStaticWrapper:isLastSkill() then
      slots[skillNo].iconMinus:SetShow(true)
      if false == GlobalSwitch_UseDummyPlayerSkillWindow then
        slots[skillNo].icon:addInputEvent("Mouse_RUp", "HandleMLUp_SkillWindow_ClearButtonClick(" .. skillNo .. ")")
      else
        slots[skillNo].icon:addInputEvent("Mouse_RUp", "TestFunc_SkillAction(" .. skillNo .. ")")
      end
      Panel_SkillTooltip_Show(skillNo, false, SlotType, nil, true)
    end
  end
  local skillStaticWrapper = getSkillStaticStatus(skillNo, 1)
  local skillTypeStaticStatusWrapper = skillStaticWrapper:getSkillTypeStaticStatusWrapper()
  if false == skillLevelInfo._learnable and skillLevelInfo._usable and skillTypeStaticStatusWrapper:isSkillCommandCheck() then
    PaGlobal_Skill.skillNoSlot[skillNo].lockIcon:SetShow(true)
  end
end
function HandleMLUp_SkillWindow_LearnButtonClick(skillNo)
  audioPostEvent_SystemUi(0, 0)
  local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
  if nil == skillTypeStaticWrapper then
    return
  end
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  if nil == skillLevelInfo then
    return
  end
  if false == skillLevelInfo._learnable then
    return
  end
  local function DolearnSkill()
    PaGlobal_Skill:SkillWindow_LearnButtonClick(skillNo)
    EnableSkillWindow_EffectOff()
  end
  local skillType = skillTypeStaticWrapper:requiredEquipType()
  if 55 == skillType then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_SKILLTYPE_MEMO1")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = DolearnSkill,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  elseif 56 == skillType then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_SKILLTYPE_MEMO2")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = DolearnSkill,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    DolearnSkill()
  end
end
function HandleMLUp_SkillWindow_ClearButtonClick(skillNo)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local function partlySkillReset()
    local returnValue = ToClient_RequestClearSkillPartly(skillNo)
    PaGlobal_Skill.isPartsSkillReset = false
    if 0 == returnValue then
      ToClient_clearSkillCoolTimeSlot(skillNo)
    end
  end
  partlySkillReset()
end
function HandleMLUp_SkillWindow_StartDrag(skillNo)
  if Defines.UIMode.eUIMode_NpcDialog == GetUIMode() then
    return
  end
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
  if nil ~= skillLevelInfo and nil ~= skillTypeStaticWrapper then
    DragManager:setDragInfo(Panel_Window_Skill, nil, skillLevelInfo._skillKey:get(), "Icon/" .. skillTypeStaticWrapper:getIconPath(), Skill_GroundClick, nil)
  end
end
function HandleMScroll_SkillWindow_ScrollEvent(isShow)
  local vScroll = PaGlobal_Skill.frames[0]:GetVScroll()
  if isShow then
  else
    UIScrollButton.ScrollButtonEvent(false, Panel_Window_Skill, PaGlobal_Skill.frames[0], vScroll)
  end
end
function Skill_GroundClick(whereType, skillKey)
  if isUseNewQuickSlot() then
    FGlobal_SetNewQuickSlot_BySkillGroundClick(skillKey)
  end
end
function Skill_ClearSkill_ConfirmFromMessageBox()
  skillWindow_ClearSkill()
  if PaGlobal_Skill.radioButtons[PaGlobal_Skill.combatTabIndex]:IsCheck() then
    HandleMLUp_SkillWindow_UpdateData(PaGlobal_Skill.combatTabIndex)
  else
    HandleMLUp_SkillWindow_UpdateData(PaGlobal_Skill.awakenTabIndex)
  end
end
function Skill_RegistEventHandler()
  local vScroll = PaGlobal_Skill.frames[0]:GetVScroll()
  vScroll:addInputEvent("Mouse_LDown", "HandleMScroll_SkillWindow_ScrollEvent(true)")
  PaGlobal_Skill.buttonClose:addInputEvent("Mouse_LUp", "HandleMLUp_SkillWindow_Close( true )")
  PaGlobal_Skill._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowSkill\" )")
  PaGlobal_Skill._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelWindowSkill\", \"true\")")
  PaGlobal_Skill._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelWindowSkill\", \"false\")")
  PaGlobal_Skill.frames[0]:addInputEvent("Mouse_UpScroll", "HandleMScroll_SkillWindow_ScrollEvent(true)")
  PaGlobal_Skill.frames[0]:addInputEvent("Mouse_DownScroll", "HandleMScroll_SkillWindow_ScrollEvent(true)")
  PaGlobal_Skill.frames[0]:addInputEvent("Mouse_On", "HandleMScroll_SkillWindow_ScrollEvent(true)")
  PaGlobal_Skill.frames[0]:addInputEvent("Mouse_Out", "HandleMScroll_SkillWindow_ScrollEvent(false)")
  PaGlobal_Skill._btn_MovieToolTip:addInputEvent("Mouse_LUp", "PaGlobal_MovieSkillGuide_Web:Open()")
  PaGlobal_Skill._btn_MovieToolTip2:addInputEvent("Mouse_LUp", "PaGlobal_MovieSkillGuide_Web:Open()")
  if true == _ContentsGroup_skillOldandNew then
    PaGlobal_Skill._btn_BlackSpiritLock:addInputEvent("Mouse_LUp", "FGlobal_BlackSpiritSkillLock_Open(2)")
  end
  PaGlobal_Skill.radioButtons[PaGlobal_Skill.combatTabIndex]:addInputEvent("Mouse_LUp", "HandleMLUp_SkillWindow_UpdateData(" .. PaGlobal_Skill.combatTabIndex .. ")")
  PaGlobal_Skill.radioButtons[PaGlobal_Skill.awakenTabIndex]:addInputEvent("Mouse_LUp", "HandleMLUp_SkillWindow_UpdateData(" .. PaGlobal_Skill.awakenTabIndex .. ")")
  PaGlobal_Skill.radioButtons[PaGlobal_Skill.successionTabIndex]:addInputEvent("Mouse_LUp", "HandleMLUp_SkillWindow_UpdateData(" .. PaGlobal_Skill.successionTabIndex .. ")")
  Panel_Window_Skill:RegisterShowEventFunc(true, "Skill_ShowAni()")
  Panel_Window_Skill:RegisterShowEventFunc(false, "Skill_HideAni()")
  PaGlobal_Skill._btn_ResetAllSkill:addInputEvent("Mouse_LUp", "SkillEvent_SkillWindow_ClearSkill(" .. 0 .. ")")
  PaGlobal_Skill._btn_ResetAllSkill:addInputEvent("Mouse_On", "SkillEvent_ResetTooltip( true )")
  PaGlobal_Skill._btn_ResetAllSkill:addInputEvent("Mouse_Out", "SkillEvent_ResetTooltip()")
  PaGlobal_Skill._btn_Enable_CoolTime_Change:addInputEvent("Mouse_LUp", "Handle_SkillEnable_CoolTime_Change()")
  PaGlobal_Skill._btn_Enable_CoolTime_Change:addInputEvent("Mouse_On", "Handle_SkillCollTimeTooltip( true )")
  PaGlobal_Skill._btn_Enable_CoolTime_Change:addInputEvent("Mouse_Out", "Handle_SkillCollTimeTooltip()")
end
function SkillEvent_ResetTooltip(isShow)
  if nil == isShow then
    TooltipSimple_Hide()
    return
  end
  local uiControl = PaGlobal_Skill._btn_ResetAllSkill
  local name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SKILL_RESETALL")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_RESETBUTTON_TOOLTIPDESC")
  TooltipSimple_Show(uiControl, name, desc)
end
function Handle_SkillCollTimeTooltip(isShow)
  if nil == isShow then
    TooltipSimple_Hide()
    return
  end
  local uiControl = PaGlobal_Skill._btn_Enable_CoolTime_Change
  local name = ""
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_COOLTIMESLOT_TOOLTIPDESC")
  TooltipSimple_Show(uiControl, name, desc)
end
function SkillEvent_SkillWindow_ClearSkillMessage()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_RESETSUCCESS"))
  HandleMLUp_SkillWindow_UpdateData()
  PaGlobal_Window_Skill_CoolTimeSlot:skillUpdate()
end
function Skill_RegistMessageHandler()
  registerEvent("FromClient_luaLoadComplete", "LoadComplete_SkillWindow_Initialize")
  registerEvent("EventSkillWindowInit", "SkillEvent_SkillWindow_ControlInitialize")
  registerEvent("EventlearnedSkill", "SkillEvent_SkillWindow_LearnQuest")
  registerEvent("EventSkillWindowClearSkill", "SkillEvent_SkillWindow_ClearSkill")
  registerEvent("EventSkillWindowClearSkillByPoint", "HandleMLUp_SkillWindow_UpdateData")
  registerEvent("EventSkillWindowClearSkillAll", "SkillEvent_SkillWindow_ClearSkillMessage")
  registerEvent("EventSkillWindowUpdate", "HandleMLUp_SkillWindow_UpdateData")
  registerEvent("EventSkillWindowShowForLearn", "HandleMLUp_SkillWindow_OpenForLearn")
  registerEvent("FromClient_SkillWindowClose", "HandleMLUp_SkillWindow_UpdateData")
end
Skill_RegistMessageHandler()

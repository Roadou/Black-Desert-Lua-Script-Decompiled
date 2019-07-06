local UI_TM = CppEnums.TextMode
PaGlobal_Skill = {
  slotConfig = {
    createIcon = true,
    createEffect = true,
    createFG = true,
    createFGDisabled = true,
    createFG_Passive = true,
    createMinus = true,
    createLevel = true,
    createLearnButton = true,
    createTestimonial = true,
    createLockIcon = true,
    createMouseOver = true,
    template = {
      effect = UI.getChildControl(Panel_Window_Skill, "Static_Icon_Skill_Effect"),
      iconFG = UI.getChildControl(Panel_Window_Skill, "Static_Icon_FG"),
      iconFGDisabled = UI.getChildControl(Panel_Window_Skill, "Static_Icon_FG_DISABLE"),
      iconFG_Passive = UI.getChildControl(Panel_Window_Skill, "Static_Icon_BG"),
      iconMinus = UI.getChildControl(Panel_Window_Skill, "Static_Icon_Skill_EffectMinus"),
      learnButton = UI.getChildControl(Panel_Window_Skill, "Button_Skill_Point"),
      mouseOverButton = UI.getChildControl(Panel_Window_Skill, "Button_Skill_OverMouse"),
      testimonial = UI.getChildControl(Panel_Window_Skill, "Static_Skill_Effect"),
      lockIcon = UI.getChildControl(Panel_Window_Skill, "Static_SkillLockIcon")
    }
  },
  config = {
    slotStartX = 6,
    slotStartY = 6,
    slotGapX = 42,
    slotGapY = 42,
    emptyGapX = 22,
    emptyGapY = 18
  },
  slots = {
    [0] = {},
    {},
    {}
  },
  staticBottomBox,
  learnableSlotShowMaxCount = 8,
  learnableSlots = {},
  learnableSlotCount = 0,
  learnableSlotsSortList = {},
  learnableSlotsSortListCount = 0,
  skillNoSlot = {},
  combatTabIndex = 0,
  awakenTabIndex = 1,
  successionTabIndex = 2,
  tabIndex = 0,
  savedAwaken = false,
  lastTabIndex = 0,
  lastLearnMode = false,
  controlInitialize = false,
  radioButtons = {
    [0] = UI.getChildControl(Panel_Window_Skill, "RadioButton_Tab_Combat"),
    UI.getChildControl(Panel_Window_Skill, "RadioButton_Tab_Product"),
    UI.getChildControl(Panel_Window_Skill, "RadioButton_Tab_SuccessionSkill")
  },
  staticRemainPoint = UI.getChildControl(Panel_Window_Skill, "Static_Text_RemainSkillPoint"),
  buttonClose = UI.getChildControl(Panel_Window_Skill, "Button_Close"),
  _buttonQuestion = UI.getChildControl(Panel_Window_Skill, "Button_Question"),
  staticSkillLevel = UI.getChildControl(Panel_Window_Skill, "Static_Text_Skill_Level"),
  textSkillPoint = UI.getChildControl(Panel_Window_Skill, "Static_Text_SkillPoint"),
  progressSkillExp = UI.getChildControl(Panel_Window_Skill, "Progress2_SkillExpGage"),
  frames = {
    [0] = UI.getChildControl(Panel_Window_Skill, "Frame_Combat"),
    UI.getChildControl(Panel_Window_Skill, "Frame_Awaken"),
    UI.getChildControl(Panel_Window_Skill, "Frame_SuccessionSkill")
  },
  template_guideLine = {
    h = {
      [3] = UI.getChildControl(Panel_Window_Skill, "Static_TypeH_LT"),
      [4] = UI.getChildControl(Panel_Window_Skill, "Static_TypeH_CT"),
      [5] = UI.getChildControl(Panel_Window_Skill, "Static_TypeH_RT"),
      [6] = UI.getChildControl(Panel_Window_Skill, "Static_TypeH_LM"),
      [7] = UI.getChildControl(Panel_Window_Skill, "Static_TypeH_CM"),
      [8] = UI.getChildControl(Panel_Window_Skill, "Static_TypeH_RM"),
      [9] = UI.getChildControl(Panel_Window_Skill, "Static_TypeH_LB"),
      [10] = UI.getChildControl(Panel_Window_Skill, "Static_TypeH_CB"),
      [11] = UI.getChildControl(Panel_Window_Skill, "Static_TypeH_RB"),
      [12] = UI.getChildControl(Panel_Window_Skill, "Static_TypeH_HORI"),
      [13] = UI.getChildControl(Panel_Window_Skill, "Static_TypeH_VERTI")
    },
    v = {
      [3] = UI.getChildControl(Panel_Window_Skill, "Static_TypeV_LT"),
      [4] = UI.getChildControl(Panel_Window_Skill, "Static_TypeV_CT"),
      [5] = UI.getChildControl(Panel_Window_Skill, "Static_TypeV_RT"),
      [6] = UI.getChildControl(Panel_Window_Skill, "Static_TypeV_LM"),
      [7] = UI.getChildControl(Panel_Window_Skill, "Static_TypeV_CM"),
      [8] = UI.getChildControl(Panel_Window_Skill, "Static_TypeV_RM"),
      [9] = UI.getChildControl(Panel_Window_Skill, "Static_TypeV_LB"),
      [10] = UI.getChildControl(Panel_Window_Skill, "Static_TypeV_CB"),
      [11] = UI.getChildControl(Panel_Window_Skill, "Static_TypeV_RB"),
      [12] = UI.getChildControl(Panel_Window_Skill, "Static_TypeV_HORI"),
      [13] = UI.getChildControl(Panel_Window_Skill, "Static_TypeV_VERTI")
    },
    l = {
      [3] = UI.getChildControl(Panel_Window_Skill, "Static_TypeL_LT"),
      [4] = UI.getChildControl(Panel_Window_Skill, "Static_TypeL_CT"),
      [5] = UI.getChildControl(Panel_Window_Skill, "Static_TypeL_RT"),
      [6] = UI.getChildControl(Panel_Window_Skill, "Static_TypeL_LM"),
      [7] = UI.getChildControl(Panel_Window_Skill, "Static_TypeL_CM"),
      [8] = UI.getChildControl(Panel_Window_Skill, "Static_TypeL_RM"),
      [9] = UI.getChildControl(Panel_Window_Skill, "Static_TypeL_LB"),
      [10] = UI.getChildControl(Panel_Window_Skill, "Static_TypeL_CB"),
      [11] = UI.getChildControl(Panel_Window_Skill, "Static_TypeL_RB"),
      [12] = UI.getChildControl(Panel_Window_Skill, "Static_TypeL_HORI"),
      [13] = UI.getChildControl(Panel_Window_Skill, "Static_TypeL_VERTI")
    },
    s = {
      [3] = UI.getChildControl(Panel_Window_Skill, "Static_TypeS_LT"),
      [4] = UI.getChildControl(Panel_Window_Skill, "Static_TypeS_CT"),
      [5] = UI.getChildControl(Panel_Window_Skill, "Static_TypeS_RT"),
      [6] = UI.getChildControl(Panel_Window_Skill, "Static_TypeS_LM"),
      [7] = UI.getChildControl(Panel_Window_Skill, "Static_TypeS_CM"),
      [8] = UI.getChildControl(Panel_Window_Skill, "Static_TypeS_RM"),
      [9] = UI.getChildControl(Panel_Window_Skill, "Static_TypeS_LB"),
      [10] = UI.getChildControl(Panel_Window_Skill, "Static_TypeS_CB"),
      [11] = UI.getChildControl(Panel_Window_Skill, "Static_TypeS_RB"),
      [12] = UI.getChildControl(Panel_Window_Skill, "Static_TypeS_HORI"),
      [13] = UI.getChildControl(Panel_Window_Skill, "Static_TypeS_VERTI")
    }
  },
  awakenDesc = UI.getChildControl(Panel_Window_Skill, "StaticText_AwakenWeaponDesc"),
  _btn_MovieToolTipBG = UI.getChildControl(Panel_Window_Skill, "Static_MovieBG"),
  _btn_MovieToolTipDesc = UI.getChildControl(Panel_Window_Skill, "StaticText_MovieToolTip"),
  _btn_MovieToolTip = UI.getChildControl(Panel_Window_Skill, "Button_MovieTooltip"),
  _btn_MovieToolTip2 = UI.getChildControl(Panel_Window_Skill, "Button_MovieTooltip_SpacialCombo"),
  _btn_BlackSpiritLock = UI.getChildControl(Panel_Window_Skill, "Button_BlackSpiritLock"),
  learnedSkillList = Array.new(),
  isPartsSkillReset = false,
  saved_isLearnMode = true,
  scrollPos = 0,
  skillNoCache = 0,
  slotTypeCache = 0,
  tooltipcacheCount = 0,
  skillLevelBg = UI.getChildControl(Panel_Window_Skill, "Static_SkillLevel"),
  _txt_MentalTip = UI.getChildControl(Panel_Window_Skill, "StaticText_Mental_Tip"),
  _txt_ResourceSaveDesc = UI.getChildControl(Panel_Window_Skill, "StaticText_ResourceSaveDesc"),
  _btn_ResetAllSkill = UI.getChildControl(Panel_Window_Skill, "Button_ResetAllSkill"),
  _btn_CommandLock = UI.getChildControl(Panel_Window_Skill, "Button_SkillCommandLock"),
  _btn_Enable_CoolTime_Change = UI.getChildControl(Panel_Window_Skill, "Button_Enable_CoolTime_Change"),
  _bottomBG = UI.getChildControl(Panel_Window_Skill, "Static_BottomBox"),
  _static_CombiSkill_BG = nil,
  _static_CombiSlotBG = nil,
  _slot_CombiSkill = {},
  _static_SlotBG = {},
  _emptyCombiSkillIndex = 0,
  _slot_ControlTable = {},
  _fusionSlotMaxCount = 0,
  _combinationSkillTitle = nil,
  _stc_mouseL = nil,
  _stc_mouseR = nil
}
PaGlobal_Skill._btn_CommandLock:SetShow(false)
local beforCombatSkillNo = -1
local beforAwakenSkillNo = -1
function PaGlobal_Skill:initialize()
  self._stc_mouseL = UI.getChildControl(Panel_Window_Skill, "StaticText_MouseL_Icon")
  self._stc_mouseR = UI.getChildControl(Panel_Window_Skill, "StaticText_MouseR_Icon")
  if _ContentsGroup_skillOldandNew then
    self._static_CombiSkill_BG = UI.getChildControl(Panel_Window_Skill, "Static_SlotBG")
    self._combinationSkillTitle = UI.getChildControl(Panel_Window_Skill, "StaticText_SlotTitle")
    self._combinationSkillTitle:SetText(self._combinationSkillTitle:GetText())
    self._combinationSkillTitle:SetSize(self._combinationSkillTitle:GetTextSizeX(), self._combinationSkillTitle:GetTextSizeY())
  end
  Panel_Window_Skill:setMaskingChild(true)
  Panel_Window_Skill:ActiveMouseEventEffect(true)
  Panel_Window_Skill:setGlassBackground(true)
  self._txt_ResourceSaveDesc:SetShow(false)
  self._txt_MentalTip:SetTextMode(UI_TM.eTextMode_AutoWrap)
  if _ContentsGroup_skillOldandNew == false then
    self._txt_MentalTip:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SKILL_MENTALTIP") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SKILL_RESOURCESAVEDESC"))
    self._bottomBG:SetSize(self._bottomBG:GetSizeX(), self._txt_MentalTip:GetTextSizeY() + 10)
    Panel_Window_Skill:SetSize(Panel_Window_Skill:GetSizeX(), 580 + self._txt_MentalTip:GetTextSizeY() + 10)
  else
    self._txt_MentalTip:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SKILL_MENTALTIP") .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SKILL_MENTALTIP_FUSION") .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SKILL_RESOURCESAVEDESC"))
  end
  self._txt_MentalTip:SetPosY(self._bottomBG:GetPosY() + 10)
  local btnCombatSizeX = PaGlobal_Skill.radioButtons[0]:GetSizeX() + 23
  local btnCombatTextPosX = btnCombatSizeX - btnCombatSizeX / 2 - PaGlobal_Skill.radioButtons[0]:GetTextSizeX() / 2
  PaGlobal_Skill.radioButtons[0]:SetTextSpan(btnCombatTextPosX, 5)
  local btnAwakenSizeX = PaGlobal_Skill.radioButtons[1]:GetSizeX() + 23
  local btnAwakenTextPosX = btnAwakenSizeX - btnAwakenSizeX / 2 - PaGlobal_Skill.radioButtons[1]:GetTextSizeX() / 2
  PaGlobal_Skill.radioButtons[1]:SetTextSpan(btnAwakenTextPosX, 5)
  self:initControl()
  self:initSkillLearnableSlot()
end
function PaGlobal_Skill:initControl()
  for _, control in pairs(self.slotConfig.template) do
    control:SetShow(false)
  end
  local _frame_Combat = UI.getChildControl(Panel_Window_Skill, "Frame_Combat")
  local _frame_scroll_Combat = UI.getChildControl(_frame_Combat, "Frame_1_Scroll")
  PaGlobal_Skill._txt_ResourceSaveDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  local _btn_NewSkill = UI.getChildControl(Panel_Window_Skill, "Button_NewSkill")
  self._btn_MovieToolTip2:SetMonoTone(true)
  if (isGameTypeJapan() or isGameTypeEnglish()) and getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT then
    self._btn_MovieToolTip:SetShow(false)
  else
    self._btn_MovieToolTip:SetShow(true)
  end
  if isGameTypeKR2() then
    self._btn_MovieToolTip:SetShow(false)
  end
  if true == _ContentsGroup_skillOldandNew then
    self._stc_mouseL:SetText(self._stc_mouseL:GetText())
    self._stc_mouseR:SetSpanSize(self._stc_mouseL:GetPosX() + self._stc_mouseL:GetTextSizeX() + self._stc_mouseL:GetTextSpan().x + 10, self._stc_mouseR:GetSpanSize().y)
  end
end
function PaGlobal_Skill:initCombiControl(cellTable, parent, container, isLearn, controlTable)
  if nil == self._static_CombiSkill_BG then
    return
  end
  self._static_CombiSlotBG = UI.getChildControl(self._static_CombiSkill_BG, "Static_Slot")
  local cols = cellTable:capacityX()
  local rows = cellTable:capacityY()
  local startY = self.config.slotStartY
  local index = 0
  for row = 0, rows - 1 do
    local startX = self.config.slotStartX + self._combinationSkillTitle:GetSizeX()
    local isSlotRow = 0 == row % 2
    if isSlotRow then
    else
    end
    startY = startY + 8
    for col = 0, cols - 1 do
      local cell = cellTable:atPointer(col, row)
      local isSlotColumn = 0 == col % 2
      if isSlotColumn then
        startX = startX + self.config.emptyGapX
      else
        startX = startX + self.config.slotGapX
      end
      if cell:isSkillType() then
        local skillNo = ToClient_getFusionLearnSkillNo(index)
        local slotBG = {}
        if nil == self._static_SlotBG[index] then
          slotBG._base = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, parent, "combiSkillSlot_" .. index)
          CopyBaseProperty(self._static_CombiSlotBG, slotBG._base)
          slotBG._base:SetPosX(startX - 4)
          slotBG._base:SetShow(true)
          self._static_SlotBG[index] = slotBG
        end
        if 0 == skillNo or false == isLearn then
          self.slotConfig.createFG = true
          self.slotConfig.createFGDisabled = self.slotConfig.createFG
          self.slotConfig.createFG_Passive = not self.slotConfig.createFG
          if nil ~= container[index] and false == isLearn and 0 == skillNo then
            container[index]:clearSkill()
            container[index].icon:ChangeTextureInfoName("")
            container[index].icon:addInputEvent("Mouse_On", "")
            container[index].icon:addInputEvent("Mouse_PressMove", "")
            PaGlobal_Skill:CombiSkill(false, index)
          elseif nil == container[index] then
            local slot = {}
            SlotSkill.new(slot, index, parent, self.slotConfig)
            slot:setPos(startX, startY)
            if nil ~= slot.icon then
              slot.icon:addInputEvent("Mouse_LUp", "PaGlobal_Skill:HandleMLUp_CombiSkillWindow_LearnButtonClick(" .. index .. ")")
            end
            container[index] = slot
            PaGlobal_Skill:CombiSkill(false, index)
          end
          index = index + 1
        else
          local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
          if nil ~= skillTypeStaticWrapper then
            if skillTypeStaticWrapper:isValidLocalizing() then
              local skillTypeStatic = skillTypeStaticWrapper:get()
              self.slotConfig.createFG = skillTypeStatic:isActiveSkill() and skillTypeStatic._isSettableQuickSlot
              self.slotConfig.createFGDisabled = self.slotConfig.createFG
              self.slotConfig.createFG_Passive = not self.slotConfig.createFG
              local slot = {}
              if nil == controlTable[skillNo] then
                SlotSkill.new(slot, skillNo, parent, self.slotConfig)
                slot:setPos(startX, startY)
                controlTable[skillNo] = slot
              else
                slot = controlTable[skillNo]
              end
              if nil ~= slot.icon then
                slot.icon:addInputEvent("Mouse_On", "HandleMOver_SkillWindow_ToolTipShow(" .. skillNo .. ",false, \"SkillBox\",true)")
                slot.icon:addInputEvent("Mouse_Out", "HandleMOver_SkillWindow_ToolTipHide(" .. skillNo .. ",\"SkillBox\",true)")
                slot.icon:addInputEvent("Mouse_PressMove", "HandleMLUp_SkillWindow_StartDrag(" .. skillNo .. ")")
                slot.icon:addInputEvent("Mouse_RUp", "HandleMLUp_SkillWindow_ClearButtonClick(" .. skillNo .. ")")
                slot.icon:addInputEvent("Mouse_LUp", "PaGlobal_Skill:HandleMLUp_CombiSkillWindow_LearnButtonClick(" .. index .. ")")
                slot.icon:SetEnableDragAndDrop(true)
                Panel_SkillTooltip_SetPosition(skillNo, slot.icon, "SkillBox")
              end
              slot:setSkillTypeStatic(skillTypeStaticWrapper)
              container[index] = slot
              PaGlobal_Skill:CombiSkill(true, index)
              index = index + 1
            end
          else
            _PA_ASSERT("\236\138\164\237\130\172\237\138\184\235\166\172", "skillTypeStaticStatus \235\167\164\235\139\136\236\160\184\236\151\144 \236\151\134\235\138\148 \236\138\164\237\130\172\236\157\180 \236\158\136\236\138\181\235\139\136\235\139\164.")
          end
        end
      end
    end
  end
end
function FromClient_responseLearnFusionSkill(learnCombiSkillNo, slotNo)
  PaGlobal_Skill:combinationSkillLearn(learnCombiSkillNo, slotNo)
end
function FromClient_responseClearFusionSkill()
  PaGlobal_Skill:initTabControl_Combination(false)
  PaGlobal_SkillCombination:update()
end
function PaGlobal_Skill:initTabControl(cellTable, parent, container)
  if nil == cellTable then
    return
  end
  local cols = cellTable:capacityX()
  local rows = cellTable:capacityY()
  local startY = self.config.slotStartY
  for row = 0, rows - 1 do
    local startX = self.config.slotStartX
    local isSlotRow = 0 == row % 2
    if isSlotRow then
      startY = startY + self.config.emptyGapY
    else
      startY = startY + self.config.slotGapY
    end
    for col = 0, cols - 1 do
      local cell = cellTable:atPointer(col, row)
      local skillNo = cell._skillNo
      local isSlotColumn = 0 == col % 2
      if isSlotColumn then
        startX = startX + self.config.emptyGapX
      else
        startX = startX + self.config.slotGapX
      end
      if cell:isSkillType() then
        local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
        if nil ~= skillTypeStaticWrapper then
          if skillTypeStaticWrapper:isValidLocalizing() then
            local skillTypeStatic = skillTypeStaticWrapper:get()
            self.slotConfig.createFG = skillTypeStatic:isActiveSkill() and skillTypeStatic._isSettableQuickSlot
            self.slotConfig.createFGDisabled = self.slotConfig.createFG
            self.slotConfig.createFG_Passive = not self.slotConfig.createFG
            local slot = {}
            SlotSkill.new(slot, skillNo, parent, self.slotConfig)
            slot:setPos(startX, startY)
            if nil ~= slot.learnButton then
              slot.learnButton:SetIgnore(true)
            end
            if nil ~= slot.icon then
              slot.icon:addInputEvent("Mouse_LUp", "HandleMLUp_SkillWindow_LearnButtonClick(" .. skillNo .. ")")
              slot.icon:addInputEvent("Mouse_On", "HandleMOver_SkillWindow_ToolTipShow(" .. skillNo .. ",false, \"SkillBox\")")
              slot.icon:addInputEvent("Mouse_Out", "HandleMOver_SkillWindow_ToolTipHide(" .. skillNo .. ",\"SkillBox\")")
              Panel_SkillTooltip_SetPosition(skillNo, slot.icon, "SkillBox")
            end
            slot:setSkillTypeStatic(skillTypeStaticWrapper)
            container[skillNo] = slot
          end
        else
          _PA_ASSERT("\236\138\164\237\130\172\237\138\184\235\166\172", "skillTypeStaticStatus \235\167\164\235\139\136\236\160\184\236\151\144 \236\151\134\235\138\148 \236\138\164\237\130\172\236\157\180 \236\158\136\236\138\181\235\139\136\235\139\164.")
        end
      elseif cell:isLineType() then
        local template = self:getLineTemplate(isSlotColumn, isSlotRow, cell._cellType)
        if nil ~= template then
          local line = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, parent, "Static_Line_" .. col .. "_" .. row)
          CopyBaseProperty(template, line)
          line:SetPosX(startX)
          line:SetPosY(startY)
          line:SetIgnore(true)
          line:SetShow(true)
        end
      end
    end
  end
end
function PaGlobal_Skill:HandleMLUp_CombiSkillWindow_LearnButtonClick(index)
  Panel_EnableSkill:SetShow(false)
  Panel_SkillCoolTimeSlot:SetShow(false)
  PaGlobal_SkillCombination:open(index)
end
function SkillWindow_ScrollUpEvent()
  PaGlobal_Skill:Skill_ScrollMove("up")
end
function SkillWindow_ScrollDownEvent()
  PaGlobal_Skill:Skill_ScrollMove("down")
end
function PaGlobal_Skill:initTabControl_Combat()
  local targetFrame = self.frames[self.combatTabIndex]
  self.slots[self.combatTabIndex] = {}
  local classType = getSelfPlayer():getClassType()
  if classType >= 0 then
    local cellTable = getCombatSkillTree(classType)
    self:initTabControl(cellTable, targetFrame:GetFrameContent(), self.slots[self.combatTabIndex])
  end
  targetFrame:UpdateContentScroll()
end
function PaGlobal_Skill:initTabControl_AwakeningWeapon()
  local targetFrame = self.frames[self.awakenTabIndex]
  self.slots[self.awakenTabIndex] = {}
  local classType = getSelfPlayer():getClassType()
  if classType >= 0 then
    local cellTable = getAwakeningWeaponSkillTree(classType)
    if nil == cellTable then
      return
    end
    self:initTabControl(cellTable, targetFrame:GetFrameContent(), self.slots[self.awakenTabIndex])
  end
  targetFrame:UpdateContentScroll()
end
function PaGlobal_Skill:initTabControl_Succession()
  local targetFrame = self.frames[self.successionTabIndex]
  self.slots[self.successionTabIndex] = {}
  local classType = getSelfPlayer():getClassType()
  if classType >= 0 then
    local cellTable = getSuccessionSkillTree(classType)
    if nil == cellTable then
      return
    end
    self:initTabControl(cellTable, targetFrame:GetFrameContent(), self.slots[self.successionTabIndex])
  end
  targetFrame:UpdateContentScroll()
end
function PaGlobal_Skill:initTabControl_Combination(isLearn)
  if false == _ContentsGroup_skillOldandNew then
    return
  end
  local isPossible = PaGlobal_Skill:OnOffCombinationTab()
  if false == isPossible then
    return
  end
  local cellTable = getFusionSkillTree()
  self:initCombiControl(cellTable, self._static_CombiSkill_BG, self._slot_CombiSkill, isLearn, self._slot_ControlTable)
end
function PaGlobal_Skill:OnOffCombinationTab()
  if nil == self._combinationSkillTitle then
    return
  end
  local isLearnFusionSkill = ToClient_isLearnFusionSkillLevel() and ToClient_getFusionSkillListCount(0) ~= 0
  local originFullSizeY = 800
  local titleSize = self._combinationSkillTitle:GetSizeY()
  local combinationSkillBG = self._static_CombiSkill_BG:GetSizeY()
  if true == isLearnFusionSkill then
    self._combinationSkillTitle:SetShow(true)
    self._static_CombiSkill_BG:SetShow(true)
    Panel_Window_Skill:SetSize(Panel_Window_Skill:GetSizeX(), originFullSizeY)
  elseif false == isLearnFusionSkill then
    self._combinationSkillTitle:SetShow(false)
    self._static_CombiSkill_BG:SetShow(false)
    Panel_Window_Skill:SetSize(Panel_Window_Skill:GetSizeX(), originFullSizeY - (titleSize + combinationSkillBG) + 30)
  end
  local sizeY = self._txt_MentalTip:GetTextSizeY()
  local bgSizeY = self._bottomBG:GetSizeY()
  if sizeY > bgSizeY then
    local size = sizeY - bgSizeY
    Panel_Window_Skill:SetSize(Panel_Window_Skill:GetSizeX(), Panel_Window_Skill:GetSizeY() + size + 10)
    self._bottomBG:SetSize(self._bottomBG:GetSizeX(), self._bottomBG:GetSizeY() + size + 10)
  end
  local skillCombinationBg = UI.getChildControl(Panel_Window_Skill, "Static_SlotBG")
  local combinationBgSizeY = skillCombinationBg:GetSizeY()
  if skillCombinationBg:GetShow() then
    if true == _ContentsGroup_skillOldandNew then
      self._stc_mouseL:SetSpanSize(self._stc_mouseL:GetSpanSize().x, 665)
      self._stc_mouseR:SetSpanSize(self._stc_mouseR:GetSpanSize().x, 665)
    end
    self._btn_BlackSpiritLock:SetSpanSize(self._btn_BlackSpiritLock:GetSpanSize().x, 658)
    self._btn_MovieToolTip:SetSpanSize(self._btn_MovieToolTip:GetSpanSize().x, 658)
  else
    if true == _ContentsGroup_skillOldandNew then
      self._stc_mouseL:SetSpanSize(self._stc_mouseL:GetSpanSize().x, 665 - combinationBgSizeY)
      self._stc_mouseR:SetSpanSize(self._stc_mouseR:GetSpanSize().x, 665 - combinationBgSizeY)
    end
    self._btn_BlackSpiritLock:SetSpanSize(self._btn_BlackSpiritLock:GetSpanSize().x, 658 - combinationBgSizeY)
    self._btn_MovieToolTip:SetSpanSize(self._btn_MovieToolTip:GetSpanSize().x, 658 - combinationBgSizeY)
  end
  Panel_Window_Skill:ComputePos()
  self._bottomBG:ComputePos()
  self._btn_MovieToolTipBG:ComputePos()
  self._btn_MovieToolTipDesc:ComputePos()
  self._btn_MovieToolTip:ComputePos()
  self._btn_BlackSpiritLock:ComputePos()
  self._btn_BlackSpiritLock:SetShow(_ContentsGroup_BlackSpiritLock and getSelfPlayer():isEnableAdrenalin())
  self._txt_MentalTip:SetPosX(self._bottomBG:GetPosX() + 4)
  self._txt_MentalTip:SetPosY(self._bottomBG:GetPosY() + 4)
  return isLearnFusionSkill
end
function PaGlobal_Skill:combinationSkillLearn(learnSkillNo, slotNo)
  local skillTypeStaticWrapper = getSkillTypeStaticStatus(learnSkillNo)
  if nil == skillTypeStaticWrapper then
    return
  end
  if skillTypeStaticWrapper:isValidLocalizing() then
    local skillTypeStatic = skillTypeStaticWrapper:get()
    self.slotConfig.createFG = skillTypeStatic:isActiveSkill() and skillTypeStatic._isSettableQuickSlot
    self.slotConfig.createFGDisabled = self.slotConfig.createFG
    self.slotConfig.createFG_Passive = not self.slotConfig.createFG
    self._slot_CombiSkill[slotNo]:setSkillTypeStatic(skillTypeStaticWrapper)
    if nil ~= self._slot_CombiSkill[slotNo].learnButton then
      self._slot_CombiSkill[slotNo].learnButton:SetShow(false)
      self._slot_CombiSkill[slotNo].learnButton:SetIgnore(false)
    end
    if nil ~= self._slot_CombiSkill[slotNo].icon then
      self._slot_CombiSkill[slotNo].icon:addInputEvent("Mouse_On", "HandleMOver_SkillWindow_ToolTipShow(" .. learnSkillNo .. ",false, \"SkillBox\",true)")
      self._slot_CombiSkill[slotNo].icon:addInputEvent("Mouse_Out", "HandleMOver_SkillWindow_ToolTipHide(" .. learnSkillNo .. ",\"SkillBox\",true)")
      self._slot_CombiSkill[slotNo].icon:addInputEvent("Mouse_PressMove", "HandleMLUp_SkillWindow_StartDrag(" .. learnSkillNo .. ")")
      self._slot_CombiSkill[slotNo].icon:addInputEvent("Mouse_RUp", "HandleMLUp_SkillWindow_ClearButtonClick(" .. learnSkillNo .. ")")
      self._slot_CombiSkill[slotNo].icon:SetEnableDragAndDrop(true)
      Panel_SkillTooltip_SetPosition(learnSkillNo, self._slot_CombiSkill[slotNo].icon, "SkillBox")
    end
  end
  audioPostEvent_SystemUi(4, 2)
  self._slot_CombiSkill[slotNo].icon:AddEffect("UI_NewSkill01", false, 0, 0)
  self._slot_CombiSkill[slotNo].icon:AddEffect("fUI_Skill_Combination_01A", false, 0, 0)
  EnableSkillWindow_EffectOff()
  PaGlobal_SkillCombination:showLearnSkillEffect()
end
function PaGlobal_Skill:CombiSkill(isLearn, index)
  if false == _ContentsGroup_skillOldandNew then
    return
  end
  if true == isLearn then
    self._slot_CombiSkill[index].learnButton:SetShow(false)
    self._slot_CombiSkill[index].learnButton:SetIgnore(true)
    self._slot_CombiSkill[index].icon:EraseAllEffect()
    self._slot_CombiSkill[index].icon:AddEffect("UI_NewSkill01", false, 0, 0)
    self._slot_CombiSkill[index].icon:AddEffect("fUI_NewSkill01", false, 0, 0)
  elseif 0 == ToClient_getFusionSkillListCount(index) then
    self._slot_CombiSkill[index].learnButton:SetShow(false)
    self._slot_CombiSkill[index].learnButton:SetIgnore(true)
    self._slot_CombiSkill[index].icon:EraseAllEffect()
  else
    self._slot_CombiSkill[index].learnButton:SetShow(true)
    self._slot_CombiSkill[index].learnButton:SetIgnore(true)
  end
end
function PaGlobal_Skill:initSkillLearnableSlot()
  self.staticBottomBox = UI.getChildControl(Panel_Window_Skill, "Static_BottomBox")
  for index = 0, self.learnableSlotShowMaxCount - 1 do
    local slot = {}
    SlotSkill.new(slot, "Learnable_" .. index, self.staticBottomBox, self.slotConfig)
    if nil ~= slot.learnButton then
      slot.learnButton:SetIgnore(true)
    end
    if nil ~= slot.icon then
      slot:clearSkill()
    end
    self.learnableSlots[index] = slot
  end
end
function PaGlobal_Skill:getLineTemplate(isSlotColumn, isSlotRow, lineType)
  local lineDef
  if isSlotColumn and isSlotRow then
    lineDef = self.template_guideLine.l
  elseif not isSlotColumn and isSlotRow then
    lineDef = self.template_guideLine.v
  elseif isSlotColumn and not isSlotRow then
    lineDef = self.template_guideLine.h
  else
    lineDef = self.template_guideLine.s
  end
  return lineDef[lineType]
end
function PaGlobal_Skill:Skill_ScrollMove(moveDirection)
  if "up" == moveDirection then
    self.frames[0]:GetVScroll():SetCtrlPosByInterval(-1)
  elseif "down" == moveDirection then
    self.frames[0]:GetVScroll():SetCtrlPosByInterval(1)
  end
  self.frames[0]:UpdateContentPos()
  HandleMScroll_SkillWindow_ScrollEvent(true)
end
function PaGlobal_Skill:SkillCalcPosYByRow(row)
  if 0 == row % 2 then
    return row / 2 * (self.config.slotGapY + self.config.emptyGapY) + self.config.emptyGapY + self.config.slotStartY
  else
    return (row + 1) / 2 * (self.config.slotGapY + self.config.emptyGapY) + self.config.slotStartY
  end
end
function PaGlobal_Skill:SkillCalcPosYByColumn(col)
  if 0 == col % 2 then
    return col / 2 * (self.config.slotGapX + self.config.emptyGapX) + self.config.emptyGapX + self.config.slotStartX
  else
    return (col + 1) / 2 * (self.config.slotGapX + self.config.emptyGapX) + self.config.slotStartX
  end
end
function PaGlobal_Skill:Skill_WindowPosSet(pos, isAwaken)
  local index = 0
  if isAwaken == true then
    index = 1
  end
  local vScroll = PaGlobal_Skill.frames[index]:GetVScroll()
  local contentUseSize = PaGlobal_Skill.frames[index]:GetFrameContent():GetSizeY() - PaGlobal_Skill.frames[index]:GetSizeY()
  local posPercents = (pos - PaGlobal_Skill.frames[index]:GetSizeY() / 2) / contentUseSize
  vScroll:SetControlPos(math.max(math.min(posPercents, 1), 0))
  PaGlobal_Skill.frames[index]:UpdateContentPos()
end
function PaGlobal_Skill:SkillWindowEffect(row, col, skillNo, isOn, isAwaken)
  local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
  if skillTypeStaticWrapper:isValidLocalizing() then
    local posX, posY = self:SkillCalcPosYByColumn(col), self:SkillCalcPosYByRow(row)
    self:Skill_WindowPosSet(posY, isAwaken)
    self.savedAwaken = isAwaken
    if isAwaken == true then
      if -1 ~= beforAwakenSkillNo then
        self.slots[self.awakenTabIndex][beforAwakenSkillNo].mouseOverButton:EraseAllEffect()
        self.slots[self.awakenTabIndex][beforAwakenSkillNo].mouseOverButton:SetShow(false)
        self.slots[self.awakenTabIndex][beforAwakenSkillNo].mouseOverButton:SetIgnore(true)
      end
      beforAwakenSkillNo = skillNo
    else
      if -1 ~= beforCombatSkillNo then
        self.slots[self.combatTabIndex][beforCombatSkillNo].mouseOverButton:EraseAllEffect()
        self.slots[self.combatTabIndex][beforCombatSkillNo].mouseOverButton:SetShow(false)
      end
      beforCombatSkillNo = skillNo
    end
    if true == isOn then
      if isAwaken == true then
        if self.radioButtons[self.awakenTabIndex]:IsCheck() == false then
          HandleMLUp_SkillWindow_UpdateData(self.awakenTabIndex)
        end
        self.slots[self.awakenTabIndex][skillNo].mouseOverButton:EraseAllEffect()
        self.slots[self.awakenTabIndex][skillNo].mouseOverButton:SetShow(true)
        self.slots[self.awakenTabIndex][skillNo].mouseOverButton:SetIgnore(true)
      else
        if self.radioButtons[self.combatTabIndex]:IsCheck() == false then
          HandleMLUp_SkillWindow_UpdateData(self.combatTabIndex)
        end
        self.slots[self.combatTabIndex][skillNo].mouseOverButton:EraseAllEffect()
        self.slots[self.combatTabIndex][skillNo].mouseOverButton:SetShow(true)
        self.slots[self.combatTabIndex][skillNo].mouseOverButton:SetIgnore(true)
      end
    end
  end
end
function PaGlobal_Skill:SkillWindow_UpdateClearData()
  self.isPartsSkillReset = true
  local isNewSkillBtn = self.radioButtons[self.awakenTabIndex]:IsCheck()
  local isOldSkillBtn = self.radioButtons[self.combatTabIndex]:IsCheck()
  local slots
  if isNewSkillBtn then
    slots = self.slots[self.awakenTabIndex]
  else
    slots = self.slots[self.combatTabIndex]
  end
  if nil == slots then
    return
  end
  for skillNo, slot in pairs(slots) do
    slot:clearSkill()
    slot.icon:SetAlpha(1)
    slot.skillNo = skillNo
    local isFGDisable = true
    if nil ~= slot.iconFGDisabled then
      slot.iconFGDisabled:SetShow(true)
    end
    if nil ~= slot.iconFG_Passive then
      isFGDisable = false
      slot.iconFG_Passive:SetShow(true)
    end
    local skillLevelInfo = getSkillLevelInfo(skillNo)
    if nil == skillLevelInfo then
      return
    end
    if skillLevelInfo._usable then
      local skillStaticWrapper = getSkillStaticStatus(skillNo, 1)
      if nil == skillStaticWrapper then
        return
      end
      if not skillStaticWrapper:isAutoLearnSkillByLevel() and not skillStaticWrapper:isLearnSkillByItem() and skillStaticWrapper:isLastSkill() then
        slot.iconMinus:SetShow(true)
        slot.icon:addInputEvent("Mouse_LUp", "HandleMLUp_SkillWindow_ClearButtonClick(" .. skillNo .. ")")
        if isFGDisable then
          slot.iconFGDisabled:SetShow(false)
        else
          slot.iconFG_Passive:SetShow(false)
        end
      end
    end
  end
  local skillPointInfo = ToClient_getSkillPointInfo(self.combatTabIndex)
  if nil ~= skillPointInfo then
    self.staticRemainPoint:SetText(tostring(skillPointInfo._remainPoint .. " / " .. skillPointInfo._acquirePoint))
  end
end
function PaGlobal_Skill:SkillWindow_PlayerLearnableSkill()
  local slots = self.slots[self.combatTabIndex]
  for skillNo, slot in pairs(slots) do
    local skillLevelInfo = getSkillLevelInfo(skillNo)
    if nil ~= skillLevelInfo then
      if skillLevelInfo._learnable and false == skillLevelInfo._isLearnByQuest then
        return true
      end
    else
      return false
    end
  end
  return false
end
function PaGlobal_Skill:SkillWindow_LearnButtonClick(skillNo)
  if false == self.saved_isLearnMode then
    return
  end
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  if nil == skillLevelInfo then
    return
  end
  if false == skillLevelInfo._learnable then
    return
  end
  local skillSS = getSkillStaticStatus(skillNo, 1)
  if nil == skillSS then
    return
  end
  if skillSS:isAnyPreRequiredSkillBlocked() then
    local blockedPreRequiredSkillKeyList = skillSS:getBlockedPreRequiredSkillNoList()
    local skillNameStr = ""
    for k, v in pairs(blockedPreRequiredSkillKeyList) do
      local skillNo = v:getSkillNo()
      local skillTypeSS = getSkillTypeStaticStatus(skillNo)
      if nil ~= skillTypeSS and nil ~= skillTypeSS:getName() then
        if "" == skillNameStr then
          skillNameStr = skillTypeSS:getName()
        else
          skillNameStr = skillNameStr .. ", " .. skillTypeSS:getName()
        end
      end
    end
    local messageData = {
      content = PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_BLOCKED_NOTICE") .. [[


]] .. skillNameStr,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageData)
    return
  end
  local isSuccess = skillWindow_DoLearn(skillNo)
  if isSuccess then
    audioPostEvent_SystemUi(4, 2)
    if nil == self.skillNoSlot[skillNo] or nil == self.skillNoSlot[skillNo].icon then
      return
    end
    self.skillNoSlot[skillNo].icon:AddEffect("UI_NewSkill01", false, 0, 0)
    self.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill01", false, 0, 0)
    self.learnedSkillList:push_back(skillNo)
  end
  if nil == self.skillNoSlot[skillNo] or nil == self.skillNoSlot[skillNo].icon then
    return
  end
  UI_MAIN_checkSkillLearnable()
  if isSkillLearnTutorialClick_check() then
    HandleMLUp_SkillWindow_Close()
  end
end
function PaGlobal_Skill:UpdateLearnableSlots()
  self:ClearLearnableSlots()
end
function PaGlobal_Skill:ClearLearnableSlots()
  for index, skillSlot in pairs(self.learnableSlots) do
    skillSlot.icon:SetShow(false)
  end
  self.learnableSlotCount = 0
end
function PaGlobal_Skill:SkillWindow_Show()
  if false == _ContentsGroup_RenewUI_Skill then
    HandleMLUp_SkillWindow_OpenForLearn()
  else
    PaGlobalFunc_Skill_Open()
  end
  local vScroll = self.frames[0]:GetVScroll()
  vScroll:SetControlPos(self.scrollPos)
  self.frames[0]:UpdateContentPos()
  HandleMLUp_SkillWindow_UpdateData()
  for index = 1, #self.learnedSkillList do
    local skillNo = self.learnedSkillList[index]
    self.skillNoSlot[skillNo].icon:AddEffect("UI_NewSkill01", false, 0, 0)
    self.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill01", false, 0, 0)
  end
  self.learnedSkillList = Array.new()
  local classType = getSelfPlayer():getClassType()
  if PaGlobal_AwakenSkill.isAwakenWeaponContentsOpen then
    self.radioButtons[self.awakenTabIndex]:SetMonoTone(false)
    self.radioButtons[self.awakenTabIndex]:SetEnable(true)
  else
    self.radioButtons[self.awakenTabIndex]:SetMonoTone(true)
    self.radioButtons[self.awakenTabIndex]:SetEnable(false)
  end
end
function FromClient_OnOffCombinationTab()
  PaGlobal_Skill:initTabControl_Combination(true)
end
registerEvent("FromClient_responseLearnFusionSkill", "FromClient_responseLearnFusionSkill")
registerEvent("FromClient_responseClearFusionSkill", "FromClient_responseClearFusionSkill")
registerEvent("EventSelfPlayerLevelUp", "FromClient_OnOffCombinationTab")
registerEvent("FromClient_ChangeAdrenalinMode", "FromClient_OnOffCombinationTab")

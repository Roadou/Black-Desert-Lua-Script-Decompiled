local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
local defaultFrameBG_Skill = UI.getChildControl(Panel_Window_Guild, "Static_Frame_SkillBG")
local _frame_GuildSkill = UI.getChildControl(Panel_Guild_Skill, "Frame_GuildSkill")
local _staticText_GuildPoint = UI.getChildControl(Panel_Guild_Skill, "StaticText_Point")
local _staticText_GuildPoint_Value = UI.getChildControl(Panel_Guild_Skill, "StaticText_Point_Value")
local _staticText_GuildPoint_Percent = UI.getChildControl(Panel_Guild_Skill, "StaticText_Point_Percent")
local isContentsEnable = ToClient_IsContentsGroupOpen("36")
local GuildSkill = {
  slotConfig = {
    createIcon = true,
    createEffect = true,
    createFG = true,
    createFGDisabled = true,
    createFG_Passive = true,
    createLevel = true,
    createLearnButton = true,
    template = {
      effect = UI.getChildControl(Panel_Guild_Skill, "Static_Icon_Skill_Effect"),
      iconFG = UI.getChildControl(Panel_Guild_Skill, "Static_Icon_FG"),
      iconFGDisabled = UI.getChildControl(Panel_Guild_Skill, "Static_Icon_FG_DISABLE"),
      iconFG_Passive = UI.getChildControl(Panel_Guild_Skill, "Static_Icon_BG"),
      learnButton = UI.getChildControl(Panel_Guild_Skill, "Button_Skill_Point")
    }
  },
  config = {
    slotStartX = 130,
    slotStartY = 6,
    slotGapX = 42,
    slotGapY = 42,
    emptyGapX = 22,
    emptyGapY = 18
  },
  slots = {},
  skillNoSlot = {},
  lastTabIndex = 0,
  lastLearnMode = false,
  controlInitialize = false,
  template_guideLine = {
    h = {
      [3] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeH_LT"),
      [4] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeH_CT"),
      [5] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeH_RT"),
      [6] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeH_LM"),
      [7] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeH_CM"),
      [8] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeH_RM"),
      [9] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeH_LB"),
      [10] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeH_CB"),
      [11] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeH_RB"),
      [12] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeH_HORI"),
      [13] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeH_VERTI")
    },
    v = {
      [3] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeV_LT"),
      [4] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeV_CT"),
      [5] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeV_RT"),
      [6] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeV_LM"),
      [7] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeV_CM"),
      [8] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeV_RM"),
      [9] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeV_LB"),
      [10] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeV_CB"),
      [11] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeV_RB"),
      [12] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeV_HORI"),
      [13] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeV_VERTI")
    },
    l = {
      [3] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeL_LT"),
      [4] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeL_CT"),
      [5] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeL_RT"),
      [6] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeL_LM"),
      [7] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeL_CM"),
      [8] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeL_RM"),
      [9] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeL_LB"),
      [10] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeL_CB"),
      [11] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeL_RB"),
      [12] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeL_HORI"),
      [13] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeL_VERTI")
    },
    s = {
      [3] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeS_LT"),
      [4] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeS_CT"),
      [5] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeS_RT"),
      [6] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeS_LM"),
      [7] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeS_CM"),
      [8] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeS_RM"),
      [9] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeS_LB"),
      [10] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeS_CB"),
      [11] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeS_RB"),
      [12] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeS_HORI"),
      [13] = UI.getChildControl(Panel_Guild_Skill, "Static_TypeS_VERTI")
    }
  },
  template_arrow_to_left = UI.getChildControl(Panel_Guild_Skill, "Static_Arrow_HORI_LEFT"),
  template_arrow_to_right = UI.getChildControl(Panel_Guild_Skill, "Static_Arrow_HORI_RIGHT"),
  template_arrow_to_top = UI.getChildControl(Panel_Guild_Skill, "Static_Arrow_VERTI_TOP"),
  template_arrow_to_bottom = UI.getChildControl(Panel_Guild_Skill, "Static_Arrow_VERTI_BOTTOM"),
  _progressSkillPoint = UI.getChildControl(Panel_Guild_Skill, "Progress2_SkillPointExp")
}
function GuildSkillFrame_Init()
  defaultFrameBG_Skill:MoveChilds(defaultFrameBG_Skill:GetID(), Panel_Guild_Skill)
  UI.deletePanel(Panel_Guild_Skill:GetID())
  Panel_Guild_Skill = nil
  for _, control in pairs(GuildSkill.slotConfig.template) do
    control:SetShow(false)
  end
  _frame_GuildSkill:addInputEvent("Mouse_UpScroll", "GuildSkillFrame_ScrollEvent(true)")
  _frame_GuildSkill:addInputEvent("Mouse_DownScroll", "GuildSkillFrame_ScrollEvent(true)")
  GuildSkill.slots = {}
  local cellTable = getGuildSkillTree()
  GuildSkillFrame_InitSkillTreeControl(cellTable, _frame_GuildSkill:GetFrameContent(), GuildSkill.slots)
  _frame_GuildSkill:UpdateContentScroll()
end
function GuildSkillFrame_GetLineTemplate(isSlotColumn, isSlotRow, lineType)
  local lineDef
  if isSlotColumn and isSlotRow then
    lineDef = GuildSkill.template_guideLine.l
  elseif not isSlotColumn and isSlotRow then
    lineDef = GuildSkill.template_guideLine.v
  elseif isSlotColumn and not isSlotRow then
    lineDef = GuildSkill.template_guideLine.h
  else
    lineDef = GuildSkill.template_guideLine.s
  end
  return lineDef[lineType]
end
function GuildSkillFrame_InitSkillTreeControl(cellTable, parent, container)
  local self = GuildSkill
  local cols = cellTable:capacityX()
  local rows = cellTable:capacityY()
  local startY = GuildSkill.config.slotStartY
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
          slot.icon:addInputEvent("Mouse_LUp", "GuildSkillFrame_LearnButtonClick(" .. skillNo .. ")")
          slot.icon:addInputEvent("Mouse_On", "GuildSkillFrame_OverEvent(" .. skillNo .. ",false, \"GuildSkillBox\")")
          slot.icon:addInputEvent("Mouse_Out", "GuildSkillFrame_OverEventHide(" .. skillNo .. ",\"GuildSkillBox\")")
          Panel_SkillTooltip_SetPosition(skillNo, slot.icon, "GuildSkillBox")
        end
        slot:setSkillTypeStatic(skillTypeStaticWrapper)
        container[skillNo] = slot
      elseif cell:isLineType() then
        local template = GuildSkillFrame_GetLineTemplate(isSlotColumn, isSlotRow, cell._cellType)
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
function GuildSkillFrame_Show()
  defaultFrameBG_Skill:SetShow(true)
  local vScroll = _frame_GuildSkill:GetVScroll()
  vScroll:SetControlPos(0)
  _frame_GuildSkill:UpdateContentPos()
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  GuildSkillFrame_UpdateData(isGuildMaster)
end
function GuildSkillFrame_Hide()
  if true == defaultFrameBG_Skill:GetShow() then
    defaultFrameBG_Skill:SetShow(false)
    GuildSkill.lastLearnMode = false
    Panel_SkillTooltip_Hide()
  end
end
function GuildSkillFrame_Update()
  if false == defaultFrameBG_Skill:GetShow() then
    return
  end
  _frame_GuildSkill:UpdateContentPos()
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  GuildSkillFrame_UpdateData(isGuildMaster)
  _frame_GuildSkill:UpdateContentScroll()
end
function GuildSkillFrame_UpdateData(isLearnMode, doForce)
  local self = GuildSkill
  local skillPointInfo = ToClient_getSkillPointInfo(3)
  local skillPointPercent = string.format("%.0f", skillPointInfo._currentExp / skillPointInfo._nextLevelExp * 100)
  _staticText_GuildPoint_Value:SetText(tostring(skillPointInfo._remainPoint))
  if 100 < tonumber(skillPointPercent) then
    skillPointPercent = 100
  end
  _staticText_GuildPoint_Percent:SetText("( " .. skillPointPercent .. "% )")
  _staticText_GuildPoint_Value:SetPosX(_staticText_GuildPoint:GetPosX() + _staticText_GuildPoint:GetTextSizeX() + 10)
  _staticText_GuildPoint_Percent:SetPosX(_staticText_GuildPoint_Value:GetPosX() + _staticText_GuildPoint_Value:GetTextSizeX() + 10)
  self.lastLearnMode = isLearnMode
  GuildSkill._progressSkillPoint:SetProgressRate(skillPointInfo._currentExp / skillPointInfo._nextLevelExp * 100)
  local slots = self.slots
  for skillNo, slot in pairs(slots) do
    local skillLevelInfo = getSkillLevelInfo(skillNo)
    if nil ~= skillLevelInfo then
      local resultAble = slot:setSkill(skillLevelInfo, skillLevelInfo._learnable)
      local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
      if not skillLevelInfo._learnable and skillLevelInfo._usable and skillTypeStaticWrapper:get():isActiveSkill() then
        slot.icon:addInputEvent("Mouse_RUp", "GuildSkillFrame_Use(" .. skillNo .. ")")
      else
        slot.icon:addInputEvent("Mouse_PressMove", "")
      end
      if skillTypeStaticWrapper:isValidLocalizing() then
        slot.icon:SetShow(true)
        slot.icon:SetIgnore(false)
        slot.icon:SetMonoTone(false)
      else
        slot.icon:SetShow(false)
        slot.icon:SetIgnore(true)
        slot.icon:SetMonoTone(true)
      end
    end
    self.skillNoSlot[skillNo] = slot
  end
end
function GuildSkillFrame_LearnButtonClick(skillNo)
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  if false == isGuildMaster then
    return
  end
  local accumulateTax_s32 = Int64toInt32(myGuildInfo:getAccumulateTax())
  local accumulateCost_s32 = Int64toInt32(myGuildInfo:getAccumulateGuildHouseCost())
  if accumulateTax_s32 > 0 or accumulateCost_s32 > 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_TAXFIRST"))
    return
  end
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  if nil == skillLevelInfo then
    return
  end
  if false == skillLevelInfo._learnable then
    return
  end
  local function doLearnGuildSkill()
    local self = GuildSkill
    local isSuccess = ToClient_RequestLearnGuildSkill(skillNo)
    audioPostEvent_SystemUi(0, 0)
    _AudioPostEvent_SystemUiForXBOX(50, 0)
    if isSuccess then
      self.skillNoSlot[skillNo].icon:AddEffect("UI_NewSkill01", false, 0, 0)
      self.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill01", false, 0, 0)
    end
    return
  end
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_SKILLSTUDY")
  local messageBoxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = doLearnGuildSkill,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData, "middle")
end
function GuildSkillFrame_Use(skillNo)
  ToClient_RequestUseGuildSkill(skillNo)
end
function GuildSkillFrame_StartDrag(skillNo)
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
  if nil ~= skillLevelInfo and nil ~= skillTypeStaticWrapper then
    DragManager:setDragInfo(Panel_Window_Guild, nil, skillLevelInfo._skillKey:get(), "Icon/" .. skillTypeStaticWrapper:getIconPath(), Skill_GroundClick, nil)
  end
end
function GuildSkillFrame_GroundClick()
end
local skillNoCache = 0
local slotTypeCache = 0
local tooltipcacheCount = 0
function GuildSkillFrame_OverEventHide(skillNo, SlotType)
  if skillNoCache == skillNo and slotTypeCache == SlotType then
    tooltipcacheCount = tooltipcacheCount - 1
  else
    tooltipcacheCount = 0
  end
  if tooltipcacheCount <= 0 then
    Panel_SkillTooltip_Hide()
  end
end
function GuildSkillFrame_OverEvent(skillNo, isShowNextLevel, SlotType)
  if skillNoCache == skillNo and slotTypeCache == SlotType then
    tooltipcacheCount = tooltipcacheCount + 1
  else
    skillNoCache = skillNo
    slotTypeCache = SlotType
    tooltipcacheCount = 1
  end
  Panel_SkillTooltip_Show(skillNo, false, SlotType)
  GuildSkill.skillNoSlot[skillNo].icon:EraseAllEffect()
  if "SkillBoxBottom" == SlotType then
    local selectedSlot = UI.getChildControl(_frame_GuildSkill:GetFrameContent(), "StaticSkill_" .. skillNo)
    local vScroll = _frame_GuildSkill:GetVScroll()
    vScroll:SetControlPos(selectedSlot:GetPosY() / (_frame_GuildSkill:GetFrameContent():GetSizeY() - vScroll:GetControlButton():GetSizeY()))
    _frame_GuildSkill:UpdateContentPos()
  end
end
function GuildSkillFrame_ScrollEvent(isShow)
  local vScroll = _frame_GuildSkill:GetVScroll()
  if isShow then
  else
  end
end

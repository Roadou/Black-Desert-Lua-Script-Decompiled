Panel_SkillCombination:SetShow(false)
PaGlobal_isSkillCombinationContentsOpen = ToClient_IsContentsGroupOpen("920")
PaGlobal_SkillCombination = {
  _ui = {
    _btn_Close = UI.getChildControl(Panel_SkillCombination, "Button_Close"),
    _list2 = UI.getChildControl(Panel_SkillCombination, "List2_SkillCombination"),
    _staticTextDesc = UI.getChildControl(Panel_SkillCombination, "StaticText_Bottom_Bg")
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  _skillSlotConfig = {
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
  _skillNoCache = 0,
  _slotTypeCache = 0,
  _tooltipcacheCount = 0,
  _learnSkillIndex = 0,
  _currentSlotIndex = -1,
  _maxCombiSkill = 0,
  _mainSlot = {},
  _subSlot = {},
  _fusionSlot = {},
  _learnButton = {},
  _isFirstOpen = false
}
function PaGlobal_SkillCombination:initalize()
  self._ui._btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_SkillCombination:close()")
  for _, control in pairs(self._skillSlotConfig.template) do
    control:SetShow(false)
  end
  self._ui._staticTextDesc:SetShow(false)
  self._ui._staticTextDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._staticTextDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_COMBINATIONSKILL_TIP"))
  if self._ui._staticTextDesc:GetSizeY() < self._ui._staticTextDesc:GetTextSizeY() + 20 then
    local sizeY = self._ui._staticTextDesc:GetTextSizeY() + 20 - self._ui._staticTextDesc:GetSizeY()
    self._ui._staticTextDesc:SetSize(self._ui._staticTextDesc:GetSizeX(), self._ui._staticTextDesc:GetSizeY() + sizeY)
    Panel_SkillCombination:SetSize(Panel_SkillCombination:GetSizeX(), Panel_SkillCombination:GetSizeY() + sizeY)
  end
  self._ui._list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "SkillCombinationListControlCreate")
  self._ui._list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function PaGlobal_SkillCombination:initalizeList(index)
  self._ui._list2:getElementManager():clearKey()
  self._maxCombiSkill = ToClient_getFusionSkillListCount(index)
  for index = 0, self._maxCombiSkill - 1 do
    if nil ~= self._mainSlot[index] then
      self._mainSlot[index]:destroyChild()
    end
    if nil ~= self._subSlot[index] then
      self._subSlot[index]:destroyChild()
    end
    if nil ~= self._fusionSlot[index] then
      self._fusionSlot[index]:destroyChild()
    end
    self._mainSlot[index] = {}
    self._subSlot[index] = {}
    self._fusionSlot[index] = {}
    self._learnButton[index] = {}
  end
  for index = 0, self._maxCombiSkill - 1 do
    self._ui._list2:getElementManager():pushKey(toInt64(0, index))
  end
end
function PaGlobal_SkillCombination:setPosition()
  Panel_SkillCombination:SetPosX(Panel_Window_Skill:GetPosX() + Panel_Window_Skill:GetSizeX() - 0)
  Panel_SkillCombination:SetPosY(Panel_Window_Skill:GetPosY() + 0)
end
function PaGlobal_SkillCombination:open(index)
  Panel_SkillCombination:SetShow(true)
  PaGlobal_SkillCombination:setPosition()
  if self._currentSlotIndex ~= index then
    PaGlobal_SkillCombination:initalizeList(index)
    self._isFirstOpen = true
    self._currentSlotIndex = index
  end
end
function PaGlobal_SkillCombination:close()
  if Panel_Window_Skill:GetShow() then
    Panel_SkillCombination:SetShow(false)
    Panel_EnableSkill:SetShow(true)
  else
    Panel_SkillCombination:SetShow(false)
  end
  self._isFirstOpen = false
  self._currentSlotIndex = -1
end
function PaGlobal_SkillCombination:update()
  if false == self._isFirstOpen or false == PaGlobal_isSkillCombinationContentsOpen then
    return
  end
  self._maxCombiSkill = ToClient_getFusionSkillListCount(self._currentSlotIndex)
  for index = 0, self._maxCombiSkill - 1 do
    local mainSkillNo = ToClient_getFusionMainSkillNo(self._currentSlotIndex, index)
    local subSkillNo = ToClient_getFusionSubSkillNo(self._currentSlotIndex, index)
    local fusionSkillNo = ToClient_getFusionSkillNo(self._currentSlotIndex, index)
    PaGlobal_SkillCombination:UpdateSkillMonoTone(mainSkillNo, subSkillNo, fusionSkillNo, index)
  end
end
function PaGlobal_SkillCombination:UpdateCombiSkill(skillNo, slot, checkMonoTone)
  if true == checkMonoTone then
    if false == ToClient_isLearnedSkill(skillNo) then
      slot.icon:SetMonoTone(true)
    else
      slot.icon:SetMonoTone(false)
    end
  end
end
function PaGlobal_SkillCombination:combinationLearnSkill(index, mainSkillNo, subSkillNo, fusionSkillNo)
  self._learnSkillIndex = index
  ToClient_requestLearnFusionSkill(fusionSkillNo, mainSkillNo, subSkillNo)
end
function PaGlobal_SkillCombination:tooltipHide(skillNo, SlotType)
  if self._skillNoCache == skillNo and self._slotTypeCache == SlotType then
    self._tooltipcacheCount = self._tooltipcacheCount - 1
  else
    self._tooltipcacheCount = 0
  end
  if self._tooltipcacheCount <= 0 then
    Panel_SkillTooltip_Hide()
  end
end
function PaGlobal_SkillCombination:tooltipShow(skillNo, isShowNextLevel, SlotType)
  if self._skillNoCache == skillNo and self._slotTypeCache == SlotType then
    self._tooltipcacheCount = self._tooltipcacheCount + 1
  else
    self._skillNoCache = skillNo
    self._slotTypeCache = SlotType
    self._tooltipcacheCount = 1
  end
  Panel_SkillTooltip_Show(skillNo, false, SlotType)
end
function PaGlobal_SkillCombination:SetCombiSkill(skillNo, selfSlot, parentSlot, index)
  local skillWrapper = getSkillTypeStaticStatus(skillNo)
  if nil ~= skillWrapper and skillWrapper:isValidLocalizing() then
    local skillTypeStatic = skillWrapper:get()
    self._skillSlotConfig.createFG = skillTypeStatic:isActiveSkill() and skillTypeStatic._isSettableQuickSlot
    self._skillSlotConfig.createFGDisabled = self._skillSlotConfig.createFG
    self._skillSlotConfig.createFG_Passive = not self._skillSlotConfig.createFG
    SlotSkill.new(selfSlot, skillNo, parentSlot, self._skillSlotConfig)
    if nil ~= selfSlot.icon then
      selfSlot.icon:addInputEvent("Mouse_On", "PaGlobal_SkillCombination:tooltipShow(" .. skillNo .. ",false, \"CombiSkill\")")
      selfSlot.icon:addInputEvent("Mouse_Out", "PaGlobal_SkillCombination:tooltipHide(" .. skillNo .. ",\"CombiSkill\")")
      Panel_SkillTooltip_SetPosition(skillNo, selfSlot.icon, "CombiSkill")
    end
    selfSlot:setSkillTypeStatic(skillWrapper)
  end
end
function PaGlobal_SkillCombination:UpdateSkillMonoTone(mainSkillNo, subSkillNo, fusionSkillNo, index)
  if nil == index then
    return
  end
  local self = PaGlobal_SkillCombination
  local fusionMonoTone = false
  if false == ToClient_isLearnedSkill(mainSkillNo) then
    self._mainSlot[index].icon:SetMonoTone(true)
    fusionMonoTone = true
  else
    self._mainSlot[index].icon:SetMonoTone(false)
  end
  if false == ToClient_isLearnedSkill(subSkillNo) then
    self._subSlot[index].icon:SetMonoTone(true)
    fusionMonoTone = true
  else
    self._subSlot[index].icon:SetMonoTone(false)
  end
  if true == fusionMonoTone or true == ToClient_isLearnedSkill(fusionSkillNo) or true == ToClient_isUsedSkillForFusionSkill(mainSkillNo) then
    self._learnButton[index]:SetIgnore(true)
    self._learnButton[index]:SetMonoTone(true)
  else
    self._learnButton[index]:SetIgnore(false)
    self._learnButton[index]:SetMonoTone(false)
  end
end
function PaGlobal_SkillCombination:showLearnSkillEffect()
  if nil == self._fusionSlot[self._learnSkillIndex] then
    return
  end
  self._fusionSlot[self._learnSkillIndex].icon:AddEffect("UI_NewSkill01", false, 0, 0)
  self._fusionSlot[self._learnSkillIndex].icon:AddEffect("fUI_Skill_Combination_01A", false, 0, 0)
  EnableSkillWindow_EffectOff()
end
function SkillCombinationListControlCreate(content, key)
  local self = PaGlobal_SkillCombination
  local index = Int64toInt32(key)
  local mainSkillSlot = UI.getChildControl(content, "Static_MainSkillSlot")
  local subSkillSlot = UI.getChildControl(content, "Static_SubSkillSlot")
  local combiSkillSlot = UI.getChildControl(content, "Static_CombiSkillSlot")
  local btnLearnSkill = UI.getChildControl(content, "Button_Learn")
  local mainSkillNo = ToClient_getFusionMainSkillNo(self._currentSlotIndex, index)
  local subSkillNo = ToClient_getFusionSubSkillNo(self._currentSlotIndex, index)
  local fusionSkillNo = ToClient_getFusionSkillNo(self._currentSlotIndex, index)
  PaGlobal_SkillCombination:SetCombiSkill(mainSkillNo, self._mainSlot[index], mainSkillSlot, index)
  PaGlobal_SkillCombination:SetCombiSkill(subSkillNo, self._subSlot[index], subSkillSlot, index)
  PaGlobal_SkillCombination:SetCombiSkill(fusionSkillNo, self._fusionSlot[index], combiSkillSlot, index)
  self._learnButton[index] = btnLearnSkill
  btnLearnSkill:addInputEvent("Mouse_LUp", "PaGlobal_SkillCombination:combinationLearnSkill(" .. index .. "," .. mainSkillNo .. "," .. subSkillNo .. "," .. fusionSkillNo .. ")")
  PaGlobal_SkillCombination:UpdateSkillMonoTone(mainSkillNo, subSkillNo, fusionSkillNo, index)
end
PaGlobal_SkillCombination:initalize()

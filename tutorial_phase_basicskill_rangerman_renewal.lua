PaGlobal_TutorialPhase_BasicSkill_RangerMan = {
  _phaseNo = 6,
  _currentType = 0,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 1,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = true,
  _regionKeyRawList = {9},
  _startLimitLevel = 7,
  _totalScoldingCount = 5,
  _usedSkillCount = 0,
  _totalSkillCount = 2,
  _usedComboCount = 0,
  _totalComboCount = 2,
  _currentClearCount = 0,
  _totalClearCount = 2,
  _comboSkillName = {},
  _comboSkillKey = {},
  _comboSkillNo = {},
  _comboDesc = {},
  _skillNoList = {
    [1] = {3348},
    [2] = {
      3349,
      3350,
      3351,
      3352,
      3353
    },
    [3] = {
      3343,
      3344,
      3345,
      3346
    },
    [4] = {
      3454,
      3455,
      3456,
      3457
    },
    [5] = {3458},
    [6] = {
      3924,
      3925,
      3926
    },
    [7] = {
      3405,
      3406,
      3407,
      3408,
      3409
    },
    [8] = {
      3934,
      3935,
      3936,
      3937
    },
    [9] = {3441},
    [10] = {3928}
  }
}
local eventID = PaGlobal_TutorialEventList
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:checkPossibleForPhaseStart(stepNo)
  if false == self._isPhaseOpen then
    _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "\237\138\156\237\134\160\235\166\172\236\150\188 Phase\234\176\128 \235\139\171\237\152\128\236\158\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "\237\138\156\237\134\160\235\166\172\236\150\188 \236\139\156\236\158\145 \234\176\128\235\138\165 \236\151\172\235\182\128 \234\178\128\236\130\172\236\164\145\236\151\144 selfPlayer\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164! _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local currentRegionKeyRaw = selfPlayer:getRegionKeyRaw()
  local isPossiblePhaseRegion = false
  for index, value in pairs(self._regionKeyRawList) do
    if value == currentRegionKeyRaw then
      isPossiblePhaseRegion = true
      break
    end
  end
  if false == isPossiblePhaseRegion then
    _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "\237\138\156\237\134\160\235\166\172\236\150\188\236\157\180 \234\176\128\235\138\165\237\149\156 \236\167\128\236\151\173\236\157\180 \236\149\132\235\139\136\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\164\237\150\137\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  if self._startLimitLevel < getSelfPlayer():get():getLevel() then
    _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "\236\186\144\235\166\173\237\132\176\236\157\152 \235\160\136\235\178\168\236\157\180 " .. tostring(self._startLimitLevel) .. "\235\165\188 \236\180\136\234\179\188\237\150\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\167\132\237\150\137\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:startPhase(stepNo, typeNo)
  if false == self:checkPossibleForPhaseStart(stepNo) then
    return
  end
  if true == PaGlobal_SummonBossTutorial_Manager:isDoingSummonBossTutorial() then
    PaGlobal_SummonBossTutorial_Manager:endTutorial()
    _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "\237\138\156\237\134\160\235\166\172\236\150\188 phase(" .. tostring(self._phaseNo) .. ")\234\176\128 \235\179\180\236\138\164 \236\134\140\237\153\152 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\162\133\235\163\140\236\139\156\237\130\180! _phaseNo : " .. tostring(self._phaseNo))
  end
  local isSkippable = self:checkSkippablePhase()
  if true == isSkippable and false == PaGlobal_TutorialManager:isDoingTutorial() then
    PaGlobal_TutorialManager:questionPhaseSkip(self, stepNo, typeNo)
  else
    self:startPhaseXXX(stepNo, typeNo)
  end
end
local navigationGuideParam
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:startPhaseXXX(stepNo, typeNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\237\138\156\237\134\160\235\166\172\236\150\188", "PaGlobal_TutorialPhase_BasicSkill_RangerMan:startStep() typeNo : " .. tostring(typeNo))
  self._currentType = typeNo
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  self._updateTime = 0
  if 1 == self._currentType then
    classType = getSelfPlayer():getClassType()
    PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
    navigationGuideParam = NavigationGuideParam()
    navigationGuideParam._isAutoErase = false
    ToClient_DeleteNaviGuideByGroup()
    worldmapNavigatorStart(float3(-66624.21, -4026.99, 45348.39), navigationGuideParam, false, false, true)
    PaGlobal_TutorialUiManager:hideAllTutorialUi()
  end
  PaGlobal_TutorialUiManager:getUiHeadlineMessage():resetClearStepEffect()
  PaGlobal_TutorialUiManager:repositionScreen()
  Panel_Tutorial_Renew:SetShow(true, true)
  PaGlobal_TutorialManager:ClearEventFunctor()
  PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_AfterAndPopFlush, function()
    self:handleAfterAndPopFlush()
  end)
  PaGlobal_TutorialManager:AddEventFunctor(eventID.TutorialEvent_PlayerUsedSkill, function(skillWrapper)
    self:handleEventSelfPlayerUsedSkill(skillWrapper)
  end)
end
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:endPhase()
  self._currentStep = 0
  self._nextStep = 1
  PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
  PaGlobal_TutorialManager:startNextPhase()
  PaGlobal_TutorialUiManager:getUiBlackSpirit():showSpiritTutorialBubble(false)
end
local result = false
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
  if 1 == self._currentType then
    if 1 == self._currentStep then
      result = self:updateTryBasicSkill(deltaTime)
    elseif 2 == self._currentStep then
      result = self:updateTrySkillCombo(deltaTime)
    elseif 3 == self._currentStep then
      result = self:updateTrySkillCombo(deltaTime)
    elseif 4 == self._currentStep then
      result = false
    end
  end
  if true == result then
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:handleChangeStep(currentStep)
  if 1 == self._currentType then
    if 1 == self._currentStep then
      self:changeStepTryBasicSkill()
    elseif 2 == self._currentStep then
      self:changeStepTrySkillCombo(1)
    elseif 3 == self._currentStep then
      self:changeStepTrySkillCombo(2)
    elseif 4 == self._currentStep then
      self:changeStepSuggestCallBlackSpirit()
    elseif 5 == self._currentStep then
      self:endPhase()
    end
  end
end
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:showUiScoldingTooManyKeyInput()
  PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PRESSEDKEY_DARKSPIRIT"))
end
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:changeStepTryBasicSkill()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Title(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_RANGERMAN_STEP_DESC_1_1"))
    PaGlobal_TutorialUiManager:getUiHeadlineMessage():setSkillText(self._currentProgress, PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_RANGERMAN_STEP_COMMAND_1_1"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_PURPOSE_BATTLE_STEP1_COMMAND"))
  elseif 2 == self._currentProgress then
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Title(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_RANGERMAN_STEP_DESC_1_2"))
    PaGlobal_TutorialUiManager:getUiHeadlineMessage():setSkillText(self._currentProgress, PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_RANGERMAN_STEP_COMMAND_1_2"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_PURPOSE_BATTLE_STEP2_COMMAND"))
  elseif 3 == self._currentProgress then
    if self._totalSkillCount == self._usedSkillCount then
      PaGlobal_TutorialUiManager:getUiHeadlineMessage():addClearStepEffect(3)
    elseif self._totalSkillCount < self._usedSkillCount then
      return
    end
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Title(PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_BATTLE_STEP7") .. " ( " .. self._usedSkillCount .. " / " .. self._totalSkillCount .. " )")
    PaGlobal_TutorialUiManager:getUiHeadlineMessage():setSkillText(self._currentProgress, PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMBO_0_1"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMMAND_0_1"))
  elseif 4 == self._currentProgress then
    if self._totalSkillCount == self._usedSkillCount then
      PaGlobal_TutorialUiManager:getUiHeadlineMessage():addClearStepEffect(4)
    elseif self._totalSkillCount < self._usedSkillCount then
      return
    end
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Title(PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_BATTLE_STEP7") .. " ( " .. self._usedSkillCount .. " / " .. self._totalSkillCount .. " )")
    PaGlobal_TutorialUiManager:getUiHeadlineMessage():setSkillText(self._currentProgress, PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMBO_0_2"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMMAND_0_2"))
  end
end
local isPressedTab = false
local isPressedMouseL = false
local mouseLUpCount = 0
local isBlackSpiritScolding = false
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:updateTryBasicSkill(deltaTime)
  if 1 == self._currentProgress then
    if true == keyCustom_IsDownOnce_Action(CppEnums.ActionInputType.ActionInputType_WeaponInOut) then
      isPressedTab = true
    end
    if true == keyCustom_IsDownOnce_Action(CppEnums.ActionInputType.ActionInputType_Attack1) then
      isPressedMouseL = true
    end
    if true == isPressedTab or true == isPressedMouseL then
      isPressedTab = false
      isPressedMouseL = false
      audioPostEvent_SystemUi(4, 12)
      PaGlobal_TutorialUiManager:getUiHeadlineMessage():addClearStepEffect(1)
      audioPostEvent_SystemUi(4, 12)
      self._currentProgress = self._currentProgress + 1
      self:handleChangeStep(self._currentStep)
    end
  elseif 2 == self._currentProgress then
    if true == keyCustom_IsUp_Action(CppEnums.ActionInputType.ActionInputType_Attack1) then
      mouseLUpCount = mouseLUpCount + 1
      if self._totalScoldingCount < mouseLUpCount and false == isBlackSpiritScolding then
        isBlackSpiritScolding = true
        self:showUiScoldingTooManyKeyInput()
      end
    end
    if true == keyCustom_IsPressed_Action(CppEnums.ActionInputType.ActionInputType_Attack1) then
      self._updateTime = self._updateTime + deltaTime
    end
    if self._updateTime > 1.25 then
      audioPostEvent_SystemUi(4, 12)
      PaGlobal_TutorialUiManager:getUiHeadlineMessage():addClearStepEffect(2)
      if true == isBlackSpiritScolding then
        isBlackSpiritScolding = false
        PaGlobal_TutorialUiManager:getUiBlackSpirit():showSpiritTutorialBubble(false)
      end
      audioPostEvent_SystemUi(4, 12)
      self._updateTime = 0
      self._currentProgress = self._currentProgress + 1
      self:handleChangeStep(self._currentStep)
      return false
    end
  elseif 3 == self._currentProgress then
    if self._totalSkillCount <= self._usedSkillCount then
      self._updateTime = self._updateTime + deltaTime
      if self._updateTime > 1.25 then
        prevInputCombination = false
        isInputCombinationChanged = false
        self._usedSkillCount = 0
        self._updateTime = 0
        self._currentProgress = self._currentProgress + 1
        self:handleChangeStep(self._currentStep)
      end
    end
  elseif 4 == self._currentProgress and self._totalSkillCount <= self._usedSkillCount then
    self._updateTime = self._updateTime + deltaTime
    if true == isBlackSpiritScolding then
      isBlackSpiritScolding = false
      PaGlobal_TutorialUiManager:getUiBlackSpirit():showSpiritTutorialBubble(false)
    end
    if self._updateTime > 1.25 then
      prevInputCombination = false
      isInputCombinationChanged = false
      self._usedSkillCount = 0
      self._updateTime = 0
      self._currentProgress = 1
      return true
    end
  end
  return false
end
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:eventCallUsedSkill_TryBasicSkill(skillWrapper)
  local skillNo = skillWrapper:getSkillNo()
  local listNo = 0
  if 4 == self._currentProgress and 3942 == skillNo then
    isBlackSpiritScolding = true
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_RANGERMAN_STEP_SCOLDING_BOWCHANGE"))
  end
  if 3 == self._currentProgress then
    listNo = 1
  elseif 4 == self._currentProgress then
    listNo = 2
  else
    return
  end
  for key, value in pairs(self._skillNoList[listNo]) do
    if skillNo == value then
      audioPostEvent_SystemUi(4, 12)
      self._usedSkillCount = self._usedSkillCount + 1
      self:handleChangeStep(self._currentStep)
    end
  end
end
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:changeStepTrySkillCombo(comboStep)
  self._comboDesc[1] = {
    [1] = "LUA_TUTORIAL_RANGERMAN_STEP_DESC_2_1",
    [2] = "LUA_TUTORIAL_RANGERMAN_STEP_DESC_2_2",
    [3] = "LUA_TUTORIAL_RANGERMAN_STEP_DESC_2_3",
    [4] = "LUA_TUTORIAL_RANGERMAN_STEP_DESC_3_6"
  }
  self._comboSkillName[1] = {
    [1] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMBO_0_1",
    [2] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMBO_0_9",
    [3] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMBO_1_0",
    [4] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMBO_0_4"
  }
  self._comboSkillKey[1] = {
    [1] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMMAND_0_1",
    [2] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMMAND_0_5",
    [3] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMMAND_0_3",
    [4] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMMAND_0_4"
  }
  self._comboDesc[2] = {
    [1] = "LUA_TUTORIAL_RANGERMAN_STEP_DESC_3_1",
    [2] = "LUA_TUTORIAL_RANGERMAN_STEP_DESC_3_2",
    [3] = "LUA_TUTORIAL_RANGERMAN_STEP_DESC_2_3",
    [4] = "LUA_TUTORIAL_RANGERMAN_STEP_DESC_3_6"
  }
  self._comboSkillName[2] = {
    [1] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMBO_0_2",
    [2] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMBO_0_8",
    [3] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMBO_1_0",
    [4] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMBO_0_4"
  }
  self._comboSkillKey[2] = {
    [1] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMMAND_0_2",
    [2] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMMAND_0_8",
    [3] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMMAND_0_3",
    [4] = "LUA_TUTORIAL_BASECOMBO_RANGERMAN_COMMAND_0_4"
  }
  local function setTextForSkillTutorial(comboIndex, progressIndex)
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Title(PAGetString(Defines.StringSheet_GAME, self._comboDesc[comboIndex][progressIndex]))
    PaGlobal_TutorialUiManager:getUiHeadlineMessage():setSkillText(self._currentProgress, PAGetString(Defines.StringSheet_GAME, self._comboSkillName[comboIndex][progressIndex]), PAGetString(Defines.StringSheet_GAME, self._comboSkillKey[comboIndex][progressIndex]))
  end
  if 1 == comboStep or 2 == comboStep then
    if 1 == self._currentProgress then
      PaGlobal_TutorialUiManager:getUiHeadlineMessage():resetClearStepEffect()
      setTextForSkillTutorial(comboStep, self._currentProgress)
    elseif 2 == self._currentProgress or 3 == self._currentProgress or 4 == self._currentProgress then
      setTextForSkillTutorial(comboStep, self._currentProgress)
    end
  end
end
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:updateTrySkillCombo(deltaTime)
  local function trySkillComboInit()
    prevInputCombination = false
    isInputCombinationChanged = false
    self._usedSkillCount = 0
    self._updateTime = 0
  end
  if 1 == self._currentProgress then
    if 1 <= self._usedSkillCount then
      self._updateTime = self._updateTime + deltaTime
      PaGlobal_TutorialUiManager:getUiHeadlineMessage():addClearStepEffect(1)
      trySkillComboInit()
      self._currentProgress = self._currentProgress + 1
      self:handleChangeStep(self._currentStep)
    end
  elseif 2 == self._currentProgress then
    if true == isBlackSpiritScolding then
      isBlackSpiritScolding = false
      PaGlobal_TutorialUiManager:getUiBlackSpirit():showSpiritTutorialBubble(false)
    end
    if 1 <= self._usedSkillCount then
      self._updateTime = self._updateTime + deltaTime
      PaGlobal_TutorialUiManager:getUiHeadlineMessage():addClearStepEffect(2)
      trySkillComboInit()
      self._currentProgress = self._currentProgress + 1
      self:handleChangeStep(self._currentStep)
    end
  elseif 3 == self._currentProgress then
    if 1 <= self._usedSkillCount then
      self._updateTime = self._updateTime + deltaTime
      PaGlobal_TutorialUiManager:getUiHeadlineMessage():addClearStepEffect(3)
      trySkillComboInit()
      self._currentProgress = self._currentProgress + 1
      self:handleChangeStep(self._currentStep)
    end
  elseif 4 == self._currentProgress and 1 <= self._usedSkillCount then
    self._updateTime = self._updateTime + deltaTime
    PaGlobal_TutorialUiManager:getUiHeadlineMessage():addClearStepEffect(4)
    if self._updateTime > 1.25 then
      trySkillComboInit()
      self._currentProgress = 1
      self._usedComboCount = self._usedComboCount + 1
      if self._totalComboCount <= self._usedComboCount then
        self._updateTime = 0
        self._usedComboCount = 0
        return true
      else
        self:handleChangeStep(self._currentStep)
        PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_RANGERMAN_STEP_SCOLDING_ONEMORE"))
      end
    end
  end
end
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:eventCallUsedSkill_TrySkillCombo(skillWrapper, comboStep)
  local listNo = 0
  local skillNo = skillWrapper:getSkillNo()
  if 2 == comboStep and 1 == self._currentProgress and 3942 == skillNo then
    isBlackSpiritScolding = true
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_RANGERMAN_STEP_SCOLDING_BOWCHANGE"))
  end
  self._comboSkillNo[1] = {
    1,
    5,
    10,
    4
  }
  self._comboSkillNo[2] = {
    2,
    8,
    10,
    4
  }
  if (1 == comboStep or 2 == comboStep) and (1 == self._currentProgress or 2 == self._currentProgress or 3 == self._currentProgress or 4 == self._currentProgress) then
    listNo = self._comboSkillNo[comboStep][self._currentProgress]
  end
  for key, value in pairs(self._skillNoList[listNo]) do
    if skillNo == value then
      audioPostEvent_SystemUi(4, 12)
      self._usedSkillCount = self._usedSkillCount + 1
      self:handleChangeStep(self._currentStep)
    end
  end
end
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:changeStepSuggestCallBlackSpirit()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiManager:getUiBlackSpirit():showSuggestCallSpiritUi()
    PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  end
end
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:eventCallAfterBlackSpiritDialogClose()
  if 1 == self._currentProgress then
    Panel_CheckedQuest:SetShow(false)
    Panel_CheckedQuest:SetShow(true, true)
    self._currentProgress = 1
    self._nextStep = self._nextStep + 1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:handleAfterAndPopFlush()
  if 1 == self._currentType and 4 == self._currentStep then
    self:eventCallAfterBlackSpiritDialogClose()
  end
end
function PaGlobal_TutorialPhase_BasicSkill_RangerMan:handleEventSelfPlayerUsedSkill(skillWrapper)
  if nil ~= skillWrapper and 1 == self._currentType then
    if 1 == self._currentStep then
      self:eventCallUsedSkill_TryBasicSkill(skillWrapper)
    elseif 2 == self._currentStep then
      self:eventCallUsedSkill_TrySkillCombo(skillWrapper, 1)
    elseif 3 == self._currentStep then
      self:eventCallUsedSkill_TrySkillCombo(skillWrapper, 2)
    end
  end
end

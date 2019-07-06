PaGlobal_TutorialPhase_RenewalBasicMove_1 = {
  _phaseNo = 8,
  _currentStep = 0,
  _nextStep = 1,
  _currentProgress = 1,
  _updateTime = 0,
  _classStringData = {},
  _isPhaseOpen = true,
  _isSkippable = true,
  _regionKeyRawList = {10},
  _startLimitLevel = 5,
  _state = 0
}
local classType = 0
local isAcceptedQuest = false
local isClearQuest = false
function PaGlobal_TutorialPhase_RenewalBasicMove_1:setState(isStart)
  self._state = isStart
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:getState(isStart)
  return self._state
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:checkPossibleForPhaseStart(stepNo)
  if false == self._isPhaseOpen then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 Phase\234\176\128 \235\139\171\237\152\128\236\158\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 \236\139\156\236\158\145 \234\176\128\235\138\165 \236\151\172\235\182\128 \234\178\128\236\130\172\236\164\145\236\151\144 selfPlayer\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164! _phaseNo : " .. tostring(self._phaseNo))
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
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188\236\157\180 \234\176\128\235\138\165\237\149\156 \236\167\128\236\151\173\236\157\180 \236\149\132\235\139\136\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\164\237\150\137\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  if self._startLimitLevel < getSelfPlayer():get():getLevel() then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\236\186\144\235\166\173\237\132\176\236\157\152 \235\160\136\235\178\168\236\157\180 " .. tostring(self._startLimitLevel) .. "\235\165\188 \236\180\136\234\179\188\237\150\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\167\132\237\150\137\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:startPhase(stepNo)
  if false == self:checkPossibleForPhaseStart(stepNo) then
    _PA_LOG("\236\157\180\235\139\164\237\152\156", "\236\158\152\235\170\187\235\144\156 \237\138\156\237\134\160\235\166\172\236\150\188 stepNo \236\158\133\235\139\136\235\139\164 : " .. stepNo)
    return
  end
  if true == PaGlobal_SummonBossTutorial_Manager:isDoingSummonBossTutorial() then
    PaGlobal_SummonBossTutorial_Manager:endTutorial()
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 phase(" .. tostring(self._phaseNo) .. ")\234\176\128 \235\179\180\236\138\164 \236\134\140\237\153\152 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\162\133\235\163\140\236\139\156\237\130\180! _phaseNo : " .. tostring(self._phaseNo))
  end
  local isSkippable = self:checkSkippablePhase()
  if true == isSkippable and false == PaGlobal_TutorialManager:isDoingTutorial() then
    PaGlobal_TutorialManager:questionPhaseSkip(self, stepNo)
  else
    self:startPhaseXXX(stepNo)
  end
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_RenewalBasicMove_1:startPhase() stepNo : " .. tostring(stepNo))
  self._currentStep = stepNo
  self._currentProgress = 1
  self._updateTime = 0
  Panel_Tutorial_Renew:SetShow(true, true)
  ToClient_DeleteNaviGuideByGroup()
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialUiManager:repositionScreen()
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  self:setState(PaGlobal_TutorialState.eState_Start)
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:endPhase()
  self._currentStep = 0
  self._nextStep = 1
  self._updateTime = 0
  Panel_Tutorial_Renew:SetShow(false)
  PaGlobal_TutorialManager:endTutorial()
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:updatePerFrame(deltaTime)
  self:handleStep(deltaTime)
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:handleStep(deltaTime)
  if 1 == self._currentStep then
    self:Step01_BlackSpiritTalk(deltaTime)
  elseif 2 == self._currentStep then
    self:Step02_BasicMove(deltaTime)
  else
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:Step01_BlackSpiritTalk(deltaTime)
  local currentState = self:getState()
  if PaGlobal_TutorialState.eState_Start == currentState then
    self:Step01_Prepare()
  elseif PaGlobal_TutorialState.eState_Do == currentState then
    self:Step01_DoStep(deltaTime)
  elseif PaGlobal_TutorialState.eState_Done == currentState then
    self:Step01_Done()
  end
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:Step01_Prepare()
  getSelfPlayer():setActionChart("TUTORIAL_WAIT_STEP1")
  self:setState(PaGlobal_TutorialState.eState_Do)
end
local isFadeOut = false
function PaGlobal_TutorialPhase_RenewalBasicMove_1:Step01_DoStep(deltaTime)
  self._updateTime = self._updateTime + deltaTime
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(PAGetString(Defines.StringSheet_GAME, self._classStringData[classType][1]))
    self._updateTime = 0
    self._currentProgress = self._currentProgress + 1
  elseif 2 == self._currentProgress then
    if true == IsSelfPlayerWaitAction() then
      if false == isFadeOut then
        PaGlobal_TutorialUiBlackSpirit:showSpiritTutorialBubble(false)
        PaGlobal_TutorialPhase_RenewalBasicMove_1:fadeOutBg()
        isFadeOut = true
        self._updateTime = 0
      end
      if self._updateTime > 0.3 then
        Process_UIMode_CommonWindow_BlackSpirit()
        PaGlobal_TutorialPhase_RenewalBasicMove_1:Step05_SummonBlackSpirit()
        self._updateTime = 0
        self._currentProgress = self._currentProgress + 1
      end
    end
  elseif 3 == self._currentProgress and 1 * timeRatio < self._updateTime then
    self._updateTime = 0
    self._currentProgress = 1
    self:setState(PaGlobal_TutorialState.eState_Done)
  end
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:fadeOutBg()
  local fadeOutAni = PaGlobal_TutorialUiBlackSpirit._ui._fadeOutBg:addColorAnimation(0, 0.4, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  fadeOutAni:SetStartColor(Defines.Color.C_00FFFFFF)
  fadeOutAni:SetEndColor(Defines.Color.C_FFFFFFFF)
  fadeOutAni:SetHideAtEnd(true)
  PaGlobal_TutorialUiBlackSpirit._ui._fadeOutBg:SetShow(true)
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:Step01_Done()
  self._updateTime = 0
  self._currentProgress = 1
  self._currentStep = self._currentStep + 1
  self:setState(PaGlobal_TutorialState.eState_Start)
  PaGlobal_TutorialManager:endTutorial()
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:Step05_SummonBlackSpirit()
  PaGlobal_TutorialManager:ClearEventFunctor()
  PaGlobal_TutorialManager:AddEventFunctor(PaGlobal_TutorialEventList.TutorialEvent_ShowDialog, function(dialogData)
    if false == _ContentsGroup_NewUI_Dialog_All then
      local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
      FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
      FGlobal_AddEffect_DialogButton(funcButtonIndex, "UI_ArrowMark02", true, 0, -90)
    else
      local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
    end
  end)
  PaGlobal_TutorialManager:AddEventFunctor(PaGlobal_TutorialEventList.TutorialEvent_QuestUpdateNotify, function(param)
    local questGroupNo = PaGlobal_TutorialManager:getQuestGroupNoByQuestNoRaw(param._questNoRaw)
    local questId = PaGlobal_TutorialManager:getQuestIdByQuestNoRaw(param._questNoRaw)
    if questGroupNo == 21117 and (questId == 1 or questId == 2) then
      isClearQuest = true
      isAcceptedQuest = true
      if false == _ContentsGroup_NewUI_Dialog_All then
        local funcButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
        FGlobal_EraseAllEffect_DialogButton(funcButtonIndex)
        FGlobal_EraseAllEffect_ExitButton()
        if not questList_isClearQuest(21117, 1) then
          FGlobal_AddEffect_ExitButton("UI_ArrowMark02", true, 0, -90)
        elseif questList_hasProgressQuest(21117, 2) then
          FGlobal_AddEffect_ExitButton("UI_ArrowMark02", true, 0, -90)
        end
      else
        local funcButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
      end
    end
  end)
  PaGlobal_TutorialManager:AddEventFunctor(PaGlobal_TutorialEventList.TutorialEvent_AfterAndPopFlush, function()
    if true == isClearQuest or true == isAcceptedQuest then
      isClearQuest = false
      isAcceptedQuest = false
      if false == _ContentsGroup_NewUI_Dialog_All then
        FGlobal_EraseAllEffect_ExitButton()
      end
      self._currentProgress = 3
    end
  end)
  self:setState(PaGlobal_TutorialState.eState_Do)
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:Step02_BasicMove(deltaTime)
  local currentState = self:getState()
  if PaGlobal_TutorialState.eState_Start == currentState then
    self:Step02_Prepare()
  elseif PaGlobal_TutorialState.eState_Do == currentState then
    self:Step02_DoStep(deltaTime)
  elseif PaGlobal_TutorialState.eState_Done == currentState then
    self:Step01_Done()
  end
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:Step02_Prepare()
  self:setState(PaGlobal_TutorialState.eState_Do)
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:Step02_DoStep(deltaTime)
  if 1 == self._currentProgress then
    local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_101")
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
    PaGlobal_TutorialUiBlackSpirit:setSpiritKeyGuideShow(0)
    self._updateTime = 0
    self._currentProgress = self._currentProgress + 1
  elseif 2 == self._currentProgress then
    if Panel_Interaction:GetShow() then
      local actor = interaction_getInteractable()
      if actor ~= nil then
        local characterKey = actor:getCharacterKeyRaw()
        if 40768 == characterKey then
          self._currentProgress = self._currentProgress + 1
          self._updateTime = 0
        end
      end
    end
    if self._updateTime < 2 * timeRatio then
      local isPress = keyCustom_IsPressed_Action(CppEnums.ActionInputType.ActionInputType_MoveFront)
      if isPress then
        self._updateTime = self._updateTime + deltaTime
      end
      local isPress = keyCustom_IsPressed_Action(CppEnums.ActionInputType.ActionInputType_AutoRun)
      if isPress then
        self._updateTime = 2
      end
    else
      local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_102")
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
      PaGlobal_TutorialUiBlackSpirit:setSpiritKeyGuideShow(4)
      self._updateTime = 0
      self._currentProgress = self._currentProgress + 1
    end
  elseif 3 == self._currentProgress then
    if Panel_Interaction:GetShow() then
      local actor = interaction_getInteractable()
      if actor ~= nil then
        local characterKey = actor:getCharacterKeyRaw()
        if 40768 == characterKey then
          self._currentProgress = self._currentProgress + 1
          self._updateTime = 0
        end
      end
    end
  elseif 4 == self._currentProgress then
    if not questList_hasProgressQuest(21117, 1) then
      PaGlobal_TutorialPhase_RenewalBasicMove_1:Step01_Done()
      return
    end
    if 0 == self._updateTime then
      local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_103")
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
      PaGlobal_TutorialUiBlackSpirit:setSpiritKeyGuideShow(5)
      self._updateTime = self._updateTime + deltaTime
      if not PaGlobal_TutorialUiBlackSpirit._ui._static_KeyGuideBg:GetShow() then
        PaGlobal_TutorialUiBlackSpirit._ui._static_KeyGuideBg:SetShow(true)
      end
    end
    if not Panel_Interaction:GetShow() then
      self._currentProgress = self._currentProgress - 1
      self._updateTime = 0
      PaGlobal_TutorialUiBlackSpirit._ui._static_BottomBg:SetShow(false)
      PaGlobal_TutorialUiBlackSpirit._ui._static_KeyGuideBg:SetShow(false)
    end
    local isPress = keyCustom_IsPressed_Action(CppEnums.ActionInputType.ActionInputType_Interaction)
    if true == isPress then
      self:setState(PaGlobal_TutorialState.eState_Done)
    end
  end
end
function PaGlobal_TutorialPhase_RenewalBasicMove_1:Step01_Done()
  self._updateTime = 0
  self._currentProgress = 1
  self._currentStep = self._currentStep + 1
  self:setState(PaGlobal_TutorialState.eState_Start)
end
PaGlobal_TutorialPhase_RenewalBasicMove_1._classStringData = {
  [CppEnums.ClassType.ClassType_Warrior] = {
    "TUTORIAL_MOVE_WARRIOR_TALK1",
    "TUTORIAL_MOVE_WARRIOR_TALK2",
    "TUTORIAL_MOVE_WARRIOR_TALK3"
  },
  [CppEnums.ClassType.ClassType_Ranger] = {
    "TUTORIAL_MOVE_RANGER_TALK1",
    "TUTORIAL_MOVE_RANGER_TALK2",
    "TUTORIAL_MOVE_RANGER_TALK3"
  },
  [CppEnums.ClassType.ClassType_Sorcerer] = {
    "TUTORIAL_MOVE_SORCERER_TALK1",
    "TUTORIAL_MOVE_SORCERER_TALK2",
    "TUTORIAL_MOVE_SORCERER_TALK3"
  },
  [CppEnums.ClassType.ClassType_Giant] = {
    "TUTORIAL_MOVE_GIANT_TALK1",
    "TUTORIAL_MOVE_GIANT_TALK2",
    "TUTORIAL_MOVE_GIANT_TALK3"
  },
  [CppEnums.ClassType.ClassType_Tamer] = {
    "LUA_TUTORIAL_MOVE_TAMER_TALK1",
    "LUA_TUTORIAL_MOVE_TAMER_TALK2",
    "LUA_TUTORIAL_MOVE_TAMER_TALK3"
  },
  [CppEnums.ClassType.ClassType_BladeMaster] = {
    "LUA_TUTORIAL_MOVE_BLADEMASTER_TALK1",
    "LUA_TUTORIAL_MOVE_BLADEMASTER_TALK2",
    "LUA_TUTORIAL_MOVE_BLADEMASTER_TALK3"
  },
  [CppEnums.ClassType.ClassType_BladeMasterWomen] = {
    "LUA_TUTORIAL_MOVE_BLADEMASTER_TALK1",
    "LUA_TUTORIAL_MOVE_BLADEMASTER_TALK2",
    "LUA_TUTORIAL_MOVE_BLADEMASTER_TALK3"
  },
  [CppEnums.ClassType.ClassType_Valkyrie] = {
    "LUA_TUTORIAL_MOVE_VALKYRIE_TALK1",
    "LUA_TUTORIAL_MOVE_VALKYRIE_TALK2",
    "LUA_TUTORIAL_MOVE_VALKYRIE_TALK3"
  },
  [CppEnums.ClassType.ClassType_Wizard] = {
    "TUTORIAL_MOVE_WIZRAD_TALK1",
    "TUTORIAL_MOVE_WIZRAD_TALK2",
    "TUTORIAL_MOVE_WIZRAD_TALK3"
  },
  [CppEnums.ClassType.ClassType_WizardWomen] = {
    "TUTORIAL_MOVE_WIZRAD_TALK1",
    "TUTORIAL_MOVE_WIZRAD_TALK2",
    "TUTORIAL_MOVE_WIZRAD_TALK3"
  },
  [CppEnums.ClassType.ClassType_NinjaWomen] = {
    "TUTORIAL_MOVE_NINJA_TALK1",
    "TUTORIAL_MOVE_NINJA_TALK2",
    "TUTORIAL_MOVE_NINJA_TALK3"
  },
  [CppEnums.ClassType.ClassType_NinjaMan] = {
    "TUTORIAL_MOVE_NINJA_TALK1",
    "TUTORIAL_MOVE_NINJA_TALK2",
    "TUTORIAL_MOVE_NINJA_TALK3"
  },
  [CppEnums.ClassType.ClassType_DarkElf] = {
    "TUTORIAL_MOVE_DARKELF_TALK1",
    "TUTORIAL_MOVE_DARKELF_TALK2",
    "TUTORIAL_MOVE_DARKELF_TALK3"
  },
  [CppEnums.ClassType.ClassType_Combattant] = {
    "TUTORIAL_MOVE_DARKELF_TALK1",
    "TUTORIAL_MOVE_DARKELF_TALK2",
    "TUTORIAL_MOVE_DARKELF_TALK3"
  },
  [CppEnums.ClassType.ClassType_CombattantWomen] = {
    "TUTORIAL_MOVE_DARKELF_TALK1",
    "TUTORIAL_MOVE_DARKELF_TALK2",
    "TUTORIAL_MOVE_DARKELF_TALK3"
  },
  [CppEnums.ClassType.ClassType_Lahn] = {
    "TUTORIAL_MOVE_DARKELF_TALK1",
    "TUTORIAL_MOVE_DARKELF_TALK2",
    "TUTORIAL_MOVE_DARKELF_TALK3"
  },
  [CppEnums.ClassType.ClassType_Orange] = {
    "TUTORIAL_MOVE_DARKELF_TALK1",
    "TUTORIAL_MOVE_DARKELF_TALK2",
    "TUTORIAL_MOVE_DARKELF_TALK3"
  }
}

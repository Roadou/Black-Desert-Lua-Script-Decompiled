PaGlobal_TutorialPhase_BasicMove = {
  _phaseNo = 1,
  _currentStep = 0,
  _nextStep = 1,
  _currentProgress = 1,
  _updateTime = 0,
  _classStringData = {},
  _isPhaseOpen = true,
  _isSkippable = true,
  _regionKeyRawList = {88, 349},
  _startLimitLevel = 15
}
local classType = 0
function PaGlobal_TutorialPhase_BasicMove:checkPossibleForPhaseStart(stepNo)
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
function PaGlobal_TutorialPhase_BasicMove:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_BasicMove:startPhase(stepNo)
  if false == self:checkPossibleForPhaseStart(stepNo) then
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
function PaGlobal_TutorialPhase_BasicMove:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_BasicMove:startPhase() stepNo : " .. tostring(stepNo))
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  self._updateTime = 0
  classType = getSelfPlayer():getClassType()
  Panel_Tutorial:SetShow(true, true)
  FGlobal_NewQuickSlot_Update()
  ToClient_DeleteNaviGuideByGroup()
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
  PaGlobal_TutorialManager:setAllowShowQuickSlot(false)
  PaGlobal_TutorialManager:setAllowNewQuickSlot(false)
  PaGlobal_TutorialManager:setAllowMainQuestWidget(false)
  PaGlobal_TutorialUiManager:setShowAllDefaultUi(false)
  PaGlobal_TutorialUiManager:getUiKeyButton():setShowAll(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:repositionScreen()
end
function PaGlobal_TutorialPhase_BasicMove:endPhase()
  self._currentStep = 0
  self._nextStep = 1
  self._updateTime = 0
  PaGlobal_TutorialManager:startNextPhase()
end
local result
function PaGlobal_TutorialPhase_BasicMove:updatePerFrame(deltaTime)
  if self._nextStep ~= self._currentStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
  if 1 == self._currentStep then
    result = self:updateBlackSpiritTalk(deltaTime)
  elseif 2 == self._currentStep then
    result = self:updateBasicMove(deltaTime)
  end
  if true == result then
    self._nextStep = self._nextStep + 1
  end
end
function PaGlobal_TutorialPhase_BasicMove:handleChangeStep(currentStep)
  if 1 == currentStep then
    self:changeStepBlackSpiritTalk()
  elseif 2 == currentStep then
    self:changeStepBasicMove()
  elseif 3 == currentStep then
    self:endPhase()
  end
end
function PaGlobal_TutorialPhase_BasicMove:changeStepBlackSpiritTalk()
  getSelfPlayer():setActionChart("TUTORIAL_WAIT_STEP1")
  PaGlobalFunc_QuickSlot_SetShow(false, false)
end
function PaGlobal_TutorialPhase_BasicMove:updateBlackSpiritTalk(deltaTime)
  self._updateTime = self._updateTime + deltaTime
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, self._classStringData[classType][1]), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
    self._updateTime = 0
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  elseif 2 == self._currentProgress and 4 * timeRatio < self._updateTime then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, self._classStringData[classType][2]), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
    self._updateTime = 0
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  elseif 3 == self._currentProgress and 4 * timeRatio < self._updateTime then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, self._classStringData[classType][3]), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    end)
    self._updateTime = 0
    self._currentProgress = self._currentProgress + 1
    self:handleChangeStep(self._currentStep)
  elseif 4 == self._currentProgress and 4 * timeRatio < self._updateTime then
    self._updateTime = 0
    self._currentProgress = 1
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_BasicMove:changeStepBasicMove()
  if nil ~= getSelfPlayer() then
    getSelfPlayer():setActionChart("TUTORIAL_WAIT_STEP2")
  end
  PaGlobal_TutorialUiManager:getUiKeyButton():setShowAll(true)
  PaGlobal_TutorialUiManager:getUiKeyButton():ButtonToggleAll(false)
  PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_2"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
    PaGlobal_TutorialUiManager:getUiBlackSpirit():addBubbleKey("_bubbleKey_W")
  end)
end
function PaGlobal_TutorialPhase_BasicMove:updateBasicMove(deltaTime)
  if 1 == self._currentProgress then
    if self._updateTime < 1.5 * timeRatio then
      local isPress = keyCustom_IsPressed_Action(CppEnums.ActionInputType.ActionInputType_MoveFront)
      if isPress then
        self._updateTime = self._updateTime + deltaTime
      end
      PaGlobal_TutorialUiManager:getUiKeyButton():ButtonToggle("_button_W", true)
    else
      audioPostEvent_SystemUi(4, 12)
      PaGlobal_TutorialUiManager:getUiKeyButton():setShowAll(true)
      PaGlobal_TutorialUiManager:getUiKeyButton():ButtonToggleAll(false)
      PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
        PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_3"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_4"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
        PaGlobal_TutorialUiManager:getUiBlackSpirit():addBubbleKey("_bubbleKey_A", "_bubbleKey_S", "_bubbleKey_D")
        PaGlobal_TutorialUiManager:getUiBlackSpirit():addOverBubbleKey("_bubbleKey_W", "_bubbleKey_S")
      end)
      self._updateTime = 0
      self._currentProgress = self._currentProgress + 1
    end
  elseif 2 == self._currentProgress then
    if self._updateTime < 2 * timeRatio then
      PaGlobal_TutorialUiManager:getUiKeyButton():ButtonToggle("_button_W", true)
      PaGlobal_TutorialUiManager:getUiKeyButton():ButtonToggle("_button_A", true)
      PaGlobal_TutorialUiManager:getUiKeyButton():ButtonToggle("_button_S", true)
      PaGlobal_TutorialUiManager:getUiKeyButton():ButtonToggle("_button_D", true)
      local isPress = keyCustom_IsPressed_Action(CppEnums.ActionInputType.ActionInputType_MoveFront) or keyCustom_IsPressed_Action(CppEnums.ActionInputType.ActionInputType_MoveBack) or keyCustom_IsPressed_Action(CppEnums.ActionInputType.ActionInputType_MoveLeft) or keyCustom_IsPressed_Action(CppEnums.ActionInputType.ActionInputType_MoveRight)
      if isPress then
        self._updateTime = self._updateTime + deltaTime
      end
    else
      if nil ~= getSelfPlayer() then
        getSelfPlayer():setActionChart("TUTORIAL_WAIT_STEP3")
      end
      audioPostEvent_SystemUi(4, 12)
      PaGlobal_TutorialUiManager:getUiKeyButton():setShowAll(true)
      PaGlobal_TutorialUiManager:getUiKeyButton():ButtonToggleAll(false)
      PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
        PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "TUTORIAL_MOVE_STEP2_DARKSPIRIT"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_5"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
        PaGlobal_TutorialUiManager:getUiBlackSpirit():addBubbleKey("_bubbleKey_Shift", "_bubbleKey_W")
      end)
      self._updateTime = 0
      self._currentProgress = self._currentProgress + 1
    end
  elseif 3 == self._currentProgress then
    if self._updateTime < 2 * timeRatio then
      PaGlobal_TutorialUiManager:getUiKeyButton():ButtonToggle("_button_W", true)
      PaGlobal_TutorialUiManager:getUiKeyButton():ButtonToggle("_button_Shift", true)
      local isPress = keyCustom_IsPressed_Action(0) and keyCustom_IsPressed_Action(6)
      if isPress then
        self._updateTime = self._updateTime + deltaTime
      end
    else
      audioPostEvent_SystemUi(4, 12)
      PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
        PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "TUTORIAL_MOVE_STEP3_DARKSPIRIT"), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300)
        PaGlobal_TutorialUiManager:getUiKeyButton():disappearAll()
      end)
      if nil ~= getSelfPlayer() then
        getSelfPlayer():setActionChart("TUTORIAL_END")
      end
      self._updateTime = 0
      self._currentProgress = self._currentProgress + 1
    end
  elseif 4 == self._currentProgress then
    if 2 * timeRatio < self._updateTime then
      return true
    end
    self._updateTime = self._updateTime + deltaTime
  end
  return false
end
PaGlobal_TutorialPhase_BasicMove._classStringData = {
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
  },
  [CppEnums.ClassType.ClassType_ShyWomen] = {
    "TUTORIAL_MOVE_DARKELF_TALK1",
    "TUTORIAL_MOVE_DARKELF_TALK2",
    "TUTORIAL_MOVE_DARKELF_TALK3"
  }
}

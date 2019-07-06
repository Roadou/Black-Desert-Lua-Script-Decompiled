PaGlobal_TutorialPhase_WorldmapBuyHouse = {
  _phaseNo = 11,
  _currentStep = 0,
  _nextStep = 0,
  _currentProgress = 0,
  _prevProgress = 0,
  _updateTime = 0,
  _isPhaseOpen = true,
  _isSkippable = false,
  _currentHouseKey = -1,
  _purchaseableHouseButtonList = {},
  _nodeWaypointKeyList = {
    1,
    301,
    601,
    1101,
    1301,
    61,
    604,
    608,
    602,
    302,
    1141,
    1319,
    1314,
    1343,
    1380,
    1002
  }
}
function PaGlobal_TutorialPhase_WorldmapBuyHouse:checkPossibleForPhaseStart(stepNo)
  if false == self._isPhaseOpen then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 Phase\234\176\128 \235\139\171\237\152\128\236\158\136\236\156\188\235\175\128\235\161\156 \237\138\156\237\134\160\235\166\172\236\150\188\236\157\132 \236\139\156\236\158\145\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164. _phaseNo : " .. tostring(self._phaseNo))
    return false
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() or true == PaGlobal_ArousalTutorial_Manager:isDoingArousalTutorial() or true == PaGlobal_SummonBossTutorial_Manager:isDoingSummonBossTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
    return false
  end
  return true
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:checkSkippablePhase()
  if true == self._isSkippable and true == PaGlobal_TutorialManager:checkHaveOverLevelCharacter() then
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:startPhase(stepNo)
  if false == self:checkPossibleForPhaseStart(stepNo) then
    return
  end
  local isSkippable = self:checkSkippablePhase()
  if true == isSkippable and false == PaGlobal_TutorialManager:isDoingTutorial() then
    PaGlobal_TutorialManager:questionPhaseSkip(self, stepNo)
  else
    self:startPhaseXXX(stepNo)
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:startPhaseXXX(stepNo)
  PaGlobal_TutorialManager:setCurrentPhaseNo(self._phaseNo)
  PaGlobal_TutorialManager:setDoingTutorial(true)
  _PA_LOG("\234\179\189\235\175\188\236\154\176", "PaGlobal_TutorialPhase_WorldmapBuyHouse:startStep() stepNo : " .. tostring(stepNo) .. " typeNo : " .. tostring(typeNo))
  self._currentStep = 0
  self._nextStep = stepNo
  self._currentProgress = 1
  self._prevProgress = 1
  self._updateTime = 0
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(false)
  PaGlobal_TutorialManager:setAllowShowQuickSlot(true)
  PaGlobal_TutorialManager:setAllowNewQuickSlot(true)
  FGlobal_WorldmapMain_SetAllowTutorialPanelShow(true)
  PaGlobal_TutorialUiManager:getUiKeyButton():setShowAll(false)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:repositionScreen()
  Panel_Tutorial:SetShow(true, true)
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:endPhase()
  self._purchaseableHouseButtonList = {}
  if -1 ~= self._currentHouseKey then
    HouseControlManager:EraseAllEffectGroupTypeButtonByHouseKey(self._currentHouseKey, CppEnums.eHouseUseType.Empty)
  end
  HouseControlManager:EraseAllEffectBuyButton()
  FGlobal_WorldmapMain_SetAllowTutorialPanelShow(false)
  PaGlobal_TutorialUiBlackSpirit:setIgnoreBubble(true)
  PaGlobal_TutorialManager:setAllowCallBlackSpirit(true)
  PaGlobal_TutorialManager:endTutorial()
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:updatePerFrame(deltaTime)
  if self._currentStep ~= self._nextStep then
    self._currentStep = self._nextStep
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:handleChangeStep(currentStep)
  if 1 == self._currentStep then
    self:changeStep1()
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:toNextProgress()
  self._currentProgress = self._currentProgress + 1
  self:handleChangeStep(self._currentStep)
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:toNextStep()
  self._currentProgress = 1
  self._nextStep = self._nextStep + 1
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:toStep(destStep, destProgress)
  self._nextStep = destStep
  if nil == destProgress then
    self._currentProgress = 1
  else
    self._currentProgress = destProgress
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:setEffectNodeWaypointKeyList(waypointKey)
  for index, value in ipairs(self._nodeWaypointKeyList) do
    FGlobal_WorldmapMain_EraseAllEffectUiNodeButtonByWaypointKey(value)
    FGlobal_WorldmapMain_AddEffectUiNodeButtonByWaypointKey(value, "UI_ArrowMark02", true, 0, -50)
    FGlobal_WorldmapMain_AddEffectUiNodeButtonByWaypointKey(value, "UI_WorldMap_Ping01", true, 0, 0)
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:changeStep1()
  if 1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_45"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_46"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif -1 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_47"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_48"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
  elseif 2 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_49"), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 3 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_50"), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 4 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_51"), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 5 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_52"), "", false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, false)
    end)
  elseif 6 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_53"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_54"), false, getScreenSizeX() * 0.5 - 20, getScreenSizeY() * 0.5 - 300, true)
    end)
    self:setEffectNodeWaypointKeyList()
  elseif 7 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_55"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_56"), false, getScreenSizeX() * 0.3, getScreenSizeY() * 0.05, true)
    end)
  elseif 8 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_57"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_58"), false, getScreenSizeX() * 0.3, getScreenSizeY() * 0.05, true)
    end)
  elseif 9 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_59"), "", false, getScreenSizeX() * 0.3, getScreenSizeY() * 0.05, false)
    end)
  elseif 10 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_60"), "", false, getScreenSizeX() * 0.3, getScreenSizeY() * 0.05, false)
    end)
  elseif 11 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_61"), "", false, getScreenSizeX() * 0.3, getScreenSizeY() * 0.05, false)
    end)
  elseif 12 == self._currentProgress then
    PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
      PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_NEW_KR_62"), "", false, getScreenSizeX() * 0.3, getScreenSizeY() * 0.05, false)
    end)
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:eventCallStep1WorldMapOpenComplete()
  if -1 == self._currentProgress then
    if 6 <= self._prevProgress and self._prevProgress <= 8 then
      self._currentProgress = 6
      self:handleChangeStep(self._currentStep)
      self:setEffectNodeWaypointKeyList()
    else
      self._currentProgress = self._prevProgress
      self:handleChangeStep(self._currentStep)
    end
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:eventCallStep1WorldMapImmediatelyClose()
  if -1 ~= self._currentHouseKey then
    HouseControlManager:EraseAllEffectGroupTypeButtonByHouseKey(self._currentHouseKey, CppEnums.eHouseUseType.Empty)
    HouseControlManager:EraseAllEffectBuyButton()
    HouseControlManager:SetEnableBuyButton(true)
    HouseControlManager:SetEnableChangeUseTypeButton(true)
  end
  self._currentHouseKey = -1
  if self._currentProgress <= 8 then
    self._prevProgress = self._currentProgress
    self._currentProgress = -1
    self:handleChangeStep(self._currentStep)
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:eventCallStep1NodeLClick(uiNodeButton)
  self._purchaseableHouseButtonList = {}
  if 6 == self._currentProgress then
    for index, value in ipairs(self._nodeWaypointKeyList) do
      if value == uiNodeButton:getWaypointKey() then
        self:toNextProgress()
        return
      end
    end
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:eventCallStep1HouseHoldButtonSetBaseTexture(uiHouseButton)
  if 7 == self._currentProgress or 8 == self._currentProgress then
    if nil == uiHouseButton then
      return
    end
    local houseInfoSSW = uiHouseButton:FromClient_getStaticStatus()
    if nil == houseInfoSSW then
      _PA_ASSERT(false, "\237\149\152\236\157\180\235\141\184_\236\167\145\234\181\172\235\167\164 \237\138\156\237\134\160\235\166\172\236\150\188 : \236\167\145\236\157\152 \234\179\160\236\160\149\236\160\149\235\179\180\235\165\188 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.")
      return
    end
    local houseKey = houseInfoSSW:getHouseKey()
    if false == ToClient_IsMyHouse(houseKey) and true == houseInfoSSW:isPurchasable(CppEnums.eHouseUseType.Depot) then
      table.insert(self._purchaseableHouseButtonList, uiHouseButton)
    end
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:eventCallStep1SetTownMode(waypointKey)
  if 7 == self._currentProgress or 8 == self._currentProgress then
    for index, value in ipairs(self._purchaseableHouseButtonList) do
      value:EraseAllEffect()
      value:AddEffect("UI_ArrowMark01", true, 30, -30)
      value:AddEffect("UI_ItemInstall", true, 0, 0)
    end
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:eventCallStep1ResetTownMode()
  self._purchaseableHouseButtonList = {}
  if 6 <= self._currentProgress and self._currentProgress <= 8 then
    self:setEffectNodeWaypointKeyList()
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:eventCallStep1LClickedWorldMapHouse(uiHouseButton)
  FGlobal_Set_HousePanelPos_ForWorldmapTutorial()
  if nil == uiHouseButton:FromClient_getStaticStatus() then
    _PA_ASSERT(false, "\237\149\152\236\157\180\235\141\184_\236\167\145\234\181\172\235\167\164 \237\138\156\237\134\160\235\166\172\236\150\188 : \236\132\160\237\131\157\237\149\156 \236\167\145\236\157\152 \234\179\160\236\160\149\236\160\149\235\179\180\235\165\188 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local houseInfoSSW = uiHouseButton:FromClient_getStaticStatus()
  local houseKey = uiHouseButton:FromClient_getStaticStatus():getHouseKey()
  self._currentHouseKey = houseKey
  if (7 == self._currentProgress or 8 == self._currentProgress) and false == ToClient_IsMyHouse(houseKey) and true == houseInfoSSW:isPurchasable(CppEnums.eHouseUseType.Depot) then
    HouseControlManager:EraseAllEffectGroupTypeButtonByHouseKey(houseKey, CppEnums.eHouseUseType.Empty)
    HouseControlManager:AddEffectGroupTypeButtonByHouseKey(houseKey, CppEnums.eHouseUseType.Empty, "UI_ArrowMark07", true, 0, 25)
    if 7 == self._currentProgress then
      self:toNextProgress()
    end
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:eventCallStep1CloseHouseControl()
  if -1 ~= self._currentHouseKey then
    HouseControlManager:EraseAllEffectGroupTypeButtonByHouseKey(self._currentHouseKey, CppEnums.eHouseUseType.Empty)
    HouseControlManager:EraseAllEffectBuyButton()
    HouseControlManager:SetEnableBuyButton(true)
    HouseControlManager:SetEnableChangeUseTypeButton(true)
  end
  self._currentHouseKey = -1
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:eventCallStep1ClickedHouseControlSetUseType(index, groupType)
  if 8 == self._currentProgress then
    if -1 == self._currentHouseKey then
      return
    end
    local uiHouseButton = ToClient_findHouseButtonByKey(self._currentHouseKey)
    if CppEnums.eHouseUseType.Empty == groupType then
      HouseControlManager:EraseAllEffectGroupTypeButtonByHouseKey(self._currentHouseKey, CppEnums.eHouseUseType.Empty)
      HouseControlManager:EraseAllEffectBuyButton()
      HouseControlManager:AddEffectBuyButton("UI_ArrowMark07", true, 50, 25)
      self:toNextProgress()
    else
      HouseControlManager:EraseAllEffectGroupTypeButtonByHouseKey(self._currentHouseKey, CppEnums.eHouseUseType.Empty)
      HouseControlManager:AddEffectGroupTypeButtonByHouseKey(self._currentHouseKey, CppEnums.eHouseUseType.Empty, "UI_ArrowMark07", true, 0, 25)
      HouseControlManager:EraseAllEffectBuyButton()
    end
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:eventCallStep1MouseLUpBubble()
  if 12 == self._currentProgress then
    self:endPhase()
  else
    self:toNextProgress()
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:handleWorldMapOpenComplete()
  if 1 == self._currentStep then
    self:eventCallStep1WorldMapOpenComplete()
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:handleWorldMapImmediatelyClose()
  if 1 == self._currentStep then
    self:eventCallStep1WorldMapImmediatelyClose()
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:handleHouseHoldButtonSetBaseTexture(uiHouseButton)
  if 1 == self._currentStep then
    self:eventCallStep1HouseHoldButtonSetBaseTexture(uiHouseButton)
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:handleLClickWorldMapNode(uiNodeButton)
  if 1 == self._currentStep then
    self:eventCallStep1NodeLClick(uiNodeButton)
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:handleSetTownMode(waypointKey)
  if 1 == self._currentStep then
    self:eventCallStep1SetTownMode(waypointKey)
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:handleResetTownMode()
  self:eventCallStep1ResetTownMode()
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:handleLClickedWorldMapHouse(uiHouseButton)
  if 1 == self._currentStep then
    self:eventCallStep1LClickedWorldMapHouse(uiHouseButton)
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:handleClickedHouseControlSetUseType(index, groupType)
  if 1 == self._currentStep then
    self:eventCallStep1ClickedHouseControlSetUseType(index, groupType)
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:handleCloseHouseControl()
  if 1 == self._currentStep then
    self:eventCallStep1CloseHouseControl()
  end
end
function PaGlobal_TutorialPhase_WorldmapBuyHouse:handleMouseLUpBubble()
  if 1 == self._currentStep then
    self:eventCallStep1MouseLUpBubble()
  end
end

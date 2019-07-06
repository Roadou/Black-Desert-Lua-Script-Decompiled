local IM = CppEnums.EProcessorInputMode
AutoState_WaitForPressButton = {
  _state = AutoStateType.WAIT_FOR_PRESSBUTTON,
  _mainState = {
    None = 0,
    Normal = 1,
    Hunt = 2,
    Move = 3
  },
  _curMainState = 0,
  _curMsgIndex = 0,
  _updateTime = 1,
  _updateCurTime = 0,
  _isUpdateMouse = false,
  _isCompleteEffectOn = false,
  _btnPosX = 0,
  _btnPosY = 0,
  _isQuestSatisfied = false,
  _isNotAcceptQuest = false,
  _isExceptionQuest = false,
  _isNoHunt = false
}
function AutoState_WaitForPressButton:init()
  local questWidget = PaGlobal_MainQuest._uiAutoNaviBtn
  self._btnPosX = Panel_MainQuest:GetPosX() + questWidget:GetPosX() + questWidget:GetSizeX() / 2
  self._btnPosY = Panel_MainQuest:GetPosY() + questWidget:GetPosY() + questWidget:GetSizeY() / 2
end
function AutoState_WaitForPressButton:start()
  self._questList = ToClient_GetQuestList()
  self._isUpdateMouse = false
  self._updateCurTime = 1
  self._curMainState = self._mainState.None
  self._curMsgIndex = 0
end
function AutoState_WaitForPressButton:update(deltaTime)
  self:updateMouse(deltaTime)
  self._updateCurTime = self._updateCurTime + deltaTime
  if self._updateCurTime < self._updateTime then
    return
  end
  self._updateCurTime = 0
  self._uiQuestInfo = self._questList:getMainQuestInfo()
  self._isQuestSatisfied = self._uiQuestInfo:isSatisfied()
  self._isNotAcceptQuest = false == self._uiQuestInfo._isCleared and false == self._uiQuestInfo._isProgressing
  self._isExceptionQuest = AutoState_ExceptionGuide:checkException(self._uiQuestInfo:getQuestNo()._group, self._uiQuestInfo:getQuestNo()._quest)
  self._isNoHunt = AutoState_ExceptionGuide:noHunt(self._uiQuestInfo:getQuestNo()._group, self._uiQuestInfo:getQuestNo()._quest)
  if true == self:enableMoveState() then
    self:setMainState(self._mainState.Move)
  elseif true == Auto_FindNearQuestMonster() and false == self._isNoHunt then
    self:setMainState(self._mainState.Hunt)
  else
    self:updateNormal(deltaTime)
  end
end
function AutoState_WaitForPressButton:endProc()
  PaGlobal_AutoQuestMsg._accessBlackSpiritClick = nil
  self._curMainState = self._mainState.None
end
function AutoState_WaitForPressButton:updateNormal(deltaTime)
  self:setMainState(self._mainState.Normal)
  if true == self._isExceptionQuest and false == self._isNotAcceptQuest then
    _PA_LOG("\235\176\149\234\183\156\235\130\152_Auto", "updateNormal EXCEPTION_GUIDE")
    Auto_TransferState(AutoStateType.EXCEPTION_GUIDE)
  elseif true == ToClient_isCheckRenderModeDialog() then
    _PA_LOG("\235\176\149\234\183\156\235\130\152_Auto", "updateNormal DIALOG_INTERACTION")
    Auto_TransferState(AutoStateType.DIALOG_INTERACTION)
  else
    self:checkNormalState()
  end
end
function AutoState_WaitForPressButton:checkNormalState()
  local meetNpcKey = ToClient_checkNearMeetNPC()
  if 0 ~= meetNpcKey then
    _PA_LOG("\235\176\149\234\183\156\235\130\152_Auto", "updateNormal meetNpcKey")
    local meetNpcActorName = getNpcActor(meetNpcKey):getOriginalName()
    self:updateMessage(3, false, PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_WAITFORBUTTON_NPC_INTERACTION_R", "characterKey", meetNpcActorName, "InteractionKey", keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_Interaction)))
  elseif true == self._isQuestSatisfied then
    _PA_LOG("\235\176\149\234\183\156\235\130\152_Auto", "updateNormal isSatisfied")
    self:SetShowCompleteEffect(true)
    if UI.Get_ProcessorInputMode() == IM.eProcessorInputMode_GameMode then
      self:updateMessage(4, false, PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_WAITFORBUTTON_SHOW_MOUSE"))
    else
      self:updateMessage(5, true, PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_WAITFORBUTTON_MOUSE_L_FOR_DIALOG"))
    end
  elseif true == isVisibleAcceptButton() then
    self:updateMessage(6, false, "[TEST] isVisibleAcceptButton \236\157\180 \235\173\144\236\151\172?")
  elseif true == self._isNotAcceptQuest then
    self:SetShowCompleteEffect(true)
    self:updateMessage(7, true, "[TEST] \237\128\152\236\138\164\237\138\184 \235\175\184\236\136\152\235\157\189 \236\131\129\237\131\156\236\158\133\235\139\136\235\139\164. \236\157\152\235\162\176\235\165\188 \235\176\155\236\149\132 \236\163\188\236\132\184\236\154\148.")
  else
    self:SetShowCompleteEffect(false)
    self:updateMessage(100, false, PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_WANG"))
  end
end
function AutoState_WaitForPressButton:updateMessage(idx, isMouseUpdate, message)
  if idx == self._curMsgIndex then
    return
  end
  self._curMsgIndex = idx
  FGlobal_AutoQuestBlackSpiritMessage(message)
  self._isUpdateMouse = isMouseUpdate
  _PA_LOG("\235\176\149\234\183\156\235\130\152_Auto", "Message : " .. tostring(message))
end
function AutoState_WaitForPressButton:updateMouse(deltaTime)
  if false == self._isUpdateMouse then
    return
  end
  if false == FromClient_IsClientFocused() then
    return
  end
  if true == isMouseMove() then
    self._isUpdateMouse = false
  end
  if false == Auto_MouseMove(self._btnPosX, self._btnPosY) then
    self._isUpdateMouse = false
  end
end
function AutoState_WaitForPressButton:setMainState(idx)
  if idx == self._curMainState then
    return false
  end
  self._curMainState = idx
  self:SetShowCompleteEffect(false)
  if idx == self._mainState.Normal then
    PaGlobal_AutoQuestMsg._accessBlackSpiritClick = nil
  elseif idx == self._mainState.Hunt then
    PaGlobal_AutoQuestMsg._accessBlackSpiritClick = AutoState_Hunt_AccessBlackSpiritclick
    self:updateMessage(1, false, PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_WAITFORBUTTON_ATTACK_POSSESSEDBY_BLACKSPIRIT"))
  elseif idx == self._mainState.Move then
    PaGlobal_AutoQuestMsg._accessBlackSpiritClick = AutoState_Move_AccessBlackSpiritclick
    if true == self._isExceptionQuest then
      self:updateMessage(2, false, PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_EXCEPTIONGUIDE_" .. tostring(self._uiQuestInfo:getQuestNo()._group) .. "_" .. tostring(self._uiQuestInfo:getQuestNo()._quest) .. "_0"))
    else
      self:updateMessage(3, false, PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_WAITFORBUTTON_MOVE_POSSESSEDBY_BLACKSPIRIT"))
    end
  else
    _PA_LOG("\235\176\149\234\183\156\235\130\152_Auto", "[ERROR] setMainState : " .. tostring(idx))
  end
  local mainStateSting = {
    [0] = "None",
    "Normal",
    "Hunt",
    "Move"
  }
  _PA_LOG("\235\176\149\234\183\156\235\130\152_Auto", "setMainState : " .. tostring(mainStateSting[idx]) .. " , ClickFunc : " .. tostring(PaGlobal_AutoQuestMsg._accessBlackSpiritClick))
  return true
end
function AutoState_Move_AccessBlackSpiritclick()
  _PA_LOG("\235\176\149\234\183\156\235\130\152_Auto", "AutoState_Move_AccessBlackSpiritclick")
  local self = AutoState_WaitForPressButton
  local questCondition
  if true == self._uiQuestInfo:isSatisfied() then
    questCondition = QuestConditionCheckType.eQuestConditionCheckType_Complete
  else
    questCondition = QuestConditionCheckType.eQuestConditionCheckType_Progress
  end
  if false == ToClient_currentNaviisMainQuest() then
    _QuestWidget_FindTarget_DrawMapPath(self._uiQuestInfo:getQuestNo()._group, self._uiQuestInfo:getQuestNo()._quest, questCondition, false)
  elseif ToClient_getNaviEndPointDist() < 300 then
    ToClient_DeleteNaviGuideByGroup(0)
    _QuestWidget_FindTarget_DrawMapPath(self._uiQuestInfo:getQuestNo()._group, self._uiQuestInfo:getQuestNo()._quest, questCondition, false)
  end
  ToClient_NaviReStart()
end
function AutoState_Hunt_AccessBlackSpiritclick()
  Auto_TransferState(AutoStateType.HUNT)
end
function AutoState_WaitForPressButton:SetShowCompleteEffect(isShow)
  if false == isShow then
    if true == self._isCompleteEffectOn then
      Panel_MainQuest:EraseAllEffect()
      self._isCompleteEffectOn = false
    end
  elseif false == self._isCompleteEffectOn then
    Panel_MainQuest:AddEffect("fUI_QuestComplete_01A", true, 122, -12)
    self._isCompleteEffectOn = true
  end
end
function AutoState_WaitForPressButton:enableMoveState()
  if true == self._isQuestSatisfied then
    return false
  elseif true == self._isNotAcceptQuest then
    return false
  elseif 0 ~= ToClient_checkNearMeetNPC() then
    return false
  elseif 0 == Auto_IsPlayerInsideQuestArea(self._uiQuestInfo) then
    return false
  else
    return true
  end
end

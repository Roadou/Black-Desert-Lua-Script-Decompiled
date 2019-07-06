local AutoDialogInteractionState_Type = {
  NONE = 0,
  ESCAPE = 1,
  MOUSE_MOVING = 2,
  KEYBOARD_R = 3,
  ACCEPT_QUEST = 4,
  SELECT_REWARD = 5,
  COMPLETE_QUEST = 6,
  ACCEPT_CONFIRM = 7,
  SELECTLIST_QUEST = 8,
  NEEDTOLEARN_KNOWLEDGE = 9
}
AutoState_DialogInteraction = {
  _state = AutoStateType.DIALOG_INTERACTION,
  _interactionState = AutoDialogInteractionState_Type.NONE,
  _pressDelay = 0,
  _printTime = 3,
  _uiMode = nil,
  _targetName = ""
}
local AutoState_MouseMoving_TargetButton = {
  NONE = 0,
  DIALOG_ACCEPT_BUTTON = 1,
  DIALOG_REWARD_BUTTON = 2
}
function AutoState_DialogInteraction:init()
end
function AutoState_DialogInteraction:start()
  ToClient_GetKnowledgeSize()
  self._interactionState = AutoDialogInteractionState_Type.NONE
  self._mouseMovingTargetButton = AutoState_MouseMoving_TargetButton.NONE
  self._targetName = ""
  self._uiMode = GetUIMode()
  self:checkChangeState()
end
function AutoState_DialogInteraction:update(deltaTime)
  if ToClient_isCheckRenderModeDialog() == false then
    Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
    return
  end
  if _uiMode == Defines.UIMode.eUIMode_NpcDialog then
  elseif Defines.UIMode.eUIMode_NpcDialog == GetUIMode() then
    self._uiMode = Defines.UIMode.eUIMode_NpcDialog
    if self._uiMode ~= Defines.UIMode.eUIMode_NpcDialog then
      self:checkChangeState()
    end
  else
    return
  end
  self._pressDelay = self._pressDelay + deltaTime
  if self._printTime < self._pressDelay then
    self._pressDelay = 0
    if self._interactionState == AutoDialogInteractionState_Type.ESCAPE then
      FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_DIALOG_ESCAPE"))
    elseif self._interactionState == AutoDialogInteractionState_Type.ACCEPT_QUEST then
      FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_DIALOG_ACCEPT_QUEST"))
    elseif self._interactionState == AutoDialogInteractionState_Type.KEYBOARD_R then
      FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_DIALOG_KEYBOARD_R"))
    elseif self._interactionState == AutoDialogInteractionState_Type.SELECT_REWARD then
      FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_DIALOG_SELECT_REWARD"))
    elseif self._interactionState == AutoDialogInteractionState_Type.COMPLETE_QUEST then
      FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_DIALOG_COMPLETE_QUEST"))
    elseif self._interactionState == AutoDialogInteractionState_Type.ACCEPT_CONFIRM then
      FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_DIALOG_ACCEPT_CONFIRM"))
    elseif self._interactionState == AutoDialogInteractionState_Type.SELECTLIST_QUEST then
      FGlobal_AutoQuestBlackSpiritMessage("'" .. self._targetName .. "'" .. PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_DIALOG_ACCEPT_CONFIRM"))
    elseif self._interactionState == AutoDialogInteractionState_Type.NEEDTOLEARN_KNOWLEDGE then
      FGlobal_AutoQuestBlackSpiritMessage(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_DIALOG_NEEDTOLEARN_KNOWLEDGE", "knowledgeName", self._targetName, "buttonName", self._targetName2))
    end
  end
  if ToClient_isCheckRenderModeDialog() == false then
    Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
    return
  end
  self:MouseUpdate()
end
function AutoState_DialogInteraction:endProc()
end
function AutoState_DialogInteraction:checkChangeState()
  self._interactionState = AutoDialogInteractionState_Type.ESCAPE
  self._mouseMovingTargetButton = AutoState_MouseMoving_TargetButton.NONE
  self._pressDelay = self._printTime
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
    _PA_LOG("\234\185\128\234\183\156\235\179\180", "dialogData == nil, AutoState_DialogInteraction")
    return
  end
  local reward = dialogData:getSelectRewardCount()
  local bcount = dialogData:getFuncButtonCount()
  local newMainQuest = dialogData:isHaveAcceptMainQuest()
  local questButtonIndex
  if false == _ContentsGroup_NewUI_Dialog_All then
    questButtonIndex = FGlobal_Dialog_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
  else
    questButtonIndex = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
  end
  if -1 ~= questButtonIndex and true == newMainQuest then
    self._interactionState = AutoDialogInteractionState_Type.ACCEPT_QUEST
    self._mouseMovingTargetButton = AutoState_MouseMoving_TargetButton.DIALOG_ACCEPT_BUTTON
    return
  end
  local AutoState_isQuestComplete = function()
    local _isComplete = false
    if true == _ContentsGroup_NewUI_Dialog_All then
      _isComplete = PaGlobalFunc_DialogList_All_IsQuestComplete()
    else
      _isComplete = isQuestComplete()
    end
    return _isComplete
  end
  if true == AutoState_isQuestComplete() or dialogData:getDialogState() == CppEnums.DialogState.eDialogState_QuestComplete then
    if reward > 0 then
      self._interactionState = AutoDialogInteractionState_Type.SELECT_REWARD
      self._mouseMovingTargetButton = AutoState_MouseMoving_TargetButton.DIALOG_REWARD_BUTTON
    else
      self._interactionState = AutoDialogInteractionState_Type.COMPLETE_QUEST
    end
    return
  end
  local nDlgButtoncount = dialogData:getDialogButtonCount()
  local _isNextBtnShow = false
  if false == _ContentsGroup_NewUI_Dialog_All then
    _isNextBtnShow = isNextButtonShow()
  end
  if false == _isNextBtnShow and true == newMainQuest then
    for i = 0, nDlgButtoncount - 1 do
      local dialogButtonLink = dialogData:getDialogButtonAt(i)
      local questStaticStatus = dialogButtonLink:getQuestStaticStatus()
      if nil ~= dialogButtonLink and nil ~= questStaticStatus and questStaticStatus:getQuestType() == CppEnums.QuestType.eQuestType_BlackSpirit and false == ToClient_isProgressingQuest(questStaticStatus:getQuestNo()._group, questStaticStatus:getQuestNo()._quest) then
        self._interactionState = AutoDialogInteractionState_Type.SELECTLIST_QUEST
        self._targetName = dialogButtonLink:getQuestStaticStatus():getTitle()
        return
      end
    end
  end
  if true == _isNextBtnShow then
    self._interactionState = AutoDialogInteractionState_Type.KEYBOARD_R
    return
  end
  _PA_LOG("\234\185\128\234\183\156\235\179\180", "-- \236\167\128\236\139\157\236\157\132 \236\150\187\236\150\180\236\149\188\237\149\152\235\138\148 \236\131\129\237\153\169\236\157\180\235\157\188\235\169\180;")
  do
    local questList = ToClient_GetQuestList()
    local uiQuestInfo = questList:getMainQuestInfo()
    local knowledgeList = uiQuestInfo:getKnowledgeList()
    for i = 0, knowledgeList._size - 1 do
      local keyRaw = knowledgeList:getKnowledgeKey(i)
      _PA_LOG("\234\185\128\234\183\156\235\179\180", "--   " .. tostring(keyRaw) .. "   " .. tostring(ToClient_HavePushKnowledge(keyRaw)) .. "    " .. tostring(ToClient_IsLearnedKnowledge(keyRaw)))
      if true == ToClient_HavePushKnowledge(keyRaw) and false == ToClient_IsLearnedKnowledge(keyRaw) then
        self._interactionState = AutoDialogInteractionState_Type.NEEDTOLEARN_KNOWLEDGE
        self._targetName = knowledgeList:getKnowledgeName(i)
        self._targetName2 = knowledgeList:getKnowledgeButtonName(i)
        _PA_LOG("\234\185\128\234\183\156\235\179\180", "--wltlr" .. tostring(self._targetName) .. "  " .. tostring(self._targetName2))
        return
      end
    end
    _PA_LOG("\234\185\128\234\183\156\235\179\180", "-- \236\167\128\236\139\157\235\129\157")
  end
  if not newMainQuest then
    local _isVisibleDisplayQuestBtn = false
    if false == _ContentsGroup_NewUI_Dialog_All then
      _isVisibleDisplayQuestBtn = isVisibleDisplayQuestButton()
    else
      _isVisibleDisplayQuestBtn = PaGlobalFunc_DialogList_All_IsVisibleButton(CppEnums.DialogState.eDialogState_DisplayQuest)
    end
    if reward == 0 and bcount ~= 0 or true == _isVisibleDisplayQuestBtn or true == _isNextBtnShow then
      self._interactionState = AutoDialogInteractionState_Type.ESCAPE
      return
    end
  end
  if isVisibleAcceptButton() == true then
    self._interactionState = AutoDialogInteractionState_Type.ACCEPT_CONFIRM
    return
  end
end
function AutoState_DialogInteraction:MouseUpdate()
  if FromClient_IsClientFocused() == false then
    return
  end
  if true == isMouseMove() then
    self._mouseMovingTargetButton = AutoState_MouseMoving_TargetButton.NONE
    return
  end
  if self._mouseMovingTargetButton == AutoState_MouseMoving_TargetButton.DIALOG_ACCEPT_BUTTON then
    local pos, posX, posY
    if true == _ContentsGroup_RenewUI_Dailog then
      pos = PaGlobalFunc_MainDialog_Bottom_GetFuncPositionNewQuestButton(CppEnums.ContentsType.Contents_NewQuest)
      local sizeX, sizeY = PaGlobalFunc_MainDialog_Bottom_GetFuncButtonSizeXY()
      posX = pos._PosX + sizeX / 2
      posY = pos._PosY + PaGlobalFunc_MainDialog_Bottom_GetSizeY() + sizeY / 2
    elseif false == _ContentsGroup_NewUI_Dialog_All then
      pos = FGlobal_Dialog_GetFuncPositionNewQuestButton(CppEnums.ContentsType.Contents_NewQuest)
      posX = pos._PosX + 10
      posY = pos._PosY + Panel_Npc_Dialog:GetPosY() + 10
    else
      pos = PaGlobalFunc_DialogMain_All_GetFuncPositionNewQuestButton(CppEnums.ContentsType.Contents_NewQuest)
      posX = pos._PosX + 10
      posY = pos._PosY + Panel_Npc_Dialog_All:GetPosY() + 10
    end
    if false == pos._Return then
      _PA_LOG("\234\185\128\234\183\156\235\179\180", "MouseUpdate, \236\131\136\235\161\156\236\154\180 \236\157\152\235\162\176 \235\178\132\237\138\188\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\235\139\164")
    end
    if false == pos._Return or false == Auto_MouseMove(posX, posY) then
      self._mouseMovingTargetButton = AutoState_MouseMoving_TargetButton.NONE
    end
  elseif self._mouseMovingTargetButton == AutoState_MouseMoving_TargetButton.DIALOG_REWARD_BUTTON then
    local pos = FGlobal_getSelectRewardPosition()
    if false == Auto_MouseMove(pos._PosX, pos._PosY) then
      self._interactionState = AutoDialogInteractionState_Type.COMPLETE_QUEST
      self._mouseMovingTargetButton = AutoState_MouseMoving_TargetButton.NONE
      _PA_LOG("\234\185\128\234\183\156\235\179\180", "DIALOG_REWARD_BUTTON NONE")
    else
      self._interactionState = AutoDialogInteractionState_Type.DIALOG_REWARD_BUTTON
    end
  end
end
function AutoState_DialogInteraction:NotifyChangeDialog()
  _PA_LOG("\234\185\128\234\183\156\235\179\180", "be NotifyChangeDialog")
  self:checkChangeState()
end

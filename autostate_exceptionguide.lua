AutoState_ExceptionGuide = {
  _state = AutoStateType.DEAD,
  _targetQuestList = {
    {652, 2},
    {655, 5},
    {652, 8},
    {653, 6},
    {653, 7},
    {657, 2},
    {658, 2},
    {658, 3}
  },
  _targetQuestListNoHunt = {
    {652, 3}
  },
  _uiQuestInfo = nil
}
function AutoState_ExceptionGuide:init()
  self._uiQuestInfo = nil
end
function AutoState_ExceptionGuide:start()
  local questList = ToClient_GetQuestList()
  local uiQuestInfo = questList:getMainQuestInfo()
  if uiQuestInfo == nil or false == self:checkException(uiQuestInfo:getQuestNo()._group, uiQuestInfo:getQuestNo()._quest) then
    _PA_LOG("\234\185\128\234\183\156\235\179\180", "AutoState_ExceptionGuide\236\151\144 \235\147\177\235\161\157\235\144\152\236\167\128 \236\149\138\236\157\128 \237\128\152\236\138\164\237\138\184\235\138\148 \236\139\164\237\150\137\237\149\160 \236\136\152 \236\151\134\235\139\164   " .. tostring(uiQuestInfo:getQuestNo()._group) .. "    " .. tostring(uiQuestInfo:getQuestNo()._quest))
    Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
    return
  end
  self._uiQuestInfo = uiQuestInfo
  FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_EXCEPTIONGUIDE_" .. tostring(uiQuestInfo:getQuestNo()._group) .. "_" .. tostring(uiQuestInfo:getQuestNo()._quest) .. "_2"))
end
function AutoState_ExceptionGuide:update(deltaTime)
  if true == self._uiQuestInfo:isSatisfied() then
    Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
    return
  end
  if true == Auto_FindNearQuestMonster() then
    Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
    return
  end
  if 0 ~= Auto_IsPlayerInsideQuestArea(self._uiQuestInfo) then
    Auto_TransferState(AutoStateType.WAIT_FOR_PRESSBUTTON)
    return
  end
end
function AutoState_ExceptionGuide:endProc()
  self._uiQuestInfo = nil
end
function AutoState_ExceptionGuide:checkException(groupNo, questNo)
  for _, tempQuest in pairs(self._targetQuestList) do
    if tempQuest[1] == groupNo and tempQuest[2] == questNo then
      return true
    end
  end
  return false
end
function AutoState_ExceptionGuide:noHunt(groupNo, questNo)
  for _, tempQuest in pairs(self._targetQuestListNoHunt) do
    if tempQuest[1] == groupNo and tempQuest[2] == questNo then
      return true
    end
  end
  return false
end

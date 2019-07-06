local AutoDeadState_Type = {NONE = 0}
AutoState_Dead = {
  _state = AutoStateType.DEAD,
  _pressDelay = 0,
  _printTime = 3
}
function AutoState_Dead:init()
end
function AutoState_Dead:start()
  _pressDelay = _printTime
end
function AutoState_Dead:update(deltaTime)
  self._pressDelay = self._pressDelay + deltaTime
  if self._printTime < self._pressDelay then
    self._pressDelay = 0
    FGlobal_AutoQuestBlackSpiritMessage(PAGetString(Defines.StringSheet_GAME, "LUA_BLACKSPIRIT_POSSESS_DIE"))
  end
end
function AutoState_Dead:endProc()
end

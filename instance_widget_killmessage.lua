local _panel = Instance_Widget_KillMessage
local killMessage = {
  _ui = {
    msg = UI.getChildControl(_panel, "StaticText_KillText")
  },
  _killCount = 0,
  _updateTime = 0,
  _durationTime = 4
}
function killMessage:showAni()
  local moveAni = _panel:addMoveAnimation(0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  moveAni:SetStartPosition(getScreenSizeX() / 2 + _panel:GetSizeX(), getScreenSizeY() / 2 - 100)
  moveAni:SetEndPosition(getScreenSizeX() / 2 - _panel:GetSizeX() - 30, getScreenSizeY() / 2 - 100)
  moveAni.IsChangeChild = true
  _panel:CalcUIAniPos(moveAni)
  local coloreAni = _panel:addColorAnimation(0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  coloreAni:SetStartColor(Defines.Color.C_00FFFFFF)
  coloreAni:SetEndColor(Defines.Color.C_FFFFFFFF)
  coloreAni.IsChangeChild = true
end
function killMessage:hideAni()
  local moveAni = _panel:addMoveAnimation(0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  moveAni:SetStartPosition(_panel:GetPosX(), getScreenSizeY() / 2 - 100)
  moveAni:SetEndPosition(getScreenSizeX() / 2 - _panel:GetSizeX() * 2.2, getScreenSizeY() / 2 - 100)
  moveAni.IsChangeChild = true
  _panel:CalcUIAniPos(moveAni)
  local coloreAni = _panel:addColorAnimation(0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  coloreAni:SetStartColor(Defines.Color.C_FFFFFFFF)
  coloreAni:SetEndColor(Defines.Color.C_00FFFFFF)
  coloreAni.IsChangeChild = true
  coloreAni:SetHideAtEnd(true)
end
function PaGlobal_KillMsgUpdate(deltaTime)
  local self = killMessage
  self._updateTime = self._updateTime + deltaTime
  if self._durationTime < self._updateTime then
    self._updateTime = 0
    _panel:ClearUpdateLuaFunc()
    self:hideAni()
  end
end
function killMessage:update()
  self._updateTime = 0
  self:showAni()
  self._ui.msg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INSTANCE_WIDGET_KILLMESSAGE_COUNT", "count", self._killCount))
  _panel:RegisterUpdateFunc("PaGlobal_KillMsgUpdate")
end
function killMessage:open()
  _panel:SetShow(true)
  audioPostEvent_SystemUi(0, 1)
  self:update()
end
function FromClient_killMessage_Init()
  local self = killMessage
end
function PaGlobal_KillMessage(killCount)
  local self = killMessage
  self._killCount = killCount
  self:open()
end
function testkill()
  PaGlobal_KillMessage(5)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_killMessage_Init")

local _panel = Panel_Widget_ItemProgress
local itemProgress = {
  _ui = {
    closeBtn = UI.getChildControl(_panel, "Button_Win_Close"),
    msg = UI.getChildControl(_panel, "StaticText_Purpose"),
    progress = UI.getChildControl(_panel, "Progress2_Challenge"),
    state = UI.getChildControl(_panel, "StaticText_Count")
  },
  _currentCount = 0,
  _maxCount = 50,
  _time = 0
}
function itemProgress:update()
  self._ui.msg:SetText("\237\143\172\234\177\180\236\161\177 50\235\167\136\235\166\172 \236\178\152\236\185\152")
  self._currentCount = math.min(self._currentCount + 1, self._maxCount)
  if self._maxCount == self._currentCount then
    self._ui.state:SetText("\236\153\132\235\163\140")
  else
    self._ui.state:SetText(self._currentCount .. " / " .. self._maxCount)
  end
  self._ui.progress:SetProgressRate(self._currentCount / self._maxCount * 100)
end
function itemProgress:showAni()
  local MoveAni = _panel:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  MoveAni:SetStartPosition(Panel_Radar:GetPosX() - _panel:GetSizeX() - 50, _panel:GetSizeY() * -1)
  MoveAni:SetEndPosition(Panel_Radar:GetPosX() - _panel:GetSizeX() - 50, 70)
  MoveAni:SetDisableWhileAni(true)
  _panel:SetShow(true)
end
function itemProgress:hideAni()
  local MoveAni = _panel:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MoveAni:SetStartPosition(_panel:GetPosX(), _panel:GetPosY())
  MoveAni:SetEndPosition(_panel:GetSizeX() * -1, _panel:GetPosY())
  MoveAni:SetHideAtEnd(true)
  MoveAni:SetDisableWhileAni(true)
end
function itemProgress:open()
  self:update()
  if not _panel:GetShow() then
    self:showAni()
  else
    self._time = 0
  end
end
function itemProgress:close()
  _panel:SetShow(false)
end
function FromClient_ItemProgress_UpdatePerFrame(deltaTime)
  local self = itemProgress
  self._time = self._time + deltaTime
  if self._time > 10 then
    self._time = 0
  end
end
function itemProgress:registerEvent()
  self._ui.closeBtn:addInputEvent("Mouse_LUp", "itemProgress:close()")
  _panel:RegisterUpdateFunc("FromClient_ItemProgress_UpdatePerFrame")
end
function FromClient_ItemProgress_Init()
  local self = itemProgress
  self:registerEvent()
end
function testItemProgress()
  itemProgress:open()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_ItemProgress_Init")

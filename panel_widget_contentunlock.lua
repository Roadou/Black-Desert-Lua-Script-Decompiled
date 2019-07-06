local _panel = Panel_Widget_ContentUnlock
local contentUnlock = {
  _ui = {
    bg = UI.getChildControl(_panel, "Static_AlertMessageBg"),
    title = UI.getChildControl(_panel, "StaticText_ContentTitle"),
    desc = UI.getChildControl(_panel, "StaticText_ContentDesc"),
    iconBG = UI.getChildControl(_panel, "Static_TypeIconBg")
  },
  _currentCount = 0,
  _maxCount = 0,
  _time = 0,
  _currentQuestNo = nil
}
function contentUnlock:update(titleStr, descStr)
end
function contentUnlock:showAni()
  local MoveAni1 = _panel:addMoveAnimation(0, 1, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MoveAni1:SetStartPosition(_panel:GetPosX(), _panel:GetSizeY() * -1)
  MoveAni1:SetEndPosition(_panel:GetPosX(), getScreenSizeY() / 6)
  MoveAni1:SetDisableWhileAni(true)
  _panel:SetShow(true)
end
function contentUnlock:hideAni()
  local MoveAni1 = _panel:addMoveAnimation(0, 0.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MoveAni1:SetStartPosition(_panel:GetPosX(), _panel:GetPosY())
  MoveAni1:SetEndPosition(_panel:GetPosX(), _panel:GetSizeY() * -1)
  MoveAni1:SetDisableWhileAni(true)
  MoveAni1:SetHideAtEnd(true)
  TooltipSimple_Hide()
end
function contentUnlock:open(titleStr, descStr)
  self:update(titleStr, descStr)
  if not _panel:GetShow() then
    self:showAni()
  else
    self._time = 0
  end
end
function contentUnlock:close()
  self:hideAni()
end
local isEffect = true
function FromClient_ContentUnlock_UpdatePerFrame(deltaTime)
  local self = contentUnlock
  self._time = self._time + deltaTime
  if self._time > 10 then
    self:hideAni()
    self._time = 0
    isEffect = true
  elseif self._time > 1 and isEffect then
    self._ui.title:AddEffect("UI_QustAccept01", false, 100, 0)
    self._ui.desc:AddEffect("UI_QustAccept01", false, 100, 0)
    isEffect = false
  end
end
function contentUnlock:init()
  self:registEventHandler()
  self._ui.icon = UI.getChildControl(self._ui.iconBG, "Static_Icon")
end
function contentUnlock:registEventHandler()
  _panel:RegisterUpdateFunc("FromClient_ContentUnlock_UpdatePerFrame")
end
function FromClient_ContentUnlock_Init()
  local self = contentUnlock
  self:init()
end
function testContentUnlock(questNoRaw)
  local self = contentUnlock
  self:open("test", "desc")
end
registerEvent("FromClient_luaLoadComplete", "FromClient_ContentUnlock_Init")

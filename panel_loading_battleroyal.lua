local _panel = Panel_Loading
local battleRoyalTipString = {
  [0] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_TIP_1"),
  [1] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_TIP_2"),
  [2] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_TIP_3"),
  [3] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_TIP_4"),
  [4] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_TIP_5"),
  [5] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_TIP_6"),
  [6] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_TIP_7"),
  [7] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_KEY_1"),
  [8] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_KEY_2"),
  [9] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_KEY_3"),
  [10] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_KEY_4"),
  [11] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_KEY_5"),
  [12] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_KEY_6"),
  [13] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_KEY_7"),
  [14] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_KEY_8"),
  [15] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_KEY_9"),
  [16] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_KEY_10")
}
local battleRoyalLoading = {
  _ui = {
    txt_BattleRoyalTitle = UI.getChildControl(Panel_Loading, "StaticText_BattleRoyal_Title"),
    txt_BattleRoyalTip = UI.getChildControl(Panel_Loading, "StaticText_BattleRoyal_Guide")
  },
  _maxCount = 17
}
function battleRoyalLoading:init()
  _panel:SetShow(true, false)
  self._originalTipSizeY = self._ui.txt_BattleRoyalTip:GetSizeY()
  self._ui.txt_BattleRoyalTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_BATTLEROYAL"))
  self._ui.txt_BattleRoyalTip:SetAutoResize(true)
  local randomTip = math.random(0, self._maxCount - 1)
  self._ui.txt_BattleRoyalTip:SetText(tostring(battleRoyalTipString[randomTip]))
  self:resizePanel()
  self:registEventHandler()
end
function battleRoyalLoading:resizePanel()
  local screenX, screenY
  screenX = getScreenSizeX()
  screenY = getScreenSizeY()
  _panel:SetSize(screenX, screenY)
  self._ui.txt_BattleRoyalTip:SetSize(screenX * 0.4, self._ui.txt_BattleRoyalTip:GetSizeY())
  self._ui.txt_BattleRoyalTip:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  if self._originalTipSizeY < self._ui.txt_BattleRoyalTip:GetSizeY() then
    local resizeY = self._ui.txt_BattleRoyalTip:GetSizeY() - self._originalTipSizeY
    self._ui.txt_BattleRoyalTitle:SetSpanSize(self._ui.txt_BattleRoyalTitle:GetSpanSize().x, self._ui.txt_BattleRoyalTitle:GetSpanSize().y + resizeY)
  end
  self._ui.txt_BattleRoyalTitle:ComputePos()
  self._ui.txt_BattleRoyalTip:ComputePos()
end
function battleRoyalLoading:registEventHandler()
end
local updateTime = 0
local isScope = false
function LoadingPanel_UpdatePerFrame(deltaTime)
end
function PaGlobalFunc_battleRoyalLoading_Init()
  local self = battleRoyalLoading
  if nil == self then
    return
  end
  self:init()
end
registerEvent("FromClient_luaLoadCompleteLateUdpate", "PaGlobalFunc_battleRoyalLoading_Init")

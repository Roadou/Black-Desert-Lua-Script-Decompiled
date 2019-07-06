local _panel = Panel_Window_KeyGuide
local KeyGuideWindow = {
  _ui = {
    radio_tabs = {
      [0] = UI.getChildControl(_panel, "RadioButton_NormalTab"),
      [1] = UI.getChildControl(_panel, "RadioButton_CombatTab")
    },
    stc_LBConsoleUI = UI.getChildControl(_panel, "Static_KeyGuideLB"),
    stc_RBConsoleUI = UI.getChildControl(_panel, "Static_KeyGuideRB"),
    stc_GamePadFrame = UI.getChildControl(_panel, "Static_GamePad")
  },
  _keyGuideType = {normal = 0, count = 1},
  _keyGuideControl = {},
  _currentType = 0
}
function KeyGuideWindow:initialize()
  self._ui.stc_LBConsoleUI:SetShow(false)
  self._ui.stc_RBConsoleUI:SetShow(false)
  self._ui.radio_tabs[0]:SetShow(false)
  self._ui.radio_tabs[1]:SetShow(false)
  self._keyGuideControl[0] = self:setGuideControl(__eJoyPadInputType_LeftTrigger, UI.getChildControl(self._ui.stc_GamePadFrame, "StaticText_KeyGuideLT"))
  self._keyGuideControl[1] = self:setGuideControl(__eJoyPadInputType_LeftShoulder, UI.getChildControl(self._ui.stc_GamePadFrame, "StaticText_KeyGuideLB"))
  self._keyGuideControl[2] = self:setGuideControl(__eJoyPadInputType_RightTrigger, UI.getChildControl(self._ui.stc_GamePadFrame, "StaticText_KeyGuideRT"))
  self._keyGuideControl[3] = self:setGuideControl(__eJoyPadInputType_RightShoulder, UI.getChildControl(self._ui.stc_GamePadFrame, "StaticText_KeyGuideRB"))
  self._keyGuideControl[4] = self:setGuideControl(__eJoyPadInputType_A, UI.getChildControl(self._ui.stc_GamePadFrame, "StaticText_KeyGuideA"))
  self._keyGuideControl[5] = self:setGuideControl(__eJoyPadInputType_B, UI.getChildControl(self._ui.stc_GamePadFrame, "StaticText_KeyGuideB"))
  self._keyGuideControl[6] = self:setGuideControl(__eJoyPadInputType_X, UI.getChildControl(self._ui.stc_GamePadFrame, "StaticText_KeyGuideX"))
  self._keyGuideControl[7] = self:setGuideControl(__eJoyPadInputType_Y, UI.getChildControl(self._ui.stc_GamePadFrame, "StaticText_KeyGuideY"))
end
function KeyGuideWindow:update(guideType)
  for _, controlGroup in pairs(self._keyGuideControl) do
    controlGroup.control:SetText(PaGlobalFunc_ConsoleKeyGuide_ConvertActionTypeToString(controlGroup.joyPadType))
  end
end
function KeyGuideWindow:setGuideControl(padType, control)
  local controlGroup = {}
  controlGroup.joyPadType = padType
  controlGroup.control = control
  return controlGroup
end
function KeyGuideWindow:open()
  self._currentType = 0
  self:update(self._currentType)
  _panel:SetShow(true)
end
function KeyGuideWindow:close()
  _panel:SetShow(false)
end
function PaGlobalFunc_KeyGuidWindow_Open()
  KeyGuideWindow:open()
end
function PaGlobalFunc_KeyGuidWindow_Close()
  KeyGuideWindow:close()
end
function Input_KeyGuideWindow_NextTab(changeVal)
  local self = KeyGuideWindow
  self._currentType = self._currentType + changeVal
  if self._currentType < 0 then
    self._currentType = self._keyGuideType.count - 1
  elseif self._keyGuideType.count <= self._currentType then
    self._currentType = 0
  end
  self:update(self._currentType)
end
function FromClient_KeyGuideWindow_Init()
  local self = KeyGuideWindow
  self:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_KeyGuideWindow_Init")

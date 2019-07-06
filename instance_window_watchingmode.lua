local _panel = Instance_Window_WatchingMode
local InstanceWatchMode = {
  _ui = {
    UI_BG = UI.getChildControl(_panel, "Static_CommandBG"),
    UI_KeyQ = UI.getChildControl(_panel, "StaticText_Key_Q"),
    UI_KeyE = UI.getChildControl(_panel, "StaticText_Key_E"),
    UI_KeyR = UI.getChildControl(_panel, "StaticText_Key_R"),
    UI_TextSmall = UI.getChildControl(_panel, "StaticText_Small"),
    UI_TextBig = UI.getChildControl(_panel, "StaticText_Big"),
    UI_TextExit = UI.getChildControl(_panel, "StaticText_Exit"),
    UI_TextDesc = UI.getChildControl(_panel, "StaticText_CameraSpeedLow"),
    UI_ShowButton = UI.getChildControl(_panel, "Button_ShowCommand"),
    UI_RemainTime = UI.getChildControl(_panel, "StaticText_RemainTime"),
    _isSeigeWatching = false,
    _remainTime = -1
  }
}
function InstanceWatchMode:initialize()
  self:SetControlShow(false)
  self:registEventHandler()
end
function InstanceWatchMode:registEventHandler()
  registerEvent("onScreenResize", "FromClient_temp_ScreenResize")
end
function InstanceWatchMode:SetControlShow(isShow)
  self._ui.UI_BG:SetShow(isShow)
  self._ui.UI_KeyQ:SetShow(isShow)
  self._ui.UI_KeyE:SetShow(isShow)
  self._ui.UI_KeyR:SetShow(isShow)
  self._ui.UI_TextSmall:SetShow(isShow)
  self._ui.UI_TextBig:SetShow(isShow)
  self._ui.UI_TextExit:SetShow(isShow)
  self._ui.UI_TextDesc:SetShow(isShow)
  self._ui.UI_ShowButton:SetShow(isShow)
end
function InstanceWatchMode:resize()
end
function FromClient_InstanceWatchMode_Init()
  local self = InstanceWatchMode
  self:initialize()
end
function FromClient_InstanceWatchMode_ScreenResize()
  local self = InstanceWatchMode
  self:resize()
end
function PaGlobalFunc_InstanceWatchMode_SetControlShow(isShow)
  local self = InstanceWatchMode
  _panel:SetShow(isShow)
  self:SetControlShow(isShow)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_InstanceWatchMode_Init")

local Panel_Window_LocalWarRule_info = {
  _ui = {
    staticText_Tap_Group = nil,
    radioButton_Rule = nil,
    radioButton_Reward = nil,
    static_SubFrameBG = nil,
    staticText_Desc = nil
  },
  _value = {currentTabIndex = 0},
  _config = {
    tabCount = 2,
    ruleCount = 12,
    rewardCount = 3
  },
  _tabEnum = {eTAB_RULE = 0, eTAB_REWARD = 1},
  _tabSlot = {}
}
function Panel_Window_LocalWarRule_info:registEventHandler()
  Panel_LocalWarRule:registerPadEvent(__eConsoleUIPadEvent_LT, "PaGlobalFunc_LocalWarRule_forPadEventFunc(-1)")
  Panel_LocalWarRule:registerPadEvent(__eConsoleUIPadEvent_RT, "PaGlobalFunc_LocalWarRule_forPadEventFunc(1)")
end
function Panel_Window_LocalWarRule_info:registerMessageHandler()
  PaGlobal_registerPanelOnBlackBackground(Panel_LocalWarRule)
  registerEvent("onScreenResize", "FromClient_LocalWarRule_Resize")
end
function Panel_Window_LocalWarRule_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_LocalWarRule_info:setText()
  self._ui.staticText_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.staticText_Desc:SetText()
end
function Panel_Window_LocalWarRule_info:initValue()
  self._ui.currentTabIndex = 0
end
function Panel_Window_LocalWarRule_info:resize()
end
function Panel_Window_LocalWarRule_info:childControl()
  self._ui.staticText_Tap_Group = UI.getChildControl(Panel_LocalWarRule, "StaticText_Tap_Group")
  self._ui.radioButton_Rule = UI.getChildControl(self._ui.staticText_Tap_Group, "RadioButton_Rule")
  self._ui.radioButton_Reward = UI.getChildControl(self._ui.staticText_Tap_Group, "RadioButton_Reward")
  self._tabSlot[self._tabEnum.eTAB_RULE] = self._ui.radioButton_Rule
  self._tabSlot[self._tabEnum.eTAB_REWARD] = self._ui.radioButton_Reward
  self._ui.static_SubFrameBG = UI.getChildControl(Panel_LocalWarRule, "Static_SubFrameBG")
  self._ui.staticText_Desc = UI.getChildControl(self._ui.static_SubFrameBG, "StaticText_Desc")
end
function Panel_Window_LocalWarRule_info:clearTab()
  self._tabSlot[self._tabEnum.eTAB_RULE]:SetCheck(false)
  self._tabSlot[self._tabEnum.eTAB_REWARD]:SetCheck(false)
  self._tabSlot[self._tabEnum.eTAB_RULE]:SetFontColor(Defines.Color.C_FF525B6D)
  self._tabSlot[self._tabEnum.eTAB_REWARD]:SetFontColor(Defines.Color.C_FF525B6D)
end
function Panel_Window_LocalWarRule_info:setTab()
  self:clearTab()
  if nil ~= self._tabSlot[self._value.currentTabIndex] then
    self._tabSlot[self._value.currentTabIndex]:SetCheck(true)
    self._tabSlot[self._value.currentTabIndex]:SetFontColor(Defines.Color.C_FFEEEEEE)
  end
end
function Panel_Window_LocalWarRule_info:setContent()
  self:setTab()
  self._ui.staticText_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  if self._value.currentTabIndex == self._tabEnum.eTAB_RULE then
    local text = ""
    for index = 1, self._config.ruleCount do
      text = text .. PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_" .. index) .. "\n"
    end
    self._ui.staticText_Desc:SetText(text)
  elseif self._value.currentTabIndex == self._tabEnum.eTAB_REWARD then
    local text = ""
    for index = 1, self._config.rewardCount do
      text = text .. PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_REWARD_" .. index) .. "\n"
    end
    self._ui.staticText_Desc:SetText(text)
  end
end
function Panel_Window_LocalWarRule_info:open()
  Panel_LocalWarRule:SetShow(true)
end
function Panel_Window_LocalWarRule_info:close()
  Panel_LocalWarRule:SetShow(false)
end
function PaGlobalFunc_LocalWarRule_GetShow()
  Panel_LocalWarRule:GetShow()
end
function PaGlobalFunc_LocalWarRule_Open()
  local self = Panel_Window_LocalWarRule_info
  self:open()
end
function PaGlobalFunc_LocalWarRule_Close()
  local self = Panel_Window_LocalWarRule_info
  self:close()
end
function PaGlobalFunc_LocalWarRule_Show()
  local self = Panel_Window_LocalWarRule_info
  self:initValue()
  self:open()
  self:setContent()
end
function PaGlobalFunc_LocalWarRule_forPadEventFunc(value)
  local self = Panel_Window_LocalWarRule_info
  local newIndex = (self._value.currentTabIndex + self._config.tabCount + value) % self._config.tabCount
  self._value.currentTabIndex = newIndex
  self:setContent()
end
function FromClient_LocalWarRule_Init()
  local self = Panel_Window_LocalWarRule_info
  self:initialize()
end
function FromClient_LocalWarRule_Resize()
  local self = Panel_Window_LocalWarRule_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_LocalWarRule_Init")

PaGlobal_UIKeyguide = {
  _ui = {
    stc_A_Keyguide = nil,
    stc_X_Keyguide = nil,
    stc_Y_Keyguide = nil,
    stc_B_Keyguide = nil
  },
  _keyGuideList = {},
  _currentKeyguidetypeList = {},
  _currentTargetPanel = nil,
  _currentTargetGuideBg = nil
}
runLua("UI_Data/Script/Widget/ConsoleKeyGuide/UIKeyGuide/Panel_WidgetUIKeyguide_1.lua")
runLua("UI_Data/Script/Widget/ConsoleKeyGuide/UIKeyGuide/Panel_WidgetUIKeyguide_2.lua")
function PaGlobal_UIKeyguide_Init()
  PaGlobal_UIKeyguide:init()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_UIKeyguide_Init")

function PaGlobal_UIKeyguide:init()
  PaGlobal_UIKeyguide._currentKeyguidetypeList = {
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false
  }
  PaGlobal_UIKeyguide._ui.stc_A_Keyguide = UI.getChildControl(Panel_WidgetUIKeyguide, "Button_A_ConsoleUI")
  PaGlobal_UIKeyguide._ui.stc_Y_Keyguide = UI.getChildControl(Panel_WidgetUIKeyguide, "Button_Y_ConsoleUI")
  PaGlobal_UIKeyguide._ui.stc_X_Keyguide = UI.getChildControl(Panel_WidgetUIKeyguide, "Button_X_ConsoleUI")
  PaGlobal_UIKeyguide._ui.stc_B_Keyguide = UI.getChildControl(Panel_WidgetUIKeyguide, "Button_B_ConsoleUI")
  PaGlobal_UIKeyguide._keyGuideList[1] = PaGlobal_UIKeyguide._ui.stc_A_Keyguide
  PaGlobal_UIKeyguide._keyGuideList[2] = PaGlobal_UIKeyguide._ui.stc_Y_Keyguide
  PaGlobal_UIKeyguide._keyGuideList[3] = PaGlobal_UIKeyguide._ui.stc_X_Keyguide
  PaGlobal_UIKeyguide._keyGuideList[4] = PaGlobal_UIKeyguide._ui.stc_B_Keyguide
  PaGlobal_UIKeyguide:registerEventHandler()
end
function PaGlobal_UIKeyguide:registerEventHandler()
  registerEvent("FromClient_PadSnapChangePanel", "FromClient_UIKeyguide_PadSnapChangePanel")
  registerEvent("FromClient_PadSnapChangeTarget", "FromClient_UIKeyguide_PadSnapChangeTarget")
  registerEvent("FromClient_ChangePadKeyGuide", "FromClient_UIKeyguide_ChangePadKeyGuide")
  registerEvent("FromClient_PushPadKeyGuideEnd", "FromClient_UIKeyguide_PushPadKeyGuideEnd")
end

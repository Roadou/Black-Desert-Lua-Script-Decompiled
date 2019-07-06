local UI_TM = CppEnums.TextMode
PaGlobal_Guild_ChoiseTheMoney = {
  _ui = {
    _btn_XClose = UI.getChildControl(Panel_Guild_ChoiseTheMoney, "Button_Close"),
    _btn_Incentive = UI.getChildControl(Panel_Guild_ChoiseTheMoney, "Button_GoToIncenList"),
    _btn_Funds = UI.getChildControl(Panel_Guild_ChoiseTheMoney, "Button_GoToFundsList")
  }
}
function PaGlobal_Guild_ChoiseTheMoney:Init()
  self._ui._btn_XClose:addInputEvent("Mouse_LUp", "PaGlobal_Guild_ChoiseTheMoney:LClickEvent(0)")
  self._ui._btn_Incentive:addInputEvent("Mouse_LUp", "PaGlobal_Guild_ChoiseTheMoney:LClickEvent(1)")
  self._ui._btn_Funds:addInputEvent("Mouse_LUp", "PaGlobal_Guild_ChoiseTheMoney:LClickEvent(2)")
end
function PaGlobal_Guild_ChoiseTheMoney:Open()
  Panel_Guild_ChoiseTheMoney:SetShow(true)
end
function PaGlobal_Guild_ChoiseTheMoney:Hide()
  Panel_Guild_ChoiseTheMoney:SetShow(false)
end
function PaGlobal_Guild_ChoiseTheMoney:LClickEvent(clickType)
  if nil == clickType then
    return
  end
  if 0 == clickType then
    PaGlobal_Guild_ChoiseTheMoney:Hide()
  elseif 1 == clickType then
    HandleCLicked_IncentiveOption()
    PaGlobal_Guild_ChoiseTheMoney:Hide()
  elseif 2 == clickType then
    PaGlobal_Guild_SetFundsList_Open()
    PaGlobal_Guild_ChoiseTheMoney:Hide()
  end
end
PaGlobal_Guild_ChoiseTheMoney:Init()

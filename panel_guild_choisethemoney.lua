local UI_TM = CppEnums.TextMode
PaGlobal_Guild_ChoiseTheMoney = {
  _ui = {
    _btn_XClose = nil,
    _btn_Incentive = nil,
    _btn_Funds = nil
  }
}
function PaGlobal_Guild_ChoiseTheMoney:Init()
  if nil == Panel_Guild_ChoiseTheMoney then
    return
  end
  self._ui._btn_XClose = UI.getChildControl(Panel_Guild_ChoiseTheMoney, "Button_Close")
  self._ui._btn_Incentive = UI.getChildControl(Panel_Guild_ChoiseTheMoney, "Button_GoToIncenList")
  self._ui._btn_Funds = UI.getChildControl(Panel_Guild_ChoiseTheMoney, "Button_GoToFundsList")
  PaGlobal_Guild_ChoiseTheMoney:registEventHandler()
end
function PaGlobal_Guild_ChoiseTheMoney:registEventHandler()
  if nil == Panel_Guild_ChoiseTheMoney then
    return
  end
  Panel_Guild_ChoiseTheMoney:RegisterCloseLuaFunc(PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Escape
  }), "PaGlobal_Guild_ChoiseTheMoney:Hide()")
  self._ui._btn_XClose:addInputEvent("Mouse_LUp", "PaGlobal_Guild_ChoiseTheMoney:LClickEvent(0)")
  self._ui._btn_Incentive:addInputEvent("Mouse_LUp", "PaGlobal_Guild_ChoiseTheMoney:LClickEvent(1)")
  self._ui._btn_Funds:addInputEvent("Mouse_LUp", "PaGlobal_Guild_ChoiseTheMoney:LClickEvent(2)")
end
function PaGlobal_Guild_ChoiseTheMoney:Open()
  PaGlobal_GuildChoiseTheMoney_CheckLoadUI()
end
function PaGlobal_Guild_ChoiseTheMoney:Hide()
  PaGlobal_GuildChoiseTheMoney_CheckCloseUI()
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
function PaGlobal_GuildChoiseTheMoney_CheckLoadUI()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_ChoiseTheMoney:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_Guild_ChoiseTheMoney.XML", "Panel_Guild_ChoiseTheMoney", Defines.UIGroup.PAGameUIGroup_Window_Progress, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_Guild_ChoiseTheMoney = rv
    rv = nil
    PaGlobal_Guild_ChoiseTheMoney:Init()
  end
  Panel_Guild_ChoiseTheMoney:SetShow(true)
end
function PaGlobal_GuildChoiseTheMoney_CheckCloseUI()
  if false == PaGlobal_GuildChoiseTheMoney_GetShow() then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_ChoiseTheMoney:SetShow(false)
  else
    reqCloseUI(Panel_Guild_ChoiseTheMoney)
  end
end
function PaGlobal_GuildChoiseTheMoney_GetShow()
  if nil == Panel_Guild_ChoiseTheMoney then
    return false
  end
  return Panel_Guild_ChoiseTheMoney:GetShow()
end
function FromClient_GuildChoiseTheMoney_Init()
  PaGlobal_Guild_ChoiseTheMoney:Init()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildChoiseTheMoney_Init")

local _btn_VillageSiegeArea = FGlobal_GetPersonalIconControl(4)
_btn_VillageSiegeArea:ActiveMouseEventEffect(true)
if false == _ContentsGroup_RenewUI_Main then
  _btn_VillageSiegeArea:setGlassBackground(true)
end
local showSiegeArea = false
ToClient_toggleVillageSiegeArea(showSiegeArea)
function ToggleVillageSiegeArea(isShow)
  if false == isShow then
    showSiegeArea = not showSiegeArea
  else
    showSiegeArea = isShow
  end
  _btn_VillageSiegeArea:EraseAllEffect()
  if showSiegeArea then
    _btn_VillageSiegeArea:AddEffect("UI_VillageSiegeArea_01A", true, 0, 0)
  end
  ToClient_toggleVillageSiegeArea(showSiegeArea)
end
function VillageSiegeArea_Tooltip_ShowToggle(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGESEIGE_AREABUTTON")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGESEIGE_AREABUTTON_DESC")
  TooltipSimple_Show(_btn_VillageSiegeArea, name, desc)
end

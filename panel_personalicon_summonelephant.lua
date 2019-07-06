local _btn_SummonElephant = FGlobal_GetPersonalIconControl(8)
local elephantActorKey
function SummonElephant()
  if nil == elephantActorKey then
    return
  end
  ToClient_RequestSummonElephantFromSiegeBuilding(elephantActorKey)
end
function Panel_SummonElephant_Close()
  _btn_SummonElephant:SetShow(false)
  elephantActorKey = nil
  FGlobal_PersonalIcon_ButtonPosUpdate()
end
function FromClient_ShowElephantBarn(actorKeyRaw)
  _btn_SummonElephant:SetShow(true)
  FGlobal_PersonalIcon_ButtonPosUpdate()
  elephantActorKey = actorKeyRaw
  FGlobal_PersonalIcon_ButtonPosUpdate()
end
function FromClient_HideElephantBarn(actorKeyRaw)
  Panel_SummonElephant_Close()
end
function SummonElephant_Tooltip_ShowToggle(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONELEPHANT_TOOLTIP_TITLE")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONELEPHANT_TOOLTIP_DESC")
  TooltipSimple_Show(_btn_SummonElephant, name, desc)
end
registerEvent("FromClient_ShowElephantBarn", "FromClient_ShowElephantBarn")
registerEvent("FromClient_HideElephantBarn", "FromClient_HideElephantBarn")

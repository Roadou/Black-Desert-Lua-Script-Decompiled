local _btn_SummonParty = FGlobal_GetPersonalIconControl(9)
function Click_SummonParty()
  local remainTime_s64 = ToClient_GetLeftUsableTeleportCompassTime()
  local remainTime = Int64toInt32(remainTime_s64)
  if remainTime > 0 then
    if IsSelfPlayerWaitAction() then
      ToClient_RequestTeleportPosUseCompass()
    else
      Proc_ShowMessage_Ack("\235\140\128\234\184\176 \236\131\129\237\131\156\236\151\144\236\132\156\235\167\140 \236\157\180\236\154\169\237\149\160 \236\136\152 \236\158\136\236\138\181\235\139\136\235\139\164.")
    end
  end
end
local partyName = ""
function SummonParty_ToolTip(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local partyActorKey = ToClient_GetCharacterActorKeyRawUseCompass()
  local playerActorKey = getSelfPlayer():getActorKey()
  local descStr = ""
  local usableTime64 = ToClient_GetLeftUsableTeleportCompassTime()
  if partyActorKey == playerActorKey then
    descStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPASS_DESC_1", "remainTime", convertStringFromDatetime(usableTime64))
  else
    descStr = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_COMPASS_DESC_2", "partyName", partyName, "partyName1", partyName, "remainTime", convertStringFromDatetime(usableTime64))
  end
  local name, desc, uiControl = PAGetString(Defines.StringSheet_GAME, "LUA_COMPASS_NAME"), descStr, _btn_SummonParty
  registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
  TooltipSimple_Show(uiControl, name, desc)
end
function Panel_SummonParty_Open()
  local remainTime_s64 = ToClient_GetLeftUsableTeleportCompassTime()
  local remainTime = Int64toInt32(remainTime_s64)
  local partyActorKey = ToClient_GetCharacterActorKeyRawUseCompass()
  local playerActorKey = getSelfPlayer():getActorKey()
  if partyActorKey ~= playerActorKey then
    if remainTime > 0 then
      FGlobal_PersonalIcon_ButtonPosUpdate()
      _btn_SummonParty:SetShow(true)
      _btn_SummonParty:EraseAllEffect()
      _btn_SummonParty:AddEffect("fUI_Buster_Call01", true, 0, 0)
    else
      Panel_SummonParty_Close()
    end
  end
end
function Panel_SummonParty_Close()
  if _btn_SummonParty:GetShow() then
    _btn_SummonParty:EraseAllEffect()
    _btn_SummonParty:SetShow(false)
  end
end
local summonPartyCheck = function()
  local leftTime = Int64toInt32(ToClient_GetLeftUsableTeleportCompassTime())
  if leftTime > 0 then
    local partyActorKey = ToClient_GetCharacterActorKeyRawUseCompass()
    local playerActorKey = getSelfPlayer():getActorKey()
    if partyActorKey ~= playerActorKey then
      if 0 < RequestParty_getPartyMemberCount() then
        Panel_SummonParty_Open()
      else
        Panel_SummonParty_Close()
      end
    else
      Panel_SummonParty_Close()
    end
  else
    Panel_SummonParty_Close()
  end
end
summonPartyCheck()
function FGlobal_SummonPartyCheck()
  summonPartyCheck()
end
function FromClient_ResponseUseCompass()
  Panel_SummonParty_Open()
  partyName = ""
  partyName = ToClient_GetCharacterNameUseCompass()
  local partyActorKey = ToClient_GetCharacterActorKeyRawUseCompass()
  local playerActorKey = getSelfPlayer():getActorKey()
  local msg = ""
  if partyActorKey == playerActorKey then
    msg = PAGetString(Defines.StringSheet_GAME, "LUA_COMPASS_MESSAGE_1")
  else
    msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPASS_MESSAGE_2", "partyName", partyName)
  end
  Proc_ShowMessage_Ack(msg)
  FGlobal_PersonalIcon_ButtonPosUpdate()
end
registerEvent("FromClient_ResponseUseCompass", "FromClient_ResponseUseCompass")

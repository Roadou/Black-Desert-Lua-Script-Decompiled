local _btn_ReturnStone = FGlobal_GetPersonalIconControl(7)
function Click_ReturnStone()
  local remainTime_s64 = ToClient_GetLeftReturnStoneTime()
  local remainTime = Int64toInt32(remainTime_s64)
  local returnPos3D = ToClient_GetPosUseReturnStone()
  local regionInfo = getRegionInfoByPosition(returnPos3D)
  if remainTime > 0 then
    if IsSelfPlayerWaitAction() then
      ToClient_RequestTeleportPosUseReturnStone()
    else
      Proc_ShowMessage_Ack("\235\140\128\234\184\176 \236\131\129\237\131\156\236\151\144\236\132\156\235\167\140 \236\157\180\236\154\169\237\149\160 \236\136\152 \236\158\136\236\138\181\235\139\136\235\139\164.")
    end
  end
end
function ReturnStone_ToolTip(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local returnPos3D = ToClient_GetPosUseReturnStone()
  local regionInfo = getRegionInfoByPosition(returnPos3D)
  local regionName = ""
  if nil ~= regionInfo then
    regionName = regionInfo:getAreaName()
  end
  local returnTownRegionKey = ToClient_GetReturnStoneTownRegionKey()
  local usableTime64 = ToClient_GetLeftReturnStoneTime()
  local descStr = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_RETURNSTONE_DESC", "regionName", regionName, "remainTime", convertStringFromDatetime(usableTime64))
  local name, desc, uiControl = PAGetString(Defines.StringSheet_GAME, "LUA_RETURNSTONE_NAME"), descStr, _btn_ReturnStone
  registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
  TooltipSimple_Show(uiControl, name, desc)
end
function Panel_ReturnStone_Open()
  local remainTime_s64 = ToClient_GetLeftReturnStoneTime()
  local remainTime = Int64toInt32(remainTime_s64)
  if remainTime > 0 then
    _btn_ReturnStone:SetShow(true)
    FGlobal_PersonalIcon_ButtonPosUpdate()
    _btn_ReturnStone:EraseAllEffect()
    _btn_ReturnStone:AddEffect("fUI_Buster_Call01", true, 0, 0)
  else
    Panel_ReturnStone_Close()
  end
end
function Panel_ReturnStone_Close()
  if _btn_ReturnStone:GetShow() then
    _btn_ReturnStone:EraseAllEffect()
    _btn_ReturnStone:SetShow(false)
  end
end
local returnStoneCheck = function()
  local leftTime = Int64toInt32(ToClient_GetLeftReturnStoneTime())
  if leftTime > 0 then
    Panel_ReturnStone_Open()
  else
    Panel_ReturnStone_Close()
  end
end
returnStoneCheck()
function FromClient_ResponseUseReturnStone()
  local pos3D = ToClient_GetPosUseReturnStone()
  ToClient_DeleteNaviGuideByGroup(0)
  worldmapNavigatorStart(pos3D, NavigationGuideParam(), false, false)
  if not _btn_ReturnStone:GetShow() then
    Panel_ReturnStone_Open()
  end
  FGlobal_PersonalIcon_ButtonPosUpdate()
end
function FGlobal_ReturnStoneCheck()
  if _btn_ReturnStone:GetShow() then
    returnStoneCheck()
  end
end
registerEvent("FromClient_ResponseUseReturnStone", "FromClient_ResponseUseReturnStone")

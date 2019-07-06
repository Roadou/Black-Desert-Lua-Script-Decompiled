local IM = CppEnums.EProcessorInputMode
local autoTrain = ToClient_IsAutoLevelUp()
local function autoTraining_Init()
  if not ToClient_IsContentsGroupOpen("57") then
    return
  end
  if autoTrain then
    ToClient_RequestSetAutoLevelUp(false)
  end
  FGlobal_PersonalIcon_ButtonPosUpdate()
end
function AutoTraining_Set()
  if Panel_Global_Manual:GetShow() then
    Proc_ShowMessage_Ack("\235\175\184\235\139\136\234\178\140\236\158\132 \236\164\145\236\151\144\235\138\148 \237\157\145\236\160\149\235\160\185\236\157\152 \236\136\152\235\160\168\236\157\132 \236\157\180\236\154\169\237\149\160 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  if nil ~= PaGlobalFunc_GachaRoulette_GetShow and true == PaGlobalFunc_GachaRoulette_GetShow() then
    Proc_ShowMessage_Ack("\235\163\176\235\160\155\236\157\180 \235\143\140\236\149\132\234\176\128\235\138\148 \236\164\145\236\151\144\235\138\148 \237\157\145\236\160\149\235\160\185\236\157\152 \236\136\152\235\160\168\236\157\132 \236\157\180\236\154\169\237\149\160 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  if Panel_EventNotify:GetShow() then
    close_WindowPanelList()
    FGlobal_NpcNavi_Hide()
    EventNotify_Close()
  end
  if Panel_ScreenShotAlbum_FullScreen:GetShow() then
    ScreenshotAlbum_FullScreen_Close()
  end
  if Panel_ScreenShotAlbum:GetShow() then
    ScreenshotAlbum_Close()
  end
  if check_ShowWindow() then
    close_WindowPanelList()
    FGlobal_NpcNavi_Hide()
  end
  if check_ShowWindow() and FGlobal_NpcNavi_IsShowCheck() then
    close_WindowPanelList()
    FGlobal_NpcNavi_Hide()
  elseif not check_ShowWindow() and FGlobal_NpcNavi_IsShowCheck() then
    FGlobal_NpcNavi_Hide()
  elseif check_ShowWindow() and not FGlobal_NpcNavi_IsShowCheck() then
    close_WindowPanelList()
  end
  local pcPosition = getSelfPlayer():get():getPosition()
  local regionInfo = getRegionInfoByPosition(pcPosition)
  if not regionInfo:get():isSafeZone() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_1"))
    return
  end
  local needExp = Int64toInt32(getSelfPlayer():get():getNeedExp_s64())
  local currentexp = Int64toInt32(getSelfPlayer():get():getExp_s64())
  local expRate = currentexp * 100 / needExp
  local e1 = 10000
  local msg = ""
  ToClient_RequestSetAutoLevelUp(not autoTrain)
end
function AutoTraining_Stop()
  autoTrain = ToClient_IsAutoLevelUp()
end
function AutoTraining_ToolTip(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local currentLevel = getSelfPlayer():get():getLevel()
  local name, desc = PAGetString(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_8"), nil
  local maxExpPercent = ToClient_GetAutoLevelUpMaxExpPercent(currentLevel) / 10000
  if autoTrain then
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_6", "percent", maxExpPercent)
  else
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_7", "percent", maxExpPercent)
  end
end
function Init_AutoTraining()
  autoTraining_Init()
end
function isAutoTraining()
  return autoTrain
end
function FromClient_SetAutoLevelUp(isAuto)
  autoTrain = isAuto
  if autoTrain then
    msg = PAGetString(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_3")
  else
    msg = PAGetString(Defines.StringSheet_GAME, "LUA_AUTOTRAINING_MESSAGE_4")
  end
  Proc_ShowMessage_Ack(msg)
end

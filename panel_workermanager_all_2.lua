function PaGlobalFunc_WorkerManager_All_Open()
  PaGlobal_WorkerManager_All:prepareOpen()
end
function PaGlobalFunc_WorkerManager_All_Close()
  if true == _ContentsGroup_isConsolePadControl then
    _AudioPostEvent_SystemUiForXBOX(50, 3)
  else
    audioPostEvent_SystemUi(1, 1)
    if Panel_Window_WorkerManager_All:IsUISubApp() then
      return
    end
    Panel_Window_WorkerManager_All:CloseUISubApp()
  end
  if nil ~= Panel_WorkerRestoreAll and Panel_WorkerRestoreAll:GetShow() then
    workerRestoreAll_Close()
  end
  PaGlobal_WorkerManager_All:prepareClose()
  FGlobal_HideWorkerTooltip()
  TooltipSimple_Hide()
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:pop()
  end
end
function HandleClicked_WorkerManager_Close()
  audioPostEvent_SystemUi(1, 1)
  Panel_Window_WorkerManager_All:CloseUISubApp()
  PaGlobal_WorkerManager_All._pcUI.btn_PopUp:SetCheck(false)
  if nil ~= Panel_WorkerRestoreAll and Panel_WorkerRestoreAll:GetShow() then
    workerRestoreAll_Close()
  end
  if nil ~= Panel_Window_WorkerManager_ChangeSkill_Renew and Panel_Window_WorkerManager_ChangeSkill_Renew:GetShow() then
    PaGlobalFunc_WorkerManager_ChangeSkill_Close()
  end
  PaGlobalFunc_WorkerManager_All_Close()
end
function PaGlobalFunc_WorkerManager_All_ShowToggle()
  if nil == Panel_Window_WorkerManager_All then
    return
  end
  if Panel_Window_WorkerManager_All:GetShow() then
    PaGlobalFunc_WorkerManager_All_Close()
    return
  end
  if Panel_Window_Inventory:GetShow() then
    InventoryWindow_Close()
  end
  PaGlobalFunc_WorkerManager_All_Open()
end
function PaGlobalFunc_WorkerManager_All_PopUp()
  if PaGlobal_WorkerManager_All._pcUI.btn_PopUp:IsCheck() then
    Panel_Window_WorkerManager_All:OpenUISubApp()
  else
    Panel_Window_WorkerManager_All:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function PaGlobalFunc_WorkerManager_All_PopUp_ShowIconToolTip(isShow)
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
    local desc = ""
    if PaGlobal_WorkerManager_All._pcUI.btn_PopUp:IsCheck() then
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_CHECK_TOOLTIP")
    else
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_NOCHECK_TOOLTIP")
    end
    TooltipSimple_Show(PaGlobal_WorkerManager_All._pcUI.btn_PopUp, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobalFunc_WorkerManager_All_ButtonSimpleToolTip(isShow, key, tipType)
  local name, desc, control
  local list = PaGlobal_WorkerManager_All._commonUI.list_Worker
  local contents = list:GetContentByKey(tonumber64(key))
  if nil == contents then
    return
  end
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_RESTORE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_RESTORE_DESC")
    control = UI.getChildControl(contents, "Button_WorkRestore")
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_REPEAT_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_REPEAT_DESC")
    control = UI.getChildControl(contents, "Button_RepeatWork")
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_STOP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_STOP_DESC")
    control = UI.getChildControl(contents, "Button_StopWork")
  else
    name = ""
    desc = ""
  end
  registTooltipControl(control, Panel_Tooltip_SimpleText)
  if isShow == true then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobalFunc_WorkerManager_All_CheckRTButton()
  PaGlobal_WorkerManager_All._RTButtonCheck = true
  Panel_Window_WorkerManager_All:registerPadEvent(__eConsoleUIPadEvent_Y, "PaGlobalFunc_WorkerManager_All_SetRestore()")
  Panel_Window_WorkerManager_All:registerPadEvent(__eConsoleUIPadEvent_Up_RT, "PaGlobalFunc_WorkerManager_All_UnCheckRTButton()")
end
function PaGlobalFunc_WorkerManager_All_UnCheckRTButton()
  PaGlobal_WorkerManager_All._RTButtonCheck = false
end
function PaGlobalFunc_WorkerManager_All_SetRestore()
  if nil == Panel_Window_WorkerManager_All then
    return
  end
  if PaGlobal_WorkerManager_All._config._tab._Command == PaGlobal_WorkerManager_All._selectedTab then
    if true == PaGlobal_WorkerManager_All._RTButtonCheck then
      PaGlobalFunc_WorkerManager_All_WorkerRestore(true)
      PaGlobal_WorkerManager_All._RTButtonCheck = false
    else
      PaGlobalFunc_WorkerManager_All_WorkerRestore()
    end
  end
end
function PaGlobalFunc_WorkerManager_All_SelectTab(tabIndex)
  if nil == Panel_Window_WorkerManager_All then
    return
  end
  PaGlobal_WorkerManager_All:selectTab(tabIndex)
  PaGlobal_WorkerManager_All:update()
end
function PaGlobalFunc_WorkerManager_All_ChangeTab(changeValue)
  if true == _ContentsGroup_isConsolePadControl then
    _AudioPostEvent_SystemUiForXBOX(51, 6)
  else
    PaGlobal_WorkerManager_All:selectWorkerPC(workerNoRawStr)
  end
  PaGlobal_WorkerManager_All:changeTab(changeValue)
  PaGlobal_WorkerManager_All:update()
end
function PaGlobalFunc_WorkerManager_All_listCreate(control, key)
  PaGlobal_WorkerManager_All:listCreate(control, key)
end
function PaGlobalFunc_WorkerManager_All_SetRightPanelInfo(workerNoRawStr)
  if true == _ContentsGroup_isConsolePadControl then
    PaGlobal_WorkerManager_All:selectWorker(workerNoRawStr)
  else
    PaGlobal_WorkerManager_All:selectWorkerPC(workerNoRawStr)
  end
  PaGlobal_WorkerManager_All:setRightPanelInfo(workerNoRawStr)
  PaGlobal_WorkerManager_All:update()
end
function PaGlobalFunc_WorkerManager_All_UpdateWorkerList()
  PaGlobal_WorkerManager_All:update()
end
function PaGlobalFunc_WorkerManager_All_FireWorker()
  if "" == PaGlobal_WorkerManager_All._selectedWorker or nil == PaGlobal_WorkerManager_All._selectedWorker then
    return
  end
  PaGlobal_WorkerManager_All:fireWorker()
end
function PaGlobalFunc_WorkerManager_All_FireWorkerChecked()
  if nil == PaGlobal_WorkerManager_All._workerCount then
    return
  end
  PaGlobal_WorkerManager_All:fireWorkerChecked()
end
function PaGlobalFunc_WorkerManager_All_WorkerRestore(isRestoreAll)
  if true == _ContentsGroup_isConsolePadControl then
    _AudioPostEvent_SystemUiForXBOX(51, 7)
    PaGlobal_WorkerManager_All:workerRestore(isRestoreAll)
  else
    PaGlobal_WorkerManager_All:workerRestoreAllPC()
  end
end
function PaGlobalFunc_WorkerManager_All_WorkerRepeat(workerNoRawStr)
  if true == _ContentsGroup_isConsolePadControl then
    if nil == PaGlobal_WorkerManager_All._selectedWorker or "" == PaGlobal_WorkerManager_All._selectedWorker then
      return
    end
    PaGlobal_WorkerManager_All:workerRepeat(tonumber64(PaGlobal_WorkerManager_All._selectedWorker))
  else
    if nil == workerNoRawStr then
      return
    end
    PaGlobal_WorkerManager_All:workerRepeat(tonumber64(workerNoRawStr))
  end
end
function PaGlobalFunc_WorkerManager_All_WorkerRepeatAll()
  if PaGlobal_WorkerManager_All._workerCount <= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
    return
  end
  PaGlobal_WorkerManager_All:workerRepeatAll()
end
function PaGlobalFunc_WorkerManager_All_ClearWorkerRepeatInfo()
  if nil == PaGlobal_WorkerManager_All._selectedWorker then
    return
  end
  PaGlobal_WorkerManager_All:clearWorkerRepeatInfo()
end
function PaGlobalFunc_WorkerManager_All_WorkerStop(workerNoRawStr)
  if true == _ContentsGroup_isConsolePadControl then
    if "" == PaGlobal_WorkerManager_All._selectedWorker or nil == PaGlobal_WorkerManager_All._selectedWorker then
      return
    end
    PaGlobal_WorkerManager_All:workerStop()
  elseif nil == workerNoRawStr then
    PaGlobal_WorkerManager_All:workerStop()
  else
    PaGlobal_WorkerManager_All:workerStop(tonumber64(workerNoRawStr))
  end
end
function PaGlobalFunc_WorkerManager_All_WorkerChangeSkill()
  if "" == PaGlobal_WorkerManager_All._selectedWorker or nil == PaGlobal_WorkerManager_All._selectedWorker then
    return
  end
  PaGlobal_WorkerManager_All:workerChangeSkill()
end
function PaGlobalFunc_WorkerManager_All_UpgradeWorker()
  if "" == PaGlobal_WorkerManager_All._selectedWorker or nil == PaGlobal_WorkerManager_All._selectedWorker then
    return
  end
  PaGlobal_WorkerManager_All:upgradeWorker()
end
function PaGlobalFunc_WorkerManager_All_WorkerUpgradeNow()
  if "" == PaGlobal_WorkerManager_All._selectedWorker or nil == PaGlobal_WorkerManager_All._selectedWorker then
    return
  end
  PaGlobal_WorkerManager_All:upgradeNow()
end
function PaGlobalFunc_WorkerManager_All_ResetUpgradeCount()
  if "" == PaGlobal_WorkerManager_All._selectedWorker or nil == PaGlobal_WorkerManager_All._selectedWorker then
    return
  end
  if not ToClient_doHaveClearWorkerUpgradeItem() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_NOITEMALERT"))
    return
  end
  PaGlobal_WorkerManager_All:resetUpgradeCount()
end
function PaGlobalFunc_WorkerManager_All_GetWorkEfficiency(workerWrapperLua)
  local _tempWorkEfficiency = 0
  if _tempWorkEfficiency < workerWrapperLua:getWorkEfficiency(2) then
    _tempWorkEfficiency = workerWrapperLua:getWorkEfficiency(2)
  end
  if _tempWorkEfficiency < workerWrapperLua:getWorkEfficiency(5) then
    _tempWorkEfficiency = workerWrapperLua:getWorkEfficiency(5)
  end
  if _tempWorkEfficiency < workerWrapperLua:getWorkEfficiency(6) then
    _tempWorkEfficiency = workerWrapperLua:getWorkEfficiency(6)
  end
  if _tempWorkEfficiency < workerWrapperLua:getWorkEfficiency(8) then
    _tempWorkEfficiency = workerWrapperLua:getWorkEfficiency(8)
  end
  return _tempWorkEfficiency
end
function PaGlobalFunc_WorkerManager_All_PushWorkStartMessage(workerNo, _workType, buildingInfoSS)
  PaGlobal_WorkerManager_All:pushStartMessage(workerNo, _workType, buildingInfoSS)
end
function PaGlobalFunc_WorkerManager_All_PushWorkStopMessage(workerNo, isUserRequest, working)
  local npcWorkerWrapper = ToClient_getNpcWorkerByWorkerNo(workerNo)
  if nil == npcWorkerWrapper then
    return
  end
  local workerName = npcWorkerWrapper:getName()
  local workingArea = working:getWorkingNodeName()
  local workingName = working:getWorkingName()
  if true == isUserRequest then
    Proc_ShowMessage_Ack_With_ChatType(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_FINISHWORK_2", "workerName", workerName, "workingArea", workingArea, "workingName", workingName), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Worker)
  elseif false == isUserRequest then
    if working:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantZone) then
      Proc_ShowMessage_Ack_With_ChatType(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_FINISHWORK_3", "workerName", workerName, "workingArea", workingArea), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Worker)
    else
      Proc_ShowMessage_Ack_With_ChatType(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_FINISHWORK_1", "workerName", workerName, "workingArea", workingArea, "workingName", workingName), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Worker)
    end
  end
end
function PaGlobalFunc_WorkerManager_All_PushWorkResultItemMessage(WorkerNoRaw)
  local result_Count = ToClient_getLastestWorkingResultCount(WorkerNoRaw)
  for idx = 1, result_Count do
    local itemWrapper = ToClient_getLastestWorkingResult(WorkerNoRaw, idx - 1)
    if itemWrapper:isSet() then
      local ItemEnchantSSW = itemWrapper:getStaticStatus()
      local name = ItemEnchantSSW:getName()
      local count = Int64toInt32(itemWrapper:get():getCount_s64())
      Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_GOT_RESULT", "name", name, "count", count), nil)
    end
  end
end
function PaGlobalFunc_WorkerManager_All_GetSelectWorkerCount()
  return PaGlobal_WorkerManager_All._workerCount
end
function PaGlobalFunc_WorkerManager_All_GetSelectWorker()
  if PaGlobal_WorkerManager_All._workerCount <= 0 then
    return nil
  end
  return PaGlobal_WorkerManager_All._selectedWorker
end
function PaGlobalFunc_WorkerManager_All_GetSelectWorkerList()
  if PaGlobal_WorkerManager_All._workerCount <= 0 then
    return nil
  end
  return PaGlobal_WorkerManager_All._workerList
end
function PaGlobalFunc_WorkerManager_All_GetTotalRestoreCount(selectedItemIdx)
  if PaGlobal_WorkerManager_All._workerCount <= 0 then
    return 0
  end
  local totalPoint = 0
  local selectItem = ToClient_getNpcRecoveryItemByIndex(selectedItemIdx)
  if nil == selectItem then
    return
  end
  local selectItemCount = Int64toInt32(selectItem._itemCount_s64)
  local selectItemPoint = selectItem._contentsEventParam1
  local totalselectItemPoint = selectItemCount * selectItemPoint
  for index = 0, PaGlobal_WorkerManager_All._workerCount - 1 do
    local workerNoRaw = PaGlobal_WorkerManager_All._workerList[index]
    local workerWrapperLua = getWorkerWrapper(workerNoRaw, false)
    local maxPoint = workerWrapperLua:getMaxActionPoint()
    local currentPoint = workerWrapperLua:getActionPoint()
    local restoreActionPoint = maxPoint - currentPoint
    local remainder = restoreActionPoint % selectItemPoint
    if maxPoint >= currentPoint + selectItemPoint then
      totalPoint = totalPoint + (restoreActionPoint - remainder)
    end
  end
  return totalPoint
end
function FromClient_WorkerManager_All_WorkerDataUpdate_HeadingPlant(ExplorationNode, workerNo)
  PaGlobal_WorkerManager_All:workerDataUpdateHeadingPlant(ExplorationNode, workerNo)
end
function FromClient_WorkerManager_All_WorkerDataUpdate_HeadingHouse(rentHouseWrapper, workerNo)
  PaGlobal_WorkerManager_All:workerDataUpdateHeadingHouse(rentHouseWrapper, workerNo)
end
function FromClient_WorkerManager_All_WorkerDataUpdate_HeadingBuilding(buildingInfoSS, workerNo)
  PaGlobal_WorkerManager_All:workerDataUpdateHeadingBuilding(buildingInfoSS, workerNo)
end
function FromClient_WorkerManager_All_WorkerDataUpdate_HeadingRegionManaging(regionGroupInfo, workerNo)
  PaGlobal_WorkerManager_All:workerDataUpdateHeadingRegionManaging(regionGroupInfo, workerNo)
end
function PaGlobalFunc_WorkerManager_All_PerFrameUpdate(deltaTime)
  PaGlobal_WorkerManager_All:perFrameUpdate(deltaTime)
end
function PaGlobalFunc_WorkerManager_All_ShowAni()
  Panel_Window_WorkerManager_All:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_Window_WorkerManager_All, 0, 0.3)
end
function PaGlobalFunc_WorkerManager_All_HideAni()
  local ani1 = UIAni.AlphaAnimation(0, Panel_Window_WorkerManager_All, 0, 0.2)
  ani1:SetHideAtEnd(true)
end
function workerManager_CheckWorkingOtherChannel()
  if nil == getSelfPlayer() then
    return
  end
  if 0 ~= getSelfPlayer():get():checkWorkerWorkingServerNo() then
    return true
  else
    return false
  end
end
function workerManager_getWorkingOtherChannelMsg()
  if workerManager_CheckWorkingOtherChannel() then
    if nil == getSelfPlayer() then
      return
    end
    local workingServerNo = getSelfPlayer():get():getWorkerWorkingServerNo()
    local temporaryWrapper = getTemporaryInformationWrapper()
    if nil == temporaryWrapper then
      return
    end
    local worldNo = temporaryWrapper:getSelectedWorldServerNo()
    local channelName = getChannelName(worldNo, workingServerNo)
    return PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERWORKINGOTHERCHANNEL", "channelName", channelName)
  else
    return ""
  end
end
function workerManager_CheckWorkingOtherChannelAndMsg()
  if workerManager_CheckWorkingOtherChannel() then
    Proc_ShowMessage_Ack(workerManager_getWorkingOtherChannelMsg(), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
    return true
  else
    return false
  end
end
function workerManager_CheckWorkingOtherChannel()
  if nil == getSelfPlayer() then
    return
  end
  if 0 ~= getSelfPlayer():get():checkWorkerWorkingServerNo() then
    return true
  else
    return false
  end
end
function PaGlobalFunc_WorkerManager_All_GetTotalRestoreCount(selectedItemIdx)
  if PaGlobal_WorkerManager_All._workerCount <= 0 then
    return 0
  end
  local totalPoint = 0
  local selectItem = ToClient_getNpcRecoveryItemByIndex(selectedItemIdx)
  if nil == selectItem then
    return
  end
  local selectItemCount = Int64toInt32(selectItem._itemCount_s64)
  local selectItemPoint = selectItem._contentsEventParam1
  local totalselectItemPoint = selectItemCount * selectItemPoint
  for index = 0, PaGlobal_WorkerManager_All._workerCount - 1 do
    local workerNoRaw = PaGlobal_WorkerManager_All._workerList[index]
    local workerWrapperLua = getWorkerWrapper(workerNoRaw, false)
    local maxPoint = workerWrapperLua:getMaxActionPoint()
    local currentPoint = workerWrapperLua:getActionPoint()
    local restoreActionPoint = maxPoint - currentPoint
    local remainder = restoreActionPoint % selectItemPoint
    if maxPoint >= currentPoint + selectItemPoint then
      totalPoint = totalPoint + (restoreActionPoint - remainder)
    end
  end
  return totalPoint
end
function PaGlobalFunc_WorkerManager_All_OpenWorldMap()
  if workerManager_CheckWorkingOtherChannel() then
    if nil == getSelfPlayer() then
      return
    end
    local workingServerNo = getSelfPlayer():get():getWorkerWorkingServerNo()
    local temporaryWrapper = getTemporaryInformationWrapper()
    if nil == temporaryWrapper then
      return
    end
    local worldNo = temporaryWrapper:getSelectedWorldServerNo()
    local channelName = getChannelName(worldNo, workingServerNo)
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERWORKINGOTHERCHANNEL", "channelName", channelName), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
    return
  end
  if PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:GetShow() then
    HandleClicked_WorkerManager_All_RestoreItemClose()
  end
  PaGlobal_WorkerManager_All._sliderStartIdx = 0
  PaGlobal_WorkerManager_All._startIndex = 1
  if Panel_Window_WorkerManager_All:GetShow() and false == Panel_Window_WorkerManager_All:IsUISubApp() then
    PaGlobalFunc_WorkerManager_All_Close()
  end
  audioPostEvent_SystemUi(1, 28)
  PaGlobalFunc_WorkerManager_All_Open()
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:increaseLayer(true)
    WorldMapPopupManager:push(Panel_Window_WorkerManager_All, true)
  end
end
function FGlobal_RedoWork(_workType, _houseInfoSS, _selectedWorker, _plantKey, _workKey, _selectedSubwork, _workingCount, _itemNoRaw, _houseHoldNo, _homeWaypoint)
  local plantKey = ToClient_convertWaypointKeyToPlantKey(_homeWaypoint)
  local waitWorkerCount = ToClient_getPlantWaitWorkerListCount(plantKey, 0)
  local maxWorkerCount = ToClient_getTownWorkerMaxCapacity(plantKey)
end

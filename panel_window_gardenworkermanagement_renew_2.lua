function HandleEventAUp_GardenWorkerManagement_SelectWorker(id)
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  local prevWorker = PaGlobal_GardenWorkerManagement._currentWorkerIndex
  PaGlobal_GardenWorkerManagement._currentWorkerIndex = id
  PaGlobal_GardenWorkerManagement._ui._list2_workerList:requestUpdateByKey(toInt64(0, prevWorker))
  PaGlobal_GardenWorkerManagement._ui._list2_workerList:requestUpdateByKey(toInt64(0, PaGlobal_GardenWorkerManagement._currentWorkerIndex))
  PaGlobal_GardenWorkerManagement:updateRightInfo(PaGlobal_GardenWorkerManagement._currentWorkerIndex)
  HandleEventMO_GardenWorkerManagement_FocusWorkerButton(-1)
end
function HandleEventMO_GardenWorkerManagement_FocusWorkerButton(index)
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  PaGlobal_GardenWorkerManagement._currentFocusWorkerIndex = index
  PaGlobal_GardenWorkerManagement._ui._static_KeyGuide_Select:SetShow(PaGlobal_GardenWorkerManagement._currentWorkerIndex ~= index)
  if -1 == index then
    PaGlobal_GardenWorkerManagement._ui._static_KeyGuide_Select:SetShow(false)
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_GardenWorkerManagement._keyGuideAlign, PaGlobal_GardenWorkerManagement._ui._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function HandleEventXUp_GardenWorkerManagement_StartWork()
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  if workerManager_CheckWorkingOtherChannelAndMsg() then
    return
  end
  if nil == PaGlobal_GardenWorkerManagement._currentWorkerIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
    return
  end
  local selectedWorker = PaGlobal_GardenWorkerManagement._workerInfoList[PaGlobal_GardenWorkerManagement._currentWorkerIndex]
  if nil == selectedWorker then
    return
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local householdWrapper = temporaryWrapper:getSelfTentWrapperByIndex(PaGlobal_GardenWorkerManagement._householdIndex)
  if nil == householdWrapper then
    return
  end
  if selectedWorker._currentPoint < 2 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_HARVEST_MESSAGE_NEEDACTIONPOINT"))
    return
  end
  local houseHoldNo = householdWrapper:getHouseholdNo()
  ToClient_requestStartHarvestWorking(houseHoldNo, WorkerNo(selectedWorker._workerNo))
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PLANT_WORKMANAGER_STARTWORK"))
  PaGlobal_GardenWorkerManagement:prepareClose()
end
function FromClient_Harvest_UpdateWorkStatus()
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  if Panel_Window_GardenWorkerManagement:GetShow() then
    PaGlobal_GardenWorkerManagement:update()
  end
end
function FromClient_GardenWorkerManagement_OnScreenResize()
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  PaGlobal_GardenWorkerManagement:resize()
end
registerEvent("onScreenResize", "FromClient_GardenWorkerManagement_OnScreenResize")
registerEvent("WorldMap_StopWorkerWorking", "FromClient_Harvest_UpdateWorkStatus")
registerEvent("WorldMap_WorkerDataUpdateByHarvestWorking", "FromClient_Harvest_UpdateWorkStatus")

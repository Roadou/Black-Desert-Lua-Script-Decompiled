function HandleEventPadX_GardenList_StartNaviToGarden(controlIndex)
  if nil == Panel_Window_GardenList then
    return
  end
  PaGlobal_GardenList:setNaviToGarden(controlIndex)
end
function HandleEventPadY_GardenList_OpenGardenInfo(controlIndex)
  if nil == Panel_Window_GardenList then
    return
  end
  local index = PaGlobal_GardenList._gardenIndexList[controlIndex + 1]
  local temporaryWrapper = getTemporaryInformationWrapper()
  if nil == temporaryWrapper then
    return
  end
  local householdWrapper = temporaryWrapper:getSelfTentWrapperByIndex(index)
  if nil == householdWrapper then
    return
  end
  PaGlobal_GardenInformation:open(index)
end
function HandleEventPadA_GardenList_OpenWorkerList(controlIndex)
  if nil == Panel_Window_GardenList then
    return
  end
  local index = PaGlobal_GardenList._gardenIndexList[controlIndex + 1]
  local temporaryWrapper = getTemporaryInformationWrapper()
  if nil == temporaryWrapper then
    return
  end
  local householdWrapper = temporaryWrapper:getSelfTentWrapperByIndex(index)
  if nil == householdWrapper then
    return
  end
  PaGlobal_GardenWorkerManagement:prepareOpen(index)
end
function PaGlobal_GardenList_update()
  if nil == Panel_Window_GardenList then
    return
  end
  if false == Panel_Window_GardenList:GetShow() then
    return
  end
  PaGlobal_GardenList:update()
end
function FromClient_GardenList_OnScreenResize()
  if nil == Panel_Window_GardenList then
    return
  end
  PaGlobal_GardenList:resize()
end
registerEvent("onScreenResize", "FromClient_GardenList_OnScreenResize")
registerEvent("WorldMap_StopWorkerWorking", "PaGlobal_GardenList_update")
registerEvent("WorldMap_WorkerDataUpdateByHarvestWorking", "PaGlobal_GardenList_update")

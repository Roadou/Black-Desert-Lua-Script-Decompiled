function PaGlobal_GardenList:initialize()
  if true == PaGlobal_GardenList._initialize then
    return
  end
  PaGlobal_GardenList._ui._list2_garden = UI.getChildControl(Panel_Window_GardenList, "List2_GardenList")
  local _stc_keyguideBG = UI.getChildControl(Panel_Window_GardenList, "Static_KeyGuideBG")
  local _stc_keyguideY = UI.getChildControl(_stc_keyguideBG, "StaticText_Y_ConsoleUI")
  local _stc_keyguideA = UI.getChildControl(_stc_keyguideBG, "StaticText_A_ConsoleUI")
  local _stc_keyguideX = UI.getChildControl(_stc_keyguideBG, "StaticText_X_ConsoleUI")
  local _stc_keyguideB = UI.getChildControl(_stc_keyguideBG, "StaticText_B_ConsoleUI")
  PaGlobal_GardenList._keyGuideAlign = {
    _stc_keyguideY,
    _stc_keyguideA,
    _stc_keyguideX,
    _stc_keyguideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_GardenList._keyGuideAlign, _stc_keyguideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  PaGlobal_GardenList:registEventHandler()
  PaGlobal_GardenList:resize()
  PaGlobal_GardenList._initialize = true
end
function PaGlobal_GardenList:registEventHandler()
  if nil == Panel_Window_GardenList then
    return
  end
  PaGlobal_GardenList._ui._list2_garden:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_GardenList_addGardenListContent")
  PaGlobal_GardenList._ui._list2_garden:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function PaGlobal_GardenList:prepareOpen()
  if nil == Panel_Window_GardenList then
    return
  end
  local vScroll = PaGlobal_GardenList._ui._list2_garden:GetVScroll()
  vScroll:SetControlPos(0)
  PaGlobal_GardenList._isHarvestManagementOpen = ToClient_IsContentsGroupOpen("72")
  if false == PaGlobal_GardenList._isHarvestManagementOpen then
    local _stc_keyguideBG = UI.getChildControl(Panel_Window_GardenList, "Static_KeyGuideBG")
    UI.getChildControl(_stc_keyguideBG, "StaticText_A_ConsoleUI"):SetShow(false)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_GardenList._keyGuideAlign, _stc_keyguideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  end
end
function PaGlobal_GardenList:open()
  if nil == Panel_Window_GardenList then
    return
  end
  PaGlobal_GardenList:prepareOpen()
  PaGlobal_GardenList:update()
  Panel_Window_GardenList:SetShow(true)
end
function PaGlobal_GardenList:prepareClose()
  if nil == Panel_Window_GardenList then
    return
  end
  PaGlobal_GardenList._dwellingCount = nil
  PaGlobal_GardenList._totalGardenCount = nil
  PaGlobal_GardenList._gardenIndexList = {}
  PaGlobal_GardenList._gardenPosList = {}
  PaGlobal_GardenList._isHarvestManagementOpen = nil
end
function PaGlobal_GardenList:close()
  if nil == Panel_Window_GardenList then
    return
  end
  PaGlobal_GardenList:prepareClose()
  Panel_Window_GardenList:SetShow(false)
end
function PaGlobal_GardenList:update()
  if nil == Panel_Window_GardenList then
    return
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local gardenCount = temporaryWrapper:getSelfTentCount()
  PaGlobal_GardenList._totalGardenCount = 0
  PaGlobal_GardenList._ui._list2_garden:getElementManager():clearKey()
  for index = 0, gardenCount - 1 do
    local householdDataWithInstallationWrapper = temporaryWrapper:getSelfTentWrapperByIndex(index)
    local characterSSW = householdDataWithInstallationWrapper:getHouseholdCharacterStaticStatusWrapper()
    if nil ~= characterSSW and nil ~= characterSSW:getName() then
      PaGlobal_GardenList._totalGardenCount = PaGlobal_GardenList._totalGardenCount + 1
      PaGlobal_GardenList._gardenIndexList[PaGlobal_GardenList._totalGardenCount] = index
      PaGlobal_GardenList._ui._list2_garden:getElementManager():pushKey(toInt64(0, PaGlobal_GardenList._totalGardenCount))
    end
  end
end
function PaGlobal_GardenList:validate()
  if nil == Panel_Window_GardenList then
    return
  end
  PaGlobal_GardenList._ui._list2_garden:isValidate()
end
function PaGlobal_GardenList:resize()
  if nil == Panel_Window_GardenList then
    return
  end
  Panel_Window_GardenList:ComputePos()
end
function PaGlobal_GardenList:setNaviToGarden(controlIndex)
  if nil == Panel_Window_GardenList then
    return
  end
  ToClient_DeleteNaviGuideByGroup(0)
  local navigationGuideParam = NavigationGuideParam()
  navigationGuideParam._isAutoErase = true
  worldmapNavigatorStart(PaGlobal_GardenList._gardenPosList[controlIndex], navigationGuideParam, false, false, true)
end
function PaGlobal_GardenList_addGardenListContent(control, key)
  if nil == Panel_Window_GardenList then
    return
  end
  if nil == control or nil == key then
    return
  end
  local index = PaGlobal_GardenList._gardenIndexList[Int64toInt32(key)]
  local temporaryWrapper = getTemporaryInformationWrapper()
  if nil == temporaryWrapper then
    return
  end
  local householdDataWithInstallationWrapper = temporaryWrapper:getSelfTentWrapperByIndex(index)
  if nil == householdDataWithInstallationWrapper then
    return
  end
  local gardenSSW = householdDataWithInstallationWrapper:getHouseholdCharacterStaticStatusWrapper()
  if nil == gardenSSW then
    return
  end
  local gardenWrapper = temporaryWrapper:getSelfTentWrapperByIndex(index)
  local gardenPosX = gardenWrapper:getSelfTentPositionX()
  local gardenPosY = gardenWrapper:getSelfTentPositionY()
  local gardenPosZ = gardenWrapper:getSelfTentPositionZ()
  local gardenPos = float3(gardenPosX, gardenPosY, gardenPosZ)
  local regionWrapper = ToClient_getRegionInfoWrapperByPosition(gardenPos)
  local isWorking = ToClient_hasWorkerWorkingInHarvest(householdDataWithInstallationWrapper:getHouseholdNo())
  if nil == regionWrapper then
    return
  end
  local _txt_territoryName = UI.getChildControl(control, "StaticText_TerritoryName")
  local _txt_regionName = UI.getChildControl(control, "StaticText_RegionName")
  local _txt_typeName = UI.getChildControl(control, "StaticText_TypeName")
  local _stc_workingIcon = UI.getChildControl(control, "Static_WorkingIcon")
  _txt_territoryName:SetText(regionWrapper:getTerritoryName())
  _txt_regionName:SetText(regionWrapper:getAreaName())
  _txt_typeName:SetText(gardenSSW:getName())
  _stc_workingIcon:SetShow(isWorking)
  PaGlobal_GardenList._gardenPosList[index] = gardenPos
  control:registerPadEvent(__eConsoleUIPadEvent_X, "HandleEventPadX_GardenList_StartNaviToGarden(" .. index .. ")")
  control:registerPadEvent(__eConsoleUIPadEvent_Y, "HandleEventPadY_GardenList_OpenGardenInfo(" .. index .. ")")
  if true == PaGlobal_GardenList._isHarvestManagementOpen then
    control:registerPadEvent(__eConsoleUIPadEvent_A, "HandleEventPadA_GardenList_OpenWorkerList(" .. index .. ")")
  end
end

function PaGlobal_GardenWorkerManagement:initialize()
  if true == PaGlobal_GardenWorkerManagement._initialize then
    return
  end
  local topBG = UI.getChildControl(Panel_Window_GardenWorkerManagement, "Static_TopBg")
  PaGlobal_GardenWorkerManagement._ui._txt_regieonTitle = UI.getChildControl(topBG, "StaticText_Title")
  local centerBG = UI.getChildControl(Panel_Window_GardenWorkerManagement, "Static_CenterBg")
  local centerInfoBG = UI.getChildControl(centerBG, "Static_InfoBg")
  PaGlobal_GardenWorkerManagement._ui._stc_gardenIcon = UI.getChildControl(centerInfoBG, "Static_Icon")
  PaGlobal_GardenWorkerManagement._ui._txt_gardenName = UI.getChildControl(centerInfoBG, "StaticText_Desc")
  PaGlobal_GardenWorkerManagement._ui._txt_movementLeftTime = UI.getChildControl(centerInfoBG, "StaticText_LeftTimeValue")
  PaGlobal_GardenWorkerManagement._ui._txt_movementDistance = UI.getChildControl(centerInfoBG, "StaticText_DistanceValue")
  PaGlobal_GardenWorkerManagement._ui._txt_movementSpeed = UI.getChildControl(centerInfoBG, "StaticText_MoveSpeedValue")
  PaGlobal_GardenWorkerManagement._ui._txt_workerLuck = UI.getChildControl(centerInfoBG, "StaticText_LuckValue")
  PaGlobal_GardenWorkerManagement._ui._list2_workerList = UI.getChildControl(centerBG, "List2_Worker")
  PaGlobal_GardenWorkerManagement._ui._static_BottomBg = UI.getChildControl(Panel_Window_GardenWorkerManagement, "Static_BottomBg")
  PaGlobal_GardenWorkerManagement._ui._static_KeyGuide_DoWork = UI.getChildControl(PaGlobal_GardenWorkerManagement._ui._static_BottomBg, "StaticText_X_ConsoleUI")
  PaGlobal_GardenWorkerManagement._ui._static_KeyGuide_Select = UI.getChildControl(PaGlobal_GardenWorkerManagement._ui._static_BottomBg, "StaticText_A_ConsoleUI")
  PaGlobal_GardenWorkerManagement._ui._static_KeyGuide_Close = UI.getChildControl(PaGlobal_GardenWorkerManagement._ui._static_BottomBg, "StaticText_B_ConsoleUI")
  local txt_workerDesc = UI.getChildControl(centerInfoBG, "StaticText_DescNotice")
  txt_workerDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_workerDesc:SetText(txt_workerDesc:GetText())
  PaGlobal_GardenWorkerManagement:registEventHandler()
  PaGlobal_GardenWorkerManagement._keyGuideAlign = {
    PaGlobal_GardenWorkerManagement._ui._static_KeyGuide_DoWork,
    PaGlobal_GardenWorkerManagement._ui._static_KeyGuide_Select,
    PaGlobal_GardenWorkerManagement._ui._static_KeyGuide_Close
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_GardenWorkerManagement._keyGuideAlign, PaGlobal_GardenWorkerManagement._ui._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  PaGlobal_GardenWorkerManagement:resize()
  PaGlobal_GardenWorkerManagement._initialize = true
end
function PaGlobal_GardenWorkerManagement:registEventHandler()
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  PaGlobal_GardenWorkerManagement._ui._list2_workerList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_GardenWorkerManagement_List2EventControlCreate")
  PaGlobal_GardenWorkerManagement._ui._list2_workerList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  Panel_Window_GardenWorkerManagement:registerPadEvent(__eConsoleUIPadEvent_Up_X, "HandleEventXUp_GardenWorkerManagement_StartWork()")
end
function PaGlobal_GardenWorkerManagement:prepareOpen(index)
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  PaGlobal_GardenWorkerManagement._currentWorkerIndex = 0
  PaGlobal_GardenWorkerManagement._householdIndex = index
  PaGlobal_GardenWorkerManagement:update()
  PaGlobal_GardenWorkerManagement:open()
end
function PaGlobal_GardenWorkerManagement:open()
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  Panel_Window_GardenWorkerManagement:SetShow(true)
end
function PaGlobal_GardenWorkerManagement:prepareClose()
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  PaGlobal_GardenWorkerManagement._workerInfoList = {}
  PaGlobal_GardenWorkerManagement._householdIndex = nil
  PaGlobal_GardenWorkerManagement._currentWorkerIndex = nil
  PaGlobal_GardenWorkerManagement._currentFocusWorkerIndex = nil
  PaGlobal_GardenWorkerManagement:close()
end
function PaGlobal_GardenWorkerManagement:close()
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  Panel_Window_GardenWorkerManagement:SetShow(false)
end
function PaGlobal_GardenWorkerManagement:update()
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  PaGlobal_GardenWorkerManagement:updateWorkerList()
  PaGlobal_GardenWorkerManagement:updateRightInfo(PaGlobal_GardenWorkerManagement._currentWorkerIndex)
end
function PaGlobal_GardenWorkerManagement:validate()
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  PaGlobal_GardenWorkerManagement._ui._txt_regieonTitle:isValidate()
  PaGlobal_GardenWorkerManagement._ui._stc_gardenIcon:isValidate()
  PaGlobal_GardenWorkerManagement._ui._txt_gardenName:isValidate()
  PaGlobal_GardenWorkerManagement._ui._txt_movementLeftTime:isValidate()
  PaGlobal_GardenWorkerManagement._ui._txt_movementDistance:isValidate()
  PaGlobal_GardenWorkerManagement._ui._txt_movementSpeed:isValidate()
  PaGlobal_GardenWorkerManagement._ui._txt_workerLuck:isValidate()
  PaGlobal_GardenWorkerManagement._ui._list2_workerList:isValidate()
  PaGlobal_GardenWorkerManagement._ui._static_BottomBg:isValidate()
  PaGlobal_GardenWorkerManagement._ui._static_KeyGuide_DoWork:isValidate()
  PaGlobal_GardenWorkerManagement._ui._static_KeyGuide_Select:isValidate()
  PaGlobal_GardenWorkerManagement._ui._static_KeyGuide_Close:isValidate()
end
function PaGlobal_GardenWorkerManagement:resize()
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  Panel_Window_GardenWorkerManagement:ComputePos()
end
function PaGlobal_GardenWorkerManagement:updateWorkerList()
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  PaGlobal_GardenWorkerManagement._workerInfoList = {}
  PaGlobal_GardenWorkerManagement._ui._list2_workerList:getElementManager():clearKey()
  local workingWorkerList = {}
  local sortMethod = 0
  local workerArray = Array.new()
  workerArray = PaGlobal_GardenWorkerManagement:getWaitWorkerFullList()
  local workingWorkerIndex = 0
  for index = 1, #workerArray do
    local workerNoRaw = workerArray[index]
    local workerWrapper = getWorkerWrapper(workerNoRaw, false)
    if nil ~= workerWrapper and CppEnums.NpcWorkingType.eNpcWorkingType_Count == workerWrapper:getWorkingType() and not workerWrapper:getIsAuctionInsert() then
      if nil == PaGlobal_GardenWorkerManagement._workerInfoList[index] then
        PaGlobal_GardenWorkerManagement._workerInfoList[index] = {}
      end
      local moveSpeed = workerWrapper:getMoveSpeedWithSkill(CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking, CppEnums.eHouseUseType.count, 0) / 100
      local luck = workerWrapper:getLuckWithSkill(CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking, CppEnums.eHouseUseType.count, 0)
      local maxPoint = workerWrapper:getMaxActionPoint()
      local currentPoint = workerWrapper:getActionPoint()
      local homeWaypoint = workerWrapper:getHomeWaypoint()
      local regionInfo = ToClient_getRegionInfoWrapperByWaypoint(homeWaypoint)
      local name = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. workerWrapper:getLevel() .. " " .. workerWrapper:getName()
      local regionName = "(<PAColor0xff868686>" .. regionInfo:getAreaName() .. "<PAOldColor>)"
      PaGlobal_GardenWorkerManagement._workerInfoList[index] = {
        _workerNo = workerNoRaw,
        _name = name,
        _regionName = regionName,
        _moveSpeed = moveSpeed,
        _luck = luck / 10000,
        _maxPoint = maxPoint,
        _currentPoint = currentPoint
      }
      PaGlobal_GardenWorkerManagement._ui._list2_workerList:getElementManager():pushKey(toInt64(0, index))
      PaGlobal_GardenWorkerManagement._ui._list2_workerList:requestUpdateByKey(toInt64(0, index))
    end
  end
end
function PaGlobal_GardenWorkerManagement:getWaitWorkerFullList(plantKey)
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  local plantArray = Array.new()
  local workerArray = Array.new()
  if nil ~= plantKey then
    plantArray:push_back(plantKey)
  else
    local plantConut = ToCleint_getHomePlantKeyListCount()
    for plantIdx = 0, plantConut - 1 do
      local plantKeyRaw = ToCleint_getHomePlantKeyListByIndex(plantIdx)
      local plantKey = PlantKey()
      plantKey:setRaw(plantKeyRaw)
      plantArray:push_back(plantKey)
    end
  end
  local plantSort_do = function(a, b)
    return a:get() < b:get()
  end
  table.sort(plantArray, plantSort_do)
  for plantRawIdx = 1, #plantArray do
    local plantKey = plantArray[plantRawIdx]
    local plantWorkerCount = ToClient_getPlantWaitWorkerListCount(plantKey, 0)
    local workerHouseCount = ToClient_getTownWorkerMaxCapacity(plantKey)
    if plantWorkerCount > workerHouseCount then
      plantWorkerCount = workerHouseCount
    end
    for workerIdx = 0, plantWorkerCount - 1 do
      local workerNoRaw = ToClient_getPlantWaitWorkerNoRawByIndex(plantKey, workerIdx)
      workerArray:push_back(workerNoRaw)
    end
  end
  return workerArray
end
function PaGlobal_GardenWorkerManagement:updateRightInfo(id)
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  local workerInfo = PaGlobal_GardenWorkerManagement._workerInfoList[id]
  local temporaryWrapper = getTemporaryInformationWrapper()
  local householdWrapper = temporaryWrapper:getSelfTentWrapperByIndex(PaGlobal_GardenWorkerManagement._householdIndex)
  if nil == householdWrapper then
    return
  end
  local characterStaticStatusWrapper = householdWrapper:getHouseholdCharacterStaticStatusWrapper()
  if nil == characterStaticStatusWrapper then
    return
  end
  local itemSSW = characterStaticStatusWrapper:getItemEnchantStatcStaticWrapper()
  if nil == itemSSW then
    return
  end
  local tentPosX = householdWrapper:getSelfTentPositionX()
  local tentPosY = householdWrapper:getSelfTentPositionY()
  local tentPosZ = householdWrapper:getSelfTentPositionZ()
  local tentPosition = float3(tentPosX, tentPosY, tentPosZ)
  local regionWrapper = ToClient_getRegionInfoWrapperByPosition(tentPosition)
  if nil == regionWrapper then
    return
  end
  local name = characterStaticStatusWrapper:getName()
  local icon = "icon/" .. itemSSW:getIconPath()
  PaGlobal_GardenWorkerManagement._ui._txt_regieonTitle:SetText(regionWrapper:getAreaName())
  PaGlobal_GardenWorkerManagement._ui._stc_gardenIcon:ChangeTextureInfoName(icon)
  PaGlobal_GardenWorkerManagement._ui._txt_gardenName:SetText(name)
  if nil ~= workerInfo then
    local distance = ToClient_getCalculateMoveDistance(WorkerNo(workerInfo._workerNo), tentPosition) / 100
    local moveSpeed = workerInfo._moveSpeed
    local luck = workerInfo._luck
    local workBaseTime = ToClient_getNpcWorkingBaseTime() / 1000
    local totalWorkTime = distance / moveSpeed * 2
    PaGlobal_GardenWorkerManagement._ui._txt_movementLeftTime:SetText(Util.Time.timeFormatting(math.floor(totalWorkTime)))
    PaGlobal_GardenWorkerManagement._ui._txt_movementDistance:SetText(string.format("%.0f", distance))
    PaGlobal_GardenWorkerManagement._ui._txt_movementSpeed:SetText(string.format("%.2f", moveSpeed))
    PaGlobal_GardenWorkerManagement._ui._txt_workerLuck:SetText(string.format("%.2f", luck))
  else
    PaGlobal_GardenWorkerManagement._ui._txt_movementLeftTime:SetText("--")
    PaGlobal_GardenWorkerManagement._ui._txt_movementDistance:SetText("--")
    PaGlobal_GardenWorkerManagement._ui._txt_movementSpeed:SetText("--")
    PaGlobal_GardenWorkerManagement._ui._txt_workerLuck:SetText("--")
  end
  PaGlobal_GardenWorkerManagement._ui._static_KeyGuide_Select:SetShow(PaGlobal_GardenWorkerManagement._currentWorkerIndex ~= id)
  PaGlobal_GardenWorkerManagement._ui._static_KeyGuide_DoWork:SetShow(nil ~= workerInfo)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_GardenWorkerManagement._keyGuideAlign, PaGlobal_GardenWorkerManagement._ui._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobal_GardenWorkerManagement_List2EventControlCreate(control, key)
  if nil == Panel_Window_GardenWorkerManagement then
    return
  end
  local id = Int64toInt32(key)
  local workerInfo = PaGlobal_GardenWorkerManagement._workerInfoList[id]
  if nil == workerInfo then
    return
  end
  local button = UI.getChildControl(control, "Radiobutton_ButtonBg")
  local workerImage = UI.getChildControl(control, "Static_WorkerImage")
  local energyProgress = UI.getChildControl(control, "Progress2_EnergyProgress")
  local workerName = UI.getChildControl(control, "StaticText_WorkerTitle")
  local workerTown = UI.getChildControl(control, "StaticText_Node")
  local checkIcon = UI.getChildControl(control, "Static_CheckIcon")
  local currentEnergy = UI.getChildControl(control, "StaticText_Energy")
  checkIcon:SetShow(id == PaGlobal_GardenWorkerManagement._currentWorkerIndex)
  button:SetCheck(id == PaGlobal_GardenWorkerManagement._currentWorkerIndex)
  local workerWrapperLua = getWorkerWrapper(workerInfo._workerNo, true)
  local workerIcon = workerWrapperLua:getWorkerIcon()
  local workerGrade = workerWrapperLua:getGrade()
  local maxPoint = workerInfo._maxPoint
  local currentPoint = workerInfo._currentPoint
  local rate = math.ceil(100 * currentPoint / maxPoint)
  currentEnergy:SetText(tostring(currentPoint) .. "/" .. tostring(maxPoint))
  energyProgress:SetCurrentProgressRate(rate)
  energyProgress:SetProgressRate(rate)
  workerName:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  workerName:SetFontColor(ConvertFromGradeToColor(workerGrade))
  workerName:SetText(workerInfo._name)
  workerTown:SetText(workerInfo._regionName)
  workerImage:ChangeTextureInfoName(workerIcon)
  button:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventAUp_GardenWorkerManagement_SelectWorker(" .. id .. ")")
  button:addInputEvent("Mouse_On", "HandleEventMO_GardenWorkerManagement_FocusWorkerButton(" .. id .. ")")
  button:addInputEvent("Mouse_Out", "HandleEventMO_GardenWorkerManagement_FocusWorkerButton(-1)")
end

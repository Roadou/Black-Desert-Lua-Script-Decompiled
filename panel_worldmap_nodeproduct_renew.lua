local Window_WorldMap_NodeProductInfo = {
  _ui = {
    _static_CenterBg = UI.getChildControl(Panel_Worldmap_NodeProduct, "Static_CenterBg"),
    _static_BottomBg = UI.getChildControl(Panel_Worldmap_NodeProduct, "Static_BottomBg"),
    _static_NodeListBg = UI.getChildControl(Panel_Worldmap_NodeProduct, "Static_NodeListBg"),
    _static_FinanceBg = UI.getChildControl(Panel_Worldmap_NodeProduct, "Static_TopDescBg")
  },
  _config = {
    _financeGapY = 110,
    _panelDefaultSizeY,
    _centerBgDefaultPosY,
    _bottomBgDefaultPosY
  },
  _nodeTitleStartPosX = 0,
  _workerInfoList = {},
  _currentNodeInfo = {},
  _currentNodeIndex = 0,
  _currentWorkerIndex = 0,
  _currentFocusWorkerIndex = 0,
  _workerCount = 0,
  _subNodeCount = 0,
  _subNodeInfoList = {},
  _currentResourceList = {},
  _prevGetWearHouseKey,
  _currentExplorationNodeInClient,
  _keyGuideAlign = {}
}
function Window_WorldMap_NodeProductInfo:SetNodeData(explorationNodeInClient)
  self._currentNodeInfo = {}
  self._subNodeCount = 0
  self._subNodeInfoList = {}
  ToClient_FindSubNode(explorationNodeInClient:getPlantKey())
end
function Window_WorldMap_NodeProductInfo:SetWorkerData()
  self._workerInfoList = {}
  self._ui._list2_Worker:getElementManager():clearKey()
  local workingWorkerList = {}
  local sortMethod = 0
  local waitingWorkerCount = ToClient_getPlantWaitWorkerListCount(self._currentNodeInfo._plantKey, self._currentNodeInfo._workableType, self._currentNodeInfo._workKey, sortMethod)
  local workerIndex = 0
  local workingWorkerIndex = 0
  for index = 0, waitingWorkerCount - 1 do
    local npcWaitingWorker = ToClient_getPlantWaitWorkerByIndex(self._currentNodeInfo._plantKey, index)
    local workerNoRaw = npcWaitingWorker:getWorkerNo():get_s64()
    local workerWrapperLua = getWorkerWrapper(workerNoRaw, false)
    if false == workerWrapperLua:getIsAuctionInsert() and true == ToClient_getWorkerWorkerablePlant(npcWaitingWorker:getHomeWaypoint(), self._currentNodeInfo._plantKey:getWaypointKey()) then
      if nil == self._workerInfoList[workerIndex] then
        self._workerInfoList[workerIndex] = {}
      end
      local checkData = npcWaitingWorker:getStaticSkillCheckData()
      checkData:set(CppEnums.NpcWorkingType.eNpcWorkingType_PlantZone, houseUseType, self._currentNodeInfo._plantKey:getWaypointKey())
      checkData._diceCheckForceSuccess = true
      local firstWorkerNo = npcWaitingWorker:getWorkerNo()
      local workerNoChar = firstWorkerNo:get_s64()
      local npcWaitingWorkerSS = npcWaitingWorker:getWorkerStaticStatus()
      local workerNo = WorkerNo(workerNoChar)
      local houseUseType = CppEnums.eHouseUseType.Count
      local workSpeed = npcWaitingWorker:getWorkEfficienceWithSkill(checkData, self._currentNodeInfo._workableType)
      local moveSpeed = npcWaitingWorker:getMoveSpeedWithSkill(checkData) / 100
      local luck = npcWaitingWorker:getLuckWithSkill(checkData)
      local maxPoint = npcWaitingWorkerSS._actionPoint
      local currentPoint = npcWaitingWorker:getActionPoint()
      local workerRegionWrapper = ToClient_getRegionInfoWrapper(npcWaitingWorker)
      local workerGrade = npcWaitingWorkerSS:getCharacterStaticStatus()._gradeType:get()
      local name = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. npcWaitingWorker:getLevel() .. " " .. getWorkerName(npcWaitingWorkerSS)
      local regionName = "(<PAColor0xff868686>" .. workerRegionWrapper:getAreaName() .. "<PAOldColor>)"
      local homeWaypoint = npcWaitingWorker:getHomeWaypoint()
      if true == ToClient_isWaitWorker(npcWaitingWorker) then
        self._workerInfoList[workerIndex] = {
          _workerNo = workerNo,
          _workerNo_s64 = workerNoChar,
          _workerNoChar = Int64toInt32(workerNoChar),
          _name = name,
          _regionName = regionName,
          _workSpeed = workSpeed / 1000000,
          _moveSpeed = moveSpeed,
          _luck = luck / 10000,
          _maxPoint = maxPoint,
          _currentPoint = currentPoint,
          _homeWaypoint = homeWaypoint,
          _workerGrade = workerGrade
        }
        self._ui._list2_Worker:getElementManager():pushKey(toInt64(0, workerIndex))
        self._ui._list2_Worker:requestUpdateByKey(toInt64(0, workerIndex))
        workerIndex = workerIndex + 1
      else
        workingWorkerList[workingWorkerIndex] = {
          _workerNo = workerNo,
          _workerNo_s64 = workerNoChar,
          _workerNoChar = Int64toInt32(workerNoChar),
          _name = name,
          _regionName = regionName,
          _workSpeed = workSpeed / 1000000,
          _moveSpeed = moveSpeed,
          _luck = luck / 10000,
          _maxPoint = maxPoint,
          _currentPoint = currentPoint,
          _homeWaypoint = homeWaypoint,
          _workerGrade = workerGrade
        }
        workingWorkerIndex = workingWorkerIndex + 1
      end
    end
  end
  for index = 0, workingWorkerIndex - 1 do
    self._workerInfoList[workerIndex] = workingWorkerList[index]
    self._ui._list2_Worker:getElementManager():pushKey(toInt64(0, workerIndex))
    self._ui._list2_Worker:requestUpdateByKey(toInt64(0, workerIndex))
    workerIndex = workerIndex + 1
  end
  self._workerCount = workerIndex
end
function Window_WorldMap_NodeProductInfo:InitControl()
  self._config._panelDefaultSizeY = Panel_Worldmap_NodeProduct:GetSizeY()
  self._config._centerBgDefaultPosY = self._ui._static_CenterBg:GetPosY()
  self._config._bottomBgDefaultPosY = self._ui._static_BottomBg:GetPosY()
  self._ui._list2_Worker = UI.getChildControl(self._ui._static_CenterBg, "List2_Worker")
  self._ui._static_InfoBg = UI.getChildControl(self._ui._static_CenterBg, "Static_InfoBg")
  self._ui._static_WarningIcon = UI.getChildControl(self._ui._static_CenterBg, "StaticText_WarningIcon")
  self._ui._radioButton_NodeTemplate = UI.getChildControl(self._ui._static_NodeListBg, "RadioButton_NodeTemplate")
  self._ui._static_ProductIcon = UI.getChildControl(self._ui._static_InfoBg, "Static_Icon")
  self._ui._staticText_ProductDesc = UI.getChildControl(self._ui._static_InfoBg, "StaticText_Desc")
  self._ui._staticText_ProductDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._staticText_FinanceDesc = UI.getChildControl(self._ui._static_FinanceBg, "StaticText_Desc")
  self._ui._staticText_FinanceDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._staticText_FinanceTitle = UI.getChildControl(self._ui._static_FinanceBg, "StaticText_Title")
  self._ui._static_Icon = UI.getChildControl(self._ui._static_FinanceBg, "Static_Icon")
  self._ui._staticText_ProductName = UI.getChildControl(self._ui._static_InfoBg, "StaticText_Desc")
  self._ui._staticText_LeftTime = UI.getChildControl(self._ui._static_InfoBg, "StaticText_LeftTimeValue")
  self._ui._progress2_WorkTime = UI.getChildControl(self._ui._static_InfoBg, "Progress2_WorkTime")
  self._ui._staticText_WorkCount = UI.getChildControl(self._ui._static_InfoBg, "StaticText_WorkCountValue")
  self._ui._staticText_Distance = UI.getChildControl(self._ui._static_InfoBg, "StaticText_DistanceValue")
  self._ui._staticText_WorkSpeed = UI.getChildControl(self._ui._static_InfoBg, "StaticText_WorkSpeedValue")
  self._ui._staticText_MoveSpeed = UI.getChildControl(self._ui._static_InfoBg, "StaticText_MoveSpeedValue")
  self._ui._staticText_Luck = UI.getChildControl(self._ui._static_InfoBg, "StaticText_LuckValue")
  self._ui._static_KeyGuideLB = UI.getChildControl(self._ui._static_NodeListBg, "Static_LB_ConsoleUI")
  self._ui._static_KeyGuideRB = UI.getChildControl(self._ui._static_NodeListBg, "Static_RB_ConsoleUI")
  self._ui._static_KeyGuide_Repeat = UI.getChildControl(self._ui._static_BottomBg, "StaticText_Y_ConsoleUI")
  self._ui._static_KeyGuide_Select = UI.getChildControl(self._ui._static_BottomBg, "StaticText_A_ConsoleUI")
  self._ui._static_KeyGuide_DoWork = UI.getChildControl(self._ui._static_BottomBg, "StaticText_X_ConsoleUI")
  self._ui._static_KeyGuide_Close = UI.getChildControl(self._ui._static_BottomBg, "StaticText_B_ConsoleUI")
  self._keyGuideAlign = {
    self._ui._static_KeyGuide_DoWork,
    self._ui._static_KeyGuide_Repeat,
    self._ui._static_KeyGuide_Select,
    self._ui._static_KeyGuide_Close
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, 44, 10)
end
function Window_WorldMap_NodeProductInfo:InitEvent()
  self._ui._list2_Worker:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_WorldMap_NodeProduct_List2EventControlCreate")
  self._ui._list2_Worker:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  Panel_Worldmap_NodeProduct:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_WorldMap_NodeProduct_SelectNode(-1)")
  Panel_Worldmap_NodeProduct:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobalFunc_WorldMap_NodeProduct_SelectNode(1)")
  Panel_Worldmap_NodeProduct:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobal_NodeProduct_SetWorkCount()")
  Panel_Worldmap_NodeProduct:RegisterUpdateFunc("PaGlobalFunc_WorldMap_NodeProduct_UpdatePerFrame")
end
function Window_WorldMap_NodeProductInfo:InitRegister()
  registerEvent("FromClient_FindSubNode", "PaGlobalFunc_FromCLient_WorldMap_NodeProduct_FindSubNode")
  registerEvent("FromClient_FindSubNodeFinish", "PaGlobalFunc_FromCLient_WorldMap_NodeProduct_FindSubNodeFinish")
  registerEvent("WorldMap_WorkerDataUpdate", "PaGlobalFunc_FromCLient_WorldMap_NodeProduct_Update")
  registerEvent("WorldMap_StopWorkerWorking", "PaGlobalFunc_FromCLient_WorldMap_NodeProduct_StopWork")
  registerEvent("EventWarehouseUpdate", "PaGlobalFunc_FromCLient_WorldMap_NodeProduct_WareHouse_Update")
  registerEvent("FromClient_NotifyChangeRegionProductivity", "PaGlobalFunc_FromCLient_WorldMap_NodeProduct_NotifyChangeRegionProductivity")
end
function Window_WorldMap_NodeProductInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function PaGlobalFunc_WorldMap_NodeProduct_UpdatePerFrame(deltaTime)
  local self = Window_WorldMap_NodeProductInfo
  for index = 0, self._workerCount - 1 do
    self._ui._list2_Worker:requestUpdateByKey(toInt64(0, index))
  end
  local currentPlant = self._subNodeInfoList[self._currentNodeIndex]
  if nil == currentPlant then
    return
  end
  local plant = getPlant(currentPlant._plantKey)
  local workingCount = getWorkingList(plant)
  if 0 == workingCount then
    self._ui._progress2_WorkTime:SetProgressRate(0)
    return
  end
  for index = 0, workingCount - 1 do
    local worker = getWorkingByIndex(index).workerNo
    local workerNo = worker:get_s64()
    local workingProgress = getWorkingProgress(workerNo) * 100000
    local remainTime = Util.Time.timeFormatting(ToClient_getWorkingTime(workerNo))
    self._ui._staticText_LeftTime:SetText(remainTime)
    self._ui._progress2_WorkTime:SetProgressRate(workingProgress)
  end
end
function PaGlobalFunc_FromCLient_WorldMap_NodeProduct_NotifyChangeRegionProductivity()
  local self = Window_WorldMap_NodeProductInfo
  if false == PaGlobalFunc_WorldMap_NodeProduct_GetShow() then
    return
  end
  self:SetNodeData(self._currentExplorationNodeInClient)
end
function PaGlobalFunc_FromCLient_WorldMap_NodeProduct_StopWork()
  if false == PaGlobalFunc_WorldMap_NodeProduct_GetShow() then
    return
  end
  PaGlobalFunc_WorldMap_NodeProduct_SelectNode(0)
end
function PaGlobalFunc_FromCLient_WorldMap_NodeProduct_WareHouse_Update(affiliatedTownKey)
  local self = Window_WorldMap_NodeProductInfo
  if self._prevGetWearHouseKey == affiliatedTownKey then
    return
  end
  self._prevGetWearHouseKey = affiliatedTownKey
  local prevScrollIndex = self._ui._list2_Worker:getCurrenttoIndex()
  PaGlobalFunc_WorldMap_NodeProduct_SelectNode(0)
  self._ui._list2_Worker:moveIndex(prevScrollIndex)
end
function PaGlobalFunc_FromCLient_WorldMap_NodeProduct_Update()
  if false == PaGlobalFunc_WorldMap_NodeProduct_GetShow() then
    return
  end
  PaGlobalFunc_FromClient_WorldMap_UpdateExplorationNode()
  PaGlobalFunc_WorldMap_NodeProduct_SelectNode(0)
end
function PaGlobalFunc_FromCLient_WorldMap_NodeProduct_FindSubNodeFinish()
  local self = Window_WorldMap_NodeProductInfo
  self._ui._static_KeyGuideLB:SetShow(1 < self._subNodeCount)
  self._ui._static_KeyGuideRB:SetShow(1 < self._subNodeCount)
  PaGlobalFunc_WorldMap_NodeProduct_SelectNode(0)
  PaGlobalFunc_WorldMap_NodeProduct_SelectNode(0)
  PaGlobalFunc_WorldMap_NodeProduct_SelectWorker(0)
end
function PaGlobalFunc_FromCLient_WorldMap_NodeProduct_FindSubNode(explorationNodeInClient)
  local self = Window_WorldMap_NodeProductInfo
  if false == PaGlobalFunc_WorldMap_NodeProduct_GetShow() then
    return
  end
  if true ~= explorationNodeInClient:isMaxLevel() then
    return
  end
  self._subNodeInfoList[self._subNodeCount] = {}
  local plantKey = explorationNodeInClient:getPlantKey()
  local plant = getPlant(plantKey)
  if nil == plant then
    return
  end
  local _position = plant:getPositionInGame()
  local workableCnt = ToClient_getPlantWorkableListCount(plantKey)
  for index = 0, workableCnt - 1 do
    local workKey = ToClient_getPlantWorkableItemExchangeKeyByIndex(plantKey, index)
    local workName = ToClient_getPlantWorkableItemExchangeDescriptionByIndex(plantKey, index)
    local itemExchangeSS = ToClient_getPlantWorkableItemExchangeByIndex(plantKey, index)
    local esSSW = ToClient_getPlantWorkableItemExchangeWrapperByIndex(plantKey, index)
    local explorationSSW = ToClient_getExplorationStaticStatusWrapper(plantKey)
    local _workVolum = Int64toInt32(ToClient_getPlantCorpProductionApply(plantKey, itemExchangeSS._productTime)) / 1000
    local _workableType = itemExchangeSS._productCategory
    local itemStatic = itemExchangeSS:getFirstDropGroup():getItemStaticStatus()
    local _result_Name = getItemName(itemStatic)
    local _result_Icon = "icon/" .. getItemIconPath(itemStatic)
    local _result_Key = itemExchangeSS:getFirstDropGroup()._itemKey
    local eSSW = ToClient_getExplorationStaticStatusWrapper(plantKey:get())
    local _isFinance = eSSW:get():isFinance()
    self._subNodeInfoList[self._subNodeCount]._plantKey = plantKey
    self._subNodeInfoList[self._subNodeCount]._workKey = workKey
    self._subNodeInfoList[self._subNodeCount]._workableType = _workableType
    self._subNodeInfoList[self._subNodeCount]._workVolum = _workVolum
    self._subNodeInfoList[self._subNodeCount]._position = float3(_position.x, _position.y, _position.z)
    self._subNodeInfoList[self._subNodeCount]._result_Name = _result_Name
    self._subNodeInfoList[self._subNodeCount]._result_Icon = _result_Icon
    self._subNodeInfoList[self._subNodeCount]._result_Key = _result_Key
    self._subNodeInfoList[self._subNodeCount]._workingCount = 1
    self._subNodeInfoList[self._subNodeCount]._nodeName = getExploreNodeName(explorationNodeInClient:getStaticStatus())
    self._subNodeInfoList[self._subNodeCount]._isFinance = _isFinance
    self._subNodeInfoList[self._subNodeCount]._isFinanceDesc = esSSW:getDetailDescription()
    self._subNodeInfoList[self._subNodeCount]._isFinanceType = esSSW:getDescription()
    self._subNodeInfoList[self._subNodeCount]._financeIcon = "icon/" .. esSSW:getIcon()
    self._subNodeInfoList[self._subNodeCount]._itemExchangeSS = itemExchangeSS
    self._subNodeCount = self._subNodeCount + 1
  end
end
function PaGlobalFunc_WorldMap_NodeProduct_SelectNode(value)
  local self = Window_WorldMap_NodeProductInfo
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  self._currentNodeIndex = self._currentNodeIndex + value
  if self._currentNodeIndex < 0 then
    self._currentNodeIndex = self._subNodeCount - 1
  end
  if self._subNodeCount - 1 < self._currentNodeIndex then
    self._currentNodeIndex = 0
  end
  self._currentNodeInfo = self._subNodeInfoList[self._currentNodeIndex]
  if nil == self._currentNodeInfo then
    return
  end
  self:SetWorkerData()
  self._ui._radioButton_NodeTemplate:SetText(self._currentNodeInfo._nodeName)
  PaGlobalFunc_WorldMap_NodeProduct_SelectWorker(self._currentWorkerIndex)
  self:UpdateNodeUI(self._currentWorkerIndex)
  if true == PaGlobalFunc_WorldMap_NodeProduct_GetShow() then
    ToClient_padSnapResetControl()
  end
end
function PaGlobalFunc_WorldMap_NodeProduct_List2EventControlCreate(list_content, key)
  local self = Window_WorldMap_NodeProductInfo
  local id = Int64toInt32(key)
  local workerInfo = self._workerInfoList[id]
  if nil == workerInfo then
    return
  end
  local button = UI.getChildControl(list_content, "Radiobutton_ButtonBg")
  local workerImage = UI.getChildControl(list_content, "Static_WorkerImage")
  local EnergyProgress = UI.getChildControl(list_content, "Progress2_EnergyProgress")
  local workerName = UI.getChildControl(list_content, "StaticText_WorkerTitle")
  local workerTown = UI.getChildControl(list_content, "StaticText_Node")
  local remainTimeProgress = UI.getChildControl(list_content, "Progress2_RemainTimeProgress")
  local remainTimeVal = UI.getChildControl(list_content, "StaticText_RemainTime")
  local workingCount = UI.getChildControl(list_content, "StaticText_WorkingNameCount")
  local checkIcon = UI.getChildControl(list_content, "Static_CheckIcon")
  checkIcon:SetShow(id == self._currentWorkerIndex)
  button:SetCheck(id == self._currentWorkerIndex)
  local workerWrapperLua = getWorkerWrapper(workerInfo._workerNo_s64, true)
  local workerIcon = workerWrapperLua:getWorkerIcon()
  local workerGrade = workerWrapperLua:getGrade()
  local maxPoint = workerInfo._maxPoint
  local currentPoint = workerInfo._currentPoint
  local rate = math.ceil(100 * currentPoint / maxPoint)
  EnergyProgress:SetCurrentProgressRate(rate)
  EnergyProgress:SetProgressRate(rate)
  workerName:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  workerName:SetFontColor(ConvertFromGradeToColor(workerGrade))
  workerName:SetText(workerInfo._name)
  button:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_NodeProduct_SelectWorker(" .. id .. ")")
  button:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_NodeProduct_SetSelectButton(" .. id .. ")")
  button:addInputEvent("Mouse_Out", "PaGlobalFunc_WorldMap_NodeProduct_SetSelectButton(-1)")
  workerImage:ChangeTextureInfoName(workerIcon)
  workerTown:SetText(workerInfo._regionName)
  local progressRate = ToClient_getWorkingProgress(workerInfo._workerNo_s64) * 100000
  local remainTime = Util.Time.timeFormatting(ToClient_getLeftWorkingTime(workerInfo._workerNo_s64))
  workingCount:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  workingCount:SetText(workerWrapperLua:getWorkString())
  remainTimeProgress:SetProgressRate(progressRate)
end
function PaGlobalFunc_WorldMap_NodeProduct_SelectWorker(id)
  if false == Panel_Worldmap_NodeProduct:GetShow() then
    return
  end
  local self = Window_WorldMap_NodeProductInfo
  local prevWorker = self._currentWorkerIndex
  self._currentWorkerIndex = id
  local workerInfo = self._workerInfoList[id]
  if nil == workerInfo then
    return
  end
  local nodeInfo = self._currentNodeInfo
  if nil == nodeInfo then
    return
  end
  local affiliatedTownKey = workerInfo._homeWaypoint
  if self._prevGetWearHouseKey ~= affiliatedTownKey then
    warehouse_requestInfo(affiliatedTownKey)
  end
  if nil ~= workerInfo then
    Panel_Worldmap_NodeProduct:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_WorldMap_NodeProduct_DoWork(" .. id .. ")")
  else
    Panel_Worldmap_NodeProduct:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  end
  self._ui._list2_Worker:requestUpdateByKey(toInt64(0, prevWorker))
  self._ui._list2_Worker:requestUpdateByKey(toInt64(0, self._currentWorkerIndex))
  self:UpdateNodeUI(self._currentWorkerIndex)
  PaGlobalFunc_WorldMap_NodeProduct_SetSelectButton(-1)
end
function PaGlobalFunc_WorldMap_NodeProduct_SetSelectButton(index)
  local self = Window_WorldMap_NodeProductInfo
  self._currentFocusWorkerIndex = index
  self._ui._static_KeyGuide_Select:SetShow(self._currentWorkerIndex ~= index)
  if -1 == index then
    self._ui._static_KeyGuide_Select:SetShow(false)
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, 44, 10)
end
function Window_WorldMap_NodeProductInfo:Clear()
  self._prevGetWearHouseKey = -1
  self._ui._list2_Worker:getElementManager():clearKey()
  self._ui._static_KeyGuide_Select:SetShow(false)
  self._ui._static_KeyGuide_DoWork:SetShow(false)
  self._ui._static_KeyGuide_Repeat:SetShow(false)
  self._ui._radioButton_NodeTemplate:SetText("--")
  self._ui._staticText_LeftTime:SetText("--")
  self._ui._staticText_WorkCount:SetText("--")
  self._ui._staticText_Distance:SetText("--")
  self._ui._staticText_WorkSpeed:SetText("--")
  self._ui._staticText_MoveSpeed:SetText("--")
  self._ui._staticText_Luck:SetText("--")
  self._ui._static_ProductIcon:ChangeTextureInfoName("")
  self._ui._staticText_ProductName:SetText("--")
  Panel_Worldmap_NodeProduct:SetSize(Panel_Worldmap_NodeProduct:GetSizeX(), self._config._panelDefaultSizeY - self._config._financeGapY)
  self._ui._static_CenterBg:SetPosY(self._config._centerBgDefaultPosY - self._config._financeGapY)
  self._ui._static_BottomBg:SetPosY(self._config._bottomBgDefaultPosY - self._config._financeGapY)
  self._ui._static_WarningIcon:SetShow(false)
  self._ui._static_FinanceBg:SetShow(false)
end
function Window_WorldMap_NodeProductInfo:UpdateNodeUI(id)
  local workerInfo = self._workerInfoList[id]
  local nodeInfo = self._currentNodeInfo
  if nil == nodeInfo then
    return
  end
  local name = nodeInfo._result_Name
  local icon = nodeInfo._result_Icon
  local workVolume = nodeInfo._workVolum
  self._ui._static_ProductIcon:ChangeTextureInfoName(icon)
  self._ui._staticText_ProductName:SetText(name)
  if nil ~= workerInfo then
    local distance = ToClient_getCalculateMoveDistance(workerInfo._workerNo, nodeInfo._position) / 100
    local workSpeed = workerInfo._workSpeed
    local moveSpeed = workerInfo._moveSpeed
    local luck = workerInfo._luck
    local workBaseTime = ToClient_getNpcWorkingBaseTime() / 1000
    local totalWorkTime = math.ceil(workVolume / math.floor(workSpeed)) * workBaseTime + distance / moveSpeed * 2
    self._ui._staticText_LeftTime:SetText(Util.Time.timeFormatting(math.floor(totalWorkTime)))
    self._ui._staticText_WorkCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", nodeInfo._workingCount))
    self._ui._staticText_Distance:SetText(string.format("%.0f", distance))
    self._ui._staticText_WorkSpeed:SetText(string.format("%.2f", workSpeed))
    self._ui._staticText_MoveSpeed:SetText(string.format("%.2f", moveSpeed))
    self._ui._staticText_Luck:SetText(string.format("%.2f", luck))
  else
    self._ui._staticText_LeftTime:SetText("--")
    self._ui._staticText_WorkCount:SetText("--")
    self._ui._staticText_Distance:SetText("--")
    self._ui._staticText_WorkSpeed:SetText("--")
    self._ui._staticText_MoveSpeed:SetText("--")
    self._ui._staticText_Luck:SetText("--")
  end
  self._ui._static_KeyGuide_Select:SetShow(self._currentWorkerIndex ~= id)
  self._ui._static_KeyGuide_DoWork:SetShow(nil ~= workerInfo)
  self._ui._static_KeyGuide_Repeat:SetShow(nil ~= workerInfo)
  self._ui._static_WarningIcon:SetShow(false)
  self._ui._static_FinanceBg:SetShow(false)
  Panel_Worldmap_NodeProduct:SetSize(Panel_Worldmap_NodeProduct:GetSizeX(), self._config._panelDefaultSizeY - self._config._financeGapY)
  self._ui._static_CenterBg:SetPosY(self._config._centerBgDefaultPosY - self._config._financeGapY)
  self._ui._static_BottomBg:SetPosY(self._config._bottomBgDefaultPosY - self._config._financeGapY)
  if true == nodeInfo._isFinance then
    self:DataSetForFinance(id)
    self:UISetForFinance(id)
  end
end
function Window_WorldMap_NodeProductInfo:UISetForFinance(workerIndex)
  self._ui._static_FinanceBg:SetShow(true)
  Panel_Worldmap_NodeProduct:SetSize(Panel_Worldmap_NodeProduct:GetSizeX(), self._config._panelDefaultSizeY)
  self._ui._static_CenterBg:SetPosY(self._config._centerBgDefaultPosY)
  self._ui._static_BottomBg:SetPosY(self._config._bottomBgDefaultPosY)
  local workerInfo = self._workerInfoList[workerIndex]
  local nodeInfo = self._currentNodeInfo
  if nil == nodeInfo then
    return
  end
  self._ui._static_Icon:ChangeTextureInfoName(nodeInfo._financeIcon)
  self._ui._staticText_FinanceTitle:SetText(nodeInfo._nodeName)
  self._ui._staticText_FinanceDesc:SetText(nodeInfo._isFinanceDesc)
  self._ui._static_WarningIcon:SetShow(nil ~= workerInfo)
  self._ui._static_KeyGuide_DoWork:SetShow(false)
  self._ui._static_KeyGuide_Repeat:SetShow(false)
  if true == self._currentResourceList[0]._isCraftable then
    self._ui._static_WarningIcon:SetShow(false)
    self._ui._static_KeyGuide_DoWork:SetShow(true)
    self._ui._static_KeyGuide_Repeat:SetShow(true)
  end
  self._ui._staticText_ProductName:SetText(self._ui._staticText_ProductName:GetText() .. "(" .. self._currentResourceList[0]._haveCount .. " / " .. self._currentResourceList[0]._needCount .. ")")
end
function Window_WorldMap_NodeProductInfo:DataSetForFinance(workerIndex)
  local workerInfo = self._workerInfoList[workerIndex]
  local nodeInfo = self._currentNodeInfo
  if nil == nodeInfo then
    return
  end
  self._currentResourceList = {}
  local esSS = nodeInfo._itemExchangeSS
  local eSSCount = getExchangeSourceNeedItemList(esSS, true)
  for index = 0, eSSCount - 1 do
    self._currentResourceList[index] = {}
    local itemStaticInfomationWrapper = getExchangeSourceNeedItemByIndex(index)
    local itemStaticWrapper = itemStaticInfomationWrapper:getStaticStatus()
    local itemStatic = itemStaticWrapper:get()
    local itemKey = itemStaticInfomationWrapper:getKey()
    local _gradeType = itemStaticWrapper:getGradeType()
    local resourceKey = itemStatic._key
    local itemIcon = "icon/" .. getItemIconPath(itemStatic)
    local needCount = Int64toInt32(itemStaticInfomationWrapper:getCount_s64())
    local haveCount = 0
    if nil ~= workerInfo and 0 ~= workerInfo._homeWaypoint then
      haveCount = Int64toInt32(warehouse_getItemCount(workerInfo._homeWaypoint, itemKey))
    end
    self._currentResourceList[index] = {
      _itemKey = itemKey,
      _resourceKey = resourceKey,
      _itemIcon = itemIcon,
      _needCount = needCount,
      _haveCount = haveCount,
      _gradeType = _gradeType,
      _isCraftable = needCount <= haveCount
    }
  end
end
local function set_Workable_Count(inputNumber)
  local self = Window_WorldMap_NodeProductInfo
  if nil == Window_WorldMap_NodeProductInfo._currentNodeInfo then
    return
  end
  self._currentNodeInfo._workingCount = Int64toInt32(inputNumber)
  self._ui._staticText_WorkCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", self._currentNodeInfo._workingCount))
end
function PaGlobal_NodeProduct_SetWorkCount()
  local self = Window_WorldMap_NodeProductInfo
  if false == self._ui._static_KeyGuide_Repeat:GetShow() then
    return
  end
  if nil == self._currentNodeInfo then
    return
  end
  local s64_MaxWorkableCount = toInt64(0, 50000)
  Panel_NumberPad_Show(true, s64_MaxWorkableCount, nil, set_Workable_Count, false, nil)
end
function PaGlobalFunc_WorldMap_NodeProduct_DoWork(id)
  local self = Window_WorldMap_NodeProductInfo
  if false == self._ui._static_KeyGuide_DoWork:GetShow() then
    return
  end
  if workerManager_CheckWorkingOtherChannelAndMsg() then
    return
  end
  local workerInfo = self._workerInfoList[id]
  if nil == workerInfo then
    return
  end
  if nil == self._currentNodeInfo then
    return
  end
  local workingCount = self._currentNodeInfo._workingCount
  ToClient_requestStartPlantWorkingToNpcWorker(workerInfo._workerNo, self._currentNodeInfo._plantKey, self._currentNodeInfo._workKey, workingCount)
  PaGlobal_TutorialManager:handleClickPlantdoWork(self._currentNodeInfo._plantKey, self._currentNodeInfo._workingCount)
end
function PaGlobalFunc_WorldMap_NodeProduct_GetShow()
  return Panel_Worldmap_NodeProduct:GetShow()
end
function PaGlobalFunc_WorldMap_NodeProduct_SetShow(isShow, isAni)
  Panel_Worldmap_NodeProduct:SetShow(isShow, isAni)
end
function PaGlobalFunc_WorldMap_NodeProduct_Open(explorationNodeInClient)
  local self = Window_WorldMap_NodeProductInfo
  if true == PaGlobalFunc_WorldMap_NodeProduct_GetShow() then
    return
  end
  self:Clear()
  self._currentExplorationNodeInClient = explorationNodeInClient
  PaGlobalFunc_WorldMap_NodeProduct_SetShow(true, false)
  self:SetNodeData(explorationNodeInClient)
  PaGlobalFunc_WorldMap_RingMenu_Close()
  PaGlobalFunc_WorldMap_TopMenu_Close()
  PaGlobalFunc_WorldMap_BottomMenu_Close()
end
function PaGlobalFunc_WorldMap_NodeProduct_Close()
  local self = Window_WorldMap_NodeProductInfo
  if false == PaGlobalFunc_WorldMap_NodeProduct_GetShow() then
    return
  end
  self:Clear()
  PaGlobalFunc_WorldMap_RingMenu_Open()
  PaGlobalFunc_WorldMap_TopMenu_Open()
  PaGlobalFunc_WorldMap_BottomMenu_Open()
  PaGlobalFunc_WorldMap_NodeProduct_SetShow(false, false)
end
function PaGlobalFunc_FromClient_WorldMap_NodeProduct_luaLoadComplete()
  local self = Window_WorldMap_NodeProductInfo
  self:Initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_WorldMap_NodeProduct_luaLoadComplete")

Panel_Plant_WorkManager:setMaskingChild(true)
Panel_Plant_WorkManager:setGlassBackground(true)
Panel_Plant_WorkManager:TEMP_UseUpdateListSwap(true)
Panel_Plant_WorkManager:ActiveMouseEventEffect(true)
local defalut_Control = {
  _title = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Title"),
  _btn_Close = UI.getChildControl(Panel_Plant_WorkManager, "Button_Win_Close"),
  _btn_Question = UI.getChildControl(Panel_Plant_WorkManager, "Button_Question"),
  _Button_DoWork = UI.getChildControl(Panel_Plant_WorkManager, "Button_doWork"),
  _worker_List = {
    _BG = UI.getChildControl(Panel_Plant_WorkManager, "Static_WorkerList_BG"),
    _Title = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_WorkerList_Title"),
    _Scroll = UI.getChildControl(Panel_Plant_WorkManager, "Scroll_WorkerList"),
    _No_Worker = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_NoWorker"),
    _Button = {},
    _Progress = {},
    _ActionPoint = {},
    _RegionName = {},
    _Template = {
      _Button = UI.getChildControl(Panel_Plant_WorkManager, "RadioButton_Worker"),
      _Progress = UI.getChildControl(Panel_Plant_WorkManager, "Progress2_Worker_ActionPoint"),
      _ActionPoint = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Worker_ActionPoint"),
      _RegionName = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Worker_RegionName"),
      _rowMax = 13,
      _row_PosY_Gap = 5
    }
  },
  _work_Info = {
    _BG = UI.getChildControl(Panel_Plant_WorkManager, "Static_WorkInfo_BG"),
    _Title = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_WorkInfo_Title"),
    _Result_BG = UI.getChildControl(Panel_Plant_WorkManager, "Static_WorkInfo_Result_BG"),
    _Result_Title = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_WorkInfo_Result_Title"),
    _Result_Icon_BG_1 = UI.getChildControl(Panel_Plant_WorkManager, "Static_WorkInfo_Result_Icon_BG_1"),
    _Result_Icon_BG_2 = UI.getChildControl(Panel_Plant_WorkManager, "Static_WorkInfo_Result_Icon_BG_2"),
    _Result_Icon = UI.getChildControl(Panel_Plant_WorkManager, "Static_WorkInfo_Result_Icon"),
    _Result_Name = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_WorkInfo_Result_Name"),
    _Time_BG = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Estimated_Time_BG"),
    _Time_Value = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Estimated_Time_Value"),
    _Time_Count = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Estimated_Time_Count"),
    _Work_Count = UI.getChildControl(Panel_Plant_WorkManager, "Button_Estimated_Work_Count"),
    _Work_BG = UI.getChildControl(Panel_Plant_WorkManager, "Static_Estimated_Work_BG"),
    _Work_Volume_Text = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Estimated_WorkVolum_Text"),
    _Work_Volume_Value = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Estimated_WorkVolum_Value"),
    _Work_Speed_Text = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Estimated_WorkSpeed_Text"),
    _Work_Speed_Value = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Estimated_WorkSpeed_Value"),
    _Move_BG = UI.getChildControl(Panel_Plant_WorkManager, "Static_Estimated_Move_BG"),
    _Move_Distance_Text = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Estimated_MoveDistance_Text"),
    _Move_Distance_Value = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Estimated_MoveDistance_Value"),
    _Move_Speed_Text = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Estimated_MoveSpeed_Text"),
    _Move_Speed_Value = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Estimated_MoveSpeed_Value"),
    _Luck_BG = UI.getChildControl(Panel_Plant_WorkManager, "Static_Estimated_Luck_BG"),
    _Luck_Text = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Estimated_Luck_Text"),
    _Luck_Value = UI.getChildControl(Panel_Plant_WorkManager, "StaticText_Estimated_Luck_Value")
  }
}
defalut_Control._btn_Question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"HouseManageWork\" )")
defalut_Control._btn_Question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"HouseManageWork\", \"true\")")
defalut_Control._btn_Question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"HouseManageWork\", \"false\")")
function defalut_Control:Init_Control()
  FGlobal_AddChild(Panel_Plant_WorkManager, self._worker_List._BG, self._worker_List._Scroll)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._worker_List._BG, self._worker_List._No_Worker)
  FGlobal_Set_Table_Control(self._worker_List, "_Button", "_Button", true, false)
  FGlobal_Set_Table_Control(self._worker_List, "_Progress", "_Button", true, false)
  FGlobal_Set_Table_Control(self._worker_List, "_ActionPoint", "_Button", true, false)
  FGlobal_Set_Table_Control(self._worker_List, "_RegionName", "_Button", true, false)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Title)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Result_BG)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Result_Title)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Result_Icon_BG_1)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Result_Icon_BG_2)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Result_Icon)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Result_Name)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Time_BG)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Time_Value)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Time_Count)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Work_Count)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Work_BG)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Work_Volume_Text)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Work_Volume_Value)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Work_Speed_Text)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Work_Speed_Value)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Move_BG)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Move_Distance_Text)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Move_Distance_Value)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Move_Speed_Text)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Move_Speed_Value)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Luck_BG)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Luck_Text)
  FGlobal_AddChild(Panel_Plant_WorkManager, self._work_Info._BG, self._work_Info._Luck_Value)
end
defalut_Control:Init_Control()
function defalut_Control:Init_Function()
  self._btn_Close:addInputEvent("Mouse_LUp", "FGlobal_Plant_WorkManager_Close()")
  self._Button_DoWork:addInputEvent("Mouse_LUp", "HandleClick_Plant_doWork()")
  self._work_Info._Work_Count:addInputEvent("Mouse_LUp", "HandleClicked_WorkCount_Plant()")
  self._worker_List._BG:addInputEvent("Mouse_UpScroll", "HandleScroll_Plant_Worker_List_UpDown(true)")
  self._worker_List._BG:addInputEvent("Mouse_DownScroll", "HandleScroll_Plant_Worker_List_UpDown(false)")
  self._worker_List._Scroll:addInputEvent("Mouse_UpScroll", "HandleScroll_Plant_Worker_List_UpDown(true)")
  self._worker_List._Scroll:addInputEvent("Mouse_DownScroll", "HandleScroll_Plant_Worker_List_UpDown(false)")
  self._worker_List._Scroll:addInputEvent("Mouse_LDown", "HandleScroll_Plant_Worker_List_OnClick()")
  self._worker_List._Scroll:addInputEvent("Mouse_LUp", "HandleScroll_Plant_Worker_List_OnClick()")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_UpScroll", "HandleScroll_Plant_Worker_List_UpDown(true)")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_DownScroll", "HandleScroll_Plant_Worker_List_UpDown(false)")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LDown", "HandleScroll_Plant_Worker_List_OnClick()")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LUp", "HandleScroll_Plant_Worker_List_OnClick()")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LPress", "HandleScroll_Plant_Worker_List_OnClick()")
  for key, value in pairs(self._worker_List._Button) do
    value:addInputEvent("Mouse_On", "HandleOn_Plant_Worker_List(" .. key .. ")")
    value:addInputEvent("Mouse_Out", "HandleOut_Plant_Worker_List()")
    value:addInputEvent("Mouse_UpScroll", "HandleScroll_Plant_Worker_List_UpDown(true)")
    value:addInputEvent("Mouse_DownScroll", "HandleScroll_Plant_Worker_List_UpDown(false)")
  end
  self._work_Info._Result_Icon_BG_2:addInputEvent("Mouse_On", "Item_Tooltip_Show_PlantResult()")
  self._work_Info._Result_Icon_BG_2:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
end
defalut_Control:Init_Function()
local Work_Info = {
  _plantKey = nil,
  _workKey = nil,
  _workableType = nil,
  _workVolum = nil,
  _position = nil,
  _result_name = nil,
  _result_Icon = nil,
  _result_Key = nil,
  _workingCount = 1
}
function Work_Info:_setData(node)
  local plantKey = node:getPlantKey()
  return Work_Info:_setDataByPlantKey(plantKey)
end
function Work_Info:_setDataByPlantKey(plantKey)
  local _position = getPlant(plantKey):getPositionInGame()
  local workableCnt = ToClient_getPlantWorkableListCount(plantKey)
  for index = 1, workableCnt do
    local _workKey = ToClient_getPlantWorkableItemExchangeKeyByIndex(plantKey, index - 1)
    local _workName = ToClient_getPlantWorkableItemExchangeDescriptionByIndex(plantKey, index - 1)
    local itemExchangeSS = ToClient_getPlantWorkableItemExchangeByIndex(plantKey, index - 1)
    local _workVolum = Int64toInt32(ToClient_getPlantCorpProductionApply(plantKey, itemExchangeSS._productTime)) / 1000
    local _workableType = itemExchangeSS._productCategory
    local itemStatic = itemExchangeSS:getFirstDropGroup():getItemStaticStatus()
    local _result_Name = getItemName(itemStatic)
    local _result_Icon = "icon/" .. getItemIconPath(itemStatic)
    local _result_Key = itemExchangeSS:getFirstDropGroup()._itemKey
    Work_Info._plantKey = plantKey
    Work_Info._workKey = _workKey
    Work_Info._workableType = _workableType
    Work_Info._workVolum = _workVolum
    Work_Info._position = float3(_position.x, _position.y, _position.z)
    Work_Info._result_Name = _result_Name
    Work_Info._result_Icon = _result_Icon
    Work_Info._result_Key = _result_Key
  end
end
local Worker_List = {
  _data_Table = {},
  _rowMax = defalut_Control._worker_List._Template._rowMax,
  _contentRow = nil,
  _offsetIndex = nil,
  _offset_Max = nil,
  _selected_Worker = nil,
  _selected_Index = nil,
  _over_Index = nil
}
local sortIndex = {}
local homeWayKey = {}
local sortDistanceValue = {}
local function Worker_SortByRegionInfo()
  local sortMethod = 0
  local waitingWorkerCount = ToClient_getPlantWaitWorkerListCount(Work_Info._plantKey, Work_Info._workableType, Work_Info._workKey, sortMethod)
  if 0 == waitingWorkerCount then
    return
  end
  local workVolume = Work_Info._workVolum
  local possibleWorkerIndex = 0
  for index = 1, waitingWorkerCount do
    local npcWaitingWorker = ToClient_getPlantWaitWorkerByIndex(Work_Info._plantKey, index - 1)
    local workerNoRaw = npcWaitingWorker:getWorkerNo():get_s64()
    local workerWrapperLua = getWorkerWrapper(workerNoRaw, false)
    if true == ToClient_isWaitWorker(npcWaitingWorker) and false == workerWrapperLua:getIsAuctionInsert() then
      possibleWorkerIndex = possibleWorkerIndex + 1
      local workerData = Worker_List._data_Table[possibleWorkerIndex]
      local distance = ToClient_getCalculateMoveDistance(workerData._workerNo, Work_Info._position) / 100
      local workSpeed = workerData._workSpeed
      local moveSpeed = workerData._moveSpeed
      local workBaseTime = ToClient_getNpcWorkingBaseTime() / 1000
      local totalWorkTime = math.ceil(workVolume / workSpeed) * workBaseTime + distance / moveSpeed * 2
      sortIndex[possibleWorkerIndex] = Int64toInt32(totalWorkTime)
      homeWayKey[possibleWorkerIndex] = Worker_List._data_Table[possibleWorkerIndex]._homeWaypoint
      sortDistanceValue[possibleWorkerIndex] = distance
    end
  end
  local possibleWorkerCount = possibleWorkerIndex
  for ii = 1, possibleWorkerCount do
    local temp
    for i = possibleWorkerCount, 1, -1 do
      if i > 1 and sortIndex[i] < sortIndex[i - 1] then
        temp = Worker_List._data_Table[i]
        Worker_List._data_Table[i] = Worker_List._data_Table[i - 1]
        Worker_List._data_Table[i - 1] = temp
        temp = sortIndex[i]
        sortIndex[i] = sortIndex[i - 1]
        sortIndex[i - 1] = temp
        temp = sortDistanceValue[i]
        sortDistanceValue[i] = sortDistanceValue[i - 1]
        sortDistanceValue[i - 1] = temp
      end
    end
    if nil == temp then
      break
    end
  end
  local temp
  local function workerDataSwap(index, sortCount)
    if index ~= sortCount and Worker_List._data_Table[index]._homeWaypoint ~= Worker_List._data_Table[sortCount]._homeWaypoint then
      temp = Worker_List._data_Table[index]
      Worker_List._data_Table[index] = Worker_List._data_Table[sortCount]
      Worker_List._data_Table[sortCount] = temp
      temp = sortDistanceValue[index]
      sortDistanceValue[index] = sortDistanceValue[sortCount]
      sortDistanceValue[sortCount] = temp
    end
  end
  local territory = {}
  if 0 < FGlobal_WayPointKey_Return() and FGlobal_WayPointKey_Return() <= 300 then
    territory[0] = true
    territory[1] = false
    territory[2] = false
    territory[3] = false
  elseif FGlobal_WayPointKey_Return() >= 301 and FGlobal_WayPointKey_Return() <= 600 then
    territory[0] = false
    territory[1] = true
    territory[2] = false
    territory[3] = false
  elseif FGlobal_WayPointKey_Return() >= 601 and 1000 >= FGlobal_WayPointKey_Return() then
    territory[0] = false
    territory[1] = false
    territory[2] = true
    territory[3] = false
  elseif FGlobal_WayPointKey_Return() >= 1101 then
    territory[0] = false
    territory[1] = false
    territory[2] = false
    territory[3] = true
  end
  local _sortCount = 0
  for ii = _sortCount + 1, possibleWorkerCount do
    if Worker_List._data_Table[ii]._homeWaypoint == FGlobal_WayPointKey_Return() then
      _sortCount = _sortCount + 1
      if ii ~= _sortCount then
        workerDataSwap(ii, _sortCount)
      end
    end
  end
  local function sortByRegion(territoryKey)
    local sortTerritoryCount = 0
    local startValue = _sortCount + 1
    if startValue > possibleWorkerCount then
      return
    end
    if 0 == territoryKey then
      for jj = startValue, possibleWorkerCount do
        if 0 < Worker_List._data_Table[jj]._homeWaypoint and Worker_List._data_Table[jj]._homeWaypoint <= 300 then
          if startValue ~= jj then
            workerDataSwap(jj, startValue + sortTerritoryCount)
          end
          _sortCount = _sortCount + 1
          sortTerritoryCount = sortTerritoryCount + 1
        end
      end
    elseif 1 == territoryKey then
      for jj = startValue, possibleWorkerCount do
        if Worker_List._data_Table[jj]._homeWaypoint >= 301 and Worker_List._data_Table[jj]._homeWaypoint <= 600 then
          if startValue ~= jj then
            workerDataSwap(jj, startValue + sortTerritoryCount)
          end
          _sortCount = _sortCount + 1
          sortTerritoryCount = sortTerritoryCount + 1
        end
      end
    elseif 2 == territoryKey then
      for jj = startValue, possibleWorkerCount do
        if Worker_List._data_Table[jj]._homeWaypoint >= 601 and Worker_List._data_Table[jj]._homeWaypoint <= 1000 then
          if startValue ~= jj then
            workerDataSwap(jj, startValue + sortTerritoryCount)
          end
          _sortCount = _sortCount + 1
          sortTerritoryCount = sortTerritoryCount + 1
        end
      end
    elseif 3 == territoryKey then
      for jj = startValue, possibleWorkerCount do
        if Worker_List._data_Table[jj]._homeWaypoint >= 1101 then
          if startValue ~= jj then
            workerDataSwap(jj, startValue + sortTerritoryCount)
          end
          _sortCount = _sortCount + 1
          sortTerritoryCount = sortTerritoryCount + 1
        end
      end
    end
    if sortTerritoryCount > 1 then
      for ii = startValue + 1, startValue + sortTerritoryCount - 1 do
        for jj = startValue + sortTerritoryCount - 1, startValue + 1, -1 do
          if sortDistanceValue[jj] < sortDistanceValue[jj - 1] then
            workerDataSwap(jj, jj - 1)
          end
        end
      end
    end
  end
  if possibleWorkerCount ~= _sortCount then
    if true == territory[0] then
      sortByRegion(0)
      sortByRegion(1)
      sortByRegion(2)
      sortByRegion(3)
    elseif true == territory[1] then
      sortByRegion(1)
      sortByRegion(0)
      sortByRegion(2)
      sortByRegion(3)
    elseif true == territory[2] then
      sortByRegion(2)
      sortByRegion(1)
      sortByRegion(0)
      sortByRegion(3)
    elseif true == territory[3] then
      sortByRegion(3)
      sortByRegion(1)
      sortByRegion(0)
      sortByRegion(2)
    end
  end
end
function Worker_List:_setData()
  local sortMethod = 0
  local waitingWorkerCount = ToClient_getPlantWaitWorkerListCount(Work_Info._plantKey, Work_Info._workableType, Work_Info._workKey, sortMethod)
  self._data_Table = {}
  local _idx = 0
  for Index = 1, waitingWorkerCount do
    local npcWaitingWorker = ToClient_getPlantWaitWorkerByIndex(Work_Info._plantKey, Index - 1)
    local workerNoRaw = npcWaitingWorker:getWorkerNo():get_s64()
    local workerWrapperLua = getWorkerWrapper(workerNoRaw, false)
    if true == ToClient_isWaitWorker(npcWaitingWorker) and false == workerWrapperLua:getIsAuctionInsert() then
      _idx = _idx + 1
      if nil == self._data_Table[_idx] then
        self._data_Table[_idx] = {}
      end
      local checkData = npcWaitingWorker:getStaticSkillCheckData()
      checkData:set(CppEnums.NpcWorkingType.eNpcWorkingType_PlantZone, houseUseType, Work_Info._plantKey:getWaypointKey())
      checkData._diceCheckForceSuccess = true
      local firstWorkerNo = npcWaitingWorker:getWorkerNo()
      local workerNoChar = firstWorkerNo:get_s64()
      local npcWaitingWorkerSS = npcWaitingWorker:getWorkerStaticStatus()
      local workerNo = WorkerNo(workerNoChar)
      local houseUseType = CppEnums.eHouseUseType.Count
      local workSpeed = npcWaitingWorker:getWorkEfficienceWithSkill(checkData, Work_Info._workableType)
      local moveSpeed = npcWaitingWorker:getMoveSpeedWithSkill(checkData) / 100
      local luck = npcWaitingWorker:getLuckWithSkill(checkData)
      local maxPoint = npcWaitingWorkerSS._actionPoint
      local currentPoint = npcWaitingWorker:getActionPoint()
      local workerRegionWrapper = ToClient_getRegionInfoWrapper(npcWaitingWorker)
      local workerGrade = npcWaitingWorkerSS:getCharacterStaticStatus()._gradeType:get()
      local name = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. npcWaitingWorker:getLevel() .. " " .. getWorkerName(npcWaitingWorkerSS)
      local regionName = "(<PAColor0xff868686>" .. workerRegionWrapper:getAreaName() .. "<PAOldColor>)"
      local homeWaypoint = npcWaitingWorker:getHomeWaypoint()
      self._data_Table[_idx] = {
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
    end
  end
  local _offset_Max = _idx - self._rowMax
  if _offset_Max < 0 then
    _offset_Max = 0
  end
  self._offset_Max = _offset_Max
  self._offsetIndex = 0
  self._contentRow = _idx
  UIScroll.SetButtonSize(defalut_Control._worker_List._Scroll, self._rowMax, self._contentRow)
  Worker_SortByRegionInfo()
end
function Worker_List:_updateSlot()
  FGlobal_Clear_Control(defalut_Control._worker_List._Button)
  FGlobal_Clear_Control(defalut_Control._worker_List._ActionPoint)
  FGlobal_Clear_Control(defalut_Control._worker_List._Progress)
  FGlobal_Clear_Control(defalut_Control._worker_List._RegionName)
  for index = 1, self._rowMax do
    local _dataIndex = self._offsetIndex + index
    local data = self._data_Table[_dataIndex]
    if nil == data then
      break
    end
    local name = data._name
    local regionName = data._regionName
    local actionPoint = tostring(data._currentPoint) .. "/" .. tostring(data._maxPoint)
    local preogressRate = math.floor(data._currentPoint / data._maxPoint * 100)
    local workerGrade = data._workerGrade
    defalut_Control._worker_List._Button[index]:SetFontColor(ConvertFromGradeToColor(workerGrade))
    defalut_Control._worker_List._Button[index]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    defalut_Control._worker_List._Button[index]:SetText(name .. " " .. regionName)
    defalut_Control._worker_List._Button[index]:addInputEvent("Mouse_LUp", "Plant_Worker_List_Select(" .. index .. ")")
    defalut_Control._worker_List._ActionPoint[index]:SetText(actionPoint)
    defalut_Control._worker_List._Progress[index]:SetProgressRate(preogressRate)
    defalut_Control._worker_List._Button[index]:SetShow(true)
    defalut_Control._worker_List._Progress[index]:SetShow(true)
    if Worker_List._selected_WorkerKey == data._workerNoChar then
      defalut_Control._worker_List._Button[index]:SetCheck(true)
      defalut_Control._worker_List._ActionPoint[index]:SetShow(true)
    else
      defalut_Control._worker_List._Button[index]:SetCheck(false)
      defalut_Control._worker_List._ActionPoint[index]:SetShow(false)
    end
  end
  defalut_Control._worker_List._Scroll:SetControlPos(self._offsetIndex / self._offset_Max)
  HandleOn_Plant_Worker_List_Refresh()
end
local affiliatedTownKey
function Plant_Worker_List_Select(index)
  if Panel_Window_Exchange_Number:IsShow() then
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  end
  local selectedIndex = Worker_List._offsetIndex + index
  if nil ~= Worker_List._data_Table[selectedIndex] then
    Worker_List._selected_Worker = Worker_List._data_Table[selectedIndex]._workerNo
    Worker_List._selected_WorkerKey = Worker_List._data_Table[selectedIndex]._workerNoChar
    Worker_List._selected_Index = selectedIndex
    affiliatedTownKey = Worker_List._data_Table[selectedIndex]._homeWaypoint
    warehouse_requestInfo(affiliatedTownKey)
    defalut_Control._worker_List._No_Worker:SetShow(false)
  else
    defalut_Control._worker_List._No_Worker:SetShow(true)
  end
  if nil == Worker_List._data_Table[selectedIndex] then
    defalut_Control._work_Info._Time_Count:SetShow(false)
    defalut_Control._work_Info._Work_Count:SetShow(false)
  elseif 0 < Worker_List._data_Table[selectedIndex]._currentPoint then
    defalut_Control._work_Info._Time_Count:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_ONCE"))
    defalut_Control._work_Info._Time_Count:SetShow(true)
    defalut_Control._work_Info._Work_Count:SetShow(true)
  else
    defalut_Control._work_Info._Time_Count:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_ONCE"))
    defalut_Control._work_Info._Time_Count:SetShow(true)
    defalut_Control._work_Info._Work_Count:SetShow(false)
  end
  Work_Info._workingCount = 1
  defalut_Control._work_Info._Time_Count:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", Work_Info._workingCount))
  Worker_List:_updateSlot()
  Plant_Work_Info_Update()
end
function HandleOn_Plant_Worker_List(index)
  Worker_List._over_Index = index
  defalut_Control._worker_List._ActionPoint[index]:SetShow(true)
  Plant_Work_Info_Update(true)
  local self = Worker_List
  local workerIndex = self._offsetIndex + index
  local npcWaitingWorker = ToClient_getNpcWorkerByWorkerNo(Worker_List._data_Table[workerIndex]._workerNo_s64)
  if nil ~= npcWaitingWorker then
    local uiBase = defalut_Control._worker_List._Button[index]
    FGlobal_ShowWorkerTooltipByWorkerNoRaw(Worker_List._data_Table[workerIndex]._workerNo_s64, uiBase, false, true)
  end
end
function HandleOut_Plant_Worker_List()
  Worker_List._over_Index = nil
  Worker_List:_updateSlot()
  Plant_Work_Info_Update()
  FGlobal_HideWorkerTooltip()
end
function HandleOn_Plant_Worker_List_Refresh()
  if nil ~= Worker_List._over_Index then
    HandleOn_Plant_Worker_List(Worker_List._over_Index)
  end
end
function Plant_Work_Info_Update(isWorkerOver)
  local name = Work_Info._result_Name
  local icon = Work_Info._result_Icon
  defalut_Control._work_Info._Result_Icon:ChangeTextureInfoName(icon)
  defalut_Control._work_Info._Result_Name:SetText(name)
  local workVolume = Work_Info._workVolum
  defalut_Control._work_Info._Work_Volume_Value:SetText(": " .. string.format("%.2f", workVolume))
  local workerIndex = Worker_List._selected_Index
  if true == isWorkerOver then
    workerIndex = Worker_List._offsetIndex + Worker_List._over_Index
  end
  local workerData = Worker_List._data_Table[workerIndex]
  if nil ~= workerData then
    local distance = ToClient_getCalculateMoveDistance(workerData._workerNo, Work_Info._position) / 100
    local workSpeed = workerData._workSpeed
    local moveSpeed = workerData._moveSpeed
    local luck = workerData._luck
    defalut_Control._work_Info._Move_Distance_Value:SetText(": " .. string.format("%.0f", distance))
    defalut_Control._work_Info._Work_Speed_Value:SetText(": " .. string.format("%.2f", workSpeed))
    defalut_Control._work_Info._Move_Speed_Value:SetText(": " .. string.format("%.2f", moveSpeed))
    defalut_Control._work_Info._Luck_Value:SetText(": " .. string.format("%.2f", luck))
    local workBaseTime = ToClient_getNpcWorkingBaseTime() / 1000
    local totalWorkTime = math.ceil(workVolume / math.floor(workSpeed)) * workBaseTime + distance / moveSpeed * 2
    defalut_Control._work_Info._Time_Value:SetText(Util.Time.timeFormatting(math.floor(totalWorkTime)))
  else
    defalut_Control._work_Info._Move_Distance_Value:SetText("--")
    defalut_Control._work_Info._Work_Speed_Value:SetText("--")
    defalut_Control._work_Info._Move_Speed_Value:SetText("--")
    defalut_Control._work_Info._Luck_Value:SetText("--")
    defalut_Control._work_Info._Time_Value:SetText("--")
  end
end
local Scroll_UpDown = function(isUp, _target)
  if false == isUp then
    _target._offsetIndex = math.min(_target._offset_Max, _target._offsetIndex + 1)
  else
    _target._offsetIndex = math.max(0, _target._offsetIndex - 1)
  end
  _target:_updateSlot()
end
function HandleScroll_Plant_Worker_List_UpDown(isUp)
  Scroll_UpDown(isUp, Worker_List)
end
local ScrollOnClick = function(_target, _scroll)
  local _scroll_Button = _scroll:GetControlButton()
  local _scroll_Blank = _scroll:GetSizeY() - _scroll_Button:GetSizeY()
  local _scroll_Percent = _scroll_Button:GetPosY() / _scroll_Blank
  _target._offsetIndex = math.floor(_scroll_Percent * _target._offset_Max)
  _target:_updateSlot()
end
function HandleScroll_Plant_Worker_List_OnClick()
  ScrollOnClick(Worker_List, defalut_Control._worker_List._Scroll)
end
function Item_Tooltip_Show_PlantResult()
  local staticStatusKey = Work_Info._result_Key
  local uiBase = defalut_Control._work_Info._Result_Icon_BG_1
  if nil == staticStatusKey or nil == uiBase then
    return
  end
  local staticStatusWrapper = getItemEnchantStaticStatus(staticStatusKey)
  Panel_Tooltip_Item_Show(staticStatusWrapper, uiBase, true, false)
end
function FGlobal_Plant_WorkManager_Open(node)
  WorldMapPopupManager:push(Panel_Plant_WorkManager, true)
  if nil == node then
    return
  end
  Worker_List._selected_Worker = nil
  Worker_List._selected_WorkerKey = nil
  Worker_List._selected_Index = nil
  Worker_List._over_Index = nil
  Work_Info:_setData(node)
  Worker_List:_setData()
  Worker_List:_updateSlot()
  Plant_Worker_List_Select(1)
  local nodeName = getExploreNodeName(node:getStaticStatus())
  defalut_Control._title:SetText(nodeName)
end
function FGlobal_Plant_WorkManager_Close()
  FGlobal_WorldMapWindowEscape()
end
function FGlobal_Plant_WorkManager_Reset_Pos()
  local PosX = (getScreenSizeX() - Panel_Plant_WorkManager:GetSizeX()) / 2
  local PosY = (getScreenSizeY() - Panel_Plant_WorkManager:GetSizeY()) / 2
  Panel_Plant_WorkManager:SetPosX(PosX)
  Panel_Plant_WorkManager:SetPosY(PosY)
end
function HandleClick_Plant_doWork()
  if workerManager_CheckWorkingOtherChannelAndMsg() then
    return
  end
  if nil == Worker_List._selected_Worker then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
    return
  end
  local workingCount = Work_Info._workingCount
  local doWorkNow = ToClient_requestStartPlantWorkingToNpcWorker(Worker_List._selected_Worker, Work_Info._plantKey, Work_Info._workKey, workingCount)
  FGlobal_RedoWork(2, nil, Worker_List._selected_Worker, Work_Info._plantKey, Work_Info._workKey, nil, workingCount, nil, nil, affiliatedTownKey)
  if doWorkNow then
    Panel_Plant_WorkManager:SetShow(false)
    FGlobal_ShowWorkingProgress(FGlobal_SelectedNode(), 1)
  end
  PaGlobal_TutorialManager:handleClickPlantdoWork(Work_Info._plantKey, Work_Info._workingCount)
end
function FromClient_Plant_StopWork()
  if Panel_Plant_WorkManager:GetShow() then
    Worker_List:_setData()
    Worker_List:_updateSlot()
    if nil == Worker_List._selected_Index then
      Plant_Worker_List_Select(1)
    end
  end
end
function LimitWorkableCount_Plant()
  local workerActionPoint = Worker_List._data_Table[Worker_List._selected_Index]._currentPoint
  return workerActionPoint
end
local function set_Workable_Count(inputNumber)
  Work_Info._workingCount = Int64toInt32(inputNumber)
  defalut_Control._work_Info._Time_Count:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", Work_Info._workingCount))
end
function HandleClicked_WorkCount_Plant()
  local s64_MaxWorkableCount = toInt64(0, 50000)
  if s64_MaxWorkableCount <= toInt64(0, 0) then
    _PA_LOG("\236\157\180\235\172\184\236\162\133", "\236\157\188\234\190\188\236\157\180 \236\158\145\236\151\133\237\149\160 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.")
  else
    Panel_NumberPad_Show(true, s64_MaxWorkableCount, 0, set_Workable_Count, false)
  end
end
function FromClient_NotifyChangeRegionProductivity()
  if Panel_Plant_WorkManager:GetShow() then
    Work_Info:_setDataByPlantKey(Work_Info._plantKey)
    Plant_Work_Info_Update()
  end
end
registerEvent("WorldMap_StopWorkerWorking", "FromClient_Plant_StopWork")
registerEvent("FromClient_NotifyChangeRegionProductivity", "FromClient_NotifyChangeRegionProductivity")

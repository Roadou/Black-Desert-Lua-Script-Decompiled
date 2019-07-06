Panel_Harvest_WorkManager:setMaskingChild(true)
Panel_Harvest_WorkManager:setGlassBackground(true)
Panel_Harvest_WorkManager:TEMP_UseUpdateListSwap(true)
Panel_Harvest_WorkManager:ActiveMouseEventEffect(true)
local defalut_Control = {
  _title = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_Title"),
  _btn_Close = UI.getChildControl(Panel_Harvest_WorkManager, "Button_Win_Close"),
  _btn_Question = UI.getChildControl(Panel_Harvest_WorkManager, "Button_Question"),
  _Button_DoWork = UI.getChildControl(Panel_Harvest_WorkManager, "Button_doWork"),
  _worker_List = {
    _BG = UI.getChildControl(Panel_Harvest_WorkManager, "Static_WorkerList_BG"),
    _Title = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_WorkerList_Title"),
    _Scroll = UI.getChildControl(Panel_Harvest_WorkManager, "Scroll_WorkerList"),
    _No_Worker = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_NoWorker"),
    _Button = {},
    _Progress = {},
    _ActionPoint = {},
    _RegionName = {},
    _Template = {
      _Button = UI.getChildControl(Panel_Harvest_WorkManager, "RadioButton_Worker"),
      _Progress = UI.getChildControl(Panel_Harvest_WorkManager, "Progress2_Worker_ActionPoint"),
      _ActionPoint = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_Worker_ActionPoint"),
      _RegionName = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_Worker_RegionName"),
      _rowMax = 12,
      _row_PosY_Gap = 2
    }
  },
  _work_Info = {
    _BG = UI.getChildControl(Panel_Harvest_WorkManager, "Static_WorkInfo_BG"),
    _Title = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_WorkInfo_Title"),
    _Result_BG = UI.getChildControl(Panel_Harvest_WorkManager, "Static_WorkInfo_Result_BG"),
    _Result_Title = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_WorkInfo_Result_Title"),
    _Result_Icon_BG_1 = UI.getChildControl(Panel_Harvest_WorkManager, "Static_WorkInfo_Result_Icon_BG_1"),
    _Result_Icon_BG_2 = UI.getChildControl(Panel_Harvest_WorkManager, "Static_WorkInfo_Result_Icon_BG_2"),
    _Result_Icon = UI.getChildControl(Panel_Harvest_WorkManager, "Static_WorkInfo_Result_Icon"),
    _Result_Name = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_WorkInfo_Result_Name"),
    _Time_BG = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_Estimated_Time_BG"),
    _Time_Value = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_Estimated_Time_Value"),
    _Time_Count = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_Estimated_Time_Count"),
    _Work_Count = UI.getChildControl(Panel_Harvest_WorkManager, "Button_Estimated_Work_Count"),
    _Move_BG = UI.getChildControl(Panel_Harvest_WorkManager, "Static_Estimated_Move_BG"),
    _Move_Distance_Text = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_Estimated_MoveDistance_Text"),
    _Move_Distance_Value = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_Estimated_MoveDistance_Value"),
    _Move_Speed_Text = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_Estimated_MoveSpeed_Text"),
    _Move_Speed_Value = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_Estimated_MoveSpeed_Value"),
    _Luck_BG = UI.getChildControl(Panel_Harvest_WorkManager, "Static_Estimated_Luck_BG"),
    _Luck_Text = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_Estimated_Luck_Text"),
    _Luck_Value = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_Estimated_Luck_Value"),
    _Work_BG = UI.getChildControl(Panel_Harvest_WorkManager, "Static_WorkDesc_BG"),
    _Work_Volume_Text = UI.getChildControl(Panel_Harvest_WorkManager, "StaticText_WorkDesc_Text")
  }
}
defalut_Control._btn_Question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"HouseManageWork\" )")
defalut_Control._btn_Question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"HouseManageWork\", \"true\")")
defalut_Control._btn_Question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"HouseManageWork\", \"false\")")
function defalut_Control:Init_Control()
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._worker_List._BG, self._worker_List._Title)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._worker_List._BG, self._worker_List._Scroll)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._worker_List._BG, self._worker_List._No_Worker)
  FGlobal_Set_Table_Control(self._worker_List, "_Button", "_Button", true, false)
  FGlobal_Set_Table_Control(self._worker_List, "_Progress", "_Button", true, false)
  FGlobal_Set_Table_Control(self._worker_List, "_ActionPoint", "_Button", true, false)
  FGlobal_Set_Table_Control(self._worker_List, "_RegionName", "_Button", true, false)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Title)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Result_BG)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Result_Title)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Result_Icon_BG_1)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Result_Icon_BG_2)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Result_Icon)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Result_Name)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Time_BG)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Time_Value)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Time_Count)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Work_Count)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Move_BG)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Move_Distance_Text)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Move_Distance_Value)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Move_Speed_Text)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Move_Speed_Value)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Luck_BG)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Luck_Text)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Luck_Value)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Work_BG)
  FGlobal_AddChild(Panel_Harvest_WorkManager, self._work_Info._BG, self._work_Info._Work_Volume_Text)
  self._work_Info._Work_Volume_Text:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._work_Info._Work_Volume_Text:SetText(self._work_Info._Work_Volume_Text:GetText())
end
defalut_Control:Init_Control()
function defalut_Control:Init_Function()
  self._btn_Close:addInputEvent("Mouse_LUp", "FGlobal_Harvest_WorkManager_Close()")
  self._Button_DoWork:addInputEvent("Mouse_LUp", "HandleClick_Harvest_doWork()")
  self._worker_List._BG:addInputEvent("Mouse_UpScroll", "HandleScroll_Harvest_Worker_List_UpDown(true)")
  self._worker_List._BG:addInputEvent("Mouse_DownScroll", "HandleScroll_Harvest_Worker_List_UpDown(false)")
  self._worker_List._Scroll:addInputEvent("Mouse_UpScroll", "HandleScroll_Harvest_Worker_List_UpDown(true)")
  self._worker_List._Scroll:addInputEvent("Mouse_DownScroll", "HandleScroll_Harvest_Worker_List_UpDown(false)")
  self._worker_List._Scroll:addInputEvent("Mouse_LDown", "HandleScroll_Harvest_Worker_List_OnClick()")
  self._worker_List._Scroll:addInputEvent("Mouse_LUp", "HandleScroll_Harvest_Worker_List_OnClick()")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_UpScroll", "HandleScroll_Harvest_Worker_List_UpDown(true)")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_DownScroll", "HandleScroll_Harvest_Worker_List_UpDown(false)")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LDown", "HandleScroll_Harvest_Worker_List_OnClick()")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LUp", "HandleScroll_Harvest_Worker_List_OnClick()")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LPress", "HandleScroll_Harvest_Worker_List_OnClick()")
  for key, value in pairs(self._worker_List._Button) do
    value:addInputEvent("Mouse_On", "HandleOn_Harvest_Worker_List(" .. key .. ")")
    value:addInputEvent("Mouse_Out", "HandleOut_Harvest_Worker_List()")
    value:addInputEvent("Mouse_UpScroll", "HandleScroll_Harvest_Worker_List_UpDown(true)")
    value:addInputEvent("Mouse_DownScroll", "HandleScroll_Harvest_Worker_List_UpDown(false)")
  end
end
defalut_Control:Init_Function()
local Work_Info = {
  _workKey = nil,
  _workableType = nil,
  _workVolum = nil,
  _position = nil,
  _result_name = nil,
  _result_Icon = nil,
  _result_Key = nil,
  _workingCount = 1
}
function Work_Info:_setData(index)
  return Work_Info:_setDataByIndex(index)
end
function Work_Info:_setDataByIndex(index)
  local temporaryWrapper = getTemporaryInformationWrapper()
  local householdDataWithInstallationWrapper = temporaryWrapper:getSelfTentWrapperByIndex(index)
  if nil == householdDataWithInstallationWrapper then
    return
  end
  local tentWrapper = temporaryWrapper:getSelfTentWrapperByIndex(index)
  local tentPosX = tentWrapper:getSelfTentPositionX()
  local tentPosY = tentWrapper:getSelfTentPositionY()
  local tentPosZ = tentWrapper:getSelfTentPositionZ()
  local _position = float3(tentPosX, tentPosY, tentPosZ)
  local characterStaticStatusWrapper = householdDataWithInstallationWrapper:getHouseholdCharacterStaticStatusWrapper()
  if nil ~= characterStaticStatusWrapper then
    local _workName = characterStaticStatusWrapper:getName()
    Work_Info._result_Name = _workName
    Work_Info._position = float3(_position.x, _position.y, _position.z)
    local itemSSW = characterStaticStatusWrapper:getItemEnchantStatcStaticWrapper()
    if nil ~= itemSSW then
      defalut_Control._work_Info._Result_Icon:ChangeTextureInfoName("icon/" .. itemSSW:getIconPath())
      Work_Info._result_Key = itemSSW:get()._key:get()
      defalut_Control._work_Info._Result_Icon_BG_2:addInputEvent("Mouse_On", "Item_Tooltip_Show_HarvestResult()")
      defalut_Control._work_Info._Result_Icon_BG_2:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    end
  end
  local regionWrapper = ToClient_getRegionInfoWrapperByPosition(_position)
  defalut_Control._title:SetText(regionWrapper:getAreaName())
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
  local waitingWorkerCount = 0
  local workerArray = Array.new()
  workerArray = getWaitWorkerFullList()
  for index = 1, #workerArray do
    local workerWrapperLua = getWorkerWrapper(workerArray[index], false)
    if nil ~= workerWrapperLua then
      if CppEnums.NpcWorkingType.eNpcWorkingType_Count == workerWrapperLua:getWorkingType() and false == workerWrapperLua:getIsAuctionInsert() then
        waitingWorkerCount = waitingWorkerCount + 1
        local workerData = Worker_List._data_Table[waitingWorkerCount]
        local distance = ToClient_getCalculateMoveDistance(WorkerNo(workerData._workerNo), Work_Info._position) / 100
        local moveSpeed = workerData._moveSpeed
        local totalWorkTime = distance / moveSpeed * 2
        sortIndex[waitingWorkerCount] = Int64toInt32(totalWorkTime)
        homeWayKey[waitingWorkerCount] = Worker_List._data_Table[waitingWorkerCount]._homeWaypoint
        sortDistanceValue[waitingWorkerCount] = distance
      else
        _PA_LOG("\236\157\180\235\172\184\236\162\133", "index == " .. index .. " : \236\157\188\237\149\152\235\138\148\236\164\145")
      end
    end
  end
  if 0 == waitingWorkerCount then
    return
  end
  local possibleWorkerCount = waitingWorkerCount
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
end
function Worker_List:_setData()
  local sortMethod = 0
  local workerArray = Array.new()
  workerArray = getWaitWorkerFullList()
  self._data_Table = {}
  local _idx = 0
  for index = 1, #workerArray do
    local workerWrapper = getWorkerWrapper(workerArray[index], false)
    if nil ~= workerWrapper then
      if CppEnums.NpcWorkingType.eNpcWorkingType_Count == workerWrapper:getWorkingType() and not workerWrapper:getIsAuctionInsert() then
        _idx = _idx + 1
        if nil == self._data_Table[_idx] then
          self._data_Table[_idx] = {}
        end
        local workerNo = workerArray[index]
        local moveSpeed = workerWrapper:getMoveSpeedWithSkill(CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking, CppEnums.eHouseUseType.count, 0) / 100
        local luck = workerWrapper:getLuckWithSkill(CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking, CppEnums.eHouseUseType.count, 0)
        local maxPoint = workerWrapper:getMaxActionPoint()
        local currentPoint = workerWrapper:getActionPoint()
        local homeWaypoint = workerWrapper:getHomeWaypoint()
        local regionInfo = ToClient_getRegionInfoWrapperByWaypoint(homeWaypoint)
        local workerGrade = workerWrapper:getGrade()
        local name = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. workerWrapper:getLevel() .. " " .. workerWrapper:getName()
        local regionName = "(<PAColor0xff868686>" .. regionInfo:getAreaName() .. "<PAOldColor>)"
        self._data_Table[_idx] = {
          _workerNo = workerNo,
          _name = name,
          _regionName = regionName,
          _moveSpeed = moveSpeed,
          _luck = luck / 10000,
          _maxPoint = maxPoint,
          _currentPoint = currentPoint,
          _homeWaypoint = homeWaypoint,
          _workerGrade = workerGrade
        }
      else
        _PA_LOG("\236\157\180\235\172\184\236\162\133", "index == " .. index .. " : \236\157\188\237\149\152\235\138\148\236\164\145")
      end
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
    defalut_Control._worker_List._Button[index]:addInputEvent("Mouse_LUp", "Harvest_Worker_List_Select(" .. index .. ")")
    defalut_Control._worker_List._ActionPoint[index]:SetText(actionPoint)
    defalut_Control._worker_List._Progress[index]:SetProgressRate(preogressRate)
    defalut_Control._worker_List._Button[index]:SetShow(true)
    defalut_Control._worker_List._ActionPoint[index]:SetShow(true)
    defalut_Control._worker_List._Progress[index]:SetShow(true)
    if Worker_List._selected_WorkerKey == data._workerNo then
      defalut_Control._worker_List._Button[index]:SetCheck(true)
      defalut_Control._worker_List._ActionPoint[index]:SetShow(true)
    else
      defalut_Control._worker_List._Button[index]:SetCheck(false)
      defalut_Control._worker_List._ActionPoint[index]:SetShow(false)
    end
  end
  defalut_Control._worker_List._Scroll:SetControlPos(self._offsetIndex / self._offset_Max)
  HandleOn_Harvest_Worker_List_Refresh()
end
function Harvest_Worker_List_Select(index)
  local selectedIndex = Worker_List._offsetIndex + index
  if nil ~= Worker_List._data_Table[selectedIndex] then
    Worker_List._selected_Worker = Worker_List._data_Table[selectedIndex]._workerNo
    Worker_List._selected_WorkerKey = Worker_List._data_Table[selectedIndex]._workerNo
    Worker_List._selected_Index = selectedIndex
    defalut_Control._worker_List._No_Worker:SetShow(false)
  else
    defalut_Control._worker_List._No_Worker:SetShow(true)
  end
  if nil == Worker_List._data_Table[selectedIndex] then
    defalut_Control._work_Info._Time_Count:SetShow(false)
    defalut_Control._work_Info._Work_Count:SetShow(false)
  elseif 0 < Worker_List._data_Table[selectedIndex]._currentPoint then
    defalut_Control._work_Info._Time_Count:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_ONCE"))
    defalut_Control._work_Info._Time_Count:SetShow(false)
    defalut_Control._work_Info._Work_Count:SetShow(false)
  else
    defalut_Control._work_Info._Time_Count:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_ONCE"))
    defalut_Control._work_Info._Time_Count:SetShow(false)
    defalut_Control._work_Info._Work_Count:SetShow(false)
  end
  Work_Info._workingCount = 1
  defalut_Control._work_Info._Time_Count:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", Work_Info._workingCount))
  Worker_List:_updateSlot()
  Harvest_Work_Info_Update()
end
function HandleOn_Harvest_Worker_List(index)
  Worker_List._over_Index = index
  defalut_Control._worker_List._ActionPoint[index]:SetShow(true)
  Harvest_Work_Info_Update(true)
  local self = Worker_List
  local workerIndex = self._offsetIndex + index
  local workerArray = Array.new()
  workerArray = getWaitWorkerFullList()
  local workerWrapper = getWorkerWrapper(workerArray[workerIndex], false)
  if nil ~= workerWrapper then
    local uiBase = defalut_Control._worker_List._Button[index]
    FGlobal_ShowWorkerTooltipByWorkerNoRaw(Worker_List._data_Table[workerIndex]._workerNo, uiBase, true)
  end
end
function HandleOut_Harvest_Worker_List()
  Worker_List._over_Index = nil
  Worker_List:_updateSlot()
  Harvest_Work_Info_Update()
  FGlobal_HideWorkerTooltip()
end
function HandleOn_Harvest_Worker_List_Refresh()
  if nil ~= Worker_List._over_Index then
    HandleOn_Harvest_Worker_List(Worker_List._over_Index)
  end
end
function Harvest_Work_Info_Update(isWorkerOver)
  local name = Work_Info._result_Name
  defalut_Control._work_Info._Result_Name:SetText(name)
  local workerIndex = Worker_List._selected_Index
  if nil ~= isWorkerOver and true == isWorkerOver then
    workerIndex = Worker_List._offsetIndex + Worker_List._over_Index
  end
  local workerData = Worker_List._data_Table[workerIndex]
  if nil ~= workerData then
    local distance = ToClient_getCalculateMoveDistance(WorkerNo(workerData._workerNo), Work_Info._position) / 100
    local workSpeed = workerData._workSpeed
    local moveSpeed = workerData._moveSpeed
    local luck = workerData._luck
    defalut_Control._work_Info._Move_Distance_Value:SetText(": " .. string.format("%.0f", distance))
    defalut_Control._work_Info._Move_Speed_Value:SetText(": " .. string.format("%.2f", moveSpeed))
    defalut_Control._work_Info._Luck_Value:SetText(": " .. string.format("%.2f", luck))
    local totalWorkTime = distance / moveSpeed * 2
    defalut_Control._work_Info._Time_Value:SetText(Util.Time.timeFormatting(math.floor(totalWorkTime)))
  else
    defalut_Control._work_Info._Move_Distance_Value:SetText("--")
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
function HandleScroll_Harvest_Worker_List_UpDown(isUp)
  Scroll_UpDown(isUp, Worker_List)
end
local ScrollOnClick = function(_target, _scroll)
  local _scroll_Button = _scroll:GetControlButton()
  local _scroll_Blank = _scroll:GetSizeY() - _scroll_Button:GetSizeY()
  local _scroll_Percent = _scroll_Button:GetPosY() / _scroll_Blank
  _target._offsetIndex = math.floor(_scroll_Percent * _target._offset_Max)
  _target:_updateSlot()
end
function HandleScroll_Harvest_Worker_List_OnClick()
  ScrollOnClick(Worker_List, defalut_Control._worker_List._Scroll)
end
function Item_Tooltip_Show_HarvestResult()
  local staticStatusKey = Work_Info._result_Key
  local uiBase = defalut_Control._work_Info._Result_Icon_BG_2
  if nil == staticStatusKey or nil == uiBase then
    return
  end
  local staticStatusWrapper = getItemEnchantStaticStatus(ItemEnchantKey(staticStatusKey))
  Panel_Tooltip_Item_Show(staticStatusWrapper, uiBase, true, false)
end
local _index
function FGlobal_Harvest_WorkManager_Open(index)
  local temporaryWrapper = getTemporaryInformationWrapper()
  local householdDataWithInstallationWrapper = temporaryWrapper:getSelfTentWrapperByIndex(index)
  if nil == householdDataWithInstallationWrapper then
    return
  end
  Worker_List._selected_Worker = nil
  Worker_List._selected_WorkerKey = nil
  Worker_List._selected_Index = nil
  Worker_List._over_Index = nil
  Work_Info:_setData(index)
  Worker_List:_setData()
  Worker_List:_updateSlot()
  Harvest_Worker_List_Select(1)
  Panel_Harvest_WorkManager:SetShow(true)
  _index = index
  if Panel_HarvestList:GetShow() then
    Panel_Harvest_WorkManager:SetPosX(getScreenSizeX() / 2 - Panel_Harvest_WorkManager:GetSizeX() / 2)
    Panel_Harvest_WorkManager:SetPosY(getScreenSizeY() / 2 - Panel_Harvest_WorkManager:GetSizeY() / 2)
  else
    Panel_Harvest_WorkManager:SetPosX(getScreenSizeX() / 2 - Panel_Harvest_WorkManager:GetSizeX() / 2)
    Panel_Harvest_WorkManager:SetPosY(getScreenSizeY() / 2 - Panel_Harvest_WorkManager:GetSizeY() / 2)
  end
end
function FGlobal_Harvest_WorkManager_Close()
  if ToClient_WorldMapIsShow() then
    FGlobal_WorldMapWindowEscape()
  else
    Panel_Harvest_WorkManager:SetShow(false)
  end
end
function FGlobal_Harvest_WorkManager_Reset_Pos()
  local PosX = (getScreenSizeX() - Panel_Harvest_WorkManager:GetSizeX()) / 2
  local PosY = (getScreenSizeY() - Panel_Harvest_WorkManager:GetSizeY()) / 2
  Panel_Harvest_WorkManager:SetPosX(PosX)
  Panel_Harvest_WorkManager:SetPosY(PosY)
end
function HandleClick_Harvest_doWork()
  if workerManager_CheckWorkingOtherChannelAndMsg() then
    return
  end
  if nil == Worker_List._selected_Worker then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
    return
  end
  local workingCount = Work_Info._workingCount
  local temporaryWrapper = getTemporaryInformationWrapper()
  local householdDataWithInstallationWrapper = temporaryWrapper:getSelfTentWrapperByIndex(_index)
  if nil == householdDataWithInstallationWrapper then
    return
  end
  if Worker_List._data_Table[Worker_List._selected_Index]._currentPoint < 2 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_HARVEST_MESSAGE_NEEDACTIONPOINT"))
    return
  end
  local houseHoldNo = householdDataWithInstallationWrapper:getHouseholdNo()
  ToClient_requestStartHarvestWorking(houseHoldNo, WorkerNo(Worker_List._selected_Worker))
  Panel_Harvest_WorkManager:SetShow(false)
end
function FromClient_Harvest_StopWork()
  if Panel_Harvest_WorkManager:GetShow() then
    Worker_List:_setData()
    Worker_List:_updateSlot()
    if nil == Worker_List._selected_Index then
      Harvest_Worker_List_Select(1)
    end
  end
end
function LimitWorkableCount_Harvest()
  local workerActionPoint = Worker_List._data_Table[Worker_List._selected_Index]._currentPoint
  return workerActionPoint
end
local function set_Workable_Count(inputNumber)
  Work_Info._workingCount = Int64toInt32(inputNumber)
  defalut_Control._work_Info._Time_Count:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", Work_Info._workingCount))
end
function HandleClicked_WorkCount_Harvest()
  local s64_MaxWorkableCount = toInt64(0, LimitWorkableCount_Harvest())
  if s64_MaxWorkableCount <= toInt64(0, 0) then
    _PA_LOG("\236\157\180\235\172\184\236\162\133", "\236\157\188\234\190\188\236\157\180 \236\158\145\236\151\133\237\149\160 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.")
  else
    Panel_NumberPad_Show(true, s64_MaxWorkableCount, 0, set_Workable_Count, false)
  end
end
function WorldMap_WorkerDataUpdateByHarvestWorking(workerNoRaw)
  FGlobal_HarvestList_Update()
end
registerEvent("WorldMap_StopWorkerWorking", "FromClient_Harvest_StopWork")
registerEvent("WorldMap_WorkerDataUpdateByHarvestWorking", "WorldMap_WorkerDataUpdateByHarvestWorking")

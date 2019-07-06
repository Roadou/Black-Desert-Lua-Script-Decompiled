Panel_Finance_WorkManager:setMaskingChild(true)
Panel_Finance_WorkManager:setGlassBackground(true)
Panel_Finance_WorkManager:TEMP_UseUpdateListSwap(true)
Panel_Finance_WorkManager:ActiveMouseEventEffect(true)
local UI_TM = CppEnums.TextMode
local _position, _plantKey, wayPlant
local _affiliatedTownKey = 0
local defalut_Control = {
  _title = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_Title"),
  _btn_Close = UI.getChildControl(Panel_Finance_WorkManager, "Button_Win_Close"),
  _btn_Question = UI.getChildControl(Panel_Finance_WorkManager, "Button_Question"),
  _Button_DoWork = UI.getChildControl(Panel_Finance_WorkManager, "Button_doWork"),
  _Button_NoResource = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_NoResource"),
  _workInfo_Default = {
    _BG = UI.getChildControl(Panel_Finance_WorkManager, "Static_WorkInfo_Default_BG"),
    _Icon_BG = UI.getChildControl(Panel_Finance_WorkManager, "Static_WorkInfo_Default_Icon_BG"),
    _Icon = UI.getChildControl(Panel_Finance_WorkManager, "Static_WorkInfo_Default_Icon"),
    _Type = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_WorkInfo_Default_Type"),
    _Desc = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_WorkInfo_Default_Desc")
  },
  _worker_List = {
    _BG = UI.getChildControl(Panel_Finance_WorkManager, "Static_WorkerList_BG"),
    _Title = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_WorkerList_Title"),
    _Scroll = UI.getChildControl(Panel_Finance_WorkManager, "Scroll_WorkerList"),
    _No_Worker = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_NoWorker"),
    _Button = {},
    _Progress = {},
    _ActionPoint = {},
    _Template = {
      _Button = UI.getChildControl(Panel_Finance_WorkManager, "RadioButton_Worker"),
      _Progress = UI.getChildControl(Panel_Finance_WorkManager, "Progress2_Worker_ActionPoint"),
      _ActionPoint = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_Worker_ActionPoint"),
      _rowMax = 11,
      _row_PosY_Gap = 2
    }
  },
  _work_Info = {
    _BG = UI.getChildControl(Panel_Finance_WorkManager, "Static_WorkDetail_BG"),
    _Title = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_WorkDetail_Title"),
    _Resource_Title = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_WorkDetail_Resource_Title"),
    _Resource_Icon_BG = {},
    _Resource_Icon_Border = {},
    _Resource_Icon_Over = {},
    _Resource_Icon = {},
    _Resource_Count = {},
    _Template = {
      _Resource_Icon_BG = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_WorkDetail_Resource_Icon_BG"),
      _Resource_Icon_Border = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_WorkDetail_Resource_Icon_Boder"),
      _Resource_Icon_Over = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_WorkDetail_Resource_Icon_Over"),
      _Resource_Icon = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_WorkDetail_Resource_Icon"),
      _Resource_Count = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_WorkDetail_Resource_Count"),
      _collumMax = 6,
      _collum_PosX_Gap = 2
    },
    _Time_BG = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_Estimated_Time_BG"),
    _Time_Value = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_Estimated_Time_Value"),
    _Work_Volume_Text = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_Estimated_WorkVolum_Text"),
    _Work_Volume_Value = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_Estimated_WorkVolum_Value"),
    _Work_Speed_Text = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_Estimated_WorkSpeed_Text"),
    _Work_Speed_Value = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_Estimated_WorkSpeed_Value"),
    _Move_Distance_Text = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_Estimated_MoveDistance_Text"),
    _Move_Distance_Value = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_Estimated_MoveDistance_Value"),
    _Move_Speed_Text = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_Estimated_MoveSpeed_Text"),
    _Move_Speed_Value = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_Estimated_MoveSpeed_Value"),
    _Luck_Text = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_Estimated_Luck_Text"),
    _Luck_Value = UI.getChildControl(Panel_Finance_WorkManager, "StaticText_Estimated_Luck_Value")
  }
}
defalut_Control._btn_Question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"HouseManageWork\" )")
defalut_Control._btn_Question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"HouseManageWork\", \"true\")")
defalut_Control._btn_Question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"HouseManageWork\", \"false\")")
function defalut_Control:Init_Control()
  FGlobal_AddChild(Panel_Finance_WorkManager, self._workInfo_Default._BG, self._workInfo_Default._Icon_BG)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._workInfo_Default._BG, self._workInfo_Default._Icon)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._workInfo_Default._BG, self._workInfo_Default._Type)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._workInfo_Default._BG, self._workInfo_Default._Desc)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._worker_List._BG, self._worker_List._Title)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._worker_List._BG, self._worker_List._Scroll)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._worker_List._BG, self._worker_List._No_Worker)
  FGlobal_Set_Table_Control(self._worker_List, "_Button", "_Button", true, false)
  FGlobal_Set_Table_Control(self._worker_List, "_Progress", "_Button", true, false)
  FGlobal_Set_Table_Control(self._worker_List, "_ActionPoint", "_Button", true, false)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._work_Info._BG, self._work_Info._Resource_Title)
  FGlobal_Set_Table_Control(self._work_Info, "_Resource_Icon_BG", "_Resource_Icon_BG", false, true)
  FGlobal_Set_Table_Control(self._work_Info, "_Resource_Icon_Border", "_Resource_Icon_BG", false, true)
  FGlobal_Set_Table_Control(self._work_Info, "_Resource_Icon_Over", "_Resource_Icon_BG", false, true)
  FGlobal_Set_Table_Control(self._work_Info, "_Resource_Icon", "_Resource_Icon_BG", false, true)
  FGlobal_Set_Table_Control(self._work_Info, "_Resource_Count", "_Resource_Icon_BG", false, true)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._work_Info._BG, self._work_Info._Time_BG)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._work_Info._BG, self._work_Info._Time_Value)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._work_Info._BG, self._work_Info._Work_Volume_Text)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._work_Info._BG, self._work_Info._Work_Volume_Value)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._work_Info._BG, self._work_Info._Work_Speed_Text)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._work_Info._BG, self._work_Info._Work_Speed_Value)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._work_Info._BG, self._work_Info._Move_Distance_Text)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._work_Info._BG, self._work_Info._Move_Distance_Value)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._work_Info._BG, self._work_Info._Move_Speed_Text)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._work_Info._BG, self._work_Info._Move_Speed_Value)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._work_Info._BG, self._work_Info._Luck_Text)
  FGlobal_AddChild(Panel_Finance_WorkManager, self._work_Info._BG, self._work_Info._Luck_Value)
  defalut_Control._workInfo_Default._Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
end
defalut_Control:Init_Control()
function defalut_Control:Init_Function()
  self._btn_Close:addInputEvent("Mouse_LUp", "FGlobal_Finance_WorkManager_Close()")
  self._Button_DoWork:addInputEvent("Mouse_LUp", "HandleClick_Finance_doWork()")
  self._worker_List._BG:addInputEvent("Mouse_UpScroll", "HandleScroll_Finance_Worker_List_UpDown(true)")
  self._worker_List._BG:addInputEvent("Mouse_DownScroll", "HandleScroll_Finance_Worker_List_UpDown(false)")
  self._worker_List._Scroll:addInputEvent("Mouse_UpScroll", "HandleScroll_Finance_Worker_List_UpDown(true)")
  self._worker_List._Scroll:addInputEvent("Mouse_DownScroll", "HandleScroll_Finance_Worker_List_UpDown(false)")
  self._worker_List._Scroll:addInputEvent("Mouse_LDown", "HandleScroll_Finance_Worker_List_OnClick()")
  self._worker_List._Scroll:addInputEvent("Mouse_LUp", "HandleScroll_Finance_Worker_List_OnClick()")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_UpScroll", "HandleScroll_Finance_Worker_List_UpDown(true)")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_DownScroll", "HandleScroll_Finance_Worker_List_UpDown(false)")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LDown", "HandleScroll_Finance_Worker_List_OnClick()")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LUp", "HandleScroll_Finance_Worker_List_OnClick()")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LPress", "HandleScroll_Finance_Worker_List_OnClick()")
  for key, value in pairs(self._worker_List._Button) do
    value:addInputEvent("Mouse_On", "HandleOn_Finance_Worker_List(" .. key .. ")")
    value:addInputEvent("Mouse_Out", "HandleOut_Finance_Worker_List()")
    value:addInputEvent("Mouse_UpScroll", "HandleScroll_Finance_Worker_List_UpDown(true)")
    value:addInputEvent("Mouse_DownScroll", "HandleScroll_Finance_Worker_List_UpDown(false)")
  end
  for key, value in pairs(self._work_Info._Resource_Icon_Over) do
    value:addInputEvent("Mouse_On", "Item_Tooltip_Show_FinanceResource(" .. key .. ")")
    value:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
  end
end
defalut_Control:Init_Function()
local Work_Info = {
  _plantKey = nil,
  _workKey = nil,
  _workableType = nil,
  _workVolum = nil,
  _position = nil,
  _finance_Icon = nil,
  _finance_Type = nil,
  _finance_Des = nil,
  _resource = {},
  _isCraftable = false
}
function Work_Info:_setData()
  local workableCnt = ToClient_getPlantWorkableListCount(_plantKey)
  for index = 1, workableCnt do
    local _workKey = ToClient_getPlantWorkableItemExchangeKeyByIndex(_plantKey, index - 1)
    local _workName = ToClient_getPlantWorkableItemExchangeDescriptionByIndex(_plantKey, index - 1)
    local esSSW = ToClient_getPlantWorkableItemExchangeWrapperByIndex(_plantKey, index - 1)
    if esSSW:isSet() then
      local esSS = esSSW:get()
      local _workVolum = Int64toInt32(ToClient_getPlantCorpProductionApply(_plantKey, esSS._productTime)) / 1000
      local _workableType = esSS._productCategory
      local itemStatic = esSS:getFirstDropGroup():getItemStaticStatus()
      local _finance_Icon = "icon/" .. esSSW:getIcon()
      local _finance_Type = esSSW:getDescription()
      local _finance_Des = esSSW:getDetailDescription()
      self._plantKey = _plantKey
      self._workKey = _workKey
      self._workableType = _workableType
      self._workVolum = _workVolum
      self._position = float3(_position.x, _position.y, _position.z)
      self._finance_Icon = _finance_Icon
      self._finance_Type = _finance_Type
      self._finance_Des = _finance_Des
      self._isCraftable = true
      self._resource = {}
      local eSSCount = getExchangeSourceNeedItemList(esSS, true)
      for idx = 1, eSSCount do
        local _idx = idx - 1
        local itemStaticInfomationWrapper = getExchangeSourceNeedItemByIndex(_idx)
        local itemStaticWrapper = itemStaticInfomationWrapper:getStaticStatus()
        local itemStatic = itemStaticWrapper:get()
        local itemKey = itemStaticInfomationWrapper:getKey()
        local _gradeType = itemStaticWrapper:getGradeType()
        local resourceKey = itemStatic._key
        local itemIcon = "icon/" .. getItemIconPath(itemStatic)
        local needCount = Int64toInt32(itemStaticInfomationWrapper:getCount_s64())
        local haveCount = 0
        if 0 ~= _affiliatedTownKey then
          haveCount = Int64toInt32(warehouse_getItemCount(_affiliatedTownKey, itemKey))
        end
        self._resource[idx] = {
          _itemKey = itemKey,
          _resourceKey = resourceKey,
          _itemIcon = itemIcon,
          _needCount = needCount,
          _haveCount = haveCount,
          _gradeType = _gradeType
        }
        if needCount > haveCount then
          self._isCraftable = false
        end
      end
    end
  end
  Work_Info:_Update()
end
function Work_Info:_Update()
  defalut_Control._workInfo_Default._Icon:ChangeTextureInfoName(self._finance_Icon)
  defalut_Control._workInfo_Default._Type:SetText(self._finance_Type)
  defalut_Control._workInfo_Default._Desc:SetText(self._finance_Des)
  local _resource_SlotMax = defalut_Control._work_Info._Template._collumMax
  for idx = 1, _resource_SlotMax do
    local _data = self._resource[idx]
    if nil ~= _data then
      local gradeType = _data._gradeType
      if gradeType > 0 and gradeType <= #UI.itemSlotConfig.borderTexture then
        defalut_Control._work_Info._Resource_Icon_Border[idx]:ChangeTextureInfoName(UI.itemSlotConfig.borderTexture[gradeType].texture)
        local x1, y1, x2, y2 = setTextureUV_Func(defalut_Control._work_Info._Resource_Icon_Border[idx], UI.itemSlotConfig.borderTexture[gradeType].x1, UI.itemSlotConfig.borderTexture[gradeType].y1, UI.itemSlotConfig.borderTexture[gradeType].x2, UI.itemSlotConfig.borderTexture[gradeType].y2)
        defalut_Control._work_Info._Resource_Icon_Border[idx]:getBaseTexture():setUV(x1, y1, x2, y2)
        defalut_Control._work_Info._Resource_Icon_Border[idx]:setRenderTexture(defalut_Control._work_Info._Resource_Icon_Border[idx]:getBaseTexture())
        defalut_Control._work_Info._Resource_Icon_Border[idx]:SetShow(true)
      else
        defalut_Control._work_Info._Resource_Icon_Border[idx]:SetShow(false)
      end
      defalut_Control._work_Info._Resource_Icon[idx]:ChangeTextureInfoName(_data._itemIcon)
      local resourceCount = tostring(_data._haveCount) .. "/" .. tostring(_data._needCount)
      if _data._haveCount < _data._needCount then
        resourceCount = "<PAColor0xFFDB2B2B>" .. resourceCount .. "<PAOldColor>"
      end
      defalut_Control._work_Info._Resource_Count[idx]:SetText(resourceCount)
      defalut_Control._work_Info._Resource_Icon_BG[idx]:SetShow(true)
      defalut_Control._work_Info._Resource_Icon_Border[idx]:SetShow(true)
      defalut_Control._work_Info._Resource_Icon_Over[idx]:SetShow(true)
      defalut_Control._work_Info._Resource_Icon[idx]:SetShow(true)
      defalut_Control._work_Info._Resource_Count[idx]:SetShow(true)
    elseif nil == _data then
      defalut_Control._work_Info._Resource_Icon_BG[idx]:SetShow(false)
      defalut_Control._work_Info._Resource_Icon_Border[idx]:SetShow(false)
      defalut_Control._work_Info._Resource_Icon_Over[idx]:SetShow(false)
      defalut_Control._work_Info._Resource_Icon[idx]:SetShow(false)
      defalut_Control._work_Info._Resource_Count[idx]:SetShow(false)
    end
  end
  if true == self._isCraftable then
    defalut_Control._Button_DoWork:SetShow(true)
    defalut_Control._Button_NoResource:SetShow(false)
  elseif false == self._isCraftable then
    defalut_Control._Button_DoWork:SetShow(false)
    defalut_Control._Button_NoResource:SetShow(true)
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
local workingTime = {}
local homeWayKey = {}
local sortDistanceValue = {}
local function Worker_SortByRegionInfo()
  local workIndex = 0
  local esSSW = ToClient_getPlantWorkableItemExchangeWrapperByIndex(_plantKey, workIndex)
  local esSS = esSSW:get()
  local sortMethod = 0
  local waitingWorkerCount = ToClient_getPlantWaitWorkerListCount(Work_Info._plantKey, Work_Info._workableType, Work_Info._workKey, sortMethod)
  if 0 == waitingWorkerCount then
    return
  end
  local possibleWorkerIndex = 0
  for index = 1, waitingWorkerCount do
    local npcWaitingWorker = ToClient_getPlantWaitWorkerByIndex(Work_Info._plantKey, index - 1)
    local workerNoRaw = npcWaitingWorker:getWorkerNo():get_s64()
    local workerWrapperLua = getWorkerWrapper(workerNoRaw, false)
    if true == ToClient_isWaitWorker(npcWaitingWorker) and false == workerWrapperLua:getIsAuctionInsert() then
      possibleWorkerIndex = possibleWorkerIndex + 1
      local workVolume = Int64toInt32(ToClient_getPlantCorpProductionApply(Work_Info._plantKey, esSS._productTime)) / 1000
      local distance = ToClient_getCalculateMoveDistance(Worker_List._data_Table[possibleWorkerIndex]._workerNo, Work_Info._position) / 100
      local workSpeed = Worker_List._data_Table[possibleWorkerIndex]._workSpeed
      local moveSpeed = Worker_List._data_Table[possibleWorkerIndex]._moveSpeed
      local luck = Worker_List._data_Table[possibleWorkerIndex]._luck
      local workBaseTime = ToClient_getNpcWorkingBaseTime() / 1000
      local totalWorkTime = math.ceil(workVolume / workSpeed) * workBaseTime + distance / moveSpeed * 2
      workingTime[possibleWorkerIndex] = Int64toInt32(totalWorkTime)
      homeWayKey[possibleWorkerIndex] = Worker_List._data_Table[possibleWorkerIndex]._homeWaypoint
      sortDistanceValue[possibleWorkerIndex] = distance
    end
  end
  local possibleWorkerCount = possibleWorkerIndex
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
  for ii = 1, possibleWorkerCount do
    local temp
    for i = possibleWorkerCount, 1, -1 do
      if i > 1 and workingTime[i] < workingTime[i - 1] then
        temp = Worker_List._data_Table[i]
        Worker_List._data_Table[i] = Worker_List._data_Table[i - 1]
        Worker_List._data_Table[i - 1] = temp
        temp = workingTime[i]
        workingTime[i] = workingTime[i - 1]
        workingTime[i - 1] = temp
        temp = sortDistanceValue[i]
        sortDistanceValue[i] = sortDistanceValue[i - 1]
        sortDistanceValue[i - 1] = temp
      end
    end
    if nil == temp then
      break
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
      for ii = 1, sortTerritoryCount - 1 do
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
  if waitingWorkerCount <= 0 then
    defalut_Control._Button_NoResource:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_RENTHOUSE_WORKMANAGER_WORKERLIST_NOWORKER"))
  else
    defalut_Control._Button_NoResource:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_RENTHOUSE_WORKMANAGER_BTN_DISABLEWORK"))
  end
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
      local workSpeed = npcWaitingWorker:getWorkEfficienceWithSkill(checkData, 2)
      local moveSpeed = npcWaitingWorker:getMoveSpeedWithSkill(checkData) / 100
      local luck = npcWaitingWorker:getLuckWithSkill(checkData)
      local maxPoint = npcWaitingWorkerSS._actionPoint
      local currentPoint = npcWaitingWorker:getActionPoint()
      local workerRegionWrapper = ToClient_getRegionInfoWrapper(npcWaitingWorker)
      local name = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. npcWaitingWorker:getLevel() .. " " .. getWorkerName(npcWaitingWorkerSS) .. "(<PAColor0xff868686>" .. workerRegionWrapper:getAreaName() .. "<PAOldColor>)"
      local homeWaypoint = npcWaitingWorker:getHomeWaypoint()
      local workerGrade = npcWaitingWorkerSS:getCharacterStaticStatus()._gradeType:get()
      self._data_Table[_idx] = {
        _workerNo = workerNo,
        _workerNo_s64 = workerNoChar,
        _workerNoChar = Int64toInt32(workerNoChar),
        _name = name,
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
  for index = 1, self._rowMax do
    local _dataIndex = self._offsetIndex + index
    local data = self._data_Table[_dataIndex]
    if nil == data then
      break
    end
    local name = data._name
    local actionPoint = tostring(data._currentPoint) .. "/" .. tostring(data._maxPoint)
    local preogressRate = math.floor(data._currentPoint / data._maxPoint * 100)
    local workerGrade = data._workerGrade
    defalut_Control._worker_List._Button[index]:SetFontColor(ConvertFromGradeToColor(workerGrade))
    defalut_Control._worker_List._Button[index]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    defalut_Control._worker_List._Button[index]:SetText(name)
    defalut_Control._worker_List._Button[index]:addInputEvent("Mouse_LUp", "Finance_Worker_List_Select(" .. index .. ")")
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
  HandleOn_Finance_Worker_List_Refresh()
end
function Finance_Worker_List_Select(index)
  local selectedIndex = Worker_List._offsetIndex + index
  if nil ~= Worker_List._data_Table[selectedIndex] then
    Worker_List._selected_Worker = Worker_List._data_Table[selectedIndex]._workerNo
    Worker_List._selected_WorkerKey = Worker_List._data_Table[selectedIndex]._workerNoChar
    Worker_List._selected_Index = selectedIndex
    _affiliatedTownKey = Worker_List._data_Table[selectedIndex]._homeWaypoint
    warehouse_requestInfo(_affiliatedTownKey)
    FGlobal_Finance_WorkManager_Refresh()
    defalut_Control._worker_List._No_Worker:SetShow(false)
  else
    defalut_Control._worker_List._No_Worker:SetShow(true)
  end
  Worker_List:_updateSlot()
  Finance_Work_Info_Update()
end
function HandleOn_Finance_Worker_List(index)
  Worker_List._over_Index = index
  defalut_Control._worker_List._ActionPoint[index]:SetShow(true)
  Finance_Work_Info_Update(true)
  local self = Worker_List
  local workerIndex = self._offsetIndex + index
  local npcWaitingWorker = ToClient_getNpcWorkerByWorkerNo(Worker_List._data_Table[workerIndex]._workerNo_s64)
  if nil ~= npcWaitingWorker then
    local uiBase = defalut_Control._worker_List._Button[index]
    FGlobal_ShowWorkerTooltipByWorkerNoRaw(Worker_List._data_Table[workerIndex]._workerNo_s64, uiBase, false)
  end
end
function HandleOut_Finance_Worker_List()
  Worker_List._over_Index = nil
  Worker_List:_updateSlot()
  Finance_Work_Info_Update()
  FGlobal_HideWorkerTooltip()
end
function HandleOn_Finance_Worker_List_Refresh()
  if nil ~= Worker_List._over_Index then
    HandleOn_Finance_Worker_List(Worker_List._over_Index)
  end
end
function Finance_Work_Info_Update(isWorkerOver)
  local workVolume = Work_Info._workVolum
  defalut_Control._work_Info._Work_Volume_Value:SetText(string.format("%.2f", workVolume))
  local workerIndex = Worker_List._selected_Index
  if true == isWorkerOver then
    workerIndex = Worker_List._offsetIndex + Worker_List._over_Index
  end
  if nil ~= Worker_List._data_Table[workerIndex] then
    local distance = ToClient_getCalculateMoveDistance(Worker_List._data_Table[workerIndex]._workerNo, Work_Info._position) / 100
    local workSpeed = Worker_List._data_Table[workerIndex]._workSpeed
    local moveSpeed = Worker_List._data_Table[workerIndex]._moveSpeed
    local luck = Worker_List._data_Table[workerIndex]._luck
    defalut_Control._work_Info._Move_Distance_Value:SetText(string.format("%.0f", distance))
    defalut_Control._work_Info._Work_Speed_Value:SetText(string.format("%.2f", workSpeed))
    defalut_Control._work_Info._Move_Speed_Value:SetText(string.format("%.2f", moveSpeed))
    defalut_Control._work_Info._Luck_Value:SetText(string.format("%.2f", luck))
    local workBaseTime = ToClient_getNpcWorkingBaseTime() / 1000
    local totalWorkTime = math.ceil(workVolume / workSpeed) * workBaseTime + distance / moveSpeed * 2
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
function HandleScroll_Finance_Worker_List_UpDown(isUp)
  Scroll_UpDown(isUp, Worker_List)
end
local ScrollOnClick = function(_target, _scroll)
  local _scroll_Button = _scroll:GetControlButton()
  local _scroll_Blank = _scroll:GetSizeY() - _scroll_Button:GetSizeY()
  local _scroll_Percent = _scroll_Button:GetPosY() / _scroll_Blank
  _target._offsetIndex = math.floor(_scroll_Percent * _target._offset_Max)
  _target:_updateSlot()
end
function HandleScroll_Finance_Worker_List_OnClick()
  ScrollOnClick(Worker_List, defalut_Control._worker_List._Scroll)
end
function Item_Tooltip_Show_FinanceResource(idx)
  local staticStatusKey = Work_Info._resource[idx]._resourceKey
  local uiBase = defalut_Control._work_Info._Resource_Icon_Border[idx]
  if nil == staticStatusKey or nil == uiBase then
    return
  end
  local staticStatusWrapper = getItemEnchantStaticStatus(staticStatusKey)
  Panel_Tooltip_Item_Show(staticStatusWrapper, uiBase, true, false)
end
function FGlobal_Finance_WorkManager_Open(node)
  WorldMapPopupManager:push(Panel_Finance_WorkManager, true)
  if nil == node then
    return
  end
  Worker_List._selected_Worker = nil
  Worker_List._selected_WorkerKey = nil
  Worker_List._selected_Index = nil
  Worker_List._over_Index = nil
  _plantKey = node:getPlantKey()
  _position = getPlant(_plantKey):getPositionInGame()
  wayPlant = ToClient_getPlant(_plantKey)
  Work_Info:_setData()
  Worker_List:_setData()
  Worker_List:_updateSlot()
  Finance_Worker_List_Select(1)
  local nodeName = getExploreNodeName(node:getStaticStatus())
  defalut_Control._title:SetText(nodeName)
end
function FGlobal_Finance_WorkManager_Close()
  FGlobal_WorldMapWindowEscape()
end
function FGlobal_Finance_WorkManager_Reset_Pos()
  local PosX = (getScreenSizeX() - Panel_Finance_WorkManager:GetSizeX()) / 2
  local PosY = (getScreenSizeY() - Panel_Finance_WorkManager:GetSizeY()) / 2
  Panel_Finance_WorkManager:SetPosX(PosX)
  Panel_Finance_WorkManager:SetPosY(PosY)
end
function HandleClick_Finance_doWork()
  if workerManager_CheckWorkingOtherChannelAndMsg() then
    return
  end
  if nil == Worker_List._selected_Worker then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
    return
  end
  local workingCount = 1
  local doWorkNow = ToClient_requestStartPlantWorkingToNpcWorker(Worker_List._selected_Worker, Work_Info._plantKey, Work_Info._workKey, workingCount)
  FGlobal_RedoWork(4, nil, Worker_List._selected_Worker, Work_Info._plantKey, Work_Info._workKey, nil, workingCount, nil, nil, _affiliatedTownKey)
  if doWorkNow then
    Panel_Finance_WorkManager:SetShow(false)
    FGlobal_ShowWorkingProgress(FGlobal_SelectedNode(), 1)
  end
end
function FromClient_Finance_StopWork()
  if Panel_Finance_WorkManager:GetShow() then
    Worker_List:_setData()
    Worker_List:_updateSlot()
    if nil == Worker_List._selected_Index then
      Finance_Worker_List_Select(1)
    end
  end
end
function FGlobal_Finance_WorkManager_Refresh()
  Work_Info:_setData()
  Worker_List:_setData()
  Work_Info:_Update()
  Worker_List:_updateSlot()
  Finance_Work_Info_Update()
end
function FromClient_WareHouse_Update_ForFinance(affiliatedTownKey)
  if affiliatedTownKey == _affiliatedTownKey and true == Panel_Finance_WorkManager:GetShow() then
    FGlobal_Finance_WorkManager_Refresh()
  end
end
registerEvent("EventWarehouseUpdate", "FromClient_WareHouse_Update_ForFinance")
registerEvent("WorldMap_StopWorkerWorking", "FromClient_Finance_StopWork")

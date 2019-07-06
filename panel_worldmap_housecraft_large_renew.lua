Panel_Worldmap_HouseCraftLarge:ignorePadSnapMoveToOtherPanel()
local Window_WorldMap_HouseCraftLargeInfo = {
  _ui = {
    _static_TopBg = UI.getChildControl(Panel_Worldmap_HouseCraftLarge, "Static_TopBg"),
    _static_TopDescBg = UI.getChildControl(Panel_Worldmap_HouseCraftLarge, "Static_TopDescBg"),
    _static_CenterBg = UI.getChildControl(Panel_Worldmap_HouseCraftLarge, "Static_CenterBg"),
    _static_BottomBg = UI.getChildControl(Panel_Worldmap_HouseCraftLarge, "Static_BottomBg")
  },
  _craftSlotConfig = {createIcon = true},
  _resourceSlotConfig = {createIcon = true, createCount = true},
  _workerList = {},
  _craftItemList = {},
  _currentCraftingWorkerList = {},
  _houseInfoSS,
  _houseKey,
  _param,
  _prevGetWareHouseKey = 0,
  _onGoingIndex,
  _craftItemCount,
  _currentCraftIndex = 0,
  _currentWorkerIndex = 0,
  _currentResourceIndex = 0,
  _currentWorkKey,
  _position,
  _repeatCount = 1,
  _cancelAll = false,
  _currentCancelWorker = nil,
  _craftSlot = {},
  _resourceSlot = {},
  _keyGuides = {}
}
function PaGlobalFunc_WorldMap_HouseCraftLarge_GetCraftingdata(houseInfoSSWrapper, _param)
  local self = Window_WorldMap_HouseCraftLargeInfo
  local dataTable = {}
  self._ui._staticText_RepeatCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", self._repeatCount))
  self:InitData(houseInfoSSWrapper, _param)
  self:SetCraftData(true)
  self:SetResourceData()
  dataTable._sumProgressCount = self._craftItemList[self._onGoingIndex]._onGoingCount
  dataTable._totalCount = self._craftItemList[self._onGoingIndex]._totalCount
  dataTable._currentCount = self._craftItemList[self._onGoingIndex]._currentCount
  return dataTable
end
function Window_WorldMap_HouseCraftLargeInfo:SetCraftData(isRsfresh)
  local level = self._param._level
  local receipeKey = self._param._useType
  local workCount = ToClient_getRentHouseWorkableListByCustomOnlySize(receipeKey, 1, level)
  self._craftItemList = {}
  self._onGoingIndex = nil
  local levelIndex = 1
  local savedLevel = 0
  local levelCount = 0
  local realIndex = 0
  for index = 0, workCount - 1 do
    local esSSW = ToClient_getHouseWorkableItemExchangeByIndex(self._houseInfoSS, index)
    if true == esSSW:isSet() then
      self._craftItemList[realIndex] = {}
      local esSS = esSSW:get()
      local itemStaticWrapper = esSSW:getResultItemStaticStatusWrapper()
      local itemStatic = itemStaticWrapper:get()
      local gradeType = itemStaticWrapper:getGradeType()
      local workVolume = Int64toInt32(esSS._productTime / toInt64(0, 1000))
      local workName = esSSW:getDescription()
      local workIcon = "icon/" .. esSSW:getIcon()
      local workKey = ToClient_getWorkableExchangeKeyByIndex(index - 1)
      local exchangeKeyRaw = esSSW:getExchangeKeyRaw()
      local resultIcon = workIcon
      local resultName = workName
      local resultKey
      if false == esSSW:getUseExchangeIcon() then
        resultName = getItemName(itemStatic)
        resultKey = itemStatic._key
      end
      self._craftItemList[realIndex] = {
        _index = index,
        _level = levelIndex,
        _workKey = ToClient_getWorkableExchangeKeyByIndex(index),
        _workIcon = workIcon,
        _workName = workName,
        _workVolume = workVolume,
        _resultKey = resultKey,
        _resultIcon = resultIcon,
        _resultName = resultName,
        _currentCount = 0,
        _onGoingCount = 0,
        _totalCount = 0,
        _resourceList = {}
      }
      local currentKey = ToClient_getLargeCraftExchangeKeyRaw(self._houseInfoSS)
      if currentKey == self._craftItemList[realIndex]._workKey then
        if nil == self._onGoingIndex then
          self._onGoingIndex = index
        else
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEWORKLIST_LARGECRAFT_ALERT"))
          return
        end
      end
      if levelIndex ~= savedLevel then
        levelCount = ToClient_getRentHouseWorkableListByCustomOnlySize(receipeKey, 1, levelIndex)
        savedLevel = levelIndex
      end
      if index == levelCount then
        levelIndex = levelIndex + 1
      end
      if true == isRsfresh then
        self._currentCraftIndex = 0
        if nil ~= self._onGoingIndex then
          self._currentCraftIndex = self._onGoingIndex
        end
        self._currentWorkKey = self._craftItemList[realIndex]._workKey
        self._craftItemCount = workCount
        self._position = ToClient_GetHouseInfoStaticStatusWrapper(self._houseKey):getPosition()
      end
      realIndex = realIndex + 1
    end
  end
end
function Window_WorldMap_HouseCraftLargeInfo:SetResourceData()
  self._currentCraftingWorkerList = {}
  for index = 0, self._craftItemCount - 1 do
    local esSSW = ToClient_getHouseWorkableItemExchangeByIndex(self._houseInfoSS, index)
    if esSSW:isSet() then
      local esSS = esSSW:get()
      local eSSCount = getExchangeSourceNeedItemList(esSS, true)
      local workingCount = ToClient_getHouseWorkingWorkerList(self._houseInfoSS)
      local totalCount = 0
      local sumProgressCount = 0
      local sumOnGoingCount = 0
      if index == self._onGoingIndex then
        for idx = 0, workingCount - 1 do
          local worker = ToClient_getHouseWorkingWorkerByIndex(self._houseInfoSS, idx).workerNo
          self._currentCraftingWorkerList[idx] = worker
        end
      end
      local resource = {}
      for idx = 0, eSSCount - 1 do
        local itemStaticInfomationWrapper = getExchangeSourceNeedItemByIndex(idx)
        local itemStaticWrapper = itemStaticInfomationWrapper:getStaticStatus()
        local itemStatic = itemStaticWrapper:get()
        local gradeType = itemStaticWrapper:getGradeType()
        local itemKey = itemStaticInfomationWrapper:getKey()
        local itemKeyRaw = itemStaticInfomationWrapper:getKey():get()
        local resourceKey = itemStatic._key
        local itemName = getItemName(itemStatic)
        local itemIcon = "icon/" .. getItemIconPath(itemStatic)
        local onGoingCount = 0
        for workerIndex = 0, workingCount - 1 do
          if nil ~= self._currentCraftingWorkerList[workerIndex] then
            local resourceIndex = ToClient_getLargeCraftWorkIndexByWorker(self._currentCraftingWorkerList[workerIndex]:get_s64())
            if resourceIndex == idx then
              onGoingCount = onGoingCount + 1
            end
          end
        end
        if index ~= self._onGoingIndex then
          onGoingCount = 0
        end
        local workingCount = ToClient_getHouseWorkingWorkerList(self._houseInfoSS)
        local tempCount = 0
        for tmpIdx = 0, workingCount - 1 do
          local worker = ToClient_getHouseWorkingWorkerByIndex(self._houseInfoSS, tmpIdx).workerNo
          local workerNo = worker:get_s64()
          local resourceIndex = ToClient_getLargeCraftWorkIndexByWorker(workerNo)
          if resourceIndex == idx then
            tempCount = tempCount + ToClient_getNpcWorkerWorkingCount(workerNo)
          end
        end
        local subWorkName = getItemName(itemStatic)
        local fullCount = Int64toInt32(itemStaticInfomationWrapper:getCount_s64())
        local haveCount = 0
        if 0 ~= self._prevGetWareHouseKey and nil ~= self._prevGetWareHouseKey then
          haveCount = Int64toInt32(warehouse_getItemCount(self._prevGetWareHouseKey, itemKey))
        end
        local progressCount = ToClient_getLargeCarftCompleteProgressPoint(self._houseInfoSS, esSSW:getExchangeKeyRaw(), idx)
        if progressCount < 0 then
          progressCount = 0
        else
          progressCount = fullCount - progressCount
        end
        resource[idx] = {}
        resource[idx] = {
          _itemKey = itemKey,
          _gradeType = gradeType,
          _itemKeyRaw = itemKeyRaw,
          _resourceKey = resourceKey,
          _itemName = itemName,
          _itemIcon = itemIcon,
          _subWorkName = subWorkName,
          _fullCount = fullCount,
          _haveCount = haveCount,
          _progressCount = progressCount,
          _onGoingCount = onGoingCount,
          _workingCount = tempCount
        }
        totalCount = totalCount + fullCount
        sumProgressCount = sumProgressCount + progressCount
        sumOnGoingCount = sumOnGoingCount + onGoingCount
      end
      self._craftItemList[index]._resourceList = resource
      self._craftItemList[index]._currentCount = sumProgressCount
      self._craftItemList[index]._onGoingCount = sumOnGoingCount
      self._craftItemList[index]._totalCount = totalCount
    end
  end
end
function Window_WorldMap_HouseCraftLargeInfo:SetCraftList(isRsfresh)
  self:SetCraftData(isRsfresh)
  self:SetResourceData()
  self._position = ToClient_GetHouseInfoStaticStatusWrapper(self._houseKey):getPosition()
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_SelectCraftItem(value)
  local self = Window_WorldMap_HouseCraftLargeInfo
  PaGlobalFunc_WorldMap_HouseCraftLarge_HideTooltip()
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  ToClient_padSnapResetControl()
  self._currentCraftIndex = self._currentCraftIndex + value
  if self._currentCraftIndex < 0 then
    self._currentCraftIndex = #self._craftItemList
  end
  if #self._craftItemList < self._currentCraftIndex then
    self._currentCraftIndex = 0
  end
  self:SetTopInfo()
  self:SetResourceList()
  self:SetInfo()
  self:SetDetailInfo()
  PaGlobalFunc_WorldMap_HouseCraftLarge_SelectWorker(0)
  PaGlobalFunc_WorldMap_HouseCraftLarge_SelectResourceItem(0)
end
function Window_WorldMap_HouseCraftLargeInfo:SetTopInfo()
  local craftItem = self._craftItemList[self._currentCraftIndex]
  local esSSW = ToClient_getHouseWorkableItemExchangeByIndex(self._houseInfoSS, self._currentCraftIndex)
  local itemStaticWrapper = esSSW:getResultItemStaticStatusWrapper()
  self._craftSlot:setItemByStaticStatus(itemStaticWrapper)
  self._ui._staticText_CraftTitle:SetText(craftItem._workName)
  local guideText = ""
  if nil == self._onGoingIndex then
    guideText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSEWORKLIST_LARGECRAFT_GUIDE_2", "name", craftItem._workName)
  else
    local ongoingWorkName = self._craftItemList[self._onGoingIndex]._workName
    if self._currentCraftIndex ~= self._onGoingIndex then
      guideText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSEWORKLIST_LARGECRAFT_GUIDE_1", "name", ongoingWorkName)
    else
      guideText = ""
    end
  end
  self._ui._staticText_CraftDesc:SetText(guideText)
  local count
  if 0 == craftItem._onGoingCount then
    count = craftItem._currentCount .. " / " .. craftItem._totalCount
  else
    count = craftItem._currentCount .. "(+" .. craftItem._onGoingCount .. ")" .. " / " .. craftItem._totalCount
  end
  self._ui._staticText_CraftNeedCount:SetText(count)
  if self._onGoingIndex == self._currentCraftIndex then
    local progressRate_Complete = math.floor(craftItem._currentCount / craftItem._totalCount * 100)
    local progressRate_OnGoing = math.floor((craftItem._currentCount + craftItem._onGoingCount) / craftItem._totalCount * 100)
    self._ui._progress2_CraftMakingTime:SetProgressRate(progressRate_Complete)
    self._ui._progress2_CraftMakingTime_DoWork:SetProgressRate(progressRate_OnGoing)
  else
    self._ui._progress2_CraftMakingTime_DoWork:SetProgressRate(0)
    self._ui._progress2_CraftMakingTime:SetProgressRate(0)
  end
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_SelectResourceItem(index)
  local self = Window_WorldMap_HouseCraftLargeInfo
  local prevIndex = self._currentResourceIndex
  self._currentResourceIndex = index
  self:SetInfo()
  self:SetDetailInfo()
  self._ui._list2_ResourceList:requestUpdateByKey(toInt64(0, prevIndex))
  self._ui._list2_ResourceList:requestUpdateByKey(toInt64(0, self._currentResourceIndex))
  PaGlobalFunc_WorldMap_HouseCraftLarge_SetSelectButton(-1, 1)
end
function Window_WorldMap_HouseCraftLargeInfo:SetResourceList()
  local craftItemInfo = self._craftItemList[self._currentCraftIndex]
  if nil == craftItemInfo then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "Large Craft\236\151\144\236\132\156 \236\132\160\237\131\157\237\149\156 \235\140\128\237\152\149 \236\160\156\236\158\145\237\146\136\236\157\180 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local resourceList = craftItemInfo._resourceList
  self._ui._list2_ResourceList:getElementManager():clearKey()
  for index = 0, #resourceList do
    local resource = resourceList[index]
    if nil == resource then
      _PA_LOG("\236\157\180\237\152\184\236\132\156", "Large Craft\236\151\144\236\132\156 \236\132\160\237\131\157\237\149\156 \236\160\156\236\158\145 \236\158\172\235\163\140\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
    else
      self._ui._list2_ResourceList:getElementManager():pushKey(toInt64(0, index))
      self._ui._list2_ResourceList:requestUpdateByKey(toInt64(0, index))
    end
  end
end
function Window_WorldMap_HouseCraftLargeInfo:SetDetailInfo()
  local craftItemInfo = self._craftItemList[self._currentCraftIndex]
  if nil == craftItemInfo then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "Large Craft\236\151\144\236\132\156 \236\132\160\237\131\157\237\149\156 \235\140\128\237\152\149 \236\160\156\236\158\145\237\146\136\236\157\180 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local resource = craftItemInfo._resourceList[self._currentResourceIndex]
  if nil == resource then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "Large Craft\236\151\144\236\132\156 \236\132\160\237\131\157\237\149\156 \236\160\156\236\158\145 \236\158\172\235\163\140\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local itemStaticWrapper = getItemEnchantStaticStatus(resource._itemKey)
  self._resourceSlot:setItemByStaticStatus(itemStaticWrapper)
  self._resourceSlot.count:SetText(resource._haveCount)
  self._ui._staticText_ResourceName:SetText(resource._itemName)
  self._ui._list2_CraftingWorker:getElementManager():clearKey()
  if self._onGoingIndex ~= self._currentCraftIndex then
    return
  end
  for index = 0, #self._currentCraftingWorkerList do
    local worker = self._currentCraftingWorkerList[index]
    if nil ~= worker then
      local resourceIndex = ToClient_getLargeCraftWorkIndexByWorker(worker:get_s64())
      if resourceIndex == self._currentResourceIndex then
        self._ui._list2_CraftingWorker:getElementManager():pushKey(toInt64(0, index))
        self._ui._list2_CraftingWorker:requestUpdateByKey(toInt64(0, index))
      end
    end
  end
end
function Window_WorldMap_HouseCraftLargeInfo:SetInfo()
  local craftItemInfo = self._craftItemList[self._currentCraftIndex]
  if nil == craftItemInfo then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "Large Craft\236\151\144\236\132\156 \236\132\160\237\131\157\237\149\156 \235\140\128\237\152\149 \236\160\156\236\158\145\237\146\136\236\157\180 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local resource = craftItemInfo._resourceList[self._currentResourceIndex]
  if nil == resource then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "Large Craft\236\151\144\236\132\156 \236\132\160\237\131\157\237\149\156 \236\160\156\236\158\145 \236\158\172\235\163\140\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local workerInfo = self._workerList[self._currentWorkerIndex]
  self._ui._staticText_WorkCount:SetText(craftItemInfo._workVolume)
  if nil ~= self._onGoingIndex and self._currentCraftIndex ~= self._onGoingIndex then
    self._ui._static_keyGuide_DoWork:SetShow(false)
    self._ui._static_Keyguide_Cancel:SetShow(false)
  else
    self._ui._static_Keyguide_Cancel:SetShow(true)
    self._ui._static_WarningIcon:SetShow(0 == resource._haveCount)
    self._ui._static_keyGuide_DoWork:SetShow(0 < resource._haveCount)
  end
  if nil ~= workerInfo then
    local distance = ToClient_getCalculateMoveDistance(workerInfo._workerNo, self._position) / 100
    local workSpeed = workerInfo._workSpeed
    local moveSpeed = workerInfo._moveSpeed
    local workBaseTime = ToClient_getNpcWorkingBaseTime() / 1000
    local totalWorkTime = math.ceil(craftItemInfo._workVolume / math.floor(workSpeed)) * workBaseTime + distance / moveSpeed * 2
    self._ui._staticText_Distance:SetText(string.format("%.0f", distance))
    self._ui._staticText_WorkSpeed:SetText(string.format("%.2f", workSpeed))
    self._ui._staticText_MoveSpeed:SetText(string.format("%.2f", moveSpeed))
    self._ui._staticText_LeftTime:SetText(Util.Time.timeFormatting(math.floor(totalWorkTime)))
  else
    self._ui._staticText_Distance:SetText("--")
    self._ui._staticText_WorkSpeed:SetText("--")
    self._ui._staticText_MoveSpeed:SetText("--")
    self._ui._staticText_LeftTime:SetText("--")
    self._ui._static_WarningIcon:SetShow(false)
    self._ui._static_keyGuide_DoWork:SetShow(false)
  end
  if nil == self._onGoingIndex then
    self._ui._static_Keyguide_Cancel:SetShow(false)
  end
  self._repeatCount = 1
  self._ui._staticText_RepeatCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", self._repeatCount))
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuides, self._ui._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_SelectRepeatButton()
  local self = Window_WorldMap_HouseCraftLargeInfo
  local s64_MaxWorkableCount = toInt64(0, self:GetWorkableMaxCount())
  if s64_MaxWorkableCount <= toInt64(0, 0) then
    _PA_LOG("\236\157\180\235\172\184\236\162\133", "\236\157\188\234\190\188\236\157\180 \236\158\145\236\151\133\237\149\160 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.")
  else
    Panel_NumberPad_Show(true, s64_MaxWorkableCount, 0, PaGlobalFunc_WorldMap_HouseCraftLarge_SetRepeatCount)
  end
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_SetRepeatCount(inputNumber)
  local self = Window_WorldMap_HouseCraftLargeInfo
  self._repeatCount = Int64toInt32(inputNumber)
  self._ui._staticText_RepeatCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", self._repeatCount))
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_CraftCancel()
  local self = Window_WorldMap_HouseCraftLargeInfo
  if false == self._ui._static_Keyguide_Cancel:GetShow() then
    return
  end
  local currentKey = ToClient_getLargeCraftExchangeKeyRaw(self._houseInfoSS)
  local selectKey = self._craftItemList[self._currentCraftIndex]._workKey
  if currentKey ~= selectKey then
    return
  end
  local workName = self._craftItemList[self._currentCraftIndex]._workName
  local cancelContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LARGECRAFT_WORKMANAGER_CANCELALL_CONTENT", "workName", workName)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_LARGECRAFT_WORKMANAGER_CANCELALL_TITLE"),
    content = cancelContent,
    functionYes = PaGlobalFunc_WorldMap_HouseCraftLarge_CraftCancelContinue,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "top")
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_CraftCancelContinue()
  local self = Window_WorldMap_HouseCraftLargeInfo
  local workingCout = ToClient_getHouseWorkingWorkerList(self._houseInfoSS)
  if workingCout > 0 then
    self._cancelAll = true
    for idx = 1, workingCout do
      local worker = ToClient_getHouseWorkingWorkerByIndex(self._houseInfoSS, idx - 1).workerNo
      ToClient_requestStopPlantWorking(worker)
    end
  else
    self._cancelAll = false
    ToClient_requestChangeLargeCraftExchange(self._houseInfoSS, 0)
  end
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_DoWork()
  local self = Window_WorldMap_HouseCraftLargeInfo
  if false == self._ui._static_keyGuide_DoWork:GetShow() then
    return
  end
  if workerManager_CheckWorkingOtherChannelAndMsg() then
    return
  end
  local craftItemInfo = self._craftItemList[self._currentCraftIndex]
  if nil == craftItemInfo then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkNotSelect"))
    return
  end
  local resource = craftItemInfo._resourceList[self._currentResourceIndex]
  if nil == resource then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "Large Craft\236\151\144\236\132\156 \236\132\160\237\131\157\237\149\156 \236\160\156\236\158\145 \236\158\172\235\163\140\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local workerInfo = self._workerList[self._currentWorkerIndex]
  if nil == workerInfo then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
    return
  end
  if 0 == resource._haveCount then
    return
  end
  local workCount = resource._workingCount
  local selected_Work = craftItemInfo._workKey
  local selected_SubWork = resource._itemKeyRaw
  local selected_Worker = workerInfo._workerNo
  local currentKey = ToClient_getLargeCraftExchangeKeyRaw(self._houseInfoSS)
  if currentKey ~= selected_Work then
    local workName = craftItemInfo._workName
    local _content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LARGECRAFT_WORKMANAGER_STARTWORK_CONTENT", "workName", workName)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_LARGECRAFT_WORKMANAGER_STARTWORK_TITLE"),
      content = _content,
      functionYes = PaGlobalFunc_WorldMap_HouseCraftLarge_DoWorkContinue,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "top")
  elseif 0 < self:GetWorkableMaxCount() then
    ToClient_requestStartLargeCraftToNpcWorker(self._houseInfoSS, selected_Worker, selected_Work, selected_SubWork, self._repeatCount)
  else
    local workerActionPoint = workerInfo._currentPoint
    if workerActionPoint > 0 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_WORKERMANAGER_LARGECRAFT_MAXWORKCOUNT"))
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_HARVEST_MESSAGE_NEEDACTIONPOINT"))
    end
  end
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_DoWorkContinue()
  local self = Window_WorldMap_HouseCraftLargeInfo
  local craftItemInfo = self._craftItemList[self._currentCraftIndex]
  if nil == craftItemInfo then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "Large Craft\236\151\144\236\132\156 \236\132\160\237\131\157\237\149\156 \235\140\128\237\152\149 \236\160\156\236\158\145\237\146\136\236\157\180 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local resource = craftItemInfo._resourceList[self._currentResourceIndex]
  if nil == resource then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "Large Craft\236\151\144\236\132\156 \236\132\160\237\131\157\237\149\156 \236\160\156\236\158\145 \236\158\172\235\163\140\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local workerInfo = self._workerList[self._currentWorkerIndex]
  if nil == workerInfo then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "Large Craft\236\151\144\236\132\156 \236\132\160\237\131\157\237\149\156 \236\157\188\234\190\188 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  if 0 < self:GetWorkableMaxCount() then
    local workCount = resource._workingCount
    local selected_Work = craftItemInfo._workKey
    local selected_SubWork = resource._itemKeyRaw
    local selected_Worker = workerInfo._workerNo
    ToClient_requestChangeLargeCraftExchange(self._houseInfoSS, selected_Work)
    ToClient_requestStartLargeCraftToNpcWorker(self._houseInfoSS, selected_Worker, selected_Work, selected_SubWork, self._repeatCount)
  else
    local workerActionPoint = workerInfo._currentPoint
    if workerActionPoint > 0 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_WORKERMANAGER_LARGECRAFT_MAXWORKCOUNT"))
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_HARVEST_MESSAGE_NEEDACTIONPOINT"))
    end
  end
end
function Window_WorldMap_HouseCraftLargeInfo:GetWorkableMaxCount()
  local craftItemInfo = self._craftItemList[self._currentCraftIndex]
  if nil == craftItemInfo then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "Large Craft\236\151\144\236\132\156 \236\132\160\237\131\157\237\149\156 \235\140\128\237\152\149 \236\160\156\236\158\145\237\146\136\236\157\180 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local resource = craftItemInfo._resourceList[self._currentResourceIndex]
  if nil == resource then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "Large Craft\236\151\144\236\132\156 \236\132\160\237\131\157\237\149\156 \236\160\156\236\158\145 \236\158\172\235\163\140\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local workerInfo = self._workerList[self._currentWorkerIndex]
  local totalWorkCount = resource._fullCount
  local currentWorkCount = resource._progressCount
  local workingCount = resource._workingCount
  local ongoingCount = resource._onGoingCount
  local workableCount = totalWorkCount - currentWorkCount - workingCount - ongoingCount
  local resourceCount = resource._haveCount
  if nil == workerInfo then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
    return
  end
  local workerActionPoint = workerInfo._currentPoint
  local limitWorkableCount = 1
  if workableCount < resourceCount then
    limitWorkableCount = workableCount
  else
    limitWorkableCount = resourceCount
  end
  if workerActionPoint < limitWorkableCount then
    limitWorkableCount = workerActionPoint
  end
  return limitWorkableCount
end
function Window_WorldMap_HouseCraftLargeInfo:SetWorkerList()
  local esSSW = ToClient_getHouseWorkableItemExchangeByIndex(self._houseInfoSS, 0)
  self._ui._list2_WorkerList:getElementManager():clearKey()
  if true == esSSW:isSet() then
    local esSS = esSSW:get()
    local productCategory = esSS._productCategory
    local workableKey = ToClient_getWorkableExchangeKeyByIndex(0)
    local sortMethod = 0
    local waitingWorkerCount = ToClient_getHouseWaitWorkerList(self._houseInfoSS, productCategory, workableKey, sortMethod)
    if waitingWorkerCount <= 0 then
    else
    end
    self._workerList = {}
    local realIndex = 0
    for index = 0, waitingWorkerCount - 1 do
      local npcWaitingWorker = ToClient_getHouseWaitWorkerByIndex(self._houseInfoSS, index)
      local workerNoRaw = npcWaitingWorker:getWorkerNo():get_s64()
      local workerWrapperLua = getWorkerWrapper(workerNoRaw, false)
      if true == ToClient_isWaitWorker(npcWaitingWorker) and false == workerWrapperLua:getIsAuctionInsert() and true == ToClient_getWorkerWorkerableHouse(self._houseInfoSS, index) then
        self._workerList[realIndex] = {}
        local checkData = npcWaitingWorker:getStaticSkillCheckData()
        checkData:set(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouse, self._param._houseUseType, 0)
        checkData._diceCheckForceSuccess = true
        local firstWorkerNo = npcWaitingWorker:getWorkerNo()
        local workerNoChar = firstWorkerNo:get_s64()
        local npcWaitingWorkerSS = npcWaitingWorker:getWorkerStaticStatus()
        local workerNo = WorkerNo(workerNoChar)
        local workSpeed = npcWaitingWorker:getWorkEfficienceWithSkill(checkData, productCategory)
        local moveSpeed = npcWaitingWorker:getMoveSpeedWithSkill(checkData) / 100
        local maxPoint = npcWaitingWorkerSS._actionPoint
        local currentPoint = npcWaitingWorker:getActionPoint()
        local workerRegionWrapper = ToClient_getRegionInfoWrapper(npcWaitingWorker)
        local regionName = "(<PAColor0xff868686>" .. workerRegionWrapper:getAreaName() .. "<PAOldColor>)"
        local homeWaypoint = npcWaitingWorker:getHomeWaypoint()
        local name = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. npcWaitingWorker:getLevel() .. " " .. getWorkerName(npcWaitingWorkerSS)
        local workerGrade = npcWaitingWorkerSS:getCharacterStaticStatus()._gradeType:get()
        self._workerList[realIndex] = {
          _workerNo = workerNo,
          _workerNo_s64 = workerNoChar,
          _workerNoChar = Int64toInt32(workerNoChar),
          _name = name,
          _workSpeed = workSpeed / 1000000,
          _moveSpeed = moveSpeed,
          _maxPoint = maxPoint,
          _currentPoint = currentPoint,
          _homeWaypoint = homeWaypoint,
          _workerGrade = workerGrade,
          _regionName = regionName
        }
        self._ui._list2_WorkerList:getElementManager():pushKey(toInt64(0, realIndex))
        self._ui._list2_WorkerList:requestUpdateByKey(toInt64(0, realIndex))
        realIndex = realIndex + 1
      end
    end
  end
end
function Window_WorldMap_HouseCraftLargeInfo:InitData(houseInfoSSWrapper, _param)
  self._ui._staticText_Title:SetText(_param._houseName)
  self._houseInfoSS = houseInfoSSWrapper:get()
  self._houseKey = houseInfoSSWrapper:getHouseKey()
  self._param = _param
  self._prevGetWareHouseKey = 0
  self._currentCraftIndex = 0
  self._currentWorkerIndex = 0
  self._currentResourceIndex = 0
  self:SetWorkerList()
  self:SetCraftList(true)
  self._ui._static_Keyguide_Select:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GENERIC_KEYGUIDE_XBOX_SELECT"))
  PaGlobalFunc_WorldMap_HouseCraftLarge_SelectCraftItem(0)
  PaGlobalFunc_WorldMap_HouseCraftLarge_SelectWorker(0)
  PaGlobalFunc_WorldMap_HouseCraftLarge_SelectResourceItem(0)
end
function Window_WorldMap_HouseCraftLargeInfo:InitControl()
  self._ui._staticText_Title = UI.getChildControl(self._ui._static_TopBg, "StaticText_Title")
  self._ui._static_CraftIcon = UI.getChildControl(self._ui._static_TopDescBg, "Static_IconBg")
  self._craftSlot = {}
  self._craftSlot._bg = self._ui._static_CraftIcon
  SlotItem.new(self._craftSlot, "craftSlot", 0, self._ui._static_CraftIcon, self._craftSlotConfig)
  self._craftSlot:createChild()
  self._craftSlot.icon:SetSize(self._ui._static_CraftIcon:GetSizeX(), self._ui._static_CraftIcon:GetSizeY())
  self._ui._staticText_CraftTitle = UI.getChildControl(self._ui._static_TopDescBg, "StaticText_Title")
  self._ui._staticText_CraftDesc = UI.getChildControl(self._ui._static_TopDescBg, "StaticText_Desc")
  self._ui._staticText_CraftDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._staticText_CraftNeedCount = UI.getChildControl(self._ui._static_TopDescBg, "StaticText_NeedWorkCount")
  self._ui._progress2_CraftMakingTime = UI.getChildControl(self._ui._static_TopDescBg, "Progress2_MakingTime")
  self._ui._progress2_CraftMakingTime_DoWork = UI.getChildControl(self._ui._static_TopDescBg, "Progress2_Working")
  self._ui._list2_ResourceList = UI.getChildControl(self._ui._static_CenterBg, "List2_CraftItemList")
  self._ui._list2_WorkerList = UI.getChildControl(self._ui._static_CenterBg, "List2_Worker")
  self._ui._static_InfoBg = UI.getChildControl(self._ui._static_CenterBg, "Static_InfoBg")
  self._ui._static_DetailBg = UI.getChildControl(self._ui._static_CenterBg, "Static_DetailBg")
  self._ui._staticText_ResourceName = UI.getChildControl(self._ui._static_DetailBg, "StaticText_ItemName")
  self._ui._static_ResourceIcon = UI.getChildControl(self._ui._static_DetailBg, "Static_ResourceIcon")
  self._resourceSlot = {}
  self._resourceSlot._bg = self._ui._static_ResourceIcon
  SlotItem.new(self._resourceSlot, "resourceSlot", 0, self._ui._static_ResourceIcon, self._resourceSlotConfig)
  self._resourceSlot:createChild()
  self._ui._list2_CraftingWorker = UI.getChildControl(self._ui._static_DetailBg, "List2_CraftingWorkerList")
  self._ui._staticText_LeftTime = UI.getChildControl(self._ui._static_InfoBg, "StaticText_LeftTimeTitle")
  self._ui._staticText_WorkCount = UI.getChildControl(self._ui._static_InfoBg, "StaticText_WorkCountValue")
  self._ui._staticText_Distance = UI.getChildControl(self._ui._static_InfoBg, "StaticText_DistanceValue")
  self._ui._staticText_WorkSpeed = UI.getChildControl(self._ui._static_InfoBg, "StaticText_WorkSpeedValue")
  self._ui._staticText_MoveSpeed = UI.getChildControl(self._ui._static_InfoBg, "StaticText_MoveSpeedValue")
  self._ui._staticText_RepeatCount = UI.getChildControl(self._ui._static_InfoBg, "StaticText_RepeatCount")
  self._ui._button_Repeat = UI.getChildControl(self._ui._static_InfoBg, "Button_Repeat")
  self._ui._static_WarningIcon = UI.getChildControl(self._ui._static_BottomBg, "StaticText_WarningIcon")
  self._ui._static_Keyguide_LB = UI.getChildControl(self._ui._static_TopDescBg, "Static_LB")
  self._ui._static_Keyguide_RB = UI.getChildControl(self._ui._static_TopDescBg, "Static_RB")
  self._ui._static_keyGuide_DoWork = UI.getChildControl(self._ui._static_BottomBg, "StaticText_X_ConsoleUI")
  self._ui._static_Keyguide_Cancel = UI.getChildControl(self._ui._static_BottomBg, "StaticText_Y_ConsoleUI")
  self._ui._static_Keyguide_Select = UI.getChildControl(self._ui._static_BottomBg, "StaticText_A_ConsoleUI")
  self._ui._static_Keyguide_Close = UI.getChildControl(self._ui._static_BottomBg, "StaticText_B_ConsoleUI")
  self._keyGuides = {
    self._ui._static_keyGuide_DoWork,
    self._ui._static_Keyguide_Cancel,
    self._ui._static_Keyguide_Select,
    self._ui._static_Keyguide_Close
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuides, self._ui._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Window_WorldMap_HouseCraftLargeInfo:InitEvent()
  self._ui._list2_ResourceList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_WorldMap_HouseCraftLarge_List2EventControlCreate_ResourceList")
  self._ui._list2_ResourceList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._list2_WorkerList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_WorldMap_HouseCraftLarge_List2EventControlCreate_WorkerList")
  self._ui._list2_WorkerList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._list2_CraftingWorker:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_WorldMap_HouseCraftLarge_List2EventControlCreate_CraftingWorkerList")
  self._ui._list2_CraftingWorker:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  Panel_Worldmap_HouseCraftLarge:RegisterUpdateFunc("PaGlobalFunc_WorldMap_HouseCraftLarge_UpdatePerFrame")
  self._ui._button_Repeat:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_HouseCraftLarge_SelectRepeatButton()")
  self._ui._button_Repeat:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_HouseCraftLarge_SetSelectButton(0,2)")
  self._ui._button_Repeat:addInputEvent("Mouse_Out", "PaGlobalFunc_WorldMap_HouseCraftLarge_SetSelectButton(-1,2)")
  self._craftSlot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_HouseCraftLarge_ShowTooltip(true)")
  self._resourceSlot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_HouseCraftLarge_ShowTooltip(false)")
  self._craftSlot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_WorldMap_HouseCraftLarge_HideTooltip()")
  self._resourceSlot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_WorldMap_HouseCraftLarge_HideTooltip()")
  Panel_Worldmap_HouseCraftLarge:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_WorldMap_HouseCraftLarge_DoWork()")
  Panel_Worldmap_HouseCraftLarge:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_WorldMap_HouseCraftLarge_CraftCancel()")
  Panel_Worldmap_HouseCraftLarge:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_WorldMap_HouseCraftLarge_SelectCraftItem(-1)")
  Panel_Worldmap_HouseCraftLarge:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobalFunc_WorldMap_HouseCraftLarge_SelectCraftItem(1)")
end
function Window_WorldMap_HouseCraftLargeInfo:InitRegister()
  registerEvent("EventWarehouseUpdate", "PaGlobalFunc_FromClient_WorldMap_HouseCraftLarge_WarehouseUpdate")
  registerEvent("WorldMap_WorkerDataUpdateByHouse", "PaGlobalFunc_FromClient_WorldMap_HouseCraftLarge_WorkerDataUpdateByHouse")
  registerEvent("WorldMap_StopWorkerWorking", "PaGlobalFunc_FromClient_WorldMap_HouseCraftLarge_StopWorkerWorking")
  registerEvent("FromClient_ReceiveClearLargeCraft", "PaGlobalFunc_FromClient_WorldMap_HouseCraftLarge_ClearLargeCraft")
  registerEvent("FromClient_changeLeftWorking", "PaGlobalFunc_FromClient_WorldMap_HouseCraftLarge_ChangeLeftWorking")
end
function Window_WorldMap_HouseCraftLargeInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_ShowTooltip(isResult)
  local self = Window_WorldMap_HouseCraftLargeInfo
  local workIndex = self._currentCraftIndex
  local subWorkIndex = self._currentResourceIndex
  local staticStatusKey
  if true == isResult then
    staticStatusKey = self._craftItemList[workIndex]._resultKey
  elseif false == isResult then
    staticStatusKey = self._craftItemList[workIndex]._resourceList[subWorkIndex]._resourceKey
  end
  if nil == staticStatusKey then
    return
  end
  local staticStatusWrapper = getItemEnchantStaticStatus(staticStatusKey)
  PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, staticStatusWrapper, Defines.TooltipTargetType.Item, getScreenSizeX())
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_HideTooltip()
  PaGlobalFunc_TooltipInfo_Close()
end
function PaGlobalFunc_FromClient_WorldMap_HouseCraftLarge_WorkerDataUpdateByHouse(rentHouseWrapper)
  local self = Window_WorldMap_HouseCraftLargeInfo
  if false == PaGlobalFunc_WorldMap_HouseCraftLarge_GetShow() then
    return
  end
  local houseKey = rentHouseWrapper:getStaticStatus():getHouseKey()
  if houseKey == self._houseKey then
    self:SetWorkerList()
    self:SetCraftList(false)
    self:SetTopInfo()
    self:SetResourceList()
    self:SetInfo()
    self:SetDetailInfo()
  end
end
function PaGlobalFunc_FromClient_WorldMap_HouseCraftLarge_StopWorkerWorking(workerNo, isUserRequest)
  local self = Window_WorldMap_HouseCraftLargeInfo
  if false == PaGlobalFunc_WorldMap_HouseCraftLarge_GetShow() then
    return
  end
  if true == self._cancelAll then
    local workingCout = ToClient_getHouseWorkingWorkerList(self._houseInfoSS)
    if workingCout < 1 then
      self._cancelAll = false
      ToClient_requestChangeLargeCraftExchange(self._houseInfoSS, 0)
    end
    return
  end
  self:SetWorkerList()
  self:SetCraftList(true)
  self:SetTopInfo()
  self:SetResourceList()
  self:SetInfo()
  self:SetDetailInfo()
end
function PaGlobalFunc_FromClient_WorldMap_HouseCraftLarge_ClearLargeCraft(characterKey)
  local self = Window_WorldMap_HouseCraftLargeInfo
  if false == PaGlobalFunc_WorldMap_HouseCraftLarge_GetShow() then
    return
  end
  if characterKey == self._houseKey then
    local workName = self._craftItemList[self._currentWorkerIndex]._workName
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LARGECRAFT_WORKMANAGER_CANCELED", "workName", workName))
    self:SetWorkerList()
    self:SetCraftList(false)
    self:SetTopInfo()
    self:SetResourceList()
    self:SetInfo()
    self:SetDetailInfo()
  end
end
function PaGlobalFunc_FromClient_WorldMap_HouseCraftLarge_ChangeLeftWorking(workerNoRaw)
  local self = Window_WorldMap_HouseCraftLargeInfo
  if false == PaGlobalFunc_WorldMap_HouseCraftLarge_GetShow() then
    return
  end
  self:SetWorkerList()
  self:SetCraftList(false)
  self:SetTopInfo()
  self:SetResourceList()
  self:SetInfo()
  self:SetDetailInfo()
end
function PaGlobalFunc_FromClient_WorldMap_HouseCraftLarge_WarehouseUpdate(affiliatedTownKey)
  local self = Window_WorldMap_HouseCraftLargeInfo
  if false == PaGlobalFunc_WorldMap_HouseCraftLarge_GetShow() then
    return
  end
  if self._prevGetWareHouseKey == affiliatedTownKey then
    self:SetResourceData()
    self:SetDetailInfo()
    return
  end
  self._prevGetWareHouseKey = affiliatedTownKey
  local prevScrollIndex = self._ui._list2_WorkerList:getCurrenttoIndex()
  self:SetWorkerList()
  self:SetCraftList(false)
  self:SetResourceList()
  self:SetDetailInfo()
  self._ui._list2_WorkerList:moveIndex(prevScrollIndex)
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_UpdatePerFrame(deltaTime)
  local self = Window_WorldMap_HouseCraftLargeInfo
  if self._onGoingIndex ~= self._currentCraftIndex then
    return
  end
  for index = 0, #self._currentCraftingWorkerList do
    local worker = self._currentCraftingWorkerList[index]
    if nil ~= worker then
      local resourceIndex = ToClient_getLargeCraftWorkIndexByWorker(worker:get_s64())
      if resourceIndex == self._currentResourceIndex then
        self._ui._list2_CraftingWorker:requestUpdateByKey(toInt64(0, index))
      end
    end
  end
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_List2EventControlCreate_CraftingWorkerList(list_content, key)
  local self = Window_WorldMap_HouseCraftLargeInfo
  local id = Int64toInt32(key)
  local craftItem = self._craftItemList[self._currentCraftIndex]
  local resource = craftItem._resourceList[self._currentResourceIndex]
  local worker = self._currentCraftingWorkerList[id]
  if nil == worker then
    return
  end
  local button = UI.getChildControl(list_content, "Button_Bg")
  local progress2_Working = UI.getChildControl(list_content, "Progress2_Working")
  local staticText_name = UI.getChildControl(list_content, "StaticText_WorkerName")
  local StaticText_LeftTime = UI.getChildControl(list_content, "StaticText_Time")
  button:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_HouseCraftLarge_CancelWork(" .. id .. ")")
  button:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_HouseCraftLarge_SetGuideCraftingWorker(true)")
  button:addInputEvent("Mouse_Out", "PaGlobalFunc_WorldMap_HouseCraftLarge_SetGuideCraftingWorker(false)")
  local workerNo = worker:get_s64()
  local workerWrapper = ToClient_getNpcWorkerByWorkerNo(workerNo)
  local name = workerWrapper:getName()
  local progressRate = ToClient_getWorkingProgress(workerNo) * 100000
  local remainTime = Util.Time.timeFormatting(ToClient_getLeftWorkingTime(workerNo))
  local repeatCountStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_ONGOING", "workerNo", ToClient_getNpcWorkerWorkingCount(workerNo))
  StaticText_LeftTime:SetText(remainTime)
  progress2_Working:SetProgressRate(progressRate)
  staticText_name:SetText(name .. repeatCountStr)
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_List2EventControlCreate_ResourceList(list_content, key)
  local self = Window_WorldMap_HouseCraftLargeInfo
  local id = Int64toInt32(key)
  local craftItem = self._craftItemList[self._currentCraftIndex]
  local resource = craftItem._resourceList[id]
  if nil == resource then
    return
  end
  local button = UI.getChildControl(list_content, "Radiobutton_Work")
  local staticText_name = UI.getChildControl(list_content, "StaticText_WorkTItle")
  local staticText_Count = UI.getChildControl(list_content, "StaticText_Count")
  local progress2_Working = UI.getChildControl(list_content, "Progress2_Working")
  local Progress2_Complate = UI.getChildControl(list_content, "Progress2_Complate")
  local count
  if 0 == resource._onGoingCount then
    count = resource._progressCount .. " / " .. resource._fullCount
  else
    count = resource._progressCount .. "(+" .. resource._onGoingCount .. ")" .. " / " .. resource._fullCount
  end
  staticText_Count:SetText(count)
  staticText_name:SetText(resource._itemName)
  button:SetCheck(id == self._currentResourceIndex)
  button:addInputEvent("Mouse_LDown", "PaGlobalFunc_WorldMap_HouseCraftLarge_SelectResourceItem(" .. id .. ")")
  button:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_HouseCraftLarge_SetSelectButton(" .. id .. ",1)")
  button:addInputEvent("Mouse_Out", "PaGlobalFunc_WorldMap_HouseCraftLarge_SetSelectButton(-1,1)")
  local isOnGoing = self._currentCraftIndex == self._onGoingIndex
  if true == isOnGoing then
    local progressRate_Complete = math.floor(resource._progressCount / resource._fullCount * 100)
    local progressRate_OnGoing = math.floor((resource._onGoingCount + resource._progressCount) / resource._fullCount * 100)
    Progress2_Complate:SetProgressRate(progressRate_Complete)
    progress2_Working:SetProgressRate(progressRate_OnGoing)
  else
    Progress2_Complate:SetProgressRate(0)
    progress2_Working:SetProgressRate(0)
  end
  Progress2_Complate:SetShow(0 ~= Progress2_Complate:GetProgressRate())
  progress2_Working:SetShow(0 ~= progress2_Working:GetProgressRate())
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_List2EventControlCreate_WorkerList(list_content, key)
  local self = Window_WorldMap_HouseCraftLargeInfo
  local id = Int64toInt32(key)
  local workerInfo = self._workerList[id]
  if nil == workerInfo then
    return
  end
  local button = UI.getChildControl(list_content, "Radiobutton_ButtonBg")
  local staticText_ActionPoint = UI.getChildControl(list_content, "StaticText_ActionPoint")
  local staticText_name = UI.getChildControl(list_content, "StaticText_WorkerTitle")
  button:SetCheck(id == self._currentWorkerIndex)
  local maxPoint = workerInfo._maxPoint
  local currentPoint = workerInfo._currentPoint
  local workerWrapperLua = getWorkerWrapper(workerInfo._workerNo_s64, true)
  local workerGrade = workerWrapperLua:getGrade()
  staticText_name:SetFontColor(ConvertFromGradeToColor(workerGrade))
  staticText_name:SetText(workerInfo._name)
  button:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_HouseCraftLarge_SelectWorker(" .. id .. ")")
  button:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_HouseCraftLarge_SetSelectButton(" .. id .. ",0)")
  button:addInputEvent("Mouse_Out", "PaGlobalFunc_WorldMap_HouseCraftLarge_SetSelectButton(-1,0)")
  staticText_ActionPoint:SetText(currentPoint .. " / " .. maxPoint)
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_SelectWorker(index)
  if false == Panel_Worldmap_HouseCraftLarge:GetShow() then
    return
  end
  local self = Window_WorldMap_HouseCraftLargeInfo
  local workerInfo = self._workerList[index]
  local affiliatedTownKey = 0
  if nil ~= workerInfo then
    affiliatedTownKey = workerInfo._homeWaypoint
    if self._prevGetWareHouseKey ~= affiliatedTownKey then
      warehouse_requestInfo(affiliatedTownKey)
    end
  end
  self._prevGetWareHouseKey = affiliatedTownKey
  local prevIndex = self._currentWorkerIndex
  self._currentWorkerIndex = index
  self:SetResourceData()
  self:SetInfo()
  self:SetDetailInfo()
  self._ui._list2_WorkerList:requestUpdateByKey(toInt64(0, prevIndex))
  self._ui._list2_WorkerList:requestUpdateByKey(toInt64(0, self._currentWorkerIndex))
  PaGlobalFunc_WorldMap_HouseCraftLarge_SetSelectButton(-1, 0)
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_SetGuideCraftingWorker(isCraftingWorker)
  local self = Window_WorldMap_HouseCraftLargeInfo
  if true == isCraftingWorker then
    self._ui._static_Keyguide_Select:SetText(PAGetString(Defines.StringSheet_RESOURCE, "WORLDMAP_WOKRPROGRESS_BTN_CANCEL"))
  else
    self._ui._static_Keyguide_Select:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GENERIC_KEYGUIDE_XBOX_SELECT"))
  end
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_SetSelectButton(id, buttonType)
  local self = Window_WorldMap_HouseCraftLargeInfo
  if 0 == buttonType then
    self._ui._static_Keyguide_Select:SetShow(id ~= self._currentWorkerIndex)
  elseif 1 == buttonType then
    self._ui._static_Keyguide_Select:SetShow(id ~= self._currentResourceIndex)
  elseif 2 == buttonType then
    self._ui._static_Keyguide_Select:SetShow(true)
  end
  if -1 == id then
    self._ui._static_Keyguide_Select:SetShow(false)
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuides, self._ui._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_CancelWork(id)
  local self = Window_WorldMap_HouseCraftLargeInfo
  local worker = self._currentCraftingWorkerList[id]
  if nil == worker then
    return
  end
  self._currentCancelWorker = worker
  local _workerNo = worker:get_s64()
  local _leftWorkCount = ToClient_getNpcWorkerWorkingCount(_workerNo)
  if _leftWorkCount < 1 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKING_PROGRESS_LEFTWORKCOUNT_ACK"))
    return
  else
    local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(_workerNo)
    local workName = esSSW:getDescription()
    local cancelWorkContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LARGECRAFT_WORKMANAGER_CANCELWORK_CONTENT", "workName", workName)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_LARGECRAFT_WORKMANAGER_CANCELWORK_TITLE"),
      content = cancelWorkContent,
      functionYes = PaGlobalFunc_WorldMap_HouseCraftLarge_CancelWorkContinue,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "top")
  end
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_CancelWorkContinue()
  local self = Window_WorldMap_HouseCraftLargeInfo
  ToClient_requestCancelNextWorking(self._currentCancelWorker)
  self._currentCancelWorker = nil
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_GetShow()
  return Panel_Worldmap_HouseCraftLarge:GetShow()
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_SetShow(isShow, isAni)
  Panel_Worldmap_HouseCraftLarge:SetShow(isShow, isAni)
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_Open(houseInfoSSWrapper, _param)
  local self = Window_WorldMap_HouseCraftLargeInfo
  if true == PaGlobalFunc_WorldMap_HouseCraftLarge_GetShow() then
    return
  end
  if nil == houseInfoSSWrapper then
    PaGlobalFunc_WorldMap_HouseCraftLarge_Close()
    return
  end
  PaGlobalFunc_WorldMap_HouseCraftLarge_SetShow(true, false)
  self:InitData(houseInfoSSWrapper, _param)
end
function PaGlobalFunc_WorldMap_HouseCraftLarge_Close()
  local self = Window_WorldMap_HouseCraftLargeInfo
  if false == PaGlobalFunc_WorldMap_HouseCraftLarge_GetShow() then
    return
  end
  self._prevGetWareHouseKey = 0
  self._currentWorkerIndex = 0
  self._currentCraftIndex = 0
  self._currentResourceIndex = 0
  PaGlobalFunc_WorldMap_HouseCraftLarge_HideTooltip()
  PaGlobalFunc_WorldMapHouseManager_Open()
  PaGlobalFunc_WorldMap_HouseCraftLarge_SetShow(false, false)
end
function PaGlobalFunc_FromClient_WorldMap_HouseCraftLarge_luaLoadComplete()
  local self = Window_WorldMap_HouseCraftLargeInfo
  self:Initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_WorldMap_HouseCraftLarge_luaLoadComplete")

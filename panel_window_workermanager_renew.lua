Panel_Window_WorkerManager_Renew:SetShow(false)
local workerManager = {
  _ui = {
    _static_TopBg = UI.getChildControl(Panel_Window_WorkerManager_Renew, "Static_TopBg"),
    _static_TabTitleBg = UI.getChildControl(Panel_Window_WorkerManager_Renew, "Static_RadioButtonBg"),
    _static_ButtonBg = UI.getChildControl(Panel_Window_WorkerManager_Renew, "Static_ButtonBg"),
    _static_WorkerInformationBg = UI.getChildControl(Panel_Window_WorkerManager_Renew, "Static_WorkerInformationBg"),
    _static_WorkerSkillBg = UI.getChildControl(Panel_Window_WorkerManager_Renew, "Static_WorkerSkillBg"),
    _static_UpgradeBg = UI.getChildControl(Panel_Window_WorkerManager_Renew, "Static_UpgradeBg"),
    _static_DescBg = UI.getChildControl(Panel_Window_WorkerManager_Renew, "Static_DescBg"),
    _static_BottomBg = UI.getChildControl(Panel_Window_WorkerManager_Renew, "Static_BottomBg"),
    _list2_Worker = UI.getChildControl(Panel_Window_WorkerManager_Renew, "List2_Worker"),
    _static_PcButtonBg = UI.getChildControl(Panel_Window_WorkerManager_Renew, "Static_PcButtonBg"),
    _tabText = {},
    _skillSlot = {},
    _xboxUI = {},
    _pcUI = {}
  },
  _config = {
    _skillSlotCount = 8,
    _upgradeSlotCount = 3,
    _Tab = {
      _Base = 0,
      _Skill = 1,
      _Upgrade = 2,
      _TabCount = 3
    },
    _workerGrade = {
      _Informal = 0,
      _Normal = 1,
      _Skilled = 2,
      _Expert = 3,
      _Master = 4,
      _All = 5
    },
    _workType = {
      _HouseCraft = 0,
      _LargeCraft = 1,
      _PlantWork = 2,
      _Building = 3,
      _RegionWork = 4,
      _upgrade = 5,
      _harvest = 6
    },
    _workerUpgradeTextureType = {
      _Fail = 0,
      _Upgradable = 1,
      _InActivation = 2
    },
    _workerGradeString = {
      [0] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_0"),
      [1] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_1"),
      [2] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_2"),
      [3] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_3"),
      [4] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_4"),
      [5] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL")
    },
    _workerTownString = {
      [0] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL")
    },
    _fontColor = {
      _upgrade_Inactivation = 4283587437,
      _upgrade_NormalLevel = 4294294074,
      _upgrade_NormalState = 4293848814,
      _upgrade_Fail = 4293848814
    }
  },
  _selectedTab,
  _selectedWorker,
  _filterTown,
  _filterGrade,
  _workerList = {},
  _townList = {},
  _gradeList = {},
  _workerCount = 0,
  _elapsedTime = 0
}
function PaGlobalFunc_WorkerManager_GetTownFilter()
  return workerManager._filterTown
end
function PaGlobalFunc_WorkerManager_GetGradeFilter()
  return workerManager._filterGrade
end
function workerManager:initialize()
  self:initContorl()
  self:registInputEvent()
  self:resetData()
end
function workerManager:initContorl()
  local workerManagerUI = workerManager._ui
  workerManagerUI._tabText._radioButton_BaseOrder = UI.getChildControl(workerManagerUI._static_TabTitleBg, "RadioButton_BaseOrder")
  workerManagerUI._tabText._radioButton_Skill = UI.getChildControl(workerManagerUI._static_TabTitleBg, "RadioButton_Skill")
  workerManagerUI._tabText._radioButton_Upgrade = UI.getChildControl(workerManagerUI._static_TabTitleBg, "RadioButton_Upgrade")
  workerManagerUI._xboxUI._staticText_Restore_ConsoleUI = UI.getChildControl(workerManagerUI._static_ButtonBg, "StaticText_Restore_ConsoleUI")
  workerManagerUI._xboxUI._staticText_Redo_ConsoleUI = UI.getChildControl(workerManagerUI._static_ButtonBg, "StaticText_Redo_ConsoleUI")
  workerManagerUI._xboxUI._staticText_DoFire_ConsoleUI = UI.getChildControl(workerManagerUI._static_ButtonBg, "StaticText_DoFire_ConsoleUI")
  workerManagerUI._xboxUI._staticText_ChangeSkill_ConsoleUI = UI.getChildControl(workerManagerUI._static_ButtonBg, "StaticText_ChangeSkill_ConsoleUI")
  workerManagerUI._xboxUI._staticText_Upgrade_ConsoleUI = UI.getChildControl(workerManagerUI._static_ButtonBg, "StaticText_Upgrade_ConsoleUI")
  workerManagerUI._pcUI._button_Restore = UI.getChildControl(workerManagerUI._static_PcButtonBg, "Button_Restore")
  workerManagerUI._pcUI._button_Redo = UI.getChildControl(workerManagerUI._static_PcButtonBg, "Button_Redo")
  workerManagerUI._pcUI._button_DoFire = UI.getChildControl(workerManagerUI._static_PcButtonBg, "Button_DoFire")
  workerManagerUI._pcUI._button_ChangeSkill = UI.getChildControl(workerManagerUI._static_PcButtonBg, "Button_ChangeSkill")
  workerManagerUI._pcUI._button_Upgrade = UI.getChildControl(workerManagerUI._static_PcButtonBg, "Button_Upgrade")
  local wokerImageBG = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "Static_WorkerBg")
  workerManagerUI._static_WorkerImage = UI.getChildControl(wokerImageBG, "Static_WorkerImage")
  workerManagerUI._staticText_WorkerTitle = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "StaticText_WorkerTitle")
  workerManagerUI._staticText_Node = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "StaticText_Node")
  workerManagerUI._staticText_WorkerState = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "StaticText_State")
  workerManagerUI._static_RemainTimeProgressBg = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "Static_RemainTimeProgressBg")
  workerManagerUI._Progress2_RemainTimeProgress = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "Progress2_RemainTimeProgress")
  workerManagerUI._staticText_WorkingNameCount = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "StaticText_WorkingNameCount")
  workerManagerUI._staticText_WorkingSpeedTitle = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "StaticText_WorkingSpeedTitle")
  workerManagerUI._staticText_MovingSpeedTitle = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "StaticText_MovingSpeedTitle")
  workerManagerUI._staticText_LuckTitle = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "StaticText_LuckTitle")
  workerManagerUI._staticText_EnergyTitle = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "StaticText_EnergyTitle")
  workerManagerUI._staticText_WorkingSpeedValue = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "StaticText_WorkingSpeedValue")
  workerManagerUI._staticText_MovingSpeedValue = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "StaticText_MovingSpeedValue")
  workerManagerUI._staticText_LuckValue = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "StaticText_LuckValue")
  workerManagerUI._staticText_EnergyValue = UI.getChildControl(workerManagerUI._static_WorkerInformationBg, "StaticText_EnergyValue")
  for index = 1, self._config._skillSlotCount do
    local control = {}
    control._static_SkillSlotBg = UI.getChildControl(workerManagerUI._static_WorkerSkillBg, "Static_SkillSlotBg" .. index)
    control._static_SkillSlot = UI.getChildControl(workerManagerUI._static_WorkerSkillBg, "Static_SkillSlot" .. index)
    control._staticText_SkillTitle = UI.getChildControl(workerManagerUI._static_WorkerSkillBg, "StaticText_SkillTitle" .. index)
    control._staticText_SkillTitle:SetSize(300, 20)
    control._staticText_SkillDesc = UI.getChildControl(workerManagerUI._static_WorkerSkillBg, "StaticText_SkillDesc" .. index)
    control._staticText_SkillDesc:SetSize(320, 47)
    workerManagerUI._skillSlot[index] = control
  end
  workerManagerUI._upgradeSlot = {}
  local upgradInfo1 = {}
  upgradInfo1._static_UpgradeStateBg = UI.getChildControl(workerManagerUI._static_UpgradeBg, "Static_FirstUpgradeStateBg")
  upgradInfo1._staticText_UpgradeLevel = UI.getChildControl(workerManagerUI._static_UpgradeBg, "StaticText_FirstUpgradeLevel")
  upgradInfo1._staticText_UpgradeState = UI.getChildControl(workerManagerUI._static_UpgradeBg, "StaticText_FirstUpgradState")
  upgradInfo1._staticText_UpgradeTitle = UI.getChildControl(workerManagerUI._static_UpgradeBg, "StaticText_FirstUpgradeTitle")
  workerManagerUI._upgradeSlot[1] = upgradInfo1
  local upgradInfo2 = {}
  upgradInfo2._static_UpgradeStateBg = UI.getChildControl(workerManagerUI._static_UpgradeBg, "Static_SecondUpgradeStateBg")
  upgradInfo2._staticText_UpgradeLevel = UI.getChildControl(workerManagerUI._static_UpgradeBg, "StaticText_SecondUpgradeLevel")
  upgradInfo2._staticText_UpgradeState = UI.getChildControl(workerManagerUI._static_UpgradeBg, "StaticText_SecondUpgradeState")
  upgradInfo2._staticText_UpgradeTitle = UI.getChildControl(workerManagerUI._static_UpgradeBg, "StaticText_SecondUpgradeTitle")
  workerManagerUI._upgradeSlot[2] = upgradInfo2
  local upgradInfo3 = {}
  upgradInfo3._static_UpgradeStateBg = UI.getChildControl(workerManagerUI._static_UpgradeBg, "Static_ThirdUpgradeStateBg")
  upgradInfo3._staticText_UpgradeLevel = UI.getChildControl(workerManagerUI._static_UpgradeBg, "StaticText_ThirdUpgradeLevel")
  upgradInfo3._staticText_UpgradeState = UI.getChildControl(workerManagerUI._static_UpgradeBg, "StaticText_ThirdUpgradState")
  upgradInfo3._staticText_UpgradeTitle = UI.getChildControl(workerManagerUI._static_UpgradeBg, "StaticText_ThirdUpgradeTitle")
  workerManagerUI._upgradeSlot[3] = upgradInfo3
  workerManagerUI._xboxUI._staticText_Close_ConsoleUI = UI.getChildControl(workerManagerUI._static_BottomBg, "StaticText_Close_ConsoleUI")
  workerManagerUI._xboxUI._staticText_Align_ConsoleUI = UI.getChildControl(workerManagerUI._static_BottomBg, "StaticText_Align_ConsoleUI")
  workerManagerUI._xboxUI._staticText_SortInfo = UI.getChildControl(workerManagerUI._static_BottomBg, "StaticText_AlignInfo")
  workerManagerUI._xboxUI._staticText_SortInfo:SetShow(false)
  workerManagerUI._xboxUI._staticText_Align_ConsoleUI:SetShow(false)
  workerManagerUI._xboxUI._staticText_AllRestore_ButtonGroup = UI.getChildControl(workerManagerUI._static_BottomBg, "Static_AllRestoreBtn_Group")
  workerManagerUI._xboxUI._staticText_AllRedo_ButtonGroup = UI.getChildControl(workerManagerUI._static_BottomBg, "Static_AllRedoBtn_Group")
  workerManagerUI._xboxUI._staticText_AllRestore1_ConsoleUI = UI.getChildControl(workerManagerUI._xboxUI._staticText_AllRestore_ButtonGroup, "StaticText_AllRestore1_ConsoleUI")
  workerManagerUI._xboxUI._staticText_AllRestore2_ConsoleUI = UI.getChildControl(workerManagerUI._xboxUI._staticText_AllRestore_ButtonGroup, "StaticText_AllRestore2_ConsoleUI")
  workerManagerUI._xboxUI._staticText_AllRestore3_ConsoleUI = UI.getChildControl(workerManagerUI._xboxUI._staticText_AllRestore_ButtonGroup, "StaticText_AllRestore3_ConsoleUI")
  workerManagerUI._xboxUI._staticText_AllRedo1_ConsoleUI = UI.getChildControl(workerManagerUI._xboxUI._staticText_AllRedo_ButtonGroup, "StaticText_AllRedo1_ConsoleUI")
  workerManagerUI._xboxUI._staticText_AllRedo2_ConsoleUI = UI.getChildControl(workerManagerUI._xboxUI._staticText_AllRedo_ButtonGroup, "StaticText_AllRedo2_ConsoleUI")
  workerManagerUI._xboxUI._staticText_AllRedo3_ConsoleUI = UI.getChildControl(workerManagerUI._xboxUI._staticText_AllRedo_ButtonGroup, "StaticText_AllRedo3_ConsoleUI")
  workerManagerUI._pcUI._button_Close = UI.getChildControl(workerManagerUI._static_BottomBg, "Button_Close")
  workerManagerUI._pcUI._button_AllRestore = UI.getChildControl(workerManagerUI._static_BottomBg, "Button_AllRestore")
  workerManagerUI._pcUI._button_AllRedo = UI.getChildControl(workerManagerUI._static_BottomBg, "Button_AllRedo")
  workerManagerUI._pcUI._button_Align = UI.getChildControl(workerManagerUI._static_BottomBg, "Button_Align")
  workerManagerUI._list2_Worker:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_WorkerManager_listCreat")
  workerManagerUI._list2_Worker:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  workerManagerUI._static_UpgradeDesc = UI.getChildControl(workerManagerUI._static_DescBg, "StaticText_UpgradeDesc")
  workerManagerUI._static_UpgradeDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  workerManagerUI._static_UpgradeDesc:SetText(workerManagerUI._static_UpgradeDesc:GetText())
  local keyGuide = {
    workerManagerUI._xboxUI._staticText_Restore_ConsoleUI,
    workerManagerUI._xboxUI._staticText_Redo_ConsoleUI,
    workerManagerUI._xboxUI._staticText_DoFire_ConsoleUI,
    workerManagerUI._xboxUI._staticText_ChangeSkill_ConsoleUI,
    workerManagerUI._xboxUI._staticText_Upgrade_ConsoleUI
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuide, workerManagerUI._static_ButtonBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  local tempSizeX = workerManagerUI._xboxUI._staticText_AllRestore1_ConsoleUI:GetSizeX() + workerManagerUI._xboxUI._staticText_AllRestore2_ConsoleUI:GetSizeX() + workerManagerUI._xboxUI._staticText_AllRestore3_ConsoleUI:GetSizeX()
  tempSizeX = tempSizeX + workerManagerUI._xboxUI._staticText_AllRestore1_ConsoleUI:GetTextSizeX() + workerManagerUI._xboxUI._staticText_AllRestore2_ConsoleUI:GetTextSizeX() + workerManagerUI._xboxUI._staticText_AllRestore3_ConsoleUI:GetTextSizeX()
  workerManagerUI._xboxUI._staticText_AllRestore_ButtonGroup:SetSize(tempSizeX, workerManagerUI._xboxUI._staticText_AllRestore_ButtonGroup:GetSizeY())
  tempSizeX = workerManagerUI._xboxUI._staticText_AllRedo1_ConsoleUI:GetSizeX() + workerManagerUI._xboxUI._staticText_AllRedo2_ConsoleUI:GetSizeX() + workerManagerUI._xboxUI._staticText_AllRedo3_ConsoleUI:GetSizeX()
  tempSizeX = tempSizeX + workerManagerUI._xboxUI._staticText_AllRedo1_ConsoleUI:GetTextSizeX() + workerManagerUI._xboxUI._staticText_AllRedo2_ConsoleUI:GetTextSizeX() + workerManagerUI._xboxUI._staticText_AllRedo3_ConsoleUI:GetTextSizeX()
  workerManagerUI._xboxUI._staticText_AllRedo_ButtonGroup:SetSize(tempSizeX, workerManagerUI._xboxUI._staticText_AllRestore_ButtonGroup:GetSizeY())
  local tempBtnGroup = {
    workerManagerUI._xboxUI._staticText_Close_ConsoleUI
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, workerManagerUI._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  workerManagerUI._xboxUI._staticText_AllRedo_ButtonGroup:SetPosX(workerManagerUI._xboxUI._staticText_Close_ConsoleUI:GetPosX() - workerManagerUI._xboxUI._staticText_AllRedo_ButtonGroup:GetSizeX() - 20)
  workerManagerUI._xboxUI._staticText_AllRestore_ButtonGroup:SetPosX(workerManagerUI._xboxUI._staticText_AllRedo_ButtonGroup:GetPosX() - workerManagerUI._xboxUI._staticText_AllRestore_ButtonGroup:GetSizeX() - 20)
end
function workerManager:registInputEvent()
  if true == ToClient_isConsole() then
    Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_WorkerManager_ChangeTab(-1)")
    Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobalFunc_WorkerManager_ChangeTab(1)")
    Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_RTPress_A, "PaGlobalFunc_WorkerManager_WorkerRestore(true)")
    Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_RTPress_X, "PaGlobalFunc_WorkerManager_WorkerRepeatAll()")
  else
    self._ui._pcUI._button_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_Close()")
    self._ui._tabText._radioButton_BaseOrder:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_SelectTab(" .. self._config._Tab._Base .. ")")
    self._ui._tabText._radioButton_Skill:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_SelectTab(" .. self._config._Tab._Skill .. ")")
    self._ui._tabText._radioButton_Upgrade:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_SelectTab(" .. self._config._Tab._Upgrade .. ")")
  end
end
function workerManager:setButtonString()
  local workerManagerUI = self._ui
  if true == ToClient_isConsole() then
    workerManagerUI._xboxUI._staticText_Restore_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE"))
    workerManagerUI._xboxUI._staticText_Redo_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_REPEAT_NAME"))
    workerManagerUI._xboxUI._staticText_DoFire_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_BUTTONFIRE"))
    workerManagerUI._xboxUI._staticText_ChangeSkill_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_CHANGESKILL_NAME"))
    workerManagerUI._xboxUI._staticText_Upgrade_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERMANAGER_PROMOTION"))
  else
    workerManagerUI._pcUI._button_Restore:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE"))
    workerManagerUI._pcUI._button_Redo:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_REPEAT_NAME"))
    workerManagerUI._pcUI._button_DoFire:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_BUTTONFIRE"))
    workerManagerUI._pcUI._button_ChangeSkill:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_CHANGESKILL_NAME"))
    workerManagerUI._pcUI._button_Upgrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_UPGRADE_NAME"))
  end
  workerManagerUI._upgradeSlot[1]._staticText_UpgradeTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKER_UPGRADE_BYSTEP", "step", "1"))
  workerManagerUI._upgradeSlot[2]._staticText_UpgradeTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKER_UPGRADE_BYSTEP", "step", "2"))
  workerManagerUI._upgradeSlot[3]._staticText_UpgradeTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKER_UPGRADE_BYSTEP", "step", "3"))
  workerManagerUI._staticText_EnergyTitle:SetText(string.gsub(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERRANDOMSELECT_WORKERACTION"), " ", ""))
end
function FromClient_luaLoadComplete_WorkerManager()
  workerManager:initialize()
  workerManager:setButtonString()
end
function workerManager:setShowUI(controTable, isShow)
  for _, controlName in pairs(controTable) do
    controlName:SetShow(isShow)
  end
end
function workerManager:setSortInfo()
  self._ui._xboxUI._staticText_SortInfo:SetShow(false)
  self._ui._xboxUI._staticText_Align_ConsoleUI:SetShow(false)
end
function PaGlobalFunc_WorkerManager_SetSortInfo()
  workerManager:setSortInfo()
end
function workerManager:update(notSetScroll)
  local toIndex = 0
  local scrollvalue = 0
  local vscroll = self._ui._list2_Worker:GetVScroll()
  local hscroll = self._ui._list2_Worker:GetHScroll()
  if nil == notSetScroll then
    toIndex = self._ui._list2_Worker:getCurrenttoIndex()
    if false == self._ui._list2_Worker:IsIgnoreVerticalScroll() then
      scrollvalue = vscroll:GetControlPos()
    elseif false == self._ui._list2_Worker:IsIgnoreHorizontalScroll() then
      scrollvalue = hscroll:GetControlPos()
    end
  end
  self:setSortInfo()
  self:updateListData()
  self:setRightPanelInfo(self._selectedWorker)
  self._ui._list2_Worker:setCurrenttoIndex(toIndex)
  if nil == notSetScroll then
    if false == self._ui._list2_Worker:IsIgnoreVerticalScroll() then
      vscroll:SetControlPos(scrollvalue)
    elseif false == self._ui._list2_Worker:IsIgnoreHorizontalScroll() then
      hscroll:SetControlPos(scrollvalue)
    end
  end
end
function PaGlobalFunc_WorkerManager_WorkerListUpdate()
  workerManager:update()
end
function workerManager:resetData()
  self._selectedTab = self._config._Tab._Base
  self._selectedWorker = nil
  self._filterTown = self._config._workerTownString[0]
  self._filterGrade = self._config._workerGradeString[5]
  self._workerList = {}
  self._workerCount = 0
  self:selectTab(self._selectedTab)
end
function workerManager:updateListData()
  self._ui._list2_Worker:getElementManager():clearKey()
  local plantArray = Array.new()
  local plantConut = ToCleint_getHomePlantKeyListCount()
  for plantIdx = 0, plantConut - 1 do
    local plantKeyRaw = ToCleint_getHomePlantKeyListByIndex(plantIdx)
    local plantKey = PlantKey()
    plantKey:setRaw(plantKeyRaw)
    plantArray:push_back(plantKey)
  end
  if self._config._workerTownString[0] == self._filterTown then
    local plantSort_do = function(a, b)
      return a:get() < b:get()
    end
    table.sort(plantArray, plantSort_do)
  end
  local townTable = {}
  local gradeSort_do = function(a, b)
    return a._grade < b._grade
  end
  self._townList = {}
  self._gradeList = {}
  local townIndex = 1
  for plantRawIdx = 1, #plantArray do
    local plantKey = plantArray[plantRawIdx]
    local plantWorkerCount = ToClient_getPlantWaitWorkerListCount(plantKey, 0)
    local workerArray = Array.new()
    local isSet = false
    if plantWorkerCount > 0 then
      townIndex = townIndex + 1
    end
    for workerIdx = 0, plantWorkerCount - 1 do
      local workerNoRaw = ToClient_getPlantWaitWorkerNoRawByIndex(plantKey, workerIdx)
      local workerWrapperLua = getWorkerWrapper(workerNoRaw)
      local townName = ToClient_GetNodeNameByWaypointKey(workerWrapperLua:getHomeWaypoint())
      local worker_Grade
      if nil ~= workerWrapperLua then
        worker_Grade = workerWrapperLua:getGrade()
        if nil == self._gradeList[worker_Grade] then
          self._gradeList[worker_Grade] = self._config._workerGradeString[worker_Grade]
        end
        if nil == self._townList[plantRawIdx] then
          self._townList[plantRawIdx] = townName
        end
        if nil ~= worker_Grade and (self._config._workerGradeString[worker_Grade] == self._filterGrade or self._config._workerGradeString[5] == self._filterGrade) and (self._config._workerTownString[0] == self._filterTown or townName == self._filterTown) then
          local workerInfo = {}
          workerInfo._workerNoRaw = workerNoRaw
          workerInfo._grade = worker_Grade
          workerArray:push_back(workerInfo)
          isSet = true
        end
      end
    end
    if true == isSet then
      if self._config._workerGradeString[5] == self._filterGrade then
        table.sort(workerArray, gradeSort_do)
      end
      townTable[plantRawIdx] = workerArray
    end
  end
  local workerCount = 0
  for _, workerArray in pairs(townTable) do
    for townIndex = 1, #workerArray do
      local workerInfo = workerArray[townIndex]
      self._ui._list2_Worker:getElementManager():pushKey(workerInfo._workerNoRaw)
      self._workerList[workerCount] = workerInfo._workerNoRaw
      workerCount = workerCount + 1
    end
  end
  self._workerCount = workerCount
  if workerCount <= 0 then
    self._selectedWorker = nil
  end
  self._townList[-1] = self._config._workerTownString[0]
  self._gradeList[-1] = self._config._workerGradeString[5]
end
function workerManager:open()
  if true == Panel_Window_WorkerManager_Renew:GetShow() then
    return
  end
  Panel_Window_WorkerManager_Renew:SetShow(true)
  local isConsole = ToClient_isConsole()
  self:setShowUI(self._ui._pcUI, not isConsole)
  self:setShowUI(self._ui._xboxUI, isConsole)
end
function PaGlobalFunc_WorkerManager_Open()
  workerManager:resetData()
  workerManager:open()
  workerManager:selectTab(workerManager._selectedTab)
  workerManager:update()
end
function workerManager:temporaryOpen()
end
function workerManager:temporaryClose()
end
function PaGlobalFunc_WorkerManager_TemporaryOpen()
end
function PaGlobalFunc_WorkerManager_TemporaryClose()
end
function workerManager:close()
  PaGlobalFunc_WorkerManager_Restore_Close()
  PaGlobalFunc_WorkerManager_ChangeSkill_Close()
  Panel_Window_WorkerManager_Renew:SetShow(false)
end
function PaGlobalFunc_WorkerManager_Close()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  workerManager:close()
end
function workerManager:changeTab(changeValue)
  local tabIndex = self._selectedTab + changeValue
  if tabIndex < 0 then
    tabIndex = self._config._Tab._TabCount - 1
  elseif tabIndex >= self._config._Tab._TabCount then
    tabIndex = self._config._Tab._Base
  end
  self:selectTab(tabIndex)
end
function PaGlobalFunc_WorkerManager_ChangeTab(changeValue)
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  workerManager:changeTab(changeValue)
  workerManager:update()
end
function workerManager:selectTab(tabIndex)
  for _, controlName in pairs(self._ui._tabText) do
    controlName:SetFontColor(4287862695)
  end
  self._ui._xboxUI._staticText_Restore_ConsoleUI:SetShow(false)
  self._ui._xboxUI._staticText_Redo_ConsoleUI:SetShow(false)
  self._ui._xboxUI._staticText_DoFire_ConsoleUI:SetShow(false)
  self._ui._xboxUI._staticText_ChangeSkill_ConsoleUI:SetShow(false)
  self._ui._xboxUI._staticText_Upgrade_ConsoleUI:SetShow(false)
  if self._config._Tab._Base == tabIndex then
    self._ui._tabText._radioButton_BaseOrder:SetFontColor(Defines.Color.C_FFEEEEEE)
  elseif self._config._Tab._Skill == tabIndex then
    self._ui._tabText._radioButton_Skill:SetFontColor(Defines.Color.C_FFEEEEEE)
  elseif self._config._Tab._Upgrade == tabIndex then
    self._ui._tabText._radioButton_Upgrade:SetFontColor(Defines.Color.C_FFEEEEEE)
  end
  self._selectedTab = tabIndex
  self:selectWorker(self._selectedWorker)
  self:setRightPanelInfo(self._selectedWorker)
end
function PaGlobalFunc_WorkerManager_SelectTab(tabIndex)
  workerManager:selectTab(tabIndex)
  workerManager:update()
end
function workerManager:workerRestore(isRestoreAll)
  if self._workerCount <= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
    return
  end
  PaGlobalFunc_WorkerManager_Restore_Open(isRestoreAll)
end
function PaGlobalFunc_WorkerManager_WorkerRestore(isRestoreAll)
  _AudioPostEvent_SystemUiForXBOX(51, 7)
  workerManager:workerRestore(isRestoreAll)
end
function workerManager:workerRepeat(workerNoRaw)
  if nil == workerNoRaw then
    return
  end
  local workerWrapperLua = getWorkerWrapper(workerNoRaw)
  local currentActionPoint = workerWrapperLua:getActionPoint()
  local workerWorkingPrimitiveWrapper = workerWrapperLua:getWorkerRepeatableWorkingWrapper()
  if nil == workerWorkingPrimitiveWrapper then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX_WORKERMANAGER_CANTREPEAT_WORK"))
    return
  end
  if workerWrapperLua:isWorkerRepeatable() then
    if CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking == workerWorkingPrimitiveWrapper:getType() then
      ToClient_requestRepeatWork(WorkerNo(workerNoRaw), 1)
      self:update()
    elseif currentActionPoint > 0 then
      ToClient_requestRepeatWork(WorkerNo(workerNoRaw), currentActionPoint)
    end
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX_WORKERMANAGER_CANTREPEAT_WORK"))
  end
end
function PaGlobalFunc_WorkerManager_WorkerRepeat()
  if nil == workerManager._selectedWorker or "" == workerManager._selectedWorker then
    return
  end
  workerManager:workerRepeat(tonumber64(workerManager._selectedWorker))
end
function workerManager:workerRepeatAll()
  if self._workerCount <= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
    return
  end
  for index = 0, self._workerCount - 1 do
    local workerNoRaw = self._workerList[index]
    if nil == workerNoRaw then
      break
    end
    self:workerRepeat(workerNoRaw)
  end
end
function PaGlobalFunc_WorkerManager_WorkerRepeatAll()
  workerManager:workerRepeatAll()
end
function workerManager:clearWorkerRepeatInfo(workerNoRaw)
  local workerWrapperLua = getWorkerWrapper(workerNoRaw)
  local function doUnRepeatWork()
    ToClient_requestEraseRepeat(WorkerNo(workerNoRaw))
    self:update()
  end
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_MESSAGEBOX_UNREPEATCONFIRM"),
    functionYes = doUnRepeatWork,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_WorkerManager_clearWorkerRepeatInfo()
  if nil == self._selectedWorker or "" == self._selectedWorker then
    return
  end
  workerManager:clearWorkerRepeatInfo(tonumber64(self._selectedWorker))
end
function workerManager:workerFire()
  if "" == self._selectedWorker or nil == self._selectedWorker then
    return
  end
  local function do_CheckedWorker_Fire()
    local workerNo_64 = tonumber64(self._selectedWorker)
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    ToClient_requestDeleteMyWorker(WorkerNo(workerNo_64))
    self._selectedWorker = nil
    self:update()
  end
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
  local messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_XBOX_WORKERMANAGER_QUESTION_FIRE")
  local messageboxData = {
    title = messageTitle,
    content = messageContent,
    functionYes = do_CheckedWorker_Fire,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "middle")
end
function PaGlobalFunc_WorkerManager_WorkerFire()
  workerManager:workerFire()
end
function workerManager:workerStop()
  if "" == self._selectedWorker or nil == self._selectedWorker then
    return
  end
  local workerNoRaw = tonumber64(self._selectedWorker)
  local workerWrapperLua = getWorkerWrapper(workerNoRaw)
  if nil ~= workerWrapperLua then
    do
      local workerNo = workerNoRaw
      local leftWorkCount = workerWrapperLua:getWorkingCount()
      local workingState = workerWrapperLua:getWorkingStateXXX()
      if CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Working == workingState then
        ToClient_requestChangeWorkingState(WorkerNo(workerNo), CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Return)
        return
      elseif CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Return == workingState then
        Proc_ShowMessage_Ack_With_ChatType(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_MESSAGE_GOHOME"), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
        return
      end
      if leftWorkCount < 1 then
        Proc_ShowMessage_Ack_With_ChatType(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_HOUSECONTROL_ONLYONEWORK"), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
        return
      else
        local function cancelDoWork()
          ToClient_requestCancelNextWorking(WorkerNo(workerNo))
        end
        local workName = workerWrapperLua:getWorkString()
        local cancelWorkContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_TOWN_WORKERMANAGE_CONFIRM_WORKCANCEL", "workName", workName)
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_WORKINGPROGRESS_CANCELWORK_TITLE"),
          content = cancelWorkContent,
          functionYes = cancelDoWork,
          functionCancel = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData, "top")
      end
    end
  end
end
function PaGlobalFunc_WorkerManager_WorkerStop()
  workerManager:workerStop()
end
function workerManager:workerChangeSkill()
  PaGlobalFunc_WorkerManager_ChangeSkill_Open()
end
function PaGlobalFunc_WorkerManager_WorkerChangeSkill()
  workerManager:workerChangeSkill()
end
function workerManager:workerUpgrade()
  if "" == self._selectedWorker or nil == self._selectedWorker then
    return
  end
  local workerWrapperLua = getWorkerWrapper(tonumber64(self._selectedWorker))
  local function do_Upgrade_Worker()
    workerWrapperLua:requestUpgrade()
    self:update()
  end
  local workerName = workerWrapperLua:getName()
  local workingTime = workerWrapperLua:getLeftWorkingTime()
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
  local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_UPGRADEDESC", "name", workerName)
  local messageboxData = {
    title = messageTitle,
    content = messageContent,
    functionYes = do_Upgrade_Worker,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "top")
end
function PaGlobalFunc_WorkerManager_WorkerUpgrade()
  workerManager:workerUpgrade()
end
function PaGlobalFunc_WorkerManager_PerFrameUpdate(deltaTime)
  workerManager:perFrameUpdate(deltaTime)
end
function workerManager:perFrameUpdate(deltaTime)
  self._elapsedTime = self._elapsedTime + deltaTime
  if self._elapsedTime > 1 then
    self:update()
    self._elapsedTime = 0
  end
end
function workerManager:listCreate(control, key)
  control:SetIgnore(false)
  local _button_ButtonBg = UI.getChildControl(control, "Button_ButtonBg")
  local _static_WorkerImage = UI.getChildControl(control, "Static_WorkerImage")
  local _staticText_WorkerTitle = UI.getChildControl(control, "StaticText_WorkerTitle")
  local _staticText_Town = UI.getChildControl(control, "StaticText_Node")
  local _staticText_WorkingNameCount = UI.getChildControl(control, "StaticText_WorkingNameCount")
  local _static_RemainTimeProgressBg = UI.getChildControl(control, "Static_RemainTimeProgressBg")
  local _progress2_RemainTimeProgress = UI.getChildControl(control, "Progress2_RemainTimeProgress")
  local _static_EnergyProgressBg = UI.getChildControl(control, "Static_EnergyProgressBg")
  local _progress2_EnergyProgress = UI.getChildControl(control, "Progress2_EnergyProgress")
  local workerWrapperLua = getWorkerWrapper(key)
  if nil == workerWrapperLua then
    return
  end
  local titleText = workerWrapperLua:getGradeToColorString() .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. " " .. workerWrapperLua:getLevel() .. " " .. workerWrapperLua:getName() .. "<PAOldColor>"
  local totalWorkTime = workerWrapperLua:getTotalWorkTime() / 1000
  local leftTime = totalWorkTime - ToClient_getWorkingTime(key)
  if leftTime < 0 then
    leftTime = 0
  end
  local leftMin = math.floor(leftTime / 60)
  local leftSec = leftTime - leftMin * 60
  local leftTimeText = leftMin .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE") .. " " .. leftSec .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND")
  local leftTimePercent = leftTime / totalWorkTime * 100
  local totalEnergy = 100
  local leftEnergy = 100
  _staticText_WorkerTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  _staticText_WorkerTitle:SetText(titleText)
  _static_WorkerImage:ChangeTextureInfoName(workerWrapperLua:getWorkerIcon())
  _staticText_Town:SetText(ToClient_GetNodeNameByWaypointKey(workerWrapperLua:getHomeWaypoint()))
  _staticText_WorkingNameCount:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  _staticText_WorkingNameCount:SetText(workerWrapperLua:getWorkString())
  _progress2_RemainTimeProgress:SetProgressRate(leftTimePercent)
  _progress2_EnergyProgress:SetProgressRate(workerWrapperLua:getActionPointPercents())
  _button_ButtonBg:addInputEvent("Mouse_On", "PaGlobalFunc_WorkerManager_SetRightPanelInfo(\"" .. tostring(key) .. "\")")
end
function PaGlobalFunc_WorkerManager_listCreat(control, key)
  workerManager:listCreate(control, key)
end
function workerManager:selectWorker(workerNoRawStr)
  self._selectedWorker = workerNoRawStr
  self._ui._xboxUI._staticText_Restore_ConsoleUI:SetShow(false)
  self._ui._xboxUI._staticText_Redo_ConsoleUI:SetShow(false)
  self._ui._xboxUI._staticText_DoFire_ConsoleUI:SetShow(false)
  self._ui._xboxUI._staticText_ChangeSkill_ConsoleUI:SetShow(false)
  self._ui._xboxUI._staticText_Upgrade_ConsoleUI:SetShow(false)
  Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
  Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
  if nil == workerNoRawStr then
    return
  end
  local workerWrapperLua = getWorkerWrapper(tonumber64(workerNoRawStr))
  if nil == workerWrapperLua then
    return
  end
  local workingState = workerWrapperLua:getWorkingType()
  if self._config._Tab._Base == self._selectedTab then
    self._ui._xboxUI._staticText_Restore_ConsoleUI:SetShow(true)
    self._ui._xboxUI._staticText_Redo_ConsoleUI:SetShow(true)
    self._ui._xboxUI._staticText_Restore_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE"))
    Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_WorkerManager_WorkerRestore(false)")
    if CppEnums.NpcWorkingType.eNpcWorkingType_Count == workingState then
      self._ui._xboxUI._staticText_DoFire_ConsoleUI:SetShow(true)
      self._ui._xboxUI._staticText_Redo_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_REPEAT_NAME"))
      self._ui._xboxUI._staticText_DoFire_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_BUTTONFIRE"))
      Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_WorkerManager_WorkerRepeat()")
      Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_WorkerManager_WorkerFire()")
    else
      self._ui._xboxUI._staticText_Redo_ConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKINGPROGRESS_CANCELWORK_TITLE"))
      Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_WorkerManager_WorkerStop()")
    end
  elseif self._config._Tab._Skill == self._selectedTab then
    self._ui._xboxUI._staticText_ChangeSkill_ConsoleUI:SetShow(true)
    Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_WorkerManager_WorkerChangeSkill()")
  else
    self._ui._xboxUI._staticText_Upgrade_ConsoleUI:SetShow(true)
    self._ui._xboxUI._staticText_Upgrade_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERMANAGER_PROMOTION"))
    Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_WorkerManager_WorkerUpgrade()")
  end
end
function PaGlobalFunc_WorkerManager_SelectWorker(workerNoRawStr)
  workerManager:selectWorker(workerNoRawStr)
end
function workerManager:setWorkerBaseInfo(workerNoRawStr)
  local workerManagerUI = self._ui
  workerManagerUI._static_WorkerInformationBg:SetShow(true)
  local isShow = workerNoRawStr ~= nil
  workerManagerUI._staticText_WorkerState:SetShow(false)
  workerManagerUI._static_RemainTimeProgressBg:SetShow(isShow)
  workerManagerUI._Progress2_RemainTimeProgress:SetShow(isShow)
  workerManagerUI._staticText_WorkingNameCount:SetShow(isShow)
  workerManagerUI._static_WorkerImage:SetShow(isShow)
  workerManagerUI._staticText_WorkerTitle:SetShow(isShow)
  workerManagerUI._staticText_Node:SetShow(isShow)
  workerManagerUI._staticText_WorkingSpeedTitle:SetShow(isShow)
  workerManagerUI._staticText_MovingSpeedTitle:SetShow(isShow)
  workerManagerUI._staticText_LuckTitle:SetShow(isShow)
  workerManagerUI._staticText_EnergyTitle:SetShow(isShow)
  workerManagerUI._staticText_WorkingSpeedValue:SetShow(isShow)
  workerManagerUI._staticText_MovingSpeedValue:SetShow(isShow)
  workerManagerUI._staticText_LuckValue:SetShow(isShow)
  workerManagerUI._staticText_EnergyValue:SetShow(isShow)
  if false == isShow then
    return
  end
  local workerWrapperLua = getWorkerWrapper(tonumber64(workerNoRawStr))
  if nil == workerWrapperLua then
    return
  end
  local titleText = workerWrapperLua:getGradeToColorString() .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. " " .. workerWrapperLua:getLevel() .. " " .. workerWrapperLua:getName() .. "<PAOldColor>"
  local totalWorkTime = workerWrapperLua:getTotalWorkTime() / 1000
  local leftTime = totalWorkTime - ToClient_getWorkingTime(tonumber64(workerNoRawStr))
  if leftTime < 0 then
    leftTime = 0
  end
  local leftMin = math.floor(leftTime / 60)
  local leftSec = leftTime - leftMin * 60
  local leftTimeText = leftMin .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE") .. " " .. leftSec .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND")
  local leftTimePercent = leftTime / totalWorkTime * 100
  workerManagerUI._static_WorkerImage:ChangeTextureInfoName(workerWrapperLua:getWorkerIcon())
  local uiScale = ToClient_getGameOptionControllerWrapper():getUIScale()
  local radius = workerManagerUI._static_WorkerImage:GetSizeX() * 0.5 * uiScale
  local centerPos = float2(radius / uiScale, radius / uiScale)
  workerManagerUI._static_WorkerImage:SetCircularClip(radius, centerPos)
  workerManagerUI._staticText_WorkerTitle:SetText(titleText)
  workerManagerUI._staticText_Node:SetText(ToClient_GetNodeNameByWaypointKey(workerWrapperLua:getHomeWaypoint()))
  local isWorkingStateShow = self._config._Tab._Upgrade ~= self._selectedTab
  if isWorkingStateShow then
    workerManagerUI._Progress2_RemainTimeProgress:SetProgressRate(leftTimePercent)
    workerManagerUI._staticText_WorkingNameCount:SetText(workerWrapperLua:getWorkString())
  end
  workerManagerUI._static_RemainTimeProgressBg:SetShow(isWorkingStateShow)
  workerManagerUI._Progress2_RemainTimeProgress:SetShow(isWorkingStateShow)
  workerManagerUI._staticText_WorkingNameCount:SetShow(isWorkingStateShow)
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
  workerManagerUI._staticText_WorkingSpeedValue:SetText(string.format("%.2f", tostring(_tempWorkEfficiency / 1000000)))
  workerManagerUI._staticText_MovingSpeedValue:SetText(string.format("%.2f", workerWrapperLua:getMoveSpeed() / 100))
  workerManagerUI._staticText_LuckValue:SetText(string.format("%.2f", workerWrapperLua:getLuck() / 10000))
  workerManagerUI._staticText_EnergyValue:SetText(workerWrapperLua:getMaxActionPoint())
end
function workerManager:setWorkerSkillInfo(workerNoRawStr)
  if nil == workerNoRawStr then
    return
  end
  local workerWrapperLua = getWorkerWrapper(tonumber64(workerNoRawStr))
  if nil == workerWrapperLua then
    return
  end
  local defaultSkill = workerWrapperLua:getWorkerDefaultSkillStaticStatus()
  local changeFlag = 0
  local posX = 30
  local posY = 20
  local startIdx = 1
  local endIdx = self._config._skillSlotCount
  if nil ~= defaultSkill then
    local lastControl = self._ui._skillSlot[self._config._skillSlotCount]
    startIdx = startIdx + 1
    lastControl._static_SkillSlotBg:SetShow(true)
    lastControl._static_SkillSlot:SetShow(true)
    lastControl._staticText_SkillTitle:SetShow(true)
    lastControl._staticText_SkillDesc:SetShow(true)
    local control = self._ui._skillSlot[1]
    control._static_SkillSlotBg:SetShow(true)
    control._static_SkillSlot:ChangeTextureInfoName(defaultSkill:getIconPath())
    control._staticText_SkillTitle:SetText(defaultSkill:getName())
    control._staticText_SkillDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    control._staticText_SkillDesc:SetText(defaultSkill:getDescription())
  else
    local lastControl = self._ui._skillSlot[self._config._skillSlotCount]
    lastControl._static_SkillSlotBg:SetShow(false)
    lastControl._static_SkillSlot:SetShow(false)
    lastControl._staticText_SkillTitle:SetShow(false)
    lastControl._staticText_SkillDesc:SetShow(false)
    endIdx = endIdx - 1
  end
  self._ui._static_WorkerSkillBg:SetShow(true)
  for index = startIdx, endIdx do
    local control = self._ui._skillSlot[index]
    control._static_SkillSlotBg:SetShow(true)
    local learnLevel = (index - 1) * 5
    local basicTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. learnLevel
    control._static_SkillSlot:ChangeTextureInfoName("renewal/commonicon/wokerskill_00.dds")
    control._staticText_SkillTitle:SetText(basicTitle)
    control._staticText_SkillDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERCHANGESKILL_NOTYETSTUDYSKILL"))
  end
  workerWrapperLua:foreachSkillList(function(skillIdx, skillStaticStatusWrapper)
    if nil ~= defaultSkill then
      skillIdx = skillIdx + 1
    end
    local slotControl = self._ui._skillSlot[skillIdx + 1]
    if nil == slotControl then
      return true
    end
    self:setSkillInfoToSlot(skillIdx + 1, skillStaticStatusWrapper)
    return false
  end)
end
function workerManager:setSkillInfoToSlot(skillIdx, skillStaticStatusWrapper)
  local slotControl = self._ui._skillSlot[skillIdx]
  slotControl._static_SkillSlot:ChangeTextureInfoNameAsync(skillStaticStatusWrapper:getIconPath())
  slotControl._staticText_SkillTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  slotControl._staticText_SkillTitle:SetText(skillStaticStatusWrapper:getName())
  slotControl._staticText_SkillDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  slotControl._staticText_SkillDesc:SetText(skillStaticStatusWrapper:getDescription())
  return true
end
function workerManager:setWorkerUpgradeTexture(upgradeSlot, upgradeTextureType)
  local x1, y1, x2, y2
  if self._config._workerUpgradeTextureType._Fail == upgradeTextureType then
    x1, y1, x2, y2 = setTextureUV_Func(upgradeSlot, 1, 1, 118, 118)
  elseif self._config._workerUpgradeTextureType._Upgradable == upgradeTextureType then
    x1, y1, x2, y2 = setTextureUV_Func(upgradeSlot, 119, 1, 236, 118)
  else
    x1, y1, x2, y2 = setTextureUV_Func(upgradeSlot, 237, 1, 354, 118)
  end
  upgradeSlot:getBaseTexture():setUV(x1, y1, x2, y2)
  upgradeSlot:setRenderTexture(upgradeSlot:getBaseTexture())
end
local isShowMessage
function workerManager:setWorkerUpgradeInfo(workerNoRawStr)
  self._ui._static_UpgradeBg:SetShow(true)
  self._ui._static_DescBg:SetShow(true)
  local upgradeSlot = self._ui._upgradeSlot
  local textureType = self._config._workerUpgradeTextureType
  if workerNoRawStr == nil or workerNoRawStr == "" then
    for index = 1, self._config._upgradeSlotCount do
      upgradeSlot[index]._staticText_UpgradeLevel:SetShow(false)
      upgradeSlot[index]._staticText_UpgradeState:SetShow(false)
    end
    return
  end
  local workerWrapperLua = getWorkerWrapper(tonumber64(workerNoRawStr))
  local upgradableCount = workerWrapperLua:getUpgradePoint()
  local workeLv = workerWrapperLua:getLevel()
  local maxUpgradePoint = math.floor(workeLv / 10)
  local upgradeFailCount = maxUpgradePoint - upgradableCount
  local isProgressing = false
  local isUpgradable = workerWrapperLua:isUpgradable()
  if workerNoRawStr ~= isShowMessage then
    isShowMessage = nil
  end
  if 4 <= workerWrapperLua:getGrade() then
    self._ui._xboxUI._staticText_Upgrade_ConsoleUI:SetShow(false)
    Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
    if nil == isShowMessage then
      isShowMessage = workerNoRawStr
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_NOMORE_UPGRADE"))
    end
  elseif CppEnums.NpcWorkingType.eNpcWorkingType_Upgrade == workerWrapperLua:getWorkingType() then
    upgradeFailCount = upgradeFailCount - 1
    if upgradeFailCount < 0 then
      upgradeFailCount = 0
    end
    isProgressing = true
    self._ui._xboxUI._staticText_Upgrade_ConsoleUI:SetShow(true)
    self._ui._xboxUI._staticText_Upgrade_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERMANAGER_PROMOTION_NOW"))
    Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_SorkerManager_WorkerUpgradeNow()")
  elseif upgradeFailCount >= 3 then
    self._ui._xboxUI._staticText_Upgrade_ConsoleUI:SetShow(true)
    self._ui._xboxUI._staticText_Upgrade_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERMANAGER_PROMOTION_RESET"))
    Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_ResetUpgradeCount()")
  end
  for index = 1, self._config._upgradeSlotCount do
    upgradeSlot[index]._staticText_UpgradeState:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    if upgradeFailCount > 0 then
      self:setWorkerUpgradeTexture(upgradeSlot[index]._static_UpgradeStateBg, textureType._Fail)
      upgradeSlot[index]._staticText_UpgradeLevel:SetFontColor(self._config._fontColor._upgrade_Fail)
      upgradeSlot[index]._staticText_UpgradeState:SetFontColor(self._config._fontColor._upgrade_Fail)
      upgradeSlot[index]._staticText_UpgradeState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKER_UPGRADE_FAIL"))
      upgradeFailCount = upgradeFailCount - 1
    elseif true == isProgressing then
      isProgressing = false
      isUpgradable = false
      self:setWorkerUpgradeTexture(upgradeSlot[index]._static_UpgradeStateBg, textureType._Upgradable)
      upgradeSlot[index]._staticText_UpgradeLevel:SetFontColor(self._config._fontColor._upgrade_NormalLevel)
      upgradeSlot[index]._staticText_UpgradeState:SetFontColor(self._config._fontColor._upgrade_NormalState)
      upgradeSlot[index]._staticText_UpgradeState:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUESTWINDOW_TAB_PROGRESS"))
    elseif upgradableCount > 0 and true == isUpgradable then
      self:setWorkerUpgradeTexture(upgradeSlot[index]._static_UpgradeStateBg, textureType._Upgradable)
      upgradeSlot[index]._staticText_UpgradeLevel:SetFontColor(self._config._fontColor._upgrade_NormalLevel)
      upgradeSlot[index]._staticText_UpgradeState:SetFontColor(self._config._fontColor._upgrade_NormalState)
      upgradeSlot[index]._staticText_UpgradeState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKER_UPGRADE_AVAILABLE"))
      isUpgradable = false
    else
      self:setWorkerUpgradeTexture(upgradeSlot[index]._static_UpgradeStateBg, textureType._InActivation)
      upgradeSlot[index]._staticText_UpgradeLevel:SetFontColor(self._config._fontColor._upgrade_Inactivation)
      upgradeSlot[index]._staticText_UpgradeState:SetFontColor(self._config._fontColor._upgrade_Inactivation)
      upgradeSlot[index]._staticText_UpgradeState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKER_UPGRADE_AVAILABLE"))
    end
  end
end
function workerManager:setRightPanelInfo(workerNoRawStr)
  self._ui._static_WorkerSkillBg:SetShow(false)
  self._ui._static_UpgradeBg:SetShow(false)
  self._ui._static_DescBg:SetShow(false)
  if self._config._Tab._Base == self._selectedTab then
    self:setWorkerBaseInfo(workerNoRawStr)
    self:setWorkerSkillInfo(workerNoRawStr)
    local workerManagerUI = workerManager._ui
    local keyGuide = {
      workerManagerUI._xboxUI._staticText_Restore_ConsoleUI,
      workerManagerUI._xboxUI._staticText_Redo_ConsoleUI,
      workerManagerUI._xboxUI._staticText_DoFire_ConsoleUI,
      workerManagerUI._xboxUI._staticText_ChangeSkill_ConsoleUI,
      workerManagerUI._xboxUI._staticText_Upgrade_ConsoleUI
    }
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuide, workerManagerUI._static_ButtonBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  elseif self._config._Tab._Upgrade == self._selectedTab then
    self:setWorkerBaseInfo(workerNoRawStr)
    self:setWorkerUpgradeInfo(workerNoRawStr)
    local workerManagerUI = workerManager._ui
    local keyGuide = {
      workerManagerUI._xboxUI._staticText_Upgrade_ConsoleUI
    }
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuide, workerManagerUI._static_ButtonBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  elseif self._config._Tab._Skill == self._selectedTab then
    self:setWorkerBaseInfo(workerNoRawStr)
    self:setWorkerSkillInfo(workerNoRawStr)
    local workerManagerUI = workerManager._ui
    local keyGuide = {
      workerManagerUI._xboxUI._staticText_Restore_ConsoleUI,
      workerManagerUI._xboxUI._staticText_Redo_ConsoleUI,
      workerManagerUI._xboxUI._staticText_DoFire_ConsoleUI,
      workerManagerUI._xboxUI._staticText_ChangeSkill_ConsoleUI,
      workerManagerUI._xboxUI._staticText_Upgrade_ConsoleUI
    }
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuide, workerManagerUI._static_ButtonBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  end
end
function PaGlobalFunc_WorkerManager_SetRightPanelInfo(workerNoRawStr)
  workerManager:selectWorker(workerNoRawStr)
  workerManager:setRightPanelInfo(workerNoRawStr)
end
function PaGlobalFunc_WorkerManager_GetSelectWorkerCount()
  return workerManager._workerCount
end
function PaGlobalFunc_WorkerManager_GetSelectWorker()
  if workerManager._workerCount <= 0 then
    return nil
  end
  return workerManager._selectedWorker
end
function PaGlobalFunc_WorkerManager_GetTotalRestoreCount(selectedItemIdx)
  if workerManager._workerCount <= 0 then
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
  for index = 0, workerManager._workerCount - 1 do
    local workerNoRaw = workerManager._workerList[index]
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
function PaGlobalFunc_WorkerManager_GetSelectWorkerList()
  if workerManager._workerCount <= 0 then
    return nil
  end
  return workerManager._workerList
end
function PaGlobalFunc_WorkerManager_GetTownList()
  return workerManager._townList
end
function PaGlobalFunc_WorkerManager_GetGradeList()
  return workerManager._gradeList
end
function workerManager:setFilter(townFilter, gradeFilter)
  self._selectedWorker = nil
  if nil == townFilter then
    self._filterTown = self._config._workerTownString[0]
  else
    self._filterTown = townFilter
  end
  if nil == gradeFilter then
    self._filterGrade = self._config._workerGradeString[5]
  else
    self._filterGrade = gradeFilter
  end
  self:update(true)
end
function PaGlobalFunc_WorkerManager_SetFilter(townFilter, gradeFilter)
  workerManager:setFilter(townFilter, gradeFilter)
end
function workerManager:pushStartMessage(workerNo, _workType, buildingInfoSS)
  local workType = self._config._workType
  if _workType == workType._HouseCraft then
    local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
    if esSSW:isSet() then
      local workName = esSSW:getDescription()
      Proc_ShowMessage_Ack_With_ChatType(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_START_CRAFT", "workName", workName), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Worker)
    end
  elseif _workType == workType._LargeCraft then
    local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
    if esSSW:isSet() then
      local workName = esSSW:getDescription()
      local esSS = esSSW:get()
      local eSSCount = getExchangeSourceNeedItemList(esSS, true)
      local resourceIndex = ToClient_getLargeCraftWorkIndexByWorker(workerNo)
      local itemStaticInfomationWrapper = getExchangeSourceNeedItemByIndex(resourceIndex)
      local itemStaticWrapper = itemStaticInfomationWrapper:getStaticStatus()
      local itemStatic = itemStaticWrapper:get()
      local subWorkName = tostring(getItemName(itemStatic))
      Proc_ShowMessage_Ack_With_ChatType(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_START_LARGECRAFT", "workName", workName, "subWorkName", subWorkName), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Worker)
    end
  elseif _workType == workType._PlantWork then
    local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
    if nil ~= esSSW and esSSW:isSet() then
      local workName = esSSW:getDescription()
      Proc_ShowMessage_Ack_With_ChatType(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_START_PLANTWORK", "workName", workName), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Worker)
    end
  elseif _workType == workType._Building then
    if nil == buildingInfoSS then
      return
    end
    local workName = ToClient_getBuildingName(buildingInfoSS)
    local subWorkIndex = ToClient_getBuildingWorkingIndex(workerNo)
    local workCount = ToClient_getBuildingWorkableListCount(buildingInfoSS)
    local buildingStaticStatus = ToClient_getBuildingWorkableBuildingSourceUnitByIndex(buildingInfoSS, subWorkIndex)
    local itemStatic = buildingStaticStatus:getItemStaticStatus()
    local subWorkName = getItemName(itemStatic)
    Proc_ShowMessage_Ack_With_ChatType(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_START_BUILDING", "workName", workName, "subWorkName", subWorkName), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Worker)
  elseif _workType == workType._upgrade then
  elseif _workType == workType._RegionWork then
  end
end
function Push_Work_Start_Message(workerNo, _workType, buildingInfoSS)
  workerManager:pushStartMessage(workerNo, _workType, buildingInfoSS)
end
function workerManager:pushStopMessage(workerNo, isUserRequest, working)
  local npcWorkerWrapper = ToClient_getNpcWorkerByWorkerNo(workerNo)
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
function Push_Worker_StopWork_Message(workerNo, isUserRequest, working)
  workerManager:pushStopMessage(workerNo, isUserRequest, working)
end
function workerManager:pushWorkerResultItemMessage(WorkerNoRaw)
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
function Push_Work_ResultItem_Message(WorkerNoRaw)
  workerManager:pushWorkerResultItemMessage(WorkerNoRaw)
end
function workerManager:workerDataUpdateHeadingPlant(ExplorationNode, workerNo)
  local workType = self._config._workType
  if 0 ~= Int64toInt32(workerNo) and false == ExplorationNode:getStaticStatus():getRegion():isMainOrMinorTown() then
    Push_Work_Start_Message(workerNo, workType._PlantWork)
  end
  local _plantKey = ExplorationNode:getPlantKey()
  local wayPlant = ToClient_getPlant(_plantKey)
  local plant = getPlant(_plantKey)
  local affiliatedTownKey = ToClinet_getPlantAffiliatedWaypointKey(wayPlant)
  if _plantKey:get() == 151 then
    FGlobal_MiniGame_RequestPlantWorking()
  end
  if plantKey == nil then
    return
  end
  self:update()
end
function FromClient_WorkerDataUpdate_HeadingPlant(ExplorationNode, workerNo)
  workerManager:workerDataUpdateHeadingPlant(ExplorationNode, workerNo)
end
function workerManager:workerDataUpdateHeadingHouse(rentHouseWrapper, workerNo)
  local workType = self._config._workType
  if 0 ~= Int64toInt32(workerNo) then
    local UseGroupType = rentHouseWrapper:getHouseUseType()
    if UseGroupType == 12 or UseGroupType == 13 or UseGroupType == 14 then
      Push_Work_Start_Message(workerNo, workType._LargeCraft)
    else
      Push_Work_Start_Message(workerNo, workType._HouseCraft)
    end
  end
  if plantKey == nil then
    return
  end
  local houseInfoSS = rentHouseWrapper:getStaticStatus():get()
  local affiliatedTownKey = ToClient_getHouseAffiliatedWaypointKey(houseInfoSS)
  self:update()
end
function FromClient_WorkerDataUpdate_HeadingHouse(rentHouseWrapper, workerNo)
  workerManager:workerDataUpdateHeadingHouse(rentHouseWrapper, workerNo)
end
function workerManager:workerDataUpdateHeadingBuilding(buildingInfoSS, workerNo)
  local workType = self._config._workType
  if 0 ~= Int64toInt32(workerNo) then
    Push_Work_Start_Message(workerNo, workType._Building, buildingInfoSS)
  end
  if plantKey == nil then
    return
  end
  local affiliatedTownKey = ToClient_getBuildingAffiliatedWaypointKey(buildingInfoSS)
  workerManager:update()
end
function FromClient_WorkerDataUpdate_HeadingBuilding(buildingInfoSS, workerNo)
  workerManager:workerDataUpdateHeadingBuilding(buildingInfoSS, workerNo)
end
function workerManager:workerDataUpdateHeadingRegionManaging(regionGroupInfo, workerNo)
  local workType = self._config._workType
  if 0 ~= Int64toInt32(workerNo) then
    Push_Work_Start_Message(workerNo, workType._RegionWork)
  end
  workerManager:update()
end
function FromClient_WorkerDataUpdate_HeadingRegionManaging(regionGroupInfo, workerNo)
  workerManager:workerDataUpdateHeadingRegionManaging(regionGroupInfo, workerNo)
end
function workerManager:upgradeNow()
  local workerNoRaw = tonumber64(self._selectedWorker)
  local remainTimeInt = ToClient_getWorkingTime(workerNoRaw)
  local needPearl = ToClient_GetUsingPearlByRemainingPearl(CppEnums.InstantCashType.eInstant_CompleteNpcWorkerUpgrade, remainTimeInt)
  local function doUpgradeNow()
    ToClient_requestQuickComplete(WorkerNo(workerNoRaw), needPearl)
    self._selectedWorker = nil
  end
  local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_IMMEDIATELYCOMPLETE_MSGBOX_TITLE")
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_UPGRADENOW_CONFIRM", "pearl", tostring(needPearl))
  local messageboxData = {
    title = messageboxTitle,
    content = messageBoxMemo,
    functionYes = doUpgradeNow,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "middle")
end
function PaGlobalFunc_SorkerManager_WorkerUpgradeNow()
  workerManager:upgradeNow()
end
function workerManager:resetUpgradeCount()
  if not ToClient_doHaveClearWorkerUpgradeItem() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_NOITEMALERT"))
    return
  end
  local workerNoRaw = tonumber64(self._selectedWorker)
  local workerWrapperLua = getWorkerWrapper(workerNoRaw)
  local workerUpgradeCount = workerWrapperLua:getUpgradePoint()
  local worker_Lev = workerWrapperLua:getLevel()
  local maxUpgradePoint = math.floor(worker_Lev / 10)
  local upgradableCount = maxUpgradePoint - workerUpgradeCount
  local worker_Name = workerWrapperLua:getName()
  local function doReset()
    ToClient_requestClearWorkerUpgradePoint(workerNoRaw)
  end
  if upgradableCount > 0 then
    local title = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_MSGTITLE")
    local msg = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. worker_Lev .. " " .. workerWrapperLua:getGradeToColorString() .. worker_Name .. "<PAOldColor>"
    local content = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_MSGCONTENT", "msg", msg, "count", upgradableCount, "maxCount", maxUpgradePoint)
    local messageBoxData = {
      title = title,
      content = content,
      functionYes = doReset,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function PaGlobalFunc_ResetUpgradeCount()
  workerManager:resetUpgradeCount()
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
    local workingServerNo = getSelfPlayer():get():getWorkerWorkingServerNo()
    local temporaryWrapper = getTemporaryInformationWrapper()
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
function workerManager:registEventHandler()
  registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_WorkerManager")
  registerEvent("FromClient_AppliedChangeUseType", "PaGlobalFunc_WorkerManager_WorkerListUpdate")
  registerEvent("FromClient_ReceiveReturnHouse", "PaGlobalFunc_WorkerManager_WorkerListUpdate")
  registerEvent("WorldMap_WorkerDataUpdate", "FromClient_WorkerDataUpdate_HeadingPlant")
  registerEvent("WorldMap_WorkerDataUpdateByHouse", "FromClient_WorkerDataUpdate_HeadingHouse")
  registerEvent("WorldMap_WorkerDataUpdateByBuilding", "FromClient_WorkerDataUpdate_HeadingBuilding")
  registerEvent("WorldMap_WorkerDataUpdateByRegionManaging", "FromClient_WorkerDataUpdate_HeadingRegionManaging")
  registerEvent("FromClient_ChangeWorkerCount", "PaGlobalFunc_WorkerManager_ChangeWorkerCount()")
  registerEvent("FromClient_UpdateLastestWorkingResult", "Push_Work_ResultItem_Message")
  Panel_Window_WorkerManager_Renew:RegisterUpdateFunc("PaGlobalFunc_WorkerManager_PerFrameUpdate")
end
function PaGlobalFunc_WorkerManager_ChangeWorkerCount()
  workerManager:changeWorkerCount()
end
function workerManager:changeWorkerCount()
  self:update()
  ToClient_padSnapResetPanelControl(Panel_Window_WorkerManager_Renew)
end
function FGlobal_WorkerManger_ShowToggle()
  PaGlobalFunc_WorkerManager_Open()
  PaGlobalFunc_InventoryInfo_Close()
end
workerManager:registEventHandler()

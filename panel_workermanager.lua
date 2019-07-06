Panel_WorkerManager:SetShow(false)
Panel_WorkerManager:setGlassBackground(true)
Panel_WorkerManager:ActiveMouseEventEffect(true)
local UI_TM = CppEnums.TextMode
local UI_PP = CppEnums.PAUIMB_PRIORITY
local UI_Color = Defines.Color
local UI_PD = CppEnums.Padding
local isContentOpen = ToClient_IsContentsGroupOpen("259")
Panel_WorkerManager:RegisterShowEventFunc(true, "WorkerManager_ShowAni()")
Panel_WorkerManager:RegisterShowEventFunc(false, "WorkerManager_HideAni()")
local workerManager = {
  plantKey = nil,
  slotFixMaxCount = 6,
  slotMaxCount = 6,
  slot = {},
  startPosY = 5,
  _startIndex = 1,
  _listCount = 0,
  penelTitle = UI.getChildControl(Panel_WorkerManager, "titlebar_manageWorker"),
  workerListBg = UI.getChildControl(Panel_WorkerManager, "Static_WorkerList_BG"),
  _scroll = UI.getChildControl(Panel_WorkerManager, "WorkerList_ScrollBar"),
  _btnClose = UI.getChildControl(Panel_WorkerManager, "Button_Close"),
  checkPopUp = UI.getChildControl(Panel_WorkerManager, "CheckButton_PopUp"),
  _btnFire = UI.getChildControl(Panel_WorkerManager, "button_doWorkerFire"),
  _btnUpgradeNow = UI.getChildControl(Panel_WorkerManager, "button_UpgradeNow"),
  _restoreAll = UI.getChildControl(Panel_WorkerManager, "Button_Restore_All"),
  _reDoAll = UI.getChildControl(Panel_WorkerManager, "Button_ReDo_All"),
  _resetUpgradeCount = UI.getChildControl(Panel_WorkerManager, "Button_ResetUpgradeCount"),
  restoreItemMaxCount = 5,
  restoreItemHasCount = 0,
  restoreItemSlot = {},
  selectedRestoreWorkerIdx = 0,
  selectedUiIndex = -1,
  sliderStartIdx = 0,
  upgradeWokerNoRaw = -1,
  restoreItemBG = UI.getChildControl(Panel_WorkerManager, "Static_Restore_Item_BG"),
  btn_restoreItemClose = UI.getChildControl(Panel_WorkerManager, "Button_Close_Item"),
  _slider = UI.getChildControl(Panel_WorkerManager, "Slider_Restore_Item"),
  guideRestoreAll = UI.getChildControl(Panel_WorkerManager, "StaticText_Guide_RestoreAll"),
  desc = UI.getChildControl(Panel_WorkerManager, "StaticText_Description"),
  slotConfig = {
    createIcon = true,
    createBorder = false,
    createCount = true,
    createCash = true
  }
}
local tempTable = Array.new()
local isPopUpContentsEnable = ToClient_IsContentsGroupOpen("240")
workerManager.checkPopUp:SetShow(isPopUpContentsEnable)
workerManager._scrollBtn = UI.getChildControl(workerManager._scroll, "Frame_ScrollBar_thumb")
workerManager._sliderBtn = UI.getChildControl(workerManager._slider, "Slider_Restore_Item_Button")
local workerArray = Array.new()
function WorkerManager_ShowAni()
  Panel_WorkerManager:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_WorkerManager, 0, 0.3)
end
function WorkerManager_HideAni()
  local ani1 = UIAni.AlphaAnimation(0, Panel_WorkerManager, 0, 0.2)
  ani1:SetHideAtEnd(true)
end
function workerManager:registEventHandler()
  self._btnClose:addInputEvent("Mouse_LUp", "HandleClicked_WorkerManager_Close()")
  self.checkPopUp:addInputEvent("Mouse_LUp", "workerManager_PopUp()")
  self.checkPopUp:addInputEvent("Mouse_On", "workerManager_PopUp_ShowIconToolTip(true)")
  self.checkPopUp:addInputEvent("Mouse_Out", "workerManager_PopUp_ShowIconToolTip(false)")
  self._btnFire:addInputEvent("Mouse_LUp", "HandleClicked_workerManager_WaitWorkerFire()")
  self._btnUpgradeNow:addInputEvent("Mouse_LUp", "HandleClicked_workerManager_WorkerUpgradeNow()")
  self._restoreAll:addInputEvent("Mouse_LUp", "HandleClicked_workerManager_RestoreAll()")
  self._reDoAll:addInputEvent("Mouse_LUp", "HandleClicked_workerManager_ReDoAll()")
  self.btn_restoreItemClose:addInputEvent("Mouse_LUp", "HandleClicked_WorkerManager_RestoreItemClose()")
  self.restoreItemBG:addInputEvent("Mouse_UpScroll", "workerManager_SliderScroll( true )")
  self.restoreItemBG:addInputEvent("Mouse_DownScroll", "workerManager_SliderScroll( false )")
  self._slider:addInputEvent("Mouse_LUp", "HandleLPress_WorkerManager_RestoreItemSlider()")
  self._resetUpgradeCount:addInputEvent("Mouse_LUp", "HandleClicked_UpgradeCountReset_Show()")
  Panel_WorkerManager:RegisterUpdateFunc("workerManager_FrameUpdate")
end
function workerManager:registMessageHandler()
  registerEvent("onScreenResize", "workerManager_ResetPos")
  registerEvent("WorldMap_WorkerDataUpdate", "FromClient_WorkerDataAllUpdate")
  registerEvent("WorldMap_StopWorkerWorking", "Push_Worker_StopWork_Message")
  registerEvent("WorldMap_WorkerDataUpdate", "FromClient_WorkerDataUpdate_HeadingPlant")
  registerEvent("WorldMap_WorkerDataUpdateByHouse", "FromClient_WorkerDataUpdate_HeadingHouse")
  registerEvent("WorldMap_WorkerDataUpdateByBuilding", "FromClient_WorkerDataUpdate_HeadingBuilding")
  registerEvent("WorldMap_WorkerDataUpdateByRegionManaging", "FromClient_WorkerDataUpdate_HeadingRegionManaging")
  registerEvent("FromClient_UpdateLastestWorkingResult", "Push_Work_ResultItem_Message")
  registerEvent("FromClient_changeLeftWorking", "FromClient_changeLeftWorking")
  registerEvent("FromClient_AppliedChangeUseType", "FromClient_WorkerDataAllUpdate")
  registerEvent("FromClient_ReceiveReturnHouse", "FromClient_WorkerDataAllUpdate")
  registerEvent("FromClient_ChangeWorkerSkillNoOne", "FromClient_ChangeWorkerSkillNoOne")
  registerEvent("FromClient_ChangeWorkerSkillNo", "FromClient_ChangeWorkerSkillNo")
  registerEvent("FromClient_ClearWorkerUpgradePoint", "FromClient_ClearWorkerUpgradePoint")
end
local workedWorker = {}
local workerCheckList = {}
local workType = {
  _HouseCraft = 0,
  _LargeCraft = 1,
  _PlantWork = 2,
  _Building = 3,
  _RegionWork = 4,
  _upgrade = 5,
  _harvest = 6
}
local restoreWorkerNo
local workerGrade = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_0"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_2"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_3"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_4")
}
local function workerManager_Initiallize()
  local self = workerManager
  for slotIdx = 0, self.slotMaxCount - 1 do
    local tempSlot = {}
    tempSlot.bg = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Static_workerBG", self.workerListBg, "workerManager_WorkerSlotBG_" .. slotIdx)
    tempSlot.picture = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Static_WorkerPicture", tempSlot.bg, "workerManager_WorkerSlot_Picture_" .. slotIdx)
    tempSlot.workerCheck = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "button_worker_checkBox", tempSlot.bg, "workerManager_WorkerSlot_WorkerCheck_" .. slotIdx)
    tempSlot.workerHpBG = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Static_RestorePointBG", tempSlot.bg, "workerManager_WorkerSlot_WorkerHpBG_" .. slotIdx)
    tempSlot.workerRestorePT = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Progress2_RestorePoint", tempSlot.bg, "workerManager_WorkerSlot_WorkerRestorePT_" .. slotIdx)
    tempSlot.workerCurrentPT = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Progress2_CurrentPoint", tempSlot.bg, "workerManager_WorkerSlot_WorkerCurrentPT_" .. slotIdx)
    tempSlot.workerName = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "workerManage_workerName", tempSlot.bg, "workerManager_WorkerSlot_WorkerName_" .. slotIdx)
    tempSlot.workerNodeName = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "workerManage_workerNodeName", tempSlot.bg, "workerManager_WorkerSlot_WorkerNodeName_" .. slotIdx)
    tempSlot.progressBg = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Static_ProgressBG", tempSlot.bg, "workerManager_WorkerSlot_ProgressBg_" .. slotIdx)
    tempSlot.progress = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Progress2_RemainTime", tempSlot.bg, "workerManager_WorkerSlot_Progress_" .. slotIdx)
    tempSlot.workingName = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "workerManage_workingName", tempSlot.bg, "workerManager_WorkerSlot_WorkingName_" .. slotIdx)
    tempSlot.btn_Restore = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Button_WorkRestore", tempSlot.bg, "workerManager_WorkerSlot_BTN_WorkerRestore_" .. slotIdx)
    tempSlot.btn_Upgrade = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Button_WorkerUpgrade", tempSlot.bg, "workerManager_WorkerSlot_BTN_WorkerUpgrade_" .. slotIdx)
    tempSlot.btn_ChangeSkill = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Button_WorkerChangeSkill", tempSlot.bg, "workerManager_WorkerSlot_BTN_WorkerChangeSkill_" .. slotIdx)
    tempSlot.btn_Stop = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Button_WorkStop", tempSlot.bg, "workerManager_WorkerSlot_BTN_WorkStop_" .. slotIdx)
    tempSlot.stc_stopIcon = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Static_StopIcon", tempSlot.btn_Stop, "workerManager_WorkerSlot_BTN_WorkStop_" .. slotIdx)
    tempSlot.btn_Repeat = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Button_RepeatWork", tempSlot.bg, "workerManager_WorkerSlot_BTN_WorkRepeat_" .. slotIdx)
    tempSlot.btn_UnRepeat = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Button_UnRepeatWork", tempSlot.bg, "workerManager_WorkerSlot_BTN_WorkUnRepeat_" .. slotIdx)
    tempSlot.btn_resetCount = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Button_ResetCount", tempSlot.bg, "workerManager_WorkerSlot_BTN_UpgradeResetCount_" .. slotIdx)
    tempSlot.btn_ReloadIcon = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Static_ReloadIcon", tempSlot.bg, "workerManager_WorkerSlot_BTN_Reload_" .. slotIdx)
    tempSlot.Time = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "StaticText_Time", tempSlot.bg, "workerManager_WorkerSlot_Time_" .. slotIdx)
    tempSlot.APValue = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "StaticText_ActionPointValue", tempSlot.bg, "workerManager_WorkerSlot_ActionPoint_" .. slotIdx)
    tempSlot.upgradeComplete = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Button_ImmediatlyComplete", tempSlot.bg, "workerManager_WorkerSlot_CompleteBtn_" .. slotIdx)
    tempSlot.bg:SetPosX(5)
    tempSlot.bg:SetPosY(self.startPosY + (tempSlot.bg:GetSizeY() + 5) * slotIdx)
    tempSlot.workerCheck:SetPosX(5)
    tempSlot.workerCheck:SetPosY(5)
    tempSlot.picture:SetPosX(5)
    tempSlot.picture:SetPosY(5)
    tempSlot.picture:SetIgnore(false)
    tempSlot.workerName:SetPosX(84)
    tempSlot.workerName:SetPosY(5)
    tempSlot.workerNodeName:SetPosX(83)
    tempSlot.workerNodeName:SetPosY(25)
    tempSlot.workerHpBG:SetPosX(5)
    tempSlot.workerHpBG:SetPosY(56)
    tempSlot.workerRestorePT:SetPosX(5)
    tempSlot.workerRestorePT:SetPosY(56)
    tempSlot.workerCurrentPT:SetPosX(5)
    tempSlot.workerCurrentPT:SetPosY(56)
    tempSlot.APValue:SetPosX(12)
    tempSlot.APValue:SetPosY(48)
    tempSlot.upgradeComplete:SetPosX(228)
    tempSlot.upgradeComplete:SetPosY(20)
    tempSlot.progressBg:SetPosX(83)
    tempSlot.progressBg:SetPosY(46)
    tempSlot.progress:SetPosX(84)
    tempSlot.progress:SetPosY(47)
    tempSlot.workingName:SetPosX(84)
    tempSlot.workingName:SetPosY(46)
    tempSlot.btn_Restore:SetPosX(tempSlot.progressBg:GetPosX() + tempSlot.progressBg:GetSizeX() + 15)
    tempSlot.btn_Restore:SetPosY(5)
    tempSlot.Time:SetPosX(254)
    tempSlot.Time:SetPosY(33)
    tempSlot.Time:SetShow(false)
    tempSlot.btn_UnRepeat:SetPosX(tempSlot.btn_Restore:GetPosX())
    tempSlot.btn_UnRepeat:SetPosY(tempSlot.btn_Restore:GetPosY() + tempSlot.btn_Restore:GetSizeY() + 3)
    tempSlot.btn_Stop:SetPosX(tempSlot.btn_UnRepeat:GetPosX() - tempSlot.btn_UnRepeat:GetSizeX() - 11)
    tempSlot.btn_Stop:SetPosY(tempSlot.btn_UnRepeat:GetPosY() - 21)
    tempSlot.stc_stopIcon:SetVerticalMiddle()
    tempSlot.stc_stopIcon:SetHorizonCenter()
    tempSlot.stc_stopIcon:ComputePos()
    tempSlot.btn_Repeat:SetPosX(tempSlot.btn_Stop:GetPosX())
    tempSlot.btn_Repeat:SetPosY(tempSlot.btn_Stop:GetPosY())
    tempSlot.btn_ReloadIcon:SetPosX(tempSlot.btn_Stop:GetPosX() + 3)
    tempSlot.btn_ReloadIcon:SetPosY(tempSlot.btn_Stop:GetPosY() + 3)
    tempSlot.btn_Upgrade:SetPosX(tempSlot.btn_Restore:GetPosX() + tempSlot.btn_Restore:GetSizeX() + 3)
    tempSlot.btn_Upgrade:SetPosY(5)
    tempSlot.btn_resetCount:ComputePos()
    tempSlot.btn_ChangeSkill:SetPosX(tempSlot.btn_Upgrade:GetPosX())
    tempSlot.btn_ChangeSkill:SetPosY(tempSlot.btn_Restore:GetPosY() + tempSlot.btn_Restore:GetSizeY() + 3)
    tempSlot.bg:addInputEvent("Mouse_UpScroll", "workerManager_ScrollEvent( true )")
    tempSlot.bg:addInputEvent("Mouse_DownScroll", "workerManager_ScrollEvent( false )")
    tempSlot.workerName:addInputEvent("Mouse_UpScroll", "workerManager_ScrollEvent( true )")
    tempSlot.workerName:addInputEvent("Mouse_DownScroll", "workerManager_ScrollEvent( false )")
    tempSlot.workingName:addInputEvent("Mouse_UpScroll", "workerManager_ScrollEvent( true )")
    tempSlot.workingName:addInputEvent("Mouse_DownScroll", "workerManager_ScrollEvent( false )")
    tempSlot.progressBg:addInputEvent("Mouse_UpScroll", "workerManager_ScrollEvent( true )")
    tempSlot.progressBg:addInputEvent("Mouse_DownScroll", "workerManager_ScrollEvent( false )")
    tempSlot.progress:addInputEvent("Mouse_UpScroll", "workerManager_ScrollEvent( true )")
    tempSlot.progress:addInputEvent("Mouse_DownScroll", "workerManager_ScrollEvent( false )")
    tempSlot.picture:addInputEvent("Mouse_UpScroll", "workerManager_ScrollEvent( true )")
    tempSlot.picture:addInputEvent("Mouse_DownScroll", "workerManager_ScrollEvent( false )")
    self.slot[slotIdx] = tempSlot
  end
  self.workerListBg:addInputEvent("Mouse_UpScroll", "workerManager_ScrollEvent( true )")
  self.workerListBg:addInputEvent("Mouse_DownScroll", "workerManager_ScrollEvent( false )")
  UIScroll.InputEvent(workerManager._scroll, "workerManager_ScrollEvent")
  for resIdx = 0, self.restoreItemMaxCount - 1 do
    local tempItemSlot = {}
    tempItemSlot.slotBG = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Static_Restore_Item_Icone_BG", self.restoreItemBG, "workerManager_restoreSlotBG_" .. resIdx)
    tempItemSlot.slotIcon = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "Static_Restore_Item_Icone", tempItemSlot.slotBG, "workerManager_restoreSlot_" .. resIdx)
    tempItemSlot.itemCount = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "StaticText_Item_Count", tempItemSlot.slotIcon, "workerManager_restoreItemCount_" .. resIdx)
    tempItemSlot.restorePoint = UI.createAndCopyBasePropertyControl(Panel_WorkerManager, "StaticText_Item_Restore_Value", tempItemSlot.slotIcon, "workerManager_restorePoint_" .. resIdx)
    tempItemSlot.slotBG:SetPosX(5 + tempItemSlot.slotBG:GetSizeX() * resIdx)
    tempItemSlot.slotBG:SetPosY(23)
    tempItemSlot.slotIcon:SetPosX(5)
    tempItemSlot.slotIcon:SetPosY(5)
    tempItemSlot.itemCount:SetPosX(tempItemSlot.slotIcon:GetSizeX() - 9)
    tempItemSlot.itemCount:SetPosY(tempItemSlot.slotIcon:GetSizeY() - 10)
    tempItemSlot.restorePoint:SetPosX(3)
    tempItemSlot.restorePoint:SetPosY(2)
    tempItemSlot.slotIcon:addInputEvent("Mouse_UpScroll", "workerManager_SliderScroll( true )")
    tempItemSlot.slotIcon:addInputEvent("Mouse_DownScroll", "workerManager_SliderScroll( false )")
    self.restoreItemSlot[resIdx] = tempItemSlot
  end
  self.restoreItemBG:AddChild(self.btn_restoreItemClose)
  self.restoreItemBG:AddChild(self._slider)
  self.restoreItemBG:AddChild(self.guideRestoreAll)
  Panel_WorkerManager:RemoveControl(self.btn_restoreItemClose)
  Panel_WorkerManager:RemoveControl(self._slider)
  Panel_WorkerManager:RemoveControl(self.guideRestoreAll)
  self.btn_restoreItemClose:ComputePos()
  self._slider:ComputePos()
  self.guideRestoreAll:ComputePos()
  self.desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.desc:SetAutoResize(true)
  self.desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_DESCRIPTION"))
  self.desc:SetSize(self.desc:GetSizeX(), self.desc:GetTextSizeY() + 10)
  self.desc:setPadding(CppEnums.Padding.ePadding_Left, 10)
  self.desc:setPadding(CppEnums.Padding.ePadding_Top, 10)
  self.desc:setPadding(CppEnums.Padding.ePadding_Right, 10)
  self.desc:setPadding(CppEnums.Padding.ePadding_Bottom, 10)
  self.desc:ComputePos()
  self.btn_restoreItemClose:SetShow(true)
  self.desc:setPadding(UI_PD.ePadding_Left, 5)
  self.desc:setPadding(UI_PD.ePadding_Right, 5)
  if isContentOpen then
    self._restoreAll:SetSize(130, 40)
    self._reDoAll:SetSize(130, 40)
    self._resetUpgradeCount:SetSize(130, 40)
    self._btnUpgradeNow:SetSize(130, 40)
    self._btnFire:SetSize(130, 80)
    self._restoreAll:SetSpanSize(10, 10)
    self._reDoAll:SetSpanSize(143, 10)
    self._resetUpgradeCount:SetSpanSize(10, 53)
    self._btnUpgradeNow:SetSpanSize(143, 53)
    self._btnFire:SetSpanSize(10, 10)
    self.desc:SetSpanSize(0, 98)
  else
    self._restoreAll:SetSize(130, 40)
    self._reDoAll:SetSize(130, 40)
    self._btnUpgradeNow:SetSize(130, 40)
    self._btnFire:SetSize(130, 40)
    self._restoreAll:SetSpanSize(10, 10)
    self._reDoAll:SetSpanSize(143, 10)
    self._btnUpgradeNow:SetSpanSize(20, 8)
    self._btnFire:SetSpanSize(10, 10)
    self.desc:SetSpanSize(0, 58)
  end
  self._resetUpgradeCount:SetShow(isContentOpen)
  self._btnUpgradeNow:SetShow(isContentOpen)
end
local comboBox = {
  town = UI.getChildControl(Panel_WorkerManager, "Combobox_Town"),
  grade = UI.getChildControl(Panel_WorkerManager, "Combobox_Grade")
}
local townList = UI.getChildControl(comboBox.town, "Combobox_List")
local gradeList = UI.getChildControl(comboBox.grade, "Combobox_List")
comboBox.town:setListTextHorizonCenter()
comboBox.town:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_FILTER_TOWN"))
comboBox.town:addInputEvent("Mouse_LUp", "HandleClicked_WorkerManager_Town()")
comboBox.town:GetListControl():addInputEvent("Mouse_LUp", "WorkerManager_SetTown()")
Panel_WorkerManager:SetChildIndex(comboBox.town, 9999)
comboBox.grade:setListTextHorizonCenter()
comboBox.grade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_FILTER_GRADE"))
comboBox.grade:addInputEvent("Mouse_LUp", "HandleClicked_WorkerManager_Grade()")
comboBox.grade:GetListControl():addInputEvent("Mouse_LUp", "WorkerManager_SetGrade()")
Panel_WorkerManager:SetChildIndex(comboBox.grade, 9999)
local townSort = {}
local gradeSort = {}
local filteredArray = {}
local selectHomeWayPointIndex = -1
local selectWorkerGrade = -1
local checkUpgradeResetCount = false
local function workerManager_UpdateMain()
  local self = workerManager
  local plantArray = Array.new()
  workerArray = Array.new()
  if nil ~= workerManager.plantKey then
    plantArray:push_back(workerManager.plantKey)
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
  local totalWorkerCount = 0
  local totalWorkerCapacity = 0
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
    totalWorkerCapacity = totalWorkerCapacity + workerHouseCount
    totalWorkerCount = totalWorkerCount + plantWorkerCount
  end
  local title = ""
  if nil ~= workerManager.plantKey then
    title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERCOUNT", "Count", totalWorkerCount .. "/" .. totalWorkerCapacity)
  else
    title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_ALLWORKERCOUNT", "Count", totalWorkerCount)
  end
  self._listCount = totalWorkerCount
  self.penelTitle:SetText(title)
  townSort = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL")
  }
  gradeSort = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL")
  }
  local hasUpgradeWoker = false
  for worker_Index = 1, #workerArray do
    local workerWrapperLua = getWorkerWrapper(workerArray[worker_Index], false)
    if nil ~= workerWrapperLua then
      if CppEnums.NpcWorkingType.eNpcWorkingType_Upgrade == workerWrapperLua:getWorkingType() then
        hasUpgradeWoker = true
        self.upgradeWokerNoRaw = workerArray[worker_Index]
      end
      local worker_HomeWayPoint = workerWrapperLua:getHomeWaypoint()
      if nil == townSort[1] then
        table.insert(townSort, worker_HomeWayPoint)
      else
        local townCheck = true
        for n = 1, #townSort do
          if worker_HomeWayPoint == townSort[n] then
            townCheck = false
          end
        end
        if townCheck then
          table.insert(townSort, worker_HomeWayPoint)
        end
      end
      local worker_Grade = workerWrapperLua:getGrade()
      if nil == gradeSort[1] then
        table.insert(gradeSort, worker_Grade)
      else
        local townCheck = true
        for n = 1, #gradeSort do
          if worker_Grade == gradeSort[n] then
            townCheck = false
          end
        end
        if townCheck then
          table.insert(gradeSort, worker_Grade)
        end
      end
    end
  end
  local gradeSort_do = function(a, b)
    return a < b
  end
  table.sort(gradeSort, gradeSort_do)
  self._btnUpgradeNow:SetIgnore(true)
  self._btnUpgradeNow:SetMonoTone(true)
  local count = 0
  filteredArray = {}
  for worker_Index = 1, #workerArray do
    local workerWrapperLua = getWorkerWrapper(workerArray[worker_Index], false)
    if nil ~= workerWrapperLua then
      if selectHomeWayPointIndex > 0 then
        if workerWrapperLua:getHomeWaypoint() == townSort[selectHomeWayPointIndex] then
          if selectWorkerGrade >= 0 then
            if workerWrapperLua:getGrade() == selectWorkerGrade then
              count = count + 1
              filteredArray[count] = workerArray[worker_Index]
            end
          else
            count = count + 1
            filteredArray[count] = workerArray[worker_Index]
          end
        end
      elseif selectWorkerGrade >= 0 then
        if workerWrapperLua:getGrade() == selectWorkerGrade then
          count = count + 1
          filteredArray[count] = workerArray[worker_Index]
        end
      else
        count = count + 1
        filteredArray[count] = workerArray[worker_Index]
      end
    end
  end
  local function checkUpgradableWorker()
    for index = 1, #filteredArray do
      local workerWrapperLua = getWorkerWrapper(filteredArray[index], false)
      local workerNoRaw = filteredArray[index]
      local worker_Lev = workerWrapperLua:getLevel()
      local maxUpgradeCount = math.floor(worker_Lev / 10)
      local currentUpgradableCount = workerWrapperLua:getUpgradePoint()
      if not workerWrapperLua:isWorking() and not hasUpgradeWoker and maxUpgradeCount > currentUpgradableCount then
        return true
      end
    end
    return false
  end
  local limitCount = 0
  local resetUpgradableCount = 0
  for worker_Index = self._startIndex, #filteredArray do
    if limitCount >= self.slotMaxCount then
      break
    end
    do
      local slot = self.slot[limitCount]
      slot.btn_Restore:SetMonoTone(true)
      slot.btn_Stop:SetMonoTone(true)
      slot.btn_Stop:SetShow(false)
      slot.btn_Repeat:SetShow(false)
      slot.btn_Repeat:SetMonoTone(true)
      slot.btn_ReloadIcon:SetShow(false)
      slot.btn_UnRepeat:SetShow(false)
      slot.btn_UnRepeat:SetMonoTone(true)
      slot.btn_Upgrade:SetMonoTone(true)
      slot.btn_ChangeSkill:SetMonoTone(true)
      slot.btn_resetCount:SetShow(false)
      slot.btn_Repeat:addInputEvent("Mouse_LUp", "")
      slot.btn_UnRepeat:addInputEvent("Mouse_LUp", "")
      slot.btn_Restore:addInputEvent("Mouse_LUp", "")
      slot.btn_Stop:addInputEvent("Mouse_LUp", "")
      slot.btn_Upgrade:addInputEvent("Mouse_LUp", "")
      slot.btn_ChangeSkill:addInputEvent("Mouse_LUp", "")
      slot.btn_resetCount:addInputEvent("Mouse_LUp", "")
      slot.btn_Restore:addInputEvent("Mouse_On", "WorkerManager_ButtonSimpleToolTip( true, " .. limitCount .. ", 0 )")
      slot.btn_Restore:addInputEvent("Mouse_Out", "WorkerManager_ButtonSimpleToolTip( false, " .. limitCount .. ", 0 )")
      slot.btn_Upgrade:addInputEvent("Mouse_On", "WorkerManager_ButtonSimpleToolTip( true, " .. limitCount .. ", 1 )")
      slot.btn_Upgrade:addInputEvent("Mouse_Out", "WorkerManager_ButtonSimpleToolTip( false, " .. limitCount .. ", 1 )")
      slot.btn_Repeat:addInputEvent("Mouse_On", "WorkerManager_ButtonSimpleToolTip( true, " .. limitCount .. ", 2 )")
      slot.btn_Repeat:addInputEvent("Mouse_Out", "WorkerManager_ButtonSimpleToolTip( false, " .. limitCount .. ", 2 )")
      slot.btn_UnRepeat:addInputEvent("Mouse_On", "WorkerManager_ButtonSimpleToolTip( true, " .. limitCount .. ", 5 )")
      slot.btn_UnRepeat:addInputEvent("Mouse_Out", "WorkerManager_ButtonSimpleToolTip( false, " .. limitCount .. ", 5 )")
      slot.btn_Stop:addInputEvent("Mouse_On", "WorkerManager_ButtonSimpleToolTip( true, " .. limitCount .. ", 3 )")
      slot.btn_Stop:addInputEvent("Mouse_Out", "WorkerManager_ButtonSimpleToolTip( false, " .. limitCount .. ", 3 )")
      slot.btn_ChangeSkill:addInputEvent("Mouse_On", "WorkerManager_ButtonSimpleToolTip( true, " .. limitCount .. ", 4 )")
      slot.btn_ChangeSkill:addInputEvent("Mouse_Out", "WorkerManager_ButtonSimpleToolTip( false, " .. limitCount .. ", 4 )")
      local workerWrapperLua = getWorkerWrapper(filteredArray[worker_Index], false)
      local workerNoRaw = filteredArray[worker_Index]
      local function setWorker()
        slot.btn_Restore:SetShow(true)
        slot.btn_Upgrade:SetShow(true)
        slot.btn_Repeat:SetShow(true)
        slot.btn_ReloadIcon:SetShow(true)
        slot.upgradeComplete:SetShow(false)
        slot.btn_UnRepeat:SetShow(true)
        slot.btn_Stop:SetShow(true)
        slot.btn_ChangeSkill:SetShow(true)
        local workerUpgradeCount = workerWrapperLua:getUpgradePoint()
        local worker_Name = ""
        if workerUpgradeCount > 0 and workerWrapperLua:isUpgradable() then
          worker_Name = workerWrapperLua:getName()
          slot.btn_Upgrade:SetText(workerWrapperLua:getUpgradePoint())
          slot.btn_Upgrade:SetShow(true)
          slot.btn_Upgrade:SetMonoTone(false)
          slot.btn_Upgrade:addInputEvent("Mouse_LUp", "HandleClicked_WorkerManager_UpgradeWorker( " .. worker_Index .. " )")
        else
          slot.btn_Upgrade:SetText("0")
          slot.btn_Upgrade:SetMonoTone(true)
          slot.btn_Upgrade:addInputEvent("Mouse_LUp", "")
          worker_Name = workerWrapperLua:getName()
        end
        if workerWrapperLua:checkPossibleChangesSkillKey() then
          slot.btn_ChangeSkill:SetShow(true)
          slot.btn_ChangeSkill:SetMonoTone(false)
          slot.btn_ChangeSkill:addInputEvent("Mouse_LUp", "workerChangeSkill_Open( " .. worker_Index .. " )")
        else
          slot.btn_ChangeSkill:SetMonoTone(true)
          slot.btn_ChangeSkill:addInputEvent("Mouse_LUp", "")
        end
        local worker_Lev = workerWrapperLua:getLevel()
        local worker_HomeWayPoint = workerWrapperLua:getHomeWaypoint()
        local workerNo_64 = workerNoRaw
        slot.btn_Repeat:SetShow(false)
        slot.btn_Repeat:addInputEvent("Mouse_LUp", "")
        slot.btn_Repeat:SetMonoTone(true)
        slot.btn_ReloadIcon:SetShow(false)
        slot.btn_UnRepeat:SetShow(true)
        slot.btn_UnRepeat:addInputEvent("Mouse_LUp", "")
        slot.btn_UnRepeat:SetMonoTone(true)
        slot.btn_Stop:SetShow(true)
        if 30 == worker_Lev and 0 == workerUpgradeCount or nil ~= workerWrapperLua:getWorkerDefaultSkillStaticStatus() or 4 == workerWrapperLua:getGrade() then
          slot.btn_Upgrade:SetShow(false)
        else
          slot.btn_Upgrade:SetShow(true)
        end
        if workerWrapperLua:isWorking() then
          local workingLeftPercent = workerWrapperLua:currentProgressPercents()
          slot.progress:SetProgressRate(workingLeftPercent)
          slot.progress:SetCurrentProgressRate(workingLeftPercent)
          slot.progressBg:SetShow(true)
          slot.progress:SetShow(true)
          slot.btn_Restore:SetMonoTone(false)
          slot.btn_Restore:addInputEvent("Mouse_LUp", "HandleClicked_WorkerManager_RestoreWorker( " .. worker_Index .. ", " .. limitCount .. " )")
          slot.btn_Repeat:SetShow(false)
          slot.btn_Repeat:addInputEvent("Mouse_LUp", "")
          slot.btn_Repeat:SetMonoTone(true)
          slot.btn_ReloadIcon:SetShow(false)
          slot.btn_UnRepeat:SetShow(true)
          slot.btn_UnRepeat:addInputEvent("Mouse_LUp", "")
          slot.btn_UnRepeat:SetMonoTone(true)
          slot.btn_Stop:SetShow(true)
          slot.btn_Stop:SetMonoTone(false)
          slot.btn_Stop:addInputEvent("Mouse_LUp", "HandleClicked_WorkerManager_StopWorking( " .. worker_Index .. " )")
          slot.btn_Upgrade:SetMonoTone(true)
          slot.btn_Upgrade:addInputEvent("Mouse_LUp", "")
        else
          slot.progressBg:SetShow(true)
          slot.progress:SetShow(false)
          slot.btn_Restore:SetMonoTone(false)
          slot.btn_Restore:addInputEvent("Mouse_LUp", "HandleClicked_WorkerManager_RestoreWorker( " .. worker_Index .. ", " .. limitCount .. " )")
          slot.btn_UnRepeat:SetShow(true)
          slot.btn_UnRepeat:addInputEvent("Mouse_LUp", "")
          slot.btn_UnRepeat:SetMonoTone(true)
          slot.btn_Stop:SetShow(false)
          slot.btn_Stop:SetMonoTone(true)
          slot.btn_Stop:addInputEvent("Mouse_LUp", "")
          local currentActionPoint = workerWrapperLua:getActionPoint()
          local maxActionPoint = workerWrapperLua:getMaxActionPoint()
          if currentActionPoint == maxActionPoint then
            slot.btn_Restore:SetFontColor(4286743170)
            slot.btn_Restore:SetMonoTone(true)
            slot.btn_Restore:addInputEvent("Mouse_LUp", "")
            if restoreWorkerNo == workerNo_64 then
              HandleClicked_WorkerManager_RestoreItemClose()
            end
          end
          if workerWrapperLua:isWorkerRepeatable() and currentActionPoint > 0 then
            slot.btn_Repeat:SetShow(true)
            slot.btn_Repeat:SetMonoTone(false)
            slot.btn_ReloadIcon:SetShow(true)
            slot.btn_UnRepeat:SetShow(true)
            slot.btn_UnRepeat:SetMonoTone(false)
            slot.btn_Stop:SetShow(false)
            slot.btn_Stop:SetMonoTone(false)
            slot.btn_Stop:addInputEvent("Mouse_LUp", "HandleClicked_WorkerManager_StopWorking( " .. worker_Index .. " )")
            slot.btn_Repeat:addInputEvent("Mouse_LUp", "HandleClicked_ReDoWork( " .. worker_Index .. " )")
            slot.btn_UnRepeat:addInputEvent("Mouse_LUp", "HandleClicked_UnReDoWork( " .. worker_Index .. " )")
          else
            slot.btn_Repeat:SetShow(false)
            slot.btn_ReloadIcon:SetShow(false)
          end
        end
        local actionPointPer = workerWrapperLua:getActionPointPercents()
        slot.workerRestorePT:SetProgressRate(actionPointPer)
        slot.workerCurrentPT:SetProgressRate(actionPointPer)
        slot.APValue:SetText(tostring(workerWrapperLua:getActionPointXXX()) .. "/" .. tostring(workerWrapperLua:getMaxActionPoint()))
        if nil == workerCheckList[Int64toInt32(workerNo_64)] then
          workerCheckList[Int64toInt32(workerNo_64)] = false
        end
        local isCheck = workerCheckList[Int64toInt32(workerNo_64)]
        slot.workerCheck:SetCheck(isCheck)
        slot.workerName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. worker_Lev .. " " .. workerWrapperLua:getGradeToColorString() .. worker_Name .. "<PAOldColor>")
        slot.workerNodeName:SetText(workerWrapperLua:getWorkingNodeDesc())
        slot.workingName:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
        slot.workingName:SetText(workerWrapperLua:getWorkString())
        if slot.workingName:IsLimitText() then
          tempTable[worker_Index] = {}
          tempTable[worker_Index].control = slot.workingName
          tempTable[worker_Index].name = ""
          tempTable[worker_Index].desc = slot.workingName:GetText(workerWrapperLua:getWorkString())
          slot.workingName:SetIgnore(false)
          slot.workingName:addInputEvent("Mouse_On", "PaGlobalFunc_WorkerManager_TooltipLimitedText(" .. worker_Index .. ",true)")
          slot.workingName:addInputEvent("Mouse_Out", "PaGlobalFunc_WorkerManager_TooltipLimitedText(" .. worker_Index .. ",false)")
        else
          slot.workingName:SetIgnore(true)
        end
        if "" == workerWrapperLua:getWorkingNodeDesc() then
          slot.workingName:SetPosY(25)
        else
          slot.workingName:SetPosY(46)
        end
        if CppEnums.NpcWorkingType.eNpcWorkingType_Upgrade == workerWrapperLua:getWorkingType() then
          slot.workingName:SetPosY(46)
          slot.btn_Stop:SetShow(false)
          slot.upgradeComplete:SetShow(true)
          slot.upgradeComplete:addInputEvent("Mouse_LUp", "HandleClicked_workerManager_WorkerUpgradeNow()")
        end
        slot.picture:ChangeTextureInfoName(workerWrapperLua:getWorkerIcon())
        slot.bg:SetShow(true)
        slot.workerName:SetShow(true)
        slot.workingName:SetShow(true)
        if true == hasUpgradeWoker then
          slot.btn_Upgrade:SetMonoTone(true)
          slot.btn_Upgrade:addInputEvent("Mouse_LUp", "")
        end
        slot.picture:addInputEvent("Mouse_On", "workerManager_ToolTip( true,\t" .. worker_Index .. ", " .. limitCount .. " ) ")
        slot.picture:addInputEvent("Mouse_Out", "workerManager_ToolTip( false,\t" .. worker_Index .. ", " .. limitCount .. " )")
        slot.workerCheck:addInputEvent("Mouse_LUp", "HandleClicked_workerManager_CheckWorker( " .. Int64toInt32(workerNo_64) .. " )")
        if true == workerWrapperLua:getIsAuctionInsert() then
          slot.btn_Restore:SetMonoTone(true)
          slot.btn_Restore:addInputEvent("Mouse_LUp", "")
          slot.btn_Restore:SetFontColor(4286743170)
          slot.btn_Repeat:SetShow(false)
          slot.btn_ReloadIcon:SetShow(false)
          slot.btn_Repeat:addInputEvent("Mouse_LUp", "")
          slot.btn_Repeat:SetMonoTone(true)
          slot.btn_UnRepeat:SetShow(true)
          slot.btn_UnRepeat:addInputEvent("Mouse_LUp", "")
          slot.btn_UnRepeat:SetMonoTone(true)
          slot.btn_Stop:SetShow(false)
          slot.btn_Stop:SetMonoTone(true)
          slot.btn_Stop:addInputEvent("Mouse_LUp", "")
          slot.btn_Upgrade:SetMonoTone(true)
          slot.btn_Upgrade:addInputEvent("Mouse_LUp", "")
        end
        limitCount = limitCount + 1
        if checkUpgradeResetCount then
          slot.btn_Restore:SetShow(false)
          slot.btn_Upgrade:SetShow(false)
          slot.btn_Repeat:SetShow(false)
          slot.btn_UnRepeat:SetShow(false)
          slot.btn_Stop:SetShow(false)
          slot.btn_ChangeSkill:SetShow(false)
          local enableReset = false
          local maxUpgradeCount = math.floor(worker_Lev / 10)
          local currentUpgradableCount = workerWrapperLua:getUpgradePoint()
          if not workerWrapperLua:isWorking() and not hasUpgradeWoker then
            if maxUpgradeCount > currentUpgradableCount then
              slot.btn_resetCount:SetShow(true)
              slot.btn_resetCount:SetEnable(true)
              resetUpgradableCount = resetUpgradableCount + 1
            end
            slot.btn_resetCount:addInputEvent("Mouse_LUp", "HandleClicked_ResetUpgradeCount(" .. worker_Index .. ")")
          end
        end
      end
      if nil ~= workerWrapperLua then
        if selectHomeWayPointIndex > 0 then
          if workerWrapperLua:getHomeWaypoint() == townSort[selectHomeWayPointIndex] then
            if selectWorkerGrade >= 0 then
              if workerWrapperLua:getGrade() == selectWorkerGrade then
                setWorker()
              end
            else
              setWorker()
            end
          end
        elseif selectWorkerGrade >= 0 then
          if workerWrapperLua:getGrade() == selectWorkerGrade then
            setWorker()
          end
        else
          setWorker()
        end
      end
    end
  end
  if checkUpgradeResetCount and not checkUpgradableWorker() then
    HandleClicked_UpgradeCountReset_Show()
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_NOWORKER"))
  end
  self._listCount = count
  UIScroll.SetButtonSize(self._scroll, self.slotMaxCount, self._listCount)
end
local function workerManager_Update()
  local self = workerManager
  for slotIdx = 0, self.slotFixMaxCount - 1 do
    local slot = self.slot[slotIdx]
    slot.bg:SetShow(false)
    slot.workerName:SetShow(false)
    slot.workingName:SetShow(false)
    slot.progressBg:SetShow(true)
    slot.progress:SetShow(false)
    slot.upgradeComplete:SetShow(false)
  end
  workerManager_UpdateMain()
  self.workerListBg:SetSize(self.workerListBg:GetSizeX(), (self.slot[0].bg:GetSizeY() + 6) * self.slotMaxCount)
  self._scroll:SetSize(self._scroll:GetSizeX(), (self.slot[0].bg:GetSizeY() + 4) * self.slotMaxCount)
  Panel_WorkerManager:SetSize(Panel_WorkerManager:GetSizeX(), (self.slot[0].bg:GetSizeY() + 6) * self.slotMaxCount + 100 + self._btnFire:GetSizeY() + self.desc:GetSizeY() + 5)
  self._btnFire:ComputePos()
  self._restoreAll:ComputePos()
  self._reDoAll:ComputePos()
  self._btnUpgradeNow:ComputePos()
  self._resetUpgradeCount:ComputePos()
  self.desc:ComputePos()
  UIScroll.SetButtonSize(self._scroll, self.slotMaxCount, self._listCount)
end
function HandleClicked_WorkerManager_Town()
  audioPostEvent_SystemUi(0, 0)
  comboBox.town:DeleteAllItem()
  comboBox.town:AddItem(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL"), 1)
  for ii = 1, #townSort do
    comboBox.town:AddItem(ToClient_GetNodeNameByWaypointKey(townSort[ii]), ii + 1)
  end
  comboBox.town:ToggleListbox()
end
function WorkerManager_SetTown()
  audioPostEvent_SystemUi(0, 0)
  local selectTownIndex = comboBox.town:GetSelectIndex()
  selectHomeWayPointIndex = selectTownIndex
  comboBox.town:SetSelectItemIndex(selectTownIndex)
  if selectTownIndex > 0 then
    comboBox.town:SetText(ToClient_GetNodeNameByWaypointKey(townSort[selectTownIndex]))
  else
    comboBox.town:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL"))
  end
  comboBox.town:ToggleListbox()
  workerManager._scroll:SetControlPos(0)
  workerManager._startIndex = 1
  workerManager_Update()
end
function HandleClicked_WorkerManager_Grade()
  audioPostEvent_SystemUi(0, 0)
  comboBox.grade:DeleteAllItem()
  comboBox.grade:AddItem(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL"), 1)
  for ii = 1, #gradeSort do
    comboBox.grade:AddItem(workerGrade[gradeSort[ii]], ii + 1)
  end
  comboBox.grade:ToggleListbox()
end
function WorkerManager_SetGrade()
  audioPostEvent_SystemUi(0, 0)
  local selectGradeIndex = comboBox.grade:GetSelectIndex()
  comboBox.grade:SetSelectItemIndex(selectGradeIndex)
  if selectGradeIndex > 0 then
    comboBox.grade:SetText(workerGrade[gradeSort[selectGradeIndex]])
    selectWorkerGrade = gradeSort[selectGradeIndex]
  else
    comboBox.grade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL"))
    selectWorkerGrade = -1
  end
  comboBox.grade:ToggleListbox()
  workerManager._scroll:SetControlPos(0)
  workerManager._startIndex = 1
  workerManager_Update()
end
local function restoreItem_update()
  local self = workerManager
  for itemIdx = 0, self.restoreItemMaxCount - 1 do
    local slot = self.restoreItemSlot[itemIdx]
    slot.slotBG:SetShow(false)
    slot.slotIcon:addInputEvent("Mouse_RUp", "")
  end
  self.restoreItemHasCount = ToClient_getNpcRecoveryItemList()
  if 0 >= self.restoreItemHasCount then
    self.restoreItemBG:SetShow(false)
  end
  local uiIdx = 0
  for itemIdx = self.sliderStartIdx, self.restoreItemHasCount - 1 do
    if uiIdx >= self.restoreItemMaxCount then
      break
    end
    local slot = self.restoreItemSlot[uiIdx]
    slot.slotBG:SetShow(true)
    local recoveryItem = ToClient_getNpcRecoveryItemByIndex(itemIdx)
    local itemStatic = recoveryItem:getItemStaticStatus()
    slot.slotIcon:ChangeTextureInfoName("icon/" .. getItemIconPath(itemStatic))
    slot.itemCount:SetText(tostring(recoveryItem._itemCount_s64))
    slot.restorePoint:SetText("+" .. tostring(recoveryItem._contentsEventParam1))
    slot.slotIcon:addInputEvent("Mouse_RUp", "HandleClicked_WorkerManager_RestoreItem( " .. itemIdx .. " )")
    slot.slotIcon:addInputEvent("Mouse_On", "HandleOnOut_WorkerManager_RestoreItem( true,\t" .. itemIdx .. " )")
    slot.slotIcon:addInputEvent("Mouse_Out", "HandleOnOut_WorkerManager_RestoreItem( false,\t" .. itemIdx .. " )")
    uiIdx = uiIdx + 1
  end
  if self.restoreItemMaxCount < self.restoreItemHasCount then
    self._slider:SetShow(true)
    local sliderSize = self._slider:GetSizeX()
    local targetPercent = self.restoreItemMaxCount / self.restoreItemHasCount * 100
    local sliderBtnSize = sliderSize * (targetPercent / 100)
    self._sliderBtn:SetSize(sliderBtnSize, self._sliderBtn:GetSizeY())
    self._slider:SetInterval(self.restoreItemHasCount - self.restoreItemMaxCount)
    self._sliderBtn:addInputEvent("Mouse_LPress", "HandleLPress_WorkerManager_RestoreItemSlider()")
  else
    self._slider:SetShow(false)
  end
end
function HandleClicked_WorkerManager_StopWorking(workerIdx)
  local workerWrapperLua = getWorkerWrapper(filteredArray[workerIdx], false)
  local workerNoRaw = filteredArray[workerIdx]
  if nil ~= workerWrapperLua then
    do
      local workerNo = workerNoRaw
      local leftWorkCount = workerWrapperLua:getWorkingCount()
      local workingState = workerWrapperLua:getWorkingStateXXX()
      if CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Working == workingState then
        ToClient_requestChangeWorkingState(WorkerNo(workerNo), CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Return)
        FGlobal_HarvestList_Update()
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
        local cancelWorkContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LARGECRAFT_WORKMANAGER_CANCELWORK_CONTENT", "workName", workName)
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_WORKINGPROGRESS_CANCELWORK_TITLE"),
          content = cancelWorkContent,
          functionYes = cancelDoWork,
          functionCancel = MessageBox_Empty_function,
          priority = UI_PP.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData, "top")
      end
    end
  end
end
function workerManager_SliderScroll(isUp)
  local self = workerManager
  if true == isUp then
    if self.sliderStartIdx <= 0 then
      self.sliderStartIdx = 0
      return
    end
    self.sliderStartIdx = self.sliderStartIdx - 1
  else
    if self.restoreItemHasCount <= self.sliderStartIdx + self.restoreItemMaxCount then
      return
    end
    self.sliderStartIdx = self.sliderStartIdx + 1
  end
  local currentPos = self.sliderStartIdx / (self.restoreItemHasCount - self.restoreItemMaxCount) * 100
  if currentPos > 100 then
    currentPos = 100
  elseif currentPos < 0 then
    currentPos = 0
  end
  self._slider:SetControlPos(currentPos)
  restoreItem_update()
end
function HandleLPress_WorkerManager_RestoreItemSlider()
  local self = workerManager
  local pos = self._slider:GetControlPos()
  local posIdx = math.floor((self.restoreItemHasCount - self.restoreItemMaxCount) * pos)
  if posIdx > self.restoreItemHasCount - self.restoreItemMaxCount then
    return
  end
  self.sliderStartIdx = posIdx
  local currentPos = self.sliderStartIdx / (self.restoreItemHasCount - self.restoreItemMaxCount) * 100
  if currentPos > 100 then
    currentPos = 100
  elseif currentPos < 0 then
    currentPos = 0
  end
  self._slider:SetControlPos(currentPos)
  restoreItem_update()
end
function HandleClicked_WorkerManager_RestoreWorker(workerIdx, uiIdx)
  local self = workerManager
  self.selectedUiIndex = uiIdx
  local slot = self.slot[self.selectedUiIndex]
  self.selectedRestoreWorkerIdx = workerIdx
  local restoreItemCount = ToClient_getNpcRecoveryItemList()
  local workerWrapperLua = getWorkerWrapper(filteredArray[workerIdx], false)
  local actionPointPer = workerWrapperLua:getActionPointPercents()
  if restoreItemCount <= 0 then
    Proc_ShowMessage_Ack_With_ChatType(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_NOITEM"), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
    return
  elseif 100 == actionPointPer then
    Proc_ShowMessage_Ack_With_ChatType(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE_MAX"), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
    return
  end
  local bgSizeX = self.restoreItemBG:GetSizeX()
  local textSizeX = self.guideRestoreAll:GetTextSizeX() + 30
  if bgSizeX < textSizeX then
    self.restoreItemBG:SetSize(self.restoreItemBG:GetSizeX() + (textSizeX - bgSizeX), self.restoreItemBG:GetSizeY())
    self.btn_restoreItemClose:SetSpanSize(5, 5)
  end
  self.restoreItemBG:SetShow(true)
  self.restoreItemBG:SetPosX(slot.btn_Restore:GetPosX() - self.restoreItemBG:GetSizeX() * 0.97)
  self.restoreItemBG:SetPosY(slot.bg:GetPosY() + slot.bg:GetSizeY() * 1.75 + 27)
  restoreItem_update()
end
function HandleClicked_WorkerManager_RestoreItem(itemIdx)
  local self = workerManager
  local workerIndex = self.selectedRestoreWorkerIdx
  local workerWrapperLua = getWorkerWrapper(filteredArray[workerIndex], false)
  local workerNoRaw = filteredArray[workerIndex]
  if nil ~= workerWrapperLua then
    local workerNo = workerNoRaw
    local recoveryItem = ToClient_getNpcRecoveryItemByIndex(itemIdx)
    local recoveryItemCount = Int64toInt32(recoveryItem._itemCount_s64)
    local slotNo = recoveryItem._slotNo
    local restorePoint = recoveryItem._contentsEventParam1
    local maxPoint = workerWrapperLua:getMaxActionPoint()
    local currentPoint = workerWrapperLua:getActionPoint()
    local actionPointPer = workerWrapperLua:getActionPointPercents()
    if actionPointPer >= 100 then
      Proc_ShowMessage_Ack_With_ChatType(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE_MAX"), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
      return
    end
    if isKeyPressed(CppEnums.VirtualKeyCode.KeyCode_SHIFT) then
      local restoreItemCount = ToClient_getNpcRecoveryItemList()
      local restoreActionPoint = maxPoint - currentPoint
      local itemNeedCount = math.floor(restoreActionPoint / restorePoint)
      local currentItemCount = recoveryItemCount
      if itemNeedCount > currentItemCount then
        itemNeedCount = currentItemCount
      end
      if itemNeedCount >= 1 then
        requestRecoveryWorker(WorkerNo(workerNo), slotNo, itemNeedCount)
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoNpcWorkerActionPointIsOver"))
      end
      return
    end
    restoreWorkerNo = workerNo
    requestRecoveryWorker(WorkerNo(workerNo), slotNo, 1)
  end
end
function HandleOnOut_WorkerManager_RestoreItem(isSet, itemIdx)
  local self = workerManager
  local workerIndex = self.selectedRestoreWorkerIdx
  local workerWrapperLua = getWorkerWrapper(filteredArray[workerIndex], false)
  if nil ~= workerWrapperLua then
    local maxPoint = workerWrapperLua:getMaxActionPoint()
    local currentPoint = workerWrapperLua:getActionPoint()
    local actionPointPer = workerWrapperLua:getActionPointPercents()
    local recoveryItem = ToClient_getNpcRecoveryItemByIndex(itemIdx)
    local slotNo = recoveryItem._slotNo
    local restorePoint = recoveryItem._contentsEventParam1
    local workerSlot = self.slot[self.selectedUiIndex]
    local actionPointPrePer = (currentPoint + restorePoint) / maxPoint * 100
    if true == isSet then
      workerSlot.workerRestorePT:SetProgressRate(actionPointPrePer)
    else
      workerSlot.workerRestorePT:SetProgressRate(actionPointPer)
    end
  end
end
function HandleClicked_WorkerManager_RestoreItemClose()
  local self = workerManager
  self.restoreItemBG:SetShow(false)
  restoreWorkerNo = nil
end
function HandleClicked_WorkerManager_UpgradeWorker(workerIdx)
  local workerWrapperLua = getWorkerWrapper(filteredArray[workerIdx], false)
  local function do_Upgrade_Worker()
    workerWrapperLua:requestUpgrade()
    workerManager_UpdateMain()
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
    priority = UI_PP.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "top")
end
function HandleClicked_workerManager_WorkerUpgradeNow()
  local self = workerManager
  local workerNoRaw = self.upgradeWokerNoRaw
  local remainTimeInt = ToClient_getWorkingTime(workerNoRaw)
  local needPearl = ToClient_GetUsingPearlByRemainingPearl(CppEnums.InstantCashType.eInstant_CompleteNpcWorkerUpgrade, remainTimeInt)
  local function doUpgradeNow()
    ToClient_requestQuickComplete(WorkerNo(workerNoRaw), needPearl)
    self.upgradeWokerNoRaw = -1
  end
  local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_IMMEDIATELYCOMPLETE_MSGBOX_TITLE")
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_UPGRADENOW_CONFIRM", "pearl", tostring(needPearl))
  local messageboxData = {
    title = messageboxTitle,
    content = messageBoxMemo,
    functionYes = doUpgradeNow,
    functionCancel = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "middle")
end
function HandleClicked_ResetUpgradeCount(workerIndex)
  local self = workerManager
  local workerWrapperLua = getWorkerWrapper(filteredArray[workerIndex], false)
  local workerNoRaw = filteredArray[workerIndex]
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
function HandleClicked_UpgradeCountReset_Show()
  if ToClient_doHaveClearWorkerUpgradeItem() then
    checkUpgradeResetCount = not checkUpgradeResetCount
    workerManager_UpdateMain()
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_NOITEMALERT"))
  end
end
function FromClient_ClearWorkerUpgradePoint()
  checkUpgradeResetCount = false
  workerManager_UpdateMain()
end
function WorkerManager_WorkerCheck_Init()
  local self = workerManager
  for index = 1, #filteredArray do
    local workerNoRaw = filteredArray[index]
    workerCheckList[Int64toInt32(workerNoRaw)] = false
  end
end
function HandleClicked_workerManager_CheckWorker(workerNo_64)
  if nil == workerCheckList[workerNo_64] or false == workerCheckList[workerNo_64] then
    workerCheckList[workerNo_64] = true
  else
    workerCheckList[workerNo_64] = false
  end
  workerManager_UpdateMain()
end
function HandleClicked_workerManager_WaitWorkerFire()
  local self = workerManager
  local function do_CheckedWorker_Fire()
    for idx = 1, self._listCount do
      local workerNoRaw = filteredArray[idx]
      if workerCheckList[Int64toInt32(workerNoRaw)] then
        ToClient_requestDeleteMyWorker(WorkerNo(workerNoRaw))
      end
    end
  end
  local checkCount = 0
  for idx = 1, self._listCount do
    local workerNoRaw = filteredArray[idx]
    if workerCheckList[Int64toInt32(workerNoRaw)] then
      for index = 1, #filteredArray do
        if workerNoRaw == filteredArray[index] then
          checkCount = checkCount + 1
        end
      end
    end
  end
  if 0 == checkCount then
    Proc_ShowMessage_Ack_With_ChatType(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_FIREWORKERSELECT"), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
    return
  end
  if Panel_WorkerRestoreAll:GetShow() then
    workerRestoreAll_Close()
  end
  local selectFilterString = ""
  local selectTownIndex = comboBox.town:GetSelectIndex()
  local selectGradeIndex = comboBox.grade:GetSelectIndex()
  if selectTownIndex > 0 then
    selectFilterString = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_DESTINATIONTOWN") .. ToClient_GetNodeNameByWaypointKey(townSort[selectTownIndex])
  else
    selectFilterString = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_DESTINATIONTOWN_ALL")
  end
  if selectGradeIndex > 0 then
    selectFilterString = selectFilterString .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE") .. workerGrade[gradeSort[selectGradeIndex]]
  else
    selectFilterString = selectFilterString .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_ALL")
  end
  selectFilterString = "( " .. selectFilterString .. " )"
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
  local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_FIREWORKERDESC", "count", checkCount) .. "\n" .. selectFilterString
  local messageboxData = {
    title = messageTitle,
    content = messageContent,
    functionYes = do_CheckedWorker_Fire,
    functionCancel = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "middle")
end
function HandleClicked_workerManager_RestoreAll()
  local self = workerManager
  local restoreItemCount = ToClient_getNpcRecoveryItemList()
  if restoreItemCount <= 0 then
    Proc_ShowMessage_Ack_With_ChatType(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_NOITEM"), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
    return
  end
  FGlobal_WorkerRestoreAll_Open(self._listCount, filteredArray)
end
function HandleClicked_workerManager_ReDoAll()
  local self = workerManager
  for worker_Index = 1, #filteredArray do
    HandleClicked_ReDoWork(worker_Index)
  end
end
local elapsedTime = 0
function workerManager_FrameUpdate(deltaTime)
  elapsedTime = elapsedTime + deltaTime
  if elapsedTime > 1 then
    local self = workerManager
    for slotIdx = 0, self.slotFixMaxCount - 1 do
      local slot = self.slot[slotIdx]
      slot.bg:SetShow(false)
      slot.workerName:SetShow(false)
      slot.workingName:SetShow(false)
      slot.progressBg:SetShow(true)
      slot.progress:SetShow(false)
    end
    workerManager_UpdateMain()
    elapsedTime = 0
  end
end
function workerManager_ScrollEvent(isUp)
  local self = workerManager
  self._startIndex = UIScroll.ScrollEvent(self._scroll, isUp, self.slotMaxCount, self._listCount, self._startIndex - 1, 1) + 1
  if self.restoreItemBG:GetShow() then
    HandleClicked_WorkerManager_RestoreItemClose()
  end
  workerManager_Update()
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
function FGlobal_WorkerManger_ShowToggle()
  if Panel_WorkerManager:GetShow() then
    workerManager_Close()
    return
  end
  if Panel_Window_Inventory:GetShow() then
    InventoryWindow_Close()
  end
  workerManager_Open()
end
function workerManager_Open()
  if workerManager_CheckWorkingOtherChannel() then
    local workingServerNo = getSelfPlayer():get():getWorkerWorkingServerNo()
    local temporaryWrapper = getTemporaryInformationWrapper()
    local worldNo = temporaryWrapper:getSelectedWorldServerNo()
    local channelName = getChannelName(worldNo, workingServerNo)
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERWORKINGOTHERCHANNEL", "channelName", channelName), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
    return
  end
  if false == ToClient_IsGrowStepOpen(__eGrowStep_worker) then
    return
  end
  local self = workerManager
  if Panel_WorkerManager:GetShow() then
    Panel_WorkerManager:SetShow(false, true)
  end
  workerManager.slotMaxCount = 6
  workerManager.sliderStartIdx = 0
  workerManager.plantKey = nil
  checkUpgradeResetCount = false
  audioPostEvent_SystemUi(1, 28)
  Panel_WorkerManager:SetShow(true, true)
  workerManager_Update()
  workerManager_ResetPos()
  if self.restoreItemBG:GetShow() then
    HandleClicked_WorkerManager_RestoreItemClose()
  end
  if ToClient_WorldMapIsShow() and Panel_WorkerManager:IsUISubApp() == false then
    WorldMapPopupManager:increaseLayer(true)
    WorldMapPopupManager:push(Panel_WorkerManager, true, nil, workerRestoreAll_Close)
  end
end
function FGlobal_workerManager_OpenWorldMap()
  if workerManager_CheckWorkingOtherChannel() then
    local workingServerNo = getSelfPlayer():get():getWorkerWorkingServerNo()
    local temporaryWrapper = getTemporaryInformationWrapper()
    local worldNo = temporaryWrapper:getSelectedWorldServerNo()
    local channelName = getChannelName(worldNo, workingServerNo)
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERWORKINGOTHERCHANNEL", "channelName", channelName), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
    return
  end
  local self = workerManager
  if Panel_WorkerManager:GetShow() and Panel_WorkerManager:IsUISubApp() == false then
    Panel_WorkerManager:SetShow(false, true)
  end
  workerManager.slotMaxCount = 6
  workerManager.sliderStartIdx = 0
  workerManager.plantKey = nil
  audioPostEvent_SystemUi(1, 28)
  Panel_WorkerManager:SetShow(true, true)
  workerManager_ResetPos()
  workerManager_Update()
  if self.restoreItemBG:GetShow() then
    HandleClicked_WorkerManager_RestoreItemClose()
  end
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:increaseLayer(true)
    WorldMapPopupManager:push(Panel_WorkerManager, true, nil, workerRestoreAll_Close)
  end
end
function FGlobal_workerManager_UpdateNode(plantKey)
  if workerManager_CheckWorkingOtherChannel() then
    return
  end
  local self = workerManager
  workerManager.plantKey = plantKey
  workerManager.slotMaxCount = 6
  workerManager.sliderStartIdx = 0
  workerManager._startIndex = 1
  workerManager._scroll:SetControlPos(0)
  workerManager._slider:SetControlPos(0)
  audioPostEvent_SystemUi(1, 28)
  Panel_WorkerManager:SetShow(true, true)
  workerManager_ResetPos()
  workerManager_Update()
  if self.restoreItemBG:GetShow() then
    HandleClicked_WorkerManager_RestoreItemClose()
  end
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:increaseLayer(true)
    WorldMapPopupManager:push(Panel_WorkerManager, true, nil, workerRestoreAll_Close)
  end
end
function FGlobal_workerManager_ResetPlantKey()
  workerManager.plantKey = nil
  workerManager._startIndex = 1
  workerManager.sliderStartIdx = 0
  workerManager._scroll:SetControlPos(0)
  workerManager._slider:SetControlPos(0)
  workerManager_Update()
end
function FGlobal_WorkerManager_GetWorkerNoRaw(worker_Index)
  return filteredArray[worker_Index]
end
function HandleClicked_WorkerManager_Close()
  audioPostEvent_SystemUi(1, 1)
  Panel_WorkerManager:CloseUISubApp()
  workerManager.checkPopUp:SetCheck(false)
  workerManager_Close()
end
function workerManager_Close()
  if Panel_WorkerManager:IsUISubApp() then
    return
  end
  Panel_WorkerManager:SetShow(false)
  Panel_WorkerRestoreAll:SetShow(false)
  if Panel_WorkerRestoreAll:IsUISubApp() then
    Panel_WorkerRestoreAll:CloseUISubApp()
  end
  FGlobal_HideWorkerTooltip()
  TooltipSimple_Hide()
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:pop()
  end
end
function workerManager_PopUp()
  if workerManager.checkPopUp:IsCheck() then
    Panel_WorkerManager:OpenUISubApp()
  else
    Panel_WorkerManager:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function workerManager_Toggle()
  if Panel_WorkerManager:GetShow() then
    workerManager_Close()
  else
    workerManager_Open()
  end
end
function workerManager_ResetPos(isWorldMap)
  local posX = 0
  local posY = 0
  if nil ~= isWorldMap then
    posX = getScreenSizeX() - Panel_WorkerManager:GetSizeX() - 10
    posY = 50
  else
    posX = getScreenSizeX() - Panel_WorkerManager:GetSizeX() - 10
    posY = getScreenSizeY() / 2 - Panel_WorkerManager:GetSizeY() / 2
  end
  Panel_WorkerManager:SetPosX(posX)
  Panel_WorkerManager:SetPosY(math.max(0, posY))
end
function workerManager_ResetPos_WorldMapClose()
  if not Panel_WorldMap:GetShow() then
    workerManager.slotMaxCount = 6
    workerManager_Update()
    Panel_WorkerManager:SetPosX(getScreenSizeX() - Panel_WorkerManager:GetSizeX() - 10)
    Panel_WorkerManager:SetPosY(100)
  end
end
registerEvent("FromClient_RenderModeChangeState", "workerManager_ResetPos_WorldMapClose")
function FGlobal_RedoWork(_workType, _houseInfoSS, _selectedWorker, _plantKey, _workKey, _selectedSubwork, _workingCount, _itemNoRaw, _houseHoldNo, _homeWaypoint)
  local plantKey = ToClient_convertWaypointKeyToPlantKey(_homeWaypoint)
  local waitWorkerCount = ToClient_getPlantWaitWorkerListCount(plantKey, 0)
  local maxWorkerCount = ToClient_getTownWorkerMaxCapacity(plantKey)
  workedWorker[Int64toInt32(_selectedWorker:get_s64())] = {
    _workType = _workType,
    _houseInfoSS = _houseInfoSS,
    _selectedWorker = _selectedWorker,
    _plantKey = _plantKey,
    _workKey = _workKey,
    _selectedSubwork = _selectedSubwork,
    _workingCount = _workingCount,
    _itemNoRaw = _itemNoRaw,
    _houseHoldNo = _houseHoldNo,
    _redoWork = true
  }
end
function HandleClicked_ReDoWork(workerIndex)
  local workerWrapperLua = getWorkerWrapper(filteredArray[workerIndex], false)
  local workerNoRaw = filteredArray[workerIndex]
  local currentActionPoint = workerWrapperLua:getActionPoint()
  local workerWorkingPrimitiveWrapper = workerWrapperLua:getWorkerRepeatableWorkingWrapper()
  if nil == workerWorkingPrimitiveWrapper then
    return
  end
  if workerWrapperLua:isWorkerRepeatable() then
    if CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking == workerWorkingPrimitiveWrapper:getType() then
      ToClient_requestRepeatWork(WorkerNo(workerNoRaw), 1)
      FGlobal_HarvestList_Update()
    elseif currentActionPoint > 0 then
      ToClient_requestRepeatWork(WorkerNo(workerNoRaw), currentActionPoint)
    end
  end
end
function HandleClicked_UnReDoWork(workerIndex)
  local workerWrapperLua = getWorkerWrapper(filteredArray[workerIndex], false)
  local workerNoRaw = filteredArray[workerIndex]
  local function doUnRepeatWork()
    ToClient_requestEraseRepeat(WorkerNo(workerNoRaw))
    workerManager_Update()
  end
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_MESSAGEBOX_UNREPEATCONFIRM"),
    functionYes = doUnRepeatWork,
    functionCancel = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function workerManager_ToolTip(isShow, workerIndex, uiIndex)
  local self = workerManager
  if isShow then
    local workerNoRaw = filteredArray[workerIndex]
    if nil ~= workerNoRaw then
      FGlobal_ShowWorkerTooltipByWorkerNoRaw(workerNoRaw, Panel_WorkerManager)
    else
      FGlobal_HideWorkerTooltip()
    end
  else
    FGlobal_HideWorkerTooltip()
  end
  TooltipSimple_Hide()
end
function FromClient_WorkerDataAllUpdate()
  workerManager_Update()
  restoreItem_update()
  if Panel_WorkerRestoreAll:GetShow() then
    FGlobal_restoreItem_update()
  end
end
function Push_Work_Start_Message(workerNo, _workType, buildingInfoSS)
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
function Push_Worker_StopWork_Message(workerNo, isUserRequest, working)
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
function Push_Work_ResultItem_Message(WorkerNoRaw)
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
function WorkerManager_ButtonSimpleToolTip(isShow, limitCount, tipType)
  local self = workerManager
  local name, desc, control
  local slot = self.slot[limitCount]
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_RESTORE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_RESTORE_DESC")
    control = slot.btn_Restore
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_UPGRADE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_UPGRADE_DESC")
    control = slot.btn_Upgrade
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_REPEAT_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_REPEAT_DESC")
    control = slot.btn_Repeat
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_STOP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_STOP_DESC")
    control = slot.btn_Stop
  elseif 4 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_CHANGESKILL_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_CHANGESKILL_DESC")
    control = slot.btn_ChangeSkill
  elseif 5 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_UNREPEAT_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_UNREPEAT_DESC")
    control = slot.btn_UnRepeat
  else
    name = ""
    desc = ""
    control = slot.btn_Restore
  end
  registTooltipControl(control, Panel_Tooltip_SimpleText)
  if isShow == true then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function FromClient_WorkerDataUpdate_HeadingPlant(ExplorationNode, workerNo)
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
  workerManager_UpdateMain()
end
function FromClient_WorkerDataUpdate_HeadingHouse(rentHouseWrapper, workerNo)
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
  workerManager_UpdateMain()
end
function FromClient_WorkerDataUpdate_HeadingBuilding(buildingInfoSS, workerNo)
  if 0 ~= Int64toInt32(workerNo) then
    Push_Work_Start_Message(workerNo, workType._Building, buildingInfoSS)
  end
  if plantKey == nil then
    return
  end
  local affiliatedTownKey = ToClient_getBuildingAffiliatedWaypointKey(buildingInfoSS)
  workerManager_UpdateMain()
end
function FromClient_WorkerDataUpdate_HeadingRegionManaging(regionGroupInfo, workerNo)
  if 0 ~= Int64toInt32(workerNo) then
    Push_Work_Start_Message(workerNo, workType._RegionWork)
  end
  workerManager_UpdateMain()
end
function FromClient_changeLeftWorking(workerNo)
end
function FromClient_ChangeWorkerSkillNoOne(workerNoRaw)
end
function FromClient_ChangeWorkerSkillNo(workerNoRaw)
end
function workerManager_PopUp_ShowIconToolTip(isShow)
  if isShow then
    local self = workerManager
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
    local desc = ""
    if self.checkPopUp:IsCheck() then
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_CHECK_TOOLTIP")
    else
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_NOCHECK_TOOLTIP")
    end
    TooltipSimple_Show(self.checkPopUp, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobalFunc_WorkerManager_TooltipLimitedText(index, isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if nil == tempTable then
    return
  end
  TooltipSimple_Show(tempTable[index].control, tempTable[index].name, tempTable[index].desc)
end
workerManager_Initiallize()
workerManager:registEventHandler()
workerManager:registMessageHandler()

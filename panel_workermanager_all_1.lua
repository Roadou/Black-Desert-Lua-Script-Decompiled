function PaGlobal_WorkerManager_All:initialize()
  if true == PaGlobal_WorkerManager_All._initialize then
    return
  end
  PaGlobal_WorkerManager_All._panel = Panel_Window_WorkerManager_All
  PaGlobal_WorkerManager_All:initCommon()
  if true == _ContentsGroup_isConsolePadControl then
    PaGlobal_WorkerManager_All:initConsole()
  else
    PaGlobal_WorkerManager_All:initPC()
  end
  PaGlobal_WorkerManager_All:registEventHandler()
  PaGlobal_WorkerManager_All:validate()
  PaGlobal_WorkerManager_All._initialize = true
end
function PaGlobal_WorkerManager_All:registEventHandler()
  if nil == PaGlobal_WorkerManager_All._panel then
    return
  end
  if true == _ContentsGroup_isConsolePadControl then
    PaGlobal_WorkerManager_All._panel:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_WorkerManager_All_ChangeTab(-1)")
    PaGlobal_WorkerManager_All._panel:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobalFunc_WorkerManager_All_ChangeTab(1)")
    registerEvent("FromClient_ChangeWorkerCount", "PaGlobalFunc_WorkerManager_All_UpdateWorkerList")
  else
    Panel_Window_WorkerManager_All:RegisterShowEventFunc(true, "PaGlobalFunc_WorkerManager_All_ShowAni()")
    Panel_Window_WorkerManager_All:RegisterShowEventFunc(false, "PaGlobalFunc_WorkerManager_All_HideAni()")
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Command:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_SelectTab(" .. PaGlobal_WorkerManager_All._config._tab._Command .. ")")
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Skill:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_SelectTab(" .. PaGlobal_WorkerManager_All._config._tab._Skill .. ")")
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Promote:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_SelectTab(" .. PaGlobal_WorkerManager_All._config._tab._Promote .. ")")
    PaGlobal_WorkerManager_All._pcUI.btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_WorkerManager_Close()")
    PaGlobal_WorkerManager_All._pcUI.btn_PopUp:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_PopUp()")
    PaGlobal_WorkerManager_All._pcUI.btn_PopUp:addInputEvent("Mouse_On", "PaGlobalFunc_WorkerManager_All_PopUp_ShowIconToolTip(true)")
    PaGlobal_WorkerManager_All._pcUI.btn_PopUp:addInputEvent("Mouse_Out", "PaGlobalFunc_WorkerManager_All_PopUp_ShowIconToolTip(false)")
    PaGlobal_WorkerManager_All._pcUI.btn_FireCheckedWorker:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_FireWorkerChecked()")
    registerEvent("WorldMap_StopWorkerWorking", "PaGlobalFunc_WorkerManager_All_PushWorkStopMessage")
    registerEvent("FromClient_ClearWorkerUpgradePoint", "PaGlobalFunc_WorkerManager_All_UpdateWorkerList")
  end
  PaGlobal_WorkerManager_All._commonUI.list_Worker:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_WorkerManager_All_listCreate")
  PaGlobal_WorkerManager_All._commonUI.list_Worker:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  PaGlobal_WorkerManager_All._commonUI.list_Worker:getElementManager():clearKey()
  registerEvent("FromClient_AppliedChangeUseType", "PaGlobalFunc_WorkerManager_All_UpdateWorkerList")
  registerEvent("FromClient_ReceiveReturnHouse", "PaGlobalFunc_WorkerManager_All_UpdateWorkerList")
  registerEvent("WorldMap_WorkerDataUpdate", "PaGlobalFunc_WorkerManager_All_UpdateWorkerList")
  registerEvent("WorldMap_WorkerDataUpdate", "FromClient_WorkerManager_All_WorkerDataUpdate_HeadingPlant")
  registerEvent("WorldMap_WorkerDataUpdateByHouse", "FromClient_WorkerManager_All_WorkerDataUpdate_HeadingHouse")
  registerEvent("WorldMap_WorkerDataUpdateByBuilding", "FromClient_WorkerManager_All_WorkerDataUpdate_HeadingBuilding")
  registerEvent("WorldMap_WorkerDataUpdateByRegionManaging", "FromClient_WorkerManager_All_WorkerDataUpdate_HeadingRegionManaging")
  registerEvent("FromClient_UpdateLastestWorkingResult", "PaGlobalFunc_WorkerManager_All_PushWorkResultItemMessage")
  PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_WorkerManager_All_sliderScroll( true )")
  PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_WorkerManager_All_sliderScroll( false )")
  PaGlobal_WorkerManager_All._commonUI.btn_RestoreItemClose:addInputEvent("Mouse_LUp", "HandleClicked_WorkerManager_All_RestoreItemClose()")
  PaGlobal_WorkerManager_All._panel:RegisterUpdateFunc("PaGlobalFunc_WorkerManager_All_PerFrameUpdate")
end
function PaGlobal_WorkerManager_All:prepareOpen()
  if nil == PaGlobal_WorkerManager_All._panel then
    return
  end
  if PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:GetShow() then
    HandleClicked_WorkerManager_All_RestoreItemClose()
  end
  PaGlobal_WorkerManager_All:setData()
  PaGlobal_WorkerManager_All:updateListData()
  PaGlobal_WorkerManager_All:update()
  PaGlobal_WorkerManager_All:open()
end
function PaGlobal_WorkerManager_All:open()
  if nil == PaGlobal_WorkerManager_All._panel then
    return
  end
  PaGlobal_WorkerManager_All._panel:SetShow(true)
end
function PaGlobal_WorkerManager_All:prepareClose()
  if nil == PaGlobal_WorkerManager_All._panel then
    return
  end
  PaGlobal_WorkerManager_All:close()
end
function PaGlobal_WorkerManager_All:close()
  if nil == PaGlobal_WorkerManager_All._panel then
    return
  end
  PaGlobal_WorkerManager_All._panel:SetShow(false)
end
function PaGlobal_WorkerManager_All:update(notSetScroll)
  if nil == PaGlobal_WorkerManager_All._panel then
    return
  end
  local toIndex = 0
  local scrollvalue = 0
  local vscroll = PaGlobal_WorkerManager_All._commonUI.list_Worker:GetVScroll()
  local hscroll = PaGlobal_WorkerManager_All._commonUI.list_Worker:GetHScroll()
  if nil == notSetScroll then
    toIndex = PaGlobal_WorkerManager_All._commonUI.list_Worker:getCurrenttoIndex()
    if false == PaGlobal_WorkerManager_All._commonUI.list_Worker:IsIgnoreVerticalScroll() then
      scrollvalue = vscroll:GetControlPos()
    elseif false == PaGlobal_WorkerManager_All._commonUI.list_Worker:IsIgnoreHorizontalScroll() then
      scrollvalue = hscroll:GetControlPos()
    end
  end
  PaGlobal_WorkerManager_All:updateListData()
  PaGlobal_WorkerManager_All:setRightPanelInfo(PaGlobal_WorkerManager_All._selectedWorker)
  PaGlobal_WorkerManager_All._commonUI.list_Worker:setCurrenttoIndex(toIndex)
  if nil == notSetScroll then
    if false == PaGlobal_WorkerManager_All._commonUI.list_Worker:IsIgnoreVerticalScroll() then
      vscroll:SetControlPos(scrollvalue)
    elseif false == PaGlobal_WorkerManager_All._commonUI.list_Worker:IsIgnoreHorizontalScroll() then
      hscroll:SetControlPos(scrollvalue)
    end
  end
  if false == _ContentsGroup_isConsolePadControl then
    if nil ~= Panel_WorkerRestoreAll and Panel_WorkerRestoreAll:GetShow() then
      FGlobal_restoreItem_update()
    end
    PaGlobal_WorkerManager_All:updateRestoreItem()
  end
end
function PaGlobal_WorkerManager_All:validate()
  if nil == PaGlobal_WorkerManager_All._panel then
    return
  end
  PaGlobal_WorkerManager_All._commonUI.list_Worker:isValidate()
  PaGlobal_WorkerManager_All._commonUI.stc_InfoBG:isValidate()
  PaGlobal_WorkerManager_All._commonUI.stc_TitleBG:isValidate()
  PaGlobal_WorkerManager_All._commonUI.stc_RightGroup:isValidate()
  PaGlobal_WorkerManager_All._commonUI.btn_Reset:isValidate()
  PaGlobal_WorkerManager_All._commonUI.btn_Fire:isValidate()
  PaGlobal_WorkerManager_All._commonUI.btn_Promote:isValidate()
  PaGlobal_WorkerManager_All._commonUI.btn_RestoreAll:isValidate()
  PaGlobal_WorkerManager_All._commonUI.btn_RepeatAll:isValidate()
  PaGlobal_WorkerManager_All._commonUI.stc_BottomGroup:isValidate()
  PaGlobal_WorkerManager_All._commonUI.btn_ResetUpgradeCnt:isValidate()
  PaGlobal_WorkerManager_All._commonUI.btn_ImmediatlyComplete:isValidate()
  PaGlobal_WorkerManager_All._commonUI.stc_WorkerSkillBg:isValidate()
  PaGlobal_WorkerManager_All._commonUI.stc_UpgradeBg:isValidate()
  PaGlobal_WorkerManager_All._commonUI.stc_DescBg:isValidate()
  PaGlobal_WorkerManager_All._commonUI.stc_TabLine:isValidate()
  PaGlobal_WorkerManager_All._commonUI.stc_WokerImageBG:isValidate()
  PaGlobal_WorkerManager_All._commonUI.stc_WorkerImage:isValidate()
  PaGlobal_WorkerManager_All._commonUI.txt_WorkerTitle:isValidate()
  PaGlobal_WorkerManager_All._commonUI.txt_Node:isValidate()
  PaGlobal_WorkerManager_All._commonUI.txt_WorkerState:isValidate()
  PaGlobal_WorkerManager_All._commonUI.stc_RemainTimeProgressBg:isValidate()
  PaGlobal_WorkerManager_All._commonUI.progress_RemainTimeProgress:isValidate()
  PaGlobal_WorkerManager_All._commonUI.txt_WorkingNameCount:isValidate()
  PaGlobal_WorkerManager_All._commonUI.txt_WorkingSpeedTitle:isValidate()
  PaGlobal_WorkerManager_All._commonUI.txt_MovingSpeedTitle:isValidate()
  PaGlobal_WorkerManager_All._commonUI.txt_LuckTitle:isValidate()
  PaGlobal_WorkerManager_All._commonUI.txt_EnergyTitle:isValidate()
  PaGlobal_WorkerManager_All._commonUI.txt_WorkingSpeedValue:isValidate()
  PaGlobal_WorkerManager_All._commonUI.txt_MovingSpeedValue:isValidate()
  PaGlobal_WorkerManager_All._commonUI.txt_LuckValue:isValidate()
  PaGlobal_WorkerManager_All._commonUI.txt_EnergyValue:isValidate()
  for index = 1, PaGlobal_WorkerManager_All._config._skillSlotCount do
    PaGlobal_WorkerManager_All._commonUI.skillSlot[index].stc_SkillSlotBg:isValidate()
    PaGlobal_WorkerManager_All._commonUI.skillSlot[index].stc_SkillSlot:isValidate()
    PaGlobal_WorkerManager_All._commonUI.skillSlot[index].txt_SkillTitle:isValidate()
    PaGlobal_WorkerManager_All._commonUI.skillSlot[index].txt_SkillDesc:isValidate()
  end
  for index = 1, PaGlobal_WorkerManager_All._config._upgradeSlotCount do
    PaGlobal_WorkerManager_All._commonUI.upgradeSlot[index].stc_UpgradeStateBg:isValidate()
    PaGlobal_WorkerManager_All._commonUI.upgradeSlot[index].txt_UpgradeLevel:isValidate()
    PaGlobal_WorkerManager_All._commonUI.upgradeSlot[index].txt_UpgradeState:isValidate()
    PaGlobal_WorkerManager_All._commonUI.upgradeSlot[index].txt_UpgradeTitle:isValidate()
  end
  if true == _ContentsGroup_isConsolePadControl then
    PaGlobal_WorkerManager_All._commonUI.stc_ButtonBG:isValidate()
    PaGlobal_WorkerManager_All._consoleUI.stc_BottomBG:isValidate()
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonRTY:isValidate()
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonRTX:isValidate()
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonY:isValidate()
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonX:isValidate()
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonA:isValidate()
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonB:isValidate()
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Command:isValidate()
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Skill:isValidate()
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Promote:isValidate()
  else
    PaGlobal_WorkerManager_All._commonUI.stc_ButtonBG:isValidate()
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Command:isValidate()
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Skill:isValidate()
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Promote:isValidate()
    PaGlobal_WorkerManager_All._pcUI.btn_Close:isValidate()
    PaGlobal_WorkerManager_All._pcUI.btn_PopUp:isValidate()
    PaGlobal_WorkerManager_All._pcUI.btn_FireCheckedWorker:isValidate()
    PaGlobal_WorkerManager_All._pcUI.btn_ChangeSkill:isValidate()
  end
end
function PaGlobal_WorkerManager_All:setData()
  PaGlobal_WorkerManager_All._selectedTab = 0
  PaGlobal_WorkerManager_All._selectedWorker = 0
  PaGlobal_WorkerManager_All:selectTab(0)
  PaGlobal_WorkerManager_All._filterTown = PaGlobal_WorkerManager_All._config._workerTownString[0]
  PaGlobal_WorkerManager_All._filterGrade = PaGlobal_WorkerManager_All._config._workerGradeString[5]
  PaGlobal_WorkerManager_All._workerList = {}
  PaGlobal_WorkerManager_All._workerCount = 0
  PaGlobal_WorkerManager_All._workerCheckList = {}
  PaGlobal_WorkerManager_All._sliderStartIdx = 0
  PaGlobal_WorkerManager_All._startIndex = 1
end
function PaGlobal_WorkerManager_All:initCommon()
  PaGlobal_WorkerManager_All._commonUI.list_Worker = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "List2_Worker")
  PaGlobal_WorkerManager_All._commonUI.stc_InfoBG = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Static_WorkerInformationBg")
  PaGlobal_WorkerManager_All._commonUI.stc_TitleBG = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Static_TitleBg")
  PaGlobal_WorkerManager_All._commonUI.stc_RightGroup = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "Static_RightGroup")
  PaGlobal_WorkerManager_All._commonUI.btn_Reset = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_RightGroup, "Button_UnRepeatWork")
  PaGlobal_WorkerManager_All._commonUI.btn_Fire = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_RightGroup, "button_EachWorkerFire")
  PaGlobal_WorkerManager_All._commonUI.btn_Promote = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_RightGroup, "Button_WorkerUpgrade")
  PaGlobal_WorkerManager_All._commonUI.btn_RestoreAll = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Button_Restore_All_PCUI")
  PaGlobal_WorkerManager_All._commonUI.btn_RepeatAll = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Button_ReDo_All_PCUI")
  PaGlobal_WorkerManager_All._commonUI.stc_BottomGroup = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Static_BottomGroup")
  PaGlobal_WorkerManager_All._commonUI.btn_ResetUpgradeCnt = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_BottomGroup, "Button_ResetUpgradeCount_PCUI")
  PaGlobal_WorkerManager_All._commonUI.btn_ImmediatlyComplete = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_BottomGroup, "Button_ImmediatlyComplete_PCUI")
  PaGlobal_WorkerManager_All._commonUI.stc_WorkerSkillBg = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Static_WorkerSkillBg")
  PaGlobal_WorkerManager_All._commonUI.stc_UpgradeBg = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Static_UpgradeBg")
  PaGlobal_WorkerManager_All._commonUI.stc_DescBg = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Static_DescBg")
  PaGlobal_WorkerManager_All._commonUI.stc_TabLine = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Static_TapBtnBar")
  PaGlobal_WorkerManager_All._commonUI.stc_WokerImageBG = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "Static_WorkerBg")
  PaGlobal_WorkerManager_All._commonUI.stc_WorkerImage = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_WokerImageBG, "Static_WorkerImage")
  PaGlobal_WorkerManager_All._commonUI.txt_WorkerTitle = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "StaticText_WorkerTitle")
  PaGlobal_WorkerManager_All._commonUI.txt_Node = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "StaticText_Node")
  PaGlobal_WorkerManager_All._commonUI.txt_WorkerState = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "StaticText_State")
  PaGlobal_WorkerManager_All._commonUI.stc_RemainTimeProgressBg = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "Static_RemainTimeProgressBg")
  PaGlobal_WorkerManager_All._commonUI.progress_RemainTimeProgress = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "Progress2_RemainTimeProgress")
  PaGlobal_WorkerManager_All._commonUI.txt_WorkingNameCount = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "StaticText_WorkingNameCount")
  PaGlobal_WorkerManager_All._commonUI.txt_WorkingSpeedTitle = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "StaticText_WorkingSpeedTitle")
  PaGlobal_WorkerManager_All._commonUI.txt_MovingSpeedTitle = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "StaticText_MovingSpeedTitle")
  PaGlobal_WorkerManager_All._commonUI.txt_LuckTitle = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "StaticText_LuckTitle")
  PaGlobal_WorkerManager_All._commonUI.txt_EnergyTitle = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "StaticText_EnergyTitle")
  PaGlobal_WorkerManager_All._commonUI.txt_WorkingSpeedValue = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "StaticText_WorkingSpeedValue")
  PaGlobal_WorkerManager_All._commonUI.txt_MovingSpeedValue = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "StaticText_MovingSpeedValue")
  PaGlobal_WorkerManager_All._commonUI.txt_LuckValue = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "StaticText_LuckValue")
  PaGlobal_WorkerManager_All._commonUI.txt_EnergyValue = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_InfoBG, "StaticText_EnergyValue")
  for index = 1, PaGlobal_WorkerManager_All._config._skillSlotCount do
    local skillInfo = {}
    skillInfo.stc_SkillSlotBg = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_WorkerSkillBg, "Static_SkillSlotBg" .. index)
    skillInfo.stc_SkillSlot = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_WorkerSkillBg, "Static_SkillSlot" .. index)
    skillInfo.txt_SkillTitle = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_WorkerSkillBg, "StaticText_SkillTitle" .. index)
    skillInfo.txt_SkillTitle:SetSize(300, 20)
    skillInfo.txt_SkillDesc = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_WorkerSkillBg, "StaticText_SkillDesc" .. index)
    skillInfo.txt_SkillDesc:SetSize(320, 47)
    PaGlobal_WorkerManager_All._commonUI.skillSlot[index] = skillInfo
  end
  for index = 1, PaGlobal_WorkerManager_All._config._upgradeSlotCount do
    local upgradeInfo = {}
    upgradeInfo.stc_UpgradeStateBg = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_UpgradeBg, "Static_UpgradeStateBg" .. index)
    upgradeInfo.txt_UpgradeLevel = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_UpgradeBg, "StaticText_UpgradeLevel" .. index)
    upgradeInfo.txt_UpgradeState = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_UpgradeBg, "StaticText_UpgradeState" .. index)
    upgradeInfo.txt_UpgradeTitle = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_UpgradeBg, "StaticText_UpgradeTitle" .. index)
    PaGlobal_WorkerManager_All._commonUI.upgradeSlot[index] = upgradeInfo
  end
  PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Static_Restore_Item_BG")
  PaGlobal_WorkerManager_All._commonUI.btn_RestoreItemClose = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Button_Close_Item")
  PaGlobal_WorkerManager_All._commonUI.slider_RestoreSlider = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Slider_Restore_Item")
  PaGlobal_WorkerManager_All._commonUI.stc_GuideRestoreAll = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "StaticText_Guide_RestoreAll")
  PaGlobal_WorkerManager_All._commonUI.btn_SliderBtn = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.slider_RestoreSlider, "Slider_Restore_Item_Button")
  for resIdx = 0, PaGlobal_WorkerManager_All._restoreItemMaxCount - 1 do
    local tempItemSlot = {}
    tempItemSlot.slotBG = UI.createAndCopyBasePropertyControl(PaGlobal_WorkerManager_All._panel, "Static_Restore_Item_Icon_BG", PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG, "workerManager_restoreSlotBG_" .. resIdx)
    tempItemSlot.slotIcon = UI.createAndCopyBasePropertyControl(PaGlobal_WorkerManager_All._panel, "Static_Restore_Item_Icon", tempItemSlot.slotBG, "workerManager_restoreSlot_" .. resIdx)
    tempItemSlot.itemCount = UI.createAndCopyBasePropertyControl(PaGlobal_WorkerManager_All._panel, "StaticText_Item_Count", tempItemSlot.slotIcon, "workerManager_restoreItemCount_" .. resIdx)
    tempItemSlot.restorePoint = UI.createAndCopyBasePropertyControl(PaGlobal_WorkerManager_All._panel, "StaticText_Item_Restore_Value", tempItemSlot.slotIcon, "workerManager_restorePoint_" .. resIdx)
    tempItemSlot.slotBG:SetPosX(5 + tempItemSlot.slotBG:GetSizeX() * resIdx)
    tempItemSlot.slotBG:SetPosY(23)
    tempItemSlot.slotIcon:SetPosX(5)
    tempItemSlot.slotIcon:SetPosY(5)
    tempItemSlot.itemCount:SetPosX(tempItemSlot.slotIcon:GetSizeX() - 9)
    tempItemSlot.itemCount:SetPosY(tempItemSlot.slotIcon:GetSizeY() - 10)
    tempItemSlot.restorePoint:SetPosX(3)
    tempItemSlot.restorePoint:SetPosY(2)
    tempItemSlot.slotIcon:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_WorkerManager_All_sliderScroll( true )")
    tempItemSlot.slotIcon:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_WorkerManager_All_sliderScroll( false )")
    PaGlobal_WorkerManager_All._restoreItemSlot[resIdx] = tempItemSlot
  end
  PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:AddChild(PaGlobal_WorkerManager_All._commonUI.btn_RestoreItemClose)
  PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:AddChild(PaGlobal_WorkerManager_All._commonUI.slider_RestoreSlider)
  PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:AddChild(PaGlobal_WorkerManager_All._commonUI.stc_GuideRestoreAll)
  PaGlobal_WorkerManager_All._panel:RemoveControl(PaGlobal_WorkerManager_All._commonUI.btn_RestoreItemClose)
  PaGlobal_WorkerManager_All._panel:RemoveControl(PaGlobal_WorkerManager_All._commonUI.slider_RestoreSlider)
  PaGlobal_WorkerManager_All._panel:RemoveControl(PaGlobal_WorkerManager_All._commonUI.stc_GuideRestoreAll)
  PaGlobal_WorkerManager_All._commonUI.btn_RestoreItemClose:ComputePos()
  PaGlobal_WorkerManager_All._commonUI.slider_RestoreSlider:ComputePos()
  PaGlobal_WorkerManager_All._commonUI.stc_GuideRestoreAll:ComputePos()
end
function PaGlobal_WorkerManager_All:initConsole()
  PaGlobal_WorkerManager_All._panel:SetSize(PaGlobal_WorkerManager_All._panel:GetSizeX(), PaGlobal_WorkerManager_All._panel:GetSizeY() - PaGlobal_WorkerManager_All._commonUI.btn_RestoreAll:GetSizeY())
  PaGlobal_WorkerManager_All._commonUI.stc_ButtonBG = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Static_RadioButtonBg_ConsoleUI")
  PaGlobal_WorkerManager_All._consoleUI.stc_BottomBG = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Static_BottomBg_ConsoleUI")
  PaGlobal_WorkerManager_All._consoleUI.stc_BottomBG:SetPosY(PaGlobal_WorkerManager_All._consoleUI.stc_BottomBG:GetPosY() - PaGlobal_WorkerManager_All._commonUI.btn_RestoreAll:GetSizeY())
  PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonRTY = UI.getChildControl(PaGlobal_WorkerManager_All._consoleUI.stc_BottomBG, "Static_AllRestoreBtn_Group")
  PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonRTX = UI.getChildControl(PaGlobal_WorkerManager_All._consoleUI.stc_BottomBG, "Static_AllRepeatBtn_Group")
  PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonY = UI.getChildControl(PaGlobal_WorkerManager_All._consoleUI.stc_BottomBG, "StaticText_Recover_ConsoleUI")
  PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonX = UI.getChildControl(PaGlobal_WorkerManager_All._consoleUI.stc_BottomBG, "StaticText_Repeat_ConsoleUI")
  PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonA = UI.getChildControl(PaGlobal_WorkerManager_All._consoleUI.stc_BottomBG, "StaticText_Select_ConsoleUI")
  PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonB = UI.getChildControl(PaGlobal_WorkerManager_All._consoleUI.stc_BottomBG, "StaticText_Close_ConsoleUI")
  PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Command = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_ButtonBG, "RadioButton_BaseOrder_ConsoleUI")
  PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Skill = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_ButtonBG, "RadioButton_Skill_ConsoleUI")
  PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Promote = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_ButtonBG, "RadioButton_Upgrade_ConsoleUI")
  PaGlobal_WorkerManager_All._commonUI.stc_ButtonBG:SetShow(true)
  PaGlobal_WorkerManager_All._consoleUI.stc_BottomBG:SetShow(true)
end
function PaGlobal_WorkerManager_All:initPC()
  PaGlobal_WorkerManager_All._commonUI.stc_ButtonBG = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "Static_RadioButtonBg_PCUI")
  PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Command = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_ButtonBG, "RadioButton_BaseOrder_PCUI")
  PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Skill = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_ButtonBG, "RadioButton_Skill_PCUI")
  PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Promote = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_ButtonBG, "RadioButton_Upgrade_PCUI")
  PaGlobal_WorkerManager_All._pcUI.btn_Close = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_TitleBG, "Button_Win_Close_PCUI")
  PaGlobal_WorkerManager_All._pcUI.btn_PopUp = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_TitleBG, "CheckButton_PopUp_PCUI")
  PaGlobal_WorkerManager_All._pcUI.btn_FireCheckedWorker = UI.getChildControl(PaGlobal_WorkerManager_All._panel, "button_doWorkerFire_PCUI")
  PaGlobal_WorkerManager_All._pcUI.btn_ChangeSkill = UI.getChildControl(PaGlobal_WorkerManager_All._commonUI.stc_RightGroup, "Button_WorkerChangeSkill")
  PaGlobal_WorkerManager_All._commonUI.stc_ButtonBG:SetShow(true)
  PaGlobal_WorkerManager_All._pcUI.btn_Close:SetShow(true)
  PaGlobal_WorkerManager_All._pcUI.btn_FireCheckedWorker:SetShow(true)
  isPopUpContentsEnable = ToClient_IsContentsGroupOpen("240")
  PaGlobal_WorkerManager_All._pcUI.btn_PopUp:SetShow(false)
end
function PaGlobal_WorkerManager_All:changeTab(changeValue)
  local tabIndex = PaGlobal_WorkerManager_All._selectedTab + changeValue
  if tabIndex < 0 then
    tabIndex = PaGlobal_WorkerManager_All._config._tab._TabCount - 1
  elseif tabIndex >= PaGlobal_WorkerManager_All._config._tab._TabCount then
    tabIndex = PaGlobal_WorkerManager_All._config._tab._Command
  end
  PaGlobal_WorkerManager_All:selectTab(tabIndex)
end
function PaGlobal_WorkerManager_All:selectTab(tabIndex)
  for _, controlName in pairs(PaGlobal_WorkerManager_All._commonUI.tabText) do
    controlName:SetFontColor(4287862695)
  end
  PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Command:SetCheck(false)
  PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Skill:SetCheck(false)
  PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Promote:SetCheck(false)
  if PaGlobal_WorkerManager_All._config._tab._Command == tabIndex then
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Command:SetCheck(true)
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Command:SetFontColor(Defines.Color.C_FFEEEEEE)
    PaGlobal_WorkerManager_All._commonUI.stc_TabLine:SetPosX(PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Command:GetPosX())
  elseif PaGlobal_WorkerManager_All._config._tab._Skill == tabIndex then
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Skill:SetCheck(true)
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Skill:SetFontColor(Defines.Color.C_FFEEEEEE)
    PaGlobal_WorkerManager_All._commonUI.stc_TabLine:SetPosX(PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Skill:GetPosX())
  elseif PaGlobal_WorkerManager_All._config._tab._Promote == tabIndex then
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Promote:SetCheck(true)
    PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Promote:SetFontColor(Defines.Color.C_FFEEEEEE)
    PaGlobal_WorkerManager_All._commonUI.stc_TabLine:SetPosX(PaGlobal_WorkerManager_All._commonUI.tabText.rdo_Promote:GetPosX())
  end
  PaGlobal_WorkerManager_All._selectedTab = tabIndex
  if true == _ContentsGroup_isConsolePadControl then
    PaGlobal_WorkerManager_All:selectWorker(PaGlobal_WorkerManager_All._selectedWorker)
  else
    PaGlobal_WorkerManager_All:selectWorkerPC(PaGlobal_WorkerManager_All._selectedWorker)
  end
end
function PaGlobal_WorkerManager_All:selectWorkerPC(workerNoRawStr)
  PaGlobal_WorkerManager_All._commonUI.stc_RightGroup:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.btn_Reset:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.btn_Fire:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.btn_Promote:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.btn_RestoreAll:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.btn_RepeatAll:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.stc_BottomGroup:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.btn_ResetUpgradeCnt:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.btn_ImmediatlyComplete:SetShow(false)
  PaGlobal_WorkerManager_All._pcUI.btn_ChangeSkill:SetShow(false)
  if nil == workerNoRawStr then
    return
  end
  PaGlobal_WorkerManager_All._selectedWorker = workerNoRawStr
  local workerWrapperLua = getWorkerWrapper(tonumber64(workerNoRawStr))
  if nil == workerWrapperLua then
    return
  end
  local workingState = workerWrapperLua:getWorkingType()
  if PaGlobal_WorkerManager_All._config._tab._Command == PaGlobal_WorkerManager_All._selectedTab then
    PaGlobal_WorkerManager_All._commonUI.btn_RestoreAll:SetShow(true)
    PaGlobal_WorkerManager_All._commonUI.btn_RepeatAll:SetShow(true)
    PaGlobal_WorkerManager_All._commonUI.btn_RestoreAll:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_WorkerRestore()")
    PaGlobal_WorkerManager_All._commonUI.btn_RepeatAll:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_WorkerRepeatAll()")
    if CppEnums.NpcWorkingType.eNpcWorkingType_Count == workingState then
      PaGlobal_WorkerManager_All._commonUI.stc_RightGroup:SetShow(true)
      PaGlobal_WorkerManager_All._commonUI.btn_Fire:SetShow(true)
      PaGlobal_WorkerManager_All._commonUI.btn_Fire:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_BUTTONFIRE"))
      PaGlobal_WorkerManager_All._commonUI.btn_Fire:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_FireWorker()")
      PaGlobal_WorkerManager_All._commonUI.btn_Reset:SetShow(true)
      PaGlobal_WorkerManager_All._commonUI.btn_Reset:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_ClearWorkerRepeatInfo()")
    end
    if false == PaGlobal_WorkerManager_All._commonUI.btn_Fire:GetShow() then
      PaGlobal_WorkerManager_All._commonUI.btn_Reset:SetPosX(PaGlobal_WorkerManager_All._commonUI.btn_Fire:GetPosX())
    else
      PaGlobal_WorkerManager_All._commonUI.btn_Reset:ComputePos()
    end
  elseif PaGlobal_WorkerManager_All._config._tab._Skill == PaGlobal_WorkerManager_All._selectedTab then
    PaGlobal_WorkerManager_All._commonUI.stc_RightGroup:SetShow(true)
    PaGlobal_WorkerManager_All._pcUI.btn_ChangeSkill:SetShow(true)
    PaGlobal_WorkerManager_All._pcUI.btn_ChangeSkill:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_WorkerChangeSkill()")
  else
    PaGlobal_WorkerManager_All._commonUI.stc_RightGroup:SetShow(true)
    PaGlobal_WorkerManager_All._commonUI.btn_Promote:SetShow(true)
    PaGlobal_WorkerManager_All._commonUI.btn_Promote:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_UpgradeWorker()")
  end
end
function PaGlobal_WorkerManager_All:selectWorker(workerNoRawStr)
  local keyGuide = {
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonY,
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonX,
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonA,
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonB
  }
  PaGlobal_WorkerManager_All._selectedWorker = workerNoRawStr
  PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonRTY:SetShow(false)
  PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonRTX:SetShow(false)
  PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonY:SetShow(false)
  PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonX:SetShow(false)
  PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonA:SetShow(true)
  PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonB:SetShow(true)
  PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonA:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORLDMAP_GUILDHOUSE_CHANGEWORKER_SELECTBTN"))
  PaGlobal_WorkerManager_All._commonUI.stc_RightGroup:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.btn_Reset:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.btn_Fire:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.btn_Promote:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.btn_RestoreAll:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.btn_RepeatAll:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.stc_BottomGroup:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.btn_ResetUpgradeCnt:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.btn_ImmediatlyComplete:SetShow(false)
  Panel_Window_WorkerManager_All:registerPadEvent(__eConsoleUIPadEvent_RT, "")
  Panel_Window_WorkerManager_All:registerPadEvent(__eConsoleUIPadEvent_RTPress_X, "")
  Panel_Window_WorkerManager_All:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
  Panel_Window_WorkerManager_All:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  Panel_Window_WorkerManager_All:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
  if nil == workerNoRawStr then
    return
  end
  local workerWrapperLua = getWorkerWrapper(tonumber64(workerNoRawStr))
  if nil == workerWrapperLua then
    return
  end
  local workingState = workerWrapperLua:getWorkingType()
  if PaGlobal_WorkerManager_All._config._tab._Command == PaGlobal_WorkerManager_All._selectedTab then
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonRTY:SetShow(true)
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonRTX:SetShow(true)
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonY:SetShow(true)
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonX:SetShow(true)
    PaGlobal_WorkerManager_All._commonUI.btn_RestoreAll:SetShow(false)
    PaGlobal_WorkerManager_All._commonUI.btn_RepeatAll:SetShow(false)
    Panel_Window_WorkerManager_All:registerPadEvent(__eConsoleUIPadEvent_RT, "PaGlobalFunc_WorkerManager_All_CheckRTButton()")
    Panel_Window_WorkerManager_All:registerPadEvent(__eConsoleUIPadEvent_RTPress_X, "PaGlobalFunc_WorkerManager_All_WorkerRepeatAll()")
    Panel_Window_WorkerManager_All:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_WorkerManager_All_SetRestore()")
    Panel_Window_WorkerManager_All:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_WorkerManager_All_WorkerRepeat()")
    PaGlobal_WorkerManager_All._commonUI.stc_RightGroup:SetShow(true)
    PaGlobal_WorkerManager_All._commonUI.btn_Reset:SetShow(true)
    PaGlobal_WorkerManager_All._commonUI.btn_Reset:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_WorkerStop()")
    if CppEnums.NpcWorkingType.eNpcWorkingType_Count == workingState then
      PaGlobal_WorkerManager_All._commonUI.btn_Fire:SetShow(true)
      PaGlobal_WorkerManager_All._commonUI.btn_Fire:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_BUTTONFIRE"))
      PaGlobal_WorkerManager_All._commonUI.btn_Fire:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_FireWorker()")
    end
    if false == PaGlobal_WorkerManager_All._commonUI.btn_Fire:GetShow() then
      PaGlobal_WorkerManager_All._commonUI.btn_Reset:SetPosX(PaGlobal_WorkerManager_All._commonUI.btn_Fire:GetPosX())
    else
      PaGlobal_WorkerManager_All._commonUI.btn_Reset:ComputePos()
    end
  elseif PaGlobal_WorkerManager_All._config._tab._Skill == PaGlobal_WorkerManager_All._selectedTab then
    PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonA:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERCHANGESKILL_TITLE"))
    Panel_Window_WorkerManager_All:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_WorkerManager_All_WorkerChangeSkill()")
  else
    PaGlobal_WorkerManager_All._commonUI.stc_RightGroup:SetShow(true)
    PaGlobal_WorkerManager_All._commonUI.btn_Promote:SetShow(true)
    PaGlobal_WorkerManager_All._commonUI.btn_Promote:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_UpgradeWorker()")
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuide, PaGlobal_WorkerManager_All._consoleUI.stc_BottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobal_WorkerManager_All:setRightPanelInfo(workerNoRawStr)
  PaGlobal_WorkerManager_All._commonUI.stc_WorkerSkillBg:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.stc_UpgradeBg:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.stc_DescBg:SetShow(false)
  PaGlobal_WorkerManager_All:setWorkerBaseInfo(workerNoRawStr)
  if PaGlobal_WorkerManager_All._config._tab._Command == PaGlobal_WorkerManager_All._selectedTab then
    PaGlobal_WorkerManager_All:setWorkerSkillInfo(workerNoRawStr)
  elseif PaGlobal_WorkerManager_All._config._tab._Skill == PaGlobal_WorkerManager_All._selectedTab then
    PaGlobal_WorkerManager_All:setWorkerSkillInfo(workerNoRawStr)
  elseif PaGlobal_WorkerManager_All._config._tab._Promote == PaGlobal_WorkerManager_All._selectedTab then
    PaGlobal_WorkerManager_All:setWorkerUpgradeInfo(workerNoRawStr)
  end
end
function PaGlobal_WorkerManager_All:setWorkerBaseInfo(workerNoRawStr)
  local isShow = workerNoRawStr ~= nil
  PaGlobal_WorkerManager_All._commonUI.stc_InfoBG:SetShow(true)
  PaGlobal_WorkerManager_All._commonUI.txt_WorkerState:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.stc_RemainTimeProgressBg:SetShow(isShow)
  PaGlobal_WorkerManager_All._commonUI.progress_RemainTimeProgress:SetShow(isShow)
  PaGlobal_WorkerManager_All._commonUI.txt_WorkingNameCount:SetShow(isShow)
  PaGlobal_WorkerManager_All._commonUI.stc_WorkerImage:SetShow(isShow)
  PaGlobal_WorkerManager_All._commonUI.txt_WorkerTitle:SetShow(isShow)
  PaGlobal_WorkerManager_All._commonUI.txt_Node:SetShow(isShow)
  PaGlobal_WorkerManager_All._commonUI.txt_WorkingSpeedTitle:SetShow(isShow)
  PaGlobal_WorkerManager_All._commonUI.txt_MovingSpeedTitle:SetShow(isShow)
  PaGlobal_WorkerManager_All._commonUI.txt_LuckTitle:SetShow(isShow)
  PaGlobal_WorkerManager_All._commonUI.txt_EnergyTitle:SetShow(isShow)
  PaGlobal_WorkerManager_All._commonUI.txt_WorkingSpeedValue:SetShow(isShow)
  PaGlobal_WorkerManager_All._commonUI.txt_MovingSpeedValue:SetShow(isShow)
  PaGlobal_WorkerManager_All._commonUI.txt_LuckValue:SetShow(isShow)
  PaGlobal_WorkerManager_All._commonUI.txt_EnergyValue:SetShow(isShow)
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
  PaGlobal_WorkerManager_All._commonUI.stc_WorkerImage:SetSize(PaGlobal_WorkerManager_All._commonUI.stc_WorkerImage:GetSizeX(), (PaGlobal_WorkerManager_All._commonUI.stc_WorkerImage:GetSizeY()))
  PaGlobal_WorkerManager_All._commonUI.stc_WorkerImage:ChangeTextureInfoName(workerWrapperLua:getWorkerIcon())
  local workerImageClipSize = (PaGlobal_WorkerManager_All._commonUI.stc_WorkerImage:GetSizeX() - PaGlobal_WorkerManager_All._commonUI.stc_WokerImageBG:GetSizeX()) / 2
  PaGlobal_WorkerManager_All._commonUI.stc_WorkerImage:SetRectClipOnArea(float2(workerImageClipSize, 0), float2(PaGlobal_WorkerManager_All._commonUI.stc_WorkerImage:GetSizeX() - workerImageClipSize, PaGlobal_WorkerManager_All._commonUI.stc_WorkerImage:GetSizeY()))
  PaGlobal_WorkerManager_All._commonUI.txt_WorkerTitle:SetText(titleText)
  PaGlobal_WorkerManager_All._commonUI.txt_Node:SetText(ToClient_GetNodeNameByWaypointKey(workerWrapperLua:getHomeWaypoint()))
  PaGlobal_WorkerManager_All._commonUI.progress_RemainTimeProgress:SetProgressRate(leftTimePercent)
  PaGlobal_WorkerManager_All._commonUI.txt_WorkingNameCount:SetText(workerWrapperLua:getWorkString())
  PaGlobal_WorkerManager_All._commonUI.stc_RemainTimeProgressBg:SetShow(true)
  PaGlobal_WorkerManager_All._commonUI.progress_RemainTimeProgress:SetShow(true)
  PaGlobal_WorkerManager_All._commonUI.txt_WorkingNameCount:SetShow(true)
  local _tempWorkEfficiency = PaGlobalFunc_WorkerManager_All_GetWorkEfficiency(workerWrapperLua)
  PaGlobal_WorkerManager_All._commonUI.txt_WorkingSpeedValue:SetText(string.format("%.2f", tostring(_tempWorkEfficiency / 1000000)))
  PaGlobal_WorkerManager_All._commonUI.txt_MovingSpeedValue:SetText(string.format("%.2f", workerWrapperLua:getMoveSpeed() / 100))
  PaGlobal_WorkerManager_All._commonUI.txt_LuckValue:SetText(string.format("%.2f", workerWrapperLua:getLuck() / 10000))
  PaGlobal_WorkerManager_All._commonUI.txt_EnergyValue:SetText(workerWrapperLua:getMaxActionPoint())
end
function PaGlobal_WorkerManager_All:setWorkerSkillInfo(workerNoRawStr)
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
  local endIdx = PaGlobal_WorkerManager_All._config._skillSlotCount
  if nil ~= defaultSkill then
    local lastControl = PaGlobal_WorkerManager_All._commonUI.skillSlot[PaGlobal_WorkerManager_All._config._skillSlotCount]
    startIdx = startIdx + 1
    lastControl.stc_SkillSlotBg:SetShow(true)
    lastControl.stc_SkillSlot:SetShow(true)
    lastControl.txt_SkillTitle:SetShow(true)
    lastControl.txt_SkillDesc:SetShow(true)
    local control = PaGlobal_WorkerManager_All._commonUI.skillSlot[1]
    control.stc_SkillSlotBg:SetShow(true)
    control.stc_SkillSlot:ChangeTextureInfoName(defaultSkill:getIconPath())
    control.txt_SkillTitle:SetText(defaultSkill:getName())
    control.txt_SkillDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    control.txt_SkillDesc:SetText(defaultSkill:getDescription())
  else
    local lastControl = PaGlobal_WorkerManager_All._commonUI.skillSlot[PaGlobal_WorkerManager_All._config._skillSlotCount]
    lastControl.stc_SkillSlotBg:SetShow(false)
    lastControl.stc_SkillSlot:SetShow(false)
    lastControl.txt_SkillTitle:SetShow(false)
    lastControl.txt_SkillDesc:SetShow(false)
    endIdx = endIdx - 1
  end
  PaGlobal_WorkerManager_All._commonUI.stc_WorkerSkillBg:SetShow(true)
  for index = startIdx, endIdx do
    local control = PaGlobal_WorkerManager_All._commonUI.skillSlot[index]
    control.stc_SkillSlotBg:SetShow(true)
    local learnLevel = (index - 1) * 5
    local basicTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. learnLevel
    control.stc_SkillSlot:ChangeTextureInfoName("renewal/commonicon/wokerskill_00.dds")
    control.txt_SkillTitle:SetText(basicTitle)
    control.txt_SkillDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERCHANGESKILL_NOTYETSTUDYSKILL"))
  end
  workerWrapperLua:foreachSkillList(function(skillIdx, skillStaticStatusWrapper)
    if nil ~= defaultSkill then
      skillIdx = skillIdx + 1
    end
    local slotControl = PaGlobal_WorkerManager_All._commonUI.skillSlot[skillIdx + 1]
    if nil == slotControl then
      return true
    end
    PaGlobal_WorkerManager_All:setSkillInfoToSlot(skillIdx + 1, skillStaticStatusWrapper)
    return false
  end)
end
function PaGlobal_WorkerManager_All:setWorkerUpgradeInfo(workerNoRawStr)
  local upgradeSlot = PaGlobal_WorkerManager_All._commonUI.upgradeSlot
  local textureType = PaGlobal_WorkerManager_All._config._workerUpgradeTextureType
  if workerNoRawStr == nil or workerNoRawStr == "" then
    for index = 1, PaGlobal_WorkerManager_All._config._upgradeSlotCount do
      upgradeSlot[index].txt_UpgradeLevel:SetShow(true)
      upgradeSlot[index].txt_UpgradeState:SetShow(true)
    end
    return
  end
  local workerWrapperLua = getWorkerWrapper(tonumber64(workerNoRawStr))
  if nil == workerWrapperLua then
    return
  end
  local upgradableCount = workerWrapperLua:getUpgradePoint()
  local workeLv = workerWrapperLua:getLevel()
  local maxUpgradePoint = math.floor(workeLv / 10)
  local upgradeFailCount = maxUpgradePoint - upgradableCount
  local isProgressing = false
  local isUpgradable = workerWrapperLua:isUpgradable()
  if workerNoRawStr ~= isShowMessage then
    isShowMessage = nil
  end
  PaGlobal_WorkerManager_All._commonUI.stc_UpgradeBg:SetShow(true)
  PaGlobal_WorkerManager_All._commonUI.stc_DescBg:SetShow(true)
  PaGlobal_WorkerManager_All._commonUI.stc_BottomGroup:SetShow(false)
  PaGlobal_WorkerManager_All._commonUI.stc_BottomGroup:SetPosY(PaGlobal_WorkerManager_All._commonUI.stc_BottomGroup:GetPosY() - PaGlobal_WorkerManager_All._commonUI.stc_BottomGroup:GetSizeY())
  PaGlobal_WorkerManager_All._commonUI.stc_BottomGroup:ComputePos()
  if 4 <= workerWrapperLua:getGrade() then
    PaGlobal_WorkerManager_All._commonUI.stc_RightGroup:SetShow(false)
    PaGlobal_WorkerManager_All._commonUI.btn_Promote:SetShow(false)
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
    PaGlobal_WorkerManager_All._commonUI.stc_RightGroup:SetShow(false)
    PaGlobal_WorkerManager_All._commonUI.btn_Promote:SetShow(false)
    PaGlobal_WorkerManager_All._commonUI.stc_BottomGroup:SetShow(true)
    PaGlobal_WorkerManager_All._commonUI.btn_ImmediatlyComplete:SetShow(true)
    PaGlobal_WorkerManager_All._commonUI.btn_ImmediatlyComplete:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_WorkerUpgradeNow()")
  elseif upgradeFailCount >= 3 then
    PaGlobal_WorkerManager_All._commonUI.stc_BottomGroup:SetShow(true)
    PaGlobal_WorkerManager_All._commonUI.btn_ResetUpgradeCnt:SetShow(true)
    if false == PaGlobal_WorkerManager_All._commonUI.btn_ImmediatlyComplete:GetShow() then
      PaGlobal_WorkerManager_All._commonUI.btn_ResetUpgradeCnt:SetPosX(PaGlobal_WorkerManager_All._commonUI.btn_ImmediatlyComplete:GetPosX())
    else
      PaGlobal_WorkerManager_All._commonUI.btn_ResetUpgradeCnt:ComputePos()
    end
    PaGlobal_WorkerManager_All._commonUI.btn_ResetUpgradeCnt:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_ResetUpgradeCount()")
  end
  for index = 1, PaGlobal_WorkerManager_All._config._upgradeSlotCount do
    upgradeSlot[index].txt_UpgradeState:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    if upgradeFailCount > 0 then
      PaGlobal_WorkerManager_All:setWorkerUpgradeTexture(upgradeSlot[index].stc_UpgradeStateBg, textureType._Fail)
      upgradeSlot[index].txt_UpgradeLevel:SetFontColor(PaGlobal_WorkerManager_All._config._fontColor._upgrade_Fail)
      upgradeSlot[index].txt_UpgradeState:SetFontColor(PaGlobal_WorkerManager_All._config._fontColor._upgrade_Fail)
      upgradeSlot[index].txt_UpgradeState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKER_UPGRADE_FAIL"))
      upgradeFailCount = upgradeFailCount - 1
    elseif true == isProgressing then
      isProgressing = false
      isUpgradable = false
      PaGlobal_WorkerManager_All:setWorkerUpgradeTexture(upgradeSlot[index].stc_UpgradeStateBg, textureType._Upgradable)
      upgradeSlot[index].txt_UpgradeLevel:SetFontColor(PaGlobal_WorkerManager_All._config._fontColor._upgrade_NormalLevel)
      upgradeSlot[index].txt_UpgradeState:SetFontColor(PaGlobal_WorkerManager_All._config._fontColor._upgrade_NormalState)
      upgradeSlot[index].txt_UpgradeState:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUESTWINDOW_TAB_PROGRESS"))
    elseif upgradableCount > 0 and true == isUpgradable then
      PaGlobal_WorkerManager_All:setWorkerUpgradeTexture(upgradeSlot[index].stc_UpgradeStateBg, textureType._Upgradable)
      upgradeSlot[index].txt_UpgradeLevel:SetFontColor(PaGlobal_WorkerManager_All._config._fontColor._upgrade_NormalLevel)
      upgradeSlot[index].txt_UpgradeState:SetFontColor(PaGlobal_WorkerManager_All._config._fontColor._upgrade_NormalState)
      upgradeSlot[index].txt_UpgradeState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKER_UPGRADE_AVAILABLE"))
      isUpgradable = false
    else
      PaGlobal_WorkerManager_All:setWorkerUpgradeTexture(upgradeSlot[index].stc_UpgradeStateBg, textureType._InActivation)
      upgradeSlot[index].txt_UpgradeLevel:SetFontColor(PaGlobal_WorkerManager_All._config._fontColor._upgrade_Inactivation)
      upgradeSlot[index].txt_UpgradeState:SetFontColor(PaGlobal_WorkerManager_All._config._fontColor._upgrade_Inactivation)
      upgradeSlot[index].txt_UpgradeState:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKER_UPGRADE_AVAILABLE"))
    end
  end
  PaGlobal_WorkerManager_All:setButtonString()
end
function PaGlobal_WorkerManager_All:setSkillInfoToSlot(skillIdx, skillStaticStatusWrapper)
  local slotControl = PaGlobal_WorkerManager_All._commonUI.skillSlot[skillIdx]
  slotControl.stc_SkillSlot:ChangeTextureInfoNameAsync(skillStaticStatusWrapper:getIconPath())
  slotControl.txt_SkillTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  slotControl.txt_SkillTitle:SetText(skillStaticStatusWrapper:getName())
  slotControl.txt_SkillDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  slotControl.txt_SkillDesc:SetText(skillStaticStatusWrapper:getDescription())
  return true
end
function PaGlobal_WorkerManager_All:setButtonString()
  local workerManagerUI = PaGlobal_WorkerManager_All._commonUI
  workerManagerUI.upgradeSlot[1].txt_UpgradeTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKER_UPGRADE_BYSTEP", "step", "1"))
  workerManagerUI.upgradeSlot[2].txt_UpgradeTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKER_UPGRADE_BYSTEP", "step", "2"))
  workerManagerUI.upgradeSlot[3].txt_UpgradeTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKER_UPGRADE_BYSTEP", "step", "3"))
  workerManagerUI.txt_EnergyTitle:SetText(string.gsub(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERRANDOMSELECT_WORKERACTION"), " ", ""))
end
function PaGlobal_WorkerManager_All:setWorkerUpgradeTexture(upgradeSlot, upgradeTextureType)
  upgradeSlot:ChangeTextureInfoName("combine/etc/combine_etc_workermanage.dds")
  local x1, y1, x2, y2
  if PaGlobal_WorkerManager_All._config._workerUpgradeTextureType._Fail == upgradeTextureType then
    x1, y1, x2, y2 = setTextureUV_Func(upgradeSlot, 120, 120, 238, 238)
  elseif PaGlobal_WorkerManager_All._config._workerUpgradeTextureType._Upgradable == upgradeTextureType then
    x1, y1, x2, y2 = setTextureUV_Func(upgradeSlot, 1, 1, 119, 119)
  else
    x1, y1, x2, y2 = setTextureUV_Func(upgradeSlot, 1, 120, 119, 238)
  end
  upgradeSlot:getBaseTexture():setUV(x1, y1, x2, y2)
  upgradeSlot:setRenderTexture(upgradeSlot:getBaseTexture())
end
function PaGlobal_WorkerManager_All:listCreate(control, key)
  control:SetIgnore(false)
  local btn_ButtonBg = UI.getChildControl(control, "Button_ButtonBg")
  local checkBox_Worker = UI.getChildControl(control, "button_worker_checkBox_PCUI")
  local stc_WorkerImage = UI.getChildControl(control, "Static_WorkerImage")
  local stc_WorkerTitle = UI.getChildControl(control, "StaticText_WorkerTitle")
  local stc_Town = UI.getChildControl(control, "StaticText_Node")
  local stc_WorkingNameCount = UI.getChildControl(control, "StaticText_WorkingNameCount")
  local stc_RemainTimeProgressBg = UI.getChildControl(control, "Static_RemainTimeProgressBg")
  local progress_RemainTimeProgress = UI.getChildControl(control, "Progress2_RemainTimeProgress")
  local stc_EnergyProgressBg = UI.getChildControl(control, "Static_EnergyProgressBg")
  local progress_EnergyProgress = UI.getChildControl(control, "Progress2_EnergyProgress")
  local btn_WorkRestore = UI.getChildControl(control, "Button_WorkRestore")
  local btn_RepeatWork = UI.getChildControl(control, "Button_RepeatWork")
  local btn_Stop = UI.getChildControl(control, "Button_StopWork")
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
  local limitCount = 0
  stc_WorkerTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  stc_WorkerTitle:SetText(titleText)
  stc_WorkerImage:ChangeTextureInfoName(workerWrapperLua:getWorkerIcon())
  stc_Town:SetText(ToClient_GetNodeNameByWaypointKey(workerWrapperLua:getHomeWaypoint()))
  stc_WorkingNameCount:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  stc_WorkingNameCount:SetText(workerWrapperLua:getWorkString())
  progress_RemainTimeProgress:SetProgressRate(leftTimePercent)
  progress_EnergyProgress:SetProgressRate(workerWrapperLua:getActionPointPercents())
  btn_ButtonBg:SetCheck(tostring(key) == PaGlobal_WorkerManager_All._selectedWorker)
  if true == _ContentsGroup_isConsolePadControl then
    local startPosX = checkBox_Worker:GetPosX() + 10
    local middlePosX = startPosX + stc_WorkerImage:GetSizeX() + 20
    stc_WorkerImage:SetPosX(startPosX)
    stc_EnergyProgressBg:SetPosX(startPosX)
    progress_EnergyProgress:SetPosX(startPosX)
    stc_WorkerTitle:SetPosX(middlePosX)
    stc_Town:SetPosX(middlePosX)
    stc_WorkingNameCount:SetPosX(middlePosX)
    stc_RemainTimeProgressBg:SetPosX(middlePosX)
    progress_RemainTimeProgress:SetPosX(middlePosX)
    checkBox_Worker:SetShow(false)
    btn_ButtonBg:addInputEvent("Mouse_On", "PaGlobalFunc_WorkerManager_All_SetRightPanelInfo(\"" .. tostring(key) .. "\")")
  else
    checkBox_Worker:SetCheck(PaGlobal_WorkerManager_All._workerCheckList[tostring(key)])
    if 0 == PaGlobal_WorkerManager_All._selectedWorker and tostring(key) == tostring(PaGlobal_WorkerManager_All._workerList[0]) then
      btn_ButtonBg:SetCheck(true)
      PaGlobal_WorkerManager_All._selectedWorker = tostring(key)
      PaGlobal_WorkerManager_All:selectWorkerPC(PaGlobal_WorkerManager_All._selectedWorker)
      PaGlobal_WorkerManager_All:setRightPanelInfo(PaGlobal_WorkerManager_All._selectedWorker)
    end
    if true == btn_ButtonBg:IsCheck() then
      PaGlobal_WorkerManager_All:selectWorkerPC(PaGlobal_WorkerManager_All._selectedWorker)
      PaGlobal_WorkerManager_All:setRightPanelInfo(PaGlobal_WorkerManager_All._selectedWorker)
    end
    btn_WorkRestore:SetShow(true)
    checkBox_Worker:SetShow(true)
    btn_RepeatWork:SetShow(true)
    btn_WorkRestore:addInputEvent("Mouse_On", "PaGlobalFunc_WorkerManager_All_ButtonSimpleToolTip( true, \"" .. tostring(key) .. "\", 0 )")
    btn_WorkRestore:addInputEvent("Mouse_Out", "PaGlobalFunc_WorkerManager_All_ButtonSimpleToolTip( false, \"" .. tostring(key) .. "\", 0 )")
    btn_WorkRestore:addInputEvent("Mouse_LUp", "HandleClicked_WorkerManager_All_RestoreWorker( \"" .. tostring(key) .. "\")")
    btn_ButtonBg:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_SetRightPanelInfo(\"" .. tostring(key) .. "\")")
    checkBox_Worker:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_SetWorkerCheck(\"" .. tostring(key) .. "\")")
    local workingState = workerWrapperLua:getWorkingType()
    if CppEnums.NpcWorkingType.eNpcWorkingType_Count == workingState then
      btn_Stop:SetShow(false)
      btn_RepeatWork:SetShow(true)
      btn_RepeatWork:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_WorkerRepeat(\"" .. tostring(key) .. "\")")
      btn_RepeatWork:addInputEvent("Mouse_On", "PaGlobalFunc_WorkerManager_All_ButtonSimpleToolTip( true, \"" .. tostring(key) .. "\", 1 )")
      btn_RepeatWork:addInputEvent("Mouse_Out", "PaGlobalFunc_WorkerManager_All_ButtonSimpleToolTip( false, \"" .. tostring(key) .. "\", 1 )")
    else
      btn_RepeatWork:SetShow(false)
      btn_Stop:SetShow(true)
      btn_Stop:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorkerManager_All_WorkerStop(\"" .. tostring(key) .. "\")")
      btn_Stop:addInputEvent("Mouse_On", "PaGlobalFunc_WorkerManager_All_ButtonSimpleToolTip( true, \"" .. tostring(key) .. "\", 2 )")
      btn_Stop:addInputEvent("Mouse_Out", "PaGlobalFunc_WorkerManager_All_ButtonSimpleToolTip( false, \"" .. tostring(key) .. "\", 2 )")
    end
    btn_ButtonBg:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_WorkerManager_All_ScrollEvent()")
    btn_ButtonBg:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_WorkerManager_All_ScrollEvent()")
    stc_WorkerTitle:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_WorkerManager_All_ScrollEvent()")
    stc_WorkerTitle:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_WorkerManager_All_ScrollEvent()")
    stc_Town:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_WorkerManager_All_ScrollEvent()")
    stc_Town:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_WorkerManager_All_ScrollEvent()")
    stc_RemainTimeProgressBg:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_WorkerManager_All_ScrollEvent()")
    stc_RemainTimeProgressBg:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_WorkerManager_All_ScrollEvent()")
    progress_RemainTimeProgress:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_WorkerManager_All_ScrollEvent()")
    progress_RemainTimeProgress:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_WorkerManager_All_ScrollEvent()")
    stc_WorkerImage:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_WorkerManager_All_ScrollEvent()")
    stc_WorkerImage:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_WorkerManager_All_ScrollEvent()")
  end
end
function PaGlobalFunc_WorkerManager_All_ScrollEvent()
  if PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:GetShow() then
    HandleClicked_WorkerManager_All_RestoreItemClose()
  end
  PaGlobal_WorkerManager_All:updateRestoreItem()
end
function PaGlobalFunc_WorkerManager_All_SetWorkerCheck(workerNoRaw)
  PaGlobal_WorkerManager_All._workerCheckList[workerNoRaw] = not PaGlobal_WorkerManager_All._workerCheckList[workerNoRaw]
  PaGlobal_WorkerManager_All:update()
end
function PaGlobal_WorkerManager_All:updateListData()
  PaGlobal_WorkerManager_All._commonUI.list_Worker:changeAnimationSpeed(10)
  PaGlobal_WorkerManager_All._commonUI.list_Worker:getElementManager():clearKey()
  local plantArray = Array.new()
  local plantConut = ToCleint_getHomePlantKeyListCount()
  for plantIdx = 0, plantConut - 1 do
    local plantKeyRaw = ToCleint_getHomePlantKeyListByIndex(plantIdx)
    local plantKey = PlantKey()
    plantKey:setRaw(plantKeyRaw)
    plantArray:push_back(plantKey)
  end
  if PaGlobal_WorkerManager_All._config._workerTownString[0] == PaGlobal_WorkerManager_All._filterTown then
    local plantSort_do = function(a, b)
      return a:get() < b:get()
    end
    table.sort(plantArray, plantSort_do)
  end
  local townTable = {}
  local gradeSort_do = function(a, b)
    return a._grade < b._grade
  end
  PaGlobal_WorkerManager_All._townList = {}
  PaGlobal_WorkerManager_All._gradeList = {}
  local townIndex = 1
  for plantRawIdx = 1, #plantArray do
    local plantKey = plantArray[plantRawIdx]
    local plantWorkerCount = ToClient_getPlantWaitWorkerListCount(plantKey, 0)
    local workerArray = Array.new()
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
        if nil == PaGlobal_WorkerManager_All._gradeList[worker_Grade] then
          PaGlobal_WorkerManager_All._gradeList[worker_Grade] = PaGlobal_WorkerManager_All._config._workerGradeString[worker_Grade]
        end
        if nil == PaGlobal_WorkerManager_All._townList[plantRawIdx] then
          PaGlobal_WorkerManager_All._townList[plantRawIdx] = townName
        end
        if nil ~= worker_Grade and (PaGlobal_WorkerManager_All._config._workerGradeString[worker_Grade] == PaGlobal_WorkerManager_All._filterGrade or PaGlobal_WorkerManager_All._config._workerGradeString[5] == PaGlobal_WorkerManager_All._filterGrade) and (PaGlobal_WorkerManager_All._config._workerTownString[0] == PaGlobal_WorkerManager_All._filterTown or townName == PaGlobal_WorkerManager_All._filterTown) then
          local workerInfo = {}
          workerInfo._workerNoRaw = workerNoRaw
          workerInfo._grade = worker_Grade
          workerArray:push_back(workerInfo)
        end
      end
    end
    townTable[plantRawIdx] = workerArray
  end
  local workerCount = 0
  for _, workerArray in pairs(townTable) do
    for townIndex = 1, #workerArray do
      local workerInfo = workerArray[townIndex]
      PaGlobal_WorkerManager_All._commonUI.list_Worker:getElementManager():pushKey(workerInfo._workerNoRaw)
      PaGlobal_WorkerManager_All._workerList[workerCount] = workerInfo._workerNoRaw
      if nil == PaGlobal_WorkerManager_All._workerCheckList[tostring(workerInfo._workerNoRaw)] then
        PaGlobal_WorkerManager_All._workerCheckList[tostring(workerInfo._workerNoRaw)] = false
      end
      workerCount = workerCount + 1
    end
  end
  PaGlobal_WorkerManager_All._workerCount = workerCount
  if workerCount <= 0 then
    PaGlobal_WorkerManager_All._selectedWorker = nil
  end
  PaGlobal_WorkerManager_All._townList[-1] = PaGlobal_WorkerManager_All._config._workerTownString[0]
  PaGlobal_WorkerManager_All._gradeList[-1] = PaGlobal_WorkerManager_All._config._workerGradeString[0]
end
function PaGlobal_WorkerManager_All:fireWorker()
  local do_CheckedWorker_Fire = function()
    local workerNo_64 = tonumber64(PaGlobal_WorkerManager_All._selectedWorker)
    ToClient_requestDeleteMyWorker(WorkerNo(workerNo_64))
    PaGlobal_WorkerManager_All:updateListData()
    if tostring(PaGlobal_WorkerManager_All._workerList[0]) == PaGlobal_WorkerManager_All._selectedWorker then
      PaGlobal_WorkerManager_All._selectedWorker = tostring(PaGlobal_WorkerManager_All._workerList[1])
    else
      PaGlobal_WorkerManager_All._selectedWorker = tostring(PaGlobal_WorkerManager_All._workerList[0])
    end
    if true == _ContentsGroup_isConsolePadControl then
      _AudioPostEvent_SystemUiForXBOX(50, 1)
      PaGlobal_WorkerManager_All:selectWorker(PaGlobal_WorkerManager_All._selectedWorker)
    else
      PaGlobal_WorkerManager_All._workerCheckList = {}
      PaGlobal_WorkerManager_All:selectWorkerPC(PaGlobal_WorkerManager_All._selectedWorker)
      PaGlobal_WorkerManager_All:setRightPanelInfo(PaGlobal_WorkerManager_All._selectedWorker)
    end
    PaGlobal_WorkerManager_All:update()
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
function PaGlobal_WorkerManager_All:updateRestoreItem()
  for itemIdx = 0, PaGlobal_WorkerManager_All._restoreItemMaxCount - 1 do
    local slot = PaGlobal_WorkerManager_All._restoreItemSlot[itemIdx]
    slot.slotBG:SetShow(false)
    slot.slotIcon:addInputEvent("Mouse_RUp", "")
  end
  PaGlobal_WorkerManager_All._restoreItemHasCount = ToClient_getNpcRecoveryItemList()
  if 0 >= PaGlobal_WorkerManager_All._restoreItemHasCount then
    PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:SetShow(false)
  end
  local uiIdx = 0
  for itemIdx = PaGlobal_WorkerManager_All._sliderStartIdx, PaGlobal_WorkerManager_All._restoreItemHasCount - 1 do
    if uiIdx >= PaGlobal_WorkerManager_All._restoreItemMaxCount then
      break
    end
    local slot = PaGlobal_WorkerManager_All._restoreItemSlot[uiIdx]
    slot.slotBG:SetShow(true)
    local recoveryItem = ToClient_getNpcRecoveryItemByIndex(itemIdx)
    local itemStatic = recoveryItem:getItemStaticStatus()
    slot.slotIcon:ChangeTextureInfoName("icon/" .. getItemIconPath(itemStatic))
    slot.itemCount:SetText(tostring(recoveryItem._itemCount_s64))
    slot.restorePoint:SetText("+" .. tostring(recoveryItem._contentsEventParam1))
    slot.slotIcon:addInputEvent("Mouse_RUp", "HandleClicked_WorkerManager_All_RestoreItem( " .. itemIdx .. " )")
    uiIdx = uiIdx + 1
  end
  if PaGlobal_WorkerManager_All._restoreItemMaxCount < PaGlobal_WorkerManager_All._restoreItemHasCount then
    PaGlobal_WorkerManager_All._commonUI.slider_RestoreSlider:SetShow(true)
    local sliderSize = PaGlobal_WorkerManager_All._commonUI.slider_RestoreSlider:GetSizeX()
    local targetPercent = PaGlobal_WorkerManager_All._restoreItemMaxCount / PaGlobal_WorkerManager_All._restoreItemHasCount * 100
    local sliderBtnSize = sliderSize * (targetPercent / 100)
    PaGlobal_WorkerManager_All._commonUI.btn_SliderBtn:SetSize(sliderBtnSize, PaGlobal_WorkerManager_All._commonUI.btn_SliderBtn:GetSizeY())
    PaGlobal_WorkerManager_All._commonUI.slider_RestoreSlider:SetInterval(PaGlobal_WorkerManager_All._restoreItemHasCount - PaGlobal_WorkerManager_All._restoreItemMaxCount)
    PaGlobal_WorkerManager_All._commonUI.btn_SliderBtn:addInputEvent("Mouse_LPress", "HandleLPress_WorkerManager_All_RestoreItemSlider()")
    PaGlobal_WorkerManager_All._commonUI.slider_RestoreSlider:addInputEvent("Mouse_LUp", "HandleLPress_WorkerManager_All_RestoreItemSlider()")
  else
    PaGlobal_WorkerManager_All._commonUI.slider_RestoreSlider:SetShow(false)
  end
end
function PaGlobalFunc_WorkerManager_All_sliderScroll(isUp)
  if true == isUp then
    if PaGlobal_WorkerManager_All._sliderStartIdx <= 0 then
      PaGlobal_WorkerManager_All._sliderStartIdx = 0
      return
    end
    PaGlobal_WorkerManager_All._sliderStartIdx = PaGlobal_WorkerManager_All._sliderStartIdx - 1
  else
    if PaGlobal_WorkerManager_All._restoreItemHasCount <= PaGlobal_WorkerManager_All._sliderStartIdx + PaGlobal_WorkerManager_All._restoreItemMaxCount then
      return
    end
    PaGlobal_WorkerManager_All._sliderStartIdx = PaGlobal_WorkerManager_All._sliderStartIdx + 1
  end
  local currentPos = PaGlobal_WorkerManager_All._sliderStartIdx / (PaGlobal_WorkerManager_All._restoreItemHasCount - PaGlobal_WorkerManager_All._restoreItemMaxCount) * 100
  if currentPos > 100 then
    currentPos = 100
  elseif currentPos < 0 then
    currentPos = 0
  end
  PaGlobal_WorkerManager_All._commonUI.slider_RestoreSlider:SetControlPos(currentPos)
  PaGlobal_WorkerManager_All:updateRestoreItem()
end
function HandleLPress_WorkerManager_All_RestoreItemSlider()
  local pos = PaGlobal_WorkerManager_All._commonUI.slider_RestoreSlider:GetControlPos()
  local posIdx = math.floor((PaGlobal_WorkerManager_All._restoreItemHasCount - PaGlobal_WorkerManager_All._restoreItemMaxCount) * pos)
  if posIdx > PaGlobal_WorkerManager_All._restoreItemHasCount - PaGlobal_WorkerManager_All._restoreItemMaxCount then
    return
  end
  PaGlobal_WorkerManager_All._sliderStartIdx = posIdx
  local currentPos = PaGlobal_WorkerManager_All._sliderStartIdx / (PaGlobal_WorkerManager_All._restoreItemHasCount - PaGlobal_WorkerManager_All._restoreItemMaxCount) * 100
  if currentPos > 100 then
    currentPos = 100
  elseif currentPos < 0 then
    currentPos = 0
  end
  PaGlobal_WorkerManager_All._commonUI.slider_RestoreSlider:SetControlPos(currentPos)
  PaGlobal_WorkerManager_All:updateRestoreItem()
end
function HandleClicked_WorkerManager_All_RestoreWorker(key)
  local list = PaGlobal_WorkerManager_All._commonUI.list_Worker
  local contents = list:GetContentByKey(tonumber64(key))
  if nil == contents then
    return
  end
  PaGlobal_WorkerManager_All._selectedRestoreWorkerIdx = key
  local slotBg = UI.getChildControl(contents, "Button_ButtonBg")
  local btnRestore = UI.getChildControl(contents, "Button_WorkRestore")
  local restoreItemCount = ToClient_getNpcRecoveryItemList()
  local workerWrapperLua = getWorkerWrapper(tonumber64(key), false)
  if nil == workerWrapperLua then
    return
  end
  local actionPointPer = workerWrapperLua:getActionPointPercents()
  if restoreItemCount <= 0 then
    Proc_ShowMessage_Ack_With_ChatType(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_NOITEM"), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
    return
  elseif 100 == actionPointPer then
    Proc_ShowMessage_Ack_With_ChatType(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE_MAX"), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
    return
  end
  local bgSizeX = PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:GetSizeX()
  local textSizeX = PaGlobal_WorkerManager_All._commonUI.stc_GuideRestoreAll:GetTextSizeX() + 30
  if bgSizeX < textSizeX then
    PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:SetSize(PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:GetSizeX() + (textSizeX - bgSizeX), PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:GetSizeY())
    PaGlobal_WorkerManager_All._commonUI.btn_RestoreItemClose:SetSpanSize(5, 5)
  end
  PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:SetShow(true)
  PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:SetPosX(btnRestore:GetPosX() - PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:GetSizeX() * 0.97)
  PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:SetPosY(getMousePosY() - 27)
  PaGlobal_WorkerManager_All._commonUI.btn_RestoreItemClose:SetShow(true)
  PaGlobal_WorkerManager_All._commonUI.stc_GuideRestoreAll:SetShow(true)
  PaGlobal_WorkerManager_All:updateRestoreItem()
end
function HandleClicked_WorkerManager_All_RestoreItem(itemIdx)
  local workerIndex = PaGlobal_WorkerManager_All._selectedRestoreWorkerIdx
  local workerWrapperLua = getWorkerWrapper(tonumber64(workerIndex), false)
  if nil == workerWrapperLua then
    return
  end
  local workerNoRaw = tonumber64(workerIndex)
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
      end
      return
    end
    restoreWorkerNo = workerNo
    requestRecoveryWorker(WorkerNo(workerNo), slotNo, 1)
  end
end
function HandleClicked_WorkerManager_All_RestoreItemClose()
  if nil == Panel_Window_WorkerManager_All then
    return
  end
  PaGlobal_WorkerManager_All._commonUI.stc_RestoreItemBG:SetShow(false)
end
function PaGlobal_WorkerManager_All:fireWorkerChecked()
  local do_CheckedWorker_Fire = function()
    local unCheckedWorkerNo
    for idx = 0, PaGlobal_WorkerManager_All._workerCount - 1 do
      local workerNo_64 = PaGlobal_WorkerManager_All._workerList[idx]
      if true == PaGlobal_WorkerManager_All._workerCheckList[tostring(workerNo_64)] then
        ToClient_requestDeleteMyWorker(WorkerNo(workerNo_64))
        if nil == unCheckedWorkerNo then
          local workerWrapperLua = getWorkerWrapper(workerNo_64)
          if nil == workerWrapperLua then
            return
          end
          local workingState = workerWrapperLua:getWorkingType()
          if CppEnums.NpcWorkingType.eNpcWorkingType_Count ~= workingState then
            unCheckedWorkerNo = tostring(workerNo_64)
          end
        end
      elseif nil == unCheckedWorkerNo then
        unCheckedWorkerNo = tostring(workerNo_64)
      end
    end
    if Panel_WorkerRestoreAll:GetShow() then
      workerRestoreAll_Close()
    end
    PaGlobal_WorkerManager_All:updateListData()
    PaGlobal_WorkerManager_All._selectedWorker = unCheckedWorkerNo
    PaGlobal_WorkerManager_All:update()
    PaGlobal_WorkerManager_All:selectWorkerPC(PaGlobal_WorkerManager_All._selectedWorker)
    PaGlobal_WorkerManager_All:setRightPanelInfo(PaGlobal_WorkerManager_All._selectedWorker)
  end
  local checkCount = 0
  for idx = 0, PaGlobal_WorkerManager_All._workerCount - 1 do
    local workerNo_64 = PaGlobal_WorkerManager_All._workerList[idx]
    if true == PaGlobal_WorkerManager_All._workerCheckList[tostring(workerNo_64)] then
      checkCount = checkCount + 1
    end
  end
  if 0 == checkCount then
    Proc_ShowMessage_Ack_With_ChatType(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_FIREWORKERSELECT"), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
    return
  end
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
  local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_FIREWORKERDESC", "count", checkCount)
  local messageboxData = {
    title = messageTitle,
    content = messageContent,
    functionYes = do_CheckedWorker_Fire,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "middle")
end
function PaGlobal_WorkerManager_All:workerRestore(isRestoreAll)
  if PaGlobal_WorkerManager_All._workerCount <= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
    return
  end
  PaGlobalFunc_WorkerManager_Restore_Open(isRestoreAll)
end
function PaGlobal_WorkerManager_All:workerRestoreAllPC()
  local restoreItemCount = ToClient_getNpcRecoveryItemList()
  if restoreItemCount <= 0 then
    Proc_ShowMessage_Ack_With_ChatType(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_NOITEM"), nil, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
    return
  end
  FGlobal_WorkerRestoreAll_Open(PaGlobal_WorkerManager_All._workerCount, PaGlobal_WorkerManager_All._workerList)
end
function PaGlobal_WorkerManager_All:workerRepeat(workerNoRaw)
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
      PaGlobal_WorkerManager_All:update()
    elseif currentActionPoint > 0 then
      ToClient_requestRepeatWork(WorkerNo(workerNoRaw), currentActionPoint)
    end
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX_WORKERMANAGER_CANTREPEAT_WORK"))
  end
end
function PaGlobal_WorkerManager_All:workerRepeatAll()
  for index = 0, PaGlobal_WorkerManager_All._workerCount - 1 do
    local workerNoRaw = PaGlobal_WorkerManager_All._workerList[index]
    if nil == workerNoRaw then
      break
    end
    PaGlobal_WorkerManager_All:workerRepeat(workerNoRaw)
  end
end
function PaGlobal_WorkerManager_All:clearWorkerRepeatInfo(workerNoRaw)
  local workerNoRaw = tonumber64(PaGlobal_WorkerManager_All._selectedWorker)
  local function doUnRepeatWork()
    ToClient_requestEraseRepeat(WorkerNo(workerNoRaw))
    PaGlobal_WorkerManager_All:update()
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
function PaGlobal_WorkerManager_All:workerStop(workerNoRawStr)
  local workerNoRaw
  if nil == workerNoRawStr then
    workerNoRaw = tonumber64(PaGlobal_WorkerManager_All._selectedWorker)
  else
    workerNoRaw = workerNoRawStr
  end
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
function PaGlobal_WorkerManager_All:upgradeWorker()
  local workerWrapperLua = getWorkerWrapper(tonumber64(PaGlobal_WorkerManager_All._selectedWorker))
  local function do_Upgrade_Worker()
    workerWrapperLua:requestUpgrade()
    PaGlobal_WorkerManager_All:setRightPanelInfo(PaGlobal_WorkerManager_All._selectedWorker)
    PaGlobal_WorkerManager_All:update()
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
function PaGlobal_WorkerManager_All:resetUpgradeCount()
  local workerNoRaw = tonumber64(PaGlobal_WorkerManager_All._selectedWorker)
  local workerWrapperLua = getWorkerWrapper(workerNoRaw)
  local workerUpgradeCount = workerWrapperLua:getUpgradePoint()
  local worker_Lev = workerWrapperLua:getLevel()
  local maxUpgradePoint = math.floor(worker_Lev / 10)
  local upgradableCount = maxUpgradePoint - workerUpgradeCount
  local worker_Name = workerWrapperLua:getName()
  local function doReset()
    ToClient_requestClearWorkerUpgradePoint(workerNoRaw)
    PaGlobal_WorkerManager_All:setRightPanelInfo(PaGlobal_WorkerManager_All._selectedWorker)
    PaGlobal_WorkerManager_All:update()
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
function PaGlobal_WorkerManager_All:upgradeNow()
  local workerNoRaw = tonumber64(PaGlobal_WorkerManager_All._selectedWorker)
  local remainTimeInt = ToClient_getWorkingTime(workerNoRaw)
  local needPearl = ToClient_GetUsingPearlByRemainingPearl(CppEnums.InstantCashType.eInstant_CompleteNpcWorkerUpgrade, remainTimeInt)
  local function doUpgradeNow()
    ToClient_requestQuickComplete(WorkerNo(workerNoRaw), needPearl)
    PaGlobal_WorkerManager_All:setRightPanelInfo(PaGlobal_WorkerManager_All._selectedWorker)
    PaGlobal_WorkerManager_All:update()
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
function PaGlobal_WorkerManager_All:workerChangeSkill()
  if true == _ContentsGroup_isConsolePadControl then
    PaGlobalFunc_WorkerManager_ChangeSkill_Open()
  else
    workerChangeSkill_Open(PaGlobal_WorkerManager_All._selectedWorker)
  end
end
function PaGlobal_WorkerManager_All:workerDataUpdateHeadingPlant(ExplorationNode, workerNo)
  local workType = PaGlobal_WorkerManager_All._config._workType
  if 0 ~= Int64toInt32(workerNo) and false == ExplorationNode:getStaticStatus():getRegion():isMainOrMinorTown() then
    PaGlobalFunc_WorkerManager_All_PushWorkStartMessage(workerNo, workType._PlantWork)
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
  PaGlobal_WorkerManager_All:update()
end
function PaGlobal_WorkerManager_All:workerDataUpdateHeadingHouse(rentHouseWrapper, workerNo)
  local workType = PaGlobal_WorkerManager_All._config._workType
  if 0 ~= Int64toInt32(workerNo) then
    local UseGroupType = rentHouseWrapper:getHouseUseType()
    if UseGroupType == 12 or UseGroupType == 13 or UseGroupType == 14 then
      PaGlobalFunc_WorkerManager_All_PushWorkStartMessage(workerNo, workType._LargeCraft)
    else
      PaGlobalFunc_WorkerManager_All_PushWorkStartMessage(workerNo, workType._HouseCraft)
    end
  end
  if plantKey == nil then
    return
  end
  local houseInfoSS = rentHouseWrapper:getStaticStatus():get()
  local affiliatedTownKey = ToClient_getHouseAffiliatedWaypointKey(houseInfoSS)
  PaGlobal_WorkerManager_All:update()
end
function PaGlobal_WorkerManager_All:workerDataUpdateHeadingBuilding(buildingInfoSS, workerNo)
  local workType = PaGlobal_WorkerManager_All._config._workType
  if 0 ~= Int64toInt32(workerNo) then
    PaGlobalFunc_WorkerManager_All_PushWorkStartMessage(workerNo, workType._Building, buildingInfoSS)
  end
  if plantKey == nil then
    return
  end
  local affiliatedTownKey = ToClient_getBuildingAffiliatedWaypointKey(buildingInfoSS)
  PaGlobal_WorkerManager_All:update()
end
function PaGlobal_WorkerManager_All:workerDataUpdateHeadingRegionManaging(regionGroupInfo, workerNo)
  local workType = PaGlobal_WorkerManager_All._config._workType
  if 0 ~= Int64toInt32(workerNo) then
    PaGlobalFunc_WorkerManager_All_PushWorkStartMessage(workerNo, workType._RegionWork)
  end
  PaGlobal_WorkerManager_All:update()
end
function PaGlobal_WorkerManager_All:pushStartMessage(workerNo, _workType, buildingInfoSS)
  local workType = self._config._workType
  if _workType == workType._HouseCraft then
    local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
    if nil == esSSW then
      return
    end
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
function PaGlobal_WorkerManager_All:perFrameUpdate(deltaTime)
  PaGlobal_WorkerManager_All._elapsedTime = PaGlobal_WorkerManager_All._elapsedTime + deltaTime
  if PaGlobal_WorkerManager_All._elapsedTime > 1 then
    PaGlobal_WorkerManager_All:update()
    PaGlobal_WorkerManager_All._elapsedTime = 0
  end
end
function PaGlobal_WorkerManager_All:setSelectButton(control)
  PaGlobal_WorkerManager_All._consoleUI.keyGuide.buttonA:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_WORLDMAP_GUILDHOUSE_CHANGEWORKER_SELECTBTN"))
end

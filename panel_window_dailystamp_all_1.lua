function PaGlobal_DailyStamp_All:initialize()
  if true == PaGlobal_DailyStamp_All._initialize then
    return
  end
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  self._dayControl = {}
  self._tabControl = {}
  self._prevAttendanceCount = {}
  self:initValue()
  self:controlAll_Init()
  self:controlPc_Init()
  self:controlConsole_Init()
  self:controlSetShow()
  self:tabInit()
  self:dailyInit()
  self:descInit()
  PaGlobal_DailyStamp_All:registEventHandler()
  PaGlobal_DailyStamp_All:validate()
  PaGlobal_DailyStamp_All._initialize = true
end
function PaGlobal_DailyStamp_All:initValue()
  self._dailyStampCount = ToClient_GetAttendanceInfoCount()
  self._yesterdayTabCount = self._dailyStampCount
  self._dailyStampKeys = Array.new()
  for index = 1, self._dailyStampCount do
    local attendanceSS = ToClient_GetAttendanceInfoWrapper(index - 1)
    self._dailyStampKeys[index] = {
      attendanceSS,
      attendanceSS:getDisplayOrder(),
      false
    }
    if nil ~= self._dailyStampKeys[index][1] and false == self._dailyStampKeys[index][1]:isPossibleOverlapAttendance() and false == self._dailyStampKeys[index][1]:isPossibleAttendance() then
      self._dailyStampKeys[index][3] = true
    end
  end
  if self._dailyStampCount > 1 then
    table.sort(self._dailyStampKeys, PaGlobalFunc_DailyStamp_All_TabSort)
  end
end
function PaGlobal_DailyStamp_All:controlAll_Init()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  Panel_Window_DailyStamp_All:SetShow(false, false)
  Panel_Window_DailyStamp_All:ActiveMouseEventEffect(true)
  Panel_Window_DailyStamp_All:setGlassBackground(true)
  self._ui.stc_mainTitleBg = UI.getChildControl(Panel_Window_DailyStamp_All, "StaticText_MainTitle")
  self._ui.stc_centerBg = UI.getChildControl(Panel_Window_DailyStamp_All, "Static_CenterBG")
  self._ui.stc_tabBar = UI.getChildControl(Panel_Window_DailyStamp_All, "Static_TabBtnBar")
  self._ui.stc_buttonGroup = UI.getChildControl(self._ui.stc_centerBg, "Static_ButtonGroup")
  self._ui.stc_buttonSlot = UI.getChildControl(self._ui.stc_buttonGroup, "Button_RewardSlot")
  self._ui.txt_day = UI.getChildControl(self._ui.stc_buttonSlot, "StaticText_Day")
  self._ui.stc_iconBG = UI.getChildControl(self._ui.stc_buttonSlot, "Static_RewardIconBG")
  self._ui.stc_stamp = UI.getChildControl(self._ui.stc_buttonSlot, "Static_Stamp")
  self._ui.stc_bottomBg = UI.getChildControl(Panel_Window_DailyStamp_All, "Static_BottomBG")
  self._ui.txt_eventPeriod = UI.getChildControl(self._ui.stc_bottomBg, "StaticText_EventPeriod")
  self._ui.txt_acceptPeriod = UI.getChildControl(self._ui.stc_bottomBg, "StaticText_RewardAcceptPeriod")
  self._ui.txt_eventAlert = UI.getChildControl(self._ui.stc_bottomBg, "StaticText_EventPeriodAlert")
  self._ui.txt_weekEndDesc = UI.getChildControl(self._ui.stc_bottomBg, "StaticText_WeekEndDesc")
end
function PaGlobal_DailyStamp_All:controlPc_Init()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  self._ui_pc.btn_close = UI.getChildControl(self._ui.stc_mainTitleBg, "Button_Win_Close_PCUI")
  self._ui.stc_topBg = UI.getChildControl(Panel_Window_DailyStamp_All, "Static_TopBG_PCUI")
  self._ui_pc.btn_tabTitle = UI.getChildControl(self._ui.stc_topBg, "RadioButton_Tab_PCUI")
end
function PaGlobal_DailyStamp_All:controlConsole_Init()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  self._ui_console.stc_topBg = UI.getChildControl(Panel_Window_DailyStamp_All, "Static_TopBG_ConsoleUI")
  self._ui_console.stc_tabTitle = UI.getChildControl(self._ui_console.stc_topBg, "StaticText_TabTitle")
  self._ui_console.stc_iconLB = UI.getChildControl(self._ui_console.stc_topBg, "Static_LB")
  self._ui_console.stc_iconRB = UI.getChildControl(self._ui_console.stc_topBg, "Static_RB")
  self._ui_console.stc_keyGuideBg = UI.getChildControl(Panel_Window_DailyStamp_All, "Static_KeyGuideBG_ConsoleUI")
  self._ui_console.stc_guideA = UI.getChildControl(self._ui_console.stc_keyGuideBg, "StaticText_KeyGuideA")
  self._ui_console.stc_guideX = UI.getChildControl(self._ui_console.stc_keyGuideBg, "StaticText_KeyGuideDetail")
  self._ui_console.stc_guideB = UI.getChildControl(self._ui_console.stc_keyGuideBg, "StaticText_KeyGuideB")
end
function PaGlobal_DailyStamp_All:controlSetShow()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if false == ToClient_isConsole() then
    self._ui_pc.btn_close:SetShow(true)
    self._ui_pc.btn_tabTitle:SetShow(false)
    self._ui_console.stc_topBg:SetShow(false)
    self._ui_console.stc_keyGuideBg:SetShow(false)
  else
    self._ui_pc.btn_close:SetShow(false)
    self._ui_pc.btn_tabTitle:SetShow(false)
    self._ui_console.stc_topBg:SetShow(true)
    self._ui_console.stc_keyGuideBg:SetShow(true)
  end
end
function PaGlobal_DailyStamp_All:tabInit()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if true == ToClient_isConsole() then
    PaGlobal_DailyStamp_All:consoleTabUpdate()
  else
    PaGlobal_DailyStamp_All:pcTabUpdate()
  end
end
function PaGlobal_DailyStamp_All:pcTabUpdate()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  local function tabControlSet(index)
    if nil == self._tabControl[index] then
      self._tabControl[index] = UI.cloneControl(self._ui_pc.btn_tabTitle, self._ui.stc_topBg, "RadioButton_Tab_PCUI_" .. index)
      self._tabControl[index]:SetShow(true)
    end
    local dailyStampTabName = ""
    if nil ~= self._dailyStampKeys[index][1] then
      dailyStampTabName = self._dailyStampKeys[index][1]:getName()
    end
    self._tabControl[index]:SetText(dailyStampTabName)
    self._tabControl[index]:SetPosX(self._tabTitlePosition[self._dailyStampCount][index])
    self._tabControl[index]:addInputEvent("Mouse_LUp", "HandleEventLUp_DailyStamp_All_TabClicked(" .. index .. ")")
    self._prevAttendanceCount[index] = nil
  end
  if self._dailyStampCount < self._yesterdayTabCount then
    for index = 1, self._yesterdayTabCount do
      if index < self._dailyStampCount then
        tabControlSet(index)
      elseif nil ~= self._tabControl[index] then
        self._tabControl[index]:SetShow(false)
      end
    end
    self._yesterdayTabCount = self._dailyStampCount
  else
    for index = 1, self._dailyStampCount do
      tabControlSet(index)
    end
  end
  self:dailyTabSort()
end
function PaGlobal_DailyStamp_All:consoleTabUpdate()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  self:initValue()
  if 1 == self._dailyStampCount then
    Panel_Window_DailyStamp_All:registerPadEvent(__eConsoleUIPadEvent_LB, "")
    Panel_Window_DailyStamp_All:registerPadEvent(__eConsoleUIPadEvent_RB, "")
    self._ui_console.stc_iconLB:SetShow(false)
    self._ui_console.stc_iconRB:SetShow(false)
  else
    Panel_Window_DailyStamp_All:registerPadEvent(__eConsoleUIPadEvent_LB, "PadEventLBRB_DailyStamp_All_SelectTab(-1)")
    Panel_Window_DailyStamp_All:registerPadEvent(__eConsoleUIPadEvent_RB, "PadEventLBRB_DailyStamp_All_SelectTab(1)")
    self._ui_console.stc_iconLB:SetShow(true)
    self._ui_console.stc_iconRB:SetShow(true)
  end
  self._ui_console.stc_tabTitle:SetShow(false)
  for index = 1, self._dailyStampCount do
    if nil == self._tabControl[index] then
      self._tabControl[index] = UI.cloneControl(self._ui_console.stc_tabTitle, self._ui_console.stc_topBg, "StaticText_TabTitle_" .. index)
      self._tabControl[index]:SetShow(true)
    end
    local dailyStampTabName = ""
    if nil ~= self._dailyStampKeys[index][1] then
      dailyStampTabName = self._dailyStampKeys[index][1]:getName()
    end
    self._tabControl[index]:SetText(dailyStampTabName)
    self._tabControl[index]:SetPosX(self._tabTitlePosition[self._dailyStampCount][index])
  end
end
function PaGlobal_DailyStamp_All:dailyInit()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  local gapX = 10
  local gapY = 10
  local basePosX = self._ui.stc_buttonSlot:GetPosX()
  local basePosY = self._ui.stc_buttonSlot:GetPosY()
  for index = 0, self._rewardCount - 1 do
    local temp = {}
    temp._dayControl = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, self._ui.stc_buttonGroup, "Button_RewardSlot_" .. index)
    CopyBaseProperty(self._ui.stc_buttonSlot, temp._dayControl)
    temp._dayControl:SetPosX(basePosX + (self._ui.stc_buttonSlot:GetSizeX() + gapX) * (index % 7))
    temp._dayControl:SetPosY(basePosY + (self._ui.stc_buttonSlot:GetSizeY() + gapY) * math.floor(index / 7))
    temp._dayText = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._dayControl, "StaticText_Day_" .. index)
    CopyBaseProperty(self._ui.txt_day, temp._dayText)
    temp._dayText:SetPosX(5)
    temp._dayText:SetPosY(5)
    temp._dayText:SetText(index + 1)
    temp._slotItemBg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, temp._dayControl, "Static_RewardIconBG_" .. index)
    CopyBaseProperty(self._ui.stc_iconBG, temp._slotItemBg)
    temp._slotItemBg:SetPosX(45)
    temp._slotItemBg:SetPosY(45)
    temp.slot = {}
    SlotItem.new(temp.slot, "DailyStamp_Reward_", index, temp._dayControl, self._slotConfig)
    temp.slot:createChild()
    temp.slot.icon:SetPosX(47)
    temp.slot.icon:SetPosY(47)
    temp.goodItemSlot = {}
    SlotItem.new(temp.goodItemSlot, "DailyStamp_GoodReward_", index, temp._dayControl, self._goodItemSlotConfig)
    temp.goodItemSlot:createChild()
    temp.goodItemSlot.icon:SetPosX(43)
    temp.goodItemSlot.icon:SetPosY(13)
    if isGameTypeEnglish() or isGameTypeRussia() then
      temp.goodItemSlot.icon:SetPosX(47)
      temp.goodItemSlot.icon:SetPosY(47)
    end
    temp._stamp = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, temp._dayControl, "Static_Stamp_" .. index)
    CopyBaseProperty(self._ui.stc_stamp, temp._stamp)
    temp._stamp:SetPosX(5)
    temp._stamp:SetPosY(5)
    temp._stamp:SetShow(false)
    if true == ToClient_isConsole() then
      temp._dayControl:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PadEventXUp_DailyStamp_All_ItemToolTipShow(true, " .. index + 1 .. ")")
    end
    self._dayControl[index] = temp
  end
  self._ui.stc_buttonSlot:SetShow(false)
  self._ui.txt_day:SetShow(false)
  self._ui.stc_stamp:SetShow(false)
  self._eventPeriodTxt = self._ui.txt_eventPeriod:GetText()
  self._acceptPeriodTxt = self._ui.txt_acceptPeriod:GetText()
end
function PaGlobal_DailyStamp_All:descInit()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  self._ui.txt_eventPeriod:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_acceptPeriod:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_eventAlert:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_weekEndDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_eventPeriod:SetText(self._ui.txt_eventPeriod:GetText())
  self._ui.txt_acceptPeriod:SetText(self._ui.txt_acceptPeriod:GetText())
  self._ui.txt_eventAlert:SetText(self._ui.txt_eventAlert:GetText())
  self._ui.txt_weekEndDesc:SetText(self._ui.txt_weekEndDesc:GetText())
  if self._ui.txt_eventAlert:GetPosY() + self._ui.txt_eventAlert:GetTextSizeY() + 5 > self._ui.txt_weekEndDesc:GetPosY() then
    self._ui.txt_weekEndDesc:SetPosY(self._ui.txt_eventAlert:GetPosY() + self._ui.txt_eventAlert:GetTextSizeY() + 5)
  else
    self._ui.txt_eventAlert:ComputePos()
    self._ui.txt_weekEndDesc:ComputePos()
  end
  if self._ui.txt_eventAlert:GetTextSizeY() > 20 or self._ui.txt_weekEndDesc:GetTextSizeY() > 20 then
    local plusGapY = self._ui.txt_eventAlert:GetTextSizeY() - 20 + (self._ui.txt_weekEndDesc:GetTextSizeY() - 20)
    local panelOriginY = 806
    Panel_Window_DailyStamp_All:SetSize(Panel_Window_DailyStamp_All:GetSizeX(), panelOriginY + plusGapY)
    self._ui.stc_bottomBg:ComputePos()
  end
  self._goodItemSlotConfig.createBorder = true
end
function PaGlobal_DailyStamp_All:prepareOpen()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if false == _ContentsGroup_DailyStamp then
    return
  end
  if false == _ContentsGroup_NewUI_DailyStamp_All then
    return
  end
  if nil ~= PaGlobalFunc_DailyChallenge_GetShow and true == PaGlobalFunc_DailyChallenge_GetShow() then
    return
  end
  local currentCount = ToClient_GetAttendanceInfoCount()
  if self._dailyStampCount ~= currentCount then
    self._dailyStampCount = currentCount
    self._dailyStampKeys = Array.new()
    for index = 1, self._dailyStampCount do
      local attendanceSS = ToClient_GetAttendanceInfoWrapper(index - 1)
      self._dailyStampKeys = {
        attendanceSS,
        attendanceSS:getDisplayOrder(),
        false
      }
      if nil ~= self._dailyStampKeys[index][1] and false == self._dailyStampKeys[index][1]:isPossibleOverlapAttendance() and false == self._dailyStampKeys[index][1]:isPossibleAttendance() then
        self._dailyStampKeys[index][3] = true
      end
    end
    self:tabInit()
  end
  if self._dailyStampCount <= 0 then
    PcRoomNotify_FirstUsePearl_Open()
    return
  end
  if nil ~= Panel_LevelupGuide and true == Panel_LevelupGuide:GetShow() then
    FGlobal_LevelupGuide_PowerClose()
  end
  PaGlobal_DailyStamp_All:selectTab(self._firstTabIndex)
  PaGlobal_DailyStamp_All:setData(self._firstTabIndex)
  Panel_Window_DailyStamp_All:RegisterUpdateFunc("PaGlobalFunc_DailyStamp_All_StampAnimation")
  PaGlobal_DailyStamp_All:resize()
  PaGlobal_DailyStamp_All:open()
end
function PaGlobal_DailyStamp_All:open()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  Panel_Window_DailyStamp_All:SetShow(true)
end
function PaGlobal_DailyStamp_All:prepareClose()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  TooltipSimple_Hide()
  Panel_Tooltip_Item_hideTooltip()
  Panel_Window_DailyStamp_All:ClearUpdateLuaFunc()
  PaGlobal_DailyStamp_All:close()
end
function PaGlobal_DailyStamp_All:close()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  Panel_Window_DailyStamp_All:SetShow(false)
end
function PaGlobal_DailyStamp_All:resize()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  Panel_Window_DailyStamp_All:SetPosX(getScreenSizeX() / 2 - Panel_Window_DailyStamp_All:GetSizeX() / 2)
  Panel_Window_DailyStamp_All:SetPosY(getScreenSizeY() / 2 - Panel_Window_DailyStamp_All:GetSizeY() / 2)
  if false == ToClient_isConsole() then
    self._ui.stc_mainTitleBg:ComputePos()
    self._ui.stc_centerBg:ComputePos()
    self._ui.stc_bottomBg:ComputePos()
    self._ui_pc.btn_tabTitle:ComputePos()
  else
    self._ui_console.stc_topBg:ComputePos()
    self._ui_console.stc_keyGuideBg:ComputePos()
    self._ui_console.stc_guideA:SetShow(true)
    self._ui_console.stc_guideX:SetShow(true)
    self._ui_console.stc_guideB:SetShow(true)
    self._keyGuideAlign = {
      self._ui_console.stc_guideA,
      self._ui_console.stc_guideX,
      self._ui_console.stc_guideB
    }
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui_console.stc_keyGuideBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
    self._ui_console.stc_guideA:SetShow(false)
  end
end
function PaGlobal_DailyStamp_All:validate()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  self._ui.stc_mainTitleBg:isValidate()
  self._ui.stc_centerBg:isValidate()
  self._ui.stc_bottomBg:isValidate()
  self._ui.stc_buttonGroup:isValidate()
  self._ui.stc_buttonSlot:isValidate()
  self._ui.txt_day:isValidate()
  self._ui.stc_iconBG:isValidate()
  self._ui.stc_stamp:isValidate()
  self._ui.txt_eventPeriod:isValidate()
  self._ui.txt_acceptPeriod:isValidate()
  self._ui.txt_eventAlert:isValidate()
  self._ui.txt_weekEndDesc:isValidate()
  self._ui_pc.btn_close:isValidate()
  self._ui_pc.btn_tabTitle:isValidate()
  self._ui_console.stc_topBg:isValidate()
  self._ui_console.stc_tabTitle:isValidate()
  self._ui_console.stc_iconLB:isValidate()
  self._ui_console.stc_iconRB:isValidate()
  self._ui_console.stc_keyGuideBg:isValidate()
  self._ui_console.stc_guideB:isValidate()
  self._ui_console.stc_guideA:isValidate()
  self._ui_console.stc_guideX:isValidate()
end
function PaGlobal_DailyStamp_All:registEventHandler()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if false == ToClient_isConsole() then
    self._ui_pc.btn_close:addInputEvent("Mouse_LUp", "PaGlobalFunc_DailyStamp_All_Close()")
  else
  end
  registerEvent("FromClient_AttendanceUpdate", "FromClient_DailyStamp_All_AttendanceUpdate")
  registerEvent("FromClient_AttendanceUpdateAll", "FromClient_DailyStamp_All_AttendanceUpdateAll")
  registerEvent("FromClient_receiveAttendanceReward", "FromClient_DailyStamp_All_receiveAttendanceReward")
  registerEvent("selfPlayer_regionChanged", "FromClient_DailyStamp_All_regionCheck")
  registerEvent("FromClient_AttendanceTimer", "FromClient_DailyStamp_All_AttendanceTimer")
  registerEvent("onScreenResize", "FromClient_DailyStamp_All_onScreenResize")
  Panel_Window_DailyStamp_All:RegisterShowEventFunc(true, "PaGlobalFunc_DailyStamp_All_ShowAni()")
  Panel_Window_DailyStamp_All:RegisterShowEventFunc(false, "PaGlobalFunc_DailyStamp_All_HideAni()")
end
function PaGlobal_DailyStamp_All:acceptRewardAll(tabIndex)
  if nil == tabIndex then
    UI.ASSERT_NAME(nil ~= tabIndex, "PaGlobal_DailyStamp_All:acceptRewardAll tabIndex nil", "\236\160\149\236\167\128\237\152\156")
    return
  end
  local attendanceKey = self._dailyStampKeys[tabIndex][1]:getKey()
  local myAttendanceCount = ToClient_getAttendanceCount(attendanceKey)
  local receiveItemIndex = ToClient_getReceivedRewardCount(attendanceKey)
  if myAttendanceCount > receiveItemIndex then
    for index = receiveItemIndex, myAttendanceCount - 1 do
      ToClient_takeRewardItem(attendanceKey)
    end
  end
end
function PaGlobal_DailyStamp_All:selectTab(tabIndex)
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  for index = 1, self._dailyStampCount do
    if false == ToClient_isConsole() then
      self._tabControl[index]:SetCheck(false)
    end
    self._tabControl[index]:SetFontColor(Defines.Color.C_FF585453)
  end
  if false == ToClient_isConsole() then
    self._tabControl[tabIndex]:SetCheck(true)
  end
  self._tabControl[tabIndex]:SetFontColor(Defines.Color.C_FFFFEDD4)
end
function PaGlobalFunc_DailyStamp_All_TabSort(lhs, rhs)
  return lhs[2] > rhs[2]
end
function PaGlobal_DailyStamp_All:isPossibleAttandanceCheck()
  if nil == Panel_Window_DailyStamp_All then
    return false
  end
  if nil == self._dailyStampKeys[self._tabIndex][1] then
    return false
  end
  local waitingTime = -1
  local possibleAttendance = false
  if true == self._dailyStampKeys[self._tabIndex][1]:isPossibleAttendance() then
    waitingTime = ToClient_getWaitingTimeForAttendance()
    possibleAttendance = true
  end
  if true == self._dailyStampKeys[self._tabIndex][1]:isPossibleOverlapAttendance() then
    waitingTime = ToClient_getWaitingTimeForNextAttendance(self._dailyStampKeys[self._tabIndex][1]:getKey())
    possibleAttendance = true
  end
  if waitingTime < 0 then
    return false
  end
  if 0 == waitingTime then
    if not self._attendanceTimeCheck then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_TODAY_ATTENDANCE_POSSIBLE"))
      self._attendanceTimeCheck = true
      self:setData(self._tabIndex)
    end
  elseif true == self._attendanceTimeCheck then
    self._attendanceTimeCheck = false
    self:setData(self._tabIndex)
  end
  return self._attendanceTimeCheck
end
function PaGlobal_DailyStamp_All:setData(tabIndex)
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if nil == tabIndex then
    UI.ASSERT_NAME(nil ~= tabIndex, "PaGlobal_DailyStamp_All:setData tabIndex nil", "\236\160\149\236\167\128\237\152\156")
    return
  end
  if false == (tabIndex >= 1 and tabIndex <= self._dailyStampCount) then
    return
  end
  self._tabIndex = tabIndex
  self._ui.stc_tabBar:SetPosX(self._tabControl[tabIndex]:GetPosX() + self._tabControl[tabIndex]:GetSizeX() / 2 - self._ui.stc_tabBar:GetSizeX() / 2)
  if nil == self._dailyStampKeys[tabIndex] then
    return
  end
  local totalDayCount = self._dailyStampKeys[tabIndex][1]:getRewardCount()
  local attendanceKey = self._dailyStampKeys[tabIndex][1]:getKey()
  local myAttendanceCount = ToClient_getAttendanceCount(attendanceKey)
  local recieveCount = ToClient_getReceivedRewardCount(attendanceKey)
  local yesterdayRecieveCount = self._dailyStampKeys[tabIndex][1]:getAttendanceYesterdayCount()
  if nil == self._prevAttendanceCount[tabIndex] then
    self._prevAttendanceCount[tabIndex] = myAttendanceCount
  end
  self._secondAttendanceCheck = false
  for index = 0, self._rewardCount - 1 do
    if false == ToClient_isConsole() then
      self._dayControl[index]._dayControl:addInputEvent("Mouse_LUp", "")
      self._dayControl[index]._dayControl:addInputEvent("Mouse_RUp", "")
      self._dayControl[index]._dayControl:addInputEvent("Mouse_On", "")
      self._dayControl[index]._dayControl:addInputEvent("Mouse_Out", "")
      self._dayControl[index].slot.icon:addInputEvent("Mouse_LUp", "")
      self._dayControl[index].slot.icon:addInputEvent("Mouse_RUP", "")
      self._dayControl[index].goodItemSlot.icon:addInputEvent("Mouse_LUp", "")
      self._dayControl[index].goodItemSlot.icon:addInputEvent("Mouse_RUP", "")
    end
    self._dayControl[index]._dayControl:SetShow(false)
    self._dayControl[index]._dayControl:ResetVertexAni()
    self._dayControl[index]._dayControl:SetColor(Defines.Color.C_FFFFFFFF)
    self._dayControl[index].slot.icon:SetMonoTone(false)
    self._dayControl[index].slot.icon:SetShow(false)
    self._dayControl[index].goodItemSlot.icon:SetShow(false)
    self._dayControl[index].goodItemSlot.icon:SetMonoTone(false)
    self._dayControl[index]._stamp:SetShow(false)
    self._dayControl[index]._stamp:ResetVertexAni()
    self._dayControl[index]._stamp:SetSize(33, 33)
    self._dayControl[index]._stamp:SetPosX(60)
    self._dayControl[index]._stamp:SetPosY(20)
    self._dayControl[index]._dayText:SetShow(true)
    self._dayControl[index]._slotItemBg:SetShow(true)
  end
  self._animationdayIndex = {}
  for index = 0, totalDayCount - 1 do
    local itemGradeType = self._dailyStampKeys[tabIndex][1]:getRewardItemGradeType(index)
    local itemWrapper = self._dailyStampKeys[tabIndex][1]:getRewardItem(index)
    self._dayControl[index].slot.icon:SetShow(true)
    self._dayControl[index]._dayControl:SetShow(true)
    self._dayControl[index].slot:setItem(itemWrapper)
    self._dayControl[index]._dayText:SetFontColor(Defines.Color.C_FFEFEFEF)
    if false == ToClient_isConsole() then
      self._dayControl[index].slot.icon:addInputEvent("Mouse_On", "HandleEventOnOut_DailyStamp_All_ItemTooltip(" .. index .. "," .. tabIndex .. ")")
      self._dayControl[index].slot.icon:addInputEvent("Mouse_Out", "HandleEventOnOut_DailyStamp_All_ItemTooltip()")
    end
    if index < myAttendanceCount then
      self._dayControl[index]._stamp:SetShow(true)
      if index < recieveCount then
        self._dayControl[index].slot.icon:SetMonoTone(true)
        self._dayControl[index].goodItemSlot.icon:SetMonoTone(true)
        if index >= yesterdayRecieveCount then
          self._dayControl[index]._stamp:SetShow(false)
          self._animationTime = 0
          self._dayControl[index]._stamp:SetScale(1, 1)
          PaGlobalFunc_DailyStamp_All_SetAnimation(tabIndex, index)
          PaGlobalFunc_DailyStamp_All_ChangeTexture(index, 2, itemGradeType)
          if false == ToClient_isConsole() then
            self._dayControl[index]._dayControl:addInputEvent("Mouse_On", "HandleEventOnOut_DailyStamp_All_TodayAttendanceTooltipShow(" .. index .. ")")
            self._dayControl[index]._dayControl:addInputEvent("Mouse_Out", "HandleEventOnOut_DailyStamp_All_TodayAttendanceTooltipShow()")
          else
            self._ui_console.stc_guideA:SetShow(false)
          end
        else
          PaGlobalFunc_DailyStamp_All_ChangeTexture(index, 0, itemGradeType)
        end
      else
        if false == ToClient_isConsole() then
          self._dayControl[index]._dayControl:addInputEvent("Mouse_LUp", "HandleEventUp_DailyStamp_All_AcceptReward(" .. tabIndex .. ")")
          self._dayControl[index]._dayControl:addInputEvent("Mouse_RUp", "HandleEventUp_DailyStamp_All_AcceptReward(" .. tabIndex .. ")")
          self._dayControl[index].slot.icon:addInputEvent("Mouse_LUp", "HandleEventUp_DailyStamp_All_AcceptReward(" .. tabIndex .. ")")
          self._dayControl[index].slot.icon:addInputEvent("Mouse_RUP", "HandleEventUp_DailyStamp_All_AcceptReward(" .. tabIndex .. ")")
          self._dayControl[index].goodItemSlot.icon:addInputEvent("Mouse_LUp", "HandleEventUp_DailyStamp_All_AcceptReward(" .. tabIndex .. ")")
          self._dayControl[index].goodItemSlot.icon:addInputEvent("Mouse_RUP", "HandleEventUp_DailyStamp_All_AcceptReward(" .. tabIndex .. ")")
          self._dayControl[index]._dayControl:addInputEvent("Mouse_On", "HandleEventOnOut_DailyStamp_All_AcceptReward_TooltipShow(" .. index .. ")")
          self._dayControl[index]._dayControl:addInputEvent("Mouse_Out", "HandleEventOnOut_DailyStamp_All_AcceptReward_TooltipShow()")
        else
          self._ui_console.stc_guideA:SetShow(true)
          self._dayControl[index]._dayControl:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventUp_DailyStamp_All_AcceptReward(" .. self._tabIndex .. ")")
        end
        PaGlobalFunc_DailyStamp_All_ChangeTexture(index, 0, itemGradeType)
        local waitingTime = 0
        local possibleAttendance = false
        if self._dailyStampKeys[self._tabIndex][1]:isPossibleAttendance() then
          waitingTime = ToClient_getWaitingTimeForAttendance()
          possibleAttendance = true
        end
        if self._dailyStampKeys[self._tabIndex][1]:isPossibleOverlapAttendance() then
          waitingTime = ToClient_getWaitingTimeForNextAttendance(self._dailyStampKeys[self._tabIndex][1]:getKey())
          possibleAttendance = true
        end
        if 0 == waitingTime and not possibleAttendance and index == myAttendanceCount - 1 then
          PaGlobalFunc_DailyStamp_All_ChangeTexture(index, 0, itemGradeType)
          self._dayControl[index]._dayControl:SetVertexAniRun("Ani_Color_New", true)
        end
      end
    elseif index == myAttendanceCount then
      if self._dailyStampKeys[tabIndex][1]:isPossibleAttendance() or self._dailyStampKeys[tabIndex][1]:isPossibleOverlapAttendance() then
        if self:isPossibleAttandanceCheck() then
          PaGlobalFunc_DailyStamp_All_ChangeTexture(index, 0, itemGradeType)
          if false == ToClient_isConsole() then
            self._dayControl[index]._dayControl:addInputEvent("Mouse_On", "HandleEventOnOut_DailyStamp_All_Attendance_TooltipShow(" .. index .. ", true )")
            self._dayControl[index]._dayControl:addInputEvent("Mouse_Out", "HandleEventOnOut_DailyStamp_All_Attendance_TooltipShow()")
          end
        else
          PaGlobalFunc_DailyStamp_All_ChangeTexture(index, 3, itemGradeType)
          if false == ToClient_isConsole() then
            self._dayControl[index]._dayControl:addInputEvent("Mouse_On", "HandleEventOnOut_DailyStamp_All_Attendance_TooltipShow(" .. index .. ")")
            self._dayControl[index]._dayControl:addInputEvent("Mouse_Out", "HandleEventOnOut_DailyStamp_All_Attendance_TooltipShow()")
          end
          self._secondAttendanceCheck = true
        end
        if false == ToClient_isConsole() then
          self._dayControl[index]._dayControl:addInputEvent("Mouse_LUp", "HandleEventUp_DailyStamp_All_SetAttendance(" .. tabIndex .. ")")
          self._dayControl[index]._dayControl:addInputEvent("Mouse_RUp", "HandleEventUp_DailyStamp_All_SetAttendance(" .. tabIndex .. ")")
          self._dayControl[index].slot.icon:addInputEvent("Mouse_LUp", "HandleEventUp_DailyStamp_All_SetAttendance(" .. tabIndex .. ")")
          self._dayControl[index].slot.icon:addInputEvent("Mouse_RUP", "HandleEventUp_DailyStamp_All_SetAttendance(" .. tabIndex .. ")")
          self._dayControl[index].goodItemSlot.icon:addInputEvent("Mouse_LUp", "HandleEventUp_DailyStamp_All_SetAttendance(" .. tabIndex .. ")")
          self._dayControl[index].goodItemSlot.icon:addInputEvent("Mouse_RUP", "HandleEventUp_DailyStamp_All_SetAttendance(" .. tabIndex .. ")")
        end
        self._dayControl[index]._dayControl:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventUp_DailyStamp_All_SetAttendance(" .. self._tabIndex .. ")")
      else
        PaGlobalFunc_DailyStamp_All_ChangeTexture(index, 3, itemGradeType)
      end
    else
      PaGlobalFunc_DailyStamp_All_ChangeTexture(index, 1, itemGradeType)
    end
  end
  self._ui.txt_eventPeriod:SetText(self._eventPeriodTxt .. " " .. self._dailyStampKeys[tabIndex][1]:getPeriodDate())
  self._ui.txt_acceptPeriod:SetText(self._acceptPeriodTxt .. " " .. self._dailyStampKeys[tabIndex][1]:getExpireDate())
  self:tabUpdate()
end
function PaGlobal_DailyStamp_All:tabUpdate()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  for index = 1, self._dailyStampCount do
    local dailyStampTapName = self._dailyStampKeys[index][1]:getName()
    local attendanceKey = self._dailyStampKeys[index][1]:getKey()
    local myAttendanceCount = ToClient_getAttendanceCount(attendanceKey)
    local rewardCount = ToClient_getReceivedRewardCount(attendanceKey)
    if myAttendanceCount - rewardCount > 0 then
      dailyStampTapName = dailyStampTapName .. "(" .. myAttendanceCount - rewardCount .. ")"
    end
    self._tabControl[index]:SetText(dailyStampTapName)
  end
end
function PaGlobal_DailyStamp_All:dailyTabSort()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if 0 > self._dailyStampCount then
    return
  end
  local firstTabPosX = self._ui_pc.btn_tabTitle:GetPosX()
  local tabCheck = false
  local tabSort = {}
  local front = 1
  local back = self._dailyStampCount
  local totalDayCount, attendanceKey, rewardCount
  self._firstTabIndex = self._dailyStampCount
  for index = 1, self._dailyStampCount do
    if nil ~= self._dailyStampKeys[index][1] then
      totalDayCount = self._dailyStampKeys[index][1]:getRewardCount()
      attendanceKey = self._dailyStampKeys[index][1]:getKey()
      rewardCount = ToClient_getReceivedRewardCount(attendanceKey)
    end
    if rewardCount == totalDayCount then
      tabSort[back] = index
      back = back - 1
    else
      tabCheck = true
      self._firstTabIndex = math.min(self._firstTabIndex, index)
      tabSort[front] = index
      front = front + 1
    end
  end
  for index = 1, self._dailyStampCount do
    self._tabControl[index]:SetPosX(self._tabTitlePosition[self._dailyStampCount][index])
  end
  if not tabCheck then
    self._firstTabIndex = 1
  end
end
function PaGlobalFunc_DailyStamp_All_SetAnimation(tabIndex, dayIndex)
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if nil == tabIndex or nil == dayIndex then
    UI.ASSERT_NAME(nil ~= tabIndex, "PaGlobalFunc_DailyStamp_All_SetAnimation tabIndex nil", "\236\160\149\236\167\128\237\152\156")
    UI.ASSERT_NAME(nil ~= dayIndex, "PaGlobalFunc_DailyStamp_All_SetAnimation dayIndex nil", "\236\160\149\236\167\128\237\152\156")
    return
  end
  PaGlobal_DailyStamp_All._animationTabIndex = tabIndex
  if nil == PaGlobal_DailyStamp_All._animationdayIndex[0] then
    PaGlobal_DailyStamp_All._animationdayIndex[0] = dayIndex
  else
    PaGlobal_DailyStamp_All._animationdayIndex[1] = dayIndex
  end
end
function PaGlobalFunc_DailyStamp_All_StampAnimation(deltaTime)
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  PaGlobal_DailyStamp_All._animationTime = PaGlobal_DailyStamp_All._animationTime + deltaTime
  if PaGlobal_DailyStamp_All._tabIndex == PaGlobal_DailyStamp_All._animationTabIndex and PaGlobal_DailyStamp_All._animationTime > 0.3 and PaGlobal_DailyStamp_All._animationTime < 1 then
    for index = 0, #PaGlobal_DailyStamp_All._animationdayIndex do
      if PaGlobal_DailyStamp_All._animationdayIndex[index] <= PaGlobal_DailyStamp_All._rewardCount - 1 then
        PaGlobal_DailyStamp_All._dayControl[PaGlobal_DailyStamp_All._animationdayIndex[index]]._stamp:SetShow(true)
        PaGlobal_DailyStamp_All._dayControl[PaGlobal_DailyStamp_All._animationdayIndex[index]]._stamp:ResetVertexAni()
        PaGlobal_DailyStamp_All._dayControl[PaGlobal_DailyStamp_All._animationdayIndex[index]]._stamp:SetScale(1, 1)
        PaGlobal_DailyStamp_All._dayControl[PaGlobal_DailyStamp_All._animationdayIndex[index]]._stamp:SetSize(33, 33)
        PaGlobal_DailyStamp_All._dayControl[PaGlobal_DailyStamp_All._animationdayIndex[index]]._stamp:SetPosX(60)
        PaGlobal_DailyStamp_All._dayControl[PaGlobal_DailyStamp_All._animationdayIndex[index]]._stamp:SetPosY(20)
        PaGlobal_DailyStamp_All._dayControl[PaGlobal_DailyStamp_All._animationdayIndex[index]]._stamp:SetVertexAniRun("Ani_Move_Pos_New", true)
        PaGlobal_DailyStamp_All._dayControl[PaGlobal_DailyStamp_All._animationdayIndex[index]]._stamp:SetVertexAniRun("Ani_Scale_New", true)
      end
    end
    audioPostEvent_SystemUi(0, 21)
    _AudioPostEvent_SystemUiForXBOX(0, 21)
    PaGlobal_DailyStamp_All._animationTime = 5
  end
end
function PaGlobalFunc_DailyStamp_All_ChangeTexture(index, recieveType, itemGradeType)
  UI.ASSERT_NAME(nil ~= index, "PaGlobalFunc_DailyStamp_All_ChangeTexture index nil", "\236\160\149\236\167\128\237\152\156")
  UI.ASSERT_NAME(nil ~= recieveType, "PaGlobalFunc_DailyStamp_All_ChangeTexture recieveType nil", "\236\160\149\236\167\128\237\152\156")
  UI.ASSERT_NAME(nil ~= itemGradeType, "PaGlobalFunc_DailyStamp_All_ChangeTexture itemGradeType nil", "\236\160\149\236\167\128\237\152\156")
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  local textureTypeDay = "Combine/Etc/Combine_ETC_AccessReward_00.dds"
  local function SetDayTexture(baseT, onT, clickT)
    local x1, y1, x2, y2
    PaGlobal_DailyStamp_All._dayControl[index]._dayControl:ChangeTextureInfoName(baseT.texture)
    x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_DailyStamp_All._dayControl[index]._dayControl, baseT.x1, baseT.y1, baseT.x2, baseT.y2)
    PaGlobal_DailyStamp_All._dayControl[index]._dayControl:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGlobal_DailyStamp_All._dayControl[index]._dayControl:setRenderTexture(PaGlobal_DailyStamp_All._dayControl[index]._dayControl:getBaseTexture())
    PaGlobal_DailyStamp_All._dayControl[index]._dayControl:ChangeOnTextureInfoName(onT.texture)
    x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_DailyStamp_All._dayControl[index]._dayControl, onT.x1, onT.y1, onT.x2, onT.y2)
    PaGlobal_DailyStamp_All._dayControl[index]._dayControl:getOnTexture():setUV(x1, y1, x2, y2)
    PaGlobal_DailyStamp_All._dayControl[index]._dayControl:ChangeClickTextureInfoName(clickT.texture)
    x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_DailyStamp_All._dayControl[index]._dayControl, clickT.x1, clickT.y1, clickT.x2, clickT.y2)
    PaGlobal_DailyStamp_All._dayControl[index]._dayControl:getClickTexture():setUV(x1, y1, x2, y2)
  end
  if 0 == recieveType then
    if 1 == itemGradeType then
      local base = {
        x1 = 1,
        y1 = 1,
        x2 = 96,
        y2 = 96,
        texture = textureTypeDay
      }
      local on = {
        x1 = 1,
        y1 = 1,
        x2 = 96,
        y2 = 96,
        texture = textureTypeDay
      }
      local click = {
        x1 = 1,
        y1 = 1,
        x2 = 96,
        y2 = 96,
        texture = textureTypeDay
      }
      SetDayTexture(base, on, click)
    elseif 2 == itemGradeType then
      local base = {
        x1 = 1,
        y1 = 1,
        x2 = 96,
        y2 = 96,
        texture = textureTypeDay
      }
      local on = {
        x1 = 1,
        y1 = 1,
        x2 = 96,
        y2 = 96,
        texture = textureTypeDay
      }
      local click = {
        x1 = 1,
        y1 = 1,
        x2 = 96,
        y2 = 96,
        texture = textureTypeDay
      }
      SetDayTexture(base, on, click)
    else
      local base = {
        x1 = 1,
        y1 = 193,
        x2 = 96,
        y2 = 288,
        texture = textureTypeDay
      }
      local on = {
        x1 = 1,
        y1 = 193,
        x2 = 96,
        y2 = 288,
        texture = textureTypeDay
      }
      local click = {
        x1 = 1,
        y1 = 193,
        x2 = 96,
        y2 = 288,
        texture = textureTypeDay
      }
      SetDayTexture(base, on, click)
    end
  elseif 1 == recieveType then
    if 1 == itemGradeType then
      local base = {
        x1 = 97,
        y1 = 1,
        x2 = 192,
        y2 = 96,
        texture = textureTypeDay
      }
      local on = {
        x1 = 97,
        y1 = 1,
        x2 = 192,
        y2 = 96,
        texture = textureTypeDay
      }
      local click = {
        x1 = 97,
        y1 = 1,
        x2 = 192,
        y2 = 96,
        texture = textureTypeDay
      }
      SetDayTexture(base, on, click)
    elseif 2 == itemGradeType then
      local base = {
        x1 = 1,
        y1 = 97,
        x2 = 96,
        y2 = 192,
        texture = textureTypeDay
      }
      local on = {
        x1 = 1,
        y1 = 97,
        x2 = 96,
        y2 = 192,
        texture = textureTypeDay
      }
      local click = {
        x1 = 1,
        y1 = 97,
        x2 = 96,
        y2 = 192,
        texture = textureTypeDay
      }
      SetDayTexture(base, on, click)
    else
      local base = {
        x1 = 97,
        y1 = 193,
        x2 = 192,
        y2 = 288,
        texture = textureTypeDay
      }
      local on = {
        x1 = 97,
        y1 = 193,
        x2 = 192,
        y2 = 288,
        texture = textureTypeDay
      }
      local click = {
        x1 = 97,
        y1 = 193,
        x2 = 192,
        y2 = 288,
        texture = textureTypeDay
      }
      SetDayTexture(base, on, click)
    end
  elseif 2 == recieveType then
    if 1 == itemGradeType then
      local base = {
        x1 = 193,
        y1 = 1,
        x2 = 288,
        y2 = 96,
        texture = textureTypeDay
      }
      local on = {
        x1 = 193,
        y1 = 1,
        x2 = 288,
        y2 = 96,
        texture = textureTypeDay
      }
      local click = {
        x1 = 193,
        y1 = 1,
        x2 = 288,
        y2 = 96,
        texture = textureTypeDay
      }
      SetDayTexture(base, on, click)
    elseif 2 == itemGradeType then
      local base = {
        x1 = 97,
        y1 = 97,
        x2 = 192,
        y2 = 192,
        texture = textureTypeDay
      }
      local on = {
        x1 = 97,
        y1 = 97,
        x2 = 192,
        y2 = 192,
        texture = textureTypeDay
      }
      local click = {
        x1 = 97,
        y1 = 97,
        x2 = 192,
        y2 = 192,
        texture = textureTypeDay
      }
      SetDayTexture(base, on, click)
    else
      local base = {
        x1 = 193,
        y1 = 193,
        x2 = 288,
        y2 = 288,
        texture = textureTypeDay
      }
      local on = {
        x1 = 193,
        y1 = 193,
        x2 = 288,
        y2 = 288,
        texture = textureTypeDay
      }
      local click = {
        x1 = 193,
        y1 = 193,
        x2 = 288,
        y2 = 288,
        texture = textureTypeDay
      }
      SetDayTexture(base, on, click)
    end
  elseif 3 == recieveType then
    if 1 == itemGradeType then
      local base = {
        x1 = 289,
        y1 = 1,
        x2 = 384,
        y2 = 96,
        texture = textureTypeDay
      }
      local on = {
        x1 = 289,
        y1 = 1,
        x2 = 384,
        y2 = 96,
        texture = textureTypeDay
      }
      local click = {
        x1 = 289,
        y1 = 1,
        x2 = 384,
        y2 = 96,
        texture = textureTypeDay
      }
      SetDayTexture(base, on, click)
    elseif 2 == itemGradeType then
      local base = {
        x1 = 193,
        y1 = 97,
        x2 = 288,
        y2 = 192,
        texture = textureTypeDay
      }
      local on = {
        x1 = 193,
        y1 = 97,
        x2 = 288,
        y2 = 192,
        texture = textureTypeDay
      }
      local click = {
        x1 = 193,
        y1 = 97,
        x2 = 288,
        y2 = 192,
        texture = textureTypeDay
      }
      SetDayTexture(base, on, click)
    else
      local base = {
        x1 = 289,
        y1 = 193,
        x2 = 384,
        y2 = 288,
        texture = textureTypeDay
      }
      local on = {
        x1 = 289,
        y1 = 193,
        x2 = 384,
        y2 = 288,
        texture = textureTypeDay
      }
      local click = {
        x1 = 289,
        y1 = 193,
        x2 = 384,
        y2 = 288,
        texture = textureTypeDay
      }
      SetDayTexture(base, on, click)
    end
  end
end

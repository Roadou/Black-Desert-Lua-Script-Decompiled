Panel_Window_DailyStamp_Renew:SetShow(false, false)
local DailyStamp = {
  _ui = {
    _stc_mainTitle = UI.getChildControl(Panel_Window_DailyStamp_Renew, "StaticText_MainTitle"),
    _stc_topBG = UI.getChildControl(Panel_Window_DailyStamp_Renew, "Static_TopBG"),
    _stc_centerBG = UI.getChildControl(Panel_Window_DailyStamp_Renew, "Static_CenterBG"),
    _stc_bottomBG = UI.getChildControl(Panel_Window_DailyStamp_Renew, "Static_BottomBG"),
    _btn_rewardSlotList = {},
    _txt_dayList = {},
    _stc_stampList = {},
    _stc_rewardIconBGList = {},
    _slot_rewardSlotList = {},
    _stc_tapList = {}
  },
  _tabTitlePosition = {
    [1] = {325},
    [2] = {175, 475},
    [3] = {
      115,
      325,
      535
    }
  },
  prevAttendanceCount = {},
  _rewardRowCount = 5,
  _rewardColumnCount = 7,
  _slotCount = 35,
  _tabCount = 1,
  _tabCountMax = 1,
  _tabIndex = 1,
  nextDayShow = false,
  animationTime = -1,
  animationTabIndex = nil,
  animationdayIndex = {},
  _keyGuideAlign = {},
  _panel = Panel_Window_DailyStamp_Renew,
  _eventPeriodStr = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_DAILYSTAMP_EVENTPERIODTITLE"),
  _claimPeriodStr = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_DAILYSTAMP_REWARDACCEPTPERIODTITLE")
}
local attendanceTimeCheck = false
function FromClient_luaLoadComplete_DailyStamp()
  local self = DailyStamp
  self:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_DailyStamp")
function DailyStamp:initialize()
  self:initControl()
  self:createRewardSlot()
  self:registEventHandler()
  self:updateData()
end
function DailyStamp:initControl()
  self._ui._txt_mainTitle = UI.getChildControl(self._ui._stc_mainTitle, "StaticText_TitleIcon")
  self._ui._txt_tabTitle = UI.getChildControl(self._ui._stc_topBG, "StaticText_TabTitle")
  self._ui._txt_tabTitle:SetShow(false)
  self._ui._txt_tabLB = UI.getChildControl(self._ui._stc_topBG, "Static_LB")
  self._ui._txt_tabRB = UI.getChildControl(self._ui._stc_topBG, "Static_RB")
  self._ui._stc_buttonGroup = UI.getChildControl(self._ui._stc_centerBG, "Static_ButtonGroup")
  self._ui._btn_rewardSlotTemplate = UI.getChildControl(self._ui._stc_buttonGroup, "Button_RewardSlot")
  self._ui._txt_attendenceDesc = UI.getChildControl(self._ui._stc_centerBG, "StaticText_AttendenceDesc")
  self._ui._txt_eventPeriod = UI.getChildControl(self._ui._stc_centerBG, "StaticText_EventPeriod")
  self._ui._txt_claimPeriod = UI.getChildControl(self._ui._stc_centerBG, "StaticText_RewardAcceptPeriod")
  self._ui._txt_eventPeriodAlert = UI.getChildControl(self._ui._stc_bottomBG, "StaticText_EventPeriodAlert")
  self._ui._txt_weekEndDesc = UI.getChildControl(self._ui._stc_bottomBG, "StaticText_WeekEndDesc")
  self._ui._stc_buttonA = UI.getChildControl(self._ui._stc_bottomBG, "StaticText_KeyGuideA")
  self._ui._stc_buttonB = UI.getChildControl(self._ui._stc_bottomBG, "StaticText_KeyGuideB")
  self._ui._stc_buttonX = UI.getChildControl(self._ui._stc_bottomBG, "StaticText_KeyGuideDetail")
  self._ui._txt_eventPeriodAlert:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txt_eventPeriodAlert:SetText(self._ui._txt_eventPeriodAlert:GetText())
  self._ui._txt_weekEndDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txt_weekEndDesc:SetText(self._ui._txt_weekEndDesc:GetText())
  self._ui._txt_weekEndDesc:SetSpanSize(0, self._ui._txt_weekEndDesc:GetSpanSize().y + self._ui._txt_weekEndDesc:GetTextSizeY())
  self._ui._txt_eventPeriodAlert:SetSpanSize(0, self._ui._txt_weekEndDesc:GetSpanSize().y + self._ui._txt_eventPeriodAlert:GetTextSizeY())
  self._panel:SetSize(self._panel:GetSizeX(), self._panel:GetSizeY() + self._ui._txt_eventPeriodAlert:GetSpanSize().y)
  self._panel:ComputePos()
  self._ui._stc_bottomBG:ComputePos()
  self._ui._stc_buttonA:SetShow(true)
  self._keyGuideAlign = {
    self._ui._stc_buttonA,
    self._ui._stc_buttonX,
    self._ui._stc_buttonB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self._ui._stc_buttonA:SetShow(false)
end
function DailyStamp:registEventHandler()
  self._panel:RegisterUpdateFunc("PaGlobalFunc_DailyStamp_Animation")
  self._panel:RegisterShowEventFunc(true, "PaGlobalFunc_DailyStamp_ShowAni()")
  self._panel:RegisterShowEventFunc(false, "PaGlobalFunc_DailyStamp_HideAni()")
  registerEvent("FromClient_AttendanceUpdate", "FromClient_AttendanceUpdate_DailyStampRenew")
  registerEvent("FromClient_AttendanceUpdateAll", "FromClient_AttendanceUpdateAll_DailyStampRenew")
  registerEvent("FromClient_receiveAttendanceReward", "FromClient_receiveAttendanceReward_DailyStampRenew")
  registerEvent("selfPlayer_regionChanged", "FromClient_regionChanged_DailyStampRenew")
  registerEvent("FromClient_AttendanceTimer", "FromClient_AttendanceTimer_DailyStampRenew")
end
function DailyStamp:createRewardSlot()
  local index = 0
  local posX = 0
  local posY = 0
  local slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createClassEquipBG = true,
    createCash = true
  }
  for row = 0, self._rewardRowCount - 1 do
    for col = 0, self._rewardColumnCount - 1 do
      index = row * self._rewardColumnCount + col + 1
      self._ui._btn_rewardSlotList[index] = UI.cloneControl(self._ui._btn_rewardSlotTemplate, self._ui._stc_buttonGroup, "Button_RewardSlot" .. index)
      self._ui._txt_dayList[index] = UI.getChildControl(self._ui._btn_rewardSlotList[index], "StaticText_Day")
      self._ui._txt_dayList[index]:SetText(index)
      self._ui._stc_stampList[index] = UI.getChildControl(self._ui._btn_rewardSlotList[index], "Static_Stamp")
      self._ui._stc_rewardIconBGList[index] = UI.getChildControl(self._ui._btn_rewardSlotList[index], "Static_RewardIconBG")
      local slot = {}
      SlotItem.new(slot, "RewardSlot_" .. index, index, self._ui._stc_rewardIconBGList[index], slotConfig)
      slot:createChild()
      self._ui._slot_rewardSlotList[index] = slot
      posX = self._ui._btn_rewardSlotTemplate:GetPosX() + (self._ui._btn_rewardSlotTemplate:GetSizeX() + 10) * col
      posY = self._ui._btn_rewardSlotTemplate:GetPosY() + (self._ui._btn_rewardSlotTemplate:GetSizeY() + 10) * row
      self._ui._btn_rewardSlotList[index]:SetPosX(posX)
      self._ui._btn_rewardSlotList[index]:SetPosY(posY)
      self._ui._stc_stampList[index]:SetShow(false)
      self._ui._btn_rewardSlotList[index]:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_DailyStamp_ItemToolTipShow(true, " .. index .. ")")
    end
  end
end
function PaGlobalFunc_DailyStamp_GetShow()
  return DailyStamp._panel:GetShow()
end
function PaGlobalFunc_DailyStamp_Open()
  local self = DailyStamp
  close_WindowPanelList()
  self:open()
end
function DailyStamp:open()
  if getSelfPlayer():get():getLevel() < 6 then
    return
  end
  self._tabCount = ToClient_GetAttendanceInfoCount()
  if self._tabCount < 1 or nil == self._tabCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_NOEVENT"))
    return
  end
  self:selectTab(1)
  self._panel:SetShow(true)
end
function TabSort(lhs, rhs)
  return lhs[2] > rhs[2]
end
function DailyStamp:updateData()
  for index = 1, self._tabCountMax do
    if nil ~= self._ui._stc_tapList[index] then
      self._ui._stc_tapList[index]:SetShow(false)
    end
  end
  self._tabCount = ToClient_GetAttendanceInfoCount()
  if 1 == self._tabCount then
    Panel_Window_DailyStamp_Renew:registerPadEvent(__eConsoleUIPadEvent_LB, "")
    Panel_Window_DailyStamp_Renew:registerPadEvent(__eConsoleUIPadEvent_RB, "")
    self._ui._txt_tabLB:SetShow(false)
    self._ui._txt_tabRB:SetShow(false)
  else
    Panel_Window_DailyStamp_Renew:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_DailyStamp_selectTab(-1)")
    Panel_Window_DailyStamp_Renew:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobalFunc_DailyStamp_selectTab(1)")
    self._ui._txt_tabLB:SetShow(true)
    self._ui._txt_tabRB:SetShow(true)
  end
  self._dailyStampKeys = Array.new()
  for ii = 1, self._tabCount do
    local attendanceSS = ToClient_GetAttendanceInfoWrapper(ii - 1)
    self._dailyStampKeys[ii] = {
      attendanceSS,
      attendanceSS:getDisplayOrder(),
      false
    }
    if nil ~= self._dailyStampKeys[ii][1] and false == self._dailyStampKeys[ii][1]:isPossibleOverlapAttendance() and false == self._dailyStampKeys[ii][1]:isPossibleAttendance() then
      self._dailyStampKeys[ii][3] = true
    else
    end
  end
  if 1 < self._tabCount then
    table.sort(self._dailyStampKeys, TabSort)
  end
  if nil ~= self._dailyStampKeys[self._tabIndex] then
    local periodStr = self._eventPeriodStr .. " " .. self._dailyStampKeys[self._tabIndex][1]:getPeriodDate()
    self._ui._txt_eventPeriod:SetText(periodStr)
    local claimStr = self._claimPeriodStr .. " " .. self._dailyStampKeys[self._tabIndex][1]:getExpireDate()
    self._ui._txt_claimPeriod:SetText(claimStr)
  end
  for index = 1, self._tabCount do
    if nil == self._ui._stc_tapList[index] then
      self._ui._stc_tapList[index] = UI.cloneControl(self._ui._txt_tabTitle, self._ui._stc_topBG, "Static_TabTitle_" .. index)
      self._tabCountMax = index
    end
    self._ui._stc_tapList[index]:SetText(self._dailyStampKeys[index][1]:getName())
    self._ui._stc_tapList[index]:SetPosX(self._tabTitlePosition[self._tabCount][index])
    if self._tabIndex == index then
      self._ui._stc_tapList[index]:SetFontColor(Defines.Color.C_FFEEEEEE)
    else
      self._ui._stc_tapList[index]:SetFontColor(Defines.Color.C_FF76747D)
    end
    self._ui._stc_tapList[index]:SetShow(true)
  end
end
function DailyStamp:updateRewardSlots()
  if 1 > self._tabCount then
    return
  end
  local data = self._dailyStampKeys[self._tabIndex]
  if nil == data[1] then
    self:close()
    return
  end
  local attendanceKey = data[1]:getKey()
  local myAttendanceCount = ToClient_getAttendanceCount(attendanceKey)
  local receiveCount = ToClient_getReceivedRewardCount(attendanceKey)
  local yesterdayRecieveCount = data[1]:getAttendanceYesterdayCount()
  if nil == self.prevAttendanceCount[self._tabIndex] then
    self.prevAttendanceCount[self._tabIndex] = myAttendanceCount
  end
  if not data[1]:isPossibleAttendance() and not data[1]:isPossibleOverlapAttendance() then
    self._ui._txt_attendenceDesc:SetFontColor(Defines.Color.C_FFC4BEBE)
    self._ui._txt_attendenceDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_TODAY_ATTENDANCE_COMPLETE"))
    self._ui._txt_attendenceDesc:SetShow(true)
  else
    self._ui._txt_attendenceDesc:SetShow(false)
  end
  local totalDayCount = self._dailyStampKeys[self._tabIndex][1]:getRewardCount()
  self.animationdayIndex = {}
  self._secondAttendanceDone = false
  for ii = 1, self._slotCount do
    if ii <= totalDayCount then
      self._ui._btn_rewardSlotList[ii]:SetShow(true)
      local itemGradeType = data[1]:getRewardItemGradeType(ii - 1)
      local itemWrapper = data[1]:getRewardItem(ii - 1)
      self._ui._slot_rewardSlotList[ii]:setItem(itemWrapper)
      if myAttendanceCount >= ii then
        self._ui._stc_stampList[ii]:SetShow(true)
        if receiveCount >= ii then
          self._ui._slot_rewardSlotList[ii].icon:SetMonoTone(true)
          if yesterdayRecieveCount <= ii - 1 then
            self._ui._stc_stampList[ii]:SetShow(false)
            self._ui._stc_stampList[ii]:SetScale(1, 1)
            self.animationTime = 0
            self:setAnimation(self._tabIndex, ii)
          end
          self._ui._stc_buttonA:SetShow(false)
        else
          self._ui._stc_stampList[ii]:SetShow(false)
          self._ui._slot_rewardSlotList[ii].icon:SetMonoTone(false)
          self._ui._btn_rewardSlotList[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "Input_DailyStamp_AcceptReward(" .. self._tabIndex .. ")")
          self._ui._stc_buttonA:SetShow(true)
          local waitingTime = 0
          local possibleAttendance = false
          if data[1]:isPossibleAttendance() then
            waitingTime = ToClient_getWaitingTimeForAttendance()
            possibleAttendance = true
          end
          if data[1]:isPossibleOverlapAttendance() then
            waitingTime = ToClient_getWaitingTimeForNextAttendance(data[1]:getKey())
            possibleAttendance = true
          end
          if 0 == waitingTime and not possibleAttendance and ii == myAttendanceCount then
            self._ui._btn_rewardSlotList[ii]:SetVertexAniRun("Ani_Color_New", true)
            self._ui._txt_attendenceDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_TODAY_ATTENDANCE_COMPLETE"))
          end
        end
      else
        self._ui._stc_stampList[ii]:SetShow(false)
        self._ui._slot_rewardSlotList[ii].icon:SetMonoTone(false)
        if ii == myAttendanceCount and (data[1]:isPossibleAttendance() or data[1]:isPossibleOverlapAttendance()) then
          if isPossibleAttandanceCheck() then
          else
            self._secondAttendanceDone = true
          end
          self._ui._btn_rewardSlotList[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "DailyStamp_SetAttendance(" .. self._tabIndex .. ")")
        end
      end
    else
      self._ui._btn_rewardSlotList[ii]:SetShow(false)
    end
  end
end
function DailyStamp:setAnimation(tabIndex, dayIndex)
  self.animationTabIndex = tabIndex
  if nil == self.animationdayIndex[0] then
    self.animationdayIndex[0] = dayIndex
  else
    self.animationdayIndex[1] = dayIndex
  end
end
function DailyStamp_ChangeTexture(index, recieveType, itemGradeType)
end
function DailyStamp_SetAttendance(tabIndex)
  if not isPossibleAttandanceCheck() then
    local waitingTime = -1
    if self._dailyStampKeys[self._tabIndex][1]:isPossibleAttendance() then
      waitingTime = ToClient_getWaitingTimeForAttendance()
    end
    if self._dailyStampKeys[tabIndex][1]:isPossibleOverlapAttendance() then
      waitingTime = ToClient_getWaitingTimeForNextAttendance(self._dailyStampKeys[tabIndex][1]:getKey())
    end
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_STILL_CHECK_IMPOSSIBLE_REMAINTIME", "remainTime", Util.Time.timeFormatting_Minute(waitingTime)))
    return false
  end
  local attendanceKey = self._dailyStampKeys[tabIndex][1]:getKey()
  ToClient_onAttendance(attendanceKey)
  return true
end
function isPossibleAttandanceCheck()
  local self = DailyStamp
  if nil == self._dailyStampKeys[self._tabIndex][1] then
    return false
  end
  local waitingTime = -1
  local possibleAttendance = false
  if self._dailyStampKeys[self._tabIndex][1]:isPossibleAttendance() then
    waitingTime = ToClient_getWaitingTimeForAttendance()
    possibleAttendance = true
  end
  if self._dailyStampKeys[self._tabIndex][1]:isPossibleOverlapAttendance() then
    waitingTime = ToClient_getWaitingTimeForNextAttendance(self._dailyStampKeys[self._tabIndex][1]:getKey())
    possibleAttendance = true
  end
  if waitingTime < 0 then
    return false
  end
  if 0 == waitingTime then
    if possibleAttendance then
      self._ui._txt_attendenceDesc:SetFontColor(UI_color.C_FF96D4FC)
      self._ui._txt_attendenceDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_NEWDAY_ATTENDANCE_CLICK"))
    else
      self._ui._txt_attendenceDesc:SetFontColor(UI_color.C_FFC4BEBE)
      self._ui._txt_attendenceDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_TODAY_ATTENDANCE_COMPLETE"))
    end
    if not attendanceTimeCheck then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_TODAY_ATTENDANCE_POSSIBLE"))
      attendanceTimeCheck = true
      self:updateData()
      self:updateRewardSlots()
    end
  else
    local remainTimeText = ""
    if waitingTime < 60 then
      remainTimeText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_REMAIN_SECOND", "remainTime", waitingTime)
    else
      remainTimeText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_REMAIN_MINUTE", "remainTime", math.floor(waitingTime / 60))
    end
    self._ui._txt_attendenceDesc:SetFontColor(UI_color.C_FFEFEFEF)
    self._ui._txt_attendenceDesc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_DONOT_ATTENDANCE_AFTERPOSSIBLE", "remainTimeText", remainTimeText))
    if attendanceTimeCheck then
      attendanceTimeCheck = false
      self:updateData()
      self:updateRewardSlots()
    end
  end
  return attendanceTimeCheck
end
function PaGlobalFunc_DailyStamp_selectTab(addTabIndex)
  local self = DailyStamp
  self:selectTab(addTabIndex)
end
function DailyStamp:selectTab(addTabIndex)
  local tabIndex = self._tabIndex + addTabIndex
  if tabIndex < 1 then
    self._tabIndex = self._tabCount
  elseif tabIndex > self._tabCount then
    self._tabIndex = 1
  else
    self._tabIndex = tabIndex
  end
  self:updateData()
  self:updateRewardSlots()
end
function PaGlobalFunc_DailyStamp_ItemToolTipShow(isShow, slotIndex)
  if false == isShow then
    return
  end
  local self = DailyStamp
  local itemWrapper = self._dailyStampKeys[self._tabIndex][1]:getRewardItem(slotIndex - 1)
  local itemSSW = itemWrapper:getStaticStatus()
  PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.Item)
end
function PaGlobalFunc_DailyStamp_ItemToolTipHide(slotIndex)
end
function PaGlobalFunc_DailyStamp_AUp()
  local self = DailyStamp
end
function DailyStamp:close()
  self._panel:SetShow(false)
end
local todayFirstShow = false
function PaGlobalFunc_DailyStamp_Close()
  local self = DailyStamp
  self:close()
  if true == todayFirstShow then
    PaGlobalFunc_NewsBanner_Open()
    todayFirstShow = false
  end
end
function PaGlobalFunc_DailyStamp_Animation(deltaTime)
  local self = DailyStamp
  self.animationTime = self.animationTime + deltaTime
  if self.animationTime > 0.3 and self.animationTime < 1 then
    for index = 0, #self.animationdayIndex do
      if nil ~= self.animationdayIndex[index] and self.animationdayIndex[index] <= self._slotCount - 1 then
        self._ui._stc_stampList[self.animationdayIndex[index]]:SetShow(true)
        self._ui._stc_stampList[self.animationdayIndex[index]]:ResetVertexAni()
        self._ui._stc_stampList[self.animationdayIndex[index]]:SetVertexAniRun("Ani_Move_Pos_New", true)
        self._ui._stc_stampList[self.animationdayIndex[index]]:SetVertexAniRun("Ani_Scale_New", true)
      end
    end
    audioPostEvent_SystemUi(0, 21)
    _AudioPostEvent_SystemUiForXBOX(0, 21)
    self.animationTime = 5
  end
end
function DailyStamp_ShowToggle()
end
function PaGlobalFunc_DailyStamp_ShowAni()
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  Panel_Window_DailyStamp_Renew:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_MidHorizon.dds")
  local FadeMaskAni = Panel_Window_DailyStamp_Renew:addTextureUVAnimation(0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(CppEnums.PAUI_TEXTURE_TYPE.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0, 0)
  FadeMaskAni:SetEndUV(0.6, 0, 0)
  FadeMaskAni:SetStartUV(1, 0, 1)
  FadeMaskAni:SetEndUV(0.4, 0, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0.6, 1, 2)
  FadeMaskAni:SetStartUV(1, 1, 3)
  FadeMaskAni:SetEndUV(0.4, 1, 3)
  FadeMaskAni.IsChangeChild = true
  DailyStamp.animationTime = 0
end
function PaGlobalFunc_DailyStamp_HideAni()
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
  Panel_Window_DailyStamp_Renew:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_Window_DailyStamp_Renew, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
function TabSort(lhs, rhs)
  return lhs[2] > rhs[2]
end
function Input_DailyStamp_AcceptReward(tabIndex)
  local self = DailyStamp
  local attendanceKey = self._dailyStampKeys[tabIndex][1]:getKey()
  local function recieveReward()
    ToClient_takeRewardItem(attendanceKey)
  end
  local myAttendanceCount = ToClient_getAttendanceCount(attendanceKey)
  local receiveItemIndex = ToClient_getReceivedRewardCount(attendanceKey)
  if myAttendanceCount <= receiveItemIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_NOTHING_REWARD"))
    return
  end
  if 0 == receiveItemIndex then
    receiveItemIndex = 0
  end
  local title = PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_MSGTITLE")
  local itemWrapper = self._dailyStampKeys[tabIndex][1]:getRewardItem(receiveItemIndex)
  local content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_MSGCONTENT", "name", tostring(itemWrapper:getStaticStatus():getName()))
  messageBoxData = {
    title = title,
    content = content,
    functionYes = recieveReward,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function DailyStamp:receiveRewardAll()
  local attendanceKey = self._dailyStampKeys[self._tabIndex][1]:getKey()
  local myAttendanceCount = ToClient_getAttendanceCount(attendanceKey)
  local receiveItemIndex = ToClient_getReceivedRewardCount(attendanceKey)
  if myAttendanceCount > receiveItemIndex then
    for index = receiveItemIndex, myAttendanceCount - 1 do
      ToClient_takeRewardItem(attendanceKey)
    end
  end
end
local _secondAttendanceCheck = false
local _isDailyChallengeShow = false
function FromClient_AttendanceUpdate_DailyStampRenew(attendanceKey)
  local self = DailyStamp
  if getSelfPlayer():get():getLevel() < 6 then
    return
  end
  _secondAttendanceCheck = self._secondAttendanceDone
  for ii = 1, self._tabCount do
    local dailyKey = self._dailyStampKeys[ii][1]:getKey()
    if dailyKey:get() == attendanceKey:get() then
      self._tabIndex = ii
      self:receiveRewardAll()
      self:updateData()
      self:updateRewardSlots()
      self._dailyStampKeys[ii][3] = true
      if nil ~= self._dailyStampKeys[ii][1] and false == self._dailyStampKeys[ii][1]:isPossibleOverlapAttendance() and false == self._dailyStampKeys[ii][1]:isPossibleAttendance() then
        self._dailyStampKeys[ii][3] = true
      end
      break
    end
  end
  if self.nextDayShow or _secondAttendanceCheck then
    local seflPlayer = getSelfPlayer()
    if nil == seflPlayer then
      return
    end
    local regionInfo = getRegionInfoByPosition(seflPlayer:get():getPosition())
    local isSafeZone = regionInfo:get():isSafeZone()
    if false == isSafeZone then
      return
    end
    self.nextDayShow = false
  end
  todayFirstShow = true
  if not self._panel:GetShow() then
    _isDailyChallengeShow = true
    self._panel:SetShow(true, true)
  end
end
function FromClient_AttendanceUpdateAll_DailyStampRenew(isNextDay)
  local self = DailyStamp
  if isNextDay then
    self.nextDayShow = isNextDay
    todayFirstShow = true
  end
  self:updateData()
end
function FromClient_regionChanged_DailyStampRenew(regionData)
  local self = DailyStamp
  if self.nextDayShow then
    local isSafeZone = regionData:get():isSafeZone()
    if isSafeZone and not self._panel:GetShow() then
      self.nextDayShow = false
      PaGlobalFunc_DailyStamp_Open()
      return
    end
  end
  if _secondAttendanceCheck then
    local isSafeZone = regionData:get():isSafeZone()
    if isSafeZone and not self._panel:GetShow() then
      _secondAttendanceCheck = false
      PaGlobalFunc_DailyStamp_Open()
      return
    end
  end
end
function FromClient_receiveAttendanceReward_DailyStampRenew()
  local self = DailyStamp
  self:updateData()
  self:updateRewardSlots()
end
function PaGlobalFunc_DailyStamp_IsDailyChallengeShow()
  local result = _isDailyChallengeShow
  _isDailyChallengeShow = false
  return result
end
function FromClient_AttendanceTimer_DailyStampRenew()
  local self = DailyStamp
  if nil == getSelfPlayer() then
    return
  end
  if getSelfPlayer():get():getLevel() < 6 then
    return
  end
  local waitingTime = -1
  local attendance = false
  local remainTimeText = ""
  for index = 1, self._tabCount do
    if nil ~= self._dailyStampKeys[index] and nil ~= self._dailyStampKeys[index][1] and self._dailyStampKeys[index][1]:isPossibleAttendance() then
      waitingTime = ToClient_getWaitingTimeForAttendance()
      if 0 == waitingTime then
        local attendanceKey = self._dailyStampKeys[index][1]:getKey()
        ToClient_onAttendance(attendanceKey)
        attendance = true
      elseif waitingTime > 0 then
        if waitingTime < 60 then
          remainTimeText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_REMAIN_SECOND", "remainTime", waitingTime)
        else
          remainTimeText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_REMAIN_MINUTE", "remainTime", math.floor(waitingTime / 60))
        end
        self._ui._txt_attendenceDesc:SetFontColor(UI_color.C_FFEFEFEF)
        self._ui._txt_attendenceDesc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_DONOT_ATTENDANCE_AFTERPOSSIBLE", "remainTimeText", remainTimeText))
      end
    end
  end
  waitingTime = -1
  for index = 1, self._tabCount do
    if nil ~= self._dailyStampKeys[index] and nil ~= self._dailyStampKeys[index][1] and self._dailyStampKeys[index][1]:isPossibleOverlapAttendance() then
      waitingTime = ToClient_getWaitingTimeForNextAttendance(self._dailyStampKeys[index][1]:getKey())
      if 0 == waitingTime then
        local attendanceKey = self._dailyStampKeys[index][1]:getKey()
        ToClient_onAttendance(attendanceKey)
        attendance = true
      elseif waitingTime > 0 then
        if waitingTime < 60 then
          remainTimeText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_REMAIN_SECOND", "remainTime", waitingTime)
        else
          remainTimeText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_REMAIN_MINUTE", "remainTime", math.floor(waitingTime / 60))
        end
        if self.tapIndex == index then
          self._ui._txt_attendenceDesc:SetFontColor(UI_color.C_FFEFEFEF)
          self._ui._txt_attendenceDesc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_DONOT_ATTENDANCE_AFTERPOSSIBLE", "remainTimeText", remainTimeText))
        end
      end
    end
  end
end

local _mainPanel = Panel_Window_CharacterInfo_Renew
local _panel = Panel_Window_CharacterInfo_History_Renew
local CharacterHistoryInfo = {
  _ui = {
    stc_MonthTapBg = UI.getChildControl(_panel, "Static_Month_Tap"),
    frame_HistoryList = UI.getChildControl(_panel, "Frame_Title_List"),
    frameBG = nil
  },
  defaultFrameBG_CharacterInfo_History = nil,
  currentValue = {
    _year = ToClient_GetThisYear(),
    _month = ToClient_GetThisMonth(),
    _day = ToClient_GetToday(),
    _myHistory = 0,
    _guildHistory = 1
  },
  pastMonth_DayCount = {
    [1] = 31,
    [2] = 29,
    [3] = 31,
    [4] = 30,
    [5] = 31,
    [6] = 30,
    [7] = 31,
    [8] = 31,
    [9] = 30,
    [10] = 31,
    [11] = 30,
    [12] = 31
  },
  _hitoryContainer = {},
  _specifyKey = 100,
  _minYear = 2014,
  _minMonth = 1,
  _currentContainerIdx = 1,
  _circleRightPosModification = 51,
  _circleLeftPosModification = -80,
  _datePosModification = 100,
  _historyPosModification = 95,
  _dayRightHistoryValue = {},
  _historyRightValueLength = 0,
  _dayLeftHistoryValue = {},
  _historyLeftValueLength = 0,
  _dayCircleValue = {},
  _dayDateValue = {},
  _dateValueLength = 0,
  _lastShowedYear = ToClient_GetThisYear(),
  _lastShowedMonth = ToClient_GetThisMonth(),
  _monthEnglishTitleString = {
    [1] = "Jan",
    [2] = "Fab",
    [3] = "Mar",
    [4] = "Apr",
    [5] = "May",
    [6] = "Jun",
    [7] = "Jul",
    [8] = "Aug",
    [9] = "Sep",
    [10] = "Oct",
    [11] = "Nov",
    [12] = "Dec"
  }
}
function CharacterHistoryInfo:init()
  self._ui.txt_Year = UI.getChildControl(self._ui.stc_MonthTapBg, "StaticText_Year")
  self._ui.stc_LB = UI.getChildControl(self._ui.stc_MonthTapBg, "Static_LT_ConsoleUI")
  self._ui.stc_LB:addInputEvent("Mouse_LUp", "InputMLUp_CharacterHistoryInfo_DecreaseMonth()")
  self._ui.stc_RB = UI.getChildControl(self._ui.stc_MonthTapBg, "Static_RT_ConsoleUI")
  self._ui.stc_RB:addInputEvent("Mouse_LUp", "InputMLUp_CharacterHistoryInfo_IncreaseMonth()")
  self._ui.radioButton_Month = {}
  for monthIdx = 1, 12 do
    self._ui.radioButton_Month[monthIdx] = UI.getChildControl(self._ui.stc_MonthTapBg, "RadioButton_Month" .. monthIdx)
    self._ui.radioButton_Month[monthIdx]:addInputEvent("Mouse_LUp", "InputMLUp_CharacterHistoryInfo_TapToOpen(" .. monthIdx .. ")")
    self._ui.radioButton_Month[monthIdx]:SetFontColor(Defines.Color.C_FF444444)
    if true == _ContentsGroup_RenewUI then
      self._ui.radioButton_Month[monthIdx]:SetText(self._monthEnglishTitleString[monthIdx])
    else
      local monthString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_HISTORY_MONTH", "month", tostring(monthIdx))
      self._ui.radioButton_Month[monthIdx]:SetText(tostring(monthString))
    end
  end
  self._ui.frame_Content = self._ui.frame_HistoryList:GetFrameContent()
  self._ui.stc_Line_V = UI.getChildControl(self._ui.frame_Content, "Static_Line_Vertical")
  self._ui.txt_HistroyLine_R = UI.getChildControl(self._ui.frame_Content, "StaticText_HistoryLine_Right")
  self._ui.txt_HistroyLine_L = UI.getChildControl(self._ui.frame_Content, "StaticText_HistoryLine_Left")
  self._ui.txt_Date_L = UI.getChildControl(self._ui.frame_Content, "StaticText_Date_Left")
  self._ui.txt_Date_R = UI.getChildControl(self._ui.frame_Content, "StaticText_Date_Right")
  self._ui.stc_Circle_L = UI.getChildControl(self._ui.frame_Content, "Static_Circle_Left")
  self._ui.stc_Line_H_L = UI.getChildControl(self._ui.stc_Circle_L, "Static_Line_Horizon_Left")
  self._ui.stc_Circle_R = UI.getChildControl(self._ui.frame_Content, "Static_Circle_Right")
  self._ui.stc_Line_H_R = UI.getChildControl(self._ui.stc_Circle_R, "Static_Line_Horizon_Right")
  self._ui.frame_VScroll = UI.getChildControl(self._ui.frame_HistoryList, "Frame_VerticalScroll")
  self._ui.frameBG = UI.getChildControl(self._ui.frame_Content, "Static_FrameContentBG")
  self._ui.frameBG:SetIgnore(false)
  self._ui.stc_Line_V:SetShow(false)
  self._ui.txt_HistroyLine_R:SetShow(false)
  self._ui.txt_HistroyLine_L:SetShow(false)
  self._ui.txt_Date_L:SetShow(false)
  self._ui.txt_Date_R:SetShow(false)
  self._ui.stc_Circle_L:SetShow(false)
  self._ui.stc_Circle_R:SetShow(false)
  self:updateHistoryContainer()
end
function FromClient_CharacterHistoryInfo_updateInfo()
  if nil == CharacterHistoryInfo then
    return
  end
  self = CharacterHistoryInfo
  self:updateInfo(self._currentContainerIdx)
end
function CharacterHistoryInfo:updateHistoryContainer()
  local currentYear = ToClient_GetThisYear()
  local indexMonth = 0
  local containerIdx = 1
  for yearIdx = currentYear, self._minYear, -1 do
    if yearIdx == currentYear then
      indexMonth = ToClient_GetThisMonth()
    else
      indexMonth = 12
    end
    for monthIdx = indexMonth, 1, -1 do
      local journalListCount = ToClient_GetJournalListCount(yearIdx, monthIdx, self.currentValue._myHistory)
      if journalListCount > 0 or yearIdx == currentYear and monthIdx == ToClient_GetThisMonth() then
        local container = {}
        container.year = yearIdx
        container.month = monthIdx
        self._hitoryContainer[containerIdx] = container
        containerIdx = containerIdx + 1
      end
    end
  end
end
function CharacterHistoryInfo:updateInfo(containerIdx)
  local container = self._hitoryContainer[containerIdx]
  if nil == container then
    return
  end
  self._currentContainerIdx = containerIdx
  local indexYear = container.year
  local indexMonth = container.month
  local _journalListCount = ToClient_GetJournalListCount(indexYear, indexMonth, self.currentValue._myHistory)
  local _historyRightValueIdx = 0
  local _historyLeftValueIdx = 0
  local _dateValueIdx = 0
  local _dayIndex
  local _recvJournal = {}
  local _txtYAxis = -50
  local _isHistoryLeftSide = false
  self._ui.txt_Year:SetText(indexYear)
  for _month = 1, 12 do
    self._ui.radioButton_Month[_month]:SetFontColor(Defines.Color.C_FF444444)
  end
  self._ui.radioButton_Month[indexMonth]:SetFontColor(Defines.Color.C_FFEEEEEE)
  local _thisYear = ToClient_GetThisYear()
  local _thisMonth = ToClient_GetThisMonth()
  local _today = ToClient_GetToday()
  local receivedJournal = {}
  for journalReadingIndex = _journalListCount - 1, 0, -1 do
    local currentIndexJournal = ToClient_GetJournal(indexYear, indexMonth, self.currentValue._myHistory, journalReadingIndex)
    local journalDayCount = currentIndexJournal:getJournalDay()
    if nil == receivedJournal[journalDayCount] then
      receivedJournal[journalDayCount] = {}
      receivedJournal[journalDayCount].dayCount = journalDayCount
      receivedJournal[journalDayCount].journalIdx = 1
    end
    local journalIdx = receivedJournal[journalDayCount].journalIdx
    receivedJournal[journalDayCount][journalIdx] = currentIndexJournal:getName()
    receivedJournal[journalDayCount].journalIdx = journalIdx + 1
  end
  for dayCountIdx = self.pastMonth_DayCount[indexMonth], 1, -1 do
    if nil ~= receivedJournal[dayCountIdx] then
      _isHistoryLeftSide = not _isHistoryLeftSide
      _txtYAxis = _txtYAxis + 100
      if _dateValueIdx >= self._dateValueLength then
        if true == _isHistoryLeftSide then
          local _dayDateTitle = UI.createAndCopyBasePropertyControl(self._ui.frame_Content, "StaticText_Date_Left", self._ui.frame_Content, "StaticText_Date_Title" .. "no" .. self._dateValueLength)
          self._dayDateValue[_dateValueIdx] = _dayDateTitle
          self._dayDateValue[_dateValueIdx]:SetPosX(self._ui.stc_Line_V:GetPosX() - self._dayDateValue[_dateValueIdx]:GetSizeX() - self._datePosModification)
          local _dayCircle = UI.createAndCopyBasePropertyControl(self._ui.frame_Content, "Static_Circle_Left", self._ui.frame_Content, "Static_Circle_Left_Date" .. self._dateValueLength)
          local _dayHorizonLine = UI.createAndCopyBasePropertyControl(self._ui.stc_Circle_L, "Static_Line_Horizon_Left", _dayCircle, "Static_Line_Horizon_Left_Date" .. self._dateValueLength)
          self._dayCircleValue[_dateValueIdx] = _dayCircle
          self._dayCircleValue[_dateValueIdx]:SetPosX(self._ui.stc_Line_V:GetPosX() + self._circleLeftPosModification)
          self._dateValueLength = self._dateValueLength + 1
        else
          local _dayDateTitle = UI.createAndCopyBasePropertyControl(self._ui.frame_Content, "StaticText_Date_Right", self._ui.frame_Content, "StaticText_Date_Title" .. "no" .. self._dateValueLength)
          self._dayDateValue[_dateValueIdx] = _dayDateTitle
          self._dayDateValue[_dateValueIdx]:SetPosX(self._ui.stc_Line_V:GetPosX() + self._datePosModification)
          local _dayCircle = UI.createAndCopyBasePropertyControl(self._ui.frame_Content, "Static_Circle_Right", self._ui.frame_Content, "Static_Circle_Right_Date" .. self._dateValueLength)
          local _dayHorizonLine = UI.createAndCopyBasePropertyControl(self._ui.stc_Circle_R, "Static_Line_Horizon_Right", _dayCircle, "Static_Line_Horizon_Right_Date" .. self._dateValueLength)
          self._dayCircleValue[_dateValueIdx] = _dayCircle
          self._dayCircleValue[_dateValueIdx]:SetPosX(self._ui.stc_Line_V:GetPosX() + self._circleRightPosModification)
          self._dateValueLength = self._dateValueLength + 1
        end
      end
      local monthString, dayString
      if true == _ContentsGroup_RenewUI then
        monthString = self._monthEnglishTitleString[indexMonth] .. "."
        dayString = tostring(receivedJournal[dayCountIdx].dayCount)
      else
        monthString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_HISTORY_MONTH", "month", tostring(indexMonth))
        dayString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(receivedJournal[dayCountIdx].dayCount))
      end
      self._dayDateValue[_dateValueIdx]:SetAutoResize(true)
      self._dayDateValue[_dateValueIdx]:SetText(tostring(monthString) .. " " .. tostring(dayString))
      self._dayDateValue[_dateValueIdx]:SetPosY(_txtYAxis - 7)
      self._dayDateValue[_dateValueIdx]:SetShow(true)
      self._dayCircleValue[_dateValueIdx]:SetPosY(_txtYAxis)
      self._dayCircleValue[_dateValueIdx]:SetShow(true)
      _dateValueIdx = _dateValueIdx + 1
      _txtYAxis = _txtYAxis + 45
      local _historyValue
      for index, dayCountJournal in ipairs(receivedJournal[dayCountIdx]) do
        if true == _isHistoryLeftSide then
          if nil == self._dayLeftHistoryValue[_historyLeftValueIdx] then
            local _dayHistoryLine = UI.createAndCopyBasePropertyControl(self._ui.frame_Content, "StaticText_HistoryLine_Left", self._ui.frame_Content, "StaticText_HistoryLine_LeftNo" .. self._historyLeftValueLength)
            self._dayLeftHistoryValue[_historyLeftValueIdx] = _dayHistoryLine
            self._historyLeftValueLength = self._historyLeftValueLength + 1
          end
          _historyValue = self._dayLeftHistoryValue[_historyLeftValueIdx]
          _historyValue:SetText(tostring(dayCountJournal) .. " \194\183")
          _historyValue:SetPosX(self._ui.stc_Line_V:GetPosX() - _historyValue:GetSizeX() - self._historyPosModification)
          _historyLeftValueIdx = _historyLeftValueIdx + 1
        else
          if nil == self._dayRightHistoryValue[_historyRightValueIdx] then
            local _dayHistoryLine = UI.createAndCopyBasePropertyControl(self._ui.frame_Content, "StaticText_HistoryLine_Right", self._ui.frame_Content, "StaticText_HistoryLine_RightNo" .. self._historyRightValueLength)
            self._dayRightHistoryValue[_historyRightValueIdx] = _dayHistoryLine
            self._historyRightValueLength = self._historyRightValueLength + 1
          end
          _historyValue = self._dayRightHistoryValue[_historyRightValueIdx]
          _historyValue:SetText("\194\183 " .. tostring(dayCountJournal))
          _historyValue:SetPosX(self._ui.stc_Line_V:GetPosX() + self._historyPosModification)
          _historyRightValueIdx = _historyRightValueIdx + 1
        end
        _historyValue:SetAutoResize(true)
        _historyValue:SetPosY(_txtYAxis)
        _historyValue:SetIgnore(true)
        _historyValue:SetShow(true)
        _txtYAxis = _txtYAxis + 30
      end
    end
  end
  if _dateValueIdx < self._dateValueLength then
    for _earseIndex = _dateValueIdx, self._dateValueLength - 1 do
      self._dayCircleValue[_earseIndex]:SetShow(false)
      self._dayDateValue[_earseIndex]:SetShow(false)
    end
  end
  if _historyRightValueIdx < self._historyRightValueLength then
    for _earseIndex = _historyRightValueIdx, self._historyRightValueLength - 1 do
      self._dayRightHistoryValue[_earseIndex]:SetShow(false)
    end
  end
  if _historyLeftValueIdx < self._historyLeftValueLength then
    for _earseIndex = _historyLeftValueIdx, self._historyLeftValueLength - 1 do
      self._dayLeftHistoryValue[_earseIndex]:SetShow(false)
    end
  end
  if nil == self._dayCircleValue[_dateValueIdx - 1] then
    self._ui.stc_Line_V:SetShow(false)
  else
    self._ui.stc_Line_V:SetSize(self._ui.stc_Line_V:GetSizeX(), self._dayCircleValue[_dateValueIdx - 1]:GetPosY() + 16)
    self._ui.stc_Line_V:SetShow(true)
  end
  self._ui.frame_HistoryList:UpdateContentScroll()
  self._ui.frame_VScroll:SetControlTop()
  self._ui.frame_HistoryList:UpdateContentPos()
  if _txtYAxis < self._ui.frame_HistoryList:GetSizeY() then
    self._ui.frameBG:SetIgnore(true)
    self._ui.frame_VScroll:SetShow(false)
  else
    self._ui.frame_Content:SetSize(self._ui.frame_Content:GetSizeX(), _txtYAxis + 30)
    self._ui.frameBG:SetSize(self._ui.frame_Content:GetSizeX(), self._ui.frame_Content:GetSizeY())
    self._ui.frameBG:SetIgnore(false)
    self._ui.frame_VScroll:SetShow(true)
  end
  local prevContainer = self._hitoryContainer[self._currentContainerIdx - 1]
  local nextContainer = self._hitoryContainer[self._currentContainerIdx + 1]
  if nil == prevContainer then
    self._ui.stc_RB:SetShow(false)
  else
    self._ui.stc_RB:SetShow(true)
  end
  if nil == nextContainer then
    self._ui.stc_LB:SetShow(false)
  else
    self._ui.stc_LB:SetShow(true)
  end
end
function CharacterHistoryInfo:registEvent()
  registerEvent("FromClient_JournalInfo_UpdateText", "FromClient_CharacterHistoryInfo_updateInfo")
end
function PaGlobalFunc_CharacterHistoryInfo_Open()
  if nil == CharacterHistoryInfo then
    return
  end
  local self = CharacterHistoryInfo
  self:open()
end
function CharacterHistoryInfo:open()
  ToClient_RequestJournalList(self.currentValue._year, self.currentValue._month, self.currentValue._myHistory)
end
function FromClient_luaLoadComplete_Panel_Window_CharacterInfo_History()
  local self = CharacterHistoryInfo
  self:init()
  self.defaultFrameBG_CharacterInfo_History = UI.getChildControl(_mainPanel, "Static_HistoryInfoBg")
  self.defaultFrameBG_CharacterInfo_History:SetShow(false)
  self.defaultFrameBG_CharacterInfo_History:MoveChilds(self.defaultFrameBG_CharacterInfo_History:GetID(), _panel)
  deletePanel(_panel:GetID())
  self:registEvent()
end
function InputMLUp_CharacterHistoryInfo_TapToOpen(monthIdx)
  local self = CharacterHistoryInfo
  self.currentValue._month = monthIdx
  ToClient_RequestJournalList(self.currentValue._year, self.currentValue._month, self.currentValue._myHistory)
end
function InputMLUp_CharacterHistoryInfo_DecreaseMonth()
  local self = CharacterHistoryInfo
  self:updateInfo(self._currentContainerIdx + 1)
end
function InputMLUp_CharacterHistoryInfo_IncreaseMonth()
  local self = CharacterHistoryInfo
  self:updateInfo(self._currentContainerIdx - 1)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Panel_Window_CharacterInfo_History")

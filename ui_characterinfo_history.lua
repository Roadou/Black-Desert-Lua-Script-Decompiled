local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
local UI_color = Defines.Color
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_TM = CppEnums.TextMode
local pastMonth_DayCount = {
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
}
local currentValue = {
  _year = ToClient_GetThisYear(),
  _month = ToClient_GetThisMonth(),
  _day = ToClient_GetToday(),
  _myHistory = 0,
  _guildHistory = 1
}
local monthValue, monthLine, verticalLine, dayLeftValue, dayLeftLine, dayHistoryLeftValue, dayRightValue, dayRightLine, dayHistoryRightValue, _frameHistoryList, _contentHistoryList, _scroll, noScroll_FrameSize
local firstLogYearValue = 2014
local thisYearValue, radioBtn_Year, radioBtn_YearValue, selectedYear, yearLeftButton, yearRightButton
local yearIndex = {}
local radioBtn_YearPosX
local radioBtn_YearGap = 15
local topMonth
local monthIndex = {}
local haveInfoMonth
function monthIndex_Create()
  if nil == Panel_Window_CharInfo_HistoryInfo then
    return
  end
  local _monthCount = 11
  for index = 0, 11 do
    monthIndex[index] = nil
    monthIndex[index] = {}
    monthIndex[index] = UI.createControl(UI_PUCT.PA_UI_CONTROL_RADIOBUTTON, Panel_Window_CharInfo_HistoryInfo, "RadioButton_Month_" .. index + 1)
    CopyBaseProperty(topMonth, monthIndex[index])
    monthIndex[index]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_HISTORY_MONTH", "month", index + 1))
    monthIndex[index]:SetSpanSize((monthIndex[index]:GetSizeX() + 32) * _monthCount + 30, 0)
    monthIndex[index]:addInputEvent("Mouse_LUp", "HandleClicked_MyHistory_MonthCheck(" .. index .. ",true)")
    monthIndex[index]:SetShow(true)
    _monthCount = _monthCount - 1
  end
end
local helpWidget
function helpWidget_Create()
  if nil == Panel_Window_CharInfo_HistoryInfo then
    return
  end
  local _checkedQuestStaticActive = UI.getChildControl(Panel_CheckedQuest, "Static_Active")
  local tooltipBase = UI.getChildControl(_checkedQuestStaticActive, "StaticText_Notice_1")
  helpWidget = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, _contentHistoryList, "HelpWindow_For_CharHistory")
  CopyBaseProperty(tooltipBase, helpWidget)
  helpWidget:SetColor(UI_color.C_FFFFFFFF)
  helpWidget:SetAlpha(1)
  helpWidget:SetFontColor(UI_color.C_FFC4BEBE)
  helpWidget:SetAutoResize(true)
  helpWidget:SetShow(false)
  _contentHistoryList:SetChildIndex(helpWidget, 9999)
end
local _firstOpenCheck = true
function MyHistory_DataUpdate()
  if nil == Panel_Window_CharInfo_HistoryInfo then
    return
  end
  if _firstOpenCheck then
    _firstOpenCheck = false
    HandleClicked_MyHistory_YearCheck(ToClient_GetThisYear() - firstLogYearValue)
    HandleClicked_MyHistory_MonthCheck(ToClient_GetThisMonth() - 1)
    haveInfoMonth = ToClient_GetThisMonth()
    return
  end
  ToClient_RequestJournalList(currentValue._year, currentValue._month, currentValue._myHistory)
end
local _dayHistoryValue = {}
function FromClient_MyHistoryInfo_Update()
  if nil == Panel_Window_CharInfo_HistoryInfo then
    return
  end
  if nil == haveInfoMonth then
    haveInfoMonth = ToClient_GetThisMonth()
  end
  _listCount = ToClient_GetJournalListCount(currentValue._year, currentValue._month, currentValue._myHistory)
  if 0 ~= _listCount or currentValue._year == ToClient_GetThisYear() and currentValue._month == ToClient_GetThisMonth() then
  else
    for i = 0, 11 do
      if haveInfoMonth - 1 == i then
        monthIndex[i]:SetFontColor(UI_color.C_FFFFFFFF)
      else
        monthIndex[i]:SetFontColor(UI_color.C_FF888888)
      end
    end
    return
  end
  _contentHistoryList:DestroyAllChild()
  helpWidget_Create()
  if 0 == currentValue._day then
    for i = 0, 11 do
      if haveInfoMonth - 1 == i then
        monthIndex[i]:SetFontColor(UI_color.C_FFFFFFFF)
      else
        monthIndex[i]:SetFontColor(UI_color.C_FF888888)
      end
    end
    return
  end
  _contentHistoryList:SetIgnore(true)
  local frameContent = {
    _monthValue = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, _contentHistoryList, "StaticText_Month_Value"),
    _monthLine = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, _contentHistoryList, "Static_MonthLine"),
    _verticalLine = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, _contentHistoryList, "Static_VerticalLine")
  }
  CopyBaseProperty(monthValue, frameContent._monthValue)
  CopyBaseProperty(monthLine, frameContent._monthLine)
  CopyBaseProperty(verticalLine, frameContent._verticalLine)
  frameContent._monthValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHALLENGE_YEAR", "year", currentValue._year) .. " " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_HISTORY_MONTH", "month", currentValue._month))
  frameContent._monthValue:SetShow(false)
  frameContent._monthLine:SetShow(true)
  frameContent._verticalLine:SetShow(true)
  local sizeY = 10
  local lineGap = 50
  local textSizeY = 23
  local _journalInfo = {}
  local emptyDay = 0
  local _dayValue = {}
  local _dayLine = {}
  local dayLogCount = 1
  local firstDay = 0
  for dayIndex = currentValue._day, 1, -1 do
    _dayValue[dayIndex] = {}
    _dayLine[dayIndex] = {}
    if 1 == dayLogCount % 2 then
      local _dayLeftValue = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, _contentHistoryList, "StaticText_DayLeft_Value_" .. dayIndex)
      local _dayLeftLine = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, _contentHistoryList, "Static_DayLeftLine_" .. dayIndex)
      CopyBaseProperty(dayLeftValue, _dayLeftValue)
      CopyBaseProperty(dayLeftLine, _dayLeftLine)
      _dayValue[dayIndex] = _dayLeftValue
      _dayLine[dayIndex] = _dayLeftLine
    else
      local _dayRightValue = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, _contentHistoryList, "StaticText_DayRight_Value_" .. dayIndex)
      local _dayRightLine = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, _contentHistoryList, "Static_DayRightLine" .. dayIndex)
      CopyBaseProperty(dayRightValue, _dayRightValue)
      CopyBaseProperty(dayRightLine, _dayRightLine)
      _dayValue[dayIndex] = _dayRightValue
      _dayLine[dayIndex] = _dayRightLine
    end
    local checkLog = false
    for i = _listCount - 1, 0, -1 do
      _journalInfo[i] = {}
      _journalInfo[i] = ToClient_GetJournal(currentValue._year, currentValue._month, currentValue._myHistory, i)
      if nil ~= _journalInfo[i] and dayIndex == _journalInfo[i]:getJournalDay() then
        if false == checkLog then
          checkLog = true
        end
        sizeY = sizeY + textSizeY
        if 1 == dayLogCount % 2 then
          local _dayHistoryLeftValue = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, _contentHistoryList, "StaticText_MyHistory_" .. i)
          CopyBaseProperty(dayHistoryLeftValue, _dayHistoryLeftValue)
          _dayHistoryValue[i] = _dayHistoryLeftValue
          _dayHistoryValue[i]:addInputEvent("Mouse_On", "MyHistory_HelpWidget_Show(true," .. i .. ", true)")
          _dayHistoryValue[i]:addInputEvent("Mouse_Out", "MyHistory_HelpWidget_Show(false)")
        else
          local _dayHistoryRightValue = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, _contentHistoryList, "StaticText_MyHistory_" .. i)
          CopyBaseProperty(dayHistoryRightValue, _dayHistoryRightValue)
          _dayHistoryValue[i] = _dayHistoryRightValue
          _dayHistoryValue[i]:addInputEvent("Mouse_On", "MyHistory_HelpWidget_Show(true," .. i .. ", false)")
          _dayHistoryValue[i]:addInputEvent("Mouse_Out", "MyHistory_HelpWidget_Show(false)")
        end
        _dayHistoryValue[i]:SetAutoResize(true)
        _dayHistoryValue[i]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
        _dayHistoryValue[i]:SetText(tostring(_journalInfo[i]:getName()))
        _dayHistoryValue[i]:SetPosY(sizeY + 30)
        _dayHistoryValue[i]:SetShow(true)
        _dayHistoryValue[i]:SetIgnore(false)
      end
    end
    if true == checkLog then
      sizeY = sizeY + lineGap
      _dayValue[dayIndex]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_HISTORY_DAY", "day", dayIndex))
      _dayValue[dayIndex]:SetShow(true)
      _dayLine[dayIndex]:SetShow(true)
      _dayValue[dayIndex]:SetPosY(sizeY + 15)
      _dayLine[dayIndex]:SetPosY(sizeY + 20)
      dayLogCount = dayLogCount + 1
      firstDay = dayIndex
    end
  end
  if firstDay > 0 then
    _contentHistoryList:SetSize(_contentHistoryList:GetSizeX(), _dayLine[firstDay]:GetPosY() + 50)
    frameContent._verticalLine:SetSize(frameContent._verticalLine:GetSizeX(), _dayLine[firstDay]:GetPosY() - 20)
    frameContent._verticalLine:SetShow(true)
    if noScroll_FrameSize < _dayLine[firstDay]:GetPosY() + 50 then
      _scroll:SetShow(true)
    else
      _scroll:SetShow(false)
    end
  else
    frameContent._verticalLine:SetSize(frameContent._verticalLine:GetSizeX(), noScroll_FrameSize)
    frameContent._verticalLine:SetShow(false)
    _contentHistoryList:SetSize(_contentHistoryList:GetSizeX(), noScroll_FrameSize)
    _scroll:SetShow(false)
  end
  _scroll:SetInterval(_contentHistoryList:GetSizeY() / 100 * 1.1)
  _frameHistoryList:UpdateContentScroll()
  _scroll:SetControlTop()
  _frameHistoryList:UpdateContentPos()
  haveInfoMonth = currentValue._month
end
function MyHistory_HelpWidget_Show(isShow, index, isLeft)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local journalInfo = ToClient_GetJournal(currentValue._year, currentValue._month, currentValue._myHistory, index)
  if nil == journalInfo then
    TooltipSimple_Hide()
    return
  end
  if nil == Panel_Window_CharInfo_HistoryInfo then
    return
  end
  local name = ""
  local helpName = tostring(journalInfo:getName())
  local helpDesc = "<PAColor0xFFFFF3AF>" .. PAGetStringParam3(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_HISTORY_TIME", "hour", journalInfo:getJournalHour(), "minute", journalInfo:getJournalMinute(), "second", journalInfo:getJournalSecond()) .. "<PAOldColor>"
  local desc = helpName .. "\n" .. helpDesc
  TooltipSimple_Show(_dayHistoryValue[index], name, desc)
end
function HandleClicked_MyHistory_MonthCheck(index, audioFlag)
  if nil == Panel_Window_CharInfo_HistoryInfo then
    return
  end
  if true == audioFlag then
    audioPostEvent_SystemUi(0, 0)
  end
  for i = 0, 11 do
    if index == i then
      monthIndex[i]:SetFontColor(UI_color.C_FFFFFFFF)
    else
      monthIndex[i]:SetFontColor(UI_color.C_FF888888)
    end
  end
  monthIndex[index]:SetCheck(true)
  currentValue._month = index + 1
  if ToClient_GetThisYear() <= currentValue._year and ToClient_GetThisMonth() < currentValue._month then
    currentValue._day = 0
  end
  if ToClient_GetThisMonth() == currentValue._month then
    currentValue._day = ToClient_GetToday()
  else
    currentValue._day = pastMonth_DayCount[index + 1]
  end
  MyHistory_DataUpdate()
end
function HandleClicked_MyHistory_YearCheck(index)
  if nil == Panel_Window_CharInfo_HistoryInfo then
    return
  end
  currentValue._year = firstLogYearValue + index
  radioBtn_YearValue:SetText(currentValue._year)
  selectedYear:SetText(currentValue._year)
  if firstLogYearValue < currentValue._year then
    yearLeftButton:SetShow(true)
  else
    yearLeftButton:SetShow(false)
  end
  if ToClient_GetThisYear() > currentValue._year then
    yearRightButton:SetShow(true)
  else
    yearRightButton:SetShow(false)
  end
  if currentValue._year == ToClient_GetThisYear() then
    HandleClicked_MyHistory_MonthCheck(ToClient_GetThisMonth() - 1)
  else
    HandleClicked_MyHistory_MonthCheck(11)
  end
  yearLeftButton:addInputEvent("Mouse_LUp", "HandleClicked_MyHistory_YearCheck(" .. currentValue._year - firstLogYearValue - 1 .. ")")
  yearRightButton:addInputEvent("Mouse_LUp", "HandleClicked_MyHistory_YearCheck(" .. currentValue._year - firstLogYearValue + 1 .. ")")
end
local function initializeHistoryInfo()
  if nil == Panel_Window_CharInfo_HistoryInfo then
    return
  end
  Panel_Window_CharInfo_HistoryInfo:SetShow(false)
  monthValue = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "StaticText_MainMonth")
  monthLine = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "Static_HorizontalCenter")
  verticalLine = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "Static_VerticalLine")
  dayLeftValue = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "StaticText_DayLeft_Value")
  dayLeftLine = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "Static_HorizontalLeft")
  dayHistoryLeftValue = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "StaticText_HistoryLeftList")
  dayRightValue = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "StaticText_DayRight_Value")
  dayRightLine = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "Static_HorizontalRight")
  dayHistoryRightValue = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "StaticText_HistoryRightList")
  _frameHistoryList = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "Frame_HistoryList")
  _contentHistoryList = UI.getChildControl(_frameHistoryList, "Frame_1_Content")
  _scroll = UI.getChildControl(_frameHistoryList, "Frame_1_VerticalScroll")
  noScroll_FrameSize = _frameHistoryList:GetSizeY()
  _frameHistoryList:SetIgnore(false)
  firstLogYearValue = 2014
  thisYearValue = currentValue._year
  radioBtn_Year = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "RadioButton_YearStic")
  radioBtn_YearValue = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "StaticText_YearSticText")
  selectedYear = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "StaticText_SelectYearValue")
  yearLeftButton = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "Button_Year_Left")
  yearRightButton = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "Button_Year_Right")
  radioBtn_YearPosX = radioBtn_Year:GetPosX()
  radioBtn_YearGap = 15
  topMonth = UI.getChildControl(Panel_Window_CharInfo_HistoryInfo, "RadioButton_Month")
end
local registMessageHandler = function()
  registerEvent("FromClient_JournalInfo_UpdateText", "FromClient_MyHistoryInfo_Update")
end
function FromClient_CharacterInfoHistory_Init()
  PaGlobal_CharacterInfoHistory_Init()
  registMessageHandler()
end
function PaGlobal_CharacterInfoHistory_Init()
  _firstOpenCheck = true
  initializeHistoryInfo()
  monthIndex_Create()
  MyHistory_DataUpdate()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_CharacterInfoHistory_Init")

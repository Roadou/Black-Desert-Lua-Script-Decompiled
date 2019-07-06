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
local guildHistory = {
  _ui = {
    defaultFrameBG_History = nil,
    monthValue = nil,
    monthLine = nil,
    verticalLine = nil,
    dayLeftValue = nil,
    dayLeftLine = nil,
    dayHistoryLeftValue = nil,
    dayRightValue = nil,
    dayRightLine = nil,
    dayHistoryRightValue = nil,
    _frameHistoryList = nil,
    _contentHistoryList = nil,
    _scroll = nil,
    radioBtn_Year = nil,
    radioBtn_YearValue = nil,
    selectedYear = nil,
    yearLeftButton = nil,
    yearRightButton = nil,
    topMonth = nil
  },
  noScroll_FrameSize = 0,
  monthIndex = {},
  haveInfoMonth = nil,
  radioBtn_YearPosX = nil,
  radioBtn_YearGap = 15
}
local firstLogYearValue = 2014
function guildHistory:initialize()
  if nil == Panel_Guild_Journal then
    return
  end
  Panel_Guild_Journal:SetShow(false)
  guildHistory._ui.monthValue = UI.getChildControl(Panel_Guild_Journal, "StaticText_MainMonth")
  guildHistory._ui.monthLine = UI.getChildControl(Panel_Guild_Journal, "Static_HorizontalCenter")
  guildHistory._ui.verticalLine = UI.getChildControl(Panel_Guild_Journal, "Static_VerticalLine")
  guildHistory._ui.dayLeftValue = UI.getChildControl(Panel_Guild_Journal, "StaticText_DayLeft_Value")
  guildHistory._ui.dayLeftLine = UI.getChildControl(Panel_Guild_Journal, "Static_HorizontalLeft")
  guildHistory._ui.dayHistoryLeftValue = UI.getChildControl(Panel_Guild_Journal, "StaticText_HistoryLeftList")
  guildHistory._ui.dayRightValue = UI.getChildControl(Panel_Guild_Journal, "StaticText_DayRight_Value")
  guildHistory._ui.dayRightLine = UI.getChildControl(Panel_Guild_Journal, "Static_HorizontalRight")
  guildHistory._ui.dayHistoryRightValue = UI.getChildControl(Panel_Guild_Journal, "StaticText_HistoryRightList")
  guildHistory._ui._frameHistoryList = UI.getChildControl(Panel_Guild_Journal, "Frame_HistoryList")
  guildHistory._ui._contentHistoryList = UI.getChildControl(guildHistory._ui._frameHistoryList, "Frame_1_Content")
  guildHistory._ui._scroll = UI.getChildControl(guildHistory._ui._frameHistoryList, "Frame_1_VerticalScroll")
  guildHistory._ui._scroll:SetShow(false)
  guildHistory._ui.radioBtn_Year = UI.getChildControl(Panel_Guild_Journal, "RadioButton_YearStic")
  guildHistory._ui.radioBtn_YearValue = UI.getChildControl(Panel_Guild_Journal, "StaticText_YearSticText")
  guildHistory._ui.selectedYear = UI.getChildControl(Panel_Guild_Journal, "StaticText_SelectYearValue")
  guildHistory._ui.yearLeftButton = UI.getChildControl(Panel_Guild_Journal, "Button_Year_Left")
  guildHistory._ui.yearRightButton = UI.getChildControl(Panel_Guild_Journal, "Button_Year_Right")
  guildHistory.noScroll_FrameSize = guildHistory._ui._frameHistoryList:GetSizeY()
  guildHistory._ui._frameHistoryList:SetIgnore(false)
  guildHistory._ui.topMonth = UI.getChildControl(Panel_Guild_Journal, "RadioButton_Month")
  local _monthCount = 11
  for index = 0, 11 do
    guildHistory.monthIndex[index] = nil
    guildHistory.monthIndex[index] = {}
    guildHistory.monthIndex[index] = UI.createControl(UI_PUCT.PA_UI_CONTROL_RADIOBUTTON, Panel_Guild_Journal, "RadioButton_Month_" .. index + 1)
    CopyBaseProperty(guildHistory._ui.topMonth, guildHistory.monthIndex[index])
    guildHistory.monthIndex[index]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_HISTORY_MONTH", "month", index + 1))
    guildHistory.monthIndex[index]:SetSpanSize((guildHistory.monthIndex[index]:GetSizeX() + 20) * _monthCount + 40, 65)
    guildHistory.monthIndex[index]:addInputEvent("Mouse_LUp", "HandleClicked_GuildHistory_MonthCheck(" .. index .. ")")
    guildHistory.monthIndex[index]:SetShow(true)
    _monthCount = _monthCount - 1
  end
  guildHistory.radioBtn_YearPosX = guildHistory._ui.radioBtn_Year:GetPosX()
  guildHistory._ui.defaultFrameBG_History = UI.getChildControl(Panel_Window_Guild, "Static_Frame_Journal")
  guildHistory._ui.defaultFrameBG_History:MoveChilds(guildHistory._ui.defaultFrameBG_History:GetID(), Panel_Guild_Journal)
  HandleClicked_GuildHistory_YearCheck(currentValue._year - firstLogYearValue)
  HandleClicked_GuildHistory_MonthCheck(currentValue._month - 1)
end
function guildHistory:registMessageHandler()
  registerEvent("FromClient_JournalInfo_UpdateText", "FromClient_GuildHistoryInfo_Update")
end
local helpWidget
function guild_helpWidget_Create()
  if nil == Panel_Guild_Journal then
    return
  end
  local tooltipBase = UI.getChildControl(Panel_CheckedQuest, "StaticText_Notice_1")
  helpWidget = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, guildHistory._ui._contentHistoryList, "HelpWindow_For_GuildHistory")
  CopyBaseProperty(tooltipBase, helpWidget)
  helpWidget:SetColor(UI_color.C_FFFFFFFF)
  helpWidget:SetAlpha(1)
  helpWidget:SetFontColor(UI_color.C_FFC4BEBE)
  helpWidget:SetAutoResize(true)
  helpWidget:SetShow(false)
  guildHistory._ui._contentHistoryList:SetChildIndex(helpWidget, 9999)
end
local _firstOpenCheck = true
function GuildHistory_DataUpdate()
  if _firstOpenCheck then
    _firstOpenCheck = false
    guildHistory.haveInfoMonth = ToClient_GetThisMonth()
    return
  end
  ToClient_RequestJournalList(currentValue._year, currentValue._month, currentValue._guildHistory)
end
local _dayHistoryValue = {}
function FromClient_GuildHistoryInfo_Update()
  if nil == Panel_Guild_Journal then
    return
  end
  if nil == guildHistory.haveInfoMonth then
    return
  end
  _listCount = ToClient_GetJournalListCount(currentValue._year, currentValue._month, currentValue._guildHistory)
  if 0 ~= _listCount or currentValue._year == ToClient_GetThisYear() and currentValue._month == ToClient_GetThisMonth() then
  else
    for i = 0, 11 do
      if guildHistory.haveInfoMonth - 1 == i then
        guildHistory.monthIndex[i]:SetFontColor(UI_color.C_FFFFFFFF)
      else
        guildHistory.monthIndex[i]:SetFontColor(UI_color.C_FF888888)
      end
    end
    return
  end
  guildHistory._ui._contentHistoryList:DestroyAllChild()
  guildHistory._ui._contentHistoryList:SetIgnore(true)
  if 0 == currentValue._day then
    for i = 0, 11 do
      if guildHistory.haveInfoMonth - 1 == i then
        guildHistory.monthIndex[i]:SetFontColor(UI_color.C_FFFFFFFF)
      else
        guildHistory.monthIndex[i]:SetFontColor(UI_color.C_FF888888)
      end
    end
    return
  end
  local frameContent = {
    _monthValue = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, guildHistory._ui._contentHistoryList, "StaticText_Month_Value"),
    _monthLine = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, guildHistory._ui._contentHistoryList, "Static_MonthLine"),
    _verticalLine = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, guildHistory._ui._contentHistoryList, "Static_VerticalLine")
  }
  CopyBaseProperty(guildHistory._ui.monthValue, frameContent._monthValue)
  CopyBaseProperty(guildHistory._ui.monthLine, frameContent._monthLine)
  CopyBaseProperty(guildHistory._ui.verticalLine, frameContent._verticalLine)
  frameContent._monthValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", currentValue._year) .. " " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_HISTORY_MONTH", "month", currentValue._month))
  frameContent._monthValue:SetShow(true)
  frameContent._monthLine:SetShow(false)
  frameContent._verticalLine:SetShow(true)
  local sizeY = 10
  local lineGap = 30
  local textSizeY = 20
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
      local _dayLeftValue = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, guildHistory._ui._contentHistoryList, "StaticText_DayLeft_Value_" .. dayIndex)
      local _dayLeftLine = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, guildHistory._ui._contentHistoryList, "Static_DayLeftLine_" .. dayIndex)
      CopyBaseProperty(guildHistory._ui.dayLeftValue, _dayLeftValue)
      CopyBaseProperty(guildHistory._ui.dayLeftLine, _dayLeftLine)
      _dayValue[dayIndex] = _dayLeftValue
      _dayLine[dayIndex] = _dayLeftLine
    else
      local _dayRightValue = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, guildHistory._ui._contentHistoryList, "StaticText_DayRight_Value_" .. dayIndex)
      local _dayRightLine = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, guildHistory._ui._contentHistoryList, "Static_DayRightLine" .. dayIndex)
      CopyBaseProperty(guildHistory._ui.dayRightValue, _dayRightValue)
      CopyBaseProperty(guildHistory._ui.dayRightLine, _dayRightLine)
      _dayValue[dayIndex] = _dayRightValue
      _dayLine[dayIndex] = _dayRightLine
    end
    local checkLog = false
    for i = _listCount - 1, 0, -1 do
      _journalInfo[i] = {}
      _journalInfo[i] = ToClient_GetJournal(currentValue._year, currentValue._month, currentValue._guildHistory, i)
      if nil ~= _journalInfo[i] and dayIndex == _journalInfo[i]:getJournalDay() then
        if false == checkLog then
          checkLog = true
        end
        sizeY = sizeY + textSizeY
        if 1 == dayLogCount % 2 then
          local _dayHistoryLeftValue = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, guildHistory._ui._contentHistoryList, "StaticText_GuildHistory_" .. i)
          CopyBaseProperty(guildHistory._ui.dayHistoryLeftValue, _dayHistoryLeftValue)
          _dayHistoryValue[i] = _dayHistoryLeftValue
          _dayHistoryValue[i]:SetText(tostring(_journalInfo[i]:getName()))
          _dayHistoryValue[i]:addInputEvent("Mouse_On", "GuildHistory_HelpWidget_Show(true," .. i .. ", true)")
          _dayHistoryValue[i]:addInputEvent("Mouse_Out", "GuildHistory_HelpWidget_Show(false)")
        else
          local _dayHistoryRightValue = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, guildHistory._ui._contentHistoryList, "StaticText_GuildHistory_" .. i)
          CopyBaseProperty(guildHistory._ui.dayHistoryRightValue, _dayHistoryRightValue)
          _dayHistoryValue[i] = _dayHistoryRightValue
          _dayHistoryValue[i]:SetText(tostring(_journalInfo[i]:getName()))
          _dayHistoryValue[i]:addInputEvent("Mouse_On", "GuildHistory_HelpWidget_Show(true," .. i .. ", false)")
          _dayHistoryValue[i]:addInputEvent("Mouse_Out", "GuildHistory_HelpWidget_Show(false)")
        end
        _dayHistoryValue[i]:SetAutoResize(true)
        _dayHistoryValue[i]:SetPosY(sizeY + 20)
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
    guildHistory._ui._contentHistoryList:SetSize(guildHistory._ui._contentHistoryList:GetSizeX(), _dayLine[firstDay]:GetPosY() + 50)
    frameContent._verticalLine:SetSize(frameContent._verticalLine:GetSizeX(), _dayLine[firstDay]:GetPosY())
    frameContent._verticalLine:SetShow(true)
    if guildHistory.noScroll_FrameSize < _dayLine[firstDay]:GetPosY() + 50 then
      guildHistory._ui._scroll:SetShow(true)
    else
      guildHistory._ui._scroll:SetShow(false)
    end
  else
    frameContent._verticalLine:SetSize(frameContent._verticalLine:GetSizeX(), guildHistory.noScroll_FrameSize)
    frameContent._verticalLine:SetShow(false)
    guildHistory._ui._contentHistoryList:SetSize(guildHistory._ui._contentHistoryList:GetSizeX(), guildHistory.noScroll_FrameSize)
    guildHistory._ui._scroll:SetShow(false)
  end
  guildHistory._ui._scroll:SetInterval(guildHistory._ui._contentHistoryList:GetSizeY() / 100 * 1.1)
  guildHistory._ui._frameHistoryList:UpdateContentScroll()
  guildHistory._ui._scroll:SetControlTop()
  guildHistory._ui._frameHistoryList:UpdateContentPos()
  guildHistory.haveInfoMonth = currentValue._month
end
function GuildHistory_HelpWidget_Show(isShow, index, isLeft)
  if nil == index then
    TooltipSimple_Hide()
    return
  end
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local journalInfo = ToClient_GetJournal(currentValue._year, currentValue._month, currentValue._guildHistory, index)
  if nil == journalInfo then
    TooltipSimple_Hide()
    return
  end
  local name = ""
  local helpName = tostring(journalInfo:getName())
  local helpDesc = "<PAColor0xFFFFF3AF>" .. PAGetStringParam3(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_HISTORY_TIME", "hour", journalInfo:getJournalHour(), "minute", journalInfo:getJournalMinute(), "second", journalInfo:getJournalSecond()) .. "<PAOldColor>"
  local desc = helpName .. "\n" .. helpDesc
  TooltipSimple_Show(_dayHistoryValue[index], name, desc)
end
function HandleClicked_GuildHistory_MonthCheck(index)
  if nil == Panel_Guild_Journal then
    return
  end
  for i = 0, 11 do
    if index == i then
      guildHistory.monthIndex[i]:SetFontColor(UI_color.C_FFFFFFFF)
    else
      guildHistory.monthIndex[i]:SetFontColor(UI_color.C_FF888888)
    end
  end
  guildHistory.monthIndex[index]:SetCheck(true)
  currentValue._month = index + 1
  if ToClient_GetThisYear() <= currentValue._year and ToClient_GetThisMonth() < currentValue._month then
    currentValue._day = 0
  end
  if ToClient_GetThisMonth() == currentValue._month then
    currentValue._day = ToClient_GetToday()
  else
    currentValue._day = pastMonth_DayCount[index + 1]
  end
  GuildHistory_DataUpdate()
end
function HandleClicked_GuildHistory_YearCheck(index)
  if nil == Panel_Guild_Journal then
    return
  end
  currentValue._year = firstLogYearValue + index
  guildHistory._ui.radioBtn_YearValue:SetText(currentValue._year)
  guildHistory._ui.selectedYear:SetText(currentValue._year)
  local sizeX = guildHistory.radioBtn_YearPosX
  if firstLogYearValue < currentValue._year then
    guildHistory._ui.yearLeftButton:SetShow(true)
  else
    guildHistory._ui.yearLeftButton:SetShow(false)
  end
  if ToClient_GetThisYear() > currentValue._year then
    guildHistory._ui.yearRightButton:SetShow(true)
  else
    guildHistory._ui.yearRightButton:SetShow(false)
  end
  if true == _ContentsGroup_RenewUI then
    if currentValue._year == ToClient_GetThisYear() then
      InputMLUp_CharacterHistoryInfo_TapToOpen(ToClient_GetThisMonth())
    else
      InputMLUp_CharacterHistoryInfo_TapToOpen(12)
    end
  elseif currentValue._year == ToClient_GetThisYear() then
    HandleClicked_MyHistory_MonthCheck(ToClient_GetThisMonth() - 1)
  else
    HandleClicked_MyHistory_MonthCheck(11)
  end
  guildHistory._ui.yearLeftButton:addInputEvent("Mouse_LUp", "HandleClicked_GuildHistory_YearCheck(" .. currentValue._year - firstLogYearValue - 1 .. ")")
  guildHistory._ui.yearRightButton:addInputEvent("Mouse_LUp", "HandleClicked_GuildHistory_YearCheck(" .. currentValue._year - firstLogYearValue + 1 .. ")")
end
function FGlobal_GuildHistory_Show(isShow)
  if nil == Panel_Guild_Journal then
    return
  end
  if isShow == true then
    guildHistory._ui.defaultFrameBG_History:SetShow(true)
    GuildHistory_DataUpdate()
  else
    guildHistory._ui.defaultFrameBG_History:SetShow(false)
  end
end
function FromClient_GuildHistory_Init()
  PaGlobal_GuildHistory_Init()
  guildHistory:registMessageHandler()
end
function PaGlobal_GuildHistory_Init()
  guildHistory:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildHistory_Init")

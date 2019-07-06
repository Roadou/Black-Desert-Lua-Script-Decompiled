local _panel = Panel_Worldmap_WarFilter_Renew
local WarFilter = {
  _ui = {
    txt_categoryLeft = UI.getChildControl(_panel, "StaticText_CategoryLeft"),
    txt_categoryRight = UI.getChildControl(_panel, "StaticText_CategoryRight"),
    btn_template = UI.getChildControl(_panel, "Button_FilterTemplate"),
    stc_bottomKeyGuide = UI.getChildControl(_panel, "Static_BottomKeyBG"),
    btn_gradeFilters = {},
    btn_dayFilters = {},
    stc_selectedGrade = {},
    stc_selectedDay = {},
    txt_gradeFilterNames = {},
    txt_dayFilterNames = {},
    stc_gradeCheck = {},
    stc_dayCheck = {}
  },
  _gradeCount = 4,
  _dayCount = nil,
  _currentGradeFilter = 1,
  _currentDayFilter = 1,
  _currentColumn = 1
}
local _buttonStrings = {
  [1] = {
    PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SELECTDEFALUT"),
    PAGetString(Defines.StringSheet_GAME, "LUA_NODEGRADE_0"),
    PAGetString(Defines.StringSheet_GAME, "LUA_NODEGRADE_1"),
    PAGetString(Defines.StringSheet_GAME, "LUA_NODEGRADE_2"),
    PAGetString(Defines.StringSheet_GAME, "LUA_NODEGRADE_3")
  },
  [2] = {
    PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SELECTDEFALUT"),
    PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SUNDAY_COLOR"),
    PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_MONDAY_COLOR"),
    PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_TUESDAY_COLOR"),
    PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_WEDNESDAY_COLOR"),
    PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_THUSDAY_COLOR"),
    PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_FRIDAY_COLOR"),
    PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SATURDAY_COLOR")
  }
}
function FromClient_luaLoadComplete_WarFilter()
  WarFilter:init()
end
function FromClient_WarFilter_OnScreenResize()
  WarFilter:resize()
end
registerEvent("onScreenResize", "FromClient_WarFilter_OnScreenResize")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_WarFilter")
function WarFilter:init()
  self._ui.txt_categoryLeft:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui.txt_categoryRight:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui.txt_categoryLeft:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SELECTTAXGRADE"))
  self._ui.txt_categoryRight:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SELECTDAY"))
  for ii = 1, self._gradeCount + 1 do
    self._ui.btn_gradeFilters[ii] = UI.cloneControl(self._ui.btn_template, _panel, "Button_GradeFilter_" .. ii)
    self._ui.btn_gradeFilters[ii]:SetPosX(self._ui.btn_template:GetPosX())
    self._ui.btn_gradeFilters[ii]:SetPosY(self._ui.btn_template:GetPosY() + (ii - 1) * 49)
    self._ui.btn_gradeFilters[ii]:addInputEvent("Mouse_On", "InputMOn_WarFilter_GradeFilter(" .. ii .. ")")
    self._ui.stc_selectedGrade[ii] = UI.getChildControl(self._ui.btn_gradeFilters[ii], "Static_Selected")
    self._ui.stc_selectedGrade[ii]:SetShow(false)
    self._ui.stc_gradeCheck[ii] = UI.getChildControl(self._ui.btn_gradeFilters[ii], "Static_Check")
    self._ui.stc_gradeCheck[ii]:SetShow(false)
    self._ui.txt_gradeFilterNames[ii] = UI.getChildControl(self._ui.btn_gradeFilters[ii], "StaticText_FilterName")
    self._ui.txt_gradeFilterNames[ii]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    self._ui.txt_gradeFilterNames[ii]:SetText(_buttonStrings[1][ii])
  end
  self._dayCount = CppEnums.VillageSiegeType.eVillageSiegeType_Count
  for ii = 1, self._dayCount + 1 do
    self._ui.btn_dayFilters[ii] = UI.cloneControl(self._ui.btn_template, _panel, "Button_DayFilter_" .. ii)
    self._ui.btn_dayFilters[ii]:SetPosX(self._ui.btn_template:GetPosX() + 185)
    self._ui.btn_dayFilters[ii]:SetPosY(self._ui.btn_template:GetPosY() + (ii - 1) * 49)
    self._ui.btn_dayFilters[ii]:addInputEvent("Mouse_On", "InputMOn_WarFilter_DayFilter(" .. ii .. ")")
    self._ui.stc_selectedDay[ii] = UI.getChildControl(self._ui.btn_dayFilters[ii], "Static_Selected")
    self._ui.stc_selectedDay[ii]:SetShow(false)
    self._ui.stc_dayCheck[ii] = UI.getChildControl(self._ui.btn_dayFilters[ii], "Static_Check")
    self._ui.stc_dayCheck[ii]:SetShow(false)
    self._ui.txt_dayFilterNames[ii] = UI.getChildControl(self._ui.btn_dayFilters[ii], "StaticText_FilterName")
    self._ui.txt_dayFilterNames[ii]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    self._ui.txt_dayFilterNames[ii]:SetText(_buttonStrings[2][ii])
  end
  self._ui.btn_template:SetShow(false)
  local bottomButton = self._ui.btn_dayFilters[#self._ui.btn_dayFilters]
  local bottomPoint = bottomButton:GetPosY() + bottomButton:GetSizeY()
  _panel:SetSize(_panel:GetSizeX(), bottomPoint + self._ui.stc_bottomKeyGuide:GetSizeY())
  self._ui.stc_bottomKeyGuide:ComputePos()
  self:resize()
end
function PaGlobaFunc_WarFilter_GetShow()
  return _panel:GetShow()
end
function PaGlobaFunc_WarFilter_Open()
  WarFilter:open()
end
function WarFilter:open()
  self:setGradeFilterTo(self._currentGradeFilter)
  self:setDayFilterTo(self._currentDayFilter)
  self:snapToColumn(self._currentColumn)
  _panel:SetShow(true)
end
function InputMOn_WarFilter_GradeFilter(index)
  WarFilter:setGradeFilterTo(index)
end
function WarFilter:setGradeFilterTo(index)
  self._ui.stc_gradeCheck[self._currentGradeFilter]:SetShow(false)
  self._ui.stc_selectedGrade[self._currentGradeFilter]:SetShow(false)
  if index > self._gradeCount + 1 then
    self._currentGradeFilter = 1
  elseif index < 1 then
    self._currentGradeFilter = self._gradeCount + 1
  else
    self._currentGradeFilter = index
  end
  self._ui.stc_gradeCheck[self._currentGradeFilter]:SetShow(true)
  self._ui.stc_selectedGrade[self._currentGradeFilter]:SetShow(true)
end
function InputMOn_WarFilter_DayFilter(index)
  WarFilter:setDayFilterTo(index)
end
function WarFilter:setDayFilterTo(index)
  self._ui.stc_dayCheck[self._currentDayFilter]:SetShow(false)
  self._ui.stc_selectedDay[self._currentDayFilter]:SetShow(false)
  if index > self._dayCount + 1 then
    self._currentDayFilter = 1
  elseif index < 1 then
    self._currentDayFilter = self._dayCount + 1
  else
    self._currentDayFilter = index
  end
  self._ui.stc_dayCheck[self._currentDayFilter]:SetShow(true)
  self._ui.stc_selectedDay[self._currentDayFilter]:SetShow(true)
end
function WarFilter:snapToColumn(index)
  self._ui.stc_selectedGrade[self._currentGradeFilter]:SetShow(1 == index)
  self._ui.stc_selectedDay[self._currentDayFilter]:SetShow(2 == index)
  self._currentColumn = index
end
function Input_WarFilter_DPad(dPadtype)
  local self = WarFilter
  if dPadtype == __eJoyPadInputType_DPad_Down then
    if 1 == self._currentColumn then
      self:setGradeFilterTo(self._currentGradeFilter + 1)
    elseif 2 == self._currentColumn then
      self:setDayFilterTo(self._currentDayFilter + 1)
    end
  elseif dPadtype == __eJoyPadInputType_DPad_Up then
    if 1 == self._currentColumn then
      self:setGradeFilterTo(self._currentGradeFilter - 1)
    elseif 2 == self._currentColumn then
      self:setDayFilterTo(self._currentDayFilter - 1)
    end
  elseif dPadtype == __eJoyPadInputType_DPad_Left then
    self:snapToColumn(1)
  elseif dPadtype == __eJoyPadInputType_DPad_Right then
    self:snapToColumn(2)
  end
end
function PaGlobaFunc_WarFilter_Close()
  WarFilter:close()
end
function PaGlobaFunc_WarFilter_ApplyAndClose()
  WarFilter:apply()
  WarFilter:close()
  ToClient_WorldmapEraseFocusedUi()
end
function WarFilter:apply()
  if 1 == self._currentGradeFilter then
    ToClient_resetVisibleVillageSiegeTaxLevel()
  else
    ToClient_setVisibleVillageSiegeTaxLevel(self._currentGradeFilter - 2)
  end
  if 1 == self._currentDayFilter then
    ToClient_resetVisibleVillageSiegeType()
  else
    ToClient_setVisibleVillageSiegeType(self._currentDayFilter - 2)
  end
end
function WarFilter:close()
  _panel:SetShow(false)
end
function WarFilter:resize()
  _panel:ComputePos()
end

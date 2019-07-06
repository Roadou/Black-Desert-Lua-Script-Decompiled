local _panel = Panel_Window_InstallationMode_VillageTentPopUp_Renew
_panel:SetShow(false)
_panel:setMaskingChild(true)
_panel:ActiveMouseEventEffect(true)
_panel:setGlassBackground(true)
local VillageTentPopup = {
  _ui = {
    bg = UI.getChildControl(_panel, "Static_VillageTentBG"),
    txt_dateTemplate = UI.getChildControl(_panel, "StaticText_DayTemplate"),
    txt_regionTemplate = UI.getChildControl(_panel, "StaticText_RegionTemplate"),
    txt_joinDesc = UI.getChildControl(_panel, "StaticText_VillageTent_JoinDesc"),
    stc_bottomBG = UI.getChildControl(_panel, "Static_NoticeBg"),
    txt_bottomDesc = UI.getChildControl(_panel, "StaticText_NoticeDesc"),
    stc_lineVertical = UI.getChildControl(_panel, "Static_PartLineVertical"),
    stc_keyGuideBG = UI.getChildControl(_panel, "Static_KeyGuideArea")
  }
}
local _regionInfoWrapper = {}
local _dayControl = {}
local _dayCount = 0
local posY = 0
local textGap = 35
local maxCount = 7
local dayString = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SUNDAY"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_MONDAY"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_TUESDAY"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_WEDNESDAY"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_THUSDAY"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_FRIDAY"),
  [6] = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SATURDAY")
}
function FromClient_luaLoadComplete_VillageTentPopup()
  VillageTentPopup:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_VillageTentPopup")
local self = VillageTentPopup
function VillageTentPopup:initialize()
  posY = self._ui.txt_dateTemplate:GetPosY()
  self._ui.txt_bottomDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_bottomDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_VILLAGETENTPOPUP_DESC"))
  self._ui.txt_joinDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_dateTemplate:SetShow(false)
  self._ui.txt_regionTemplate:SetShow(false)
  self._ui.keyGuide_A = UI.getChildControl(self._ui.stc_keyGuideBG, "StaticText_Confirm_ConsoleUI")
  self._ui.keyGuide_B = UI.getChildControl(self._ui.stc_keyGuideBG, "StaticText_Cancel_ConsoleUI")
  self.keyGuideGroup = {
    self._ui.keyGuide_A,
    self._ui.keyGuide_B
  }
  _dayControl = {}
  local temp = {}
  for index = 0, maxCount - 1 do
    _dayControl[index] = {}
    temp[index] = {}
    temp[index]._day = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, _panel, "StaticText_Day_" .. index)
    CopyBaseProperty(self._ui.txt_dateTemplate, temp[index]._day)
    temp[index]._day:SetPosY(posY + index * textGap)
    temp[index]._day:SetShow(false)
    temp[index]._regionName = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, _panel, "StaticText_RegionName_" .. index)
    CopyBaseProperty(self._ui.txt_regionTemplate, temp[index]._regionName)
    temp[index]._regionName:SetPosY(posY + index * textGap)
    temp[index]._regionName:SetShow(false)
    _dayControl[index] = temp[index]
  end
  self:registerEventHandler()
end
function VillageTentPopup:registerEventHandler()
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "Input_VillageTentPopup_SetRegion()")
end
function PaGlobalFunc_VillageTentPopup_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_VillageTentPopup_Open()
  if _panel:GetShow() then
    return
  end
  local position = housing_getInstallationPos()
  local count = housing_getInstallableSiegeKeyList(position)
  _dayCount = count
  _panel:SetShow(true)
  VillageTent_ChangeFontColor(7)
  VillageTent_SetText(count)
end
function VillageTent_SetText(count)
  local position = housing_getInstallationPos()
  local warDay = ToClient_GetCurrentInstallableTentDayOfWeek(position)
  local currentDayIndex = -1
  for index = 0, maxCount - 1 do
    if index < count then
      _regionInfoWrapper[index] = housing_getInstallableSiegeRegionInfo(index)
      local day = _regionInfoWrapper[index]:getVillageSiegeType()
      local regionName = _regionInfoWrapper[index]:getAreaName()
      local taxLevel = _regionInfoWrapper[index]:get():getVillageTaxLevel()
      local tempString = ""
      if true == _ContentsGroup_SeigeSeason5 then
        if _ContentsGroup_NewSiegeRule then
          tempString = "LUA_NODEGRADE_"
        else
          tempString = "LUA_NODEGRADE2_"
        end
        tempString = PAGetString(Defines.StringSheet_GAME, tempString .. tostring(taxLevel))
        _dayControl[index]._regionName:SetText(regionName .. "(" .. tempString .. ")")
      else
        if 0 == taxLevel then
          tempString = PAGetString(Defines.StringSheet_GAME, "LUA_TAX_GRADE_ZERO")
        elseif 1 == taxLevel then
          tempString = "I"
        elseif 2 == taxLevel then
          tempString = "II"
        elseif 3 == taxLevel then
          tempString = "III"
        end
        _dayControl[index]._regionName:SetText(regionName .. "(" .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_VILLAGETENT_GRADE", "index", tempString) .. ")")
      end
      _dayControl[index]._day:SetText(dayString[day])
      _dayControl[index]._day:SetShow(true)
      _dayControl[index]._regionName:SetShow(true)
      if warDay == day then
        currentDayIndex = index
      end
    else
      _dayControl[index]._day:SetShow(false)
      _dayControl[index]._regionName:SetShow(false)
    end
  end
  if currentDayIndex >= 0 then
    VillageTent_ChangeFontColor(currentDayIndex)
    self._ui.txt_joinDesc:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SETDESC", "day", _dayControl[currentDayIndex]._day:GetText(), "regionName", _dayControl[currentDayIndex]._regionName:GetText()))
    self._ui.txt_joinDesc:SetShow(true)
  else
    self._ui.txt_joinDesc:SetShow(false)
  end
  VillageTent_SetSize(count)
end
function VillageTent_SetSize(count)
  self._ui.bg:SetSize(self._ui.bg:GetSizeX(), 70 + (count - 1) * textGap)
  self._ui.txt_joinDesc:SetPosY(_dayControl[count - 1]._day:GetPosY() + 45)
  self._ui.stc_lineVertical:SetSize(1, (count + 1) * textGap)
  self._ui.txt_bottomDesc:SetPosY(self._ui.txt_joinDesc:GetPosY() + self._ui.txt_joinDesc:GetTextSizeY() + 15)
  _panel:SetSize(_panel:GetSizeX(), self._ui.txt_joinDesc:GetPosY() + self._ui.txt_joinDesc:GetTextSizeY() + self._ui.stc_bottomBG:GetSizeY() + self._ui.txt_bottomDesc:GetTextSizeY() + 30)
  self._ui.stc_keyGuideBG:ComputePos()
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self.keyGuideGroup, self._ui.stc_keyGuideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function VillageTent_ChangeFontColor(index)
  for ii = 0, _dayCount - 1 do
    if ii == index then
      _dayControl[ii]._day:SetFontColor(Defines.Color.C_FFFFCE22)
      _dayControl[ii]._regionName:SetFontColor(Defines.Color.C_FFFFCE22)
      dayCheck = true
    else
      _dayControl[ii]._day:SetFontColor(Defines.Color.C_FFC4BEBE)
      _dayControl[ii]._regionName:SetFontColor(Defines.Color.C_FFC4BEBE)
    end
  end
end
function Input_VillageTentPopup_SetRegion()
  local position = housing_getInstallationPos()
  local currentDay = ToClient_GetCurrentInstallableTentDayOfWeek(position)
  for ii = 0, _dayCount - 1 do
    local _regionInfoWrapper = housing_getInstallableSiegeRegionInfo(ii)
    local day = _regionInfoWrapper:getVillageSiegeType()
    if currentDay == day then
      local regionKeyRaw = _regionInfoWrapper:get()._regionKey:get()
      if ToClient_IsVillageSiegeInThisWeek(regionKeyRaw) then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_VILLAGETENTPOPUP_LASTWEEK"))
      else
        housing_InstallObject(regionKeyRaw)
        FGlobal_HouseInstallationControl_Close()
        PaGlobalFunc_InstallationMode_Manager_Exit()
      end
    end
  end
end
function PaGlobalFunc_VillageTent_Close()
  _panel:SetShow(false)
end

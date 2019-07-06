Panel_RecentMemory:SetPosX(-10)
Panel_RecentMemory:SetPosY(265)
Panel_RecentMemory:ActiveMouseEventEffect(true)
Panel_RecentMemory:setGlassBackground(true)
local RecentMemory = {
  _close = UI.getChildControl(Panel_RecentMemory, "Button_Close"),
  _questString0_1 = UI.getChildControl(Panel_RecentMemory, "StaticText_Quest1_1"),
  _questString0_2 = UI.getChildControl(Panel_RecentMemory, "StaticText_Quest1_2"),
  _questString1 = UI.getChildControl(Panel_RecentMemory, "StaticText_Quest2"),
  _memo = UI.getChildControl(Panel_RecentMemory, "StaticText_Memo"),
  _time = UI.getChildControl(Panel_RecentMemory, "StaticText_Time"),
  _closeNotify = UI.getChildControl(Panel_RecentMemory, "StaticText_CloseNotify")
}
RecentMemory._close:addInputEvent("Mouse_LUp", "RecentMemory_Close()")
function RecentMemory:filldata(memo, recentTime, questNo0, questNo1, questNoCurrent)
  questWrapper = ToClient_getQuestWrapper(questNo0)
  if nil ~= questWrapper then
    self._questString0_1:SetText("- " .. questWrapper:getTitle())
  else
    self._questString0_1:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECENTMEMORY_NOCOMPLETEQUEST"))
  end
  questWrapper = ToClient_getQuestWrapper(questNo1)
  if nil ~= questWrapper then
    self._questString0_2:SetText("- " .. questWrapper:getTitle())
  else
    self._questString0_2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECENTMEMORY_NOCOMPLETEQUEST"))
  end
  local paTime = PATime(recentTime)
  self._memo:SetText(memo)
  self._time:SetShow(false)
  questWrapper = ToClient_getQuestWrapper(questNoCurrent)
  if nil ~= questWrapper then
    self._questString1:SetText("- " .. questWrapper:getTitle())
  else
    self._questString1:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECENTMEMORY_NOPROGRESSQUEST"))
  end
end
function RecentMemory:show()
  if isFlushedUI() then
    return
  end
  local _year = ToClient_GetThisYear()
  local _month = ToClient_GetThisMonth()
  local _day = ToClient_GetToday()
  local dayCheck = ToClient_getGameUIManagerWrapper():getLuaCacheDataListTime(__eRecentMemoryCheck)
  if nil ~= dayCheck then
    local savedYear = dayCheck:GetYear()
    local savedMonth = dayCheck:GetMonth()
    local savedDay = dayCheck:GetDay()
    if _year == savedYear and _month == savedMonth and _day == savedDay then
      return
    end
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() then
    return
  end
  Panel_RecentMemory:SetShow(true, false)
end
function RecentMemory_Close()
  local _year = ToClient_GetThisYear()
  local _month = ToClient_GetThisMonth()
  local _day = ToClient_GetToday()
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListTime(__eRecentMemoryCheck, _year, _month, _day, 0, 0, 0, CppEnums.VariableStorageType.eVariableStorageType_User)
  Panel_RecentMemory:SetShow(false, false)
end
function FromClient_PreviousCharacterDataUpdate(memo, recentTime, questNo0, questNo1, questNoCurrent)
  RecentMemory:filldata(memo, recentTime, questNo0, questNo1, questNoCurrent)
  RecentMemory:show()
end
local openTime = 0
local beforTime = 0
function recentMemory_OpenTimeCheck(deltaTime)
  openTime = openTime + deltaTime
  local sumTime = 35 - math.ceil(openTime)
  RecentMemory._closeNotify:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RECENTMEMORY_CLOSETIME", "sumTime", convertStringFromDatetime(toInt64(0, sumTime))))
  if openTime > 35 then
    RecentMemory_Close()
    openTime = 0
  end
end
Panel_RecentMemory:RegisterUpdateFunc("recentMemory_OpenTimeCheck")
registerEvent("FromClient_PreviousCharacterDataUpdate", "FromClient_PreviousCharacterDataUpdate")

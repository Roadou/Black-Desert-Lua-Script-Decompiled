Panel_Window_WorkerManager_ChangeSkill_Renew:SetShow(false)
Panel_Window_WorkerManager_ChangeSkill_Renew:ignorePadSnapMoveToOtherPanel()
local workerChangeSkill = {
  _ui = {
    _static_CenterBg = UI.getChildControl(Panel_Window_WorkerManager_ChangeSkill_Renew, "Static_CenterBg"),
    _static_BottomBg = UI.getChildControl(Panel_Window_WorkerManager_ChangeSkill_Renew, "Static_BottomBg")
  },
  _config = {_skillSlotCount = 7},
  _selectedWorkerNoRaw = nil,
  _selectedSkillKeyRaw = nil,
  _skillSlot = {}
}
function workerChangeSkill:initialize()
  self._ui.keyGuide_A = UI.getChildControl(self._ui._static_BottomBg, "StaticText_A_ConsoleUI")
  self._ui.keyGuide_B = UI.getChildControl(self._ui._static_BottomBg, "StaticText_B_ConsoleUI")
  local tempBtnGroup = {
    self._ui.keyGuide_A,
    self._ui.keyGuide_B
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self:initContorl()
end
function workerChangeSkill:initContorl()
  local workerRestoreUI = self._ui
  for index = 1, self._config._skillSlotCount do
    local slot = {}
    slot.slotBG = UI.getChildControl(workerRestoreUI._static_CenterBg, "Button_SkillSlot_" .. index)
    slot.slotBG:SetShow(false)
    slot.name = UI.getChildControl(slot.slotBG, "StaticText_Name")
    slot.desc = UI.getChildControl(slot.slotBG, "StaticText_Desc")
    slot.icon = UI.getChildControl(slot.slotBG, "Static_Icon")
    self._skillSlot[index] = slot
  end
  Panel_Window_WorkerManager_ChangeSkill_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_WorkerManager_ChangeSkill_Confirm()")
end
function workerChangeSkill:resetData()
  self._selectedWorkerNoRaw = nil
  self._selectedSkillKeyRaw = nil
end
function workerChangeSkill:open()
  self:resetData()
  self:setPosition()
  local workerNoRawStr
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    workerNoRawStr = PaGlobalFunc_WorkerManager_All_GetSelectWorker()
  else
    workerNoRawStr = PaGlobalFunc_WorkerManager_GetSelectWorker()
  end
  if nil == workerNoRawStr then
    return
  end
  self._selectedWorkerNoRaw = tonumber64(workerNoRawStr)
  if true == Panel_Window_WorkerManager_ChangeSkill_Renew:GetShow() then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(8, 14)
  Panel_Window_WorkerManager_ChangeSkill_Renew:SetShow(true)
  self:update()
end
function workerChangeSkill:setPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_Window_WorkerManager_ChangeSkill_Renew:GetSizeX()
  local panelSizeY = Panel_Window_WorkerManager_ChangeSkill_Renew:GetSizeY()
  Panel_Window_WorkerManager_ChangeSkill_Renew:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Panel_Window_WorkerManager_ChangeSkill_Renew:SetPosY(scrSizeY / 2 - panelSizeY / 2)
end
function PaGlobalFunc_WorkerManager_ChangeSkill_Open()
  workerChangeSkill:open()
end
function workerChangeSkill:close()
  if false == Panel_Window_WorkerManager_ChangeSkill_Renew:GetShow() then
    return
  end
  Panel_Window_WorkerManager_ChangeSkill_Renew:SetShow(false)
end
function workerChangeSkill:confirm()
  local prevWorkerSkillKeyRaw = self._selectedSkillKeyRaw
  local workerNoRaw = self._selectedWorkerNoRaw
  if nil == prevWorkerSkillKeyRaw or nil == workerNoRaw then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERCHANGESKILL_NOSELECTSKILL"))
    return
  end
  ToClient_requestChangeSkillNoOne(workerNoRaw, prevWorkerSkillKeyRaw)
end
function PaGlobalFunc_WorkerManager_ChangeSkill_Confirm()
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  workerChangeSkill:confirm()
  workerChangeSkill:close()
end
function PaGlobalFunc_WorkerManager_ChangeSkill_Close()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  workerChangeSkill:close()
end
function workerChangeSkill:update()
  for index = 1, self._config._skillSlotCount do
    self._skillSlot[index].slotBG:SetShow(false)
  end
  local workerNoRaw = self._selectedWorkerNoRaw
  local workerWrapperLua = getWorkerWrapper(workerNoRaw)
  local skillCount = workerWrapperLua:getSkillCount()
  for skillIdx = 1, skillCount do
    local skillSSW = workerWrapperLua:getSkillSSW(skillIdx - 1)
    local slot = self._skillSlot[skillIdx]
    if nil == slot then
      _PA_LOG("\236\157\180\235\139\164\237\152\156", "skillIdx" .. skillIdx)
      return
    end
    slot.slotBG:SetShow(true)
    slot.icon:ChangeTextureInfoName(skillSSW:getIconPath())
    slot.name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    slot.name:SetFontColor(Defines.Color.C_FFEFEFEF)
    slot.name:SetText(skillSSW:getName())
    slot.desc:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    slot.desc:SetFontColor(Defines.Color.C_FF76747D)
    slot.desc:SetText(skillSSW:getDescription())
    local skillKeyRaw = skillSSW:getKeyRaw()
    slot.slotBG:addInputEvent("Mouse_On", "HandleClicked_WorkerChangeSkill_Select( " .. tostring(skillKeyRaw) .. " )")
  end
end
function workerChangeSkill:selectSkill(skillKeyRaw)
  self._selectedSkillKeyRaw = skillKeyRaw
end
function HandleClicked_WorkerChangeSkill_Select(skillKeyRaw)
  workerChangeSkill:selectSkill(skillKeyRaw)
end
function FromClient_ChangeWorkerSkillNoOne(workerNoRaw)
  local workerWrapperLua = getWorkerWrapper(workerNoRaw)
  local worker_Lev = workerWrapperLua:getLevel()
  local worker_Name = workerWrapperLua:getName()
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. worker_Lev .. " " .. workerWrapperLua:getGradeToColorString() .. worker_Name .. "<PAOldColor>"
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERCHANGESKILL_WORKERCHANGESKILL", "name", name))
end
function FromClient_ChangeWorkerSkillNo(workerNoRaw)
  local workerWrapperLua = getWorkerWrapper(workerNoRaw)
  local worker_Lev = workerWrapperLua:getLevel()
  local worker_Name = workerWrapperLua:getName()
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. worker_Lev .. " " .. workerWrapperLua:getGradeToColorString() .. worker_Name .. "<PAOldColor>"
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERCHANGESKILL_WORKERCHANGESKILL", "name", name))
end
function workerChangeSkill:registEventHandler()
  registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_WorkerManager_ChangeSkill")
  registerEvent("FromClient_ChangeWorkerSkillNoOne", "FromClient_ChangeWorkerSkillNoOne")
  registerEvent("FromClient_ChangeWorkerSkillNo", "FromClient_ChangeWorkerSkillNo")
end
function FromClient_luaLoadComplete_WorkerManager_ChangeSkill()
  workerChangeSkill:initialize()
end
workerChangeSkill:registEventHandler()

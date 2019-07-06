local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
Panel_WorkerChangeSkill:SetShow(false)
local workerChangeSkill = {
  ui = {
    panelBG = UI.getChildControl(Panel_WorkerChangeSkill, "Static_BG"),
    btn_Confirm = UI.getChildControl(Panel_WorkerChangeSkill, "Button_Confirm"),
    btn_Cancel = UI.getChildControl(Panel_WorkerChangeSkill, "Button_Cancel"),
    btn_Close = UI.getChildControl(Panel_WorkerChangeSkill, "Button_Close")
  },
  config = {maxSkillCount = 7},
  selectedWorkerNoRaw = nil,
  selectedSkillKeyRaw = nil,
  uiPool = {}
}
function workerChangeSkill:Init()
  for idx = 0, self.config.maxSkillCount - 1 do
    local tempSlot = {}
    tempSlot.bg = UI.createAndCopyBasePropertyControl(Panel_WorkerChangeSkill, "Static_SkillBox_Default", self.ui.panelBG, "workerChangeSkill_SlotBG_" .. idx)
    tempSlot.iconBg = UI.createAndCopyBasePropertyControl(Panel_WorkerChangeSkill, "Static_SkillSlotBG_00", tempSlot.bg, "workerChangeSkill_SkillIconBG_" .. idx)
    tempSlot.icon = UI.createAndCopyBasePropertyControl(Panel_WorkerChangeSkill, "Static_SkillSlot_00", tempSlot.iconBg, "workerChangeSkill_SkillIcon_" .. idx)
    tempSlot.name = UI.createAndCopyBasePropertyControl(Panel_WorkerChangeSkill, "StaticText_SkillName_00", tempSlot.bg, "workerChangeSkill_SkillName_" .. idx)
    tempSlot.desc = UI.createAndCopyBasePropertyControl(Panel_WorkerChangeSkill, "StaticText_SkillDesc_00", tempSlot.bg, "workerChangeSkill_SkillDesc_" .. idx)
    tempSlot.selectBtn = UI.createAndCopyBasePropertyControl(Panel_WorkerChangeSkill, "RadioButton_SkillSelect_00", tempSlot.bg, "workerChangeSkill_SkillSelectBtn_" .. idx)
    tempSlot.bg:SetPosX(5)
    tempSlot.bg:SetPosY(5 + (tempSlot.bg:GetSizeY() + 3) * idx)
    tempSlot.iconBg:SetPosX(3)
    tempSlot.iconBg:SetPosY(3)
    tempSlot.icon:SetPosX(0)
    tempSlot.icon:SetPosY(0)
    tempSlot.name:SetPosX(50)
    tempSlot.name:SetPosY(3)
    tempSlot.desc:SetPosX(50)
    tempSlot.desc:SetPosY(25)
    tempSlot.desc:SetTextMode(UI_TM.eTextMode_LimitText)
    tempSlot.selectBtn:SetPosX(260)
    tempSlot.selectBtn:SetPosY(3)
    tempSlot.selectBtn:SetTextMode(UI_TM.eTextMode_AutoWrap)
    tempSlot.selectBtn:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORLDMAP_GUILDHOUSE_CHANGEWORKER_SELECTBTN"))
    local skillLev = 0
    if 0 == idx then
      skillLev = 1
    else
      skillLev = idx * 5
    end
    tempSlot.name:SetText(skillLev .. PAGetString(Defines.StringSheet_GAME, "JOURNAL_WORD_LEVEL"))
    self.uiPool[idx] = tempSlot
  end
end
workerChangeSkill:Init()
function workerChangeSkill:Update()
  for idx = 0, self.config.maxSkillCount - 1 do
    local slot = self.uiPool[idx]
    slot.bg:SetShow(false)
    slot.selectBtn:SetCheck(false)
  end
  local workerNoRaw = self.selectedWorkerNoRaw
  local workerWrapperLua = getWorkerWrapper(workerNoRaw, true)
  local skillCount = workerWrapperLua:getSkillCount()
  for skillIdx = 0, skillCount - 1 do
    local skillSSW = workerWrapperLua:getSkillSSW(skillIdx)
    local slot = self.uiPool[skillIdx]
    slot.bg:SetShow(true)
    slot.icon:ChangeTextureInfoName(skillSSW:getIconPath())
    slot.name:SetFontColor(UI_color.C_FFEFEFEF)
    slot.name:SetText(skillSSW:getName())
    slot.desc:SetFontColor(UI_color.C_FFFAE696)
    slot.desc:SetText(skillSSW:getDescription())
    slot.desc:SetEnableArea(0, 0, slot.desc:GetTextSizeX() + 5, slot.desc:GetSizeY())
    slot.desc:addInputEvent("Mouse_On", "WorkerChangeSkill_SimpleTooltip( true, " .. skillIdx .. " )")
    slot.desc:addInputEvent("Mouse_Out", "WorkerChangeSkill_SimpleTooltip( false, " .. skillIdx .. " )")
    local skillKeyRaw = skillSSW:getKeyRaw()
    slot.selectBtn:addInputEvent("Mouse_LUp", "HandleClicked_WorkerChangeSkill_Select( " .. skillKeyRaw .. " )")
  end
end
function WorkerChangeSkill_SimpleTooltip(isShow, skillIndex)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local self = workerChangeSkill
  local name, desc, control
  local workerNoRaw = self.selectedWorkerNoRaw
  local workerWrapperLua = getWorkerWrapper(workerNoRaw, true)
  local skillSSW = workerWrapperLua:getSkillSSW(skillIndex)
  local slot = self.uiPool[skillIndex]
  name = skillSSW:getName()
  desc = skillSSW:getDescription()
  control = slot.desc
  TooltipSimple_Show(control, name, desc)
end
function HandleClicked_WorkerChangeSkill_Select(skillKeyRaw)
  workerChangeSkill.selectedSkillKeyRaw = skillKeyRaw
end
function HandleClicked_WorkerChangeSkill_Do()
  local prevWorkerSkillKeyRaw = workerChangeSkill.selectedSkillKeyRaw
  local workerNoRaw = workerChangeSkill.selectedWorkerNoRaw
  if nil == prevWorkerSkillKeyRaw or nil == workerNoRaw then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERCHANGESKILL_NOSELECTSKILL"))
    return
  end
  ToClient_requestChangeSkillNoOne(workerNoRaw, prevWorkerSkillKeyRaw)
  HandleClicked_WorkerChangeSkill_Close()
end
function HandleClicked_WorkerChangeSkill_Close()
  Panel_WorkerChangeSkill:SetShow(false)
  workerChangeSkill.selectedSkillKeyRaw = nil
  workerChangeSkill.selectedWorkerNoRaw = nil
end
function FromClient_ChangeWorkerSkillNoOne(workerNoRaw)
  local workerWrapperLua = getWorkerWrapper(workerNoRaw, true)
  local worker_Lev = workerWrapperLua:getLevel()
  local worker_Name = workerWrapperLua:getName()
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. worker_Lev .. " " .. workerWrapperLua:getGradeToColorString() .. worker_Name .. "<PAOldColor>"
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERCHANGESKILL_WORKERCHANGESKILL", "name", name))
end
function FromClient_ChangeWorkerSkillNo(workerNoRaw)
  local workerWrapperLua = getWorkerWrapper(workerNoRaw, true)
  local worker_Lev = workerWrapperLua:getLevel()
  local worker_Name = workerWrapperLua:getName()
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. worker_Lev .. " " .. workerWrapperLua:getGradeToColorString() .. worker_Name .. "<PAOldColor>"
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERCHANGESKILL_WORKERCHANGESKILL", "name", name))
end
function FGlobal_workerChangeSkill_Close()
  workerChangeSkill.selectedSkillKeyRaw = nil
  workerChangeSkill.selectedWorkerNoRaw = nil
  Panel_WorkerChangeSkill:SetShow(false)
end
function workerChangeSkill_Open(worker_Index)
  workerChangeSkill.selectedSkillKeyRaw = nil
  workerChangeSkill.selectedWorkerNoRaw = nil
  local workerNoRaw
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    workerNoRaw = tonumber64(worker_Index)
  else
    workerNoRaw = FGlobal_WorkerManager_GetWorkerNoRaw(worker_Index)
  end
  workerChangeSkill.selectedWorkerNoRaw = workerNoRaw
  Panel_WorkerChangeSkill:SetShow(true)
  workerChangeSkill:Update()
end
function workerChangeSkill:registEventHandler()
  self.ui.btn_Confirm:addInputEvent("Mouse_LUp", "HandleClicked_WorkerChangeSkill_Do()")
  self.ui.btn_Cancel:addInputEvent("Mouse_LUp", "HandleClicked_WorkerChangeSkill_Close()")
  self.ui.btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_WorkerChangeSkill_Close()")
end
function workerChangeSkill:registMessageHandler()
  registerEvent("FromClient_ChangeWorkerSkillNoOne", "FromClient_ChangeWorkerSkillNoOne")
  registerEvent("FromClient_ChangeWorkerSkillNo", "FromClient_ChangeWorkerSkillNo")
end
workerChangeSkill:registEventHandler()
workerChangeSkill:registMessageHandler()

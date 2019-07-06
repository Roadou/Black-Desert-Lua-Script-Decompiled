function PaGlobal_WorkerSkillTooltip_All:initialize()
  if nil == Panel_Widget_WorkerSkillTooltip_All then
    return
  end
  PaGlobal_WorkerSkillTooltip_All._ui._stc_Tooltip_Template = UI.getChildControl(Panel_Widget_WorkerSkillTooltip_All, "Static_TooltipTemplate")
  PaGlobal_WorkerSkillTooltip_All._ui._icon_SkillBgTemplate = UI.getChildControl(PaGlobal_WorkerSkillTooltip_All._ui._stc_Tooltip_Template, "Static_SkillIconBg_Template")
  PaGlobal_WorkerSkillTooltip_All._ui._icon_SkillTemplate = UI.getChildControl(PaGlobal_WorkerSkillTooltip_All._ui._icon_SkillBgTemplate, "Static_SkillIcon_Template")
  PaGlobal_WorkerSkillTooltip_All._ui._txt_Name_Template = UI.getChildControl(PaGlobal_WorkerSkillTooltip_All._ui._stc_Tooltip_Template, "StaticText_Desc_Template")
  PaGlobal_WorkerSkillTooltip_All._ui._txt_Desc_Template = UI.getChildControl(PaGlobal_WorkerSkillTooltip_All._ui._stc_Tooltip_Template, "StaticText_Name_Template")
  PaGlobal_WorkerSkillTooltip_All._ui._stc_Tooltip_Template:SetShow(false)
  PaGlobal_WorkerSkillTooltip_All._isConsole = ToClient_isConsole()
  PaGlobal_WorkerSkillTooltip_All:validate()
  PaGlobal_WorkerSkillTooltip_All:createControl()
  Panel_Widget_WorkerSkillTooltip_All:SetShow(false)
end
function PaGlobal_WorkerSkillTooltip_All:validate()
  if nil == Panel_Widget_WorkerSkillTooltip_All then
    return
  end
  PaGlobal_WorkerSkillTooltip_All._ui._stc_Tooltip_Template:isValidate()
  PaGlobal_WorkerSkillTooltip_All._ui._icon_SkillBgTemplate:isValidate()
  PaGlobal_WorkerSkillTooltip_All._ui._icon_SkillTemplate:isValidate()
  PaGlobal_WorkerSkillTooltip_All._ui._txt_Name_Template:isValidate()
  PaGlobal_WorkerSkillTooltip_All._ui._txt_Desc_Template:isValidate()
  PaGlobal_WorkerSkillTooltip_All._initialize = true
end
function PaGlobal_WorkerSkillTooltip_All:createControl()
  if nil == Panel_Widget_WorkerSkillTooltip_All or false == PaGlobal_WorkerSkillTooltip_All._initialize then
    return
  end
  for index = 0, PaGlobal_WorkerSkillTooltip_All._MAXSLOT - 1 do
    local skillSlot = {}
    skillSlot.slot = UI.cloneControl(PaGlobal_WorkerSkillTooltip_All._ui._stc_Tooltip_Template, Panel_Widget_WorkerSkillTooltip_All, "WorkerSkill_" .. index)
    skillSlot.Bg = UI.getChildControl(skillSlot.slot, "Static_SkillIconBg_Template")
    skillSlot.name = UI.getChildControl(skillSlot.slot, "StaticText_Name_Template")
    skillSlot.icon = UI.getChildControl(skillSlot.Bg, "Static_SkillIcon_Template")
    skillSlot.desc = UI.getChildControl(skillSlot.slot, "StaticText_Desc_Template")
    skillSlot.slot:SetShow(false)
    PaGlobal_WorkerSkillTooltip_All._tooltiplist[index] = skillSlot
    skillSlot.slot:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobal_WorkerSkillTooltip_All_Hide()")
    skillSlot.slot:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobal_WorkerSkillTooltip_All_Hide()")
  end
end
function PaGlobal_WorkerSkillTooltip_All:clearData()
  if nil == Panel_Widget_WorkerSkillTooltip_All then
    return
  end
  PaGlobal_WorkerSkillTooltip_All._workerKeyRaw = nil
  PaGlobal_WorkerSkillTooltip_All._uiBase = nil
  PaGlobal_WorkerSkillTooltip_All._skillCount = nil
end
function PaGlobal_WorkerSkillTooltip_All:AudioPostEvent(value, value, isConsole)
  if nil == Panel_Widget_WorkerSkillTooltip_All then
    return
  end
  if true == PaGlobal_WorkerSkillTooltip_All._isConsole and true == isConsole then
    _AudioPostEvent_SystemUiForXBOX(idx, value)
  elseif false == PaGlobal_WorkerSkillTooltip_All._isConsole and false == isConsole then
    audioPostEvent_SystemUi(idx, value)
  end
end

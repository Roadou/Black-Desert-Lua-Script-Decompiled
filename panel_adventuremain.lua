local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
local isAdventureOpen = ToClient_IsContentsGroupOpen("268")
local adventureUi = {
  _txt_Level = UI.getChildControl(Panel_Widget_Adventure, "StaticText_LEVEL"),
  _txt_Fish = UI.getChildControl(Panel_Widget_Adventure, "StaticText_FISH"),
  _txt_HorseTrain = UI.getChildControl(Panel_Widget_Adventure, "StaticText_HORSETRAINNING"),
  _txt_Knowkledge = UI.getChildControl(Panel_Widget_Adventure, "StaticText_KNOWLEDGE"),
  _txt_Total = UI.getChildControl(Panel_Widget_Adventure, "StaticText_TOTAL")
}
function AdventureMain_Show()
  Panel_Widget_Adventure:SetShow(true)
  adventureUi._txt_Level:SetShow(true)
  adventureUi._txt_Fish:SetShow(true)
  adventureUi._txt_HorseTrain:SetShow(true)
  adventureUi._txt_Knowkledge:SetShow(false)
  adventureUi._txt_Total:SetShow(true)
  AdventureMain_Refresh()
end
function AdventureMain_Hide()
  Panel_Widget_Adventure:SetShow(false)
  adventureUi._txt_Level:SetShow(false)
  adventureUi._txt_Fish:SetShow(false)
  adventureUi._txt_HorseTrain:SetShow(false)
  adventureUi._txt_Total:SetShow(false)
end
function AdventureMain_Refresh()
  adventureUi._txt_Level:SetText("LEVEL : " .. ScoreToGrade(ToClient_GetAdventureGrade(0)))
  adventureUi._txt_Fish:SetText("FISH : " .. ScoreToGrade(ToClient_GetAdventureGrade(2)))
  adventureUi._txt_HorseTrain:SetText("HORSE : " .. ScoreToGrade(ToClient_GetAdventureGrade(3)))
  adventureUi._txt_Total:SetText("TOTAL : " .. ScoreToGrade(ToClient_GetAdventureGrade(3)))
end
function ScoreToGrade(grade)
  if 4 == grade then
    return "A"
  elseif 3 == grade then
    return "B"
  elseif 2 == grade then
    return "C"
  elseif 1 == grade then
    return "D"
  end
  return "F"
end

local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
local VCK = CppEnums.VirtualKeyCode
local UI_IT = CppEnums.UiInputType
Panel_UIControl:SetShow(false)
Panel_UIControl:RegisterShowEventFunc(true, "UI_Control_ShowAni()")
Panel_UIControl:RegisterShowEventFunc(false, "UI_Control_HideAni()")
function UI_Control_ShowAni()
  Panel_UIControl:SetShow(true)
end
function UI_Control_HideAni()
  Panel_UIControl:SetShow(false)
end
local expText
if false == _ContentsGroup_RenewUI_Main then
  expText = UI.getChildControl(Panel_SelfPlayerExpGage, "StaticText_EXPText")
end
local mainBarText = UI.getChildControl(Panel_MainStatus_User_Bar, "StaticText_MainBarText")
local quickSlotText = UI.getChildControl(Panel_QuickSlot, "StaticText_quickSlot")
local fieldViewText = UI.getChildControl(Panel_FieldViewMode, "StaticText_viewModeText")
local radarText = UI.getChildControl(Panel_Radar, "StaticText_radarText")
local npcNaviText = UI.getChildControl(Panel_NpcNavi, "StaticText_npcNaviText")
local pvpText = UI.getChildControl(Panel_PvpMode, "StaticText_pvpText")
local servantText = UI.getChildControl(Panel_Window_Servant, "StaticText_servantText")
local _checkedQuestStaticActive = UI.getChildControl(Panel_CheckedQuest, "Static_Active")
local questResizeButton = UI.getChildControl(_checkedQuestStaticActive, "Button_Size")
function Movable_UI()
  mainBarText:SetShow(false)
  Panel_MainStatus_User_Bar:SetIgnore(false)
  Panel_MainStatus_User_Bar:SetDragEnable(true)
  Panel_MainStatus_User_Bar:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_isWidget.dds")
  PaGlobalAppliedBuffList:setMovableUIForControlMode()
  quickSlotText:SetShow(false)
  Panel_QuickSlot:SetIgnore(false)
  Panel_QuickSlot:SetDragEnable(true)
  Panel_QuickSlot:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_isWidget.dds")
  servantText:SetShow(false)
  Panel_Window_Servant:SetDragEnable(true)
  Panel_Window_Servant:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_isWidget.dds")
  pvpText:SetShow(false)
  Panel_PvpMode:SetIgnore(false)
  _pvpButton:SetIgnore(true)
  Panel_PvpMode:SetDragEnable(true)
  Panel_PvpMode:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_isWidget.dds")
  Panel_ClassResource:SetIgnore(false)
  Panel_ClassResource:SetDragEnable(true)
  Panel_ClassResource:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_isWidget.dds")
  npcNaviText:SetShow(false)
  Panel_NpcNavi:SetDragEnable(true)
  if false == _ContentsGroup_RemasterUI_Party then
    Panel_Party:SetDragAll(true)
    Panel_Party:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_isWidget.dds")
  else
    Panel_Widget_Party:SetDragAll(true)
    Panel_Widget_Party:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_isWidget.dds")
  end
  FGlobal_Panel_Radar_Movable_UI()
  Panel_CheckedQuest:SetDragEnable(true)
  Panel_CheckedQuest:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_isWidget.dds")
  questResizeButton:SetShow(true)
  Panel_NewEquip:SetDragAll(true)
  fieldViewText:SetShow(false)
  Panel_FieldViewMode:SetIgnore(false)
  Panel_FieldViewMode:SetDragAll(true)
  Panel_FieldViewMode:SetDragEnable(true)
  Panel_FieldViewMode:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_isWidget.dds")
  Panel_SkillCommand:SetIgnore(false)
  Panel_SkillCommand:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_isWidget.dds")
  FGlobal_SetMovableMode(true)
end
function Movable_UI_Cancel()
  mainBarText:SetShow(false)
  Panel_MainStatus_User_Bar:SetIgnore(true)
  Panel_MainStatus_User_Bar:SetDragEnable(false)
  Panel_MainStatus_User_Bar:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_empty.dds")
  MainStatusBar_PosX = Panel_MainStatus_User_Bar:GetPosX()
  MainStatusBar_PosY = Panel_MainStatus_User_Bar:GetPosY()
  quickSlotText:SetShow(false)
  Panel_QuickSlot:SetIgnore(true)
  Panel_QuickSlot:SetDragEnable(false)
  Panel_QuickSlot:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_empty.dds")
  Panel_ClassResource:SetIgnore(true)
  Panel_ClassResource:SetDragEnable(false)
  Panel_ClassResource:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_empty.dds")
  pvpText:SetShow(false)
  Panel_PvpMode:SetIgnore(true)
  Panel_PvpMode:SetDragEnable(false)
  _pvpButton:SetIgnore(false)
  Panel_PvpMode:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_empty.dds")
  npcNaviText:SetShow(false)
  Panel_NpcNavi:SetDragEnable(false)
  FGlobal_Panel_Radar_Movable_UI_Cancel()
  Panel_CheckedQuest:SetDragEnable(false)
  Panel_CheckedQuest:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_empty.dds")
  questResizeButton:SetShow(false)
  Panel_NewEquip:SetDragAll(false)
  PaGlobalAppliedBuffList:cancelMovableUIForControlMode()
  servantText:SetShow(false)
  Panel_Window_Servant:SetDragEnable(false)
  Panel_Window_Servant:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_empty.dds")
  local temporaryWrapper = getTemporaryInformationWrapper()
  if nil == temporaryWrapper or nil == temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle) and nil == temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Ship) and nil == temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Pet) then
    Panel_Window_Servant:SetShow(false)
  end
  fieldViewText:SetShow(false)
  Panel_FieldViewMode:SetIgnore(true)
  Panel_FieldViewMode:SetDragAll(false)
  Panel_FieldViewMode:SetDragEnable(false)
  Panel_FieldViewMode:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_empty.dds")
  if false == _ContentsGroup_RemasterUI_Party then
    Panel_Party:SetDragEnable(false)
    Panel_Party:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_empty.dds")
  else
    Panel_Widget_Party:SetDragEnable(false)
    Panel_Widget_Party:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_empty.dds")
  end
  Panel_SkillCommand:SetIgnore(true)
  Panel_SkillCommand:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_empty.dds")
  FGlobal_SetMovableMode(false)
end
function Panel_UIControl_SetShow(bShow)
  if bShow == Panel_UIControl:GetShow() then
    return
  end
  if bShow then
    FieldViewMode_ShowToggle(true)
    Panel_UIControl:SetShow(true, true)
    Movable_UI()
    ResetPos_WidgetButton()
  else
    FieldViewMode_ShowToggle(false)
    SelfPlayerStatusBar_RefleshPosition()
    Movable_UI_Cancel()
    Panel_UIControl:SetShow(false, true)
    ResetPos_WidgetButton()
  end
end

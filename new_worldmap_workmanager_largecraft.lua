local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_TM = CppEnums.TextMode
local UI_PP = CppEnums.PAUIMB_PRIORITY
Panel_LargeCraft_WorkManager:setMaskingChild(true)
Panel_LargeCraft_WorkManager:setGlassBackground(true)
Panel_LargeCraft_WorkManager:TEMP_UseUpdateListSwap(true)
Panel_LargeCraft_WorkManager:ActiveMouseEventEffect(true)
Panel_LargeCraft_WorkManager:RegisterShowEventFunc(true, "Panel_LargeCraft_WorkManager_ShowAni()")
Panel_LargeCraft_WorkManager:RegisterShowEventFunc(false, "Panel_LargeCraft_WorkManager_HideAni()")
function Panel_LargeCraft_WorkManager_ShowAni()
  local aniInfo1 = Panel_LargeCraft_WorkManager:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.05)
  aniInfo1.AxisX = Panel_LargeCraft_WorkManager:GetSizeX() / 2
  aniInfo1.AxisY = Panel_LargeCraft_WorkManager:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_LargeCraft_WorkManager:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.05)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_LargeCraft_WorkManager:GetSizeX() / 2
  aniInfo2.AxisY = Panel_LargeCraft_WorkManager:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_LargeCraft_WorkManager_HideAni()
  Panel_LargeCraft_WorkManager:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_LargeCraft_WorkManager:addColorAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local houseInfoSS, houseKey, houseParam
local affiliatedTownKey = 0
local defalut_Control = {
  _title = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Title"),
  _btn_Close = UI.getChildControl(Panel_LargeCraft_WorkManager, "Button_Win_Close"),
  _btn_Question = UI.getChildControl(Panel_LargeCraft_WorkManager, "Button_Question"),
  _largCraft_List = {
    _BG = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_LargCraftInfo_BG"),
    _Index = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_LargeCraftInfo_Index"),
    _Slide_Left = UI.getChildControl(Panel_LargeCraft_WorkManager, "Button_LargCraftInfo_Slide_Left"),
    _Slide_Right = UI.getChildControl(Panel_LargeCraft_WorkManager, "Button_LargCraftInfo_Slide_Right"),
    _Btn_Cancel = UI.getChildControl(Panel_LargeCraft_WorkManager, "Button_LargCraftInfo_Cancel"),
    _Icon_BG_1 = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_LargCraftInfo_Result_Icon_BG_1"),
    _Icon_BG_2 = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_LargCraftInfo_Result_Icon_BG_2"),
    _Icon = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_LargCraftInfo_Result_Icon"),
    _Name = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_LargCraftInfo_Name"),
    _Total_Count = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_LargCraftInfo_TotalCount"),
    _Current_Count = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_LargCraftInfo_CurrentCount"),
    _Progress_BG = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_LargCraftInfo_Progress_BG"),
    _Progress_OutLine = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_LargCraftInfo_Progress_OutLine"),
    _Progress_OnGoing = UI.getChildControl(Panel_LargeCraft_WorkManager, "Progress2_LargCraftInfo_OnGoing"),
    _Progress_Complete = UI.getChildControl(Panel_LargeCraft_WorkManager, "Progress2_LargCraftInfo_Complete"),
    _Guide = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_LargCraftInfo_Guide")
  },
  _subWork_List = {
    _BG = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_SubWorkList_BG"),
    _Title = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_SubWorkList_Title"),
    _Scroll = UI.getChildControl(Panel_LargeCraft_WorkManager, "Scroll_SubWorkList"),
    _Button = {},
    _Progress_OnGoing = {},
    _Progress_Complete = {},
    _CountText_1 = {},
    _CountText_2 = {},
    _Ani_OnGoing = {},
    _Template = {
      _Button = UI.getChildControl(Panel_LargeCraft_WorkManager, "RadioButton_SubWork"),
      _Progress_OnGoing = UI.getChildControl(Panel_LargeCraft_WorkManager, "Progress2_SubWorkList_OnGoing"),
      _Progress_Complete = UI.getChildControl(Panel_LargeCraft_WorkManager, "Progress2_SubWorkList_Complete"),
      _CountText_1 = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_SubWorkList_Count_1"),
      _CountText_2 = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_SubWorkList_Count_2"),
      _Ani_OnGoing = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_SubWorkList_OnGoingAni"),
      _rowMax = 7,
      _row_PosY_Gap = 1
    }
  },
  _worker_List = {
    _BG = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_WorkerList_BG"),
    _Title = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_WorkerList_Title"),
    _Scroll = UI.getChildControl(Panel_LargeCraft_WorkManager, "Scroll_WorkerList"),
    _No_Worker = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_NoWorker"),
    _Button = {},
    _Progress = {},
    _ActionPoint = {},
    _Template = {
      _Button = UI.getChildControl(Panel_LargeCraft_WorkManager, "RadioButton_Worker"),
      _Progress = UI.getChildControl(Panel_LargeCraft_WorkManager, "Progress2_Worker_ActionPoint"),
      _ActionPoint = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Worker_ActionPoint"),
      _rowMax = 6,
      _row_PosY_Gap = 1
    }
  },
  _subWork_Info = {
    _BG = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_SubWorkInfo_BG"),
    _Title = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_SubWorkInfo_Title"),
    _Resource_BG = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_SubWorkInfo_Resource_BG"),
    _Resource_Title = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_SubWorkInfo_Resource_Title"),
    _Resource_Name = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_SubWorkInfo_Resource_Name"),
    _Resource_Icon_BG = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_SubWorkInfo_Resource_Icon_BG"),
    _Resource_Icon_Border = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_SubWorkInfo_Resource_Icon_Border"),
    _Resource_Icon_Over = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_SubWorkInfo_Resource_Icon_Over"),
    _Resource_Icon = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_SubWorkInfo_Resource_Icon"),
    _Resource_Count = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_SubWorkInfo_Resource_Count"),
    _OnGoing_BG = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_SubWorkInfo_OnGoing_BG"),
    _OnGoing_Title = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_SubWorkInfo_OnGoing_Title"),
    _OnGoing_Scroll = UI.getChildControl(Panel_LargeCraft_WorkManager, "Scroll_SubWorkInfo_OnGoing"),
    _OnGoing_Guide = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_SubWorkInfo_OnGoing_Guide"),
    _immediately = UI.getChildControl(Panel_LargeCraft_WorkManager, "Button_Immediately"),
    _OnGoing_Time = {},
    _OnGoing_Progress_BG = {},
    _OnGoing_Progress = {},
    _OnGoing_Cancel = {},
    _Template = {
      _OnGoing_Time = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_SubWorkInfo_Ongoing_Time"),
      _OnGoing_Progress_BG = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_SubWorkInfo_OnGoing_Progress_BG"),
      _OnGoing_Progress = UI.getChildControl(Panel_LargeCraft_WorkManager, "Progress2_SubWorkInfo_OnGoing"),
      _OnGoing_Cancel = UI.getChildControl(Panel_LargeCraft_WorkManager, "Button_SubWorkInfo_Cancel"),
      _rowMax = 4,
      _row_PosY_Gap = 5
    }
  },
  _subWork_Estimated = {
    _BG = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_Estimated_BG"),
    _Title = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Estimated_Title"),
    _Time_BG = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_Estimated_Time_BG"),
    _Time_Text = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Estimated_Time_Text"),
    _Time_Value = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Estimated_Time_Value"),
    _Time_Count = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Estimated_Time_Count"),
    _Work_Count = UI.getChildControl(Panel_LargeCraft_WorkManager, "Button_Estimated_Work_Count"),
    _Work_BG = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_Estimated_Work_BG"),
    _Work_Volume_Text = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Estimated_WorkVolum_Text"),
    _Work_Volume_Value = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Estimated_WorkVolum_Value"),
    _Work_Speed_Text = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Estimated_WorkSpeed_Text"),
    _Work_Speed_Value = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Estimated_WorkSpeed_Value"),
    _Move_BG = UI.getChildControl(Panel_LargeCraft_WorkManager, "Static_Estimated_Move_BG"),
    _Move_Distance_Text = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Estimated_MoveDistance_Text"),
    _Move_Distance_Value = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Estimated_MoveDistance_Value"),
    _Move_Speed_Text = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Estimated_MoveSpeed_Text"),
    _Move_Speed_Value = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Estimated_MoveSpeed_Value"),
    _Button_DoWork = UI.getChildControl(Panel_LargeCraft_WorkManager, "Button_doWork"),
    _Cant_Work = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Cant_Work"),
    _Finished_Work = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Finished_Work"),
    _Last_Work = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_Last_Work"),
    _No_Resource_Work = UI.getChildControl(Panel_LargeCraft_WorkManager, "StaticText_noResource")
  }
}
defalut_Control._subWork_Info._immediately:SetShow(false)
defalut_Control._btn_Question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"HouseManageWork\" )")
defalut_Control._btn_Question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"HouseManageWork\", \"true\")")
defalut_Control._btn_Question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"HouseManageWork\", \"false\")")
function defalut_Control:Init_Control()
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Index)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Slide_Left)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Slide_Right)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Btn_Cancel)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Icon_BG_1)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Icon_BG_2)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Icon)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Name)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Total_Count)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Current_Count)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Progress_BG)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Progress_OutLine)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Progress_OnGoing)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Progress_Complete)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._largCraft_List._BG, self._largCraft_List._Guide)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_List._BG, self._subWork_List._Title)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_List._BG, self._subWork_List._Scroll)
  FGlobal_Set_Table_Control(self._subWork_List, "_Button", "_Button", true, false)
  FGlobal_Set_Table_Control(self._subWork_List, "_Ani_OnGoing", "_Button", true, false)
  FGlobal_Set_Table_Control(self._subWork_List, "_Progress_OnGoing", "_Button", true, false)
  FGlobal_Set_Table_Control(self._subWork_List, "_Progress_Complete", "_Button", true, false)
  FGlobal_Set_Table_Control(self._subWork_List, "_CountText_1", "_Button", true, false)
  FGlobal_Set_Table_Control(self._subWork_List, "_CountText_2", "_Button", true, false)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._worker_List._BG, self._worker_List._Title)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._worker_List._BG, self._worker_List._Scroll)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._worker_List._BG, self._worker_List._No_Worker)
  FGlobal_Set_Table_Control(self._worker_List, "_Button", "_Button", true, false)
  FGlobal_Set_Table_Control(self._worker_List, "_Progress", "_Button", true, false)
  FGlobal_Set_Table_Control(self._worker_List, "_ActionPoint", "_Button", true, false)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Info._BG, self._subWork_Info._Title)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Info._BG, self._subWork_Info._Resource_BG)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Info._BG, self._subWork_Info._Resource_Title)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Info._BG, self._subWork_Info._Resource_Name)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Info._BG, self._subWork_Info._Resource_Icon_BG)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Info._BG, self._subWork_Info._Resource_Icon)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Info._BG, self._subWork_Info._Resource_Count)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Info._BG, self._subWork_Info._OnGoing_BG)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Info._BG, self._subWork_Info._OnGoing_Title)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Info._BG, self._subWork_Info._OnGoing_Scroll)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Info._BG, self._subWork_Info._OnGoing_Guide)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Info._BG, self._subWork_Info._immediately)
  FGlobal_Set_Table_Control(self._subWork_Info, "_OnGoing_Time", "_OnGoing_Time", true, false)
  FGlobal_Set_Table_Control(self._subWork_Info, "_OnGoing_Progress_BG", "_OnGoing_Time", true, false)
  FGlobal_Set_Table_Control(self._subWork_Info, "_OnGoing_Progress", "_OnGoing_Time", true, false)
  FGlobal_Set_Table_Control(self._subWork_Info, "_OnGoing_Cancel", "_OnGoing_Time", true, false)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Title)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Time_BG)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Time_Text)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Time_Value)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Time_Count)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Work_Count)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Work_BG)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Work_Volume_Text)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Work_Volume_Value)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Work_Speed_Text)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Work_Speed_Value)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Move_BG)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Move_Distance_Text)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Move_Distance_Value)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Move_Speed_Text)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Move_Speed_Value)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Button_DoWork)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Cant_Work)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._Last_Work)
  FGlobal_AddChild(Panel_LargeCraft_WorkManager, self._subWork_Estimated._BG, self._subWork_Estimated._No_Resource_Work)
end
defalut_Control:Init_Control()
function defalut_Control:Init_Function()
  self._btn_Close:addInputEvent("Mouse_LUp", "FGlobal_LargeCraft_WorkManager_Close()")
  self._largCraft_List._BG:addInputEvent("Mouse_UpScroll", "HandleClick_LargCraft_List_Btn(true)")
  self._largCraft_List._BG:addInputEvent("Mouse_DownScroll", "HandleClick_LargCraft_List_Btn(false)")
  self._largCraft_List._Slide_Right:addInputEvent("Mouse_LUp", "HandleClick_LargCraft_List_Btn(false)")
  self._largCraft_List._Slide_Left:addInputEvent("Mouse_LUp", "HandleClick_LargCraft_List_Btn(true)")
  self._largCraft_List._Icon_BG_2:addInputEvent("Mouse_On", "Item_Tooltip_Show_LargeCraft(true)")
  self._largCraft_List._Icon_BG_2:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
  self._largCraft_List._Btn_Cancel:addInputEvent("Mouse_LUp", "HandleClick_LargCraft_Cancel_Btn()")
  self._subWork_List._BG:addInputEvent("Mouse_UpScroll", "HandleScroll_SubWork_List_UpDown(true)")
  self._subWork_List._BG:addInputEvent("Mouse_DownScroll", "HandleScroll_SubWork_List_UpDown(false)")
  self._subWork_List._Scroll:addInputEvent("Mouse_UpScroll", "HandleScroll_SubWork_List_UpDown(true)")
  self._subWork_List._Scroll:addInputEvent("Mouse_DownScroll", "HandleScroll_SubWork_List_UpDown(false)")
  self._subWork_List._Scroll:addInputEvent("Mouse_LUp", "HandleScroll_SubWork_List_OnClick()")
  self._subWork_List._Scroll:addInputEvent("Mouse_LDown", "HandleScroll_SubWork_List_OnClick()")
  self._subWork_List._Scroll:GetControlButton():addInputEvent("Mouse_UpScroll", "HandleScroll_SubWork_List_UpDown(true)")
  self._subWork_List._Scroll:GetControlButton():addInputEvent("Mouse_DownScroll", "HandleScroll_SubWork_List_UpDown(false)")
  self._subWork_List._Scroll:GetControlButton():addInputEvent("Mouse_LUp", "HandleScroll_SubWork_List_OnClick()")
  self._subWork_List._Scroll:GetControlButton():addInputEvent("Mouse_LDown", "HandleScroll_SubWork_List_OnClick()")
  self._subWork_List._Scroll:GetControlButton():addInputEvent("Mouse_LPress", "HandleScroll_SubWork_List_OnClick()")
  for key, value in pairs(self._subWork_List._Button) do
    value:addInputEvent("Mouse_LUp", "SubWork_List_Select(" .. tostring(key) .. ")")
    value:addInputEvent("Mouse_On", "HandleOn_SubWork_List(" .. tostring(key) .. ")")
    value:addInputEvent("Mouse_Out", "HandleOut_SubWork_List()")
    value:addInputEvent("Mouse_UpScroll", "HandleScroll_SubWork_List_UpDown(true)")
    value:addInputEvent("Mouse_DownScroll", "HandleScroll_SubWork_List_UpDown(false)")
  end
  self._worker_List._BG:addInputEvent("Mouse_UpScroll", "HandleScroll_LargeCraft_Worker_List_UpDown(true)")
  self._worker_List._BG:addInputEvent("Mouse_DownScroll", "HandleScroll_LargeCraft_Worker_List_UpDown(false)")
  self._worker_List._Scroll:addInputEvent("Mouse_UpScroll", "HandleScroll_LargeCraft_Worker_List_UpDown(true)")
  self._worker_List._Scroll:addInputEvent("Mouse_DownScroll", "HandleScroll_LargeCraft_Worker_List_UpDown(false)")
  self._worker_List._Scroll:addInputEvent("Mouse_LDown", "HandleScroll_LargeCraft_Worker_List_OnClick()")
  self._worker_List._Scroll:addInputEvent("Mouse_LUp", "HandleScroll_LargeCraft_Worker_List_OnClick()")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_UpScroll", "HandleScroll_LargeCraft_Worker_List_UpDown(true)")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_DownScroll", "HandleScroll_LargeCraft_Worker_List_UpDown(false)")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LDown", "HandleScroll_LargeCraft_Worker_List_OnClick()")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LUp", "HandleScroll_LargeCraft_Worker_List_OnClick()")
  self._worker_List._Scroll:GetControlButton():addInputEvent("Mouse_LPress", "HandleScroll_LargeCraft_Worker_List_OnClick()")
  for key, value in pairs(self._worker_List._Button) do
    value:addInputEvent("Mouse_LUp", "LargeCraft_Worker_List_Select(" .. key .. ")")
    value:addInputEvent("Mouse_On", "HandleOn_LargeCraft_Worker_List(" .. key .. ")")
    value:addInputEvent("Mouse_Out", "HandleOut_LargeCraft_Worker_List()")
    value:addInputEvent("Mouse_UpScroll", "HandleScroll_LargeCraft_Worker_List_UpDown(true)")
    value:addInputEvent("Mouse_DownScroll", "HandleScroll_LargeCraft_Worker_List_UpDown(false)")
  end
  self._subWork_Info._OnGoing_BG:addInputEvent("Mouse_UpScroll", "HandleScroll_SubWork_Progress_List_UpDown(true)")
  self._subWork_Info._OnGoing_BG:addInputEvent("Mouse_DownScroll", "HandleScroll_SubWork_Progress_List_UpDown(false)")
  self._subWork_Info._OnGoing_Scroll:addInputEvent("Mouse_UpScroll", "HandleScroll_SubWork_Progress_List_UpDown(true)")
  self._subWork_Info._OnGoing_Scroll:addInputEvent("Mouse_DownScroll", "HandleScroll_SubWork_Progress_List_UpDown(false)")
  self._subWork_Info._OnGoing_Scroll:addInputEvent("Mouse_LDown", "HandleScroll_SubWork_Progress_List_OnClick()")
  self._subWork_Info._OnGoing_Scroll:addInputEvent("Mouse_LUp", "HandleScroll_SubWork_Progress_List_OnClick()")
  self._subWork_Info._OnGoing_Scroll:GetControlButton():addInputEvent("Mouse_UpScroll", "HandleScroll_SubWork_Progress_List_UpDown(true)")
  self._subWork_Info._OnGoing_Scroll:GetControlButton():addInputEvent("Mouse_DownScroll", "HandleScroll_SubWork_Progress_List_UpDown(false)")
  self._subWork_Info._OnGoing_Scroll:GetControlButton():addInputEvent("Mouse_LDown", "HandleScroll_SubWork_Progress_List_OnClick()")
  self._subWork_Info._OnGoing_Scroll:GetControlButton():addInputEvent("Mouse_LUp", "HandleScroll_SubWork_Progress_List_OnClick()")
  self._subWork_Info._OnGoing_Scroll:GetControlButton():addInputEvent("Mouse_LPress", "HandleScroll_SubWork_Progress_List_OnClick()")
  self._subWork_Info._Resource_Icon_Over:addInputEvent("Mouse_On", "Item_Tooltip_Show_LargeCraft(false)")
  self._subWork_Info._Resource_Icon_Over:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
  for key, value in pairs(self._subWork_Info._OnGoing_Cancel) do
    value:addInputEvent("Mouse_LUp", "HandleClick_OnGoing_Cancel_LargeCraft(" .. tostring(key) .. ")")
  end
  self._subWork_Estimated._Work_Count:addInputEvent("Mouse_LUp", "HandleClicked_WorkCount_LargeCraft()")
  self._subWork_Estimated._Button_DoWork:addInputEvent("Mouse_LUp", "HandleClick_doWork_LargeCraft()")
end
defalut_Control:Init_Function()
local LargCraft_List = {
  _data_Table = {},
  _workerList = {},
  _onGoingIndex = nil,
  _workableType = nil,
  _currentIndex = 0,
  _selectedWork = 0,
  _contentCount = 0,
  _position = nil
}
local SubWork_List = {}
function LargCraft_List:_setData(isRefresh)
  local level = houseParam._level
  local receipeKey = houseParam._useType
  local workData = ToClient_getHouseWorkableListCount(houseInfoSS)
  local workCount = ToClient_getRentHouseWorkableListByCustomOnlySize(receipeKey, 1, level)
  if workCount <= 0 then
    return
  end
  self._onGoingIndex = nil
  self._data_Table = {}
  SubWork_List._data_Table = {}
  local levelIndex = 1
  local savedLevel = 0
  local levelCount = 0
  for index = 1, workCount do
    if self._data_Table[index] == nil then
      self._data_Table[index] = {}
    end
    local esSSW = ToClient_getHouseWorkableItemExchangeByIndex(houseInfoSS, index - 1)
    if esSSW:isSet() then
      local esSS = esSSW:get()
      local itemStatic = esSSW:getResultItemStaticStatusWrapper():get()
      local workVolume = Int64toInt32(esSS._productTime / toInt64(0, 1000))
      local workName = esSSW:getDescription()
      local workIcon = "icon/" .. esSSW:getIcon()
      local resultIcon = workIcon
      local resultName = workName
      local resultKey
      if false == esSSW:getUseExchangeIcon() then
        resultName = getItemName(itemStatic)
        resultKey = itemStatic._key
      end
      self._data_Table[index] = {
        _index = index,
        _level = levelIndex,
        _workKey = ToClient_getWorkableExchangeKeyByIndex(index - 1),
        _workIcon = workIcon,
        _workName = workName,
        _workVolume = workVolume,
        _resultKey = resultKey,
        _resultIcon = resultIcon,
        _resultName = resultName,
        _currentCount = 0,
        _onGoingCount = 0,
        _totalCount = 0
      }
      local currentKey = ToClient_getLargeCraftExchangeKeyRaw(houseInfoSS)
      if self._data_Table[index]._workKey == currentKey then
        if nil == self._onGoingIndex then
          self._onGoingIndex = index
        else
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEWORKLIST_LARGECRAFT_ALERT"))
          return
        end
      end
      if levelIndex ~= savedLevel then
        levelCount = ToClient_getRentHouseWorkableListByCustomOnlySize(receipeKey, 1, levelIndex)
        savedLevel = levelIndex
      end
      if index == levelCount then
        levelIndex = levelIndex + 1
      end
    end
  end
  if true == isRefresh then
    self._currentIndex = 1
    if nil ~= self._onGoingIndex then
      self._currentIndex = self._onGoingIndex
    end
    self._selectedWork = self._data_Table[self._currentIndex]._workKey
    self._contentCount = workCount
    self._position = ToClient_GetHouseInfoStaticStatusWrapper(houseKey):getPosition()
  end
end
function LargCraft_List:_updateSlot()
  local index = self._currentIndex
  local icon = self._data_Table[index]._resultIcon
  local name = self._data_Table[index]._workName
  local totalCount = self._data_Table[index]._totalCount
  local currentCount = self._data_Table[index]._currentCount
  local onGoingCount = self._data_Table[index]._onGoingCount
  defalut_Control._largCraft_List._Index:SetText("[" .. tostring(index) .. "/" .. tostring(self._contentCount) .. "]")
  defalut_Control._largCraft_List._Icon:ChangeTextureInfoName(icon)
  local x1, y1, x2, y2 = setTextureUV_Func(defalut_Control._largCraft_List._Icon, 0, 0, 44, 44)
  defalut_Control._largCraft_List._Icon:getBaseTexture():setUV(x1, y1, x2, y2)
  defalut_Control._largCraft_List._Icon:setRenderTexture(defalut_Control._largCraft_List._Icon:getBaseTexture())
  defalut_Control._largCraft_List._Name:SetText(name)
  if self._onGoingIndex == self._currentIndex then
    local progressRate_Complete = math.floor(currentCount / totalCount * 100)
    local progressRate_OnGoing = math.floor((currentCount + onGoingCount) / totalCount * 100)
    defalut_Control._largCraft_List._Current_Count:SetText(tostring(currentCount) .. "/" .. tostring(totalCount))
    defalut_Control._largCraft_List._Progress_Complete:SetProgressRate(progressRate_Complete)
    defalut_Control._largCraft_List._Progress_OnGoing:SetProgressRate(progressRate_OnGoing)
    defalut_Control._largCraft_List._Btn_Cancel:SetShow(true)
    defalut_Control._largCraft_List._Current_Count:SetShow(true)
    defalut_Control._largCraft_List._Progress_BG:SetShow(true)
    defalut_Control._largCraft_List._Progress_OutLine:SetShow(true)
    defalut_Control._largCraft_List._Progress_Complete:SetShow(true)
    defalut_Control._largCraft_List._Progress_OnGoing:SetShow(true)
    defalut_Control._largCraft_List._Total_Count:SetShow(false)
    defalut_Control._largCraft_List._Guide:SetShow(false)
  else
    local guideText = ""
    if nil == self._onGoingIndex then
      guideText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSEWORKLIST_LARGECRAFT_GUIDE_2", "name", name)
    else
      local ongoingWorkName = self._data_Table[self._onGoingIndex]._workName
      guideText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSEWORKLIST_LARGECRAFT_GUIDE_1", "name", ongoingWorkName)
    end
    defalut_Control._largCraft_List._Total_Count:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSEWORKLIST_LARGECRAFT_TOTALCOUNT", "totalCount", totalCount))
    defalut_Control._largCraft_List._Guide:SetText(guideText)
    local _totalCountPosX = math.max(defalut_Control._largCraft_List._Total_Count:GetPosX(), defalut_Control._largCraft_List._Guide:GetPosX() + defalut_Control._largCraft_List._Guide:GetTextSizeX() + 5)
    defalut_Control._largCraft_List._Total_Count:SetSpanSize(_totalCountPosX, defalut_Control._largCraft_List._Total_Count:GetPosY())
    defalut_Control._largCraft_List._Total_Count:ComputePos()
    defalut_Control._largCraft_List._Btn_Cancel:SetShow(false)
    defalut_Control._largCraft_List._Current_Count:SetShow(false)
    defalut_Control._largCraft_List._Progress_BG:SetShow(false)
    defalut_Control._largCraft_List._Progress_OutLine:SetShow(false)
    defalut_Control._largCraft_List._Progress_Complete:SetShow(false)
    defalut_Control._largCraft_List._Progress_OnGoing:SetShow(false)
    defalut_Control._largCraft_List._Total_Count:SetShow(true)
    defalut_Control._largCraft_List._Guide:SetShow(true)
  end
  if self._contentCount == 1 then
    defalut_Control._largCraft_List._Slide_Left:SetShow(false)
    defalut_Control._largCraft_List._Slide_Right:SetShow(false)
  elseif self._contentCount > 1 then
    if index == 1 then
      defalut_Control._largCraft_List._Slide_Left:SetShow(false)
      defalut_Control._largCraft_List._Slide_Right:SetShow(true)
    elseif index == self._contentCount then
      defalut_Control._largCraft_List._Slide_Left:SetShow(true)
      defalut_Control._largCraft_List._Slide_Right:SetShow(false)
    else
      defalut_Control._largCraft_List._Slide_Left:SetShow(true)
      defalut_Control._largCraft_List._Slide_Right:SetShow(true)
    end
  end
end
function HandleClick_LargCraft_List_Btn(isLeft)
  if isLeft and 1 < LargCraft_List._currentIndex then
    Subwork_Progress_List_SetWorkingCount(1)
    defalut_Control._subWork_Estimated._Time_Count:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", Subwork_Progress_List_GetWorkingCount()))
    LargCraft_List._currentIndex = LargCraft_List._currentIndex - 1
    LargCraft_List:_updateSlot()
    SubWork_List:_updateSlot(true)
    SubWork_List_Select(1)
    SubWork_List:_updateSlot()
  elseif false == isLeft and LargCraft_List._contentCount > LargCraft_List._currentIndex then
    Subwork_Progress_List_SetWorkingCount(1)
    defalut_Control._subWork_Estimated._Time_Count:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", Subwork_Progress_List_GetWorkingCount()))
    LargCraft_List._currentIndex = LargCraft_List._currentIndex + 1
    LargCraft_List:_updateSlot()
    SubWork_List:_updateSlot(true)
    SubWork_List_Select(1)
    SubWork_List:_updateSlot()
  end
  LargCraft_List._selectedWork = LargCraft_List._data_Table[LargCraft_List._currentIndex]._workKey
end
local _Cancel_All = false
function LargCraft_Cancel_All()
  local workingCout = ToClient_getHouseWorkingWorkerList(houseInfoSS)
  if workingCout > 0 then
    _Cancel_All = true
    for idx = 1, workingCout do
      local worker = ToClient_getHouseWorkingWorkerByIndex(houseInfoSS, idx - 1).workerNo
      ToClient_requestStopPlantWorking(worker)
    end
  else
    _Cancel_All = false
    ToClient_requestChangeLargeCraftExchange(houseInfoSS, 0)
    FGlobal_WorldMapWindowEscape()
  end
end
function HandleClick_LargCraft_Cancel_Btn()
  local currentKey = ToClient_getLargeCraftExchangeKeyRaw(houseInfoSS)
  local selected_Work = LargCraft_List._selectedWork
  if currentKey ~= selected_Work then
    return
  end
  local workName = LargCraft_List._data_Table[LargCraft_List._currentIndex]._workName
  local cancelContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_TOWN_WORKERMANAGE_CONFIRM_WORKCANCEL", "workName", "<PAColor0xFFFFD543>" .. workName .. "<PAOldColor>")
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_LARGECRAFT_WORKMANAGER_CANCELALL_TITLE"),
    content = cancelContent,
    functionYes = LargCraft_Cancel_All,
    functionCancel = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "top")
end
SubWork_List = {
  _data_Table = {},
  _rowMax = defalut_Control._subWork_List._Template._rowMax,
  _contentRow = nil,
  _offsetIndex = nil,
  _offset_Max = nil,
  _selected_SubWork = nil,
  _selected_Index = nil,
  _over_Index = nil
}
function SubWork_List:_setData()
  for index = 1, LargCraft_List._contentCount do
    local esSSW = ToClient_getHouseWorkableItemExchangeByIndex(houseInfoSS, index - 1)
    if esSSW:isSet() then
      local esSS = esSSW:get()
      local eSSCount = getExchangeSourceNeedItemList(esSS, true)
      local workingCout = ToClient_getHouseWorkingWorkerList(houseInfoSS)
      local totalCount = 0
      local sumProgressCount = 0
      local sumOnGoingCount = 0
      if workingCout > 0 then
        LargCraft_List._workerList = {}
      end
      local workingList = {}
      for idx = 1, workingCout do
        local worker = ToClient_getHouseWorkingWorkerByIndex(houseInfoSS, idx - 1).workerNo
        local workerNo = worker:get_s64()
        local resourceIndex = ToClient_getLargeCraftWorkIndexByWorker(workerNo) + 1
        if nil == workingList[resourceIndex] then
          workingList[resourceIndex] = {}
        end
        local _index = #workingList[resourceIndex] + 1
        workingList[resourceIndex][_index] = worker
        LargCraft_List._workerList[idx] = workerNo
      end
      self._data_Table[index] = {}
      for idx = 1, eSSCount do
        if nil == self._data_Table[index]._resource then
          self._data_Table[index]._resource = {}
        end
        local itemStaticInfomationWrapper = getExchangeSourceNeedItemByIndex(idx - 1)
        local itemStaticWrapper = itemStaticInfomationWrapper:getStaticStatus()
        local itemStatic = itemStaticWrapper:get()
        local gradeType = itemStaticWrapper:getGradeType()
        local itemKey = itemStaticInfomationWrapper:getKey()
        local itemKeyRaw = itemStaticInfomationWrapper:getKey():get()
        local resourceKey = itemStatic._key
        local itemName = getItemName(itemStatic)
        local itemIcon = "icon/" .. getItemIconPath(itemStatic)
        local workerList = {}
        local onGoingCount = 0
        if nil ~= workingList[idx] then
          workerList = workingList[idx]
          onGoingCount = #workingList[idx]
        end
        local workingCount = ToClient_getHouseWorkingWorkerList(houseInfoSS)
        local tempCount = 0
        for tmpIdx = 1, workingCount do
          local worker = ToClient_getHouseWorkingWorkerByIndex(houseInfoSS, tmpIdx - 1).workerNo
          local workerNo = worker:get_s64()
          local resourceIndex = ToClient_getLargeCraftWorkIndexByWorker(workerNo) + 1
          if resourceIndex == idx then
            tempCount = tempCount + ToClient_getNpcWorkerWorkingCount(workerNo) + 1
          end
        end
        local subWorkName = getItemName(itemStatic)
        local fullCount = Int64toInt32(itemStaticInfomationWrapper:getCount_s64())
        local haveCount = 0
        if 0 ~= affiliatedTownKey then
          haveCount = Int64toInt32(warehouse_getItemCount(affiliatedTownKey, itemKey))
        end
        local progressCount = ToClient_getLargeCarftCompleteProgressPoint(houseInfoSS, esSSW:getExchangeKeyRaw(), idx - 1)
        if progressCount < 0 then
          progressCount = 0
        else
          progressCount = fullCount - progressCount
        end
        self._data_Table[index]._resource[idx] = {
          _itemKey = itemKey,
          _gradeType = gradeType,
          _itemKeyRaw = itemKeyRaw,
          _resourceKey = resourceKey,
          _itemName = itemName,
          _itemIcon = itemIcon,
          _subWorkName = subWorkName,
          _fullCount = fullCount,
          _haveCount = haveCount,
          _progressCount = progressCount,
          _workerList = workerList,
          _onGoingCount = onGoingCount,
          _workingCount = tempCount
        }
        totalCount = totalCount + fullCount
        sumProgressCount = sumProgressCount + progressCount
        sumOnGoingCount = sumOnGoingCount + onGoingCount
      end
      LargCraft_List._data_Table[index]._currentCount = sumProgressCount
      LargCraft_List._data_Table[index]._onGoingCount = sumOnGoingCount
      LargCraft_List._data_Table[index]._totalCount = totalCount
    end
  end
end
function SubWork_List:_setOffset()
  local index = LargCraft_List._currentIndex
  local esSSW = ToClient_getHouseWorkableItemExchangeByIndex(houseInfoSS, index - 1)
  if esSSW:isSet() then
    local esSS = esSSW:get()
    local eSSCount = getExchangeSourceNeedItemList(esSS, true)
    local _offset_Max = eSSCount - self._rowMax
    if _offset_Max < 0 then
      _offset_Max = 0
    end
    self._offset_Max = _offset_Max
    self._offsetIndex = 0
    self._contentRow = eSSCount
    UIScroll.SetButtonSize(defalut_Control._subWork_List._Scroll, self._rowMax, self._contentRow)
    self._selected_SubWork = nil
    self._selected_Index = nil
    self._over_Index = nil
  end
end
function SubWork_List:_updateSlot(isRefresh)
  local index = LargCraft_List._currentIndex
  local isOnGoing = LargCraft_List._currentIndex == LargCraft_List._onGoingIndex
  if true == isRefresh then
    self:_setOffset()
  end
  for idx = 1, self._rowMax do
    local _idx = self._offsetIndex + idx
    if nil == self._data_Table[index]._resource[_idx] then
      defalut_Control._subWork_List._Button[idx]:SetShow(false)
      defalut_Control._subWork_List._CountText_1[idx]:SetShow(false)
      defalut_Control._subWork_List._Progress_OnGoing[idx]:SetShow(false)
      defalut_Control._subWork_List._Progress_Complete[idx]:SetShow(false)
      defalut_Control._subWork_List._Ani_OnGoing[idx]:SetShow(false)
      defalut_Control._subWork_List._CountText_2[idx]:SetShow(false)
    else
      local _subWorkName = self._data_Table[index]._resource[_idx]._subWorkName
      local _fullCount = self._data_Table[index]._resource[_idx]._fullCount
      local _progressCount = self._data_Table[index]._resource[_idx]._progressCount
      local _onGoingCount = self._data_Table[index]._resource[_idx]._onGoingCount
      defalut_Control._subWork_List._Button[idx]:SetText(_subWorkName)
      defalut_Control._subWork_List._Button[idx]:SetShow(true)
      if self._selected_Index == _idx then
        defalut_Control._subWork_List._Button[idx]:SetCheck(true)
      else
        defalut_Control._subWork_List._Button[idx]:SetCheck(false)
      end
      if _onGoingCount > 0 then
        defalut_Control._subWork_List._Ani_OnGoing[idx]:SetShow(true)
      else
        defalut_Control._subWork_List._Ani_OnGoing[idx]:SetShow(false)
      end
      if isOnGoing then
        local progressRate_OnGoing = math.floor((_onGoingCount + _progressCount) / _fullCount * 100)
        local progressRate_Complete = math.floor(_progressCount / _fullCount * 100)
        if _fullCount == _progressCount then
          defalut_Control._subWork_List._CountText_2[idx]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEWORKLIST_LARGECRAFT_SUBWORK_FINISHED"))
          defalut_Control._subWork_List._CountText_2[idx]:SetShow(true)
          defalut_Control._subWork_List._CountText_1[idx]:SetShow(false)
        else
          defalut_Control._subWork_List._CountText_1[idx]:SetText(tostring(_progressCount) .. "/" .. tostring(_fullCount))
          defalut_Control._subWork_List._CountText_1[idx]:SetShow(true)
          defalut_Control._subWork_List._CountText_2[idx]:SetShow(false)
        end
        defalut_Control._subWork_List._Progress_OnGoing[idx]:SetProgressRate(progressRate_OnGoing)
        defalut_Control._subWork_List._Progress_Complete[idx]:SetProgressRate(progressRate_Complete)
        defalut_Control._subWork_List._Progress_OnGoing[idx]:SetShow(true)
        defalut_Control._subWork_List._Progress_Complete[idx]:SetShow(true)
        if _onGoingCount > 0 and (self._selected_Index == _idx or self._over_Index == _idx) then
          defalut_Control._subWork_List._CountText_1[idx]:SetText("(+" .. tostring(_onGoingCount) .. ")  " .. tostring(_progressCount) .. "/" .. tostring(_fullCount))
        end
      else
        defalut_Control._subWork_List._CountText_2[idx]:SetText(tostring(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSEWORKLIST_LARGECRAFT_SUBWORK_COUNT", "fullCount", _fullCount)))
        defalut_Control._subWork_List._CountText_1[idx]:SetShow(false)
        defalut_Control._subWork_List._Progress_OnGoing[idx]:SetShow(false)
        defalut_Control._subWork_List._Progress_Complete[idx]:SetShow(false)
        defalut_Control._subWork_List._Ani_OnGoing[idx]:SetShow(false)
        defalut_Control._subWork_List._CountText_2[idx]:SetShow(true)
      end
    end
  end
  HandleOn_SubWork_List_Refresh()
end
function SubWork_List_Select(index)
  Subwork_Progress_List_SetWorkingCount(1)
  if Panel_Window_Exchange_Number:IsShow() then
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  end
  local workIndex = LargCraft_List._currentIndex
  local subWorkIndex = SubWork_List._offsetIndex + index
  if nil == SubWork_List._data_Table[workIndex]._resource[subWorkIndex] then
    return
  end
  defalut_Control._subWork_Estimated._Time_Count:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", Subwork_Progress_List_GetWorkingCount()))
  SubWork_List._selected_SubWork = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._itemKeyRaw
  SubWork_List._selected_Index = subWorkIndex
  SubWork_List:_updateSlot()
  SubWork_Info_Update()
  SubWork_Estimated_Update()
end
function HandleOn_SubWork_List(index)
  SubWork_List._over_Index = SubWork_List._offsetIndex + index
  if SubWork_List._selected_Index ~= SubWork_List._over_Index then
    local data = SubWork_List._data_Table[LargCraft_List._currentIndex]._resource[SubWork_List._over_Index]
    if data ~= nil then
      local _onGoingCount = data._onGoingCount
      local _fullCount = data._fullCount
      local _progressCount = data._progressCount
      if _onGoingCount > 0 then
        defalut_Control._subWork_List._CountText_1[index]:SetText("(+" .. tostring(_onGoingCount) .. ")  " .. tostring(_progressCount) .. "/" .. tostring(_fullCount))
      end
    end
    SubWork_Info_Update(true)
    SubWork_Estimated_Update(true)
  end
end
function HandleOut_SubWork_List()
  SubWork_List._over_Index = nil
  SubWork_List:_updateSlot()
  SubWork_Info_Update()
  SubWork_Estimated_Update()
end
function HandleOn_SubWork_List_Refresh()
  if nil ~= SubWork_List._over_Index then
    if defalut_Control._subWork_List._Button[SubWork_List._over_Index]:GetShow() then
      HandleOn_SubWork_List(SubWork_List._over_Index)
    else
      HandleOut_SubWork_List()
    end
  end
end
function SubWork_List_Immediately_CraftItem()
  local worker = ToClient_getHouseWorkingWorkerByIndex(houseInfoSS, 0).workerNo
  local workerNo = worker:get_s64()
  local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
  if esSSW:isSet() then
    local workingIcon = esSSW:getIcon()
    local workName = esSSW:getDescription()
    defalut_Control._subWork_info._remainTimeInt = ToClient_getWorkingTime(workerNo)
    defalut_Control._subWork_info._needPearl = ToClient_GetUsingPearlByRemainingPearl(CppEnums.InstantCashType.eInstant_CompleteNpcWorking, defalut_Control._subWork_info._remainTimeInt)
    local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_IMMEDIATELYCOMPLETE_MSGBOX_TITLE")
    local messageBoxMemo = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_HOUSE_IMMEDIATELY", "workName", workName, "needPearl", tostring(defalut_Control._subWork_info._needPearl))
    local messageboxData = {
      title = messageboxTitle,
      content = messageBoxMemo,
      functionYes = SubWork_List_Immediately_CraftItemYes,
      functionCancel = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "middle")
  end
end
function SubWork_List_Immediately_CraftItemYes()
  ToClient_requestQuickComplete(defalut_Control._subWork_info._worker, defalut_Control._subWork_info._needPearl)
end
local Worker_List = {
  _data_Table = {},
  _rowMax = defalut_Control._worker_List._Template._rowMax,
  _contentRow = nil,
  _offsetIndex = nil,
  _offset_Max = nil,
  _selected_Worker = nil,
  _selected_WorkerKey = nil,
  _selected_Index = nil,
  _over_Index = nil
}
local workingTime = {}
local homeWayKey = {}
local sortDistanceValue = {}
local function Worker_SortByRegionInfo()
  local workIndex = 0
  local esSSW = ToClient_getHouseWorkableItemExchangeByIndex(houseInfoSS, workIndex)
  if false == esSSW:isSet() then
    return
  end
  local esSS = esSSW:get()
  local productCategory = esSS._productCategory
  local workableKey = ToClient_getWorkableExchangeKeyByIndex(workIndex)
  local sortMethod = 0
  local waitingWorkerCount = ToClient_getHouseWaitWorkerList(houseInfoSS, productCategory, workableKey, sortMethod)
  local workVolume = Int64toInt32(esSS._productTime / toInt64(0, 1000))
  if 0 == waitingWorkerCount then
    return
  end
  local possibleWorkerIndex = 0
  for index = 1, waitingWorkerCount do
    local npcWaitingWorker = ToClient_getHouseWaitWorkerByIndex(houseInfoSS, index - 1)
    local workerNoRaw = npcWaitingWorker:getWorkerNo():get_s64()
    local workerWrapperLua = getWorkerWrapper(workerNoRaw, false)
    if true == ToClient_isWaitWorker(npcWaitingWorker) and false == workerWrapperLua:getIsAuctionInsert() then
      possibleWorkerIndex = possibleWorkerIndex + 1
      local distance = ToClient_getCalculateMoveDistance(Worker_List._data_Table[possibleWorkerIndex]._workerNo, LargCraft_List._position) / 100
      local workSpeed = Worker_List._data_Table[possibleWorkerIndex]._workSpeed
      local moveSpeed = Worker_List._data_Table[possibleWorkerIndex]._moveSpeed
      local workBaseTime = ToClient_getNpcWorkingBaseTimeForHouse() / 1000
      local totalWorkTime = math.ceil(workVolume / workSpeed) * workBaseTime + distance / moveSpeed * 2
      workingTime[possibleWorkerIndex] = Int64toInt32(totalWorkTime)
      homeWayKey[possibleWorkerIndex] = Worker_List._data_Table[possibleWorkerIndex]._homeWaypoint
      sortDistanceValue[possibleWorkerIndex] = distance
    end
  end
  local possibleWorkerCount = possibleWorkerIndex
  local temp
  local function workerDataSwap(index, sortCount)
    if index ~= sortCount and Worker_List._data_Table[index]._homeWaypoint ~= Worker_List._data_Table[sortCount]._homeWaypoint then
      temp = Worker_List._data_Table[index]
      Worker_List._data_Table[index] = Worker_List._data_Table[sortCount]
      Worker_List._data_Table[sortCount] = temp
      temp = sortDistanceValue[index]
      sortDistanceValue[index] = sortDistanceValue[sortCount]
      sortDistanceValue[sortCount] = temp
    end
  end
  for ii = 1, possibleWorkerCount do
    local temp
    for i = possibleWorkerCount, 1, -1 do
      if i > 1 and workingTime[i] < workingTime[i - 1] then
        temp = Worker_List._data_Table[i]
        Worker_List._data_Table[i] = Worker_List._data_Table[i - 1]
        Worker_List._data_Table[i - 1] = temp
        temp = workingTime[i]
        workingTime[i] = workingTime[i - 1]
        workingTime[i - 1] = temp
        temp = sortDistanceValue[i]
        sortDistanceValue[i] = sortDistanceValue[i - 1]
        sortDistanceValue[i - 1] = temp
      end
    end
    if nil == temp then
      break
    end
  end
  local territory = {}
  if 0 < FGlobal_WayPointKey_Return() and FGlobal_WayPointKey_Return() <= 300 then
    territory[0] = true
    territory[1] = false
    territory[2] = false
    territory[3] = false
  elseif FGlobal_WayPointKey_Return() >= 301 and FGlobal_WayPointKey_Return() <= 600 then
    territory[0] = false
    territory[1] = true
    territory[2] = false
    territory[3] = false
  elseif FGlobal_WayPointKey_Return() >= 601 and 1000 >= FGlobal_WayPointKey_Return() then
    territory[0] = false
    territory[1] = false
    territory[2] = true
    territory[3] = false
  elseif FGlobal_WayPointKey_Return() >= 1101 then
    territory[0] = false
    territory[1] = false
    territory[2] = false
    territory[3] = true
  end
  local _sortCount = 0
  for ii = _sortCount + 1, possibleWorkerCount do
    if Worker_List._data_Table[ii]._homeWaypoint == FGlobal_WayPointKey_Return() then
      _sortCount = _sortCount + 1
      if ii ~= _sortCount then
        workerDataSwap(ii, _sortCount)
      end
    end
  end
  local function sortByRegion(territoryKey)
    local sortTerritoryCount = 0
    local startValue = _sortCount + 1
    if startValue > possibleWorkerCount then
      return
    end
    if 0 == territoryKey then
      for jj = startValue, possibleWorkerCount do
        if 0 < Worker_List._data_Table[jj]._homeWaypoint and Worker_List._data_Table[jj]._homeWaypoint <= 300 then
          if startValue ~= jj then
            workerDataSwap(jj, startValue + sortTerritoryCount)
          end
          _sortCount = _sortCount + 1
          sortTerritoryCount = sortTerritoryCount + 1
        end
      end
    elseif 1 == territoryKey then
      for jj = startValue, possibleWorkerCount do
        if Worker_List._data_Table[jj]._homeWaypoint >= 301 and Worker_List._data_Table[jj]._homeWaypoint <= 600 then
          if startValue ~= jj then
            workerDataSwap(jj, startValue + sortTerritoryCount)
          end
          _sortCount = _sortCount + 1
          sortTerritoryCount = sortTerritoryCount + 1
        end
      end
    elseif 2 == territoryKey then
      for jj = startValue, possibleWorkerCount do
        if Worker_List._data_Table[jj]._homeWaypoint >= 601 and Worker_List._data_Table[jj]._homeWaypoint <= 1000 then
          if startValue ~= jj then
            workerDataSwap(jj, startValue + sortTerritoryCount)
          end
          _sortCount = _sortCount + 1
          sortTerritoryCount = sortTerritoryCount + 1
        end
      end
    elseif 3 == territoryKey then
      for jj = startValue, possibleWorkerCount do
        if Worker_List._data_Table[jj]._homeWaypoint >= 1101 then
          if startValue ~= jj then
            workerDataSwap(jj, startValue + sortTerritoryCount)
          end
          _sortCount = _sortCount + 1
          sortTerritoryCount = sortTerritoryCount + 1
        end
      end
    end
    if sortTerritoryCount > 1 then
      for ii = startValue + 1, startValue + sortTerritoryCount - 1 do
        for jj = startValue + sortTerritoryCount - 1, startValue + 1, -1 do
          if sortDistanceValue[jj] < sortDistanceValue[jj - 1] then
            workerDataSwap(jj, jj - 1)
          end
        end
      end
    end
  end
  if waitingWorkerCount ~= _sortCount then
    if true == territory[0] then
      sortByRegion(0)
      sortByRegion(1)
      sortByRegion(2)
      sortByRegion(3)
    elseif true == territory[1] then
      sortByRegion(1)
      sortByRegion(0)
      sortByRegion(2)
      sortByRegion(3)
    elseif true == territory[2] then
      sortByRegion(2)
      sortByRegion(1)
      sortByRegion(0)
      sortByRegion(3)
    elseif true == territory[3] then
      sortByRegion(3)
      sortByRegion(1)
      sortByRegion(0)
      sortByRegion(2)
    end
  end
end
function Worker_List:_setData()
  local workIndex = 0
  local esSSW = ToClient_getHouseWorkableItemExchangeByIndex(houseInfoSS, workIndex)
  if esSSW:isSet() then
    local esSS = esSSW:get()
    local productCategory = CppEnums.ProductCategory.ProductCategory_LargeCraft
    local workableKey = ToClient_getWorkableExchangeKeyByIndex(workIndex)
    local sortMethod = 0
    local waitingWorkerCount = ToClient_getHouseWaitWorkerList(houseInfoSS, productCategory, workableKey, sortMethod)
    if waitingWorkerCount <= 0 then
      defalut_Control._subWork_Estimated._No_Resource_Work:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_RENTHOUSE_WORKMANAGER_WORKERLIST_NOWORKER"))
    else
      defalut_Control._subWork_Estimated._No_Resource_Work:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_RENTHOUSE_WORKMANAGER_BTN_DISABLEWORK"))
    end
    local _Idx = 0
    self._data_Table = {}
    for Index = 1, waitingWorkerCount do
      local npcWaitingWorker = ToClient_getHouseWaitWorkerByIndex(houseInfoSS, Index - 1)
      local workerNoRaw = npcWaitingWorker:getWorkerNo():get_s64()
      local workerWrapperLua = getWorkerWrapper(workerNoRaw, false)
      if true == ToClient_isWaitWorker(npcWaitingWorker) and false == workerWrapperLua:getIsAuctionInsert() then
        _Idx = _Idx + 1
        if nil == self._data_Table[_Idx] then
          self._data_Table[_Idx] = {}
        end
        local checkData = npcWaitingWorker:getStaticSkillCheckData()
        checkData:set(CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouseLargeCraft, houseUseType, 0)
        checkData._diceCheckForceSuccess = true
        local firstWorkerNo = npcWaitingWorker:getWorkerNo()
        local workerNoChar = firstWorkerNo:get_s64()
        local npcWaitingWorkerSS = npcWaitingWorker:getWorkerStaticStatus()
        local workerNo = WorkerNo(workerNoChar)
        local houseUseType = CppEnums.eHouseUseType.Count
        local workSpeed = npcWaitingWorker:getWorkEfficienceWithSkill(checkData, productCategory)
        local moveSpeed = npcWaitingWorker:getMoveSpeedWithSkill(checkData) / 100
        local maxPoint = npcWaitingWorkerSS._actionPoint
        local currentPoint = npcWaitingWorker:getActionPoint()
        local workerRegionWrapper = ToClient_getRegionInfoWrapper(npcWaitingWorker)
        local homeWaypoint = npcWaitingWorker:getHomeWaypoint()
        local isWorkable = ToClient_getWorkerWorkerableHouse(houseInfoSS, Index - 1)
        local name
        if isWorkable then
          name = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. npcWaitingWorker:getLevel() .. " " .. getWorkerName(npcWaitingWorkerSS) .. "(<PAColor0xff868686>" .. workerRegionWrapper:getAreaName() .. "<PAOldColor>)"
        else
          name = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. npcWaitingWorker:getLevel() .. " " .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_HOUSE_NOTFINDNODE", "npcWaitingWorkerSS", getWorkerName(npcWaitingWorkerSS), "getAreaName", workerRegionWrapper:getAreaName())
        end
        local workerGrade = npcWaitingWorkerSS:getCharacterStaticStatus()._gradeType:get()
        self._data_Table[_Idx] = {
          _workerNo = workerNo,
          _workerNo_s64 = workerNoChar,
          _workerNoChar = Int64toInt32(workerNoChar),
          _name = name,
          _workSpeed = workSpeed / 1000000,
          _moveSpeed = moveSpeed,
          _maxPoint = maxPoint,
          _currentPoint = currentPoint,
          _homeWaypoint = homeWaypoint,
          _isWorkable = isWorkable,
          _workerGrade = workerGrade
        }
      end
    end
    local _offset_Max = _Idx - self._rowMax
    if _offset_Max < 0 then
      _offset_Max = 0
    end
    self._offset_Max = _offset_Max
    self._offsetIndex = 0
    self._contentRow = _Idx
    UIScroll.SetButtonSize(defalut_Control._worker_List._Scroll, self._rowMax, self._contentRow)
  end
  Worker_SortByRegionInfo()
end
function Worker_List:_updateSlot()
  FGlobal_Clear_Control(defalut_Control._worker_List._Button)
  FGlobal_Clear_Control(defalut_Control._worker_List._ActionPoint)
  FGlobal_Clear_Control(defalut_Control._worker_List._Progress)
  local rowIndex = self._offsetIndex
  local isSelectedWorker = false
  for index = 1, self._rowMax do
    local _dataIndex = rowIndex + index
    local data = self._data_Table[_dataIndex]
    if nil == data then
      break
    end
    local name = data._name
    local actionPoint = tostring(data._currentPoint) .. "/" .. tostring(data._maxPoint)
    local preogressRate = math.floor(data._currentPoint / data._maxPoint * 100)
    local workerGrade = data._workerGrade
    defalut_Control._worker_List._Button[index]:SetFontColor(ConvertFromGradeToColor(workerGrade))
    defalut_Control._worker_List._Button[index]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    defalut_Control._worker_List._Button[index]:SetText(name)
    defalut_Control._worker_List._ActionPoint[index]:SetText(actionPoint)
    defalut_Control._worker_List._Progress[index]:SetProgressRate(preogressRate)
    defalut_Control._worker_List._Button[index]:SetShow(true)
    defalut_Control._worker_List._Progress[index]:SetShow(true)
    if self._selected_WorkerKey == data._workerNoChar then
      defalut_Control._worker_List._Button[index]:SetCheck(true)
      defalut_Control._worker_List._ActionPoint[index]:SetShow(true)
      isSelectedWorker = true
    else
      defalut_Control._worker_List._Button[index]:SetCheck(false)
      defalut_Control._worker_List._ActionPoint[index]:SetShow(false)
    end
  end
  if false == isSelectedWorker then
  end
  defalut_Control._worker_List._Scroll:SetControlPos(self._offsetIndex / self._offset_Max)
  HandleOn_LargerCraft_Worker_List_Refresh()
end
function LargeCraft_Worker_List_Select(index)
  Subwork_Progress_List_SetWorkingCount(1)
  if Panel_Window_Exchange_Number:IsShow() then
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  end
  local selectedIndex = Worker_List._offsetIndex + index
  if nil ~= Worker_List._data_Table[selectedIndex] then
    Worker_List._selected_Worker = Worker_List._data_Table[selectedIndex]._workerNo
    Worker_List._selected_WorkerKey = Worker_List._data_Table[selectedIndex]._workerNoChar
    Worker_List._selected_Index = selectedIndex
    affiliatedTownKey = Worker_List._data_Table[selectedIndex]._homeWaypoint
    warehouse_requestInfo(affiliatedTownKey)
    if isUpdateResource then
      FGlobal_LargeCraft_WorkManager_Refresh(true)
    end
    defalut_Control._worker_List._No_Worker:SetShow(false)
  else
    defalut_Control._worker_List._No_Worker:SetShow(true)
  end
  defalut_Control._subWork_Estimated._Time_Count:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", Subwork_Progress_List_GetWorkingCount()))
  Worker_List:_updateSlot()
  SubWork_Estimated_Update()
end
function HandleOn_LargeCraft_Worker_List(index)
  Worker_List._over_Index = index
  defalut_Control._worker_List._ActionPoint[index]:SetShow(true)
  SubWork_Estimated_Update(false)
  local self = Worker_List
  local workerIndex = self._offsetIndex + index
  local npcWaitingWorker = ToClient_getNpcWorkerByWorkerNo(Worker_List._data_Table[workerIndex]._workerNo_s64)
  if nil ~= npcWaitingWorker then
    local uiBase = defalut_Control._worker_List._Button[index]
    FGlobal_ShowWorkerTooltipByWorkerNoRaw(Worker_List._data_Table[workerIndex]._workerNo_s64, uiBase, true)
  end
end
function HandleOut_LargeCraft_Worker_List()
  Worker_List._over_Index = nil
  Worker_List:_updateSlot()
  SubWork_Estimated_Update()
  FGlobal_HideWorkerTooltip()
end
function HandleOn_LargerCraft_Worker_List_Refresh()
  if nil ~= Worker_List._over_Index then
    HandleOut_LargeCraft_Worker_List(Worker_List._over_Index)
  end
end
local Subwork_Progress_List = {
  _workerList = nil,
  _workingCount = 1,
  _onGoingCount = nil,
  _rowMax = defalut_Control._subWork_Info._Template._rowMax,
  _contentRow = nil,
  _offsetIndex = nil,
  _offset_Max = nil,
  _last_offset = nil,
  _workingLeftCount = {}
}
function Subwork_Progress_List_SetWorkingCount(count)
  if nil == count or count < 1 then
    count = 1
  end
  Subwork_Progress_List._workingCount = count
end
function Subwork_Progress_List_GetWorkingCount()
  return Subwork_Progress_List._workingCount
end
function Subwork_Progress_List:_updateSlot()
  Subwork_Progress_List_UpdateSlot()
end
function Subwork_Progress_List_UpdateSlot(isRefresh, isOver)
  if 0 == Subwork_Progress_List._onGoingCount and true ~= isRefresh then
    return
  end
  if true == isRefresh then
    local workIndex = LargCraft_List._currentIndex
    local subWorkIndex = SubWork_List._selected_Index
    if isOver then
      subWorkIndex = SubWork_List._over_Index
    end
    Subwork_Progress_List._workerList = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._workerList
    Subwork_Progress_List._onGoingCount = #Subwork_Progress_List._workerList
    if 0 == Subwork_Progress_List._onGoingCount then
      defalut_Control._subWork_Info._OnGoing_Guide:SetShow(true)
      defalut_Control._subWork_Info._immediately:SetShow(false)
    else
      defalut_Control._subWork_Info._OnGoing_Guide:SetShow(false)
      if false then
        defalut_Control._subWork_Info._immediately:SetShow(true)
        defalut_Control._subWork_Info._immediately:addInputEvent("Mouse_LUp", "SubWork_List_Immediately_CraftItem()")
      end
    end
    local _offset_Max = Subwork_Progress_List._onGoingCount - Subwork_Progress_List._rowMax
    if _offset_Max < 0 then
      _offset_Max = 0
    end
    Subwork_Progress_List._offset_Max = _offset_Max
    Subwork_Progress_List._contentRow = Subwork_Progress_List._onGoingCount
    Subwork_Progress_List._offsetIndex = 0
    UIScroll.SetButtonSize(defalut_Control._subWork_Info._OnGoing_Scroll, Subwork_Progress_List._rowMax, Subwork_Progress_List._contentRow)
  end
  local isScrolled = Subwork_Progress_List._last_offset ~= Subwork_Progress_List._offsetIndex
  if true == isRefresh or isScrolled then
    FGlobal_Clear_Control(defalut_Control._subWork_Info._OnGoing_Time)
    FGlobal_Clear_Control(defalut_Control._subWork_Info._OnGoing_Progress_BG)
    FGlobal_Clear_Control(defalut_Control._subWork_Info._OnGoing_Progress)
    FGlobal_Clear_Control(defalut_Control._subWork_Info._OnGoing_Cancel)
    Subwork_Progress_List._last_offset = Subwork_Progress_List._offsetIndex
  end
  for idx = 1, Subwork_Progress_List._rowMax do
    local Index = Subwork_Progress_List._offsetIndex + idx
    local worker = Subwork_Progress_List._workerList[Index]
    if nil == worker then
      break
    end
    local workerNo = worker:get_s64()
    local progressRate = ToClient_getWorkingProgress(workerNo) * 100000
    local remainTime = Util.Time.timeFormatting(ToClient_getLeftWorkingTime(workerNo))
    if 0 < ToClient_getNpcWorkerWorkingCount(workerNo) then
      defalut_Control._subWork_Info._OnGoing_Cancel[idx]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_ONGOING", "workerNo", ToClient_getNpcWorkerWorkingCount(workerNo)))
    else
      defalut_Control._subWork_Info._OnGoing_Cancel[idx]:SetText("")
    end
    defalut_Control._subWork_Info._OnGoing_Time[idx]:SetText(remainTime)
    defalut_Control._subWork_Info._OnGoing_Progress[idx]:SetProgressRate(progressRate)
    if true == isRefresh or isScrolled then
      defalut_Control._subWork_Info._OnGoing_Time[idx]:SetShow(true)
      defalut_Control._subWork_Info._OnGoing_Progress_BG[idx]:SetShow(true)
      defalut_Control._subWork_Info._OnGoing_Progress[idx]:SetShow(true)
      defalut_Control._subWork_Info._OnGoing_Cancel[idx]:SetShow(true)
    end
  end
  if 0 ~= Subwork_Progress_List._offset_Max then
    defalut_Control._subWork_Info._OnGoing_Scroll:SetControlPos(Subwork_Progress_List._offsetIndex / Subwork_Progress_List._offset_Max)
  end
end
function SubWork_Info_Update(isWorkOver)
  local workIndex = LargCraft_List._currentIndex
  local subWorkIndex = SubWork_List._selected_Index
  if isWorkOver then
    subWorkIndex = SubWork_List._over_Index
  end
  local icon = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._itemIcon
  local key = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._resourceKey
  local name = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._itemName
  local gradeType = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._gradeType
  local haveCount = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._haveCount
  if haveCount < 1 then
    haveCount = "<PAColor0xFFDB2B2B>" .. haveCount .. "/1<PAOldColor>"
  else
    haveCount = tostring(haveCount) .. "/1"
  end
  if gradeType > 0 and gradeType <= #UI.itemSlotConfig.borderTexture then
    defalut_Control._subWork_Info._Resource_Icon_Border:ChangeTextureInfoName(UI.itemSlotConfig.borderTexture[gradeType].texture)
    local x1, y1, x2, y2 = setTextureUV_Func(defalut_Control._subWork_Info._Resource_Icon_Border, UI.itemSlotConfig.borderTexture[gradeType].x1, UI.itemSlotConfig.borderTexture[gradeType].y1, UI.itemSlotConfig.borderTexture[gradeType].x2, UI.itemSlotConfig.borderTexture[gradeType].y2)
    defalut_Control._subWork_Info._Resource_Icon_Border:getBaseTexture():setUV(x1, y1, x2, y2)
    defalut_Control._subWork_Info._Resource_Icon_Border:setRenderTexture(defalut_Control._subWork_Info._Resource_Icon_Border:getBaseTexture())
    defalut_Control._subWork_Info._Resource_Icon_Border:SetShow(true)
  else
    defalut_Control._subWork_Info._Resource_Icon_Border:SetShow(false)
  end
  defalut_Control._subWork_Info._Resource_Icon:ChangeTextureInfoName(icon)
  defalut_Control._subWork_Info._Resource_Name:SetText(name)
  defalut_Control._subWork_Info._Resource_Count:SetText(haveCount)
  Subwork_Progress_List_UpdateSlot(true, isWorkOver)
end
function SubWork_Estimated_Update(isWorkOver)
  local workIndex = LargCraft_List._currentIndex
  local subWorkIndex = SubWork_List._selected_Index
  if true == isWorkOver then
    subWorkIndex = SubWork_List._over_Index
  end
  local workerIndex = Worker_List._selected_Index
  if false == isWorkOver then
    workerIndex = Worker_List._over_Index
  end
  local distance = 0
  local workVolume = 0
  local workSpeed = 0
  local moveSpeed = 0
  if nil ~= LargCraft_List._data_Table[workIndex] then
    workVolume = LargCraft_List._data_Table[workIndex]._workVolume
    defalut_Control._subWork_Estimated._Work_Volume_Value:SetText(": " .. string.format("%.2f", workVolume))
  end
  if nil ~= Worker_List._data_Table[workerIndex] then
    distance = ToClient_getCalculateMoveDistance(Worker_List._data_Table[workerIndex]._workerNo, LargCraft_List._position) / 100
    workSpeed = Worker_List._data_Table[workerIndex]._workSpeed
    moveSpeed = Worker_List._data_Table[workerIndex]._moveSpeed
    defalut_Control._subWork_Estimated._Move_Distance_Value:SetText(": " .. string.format("%.0f", distance))
    defalut_Control._subWork_Estimated._Work_Speed_Value:SetText(": " .. string.format("%.2f", workSpeed))
    defalut_Control._subWork_Estimated._Move_Speed_Value:SetText(": " .. string.format("%.2f", moveSpeed))
  end
  if nil ~= LargCraft_List._data_Table[workIndex] and nil ~= Worker_List._data_Table[workerIndex] then
    local workBaseTime = ToClient_getNpcWorkingBaseTimeForHouse() / 1000
    local totalWorkTime = math.ceil(workVolume / math.floor(workSpeed)) * workBaseTime + distance / moveSpeed * 2
    defalut_Control._subWork_Estimated._Time_Value:SetText(Util.Time.timeFormatting(math.floor(totalWorkTime)))
  end
  local _fullCount = 0
  local _progressCount = 0
  local _onGoingCount = 0
  local _haveCount = 0
  local isFinished = false
  local isLastWork = false
  if nil ~= SubWork_List._data_Table[workIndex]._resource[subWorkIndex] then
    _fullCount = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._fullCount
    _progressCount = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._progressCount
    _onGoingCount = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._onGoingCount
    _haveCount = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._haveCount
    isFinished = _fullCount == _progressCount
    isLastWork = _fullCount == _progressCount + _onGoingCount
  end
  local isOnGoing = LargCraft_List._currentIndex == LargCraft_List._onGoingIndex
  if isOnGoing then
    if true == isFinished then
      defalut_Control._subWork_Estimated._Button_DoWork:SetShow(false)
      defalut_Control._subWork_Estimated._Cant_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Finished_Work:SetShow(true)
      defalut_Control._subWork_Estimated._Last_Work:SetShow(false)
      defalut_Control._subWork_Estimated._No_Resource_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Work_Count:SetShow(false)
    elseif true == isLastWork then
      defalut_Control._subWork_Estimated._Button_DoWork:SetShow(false)
      defalut_Control._subWork_Estimated._Cant_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Finished_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Last_Work:SetShow(true)
      defalut_Control._subWork_Estimated._No_Resource_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Work_Count:SetShow(false)
    elseif _haveCount < 1 then
      defalut_Control._subWork_Estimated._Button_DoWork:SetShow(false)
      defalut_Control._subWork_Estimated._Cant_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Finished_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Last_Work:SetShow(false)
      defalut_Control._subWork_Estimated._No_Resource_Work:SetShow(true)
      defalut_Control._subWork_Estimated._Work_Count:SetShow(false)
    else
      defalut_Control._subWork_Estimated._Button_DoWork:SetShow(true)
      defalut_Control._subWork_Estimated._Cant_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Finished_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Last_Work:SetShow(false)
      defalut_Control._subWork_Estimated._No_Resource_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Work_Count:SetShow(true)
    end
  elseif LargCraft_List._onGoingIndex == nil then
    if _haveCount < 1 then
      defalut_Control._subWork_Estimated._Button_DoWork:SetShow(false)
      defalut_Control._subWork_Estimated._Cant_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Finished_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Last_Work:SetShow(false)
      defalut_Control._subWork_Estimated._No_Resource_Work:SetShow(true)
      defalut_Control._subWork_Estimated._Work_Count:SetShow(false)
    else
      defalut_Control._subWork_Estimated._Button_DoWork:SetShow(true)
      defalut_Control._subWork_Estimated._Cant_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Finished_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Last_Work:SetShow(false)
      defalut_Control._subWork_Estimated._No_Resource_Work:SetShow(false)
      defalut_Control._subWork_Estimated._Work_Count:SetShow(true)
    end
  else
    defalut_Control._subWork_Estimated._Button_DoWork:SetShow(false)
    defalut_Control._subWork_Estimated._Cant_Work:SetShow(true)
    defalut_Control._subWork_Estimated._Finished_Work:SetShow(false)
    defalut_Control._subWork_Estimated._Last_Work:SetShow(false)
    defalut_Control._subWork_Estimated._No_Resource_Work:SetShow(false)
    defalut_Control._subWork_Estimated._Work_Count:SetShow(false)
  end
end
local Scroll_UpDown = function(isUp, _target)
  if false == isUp then
    _target._offsetIndex = math.min(_target._offset_Max, _target._offsetIndex + 1)
  else
    _target._offsetIndex = math.max(0, _target._offsetIndex - 1)
  end
  _target:_updateSlot()
end
function HandleScroll_SubWork_List_UpDown(isUp)
  Scroll_UpDown(isUp, SubWork_List)
end
function HandleScroll_LargeCraft_Worker_List_UpDown(isUp)
  Scroll_UpDown(isUp, Worker_List)
end
function HandleScroll_SubWork_Progress_List_UpDown(isUp)
  Scroll_UpDown(isUp, Subwork_Progress_List)
end
local ScrollOnClick = function(_target, _scroll)
  local _scroll_Button = _scroll:GetControlButton()
  local _scroll_Blank = _scroll:GetSizeY() - _scroll_Button:GetSizeY()
  local _scroll_Percent = _scroll_Button:GetPosY() / _scroll_Blank
  _target._offsetIndex = math.floor(_scroll_Percent * _target._offset_Max)
  _target:_updateSlot()
end
function HandleScroll_SubWork_List_OnClick()
  ScrollOnClick(SubWork_List, defalut_Control._subWork_List._Scroll)
end
function HandleScroll_LargeCraft_Worker_List_OnClick()
  ScrollOnClick(Worker_List, defalut_Control._worker_List._Scroll)
end
function HandleScroll_SubWork_Progress_List_OnClick()
  ScrollOnClick(Subwork_Progress_List, defalut_Control._subWork_Info._OnGoing_Scroll)
end
function Item_Tooltip_Show_LargeCraft(isResult)
  local workIndex = LargCraft_List._currentIndex
  local subWorkIndex = SubWork_List._selected_Index
  local staticStatusKey, uiBase
  if isResult then
    staticStatusKey = LargCraft_List._data_Table[workIndex]._resultKey
    uiBase = defalut_Control._largCraft_List._Icon_BG_1
  elseif false == isResult then
    staticStatusKey = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._resourceKey
    uiBase = defalut_Control._subWork_Info._Resource_Icon_BG
  end
  if nil == staticStatusKey or nil == uiBase then
    return
  end
  local staticStatusWrapper = getItemEnchantStaticStatus(staticStatusKey)
  Panel_Tooltip_Item_Show(staticStatusWrapper, uiBase, true, false)
end
function FGlobal_LargeCraft_WorkManager_Open(houseInfoSSWrapper, param)
  if nil == houseInfoSSWrapper then
    return
  end
  Worker_List._selected_Worker = nil
  Worker_List._selected_WorkerKey = nil
  Worker_List._selected_Index = nil
  Worker_List._over_Index = nil
  houseInfoSS = houseInfoSSWrapper:get()
  houseKey = houseInfoSSWrapper:getHouseKey()
  houseParam = param
  LargCraft_List:_setData(true)
  SubWork_List:_setData()
  Worker_List:_setData()
  SubWork_List:_updateSlot(true)
  Worker_List:_updateSlot()
  SubWork_List_Select(1)
  SubWork_List:_updateSlot()
  LargeCraft_Worker_List_Select(1)
  Worker_List:_updateSlot()
  LargCraft_List:_updateSlot()
  defalut_Control._title:SetText(houseParam._houseName)
  local PosX = Panel_HouseControl:GetPosX(PosX)
  local PosY = Panel_HouseControl:GetPosY(PosY)
  Panel_LargeCraft_WorkManager:SetPosX(PosX)
  Panel_LargeCraft_WorkManager:SetPosY(PosY)
  Panel_LargeCraft_WorkManager:SetShow(true)
end
function FGlobal_LargeCraft_WorkManager_Close()
  FGlobal_WorldMapWindowEscape()
end
function HandleClick_doWork_LargeCraft()
  if workerManager_CheckWorkingOtherChannelAndMsg() then
    return
  end
  local workCount = Subwork_Progress_List._workingCount
  local selected_Work = LargCraft_List._selectedWork
  local selected_SubWork = SubWork_List._selected_SubWork
  local selected_Worker = Worker_List._selected_Worker
  if nil == selected_Worker then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
    return
  elseif 0 == selected_Work then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkNotSelect"))
    LargCraft_List:_setData(isRefresh)
    FGlobal_LargeCraft_WorkManager_Refresh(false)
    return
  end
  local currentKey = ToClient_getLargeCraftExchangeKeyRaw(houseInfoSS)
  if currentKey ~= selected_Work then
    local workName = LargCraft_List._data_Table[LargCraft_List._currentIndex]._workName
    local _content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LARGECRAFT_WORKMANAGER_STARTWORK_CONTENT", "workName", workName)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_LARGECRAFT_WORKMANAGER_STARTWORK_TITLE"),
      content = _content,
      functionYes = HandleClick_doWork_LargeCraft_Continue,
      functionCancel = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "top")
  else
    if nil == LimitWorkableCount_LargeCraft() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
      return
    end
    if 0 < LimitWorkableCount_LargeCraft() then
      ToClient_requestStartLargeCraftToNpcWorker(houseInfoSS, selected_Worker, selected_Work, selected_SubWork, workCount)
      FGlobal_RedoWork(1, houseInfoSS, selected_Worker, nil, selected_Work, selected_SubWork, workCount, nil, nil, affiliatedTownKey)
    else
      local workerActionPoint = Worker_List._data_Table[Worker_List._selected_Index]._currentPoint
      if workerActionPoint > 0 then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_WORKERMANAGER_LARGECRAFT_MAXWORKCOUNT"))
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_HARVEST_MESSAGE_NEEDACTIONPOINT"))
      end
    end
  end
end
function HandleClick_doWork_LargeCraft_Continue()
  if 0 < LimitWorkableCount_LargeCraft() then
    local workCount = Subwork_Progress_List._workingCount
    local selected_Work = LargCraft_List._selectedWork
    local selected_SubWork = SubWork_List._selected_SubWork
    local selected_Worker = Worker_List._selected_Worker
    ToClient_requestChangeLargeCraftExchange(houseInfoSS, selected_Work)
    ToClient_requestStartLargeCraftToNpcWorker(houseInfoSS, selected_Worker, selected_Work, selected_SubWork, workCount)
    FGlobal_RedoWork(1, houseInfoSS, selected_Worker, nil, selected_Work, selected_SubWork, workCount, nil, nil, affiliatedTownKey)
  else
    local workerActionPoint = Worker_List._data_Table[Worker_List._selected_Index]._currentPoint
    if workerActionPoint > 0 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_WORKERMANAGER_LARGECRAFT_MAXWORKCOUNT"))
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_HARVEST_MESSAGE_NEEDACTIONPOINT"))
    end
  end
end
function LimitWorkableCount_LargeCraft()
  local workIndex = LargCraft_List._currentIndex
  local subWorkIndex = SubWork_List._selected_Index
  local totalWorkCount = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._fullCount
  local currentWorkCount = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._progressCount
  local workingCount = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._workingCount
  local workableCount = totalWorkCount - currentWorkCount - workingCount
  local resourceCount = SubWork_List._data_Table[workIndex]._resource[subWorkIndex]._haveCount
  if nil == Worker_List._data_Table[Worker_List._selected_Index] then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect"))
    return
  end
  local workerActionPoint = Worker_List._data_Table[Worker_List._selected_Index]._currentPoint
  local ongoingCount = SubWork_List._data_Table[workIndex]._onGoingCount
  local limitWorkableCount = 1
  if workableCount < resourceCount then
    limitWorkableCount = workableCount
  else
    limitWorkableCount = resourceCount
  end
  if workerActionPoint < limitWorkableCount then
    limitWorkableCount = workerActionPoint
  end
  return limitWorkableCount
end
function Set_Workable_Count_LargetCraft(inputNumber)
  Subwork_Progress_List._workingCount = Int64toInt32(inputNumber)
  defalut_Control._subWork_Estimated._Time_Count:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKMANAGER_BUILDING_DEFAULT", "getWorkingCount", Subwork_Progress_List._workingCount))
end
function HandleClicked_WorkCount_LargeCraft()
  local s64_MaxWorkableCount = toInt64(0, LimitWorkableCount_LargeCraft())
  if s64_MaxWorkableCount <= toInt64(0, 0) then
    _PA_LOG("\236\157\180\235\172\184\236\162\133", "\236\157\188\234\190\188\236\157\180 \236\158\145\236\151\133\237\149\160 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.")
  else
    Panel_NumberPad_Show(true, s64_MaxWorkableCount, 0, Set_Workable_Count_LargetCraft)
  end
end
local worker_StopWork
function HandleClick_OnGoing_Cancel_LargeCraft(idx)
  local index = Subwork_Progress_List._offsetIndex + idx
  if nil ~= Subwork_Progress_List._workerList[index] then
    worker_StopWork = Subwork_Progress_List._workerList[index]
  else
    return
  end
  local _workerNo = worker_StopWork:get_s64()
  local _leftWorkCount = ToClient_getNpcWorkerWorkingCount(_workerNo)
  if _leftWorkCount < 1 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKING_PROGRESS_LEFTWORKCOUNT_ACK"))
    return
  else
    local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(_workerNo)
    local workName = esSSW:getDescription()
    local cancelWorkContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LARGECRAFT_WORKMANAGER_CANCELWORK_CONTENT", "workName", workName)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_LARGECRAFT_WORKMANAGER_CANCELWORK_TITLE"),
      content = cancelWorkContent,
      functionYes = HandleClick_OnGoing_Cancel_LargeCraft_Continue,
      functionCancel = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "top")
  end
end
function HandleClick_OnGoing_Cancel_LargeCraft_Continue()
  ToClient_requestCancelNextWorking(worker_StopWork)
  worker_StopWork = nil
end
function FromClient_LargeCraft_WorkManager_StopWorkerWorking(workerNo, isUserRequest)
  if true == _Cancel_All then
    local workingCout = ToClient_getHouseWorkingWorkerList(houseInfoSS)
    if workingCout < 1 then
      _Cancel_All = false
      ToClient_requestChangeLargeCraftExchange(houseInfoSS, 0)
      FGlobal_WorldMapWindowEscape()
    end
    return
  end
  FGlobal_LargeCraft_WorkManager_Refresh(false)
end
function FromClient_LargeCraft_WorkManager_WorkerDataUpdate(rentHouseWrapper)
  local _HouseKey = rentHouseWrapper:getStaticStatus():getHouseKey()
  if _HouseKey == houseKey then
    FGlobal_LargeCraft_WorkManager_Refresh(false)
  end
end
function FromClient_LargeCraft_WorkManager_ClearLargeCraft(characterKey)
  if characterKey == houseKey then
    local workName = LargCraft_List._data_Table[LargCraft_List._currentIndex]._workName
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LARGECRAFT_WORKMANAGER_CANCELED", "workName", workName))
    FGlobal_LargeCraft_WorkManager_Refresh(false)
  end
end
function FromClient_LargeCraft_WorkManager_changeLeftWorking(workerNoRaw)
  FGlobal_LargeCraft_WorkManager_Refresh()
end
function FGlobal_LargeCraft_WorkManager_Refresh(dontUpdateWorker)
  if Panel_LargeCraft_WorkManager:GetShow() then
    LargCraft_List:_setData()
    SubWork_List:_setData()
    if false == dontUpdateWorker then
      Worker_List:_setData()
    end
    LargCraft_List:_updateSlot()
    SubWork_List:_updateSlot()
    if false == dontUpdateWorker then
      Worker_List:_updateSlot()
    end
    SubWork_Info_Update()
    if nil == Worker_List._selected_Index then
      LargeCraft_Worker_List_Select(1)
    end
  end
end
function FromClient_WareHouse_Update_ForLargeCraft(_affiliatedTownKey)
  if affiliatedTownKey == _affiliatedTownKey and true == Panel_LargeCraft_WorkManager:GetShow() then
    FGlobal_LargeCraft_WorkManager_Refresh(true)
  end
end
Panel_LargeCraft_WorkManager:RegisterUpdateFunc("Subwork_Progress_List_UpdateSlot")
registerEvent("WorldMap_StopWorkerWorking", "FromClient_LargeCraft_WorkManager_StopWorkerWorking")
registerEvent("WorldMap_WorkerDataUpdateByHouse", "FromClient_LargeCraft_WorkManager_WorkerDataUpdate")
registerEvent("FromClient_ReceiveClearLargeCraft", "FromClient_LargeCraft_WorkManager_ClearLargeCraft")
registerEvent("EventWarehouseUpdate", "FromClient_WareHouse_Update_ForLargeCraft")
registerEvent("FromClient_changeLeftWorking", "FromClient_LargeCraft_WorkManager_changeLeftWorking")

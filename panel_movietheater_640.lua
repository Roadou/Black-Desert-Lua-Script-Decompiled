local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_MovieTheater_640:ActiveMouseEventEffect(true)
Panel_MovieTheater_640:setGlassBackground(true)
Panel_MovieTheater_640:SetShow(false, false)
Panel_MovieTheater_640:RegisterShowEventFunc(true, "Panel_MovieTheater640_ShowAni()")
Panel_MovieTheater_640:RegisterShowEventFunc(false, "Panel_MovieTheater640_HideAni()")
function Panel_MovieTheater640_ShowAni()
  UIAni.AlphaAnimation(1, Panel_MovieTheater_640, 0, 0.15)
  local aniInfo1 = Panel_MovieTheater_640:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_MovieTheater_640:GetSizeX() / 2
  aniInfo1.AxisY = Panel_MovieTheater_640:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_MovieTheater_640:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_MovieTheater_640:GetSizeX() / 2
  aniInfo2.AxisY = Panel_MovieTheater_640:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_MovieTheater640_HideAni()
  local aniInfo = UIAni.AlphaAnimation(0, Panel_MovieTheater_640, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local _btn_Close = UI.getChildControl(Panel_MovieTheater_640, "Button_Close")
local _btn_Replay = UI.getChildControl(Panel_MovieTheater_640, "Button_Replay")
local _txt_Title = UI.getChildControl(Panel_MovieTheater_640, "StaticText_Title")
local _movieTheater_640 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_MovieTheater_640, "WebControl_WorldmapGuide")
_btn_Close:addInputEvent("Mouse_LUp", "Panel_MovieTheater640_WindowClose()")
_btn_Replay:addInputEvent("Mouse_LUp", "Panel_MovieTheater640_Replay()")
_movieTheater_640:addInputEvent("Mouse_Out", "Panel_MovieTheater640_HideControl()")
_movieTheater_640:addInputEvent("Mouse_On", "Panel_MovieTheater640_ShowControl()")
function Panel_MovieTheater640_Initialize()
  _movieTheater_640:SetPosX(5)
  _movieTheater_640:SetPosY(50)
  _movieTheater_640:SetSize(640, 480)
  _movieTheater_640:SetUrl(640, 480, "coui://UI_Data/UI_Html/UI_Guide_Movie_640.html")
  Panel_MovieTheater_640:SetSize(Panel_MovieTheater_640:GetSizeX(), 577)
end
local playedNo = 0
local movieDesc = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_0"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_1"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_2"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_3"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_4"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_640_MOVIEDESC_DEFAULT"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_640_MOVIEDESC_SKILLCOMBO"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_10"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_11"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_12"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_13"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_14"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_15"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_16"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_17"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_18"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_19"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_20"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_21"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_22"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_23"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_24"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_25"),
  PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_26")
}
local prevTitleNo = -1
function Panel_MovieTheater640_GameGuide_Func(titleNo)
  if isGameTypeGT() then
    return
  end
  if not _movieTheater_640:isReadyView() then
    return
  end
  _movieTheater_640:TriggerEvent("ControlAudio", getVolumeParam(0) / 100)
  local isShow = Panel_MovieTheater_640:IsShow()
  if isShow == true and prevTitleNo == titleNo then
    Panel_MovieTheater_640:SetShow(false, true)
    prevTitleNo = -1
    return
  elseif 6 ~= titleNo then
    Panel_MovieTheater_640:SetShow(true, true)
    _movieTheater_640:SetShow(true)
    Panel_Window_SkillGuide_Close()
    Panel_MovieTheater_SkillGuide_640_JustClose()
  end
  _txt_Title:SetText(movieDesc[titleNo])
  if titleNo == 0 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_02.webm")
    playedNo = 0
  elseif titleNo == 1 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_01.webm")
    playedNo = 1
  elseif titleNo == 2 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_20_FindWay.webm")
    playedNo = 2
  elseif titleNo == 3 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_21_LearnSkill.webm")
    playedNo = 3
  elseif titleNo == 4 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_22_FindTarget.webm")
    playedNo = 4
  elseif titleNo == 5 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Control.webm")
    playedNo = 5
  elseif titleNo == 6 then
    Panel_Window_SkillGuide_ShowToggle()
  elseif titleNo == 7 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_03.webm")
    playedNo = 7
  elseif titleNo == 8 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_04.webm")
    playedNo = 8
  elseif titleNo == 9 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_05.webm")
    playedNo = 9
  elseif titleNo == 10 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_06.webm")
    playedNo = 10
  elseif titleNo == 11 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_07.webm")
    playedNo = 11
  elseif titleNo == 12 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_08.webm")
    playedNo = 12
  elseif titleNo == 13 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_09_Fish.webm")
    playedNo = 13
  elseif titleNo == 14 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_10_Wp.webm")
    playedNo = 14
  elseif titleNo == 15 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_11_Dial.webm")
    playedNo = 15
  elseif titleNo == 16 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_12_Intimacy.webm")
    playedNo = 16
  elseif titleNo == 17 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_13_MoveHouse.webm")
    playedNo = 17
  elseif titleNo == 18 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_14_Cook.webm")
    playedNo = 18
  elseif titleNo == 19 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_15_Alchemy.webm")
    playedNo = 19
  elseif titleNo == 20 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_16_Tent.webm")
    playedNo = 20
  elseif titleNo == 21 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_17_QuestFilter.webm")
    playedNo = 21
  elseif titleNo == 22 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_18_Findway.webm")
    playedNo = 22
  elseif titleNo == 23 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_19_BlackRage.webm")
    playedNo = 23
  end
  prevTitleNo = titleNo
end
function Panel_MovieTheater640_Replay()
  if not _movieTheater_640:isReadyView() then
    return
  end
  if playedNo == 0 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_02.webm")
  elseif playedNo == 1 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_01.webm")
  elseif playedNo == 2 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_20_FindWay.webm")
  elseif playedNo == 3 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_21_LearnSkill.webm")
  elseif playedNo == 4 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_22_FindTarget.webm")
  elseif playedNo == 5 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Control.webm")
  elseif playedNo == 6 then
  elseif playedNo == 7 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_03.webm")
  elseif playedNo == 8 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_04.webm")
  elseif playedNo == 9 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_05.webm")
  elseif playedNo == 10 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_06.webm")
  elseif playedNo == 11 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_07.webm")
  elseif playedNo == 12 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_08.webm")
  elseif playedNo == 13 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_09_Fish.webm")
  elseif playedNo == 14 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_10_Wp.webm")
  elseif playedNo == 15 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_11_Dial.webm")
  elseif playedNo == 16 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_12_Intimacy.webm")
  elseif playedNo == 17 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_13_MoveHouse.webm")
  elseif playedNo == 18 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_14_Cook.webm")
  elseif playedNo == 19 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_15_Alchemy.webm")
  elseif playedNo == 20 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_16_Tent.webm")
  elseif playedNo == 21 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_17_QuestFilter.webm")
  elseif playedNo == 22 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_18_Findway.webm")
  elseif playedNo == 23 then
    _movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_19_BlackRage.webm")
  end
end
function Panel_MovieTheater640_WindowClose()
  Panel_MovieTheater_640:SetShow(false, false)
  _movieTheater_640:TriggerEvent("ControlAudio", 0)
  if Panel_WorldMap:GetShow() then
    Panel_Worldmap_MovieGuide_Close()
  end
end
function Panel_MovieTheater640_Reset()
  _movieTheater_640:ResetUrl()
end
function FGlobal_Panel_MovieTheater640_WindowClose()
  Panel_MovieTheater_640:SetShow(false, true)
  Panel_MovieTheater640_Reset()
end
function Panel_MovieTheater640_ShowControl()
  if isGameTypeGT() then
    return
  end
  _movieTheater_640:TriggerEvent("ShowControl", "true")
end
function Panel_MovieTheater640_HideControl()
  _movieTheater_640:TriggerEvent("ShowControl", "false")
end

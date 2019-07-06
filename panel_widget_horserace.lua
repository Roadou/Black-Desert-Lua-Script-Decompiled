local Panel_Widget_HorseRace_info = {
  _RaceInfo_static_MainBG = UI.getChildControl(Panel_Window_HorseRace, "Race_MainBG"),
  _RaceInfo_txt_Title = UI.getChildControl(Panel_Window_HorseRace, "StaticText_RaceTitle"),
  _RaceInfo_static_BG = UI.getChildControl(Panel_Window_HorseRace, "Race_BG"),
  _RaceInfo_txt_PlayerIcon = UI.getChildControl(Panel_Window_HorseRace, "Race_Player_Icon"),
  _RaceInfo_txt_PlayerTitle = UI.getChildControl(Panel_Window_HorseRace, "Race_Player_Text"),
  _RaceInfo_txt_PlayerValue = UI.getChildControl(Panel_Window_HorseRace, "Race_Player_Value"),
  _RaceInfo_txt_RemainIcon = UI.getChildControl(Panel_Window_HorseRace, "Race_Time_Icon"),
  _RaceInfo_txt_RemainTitle = UI.getChildControl(Panel_Window_HorseRace, "Race_RemainTime_Text"),
  _RaceInfo_txt_RemainValue = UI.getChildControl(Panel_Window_HorseRace, "Race_RemainTime_Value"),
  _RaceInfo_txt_Tier = UI.getChildControl(Panel_Window_HorseRace, "Race_RegTier_Text"),
  _RaceInfo_txt_TierValue = UI.getChildControl(Panel_Window_HorseRace, "Race_RegTier_Value"),
  _RaceInfo_txt_Stat = UI.getChildControl(Panel_Window_HorseRace, "Race_RegStatus_Text"),
  _RaceInfo_btn_Join = UI.getChildControl(Panel_Window_HorseRace, "Race_Button_JoinRace"),
  _RaceInfo_btn_Cancel = UI.getChildControl(Panel_Window_HorseRace, "Race_Button_CancelRace"),
  _RaceInfo_txt_Desc = UI.getChildControl(Panel_Window_HorseRace, "StaticText_Desc"),
  _RaceInfo_btn_Close = UI.getChildControl(Panel_Window_HorseRace, "Button_WinClose")
}
Panel_Widget_HorseRace_info._RaceInfo_btn_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_RaceInfo_Toggle()")
local raceRaedy = false
function PaGlobalFunc_RaceInfo_Toggle()
  local isRaceChannel = ToClient_IsHorseRaceChannel()
  if isRaceChannel then
    if Panel_Window_HorseRace:GetShow() then
      PaGlobalFunc_RaceInfo_Hide()
    else
      ToClient_RequestMatchInfo(CppEnums.MatchType.Race)
    end
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_MAINCHANNEL_HORSERACE"))
  end
end
function PaGlobalFunc_RaceInfo_Hide()
  Panel_Window_HorseRace:SetShow(false)
end
function PaGlobalFunc_RaceInfo_Join()
  ToClient_RegisterRaceMatch()
  ToClient_RequestMatchInfo(CppEnums.MatchType.Race)
end
function PaGlobalFunc_RaceInfo_Cancel()
  ToClient_UnRegisterRaceMatch()
  ToClient_RequestMatchInfo(CppEnums.MatchType.Race)
end
local matchStateMemo = "-"
local matchStateTime = "0"
local matchPlayer = "0"
local matchTier = "- "
function FGlobal_RaceInfo_Open(isRegister, registerCount, remainedMinute, matchState, param1)
  local self = Panel_Widget_HorseRace_info
  Panel_Window_HorseRace:SetShow(true)
  self._RaceInfo_btn_Join:addInputEvent("Mouse_LUp", "PaGlobalFunc_RaceInfo_Join()")
  self._RaceInfo_btn_Cancel:addInputEvent("Mouse_LUp", "PaGlobalFunc_RaceInfo_Cancel()")
  local color = Defines.Color.C_FF888888
  if 0 == matchState then
    matchStateMemo = "<PAColor0xFFDDCD82>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_1") .. "<PAOldColor>\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACE_IMPOSSIBLE")
    matchStateTime = remainedMinute + 1
    matchPlayer = "- "
    matchTier = "- "
  elseif 1 == matchState then
    matchStateMemo = "<PAColor0xFFDDCD82>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_2") .. "<PAOldColor>\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACE_POSSIBLE")
    matchStateTime = remainedMinute + 1
    matchPlayer = registerCount
    matchTier = param1
  elseif 2 == matchState then
    matchStateMemo = "<PAColor0xFFDDCD82>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_3") .. "<PAOldColor>\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACE_IMPOSSIBLE")
    matchStateTime = remainedMinute + 1
    matchPlayer = "- "
    matchTier = "- "
  elseif 3 == matchState then
    matchStateMemo = "<PAColor0xFFDDCD82>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_4") .. "<PAOldColor>\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACE_IMPOSSIBLE")
    matchStateTime = "0"
    matchPlayer = "- "
    matchTier = "- "
  elseif 4 == matchState then
    matchStateMemo = "<PAColor0xFFDDCD82>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_5") .. "<PAOldColor>\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACE_IMPOSSIBLE")
    matchStateTime = "0"
    matchPlayer = "- "
    matchTier = "- "
  end
  if isRegister then
    raceRaedy = true
    Panel_Window_HorseRace:SetShow(true)
    self._RaceInfo_txt_PlayerValue:SetText(tostring(registerCount) .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_OPEN_PEOPLE"))
    self._RaceInfo_txt_RemainValue:SetText(matchStateTime .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_OPEN_MINUTE"))
    self._RaceInfo_txt_TierValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_OPEN_GENERATION", "param", param1))
    self._RaceInfo_txt_Stat:SetText(matchStateMemo)
    self._RaceInfo_btn_Join:SetShow(true)
    self._RaceInfo_btn_Join:SetMonoTone(false)
    self._RaceInfo_btn_Join:SetIgnore(false)
    self._RaceInfo_btn_Join:SetFontColor(Defines.Color.C_FFEFEFEF)
    self._RaceInfo_btn_Cancel:SetShow(true)
    self._RaceInfo_btn_Cancel:SetMonoTone(false)
    self._RaceInfo_btn_Cancel:SetIgnore(false)
    self._RaceInfo_btn_Cancel:SetFontColor(Defines.Color.C_FFEFEFEF)
  else
    raceRaedy = false
    Panel_Window_HorseRace:SetShow(true)
    self._RaceInfo_txt_PlayerValue:SetText(matchPlayer .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_OPEN_PEOPLE"))
    self._RaceInfo_txt_RemainValue:SetText(matchStateTime .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_OPEN_MINUTE"))
    self._RaceInfo_txt_TierValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_RACEINFO_OPEN_GENERATION", "param", param1))
    self._RaceInfo_txt_Stat:SetText(matchStateMemo)
    self._RaceInfo_btn_Join:SetShow(true)
    self._RaceInfo_btn_Join:SetMonoTone(true)
    self._RaceInfo_btn_Join:SetIgnore(true)
    self._RaceInfo_btn_Join:SetFontColor(color)
    self._RaceInfo_btn_Cancel:SetShow(true)
    self._RaceInfo_btn_Cancel:SetMonoTone(true)
    self._RaceInfo_btn_Cancel:SetIgnore(true)
    self._RaceInfo_btn_Cancel:SetFontColor(color)
  end
  local raceInfoTextSizeY = self._RaceInfo_txt_Stat:GetTextSizeY()
  local raceInfoTextPosY = self._RaceInfo_txt_Stat:GetPosY()
  local raceJoinButtonPosY = self._RaceInfo_btn_Join:GetPosY()
  local sizeY = 0
  if raceJoinButtonPosY < raceInfoTextPosY + raceInfoTextSizeY then
    sizeY = raceInfoTextPosY + raceInfoTextSizeY - raceJoinButtonPosY
    self._RaceInfo_btn_Join:SetPosY(raceJoinButtonPosY + sizeY)
    self._RaceInfo_btn_Cancel:SetPosY(raceJoinButtonPosY + sizeY)
  end
  self._RaceInfo_static_BG:SetSize(self._RaceInfo_static_BG:GetSizeX(), self._RaceInfo_static_BG:GetSizeY() + sizeY)
  local button = PaGlobalFunc_Widget_FunctionButton_Control(Widget_Function_Type.HorseRace)
  Panel_Window_HorseRace:SetPosX(Panel_Widget_Function:GetPosX() + button:GetPosX() - Panel_Window_HorseRace:GetSizeX() / 2)
  Panel_Window_HorseRace:SetPosY(Panel_Widget_Function:GetPosY() + button:GetSizeY() + 10)
  Panel_Window_HorseRace:SetSize(Panel_Window_HorseRace:GetSizeX(), Panel_Window_HorseRace:GetSizeY() + sizeY)
end
function FGlobal_RaceInfo_MessageManager(msgType)
  if 0 == msgType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_HORSERACE_COMPLETE"))
  elseif 1 == msgType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_HORSERACE_CANCEL"))
  end
end

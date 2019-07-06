local _buttonRewardBG = UI.getChildControl(Panel_Event_100Day, "Button_Reward_BG")
local _buttonRewardGet = UI.getChildControl(Panel_Event_100Day, "Button_Reward_Get")
local _StaticText_Title = UI.getChildControl(Panel_Event_100Day, "StaticText_Title")
local _btn_Close = UI.getChildControl(Panel_Event_100Day, "Button_Win_Close")
local _EventUserName = UI.getChildControl(Panel_Event_100Day, "EventUserName")
local _EventItemIcon = UI.getChildControl(Panel_Event_100Day, "Static_EventItemIcon")
local _EventBeginnerBG = UI.getChildControl(Panel_Event_100Day, "EventBeginnerBG")
local _EventGameExit = UI.getChildControl(Panel_Event_100Day, "Button_GameExit")
local _EventCancle = UI.getChildControl(Panel_Event_100Day, "Button_GameExitCancle")
function FGlobal_Event_100Day_Init()
  local player = getSelfPlayer()
  local classType = getSelfPlayer():getClassType()
  if nil == player then
    return
  end
  _EventItemIcon:SetShow(false)
  _EventUserName:SetShow(false)
  Panel_Event_100Day:SetShow(false)
end
function FGlobal_Event_100Day_Open()
  Panel_Event_100Day:SetShow(true)
end
function FGlobal_Event_100Day_GameExitOpen()
  _EventBeginnerBG:ChangeTextureInfoName("New_UI_Common_forLua/Window/Event/eventBeginnerExitBG.dds")
  Panel_Event_100Day:SetSize(770, 630)
  _EventGameExit:SetShow(true)
  _EventCancle:SetShow(true)
  Panel_Event_100Day:ComputePos()
  _EventBeginnerBG:ComputePos()
  _EventGameExit:ComputePos()
  _EventCancle:ComputePos()
  _btn_Close:ComputePos()
  _StaticText_Title:ComputePos()
  _EventItemIcon:SetPosX(85)
  _EventUserName:SetPosX(94)
  Panel_Event_100Day:SetPosY(Panel_Event_100Day:GetPosY() - 100)
  Panel_Event_100Day:SetShow(true)
  _buttonRewardGet:SetShow(false)
  _buttonRewardBG:SetShow(false)
end
function HandleClickedChallengeReward()
  audioPostEvent_SystemUi(0, 5)
  _AudioPostEvent_SystemUiForXBOX(0, 5)
  if nil ~= PaGlobal_CharacterInfoPanel_GetShowPanelStatus and false == PaGlobal_CharacterInfoPanel_GetShowPanelStatus() then
    PaGlobal_CharacterInfoPanel_SetShowPanelStatus(true)
    audioPostEvent_SystemUi(1, 34)
    _AudioPostEvent_SystemUiForXBOX(1, 34)
  end
  if _ContentsGroup_isUsedNewCharacterInfo == false then
    HandleClicked_CharacterInfo_Tab(3)
  else
    PaGlobal_CharacterInfo:showWindow(3)
  end
  HandleClickedTapButton(2)
  Panel_Event_100Day:SetShow(false)
end
function FGlobal_Event_100Day_Close()
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
  Panel_Event_100Day:SetShow(false, false)
end
function HandleClicked_event_100Day_Close()
  FGlobal_Event_100Day_Close()
end
function HandleClicked_GameOff_Yes()
  FGlobal_Event_100Day_Close()
  Panel_GameExit_GameOff_Yes()
end
function registEventHandler()
  _btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_event_100Day_Close()")
  _buttonRewardGet:addInputEvent("Mouse_LUp", "HandleClickedChallengeReward()")
  _EventGameExit:addInputEvent("Mouse_LUp", "HandleClicked_GameOff_Yes()")
  _EventCancle:addInputEvent("Mouse_LUp", "HandleClicked_event_100Day_Close()")
end
FGlobal_Event_100Day_Init()
if true ~= isGameTypeKorea() or ToClient_GetUserPlayMinute() < 2880 then
end
registEventHandler()

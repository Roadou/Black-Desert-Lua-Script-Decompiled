Panel_BeginnerReward:SetShow(false)
local _buttonRewardGet = UI.getChildControl(Panel_BeginnerReward, "Button_Reward_Get")
local _btn_Close = UI.getChildControl(Panel_BeginnerReward, "Button_Win_Close")
function beginnerReward_Init()
  Panel_BeginnerReward:SetShow(true)
end
function HandleClickedChallengeReward()
  audioPostEvent_SystemUi(0, 5)
  if nil ~= PaGlobal_CharacterInfoPanel_GetShowPanelStatus and false == PaGlobal_CharacterInfoPanel_GetShowPanelStatus() then
    PaGlobal_CharacterInfoPanel_SetShowPanelStatus(true)
    audioPostEvent_SystemUi(1, 34)
  end
  if _ContentsGroup_isUsedNewCharacterInfo == false then
    HandleClicked_CharacterInfo_Tab(3)
  else
    PaGlobal_CharacterInfo:showWindow(3)
  end
  HandleClickedTapButton(2)
  Panel_BeginnerReward:SetShow(false)
end
function beginnerReward_Close()
  audioPostEvent_SystemUi(13, 5)
  Panel_BeginnerReward:SetShow(false, false)
end
function HandleClicked_beginnerReward_Close()
  beginnerReward_Close()
end
function beginnerReward:registEventHandler()
  _btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_beginnerReward_Close()")
  _buttonRewardGet:addInputEvent("Mouse_LUp", "HandleClickedChallengeReward()")
end
if ToClient_GetUserPlayMinute() < 1440 then
  beginnerReward_Init()
end
beginnerReward:registEventHandler()

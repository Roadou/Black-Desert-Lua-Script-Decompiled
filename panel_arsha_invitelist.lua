local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
Panel_Window_ArshaInviteList:SetShow(false)
local arshaPvPInviteList = {
  _btn_Close = UI.getChildControl(Panel_Window_ArshaInviteList, "Button_Close"),
  _list2 = UI.getChildControl(Panel_Window_ArshaInviteList, "List2_ArshaInviteList")
}
function CompetitionGame_InviteList_Init()
  local self = arshaPvPInviteList
  self._list2:changeAnimationSpeed(10)
  self._list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "ArshaPvP_InviteListUpdate")
  self._list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._btn_Close:addInputEvent("Mouse_LUp", "FGlobal_ArshaPvP_InviteList_Close()")
end
function ArshaPvP_InviteListUpdate(contents, key)
  local idx = Int64toInt32(key)
  local _txt_Level = UI.getChildControl(contents, "StaticText_Level")
  _txt_Level:SetShow(true)
  _txt_Level:SetPosX(17)
  _txt_Level:SetPosY(5)
  local _txt_Class = UI.getChildControl(contents, "StaticText_Class")
  _txt_Class:SetShow(true)
  _txt_Class:SetPosX(110)
  _txt_Class:SetPosY(5)
  local _txt_Name = UI.getChildControl(contents, "StaticText_Name")
  _txt_Name:SetShow(true)
  _txt_Name:SetPosX(340)
  _txt_Name:SetPosY(5)
  local _txt_KindOf = UI.getChildControl(contents, "StaticText_KindOf")
  _txt_KindOf:SetShow(true)
  local _btn_InviteAccept = UI.getChildControl(contents, "Button_InviteAccept")
  _btn_InviteAccept:SetShow(true)
  local _btn_InviteDeny = UI.getChildControl(contents, "Button_InviteDeny")
  _btn_InviteDeny:SetShow(true)
  local waitListInfo = ToClient_GetJoinRequesterListAt(idx)
  if nil ~= waitListInfo then
    local userNo = waitListInfo:getUserNo()
    local userLevel = waitListInfo:getCharacterLevel()
    local userClass = waitListInfo:getCharacterClass()
    local userName = waitListInfo:getUserName()
    local characterName = waitListInfo:getCharacterName()
    local teamNo = waitListInfo:getTeamNo()
    local kindOfValue = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_PARTICIPANT")
    if 0 == teamNo then
      kindOfValue = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_PARTICIPANT")
    else
      kindOfValue = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_OBSERVER")
    end
    _txt_Level:SetText(userLevel)
    _txt_Class:SetText(getCharacterClassName(userClass))
    _txt_Name:SetText(characterName)
    _txt_KindOf:SetText(tostring(kindOfValue))
    _btn_InviteAccept:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_JoinDecision(" .. idx .. ", true)")
    _btn_InviteDeny:addInputEvent("Mouse_LUp", "HandleClicked_ArshaPvP_JoinDecision(" .. idx .. ", false)")
  end
end
function ArshaPvP_InviteList_SelectedUpdate()
  local self = arshaPvPInviteList
  local ListCount = ToClient_GetJoinRequesterListCount()
  self._list2:getElementManager():clearKey()
  if ListCount > 0 then
    for idx = 0, ListCount - 1 do
      self._list2:getElementManager():pushKey(toInt64(0, idx))
    end
  end
end
function HandleClicked_ArshaPvP_JoinDecision(idx, isAccept)
  if nil == idx then
    return
  end
  local waitListInfo = ToClient_GetJoinRequesterListAt(idx)
  local userNo_s64 = waitListInfo:getUserNo()
  ToClient_ResponseJoinCompetition(userNo_s64, isAccept)
end
function FromClient_UpdateJoinRequesterList()
  local self = arshaPvPInviteList
  ArshaPvP_InviteList_SelectedUpdate()
end
function FGlobal_ArshaPvP_InviteList_Open()
  local self = arshaPvPInviteList
  Panel_Window_ArshaInviteList:SetShow(true)
  ArshaPvP_InviteList_SelectedUpdate()
end
function FGlobal_ArshaPvP_InviteList_Close()
  Panel_Window_ArshaInviteList:SetShow(false)
end
CompetitionGame_InviteList_Init()
registerEvent("FromClient_UpdateJoinRequesterList", "FromClient_UpdateJoinRequesterList")

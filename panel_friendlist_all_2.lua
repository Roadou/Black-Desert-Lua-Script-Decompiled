function PaGlobal_FriendList_Show_All()
  if nil == Panel_FriendList_All then
    return
  end
  PaGlobal_FriendList_All:prepareOpen()
end
function PaGlobal_FriendList_Hide_All()
  if nil == Panel_FriendList_All then
    return
  end
  PaGlobal_FriendList_All:prepareClose()
end
function ResponseFriendList_updateFriends_All()
  if nil == Panel_FriendList_All then
    return
  end
  if PaGlobal_FriendList_All._tab._consoleFriendTab == PaGlobal_FriendList_All._currentTab then
    PaGlobal_FriendList_All:updateFriendListForConsole()
  else
    PaGlobal_FriendList_All:updateFriendList()
  end
end
function FromClient_NoticeNewMessage_All(isSoundNotice, isEffectNotice)
  if nil == Panel_FriendList_All then
    return
  end
  if isEffectNotice and false == Panel_FriendList_All:GetShow() then
    UIMain_FriendListUpdate()
    if false == _ContentsGroup_RemasterUI_Main_Alert then
      UIMain_FriendsUpdate()
    end
  end
  if isSoundNotice then
    audioPostEvent_SystemUi(3, 11)
  end
end
function PaGlobal_FriendList_ChangeTab_All()
  if nil == Panel_FriendList_All then
    return
  end
  if PaGlobal_FriendList_All._tab._consoleFriendTab == PaGlobal_FriendList_All._currentTab then
    PaGlobal_FriendList_All._currentTab = PaGlobal_FriendList_All._tab._pcFriendTab
  else
    PaGlobal_FriendList_All._currentTab = PaGlobal_FriendList_All._tab._consoleFriendTab
  end
  PaGlobal_FriendList_All:updateTab()
end
function PaGlobal_FriendListAdd_Close_All()
  if nil == Panel_FriendList_Add_All then
    return
  end
  PaGlobal_AddFriend_All:prepareClose()
end
function PaGlobal_FriendListAdd_Open_All()
  if nil == Panel_FriendList_Add_All then
    return
  end
  PaGlobal_AddFriend_All:prepareOpen()
end
function PaGlobal_FriendListAdd_CheckCurrentUiEdit_All(targetUI)
  return nil ~= targetUI and targetUI:GetKey() == PaGlobal_AddFriend_All._ui.edit_Name:GetKey()
end
function PaGlobal_FriendRequestList_Close_All()
  if nil == Panel_Friend_RequestList_All then
    return
  end
  PaGlobal_FriendRequest_All:prepareClose()
end
function PaGlobal_FriendRequestList_Open_All()
  if nil == Panel_Friend_RequestList_All then
    return
  end
  if PaGlobal_FriendList_All._tab._pcFriendTab == PaGlobal_FriendList_All._currentTab then
    PaGlobal_FriendRequest_All:prepareOpen()
  end
end
function PaGlobal_FriendRequestList_Update_All()
  if nil == Panel_Friend_RequestList_All then
    return
  end
  PaGlobal_FriendRequest_All:updateList()
end
function PaGlobal_FriendGroupRename_Close_All()
  if nil == Panel_Friend_GroupRename_All then
    return
  end
  PaGlobal_Friend_GroupRename_All:prepareClose()
end
function PaGlobal_FriendGroupRename_Open_All(isAdd)
  if nil == Panel_Friend_GroupRename_All then
    return
  end
  PaGlobal_Friend_GroupRename_All:prepareOpen(isAdd)
end
function PaGlobal_FriendList_showAni()
  audioPostEvent_SystemUi(1, 0)
  UIAni.AlphaAnimation(1, Panel_FriendList_All, 0, 0.15)
  local aniInfo1 = Panel_FriendList_All:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_FriendList_All:GetSizeX() / 2
  aniInfo1.AxisY = Panel_FriendList_All:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_FriendList_All:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_FriendList_All:GetSizeX() / 2
  aniInfo2.AxisY = Panel_FriendList_All:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function PaGlobal_FriendList_hideAni()
  audioPostEvent_SystemUi(1, 1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_FriendList_All, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
Panel_FriendList_All:RegisterShowEventFunc(true, "PaGlobal_FriendList_showAni()")
Panel_FriendList_All:RegisterShowEventFunc(false, "PaGlobal_FriendList_hideAni()")

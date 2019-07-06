function PaGlobal_FriendList_All._groupListData:clear()
  _defaultGroupIndex = -1
  _partyplayGroupIndex = -1
  PaGlobal_FriendList_All._groupListData._selectedGroupIndex = -1
  PaGlobal_FriendList_All._groupListData._uiGroups = {}
  PaGlobal_FriendList_All._groupListData._groupInfo = {}
  PaGlobal_FriendList_All._groupListData._groupCount = 0
end
function PaGlobal_FriendList_All._friendListData:clear()
  PaGlobal_FriendList_All._friendListData._selectedFriendIndex = -1
  PaGlobal_FriendList_All._friendListData._uiFriends = {}
  PaGlobal_FriendList_All._friendListData._friendInfo = {}
end
function PaGlobal_FriendList_All:initialize()
  if true == PaGlobal_FriendList_All._initialize then
    return
  end
  PaGlobal_FriendList_All._ui.stc_TitleBG = UI.getChildControl(Panel_FriendList_All, "Static_PartLine")
  PaGlobal_FriendList_All._ui.btn_Close = UI.getChildControl(PaGlobal_FriendList_All._ui.stc_TitleBG, "Button_Close_PCUI")
  PaGlobal_FriendList_All._ui.btn_Question = UI.getChildControl(PaGlobal_FriendList_All._ui.stc_TitleBG, "Button_Question_PCUI")
  PaGlobal_FriendList_All._ui.chk_Sound = UI.getChildControl(Panel_FriendList_All, "CheckButton_Sound_PCUI")
  PaGlobal_FriendList_All._ui.chk_Effect = UI.getChildControl(Panel_FriendList_All, "CheckButton_Effect_PCUI")
  PaGlobal_FriendList_All._ui.stc_TabBG = UI.getChildControl(Panel_FriendList_All, "Static_TabTypeBg_ConsoleUI")
  PaGlobal_FriendList_All._ui.rdo_PCFriend = UI.getChildControl(PaGlobal_FriendList_All._ui.stc_TabBG, "RadioButton_PCFrined")
  PaGlobal_FriendList_All._ui.rdo_ConsoleFriend = UI.getChildControl(PaGlobal_FriendList_All._ui.stc_TabBG, "RadioButton_XBoxFrined")
  PaGlobal_FriendList_All._ui.stc_KeyGuide_LB = UI.getChildControl(PaGlobal_FriendList_All._ui.stc_TabBG, "Static_LB")
  PaGlobal_FriendList_All._ui.stc_KeyGuide_RB = UI.getChildControl(PaGlobal_FriendList_All._ui.stc_TabBG, "Static_RB")
  PaGlobal_FriendList_All._ui.list2_Friend = UI.getChildControl(Panel_FriendList_All, "List2_Friend")
  PaGlobal_FriendList_All._ui.btn_Request = UI.getChildControl(Panel_FriendList_All, "Button_Offer_PCUI")
  PaGlobal_FriendList_All._ui.btn_AddFriend = UI.getChildControl(Panel_FriendList_All, "Button_AddFriend_PCUI")
  PaGlobal_FriendList_All._ui.stc_XBFunctionBG = UI.getChildControl(Panel_FriendList_All, "Static_Function_BG_1")
  PaGlobal_FriendList_All._ui.stc_PopupFunctionBG = UI.getChildControl(Panel_FriendList_All, "Static_Function_BG_2")
  PaGlobal_FriendList_All._ui.stc_SubFunctionBG = UI.getChildControl(Panel_FriendList_All, "Static_Function_BG_3")
  PaGlobal_FriendList_All._ui.stc_function = UI.getChildControl(Panel_FriendList_All, "Style_Function")
  PaGlobal_FriendList_All._ui.stc_BottomBG = UI.getChildControl(Panel_FriendList_All, "Static_BottomBg")
  PaGlobal_FriendList_All._ui.txt_KeyGuide_X = UI.getChildControl(PaGlobal_FriendList_All._ui.stc_BottomBG, "StaticText_GroupRename")
  PaGlobal_FriendList_All._ui.txt_KeyGuide_Y = UI.getChildControl(PaGlobal_FriendList_All._ui.stc_BottomBG, "StaticText_RequestList")
  PaGlobal_FriendList_All._ui.txt_KeyGuide_A = UI.getChildControl(PaGlobal_FriendList_All._ui.stc_BottomBG, "StaticText_Select")
  PaGlobal_FriendList_All._ui.txt_KeyGuide_B = UI.getChildControl(PaGlobal_FriendList_All._ui.stc_BottomBG, "StaticText_Close")
  PaGlobal_FriendList_All._ui.txt_KeyGuide_LT = UI.getChildControl(PaGlobal_FriendList_All._ui.stc_BottomBG, "StaticText_AddFriend")
  PaGlobal_FriendList_All._keyGuides = {
    PaGlobal_FriendList_All._ui.txt_KeyGuide_LT,
    PaGlobal_FriendList_All._ui.txt_KeyGuide_X,
    PaGlobal_FriendList_All._ui.txt_KeyGuide_Y,
    PaGlobal_FriendList_All._ui.txt_KeyGuide_A,
    PaGlobal_FriendList_All._ui.txt_KeyGuide_B
  }
  PaGlobal_FriendList_All:initPopup()
  PaGlobal_FriendList_All:preparePlatform()
  PaGlobal_FriendList_All._ui.stc_function:SetShow(false)
  PaGlobal_FriendList_All._ui.list2_Friend:createChildContent(CppEnums.PAUIList2ElementManagerType.tree)
  PaGlobal_FriendList_All:registEventHandler()
  PaGlobal_FriendList_All._initialize = true
end
function PaGlobal_FriendList_All:preparePlatform()
  if true == _ContentsGroup_RenewUI then
    PaGlobal_FriendList_All._ui.btn_Close:SetShow(false)
    PaGlobal_FriendList_All._ui.btn_Question:SetShow(false)
    PaGlobal_FriendList_All._ui.chk_Sound:SetShow(false)
    PaGlobal_FriendList_All._ui.chk_Effect:SetShow(false)
    PaGlobal_FriendList_All._ui.btn_Request:SetShow(false)
    PaGlobal_FriendList_All._ui.btn_AddFriend:SetShow(false)
    PaGlobal_FriendList_All._ui.list2_Friend:SetSize(PaGlobal_FriendList_All._ui.list2_Friend:GetSizeX(), PaGlobal_FriendList_All._ui.list2_Friend:GetSizeY() + 55)
    PaGlobal_FriendList_All:updateKeyGuides()
  else
    PaGlobal_FriendList_All._ui.stc_BottomBG:SetShow(false)
    PaGlobal_FriendList_All._ui.stc_TabBG:SetShow(false)
  end
end
function PaGlobal_FriendList_All:registEventHandler()
  if nil == Panel_FriendList_All then
    return
  end
  registerEvent("ResponseFriendList_updateFriends", "ResponseFriendList_updateFriends_All")
  PaGlobal_FriendList_All._ui.list2_Friend:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_FriendList_List2EventControlCreate")
  if true == _ContentsGroup_RenewUI then
    Panel_FriendList_All:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobal_FriendRequestList_Open_All()")
    Panel_FriendList_All:registerPadEvent(__eConsoleUIPadEvent_LT, "PaGlobal_FriendList_ClickAddFriendButton()")
    Panel_FriendList_All:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobal_FriendList_ChangeTab_All()")
    Panel_FriendList_All:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobal_FriendList_ChangeTab_All()")
  else
    PaGlobal_FriendList_All._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_FriendList_Hide_All()")
    PaGlobal_FriendList_All._ui.btn_Question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelFriends\" )")
    PaGlobal_FriendList_All._ui.btn_Question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelFriends\", \"true\")")
    PaGlobal_FriendList_All._ui.btn_Question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelFriends\", \"false\")")
    PaGlobal_FriendList_All._ui.btn_Request:addInputEvent("Mouse_LUp", "PaGlobal_FriendRequestList_Open_All()")
    PaGlobal_FriendList_All._ui.btn_AddFriend:addInputEvent("Mouse_LUp", "PaGlobal_FriendList_ClickAddFriendButton()")
    PaGlobal_FriendList_All._ui.chk_Sound:addInputEvent("Mouse_LUp", "ToClient_RequestToggleSoundNotice()")
    PaGlobal_FriendList_All._ui.chk_Effect:addInputEvent("Mouse_LUp", "ToClient_RequestToggleEffectNotice()")
    registerEvent("FromClient_NoticeNewMessage", "FromClient_NoticeNewMessage_All")
  end
end
function PaGlobal_FriendList_All:prepareOpen()
  if nil == Panel_FriendList_All and true == _ContentsGroup_NewUI_Friend_All then
    return
  end
  ToClient_updateAddFriendAllowed()
  RequestFriendList_getFriendList()
  RequestFriendList_getAddFriendList()
  if false == _ContentsGroup_RenewUI then
    PaGlobal_FriendList_All:loadOption()
  end
  PaGlobal_FriendList_All:updateTab()
  PaGlobal_FriendList_All:open()
end
function PaGlobal_FriendList_All:open()
  if nil == Panel_FriendList_All then
    return
  end
  Panel_FriendList_All:SetShow(true)
end
function PaGlobal_FriendList_All:prepareClose()
  if nil == Panel_FriendList_All then
    return
  end
  if true == Panel_Friend_GroupRename_All:GetShow() then
    PaGlobal_FriendGroupRename_Close()
    return
  end
  if true == Panel_FriendList_Add_All:GetShow() then
    PaGlobal_FriendListAdd_Close_All()
    return
  end
  if true == PaGlobal_FriendList_All._ui.stc_SubFunctionBG:GetShow() then
    PaGlobal_FriendList_All._ui.stc_SubFunctionBG:SetShow(false)
    ToClient_padSnapSetTargetGroup(PaGlobal_FriendList_All._ui.stc_PopupFunctionBG)
    return
  elseif true == PaGlobal_FriendList_All._ui.stc_PopupFunctionBG:GetShow() then
    PaGlobal_FriendList_All:showPopupMenu(false)
    return
  elseif true == PaGlobal_FriendList_All._ui.stc_XBFunctionBG:GetShow() then
    PaGlobal_FriendList_All._ui.stc_XBFunctionBG:SetShow(false)
    return
  end
  PaGlobal_FriendList_All._groupListData:clear()
  PaGlobal_FriendList_All._friendListData:clear()
  PaGlobal_FriendList_All:close()
end
function PaGlobal_FriendList_All:close()
  if nil == Panel_FriendList_All then
    return
  end
  Panel_FriendList_All:SetShow(false)
end
function PaGlobal_FriendList_All:updateTab()
  if true == _ContentsGroup_RenewUI then
    PaGlobal_FriendList_All._currentKeyGuideType = PaGlobal_FriendList_All._keyGuideType._None
    PaGlobal_FriendList_All:updateKeyGuides()
  end
  if PaGlobal_FriendList_All._tab._consoleFriendTab == PaGlobal_FriendList_All._currentTab then
    PaGlobal_FriendList_All:updateFriendListForConsole()
    if true == _ContentsGroup_RenewUI then
      PaGlobal_FriendList_All._ui.rdo_PCFriend:SetFontColor(Defines.Color.C_FF585453)
      PaGlobal_FriendList_All._ui.rdo_ConsoleFriend:SetFontColor(Defines.Color.C_FFFFEDD4)
    end
  else
    PaGlobal_FriendList_All:updateFriendList()
    if true == _ContentsGroup_RenewUI then
      PaGlobal_FriendList_All._ui.rdo_PCFriend:SetFontColor(Defines.Color.C_FFFFEDD4)
      PaGlobal_FriendList_All._ui.rdo_ConsoleFriend:SetFontColor(Defines.Color.C_FF585453)
    end
  end
end
function PaGlobal_FriendList_All:loadOption()
  local noticeSound = ToClient_RoadToggleSoundNotice() or false
  local noticeEffect = ToClient_RoadToggleEffectNotice() or false
  PaGlobal_FriendList_All._ui.chk_Sound:SetCheck(noticeSound)
  PaGlobal_FriendList_All._ui.chk_Effect:SetCheck(noticeEffect)
end
function PaGlobal_FriendList_All:updateKeyGuides()
  local Type = PaGlobal_FriendList_All._keyGuideType
  if Type._DefaultGroup == PaGlobal_FriendList_All._currentKeyGuideType then
    PaGlobal_FriendList_All._ui.txt_KeyGuide_X:SetShow(false)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_Y:SetShow(true)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_A:SetShow(true)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_B:SetShow(true)
  elseif Type._Group == PaGlobal_FriendList_All._currentKeyGuideType then
    PaGlobal_FriendList_All._ui.txt_KeyGuide_X:SetShow(true)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_Y:SetShow(true)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_A:SetShow(true)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_B:SetShow(true)
  elseif Type._Friend == PaGlobal_FriendList_All._currentKeyGuideType then
    PaGlobal_FriendList_All._ui.txt_KeyGuide_X:SetShow(false)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_Y:SetShow(true)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_A:SetShow(true)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_B:SetShow(true)
  elseif Type._XBFriend == PaGlobal_FriendList_All._currentKeyGuideType then
    PaGlobal_FriendList_All._ui.txt_KeyGuide_X:SetShow(false)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_Y:SetShow(false)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_A:SetShow(true)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_B:SetShow(true)
  elseif Type._Popup == PaGlobal_FriendList_All._currentKeyGuideType then
    PaGlobal_FriendList_All._ui.txt_KeyGuide_X:SetShow(false)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_Y:SetShow(false)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_A:SetShow(true)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_B:SetShow(true)
  elseif Type._AddGroup == PaGlobal_FriendList_All._currentKeyGuideType then
    PaGlobal_FriendList_All._ui.txt_KeyGuide_X:SetShow(false)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_Y:SetShow(true)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_A:SetShow(true)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_B:SetShow(true)
  elseif Type._None == PaGlobal_FriendList_All._currentKeyGuideType then
    PaGlobal_FriendList_All._ui.txt_KeyGuide_X:SetShow(false)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_Y:SetShow(false)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_A:SetShow(false)
    PaGlobal_FriendList_All._ui.txt_KeyGuide_B:SetShow(true)
  end
  local isLTShow = Type._Popup ~= PaGlobal_FriendList_All._currentKeyGuideType and PaGlobal_FriendList_All._tab._pcFriendTab == PaGlobal_FriendList_All._currentTab
  PaGlobal_FriendList_All._ui.txt_KeyGuide_LT:SetShow(isLTShow)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_FriendList_All._keyGuides, PaGlobal_FriendList_All._ui.stc_BottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_AUTO_WRAP_LEFT)
end
function PaGlobal_FriendList_All:updateFriendList()
  if nil == Panel_FriendList_All then
    return
  end
  local friendList = PaGlobal_FriendList_All._ui.list2_Friend
  local _groupListData = PaGlobal_FriendList_All._groupListData
  local _friendListData = PaGlobal_FriendList_All._friendListData
  _groupListData:clear()
  _friendListData:clear()
  friendList:getElementManager():clearKey()
  local mainElement = friendList:getElementManager():getMainElement()
  local friendGroupCount = RequestFriends_getFriendGroupCount()
  local indexCnt = 0
  local groupIndexCnt = 0
  for groupIndex = 0, friendGroupCount - 1 do
    local friendGroup = RequestFriends_getFriendGroupAt(groupIndex)
    local treeElement = mainElement:createChild(toInt64(0, indexCnt))
    _groupListData._groupInfo[indexCnt] = friendGroup
    _groupListData._groupInfoByGroupIndex[groupIndex] = friendGroup
    _groupListData._groupCount = friendGroupCount
    indexCnt = indexCnt + 1
    groupIndexCnt = indexCnt
    if false == friendGroup:isHide() then
      local friendCount = friendGroup:getFriendCount()
      for friendIndex = 0, friendCount - 1 do
        local friendInfo = friendGroup:getFriendAt(friendIndex)
        local subTreeElement = treeElement:createChild(toInt64(0, indexCnt))
        _friendListData._friendInfo[indexCnt] = friendInfo
        indexCnt = indexCnt + 1
      end
    end
  end
  if PaGlobal_FriendList_All._MAX_GROUP_COUNT ~= friendGroupCount then
    mainElement:createChild(toInt64(0, indexCnt))
  end
  friendList:getElementManager():refillKeyList()
end
function PaGlobal_FriendList_All:updateFriendListForConsole()
  if nil == Panel_FriendList_All then
    return
  end
  local friendList = PaGlobal_FriendList_All._ui.list2_Friend
  local _groupListData = PaGlobal_FriendList_All._groupListData
  local _friendListData = PaGlobal_FriendList_All._friendListData
  _groupListData:clear()
  _friendListData:clear()
  friendList:getElementManager():clearKey()
  local mainElement = friendList:getElementManager():getMainElement()
  local friendCount = ToClient_InitializeXboxFriendForLua()
  for index = 0, friendCount - 1 do
    local treeElement = mainElement:createChild(toInt64(0, index))
    local friendInfo = ToClient_getXboxFriendInfoByIndex(index)
    _friendListData._friendInfo[index] = friendInfo
  end
  friendList:getElementManager():refillKeyList()
end
function PaGlobal_FriendList_List2EventControlCreate(control, key64)
  local index = Int64toInt32(key64)
  local parentBG = UI.getChildControl(control, "Static_ParentBG")
  local childBG = UI.getChildControl(control, "Static_ChildBG")
  local name = UI.getChildControl(control, "StaticText_Name")
  local addGroup = UI.getChildControl(control, "StaticText_AddGroup")
  local upIcon = UI.getChildControl(control, "Static_UpIcon")
  local downIcon = UI.getChildControl(control, "Static_DownIcon")
  local _groupListData = PaGlobal_FriendList_All._groupListData
  local _friendListData = PaGlobal_FriendList_All._friendListData
  local friendGroupNoDefault = -1
  local friendGroupNoPartyFriend = -2
  parentBG:SetShow(false)
  childBG:SetShow(false)
  upIcon:SetShow(false)
  downIcon:SetShow(false)
  control:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  parentBG:addInputEvent("Mouse_RUp", "")
  if nil ~= _groupListData._groupInfo[index] then
    local friendGroup = _groupListData._groupInfo[index]
    local treeElement = PaGlobal_FriendList_All._ui.list2_Friend:getElementManager():getByKey(key64)
    parentBG:SetShow(true)
    addGroup:SetShow(false)
    name:SetShow(true)
    if false == treeElement:getIsOpen() then
      downIcon:SetShow(true)
    else
      upIcon:SetShow(true)
    end
    if friendGroup:getGroupNo() == friendGroupNoDefault then
      name:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_GROUP_ETC"))
    elseif friendGroup:getGroupNo() == friendGroupNoPartyFriend then
      name:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_GROUP_PARTY"))
    else
      name:SetText(friendGroup:getName())
      if true == _ContentsGroup_RenewUI then
        control:registerPadEvent(__eConsoleUIPadEvent_Up_X, "InputRUp_FriendList_GroupRenameOpen(" .. index .. ")")
      else
        parentBG:addInputEvent("Mouse_RUp", "InputRUp_FriendList_GroupRenameOpen(" .. index .. ")")
      end
    end
    if true == _ContentsGroup_RenewUI then
      control:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_FriendList_ToggleGroup(" .. index .. ")")
      control:addInputEvent("Mouse_On", "PaGlobal_FriendList_SetSelectedGroupIndex(" .. index .. ")")
    else
      parentBG:addInputEvent("Mouse_LUp", "PaGlobal_FriendList_ToggleGroup(" .. index .. ")")
    end
  elseif nil ~= _friendListData._friendInfo[index] then
    local friendInfo = _friendListData._friendInfo[index]
    local friendName = friendInfo:getName()
    childBG:SetShow(true)
    addGroup:SetShow(false)
    name:SetShow(true)
    if PaGlobal_FriendList_All._tab._consoleFriendTab == PaGlobal_FriendList_All._currentTab then
      local isLogin = friendInfo:isOnline()
      local loginString = PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_ONLINE")
      if false == isLogin then
        loginString = PAGetString(Defines.StringSheet_GAME, "LUA_FRIENDINFO_LOGOUT")
      end
      if ("" == friendName or nil == friendName) and true == isLogin then
        friendName = friendInfo:getGamerTag() .. PAGetString(Defines.StringSheet_GAME, "LUA_FRIENDLIST_NOTINGAME")
      elseif true == isLogin then
        friendName = friendInfo:getGamerTag() .. " (" .. friendInfo:getName() .. ", " .. loginString .. ")"
      else
        friendName = friendInfo:getGamerTag() .. " (" .. loginString .. ")"
      end
      control:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_FriendList_All:showXBMenu()")
      control:addInputEvent("Mouse_On", "PaGlobal_FriendList_SetSelectedXBFriendIndex(" .. index .. ")")
    elseif true == _ContentsGroup_RenewUI then
      local charcterName = friendInfo:getCharacterName()
      if nil == charcterName or "" == charcterName or false == friendInfo:isOnline() or true == friendInfo:isGhostMode() then
        local s64_lastLogoutTime = friendInfo:getLastLogoutTime_s64()
        friendName = friendName .. " " .. "(" .. convertStringFromDatetimeOverHourForFriends(s64_lastLogoutTime) .. ")"
      else
        friendName = friendName .. " (" .. charcterName .. " , " .. PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_ONLINE") .. ")"
      end
      control:registerPadEvent(__eConsoleUIPadEvent_Up_A, "InputLUp_FriendList_ShowPopup(" .. index .. ")")
      control:addInputEvent("Mouse_On", "PaGlobal_FriendList_SetSelectedFriendIndex()")
    else
      if false == friendInfo:isOnline() or true == friendInfo:isGhostMode() or nil == charcterName or "" == charcterName then
        local s64_lastLogoutTime = friendInfo:getLastLogoutTime_s64()
        friendName = friendName .. " " .. "(" .. convertStringFromDatetimeOverHourForFriends(s64_lastLogoutTime) .. ")"
      else
        friendName = friendName .. " " .. "(" .. friendInfo:getCharacterName() .. ", " .. PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_ONLINE") .. ")"
      end
      childBG:addInputEvent("Mouse_LUp", "InputLUp_FriendList_ShowPopup(" .. index .. ")")
    end
    name:SetText(friendName)
  else
    parentBG:SetShow(true)
    name:SetShow(false)
    addGroup:SetShow(true)
    addGroup:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_ADD_GROUP"))
    local totalSizeX = parentBG:GetSizeX()
    local addGroupSizeX = addGroup:GetSizeX() + addGroup:GetTextSizeX()
    local posX = parentBG:GetPosX() + (totalSizeX - addGroupSizeX) / 2
    addGroup:SetPosX(posX)
    if true == _ContentsGroup_RenewUI then
      control:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_FriendGroupRename_Open_All(true)")
      control:addInputEvent("Mouse_On", "PaGlobal_FriendList_OnAddGroupBtn()")
    else
      parentBG:addInputEvent("Mouse_LUp", "PaGlobal_FriendGroupRename_Open_All(true)")
    end
  end
end
function PaGlobal_FriendList_ToggleGroup(id)
  PaGlobal_FriendList_All._groupListData._selectedGroupIndex = index
  PaGlobal_FriendList_All._ui.list2_Friend:getElementManager():toggle(toInt64(0, id))
end
function InputRUp_FriendList_GroupRenameOpen(index)
  PaGlobal_FriendList_All._groupListData._selectedGroupIndex = index
  PaGlobal_FriendGroupRename_Open_All(false)
end
function InputLUp_FriendList_ShowPopup(index)
  PaGlobal_FriendList_All._friendListData._selectedFriendIndex = index
  PaGlobal_FriendList_All:showPopupMenu(true)
end
function InputLUp_FriendList_AddGroupOpen(index)
  PaGlobal_FriendList_All._friendListData._selectedFriendIndex = index
  PaGlobal_FriendList_All:showPopupMenu(true)
end
function PaGlobal_FriendList_SetSelectedGroupIndex(index)
  if 0 ~= index then
    PaGlobal_FriendList_All._currentKeyGuideType = PaGlobal_FriendList_All._keyGuideType._Group
  else
    PaGlobal_FriendList_All._currentKeyGuideType = PaGlobal_FriendList_All._keyGuideType._DefaultGroup
  end
  PaGlobal_FriendList_All:updateKeyGuides()
end
function PaGlobal_FriendList_SetSelectedFriendIndex()
  PaGlobal_FriendList_All._currentKeyGuideType = PaGlobal_FriendList_All._keyGuideType._Friend
  PaGlobal_FriendList_All:updateKeyGuides()
end
function PaGlobal_FriendList_SetSelectedXBFriendIndex(index)
  PaGlobal_FriendList_All._selectedXBFriendIndex = index
  PaGlobal_FriendList_All._currentKeyGuideType = PaGlobal_FriendList_All._keyGuideType._XBFriend
  PaGlobal_FriendList_All:updateKeyGuides()
end
function PaGlobal_FriendList_OnAddGroupBtn()
  PaGlobal_FriendList_All._currentKeyGuideType = PaGlobal_FriendList_All._keyGuideType._AddGroup
  PaGlobal_FriendList_All:updateKeyGuides()
end
function PaGlobal_FriendList_All:initPopup()
  if nil == Panel_FriendList_All then
    return
  end
  local bgSizeX = PaGlobal_FriendList_All._ui.stc_XBFunctionBG:GetSizeX()
  local buttonSizeY = PaGlobal_FriendList_All._ui.stc_function:GetSizeY()
  for i = 0, 1 do
    local control = UI.cloneControl(PaGlobal_FriendList_All._ui.stc_function, PaGlobal_FriendList_All._ui.stc_XBFunctionBG, "Static_Funtion_" .. i)
    control:SetPosX(0)
    control:SetPosY(buttonSizeY * i)
    PaGlobal_FriendList_All._ui.stc_XBFunctionList[i] = control
  end
  PaGlobal_FriendList_All._ui.stc_XBFunctionBG:SetSize(bgSizeX, buttonSizeY * 2)
  PaGlobal_FriendList_All._ui.stc_XBFunctionList[0]:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_XBOX_PROFILE"))
  PaGlobal_FriendList_All._ui.stc_XBFunctionList[1]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX_FRIEND_GAMEINVITE"))
  PaGlobal_FriendList_All._ui.stc_XBFunctionList[0]:addInputEvent("Mouse_LUp", "PaGlobal_FriendList_All:ShowXBoxProfile()")
  PaGlobal_FriendList_All._ui.stc_XBFunctionList[1]:addInputEvent("Mouse_LUp", "PaGlobal_FriendList_All:SendXboxInvite()")
  PaGlobal_FriendList_All._ui.stc_XBFunctionBG:SetShow(false)
  for i = 0, 3 do
    local control = UI.cloneControl(PaGlobal_FriendList_All._ui.stc_function, PaGlobal_FriendList_All._ui.stc_PopupFunctionBG, "Static_Funtion_" .. i)
    control:SetPosX(0)
    control:SetPosY(buttonSizeY * i)
    PaGlobal_FriendList_All._ui.stc_PopupFunctionList[i] = control
  end
  PaGlobal_FriendList_All._ui.stc_PopupFunctionList[0]:SetText(PAGetString(Defines.StringSheet_GAME, "INTERACTION_MENU3"))
  PaGlobal_FriendList_All._ui.stc_PopupFunctionList[1]:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_REMOVE_FRIEND"))
  PaGlobal_FriendList_All._ui.stc_PopupFunctionList[2]:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_CHANGE_GROUP"))
  PaGlobal_FriendList_All._ui.stc_PopupFunctionList[3]:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_WHISPER"))
  PaGlobal_FriendList_All._ui.stc_PopupFunctionList[0]:addInputEvent("Mouse_LUp", "PaGlobal_FriendList_All:partyInvite()")
  PaGlobal_FriendList_All._ui.stc_PopupFunctionList[1]:addInputEvent("Mouse_LUp", "PaGlobal_FriendList_All:deleteFriend()")
  PaGlobal_FriendList_All._ui.stc_PopupFunctionList[2]:addInputEvent("Mouse_LUp", "PaGlobal_FriendList_All:groupMoveList()")
  PaGlobal_FriendList_All._ui.stc_PopupFunctionList[3]:addInputEvent("Mouse_LUp", "PaGlobal_FriendList_All:messangerOpen()")
  if true == _ContentsGroup_RenewUI then
    PaGlobal_FriendList_All._ui.stc_PopupFunctionList[3]:SetShow(false)
    PaGlobal_FriendList_All._ui.stc_PopupFunctionBG:SetSize(bgSizeX, buttonSizeY * 3)
  else
    PaGlobal_FriendList_All._ui.stc_PopupFunctionBG:SetSize(bgSizeX, buttonSizeY * 4)
  end
  PaGlobal_FriendList_All._ui.stc_PopupFunctionBG:SetShow(false)
  for i = 0, 3 do
    local control = UI.cloneControl(PaGlobal_FriendList_All._ui.stc_function, PaGlobal_FriendList_All._ui.stc_SubFunctionBG, "Static_Funtion_" .. i)
    control:SetPosX(0)
    control:SetPosY(buttonSizeY * i)
    PaGlobal_FriendList_All._ui.stc_SubFunctionList[i] = control
  end
  PaGlobal_FriendList_All._ui.stc_SubFunctionBG:SetShow(false)
end
function PaGlobal_FriendList_All:showXBMenu()
  if nil == Panel_FriendList_All then
    return
  end
  local XB_BG = PaGlobal_FriendList_All._ui.stc_XBFunctionBG
  XB_BG:SetShow(true)
  ToClient_padSnapSetTargetGroup(XB_BG)
  local control
  local index = PaGlobal_FriendList_All._selectedXBFriendIndex
  if -1 ~= index then
    control = PaGlobal_FriendList_All._ui.list2_Friend:GetContentByKey(toInt64(0, index))
  end
  if nil ~= control then
    local posY = PaGlobal_FriendList_All._ui.list2_Friend:GetPosY() + control:GetPosY()
    XB_BG:SetPosY(posY)
  end
  PaGlobal_FriendList_All._currentKeyGuideType = PaGlobal_FriendList_All._keyGuideType._Popup
  PaGlobal_FriendList_All:updateKeyGuides()
end
function PaGlobal_FriendList_All:ShowXBoxProfile()
  local index = PaGlobal_FriendList_All._selectedXBFriendIndex
  local xboxFriendInfo = ToClient_getXboxFriendInfoByIndex(index)
  ToClient_showXboxFriendProfile(xboxFriendInfo:getXuid())
end
function PaGlobal_FriendList_All:SendXboxInvite()
  if nil == Panel_FriendList_All then
    return
  end
  local index = PaGlobal_FriendList_All._selectedXBFriendIndex
  local xboxFriendInfo = ToClient_getXboxFriendInfoByIndex(index)
  ToClient_sendXboxInvite(xboxFriendInfo:getXuid(), "Hello!")
end
function PaGlobal_FriendList_All:isSelectFriendBlocked()
  if nil == Panel_FriendList_All then
    return
  end
  local userNo = PaGlobal_FriendList_All._friendListData._friendInfo[PaGlobal_FriendList_All._friendListData._selectedFriendIndex]:getUserNo()
  local groupNo = PaGlobal_FriendList_All._friendListData._friendInfo[PaGlobal_FriendList_All._friendListData._selectedFriendIndex]:getGroupNo()
  return RequestFriends_isBlockedFriend(userNo, groupNo)
end
function PaGlobal_FriendList_All:renameFriendGroup()
  if nil == Panel_FriendList_All then
    return
  end
  PaGlobal_FriendGroupRename_Open_All(false)
  PaGlobal_FriendList_All._ui.stc_XBFunctionBG:SetShow(false)
end
function PaGlobal_FriendList_All:partyInvite()
  if nil == Panel_FriendList_All then
    return
  end
  local _friendListData = PaGlobal_FriendList_All._friendListData
  local userCharacterName = _friendListData._friendInfo[_friendListData._selectedFriendIndex]:getCharacterName()
  local isOnline = _friendListData._friendInfo[_friendListData._selectedFriendIndex]:isOnline()
  local isSelfPlayerPlayingPvPMatch = getSelfPlayer():isDefinedPvPMatch()
  if PaGlobal_FriendList_All:isSelectFriendBlocked() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if false == isSelfPlayerPlayingPvPMatch then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERACTION_ACK_INVITE", "targetName", userCharacterName))
  end
  RequestParty_inviteCharacter(userCharacterName)
end
function PaGlobal_FriendList_All:deleteFriend()
  if nil == Panel_FriendList_All then
    return
  end
  local _friendListData = PaGlobal_FriendList_All._friendListData
  requestFriendList_deleteFriend(_friendListData._friendInfo[_friendListData._selectedFriendIndex]:getUserNo())
  PaGlobal_FriendList_All._ui.stc_PopupFunctionBG:SetShow(false)
end
function PaGlobal_FriendList_All:groupMoveList()
  if nil == Panel_FriendList_All then
    return
  end
  local moveGroupBG = PaGlobal_FriendList_All._ui.stc_SubFunctionBG
  local moveGroup = PaGlobal_FriendList_All._ui.stc_PopupFunctionList[2]
  PaGlobal_FriendList_All:groupMoveSetShow(true)
  moveGroupBG:SetPosX(PaGlobal_FriendList_All._ui.stc_PopupFunctionBG:GetPosX() + moveGroup:GetSizeX() + 10)
  moveGroupBG:SetPosY(PaGlobal_FriendList_All._ui.stc_PopupFunctionBG:GetPosY() + moveGroup:GetPosY())
end
function PaGlobal_FriendList_All:messangerOpen()
  if nil == Panel_FriendList_All then
    return
  end
  local _friendListData = PaGlobal_FriendList_All._friendListData
  local userNo = _friendListData._friendInfo[_friendListData._selectedFriendIndex]:getUserNo()
  local userName = _friendListData._friendInfo[_friendListData._selectedFriendIndex]:getName()
  local isOnline = _friendListData._friendInfo[_friendListData._selectedFriendIndex]:isOnline()
  if PaGlobal_FriendList_All:isSelectFriendBlocked() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  RequestFriendList_OpenMessanger(userNo, userName, isOnline)
  PaGlobal_FriendList_All._ui.stc_PopupFunctionBG:SetShow(false)
end
function PaGlobal_FriendList_All:showPopupMenu(isShow)
  if nil == Panel_FriendList_All then
    return
  end
  local friendListData = PaGlobal_FriendList_All._friendListData
  local groupListData = PaGlobal_FriendList_All._groupListData
  local popupBG = PaGlobal_FriendList_All._ui.stc_PopupFunctionBG
  popupBG:SetShow(isShow)
  if isShow then
    local isOnline = friendListData._friendInfo[friendListData._selectedFriendIndex]:isOnline()
    local isMessage = RequestFriendList_isMessageList(friendListData._friendInfo[friendListData._selectedFriendIndex]:getUserNo()) and false == _ContentsGroup_RenewUI and true == isOnline
    local isGroupMove = 2 <= groupListData._groupCount
    local control
    local index = friendListData._selectedFriendIndex
    if -1 ~= index then
      control = PaGlobal_FriendList_All._ui.list2_Friend:GetContentByKey(toInt64(0, index))
    end
    if nil ~= control then
      local posY = PaGlobal_FriendList_All._ui.list2_Friend:GetPosY() + control:GetPosY()
      popupBG:SetPosY(posY)
    end
    ToClient_padSnapSetTargetGroup(popupBG)
    PaGlobal_FriendList_All._ui.stc_PopupFunctionList[2]:SetShow(isGroupMove)
    PaGlobal_FriendList_All._ui.stc_PopupFunctionList[3]:SetShow(isMessage)
    local gapY = PaGlobal_FriendList_All._ui.stc_PopupFunctionList[1]:GetSizeY()
    local activeCount = 0
    for i = 0, 3 do
      stc_function = PaGlobal_FriendList_All._ui.stc_PopupFunctionList[i]
      if true == stc_function:GetShow() then
        stc_function:SetPosY(gapY * activeCount)
        activeCount = activeCount + 1
      end
    end
    popupBG:SetSize(popupBG:GetSizeX(), gapY * activeCount)
    PaGlobal_FriendList_All._currentKeyGuideType = PaGlobal_FriendList_All._keyGuideType._Popup
    PaGlobal_FriendList_All:updateKeyGuides()
  end
end
function PaGlobal_FriendList_All:updateGroups()
  if nil == Panel_FriendList_All then
    return
  end
  local popupBG = PaGlobal_FriendList_All._ui.stc_SubFunctionBG
  local menuList = PaGlobal_FriendList_All._ui.stc_SubFunctionList
  for index = 0, 3 do
    menuList[index]:SetShow(false)
  end
  local groupCount = PaGlobal_FriendList_All._groupListData._groupCount
  local buttonSizeX = PaGlobal_FriendList_All._ui.stc_function:GetSizeX()
  local buttonSizeY = PaGlobal_FriendList_All._ui.stc_function:GetSizeY()
  local friendGroupNoPartyFriend = -2
  popupBG:SetSize(buttonSizeX, buttonSizeY * groupCount)
  local count = 0
  for groupIndex = 0, groupCount - 1 do
    local groupName = PaGlobal_FriendList_All._groupListData._groupInfoByGroupIndex[groupIndex]:getName()
    local groupNo = PaGlobal_FriendList_All._groupListData._groupInfoByGroupIndex[groupIndex]:getGroupNo()
    if groupNo ~= friendGroupNoPartyFriend then
      if groupName == "" then
        menuList[groupIndex]:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_GROUP_ETC"))
      else
        menuList[groupIndex]:SetText(groupName)
      end
      menuList[groupIndex]:SetShow(true)
      menuList[groupIndex]:SetPosY(buttonSizeY * count)
      menuList[groupIndex]:addInputEvent("Mouse_LUp", "PaGlobal_FriendList_All:moveGroupTo(" .. groupIndex .. ")")
      count = count + 1
    end
  end
end
function PaGlobal_FriendList_All:moveGroupTo(groupIndex)
  if nil == Panel_FriendList_All then
    return
  end
  requestFriendList_moveGroup(PaGlobal_FriendList_All._friendListData._friendInfo[PaGlobal_FriendList_All._friendListData._selectedFriendIndex]:getUserNo(), PaGlobal_FriendList_All._groupListData._groupInfoByGroupIndex[groupIndex]:getGroupNo())
  PaGlobal_FriendList_All._ui.stc_PopupFunctionBG:SetShow(false)
  PaGlobal_FriendList_All._ui.stc_SubFunctionBG:SetShow(false)
end
function PaGlobal_FriendList_All:groupMoveSetShow(isShow)
  if nil == Panel_FriendList_All then
    return
  end
  PaGlobal_FriendList_All._ui.stc_SubFunctionBG:SetShow(isShow)
  if isShow then
    PaGlobal_FriendList_All:updateGroups()
    ToClient_padSnapSetTargetGroup(PaGlobal_FriendList_All._ui.stc_SubFunctionBG)
    PaGlobal_FriendList_All._currentKeyGuideType = PaGlobal_FriendList_All._keyGuideType._Popup
    PaGlobal_FriendList_All:updateKeyGuides()
  end
end
function PaGlobal_FriendList_ClickAddFriendButton()
  if nil == Panel_FriendList_All then
    return
  end
  if false == ToClient_isAddFriendAllowed() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    ToClient_showPrivilegeError()
  elseif PaGlobal_FriendList_All._tab._pcFriendTab == PaGlobal_FriendList_All._currentTab then
    PaGlobal_FriendListAdd_Open_All()
  end
end
function PaGlobal_AddFriend_All:initialize()
  if true == PaGlobal_AddFriend_All._initialize then
    return
  end
  PaGlobal_AddFriend_All._ui.btn_Close = UI.getChildControl(Panel_FriendList_Add_All, "Button_AddFriend_Close_PCUI")
  PaGlobal_AddFriend_All._ui.txt_Desc = UI.getChildControl(Panel_FriendList_Add_All, "StaticText_NameDesc")
  PaGlobal_AddFriend_All._ui.sub_BG = UI.getChildControl(Panel_FriendList_Add_All, "Static_FriendName_SubBg")
  PaGlobal_AddFriend_All._ui.chk_isFamilyName = UI.getChildControl(Panel_FriendList_Add_All, "CheckButton_IsUserNickName_PCUI")
  PaGlobal_AddFriend_All._ui.rdo_Family = UI.getChildControl(Panel_FriendList_Add_All, "RadioButton_PCFrined_ConsoleUI")
  PaGlobal_AddFriend_All._ui.rdo_Character = UI.getChildControl(Panel_FriendList_Add_All, "RadioButton_XBoxFrined_ConsoleUI")
  PaGlobal_AddFriend_All._ui.stc_KeyGuide_RB = UI.getChildControl(Panel_FriendList_Add_All, "Static_RB_ConsoleUI")
  PaGlobal_AddFriend_All._ui.stc_KeyGuide_LB = UI.getChildControl(Panel_FriendList_Add_All, "Static_LB_ConsoleUI")
  PaGlobal_AddFriend_All._ui.stc_keyGuide_X = UI.getChildControl(Panel_FriendList_Add_All, "StaticText_EditNameKeyGuide_ConsoleUI")
  PaGlobal_AddFriend_All._ui.edit_Name = UI.getChildControl(Panel_FriendList_Add_All, "Edit_FriendName")
  PaGlobal_AddFriend_All._ui.btn_Confirm = UI.getChildControl(Panel_FriendList_Add_All, "Button_AddFriend_Yes_PCUI")
  PaGlobal_AddFriend_All._ui.btn_Cancel = UI.getChildControl(Panel_FriendList_Add_All, "Button_AddFriend_No_PCUI")
  PaGlobal_AddFriend_All._ui.stc_keyGuideBG = UI.getChildControl(Panel_FriendList_Add_All, "Static_FriendBotton_ConsoleUI")
  PaGlobal_AddFriend_All._ui.stc_KeyGuide_A = UI.getChildControl(PaGlobal_AddFriend_All._ui.stc_keyGuideBG, "StaticText_Apply")
  PaGlobal_AddFriend_All._ui.stc_KeyGuide_B = UI.getChildControl(PaGlobal_AddFriend_All._ui.stc_keyGuideBG, "StaticText_Cancel")
  PaGlobal_AddFriend_All._keyGuides = {
    PaGlobal_AddFriend_All._ui.stc_KeyGuide_A,
    PaGlobal_AddFriend_All._ui.stc_KeyGuide_B
  }
  PaGlobal_AddFriend_All._ui.edit_Name:SetMaxInput(getGameServiceTypeUserNickNameLength())
  PaGlobal_AddFriend_All:preparePlatform()
  PaGlobal_AddFriend_All:registEventHandler()
  PaGlobal_AddFriend_All._initialize = true
end
function PaGlobal_AddFriend_All:preparePlatform()
  if nil == Panel_FriendList_Add_All then
    return
  end
  if true == _ContentsGroup_RenewUI then
    PaGlobal_AddFriend_All._ui.btn_Close:SetShow(false)
    PaGlobal_AddFriend_All._ui.chk_isFamilyName:SetShow(false)
    PaGlobal_AddFriend_All._ui.btn_Confirm:SetShow(false)
    PaGlobal_AddFriend_All._ui.btn_Cancel:SetShow(false)
    local subBG = PaGlobal_AddFriend_All._ui.sub_BG
    Panel_FriendList_Add_All:SetSize(Panel_FriendList_Add_All:GetSizeX(), Panel_FriendList_Add_All:GetSizeY() - 40)
    subBG:SetSize(subBG:GetSizeX(), subBG:GetSizeY() - 40)
    Panel_FriendList_Add_All:ComputePos()
    PaGlobal_AddFriend_All._ui.stc_keyGuideBG:ComputePos()
    PaGlobal_AddFriend_All:updateTab()
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_AddFriend_All._keyGuides, PaGlobal_AddFriend_All._ui.stc_keyGuideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  else
    PaGlobal_AddFriend_All._ui.rdo_Family:SetShow(false)
    PaGlobal_AddFriend_All._ui.rdo_Character:SetShow(false)
    PaGlobal_AddFriend_All._ui.stc_KeyGuide_RB:SetShow(false)
    PaGlobal_AddFriend_All._ui.stc_KeyGuide_LB:SetShow(false)
    PaGlobal_AddFriend_All._ui.stc_keyGuide_X:SetShow(false)
    PaGlobal_AddFriend_All._ui.stc_keyGuideBG:SetShow(false)
    PaGlobal_AddFriend_All._ui.chk_isFamilyName:SetCheck(PaGlobal_AddFriend_All._isFamilyName)
    PaGlobal_AddFriend_All._ui.chk_isFamilyName:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_BTN_NICKNAME"))
  end
end
function PaGlobal_AddFriend_All:registEventHandler()
  if nil == Panel_FriendList_Add_All then
    return
  end
  Panel_FriendList_Add_All:ignorePadSnapMoveToOtherPanel()
  if true == _ContentsGroup_RenewUI then
    PaGlobal_AddFriend_All._ui.edit_Name:setXboxVirtualKeyBoardEndEvent("PaGlobal_FriendListAdd_EnterAddFriend")
    Panel_FriendList_Add_All:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobal_FriendListAdd_SetFocusEdit()")
    Panel_FriendList_Add_All:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_FriendListAdd_SendAddFriend()")
    Panel_FriendList_Add_All:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobal_AddFriend_ChangeNicknameMode()")
    Panel_FriendList_Add_All:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobal_AddFriend_ChangeNicknameMode()")
  else
    PaGlobal_AddFriend_All._ui.edit_Name:RegistReturnKeyEvent("PaGlobal_FriendListAdd_SendAddFriend")
    PaGlobal_AddFriend_All._ui.chk_isFamilyName:addInputEvent("Mouse_LUp", "PaGlobal_AddFriend_ChangeNicknameMode()")
    PaGlobal_AddFriend_All._ui.btn_Confirm:addInputEvent("Mouse_LUp", "PaGlobal_FriendListAdd_SendAddFriend()")
    PaGlobal_AddFriend_All._ui.btn_Cancel:addInputEvent("Mouse_LUp", "PaGlobal_FriendListAdd_Close_All()")
    PaGlobal_AddFriend_All._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_FriendListAdd_Close_All()")
  end
end
function PaGlobal_AddFriend_All:prepareOpen()
  if nil == Panel_FriendList_Add_All and true == _ContentsGroup_NewUI_Friend_All then
    return
  end
  PaGlobal_AddFriend_All._ui.edit_Name:SetEditText("", true)
  PaGlobal_AddFriend_All:open()
end
function PaGlobal_AddFriend_All:open()
  if nil == Panel_FriendList_Add_All then
    return
  end
  Panel_FriendList_Add_All:SetShow(true)
end
function PaGlobal_AddFriend_All:prepareClose()
  if nil == Panel_FriendList_Add_All then
    return
  end
  CheckChattingInput()
  ClearFocusEdit()
  PaGlobal_AddFriend_All:close()
end
function PaGlobal_AddFriend_All:close()
  if nil == Panel_FriendList_Add_All then
    return
  end
  Panel_FriendList_Add_All:SetShow(false)
end
function PaGlobal_AddFriend_All:updateTab()
  if false == PaGlobal_AddFriend_All._isFamilyName then
    PaGlobal_AddFriend_All._ui.rdo_Family:SetFontColor(Defines.Color.C_FF585453)
    PaGlobal_AddFriend_All._ui.rdo_Character:SetFontColor(Defines.Color.C_FFFFEDD4)
  else
    PaGlobal_AddFriend_All._ui.rdo_Family:SetFontColor(Defines.Color.C_FFFFEDD4)
    PaGlobal_AddFriend_All._ui.rdo_Character:SetFontColor(Defines.Color.C_FF585453)
  end
end
function PaGlobal_FriendListAdd_EnterAddFriend(str)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  PaGlobal_AddFriend_All._ui.edit_Name:SetEditText(str, true)
  ClearFocusEdit()
end
function PaGlobal_FriendListAdd_SetFocusEdit()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  ClearFocusEdit()
  SetFocusEdit(PaGlobal_AddFriend_All._ui.edit_Name)
  PaGlobal_AddFriend_All._ui.edit_Name:SetEditText(PaGlobal_AddFriend_All._ui.edit_Name:GetEditText(), true)
end
function PaGlobal_FriendListAdd_SendAddFriend()
  local friendStr = PaGlobal_AddFriend_All._ui.edit_Name:GetEditText()
  if "" == friendStr then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_DETECTPLAYER_ERRORMSG_PLAYERNAME_NIL"),
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "FRIEND_TEXT_TITLE"),
    content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_XBOX_FRIEND_ADD_ALERT", "characterName", tostring(friendStr)),
    functionYes = PaGlobal_FriendListAdd_EnterAddFriendFunctionYes,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_FriendListAdd_EnterAddFriendFunctionYes()
  requestFriendList_addFriend(PaGlobal_AddFriend_All._ui.edit_Name:GetEditText(), not PaGlobal_AddFriend_All._isFamilyName)
  PaGlobal_AddFriend_All:prepareClose()
end
function PaGlobal_AddFriend_ChangeNicknameMode()
  if false == _ContentsGroup_RenewUI then
    PaGlobal_AddFriend_All._isFamilyName = PaGlobal_AddFriend_All._ui.chk_isFamilyName:IsCheck()
    if PaGlobal_AddFriend_All._isFamilyName then
      PaGlobal_AddFriend_All._ui.chk_isFamilyName:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_BTN_NICKNAME"))
    else
      PaGlobal_AddFriend_All._ui.chk_isFamilyName:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_BTN_CHARACTERNAME"))
    end
  else
    PaGlobal_AddFriend_All._isFamilyName = not PaGlobal_AddFriend_All._isFamilyName
    PaGlobal_AddFriend_All:updateTab()
  end
end
function PaGlobal_FriendRequest_All:initialize()
  if true == PaGlobal_FriendRequest_All._initialize then
    return
  end
  PaGlobal_FriendRequest_All._ui.btn_Close = UI.getChildControl(Panel_Friend_RequestList_All, "RequestFriend_Close_PCUI")
  PaGlobal_FriendRequest_All._ui.list2_request = UI.getChildControl(Panel_Friend_RequestList_All, "List2_RequestFriend")
  PaGlobal_FriendRequest_All._ui.stc_keyGuideBG = UI.getChildControl(Panel_Friend_RequestList_All, "Static_RequestBottom_ConsoleUI")
  PaGlobal_FriendRequest_All._ui.stc_keyGuide_X = UI.getChildControl(PaGlobal_FriendRequest_All._ui.stc_keyGuideBG, "StaticText_Refuse")
  PaGlobal_FriendRequest_All._ui.stc_keyGuide_A = UI.getChildControl(PaGlobal_FriendRequest_All._ui.stc_keyGuideBG, "StaticText_Accept")
  PaGlobal_FriendRequest_All._ui.stc_KeyGuide_B = UI.getChildControl(PaGlobal_FriendRequest_All._ui.stc_keyGuideBG, "StaticText_Cancel")
  PaGlobal_FriendRequest_All._keyGuides = {
    PaGlobal_FriendRequest_All._ui.stc_keyGuide_X,
    PaGlobal_FriendRequest_All._ui.stc_keyGuide_A,
    PaGlobal_FriendRequest_All._ui.stc_KeyGuide_B
  }
  PaGlobal_FriendRequest_All._ui.list2_request:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  PaGlobal_FriendRequest_All:preparePlatform()
  PaGlobal_FriendRequest_All:registEventHandler()
  PaGlobal_FriendRequest_All._initialize = true
end
function PaGlobal_FriendRequest_All:preparePlatform()
  if nil == Panel_Friend_RequestList_All then
    return
  end
  if true == _ContentsGroup_RenewUI then
    PaGlobal_FriendRequest_All._ui.btn_Close:SetShow(false)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_FriendRequest_All._keyGuides, PaGlobal_FriendRequest_All._ui.stc_keyGuideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  else
    PaGlobal_FriendRequest_All._ui.stc_keyGuideBG:SetShow(false)
  end
end
function PaGlobal_FriendRequest_All:registEventHandler()
  if nil == Panel_Friend_RequestList_All then
    return
  end
  Panel_Friend_RequestList_All:ignorePadSnapMoveToOtherPanel()
  registerEvent("ResponseFriendList_updateAddFriends", "PaGlobal_FriendRequestList_Update_All")
  PaGlobal_FriendRequest_All._ui.list2_request:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_FriendRequest_List2EventControlCreate")
  if false == _ContentsGroup_RenewUI then
    PaGlobal_FriendRequest_All._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_FriendRequestList_Close_All()")
  end
end
function PaGlobal_FriendRequest_All:prepareOpen()
  if nil == Panel_Friend_RequestList_All and true == _ContentsGroup_NewUI_Friend_All then
    return
  end
  PaGlobal_FriendRequest_All._selectFriendIndex = -1
  RequestFriendList_getAddFriendList()
  PaGlobal_FriendRequest_All:updateList()
  ToClient_padSnapSetTargetPanel(Panel_Friend_RequestList_All)
  PaGlobal_FriendRequest_All:open()
end
function PaGlobal_FriendRequest_All:open()
  if nil == Panel_Friend_RequestList_All then
    return
  end
  Panel_Friend_RequestList_All:SetShow(true)
end
function PaGlobal_FriendRequest_All:prepareClose()
  if nil == Panel_Friend_RequestList_All then
    return
  end
  PaGlobal_FriendRequest_All:close()
end
function PaGlobal_FriendRequest_All:close()
  if nil == Panel_Friend_RequestList_All then
    return
  end
  Panel_Friend_RequestList_All:SetShow(false)
end
function PaGlobal_FriendRequest_All:updateList()
  if nil == Panel_Friend_RequestList_All then
    return
  end
  local listControl = PaGlobal_FriendRequest_All._ui.list2_request
  listControl:getElementManager():clearKey()
  local friendCount = RequestFriends_getAddFriendCount()
  for friendIndex = 0, friendCount - 1 do
    local addFriendInfo = RequestFriends_getAddFriendAt(friendIndex)
    if nil ~= addFriendInfo then
      listControl:getElementManager():pushKey(toInt64(0, friendIndex))
    end
  end
  if false == _ContentsGroup_RenewUI and false == _ContentsGroup_RemasterUI_Main_Alert then
    FGlobal_NewFriendAlertOff()
  end
end
function PaGlobal_FriendRequest_List2EventControlCreate(control, key64)
  local index = Int64toInt32(key64)
  local addFriendInfo = RequestFriends_getAddFriendAt(index)
  if nil == addFriendInfo then
    return
  end
  local btn_Ok = UI.getChildControl(control, "Button_Apply_PCUI")
  local btn_Refuse = UI.getChildControl(control, "Button_Dismiss_PCUI")
  local name = UI.getChildControl(control, "StaticText_Name")
  control:addInputEvent("Mouse_On", "PaGlobal_FriendRequest_Select(" .. index .. ")")
  if true == _ContentsGroup_RenewUI then
    btn_Ok:SetShow(false)
    btn_Refuse:SetShow(false)
    control:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobal_FriendRequest_RefuseFriend()")
    control:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_FriendRequest_AcceptFriend()")
  else
    btn_Ok:addInputEvent("Mouse_LUp", "PaGlobal_FriendRequest_AcceptFriend()")
    btn_Refuse:addInputEvent("Mouse_LUp", "PaGlobal_FriendRequest_RefuseFriend()")
  end
  name:SetText(addFriendInfo:getName())
end
function PaGlobal_FriendRequest_AcceptFriend()
  if ToClient_isAddFriendAllowed() then
    if -1 ~= PaGlobal_FriendRequest_All._selectFriendIndex then
      requestFriendList_acceptFriend(PaGlobal_FriendRequest_All._selectFriendIndex)
      PaGlobal_FriendRequest_All:updateList()
    end
  else
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    ToClient_showPrivilegeError()
  end
end
function PaGlobal_FriendRequest_RefuseFriend()
  if -1 ~= PaGlobal_FriendRequest_All._selectFriendIndex then
    requestFriendList_refuseFriend(PaGlobal_FriendRequest_All._selectFriendIndex)
    PaGlobal_FriendRequest_All:updateList()
  end
end
function PaGlobal_FriendRequest_Select(index)
  PaGlobal_FriendRequest_All._selectFriendIndex = index
end
function PaGlobal_Friend_GroupRename_All:initialize()
  if true == PaGlobal_Friend_GroupRename_All._initialize then
    return
  end
  PaGlobal_Friend_GroupRename_All._ui.btn_Close = UI.getChildControl(Panel_Friend_GroupRename_All, "Button_GroupName_Close_PCUI")
  PaGlobal_Friend_GroupRename_All._ui.sub_BG = UI.getChildControl(Panel_Friend_GroupRename_All, "Static_GroupName_SubBg")
  PaGlobal_Friend_GroupRename_All._ui.edit_GroupName = UI.getChildControl(Panel_Friend_GroupRename_All, "Edit_GroupName")
  PaGlobal_Friend_GroupRename_All._ui.stc_keyGuide_X = UI.getChildControl(Panel_Friend_GroupRename_All, "StaticText_EditGroupKeyGuide_ConsoleUI")
  PaGlobal_Friend_GroupRename_All._ui.btn_Confirm = UI.getChildControl(Panel_Friend_GroupRename_All, "Button_GroupName_Yes_PCUI")
  PaGlobal_Friend_GroupRename_All._ui.btn_Cancel = UI.getChildControl(Panel_Friend_GroupRename_All, "Button_GroupName_No_PCUI")
  PaGlobal_Friend_GroupRename_All._ui.stc_keyGuideBG = UI.getChildControl(Panel_Friend_GroupRename_All, "Static_Bottom_ConsoleUI")
  PaGlobal_Friend_GroupRename_All._ui.stc_KeyGuide_A = UI.getChildControl(PaGlobal_Friend_GroupRename_All._ui.stc_keyGuideBG, "StaticText_Apply")
  PaGlobal_Friend_GroupRename_All._ui.stc_KeyGuide_B = UI.getChildControl(PaGlobal_Friend_GroupRename_All._ui.stc_keyGuideBG, "StaticText_Cancel")
  PaGlobal_Friend_GroupRename_All._keyGuides = {
    PaGlobal_Friend_GroupRename_All._ui.stc_KeyGuide_A,
    PaGlobal_Friend_GroupRename_All._ui.stc_KeyGuide_B
  }
  PaGlobal_Friend_GroupRename_All._ui.edit_GroupName:SetMaxInput(getGameServiceTypeUserNickNameLength())
  PaGlobal_Friend_GroupRename_All:preparePlatform()
  PaGlobal_Friend_GroupRename_All:registEventHandler()
  PaGlobal_Friend_GroupRename_All._initialize = true
end
function PaGlobal_Friend_GroupRename_All:preparePlatform()
  if nil == Panel_Friend_GroupRename_All then
    return
  end
  if true == _ContentsGroup_RenewUI then
    PaGlobal_Friend_GroupRename_All._ui.btn_Close:SetShow(false)
    PaGlobal_Friend_GroupRename_All._ui.btn_Confirm:SetShow(false)
    PaGlobal_Friend_GroupRename_All._ui.btn_Cancel:SetShow(false)
    local subBG = PaGlobal_Friend_GroupRename_All._ui.sub_BG
    Panel_Friend_GroupRename_All:SetSize(Panel_Friend_GroupRename_All:GetSizeX(), Panel_Friend_GroupRename_All:GetSizeY() - 90)
    subBG:SetSize(subBG:GetSizeX(), subBG:GetSizeY() - 90)
    Panel_Friend_GroupRename_All:ComputePos()
    PaGlobal_Friend_GroupRename_All._ui.stc_keyGuideBG:ComputePos()
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_Friend_GroupRename_All._keyGuides, PaGlobal_Friend_GroupRename_All._ui.stc_keyGuideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  else
    PaGlobal_Friend_GroupRename_All._ui.stc_keyGuide_X:SetShow(false)
    PaGlobal_Friend_GroupRename_All._ui.stc_keyGuideBG:SetShow(false)
  end
end
function PaGlobal_Friend_GroupRename_All:registEventHandler()
  if nil == Panel_Friend_GroupRename_All then
    return
  end
  Panel_Friend_GroupRename_All:ignorePadSnapMoveToOtherPanel()
  if true == _ContentsGroup_RenewUI then
    PaGlobal_Friend_GroupRename_All._ui.edit_GroupName:setXboxVirtualKeyBoardEndEvent("PaGlobal_FriendGroupRename_EnterGroupName")
    Panel_Friend_GroupRename_All:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobal_FriendGroupRename_SetFocusEdit()")
    Panel_Friend_GroupRename_All:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_FriendGroupRename_Confirm()")
  else
    PaGlobal_Friend_GroupRename_All._ui.edit_GroupName:RegistReturnKeyEvent("PaGlobal_FriendGroupRename_EnterGroupName")
    PaGlobal_Friend_GroupRename_All._ui.edit_GroupName:addInputEvent("Mouse_LUp", "PaGlobal_FriendGroupRename_SetFocusEdit()")
    PaGlobal_Friend_GroupRename_All._ui.btn_Confirm:addInputEvent("Mouse_LUp", "PaGlobal_FriendGroupRename_Confirm()")
    PaGlobal_Friend_GroupRename_All._ui.btn_Cancel:addInputEvent("Mouse_LUp", "PaGlobal_FriendGroupRename_Close_All()")
    PaGlobal_Friend_GroupRename_All._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_FriendGroupRename_Close_All()")
  end
end
function PaGlobal_Friend_GroupRename_All:prepareOpen(isAdd)
  if nil == Panel_Friend_GroupRename_All then
    return
  end
  PaGlobal_Friend_GroupRename_All._isAddGroup = isAdd
  if true == isAdd then
    PaGlobal_Friend_GroupRename_All._ui.edit_GroupName:SetEditText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_NEW_GROUPNAME"), true)
  else
    PaGlobal_Friend_GroupRename_All._ui.edit_GroupName:SetEditText("", true)
  end
  ToClient_padSnapSetTargetPanel(Panel_Friend_GroupRename_All)
  PaGlobal_Friend_GroupRename_All:open()
end
function PaGlobal_Friend_GroupRename_All:open()
  if nil == Panel_Friend_GroupRename_All then
    return
  end
  Panel_Friend_GroupRename_All:SetShow(true)
end
function PaGlobal_Friend_GroupRename_All:prepareClose()
  if nil == Panel_Friend_GroupRename_All then
    return
  end
  CheckChattingInput()
  PaGlobal_Friend_GroupRename_All:close()
end
function PaGlobal_Friend_GroupRename_All:close()
  if nil == Panel_Friend_GroupRename_All then
    return
  end
  Panel_Friend_GroupRename_All:SetShow(false)
end
function PaGlobal_FriendGroupRename_SetFocusEdit()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  ClearFocusEdit()
  SetFocusEdit(PaGlobal_Friend_GroupRename_All._ui.edit_GroupName)
  PaGlobal_Friend_GroupRename_All._ui.edit_GroupName:SetEditText(PaGlobal_Friend_GroupRename_All._ui.edit_GroupName:GetEditText(), true)
end
function PaGlobal_FriendGroupRename_EnterGroupName(str)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  PaGlobal_Friend_GroupRename_All._ui.edit_GroupName:SetEditText(str, true)
  ClearFocusEdit()
end
function PaGlobal_FriendGroupRename_Confirm()
  if true == PaGlobal_Friend_GroupRename_All._isAddGroup then
    PaGlobal_FriendGroupRename_AddGroup()
  else
    PaGlobal_FriendGroupRename_RenameGroup()
  end
end
function PaGlobal_FriendGroupRename_RenameGroup()
  local _groupListData = PaGlobal_FriendList._groupListData
  local editText = PaGlobal_Friend_GroupRename_All._ui.edit_GroupName:GetEditText()
  if 0 <= _groupListData._selectedGroupIndex then
    local friendGroup = _groupListData._groupInfo[_groupListData._selectedGroupIndex]
    if editText == friendGroup:getName() then
      return
    end
    if "" == PeditText then
      return
    end
    requestFriendList_renameGroup(_groupListData._groupInfo[_groupListData._selectedGroupIndex]:getGroupNo(), editText)
  end
  PaGlobal_Friend_GroupRename_All:prepareClose()
end
function PaGlobal_FriendGroupRename_AddGroup()
  local editText = PaGlobal_Friend_GroupRename_All._ui.edit_GroupName:GetEditText()
  requestFriendList_addFriendGroup(editText)
  PaGlobal_Friend_GroupRename_All:prepareClose()
end
function PaGlobal_FriendMessangerManager_All:createMessanger(messangerId, userName, isOnline)
  local messanger = {
    _mainPanel = nil,
    _uiClose = nil,
    _uiEnter = nil,
    _uiEditInputChat = nil,
    _uiStaticTitle = nil,
    _uiStaticTitleImg = nil,
    _uiSizeControl = nil,
    _uiSlider = nil,
    _uiSliderButton = nil,
    _uiFrame = nil,
    _uiFrameContent = nil,
    _uiFrameScroll = nil,
    _uiStaticText = {},
    _uiStaticBg = {},
    _messangerAlpha = 1,
    _messageCount = 0,
    _isCallShow = false
  }
  function messanger:initialize(messangerId, userName, isOnline)
    messanger:createPanel(messangerId, isOnline)
    messanger:prepareControl(messangerId, userName, isOnline)
  end
  function messanger:clear()
    UI.deletePanel(messanger._mainPanel:GetID())
    messanger._mainPanel = nil
  end
  function messanger:createPanel(messangerId, isOnline)
    local newName = "Panel_FriendMessanger" .. messangerId
    messanger._mainPanel = UI.createPanel(newName, Defines.UIGroup.PAGameUIGroup_WorldMap_Popups)
    CopyBaseProperty(Panel_Friend_Messanger_All, messanger._mainPanel)
    messanger._mainPanel:SetDragAll(true)
    messanger._mainPanel:SetShow(true)
    messanger._mainPanel:addInputEvent("Mouse_UpScroll", "FriendMessanger_OnMouseWheel( " .. messangerId .. ", true )")
    messanger._mainPanel:addInputEvent("Mouse_DownScroll", "FriendMessanger_OnMouseWheel( " .. messangerId .. ", false )")
  end
  function messanger:prepareControl(messangerId, userName, isOnline)
    messanger._uiClose = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_Friend_Messanger_All, messanger._mainPanel, "Button_Close", 0)
    messanger._uiClose:addInputEvent("Mouse_LUp", "FriendMessanger_Close(" .. messangerId .. ")")
    messanger._uiFrame = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_FRAME, Panel_Friend_Messanger_All, messanger._mainPanel, "Frame_1", 0)
    messanger._uiFrameScroll = messanger._uiFrame:GetVScroll()
    local styleFrame = UI.getChildControl(Panel_Friend_Messanger_All, "Frame_1")
    local styleScroll = UI.getChildControl(styleFrame, "Frame_1_VerticalScroll")
    CopyBaseProperty(styleScroll, messanger._uiFrameScroll)
    messanger._uiFrameContent = messanger._uiFrame:GetFrameContent()
    local btn_Enter = UI.getChildControl(Panel_Friend_Messanger_All, "Button_Enter")
    messanger._uiEnter = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_Friend_Messanger_All, messanger._mainPanel, "Button_Enter", 0)
    messanger._uiEnterIcon = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, btn_Enter, messanger._uiEnter, "Static_EnterIcon", 0)
    messanger._uiEnter:addInputEvent("Mouse_LUp", "friend_sendMessage(" .. messangerId .. ")")
    messanger._uiEditInputChat = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_EDIT, Panel_Friend_Messanger_All, messanger._mainPanel, "Edit_InputChat", 0)
    messanger._uiEditInputChat:SetMaxInput(100)
    if isOnline then
      messanger._uiEditInputChat:addInputEvent("Mouse_LUp", "FriendMessanger_SetFocusEdit(" .. messangerId .. ")")
      messanger._uiEditInputChat:RegistReturnKeyEvent("friend_sendMessageByKey()")
      messanger._uiEditInputChat:SetEnable(true)
      messanger._uiEnter:SetEnable(true)
    else
      messanger._uiEditInputChat:SetEnable(false)
      messanger._uiEnter:SetEnable(false)
    end
    messanger._uiStaticTitle = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Friend_Messanger_All, messanger._mainPanel, "StaticText_TitleName", 0)
    messanger._uiStaticTitle:SetText(userName)
    messanger._uiStaticTitleImg = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Friend_Messanger_All, messanger._mainPanel, "Static_TitleImage", 0)
    messanger._uiSizeControl = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_Friend_Messanger_All, messanger._mainPanel, "Button_SizeControl", 0)
    messanger._uiSizeControl:addInputEvent("Mouse_LDown", "FriendMessanger_ResizeStartPos( " .. messangerId .. " )")
    messanger._uiSizeControl:addInputEvent("Mouse_LPress", "FriendMessanger_Resize( " .. messangerId .. " )")
    messanger._uiSlider = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_SLIDER, messanger._mainPanel, "Slider_Alpha")
    messanger._uiSliderButton = messanger._uiSlider:GetControlButton()
    local style = UI.getChildControl(Panel_Friend_Messanger_All, "Slider_Alpha")
    CopyBaseProperty(style, messanger._uiSlider)
    messanger._uiSlider:SetInterval(100)
    messanger._uiSliderButton:addInputEvent("Mouse_LPress", "FriendMessanger_AlphaSlider( " .. messangerId .. ")")
    messanger._uiSlider:addInputEvent("Mouse_LUp", "FriendMessanger_AlphaSlider( " .. messangerId .. ")")
    messanger._uiSlider:SetControlPos(100)
  end
  function messanger:createControl(controlType, parentStyleControl, parentControl, controlName, index)
    local styleControl = UI.getChildControl(parentStyleControl, controlName)
    local control = UI.createControl(controlType, parentControl, controlName .. index)
    CopyBaseProperty(styleControl, control)
    return control
  end
  function messanger:clearAllMessage()
    for index = 0, messanger._messageCount - 1 do
      messanger._uiStaticText[index]:SetShow(false)
      messanger._uiStaticBg[index]:SetShow(false)
      UI.deleteControl(messanger._uiStaticText[index])
      UI.deleteControl(messanger._uiStaticBg[index])
    end
    messanger._messageCount = 0
  end
  function messanger:updateMessage(chattingMessage)
    local msg = chattingMessage:getContent()
    local isMe = chattingMessage.isMe
    messanger:showMessage(isMe, msg)
    messanger._messageCount = messanger._messageCount + 1
  end
  function messanger:showMessage(isMe, msg)
    messanger:createMessageUI(isMe)
    messanger:resizeMessageUI(msg)
    messanger:setPosMessageUI(isMe)
  end
  function messanger:resizeMessageUI(msg)
    local panelSizeX = messanger._mainPanel:GetSizeX()
    local maxTextSizeX = panelSizeX - 100
    local staticText = messanger._uiStaticText[messanger._messageCount]
    local staticBg = messanger._uiStaticBg[messanger._messageCount]
    staticText:SetSize(maxTextSizeX, staticText:GetSizeY())
    staticText:SetAutoResize(true)
    staticText:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    staticText:SetText(msg)
    local textSizeX = maxTextSizeX
    local textSizeX = math.min(staticText:GetTextSizeX(), maxTextSizeX)
    textSizeX = math.max(12, textSizeX)
    staticBg:SetSize(textSizeX + 13, staticText:GetSizeY() + 13)
    staticBg:SetAlpha(messanger._messangerAlpha)
    staticText:SetFontAlpha(messanger._messangerAlpha)
  end
  function messanger:createMessageUI(isMe)
    local styleBg = UI.getChildControl(Panel_Friend_Messanger_All, "Static_To")
    local styleText = UI.getChildControl(Panel_Friend_Messanger_All, "StaticText_To")
    if false == isMe then
      styleBg = UI.getChildControl(Panel_Friend_Messanger_All, "Static_From")
      styleText = UI.getChildControl(Panel_Friend_Messanger_All, "StaticText_From")
    end
    messanger._uiStaticBg[messanger._messageCount] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, messanger._uiFrameContent, "Static_BG_" .. messanger._messageCount)
    messanger._uiStaticText[messanger._messageCount] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, messanger._uiFrameContent, "Static_Text_" .. messanger._messageCount)
    CopyBaseProperty(styleBg, messanger._uiStaticBg[messanger._messageCount])
    CopyBaseProperty(styleText, messanger._uiStaticText[messanger._messageCount])
    messanger._uiStaticBg[messanger._messageCount]:SetShow(true)
    messanger._uiStaticText[messanger._messageCount]:SetIgnore(true)
    messanger._uiStaticText[messanger._messageCount]:SetShow(true)
  end
  function messanger:setPosMessageUI(isMe)
    local prevBgPosY = 0
    local prevBgSizeY = 0
    if 0 < messanger._messageCount then
      prevBgPosY = messanger._uiStaticBg[messanger._messageCount - 1]:GetPosY()
      prevBgSizeY = messanger._uiStaticBg[messanger._messageCount - 1]:GetSizeY()
    end
    local bgPosX = 12
    if isMe then
      bgPosX = messanger._mainPanel:GetSizeX() - messanger._uiStaticBg[messanger._messageCount]:GetSizeX() - 40
      messanger._uiStaticText[messanger._messageCount]:SetPosX(messanger._uiStaticText[messanger._messageCount]:GetPosX() - 39)
    end
    messanger._uiStaticBg[messanger._messageCount]:SetPosX(bgPosX)
    messanger._uiStaticBg[messanger._messageCount]:SetPosY(prevBgPosY + prevBgSizeY + 5)
    messanger._uiStaticText[messanger._messageCount]:SetPosY(messanger._uiStaticBg[messanger._messageCount]:GetPosY() + 1)
  end
  messanger:initialize(messangerId, userName, isOnline)
  return messanger
end
function FriendMessanger_AlphaSlider(messangerId)
  local messanger = PaGlobal_FriendMessangerManager_All._messangerList[messangerId]
  local panel = PaGlobal_FriendMessangerManager_All._messangerList[messangerId]._mainPanel
  messanger._messangerAlpha = messanger._uiSlider:GetControlPos() * 0.5 + 0.5
  panel:SetAlpha(messanger._messangerAlpha)
  panel:SetAlphaChild(messanger._messangerAlpha)
  messanger._uiStaticTitle:SetFontAlpha(messanger._messangerAlpha)
  for i = 0, messanger._messageCount - 1 do
    local staticText = messanger._uiStaticText[i]
    if nil ~= staticText then
      staticText:SetFontAlpha(messanger._messangerAlpha)
    end
  end
end
local orgMouseX = 0
local orgMouseY = 0
local orgPanelSizeX = 0
local orgPanelSizeY = 0
local orgPanelPosY = 0
function FriendMessanger_ResizeStartPos(messangerId)
  local panel = PaGlobal_FriendMessangerManager_All._messangerList[messangerId]._mainPanel
  orgMouseX = getMousePosX()
  orgMouseY = getMousePosY()
  orgPanelPosX = panel:GetPosX()
  orgPanelSizeX = panel:GetSizeX()
  orgPanelSizeY = panel:GetSizeY()
end
function FriendMessanger_Resize(messangerId)
  local messanger = PaGlobal_FriendMessangerManager_All._messangerList[messangerId]
  local panel = messanger._mainPanel
  local currentPosX = panel:GetPosX()
  local currentX = getMousePosX()
  local currentY = getMousePosY()
  local deltaX = orgMouseX - currentX
  local deltaY = currentY - orgMouseY
  local sizeX = orgPanelSizeX + deltaX
  local sizeY = orgPanelSizeY + deltaY
  if sizeX > 800 then
    sizeX = 800
  elseif sizeX < 300 then
    sizeX = 300
  end
  if sizeY > 800 then
    sizeY = 800
  elseif sizeY < 212 then
    sizeY = 212
  end
  local currentSizeX = panel:GetSizeX()
  local currentSizeY = panel:GetSizeY()
  panel:SetSize(sizeX, sizeY)
  panel:SetPosX(currentPosX + currentSizeX - sizeX)
  messanger._uiSizeControl:SetPosY(panel:GetSizeY() - messanger._uiSizeControl:GetSizeY())
  messanger._uiEditInputChat:SetPosY(panel:GetSizeY() - messanger._uiEditInputChat:GetSizeY() - 5)
  messanger._uiEditInputChat:SetSize(panel:GetSizeX() - 69, messanger._uiEditInputChat:GetSizeY())
  messanger._uiClose:SetPosX(panel:GetSizeX() - messanger._uiClose:GetSizeX() - 5)
  messanger._uiFrame:SetSize(panel:GetSizeX() - 10, panel:GetSizeY() - 55)
  messanger._uiEnter:SetPosY(panel:GetSizeY() - 33)
  messanger._uiEnter:SetPosX(panel:GetSizeX() - 46)
  messanger._uiSlider:SetPosX(panel:GetSizeX() - 102)
  FromClient_FriendListUpdateMessanger(messangerId)
end
function FriendMessanger_OnMouseWheel(messangerId, isUp)
  local messanger = PaGlobal_FriendMessangerManager_All._messangerList[messangerId]
  local targetScroll = messanger._uiFrameScroll
  if isUp then
    targetScroll:ControlButtonUp()
  else
    targetScroll:ControlButtonDown()
  end
  messanger._uiFrame:UpdateContentPos()
end
function FriendMessanger_CheckCurrentUiEdit(targetUI)
  if -1 == PaGlobal_FriendMessangerManager_All._currentFocusId then
    return false
  end
  local currentEdit = PaGlobal_FriendMessangerManager_All._messangerList[PaGlobal_FriendMessangerManager_All._currentFocusId]._uiEditInputChat
  return nil ~= targetUI and targetUI:GetKey() == currentEdit:GetKey()
end
function FriendMessanger_Close(messangerId)
  local messanger = PaGlobal_FriendMessangerManager_All._messangerList[messangerId]
  ToClient_FriendListCloseMessanger(messangerId)
  messanger:clear()
  PaGlobal_FriendMessangerManager_All._messangerList[messangerId] = nil
  if messangerId == PaGlobal_FriendMessangerManager_All._currentFocusId then
    PaGlobal_FriendMessangerManager_All._currentFocusId = -1
    ClearFocusEdit()
  end
  CheckChattingInput()
end
function FriendMessanger_SetFocusEdit(messangerId)
  local messanger = PaGlobal_FriendMessangerManager_All._messangerList[messangerId]
  SetFocusEdit(messanger._uiEditInputChat)
  PaGlobal_FriendMessangerManager_All._currentFocusId = messangerId
end
function FriendMessanger_KillFocusEdit()
  if -1 == PaGlobal_FriendMessangerManager_All._currentFocusId then
    return false
  end
  ClearFocusEdit()
  CheckChattingInput()
  PaGlobal_FriendMessangerManager_All._currentFocusId = -1
  return false
end
function friend_sendMessageByKey()
  friend_sendMessage(PaGlobal_FriendMessangerManager_All._currentFocusId)
end
function friend_killFocusMessangerByKey()
  FriendMessanger_KillFocusEdit()
end
function friend_sendMessage(messangerId)
  local messanger = PaGlobal_FriendMessangerManager_All._messangerList[messangerId]
  local rv = chatting_sendMessageByUserNo(RequestFriendList_GetMessageListById(messangerId):getUserNo(), messanger._uiEditInputChat:GetEditText(), CppEnums.ChatType.Friend)
  if 0 == rv then
    RequestFriendList_GetMessageListById(messangerId):pushFromMessage(messanger._uiEditInputChat:GetEditText())
  end
  messanger._uiEditInputChat:SetEditText("", true)
end
function FromClient_FriendListUpdateMessanger(messangerId)
  local friendMesaageList = RequestFriendList_GetMessageListById(messangerId)
  local message = friendMesaageList:beginMessage()
  local messanger = PaGlobal_FriendMessangerManager_All._messangerList[messangerId]
  if nil == messanger then
    return
  end
  if 0 < messanger._messageCount then
    messanger:clearAllMessage()
  end
  while message ~= nil do
    messanger:updateMessage(message)
    message = friendMesaageList:nextMessage()
  end
  messanger._uiFrame:UpdateContentScroll()
  messanger._uiFrameScroll:SetControlBottom()
  messanger._uiFrame:UpdateContentPos()
  messanger._uiFrameScroll:GetControlButton():SetPosX(0)
end
function FromClient_FriendListOpenMessanger(messangerId, userName, isOnline)
  if nil == PaGlobal_FriendMessangerManager_All._messangerList[messangerId] and true == _ContentsGroup_NewUI_Friend_All then
    PaGlobal_FriendMessangerManager_All._messangerList[messangerId] = PaGlobal_FriendMessangerManager_All:createMessanger(messangerId, userName, isOnline)
  end
  if isOnline then
    FriendMessanger_SetFocusEdit(messangerId)
  end
  FromClient_FriendListUpdateMessanger(messangerId)
end
function FromClient_FriendListUpdateLogOnOffForMessanger(messangerId, isOnline)
  local messanger = PaGlobal_FriendMessangerManager_All._messangerList[messangerId]
  if messangerId == PaGlobal_FriendMessangerManager_All._currentFocusId and -1 ~= messangerId then
    PaGlobal_FriendMessangerManager_All._currentFocusId = -1
    ClearFocusEdit()
    CheckChattingInput()
  end
  if nil ~= messanger then
    if 1 == isOnline then
      messanger._uiEditInputChat:SetEnable(true)
      messanger._uiEnter:SetEnable(true)
    else
      messanger._uiEditInputChat:SetEnable(false)
      messanger._uiEnter:SetEnable(false)
    end
  end
end
registerEvent("FromClient_FriendListUpdateMessanger", "FromClient_FriendListUpdateMessanger")
registerEvent("FromClient_FriendListOpenMessanger", "FromClient_FriendListOpenMessanger")

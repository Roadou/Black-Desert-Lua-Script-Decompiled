PaGlobal_FriendList_All = {
  _ui = {
    stc_TitleBG = nil,
    btn_Close = nil,
    btn_Question = nil,
    chk_Sound = nil,
    chk_Effect = nil,
    stc_TabBG = nil,
    rdo_PCFriend = nil,
    rdo_ConsoleFriend = nil,
    stc_KeyGuide_LB = nil,
    stc_KeyGuide_RB = nil,
    list2_Friend = nil,
    stc_backStatic = nil,
    stc_overStatic = nil,
    btn_Request = nil,
    btn_AddFriend = nil,
    stc_FunctionBG = nil,
    stc_function = nil,
    stc_XBFunctionBG = nil,
    stc_XBFunctionList = {},
    stc_PopupFunctionBG = nil,
    stc_PopupFunctionList = {},
    stc_SubFunctionBG = nil,
    stc_SubFunctionList = {},
    stc_BottomBG = nil,
    txt_KeyGuide_X = nil,
    txt_KeyGuide_Y = nil,
    txt_KeyGuide_A = nil,
    txt_KeyGuide_B = nil,
    txt_KeyGuide_LT = nil
  },
  _groupListData = {
    _defaultGroupIndex = -1,
    _partyplayGroupIndex = -1,
    _selectedGroupIndex = -1,
    _uiGroups = {},
    _groupInfo = {},
    _groupInfoByGroupIndex = {},
    _groupCount = 0
  },
  _friendListData = {
    _selectedFriendIndex = -1,
    _uiFriends = {},
    _friendInfo = {}
  },
  _keyGuideType = {
    _DefaultGroup = 1,
    _Group = 2,
    _Friend = 3,
    _XBFriend = 4,
    _Popup = 5,
    _AddGroup = 6,
    _None = 7
  },
  _tab = {_pcFriendTab = 0, _consoleFriendTab = 1},
  _MAX_FUNCTION_COUNT = 4,
  _MAX_GROUP_COUNT = 5,
  _MAX_FRIEND_COUNT = 50,
  _currentKeyGuideType = 1,
  _currentTab = 0,
  _selectedXBFriendIndex = -1,
  _initialize = false
}
PaGlobal_FriendMessangerManager_All = {
  _currentFocusId = -1,
  _messangerList = {}
}
PaGlobal_AddFriend_All = {
  _ui = {
    btn_Close = nil,
    txt_Desc = nil,
    chk_isFamilyName = nil,
    rdo_Family = nil,
    rdo_Character = nil,
    stc_KeyGuide_RB = nil,
    stc_KeyGuide_LB = nil,
    stc_keyGuide_X = nil,
    edit_Name = nil,
    btn_Confirm = nil,
    btn_Cancel = nil,
    stc_keyGuideBG = nil,
    stc_KeyGuide_A = nil,
    stc_KeyGuide_B = nil
  },
  _isFamilyName = true,
  _initialize = false
}
PaGlobal_FriendRequest_All = {
  _ui = {
    btn_Close = nil,
    list2_request = nil,
    stc_keyGuideBG = nil,
    stc_keyGuide_X = nil,
    stc_KeyGuide_A = nil,
    stc_keyGuide_B = nil
  },
  _maxFriendCount = 30,
  _selectFriendIndex = 0,
  _initialize = false
}
PaGlobal_Friend_GroupRename_All = {
  _ui = {
    btn_Close = nil,
    edit_GroupName = nil,
    stc_keyGuide_X = nil,
    btn_Confirm = nil,
    btn_Cancel = nil,
    stc_keyGuideBG = nil,
    stc_KeyGuide_A = nil,
    stc_KeyGuide_B = nil
  },
  _isAddGroup = false,
  _initialize = false
}
runLua("UI_Data/Script/Window/Friend/Panel_FriendList_All_1.lua")
runLua("UI_Data/Script/Window/Friend/Panel_FriendList_All_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_FriendList_All_Init")
registerEvent("FromClient_luaLoadComplete", "FromClient_PaGlobal_AddFriend_All_Init")
registerEvent("FromClient_luaLoadComplete", "FromClient_PaGlobal_FriendRequest_All_Init")
registerEvent("FromClient_luaLoadComplete", "FromClient_PaGlobal_Friend_GroupRename_All_Init")
function FromClient_FriendList_All_Init()
  PaGlobal_FriendList_All:initialize()
end
function FromClient_PaGlobal_AddFriend_All_Init()
  PaGlobal_AddFriend_All:initialize()
end
function FromClient_PaGlobal_FriendRequest_All_Init()
  PaGlobal_FriendRequest_All:initialize()
end
function FromClient_PaGlobal_Friend_GroupRename_All_Init()
  PaGlobal_Friend_GroupRename_All:initialize()
end

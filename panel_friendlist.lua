Panel_FriendList:SetShow(false, false)
Panel_FriendList:RegisterShowEventFunc(true, "PaGlobal_FriendList:ShowAni()")
Panel_FriendList:RegisterShowEventFunc(false, "PaGlobal_FriendList:HideAni()")
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
PaGlobal_FriendList = {
  _ui = {
    _btnClose = UI.getChildControl(Panel_FriendList, "Button_Close"),
    _btnQuestion = UI.getChildControl(Panel_FriendList, "Button_Question"),
    _btnRequestList = UI.getChildControl(Panel_FriendList, "Button_Offer"),
    _btnAddFriend = UI.getChildControl(Panel_FriendList, "Button_AddFriend"),
    _checkBtnSound = UI.getChildControl(Panel_FriendList, "CheckButton_Sound"),
    _checkBtnEffect = UI.getChildControl(Panel_FriendList, "CheckButton_Effect"),
    _checkBtnSortByOnline = UI.getChildControl(Panel_FriendList, "CheckButton_SortByOnline"),
    _treeFriend = UI.getChildControl(Panel_FriendList, "Tree_Friend"),
    _treeFriendBackStatic = nil,
    _treeFriendOverStatic = nil,
    _treeFriendScroll = nil
  },
  _groupData = {
    _selectedIndex = -1,
    _info = {},
    _infoByIndex = {},
    _count = 0,
    _maxCount = 5,
    _isMenuShow = false
  },
  _friendData = {
    _selectedIndex = -1,
    _info = {},
    _maxCount = 50,
    _isMenuShow = false
  }
}
function PaGlobal_FriendList:Initialize()
  ToClient_GetFriendList()
  Panel_FriendList:addInputEvent("Mouse_Out", "PaGlobal_FriendList:ClosePopupMenu()")
  self._ui._treeFriendBackStatic = UI.getChildControl(self._ui._treeFriend, "Tree_Friend_BackStatic")
  self._ui._treeFriendOverStatic = UI.getChildControl(self._ui._treeFriend, "Tree_Friend_OverStatic")
  self._ui._treeFriendScroll = UI.getChildControl(self._ui._treeFriend, "Tree_Friend_Scroll")
  self._ui._btnClose:addInputEvent("Mouse_LUp", " PaGlobal_FriendList:Hide()")
  self._ui._btnQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelFriends\" )")
  self._ui._btnQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelFriends\", \"true\")")
  self._ui._btnQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelFriends\", \"false\")")
  self._ui._btnRequestList:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:ClickRequestButton()")
  self._ui._btnAddFriend:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:ClickAddFriendButton()")
  self._ui._checkBtnSound:addInputEvent("Mouse_LUp", "ToClient_ToggleSoundNotice()")
  self._ui._checkBtnEffect:addInputEvent("Mouse_LUp", "ToClient_ToggleEffectNotice()")
  self._ui._checkBtnSortByOnline:addInputEvent("Mouse_LUp", "ToClient_ToggleSortByOnline()")
  self._ui._treeFriend:addInputEvent("Mouse_RUp", "PaGlobal_FriendList:ClickFriendList(true)")
  self._ui._treeFriend:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:ClickFriendList(false)")
  self._ui._treeFriend:addInputEvent("Mouse_UpScroll", "PaGlobal_FriendList:ClosePopupMenu()")
  self._ui._treeFriend:addInputEvent("Mouse_DownScroll", "PaGlobal_FriendList:ClosePopupMenu()")
  self._ui._treeFriend:SetItemQuantity(15)
  self._ui._treeFriendScroll:SetSize(self._ui._treeFriendScroll:GetSizeX(), self._ui._treeFriend:GetSizeY())
end
function PaGlobal_FriendList:UpdateList()
  local prePos = self._ui._treeFriendScroll:GetControlPos()
  self._ui._treeFriend:ClearTree()
  self._ui._treeFriend:SetShow(true)
  self._ui._treeFriendBackStatic:SetShow(true)
  self._ui._treeFriendOverStatic:SetShow(true)
  self._groupData._count = ToClient_GetFriendGroupCount()
  local indexCnt = 0
  local groupIndexCnt = 0
  for groupIndex = 0, self._groupData._count - 1 do
    local friendGroup = ToClient_GetFriendGroupAt(groupIndex)
    local rootItem = self._ui._treeFriend:createRootItem()
    if -1 == friendGroup:getGroupNo() then
      rootItem:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_GROUP_ETC"))
    else
      rootItem:SetText(friendGroup:getName())
    end
    rootItem:SetCustomData(rootItem)
    self._ui._treeFriend:AddRootItem(rootItem)
    self._groupData._info[indexCnt] = friendGroup
    self._groupData._infoByIndex[groupIndex] = friendGroup
    self._groupData._count = self._groupData._count
    indexCnt = indexCnt + 1
    groupIndexCnt = indexCnt
    if false == friendGroup:isHide() then
      local friendCount = friendGroup:getFriendCount()
      for friendIndex = 0, friendCount - 1 do
        local friendInfo = friendGroup:getFriendAt(friendIndex)
        local childItem = self._ui._treeFriend:createChildItem()
        local friendName = friendInfo:getName()
        local fontColor
        if false == friendInfo:isOnline() then
          local s64_lastLogoutTime = friendInfo:getLastLogoutTime_s64()
          friendName = friendName .. "(" .. convertStringFromDatetimeOverHourForFriends(s64_lastLogoutTime) .. ")"
          fontColor = Defines.Color.C_FF888888
        else
          fontColor = Defines.Color.C_FFFFFFFF
          if -1 < friendInfo:getWp() and -1 < friendInfo:getExplorationPoint() then
            friendName = friendName .. "(" .. friendInfo:getCharacterName() .. ", " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. tostring(friendInfo:getLevel()) .. ") " .. tostring(friendInfo:getWp()) .. "/" .. tostring(friendInfo:getExplorationPoint())
          else
            friendName = friendName .. "(" .. PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_ONLINE") .. ")"
          end
        end
        childItem:SetText(friendName)
        childItem:SetFontColor(fontColor)
        childItem:SetCustomData(childItem)
        self._ui._treeFriend:AddItem(childItem, rootItem)
        local messageList = ToClient_GetFriendMessageListByUserNo(friendInfo:getUserNo())
        if nil ~= messageList then
          local messageCount = messageList:getMessageCount()
          if messageCount > 0 then
            local childIcon = childItem:GetChildIcon()
            childIcon:SetText(messageCount)
            childIcon:SetTextureByPath("New_UI_Common_forLua/Widget/Character_Main/Knowledge_00.dds")
            childIcon:SetTextureUV(196, 1, 20, 20)
            childIcon:SetIconSize(14, 14)
          end
        end
        self._friendData._info[indexCnt] = friendInfo
        indexCnt = indexCnt + 1
      end
      if friendCount > 0 then
        self._ui._treeFriend:SetSelectItem(groupIndexCnt)
      end
    end
  end
  self._ui._treeFriend:RefreshOpenList()
  self._ui._treeFriendScroll:SetControlPos(prePos)
end
function FGlobal_FriendList_UpdateList()
  PaGlobal_FriendList:UpdateList()
end
function FromClient_UpdateFriendList()
  PaGlobal_FriendList:UpdateList()
end
function FromClient_NoticeNewMessage(isSoundNotice, isEffectNotice)
  if isEffectNotice and false == Panel_FriendList:GetShow() then
    UIMain_FriendListUpdate()
    if false == _ContentsGroup_RemasterUI_Main_Alert then
      UIMain_FriendsUpdate()
    end
  end
  if isSoundNotice then
    audioPostEvent_SystemUi(3, 11)
  end
end
PaGlobal_FriendList:Initialize()
local FriendRequestList = {
  _maxFriendCount = 30,
  _ui = {
    _backGround = UI.getChildControl(Panel_FriendList, "Static_OfferWindow"),
    _listBox = nil,
    _btnClose = nil,
    _btnAccept = nil,
    _btnRefuse = nil,
    _partLine = nil,
    _titleName = nil,
    _scroll = nil,
    _scrollCtrlButton = nil
  },
  _selectFriendIndex = -1,
  _slotRows = 12
}
function FriendRequestList:SetShow(isShow)
  self._ui._backGround:SetShow(isShow)
end
function FriendRequestList:Initialize()
  self._ui._listBox = UI.getChildControl(self._ui._backGround, "Listbox_RequestFriend")
  self._ui._btnClose = UI.getChildControl(self._ui._backGround, "RequestFriend_Close")
  self._ui._btnAccept = UI.getChildControl(self._ui._backGround, "Button_Accept")
  self._ui._btnRefuse = UI.getChildControl(self._ui._backGround, "Button_Refuse")
  self._ui._partLine = UI.getChildControl(self._ui._backGround, "Static_RequestFriendPartLine")
  self._ui._titleName = UI.getChildControl(self._ui._backGround, "StaticText_RequestFriendName")
  self._ui._scroll = UI.getChildControl(self._ui._listBox, "RequestFriend_Scroll")
  self._ui._scroll:SetControlTop()
  self._ui._listBox:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:ClickRequestList()")
  self._ui._btnClose:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:HideRequestList()")
  self._ui._btnAccept:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:AcceptRequest()")
  self._ui._btnRefuse:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:RefuseRequest()")
  self:SetShow(false)
end
function FriendRequestList:UpdateList()
  local listControl = self._ui._listBox
  listControl:DeleteAll()
  local friendCount = ToClient_GetAddFriendCount()
  for friendIndex = 0, friendCount - 1 do
    local addFriendInfo = ToClient_GetAddFriendAt(friendIndex)
    listControl:AddItemWithLineFeed(addFriendInfo:getName(), Defines.Color.C_FFC4BEBE)
  end
  UIScroll.SetButtonSize(self._ui._scroll, self._slotRows, friendCount)
  if friendCount > 0 then
    self:SetShow(true)
  end
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    FGlobal_NewFriendAlertOff()
  end
end
function FriendRequestList:Show()
  self._selectFriendIndex = -1
  self:SetShow(true)
  ToClient_GetAddFriendList()
  self:UpdateList()
end
function FriendRequestList:Hide()
  self:SetShow(false)
end
function PaGlobal_FriendList:ClickRequestButton()
  if FriendRequestList._ui._backGround:GetShow() then
    FriendRequestList:Hide()
  else
    FriendRequestList:Show()
  end
end
function PaGlobal_FriendList:AcceptRequest()
  if ToClient_isAddFriendAllowed() then
    if -1 ~= FriendRequestList._selectFriendIndex then
      ToClient_AcceptFriend(FriendRequestList._selectFriendIndex)
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
function PaGlobal_FriendList:RefuseRequest()
  if -1 ~= FriendRequestList._selectFriendIndex then
    ToClient_RefuseFriend(FriendRequestList._selectFriendIndex)
  end
end
function PaGlobal_FriendList:ClickRequestList()
  FriendRequestList._selectFriendIndex = FriendRequestList._ui._listBox:GetSelectIndex()
end
function PaGlobal_FriendList:HideRequestList()
  FriendRequestList:Hide()
end
function FromClient_UpdateFriendRequestList()
  FriendRequestList:UpdateList()
end
FriendRequestList:Initialize()
local PopupAddFriend = {
  _ui = {
    _backGround = UI.getChildControl(Panel_FriendList, "Static_FriendName_BG"),
    _editName = nil,
    _btnConfirm = nil,
    _btnCancel = nil,
    _btnClose = nil,
    _staticTitle = nil,
    _checkUserNickName = nil
  }
}
function PopupAddFriend:SetShow(isShow)
  self._ui._backGround:SetShow(isShow)
  if isShow then
    SetFocusEdit(self._ui._editName)
    self._ui._editName:SetMaxInput(getGameServiceTypeUserNickNameLength())
  else
    CheckChattingInput()
  end
  self._ui._editName:SetEditText("", true)
end
function PopupAddFriend:Initialize()
  self._ui._editName = UI.getChildControl(self._ui._backGround, "Edit_FriendName")
  self._ui._btnConfirm = UI.getChildControl(self._ui._backGround, "Button_AddFriend_Confirm")
  self._ui._btnCancel = UI.getChildControl(self._ui._backGround, "Button_AddFriend_Cancel")
  self._ui._btnClose = UI.getChildControl(self._ui._backGround, "Button_AddFriend_Close")
  self._ui._staticTitle = UI.getChildControl(self._ui._backGround, "StaticText_AddFriend")
  self._ui._checkUserNickName = UI.getChildControl(self._ui._backGround, "CheckButton_IsUserNickName")
  self._ui._btnConfirm:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:AddFriend()")
  self._ui._btnCancel:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:CloseAddFriendPopup()")
  self._ui._btnClose:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:CloseAddFriendPopup()")
  self._ui._checkUserNickName:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:ChangeNickNameMode()")
  self._ui._checkUserNickName:SetCheck(true)
  self._ui._checkUserNickName:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_BTN_NICKNAME"))
  self._ui._editName:RegistReturnKeyEvent("PaGlobal_FriendList:AddFriend()")
  self:SetShow(false)
  PaGlobal_FriendList:ChangeNickNameMode()
end
function PaGlobal_FriendList:ClickAddFriendButton()
  if PopupAddFriend._ui._backGround:GetShow() then
    PopupAddFriend:SetShow(false)
  else
    PopupAddFriend:SetShow(true)
  end
end
function PaGlobal_FriendList:AddFriend()
  local isNickName = PopupAddFriend._ui._checkUserNickName:IsCheck()
  ToClient_AddFriend(PopupAddFriend._ui._editName:GetEditText(), isNickName)
  PopupAddFriend:SetShow(false)
  ClearFocusEdit()
end
function PaGlobal_FriendList:CloseAddFriendPopup()
  PopupAddFriend:SetShow(false)
  ClearFocusEdit()
end
function PaGlobal_FriendList:ChangeInputMode()
end
function PaGlobal_FriendList:ChangeNickNameMode()
  local isNickName = not PopupAddFriend._ui._checkUserNickName:IsCheck()
  if isNickName then
    PopupAddFriend._ui._checkUserNickName:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_BTN_NICKNAME"))
  else
    PopupAddFriend._ui._checkUserNickName:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_BTN_CHARACTERNAME"))
  end
end
function FGlobal_FriendList_AddFriendPopupClose()
  PopupAddFriend:SetShow(false)
  ClearFocusEdit()
end
function FGlobal_FriendList_CheckUiEdit(targetUI)
  return nil ~= targetUI and targetUI:GetKey() == PopupAddFriend._ui._editName:GetKey()
end
PopupAddFriend:Initialize()
local PopupRenameGroup = {
  _ui = {
    _backGround = UI.getChildControl(Panel_FriendList, "Static_GroupName_BG"),
    _editName = nil,
    _btnConfirm = nil,
    _btnCancel = nil,
    _btnClose = nil,
    _staticTitle = nil
  }
}
function PopupRenameGroup:SetShow(isShow)
  self._isShow = isShow
  self._ui._backGround:SetShow(isShow)
  if false == isShow then
    CheckChattingInput()
  end
  self._ui._editName:SetEditText("", true)
end
function PopupRenameGroup:Initialize()
  self._ui._editName = UI.getChildControl(self._ui._backGround, "Edit_GroupName")
  self._ui._btnConfirm = UI.getChildControl(self._ui._backGround, "Button_GroupName_Confirm")
  self._ui._btnCancel = UI.getChildControl(self._ui._backGround, "Button_GroupName_Cancel")
  self._ui._btnClose = UI.getChildControl(self._ui._backGround, "Button_GroupName_Close")
  self._ui._staticTitle = UI.getChildControl(self._ui._backGround, "StaticText_ChangeGroupName")
  self._ui._btnConfirm:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:PopupRenameGroup()")
  self._ui._btnCancel:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:ClosePopupRenameGroup()")
  self._ui._btnClose:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:ClosePopupRenameGroup()")
  self._ui._editName:SetMaxInput(getGameServiceTypeUserNickNameLength())
  self:SetShow(false)
end
function PaGlobal_FriendList:PopupRenameGroup()
  if 0 <= self._groupData._selectedIndex then
    local friendGroup = self._groupData._info[self._groupData._selectedIndex]
    if PopupRenameGroup._ui._editName:GetEditText() == friendGroup:getName() then
      return
    end
    _PA_LOG("YHG", tostring(PopupRenameGroup._ui._editName:GetEditText()))
    _PA_LOG("YHG", tostring(""))
    if nil == PopupRenameGroup._ui._editName:GetEditText() then
      _PA_LOG("YHG", tostring(nil))
      return
    end
    ToClient_RenameGroup(self._groupData._info[self._groupData._selectedIndex]:getGroupNo(), PopupRenameGroup._ui._editName:GetEditText())
  end
  PopupRenameGroup:SetShow(false)
end
function PaGlobal_FriendList:ClosePopupRenameGroup()
  PopupRenameGroup:SetShow(false)
end
PopupRenameGroup:Initialize()
local styleMenuButton = UI.getChildControl(Panel_FriendList, "Style_Function")
styleMenuButton:SetShow(false)
local PopupGroupMenu = {
  _ui = {
    _backGround,
    _renameGroup,
    _addGroup
  }
}
function PopupGroupMenu:Initialize()
  local stylePopupBackGround = UI.getChildControl(Panel_FriendList, "Static_Function_BG")
  stylePopupBackGround:SetShow(false)
  self._ui._backGround = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_FriendList, "FriendPopupGroupMenu")
  self._ui._renameGroup = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._ui._backGround, "FriendPopupRenameGroup")
  self._ui._addGroup = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._ui._backGround, "FriendPopupAddGroup")
  CopyBaseProperty(styleMenuButton, self._ui._renameGroup)
  CopyBaseProperty(stylePopupBackGround, self._ui._backGround)
  CopyBaseProperty(styleMenuButton, self._ui._addGroup)
  local buttonSizeX = styleMenuButton:GetSizeX()
  local buttonSizeY = styleMenuButton:GetSizeY()
  self._ui._backGround:SetSize(buttonSizeX, buttonSizeY * 2)
  self._ui._renameGroup:SetPosX(0)
  self._ui._renameGroup:SetPosY(0)
  self._ui._addGroup:SetPosX(0)
  self._ui._addGroup:SetPosY(buttonSizeY)
  self._ui._renameGroup:SetShow(true)
  self._ui._addGroup:SetShow(true)
  self._ui._renameGroup:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_RENAME"))
  self._ui._addGroup:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_ADD_GROUP"))
  self._ui._renameGroup:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:RenameFriendGroup()")
  self._ui._addGroup:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:AddFriendGroup()")
  self._ui._backGround:SetShow(false)
end
function PopupGroupMenu:SetShow(isShow)
  local groupEtc = 0
  if groupEtc == PaGlobal_FriendList._groupData._selectedIndex then
    self._ui._renameGroup:SetEnable(false)
    self._ui._renameGroup:SetMonoTone(true)
    self._ui._renameGroup:SetIgnore(true)
  else
    self._ui._renameGroup:SetEnable(true)
    self._ui._renameGroup:SetMonoTone(false)
    self._ui._renameGroup:SetIgnore(false)
  end
  self._ui._addGroup:SetEnable(true)
  self._ui._addGroup:SetIgnore(false)
  self._ui._backGround:SetShow(isShow)
  PaGlobal_FriendList._groupData._isMenuShow = isShow
end
function PopupGroupMenu:SetPos(x, y)
  self._ui._backGround:SetPosX(x)
  self._ui._backGround:SetPosY(y)
end
PopupGroupMenu:Initialize()
local PopupFriendMenu = {
  _ui = {
    _backGround,
    _partyInvite,
    _messanger,
    _moveGroup,
    _delete
  }
}
function PopupFriendMenu:Initialize()
  self._ui._backGround = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_FriendList, "FriendPopupFriendMenu")
  self._ui._partyInvite = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._ui._backGround, "FriendPopupPartyInvite")
  self._ui._messanger = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._ui._backGround, "FriendPopupWhisper")
  self._ui._moveGroup = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._ui._backGround, "FriendPopupMoveGroup")
  self._ui._delete = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._ui._backGround, "FriendPopupDeleteFriend")
  CopyBaseProperty(styleMenuButton, self._ui._partyInvite)
  CopyBaseProperty(styleMenuButton, self._ui._messanger)
  CopyBaseProperty(styleMenuButton, self._ui._moveGroup)
  CopyBaseProperty(styleMenuButton, self._ui._delete)
  local buttonSizeX = styleMenuButton:GetSizeX()
  local buttonSizeY = styleMenuButton:GetSizeY()
  self._ui._backGround:SetSize(buttonSizeX, buttonSizeY * 2)
  self._ui._partyInvite:SetPosX(0)
  self._ui._partyInvite:SetPosY(0)
  self._ui._messanger:SetPosX(0)
  self._ui._messanger:SetPosY(buttonSizeY)
  self._ui._moveGroup:SetPosX(0)
  self._ui._moveGroup:SetPosY(buttonSizeY * 2)
  self._ui._delete:SetPosX(0)
  self._ui._delete:SetPosY(buttonSizeY * 3)
  self._ui._partyInvite:SetShow(true)
  self._ui._messanger:SetShow(true)
  self._ui._moveGroup:SetShow(true)
  self._ui._delete:SetShow(true)
  self._ui._partyInvite:SetText(PAGetString(Defines.StringSheet_GAME, "INTERACTION_MENU3"))
  self._ui._messanger:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_WHISPER"))
  self._ui._moveGroup:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_CHANGE_GROUP"))
  self._ui._delete:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_REMOVE_FRIEND"))
  self._ui._partyInvite:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:PartyInvite()")
  self._ui._messanger:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:OpenMessanger()")
  self._ui._moveGroup:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:GroupMoveList()")
  self._ui._delete:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:DeleteFriend()")
  self._ui._backGround:SetShow(false)
end
function PopupFriendMenu:SetShow(isShow)
  if isShow then
    local isOnline = PaGlobal_FriendList._friendData._info[PaGlobal_FriendList._friendData._selectedIndex]:isOnline()
    local isMessage = ToClient_IsMessageList(PaGlobal_FriendList._friendData._info[PaGlobal_FriendList._friendData._selectedIndex]:getUserNo())
    if false == isOnline and false == isMessage then
      self._ui._messanger:SetEnable(false)
      self._ui._messanger:SetMonoTone(true)
      self._ui._messanger:SetIgnore(true)
    else
      self._ui._messanger:SetEnable(true)
      self._ui._messanger:SetMonoTone(false)
      self._ui._messanger:SetIgnore(false)
    end
  end
  self._ui._backGround:SetShow(isShow)
  PaGlobal_FriendList._friendData._isMenuShow = isShow
end
function PopupFriendMenu:SetPos(x, y)
  self._ui._backGround:SetPosX(x)
  self._ui._backGround:SetPosY(y)
end
PopupFriendMenu:Initialize()
local PopupGroupList = {
  _ui = {
    _backGround,
    _moveGroups = {}
  }
}
function PopupGroupList:Initialize()
  self._ui._backGround = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_FriendList, "FriendPopupGroupList")
  for groupIndex = 0, PaGlobal_FriendList._groupData._maxCount - 1 do
    self._ui._moveGroups[groupIndex] = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._ui._backGround, "FriendPopupMoveGroups_" .. groupIndex)
    CopyBaseProperty(styleMenuButton, self._ui._moveGroups[groupIndex])
    local buttonSizeY = styleMenuButton:GetSizeY()
    self._ui._moveGroups[groupIndex]:SetSize(styleMenuButton:GetSizeX() + styleMenuButton:GetSizeX() / 3, styleMenuButton:GetSizeY())
    self._ui._moveGroups[groupIndex]:SetPosX(0)
    self._ui._moveGroups[groupIndex]:SetPosY(buttonSizeY * groupIndex)
    self._ui._moveGroups[groupIndex]:addInputEvent("Mouse_LUp", "PaGlobal_FriendList:MoveGroup(" .. groupIndex .. ")")
  end
  self._ui._backGround:SetShow(false)
end
function PopupGroupList:UpdateGroups()
  for index = 0, PaGlobal_FriendList._groupData._maxCount - 1 do
    self._ui._moveGroups[index]:SetShow(false)
  end
  self._ui._backGround:SetSize(styleMenuButton:GetSizeX(), styleMenuButton:GetSizeY() * PaGlobal_FriendList._groupData._count)
  for groupIndex = 0, PaGlobal_FriendList._groupData._count - 1 do
    local groupName = PaGlobal_FriendList._groupData._infoByIndex[groupIndex]:getName()
    if groupName == "" then
      self._ui._moveGroups[groupIndex]:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_GROUP_ETC"))
    else
      self._ui._moveGroups[groupIndex]:SetText(groupName)
    end
    self._ui._moveGroups[groupIndex]:SetShow(true)
  end
end
function PopupGroupList:SetShow(isShow)
  self._ui._backGround:SetShow(isShow)
  if isShow then
    PopupGroupList:UpdateGroups()
  end
end
function PopupGroupList:SetPos(x, y)
  self._ui._backGround:SetPosX(x)
  self._ui._backGround:SetPosY(y)
end
PopupGroupList:Initialize()
function PaGlobal_FriendList:RenameFriendGroup()
  PopupRenameGroup:SetShow(true)
  PopupGroupMenu:SetShow(false)
end
function PaGlobal_FriendList:AddFriendGroup()
  ToClient_AddFriendGroup(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_NEW_GROUPNAME"))
  PopupGroupMenu:SetShow(false)
end
function PaGlobal_FriendList:ClickFriendList(isRUp)
  self._ui._treeFriend:SetSelectItemMousePoint()
  local friendIndex = self._ui._treeFriend:GetSelectItem()
  if nil == friendIndex then
    return
  end
  if isRUp then
    if CppEnums.TreeItemType.PA_TREE_ITEM_ROOT == friendIndex:GetType() then
      self._groupData._selectedIndex = friendIndex:GetIndex()
      PopupFriendMenu:SetShow(false)
      PopupGroupMenu:SetShow(true)
      PopupGroupMenu:SetPos(getMousePosX() - Panel_FriendList:GetPosX(), getMousePosY() - Panel_FriendList:GetPosY())
    else
      self._friendData._selectedIndex = friendIndex:GetIndex()
      PopupGroupMenu:SetShow(false)
      PopupFriendMenu:SetShow(true)
      PopupFriendMenu:SetPos(getMousePosX() - Panel_FriendList:GetPosX(), getMousePosY() - Panel_FriendList:GetPosY())
    end
    PopupGroupList:SetShow(false)
  elseif self._friendData._isMenuShow or self._groupData._isMenuShow then
    self:ClosePopupMenu()
  elseif CppEnums.TreeItemType.PA_TREE_ITEM_ROOT == friendIndex:GetType() then
  else
    self._friendData._selectedIndex = friendIndex:GetIndex()
    if 1 == self._friendData._info[self._friendData._selectedIndex]:getFriendType() then
    else
      self._friendData._selectedIndex = friendIndex:GetIndex()
      self:OpenMessanger()
    end
  end
end
function PaGlobal_FriendList:PartyInvite()
  local userCharacterName = PaGlobal_FriendList._friendData._info[PaGlobal_FriendList._friendData._selectedIndex]:getCharacterName()
  local isOnline = PaGlobal_FriendList._friendData._info[PaGlobal_FriendList._friendData._selectedIndex]:isOnline()
  local isSelfPlayerPlayingPvPMatch = getSelfPlayer():isDefinedPvPMatch()
  if isSelectFriendBlocked() then
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
function PaGlobal_FriendList:OpenMessanger()
  if ToClient_isAddFriendAllowed() then
    local selectedUser = self._friendData._info[self._friendData._selectedIndex]
    ToClient_OpenMessanger(selectedUser:getUserNo(), selectedUser:getName(), selectedUser:isOnline())
    PopupFriendMenu:SetShow(false)
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
function PaGlobal_FriendList:GroupMoveList()
  PopupGroupList:SetShow(true)
  PopupGroupList:SetPos(PopupFriendMenu._ui._backGround:GetPosX() + PopupFriendMenu._ui._backGround:GetSizeX(), PopupFriendMenu._ui._backGround:GetPosY())
end
function PaGlobal_FriendList:DeleteFriend()
  ToClient_DeleteFriend(self._friendData._info[self._friendData._selectedIndex]:getUserNo())
  PopupFriendMenu:SetShow(false)
end
function PaGlobal_FriendList:MoveGroup(groupIndex)
  ToClient_MoveGroup(self._friendData._info[self._friendData._selectedIndex]:getUserNo(), self._groupData._infoByIndex[groupIndex]:getGroupNo())
  PopupFriendMenu:SetShow(false)
  PopupGroupList:SetShow(false)
end
function PaGlobal_FriendList:Show()
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    local friendsBTN = UI.getChildControl(Panel_UIMain, "Button_FriendList")
    friendsBTN:EraseAllEffect()
  end
  FGlobal_NewMessage_Close()
  ToClient_updateAddFriendAllowed()
  Panel_FriendList:SetShow(true, true)
end
function PaGlobal_FriendList:Hide()
  self:ClosePopupMenu(false)
  PopupAddFriend:SetShow(false)
  FriendRequestList:SetShow(false)
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  Panel_FriendList:SetShow(false, true)
end
function PaGlobal_FriendList:ShowAni()
  ToClient_GetFriendList()
  ToClient_GetAddFriendList()
  self:UpdateList()
  FriendRequestList:UpdateList()
  UIAni.AlphaAnimation(1, Panel_FriendList, 0, 0.15)
  local aniInfo1 = Panel_FriendList:addScaleAnimation(0, 0.08, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_FriendList:GetSizeX() / 2
  aniInfo1.AxisY = Panel_FriendList:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_FriendList:addScaleAnimation(0.08, 0.15, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_FriendList:GetSizeX() / 2
  aniInfo2.AxisY = Panel_FriendList:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function PaGlobal_FriendList:HideAni()
  local aniInfo = UIAni.AlphaAnimation(0, Panel_FriendList, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
function PaGlobal_FriendList:ClosePopupMenu()
  PopupFriendMenu:SetShow(false)
  PopupGroupMenu:SetShow(false)
  PopupGroupList:SetShow(false)
end
function FGlobal_FriendList_Show()
  PaGlobal_FriendList:Show()
end
function FGlobal_FriendList_Hide()
  PaGlobal_FriendList:Hide()
end
function FromClient_OnScreenResize_FriendList()
  Panel_FriendList:SetPosX(getScreenSizeX() - Panel_FriendList:GetSizeX())
  Panel_FriendList:SetPosY(getScreenSizeY() / 2 - Panel_FriendList:GetSizeY() / 2)
end
registerEvent("FromClient_UpdateFriendList", "FromClient_UpdateFriendList")
registerEvent("FromClient_NoticeNewMessage", "FromClient_NoticeNewMessage")
registerEvent("FromClient_UpdateFriendRequestList", "FromClient_UpdateFriendRequestList")
registerEvent("onScreenResize", "FromClient_OnScreenResize_FriendList")

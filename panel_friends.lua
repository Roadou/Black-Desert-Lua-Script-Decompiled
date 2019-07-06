Panel_FriendList:SetShow(false, false)
Panel_FriendList:setMaskingChild(true)
Panel_FriendList:ActiveMouseEventEffect(true)
Panel_FriendList:setGlassBackground(true)
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local IM = CppEnums.EProcessorInputMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
Panel_FriendList:RegisterShowEventFunc(true, "FriendList_showAni()")
Panel_FriendList:RegisterShowEventFunc(false, "FriendList_hideAni()")
local _groupListData = {
  _defaultGroupIndex = -1,
  _partyplayGroupIndex = -1,
  _selectedGroupIndex = -1,
  _uiGroups = {},
  _groupInfo = {},
  _groupInfoByGroupIndex = {},
  _groupCount = 0
}
function _groupListData:clear()
  _defaultGroupIndex = -1
  _partyplayGroupIndex = -1
  self._selectedGroupIndex = -1
  self._uiGroups = {}
  self._groupInfo = {}
  self._groupCount = 0
end
local _friendListData = {
  _selectedFriendIndex = -1,
  _uiFriends = {},
  _friendInfo = {}
}
function _friendListData:clear()
  self._selectedFriendIndex = -1
  self._uiFriends = {}
  self._friendInfo = {}
end
local FriendMessangerManager = {
  _currentFocusId = -1,
  _messangerList = {}
}
function FriendMessangerManager:createMessanger(messangerId, userName, isOnline)
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
    UI.deletePanel(self._mainPanel:GetID())
    self._mainPanel = nil
  end
  function messanger:createPanel(messangerId, isOnline)
    local newName = "Panel_FriendMessanger" .. messangerId
    messanger._mainPanel = UI.createPanel(newName, Defines.UIGroup.PAGameUIGroup_WorldMap_Popups)
    CopyBaseProperty(Panel_Friend_Messanger, messanger._mainPanel)
    messanger._mainPanel:SetDragAll(true)
    messanger._mainPanel:SetShow(true)
    messanger._mainPanel:addInputEvent("Mouse_UpScroll", "FriendMessanger_OnMouseWheel( " .. messangerId .. ", true )")
    messanger._mainPanel:addInputEvent("Mouse_DownScroll", "FriendMessanger_OnMouseWheel( " .. messangerId .. ", false )")
  end
  function messanger:prepareControl(messangerId, userName, isOnline)
    self._uiClose = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_Friend_Messanger, self._mainPanel, "Button_Close", 0)
    self._uiClose:addInputEvent("Mouse_LUp", "FriendMessanger_Close(" .. messangerId .. ")")
    self._uiFrame = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_FRAME, Panel_Friend_Messanger, self._mainPanel, "Frame_1", 0)
    self._uiFrameScroll = self._uiFrame:GetVScroll()
    local styleFrame = UI.getChildControl(Panel_Friend_Messanger, "Frame_1")
    local styleScroll = UI.getChildControl(styleFrame, "Frame_1_VerticalScroll")
    CopyBaseProperty(styleScroll, self._uiFrameScroll)
    self._uiFrameContent = self._uiFrame:GetFrameContent()
    self._uiEnter = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_Friend_Messanger, self._mainPanel, "Button_Enter", 0)
    self._uiEnter:addInputEvent("Mouse_LUp", "friend_sendMessage(" .. messangerId .. ")")
    self._uiEditInputChat = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_EDIT, Panel_Friend_Messanger, self._mainPanel, "Edit_InputChat", 0)
    self._uiEditInputChat:SetMaxInput(100)
    if isOnline then
      self._uiEditInputChat:addInputEvent("Mouse_LUp", "FriendMessanger_SetFocusEdit(" .. messangerId .. ")")
      self._uiEditInputChat:RegistReturnKeyEvent("friend_sendMessageByKey()")
      self._uiEditInputChat:SetEnable(true)
      self._uiEnter:SetEnable(true)
    else
      self._uiEditInputChat:SetEnable(false)
      self._uiEnter:SetEnable(false)
    end
    self._uiStaticTitle = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Friend_Messanger, self._mainPanel, "StaticText_TitleName", 0)
    self._uiStaticTitle:SetText(userName)
    self._uiStaticTitleImg = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Friend_Messanger, self._mainPanel, "Static_TitleImage", 0)
    self._uiSizeControl = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_Friend_Messanger, self._mainPanel, "Button_SizeControl", 0)
    self._uiSizeControl:addInputEvent("Mouse_LDown", "FriendMessanger_ResizeStartPos( " .. messangerId .. " )")
    self._uiSizeControl:addInputEvent("Mouse_LPress", "FriendMessanger_Resize( " .. messangerId .. " )")
    self._uiCall = messanger:createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_Friend_Messanger, self._mainPanel, "Button_Call", 0)
    self._uiSlider = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_SLIDER, self._mainPanel, "Slider_Alpha")
    self._uiSliderButton = self._uiSlider:GetControlButton()
    local style = UI.getChildControl(Panel_Friend_Messanger, "Slider_Alpha")
    CopyBaseProperty(style, self._uiSlider)
    self._uiSlider:SetInterval(100)
    self._uiSliderButton:addInputEvent("Mouse_LPress", "FriendMessanger_AlphaSlider( " .. messangerId .. ")")
    self._uiSlider:addInputEvent("Mouse_LUp", "FriendMessanger_AlphaSlider( " .. messangerId .. ")")
    self._uiSlider:SetControlPos(100)
    messanger:setShowCallBtn()
  end
  function messanger:setShowCallBtn()
    self._uiCall:SetShow(self._isCallShow)
    local computeValue = 0
    if false == self._isCallShow then
      computeValue = 20
    end
    self._uiSlider:SetPosX(self._mainPanel:GetSizeX() - 102 + computeValue)
  end
  function messanger:createControl(controlType, parentStyleControl, parentControl, controlName, index)
    local styleControl = UI.getChildControl(parentStyleControl, controlName)
    local control = UI.createControl(controlType, parentControl, controlName .. index)
    CopyBaseProperty(styleControl, control)
    return control
  end
  function messanger:clearAllMessage()
    for index = 0, self._messageCount - 1 do
      self._uiStaticText[index]:SetShow(false)
      self._uiStaticBg[index]:SetShow(false)
      UI.deleteControl(self._uiStaticText[index])
      UI.deleteControl(self._uiStaticBg[index])
    end
    self._messageCount = 0
  end
  function messanger:updateMessage(chattingMessage)
    local msg = chattingMessage:getContent()
    local isMe = chattingMessage.isMe
    messanger:showMessage(isMe, msg)
    self._messageCount = self._messageCount + 1
  end
  function messanger:showMessage(isMe, msg)
    messanger:createMessageUI(isMe)
    messanger:resizeMessageUI(msg)
    messanger:setPosMessageUI(isMe)
  end
  function messanger:resizeMessageUI(msg)
    local panelSizeX = self._mainPanel:GetSizeX()
    local maxTextSizeX = panelSizeX - 100
    local staticText = self._uiStaticText[self._messageCount]
    local staticBg = self._uiStaticBg[self._messageCount]
    staticText:SetSize(maxTextSizeX, staticText:GetSizeY())
    staticText:SetAutoResize(true)
    staticText:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    staticText:SetText(msg)
    local textSizeX = maxTextSizeX
    local textSizeX = math.min(staticText:GetTextSizeX(), maxTextSizeX)
    textSizeX = math.max(12, textSizeX)
    staticBg:SetSize(textSizeX + 13, staticText:GetSizeY() + 13)
    staticBg:SetAlpha(self._messangerAlpha)
    staticText:SetFontAlpha(self._messangerAlpha)
  end
  function messanger:createMessageUI(isMe)
    local styleBg = UI.getChildControl(Panel_Friend_Messanger, "Static_To")
    local styleText = UI.getChildControl(Panel_Friend_Messanger, "StaticText_To")
    if false == isMe then
      styleBg = UI.getChildControl(Panel_Friend_Messanger, "Static_From")
      styleText = UI.getChildControl(Panel_Friend_Messanger, "StaticText_From")
    end
    self._uiStaticBg[self._messageCount] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._uiFrameContent, "Static_BG_" .. self._messageCount)
    self._uiStaticText[self._messageCount] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._uiFrameContent, "Static_Text_" .. self._messageCount)
    CopyBaseProperty(styleBg, self._uiStaticBg[self._messageCount])
    CopyBaseProperty(styleText, self._uiStaticText[self._messageCount])
    self._uiStaticBg[self._messageCount]:SetShow(true)
    self._uiStaticText[self._messageCount]:SetIgnore(true)
    self._uiStaticText[self._messageCount]:SetShow(true)
  end
  function messanger:setPosMessageUI(isMe)
    local prevBgPosY = 0
    local prevBgSizeY = 0
    if 0 < self._messageCount then
      prevBgPosY = self._uiStaticBg[self._messageCount - 1]:GetPosY()
      prevBgSizeY = self._uiStaticBg[self._messageCount - 1]:GetSizeY()
    end
    local bgPosX = 12
    if isMe then
      bgPosX = messanger._mainPanel:GetSizeX() - self._uiStaticBg[self._messageCount]:GetSizeX() - 14
      self._uiStaticText[self._messageCount]:SetPosX(self._uiStaticText[self._messageCount]:GetPosX() - 13)
    end
    self._uiStaticBg[self._messageCount]:SetPosX(bgPosX)
    self._uiStaticBg[self._messageCount]:SetPosY(prevBgPosY + prevBgSizeY + 5)
    self._uiStaticText[self._messageCount]:SetPosY(self._uiStaticBg[self._messageCount]:GetPosY() + 1)
  end
  messanger:initialize(messangerId, userName, isOnline)
  return messanger
end
function FriendMessanger_AlphaSlider(messangerId)
  local messanger = FriendMessangerManager._messangerList[messangerId]
  local panel = FriendMessangerManager._messangerList[messangerId]._mainPanel
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
  local panel = FriendMessangerManager._messangerList[messangerId]._mainPanel
  orgMouseX = getMousePosX()
  orgMouseY = getMousePosY()
  orgPanelPosX = panel:GetPosX()
  orgPanelSizeX = panel:GetSizeX()
  orgPanelSizeY = panel:GetSizeY()
end
function FriendMessanger_Resize(messangerId)
  local messanger = FriendMessangerManager._messangerList[messangerId]
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
  messanger._uiCall:SetPosX(panel:GetSizeX() - 41)
  messanger._uiSlider:SetPosX(panel:GetSizeX() - 102)
  messanger:setShowCallBtn()
  FromClient_FriendListUpdateMessanger(messangerId)
end
function FriendMessanger_OnMouseWheel(messangerId, isUp)
  local messanger = FriendMessangerManager._messangerList[messangerId]
  local targetScroll = messanger._uiFrameScroll
  if isUp then
    targetScroll:ControlButtonUp()
  else
    targetScroll:ControlButtonDown()
  end
  messanger._uiFrame:UpdateContentPos()
end
function FriendMessanger_CheckCurrentUiEdit(targetUI)
  if -1 == FriendMessangerManager._currentFocusId then
    return false
  end
  local currentEdit = FriendMessangerManager._messangerList[FriendMessangerManager._currentFocusId]._uiEditInputChat
  return nil ~= targetUI and targetUI:GetKey() == currentEdit:GetKey()
end
function FriendMessanger_Close(messangerId)
  local messanger = FriendMessangerManager._messangerList[messangerId]
  ToClient_FriendListCloseMessanger(messangerId)
  messanger:clear()
  FriendMessangerManager._messangerList[messangerId] = nil
  if messangerId == FriendMessangerManager._currentFocusId then
    FriendMessangerManager._currentFocusId = -1
    ClearFocusEdit()
  end
  CheckChattingInput()
end
function FriendMessanger_SetFocusEdit(messangerId)
  local messanger = FriendMessangerManager._messangerList[messangerId]
  SetFocusEdit(messanger._uiEditInputChat)
  FriendMessangerManager._currentFocusId = messangerId
end
function FriendMessanger_KillFocusEdit()
  if -1 == FriendMessangerManager._currentFocusId then
    return false
  end
  ClearFocusEdit()
  CheckChattingInput()
  FriendMessangerManager._currentFocusId = -1
  return false
end
function friend_sendMessageByKey()
  friend_sendMessage(FriendMessangerManager._currentFocusId)
end
function friend_killFocusMessangerByKey()
  FriendMessanger_KillFocusEdit()
end
function friend_sendMessage(messangerId)
  local messanger = FriendMessangerManager._messangerList[messangerId]
  local rv = chatting_sendMessageByUserNo(RequestFriendList_GetMessageListById(messangerId):getUserNo(), messanger._uiEditInputChat:GetEditText(), CppEnums.ChatType.Friend)
  if 0 == rv then
    RequestFriendList_GetMessageListById(messangerId):pushFromMessage(messanger._uiEditInputChat:GetEditText())
  end
  messanger._uiEditInputChat:SetEditText("", true)
end
function FromClient_FriendListUpdateMessanger(messangerId)
  local friendMesaageList = RequestFriendList_GetMessageListById(messangerId)
  local message = friendMesaageList:beginMessage()
  local messanger = FriendMessangerManager._messangerList[messangerId]
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
  if nil == FriendMessangerManager._messangerList[messangerId] then
    FriendMessangerManager._messangerList[messangerId] = FriendMessangerManager:createMessanger(messangerId, userName, isOnline)
  end
  if isOnline then
    FriendMessanger_SetFocusEdit(messangerId)
  end
  FromClient_FriendListUpdateMessanger(messangerId)
end
function FromClient_FriendListUpdateLogOnOffForMessanger(messangerId, isOnline)
  local messanger = FriendMessangerManager._messangerList[messangerId]
  if messangerId == FriendMessangerManager._currentFocusId and -1 ~= messangerId then
    FriendMessangerManager._currentFocusId = -1
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
local styleFriendGroup = UI.getChildControl(Panel_FriendList, "Style_FriendGroup")
local styleFriendGroupName = UI.getChildControl(Panel_FriendList, "StyleGroupName")
local styleName = UI.getChildControl(Panel_FriendList, "Style_Name")
local friendsBTN
if false == _ContentsGroup_RemasterUI_Main_Alert then
  friendsBTN = UI.getChildControl(Panel_UIMain, "Button_FriendList")
end
styleFriendGroup:SetShow(false)
styleFriendGroupName:SetShow(false)
styleFriendGroupName:SetIgnore(false)
styleName:SetShow(false)
styleName:SetIgnore(false)
local FriendList = {
  _mainPanel = Panel_FriendList,
  _maxGroupCount = 5,
  _maxFriendCount = 50,
  _uiClose = UI.getChildControl(Panel_FriendList, "Button_Close"),
  _buttonRefresh = UI.getChildControl(Panel_FriendList, "Button_Refresh"),
  _buttonQuestion = UI.getChildControl(Panel_FriendList, "Button_Question"),
  _checkButtonSound = UI.getChildControl(Panel_FriendList, "CheckButton_Sound"),
  _checkButtonEffect = UI.getChildControl(Panel_FriendList, "CheckButton_Effect"),
  _uiTreeFriend = UI.getChildControl(Panel_FriendList, "Tree_Friend"),
  _uiTreeFriendBackStatic = nil,
  _uiTreeFriendOverStatic = nil,
  _uiTreeFriendScroll = nil,
  _isFriendMenuShow = false,
  _isGroupMenuShow = false
}
function FriendList:initialize()
  self._uiTreeFriendBackStatic = UI.getChildControl(self._uiTreeFriend, "Tree_Friend_BackStatic")
  self._uiTreeFriendOverStatic = UI.getChildControl(self._uiTreeFriend, "Tree_Friend_OverStatic")
  self._uiTreeFriendScroll = UI.getChildControl(self._uiTreeFriend, "Tree_Friend_Scroll")
  self._uiClose:addInputEvent("Mouse_LUp", "Friend_CloseWindow()")
  self._buttonRefresh:SetShow(false)
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelFriends\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelFriends\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelFriends\", \"false\")")
  self._checkButtonSound:addInputEvent("Mouse_LUp", "ToClient_RequestToggleSoundNotice()")
  self._checkButtonEffect:addInputEvent("Mouse_LUp", "ToClient_RequestToggleEffectNotice()")
  self._checkButtonSound:SetEnableArea(0, 0, self._checkButtonSound:GetSizeX() + self._checkButtonSound:GetTextSizeX() + 10, self._checkButtonSound:GetSizeY())
  self._checkButtonEffect:SetEnableArea(0, 0, self._checkButtonEffect:GetSizeX() + self._checkButtonEffect:GetTextSizeX() + 10, self._checkButtonEffect:GetSizeY())
  self._uiTreeFriend:addInputEvent("Mouse_RUp", "clickFriendList(true)")
  self._uiTreeFriend:addInputEvent("Mouse_LUp", "clickFriendList(false)")
  self._uiTreeFriend:addInputEvent("Mouse_UpScroll", "friend_closeFriendMenu()")
  self._uiTreeFriend:addInputEvent("Mouse_DownScroll", "friend_closeFriendMenu()")
  local ySize = self._uiTreeFriend:GetSizeY() - 20
  self._uiTreeFriend:SetItemQuantity(15)
  self._uiTreeFriendScroll:SetSize(self._uiTreeFriendScroll:GetSizeX(), ySize)
end
function FriendList:loadOption()
  local noticeSound = ToClient_RoadToggleSoundNotice() or false
  local noticeEffect = ToClient_RoadToggleEffectNotice() or false
  self._checkButtonSound:SetCheck(noticeSound)
  self._checkButtonEffect:SetCheck(noticeEffect)
end
function FriendList:updateList()
  self._uiTreeFriend:ClearTree()
  self._uiTreeFriend:SetAlpha(1)
  self._uiTreeFriend:SetShow(true)
  self._uiTreeFriendBackStatic:SetAlpha(1)
  self._uiTreeFriendOverStatic:SetAlpha(1)
  self._uiTreeFriendBackStatic:SetShow(true)
  self._uiTreeFriendOverStatic:SetShow(true)
  local friendGroupNoDefault = -1
  local friendGroupNoPartyFriend = -2
  local friendGroupCount = RequestFriends_getFriendGroupCount()
  local indexCnt = 0
  local groupIndexCnt = 0
  for groupIndex = 0, friendGroupCount - 1 do
    local friendGroup = RequestFriends_getFriendGroupAt(groupIndex)
    local rootItem = self._uiTreeFriend:createRootItem()
    if friendGroup:getGroupNo() == friendGroupNoDefault then
      rootItem:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_GROUP_ETC"))
      _groupListData._defaultGroupIndex = indexCnt
    elseif friendGroup:getGroupNo() == friendGroupNoPartyFriend then
      rootItem:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_GROUP_PARTY"))
      _groupListData._partyplayGroupIndex = indexCnt
    else
      rootItem:SetText(friendGroup:getName())
    end
    rootItem:SetCustomData(rootItem)
    self._uiTreeFriend:AddRootItem(rootItem)
    _groupListData._groupInfo[indexCnt] = friendGroup
    _groupListData._groupInfoByGroupIndex[groupIndex] = friendGroup
    _groupListData._groupCount = friendGroupCount
    indexCnt = indexCnt + 1
    groupIndexCnt = indexCnt
    if false == friendGroup:isHide() then
      local friendCount = friendGroup:getFriendCount()
      for friendIndex = 0, friendCount - 1 do
        local friendInfo = friendGroup:getFriendAt(friendIndex)
        local childItem = self._uiTreeFriend:createChildItem()
        local friendName = friendInfo:getName()
        if false == friendInfo:isOnline() or true == friendInfo:isGhostMode() then
          local s64_lastLogoutTime = friendInfo:getLastLogoutTime_s64()
          friendName = friendName .. " " .. "(" .. convertStringFromDatetimeOverHourForFriends(s64_lastLogoutTime) .. ")"
        elseif -1 < friendInfo:getWp() and -1 < friendInfo:getExplorationPoint() then
          friendName = friendName .. " " .. "(" .. friendInfo:getCharacterName() .. ", " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. tostring(friendInfo:getLevel()) .. ") " .. tostring(friendInfo:getWp()) .. "/" .. tostring(friendInfo:getExplorationPoint())
        else
          friendName = friendName .. " " .. "(" .. PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_ONLINE") .. ")"
        end
        childItem:SetText(friendName)
        childItem:SetCustomData(childItem)
        self._uiTreeFriend:AddItem(childItem, rootItem)
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
        _friendListData._friendInfo[indexCnt] = friendInfo
        indexCnt = indexCnt + 1
      end
      if friendCount > 0 then
        self._uiTreeFriend:SetSelectItem(groupIndexCnt)
      end
    end
  end
  self._uiTreeFriend:RefreshOpenList()
end
function FriendList:updateListForXbox()
  self._uiTreeFriend:ClearTree()
  self._uiTreeFriend:SetAlpha(1)
  self._uiTreeFriend:SetShow(true)
  self._uiTreeFriendBackStatic:SetAlpha(1)
  self._uiTreeFriendOverStatic:SetAlpha(1)
  self._uiTreeFriendBackStatic:SetShow(true)
  self._uiTreeFriendOverStatic:SetShow(true)
  local friendGroupNoDefault = -1
  local friendGroupNoPartyFriend = -2
  local friendGroupCount = RequestFriends_getFriendGroupCount()
  local indexCnt = 0
  local groupIndexCnt = 0
  for groupIndex = 0, friendGroupCount - 1 do
    local friendGroup = RequestFriends_getFriendGroupAt(groupIndex)
    local rootItem = self._uiTreeFriend:createRootItem()
    if friendGroup:getGroupNo() == friendGroupNoDefault then
      rootItem:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_GROUP_ETC"))
      _groupListData._defaultGroupIndex = indexCnt
    elseif friendGroup:getGroupNo() == friendGroupNoPartyFriend then
      rootItem:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_GROUP_PARTY"))
      _groupListData._partyplayGroupIndex = indexCnt
    else
      rootItem:SetText(friendGroup:getName())
    end
    rootItem:SetCustomData(rootItem)
    self._uiTreeFriend:AddRootItem(rootItem)
    _groupListData._groupInfo[indexCnt] = friendGroup
    _groupListData._groupInfoByGroupIndex[groupIndex] = friendGroup
    _groupListData._groupCount = friendGroupCount
    indexCnt = indexCnt + 1
    groupIndexCnt = indexCnt
    if false == friendGroup:isHide() then
      local friendCount = ToClient_InitializeXboxFriendForLua()
      for friendIndex = 0, friendCount - 1 do
        local friendInfo = ToClient_getXboxFriendInfoByIndex(friendIndex)
        if nil == friendInfo then
        else
          local childItem = self._uiTreeFriend:createChildItem()
          local friendName = "[" .. friendInfo:getGamerTag() .. "] " .. friendInfo:getName()
          if false == friendInfo:isOnline() then
            friendName = friendName .. "( Offline )"
          elseif -1 < friendInfo:getWp() and -1 < friendInfo:getExplorationPoint() then
            friendName = friendName .. "(" .. friendInfo:getCharacterName() .. ", " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. tostring(friendInfo:getLevel()) .. ") " .. tostring(friendInfo:getWp()) .. "/" .. tostring(friendInfo:getExplorationPoint())
          else
            friendName = friendName .. "(" .. PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_ONLINE") .. ")"
          end
          childItem:SetText(friendName)
          childItem:SetCustomData(childItem)
          self._uiTreeFriend:AddItem(childItem, rootItem)
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
          _friendListData._friendInfo[indexCnt] = friendInfo
          indexCnt = indexCnt + 1
        end
      end
      if friendCount > 0 then
        self._uiTreeFriend:SetSelectItem(groupIndexCnt)
      end
    end
  end
  self._uiTreeFriend:RefreshOpenList()
end
FriendList:initialize()
registerEvent("ResponseFriendList_updateFriends", "ResponseFriendList_updateFriends")
registerEvent("FromClient_NoticeNewMessage", "FromClient_NoticeNewMessage")
function ResponseFriendList_updateFriends()
  if true == ToClient_isConsole() then
    FriendList:updateListForXbox()
  else
    FriendList:updateList()
  end
end
function Friend_CloseWindow()
  FriendList_hide()
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
local RequestFriendList = {
  _maxFriendCount = 30,
  _uiRequestFriendList = UI.getChildControl(Panel_FriendList, "Listbox_RequestFriend"),
  _uiBackGround = UI.getChildControl(Panel_FriendList, "Static_OfferWindow"),
  _uiClose = UI.getChildControl(Panel_FriendList, "RequestFriend_Close"),
  _uiApply = UI.getChildControl(Panel_FriendList, "Button_Apply"),
  _uiRefuse = UI.getChildControl(Panel_FriendList, "Button_Dismiss"),
  _uiPartLine = UI.getChildControl(Panel_FriendList, "Static_RequestFriendPartLine"),
  _uiTitleName = UI.getChildControl(Panel_FriendList, "StaticText_RequestFriendName"),
  _uiScroll = nil,
  _uiScrollCtrlButton = nil,
  _friendList = {},
  _selectFriendIndex,
  _slotRows = 12
}
function friend_clickCloseRequestFriendButton()
  AddFriendList_hide()
end
function RequestFriendList:SetShow(isShow)
  RequestFriendList._uiRequestFriendList:SetShow(isShow)
  RequestFriendList._uiBackGround:SetShow(isShow)
  RequestFriendList._uiClose:SetShow(isShow)
  RequestFriendList._uiApply:SetShow(isShow)
  RequestFriendList._uiRefuse:SetShow(isShow)
  RequestFriendList._uiPartLine:SetShow(isShow)
  RequestFriendList._uiTitleName:SetShow(isShow)
end
function RequestFriendList:initialize()
  self._uiScroll = UI.getChildControl(self._uiRequestFriendList, "RequestFriend_Scroll")
  self._uiScroll:SetControlTop()
  self._uiRequestFriendList:addInputEvent("Mouse_LUp", "clickRequestList()")
  self._uiClose:addInputEvent("Mouse_LUp", "friend_clickCloseRequestFriendButton()")
  self._selectFriendIndex = -1
  self._uiApply:addInputEvent("Mouse_LUp", "friend_clickAcceptFriend()")
  self._uiRefuse:addInputEvent("Mouse_LUp", "friend_clickRefuseFriend()")
  self:SetShow(false)
end
function friend_clickAcceptFriend()
  if ToClient_isAddFriendAllowed() then
    if -1 ~= RequestFriendList._selectFriendIndex then
      requestFriendList_acceptFriend(RequestFriendList._selectFriendIndex)
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
function friend_clickRefuseFriend()
  if -1 ~= RequestFriendList._selectFriendIndex then
    requestFriendList_refuseFriend(RequestFriendList._selectFriendIndex)
  end
end
function clickRequestList()
  RequestFriendList._selectFriendIndex = RequestFriendList._uiRequestFriendList:GetSelectIndex()
end
function RequestFriendList:updateList()
  local listControl = self._uiRequestFriendList
  listControl:DeleteAll()
  local friendCount = RequestFriends_getAddFriendCount()
  for friendIndex = 0, friendCount - 1 do
    local addFriendInfo = RequestFriends_getAddFriendAt(friendIndex)
    listControl:AddItemWithLineFeed(addFriendInfo:getName(), UI_color.C_FFC4BEBE)
  end
  UIScroll.SetButtonSize(self._uiScroll, self._slotRows, friendCount)
  if friendCount > 0 then
    self:SetShow(true)
  end
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    FGlobal_NewFriendAlertOff()
  end
end
RequestFriendList:initialize()
registerEvent("ResponseFriendList_updateAddFriends", "ResponseFriendList_updateAddFriends")
function AddFriendList_show()
  self._selectFriendIndex = -1
  RequestFriendList:SetShow(true)
  local isNew = RequestFriendList_getAddFriendList()
  RequestFriendList:updateList()
end
function AddFriendList_hide()
  RequestFriendList:SetShow(false)
end
function ResponseFriendList_updateAddFriends()
  RequestFriendList:updateList()
end
local PopupAddFriend = {
  _uiBackGround = UI.getChildControl(Panel_FriendList, "Static_FriendName_BG"),
  _uiEditName = UI.getChildControl(Panel_FriendList, "Edit_FriendName"),
  _uiYesButton = UI.getChildControl(Panel_FriendList, "Button_AddFriend_Yes"),
  _uiNoButton = UI.getChildControl(Panel_FriendList, "Button_AddFriend_No"),
  _uiCloseButton = UI.getChildControl(Panel_FriendList, "Button_AddFriend_Close"),
  _uiStaticTitle = UI.getChildControl(Panel_FriendList, "StaticText_AddFriend"),
  _uiCheckUserNickName = UI.getChildControl(Panel_FriendList, "CheckButton_IsUserNickName")
}
function PopupAddFriend:SetShow(isShow)
  self._uiBackGround:SetShow(isShow)
  self._uiEditName:SetShow(isShow)
  self._uiYesButton:SetShow(isShow)
  self._uiNoButton:SetShow(isShow)
  self._uiCloseButton:SetShow(isShow)
  self._uiStaticTitle:SetShow(isShow)
  self._uiCheckUserNickName:SetShow(isShow)
  if isShow then
    SetFocusEdit(self._uiEditName)
    self._uiEditName:SetMaxInput(getGameServiceTypeUserNickNameLength())
  else
    CheckChattingInput()
  end
  self._uiEditName:SetEditText("", true)
end
function PopupAddFriend:initialize()
  self._uiYesButton:addInputEvent("Mouse_LUp", "friend_clickAddFriend()")
  self._uiNoButton:addInputEvent("Mouse_LUp", "friend_clickAddFriendClose()")
  self._uiCloseButton:addInputEvent("Mouse_LUp", "friend_clickAddFriendClose()")
  self._uiCheckUserNickName:addInputEvent("Mouse_LUp", "friend_ChangeNickNameMode()")
  self._uiCheckUserNickName:SetPosX(self._uiBackGround:GetPosX() + 12)
  self._uiCheckUserNickName:SetPosY(self._uiBackGround:GetPosY() + 51)
  self._uiCheckUserNickName:SetCheck(true)
  self._uiCheckUserNickName:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_BTN_NICKNAME"))
  self._uiCheckUserNickName:SetEnableArea(0, 0, self._uiCheckUserNickName:GetSizeX() + self._uiCheckUserNickName:GetTextSizeX() + 20, self._uiCheckUserNickName:GetSizeY())
  self._uiEditName:RegistReturnKeyEvent("friend_clickAddFriend()")
  self:SetShow(false)
  friend_ChangeNickNameMode()
end
function friend_clickAddFriend()
  local isNickName = PopupAddFriend._uiCheckUserNickName:IsCheck()
  requestFriendList_addFriend(PopupAddFriend._uiEditName:GetEditText(), isNickName)
  PopupAddFriend:SetShow(false)
  ClearFocusEdit()
end
function friend_clickAddFriendClose()
  PopupAddFriend:SetShow(false)
  ClearFocusEdit()
end
function friend_ChangeInputMode()
end
function friend_ChangeNickNameMode()
  local isNickName = not PopupAddFriend._uiCheckUserNickName:IsCheck()
  if isNickName then
    PopupAddFriend._uiCheckUserNickName:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_BTN_NICKNAME"))
  else
    PopupAddFriend._uiCheckUserNickName:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_BTN_CHARACTERNAME"))
  end
end
function AddFriendInput_CheckCurrentUiEdit(targetUI)
  return nil ~= targetUI and targetUI:GetKey() == PopupAddFriend._uiEditName:GetKey()
end
PopupAddFriend:initialize()
local PopupRenameGroup = {
  _uiBackGround = UI.getChildControl(Panel_FriendList, "Static_GroupName_BG"),
  _uiEditName = UI.getChildControl(Panel_FriendList, "Edit_GroupName"),
  _uiYesButton = UI.getChildControl(Panel_FriendList, "Button_GroupName_Yes"),
  _uiNoButton = UI.getChildControl(Panel_FriendList, "Button_GroupName_No"),
  _uiCloseButton = UI.getChildControl(Panel_FriendList, "Button_GroupName_Close"),
  _uiStaticTitle = UI.getChildControl(Panel_FriendList, "StaticText_ChangeGroupName")
}
function PopupRenameGroup:SetShow(isShow)
  self._isShow = isShow
  self._uiBackGround:SetShow(isShow)
  self._uiEditName:SetShow(isShow)
  self._uiYesButton:SetShow(isShow)
  self._uiNoButton:SetShow(isShow)
  self._uiCloseButton:SetShow(isShow)
  self._uiStaticTitle:SetShow(isShow)
  if false == isShow then
    CheckChattingInput()
  end
  self._uiEditName:SetEditText("", true)
end
function PopupRenameGroup:initialize()
  self._uiYesButton:addInputEvent("Mouse_LUp", "friend_clickRenameGroup()")
  self._uiNoButton:addInputEvent("Mouse_LUp", "friend_clickRenameGroupClose()")
  self._uiCloseButton:addInputEvent("Mouse_LUp", "friend_clickRenameGroupClose()")
  self:SetShow(false)
  self._uiEditName:SetMaxInput(getGameServiceTypeUserNickNameLength())
end
function friend_clickRenameGroup()
  if 0 <= _groupListData._selectedGroupIndex then
    local friendGroup = _groupListData._groupInfo[_groupListData._selectedGroupIndex]
    if PopupRenameGroup._uiEditName:GetEditText() == friendGroup:getName() then
      return
    end
    if "" == PopupRenameGroup._uiEditName:GetEditText() then
      return
    end
    requestFriendList_renameGroup(_groupListData._groupInfo[_groupListData._selectedGroupIndex]:getGroupNo(), PopupRenameGroup._uiEditName:GetEditText())
  end
  PopupRenameGroup:SetShow(false)
end
function friend_clickRenameGroupClose()
  PopupRenameGroup:SetShow(false)
end
PopupRenameGroup:initialize()
local stylePopupBackGround = UI.getChildControl(Panel_FriendList, "Static_Function_BG")
local styleMenuButton = UI.getChildControl(Panel_FriendList, "Style_Function")
stylePopupBackGround:SetShow(false)
styleMenuButton:SetShow(false)
local PopupGroupMenu = {
  _uiBackGround,
  _uiRenameGroup,
  _uiAddGroup
}
function PopupGroupMenu:initialize()
  self._uiBackGround = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_FriendList, "FriendPopupGroupMenu")
  CopyBaseProperty(stylePopupBackGround, self._uiBackGround)
  self._uiRenameGroup = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._uiBackGround, "FriendPopupRenameGroup")
  CopyBaseProperty(styleMenuButton, self._uiRenameGroup)
  self._uiAddGroup = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._uiBackGround, "FriendPopupAddGroup")
  CopyBaseProperty(styleMenuButton, self._uiAddGroup)
  local buttonSizeX = styleMenuButton:GetSizeX()
  local buttonSizeY = styleMenuButton:GetSizeY()
  self._uiBackGround:SetSize(buttonSizeX, buttonSizeY * 2)
  self._uiRenameGroup:SetPosX(0)
  self._uiRenameGroup:SetPosY(0)
  self._uiAddGroup:SetPosX(0)
  self._uiAddGroup:SetPosY(buttonSizeY)
  self._uiRenameGroup:SetShow(true)
  self._uiAddGroup:SetShow(true)
  self._uiRenameGroup:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_RENAME"))
  self._uiAddGroup:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_ADD_GROUP"))
  self._uiRenameGroup:addInputEvent("Mouse_LUp", "friend_renameFriendGroup()")
  self._uiAddGroup:addInputEvent("Mouse_LUp", "friend_addFriendGroup()")
  self._uiBackGround:SetShow(false)
end
function PopupGroupMenu:SetShow(isShow)
  if _groupListData._defaultGroupIndex == _groupListData._selectedGroupIndex then
    self._uiRenameGroup:SetEnable(false)
    self._uiRenameGroup:SetMonoTone(true)
    self._uiRenameGroup:SetIgnore(true)
    self._uiAddGroup:SetEnable(true)
    self._uiAddGroup:SetMonoTone(false)
    self._uiAddGroup:SetIgnore(false)
  elseif _groupListData._partyplayGroupIndex == _groupListData._selectedGroupIndex then
    self._uiRenameGroup:SetEnable(false)
    self._uiRenameGroup:SetMonoTone(true)
    self._uiRenameGroup:SetIgnore(true)
    self._uiAddGroup:SetEnable(false)
    self._uiAddGroup:SetMonoTone(true)
    self._uiAddGroup:SetIgnore(true)
  else
    self._uiRenameGroup:SetEnable(true)
    self._uiRenameGroup:SetMonoTone(false)
    self._uiRenameGroup:SetIgnore(false)
    self._uiAddGroup:SetEnable(true)
    self._uiAddGroup:SetMonoTone(false)
    self._uiAddGroup:SetIgnore(false)
  end
  self._uiBackGround:SetShow(isShow)
  FriendList._isGroupMenuShow = isShow
end
function PopupGroupMenu:setPos(x, y)
  self._uiBackGround:SetPosX(x)
  self._uiBackGround:SetPosY(y)
end
PopupGroupMenu:initialize()
local PopupFriendMenu = {
  _uiBackGround,
  _uiPartyInvite,
  _uiMessanger,
  _uiMoveGroup,
  _uiDelete,
  _uiXboxProfile,
  _uiRecallFriend
}
function PopupFriendMenu:initialize()
  self._uiBackGround = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_FriendList, "FriendPopupFriendMenu")
  self._uiPartyInvite = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._uiBackGround, "FriendPopupPartyInvite")
  CopyBaseProperty(styleMenuButton, self._uiPartyInvite)
  self._uiMessanger = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._uiBackGround, "FriendPopupWhisper")
  CopyBaseProperty(styleMenuButton, self._uiMessanger)
  self._uiMoveGroup = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._uiBackGround, "FriendPopupMoveGroup")
  CopyBaseProperty(styleMenuButton, self._uiMoveGroup)
  self._uiDelete = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._uiBackGround, "FriendPopupDeleteFriend")
  CopyBaseProperty(styleMenuButton, self._uiDelete)
  self._uiXboxProfile = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._uiBackGround, "FriendPopupXboxProfile")
  CopyBaseProperty(styleMenuButton, self._uiXboxProfile)
  self._uiRecallFriend = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._uiBackGround, "FriendPopupXboxRecallFriend")
  CopyBaseProperty(styleMenuButton, self._uiRecallFriend)
  local buttonSizeX = styleMenuButton:GetSizeX()
  local buttonSizeY = styleMenuButton:GetSizeY()
  self._uiBackGround:SetSize(buttonSizeX, buttonSizeY * 2)
  self._uiPartyInvite:SetPosX(0)
  self._uiPartyInvite:SetPosY(0)
  self._uiMessanger:SetPosX(0)
  self._uiMessanger:SetPosY(buttonSizeY)
  self._uiMoveGroup:SetPosX(0)
  self._uiMoveGroup:SetPosY(buttonSizeY * 2)
  self._uiDelete:SetPosX(0)
  self._uiDelete:SetPosY(buttonSizeY * 3)
  self._uiXboxProfile:SetPosX(0)
  self._uiXboxProfile:SetPosY(buttonSizeY * 4)
  self._uiRecallFriend:SetPosX(0)
  self._uiRecallFriend:SetPosY(buttonSizeY * 5)
  self._uiPartyInvite:SetShow(true)
  self._uiMessanger:SetShow(true)
  self._uiMoveGroup:SetShow(true)
  self._uiDelete:SetShow(true)
  self._uiXboxProfile:SetShow(true)
  self._uiRecallFriend:SetShow(false)
  if false == ToClient_isConsole() then
    self._uiXboxProfile:SetShow(false)
    self._uiRecallFriend:SetShow(false)
  end
  if ToClient_IsDevelopment() then
    self._uiXboxProfile:SetShow(true)
    self._uiRecallFriend:SetShow(false)
  end
  self._uiPartyInvite:SetText(PAGetString(Defines.StringSheet_GAME, "INTERACTION_MENU3"))
  self._uiMessanger:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_WHISPER"))
  self._uiMoveGroup:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_CHANGE_GROUP"))
  self._uiDelete:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_REMOVE_FRIEND"))
  self._uiXboxProfile:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_XBOX_PROFILE"))
  self._uiRecallFriend:SetText("Recall")
  self._uiPartyInvite:addInputEvent("Mouse_LUp", "friend_PartyInvite()")
  self._uiMessanger:addInputEvent("Mouse_LUp", "friend_Messanger()")
  self._uiMoveGroup:addInputEvent("Mouse_LUp", "friend_groupMoveList()")
  self._uiDelete:addInputEvent("Mouse_LUp", "friend_deleteFriend()")
  self._uiXboxProfile:addInputEvent("Mouse_LUp", "friend_XboxProfileShow()")
  self._uiRecallFriend:addInputEvent("Mouse_LUp", "friend_RequestRecall()")
  self._uiBackGround:SetShow(false)
end
function PopupFriendMenu:SetShow(isShow)
  if isShow then
    local isOnline = _friendListData._friendInfo[_friendListData._selectedFriendIndex]:isOnline()
    local isMessage = RequestFriendList_isMessageList(_friendListData._friendInfo[_friendListData._selectedFriendIndex]:getUserNo())
    if false == isOnline and false == isMessage then
      self._uiMessanger:SetEnable(false)
      self._uiMessanger:SetMonoTone(true)
      self._uiMessanger:SetIgnore(true)
    else
      self._uiMessanger:SetEnable(true)
      self._uiMessanger:SetMonoTone(false)
      self._uiMessanger:SetIgnore(false)
    end
  end
  self._uiBackGround:SetShow(isShow)
  FriendList._isFriendMenuShow = isShow
end
function PopupFriendMenu:setPos(x, y)
  self._uiBackGround:SetPosX(x)
  self._uiBackGround:SetPosY(y)
end
PopupFriendMenu:initialize()
local PopupPartyFriendMenu = {
  _uiBackGround,
  _uiAddFriend,
  _uiDeletePartyFriend
}
function PopupPartyFriendMenu:initialize()
  self._uiBackGround = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_FriendList, "FriendPopupPartyFriendMenu")
  self._uiAddFriend = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._uiBackGround, "FriendPopupRequestAddFriend")
  self._uiDeletePartyFriend = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._uiBackGround, "FriendPopupRequestDeletePartyFriend")
  CopyBaseProperty(styleMenuButton, self._uiAddFriend)
  CopyBaseProperty(styleMenuButton, self._uiDeletePartyFriend)
  local buttonSizeX = styleMenuButton:GetSizeX()
  local buttonSizeY = styleMenuButton:GetSizeY()
  self._uiBackGround:SetSize(buttonSizeX, buttonSizeY)
  self._uiDeletePartyFriend:SetSize(buttonSizeX, buttonSizeY)
  self._uiAddFriend:SetPosX(0)
  self._uiAddFriend:SetPosY(0)
  self._uiDeletePartyFriend:SetPosX(0)
  self._uiDeletePartyFriend:SetPosY(self._uiAddFriend:GetSizeY())
  self._uiAddFriend:SetShow(true)
  self._uiDeletePartyFriend:SetShow(true)
  self._uiAddFriend:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_ADD_FRIEND"))
  self._uiAddFriend:addInputEvent("Mouse_LUp", "friend_requestAddFriend()")
  self._uiDeletePartyFriend:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INGAMECASHSHOP_NEWCART_DELETEITEM"))
  self._uiDeletePartyFriend:addInputEvent("Mouse_LUp", "friend_deleteFriend()")
  self._uiBackGround:SetShow(false)
end
function PopupPartyFriendMenu:SetShow(isShow)
  self._uiBackGround:SetShow(isShow)
  FriendList._isFriendMenuShow = isShow
end
function PopupPartyFriendMenu:setPos(x, y)
  self._uiBackGround:SetPosX(x)
  self._uiBackGround:SetPosY(y)
end
PopupPartyFriendMenu:initialize()
local PopupGroupList = {
  _uiBackGround,
  _uiMoveGroups = {},
  _maxGroupCount = 5
}
function PopupGroupList:initialize()
  self._uiBackGround = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_FriendList, "FriendPopupGroupList")
  for groupIndex = 0, self._maxGroupCount - 1 do
    self._uiMoveGroups[groupIndex] = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, self._uiBackGround, "FriendPopupMoveGroups_" .. groupIndex)
    CopyBaseProperty(styleMenuButton, self._uiMoveGroups[groupIndex])
    local buttonSizeY = styleMenuButton:GetSizeY()
    self._uiMoveGroups[groupIndex]:SetSize(styleMenuButton:GetSizeX() + styleMenuButton:GetSizeX() / 3, styleMenuButton:GetSizeY())
    self._uiMoveGroups[groupIndex]:SetPosX(0)
    self._uiMoveGroups[groupIndex]:SetPosY(buttonSizeY * groupIndex)
    self._uiMoveGroups[groupIndex]:addInputEvent("Mouse_LUp", "clickedFriend_moveGroup(" .. groupIndex .. ")")
  end
  self._uiBackGround:SetShow(false)
end
function PopupGroupList:updateGroups()
  for index = 0, self._maxGroupCount - 1 do
    self._uiMoveGroups[index]:SetShow(false)
  end
  local groupCount = _groupListData._groupCount
  local buttonSizeX = styleMenuButton:GetSizeX()
  local buttonSizeY = styleMenuButton:GetSizeY()
  local friendGroupNoPartyFriend = -2
  self._uiBackGround:SetSize(buttonSizeX, buttonSizeY * groupCount)
  for groupIndex = 0, groupCount - 1 do
    local groupName = _groupListData._groupInfoByGroupIndex[groupIndex]:getName()
    if _groupListData._groupInfoByGroupIndex[groupIndex]:getGroupNo() ~= friendGroupNoPartyFriend then
      if groupName == "" then
        self._uiMoveGroups[groupIndex]:SetText(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_GROUP_ETC"))
      else
        self._uiMoveGroups[groupIndex]:SetText(groupName)
      end
      self._uiMoveGroups[groupIndex]:SetShow(true)
    end
  end
end
function PopupGroupList:SetShow(isShow)
  self._uiBackGround:SetShow(isShow)
  if isShow then
    PopupGroupList:updateGroups()
  end
end
function PopupGroupList:setPos(x, y)
  self._uiBackGround:SetPosX(x)
  self._uiBackGround:SetPosY(y)
end
PopupGroupList:initialize()
function clickFriendGroupIcon(groupIndex)
  requestFriendList_checkGroup(_groupListData._groupInfoByGroupIndex[groupIndex]:getGroupNo())
end
function clickFriendGroup(groupIndex)
  _groupListData._selectedGroupIndex = groupIndex
  PopupFriendMenu:SetShow(false)
  PopupPartyFriendMenu:SetShow(false)
  PopupGroupMenu:SetShow(true)
  PopupGroupMenu:setPos(_groupListData._uiGroups[groupIndex]:GetPosX() + 30, _groupListData._uiGroups[groupIndex]:GetPosY())
end
function friend_renameFriendGroup()
  PopupRenameGroup:SetShow(true)
  PopupGroupMenu:SetShow(false)
end
function friend_addFriendGroup()
  requestFriendList_addFriendGroup(PAGetString(Defines.StringSheet_GAME, "FRIEND_TEXT_NEW_GROUPNAME"))
  PopupGroupMenu:SetShow(false)
end
function friend_deleteFriendGroup()
  PopupGroupMenu:SetShow(false)
end
function clickFriendList(isRUp)
  local self = FriendList
  self._uiTreeFriend:SetSelectItemMousePoint()
  local friendIndex = self._uiTreeFriend:GetSelectItem()
  if nil == friendIndex then
    return
  end
  if isRUp then
    if CppEnums.TreeItemType.PA_TREE_ITEM_ROOT == friendIndex:GetType() then
      _groupListData._selectedGroupIndex = friendIndex:GetIndex()
      PopupFriendMenu:SetShow(false)
      PopupPartyFriendMenu:SetShow(false)
      PopupGroupMenu:SetShow(true)
      PopupGroupMenu:setPos(getMousePosX() - self._mainPanel:GetPosX(), getMousePosY() - self._mainPanel:GetPosY())
    else
      _friendListData._selectedFriendIndex = friendIndex:GetIndex()
      PopupGroupMenu:SetShow(false)
      if _friendListData._friendInfo[_friendListData._selectedFriendIndex]:getFriendType() == 1 then
        PopupPartyFriendMenu:SetShow(true)
        PopupFriendMenu:SetShow(false)
        PopupPartyFriendMenu:setPos(getMousePosX() - self._mainPanel:GetPosX(), getMousePosY() - self._mainPanel:GetPosY())
      else
        PopupFriendMenu:SetShow(true)
        PopupPartyFriendMenu:SetShow(false)
        PopupFriendMenu:setPos(getMousePosX() - self._mainPanel:GetPosX(), getMousePosY() - self._mainPanel:GetPosY())
      end
    end
    PopupGroupList:SetShow(false)
  else
    audioPostEvent_SystemUi(0, 0)
    if self._isFriendMenuShow or self._isGroupMenuShow then
      friend_closeFriendMenu()
    elseif CppEnums.TreeItemType.PA_TREE_ITEM_ROOT == friendIndex:GetType() then
    else
      _friendListData._selectedFriendIndex = friendIndex:GetIndex()
      if _friendListData._friendInfo[_friendListData._selectedFriendIndex]:getFriendType() == 1 then
      else
        _friendListData._selectedFriendIndex = friendIndex:GetIndex()
        friend_Messanger()
      end
    end
  end
end
function friend_PartyInvite()
  local userCharacterName = _friendListData._friendInfo[_friendListData._selectedFriendIndex]:getCharacterName()
  local isOnline = _friendListData._friendInfo[_friendListData._selectedFriendIndex]:isOnline()
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
function friend_Messanger()
  local userNo = _friendListData._friendInfo[_friendListData._selectedFriendIndex]:getUserNo()
  local userName = _friendListData._friendInfo[_friendListData._selectedFriendIndex]:getName()
  local isOnline = _friendListData._friendInfo[_friendListData._selectedFriendIndex]:isOnline()
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
  RequestFriendList_OpenMessanger(userNo, userName, isOnline)
  PopupFriendMenu:SetShow(false)
end
function friend_groupMoveList()
  PopupGroupList:SetShow(true)
  PopupGroupList:setPos(PopupFriendMenu._uiBackGround:GetPosX() + PopupFriendMenu._uiBackGround:GetSizeX(), PopupFriendMenu._uiBackGround:GetPosY())
end
function friend_requestAddFriend()
  requestFriendList_addFriend(_friendListData._friendInfo[_friendListData._selectedFriendIndex]:getName())
  PopupPartyFriendMenu:SetShow(false)
end
function friend_deleteFriend()
  requestFriendList_deleteFriend(_friendListData._friendInfo[_friendListData._selectedFriendIndex]:getUserNo())
  PopupFriendMenu:SetShow(false)
  PopupPartyFriendMenu:SetShow(false)
end
function clickedFriend_moveGroup(groupIndex)
  requestFriendList_moveGroup(_friendListData._friendInfo[_friendListData._selectedFriendIndex]:getUserNo(), _groupListData._groupInfoByGroupIndex[groupIndex]:getGroupNo())
  PopupFriendMenu:SetShow(false)
  PopupGroupList:SetShow(false)
end
function friend_XboxProfileShow()
  ToClient_showXboxFriendProfile(_friendListData._friendInfo[_friendListData._selectedFriendIndex]:getXuid())
  PopupFriendMenu:SetShow(false)
  PopupGroupList:SetShow(false)
end
function friend_RequestRecall()
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
  friends_requestRecall(_friendListData._friendInfo[_friendListData._selectedFriendIndex]:getUserNo())
  PopupFriendMenu:SetShow(false)
  PopupGroupList:SetShow(false)
end
Panel_FriendList:addInputEvent("Mouse_Out", "friend_closeFriendMenu()")
local uiRequestList = UI.getChildControl(Panel_FriendList, "Button_Offer")
uiRequestList:addInputEvent("Mouse_LUp", "friend_clickRequestButton()")
local uiAddFriend = UI.getChildControl(Panel_FriendList, "Button_AddFriend")
uiAddFriend:addInputEvent("Mouse_LUp", "friend_clickAddFriendButton()")
function friend_closeFriendMenu()
  PopupFriendMenu:SetShow(false)
  PopupPartyFriendMenu:SetShow(false)
  PopupGroupMenu:SetShow(false)
  PopupGroupList:SetShow(false)
end
function friend_clickRequestButton()
  if RequestFriendList._uiBackGround:GetShow() then
    AddFriendList_hide()
  else
    AddFriendList_show()
  end
end
function friend_clickAddFriendButton()
  if PopupAddFriend._uiBackGround:GetShow() then
    PopupAddFriend:SetShow(false)
  elseif false == ToClient_isAddFriendAllowed() then
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
  else
    PopupAddFriend:SetShow(true)
  end
end
function FriendList_ShowToggle()
  if CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode == UI.Get_ProcessorInputMode() then
    return
  end
  if Panel_FriendList:GetShow() == true then
    FriendList_hide()
  else
    FriendList_show()
  end
end
function FriendList_show()
  ToClient_updateAddFriendAllowed()
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    friendsBTN:EraseAllEffect()
  end
  Panel_FriendList:SetShow(true, true)
  FriendList:loadOption()
end
function FriendList_hide()
  PopupAddFriend:SetShow(false)
  RequestFriendList:SetShow(false)
  PopupFriendMenu:SetShow(false)
  PopupPartyFriendMenu:SetShow(false)
  PopupGroupMenu:SetShow(false)
  PopupGroupList:SetShow(false)
  Panel_FriendList:SetShow(false, true)
end
function FromClient_FriendList_onScreenResize()
  Panel_FriendList:SetPosX(getScreenSizeX() - Panel_FriendList:GetSizeX())
  Panel_FriendList:SetPosY(getScreenSizeY() / 2 - Panel_FriendList:GetSizeY() / 2)
end
function FriendList_showAni()
  audioPostEvent_SystemUi(1, 0)
  local isNew = RequestFriendList_getFriendList()
  if true == ToClient_isConsole() then
    FriendList:updateListForXbox()
  else
    FriendList:updateList()
  end
  RequestFriendList_getAddFriendList()
  RequestFriendList:updateList()
  UIAni.AlphaAnimation(1, Panel_FriendList, 0, 0.15)
  local aniInfo1 = Panel_FriendList:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_FriendList:GetSizeX() / 2
  aniInfo1.AxisY = Panel_FriendList:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_FriendList:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_FriendList:GetSizeX() / 2
  aniInfo2.AxisY = Panel_FriendList:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function FriendList_hideAni()
  audioPostEvent_SystemUi(1, 1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_FriendList, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
function FromClient_NotifyFriendMessage(msgType, strParam1, param1, param2)
  local msgStr = ""
  if 0 == msgType then
    if 1 == param1 then
      msgStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FRIENDS_NOTIFYFRIENDMESSAGE_LOGIN", "strParam1", strParam1)
    elseif 0 == msgType then
      msgStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FRIENDS_NOTIFYFRIENDMESSAGE_LOGOUT", "strParam1", strParam1)
    end
    Proc_ShowMessage_Ack(msgStr)
    FriendList:updateList()
    FromClient_FriendListUpdateLogOnOffForMessanger(param2, param1)
  end
end
function FromClient_ResponseFriendRecall(friendName, serverName, serverNo)
  local ClickedYesFunc = function()
    TargetWindow_ShowToggle(43)
  end
  friendServerNo = serverNo
  local messageboxData = {
    title = "\236\185\156\234\181\172 \236\180\136\235\140\128",
    content = tostring(friendName) .. "\234\176\128 " .. tostring(serverName) .. " \236\177\132\235\132\144\235\161\156 \236\180\136\235\140\128\237\149\152\236\152\128\236\138\181\235\139\136\235\139\164. \236\177\132\235\132\144\236\157\180\235\143\153\237\149\152\236\139\156\234\178\160\236\138\181\235\139\136\234\185\140?",
    functionYes = ClickedYesFunc,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function isSelectFriendBlocked()
  local userNo = _friendListData._friendInfo[_friendListData._selectedFriendIndex]:getUserNo()
  local groupNo = _friendListData._friendInfo[_friendListData._selectedFriendIndex]:getGroupNo()
  return RequestFriends_isBlockedFriend(userNo, groupNo)
end
registerEvent("FromClient_ResponseFriendRecall", "FromClient_ResponseFriendRecall")
registerEvent("FromClient_GroundMouseClick", "FriendMessanger_KillFocusEdit")
registerEvent("onScreenResize", "FromClient_FriendList_onScreenResize")
registerEvent("FromClient_FriendListUpdateLogOnOffForMessanger", "FromClient_FriendListUpdateLogOnOffForMessanger")
registerEvent("FromClient_NotifyFriendMessage", "FromClient_NotifyFriendMessage")
registerEvent("FromClient_FriendDirectlyMessage", "FromClient_FriendDirectlyMessage")
function FriendfunctionYes()
  ToClient_RquestDirectlyCompelte(true)
end
function FriendfunctionNo()
  ToClient_RquestDirectlyCompelte(false)
end
function FromClient_FriendDirectlyMessage(fromUserName)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "FRIEND_TEXT_TITLE"),
    content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_XBOX_FRIEND_MESSAGE", "userName", fromUserName),
    functionYes = FriendfunctionYes,
    functionNo = FriendfunctionNo,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end

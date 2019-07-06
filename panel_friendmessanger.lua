local IM = CppEnums.EProcessorInputMode
local CTLTYPE = CppEnums.PA_UI_CONTROL_TYPE
PaGlobal_FriendMessanger = {
  _currentFocusId = -1,
  _messangerList = {}
}
function PaGlobal_FriendMessanger:CreateMessanger(messangerId, userName, isOnline)
  local messanger = {
    _ui = {
      _mainPanel = nil,
      _btnClose = nil,
      _enterBtn = nil,
      _editInputChat = nil,
      _staticTitle = nil,
      _staticTitleImg = nil,
      _sizeControl = nil,
      _slider = nil,
      _sliderButton = nil,
      _frame = nil,
      _frameContent = nil,
      _frameScroll = nil,
      _staticText = {},
      _staticBg = {}
    },
    _messangerAlpha = 1,
    _messageCount = 0,
    _isCallShow = false
  }
  function messanger:Initialize(messangerId, userName, isOnline)
    messanger:CreatePanel(messangerId, isOnline)
    messanger:PrepareControl(messangerId, userName, isOnline)
  end
  function messanger:Clear()
    UI.deletePanel(self._ui._mainPanel:GetID())
    self._ui._mainPanel = nil
  end
  function messanger:CreatePanel(messangerId, isOnline)
    local newName = "Panel_FriendMessanger" .. messangerId
    messanger._ui._mainPanel = UI.createPanel(newName, Defines.UIGroup.PAGameUIGroup_WorldMap_Popups)
    CopyBaseProperty(Panel_Friend_Messanger, messanger._ui._mainPanel)
    messanger._ui._mainPanel:SetDragAll(true)
    messanger._ui._mainPanel:SetShow(true)
    messanger._ui._mainPanel:addInputEvent("Mouse_UpScroll", "PaGlobal_FriendMessanger:Scroll( " .. messangerId .. ", true )")
    messanger._ui._mainPanel:addInputEvent("Mouse_DownScroll", "PaGlobal_FriendMessanger:Scroll( " .. messangerId .. ", false )")
  end
  function messanger:PrepareControl(messangerId, userName, isOnline)
    self._ui._btnClose = messanger:CreateControl(CTLTYPE.PA_UI_CONTROL_BUTTON, Panel_Friend_Messanger, self._ui._mainPanel, "Button_Close", 0)
    self._ui._frame = messanger:CreateControl(CTLTYPE.PA_UI_CONTROL_FRAME, Panel_Friend_Messanger, self._ui._mainPanel, "Frame_1", 0)
    self._ui._enterBtn = messanger:CreateControl(CTLTYPE.PA_UI_CONTROL_BUTTON, Panel_Friend_Messanger, self._ui._mainPanel, "Button_Enter", 0)
    self._ui._staticTitle = messanger:CreateControl(CTLTYPE.PA_UI_CONTROL_STATICTEXT, Panel_Friend_Messanger, self._ui._mainPanel, "StaticText_TitleName", 0)
    self._ui._staticTitleImg = messanger:CreateControl(CTLTYPE.PA_UI_CONTROL_STATIC, Panel_Friend_Messanger, self._ui._mainPanel, "Static_TitleImage", 0)
    self._ui._sizeControl = messanger:CreateControl(CTLTYPE.PA_UI_CONTROL_BUTTON, Panel_Friend_Messanger, self._ui._mainPanel, "Button_SizeControl", 0)
    self._ui._editInputChat = messanger:CreateControl(CTLTYPE.PA_UI_CONTROL_EDIT, Panel_Friend_Messanger, self._ui._mainPanel, "Edit_InputChat", 0)
    self._ui._frameScroll = self._ui._frame:GetVScroll()
    CopyBaseProperty(UI.getChildControl(UI.getChildControl(Panel_Friend_Messanger, "Frame_1"), "Frame_1_VerticalScroll"), self._ui._frameScroll)
    self._ui._frameContent = self._ui._frame:GetFrameContent()
    self._ui._btnClose:addInputEvent("Mouse_LUp", "PaGlobal_FriendMessanger:Close(" .. messangerId .. ")")
    self._ui._enterBtn:addInputEvent("Mouse_LUp", "PaGlobal_FriendMessanger:SendMessage(" .. messangerId .. ")")
    self._ui._editInputChat:SetMaxInput(100)
    if isOnline then
      self._ui._editInputChat:addInputEvent("Mouse_LUp", "PaGlobal_FriendMessanger:SetFocusEdit(" .. messangerId .. ")")
      self._ui._editInputChat:RegistReturnKeyEvent("PaGlobal_FriendMessanger:SendMessageByKeyboard()")
      self._ui._editInputChat:SetEnable(true)
      self._ui._enterBtn:SetEnable(true)
    else
      self._ui._editInputChat:SetEnable(false)
      self._ui._enterBtn:SetEnable(false)
    end
    self._ui._staticTitle:SetText(userName)
    self._ui._sizeControl:addInputEvent("Mouse_LDown", "PaGlobal_FriendMessanger:SetPos( " .. messangerId .. " )")
    self._ui._sizeControl:addInputEvent("Mouse_LPress", "PaGlobal_FriendMessanger:Resize( " .. messangerId .. " )")
    self._ui._slider = UI.createControl(CTLTYPE.PA_UI_CONTROL_SLIDER, self._ui._mainPanel, "Slider_Alpha")
    self._ui._sliderButton = self._ui._slider:GetControlButton()
    local style = UI.getChildControl(Panel_Friend_Messanger, "Slider_Alpha")
    CopyBaseProperty(style, self._ui._slider)
    self._ui._slider:SetInterval(100)
    self._ui._sliderButton:addInputEvent("Mouse_LPress", "PaGlobal_FriendMessanger:SetAlpha( " .. messangerId .. ")")
    self._ui._slider:addInputEvent("Mouse_LUp", "PaGlobal_FriendMessanger:SetAlpha( " .. messangerId .. ")")
    self._ui._slider:SetControlPos(100)
  end
  function messanger:CreateControl(controlType, parentStyleControl, parentControl, controlName, index)
    local styleControl = UI.getChildControl(parentStyleControl, controlName)
    local control = UI.createControl(controlType, parentControl, controlName .. index)
    CopyBaseProperty(styleControl, control)
    return control
  end
  function messanger:ClearAllMessage()
    for index = 0, self._messageCount - 1 do
      self._ui._staticText[index]:SetShow(false)
      self._ui._staticBg[index]:SetShow(false)
      UI.deleteControl(self._ui._staticText[index])
      UI.deleteControl(self._ui._staticBg[index])
    end
    self._messageCount = 0
  end
  function messanger:UpdateMessage(chattingMessage)
    messanger:ShowMessage(chattingMessage.isMe, chattingMessage:getContent())
    self._messageCount = self._messageCount + 1
  end
  function messanger:ShowMessage(isMe, msg)
    messanger:CreateMessageUI(isMe)
    messanger:ResizeMessageUI(msg)
    messanger:SetPosMessageUI(isMe)
  end
  function messanger:ResizeMessageUI(msg)
    local panelSizeX = self._ui._mainPanel:GetSizeX()
    local maxTextSizeX = panelSizeX - 100
    local staticText = self._ui._staticText[self._messageCount]
    local staticBg = self._ui._staticBg[self._messageCount]
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
  function messanger:CreateMessageUI(isMe)
    local styleBg = UI.getChildControl(Panel_Friend_Messanger, "Static_To")
    local styleText = UI.getChildControl(Panel_Friend_Messanger, "StaticText_To")
    if false == isMe then
      styleBg = UI.getChildControl(Panel_Friend_Messanger, "Static_From")
      styleText = UI.getChildControl(Panel_Friend_Messanger, "StaticText_From")
    end
    self._ui._staticBg[self._messageCount] = UI.createControl(CTLTYPE.PA_UI_CONTROL_STATIC, self._ui._frameContent, "Static_BG_" .. self._messageCount)
    self._ui._staticText[self._messageCount] = UI.createControl(CTLTYPE.PA_UI_CONTROL_STATICTEXT, self._ui._frameContent, "Static_Text_" .. self._messageCount)
    CopyBaseProperty(styleBg, self._ui._staticBg[self._messageCount])
    CopyBaseProperty(styleText, self._ui._staticText[self._messageCount])
    self._ui._staticBg[self._messageCount]:SetShow(true)
    self._ui._staticText[self._messageCount]:SetIgnore(true)
    self._ui._staticText[self._messageCount]:SetShow(true)
  end
  function messanger:SetPosMessageUI(isMe)
    local prevBgPosY = 0
    local prevBgSizeY = 0
    if 0 < self._messageCount then
      prevBgPosY = self._ui._staticBg[self._messageCount - 1]:GetPosY()
      prevBgSizeY = self._ui._staticBg[self._messageCount - 1]:GetSizeY()
    end
    local bgPosX = 12
    if isMe then
      bgPosX = messanger._ui._mainPanel:GetSizeX() - self._ui._staticBg[self._messageCount]:GetSizeX() - 14
      self._ui._staticText[self._messageCount]:SetPosX(self._ui._staticText[self._messageCount]:GetPosX() - 13)
    end
    self._ui._staticBg[self._messageCount]:SetPosX(bgPosX)
    self._ui._staticBg[self._messageCount]:SetPosY(prevBgPosY + prevBgSizeY + 5)
    self._ui._staticText[self._messageCount]:SetPosY(self._ui._staticBg[self._messageCount]:GetPosY() + 1)
  end
  messanger:Initialize(messangerId, userName, isOnline)
  return messanger
end
function PaGlobal_FriendMessanger:SetAlpha(messangerId)
  local messanger = PaGlobal_FriendMessanger._messangerList[messangerId]
  local panel = PaGlobal_FriendMessanger._messangerList[messangerId]._ui._mainPanel
  messanger._messangerAlpha = messanger._ui._slider:GetControlPos() * 0.5 + 0.5
  panel:SetAlpha(messanger._messangerAlpha)
  panel:SetAlphaChild(messanger._messangerAlpha)
  messanger._ui._btnClose:SetAlpha(1)
  messanger._ui._slider:SetAlpha(1)
  messanger._ui._sliderButton:SetAlpha(1)
  messanger._ui._staticTitle:SetFontAlpha(messanger._messangerAlpha)
  for i = 0, messanger._messageCount - 1 do
    local staticText = messanger._ui._staticText[i]
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
function PaGlobal_FriendMessanger:SetPos(messangerId)
  local panel = PaGlobal_FriendMessanger._messangerList[messangerId]._ui._mainPanel
  orgMouseX = getMousePosX()
  orgMouseY = getMousePosY()
  orgPanelPosX = panel:GetPosX()
  orgPanelSizeX = panel:GetSizeX()
  orgPanelSizeY = panel:GetSizeY()
end
function PaGlobal_FriendMessanger:Resize(messangerId)
  local messanger = PaGlobal_FriendMessanger._messangerList[messangerId]
  local panel = messanger._ui._mainPanel
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
  messanger._ui._sizeControl:SetPosY(panel:GetSizeY() - messanger._ui._sizeControl:GetSizeY())
  messanger._ui._editInputChat:SetPosY(panel:GetSizeY() - messanger._ui._editInputChat:GetSizeY() - 5)
  messanger._ui._editInputChat:SetSize(panel:GetSizeX() - 69, messanger._ui._editInputChat:GetSizeY())
  messanger._ui._btnClose:SetPosX(panel:GetSizeX() - messanger._ui._btnClose:GetSizeX() - 5)
  messanger._ui._frame:SetSize(panel:GetSizeX() - 10, panel:GetSizeY() - 55)
  messanger._ui._enterBtn:SetPosY(panel:GetSizeY() - 33)
  messanger._ui._enterBtn:SetPosX(panel:GetSizeX() - 46)
  messanger._ui._slider:SetPosX(panel:GetSizeX() - 82)
  FromClient_UpdateFriendMessanger(messangerId)
end
function PaGlobal_FriendMessanger:Scroll(messangerId, isUp)
  local messanger = PaGlobal_FriendMessanger._messangerList[messangerId]
  local targetScroll = messanger._ui._frameScroll
  if isUp then
    targetScroll:ControlButtonUp()
  else
    targetScroll:ControlButtonDown()
  end
  messanger._ui._frame:UpdateContentPos()
end
function FGlobal_FriendMessanger_CheckUiEdit(targetUI)
  if -1 == PaGlobal_FriendMessanger._currentFocusId then
    return false
  end
  local currentEdit = PaGlobal_FriendMessanger._messangerList[PaGlobal_FriendMessanger._currentFocusId]._ui._editInputChat
  return nil ~= targetUI and targetUI:GetKey() == currentEdit:GetKey()
end
function PaGlobal_FriendMessanger:Close(messangerId)
  local messanger = PaGlobal_FriendMessanger._messangerList[messangerId]
  ToClient_CloseMessanger(messangerId)
  messanger:Clear()
  PaGlobal_FriendMessanger._messangerList[messangerId] = nil
  if messangerId == PaGlobal_FriendMessanger._currentFocusId then
    PaGlobal_FriendMessanger._currentFocusId = -1
    ClearFocusEdit()
  end
  CheckChattingInput()
end
function PaGlobal_FriendMessanger:SetFocusEdit(messangerId)
  local messanger = PaGlobal_FriendMessanger._messangerList[messangerId]
  SetFocusEdit(messanger._ui._editInputChat)
  PaGlobal_FriendMessanger._currentFocusId = messangerId
end
function FGlobal_FriendMessanger_KillFocusEdit()
  if -1 == PaGlobal_FriendMessanger._currentFocusId then
    return false
  end
  ClearFocusEdit()
  PaGlobal_FriendMessanger._currentFocusId = -1
  CheckChattingInput()
  return false
end
function PaGlobal_FriendMessanger:SendMessageByKeyboard()
  PaGlobal_FriendMessanger:SendMessage(PaGlobal_FriendMessanger._currentFocusId)
end
function PaGlobal_FriendMessanger:SendMessage(messangerId)
  local messanger = PaGlobal_FriendMessanger._messangerList[messangerId]
  local rv = chatting_sendMessageByUserNo(ToClient_GetMessageListById(messangerId):getUserNo(), messanger._ui._editInputChat:GetEditText(), CppEnums.ChatType.Friend)
  if 0 == rv then
    ToClient_GetMessageListById(messangerId):pushFromMessage(messanger._ui._editInputChat:GetEditText())
  end
  messanger._ui._editInputChat:SetEditText("", true)
end
function PaGlobal_FriendMessanger:UpdateLogOnOff(messangerId, isOnline)
  local messanger = self._messangerList[messangerId]
  if messangerId == self._currentFocusId and -1 ~= messangerId then
    self._currentFocusId = -1
    ClearFocusEdit()
    CheckChattingInput()
  end
  if nil ~= messanger then
    if 1 == isOnline then
      messanger._ui._editInputChat:SetEnable(true)
      messanger._ui._enterBtn:SetEnable(true)
    else
      messanger._ui._editInputChat:SetEnable(false)
      messanger._ui._enterBtn:SetEnable(false)
    end
  end
end
function FromClient_KillFocusMessanger()
  FGlobal_FriendMessanger_KillFocusEdit()
end
function FromClient_UpdateFriendMessanger(messangerId)
  local friendMesaageList = ToClient_GetMessageListById(messangerId)
  local message = friendMesaageList:beginMessage()
  local messanger = PaGlobal_FriendMessanger._messangerList[messangerId]
  if nil == messanger then
    return
  end
  if 0 < messanger._messageCount then
    messanger:ClearAllMessage()
  end
  while message ~= nil do
    messanger:UpdateMessage(message)
    message = friendMesaageList:nextMessage()
  end
  messanger._ui._frame:UpdateContentScroll()
  messanger._ui._frameScroll:SetControlBottom()
  messanger._ui._frame:UpdateContentPos()
  messanger._ui._frameScroll:GetControlButton():SetPosX(-3)
end
function FromClient_OpenMessanger(messangerId, userName, isOnline)
  if nil == PaGlobal_FriendMessanger._messangerList[messangerId] then
    PaGlobal_FriendMessanger._messangerList[messangerId] = PaGlobal_FriendMessanger:CreateMessanger(messangerId, userName, isOnline)
  end
  if isOnline then
    PaGlobal_FriendMessanger:SetFocusEdit(messangerId)
  end
  FGlobal_FriendList_UpdateList()
  FromClient_UpdateFriendMessanger(messangerId)
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
    FGlobal_FriendList_UpdateList()
    PaGlobal_FriendMessanger:UpdateLogOnOff(param2, param1)
  end
end
registerEvent("FromClient_GroundMouseClick", "FromClient_KillFocusMessanger")
registerEvent("FromClient_UpdateFriendMessanger", "FromClient_UpdateFriendMessanger")
registerEvent("FromClient_OpenMessanger", "FromClient_OpenMessanger")
registerEvent("FromClient_NotifyFriendMessage", "FromClient_NotifyFriendMessage")

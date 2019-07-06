local _OUT_PARTY = not ToClient_IsDevelopment()
local _panel = LobbyInstance_RoomMessageBox
local RoomMessageBox = {
  eMessageType = {makeRoom = 0, joinRoom = 1},
  ePlayType = {solo = 0, party = 1},
  _ui = {},
  _panelBasicSizeX = _panel:GetSizeX(),
  _panelBasicSizeY = _panel:GetSizeY(),
  _btnBasicApplyPosY = 0,
  _btnBasicCancelPosY = 0,
  _stcBasicRoomInfoPosY = 0,
  _stcTextBasicPosY = 0,
  _messageType = nil,
  _minIDCheck = 4,
  _maxIDCheck = 10,
  _minPWCheck = 4,
  _maxPWCheck = 6,
  _isSoloPlay = false
}
function RoomMessageBox:initialize()
  self._ui.stc_blockBG = UI.getChildControl(_panel, "Static_BlockBG")
  self._ui.stc_textTitle = UI.getChildControl(_panel, "Static_Text_Title")
  self._ui.btn_apply = UI.getChildControl(_panel, "Button_Apply")
  self._ui.btn_cancel = UI.getChildControl(_panel, "Button_Cancel")
  self._ui.btn_close = UI.getChildControl(_panel, "Button_Close")
  self._ui.stc_roomInfo = UI.getChildControl(_panel, "Static_RoomInfo")
  self._ui.stc_image = UI.getChildControl(_panel, "Static_Image")
  self._ui.stc_mapName = UI.getChildControl(self._ui.stc_image, "StaticText_MapName")
  self._ui.stc_imageBlue = UI.getChildControl(_panel, "Static_ImageBlue")
  self._ui.stc_text = UI.getChildControl(_panel, "Static_Text")
  self._ui.edit_roomId = UI.getChildControl(self._ui.stc_roomInfo, "Edit_RoomId")
  self._ui.edit_password = UI.getChildControl(self._ui.stc_roomInfo, "Edit_Password")
  self._ui.stc_inputShield = UI.getChildControl(self._ui.stc_roomInfo, "Static_InputShield")
  self._ui.stc_typeToggle = UI.getChildControl(_panel, "Static_TypeToggle")
  self._ui.rdo_soloPlay = UI.getChildControl(self._ui.stc_typeToggle, "RadioButton_Solo")
  self._ui.rdo_partyPlay = UI.getChildControl(self._ui.stc_typeToggle, "RadioButton_Party")
  self._ui.txt_typeDesc = UI.getChildControl(self._ui.stc_typeToggle, "StaticText_TypeDesc")
  self._ui.edit_roomId:SetMaxInput(self._maxIDCheck)
  self._ui.edit_password:SetMaxInput(self._maxPWCheck)
  self._ui.edit_password:SetSafeMode(true)
  if _OUT_PARTY then
    self._ui.rdo_soloPlay:SetShow(false)
    self._ui.rdo_soloPlay:SetIgnore(true)
    self._ui.rdo_partyPlay:SetShow(false)
    self._ui.rdo_partyPlay:SetEnable(false)
    self._ui.rdo_partyPlay:SetMonoTone(true)
    self._ui.rdo_partyPlay:SetIgnore(true)
    self._ui.txt_typeDesc:SetShow(true)
  end
  self._btnBasicApplyPosY = self._ui.btn_apply:GetPosY()
  self._btnBasicCancelPosY = self._ui.btn_cancel:GetPosY()
  self._stcBasicRoomInfoPosY = self._ui.stc_roomInfo:GetPosY()
  self._stcTextBasicPosY = self._ui.stc_text:GetPosY()
  self._stcBasicTypeToglePosY = self._ui.stc_typeToggle:GetPosY()
  self._ui.rdo_soloPlay:SetCheck(true)
  self._isSoloPlay = true
  self:registEventHandler()
end
function RoomMessageBox:registEventHandler()
  registerEvent("onScreenResize", "FromClient_RoomMessageBox_ScreenResize")
  self._ui.btn_apply:addInputEvent("Mouse_LUp", "PaGlobalFunc_RoomMessageBox_ButtonClickApply()")
  self._ui.btn_cancel:addInputEvent("Mouse_LUp", "PaGlobalFunc_RoomMessageBox_ButtonClickCancel()")
  self._ui.btn_close:addInputEvent("Mouse_LUp", "PaGlobalFunc_RoomMessageBox_ButtonClickCancel()")
  self._ui.stc_inputShield:addInputEvent("Mouse_LUp", "PaGlobalFunc_RoomMessageBox_EditPasswordClick()")
  self._ui.rdo_soloPlay:addInputEvent("Mouse_LUp", "PaGlobalFunc_RoomMessageBox_PlayTypeToggle(" .. self.ePlayType.solo .. ")")
  self._ui.rdo_partyPlay:addInputEvent("Mouse_LUp", "PaGlobalFunc_RoomMessageBox_PlayTypeToggle(" .. self.ePlayType.party .. ")")
end
function RoomMessageBox:show(eMessageType)
  local strTitle, btnTitle
  if self.eMessageType.makeRoom == eMessageType then
    strTitle = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ROOMMESSAGE_MAKE")
    btnTitle = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LOBBY_CREATE")
  elseif self.eMessageType.joinRoom == eMessageType then
    strTitle = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ROOMMESSAGE_ENTER")
    btnTitle = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LOCALWARINFO_JOIN_BTN")
  end
  self._messageType = eMessageType
  self._ui.stc_textTitle:SetText(strTitle)
  self._ui.btn_apply:SetText(btnTitle)
  self:showType(eMessageType)
  self:open()
end
function RoomMessageBox:reset()
  self._ui.edit_roomId:SetEditText("")
  self._ui.edit_password:SetEditText("")
  if true == self._ui.edit_roomId:GetFocusEdit() or true == self._ui.edit_password:GetFocusEdit() then
    ClearFocusEdit()
  end
end
function RoomMessageBox:showType(eMessageType, isShow)
  local addImageSizeY = self._ui.stc_image:GetSizeY()
  if self.eMessageType.makeRoom == eMessageType or true == isShow then
    self._ui.stc_image:SetShow(true)
    self._ui.stc_imageBlue:SetShow(true)
    self._ui.btn_apply:SetPosY(self._btnBasicApplyPosY + addImageSizeY)
    self._ui.btn_cancel:SetPosY(self._btnBasicApplyPosY + addImageSizeY)
    self._ui.stc_roomInfo:SetPosY(self._stcBasicRoomInfoPosY + addImageSizeY)
    self._ui.stc_text:SetPosY(self._stcTextBasicPosY + addImageSizeY)
    self._ui.stc_typeToggle:SetPosY(self._stcBasicTypeToglePosY + addImageSizeY)
    _panel:SetSize(_panel:GetSizeX(), self._panelBasicSizeY + addImageSizeY)
  elseif self.eMessageType.joinRoom == eMessageType or false == isShow then
    self._ui.stc_image:SetShow(false)
    self._ui.stc_imageBlue:SetShow(false)
    self._ui.btn_apply:SetPosY(self._btnBasicApplyPosY)
    self._ui.btn_cancel:SetPosY(self._btnBasicApplyPosY)
    self._ui.stc_roomInfo:SetPosY(self._stcBasicRoomInfoPosY)
    self._ui.stc_text:SetPosY(self._stcTextBasicPosY)
    self._ui.stc_typeToggle:SetPosY(self._stcBasicTypeToglePosY)
    _panel:SetSize(self._panelBasicSizeX, self._panelBasicSizeY)
  end
end
function RoomMessageBox:makeRoom()
  local roomId = self._ui.edit_roomId:GetEditText()
  local password = self._ui.edit_password:GetEditText()
  local whereType, slotNo = self:getFindPrivateGameTicket()
  if slotNo < 0 then
    local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ROOM_TICKET_TITLE")
    local messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ROOM_TICKET_DESC")
    local messageBoxData = {
      title = messageTitle,
      content = messageContent,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if false == self:isCheckIdAndPassword(roomId, password) then
    return
  end
  if true == self._isSoloPlay then
    if false == self:isCheckCanSoloPlay() then
      return
    end
    ToClient_MakeBattleRoyalPrivateRoom(roomId, password, whereType, slotNo)
  else
    if false == self:isCheckCanPartyPlay() then
      return
    end
    ToClient_MakeBattleRoyalPartyPrivateRoom(roomId, password, whereType, slotNo)
  end
  PaGlobalFunc_RoomMessageBox_ButtonClickCancel()
end
function RoomMessageBox:joinRoom()
  local roomId = self._ui.edit_roomId:GetEditText()
  local password = self._ui.edit_password:GetEditText()
  if false == self:isCheckIdAndPassword(roomId, password) then
    return
  end
  if true == self._isSoloPlay then
    if false == self:isCheckCanSoloPlay() then
      return
    end
    ToClient_EnterBattleRoyalPrivateRoom(roomId, password)
  else
    if false == self:isCheckCanPartyPlay() then
      return
    end
    ToClient_EnterBattleRoyalPartyPrivateRoom(roomId, password)
  end
  PaGlobalFunc_RoomMessageBox_ButtonClickCancel()
end
function RoomMessageBox:isCheckCanSoloPlay()
  local partyCount = RequestParty_getPartyMemberCount()
  if partyCount > 0 then
    local partyTitle = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ROOM_TICKET_TITLE")
    local partyContent = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ROOM_PARTY_NOT_IN")
    local partyBoxData = {
      title = partyTitle,
      content = partyContent,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(partyBoxData)
    return false
  end
  return true
end
function RoomMessageBox:isCheckCanPartyPlay()
  local partyCount = RequestParty_getPartyMemberCount()
  if partyCount > 0 then
    for i = 0, partyCount - 1 do
      if RequestParty_isSelfPlayer(i) then
        local data = RequestParty_getPartyMemberAt(i)
        if false == data._isMaster then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_NOPARTYBOSS"))
          return false
        end
        break
      end
    end
    if partyCount > 3 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_PARTYPLAY_MAX"))
      return false
    end
  end
  return true
end
function RoomMessageBox:open()
  _panel:SetShow(true)
end
function RoomMessageBox:close()
  _panel:SetShow(false)
end
function RoomMessageBox:update()
end
function RoomMessageBox:resize()
  self._ui.stc_blockBG:SetSize(getScreenSizeX() + 500, getScreenSizeY() + 500)
  self._ui.stc_blockBG:ComputePos()
  self._ui.stc_textTitle:ComputePos()
  self._ui.btn_apply:ComputePos()
  self._ui.btn_cancel:ComputePos()
  self._ui.btn_close:ComputePos()
  self._ui.stc_image:ComputePos()
  self._ui.stc_roomInfo:ComputePos()
  self:showType(nil, self._ui.stc_image:GetShow())
end
function FromClient_RoomMessageBox_Init()
  local self = RoomMessageBox
  self:initialize()
end
function FromClient_RoomMessageBox_ScreenResize()
  local self = RoomMessageBox
  self:resize()
end
function PaGlobalFunc_RoomMessageBox_ShowMakeRoom()
  local self = RoomMessageBox
  self:show(self.eMessageType.makeRoom)
end
function PaGlobalFunc_RoomMessageBox_ShowJoinRoom()
  local self = RoomMessageBox
  self:show(self.eMessageType.joinRoom)
end
function PaGlobalFunc_RoomMessageBox_ButtonClickApply()
  local self = RoomMessageBox
  if self.eMessageType.makeRoom == self._messageType then
    self:makeRoom()
  elseif self.eMessageType.joinRoom == self._messageType then
    self:joinRoom()
  end
end
function PaGlobalFunc_RoomMessageBox_ButtonClickCancel()
  local self = RoomMessageBox
  self:reset()
  self:close()
end
function PaGlobalFunc_RoomMessageBox_EditPasswordClick()
  local self = RoomMessageBox
  RoomPassword_Open(self._ui.edit_password)
end
function PaGlobalFunc_RoomMessageBox_GetPasswordPos()
  local self = RoomMessageBox
  local posX, posY
  posX = _panel:GetPosX() + self._ui.stc_roomInfo:GetPosX() + self._ui.edit_password:GetPosX() + self._ui.edit_password:GetSizeX() + 10
  posY = _panel:GetPosY() + self._ui.stc_roomInfo:GetPosY() - 20
  return posX, posY
end
function RoomMessageBox:PlayTypeToggle(eType)
  if self.ePlayType.solo == eType then
    self._isSoloPlay = true
  elseif self.ePlayType.party == eType then
    self._isSoloPlay = false
  end
end
function PaGlobalFunc_RoomMessageBox_PlayTypeToggle(eType)
  RoomMessageBox:PlayTypeToggle(eType)
end
function RoomMessageBox:getFindPrivateGameTicket()
  local slotNo = 0
  local whereTable = {
    CppEnums.ItemWhereType.eInventory
  }
  local count = #whereTable
  for i = 1, count do
    slotNo = ToClient_GetBattleRoyalePrivateGameTicket(whereTable[i])
    if CppEnums.TInventorySlotNoUndefined ~= slotNo then
      return whereTable[i], slotNo
    end
  end
  return -1, -1
end
function PaGlobal_FindPrivateGameTicket()
  return RoomMessageBox:getFindPrivateGameTicket()
end
function RoomMessageBox:isCheckIdAndPassword(id, password)
  if string.len(id) < self._minIDCheck then
    local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ROOM_TICKET_TITLE")
    local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ROOM_ID_MIN_DESC", "min", self._minIDCheck)
    local messageBoxData = {
      title = messageTitle,
      content = messageContent,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return false
  end
  if string.len(password) < self._minPWCheck then
    local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ROOM_TICKET_TITLE")
    local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ROOM_PW_MIN_DESC", "min", self._minPWCheck)
    local messageBoxData = {
      title = messageTitle,
      content = messageContent,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return false
  end
  return true
end
registerEvent("FromClient_luaLoadComplete", "FromClient_RoomMessageBox_Init")

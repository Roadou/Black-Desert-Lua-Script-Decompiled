local _panel = Instance_RoomMemberList
local roomMemberList = {
  _ui = {
    btn_closeIcon = UI.getChildControl(_panel, "Button_CloseIcon"),
    list_roomMember = UI.getChildControl(_panel, "List2_MemberList")
  },
  _myName = ""
}
function roomMemberList:initialize()
  self._myName = getSelfPlayer():getUserNickname()
  self:registEventHandler()
  self:memberListRefresh()
end
function roomMemberList:memberListRefresh()
  local memberList = self._ui.list_roomMember
  local toIndex = memberList:getCurrenttoIndex()
  local count = ToClient_GetBattleRoyaleSuvivorCount()
  memberList:getElementManager():clearKey()
  for index = 1, count do
    memberList:getElementManager():pushKey(toInt64(0, index - 1))
  end
  if toIndex >= count then
    toIndex = count - 1
  end
  memberList:setCurrenttoIndex(toIndex)
end
function roomMemberList:createControl(control, key)
  local idx = Int64toInt32(key)
  local txt_memberName = UI.getChildControl(control, "List2_MemberList_Name")
  local btn_kickOut = UI.getChildControl(control, "Button_KickOut")
  local name = ToClient_GetBattleRoyaleSurvivorName(idx)
  local isSelf = self._myName == name
  txt_memberName:SetText(name)
  if isSelf then
    btn_kickOut:SetShow(false)
  else
    btn_kickOut:SetShow(true)
    btn_kickOut:addInputEvent("Mouse_LUp", "InputMLUp_roomMemberList_KickOut(" .. idx .. ")")
  end
end
function roomMemberList:kickOut(idx)
  local name = ToClient_GetBattleRoyaleSurvivorName(idx)
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_TITLE")
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_ROOMMEBER_KICKOUT", "name", name)
  local function goToKick()
    ToClient_BattleRoyaleKickPlayer(idx)
  end
  local messageBoxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = goToKick,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function roomMemberList:registEventHandler()
  self._ui.list_roomMember:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_roomMemberList_CreateControl")
  self._ui.list_roomMember:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.btn_closeIcon:addInputEvent("Mouse_LUp", "PaGlobalFunc_roomMemberList_Close()")
  registerEvent("onScreenResize", "FromClient_roomMemberList_ScreenResize")
  registerEvent("FromClient_SurvivorListChanged", "FromClient_roomMemberList_SurvivorListChanged")
end
function roomMemberList:open()
  _panel:SetShow(true)
end
function roomMemberList:close()
  _panel:SetShow(false)
end
function roomMemberList:update()
end
function roomMemberList:resize()
  _panel:SetPosX(getScreenSizeX() - Instance_Widget_Leave:GetSizeX() - _panel:GetSizeX() - 20)
  _panel:SetPosY(getScreenSizeY() - _panel:GetSizeY() - 5)
end
function FromClient_roomMemberList_Init()
  local self = roomMemberList
  self:initialize()
end
function FromClient_roomMemberList_ScreenResize()
  local self = roomMemberList
  self:resize()
end
function PaGlobalFunc_roomMemberList_Open()
  local self = roomMemberList
  self:open()
end
function PaGlobalFunc_roomMemberList_Close()
  local self = roomMemberList
  self:close()
end
function PaGlobalFunc_roomMemberList_CreateControl(control, key)
  local self = roomMemberList
  self:createControl(control, key)
end
function InputMLUp_roomMemberList_KickOut(idx)
  local self = roomMemberList
  self:kickOut(idx)
end
function FromClient_roomMemberList_SurvivorListChanged()
  local self = roomMemberList
  self:memberListRefresh()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_roomMemberList_Init")

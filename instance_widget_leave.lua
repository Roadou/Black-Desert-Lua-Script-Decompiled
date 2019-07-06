local _MEMBER_LIST_OUT = false
Instance_Widget_Leave:SetShow(false)
local WidgetLeave = {
  _ui = {},
  _isGameStart = false,
  _battleState = 0,
  _isSendLeave = false
}
function WidgetLeave:open()
  if _panel:GetShow() == true then
    self:close()
    return
  end
  _panel:SetShow(true)
end
function WidgetLeave:close()
  _panel:SetShow(false)
end
function WidgetLeave:update()
end
function WidgetLeave:resize()
end
function WidgetLeave:isMaster()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return false
  end
  return selfPlayer:get():getUserNo() == ToClient_GetBattleRoyalePrivateGameHost()
end
function WidgetLeave:isTrainingRoom()
  return ToClient_IsBattleRoyaleTrainingRoom()
end
function WidgetLeave:updateButton()
  if __eBattleRoyaleState_Playing == ToClient_CurrentBattleRoyaleState() or __eBattleRoyaleState_Register == ToClient_CurrentBattleRoyaleState() then
    self._ui.buttonStart:SetShow(false)
    return
  end
  if true == self:isMaster() then
    self._ui.buttonStart:SetShow(true)
  elseif true == self:isTrainingRoom() then
    self._ui.buttonStart:SetShow(true)
    self._ui.buttonStart:AddEffect("UI_ArrowMark02", true, 50, -10)
  else
    self._ui.buttonStart:SetShow(false)
  end
end
function WidgetLeave:updateMemberListButton()
  if _MEMBER_LIST_OUT then
    self._ui.buttonMemberList:SetShow(false)
    return
  end
  self._ui.buttonMemberList:SetShow(self:isMaster())
  if 0 ~= self._battleState then
    self._ui.buttonMemberList:SetSpanSize(0, self._ui.buttonStart:GetSpanSize().y)
  end
end
function WidgetLeave:registEventHandler()
  registerEvent("onScreenResize", "FromClient_WidgetLeave_ScreenResize")
  registerEvent("FromClient_BattleRoyaleStateChanged", "FromClient_WidgetLeave_BattleRoyaleStateChanged")
  registerEvent("FromClient_ClassChangeBattleRoyale", "PaGlobal_WidgetLeave_FromClient_ClassChangeBattleRoyale")
  registerEvent("FromClient_ExitInstanceField", "FromClient_WidgetLeave_ExitInstanceField")
  self._ui.buttonLeave:addInputEvent("Mouse_LUp", "PaGlobal_Leave_Out()")
  self._ui.buttonStart:addInputEvent("Mouse_LUp", "InputMLUp_WidgetLeave_GameStart()")
  self._ui.buttonBlackSpirit:addInputEvent("Mouse_LUp", "InputMLUp_WidgetLeave_SetBlackSpirit()")
  if false == _MEMBER_LIST_OUT then
    self._ui.buttonMemberList:addInputEvent("Mouse_LUp", "InputMLUp_WidgetLeave_MemberList()")
  end
end
function FromClient_WidgetLeave_Init()
  local self = WidgetLeave
  Instance_Widget_Leave:SetShow(true)
  self._ui.buttonLeave = UI.getChildControl(Instance_Widget_Leave, "Button_Leave")
  self._ui.buttonStart = UI.getChildControl(Instance_Widget_Leave, "Button_GameStart")
  self._ui.buttonMemberList = UI.getChildControl(Instance_Widget_Leave, "Button_MemberList")
  self._ui.buttonBlackSpirit = UI.getChildControl(Instance_Widget_Leave, "Button_BlackSpirit")
  self._ui.buttonBlackSpirit:SetShow(false)
  self:updateButton()
  self:updateMemberListButton()
  self:registEventHandler()
end
function FromClient_WidgetLeave_ScreenResize()
  local self = WidgetLeave
  self:resize()
end
function PaGlobal_Leave_Out()
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_TITLE")
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_BEFORE_LOBBY")
  local messageBoxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = PaGlobal_Direct_Leave_Out,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_Direct_Leave_Out()
  local self = WidgetLeave
  if true == self._isSendLeave then
    return
  end
  ToClient_ExitBattleRoyale()
  PaGlobal_WidgetLeave_MessageBox_WaitProcess()
  self._isSendLeave = true
end
function PaGlobal_WidgetLeave_GetIsStart()
  local self = WidgetLeave
  if nil == self then
    return false
  end
  return self._isGameStart
end
function PaGlobal_WidgetLeave_FromClient_ClassChangeBattleRoyale()
  local self = WidgetLeave
  if true == self then
    return
  end
  if true == self:isTrainingRoom() then
    local selfPlayer = getSelfPlayer()
    local classType = selfPlayer:getClassType()
    if classType == CppEnums.ClassType.ClassType_Temp1 then
      self._ui.buttonBlackSpirit:SetShow(false)
    else
      self._ui.buttonBlackSpirit:SetShow(true)
    end
  end
end
function InputMLUp_WidgetLeave_GameStart()
  local self = WidgetLeave
  if nil == self then
    return
  end
  if false == PaGlobalFunc_PrivateTimeMessage_GetIsStart() then
    ToClient_StartBattleRoyalPrivateRoom()
  end
  WidgetLeave._ui.buttonStart:SetShow(false)
  self._isGameStart = true
  self._battleState = self._battleState + 1
  self:updateMemberListButton()
end
function InputMLUp_WidgetLeave_MemberList()
  if nil == PaGlobalFunc_roomMemberList_Open then
    return
  end
  PaGlobalFunc_roomMemberList_Open()
end
function InputMLUp_WidgetLeave_SetBlackSpirit()
  local selfPlayer = getSelfPlayer()
  local classType = selfPlayer:getClassType()
  if classType == CppEnums.ClassType.ClassType_Temp1 then
  else
    ToClient_classChange(CppEnums.ClassType.ClassType_Temp1)
  end
end
function FromClient_WidgetLeave_BattleRoyaleStateChanged(state)
  local self = WidgetLeave
  self._battleState = state
  if 0 == state then
    self:updateButton()
    self:updateMemberListButton()
    return
  end
  WidgetLeave._ui.buttonStart:SetShow(false)
  self:updateMemberListButton()
end
function FromClient_WidgetLeave_ExitInstanceField()
  local self = WidgetLeave
  if 0 ~= self._battleState then
    return
  end
  if toInt64(0, -1) == ToClient_GetBattleRoyalePrivateGameHost() then
    return
  end
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoBattleRoyalePrivageGameDropped"))
end
function PaGlobal_WidgetLeave_MessageBox_WaitProcess()
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_WAIT_PROCESS"),
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_0
  }
  MessageBox.showMessageBox(messageBoxData)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_WidgetLeave_Init")

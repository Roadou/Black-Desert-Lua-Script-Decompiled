local _panel = LobbyInstance_Widget_Leave
_panel:SetShow(false)
local widgetLeave = {
  _ui = {
    stc_BottomGroup = UI.getChildControl(_panel, "Static_BottomGroup")
  },
  buttonTooltipTitleKey = {
    [0] = "PANEL_BATTLEROYAL_GAME_OPTION",
    [1] = "PANEL_PARTYLIST_TITLE",
    [2] = "PANEL_BATTLEROYALRANK_TITLE",
    [3] = "PANEL_INSTANCE_REWARDLIST_TOOLTIPTITLE"
  },
  btn_withTooltip = {}
}
widgetLeave.btn_withTooltip = {
  [0] = UI.getChildControl(widgetLeave._ui.stc_BottomGroup, "Button_Option"),
  [1] = UI.getChildControl(widgetLeave._ui.stc_BottomGroup, "Button_PartyInvite"),
  [2] = UI.getChildControl(widgetLeave._ui.stc_BottomGroup, "Button_Rank"),
  [3] = UI.getChildControl(widgetLeave._ui.stc_BottomGroup, "Button_RewardList")
}
function PaGlobal_Leave_Init()
  _panel:SetShow(true)
  local self = widgetLeave
  local buttonLeave = UI.getChildControl(_panel, "Button_Leave")
  local buttonSoloPlay = UI.getChildControl(_panel, "Button_SoloPlay")
  local buttonPartyPlay = UI.getChildControl(_panel, "Button_PartyPlay")
  local buttonTrainingPlay = UI.getChildControl(_panel, "Button_TrainingPlay")
  local buttonJoinRoom = UI.getChildControl(_panel, "Button_EnterSecret")
  local buttonMakeRoom = UI.getChildControl(_panel, "Button_MakeRoom")
  buttonLeave:addInputEvent("Mouse_LUp", "PaGlobal_Leave_Out()")
  buttonSoloPlay:addInputEvent("Mouse_LUp", "PaGlobal_Leave_MessageBox_SoloPlay()")
  buttonPartyPlay:addInputEvent("Mouse_LUp", "PaGlobal_Leave_MessageBox_PartyPlay()")
  buttonTrainingPlay:addInputEvent("Mouse_LUp", "PaGlobal_Leave_MessageBox_TrainingPlay()")
  buttonJoinRoom:addInputEvent("Mouse_LUp", "PaGlobal_Leave_RoomJoin()")
  buttonMakeRoom:addInputEvent("Mouse_LUp", "PaGlobal_Leave_RoomMake()")
  buttonTrainingPlay:SetShow(true)
  local buttonOption = self.btn_withTooltip[0]
  buttonOption:addInputEvent("Mouse_LUp", "showGameOption()")
  local buttonPartyInvite = self.btn_withTooltip[1]
  buttonPartyInvite:addInputEvent("Mouse_LUp", "FGlobal_PartyList_ShowToggle()")
  local buttonRanking = self.btn_withTooltip[2]
  buttonRanking:addInputEvent("Mouse_LUp", "PaGlobalFunc_BattleRoyalRank_Open()")
  local buttonRewardList = self.btn_withTooltip[3]
  buttonRewardList:addInputEvent("Mouse_LUp", "PaGlobal_RewardList_Open()")
  for i = 0, table.getn(self.btn_withTooltip) do
    self.btn_withTooltip[i]:addInputEvent("Mouse_On", "WidgetLeave_Button_ShowToolTip(" .. i .. ")")
    self.btn_withTooltip[i]:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  end
  local whereType, slotNo = PaGlobal_FindPrivateGameTicket()
  if true == buttonTrainingPlay:GetShow() then
    if slotNo < 0 then
      buttonMakeRoom:SetShow(false)
      buttonSoloPlay:SetSpanSize(0, 200)
      buttonPartyPlay:SetSpanSize(0, 150)
      buttonTrainingPlay:SetSpanSize(0, 100)
      buttonJoinRoom:SetSpanSize(0, 50)
      buttonMakeRoom:SetSpanSize(0, 100)
    else
      buttonSoloPlay:SetSpanSize(0, 250)
      buttonPartyPlay:SetSpanSize(0, 200)
      buttonTrainingPlay:SetSpanSize(0, 150)
      buttonJoinRoom:SetSpanSize(0, 100)
      buttonMakeRoom:SetSpanSize(0, 50)
      buttonMakeRoom:SetShow(true)
    end
  elseif slotNo < 0 then
    buttonMakeRoom:SetShow(false)
    buttonSoloPlay:SetSpanSize(0, 150)
    buttonPartyPlay:SetSpanSize(0, 100)
    buttonTrainingPlay:SetSpanSize(0, 100)
    buttonJoinRoom:SetSpanSize(0, 50)
    buttonMakeRoom:SetSpanSize(0, 100)
  else
    buttonSoloPlay:SetSpanSize(0, 200)
    buttonPartyPlay:SetSpanSize(0, 150)
    buttonTrainingPlay:SetSpanSize(0, 150)
    buttonJoinRoom:SetSpanSize(0, 100)
    buttonMakeRoom:SetSpanSize(0, 50)
    buttonMakeRoom:SetShow(true)
  end
  self._ui.txt_makeRoom = UI.getChildControl(buttonMakeRoom, "StaticText_MakeRoomTitle")
  self._ui.txt_joinRoom = UI.getChildControl(buttonJoinRoom, "StaticText_EnterTitle")
  UI.setLimitTextAndAddTooltip(self._ui.txt_makeRoom)
  UI.setLimitTextAndAddTooltip(self._ui.txt_joinRoom)
  if false == ToClient_isInstanceFieldMainServer() then
    buttonSoloPlay:SetShow(false)
    buttonPartyPlay:SetShow(false)
    buttonTrainingPlay:SetShow(false)
    buttonJoinRoom:SetShow(false)
    buttonMakeRoom:SetShow(false)
    buttonOption:SetShow(false)
    buttonPartyInvite:SetShow(false)
    buttonRanking:SetShow(false)
    buttonRewardList:SetShow(false)
  end
end
function PaGlobal_Leave_Out()
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_TITLE")
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_BEFORE_SERVER")
  local goToMove = function()
    ToClient_RequestBattleRoyaleExitToBeforeServer()
  end
  local messageBoxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = goToMove,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_Leave_SoloPlay()
  local selectBettingKeyData = ToClient_GetBettingScoreKey(0)
  if nil == selectBettingKeyData then
    return
  end
  ToClient_BattleRoyaleJoinQueue(__eBattleRoyaleMode_Solo, selectBettingKeyData)
end
function PaGlobal_Leave_PartyPlay()
  local partyCount = RequestParty_getPartyMemberCount()
  if partyCount > 0 then
    for i = 0, partyCount - 1 do
      if RequestParty_isSelfPlayer(i) then
        local data = RequestParty_getPartyMemberAt(i)
        if false == data._isMaster then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_NOPARTYBOSS"))
          return
        end
        break
      end
    end
    if partyCount > 3 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_PARTYPLAY_MAX"))
      return
    end
  end
  local selectBettingKeyData = ToClient_GetBettingScoreKey(0)
  if nil == selectBettingKeyData then
    return
  end
  ToClient_BattleRoyaleJoinQueue(__eBattleRoyaleMode_Team, selectBettingKeyData)
end
function PaGlobal_Leave_TrainingPlay()
  local selectBettingKeyData = ToClient_GetBettingScoreKey(0)
  if nil == selectBettingKeyData then
    return
  end
  ToClient_BattleRoyaleJoinQueue(__eBattleRoyaleMode_Training, selectBettingKeyData)
end
function PaGlobal_Leave_RoomJoin()
  PaGlobalFunc_RoomMessageBox_ShowJoinRoom()
end
function PaGlobal_Leave_RoomMake()
  PaGlobalFunc_RoomMessageBox_ShowMakeRoom()
end
function PaGlobal_Leave_PartyMessageCheck()
  local partyCount = RequestParty_getPartyMemberCount()
  if partyCount < 3 then
    FGlobal_PartyList_ShowToggle()
  end
end
function PaGlobal_Leave_MessageBox_SoloPlay()
  local messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_SOLOPLAY_MSG")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_BATTLEROYAL_ENTER"),
    content = messageContent,
    functionYes = PaGlobal_Leave_SoloPlay,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_Leave_MessageBox_PartyPlay()
  local messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_PARTYPLAY_MSG")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_BATTLEROYAL_ENTER"),
    content = messageContent,
    functionYes = PaGlobal_Leave_PartyPlay,
    functionNo = PaGlobal_Leave_PartyMessageCheck,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_Leave_MessageBox_TrainingPlay()
  local messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_TRAINING_MSG")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_BATTLEROYAL_ENTER"),
    content = messageContent,
    functionYes = PaGlobal_Leave_TrainingPlay,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function WidgetLeave_Button_ShowToolTip(tooltipIndex)
  local self = widgetLeave
  local tooltipText = PAGetString(Defines.StringSheet_RESOURCE, self.buttonTooltipTitleKey[tooltipIndex])
  TooltipSimple_Show(self.btn_withTooltip[tooltipIndex], tooltipText)
end
function FromClient_MatchingTestAck(type, param0, param1, param2)
  if 0 == type then
    Proc_ShowMessage_Ack("\236\158\152\235\170\187\235\144\156 \235\170\133\235\160\185\236\150\180\235\165\188 \236\158\133\235\160\165!!")
  elseif 1 == type then
    Proc_ShowMessage_Ack(string.format("\236\181\156\235\140\128\236\157\184\236\155\144 \235\179\128\234\178\189 : %s", param0))
  elseif 2 == type then
    Proc_ShowMessage_Ack(string.format("[\235\167\164\236\185\173\235\167\164\235\139\136\236\160\128] \236\132\156\235\178\132 \235\178\136\237\152\184 : %s, \237\152\132\236\158\172 \236\157\184\236\155\144 \236\136\152 : %s, \236\181\156\235\140\128 \236\157\184\236\155\144 \236\136\152 : %s", param0, param1, param2))
  elseif 3 == type then
    Proc_ShowMessage_Ack(string.format("\237\152\132\236\158\172 \236\132\156\235\178\132 \235\178\136\237\152\184 : %s", param0))
  elseif 4 == type then
    Proc_ShowMessage_Ack(string.format("[\236\167\132\236\167\156] \236\132\156\235\178\132 \235\178\136\237\152\184 : %s, \236\134\148\235\161\156 \236\157\184\236\155\144 \236\136\152 : %s, \237\140\140\237\139\176 \236\157\184\236\155\144 \236\136\152 : %s", param0, param1, param2))
  else
    Proc_ShowMessage_Ack("\236\158\152\235\170\187\235\144\156 \235\170\133\235\160\185\236\150\180\235\165\188 \236\158\133\235\160\165!!")
  end
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_Leave_Init")
registerEvent("FromClient_MatchingTestAck", "FromClient_MatchingTestAck")

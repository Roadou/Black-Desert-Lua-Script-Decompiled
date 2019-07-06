local Panel_Window_LocalWarInfo_info = {
  _ui = {
    static_MainTitleBar = nil,
    staticText_Icon = nil,
    static_BottomBG = nil,
    staticText_A_ConsoleUI = nil,
    staticText_B_ConsoleUI = nil,
    staticText_Y_ConsoleUI = nil,
    static_MainBg = nil,
    list2_ServerList = nil
  },
  _value = {localWarServerCount = 0},
  _config = {},
  _enum = {}
}
function Panel_Window_LocalWarInfo_info:registEventHandler()
end
function Panel_Window_LocalWarInfo_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_LocalWarInfo_Resize")
  registerEvent("FromClient_UpdateLocalWarStatus", "FromClient_LocalWarInfo_UpdateLocalWarStatus")
  self._ui.list2_ServerList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_LocalWarInfo_Server_List")
  self._ui.list2_ServerList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function Panel_Window_LocalWarInfo_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_LocalWarInfo_info:initValue()
  self._value.localWarServerCount = 0
end
function Panel_Window_LocalWarInfo_info:resize()
  Panel_LocalWarInfo:ComputePos()
end
function Panel_Window_LocalWarInfo_info:childControl()
  self._ui.static_MainTitleBar = UI.getChildControl(Panel_LocalWarInfo, "Static_MainTitleBar")
  self._ui.staticText_Icon = UI.getChildControl(self._ui.static_MainTitleBar, "StaticText_Icon")
  self._ui.static_BottomBG = UI.getChildControl(Panel_LocalWarInfo, "Static_BottomBG")
  self._ui.staticText_A_ConsoleUI = UI.getChildControl(self._ui.static_BottomBG, "StaticText_A_ConsoleUI")
  self._ui.staticText_B_ConsoleUI = UI.getChildControl(self._ui.static_BottomBG, "StaticText_B_ConsoleUI")
  self._ui.staticText_Y_ConsoleUI = UI.getChildControl(self._ui.static_BottomBG, "StaticText_Y_ConsoleUI")
  self._ui.static_MainBg = UI.getChildControl(Panel_LocalWarInfo, "Static_MainBg")
  self._ui.list2_ServerList = UI.getChildControl(self._ui.static_MainBg, "List2_ServerList")
  local keyGuides = {
    self._ui.staticText_Y_ConsoleUI,
    self._ui.staticText_A_ConsoleUI,
    self._ui.staticText_B_ConsoleUI
  }
  self._ui.staticText_Y_ConsoleUI:SetShow(false)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.static_BottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Panel_Window_LocalWarInfo_info:setContent()
  self._ui.list2_ServerList:getElementManager():clearKey()
  self._value.localWarServerCount = ToClient_GetLocalwarStatusCount()
  for index = 0, self._value.localWarServerCount - 1 do
    self._ui.list2_ServerList:getElementManager():pushKey(toInt64(0, index))
    self._ui.list2_ServerList:requestUpdateByKey(toInt64(0, index))
  end
end
function Panel_Window_LocalWarInfo_info:open()
  if false == Panel_LocalWarInfo:GetShow() then
    _AudioPostEvent_SystemUiForXBOX(1, 18)
  end
  Panel_LocalWarInfo:SetShow(true)
end
function Panel_Window_LocalWarInfo_info:close()
  _AudioPostEvent_SystemUiForXBOX(1, 17)
  Panel_LocalWarInfo:SetShow(false)
end
function PaGlobalFunc_LocalWarInfo_GetShow()
  return Panel_LocalWarInfo:GetShow()
end
function PaGlobalFunc_LocalWarInfo_Open()
  local self = Panel_Window_LocalWarInfo_info
  self:open()
end
function PaGlobalFunc_LocalWarInfo_Close()
  local self = Panel_Window_LocalWarInfo_info
  _AudioPostEvent_SystemUiForXBOX(1, 17)
  self:close()
end
function PaGlobalFunc_LocalWarInfo_Show()
  local playerWrapper = getSelfPlayer()
  local player = playerWrapper:get()
  local hp = player:getHp()
  local maxHp = player:getMaxHp()
  local isGameMaster = ToClient_SelfPlayerIsGM()
  if 0 == ToClient_GetMyTeamNoLocalWar() then
    local self = Panel_Window_LocalWarInfo_info
    ToClient_RequestLocalwarStatus()
    self:open()
    self:setContent()
  elseif hp == maxHp or isGameMaster then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_LOCALWAR_GETOUT_MEMO")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = messageBoxMemo,
      functionYes = PaGlobalFunc_LocalWarInfo_GetOut,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "middle")
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_MAXHP_CHECK"))
  end
end
function PaGlobalFunc_LocalWarInfo_Exit()
  local self = Panel_Window_LocalWarInfo_info
  self:close()
  PaGlobalFunc_LocalWarRule_Close()
end
local limitLevel = 0
local limitAP = 0
local limitDP = 0
local limitADP = 0
function PaGlobalFunc_LocalWarInfo_Server_List(list_content, key)
  local self = Panel_Window_LocalWarInfo_info
  local id = Int64toInt32(key)
  local localWarStatusData = ToClient_GetLocalwarStatusData(id)
  if nil == localWarStatusData then
    return
  end
  local curChannelData = getCurrentChannelServerData()
  if nil == curChannelData then
    return
  end
  local getServerNo = localWarStatusData:getServerNo()
  local getJoinMemberCount = localWarStatusData:getTotalJoinCount()
  local getCurrentState = localWarStatusData:getState()
  local getRemainTime = localWarStatusData:getRemainTime()
  local warTimeMinute = math.floor(Int64toInt32(getRemainTime / toInt64(0, 60)))
  local warTimeSecond = Int64toInt32(getRemainTime) % 60
  local channelName = getChannelName(curChannelData._worldNo, getServerNo)
  local isLimitLocalWar = localWarStatusData:isLimitedLocalWar()
  local staticText_LevelValue = UI.getChildControl(list_content, "StaticText_LevelValue")
  local staticText_AttackValue = UI.getChildControl(list_content, "StaticText_AttackValue")
  local staticText_DefenceValue = UI.getChildControl(list_content, "StaticText_DefenceValue")
  local staticText_AttackDefence = UI.getChildControl(list_content, "StaticText_AttackDefence")
  local staticText_ServerName = UI.getChildControl(list_content, "StaticText_ServerValue")
  local staticText_CountValue = UI.getChildControl(list_content, "StaticText_CountValue")
  local staticText_RemainTimeValue = UI.getChildControl(list_content, "StaticText_RemainTimeValue")
  local staticText_StateValue = UI.getChildControl(list_content, "StaticText_StateValue")
  if getJoinMemberCount < 0 then
    getJoinMemberCount = 0
  end
  staticText_ServerName:SetText(channelName)
  if isLimitLocalWar then
    limitLevel = ToClient_GetLevelForLimitedLocalWar() - 1
    limitAP = ToClient_GetAttackForLimitedLocalWar() - 1
    limitDP = ToClient_GetDefenseForLimitedLocalWar() - 1
    limitADP = ToClient_GetADSummaryForLimitedLocalWar() - 1
    staticText_LevelValue:SetShow(true)
    staticText_AttackValue:SetShow(true)
    staticText_DefenceValue:SetShow(true)
    staticText_AttackDefence:SetShow(true)
    staticText_LevelValue:SetText(limitLevel)
    staticText_AttackValue:SetText(limitAP)
    staticText_DefenceValue:SetText(limitDP)
    staticText_AttackDefence:SetText(limitADP)
  else
    limitLevel = 0
    limitAP = 0
    limitDP = 0
    limitADP = 0
    staticText_LevelValue:SetShow(true)
    staticText_AttackValue:SetShow(true)
    staticText_DefenceValue:SetShow(true)
    staticText_AttackDefence:SetShow(true)
    staticText_LevelValue:SetText("-")
    staticText_AttackValue:SetText("-")
    staticText_DefenceValue:SetText("-")
    staticText_AttackDefence:SetText("-")
  end
  local isCurrentState = ""
  local isWarTime = ""
  local joinable = false
  if 0 == getCurrentState then
    isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_JOIN_WAITING")
    isWarTime = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_WAITING")
    joinable = true
  elseif 1 == getCurrentState then
    isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_ING")
    isWarTime = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_TIME", "warTimeMinute", warTimeMinute, "warTimeSecond", Int64toInt32(warTimeSecond))
  elseif 2 == getCurrentState then
    isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_SOONFINISH")
    isWarTime = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_TIME", "warTimeMinute", warTimeMinute, "warTimeSecond", Int64toInt32(warTimeSecond))
  elseif 3 == getCurrentState then
    isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH")
    isWarTime = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH")
  end
  staticText_StateValue:SetText(isCurrentState)
  staticText_RemainTimeValue:SetText(isWarTime)
  staticText_CountValue:SetText(getJoinMemberCount)
  list_content:addInputEvent("Mouse_LUp", "PaGlobalFunc_LocalWarInfo_GoLocalWar( " .. id .. "," .. tostring(isLimitLocalWar) .. " )")
end
function PaGlobalFunc_LocalWarInfo_GoLocalWar(index, isLimitLocalWar)
  local playerWrapper = getSelfPlayer()
  if nil == playerWrapper then
    return
  end
  local curChannelData = getCurrentChannelServerData()
  if nil == curChannelData then
    return
  end
  local player = playerWrapper:get()
  local hp = player:getHp()
  local maxHp = player:getMaxHp()
  local isGameMaster = ToClient_SelfPlayerIsGM()
  local getLevel = playerWrapper:get():getLevel()
  local isMineADSum = ToClient_getOffence() + ToClient_getDefence()
  if not isLimitLocalWar and getLevel < 50 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LEVELLIMIT"))
    return
  end
  if isLimitLocalWar then
    if getLevel >= limitLevel then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LEVEL_LIMIT"))
    elseif limitAP <= ToClient_getOffence() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_ATTACK_LIMIT"))
    elseif limitDP <= ToClient_getDefence() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DEFENCE_LIMIT"))
    elseif isMineADSum >= limitADP then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_ADSUM_LIMIT"))
    end
  end
  local localWarStatusData = ToClient_GetLocalwarStatusData(index)
  if nil == localWarStatusData then
    local msg = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_NOTOPENWAR")
    Proc_ShowMessage_Ack(msg)
    return
  end
  local maxPlayer = ToClient_GetMaxLocalWarPlayer()
  local getJoinMemberCount = localWarStatusData:getTotalJoinCount()
  if getJoinMemberCount >= maxPlayer * 2 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_MESSAGE_FULLJOIN"))
    return
  end
  local getServerNo = localWarStatusData:getServerNo()
  local channelName = getChannelName(curChannelData._worldNo, getServerNo)
  local isGameMaster = ToClient_SelfPlayerIsGM()
  local channelMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CHANNELMOVE", "channelName", channelName)
  local noticeTitle = ""
  local tempChannel = getGameChannelServerDataByWorldNo(curChannelData._worldNo, index)
  local function joinLocalWar()
    local playerWrapper = getSelfPlayer()
    local player = playerWrapper:get()
    local hp = player:getHp()
    local maxHp = player:getMaxHp()
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    if player:doRideMyVehicle() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_NOT_RIDEHORSE"))
    elseif ToClient_IsMyselfInArena() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCompetitionAlreadyIn"))
      return
    end
    if IsSelfPlayerWaitAction() then
      if hp == maxHp or isGameMaster then
        if getServerNo == curChannelData._serverNo then
          ToClient_JoinLocalWar()
        else
          ToClient_RequestLocalwarJoinToAnotherChannel(getServerNo)
        end
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_MAXHP_CHECK"))
      end
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_LOCALWARINFO"))
    end
  end
  if getServerNo == curChannelData._serverNo then
    noticeTitle = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_JOIN")
    channelMemo = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CURRENTCHANNELJOIN")
  else
    noticeTitle = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG")
    channelMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CHANNELMOVE", "channelName", channelName)
  end
  local changeChannelTime = getChannelMoveableRemainTime(curChannelData._worldNo)
  local changeRealChannelTime = convertStringFromDatetime(changeChannelTime)
  if changeChannelTime > toInt64(0, 0) and getServerNo ~= curChannelData._serverNo then
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANGECHANNEL_PENALTY", "changeRealChannelTime", changeRealChannelTime)
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    local messageBoxData = {
      title = noticeTitle,
      content = channelMemo,
      functionYes = joinLocalWar,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function PaGlobalFunc_LocalWarInfo_GetOut()
  if IsSelfPlayerWaitAction() then
    ToClient_UnJoinLocalWar()
    if nil ~= Panel_LocalWarTeam and Panel_LocalWarTeam:GetShow() then
      Panel_LocalWarTeam:SetShow(false)
    end
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_WAITPOSITION_POSSIBLE"))
  end
end
function FromClient_LocalWarInfo_Init()
  local self = Panel_Window_LocalWarInfo_info
  self:initialize()
end
function FromClient_LocalWarInfo_Resize()
  local self = Panel_Window_LocalWarInfo_info
  self:resize()
end
function FromClient_LocalWarInfo_UpdateLocalWarStatus()
  local self = Panel_Window_LocalWarInfo_info
  self:setContent()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_LocalWarInfo_Init")

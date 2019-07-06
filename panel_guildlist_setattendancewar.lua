Panel_GuildList_SetAttendanceWar:SetShow(false)
local centerBg = UI.getChildControl(Panel_GuildList_SetAttendanceWar, "Static_CenterBg")
local SetAttendanceWar = {
  _ui = {
    _pariticipantList2 = UI.getChildControl(centerBg, "List2_JoinMemberList"),
    _nonPariticipantList2 = UI.getChildControl(centerBg, "List2_UnjoinMemberList")
  },
  _member = {}
}
function SetAttendanceWar:init()
  self._ui._pariticipantList2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FGlobal_SiegeParticipant_List2EventControlCreate")
  self._ui._pariticipantList2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._nonPariticipantList2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FGlobal_SiegeNonParticipant_List2EventControlCreate")
  self._ui._nonPariticipantList2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  local buttonconfirm = UI.getChildControl(Panel_GuildList_SetAttendanceWar, "Button_Confirm")
  local buttoncloseBg = UI.getChildControl(Panel_GuildList_SetAttendanceWar, "Static_TitleBg")
  local buttonclose = UI.getChildControl(buttoncloseBg, "Button_Close")
  local buttoncancel = UI.getChildControl(Panel_GuildList_SetAttendanceWar, "Button_Cancel")
  buttonconfirm:addInputEvent("Mouse_LUp", "HandleClicked_SetAttendanceWar_Confirm()")
  buttoncancel:addInputEvent("Mouse_LUp", "HandleClicked_SetAttendanceWar_Cancel()")
  buttonclose:addInputEvent("Mouse_LUp", "HandleClicked_SetAttendanceWar_Cancel()")
  self._ui._nonPariticipantTitle = UI.getChildControl(centerBg, "StaticText_LeftTitle")
  self._ui._pariticipantTitle = UI.getChildControl(centerBg, "StaticText_RightTitle")
end
function FGlobal_SetAttendanceWar_Open()
  SetAttendanceWar:open()
end
function SetAttendanceWar:open()
  self:reset()
  Panel_GuildList_SetAttendanceWar:SetShow(true)
  local myguildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myguildInfo then
    return
  end
  local totalCount = 0
  local participantCount = 0
  if true == myguildInfo:isAllianceGuild() then
    local allianceWrapper = ToClient_GetMyGuildAllianceWrapper()
    if nil == allianceWrapper then
      return
    end
    for guildIndex = 0, allianceWrapper:getMemberCount() - 1 do
      local guildWrapper = allianceWrapper:getMemberGuild(Int64toInt32(guildIndex))
      if nil ~= guildWrapper then
        totalCount = totalCount + guildWrapper:getMemberCount()
        participantCount = participantCount + guildWrapper:getSiegeParticipantCount()
      end
    end
  else
    totalCount = myguildInfo:getMemberCount()
    participantCount = myguildInfo:getSiegeParticipantCount()
  end
  local nonParticipantCount = totalCount - participantCount
  local pstr = " ( " .. tostring(participantCount) .. "/" .. tostring(totalCount) .. " )"
  local nonpstr = " ( " .. tostring(nonParticipantCount) .. "/" .. tostring(totalCount) .. " )"
  self._ui._nonPariticipantTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDLIST_SETATTENDANCEWAR_SUBTITLE1") .. nonpstr)
  self._ui._pariticipantTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDLIST_SETATTENDANCEWAR_SUBTITLE2") .. pstr)
end
function SetAttendanceWar:reset()
  self._member = {}
  self:update()
end
function SetAttendanceWar:update()
  local myguildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myguildInfo then
    return
  end
  self._ui._pariticipantList2:getElementManager():clearKey()
  self._ui._nonPariticipantList2:getElementManager():clearKey()
  local dataIndex = 0
  local memberCount = myguildInfo:getMemberCount()
  for index = 0, memberCount - 1 do
    local guildMember = myguildInfo:getMember(index)
    if nil == guildMember then
      return
    end
    if guildMember:isSiegeParticipant() then
      self._ui._pariticipantList2:getElementManager():pushKey(toInt64(0, dataIndex))
    else
      self._ui._nonPariticipantList2:getElementManager():pushKey(toInt64(0, dataIndex))
    end
    if nil == self._member[dataIndex] then
      self._member[dataIndex] = {}
    end
    self._member[dataIndex]._userNo = guildMember:getUserNo()
    self._member[dataIndex]._guildNo = myguildInfo:getGuildNo_s64()
    self._member[dataIndex]._index = index
    self._member[dataIndex]._isAllianceMember = myguildInfo:isAllianceGuild()
    self._member[dataIndex]._guildAllianceNo = myguildInfo:guildAllianceNo_s64()
    dataIndex = dataIndex + 1
  end
  if true == myguildInfo:isAllianceGuild() then
    local allianceWrapper = ToClient_GetMyGuildAllianceWrapper()
    if nil == allianceWrapper then
      return
    end
    for guildIndex = 0, allianceWrapper:getMemberCount() - 1 do
      local guildWrapper = allianceWrapper:getMemberGuild(Int64toInt32(guildIndex))
      if nil ~= guildWrapper and guildWrapper:getGuildNo_s64() ~= myguildInfo:getGuildNo_s64() then
        local memberCount = guildWrapper:getMemberCount()
        for index = 0, memberCount - 1 do
          local guildMember = guildWrapper:getMember(Int64toInt32(index))
          if nil == guildMember then
            return
          end
          if guildMember:isSiegeParticipant() then
            self._ui._pariticipantList2:getElementManager():pushKey(toInt64(0, dataIndex))
          else
            self._ui._nonPariticipantList2:getElementManager():pushKey(toInt64(0, dataIndex))
          end
          if nil == self._member[dataIndex] then
            self._member[dataIndex] = {}
          end
          self._member[dataIndex]._userNo = guildMember:getUserNo()
          self._member[dataIndex]._guildNo = guildWrapper:getGuildNo_s64()
          self._member[dataIndex]._index = index
          self._member[dataIndex]._isAllianceMember = guildWrapper:isAllianceGuild()
          self._member[dataIndex]._guildAllianceNo = guildWrapper:guildAllianceNo_s64()
          dataIndex = dataIndex + 1
        end
      end
    end
  end
end
function FGlobal_SiegeParticipant_List2EventControlCreate(list_content, key)
  local dataIndex = Int64toInt32(key)
  local data = SetAttendanceWar._member[dataIndex]
  local guildInfo = ToClient_GetGuildWrapperByGuildNo(data._guildNo)
  if nil == guildInfo then
    return
  end
  local guildMember = guildInfo:getMemberByUserNo(data._userNo)
  if nil == guildMember then
    return
  end
  local name = guildMember:getName()
  local staticText_name = UI.getChildControl(list_content, "StaticText_Name")
  local static_guildMark = UI.getChildControl(list_content, "Static_GuildMark")
  staticText_name:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  staticText_name:SetText(name)
  if true == data._isAllianceMember then
    staticText_name:SetPosX(70)
    static_guildMark:SetShow(true)
    setGuildTextureByGuildNo(data._guildNo, static_guildMark)
  else
    staticText_name:SetPosX(40)
    static_guildMark:SetShow(false)
  end
  SetAttendanceWar._member[dataIndex]._tooltip = staticText_name
  staticText_name:SetIgnore(false)
  staticText_name:addInputEvent("Mouse_On", "HandleOver_SetAttendanceWar_GuildMember( true, " .. dataIndex .. " )")
  staticText_name:addInputEvent("Mouse_Out", "HandleOver_SetAttendanceWar_GuildMember( false, " .. dataIndex .. " )")
end
function FGlobal_SiegeNonParticipant_List2EventControlCreate(list_content, key)
  local dataIndex = Int64toInt32(key)
  local data = SetAttendanceWar._member[dataIndex]
  local guildInfo = ToClient_GetGuildWrapperByGuildNo(data._guildNo)
  if nil == guildInfo then
    return
  end
  local guildMember = guildInfo:getMemberByUserNo(data._userNo)
  if nil == guildMember then
    return
  end
  local name = guildMember:getName()
  local staticText_name = UI.getChildControl(list_content, "StaticText_Name")
  local static_guildMark = UI.getChildControl(list_content, "Static_GuildMark")
  local checkbox_participant = UI.getChildControl(list_content, "CheckButton_Attendance")
  staticText_name:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  staticText_name:SetText(name)
  if true == data._isAllianceMember then
    staticText_name:SetPosX(70)
    static_guildMark:SetShow(true)
    setGuildTextureByGuildNo(data._guildNo, static_guildMark)
  else
    staticText_name:SetPosX(40)
    static_guildMark:SetShow(false)
  end
  staticText_name:SetIgnore(true)
  checkbox_participant:SetEnableArea(0, 0, staticText_name:GetPosX() + staticText_name:GetSizeX(), checkbox_participant:GetSizeY())
  checkbox_participant:addInputEvent("Mouse_On", "HandleOver_SetAttendanceWar_GuildMember( true, " .. dataIndex .. " )")
  checkbox_participant:addInputEvent("Mouse_Out", "HandleOver_SetAttendanceWar_GuildMember( false, " .. dataIndex .. " )")
  checkbox_participant:addInputEvent("Mouse_LUp", "HandleClicked_SetAttendanceWar_SetParticipantToggle( " .. dataIndex .. " )")
  SetAttendanceWar._member[dataIndex]._tooltip = checkbox_participant
  local newMember = SetAttendanceWar._member[dataIndex]._newMember
  checkbox_participant:SetCheck(true == newMember)
end
function HandleOver_SetAttendanceWar_GuildMember(over, dataIndex)
  local data = SetAttendanceWar._member[dataIndex]
  local guildInfo = ToClient_GetGuildWrapperByGuildNo(data._guildNo)
  if nil == guildInfo then
    return
  end
  if true == over then
    TooltipSimple_Show(data._tooltip, PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LORDMENU_TER_GUILDNAME") .. " " .. guildInfo:getName())
  else
    TooltipSimple_Hide()
  end
end
function HandleClicked_SetAttendanceWar_SetParticipantToggle(index)
  local data = SetAttendanceWar._member[index]
  local guildInfo = ToClient_GetGuildWrapperByGuildNo(data._guildNo)
  if nil == guildInfo then
    return
  end
  local guildMember = guildInfo:getMemberByUserNo(data._userNo)
  if nil == guildMember then
    return
  end
  local self = SetAttendanceWar
  local count = 0
  for i, v in pairs(self._member) do
    if true == v._newMember then
      count = count + 1
    end
  end
  local isparticipant
  if nil == self._member[index] then
    return
  end
  if true == self._member[index]._newMember then
    isparticipant = false
  else
    isparticipant = true
  end
  if true == isparticipant and count >= 5 then
    local str = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CHANGEPARTICIPANT_MAXMEMBER")
    Proc_ShowMessage_Ack(str)
    SetAttendanceWar:update()
    return
  end
  self._member[index]._newMember = isparticipant
end
function HandleClicked_SetAttendanceWar_Confirm()
  local guildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == guildInfo then
    return
  end
  local function confirm()
    Panel_GuildList_SetAttendanceWar:SetShow(false)
    local count = 0
    for index, data in pairs(SetAttendanceWar._member) do
      if true == data._newMember then
        count = count + 1
        if count > 5 then
          local str = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CHANGEPARTICIPANT_MAXMEMBER")
          Proc_ShowMessage_Ack(str)
          return
        end
      end
    end
    local participantCount = 0
    local myguildInfo = ToClient_GetMyGuildInfoWrapper()
    if nil == myguildInfo then
      return
    end
    if true == myguildInfo:isAllianceGuild() then
      local allianceWrapper = ToClient_GetMyGuildAllianceWrapper()
      if nil == allianceWrapper then
        return
      end
      for guildIndex = 0, allianceWrapper:getMemberCount() - 1 do
        local guildWrapper = allianceWrapper:getMemberGuild(Int64toInt32(guildIndex))
        if nil ~= guildWrapper then
          participantCount = participantCount + guildWrapper:getSiegeParticipantCount()
        end
      end
    else
      participantCount = myguildInfo:getSiegeParticipantCount()
    end
    if participantCount < 10 then
      local str = PAGetString(Defines.StringSheet_GAME, "LUA_NOTENOUGH_SIEGEPARTICIPANT")
      Proc_ShowMessage_Ack(str)
      return
    end
    for index, data in pairs(SetAttendanceWar._member) do
      if true == data._newMember then
        ToClient_resquestParticipateSiegeFromMaster(data._guildNo, data._userNo, true)
      end
    end
    ToClient_resquestEndToParticipantAtSiege()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SIEGE_MESSAGEBOX_ENDTOPARTICIPANTSIEGE")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = messageBoxMemo,
    functionYes = confirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleClicked_SetAttendanceWar_Cancel()
  Panel_GuildList_SetAttendanceWar:SetShow(false)
end
function FromClient_luaLoadComplete_SetAttendanceWar()
  SetAttendanceWar:init()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_SetAttendanceWar")

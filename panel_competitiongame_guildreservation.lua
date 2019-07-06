local UI_TM = CppEnums.TextMode
local UI_VT = CppEnums.VillageSiegeType
local reservationSlotArr = {}
local isContentsArsha = ToClient_IsContentsGroupOpen("227")
local isCanDoReservation = ToClient_IsCanDoReservationArsha()
Panel_CompetitionGame_GuildReservation:SetShow(false)
local competitionGuildReservation = {
  _txt_Title = UI.getChildControl(Panel_CompetitionGame_GuildReservation, "StaticText_Title"),
  _btn_CloseX = UI.getChildControl(Panel_CompetitionGame_GuildReservation, "Button_Close"),
  _btn_Question = UI.getChildControl(Panel_CompetitionGame_GuildReservation, "Button_Question"),
  _btn_Refresh = UI.getChildControl(Panel_CompetitionGame_GuildReservation, "Button_Refresh")
}
local reservationSlot = {
  _slot_BG = UI.getChildControl(Panel_CompetitionGame_GuildReservation, "Static_DayControlBg"),
  _slot_txt_DayOfWeek = UI.getChildControl(Panel_CompetitionGame_GuildReservation, "StaticText_DayOfWeek"),
  _slot_txt_Date = UI.getChildControl(Panel_CompetitionGame_GuildReservation, "StaticText_Date"),
  _slot_txt_GuildName = UI.getChildControl(Panel_CompetitionGame_GuildReservation, "StaticText_ReserveGuildName"),
  _slot_btn_Reserve = UI.getChildControl(Panel_CompetitionGame_GuildReservation, "Button_Reserve")
}
local dayOfWeekString = {
  [UI_VT.eVillageSiegeType_Sunday] = PAGetString(Defines.StringSheet_GAME, "LUA_DAYOFWEEK_SUNDAY"),
  [UI_VT.eVillageSiegeType_Monday] = PAGetString(Defines.StringSheet_GAME, "LUA_DAYOFWEEK_MONDAY"),
  [UI_VT.eVillageSiegeType_Tuesday] = PAGetString(Defines.StringSheet_GAME, "LUA_DAYOFWEEK_TUESDAY"),
  [UI_VT.eVillageSiegeType_Wednesday] = PAGetString(Defines.StringSheet_GAME, "LUA_DAYOFWEEK_WEDNESDAY"),
  [UI_VT.eVillageSiegeType_Thursday] = PAGetString(Defines.StringSheet_GAME, "LUA_DAYOFWEEK_THURSDAY"),
  [UI_VT.eVillageSiegeType_Friday] = PAGetString(Defines.StringSheet_GAME, "LUA_DAYOFWEEK_FRIDAY"),
  [UI_VT.eVillageSiegeType_Saturday] = PAGetString(Defines.StringSheet_GAME, "LUA_DAYOFWEEK_SATURDAY")
}
function Panel_CompetitionGame_GuildReservation_Init()
  local self = competitionGuildReservation
  for Index = 0, 6 do
    reservationSlotArr[Index] = {}
    local temp = {}
    temp._slot_BG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CompetitionGame_GuildReservation, "CompetitionReservation_SlotBg_" .. Index)
    CopyBaseProperty(reservationSlot._slot_BG, temp._slot_BG)
    temp._slot_BG:SetPosY(52 + (reservationSlot._slot_BG:GetSizeY() + 5) * Index)
    temp._slot_txt_DayOfWeek = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._slot_BG, "CompetitionReservation_SlotDayOfWeek_" .. Index)
    CopyBaseProperty(reservationSlot._slot_txt_DayOfWeek, temp._slot_txt_DayOfWeek)
    temp._slot_txt_DayOfWeek:SetText("")
    temp._slot_txt_DayOfWeek:SetPosX(10)
    temp._slot_txt_DayOfWeek:SetPosY(6)
    temp._slot_txt_Date = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._slot_BG, "CompetitionReservation_SlotDate_" .. Index)
    CopyBaseProperty(reservationSlot._slot_txt_Date, temp._slot_txt_Date)
    temp._slot_txt_Date:SetPosX(26)
    temp._slot_txt_Date:SetPosY(8)
    temp._slot_txt_GuildName = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._slot_BG, "CompetitionReservation_SlotGuildName_" .. Index)
    CopyBaseProperty(reservationSlot._slot_txt_GuildName, temp._slot_txt_GuildName)
    temp._slot_txt_GuildName:SetPosX(90)
    temp._slot_txt_GuildName:SetPosY(8)
    temp._slot_btn_Reserve = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, temp._slot_BG, "CompetitionReservation_SlotReserveBtn_" .. Index)
    CopyBaseProperty(reservationSlot._slot_btn_Reserve, temp._slot_btn_Reserve)
    temp._slot_btn_Reserve:SetPosX(325)
    temp._slot_btn_Reserve:SetPosY(4)
    reservationSlotArr[Index] = temp
  end
  for _, control in pairs(reservationSlot) do
    control:SetShow(false)
  end
  self._txt_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RESERVATION_ARSHA_TITLE"))
  self._btn_Refresh:SetText(PAGetString(Defines.StringSheet_RESOURCE, "UI_WINDOW_DELIVERY_INFORMATION_BTN_REFRESH"))
end
function FGlobal_Panel_CompetitionGame_GuildReservation_Open()
  if false == isContentsArsha or false == isCanDoReservation then
    return
  end
  local self = competitionGuildReservation
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  local isGuildLeader = isGuildMaster or isGuildSubMaster
  FGlobal_RefreshReservationInfo()
  Panel_CompetitionGame_GuildReservation:SetShow(true)
  if nil ~= Panel_CompetitionGame_JoinDesc then
    Panel_CompetitionGame_GuildReservation:SetPosX(Panel_CompetitionGame_JoinDesc:GetPosX() + Panel_CompetitionGame_JoinDesc:GetSizeX() + 10, Panel_CompetitionGame_JoinDesc:GetPosY())
  end
end
function FGlobal_Panel_CompetitionGame_GuildReservation_Close()
  local self = competitionGuildReservation
  Panel_CompetitionGame_GuildReservation:SetShow(false)
end
function FGlobal_Panel_CompetitionGame_ReservationArsha(reservationIndex, isReservation)
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  local isGuildLeader = isGuildMaster or isGuildSubMaster
  local reservationInfo = ToClient_GetArshaReservationInfoAt(reservationIndex)
  local reservationPrice = Int64toInt32(ToClient_GetReservationPrice())
  local messageBoxMemo = ""
  local reservationGuildNo = reservationInfo:getGuildNo()
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  local userGuildNo
  if nil ~= myGuildInfo then
    userGuildNo = myGuildInfo:getGuildNo_s64()
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_NO_GUILD"))
    return
  end
  if toInt64(0, 0) ~= reservationGuildNo and userGuildNo ~= reservationGuildNo then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoAlreadyReservationDay"))
    return
  end
  if false == isGuildMaster then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCanDoOnlyGuildMaster"))
    return
  end
  local function requestReservation()
    ToClient_RequestCompetitionReservation(reservationIndex, isReservation)
  end
  if nil ~= reservationInfo and toInt64(0, 0) == reservationGuildNo then
    messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_DO_RESERVATION", "reservationPrice", reservationPrice)
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_CANCEL_RESERVATION")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = requestReservation,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FGlobal_RefreshReservationInfo()
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  ToClient_RequestArshaReservationList()
end
function HandleChangeReservationInfo(dayIndex, dayValue, dayOfWeekValue, reservationGuildName, guildNo, isReservation)
  local self = competitionGuildReservation
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  local userGuildNo
  local isMyGuild = false
  local btnText = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_RESERVATION")
  local Index = dayIndex
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  local isGuildLeader = isGuildMaster or isGuildSubMaster
  if nil ~= myGuildInfo then
    userGuildNo = myGuildInfo:getGuildNo_s64()
    isMyGuild = userGuildNo == guildNo
  end
  if Index < 0 or Index >= 7 then
    return
  end
  if isMyGuild then
    btnText = PAGetString(Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_17")
  end
  reservationSlotArr[Index]._slot_txt_Date:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(dayValue)))
  reservationSlotArr[Index]._slot_txt_DayOfWeek:SetText(dayOfWeekString[dayOfWeekValue])
  reservationSlotArr[Index]._slot_btn_Reserve:SetText(btnText)
  reservationSlotArr[Index]._slot_btn_Reserve:SetShow(true)
  if nil == myGuildInfo or false == isGuildMaster then
    reservationSlotArr[Index]._slot_btn_Reserve:SetShow(false)
  end
  if true == isReservation then
    reservationSlotArr[Index]._slot_txt_GuildName:SetText(reservationGuildName)
  else
    reservationSlotArr[Index]._slot_txt_GuildName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CANDORESERVATIONARSHA"))
  end
end
function FromClient_RequestTransferHost(hostCharacterName, userNo)
  local self = competitionGuildReservation
  local function transferHost()
    ToClient_RequestAcceptTransferHost(userNo, true)
  end
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_TRANSFER_HOST_TO_OTHERGUILDMASTER", "characterName", hostCharacterName)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = transferHost,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FromClient_ChangedHost(isHostMyself)
  if true == isHostMyself then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GET_ARSHAHOST"))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RELEASE_ARSHAHOST_DESC"))
    FGlobal_ArshaPvP_Close()
  end
end
function FromClient_ChangeAssistant(isAssistant)
  if true == isAssistant then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_SET_TO_ASSISTANT"))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_RELEASE_FROM_ASSISTANT"))
  end
end
function Panel_CompetitionGame_GuildReservation_Event()
  local self = competitionGuildReservation
  self._btn_CloseX:addInputEvent("Mouse_LUp", "FGlobal_Panel_CompetitionGame_GuildReservation_Close()")
  self._btn_Refresh:addInputEvent("Mouse_LUp", "FGlobal_RefreshReservationInfo()")
  for index = 0, #reservationSlotArr do
    if reservationSlotArr[index] ~= nil then
      local value = index
      reservationSlotArr[index]._slot_btn_Reserve:addInputEvent("Mouse_LUp", "FGlobal_Panel_CompetitionGame_ReservationArsha(" .. value .. ")")
    else
      _PA_LOG("\236\160\149\237\131\156\234\179\164", "\236\151\172\234\184\176\235\165\188 \235\147\164\236\150\180\236\152\164\235\169\180 \236\149\136\235\144\156\235\139\164!!!!!! \236\189\148\235\147\156 \234\178\128\236\166\157\237\149\180\236\163\188\236\132\184\236\154\148!")
    end
  end
  registerEvent("FromClient_ChangeReservationInfo", "HandleChangeReservationInfo")
  registerEvent("FromClient_RequestTransferHost", "FromClient_RequestTransferHost")
  registerEvent("FromClient_ChangedHost", "FromClient_ChangedHost")
  registerEvent("FromClient_ChangeAssistant", "FromClient_ChangeAssistant")
end

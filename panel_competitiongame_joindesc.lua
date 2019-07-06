local UI_TM = CppEnums.TextMode
local UI_VT = CppEnums.VillageSiegeType
local isContentsArsha = ToClient_IsContentsGroupOpen("227")
local isCanDoReservation = ToClient_IsCanDoReservationArsha()
local reservationSlotArr = {}
local competitionGameJoinDesc = {
  btn_CloseX = nil,
  descBG = nil,
  btn_Join = nil,
  btn_ObserverJoin = nil,
  btn_Refresh = nil,
  frame_Desc = nil,
  reservationMisc = {},
  reservationSlot = {
    _slot_BG = nil,
    _slot_txt_DayOfWeek = nil,
    _slot_txt_Date = nil,
    _slot_txt_GuildName = nil,
    _slot_btn_Reserve = nil
  }
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
function competitionGameJoinDesc:controlInitialize()
  if nil == Panel_CompetitionGame_JoinDesc then
    return
  end
  competitionGameJoinDesc.btn_CloseX = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "Button_Close")
  competitionGameJoinDesc.descBG = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "Static_AllBG")
  competitionGameJoinDesc.btn_Join = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "Button_Join")
  competitionGameJoinDesc.btn_ObserverJoin = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "Button_ObserverJoin")
  competitionGameJoinDesc.btn_Refresh = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "Button_Refresh")
  competitionGameJoinDesc.frame_Desc = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "Frame_Desc")
  competitionGameJoinDesc.reservationMisc[1] = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "Static_LeftMidbg")
  competitionGameJoinDesc.reservationMisc[2] = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "StaticText_DayOfWeek_Title")
  competitionGameJoinDesc.reservationMisc[3] = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "StaticText_Date_Title")
  competitionGameJoinDesc.reservationMisc[4] = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "StaticText_ReserveGuildName_Title")
  competitionGameJoinDesc.reservationMisc[5] = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "StaticText_Reserve_Title")
  competitionGameJoinDesc.reservationSlot._slot_BG = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "Static_DayControlBg")
  competitionGameJoinDesc.reservationSlot._slot_txt_DayOfWeek = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "StaticText_DayOfWeek")
  competitionGameJoinDesc.reservationSlot._slot_txt_Date = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "StaticText_Date")
  competitionGameJoinDesc.reservationSlot._slot_txt_GuildName = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "StaticText_ReserveGuildName")
  competitionGameJoinDesc.reservationSlot._slot_btn_Reserve = UI.getChildControl(Panel_CompetitionGame_JoinDesc, "Button_Reserve")
end
function competitionGameJoinDesc:initialize()
  if nil == Panel_CompetitionGame_JoinDesc then
    return
  end
  Panel_CompetitionGame_JoinDesc:SetShow(false)
  competitionGameJoinDesc:controlInitialize()
  self.frame_content = UI.getChildControl(self.frame_Desc, "Frame_1_Content")
  self.frame_Scroll = UI.getChildControl(self.frame_Desc, "Frame_1_VerticalScroll")
  self.txt_Desc = UI.getChildControl(self.frame_content, "StaticText_Desc")
  self.txt_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_ESCMENUDESC"))
  self.frame_content:SetSize(self.frame_content:GetSizeX(), self.txt_Desc:GetTextSizeY() + 10)
  local resizeTextY = self.txt_Desc:GetTextSizeY() + self.btn_Join:GetSizeY()
  reservationSlotArr = {}
  for Index = 0, 6 do
    reservationSlotArr[Index] = {}
    local temp = {}
    temp._slot_BG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CompetitionGame_JoinDesc, "CompetitionReservation_SlotBg_" .. Index)
    CopyBaseProperty(self.reservationSlot._slot_BG, temp._slot_BG)
    temp._slot_BG:SetPosY(93 + (self.reservationSlot._slot_BG:GetSizeY() + 5) * Index)
    temp._slot_txt_DayOfWeek = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._slot_BG, "CompetitionReservation_SlotDayOfWeek_" .. Index)
    CopyBaseProperty(self.reservationSlot._slot_txt_DayOfWeek, temp._slot_txt_DayOfWeek)
    temp._slot_txt_DayOfWeek:SetText("")
    temp._slot_txt_DayOfWeek:SetPosX(50)
    temp._slot_txt_DayOfWeek:SetPosY(10)
    temp._slot_txt_Date = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._slot_BG, "CompetitionReservation_SlotDate_" .. Index)
    CopyBaseProperty(self.reservationSlot._slot_txt_Date, temp._slot_txt_Date)
    temp._slot_txt_Date:SetText("")
    temp._slot_txt_Date:SetPosX(130)
    temp._slot_txt_Date:SetPosY(10)
    temp._slot_txt_GuildName = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, temp._slot_BG, "CompetitionReservation_SlotGuildName_" .. Index)
    CopyBaseProperty(self.reservationSlot._slot_txt_GuildName, temp._slot_txt_GuildName)
    temp._slot_txt_GuildName:SetText("")
    temp._slot_txt_GuildName:SetPosX(250)
    temp._slot_txt_GuildName:SetPosY(10)
    temp._slot_btn_Reserve = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, temp._slot_BG, "CompetitionReservation_SlotReserveBtn_" .. Index)
    CopyBaseProperty(self.reservationSlot._slot_btn_Reserve, temp._slot_btn_Reserve)
    temp._slot_btn_Reserve:SetPosX(490)
    temp._slot_btn_Reserve:SetPosY(5)
    temp._slot_btn_Reserve:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    reservationSlotArr[Index] = temp
  end
  for _, control in pairs(self.reservationSlot) do
    control:SetShow(false)
  end
  self.btn_Join:ComputePos()
  self.btn_ObserverJoin:ComputePos()
  self.btn_Refresh:ComputePos()
  self:registEventHandler()
  registerCloseLuaEvent(Panel_CompetitionGame_JoinDesc, PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Escape
  }), "PaGlobalFunc_CompetitionGame_JoinDesc_Close()")
end
function competitionGameJoinDesc:registEventHandler()
  if nil == Panel_CompetitionGame_JoinDesc then
    return
  end
  self.btn_Join:addInputEvent("Mouse_LUp", "FGlobal_Panel_CompetitionGame_JoinDesc_Join(false)")
  self.btn_ObserverJoin:addInputEvent("Mouse_LUp", "FGlobal_Panel_CompetitionGame_JoinDesc_Join(true)")
  self.btn_CloseX:addInputEvent("Mouse_LUp", "PaGlobalFunc_CompetitionGame_JoinDesc_Close()")
  self.btn_CloseX:addInputEvent("Mouse_LUp", "PaGlobalFunc_CompetitionGame_JoinDesc_Close()")
  self.btn_Refresh:addInputEvent("Mouse_LUp", "FGlobal_RefreshReservationInfo()")
  for index = 0, #reservationSlotArr do
    if reservationSlotArr[index] ~= nil then
      local value = index
      reservationSlotArr[index]._slot_btn_Reserve:addInputEvent("Mouse_LUp", "FGlobal_Panel_CompetitionGame_ReservationArsha(" .. value .. ")")
    else
      _PA_LOG("\236\160\149\237\131\156\234\179\164", "\236\151\172\234\184\176\235\165\188 \235\147\164\236\150\180\236\152\164\235\169\180 \236\149\136\235\144\156\235\139\164!!!!!! \236\189\148\235\147\156 \234\178\128\236\166\157\237\149\180\236\163\188\236\132\184\236\154\148!")
    end
  end
end
function PaGlobalFunc_CompetitionGame_JoinDesc_Open()
  if false == ToClient_IsGrowStepOpen(__eGrowStep_arsha) then
    return
  end
  local self = competitionGameJoinDesc
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  local isGuildLeader = isGuildMaster or isGuildSubMaster
  audioPostEvent_SystemUi(1, 18)
  _AudioPostEvent_SystemUiForXBOX(1, 18)
  PaGlobalFunc_CompetitionGameJoinDesc_SetShowPanel(true, false)
  Panel_CompetitionGame_JoinDesc:SetShow(true)
  local arshaAvailable = true == isContentsArsha and true == isCanDoReservation
  self:doShitWhenArhaIsAvailable(arshaAvailable)
  if arshaAvailable then
    FGlobal_RefreshReservationInfo()
  end
end
function competitionGameJoinDesc:doShitWhenArhaIsAvailable(arshaAvailable)
  if nil == Panel_CompetitionGame_JoinDesc then
    return
  end
  for ii = 1, #self.reservationMisc do
    self.reservationMisc[ii]:SetShow(arshaAvailable)
  end
  for ii = 0, 6 do
    reservationSlotArr[ii]._slot_btn_Reserve:SetShow(arshaAvailable)
  end
  UI.getChildControl(Panel_CompetitionGame_JoinDesc, "StaticText_Unavailable"):SetShow(not arshaAvailable)
end
function FGlobal_RefreshReservationInfo()
  ToClient_RequestArshaReservationList()
end
function PaGlobalFunc_CompetitionGame_JoinDesc_Close()
  if nil == Panel_CompetitionGame_JoinDesc then
    return
  end
  local self = competitionGameJoinDesc
  audioPostEvent_SystemUi(1, 17)
  _AudioPostEvent_SystemUiForXBOX(1, 17)
  Panel_CompetitionGame_JoinDesc:SetShow(false)
  PaGlobalFunc_CompetitionGameJoinDesc_SetShowPanel(false, false)
end
function FGlobal_Panel_CompetitionGame_JoinDesc_Join(isObserver)
  local selfProxy = getSelfPlayer():get()
  local inventory = selfProxy:getInventory()
  local hasItem = inventory:getItemCount_s64(ItemEnchantKey(65012, 0))
  if toInt64(0, 0) == hasItem then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_JOINDESC_HASITEM"))
    return
  end
  if ToClient_IsCompetitionHost() then
    CompetitionGame_HostIntoCompetition()
  else
    if FGlobal_Panel_CompetitionGame_ExpirationItemCheck(ItemEnchantKey(65012, 0)) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_JOINDESC_HASITEM"))
      return
    end
    ToClient_RequestJoinCompetition(isObserver)
  end
end
function FGlobal_Panel_CompetitionGame_ExpirationItemCheck(index)
  local selfProxy = getSelfPlayer():get()
  if nil == selfProxy then
    return
  end
  local inventory = selfProxy:getInventory()
  local invenSize = getSelfPlayer():get():getInventorySlotCount(true)
  for i = 1, invenSize - 1 do
    if not inventory:empty(i) then
      local itemWrapper = getInventoryItem(i)
      if nil ~= itemWrapper and itemKey == itemWrapper:get():getKey():getItemKey() then
        local itemExpiration = itemWrapper:getExpirationDate()
        if nil ~= itemExpiration and false == itemExpiration:isIndefinite() then
          local remainTime = Int64toInt32(getLeftSecond_s64(itemExpiration))
          if remainTime <= 0 then
            return true
          end
        end
      end
    end
  end
  return false
end
function FromClient_CompetitionJoin_HandleChangeReservationInfo(dayIndex, dayValue, dayOfWeekValue, reservationGuildName, guildNo, isReservation)
  if nil == Panel_CompetitionGame_JoinDesc then
    return
  end
  local self = competitionGameJoinDesc
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
function FromClient_CompetitionJoin_RequestTransferHost(hostCharacterName, userNo)
  local self = competitionGameJoinDesc
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
function FromClient_CompetitionJoin_ChangedHost(isHostMyself)
  if true == isHostMyself then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GET_ARSHAHOST"))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RELEASE_ARSHAHOST_DESC"))
    FGlobal_ArshaPvP_Close()
  end
end
function FromClient_CompetitionJoin_ChangeAssistant(isAssistant)
  if true == isAssistant then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_SET_TO_ASSISTANT"))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITIONGAME_RELEASE_FROM_ASSISTANT"))
  end
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
function PaGlobalFunc_CompetitionGameJoinDesc_CheckLoadUI()
  local rv = reqLoadUI("UI_Data/Window/CompetitionGame/Panel_CompetitionGame_JoinDesc.XML", "Panel_CompetitionGame_JoinDesc", Defines.UIGroup.PAGameUIGroup_Windows, SETRENDERMODE_BITSET_DEFULAT())
  if nil ~= rv and 0 ~= rv then
    Panel_CompetitionGame_JoinDesc = rv
    rv = nil
    competitionGameJoinDesc:initialize()
  end
end
function PaGlobalFunc_CompetitionGameJoinDesc_CheckCloseUI(isAni)
  if nil == Panel_CompetitionGame_JoinDesc then
    return
  end
  reqCloseUI(Panel_CompetitionGame_JoinDesc, isAni)
end
function PaGlobalFunc_CompetitionGameJoinDesc_SetShowPanel(isShow, isAni)
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobalFunc_CompetitionGameJoinDesc_SetShowPanel isShow nil", "\236\160\149\236\167\128\237\152\156")
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_CompetitionGame_JoinDesc:SetShow(isShow, isAni)
    return
  end
  if true == isShow then
    PaGlobalFunc_CompetitionGameJoinDesc_CheckLoadUI()
    if nil ~= Panel_CompetitionGame_JoinDesc then
      Panel_CompetitionGame_JoinDesc:SetShow(isShow, isAni)
    end
  else
    PaGlobalFunc_CompetitionGameJoinDesc_CheckCloseUI(isAni)
  end
end
function competitionGameJoinDesc:registMessageHandler()
  registerEvent("FromClient_ChangeReservationInfo", "FromClient_CompetitionJoin_HandleChangeReservationInfo")
  registerEvent("FromClient_RequestTransferHost", "FromClient_CompetitionJoin_RequestTransferHost")
  registerEvent("FromClient_ChangedHost", "FromClient_CompetitionJoin_ChangedHost")
  registerEvent("FromClient_ChangeAssistant", "FromClient_CompetitionJoin_ChangeAssistant")
end
function FromClient_luaLoadComplete_CompetitionGameJoinDesc()
  competitionGameJoinDesc:registMessageHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_CompetitionGameJoinDesc")

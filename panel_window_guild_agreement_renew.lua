local Window_GuildAgreementInfo = {
  _ui = {
    _static_AgreementContentBg = UI.getChildControl(Panel_Console_Window_GuildAgreement, "Static_AgreementContentBg"),
    _static_ConstractInfoBg = UI.getChildControl(Panel_Console_Window_GuildAgreement, "Static_ConstractInfoBg"),
    _static_TopBg = UI.getChildControl(Panel_Console_Window_GuildAgreement, "Static_TopBg"),
    _static_BottomBg = UI.getChildControl(Panel_Console_Window_GuildAgreement, "Static_BottomBg")
  },
  _keyguide = {},
  _isJoin = false,
  _usableActivity,
  _memberIndex = -1,
  _memberBenefit,
  _memberPenalty,
  _targetName,
  _isRenew = false,
  _targetActorKeyRaw,
  _usableActivity,
  _sendContractPeriod,
  _sendDailyPayment,
  _sendPenaltyCost,
  _s64_guildNo = 0,
  _inviteGuildName,
  _inviteGuildMasterFamilyName,
  _inviteGuildMasterCharacterName,
  _period,
  _dailyPayment,
  _penaltyCost
}
function Window_GuildAgreementInfo:Initialize()
  self:InitControl()
  self:InitEvent()
end
function Window_GuildAgreementInfo:InitControl()
  self._ui._staticText_Content = UI.getChildControl(self._ui._static_AgreementContentBg, "StaticText_Content")
  self._ui._staticText_Content:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._staticText_Content:SetAutoResize(true)
  self._ui._staticText_Content:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_3"))
  self._ui._staticText_Periodvalue = UI.getChildControl(self._ui._static_ConstractInfoBg, "StaticText_PeriodValue")
  self._ui._staticText_DailyPaymentValue = UI.getChildControl(self._ui._static_ConstractInfoBg, "StaticText_DailyPaymentValue")
  self._ui._staticText_PenaltyCostValue = UI.getChildControl(self._ui._static_ConstractInfoBg, "StaticText_PenaltyCostValue")
  self._ui._staticText_FromValue = UI.getChildControl(self._ui._static_ConstractInfoBg, "StaticText_FromValue")
  self._ui._staticText_ToValue = UI.getChildControl(self._ui._static_ConstractInfoBg, "StaticText_ToValue")
  self._ui._staticText_Title = UI.getChildControl(self._ui._static_TopBg, "StaticText_TitleIcon")
  self._ui._staticText_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_2"))
  self._ui._button_Confirm = UI.getChildControl(self._ui._static_BottomBg, "Button_Confirm")
  self._ui._button_Renew = UI.getChildControl(self._ui._static_BottomBg, "Button_Renew")
  self._ui._button_Option = UI.getChildControl(self._ui._static_BottomBg, "Button_Option")
  self._ui._button_Close = UI.getChildControl(self._ui._static_BottomBg, "Button_Close")
  self._keyguide = {
    self._ui._button_Confirm,
    self._ui._button_Renew,
    self._ui._button_Option,
    self._ui._button_Close
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguide, self._ui._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 30)
end
function Window_GuildAgreementInfo:InitEvent()
  self._ui._button_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_AgreementGuild_Close()")
  self._ui._button_Option:addInputEvent("Mouse_LUp", "PaGlobalFunc_AgreementGuild_SignOption_Open()")
end
function PaGlobalFunc_AgreementGuild_Master_ContractOpen(memberIndex, requesterMemberGrade, usableActivity)
  local self = Window_GuildAgreementInfo
  self._isJoin = false
  if usableActivity > 10000 then
    usableActivity = 10000
  end
  self._usableActivity = usableActivity
  local memberInfo = ToClient_GetMyGuildInfoWrapper():getMember(memberIndex)
  if nil == memberInfo then
    _PA_ASSERT(false, "FGlobal_AgreementGuild_Master_Open \236\157\152 \235\169\164\235\178\132\236\157\184\235\141\177\236\138\164\234\176\128 \235\185\132\236\160\149\236\131\129\236\158\133\235\139\136\235\139\164 " .. tostring(memberIndex))
  end
  local name = memberInfo:getName()
  local expiration = memberInfo:getContractedExpirationUtc()
  self._memberIndex = memberIndex
  self._memberBenefit = memberInfo:getContractedBenefit()
  self._memberPenalty = memberInfo:getContractedPenalty()
  self._ui._staticText_Content:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_3"))
  local periodText
  if 0 < Int64toInt32(getLeftSecond_TTime64(expiration)) then
    periodText = convertStringFromDatetime(getLeftSecond_TTime64(expiration))
  else
    periodText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_REMAINPERIOD")
  end
  self._ui._staticText_Periodvalue:SetShow(true)
  self._ui._staticText_Periodvalue:SetText(periodText)
  self._ui._staticText_DailyPaymentValue:SetShow(true)
  self._ui._staticText_DailyPaymentValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(self._memberBenefit)))
  self._ui._staticText_PenaltyCostValue:SetShow(true)
  self._ui._staticText_PenaltyCostValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(self._memberPenalty)))
  self._targetName = name
  self._ui._staticText_ToValue:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui._staticText_ToValue:SetText(name)
  self._ui._staticText_FromValue:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui._staticText_FromValue:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORLDMAP_GUILDHOUSECONTROL_OWNGUILD_MASTER_TITLE"))
  self._isRenew = false
  local contractAble = memberInfo:getContractableUtc()
  local contractAbleTo = false
  if 0 == requesterMemberGrade then
    if 0 >= Int64toInt32(getLeftSecond_TTime64(contractAble)) then
      isRenew = true
    else
      isRenew = false
    end
  elseif 1 == requesterMemberGrade then
    if 0 >= Int64toInt32(getLeftSecond_TTime64(contractAble)) then
      contractAbleTo = true
    else
      contractAbleTo = false
    end
    isRenew = 2 == memberInfo:getGrade() and contractAbleTo
  else
    isRenew = false
  end
  self._ui._button_Confirm:SetShow(false)
  self._ui._button_Renew:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_AGREEMENTGUILDMASTER_BTN_PERIOD_RENEW"))
  self._ui._button_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_AgreementGuild_Close()")
  if true == isRenew then
    self._ui._button_Option:SetShow(true)
    self._ui._button_Renew:SetShow(true)
  else
    self._ui._button_Option:SetShow(false)
    self._ui._button_Renew:SetShow(false)
  end
  if true == _ContentsGroup_isConsolePadControl then
    if true == isRenew then
      Panel_Console_Window_GuildAgreement:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_AgreementGuild_SendReContract()")
      Panel_Console_Window_GuildAgreement:registerPadEvent(__eConsoleUIPadEvent_Y, "PaGlobalFunc_AgreementGuild_SignOption_Open()")
    else
      Panel_Console_Window_GuildAgreement:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
      Panel_Console_Window_GuildAgreement:registerPadEvent(__eConsoleUIPadEvent_Y, "")
    end
    Panel_Console_Window_GuildAgreement:registerPadEvent(__eCONSOLE_UI_INPUT_TYPE_B, "PaGlobalFunc_AgreementGuild_Close()")
  end
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  local guildName = guildWrapper:getName()
  self._ui._staticText_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_CONTRACT", "guildName", guildName))
  PaGlobalFunc_AgreementGuild_Open()
end
function PaGlobal_AgreementGuild_InviteOpen(isJoin, hostUsername, hostname, guildName, period, benefit, penalty, s64_guildNo)
  local self = Window_GuildAgreementInfo
  self._s64_guildNo = s64_guildNo
  if getSelfPlayer():get():isGuildMaster() then
    return
  end
  self._isJoin = isJoin
  self._inviteGuildName = guildName
  self._inviteGuildMasterFamilyName = hostUsername
  self._inviteGuildMasterCharacterName = hostname
  self._period = period
  self._dailyPayment = benefit
  self._penaltyCost = penalty
  self._ui._staticText_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_CONTRACT", "guildName", self._inviteGuildName))
  self._ui._staticText_Periodvalue:SetText(self._period .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY"))
  self._ui._staticText_DailyPaymentValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(self._dailyPayment)))
  self._ui._staticText_PenaltyCostValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(self._penaltyCost)))
  self._ui._staticText_FromValue:SetText(self._inviteGuildMasterFamilyName .. "(" .. self._inviteGuildMasterCharacterName .. ")")
  local myNick = getSelfPlayer():getUserNickname()
  self._ui._staticText_ToValue:SetText(myNick)
  self._ui._button_Confirm:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDAGREEMENT_CONTRACT"))
  self._ui._button_Confirm:SetShow(true)
  self._ui._button_Option:SetShow(false)
  self._ui._button_Renew:SetShow(false)
  if _ContentsGroup_isConsolePadControl then
    Panel_Console_Window_GuildAgreement:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_AgreementGuild_AgreementConfirm()")
    Panel_Console_Window_GuildAgreement:registerPadEvent(__eCONSOLE_UI_INPUT_TYPE_B, "PaGlobalFunc_AgreementGuild_Master_InviteRefuse()")
    Panel_Console_Window_GuildAgreement:registerPadEvent(__eConsoleUIPadEvent_Y, "")
  end
  PaGlobalFunc_AgreementGuild_Open()
end
function PaGlobalFunc_AgreementGuild_Master_InviteRefuse()
  local self = Window_GuildAgreementInfo
  if self._isJoin then
    ToClient_RequestRefuseGuildInvite()
  else
    ToClient_RenewGuildContract(false)
  end
  PaGlobalFunc_AgreementGuild_Close()
end
function PaGlobalFunc_AgreementGuild_AgreementConfirm()
  local self = Window_GuildAgreementInfo
  local inputName = getSelfPlayer():getUserNickname()
  if self._isJoin then
    ToClient_RequestAcceptGuildInvite()
  else
    ToClient_RenewGuildContract(true)
  end
  PaGlobalFunc_AgreementGuild_Close()
end
function PaGlobalFunc_AgreementGuild_SendReContract()
  local self = Window_GuildAgreementInfo
  ToClient_SuggestGuildContract(self._memberIndex, tonumber(self._sendContractPeriod), tonumber(self._sendDailyPayment), tonumber(self._sendPenaltyCost))
  PaGlobalFunc_AgreementGuild_Close()
end
function PaGlobalFunc_AgreementGuild_SendInvite()
  local self = Window_GuildAgreementInfo
  toClient_RequestInviteGuild(self._targetName, tonumber(self._sendContractPeriod), tonumber(self._sendDailyPayment), tonumber(self._sendPenaltyCost))
  PaGlobalFunc_AgreementGuild_Close()
end
function PaGlobalFunc_AgreementGuild_Open_ForJoin(targetKeyRaw, targetName, preGuildActivity)
  local self = Window_GuildAgreementInfo
  self._targetActorKeyRaw = targetKeyRaw
  self._isJoin = true
  self._targetName = targetName
  self._ui._staticText_ToValue:SetText(targetName)
  self._ui._staticText_FromValue:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORLDMAP_GUILDHOUSECONTROL_OWNGUILD_MASTER_TITLE"))
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  local guildName = guildWrapper:getName()
  self._ui._staticText_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_CONTRACT", "guildName", guildName))
  self._ui._button_Confirm:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDAGREEMENT_CONTRACT"))
  self._ui._button_Confirm:SetShow(true)
  self._ui._button_Renew:SetShow(false)
  self._ui._button_Option:SetShow(true)
  if _ContentsGroup_isConsolePadControl then
    Panel_Console_Window_GuildAgreement:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_AgreementGuild_SendInvite()")
    Panel_Console_Window_GuildAgreement:registerPadEvent(__eCONSOLE_UI_INPUT_TYPE_B, "PaGlobalFunc_AgreementGuild_Close()")
    Panel_Console_Window_GuildAgreement:registerPadEvent(__eConsoleUIPadEvent_Y, "PaGlobalFunc_AgreementGuild_SignOption_Open()")
  end
  PaGlobalFunc_AgreementGuild_SignOption_Open()
  PaGlobalFunc_AgreementGuild_SignOption_ContractDaySetData(4)
  PaGlobalFunc_AgreementGuild_SignOption_Confirm()
  PaGlobalFunc_AgreementGuild_Open()
end
function PaGlobalFunc_AgreementGuild_AgreementSetData(contractPeriod, dailyPayment, value_penaltyCost)
  local self = Window_GuildAgreementInfo
  self._sendContractPeriod = contractPeriod
  self._sendDailyPayment = dailyPayment
  self._sendPenaltyCost = value_penaltyCost
  self._ui._staticText_Periodvalue:SetText(self._sendContractPeriod .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY"))
  self._ui._staticText_DailyPaymentValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(self._sendDailyPayment)))
  self._ui._staticText_PenaltyCostValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(self._sendPenaltyCost)))
end
function PaGlobalFunc_AgreementGuild_GetIsJoin()
  local self = Window_GuildAgreementInfo
  return self._isJoin
end
function PaGlobalFunc_AgreementGuild_GetData()
  local self = Window_GuildAgreementInfo
  return self._usableActivity, self._memberBenefit, self._memberPenalty
end
function PaGlobalFunc_AgreementGuild_Master_GetShow()
  return Panel_Console_Window_GuildAgreement:GetShow()
end
function PaGlobalFunc_AgreementGuild_Open()
  local self = Window_GuildAgreementInfo
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguide, self._ui._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 30)
  PaGlobalFunc_AgreementGuild_Master_SetShow(true, false)
end
function PaGlobalFunc_AgreementGuild_Close()
  local self = Window_GuildAgreementInfo
  self._memberIndex = -1
  self._isJoin = false
  self._usableActivity = nil
  self._memberIndex = -1
  self._memberBenefit = nil
  self._memberPenalty = nil
  self._targetName = nil
  self._isRenew = false
  self._targetActorKeyRaw = nil
  self._usableActivity = nil
  self._sendContractPeriod = nil
  self._sendDailyPayment = nil
  self._sendPenaltyCost = nil
  self._s64_guildNo = 0
  self._inviteGuildName = nil
  self._inviteGuildMasterFamilyName = nil
  self._inviteGuildMasterCharacterName = nil
  self._period = nil
  self._dailyPayment = nil
  self._penaltyCost = nil
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  PaGlobalFunc_AgreementGuild_Master_SetShow(false, false)
end
function PaGlobalFunc_AgreementGuild_Master_SetShow(isShow, isAni)
  Panel_Console_Window_GuildAgreement:SetShow(isShow, isAni)
end
function PaGlobalFunc_FromClient_GuildAgreement_luaLoadComplete()
  local self = Window_GuildAgreementInfo
  self:Initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_GuildAgreement_luaLoadComplete")

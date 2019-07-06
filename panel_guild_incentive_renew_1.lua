function PaGlobal_GuildIncentive:initialize()
  if true == PaGlobal_GuildIncentive._initialize then
    return
  end
  local txt_fundationDesc = UI.getChildControl(Panel_Guild_Incentive_SetFund, "StaticText_Desc")
  txt_fundationDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_fundationDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_INCENTIVE_FOUNDATION_DESC"))
  local txt_fundationValue = UI.getChildControl(Panel_Guild_Incentive_SetFund, "Edit_MoneyValue")
  txt_fundationValue:SetEditText("", true)
  Panel_Guild_Incentive_SetFund:ignorePadSnapMoveToOtherPanel()
  local txt_optionDesc = UI.getChildControl(Panel_Guild_Incentive_MemberList, "StaticText_Incentive_Explain")
  txt_optionDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_optionDesc:SetText(txt_optionDesc:GetText())
  local keyGuideBG = UI.getChildControl(Panel_Guild_Incentive_MemberList, "Static_BottomKeyBG")
  local stc_keyGuideY = UI.getChildControl(keyGuideBG, "StaticText_SendIncentive_ConsoleUI")
  local stc_keyGuideX = UI.getChildControl(keyGuideBG, "StaticText_AllSetting_ConsoleUI")
  local stc_keyGuideA = UI.getChildControl(keyGuideBG, "StaticText_IndividualSetting_ConsoleUI")
  local stc_keyGuideB = UI.getChildControl(keyGuideBG, "StaticText_Cancel_ConsoleUI")
  local keyGuideTable = {
    stc_keyGuideY,
    stc_keyGuideX,
    stc_keyGuideA,
    stc_keyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuideTable, keyGuideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  Panel_Guild_Incentive_MemberList:ignorePadSnapMoveToOtherPanel()
  PaGlobal_GuildIncentive._defaultLevelPanelSizeY = Panel_Guild_Incentive_Tier:GetSizeY()
  PaGlobal_GuildIncentive._defaultLevelBGSizeY = UI.getChildControl(Panel_Guild_Incentive_Tier, "Static_CenterBg"):GetSizeY()
  Panel_Guild_Incentive_Tier:ignorePadSnapMoveToOtherPanel()
  PaGlobal_GuildIncentive:registEventHandler()
  PaGlobal_GuildIncentive:validate()
  PaGlobal_GuildIncentive._initialize = true
end
function PaGlobal_GuildIncentive:registEventHandler()
  if nil == Panel_Guild_Incentive_SetFund then
    return
  end
  Panel_Guild_Incentive_SetFund:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobal_GuildIncentive_SetTotalFundation()")
  Panel_Guild_Incentive_SetFund:registerPadEvent(__eConsoleUIPadEvent_Up_A, " PaGlobal_GuildIncentive:memberListPrepareOpen()")
  PaGlobal_GuildIncentive._ui._list2_guildMember:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_GuildIncentive_addGuildMemberContent")
  PaGlobal_GuildIncentive._ui._list2_guildMember:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  Panel_Guild_Incentive_MemberList:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobal_GuildIncentive:sendIncentive()")
  Panel_Guild_Incentive_MemberList:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobal_GuildIncentive:setIncentiveGrade(false)")
end
function PaGlobal_GuildIncentive:prepareOpen()
  if nil == Panel_Guild_Incentive_SetFund then
    return
  end
  PaGlobal_GuildIncentive:fundationPrepareOpen()
  PaGlobal_GuildIncentive:open()
end
function PaGlobal_GuildIncentive:open()
  if nil == Panel_Guild_Incentive_SetFund then
    return
  end
  Panel_Guild_Incentive_SetFund:SetShow(true)
end
function PaGlobal_GuildIncentive:prepareClose()
  if nil == Panel_Guild_Incentive_SetFund then
    return
  end
  PaGlobal_GuildIncentive:close()
end
function PaGlobal_GuildIncentive:close()
  if nil == Panel_Guild_Incentive_SetFund then
    return
  end
  Panel_Guild_Incentive_SetFund:SetShow(false)
  Panel_Guild_Incentive_MemberList:SetShow(false)
end
function PaGlobal_GuildIncentive:update()
  if nil == Panel_Guild_Incentive_SetFund then
    return
  end
end
function PaGlobal_GuildIncentive:validate()
  if nil == Panel_Guild_Incentive_SetFund then
    return
  end
end
function PaGlobal_GuildIncentive:fundationPrepareOpen()
  PaGlobal_GuildIncentive._totalFundation = nil
  PaGlobal_GuildIncentive._totalFundation64 = nil
  PaGlobal_GuildIncentive._ui._edit_totalFundation:SetEditText("", true)
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local businessFunds = myGuildListInfo:getGuildBusinessFunds_s64()
  local businessFunds10 = businessFunds * toInt64(0, 10) / toInt64(0, 100)
  local businessFunds30 = businessFunds * toInt64(0, 40) / toInt64(0, 100)
  local txt_fundationBG = UI.getChildControl(Panel_Guild_Incentive_SetFund, "Static_GuildFundBG")
  local txt_totalFund = UI.getChildControl(txt_fundationBG, "StaticText_TotalFund")
  local txt_possibleFund = UI.getChildControl(txt_fundationBG, "StaticText_PossibleFund")
  txt_totalFund:SetText(makeDotMoney(businessFunds))
  txt_possibleFund:SetText(makeDotMoney(businessFunds10) .. " ~ " .. makeDotMoney(businessFunds30))
end
function PaGlobal_GuildIncentive_SetTotalFundation()
  if nil == Panel_Guild_Incentive_SetFund then
    return
  end
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local businessFunds = myGuildListInfo:getGuildBusinessFunds_s64()
  local businessFunds30 = businessFunds * toInt64(0, 40) / toInt64(0, 100)
  Panel_NumberPad_Show(true, businessFunds30, nil, PaGlobal_GuildIncentive_FundationValueConfirm)
end
function PaGlobal_GuildIncentive_FundationValueConfirm(inputNumber)
  if nil == Panel_Guild_Incentive_SetFund then
    return
  end
  PaGlobal_GuildIncentive._ui._edit_totalFundation:SetEditText(makeDotMoney(inputNumber), false)
  PaGlobal_GuildIncentive._totalFundation = Int64toInt32(inputNumber)
  PaGlobal_GuildIncentive._totalFundation64 = inputNumber
end
function PaGlobal_GuildIncentive:memberListPrepareOpen()
  if nil == Panel_Guild_Incentive_SetFund or nil == Panel_Guild_Incentive_MemberList then
    return
  end
  if nil == PaGlobal_GuildIncentive._totalFundation then
    return
  end
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  PaGlobal_GuildIncentive._selectedMemberIndex = nil
  PaGlobal_GuildIncentive._isIndividualSetting = false
  PaGlobal_GuildIncentive._guildMemberFundLevelList = {}
  local businessFunds = myGuildListInfo:getGuildBusinessFunds_s64()
  local businessFunds10 = businessFunds * toInt64(0, 10) / toInt64(0, 100)
  local businessFunds30 = businessFunds * toInt64(0, 40) / toInt64(0, 100)
  if businessFunds10 > PaGlobal_GuildIncentive._totalFundation64 or businessFunds30 < PaGlobal_GuildIncentive._totalFundation64 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_INCENTIVE_FOUNDATION_RANGEOFMONEY_ALERT"))
    return
  end
  ToClient_InitGuildIncentiveList(PaGlobal_GuildIncentive._totalFundation64)
  PaGlobal_GuildIncentive:initializeGuildMemberList()
  PaGlobal_GuildIncentive:updateGuildMemberList()
  local fundBG = UI.getChildControl(Panel_Guild_Incentive_MemberList, "Static_GuildFundBG")
  local guildTotalFund = UI.getChildControl(fundBG, "StaticText_TotalFund")
  local incentiveTotalFund = UI.getChildControl(fundBG, "StaticText_PossibleFund")
  guildTotalFund:SetText(makeDotMoney(businessFunds))
  incentiveTotalFund:SetText(makeDotMoney(PaGlobal_GuildIncentive._totalFundation64))
  Panel_Guild_Incentive_SetFund:SetShow(false)
  Panel_Guild_Incentive_MemberList:SetShow(true)
end
function PaGlobal_GuildIncentive:initializeGuildMemberList()
  if nil == Panel_Guild_Incentive_MemberList then
    return
  end
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local guildMemberCount = ToClient_getGuildIncentiveListCount()
  PaGlobal_GuildIncentive._ui._list2_guildMember:getElementManager():clearKey()
  for index = 1, guildMemberCount do
    PaGlobal_GuildIncentive._ui._list2_guildMember:getElementManager():pushKey(toInt64(0, index))
  end
end
function PaGlobal_GuildIncentive:updateGuildMemberList()
  if nil == Panel_Guild_Incentive_MemberList then
    return
  end
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local guildMemberCount = ToClient_getGuildIncentiveListCount()
  for index = 1, guildMemberCount do
    PaGlobal_GuildIncentive._ui._list2_guildMember:requestUpdateByKey(toInt64(0, index))
  end
end
function PaGlobal_GuildIncentive_addGuildMemberContent(control, key)
  if nil == Panel_Guild_Incentive_MemberList then
    return
  end
  if nil == control or nil == key then
    return
  end
  local guildMemberIndex = Int64toInt32(key)
  local guildMemberInfo = ToClient_getMemberGuildIncentiveListByIndex(guildMemberIndex - 1)
  if nil == guildMemberInfo then
    return
  end
  local stc_memberGrade = UI.getChildControl(control, "StaticText_Grade")
  local txt_charName = UI.getChildControl(control, "StaticText_CharName")
  local txt_contributePoint = UI.getChildControl(control, "StaticText_ContributedTendency")
  local txt_incentiveValue = UI.getChildControl(control, "StaticText_IncentiveValue")
  local txt_taxRate = UI.getChildControl(control, "StaticText_TaxRate")
  local txt_fundLevel = UI.getChildControl(control, "StaticText_FundLevel")
  local gradeType = guildMemberInfo:getGrade()
  local gradeValue = ""
  if 0 == gradeType then
    gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMASTER")
  elseif 1 == gradeType then
    gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDSUBMASTER")
  elseif 2 == gradeType then
    gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMEMBER")
  elseif 3 == gradeType then
    gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_SUPPLYOFFICER")
  end
  local grade = ToClient_getGuildMemberIncentiveGrade(guildMemberIndex - 1)
  local usableActivity = guildMemberInfo:getUsableActivity()
  local tempActivityText = tostring(guildMemberInfo:getTotalActivity()) .. "(+" .. tostring(usableActivity) .. ")"
  local incentive = ToClient_getGuildMemberIncentiveMoney_s64(guildMemberIndex - 1)
  local incentiveAfterTax = ToClient_getGuildMemberIncentiveMoneyAfterTax_s64(guildMemberIndex - 1)
  local rate = ToClient_GetCalculateRate(incentiveAfterTax, incentive)
  rate = 1 - rate
  rate = rate * 100
  rate = math.ceil(rate)
  stc_memberGrade:SetText(gradeValue)
  txt_charName:SetText(guildMemberInfo:getName())
  txt_contributePoint:SetText(tempActivityText)
  txt_incentiveValue:SetText(makeDotMoney(incentive))
  txt_taxRate:SetText(tostring(rate) .. "%")
  txt_fundLevel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_INCENTIVE_GRADE_FOR_WHAT", "grade", tostring(grade)))
  control:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_GuildIncentive:setIncentiveGrade(true," .. guildMemberIndex .. ")")
end
function PaGlobal_GuildIncentive:sendIncentive()
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_PAYMENTS")
  local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_PAYMENTS_CONFIRM")
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = PayIncentiveConfirm,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PayIncentiveConfirm()
  ToClient_PayGuildMemberIncentive()
  PaGlobal_GuildIncentive:prepareClose()
end
function PaGlobal_GuildIncentive:setIncentiveGrade(isIndividualSetting, index)
  PaGlobal_GuildIncentive._selectedMemberIndex = index
  PaGlobal_GuildIncentive._isIndividualSetting = isIndividualSetting
  PaGlobal_GuildIncentiveTier_Show()
end
function PaGlobal_GuildIncentive_setIncentiveGrade_CallBack(grade)
  if nil == Panel_Guild_Incentive_MemberList or nil == Panel_Guild_Incentive_Tier or nil == grade then
    return
  end
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local totalMoney = PaGlobal_GuildIncentive._totalFundation64
  if false == PaGlobal_GuildIncentive._isIndividualSetting then
    local memberCount = ToClient_getGuildIncentiveListCount()
    for index = 1, memberCount do
      PaGlobal_GuildIncentive._guildMemberFundLevelList[index] = Int64toInt32(grade)
      ToClient_SetGuildMemberIncentiveGrade(index - 1, Int64toInt32(grade), totalMoney)
    end
  else
    PaGlobal_GuildIncentive._guildMemberFundLevelList[PaGlobal_GuildIncentive._selectedMemberIndex] = Int64toInt32(grade)
    ToClient_SetGuildMemberIncentiveGrade(PaGlobal_GuildIncentive._selectedMemberIndex - 1, Int64toInt32(grade), totalMoney)
  end
  if true == Panel_Guild_Incentive_Tier:GetShow() then
    PaGlobal_GuildIncentiveTier_Close()
  end
  PaGlobal_GuildIncentive:updateGuildMemberList()
end
function PaGlobal_GuildIncentiveTier_Open()
  Panel_Guild_Incentive_Tier:SetShow(true, true)
end
function PaGlobal_GuildIncentiveTier_Close()
  Panel_Guild_Incentive_Tier:SetShow(false, false)
end
function PaGlobal_GuildIncentiveTier_Show()
  local panel = Panel_Guild_Incentive_Tier
  local stc_TierTitle = UI.getChildControl(panel, "StaticText_Title")
  local stc_TierCenterBG = UI.getChildControl(panel, "Static_CenterBg")
  local stc_Caution = UI.getChildControl(stc_TierCenterBG, "StaticText_Caution")
  local stc_BottomBg = UI.getChildControl(panel, "Static_BottomBg")
  local panelSizeY = PaGlobal_GuildIncentive._defaultLevelPanelSizeY
  local bgSizeY = PaGlobal_GuildIncentive._defaultLevelBGSizeY
  local btn_level = {}
  local maxLevelCnt = 10
  for index = 1, maxLevelCnt do
    btn_level[index] = UI.getChildControl(stc_TierCenterBG, "Button_" .. index)
    btn_level[index]:addInputEvent("Mouse_LUp", "PaGlobal_GuildIncentive_setIncentiveGrade_CallBack(" .. index .. ")")
  end
  if PaGlobal_GuildIncentive._isIndividualSetting then
    stc_TierTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INCENTIVE_FUNDGRADECHANGEONE"))
    stc_Caution:SetText("")
    stc_Caution:SetShow(false)
  else
    stc_TierTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INCENTIVE_FUNDGRADECHANGEALL"))
    stc_Caution:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    stc_Caution:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDINCENTIVE_ALLPAYMESSAGE"))
    stc_Caution:SetShow(true)
    panelSizeY = PaGlobal_GuildIncentive._defaultLevelPanelSizeY + stc_Caution:GetSizeY()
    bgSizeY = PaGlobal_GuildIncentive._defaultLevelBGSizeY + stc_Caution:GetSizeY()
  end
  panel:SetSize(panel:GetSizeX(), panelSizeY)
  stc_TierCenterBG:SetSize(stc_TierCenterBG:GetSizeX(), bgSizeY)
  panel:ComputePos()
  stc_TierCenterBG:ComputePos()
  stc_BottomBg:ComputePos()
  PaGlobal_GuildIncentiveTier_Open()
end

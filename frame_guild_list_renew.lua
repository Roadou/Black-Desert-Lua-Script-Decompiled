local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local UI_Class = CppEnums.ClassType
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local IM = CppEnums.EProcessorInputMode
local VCK = CppEnums.VirtualKeyCode
local _constGuildListMaxCount = 150
local _startMemberIndex = 0
local _constStartY = 5
local _constStartButtonX = 5
local _constStartButtonY = 5
local _constStartButtonGapY = 30
local _constCollectionX = 120
local _constCollectionY = 80
local _selectIndex = 0
local _onlineGuildMember = 0
local _myindex
local _initMoney = false
local _UI_Menu_Button = {
  Type_Whisper = 0,
  Type_AppointCommander = 1,
  Type_CancelAppoint = 2,
  Type_ChangeMaster = 3,
  Type_ProtectMember = 4,
  Type_CancelProtectMember = 5,
  Type_PartyInvite = 6,
  Type_Supply = 7,
  Type_Deportation = 8,
  Type_PriceLimit = 9,
  Type_Count = 10
}
local numberKeyCode = {
  VCK.KeyCode_0,
  VCK.KeyCode_1,
  VCK.KeyCode_2,
  VCK.KeyCode_3,
  VCK.KeyCode_4,
  VCK.KeyCode_5,
  VCK.KeyCode_6,
  VCK.KeyCode_7,
  VCK.KeyCode_8,
  VCK.KeyCode_9,
  VCK.KeyCode_NUMPAD0,
  VCK.KeyCode_NUMPAD1,
  VCK.KeyCode_NUMPAD2,
  VCK.KeyCode_NUMPAD3,
  VCK.KeyCode_NUMPAD4,
  VCK.KeyCode_NUMPAD5,
  VCK.KeyCode_NUMPAD6,
  VCK.KeyCode_NUMPAD7,
  VCK.KeyCode_NUMPAD8,
  VCK.KeyCode_NUMPAD9
}
local inputGuildDepositNum_s64 = toInt64(0, 0)
local inputGuildDepositMaxNum_s64 = toInt64(0, 0)
local notice_title = UI.getChildControl(Panel_Window_Guild, "StaticText_NoticeTitle")
local isVoiceOpen = ToClient_IsContentsGroupOpen("75")
GuildListInfoPage = {
  _frameDefaultBG = UI.getChildControl(Panel_Window_Guild, "Static_Frame_ListBG"),
  _buttonListBG = UI.getChildControl(Panel_Guild_List, "Static_FunctionBG"),
  listInfoTitleBG = nil,
  staticText_Grade = nil,
  staticText_Level = nil,
  staticText_Class = nil,
  staticText_activity = nil,
  staticText_contributedTendency = nil,
  staticText_contract = nil,
  staticText_charName = nil,
  staticText_Voice = nil,
  staticText_WarGrade = nil,
  listening_Volume = nil,
  listening_VolumeSlider = nil,
  listening_VolumeSliderBtn = nil,
  listening_VolumeClose = nil,
  listening_VolumeButton = nil,
  listening_VolumeValue = nil,
  _scrollBar,
  _list = {},
  _buttonList = {},
  _btnGiveIncentive,
  _btnDeposit,
  _btnPaypal,
  _btnSiegeReward,
  _btnWelfare,
  decoIcon_Guild,
  decoIcon_Clan,
  _frameGuildList,
  _contentGuildList,
  _onlineCount,
  _clickedUserNo = -1
}
local tempGuildList = {}
local tempGuildUserNolist = {}
local text_contributedTendency
local siegeGradeCount = {
  grade1 = 0,
  grade2 = 0,
  grade3 = 0,
  grade4 = 0,
  grade5 = 0
}
Panel_GuildIncentive:SetShow(false)
local incentive_InputMoney = UI.getChildControl(Panel_GuildIncentive, "Edit_InputIncentiveValue")
local btn_incentive_Send = UI.getChildControl(Panel_GuildIncentive, "Button_Confirm")
local btn_incentive_Cancle = UI.getChildControl(Panel_GuildIncentive, "Button_Cancle")
local btn_incentive_Help = UI.getChildControl(Panel_GuildIncentive, "Button_Question")
incentive_InputMoney:SetNumberMode(true)
local txt_incentive_Title = UI.getChildControl(Panel_GuildIncentive, "StaticText_Title")
local txt_incentive_Deposit = UI.getChildControl(Panel_GuildIncentive, "StaticText_Incentive")
local txt_incentive_Notify = UI.getChildControl(Panel_GuildIncentive, "StaticText_Notify")
txt_incentive_Notify:SetTextMode(UI_TM.eTextMode_AutoWrap)
incentive_InputMoney:addInputEvent("Mouse_LUp", "HandleClicked_SetIncentive()")
btn_incentive_Send:addInputEvent("Mouse_LUp", "HandleClicked_GuildIncentive_Send()")
btn_incentive_Cancle:addInputEvent("Mouse_LUp", "HandleClicked_GuildIncentive_Close()")
btn_incentive_Help:addInputEvent("Mouse_LUp", "")
incentive_InputMoney:RegistReturnKeyEvent("FGlobal_SaveGuildMoney_Send()")
local btn_GuildMasterMandateBG = UI.getChildControl(Panel_Window_Guild, "Static_InfoArea")
local btn_GuildMasterMandate = UI.getChildControl(btn_GuildMasterMandateBG, "Button_GuildMandate")
local frameSizeY = 0
local contentSizeY = 0
local _incentivePanelType = 0
local _selectSortType = -1
local _listSort = {
  grade = false,
  level = false,
  class = false,
  name = false,
  ap = false,
  expiration = false,
  wp = false,
  kp = false,
  siegegrade = false
}
local isSiegeSeason5 = ToClient_IsContentsGroupOpen("388")
local isWarGradeOpen = isSiegeSeason5
local setVol_selectedMemberIdx = 0
local setVol_selectedMemberVol = 0
function _guildListInfoPage_titleTooltipShow(isShow, titleType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local self = GuildListInfoPage
  local control, name, desc
  if 0 == titleType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_ACTIVITY_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_ACTIVITY_CONTENTS")
    control = self.staticText_activity
  elseif 1 == titleType then
    control = self.staticText_contributedTendency
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRIBUTEDTENDENCY_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRIBUTEDTENDENCY_CONTENTS")
  elseif 2 == titleType then
    control = self.staticText_contract
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRACT_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRACT_CONTENTS")
  elseif 3 == titleType then
    control = self.staticText_contributedTendency
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_CONTRIBUTEDTENDENCY_TOOLTIP_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_CONTRIBUTEDTENDENCY_TOOLTIP_DESC")
  elseif 4 == titleType then
    control = self.staticText_Voice
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_VOICECHAT_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_VOICECHAT_TOOLTIP_DESC")
  elseif 5 == titleType then
    control = self.staticText_WarGrade
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_NAME")
    local desc2 = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_DESC_2", "grade5", tostring(siegeGradeCount.grade5))
    desc = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_DESC", "grade1", tostring(siegeGradeCount.grade1), "grade2", tostring(siegeGradeCount.grade2), "grade3", tostring(siegeGradeCount.grade3), "grade4", tostring(siegeGradeCount.grade4))
  end
  TooltipSimple_Show(control, name, desc)
end
function _guildListInfoPage_MandateTooltipShow(isShow, titleType, controlIdx)
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local dataIdx = tempGuildList[controlIdx + 1].idx
  local myGuildMemberInfo = myGuildListInfo:getMember(dataIdx)
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local channelName = getChannelName(worldNo, myGuildMemberInfo:getServerNo())
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local memberChannel = ""
  if true == myGuildMemberInfo:isOnline() and false == myGuildMemberInfo:isGhostMode() then
    lastLogin = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ONLINE_MEMBER")
    memberChannel = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_CHANNEL_MEMBER", "channelName", channelName)
  else
    lastLogin = GuildLogoutTimeConvert(myGuildMemberInfo:getElapsedTimeAfterLogOut_s64())
    memberChannel = ""
  end
  if 0 == titleType then
    control = GuildListInfoPage._list[controlIdx]._contractBtn
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRACT_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_TITLETYPE5_DESC") .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_LASTLOGOUT", "lastLogin", lastLogin) .. memberChannel
  elseif 1 == titleType then
    control = GuildListInfoPage._list[controlIdx]._contractBtn
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRACT_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_TITLETYPE3_DESC") .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_LASTLOGOUT", "lastLogin", lastLogin) .. memberChannel
  elseif 2 == titleType then
    control = GuildListInfoPage._list[controlIdx]._contractBtn
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRACT_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_TITLETYPE4_DESC") .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_LASTLOGOUT", "lastLogin", lastLogin) .. memberChannel
  end
  local memberIsLimit = myGuildMemberInfo:getIsPriceLimit()
  local memberIsGrade = myGuildMemberInfo:getGrade()
  if myGuildMemberInfo:isSelf() and memberIsGrade > 0 then
    if true == memberIsLimit then
      desc = desc .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_LIMITPRICE", "limitprice", makeDotMoney(myGuildMemberInfo:getPriceLimit()))
    else
      desc = desc .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_LIMITPRICE", "limitprice", PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_LIMITPRICE_NO"))
    end
  elseif isGuildMaster and memberIsGrade > 0 then
    if true == memberIsLimit then
      desc = desc .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_LIMITPRICEOTHER", "limitprice", makeDotMoney(myGuildMemberInfo:getPriceLimit()))
    else
      desc = desc .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_LIMITPRICEOTHER", "limitprice", PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_LIMITPRICE_NO"))
    end
  end
  local guildMemberGradeType = myGuildMemberInfo:getGrade()
  if __eGuildMemberGradeJunior == guildMemberGradeType then
    local juniorTime = myGuildMemberInfo:getJuniorUpgradeData()
    local juniorYear = juniorTime:GetYear()
    local juniorMonth = juniorTime:GetMonth()
    local juniorDay = juniorTime:GetDay()
    desc = desc .. [[

- ]] .. PAGetStringParam3(Defines.StringSheet_GAME, "LUA_JUNIOR_UPGRADE_REMAIN_TIME_CONTRACT_TOOLTIP_ADD_TEXT", "year", juniorYear, "month", juniorMonth, "day", juniorDay)
  end
  if true == myGuildMemberInfo:isVacation() then
    desc = desc .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MEMBER_LIST_CONTRACT_TOOLTIP_VACATION_ADD")
  end
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function HandleOver_GuildFund_TooltipShow()
  registTooltipControl(GuildListInfoPage._textBusinessFundsBG, Panel_Tooltip_SimpleText)
  TooltipSimple_Show(GuildListInfoPage._textBusinessFundsBG, PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_GUILDMONEY"))
end
function HandleOver_GuildFund_TooltipHide()
  TooltipSimple_Hide()
end
function GuildLogoutTimeConvert(s64_datetime)
  local s64_dayCycle = toInt64(0, 86400)
  local s64_hourCycle = toInt64(0, 3600)
  local s64_day = s64_datetime / s64_dayCycle
  local s64_hour = (s64_datetime - s64_dayCycle * s64_day) / s64_hourCycle
  local strDate = ""
  if s64_day > Defines.s64_const.s64_0 then
    strDate = tostring(s64_day) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY")
  elseif s64_hour > Defines.s64_const.s64_0 then
    strDate = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY_IN")
  else
    strDate = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY_IN")
  end
  return strDate
end
function GuildListInfoPage:initialize()
  self.listInfoTitleBG = UI.getChildControl(Panel_Guild_List, "Static_List_BG")
  self.staticText_Grade = UI.getChildControl(self.listInfoTitleBG, "StaticText_M_Grade")
  self.staticText_Level = UI.getChildControl(self.listInfoTitleBG, "StaticText_M_Level")
  self.staticText_Class = UI.getChildControl(self.listInfoTitleBG, "StaticText_M_Class")
  self.staticText_activity = UI.getChildControl(self.listInfoTitleBG, "StaticText_M_Activity")
  self.staticText_contributedTendency = UI.getChildControl(self.listInfoTitleBG, "StaticText_M_ContributedTendency")
  self.staticText_contract = UI.getChildControl(self.listInfoTitleBG, "StaticText_M_Contract")
  self.staticText_charName = UI.getChildControl(self.listInfoTitleBG, "StaticText_M_CharName")
  self.staticText_Voice = UI.getChildControl(self.listInfoTitleBG, "StaticText_M_Voice")
  self.staticText_WarGrade = UI.getChildControl(self.listInfoTitleBG, "StaticText_WarGrade")
  self.listening_Volume = UI.getChildControl(Panel_Guild_List, "Static_Listening_VolumeBG")
  self.listening_VolumeSlider = UI.getChildControl(self.listening_Volume, "Slider_ListeningVolume")
  self.listening_VolumeSliderBtn = UI.getChildControl(self.listening_VolumeSlider, "Slider_MicVol_Button")
  self.listening_VolumeClose = UI.getChildControl(self.listening_Volume, "Button_VolumeSetClose")
  self.listening_VolumeButton = UI.getChildControl(self.listening_Volume, "Checkbox_SpeakerIcon")
  self.listening_VolumeValue = UI.getChildControl(self.listening_Volume, "StaticText_SpeakerVolumeValue")
  self.staticText_Grade:addInputEvent("Mouse_LUp", "HandleClicked_GuildListSort( " .. 0 .. " )")
  self.staticText_Level:addInputEvent("Mouse_LUp", "HandleClicked_GuildListSort( " .. 1 .. " )")
  self.staticText_Class:addInputEvent("Mouse_LUp", "HandleClicked_GuildListSort( " .. 2 .. " )")
  self.staticText_charName:addInputEvent("Mouse_LUp", "HandleClicked_GuildListSort( " .. 3 .. " )")
  self.staticText_activity:addInputEvent("Mouse_LUp", "HandleClicked_GuildListSort( " .. 4 .. " )")
  self.staticText_contract:addInputEvent("Mouse_LUp", "HandleClicked_GuildListSort( " .. 5 .. " )")
  self.staticText_contributedTendency:addInputEvent("Mouse_LUp", "HandleClicked_GuildListSort( " .. 6 .. " )")
  self.staticText_activity:addInputEvent("Mouse_On", "_guildListInfoPage_titleTooltipShow( true, " .. 0 .. " )")
  self.staticText_activity:addInputEvent("Mouse_Out", "_guildListInfoPage_titleTooltipShow( false," .. 0 .. " )")
  self.staticText_contract:addInputEvent("Mouse_On", "_guildListInfoPage_titleTooltipShow( true, " .. 2 .. " )")
  self.staticText_contract:addInputEvent("Mouse_Out", "_guildListInfoPage_titleTooltipShow( false," .. 2 .. " )")
  self.staticText_contributedTendency:addInputEvent("Mouse_On", "_guildListInfoPage_titleTooltipShow( true, " .. 3 .. " )")
  self.staticText_contributedTendency:addInputEvent("Mouse_Out", "_guildListInfoPage_titleTooltipShow( false, " .. 3 .. " )")
  self.staticText_Voice:SetShow(false)
  self.listening_Volume:SetShow(false)
  self.staticText_contributedTendency:SetSpanSize(535, 0)
  if true == isVoiceOpen then
    self.listening_VolumeClose:addInputEvent("Mouse_LUp", "HandleOnOut_GuildMemberList_VolumeClose()")
    self.listening_VolumeButton:addInputEvent("Mouse_LUp", "HandleClicked_VoiceChatListening()")
    self.listening_VolumeSlider:addInputEvent("Mouse_LUp", "HandleClicked_VoiceChatListeningVolume()")
    self.listening_VolumeSliderBtn:addInputEvent("Mouse_LPress", "HandleClicked_VoiceChatListeningVolume()")
    self.staticText_Voice:SetShow(true)
    self.staticText_Voice:addInputEvent("Mouse_On", "_guildListInfoPage_titleTooltipShow( true, " .. 4 .. " )")
    self.staticText_Voice:addInputEvent("Mouse_Out", "_guildListInfoPage_titleTooltipShow( false, " .. 4 .. " )")
    self.staticText_contributedTendency:SetSpanSize(495, 0)
  end
  self.staticText_WarGrade:SetShow(false)
  if isWarGradeOpen then
    self.staticText_WarGrade:SetShow(true)
    self.staticText_WarGrade:addInputEvent("Mouse_LUp", "HandleClicked_GuildListSort(" .. 7 .. ")")
    self.staticText_WarGrade:addInputEvent("Mouse_On", "_guildListInfoPage_titleTooltipShow(true, " .. 5 .. " )")
    self.staticText_WarGrade:addInputEvent("Mouse_Out", "_guildListInfoPage_titleTooltipShow(false, " .. 5 .. " )")
    if true == _ContentsGroup_NewSiegeRule then
      self.staticText_WarGrade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDLIST_WARPARTICIPANT_TITLE"))
    else
      self.staticText_WarGrade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDLIST_WARGRADETITLE"))
    end
  end
  text_contributedTendency = self.staticText_contributedTendency:GetText()
  self._frameGuildList = UI.getChildControl(Panel_Guild_List, "Frame_GuildList")
  self._contentGuildList = UI.getChildControl(self._frameGuildList, "Frame_1_Content")
  local _copyGrade = UI.getChildControl(self._contentGuildList, "StaticText_C_Grade")
  local _copyLevel = UI.getChildControl(self._contentGuildList, "StaticText_C_Level")
  local _copyClass = UI.getChildControl(self._contentGuildList, "StaticText_C_Class")
  local _copyCharName = UI.getChildControl(self._contentGuildList, "StaticText_C_CharName")
  local _copyContributedTendency = UI.getChildControl(self._contentGuildList, "StaticText_C_ContributedTendency")
  local _copySaying = UI.getChildControl(self._contentGuildList, "StaticText_C_Voice_Saying")
  local _copyListening = UI.getChildControl(self._contentGuildList, "StaticText_C_Voice_Listening")
  local _copyActivity = UI.getChildControl(self._contentGuildList, "StaticText_C_Activity")
  local _copyContractButton = UI.getChildControl(self._contentGuildList, "Button_C_Contract")
  local _copyGuardHim = UI.getChildControl(self._contentGuildList, "Static_C_GuardHim")
  local _copyWarGradeButton = UI.getChildControl(self._contentGuildList, "Button_WarGrade")
  local _copyWarStateButton = UI.getChildControl(self._contentGuildList, "Button_WarState")
  local _copyButton = UI.getChildControl(Panel_Guild_List, "Button_Function")
  GuildListInfoPage._textBusinessFundsBG = UI.getChildControl(Panel_Guild_List, "StaticText_GuildMoney")
  GuildListInfoPage._textBusinessFundsBG:addInputEvent("Mouse_On", "HandleOver_GuildFund_TooltipShow()")
  GuildListInfoPage._textBusinessFundsBG:addInputEvent("Mouse_Out", "HandleOver_GuildFund_TooltipHide()")
  GuildListInfoPage._btnGiveIncentive = UI.getChildControl(Panel_Guild_List, "Button_Incentive")
  GuildListInfoPage._btnDeposit = UI.getChildControl(Panel_Guild_List, "Button_Deposit")
  GuildListInfoPage._btnPaypal = UI.getChildControl(Panel_Guild_List, "Button_Paypal")
  GuildListInfoPage._btnSiegeReward = UI.getChildControl(Panel_Guild_List, "Button_SiegeReward")
  GuildListInfoPage._btnWelfare = UI.getChildControl(Panel_Guild_List, "Button_Welfare")
  GuildListInfoPage.decoIcon_Guild = UI.getChildControl(self._contentGuildList, "Static_DecoIcon_Guild")
  GuildListInfoPage.decoIcon_Clan = UI.getChildControl(self._contentGuildList, "Static_DecoIcon_Clan")
  if true == __Guild_LimitPrice then
    GuildListInfoPage._btnGiveIncentive:addInputEvent("Mouse_LUp", "PaGlobal_Guild_ChoiseTheMoney:Open()")
  else
    GuildListInfoPage._btnGiveIncentive:SetText(PAGetString(Defines.StringSheet_RESOURCE, "FRAME_GUILD_LIST_BTN_INCENTIVE"))
    GuildListInfoPage._btnGiveIncentive:addInputEvent("Mouse_LUp", "HandleCLicked_IncentiveOption()")
  end
  GuildListInfoPage._btnDeposit:addInputEvent("Mouse_LUp", "HandleCLicked_GuildListIncentive_Deposit()")
  GuildListInfoPage._btnPaypal:addInputEvent("Mouse_LUp", "HandleCLicked_GuildListIncentive_Paypal()")
  GuildListInfoPage._btnSiegeReward:addInputEvent("Mouse_LUp", "HandleCLicked_GuildList_TakeSiegeReward()")
  GuildListInfoPage._btnWelfare:addInputEvent("Mouse_LUp", "HandleClicked_GuildListWelfare_Request()")
  self._scrollBar = UI.getChildControl(self._frameGuildList, "VerticalScroll")
  UIScroll.InputEvent(self._scrollBar, "GuildListMouseScrollEvent")
  GuildListInfoPage._btnGiveIncentive:SetTextMode(UI_TM.eTextMode_LimitText)
  GuildListInfoPage._btnDeposit:SetTextMode(UI_TM.eTextMode_LimitText)
  GuildListInfoPage._btnPaypal:SetTextMode(UI_TM.eTextMode_LimitText)
  GuildListInfoPage._btnSiegeReward:SetTextMode(UI_TM.eTextMode_LimitText)
  GuildListInfoPage._btnWelfare:SetTextMode(UI_TM.eTextMode_LimitText)
  local isIncentiveLimit = GuildListInfoPage._btnGiveIncentive:IsLimitText()
  local isDepositLimit = GuildListInfoPage._btnDeposit:IsLimitText()
  local isPayPalLimit = GuildListInfoPage._btnPaypal:IsLimitText()
  local isWelfareLimit = GuildListInfoPage._btnWelfare:IsLimitText()
  local isSiegeRewardLimit = GuildListInfoPage._btnSiegeReward:IsLimitText()
  if isIncentiveLimit then
    GuildListInfoPage._btnGiveIncentive:addInputEvent("Mouse_On", "GuildList_Simpletooltips(true, 0)")
    GuildListInfoPage._btnGiveIncentive:addInputEvent("Mouse_On", "GuildList_Simpletooltips(false)")
  end
  if isDepositLimit then
    GuildListInfoPage._btnDeposit:addInputEvent("Mouse_On", "GuildList_Simpletooltips(true, 1)")
    GuildListInfoPage._btnDeposit:addInputEvent("Mouse_On", "GuildList_Simpletooltips(false)")
  end
  if isPayPalLimit then
    GuildListInfoPage._btnPaypal:addInputEvent("Mouse_On", "GuildList_Simpletooltips(true, 2)")
    GuildListInfoPage._btnPaypal:addInputEvent("Mouse_On", "GuildList_Simpletooltips(false)")
  end
  if isWelfareLimit then
    GuildListInfoPage._btnWelfare:addInputEvent("Mouse_On", "GuildList_Simpletooltips(true, 3)")
    GuildListInfoPage._btnWelfare:addInputEvent("Mouse_On", "GuildList_Simpletooltips(false)")
  end
  if isSiegeRewardLimit then
    GuildListInfoPage._btnSiegeReward:addInputEvent("Mouse_On", "GuildList_Simpletooltips(true, 4)")
    GuildListInfoPage._btnSiegeReward:addInputEvent("Mouse_On", "GuildList_Simpletooltips(false)")
  end
  self._contentGuildList:addInputEvent("Mouse_UpScroll", "GuildListMouseScrollEvent(true)")
  self._contentGuildList:addInputEvent("Mouse_DownScroll", "GuildListMouseScrollEvent(false)")
  function createListInfo(pIndex)
    local rtGuildListInfo = {}
    rtGuildListInfo._grade = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._contentGuildList, "StaticText_Grade_" .. pIndex)
    rtGuildListInfo._level = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._contentGuildList, "StaticText_Level_" .. pIndex)
    rtGuildListInfo._class = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._contentGuildList, "StaticText_Class_" .. pIndex)
    rtGuildListInfo._charName = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._contentGuildList, "StaticText_CharName_" .. pIndex)
    rtGuildListInfo._contributedTendency = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._contentGuildList, "StaticText_ContributedTendency_" .. pIndex)
    rtGuildListInfo._activity = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._contentGuildList, "StaticText_Activity_" .. pIndex)
    rtGuildListInfo._contractBtn = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, self._contentGuildList, "Button_C_Contract_" .. pIndex)
    rtGuildListInfo._guardHim = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self._contentGuildList, "Static_C_GuardHim_" .. pIndex)
    CopyBaseProperty(_copyGrade, rtGuildListInfo._grade)
    CopyBaseProperty(_copyLevel, rtGuildListInfo._level)
    CopyBaseProperty(_copyClass, rtGuildListInfo._class)
    CopyBaseProperty(_copyCharName, rtGuildListInfo._charName)
    CopyBaseProperty(_copyContributedTendency, rtGuildListInfo._contributedTendency)
    CopyBaseProperty(_copyActivity, rtGuildListInfo._activity)
    CopyBaseProperty(_copyContractButton, rtGuildListInfo._contractBtn)
    CopyBaseProperty(_copyGuardHim, rtGuildListInfo._guardHim)
    rtGuildListInfo._grade:SetPosY(_constStartY + pIndex * 30)
    rtGuildListInfo._level:SetPosY(_constStartY + pIndex * 30)
    rtGuildListInfo._class:SetPosY(_constStartY + pIndex * 30)
    rtGuildListInfo._charName:SetPosY(_constStartY + pIndex * 30)
    rtGuildListInfo._contributedTendency:SetPosY(_constStartY + pIndex * 30)
    rtGuildListInfo._activity:SetPosY(_constStartY + pIndex * 30)
    rtGuildListInfo._contractBtn:SetPosY(pIndex * 30 + 6)
    rtGuildListInfo._guardHim:SetPosY(pIndex * 30 + 8)
    rtGuildListInfo._guardHim:SetPosX(rtGuildListInfo._grade:GetTextSizeX() + 20)
    rtGuildListInfo._contributedTendency:SetPosX(520)
    rtGuildListInfo._grade:SetIgnore(false)
    rtGuildListInfo._level:SetIgnore(false)
    rtGuildListInfo._class:SetIgnore(false)
    rtGuildListInfo._charName:SetIgnore(false)
    rtGuildListInfo._contributedTendency:SetIgnore(false)
    rtGuildListInfo._activity:SetIgnore(false)
    rtGuildListInfo._charName:addInputEvent("Mouse_LUp", "HandleClickedGuildMemberMenuButton(" .. pIndex .. ")")
    rtGuildListInfo._charName:addInputEvent("Mouse_On", "HandleToolTipChannelName( true,\t" .. pIndex .. ")")
    rtGuildListInfo._charName:addInputEvent("Mouse_Out", "HandleToolTipChannelName( false,\t" .. pIndex .. ")")
    rtGuildListInfo._charName:addInputEvent("Mouse_LUp", "HandleToolTipChannelName( true, " .. pIndex .. " )")
    rtGuildListInfo._contractBtn:addInputEvent("Mouse_LUp", "HandleClickedGuildMemberContractButton(" .. pIndex .. ")")
    rtGuildListInfo._grade:addInputEvent("Mouse_UpScroll", "GuildListMouseScrollEvent(true)")
    rtGuildListInfo._level:addInputEvent("Mouse_UpScroll", "GuildListMouseScrollEvent(true)")
    rtGuildListInfo._class:addInputEvent("Mouse_UpScroll", "GuildListMouseScrollEvent(true)")
    rtGuildListInfo._charName:addInputEvent("Mouse_UpScroll", "GuildListMouseScrollEvent(true)")
    rtGuildListInfo._contributedTendency:addInputEvent("Mouse_UpScroll", "GuildListMouseScrollEvent(true)")
    rtGuildListInfo._activity:addInputEvent("Mouse_UpScroll", "GuildListMouseScrollEvent(true)")
    rtGuildListInfo._contractBtn:addInputEvent("Mouse_UpScroll", "GuildListMouseScrollEvent(true)")
    rtGuildListInfo._guardHim:addInputEvent("Mouse_UpScroll", "GuildListMouseScrollEvent(true)")
    rtGuildListInfo._grade:addInputEvent("Mouse_DownScroll", "GuildListMouseScrollEvent(false)")
    rtGuildListInfo._level:addInputEvent("Mouse_DownScroll", "GuildListMouseScrollEvent(false)")
    rtGuildListInfo._class:addInputEvent("Mouse_DownScroll", "GuildListMouseScrollEvent(false)")
    rtGuildListInfo._charName:addInputEvent("Mouse_DownScroll", "GuildListMouseScrollEvent(false)")
    rtGuildListInfo._contributedTendency:addInputEvent("Mouse_DownScroll", "GuildListMouseScrollEvent(false)")
    rtGuildListInfo._activity:addInputEvent("Mouse_DownScroll", "GuildListMouseScrollEvent(false)")
    rtGuildListInfo._contractBtn:addInputEvent("Mouse_DownScroll", "GuildListMouseScrollEvent(false)")
    rtGuildListInfo._guardHim:addInputEvent("Mouse_UpScroll", "GuildListMouseScrollEvent(false)")
    if true == isVoiceOpen then
      rtGuildListInfo._saying = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, self._contentGuildList, "StaticText_Saying_" .. pIndex)
      rtGuildListInfo._listening = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, self._contentGuildList, "StaticText_Listening_" .. pIndex)
      CopyBaseProperty(_copySaying, rtGuildListInfo._saying)
      CopyBaseProperty(_copyListening, rtGuildListInfo._listening)
      rtGuildListInfo._saying:SetPosY(_constStartY + pIndex * 30)
      rtGuildListInfo._listening:SetPosY(_constStartY + pIndex * 30)
      rtGuildListInfo._saying:SetIgnore(false)
      rtGuildListInfo._listening:SetIgnore(false)
      rtGuildListInfo._saying:SetAutoDisableTime(2)
      rtGuildListInfo._saying:DoAutoDisableTime()
      rtGuildListInfo._listening:SetAutoDisableTime(2)
      rtGuildListInfo._listening:DoAutoDisableTime()
      rtGuildListInfo._saying:addInputEvent("Mouse_DownScroll", "GuildListMouseScrollEvent(false)")
      rtGuildListInfo._listening:addInputEvent("Mouse_DownScroll", "GuildListMouseScrollEvent(false)")
      rtGuildListInfo._saying:addInputEvent("Mouse_UpScroll", "GuildListMouseScrollEvent(true)")
      rtGuildListInfo._listening:addInputEvent("Mouse_UpScroll", "GuildListMouseScrollEvent(true)")
      rtGuildListInfo._saying:addInputEvent("Mouse_LUp", "HandleClickedVoiceChatSaying(" .. pIndex .. ")")
      rtGuildListInfo._saying:addInputEvent("Mouse_On", "HandleToolTipVoiceIcon( true, " .. pIndex .. "," .. 0 .. ")")
      rtGuildListInfo._saying:addInputEvent("Mouse_Out", "HandleToolTipVoiceIcon( false, " .. pIndex .. "," .. 0 .. ")")
      rtGuildListInfo._listening:addInputEvent("Mouse_LUp", "HandleClick_GuildMemberList_Listening(" .. pIndex .. ")")
      rtGuildListInfo._listening:addInputEvent("Mouse_On", "HandleToolTipVoiceIcon( true, " .. pIndex .. "," .. 1 .. ")")
      rtGuildListInfo._listening:addInputEvent("Mouse_Out", "HandleToolTipVoiceIcon( false, " .. pIndex .. "," .. 1 .. ")")
    end
    if isWarGradeOpen then
      rtGuildListInfo._warGradeBtn = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, self._contentGuildList, "Button_C_WarGrade_" .. pIndex)
      CopyBaseProperty(_copyWarGradeButton, rtGuildListInfo._warGradeBtn)
      rtGuildListInfo._warGradeBtn:SetPosY(pIndex * 30 + 6)
      rtGuildListInfo._warGradeBtn:addInputEvent("Mouse_LUp", "HandleClickedWarGrade(" .. pIndex .. ")")
      rtGuildListInfo._warStateBtn = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, self._contentGuildList, "Button_C_WarState" .. pIndex)
      CopyBaseProperty(_copyWarStateButton, rtGuildListInfo._warStateBtn)
      rtGuildListInfo._warStateBtn:SetPosY(pIndex * 30 + 6)
    end
    function rtGuildListInfo:SetShow(isShow)
      rtGuildListInfo._grade:SetShow(isShow)
      rtGuildListInfo._level:SetShow(isShow)
      rtGuildListInfo._class:SetShow(isShow)
      rtGuildListInfo._charName:SetShow(isShow)
      rtGuildListInfo._contributedTendency:SetShow(isShow)
      if true == isVoiceOpen then
        rtGuildListInfo._saying:SetShow(isShow)
        rtGuildListInfo._listening:SetShow(isShow)
      end
      if true == isWarGradeOpen then
        rtGuildListInfo._warGradeBtn:SetShow(isShow)
        rtGuildListInfo._warStateBtn:SetShow(isShow)
      end
      rtGuildListInfo._activity:SetShow(isShow)
      rtGuildListInfo._contractBtn:SetShow(isShow)
      rtGuildListInfo._guardHim:SetShow(isShow)
    end
    function rtGuildListInfo:SetIgnore(isIgnore)
      rtGuildListInfo._grade:SetIgnore(isIgnore)
      rtGuildListInfo._level:SetIgnore(isIgnore)
      rtGuildListInfo._class:SetIgnore(isIgnore)
      rtGuildListInfo._charName:SetIgnore(isIgnore)
      rtGuildListInfo._contributedTendency:SetIgnore(isIgnore)
      if true == isVoiceOpen then
        rtGuildListInfo._saying:SetIgnore(isIgnore)
        rtGuildListInfo._listening:SetIgnore(isIgnore)
      end
      if true == isWarGradeOpen then
        rtGuildListInfo._warGradeBtn:SetIgnore(false)
        rtGuildListInfo._warStateBtn:SetIgnore(false)
      end
      rtGuildListInfo._activity:SetIgnore(isIgnore)
      rtGuildListInfo._guardHim:SetIgnore(isIgnore)
    end
    return rtGuildListInfo
  end
  function createListInfoButton(pIndex)
    local rtGuildListInfoButton = {}
    local rtGuildListInfoButton = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, self._buttonListBG, "Guild_Menu_Button_" .. pIndex)
    CopyBaseProperty(_copyButton, rtGuildListInfoButton)
    rtGuildListInfoButton:SetPosX(_constStartButtonX)
    rtGuildListInfoButton:SetShow(true)
    if isGameTypeTH() or isGameTypeID() then
      rtGuildListInfoButton:SetSize(185, 30)
    else
      rtGuildListInfoButton:SetSize(175, 30)
    end
    rtGuildListInfoButton:addInputEvent("Mouse_LUp", "HandleClickedGuildMenuButton(" .. pIndex .. ")")
    return rtGuildListInfoButton
  end
  self._buttonListBG:addInputEvent("Mouse_Out", "MouseOutGuildMenuButton()")
  for index = 0, _constGuildListMaxCount - 1 do
    self._list[index] = createListInfo(index)
  end
  for index = 0, _UI_Menu_Button.Type_Count - 1 do
    self._buttonList[index] = createListInfoButton(index)
    self._buttonList[index]:addInputEvent("Mouse_Out", "MouseOutGuildMenuButton()")
  end
  Panel_Guild_List:SetChildIndex(self.staticText_Grade, 9999)
  Panel_Guild_List:SetChildIndex(self.staticText_Level, 9999)
  Panel_Guild_List:SetChildIndex(self.staticText_Class, 9999)
  Panel_Guild_List:SetChildIndex(self.staticText_charName, 9999)
  Panel_Guild_List:SetChildIndex(self.staticText_activity, 9999)
  Panel_Guild_List:SetChildIndex(self.staticText_contract, 9999)
  GuildListInfoPage._buttonList[0]:SetText(PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_WHISPER"))
  GuildListInfoPage._buttonList[1]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_BUTTONLIST_TEXT_2"))
  GuildListInfoPage._buttonList[2]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_BUTTONLIST_TEXT_3"))
  GuildListInfoPage._buttonList[3]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_BUTTONLIST_TEXT_0"))
  GuildListInfoPage._buttonList[4]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_BUTTONLIST_TEXT_4"))
  GuildListInfoPage._buttonList[5]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_BUTTONLIST_TEXT_5"))
  GuildListInfoPage._buttonList[6]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_BUTTONLIST_TEXT_6"))
  GuildListInfoPage._buttonList[7]:SetText(PAGetString(Defines.StringSheet_GAME, "GULD_BUTTON7"))
  GuildListInfoPage._buttonList[8]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_BUTTONLIST_TEXT_1"))
  GuildListInfoPage._buttonList[_UI_Menu_Button.Type_PriceLimit]:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_USEGUILDFUNDS_TITLE"))
  UI.deleteControl(_copyGrade)
  UI.deleteControl(_copyLevel)
  UI.deleteControl(_copyClass)
  UI.deleteControl(_copyCharName)
  UI.deleteControl(_copyContributedTendency)
  UI.deleteControl(_copySaying)
  UI.deleteControl(_copyListening)
  UI.deleteControl(_copyActivity)
  UI.deleteControl(_copyContractButton)
  UI.deleteControl(_copyButton)
  UI.deleteControl(_copyGuardHim)
  UI.deleteControl(_copyWarGradeButton)
  UI.deleteControl(_copyWarStateButton)
  _copyGrade, _copyLevel, _copyClass, _copyCharName, _copyContributedTendency, _copySaying, _copyListening = nil, nil, nil, nil, nil, nil, nil
  _copyContractButton = nil
  _copyButton = nil
  _copyGuardHim, _copyWarGradeButton, _copyWarStateButton = nil, nil, nil
  frameSizeY = self._frameGuildList:GetSizeY()
  self._frameGuildList:UpdateContentScroll()
  self._frameGuildList:UpdateContentPos()
  self._frameDefaultBG:MoveChilds(self._frameDefaultBG:GetID(), Panel_Guild_List)
  UI.deletePanel(Panel_Guild_List:GetID())
  Panel_Guild_List = nil
end
function authorityCheck(memberType, gradeType, buttonType, isProtect, isOnline)
  local returnValue = false
  if 0 == memberType then
    if 0 == gradeType then
      returnValue = false
    elseif 1 == gradeType then
      if 0 == buttonType or 2 == buttonType or 3 == buttonType or 6 == buttonType or 7 == buttonType or 8 == buttonType then
        returnValue = true
      end
    elseif 2 == gradeType then
      if 0 == buttonType then
        returnValue = true
      elseif 1 == buttonType then
        if isProtect then
          returnValue = false
        else
          returnValue = true
        end
      elseif 4 == buttonType then
        if isProtect then
          returnValue = false
        else
          returnValue = true
        end
      elseif 5 == buttonType then
        if isProtect then
          returnValue = true
        else
          returnValue = false
        end
      elseif 6 == buttonType then
        returnValue = true
      elseif 7 == buttonType then
        if isProtect then
          returnValue = false
        else
          returnValue = true
        end
      elseif 8 == buttonType then
        returnValue = true
      end
    elseif __eGuildMemberGradeJunior == gradeType then
      if 0 == buttonType then
        returnValue = true
      elseif 4 == buttonType then
        if isProtect then
          returnValue = false
        else
          returnValue = true
        end
      elseif 5 == buttonType then
        if isProtect then
          returnValue = true
        else
          returnValue = false
        end
      elseif 6 == buttonType then
        returnValue = true
      elseif 8 == buttonType then
        returnValue = true
      end
      if ToClient_SelfPlayerIsGM() then
        if 0 == buttonType then
          returnValue = true
        elseif 1 == buttonType then
          if isProtect then
            returnValue = false
          else
            returnValue = true
          end
        elseif 4 == buttonType then
          if isProtect then
            returnValue = false
          else
            returnValue = true
          end
        elseif 5 == buttonType then
          if isProtect then
            returnValue = true
          else
            returnValue = false
          end
        elseif 6 == buttonType then
          returnValue = true
        elseif 7 == buttonType then
          if isProtect then
            returnValue = false
          else
            returnValue = true
          end
        elseif 8 == buttonType then
          returnValue = true
        end
      end
    elseif 3 == gradeType and (0 == buttonType or 1 == buttonType or 2 == buttonType or 6 == buttonType or 8 == buttonType) then
      returnValue = true
    end
    if _UI_Menu_Button.Type_PriceLimit == buttonType then
      returnValue = true
    end
  elseif 1 == memberType then
    if 0 == gradeType then
      if 6 == buttonType or 0 == buttonType then
        returnValue = true
      end
    elseif 1 == gradeType then
      if 0 == buttonType or 6 == buttonType then
        returnValue = true
      end
    elseif 2 == gradeType then
      if 0 == buttonType or 6 == buttonType or 8 == buttonType then
        returnValue = true
      end
    elseif 3 == gradeType then
      if 0 == buttonType or 6 == buttonType or 8 == buttonType then
        returnValue = true
      end
    elseif __eGuildMemberGradeJunior == gradeType and (0 == buttonType or 6 == buttonType or 8 == buttonType) then
      returnValue = true
    end
  elseif 2 == memberType and (0 == buttonType or 6 == buttonType) then
    returnValue = true
  end
  if false == isOnline and (0 == buttonType or 6 == buttonType or 3 == buttonType) then
    returnValue = false
  end
  return returnValue
end
function HandleClickedGuildMemberMenuButton(index)
  local self = GuildListInfoPage
  local dataIdx = tempGuildList[index + 1].idx
  local guildMember = ToClient_GetMyGuildInfoWrapper():getMember(dataIdx)
  local grade = guildMember:getGrade()
  local isProtect = guildMember:isProtectable()
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  local isSupplyOfficer = getSelfPlayer():get():isGuildSupplyOfficer()
  local buttonPosY = 5
  local savedMemberNum = 0
  local buttonListBgX = self._list[index]._charName:GetParentPosX() - Panel_Window_Guild:GetPosX()
  local buttonListBgY = self._list[index]._charName:GetParentPosY() - Panel_Window_Guild:GetPosY() - _constCollectionY
  GuildListInfoPage._buttonListBG:SetPosX(buttonListBgX)
  GuildListInfoPage._buttonListBG:SetPosY(buttonListBgY)
  for dataIdx = 0, _UI_Menu_Button.Type_Count - 1 do
    GuildListInfoPage._buttonList[dataIdx]:SetShow(false)
  end
  if isGuildMaster then
    savedMemberNum = 0
  elseif isGuildSubMaster then
    savedMemberNum = 1
  else
    savedMemberNum = 2
  end
  local isOnline = true == guildMember:isOnline() and false == guildMember:isGhostMode()
  GuildListInfoPage._buttonListBG:SetShow(false)
  for idx = 0, _UI_Menu_Button.Type_Count - 1 do
    if authorityCheck(savedMemberNum, grade, idx, isProtect, isOnline) then
      GuildListInfoPage._buttonListBG:SetShow(true)
      GuildListInfoPage._buttonList[idx]:SetShow(true)
      GuildListInfoPage._buttonList[idx]:SetPosY(buttonPosY)
      buttonPosY = buttonPosY + GuildListInfoPage._buttonList[idx]:GetSizeY() + 5
    end
  end
  if isGameTypeTH() or isGameTypeID() then
    GuildListInfoPage._buttonListBG:SetSize(195, buttonPosY)
  else
    GuildListInfoPage._buttonListBG:SetSize(185, buttonPosY)
  end
  _selectIndex = dataIdx
  self._clickedUserNo = guildMember:getUserNo()
end
function HandleClickedGuildMemberContractButton(index)
  local memberIndex = index
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local dataIdx = tempGuildList[index + 1].idx
  local myGuildMemberInfo = myGuildListInfo:getMember(dataIdx)
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  local usableActivity = myGuildMemberInfo:getUsableActivity()
  if true == isGuildMaster then
    FGlobal_AgreementGuild_Master_Open(dataIdx, 0, usableActivity)
  elseif true == isGuildSubMaster then
    FGlobal_AgreementGuild_Master_Open(dataIdx, 1, usableActivity)
  else
    FGlobal_AgreementGuild_Master_Open(dataIdx, 2, usableActivity)
  end
  local guildMemberGradeType = myGuildMemberInfo:getGrade()
  if __eGuildMemberGradeJunior == guildMemberGradeType then
    local juniorTime = myGuildMemberInfo:getJuniorUpgradeData()
    local juniorYear = juniorTime:GetYear()
    local juniorMonth = juniorTime:GetMonth()
    local juniorDay = juniorTime:GetDay()
    FGlobal_Add_Contract_juniorTimeText(juniorYear, juniorMonth, juniorDay)
  end
  HandleCLicked_AgreementGuildMaster()
end
function HandleCLicked_AgreementGuildMaster()
  local self = GuildListInfoPage
  if true == Panel_AgreementGuild_Master:GetShow() then
    self._btnPaypal:SetIgnore(true)
    self._btnPaypal:SetMonoTone(true)
  else
    self._btnPaypal:SetIgnore(false)
    self._btnPaypal:SetMonoTone(false)
  end
end
function HandleCLicked_IncentiveOption()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local pcPosition = player:get():getPosition()
  local regionInfo = getRegionInfoByPosition(pcPosition)
  local safeZoneCheck = regionInfo:get():isSafeZone()
  if safeZoneCheck then
    Panel_GuildIncentiveOption_ShowToggle()
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_INCENTIVE_ALERT"))
  end
end
function HandleCLicked_GuildListIncentive_Open()
  _incentivePanelType = 0
  incentive_InputMoney:SetEditText("", true)
  Panel_GuildIncentive:SetShow(true)
  txt_incentive_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_INCENTIVE_TITLE"))
  txt_incentive_Deposit:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_INCENTIVE_DEPOSIT"))
  txt_incentive_Notify:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_INCENTIVE_NOTIFY"))
end
function HandleCLicked_GuildListIncentive_Deposit()
  _incentivePanelType = 1
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local businessFunds_s64 = myGuildListInfo:getGuildBusinessFunds_s64()
  local unpaidTax_s64 = myGuildListInfo:getAccumulateTax()
  local unpaidCost_s64 = myGuildListInfo:getAccumulateGuildHouseCost()
  local maxInputValue_s64 = toInt64(0, 0)
  if unpaidTax_s64 > toInt64(0, 0) then
    maxInputValue_s64 = myGuildListInfo:getAccumulateTax() - myGuildListInfo:getGuildBusinessFunds_s64()
  elseif unpaidCost_s64 > toInt64(0, 0) then
    maxInputValue_s64 = myGuildListInfo:getAccumulateGuildHouseCost() - myGuildListInfo:getGuildBusinessFunds_s64()
  end
  inputGuildDepositMaxNum_s64 = maxInputValue_s64
  incentive_InputMoney:SetEditText(maxInputValue_s64, true)
  Panel_GuildIncentive:SetShow(true)
  txt_incentive_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_DEPOSIT_TITLE"))
  txt_incentive_Deposit:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_DEPOSIT_DEPOSIT"))
  txt_incentive_Notify:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDLIST_DEPOSIT_NOTIFY", "maxInput", makeDotMoney(maxInputValue_s64)))
end
function HandleCLicked_GuildListIncentive_Paypal()
  local hasWareHouse = ToClient_HasWareHouseFromNpc()
  if hasWareHouse then
    FGlobal_GetDailyPay_Show()
  else
    ToClient_TakeMyGuildBenefit(false)
  end
end
function HandleCLicked_GuildList_TakeSiegeReward()
  ToClient_resquestTakeSiegeMedalReward()
end
function checkVoiceChatMicTexture(idx, onOff)
  local sayControl = GuildListInfoPage._list[idx]._saying
  if onOff then
    local x1, y1, x2, y2 = setTextureUV_Func(sayControl, 105, 169, 133, 197)
    sayControl:getBaseTexture():setUV(x1, y1, x2, y2)
    sayControl:setRenderTexture(sayControl:getBaseTexture())
  else
    local x1, y1, x2, y2 = setTextureUV_Func(sayControl, 105, 198, 133, 226)
    sayControl:getBaseTexture():setUV(x1, y1, x2, y2)
    sayControl:setRenderTexture(sayControl:getBaseTexture())
  end
end
function checkVoiceChatListenTexture(idx, onOff)
  local listenControl = GuildListInfoPage._list[idx]._listening
  if onOff then
    local x1, y1, x2, y2 = setTextureUV_Func(listenControl, 134, 169, 162, 197)
    listenControl:getBaseTexture():setUV(x1, y1, x2, y2)
    listenControl:setRenderTexture(listenControl:getBaseTexture())
  else
    local x1, y1, x2, y2 = setTextureUV_Func(listenControl, 134, 198, 162, 226)
    listenControl:getBaseTexture():setUV(x1, y1, x2, y2)
    listenControl:setRenderTexture(listenControl:getBaseTexture())
  end
end
function checkVoiceChatListenOtherTexture(onOff)
  local self = GuildListInfoPage
  self.listening_VolumeButton:ChangeTextureInfoName("renewal/ui_icon/console_icon_01.dds")
  if onOff then
    local x1, y1, x2, y2 = setTextureUV_Func(self.listening_VolumeButton, 134, 169, 162, 197)
    self.listening_VolumeButton:getBaseTexture():setUV(x1, y1, x2, y2)
    self.listening_VolumeButton:setRenderTexture(self.listening_VolumeButton:getBaseTexture())
  else
    local x1, y1, x2, y2 = setTextureUV_Func(self.listening_VolumeButton, 134, 198, 162, 226)
    self.listening_VolumeButton:getBaseTexture():setUV(x1, y1, x2, y2)
    self.listening_VolumeButton:setRenderTexture(self.listening_VolumeButton:getBaseTexture())
  end
end
function checkIsBlockedPlayer(selectIndex)
  return ToClient_IsGuildMemberBlocked(selectIndex)
end
function HandleClickedVoiceChatSaying(index)
  local self = GuildListInfoPage
  local memberIndex = index
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local dataIdx = tempGuildList[index + 1].idx
  local myGuildMemberInfo = myGuildListInfo:getMember(dataIdx)
  if true == isVoiceOpen then
    self._list[index]._saying:SetAutoDisableTime(2)
    self._list[index]._saying:DoAutoDisableTime()
    self._list[index]._listening:SetAutoDisableTime(2)
    self._list[index]._listening:DoAutoDisableTime()
  end
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  local usableActivity = myGuildMemberInfo:getUsableActivity()
  local isSaying = myGuildMemberInfo:isVoiceChatSpeak()
  local isListening = myGuildMemberInfo:isVoiceChatListen()
  if true == myGuildMemberInfo:isSelf() then
    if isSaying then
      isSaying = false
      ToClient_StopVoiceChat()
    else
      isSaying = true
      ToClient_StartVoiceChat()
    end
    if false == ToClient_IsConnectedMic() then
      local x1, y1, x2, y2 = setTextureUV_Func(self._list[index]._saying, 105, 198, 133, 226)
      self._list[index]._saying:getBaseTexture():setUV(x1, y1, x2, y2)
      self._list[index]._saying:setRenderTexture(self._list[index]._saying:getBaseTexture())
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_Guild_List_NotConnectedMic"))
      return
    end
    checkVoiceChatMicTexture(index, isSaying)
    ToClient_VoiceChatChangeState(CppEnums.VoiceChatType.eVoiceChatType_Guild, myGuildMemberInfo:getUserNo(), isSaying, isListening, false)
  else
    local isGuildMaster = getSelfPlayer():get():isGuildMaster()
    local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
    if true == isGuildMaster or true == isGuildSubMaster then
      local function handle_SendForceState()
        checkVoiceChatMicTexture(index, false)
        ToClient_VoiceChatChangeState(CppEnums.VoiceChatType.eVoiceChatType_Guild, tempGuildList[index + 1].userNo, false, isListening, true)
      end
      if false == isSaying then
        return
      end
      local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "Lua_Guild_List_VoiceChatControl_ForceSpeakOff", "GuildMember", myGuildMemberInfo:getName())
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
        content = messageBoxMemo,
        functionYes = handle_SendForceState,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
      return
    end
  end
end
function HandleClicked_VoiceChatListening()
  local self = GuildListInfoPage
  local memberIndex = setVol_selectedMemberIdx
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local dataIdx = tempGuildList[setVol_selectedMemberIdx + 1].idx
  local myGuildMemberInfo = myGuildListInfo:getMember(dataIdx)
  local isSaying = myGuildMemberInfo:isVoiceChatSpeak()
  local isListening = myGuildMemberInfo:isVoiceChatListen()
  isListening = not isListening
  checkVoiceChatListenTexture(memberIndex, isListening)
  checkVoiceChatListenOtherTexture(isListening)
  if not isListening then
    self.listening_VolumeSlider:SetControlPos(0)
    ToClient_setSpeakerVolume(0)
  else
    self.listening_VolumeSlider:SetControlPos(100)
    ToClient_setSpeakerVolume(100)
  end
  listeningVol = math.ceil(self.listening_VolumeSlider:GetControlPos() * 100)
  self.listening_VolumeValue:SetText(listeningVol .. "%")
  ToClient_VoiceChatChangeState(CppEnums.VoiceChatType.eVoiceChatType_Guild, myGuildMemberInfo:getUserNo(), isSaying, isListening, not isSelf)
  if false == _ContentsGroup_RemasterUI_Main_RightTop then
    FGlobal_VoiceChatState()
  else
    PaGlobalFunc_Widget_FunctionButton_HandleUpdate(Widget_Function_Type.SetVoice)
  end
end
local prevVoiceChatListen = false
function HandleClicked_VoiceChatListeningVolume()
  local self = GuildListInfoPage
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  local dataIdx = tempGuildList[setVol_selectedMemberIdx + 1].idx
  local myGuildMemberInfo = myGuildListInfo:getMember(dataIdx)
  local isSaying = myGuildMemberInfo:isVoiceChatSpeak()
  local isListening = myGuildMemberInfo:isVoiceChatListen()
  prevVoiceChatListen = isListening
  local volume = math.ceil(self.listening_VolumeSlider:GetControlPos() * 100)
  self.listening_VolumeValue:SetText(volume .. "%")
  if volume > 0 then
    isListening = true
    checkVoiceChatListenOtherTexture(true)
    checkVoiceChatListenTexture(setVol_selectedMemberIdx, true)
  else
    isListening = false
    checkVoiceChatListenOtherTexture(false)
    checkVoiceChatListenTexture(setVol_selectedMemberIdx, false)
  end
  if myGuildMemberInfo:isSelf() then
    ToClient_setSpeakerVolume(volume)
    if prevVoiceChatListen ~= isListening then
      ToClient_VoiceChatChangeState(CppEnums.VoiceChatType.eVoiceChatType_Guild, myGuildMemberInfo:getUserNo(), isSaying, isListening, false)
    end
    if false == _ContentsGroup_RemasterUI_Main_RightTop then
      FGlobal_VoiceChatState()
    else
      PaGlobalFunc_Widget_FunctionButton_HandleUpdate(Widget_Function_Type.SetVoice)
    end
  else
    ToClient_VoiceChatChangeVolume(CppEnums.VoiceChatType.eVoiceChatType_Guild, myGuildMemberInfo:getUserNo(), volume)
  end
end
function HandleClickedGuildMenuButton(index)
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local myGuildMemberInfo = myGuildListInfo:getMember(_selectIndex)
  if nil == myGuildMemberInfo then
    return
  end
  local messageTitle = ""
  local messageContent = ""
  local yesFunction
  local targetName = myGuildMemberInfo:getName()
  local characterName = myGuildMemberInfo:getCharacterName()
  local isOnlineMember = myGuildMemberInfo:isOnline()
  if index == _UI_Menu_Button.Type_ChangeMaster then
    messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_DELEGATE_MASTER")
    messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_DELEGATE_MASTER_QUESTION", "target", "'" .. tostring(targetName) .. "'")
    yesFunction = MessageBoxYesFunction_ChangeGuildMaster
    local messageboxData = {
      title = messageTitle,
      content = messageContent,
      functionYes = yesFunction,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "top")
    return
  elseif index == _UI_Menu_Button.Type_Deportation then
    messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_EXPEL_GUILDMEMBER")
    messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_EXPEL_GUILDMEMBER_QUESTION", "target", "[" .. tostring(targetName) .. "]")
    yesFunction = MessageBoxYesFunction_ExpelMember
  elseif index == _UI_Menu_Button.Type_AppointCommander then
    messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_APPOINT_GUILDSUBMASTER")
    messageContent = "'" .. tostring(targetName) .. "'" .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_APPOINT_GUILDSUBMASTER_QUESTION")
    yesFunction = MessageBoxYesFunction_AppointCommander
  elseif index == _UI_Menu_Button.Type_CancelAppoint then
    messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_APPOINT_GUILDMEMBER")
    messageContent = "'" .. tostring(targetName) .. "'" .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_APPOINT_GUILDMEMBER_QUESTION")
    yesFunction = MessageBoxYesFunction_CancelAppoint
  elseif index == _UI_Menu_Button.Type_ProtectMember then
    local protectRate = 10
    local currentProtectMemberCount = myGuildListInfo:getProtectGuildMemberCount()
    local maxProtectMemberCount = math.floor(myGuildListInfo:getMemberCount() / protectRate + 0.5) - 1
    messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_PROTECT_GUILDMEMBER")
    messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_PROTECT_GUILDMEMBER_DESC")
    yesFunction = MessageBoxYesFunction_ProtectMember
    GuildListInfoPage._buttonListBG:SetShow(false)
    local messageboxData = {
      title = messageTitle,
      content = messageContent,
      functionYes = yesFunction,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "top")
    return
  elseif index == _UI_Menu_Button.Type_CancelProtectMember then
    messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CANCEL_PROTECT_GUILDMEMBER")
    messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CANCEL_PROTECT_GUILDMEMBER_DESC")
    yesFunction = MessageBoxYesFunction_CancelProtectMember
  elseif index == _UI_Menu_Button.Type_PartyInvite then
    if false == checkIsBlockedPlayer(_selectIndex) then
      local function guildMemberPartyInvite()
        RequestParty_inviteCharacter(characterName)
      end
      messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
      GuildListInfoPage._buttonListBG:SetShow(false)
      if isOnlineMember then
        messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDLIST_GUILDMEMBERPARTYINVITE_MSG", "targetName", characterName)
        local messageboxData = {
          title = messageTitle,
          content = messageContent,
          functionYes = guildMemberPartyInvite,
          functionNo = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData, "middle")
        return
      else
        messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_PARTYINVITE_NOTJOINMEMBER")
        local messageboxData = {
          title = messageTitle,
          content = messageContent,
          functionYes = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData, "middle")
        return
      end
    else
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE")
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
        content = messageBoxMemo,
        functionYes = MessageBox_Empty_function,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    end
  elseif index == _UI_Menu_Button.Type_Supply then
    messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SUPPLYOFFICER_APPOINTMENT_TITLE")
    messageContent = "'" .. tostring(targetName) .. "'" .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SUPPLYOFFICER_APPOINTMENT_MEMO")
    yesFunction = MessageBoxYesFunction_AppointSupply
  elseif index == _UI_Menu_Button.Type_Whisper then
    PaGlobal_ChattingInput_SendWhisper(characterName, targetName)
    return
  elseif _UI_Menu_Button.Type_PriceLimit == index then
    PaGlobal_Guild_UseGuildFunds:ShowToggle(_selectIndex, true)
    return
  else
    UI.ASSERT(false, "\236\158\145\236\151\133\237\149\180\236\149\188\237\149\169\235\139\136\235\139\164!")
    return
  end
  GuildListInfoPage._buttonListBG:SetShow(false)
  local messageboxData = {
    title = messageTitle,
    content = messageContent,
    functionYes = yesFunction,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function HandleToolTipCharacterName(isShow, index, uiIndex)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local dataIndex = tempGuildList[uiIndex + 1].idx
  local myGuildMemberInfo = myGuildListInfo:getMember(dataIndex)
  local isOnline = myGuildMemberInfo:isOnline()
  local uiControl = GuildListInfoPage._list[uiIndex]._charName
  local name = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDLIST_FAMILYNAME", "name", myGuildMemberInfo:getName())
  local desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDLIST_CHARACTERNAME", "name", myGuildMemberInfo:getCharacterName())
  if isOnline then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function HandleToolTipChannelName(isShow, index)
  local self = GuildListInfoPage
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local dataIndex = tempGuildList[index + 1].idx
  local myGuildMemberInfo = myGuildListInfo:getMember(dataIndex)
  local guildMemberName = myGuildMemberInfo:getCharacterName()
  local isOnline = myGuildMemberInfo:isOnline() and false == myGuildMemberInfo:isGhostMode()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local channelName = getChannelName(worldNo, myGuildMemberInfo:getServerNo())
  if isOnline then
    name = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDLIST_JOINCHANNEL_FOR", "guildMemberName", guildMemberName)
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_CHANNEL_MEMBER", "channelName", channelName)
    control = self._list[index]._charName
    if isShow == true then
      TooltipSimple_Show(control, name, desc)
    else
      TooltipSimple_Hide()
    end
  end
end
function HandleToolTipVoiceIcon(isShow, index, tipType)
  local self = GuildListInfoPage
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_VOICECHATICON_TOOLTIP_VOICE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_VOICECHATICON_TOOLTIP_VOICE_DESC")
    control = self._list[index]._saying
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_VOICECHATICON_TOOLTIP_SPEAKER_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_VOICECHATICON_TOOLTIP_SPEAKER_DESC")
    control = self._list[index]._listening
  end
  if isShow == true then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function HandleClick_GuildMemberList_Listening(index)
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local self = GuildListInfoPage
  local dataIdx = tempGuildList[index + 1].idx
  local myGuildMemberInfo = myGuildListInfo:getMember(dataIdx)
  if nil == myGuildMemberInfo then
    return
  end
  self.listening_Volume:SetShow(true)
  if myGuildMemberInfo:isSelf() then
    setVol_selectedMemberVol = ToClient_getSpeakerVolume()
  else
    setVol_selectedMemberVol = myGuildMemberInfo:getVoiceVolume()
  end
  self.listening_VolumeSlider:SetControlPos(setVol_selectedMemberVol)
  if setVol_selectedMemberVol > 0 then
    checkVoiceChatListenOtherTexture(true)
  else
    checkVoiceChatListenOtherTexture(false)
  end
  self.listening_VolumeValue:SetText(setVol_selectedMemberVol .. "%")
  setVol_selectedMemberIdx = index
  local targetControl = GuildListInfoPage._list[index]._listening
  self.listening_Volume:SetPosX(targetControl:GetPosX() - self.listening_Volume:GetSizeX() / 2)
  self.listening_Volume:SetPosY(targetControl:GetPosY() + targetControl:GetSizeY() * 2 + 45)
end
function HandleOnOut_GuildMemberList_VolumeClose()
  local self = GuildListInfoPage
  self.listening_Volume:SetShow(false)
  setVol_selectedMemberIdx = 0
end
function HandleClickedWarGrade(index)
  local function changeSiegeGrade(count_s64)
    local dataIdx = tempGuildList[index + 1].idx
    ToClient_RequestChangeSiegeCombatantbyIndex(dataIdx, 6 - Int64toInt32(count_s64))
  end
  Panel_NumberPad_Show(true, toInt64(0, 5), nil, changeSiegeGrade)
end
function MessageBoxYesFunction_ChangeGuildMaster()
  ToClient_RequestChangeGuildMemberGradeForMaster(_selectIndex)
  FGlobal_Notice_AuthorizationUpdate()
end
function MessageBoxYesFunction_ExpelMember()
  ToClient_RequestExpelMemberFromGuild(_selectIndex, GuildListInfoPage._clickedUserNo)
end
function MessageBoxYesFunction_AppointCommander()
  ToClient_RequestChangeGuildMemberGrade(_selectIndex, 1)
  FGlobal_Notice_AuthorizationUpdate()
end
function MessageBoxYesFunction_CancelAppoint()
  ToClient_RequestChangeGuildMemberGrade(_selectIndex, 2)
  FGlobal_Notice_AuthorizationUpdate()
end
function MessageBoxYesFunction_AppointSupply()
  ToClient_RequestChangeGuildMemberGrade(_selectIndex, 3)
  FGlobal_Notice_AuthorizationUpdate()
end
function MessageBoxYesFunction_ProtectMember()
  ToClient_RequestChangeProtectMember(_selectIndex, true)
end
function MessageBoxYesFunction_CancelProtectMember()
  ToClient_RequestChangeProtectMember(_selectIndex, false)
end
function MouseOutGuildMenuButton()
  local self = GuildListInfoPage
  local sizeX = self._buttonListBG:GetSizeX()
  local sizeY = self._buttonListBG:GetSizeY()
  local posX = self._buttonListBG:GetPosX()
  local posY = self._buttonListBG:GetPosY()
  local xxxx = Panel_Window_Guild:GetPosX() + posX + 42
  local yyyy = Panel_Window_Guild:GetPosY() + posY + 95
  local mousePosX = getMousePosX() - Panel_Window_Guild:GetPosX() - _constCollectionX
  local mousePosY = getMousePosY() - Panel_Window_Guild:GetPosY() - _constCollectionY
  if xxxx <= getMousePosX() and getMousePosX() <= xxxx + sizeX and yyyy <= getMousePosY() and getMousePosY() <= yyyy + sizeY then
  else
    self._buttonListBG:SetShow(false)
  end
end
function GuildListMouseScrollEvent(isUpScroll)
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  local memberCount = guildWrapper:getMemberCount()
  UIScroll.ScrollEvent(GuildListInfoPage._scrollBar, isUpScroll, memberCount, memberCount, 0, 1)
  GuildListInfoPage:UpdateData()
end
function GuildListInfoPage:TitleLineReset()
  self.staticText_Grade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_POSITION"))
  self.staticText_Level:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_LEVEL"))
  self.staticText_Class:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CLASS"))
  self.staticText_charName:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CHARNAME"))
  self.staticText_activity:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_ACTIVITY"))
  self.staticText_contract:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_HIRE"))
  self.staticText_contributedTendency:SetText(text_contributedTendency)
end
function GuildListInfoPage:SetGuildList()
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local memberCount = myGuildListInfo:getMemberCount()
  tempGuildList = {}
  for index = 1, memberCount do
    local myGuildMemberInfo = myGuildListInfo:getMember(index - 1)
    if nil == myGuildMemberInfo then
      return
    end
    local prevLevel = myGuildMemberInfo:getLevel()
    local prevWp = myGuildMemberInfo:getMaxWp()
    local prevClass = myGuildMemberInfo:getClassType()
    if false == myGuildMemberInfo:isOnline() or true == myGuildMemberInfo:isGhostMode() then
      prevLevel = 0
      prevWp = 0
      prevClass = UI_Class.ClassType_Count
    end
    tempGuildList[index] = {
      idx = index - 1,
      online = myGuildMemberInfo:isOnline(),
      grade = myGuildMemberInfo:getGrade(),
      level = prevLevel,
      class = prevClass,
      name = myGuildMemberInfo:getName(),
      ap = Int64toInt32(myGuildMemberInfo:getTotalActivity()),
      expiration = myGuildMemberInfo:getContractedExpirationUtc(),
      wp = prevWp,
      kp = myGuildMemberInfo:getExplorationPoint(),
      userNo = myGuildMemberInfo:getUserNo(),
      siegegrade = myGuildMemberInfo:getSiegeCombatantGrade(),
      siegeParticipant = myGuildMemberInfo:isSiegeParticipant()
    }
  end
end
local function guildListCompareGrade(w1, w2)
  local w1Grade = w1.grade
  local w2Grade = w2.grade
  if 2 == w1Grade then
    w1Grade = 3
  elseif 3 == w1Grade then
    w1Grade = 2
  end
  if 2 == w2Grade then
    w2Grade = 3
  elseif 3 == w2Grade then
    w2Grade = 2
  end
  if true == _listSort.grade then
    return w1Grade < w2Grade
  else
    return w1Grade > w2Grade
  end
end
local function guildListCompareLev(w1, w2)
  if true == _listSort.level then
    if w2.level < w1.level then
      return true
    end
  elseif w1.level < w2.level then
    return true
  end
end
local function guildListCompareClass(w1, w2)
  if true == _listSort.class then
    if w2.class < w1.class then
      return true
    end
  elseif w1.class < w2.class then
    return true
  end
end
local function guildListCompareName(w1, w2)
  if true == _listSort.name then
    if w1.name < w2.name then
      return true
    end
  elseif w2.name < w1.name then
    return true
  end
end
local function guildListCompareAp(w1, w2)
  if true == _listSort.ap then
    if w2.ap < w1.ap then
      return true
    end
  elseif w1.ap < w2.ap then
    return true
  end
end
local function guildListCompareExpiration(w1, w2)
  if true == _listSort.expiration then
    if w2.expiration < w1.expiration then
      return true
    end
  elseif w1.expiration < w2.expiration then
    return true
  end
end
local function guildListCompareWp(w1, w2)
  if true == _listSort.wp then
    if w2.wp < w1.wp then
      return true
    end
  elseif false == _listSort.wp and true == _listSort.kp then
    if w2.kp < w1.kp then
      return true
    end
  elseif w1.wp < w2.wp then
    return true
  end
end
local function guildListSiegeGrade(w1, w2)
  if true == _ContentsGroup_NewSiegeRule then
    if true == _listSort.siegegrade then
      if true == w2.siegeParticipant and false == w1.siegeParticipant then
        return true
      elseif false == w2.siegeParticipant and true == w1.siegeParticipant then
        return false
      else
        return guildListCompareGrade(w1, w2)
      end
    elseif true == w1.siegeParticipant and false == w2.siegeParticipant then
      return true
    elseif false == w1.siegeParticipant and true == w2.siegeParticipant then
      return false
    else
      return guildListCompareGrade(w1, w2)
    end
  elseif true == _listSort.siegegrade then
    if w2.siegegrade < w1.siegegrade then
      return true
    end
  elseif w1.siegegrade < w2.siegegrade then
    return true
  end
end
function HandleClicked_GuildListSort(sortType)
  _selectSortType = sortType
  GuildListInfoPage:TitleLineReset()
  local self = GuildListInfoPage
  if 0 == sortType then
    if false == _listSort.grade then
      self.staticText_Grade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_POSITION") .. "\226\150\178")
      _listSort.grade = true
    else
      self.staticText_Grade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_POSITION") .. "\226\150\188")
      _listSort.grade = false
    end
    table.sort(tempGuildList, guildListCompareGrade)
  elseif 1 == sortType then
    if false == _listSort.level then
      self.staticText_Level:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_LEVEL") .. "\226\150\178")
      _listSort.level = true
    else
      self.staticText_Level:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_LEVEL") .. "\226\150\188")
      _listSort.level = false
    end
    table.sort(tempGuildList, guildListCompareLev)
  elseif 2 == sortType then
    if false == _listSort.class then
      self.staticText_Class:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CLASS") .. "\226\150\178")
      _listSort.class = true
    else
      self.staticText_Class:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CLASS") .. "\226\150\188")
      _listSort.class = false
    end
    table.sort(tempGuildList, guildListCompareClass)
  elseif 3 == sortType then
    if false == _listSort.name then
      self.staticText_charName:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CHARNAME") .. "\226\150\178")
      _listSort.name = true
    else
      self.staticText_charName:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_CHARNAME") .. "\226\150\188")
      _listSort.name = false
    end
    table.sort(tempGuildList, guildListCompareName)
  elseif 4 == sortType then
    if false == _listSort.ap then
      self.staticText_activity:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_ACTIVITY") .. "\226\150\178")
      _listSort.ap = true
    else
      self.staticText_activity:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_ACTIVITY") .. "\226\150\188")
      _listSort.ap = false
    end
    table.sort(tempGuildList, guildListCompareAp)
  elseif 5 == sortType then
    if false == _listSort.expiration then
      self.staticText_contract:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_HIRE") .. "\226\150\178")
      _listSort.expiration = true
    else
      self.staticText_contract:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_HIRE") .. "\226\150\188")
      _listSort.expiration = false
    end
    table.sort(tempGuildList, guildListCompareExpiration)
  elseif 6 == sortType then
    if false == _listSort.wp then
      self.staticText_contributedTendency:SetText(text_contributedTendency .. "\226\150\178")
      _listSort.wp = true
    elseif false == _listSort.kp then
      self.staticText_contributedTendency:SetText(text_contributedTendency .. "\226\150\178")
      _listSort.kp = true
    else
      self.staticText_contributedTendency:SetText(text_contributedTendency .. "\226\150\188")
      _listSort.wp = false
      _listSort.kp = false
    end
    table.sort(tempGuildList, guildListCompareWp)
  elseif 7 == sortType then
    if true == _ContentsGroup_NewSiegeRule then
      if false == _listSort.siegegrade then
        self.staticText_WarGrade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDLIST_WARPARTICIPANT_TITLE") .. "\226\150\178")
        _listSort.siegegrade = true
      else
        self.staticText_WarGrade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDLIST_WARPARTICIPANT_TITLE") .. "\226\150\188")
        _listSort.siegegrade = false
      end
    elseif false == _listSort.siegegrade then
      self.staticText_WarGrade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDLIST_WARGRADETITLE") .. "\226\150\178")
      _listSort.siegegrade = true
    else
      self.staticText_WarGrade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDLIST_WARGRADETITLE") .. "\226\150\188")
      _listSort.siegegrade = false
    end
    table.sort(tempGuildList, guildListSiegeGrade)
  end
  GuildListInfoPage:UpdateData()
end
function GuildListInfoPage:GuildListSortSet()
  GuildListInfoPage:TitleLineReset()
  self.staticText_Grade:SetText(PAGetString(Defines.StringSheet_RESOURCE, "GUILD_TEXT_POSITION") .. "\226\150\178")
  _listSort.grade = true
  table.sort(tempGuildList, guildListCompareGrade)
end
function GuildListInfoPage:updateSort()
  if 0 == _selectSortType then
    table.sort(tempGuildList, guildListCompareGrade)
  elseif 1 == _selectSortType then
    table.sort(tempGuildList, guildListCompareLev)
  elseif 2 == _selectSortType then
    table.sort(tempGuildList, guildListCompareClass)
  elseif 3 == _selectSortType then
    table.sort(tempGuildList, guildListCompareName)
  elseif 4 == _selectSortType then
    table.sort(tempGuildList, guildListCompareAp)
  elseif 5 == _selectSortType then
    table.sort(tempGuildList, guildListCompareExpiration)
  elseif 6 == _selectSortType then
    table.sort(tempGuildList, guildListCompareWp)
  elseif 7 == _selectSortType then
    table.sort(tempGuildList, guildListSiegeGrade)
  end
end
function GuildListInfoPage:UpdateData()
  GuildListInfoPage:SetGuildList()
  GuildListInfoPage:updateSort()
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local businessFunds_s64 = myGuildListInfo:getGuildBusinessFunds_s64()
  local guildGrade = myGuildListInfo:getGuildGrade()
  GuildListInfoPage._textBusinessFundsBG:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_GUILDMONEY", "getGuildMoney", makeDotMoney(businessFunds_s64)))
  local memberCount = myGuildListInfo:getMemberCount()
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  self._onlineCount = 0
  contentSizeY = 0
  for index = 0, _constGuildListMaxCount - 1 do
    self._list[index]:SetShow(false)
  end
  tempGuildUserNolist = {}
  siegeGradeCount.grade1 = 0
  siegeGradeCount.grade2 = 0
  siegeGradeCount.grade3 = 0
  siegeGradeCount.grade4 = 0
  siegeGradeCount.grade5 = 0
  for index = 0, memberCount - 1 do
    local dataIdx = tempGuildList[index + 1].idx
    local myGuildMemberInfo = myGuildListInfo:getMember(dataIdx)
    if nil == myGuildMemberInfo then
      _PA_ASSERT(false, "\235\169\164\235\178\132 \235\141\176\236\157\180\237\132\176\234\176\128 \236\151\134\236\157\132 \236\136\152 \236\158\136\235\130\152? \237\153\149\236\157\184 \235\176\148\235\158\141\235\139\136\235\139\164.")
      return
    end
    local userNo = myGuildMemberInfo:getUserNo()
    local myUserNo = getSelfPlayer():get():getUserNo()
    tempGuildUserNolist[index] = userNo
    self:UpdateDataDetail(myGuildMemberInfo, index, dataIdx)
    if true == myGuildMemberInfo:isSelf() or userNo == myUserNo then
      local isTakableSiegeReward = myGuildMemberInfo:isTakableSiegeReward()
      GuildListInfoPage._btnSiegeReward:SetMonoTone(not isTakableSiegeReward)
      GuildListInfoPage._btnSiegeReward:SetEnable(isTakableSiegeReward)
      btn_GuildMasterMandate:addInputEvent("Mouse_LUp", "HandleClicked_GuildMasterMandate( " .. index .. " )")
      _myindex = index
      FGlobal_GetDailyPay_PayInfo(_myindex)
    end
    if false == myGuildMemberInfo:isSelf() then
      contentSizeY = contentSizeY + self._list[index]._charName:GetSizeY() + 2
    end
  end
  self._contentGuildList:SetSize(self._frameGuildList:GetSizeX(), contentSizeY)
  if contentSizeY <= frameSizeY then
    self._scrollBar:SetShow(false)
  else
    self._scrollBar:SetShow(true)
  end
  if not notice_title:GetShow() then
    GuildMainInfo_Hide()
  end
  self._frameGuildList:UpdateContentScroll()
  self._frameGuildList:UpdateContentPos()
  self._scrollBar:SetInterval(self._contentGuildList:GetSizeY() / 100 * 1.1)
  if (true == isGuildMaster or true == isGuildSubMaster) and 1 == guildGrade then
    self._btnWelfare:SetShow(true)
  else
    self._btnWelfare:SetShow(false)
  end
  self:checkSelfVolunteer()
  PaGlobalFunc_AllianceList_Update()
end
function FGlobal_GetDailyPay_PayInfo()
  return _myindex
end
function FGlobal_GetDailyPay_RealIndexInfo()
  return tempGuildList[_myindex + 1].idx
end
function GuildListInfoPage:setGradeInfo(control, index, grade, isVacation)
  if nil == control then
    return
  end
  control:SetText("")
  control:SetSize(43, 26)
  control:SetSpanSize(0, 0)
  control:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_ETC_Guild.dds")
  if __eGuildMemberGradeMaster == grade then
    local x1, y1, x2, y2 = setTextureUV_Func(control, 224, 227, 267, 253)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif __eGuildMemberGradeSubMaster == grade then
    local x1, y1, x2, y2 = setTextureUV_Func(control, 224, 200, 267, 226)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif __eGuildMemberGradeNormal == grade then
    local x1, y1, x2, y2 = setTextureUV_Func(control, 224, 146, 267, 172)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif __eGuildMemberGradeSupplyOfficer == grade then
    local x1, y1, x2, y2 = setTextureUV_Func(control, 224, 173, 267, 199)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif __eGuildMemberGradeJunior == grade then
    control:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_ETC_Guild01.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 1, 44, 27)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:SetSpanSize(-1, 0)
  end
  control:setRenderTexture(control:getBaseTexture())
  if true == isVacation then
    control:SetMonoTone(true)
    control:addInputEvent("Mouse_On", "GuildListInfoTooltip_Vacation( true, " .. index .. " )")
    control:addInputEvent("Mouse_Out", "GuildListInfoTooltip_Vacation( false, " .. index .. " )")
  else
    control:SetMonoTone(false)
    control:addInputEvent("Mouse_On", "GuildListInfoTooltip_Grade( true, " .. index .. ", " .. grade .. " )")
    control:addInputEvent("Mouse_Out", "GuildListInfoTooltip_Grade( false, " .. index .. ", " .. grade .. " )")
  end
end
function GuildListInfoPage:getClassText(classType)
  if UI_Class.ClassType_Warrior == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WARRIOR")
  elseif UI_Class.ClassType_Ranger == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_RANGER")
  elseif UI_Class.ClassType_Sorcerer == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_SORCERER")
  elseif UI_Class.ClassType_Giant == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_GIANT")
  elseif UI_Class.ClassType_Tamer == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_TAMER")
  elseif UI_Class.ClassType_BladeMaster == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_BLADEMASTER")
  elseif UI_Class.ClassType_Valkyrie == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_VALKYRIE")
  elseif UI_Class.ClassType_BladeMasterWomen == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_BLADEMASTERWOMAN")
  elseif UI_Class.ClassType_Kunoichi == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_KUNOICHI")
  elseif UI_Class.ClassType_Wizard == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WIZARD")
  elseif UI_Class.ClassType_WizardWomen == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WIZARDWOMAN")
  elseif UI_Class.ClassType_NinjaWomen == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_NINJAWOMEN")
  elseif UI_Class.ClassType_NinjaMan == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_NINJAMAN")
  elseif UI_Class.ClassType_DarkElf == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_DARKELF")
  elseif UI_Class.ClassType_Combattant == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_STRIKER")
  elseif UI_Class.ClassType_CombattantWomen == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_COMBATTANTWOMEN")
  elseif UI_Class.ClassType_Lahn == classType then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_RAN")
  elseif UI_Class.ClassType_Orange == classType then
    return PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_ELFMAN")
  else
    return "-"
  end
end
function GuildListInfoPage:setOnline(isOnline, guildMemberInfo, elementControl, index, dataIdx)
  if nil == guildMemberInfo or nil == elementControl then
    return
  end
  if true == isOnline then
    local usableActivity = guildMemberInfo:getUsableActivity()
    if usableActivity > 10000 then
      usableActivity = 10000
    end
    local textActivity = tostring(guildMemberInfo:getTotalActivity()) .. "(<PAColor0xfface400>+" .. tostring(usableActivity) .. "<PAOldColor>)"
    elementControl._activity:SetText(textActivity)
    elementControl._activity:SetFontColor(UI_color.C_FFC4BEBE)
    elementControl._level:SetFontColor(UI_color.C_FFC4BEBE)
    elementControl._class:SetFontColor(UI_color.C_FFC4BEBE)
    elementControl._contributedTendency:SetFontColor(UI_color.C_FFC4BEBE)
    if guildMemberInfo:isSelf() then
      elementControl._charName:SetFontColor(UI_color.C_FFEF9C7F)
    else
      elementControl._charName:SetFontColor(UI_color.C_FFC4BEBE)
    end
    elementControl._charName:SetText(guildMemberInfo:getName() .. " (" .. guildMemberInfo:getCharacterName() .. ")")
    elementControl._charName:addInputEvent("Mouse_On", "")
    elementControl._charName:addInputEvent("Mouse_Out", "")
    if isVoiceOpen and 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() then
      elementControl._charName:SetText(guildMemberInfo:getName())
      elementControl._charName:addInputEvent("Mouse_On", "HandleToolTipCharacterName(true, " .. dataIdx .. "," .. index .. ")")
      elementControl._charName:addInputEvent("Mouse_Out", "HandleToolTipCharacterName(false)")
    end
    if true == isVoiceOpen then
      elementControl._saying:SetIgnore(false)
      elementControl._listening:SetIgnore(false)
    end
  else
    local textActivity = tostring(guildMemberInfo:getTotalActivity()) .. "(+" .. tostring(guildMemberInfo:getUsableActivity()) .. ")"
    elementControl._activity:SetText(textActivity)
    elementControl._contributedTendency:SetFontColor(UI_color.C_FF515151)
    elementControl._activity:SetFontColor(UI_color.C_FF515151)
    elementControl._level:SetFontColor(UI_color.C_FF515151)
    elementControl._class:SetFontColor(UI_color.C_FF515151)
    elementControl._charName:SetFontColor(UI_color.C_FF515151)
    elementControl._charName:SetText(guildMemberInfo:getName() .. " ( - )")
    elementControl._level:SetText("-")
    elementControl._class:SetText("-")
    if true == isVoiceOpen then
      elementControl._saying:SetIgnore(true)
      elementControl._listening:SetIgnore(true)
    end
  end
end
function GuildListInfoPage:setContractButton(index, guildMember, contractButton)
  local contractAble = guildMember:getContractableUtc()
  local expiration = guildMember:getContractedExpirationUtc()
  local isContractState = 0
  if 0 < Int64toInt32(getLeftSecond_TTime64(expiration)) then
    isContractState = 1
    if 0 >= Int64toInt32(getLeftSecond_TTime64(contractAble)) then
      isContractState = 0
    end
  else
    isContractState = 2
  end
  GuildListControl_ChangeTexture_Expiration(contractButton, isContractState)
  contractButton:addInputEvent("Mouse_On", "_guildListInfoPage_MandateTooltipShow( true, " .. isContractState .. ", " .. index .. ")")
  contractButton:addInputEvent("Mouse_Out", "_guildListInfoPage_MandateTooltipShow( false, " .. isContractState .. ", " .. index .. ")")
  contractButton:setTooltipEventRegistFunc("_guildListInfoPage_MandateTooltipShow( true, " .. isContractState .. ", " .. index .. ")")
  contractButton:addInputEvent("Mouse_LUp", "HandleClickedGuildMemberContractButton( " .. index .. " )")
  if 0 == ToClient_GetMyGuildInfoWrapper():getGuildGrade() then
    contractButton:SetIgnore(true)
    contractButton:SetMonoTone(true)
  else
    contractButton:SetIgnore(false)
    contractButton:SetMonoTone(false)
  end
end
function GuildListInfoPage:setSiegeParticipant(index, guildMember, control, isMyInfo)
  if _ContentsGroup_NewSiegeRule then
    local participantText = PAGetString(Defines.StringSheet_GAME, "LUA_SIEGE_PARTICIPANT")
    local nonparticipantText = PAGetString(Defines.StringSheet_GAME, "LUA_SIEGE_NONPARTICIPANT")
    if true == guildMember:isSelf() then
      control._warGradeBtn:SetShow(true)
      control._warStateBtn:SetShow(false)
      if guildMember:isSiegeParticipant() then
        control._warGradeBtn:SetText(participantText)
        control._warGradeBtn:addInputEvent("Mouse_LUp", "FGlobal_requestParticipateAtSiege( false )")
      else
        control._warGradeBtn:SetText(nonparticipantText)
        control._warGradeBtn:addInputEvent("Mouse_LUp", "FGlobal_requestParticipateAtSiege( true )")
      end
    else
      control._warGradeBtn:SetShow(false)
      control._warStateBtn:SetShow(true)
      if false == isRealServiceMode() then
        control._warStateBtn:addInputEvent("Mouse_LUp", "FGlobal_requestParticipateAtSiegeFromMaster( " .. tostring(guildMember:getUserNo()) .. " )")
      end
      if guildMember:isSiegeParticipant() then
        control._warStateBtn:SetText(participantText)
      else
        control._warStateBtn:SetText(nonparticipantText)
      end
    end
  elseif isWarGradeOpen then
    local siegGradeTempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_NAME_E")
    if 1 == guildMember:getSiegeCombatantGrade() then
      if false == isMyInfo then
        siegeGradeCount.grade1 = siegeGradeCount.grade1 + 1
      end
      siegGradeTempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_NAME_A")
    elseif 2 == guildMember:getSiegeCombatantGrade() then
      if false == isMyInfo then
        siegeGradeCount.grade2 = siegeGradeCount.grade2 + 1
      end
      siegGradeTempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_NAME_B")
    elseif 3 == guildMember:getSiegeCombatantGrade() then
      if false == isMyInfo then
        siegeGradeCount.grade3 = siegeGradeCount.grade3 + 1
      end
      siegGradeTempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_NAME_C")
    elseif 4 == guildMember:getSiegeCombatantGrade() then
      if false == isMyInfo then
        siegeGradeCount.grade4 = siegeGradeCount.grade4 + 1
      end
      siegGradeTempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_NAME_D")
    elseif 5 == guildMember:getSiegeCombatantGrade() then
      if false == isMyInfo then
        siegeGradeCount.grade5 = siegeGradeCount.grade5 + 1
      end
      siegGradeTempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_NAME_E")
    end
    control._warGradeBtn:SetText(siegGradeTempText)
    control._warGradeBtn:SetShow(true)
    control._warStateBtn:SetShow(false)
    if true == isMyInfo then
      control._warGradeState:SetShow(true)
      control._warGradeState:addInputEvent("Mouse_LUp", "HandleClickedWarGrade(" .. index .. ")")
      control._warGradeState:SetText(siegGradeTempText)
      control._warGradeBtn:SetShow(false)
    end
  end
  if true == guildMember:isVacation() then
    control._warGradeBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MEMBER_LIST_WAR_JOINBUTTON_VACATION"))
    control._warStateBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MEMBER_LIST_WAR_JOINBUTTON_VACATION"))
    control._warGradeBtn:addInputEvent("Mouse_LUp", "")
    control._warStateBtn:addInputEvent("Mouse_LUp", "")
    control._warGradeBtn:SetFontColor(UI_color.C_FF515151)
    control._warStateBtn:SetFontColor(UI_color.C_FF515151)
  else
    control._warGradeBtn:SetFontColor(UI_color.C_FFC4BEBE)
    control._warStateBtn:SetFontColor(UI_color.C_FFC4BEBE)
  end
end
function GuildListInfoPage:setVoiceButton(index, guildMember, control, isMyInfo)
  if true == isVoiceOpen then
    if guildMember:isVoiceChatSpeak() then
      if guildMember:isVoiceSpeaking() then
        local x1, y1, x2, y2 = setTextureUV_Func(control._saying, 105, 169, 133, 197)
        control._saying:getBaseTexture():setUV(x1, y1, x2, y2)
        control._saying:setRenderTexture(control._saying:getBaseTexture())
      else
        checkVoiceChatMicTexture(index, true)
      end
    else
      checkVoiceChatMicTexture(index, false)
    end
    checkVoiceChatListenTexture(index, guildMember:isVoiceChatListen())
  end
end
function GuildListInfoPage:UpdateDataDetail(guildMember, index, dataIdx, uiControlTable)
  local guildMemberUiInfo = self._list[index]
  if nil == guildMemberUiInfo then
    return
  end
  local isMyInfo = nil ~= uiControlTable
  if true == isMyInfo then
    guildMemberUiInfo = uiControlTable
  end
  local gradeType = guildMember:getGrade()
  local isVacation = guildMember:isVacation()
  self:setGradeInfo(guildMemberUiInfo._grade, index, gradeType, isVacation)
  guildMemberUiInfo._level:SetText(guildMember:getLevel())
  local classTypeName = GuildListInfoPage:getClassText(guildMember:getClassType())
  guildMemberUiInfo._class:SetText(classTypeName)
  local maxWp = guildMember:getMaxWp()
  if 0 == maxWp or true == guildMember:isGhostMode() then
    maxWp = "-"
  end
  local explorationPoint = guildMember:getExplorationPoint()
  guildMemberUiInfo._contributedTendency:SetText(maxWp .. "/" .. explorationPoint)
  if nil ~= guildMemberUiInfo.SetIgnore then
    if guildMember:isSelf() then
      guildMemberUiInfo:SetIgnore(true)
    else
      guildMemberUiInfo:SetIgnore(false)
    end
  end
  self:setVoiceButton(index, guildMember, guildMemberUiInfo, isMyInfo)
  local isOnline = true == guildMember:isOnline() and false == guildMember:isGhostMode()
  self:setOnline(isOnline, guildMember, guildMemberUiInfo, index, dataIdx)
  guildMemberUiInfo._charName:addInputEvent("Mouse_LUp", "HandleClickedGuildMemberMenuButton( " .. index .. " )")
  self:setContractButton(index, guildMember, guildMemberUiInfo._contractBtn)
  if nil ~= guildMemberUiInfo.SetShow then
    guildMemberUiInfo:SetShow(true)
  end
  self:setSiegeParticipant(index, guildMember, guildMemberUiInfo, isMyInfo)
  guildMemberUiInfo._guardHim:SetShow(guildMember:isProtectable())
  if true == PaGlobalFunc_checkIsSelfVolunteer() then
    guildMemberUiInfo._contractBtn:SetMonoTone(true)
    guildMemberUiInfo._contractBtn:addInputEvent("Mouse_On", "HandleOnOut_VolunteerMember_DontSeeContractTooltip(true," .. index .. ")")
    guildMemberUiInfo._contractBtn:addInputEvent("Mouse_Out", "HandleOnOut_VolunteerMember_DontSeeContractTooltip(false," .. index .. " )")
    guildMemberUiInfo._contractBtn:addInputEvent("Mouse_LUp", "")
    guildMemberUiInfo._warGradeBtn:addInputEvent("Mouse_LUp", "")
    guildMemberUiInfo._warStateBtn:addInputEvent("Mouse_LUp", "")
  end
end
function GuildListInfoTooltip_Vacation(isShow, index)
  if nil == index then
    return
  end
  local self = GuildListInfoPage
  local name, desc, dcontrol
  name = PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_GUILD_LIST_GRADE_ICON_VACATION_TOOLTIP")
  desc = nil
  control = self._list[index]._grade
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function GuildListInfoTooltip_Grade(isShow, index, gradeType)
  if nil == index then
    return
  end
  local self = GuildListInfoPage
  local name, desc, control
  local gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMEMBER")
  if __eGuildMemberGradeMaster == gradeType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMASTER")
  elseif __eGuildMemberGradeSubMaster == gradeType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDSUBMASTER")
  elseif __eGuildMemberGradeNormal == gradeType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMEMBER")
  elseif __eGuildMemberGradeSupplyOfficer == gradeType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_SUPPLYOFFICER")
  elseif __eGuildMemberGradeJunior == gradeType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_NEWBIE")
  elseif __eGuildMemberGradeVolunteer == gradeType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_GUILD_LIST_GRADE_ICON_VACATION_TOOLTIP")
  end
  control = self._list[index]._grade
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function HandleOnOut_VolunteerMember_DontSeeContractTooltip(isShow, index)
  if nil == index then
    return
  end
  local self = GuildListInfoPage
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRACT_TITLE")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_VOLUNTEERMEMBER_DONTSEE_CONTRACT")
  control = self._list[index]._contractBtn
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function GuildListInfoPage:UpdateVoiceDataByUserNo(userNo)
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local memberCount = myGuildListInfo:getMemberCount()
  local uiIndex = 0
  for index = 0, memberCount - 1 do
    if userNo == tempGuildUserNolist[index] then
      uiIndex = index
    end
  end
  if nil == uiIndex then
    return
  end
  local myGuildMemberInfo = myGuildListInfo:getMemberByUserNo(userNo)
  if nil == myGuildMemberInfo then
    return
  end
  if myGuildMemberInfo:isVoiceChatSpeak() then
    if myGuildMemberInfo:isVoiceSpeaking() then
      local x1, y1, x2, y2 = setTextureUV_Func(self._list[uiIndex]._saying, 105, 169, 133, 197)
      self._list[uiIndex]._saying:getBaseTexture():setUV(x1, y1, x2, y2)
      self._list[uiIndex]._saying:setRenderTexture(self._list[uiIndex]._saying:getBaseTexture())
    else
      local x1, y1, x2, y2 = setTextureUV_Func(self._list[uiIndex]._saying, 105, 198, 133, 226)
      self._list[uiIndex]._saying:getBaseTexture():setUV(x1, y1, x2, y2)
      self._list[uiIndex]._saying:setRenderTexture(self._list[uiIndex]._saying:getBaseTexture())
    end
  else
    checkVoiceChatMicTexture(uiIndex, false)
  end
end
function GuildListInfoPage:checkSelfVolunteer()
  local self = GuildListInfoPage
  if true == PaGlobalFunc_checkIsSelfVolunteer() then
    self._btnDeposit:SetShow(false)
    self._btnPaypal:SetShow(false)
    self._btnSiegeReward:SetShow(false)
  else
    self._btnDeposit:SetShow(true)
    self._btnPaypal:SetShow(true)
    self._btnSiegeReward:SetShow(true)
  end
end
function FGlobal_GuildListOnlineCheck()
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local memberCount = myGuildListInfo:getMemberCount()
  for index = 0, memberCount - 1 do
    local myGuildMemberInfo = myGuildListInfo:getMember(index)
    if nil == myGuildMemberInfo then
      return
    end
    if myGuildMemberInfo:isOnline() == true then
      _onlineGuildMember = _onlineGuildMember + 1
    end
  end
end
function HandleClicked_GuildMasterMandate(index)
  local self = GuildListInfoPage
  if not ToClient_IsAbleChangeMaster() then
    return
  end
  ToClient_RequestChangeGuildMaster(index)
  self:UpdateData()
end
function GuildListControl_ChangeTexture_Expiration(control, state)
  control:ChangeTextureInfoName("renewal/pcremaster/remaster_etc_guild.dds")
  if 2 == state then
    local x1, y1, x2, y2 = setTextureUV_Func(control, 201, 116, 223, 138)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    local x1, y1, x2, y2 = setTextureUV_Func(control, 201, 139, 223, 161)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    local x1, y1, x2, y2 = setTextureUV_Func(control, 201, 162, 223, 184)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif 0 == state then
    local x1, y1, x2, y2 = setTextureUV_Func(control, 201, 47, 223, 69)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    local x1, y1, x2, y2 = setTextureUV_Func(control, 201, 70, 223, 92)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    local x1, y1, x2, y2 = setTextureUV_Func(control, 201, 93, 223, 115)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  elseif 1 == state then
    local x1, y1, x2, y2 = setTextureUV_Func(control, 201, 185, 223, 207)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    local x1, y1, x2, y2 = setTextureUV_Func(control, 201, 208, 223, 230)
    control:getOnTexture():setUV(x1, y1, x2, y2)
    local x1, y1, x2, y2 = setTextureUV_Func(control, 201, 231, 223, 253)
    control:getClickTexture():setUV(x1, y1, x2, y2)
  end
end
function GuildListInfoPage:Show()
  if false == self._frameDefaultBG:GetShow() then
    self._frameDefaultBG:SetShow(true)
    self._scrollBar:SetControlPos(0)
    self:SetGuildList()
    _selectSortType = 0
    self:GuildListSortSet()
    self:UpdateData()
    FGlobal_Notice_Update()
    self.listening_Volume:SetShow(false)
    ToClient_RequestWarehouseInfo()
    GuildList_PanelResize_ByFontSize()
  end
end
function GuildListInfoPage:Hide()
  if true == self._frameDefaultBG:GetShow() then
    self._frameDefaultBG:SetShow(false)
    ClearFocusEdit()
    CheckChattingInput()
  end
end
function FGlobal_GuildListScrollTop()
  local self = GuildListInfoPage
  self._scrollBar:SetControlTop()
end
function HandleClicked_SetIncentive()
  SetFocusEdit(incentive_InputMoney)
  inputGuildDepositNum_s64 = toInt64(0, 0)
  incentive_InputMoney:SetEditText("", true)
  incentive_InputMoney:SetNumberMode(true)
end
function FGlobal_GuildIncentive_Close()
  if not Panel_GuildIncentive:GetShow() then
    return
  end
  ClearFocusEdit()
  Panel_GuildIncentive:SetShow(false)
  CheckChattingInput()
end
function HandleClicked_GuildIncentive_Close()
  if not Panel_GuildIncentive:GetShow() then
    return
  end
  ClearFocusEdit()
  CheckChattingInput()
  Panel_GuildIncentive:SetShow(false)
end
function HandleClicked_GuildIncentive_Send()
  local tempMoney = tonumber(incentive_InputMoney:GetEditText())
  if nil == tempMoney or tempMoney <= 0 or tempMoney == "" then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_PERFORM_MESSAGE_0"))
    ClearFocusEdit()
    return
  end
  if 0 == _incentivePanelType then
  else
    ToClient_DepositToGuildWareHouse(tempMoney)
  end
  ClearFocusEdit()
  FGlobal_GuildIncentive_Close()
end
function FGlobal_SaveGuildMoney_Send()
  HandleClicked_GuildIncentive_Send()
end
function FGlobal_CheckSaveGuildMoneyUiEdit(targetUI)
  return nil ~= targetUI and targetUI:GetKey() == incentive_InputMoney:GetKey()
end
function FGlobal_GuildDeposit_InputCheck()
  for idx, val in ipairs(numberKeyCode) do
    if isKeyDown_Once(val) then
      if idx > 10 then
        _GuildDeposit_InputCheck_Command(idx - 11)
      else
        _GuildDeposit_InputCheck_Command(idx - 1)
      end
    end
  end
  if isKeyDown_Once(VCK.KeyCode_BACK) then
    _GuildDeposit_InputCheck_BackSpaceCommand()
  end
end
function _GuildDeposit_InputCheck_Command(number)
  local str = tostring(inputGuildDepositNum_s64)
  local newStr = str .. tostring(number)
  local s64_newNumber = tonumber64(newStr)
  local s64_MAX = inputGuildDepositMaxNum_s64
  if s64_newNumber > s64_MAX then
    inputGuildDepositNum_s64 = inputGuildDepositMaxNum_s64
  else
    inputGuildDepositNum_s64 = s64_newNumber
  end
  incentive_InputMoney:SetEditText(tostring(inputGuildDepositNum_s64), true)
end
function _GuildDeposit_InputCheck_BackSpaceCommand()
  local str = tostring(inputGuildDepositNum_s64)
  local length = string.len(str)
  local newStr = ""
  if length > 1 then
    newStr = string.sub(str, 1, length - 1)
    inputGuildDepositNum_s64 = tonumber64(newStr)
  else
    newStr = "0"
    inputGuildDepositNum_s64 = Defines.s64_const.s64_0
  end
  incentive_InputMoney:SetEditText(newStr, true)
end
function FGlobal_GuildMenuButtonHide()
  GuildListInfoPage._buttonListBG:SetShow(false)
end
function GuildList_PanelResize_ByFontSize()
  local self = GuildListInfoPage
  if isVoiceOpen then
    if 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() and isVoiceOpen then
      self.staticText_charName:SetSize(135, 20)
      self.staticText_charName:SetPosX(240)
      self.staticText_activity:SetPosX(485)
      self.staticText_contributedTendency:SetPosX(590)
      self.staticText_Voice:SetPosX(670)
      if isWarGradeOpen then
        self.staticText_WarGrade:SetPosX(760)
        self.staticText_contract:SetPosX(830)
      else
        self.staticText_contract:SetPosX(680)
      end
    else
      self.staticText_charName:SetSize(240, 20)
      self.staticText_charName:SetPosX(240)
      self.staticText_activity:SetPosX(500)
      if isVoiceOpen then
        self.staticText_contributedTendency:SetPosX(590)
      else
        self.staticText_contributedTendency:SetPosX(535)
      end
      self.staticText_Voice:SetPosX(670)
      if isWarGradeOpen then
        self.staticText_WarGrade:SetPosX(745)
        self.staticText_contract:SetPosX(830)
      else
        self.staticText_contract:SetPosX(680)
      end
    end
  else
    self.staticText_charName:SetPosX(220)
    self.staticText_activity:SetPosX(480)
    self.staticText_contributedTendency:SetPosX(600)
    self.staticText_WarGrade:SetPosX(740)
    self.staticText_contract:SetPosX(840)
  end
  if isVoiceOpen then
    for index = 0, _constGuildListMaxCount - 1 do
      local rtGuildListInfo = GuildListInfoPage._list[index]
      if 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() then
        rtGuildListInfo._charName:SetSize(120, 20)
        rtGuildListInfo._charName:SetPosX(250)
        rtGuildListInfo._activity:SetPosX(455)
        rtGuildListInfo._contributedTendency:SetPosX(575)
        rtGuildListInfo._saying:SetPosX(668)
        rtGuildListInfo._listening:SetPosX(690)
      else
        rtGuildListInfo._charName:SetSize(240, 20)
        rtGuildListInfo._charName:SetPosX(230)
        rtGuildListInfo._activity:SetPosX(470)
        rtGuildListInfo._contributedTendency:SetPosX(570)
        rtGuildListInfo._saying:SetPosX(668)
        rtGuildListInfo._listening:SetPosX(690)
      end
    end
  else
    for index = 0, _constGuildListMaxCount - 1 do
      local rtGuildListInfo = GuildListInfoPage._list[index]
      rtGuildListInfo._charName:SetSize(240, 20)
      rtGuildListInfo._charName:SetPosX(210)
      rtGuildListInfo._activity:SetPosX(450)
      rtGuildListInfo._contributedTendency:SetPosX(580)
    end
  end
  for index = 0, _constGuildListMaxCount - 1 do
    local rtGuildListInfo = GuildListInfoPage._list[index]
    if isWarGradeOpen then
      rtGuildListInfo._warGradeBtn:SetPosX(740)
      rtGuildListInfo._warStateBtn:SetPosX(740)
      rtGuildListInfo._contractBtn:SetPosX(860)
    else
      rtGuildListInfo._contractBtn:SetPosX(705)
    end
  end
end
function GuildList_Simpletooltips(isShow, tipType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local self = rtGuildListInfo
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "FRAME_GUILD_LIST_BTN_INCENTIVE")
    control = self._btnGiveIncentive
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "FRAME_GUILD_LIST_BTN_DEPOSIT")
    control = self._btnDeposit
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "FRAME_GUILD_LIST_BTN_PAYPAL")
    control = self._btnPaypal
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "FRAME_GUILD_LIST_BTN_WELFARE")
    control = self._btnWelfare
  elseif 4 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "FRAME_GUILD_LIST_BTN_WELFARE")
    control = self._btnSiegeReward
  end
  TooltipSimple_Show(control, name, desc)
end
if false == _ContentsGroup_RenewUI_Guild then
  registerEvent("FromClient_ResponseGuildMasterChange", "FromClient_ResponseGuildMasterChange")
  registerEvent("FromClient_ResponseChangeGuildMemberGrade", "FromClient_ResponseChangeGuildMemberGrade")
  registerEvent("FromClient_RequestExpelMemberFromGuild", "FromClient_RequestExpelMemberFromGuild")
  registerEvent("FromClient_RequestChangeGuildMemberGrade", "FromClient_RequestChangeGuildMemberGrade")
  registerEvent("FromClient_ResponseChangeProtectGuildMember", "FromClient_ResponseChangeProtectGuildMember")
  registerEvent("FromClient_ChangedSiegeGrade", "FromClient_ChangedSiegeGrade")
  registerEvent("FromClient_ResponseParticipateSiege", "FromClient_ResponseParticipateSiege")
  registerEvent("FromClient_ResponseTakableSiegeReward", "FromClient_ResponseTakableSiegeReward")
end
function PaGlobalFunc_GuildListInfoPage_Update()
  GuildListInfoPage:UpdateData()
end
function FromClient_ResponseParticipateSiege(isParticipant, isSelf)
  GuildListInfoPage:UpdateData()
  if true == isSelf then
    if true == isParticipant then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SIEGE_NAKMESSAGE_PARTICIPANT"))
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SIEGE_NAKMESSAGE_NONPARTICIPANT"))
    end
  end
end
function FromClient_ResponseTakableSiegeReward()
  GuildListInfoPage:UpdateData()
end
function FromClient_ResponseGuildMasterChange(userNo, targetNo)
  local userNum = Int64toInt32(getSelfPlayer():get():getUserNo())
  if userNum == Int64toInt32(userNo) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MASTERCHANGE_MESSAGE_0"))
  elseif userNum == Int64toInt32(targetNo) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MASTERCHANGE_MESSAGE_1"))
  end
  GuildListInfoPage:UpdateData()
end
function FromClient_ResponseChangeGuildMemberGrade(targetNo, grade, beforeGrade)
  local userNum = Int64toInt32(getSelfPlayer():get():getUserNo())
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  local beforeGradeStr, gradeStr, msg
  if nil ~= guildWrapper then
    local guildGrade = guildWrapper:getGuildGrade()
    if 0 ~= guildGrade then
      if userNum == Int64toInt32(targetNo) then
        if 1 == grade then
          msg = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GRADECHANGE_MESSAGE_0")
          gradeStr = PAGetString(Defines.StringSheet_GAME, "LUA_CHANGE_GUILD_MEMBER_GRADE_MESSAGE_01")
        elseif 2 == grade then
          msg = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GRADECHANGE_MESSAGE_1")
          gradeStr = PAGetString(Defines.StringSheet_GAME, "LUA_CHANGE_GUILD_MEMBER_GRADE_MESSAGE_02")
        elseif 3 == grade then
          msg = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SUPPLYOFFICER_APPOINTMENT_DO")
          gradeStr = PAGetString(Defines.StringSheet_GAME, "LUA_CHANGE_GUILD_MEMBER_GRADE_MESSAGE_03")
        end
        if 1 == beforeGrade then
          beforeGradeStr = PAGetString(Defines.StringSheet_GAME, "LUA_CHANGE_GUILD_MEMBER_GRADE_MESSAGE_01")
        elseif 2 == beforeGrade then
          beforeGradeStr = PAGetString(Defines.StringSheet_GAME, "LUA_CHANGE_GUILD_MEMBER_GRADE_MESSAGE_02")
        elseif 3 == beforeGrade then
          beforeGradeStr = PAGetString(Defines.StringSheet_GAME, "LUA_CHANGE_GUILD_MEMBER_GRADE_MESSAGE_03")
        end
      end
    elseif userNum == Int64toInt32(targetNo) then
      if 1 == grade then
        msg = PAGetString(Defines.StringSheet_GAME, "LUA_CLAN_GRADECHANGE_MESSAGE_4")
        gradeStr = PAGetString(Defines.StringSheet_GAME, "LUA_CHANGE_GUILD_MEMBER_GRADE_MESSAGE_01")
      elseif 2 == grade then
        msg = PAGetString(Defines.StringSheet_GAME, "LUA_CLAN_GRADECHANGE_MESSAGE_5")
        gradeStr = PAGetString(Defines.StringSheet_GAME, "LUA_CHANGE_CLAN_MEMBER_GRADE_MESSAGE_01")
      end
      if 1 == beforeGrade then
        beforeGradeStr = PAGetString(Defines.StringSheet_GAME, "LUA_CHANGE_GUILD_MEMBER_GRADE_MESSAGE_01")
      elseif 2 == beforeGrade then
        beforeGradeStr = PAGetString(Defines.StringSheet_GAME, "LUA_CHANGE_CLAN_MEMBER_GRADE_MESSAGE_01")
      end
    end
  end
  if nil ~= gradeStr and nil ~= beforeGradeStr then
    Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_CHANGE_MEMBER_GRADE_MESSAGE", "beforeGradeStr", beforeGradeStr, "gradeStr", gradeStr))
  elseif nil ~= msg then
    Proc_ShowMessage_Ack(msg)
  end
  GuildServantList_Close()
  FGlobal_Window_Servant_Update()
  GuildListInfoPage:UpdateData()
end
function FromClient_ResponseChangeProtectGuildMember(targetNo, isProtectable)
  local userNum = Int64toInt32(getSelfPlayer():get():getUserNo())
  if userNum == Int64toInt32(targetNo) then
    if true == isProtectable then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PROTECT_GUILDMEMBER_MESSAGE_0"))
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PROTECT_GUILDMEMBER_MESSAGE_1"))
    end
  end
  GuildServantList_Close()
  FGlobal_Window_Servant_Update()
  GuildListInfoPage:UpdateData()
end
function FromClient_RequestExpelMemberFromGuild()
  if true == Panel_Window_Guild:GetShow() then
    GuildListInfoPage:UpdateData()
  elseif true == Panel_ClanList:GetShow() then
    FGlobal_ClanList_Update()
  end
  GuildServantList_Close()
  FGlobal_Window_Servant_Update()
end
function FromClient_RequestChangeGuildMemberGrade(grade)
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil ~= guildWrapper then
    local guildGrade = guildWrapper:getGuildGrade()
    if 0 ~= guildGrade then
      if 1 == grade then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GRADECHANGE_MESSAGE_2"))
      elseif 2 == grade then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GRADECHANGE_MESSAGE_3"))
      elseif 3 == grade then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GRADECHANGE_MESSAGE_4"))
      end
    elseif 1 == grade then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CLAN_GRADECHANGE_MESSAGE_2"))
    elseif 2 == grade then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CLAN_GRADECHANGE_MESSAGE_3"))
    end
  end
  GuildServantList_Close()
  FGlobal_Window_Servant_Update()
  GuildListInfoPage:UpdateData()
end
function HandleClicked_GuildListWelfare_Request()
  ToClient_RequestGuildWelfare()
end
function FGlobal_requestParticipateAtSiege(isparticipant)
  local function confirm()
    ToClient_resquestParticipateSiege(isparticipant)
  end
  local messageBoxMemo
  if true == isparticipant then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SIEGE_MESSAGEBOX_PARTICIPANT")
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SIEGE_MESSAGEBOX_NONPARTICIPANT")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = messageBoxMemo,
    functionYes = confirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FGlobal_requestParticipateAtSiegeFromMaster(userNo)
  if true == isRealServiceMode() then
    return
  end
  local function confirm()
    local isGuildMaster = getSelfPlayer():get():isGuildMaster()
    local isParticipant
    if true == isGuildMaster then
      local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
      local guildMember = myGuildListInfo:getMemberByUserNo(userNo)
      local memberCount = myGuildListInfo:getMemberCount()
      local targetUserNo
      local isSiegeParticipant = not guildMember:isSiegeParticipant()
      ToClient_resquestParticipateSiegeFromMaster(myGuildListInfo:getGuildNo_s64(), userNo, isSiegeParticipant)
    end
  end
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  local guildMember = myGuildListInfo:getMemberByUserNo(userNo)
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SIEGE_MESSAGEBOX_CHANGEPARTICIPANT", "GuildMember", guildMember:getName())
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = messageBoxMemo,
    functionYes = confirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FromClient_ChangedSiegeGrade(isNotify, userName, grade)
  if true == isNotify then
    local str = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_SETTING_TOOLTIP", "userName", userName, "grade", tostring(6 - grade))
    Proc_ShowMessage_Ack(str)
  end
  GuildListInfoPage:UpdateData()
end

local CT2S = CppEnums.ClassType2String
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_TM = CppEnums.TextMode
local IM = CppEnums.EProcessorInputMode
local UI_VT = CppEnums.VehicleType
local isGuildBattle = ToClient_IsContentsGroupOpen("280")
local isProtectGuildMember = ToClient_IsContentsGroupOpen("52")
local isContentsGuildDuel = ToClient_IsContentsGroupOpen("69") and not isGuildBattle
local isContentsGuildInfo = ToClient_IsContentsGroupOpen("206")
local isContentsArsha = ToClient_IsContentsGroupOpen("227")
local isContentsGuildHouse = ToClient_IsContentsGroupOpen("36")
local isCanDoReservation = ToClient_IsCanDoReservationArsha()
local lifeType = {
  [0] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_GATHERING"),
  [1] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_FISHING"),
  [2] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_HUNTING"),
  [3] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_COOKING"),
  [4] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_ALCHEMY"),
  [5] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_PROCESSING"),
  [6] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_OBEDIENCE"),
  [7] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE"),
  [8] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_GROWTH"),
  [9] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_WEALTH"),
  [10] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_COMBAT")
}
local tabNumber = 99
local _urlCache = ""
local isPopUpContentsEnable = ToClient_IsContentsGroupOpen("240")
function guild_ShowAni()
  if nil == Panel_Window_Guild then
    return
  end
  Panel_Window_Guild:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_Window_Guild, 0, 0.3)
end
function guild_HideAni()
  if nil == Panel_Window_Guild then
    return
  end
  local ani1 = UIAni.AlphaAnimation(0, Panel_Window_Guild, 0, 0.2)
  ani1:SetHideAtEnd(true)
end
local constCreateWarInfoCount = 4
local keyUseCheck = true
local guildCommentsWebUrl
local GuildInfoPage = {}
function GuildInfoPage:initialize()
  if nil == Panel_Window_Guild then
    return
  end
  self._area_MainBG = UI.getChildControl(Panel_Window_Guild, "Static_Button_BG")
  self._guildMainBG = UI.getChildControl(Panel_Window_Guild, "Static_Menu_BG_0")
  self._windowTitleBg = UI.getChildControl(Panel_Window_Guild, "StaticText_Title")
  self._windowTitle = UI.getChildControl(self._windowTitleBg, "StaticText_TitleIcon")
  self._iconOccupyTerritory = UI.getChildControl(Panel_Window_Guild, "Static_GuildIcon_BG")
  self._iconGuildMark = UI.getChildControl(Panel_Window_Guild, "Static_Guild_Icon")
  self._area_Info = UI.getChildControl(Panel_Window_Guild, "Static_InfoArea")
  self._line_Top = UI.getChildControl(Panel_Window_Guild, "Static_TopLine")
  self._area_Introduce = UI.getChildControl(Panel_Window_Guild, "Static_IntroduceArea")
  self._introduce_btn = UI.getChildControl(self._area_Introduce, "Button_Introduce")
  self._introduce_Reset = UI.getChildControl(self._area_Introduce, "Button_IntroReset")
  self._introduce_edit = UI.getChildControl(self._area_Introduce, "MultilineEdit_Introduce")
  self._introduce_edit_TW = UI.getChildControl(self._area_Introduce, "MultilineEdit_Introduce_TW")
  self._promote_btn = UI.getChildControl(self._area_Introduce, "Button_Promote")
  self._txtRGuildName = UI.getChildControl(Panel_Window_Guild, "StaticText_R_GuildName")
  self._txtRMaster = UI.getChildControl(Panel_Window_Guild, "StaticText_R_Master")
  self._txtRRank_Title = UI.getChildControl(self._area_Info, "StaticText_GuildRank")
  self._txtRRank = UI.getChildControl(self._area_Info, "StaticText_GuildRank_Value")
  self._txtUnpaidTax = UI.getChildControl(Panel_Window_Guild, "StaticText_UnpaidTax")
  self._btnIncreaseMember = UI.getChildControl(self._area_Info, "Button_IncreaseMember")
  self._btnTaxPayment = UI.getChildControl(Panel_Window_Guild, "Button_TaxPayment")
  self._txtGuildPoint = UI.getChildControl(self._area_Info, "StaticText_Point")
  self._txtGuildPointValue = UI.getChildControl(self._area_Info, "StaticText_Point_Value")
  self._txtGuildPointPercent = UI.getChildControl(self._area_Info, "StaticText_Point_Percent")
  self._planning = UI.getChildControl(Panel_Window_Guild, "StaticText_1")
  self._planning:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TODAY_COMMENT"))
  self._txtProtect = UI.getChildControl(self._area_Info, "StaticText_Protect")
  self._txtProtectValue = UI.getChildControl(self._area_Info, "StaticText_ProtectValue")
  self._btnProtectAdd = UI.getChildControl(self._area_Info, "Button_ProtectAdd")
  self._txtGuildMoneyTitle = UI.getChildControl(self._area_Info, "StaticText_GuildMoneyTitle")
  self._txtGuildMoney = UI.getChildControl(self._area_Info, "StaticText_GuildMoneyValue")
  self._txtGuildTerritoryTitle = UI.getChildControl(self._area_Info, "StaticText_TerritoryArea")
  self._txtGuildTerritoryValue = UI.getChildControl(self._area_Info, "StaticText_TerritoryAreaValue")
  self._txtGuildTerritoryValue:SetTextMode(UI_TM.eTextMode_LimitText)
  self._btnEvacuation = UI.getChildControl(Panel_Window_Guild, "Button_Evacuation")
  self._txtGuildServantTitle = UI.getChildControl(self._area_Info, "StaticText_GuildServant")
  self._txtGuildServantValue = UI.getChildControl(self._area_Info, "StaticText_GuildServantValue")
  self._txtGuildServantValue:SetTextMode(UI_TM.eTextMode_LimitText)
  self._btn_GuildMasterMandateBG = UI.getChildControl(self._area_Info, "Static_GuildMandateBG")
  self._btn_GuildMasterMandate = UI.getChildControl(self._area_Info, "Button_GuildMandate")
  self._btnGuildDel = UI.getChildControl(self._area_Info, "Button_GuildDispersal")
  self._btnGetVacation = UI.getChildControl(self._area_Info, "Button_GetVacation")
  self._btnReleaseVacation = UI.getChildControl(self._area_Info, "Button_ReleaseVacation")
  self._btnChangeMark = UI.getChildControl(self._area_Info, "Button_GuildMark")
  self._btnGuildWebInfo = UI.getChildControl(self._area_Info, "Button_GuildInfo_Web")
  self._btnGuildWarehouse = UI.getChildControl(self._area_Info, "Button_GuildInfo_Warehouse")
  self._btnGetArshaHost = UI.getChildControl(self._area_Info, "Button_GetArshaHost")
  self._area_TodayComment = UI.getChildControl(Panel_Window_Guild, "Static_TodayCommentArea")
  self._area_TodayComment:SetAlpha(0.5)
  self._Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, self._area_TodayComment, "WebControl_TodayComment")
  self._Web:SetShow(true)
  self._Web:SetSize(474, 216)
  self._Web:SetHorizonCenter()
  self._Web:SetVerticalBottom()
  self._Web:SetSpanSize(0, 10)
  self._Web:ResetUrl()
  Panel_Window_Guild:SetChildIndex(self._Web, 9999)
  self.notice_title = UI.getChildControl(Panel_Window_Guild, "StaticText_NoticeTitle")
  self.notice_edit = UI.getChildControl(Panel_Window_Guild, "Edit_Notice")
  self.notice_btn = UI.getChildControl(Panel_Window_Guild, "Button_Notice")
  self.checkPopUp = UI.getChildControl(Panel_Window_Guild, "CheckButton_PopUp")
  if not isContentsGuildInfo then
    self._btnGuildWebInfo:SetShow(false)
  end
  if ToClient_IsConferenceMode() then
    self._btnGuildWebInfo:SetIgnore(true)
    self._btnGuildWebInfo:SetMonoTone(true)
  end
  if not isProtectGuildMember then
    self._btnProtectAdd:SetShow(false)
  end
  if false == isContentsArsha or false == isCanDoReservation then
    self._btnGetArshaHost:SetShow(false)
  end
  if not isContentsGuildHouse then
    self._btnGuildWarehouse:SetShow(false)
  end
  function self:GetShow()
    return self._btnGuildDel:GetShow()
  end
  self:checkShowVacationButton()
  self._btnGetVacation:addInputEvent("Mouse_On", "GuildSimplTooltips(true, 15)")
  self._btnGetVacation:addInputEvent("Mouse_Out", "GuildSimplTooltips(false, 15)")
  self._btnReleaseVacation:addInputEvent("Mouse_On", "GuildSimplTooltips(true, 16)")
  self._btnReleaseVacation:addInputEvent("Mouse_Out", "GuildSimplTooltips(false, 16)")
  self._btnGetVacation:addInputEvent("Mouse_LUp", "HandleClicked_Guild_GetVacation( true )")
  self._btnReleaseVacation:addInputEvent("Mouse_LUp", "HandleClicked_Guild_GetVacation( false )")
  self._introduce_Reset:addInputEvent("Mouse_On", "GuildSimplTooltips(true, 13)")
  self._introduce_Reset:addInputEvent("Mouse_Out", "GuildSimplTooltips(false)")
  self._introduce_btn:addInputEvent("Mouse_On", "GuildSimplTooltips(true, 14)")
  self._introduce_btn:addInputEvent("Mouse_Out", "GuildSimplTooltips(false)")
  self._btnGuildDel:addInputEvent("Mouse_LUp", "HandleClickedGuildDel()")
  self._btnChangeMark:addInputEvent("Mouse_LUp", "HandleClickedChangeMark()")
  self._btnTaxPayment:addInputEvent("Mouse_LUp", "HandleClicked_TaxPayment()")
  self._btnIncreaseMember:addInputEvent("Mouse_LUp", "HandleClickedIncreaseMember()")
  self._btnIncreaseMember:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 6, true )")
  self._btnIncreaseMember:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 6, false )")
  self._btnProtectAdd:addInputEvent("Mouse_LUp", "HandleClickedIncreaseProtectMember()")
  self._btnProtectAdd:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 8, true )")
  self._btnProtectAdd:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 8, false )")
  self._btnChangeMark:addInputEvent("Mouse_On", "GuildSimplTooltips(true, 2)")
  self._btnChangeMark:addInputEvent("Mouse_Out", "GuildSimplTooltips(false, 2)")
  self._btnGuildDel:addInputEvent("Mouse_On", "GuildSimplTooltips(true, 3)")
  self._btnGuildDel:addInputEvent("Mouse_Out", "GuildSimplTooltips(false, 3)")
  self._btnGuildWebInfo:addInputEvent("Mouse_LUp", "FGlobal_GuildWebInfoFromGuildMain_Open()")
  self._btnGuildWebInfo:addInputEvent("Mouse_On", "GuildSimplTooltips( true, 6 )")
  self._btnGuildWebInfo:addInputEvent("Mouse_Out", "GuildSimplTooltips( false, 6 )")
  self._btnGuildWarehouse:addInputEvent("Mouse_LUp", "GuildWarehouseOpen()")
  self._btnGuildWarehouse:addInputEvent("Mouse_On", "GuildSimplTooltips( true, 7 )")
  self._btnGuildWarehouse:addInputEvent("Mouse_Out", "GuildSimplTooltips( false, 7 )")
  if true == isContentsArsha and true == isCanDoReservation then
    self._btnGetArshaHost:addInputEvent("Mouse_LUp", "HandleClickedGetArshaHost()")
    self._btnGetArshaHost:addInputEvent("Mouse_On", "GuildSimplTooltips( true, 8 )")
    self._btnGetArshaHost:addInputEvent("Mouse_Out", "GuildSimplTooltips( false, 8 )")
  end
  self._btn_GuildMasterMandate:addInputEvent("Mouse_On", "GuildSimplTooltips( true, 0 )")
  self._btn_GuildMasterMandate:addInputEvent("Mouse_Out", "GuildSimplTooltips( false, 0 )")
  self._btn_GuildMasterMandateBG:addInputEvent("Mouse_On", "GuildSimplTooltips( true, 1 )")
  self._btn_GuildMasterMandateBG:addInputEvent("Mouse_Out", "GuildSimplTooltips( false, 1 )")
  self.checkPopUp:addInputEvent("Mouse_LUp", "HandleClickedGuild_PopUp()")
  self.checkPopUp:addInputEvent("Mouse_On", "Guild_PopUp_ShowIconToolTip( true )")
  self.checkPopUp:addInputEvent("Mouse_Out", "Guild_PopUp_ShowIconToolTip( false )")
  if not isGameTypeEnglish() then
    self._txtRGuildName:addInputEvent("Mouse_On", "GuildSimplTooltips( true, 4 )")
    self._txtRGuildName:addInputEvent("Mouse_Out", "GuildSimplTooltips( false, 4 )")
    self._txtRMaster:addInputEvent("Mouse_On", "GuildSimplTooltips( true, 5 )")
    self._txtRMaster:addInputEvent("Mouse_Out", "GuildSimplTooltips( false, 5 )")
    self._txtRGuildName:SetIgnore(false)
    self._txtRMaster:SetIgnore(false)
  else
    self._txtRGuildName:SetIgnore(true)
    self._txtRMaster:SetIgnore(true)
  end
  self.notice_title:addInputEvent("Mouse_On", "GuildSimplTooltips(true, 9)")
  self.notice_title:addInputEvent("Mouse_Out", "GuildSimplTooltips(false)")
  self.notice_btn:addInputEvent("Mouse_On", "GuildSimplTooltips(true, 10)")
  self.notice_btn:addInputEvent("Mouse_Out", "GuildSimplTooltips(false)")
  self._btnEvacuation:addInputEvent("Mouse_LUp", "HandleClickedRelease()")
  self._btnEvacuation:addInputEvent("Mouse_On", "GuildSimplTooltips( true, 11 )")
  self._btnEvacuation:addInputEvent("Mouse_Out", "GuildSimplTooltips( false, 11 )")
  self.checkPopUp:SetShow(isPopUpContentsEnable)
end
local HandleClickedGuildDelContinue = function()
  ToClient_RequestDestroyGuild()
  HandleClickedGuildHideButton()
end
local HandleClickedGuildLeaveContinue = function()
  ToClient_RequestDisjoinGuild()
  HandleClickedGuildHideButton()
end
function PaGlobalFunc_checkIsSelfVolunteer()
  if false == _ContentsGroup_BattleFieldVolunteer then
    return false
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return false
  end
  if __eGuildMemberGradeVolunteer == selfPlayer:getGuildMemberGrade() then
    return true
  end
  return false
end
local isVacation
function GuildInfoPage:checkShowVacationButton()
  if nil == Panel_Window_Guild then
    return
  end
  if false == _ContentsGroup_BattleFieldVolunteer then
    self._btnGetVacation:SetShow(false)
    self._btnReleaseVacation:SetShow(false)
    return
  end
  if nil ~= getSelfPlayer() then
    if getSelfPlayer():get():isGuildMaster() then
      self._btnGetVacation:SetShow(false)
      self._btnReleaseVacation:SetShow(false)
      return
    end
  elseif nil == getSelfPlayer() then
    return
  end
  if true == PaGlobalFunc_checkIsSelfVolunteer() then
    self._btnGetVacation:SetShow(false)
    self._btnReleaseVacation:SetShow(false)
    return
  end
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local guildMemberCount = myGuildInfo:getMemberCount()
  for ii = 1, guildMemberCount do
    local guildMemberInfo = myGuildInfo:getMember(ii - 1)
    if nil ~= guildMemberInfo and true == guildMemberInfo:isSelf() then
      isVacation = guildMemberInfo:isVacation()
      if false == isVacation then
        self._btnGetVacation:SetShow(true)
        self._btnReleaseVacation:SetShow(false)
      else
        self._btnGetVacation:SetShow(false)
        self._btnReleaseVacation:SetShow(true)
      end
      return
    end
  end
end
function FGlobal_RequestApplyVacation()
  ToClient_RequestApplyVacation(true)
end
function FGlobal_RequestApplyReturnVacation()
  ToClient_RequestApplyVacation(false)
end
function HandleClicked_Guild_GetVacation(isGet)
  local self = GuildInfoPage
  if nil == isVacation then
    return
  end
  local messageData, msgTitle, msgContent
  if false == isVacation and true == isGet then
    msgTitle = PAGetString(Defines.StringSheet_GAME, "LUA_GET_VACATION_MESSAGE_WINDOW_TITLE")
    msgContent = PAGetString(Defines.StringSheet_GAME, "LUA_GET_VACATION_MESSAGE_WINDOW_CONTENT")
    messageData = {
      title = msgTitle,
      content = msgContent,
      functionYes = FGlobal_RequestApplyVacation,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageData)
  elseif true == isVacation and false == isGet then
    msgTitle = PAGetString(Defines.StringSheet_GAME, "LUA_RETURN_VACATION_MESSAGE_WINDOW_TITLE")
    msgContent = PAGetString(Defines.StringSheet_GAME, "LUA_RETURN_VACATION_MESSAGE_WINDOW_CONTENT")
    messageData = {
      title = msgTitle,
      content = msgContent,
      functionYes = FGlobal_RequestApplyReturnVacation,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageData)
  end
end
function FromClient_applyVacationResult(guildNo, userNo, result)
  if nil == Panel_Window_Guild then
    return
  end
  local self = GuildInfoPage
  PaGlobalFunc_GuildListInfoPage_Update()
  if nil ~= getSelfPlayer then
    if true == getSelfPlayer():get():isGuildMaster() then
      return
    end
    if getSelfPlayer():get():getUserNo() ~= userNo then
      return
    end
  end
  if true == result then
    self._btnGetVacation:SetShow(false)
    self._btnReleaseVacation:SetShow(true)
    isVacation = true
  elseif false == result then
    self._btnGetVacation:SetShow(true)
    self._btnReleaseVacation:SetShow(false)
    isVacation = false
  end
end
function HandleClickedGuild_PopUp()
  if nil == Panel_Window_Guild then
    return
  end
  if GuildInfoPage.checkPopUp:IsCheck() then
    Panel_Window_Guild:OpenUISubApp()
  else
    Panel_Window_Guild:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function HandleClickedGuildDel()
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    _PA_ASSERT(false, "ResponseGuildInviteForGuildGrade \236\151\144\236\132\156 \234\184\184\235\147\156 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local guildGrade = myGuildInfo:getGuildGrade()
  local messageboxData
  if true == getSelfPlayer():get():isGuildMaster() then
    if myGuildInfo:getMemberCount() <= 1 then
      messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_GUILD"),
        content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_GUILD_ASK"),
        functionYes = HandleClickedGuildDelContinue,
        functionNo = MessageBox_Empty_function,
        priority = UCT.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_CANT_DISPERSE"))
    end
  else
    local tempText
    if 0 == guildGrade then
      tempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLANLIST_CLANOUT_ASK")
    else
      tempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_WITHDRAW_GUILD_ASK") .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_MENTINFO")
    end
    messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_WITHDRAW_GUILD"),
      content = tempText,
      functionYes = HandleClickedGuildLeaveContinue,
      functionNo = MessageBox_Empty_function,
      priority = UCT.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
end
function HandleClickedChangeMark()
  messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ADDMARK_MESSAGEBOX_TITLE"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ADDMARK_MESSAGEBOX_TEXT"),
    functionYes = HandleClickedChangeMark_Continue,
    functionNo = MessageBox_Empty_function,
    priority = UCT.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "top")
end
function HandleClickedChangeMark_Continue()
  guildMarkUpdate(false)
end
function HandleClickedOpenSiegeGate()
  ToClient_RequestOpenSiegeGate()
end
function HandleClicked_TaxPayment()
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local taxValue = Int64toInt32(myGuildInfo:getAccumulateTax())
  local costValue = Int64toInt32(myGuildInfo:getAccumulateGuildHouseCost())
  if taxValue > 0 then
    local msgBox_Title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_GUILDLAWTAX")
    local msgBox_Content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_GUILDLAWTAX_ASK", "taxValue", taxValue)
    messageboxData = {
      title = msgBox_Title,
      content = msgBox_Content,
      functionYes = Guild_DoTaxPayment,
      functionNo = MessageBox_Empty_function,
      priority = UCT.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "middle")
  elseif costValue > 0 then
    local msgBox_Title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_HOUSECOSTS_PAY")
    local msgBox_Content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_HOUSECOSTS_PAY_ASK", "taxValue", costValue)
    messageboxData = {
      title = msgBox_Title,
      content = msgBox_Content,
      functionYes = Guild_DoGuildHouseCost,
      functionNo = MessageBox_Empty_function,
      priority = UCT.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "middle")
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UNPAID_CONFIRM"))
    return
  end
end
function Guild_DoTaxPayment()
  ToClient_PayComporateTax()
end
function Guild_DoGuildHouseCost()
  ToClient_PayGuildHouseCost()
end
function HandleClickedIncreaseMember()
  local skillPointInfo = ToClient_getSkillPointInfo(3)
  if skillPointInfo._remainPoint < 2 then
    local messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_NEED_GUILDSKILLPOINT") .. tostring(skillPointInfo._remainPoint) .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_EXPAND_POINT_LACK")
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_EXPAND_MAX_COUNT"),
      content = messageContent,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    local messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_EXPAND_MAX_COUNT_EXECUTE") .. tostring(skillPointInfo._remainPoint)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_EXPAND_MAX_COUNT"),
      content = messageContent,
      functionYes = Guild_IncreaseMember_Confirm,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "top")
  end
end
function Guild_IncreaseMember_Confirm()
  ToClient_RequestVaryJoinableGuildMemeberCount()
end
function HandleClickedIncreaseProtectMember()
  local skillPointInfo = ToClient_getSkillPointInfo(3)
  if 3 > skillPointInfo._remainPoint then
    local messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PROTECTADD_MOREPOINT") .. tostring(skillPointInfo._remainPoint) .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_EXPAND_POINT_LACK")
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PROTECTADD_TITLE"),
      content = messageContent,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    local messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PROTECTADD_POINT") .. tostring(skillPointInfo._remainPoint)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PROTECTADD_TITLE"),
      content = messageContent,
      functionYes = Guild_IncreaseProtectMember_Confirm,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "top")
  end
end
function Guild_IncreaseProtectMember_Confirm()
  ToClient_RequestVaryProtectGuildMemeberCount()
end
function GuildWarehouseOpen()
  warehouse_requestGuildWarehouseInfo()
end
function GuildInfoPage:UpdateData()
  if nil == Panel_Window_Guild then
    return
  end
  SetDATAByGuildGrade()
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  local myGuildAllianceChair = ToClient_GetMyGuildAlliancChairGuild()
  local myGuildAllianceCache
  if nil ~= myGuildAllianceChair then
    myGuildAllianceCache = myGuildAllianceChair
  else
    myGuildAllianceCache = myGuildInfo
  end
  if myGuildInfo ~= nil then
    local guildRank = myGuildInfo:getMemberCountLevel()
    local guildRankString = ""
    if 1 == guildRank then
      guildRankString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_SMALL")
    elseif 2 == guildRank then
      guildRankString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_MIDDLE")
    elseif 3 == guildRank then
      guildRankString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_BIG")
    elseif 4 == guildRank then
      guildRankString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_BIGGEST")
    end
    local skillPointInfo = ToClient_getSkillPointInfo(3)
    local skillPointPercent = string.format("%.0f", skillPointInfo._currentExp / skillPointInfo._nextLevelExp * 100)
    if 100 < tonumber(skillPointPercent) then
      skillPointPercent = 100
    end
    self._txtRGuildName:SetText(myGuildInfo:getName())
    self._txtRRank:SetText(guildRankString .. "(" .. myGuildInfo:getMemberCount() .. "/" .. myGuildInfo:getJoinableMemberCount() .. ")")
    self._txtRRank:SetSpanSize(self._txtRRank_Title:GetSpanSize().x + self._txtRRank_Title:GetTextSizeX() + 10, self._txtRRank:GetSpanSize().y)
    self._txtRMaster:SetText(myGuildInfo:getGuildMasterName())
    self._txtProtectValue:SetText(myGuildInfo:getProtectGuildMemberCount() .. "/" .. myGuildInfo:getAvaiableProtectGuildMemberCount())
    self._txtProtectValue:SetSpanSize(self._txtProtect:GetSpanSize().x + self._txtProtect:GetTextSizeX() + 10, self._txtProtectValue:GetSpanSize().y)
    self._txtGuildPointValue:SetText(tostring(skillPointInfo._remainPoint) .. "/" .. tostring(skillPointInfo._acquirePoint - 1))
    self._txtGuildPointPercent:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_SKILLPOINTPERCENT_SUBTITLE", "skillPointPercent", skillPointPercent))
    self._txtGuildPointPercent:SetSpanSize(self._txtGuildPointValue:GetSpanSize().x + self._txtGuildPointValue:GetTextSizeX() + 25, self._txtGuildPointPercent:GetSpanSize().y)
    self._txtGuildPointValue:SetSpanSize(self._txtGuildPoint:GetSpanSize().x + self._txtGuildPoint:GetTextSizeX() + 10, self._txtGuildPointValue:GetSpanSize().y)
    self._txtGuildPointPercent:SetSpanSize(self._txtGuildPointValue:GetSpanSize().x + self._txtGuildPointValue:GetTextSizeX() + 20, self._txtGuildPointPercent:GetSpanSize().y)
    local _btnProtectAddlength = self._txtProtectValue:GetPosX() + self._txtProtectValue:GetTextSizeX()
    local _btnIncreaseMemberlnegth = self._txtRRank:GetPosX() + self._txtRRank:GetTextSizeX()
    local longX = math.max(_btnProtectAddlength, _btnIncreaseMemberlnegth) + 20
    self._btnProtectAdd:SetPosX(longX)
    self._btnIncreaseMember:SetPosX(longX)
    local getGuildMoney = myGuildInfo:getGuildBusinessFunds_s64()
    self._txtGuildMoney:SetText(makeDotMoney(getGuildMoney))
    self._txtGuildMoney:SetSpanSize(self._txtGuildMoneyTitle:GetSpanSize().x + self._txtGuildMoneyTitle:GetTextSizeX() + 10, self._txtGuildMoney:GetSpanSize().y)
    self._txtGuildTerritoryValue:SetText("-")
    self._txtGuildTerritoryValue:SetSpanSize(self._txtGuildTerritoryTitle:GetSpanSize().x + self._txtGuildTerritoryTitle:GetTextSizeX() + 10, self._txtGuildTerritoryValue:GetSpanSize().y)
    self._txtGuildServantValue:SetText("-")
    self._txtGuildServantValue:SetSpanSize(self._txtGuildServantTitle:GetSpanSize().x + self._txtGuildServantTitle:GetTextSizeX() + 10, self._txtGuildServantValue:GetSpanSize().y)
    local guildArea1 = ""
    local territoryKey = ""
    local territoryWarName = ""
    if 0 < myGuildAllianceCache:getTerritoryCount() then
      for idx = 0, myGuildAllianceCache:getTerritoryCount() - 1 do
        territoryKey = myGuildAllianceCache:getTerritoryKeyAt(idx)
        if territoryKey >= 0 then
          local territoryInfoWrapper = getTerritoryInfoWrapperByIndex(territoryKey)
          if nil ~= territoryInfoWrapper then
            guildArea1 = territoryInfoWrapper:getTerritoryName()
            local territoryComma = ", "
            if "" == territoryWarName then
              territoryComma = ""
            end
            territoryWarName = territoryWarName .. territoryComma .. guildArea1
          end
          self._txtGuildTerritoryValue:SetText(territoryWarName)
        end
      end
    end
    local guildArea2 = ""
    local regionKey = ""
    local siegeWarName = ""
    if 0 < myGuildAllianceCache:getSiegeCount() then
      for idx = 0, myGuildAllianceCache:getSiegeCount() - 1 do
        regionKey = myGuildAllianceCache:getSiegeKeyAt(idx)
        if regionKey > 0 then
          local regionInfoWrapper = getRegionInfoWrapper(regionKey)
          if nil ~= regionInfoWrapper then
            guildArea2 = regionInfoWrapper:getAreaName()
            local siegeComma = ", "
            if "" == siegeWarName then
              siegeComma = ""
            end
            siegeWarName = siegeWarName .. siegeComma .. guildArea2
          end
          self._txtGuildTerritoryValue:SetText(siegeWarName)
        end
      end
    end
    if self._txtGuildTerritoryValue:GetTextSizeX() + 30 < self._txtGuildTerritoryValue:GetSizeX() then
      self._txtGuildTerritoryValue:SetIgnore(true)
    else
      self._txtGuildTerritoryValue:SetIgnore(false)
    end
    self._txtGuildTerritoryValue:addInputEvent("Mouse_On", "HandleClicked_TerritoryNameOnEvent( true )")
    self._txtGuildTerritoryValue:addInputEvent("Mouse_Out", "HandleClicked_TerritoryNameOnEvent( false )")
    local guildServantElephantCount = guildStable_getServantCount(UI_VT.Type_Elephant)
    local guildServantShipCount = guildStable_getServantCount(UI_VT.Type_SailingBoat)
    local guilServantValueCount = ""
    if guildServantElephantCount > 0 then
      guilServantValueCount = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_SERVANTCOUNT_ELEPHANT_ONLY", "guildServantElephantCount", guildServantElephantCount)
    end
    if guildServantShipCount > 0 then
      if guildServantElephantCount > 0 then
        guilServantValueCount = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_SERVANTCOUNT_GUILDVEHICLE_BOTH", "guilServantValueCount", guilServantValueCount, "guildServantShipCount", guildServantShipCount)
      else
        guilServantValueCount = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_SERVANTCOUNT_SAILBOAT_ONLY", "guildServantShipCount", guildServantShipCount)
      end
    end
    self._txtGuildServantValue:SetText(guilServantValueCount)
    if self._txtGuildServantValue:GetTextSizeX() + 30 < self._txtGuildServantValue:GetSizeX() then
      self._txtGuildServantValue:SetIgnore(true)
    else
      self._txtGuildServantValue:SetIgnore(false)
    end
    self._txtGuildServantValue:addInputEvent("Mouse_On", "HandleClicked_GuildServantCountOnEvent( true )")
    self._txtGuildServantValue:addInputEvent("Mouse_Out", "HandleClicked_GuildServantCountOnEvent( false )")
    if toInt64(0, 0) < myGuildInfo:getAccumulateTax() then
      self._txtUnpaidTax:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UNPAIDTAX", "getAccumulateTax", tostring(myGuildInfo:getAccumulateTax())))
    elseif toInt64(0, 0) < myGuildInfo:getAccumulateGuildHouseCost() then
      self._txtUnpaidTax:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UNPAIDTAX_HOUSE", "getAccumulateGuildHouseCost", tostring(myGuildInfo:getAccumulateGuildHouseCost())))
    end
    local isGuildMaster = getSelfPlayer():get():isGuildMaster()
    if true == isGuildMaster then
      if 0 == myGuildInfo:getGuildGrade() then
      end
      local skillPointInfo = ToClient_getSkillPointInfo(3)
      local isEnable = ToClient_GetGuildSkillPointPerIncreaseMember() <= skillPointInfo._remainPoint
      self._btnIncreaseMember:SetMonoTone(not isEnable)
    elseif 0 == myGuildInfo:getGuildGrade() then
    end
    local isSet = setGuildTextureByGuildNo(myGuildInfo:getGuildNo_s64(), GuildInfoPage._iconGuildMark)
    if false == isSet then
      GuildInfoPage._iconGuildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(GuildInfoPage._iconGuildMark, 183, 1, 188, 6)
      GuildInfoPage._iconGuildMark:getBaseTexture():setUV(x1, y1, x2, y2)
      GuildInfoPage._iconGuildMark:setRenderTexture(GuildInfoPage._iconGuildMark:getBaseTexture())
    else
      GuildInfoPage._iconGuildMark:getBaseTexture():setUV(0, 0, 1, 1)
      GuildInfoPage._iconGuildMark:setRenderTexture(GuildInfoPage._iconGuildMark:getBaseTexture())
    end
  else
    HandleClickedGuildHideButton()
  end
end
function HandleClickedRelease()
  local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_REGION_EXTRICATE_MESSAGE_DESC")
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_REGION_EXTRICATE_NAME"),
    content = contentString,
    functionYes = ReleaseAccept,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function ReleaseAccept()
  ToClient_RequestReleaseSiege()
end
local GuildLetsWarPage = {}
function GuildLetsWarPage:initialize()
  if nil == Panel_Guild_Declaration then
    return
  end
  self._letsWarBG = UI.getChildControl(Panel_Guild_Declaration, "Static_Menu_BG_2")
  self._txtLetsWarTitle = UI.getChildControl(Panel_Guild_Declaration, "StaticText_Title")
  self._btnLetsWarDoWar = UI.getChildControl(Panel_Guild_Declaration, "Button_LetsWar")
  self._editLetsWarInputName = UI.getChildControl(Panel_Guild_Declaration, "Edit_InputGuild")
  self._txtLetsWarHelp = UI.getChildControl(Panel_Guild_Declaration, "StaticText_WarDesc_help")
  self._btnCose = UI.getChildControl(Panel_Guild_Declaration, "Button_Close")
  function self:SetShow(isShow)
    self._letsWarBG:SetShow(isShow)
    self._btnLetsWarDoWar:SetShow(isShow)
    self._editLetsWarInputName:SetShow(isShow)
    self._txtLetsWarHelp:SetShow(isShow)
  end
  function self:GetShow()
    return self._letsWarBG:GetShow()
  end
  self:SetShow(false)
  self._txtLetsWarHelp:SetTextMode(UI_TM.eTextMode_AutoWrap)
  if CppEnums.GuildWarType.GuildWarType_Normal == ToClient_GetGuildWarType() then
    self._txtLetsWarHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_LETSWARHELP"))
  elseif CppEnums.GuildWarType.GuildWarType_Both == ToClient_GetGuildWarType() then
    self._txtLetsWarHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_LETSWARHELP_JP"))
  else
    self._txtLetsWarHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_LETSWARHELP"))
  end
  Panel_Guild_Declaration:SetSize(Panel_Guild_Declaration:GetSizeX(), self._txtLetsWarHelp:GetTextSizeY() + 10 + self._txtLetsWarTitle:GetSizeY() + self._btnLetsWarDoWar:GetSizeY() + 50)
  self._letsWarBG:SetSize(self._letsWarBG:GetSizeX(), Panel_Guild_Declaration:GetSizeY() - self._txtLetsWarTitle:GetSizeY() - 8)
  self._txtLetsWarHelp:SetSize(self._txtLetsWarHelp:GetSizeX(), self._txtLetsWarHelp:GetTextSizeY() + 10)
  self._btnLetsWarDoWar:addInputEvent("Mouse_LUp", "HandleClickedLetsWar()")
  self._editLetsWarInputName:addInputEvent("Mouse_LUp", "HandleClickedLetsWarEditName()")
  self._btnCose:addInputEvent("Mouse_LUp", "HandleClicked_LetsWarHide()")
  self._editLetsWarInputName:RegistReturnKeyEvent("HandleClickedLetsWar()")
end
function HandleClickedLetsWar()
  if nil == Panel_Guild_Declaration then
    return
  end
  local guildName = GuildLetsWarPage._editLetsWarInputName:GetEditText()
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local myGuildName = myGuildInfo:getName()
  local accumulateTax_s32 = Int64toInt32(myGuildInfo:getAccumulateTax())
  local accumulateCost_s32 = Int64toInt32(myGuildInfo:getAccumulateGuildHouseCost())
  local close_function = function()
    CheckChattingInput()
  end
  if accumulateTax_s32 > 0 or accumulateCost_s32 > 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_TAXFIRST"))
    ClearFocusEdit()
    close_function()
    return
  end
  if guildName == myGuildName then
    local messageboxData = {
      title = "",
      content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_LETSWARFAIL"),
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  elseif CppEnums.GuildWarType.GuildWarType_Both == ToClient_GetGuildWarType() then
    local messageboxData = {
      title = "",
      content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DECLAREWAR_DECREASEMONEY"),
      functionYes = ConfirmDeclareGuildWar,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, nil, nil)
  else
    ConfirmDeclareGuildWar()
  end
  ClearFocusEdit()
  close_function()
end
function ConfirmDeclareGuildWar()
  if nil == Panel_Guild_Declaration then
    return
  end
  local guildName = GuildLetsWarPage._editLetsWarInputName:GetEditText()
  ToClient_RequestDeclareGuildWar(0, guildName, false)
  GuildLetsWarPage._editLetsWarInputName:SetEditText("", true)
end
function HandleClickedLetsWarEditName()
  if nil == Panel_Guild_Declaration then
    return
  end
  SetFocusEdit(GuildLetsWarPage._editLetsWarInputName)
  GuildLetsWarPage._editLetsWarInputName:SetEditText("", true)
end
function FGlobal_CheckGuildLetsWarUiEdit(targetUI)
  if nil == Panel_Window_Guild then
    return false
  end
  return nil ~= targetUI and targetUI:GetKey() == GuildLetsWarPage._editLetsWarInputName:GetKey()
end
function FGlobal_GuildLetsWarClearFocusEdit()
  if nil == Panel_Guild_Declaration then
    return
  end
  GuildLetsWarPage._editLetsWarInputName:SetText("", true)
  ClearFocusEdit()
  CheckChattingInput()
end
function GuildLetsWarPage:UpdateData()
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  if true == isGuildMaster or true == isGuildSubMaster then
    self:SetShow(true)
  else
    self:SetShow(false)
  end
end
function HandleClicked_LetsWarShow()
  if nil == Panel_Guild_Declaration then
    return
  end
  Panel_Guild_Declaration:SetShow(true)
end
function HandleClicked_LetsWarHide()
  if nil == Panel_Guild_Declaration then
    return
  end
  Panel_Guild_Declaration:SetShow(false)
end
local GuildWarInfoPage = {
  slotMaxCount = 4,
  _listCount = 0,
  _startIndex = 0
}
function GuildWarInfoPage:initialize()
  if nil == Panel_Window_Guild then
    return
  end
  local constStartY = 450
  self._area_GuildWarInfo = UI.getChildControl(Panel_Window_Guild, "Static_WarArea")
  self._area_GuildWarInfo:SetAlpha(0.5)
  self._list2 = UI.getChildControl(self._area_GuildWarInfo, "List2_WarInfo")
  self._list2_2 = UI.getChildControl(self._area_GuildWarInfo, "List2_WarInfo2")
  self._list2_2:SetShow(false)
  self._txtNoWar = UI.getChildControl(self._area_GuildWarInfo, "StaticText_NoWar")
  self._btnWarList1 = UI.getChildControl(self._area_GuildWarInfo, "RadioButton_WarList1")
  self._btnWarList2 = UI.getChildControl(self._area_GuildWarInfo, "RadioButton_WarList2")
  self._btnDeclaration = UI.getChildControl(self._area_GuildWarInfo, "Button_Declaration")
  self._txt_Title = UI.getChildControl(self._area_GuildWarInfo, "StaticText_WarInfo_Title")
  self._list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_GuildWarInfo_List2Event")
  self._list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._list2_2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_GuildWarInfo2_List2Event")
  self._list2_2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._btnDeclaration:ComputePos()
  self._btnWarList1:addInputEvent("Mouse_LUp", "HandleClicked_WarInfoUpdate( " .. 1 .. " )")
  self._btnWarList2:addInputEvent("Mouse_LUp", "HandleClicked_WarInfoUpdate( " .. 2 .. " )")
  self._btnDeclaration:addInputEvent("Mouse_LUp", "HandleClicked_LetsWarShow()")
  self._txt_Title:addInputEvent("Mouse_On", "GuildSimplTooltips(true, 12)")
  self._txt_Title:addInputEvent("Mouse_Out", "GuildSimplTooltips(false)")
end
function PaGlobal_GuildWarInfo_List2Event(contents, key)
  if nil == Panel_Window_Guild then
    return
  end
  local idx = Int64toInt32(key)
  local self = GuildWarInfoPage
  self._txtNoWar:SetSpanSize(30, 120)
  self._txtNoWar:ComputePos()
  self._txtNoWar:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._txtNoWar:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_NOWAR"))
  self._txtNoWar:SetShow(false)
  local isLeftIdx = 2 * idx
  local isRightIdx = 2 * idx + 1
  local isLeftChk = nil ~= ToClient_GetWarringGuildListAt(isLeftIdx)
  local isRightChk = nil ~= ToClient_GetWarringGuildListAt(isRightIdx)
  local isListCount = ToClient_GetWarringGuildListCount()
  if isRightIdx >= isListCount then
    isRightChk = false
  end
  if 0 == isListCount then
    self._txtNoWar:SetShow(true)
  end
  local LeftGuildBG = UI.getChildControl(contents, "Static_Left_WarBG")
  local LeftGuildIconBG = UI.getChildControl(contents, "Static_Left_GuildIconBG")
  local LeftGuildIcon = UI.getChildControl(contents, "Static_Left_GuildIcon")
  local LeftGuildName = UI.getChildControl(contents, "StaticText_Left_GuildName")
  local LeftWarScore = UI.getChildControl(contents, "StaticText_Left_WarScore")
  local LeftBattleScore = UI.getChildControl(contents, "StaticText_Left_GuildBattle")
  local LeftWarIcon = UI.getChildControl(contents, "Static_Left_WarIcon")
  local Left_Btn_WarStop = UI.getChildControl(contents, "Button_Left_WarStop")
  local Left_Btn_GuildBattle = UI.getChildControl(contents, "Button_Left_GuildBattle")
  LeftGuildBG:SetShow(isLeftChk)
  LeftGuildIconBG:SetShow(isLeftChk)
  LeftGuildIcon:SetShow(isLeftChk)
  LeftGuildName:SetShow(isLeftChk)
  LeftWarScore:SetShow(isLeftChk)
  LeftBattleScore:SetShow(isLeftChk)
  LeftWarIcon:SetShow(false)
  Left_Btn_WarStop:SetShow(isLeftChk)
  Left_Btn_GuildBattle:SetShow(isLeftChk)
  local RightGuildBG = UI.getChildControl(contents, "Static_Right_WarBG")
  local RightGuildIconBG = UI.getChildControl(contents, "Static_Right_GuildIconBG")
  local RightGuildIcon = UI.getChildControl(contents, "Static_Right_GuildIcon")
  local RightGuildName = UI.getChildControl(contents, "StaticText_Right_GuildName")
  local RightWarScore = UI.getChildControl(contents, "StaticText_Right_WarScore")
  local RightBattleScore = UI.getChildControl(contents, "StaticText_Right_GuildBattle")
  local RightWarIcon = UI.getChildControl(contents, "Static_Right_WarIcon")
  local Right_Btn_WarStop = UI.getChildControl(contents, "Button_Right_WarStop")
  local Right_Btn_GuildBattle = UI.getChildControl(contents, "Button_Right_GuildBattle")
  RightGuildBG:SetShow(isRightChk)
  RightGuildIconBG:SetShow(isRightChk)
  RightGuildIcon:SetShow(isRightChk)
  RightGuildName:SetShow(isRightChk)
  RightWarScore:SetShow(isRightChk)
  RightBattleScore:SetShow(isRightChk)
  RightWarIcon:SetShow(false)
  Right_Btn_WarStop:SetShow(isRightChk)
  Right_Btn_GuildBattle:SetShow(isRightChk)
  if isLeftChk then
    local isSet = false
    local isGuildWarListInfo = ToClient_GetWarringGuildListAt(isLeftIdx)
    local guildNo_s64 = isGuildWarListInfo:getGuildNo()
    if isGuildWarListInfo:isExist() then
      isSet = setGuildTextureByGuildNo(guildNo_s64, LeftGuildIcon)
    end
    if false == isSet then
    else
      LeftGuildIcon:getBaseTexture():setUV(0, 0, 1, 1)
      LeftGuildIcon:setRenderTexture(LeftGuildIcon:getBaseTexture())
      LeftGuildIcon:SetPosX(15)
      LeftGuildIcon:SetPosY(11)
    end
    if isGuildWarListInfo:isExist() then
      LeftGuildName:SetMonoTone(false)
      LeftGuildName:SetText(isGuildWarListInfo:getGuildName())
    else
      LeftGuildName:SetMonoTone(true)
      LeftGuildName:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DISSOLUTION"))
    end
    local guildWarKillScore = tostring(Uint64toUint32(isGuildWarListInfo:getKillCount()))
    local guildWarDeathScore = tostring(Uint64toUint32(isGuildWarListInfo:getDeathCount()))
    LeftWarScore:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_GUILDWARSCORE", "killCount", guildWarKillScore, "deathCount", guildWarDeathScore))
    LeftBattleScore:EraseAllEffect()
    if isContentsGuildDuel then
      if ToClient_IsGuildDuelingGuild(guildNo_s64) then
        local guildDuelKillScore = tostring(ToClient_GetGuildDuelKillCount(guildNo_s64))
        local guildDuelDeathScore = tostring(ToClient_GetGuildDuelDeathCount(guildNo_s64))
        LeftBattleScore:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_GUILDDUELSCORE", "killCount", guildDuelKillScore, "deathCount", guildDuelDeathScore))
        local deadline = ToClient_GetGuildDuelDeadline_s64(guildNo_s64)
        if deadline < toInt64(0, 3600) then
          LeftBattleScore:AddEffect("UI_Quest_Complete_GoldAura", true, 0, 0)
        end
      else
        LeftBattleScore:addInputEvent("Mouse_On", "")
        LeftBattleScore:addInputEvent("Mouse_Out", "")
        LeftBattleScore:SetShow(false)
      end
    end
    Left_Btn_WarStop:addInputEvent("Mouse_LUp", "HandleClickedStopWar(" .. isLeftIdx .. ")")
    Left_Btn_WarStop:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( " .. 9 .. ", true, " .. idx .. ", true )")
    Left_Btn_WarStop:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( " .. 9 .. ", false, " .. idx .. ", true )")
    Left_Btn_GuildBattle:addInputEvent("Mouse_LUp", "")
    if isContentsGuildDuel then
      LeftBattleScore:addInputEvent("Mouse_On", "HandleOnOut_GuildDuelInfo_Tooltip( true, " .. isLeftIdx .. ")")
      LeftBattleScore:addInputEvent("Mouse_Out", "HandleOnOut_GuildDuelInfo_Tooltip( false, " .. isLeftIdx .. ")")
    end
    local isGuildMaster = getSelfPlayer():get():isGuildMaster()
    local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
    if true == isGuildMaster or true == isGuildSubMaster then
      Left_Btn_WarStop:SetShow(true)
      Left_Btn_GuildBattle:SetShow(isContentsGuildDuel)
    else
      Left_Btn_WarStop:SetShow(false)
      Left_Btn_GuildBattle:SetShow(false)
    end
  end
  if isRightChk then
    local isSet = false
    local isGuildWarListInfo = ToClient_GetWarringGuildListAt(isRightIdx)
    local guildNo_s64 = isGuildWarListInfo:getGuildNo()
    if isGuildWarListInfo:isExist() then
      isSet = setGuildTextureByGuildNo(guildNo_s64, RightGuildIcon)
    end
    if false == isSet then
      RightGuildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(RightGuildIcon, 183, 1, 188, 6)
      RightGuildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
      RightGuildIcon:setRenderTexture(RightGuildIcon:getBaseTexture())
    else
      RightGuildIcon:getBaseTexture():setUV(0, 0, 1, 1)
      RightGuildIcon:setRenderTexture(RightGuildIcon:getBaseTexture())
    end
    if isGuildWarListInfo:isExist() then
      RightGuildName:SetMonoTone(false)
      RightGuildName:SetText(isGuildWarListInfo:getGuildName())
    else
      RightGuildName:SetMonoTone(true)
      RightGuildName:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DISSOLUTION"))
    end
    local guildWarKillScore = tostring(Uint64toUint32(isGuildWarListInfo:getKillCount()))
    local guildWarDeathScore = tostring(Uint64toUint32(isGuildWarListInfo:getDeathCount()))
    RightWarScore:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_GUILDWARSCORE", "killCount", guildWarKillScore, "deathCount", guildWarDeathScore))
    RightBattleScore:EraseAllEffect()
    if isContentsGuildDuel then
      if ToClient_IsGuildDuelingGuild(guildNo_s64) then
        local guildDuelKillScore = tostring(ToClient_GetGuildDuelKillCount(guildNo_s64))
        local guildDuelDeathScore = tostring(ToClient_GetGuildDuelDeathCount(guildNo_s64))
        RightBattleScore:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_GUILDDUELSCORE", "killCount", guildDuelKillScore, "deathCount", guildDuelDeathScore))
        RightBattleScore:SetPosX(RightWarScore:GetPosX() + RightWarScore:GetTextSizeX() + 10)
        local deadline = ToClient_GetGuildDuelDeadline_s64(guildNo_s64)
        if deadline < toInt64(0, 3600) then
          RightBattleScore:AddEffect("UI_Quest_Complete_GoldAura", true, 0, 0)
        end
      else
        RightBattleScore:addInputEvent("Mouse_On", "")
        RightBattleScore:addInputEvent("Mouse_Out", "")
        RightBattleScore:SetShow(false)
      end
    end
    Right_Btn_WarStop:addInputEvent("Mouse_LUp", "HandleClickedStopWar(" .. isRightIdx .. ")")
    Right_Btn_WarStop:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( " .. 9 .. ", true, " .. idx .. ", false )")
    Right_Btn_WarStop:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( " .. 9 .. ", false, " .. idx .. ", false )")
    Right_Btn_GuildBattle:addInputEvent("Mouse_LUp", "")
    if isContentsGuildDuel then
      RightBattleScore:addInputEvent("Mouse_On", "HandleOnOut_GuildDuelInfo_Tooltip( true, " .. isRightIdx .. ")")
      RightBattleScore:addInputEvent("Mouse_Out", "HandleOnOut_GuildDuelInfo_Tooltip( false, " .. isRightIdx .. ")")
    end
    local isGuildMaster = getSelfPlayer():get():isGuildMaster()
    local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
    if true == isGuildMaster or true == isGuildSubMaster then
      Right_Btn_WarStop:SetShow(true)
      Right_Btn_GuildBattle:SetShow(isContentsGuildDuel)
    else
      Right_Btn_WarStop:SetShow(false)
      Right_Btn_GuildBattle:SetShow(false)
    end
  end
end
function PaGlobal_GuildWarInfo2_List2Event(contents, key)
  if nil == Panel_Window_Guild then
    return
  end
  local idx = Int64toInt32(key)
  local self = GuildWarInfoPage
  self._txtNoWar:SetSpanSize(30, 120)
  self._txtNoWar:ComputePos()
  self._txtNoWar:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._txtNoWar:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_NOWAR"))
  self._txtNoWar:SetShow(false)
  local isLeftIdx = 2 * idx
  local isRightIdx = 2 * idx + 1
  local isLeftChk = nil ~= ToClient_GetDeclareGuildWarToMyGuild_s64(isLeftIdx)
  local isRightChk = nil ~= ToClient_GetDeclareGuildWarToMyGuild_s64(isRightIdx)
  local isListCount = ToClient_GetCountDeclareGuildWarToMyGuild()
  if isRightIdx >= isListCount then
    isRightChk = false
  end
  if 0 == isListCount then
    self._txtNoWar:SetShow(true)
  end
  local Left_WarBG = UI.getChildControl(contents, "Static_Left_WarBG")
  local Left_GuildIconBG = UI.getChildControl(contents, "Static_Left_EnemyGuild_IconBG")
  local Left_GuildIcon = UI.getChildControl(contents, "Static_Left_GuildIcon")
  local Left_GuildName = UI.getChildControl(contents, "StaticText_Left_GuildName")
  local Left_GuildMaster = UI.getChildControl(contents, "StaticText_Left_GuildMaster")
  Left_WarBG:SetShow(isLeftChk)
  Left_GuildIconBG:SetShow(isLeftChk)
  Left_GuildIcon:SetShow(isLeftChk)
  Left_GuildName:SetShow(isLeftChk)
  Left_GuildMaster:SetShow(isLeftChk)
  local Right_WarBG = UI.getChildControl(contents, "Static_Right_WarBG")
  local Right_GuildIconBG = UI.getChildControl(contents, "Static_Right_EnemyGuild_IconBG")
  local Right_GuildIcon = UI.getChildControl(contents, "Static_Right_GuildIcon")
  local Right_GuildName = UI.getChildControl(contents, "StaticText_Right_GuildName")
  local Right_GuildMaster = UI.getChildControl(contents, "StaticText_Right_GuildMaster")
  Right_WarBG:SetShow(isRightChk)
  Right_GuildIconBG:SetShow(isRightChk)
  Right_GuildIcon:SetShow(isRightChk)
  Right_GuildName:SetShow(isRightChk)
  Right_GuildMaster:SetShow(isRightChk)
  if isLeftChk then
    local guildNo = ToClient_GetDeclareGuildWarToMyGuild_s64(isLeftIdx)
    local guildWrapper = ToClient_GetGuildInfoWrapperByGuildNo(guildNo)
    self._txtNoWar:SetSpanSize(30, 120)
    self._txtNoWar:ComputePos()
    self._txtNoWar:SetTextMode(UI_TM.eTextMode_AutoWrap)
    self._txtNoWar:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_NOWAR"))
    self._txtNoWar:SetShow(false)
    if nil ~= guildWrapper then
      local guildNo_s64 = tostring(guildWrapper:getGuildNo_s64())
      local isSet = setGuildTextureByGuildNo(guildWrapper:getGuildNo_s64(), Left_GuildIcon)
      if false == isSet then
        Left_GuildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(Left_GuildIcon, 183, 1, 188, 6)
        Left_GuildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
        Left_GuildIcon:setRenderTexture(Left_GuildIcon:getBaseTexture())
      else
        Left_GuildIcon:getBaseTexture():setUV(0, 0, 1, 1)
        Left_GuildIcon:setRenderTexture(Left_GuildIcon:getBaseTexture())
      end
      Left_GuildName:SetText(guildWrapper:getName())
      Left_GuildMaster:SetText(guildWrapper:getGuildMasterName())
    end
  end
  if isRightChk then
    local guildNo = ToClient_GetDeclareGuildWarToMyGuild_s64(isRightIdx)
    local guildWrapper = ToClient_GetGuildInfoWrapperByGuildNo(guildNo)
    self._txtNoWar:SetSpanSize(30, 120)
    self._txtNoWar:ComputePos()
    self._txtNoWar:SetTextMode(UI_TM.eTextMode_AutoWrap)
    self._txtNoWar:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_NOWAR"))
    self._txtNoWar:SetShow(false)
    if nil ~= guildWrapper then
      local guildNo_s64 = tostring(guildWrapper:getGuildNo_s64())
      local isSet = setGuildTextureByGuildNo(guildWrapper:getGuildNo_s64(), Right_GuildIcon)
      if false == isSet then
        Right_GuildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(Right_GuildIcon, 183, 1, 188, 6)
        Right_GuildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
        Right_GuildIcon:setRenderTexture(Right_GuildIcon:getBaseTexture())
      else
        Right_GuildIcon:getBaseTexture():setUV(0, 0, 1, 1)
        Right_GuildIcon:setRenderTexture(Right_GuildIcon:getBaseTexture())
      end
      Right_GuildName:SetText(guildWrapper:getName())
      Right_GuildMaster:SetText(guildWrapper:getGuildMasterName())
    end
  end
end
function HandleClickedStopWar(index)
  if nil == index then
    return
  end
  local function ExecuteStopGuildWar()
    ToClient_RequestStopGuildWar(index)
  end
  local guildWarInfo = ToClient_GetWarringGuildListAt(index)
  local guildExit = guildWarInfo:isExist()
  local guildName = guildWarInfo:getGuildName()
  local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_STOPGUILDWAR_MSG_DEFAULT")
  if guildExit then
    contentString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_STOPGUILDWAR_MSG_GUILDNAME", "guildName", tostring(guildName))
  else
    contentString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_STOPGUILDWAR_MSG_NOGUILD")
  end
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = contentString,
    functionYes = ExecuteStopGuildWar,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function GuildWarInfoPage:UpdateData()
  if nil == Panel_Window_Guild then
    return
  end
  ToClient_RequestDeclareGuildWarToMyGuild()
  if self._btnWarList1:IsCheck() then
    self._list2:SetShow(true)
    self._list2_2:SetShow(false)
    self._list2:getElementManager():clearKey()
    local isListCount = ToClient_GetWarringGuildListCount()
    local isList2thCount = math.ceil(isListCount / 2)
    for index = 0, isList2thCount - 1 do
      self._list2:getElementManager():pushKey(index)
    end
    if 0 == isListCount then
      self._txtNoWar:SetShow(true)
    end
  else
    self._list2:SetShow(false)
    self._list2_2:SetShow(true)
    self._list2_2:getElementManager():clearKey()
    local isListCount = ToClient_GetCountDeclareGuildWarToMyGuild()
    local isList2thCount = math.ceil(isListCount / 2)
    for index = 0, isList2thCount - 1 do
      self._list2_2:getElementManager():pushKey(index)
    end
  end
end
local warInfoTypeIsMine = true
function HandleClicked_WarInfoUpdate(typeNo)
  local self = GuildWarInfoPage
  if 1 == typeNo then
    if true == warInfoTypeIsMine then
      return
    end
    warInfoTypeIsMine = true
  else
    if false == warInfoTypeIsMine then
      return
    end
    warInfoTypeIsMine = false
  end
  self:UpdateData()
end
GuildManager = {
  _doHaveSeige = false,
  _isResize = true,
  _savePos = float2(0, 0)
}
local guildManagerButtonPositionList = {}
function GuildManager:initialize()
  if nil == Panel_Window_Guild then
    return
  end
  self.mainBtn_Main = UI.getChildControl(Panel_Window_Guild, "Button_Tab_Main")
  self.mainBtn_History = UI.getChildControl(Panel_Window_Guild, "Button_Tab_History")
  self.mainBtn_Info = UI.getChildControl(Panel_Window_Guild, "Button_Tab_GuildInfo")
  self.mainBtn_Quest = UI.getChildControl(Panel_Window_Guild, "Button_Tab_GuildQuest")
  self.mainBtn_Tree = UI.getChildControl(Panel_Window_Guild, "Button_Tab_Skill")
  self.mainBtn_Warfare = UI.getChildControl(Panel_Window_Guild, "Button_Tab_Warfare")
  self.mainBtn_Recruitment = UI.getChildControl(Panel_Window_Guild, "Button_Tab_Recruitment")
  self.mainBtn_CraftInfo = UI.getChildControl(Panel_Window_Guild, "Button_Tab_CraftInfo")
  self.mainBtn_GuildBattle = UI.getChildControl(Panel_Window_Guild, "Button_Tab_GuildBattle")
  self.mainBtn_GuildManufacture = UI.getChildControl(Panel_Window_Guild, "Button_Tab_GuildManufacture")
  self.mainBtn_GuildAlliance = UI.getChildControl(Panel_Window_Guild, "Button_Tab_GuildAlliance")
  self.mainBtn_GuildAllianceList = UI.getChildControl(Panel_Window_Guild, "Button_Tab_AllianceList")
  self.mainBtn_VolunteerList = UI.getChildControl(Panel_Window_Guild, "Button_Tab_VolunteerList")
  self.closeButton = UI.getChildControl(Panel_Window_Guild, "Button_Close")
  self._buttonQuestion = UI.getChildControl(Panel_Window_Guild, "Button_Question")
  self.mainBtn_Main:addInputEvent("Mouse_LUp", "GuildManager:TabToggle( 99 )")
  self.mainBtn_History:addInputEvent("Mouse_LUp", "GuildManager:TabToggle( 0 )")
  self.mainBtn_Info:addInputEvent("Mouse_LUp", "GuildManager:TabToggle( 1 )")
  self.mainBtn_Quest:addInputEvent("Mouse_LUp", "GuildManager:TabToggle( 2 )")
  self.mainBtn_Tree:addInputEvent("Mouse_LUp", "GuildManager:TabToggle( 3 )")
  self.mainBtn_Warfare:addInputEvent("Mouse_LUp", "GuildManager:TabToggle( 4 )")
  self.mainBtn_Recruitment:addInputEvent("Mouse_LUp", "GuildManager:TabToggle( 5 )")
  self.mainBtn_CraftInfo:addInputEvent("Mouse_LUp", "GuildManager:TabToggle( 6 )")
  self.mainBtn_GuildBattle:addInputEvent("Mouse_LUp", "GuildManager:TabToggle( 7 )")
  self.mainBtn_GuildManufacture:addInputEvent("Mouse_LUp", "GuildManager:TabToggle( 8 )")
  self.mainBtn_GuildAlliance:addInputEvent("Mouse_LUp", "GuildManager:TabToggle( 9 )")
  self.mainBtn_GuildAllianceList:addInputEvent("Mouse_LUp", "GuildManager:TabToggle( 10 )")
  self.mainBtn_VolunteerList:addInputEvent("Mouse_LUp", "GuildManager:TabToggle( 11 )")
  self.closeButton:addInputEvent("Mouse_LUp", "HandleClickedGuildHideButton()")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelGuild\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelGuild\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelGuild\", \"false\")")
  self.mainBtn_Main:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 99, true )")
  self.mainBtn_History:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 5, true )")
  self.mainBtn_Info:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 0, true )")
  self.mainBtn_Quest:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 1, true )")
  self.mainBtn_Tree:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 2, true )")
  self.mainBtn_Warfare:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 3, true )")
  self.mainBtn_Recruitment:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 4, true )")
  self.mainBtn_CraftInfo:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 11, true )")
  self.mainBtn_GuildBattle:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 12, true )")
  self.mainBtn_GuildManufacture:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 13, true )")
  self.mainBtn_GuildAlliance:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 14, true )")
  self.mainBtn_GuildAllianceList:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 15, true )")
  self.mainBtn_VolunteerList:addInputEvent("Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 16, true )")
  self.mainBtn_Main:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 99, false )")
  self.mainBtn_History:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 5, false )")
  self.mainBtn_Info:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 0, false )")
  self.mainBtn_Quest:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 1, false )")
  self.mainBtn_Tree:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 2, false )")
  self.mainBtn_Warfare:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 3, false )")
  self.mainBtn_Recruitment:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 4, false )")
  self.mainBtn_CraftInfo:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 11, false )")
  self.mainBtn_GuildBattle:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 12, false )")
  self.mainBtn_GuildManufacture:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 13, false )")
  self.mainBtn_GuildAlliance:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 14, false )")
  self.mainBtn_GuildAllianceList:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 15, false )")
  self.mainBtn_VolunteerList:addInputEvent("Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 16, false )")
  if true == _ContentsGroup_GuildManufacture then
    self.mainBtn_GuildManufacture:SetShow(true)
    self.mainBtn_CraftInfo:SetShow(false)
  else
    self.mainBtn_GuildManufacture:SetShow(false)
    self.mainBtn_CraftInfo:SetShow(true)
  end
  if true == _ContentsGroup_guildAlliance then
    self.mainBtn_GuildAlliance:SetShow(true)
    self.mainBtn_GuildAllianceList:SetShow(true)
  else
    self.mainBtn_GuildAlliance:SetShow(false)
    self.mainBtn_GuildAllianceList:SetShow(false)
  end
  PaGlobal_CheckVolunteerList()
  GuildInfoPage:initialize()
  GuildLetsWarPage:initialize()
  GuildWarInfoPage:initialize()
  guildManagerButtonPositionList[0] = self.mainBtn_Main:GetPosX()
  guildManagerButtonPositionList[1] = self.mainBtn_Info:GetPosX()
  guildManagerButtonPositionList[2] = self.mainBtn_Quest:GetPosX()
  guildManagerButtonPositionList[3] = self.mainBtn_Tree:GetPosX()
  guildManagerButtonPositionList[4] = self.mainBtn_Warfare:GetPosX()
  guildManagerButtonPositionList[5] = self.mainBtn_History:GetPosX()
  guildManagerButtonPositionList[6] = self.mainBtn_Recruitment:GetPosX()
  guildManagerButtonPositionList[7] = self.mainBtn_GuildManufacture:GetPosX()
  guildManagerButtonPositionList[8] = self.mainBtn_GuildBattle:GetPosX()
  guildManagerButtonPositionList[9] = self.mainBtn_GuildAlliance:GetPosX()
  guildManagerButtonPositionList[10] = self.mainBtn_GuildAllianceList:GetPosX()
  guildManagerButtonPositionList[11] = self.mainBtn_VolunteerList:GetPosX()
  Panel_Window_Guild:SetShow(false)
  Panel_Window_Guild:setGlassBackground(true)
  Panel_Window_Guild:SetDragAll(true)
  GuildManager.mainBtn_GuildBattle:SetShow(isGuildBattle)
  GuildManager:registEventHandler()
  PaGlobal_SeasonTexture_SetPanel(Panel_Window_Guild)
end
function GuildManager:registEventHandler()
  if nil == Panel_Window_Guild then
    return
  end
  Panel_Window_Guild:RegisterCloseLuaFunc(PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Escape
  }), "PanelCloseFunc_Guild()")
  Panel_Window_Guild:RegisterShowEventFunc(true, "guild_ShowAni()")
  Panel_Window_Guild:RegisterShowEventFunc(false, "guild_HideAni()")
end
function GuildManager:registMessageHandler()
  if false == _ContentsGroup_RenewUI_Guild then
    registerEvent("FromClient_ResponseGuildUpdate", "FromClient_ResponseGuildUpdate")
    registerEvent("ResponseGuild_invite", "FromClient_ResponseGuild_invite")
    registerEvent("ResponseGuild_refuse", "FromClient_ResponseGuild_refuse")
    registerEvent("EventChangeGuildInfo", "FromClient_EventActorChangeGuildInfo")
    registerEvent("FromClient_UpdateGuildContract", "FromClient_ResponseUpdateGuildContract")
    registerEvent("FromClient_NotifyGuildMessage", "FromClient_NotifyGuildMessage")
    registerEvent("FromClient_GuildInviteForGuildGrade", "FromClient_ResponseGuildInviteForGuildGrade")
    registerEvent("FromClient_ResponseDeclareGuildWarToMyGuild ", "FromClient_ResponseDeclareGuildWarToMyGuild")
    registerEvent("FromClient_RequestGuildWar", "FromClient_RequestGuildWar")
    registerEvent("FromClient_ResponseGuildNotice", "FromClient_ResponseGuildNotice")
    registerEvent("FromClient_GuildListUpdate", "FromClient_GuildListUpdate")
    registerEvent("FromClient_resetGuildVolunteerMember", "FromClient_resetGuildVolunteerMember_Panel_Guild")
    registerEvent("FromClient_applyVacationResult", "FromClient_applyVacationResult")
  end
  registerEvent("FromWeb_WebPageError", "FromWeb_WebPageError")
  registerEvent("onScreenResize", "Guild_onScreenResize")
end
function PaGlobal_CheckVolunteerList()
  if nil == Panel_Window_Guild then
    return
  end
  local self = GuildManager
  if true == _ContentsGroup_BattleFieldVolunteer then
    self.mainBtn_VolunteerList:SetShow(true)
  end
end
function FromClient_resetGuildVolunteerMember_Panel_Guild()
  PaGlobal_CheckVolunteerList()
end
function HandleClickedGuildHideButton()
  if nil == Panel_Window_Guild then
    return
  end
  Panel_Window_Guild:CloseUISubApp()
  GuildInfoPage.checkPopUp:SetCheck(false)
  GuildManager:Hide()
end
function Panel_Guild_Tab_ToolTip_Func(tabNo, isOn, inPut_index, isLeft)
  if nil == Panel_Window_Guild then
    return
  end
  local control = GuildWarInfoPage._list2
  local btn_WarStop, btn_WarIcon
  if nil ~= inPut_index then
    local contents = control:GetContentByKey(toInt64(0, inPut_index))
    if isLeft then
      contents = control:GetContentByKey(toInt64(0, inPut_index))
      btn_WarStop = UI.getChildControl(contents, "Button_Left_WarStop")
      btn_WarIcon = UI.getChildControl(contents, "Static_Left_WarIcon")
    else
      contents = control:GetContentByKey(toInt64(0, inPut_index))
      btn_WarStop = UI.getChildControl(contents, "Button_Right_WarStop")
      btn_WarIcon = UI.getChildControl(contents, "Static_Right_WarIcon")
    end
  end
  if true == isOn then
    local uiControl, name, desc
    if 0 == tabNo then
      uiControl = GuildManager.mainBtn_Info
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDLIST")
      desc = nil
    elseif 1 == tabNo then
      uiControl = GuildManager.mainBtn_Quest
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDQUEST")
      desc = nil
    elseif 2 == tabNo then
      uiControl = GuildManager.mainBtn_Tree
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDSKILL")
      desc = nil
    elseif 3 == tabNo then
      uiControl = GuildManager.mainBtn_Warfare
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDWARFAREINFO")
      desc = nil
    elseif 4 == tabNo then
      uiControl = GuildManager.mainBtn_Recruitment
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENTGUILD")
      desc = nil
    elseif 5 == tabNo then
      uiControl = GuildManager.mainBtn_History
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDHISTORY")
      desc = nil
    elseif 6 == tabNo then
      uiControl = GuildInfoPage._btnIncreaseMember
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_HELP_WARINFO")
      desc = nil
    elseif 7 == tabNo then
      uiControl = btn_WarIcon
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PENALTY")
      desc = nil
    elseif 8 == tabNo then
      uiControl = GuildInfoPage._btnProtectAdd
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_HELP_PROTECTADD")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PROTECTADD_DESC")
    elseif 9 == tabNo then
      uiControl = btn_WarStop
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_WARSTOP")
      desc = nil
    elseif 10 == tabNo then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_WARREQUEST")
      desc = nil
    elseif 11 == tabNo then
      uiControl = GuildManager.mainBtn_CraftInfo
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDCRAFTINFO_TITLE")
      desc = nil
    elseif 12 == tabNo then
      uiControl = GuildManager.mainBtn_GuildBattle
      name = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_GUILDBATTLE")
      desc = nil
    elseif 13 == tabNo then
      uiControl = GuildManager.mainBtn_GuildManufacture
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMANUFACTURE")
      desc = nil
    elseif 14 == tabNo then
      uiControl = GuildManager.mainBtn_GuildAlliance
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_TITLE")
      desc = nil
    elseif 15 == tabNo then
      uiControl = GuildManager.mainBtn_GuildAllianceList
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TAB_ALLIANCELISTITLE")
      desc = nil
    elseif 16 == tabNo then
      uiControl = GuildManager.mainBtn_VolunteerList
      name = PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_GUILD_VOLUNTEER_LIST_TAB_BUTTON_TOOLTIP")
      desc = nil
    elseif 99 == tabNo then
      uiControl = GuildManager.mainBtn_Main
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDINFO_TITLE")
      desc = nil
    end
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function GuildSimplTooltips(isShow, tipType)
  if nil == Panel_Window_Guild then
    return
  end
  if not isShow then
    TooltipSimple_Hide()
    return false
  end
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMASTER_MANDATE_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMASTER_MANDATE_TOOLTIP_DESC")
    control = GuildInfoPage._btn_GuildMasterMandate
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMASTER_MANDATE_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMASTER_MANDATE_TOOLTIP_DESC")
    control = GuildInfoPage._btn_GuildMasterMandateBG
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMARK_BTN_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMARK_BTN_TOOLTIP_DESC")
    control = GuildInfoPage._btnChangeMark
  elseif 3 == tipType then
    if getSelfPlayer():get():isGuildMaster() then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_GUILD")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDDEL_BTN_TOOLTIP_DESC")
    else
      name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_WITHDRAW_GUILD")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDDEL_BTN_TOOLTIP_DESC2")
    end
    control = GuildInfoPage._btnGuildDel
  elseif 4 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_SIMPLETOOLTIP_GUILDNAME")
    control = GuildInfoPage._txtRGuildName
  elseif 5 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_SIMPLETOOLTIP_GUILDNICKNAME")
    control = GuildInfoPage._txtRMaster
  elseif 6 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_SIMPLETOOLTIP_WEBINFO")
    control = GuildInfoPage._btnGuildWebInfo
  elseif 7 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_SIMPLETOOLTIP_WAREHOUSE")
    control = GuildInfoPage._btnGuildWarehouse
  elseif 8 == tipType and true == isContentsArsha and true == isCanDoReservation then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_SIMPLETOOLTIP_GETARSHAHOST")
    control = GuildInfoPage._btnGetArshaHost
  elseif 9 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_LIST_NOTICE_TITLE")
    control = GuildInfoPage.notice_title
  elseif 10 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_LIST_NOTICE_TITLE") .. " " .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKET_REGISTITEM_BTN_CONFIRM")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ONLINE_NOTICE_DESC")
    control = GuildInfoPage.notice_btn
  elseif 11 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_REGION_EXTRICATE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_REGION_EXTRICATE_TOOLTIP_DESC")
    control = GuildInfoPage._btnEvacuation
  elseif 12 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_WARHELP")
    control = GuildWarInfoPage._txt_Title
  elseif 13 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHAT_SOCIALMENU_BTN_RESET")
    control = GuildInfoPage._introduce_Reset
  elseif 14 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDINTRODUCE_WRITE_TOOLTIP_TITLE")
    control = GuildInfoPage._introduce_edit
  elseif 15 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_GUILD_GET_VACATION_BUTTON_TOOLTIP_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_GUILD_GET_VACATION_BUTTON_TOOLTIP_DESC")
    control = GuildInfoPage._btnGetVacation
  elseif 16 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_GUILD_RELEASE_VACATION_BUTTON_TOOLTIP_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_GUILD_RELEASE_VACATION_BUTTON_TOOLTIP_DESC")
    control = GuildInfoPage._btnReleaseVacation
  end
  TooltipSimple_Show(control, name, desc)
end
local _index
function GuildManager:TabToggle(index)
  if nil == Panel_Window_Guild then
    return
  end
  GuildInfoPage._area_MainBG:SetSize(924, 642)
  if 10 == index then
    local _isGuildAllianceMember = getSelfPlayer():get():isGuildAllianceMember()
    if true ~= _isGuildAllianceMember then
      local _allianceYet = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_CAUTION_MESSAGE_TEXT")
      Proc_ShowMessage_Ack(_allianceYet)
      self.mainBtn_Main:SetCheck(tabNumber == 99)
      self.mainBtn_History:SetCheck(tabNumber == 0)
      self.mainBtn_Info:SetCheck(tabNumber == 1)
      self.mainBtn_Quest:SetCheck(tabNumber == 2)
      self.mainBtn_Tree:SetCheck(tabNumber == 3)
      self.mainBtn_Warfare:SetCheck(tabNumber == 4)
      self.mainBtn_Recruitment:SetCheck(tabNumber == 5)
      self.mainBtn_CraftInfo:SetCheck(tabNumber == 6)
      self.mainBtn_GuildBattle:SetCheck(tabNumber == 7)
      self.mainBtn_GuildManufacture:SetCheck(8 == tabNumber)
      self.mainBtn_GuildAlliance:SetCheck(9 == tabNumber)
      self.mainBtn_GuildAllianceList:SetCheck(10 == tabNumber)
      self.mainBtn_VolunteerList:SetCheck(11 == tabNumber)
      return
    end
  end
  tabNumber = 99
  self.mainBtn_Main:SetCheck(index == 99)
  self.mainBtn_History:SetCheck(index == 0)
  self.mainBtn_Info:SetCheck(index == 1)
  self.mainBtn_Quest:SetCheck(index == 2)
  self.mainBtn_Tree:SetCheck(index == 3)
  self.mainBtn_Warfare:SetCheck(index == 4)
  self.mainBtn_Recruitment:SetCheck(index == 5)
  self.mainBtn_CraftInfo:SetCheck(index == 6)
  self.mainBtn_GuildBattle:SetCheck(index == 7)
  self.mainBtn_GuildManufacture:SetCheck(8 == index)
  self.mainBtn_GuildAlliance:SetCheck(9 == index)
  self.mainBtn_GuildAllianceList:SetCheck(10 == index)
  self.mainBtn_VolunteerList:SetCheck(11 == index)
  if getSelfPlayer():get():isGuildMaster() and getSelfPlayer():get():isGuildSubMaster() then
    FGlobal_ClearCandidate()
    GuildInfoPage._Web:ResetUrl()
  end
  PaGlobal_Guild_Manufacture:SetShow(false)
  if 0 == index then
    FGlobal_GuildHistory_Show(true)
    GuildListInfoPage:Hide()
    GuildQuestInfoPage:Hide()
    GuildWarfareInfoPage:Hide()
    GuildSkillFrame_Hide()
    Guild_Recruitment_Close()
    GuildMainInfo_Hide()
    GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
    GuildInfoPage._btn_GuildMasterMandate:SetShow(false)
    PaGlobal_GuildBattle:Close()
    FGlobal_GuildAlliance_Show(false)
    FGlobal_GuildAllianceList_Open(false)
    FGlobal_Guild_VolunteerList_Close()
    tabNumber = 0
  elseif 1 == index then
    local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
    local guildGrade
    if nil ~= myGuildInfo then
      guildGrade = myGuildInfo:getGuildGrade()
    end
    FGlobal_GuildHistory_Show(false)
    GuildListInfoPage:Show()
    GuildQuestInfoPage:Hide()
    GuildWarfareInfoPage:Hide()
    GuildSkillFrame_Hide()
    Guild_Recruitment_Close()
    GuildMainInfo_Hide()
    GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
    GuildInfoPage._btn_GuildMasterMandate:SetShow(false)
    PaGlobal_GuildBattle:Close()
    FGlobal_GuildAlliance_Show(false)
    FGlobal_GuildAllianceList_Open(false)
    FGlobal_Guild_VolunteerList_Close()
    tabNumber = 1
  elseif 2 == index then
    GuildInfoPage._area_MainBG:SetSize(924, 600)
    FGlobal_GuildHistory_Show(false)
    GuildListInfoPage:Hide()
    GuildQuestInfoPage:Show()
    GuildWarfareInfoPage:Hide()
    GuildSkillFrame_Hide()
    GuildMainInfo_Hide()
    Guild_Recruitment_Close()
    GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
    GuildInfoPage._btn_GuildMasterMandate:SetShow(false)
    PaGlobal_GuildBattle:Close()
    FGlobal_GuildAlliance_Show(false)
    FGlobal_GuildAllianceList_Open(false)
    FGlobal_Guild_VolunteerList_Close()
    tabNumber = 2
  elseif 3 == index then
    FGlobal_GuildHistory_Show(false)
    GuildListInfoPage:Hide()
    GuildQuestInfoPage:Hide()
    GuildWarfareInfoPage:Hide()
    GuildSkillFrame_Show()
    GuildMainInfo_Hide()
    Guild_Recruitment_Close()
    GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
    GuildInfoPage._btn_GuildMasterMandate:SetShow(false)
    PaGlobal_GuildBattle:Close()
    FGlobal_GuildAlliance_Show(false)
    FGlobal_GuildAllianceList_Open(false)
    FGlobal_Guild_VolunteerList_Close()
    tabNumber = 3
  elseif 4 == index then
    FGlobal_GuildHistory_Show(false)
    GuildListInfoPage:Hide()
    GuildQuestInfoPage:Hide()
    GuildWarfareInfoPage:Show()
    GuildSkillFrame_Hide()
    GuildMainInfo_Hide()
    Guild_Recruitment_Close()
    GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
    GuildInfoPage._btn_GuildMasterMandate:SetShow(false)
    PaGlobal_GuildBattle:Close()
    FGlobal_GuildAlliance_Show(false)
    FGlobal_GuildAllianceList_Open(false)
    FGlobal_Guild_VolunteerList_Close()
    tabNumber = 4
  elseif 5 == index then
    local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
    if nil == myGuildInfo then
      return
    end
    if not getSelfPlayer():get():isGuildMaster() and not getSelfPlayer():get():isGuildSubMaster() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ONLYMASTER"))
      self.mainBtn_Main:SetCheck(_index == 99)
      self.mainBtn_History:SetCheck(_index == 0)
      self.mainBtn_Info:SetCheck(_index == 1)
      self.mainBtn_Quest:SetCheck(_index == 2)
      self.mainBtn_Tree:SetCheck(_index == 3)
      self.mainBtn_Warfare:SetCheck(_index == 4)
      self.mainBtn_Recruitment:SetCheck(_index == 5)
      self.mainBtn_CraftInfo:SetCheck(_index == 6)
      self.mainBtn_GuildBattle:SetCheck(_index == 7)
      self.mainBtn_GuildAlliance:SetCheck(_index == 9)
      self.mainBtn_GuildAllianceList:SetCheck(_index == 10)
      self.mainBtn_VolunteerList:SetCheck(_index == 11)
      return
    end
    FGlobal_GuildHistory_Show(false)
    GuildListInfoPage:Hide()
    GuildQuestInfoPage:Hide()
    GuildWarfareInfoPage:Hide()
    GuildSkillFrame_Hide()
    GuildMainInfo_Hide()
    Guild_Recruitment_Open()
    GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
    GuildInfoPage._btn_GuildMasterMandate:SetShow(false)
    PaGlobal_GuildBattle:Close()
    FGlobal_GuildAlliance_Show(false)
    FGlobal_GuildAllianceList_Open(false)
    FGlobal_Guild_VolunteerList_Close()
    tabNumber = 5
  elseif 99 == index then
    GuildMainInfo_Show()
    FGlobal_GuildHistory_Show(false)
    GuildListInfoPage:Hide()
    GuildQuestInfoPage:Hide()
    GuildWarfareInfoPage:Hide()
    GuildSkillFrame_Hide()
    Guild_Recruitment_Close()
    PaGlobal_GuildBattle:Close()
    FGlobal_GuildAlliance_Show(false)
    FGlobal_GuildAllianceList_Open(false)
    FGlobal_Guild_VolunteerList_Close()
    tabNumber = 99
  elseif 6 == index then
    FGlobal_GuildHistory_Show(false)
    GuildMainInfo_Hide()
    GuildListInfoPage:Hide()
    GuildQuestInfoPage:Hide()
    GuildWarfareInfoPage:Hide()
    GuildSkillFrame_Hide()
    Guild_Recruitment_Close()
    GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
    GuildInfoPage._btn_GuildMasterMandate:SetShow(false)
    PaGlobal_GuildBattle:Close()
    FGlobal_GuildAlliance_Show(false)
    FGlobal_GuildAllianceList_Open(false)
    FGlobal_Guild_VolunteerList_Close()
    tabNumber = 6
  elseif 7 == index then
    if false == ToClient_isGuildBattle() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_CANNOT_GUILDBATTLE_SERVER"))
      self.mainBtn_GuildBattle:SetCheck(false)
      return
    end
    FGlobal_GuildBattle_Open()
    FGlobal_GuildHistory_Show(false)
    GuildMainInfo_Hide()
    GuildListInfoPage:Hide()
    GuildQuestInfoPage:Hide()
    GuildWarfareInfoPage:Hide()
    GuildSkillFrame_Hide()
    Guild_Recruitment_Close()
    GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
    GuildInfoPage._btn_GuildMasterMandate:SetShow(false)
    FGlobal_GuildAlliance_Show(false)
    FGlobal_GuildAllianceList_Open(false)
    FGlobal_Guild_VolunteerList_Close()
    tabNumber = 7
  elseif 8 == index then
    FGlobal_GuildHistory_Show(false)
    GuildMainInfo_Hide()
    GuildListInfoPage:Hide()
    GuildQuestInfoPage:Hide()
    GuildWarfareInfoPage:Hide()
    GuildSkillFrame_Hide()
    Guild_Recruitment_Close()
    GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
    GuildInfoPage._btn_GuildMasterMandate:SetShow(false)
    FGlobal_GuildBattle_Close()
    FGlobal_GuildAlliance_Show(false)
    PaGlobal_Guild_Manufacture:SetShow(true)
    FGlobal_GuildAllianceList_Open(false)
    FGlobal_Guild_VolunteerList_Close()
    tabNumber = 8
  elseif 9 == index then
    FGlobal_GuildHistory_Show(false)
    GuildListInfoPage:Hide()
    GuildQuestInfoPage:Hide()
    GuildWarfareInfoPage:Hide()
    GuildSkillFrame_Hide()
    Guild_Recruitment_Close()
    GuildMainInfo_Hide()
    GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
    GuildInfoPage._btn_GuildMasterMandate:SetShow(false)
    PaGlobal_GuildBattle:Close()
    FGlobal_GuildAllianceList_Open(false)
    FGlobal_Guild_VolunteerList_Close()
    local guildAlliance = ToClient_GetMyGuildAllianceWrapper()
    local _isGuildMaster = getSelfPlayer():get():isGuildMaster()
    local _isGuildAllianceMember = getSelfPlayer():get():isGuildAllianceMember()
    if true ~= _isGuildAllianceMember then
      if _isGuildMaster then
        FGlobal_GuildAlliance_Show(true)
      else
        local _allianceYet = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_CAUTION_MESSAGE_TEXT")
        Proc_ShowMessage_Ack(_allianceYet)
      end
    else
      FGlobal_GuildAlliance_Show(true)
    end
    tabNumber = 9
  elseif 10 == index then
    FGlobal_GuildHistory_Show(false)
    GuildListInfoPage:Hide()
    GuildQuestInfoPage:Hide()
    GuildWarfareInfoPage:Hide()
    GuildSkillFrame_Hide()
    Guild_Recruitment_Close()
    GuildMainInfo_Hide()
    GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
    GuildInfoPage._btn_GuildMasterMandate:SetShow(false)
    PaGlobal_GuildBattle:Close()
    FGlobal_GuildAlliance_Show(false)
    FGlobal_Guild_VolunteerList_Close()
    FGlobal_GuildAllianceList_Open(true)
    tabNumber = 10
  elseif 11 == index then
    FGlobal_GuildHistory_Show(false)
    GuildListInfoPage:Hide()
    GuildQuestInfoPage:Hide()
    GuildWarfareInfoPage:Hide()
    GuildSkillFrame_Hide()
    Guild_Recruitment_Close()
    GuildMainInfo_Hide()
    GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
    GuildInfoPage._btn_GuildMasterMandate:SetShow(false)
    PaGlobal_GuildBattle:Close()
    FGlobal_GuildAlliance_Show(false)
    FGlobal_GuildAllianceList_Open(false)
    FGlobal_Guild_VolunteerList_Open()
    tabNumber = 11
  end
  FGlobal_Guild_CraftInfo_Open(6 == index)
  FGlobal_GuildMenuButtonHide()
  _index = index
end
function GuildManager:Hide()
  if false == GuildInfoPage:getShowPanel() then
    return
  end
  if Panel_Window_Guild:IsUISubApp() then
    return
  end
  PaGlobalFunc_GuildQuest_Reward_Close()
  Panel_SkillTooltip_Hide()
  Panel_Tooltip_Item_hideTooltip()
  PaGlobal_Guild_ManufactureSelect:close()
  PaGlobal_Guild_UseGuildFunds:ShowToggle(nil, false)
  if nil == PaGlobal_GuildPanelLoad_SetShowPanelGuildMain then
    Panel_Window_Guild:SetShow(false, true)
  else
    PaGlobal_GuildPanelLoad_SetShowPanelGuildMain(false, true)
  end
  if false == _ContentsGroup_NewUI_Dialog_All then
    FGlobal_ShowRewardList(false)
  end
  HelpMessageQuestion_Out()
  FGlobal_AgreementGuild_Close()
  agreementGuild_Master_Close()
  Panel_GuildIncentiveOption_Close()
  HandleClicked_LetsWarHide()
  FGlobal_GuildMenuButtonHide()
  TooltipSimple_Hide()
  TooltipGuild_Hide()
  FGlobal_GetDailyPay_Hide()
  FGlobal_GetGuildMemberBonus_Hide()
  Panel_Guild_Incentive_Foundation_Close()
  FGlobal_Guild_VolunteerList_Close()
  if false == CheckChattingInput() then
    ClearFocusEdit()
  end
  FGlobal_ClearCandidate()
  GuildInfoPage._Web:ResetUrl()
end
function GuildManager:Show()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if false == GuildInfoPage:getShowPanel() then
    if nil == PaGlobal_GuildPanelLoad_SetShowPanelGuildMain then
      Panel_Window_Guild:SetShow(true, true)
    else
      PaGlobal_GuildPanelLoad_SetShowPanelGuildMain(true, true)
    end
    local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
    local isGuildMaster = getSelfPlayer():get():isGuildMaster()
    local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
    if myGuildInfo ~= nil then
      GuildManager._doHaveSeige = myGuildInfo:doHaveOccupyingSiege()
    end
    local isAdmin = 0
    if isGuildMaster or isGuildSubMaster then
      isAdmin = 1
    end
    local _isGuildAllianceMember = getSelfPlayer():get():isGuildAllianceMember()
    if _isGuildAllianceMember then
      self.mainBtn_GuildAlliance:SetPosX(guildManagerButtonPositionList[0])
      self.mainBtn_GuildAllianceList:SetPosX(guildManagerButtonPositionList[1])
      self.mainBtn_Main:SetPosX(guildManagerButtonPositionList[2])
      self.mainBtn_Info:SetPosX(guildManagerButtonPositionList[3])
      self.mainBtn_Quest:SetPosX(guildManagerButtonPositionList[4])
      self.mainBtn_Tree:SetPosX(guildManagerButtonPositionList[5])
      self.mainBtn_Warfare:SetPosX(guildManagerButtonPositionList[6])
      self.mainBtn_History:SetPosX(guildManagerButtonPositionList[7])
      self.mainBtn_Recruitment:SetPosX(guildManagerButtonPositionList[8])
      self.mainBtn_GuildManufacture:SetPosX(guildManagerButtonPositionList[9])
      self.mainBtn_GuildBattle:SetPosX(guildManagerButtonPositionList[10])
      self.mainBtn_VolunteerList:SetPosX(guildManagerButtonPositionList[11])
    else
      self.mainBtn_Main:ComputePos()
      self.mainBtn_Info:ComputePos()
      self.mainBtn_Quest:ComputePos()
      self.mainBtn_Tree:ComputePos()
      self.mainBtn_Warfare:ComputePos()
      self.mainBtn_History:ComputePos()
      self.mainBtn_Recruitment:ComputePos()
      self.mainBtn_GuildManufacture:ComputePos()
      self.mainBtn_GuildBattle:ComputePos()
      self.mainBtn_GuildAlliance:ComputePos()
      self.mainBtn_GuildAllianceList:ComputePos()
      if false == _ContentsGroup_guildAlliance then
        self.mainBtn_VolunteerList:SetPosX(self.mainBtn_GuildAlliance:GetPosX())
      else
        self.mainBtn_VolunteerList:ComputePos()
      end
    end
    if _isGuildAllianceMember then
      self.mainBtn_GuildAlliance:SetCheck(true)
      self.mainBtn_Main:SetCheck(false)
    else
      self.mainBtn_Main:SetCheck(true)
      self.mainBtn_GuildAlliance:SetCheck(false)
    end
    self.mainBtn_Info:SetCheck(false)
    self.mainBtn_Quest:SetCheck(false)
    self.mainBtn_Tree:SetCheck(false)
    self.mainBtn_Warfare:SetCheck(false)
    self.mainBtn_History:SetCheck(false)
    self.mainBtn_Recruitment:SetCheck(false)
    self.mainBtn_GuildAllianceList:SetCheck(false)
    self.mainBtn_Main:SetIgnore(false)
    self.mainBtn_Info:SetIgnore(false)
    self.mainBtn_Quest:SetIgnore(false)
    self.mainBtn_Tree:SetIgnore(false)
    self.mainBtn_Warfare:SetIgnore(false)
    self.mainBtn_History:SetIgnore(false)
    self.mainBtn_Recruitment:SetIgnore(false)
    self.mainBtn_CraftInfo:SetIgnore(false)
    self.mainBtn_GuildBattle:SetIgnore(false)
    self.mainBtn_GuildAlliance:SetIgnore(false)
    self.mainBtn_GuildAllianceList:SetIgnore(false)
    self.mainBtn_Main:SetMonoTone(false)
    self.mainBtn_Info:SetMonoTone(false)
    self.mainBtn_Quest:SetMonoTone(false)
    self.mainBtn_Tree:SetMonoTone(false)
    self.mainBtn_Warfare:SetMonoTone(false)
    self.mainBtn_History:SetMonoTone(false)
    self.mainBtn_GuildAlliance:SetMonoTone(false)
    self.mainBtn_GuildAllianceList:SetMonoTone(false)
    if getSelfPlayer():get():isGuildMaster() or getSelfPlayer():get():isGuildSubMaster() then
      self.mainBtn_Recruitment:SetMonoTone(false)
    else
      self.mainBtn_Recruitment:SetMonoTone(true)
    end
    self.mainBtn_CraftInfo:SetMonoTone(false)
    GuildWarInfoPage._btnWarList1:SetCheck(true)
    GuildWarInfoPage._btnWarList2:SetCheck(false)
    if isDeadInWatchingMode() and not Panel_DeadMessage:GetShow() then
      GuildManager:TabToggle(4)
      self.mainBtn_Main:SetCheck(false)
      self.mainBtn_Info:SetCheck(false)
      self.mainBtn_Quest:SetCheck(false)
      self.mainBtn_Tree:SetCheck(false)
      self.mainBtn_Warfare:SetCheck(true)
      self.mainBtn_History:SetCheck(false)
      self.mainBtn_Recruitment:SetCheck(false)
      self.mainBtn_CraftInfo:SetCheck(false)
      self.mainBtn_GuildBattle:SetCheck(false)
      self.mainBtn_GuildAlliance:SetCheck(false)
      self.mainBtn_GuildManufacture:SetCheck(false)
      self.mainBtn_GuildAllianceList:SetCheck(false)
      self.mainBtn_Main:SetIgnore(true)
      self.mainBtn_Info:SetIgnore(true)
      self.mainBtn_Quest:SetIgnore(true)
      self.mainBtn_Tree:SetIgnore(true)
      self.mainBtn_Warfare:SetIgnore(false)
      self.mainBtn_History:SetIgnore(true)
      self.mainBtn_Recruitment:SetIgnore(true)
      self.mainBtn_CraftInfo:SetIgnore(true)
      self.mainBtn_GuildBattle:SetIgnore(true)
      self.mainBtn_GuildAlliance:SetIgnore(true)
      self.mainBtn_GuildManufacture:SetIgnore(true)
      self.mainBtn_GuildAllianceList:SetIgnore(true)
      self.mainBtn_Main:SetMonoTone(true)
      self.mainBtn_Info:SetMonoTone(true)
      self.mainBtn_Quest:SetMonoTone(true)
      self.mainBtn_Tree:SetMonoTone(true)
      self.mainBtn_Warfare:SetMonoTone(true)
      self.mainBtn_History:SetMonoTone(true)
      self.mainBtn_Recruitment:SetMonoTone(true)
      self.mainBtn_CraftInfo:SetMonoTone(true)
      self.mainBtn_GuildBattle:SetMonoTone(true)
      self.mainBtn_GuildAlliance:SetMonoTone(true)
      self.mainBtn_GuildManufacture:SetMonoTone(true)
      self.mainBtn_GuildAllianceList:SetMonoTone(true)
    elseif _isGuildAllianceMember then
      GuildManager:TabToggle(9)
    else
      GuildManager:TabToggle(99)
    end
    GuildInfoPage:UpdateData()
    GuildInfoPage:checkShowVacationButton()
    PaGlobal_CheckVolunteerList()
    GuildListInfoPage:UpdateData()
    GuildLetsWarPage:UpdateData()
    GuildWarInfoPage:UpdateData()
    GuildSkillFrame_Update()
    FGlobal_Notice_Update()
    GuildIntroduce_Update()
    FromClient_ResponseGuildNotice()
    FGlobal_GuildListScrollTop()
    guildQuest_ProgressingGuildQuest_UpdateRemainTime()
    ToClient_RequestGuildUnjoinedPlayerList()
    GuildComment_Load()
  end
  GuildManager:volunteerTabCheck()
  GuildMainInfo_Show()
end
function GuildManager:volunteerTabCheck()
  if nil == Panel_Window_Guild then
    return
  end
  if true == PaGlobalFunc_checkIsSelfVolunteer() then
    self.mainBtn_Quest:SetShow(false)
    self.mainBtn_History:SetShow(false)
    self.mainBtn_Recruitment:SetShow(false)
    self.mainBtn_GuildManufacture:SetShow(false)
    self.mainBtn_GuildBattle:SetShow(false)
    self.mainBtn_CraftInfo:SetShow(false)
    self.mainBtn_Main:SetPosX(guildManagerButtonPositionList[0])
    self.mainBtn_Info:SetPosX(guildManagerButtonPositionList[1])
    self.mainBtn_VolunteerList:SetPosX(guildManagerButtonPositionList[2])
    self.mainBtn_Warfare:SetPosX(guildManagerButtonPositionList[3])
    self.mainBtn_GuildAlliance:SetPosX(guildManagerButtonPositionList[4])
    self.mainBtn_GuildAllianceList:SetPosX(guildManagerButtonPositionList[5])
    self.mainBtn_Tree:SetPosX(guildManagerButtonPositionList[6])
    self.mainBtn_Quest:SetPosX(guildManagerButtonPositionList[7])
    self.mainBtn_History:SetPosX(guildManagerButtonPositionList[8])
    self.mainBtn_Recruitment:SetPosX(guildManagerButtonPositionList[9])
    self.mainBtn_GuildManufacture:SetPosX(guildManagerButtonPositionList[10])
    self.mainBtn_GuildBattle:SetPosX(guildManagerButtonPositionList[11])
  end
end
function GuildComment_Load()
  if nil == Panel_Window_Guild then
    return
  end
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil == guildWrapper then
    return
  end
  local guildNo_s64 = guildWrapper:getGuildNo_s64()
  local myUserNo = getSelfPlayer():get():getUserNo()
  local cryptKey = getSelfPlayer():get():getWebAuthenticKeyCryptString()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  guildCommentsWebUrl = PaGlobal_URL_Check(worldNo)
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  local isAdmin = 0
  if isGuildMaster or isGuildSubMaster then
    isAdmin = 1
  end
  if nil ~= guildCommentsWebUrl then
    FGlobal_SetCandidate()
    local url = guildCommentsWebUrl .. "/guild?guildNo=" .. tostring(guildNo_s64) .. "&userNo=" .. tostring(myUserNo) .. "&certKey=" .. tostring(cryptKey) .. "&isMaster=" .. tostring(isAdmin)
    _urlCache = url
    GuildInfoPage._Web:ResetUrl()
    GuildInfoPage._Web:SetUrl(474, 216, url, false, true)
    GuildInfoPage._Web:SetIME(true)
  end
end
function GuildMainInfo_MandateBtn()
  if nil == Panel_Window_Guild then
    return
  end
  if 99 ~= tabNumber then
    return
  end
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  if toInt64(0, -1) == myGuildInfo:getGuildMasterUserNo() then
    if not isGuildMaster then
      GuildInfoPage._btn_GuildMasterMandate:SetShow(true)
      GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
      GuildInfoPage._btn_GuildMasterMandate:SetEnable(true)
      GuildInfoPage._btn_GuildMasterMandate:SetMonoTone(false)
      GuildInfoPage._btn_GuildMasterMandate:SetFontColor(UI_color.C_FF00C0D7)
    end
  elseif isGuildSubMaster then
    if ToClient_IsAbleChangeMaster() then
      if myGuildInfo:getGuildBusinessFunds_s64() < toInt64(0, 20000000) then
        GuildInfoPage._btn_GuildMasterMandate:SetShow(true)
        GuildInfoPage._btn_GuildMasterMandateBG:SetShow(true)
        GuildInfoPage._btn_GuildMasterMandate:SetEnable(false)
        GuildInfoPage._btn_GuildMasterMandate:SetMonoTone(true)
        GuildInfoPage._btn_GuildMasterMandate:SetFontColor(UI_color.C_FFC4BEBE)
      else
        GuildInfoPage._btn_GuildMasterMandate:SetShow(true)
        GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
        GuildInfoPage._btn_GuildMasterMandate:SetEnable(true)
        GuildInfoPage._btn_GuildMasterMandate:SetMonoTone(false)
        GuildInfoPage._btn_GuildMasterMandate:SetFontColor(UI_color.C_FF00C0D7)
      end
    else
      GuildInfoPage._btn_GuildMasterMandate:SetShow(true)
      GuildInfoPage._btn_GuildMasterMandate:SetEnable(false)
      GuildInfoPage._btn_GuildMasterMandateBG:SetShow(true)
      GuildInfoPage._btn_GuildMasterMandate:SetMonoTone(true)
    end
  else
    GuildInfoPage._btn_GuildMasterMandate:SetShow(false)
    GuildInfoPage._btn_GuildMasterMandateBG:SetShow(false)
    TooltipSimple_Hide()
  end
end
function GuildMainInfo_ButtonPositionSet()
  if nil == Panel_Window_Guild then
    return
  end
  local self = GuildInfoPage
  local btnList = {
    [1] = self._btnGuildWebInfo,
    [2] = self._btnGuildWarehouse,
    [3] = self._btnGetArshaHost,
    [4] = self._btnChangeMark
  }
  local btnCount = 5
  local mandate = self._btn_GuildMasterMandate
  local mandateBG = self._btn_GuildMasterMandateBG
  local gapX = 3
  local lastPos = 0
  for ii = 2, btnCount do
    if nil ~= btnList[ii] and true == btnList[ii]:GetShow() then
      btnList[ii]:SetPosX(btnList[ii - 1]:GetPosX() + btnList[ii - 1]:GetSizeX() + gapX)
      lastPos = btnList[ii]:GetPosX() + btnList[ii]:GetSizeX()
    end
  end
  mandate:SetPosX(lastPos + gapX)
  mandateBG:SetPosX(mandate:GetPosX())
end
function GuildMainInfo_Show()
  if nil == Panel_Window_Guild then
    return
  end
  local self = GuildInfoPage
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if 99 ~= tabNumber then
    return
  end
  if nil == myGuildInfo then
    return
  end
  local hasOccupyTerritory = myGuildInfo:getHasSiegeCount()
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  if 0 == hasOccupyTerritory then
    local myGuildAllianceChair = ToClient_GetMyGuildAlliancChairGuild()
    if nil ~= myGuildAllianceChair then
      hasOccupyTerritory = myGuildAllianceChair:getHasSiegeCount()
    end
  end
  if isGuildMaster then
    GuildWarInfoPage._area_GuildWarInfo:SetShow(true)
    self._btnChangeMark:SetShow(true)
    GuildInfoPage.notice_btn:SetShow(true)
    self._promote_btn:SetShow(true)
    self._introduce_btn:SetShow(true)
    self._introduce_Reset:SetShow(true)
    GuildWarInfoPage._btnDeclaration:SetShow(true)
    self._btnIncreaseMember:SetShow(true)
    if isProtectGuildMember then
      self._btnProtectAdd:SetShow(true)
    end
    if isGameTypeTaiwan() then
      self._introduce_edit_TW:SetEnable(true)
    else
      self._introduce_edit:SetEnable(true)
    end
  elseif isGuildSubMaster then
    GuildWarInfoPage._area_GuildWarInfo:SetShow(true)
    self._btnChangeMark:SetShow(false)
    GuildInfoPage.notice_btn:SetShow(true)
    self._promote_btn:SetShow(true)
    self._introduce_btn:SetShow(true)
    self._introduce_Reset:SetShow(true)
    GuildWarInfoPage._btnDeclaration:SetShow(true)
    self._btnIncreaseMember:SetShow(false)
    self._btnProtectAdd:SetShow(false)
    if isGameTypeTaiwan() then
      self._introduce_edit_TW:SetEnable(true)
    else
      self._introduce_edit:SetEnable(true)
    end
  else
    GuildWarInfoPage._area_GuildWarInfo:SetShow(true)
    self._btnChangeMark:SetShow(false)
    GuildInfoPage.notice_btn:SetShow(false)
    self._promote_btn:SetShow(false)
    self._introduce_btn:SetShow(false)
    self._introduce_Reset:SetShow(false)
    GuildWarInfoPage._btnDeclaration:SetShow(false)
    self._btnIncreaseMember:SetShow(false)
    self._btnProtectAdd:SetShow(false)
    if isGameTypeTaiwan() then
      self._introduce_edit_TW:SetEnable(false)
    else
      self._introduce_edit:SetEnable(false)
    end
  end
  if 0 ~= hasOccupyTerritory then
    self._iconOccupyTerritory:SetShow(true)
  else
    self._iconOccupyTerritory:SetShow(true)
  end
  GuildInfoPage.notice_title:SetShow(true)
  GuildInfoPage.notice_edit:SetShow(true)
  if isGameTypeTaiwan() then
    self._introduce_edit_TW:SetShow(true)
    self._introduce_edit:SetShow(false)
  else
    self._introduce_edit:SetShow(true)
    self._introduce_edit_TW:SetShow(false)
  end
  self._area_Introduce:SetShow(true)
  self._guildMainBG:SetShow(true)
  self._iconGuildMark:SetShow(true)
  self._txtRGuildName:SetShow(true)
  self._txtRMaster:SetShow(true)
  self._txtRRank_Title:SetShow(true)
  self._txtRRank:SetShow(true)
  self._txtGuildPoint:SetShow(true)
  self._txtGuildPointValue:SetShow(true)
  self._txtGuildPointPercent:SetShow(true)
  self._btnGuildDel:SetShow(true)
  self._planning:SetShow(true)
  self._area_TodayComment:SetShow(true)
  self._line_Top:SetShow(true)
  self._area_Info:SetShow(true)
  self._txtProtect:SetShow(true)
  self._txtProtectValue:SetShow(true)
  self._txtGuildMoneyTitle:SetShow(true)
  self._txtGuildMoney:SetShow(true)
  self._txtGuildTerritoryTitle:SetShow(true)
  self._txtGuildTerritoryValue:SetShow(true)
  self._txtGuildServantTitle:SetShow(true)
  self._txtGuildServantValue:SetShow(true)
  if true == _ContentsGroup_SeigeSeason5 then
  end
  if isContentsGuildHouse then
    self._btnGuildWarehouse:SetShow(true)
  else
    self._btnGuildWarehouse:SetShow(false)
  end
  if isContentsGuildInfo then
    self._btnGuildWebInfo:SetShow(true)
  else
    self._btnGuildWebInfo:SetShow(false)
    self._btnGuildWarehouse:SetPosX(self._btnGuildWebInfo:GetPosX())
  end
  self._btnGetArshaHost:SetShow(false)
  if (isGuildMaster or isGuildSubMaster) and true == isContentsArsha and true == isCanDoReservation then
    self._btnGetArshaHost:SetShow(true)
  end
  if isGameTypeKR2() then
    self._btnChangeMark:SetShow(false)
  end
  if nil ~= guildCommentsWebUrl then
    self._Web:SetShow(true)
  end
  GuildMainInfo_MandateBtn()
  if true == PaGlobalFunc_checkIsSelfVolunteer() then
    self._btnGuildDel:SetShow(false)
    self._btnGetVacation:SetShow(false)
    self._btnReleaseVacation:SetShow(false)
    self._btnChangeMark:SetShow(false)
    self._btnGetArshaHost:SetShow(false)
    self._btnGuildWarehouse:SetShow(false)
    self._btn_GuildMasterMandate:SetShow(false)
    self._btn_GuildMasterMandateBG:SetShow(false)
  end
  GuildMainInfo_ButtonPositionSet()
end
function guildCommentsUrlByServiceType()
  local url
  if CppEnums.CountryType.DEV == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_KOR_DEV")
  elseif CppEnums.CountryType.KOR_ALPHA == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_KOR_ALPHA")
  elseif CppEnums.CountryType.KOR_REAL == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_KOR_REAL")
  elseif CppEnums.CountryType.NA_ALPHA == getGameServiceType() then
    if 0 == getServiceNationType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_URL_NA_ALPHA_NA", "port", worldNo)
    elseif 1 == getServiceNationType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_URL_NA_ALPHA_EU", "port", worldNo)
    end
  elseif CppEnums.CountryType.NA_REAL == getGameServiceType() then
    if 0 == getServiceNationType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_URL_NA_REAL_NA", "port", worldNo)
    elseif 1 == getServiceNationType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_URL_NA_REAL_EU", "port", worldNo)
    end
  elseif CppEnums.CountryType.JPN_ALPHA == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_JP_ALPHA")
  elseif CppEnums.CountryType.JPN_REAL == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_JP_REAL")
  elseif CppEnums.CountryType.RUS_ALPHA == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_RUS_ALPHA")
  elseif CppEnums.CountryType.RUS_REAL == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_RUS_REAL_F2P")
  elseif CppEnums.CountryType.TW_ALPHA == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_TW_ALPHA")
  elseif CppEnums.CountryType.TW_REAL == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_TW_REAL")
  elseif CppEnums.CountryType.SA_ALPHA == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_SA_ALPHA")
  elseif CppEnums.CountryType.SA_REAL == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_SA_REAL")
  elseif CppEnums.CountryType.KR2_ALPHA == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_KR2_ALPHA")
  elseif CppEnums.CountryType.KR2_REAL == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_KR2_REAL")
  elseif CppEnums.CountryType.TR_ALPHA == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_TR_ALPHA")
  elseif CppEnums.CountryType.TR_REAL == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_TR_REAL")
  elseif CppEnums.CountryType.TH_ALPHA == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_TH_ALPHA")
  elseif CppEnums.CountryType.TH_REAL == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_TH_REAL")
  elseif CppEnums.CountryType.ID_ALPHA == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_ID_ALPHA")
  elseif CppEnums.CountryType.ID_REAL == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_URL_ID_REAL")
  end
  return url
end
function GuildMainInfo_Hide()
  if nil == Panel_Window_Guild then
    return
  end
  GuildInfoPage._Web:SetShow(false)
  GuildInfoPage.notice_title:SetShow(false)
  GuildInfoPage.notice_edit:SetShow(false)
  GuildInfoPage.notice_btn:SetShow(false)
  GuildInfoPage._area_Introduce:SetShow(false)
  GuildInfoPage._guildMainBG:SetShow(false)
  GuildInfoPage._iconOccupyTerritory:SetShow(false)
  GuildInfoPage._iconGuildMark:SetShow(false)
  GuildInfoPage._txtRGuildName:SetShow(false)
  GuildInfoPage._txtRMaster:SetShow(false)
  GuildInfoPage._txtRRank_Title:SetShow(false)
  GuildInfoPage._txtRRank:SetShow(false)
  GuildInfoPage._btnIncreaseMember:SetShow(false)
  GuildInfoPage._txtGuildPoint:SetShow(false)
  GuildInfoPage._txtGuildPointValue:SetShow(false)
  GuildInfoPage._txtGuildPointPercent:SetShow(false)
  GuildInfoPage._btnGuildDel:SetShow(false)
  GuildInfoPage._btnChangeMark:SetShow(false)
  GuildInfoPage._planning:SetShow(false)
  GuildInfoPage._area_Info:SetShow(false)
  GuildInfoPage._txtProtect:SetShow(false)
  GuildInfoPage._txtProtectValue:SetShow(false)
  GuildInfoPage._btnProtectAdd:SetShow(false)
  GuildInfoPage._txtGuildMoneyTitle:SetShow(false)
  GuildInfoPage._txtGuildMoney:SetShow(false)
  GuildInfoPage._txtGuildTerritoryTitle:SetShow(false)
  GuildInfoPage._txtGuildTerritoryValue:SetShow(false)
  GuildInfoPage._txtGuildServantTitle:SetShow(false)
  GuildInfoPage._txtGuildServantValue:SetShow(false)
  GuildInfoPage._btnGuildWebInfo:SetShow(false)
  GuildInfoPage._btnGuildWarehouse:SetShow(false)
  GuildInfoPage._btnGetArshaHost:SetShow(false)
  GuildInfoPage._btnEvacuation:SetShow(false)
  GuildInfoPage._line_Top:SetShow(false)
  GuildInfoPage._area_TodayComment:SetShow(false)
  GuildWarInfoPage._area_GuildWarInfo:SetShow(false)
  GuildMainInfo_MandateBtn()
end
function HandleClicked_TerritoryNameOnEvent(isShow)
  if nil == Panel_Window_Guild then
    return
  end
  local self = GuildInfoPage
  local name, desc, control
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  local myGuildAllianceChair = ToClient_GetMyGuildAlliancChairGuild()
  local myGuildAllianceCache
  if nil ~= myGuildAllianceChair then
    myGuildAllianceCache = myGuildAllianceChair
  else
    myGuildAllianceCache = myGuildInfo
  end
  if nil == myGuildAllianceCache then
    return
  end
  local guildArea1 = ""
  local territoryKey = ""
  local territoryWarName = ""
  if 0 < myGuildAllianceCache:getTerritoryCount() then
    for idx = 0, myGuildAllianceCache:getTerritoryCount() - 1 do
      territoryKey = myGuildAllianceCache:getTerritoryKeyAt(idx)
      local territoryInfoWrapper = getTerritoryInfoWrapperByIndex(territoryKey)
      if nil ~= territoryInfoWrapper then
        guildArea1 = territoryInfoWrapper:getTerritoryName()
        local territoryComma = ", "
        if "" == territoryWarName then
          territoryComma = ""
        end
        territoryWarName = territoryWarName .. territoryComma .. guildArea1
        if 2 == territoryKey then
          desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TERRITORYBENEFIT_1")
        end
        if 3 == territoryKey then
          if nil == desc then
            desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TERRITORYBENEFIT_2")
          else
            desc = desc .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TERRITORYBENEFIT_3")
          end
        end
        if 4 == territoryKey then
          if nil == desc then
            desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TERRITORYBENEFIT_4")
          else
            desc = desc .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TERRITORYBENEFIT_5")
          end
        end
      end
    end
    name = territoryWarName
    control = self._txtGuildTerritoryValue
    if nil ~= desc then
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TERRITORYBENEFIT_6", "territoryName", desc)
    end
    if not _ContentsGroup_OccupyBenefit then
      desc = nil
    end
  end
  local guildArea2 = ""
  local regionKey = ""
  local siegeWarName = ""
  if 0 < myGuildAllianceCache:getSiegeCount() then
    for idx = 0, myGuildAllianceCache:getSiegeCount() - 1 do
      regionKey = myGuildAllianceCache:getSiegeKeyAt(idx)
      local regionInfoWrapper = getRegionInfoWrapper(regionKey)
      if nil ~= regionInfoWrapper then
        guildArea2 = regionInfoWrapper:getAreaName()
        local siegeComma = ", "
        if "" == siegeWarName then
          siegeComma = ""
        end
        siegeWarName = siegeWarName .. siegeComma .. guildArea2
      end
    end
    name = siegeWarName
    control = self._txtGuildTerritoryValue
  end
  if isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function HandleClicked_GuildServantCountOnEvent(isShow)
  if nil == Panel_Window_Guild then
    return
  end
  local self = GuildInfoPage
  local name, desc, control
  local guildServantElephantCount = guildStable_getServantCount(UI_VT.Type_Elephant)
  local guildServantShipCount = guildStable_getServantCount(UI_VT.Type_SailingBoat)
  local guilServantValueCount = ""
  if guildServantElephantCount > 0 then
    guilServantValueCount = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_SERVANTCOUNT_ELEPHANT_ONLY", "guildServantElephantCount", guildServantElephantCount)
  end
  if guildServantShipCount > 0 then
    if guildServantElephantCount > 0 then
      guilServantValueCount = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_SERVANTCOUNT_GUILDVEHICLE_BOTH", "guilServantValueCount", guilServantValueCount, "guildServantShipCount", guildServantShipCount)
    else
      guilServantValueCount = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_SERVANTCOUNT_SAILBOAT_ONLY", "guildServantShipCount", guildServantShipCount)
    end
  end
  if nil ~= guilServantValueCount then
    name = guilServantValueCount
    control = self._txtGuildServantValue
  end
  if isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function FromClient_ResponseGuildUpdate()
  if nil == Panel_Window_Guild then
    return
  end
  if true == GuildInfoPage:getShowPanel() then
    GuildInfoPage:UpdateData()
    GuildListInfoPage:UpdateData()
    GuildQuestInfoPage:UpdateData()
    GuildWarInfoPage:UpdateData()
    GuildSkillFrame_Update()
    guildQuest_ProgressingGuildQuest_UpdateRemainTime()
  elseif true == Panel_ClanList:GetShow() then
    FGlobal_ClanList_Update()
  end
end
function FromClient_GuildListUpdate(userNo)
  if true == GuildInfoPage:getShowPanel() then
    GuildListInfoPage:UpdateVoiceDataByUserNo(userNo)
  end
end
function FromClient_EventActorChangeGuildInfo()
  GuildInfoPage:UpdateData()
end
local messageBox_guild_accept = function()
  ToClient_RequestAcceptGuildInvite()
end
local messageBox_guild_refuse = function()
  ToClient_RequestRefuseGuildInvite()
end
function FromClient_ResponseGuild_refuse(questName, s64_joinableTime)
  if s64_joinableTime > toInt64(0, 0) then
    local lefttimeText = convertStringFromDatetime(getLeftSecond_TTime64(s64_joinableTime))
    local contentString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_MSGBOX_JOINWAITTIME_CONTENT", "questName", questName, "lefttimeText", lefttimeText)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_INVITE"),
      content = contentString,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
    if nil == myGuildInfo then
      _PA_ASSERT(false, "FromClient_ResponseGuild_refuse \236\151\144\236\132\156 \234\184\184\235\147\156 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
    end
    local textGuild = ""
    local guildGrade = myGuildInfo:getGuildGrade()
    if 0 == guildGrade then
      textGuild = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLAN")
    else
      textGuild = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD")
    end
    local contentString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_REFUSE_GUILDINVITE", "name", questName, "guild", textGuild)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_INVITE"),
      content = contentString,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
end
function FromClient_ResponseGuild_invite(s64_guildNo, hostUsername, hostName, guildName, guildGrade, periodDay, benefit, penalty)
  if 0 == guildGrade then
    local luaGuildTextGuildInviteMsg = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLAN_INVITE_MSG")
    local luaGuildTextGuildInvite = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLAN_INVITE")
    local contentString = hostUsername .. "(" .. hostName .. ")" .. luaGuildTextGuildInviteMsg
    local messageboxData = {
      title = luaGuildTextGuildInvite,
      content = contentString,
      functionYes = messageBox_guild_accept,
      functionCancel = messageBox_guild_refuse,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  elseif 1 == guildGrade then
    FGlobal_AgreementGuild_Open(true, hostUsername, hostName, guildName, periodDay, benefit, penalty, s64_guildNo)
  end
end
function messageBox_guildAlliance_accept()
  ToClient_sendJoinGuildAlliance(true)
end
function messageBox_guildAlliance_refuse()
  ToClient_sendJoinGuildAlliance(false)
end
function FromClient_ResponseUpdateGuildContract(notifyType, userNickName, characterName, strParam1, strParam2, s64_param1, s64_param2, s64_param3)
  local param1 = Int64toInt32(s64_param1)
  local param2 = Int64toInt32(s64_param2)
  local param3 = Int64toInt32(s64_param3)
  if 0 == notifyType then
    local tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_PENSION")
    local guildWrapper = ToClient_GetMyGuildInfoWrapper()
    if nil == guildWrapper then
      return
    end
    local guildGrade = guildWrapper:getGuildGrade()
    if 1 == guildGrade then
      Proc_ShowMessage_Ack(tempStr)
    end
  elseif 1 == notifyType then
    local tempStr = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_MONEY_DEPOSIT", "userNickName", userNickName, "money", tostring(param1))
    Proc_ShowMessage_Ack(tempStr)
  elseif 2 == notifyType then
    local isWarehouseGet = FGlobal_GetDailyPay_WarehouseCheckReturn()
    local tempStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_MONEY_COLLECTION_INVEN", "money", makeDotMoney(param1))
    if true == isWarehouseGet then
      tempStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_MONEY_COLLECTION_WAREHOUSE", "money", makeDotMoney(param1))
    else
      tempStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_MONEY_COLLECTION_INVEN", "money", makeDotMoney(param1))
    end
    if 1 == param2 then
      Proc_ShowMessage_Ack(tempStr)
    end
  elseif 3 == notifyType then
    local tempStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_HIRE_RENEWAL", "userNickName", userNickName)
    Proc_ShowMessage_Ack(tempStr)
  elseif 4 == notifyType then
    local tempStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_EXPIRATION", "userNickName", userNickName)
    Proc_ShowMessage_Ack(tempStr)
  elseif 5 == notifyType then
    local periodDay = getTemporaryInformationWrapper():getContractedPeriodDay()
    local benefit = getTemporaryInformationWrapper():getContractedBenefit()
    local penalty = getTemporaryInformationWrapper():getContractedPenalty()
    local guildWrapper = ToClient_GetMyGuildInfoWrapper()
    if nil == guildWrapper then
      _PA_ASSERT(false, "\234\184\184\235\147\156\236\155\144\236\157\180 \234\179\160\236\154\169\234\179\132\236\149\189\236\132\156\235\165\188 \235\176\155\235\138\148\235\141\176 \234\184\184\235\147\156 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
      return
    end
    local guildName = guildWrapper:getName()
    FGlobal_AgreementGuild_Open(false, userNickName, characterName, guildName, periodDay, benefit, penalty, guildWrapper:getGuildNo_s64())
  elseif 6 == notifyType then
    local tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_PAYMENTS", "typeMoney", tostring(param2))
    if 0 ~= param1 then
      tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UNPAID", "typeMoney", tostring(param2))
    end
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_INCOMETAX", "type", tempTxt))
  elseif 7 == notifyType then
    local tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_LEAVE", "userNickName", userNickName)
    if param1 > 0 then
      tempTxt = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_PENALTIES", "tempTxt", tempTxt, "money", tostring(param1))
    end
    Proc_ShowMessage_Ack(tempTxt)
    if nil == PaGlobal_GuildPanelLoad_SetShowPanelGuildMain then
      Panel_Window_Guild:SetShow(false, true)
    else
      PaGlobal_GuildPanelLoad_SetShowPanelGuildMain(false, true)
    end
  elseif 8 == notifyType then
    local tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_FIRE", "userNickName", userNickName)
    if param1 > 0 then
      tempTxt = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_BONUS", "tempTxt", tempTxt, "money", tostring(param1))
    end
    Proc_ShowMessage_Ack(tempTxt)
  elseif 9 == notifyType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UPGRADES"))
  elseif 10 == notifyType then
  elseif 11 == notifyType then
    local text = ""
    if 1 == param3 then
      text = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_BESTMONEY", "money", makeDotMoney(s64_param1))
    else
      text = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_NOTBESTMONEY", "money", makeDotMoney(s64_param1))
    end
    Proc_ShowMessage_Ack(text)
  elseif 12 == notifyType then
    local text
    if 1 == param1 then
      text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_BIDCANCEL")
    else
      text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_BIDSUCCESS")
    end
    Proc_ShowMessage_Ack(text)
  elseif 13 == notifyType then
    if toInt64(0, 0) == s64_param1 then
      Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_USEGUILDSHOP_BUY", "userNickName", tostring(userNickName), "param2", makeDotMoney(s64_param2)))
    end
    if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= PaGlobalFunc_NPCShop_ALL_GetShow then
      if true == PaGlobalFunc_NPCShop_ALL_GetShow() and npcShop_isGuildShopContents() then
        PaGlobalFunc_NPCShop_ALL_UpdateMoney()
        return
      end
    elseif true == _ContentsGroup_RenewUI_NpcShop then
      if PaGlobalFunc_Dialog_NPCShop_IsShow() and npcShop_isGuildShopContents() then
        FromClient_Dialog_NPCShop_UpdateMoneyWarehouse()
        return
      end
    elseif Panel_Window_NpcShop:IsShow() and npcShop_isGuildShopContents() then
      NpcShop_UpdateMoneyWarehouse()
      return
    end
  elseif 14 == notifyType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_INCENTIVE"))
  elseif 15 == notifyType then
    local tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_PAYMENTS", "typeMoney", tostring(param2))
    if 0 ~= param1 then
      tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UNPAID", "typeMoney", tostring(param2))
    end
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_HOUSECOSTS", "tempTxt", tempTxt))
  elseif 16 == notifyType then
    local text = ""
    if 0 == param1 then
      text = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_CREATE_CLAN", "name", userNickName)
    else
      text = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_CREATE_GUILD", "name", userNickName)
    end
    Proc_ShowMessage_Ack(text)
  elseif 17 == notifyType then
    if false == ToClient_GetMessageFilter(9) then
      local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ACCEPT_GUILDQUEST")
      Proc_ShowMessage_Ack(text)
    end
  elseif 18 == notifyType then
    if false == ToClient_GetMessageFilter(9) then
      local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_COMPLETE_GUILDQUEST")
      Proc_ShowMessage_Ack(text)
    end
  elseif 19 == notifyType then
    local regionInfoWrapper = getRegionInfoWrapper(param2)
    if nil == regionInfoWrapper then
      _PA_ASSERT(false, "\236\132\177\236\163\188\234\176\128 \235\167\136\236\157\132\236\132\184\234\184\136\236\157\132 \236\136\152\234\184\136\237\150\136\235\138\148\235\141\176 \235\167\136\236\157\132 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
      return
    end
    local text = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_LORD_MOVETAX_TO_GUILDMONEY", "region", regionInfoWrapper:getAreaName(), "silver", makeDotMoney(s64_param1))
    Proc_ShowMessage_Ack(text)
  elseif 20 == notifyType then
  elseif 21 == notifyType then
    if CppEnums.GuildWarType.GuildWarType_Normal == ToClient_GetGuildWarType() then
      if param3 == 1 then
        local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ACCEPT_BATTLE_NO_RESOURCE")
        Proc_ShowMessage_Ack(text)
      else
        local tendency = param1
        local text = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_DECLARE_WAR_CONSUME", "silver", makeDotMoney(s64_param2))
        Proc_ShowMessage_Ack(text)
      end
    end
  elseif 22 == notifyType then
  elseif 23 == notifyType then
  elseif 24 == notifyType then
  elseif 25 == notifyType then
    if Panel_GuildWarInfo:GetShow() then
    end
  elseif 26 == notifyType then
    GuildQuestInfoPage:UpdateData()
  elseif 27 == notifyType then
  elseif 28 == notifyType then
    if 0 == param1 then
      local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMP_DOWN")
      Proc_ShowMessage_Ack(userNickName .. text)
    else
      local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMP_UP")
      Proc_ShowMessage_Ack(userNickName .. text)
    end
    if Panel_GuildWarInfo:GetShow() then
      FromClient_WarInfoContent_Set()
    end
  elseif 29 == notifyType then
    if 0 == param1 then
      local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_CHEER_GUILD")
      Proc_ShowMessage_Ack(userNickName .. text)
      FromClient_NotifySiegeScoreToLog()
    else
      FromClient_NotifySiegeScoreToLog()
    end
    if Panel_GuildWarInfo:GetShow() then
      FromClient_WarInfoContent_Set()
    end
  elseif 30 == notifyType then
    local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DONOT_GUILDQUEST")
    Proc_ShowMessage_Ack(text)
  elseif 31 == notifyType then
  elseif 32 == notifyType then
    local regionInfoWrapper = getRegionInfoWrapper(param3)
    local areaName = ""
    if nil ~= regionInfoWrapper then
      areaName = regionInfoWrapper:getAreaName()
    end
    local characterStaticStatusWarpper = getCharacterStaticStatusWarpper(param2)
    local characterName = ""
    if nil ~= characterStaticStatusWarpper then
      characterName = characterStaticStatusWarpper:getName()
    end
    local msg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BUILDING_AUTODESTROYBUILD", "areaName", areaName, "characterName", characterName)
    Proc_ShowMessage_Ack(msg)
  elseif 38 == notifyType then
    local tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDE_PAYPROPERTYTAX", "typeMoney", makeDotMoney(s64_param1))
    Proc_ShowMessage_Ack(tempTxt)
  elseif 39 == notifyType then
    local tempTxt = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_GETWELFARE", "typeMoney", makeDotMoney(s64_param1))
    Proc_ShowMessage_Ack(tempTxt)
  elseif 43 == notifyType then
    local tempTxt = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_NOTIFYWELFARE")
    Proc_ShowMessage_Ack(tempTxt)
  end
  FromClient_ResponseGuildUpdate()
end
function FromClient_NotifyGuildMessage(msgType, strParam1, strParam2, s64_param1, s64_param2, s64_param3)
  local param1 = Int64toInt32(s64_param1)
  local param2 = Int64toInt32(s64_param2)
  local param3 = Int64toInt32(s64_param3)
  if 0 == msgType then
    local message = ""
    if 0 == param1 then
      message = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_CLAN_OUT")
    else
      message = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_GUILD_OUT")
    end
    Proc_ShowMessage_Ack(message)
  elseif 1 == msgType then
    local message = ""
    if 0 == param1 then
      message = PAGetStringParam1(Defines.StringSheet_GAME, "GAME_MESSAGE_CLANMEMBER_OUT", "familyName", strParam1)
    else
      message = PAGetStringParam1(Defines.StringSheet_GAME, "GAME_MESSAGE_GUILDMEMBER_OUT", "familyName", strParam1)
    end
    Proc_ShowMessage_Ack(message)
  elseif 2 == msgType then
    local message = ""
    if 0 == param1 then
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_JOIN_GUILD", "name", strParam1)
    elseif 1 == param2 then
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_JOIN_VOLUNTEER", "name", strParam1)
    else
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_JOIN_GUILD", "name", strParam1)
    end
    Proc_ShowMessage_Ack(message)
  elseif 3 == msgType then
    local message = ""
    if 0 == param1 then
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_WHO_JOIN_CLAN", "name", strParam1)
    elseif 1 == param2 then
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_WHO_JOIN_VOLUNTEER", "name", strParam1)
    else
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_WHO_JOIN_GUILD", "name", strParam1)
    end
    Proc_ShowMessage_Ack(message)
  elseif 4 == msgType then
    local message = ""
    if 0 == param1 then
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_CLAN_MSG", "name", strParam1)
    else
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_GUILD_MSG", "name", strParam1)
    end
    Proc_ShowMessage_Ack(message)
  elseif 5 == msgType then
    local textGrade = ""
    if 0 == param1 then
      textGrade = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLAN")
    else
      textGrade = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD")
    end
    local message = ""
    if 0 == param2 then
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_EXPEL_SELF", "guild", strParam2)
    else
      message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_EXPEL_OTHER", "name", strParam1, "guild", strParam2)
    end
    Proc_ShowMessage_Ack(message)
  elseif 6 == msgType then
    local message = ""
    if param1 <= 30 and param2 > 30 then
      message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_COMPORATETAX_GUILDMEMBERCOUNT", "membercount", "30", "silver", PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERCOUNT_10"))
    elseif param1 <= 50 and param2 > 50 then
      message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_COMPORATETAX_GUILDMEMBERCOUNT", "membercount", "50", "silver", PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERCOUNT_25"))
    elseif param1 <= 75 and param2 > 75 then
      message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_COMPORATETAX_GUILDMEMBERCOUNT", "membercount", "75", "silver", PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERCOUNT_50"))
    else
      message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_INCREASE_GUILDMEMBERCOUNT", "membercount", param2)
    end
    Proc_ShowMessage_Ack(message)
  elseif 7 == msgType then
    local message = ""
    local characterName = strParam1
    local userNickName = strParam2
    if true == GameOption_ShowGuildLoginMessage() then
      if 0 == param1 then
        message = PAGetStringParam2(Defines.StringSheet_GAME, "GAME_MESSAGE_LOGIN_GUILD_MEMBER", "familyName", userNickName, "characterName", characterName)
      elseif 1 == param1 then
        message = PAGetStringParam2(Defines.StringSheet_GAME, "GAME_MESSAGE_LOGOUT_GUILD_MEMBER", "familyName", userNickName, "characterName", characterName)
      end
      Proc_ShowMessage_Ack(message)
    end
  elseif 8 == msgType then
    local message = ""
    local characterName = strParam1
    local userNickName = strParam2
  elseif 9 == msgType then
    local message = {}
    if param1 > 15 then
      message.main = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERLEVELUP_MAIN", "strParam1", strParam1, "param1", param1)
      message.sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBER_CHEER")
      message.addMsg = ""
      Proc_ShowMessage_Ack_For_RewardSelect(message, 3.2, 22)
    end
  elseif 10 == msgType then
    local message = {}
    if param1 <= 8 then
      local lifeLevel
      if _ContentsGroup_isUsedNewCharacterInfo == false then
        lifeLevel = FGlobal_CraftLevel_Replace(param2, param1)
      else
        lifeLevel = FGlobal_UI_CharacterInfo_Basic_Global_CraftLevelReplace(param2)
      end
      message.main = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERLIFELEVELUP_MAIN", "strParam1", strParam1, "param1", lifeType[param1], "lifeLevel", lifeLevel)
      message.sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBER_CHEER")
      message.addMsg = ""
      Proc_ShowMessage_Ack_For_RewardSelect(message, 3.2, 22)
    end
  elseif 11 == msgType then
    local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(param1))
    if itemSSW == nil then
      return
    end
    local itemName = itemSSW:getName()
    local itemClassify = itemSSW:getItemClassify()
    local enchantLevel = itemSSW:get()._key:getEnchantLevel()
    local enchantLevelHigh = 0
    if nil ~= enchantLevel and 0 ~= enchantLevel then
      if enchantLevel >= 16 then
        enchantLevelHigh = HighEnchantLevel_ReplaceString(enchantLevel)
      elseif CppEnums.ItemClassifyType.eItemClassify_Accessory == itemClassify then
        enchantLevelHigh = HighEnchantLevel_ReplaceString(enchantLevel + 15)
      else
        enchantLevelHigh = "+ " .. enchantLevel
      end
    end
    local message = {}
    message.main = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERENCHANTSUCCESS_MAIN1", "strParam1", strParam1, "param1", enchantLevelHigh, "strParam2", itemName)
    message.sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBER_CHEER")
    message.addMsg = ""
    Proc_ShowMessage_Ack_For_RewardSelect(message, 3.2, 22)
  elseif 12 == msgType then
    local message = ""
    message = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDDUELWILLBEEND")
    Proc_ShowMessage_Ack(message)
  elseif 13 == msgType then
    local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(param1))
    if itemSSW == nil then
      return
    end
    local itemName = itemSSW:getName()
    local itemClassify = itemSSW:getItemClassify()
    local enchantLevel = itemSSW:get()._key:getEnchantLevel()
    local enchantLevelHigh = 0
    if nil ~= enchantLevel and 0 ~= enchantLevel then
      if enchantLevel >= 16 then
        enchantLevelHigh = HighEnchantLevel_ReplaceString(enchantLevel)
      elseif CppEnums.ItemClassifyType.eItemClassify_Accessory == itemClassify then
        enchantLevelHigh = HighEnchantLevel_ReplaceString(enchantLevel + 15)
      else
        enchantLevelHigh = "+ " .. enchantLevel
      end
    end
    local message = {}
    message.main = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERPROMOTION_CAPHRAS", "strParam1", strParam1, "param1", enchantLevelHigh, "strParam2", itemName)
    message.sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBER_CHEER")
    message.addMsg = ""
    Proc_ShowMessage_Ack_For_RewardSelect(message, 3.2, 22)
  end
end
function FromClient_NotifyGuildMemberDoPk(attackerGuildName, attackerUserNickName, attackerCharacterName, deadGuildName, deadUserNickName, deadCharacterName)
  local text = ""
  local myGuildMember = attackerUserNickName .. "(" .. attackerCharacterName .. ")"
  local deadUser = deadUserNickName .. "(" .. deadCharacterName .. ")"
  if "" ~= deadGuildName then
    text = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILD_MEMBER_PK_DO_OTHER_GUILD_MEMBER", "username", myGuildMember, "GuildName", deadGuildName, "targetUserName", deadUser)
  else
    text = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_MEMBER_PK_DO", "username", myGuildMember, "deadUser", deadUser)
  end
  Proc_ShowMessage_Ack(text)
end
function FromClient_NotifyGuildMemberKilledOtherPlayer(attackerGuildName, attackerUserNickName, attackerCharacterName, deadGuildName, deadUserNickName, deadCharacterName)
  local text = ""
  local myGuildMember = attackerUserNickName .. "(" .. attackerCharacterName .. ")"
  local deadUser = deadUserNickName .. "(" .. deadCharacterName .. ")"
  do return end
  if "" ~= deadGuildName then
    text = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILD_MEMBER_KILLEDBY_OTHER_GUILD_MEMBER", "username", myGuildMember, "GuildName", deadGuildName, "targetUserName", deadUser)
  else
    text = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_MEMBER_KILLEDBY_PC", "username", myGuildMember, "deadUser", deadUser)
  end
  Proc_ShowMessage_Ack(text)
end
function FromClient_ResponseGuildInviteForGuildGrade(targetActorKeyRaw, targetName, preGuildActivity)
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    _PA_ASSERT(false, "ResponseGuildInviteForGuildGrade \236\151\144\236\132\156 \234\184\184\235\147\156 \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  if nil == targetName then
    _PA_ASSERT(false, "targetName \236\160\149\235\179\180\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  local guildGrade = myGuildInfo:getGuildGrade()
  if 0 == guildGrade then
    toClient_RequestInviteGuild(targetName, 0, 0, 0)
  else
    FGlobal_AgreementGuild_Master_Open_ForJoin(targetActorKeyRaw, targetName, preGuildActivity)
  end
end
function FromClient_ResponseDeclareGuildWarToMyGuild()
  if nil == Panel_Window_Guild then
    return
  end
  if Panel_Window_Guild:GetShow() and GuildWarInfoPage._btnWarList2:IsCheck() then
    GuildWarInfoPage:UpdateData()
  end
end
function SetDATAByGuildGrade()
  if nil == Panel_Window_Guild then
    return
  end
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local guildGrade = myGuildInfo:getGuildGrade()
  local memberData
  local memberCount = myGuildInfo:getMemberCount()
  for memberIdx = 0, memberCount - 1 do
    memberData = myGuildInfo:getMember(memberIdx)
    if memberData:isSelf() then
      break
    end
  end
  if nil == memberData then
    return
  end
  if 0 == guildGrade then
    GuildManager.mainBtn_Info:SetEnable(true)
    GuildManager.mainBtn_History:SetEnable(false)
    GuildManager.mainBtn_Quest:SetEnable(false)
    GuildManager.mainBtn_Tree:SetEnable(false)
    GuildManager.mainBtn_Warfare:SetEnable(false)
    GuildInfoPage._btnChangeMark:SetEnable(false)
    GuildLetsWarPage._btnLetsWarDoWar:SetEnable(false)
    GuildLetsWarPage._editLetsWarInputName:SetEnable(false)
    GuildManager.mainBtn_Info:SetMonoTone(false)
    GuildManager.mainBtn_History:SetMonoTone(true)
    GuildManager.mainBtn_Quest:SetMonoTone(true)
    GuildManager.mainBtn_Tree:SetMonoTone(true)
    GuildManager.mainBtn_Warfare:SetMonoTone(true)
    GuildInfoPage._btnChangeMark:SetMonoTone(true)
    GuildLetsWarPage._btnLetsWarDoWar:SetMonoTone(true)
    GuildLetsWarPage._editLetsWarInputName:SetMonoTone(true)
    GuildInfoPage._btnTaxPayment:SetShow(false)
    GuildInfoPage._txtUnpaidTax:SetShow(false)
    GuildInfoPage._btnIncreaseMember:SetShow(false)
    GuildListInfoPage._btnPaypal:SetShow(false)
    GuildListInfoPage._btnGiveIncentive:SetShow(false)
    GuildListInfoPage._btnDeposit:SetShow(false)
    GuildListInfoPage._textBusinessFundsBG:SetShow(false)
    GuildListInfoPage.decoIcon_Guild:SetShow(false)
    GuildListInfoPage.decoIcon_Clan:SetShow(true)
    GuildInfoPage._windowTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_CLANNAME"))
  else
    GuildManager.mainBtn_Info:SetEnable(true)
    GuildManager.mainBtn_History:SetEnable(true)
    GuildManager.mainBtn_Quest:SetEnable(true)
    GuildManager.mainBtn_Tree:SetEnable(true)
    GuildManager.mainBtn_Warfare:SetEnable(true)
    GuildInfoPage._btnChangeMark:SetEnable(true)
    GuildManager.mainBtn_Info:SetMonoTone(false)
    GuildManager.mainBtn_History:SetMonoTone(false)
    if isGameTypeEnglish() then
      GuildManager.mainBtn_Quest:SetMonoTone(true)
    else
      GuildManager.mainBtn_Quest:SetMonoTone(false)
    end
    GuildManager.mainBtn_Tree:SetMonoTone(false)
    GuildManager.mainBtn_Warfare:SetMonoTone(false)
    GuildInfoPage._btnChangeMark:SetMonoTone(false)
    GuildListInfoPage._btnDeposit:SetMonoTone(true)
    local accumulateTax_s64 = myGuildInfo:getAccumulateTax()
    local accumulateCost_s64 = myGuildInfo:getAccumulateGuildHouseCost()
    local businessFunds_s64 = myGuildInfo:getGuildBusinessFunds_s64()
    if accumulateTax_s64 > toInt64(0, 0) or accumulateCost_s64 > toInt64(0, 0) then
      GuildInfoPage._txtUnpaidTax:SetShow(true)
      if accumulateTax_s64 > businessFunds_s64 or accumulateCost_s64 > businessFunds_s64 then
        GuildListInfoPage._btnDeposit:SetMonoTone(false)
        GuildListInfoPage._btnDeposit:SetEnable(true)
      else
        GuildListInfoPage._btnDeposit:SetMonoTone(true)
        GuildListInfoPage._btnDeposit:SetEnable(false)
      end
    else
      GuildInfoPage._txtUnpaidTax:SetShow(false)
      GuildListInfoPage._btnDeposit:SetMonoTone(true)
      GuildListInfoPage._btnDeposit:SetEnable(false)
    end
    if getSelfPlayer():get():isGuildMaster() then
      if accumulateTax_s64 > toInt64(0, 0) or accumulateCost_s64 > toInt64(0, 0) then
        GuildInfoPage._btnTaxPayment:SetShow(true)
      else
        GuildInfoPage._btnTaxPayment:SetShow(false)
      end
      GuildListInfoPage._btnGiveIncentive:SetShow(true)
    elseif getSelfPlayer():get():isGuildSubMaster() then
      GuildInfoPage._btnIncreaseMember:SetShow(false)
      if accumulateTax_s64 > toInt64(0, 0) or accumulateCost_s64 > toInt64(0, 0) then
        GuildInfoPage._btnTaxPayment:SetShow(true)
      else
        GuildInfoPage._btnTaxPayment:SetShow(false)
      end
      GuildListInfoPage._btnGiveIncentive:SetShow(false)
    else
      GuildInfoPage._btnIncreaseMember:SetShow(false)
      GuildInfoPage._btnTaxPayment:SetShow(false)
      GuildListInfoPage._btnGiveIncentive:SetShow(false)
    end
    if memberData:isCollectableBenefit() and false == memberData:isFreeAgent() and toInt64(0, 0) < memberData:getContractedBenefit() then
      GuildListInfoPage._btnPaypal:SetEnable(true)
      GuildListInfoPage._btnPaypal:SetMonoTone(false)
      if toInt64(0, 0) == businessFunds_s64 then
        GuildListInfoPage._btnPaypal:SetFontColor(UI_color.C_FFF26A6A)
      else
        GuildListInfoPage._btnPaypal:SetFontColor(UI_color.C_FFEDEDEE)
      end
    else
      GuildListInfoPage._btnPaypal:SetEnable(false)
      GuildListInfoPage._btnPaypal:SetMonoTone(true)
    end
    if true == PaGlobalFunc_checkIsSelfVolunteer() then
      GuildListInfoPage._btnPaypal:SetShow(false)
    else
      GuildListInfoPage._btnPaypal:SetShow(true)
    end
    GuildListInfoPage._textBusinessFundsBG:SetShow(true)
    GuildListInfoPage.decoIcon_Guild:SetShow(true)
    GuildListInfoPage.decoIcon_Clan:SetShow(false)
    GuildInfoPage._windowTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_GUILDNAME"))
  end
end
function Guild_onScreenResize()
  if nil == Panel_Window_Guild then
    GuildManager._isResize = true
    return
  end
  Panel_Window_Guild:SetPosX(getScreenSizeX() / 2 - Panel_Window_Guild:GetSizeX() / 2)
  Panel_Window_Guild:SetPosY(getScreenSizeY() / 2 - Panel_Window_Guild:GetSizeY() / 2)
  GuildManager._isResize = false
end
local targetUserNo, targetGuildNo, targetGuildName
function FromClient_RequestGuildWar(userNo, guildNo, guildName)
  if MessageBox.isPopUp() and targetGuildNo == guildNo then
    return
  end
  if isGameTypeJapan() or isGameTypeKR2() then
    keyUseCheck = false
  end
  targetUserNo = userNo
  targetGuildNo = guildNo
  targetGuildName = guildName
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_DECLAREWAR", "guildName", targetGuildName)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = FGlobal_AcceptGuildWar,
    functionNo = FGlobal_RefuseGuildWar,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData, nil, nil, keyUseCheck)
end
function FGlobal_AcceptGuildWar()
  ToClient_RequestDeclareGuildWar(targetGuildNo, targetGuildName, true)
  targetUserNo = nil
  targetGuildNo = nil
  targetGuildName = nil
end
function FGlobal_RefuseGuildWar()
  ToClient_RequestRefuseGuildWar(targetUserNo, targetGuildName)
  targetUserNo = nil
  targetGuildNo = nil
  targetGuildName = nil
end
function HandleClickedGuildDuel(index)
  local guildWrapper = ToClient_GetWarringGuildListAt(index)
  local guildNo_s64 = guildWrapper:getGuildNo()
  FGlobal_GuildDuel_Open(guildNo_s64)
end
function HandleOnOut_GuildDuelInfo_Tooltip(isShow, idx)
  if isShow then
    local guildwarWrapper = ToClient_GetWarringGuildListAt(idx)
    local guildNo_s64 = guildwarWrapper:getGuildNo()
    local deadline = ToClient_GetGuildDuelDeadline_s64(guildNo_s64)
    local lefttimeText = convertStringFromDatetime(getLeftSecond_TTime64(deadline))
    local targetKillCount = ToClient_GetGuildDuelTargetKillByGuild(guildNo_s64)
    local fightMoney_s64 = ToClient_GetGuildDuelPrizeByGuild_s64(guildNo_s64)
    local control = GuildWarInfoPage._list[idx]._guildShowbuScore
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDDUEL_INFOTOOLTIP_TITLE")
    local desc = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILD_GUILDDUEL_INFOTOOLTIP_DESC", "targetKillCount", targetKillCount, "fightMoney", makeDotMoney(fightMoney_s64), "time", lefttimeText)
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function Notice_Init()
  if nil == Panel_Window_Guild then
    return
  end
  GuildInfoPage.notice_edit:SetMaxInput(40)
  GuildInfoPage.notice_btn:addInputEvent("Mouse_LUp", "Notice_Regist()")
  GuildInfoPage.notice_edit:addInputEvent("Mouse_LUp", "HandleClicked_NoticeEditSetFocus()")
  GuildInfoPage.notice_edit:RegistReturnKeyEvent("Notice_Regist()")
end
function Notice_Regist()
  if nil == Panel_Window_Guild then
    return
  end
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  if false == isGuildMaster and false == isGuildSubMaster then
    return
  end
  local close_function = function()
    CheckChattingInput()
  end
  ToClient_RequestSetGuildNotice(tostring(GuildInfoPage.notice_edit:GetEditText()))
  close_function()
  ClearFocusEdit()
end
function HandleClicked_NoticeEditSetFocus()
  if nil == Panel_Window_Guild then
    return
  end
  SetFocusEdit(GuildInfoPage.notice_edit)
  GuildInfoPage.notice_edit:SetEditText(GuildInfoPage.notice_edit:GetEditText(), true)
end
function FromClient_ResponseGuildNotice()
  if nil == Panel_Window_Guild then
    return
  end
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil == guildWrapper then
    return
  end
  local guildNotice = guildWrapper:getGuildNotice()
  GuildInfoPage.notice_edit:SetEditText(guildNotice, false)
end
function FGlobal_Notice_Update()
  FGlobal_Notice_AuthorizationUpdate()
end
function FGlobal_Notice_AuthorizationUpdate()
  if nil == Panel_Window_Guild then
    return
  end
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  if true == isGuildMaster or true == isGuildSubMaster then
    GuildInfoPage.notice_edit:SetIgnore(false)
  else
    GuildInfoPage.notice_edit:SetIgnore(true)
  end
end
function FGlobal_GuildNoticeClearFocusEdit()
  ClearFocusEdit()
  CheckChattingInput()
end
function FGlobal_CheckGuildNoticeUiEdit(targetUI)
  if nil == Panel_Window_Guild then
    return false
  end
  return nil ~= targetUI and targetUI:GetKey() == GuildInfoPage.notice_edit:GetKey()
end
function Introduce_Init()
  if nil == Panel_Window_Guild then
    return
  end
  if isGameTypeTaiwan() then
    GuildInfoPage._introduce_edit_TW:SetMaxEditLine(7)
  else
    GuildInfoPage._introduce_edit:SetMaxEditLine(10)
  end
  GuildInfoPage._introduce_edit:SetMaxInput(200)
  GuildInfoPage._introduce_edit_TW:SetMaxInput(200)
  GuildInfoPage._promote_btn:addInputEvent("Mouse_LUp", "Guild_Promote_Confirm()")
  GuildInfoPage._promote_btn:addInputEvent("Mouse_On", "Promote_Tooltip(true)")
  GuildInfoPage._promote_btn:addInputEvent("Mouse_Out", "Promote_Tooltip(false)")
  GuildInfoPage._introduce_btn:addInputEvent("Mouse_LUp", "Introduce_Regist()")
  GuildInfoPage._introduce_Reset:addInputEvent("Mouse_LUp", "Introduce_Reset()")
  GuildInfoPage._introduce_edit:addInputEvent("Mouse_LUp", "HandleClicked_IntroduceEditSetFocus()")
  GuildInfoPage._introduce_edit_TW:addInputEvent("Mouse_LUp", "HandleClicked_IntroduceEditSetFocus()")
end
function HandleClicked_IntroduceEditSetFocus()
  if nil == Panel_Window_Guild then
    return
  end
  if isGameTypeTaiwan() then
    SetFocusEdit(GuildInfoPage._introduce_edit_TW)
    GuildInfoPage._introduce_edit_TW:SetEditText(GuildInfoPage._introduce_edit_TW:GetEditText(), true)
  else
    SetFocusEdit(GuildInfoPage._introduce_edit)
    GuildInfoPage._introduce_edit:SetEditText(GuildInfoPage._introduce_edit:GetEditText(), true)
  end
end
function FGlobal_GuildIntroduceClearFocusEdit()
  ClearFocusEdit()
  CheckChattingInput()
end
function Guild_Promote_Confirm()
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PROMOTE_BTN_MESSAGE_DESC")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = Guild_Promote,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function Guild_Promote()
  local selfProxy = getSelfPlayer():get()
  local isGuildMaster = selfProxy:isGuildMaster()
  local isGuildSubMaster = selfProxy:isGuildSubMaster()
  if false == isGuildMaster and false == isGuildSubMaster then
    return
  end
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  local guildIntroduce = guildWrapper:getGuildIntrodution()
  ToClient_SetLinkedGuildInfoByGuild()
  chatting_sendMessageNoMatterEmpty("", guildIntroduce, CppEnums.ChatType.World)
end
function Promote_Tooltip(isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if nil == Panel_Window_Guild then
    return
  end
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PROMOTE_BTN_TITLE")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PROMOTE_BTN_DESC")
  control = GuildInfoPage._promote_btn
  TooltipSimple_Show(control, name, desc)
end
function Introduce_Regist()
  if nil == Panel_Window_Guild then
    return
  end
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  if false == isGuildMaster and false == isGuildSubMaster then
    return
  end
  local close_function = function()
    CheckChattingInput()
  end
  if isGameTypeTaiwan() then
    ToClient_RequestSetIntrodution(tostring(GuildInfoPage._introduce_edit_TW:GetEditText()))
  else
    ToClient_RequestSetIntrodution(tostring(GuildInfoPage._introduce_edit:GetEditText()))
  end
  close_function()
  ClearFocusEdit()
end
function Introduce_Reset()
  if nil == Panel_Window_Guild then
    return
  end
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  if false == isGuildMaster and false == isGuildSubMaster then
    return
  end
  if isGameTypeTaiwan() then
    GuildInfoPage._introduce_edit_TW:SetEditText("", true)
  else
    GuildInfoPage._introduce_edit:SetEditText("", true)
  end
  ToClient_RequestSetIntrodution(tostring(""))
end
function GuildIntroduce_Update()
  if nil == Panel_Window_Guild then
    return
  end
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil == guildWrapper then
    return
  end
  local guildIntroduce = guildWrapper:getGuildIntrodution()
  if isGameTypeTaiwan() then
    GuildInfoPage._introduce_edit_TW:SetEditText(guildIntroduce, false)
  else
    GuildInfoPage._introduce_edit:SetEditText(guildIntroduce, false)
  end
end
function FGlobal_CheckGuildIntroduceUiEdit(targetUI)
  if nil == Panel_Window_Guild then
    return false
  end
  if isGameTypeTaiwan() then
    return nil ~= targetUI and targetUI:GetKey() == GuildInfoPage._introduce_edit_TW:GetKey()
  else
    return nil ~= targetUI and targetUI:GetKey() == GuildInfoPage._introduce_edit:GetKey()
  end
end
function FromWeb_WebPageError(url, statusCode)
  if nil == Panel_Window_Guild then
    return
  end
  if 200 ~= statusCode then
    return
  end
  if _urlCache ~= url then
    return
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local startIndex = string.find(url, "?")
  if nil ~= startIndex then
    local _url = string.sub(url, 1, startIndex - 1)
    if PaGlobal_URL_Check(worldNo) == _url then
      GuildInfoPage._Web:SetShow(true)
      return
    end
  end
  GuildInfoPage._Web:SetShow(false)
end
function HandleClickedGetArshaHost()
  if false == isContentsArsha or false == isCanDoReservation then
    return
  end
  local isHost = ToClient_IsCompetitionHost()
  local messageBoxMemo = ""
  local func = function()
    ToClient_RequestGetHostByReservationInfo()
  end
  if false == isHost then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_LENT_ARSHAHOST")
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_RELEASE_ARSHAHOST")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = func,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function Guild_PopUp_ShowIconToolTip(isShow)
  if isShow then
    if nil == Panel_Window_Guild then
      return
    end
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
    local desc = ""
    if GuildInfoPage.checkPopUp:IsCheck() then
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_CHECK_TOOLTIP")
    else
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_NOCHECK_TOOLTIP")
    end
    TooltipSimple_Show(GuildInfoPage.checkPopUp, name, desc)
  else
    TooltipSimple_Hide()
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_Guild_Init")
function FromClient_Guild_Init()
  PaGlobal_Guild_initialize()
  GuildManager:registMessageHandler()
end
function PaGlobal_Guild_initialize()
  GuildManager:initialize()
  GuildMainInfo_Show()
  Notice_Init()
  Introduce_Init()
end
function PaGlobal_Guild_SavePosFromPanelPos()
  if nil == Panel_Window_Guild then
    return
  end
  GuildManager._savePos = float2(Panel_Window_Guild:GetPosX(), Panel_Window_Guild:GetPosY())
end
function PaGlobal_Guild_SetPanelPosFromSavePos()
  if nil == Panel_Window_Guild then
    return
  end
  if true == GuildManager._isResize then
    Guild_onScreenResize()
  else
    Panel_Window_Guild:SetPosX(GuildManager._savePos.x)
    Panel_Window_Guild:SetPosY(GuildManager._savePos.y)
  end
end
function Test_GiveMeGuildWelfare()
  ToClient_RequestguildWelfare()
end
function GuildInfoPage:getShowPanel()
  if nil == PaGlobal_GuildPanelLoad_GetShowPanelGuildMain then
    return Panel_Window_Guild:GetShow()
  else
    return PaGlobal_GuildPanelLoad_GetShowPanelGuildMain()
  end
end

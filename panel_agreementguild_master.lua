local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local _memberIndex = -1
local _isJoin = false
local _targetActorKeyRaw = 0
local _targetName = ""
local isRenew = false
local AgreementGuild_Master = {
  btn_Send = nil,
  btn_Refuse = nil,
  btn_Close = nil,
  title = nil,
  txt_GuildName = nil,
  radioBtnPeriod = nil,
  penaltyCostTitle = nil,
  dailyPaymentTitle = nil,
  remainPeriodTitle = nil,
  remainPeriod = nil,
  dailyPayment = nil,
  penaltyCost = nil,
  btnRenew = nil,
  from = nil,
  to = nil,
  guildMark = nil,
  dailyPayment_edit = nil,
  penaltyCost_edit = nil,
  memberBenefit = 0,
  memberPenalty = 0,
  maxDailyPayment = nil,
  maxpenaltyCost = nil,
  _frame = nil,
  _frame_Content = nil,
  _frame_Summary = nil,
  usableActivity = 0,
  maxBenefitValue = 0,
  maxpenaltyCostValue = 0
}
local periodValue = {
  [0] = 0,
  [1] = 1,
  [2] = 7,
  [3] = 14,
  [4] = 30,
  [5] = 180,
  [6] = 365
}
local paymentPerDay = {
  [0] = 0,
  [1] = 1000,
  [2] = 7000,
  [3] = 14000,
  [4] = 30000,
  [5] = 180000,
  [6] = 365000
}
local cancellationCharge = {
  [0] = 0,
  [1] = 500,
  [2] = 3500,
  [3] = 7000,
  [4] = 15000,
  [5] = 90000,
  [6] = 182500
}
function HandleClicked_AgreementGuild_Master_SetData(index)
  if nil == Panel_AgreementGuild_Master then
    return
  end
  local self = AgreementGuild_Master
  self._radioBtn_Period[index]:SetCheck(true)
  if _isJoin then
    self.dailyPayment:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(paymentPerDay[index])))
    self.penaltyCost:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(cancellationCharge[index])))
  else
    local usableActivity = self.usableActivity
    local tempBenefit32 = Int64toInt32(self.memberBenefit)
    local tempPenalty32 = Int64toInt32(self.memberPenalty)
    local useBenefit = 0
    if tempBenefit32 < paymentPerDay[index] then
      useBenefit = paymentPerDay[index]
    else
      useBenefit = tempBenefit32
    end
    local usePenalty = 0
    if tempPenalty32 < cancellationCharge[index] then
      usePenalty = cancellationCharge[index]
    else
      usePenalty = tempPenalty32
    end
    self.maxBenefitValue = useBenefit + useBenefit * (usableActivity / 100 / 100)
    self.maxpenaltyCostValue = usePenalty + usePenalty * (usableActivity / 100 / 100)
    AgreementGuild_SetMaxDailyPayment(paymentPerDay[index], self.maxBenefitValue)
    AgreementGuild_SetMaxPenalty(cancellationCharge[index], self.maxpenaltyCostValue)
    self.dailyPayment_edit:SetEditText(tostring(self.memberBenefit))
    self.penaltyCost_edit:SetEditText(tostring(self.memberPenalty))
  end
end
function AgreementGuild_Master:Initialize()
  if nil == Panel_AgreementGuild_Master then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_AgreementGuild_Master:SetShow(false)
  end
  AgreementGuild_Master.btn_Send = UI.getChildControl(Panel_AgreementGuild_Master, "Button_Confirm")
  AgreementGuild_Master.btn_Refuse = UI.getChildControl(Panel_AgreementGuild_Master, "Button_Refuse")
  AgreementGuild_Master.btn_Close = UI.getChildControl(Panel_AgreementGuild_Master, "Button_Close")
  AgreementGuild_Master.title = UI.getChildControl(Panel_AgreementGuild_Master, "StaticText_AgreementContentTitle")
  AgreementGuild_Master.txt_GuildName = UI.getChildControl(Panel_AgreementGuild_Master, "StaticText_AgreementSummaryTitle")
  AgreementGuild_Master.radioBtnPeriod = UI.getChildControl(Panel_AgreementGuild_Master, "RadioButton_Period")
  AgreementGuild_Master.penaltyCostTitle = UI.getChildControl(Panel_AgreementGuild_Master, "StaticText_PenaltyCost")
  AgreementGuild_Master.dailyPaymentTitle = UI.getChildControl(Panel_AgreementGuild_Master, "StaticText_DailyPayment")
  AgreementGuild_Master.remainPeriodTitle = UI.getChildControl(Panel_AgreementGuild_Master, "StaticText_Period")
  AgreementGuild_Master.remainPeriod = UI.getChildControl(Panel_AgreementGuild_Master, "StaticText_PeriodValue")
  AgreementGuild_Master.dailyPayment = UI.getChildControl(Panel_AgreementGuild_Master, "StaticText_PaymentValue")
  AgreementGuild_Master.penaltyCost = UI.getChildControl(Panel_AgreementGuild_Master, "StaticText_PenaltyCostValue")
  AgreementGuild_Master.btnRenew = UI.getChildControl(Panel_AgreementGuild_Master, "Button_Period_Renew")
  AgreementGuild_Master.from = UI.getChildControl(Panel_AgreementGuild_Master, "StaticText_From")
  AgreementGuild_Master.to = UI.getChildControl(Panel_AgreementGuild_Master, "StaticText_To")
  AgreementGuild_Master.guildMark = UI.getChildControl(Panel_AgreementGuild_Master, "Static_GuildMark")
  AgreementGuild_Master.dailyPayment_edit = UI.getChildControl(Panel_AgreementGuild_Master, "Edit_Payment")
  AgreementGuild_Master.penaltyCost_edit = UI.getChildControl(Panel_AgreementGuild_Master, "Edit_PenaltyCost")
  AgreementGuild_Master.maxDailyPayment = UI.getChildControl(Panel_AgreementGuild_Master, "StaticText_MaxPayment")
  AgreementGuild_Master.maxpenaltyCost = UI.getChildControl(Panel_AgreementGuild_Master, "StaticText_MaxPenaltyCost")
  AgreementGuild_Master._frame = UI.getChildControl(Panel_AgreementGuild_Master, "Frame_1")
  AgreementGuild_Master._frame_Content = UI.getChildControl(AgreementGuild_Master._frame, "Frame_1_Content")
  AgreementGuild_Master._frame_Summary = UI.getChildControl(AgreementGuild_Master._frame_Content, "StaticText_1")
  AgreementGuild_Master._frame_Summary:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  if isGameTypeEnglish() then
    self.dailyPayment_edit:SetSpanSize(180, self.dailyPayment_edit:GetSpanSize().y)
    self.penaltyCost_edit:SetSpanSize(180, self.penaltyCost_edit:GetSpanSize().y)
    self.penaltyCostTitle:SetSpanSize(50, self.penaltyCostTitle:GetSpanSize().y)
    self.dailyPaymentTitle:SetSpanSize(50, self.dailyPaymentTitle:GetSpanSize().y)
    self.remainPeriodTitle:SetSpanSize(50, self.remainPeriodTitle:GetSpanSize().y)
  else
    self.dailyPayment_edit:SetSpanSize(170, self.dailyPayment_edit:GetSpanSize().y)
    self.penaltyCost_edit:SetSpanSize(170, self.penaltyCost_edit:GetSpanSize().y)
    self.penaltyCostTitle:SetSpanSize(75, self.penaltyCostTitle:GetSpanSize().y)
    self.dailyPaymentTitle:SetSpanSize(75, self.dailyPaymentTitle:GetSpanSize().y)
    self.remainPeriodTitle:SetSpanSize(75, self.remainPeriodTitle:GetSpanSize().y)
  end
  AgreementGuild_Master._radioBtn_Period = {}
  for index = 0, 6 do
    AgreementGuild_Master._radioBtn_Period[index] = {}
    AgreementGuild_Master._radioBtn_Period[index] = UI.createControl(UCT.PA_UI_CONTROL_RADIOBUTTON, Panel_AgreementGuild_Master, "RadioButton_Period_" .. index)
    CopyBaseProperty(AgreementGuild_Master.radioBtnPeriod, AgreementGuild_Master._radioBtn_Period[index])
    AgreementGuild_Master._radioBtn_Period[index]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_DAY", "day", periodValue[index]))
    AgreementGuild_Master._radioBtn_Period[index]:SetPosX((AgreementGuild_Master.radioBtnPeriod:GetPosX() + 90) * index)
    AgreementGuild_Master._radioBtn_Period[index]:SetPosY(700)
    AgreementGuild_Master._radioBtn_Period[index]:SetShow(false)
    AgreementGuild_Master._radioBtn_Period[index]:addInputEvent("Mouse_LUp", "HandleClicked_AgreementGuild_Master_SetData(" .. index .. ")")
  end
  AgreementGuild_Master:registEventHandler()
end
function AgreementGuild_Master:Update()
  if nil == Panel_AgreementGuild_Master then
    return
  end
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  local guildName = guildWrapper:getName()
  self.title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_2"))
  self.txt_GuildName:SetText("[" .. tostring(guildName) .. "]")
  local isSet = setGuildTextureByGuildNo(guildWrapper:getGuildNo_s64(), self.guildMark)
  if false == isSet then
    self.guildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self.guildMark, 183, 1, 188, 6)
    self.guildMark:getBaseTexture():setUV(x1, y1, x2, y2)
    self.guildMark:setRenderTexture(self.guildMark:getBaseTexture())
  else
    self.guildMark:getBaseTexture():setUV(0, 0, 1, 1)
    self.guildMark:setRenderTexture(self.guildMark:getBaseTexture())
  end
  AgreementGuild_Master._frame_Summary:SetAutoResize()
  AgreementGuild_Master._frame_Summary:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_3"))
  AgreementGuild_Master._frame_Content:SetSize(AgreementGuild_Master._frame_Content:GetSizeX(), AgreementGuild_Master._frame_Summary:GetTextSizeY())
  self._frame:UpdateContentPos()
  if AgreementGuild_Master._frame_Content:GetSizeY() < self._frame:GetSizeY() then
    self._frame:GetVScroll():SetShow(false)
  else
    self._frame:GetVScroll():SetShow(true)
  end
end
function AgreementGuild_Master:SetPosition()
  if nil == Panel_AgreementGuild_Master then
    return
  end
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_AgreementGuild_Master:GetSizeX()
  local panelSizeY = Panel_AgreementGuild_Master:GetSizeY()
  Panel_AgreementGuild_Master:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Panel_AgreementGuild_Master:SetPosY(scrSizeY / 2 - panelSizeY / 2)
end
function AgreementGuild_Master:SetShowContractPreSet(isShow)
  if nil == Panel_AgreementGuild_Master then
    return
  end
  local self = AgreementGuild_Master
  local usableActivity = self.usableActivity
  local startRadioIndex = 0
  if true == _isJoin then
    startRadioIndex = 0
  else
    startRadioIndex = 1
  end
  local sumIndex = 0
  for index = startRadioIndex, #periodValue do
    self._radioBtn_Period[index]:SetPosX(self.radioBtnPeriod:GetPosX() + 65 * sumIndex)
    self._radioBtn_Period[index]:SetPosY(self.remainPeriodTitle:GetPosY() + self.remainPeriodTitle:GetTextSizeY() + 5)
    self._radioBtn_Period[index]:SetShow(true)
    self._radioBtn_Period[index]:SetEnableArea(0, 0, self._radioBtn_Period[index]:GetSizeX() + self._radioBtn_Period[index]:GetTextSizeX(), self._radioBtn_Period[index]:GetSizeY())
    self._radioBtn_Period[index]:SetCheck(false)
    sumIndex = sumIndex + 1
  end
  self.dailyPayment:SetShow(true)
  self.penaltyCost:SetShow(true)
  if isShow then
    HandleClicked_AgreementGuild_Master_SetData(4)
  end
  self.dailyPayment_edit:SetShow(not isShow)
  self.penaltyCost_edit:SetShow(not isShow)
  self.maxDailyPayment:SetShow(not isShow)
  self.maxpenaltyCost:SetShow(not isShow)
end
function AgreementGuild_Master:SetHideContractControl()
  if nil == Panel_AgreementGuild_Master then
    return
  end
  local self = AgreementGuild_Master
  for i = 0, #periodValue do
    self._radioBtn_Period[i]:SetShow(false)
    self._radioBtn_Period[i]:SetCheck(false)
  end
  self.dailyPayment_edit:SetShow(false)
  self.penaltyCost_edit:SetShow(false)
  self.maxDailyPayment:SetShow(false)
  self.maxpenaltyCost:SetShow(false)
end
function FGlobal_AgreementGuild_Master_Open_ForJoin(targetKeyRaw, targetName, preGuildActivity)
  PaGlobal_AgreementGuildMaster_CheckLoadUI()
  _targetActorKeyRaw = targetKeyRaw
  _isJoin = true
  _targetName = targetName
  local self = AgreementGuild_Master
  local textTemp = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_FORJOIN", "targetName", targetName)
  self.to:SetText(textTemp)
  self.btn_Send:SetShow(true)
  self.btn_Refuse:SetShow(true)
  self.remainPeriod:SetShow(false)
  self:SetShowContractPreSet(true)
  self.btnRenew:SetShow(false)
  self.btn_Close:SetShow(false)
  AgreementGuild_Master:Update()
  AgreementGuild_Master:SetPosition()
end
function FGlobal_AgreementGuild_Master_Open(memberIndex, requesterMemberGrade, usableActivity)
  if true == PaGlobal_GuildGetDailyPay_GetShow() then
    PaGlobal_GuildGetDailyPay_CheckCloseUI()
  end
  PaGlobal_AgreementGuildMaster_CheckLoadUI()
  local self = AgreementGuild_Master
  _isJoin = false
  if usableActivity > 10000 then
    usableActivity = 10000
  end
  self.usableActivity = usableActivity
  local memberInfo = ToClient_GetMyGuildInfoWrapper():getMember(memberIndex)
  if nil == memberInfo then
    _PA_ASSERT(false, "FGlobal_AgreementGuild_Master_Open \236\157\152 \235\169\164\235\178\132\236\157\184\235\141\177\236\138\164\234\176\128 \235\185\132\236\160\149\236\131\129\236\158\133\235\139\136\235\139\164 " .. tostring(memberIndex))
  end
  _memberIndex = memberIndex
  local name = memberInfo:getName()
  local expiration = memberInfo:getContractedExpirationUtc()
  self.memberBenefit = memberInfo:getContractedBenefit()
  self.memberPenalty = memberInfo:getContractedPenalty()
  local temp1
  if 0 < Int64toInt32(getLeftSecond_TTime64(expiration)) then
    temp1 = convertStringFromDatetime(getLeftSecond_TTime64(expiration))
  else
    temp1 = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_REMAINPERIOD")
  end
  self:SetHideContractControl()
  self.remainPeriod:SetShow(true)
  self.remainPeriod:SetText(temp1)
  self.dailyPayment:SetShow(true)
  self.penaltyCost:SetShow(true)
  self.dailyPayment:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(self.memberBenefit)))
  self.penaltyCost:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(self.memberPenalty)))
  _targetName = name
  local textTemp = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_FORJOIN", "targetName", name)
  self.to:SetText(textTemp)
  self.btn_Send:SetShow(false)
  self.btn_Refuse:SetShow(false)
  self.btn_Close:SetShow(true)
  isRenew = false
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
    isRenew = (2 == memberInfo:getGrade() or 5 == memberInfo:getGrade()) and contractAbleTo
  else
    isRenew = false
  end
  if false == memberInfo:isOnline() or true == memberInfo:isGhostMode() then
    isRenew = false
  end
  self.btnRenew:SetShow(isRenew)
  AgreementGuild_Master:Update()
  AgreementGuild_Master:SetPosition()
end
function FGlobal_Add_Contract_juniorTimeText(year, month, day)
  if nil == Panel_AgreementGuild_Master then
    return
  end
  local self = AgreementGuild_Master
  local juniorTimeStr = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_JUNIOR_UPGRADE_REMAIN_TIME_CONTRACT_ADD_TEXT", "year", year, "month", month, "day", day)
  AgreementGuild_Master._frame_Summary:SetAutoResize()
  AgreementGuild_Master._frame_Summary:SetText(juniorTimeStr .. [[


]] .. AgreementGuild_Master._frame_Summary:GetText())
  AgreementGuild_Master._frame_Content:SetSize(AgreementGuild_Master._frame_Content:GetSizeX(), AgreementGuild_Master._frame_Summary:GetTextSizeY())
  self._frame:UpdateContentPos()
  if AgreementGuild_Master._frame_Content:GetSizeY() < self._frame:GetSizeY() then
    self._frame:GetVScroll():SetShow(false)
  else
    self._frame:GetVScroll():SetShow(true)
  end
end
function agreementGuild_Master_Close()
  if false == PaGlobal_AgreementGuildMaster_GetShow() then
    return
  end
  PaGlobal_AgreementGuildMaster_CheckCloseUI()
  ClearFocusEdit()
  CheckChattingInput()
  HandleCLicked_AgreementGuildMaster()
  SetDATAByGuildGrade()
end
function agreementGuild_Master_Send()
  if nil == Panel_AgreementGuild_Master then
    return
  end
  local self = AgreementGuild_Master
  local value_ContractPeriod, value_DailyPayment, value_PenaltyCost
  if self.dailyPayment_edit:GetShow() then
    value_DailyPayment = tonumber(self.dailyPayment_edit:GetEditText())
    value_PenaltyCost = tonumber(self.penaltyCost_edit:GetEditText())
    if nil == value_DailyPayment then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_DAILYMONEY"))
      return
    end
    if nil == value_PenaltyCost then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_PENALTIES"))
      return
    end
    if value_DailyPayment > CppEnums.GuildBenefit.eMaxContractedBenefit then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_DAILYMONEY_TOOMUCH"))
      return
    end
    if value_PenaltyCost > CppEnums.GuildBenefit.eMaxContractedPenalty then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_BREACH_TOOMUCH"))
      return
    end
  else
    for i = 0, #periodValue do
      if self._radioBtn_Period[i]:IsCheck() then
        value_ContractPeriod = periodValue[i]
        value_DailyPayment = paymentPerDay[i]
        value_PenaltyCost = cancellationCharge[i]
      end
    end
  end
  for i = 0, #periodValue do
    if self._radioBtn_Period[i]:IsCheck() then
      value_ContractPeriod = periodValue[i]
    end
  end
  if nil == value_ContractPeriod then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_PERIOD_EDIT"))
    return
  end
  if false == _isJoin then
    if value_ContractPeriod <= 0 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_PERIOD_EDIT"))
      return
    end
    local checkedIndex = _AgreementGuild_Master_ReturnCheckedNum()
    if value_DailyPayment < paymentPerDay[checkedIndex] then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_DAILYMONEY_LESS"))
      return
    elseif value_DailyPayment > self.maxBenefitValue then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_DAILYMONEY_TOOMUCH"))
      return
    elseif value_PenaltyCost < cancellationCharge[checkedIndex] then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_BREACH_LESS"))
      return
    elseif value_PenaltyCost > self.maxpenaltyCostValue then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_BREACH_TOOMUCH"))
      return
    end
  end
  if _isJoin then
    toClient_RequestInviteGuild(_targetName, value_ContractPeriod, value_DailyPayment, value_PenaltyCost)
  else
    ToClient_SuggestGuildContract(_memberIndex, value_ContractPeriod, value_DailyPayment, value_PenaltyCost)
  end
  agreementGuild_Master_Close()
end
function FromClient_Agreement_Result()
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_ACK_MSG", "familyName", _targetName))
end
function HandleClicked_AgreementGuild_Master_SetEditBox(type)
  if nil == Panel_AgreementGuild_Master then
    return
  end
  local self = AgreementGuild_Master
  local control
  if 0 == type then
    control = self.dailyPayment_edit
  elseif 1 == type then
    control = self.penaltyCost_edit
  elseif 2 == type then
  end
  control:SetEditText("", true)
end
function _AgreementGuild_Master_ReturnCheckedNum()
  if nil == Panel_AgreementGuild_Master then
    return
  end
  local self = AgreementGuild_Master
  for idx = 1, #periodValue do
    local isCheck = self._radioBtn_Period[idx]:IsCheck()
    if true == isCheck then
      return idx
    end
  end
end
function HandleClicked_AgreementGuild_Master_Renew()
  if nil == Panel_AgreementGuild_Master then
    return
  end
  local self = AgreementGuild_Master
  local usableActivity = self.usableActivity
  local memberInfo = ToClient_GetMyGuildInfoWrapper():getMember(_memberIndex)
  if nil == memberInfo then
    _PA_ASSERT(false, "FGlobal_AgreementGuild_Master_Open \236\157\152 \235\169\164\235\178\132\236\157\184\235\141\177\236\138\164\234\176\128 \235\185\132\236\160\149\236\131\129\236\158\133\235\139\136\235\139\164 " .. tostring(memberIndex))
  end
  local name = memberInfo:getName()
  local expiration = memberInfo:getContractedExpirationUtc()
  self.memberBenefit = memberInfo:getContractedBenefit()
  self.memberPenalty = memberInfo:getContractedPenalty()
  local temp1
  if 0 < Int64toInt32(getLeftSecond_TTime64(expiration)) then
    temp1 = convertStringFromDatetime(getLeftSecond_TTime64(expiration))
  else
    temp1 = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_REMAINPERIOD")
  end
  self.remainPeriod:SetShow(false)
  local tempBenefit32 = Int64toInt32(self.memberBenefit)
  local tempPenalty32 = Int64toInt32(self.memberPenalty)
  self:SetShowContractPreSet(false)
  self.dailyPayment_edit:SetEditText(tostring(tempBenefit32))
  self.penaltyCost_edit:SetEditText(tostring(tempPenalty32))
  self._radioBtn_Period[4]:SetCheck(true)
  local checkedIndex = _AgreementGuild_Master_ReturnCheckedNum()
  local useBenefit = 0
  if tempBenefit32 < paymentPerDay[checkedIndex] then
    useBenefit = paymentPerDay[checkedIndex]
  else
    useBenefit = tempBenefit32
  end
  local usePenalty = 0
  if tempPenalty32 < cancellationCharge[checkedIndex] then
    usePenalty = cancellationCharge[checkedIndex]
  else
    usePenalty = tempPenalty32
  end
  self.maxBenefitValue = useBenefit + useBenefit * (usableActivity / 100 / 100)
  self.maxpenaltyCostValue = usePenalty + usePenalty * (usableActivity / 100 / 100)
  AgreementGuild_SetMaxDailyPayment(paymentPerDay[checkedIndex], self.maxBenefitValue)
  AgreementGuild_SetMaxPenalty(cancellationCharge[checkedIndex], self.maxpenaltyCostValue)
  self.dailyPayment:SetShow(false)
  self.penaltyCost:SetShow(false)
  self.btnRenew:SetShow(false)
  self.btn_Send:SetShow(true)
  self.btn_Refuse:SetShow(true)
  self.btn_Close:SetShow(false)
  HandleClicked_AgreementGuild_Master_SetData(4)
end
function AgreementGuild_Master:registEventHandler()
  if nil == Panel_AgreementGuild_Master then
    return
  end
  self.btn_Send:addInputEvent("Mouse_LUp", "agreementGuild_Master_Send()")
  self.btn_Refuse:addInputEvent("Mouse_LUp", "agreementGuild_Master_Close()")
  self.btn_Close:addInputEvent("Mouse_LUp", "agreementGuild_Master_Close()")
  self.btnRenew:addInputEvent("Mouse_LUp", "HandleClicked_AgreementGuild_Master_Renew()")
  self.dailyPayment_edit:addInputEvent("Mouse_LUp", "HandleClicked_AgreementGuild_Master_SetEditBox(" .. 0 .. ")")
  self.penaltyCost_edit:addInputEvent("Mouse_LUp", "HandleClicked_AgreementGuild_Master_SetEditBox(" .. 1 .. ")")
end
function AgreementGuild_Master:registMessageHandler()
end
function AgreementGuild_SetMaxDailyPayment(checkIndex, benefitMax)
  if nil == Panel_AgreementGuild_Master then
    return
  end
  local self = AgreementGuild_Master
  local maxBenefit = math.min(tonumber(benefitMax), tonumber(CppEnums.GuildBenefit.eMaxContractedBenefit))
  self.maxDailyPayment:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_MAXDAILYPAYMENT", "checkedIndex", makeDotMoney(toInt64(0, checkIndex)), "maxBenefitValue", makeDotMoney(maxBenefit)))
end
function AgreementGuild_SetMaxPenalty(checkIndex, penaltyMax)
  if nil == Panel_AgreementGuild_Master then
    return
  end
  local self = AgreementGuild_Master
  local maxPenalty = math.min(tonumber(penaltyMax), tonumber(CppEnums.GuildBenefit.eMaxContractedPenalty))
  self.maxpenaltyCost:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_MAXDAILYPAYMENT", "checkedIndex", makeDotMoney(toInt64(0, checkIndex)), "maxBenefitValue", makeDotMoney(maxPenalty)))
end
function PaGlobal_AgreementGuildMaster_CheckLoadUI()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_AgreementGuild_Master:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_AgreementGuild_Master.XML", "Panel_AgreementGuild_Master", Defines.UIGroup.PAGameUIGroup_Window_Progress, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_AgreementGuild_Master = rv
    rv = nil
    AgreementGuild_Master:Initialize()
  end
  Panel_AgreementGuild_Master:SetShow(true)
end
function PaGlobal_AgreementGuildMaster_CheckCloseUI()
  if false == PaGlobal_AgreementGuildMaster_GetShow() then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_AgreementGuild_Master:SetShow(false)
  else
    reqCloseUI(Panel_AgreementGuild_Master)
  end
end
function PaGlobal_AgreementGuildMaster_GetShow()
  if nil == Panel_AgreementGuild_Master then
    return false
  end
  return Panel_AgreementGuild_Master:GetShow()
end
function FromClient_AgreementGuildMaster_Init()
  AgreementGuild_Master:Initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_AgreementGuildMaster_Init")

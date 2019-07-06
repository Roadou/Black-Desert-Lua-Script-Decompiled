local _panel = Panel_Console_Window_SignOption
_panel:ignorePadSnapMoveToOtherPanel()
local Window_GuildAgreementOptionInfo = {
  _ui = {
    _static_ButtomBg = UI.getChildControl(_panel, "Static_BottomBg"),
    _static_SignContentBg = UI.getChildControl(_panel, "Static_SignContentBg"),
    _buttonList = {}
  },
  _keyguide = {},
  _currentContractDayIndex = -1,
  _periodValue = {
    [0] = 0,
    [1] = 1,
    [2] = 7,
    [3] = 14,
    [4] = 30,
    [5] = 180,
    [6] = 365
  },
  _paymentPerDay = {
    [0] = 0,
    [1] = 1000,
    [2] = 7000,
    [3] = 14000,
    [4] = 30000,
    [5] = 180000,
    [6] = 365000
  },
  _cancellationCharge = {
    [0] = 0,
    [1] = 500,
    [2] = 3500,
    [3] = 7000,
    [4] = 15000,
    [5] = 90000,
    [6] = 182500
  },
  _contractPeriod,
  _dailyaPayment,
  _penaltyCost,
  _isJoin = false,
  _usableActivity,
  _memberBenefit,
  _memberPenalty,
  _maxBenefitValue,
  _maxpenaltyCostValue
}
function Window_GuildAgreementOptionInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  PaGlobal_registerPanelOnBlackBackground(_panel)
end
function Window_GuildAgreementOptionInfo:InitControl()
  self._ui._buttonList[0] = UI.getChildControl(self._ui._static_SignContentBg, "RadioButton_0D")
  self._ui._buttonList[1] = UI.getChildControl(self._ui._static_SignContentBg, "RadioButton_1D")
  self._ui._buttonList[2] = UI.getChildControl(self._ui._static_SignContentBg, "RadioButton_7D")
  self._ui._buttonList[3] = UI.getChildControl(self._ui._static_SignContentBg, "RadioButton_15D")
  self._ui._buttonList[4] = UI.getChildControl(self._ui._static_SignContentBg, "RadioButton_30D")
  self._ui._buttonList[5] = UI.getChildControl(self._ui._static_SignContentBg, "RadioButton_90D")
  self._ui._buttonList[6] = UI.getChildControl(self._ui._static_SignContentBg, "RadioButton_365D")
  for index = 0, #self._ui._buttonList do
    self._ui._buttonList[index]:SetText(self._periodValue[index] .. PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFETIME"))
  end
  self._keyguide = {
    UI.getChildControl(self._ui._static_ButtomBg, "StaticText_A_ConsoleUI"),
    UI.getChildControl(self._ui._static_ButtomBg, "Button_Y_ConsoleUI"),
    UI.getChildControl(self._ui._static_ButtomBg, "Button_B_ConsoleUI")
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguide, self._ui._static_ButtomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 30)
  self._ui._edit_DailyPayment = UI.getChildControl(self._ui._static_SignContentBg, "Edit_DailyPayment")
  self._ui._edit_PenaltyCost = UI.getChildControl(self._ui._static_SignContentBg, "Edit_PenaltyCost")
  self._ui._staticText_DailyPaymentRange = UI.getChildControl(self._ui._static_SignContentBg, "StaticText_DailyPaymentRange")
  self._ui._staticText_PenaltyRange = UI.getChildControl(self._ui._static_SignContentBg, "StaticText_PenaltyRange")
end
function Window_GuildAgreementOptionInfo:InitEvent()
  for index = 0, #self._ui._buttonList do
    self._ui._buttonList[index]:addInputEvent("Mouse_LUp", "PaGlobalFunc_AgreementGuild_SignOption_ContractDaySetData(" .. index .. ")")
  end
  self._ui._edit_DailyPayment:addInputEvent("Mouse_LUp", "PaGlobalFunc_AgreementGuild_SignOption_DailyPayEditClick()")
  self._ui._edit_PenaltyCost:addInputEvent("Mouse_LUp", "PaGlobalFunc_AgreementGuild_SignOption_PenaltyEditClick()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Y, "PaGlobalFunc_AgreementGuild_SignOption_Confirm()")
end
function PaGlobalFunc_AgreementGuild_SignOption_Open()
  local self = Window_GuildAgreementOptionInfo
  self._currentContractDayIndex = -1
  self._isJoin = PaGlobalFunc_AgreementGuild_GetIsJoin()
  local usableActivity, benefit, panalty = PaGlobalFunc_AgreementGuild_GetData()
  self._usableActivity = usableActivity
  self._memberBenefit = benefit
  self._memberPenalty = panalty
  self._ui._edit_DailyPayment:SetIgnore(self._isJoin)
  self._ui._edit_PenaltyCost:SetIgnore(self._isJoin)
  self:SetMaxDailyPayment(self._paymentPerDay[0], 0)
  self._ui._staticText_PenaltyRange:SetText(makeDotMoney(toInt64(0, self._cancellationCharge[0])) .. " ~ " .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_MONEY"))
  for contorlIndex, control in pairs(self._ui._buttonList) do
    control:SetCheck(false)
  end
  self._ui._buttonList[1]:SetCheck(true)
  PaGlobalFunc_AgreementGuild_SignOption_ContractDaySetData(1)
  PaGlobalFunc_AgreementGuild_SignOption_SetShow(true, false)
  if false == _panel:GetShow() then
    _AudioPostEvent_SystemUiForXBOX(8, 14)
  end
end
function PaGlobalFunc_AgreementGuild_SignOption_Close()
  local self = Window_GuildAgreementOptionInfo
  self._contractPeriod = -1
  self._dailyaPayment = -1
  self._penaltyCost = -1
  self._isJoin = false
  self._usableActivity = -1
  self._memberBenefit = -1
  self._memberPenalty = -1
  self._maxBenefitValue = -1
  self._maxpenaltyCostValue = -1
  self._ui._edit_DailyPayment:SetText("")
  self._ui._edit_PenaltyCost:SetText("")
  for index = 0, #self._ui._buttonList do
    self._ui._buttonList[index]:SetCheck(false)
  end
  if _panel:GetShow() then
    _AudioPostEvent_SystemUiForXBOX(50, 3)
  end
  PaGlobalFunc_AgreementGuild_SignOption_SetShow(false, true)
end
function PaGlobalFunc_AgreementGuild_SignOption_GetShow()
  return Panel_Console_Window_SignOption:GetShow()
end
function PaGlobalFunc_AgreementGuild_SignOption_SetShow(isShow, isAni)
  Panel_Console_Window_SignOption:SetShow(isShow, isAni)
end
function PaGlobalFunc_AgreementGuild_SignOption_DailyPayEditClick()
  local self = Window_GuildAgreementOptionInfo
  local maxBenefit
  if nil == self._maxBenefitValue then
    maxBenefit = 0
  else
    maxBenefit = math.min(tonumber(self._maxBenefitValue), tonumber(CppEnums.GuildBenefit.eMaxContractedBenefit))
  end
  Panel_NumberPad_Show(true, toInt64(0, maxBenefit), nil, PaGlobalFunc_AgreementGuild_SignOption_DailyPayComfirm, nil, nil, nil, nil, toInt64(0, maxBenefit))
  Panel_NumberPad_SetType("Guild_AgreementOption")
end
function PaGlobalFunc_AgreementGuild_SignOption_DailyPayComfirm(inputNumber, param)
  local self = Window_GuildAgreementOptionInfo
  self._ui._edit_DailyPayment:SetText(Int64toInt32(inputNumber))
end
function PaGlobalFunc_AgreementGuild_SignOption_PenaltyEditClick()
  local self = Window_GuildAgreementOptionInfo
  local maxpenalty
  if nil == self._maxpenaltyCostValue then
    maxpenalty = 0
  else
    maxpenalty = self._maxpenaltyCostValue
  end
  Panel_NumberPad_Show(true, toInt64(0, maxpenalty), param, PaGlobalFunc_AgreementGuild_SignOption_PenaltyComfirm, nil, nil, nil, nil, toInt64(0, maxpenalty))
  Panel_NumberPad_SetType("Guild_AgreementOption")
end
function PaGlobalFunc_AgreementGuild_SignOption_PenaltyComfirm(inputNumber, param)
  local self = Window_GuildAgreementOptionInfo
  self._ui._edit_PenaltyCost:SetText(Int64toInt32(inputNumber))
end
function PaGlobalFunc_AgreementGuild_SignOption_Confirm()
  local self = Window_GuildAgreementOptionInfo
  local dailyPaymentValue = tonumber(self._ui._edit_DailyPayment:GetText())
  local penaltyCostValue = tonumber(self._ui._edit_PenaltyCost:GetText())
  if nil == dailyPaymentValue then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_DAILYMONEY"))
    return
  end
  if nil == penaltyCostValue then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_PENALTIES"))
    return
  end
  if -1 == self._currentContractDayIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_PERIOD_EDIT"))
    return
  end
  if false == self._isJoin then
    if dailyPaymentValue < self._paymentPerDay[self._currentContractDayIndex] then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_DAILYMONEY_LESS"))
      return
    elseif dailyPaymentValue > self._maxBenefitValue then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_DAILYMONEY_TOOMUCH"))
      return
    elseif penaltyCostValue < self._cancellationCharge[self._currentContractDayIndex] then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_BREACH_LESS"))
      return
    elseif penaltyCostValue > self._maxpenaltyCostValue then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_BREACH_TOOMUCH"))
      return
    end
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  PaGlobalFunc_AgreementGuild_AgreementSetData(self._periodValue[self._currentContractDayIndex], dailyPaymentValue, penaltyCostValue)
  PaGlobalFunc_AgreementGuild_SignOption_Close()
end
function PaGlobalFunc_AgreementGuild_SignOption_ContractDaySetData(index)
  local self = Window_GuildAgreementOptionInfo
  self._currentContractDayIndex = index
  if true == self._isJoin then
    self._ui._edit_DailyPayment:SetText(self._paymentPerDay[index])
    self._ui._edit_PenaltyCost:SetText(self._cancellationCharge[index])
    self._ui._staticText_DailyPaymentRange:SetText(makeDotMoney(toInt64(0, self._paymentPerDay[index])) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_MONEY"))
    self._ui._staticText_PenaltyRange:SetText(makeDotMoney(toInt64(0, self._cancellationCharge[index])) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_MONEY"))
  else
    local usableActivity = self._usableActivity
    local tempBenefit32 = Int64toInt32(self._memberBenefit)
    local tempPenalty32 = Int64toInt32(self._memberPenalty)
    local useBenefit = 0
    if tempBenefit32 < self._paymentPerDay[index] then
      useBenefit = self._paymentPerDay[index]
    else
      useBenefit = tempBenefit32
    end
    local usePenalty = 0
    if tempPenalty32 < self._cancellationCharge[index] then
      usePenalty = self._cancellationCharge[index]
    else
      usePenalty = tempPenalty32
    end
    self._maxBenefitValue = useBenefit + useBenefit * (usableActivity / 100 / 100)
    self._maxpenaltyCostValue = usePenalty + usePenalty * (usableActivity / 100 / 100)
    self:SetMaxDailyPayment(self._paymentPerDay[index], self._maxBenefitValue)
    self._ui._staticText_PenaltyRange:SetText(makeDotMoney(toInt64(0, self._cancellationCharge[index])) .. " ~ " .. makeDotMoney(toInt64(0, self._maxpenaltyCostValue)) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_MONEY"))
    self._ui._edit_DailyPayment:SetText(tostring(self._paymentPerDay[index]))
    self._ui._edit_PenaltyCost:SetText(tostring(self._cancellationCharge[index]))
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
end
function Window_GuildAgreementOptionInfo:SetMaxDailyPayment(checkIndex, benefitMax)
  local self = Window_GuildAgreementOptionInfo
  local maxBenefit = math.min(tonumber(benefitMax), tonumber(CppEnums.GuildBenefit.eMaxContractedBenefit))
  self._ui._staticText_DailyPaymentRange:SetText(makeDotMoney(toInt64(0, checkIndex)) .. " ~ " .. makeDotMoney(maxBenefit) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_MONEY"))
end
function PaGlobalFunc_GuildAgreementOption_Init()
  local self = Window_GuildAgreementOptionInfo
  self:Initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_GuildAgreementOption_Init")

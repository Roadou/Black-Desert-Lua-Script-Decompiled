local UI_TM = CppEnums.TextMode
PaGlobal_Guild_UseGuildFunds = {
  _ui = {
    mainBG = UI.getChildControl(Panel_Guild_UseGuildFunds, "Static_MainBG"),
    btn_Close = UI.getChildControl(Panel_Guild_UseGuildFunds, "Button_Close"),
    desc = UI.getChildControl(Panel_Guild_UseGuildFunds, "StaticText_Desc")
  },
  _selectIndex = nil,
  _limitPrice = 0,
  _isVolunteer = false,
  _selectUserNo = nil
}
function PaGlobal_Guild_UseGuildFunds:init()
  self._ui.btn_Set = UI.getChildControl(self._ui.mainBG, "Button_Set")
  self._ui.edit_Input = UI.getChildControl(self._ui.mainBG, "Edit_InputFunds")
  self._ui.chk_Unlimit = UI.getChildControl(self._ui.mainBG, "CheckButton_FundsLimit")
  self._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_Guild_UseGuildFunds:ShowToggle(nil, false)")
  self._ui.btn_Set:addInputEvent("Mouse_LUp", "PaGlobal_Guild_UseGuildFunds:ApplyMemberPriceLimit()")
  self._ui.edit_Input:addInputEvent("Mouse_LUp", "PaGlobal_Guild_UseGuildFunds:SetFunds()")
  self._ui.chk_Unlimit:addInputEvent("Mouse_LUp", "PaGlobal_Guild_UseGuildFunds:CheckLimit()")
  self._ui.chk_Unlimit:SetEnableArea(0, 0, self._ui.chk_Unlimit:GetTextSizeX() + 40, 25)
  self._ui.desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui.desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_USEGUILDFUNDS_DESC"))
  self._isVolunteer = false
end
function PaGlobal_Guild_UseGuildFunds:ShowToggle(selectIndex, isShow, isVolunteer)
  if nil == isShow then
    return
  end
  self._limitPrice = 0
  self._isVolunteer = false
  if false == isShow then
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  else
    local guildMember
    if true == isVolunteer then
      guildMember = ToClient_GetMyGuildInfoWrapper():getVolunteerMember(selectIndex)
      self._selectUserNo = guildMember:getUserNo()
      self._isVolunteer = true
    else
      guildMember = ToClient_GetMyGuildInfoWrapper():getMember(selectIndex)
      self._selectUserNo = guildMember:getUserNo()
    end
    local memberIsLimit = guildMember:getIsPriceLimit()
    if true == memberIsLimit then
      self._limitPrice = guildMember:getPriceLimit()
      self._ui.edit_Input:SetText(makeDotMoney(self._limitPrice))
      self._ui.edit_Input:SetIgnore(false)
      self._ui.chk_Unlimit:SetCheck(false)
    else
      self._ui.edit_Input:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_USEGUILDFUNDS_UNLIMITED"))
      self._ui.edit_Input:SetIgnore(true)
      self._ui.chk_Unlimit:SetCheck(true)
    end
  end
  self._selectIndex = selectIndex
  Panel_Guild_UseGuildFunds:SetShow(isShow)
end
function PaGlobal_Guild_UseGuildFunds:SetFunds()
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  if true == self._ui.chk_Unlimit:IsCheck() then
    return
  end
  Panel_NumberPad_Show(true, myGuildInfo:getGuildBusinessFunds_s64(), 0, PaGlobal_Guild_UseGuildFunds_InputNumber)
end
function PaGlobal_Guild_UseGuildFunds:CheckLimit()
  self._limitPrice = 0
  if true == self._ui.chk_Unlimit:IsCheck() then
    self._ui.edit_Input:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_USEGUILDFUNDS_UNLIMITED"))
    self._ui.edit_Input:SetIgnore(true)
  else
    self._ui.edit_Input:SetText("0")
    self._ui.edit_Input:SetIgnore(false)
  end
end
function PaGlobal_Guild_UseGuildFunds_InputNumber(inputNumber, param)
  PaGlobal_Guild_UseGuildFunds:Update(inputNumber, param)
end
function PaGlobal_Guild_UseGuildFunds:Update(inputNumber, param)
  if true == self._ui.chk_Unlimit:IsCheck() then
    self._ui.edit_Input:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_USEGUILDFUNDS_UNLIMITED"))
    self._ui.edit_Input:SetIgnore(true)
    return
  end
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local limitPriceMax = myGuildInfo:getGuildBusinessFunds_s64()
  if inputNumber > limitPriceMax then
    inputNumber = limitPriceMax
  end
  self._limitPrice = inputNumber
  self._ui.edit_Input:SetIgnore(false)
  self._ui.edit_Input:SetText(makeDotMoney(self._limitPrice))
end
function PaGlobal_Guild_UseGuildFunds:ApplyMemberPriceLimit()
  if true == self._ui.chk_Unlimit:IsCheck() then
    ToClient_SetGuildMemberPriceLimit(self._selectUserNo, 0, false)
  else
    ToClient_SetGuildMemberPriceLimit(self._selectUserNo, self._limitPrice, true)
  end
  self:ShowToggle(nil, false)
end
PaGlobal_Guild_UseGuildFunds:init()

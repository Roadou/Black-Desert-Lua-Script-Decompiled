local UI_TM = CppEnums.TextMode
local _panel = Panel_Window_GuildFunding_Renew
local GuildFunding = {
  _ui = {
    stc_mainBG = UI.getChildControl(_panel, "Static_CenterBg"),
    txt_desc = nil,
    edit_val = nil,
    chk_unlimit = nil,
    txt_keyGuideSelect = nil,
    stc_bottomBG = UI.getChildControl(_panel, "Static_Bottom"),
    txt_keyGuideConfirm = nil,
    txt_keyGuideCancel = nil
  },
  _selectIndex = nil,
  _limitPrice = 0,
  _selectUserNo = nil
}
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_GuildFunding_Init")
local self = GuildFunding
function PaGlobalFunc_GuildFunding_Init()
  GuildFunding:init()
end
function GuildFunding:init()
  self._ui.edit_Input = UI.getChildControl(self._ui.stc_mainBG, "Edit_Value")
  self._ui.chk_Unlimit = UI.getChildControl(self._ui.stc_mainBG, "CheckButton_Unlimit")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_GuildFunding_Apply()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_GuildFunding_SetFundsValue()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_GuildFunding_CheckUnlimit()")
  self._ui.txt_desc = UI.getChildControl(self._ui.stc_mainBG, "StaticText_Desc")
  self._ui.txt_desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui.txt_desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_USEGUILDFUNDS_DESC"))
  local addSpace = self._ui.txt_desc:GetTextSizeY() - self._ui.txt_desc:GetSizeY()
  if addSpace > 0 then
    self._ui.stc_mainBG:SetSize(self._ui.stc_mainBG:GetSizeX(), self._ui.stc_mainBG:GetSizeY() + addSpace)
    _panel:SetSize(_panel:GetSizeX(), _panel:GetSizeY() + addSpace)
    _panel:ComputePosAllChild()
  end
  self._ui.txt_keyGuideConfirm = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_KeyGuideConfirm")
  self._ui.txt_keyGuideCancel = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_KeyGuideCancel")
  local keyGuides = {
    self._ui.txt_keyGuideConfirm,
    self._ui.txt_keyGuideCancel
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobalFunc_GuildFunding_Open(selectIndex)
  self:ShowToggle(selectIndex, true)
end
function PaGlobalFunc_GuildFunding_Close()
  self:ShowToggle(nil, false)
end
function GuildFunding:ShowToggle(selectIndex, isShow)
  if nil == isShow then
    return
  end
  self._limitPrice = 0
  if false == isShow then
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  else
    local guildMember = ToClient_GetMyGuildInfoWrapper():getMember(selectIndex)
    local memberIsLimit = guildMember:getIsPriceLimit()
    self._selectUserNo = guildMember:getUserNo()
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
  _panel:SetShow(isShow)
end
function PaGlobalFunc_GuildFunding_SetFundsValue()
  GuildFunding:SetFunds()
end
function GuildFunding:SetFunds()
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  if true == self._ui.chk_Unlimit:IsCheck() then
    return
  end
  Panel_NumberPad_Show(true, myGuildInfo:getGuildBusinessFunds_s64(), 0, GuildFunding_InputNumber)
end
function PaGlobalFunc_GuildFunding_CheckUnlimit()
  GuildFunding:CheckLimit()
end
function GuildFunding:CheckLimit()
  self._limitPrice = 0
  self._ui.chk_Unlimit:SetCheck(not self._ui.chk_Unlimit:IsCheck())
  if true == self._ui.chk_Unlimit:IsCheck() then
    self._ui.edit_Input:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_USEGUILDFUNDS_UNLIMITED"))
    self._ui.edit_Input:SetIgnore(true)
  else
    self._ui.edit_Input:SetText("0")
    self._ui.edit_Input:SetIgnore(false)
  end
end
function GuildFunding_InputNumber(inputNumber, param)
  GuildFunding:Update(inputNumber, param)
end
function GuildFunding:Update(inputNumber, param)
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
function PaGlobalFunc_GuildFunding_Apply()
  GuildFunding:ApplyMemberPriceLimit()
end
function GuildFunding:ApplyMemberPriceLimit()
  if nil == self._selectUserNo then
    return
  end
  if true == self._ui.chk_Unlimit:IsCheck() then
    ToClient_SetGuildMemberPriceLimit(self._selectUserNo, 0, false)
  else
    ToClient_SetGuildMemberPriceLimit(self._selectUserNo, self._limitPrice, true)
  end
  self:ShowToggle(nil, false)
end

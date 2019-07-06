local UI_TM = CppEnums.TextMode
PaGlobal_Guild_UseGuildFunds = {
  _ui = {
    mainBG = nil,
    btn_Close = nil,
    desc = nil
  },
  _selectIndex = nil,
  _limitPrice = 0,
  _isVolunteer = false,
  _selectUserNo = nil
}
function PaGlobal_Guild_UseGuildFunds:init()
  if nil == Panel_Guild_UseGuildFunds then
    return
  end
  self._ui.mainBG = UI.getChildControl(Panel_Guild_UseGuildFunds, "Static_MainBG")
  self._ui.btn_Close = UI.getChildControl(Panel_Guild_UseGuildFunds, "Button_Close")
  self._ui.desc = UI.getChildControl(Panel_Guild_UseGuildFunds, "StaticText_Desc")
  self._ui.btn_Set = UI.getChildControl(self._ui.mainBG, "Button_Set")
  self._ui.edit_Input = UI.getChildControl(self._ui.mainBG, "Edit_InputFunds")
  self._ui.chk_Unlimit = UI.getChildControl(self._ui.mainBG, "CheckButton_FundsLimit")
  self._ui.chk_Unlimit:SetEnableArea(0, 0, self._ui.chk_Unlimit:GetTextSizeX() + 40, 25)
  self._ui.desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui.desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_USEGUILDFUNDS_DESC"))
  self._isVolunteer = false
  PaGlobal_Guild_UseGuildFunds:registEventHandler()
end
function PaGlobal_Guild_UseGuildFunds:registEventHandler()
  if nil == Panel_Guild_UseGuildFunds then
    return
  end
  self._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_Guild_UseGuildFunds:ShowToggle(nil, false)")
  self._ui.btn_Set:addInputEvent("Mouse_LUp", "PaGlobal_Guild_UseGuildFunds:ApplyMemberPriceLimit()")
  self._ui.edit_Input:addInputEvent("Mouse_LUp", "PaGlobal_Guild_UseGuildFunds:SetFunds()")
  self._ui.chk_Unlimit:addInputEvent("Mouse_LUp", "PaGlobal_Guild_UseGuildFunds:CheckLimit()")
end
function PaGlobal_Guild_UseGuildFunds:ShowToggle(selectIndex, isShow, isVolunteer)
  if nil == isShow then
    return
  end
  self._limitPrice = 0
  self._isVolunteer = false
  if true == isShow then
    PaGlobal_GuiildUseFunds_CheckLoadUI()
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
  else
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
    PaGlobal_GuiildUseFunds_CheckCloseUI()
  end
  self._selectIndex = selectIndex
end
function PaGlobal_Guild_UseGuildFunds:SetFunds()
  if nil == Panel_Guild_UseGuildFunds then
    return
  end
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
  if nil == Panel_Guild_UseGuildFunds then
    return
  end
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
  if nil == Panel_Guild_UseGuildFunds then
    return
  end
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
  if nil == Panel_Guild_UseGuildFunds then
    return
  end
  if true == self._ui.chk_Unlimit:IsCheck() then
    ToClient_SetGuildMemberPriceLimit(self._selectUserNo, 0, false)
  else
    ToClient_SetGuildMemberPriceLimit(self._selectUserNo, self._limitPrice, true)
  end
  self:ShowToggle(nil, false)
end
function PaGlobal_GuiildUseFunds_CheckLoadUI()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_UseGuildFunds:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_Guild_UseGuildFunds.XML", "Panel_Guild_UseGuildFunds", Defines.UIGroup.PAGameUIGroup_Window_Progress, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_Guild_UseGuildFunds = rv
    rv = nil
    PaGlobal_Guild_UseGuildFunds:init()
  end
  Panel_Guild_UseGuildFunds:SetShow(true)
end
function PaGlobal_GuiildUseFunds_CheckCloseUI()
  if nil == Panel_Guild_UseGuildFunds then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_UseGuildFunds:SetShow(false)
  else
    reqCloseUI(Panel_Guild_UseGuildFunds)
  end
end
function PaGlobal_GuiildUseFunds_GetShow()
  if nil == Panel_Guild_UseGuildFunds then
    return false
  end
  return Panel_Guild_UseGuildFunds:GetShow()
end
function FromClient_GuiildUseFunds_Init()
  PaGlobal_Guild_UseGuildFunds:init()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_GuiildUseFunds_Init")
